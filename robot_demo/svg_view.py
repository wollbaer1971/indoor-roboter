"""Deterministic SVG snapshot from actual simulator poses, without a display."""
from __future__ import annotations

import math
from pathlib import Path
from .core import Simulation


def write_svg(path: Path | str, simulation: Simulation, trace):
    sim, scale, margin = simulation, 80.0, 40.0
    width, height = sim.world.width*scale+2*margin, sim.world.height*scale+2*margin+55
    lines = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width:g}" height="{height:g}" viewBox="0 0 {width:g} {height:g}">',
             '<rect width="100%" height="100%" fill="#f8fafc"/>',
             '<text x="40" y="30" font-family="sans-serif" font-size="18" fill="#163047">Stufe 2: reaktiver Fahrdemonstrator</text>',
             f'<g transform="translate({margin},{sim.world.height*scale+65}) scale({scale},-{scale})">',
             f'<rect width="{sim.world.width}" height="{sim.world.height}" fill="white" stroke="#64748b" stroke-width="0.03"/>']
    for box in sim.world.obstacles:
        lines.append(f'<rect x="{box.left}" y="{box.bottom}" width="{box.right-box.left}" height="{box.top-box.bottom}" fill="#b8c6d5"/>')
    points = " ".join(f'{pose.x:.5f},{pose.y:.5f}' for pose in trace)
    lines.append(f'<polyline points="{points}" fill="none" stroke="#759bb6" stroke-width="0.025"/>')
    p, r = sim.pose, sim.parameters.radius_m
    lines.append(f'<circle cx="{p.x}" cy="{p.y}" r="{r}" fill="#3b9c7b" stroke="#163047" stroke-width="0.025"/>')
    lines.append(f'<path d="M {p.x} {p.y} L {p.x+r*math.cos(p.heading)} {p.y+r*math.sin(p.heading)}" stroke="#163047" stroke-width="0.03"/>')
    lines += ['</g>', f'<text x="40" y="{height-14}" font-family="sans-serif" font-size="13" fill="#334155">Seed {sim.seed} | {sim.steps} Schritte | {sim.distance_m:.2f} m | {sim.navigator.turns_selected} Drehungen | kinematische Simulation</text>', '</svg>']
    Path(path).write_text("\n".join(lines)+"\n", encoding="utf-8")
