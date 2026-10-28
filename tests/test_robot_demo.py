import contextlib
import io
import math
from pathlib import Path
import random
import tempfile
import unittest
import xml.etree.ElementTree as ET

from robot_demo.__main__ import main
from robot_demo.core import (KinematicDrive, Mode, Parameters, RandomTurnNavigator,
                             RangeReading, Simulation, VelocityCommand)
from robot_demo.geometry import Pose, Rectangle, World
from robot_demo.scenario import load_scenario


def parameters(**overrides):
    values = dict(radius_m=0.2, speed_m_s=0.5, turn_rate_rad_s=math.pi/2,
                  sensor_range_m=1.5, detection_distance_m=0.3,
                  min_turn_rad=math.pi/4, max_turn_rad=math.pi*5/6)
    return Parameters(**{**values, **overrides})


class GeometryTests(unittest.TestCase):
    def test_wall_distance_is_measured_from_robot_footprint(self):
        self.assertAlmostEqual(World(10, 10).free_distance(Pose(1, 1), 0.2), 8.8)

    def test_sensor_range_clips_distance(self):
        self.assertEqual(World(10, 10).free_distance(Pose(1, 1), 0.2, 1.5), 1.5)

    def test_rounded_obstacle_corner(self):
        world = World(10, 10, (Rectangle(4, 4, 5, 5),))
        self.assertAlmostEqual(world.free_distance(Pose(1, 1, math.pi/4), 0.5), math.hypot(3, 3)-0.5)

    def test_obstacle_beside_centre_ray_still_blocks_footprint(self):
        world = World(10, 10, (Rectangle(4, 1.1, 5, 2),))
        self.assertAlmostEqual(world.free_distance(Pose(1, 1), 0.2), 3-math.sqrt(0.03))

    def test_contact_and_penetration_are_not_free(self):
        world = World(10, 10, (Rectangle(4, 1, 5, 2),))
        self.assertFalse(world.is_free(Pose(3.8, 1.5), 0.2))
        self.assertFalse(world.is_free(Pose(4.5, 1.5), 0.2))


class NavigationTests(unittest.TestCase):
    def test_clear_path_commands_straight_motion(self):
        nav = RandomTurnNavigator(parameters(), random.Random(7))
        self.assertEqual(nav.command(RangeReading(1.5), 0.05), VelocityCommand(0.5, 0.0))

    def test_detection_stops_before_selecting_turn(self):
        nav = RandomTurnNavigator(parameters(), random.Random(7))
        self.assertEqual(nav.command(RangeReading(0.2), 0.05), VelocityCommand())
        self.assertEqual(nav.mode, Mode.TURNING)
        self.assertEqual(nav.turns_selected, 1)

    def test_turns_are_bounded_random_and_in_place(self):
        nav = RandomTurnNavigator(parameters(), random.Random(7))
        selected = []
        for _ in range(50):
            nav.mode = Mode.FORWARD
            nav.command(RangeReading(0.1), 0.05)
            selected.append(nav.remaining_turn_rad)
            self.assertGreaterEqual(abs(nav.remaining_turn_rad), math.pi/4)
            self.assertLessEqual(abs(nav.remaining_turn_rad), math.pi*5/6)
            command = nav.command(RangeReading(0.1), 0.05)
            self.assertEqual(command.linear_m_s, 0.0)
            self.assertLessEqual(abs(command.angular_rad_s), parameters().turn_rate_rad_s)
        self.assertGreater(len(set(selected)), 40)
        self.assertTrue(any(a < 0 for a in selected))
        self.assertTrue(any(a > 0 for a in selected))

    def test_finished_turn_rechecks_and_repeats_when_still_blocked(self):
        nav = RandomTurnNavigator(parameters(), random.Random(7))
        nav.command(RangeReading(0.1), 0.05)
        while abs(nav.remaining_turn_rad) > 1e-9:
            nav.command(RangeReading(0.1), 0.05)
        self.assertEqual(nav.command(RangeReading(0.1), 0.05), VelocityCommand())
        self.assertEqual(nav.mode, Mode.TURNING)
        self.assertEqual(nav.turns_selected, 2)

    def test_finished_turn_allows_forward_only_after_clear_reading(self):
        nav = RandomTurnNavigator(parameters(), random.Random(7))
        nav.command(RangeReading(0.1), 0.05)
        while abs(nav.remaining_turn_rad) > 1e-9:
            nav.command(RangeReading(0.1), 0.05)
        self.assertEqual(nav.command(RangeReading(1.5), 0.05), VelocityCommand())
        self.assertEqual(nav.mode, Mode.FORWARD)
        self.assertEqual(nav.command(RangeReading(1.5), 0.05).linear_m_s, 0.5)


