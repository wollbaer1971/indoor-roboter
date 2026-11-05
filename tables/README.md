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
Traceability 5, Entscheidungen Kapitel 3: 3, Anhang A: 4, ADR-Blatt: 2. Eine Spalte weglassen oder umsortieren geht nur im Generator.

## Was die Prüfung ablehnt

- Eine erzeugte Datei weicht vom Modell ab, z. B. weil sie in Overleaf geändert
  wurde. Lösung: Änderung im Modell machen, `generate_docs.py` ausführen.
- Eine Requirement- oder Testzeile steht von Hand in einem Kapitel.
- Eine erzeugte Tabelle wird nirgends mit `\modeltable` bzw. `\modeltext` eingebunden.
- Ein Kapitel nennt eine DEC- oder ADR-ID, die es im Modell nicht gibt.
- Die abgeleiteten Requirements der B.1-Use-Cases (Kapitel 12, Fließtext)
  passen nicht zu den Modellbeziehungen.

## Noch nicht aus dem Modell erzeugt

Teilsystemtabelle (Kapitel 8), ROS2-Tabellen (Kapitel 9), Annahmen und
die Use-Case-Beschreibungen sind noch Handarbeit.
