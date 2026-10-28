package MobileMaterialRobot_UseCases_B1 {
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  private import MobileMaterialRobot_Context_A1::HumanOperator;
  doc /*
  Iteration B use cases derived from Baseline A.1 operating cases.
  Use cases are kept at system level and serve as sources for Candidate
  Requirements REQ-B-*.
  */

  use case def UC_B_001_TransportauftragErteilen {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Operator submits start and target through the web app.
    Covers: OP-01.
    Result: Order is accepted with status or rejected with reason.
    */
  }

  use case def UC_B_002_WerkstuecktraegerBereitstellen {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: A human or external transfer system places the workpiece carrier on
    the robot.
    Covers: OP-02, OP-03.
    MVP: partially; active loading is deferred.
    */
  }

  use case def UC_B_003_AutonomeTransportmissionAusfuehren {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot drives autonomously to a defined target through rooms,
    corridor and open doors.
    Covers: OP-04, OP-05, OP-06, OP-07, OP-12.
    */
  }

  use case def UC_B_004_TemporaeresHindernisBehandeln {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot detects temporary obstacle and stops, replans or reports blockage.
    Covers: OP-08, OP-09.
    */
  }

  use case def UC_B_005_BlockiertenFahrwegBehandeln {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot detects that no useful route is available and reports blockage.
    Covers: OP-10.
    */
  }

  use case def UC_B_006_PersonImFahrbereichBehandeln {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot treats persons in the operating area as safety-relevant.
    Covers: OP-11, OP-16.
    MVP: reduced reaction, at least stop and report.
    */
  }

  use case def UC_B_007_BetrieblichenStoppAusloesen {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: User triggers an operational stop. The current transport order is
      paused and retained. Only explicit manual release may continue it;
      safety and route checks remain applicable.
    Covers: OP-13.
    Note: OperationalStop is not EmergencyStop.
    */
  }

  use case def UC_B_008_RueckkehrZurLadestationAusloesen {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot drives to charging station area as a target or command.
    Covers: OP-14.
    Open: docking and automatic charging remain deferred.
    */
  }

  use case def UC_B_009_TechnischenFehlerBehandeln {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Robot reacts to a technical fault, reaches a controlled state and
    reports diagnostic information.
    Covers: OP-15, OP-16.
    */
  }

  use case def UC_B_010_KarteUndUmgebungVerwalten {
    subject robot : MobileMaterialRobot;
    actor operator : HumanOperator;
    doc /*
    Goal: Base map, temporary obstacles and possible long-term map changes
    remain distinguishable.
    Covers: OP-05, OP-08, OP-10.
    */
  }
}
