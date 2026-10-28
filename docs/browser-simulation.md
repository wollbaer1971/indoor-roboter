# Browseransicht am gemeinsamen Simulationskern

## Ziel und Anschluss

Ein neuer Baustein: den vorhandenen reaktiven Fahrdemonstrator im Browser
anzeigen und bedienen. Der vorhandene Python-Kern bleibt fuer Wahrnehmung,
Navigation, Zufallswinkel und Bewegung verantwortlich. Turtle bleibt nutzbar.
Die Browsersteuerung ist ein Adapter ausserhalb des Roboters, noch keine
Web-App fuer Transportauftraege. Kein Materialtransport, keine reale Hardware.

## 1. Stand laden und lokal starten

Voraussetzung: Python 3.10+ und ein Browser mit JavaScript/Canvas.
Tk, Node.js, ROS 2 und pip-Pakete sind fuer den Betrieb nicht erforderlich.
Die Erweiterung liegt im Branch `codex/stage2-reactive-wander` / PR #2.
Im Repository-Hauptverzeichnis:

```powershell
git fetch origin
git switch codex/stage2-reactive-wander
py -3 -m robot_demo.web_server
```

Unter Linux/macOS entsprechend `python3 -m robot_demo.web_server`.
Danach im Browser **http://127.0.0.1:8765** oeffnen. Die Seite wird nicht
automatisch geoeffnet. Bei belegtem Port:

```powershell
py -3 -m robot_demo.web_server --port 8766
```

Dann http://127.0.0.1:8766 verwenden. Beenden im Terminal mit Strg+C.
Die HTML-Datei nicht direkt als file:// oeffnen: Sie braucht den lokalen Server.
Der Server bindet ausschliesslich an 127.0.0.1. Dies ist kein Internet-Hosting
und noch kein Zugriff vom Tablet/Smartphone auf einen anderen Rechner.

## 2. Bewegung beobachten und manuell freigeben

1. Die Ansicht startet pausiert. **Start / manuell fortsetzen** anklicken.
   Der Roboter faehrt geradeaus, stoppt vor erkanntem Hindernis und dreht.
   Bei weiterhin blockiertem Weg waehlt er nach der Drehung erneut einen Winkel.
2. **Pausieren** haelt Pose, Operation, Zufallszustand und Restdrehwinkel fest.
   Nur **Start / manuell fortsetzen** gibt die Fortsetzung frei.
3. **Zuruecksetzen** laedt das gewaehlte JSON-Szenario mit demselben Seed neu
   und bleibt pausiert. Reset ist ein neuer Lauf, keine Fortsetzung.

Rasterweite 1 m. Blau ist die Spur, Gruen Geradeausfahrt, Gelb Drehung,
Grau Pause. Die ideale Sensoranzeige wird bei erkanntem Hindernis rot.
Die Spur zeigt die letzten maximal 4000 bewegten Positionen.

Der Server ist der einzige Taktgeber. Er berechnet pro Takt einen festen
Simulationszeitschritt aus scenario.json; der Browser fragt etwa alle 100 ms
Zustand ab und integriert keine Bewegung. Langsame Rechner koennen den Lauf
verlangsamen; dies ist keine Echtzeitgarantie. Mehrere Tabs teilen denselben
Lauf und beschleunigen ihn nicht.

Ohne erfolgreichen Statusabruf pausiert der Server beim ersten Takt nach
2 Sekunden. Wiederverbindung setzt ihn nicht automatisch fort. Ein weiterer
offener Tab kann den Statusabruf aufrechterhalten. Das Timeout ist eine
Bedienentscheidung des Simulationsadapters, kein Sicherheitssystem.
Simulationsfehler werden angezeigt, pausieren den Lauf und erfordern Reset.

Parameter/Seed stammen unveraendert aus dem vorhandenen Beispielszenario:

```powershell
py -3 -m robot_demo.web_server --seed 12 --scenario robot_demo/scenario.json
```

Alle Zahlen dort sind editierbare Demonstrationswerte, keine freigegebenen
Geometrien oder Hardwareparameter. Die bisherige 2D-Kinematik enthaelt keine
Traegheit, Reibung, Motor- oder Kontaktphysik. Physikalische und realistische
Simulation bleibt ein spaeterer Ausbauschritt.

