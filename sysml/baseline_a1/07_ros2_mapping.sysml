package MobileMaterialRobot_ROS2Mapping_A1 {
  doc /*
  Preliminary ROS2 mapping for later implementation work.
  Baseline A.1 does not require ROS2 as a system requirement. ROS2 is documented
  here as a likely architecture mapping, not as a final technology decision.

  Safety path (ADR-0009, proposed):
    navigation_node -> /cmd_vel_nav -> velocity_gate_node -> /cmd_vel
    -> motion_controller_node. Only the velocity gate publishes /cmd_vel.
    sysml/tools/generate_traceability.py enforces this rule.

  Convention: "Publishes:" and "Subscribes:" list ROS2 topics starting with "/".
  Other entries (e.g. sensor topics, hardware interfaces) are not checked.
  */

  part def MissionManagerNode {
    doc /*
    SysML element: MissionSystem
    Possible ROS2 node: mission_manager_node
    Publishes: /mission_state, /goal_pose
    Subscribes: /transport_order, /operator_command, /navigation_result,
      /battery_state, /safety_state
    Owns: order validation, mission state, completion/blockage reporting.
      OperationalStop cancels the navigation goal. It is not routed through
      the safety gate (REQ-B-SAFE-003).
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
    Subscribes: /map, /odom, sensor topics
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
    Publishes: /cmd_vel_nav, /navigation_result
    Subscribes: /goal_pose, /robot_pose, /map, /local_obstacles, /safety_state
    Parameters: nominal_speed, speed_limit, planner_config
    Note: /safety_state is used for replanning and status only. Stopping does
      not depend on this node, see VelocityGateNode.
    Related requirements: REQ-NAV-001 through REQ-NAV-005, REQ-PERF-001.
    */
  }

  part def SafetySupervisorNode {
    doc /*
    SysML element: SafetySystem
    Possible ROS2 node: safety_supervisor_node
    Publishes: /safety_state
    Subscribes: /local_obstacles, /odom, safety inputs
    Owns: evaluation of obstacles, persons and measured speed against limits.
    Related requirements: REQ-SAFE-001, REQ-SAFE-002, REQ-PERF-001.
    */
  }

  part def VelocityGateNode {
    doc /*
    SysML element: SafetySystem
    Possible ROS2 node: velocity_gate_node (ADR-0009, proposed)
    Publishes: /cmd_vel
    Subscribes: /cmd_vel_nav, /safety_state
    Behavior: forwards /cmd_vel_nav as /cmd_vel only while /safety_state
      allows motion. Sends zero velocity when /safety_state blocks motion,
      or when /safety_state or /cmd_vel_nav exceed their timeout.
    Limit: software only, not safety-rated. Does not replace emergency stop
      or hardware motor shutdown (OI-SAFE-001). Timeouts open (OI-SAFE-002).
    Related requirements: REQ-SAFE-001, REQ-B-SAFE-003.
    */
  }

  part def MotionControllerNode {
    doc /*
    SysML element: MotionSystem
    Possible ROS2 node: motion_controller_node, plus MCU firmware
    Publishes: /odom
    Subscribes: /cmd_vel, motor driver interface
    Behavior: stops the drive when /cmd_vel exceeds its timeout (watchdog).
    Related requirements: REQ-NAV-001, REQ-PERF-001.
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
    part velocityGate : VelocityGateNode;
    part motionController : MotionControllerNode;
    part energyMonitor : EnergyMonitorNode;
  }
}
