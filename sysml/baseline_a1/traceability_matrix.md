# Traceability Matrix - Mobile Material Robot Baseline A.1

| Requirement | Need / Source | SysML Element | Interface / ROS2 Element | Test | Status |
| --- | --- | --- | --- | --- | --- |
| REQ-MIS-001 | SN-UI-001, UC-001 | MissionSystem | IF-002, MissionManagerNode | TC-UI-001 | Planned; no execution evidence |
| REQ-MIS-002 | SN-USER-002, SN-USER-003 | MissionSystem, UserInterfaceSystem | /mission_state | TC-STA-001, TC-UI-003 | Planned; no execution evidence |
| REQ-TRN-001 | SN-TRN-001 | TransportSystem | IF-003 | TC-TRN-001 | Planned; payload data/limits open |
| REQ-TRN-002 | SN-TRN-002, SN-SAFE-003 | TransportSystem, SafetySystem | IF-003 | TC-TRN-002 | Planned; payload data/limits open |
| REQ-MAP-001 | Baseline A.1 map concept | NavigationSystem | MapManagementNode, /map | TC-MAP-001 | Planned; no execution evidence |
| REQ-MAP-002 | SN-NAV-002 | PerceptionSystem, NavigationSystem | PerceptionNode, /local_obstacles | TC-OBS-001 | Planned; no execution evidence |
| REQ-MAP-003 | ADR-0007 | NavigationSystem | MapManagementNode | TC-MAP-002 | Planned; no execution evidence |
| REQ-LOC-001 | UC-006 | NavigationSystem | LocalizationNode, /robot_pose | TC-LOC-001 | Planned; no execution evidence |
| REQ-NAV-001 | UC-003 | NavigationSystem, MotionSystem | NavigationNode, /cmd_vel | TC-NAV-001 | Planned; no execution evidence |
| REQ-NAV-002 | UC-007 | NavigationSystem, PerceptionSystem | NavigationNode, PerceptionNode | TC-OBS-001 | Planned; no execution evidence |
| REQ-NAV-003 | UC-008 | NavigationSystem, MissionSystem | /navigation_result, /mission_state | TC-OBS-002 | Planned; no execution evidence |
| REQ-NAV-004 | SN-NAV-005, UC-004 | NavigationSystem, MotionSystem | IF-005 | TC-NAV-002 | Planned; no execution evidence |
| REQ-NAV-005 | SN-NAV-006, UC-004 | NavigationSystem, MotionSystem | IF-005 | TC-NAV-002 | Planned; no execution evidence |
| REQ-SAFE-001 | SN-SAFE-002 | SafetySystem, MotionSystem | SafetySupervisorNode, /safety_state | TC-OBS-001, TC-OBS-002 | Planned; no execution evidence |
| REQ-SAFE-002 | SN-SAFE-001 | SafetySystem, PerceptionSystem | IF-006, SafetySupervisorNode | TC-SAFE-002 | Planned; safety concept open |
| REQ-UI-001 | SN-UI-001 | UserInterfaceSystem, MissionSystem | IF-001, IF-002, WebInterfaceNode | TC-UI-001 | Planned; no execution evidence |
| REQ-UI-002 | SN-UI-002 | UserInterfaceSystem, MissionSystem, EnergySystem | WebInterfaceNode | TC-UI-002, TC-UI-003 | Planned; no execution evidence |
| REQ-PWR-001 | Energy monitoring need | EnergySystem | EnergyMonitorNode, /battery_state | TC-PWR-001 | Planned; no execution evidence |
| REQ-PWR-002 | SN-ENE-001, DEC-008 | EnergySystem | EnergyMonitorNode | TC-PWR-002 | Planned; no execution evidence |
| REQ-PERF-001 | DEC-007 | MotionSystem, SafetySystem | NavigationNode parameter nominal_speed | TC-PERF-001 | Planned; no execution evidence |
| REQ-STA-001 | SN-OPS-001 | MissionSystem, UserInterfaceSystem | /mission_state | TC-OBS-002, TC-STA-001 | Planned; no execution evidence |
| REQ-ARCH-001 | SN-DEV-003 | Complete model | Traceability artifacts | TC-TRC-001 | Planned; no execution evidence |

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

## Simulation-only test context (2026-10-28)

REQ-NAV-004 and REQ-NAV-005 remain linked to the existing TC-NAV-002.
The usage `MobileMaterialRobot_SimulationVerification_A1::schoolTransportTest`
binds its subject to
`MobileMaterialRobot_Simulation_A1::schoolTransportBench.robot`.
Status: model integration proposal; simulation configuration, run evidence
and verdict remain open. REQ-TRN-001/002 are not verified by this addition.


## Operational-stop decision (2026-10-28)

User decision: pause the current transport order; continuation only after
explicit manual release. TC-UI-003 covers REQ-UI-002 and REQ-MIS-002 using
PauseResumeCriterion. The original order identity and start/target are
retained. Automatic restart is prohibited; safety and route checks remain.
Model tests are synthetic; no actual vehicle stop or simulation run is claimed.

