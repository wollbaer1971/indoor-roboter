package MobileRobot_Wander_Behavior {
  private import ScalarValues::*;
  private import MobileMaterialRobot_Behavior_A1::ResumePermitted;

  item def ObstacleDetected;
  item def TurnFinished {
    attribute pathClear : Boolean;
  }
  item def PauseRequested;
  item def ManualResumeRequested {
    attribute manualRelease : Boolean;
    attribute safeToMove : Boolean;
    attribute operationAvailable : Boolean;
  }
  action def DriveForward;
  action def SelectRandomAngle;
  action def RotateInPlace;

  state def ReactiveWanderState {
    doc /*
    Entry starts a reactive operation without material transport or a goal map.
    Two pause states retain the interrupted mode. In-place turn progress is
    retained by the controller; resume does not select a fresh random angle.
    Obstruction means detected clearance limit, not a deliberate collision.
    */
    entry; then forward;
    state forward {
      do action move : DriveForward;
    }
    state turning {
      do action rotate : RotateInPlace;
    }
    state pausedForward;
    state pausedTurning;
    transition first forward accept ObstacleDetected
      do action selectInitialAngle : SelectRandomAngle {}
      then turning;
    transition first turning accept finishedClear : TurnFinished
      if finishedClear.pathClear then forward;
    transition first turning accept finishedBlocked : TurnFinished
      if not finishedBlocked.pathClear
      do action selectNextAngle : SelectRandomAngle {}
      then turning;
    transition first forward accept PauseRequested then pausedForward;
    transition first turning accept PauseRequested then pausedTurning;
    transition first pausedForward accept resumeForward : ManualResumeRequested
      if ResumePermitted(isPaused = true, manualRelease = resumeForward.manualRelease,
        safeToMove = resumeForward.safeToMove,
        retainedOrderAvailable = resumeForward.operationAvailable)
      then forward;
    transition first pausedTurning accept resumeTurn : ManualResumeRequested
      if ResumePermitted(isPaused = true, manualRelease = resumeTurn.manualRelease,
        safeToMove = resumeTurn.safeToMove,
        retainedOrderAvailable = resumeTurn.operationAvailable)
      then turning;
  }
}
