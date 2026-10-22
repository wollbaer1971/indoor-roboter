package MobileMaterialRobot_UseCases_B1 {
  doc /*
  Iteration B use cases derived from Baseline A.1 operating cases.
  Use cases are kept at system level and serve as sources for Candidate
  Requirements REQ-B-*.
  */

  action def <'UC-B-001'> UC_B_001_TransportauftragErteilen {
    doc /*
    Goal: Operator submits start and target through the web app.
    Covers: OP-01.
    Result: Order is accepted with status or rejected with reason.
    Verification idea: Web-app order tests.
    Open issues: OI-UI-001.
    */
  }

  action def <'UC-B-002'> UC_B_002_WerkstuecktraegerBereitstellen {
    doc /*
    Goal: A human or external transfer system places the workpiece carrier on
    the robot.
    Covers: OP-02, OP-03.
    MVP: partially; active loading is deferred.
    Verification idea: Payload interface test after carrier data are known.
    Open issues: OI-MECH-001, OI-MECH-002.
    */
  }

  action def <'UC-B-003'> UC_B_003_AutonomeTransportmissionAusfuehren {
    doc /*
    Goal: Robot drives autonomously to a defined target through rooms,
    corridor and open doors.
    Covers: OP-04, OP-05, OP-06, OP-07, OP-12.
    Verification idea: End-to-end route through rooms, corridor and open door.
    Open issues: OI-TEST-001, OI-SAFE-002.
    */
  }

  action def <'UC-B-004'> UC_B_004_TemporaeresHindernisBehandeln {
    doc /*
    Goal: Robot detects temporary obstacle and stops, replans or reports blockage.
    Covers: OP-08, OP-09.
    Verification idea: Obstacle in route, stop or local replan.
    Open issues: OI-NAV-002, OI-SAFE-002.
    */
  }

  action def <'UC-B-005'> UC_B_005_BlockiertenFahrwegBehandeln {
    doc /*
    Goal: Robot detects that no useful route is available and reports blockage.
    Covers: OP-10.
    Verification idea: Blocked route test.
    Open issues: OI-TEST-001.
    */
  }

  action def <'UC-B-006'> UC_B_006_PersonImFahrbereichBehandeln {
    doc /*
    Goal: Robot treats persons in the operating area as safety-relevant.
    Covers: OP-11, OP-16.
    MVP: reduced reaction, at least stop and report.
    Verification idea: Reduced MVP reaction: stop and report.
    Open issues: OI-SAFE-001, OI-SAFE-002.
    */
  }

  action def <'UC-B-007'> UC_B_007_BetrieblichenStoppAusloesen {
    doc /*
    Goal: User triggers an operational stop.
    Covers: OP-13.
    Note: OperationalStop is not EmergencyStop.
    Verification idea: OperationalStop review and behavior test.
    Open issues: OI-SAFE-001.
    */
  }

  action def <'UC-B-008'> UC_B_008_RueckkehrZurLadestationAusloesen {
    doc /*
    Goal: Robot drives to charging station area as a target or command.
    Covers: OP-14.
    Open: docking and automatic charging remain deferred.
    Verification idea: Navigate to charging station area.
    Open issues: OI-ENE-002.
    */
  }

  action def <'UC-B-009'> UC_B_009_TechnischenFehlerBehandeln {
    doc /*
    Goal: Robot reacts to a technical fault, reaches a controlled state and
    reports diagnostic information.
    Covers: OP-15, OP-16.
    Verification idea: Fault status and diagnostic review.
    Open issues: OI-UI-001.
    */
  }

  action def <'UC-B-010'> UC_B_010_KarteUndUmgebungVerwalten {
    doc /*
    Goal: Base map, temporary obstacles and possible long-term map changes
    remain distinguishable.
    Covers: OP-05, OP-08, OP-10.
    Verification idea: Base map load and temporary obstacle distinction.
    Open issues: OI-NAV-001, OI-NAV-002.
    */
  }
}
