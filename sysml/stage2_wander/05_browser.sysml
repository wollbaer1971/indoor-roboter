package MobileRobot_Wander_Browser {
  private import ScalarValues::*;
  private import VerificationCases::*;
  private import StandardViewDefinitions::*;
  private import MobileRobot_Wander_Architecture::*;

  item def SimulationSnapshot {
    doc /* Engineering subset of GET /api/state. JSON mapping and full payload: docs/browser-simulation.md. */
    attribute x_m : Real;
    attribute y_m : Real;
    attribute heading_rad : Real;
    attribute time_s : Real;
    attribute modeName : String;
    attribute remainingTurn_rad : Real;
    attribute operationId : String;
  }
  enum def SimulationCommandKind { pause; resume; reset; }
  item def SimulationControlCommand {
    attribute kind : SimulationCommandKind;
    attribute manualRelease : Boolean;
    doc /* Browser button resume maps to explicit manualRelease=true in WebSession.command.
    GET/polling/reconnect never grants release. Reset creates a paused new run. */
  }
  port def BrowserControlPort {
    out item controlCommand : SimulationControlCommand;
    in item snapshot : SimulationSnapshot;
  }
  part def BrowserVisualization :> SimulationVisualization {
    port simulationPort : BrowserControlPort;
    doc /* HTML Canvas consumes authoritative snapshots. No motion integration or navigation in JavaScript. */
  }
  part def BrowserSimulation :> ReactiveSimulation {
    port browserPort : ~BrowserControlPort;
    part redefines viewer : BrowserVisualization;
    connect browserPort to viewer.simulationPort;
    doc /* Implementation: robot_demo/web_server.py, WebSession and LocalServer.
    Same inherited robot/world and Python core as Turtle. One local shared session.
    Starts paused, fixed-step Python clock, bounded trace. Missing state polling
    pauses after the adapter's two-second connection timeout; reconnect stays paused.
    This timeout is an adapter choice, not a physical robot safety requirement. */
  }
  part browserDemo : BrowserSimulation;

  requirement NEED_WEB_001 {
    subject simulation : ReactiveSimulation;
    doc /* Teaching need: observe and control the existing minimal simulation in a browser. */
  }
  constraint def BrowserAdapterCriterion {
    in attribute observationsAvailable : Boolean;
    in attribute sameCore : Boolean;
    in attribute snapshotOnlyRendering : Boolean;
    in attribute manualResumeOnly : Boolean;
    observationsAvailable and sameCore and snapshotOnlyRendering and manualResumeOnly
  }
  requirement REQ_WEB_001 {
    subject simulation : BrowserSimulation;
    in attribute observationsAvailable : Boolean;
    in attribute sameCore : Boolean;
    in attribute snapshotOnlyRendering : Boolean;
    in attribute manualResumeOnly : Boolean;
    require constraint criterion : BrowserAdapterCriterion {
      in attribute redefines observationsAvailable = REQ_WEB_001::observationsAvailable;
      in attribute redefines sameCore = REQ_WEB_001::sameCore;
      in attribute redefines snapshotOnlyRendering = REQ_WEB_001::snapshotOnlyRendering;
      in attribute redefines manualResumeOnly = REQ_WEB_001::manualResumeOnly;
    }
    doc /* Display/control adapter reuses the simulation core, renders received state
    and resumes paused operation only through explicit manual release.
    Missing observations must not be reported as a successful verification. */
  }
  verification def TC_WEB_001 {
    subject simulation : BrowserSimulation;
    doc /* Execute tests/test_web_server.py and tools/test_web_browser.cjs.
    Observe same-seed core parity, real Canvas rendering, pause/manual resume,
    reset, reconnect and invalid commands. No verdict assigned without a run.
    Evidence and source commit are recorded in docs/browser-simulation.md. */
    objective { verify REQ_WEB_001; }
  }
  dependency from REQ_WEB_001 to NEED_WEB_001;
  dependency from BrowserSimulation to REQ_WEB_001;
  dependency from BrowserVisualization to REQ_WEB_001;
  view browserArchitecture : InterconnectionView { expose BrowserSimulation; }
}
