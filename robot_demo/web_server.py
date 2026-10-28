"""Local browser adapter. Simulation state and fixed steps stay in Python."""
from __future__ import annotations

import argparse
from collections import deque
from dataclasses import asdict
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import threading
import time

from .scenario import DEFAULT_SCENARIO, load_scenario

STATIC = Path(__file__).with_name("web")


class WebSession:
    """One shared local session, independent of browser rendering/poll rate.

    Pauses after two seconds without a successful state request. No automatic
    resume on reconnect. The trace retains only the latest 4000 moving poses.
    """
    def __init__(self, factory, clock=time.monotonic):
        self.factory, self.clock = factory, clock
        self.lock = threading.Lock()
        self.last_seen = clock()
        self.error = None
        self.generation = 0
        self._reset()

    def _reset(self):
        simulation, dt = self.factory()
        simulation.pause()
        self.simulation, self.dt = simulation, dt
        self.trace = deque([(simulation.pose.x, simulation.pose.y)], maxlen=4000)
        self.error = None
        self.generation += 1

    def tick(self):
        with self.lock:
            sim = self.simulation
            if self.clock() - self.last_seen > 2.0:
                sim.pause()
            if not sim.paused:
                try:
                    old = sim.pose
                    sim.step(self.dt)
                    if (old.x, old.y) != (sim.pose.x, sim.pose.y):
                        self.trace.append((sim.pose.x, sim.pose.y))
                except Exception as error:
                    sim.pause()
                    self.error = str(error)

    def command(self, command):
        with self.lock:
            if command == "pause":
                self.simulation.pause()
            elif command == "resume":
                if self.error:
                    raise ValueError("Simulationsfehler: zuerst zuruecksetzen")
                if self.simulation.paused and not self.simulation.resume(manual_release=True):
                    raise ValueError("Manuelle Fortsetzung wurde abgelehnt")
                self.last_seen = self.clock()
            elif command == "reset":
                self._reset()
                self.last_seen = self.clock()
            else:
                raise ValueError("Unbekannter Befehl")

    def snapshot(self):
        with self.lock:
            self.last_seen = self.clock()
            sim = self.simulation
            # Fresh reading at current pose; core's last_reading precedes motion.
            clearance = sim.world.free_distance(sim.pose, sim.parameters.radius_m,
                                                sim.parameters.sensor_range_m)
            return {
                "generation": self.generation, "operation_id": sim.operation_id,
                "pose": asdict(sim.pose), "mode": sim.mode.value,
                "navigation_mode": sim.navigator.mode.value,
                "remaining_turn_rad": sim.navigator.remaining_turn_rad,
                "world": asdict(sim.world), "parameters": asdict(sim.parameters),
                "clearance_m": clearance, "trace": list(self.trace),
                "steps": sim.steps, "time_s": sim.time_s, "step_s": self.dt,
                "distance_m": sim.distance_m, "turns": sim.navigator.turns_selected,
                "seed": sim.seed, "error": self.error,
            }


class LocalServer(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(self, session, port=8765):
        self.session = session
        super().__init__(("127.0.0.1", port), Handler)
        self.authority = f"127.0.0.1:{self.server_port}"


class Handler(BaseHTTPRequestHandler):
    def setup(self):
        super().setup()
        self.connection.settimeout(5)

    def log_message(self, *args):
        pass

    def _reply(self, status, data, content_type="application/json; charset=utf-8"):
        if not isinstance(data, bytes):
            data = json.dumps(data, allow_nan=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; frame-ancestors 'none'")
        self.end_headers()
        self.wfile.write(data)

    def _local_request(self):
        authority = self.server.authority
        if self.headers.get("Host") != authority:
            self._reply(403, {"error": "Nur die lokale Serveradresse ist erlaubt"})
            return False
        origin = self.headers.get("Origin")
        if origin is not None and origin != f"http://{authority}":
            self._reply(403, {"error": "Fremder Origin abgelehnt"})
            return False
        return True

    def do_GET(self):
        if not self._local_request():
            return
        if self.path == "/api/state":
            self._reply(200, self.server.session.snapshot())
            return
        routes = {"/": ("index.html", "text/html; charset=utf-8"),
                  "/app.js": ("app.js", "text/javascript; charset=utf-8"),
                  "/style.css": ("style.css", "text/css; charset=utf-8")}
        if self.path not in routes:
            self._reply(404, {"error": "Nicht gefunden"})
            return
        name, mime = routes[self.path]
        self._reply(200, (STATIC / name).read_bytes(), mime)

    def do_POST(self):
        self.close_connection = True
        if not self._local_request():
            return
        if self.path != "/api/command":
            self._reply(404, {"error": "Nicht gefunden"})
            return
        if self.headers.get("Content-Type") != "application/json":
            self._reply(415, {"error": "application/json erforderlich"})
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if not 0 < length <= 1024:
                raise ValueError("Ungueltige Nachrichtenlaenge")
            data = json.loads(self.rfile.read(length))
            if not isinstance(data, dict) or set(data) != {"command"} or not isinstance(data["command"], str):
                raise ValueError("Erwartet: genau ein command-Textfeld")
            self.server.session.command(data["command"])
            self._reply(200, self.server.session.snapshot())
        except (ValueError, UnicodeError, OSError) as error:
            self._reply(400, {"error": str(error)})


def run(session, port=8765):
    stop = threading.Event()
    # A single clock owner; browser GETs never advance simulation time.
    def tick_loop():
        while not stop.wait(session.dt):
            session.tick()

    with LocalServer(session, port) as server:
        ticker = threading.Thread(target=tick_loop, daemon=True)
        ticker.start()
        print(f"Browser oeffnen: http://{server.authority}\nStart pausiert. Beenden: Strg+C.", flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass
        finally:
            stop.set()
            ticker.join(timeout=2)


def main(argv=None):
    parser = argparse.ArgumentParser(description="Lokale Browseransicht des Roboter-Demonstrators")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--scenario", type=Path, default=DEFAULT_SCENARIO)
    parser.add_argument("--seed", type=int)
    args = parser.parse_args(argv)
    if not 1 <= args.port <= 65535:
        parser.error("Port muss zwischen 1 und 65535 liegen")
    try:
        run(WebSession(lambda: load_scenario(args.scenario, args.seed)), args.port)
    except (ValueError, KeyError, TypeError, OSError) as error:
        parser.exit(2, f"Fehler: {error}\n")


if __name__ == "__main__":
    main()
