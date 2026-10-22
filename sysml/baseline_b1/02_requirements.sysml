package MobileMaterialRobot_Requirements_B1 {
  doc /*
  Candidate Requirements derived in Iteration B.
  They refine Baseline A.1 and will be filtered into the formal MVP scope in
  Iteration C.
  Each requirement carries its project ID as SysML short name, for example
  <'REQ-B-MIS-001'>, and uses the common RobotRequirement type from Baseline A.1.
  */

  import MobileMaterialRobot_Requirements_A1::RobotRequirement;

  requirement <'REQ-B-MIS-001'> acceptOrRejectOrder : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall accept or reject a transport order with unique start
      and target location.
    Verification idea: submit valid, invalid and not executable orders.
    */
  }

  requirement <'REQ-B-UI-001'> webAppOrderTrigger : RobotRequirement {
    doc /*
    Type: interface
    Text: The first version shall trigger transport orders through a web app.
    Verification idea: operator selects start and target; robot receives order.
    */
  }

  requirement <'REQ-B-STA-001'> reportStatusSet : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall report at least ready, accepted, driving, target
      reached, blocked, stopped and fault.
    Verification idea: integration test checks status sequence.
    */
  }

  requirement <'REQ-B-NAV-001'> driveToDefinedTarget : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall autonomously drive to a defined target location.
    Verification idea: system test without manual vehicle control.
    */
  }

  requirement <'REQ-B-NAV-002'> multiRoomRoute : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall execute a route through multiple rooms, a corridor
      and at least one open door.
    Verification idea: route test in school demonstrator or equivalent setup.
    */
  }

  requirement <'REQ-B-NAV-003'> reportUnreachableRoute : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall detect and report when target or route is not reachable.
    Verification idea: block route and expect blocked/not reachable status.
    */
  }

  requirement <'REQ-B-LOC-001'> determinePoseInArea : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall determine its pose in the operating area.
    Verification idea: pose tolerance to be defined.
    */
  }

  requirement <'REQ-B-PER-001'> detectObstacles : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall detect obstacles in the relevant driving area and
      provide them to local navigation.
    Verification idea: obstacle appears in local environment representation.
    */
  }

  requirement <'REQ-B-MAP-001'> useApprovedBaseMap : RobotRequirement {
    doc /*
    Type: functional
    Text: The system shall load an approved base map and use it for navigation.
    Verification idea: load map and plan target route.
    */
  }

  requirement <'REQ-B-MAP-002'> separateTemporaryObstacles : RobotRequirement {
    doc /*
    Type: constraint
    Source: OI-NAV-002
    Text: The system shall distinguish temporary obstacles from long-term map
      information.
    Verification idea: temporary obstacle does not automatically change long-term map.
    */
  }

  requirement <'REQ-B-SAFE-001'> safeStateForObstacles : RobotRequirement {
    doc /*
    Type: safety
    Text: The system shall enter a safe state for obstacles that cannot be
      handled safely.
    Verification idea: no collision, controlled stop, status reported.
    */
  }

  requirement <'REQ-B-SAFE-002'> personsSafetyRelevant : RobotRequirement {
    doc /*
    Type: safety
    Text: The system shall treat persons in the operating area as
      safety-relevant environment elements.
    Verification idea: MVP reduced behavior is stop and report.
    */
  }

  requirement <'REQ-B-SAFE-003'> separateStopTypes : RobotRequirement {
    doc /*
    Type: safety/constraint
    Source: OI-SAFE-001
    Text: OperationalStop, SafetyStop and EmergencyStop shall be conceptually
      and functionally separated.
    Verification idea: review and later safety tests.
    */
  }

  requirement <'REQ-B-PERF-001'> nominalSpeedMvp : RobotRequirement {
    doc /*
    Type: performance
    Source: DEC-007
    Text: MVP nominal speed shall be approximately 0.5 m/s.
    Verification idea: measured driving profile within tolerance to be defined.
    */
  }

  requirement <'REQ-B-PWR-001'> teachingProfileEndurance : RobotRequirement {
    doc /*
    Type: non-functional
    Source: DEC-008, OI-ENE-001
    Text: The first version shall cover a defined teaching profile of
      approximately 2 h.
    Verification idea: endurance test with profile to be defined.
    */
  }

  requirement <'REQ-B-TRN-001'> carryPlacedCarrier : RobotRequirement {
    doc /*
    Type: interface
    Source: SN-TRN-004, OI-MECH-001, OI-MECH-002
    Text: The robot shall carry a manually placed workpiece carrier as payload.
    Verification idea: mechanical payload test after carrier data are known.
    */
  }

  requirement <'REQ-B-ENE-001'> returnToChargingStation : RobotRequirement {
    doc /*
    Type: functional
    Source: OI-ENE-002
    Text: The system shall handle return to charging station as a target or
      operating command.
    Verification idea: MVP test reaches charging station area; docking deferred.
    */
  }
}
