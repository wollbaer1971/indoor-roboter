package MobileMaterialRobot_Verification_A1 {
  doc /*
  Verification cases for Baseline A.1. Test definitions are starter artifacts
  and need concrete preconditions, measurement tolerances and test environment
  details in Iteration B.

  Each verification case carries its test ID as SysML short name, for example
  <'TC-MAP-001'>. The verified requirements are referenced inside the
  objective block. Note: "verify loadBaseMap;" references the existing
  requirement, while "verify requirement loadBaseMap;" would declare a new one.
  */

  import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  import MobileMaterialRobot_Requirements_A1::*;

  verification def <'TC-MAP-001'> BaseMapLoadTest {
    doc /*
    Precondition: Base map file exists.
    Action: Load base map.
    Expected: Map is available and referenced by localization/navigation.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify loadBaseMap;               // REQ-MAP-001
    }
  }

  verification def <'TC-MAP-002'> TemporaryObstacleMapSeparationTest {
    doc /*
    Action: Add a temporary obstacle to the local environment.
    Expected: Long-term map is not automatically changed.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify separateMapLayers;         // REQ-MAP-003
    }
  }

  verification def <'TC-LOC-001'> PoseEstimationTest {
    doc /*
    Action: Estimate robot pose in known map.
    Expected: Pose estimate stays within a tolerance to be defined.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify determinePose;             // REQ-LOC-001
    }
  }

  verification def <'TC-NAV-001'> AutonomousTargetDriveTest {
    doc /*
    Action: Start mission to a known target.
    Expected: Robot reaches target without manual vehicle control.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify driveToTarget;             // REQ-NAV-001
    }
  }

  verification def <'TC-NAV-002'> MultiRoomRouteTest {
    doc /*
    Action: Drive route through at least two rooms, a corridor and one open door.
    Expected: Route is completed autonomously.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify traverseRoomsViaCorridor;  // REQ-NAV-004
      verify passOpenDoors;             // REQ-NAV-005
    }
  }

  verification def <'TC-OBS-001'> ObstacleDetectionTest {
    doc /*
    Action: Place obstacle in front of planned route.
    Expected: Obstacle is detected and robot stops or safely replans.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify detectEnvironmentChanges;  // REQ-MAP-002
      verify considerObstacles;         // REQ-NAV-002
      verify enterSafeStateOnObstacle;  // REQ-SAFE-001
    }
  }

  verification def <'TC-OBS-002'> BlockedRouteTest {
    doc /*
    Action: Block route so no safe alternative is available.
    Expected: Robot stops and reports blocked route.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify detectUnreachableTarget;   // REQ-NAV-003
      verify enterSafeStateOnObstacle;  // REQ-SAFE-001
      verify reportOperatingStatus;     // REQ-STA-001
    }
  }

  verification def <'TC-UI-001'> WebAppOrderTest {
    doc /*
    Action: User creates transport order in web app.
    Expected: Robot accepts or rejects order with clear status.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify webAppOrderEntry;          // REQ-UI-001
    }
  }

  verification def <'TC-UI-002'> BasicCommandTest {
    doc /*
    Action: Trigger status, operational stop and return-to-charging command.
    Expected: Each command creates the expected observable system response.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify basicOperatingCommands;    // REQ-UI-002
    }
  }

  verification def <'TC-STA-001'> MissionStatusTest {
    doc /*
    Source: chapters/10_verifikation_traceability.tex
    Action: Run a mission through its status changes.
    Expected: Status changes are reported correctly.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify reportOperatingStatus;     // REQ-STA-001
    }
  }

  verification def <'TC-PWR-001'> LowEnergyTest {
    doc /*
    Source: chapters/10_verifikation_traceability.tex
    Action: Simulate or reach a low state of charge.
    Expected: A warning is generated and the mission can be evaluated.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify monitorEnergyState;        // REQ-PWR-001
    }
  }

  verification def <'TC-TRC-001'> TraceabilityReview {
    doc /*
    Source: chapters/10_verifikation_traceability.tex
    Action: Review the generated traceability matrix.
    Expected: Every MVP requirement is linked to function, element, interface
      and test.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify functionTraceability;      // REQ-ARCH-001
    }
  }

  verification def <'TC-PWR-002'> OperatingTimeTest {
    doc /*
    Action: Run defined teaching-block operating profile.
    Expected: System covers approximately 2 h without intermediate charging.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify operatingTime;             // REQ-PWR-002
    }
  }

  verification def <'TC-PERF-001'> NominalSpeedTest {
    doc /*
    Action: Measure driving profile during nominal movement.
    Expected: Nominal speed is approximately 0.5 m/s within defined tolerance.
    */
    subject robot : MobileMaterialRobot;
    objective {
      verify nominalSpeed;              // REQ-PERF-001
    }
  }
}
