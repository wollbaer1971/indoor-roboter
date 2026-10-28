"""Reusable navigation, sensing and kinematic motion; no graphics imports."""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import math
import random
from typing import Protocol

from .geometry import EPS, Pose, World


class Mode(str, Enum):
    FORWARD = "forward"
    TURNING = "turning"
    PAUSED = "paused"


@dataclass(frozen=True)
class Parameters:
    radius_m: float
    speed_m_s: float
    turn_rate_rad_s: float
    sensor_range_m: float
    detection_distance_m: float
    min_turn_rad: float
    max_turn_rad: float

    def __post_init__(self):
        values = tuple(self.__dict__.values())
        if not all(math.isfinite(v) and v > 0.0 for v in values):
            raise ValueError("All robot parameters must be finite and positive")
        if self.detection_distance_m >= self.sensor_range_m:
            raise ValueError("Detection distance must be smaller than sensor range")
        if self.min_turn_rad > self.max_turn_rad or self.max_turn_rad > math.pi:
            raise ValueError("Turn bounds must satisfy 0 < min <= max <= pi")


@dataclass(frozen=True)
class VelocityCommand:
    linear_m_s: float = 0.0
    angular_rad_s: float = 0.0


@dataclass(frozen=True)
class RangeReading:
    forward_clearance_m: float


class RangeSensor(Protocol):
    def read(self, pose: Pose) -> RangeReading: ...


class SimulatedRangeSensor:
    """Ideal forward footprint-clearance sensor, not a specific real sensor."""
    def __init__(self, world: World, parameters: Parameters):
        self.world, self.parameters = world, parameters

    def read(self, pose: Pose) -> RangeReading:
        return RangeReading(self.world.free_distance(
            pose, self.parameters.radius_m, self.parameters.sensor_range_m))


class RandomTurnNavigator:
    """Consumes sensor readings only; does not access ground-truth world/pose."""
    def __init__(self, parameters: Parameters, rng: random.Random):
        self.parameters, self.rng = parameters, rng
        self.mode = Mode.FORWARD
        self.remaining_turn_rad = 0.0
        self.turns_selected = 0
        self.last_selected_turn_rad = 0.0

    def _choose_turn(self):
        magnitude = self.rng.uniform(self.parameters.min_turn_rad, self.parameters.max_turn_rad)
        self.remaining_turn_rad = magnitude*self.rng.choice((-1, 1))
        self.last_selected_turn_rad = self.remaining_turn_rad
        self.turns_selected += 1
        self.mode = Mode.TURNING

    def command(self, reading: RangeReading, dt: float) -> VelocityCommand:
        blocked = reading.forward_clearance_m <= self.parameters.detection_distance_m+EPS
        if self.mode == Mode.FORWARD:
            if blocked:
                self._choose_turn()
                return VelocityCommand()
            return VelocityCommand(linear_m_s=self.parameters.speed_m_s)
        if abs(self.remaining_turn_rad) > EPS:
            angle = math.copysign(min(abs(self.remaining_turn_rad),
                                      self.parameters.turn_rate_rad_s*dt), self.remaining_turn_rad)
            self.remaining_turn_rad -= angle
            return VelocityCommand(angular_rad_s=angle/dt)
        # The completed turn was applied on the previous tick. Re-read first.
        if blocked:
            self._choose_turn()
        else:
            self.mode = Mode.FORWARD
        return VelocityCommand()


class KinematicDrive:
    """Straight motion and in-place rotation; simulation collision guard.

    No inertia, wheel slip, motor model, contact forces or arc motion.
    """
    def __init__(self, world: World, parameters: Parameters):
        self.world, self.parameters = world, parameters

    def apply(self, pose: Pose, command: VelocityCommand, dt: float) -> Pose:
        if not all(math.isfinite(v) for v in (command.linear_m_s, command.angular_rad_s)):
            raise ValueError("Motion command must be finite")
        if command.linear_m_s < 0 or (command.linear_m_s and command.angular_rad_s):
            raise ValueError("This demonstrator supports forward OR in-place turn only")
        if command.linear_m_s:
            # Query the complete swept path, even for an unusually large dt.
            available = self.world.free_distance(pose, self.parameters.radius_m)
            distance = min(command.linear_m_s*dt,
                           max(0.0, available-self.parameters.detection_distance_m))
            return Pose(pose.x+distance*math.cos(pose.heading),
                        pose.y+distance*math.sin(pose.heading), pose.heading)
        return Pose(pose.x, pose.y, (pose.heading+command.angular_rad_s*dt) % math.tau)


def resume_permitted(is_paused, manual_release, safe_to_move, operation_available):
    """Same explicit manual-release policy as the existing SysML model."""
    return is_paused and manual_release and safe_to_move and operation_available


class Simulation:
    def __init__(self, world: World, parameters: Parameters, initial_pose: Pose,
                 seed: int = 7, sensor: RangeSensor | None = None):
        if not world.is_free(initial_pose, parameters.radius_m):
            raise ValueError("Initial robot footprint touches a wall or obstacle")
        self.world, self.parameters, self.pose = world, parameters, initial_pose
        self.seed = seed
        self.sensor = sensor or SimulatedRangeSensor(world, parameters)
        self.navigator = RandomTurnNavigator(parameters, random.Random(seed))
        self.drive = KinematicDrive(world, parameters)
        self.operation_id = "reactive-wander-demo"
        self.paused = False
        self.steps = 0
        self.time_s = 0.0
        self.distance_m = 0.0
        self.last_command = VelocityCommand()
        self.last_reading = self.sensor.read(self.pose)

    @property
    def mode(self):
        return Mode.PAUSED if self.paused else self.navigator.mode

    def pause(self):
        self.paused = True
        self.last_command = VelocityCommand()

    def resume(self, manual_release: bool = False) -> bool:
        if not resume_permitted(self.paused, manual_release,
                                self.world.is_free(self.pose, self.parameters.radius_m),
                                bool(self.operation_id)):
            return False
        self.paused = False
        return True

    def step(self, dt: float = 0.05):
        if not math.isfinite(dt) or dt <= 0:
            raise ValueError("dt must be finite and positive")
        self.last_reading = self.sensor.read(self.pose)
        if not math.isfinite(self.last_reading.forward_clearance_m) or self.last_reading.forward_clearance_m < 0:
            self.pause()
            raise ValueError("Invalid range reading: simulation paused")
        old = self.pose
        self.last_command = VelocityCommand() if self.paused else self.navigator.command(self.last_reading, dt)
        self.pose = self.drive.apply(old, self.last_command, dt)
        if not self.world.is_free(self.pose, self.parameters.radius_m):
            self.pose = old
            self.pause()
            raise RuntimeError("Collision guard rejected the pose")
        self.distance_m += math.hypot(self.pose.x-old.x, self.pose.y-old.y)
        self.steps += 1
        self.time_s += dt
        return self.pose
