package MobileMaterialRobot_Decisions_A1 {
  private import MobileMaterialRobot_Requirements_A1::*;
  private import MobileMaterialRobot_Requirements_B1::*;
  private import MobileMaterialRobot_Verification_A1::*;
  private import MobileMaterialRobot_Simulation_A1::SimulationTestBench;
  private import MobileMaterialRobot_Structure_A1::*;

  doc /*
  Entscheidungsprotokoll. Jede Entscheidung ist ein benannter Kommentar.
  'about' verknuepft sie mit den betroffenen Modellelementen; ein falscher
  Verweis ist ein Modellfehler. Die Felder sind Quelle der
  Entscheidungstabellen in Kapitel 3, Kapitel 8 und Anhang A; siehe tables/README.md.
  Art: Baseline (DEC) oder Architektur (ADR).
  */

  // Entscheidungen der Baseline A.1

  comment DEC_001 /*
    ID: DEC-001
    Art: Baseline
    Entscheidung: Das Zielsystem ist ein Indoor-Demonstrator.
    Status: Angenommen
    Begruendung: Der Einsatz erfolgt in einem produktionsaehnlichen
      Schulbereich.
  */

  comment DEC_002 /*
    ID: DEC-002
    Art: Baseline
    Entscheidung: Einsatzort ist ein produktionsaehnlicher Schulbereich.
    Status: Angenommen
    Begruendung: Der didaktische Zweck ist Teil des Projekts.
  */

  comment DEC_003 about TransportSystem /*
    ID: DEC-003
    Art: Baseline
    Entscheidung: Transportgut ist ein Werkstuecktraeger eines Transfersystems.
    Status: Angenommen
    Begruendung: Erzeugt eine klare mechanische Schnittstelle.
  */

  comment DEC_004 about TransportSystem /*
    ID: DEC-004
    Art: Baseline
    Entscheidung: Die Beladung erfolgt zunaechst extern durch Mensch oder
      Transfersystem.
    Status: Angenommen
    Begruendung: Reduziert MVP-Komplexitaet und haelt die
      Zielsystem-Schnittstelle sichtbar.
  */

  comment DEC_005 about REQ_NAV_004 /*
    ID: DEC-005
    Art: Baseline
    Entscheidung: Der Fahrbereich umfasst mehrere Raeume und einen Flur.
    Status: Angenommen
    Begruendung: Macht Navigation realistischer als ein einzelner Testraum.
  */

  comment DEC_006 about REQ_NAV_005 /*
    ID: DEC-006
    Art: Baseline
    Entscheidung: Offene Tueren muessen befahrbar sein.
    Status: Angenommen
    Begruendung: Wichtige Randbedingung fuer Abmessungen, Navigation und Test.
  */

  comment DEC_007 about REQ_PERF_001, REQ_B_PERF_001 /*
    ID: DEC-007
    Art: Baseline
    Entscheidung: Die MVP-Geschwindigkeit liegt bei ca. 0,5 m/s.
    Status: Angenommen
    Begruendung: Niedriges Risiko, geeignet fuer Unterricht und fruehe Tests.
  */

  comment DEC_008 about REQ_PWR_002, REQ_B_PWR_001 /*
    ID: DEC-008
    Art: Baseline
    Entscheidung: Die Zielbetriebsdauer der ersten Version liegt bei ca. 2 h.
    Status: Angenommen
    Begruendung: Deckt einen 90-min-Unterrichtsblock mit Reserve ab.
  */

  comment DEC_009 about REQ_UI_001, REQ_B_UI_001 /*
    ID: DEC-009
    Art: Baseline
    Entscheidung: Transportauftraege werden zunaechst ueber eine Web-App
      ausgeloest.
    Status: Angenommen
    Begruendung: Einfacher Einstieg ohne Produktionsleitsystem.
  */

  comment DEC_010 about REQ_UI_002 /*
    ID: DEC-010
    Art: Baseline
    Entscheidung: Eine einfache Bedienoberflaeche fuer Status, Stopp und
      Rueckkehr zur Ladestation ist vorgesehen.
    Status: Angenommen
    Begruendung: Erforderlich fuer Bedienbarkeit, Tests und Demonstration.
  */

  comment DEC_011 about EnergySystem, REQ_B_ENE_001 /*
    ID: DEC-011
    Art: Baseline
    Entscheidung: Rueckkehr zur Ladestation gehoert zum Zielsystem.
    Status: Angenommen
    Begruendung: Energie- und Betriebsaspekte bleiben frueh sichtbar.
  */

  comment DEC_012 /*
    ID: DEC-012
    Art: Baseline
    Entscheidung: Hoehere Geschwindigkeit wird als spaetere Erweiterung
      gefuehrt.
    Status: Angenommen
    Begruendung: Architektur soll Erweiterung nicht unnoetig blockieren.
  */

  comment DEC_013 about REQ_UI_002, REQ_MIS_002, REQ_B_SAFE_003, TC_UI_003 /*
    ID: DEC-013
    Art: Baseline
    Entscheidung: Ein betrieblicher Stopp pausiert den laufenden
      Transportauftrag. Auftrags-ID, Start und Ziel bleiben erhalten.
      Fortsetzung nur nach ausdruecklicher manueller Freigabe; Sicherheits-
      und Routenpruefung werden dabei nicht umgangen.
    Status: Angenommen
    Datum: 28.10.2026
    Begruendung: Kein unbeabsichtigter Wiederanlauf; der Auftrag geht nicht
      verloren. Rueckkehr nach Blockade, Fehler und Sicherheitsstopp regelt
      DEC-015.
  */

  comment DEC_014 about TC_NAV_002, SimulationTestBench /*
    ID: DEC-014
    Art: Baseline
    Entscheidung: Verifikation erfolgt zunaechst ausschliesslich in der
      Simulation, ohne reale Hardware. Der Simulator ist noch nicht
      ausgewaehlt.
    Status: Angenommen
    Datum: 28.10.2026
    Begruendung: Navigationstests werden moeglich, bevor Fahrwerk, Sensorik
      und Nutzlast festgelegt sind.
  */

  comment DEC_015 about REQ_UI_002, REQ_MIS_002, REQ_B_STA_001, REQ_B_SAFE_003, TC_UI_004 /*
    ID: DEC-015
    Art: Baseline
    Entscheidung: Ein pausierter Auftrag kann vom Bediener abgebrochen werden;
      er wird verworfen, der Roboter meldet gestoppt. Aus gestoppt,
      abgeschlossen, abgelehnt, blockiert, Ladebereich erreicht, Fehler und
      sicherem Zustand fuehrt nur eine manuelle Quittierung zurueck in den
      Bereitschaftszustand. Aus Fehler nur bei behobenem Fehler, aus sicherem
      Zustand nur wenn die Bewegung wieder sicher ist. Die Quittierung setzt
      keinen Not-Halt zurueck.
    Status: Angenommen
    Datum: 05.11.2026
    Begruendung: Kein Zustand ist mehr eine Sackgasse; der Roboter nimmt nach
      jedem Ende wieder Auftraege an. Die Rueckkehr bleibt eine bewusste
      Bedienhandlung, wie die Fortsetzung nach DEC-013. Der Status gestoppt
      aus REQ-B-STA-001 erhaelt eine Bedeutung.
  */

  comment DEC_016 about REQ_SAFE_001, REQ_B_SAFE_001, REQ_DIAG_001, SafetySystem /*
    ID: DEC-016
    Art: Baseline
    Entscheidung: Unsichere Situationen fuehren in den sicheren Zustand,
      technische Fehler in den Fehlerzustand, und zwar in allen aktiven
      Betriebszustaenden: bereit, Auftrag angenommen, Fahrt, Ausweichen,
      pausiert, blockiert und Rueckkehr zur Ladestation. Das gilt auch im
      Stillstand.
    Status: Angenommen
    Datum: 05.11.2026
    Begruendung: Ein Fehler im Stillstand, z. B. am Akku, ist genauso
      relevant wie waehrend der Fahrt. Ein pausierter oder blockierter
      Auftrag darf nach einem Fehler nicht einfach fortgesetzt werden.
  */

  // Architektur- und Prozessentscheidungen

  comment ADR_0001 about REQ_ARCH_002 /*
    ID: ADR-0001
    Art: Architektur
    Titel: Gesamtmodell vor MVP-Modell
    Entscheidung: Das Gesamtmodell wird von Beginn an mit allen zentralen
      Zielsystem-Teilsystemen aufgebaut. Der MVP implementiert nur einen
      markierten Teil davon.
    Status: Angenommen
    Version: 0.1
    Begruendung: Vermeidet Doppelarbeit und haelt MVP-Elemente rueckfuehrbar
      auf das Zielsystem.
    Begruendung-Detail: Ein separates MVP-Modell wuerde spaeter Doppelarbeit
      erzeugen. Eine direkte Implementierung wuerde Traceability verlieren.
      Eine vollstaendige Zielarchitektur vor dem ersten Prototyp waere zu
      schwerfaellig.
    Alternativen: Separates MVP-Modell; direkte Implementierung ohne
      Zielarchitektur; vollstaendige Zielarchitektur vor erstem Prototyp
    Auswirkung: Alle Artefakte benoetigen Status- und Prioritaetsattribute.
      MVP-Elemente bleiben auf Zielsystem-Elemente rueckfuehrbar.
    Risiko: Noch nicht implementierte Zielsystembereiche koennen zu grob
      bleiben. Dieses Risiko wird durch offene Punkte und spaetere
      Iterationen kontrolliert.
  */

  comment ADR_0002 /*
    ID: ADR-0002
    Art: Architektur
    Titel: MVP 1 fokussiert Navigationskern
    Status: Angenommen
    Begruendung: Prueft zentrale technische Hypothese ohne volle Komplexitaet
      der Kistenhandhabung.
  */

  comment ADR_0003 about TransportSystem /*
    ID: ADR-0003
    Art: Architektur
    Titel: TransportSystem bleibt Teil der Zielarchitektur
    Status: Angenommen
    Begruendung: Verhindert, dass spaetere Materialhandhabung architektonisch
      vergessen wird.
  */

  comment ADR_0004 /*
    ID: ADR-0004
    Art: Architektur
    Titel: ROS2-Mapping als Architekturartefakt
    Status: Angenommen
    Begruendung: Verbindet Modell, Implementierung und Tests; keine starre
      1:1-Uebersetzung.
  */

  comment ADR_0005 /*
    ID: ADR-0005
    Art: Architektur
    Titel: Dokumentation als lebendes Overleaf-Projekt
    Status: Angenommen
    Begruendung: Ermoeglicht fortlaufende Pflege, Review und spaetere
      Veroeffentlichung.
  */

  comment ADR_0006 /*
    ID: ADR-0006
    Art: Architektur
    Titel: Keine vorzeitige Festlegung auf konkrete Technologien in
      Iteration A
    Status: Angenommen
    Begruendung: Anforderungen und Loesungen bleiben getrennt; ROS2,
      Sensorik, Rechner und Fahrwerk werden spaeter begruendet entschieden.
  */

  comment ADR_0007 about REQ_MAP_003, REQ_B_MAP_002 /*
    ID: ADR-0007
    Art: Architektur
    Titel: Kartenkonzept in drei Informationsarten trennen
    Status: Angenommen
    Begruendung: Basisinformationen, aktuelle Umgebungsinformationen und
      dauerhaft erkannte Aenderungen werden getrennt, um fehlerhafte
      Kartenupdates zu vermeiden.
  */

  comment ADR_0008 /*
    ID: ADR-0008
    Art: Architektur
    Titel: Iteration B aus Betriebsfaellen statt aus isolierter
      Requirements-Liste ableiten
    Status: Angenommen
    Begruendung: Use Cases schaffen Kontext fuer Anforderungen, Alternativen
      und Verifikation.
  */
}
