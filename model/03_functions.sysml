package Functions {
  doc /* Funktionen des autonomen Indoor-Roboters, abgeleitet aus
         den Requirements in 02_requirements.sysml. Jede Funktion
         erfuellt (satisfy) mindestens eine Anforderung.

         Bewusst noch keine Zuordnung zu Hardware oder Systemteilen
         -- das folgt erst in einer spaeteren Structure-Datei, siehe
         docs/decisions.md ADR-003 (technologieoffen, um sich nicht
         vorschnell an einen Hersteller oder ein Sensorsystem zu
         binden). */

  import Requirements::*;

  action def Hinderniserkennung {
    doc /* Erkennt Hindernisse im Fahrweg des Roboters. Vorstufe zu
           Kollisionsvermeidung -- liefert die Information, auf der
           Kollisionsvermeidung entscheidet. Erkennt selbst noch
           keine Abgruende (siehe Absturzsicherung). */
  }

  action def Kollisionsvermeidung {
    doc /* Reagiert auf ein von Hinderniserkennung gemeldetes
           Hindernis: bremsen, stoppen oder ausweichen, abhaengig
           vom Abstand. */
  }

  // REQ_Kollisionsvermeidung verlangt "erkennen UND rechtzeitig
  // reagieren" -- deshalb zwei Funktionen, die dieselbe Anforderung
  // gemeinsam erfuellen, nicht eine Funktion fuer beides.
  satisfy requirement REQ_Kollisionsvermeidung by Hinderniserkennung;
  satisfy requirement REQ_Kollisionsvermeidung by Kollisionsvermeidung;

  action def Absturzsicherung {
    doc /* Erkennt fehlenden Untergrund (Kante, Stufe) und
           verhindert ein Herunterfallen. Welcher Sensor das leistet,
           ist noch offen -- siehe REQ_Absturzsicherung. */
  }
  satisfy requirement REQ_Absturzsicherung by Absturzsicherung;

  action def Statusausgabe {
    doc /* Macht den Betriebszustand des Roboters nach aussen
           sichtbar. Erste, einfachste Auspraegung: der Herzschlag
           aus Band 2, Mission M00 (indoor_roboter_base_py /
           indoor_roboter_base_cpp, Topic /system/heartbeat). Wird
           mit der State Machine (folgt) differenzierter -- Normal,
           Warnung, Nothalt statt nur "lebt". */
  }
  satisfy requirement REQ_Status by Statusausgabe;

  action def Batterieueberwachung {
    doc /* Ueberwacht den Akkuzustand des Roboters. Optional in
           dieser Ausbaustufe -- siehe REQ_Batterie. */
  }
  satisfy requirement REQ_Batterie by Batterieueberwachung;
}
