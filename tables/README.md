# Tabellen aus dem Modell

Das SysML-Modell unter `sysml/` ist die führende Quelle. Requirement-, Test-,
MVP- und Traceability-Tabellen entstehen daraus. In Overleaf wird nur das
Aussehen angepasst.

Eine Faustregel: Steht in einer Zelle eine Requirement- oder Test-ID, kommt
die Zeile aus dem Modell.

## Wer ändert was?

| Was | Wo | Wer |
| --- | --- | --- |
| Text, Akzeptanz, Typ, Quelle, MVP-Status eines Requirements | `sysml/baseline_a1/02_requirements.sysml`, `sysml/baseline_b1/02_requirements.sysml` | Modell |
| Testname, erwartetes Ergebnis, verifizierte Requirements | `sysml/baseline_a1/06_tests.sysml` | Modell |
| Zuordnung Requirement → Systemelement | `sysml/baseline_a1/08_traceability.sysml` | Modell |
| Spaltenbreiten, Kopfzeilen, Schrift, Position der Tabelle | `chapters/*.tex`, `appendices/*.tex` | Overleaf |
| Fließtext, Abbildungen, Use-Case-Beschreibungen | `chapters/*.tex` | Overleaf |
| `tables/generated/*.tex` | nicht von Hand ändern | Generator |

## Ein Requirement ändern, Schritt für Schritt

1. Im Modell den Doc-Block des Requirements bearbeiten, z. B.:

   ```
   requirement REQ_NAV_001 {
     subject robot : MobileMaterialRobot;
     doc /*
     ID: REQ-NAV-001
     Typ: Funktional
     Gruppe: Initial
     Quelle: UC-003, FUN-NAV-001
     Text: Das System muss einen vorgegebenen Zielstandort autonom anfahren
       koennen.
     Akzeptanz: Ziel wird ohne manuelle Steuerung erreicht.
     MVP: MVP
     MVP-Begruendung: Autonomes Zielanfahren ist zentraler Funktionsnachweis.
     Schnittstelle: NavigationNode, /cmd_vel
     Status: Geplant; kein Ausfuehrungsnachweis
     */
   }
   ```

   Felder beginnen mit 4 Leerzeichen, Folgezeilen mit 6. Ohne `MVP:` taucht
   das Requirement nicht in der MVP-Tabelle auf. `Gruppe` ist `Initial` oder
   `Iteration A` und legt fest, in welcher der beiden Tabellen es steht.
   Einen Verweis „Siehe DEC-013.“ schreibt man nicht ins Requirement. Er
   entsteht aus der Entscheidung (siehe unten).

2. Tabellen neu erzeugen:

   ```
   python tools/generate_docs.py
   ```

3. Prüfen:

   ```
   python tools/validate_sysml.py --self-test --negative-tests
   ```

4. Modelländerung und erzeugte Dateien gemeinsam committen und pushen.
   Danach sieht Overleaf (über die GitHub-Synchronisierung) die neuen Zeilen.

## Eine Entscheidung festhalten, Schritt für Schritt

Entscheidungen stehen in `sysml/baseline_a1/09_decisions.sysml`, je ein
benannter Kommentar. Aus ihnen entstehen die Tabellen in Kapitel 3, Anhang A
und das Entscheidungsblatt in Kapitel 8.

1. Neue Entscheidung anlegen, z. B.:

   ```
   comment DEC_015 about REQ_PWR_001, EnergySystem /*
     ID: DEC-015
     Art: Baseline
     Entscheidung: Der Ladezustand wird in Prozent gemeldet.
     Status: Angenommen
     Datum: 12.11.2026
     Begruendung: Einheitliche Anzeige in der Web-App.
   */
   ```

   - `about` nennt die betroffenen Modellelemente. Jedes dort genannte
     Requirement bekommt in den Tabellen den Verweis „Siehe DEC-015.“
     Ein Tippfehler im Namen ist ein Modellfehler und wird gemeldet.
   - `Art: Architektur` für ADRs; dann statt `Entscheidung` ein kurzer `Titel`.
     Mit `Alternativen`, `Auswirkung` und `Risiko` entsteht zusätzlich ein
     Entscheidungsblatt (`tables/generated/adr_XXXX_details.tex`), das man
     im Kapitel mit `\modeltable{...}` einbindet.
   - Keine Zeile am Bindestrich umbrechen, wenn das Wort danach weitergeht
     (`Zielsystem-` / `Schnittstelle`). Der Generator meldet das.

2. `python tools/generate_docs.py` und den Validator ausführen, committen.

Jede Nennung von `DEC-nnn` oder `ADR-nnnn` im Repository muss eine Entscheidung
im Modell haben, sonst schlägt die Prüfung fehl.

## Annahmen

Annahmen stehen in `sysml/baseline_a1/10_assumptions.sysml`, genauso aufgebaut:

```
comment A_011 about REQ_PWR_002 /*
  ID: A-011
  Annahme: Die Ladestation ist waehrend des Unterrichts frei zugaenglich.
  Status: Vorlaeufig
*/
```

`Status` ist einer von `Vorlaeufig`, `Offen`, `Sicherheitsrelevant`,
`Ersetzt`; andere Werte lehnt der Generator ab. Eine Annahme, die sich als
Forderung an das System herausstellt, wird nicht gelöscht: Sie bekommt
`Status: Ersetzt` und `Ersetzt-durch: REQ-...`, so wie A-010. `about` nennt, was von
der Annahme abhängt. Fällt sie, ist das die Liste der zu prüfenden Elemente.
Jede Nennung von `A-nnn` im Repository muss eine Annahme im Modell haben.

