# Modellbereinigung und Pruefung, 28.10.2026

## Ausgangspunkt und Umfang

Ausgangspunkt ist PR #1 mit Commit cd460a5d493e946e1765388176308c2a7baedfa7.
Die Bereinigung betrifft das bestehende Gesamtmodell in `sysml`, keine
Parallelarchitektur. Die Anforderungs-IDs und grundlegenden V1-Ziele bleiben
erhalten. Noch offene fachliche Parameter werden nicht durch Schaetzwerte ersetzt.

## Behobene Struktur- und Konsistenzprobleme

1. Genau ein kanonischer Robotertyp; Kontext, Schnittstellen und Simulation
   teilen diesen Typ. Die alten externen Namen sind kompatible Aliase.
2. Ports und Subsysteme befinden sich am selben Robotertyp. Externe Systeme
   sind eindeutig im Kontext definiert und ueber Ports verbunden.
3. Digitale Ports enthalten gerichtete, typisierte Inhalte. Physikalische
   Vertraege bleiben ohne erfundene Last-, Geometrie- oder Energieparameter.
4. Die Testdefinitionen verwenden qualifizierte Anforderungsreferenzen in
   Objectives. Alle 22 A.1-Anforderungen haben mindestens eine Testdefinition.
   Fehlende PWR-, Status-, Traceability-, Nutzlast- und Personentests sind als
   geplante Definitionen ergaenzt, nicht als ausgefuehrte Tests ausgegeben.
5. MapManagement wird als Verantwortung des vorhandenen NavigationSystem
   beschrieben, nicht als nicht existierendes Modellelement.
6. Die zehn B.1-Use-Cases sind echte Use-Case-Definitionen. Quellenbeziehungen
   werden im Modell referenziert; Matrix und Source-Felder sind abgeglichen.
7. Ein nominaler Aktionsfluss und Ereignisuebergaenge ersetzen rein textuelle
   Ablaufskizzen. Die Struktur referenziert diese Verhaltensdefinitionen.
8. Explizite Standard-Views ersetzen die irrefuehrende Bezeichnung ContextView
   fuer einen normalen Kontextbaustein.
9. Anforderungen, Rollen, Funktionen, Kandidaten-Mapping und Tests sind ueber
   aufgeloeste Modellreferenzen verbunden. Geplante Verantwortung wird nicht
   als nachgewiesene Erfuellung behauptet.

## Reproduzierbare Pruefung

```powershell
python tools/validate_sysml.py --self-test --negative-tests
```

Werkzeug: offizielle SysML v2 Pilot Implementation, Release 2025-10,
Kernel 0.53.0; zugehoerige Standardbibliothek; Java 21 oder neuer.
Der Download ist mit SHA-256
`bbd51b1827d9d4a586644d4a1d16e6f17c01a7ffa80ab49e3f8774fa1f46ce5e`
gepinnt. Laufzeit und Bibliothek werden nicht ins Repository eingecheckt.
Es wird keine Syside-Lizenz umgangen oder benoetigt.

Die GitHub-Actions-Pruefung verwendet denselben Befehl. Ein lokaler
Prueferfolg bedeutet noch nicht, dass der externe CI-Lauf bereits erfolgt ist.

### Modellpruefung und Auswertung

- 16 SysML-Quelldateien werden als Gesamtmodell geladen.
- Ziel: null Modellfehler und null Modellwarnungen; Warnungen blockieren CI.
- 15 synthetische Auswertungen: pass; zu wenige Raeume -> fail;
  fehlender Flur -> fail; keine offene Tuer -> fail; manuelle Fahrt -> fail;
  unvollstaendige bzw. fehlende Nachweise -> inconclusive. Acht weitere
  Faelle pruefen die manuelle Pausenfreigabe, Auftragserhalt, Bewegungsstopp,
  Ablehnung unsicherer Freigaben und fehlende Pausennachweise.
- Wiederverwendbare Constraint-Definitionen sind die gemeinsame Quelle der
  Kriterien fuer Anforderungen und Verifikationsauswertung.
