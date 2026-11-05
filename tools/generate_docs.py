#!/usr/bin/env python3
"""Erzeugt die modellgebundenen Teile der LaTeX-Doku aus dem SysML-Modell.

Das Modell unter sysml/ ist die fuehrende Quelle. Dieses Skript schreibt:

- tables/generated/*.tex: nur Tabellenzeilen (bzw. ein Absatz fuer ADR-Texte). Kopf, Spaltenbreiten und
  Layout stehen im jeweiligen Kapitel und duerfen in Overleaf angepasst werden.
- den markierten Tabellenblock in sysml/baseline_a1/traceability_matrix.md.

    python tools/generate_docs.py           # Dateien neu schreiben
    python tools/generate_docs.py --check   # nur pruefen, ob alles aktuell ist

Inhalte werden im Modell geaendert, nie in den erzeugten Dateien.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
GENERATED = Path("tables/generated")
MATRIX = Path("sysml/baseline_a1/traceability_matrix.md")
BEGIN, END = "<!-- BEGIN GENERATED: tools/generate_docs.py -->", "<!-- END GENERATED -->"
TEX_HEADER = ("% AUTOMATISCH ERZEUGT aus dem SysML-Modell mit tools/generate_docs.py.\n"
              "% Nicht von Hand aendern: Inhalte im Modell pflegen, Layout im Kapitel.\n")
GROUPS = {"Initial": "initial", "Iteration A": "iteration_a"}


def blocks(source: str, keyword: str, prefix: str) -> list[tuple[str, str]]:
    """Top-level blocks such as 'requirement REQ_X {' in file order."""
    pattern = rf"^  {keyword} ({prefix}\w+) \{{\n(.*?)^  \}}"
    return re.findall(pattern, source, flags=re.M | re.S)


def fields(body: str, name: str) -> dict[str, str]:
    """Parse the 'Key: value' lines of the first doc block of an element."""
    doc = re.search(r"doc /\*(.*?)\*/", body, flags=re.S)
    if not doc:
        raise ValueError(f"{name}: doc block missing")
    return parse_fields(doc[1])


def parse_fields(text: str) -> dict[str, str]:
    """'Key: value' lines indented by 4 spaces; lines indented by 6 continue a value."""
    result: dict[str, str] = {}
    key = None
    for line in text.splitlines():
        if m := re.match(r"^ {4}([A-Za-z][\w-]*): (.*)$", line):
            key = m[1]
            result[key] = m[2].strip()
        elif key and (m := re.match(r"^ {6}(\S.*)$", line)):
            if re.search(r"[A-Za-z]-$", result[key]) and m[1][0].isupper():
                raise ValueError(f"line break inside a hyphenated word: '{result[key][-30:]}' / '{m[1][:20]}'")
            result[key] += " " + m[1].strip()
    return result


def require(data: dict[str, str], name: str, *keys: str) -> None:
    missing = [k for k in keys if not data.get(k)]
    if missing:
        raise ValueError(f"{name}: doc field(s) missing: {', '.join(missing)}")


def dashed(name: str) -> str:
    return name.replace("_", "-")


def tex(text: str) -> str:
    """Escape plain model text for LaTeX and apply the document's conventions."""
    for char, repl in (("\\", r"\textbackslash{}"), ("&", r"\&"), ("%", r"\%"), ("$", r"\$"),
                       ("#", r"\#"), ("_", r"\_"), ("{", r"\{"), ("}", r"\}"),
                       ("~", r"\textasciitilde{}"), ("^", r"\textasciicircum{}")):
        text = text.replace(char, repl)
    text = text.replace(r"\textbackslash\{\}", r"\textbackslash{}")
    text = re.sub(r"(\d+),(\d+) m/s", r"$\1{,}\2\\,\\mathrm{m/s}$", text)
    for abbreviation in ("z. B.", "d. h.", "u. a."):
        text = text.replace(abbreviation, abbreviation.replace(" ", r"\,"))
    # ROS2 topics and identifiers with underscores in typewriter font.
    text = re.sub(r"(?<![\w\\])(/[a-z][a-z\\_]*|[A-Za-z]+(?:\\_[A-Za-z]+)+)", r"\\texttt{\1}", text)
    # Typewriter names may break after underscores; Overleaf cannot change that inside generated text.
    return re.sub(r"\\texttt\{[^}]*\}", lambda m: m[0].replace(r"\_", r"\_\allowbreak{}"), text)


def requirement_text(model: dict, rid: str, data: dict[str, str]) -> str:
    """Requirement text plus a pointer to the decisions recorded 'about' it."""
    text = tex(data["Text"])
    decisions = model["decided_by"].get(rid, [])
    if decisions:
        text += " Siehe " + ", ".join(decisions) + "."
    return text


