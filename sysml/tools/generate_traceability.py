#!/usr/bin/env python3
"""Generate the traceability matrices from the SysML v2 model.

Reads the textual model in sysml/baseline_a1 and sysml/baseline_b1 and writes
the tables between the GENERATED markers in each traceability_matrix.md.
Text outside the markers (e.g. open issues) is kept as written.

This is not a SysML parser. It reads the modeling conventions used in this
repository (short names, satisfy/allocate/verify/dependency statements) with
regular expressions and fails loudly when a reference does not resolve.

Usage:
    python3 sysml/tools/generate_traceability.py          # update matrices
    python3 sysml/tools/generate_traceability.py --check  # fail if outdated
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
A1 = ROOT / "baseline_a1"
B1 = ROOT / "baseline_b1"
BEGIN = "<!-- BEGIN GENERATED: do not edit, run sysml/tools/generate_traceability.py -->"
END = "<!-- END GENERATED -->"

errors: list[str] = []


def read(path: Path) -> str:
    # Drop "//" notes. Doc blocks in this model never contain "//".
    return re.sub(r"//[^\n]*", "", path.read_text(encoding="utf-8"))


def code(src: str) -> str:
    """Model text without doc blocks, so relationships are not read from prose."""
    return re.sub(r"doc /\*.*?\*/", "", src, flags=re.S)


def doc_fields(doc: str) -> dict[str, str]:
    """Parse 'Key: value' lines of a doc block; indented lines continue."""
    fields: dict[str, str] = {}
    key = None
    for line in doc.splitlines():
        m = re.match(r"^ {4}([A-Z][\w ]*): (.*)$", line)
        if m:
            key = m.group(1)
            fields[key] = m.group(2).strip()
        elif key and line.startswith("      "):
            fields[key] += " " + line.strip()
    return fields


def body_of(src: str, header_regex: str) -> str:
    """Return the text between the braces of the first element matching header_regex."""
    m = re.search(header_regex + r"\s*\{", src)
    if not m:
        errors.append(f"element not found: {header_regex}")
        return ""
    depth, i = 1, m.end()
    while depth and i < len(src):
        depth += {"{": 1, "}": -1}.get(src[i], 0)
        i += 1
    return src[m.end() : i - 1]


def requirements(src: str) -> dict[str, dict]:
    reqs = {}
    pattern = r"requirement <'([\w-]+)'> (\w+) : RobotRequirement \{\s*doc /\*(.*?)\*/"
    for rid, name, doc in re.findall(pattern, src, re.S):
        if name in reqs:
            errors.append(f"duplicate requirement name {name}")
        reqs[name] = {"id": rid, **doc_fields(doc)}
    return reqs


def resolve(name: str, known: dict | set, where: str) -> bool:
    if name not in known:
        errors.append(f"{where}: unknown element '{name}'")
        return False
    return True


def join(items) -> str:
    return ", ".join(items) if items else "–"


# ---------------------------------------------------------------- Baseline A.1

def build_a1() -> str:
    structure = code(read(A1 / "03_structure.sysml"))
    reqs = requirements(read(A1 / "02_requirements.sysml"))
    tests_src = read(A1 / "06_tests.sysml")
    ros2_src = code(read(A1 / "07_ros2_mapping.sysml"))
    trace = code(read(A1 / "08_traceability.sysml"))

    robot_body = body_of(structure, r"part def MobileMaterialRobot")
    subsystems = dict(re.findall(r"part (\w+) : (\w+);", robot_body))
    nodes = dict(re.findall(r"part (\w+) : (\w+);", body_of(ros2_src, r"part def Ros2System")))

    satisfied: dict[str, list[str]] = {n: [] for n in reqs}
    sub_reqs: dict[str, list[str]] = {u: [] for u in subsystems}
    for req, by in re.findall(r"satisfy (\w+) by (\w+);", body_of(trace, r"part robot : MobileMaterialRobot")):
        if resolve(req, reqs, "satisfy") and resolve(by, subsystems, "satisfy"):
            satisfied[req].append(subsystems[by])
            sub_reqs[by].append(reqs[req]["id"])
    for req in re.findall(r"^  satisfy (\w+) by robot;", trace, re.M):
        if resolve(req, reqs, "satisfy"):
            satisfied[req].append("MobileMaterialRobot")

    allocated: dict[str, list[str]] = {u: [] for u in subsystems}
    for sub, node in re.findall(r"allocate robot\.(\w+) to ros2\.(\w+);", trace):
        if resolve(sub, subsystems, "allocate") and resolve(node, nodes, "allocate"):
            allocated[sub].append(nodes[node])

    # ROS2 topic graph from the "Publishes:"/"Subscribes:" lines of the node docs.
    ros2_raw = read(A1 / "07_ros2_mapping.sysml")
    pubs: dict[str, list[str]] = {}
    subs: dict[str, list[str]] = {}
    for node, doc in re.findall(r"part def (\w+Node) \{\s*doc /\*(.*?)\*/", ros2_raw, re.S):
        f = doc_fields(doc)
        for topic in re.findall(r"/[\w/]+", f.get("Publishes", "")):
            pubs.setdefault(topic, []).append(node)
        for topic in re.findall(r"/[\w/]+", f.get("Subscribes", "")):
            subs.setdefault(topic, []).append(node)

    # ADR-0009: only nodes allocated from the SafetySystem may publish /cmd_vel.
    safety_nodes = set(allocated.get("safety", []))
    cmd_vel_pubs = pubs.get("/cmd_vel", [])
    if not cmd_vel_pubs:
        errors.append("ADR-0009: no node publishes /cmd_vel")
    for node in cmd_vel_pubs:
        if node not in safety_nodes:
            errors.append(f"ADR-0009: {node} publishes /cmd_vel but is not allocated from SafetySystem")

    verified: dict[str, list[str]] = {n: [] for n in reqs}
    test_rows = []
    for tid, tname, body in re.findall(r"verification def <'([\w-]+)'> (\w+) \{(.*?)\n  \}", tests_src, re.S):
        names = re.findall(r"verify (\w+);", code(body))
        for n in names:
            if resolve(n, reqs, f"verify in {tid}"):
                verified[n].append(tid)
        test_rows.append(f"| {tid} | {tname} | {join(reqs[n]['id'] for n in names if n in reqs)} |")

    def ros2_for(req: str) -> list[str]:
        by_def = {d: u for u, d in subsystems.items()}
        out = []
        for d in satisfied[req]:
            for node in allocated.get(by_def.get(d, ""), []):
                if node not in out:
                    out.append(node)
        return out

    lines = [
        "## Requirements",
        "",
        "| Requirement | Source | Satisfied by | ROS2 node (via allocation) | Interface | Test | Status |",
        "| --- | --- | --- | --- | --- | --- | --- |",
    ]
    for name, r in reqs.items():
        gaps = []
        if not satisfied[name]:
            gaps.append("no element")
        if not verified[name]:
            gaps.append("no test")
        status = "Gap: " + ", ".join(gaps) if gaps else "Covered"
        lines.append(
            f"| {r['id']} | {r.get('Source', '–')} | {join(satisfied[name])} | {join(ros2_for(name))} "
            f"| {r.get('Interface', '–')} | {join(verified[name])} | {status} |"
        )

    lines += [
        "",
        "## Subsystems",
        "",
        "| Subsystem | Satisfies | Allocated to | Status |",
        "| --- | --- | --- | --- |",
    ]
    for usage, d in subsystems.items():
        status = "Gap: no ROS2 node" if not allocated[usage] else "Allocated"
        lines.append(f"| {d} | {join(sub_reqs[usage])} | {join(allocated[usage])} | {status} |")

    lines += [
        "",
        "## ROS2 topics",
        "",
        "Rule (ADR-0009): only nodes allocated from SafetySystem publish `/cmd_vel`.",
        "",
        "| Topic | Published by | Subscribed by | Status |",
        "| --- | --- | --- | --- |",
    ]
    for topic in sorted(set(pubs) | set(subs)):
        p, s = pubs.get(topic, []), subs.get(topic, [])
        status = "Gap: no publisher" if not p else "Gap: no subscriber" if not s else "Connected"
        lines.append(f"| `{topic}` | {join(p)} | {join(s)} | {status} |")

    lines += ["", "## Verification cases", "", "| Test | Name | Verifies |", "| --- | --- | --- |"]
    lines += test_rows
    return "\n".join(lines)


# ---------------------------------------------------------------- Baseline B.1

def build_b1() -> str:
    reqs = requirements(read(B1 / "02_requirements.sysml"))
    uc_src = read(B1 / "01_use_cases.sysml")
    trace = code(read(B1 / "03_traceability.sysml"))

    ucs = {}
    for uid, name, doc in re.findall(r"action def <'([\w-]+)'> (\w+) \{\s*doc /\*(.*?)\*/", uc_src, re.S):
        ucs[name] = {"id": uid, **doc_fields(doc)}

    linked: dict[str, list[str]] = {n: [] for n in ucs}
    used = set()
    for clients, supplier in re.findall(r"dependency from (.*?)\s+to (\w+);", trace, re.S):
        if not resolve(supplier, ucs, "dependency"):
            continue
        for c in re.split(r"[,\s]+", clients.strip()):
            if resolve(c, reqs, "dependency"):
                linked[supplier].append(reqs[c]["id"])
                used.add(c)

    lines = [
        "## Use cases",
        "",
        "| Use Case | Candidate Requirements | Verification idea | Related Open Issues |",
        "| --- | --- | --- | --- |",
    ]
    for name, u in ucs.items():
        vi = u.get("Verification idea", "–").rstrip(".")
        oi = u.get("Open issues", "–").rstrip(".")
        lines.append(f"| {u['id']} | {join(linked[name])} | {vi} | {oi} |")

    orphans = [f"- {r['id']} (Source: {r.get('Source', '–')})" for n, r in reqs.items() if n not in used]
    lines += ["", "## Requirements without use case", ""] + (orphans or ["- none"])
    return "\n".join(lines)


# ---------------------------------------------------------------- main

def splice(path: Path, generated: str) -> tuple[str, str]:
    old = path.read_text(encoding="utf-8")
    if BEGIN not in old or END not in old:
        errors.append(f"{path}: GENERATED markers missing")
        return old, old
    head, rest = old.split(BEGIN, 1)
    _, tail = rest.split(END, 1)
    return old, f"{head}{BEGIN}\n\n{generated}\n\n{END}{tail}"


def main() -> int:
    check = "--check" in sys.argv[1:]
    targets = [(A1 / "traceability_matrix.md", build_a1()), (B1 / "traceability_matrix.md", build_b1())]
    results = [(p, *splice(p, g)) for p, g in targets]
    if errors:
        print("Model errors:", *errors, sep="\n  ")
        return 2
    outdated = [p for p, old, new in results if old != new]
    if check:
        for p in outdated:
            print(f"outdated: {p.relative_to(ROOT.parent)}")
        return 1 if outdated else 0
    for p, old, new in results:
        if old != new:
            p.write_text(new, encoding="utf-8")
            print(f"updated: {p.relative_to(ROOT.parent)}")
    if not outdated:
        print("matrices already up to date")
    return 0


if __name__ == "__main__":
    sys.exit(main())