## Nicht-Ziele

`sysml/baseline_a1/11_non_goals.sysml`, je Nicht-Ziel ein Kommentar mit `ID`
und `Nicht-Ziel`. Daraus entsteht die Aufzählung in Kapitel 3
(`\modeltext{non_goals_a1}` innerhalb der `itemize`-Umgebung). Die
Reihenfolge im Modell ist die Reihenfolge im Dokument; Komma und Schlusspunkt
setzt der Generator. Eine von Hand ergänzte `\item`-Zeile in dieser Liste
lehnt die Prüfung ab.

## Funktionen

`sysml/baseline_a1/12_functions.sysml`, je Funktion eine `action def` mit
`ID`, `Name`, `Zweck` und optional `HW-Anteil`, `SW-Anteil`, `Status` (alle
drei oder keines). Welches Teilsystem eine Funktion ausführt, steht als
`perform action ... : FUN_...;` im Teilsystem in `03_structure.sysml`. Zu
welchen Requirements sie beiträgt, steht als `dependency` am Ende der
Funktionsdatei. Daraus entstehen die Funktionstabelle (Kapitel 8), die
HW/SW-Allokation (Kapitel 9) und die FUN-IDs in der Quelle-Spalte der
Traceability. FUN-IDs schreibt man deshalb nicht mehr ins `Quelle`-Feld.
Eine Funktion ohne ausführendes Teilsystem oder ohne Requirement lehnt der
Generator ab.

## Zustandsdiagramm

Die Abbildung „Betriebszustände“ in Kapitel 8 entsteht aus
`RobotOperationState` in `sysml/baseline_a1/05_behavior.sysml`
(`tables/generated/state_machine_a1.tex`). Zustände, Pfeile, Ereignisse und
Bedingungen kommen aus dem Modell. Die Sicherheitsübergänge aus DEC-016 sind
in einem Hinweiskasten zusammengefasst; der Generator prüft vorher, dass sie
vollständig sind.

Das Aussehen steht in `figures/tikz/state_machine_layout.tex` und wird in
Overleaf gepflegt:

- `\coordinate (pos-<Zustand>) at (x, y);` setzt die Position eines Zustands.
  Jeder Zustand braucht genau eine; ein neuer Zustand im Modell ohne
  Koordinate lässt den Generator abbrechen.
- `e-<von>-<nach>/.style={...}` formt einen einzelnen Pfeil, z. B.
  `bend left=40` oder `out=60, in=-120` für einen Bogen und
  `every node/.append style={pos=0.3}` für die Lage der Beschriftung.
- Stile `state`, `terminal`, `transition`, `event`, `note` für Kästen,
  Pfeile, Beschriftungen und den Hinweiskasten.

## Teilsysteme und ROS2

- Teilsystem: Felder `Verantwortung` und `MVP-Status` im `part def` in
  `03_structure.sysml`. In der Tabelle erscheint jedes Teilsystem, das
  `MobileMaterialRobot` als Part enthält, in dieser Reihenfolge.
- ROS2-Node: `part def ...Node` in `07_ros2_mapping.sysml` mit `Node`,
  `Kurzname`, `Schnittstellenidee`, `Publiziert`, `Abonniert`,
  `Anforderungen`, optional `Rolle` und `Ergaenzung`. Das SysML-Element
  kommt aus den `dependency`-Zeilen am Dateiende.
- Topic: `item def ...Topic` mit `Name`, `Typ`, `Zweck`. Die Richtung wird
  aus `Publiziert`/`Abonniert` der Nodes berechnet, nicht eingetragen.
  Ein Topic ohne Definition oder ohne publizierenden Node lehnt die Prüfung ab.

## Das Aussehen in Overleaf ändern

Jede modellgebundene Tabelle sieht im Kapitel so aus:

```latex
\begin{longtable}{L{0.15\textwidth} L{0.16\textwidth} L{0.36\textwidth} L{0.18\textwidth}}
\toprule
ID & Typ & Requirement & Akzeptanzidee \\
\midrule
\modeltable{requirements_a1_initial}
\bottomrule
\end{longtable}
```

Alles außer der Zeile `\modeltable{...}` ist Layout und darf frei geändert
werden: Spaltenbreiten, Kopfzeile, `\small`, `\caption`, Umgebung.
Nur die Spaltenzahl muss bleiben: Requirements 4, MVP 3, Tests 4,
Traceability 5, Entscheidungen Kapitel 3: 3, Anhang A: 4, ADR-Blatt: 2,
Teilsysteme 3, ROS2-Mapping 4, ROS2-Topics 4, Annahmen 3, Funktionen 4,
Allokation 4. Eine Spalte weglassen oder umsortieren geht nur im Generator.

## Was die Prüfung ablehnt

- Eine erzeugte Datei weicht vom Modell ab, z. B. weil sie in Overleaf geändert
  wurde. Lösung: Änderung im Modell machen, `generate_docs.py` ausführen.
- Eine Requirement- oder Testzeile steht von Hand in einem Kapitel.
- Eine erzeugte Tabelle wird nirgends mit `\modeltable` bzw. `\modeltext` eingebunden.
- Ein Kapitel nennt eine DEC- oder ADR-ID, die es im Modell nicht gibt.
- Die abgeleiteten Requirements der B.1-Use-Cases (Kapitel 12, Fließtext)
  passen nicht zu den Modellbeziehungen.

## Noch nicht aus dem Modell erzeugt

Interne Schnittstellen (Kapitel 8) und die Use-Case-Beschreibungen sind
noch Handarbeit.
