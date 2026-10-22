# Traceability Matrix - Iteration B / Baseline B.1

The tables below are generated from the SysML model (`01_use_cases`,
`02_requirements`, `03_traceability`). Change the model and run
`python3 sysml/tools/generate_traceability.py`, do not edit the tables by hand.

<!-- BEGIN GENERATED: do not edit, run sysml/tools/generate_traceability.py -->

## Use cases

| Use Case | Candidate Requirements | Verification idea | Related Open Issues |
| --- | --- | --- | --- |
| UC-B-001 | REQ-B-MIS-001, REQ-B-UI-001, REQ-B-STA-001 | Web-app order tests | OI-UI-001 |
| UC-B-002 | REQ-B-TRN-001 | Payload interface test after carrier data are known | OI-MECH-001, OI-MECH-002 |
| UC-B-003 | REQ-B-NAV-001, REQ-B-NAV-002, REQ-B-LOC-001, REQ-B-PERF-001, REQ-B-STA-001 | End-to-end route through rooms, corridor and open door | OI-TEST-001, OI-SAFE-002 |
| UC-B-004 | REQ-B-PER-001, REQ-B-MAP-002, REQ-B-SAFE-001 | Obstacle in route, stop or local replan | OI-NAV-002, OI-SAFE-002 |
| UC-B-005 | REQ-B-NAV-003, REQ-B-SAFE-001, REQ-B-STA-001 | Blocked route test | OI-TEST-001 |
| UC-B-006 | REQ-B-SAFE-002, REQ-B-SAFE-003 | Reduced MVP reaction: stop and report | OI-SAFE-001, OI-SAFE-002 |
| UC-B-007 | REQ-B-SAFE-003, REQ-B-STA-001 | OperationalStop review and behavior test | OI-SAFE-001 |
| UC-B-008 | REQ-B-ENE-001 | Navigate to charging station area | OI-ENE-002 |
| UC-B-009 | REQ-B-STA-001 | Fault status and diagnostic review | OI-UI-001 |
| UC-B-010 | REQ-B-MAP-001, REQ-B-MAP-002 | Base map load and temporary obstacle distinction | OI-NAV-001, OI-NAV-002 |

## Requirements without use case

- REQ-B-PWR-001 (Source: DEC-008, OI-ENE-001)

<!-- END GENERATED -->

## Status

Baseline B.1 is a candidate requirements baseline. Iteration C should decide which of these requirements are mandatory for MVP 1, which remain visible interfaces, and which move to later releases.
