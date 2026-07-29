package Interfaces {
  doc /* Schnittstelle zwischen Sicherheitseinheit und Recheneinheit
         (siehe 05_structure.sysml). Technologieoffen: Diese Datei
         legt fest, WELCHE Information in welche Richtung fliesst --
         noch nicht, WIE die Verbindung technisch realisiert wird
         (seriell wie in Band 1 mit 9600 Baud, micro-ROS oder etwas
         anderes). Die technische Bindung folgt erst spaeter, wenn
         tatsaechlich Hardware feststeht.

         Stil angelehnt an SysML_Lehrbuch/.../05_interfaces.sysml:
         Ports und Connections werden dort ergaenzend zu den bereits
         in 03_structure.sysml definierten part def notiert, nicht
         als neue, unabhaengige Definition. Diese Datei folgt
         demselben Muster fuer Sicherheitseinheit/Recheneinheit aus
         05_structure.sysml. */

  // Port-Definitionen. Bewusst funktional benannt (was fliesst),
  // nicht technisch (wie es uebertragen wird).
  port def SicherheitsstatusPort;
  port def FahrbefehlPort;

  // Ergaenzt Sicherheitseinheit aus 05_structure.sysml um Ports:
  part def Sicherheitseinheit {
    doc /* Meldet ihren Status (u. a. Ergebnis von
           Hinderniserkennung, Absturzsicherung, Kontaktsensor) an
           die Recheneinheit und empfaengt von dort Fahrbefehle. */

    port statusOut : SicherheitsstatusPort;
    port fahrbefehlIn : ~FahrbefehlPort;
  }

  // Ergaenzt Recheneinheit aus 05_structure.sysml um Ports:
  part def Recheneinheit {
    doc /* Empfaengt den Sicherheitsstatus und sendet
           Fahrbefehle -- realisiert in Band 2 durch
           indoor_roboter_base_py / indoor_roboter_base_cpp. */

    port statusIn : ~SicherheitsstatusPort;
    port fahrbefehlOut : FahrbefehlPort;
  }

  // Ergaenzt Roboter aus 05_structure.sysml um die Verbindung
  // zwischen beiden Ebenen:
  part def Roboter {
    part sicherheit : Sicherheitseinheit;
    part rechen : Recheneinheit;

    connection status
      connect sicherheit.statusOut to rechen.statusIn;
    connection fahrbefehl
      connect rechen.fahrbefehlOut to sicherheit.fahrbefehlIn;
  }

  doc /* Bezug zu Mission M00 (Band 2): system_node realisiert vorerst
         nur die Recheneinheit-Seite von statusOut/statusIn -- ein
         Herzschlag ohne echten Sicherheitsstatus. Ab Mission M01
         (serial_bridge_node) wird statusIn mit echten Daten von der
         Sicherheitseinheit gefuellt; fahrbefehlOut/fahrbefehlIn
         folgt mit motor_node. */
}