DECISION_REF = re.compile(r"\b(?:DEC-\d{3}|ADR-\d{4})\b")
REFERENCE_SOURCES = ("sysml/**/*.sysml", "chapters/*.tex", "appendices/*.tex", "docs/*.md", "*.md")


def load_decisions(root: Path) -> tuple[list[tuple[str, dict[str, str]]], dict[str, list[str]]]:
    source = (root / "sysml/baseline_a1/09_decisions.sysml").read_text(encoding="utf-8")
    decisions = []
    decided_by: dict[str, list[str]] = {}
    for name, about, body in re.findall(
            r"^  comment ((?:DEC|ADR)_\d+)(?: about ([^/]*?))? /\*(.*?)\*/", source, flags=re.M | re.S):
        data = parse_fields(body)
        require(data, name, "ID", "Art", "Status", "Begruendung")
        if data["ID"] != dashed(name):
            raise ValueError(f"{name}: ID field {data['ID']} does not match the element name")
        require(data, name, "Entscheidung" if data["Art"] == "Baseline" else "Titel")
        if data["Art"] not in ("Baseline", "Architektur"):
            raise ValueError(f"{name}: Art must be Baseline or Architektur")
        decisions.append((data["ID"], data))
        for target in filter(None, (a.strip() for a in about.split(","))):
            decided_by.setdefault(dashed(target.split("::")[-1]), []).append(data["ID"])
    known = {did for did, _ in decisions}
    unknown = set()
    for pattern in REFERENCE_SOURCES:
        for path in root.glob(pattern):
            if "generated" not in path.parts:
                unknown |= {f"{ref} in {path.relative_to(root)}"
                            for ref in DECISION_REF.findall(path.read_text(encoding="utf-8")) if ref not in known}
    if unknown:
        raise ValueError("decision reference(s) without record in 09_decisions.sysml: " + ", ".join(sorted(unknown)))
    return decisions, decided_by


def split_list(value: str) -> list[str]:
    return [item.strip() for item in value.split(",") if item.strip()]


def load_architecture(root: Path, requirement_ids: set[str]) -> dict:
    """Subsystems of the canonical robot, ROS2 node candidates and their topics."""
    a1 = root / "sysml/baseline_a1"
    structure = (a1 / "03_structure.sysml").read_text(encoding="utf-8")
    robot = dict(blocks(structure, "part def", ""))["MobileMaterialRobot"]
    defs = dict(blocks(structure, "part def", ""))
    subsystems = []
    for part_type in re.findall(r"^    part \w+ : (\w+);", robot, flags=re.M):
        data = fields(defs[part_type], part_type)
        require(data, part_type, "Verantwortung", "MVP-Status")
        subsystems.append((part_type, data))

    mapping = (a1 / "07_ros2_mapping.sysml").read_text(encoding="utf-8")
    targets: dict[str, list[str]] = {}
    for node, element in re.findall(
            r"dependency from (\w+) to MobileMaterialRobot_Structure_A1::(\w+);", mapping):
        targets.setdefault(node, []).append(element)
    nodes = []
    for name, body in blocks(mapping, "part def", ""):
        data = fields(body, name)
        require(data, name, "Node", "Kurzname", "Schnittstellenidee", "Publiziert", "Anforderungen")
        if not targets.get(name):
            raise ValueError(f"{name}: no dependency to a subsystem")
        unknown = set(split_list(data["Anforderungen"])) - requirement_ids
        if unknown:
            raise ValueError(f"{name}: unknown requirement(s) {sorted(unknown)}")
        nodes.append((name, data, targets[name]))

    topics = []
    for name, body in blocks(mapping, "item def", ""):
        data = fields(body, name)
        require(data, name, "Name", "Typ", "Zweck")
        topic = data["Name"]
        publishers = [d["Kurzname"] for _, d, _ in nodes if topic in split_list(d["Publiziert"])]
        subscribers = [d["Kurzname"] for _, d, _ in nodes if topic in split_list(d.get("Abonniert", ""))]
        if not publishers:
            raise ValueError(f"{name}: topic {topic} has no publishing node")
        topics.append((topic, data, publishers, subscribers))
    declared = {topic for topic, *_ in topics}
    used = {item for _, d, _ in nodes for key in ("Publiziert", "Abonniert")
            for item in split_list(d.get(key, "")) if item.startswith("/")}
    if used - declared:
        raise ValueError(f"topics used by nodes without item def: {sorted(used - declared)}")
    return {"subsystems": subsystems, "nodes": nodes, "topics": topics}


def typewriter(name: str) -> str:
    text = tex(name)
    return text if text.startswith(r"\texttt{") else r"\texttt{" + text + "}"


