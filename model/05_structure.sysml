package Structure {
  doc /* Logische Architektur des autonomen Indoor-Roboters --
         Zwei-Ebenen-Aufteilung (Sicherheitseinheit/Recheneinheit),
         siehe docs/decisions.md ADR-003. Bewusst noch KEINE
         Technologiebindung: kein Mikrocontroller-Hersteller, kein
         konkreter Sensortyp. Das folgt erst in einer spaeteren
         Datei (Technologiebindung), sobald tatsaechlich Hardware
         ausgewaehlt wird.

         Stilistisch angelehnt an SysML_Lehrbuch/.../03_structure.sysml
         (part def mit Unterteilen), aber mit `perform`-Zuordnung zu
         den Funktionen aus 03_functions.sysml ergaenzt -- das Buch
         selbst modelliert bewusst keine Aktionen (siehe Hinweis in
         04_behavior.sysml), daher ist das eine eigenstaendige
         Erweiterung dieses Projekts, kein aus dem Buch uebernommenes
         Muster. */

  import Functions::*;

  part def Roboter {
    doc /* Gesamtsystem. */
    part sicherheit : Sicherheitseinheit;
    part rechen : Recheneinheit;
  }

  part def Sicherheitseinheit {
    doc /* Echtzeitfaehige Ebene: alles, was garantierte
           Reaktionszeiten braucht (vgl. Band 1, Kap. 25 "Warum
           unser Roboter zwei Gehirne braucht"). Technologieoffen --
           noch keine Festlegung auf einen bestimmten
           Mikrocontroller. */

    part abstandssensor : Abstandssensor[1..*];
    part kantensensor : Kantensensor[1..*];
    part kontaktsensor : Kontaktsensor;
    part antrieb : Antrieb;

    perform action Hinderniserkennung;
    perform action Kollisionsvermeidung;
    perform action Absturzsicherung;
  }

  part def Recheneinheit {
    doc /* Intelligenzebene: Navigation, Statusausgabe, ROS2 (Band 2,
           edge/ros2/{python,cpp}). Kommuniziert mit der
           Sicherheitseinheit ueber eine noch zu definierende
           Schnittstelle (Serial o. ae. -- folgt in einer
           Interfaces-Datei). Technologieoffen -- noch keine
           Festlegung auf ein bestimmtes Einplatinencomputer-System. */

    perform action Statusausgabe;
    perform action Batterieueberwachung;
  }

  part def Abstandssensor {
    doc /* Erkennt Hindernisse im Fahrweg (Basis fuer
           Hinderniserkennung). Technologieoffen -- Ultraschall,
           Infrarot oder Lidar moeglich. Mehrfach instanziierbar
           (z. B. mehrere Blickrichtungen), siehe Multiplizitaet
           [1..*] in Sicherheitseinheit. */
  }

  part def Kantensensor {
    doc /* Erkennt fehlenden Untergrund (Basis fuer
           Absturzsicherung). Sensortechnologie bewusst offen --
           siehe REQ_Absturzsicherung in 02_requirements.sysml. */
  }

  part def Kontaktsensor {
    doc /* Erkennt physischen Kontakt als letzte Sicherheitsebene,
           unabhaengig von Abstandssensoren. Entspricht dem
           bestehenden Kontakt-Interrupt aus Band 1 (D2, FALLING) --
           dort bereits real vorhanden, hier erstmals modelliert. */
  }

  part def Antrieb {
    doc /* Setzt Fahrbefehle der Sicherheitseinheit in Bewegung um.
           Motor-/Treiber-Technologie bewusst offen. */
  }
}
