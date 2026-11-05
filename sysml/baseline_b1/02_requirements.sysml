package MobileMaterialRobot_Requirements_B1 {
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  private import MobileMaterialRobot_UseCases_B1::*;
  doc /*
  Candidate Requirements der Iteration B. Sie praezisieren Baseline A.1 und
  werden in Iteration C in den verbindlichen MVP-Scope gefiltert.
  Die Doc-Felder sind Quelle der LaTeX-Tabellen in Kapitel 12.
  */

  requirement REQ_B_MIS_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-MIS-001
    Typ: Funktional
    Quelle: UC-B-001
    Text: Das System muss einen Transportauftrag mit eindeutigem Start- und
      Zielstandort annehmen oder begruendet ablehnen.
    Akzeptanz: Test: gueltiger, ungueltiger und nicht ausfuehrbarer Auftrag
      ueber Web-App.
    MVP: MVP
    MVP-Begruendung: Auftragserteilung ist Startpunkt des
      End-to-End-Demonstrators.
    */
  }

  requirement REQ_B_UI_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-UI-001
    Typ: Schnittstelle
    Quelle: UC-B-001
    Text: Die erste Version muss Transportauftraege ueber eine Web-App ausloesen
      koennen.
    Akzeptanz: Test: Bediener waehlt Start und Ziel; Roboter erhaelt Auftrag.
    MVP: MVP
    MVP-Begruendung: Web-App ist die festgelegte erste Auftragsschnittstelle.
    */
  }

  requirement REQ_B_STA_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-STA-001
    Typ: Funktional
    Quelle: UC-B-001, UC-B-003, UC-B-005, UC-B-006, UC-B-007, UC-B-009
    Text: Das System muss den Auftragsstatus mindestens als bereit, angenommen,
      unterwegs, Ziel erreicht, pausiert, blockiert, gestoppt oder Fehler
      melden.
    Akzeptanz: Integrationstest mit Statusfolge je Use Case.
    MVP: MVP
    MVP-Begruendung: Status ist fuer Unterricht, Test und Fehlersuche notwendig.
    */
  }

  requirement REQ_B_NAV_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-NAV-001
    Typ: Funktional
    Quelle: UC-B-003
    Text: Das System muss einen definierten Zielstandort autonom anfahren.
    Akzeptanz: Systemtest: Ziel wird ohne manuelle Fahrzeugsteuerung erreicht.
    MVP: MVP
    MVP-Begruendung: Autonomes Zielanfahren ist Kernfaehigkeit.
    */
  }

  requirement REQ_B_NAV_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-NAV-002
    Typ: Funktional
    Quelle: UC-B-003
    Text: Das System muss eine Route durch mehrere Raeume, einen Flur und
      mindestens eine offene Tuer ausfuehren koennen.
    Akzeptanz: Systemtest im Schul-Demonstrationsbereich oder Testaufbau.
    MVP: MVP
    MVP-Begruendung: Mehrere Raeume, Flur und offene Tuer bilden den
      realistischen Demonstrationskontext.
    */
  }

  requirement REQ_B_NAV_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-NAV-003
    Typ: Funktional
    Quelle: UC-B-003, UC-B-005
    Text: Das System muss erkennen und melden, wenn Ziel oder Route nicht
      erreichbar sind.
    Akzeptanz: Test: Route blockieren; Status blockiert oder nicht erreichbar
      erwarten.
    MVP: MVP
    MVP-Begruendung: Blockierte Wege muessen kontrolliert behandelt werden.
    */
  }

  requirement REQ_B_LOC_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-LOC-001
    Typ: Funktional
    Quelle: UC-B-003
    Text: Das System muss seine Pose im definierten Betriebsbereich bestimmen.
    Akzeptanz: Test mit noch festzulegender Positions- und
      Orientierungsabweichung.
    MVP: MVP
    MVP-Begruendung: Ohne Lokalisierung ist Navigation nicht nachweisbar.
    */
  }

  requirement REQ_B_PER_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-PER-001
    Typ: Funktional
    Quelle: UC-B-004
    Text: Das System muss Hindernisse im relevanten Fahrbereich erfassen und
      fuer die lokale Navigation bereitstellen.
    Akzeptanz: Test: Hindernis erscheint in lokaler Umgebungsdarstellung.
    MVP: MVP
    MVP-Begruendung: Hinderniswahrnehmung ist Kern der semi-dynamischen
      Umgebung.
    */
  }

  requirement REQ_B_MAP_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-MAP-001
    Typ: Funktional
    Quelle: UC-B-010
    Text: Das System muss eine freigegebene Grundkarte des Betriebsbereichs
      laden und fuer Navigation verwenden.
    Akzeptanz: Test: Karte laden und Zielroute planen.
    MVP: MVP
    MVP-Begruendung: Grundkarte ist Eingangsvoraussetzung des
      Navigationskonzepts.
    */
  }

  requirement REQ_B_MAP_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-MAP-002
    Typ: Constraint
    Quelle: UC-B-004, UC-B-010, OI-NAV-002
    Text: Das System muss temporaere Hindernisse von dauerhaften
      Karteninformationen unterscheiden.
    Akzeptanz: Test: Hindernis blockiert Route lokal, veraendert aber die
      Langzeitkarte nicht automatisch.
    MVP: MVP reduziert
    MVP-Begruendung: Trennung temporaer/dauerhaft muss sichtbar sein; voller
      Kartenfreigabeprozess spaeter.
    */
  }

  requirement REQ_B_NAV_004 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-NAV-004
    Typ: Funktional
    Quelle: UC-B-004
    Text: Das System muss bei einem temporaeren Hindernis stoppen, lokal
      umplanen oder eine Blockade melden.
    Akzeptanz: Test: Hindernis in Fahrweg platzieren; erwartete Reaktion
      pruefen.
    */
  }

  requirement REQ_B_SAFE_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-SAFE-001
    Typ: Safety
    Quelle: UC-B-004, UC-B-005
    Text: Das System muss bei nicht sicher behandelbaren Hindernissen in einen
      sicheren Zustand uebergehen.
    Akzeptanz: Test: keine Kollision; Bewegung endet kontrolliert; Status wird
      gemeldet.
    */
  }

  requirement REQ_B_SAFE_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-SAFE-002
    Typ: Safety
    Quelle: UC-B-006
    Text: Das System muss Personen im Fahrbereich als sicherheitsrelevante
      Umgebungselemente behandeln.
    Akzeptanz: Safety-Testkonzept offen; zunaechst reduzierte MVP-Reaktion:
      stoppen und melden.
    MVP: MVP reduziert
    MVP-Begruendung: Im MVP mindestens Stoppen und Melden; vollstaendige
      Safety-Architektur spaeter.
    */
  }

  requirement REQ_B_SAFE_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-SAFE-003
    Typ: Safety
    Quelle: UC-B-006, UC-B-007, OI-SAFE-001
    Text: Das System muss betrieblichen Stopp, SafetyStop und EmergencyStop
      begrifflich und funktional trennen.
    Akzeptanz: Review, Pause-/Fortsetzungstests und spaeterer Safety-Test;
      EmergencyStop bleibt Open Issue.
    */
  }

  requirement REQ_B_PERF_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-PERF-001
    Typ: Leistung
    Quelle: UC-B-003, DEC-007
    Text: Die MVP-Nominalgeschwindigkeit soll ca. 0,5 m/s betragen.
    Akzeptanz: Messfahrt mit noch festzulegender Toleranz.
    */
  }

  requirement REQ_B_PWR_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-PWR-001
    Typ: Nichtfunktional
    Quelle: DEC-008, OI-ENE-001
    Text: Die erste Version soll ein definiertes Unterrichtsprofil von ca. 2 h
      abdecken.
    Akzeptanz: Dauertest mit noch zu definierendem
      Fahr-/Warte-/Demonstrationsprofil.
    */
  }

  requirement REQ_B_TRN_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-TRN-001
    Typ: Schnittstelle
    Quelle: UC-B-002, OI-MECH-001, OI-MECH-002
    Text: Der Roboter muss einen manuell aufgesetzten Werkstuecktraeger als
      Payload mitfuehren koennen.
    Akzeptanz: Mechanischer Test offen, abhaengig von OI-MECH-001 und
      OI-MECH-002.
    MVP: MVP reduziert
    MVP-Begruendung: Werkstuecktraeger als Payload beruecksichtigen; aktive
      Uebergabe spaeter.
    */
  }

  requirement REQ_B_ENE_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-B-ENE-001
    Typ: Funktional
    Quelle: UC-B-008, OI-ENE-002
    Text: Das System muss eine Rueckkehr zur Ladestation als Ziel oder
      Betriebsbefehl behandeln koennen.
    Akzeptanz: MVP-Test: Fahrziel Ladestation erreichen; Docking/Laden offen.
    MVP: Teilweise
    MVP-Begruendung: Rueckkehr als Fahrziel; automatisches Docking/Laden
      spaeter.
    */
  }

  // Trace sources from the reconciled Source fields and existing matrix.
  dependency from REQ_B_MIS_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_UI_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_STA_001 to UC_B_001_TransportauftragErteilen;
  dependency from REQ_B_STA_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_STA_001 to UC_B_005_BlockiertenFahrwegBehandeln;
  dependency from REQ_B_STA_001 to UC_B_006_PersonImFahrbereichBehandeln;
  dependency from REQ_B_STA_001 to UC_B_007_BetrieblichenStoppAusloesen;
  dependency from REQ_B_STA_001 to UC_B_009_TechnischenFehlerBehandeln;
  dependency from REQ_B_NAV_001 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_NAV_002 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_NAV_003 to UC_B_003_AutonomeTransportmissionAusfuehren;
  dependency from REQ_B_NAV_003 to UC_B_005_BlockiertenFahrwegBehandeln;
  dependency from REQ_B_NAV_004 to UC_B_004_TemporaeresHindernisBehandeln;
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
