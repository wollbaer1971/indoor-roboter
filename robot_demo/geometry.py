"""Continuous 2-D geometry for a circular robot and rectangular obstacles.

Distances are metres. Heading is radians, counter-clockwise from +x.
The range query measures free travel of the robot footprint, not a LiDAR ray.
"""
from __future__ import annotations

from dataclasses import dataclass
import math

EPS = 1e-9


@dataclass(frozen=True)
class Pose:
    x: float
    y: float
    heading: float = 0.0

    def __post_init__(self):
        if not all(math.isfinite(v) for v in (self.x, self.y, self.heading)):
            raise ValueError("Pose coordinates and heading must be finite")


@dataclass(frozen=True)
class Rectangle:
    left: float
    bottom: float
    right: float
    top: float

    def __post_init__(self):
        if not all(math.isfinite(v) for v in (self.left, self.bottom, self.right, self.top)):
            raise ValueError("Obstacle coordinates must be finite")
        if self.left >= self.right or self.bottom >= self.top:
            raise ValueError("Obstacle rectangle must have positive dimensions")

    def distance(self, x: float, y: float) -> float:
        return math.hypot(max(self.left-x, 0.0, x-self.right),
                          max(self.bottom-y, 0.0, y-self.top))


def _ray_box(x: float, y: float, dx: float, dy: float, box: Rectangle) -> float:
    near, far = 0.0, math.inf
    for origin, direction, low, high in ((x, dx, box.left, box.right),
                                         (y, dy, box.bottom, box.top)):
        if abs(direction) < EPS:
            if origin < low or origin > high:
                return math.inf
            continue
        a, b = (low-origin)/direction, (high-origin)/direction
        near, far = max(near, min(a, b)), min(far, max(a, b))
        if near > far:
            return math.inf
    return near if far >= 0.0 else math.inf


def _ray_circle(x, y, dx, dy, cx, cy, radius):
    ox, oy = x-cx, y-cy
    c = ox*ox + oy*oy - radius*radius
    if c <= 0.0:
        return 0.0
    b = ox*dx + oy*dy
    discriminant = b*b-c
    if discriminant < -EPS:
        return math.inf
    t = -b-math.sqrt(max(0.0, discriminant))
    return t if t >= 0.0 else math.inf


@dataclass(frozen=True)
class World:
    width: float
    height: float
    obstacles: tuple[Rectangle, ...] = ()

    def __post_init__(self):
        if not all(math.isfinite(v) and v > 0.0 for v in (self.width, self.height)):
            raise ValueError("World dimensions must be finite and positive")
        for box in self.obstacles:
            if box.left < 0 or box.bottom < 0 or box.right > self.width or box.top > self.height:
                raise ValueError("Obstacle lies outside the world")

    def is_free(self, pose: Pose, radius: float) -> bool:
        return (radius < pose.x < self.width-radius
                and radius < pose.y < self.height-radius
                and all(box.distance(pose.x, pose.y) > radius+EPS for box in self.obstacles))

    def free_distance(self, pose: Pose, radius: float, limit: float = math.inf) -> float:
        """First contact distance for a swept disk, clipped to sensor range.

        Rounded rectangle expansion prevents corner tunnelling. World walls
        are also obstacles. An already invalid pose has zero free distance.
        """
        if not self.is_free(pose, radius):
            return 0.0
        dx, dy = math.cos(pose.heading), math.sin(pose.heading)
        distance = limit
        if dx > EPS:
            distance = min(distance, (self.width-radius-pose.x)/dx)
        elif dx < -EPS:
            distance = min(distance, (radius-pose.x)/dx)
        if dy > EPS:
            distance = min(distance, (self.height-radius-pose.y)/dy)
        elif dy < -EPS:
            distance = min(distance, (radius-pose.y)/dy)
        for box in self.obstacles:
            # Minkowski sum of rectangle and disk = two strips + corner disks.
            strips = (Rectangle(box.left-radius, box.bottom, box.right+radius, box.top),
                      Rectangle(box.left, box.bottom-radius, box.right, box.top+radius))
            for strip in strips:
                distance = min(distance, _ray_box(pose.x, pose.y, dx, dy, strip))
            for cx in (box.left, box.right):
                for cy in (box.bottom, box.top):
                    distance = min(distance, _ray_circle(pose.x, pose.y, dx, dy, cx, cy, radius))
        return max(0.0, distance)
