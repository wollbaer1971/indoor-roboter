package MobileMaterialRobot_Views_A1 {
  private import StandardViewDefinitions::*;

  view systemContext : InterconnectionView {
    expose MobileMaterialRobot_Context_A1::schoolContext;
  }

  view robotArchitecture : InterconnectionView {
    expose MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  }

  view missionFlow : ActionFlowView {
    expose MobileMaterialRobot_Behavior_A1::ExecuteTransportMission;
  }

  view operationStates : StateTransitionView {
    expose MobileMaterialRobot_Behavior_A1::RobotOperationState;
  }

  view simulationTestBench : InterconnectionView {
    expose MobileMaterialRobot_Simulation_A1::schoolTransportBench;
  }
}
