package MobileRobot_Wander_Architecture {
  private import ScalarValues::*;
  private import MobileMaterialRobot_Structure_A1::MobileRobotBase;
  private import MobileMaterialRobot_Structure_A1::NavigationSystem;
  private import MobileRobot_Wander_Behavior::*;
  private import StandardViewDefinitions::*;

  part def ReactiveDrivingParameters {
    doc /* Unit-explicit parameters; no approved physical robot values assigned here. */
    attribute radius_m : Real;
    attribute speed_m_s : Real;
    attribute turnRate_rad_s : Real;
    attribute sensorRange_m : Real;
    attribute detectionDistance_m : Real;
    attribute minTurnMagnitude_rad : Real;
    attribute maxTurnMagnitude_rad : Real;
  }

  part def ReactiveWanderRobot :> MobileRobotBase {
    doc /*
    Minimal reactive variant. Inherits perception, navigation, motion, safety,
    diagnostics and the same typed perception/motion connections.
    No MissionSystem, TransportSystem, carrier, charging or WebApp is instantiated.
    Turtle is a visualization adapter; replacing it does not change the controller.
    */
    exhibit state reactiveState : ReactiveWanderState;
    part configuration : ReactiveDrivingParameters;
    part redefines navigation : NavigationSystem {
      attribute remainingTurn_rad : Real;
    }
  }

  part def KinematicWorld {
    doc /* Circular footprint, rectangular obstacles and swept-path collision guard; no contact dynamics. */
  }
  part def TurtleVisualization {
    doc /* Receives simulation pose/status for drawing; no navigation decisions. */
  }
  part def ReactiveSimulation {
    part robot : ReactiveWanderRobot;
    part world : KinematicWorld;
    part viewer : TurtleVisualization;
  }
  part reactiveDemo : ReactiveSimulation;

  view wanderArchitecture : InterconnectionView {
    expose ReactiveWanderRobot;
  }
  view wanderBehavior : StateTransitionView {
    expose ReactiveWanderState;
  }
}
