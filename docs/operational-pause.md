# Bestaetigte Pausenregel, 28.10.2026

Die Nutzerin hat entschieden: Ein betrieblicher Stopp pausiert den laufenden
Transportauftrag. Fortsetzung nur nach manueller Freigabe.

## Modellierte Wirkung

- driving, orderAccepted und avoidingObstacle gehen auf OperationalStopRequested
  nach paused.
- OperationalStop gibt dasselbe TransportOrder-Objekt als pausedOrder weiter:
  Auftrags-ID, Start und Ziel werden weder geloescht noch durch einen neuen
  Auftrag ersetzt. MissionSystem behaelt activeOrder.
- Motion muss waehrend der Pausenphase gestoppt sein. Es wird keine numerische
  Stoppzeit oder Bremsstrecke erfunden.
- Der digitale Bedienbefehl resumeMission wird in der Steuerungsanbindung als
  ausdrueckliche manuelle Freigabe behandelt. Der interne ResumeRequested-Event
  enthaelt die bestaetigte Bedienabsicht und die vorhandenen Voraussetzungen.
- Die gemeinsame Berechnung ResumePermitted erlaubt Freigabe nur bei paused,
  manueller Freigabe, vorhandenem behaltenem Auftrag und safeToMove.
- Freigabe fuehrt nach orderAccepted. Erst RouteReady erlaubt driving. Damit
  erzwingt eine manuelle Freigabe keine Fahrt bei ungueltigem oder blockiertem
  Weg. SafetyStop und EmergencyStop werden dadurch nicht zurueckgesetzt.
- Die Einbindung in reale oder simulierte Bedien-/Sicherheitssoftware ist noch
  nicht implementiert. Ein wahrer Testwert ist kein Bedien- oder Sensornachweis.

## Verifikation

TC_UI_003 ist mit REQ_UI_002 und REQ_MIS_002 verbunden.
PauseResumeCriterion vergleicht beobachteten Auftragserhalt und Bewegungsstopp
mit der Pausenregel sowie beobachtete Resume-Annahme mit ResumePermitted.
Die Stopp-Beobachtung bezieht sich auf die Phase vor einer Resume-Annahme.

Acht ausschliesslich synthetische Fixtures ergaenzen die bisherigen sieben:

| Fall | Erwartung der Modell-Auswertung |
| --- | --- |
| Keine manuelle Freigabe, korrekt weiter pausiert | pass |
| Manuell freigegeben und Voraussetzungen erfuellt | pass |
| Resume ohne manuelle Freigabe angenommen | fail |
| Unsichere Resume-Anfrage korrekt abgelehnt | pass |
| Urspruenglicher Auftrag verloren | fail |
| Bewegung waehrend Pausenphase nicht gestoppt | fail |
| Resume ausserhalb paused korrekt abgelehnt | pass |
| Pausennachweise fehlen | inconclusive |

Kein Fall belegt einen physikalischen Stopp oder eine Simulatorfahrt.
Abbruch und Rueckkehr nach Blockade, Fehler und sicherem Zustand regelt
DEC-015 (manuelle Quittierung); der Not-Halt bleibt offen (OI-SAFE-001).

Pruefbefehl im Repository:
`python tools/validate_sysml.py --self-test --negative-tests`
