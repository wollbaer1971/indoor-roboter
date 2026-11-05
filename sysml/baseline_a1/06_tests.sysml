package MobileMaterialRobot_Verification_A1 {
  private import ScalarValues::*;
  private import VerificationCases::*;
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  doc /*
  Verifikationsfaelle der Baseline A.1. Alle sind geplant; keiner wurde an
  einem realen Roboter oder in einem dokumentierten Simulationslauf
  ausgefuehrt. Es werden weder Ergebnisse noch Nachweise behauptet.
  Die Doc-Felder (Name, Erwartet, ...) sind Quelle der LaTeX-Testtabelle.
  */

  verification def TC_MAP_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-MAP-001
    Name: Grundkarte laden
    Vorbedingung: Grundkartendatei ist vorhanden.
    Ablauf: Grundkarte laden.
    Erwartet: Karte ist verfuegbar und wird von Lokalisierung und Navigation
      referenziert.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_001;
    }
  }

  verification def TC_MAP_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-MAP-002
    Name: Karteninformation trennen
    Ablauf: Temporaeres Hindernis in die lokale Umgebung einbringen.
    Erwartet: Temporaere Hindernisse werden lokal beruecksichtigt, ohne die
      Langzeitkarte automatisch zu veraendern.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_003;
    }
  }

  verification def TC_LOC_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-LOC-001
    Name: Lokalisierung in Karte
    Ablauf: Roboterpose in bekannter Karte schaetzen.
    Erwartet: Roboterpose wird innerhalb einer noch festzulegenden Toleranz
      geschaetzt.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_LOC_001;
    }
  }

  verification def TC_NAV_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-NAV-001
    Name: Autonomes Zielanfahren
    Ablauf: Mission zu einem bekannten Ziel starten.
    Erwartet: Roboter erreicht das Ziel ohne manuelle Fahrzeugsteuerung.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_001;
    }
  }

  verification def TC_NAV_002 {
    subject testRobot : MobileMaterialRobot;
    in attribute evidenceComplete : Boolean default = false;
    in attribute roomsVisited : Integer;
    in attribute corridorTraversed : Boolean;
    in attribute openDoorPassed : Boolean;
    in attribute autonomousDriving : Boolean;
    return verdict : VerdictKind = if evidenceComplete ?
      PassIf(
        MobileMaterialRobot_Requirements_A1::MultiRoomCriterion(
          roomsVisited = roomsVisited,
          corridorTraversed = corridorTraversed)
        and MobileMaterialRobot_Requirements_A1::OpenDoorCriterion(
          openDoorPassed = openDoorPassed,
          autonomousDriving = autonomousDriving))
      else VerdictKind::inconclusive;
    doc /*
    ID: TC-NAV-002
    Name: Raeume-Flur-Tuer-Test
    Methode: Zunaechst nur Simulation; kein physischer Roboter erforderlich.
    Vorbedingung: Dokumentierte Welt, Roboterkonfiguration und Route mit offener
      Tuer.
    Ablauf: Route durch mindestens zwei Raeume, einen Flur und eine offene Tuer
      fahren.
    Erwartet: Roboter durchfaehrt mindestens zwei Raeume, einen Flurabschnitt
      und eine offene Tuer autonom.
    Nachweis: Lauf-ID, Konfigurationsversionen, Simulationszeit und Trajektorie.
    Hinweis: Vor der Auswertung eines dokumentierten Laufs wird kein Ergebnis
      behauptet.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_004 {
        subject redefines robot = TC_NAV_002::testRobot;
        in attribute :>> roomsVisited = TC_NAV_002::roomsVisited;
        in attribute :>> corridorTraversed = TC_NAV_002::corridorTraversed;
      }
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_005 {
        subject redefines robot = TC_NAV_002::testRobot;
        in attribute :>> openDoorPassed = TC_NAV_002::openDoorPassed;
        in attribute :>> autonomousDriving = TC_NAV_002::autonomousDriving;
      }
    }
  }

  verification def TC_OBS_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-OBS-001
    Name: Hindernis frontal
    Ablauf: Hindernis vor die geplante Route stellen.
    Erwartet: Hindernis wird erkannt; Roboter stoppt oder faehrt sicher
      ausweichend.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_MAP_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_001;
    }
  }

  verification def TC_OBS_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-OBS-002
    Name: Blockierter Fahrweg
    Ablauf: Route so blockieren, dass keine sichere Alternative besteht.
    Erwartet: Roboter stoppt und meldet Blockade.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_NAV_003;
      verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_STA_001;
    }
  }

  verification def TC_UI_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-UI-001
    Name: Web-App-Auftrag
    Ablauf: Benutzer erstellt einen Transportauftrag in der Web-App.
    Erwartet: Start und Ziel werden ueber die Web-App gewaehlt; der Roboter
      nimmt den Auftrag an oder lehnt ihn mit nachvollziehbarem Status ab.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_001;
    }
  }

  verification def TC_UI_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-UI-002
    Name: Grundbefehle
    Ablauf: Status, betrieblichen Stopp und Rueckkehr zur Ladestation ausloesen.
    Erwartet: Status, betrieblicher Stopp und Rueckkehr zur Ladestation erzeugen
      nachvollziehbare Systemreaktionen.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_002;
    }
  }

  verification def TC_PWR_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-PWR-002
    Name: Unterrichtsprofil 2 h
    Ablauf: Definiertes Unterrichtsprofil ausfuehren.
    Erwartet: Roboter erreicht ein definiertes Demonstrationsprofil von ca. 2 h
      ohne Zwischenladen.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_PWR_002;
    }
  }

  verification def TC_PERF_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-PERF-001
    Name: Nominalgeschwindigkeit
    Ablauf: Fahrprofil bei nominaler Bewegung messen.
    Erwartet: Fahrprofil wird mit ca. 0,5 m/s innerhalb definierter Toleranz
      ausgefuehrt.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_PERF_001;
    }
  }

  verification def TC_PWR_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-PWR-001
    Name: Niedriger Energiezustand
    Ablauf: Simulierten Energiezustand beobachten.
    Erwartet: Warnung bei niedrigem Ladezustand wird erzeugt und gemeldet.
    Hinweis: Batteriemodell und Schwellwerte sind offen.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_PWR_001; }
  }

  verification def TC_STA_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-STA-001
    Name: Missionsstatus melden
    Ablauf: Missions- und Betriebsstatus an der definierten digitalen
      Schnittstelle beobachten.
    Erwartet: Statuswechsel werden korrekt ausgegeben.
    Hinweis: Es wird keine erfolgreiche Ausfuehrung behauptet.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_STA_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_002;
    }
  }

  verification def TC_TRC_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-TRC-001
    Name: Traceability-Review
    Ablauf: Requirement-, Systemelement-, Schnittstellen- und Testverweise
      pruefen; ungeloeste Verweise melden.
    Erwartet: Jede MVP-Anforderung ist mit Funktion, Element, Schnittstelle und
      Test verknuepft; MVP-Elemente verweisen auf Zielsystem-Elemente.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_ARCH_001;
      verify MobileMaterialRobot_Requirements_A1::REQ_ARCH_002;
    }
  }

  verification def TC_DIAG_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-DIAG-001
    Name: Diagnosemeldung
    Ablauf: Simulierten Fehler einspeisen und Diagnosemeldung pruefen.
    Erwartet: Bei simuliertem Fehler enthaelt die Meldung Ursache, betroffene
      Funktion und Zeitstempel.
    Hinweis: Fehlerquellen sind offen.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_DIAG_001; }
  }

  verification def TC_MNT_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-MNT-001
    Name: Wartungsreview
    Ablauf: Zugaenglichkeit zentraler Komponenten im Wartungsreview pruefen.
    Erwartet: Zugang zu zentralen Komponenten ohne unverhaeltnismaessige
      Demontage; erst mit mechanischem Entwurf ausfuehrbar.
    Hinweis: In der reinen Simulationsphase nicht ausfuehrbar.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_MNT_001; }
  }

  verification def TC_TRN_001 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-TRN-001
    Name: Kistentransport
    Ablauf: Transport eines manuell aufgesetzten Werkstuecktraegers simulieren.
    Erwartet: Manuell aufgesetzter Werkstuecktraeger erreicht das Ziel;
      Nutzlastdaten und Zieltoleranz vor Ausfuehrung festlegen.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_TRN_001; }
  }

  verification def TC_TRN_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-TRN-002
    Name: Lage der Kiste
    Ablauf: Simulierte Lage des Werkstuecktraegers im vereinbarten Fahrprofil
      pruefen.
    Erwartet: Werkstuecktraeger bleibt im vereinbarten Fahrprofil innerhalb der
      zulaessigen Lage; Grenzwerte offen.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_TRN_002; }
  }

  verification def TC_SAFE_002 {
    subject testRobot : MobileMaterialRobot;
    doc /*
    ID: TC-SAFE-002
    Name: Person im Fahrweg
    Ablauf: Simulierte Reaktion auf eine Person im Fahrweg pruefen.
    Erwartet: Reaktion auf eine Person im Fahrweg; Bewertungskriterium erst mit
      Safety-Konzept.
    */
    objective { verify MobileMaterialRobot_Requirements_A1::REQ_SAFE_002; }
  }


  verification def TC_UI_003 {
    subject testRobot : MobileMaterialRobot;
    in attribute evidenceComplete : Boolean default = false;
    in attribute wasPaused : Boolean;
    in attribute retainedOrderMatches : Boolean;
    in attribute motionStopped : Boolean;
    in attribute manualRelease : Boolean;
    in attribute safeToMove : Boolean;
    in attribute resumeAccepted : Boolean;
    return verdict : VerdictKind = if evidenceComplete ?
      PassIf(MobileMaterialRobot_Behavior_A1::PauseResumeCriterion(
        wasPaused = wasPaused, retainedOrderMatches = retainedOrderMatches,
        motionStopped = motionStopped, manualRelease = manualRelease,
        safeToMove = safeToMove, resumeAccepted = resumeAccepted))
      else VerdictKind::inconclusive;
    doc /*
    ID: TC-UI-003
    Name: Pause und manuelle Fortsetzung
    Ablauf: Betrieblichen Stopp waehrend eines Auftrags ausloesen, dann
      Fortsetzung mit und ohne manuelle Freigabe anfordern.
    Erwartet: Betrieblicher Stopp pausiert den Auftrag, Bewegung ist gestoppt,
      Auftrag bleibt erhalten; Fortsetzung nur bei manueller Freigabe und
      erfuellten Voraussetzungen (DEC-013).
    Hinweis: motionStopped bezieht sich auf die Pausenphase vor der Auswertung
      der Fortsetzung. Die Attribute sind Beobachtungseingaben; es wird keine
      physikalische Stoppleistung behauptet.
    */
    objective {
      verify MobileMaterialRobot_Requirements_A1::REQ_UI_002;
      verify MobileMaterialRobot_Requirements_A1::REQ_MIS_002;
    }
  }
}
