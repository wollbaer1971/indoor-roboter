import os
import unittest

from robot_demo.core import Mode
from robot_demo.scenario import load_scenario


@unittest.skipUnless(os.environ.get("DISPLAY") or os.name == "nt", "Turtle smoke test needs a display; CI uses Xvfb")
class TurtleSmokeTest(unittest.TestCase):
    def test_draw_pause_resume_and_timer_loop(self):
        from robot_demo.turtle_view import TurtleViewer
        sim, dt = load_scenario()
        viewer = TurtleViewer(sim, dt)
        try:
            self.assertGreater(len(viewer.screen.getcanvas().find_all()), 10)
            viewer.pause()
            self.assertEqual(sim.mode, Mode.PAUSED)
            viewer.resume()
            self.assertEqual(sim.mode, Mode.FORWARD)
            viewer.run(max_steps=4)
            self.assertEqual(sim.steps, 4)
            self.assertGreaterEqual(viewer.rendered_frames, 7)
        finally:
            viewer.close()
