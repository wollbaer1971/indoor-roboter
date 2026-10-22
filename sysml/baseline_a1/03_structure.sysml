package MobileMaterialRobot_Structure_A1 {
  doc /*
  Top-level structural decomposition for Baseline A.1.
  This is not a final physical architecture. It separates responsibilities so
  requirements, interfaces and tests can be allocated later.
  */

  part def MobileMaterialRobot {
    doc /* Top-level System of Interest. */
    part mission : MissionSystem;
    part navigation : NavigationSystem;
    part perception : PerceptionSystem;
    part motion : MotionSystem;
    part transport : TransportSystem;
    part energy : EnergySystem;
    part communication : CommunicationSystem;
    part userInterface : UserInterfaceSystem;
    part safety : SafetySystem;
    part diagnostics : DiagnosticsSystem;
  }

  part def MissionSystem {
    doc /*
    Owns transport order handling, mission state, target validation, mission
    progress and completion or blockage reporting.
    */
  }

  part def NavigationSystem {
    doc /*
    Owns map use, localization, route planning, local planning and handling of
    non-reachable targets or blocked routes.
    */
  }

  part def PerceptionSystem {
    doc /*
    Owns onboard sensing and interpretation of current environment information.
    Sensor choice is intentionally open in Baseline A.1.
    */
  }

  part def MotionSystem {
    doc /*
    Owns vehicle movement, drive control and execution of planned motion within
    speed and safety limits.
    */
  }

  part def TransportSystem {
    doc /*
    Owns the mechanical payload interface to the workpiece carrier. Active
    loading is not part of MVP 1, but the interface is part of the target system.
    */
  }

  part def EnergySystem {
    doc /*
    Owns energy storage, state-of-charge monitoring and return-to-charging
    behavior coordination. Automatic charging remains open.
    */
  }

  part def CommunicationSystem {
    doc /*
    Owns network communication, command/status exchange, logs and future
    integration points.
    */
  }

  part def UserInterfaceSystem {
    doc /*
    Owns web-app interaction, operator commands, status display and basic
    commands such as OperationalStop and return to charging station.
    */
  }

  part def SafetySystem {
    doc /*
    Owns safety-relevant state evaluation, safety stop decisions and future
    emergency-stop integration.
    */
  }

  part def DiagnosticsSystem {
    doc /*
    Owns diagnostic information for test, maintenance and fault analysis.
    */
  }
}
