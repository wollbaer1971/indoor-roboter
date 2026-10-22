package MobileMaterialRobot_Requirements_A1 {
  doc /*
  Initial system requirements derived from Baseline A.1.
  Each requirement carries its project ID as SysML short name, for example
  <'REQ-MIS-001'>, and a readable declared name. Both can be used in references.
  */

  import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;

  requirement def RobotRequirement {
    doc /* Common requirement type. The subject is the System of Interest. */
    subject robot : MobileMaterialRobot;
  }

  requirement <'REQ-MIS-001'> acceptTransportOrder : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall accept a transport order with start and target location.
    Acceptance: Order is accepted, validated and assigned a mission status.
    */
  }

  requirement <'REQ-MIS-002'> reportOrderStatus : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall report whether a transport order is accepted,
      rejected, paused, blocked or completed.
    Acceptance: Status transitions are visible for operation and testing.
    */
  }

  requirement <'REQ-TRN-001'> transportCarrier : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall transport a workpiece carrier between two defined
      transport locations.
    Acceptance: The carrier reaches the target location in the defined test setup.
    */
  }

  requirement <'REQ-TRN-002'> securePayload : RobotRequirement {
    doc /*
    Type: safety/functional
    Text: The system shall hold or secure the carried workpiece carrier so that
      it does not create an additional hazard during transport.
    Acceptance: The carrier remains within allowed pose limits in the specified
      driving profile.
    */
  }

  requirement <'REQ-MAP-001'> loadBaseMap : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall load an existing base map of the operating area.
    Acceptance: The map is loaded and can be used for localization.
    */
  }

  requirement <'REQ-MAP-002'> detectEnvironmentChanges : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall detect relevant changes in the drivable environment
      during operation.
    Acceptance: An obstacle appears in the local environment representation.
    */
  }

  requirement <'REQ-MAP-003'> separateMapLayers : RobotRequirement {
    doc /*
    Type: constraint
    Text: The system shall distinguish base information, current environment
      information and possible long-term map updates.
    Acceptance: A temporary obstacle does not automatically change the long-term map.
    */
  }

  requirement <'REQ-LOC-001'> determinePose : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall determine its pose inside the defined operating area.
    Acceptance: Pose error remains within a tolerance to be defined in Iteration B.
    */
  }

  requirement <'REQ-NAV-001'> driveToTarget : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall autonomously drive to a selected target location.
    Acceptance: The target is reached without manual vehicle control.
    */
  }

  requirement <'REQ-NAV-002'> considerObstacles : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall consider detected obstacles in path or motion planning.
    Acceptance: The robot stops or locally replans around the obstacle.
    */
  }

  requirement <'REQ-NAV-003'> detectUnreachableTarget : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall detect when a target or route is not reachable.
    Acceptance: The system reports blockage or non-reachability with a clear status.
    */
  }

  requirement <'REQ-NAV-004'> traverseRoomsViaCorridor : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall reach multiple rooms through a connecting corridor.
    Acceptance: Test route includes at least two rooms and one corridor section.
    */
  }

  requirement <'REQ-NAV-005'> passOpenDoors : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall pass open doors in the defined operating area.
    Acceptance: The robot passes an open door without manual vehicle control.
    */
  }

  requirement <'REQ-SAFE-001'> enterSafeStateOnObstacle : RobotRequirement {
    doc /*
    Type: safety
    Text: The system shall transition to a safe state for obstacles that cannot
      be handled safely.
    Acceptance: No contact with the obstacle and blockage status is reported.
    */
  }

  requirement <'REQ-SAFE-002'> considerPersons : RobotRequirement {
    doc /*
    Type: safety
    Text: The system shall consider persons in the operating area as
      safety-relevant for motion decisions.
    Acceptance: Robot slows, stops or selects an alternative according to a later
      safety concept.
    */
  }

  requirement <'REQ-UI-001'> webAppOrderEntry : RobotRequirement {
    doc /*
    Type: functional
    Text: The first version shall accept transport orders through a web app.
    Acceptance: User selects start and target and starts the order.
    */
  }

  requirement <'REQ-UI-002'> basicOperatingCommands : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall provide basic commands for status, operational stop
      and return to charging station.
    Acceptance: Commands can be triggered and produce observable system responses.
    */
  }

  requirement <'REQ-PWR-001'> monitorEnergyState : RobotRequirement {
    doc /*
    Type: non-functional
    Text: The system shall monitor its energy state.
    Acceptance: Low state of charge is detected and reported.
    */
  }

  requirement <'REQ-PWR-002'> operatingTime : RobotRequirement {
    doc /*
    Type: non-functional
    Text: The first version shall cover approximately 2 h of operating time.
    Acceptance: A teaching-block operating profile is defined and achieved.
    */
  }

  requirement <'REQ-PERF-001'> nominalSpeed : RobotRequirement {
    doc /*
    Type: performance
    Text: The MVP nominal speed shall be approximately 0.5 m/s.
    Acceptance: Driving profile is measured within a tolerance to be defined.
    */
  }

  requirement <'REQ-STA-001'> reportOperatingStatus : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall report mission and operating status.
    Acceptance: Status is available to operator or tester.
    */
  }

  requirement <'REQ-ARCH-001'> functionTraceability : RobotRequirement {
    doc /*
    Type: constraint
    Text: Each essential function shall be traceable to at least one logical
      system element and verification idea.
    Acceptance: Traceability matrix has no empty core columns for MVP items.
    */
  }
}
