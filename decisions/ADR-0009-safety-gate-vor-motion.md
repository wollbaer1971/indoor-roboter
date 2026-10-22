# ADR-0009: Safety-Gate zwischen Navigation und Motion

- Status: Vorgeschlagen
- Datum: 2026-10-22
- Betroffene Requirements: REQ-SAFE-001, REQ-SAFE-002, REQ-PERF-001, REQ-B-SAFE-001, REQ-B-SAFE-003
- Betroffene Open Issues: OI-SAFE-001, OI-SAFE-002
- Betroffene Tests: TC-OBS-001, TC-OBS-002, neu TC-SAFE-001

## Kontext

Im vorlaeufigen ROS2-Mapping (SysML `07_ros2_mapping.sysml`) veroeffentlicht der
`navigation_node` die Fahrbefehle `/cmd_vel` direkt an den Antrieb. Der
`safety_supervisor_node` liest `/cmd_vel` mit und meldet `/safety_state`, auf das
wiederum die Navigation reagieren soll.

Damit haengt der Sicherheitsstopp davon ab, dass genau die Komponente gehorcht,
die gerade den Fehler macht. Haengt die Navigation, stuerzt sie ab oder plant sie
falsch, sendet sie weiter Fahrbefehle. Der Supervisor kann das nur melden, nicht
verhindern.

Kapitel 9 der Dokumentation sieht `/safety_state` bereits als Signal an Motion vor
und nennt einen zusaetzlichen Hardware-Stopp. Das SysML-Mapping ist davon
abgewichen.

## Betrachtete Alternativen

1. **Navigation reagiert auf `/safety_state`** (bisheriges SysML-Mapping).
   Abgelehnt: Die Sicherheit haengt von der fehlerverursachenden Komponente ab.
2. **Motion-Controller reagiert auf `/safety_state`** (Kapitel 9).
   Besser, weil der Stopp nah am Antrieb wirkt. Nachteil: Der Motion-Controller
   vermischt Regelung und Sicherheitslogik, und der Sicherheitspfad ist schwer
   getrennt zu testen.
3. **Eigenes Safety-Gate zwischen Navigation und Motion.** Die Navigation
   veroeffentlicht `/cmd_vel_nav`. Ein `velocity_gate_node` der SafetySystem-Schicht
   gibt diese Befehle nur bei freigegebenem `/safety_state` als `/cmd_vel` an den
   Motion-Controller weiter, sonst Nullgeschwindigkeit.

## Entscheidung

Alternative 3. Der `velocity_gate_node` ist der einzige Node, der `/cmd_vel`
veroeffentlicht. Er arbeitet fail-safe:

- `/safety_state` nicht freigegeben -> Nullgeschwindigkeit.
- `/safety_state` aelter als ein festzulegendes Timeout -> Nullgeschwindigkeit.
- `/cmd_vel_nav` aelter als ein festzulegendes Timeout -> Nullgeschwindigkeit.

Zusaetzlich stoppt der Motion-Controller (bzw. die MCU-Firmware), wenn `/cmd_vel`
ausbleibt (Watchdog).

Der betriebliche Stopp (OperationalStop) laeuft weiter ueber die Mission: Sie
bricht das Navigationsziel ab. Er ist bewusst kein Teil des Safety-Gates. Das
haelt die Trennung aus REQ-B-SAFE-003 auch in der Software sichtbar.

## Begruendung

- Ein Fehler in der Navigation kann den Roboter nicht mehr in Bewegung halten.
- Das Gate ist klein und laesst sich isoliert testen (TC-SAFE-001).
- Die Regel "nur die Safety-Schicht sendet `/cmd_vel`" ist maschinell pruefbar.
  `sysml/tools/generate_traceability.py` bricht ab, wenn sie verletzt wird.

## Auswirkungen

- Zielsystem: neue Nodes `velocity_gate_node` (SafetySystem) und
  `motion_controller_node` (MotionSystem, Name aus Kapitel 9). Das
  MotionSystem ist damit erstmals einem ROS2-Node zugeordnet.
- MVP: geringer Mehraufwand. Bei Nutzung von Nav2 entspricht das dem ueblichen
  Muster, den Controller-Ausgang auf ein eigenes Topic umzulegen und ueber einen
  Mux oder ein Gate an den Antrieb zu fuehren.

## Risiken und Grenzen

- **Das Gate ist Software und nicht sicherheitsgerichtet.** Es ersetzt keinen
  Not-Halt und keine Sicherheitsabschaltung der Motoren in Hardware. Fuer den
  Schutz von Personen bleibt OI-SAFE-001 offen: Not-Halt, Safety-Hardware und
  ggf. sicherheitsgerichteter Sensor muessen unabhaengig von ROS2 wirken.
- Timeouts und zulaessige Latenzen sind offen (OI-SAFE-002). Ohne Zahlen ist der
  fail-safe-Mechanismus nicht verifizierbar.
- Ein zusaetzlicher Node erhoeht die Latenz zwischen Planung und Antrieb leicht.
