package MobileMaterialRobot_Verification_A1 {
  private import ScalarValues::*;
  private import VerificationCases::*;
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  doc /*
  Verification cases for Baseline A.1. Test definitions are starter artifacts
  and need concrete preconditions, measurement tolerances and test environment
  details in Iteration B.
  */

  verification def TC_MAP_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-MAP-001
    Verifies: REQ-MAP-001
    Precondition: Base map file exists.
    Action: Load base map.
    Expected: Map is available and referenced by localization/navigation.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_001;
    }
  }

  verification def TC_MAP_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-MAP-002
    Verifies: REQ-MAP-003
    Action: Add a temporary obstacle to the local environment.
    Expected: Long-term map is not automatically changed.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_003;
    }
  }

  verification def TC_LOC_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-LOC-001
    Verifies: REQ-LOC-001
    Action: Estimate robot pose in known map.
    Expected: Pose estimate stays within a tolerance to be defined.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_LOC_001;
    }
  }

  verification def TC_NAV_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-NAV-001
    Verifies: REQ-NAV-001
    Action: Start mission to a known target.
    Expected: Robot reaches target without manual vehicle control.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_001;
    }
  }

  verification def TC_NAV_002 {
    subject testRobot : MobileMaterialRobot;
    in attribute evidenceComplete : Boolean default = false;
    in attribute roomsVisited : Integer;
    in attribute corridorTraversed : Boolean;
    in attribute openDoorPassed : Boolean;
    in attribute autonomousDriving : Boolean;
    return verdict : VerdictKind = if evidenceComplete ?
      PassIf(
        MobileMaterialRobot_Requirements_A1::MultiRoomCriterion(
          roomsVisited = roomsVisited,
          corridorTraversed = corridorTraversed)
        and MobileMaterialRobot_Requirements_A1::OpenDoorCriterion(
          openDoorPassed = openDoorPassed,
          autonomousDriving = autonomousDriving))
      else VerdictKind::inconclusive;
    doc /*
    ID: TC-NAV-002
    Verifies: REQ-NAV-004, REQ-NAV-005
    Method: Initially simulation only; no physical robot is required.
    Precondition: Documented world, robot configuration and open-door route.
    Action: Drive route through at least two rooms, a corridor and one open door.
    Expected: Route is completed autonomously in the simulation.
    Evidence: Run ID, configuration versions, simulation time and trajectory.
    No verdict is asserted before a documented run has been evaluated.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_004 {
        subject redefines robot = TC_NAV_002::testRobot;
        in attribute :>> roomsVisited = TC_NAV_002::roomsVisited;
        in attribute :>> corridorTraversed = TC_NAV_002::corridorTraversed;
      }
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_005 {
        subject redefines robot = TC_NAV_002::testRobot;
        in attribute :>> openDoorPassed = TC_NAV_002::openDoorPassed;
        in attribute :>> autonomousDriving = TC_NAV_002::autonomousDriving;
      }
    }
  }

  verification def TC_OBS_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-OBS-001
    Verifies: REQ-MAP-002, REQ-NAV-002, REQ-SAFE-001
    Action: Place obstacle in front of planned route.
    Expected: Obstacle is detected and robot stops or safely replans.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_001;
    }
  }

  verification def TC_OBS_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-OBS-002
    Verifies: REQ-NAV-003, REQ-SAFE-001, REQ-STA-001
    Action: Block route so no safe alternative is available.
    Expected: Robot stops and reports blocked route.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_003;
      verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_STA_001;
    }
  }

  verification def TC_UI_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-UI-001
    Verifies: REQ-UI-001
    Action: User creates transport order in web app.
    Expected: Robot accepts or rejects order with clear status.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_001;
    }
  }

  verification def TC_UI_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-UI-002
    Verifies: REQ-UI-002
    Action: Trigger status, operational stop and return-to-charging command.
    Expected: Each command creates the expected observable system response.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_002;
    }
  }

  verification def TC_PWR_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-PWR-002
    Verifies: REQ-PWR-002
    Action: Run defined teaching-block operating profile.
    Expected: System covers approximately 2 h without intermediate charging.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_PWR_002;
    }
  }

  verification def TC_PERF_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-PERF-001
    Verifies: REQ-PERF-001
    Action: Measure driving profile during nominal movement.
    Expected: Nominal speed is approximately 0.5 m/s within defined tolerance.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_PERF_001;
    }
  }

  // Planned verification definitions; no pass verdict or fabricated evidence.
  verification def TC_PWR_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Observe simulated energy state and check low-energy reporting. Battery model and thresholds remain open. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_PWR_001; }
  }

  verification def TC_STA_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Observe mission/operating status on the defined digital interface; no successful execution is asserted. */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_STA_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_002;
    }
  }

  verification def TC_TRC_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Inspect requirement, responsible system element, interface and test references; unresolved links must be reported. Also inspect that MVP elements reference target-system elements (REQ-ARCH-002). */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_ARCH_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_ARCH_002;
    }
  }

  verification def TC_DIAG_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Inject a simulated fault and inspect the diagnostic message for cause, affected function and timestamp. Fault sources remain open. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_DIAG_001; }
  }

  verification def TC_MNT_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Maintenance review of component accessibility. Requires a physical design; cannot be executed in the simulation-only phase. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_MNT_001; }
  }

  verification def TC_TRN_001 {
    subject testRobot : MobileMaterialRobot;
    doc /* Simulate transport of a manually placed carrier. Payload data and goal tolerance must be fixed before execution. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_TRN_001; }
  }

  verification def TC_TRN_002 {
    subject testRobot : MobileMaterialRobot;
    doc /* Inspect simulated carrier pose during the agreed driving profile. Allowed pose/load limits remain open. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_TRN_002; }
  }

  verification def TC_SAFE_002 {
    subject testRobot : MobileMaterialRobot;
    doc /* Inspect the simulated response to a person in the route. Pass criteria require the still-open safety concept. */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_002; }
  }


  verification def TC_UI_003 {
    subject testRobot : MobileMaterialRobot;
    in attribute evidenceComplete : Boolean default = false;
    in attribute wasPaused : Boolean;
    in attribute retainedOrderMatches : Boolean;
    in attribute motionStopped : Boolean;
    in attribute manualRelease : Boolean;
    in attribute safeToMove : Boolean;
    in attribute resumeAccepted : Boolean;
    return verdict : VerdictKind = if evidenceComplete ?
      PassIf(MobileMaterialRobot_Behavior_A1::PauseResumeCriterion(
        wasPaused = wasPaused, retainedOrderMatches = retainedOrderMatches,
        motionStopped = motionStopped, manualRelease = manualRelease,
        safeToMove = safeToMove, resumeAccepted = resumeAccepted))
      else VerdictKind::inconclusive;
    doc /*
    Operational-stop decision: retain and pause the active order, stop motion,
    and accept resume only on explicit manual release and valid prerequisites.
    motionStopped refers to the pause phase before evaluating the resume.
    These are observation inputs; no physical stopping performance is asserted.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_002;
    }
  }
}
