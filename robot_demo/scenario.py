from __future__ import annotations

import json
import math
from pathlib import Path
from .core import Parameters, Simulation
from .geometry import Pose, Rectangle, World

DEFAULT_SCENARIO = Path(__file__).with_name("scenario.json")


def load_scenario(path: Path | str = DEFAULT_SCENARIO, seed: int | None = None):
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    world_data, robot, pose = data["world"], data["robot"], data["initial_pose"]
    world = World(world_data["width_m"], world_data["height_m"],
                  tuple(Rectangle(*r) for r in world_data["obstacles_m"]))
    parameters = Parameters(robot["radius_m"], robot["speed_m_s"],
                            math.radians(robot["turn_rate_deg_s"]), robot["sensor_range_m"],
                            robot["detection_distance_m"], math.radians(robot["min_turn_deg"]),
                            math.radians(robot["max_turn_deg"]))
    initial = Pose(pose["x_m"], pose["y_m"], math.radians(pose["heading_deg"]))
    dt = data["step_s"]
    if not math.isfinite(dt) or dt <= 0:
        raise ValueError("step_s must be finite and positive")
    sim = Simulation(world, parameters, initial, data["seed"] if seed is None else seed)
    return sim, dt
