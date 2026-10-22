package MobileMaterialRobot {

  part def MobileMaterialTransportRobot {
    part missionSystem : MissionSystem;
    part transportSystem : TransportSystem;
    part navigationSystem : NavigationSystem;
    part perceptionSystem : PerceptionSystem;
    part motionSystem : MotionSystem;
    part energySystem : EnergySystem;
    part safetySystem : SafetySystem;
    part communicationSystem : CommunicationSystem;
    part userInterface : UserInterface;
  }

  part def MissionSystem;
  part def TransportSystem;
  part def NavigationSystem;
  part def PerceptionSystem;
  part def MotionSystem;
  part def EnergySystem;
  part def SafetySystem;
  part def CommunicationSystem;
  part def UserInterface;

}
