package MobileMaterialRobot_Stakeholders_A1 {
  private import MobileMaterialRobot_Requirements_A1::*;
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  doc /*
  Stakeholder und Stakeholder Needs der Baseline A.1.
  Ein Stakeholder ist eine Rolle (part def), keine Person. Ein Need ist ein
  concern, also eine Frage oder ein Anliegen dieser Rolle; seine Quelle sind
  die stakeholder-Features, nicht ein Textfeld. Die Doc-Felder sind Quelle
  der Tabellen in Kapitel 4. Unten steht, aus welchen Needs welche
  Requirements abgeleitet sind; das Quelle-Feld der Requirements muss dazu
  passen (tools/generate_docs.py prueft das).
  */

  part def STK_001 {
    doc /*
    ID: STK-001
    Name: Bediener
    Interesse: Transportauftrag einfach und fehlerarm ausloesen
    */
  }

  part def STK_002 {
    doc /*
    ID: STK-002
    Name: Materialempfaenger
    Interesse: Richtige Kiste am richtigen Ziel erhalten
    */
  }

  part def STK_003 {
    doc /*
    ID: STK-003
    Name: Betreiber
    Interesse: Zuverlaessiger, planbarer und wirtschaftlicher Betrieb
    */
  }

  part def STK_004 {
    doc /*
    ID: STK-004
    Name: Personen im Fahrbereich
    Interesse: Keine Gefaehrdung durch Bewegung, Last oder Fehlverhalten des
      Roboters
    */
  }

  part def STK_005 {
    doc /*
    ID: STK-005
    Name: Wartung
    Interesse: Fehler schnell diagnostizieren und Komponenten sicher warten
      koennen
    */
  }

  part def STK_006 {
    doc /*
    ID: STK-006
    Name: Produktion/Betrieb
    Interesse: Transport darf laufende Arbeitsablaeufe nicht stoeren
    */
  }

  part def STK_007 {
    doc /*
    ID: STK-007
    Name: IT
    Interesse: Sichere Integration in Netzwerk, Updates, Logging und moegliche
      Auftragsquellen
    */
  }

  part def STK_008 {
    doc /*
    ID: STK-008
    Name: Sicherheitsverantwortliche
    Interesse: Nachweisbarer sicherer Betrieb und geeignete Schutzmassnahmen
    */
  }

  part def STK_009 {
    doc /*
    ID: STK-009
    Name: Entwicklungsteam
    Interesse: Klare Architektur, testbare Schnittstellen und wartbares Modell
    */
  }

  part def STK_010 {
    doc /*
    ID: STK-010
    Name: Einkauf/Management
    Interesse: Begruendete Komponentenwahl, Kostenkontrolle und
      Nutzenbewertung
    */
  }

  part def STK_011 {
    doc /*
    ID: STK-011
    Name: Lehrende und Lernende
    Interesse: Demonstrierbare, verstaendliche und didaktisch nutzbare
      Systemablaeufe
    */
  }

  concern SN_001 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    doc /*
    ID: SN-001
    Gruppe: Initial
    Need: Der Bediener moechte einen Transportauftrag mit moeglichst wenig
      Bedienaufwand ausloesen.
    Prioritaet: Must
    */
  }

  concern SN_002 {
    subject robot : MobileMaterialRobot;
    stakeholder materialempfaenger : STK_002;
    doc /*
    ID: SN-002
    Gruppe: Initial
    Need: Die Materialkiste soll am vorgesehenen Zielstandort ankommen.
    Prioritaet: Must
    */
  }

  concern SN_003 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-003
    Gruppe: Initial
    Need: Der Betreiber moechte den Betriebszustand des Roboters jederzeit
      erkennen koennen.
    Prioritaet: Must
    */
  }

  concern SN_004 {
    subject robot : MobileMaterialRobot;
    stakeholder personImFahrbereich : STK_004;
    doc /*
    ID: SN-004
    Gruppe: Initial
    Need: Personen im Fahrbereich duerfen durch den Roboter nicht gefaehrdet
      werden.
    Prioritaet: Must
    */
  }

  concern SN_005 {
    subject robot : MobileMaterialRobot;
    stakeholder wartung : STK_005;
    doc /*
    ID: SN-005
    Gruppe: Initial
    Need: Wartungspersonal benoetigt Diagnoseinformationen fuer Fehleranalyse
      und Instandhaltung.
    Prioritaet: Should
    */
  }

  concern SN_006 {
    subject robot : MobileMaterialRobot;
    stakeholder produktion : STK_006;
    doc /*
    ID: SN-006
    Gruppe: Initial
    Need: Der Roboter soll Hindernisse und geaenderte Umgebungen so behandeln,
      dass Betriebsablaeufe nicht unnoetig gestoert werden.
    Prioritaet: Must
    */
  }

  concern SN_007 {
    subject robot : MobileMaterialRobot;
    stakeholder it : STK_007;
    doc /*
    ID: SN-007
    Gruppe: Initial
    Need: Netzwerkschnittstellen, Updates und Datenhaltung sollen
      kontrollierbar und sicher sein.
    Prioritaet: Should
    */
  }

  concern SN_008 {
    subject robot : MobileMaterialRobot;
    stakeholder entwicklung : STK_009;
    doc /*
    ID: SN-008
    Gruppe: Initial
    Need: Architekturentscheidungen sollen nachvollziehbar dokumentiert und
      mit Anforderungen verknuepft sein.
    Prioritaet: Must
    */
  }

  concern SN_009 {
    subject robot : MobileMaterialRobot;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-009
    Gruppe: Initial
    Need: Der Roboter soll sich fuer die Demonstration technischer
      Zusammenhaenge im Unterricht eignen.
    Prioritaet: Must
    */
  }

  concern SN_010 {
    subject robot : MobileMaterialRobot;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-010
    Gruppe: Initial
    Need: Wichtige Systemzustaende und Ablaeufe sollen im Unterricht
      nachvollziehbar dargestellt werden koennen.
    Prioritaet: Should
    */
  }

  concern SN_USER_001 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    doc /*
    ID: SN-USER-001
    Gruppe: Bedienung und Auftrag
    Need: Ein Bediener moechte einen Transportauftrag einfach erteilen
      koennen.
    */
  }

  concern SN_USER_002 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    doc /*
    ID: SN-USER-002
    Gruppe: Bedienung und Auftrag
    Need: Ein Bediener moechte erkennen koennen, ob ein Transportauftrag
      angenommen wurde.
    */
  }

  concern SN_USER_003 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    doc /*
    ID: SN-USER-003
    Gruppe: Bedienung und Auftrag
    Need: Ein Bediener moechte den aktuellen Zustand eines Transportauftrags
      erkennen koennen.
    */
  }

  concern SN_TRN_001 {
    subject robot : MobileMaterialRobot;
    stakeholder materialempfaenger : STK_002;
    doc /*
    ID: SN-TRN-001
    Gruppe: Transport
    Need: Material soll zuverlaessig vom gewuenschten Ausgangsort zum
      gewuenschten Zielort gelangen.
    */
  }

  concern SN_TRN_002 {
    subject robot : MobileMaterialRobot;
    stakeholder materialempfaenger : STK_002;
    stakeholder personImFahrbereich : STK_004;
    doc /*
    ID: SN-TRN-002
    Gruppe: Transport
    Need: Die transportierte Kiste soll waehrend des Transports sicher
      gehalten werden.
    */
  }

  concern SN_TRN_003 {
    subject robot : MobileMaterialRobot;
    stakeholder materialempfaenger : STK_002;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-TRN-003
    Gruppe: Transport
    Need: Eine Materialkiste soll dem richtigen Transportauftrag zugeordnet
      werden koennen.
    */
  }

  concern SN_TRN_004 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder produktion : STK_006;
    doc /*
    ID: SN-TRN-004
    Gruppe: Transport
    Need: Ein Werkstuecktraeger soll durch einen Menschen auf den Roboter
      aufgesetzt werden koennen.
    */
  }

  concern SN_TRN_005 {
    subject robot : MobileMaterialRobot;
    stakeholder produktion : STK_006;
    doc /*
    ID: SN-TRN-005
    Gruppe: Transport
    Need: Ein Werkstuecktraeger soll perspektivisch durch ein externes
      Transfersystem uebergeben werden koennen.
    */
  }

  concern SN_NAV_001 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-NAV-001
    Gruppe: Navigation und Umgebung
    Need: Der Roboter soll die gewuenschten Transportziele selbststaendig
      erreichen.
    */
  }

  concern SN_NAV_002 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    stakeholder produktion : STK_006;
    doc /*
    ID: SN-NAV-002
    Gruppe: Navigation und Umgebung
    Need: Der Roboter soll mit Veraenderungen seiner Umgebung umgehen koennen.
    */
  }

  concern SN_NAV_003 {
    subject robot : MobileMaterialRobot;
    stakeholder produktion : STK_006;
    doc /*
    ID: SN-NAV-003
    Gruppe: Navigation und Umgebung
    Need: Voruebergehende Hindernisse sollen einen Transport moeglichst nicht
      unnoetig verhindern.
    */
  }

  concern SN_NAV_004 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-NAV-004
    Gruppe: Navigation und Umgebung
    Need: Der Roboter soll erkennen koennen, wenn ein Ziel oder Fahrweg nicht
      erreichbar ist.
    */
  }

  concern SN_NAV_005 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder betreiber : STK_003;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-NAV-005
    Gruppe: Navigation und Umgebung
    Need: Der Roboter soll mehrere Raeume ueber einen verbindenden Flur
      erreichen koennen.
    */
  }

  concern SN_NAV_006 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder betreiber : STK_003;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-NAV-006
    Gruppe: Navigation und Umgebung
    Need: Der Roboter soll offene Tueren selbststaendig durchfahren koennen.
    */
  }

  concern SN_SAFE_001 {
    subject robot : MobileMaterialRobot;
    stakeholder personImFahrbereich : STK_004;
    stakeholder sicherheit : STK_008;
    doc /*
    ID: SN-SAFE-001
    Gruppe: Safety
    Need: Personen im Fahrbereich duerfen durch den Roboter nicht gefaehrdet
      werden.
    */
  }

  concern SN_SAFE_002 {
    subject robot : MobileMaterialRobot;
    stakeholder personImFahrbereich : STK_004;
    stakeholder sicherheit : STK_008;
    doc /*
    ID: SN-SAFE-002
    Gruppe: Safety
    Need: Der Roboter soll bei kritischen Situationen in einen sicheren
      Zustand uebergehen.
    */
  }

  concern SN_SAFE_003 {
    subject robot : MobileMaterialRobot;
    stakeholder personImFahrbereich : STK_004;
    stakeholder materialempfaenger : STK_002;
    doc /*
    ID: SN-SAFE-003
    Gruppe: Safety
    Need: Der Transportgegenstand soll keine zusaetzliche Gefaehrdung
      verursachen.
    */
  }

  concern SN_OPS_001 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-OPS-001
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Der Betreiber moechte den Betriebszustand des Roboters erkennen
      koennen.
    */
  }

  concern SN_OPS_002 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    stakeholder wartung : STK_005;
    doc /*
    ID: SN-OPS-002
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Stoerungen sollen nachvollziehbar sein.
    */
  }

  concern SN_OPS_003 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-OPS-003
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Der Roboter soll im normalen Betrieb moeglichst wenig manuelle
      Eingriffe benoetigen.
    */
  }

  concern SN_MNT_001 {
    subject robot : MobileMaterialRobot;
    stakeholder wartung : STK_005;
    doc /*
    ID: SN-MNT-001
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Wartungspersonal soll Fehler diagnostizieren koennen.
    */
  }

  concern SN_MNT_002 {
    subject robot : MobileMaterialRobot;
    stakeholder wartung : STK_005;
    doc /*
    ID: SN-MNT-002
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Verschleissteile und zentrale Komponenten sollen zugaenglich sein.
    */
  }

  concern SN_MNT_003 {
    subject robot : MobileMaterialRobot;
    stakeholder wartung : STK_005;
    stakeholder it : STK_007;
    doc /*
    ID: SN-MNT-003
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Hardware und Software sollen austauschbar beziehungsweise
      aktualisierbar sein.
    */
  }

  concern SN_DEV_001 {
    subject robot : MobileMaterialRobot;
    stakeholder entwicklung : STK_009;
    doc /*
    ID: SN-DEV-001
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Das System soll schrittweise entwickelt und erweitert werden
      koennen.
    */
  }

  concern SN_DEV_002 {
    subject robot : MobileMaterialRobot;
    stakeholder entwicklung : STK_009;
    doc /*
    ID: SN-DEV-002
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Aenderungen sollen moeglichst lokal bleiben und keine unnoetigen
      Aenderungen anderer Subsysteme verursachen.
    */
  }

  concern SN_DEV_003 {
    subject robot : MobileMaterialRobot;
    stakeholder entwicklung : STK_009;
    stakeholder einkauf : STK_010;
    doc /*
    ID: SN-DEV-003
    Gruppe: Betrieb, Wartung und Entwicklung
    Need: Anforderungen, Architektur, Implementierung und Tests sollen
      nachvollziehbar miteinander verbunden sein.
    */
  }

  concern SN_EDU_001 {
    subject robot : MobileMaterialRobot;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-EDU-001
    Gruppe: Unterricht und Demonstration
    Need: Der Roboter soll sich fuer die Demonstration technischer
      Zusammenhaenge im Unterricht eignen.
    */
  }

  concern SN_EDU_002 {
    subject robot : MobileMaterialRobot;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-EDU-002
    Gruppe: Unterricht und Demonstration
    Need: Wichtige Systemzustaende und Ablaeufe sollen im Unterricht
      nachvollziehbar dargestellt werden koennen.
    */
  }

  concern SN_EDU_003 {
    subject robot : MobileMaterialRobot;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-EDU-003
    Gruppe: Unterricht und Demonstration
    Need: Das System soll innerhalb eines Unterrichtsblocks sinnvoll
      eingesetzt werden koennen.
    */
  }

  concern SN_UI_001 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-UI-001
    Gruppe: Unterricht und Demonstration
    Need: Ein Benutzer soll Transportauftraege ueber eine Web-Oberflaeche
      ausloesen koennen.
    */
  }

  concern SN_UI_002 {
    subject robot : MobileMaterialRobot;
    stakeholder bediener : STK_001;
    stakeholder betreiber : STK_003;
    doc /*
    ID: SN-UI-002
    Gruppe: Unterricht und Demonstration
    Need: Ein Benutzer soll grundlegende Betriebsbefehle ausloesen koennen.
    */
  }

  concern SN_ENE_001 {
    subject robot : MobileMaterialRobot;
    stakeholder betreiber : STK_003;
    stakeholder lehre : STK_011;
    doc /*
    ID: SN-ENE-001
    Gruppe: Unterricht und Demonstration
    Need: Der Roboter soll einen Unterrichtsblock ohne notwendiges
      Zwischenladen absolvieren koennen.
    */
  }
  // Herkunft: Requirement wird aus Need abgeleitet (Quelle-Feld des Requirements).
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MIS_001 to SN_UI_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MIS_001 to SN_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MIS_002 to SN_USER_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MIS_002 to SN_USER_003;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_TRN_001 to SN_TRN_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_TRN_001 to SN_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_TRN_002 to SN_TRN_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_TRN_002 to SN_SAFE_003;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MAP_002 to SN_NAV_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MAP_002 to SN_006;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MAP_003 to SN_NAV_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_NAV_003 to SN_NAV_004;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_NAV_004 to SN_NAV_005;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_NAV_005 to SN_NAV_006;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_SAFE_001 to SN_SAFE_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_SAFE_001 to SN_004;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_SAFE_002 to SN_SAFE_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_UI_001 to SN_UI_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_UI_002 to SN_UI_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_PWR_002 to SN_ENE_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_STA_001 to SN_OPS_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_STA_001 to SN_003;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_001 to SN_DEV_003;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_001 to SN_008;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_DIAG_001 to SN_005;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_DIAG_001 to SN_MNT_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_MNT_001 to SN_MNT_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_002 to SN_DEV_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_002 to SN_DEV_002;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_003 to SN_DEV_001;
  dependency from MobileMaterialRobot_Requirements_A1::REQ_ARCH_003 to SN_DEV_002;
}
