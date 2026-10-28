package MobileMaterialRobot_ModelChecks_A1 {
  private import MobileMaterialRobot_Verification_A1::TC_NAV_002;
  private import MobileMaterialRobot_Verification_A1::TC_UI_003;
  private import MobileMaterialRobot_Simulation_A1::schoolTransportBench;

  doc /*
  Synthetic test fixtures for the model's evidence evaluator only.
  These literals are not observations, simulator runs or robot test results.
  */

  verification syntheticPass : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> roomsVisited = 2;
    in attribute :>> corridorTraversed = true;
    in attribute :>> openDoorPassed = true;
    in attribute :>> autonomousDriving = true;
  }

  verification syntheticFail : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> roomsVisited = 1;
    in attribute :>> corridorTraversed = true;
    in attribute :>> openDoorPassed = true;
    in attribute :>> autonomousDriving = true;
  }

  verification syntheticIncomplete : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = false;
    in attribute :>> roomsVisited = 2;
    in attribute :>> corridorTraversed = true;
    in attribute :>> openDoorPassed = true;
    in attribute :>> autonomousDriving = true;
  }

  verification syntheticNoCorridor : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> roomsVisited = 2;
    in attribute :>> corridorTraversed = false;
    in attribute :>> openDoorPassed = true;
    in attribute :>> autonomousDriving = true;
  }

  verification syntheticNoDoor : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> roomsVisited = 2;
    in attribute :>> corridorTraversed = true;
    in attribute :>> openDoorPassed = false;
    in attribute :>> autonomousDriving = true;
  }

  verification syntheticManualDriving : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> roomsVisited = 2;
    in attribute :>> corridorTraversed = true;
    in attribute :>> openDoorPassed = true;
    in attribute :>> autonomousDriving = false;
  }

  verification syntheticMissingEvidence : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;
    // No measurements are bound. The default completeness flag is false.
  }

  // Synthetic pause-policy fixtures, not observed robot or simulator data.
  verification syntheticPauseHeld : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = true;
    in attribute :>> manualRelease = false;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = false;
  }

  verification syntheticResumeApproved : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = true;
    in attribute :>> manualRelease = true;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = true;
  }

  verification syntheticResumeWithoutRelease : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = true;
    in attribute :>> manualRelease = false;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = true;
  }

  verification syntheticResumeUnsafe : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = true;
    in attribute :>> manualRelease = true;
    in attribute :>> safeToMove = false;
    in attribute :>> resumeAccepted = false;
  }

  verification syntheticLostOrder : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = false;
    in attribute :>> motionStopped = true;
    in attribute :>> manualRelease = true;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = false;
  }

  verification syntheticMotionContinues : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = true;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = false;
    in attribute :>> manualRelease = false;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = false;
  }

  verification syntheticResumeOutsidePause : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
    in attribute :>> evidenceComplete = true;
    in attribute :>> wasPaused = false;
    in attribute :>> retainedOrderMatches = true;
    in attribute :>> motionStopped = false;
    in attribute :>> manualRelease = true;
    in attribute :>> safeToMove = true;
    in attribute :>> resumeAccepted = false;
  }

  verification syntheticPauseMissingEvidence : TC_UI_003 {
    subject redefines testRobot = schoolTransportBench.robot;
  }
}