def direction(publishers: list[str], subscribers: list[str]) -> str:
    source = ", ".join(publishers)
    return f"{source} zu {', '.join(subscribers)}" if subscribers else f"{source} (noch kein Abnehmer)"


def decision_status(data: dict[str, str]) -> str:
    return data["Status"] + (f" ({data['Datum']})" if data.get("Datum") else "")


def row(*cells: str) -> str:
    return " & ".join(cells) + r" \\" + "\n"


def load(root: Path) -> dict:
    a1 = root / "sysml/baseline_a1"
    req_src = (a1 / "02_requirements.sysml").read_text(encoding="utf-8")
    requirements = []
    for name, body in blocks(req_src, "requirement", "REQ_"):
        data = fields(body, name)
        require(data, name, "ID", "Typ", "Gruppe", "Quelle", "Text", "Akzeptanz", "Schnittstelle", "Status")
        if data["ID"] != dashed(name):
            raise ValueError(f"{name}: ID field {data['ID']} does not match the element name")
        if data["Gruppe"] not in GROUPS:
            raise ValueError(f"{name}: Gruppe must be one of {sorted(GROUPS)}")
        if "MVP" in data:
            require(data, name, "MVP-Begruendung")
        requirements.append((dashed(name), data))

    elements: dict[str, list[str]] = {}
    trace = (a1 / "08_traceability.sysml").read_text(encoding="utf-8")
    for element, req in re.findall(
            r"dependency from MobileMaterialRobot_Structure_A1::(\w+) to MobileMaterialRobot_Requirements_A1::(REQ_\w+);", trace):
        elements.setdefault(dashed(req), []).append(element)

    test_src = (a1 / "06_tests.sysml").read_text(encoding="utf-8")
    tests = []
    for name, body in blocks(test_src, "verification def", "TC_"):
        data = fields(body, name)
        require(data, name, "ID", "Name", "Erwartet")
        if data["ID"] != dashed(name):
            raise ValueError(f"{name}: ID field {data['ID']} does not match the element name")
        verified = [dashed(r) for r in re.findall(r"verify MobileMaterialRobot_Requirements_A1::(REQ_\w+)", body)]
        tests.append((dashed(name), data, verified))
    tests_of: dict[str, list[str]] = {}
    for tc, _, verified in tests:
        for req in verified:
            tests_of.setdefault(req, []).append(tc)

    b1_src = (root / "sysml/baseline_b1/02_requirements.sysml").read_text(encoding="utf-8")
    b1 = []
    for name, body in blocks(b1_src, "requirement", "REQ_B_"):
        data = fields(body, name)
        require(data, name, "ID", "Typ", "Quelle", "Text", "Akzeptanz")
        if "MVP" in data:
            require(data, name, "MVP-Begruendung")
        b1.append((dashed(name), data))

    for rid, data in requirements:
        if not elements.get(rid) and not data.get("Systemelement"):
            raise ValueError(f"{rid}: no traceability dependency and no Systemelement field")
        if not tests_of.get(rid):
            raise ValueError(f"{rid}: not verified by any test definition")
    decisions, decided_by = load_decisions(root)
    architecture = load_architecture(root, {rid for rid, _ in requirements})
    return {"requirements": requirements, "elements": elements, "tests": tests,
            "tests_of": tests_of, "b1": b1, "decisions": decisions, "decided_by": decided_by,
            **architecture}


def element_list(model: dict, rid: str, data: dict[str, str]) -> list[str]:
    return model["elements"].get(rid) or [data["Systemelement"]]


