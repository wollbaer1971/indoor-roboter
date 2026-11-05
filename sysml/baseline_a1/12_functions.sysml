package MobileMaterialRobot_Functions_A1 {
  private import MobileMaterialRobot_Requirements_A1::*;

  doc /*
  Funktionale Architektur der Baseline A.1: Requirement -> Funktion ->
  Teilsystem. Jede Funktion ist eine action def; Teilsysteme fuehren sie in
  03_structure.sysml per 'perform' aus. Die Abhaengigkeiten am Dateiende
  nennen die Requirements, zu denen eine Funktion beitraegt; sie sind
  geplante Zuordnungen, kein Erfuellungsnachweis.
  Die Felder sind Quelle der Funktionstabelle (Kapitel 8) und der
  HW/SW-Allokation (Kapitel 9). Ohne HW-Anteil/SW-Anteil ist eine Funktion
  noch nicht alloziert und fehlt in der Allokationstabelle.
  */

  action def FUN_MIS_001 {
    doc /*
    ID: FUN-MIS-001
    Name: Transportauftrag bearbeiten
    Zweck: Auftrag annehmen, pruefen, ausfuehren und Status verwalten
    */
  }

  action def FUN_MAP_001 {
    doc /*
    ID: FUN-MAP-001
    Name: Grundkarte verwalten
    Zweck: Karte laden, referenzieren und fuer Lokalisierung bereitstellen
    HW-Anteil: Onboard-Speicher, Rechner
    SW-Anteil: Kartenserver, Kartenverwaltung, Versionierung
    Status: MVP
    */
  }

  action def FUN_LOC_001 {
    doc /*
    ID: FUN-LOC-001
    Name: Pose bestimmen
    Zweck: Roboterpose relativ zur Karte schaetzen
    HW-Anteil: Sensorik, Encoder, IMU, Rechner
    SW-Anteil: Lokalisierungsalgorithmus, Transformationsbaum
    Status: MVP
    */
  }

  action def FUN_PER_001 {
    doc /*
    ID: FUN-PER-001
    Name: Umgebung erfassen
    Zweck: Sensorinformationen fuer Navigation und Hindernisbehandlung
      bereitstellen
    HW-Anteil: LiDAR/Kamera/weitere Sensorik
    SW-Anteil: Sensortreiber, Filterung, Hindernisextraktion
    Status: MVP
    */
  }

  action def FUN_NAV_001 {
    doc /*
    ID: FUN-NAV-001
    Name: Route und Bewegung planen
    Zweck: Globales Ziel und lokale Hindernisse in Bewegungsbefehle
      ueberfuehren
    HW-Anteil: Rechner
    SW-Anteil: globale Planung, lokale Planung, Recovery-Verhalten
    Status: MVP
    */
  }

  action def FUN_MOT_001 {
    doc /*
    ID: FUN-MOT-001
    Name: Bewegung ausfuehren
    Zweck: Bewegungsbefehle in Motorsteuerung und Radbewegung umsetzen
    HW-Anteil: Motoren, Motorcontroller, Encoder
    SW-Anteil: hardwarenahe Regelung, ROS2-Anbindung
    Status: MVP
    */
  }

  action def FUN_SAFE_001 {
    doc /*
    ID: FUN-SAFE-001
    Name: Sicheren Zustand herstellen
    Zweck: Bei nicht beherrschbaren Situationen stoppen oder sicheren Zustand
      melden
    HW-Anteil: Sensorik, Not-Halt, ggf. Safety-Hardware
    SW-Anteil: Ueberwachung, Stopp-Logik, Fehlerstatus
    Status: MVP reduziert
    */
  }

  action def FUN_STA_001 {
    doc /*
    ID: FUN-STA-001
    Name: Status und Diagnose melden
    Zweck: Betriebs- und Missionsinformationen fuer Nutzer, Tests und Wartung
      bereitstellen
    */
  }

  action def FUN_TRN_001 {
    doc /*
    ID: FUN-TRN-001
    Name: Werkstuecktraeger handhaben
    Zweck: Werkstuecktraeger aufnehmen, sichern und abgeben
    HW-Anteil: Mechanik der Aufnahme, Aktoren, Sensorik
    SW-Anteil: Handhabungslogik, Verriegelungsstatus
    Status: Zielsystem
    */
  }

  // Beitrag der Funktionen zu Requirements (geplant, kein Nachweis).
  dependency from FUN_MIS_001 to REQ_MIS_001;
  dependency from FUN_MAP_001 to REQ_MAP_001;
  dependency from FUN_LOC_001 to REQ_LOC_001;
  dependency from FUN_PER_001 to REQ_MAP_002;
  dependency from FUN_NAV_001 to REQ_NAV_001;
  dependency from FUN_NAV_001 to REQ_NAV_002;
  dependency from FUN_MOT_001 to REQ_NAV_001;
  dependency from FUN_MOT_001 to REQ_PERF_001;
  dependency from FUN_SAFE_001 to REQ_SAFE_001;
  dependency from FUN_STA_001 to REQ_STA_001;
  dependency from FUN_STA_001 to REQ_PWR_001;
  dependency from FUN_STA_001 to REQ_DIAG_001;
  dependency from FUN_TRN_001 to REQ_TRN_001;
}
