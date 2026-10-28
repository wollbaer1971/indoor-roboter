# Stufe 2: reaktiver Fahrdemonstrator

Diese Variante erbt von `MobileRobotBase`, nicht vom vollstaendigen
Transportroboter. Der Transportroboter erbt dieselbe Basis und behaelt seine
Auftrags-, Transport-, Energie- und Benutzerfunktionen.

- `01_requirements.sysml`: fuenf Anforderungen und gemeinsame Kriterien.
- `02_behavior.sysml`: Geradeausfahrt, Zufallsdrehung, erneute Pruefung und Pause.
- `03_architecture.sysml`: Variante, Parameter, Simulationsumgebung und Views.
- `04_verification.sysml`: Testdefinitionen, Quellenbeziehungen und synthetische Beispiele.

Der Controller darf nur eine Vorwaerts-Abstandsbeobachtung verwenden;
Weltgeometrie und wahre Pose werden nicht als Navigator-Eingaben modelliert.
Die minimale Stufe beinhaltet keine autonome Zielnavigation oder Materialaufnahme.

Parameter sind im Modell ohne erfundene physikalische Werte deklariert.
Das JSON-Beispielszenario der lauffaehigen Python-Implementierung ist eine
editierbare Instanz fuer Demonstrationen, keine freigegebene Hardwareauslegung.

Start, Funktionstest, Wiederverwendung und Grenzen:
[docs/reactive-wander.md](../../docs/reactive-wander.md).

Den gesamten Ordner `sysml` laden. Die gemeinsame Zusammenstellung ist
`sysml/00_project.sysml`; die Standard-Views dieser Stufe heissen
`wanderArchitecture` und `wanderBehavior`.
