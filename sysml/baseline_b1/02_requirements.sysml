package MobileMaterialRobot_Requirements_B1 {
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  private import MobileMaterialRobot_UseCases_B1::*;
  doc /*
  Candidate Requirements derived in Iteration B.
  They refine Baseline A.1 and will be filtered into the formal MVP scope in
  Iteration C.
  */

  requirement REQ_B_MIS_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-001
    Text: The system shall accept or reject a transport order with unique start
      and target location.
    Verification idea: submit valid, invalid and not executable orders.
    */
  }

  requirement REQ_B_UI_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: interface
    Source: UC-B-001
    Text: The first version shall trigger transport orders through a web app.
    Verification idea: operator selects start and target; robot receives order.
    */
  }

  requirement REQ_B_STA_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-001, UC-B-003, UC-B-005, UC-B-007, UC-B-009
    Text: The system shall report at least ready, accepted, driving, target
      reached, paused, blocked, stopped and fault.
    Verification idea: integration test checks status sequence.
    */
  }

  requirement REQ_B_NAV_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-003
    Text: The system shall autonomously drive to a defined target location.
    Verification idea: system test without manual vehicle control.
    */
  }

  requirement REQ_B_NAV_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-003
    Text: The system shall execute a route through multiple rooms, a corridor
      and at least one open door.
    Verification idea: route test in school demonstrator or equivalent setup.
    */
  }

  requirement REQ_B_NAV_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-005
    Text: The system shall detect and report when target or route is not reachable.
    Verification idea: block route and expect blocked/not reachable status.
    */
  }

  requirement REQ_B_LOC_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-003
    Text: The system shall determine its pose in the operating area.
    Verification idea: pose tolerance to be defined.
    */
  }

  requirement REQ_B_PER_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-004
    Text: The system shall detect obstacles in the relevant driving area and
      provide them to local navigation.
    Verification idea: obstacle appears in local environment representation.
    */
  }

  requirement REQ_B_MAP_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-010
    Text: The system shall load an approved base map and use it for navigation.
    Verification idea: load map and plan target route.
    */
  }

  requirement REQ_B_MAP_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: constraint
    Source: UC-B-004, UC-B-010, OI-NAV-002
    Text: The system shall distinguish temporary obstacles from long-term map
      information.
    Verification idea: temporary obstacle does not automatically change long-term map.
    */
  }

  requirement REQ_B_SAFE_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: safety
    Source: UC-B-004, UC-B-005
    Text: The system shall enter a safe state for obstacles that cannot be
      handled safely.
    Verification idea: no collision, controlled stop, status reported.
    */
  }

  requirement REQ_B_SAFE_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: safety
    Source: UC-B-006
    Text: The system shall treat persons in the operating area as
      safety-relevant environment elements.
    Verification idea: MVP reduced behavior is stop and report.
    */
  }

  requirement REQ_B_SAFE_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: safety/constraint
    Source: UC-B-006, UC-B-007, OI-SAFE-001
    Text: OperationalStop, SafetyStop and EmergencyStop shall be conceptually
      and functionally separated.
    Decision 2026-10-28: OperationalStop pauses the retained mission and
      requires explicit manual release to continue; it does not reset safety stops.
    Verification idea: review, pause/resume tests and later safety tests.
    */
  }

  requirement REQ_B_PERF_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: performance
    Source: UC-B-003, DEC-007
    Text: MVP nominal speed shall be approximately 0.5 m/s.
    Verification idea: measured driving profile within tolerance to be defined.
    */
  }

  requirement REQ_B_PWR_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: non-functional
    Source: DEC-008, OI-ENE-001
    Text: The first version shall cover a defined teaching profile of
      approximately 2 h.
    Verification idea: endurance test with profile to be defined.
    */
  }

  requirement REQ_B_TRN_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: interface
    Source: UC-B-002, OI-MECH-001, OI-MECH-002
    Text: The robot shall carry a manually placed workpiece carrier as payload.
    Verification idea: mechanical payload test after carrier data are known.
    */
  }

  requirement REQ_B_ENE_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    Type: functional
    Source: UC-B-008, OI-ENE-002
    Text: The system shall handle return to charging station as a target or
      operating command.
    Verification idea: MVP test reaches charging station area; docking deferred.
    */
  }

  // Trace sources from the reconciled Source fields and existing matrix.
  dependency from REQ_B_MIS_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_UI_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_STA_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_STA_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_STA_001 to UC_B_005_BlockiertenFahrwegBehandeln;
  dependency from REQ_B_STA_001 to UC_B_007_BetrieblichenStoppAusloesen;
  dependency from REQ_B_STA_001 to UC_B_009_TechnischenFehlerBehandeln;
  dependency from REQ_B_NAV_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_NAV_002 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_NAV_003 to UC_B_005_BlockiertenFahrwegBehandeln;
  dependency from REQ_B_LOC_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_PER_001 to UC_B_004_TemporaeresHindernisBehandeln;
  dependency from REQ_B_MAP_001 to UC_B_010_KarteUndUmgebungVerwalten;
  dependency from REQ_B_MAP_002 to UC_B_004_TemporaeresHindernisBehandeln;
  dependency from REQ_B_MAP_002 to UC_B_010_KarteUndUmgebungVerwalten;
  dependency from REQ_B_SAFE_001 to UC_B_004_TemporaeresHindernisBehandeln;
  dependency from REQ_B_SAFE_001 to UC_B_005_BlockiertenFahrwegBehandeln;
  dependency from REQ_B_SAFE_002 to UC_B_006_PersonImFahrbereichBehandeln;
  dependency from REQ_B_SAFE_003 to UC_B_006_PersonImFahrbereichBehandeln;
  dependency from REQ_B_SAFE_003 to UC_B_007_BetrieblichenStoppAusloesen;
  dependency from REQ_B_PERF_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_TRN_001 to UC_B_002_WerkstuecktraegerBereitstellen;
  dependency from REQ_B_ENE_001 to UC_B_008_RueckkehrZurLadestationAusloesen;
}
