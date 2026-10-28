# SysML v2 Baseline A.1

Dieses Verzeichnis enthaelt ein konservatives SysML-v2-Startermodell zur System Definition Baseline A.1 des Mobile Material Robot.

Die Dateien sind bewusst klein und thematisch getrennt:

- `00_overview.sysml`: Ziel, Scope, Baseline, Annahmen und Nicht-Ziele
- `01_context.sysml`: Stakeholder, externe Systeme und Kontext
- `02_requirements.sysml`: initiale Systemanforderungen
- `03_structure.sysml`: Top-Level-Struktur und Subsysteme
- `04_interfaces.sysml`: externe Schnittstellen und Port-Skizzen
- `05_behavior.sysml`: Betriebsablaeufe, Aktivitaeten und Zustandsmodell
- `06_tests.sysml`: Verifikationsfaelle
- `07_ros2_mapping.sysml`: vorlaeufiges ROS2-Mapping als Architekturartefakt
- `traceability_matrix.md`: Review-Matrix von Need/Requirement bis Test

Hinweis: Die SysML-v2-Syntax ist als gut lesbarer Starter fuer die weitere Modellierung gedacht. Vor formaler Weiterverarbeitung sollte sie gegen die konkret verwendete Toolchain, zum Beispiel Syside, geprueft werden.

## Simulationspruefstand (Ergaenzung vom 28.10.2026)

Die erste Umsetzung erfolgt ausschliesslich in einer physikalischen Simulation
mit realistischer Darstellung. Simulator und konkrete physikalische Parameter
sind noch nicht festgelegt; dieses Modell startet keine Simulation.

- `90_simulation_testbench.sysml`: logischer Pruefstand mit dem vorhandenen
  `MobileMaterialRobot_Structure_A1::MobileMaterialRobot`, Welt,
  Steuerungsadapter und unabhaengigem Beobachter.
- `91_simulation_verification.sysml`: Verwendung des vorhandenen
  `MobileMaterialRobot_Verification_A1::TC_NAV_002` am Roboter des Pruefstands.

Die bisherigen Chat-/ZIP-Vorlagen mit `RobotStructure::MobileRobot` und
`RobotVerification::MultiRoomSimulationTest` passen nicht zu dieser Baseline.
Sie sind fuer diese Integration nicht erforderlich und sollten nicht
zusaetzlich als Parallelmodell geladen werden.

### Verknuepfung mit der vorhandenen Verifikation

`TC_NAV_002` erhaelt einen typisierten Testgegenstand. Die vorhandenen
Testdefinitionen verwenden nun `objective { verify ...; }` mit qualifizierten
Referenzen auf die bestehenden Anforderungen. Die vorherige Schreibweise
`verify requirement REQ_...;` deklarierte jeweils eine lokale Anforderung,
statt den beabsichtigten Bezug auf das Requirements-Paket herzustellen.

`TC_NAV_002` prueft REQ-NAV-004 und REQ-NAV-005. Ein erfolgreicher
Navigationstest allein belegt weder Traegersicherung noch reale Sicherheit.
REQ-TRN-001/002 bleiben eigenstaendige offene Verifikationsaufgaben.

### Modellpruefung

1. Gesamten Ordner `sysml/baseline_a1` in der SysML-Toolchain laden.
2. Alle qualifizierten Requirements-Verweise in `06_tests.sysml` aufloesen.
3. Von `schoolTransportTest` zu `TC_NAV_002` und von dessen Subject-Bindung
   zu `schoolTransportBench.robot` navigieren.
4. Negativfall in einer Arbeitskopie: `.robot` durch `.robotMissing`
   ersetzen. Erwartet: unaufgeloester Verweis. Danach rueckgaengig machen.
5. Negativfall: `.robot` durch `.world` ersetzen.
   Erwartet: Typunvertraeglichkeit zum Testgegenstand MobileMaterialRobot.
   Danach rueckgaengig machen.

Bei Syside mit freigeschalteter Visualisierung: Dateien speichern und
`SimulationTestBench` ueber `Syside: Visualize element` als verschachtelte
Sicht darstellen. Die vier Bestandteile muessen sichtbar sein.
Toolversion und Lizenzumfang sind vor Ort zu pruefen.

### Geplanter Simulationsfunktionstest

Welt und Roboter auf einen dokumentierten Anfangszustand zuruecksetzen.
Ein Ziel in Raum B aus Raum A ueber Flur und offene Tuer anfahren lassen,
ohne manuelle Fahrzeugsteuerung. Referenztrajektorie, Tuerdurchfahrt und
Zielankunft mit Konfigurationsversion und Laufkennung protokollieren.
Zieltoleranz und maximale Versuchsdauer vor dem Lauf festlegen; hier werden
keine neuen Grenzwerte als Systemanforderung vorgegeben.
Bei Zielverfehlung ist der Nachweis nicht erbracht; bei fehlenden Daten oder
fehlender Versuchskonfiguration bleibt die Bewertung unentschieden.
Fahrversuche und erfolgreiche Ergebnisse sind noch nicht nachgewiesen.

Pruefstatus: Die Integration wurde statisch auf vorhandene Paket-, Typ-,
Anforderungs- und Testnamen sowie unveraenderte Anforderungs-IDs abgeglichen.
Dies ersetzt keinen SysML-Parserlauf und keine semantische Toolpruefung.
Kein Simulatorlauf wurde ausgefuehrt.
