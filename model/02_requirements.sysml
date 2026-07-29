package Requirements {
  doc /* Anforderungen des autonomen Indoor-Roboters (indoor-roboter).
         Ausgangsstand: klein und flach gehalten, siehe ADR-002 in
         docs/decisions.md (Model First). Wird missionsweise
         erweitert, nicht im Voraus vollstaendig entworfen. */

  import Stakeholder::*;

  requirement REQ_Sicherheit {
    doc /* Der Roboter darf Personen und Umgebung nicht gefaehrden.
           Stakeholder: Anwender. */

    requirement REQ_Kollisionsvermeidung {
      doc /* Der Roboter muss Hindernisse in seinem Fahrweg
             erkennen und rechtzeitig reagieren. */
    }

    requirement REQ_Absturzsicherung {
      doc /* Der Roboter muss fehlenden Untergrund (Kante, Stufe)
             erkennen und ein Herunterfallen verhindern.

             Offen: Die bisherige Sensorbestueckung (2x HC-SR04
             nach vorne, Band 1) deckt das nicht ab. Bewusst noch
             keine Hardwarebindung -- siehe docs/decisions.md,
             ADR-003, Offene Frage. */
    }
  }

  requirement REQ_Status {
    doc /* Der Roboter muss seinen Betriebszustand nach aussen
           sichtbar machen. Stakeholder: Anwender, Entwickler. */
  }

  requirement REQ_Batterie {
    doc /* Der Roboter soll seinen Akkuzustand ueberwachen.
           Optional/erweiterbar -- kein Muss in der ersten
           Ausbaustufe des Modells. */
  }
}