## 3. Reproduzierbaren Funktionstest ausfuehren

Voraussetzungen: unveraendertes Beispielszenario, Seed 7, nur ein Browser-Tab.
Eingaben: Start, Pause, manuelle Fortsetzung, Reset, Verbindungsunterbrechung.

| Schritt | Erwartetes Ergebnis |
| --- | --- |
| Mit `--seed 7` starten und Seite oeffnen | Pausiert, Zeit 0 s, Position 1,00 / 1,00 m |
| Start anklicken | Geradeausfahrt, Zeit und Weg wachsen |
| Erste Hindernisreaktion abwarten | Translation endet, Drehung beginnt; keine Hindernisdurchdringung |
| Waehrend Drehung pausieren; 1 s warten | Pose, Zeit, Restdrehwinkel und Drehungszahl bleiben gleich |
| Manuell fortsetzen | Restdrehung wird erhalten und fortgesetzt |
| Alle Simulationstabs schliessen; mindestens 3 s warten; erneut oeffnen | Pausiert; kein automatischer Wiederanlauf |
| Reset | Startpose, Zeit 0, Seed 7, geloeschte Spur; weiter pausiert |

Negativfall am laufenden Server (zweites Terminal, plattformunabhaengig):

```python
import json, urllib.request, urllib.error
request = urllib.request.Request(
    'http://127.0.0.1:8765/api/command',
    data=json.dumps({'command': 'drive'}).encode(),
    headers={'Content-Type': 'application/json'}, method='POST')
try:
    urllib.request.urlopen(request)
except urllib.error.HTTPError as error:
    print(error.code, error.read().decode())
```

Erwartet: HTTP 400 / unbekannter Befehl. Ein pausierter Lauf bleibt pausiert;
der ungueltige Befehl veraendert weder Pose noch Auftrag/Fahrbetrieb.

Automatisierte Python-Pruefung:

```powershell
py -3 -m unittest discover -s tests -v
```

`tests/test_web_server.py` prueft acht Faelle einschliesslich echter HTTP-Requests.
Der gleiche Seed erzeugt ueber 1000 Schritte exakt dieselben Posen und
Drehungszahlen wie der unveraenderte Kern ohne Webadapter. Der Test setzt
eine kontrollierte Uhr ein; HTTP-Zustandsabfragen duerfen keinen Schritt ausloesen.
Zusaetzlich: Pause in Drehung, Verbindungs-Timeout/Wiederverbindung, Reset,
Sensorfehler und abgewiesene Requests. Ohne Display wird nur der bisherige
Turtle-Test uebersprungen.

`tools/test_web_browser.cjs` prueft mit echtem Chromium Canvas-Pixel, erste
Drehung, Pause, manuelle Fortsetzung, Verbindungsabbruch/Wiederverbindung,
Reset und mobiles Layout. Playwright 1.56.0 ist nur eine Testabhaengigkeit.
Die GitHub-Action installiert es; fuer den Benutzerstart ist es nicht notwendig.
Screenshots liegen als CI-Artefakt `browser-screenshots` vor, wenn der Test laeuft.

## Modellbeziehungen und JSON-Vertrag

Die neue Datei `sysml/stage2_wander/05_browser.sysml` wird ueber
`sysml/00_project.sysml` importiert. Sie importiert die vorhandene Architektur,
ScalarValues, VerificationCases und StandardViewDefinitions.

`SimulationVisualization` ist die gemeinsame Anzeige-Abstraktion.
`TurtleVisualization` und `BrowserVisualization` spezialisieren sie.
`BrowserSimulation` spezialisiert `ReactiveSimulation` und behaelt dessen
`ReactiveWanderRobot`, `MobileRobotBase` und Welt. Nur der Anzeigeadapter
wird redefiniert. Es entsteht kein zweites Robotermodell.

`BrowserControlPort` sendet Bedienbefehle und empfaengt Snapshots; der
Serveranschluss ist konjugiert (`~BrowserControlPort`).

| Modellfeld | JSON / Implementierung |
| --- | --- |
| SimulationSnapshot.x_m, y_m, heading_rad | pose.x, pose.y, pose.heading; Meter / Radiant |
| SimulationSnapshot.time_s, modeName | time_s, mode; forward/turning/paused |
| SimulationSnapshot.remainingTurn_rad, operationId | remaining_turn_rad, operation_id |
| SimulationControlCommand.kind | POST /api/command: command=pause/resume/reset |
| SimulationControlCommand.manualRelease | resume-Knopf -> WebSession.command -> Simulation.resume(manual_release=True); kein impliziter Freigabewert aus GET |

