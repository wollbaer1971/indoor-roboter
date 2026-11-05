package MobileMaterialRobot_NonGoals_A1 {
  private import MobileMaterialRobot_Requirements_A1::*;
  private import MobileMaterialRobot_Structure_A1::*;

  doc /*
  Nicht-Ziele der ersten Entwicklungsstufe: bewusst ausgeschlossener Umfang.
  Jedes Nicht-Ziel ist ein benannter Kommentar; 'about' nennt Elemente, deren
  Grenze es zieht. Die Felder sind Quelle der Aufzaehlung in Kapitel 3; die
  Reihenfolge hier ist die Reihenfolge im Dokument.
  */

  comment NG_001 /*
    ID: NG-001
    Nicht-Ziel: Ausseneinsatz
  */

  comment NG_002 about NavigationSystem /*
    ID: NG-002
    Nicht-Ziel: Treppensteigen
  */

  comment NG_003 /*
    ID: NG-003
    Nicht-Ziel: autonomer Personenverkehr
  */

  comment NG_004 about TransportSystem /*
    ID: NG-004
    Nicht-Ziel: Manipulatorarm
  */

  comment NG_005 about TransportSystem /*
    ID: NG-005
    Nicht-Ziel: humanoide Manipulation
  */

  comment NG_006 about TransportSystem, REQ_TRN_001 /*
    ID: NG-006
    Nicht-Ziel: vollstaendig autonome Be- und Entladung beliebiger
      Gegenstaende
  */

  comment NG_007 about NavigationSystem /*
    ID: NG-007
    Nicht-Ziel: mehrere Stockwerke per Aufzug
  */

  comment NG_008 about REQ_ARCH_003, MissionSystem /*
    ID: NG-008
    Nicht-Ziel: autonome Flottenoptimierung
    Hinweis: Grenze zu REQ-ARCH-003: Mehrere Roboter sollen moeglich bleiben,
      ihre Optimierung als Flotte ist nicht Ziel.
  */

  comment NG_009 /*
    ID: NG-009
    Nicht-Ziel: Betrieb auf oeffentlichen Strassen
  */

  comment NG_010 about REQ_PERF_001, MotionSystem /*
    ID: NG-010
    Nicht-Ziel: hochdynamische Fahrgeschwindigkeiten
    Hinweis: Siehe DEC-012 (hoehere Geschwindigkeit als spaetere Erweiterung).
  */
}
