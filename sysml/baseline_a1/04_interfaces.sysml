package MobileMaterialRobot_Interfaces_A1 {
  doc /*
  External and first internal interface sketches for Baseline A.1.
  Details such as protocol, connector type, message format, rate and tolerance
  are intentionally left for later iterations.
  */

  port def TransportOrderPort;
  port def MissionStatusPort;
  port def OperationalCommandPort;
  port def PayloadMechanicalPort;
  port def EnvironmentInteractionPort;
  port def ChargingStationPort;
  port def DiagnosticsPort;
  port def SafetyStatePort;

  part def MobileMaterialRobot {
    port orderIn : ~TransportOrderPort;
    port statusOut : MissionStatusPort;
    port commandIn : ~OperationalCommandPort;
    port payloadMount : PayloadMechanicalPort;
    port environment : EnvironmentInteractionPort;
    port charging : ChargingStationPort;
    port diagnosticsOut : DiagnosticsPort;
    port safetyStateOut : SafetyStatePort;
  }

  part def WebApp {
    port orderOut : TransportOrderPort;
    port statusIn : ~MissionStatusPort;
    port commandOut : OperationalCommandPort;
  }

  part def WorkpieceCarrier {
    port mechanicalInterface : ~PayloadMechanicalPort;
  }

  part def DrivingEnvironment {
    port physicalInteraction : ~EnvironmentInteractionPort;
  }

  part def ChargingStation {
    port chargeInterface : ~ChargingStationPort;
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