Der Snapshot-Typ beschreibt bewusst den Engineering-Kern der Anzeige.
Der HTTP-Snapshot ergaenzt Weltrechtecke, Parameter, Spur, Seed, Zaehler,
Fehlermeldung und Laufgeneration. Er ist kein Sensorinterface des Navigators.
Der Navigator erhaelt weiterhin ausschliesslich RangeReading und Zeitschritt.

GET /api/state liefert JSON; POST /api/command erwartet genau
`{"command":"pause"}`, `{"command":"resume"}` oder `{"command":"reset"}`
mit Content-Type application/json. Fehler: 400 ungueltiger Inhalt/Befehl,
403 fremder Host/Origin, 404 unbekannter Pfad, 415 falscher Inhaltstyp.
Nur fest freigegebene Webdateien werden ausgeliefert; kein Verzeichnisserver.

Traceability:

| Stufe | Bezug |
| --- | --- |
| Need | NEED_WEB_001: Lehre durch Beobachtung und Bedienung im Browser |
| Requirement | REQ_WEB_001: gemeinsamer Kern, Anzeige aus Snapshots, nur manuelle Fortsetzung |
| Systemelement | BrowserSimulation / BrowserVisualization / BrowserControlPort |
| Implementierung | robot_demo/web_server.py und robot_demo/web/ |
| VerificationCase | TC_WEB_001; verweist auf Python- und Chromium-Tests |
| Evidence | ausgefuehrte Tests mit zugehoerigem Commit und CI-Lauf; siehe unten |

Die `dependency`-Beziehungen dokumentieren Traceability, keine bereits
nachgewiesene Erfuellung. TC_WEB_001 enthaelt deshalb keinen erfundenen
Pass-Vermerk. Das formale BrowserAdapterCriterion verlangt explizit vorhandene
Beobachtungen; es wird durch die Diagrammanzeige nicht automatisch ausgefuehrt.

## Syntax, Semantik, Darstellung und Nachweisgrenzen

Gesamten Quellordner `sysml` mit Standardbibliothek laden; nicht nur die
neue Datei. Reproduzierbare Parser-/Semantikpruefung wie im bisherigen Projekt:

```powershell
py -3 tools/validate_sysml.py --self-test --negative-tests
```

Werkzeug bleibt die offizielle SysML Pilot Implementation 0.53.0 / Release
2025-10, mit gepruefter Downloadpruefsumme und Java 21+. Keine neue
Werkzeugversion oder Syside-Lizenz ist vorausgesetzt. Syside-Installation
ist weiterhin unbestaetigt. Die deklarierte Sicht heisst `browserArchitecture`;
zusaetzlich bleiben `wanderArchitecture` und `wanderBehavior` erhalten.

Klar bezeichnete Diagrammalternative: offizieller SysML-Jupyter-Kernel.
Er benoetigt zusaetzlich Jupyter und fuer die Diagrammausgabe Graphviz;
eine entsprechende lokale Installation ist nicht bestaetigt.
`jupyter kernelspec list` muss den Kernel `sysml` zeigen. In einem neuen
Notebook diesen Kernel verwenden. Um die bestehenden Paketzyklen nicht
durch einzelnes Laden von Dateien aufzubrechen, den gesamten Projektquelltext
in einer gemeinsamen ersten SysML-Codezelle ausfuehren. Der Text kann mit
diesem Python-Snippet aus den massgebenden Dateien zusammengestellt werden:

```python
from pathlib import Path
sources = sorted(Path('sysml').rglob('*.sysml'))
Path('.cache').mkdir(exist_ok=True)
Path('.cache/model_for_notebook.sysml').write_text(
    '\n\n'.join(p.read_text(encoding='utf-8') for p in sources), encoding='utf-8')
```

Den Inhalt der erzeugten Datei in die erste Notebookzelle kopieren und
ausfuehren. Danach in einer zweiten Zelle:

```text
%viz MobileRobot_Wander_Browser::BrowserSimulation
```

