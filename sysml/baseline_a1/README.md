# SysML v2 Baseline A.1

## Verbindliche Struktur

Es gibt genau eine Definition des Robotertyps:
`MobileMaterialRobot_Structure_A1::MobileMaterialRobot` in `03_structure.sysml`.
Dieser Typ besitzt Subsysteme, Ports und das Betriebszustandsmodell.
Kontext, Verifikation und Simulationspruefstand beziehen sich darauf.
Ein `SystemContext` ist ein Kontextbaustein, keine View-Definition.
Die tatsaechlichen Sichten sind in `93_views.sysml` deklariert.

| Datei | Zweck |
| --- | --- |
| `00_overview.sysml` | Modellzusammenstellung mit oeffentlichen Imports, Scope und Entscheidungen |
| `01_context.sysml` | Externe Akteure, kanonische externe Typen, Kontext und Verbindungen |
| `02_requirements.sysml` | 26 Anforderungen mit typisiertem Subject; wiederverwendbare Raum-/Tuerkriterien |
| `03_structure.sysml` | Kanonischer Robotertyp mit Subsystemen, Ports und ausgefuehrten Funktionen |
| `04_interfaces.sysml` | Gemeinsame Datentypen, digitale Portinhalte und physische Vertragshalter |
| `05_behavior.sysml` | Nominaler Missionsablauf, Ereignisse und Betriebszustandsgeruest |
| `06_tests.sysml` | 23 geplante Testdefinitionen; TC_NAV_002 mit auswertbarer Kriterienlogik |
| `07_ros2_mapping.sysml` | Kandidaten fuer ROS2-Zuordnung, jetzt mit expliziten Abhaengigkeiten |
| `08_traceability.sysml` | Aufgeloeste Beziehungen zwischen Verantwortlichkeiten und Anforderungen |
| `09_decisions.sysml` | Entscheidungsprotokoll (DEC, ADR) als benannte Kommentare mit `about`-Bezug |
| `10_assumptions.sysml` | Annahmen A-001 bis A-011 als benannte Kommentare mit `about`-Bezug |
| `11_non_goals.sysml` | Nicht-Ziele NG-001 bis NG-010 der ersten Entwicklungsstufe |
| `12_functions.sysml` | Funktionen FUN-... als `action def`, Beitrag zu Requirements; Teilsysteme fuehren sie per `perform` aus |
| `90_simulation_testbench.sysml` | Pruefstand mit kanonischem Roboter, Welt, Adapter und Beobachter |
| `91_simulation_verification.sysml` | Bindung von TC_NAV_002 an den Pruefstandsroboter |
| `92_model_checks.sysml` | Ausschliesslich synthetische Testdaten fuer die Modell-Auswertung |
| `93_views.sysml` | Kontext-, Architektur-, Ablauf-, Zustands- und Simulationssichten |
| `traceability_matrix.md` | Review-Matrix; Status bezeichnet Planung, keine bestandenen Robotertests |

## Namens- und Grenzkonvention

Typen: UpperCamelCase. Verwendungen: lowerCamelCase.
Anforderungs-/Testnamen behalten `REQ_NAV_004` bzw. `TC_NAV_002`;
Dokumentations-IDs behalten `REQ-NAV-004` bzw. `TC-NAV-002`.
Der enum-Wert `orderAccepted` und der gleichnamige Betriebszustand stehen fuer
fachlich akzeptierte Auftraege. Der Name vermeidet eine Kollision mit dem
geerbten SysML-Mitglied `accepted`.

`WebApp` liegt ausserhalb der Systemgrenze. `UserInterfaceSystem` bezeichnet
den roboterseitigen Anschluss, nicht eine zweite Web-Oberflaeche.
Die frueheren Paralleltypen in Ueberblick, Kontext und Schnittstellen sind
entfernt. Der alte externe Name `MobileMaterialTransportRobot` ist ein Alias
auf den kanonischen Typ, `UserInterface` ein Alias auf `UserInterfaceSystem`.

## Lade- und Importbeziehungen

- Schnittstellen/Datentypen und Verhalten werden von der Struktur verwendet.
- Kontext verwendet Struktur und Schnittstellentypen.
- Anforderungen und Verifikation verwenden den kanonischen Robotertyp.
- Der Simulationspruefstand verwendet dieselbe Struktur.
- Die Testverwendung importiert Pruefstand und TC_NAV_002.
- Views verwenden vorhandene Elemente; sie erzeugen keine neuen Robotertypen.
- `00_overview.sysml` ist die Zusammenstellung, kein zweites Systemmodell.

