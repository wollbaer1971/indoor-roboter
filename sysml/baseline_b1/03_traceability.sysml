package MobileMaterialRobot_Traceability_B1 {
  doc /*
  Traceability relationships for Iteration B.

  dependency from <requirements> to <use case>: the requirements are derived
  from that use case. This replaces the UC references that were previously
  kept in the "Source:" lines of the requirements.

  traceability_matrix.md is generated from these relationships with
  sysml/tools/generate_traceability.py. Change the model, not the matrix.
  */

  import MobileMaterialRobot_UseCases_B1::*;
  import MobileMaterialRobot_Requirements_B1::*;

  dependency from acceptOrRejectOrder, webAppOrderTrigger, reportStatusSet
    to UC_B_001_TransportauftragErteilen;

  dependency from carryPlacedCarrier
    to UC_B_002_WerkstuecktraegerBereitstellen;

  dependency from driveToDefinedTarget, multiRoomRoute, determinePoseInArea,
    nominalSpeedMvp, reportStatusSet
    to UC_B_003_AutonomeTransportmissionAusfuehren;

  dependency from detectObstacles, separateTemporaryObstacles, safeStateForObstacles
    to UC_B_004_TemporaeresHindernisBehandeln;

  dependency from reportUnreachableRoute, safeStateForObstacles, reportStatusSet
    to UC_B_005_BlockiertenFahrwegBehandeln;

  dependency from personsSafetyRelevant, separateStopTypes
    to UC_B_006_PersonImFahrbereichBehandeln;

  dependency from separateStopTypes, reportStatusSet
    to UC_B_007_BetrieblichenStoppAusloesen;

  dependency from returnToChargingStation
    to UC_B_008_RueckkehrZurLadestationAusloesen;

  dependency from reportStatusSet
    to UC_B_009_TechnischenFehlerBehandeln;

  dependency from useApprovedBaseMap, separateTemporaryObstacles
    to UC_B_010_KarteUndUmgebungVerwalten;
}