- Drei Mutationen in temporaeren Kopien pruefen die Aufloesung von Importen,
  Features und kompatiblen Typbindungen. Die Referenzimplementierung meldet
  eine unpassende Typbindung als Warnung; das Projekt behandelt sie als Fehler
  seines Qualitaetsgates, ohne die Diagnose umzudeuten.

Die Gesamtpruefung mit 16 Quelldateien, 15 synthetischen Auswertungen
und drei Negativtests wurde erfolgreich ausgefuehrt: null Modellfehler,
null Modellwarnungen im unveraenderten Modell. Die absichtlich defekten
Kopien wurden jeweils erkannt.
Keine der synthetischen Eingaben dokumentiert eine reale Beobachtung.

## Noch nicht entschieden oder implementiert

- Wiederanlauf nach Blockade, technischem Fehler oder Sicherheitsstopp.
- Simulator, konkrete Hardware-/Sensor-/Energiekonfiguration, Weltgeometrie,
  Massen, Reibung, Nutzlast und quantitative Toleranzen.
- Bewertung physikalischer Realitaetsnaehe, Sicherheitskonzept und Dauerlauf.

Der Stand ist ein pruefbares Engineering-Modell mit auswertbaren Kriterien
und nominalem Verhalten einschliesslich expliziter manueller Pausenfreigabe.
Er ist keine implementierte Robotersteuerung und
kein ausgefuehrter physikalischer Simulationsversuch.

# Abgleich LaTeX und Modell, 05.11.2026

Die LaTeX-Dokumentation wurde auf den Modellstand gebracht. Bei B.1 wurde
umgekehrt das Modell ergaenzt, wo es Zuordnungen aus dem Kapitel verloren hatte.

- A.1: 25 Requirements, 20 Testdefinitionen in Kapitel 5, Kapitel 10 und
  Anhang C identisch mit dem Modell. REQ-UI-002 enthaelt die Pausenregel.
- Anhang C uebernimmt Systemelement, Schnittstelle und Test aus
  `sysml/baseline_a1/traceability_matrix.md`. Die Need-Spalte vereinigt die
  Quellen beider Fassungen.
- DEC-013 (Pausenregel) und DEC-014 (zunaechst nur Simulation) stehen in
  Entscheidungsprotokoll und Modell.
- Kapitel 8 und 9 verwenden die Modellnamen (`UserInterfaceSystem`,
  `DiagnosticsSystem`, ROS2-Kandidatennamen aus `07_ros2_mapping.sysml`).
  `/odom` wurde aus dem LaTeX ins Modell-Mapping uebernommen.
- B.1: REQ-B-NAV-004 ergaenzt; REQ-B-NAV-003 auch aus UC-B-003,
  REQ-B-STA-001 auch aus UC-B-006 abgeleitet.

`validate_sysml.py` prueft diesen Abgleich jetzt bei jedem Lauf.

Bewusst nicht abgeglichen: Die internen Schnittstellen aus Kapitel 8
(IF-MIS-NAV-001 usw.) sind im Modell nicht modelliert. Das ist
Architekturarbeit (Ports und Inhalte der Teilsysteme), kein Abgleich.

# Doku aus dem Modell, 05.11.2026

Entscheidung: Das Modell fuehrt. Die Requirement-, Test-, MVP- und
Traceability-Tabellen der LaTeX-Doku werden aus dem Modell erzeugt;
Overleaf passt nur ihr Aussehen an.

- Requirement- und Testtexte im Modell sind jetzt deutsch. Bezeichner bleiben
  englisch. Neue Doc-Felder: Gruppe, Quelle, MVP, MVP-Begruendung,
  Schnittstelle, Status (Requirements) sowie Name und Erwartet (Tests).
- Wo das Modell neuer war, gilt sein Inhalt: Werkstuecktraeger statt
  Materialkiste (REQ-TRN-001/002), Pose statt Position (REQ-LOC-001),
  Typ Leistung (REQ-PERF-001).
- `tools/generate_docs.py` schreibt `tables/generated/*.tex` (nur Zeilen) und
  den markierten Block in `sysml/baseline_a1/traceability_matrix.md`.
