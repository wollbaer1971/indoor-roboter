# Traceability Matrix - Mobile Material Robot Baseline A.1

The tables below are generated from the SysML model (`02_requirements`,
`06_tests`, `07_ros2_mapping`, `08_traceability`). Change the model and run
`python3 sysml/tools/generate_traceability.py`, do not edit the tables by hand.

<!-- BEGIN GENERATED: do not edit, run sysml/tools/generate_traceability.py -->

## Requirements

| Requirement | Source | Function | Satisfied by | ROS2 node (via allocation) | Interface | Test | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REQ-MIS-001 | SN-UI-001, UC-001, SN-001 | FUN-MIS-001 | MissionSystem | MissionManagerNode | IF-002 | – | Gap: no test |
| REQ-MIS-002 | SN-USER-002, SN-USER-003 | – | MissionSystem, UserInterfaceSystem | MissionManagerNode, WebInterfaceNode | /mission_state | – | Gap: no test |
| REQ-TRN-001 | SN-TRN-001, SN-002 | FUN-TRN-001 | TransportSystem | – | IF-003 | – | Gap: no test |
| REQ-TRN-002 | SN-TRN-002, SN-SAFE-003 | – | TransportSystem, SafetySystem | SafetySupervisorNode, VelocityGateNode | IF-003 | – | Gap: no test |
| REQ-MAP-001 | Baseline A.1 map concept | FUN-MAP-001 | NavigationSystem | MapManagementNode, LocalizationNode, NavigationNode | /map | TC-MAP-001 | Covered |
| REQ-MAP-002 | SN-NAV-002, SN-006 | FUN-PER-001 | PerceptionSystem, NavigationSystem | PerceptionNode, MapManagementNode, LocalizationNode, NavigationNode | /local_obstacles | TC-OBS-001 | Covered |
| REQ-MAP-003 | ADR-0007, SN-NAV-002, R-09 | – | NavigationSystem | MapManagementNode, LocalizationNode, NavigationNode | – | TC-MAP-002 | Covered |
| REQ-LOC-001 | UC-006 | FUN-LOC-001 | NavigationSystem | MapManagementNode, LocalizationNode, NavigationNode | /robot_pose | TC-LOC-001 | Covered |
| REQ-NAV-001 | UC-003 | FUN-NAV-001 | NavigationSystem, MotionSystem | MapManagementNode, LocalizationNode, NavigationNode, MotionControllerNode | /cmd_vel | TC-NAV-001 | Covered |
| REQ-NAV-002 | UC-007 | FUN-NAV-001 | NavigationSystem, PerceptionSystem | MapManagementNode, LocalizationNode, NavigationNode, PerceptionNode | /local_obstacles | TC-OBS-001 | Covered |
| REQ-NAV-003 | UC-008, SN-NAV-004 | – | NavigationSystem, MissionSystem | MapManagementNode, LocalizationNode, NavigationNode, MissionManagerNode | /navigation_result, /mission_state | TC-OBS-002 | Covered |
| REQ-NAV-004 | SN-NAV-005, UC-004 | – | NavigationSystem, MotionSystem | MapManagementNode, LocalizationNode, NavigationNode, MotionControllerNode | IF-005 | TC-NAV-002 | Covered |
| REQ-NAV-005 | SN-NAV-006, UC-004 | – | NavigationSystem, MotionSystem | MapManagementNode, LocalizationNode, NavigationNode, MotionControllerNode | IF-005 | TC-NAV-002 | Covered |
| REQ-SAFE-001 | SN-SAFE-002, SN-004 | FUN-SAFE-001 | SafetySystem, MotionSystem | SafetySupervisorNode, VelocityGateNode, MotionControllerNode | /safety_state | TC-OBS-001, TC-OBS-002, TC-SAFE-001 | Covered |
| REQ-SAFE-002 | SN-SAFE-001, R-04 | – | SafetySystem, PerceptionSystem | SafetySupervisorNode, VelocityGateNode, PerceptionNode | IF-006 | – | Gap: no test |
| REQ-UI-001 | SN-UI-001, UC-001 | – | UserInterfaceSystem, MissionSystem | WebInterfaceNode, MissionManagerNode | IF-001, IF-002 | TC-UI-001 | Covered |
| REQ-UI-002 | SN-UI-002, UC-009, UC-010 | – | UserInterfaceSystem, MissionSystem, EnergySystem | WebInterfaceNode, MissionManagerNode, EnergyMonitorNode | – | TC-UI-002 | Covered |
| REQ-PWR-001 | Energy monitoring need | FUN-STA-001 | EnergySystem | EnergyMonitorNode | /battery_state | TC-PWR-001 | Covered |
| REQ-PWR-002 | SN-ENE-001, DEC-008 | – | EnergySystem | EnergyMonitorNode | – | TC-PWR-002 | Covered |
| REQ-PERF-001 | DEC-007 | – | MotionSystem, SafetySystem | MotionControllerNode, SafetySupervisorNode, VelocityGateNode | parameter nominal_speed | TC-PERF-001 | Covered |
| REQ-STA-001 | SN-OPS-001, SN-003 | FUN-STA-001 | MissionSystem, UserInterfaceSystem | MissionManagerNode, WebInterfaceNode | /mission_state | TC-OBS-002, TC-STA-001 | Covered |
| REQ-ARCH-001 | SN-DEV-003, SN-008 | – | MobileMaterialRobot | – | traceability artifacts | TC-TRC-001 | Covered |
| REQ-DIAG-001 | SN-005 | FUN-STA-001 | DiagnosticsSystem, CommunicationSystem | WebInterfaceNode | /diagnostics | – | Gap: no test |
| REQ-MNT-001 | SN-MNT-002, SN-MNT-003 | – | MobileMaterialRobot | – | maintenance interfaces open | – | Gap: no test |
| REQ-ARCH-002 | SN-DEV-001, SN-DEV-002 | – | MobileMaterialRobot | – | MVP marking | – | Gap: no test |

