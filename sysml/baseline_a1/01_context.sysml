package MobileMaterialRobot_Context_A1 {
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  private import MobileMaterialRobot_Interfaces_A1::*;
  doc /*
  Context model for Baseline A.1.
  The system boundary is around the Mobile Material Robot. Web app, users,
  workpiece carrier, external transfer system, driving environment, persons,
  obstacles, charging station and IT infrastructure are external.
  */

  part def WebApp {
    doc /* Initial user interface for transport orders and basic commands. */
    port orderOut : TransportOrderPort;
    port statusIn : ~MissionStatusPort;
    port commandOut : OperationalCommandPort;
  }

  part def HumanOperator {
    doc /* Starts transport orders and requests basic operating commands. */
  }

  part def WorkpieceCarrier {
    doc /*
    Standard workpiece carrier of a transfer system.
    Size, mass, maximum workpiece mass and center-of-gravity range are open.
    */
    port mechanicalInterface : ~PayloadMechanicalPort;
  }

  part def ExternalTransferSystem {
    doc /*
    External system that may place a workpiece carrier on the robot in later
    versions. Active loading by the robot is not part of MVP 1.
    */
  }

  part def SchoolProductionArea {
    doc /*
    Production-like school demonstrator area with multiple rooms, a corridor
    and open doors.
    */
    port physicalInteraction : ~EnvironmentInteractionPort;
  }

  part def PersonInOperatingArea {
    doc /* External actor with safety relevance. */
  }

  part def TemporaryObstacle {
    doc /* Movable object that can temporarily block the planned route. */
  }

  part def ChargingStation {
    doc /*
    External station for return-to-charge behavior. Automatic docking and
    charging remain open for MVP definition.
    */
    port chargeInterface : ~ChargingStationPort;
  }

  part def ITInfrastructure {
    doc /* Network, access control, updates, logging and possible integration. */
  }

  part def SystemContext {
    part robot : MobileMaterialRobot;
    part webApp : WebApp;
    part operator : HumanOperator;
    part carrier : WorkpieceCarrier;
    part transferSystem : ExternalTransferSystem;
    part environment : SchoolProductionArea;
    part person : PersonInOperatingArea;
    part obstacle : TemporaryObstacle;
    part charger : ChargingStation;
    part it : ITInfrastructure;
    connect webApp.orderOut to robot.orderIn;
    connect robot.statusOut to webApp.statusIn;
    connect webApp.commandOut to robot.commandIn;
    connect carrier.mechanicalInterface to robot.payloadMount;
    connect environment.physicalInteraction to robot.environment;
    connect charger.chargeInterface to robot.charging;
  }

  part schoolContext : SystemContext;
}

