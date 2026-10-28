package MobileRobot_Wander_Requirements {
  private import ScalarValues::*;
  private import MobileRobot_Wander_Architecture::ReactiveWanderRobot;

  constraint def ForwardCriterion {
    in attribute pathClear : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute angularSpeed_rad_s : Real;
    pathClear implies (linearSpeed_m_s > 0.0 and angularSpeed_rad_s == 0.0)
  }
  constraint def ObstacleStopCriterion {
    in attribute obstacleDetected : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute turnSelected : Boolean;
    obstacleDetected implies (linearSpeed_m_s == 0.0 and turnSelected)
  }
  constraint def TurnCriterion {
    in attribute magnitude_rad : Real;
    in attribute minimum_rad : Real;
    in attribute maximum_rad : Real;
    in attribute linearSpeed_m_s : Real;
    minimum_rad > 0.0 and maximum_rad >= minimum_rad and
      magnitude_rad >= minimum_rad and magnitude_rad <= maximum_rad and
      linearSpeed_m_s == 0.0
  }
  constraint def RecheckCriterion {
    in attribute turnComplete : Boolean;
    in attribute pathClear : Boolean;
    in attribute forwardModeSelected : Boolean;
    forwardModeSelected == (turnComplete and pathClear)
  }

  requirement REQ_WDR_001 {
    subject robot : ReactiveWanderRobot;
    in attribute pathClear : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute angularSpeed_rad_s : Real;
    require constraint criterion : ForwardCriterion {
      in attribute redefines pathClear = REQ_WDR_001::pathClear;
      in attribute redefines linearSpeed_m_s = REQ_WDR_001::linearSpeed_m_s;
      in attribute redefines angularSpeed_rad_s = REQ_WDR_001::angularSpeed_rad_s;
    }
    doc /* In active forward mode on a clear path, command positive straight motion. */
  }
  requirement REQ_WDR_002 {
    subject robot : ReactiveWanderRobot;
    in attribute obstacleDetected : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute turnSelected : Boolean;
    require constraint criterion : ObstacleStopCriterion {
      in attribute redefines obstacleDetected = REQ_WDR_002::obstacleDetected;
      in attribute redefines linearSpeed_m_s = REQ_WDR_002::linearSpeed_m_s;
      in attribute redefines turnSelected = REQ_WDR_002::turnSelected;
    }
    doc /* On detected obstruction, stop forward movement and select a random in-place turn. */
  }
  requirement REQ_WDR_003 {
    subject robot : ReactiveWanderRobot;
    in attribute magnitude_rad : Real;
    in attribute minimum_rad : Real;
    in attribute maximum_rad : Real;
    in attribute linearSpeed_m_s : Real;
    require constraint criterion : TurnCriterion {
      in attribute redefines magnitude_rad = REQ_WDR_003::magnitude_rad;
      in attribute redefines minimum_rad = REQ_WDR_003::minimum_rad;
      in attribute redefines maximum_rad = REQ_WDR_003::maximum_rad;
      in attribute redefines linearSpeed_m_s = REQ_WDR_003::linearSpeed_m_s;
    }
    doc /* Turn magnitude is sampled within configured nonzero bounds; no forward motion during turning. */
  }
  requirement REQ_WDR_004 {
    subject robot : ReactiveWanderRobot;
    in attribute turnComplete : Boolean;
    in attribute pathClear : Boolean;
    in attribute forwardModeSelected : Boolean;
    require constraint criterion : RecheckCriterion {
      in attribute redefines turnComplete = REQ_WDR_004::turnComplete;
      in attribute redefines pathClear = REQ_WDR_004::pathClear;
      in attribute redefines forwardModeSelected = REQ_WDR_004::forwardModeSelected;
    }
    doc /* After a completed turn, re-read perception. Drive only if clear; otherwise select another turn. */
  }
  requirement REQ_WDR_005 {
    subject robot : ReactiveWanderRobot;
    doc /* Pause preserves the active operation and remaining turn. Resume requires explicit manual release. */
  }
}