Dies fordert eine Typdarstellung aus demselben Modell an. `%viz --help` zeigt
die Darstellungsoptionen des installierten Kernels. Die Befehle wurden im
offiziellen Quellcode des Releases 2025-10 geprueft; der Notebook-/Diagrammlauf
wurde hier nicht ausgefuehrt. Die Validierungs-CI erzeugt keine Diagramme.
Die Canvas-Szene ist die Laufzeitansicht, kein automatisch aus SysML erzeugtes
Architekturdiagramm.

Pruefebenen getrennt lesen:

- Parser/semantische Modellpruefung: Referenzen, Typen, Imports, Verifikationsbezug.
- Kriterienauswertung: bestehende synthetische Modellbeispiele; kein Simulatorlauf.
- Python-/HTTP-Tests: Implementierungslogik, Schnittstelle, gleicher Fahrkern.
- Chromium: tatsaechliche Browserdarstellung und Bedienung.
- Simulation: berechnete 2D-kinematische Bewegung mit Beispielparametern.
- Realer Robotertest: nicht durchgefuehrt und in dieser Stufe nicht vorgesehen.

## Nachweise dieser Erweiterung

Gepruefter Code-Commit: **8bbca044e623141af643d2d6c0405781abec6374**.

- [Python, HTTP und echtes Turtle-Fenster](https://github.com/wollbaer1971/indoor-roboter/actions/runs/40781959216): alle 28 Python-Tests bestanden, ohne Skip.
- Derselbe Lauf: echter Chromium-Test erfolgreich, einschliesslich Canvas-Pixel,
  erster Drehung, Pause waehrend Drehung, manueller Fortsetzung, Timeout,
  Wiederverbindung, Reset und mobilem Layout. Keine JavaScript-Laufzeitfehler.
  Screenshots: CI-Artefakt browser-screenshots. Kein manueller Sichttest behauptet.
- [Offizieller SysML-Parser und semantische Validierung](https://github.com/wollbaer1971/indoor-roboter/actions/runs/40781959207): 22 Quelldateien,
  **0 Fehler, 0 Warnungen**; 15 bisherige und 6 Wander-Kriterienbeispiele
  mit erwarteten Ergebnissen. Alle drei absichtlich beschaedigten Modellkopien
  wurden erkannt. Das BrowserAdapterCriterion wurde nicht separat ausgewertet;
  der Browsernachweis stammt aus den ausgefuehrten Implementierungstests.
- Lokal: 27 Python-Tests bestanden, ein Turtle-Test mangels Display uebersprungen;
  JavaScript mit node --check geprueft. Der lokale Browserdownload schlug fehl.

Die nachfolgende Aenderung dieser Anleitung betrifft nur Dokumentation.
Simulationsnachweise bleiben von realen Fahr-/Sicherheitsnachweisen getrennt.

## Entscheidungen und offene Punkte

- Lokaler HTTP-Adapter und Canvas; keine zusaetzlichen Laufzeitpakete.
- Start/Reset pausiert, explizite manuelle Fortsetzung; gemeinsame Session fuer alle Tabs.
- Keine Robotiklogik im Browser. Bestehender Transportumfang bleibt im Gesamtmodell.
- Internet-/LAN-Betrieb, Benutzerkonten, Transportauftraege und 3D/Physik sind offen.
- Die Parameter des Beispiels sind weiterhin keine Hardwareauslegung.

Primärquellen:
[Python HTTP-Server](https://docs.python.org/3/library/http.server.html),
[Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API),
[SysML-v2-Release](https://github.com/Systems-Modeling/SysML-v2-Release),
[offizielles Beispiel zur Port-Konjugation](https://github.com/Systems-Modeling/SysML-v2-Release/blob/master/sysml/src/training/10.%20Ports/Port%20Conjugation%20Example.sysml),
[Jupyter-Kernel und Graphviz-Konfiguration](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/blob/2025-10/org.omg.sysml.jupyter.kernel/README.adoc),
[viz-Befehl im offiziellen Release](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/blob/2025-10/org.omg.sysml.jupyter.kernel/src/main/java/org/omg/sysml/jupyter/kernel/magic/Viz.java),
[Playwright](https://playwright.dev/docs/intro).

Python http.server ist fuer den lokalen Demonstrator vorgesehen; die offizielle
Dokumentation empfiehlt es nicht als Produktionsserver.
