# Modellbereinigung und Pruefung, 28.10.2026

Aktueller Erweiterungsstand fuer Turtle und Browser: Code-Commit
`8bbca044e623141af643d2d6c0405781abec6374`, **22 SysML-Dateien, 0 Fehler,
0 Warnungen**. Alle 28 Python-Tests sowie die echte Chromium-Pruefung sind
erfolgreich. Quellen, genaue Nachweisgrenzen und CI-Links stehen in
[Browser-Simulation](browser-simulation.md#nachweise-dieser-erweiterung).
Die folgenden Abschnitte dokumentieren die vorherige Modellbereinigung.

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

- 21 SysML-Quelldateien werden als Gesamtmodell geladen.
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

Die vorherige A.1-Gesamtpruefung mit 16 Quelldateien, 15 synthetischen Auswertungen
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

## Erweiterung: reaktiver Fahrdemonstrator

Die aktuelle Gesamtmodell-Pruefung umfasst 21 Quellen, 15 bisherige
Pausen-/Transportkriterien und sechs neue reaktive Kriterien. Der Check
kontrolliert weiter genau eine Definition von MobileMaterialRobot; diese
spezialisiert nun MobileRobotBase. Fuer die neue Variante werden fuenf
Anforderungen und ihre Testverweise abgeglichen.

Python-Tests und die echte Turtle-Fensterpruefung laufen in einem separaten
GitHub-Workflow. Ein erfolgreicher Modellcheck belegt keine physikalische
Simulation oder reale Sensor-/Antriebsfunktion.

Die Erweiterungspruefung wurde im Code-Commit
`c81f424dd05d5a0446a4eb933907fdf64fa06ea4` erfolgreich ausgefuehrt:
[SysML](https://github.com/wollbaer1971/indoor-roboter/actions/runs/40778094531)
und [20 Python-/Turtle-Tests](https://github.com/wollbaer1971/indoor-roboter/actions/runs/40778094730).
Die anschliessende Dokumentation aendert diesen getesteten Code nicht.