- `validate_sysml.py` ersetzt den bisherigen ID-Abgleich: Er prueft, dass die
  erzeugten Dateien aktuell sind und kein Kapitel handgeschriebene
  Requirement- oder Testzeilen enthaelt. Zwei Negativtests.
- Neuer CI-Lauf `latex.yml` baut das PDF. Dabei wurden zwei Fehler gefunden,
  die schon auf main das Kompilieren verhinderten (TikZ-Stil `step`,
  fehlendes `align` in der Kontextgrafik); beide behoben.

# Entscheidungsprotokoll im Modell, 05.11.2026

- `sysml/baseline_a1/09_decisions.sysml` enthaelt DEC-001 bis DEC-014 und
  ADR-0001 bis ADR-0008 als benannte Kommentare. `about` verbindet jede
  Entscheidung mit den betroffenen Requirements, Tests oder Teilsystemen;
  die Referenzimplementierung meldet falsche Verweise als Fehler.
- Die englische Liste `BaselineA1_Decisions` in `00_overview.sysml` und die
  Entscheidungsfelder in REQ-UI-002 und REQ-B-SAFE-003 sind entfallen.
- Erzeugt werden die DEC-Tabelle in Kapitel 3, beide Tabellen in Anhang A und
  das ADR-0001-Blatt in Kapitel 8. Kapitel 3 zeigt jetzt auch DEC-013 und
  DEC-014 und denselben Status wie Anhang A ("Angenommen" statt "Entschieden").
- Jede DEC-/ADR-Nennung im Repository muss eine Entscheidung im Modell haben.

# Teilsysteme und ROS2 aus dem Modell, 05.11.2026

- Die Teilsystemtabelle (Kapitel 8) kommt aus den `part def` in
  `03_structure.sysml`, in der Part-Reihenfolge von `MobileMaterialRobot`.
- ROS2-Mapping und ROS2-Topics (Kapitel 9) kommen aus
  `07_ros2_mapping.sysml`. Neu sind 14 Topic-Definitionen (`item def`).
  Die Richtung eines Topics wird aus Publiziert/Abonniert berechnet.
- Dabei sichtbar gewordene Abweichungen, offen zur fachlichen Klaerung:
  `/safety_state` hatte im Kapitel auch Mission als Abnehmer,
  `/battery_state` auch UI, `/mission_state` auch Logging. Im Modell
  abonniert keiner dieser Nodes das Topic; die Tabelle zeigt den Modellstand.

# Sicherheitsuebergaenge im Zustandsautomaten, 05.11.2026

- `MissionManagerNode` abonniert `/safety_state`; die Missionssteuerung
  erfaehrt damit vom Safety-Zustand und kann nach `safeState` wechseln.
- `RobotOperationState`: UnsafeCondition fuehrt jetzt aus allen aktiven
  Zustaenden (orderAccepted, driving, avoidingObstacle, paused,
  returningToChargingStation) nach `safeState`, TechnicalFault nach `fault`.
  Vorher galt beides nur in `driving`.
- `avoidingObstacle` ist erreichbar: driving --ObstacleDetected-->
  avoidingObstacle --ObstacleCleared--> driving bzw. --RouteBlocked--> blocked,
  wie in HandleTemporaryObstacle beschrieben.
- `validate_sysml.py` prueft die Regeln aus dem Doc-Block des Zustandsautomaten:
  Sicherheitsuebergaenge in allen aktiven Zustaenden, Erreichbarkeit aller
  Zustaende. Einzige erklaerte Ausnahme: `stopped` (Abbruch eines pausierten
  Auftrags ist nicht entschieden). Negativtest `missing_safety_exit`.
- Weiter offen: Wiederanlauf aus `safeState`, `fault` und `blocked`.

# Abbruch und Quittierung, DEC-015, 05.11.2026

- Neue Bedienbefehle `cancelMission` und `acknowledge`; Ereignisse
  `CancelRequested` und `AcknowledgeRequested` (mit safeToMove, faultCleared);
  Aktion `CancelMission` im MissionSystem.
