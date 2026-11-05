package MobileMaterialRobot_Requirements_A1 {
  private import ScalarValues::*;
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  constraint def MultiRoomCriterion {
    in attribute roomsVisited : Integer;
    in attribute corridorTraversed : Boolean;
    roomsVisited >= 2 and corridorTraversed
  }

  constraint def OpenDoorCriterion {
    in attribute openDoorPassed : Boolean;
    in attribute autonomousDriving : Boolean;
    openDoorPassed and autonomousDriving
  }

  doc /*
  Systemanforderungen der Baseline A.1. Die Doc-Felder (ID, Typ, Gruppe,
  Quelle, Text, Akzeptanz, MVP, MVP-Begruendung, Schnittstelle, Status,
  Hinweis) sind Quelle der LaTeX-Tabellen; Entscheidungen verweisen per
  'about' aus 09_decisions.sysml auf Requirements; siehe
  tables/README.md. Formale Kriterien stehen in den constraint defs.
  */

  requirement REQ_MIS_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MIS-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-UI-001, UC-001, SN-001
    Text: Das System muss einen Transportauftrag mit Start- und Zielstandort
      annehmen koennen.
    Akzeptanz: Auftrag wird angenommen, validiert und mit Status versehen.
    Schnittstelle: IF-002, MissionManagerNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_MIS_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MIS-002
    Typ: Funktional
    Gruppe: Iteration A
    Quelle: SN-USER-002, SN-USER-003
    Text: Das System muss melden, ob ein Transportauftrag angenommen, abgelehnt,
      pausiert, blockiert oder abgeschlossen wurde.
    Akzeptanz: Statuswechsel sind fuer Bedienung und Test nachvollziehbar.
    Schnittstelle: /mission_state
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_TRN_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-TRN-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-TRN-001, SN-002
    Text: Das System muss einen Werkstuecktraeger zwischen zwei definierten
      Transportorten transportieren koennen.
    Akzeptanz: Der Werkstuecktraeger erreicht den Zielort im definierten
      Testaufbau.
    MVP: Nicht MVP
    MVP-Begruendung: Materialumschlag wird im Zielsystem modelliert, aber im
      ersten MVP noch nicht voll implementiert.
    Schnittstelle: IF-003
    Status: Geplant; Nutzlastdaten und -grenzen offen
    */
  }

  requirement REQ_TRN_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-TRN-002
    Typ: Safety/Funktional
    Gruppe: Iteration A
    Quelle: SN-TRN-002, SN-SAFE-003
    Text: Das System muss den transportierten Werkstuecktraeger waehrend des
      Transports so halten oder sichern, dass er keine zusaetzliche Gefaehrdung
      verursacht.
    Akzeptanz: Der Werkstuecktraeger bleibt im spezifizierten Fahrprofil
      innerhalb der zulaessigen Lage.
    Schnittstelle: IF-003
    Status: Geplant; Nutzlastdaten und -grenzen offen
    */
  }

  requirement REQ_MAP_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MAP-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: Kartenkonzept Baseline A.1
    Text: Das System muss eine vorhandene Grundkarte des Betriebsbereichs laden
      koennen.
    Akzeptanz: Karte wird geladen und fuer Lokalisierung genutzt.
    MVP: MVP
    MVP-Begruendung: Ohne Grundkarte ist der geplante Navigationskern nicht
      nachweisbar.
    Schnittstelle: MapManagementNode, /map
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_MAP_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MAP-002
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-NAV-002, SN-006
    Text: Das System muss relevante Veraenderungen der befahrbaren Umgebung
      waehrend des Betriebs erkennen.
    Akzeptanz: Hindernis erscheint in lokaler Umgebungsdarstellung.
    MVP: MVP
    MVP-Begruendung: Laufzeitaktualisierung der Umgebung ist Kern der
      Projektidee.
    Schnittstelle: PerceptionNode, /local_obstacles
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_MAP_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MAP-003
    Typ: Constraint
    Gruppe: Iteration A
    Quelle: ADR-0007, SN-NAV-002, R-09
    Text: Das System muss zwischen Basisinformationen, aktuellen
      Umgebungsinformationen und moeglichen dauerhaften Kartenupdates
      unterscheiden koennen.
    Akzeptanz: Temporaeres Hindernis veraendert die Langzeitkarte nicht
      automatisch.
    Schnittstelle: MapManagementNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_LOC_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-LOC-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: UC-006
    Text: Das System muss seine Pose innerhalb des definierten Betriebsbereichs
      bestimmen koennen.
    Akzeptanz: Die Posenabweichung liegt innerhalb einer noch festzulegenden
      Toleranz.
    MVP: MVP
    MVP-Begruendung: Lokalisierung ist Voraussetzung fuer zielgerichtete
      Navigation.
    Schnittstelle: LocalizationNode, /robot_pose
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_NAV_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-NAV-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: UC-003
    Text: Das System muss einen vorgegebenen Zielstandort autonom anfahren
      koennen.
    Akzeptanz: Ziel wird ohne manuelle Steuerung erreicht.
    MVP: MVP
    MVP-Begruendung: Autonomes Zielanfahren ist zentraler Funktionsnachweis.
    Schnittstelle: NavigationNode, /cmd_vel
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_NAV_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-NAV-002
    Typ: Funktional
    Gruppe: Initial
    Quelle: UC-007
    Text: Das System muss erkannte Hindernisse bei der Bewegungs- oder
      Pfadplanung beruecksichtigen.
    Akzeptanz: Roboter stoppt oder plant lokale Umfahrung.
    MVP: MVP
    MVP-Begruendung: Hindernisbehandlung prueft die Kopplung von Wahrnehmung und
      Navigation.
    Schnittstelle: NavigationNode, PerceptionNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_NAV_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-NAV-003
    Typ: Funktional
    Gruppe: Iteration A
    Quelle: UC-008, SN-NAV-004
    Text: Das System muss erkennen koennen, wenn ein Ziel oder Fahrweg nicht
      erreichbar ist.
    Akzeptanz: System meldet Blockade oder Nichterreichbarkeit mit
      nachvollziehbarem Status.
    Schnittstelle: /navigation_result, /mission_state
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_NAV_004 {
    subject robot : MobileMaterialRobot;
    in attribute roomsVisited : Integer;
    in attribute corridorTraversed : Boolean;
    require constraint routeCriterion : MultiRoomCriterion {
      in attribute :>> roomsVisited = REQ_NAV_004::roomsVisited;
      in attribute :>> corridorTraversed = REQ_NAV_004::corridorTraversed;
    }
    doc /*
    ID: REQ-NAV-004
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-NAV-005, UC-004
    Text: Das System muss im definierten Fahrbereich mehrere Raeume und einen
      verbindenden Flur erreichen koennen.
    Akzeptanz: Testfahrt fuehrt ueber mindestens zwei Raeume und einen Flur.
    MVP: MVP
    MVP-Begruendung: Mehrere Raeume und Flur bilden den Demonstrationskern.
    Schnittstelle: IF-005
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_NAV_005 {
    subject robot : MobileMaterialRobot;
    in attribute openDoorPassed : Boolean;
    in attribute autonomousDriving : Boolean;
    require constraint doorCriterion : OpenDoorCriterion {
      in attribute :>> openDoorPassed = REQ_NAV_005::openDoorPassed;
      in attribute :>> autonomousDriving = REQ_NAV_005::autonomousDriving;
    }
    doc /*
    ID: REQ-NAV-005
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-NAV-006, UC-004
    Text: Das System muss offene Tueren im definierten Fahrbereich durchfahren
      koennen.
    Akzeptanz: Testfahrt passiert eine offene Tuer ohne manuelle
      Fahrzeugsteuerung.
    MVP: MVP
    MVP-Begruendung: Offene Tueren sind zentrale Randbedingung der Umgebung.
    Schnittstelle: IF-005
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_SAFE_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-SAFE-001
    Typ: Safety
    Gruppe: Initial
    Quelle: SN-SAFE-002, SN-004
    Text: Das System muss bei nicht sicher behandelbaren Hindernissen in einen
      sicheren Zustand uebergehen.
    Akzeptanz: Kein Kontakt mit Hindernis; Statusmeldung Blockade.
    MVP: MVP reduziert
    MVP-Begruendung: Fuer MVP mindestens sicheres Stoppen; spaetere
      Safety-Auslegung bleibt offen.
    Schnittstelle: SafetySupervisorNode, /safety_state
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_SAFE_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-SAFE-002
    Typ: Safety
    Gruppe: Iteration A
    Quelle: SN-SAFE-001, R-04
    Text: Das System muss Personen im Fahrbereich bei der Bewegungsentscheidung
      sicherheitsrelevant beruecksichtigen.
    Akzeptanz: Roboter reduziert Bewegung, stoppt oder waehlt Alternative
      gemaess spaeterem Safety-Konzept.
    Schnittstelle: IF-006, SafetySupervisorNode
    Status: Geplant; Safety-Konzept offen
    */
  }

  requirement REQ_UI_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-UI-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-UI-001, UC-001
    Text: Das System muss Transportauftraege in der ersten Version ueber eine
      Web-App entgegennehmen koennen.
    Akzeptanz: Benutzer kann Start und Ziel auswaehlen und Auftrag starten.
    MVP: MVP
    MVP-Begruendung: Die Web-App ist die erste reale Auftragsschnittstelle.
    Schnittstelle: IF-001, IF-002, WebInterfaceNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_UI_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-UI-002
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-UI-002, UC-009, UC-010
    Text: Das System muss grundlegende Bedienbefehle fuer Status, betrieblichen
      Stopp, ausdrueckliche manuelle Fortsetzung oder Abbruch des Auftrags,
      Quittierung und Rueckkehr zur Ladestation bereitstellen.
    Akzeptanz: Die Befehle sind ausloesbar und erzeugen nachvollziehbare
      Systemreaktionen. Ohne manuelle Freigabe wird nicht automatisch
      fortgesetzt.
    MVP: MVP reduziert
    MVP-Begruendung: Status, betrieblicher Stopp mit manueller Fortsetzung und
      Rueckkehr zur Ladestation werden als Grundbefehle betrachtet.
    Schnittstelle: WebInterfaceNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_PWR_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-PWR-001
    Typ: Nichtfunktional
    Gruppe: Initial
    Quelle: Bedarf Energieueberwachung
    Text: Das System muss seinen Energiezustand ueberwachen.
    Akzeptanz: Niedriger Ladezustand wird erkannt und gemeldet.
    Schnittstelle: EnergyMonitorNode, /battery_state
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_PWR_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-PWR-002
    Typ: Nichtfunktional
    Gruppe: Initial
    Quelle: SN-ENE-001, DEC-008
    Text: Die erste Version soll eine Betriebsdauer von ca. 2 h fuer einen
      Unterrichtsblock abdecken.
    Akzeptanz: Testprofil fuer Unterrichtsbetrieb wird definiert und erreicht.
    MVP: MVP
    MVP-Begruendung: 2 h Betriebsdauer decken einen 90-min-Unterrichtsblock mit
      Reserve ab.
    Schnittstelle: EnergyMonitorNode
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_PERF_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-PERF-001
    Typ: Leistung
    Gruppe: Initial
    Quelle: DEC-007
    Text: Die Nominalgeschwindigkeit des MVP soll ca. 0,5 m/s betragen.
    Akzeptanz: Fahrprofil wird mit definierter Toleranz gemessen.
    MVP: MVP
    MVP-Begruendung: Niedrige Geschwindigkeit reduziert Risiko und erleichtert
      Unterricht und Tests.
    Schnittstelle: NavigationNode Parameter nominal_speed
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_STA_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-STA-001
    Typ: Funktional
    Gruppe: Initial
    Quelle: SN-OPS-001, SN-003
    Text: Das System muss seinen Missions- und Betriebsstatus melden koennen.
    Akzeptanz: Status ist fuer Bediener/Betreiber abrufbar.
    MVP: MVP
    MVP-Begruendung: Statusmeldung ist fuer Testbarkeit und Bedienbarkeit
      erforderlich.
    Schnittstelle: /mission_state
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_ARCH_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-ARCH-001
    Typ: Constraint
    Gruppe: Initial
    Quelle: SN-DEV-003, SN-008
    Text: Jede wesentliche Funktion muss auf mindestens ein logisches
      Systemelement und eine Verifikationsidee abbildbar sein.
    Akzeptanz: Die Traceability-Matrix enthaelt fuer MVP-Elemente keine leeren
      Kernspalten.
    Systemelement: Gesamtmodell
    Schnittstelle: Traceability-Artefakte
    Status: Geplant; kein Ausfuehrungsnachweis
    */
  }

  requirement REQ_DIAG_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-DIAG-001
    Typ: Operational
    Gruppe: Initial
    Quelle: SN-005, SN-MNT-001
    Text: Das System muss Diagnoseinformationen fuer Fehlersuche bereitstellen.
    Akzeptanz: Fehlermeldungen enthalten Ursache, betroffene Funktion und
      Zeitstempel.
    Schnittstelle: DiagnosticsNode, /diagnostics
    Status: Geplant; Meldungsfelder noch nicht modelliert
    Hinweis: DiagnosticMessage enthaelt bisher nur Freitext; die drei
      Abnahmefelder sind noch nicht als Attribute modelliert.
    */
  }

  requirement REQ_MNT_001 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-MNT-001
    Typ: Operational
    Gruppe: Iteration A
    Quelle: SN-MNT-002
    Text: Zentrale Komponenten und Verschleissteile muessen fuer Wartung
      zugaenglich sein.
    Akzeptanz: Wartungsreview bestaetigt Zugang ohne unverhaeltnismaessige
      Demontage.
    Schnittstelle: offen
    Status: Geplant; erfordert mechanischen Entwurf
    Hinweis: Pruefkriterien und Komponentenliste sind offen; vor einem
      mechanischen Entwurf nicht pruefbar.
    */
  }

  requirement REQ_ARCH_002 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-ARCH-002
    Typ: Constraint
    Gruppe: Iteration A
    Quelle: SN-DEV-001, SN-DEV-002
    Text: Das System muss so strukturiert werden, dass ein MVP als Teilmenge des
      Zielsystems markiert werden kann.
    Akzeptanz: MVP-Elemente referenzieren Zielsystem-Elemente statt ein
      separates Wegwerfmodell zu bilden.
    Systemelement: Gesamtmodell
    Schnittstelle: MVP-Markierung (noch nicht modelliert)
    Status: Geplant; MVP-Status nur als Dokumentationsfeld, noch keine
      SysML-Metadaten
    Hinweis: Der MVP-Status steht bisher nur als Dokumentationsfeld im
      Requirement, noch nicht als SysML-Metadaten.
    */
  }

  requirement REQ_ARCH_003 {
    subject robot : MobileMaterialRobot;
    doc /*
    ID: REQ-ARCH-003
    Typ: Constraint
    Gruppe: Iteration A
    Quelle: A-010, SN-DEV-001, SN-DEV-002
    Text: Das System muss so strukturiert werden, dass eine spaetere
      Erweiterung auf mehrere Roboter nicht unnoetig verhindert wird.
    Akzeptanz: Transportauftrag und Missionsstatus koennen einem Roboter
      zugeordnet werden; ROS2-Topics sind je Roboter in einem eigenen
      Namensraum adressierbar; fuer dauerhafte Kartenaenderungen ist
      festgelegt, wer sie freigibt.
    Schnittstelle: TransportOrder, MissionStatus, OperatorCommand,
      MapManagementNode, ROS2-Namensraum
    Status: Geplant; Roboterkennung modelliert, Namensraum und
      Kartenfreigabe offen
    Hinweis: Entstanden aus der frueheren Annahme A-010. TransportOrder,
      MissionStatus und OperatorCommand tragen eine Roboterkennung (robotId).
      Offen sind der ROS2-Namensraum je Roboter und die Freigabe dauerhafter
      Kartenaenderungen.
    */
  }
}

