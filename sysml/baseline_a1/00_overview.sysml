package MobileMaterialRobot_BaselineA1 {
  public import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  public import MobileMaterialRobot_Context_A1::SystemContext;
  public import MobileMaterialRobot_Context_A1::schoolContext;
  public import MobileMaterialRobot_Requirements_A1::*;
  public import MobileMaterialRobot_Behavior_A1::*;
  public import MobileMaterialRobot_Interfaces_A1::*;
  public import MobileMaterialRobot_Verification_A1::*;
  public import MobileMaterialRobot_Simulation_A1::*;
  public import MobileMaterialRobot_SimulationVerification_A1::*;
  public import MobileMaterialRobot_ROS2Mapping_A1::*;
  public import MobileMaterialRobot_Views_A1::*;
  public import MobileMaterialRobot_Traceability_A1::*;
  doc /*
  Model: Mobile Material Robot - System Definition Baseline A.1
  Purpose:
    The Mobile Material Robot transports workpiece carriers of a transfer
    system autonomously between defined locations inside a production-like
    school demonstrator area.

  Method:
    This starter model follows the project documentation and keeps
    requirements, context, structure, interfaces, behavior, verification and
    ROS2 mapping traceable. Concrete technologies remain open unless they
    were explicitly decided in Baseline A.1.
  */

  item def BaselineA1_Decisions {
    doc /*
    DEC-001: Indoor demonstrator.
    DEC-002: Production-like school environment.
    DEC-003: Workpiece carrier of a transfer system as payload.
    DEC-004: External loading by human or external transfer system.
    DEC-005: Operating area includes multiple rooms and a corridor.
    DEC-006: Open doors must be passable.
    DEC-007: MVP nominal speed approximately 0.5 m/s.
    DEC-008: First-version operating time approximately 2 h.
    DEC-009: Transport orders initially via web app.
    DEC-010: Simple UI for status, operational stop and return to charging station.
    DEC-011: Return to charging station belongs to the target system.
    DEC-012: Higher speed is a later extension.
    */
  }

  item def BaselineA1_Assumptions {
    doc /*
    A-001: Robot moves mostly on one level.
    A-002: Operating area is suitable for a small mobile robot.
    A-003: Stairs are not handled autonomously.
    A-004: Workpiece carrier size, mass and center of gravity are still open.
    A-005: Transport locations are stable for a relevant period.
    A-006: Humans may enter the robot operating area.
    A-007: Temporary obstacles are part of normal operation.
    A-008: Some environment changes may become long-term changes.
    A-009: The first system works with one robot.
    A-010: Later multi-robot extension should not be unnecessarily blocked.
    */
  }

  item def NonGoals_FirstDevelopmentStage {
    doc /*
    Not primary goals:
    outdoor operation, stairs, autonomous passenger transport, manipulator arm,
    humanoid manipulation, fully autonomous loading/unloading of arbitrary
    objects, multi-floor elevator operation, fleet optimization, public roads
    and high dynamic driving speeds.
    */
  }
}

