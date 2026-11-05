# Mobile Robot Overleaf Documentation

Dieses Verzeichnis enthaelt eine modulare LaTeX-Projektstruktur fuer die MBSE-gestuetzte Entwicklung eines mobilen Materialtransportroboters.

## Einstieg

In Overleaf kann der gesamte Ordner als ZIP hochgeladen werden. Hauptdatei:

- `main.tex`

## Struktur

- `chapters/`: Hauptkapitel der Dokumentation
- `appendices/`: Entscheidungslog, offene Punkte, Traceability
- `bibliography/`: BibTeX-Dateien
- `config/`: LaTeX-Praeambel und globale Einstellungen
- `sysml/`: begleitende SysML-v2-Artefakte
- `decisions/`: spaetere Einzel-ADRs
- `figures/`: Abbildungen
- `figures/tikz/`: TikZ-Quellen fuer Entwicklungsablauf, Systemkontext, Navigationslogik, Betriebsfaelle und Traceability
- `tables/generated/`: aus dem Modell erzeugte Tabellenzeilen (nicht von Hand aendern)
- `sysml/baseline_a1/`: zugehoerige SysML-v2-Starterdateien zur System Definition Baseline A.1

## Modell fuehrt

Requirement-, Test-, MVP- und Traceability-Tabellen werden aus dem SysML-Modell
erzeugt (`python tools/generate_docs.py`). In Overleaf wird nur ihr Aussehen
angepasst. Ablauf und Regeln: [tables/README.md](tables/README.md).

## Pflegeprinzip

Jeder technische Entwicklungsschritt wird mit Requirements, Alternativen, Entscheidung, Begruendung, Auswirkungen auf MVP und Zielsystem, offenen Punkten und Verifikationsidee dokumentiert.

## Aktueller Stand

Stand Version 0.3 enthaelt die konsolidierte `System Definition Baseline A.1`, das neue Kapitel `Iteration B: Use Cases und System Requirements`, ein Glossar, TikZ-Diagramme und aktualisierte Register fuer Entscheidungen, offene Punkte, Betriebsfaelle, Requirements, MVP-Scope und Traceability.

Der SysML-v2-Verzeichnisbaum unter `sysml/baseline_a1/` enthaelt Ueberblick, Kontext, Requirements, Struktur, Schnittstellen, Verhalten, Tests, ROS2-Mapping und eine Traceability-Matrix als Startermodell fuer die weitere MBSE-Arbeit.

Der SysML-v2-Verzeichnisbaum unter `sysml/baseline_b1/` enthaelt die Use-Case-Struktur, Candidate Requirements und Traceability fuer Iteration B.
