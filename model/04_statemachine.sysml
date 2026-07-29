package Betriebszustand {
  doc /* Zustandsmodell des autonomen Indoor-Roboters. Verbindet die
         Funktionen aus 03_functions.sysml zu einem gemeinsamen
         Betriebszustand -- die Grundlage fuer Statusausgabe
         (REQ_Status) und fuer die spaetere Zwei-Ebenen-Architektur
         (Sicherheitseinheit/Recheneinheit, siehe docs/decisions.md
         ADR-003).

         Bewusst klein gehalten: vier Zustaende als Ausgangspunkt,
         erweiterbar (z. B. eigener Ladezustand), sobald
         Batterieueberwachung tatsaechlich ausgebaut wird.

         Stil angelehnt an SysML_Lehrbuch/.../04_behavior.sysml
         (state def mit entry/then und accept-Transitionen), aber
         eigene Zustaende und Ereignisse fuer dieses Projekt. */

  import Requirements::*;
  import Functions::*;

  state def Betrieb {
    entry; then init;

    state init {
      doc /* Startzustand. Sensoren noch nicht bestaetigt bereit. */
      transition accept SystemBereit then normal;
    }

    state normal {
      doc /* Regelbetrieb. Hinderniserkennung und Absturzsicherung
             laufen, kein erhoehtes Risiko gemeldet. */
      transition accept HindernisNah then warnung;
      transition accept AbgrundErkannt then nothalt;
      transition accept KontaktAusgeloest then nothalt;
    }

    state warnung {
      doc /* Erhoehtes Risiko: Hindernis im Nahbereich, aber noch
             nicht im Sicherheitsabstand. Kollisionsvermeidung
             reduziert Geschwindigkeit. */
      transition accept HindernisFrei then normal;
      transition accept HindernisSehrNah then nothalt;
      transition accept AbgrundErkannt then nothalt;
      transition accept KontaktAusgeloest then nothalt;
    }

    state nothalt {
      doc /* Sicherer Halt. Ausgeloest durch Absturzgefahr, direkten
             Kontakt oder minimalen Hindernisabstand. Verlassen nur
             durch expliziten Reset, nicht automatisch. */
      transition accept Reset then init;
    }
  }

  // Jeder Zustand von Betrieb ist zugleich der Inhalt, den
  // Statusausgabe nach aussen meldet -- siehe 03_functions.sysml.
  satisfy requirement REQ_Status by Betrieb;
}
