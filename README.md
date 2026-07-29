# indoor-roboter

Code- und Modell-Repository für den autonomen Indoor-Roboter aus der
Buchreihe **VOM CODE ZUM ROBOTER** (siehe separates Repo
[`vom-code-zum-roboter`](https://github.com/wollbaer1971/vom-code-zum-roboter)).

## Grundprinzip: Model First

Kein Code entsteht ohne vorheriges Modell. Das SysML-v2-Modell in
[`model/`](model/) definiert immer zuerst den Rahmen -- Stakeholder,
Anforderungen, Funktionen, Zustände, Struktur --, bevor Vibe-Coding
diesen Rahmen mit Code füllt.

Das [SysML-Lehrbuch](https://github.com/wollbaer1971/SysML_Lehrbuch)
ist die Referenz für Syntax und MBSE-Konzepte und steht bewusst
getrennt von diesem Repo. Hier wächst nur das konkrete Modell dieses
einen Roboters, Schritt für Schritt, Kapitel für Kapitel.

## Stakeholder

- **Entwickler** -- baut, wartet, testet und erweitert den Roboter.
- **Anwender** -- nutzt den Roboter, hält sich in seiner Nähe auf und
  verlässt sich auf sein sicheres Verhalten.

## Struktur

```
indoor-roboter/
├── model/            SysML-v2-Modell (wächst schrittweise)
├── microcontroller/  Echtzeit-/Sicherheitsebene (Band 1)
└── edge/
    └── ros2/
        ├── python/    indoor_roboter_base_py
        └── cpp/       indoor_roboter_base_cpp
```

Die Zuordnung von Funktionen zu konkreter Hardware (Mikrocontroller,
Sensoren, Antrieb) ist bewusst noch offen -- siehe
[`docs/decisions.md`](docs/decisions.md).

## Status

Frühe Modellierungsphase. Requirements und Stakeholder stehen,
Funktionen und Zustandsmodell folgen. Noch keine Hardwarebindung.