## Subsystems

| Subsystem | Satisfies | Allocated to | Status |
| --- | --- | --- | --- |
| MissionSystem | REQ-MIS-001, REQ-MIS-002, REQ-STA-001, REQ-NAV-003, REQ-UI-001, REQ-UI-002 | MissionManagerNode | Allocated |
| NavigationSystem | REQ-MAP-001, REQ-MAP-002, REQ-MAP-003, REQ-LOC-001, REQ-NAV-001, REQ-NAV-002, REQ-NAV-003, REQ-NAV-004, REQ-NAV-005 | MapManagementNode, LocalizationNode, NavigationNode | Allocated |
| PerceptionSystem | REQ-MAP-002, REQ-NAV-002, REQ-SAFE-002 | PerceptionNode | Allocated |
| MotionSystem | REQ-NAV-001, REQ-NAV-004, REQ-NAV-005, REQ-SAFE-001, REQ-PERF-001 | MotionControllerNode | Allocated |
| TransportSystem | REQ-TRN-001, REQ-TRN-002 | – | Gap: no ROS2 node |
| EnergySystem | REQ-UI-002, REQ-PWR-001, REQ-PWR-002 | EnergyMonitorNode | Allocated |
| CommunicationSystem | REQ-DIAG-001 | WebInterfaceNode | Allocated |
| UserInterfaceSystem | REQ-MIS-002, REQ-STA-001, REQ-UI-001, REQ-UI-002 | WebInterfaceNode | Allocated |
| SafetySystem | REQ-TRN-002, REQ-SAFE-001, REQ-SAFE-002, REQ-PERF-001 | SafetySupervisorNode, VelocityGateNode | Allocated |
| DiagnosticsSystem | REQ-DIAG-001 | – | Gap: no ROS2 node |

## ROS2 topics

Rule (ADR-0009): only nodes allocated from SafetySystem publish `/cmd_vel`.

| Topic | Published by | Subscribed by | Status |
| --- | --- | --- | --- |
| `/battery_state` | EnergyMonitorNode | MissionManagerNode | Connected |
| `/cmd_vel` | VelocityGateNode | MotionControllerNode | Connected |
| `/cmd_vel_nav` | NavigationNode | VelocityGateNode | Connected |
| `/diagnostics` | – | WebInterfaceNode | Gap: no publisher |
| `/goal_pose` | MissionManagerNode | NavigationNode | Connected |
| `/local_obstacles` | PerceptionNode | MapManagementNode, NavigationNode, SafetySupervisorNode | Connected |
| `/map` | MapManagementNode | LocalizationNode, NavigationNode | Connected |
| `/map_update_candidate` | MapManagementNode | – | Gap: no subscriber |
| `/mission_state` | MissionManagerNode | WebInterfaceNode | Connected |
| `/navigation_result` | NavigationNode | MissionManagerNode | Connected |
| `/odom` | MotionControllerNode | LocalizationNode, SafetySupervisorNode | Connected |
| `/operator_command` | WebInterfaceNode | MissionManagerNode | Connected |
| `/robot_pose` | LocalizationNode | NavigationNode | Connected |
| `/safety_state` | SafetySupervisorNode | MissionManagerNode, NavigationNode, VelocityGateNode | Connected |
| `/transport_order` | WebInterfaceNode | MissionManagerNode | Connected |

## Verification cases

| Test | Name | Verifies |
| --- | --- | --- |
| TC-MAP-001 | BaseMapLoadTest | REQ-MAP-001 |
| TC-MAP-002 | TemporaryObstacleMapSeparationTest | REQ-MAP-003 |
| TC-LOC-001 | PoseEstimationTest | REQ-LOC-001 |
| TC-NAV-001 | AutonomousTargetDriveTest | REQ-NAV-001 |
| TC-NAV-002 | MultiRoomRouteTest | REQ-NAV-004, REQ-NAV-005 |
| TC-OBS-001 | ObstacleDetectionTest | REQ-MAP-002, REQ-NAV-002, REQ-SAFE-001 |
| TC-OBS-002 | BlockedRouteTest | REQ-NAV-003, REQ-SAFE-001, REQ-STA-001 |
| TC-SAFE-001 | VelocityGateFailSafeTest | REQ-SAFE-001 |
| TC-UI-001 | WebAppOrderTest | REQ-UI-001 |
| TC-UI-002 | BasicCommandTest | REQ-UI-002 |
| TC-STA-001 | MissionStatusTest | REQ-STA-001 |
| TC-PWR-001 | LowEnergyTest | REQ-PWR-001 |
| TC-TRC-001 | TraceabilityReview | REQ-ARCH-001 |
| TC-PWR-002 | OperatingTimeTest | REQ-PWR-002 |
| TC-PERF-001 | NominalSpeedTest | REQ-PERF-001 |

<!-- END GENERATED -->

## Deferred Open Issues

The following gaps are intentional for Baseline A.1. They are not omissions in
the system definition. They are deferred because they require later use cases,
quantified requirements, safety decisions, architecture work or verification
planning.

- OI-MECH-001: Workpiece carrier geometry, mass and center-of-gravity range.
- OI-MECH-002: Payload retention and mechanical support tests.
- OI-SAFE-001: Person-related safety behavior and distinction between OperationalStop, SafetyStop and EmergencyStop.
- OI-ENE-002: Charging station scope: return-only, docking or automatic charging.
- OI-NAV-002: Map update approval rules and distinction between temporary and long-term changes.
