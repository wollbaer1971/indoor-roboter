# Architekturentscheidungen (ADRs)

Dieses Dokument hält Entscheidungen fest, die das Modell oder die
Struktur dieses Repos betreffen -- mit Begründung, nicht nur mit
Ergebnis. Neue Einträge werden oben angefügt.

## Format

```
## ADR-NNN: <Titel>
Datum: YYYY-MM-DD
Status: vorgeschlagen | entschieden | verworfen

### Kontext
Was war die Ausgangslage, welche Frage stand offen?

### Entscheidung
Was wurde entschieden?

### Begründung
Warum diese Option und nicht eine andere?

### Konsequenzen
Was folgt daraus -- auch unangenehme Nebenwirkungen?
```

---

## ADR-001: Zwei getrennte Repos statt Monorepo
Datum: 2026-07-27
Status: entschieden

### Kontext
Die Buchreihe VOM CODE ZUM ROBOTER braucht sowohl LaTeX-Buchquellen
als auch ausführbaren Robotercode. Beides in einem Repo zu halten
(Monorepo) stand zur Debatte.

### Entscheidung
Zwei getrennte Repos: `vom-code-zum-roboter` (Bücher, LaTeX) und
`indoor-roboter` (Modell, Code).

### Begründung
Bücher und Code haben unterschiedliche Versionierungs- und
Review-Zyklen. Ein Monorepo hätte beides künstlich gekoppelt.

### Konsequenzen
Missionstexte in den Büchern müssen Codebeispiele aus
`indoor-roboter` referenzieren, nicht duplizieren.

---

## ADR-002: Model First -- SysML-v2-Modell vor jedem Code
Datum: 2026-07-29
Status: entschieden

### Kontext
Bisheriger Code (Band 1: Arduino-Sketches, `sensor_bridge.py`,
`motor_bridge.py`) entstand ohne vorheriges Modell. Das erschwert
Nachvollziehbarkeit und lässt Python- und C++-Implementierungen
(Band 2) potenziell auseinanderdriften.

### Entscheidung
Für alle neuen Programmieraufgaben gilt: Das SysML-v2-Modell in
`model/` definiert immer zuerst den Rahmen (Anforderung -> Funktion
-> Systemteil -> Schnittstelle). Vibe-Coding erstellt danach den
Code, der diesen Rahmen füllt.

### Begründung
Traceability von der Anforderung bis zum Code; verhindert, dass
Python- und C++-Implementierung unterschiedliche, nicht modellierte
Annahmen treffen.

### Konsequenzen
Band 1 (bereits als Probedruck vorhanden) folgt diesem Prinzip noch
nicht durchgängig -- wird nicht rückwirkend nachmodelliert (siehe
ADR-003), dient aber als Vorlage für Teil 0 der Neufassung.

---

## ADR-003: Band 1 wird umstrukturiert, nicht rückwirkend modelliert
Datum: 2026-07-29
Status: entschieden

### Kontext
Band 1 "Die Robotik-Werkstatt" existiert nur als Probedruck, ist also
änderbar. Die Frage: Wird der bestehende Robotercode (Kap. 21-25)
nachträglich in SysML modelliert, oder bleibt er wie er ist?

### Entscheidung
Band 1 bekommt einen neuen Teil 0 (Stakeholder, Requirements,
Funktionen, State Machine) *vor* den Werkzeug-Kapiteln. ROS2 entfällt
komplett aus Band 1 und wandert zu Band 2, M00. Der bestehende
Mikrocontroller-Code (Kap. 21-25) bleibt technisch bestehen, wird aber
in Kap. 25 an das neue Modell rückgebunden.

### Begründung
Band 1 bleibt Werkzeug-Fundament (Linux, Docker, Git, VS Code) plus
Mikrocontroller-Ebene. Die Recheneinheit/ROS2-Ebene gehört vollständig
zu Band 2 -- danach soll keine Werkzeug-Einrichtung mehr nötig sein.

### Konsequenzen
Kapitel 16-20 (Docker) brauchen ein neues Beispiel statt `ros:jazzy`.
Kapitel 21-22 (Pub-Sub) verweisen im Transfer-Absatz auf Band 2 statt
auf ROS2 direkt. Kapitel 26-29 entfallen ersatzlos aus Band 1.

### Offene Frage
Konkrete Hardwarebindung der Requirements (z. B. Absturzsicherung --
welcher Sensor?) ist bewusst noch nicht entschieden, um sich nicht
vorschnell an einen Hersteller zu binden. Siehe `model/03_structure.sysml`
(folgt).