def render(root: Path) -> dict[Path, str]:
    model = load(root)
    out: dict[Path, str] = {}

    def table(name: str, lines: list[str]) -> None:
        out[GENERATED / f"{name}.tex"] = TEX_HEADER + "".join(lines)

    for group, suffix in GROUPS.items():
        selected = [(rid, d) for rid, d in model["requirements"] if d["Gruppe"] == group]
        table(f"requirements_a1_{suffix}",
              [row(rid, tex(d["Typ"]), requirement_text(model, rid, d), tex(d["Akzeptanz"])) for rid, d in selected])
        table(f"traceability_a1_{suffix}",
              [row(rid, tex(d["Quelle"]), tex(", ".join(element_list(model, rid, d))),
                   tex(d["Schnittstelle"]), ", ".join(model["tests_of"][rid])) for rid, d in selected])
    table("mvp_a1", [row(rid, tex(d["MVP"]), tex(d["MVP-Begruendung"]))
                     for rid, d in model["requirements"] if "MVP" in d])
    table("tests_a1", [row(tc, tex(d["Name"]), ", ".join(verified), tex(d["Erwartet"]))
                       for tc, d, verified in model["tests"]])
    table("requirements_b1", [row(rid, tex(d["Typ"]), requirement_text(model, rid, d), tex(d["Akzeptanz"]))
                              for rid, d in model["b1"]])
    table("mvp_b1", [row(rid, tex(d["MVP"]), tex(d["MVP-Begruendung"])) for rid, d in model["b1"] if "MVP" in d])

    baseline = [(did, d) for did, d in model["decisions"] if d["Art"] == "Baseline"]
    architecture = [(did, d) for did, d in model["decisions"] if d["Art"] == "Architektur"]
    table("decisions_baseline_summary", [row(did, tex(d["Entscheidung"]), tex(decision_status(d))) for did, d in baseline])
    table("decisions_baseline", [row(did, tex(d["Entscheidung"]), tex(decision_status(d)), tex(d["Begruendung"]))
                                 for did, d in baseline])
    table("decisions_architecture", [row(did, tex(d["Titel"]), tex(decision_status(d)), tex(d["Begruendung"]))
                                     for did, d in architecture])
    # Full decision sheet for ADRs that record alternatives (chapter 8).
    for did, d in architecture:
        if "Alternativen" in d:
            require(d, did, "Entscheidung", "Auswirkung", "Risiko")
            key = did.lower().replace("-", "_")
            status = d["Status"] + (f" fuer Version {d['Version']}" if d.get("Version") else "")
            out[GENERATED / f"{key}_decision.tex"] = TEX_HEADER + tex(d["Entscheidung"]) + "\n"
            table(f"{key}_details", [row("Status", tex(status)),
                                     row("Alternativen", tex(d["Alternativen"])),
                                     row("Begruendung", tex(d.get("Begruendung-Detail", d["Begruendung"]))),
                                     row("Auswirkung", tex(d["Auswirkung"])),
                                     row("Risiko", tex(d["Risiko"]))])

    table("subsystems_a1", [row(name, tex(d["Verantwortung"]), tex(d["MVP-Status"]))
                            for name, d in model["subsystems"]])
    table("ros2_mapping_a1", [
        row(tex(", ".join(elements) + (f" ({d['Rolle']})" if d.get("Rolle") else "")),
            typewriter(d["Node"]) + (", " + tex(d["Ergaenzung"]) if d.get("Ergaenzung") else ""),
            tex(d["Schnittstellenidee"]), ", ".join(split_list(d["Anforderungen"])))
        for _, d, elements in model["nodes"]])
    table("ros2_topics_a1", [row(tex(topic), tex(d["Typ"]), tex(direction(pub, sub)), tex(d["Zweck"]))
                             for topic, d, pub, sub in model["topics"]])

    md_rows = ["| Requirement | Quelle | Systemelement | Schnittstelle / ROS2 | Test | Status |",
               "| --- | --- | --- | --- | --- | --- |"]
    for rid, d in model["requirements"]:
        md_rows.append("| " + " | ".join([rid, d["Quelle"], ", ".join(element_list(model, rid, d)),
                                           d["Schnittstelle"], ", ".join(model["tests_of"][rid]), d["Status"]]) + " |")
    matrix = (root / MATRIX).read_text(encoding="utf-8")
    if BEGIN not in matrix or END not in matrix:
        raise ValueError(f"{MATRIX}: generated-block markers missing")
    head, rest = matrix.split(BEGIN, 1)
    _, tail = rest.split(END, 1)
    out[MATRIX] = head + BEGIN + "\n" + "\n".join(md_rows) + "\n" + END + tail
    return out


def stale(root: Path) -> list[str]:
    """Paths whose committed content differs from what the model produces."""
    expected = render(root)
    problems = []
    for rel, content in expected.items():
        path = root / rel
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            problems.append(str(rel))
    known = {p.name for p in expected if p.parent == GENERATED}
    if (root / GENERATED).is_dir():
        problems += [str(GENERATED / p.name) + " (unbekannt)" for p in (root / GENERATED).glob("*.tex")
                     if p.name not in known]
    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--check", action="store_true", help="nur pruefen, nichts schreiben")
    args = parser.parse_args()
    try:
        if args.check:
            problems = stale(REPO)
            if problems:
                print("Veraltet oder von Hand geaendert (python tools/generate_docs.py ausfuehren):\n  "
                      + "\n  ".join(problems), file=sys.stderr)
                return 1
            print("GENERATED docs up to date")
            return 0
        (REPO / GENERATED).mkdir(parents=True, exist_ok=True)
        for rel, content in render(REPO).items():
            (REPO / rel).write_text(content, encoding="utf-8")
            print(f"wrote {rel}")
        return 0
    except (ValueError, OSError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
