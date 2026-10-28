"""HTTP integration and deterministic session tests; no display required."""
import http.client
import json
import threading
import unittest

from robot_demo.scenario import load_scenario
from robot_demo.web_server import LocalServer, WebSession


class SessionTests(unittest.TestCase):
    def setUp(self):
        self.now = 100.0
        self.session = WebSession(load_scenario, clock=lambda: self.now)

    def test_start_paused_and_reads_do_not_step(self):
        first = self.session.snapshot()
        for _ in range(20):
            self.session.tick()
            self.session.snapshot()
        self.assertEqual(self.session.snapshot(), first)

    def test_same_core_same_seed_same_trajectory(self):
        reference, dt = load_scenario()
        self.session.command("resume")
        for _ in range(1000):
            self.session.tick()
            reference.step(dt)
        sim = self.session.simulation
        self.assertEqual(sim.pose, reference.pose)
        self.assertEqual(sim.navigator.turns_selected, reference.navigator.turns_selected)
        self.assertEqual(sim.time_s, reference.time_s)
        self.assertGreater(sim.navigator.turns_selected, 0)

    def test_pause_during_turn_retains_operation_rng_and_angle(self):
        self.session.command("resume")
        for _ in range(1000):
            self.session.tick()
            if self.session.simulation.navigator.remaining_turn_rad:
                break
        sim = self.session.simulation
        self.assertNotEqual(sim.navigator.remaining_turn_rad, 0)
        self.session.command("pause")
        before = self.session.snapshot()
        rng = sim.navigator.rng.getstate()
        for _ in range(30):
            self.session.tick()
        self.assertEqual(before, self.session.snapshot())
        self.assertEqual(rng, sim.navigator.rng.getstate())
        self.session.command("resume")
        self.session.tick()
        self.assertLess(abs(sim.navigator.remaining_turn_rad), abs(before["remaining_turn_rad"]))
        self.assertEqual(sim.operation_id, before["operation_id"])

    def test_disconnect_pauses_reconnect_does_not_resume(self):
        self.session.command("resume")
        self.session.tick()
        self.now += 2.01
        self.session.tick()
        self.assertTrue(self.session.simulation.paused)
        before = self.session.snapshot()
        self.session.tick()
        self.assertEqual(before, self.session.snapshot())

    def test_reset_repeats_seed_but_stays_paused(self):
        self.session.command("resume")
        self.session.tick()
        self.session.command("reset")
        state = self.session.snapshot()
        self.assertEqual(state["steps"], 0)
        self.assertEqual(state["mode"], "paused")
        self.assertEqual(state["generation"], 2)
        self.assertEqual(state["seed"], 7)
        self.assertEqual(len(state["trace"]), 1)

    def test_sensor_fault_latches_pause_and_requires_reset(self):
        from robot_demo.core import RangeReading
        class InvalidSensor:
            def read(self, pose):
                return RangeReading(float("nan"))
        self.session.simulation.sensor = InvalidSensor()
        self.session.command("resume")
        self.session.tick()
        state = self.session.snapshot()
        self.assertEqual(state["mode"], "paused")
        self.assertTrue(state["error"])
        with self.assertRaises(ValueError):
            self.session.command("resume")
        self.session.command("reset")
        self.assertIsNone(self.session.snapshot()["error"])


class HTTPTests(unittest.TestCase):
    def setUp(self):
        self.session = WebSession(load_scenario)
        self.server = LocalServer(self.session, 0)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=2)

    def request(self, method, path, body=None, headers=None):
        connection = http.client.HTTPConnection("127.0.0.1", self.server.server_port, timeout=3)
        connection.request(method, path, body, headers or {})
        response = connection.getresponse()
        status, data, mime = response.status, response.read(), response.getheader("Content-Type")
        connection.close()
        return status, data, mime

    def post(self, data):
        return self.request("POST", "/api/command", json.dumps(data), {"Content-Type": "application/json"})

    def test_assets_and_state_are_served_without_advancing(self):
        for path, mime in (("/", "text/html"), ("/app.js", "text/javascript"), ("/style.css", "text/css")):
            status, body, actual = self.request("GET", path)
            self.assertEqual(status, 200)
            self.assertTrue(body)
            self.assertIn(mime, actual)
        state = json.loads(self.request("GET", "/api/state")[1])
        self.assertEqual(state["steps"], 0)
        self.assertEqual(state["mode"], "paused")

    def test_commands_and_negative_requests(self):
        self.assertEqual(self.post({"command": "resume"})[0], 200)
        self.session.tick()
        self.assertGreater(self.session.snapshot()["distance_m"], 0)
        self.assertEqual(self.post({"command": "pause"})[0], 200)
        state = self.session.snapshot()
        for data in ({"command": "drive"}, {"command": "resume", "extra": True}, [], {"command": 7}):
            self.assertEqual(self.post(data)[0], 400)
        self.assertEqual(self.session.snapshot(), state)
        self.assertEqual(self.request("GET", "/api/command")[0], 404)
        self.assertEqual(self.request("GET", "/../scenario.json")[0], 404)
        self.assertEqual(self.request("POST", "/api/command", "bad", {"Content-Type":"application/json"})[0], 400)
        self.assertEqual(self.request("POST", "/api/command", "{}")[0], 415)
        self.assertEqual(self.request("POST", "/api/command", "{}", {"Content-Type":"application/json", "Origin":"https://example.org"})[0], 403)
        self.assertEqual(self.request("GET", "/api/state", headers={"Host":"example.org"})[0], 403)


if __name__ == "__main__":
    unittest.main()
