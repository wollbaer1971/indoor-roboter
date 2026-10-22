package MobileMaterialRobot_Behavior_A1 {
  doc /*
  Behavior sketches for Baseline A.1. These actions and states are intentionally
  high-level and will be refined into detailed behavior models in later
  iterations.
  */

  action def ExecuteTransportMission {
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
    High-level operation states for MVP and later refinement.
    */
    state Off;
    state Initializing;
    state Ready;
    state OrderAccepted;
    state Navigating;
    state AvoidingObstacle;
    state Blocked;
    state OperationalStopped;
    state ReturningToChargingStation;
    state ChargingInterfaceReached;
    state Fault;
    state SafeState;
  }
}