class SimulationTests(unittest.TestCase):
    def test_straight_motion_uses_seconds_and_metres(self):
        sim = Simulation(World(10, 10), parameters(), Pose(1, 1))
        sim.step(0.5)
        self.assertAlmostEqual(sim.pose.x, 1.25)
        self.assertAlmostEqual(sim.pose.y, 1.0)

    def test_large_step_does_not_tunnel_through_thin_obstacle(self):
        world = World(10, 10, (Rectangle(4, 0, 4.01, 10),))
        drive = KinematicDrive(world, parameters())
        pose = drive.apply(Pose(1, 1), VelocityCommand(0.5, 0), 100)
        self.assertAlmostEqual(pose.x, 3.5)
        self.assertTrue(world.is_free(pose, 0.2))

    def test_long_runs_for_multiple_seeds_keep_robot_clear(self):
        for seed in range(6):
            sim, dt = load_scenario(seed=seed)
            for _ in range(4000):
                sim.step(dt)
                self.assertTrue(sim.world.is_free(sim.pose, sim.parameters.radius_m))
            self.assertGreater(sim.navigator.turns_selected, 5)
            self.assertGreater(sim.distance_m, 15)

    def test_seed_reproduces_whole_motion(self):
        a, dt = load_scenario(seed=5)
        b, _ = load_scenario(seed=5)
        c, _ = load_scenario(seed=6)
        for _ in range(1200):
            a.step(dt); b.step(dt); c.step(dt)
            self.assertEqual(a.pose, b.pose)
            self.assertEqual(a.mode, b.mode)
        self.assertNotEqual(a.pose, c.pose)

    def test_pause_keeps_turn_progress_pose_and_operation(self):
        sim = Simulation(World(10, 10), parameters(), Pose(9.6, 2))
        sim.step(); sim.step()
        self.assertEqual(sim.mode, Mode.TURNING)
        sim.pause()
        before = (sim.pose, sim.navigator.remaining_turn_rad, sim.navigator.rng.getstate(), sim.operation_id)
        for _ in range(100):
            sim.step()
            self.assertEqual(sim.last_command, VelocityCommand())
        self.assertEqual(before, (sim.pose, sim.navigator.remaining_turn_rad,
                                 sim.navigator.rng.getstate(), sim.operation_id))
        self.assertFalse(sim.resume())
        self.assertEqual(sim.mode, Mode.PAUSED)
        self.assertTrue(sim.resume(manual_release=True))
        self.assertEqual(sim.mode, Mode.TURNING)
        sim.step()
        self.assertNotEqual(sim.pose.heading, before[0].heading)

    def test_invalid_sensor_pauses_and_retains_pose(self):
        class BrokenSensor:
            def read(self, pose):
                return RangeReading(float("nan"))
        sim = Simulation(World(10, 10), parameters(), Pose(1, 1), sensor=BrokenSensor())
        with self.assertRaises(ValueError):
            sim.step()
        self.assertEqual(sim.mode, Mode.PAUSED)
        self.assertEqual(sim.pose, Pose(1, 1))

    def test_invalid_pose_and_configuration_are_rejected(self):
        for function in (lambda: Pose(1, 1, float("nan")),
                         lambda: parameters(speed_m_s=-1),
                         lambda: parameters(min_turn_rad=0),
                         lambda: parameters(detection_distance_m=2),
                         lambda: Simulation(World(10, 10), parameters(), Pose(0.1, 1))):
            with self.assertRaises(ValueError):
                function()

    def test_invalid_time_step_does_not_advance(self):
        sim, _ = load_scenario()
        for dt in (0, -1, float("nan"), float("inf")):
            with self.assertRaises(ValueError):
                sim.step(dt)
        self.assertEqual(sim.steps, 0)

    def test_headless_cli_writes_valid_trace_svg(self):
        with tempfile.TemporaryDirectory() as temporary:
            svg = Path(temporary)/"trace.svg"
            with contextlib.redirect_stdout(io.StringIO()) as output:
                result = main(["--headless", "--steps", "1000", "--seed", "7", "--svg", str(svg)])
            self.assertEqual(result, 0)
            self.assertIn('"steps": 1000', output.getvalue())
            root = ET.parse(svg).getroot()
            self.assertTrue(root.tag.endswith("svg"))
            points = root.find(".//{http://www.w3.org/2000/svg}polyline").get("points").split()
            self.assertEqual(len(points), 1001)


if __name__ == "__main__":
    unittest.main()
