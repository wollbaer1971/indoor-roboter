package MobileMaterialRobot_SimulationVerification_A1 {
  private import MobileMaterialRobot_Simulation_A1::schoolTransportBench;
  private import MobileMaterialRobot_Verification_A1::TC_NAV_002;

  doc /*
  Reuses the existing TC-NAV-002 test and REQ-NAV-004/REQ-NAV-005.
  Does not introduce parallel RobotStructure or RobotVerification packages.
  */

  verification schoolTransportTest : TC_NAV_002 {
    subject redefines testRobot = schoolTransportBench.robot;

    doc /*
    Planned simulation test usage, not a recorded successful execution.
    Numerical tolerances, simulator configuration and results remain open.
    Payload retention is covered separately by REQ-TRN-002; this navigation
    test alone does not establish transport or safety compliance.
    */
  }
}
