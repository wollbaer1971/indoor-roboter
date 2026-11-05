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
