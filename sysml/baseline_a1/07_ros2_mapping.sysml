package MobileMaterialRobot_ROS2Mapping_A1 {
  doc /*
  Vorlaeufiges ROS2-Mapping fuer die spaetere Implementierung. Baseline A.1
  fordert ROS2 nicht als Systemanforderung; das Mapping ist eine
  wahrscheinliche Architekturzuordnung, keine endgueltige Technologie-
  entscheidung (ADR-0004).

  Nodes: Die Felder sind Quelle der ROS2-Mapping-Tabelle in Kapitel 9.
  Publiziert/Abonniert nennen Topics; daraus leitet der Generator die
  Richtung jedes Topics ab. Eintraege ohne fuehrenden Schraegstrich
  (z. B. Sensor-Topics) sind noch nicht festgelegte Quellen.
  Topics: je eine item def mit Name, Typ und Zweck.
  */

  part def MissionManagerNode {
    doc /*
    Node: mission_manager_node
    Kurzname: Mission
    Schnittstellenidee: Auftrag, Ziel, Missionszustand
    Publiziert: /mission_state, /goal_pose
    Abonniert: /transport_order, /operator_command, /navigation_result,
      /battery_state
    Verantwortung: Auftragsvalidierung, Missionszustand, Meldung von
      Abschluss oder Blockade.
    Anforderungen: REQ-MIS-001, REQ-MIS-002, REQ-STA-001
    */
  }

  part def WebInterfaceNode {
    doc /*
    Node: web_interface_node
    Kurzname: Web-Interface
    Schnittstellenidee: Auftraege und Bedienbefehle von der Web-App, Status
      und Diagnose zur Web-App
    Publiziert: /transport_order, /operator_command
    Abonniert: /mission_state, /diagnostics
    Anforderungen: REQ-UI-001, REQ-UI-002
    */
  }

  part def NavigationNode {
    doc /*
    Node: navigation_node
    Ergaenzung: z. B. auf Basis Nav2
    Kurzname: Navigation
    Schnittstellenidee: Zielaktion, Pfad, Bewegungsbefehl
    Publiziert: /cmd_vel, /navigation_result
    Abonniert: /goal_pose, /robot_pose, /odom, /map, /local_obstacles,
      /safety_state
    Parameter: nominal_speed, speed_limit, planner_config
    Anforderungen: REQ-NAV-001, REQ-NAV-002, REQ-NAV-003, REQ-NAV-004,
      REQ-NAV-005, REQ-PERF-001
    */
  }

  part def MapManagementNode {
    doc /*
    Node: map_management_node
    Rolle: Kartenverwaltung
    Kurzname: Kartenverwaltung
    Schnittstellenidee: Karte bereitstellen, Kartenupdate-Kandidaten
    Publiziert: /map, /map_update_candidate
    Abonniert: /local_obstacles
    Anforderungen: REQ-MAP-001, REQ-MAP-003
    */
  }

  part def LocalizationNode {
    doc /*
    Node: localization_node
    Rolle: Lokalisierung
    Kurzname: Lokalisierung
    Schnittstellenidee: Pose, Transformationsdaten
    Publiziert: /robot_pose
    Abonniert: /map, Sensor-Topics
    Anforderungen: REQ-LOC-001
    */
  }

  part def PerceptionNode {
    doc /*
    Node: perception_node
    Ergaenzung: ggf. aufgeteilt in Sensortreiber und Hindernisverarbeitung
    Kurzname: Perception
    Schnittstellenidee: Sensordaten, Hindernisse, lokale Karte
    Publiziert: /local_obstacles
    Abonniert: Sensor-Topics
    Anforderungen: REQ-MAP-002, REQ-SAFE-002
    */
  }

  part def MotionControllerNode {
    doc /*
    Node: motion_controller_node
    Ergaenzung: ggf. mit MCU-Firmware
    Kurzname: Motion
    Schnittstellenidee: Geschwindigkeitsvorgabe, Odometrie, Motorstatus
    Publiziert: /odom
    Abonniert: /cmd_vel, /safety_state
    Verantwortung: Ausfuehrung zulaessiger Bewegungsbefehle und Odometrie.
    Anforderungen: REQ-NAV-001
    Hinweis: Nur Kandidat; weder Treiber noch Simulator ausgewaehlt.
    */
  }

  part def SafetySupervisorNode {
    doc /*
    Node: safety_supervisor_node
    Ergaenzung: spaeter plus Hardware-Stopp
    Kurzname: Safety
    Schnittstellenidee: Safety-Zustand, Stoppgrund
    Publiziert: /safety_state
    Abonniert: /local_obstacles, /cmd_vel, Safety-Eingaenge
    Anforderungen: REQ-SAFE-001, REQ-SAFE-002
    */
  }

  part def EnergyMonitorNode {
    doc /*
    Node: energy_monitor_node
    Kurzname: Energy
    Schnittstellenidee: Batterie- und Warnstatus
    Publiziert: /battery_state
    Abonniert: Batterie-Hardwareschnittstelle
    Anforderungen: REQ-PWR-001, REQ-PWR-002
    */
  }

  part def DiagnosticsNode {
    doc /*
    Node: diagnostics_node
    Kurzname: Diagnose
    Schnittstellenidee: Diagnosemeldungen
    Publiziert: /diagnostics
    Anforderungen: REQ-DIAG-001
    Hinweis: Nur Kandidat; noch keine konkreten Diagnosequellen ausgewaehlt.
    */
  }

  // Topics der Kandidaten-Architektur. Typ "offen" heisst: noch nicht entschieden.

  item def GoalPoseTopic {
    doc /*
    Name: /goal_pose
    Typ: Topic/Action offen
    Zweck: Zielvorgabe fuer Navigation
    */
  }

  item def CmdVelTopic {
    doc /*
    Name: /cmd_vel
    Typ: Topic
    Zweck: Geschwindigkeitsvorgabe
    */
  }

  item def OdomTopic {
    doc /*
    Name: /odom
    Typ: Topic
    Zweck: Odometriedaten
    */
  }

  item def MapTopic {
    doc /*
    Name: /map
    Typ: Topic/Service
    Zweck: Grundkarte
    */
  }

  item def LocalObstaclesTopic {
    doc /*
    Name: /local_obstacles
    Typ: Topic
    Zweck: erkannte Hindernisse
    */
  }

  item def MissionStateTopic {
    doc /*
    Name: /mission_state
    Typ: Topic
    Zweck: Missionsstatus
    */
  }

  item def SafetyStateTopic {
    doc /*
    Name: /safety_state
    Typ: Topic
    Zweck: Safety-Zustand und Stoppgrund
    */
  }

  item def BatteryStateTopic {
    doc /*
    Name: /battery_state
    Typ: Topic
    Zweck: Energiezustand
    */
  }

  item def TransportOrderTopic {
    doc /*
    Name: /transport_order
    Typ: Topic
    Zweck: Transportauftrag
    */
  }

  item def OperatorCommandTopic {
    doc /*
    Name: /operator_command
    Typ: Topic
    Zweck: Status, Stopp, Fortsetzung, Rueckkehr
    */
  }

  item def NavigationResultTopic {
    doc /*
    Name: /navigation_result
    Typ: Topic
    Zweck: Ziel erreicht, blockiert, nicht erreichbar
    */
  }

  item def RobotPoseTopic {
    doc /*
    Name: /robot_pose
    Typ: Topic
    Zweck: geschaetzte Pose
    */
  }

  item def MapUpdateCandidateTopic {
    doc /*
    Name: /map_update_candidate
    Typ: Topic
    Zweck: vorgeschlagene dauerhafte Kartenaenderung
    */
  }

  item def DiagnosticsTopic {
    doc /*
    Name: /diagnostics
    Typ: Topic
    Zweck: Diagnosemeldungen
    */
  }

  // Kandidaten-Zuordnung Node -> Teilsystem; keine Allokation, kein Nachweis.
  dependency from MissionManagerNode to MobileMaterialRobot_Structure_A1::MissionSystem;
  dependency from WebInterfaceNode to MobileMaterialRobot_Structure_A1::UserInterfaceSystem;
  dependency from WebInterfaceNode to MobileMaterialRobot_Structure_A1::CommunicationSystem;
  dependency from NavigationNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from MapManagementNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from LocalizationNode to MobileMaterialRobot_Structure_A1::NavigationSystem;
  dependency from PerceptionNode to MobileMaterialRobot_Structure_A1::PerceptionSystem;
  dependency from MotionControllerNode to MobileMaterialRobot_Structure_A1::MotionSystem;
  dependency from SafetySupervisorNode to MobileMaterialRobot_Structure_A1::SafetySystem;
  dependency from EnergyMonitorNode to MobileMaterialRobot_Structure_A1::EnergySystem;
  dependency from DiagnosticsNode to MobileMaterialRobot_Structure_A1::DiagnosticsSystem;
}
