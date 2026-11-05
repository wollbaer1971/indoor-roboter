package MobileMaterialRobot_ROS2Mapping_A1 {
  doc /*
  Preliminary ROS2 mapping for later implementation work.
  Baseline A.1 does not require ROS2 as a system requirement. ROS2 is documented
  here as a likely architecture mapping, not as a final technology decision.
  */

  part def MissionManagerNode {
    doc /*
    SysML element: MissionSystem
    Possible ROS2 node: mission_manager_node
    Publishes: /mission_state, /goal_pose
    Subscribes: /transport_order, /operator_command, /navigation_result, /battery_state
    Owns: order validation, mission state, completion/blockage reporting.
    Related requirements: REQ-MIS-001, REQ-MIS-002, REQ-STA-001.
    */
  }

  part def WebInterfaceNode {
    doc /*
    SysML element: UserInterfaceSystem / CommunicationSystem
    Possible ROS2 node: web_interface_node
    Publishes: /transport_order, /operator_command
    Subscribes: /mission_state, /diagnostics
    Related requirements: REQ-UI-001, REQ-UI-002.
    */
  }

  part def MapManagementNode {
    doc /*
    SysML element: NavigationSystem (owns map management)
    Possible ROS2 node: map_management_node
    Publishes: /map, /map_update_candidate
    Subscribes: /local_obstacles
    Related requirements: REQ-MAP-001, REQ-MAP-003.
    */
  }

  part def LocalizationNode {
    doc /*
    SysML element: NavigationSystem
    Possible ROS2 node: localization_node
    Publishes: /robot_pose
    Subscribes: /map, sensor topics
    Related requirement: REQ-LOC-001.
    */
  }

  part def PerceptionNode {
    doc /*
    SysML element: PerceptionSystem
    Possible ROS2 node: perception_node
    Publishes: /local_obstacles
    Subscribes: sensor topics
    Related requirements: REQ-MAP-002, REQ-SAFE-002.
    */
  }

  part def NavigationNode {
    doc /*
    SysML element: NavigationSystem
    Possible ROS2 node: navigation_node
    Publishes: /cmd_vel, /navigation_result
    Subscribes: /goal_pose, /robot_pose, /odom, /map, /local_obstacles, /safety_state
    Parameters: nominal_speed, speed_limit, planner_config
    Related requirements: REQ-NAV-001 through REQ-NAV-005, REQ-PERF-001.
    */
  }

  part def SafetySupervisorNode {
    doc /*
    SysML element: SafetySystem
    Possible ROS2 node: safety_supervisor_node
    Publishes: /safety_state
    Subscribes: /local_obstacles, /cmd_vel, safety inputs
    Related requirements: REQ-SAFE-001, REQ-SAFE-002.
    */
  }

  part def EnergyMonitorNode {
    doc /*
    SysML element: EnergySystem
    Possible ROS2 node: energy_monitor_node
    Publishes: /battery_state
    Subscribes: battery hardware interface
    Related requirements: REQ-PWR-001, REQ-PWR-002.
    */
  }

  part def MotionControllerNode {
    doc /*
    SysML element: MotionSystem
    Possible ROS2 node: motion_controller_node
    Candidate only; no physical driver or simulator selected.
    Publishes: /odom
    Subscribes: /cmd_vel, /safety_state
    Owns: execution of permitted motion commands and odometry reporting.
    */
  }

  part def DiagnosticsNode {
    doc /*
    SysML element: DiagnosticsSystem
    Possible ROS2 node: diagnostics_node
    Candidate only; no concrete diagnostic sources selected.
    Publishes: /diagnostics
    */
  }

  // Candidate technology mapping; these dependencies are not allocations or evidence.
  dependency from MotionControllerNode to MobileMaterialRobot_Structure_A1::MotionSystem;
  dependency from DiagnosticsNode to MobileMaterialRobot_Structure_A1::DiagnosticsSystem;
  dependency from MissionManagerNode to MobileMaterialRobot_Structure_A1::MissionSystem;
  dependency from WebInterfaceNode to MobileMaterialRobot_Structure_A1::UserInterfaceSystem;
  dependency from WebInterfaceNode to MobileMaterialRobot_Structure_A1::CommunicationSystem;
  dependency from MapManagementNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from LocalizationNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from PerceptionNode to MobileMaterialRobot_Structure_A1::PerceptionSystem;
  dependency from NavigationNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from SafetySupervisorNode to MobileMaterialRobot_Structure_A1::SafetySystem;
  dependency from EnergyMonitorNode to MobileMaterialRobot_Structure_A1::EnergySystem;
}
