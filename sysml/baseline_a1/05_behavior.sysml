package MobileMaterialRobot_Behavior_A1 {
  private import MobileMaterialRobot_Interfaces_A1::TransportOrder;

  item def PowerOnRequested;
  item def InitializationComplete;
  item def OrderValidated;
  item def OrderRejected;
  item def RouteReady;
  item def TargetReached;
  item def RouteBlocked;
  item def OperationalStopRequested;
  item def ReturnRequested;
  item def ChargingAreaReached;
  item def TechnicalFault;
  item def UnsafeCondition;
  doc /*
  Behavior sketches for Baseline A.1. These actions and states are intentionally
  high-level and will be refined into detailed behavior models in later
  iterations.
  */

  action def ExecuteTransportMission {
    first start;
    then action receiveOrder;
    then action validateLocations;
    then action confirmAcceptance;
    then action loadMapAndLocalize;
    then action planRoute;
    then action driveAndObserve;
    then action reportResult;
    then done;

    doc /*
    Nominal steps:
    1. Receive transport order from web app.
    2. Validate start and target location.
    3. Confirm order acceptance.
    4. Load base map and verify localization.
    5. Plan route through rooms, corridor and open doors.
    6. Drive toward target at approximately 0.5 m/s nominal speed.
    7. Detect current environment changes and temporary obstacles.
    8. Replan, avoid or stop when needed.
    9. Report target reached or blocked/not reachable.
    */
  }

  action def HandleTemporaryObstacle {
    doc /*
    Steps:
    1. Perception reports obstacle or uncertain free space.
    2. Navigation adds obstacle to current local environment representation.
    3. Motion is adapted or stopped.
    4. Mission continues when safe path exists.
    5. Mission reports blocked state if no safe path exists.
    */
  }

  action def PassOpenDoor {
    doc /*
    Steps:
    1. Door passage is part of the known base map.
    2. Robot localizes relative to the passage.
    3. Local perception checks current drivable space.
    4. Robot drives through the open door without manual vehicle control.
    */
  }

  action def ReturnToChargingStation {
    doc /*
    Steps:
    1. Return command is triggered by the user or later by energy logic.
    2. Mission validates charging station target.
    3. Navigation plans route to charging station.
    4. Robot reaches charging station area.
    TODO: Decide whether automatic docking and automatic charging are in scope.
    */
  }

  action def OperationalStop {
    doc /*
    Operational stop is a normal operating command from the user interface.
    It is not identical to a safety-rated emergency stop.
    */
  }

  action def SafetyStop {
    doc /*
    Safety stop is a safety-related response to an unsafe or not safely
    manageable situation. Detailed safety concept is open.
    */
  }

  state def RobotOperationState {
    doc /*
    Nominal mission skeleton using the same vocabulary as MissionStatusKind.
    Events are abstract inputs, not a scheduler or a simulator implementation.
    No automatic restart after stop, blocked route, fault or unsafe condition
    is assumed. Recovery decisions remain open.
    */
    entry; then off;
    state off;
    state initializing;
    state ready;
    state orderAccepted;
    state rejected;
    state driving;
    state avoidingObstacle;
    state paused;
    state blocked;
    state completed;
    state stopped;
    state returningToChargingStation;
    state chargingInterfaceReached;
    state fault;
    state safeState;

    transition first off accept PowerOnRequested then initializing;
    transition first initializing accept InitializationComplete then ready;
    transition first ready accept OrderValidated then orderAccepted;
    transition first ready accept OrderRejected then rejected;
    transition first orderAccepted accept RouteReady then driving;
    transition first driving accept TargetReached then completed;
    transition first driving accept RouteBlocked then blocked;
    transition first driving accept OperationalStopRequested then stopped;
    transition first ready accept ReturnRequested then returningToChargingStation;
    transition first returningToChargingStation accept ChargingAreaReached then chargingInterfaceReached;
    transition first driving accept TechnicalFault then fault;
    transition first driving accept UnsafeCondition then safeState;
  }
}
