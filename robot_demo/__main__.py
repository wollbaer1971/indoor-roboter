from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

from .scenario import DEFAULT_SCENARIO, load_scenario
from .svg_view import write_svg


def main(argv=None):
    parser = argparse.ArgumentParser(description="Reaktiver Roboter: geradeaus, Hindernis erkennen, zufaellig drehen.")
    parser.add_argument("--scenario", type=Path, default=DEFAULT_SCENARIO)
    parser.add_argument("--seed", type=int, help="Reproduzierbarer Zufall; sonst Seed aus Beispielszenario")
    parser.add_argument("--headless", action="store_true", help="Ohne Turtle-Fenster ausfuehren")
    parser.add_argument("--steps", type=int, default=3000, help="Schritte im Headless-Modus")
    parser.add_argument("--svg", type=Path, help="Headless-Spur als SVG speichern")
    args = parser.parse_args(argv)
    if args.steps <= 0:
        parser.error("--steps muss positiv sein")
    if args.svg and not args.headless:
        parser.error("--svg erfordert --headless")
    try:
        simulation, dt = load_scenario(args.scenario, args.seed)
        if args.headless:
            trace = [simulation.pose]
            for _ in range(args.steps):
                simulation.step(dt)
                trace.append(simulation.pose)
            if args.svg:
                write_svg(args.svg, simulation, trace)
            print(json.dumps({"steps": simulation.steps, "time_s": round(simulation.time_s, 6),
                              "distance_m": round(simulation.distance_m, 6),
                              "turns": simulation.navigator.turns_selected, "seed": simulation.seed,
                              "mode": simulation.mode.value, "x_m": simulation.pose.x,
                              "y_m": simulation.pose.y}, indent=2))
        else:
            # Headless execution and core tests do not even import Turtle/Tk.
            from .turtle_view import TurtleViewer
            factory = lambda: load_scenario(args.scenario, args.seed)
            TurtleViewer(simulation, dt, factory).run()
        return 0
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(f"Fehler: {error}", file=sys.stderr)
        return 2
    except Exception as error:
        # Make a missing GUI/Tk installation actionable without hiding core errors.
        if error.__class__.__name__ in ("TclError", "Terminator") or isinstance(error, ImportError):
            print(f"Turtle konnte nicht starten: {error}\nPython mit Tk installieren oder --headless verwenden.", file=sys.stderr)
            return 2
        raise


if __name__ == "__main__":
    raise SystemExit(main())
