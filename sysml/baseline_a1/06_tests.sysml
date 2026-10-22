package MobileMaterialRobot_Verification_A1 {
  doc /*
  Verification cases for Baseline A.1. Test definitions are starter artifacts
  and need concrete preconditions, measurement tolerances and test environment
  details in Iteration B.
  */

  verification def TC_MAP_001 {
    doc /*
    ID: TC-MAP-001
    Verifies: REQ-MAP-001
    Precondition: Base map file exists.
    Action: Load base map.
    Expected: Map is available and referenced by localization/navigation.
    */
    verify requirement REQ_MAP_001;
  }

  verification def TC_MAP_002 {
    doc /*
    ID: TC-MAP-002
    Verifies: REQ-MAP-003
    Action: Add a temporary obstacle to the local environment.
    Expected: Long-term map is not automatically changed.
    */
    verify requirement REQ_MAP_003;
  }

  verification def TC_LOC_001 {
    doc /*
    ID: TC-LOC-001
    Verifies: REQ-LOC-001
    Action: Estimate robot pose in known map.
    Expected: Pose estimate stays within a tolerance to be defined.
    */
    verify requirement REQ_LOC_001;
  }

  verification def TC_NAV_001 {
    doc /*
    ID: TC-NAV-001
    Verifies: REQ-NAV-001
    Action: Start mission to a known target.
    Expected: Robot reaches target without manual vehicle control.
    */
    verify requirement REQ_NAV_001;
  }

  verification def TC_NAV_002 {
    doc /*
    ID: TC-NAV-002
    Verifies: REQ-NAV-004, REQ-NAV-005
    Action: Drive route through at least two rooms, a corridor and one open door.
    Expected: Route is completed autonomously.
    */
    verify requirement REQ_NAV_004;
    verify requirement REQ_NAV_005;
  }

  verification def TC_OBS_001 {
    doc /*
    ID: TC-OBS-001
    Verifies: REQ-MAP-002, REQ-NAV-002, REQ-SAFE-001
    Action: Place obstacle in front of planned route.
    Expected: Obstacle is detected and robot stops or safely replans.
    */
    verify requirement REQ_MAP_002;
    verify requirement REQ_NAV_002;
    verify requirement REQ_SAFE_001;
  }

  verification def TC_OBS_002 {
    doc /*
    ID: TC-OBS-002
    Verifies: REQ-NAV-003, REQ-SAFE-001, REQ-STA-001
    Action: Block route so no safe alternative is available.
    Expected: Robot stops and reports blocked route.
    */
    verify requirement REQ_NAV_003;
    verify requirement REQ_SAFE_001;
    verify requirement REQ_STA_001;
  }

  verification def TC_UI_001 {
    doc /*
    ID: TC-UI-001
    Verifies: REQ-UI-001
    Action: User creates transport order in web app.
    Expected: Robot accepts or rejects order with clear status.
    */
    verify requirement REQ_UI_001;
  }

  verification def TC_UI_002 {
    doc /*
    ID: TC-UI-002
    Verifies: REQ-UI-002
    Action: Trigger status, operational stop and return-to-charging command.
    Expected: Each command creates the expected observable system response.
    */
    verify requirement REQ_UI_002;
  }

  verification def TC_PWR_002 {
    doc /*
    ID: TC-PWR-002
    Verifies: REQ-PWR-002
    Action: Run defined teaching-block operating profile.
    Expected: System covers approximately 2 h without intermediate charging.
    */
    verify requirement REQ_PWR_002;
  }

  verification def TC_PERF_001 {
    doc /*
    ID: TC-PERF-001
    Verifies: REQ-PERF-001
    Action: Measure driving profile during nominal movement.
    Expected: Nominal speed is approximately 0.5 m/s within defined tolerance.
    */
    verify requirement REQ_PERF_001;
  }
}
