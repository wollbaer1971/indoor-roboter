package MobileMaterialRobot_Behavior_A1 {
  private import ScalarValues::*;
  private import MobileMaterialRobot_Interfaces_A1::TransportOrder;

  item def PowerOnRequested;
  item def InitializationComplete;
  item def OrderValidated;
  item def OrderRejected;
  item def RouteReady;
  item def TargetReached;
  item def RouteBlocked;
  item def OperationalStopRequested;
  item def ResumeRequested {
    doc /* Internal event after an explicit operator resume command. */
    attribute manualRelease : Boolean;
    attribute safeToMove : Boolean;
    attribute retainedOrderAvailable : Boolean;
  }
  item def ReturnRequested;
  item def ChargingAreaReached;
  item def TechnicalFault;
  item def UnsafeCondition;

  calc def ResumePermitted {
    in attribute isPaused : Boolean;
    in attribute manualRelease : Boolean;
    in attribute safeToMove : Boolean;
    in attribute retainedOrderAvailable : Boolean;
    isPaused and manualRelease and safeToMove and retainedOrderAvailable
  }

  constraint def PauseResumeCriterion {
    in attribute wasPaused : Boolean;
    in attribute retainedOrderMatches : Boolean;
    in attribute motionStopped : Boolean;
    in attribute manualRelease : Boolean;
    in attribute safeToMove : Boolean;
    in attribute resumeAccepted : Boolean;
    (wasPaused implies (retainedOrderMatches and motionStopped)) and
    (resumeAccepted == ResumePermitted(
      isPaused = wasPaused, manualRelease = manualRelease,
      safeToMove = safeToMove, retainedOrderAvailable = retainedOrderMatches))
  }
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
    in item activeOrder : TransportOrder[0..1];
    out item pausedOrder : TransportOrder[0..1] = activeOrder;
    doc /*
    Operational stop is a normal operating command from the user interface.
    It pauses a running transport order and stops motion. The same order,
    including ID, start and target, is retained. No automatic resume is allowed.
    It is not identical to a safety-rated emergency stop.
    */
  }

  action def ResumeMission {
    in item pausedOrder : TransportOrder[0..1];
    out item continuedOrder : TransportOrder[0..1] = pausedOrder;
    doc /*
    Explicit manual release continues the same retained order.
    Resume approval returns to orderAccepted. RouteReady is still required
    before driving; safety/route checks are not bypassed.
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
    Operational stop pauses the retained mission. Only explicit manual release
    can resume it, subject to the existing safety and route checks.
    Recovery after blocked route, fault or unsafe condition remains open.
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
    transition first driving accept OperationalStopRequested then paused;
    transition first orderAccepted accept OperationalStopRequested then paused;
    transition first avoidingObstacle accept OperationalStopRequested then paused;
    transition first paused accept resume : ResumeRequested
      if ResumePermitted(isPaused = true, manualRelease = resume.manualRelease,
        safeToMove = resume.safeToMove,
        retainedOrderAvailable = resume.retainedOrderAvailable)
      then orderAccepted;
    transition first ready accept ReturnRequested then returningToChargingStation;
    transition first returningToChargingStation accept ChargingAreaReached then chargingInterfaceReached;
    transition first driving accept TechnicalFault then fault;
    transition first driving accept UnsafeCondition then safeState;
  }
}
