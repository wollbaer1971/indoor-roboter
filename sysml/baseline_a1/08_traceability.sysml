package MobileMaterialRobot_Traceability_A1 {
  doc /*
  Traceability relationships for Baseline A.1.

  satisfy:  which logical subsystem fulfills which requirement.
  allocate: which ROS2 node implements which logical subsystem.
  verify:   lives in 06_tests.sysml.

  traceability_matrix.md is generated from these relationships with
  sysml/tools/generate_traceability.py. Change the model, not the matrix.
  */

  import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  import MobileMaterialRobot_Requirements_A1::*;
  import MobileMaterialRobot_ROS2Mapping_A1::Ros2System;

  part robot : MobileMaterialRobot {
    // Mission
    satisfy acceptTransportOrder by mission;
    satisfy reportOrderStatus by mission;
    satisfy reportOrderStatus by userInterface;
    satisfy reportOperatingStatus by mission;
    satisfy reportOperatingStatus by userInterface;

    // Transport
    satisfy transportCarrier by transport;
    satisfy securePayload by transport;
    satisfy securePayload by safety;

    // Map, localization and navigation
    satisfy loadBaseMap by navigation;
    satisfy detectEnvironmentChanges by perception;
    satisfy detectEnvironmentChanges by navigation;
    satisfy separateMapLayers by navigation;
    satisfy determinePose by navigation;
    satisfy driveToTarget by navigation;
    satisfy driveToTarget by motion;
    satisfy considerObstacles by navigation;
    satisfy considerObstacles by perception;
    satisfy detectUnreachableTarget by navigation;
    satisfy detectUnreachableTarget by mission;
    satisfy traverseRoomsViaCorridor by navigation;
    satisfy traverseRoomsViaCorridor by motion;
    satisfy passOpenDoors by navigation;
    satisfy passOpenDoors by motion;

    // Safety
    satisfy enterSafeStateOnObstacle by safety;
    satisfy enterSafeStateOnObstacle by motion;
    satisfy considerPersons by safety;
    satisfy considerPersons by perception;

    // User interface
    satisfy webAppOrderEntry by userInterface;
    satisfy webAppOrderEntry by mission;
    satisfy basicOperatingCommands by userInterface;
    satisfy basicOperatingCommands by mission;
    satisfy basicOperatingCommands by energy;

    // Energy and performance
    satisfy monitorEnergyState by energy;
    satisfy operatingTime by energy;
    satisfy nominalSpeed by motion;
    satisfy nominalSpeed by safety;
  }

  // Process requirement: fulfilled by the model as a whole.
  satisfy functionTraceability by robot;

  part ros2 : Ros2System;

  allocate robot.mission to ros2.missionManager;
  allocate robot.userInterface to ros2.webInterface;
  allocate robot.communication to ros2.webInterface;
  allocate robot.navigation to ros2.mapManagement;
  allocate robot.navigation to ros2.localization;
  allocate robot.navigation to ros2.navigation;
  allocate robot.perception to ros2.perception;
  allocate robot.safety to ros2.safetySupervisor;
  allocate robot.safety to ros2.velocityGate;
  allocate robot.motion to ros2.motionController;
  allocate robot.energy to ros2.energyMonitor;
  // Not yet allocated: transport, diagnostics.
}
