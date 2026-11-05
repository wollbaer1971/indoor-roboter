#!/usr/bin/env python3
"""Erzeugt die modellgebundenen Teile der LaTeX-Doku aus dem SysML-Modell.

Das Modell unter sysml/ ist die fuehrende Quelle. Dieses Skript schreibt:

- tables/generated/*.tex: nur Tabellenzeilen. Kopf, Spaltenbreiten und
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
    """Parse 'Key: value' lines of the first doc block; indented lines continue a value."""
    doc = re.search(r"doc /\*(.*?)\*/", body, flags=re.S)
    if not doc:
        raise ValueError(f"{name}: doc block missing")
    result: dict[str, str] = {}
    key = None
    for line in doc[1].splitlines():
        if m := re.match(r"^ {4}([A-Za-z][\w-]*): (.*)$", line):
            key = m[1]
            result[key] = m[2].strip()
        elif key and (m := re.match(r"^ {6}(\S.*)$", line)):
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
    # ROS2 topics and identifiers with underscores in typewriter font.
    text = re.sub(r"(?<![\w\\])(/[a-z][a-z\\_]*|[A-Za-z]+(?:\\_[A-Za-z]+)+)", r"\\texttt{\1}", text)
    return text


def requirement_text(data: dict[str, str]) -> str:
    """Requirement text plus a short pointer to a recorded decision, if any."""
    text = tex(data["Text"])
    decisions = re.findall(r"DEC-\d+", data.get("Entscheidung", ""))
    if decisions:
        text += " Siehe " + ", ".join(dict.fromkeys(decisions)) + "."
    return text


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
    return {"requirements": requirements, "elements": elements, "tests": tests,
            "tests_of": tests_of, "b1": b1}


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
              [row(rid, tex(d["Typ"]), requirement_text(d), tex(d["Akzeptanz"])) for rid, d in selected])
        table(f"traceability_a1_{suffix}",
              [row(rid, tex(d["Quelle"]), tex(", ".join(element_list(model, rid, d))),
                   tex(d["Schnittstelle"]), ", ".join(model["tests_of"][rid])) for rid, d in selected])
    table("mvp_a1", [row(rid, tex(d["MVP"]), tex(d["MVP-Begruendung"]))
                     for rid, d in model["requirements"] if "MVP" in d])
    table("tests_a1", [row(tc, tex(d["Name"]), ", ".join(verified), tex(d["Erwartet"]))
                       for tc, d, verified in model["tests"]])
    table("requirements_b1", [row(rid, tex(d["Typ"]), requirement_text(d), tex(d["Akzeptanz"]))
                              for rid, d in model["b1"]])
    table("mvp_b1", [row(rid, tex(d["MVP"]), tex(d["MVP-Begruendung"])) for rid, d in model["b1"] if "MVP" in d])

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
