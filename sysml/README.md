# SysML-v2-Gesamtmodell

Das aktuelle Modell wird als kompletter Ordner `sysml` geladen.

- `baseline_a1/`: Systemkontext, kanonische Architektur, Requirements,
  Schnittstellen, Verhalten, Verifikation und Simulationspruefstand.
- `baseline_b1/`: Use Cases und Candidate Requirements mit typisiertem
  Systemgegenstand und aufgeloesten Quellenbeziehungen.
- `mobile_material_robot_overview.sysml`: kompatible Namensfassade fuer den
  frueheren Strukturanker; keine separate Architektur mehr.

Kanonischer Robotertyp:
`MobileMaterialRobot_Structure_A1::MobileMaterialRobot`.

`baseline_a1/00_overview.sysml` stellt das Modell ueber oeffentliche Imports
zusammen. Imports machen Modellelemente sichtbar; sie ersetzen nicht das
Laden der Quelldateien durch das Werkzeug. Einzelne Dateien sollten nicht
isoliert geprueft werden. Fuer A.1 allein reicht der Ordner `baseline_a1`;
fuer A.1, B.1 und die Namensfassade muss der ganze Ordner `sysml` geladen sein.

Validierung und noch offene fachliche Entscheidungen:
[siehe Modellpruefung](../docs/model-validation.md).

## Gemeinsame Basis und Fahrdemonstrator

Die gemeinsame Zusammenstellung ist jetzt `00_project.sysml`.
`stage2_wander/` ergaenzt eine reaktive Variante ohne Materialtransport.
`MobileRobotBase` in der A.1-Struktur wird sowohl von dieser Variante als auch
von `MobileMaterialRobot` spezialisiert. Der bisherige A.1-Modellzugang bleibt
fuer das Transportmodell verfuegbar.

[Start und Traceability](../docs/reactive-wander.md).
