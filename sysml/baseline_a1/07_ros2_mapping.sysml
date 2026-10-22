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
    Publishes: /mission_state
    Subscribes: /transport_order, /navigation_result, /battery_state
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
    SysML element: NavigationSystem / MapManagement
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
    Subscribes: /goal_pose, /robot_pose, /map, /local_obstacles, /safety_state
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

  part def Ros2System {
    doc /*
    Node composition of the preliminary ROS2 architecture. Allocation targets
    for the logical subsystems, see 08_traceability.sysml.
    */
    part missionManager : MissionManagerNode;
    part webInterface : WebInterfaceNode;
    part mapManagement : MapManagementNode;
    part localization : LocalizationNode;
    part perception : PerceptionNode;
    part navigation : NavigationNode;
    part safetySupervisor : SafetySupervisorNode;
    part energyMonitor : EnergyMonitorNode;
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
}
