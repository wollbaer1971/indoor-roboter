package MobileRobot_Wander_Verification {
  private import ScalarValues::*;
  private import VerificationCases::*;
  private import MobileRobot_Wander_Architecture::*;
  private import MobileRobot_Wander_Requirements::*;

  verification def TC_WDR_001 {
    subject robot : ReactiveWanderRobot;
    in attribute pathClear : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute angularSpeed_rad_s : Real;
    objective {
      verify REQ_WDR_001 {
        subject redefines robot = TC_WDR_001::robot;
        in attribute redefines pathClear = TC_WDR_001::pathClear;
        in attribute redefines linearSpeed_m_s = TC_WDR_001::linearSpeed_m_s;
        in attribute redefines angularSpeed_rad_s = TC_WDR_001::angularSpeed_rad_s;
      }
    }
    return verdict : VerdictKind = PassIf(ForwardCriterion(pathClear = pathClear,
      linearSpeed_m_s = linearSpeed_m_s, angularSpeed_rad_s = angularSpeed_rad_s));
  }
  verification def TC_WDR_002 {
    subject robot : ReactiveWanderRobot;
    in attribute obstacleDetected : Boolean;
    in attribute linearSpeed_m_s : Real;
    in attribute turnSelected : Boolean;
    objective {
      verify REQ_WDR_002 {
        subject redefines robot = TC_WDR_002::robot;
        in attribute redefines obstacleDetected = TC_WDR_002::obstacleDetected;
        in attribute redefines linearSpeed_m_s = TC_WDR_002::linearSpeed_m_s;
        in attribute redefines turnSelected = TC_WDR_002::turnSelected;
      }
    }
    return verdict : VerdictKind = PassIf(ObstacleStopCriterion(obstacleDetected = obstacleDetected,
      linearSpeed_m_s = linearSpeed_m_s, turnSelected = turnSelected));
  }
  verification def TC_WDR_003 {
    subject robot : ReactiveWanderRobot;
    in attribute magnitude_rad : Real;
    in attribute minimum_rad : Real;
    in attribute maximum_rad : Real;
    in attribute linearSpeed_m_s : Real;
    objective {
      verify REQ_WDR_003 {
        subject redefines robot = TC_WDR_003::robot;
        in attribute redefines magnitude_rad = TC_WDR_003::magnitude_rad;
        in attribute redefines minimum_rad = TC_WDR_003::minimum_rad;
        in attribute redefines maximum_rad = TC_WDR_003::maximum_rad;
        in attribute redefines linearSpeed_m_s = TC_WDR_003::linearSpeed_m_s;
      }
    }
    return verdict : VerdictKind = PassIf(TurnCriterion(magnitude_rad = magnitude_rad,
      minimum_rad = minimum_rad, maximum_rad = maximum_rad, linearSpeed_m_s = linearSpeed_m_s));
  }
  verification def TC_WDR_004 {
    subject robot : ReactiveWanderRobot;
    in attribute turnComplete : Boolean;
    in attribute pathClear : Boolean;
    in attribute forwardModeSelected : Boolean;
    objective {
      verify REQ_WDR_004 {
        subject redefines robot = TC_WDR_004::robot;
        in attribute redefines turnComplete = TC_WDR_004::turnComplete;
        in attribute redefines pathClear = TC_WDR_004::pathClear;
        in attribute redefines forwardModeSelected = TC_WDR_004::forwardModeSelected;
      }
    }
    return verdict : VerdictKind = PassIf(RecheckCriterion(turnComplete = turnComplete,
      pathClear = pathClear, forwardModeSelected = forwardModeSelected));
  }
  verification def TC_WDR_005 {
    subject robot : ReactiveWanderRobot;
    doc /* Python integration test retains pose, operation ID, RNG and remaining turn while paused. */
    objective { verify REQ_WDR_005; }
  }

  // Synthetic criterion checks only; none of these literals is a robot measurement.
  verification clearForward : TC_WDR_001 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> pathClear = true;
    in attribute :>> linearSpeed_m_s = 0.5;
    in attribute :>> angularSpeed_rad_s = 0.0;
  }
  verification blockedButMoving : TC_WDR_002 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> obstacleDetected = true;
    in attribute :>> linearSpeed_m_s = 0.5;
    in attribute :>> turnSelected = true;
  }
  verification validTurn : TC_WDR_003 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> magnitude_rad = 1.0;
    in attribute :>> minimum_rad = 0.5;
    in attribute :>> maximum_rad = 2.5;
    in attribute :>> linearSpeed_m_s = 0.0;
  }
  verification invalidTurn : TC_WDR_003 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> magnitude_rad = 0.0;
    in attribute :>> minimum_rad = 0.5;
    in attribute :>> maximum_rad = 2.5;
    in attribute :>> linearSpeed_m_s = 0.0;
  }
  verification blockedAfterTurn : TC_WDR_004 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> turnComplete = true;
    in attribute :>> pathClear = false;
    in attribute :>> forwardModeSelected = true;
  }
  verification clearAfterTurn : TC_WDR_004 {
    subject redefines robot = reactiveDemo.robot;
    in attribute :>> turnComplete = true;
    in attribute :>> pathClear = true;
    in attribute :>> forwardModeSelected = true;
  }
}
