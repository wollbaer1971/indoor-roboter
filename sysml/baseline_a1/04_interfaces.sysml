package MobileMaterialRobot_Interfaces_A1 {
  private import ScalarValues::*;
  doc /*
  External and first internal interface sketches for Baseline A.1.
  Details such as protocol, connector type, message format, rate and tolerance
  are intentionally left for later iterations.
  */

  item def TransportOrder {
    doc /* robotId ist leer, solange der Auftrag keinem Roboter zugeteilt ist (REQ-ARCH-003). */
    attribute orderId : String;
    attribute robotId : String[0..1];
    attribute startLocation : String;
    attribute targetLocation : String;
  }
  enum def MissionStatusKind {
    off; initializing; ready; orderAccepted; rejected; driving;
    avoidingObstacle; paused; blocked; completed; stopped;
    returningToChargingStation; chargingInterfaceReached; fault; safeState;
  }
  item def MissionStatus {
    doc /* Jeder Status nennt den meldenden Roboter (REQ-ARCH-003). */
    attribute robotId : String;
    attribute orderId : String;
    attribute statusKind : MissionStatusKind;
    doc /* Warnung bei niedrigem Ladezustand; aendert den Betriebszustand nicht (DEC-017). */
    attribute lowEnergyWarning : Boolean;
  }
  enum def OperatorCommandKind {
    requestStatus; operationalStop; resumeMission; cancelMission;
    acknowledge; returnToChargingStation;
  }
  item def OperatorCommand {
    doc /*
    robotId adressiert den Roboter. Leer bedeutet: der einzige Roboter
    (A-009). Bei mehreren Robotern darf ein Befehl nicht ohne Adressat
    wirken (REQ-ARCH-003).
    */
    attribute robotId : String[0..1];
    attribute kind : OperatorCommandKind;
  }
  item def DiagnosticMessage {
    attribute text : String;
  }
  item def SafetyStateReport {
    doc /* Reports the safety assessment; no safety integrity level is claimed. */
    attribute safeToMove : Boolean;
  }

  port def TransportOrderPort {
    out item order : TransportOrder;
  }
  port def MissionStatusPort {
    out item status : MissionStatus;
  }
  port def OperationalCommandPort {
    out item command : OperatorCommand;
  }
  port def DiagnosticsPort {
    out item diagnostic : DiagnosticMessage;
  }
  port def SafetyStatePort {
    out item report : SafetyStateReport;
  }
  port def PayloadMechanicalPort {
    doc /* Mechanical contract placeholder: geometry/load/retention are open. */
  }
  port def EnvironmentInteractionPort {
    doc /* Physical interaction placeholder: sensor/contact model is open. */
  }
  port def ChargingStationPort {
    doc /* Return interface placeholder; docking/charging are not decided. */
  }

  item def InterfaceRegister {
    doc /*
    IF-001: User <-> Web app
      Transport order, basic command and status display.

    IF-002: Web app <-> robot
      Order, target, status, errors and basic commands.

    IF-003: Workpiece carrier <-> robot
      Mechanical support, retention, pose, mass and center of gravity.

    IF-004: External transfer system <-> robot
      Future mechanical or organizational handover of a workpiece carrier.

    IF-005: Robot <-> driving environment
      Motion, perception, map, obstacles, corridor and open doors.

    IF-006: Robot <-> persons
      Detection, distance, movement decision, warning and safe state.

    IF-007: Robot <-> charging station
      Return, positioning, energy transfer and state of charge.
    */
  }
}