Alle Ziele werden gemeinsam vom Validator aufgeloest. Ein Import ist kein
Dateipfad und fuehrt selbst keinen Simulator aus.

## Pruefung

Vom Repository-Hauptverzeichnis mit Python 3.10+ und einem Java-21+-JDK:

```powershell
python tools/validate_sysml.py --self-test --negative-tests
```

Beim ersten Lauf wird die unveraenderte offizielle Pilot Implementation
0.53.0 (Release 2025-10, SysML-v2.0-Linie) oeffentlich heruntergeladen,
per SHA-256 geprueft und ausserhalb des Repositorys gecacht.
Es ist keine kostenpflichtige Syside-Lizenz erforderlich.
Bei mehreren Java-Installationen `JAVA_HOME` setzen oder `--java` angeben.
Das Skript laedt Standardbibliothek und alle Quellen vor der Validierung.
Sowohl Modellfehler als auch Modellwarnungen lassen den Check scheitern.

Die 15 synthetischen Beispiele pruefen pass, fail und inconclusive fuer
Raumzahl, Flur, offene Tuer, autonome Fahrt und fehlende Nachweise sowie
manuelle Freigabe, Auftragserhalt und Bewegungsstopp in der Pausenphase.
Drei Negativtests entfernen in temporaeren Kopien ein Importziel bzw.
veraendern Feature und Subject-Typ. Sie muessen vom Validator erkannt werden.

Das Modell ist die fuehrende Quelle der Doku. Die Doc-Felder der Requirements
und Tests (deutsch) erzeugen mit `python tools/generate_docs.py` die Tabellen
in `tables/generated/` und die Matrix in `traceability_matrix.md`.
Der Validator lehnt veraltete oder von Hand geaenderte erzeugte Dateien und
handgeschriebene Requirement-/Testzeilen in den Kapiteln ab. Zwei weitere
Negativtests pruefen beides. Ablauf: [tables/README.md](../../tables/README.md).
Keine synthetische Eingabe ist ein beobachteter Simulatorlauf.

## Diagramme

In einer Syside-Installation mit verfuegbarer Visualisierung den gesamten
Modellordner oeffnen, speichern und die Views aus `93_views.sysml`
visualisieren, z.B. `systemContext`, `robotArchitecture`, `missionFlow`,
`operationStates` und `simulationTestBench`. Fuer Dateiverweise ist der
Modellordner massgebend, nicht nur die geoeffnete Datei.
Die Modell-Sichten sind Standard-SysML; Renderer/Lizenzumfang und Darstellung
koennen zwischen Werkzeugversionen abweichen.

## Fachlich offen

Zunaechst ausschliesslich Simulation, keine reale Hardware.
Simulator, Weltgeometrie, Masse, Reibung, Sensor-/Energiemodell und
physikalische Grenzen sind nicht ausgewaehlt. Physische Ports sind daher
explizite Vertragshalter; sie enthalten keine erfundenen Eigenschaften.
Geschwindigkeit etwa 0,5 m/s und Betriebsdauer etwa 2 h bleiben Zielwerte,
keine neu festgelegten harten Grenzwerte.

Bestaetigte Stoppregel: Ein betrieblicher Stopp pausiert den laufenden Auftrag.
ID, Start und Ziel bleiben erhalten. Der neue Befehl resumeMission verlangt
eine ausdrueckliche manuelle Freigabe. Ohne Freigabe bleibt der Auftrag pausiert.
Freigabe umgeht weder Sicherheit noch Navigation: erst orderAccepted, dann
nach RouteReady wieder driving.

Abbruch und Quittierung (DEC-015): Ein pausierter Auftrag kann mit
cancelMission abgebrochen werden (stopped). Aus stopped, completed, rejected,
blocked, chargingInterfaceReached, fault und safeState fuehrt nur die manuelle
Quittierung acknowledge zurueck nach ready; aus fault nur bei behobenem Fehler,
aus safeState nur bei safeToMove. Kein Zustand ist eine Sackgasse; der
Validator prueft das. Offen bleibt die vollstaendige Sicherheitsbehandlung,
insbesondere der Not-Halt (OI-SAFE-001).
Siehe [Pausenregel](../../docs/operational-pause.md).

Es gibt keinen erfolgreichen Fahr-, Nutzlast-, Sicherheits- oder Dauertest.
Siehe [Pruefprotokoll und Grenzen](../../docs/model-validation.md).
