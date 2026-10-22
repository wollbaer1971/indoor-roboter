# SysML v2 Artefakte

Dieser Ordner enthaelt die textuellen SysML-v2-Modelldateien.

Aktueller Stand:

- `baseline_a1/`: System Definition Baseline A.1 (Kontext, Requirements, Struktur, Schnittstellen, Verhalten, Tests, ROS2-Mapping)
- `baseline_b1/`: Iteration B (Use Cases, Candidate Requirements)

## Modellregeln

- Der Roboter `MobileMaterialRobot` ist genau einmal definiert, in `baseline_a1/03_structure.sysml` (Paket `MobileMaterialRobot_Structure_A1`). Alle anderen Pakete holen ihn per `import`.
- Port-Typen liegen in `baseline_a1/04_interfaces.sysml`. Die externen Systeme samt ihren Ports liegen in `baseline_a1/01_context.sysml`.
- Requirements tragen die Projekt-ID als SysML-Kurznamen, z. B. `requirement <'REQ-MIS-001'> acceptTransportOrder : RobotRequirement`. Der gemeinsame Typ `RobotRequirement` legt den Roboter als `subject` fest.
- Testfaelle tragen die Test-ID als Kurznamen und referenzieren Requirements im `objective`-Block: `verify loadBaseMap;`. Achtung: `verify requirement loadBaseMap;` wuerde eine neue, leere Anforderung anlegen statt die bestehende zu referenzieren.

Regel: SysML-Dateien werden erst dann erweitert, wenn die zugehoerigen Requirements, Funktionen und Entscheidungen in der LaTeX-Dokumentation nachvollziehbar beschrieben sind.
