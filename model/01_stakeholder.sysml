package Stakeholder {
  doc /* Stakeholder des autonomen Indoor-Roboters (indoor-roboter).
         Bewusst klein gehalten: zwei Stakeholder als Ausgangspunkt,
         erweiterbar, sobald neue Perspektiven (z. B. Betreiber,
         Wartungspersonal) tatsaechlich gebraucht werden.

         Stilistisch angelehnt an SysML_Lehrbuch/.../01_context.sysml
         (part def je Stakeholder mit doc-Kommentar), aber
         eigenstaendiges, kleineres Modell fuer dieses konkrete
         Projekt -- siehe README.md und docs/decisions.md (ADR-002). */

  part def Entwickler {
    doc /* Baut, wartet, testet und erweitert den Roboter.
           Interesse: klare Architektur, nachvollziehbare
           Anforderungen, Traceability von Anforderung bis Code. */
  }

  part def Anwender {
    doc /* Nutzt den Roboter oder haelt sich in seiner Naehe auf.
           Interesse: sicheres Verhalten, verstaendlicher
           Betriebszustand. */
  }
}
