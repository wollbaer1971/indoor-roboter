# SysML v2 Baseline A.1

Dieses Verzeichnis enthaelt ein konservatives SysML-v2-Startermodell zur System Definition Baseline A.1 des Mobile Material Robot.

Die Dateien sind bewusst klein und thematisch getrennt:

- `00_overview.sysml`: Ziel, Scope, Baseline, Annahmen und Nicht-Ziele
- `01_context.sysml`: Stakeholder, externe Systeme und Kontext
- `02_requirements.sysml`: initiale Systemanforderungen
- `03_structure.sysml`: einzige Definition des Roboters mit Subsystemen und Ports
- `04_interfaces.sysml`: Port-Typen und Schnittstellenregister
- `05_behavior.sysml`: Betriebsablaeufe, Aktivitaeten und Zustandsmodell
- `06_tests.sysml`: Verifikationsfaelle
- `07_ros2_mapping.sysml`: vorlaeufiges ROS2-Mapping als Architekturartefakt
- `traceability_matrix.md`: Review-Matrix von Need/Requirement bis Test

Hinweis: Die SysML-v2-Syntax ist als gut lesbarer Starter fuer die weitere Modellierung gedacht. Vor formaler Weiterverarbeitung sollte sie gegen die konkret verwendete Toolchain, zum Beispiel Syside, geprueft werden.
