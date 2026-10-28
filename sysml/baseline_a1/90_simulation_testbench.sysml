package MobileMaterialRobot_Simulation_A1 {
  private import MobileMaterialRobot_Structure_A1::MobileMaterialRobot;

  doc /*
  Logical simulation test environment, initially without real hardware.
  Simulator, geometry, mass, friction, sensors and energy model remain open.
  This structure does not implement physics or start a simulator.
  */

  part def SimulationWorld {
    doc /* Rooms, corridor, open doors and environment/contact physics. */
  }

  part def ControllerAdapter {
    doc /*
    Test-side execution/communication adapter for the robot control software.
    Does not duplicate the mission/navigation responsibilities already
    contained in MobileMaterialRobot. Deployment and interfaces remain open.
    */
  }

  part def SimulationObserver {
    doc /*
    Collects simulator reference data for verification, separate from
    simulated onboard sensor data. Ground truth must not implicitly
    become an input to the navigation software.
    */
  }

  part def SimulationTestBench {
    part robot : MobileMaterialRobot;
    part world : SimulationWorld;
    part controller : ControllerAdapter;
    part observer : SimulationObserver;
  }

  part schoolTransportBench : SimulationTestBench;
}
