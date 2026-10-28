"""Turtle is a viewer and keyboard adapter, not the simulation engine."""
from __future__ import annotations

import math
import turtle

from .core import Mode, Simulation


class TurtleViewer:
    def __init__(self, simulation: Simulation, dt: float, reset_factory=None):
        self.simulation, self.dt, self.reset_factory = simulation, dt, reset_factory
        self.screen = turtle.Screen()
        self.screen.setup(1000, 800)
        self.screen.title("Mobiler Roboter | Stufe 2: reaktiver Fahrdemonstrator")
        self.screen.bgcolor("#f8fafc")
        self.screen.tracer(0, 0)
        self.scale = min(850/simulation.world.width, 620/simulation.world.height)
        self.static = self._pen()
        self.trail = self._pen("#8ba8c2")
        self.robot = self._pen()
        self.hud = self._pen("#163047")
        self.error = ""
        self.closed = False
        self.rendered_frames = 0
        self._draw_world()
        self.trail.goto(self._point(simulation.pose.x, simulation.pose.y))
        self.trail.pendown()
        self.screen.onkey(self.pause, "space")
        self.screen.onkey(self.resume, "Return")
        self.screen.onkey(self.reset, "r")
        self.screen.onkey(self.close, "Escape")
        self.screen.listen()
        self.screen.getcanvas().winfo_toplevel().protocol("WM_DELETE_WINDOW", self.close)
        self.draw()

    def _pen(self, color="#334155"):
        pen = turtle.RawTurtle(self.screen, visible=False)
        pen.speed(0)
        pen.penup()
        pen.pencolor(color)
        pen.setundobuffer(None)
        return pen

    def _point(self, x, y):
        world = self.simulation.world
        return ((x-world.width/2)*self.scale, (y-world.height/2)*self.scale-20)

    def _polygon(self, pen, points, fill):
        pen.penup()
        pen.goto(self._point(*points[0]))
        pen.fillcolor(fill)
        pen.begin_fill()
        pen.pendown()
        for point in points[1:]+points[:1]:
            pen.goto(self._point(*point))
        pen.end_fill()
        pen.penup()

    def _draw_world(self):
        w = self.simulation.world
        self.static.clear()
        self.static.pensize(1)
        self.static.pencolor("#e2e8f0")
        for x in range(1, math.ceil(w.width)):
            self.static.goto(self._point(x, 0)); self.static.pendown()
            self.static.goto(self._point(x, w.height)); self.static.penup()
        for y in range(1, math.ceil(w.height)):
            self.static.goto(self._point(0, y)); self.static.pendown()
            self.static.goto(self._point(w.width, y)); self.static.penup()
        self.static.pencolor("#64748b")
        self.static.pensize(3)
        corners = [(0, 0), (w.width, 0), (w.width, w.height), (0, w.height), (0, 0)]
        self.static.goto(self._point(*corners[0])); self.static.pendown()
        for point in corners[1:]:
            self.static.goto(self._point(*point))
        self.static.penup()
        for box in w.obstacles:
            self._polygon(self.static, [(box.left, box.bottom), (box.right, box.bottom),
                                        (box.right, box.top), (box.left, box.top)], "#b8c6d5")

    def draw(self):
        sim, pen = self.simulation, self.robot
        pose, radius = sim.pose, sim.parameters.radius_m
        self.trail.goto(self._point(pose.x, pose.y))
        pen.clear()
        blocked = sim.last_reading.forward_clearance_m <= sim.parameters.detection_distance_m+1e-9
        pen.pencolor("#dc2626" if blocked else "#0891b2")
        pen.pensize(2)
        pen.goto(self._point(pose.x, pose.y)); pen.pendown()
        reach = radius+sim.last_reading.forward_clearance_m
        pen.goto(self._point(pose.x+reach*math.cos(pose.heading), pose.y+reach*math.sin(pose.heading)))
        pen.penup()
        color = {Mode.FORWARD: "#3b9c7b", Mode.TURNING: "#e7a43b", Mode.PAUSED: "#94a3b8"}[sim.mode]
        circle = [(pose.x+radius*math.cos(i*math.tau/24),
                   pose.y+radius*math.sin(i*math.tau/24)) for i in range(24)]
        pen.pencolor("#163047"); self._polygon(pen, circle, color)
        pen.goto(self._point(pose.x, pose.y)); pen.pendown()
        pen.goto(self._point(pose.x+radius*math.cos(pose.heading), pose.y+radius*math.sin(pose.heading)))
        pen.penup()
        self.hud.clear()
        self.hud.goto(-450, 350)
        mode = {Mode.FORWARD: "GERADEAUS", Mode.TURNING: "ZUFALLSDREHUNG", Mode.PAUSED: "PAUSIERT"}[sim.mode]
        self.hud.write(f"{mode}   |   Weg {sim.distance_m:.2f} m   |   Drehungen {sim.navigator.turns_selected}   |   Seed {sim.seed}",
                       font=("Arial", 14, "bold"))
        self.hud.goto(-450, 322)
        self.hud.write("Leertaste: Pause    Enter: manuell fortsetzen    R: Neustart    Esc: Ende", font=("Arial", 11, "normal"))
        self.hud.goto(-450, -370)
        self.hud.write(self.error or "1 Rasterfeld = 1 m | ideale Abstandserkennung | kinematisch, ohne Motor-/Kontaktphysik",
                       font=("Arial", 10, "normal"))
        self.screen.update()
        self.rendered_frames += 1

    def pause(self):
        self.simulation.pause()
        self.draw()

    def resume(self):
        if self.simulation.resume(manual_release=True):
            self.error = ""
        self.draw()

    def reset(self):
        if self.reset_factory is not None:
            self.simulation, self.dt = self.reset_factory()
            self.error = ""
            self.trail.clear(); self.trail.penup()
            self.trail.goto(self._point(self.simulation.pose.x, self.simulation.pose.y)); self.trail.pendown()
            self._draw_world(); self.draw()

    def close(self):
        if not self.closed:
            self.closed = True
            self.screen.bye()

    def run(self, max_steps: int | None = None):
        def tick():
            if self.closed:
                return
            try:
                self.simulation.step(self.dt)
                self.draw()
                if max_steps is not None and self.simulation.steps >= max_steps:
                    self.close()
                    return
                self.screen.ontimer(tick, max(1, round(self.dt*1000)))
            except turtle.Terminator:
                self.closed = True
            except (ValueError, RuntimeError) as error:
                self.simulation.pause()
                self.error = str(error)
                self.draw()
        self.screen.ontimer(tick, 1)
        self.screen.mainloop()
