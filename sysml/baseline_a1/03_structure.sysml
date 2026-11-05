package MobileMaterialRobot_Structure_A1 {
  private import MobileMaterialRobot_Interfaces_A1::*;
  private import MobileMaterialRobot_Behavior_A1::*;
  doc /*
  Strukturelle Zerlegung der Baseline A.1. Keine endgueltige physische
  Architektur; sie trennt Verantwortlichkeiten, damit Anforderungen,
  Schnittstellen und Tests zugeordnet werden koennen. Die Felder der
  Teilsysteme sind Quelle der Teilsystemtabelle in Kapitel 8.
  */

  part def MobileMaterialRobot {
    doc /* Top-level System of Interest. */
    port orderIn : ~TransportOrderPort;
    port statusOut : MissionStatusPort;
    port commandIn : ~OperationalCommandPort;
    port payloadMount : PayloadMechanicalPort;
    port environment : EnvironmentInteractionPort;
    port charging : ChargingStationPort;
    port diagnosticsOut : DiagnosticsPort;
    port safetyStateOut : SafetyStatePort;
    exhibit state operatingState : RobotOperationState;
    part mission : MissionSystem;
    part navigation : NavigationSystem;
    part perception : PerceptionSystem;
    part motion : MotionSystem;
    part transport : TransportSystem;
    part energy : EnergySystem;
    part communication : CommunicationSystem;
    part userInterface : UserInterfaceSystem;
    part safety : SafetySystem;
    part diagnostics : DiagnosticsSystem;
  }

  part def MissionSystem {
    doc /*
    Verantwortung: Auftragsannahme, Missionszustand, Zielvalidierung,
      Ablaufkoordination, Meldung von Abschluss oder Blockade
    MVP-Status: Teilweise
    */
    ref item activeOrder : TransportOrder[0..1];
    perform action transportMission : ExecuteTransportMission;
    perform action pauseMission : OperationalStop {
      in item redefines activeOrder = MissionSystem::activeOrder;
    }
    perform action resumeMission : ResumeMission {
      in item redefines pausedOrder = MissionSystem::activeOrder;
    }
    perform action cancelMission : CancelMission {
      in item redefines pausedOrder = MissionSystem::activeOrder;
    }
  }

  part def NavigationSystem {
    doc /*
    Verantwortung: Kartennutzung und Kartenverwaltung, Lokalisierung, globale
      und lokale Planung, Zielerreichung, Behandlung nicht erreichbarer Ziele
      und blockierter Wege
    MVP-Status: MVP
    */
    perform action passDoor : PassOpenDoor;
    perform action handleObstacle : HandleTemporaryObstacle;
  }

  part def PerceptionSystem {
    doc /*
    Verantwortung: Sensoranbindung, Hinderniserkennung, lokale Umgebungskarte
    MVP-Status: MVP
    Hinweis: Die Sensorwahl ist in Baseline A.1 bewusst offen.
    */
  }

  part def MotionSystem {
    doc /*
    Verantwortung: Bewegungsregelung, Motoransteuerung, Odometriedaten;
      Ausfuehrung geplanter Bewegungen innerhalb der Geschwindigkeits- und
      Sicherheitsgrenzen
    MVP-Status: MVP
    */
  }

  part def TransportSystem {
    doc /*
    Verantwortung: Mechanische Schnittstelle zum Werkstuecktraeger
    MVP-Status: Zielsystem
    Hinweis: Aktives Beladen ist nicht Teil von MVP 1; die Schnittstelle gehoert
      zum Zielsystem.
    */
  }

  part def EnergySystem {
    doc /*
    Verantwortung: Energiespeicher, Ueberwachung des Ladezustands, Koordination
      der Rueckkehr zur Ladestation; spaeter Laden/Docking
    MVP-Status: Minimal
    Hinweis: Automatisches Laden ist offen.
    */
    perform action returnToCharger : ReturnToChargingStation;
  }

  part def CommunicationSystem {
    doc /*
    Verantwortung: Netzwerkkommunikation, Befehls- und Statusaustausch, Logs,
      spaetere Integrationspunkte
    MVP-Status: Minimal
    */
  }

  part def UserInterfaceSystem {
    doc /*
    Verantwortung: Roboterseitiger Anschluss fuer die externe Web-App:
      Auftraege, Bedienbefehle, Status. Die Web-App selbst liegt ausserhalb der
      Systemgrenze.
    MVP-Status: Minimal
    Hinweis: Keine Hosting-Technologie festgelegt.
    */
  }

  part def SafetySystem {
    doc /*
    Verantwortung: Bewertung sicherheitsrelevanter Zustaende, Entscheidung ueber
      den sicheren Stopp, spaetere Not-Halt-Integration
    MVP-Status: MVP reduziert
    */
    perform action safetyStop : SafetyStop;
  }

  part def DiagnosticsSystem {
    doc /*
    Verantwortung: Diagnoseinformationen fuer Test, Wartung und Fehleranalyse
    MVP-Status: Minimal
    */
  }
}

