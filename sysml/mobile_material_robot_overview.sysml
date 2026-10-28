package MobileMaterialRobot {
  doc /*
  Compatibility facade for the earlier sketch. These are aliases/imports of
  canonical A.1 definitions, not a second robot architecture.
  Load the complete sysml directory rather than this file in isolation.
  */
  public import MobileMaterialRobot_Structure_A1::*;
  alias MobileMaterialTransportRobot for MobileMaterialRobot_Structure_A1::MobileMaterialRobot;
  alias UserInterface for MobileMaterialRobot_Structure_A1::UserInterfaceSystem;
}
