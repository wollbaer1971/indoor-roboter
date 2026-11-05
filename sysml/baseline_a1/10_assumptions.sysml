package MobileMaterialRobot_Assumptions_A1 {
  private import MobileMaterialRobot_Requirements_A1::*;
  private import MobileMaterialRobot_Structure_A1::*;
  private import MobileMaterialRobot_Context_A1::*;
  private import MobileMaterialRobot_ROS2Mapping_A1::MapManagementNode;

  doc /*
  Annahmen der Baseline A.1. Jede Annahme ist ein benannter Kommentar;
  'about' nennt die Modellelemente, die von ihr abhaengen. Faellt eine
  Annahme, zeigt 'about', was zu pruefen ist. Die Felder sind Quelle der
  Annahmentabelle in Kapitel 3; siehe tables/README.md.
  Status: Vorlaeufig, Offen, Sicherheitsrelevant oder Architekturziel.
  */

  comment A_001 about REQ_NAV_004, MotionSystem, NavigationSystem /*
    ID: A-001
    Annahme: Der Roboter bewegt sich ueberwiegend auf einer Ebene.
    Status: Vorlaeufig
  */

  comment A_002 about SchoolProductionArea /*
    ID: A-002
    Annahme: Der Fahrbereich ist grundsaetzlich fuer einen kleinen mobilen
      Roboter geeignet.
    Status: Vorlaeufig
  */

  comment A_003 about NavigationSystem /*
    ID: A-003
    Annahme: Treppen muessen nicht autonom bewaeltigt werden.
    Status: Vorlaeufig
  */

  comment A_004 about TransportSystem, REQ_TRN_001, REQ_TRN_002 /*
    ID: A-004
    Annahme: Der Werkstuecktraeger ueberschreitet eine noch festzulegende
      Groesse, Masse und Schwerpunktlage nicht.
    Status: Offen
  */

  comment A_005 about REQ_MIS_001, REQ_MAP_001 /*
    ID: A-005
    Annahme: Transportstandorte sind dauerhaft oder zumindest ueber laengere
      Zeit definiert.
    Status: Vorlaeufig
  */

  comment A_006 about REQ_SAFE_002, PersonInOperatingArea, SafetySystem /*
    ID: A-006
    Annahme: Menschen duerfen den Fahrbereich betreten.
    Status: Sicherheitsrelevant
  */

  comment A_007 about REQ_MAP_002, REQ_NAV_002, TemporaryObstacle /*
    ID: A-007
    Annahme: Temporaere Hindernisse sind normaler Bestandteil der
      Betriebsumgebung.
    Status: Vorlaeufig
  */

  comment A_008 about REQ_MAP_003 /*
    ID: A-008
    Annahme: Ein Teil der Umgebung kann sich langfristig veraendern.
    Status: Vorlaeufig
  */

  comment A_009 about MissionSystem, NavigationSystem, MapManagementNode,
      CommunicationSystem /*
    ID: A-009
    Annahme: Das System funktioniert zunaechst mit einem einzelnen Roboter.
    Status: Vorlaeufig
  */

  comment A_010 about CommunicationSystem /*
    ID: A-010
    Annahme: Eine spaetere Erweiterung auf mehrere Roboter soll
      architektonisch nicht unnoetig verhindert werden.
    Status: Architekturziel
  */
}