- paused --CancelRequested--> stopped. Aus stopped, completed, rejected,
  blocked, chargingInterfaceReached --Acknowledge--> ready; aus fault nur mit
  faultCleared, aus safeState nur mit safeToMove.
- REQ-UI-002 nennt Abbruch und Quittierung; geplanter Test TC-UI-004.
- Validator: alle 15 Zustaende erreichbar, keiner ohne Ausgang (neue Regel,
  Negativtest dead_end_state). Die Ausnahme fuer stopped ist entfallen.
- Offen: Not-Halt (OI-SAFE-001).

# Fehler im Stillstand, DEC-016, 05.11.2026

- ready und blocked gelten als aktive Zustaende. Auch dort fuehren
  UnsafeCondition nach safeState und TechnicalFault nach fault.
- Die Regel ist jetzt als DEC-016 im Entscheidungsprotokoll festgehalten und
  mit REQ-SAFE-001, REQ-B-SAFE-001, REQ-DIAG-001 und SafetySystem verknuepft.
- Nicht als aktiv gelten weiterhin: off, initializing, completed, rejected,
  stopped, chargingInterfaceReached, fault, safeState.

# Sicherheitsregel als Ausnahmeliste, 05.11.2026

- DEC-016 gilt jetzt fuer jeden Zustand ausser off, fault und safeState.
  Neu abgedeckt: initializing, completed, rejected, stopped,
  chargingInterfaceReached. Ein kuenftig neuer Zustand ist automatisch
  eingeschlossen und braucht beide Uebergaenge.
- Der Doc-Block nennt nur noch die Ausnahmen ("Ohne Sicherheitsuebergaenge").
- Die Sackgassen-Regel verlangt einen regulaeren Ausgang; Sicherheits- und
  Fehleruebergaenge allein zaehlen nicht.

# Annahmen im Modell, 05.11.2026

- `sysml/baseline_a1/10_assumptions.sysml`: A-001 bis A-010 als benannte
  Kommentare mit ID, Annahme und Status; `about` verknuepft jede Annahme mit
  den abhaengigen Requirements, Teilsystemen oder Kontextelementen.
- Die englische Liste `BaselineA1_Assumptions` in `00_overview.sysml` ist
  entfallen. Die Annahmentabelle in Kapitel 3 wird erzeugt; ihr Inhalt ist
  unveraendert.
- Status ist auf vier Werte beschraenkt; jede A-nnn-Nennung im Repository
  muss eine Annahme im Modell haben (Negativtest unknown_assumption_reference).

# A-010 wird REQ-ARCH-003, 05.11.2026

- A-010 ("Mehr-Roboter-Erweiterung nicht verhindern") war keine Annahme ueber
  die Umgebung, sondern eine Forderung an das System. Neu: REQ-ARCH-003
  (Constraint) mit pruefbarem Akzeptanzkriterium, zugeordnet MissionSystem,
  NavigationSystem und CommunicationSystem; Schnittstellen TransportOrder,
  MissionStatus, MapManagementNode. Geplanter Review-Test TC-ARCH-001.
- A-010 bleibt mit Status "Ersetzt" und Verweis auf REQ-ARCH-003 erhalten,
  damit die ID nachvollziehbar bleibt. Der Generator prueft, dass der
  Verweis auf ein existierendes Requirement zeigt.
- Bekannte Luecke, die TC-ARCH-001 aufdecken soll: TransportOrder und
  MissionStatus haben keine Roboterkennung, ROS2-Topics sind global benannt.

# Roboterkennung, 05.11.2026

- `robotId` in `TransportOrder` (optional: noch nicht zugeteilt),
  `MissionStatus` (Pflicht: meldender Roboter) und `OperatorCommand`
  (optional: leer = der einzige Roboter nach A-009).
- REQ-ARCH-003 ist damit zu einem Drittel erfuellt; offen bleiben der
  ROS2-Namensraum je Roboter und die Freigabe dauerhafter Kartenaenderungen.
