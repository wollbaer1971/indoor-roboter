#!/usr/bin/env python3
"""Reproducible model checks using the unmodified official Pilot Implementation.

Downloads only a public, SHA-256-pinned tool release. Model data stays local.
Requires Python 3.10+ and Java 21+; no Syside license is needed.
"""
from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request
import zipfile

import generate_docs  # same directory; the model leads the generated documentation

RELEASE = "2025-10"
VERSION = "0.53.0"
SHA256 = "bbd51b1827d9d4a586644d4a1d16e6f17c01a7ffa80ab49e3f8774fa1f46ce5e"
URL = ("https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/"
       f"releases/download/{RELEASE}/jupyter-sysml-kernel-{VERSION}.zip")
REPO = Path(__file__).resolve().parents[1]


def pilot_home(explicit: Path | None) -> Path:
    if explicit:
        home = explicit.resolve()
    else:
        base = Path(os.environ.get("LOCALAPPDATA" if os.name == "nt" else "XDG_CACHE_HOME",
                                   str(Path.home() / ".cache")))
        cache = base / "indoor-roboter" / f"pilot-{VERSION}"
        home = cache / "sysml"
        if not (home / f"jupyter-sysml-kernel-{VERSION}-all.jar").is_file():
            cache.parent.mkdir(parents=True, exist_ok=True)
            # Extract in a temporary sibling and publish only a complete tool.
            with tempfile.TemporaryDirectory(dir=cache.parent) as temporary:
                temp = Path(temporary)
                archive = temp / "pilot.zip"
                print(f"Downloading official Pilot {VERSION} ({RELEASE})", flush=True)
                request = urllib.request.Request(URL, headers={"User-Agent": "indoor-roboter-model-check"})
                with urllib.request.urlopen(request, timeout=120) as source, archive.open("wb") as dest:
                    shutil.copyfileobj(source, dest)
                if hashlib.sha256(archive.read_bytes()).hexdigest() != SHA256:
                    raise RuntimeError("Pilot archive SHA-256 mismatch")
                extracted = temp / "extracted"
                with zipfile.ZipFile(archive) as zipped:
                    for member in zipped.infolist():
                        if Path(member.filename).is_absolute() or ".." in Path(member.filename).parts:
                            raise RuntimeError("Unsafe archive path")
                    zipped.extractall(extracted)
                if cache.exists():
                    raise RuntimeError(f"Incomplete existing cache: remove {cache} and retry")
                extracted.rename(cache)
    if not (home / f"jupyter-sysml-kernel-{VERSION}-all.jar").is_file():
        raise RuntimeError(f"Pilot JAR not found in {home}")
    if not (home / "sysml.library").is_dir():
        raise RuntimeError(f"Standard library not found in {home}")
    return home


def java_command(explicit: str | None) -> str:
    java = explicit
    if not java and os.environ.get("JAVA_HOME"):
        java = str(Path(os.environ["JAVA_HOME"]) / "bin" / ("java.exe" if os.name == "nt" else "java"))
    java = java or shutil.which("java")
    if not java:
        raise RuntimeError("Install a Java 21+ JDK and set JAVA_HOME or use --java")
    probe = subprocess.run([java, "-version"], capture_output=True, text=True, check=True)
    version = re.search(r'version "(\d+)', probe.stdout + probe.stderr)
    if not version or int(version[1]) < 21:
        raise RuntimeError("Java 21+ JDK required; set JAVA_HOME or pass --java /path/to/java")
    return java


def invoke(java: str, home: Path, model: Path, self_test: bool = False) -> subprocess.CompletedProcess:
    cmd = [java, "-Xmx2g",
           "-Dlog4j.configuration=" + (REPO / "tools/log4j.properties").as_uri(),
           "--class-path", str(home / f"jupyter-sysml-kernel-{VERSION}-all.jar"),
           str(REPO / "tools/ValidateModel.java"), str(home / "sysml.library"), str(model)]
    if self_test:
        cmd.append("--self-test")
    return subprocess.run(cmd, capture_output=True, text=True, timeout=240)


def architecture_checks(model: Path) -> None:
    sources = {p: p.read_text(encoding="utf-8") for p in model.rglob("*.sysml")}
    clean = {p: re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)
             for p, text in sources.items()}
    canonical = [p for p, text in clean.items()
                 if re.search(r"\bpart def MobileMaterialRobot(?:\s*:>\s*\w+)?\s*\{", text)]
    if canonical != [model / "baseline_a1/03_structure.sysml"]:
        raise RuntimeError(f"Expected exactly one canonical robot type, found {canonical}")
    requirements = sources[model / "baseline_a1/02_requirements.sysml"]
    tests = sources[model / "baseline_a1/06_tests.sysml"]
    req_names = set(re.findall(r"\brequirement (REQ_\w+)\s*\{", requirements))
    verified = set(re.findall(r"verify MobileMaterialRobot_Requirements_A1::(REQ_\w+)", tests))
    if req_names != verified:
        raise RuntimeError(f"Requirement coverage mismatch: missing={req_names-verified}, unknown={verified-req_names}")
    matrix = (model / "baseline_a1/traceability_matrix.md").read_text(encoding="utf-8")
    defined_tests = set(re.findall(r"\bverification def (TC_\w+)", tests))
    matrix_tests = {name.replace("-", "_") for name in re.findall(r"TC-[A-Z]+-\d+", matrix)}
    if not matrix_tests <= defined_tests:
        raise RuntimeError(f"Undefined matrix tests: {matrix_tests-defined_tests}")
    print(f"ARCHITECTURE canonical_robot=1 requirements={len(req_names)} covered={len(verified)} matrix_tests_resolve=true")


def _doc_list(doc: str, key: str) -> list[str]:
    """Comma list after 'key:' in a doc block; deeper-indented lines continue it."""
    lines = doc.splitlines()
    for i, line in enumerate(lines):
        if line.strip().startswith(key + ":"):
            value = line.split(":", 1)[1]
            for follow in lines[i + 1:]:
                if not follow.startswith(" " * 6):
                    break
                value += " " + follow.strip()
            items = [v.strip() for v in value.split(",") if v.strip()]
            return [] if items == ["keine"] else items
    raise RuntimeError(f"RobotOperationState doc: '{key}:' missing")


def state_machine_checks(model: Path) -> None:
    """Safety and fault exits in every state not declared unmonitored; reachability; no dead ends."""
    source = (model / "baseline_a1/05_behavior.sysml").read_text(encoding="utf-8")
    block = re.search(r"state def RobotOperationState \{(.*?)\n  \}", source, re.S)
    if not block:
        raise RuntimeError("state def RobotOperationState not found")
    body = block[1]
    doc = re.search(r"doc /\*(.*?)\*/", body, re.S)[1]
    unmonitored, exempt = _doc_list(doc, "Ohne Sicherheitsuebergaenge"), _doc_list(doc, "Noch ohne Zugang")
    final = _doc_list(doc, "Endzustaende")
    states = re.findall(r"^\s+state (\w+);", body, re.M)
    start = re.search(r"entry; then (\w+);", body)[1]
    transitions = re.findall(r"transition first (\w+)\s+accept\s+(?:\w+\s*:\s*)?(\w+)[^;]*?then (\w+);", body, re.S)
    problems = [f"declared state {s} does not exist" for s in unmonitored + exempt + final if s not in states]
    active = [s for s in states if s not in unmonitored]
    # A regular exit is any transition other than the safety/fault exits.
    exits = {source_state for source_state, event, _ in transitions
             if event not in ("UnsafeCondition", "TechnicalFault")}
    for state in states:
        if state not in exits and state not in final:
            problems.append(f"state {state} has no regular outgoing transition (dead end)")
        if state in exits and state in final:
            problems.append(f"state {state} has an exit now; remove it from 'Endzustaende'")
    for state in active:
        for event, target in (("UnsafeCondition", "safeState"), ("TechnicalFault", "fault")):
            if (state, event, target) not in transitions:
                problems.append(f"state {state} lacks '{event} -> {target}'")
    reachable, frontier = {start}, [start]
    while frontier:
        current = frontier.pop()
        for source_state, _, target in transitions:
            if source_state == current and target not in reachable:
                reachable.add(target)
                frontier.append(target)
    for state in states:
        if state not in reachable and state not in exempt:
            problems.append(f"state {state} is unreachable")
        if state in reachable and state in exempt:
            problems.append(f"state {state} is reachable now; remove it from 'Noch ohne Zugang'")
    if problems:
        raise RuntimeError("State machine rules violated:\n  " + "\n  ".join(problems))
    print(f"STATE_MACHINE states={len(states)} reachable={len(reachable)} monitored={len(active)} "
          f"unmonitored={','.join(unmonitored)} "
          f"safety_exits=complete open_without_entry={','.join(exempt) or 'none'} "
          f"dead_ends={','.join(final) or 'none'}")


def negative_state_machine_check(model: Path) -> None:
    """Remove a safety exit and an acknowledgement in temporary copies; the check must fail."""
    with tempfile.TemporaryDirectory(prefix="states-negative-") as temporary:
        copy = Path(temporary) / "sysml"
        shutil.copytree(model, copy)
        behavior = copy / "baseline_a1/05_behavior.sysml"
        text = behavior.read_text(encoding="utf-8")
        mutated = text.replace("    transition first paused accept UnsafeCondition then safeState;\n", "", 1)
        if mutated == text:
            raise RuntimeError("Negative state machine test could not remove the paused safety exit")
        behavior.write_text(mutated, encoding="utf-8")
        try:
            state_machine_checks(copy)
        except RuntimeError:
            print("NEGATIVE missing_safety_exit: detected")
        else:
            raise RuntimeError("Negative state machine test did not detect a missing safety exit")
        behavior.write_text(text.replace("    transition first completed accept AcknowledgeRequested then ready;\n", "", 1),
                            encoding="utf-8")
        try:
            state_machine_checks(copy)
        except RuntimeError:
            print("NEGATIVE dead_end_state: detected")
            return
        raise RuntimeError("Negative state machine test did not detect a dead-end state")


def _ids(text: str) -> set[str]:
    return set(re.findall(r"(?:REQ|TC)-[A-Z]+(?:-[A-Z]+)?-\d+", text))


def documentation_checks(docs: Path) -> None:
    """The model leads: generated tables must be current and nothing model-bound is hand-written."""
    problems = []
    try:
        problems += [f"{rel}: stale or hand-edited; run python tools/generate_docs.py"
                     for rel in generate_docs.stale(docs)]
    except ValueError as error:
        raise RuntimeError(f"Model documentation fields: {error}") from error

    tex = {p: p.read_text(encoding="utf-8")
           for folder in ("chapters", "appendices") for p in sorted((docs / folder).glob("*.tex"))}
    for path, text in tex.items():
        for number, line in enumerate(text.splitlines(), 1):
            if re.match(r"\s*(?:(?:REQ|TC)-[A-Z]+(?:-[A-Z]+)?-\d+|DEC-\d{3}|ADR-\d{4}|A-\d{3}|FUN-[A-Z]+-\d{3}|[A-Z]\w*System\b[^&]*|\\texttt\{/[^}]*\})\s*&", line):
                problems.append(f"{path.relative_to(docs)}:{number}: hand-written model row (requirement, test, decision, subsystem or topic); "
                                "maintain it in the model")
    for path, text in tex.items():
        for block in re.findall(r"\\begin\{itemize\}(.*?)\\end\{itemize\}", text, re.S):
            if "\\modeltext{" in block and "\\item" in block:
                problems.append(f"{path.relative_to(docs)}: hand-written \\item in a generated list")
    used = set(re.findall(r"\\model(?:table|text)\{(\w+)\}", "".join(tex.values())))
    generated = {p.stem for p in (docs / generate_docs.GENERATED).glob("*.tex")}
    if used != generated:
        problems.append(f"\\modeltable includes: not used={sorted(generated - used)}, unknown={sorted(used - generated)}")

    # B.1 use-case derivations are still prose in chapter 12 and in the B.1 review matrix.
    b1 = (docs / "sysml/baseline_b1/02_requirements.sysml").read_text(encoding="utf-8")
    model_uc: dict[str, set[str]] = {}
    for req, uc in re.findall(r"dependency from (REQ_B_\w+) to UC_B_(\d+)_", b1):
        model_uc.setdefault(f"UC-B-{uc}", set()).add(req.replace("_", "-"))
    chapter12 = (docs / "chapters/12_iteration_b_usecases_requirements.tex").read_text(encoding="utf-8")
    for uc, derived in re.findall(r"subsection\{(UC-B-\d+).*?Abgeleitete Requirements & (.*?)\\\\", chapter12, re.S):
        if _ids(derived) != model_uc.get(uc, set()):
            problems.append(f"chapters/12 {uc}: LaTeX={sorted(_ids(derived))}, model={sorted(model_uc.get(uc, []))}")
    b1_matrix = (docs / "sysml/baseline_b1/traceability_matrix.md").read_text(encoding="utf-8")
    for uc, cell in re.findall(r"^\| (UC-B-\d+) \| (.*?) \|", b1_matrix, re.M):
        if _ids(cell) != model_uc.get(uc, set()):
            problems.append(f"baseline_b1/traceability_matrix.md {uc}: matrix={sorted(_ids(cell))}, model={sorted(model_uc.get(uc, []))}")

    if problems:
        raise RuntimeError("Documentation drifts from model:\n  " + "\n  ".join(problems))
    print(f"DOCUMENTATION generated_tables={len(generated)} up_to_date=true hand_written_rows=0 b1_use_cases_match=true")


def negative_checks(java: str, home: Path, model: Path) -> None:
    for name in ("missing_import_target", "missing_feature", "wrong_subject_type"):
        with tempfile.TemporaryDirectory(prefix="sysml-negative-") as temporary:
            copy = Path(temporary) / "sysml"
            shutil.copytree(model, copy)
            if name == "missing_import_target":
                (copy / "baseline_a1/03_structure.sysml").unlink()
            else:
                file = copy / "baseline_a1/91_simulation_verification.sysml"
                replacement = "schoolTransportBench.robotMissing" if name == "missing_feature" else "schoolTransportBench.world"
                file.write_text(file.read_text(encoding="utf-8").replace("schoolTransportBench.robot", replacement), encoding="utf-8")
            result = invoke(java, home, copy)
            # A compilation/bootstrap failure is not a successful negative model test.
            summary = re.search(r"RESULT files=\d+ errors=(\d+) warnings=(\d+)", result.stdout)
            if result.returncode == 0 or not summary or int(summary[1]) + int(summary[2]) == 0:
                raise RuntimeError(f"Negative model test did not detect {name}:\n{result.stdout}\n{result.stderr}")
            print(f"NEGATIVE {name}: detected ({summary[1]} errors, {summary[2]} warnings)")


def inheritance_check() -> None:
    """Move five subsystems into a base type, as a variant core would; the subsystem table must stay the same."""
    shared = ("navigation : NavigationSystem", "perception : PerceptionSystem", "motion : MotionSystem",
              "safety : SafetySystem", "diagnostics : DiagnosticsSystem")
    with tempfile.TemporaryDirectory(prefix="inheritance-") as temporary:
        copy = Path(temporary)
        for folder in ("chapters", "appendices", "tables", "sysml", "figures"):
            shutil.copytree(REPO / folder, copy / folder)
        structure = copy / "sysml/baseline_a1/03_structure.sysml"
        text = structure.read_text(encoding="utf-8")
        for part in shared:
            text = text.replace(f"    part {part};\n", "", 1)
        base = "".join(f"    part {part};\n" for part in shared)
        text = text.replace("  part def MobileMaterialRobot {\n",
                            "  part def MobileRobotBase {\n" + base + "  }\n\n"
                            "  part def MobileMaterialRobot :> MobileRobotBase {\n"
                            "    part redefines navigation : NavigationSystem;\n", 1)
        structure.write_text(text, encoding="utf-8")
        key = generate_docs.GENERATED / "subsystems_a1.tex"
        rows = lambda content: sorted(line for line in content.splitlines() if "&" in line)
        expected = rows((REPO / key).read_text(encoding="utf-8"))
        actual = rows(generate_docs.render(copy)[key])
        if actual != expected:
            raise RuntimeError("Subsystem table changes when subsystems are inherited from a base type")
        print(f"INHERITANCE subsystems_via_base={len(shared)} redefines=1 table_unchanged=true")


def negative_documentation_check() -> None:
    """Mutate temporary copies of docs and model; every mutation must fail the documentation check."""
    mutations = {
        "generated_table_edited": ("tables/generated/requirements_a1_initial.tex",
                                   lambda text: text.replace("annehmen koennen.", "annehmen.", 1)),
        "hand_written_row": ("chapters/05_requirements.tex",
                             lambda text: text.replace("\\modeltable{requirements_a1_initial}",
                                                       "\\modeltable{requirements_a1_initial}\nREQ-XYZ-001 & a & b & c \\\\", 1)),
        "unknown_decision_reference": ("chapters/10_verifikation_traceability.tex",
                                       lambda text: text.replace("Gemaess DEC-014", "Gemaess DEC-099", 1)),
        "undeclared_ros2_topic": ("sysml/baseline_a1/07_ros2_mapping.sysml",
                                  lambda text: text.replace("Publiziert: /odom", "Publiziert: /odom, /undeclared", 1)),
        "hand_written_subsystem_row": ("chapters/08_architektur.tex",
                                       lambda text: text.replace("\\modeltable{subsystems_a1}",
                                                                 "\\modeltable{subsystems_a1}\nExtraSystem & x & y \\\\", 1)),
        "hand_written_non_goal": ("chapters/03_systemdefinition.tex",
                                  lambda text: text.replace("\\modeltext{non_goals_a1}",
                                                            "\\modeltext{non_goals_a1}\n  \\item Raumfahrt.", 1)),
        "open_function_chain": ("sysml/baseline_a1/08_traceability.sysml",
                                lambda text: text.replace(
                                    "  dependency from MobileMaterialRobot_Structure_A1::EnergySystem to "
                                    "MobileMaterialRobot_Requirements_A1::REQ_PWR_001;\n", "", 1)),
        "missing_state_position": ("figures/tikz/state_machine_layout.tex",
                                   lambda text: text.replace("\\coordinate (pos-returnPaused)", "% removed", 1)),
        "function_without_performer": ("sysml/baseline_a1/03_structure.sysml",
                                       lambda text: text.replace("    perform action executeMotion : FUN_MOT_001;\n", "", 1)),
        "unknown_assumption_reference": ("chapters/11_iteration_a_status.tex",
                                         lambda text: text.replace("A-001 bis A-011", "A-001 bis A-099", 1)),
    }
    for name, (rel, mutate) in mutations.items():
        with tempfile.TemporaryDirectory(prefix="docs-negative-") as temporary:
            copy = Path(temporary)
            for folder in ("chapters", "appendices", "tables", "sysml", "figures"):
                shutil.copytree(REPO / folder, copy / folder)
            target = copy / rel
            original = target.read_text(encoding="utf-8")
            changed = mutate(original)
            if changed == original:
                raise RuntimeError(f"Negative documentation test {name} did not change {rel}")
            target.write_text(changed, encoding="utf-8")
            try:
                documentation_checks(copy)
            except RuntimeError:
                print(f"NEGATIVE {name}: detected")
                continue
            raise RuntimeError(f"Negative documentation test did not detect {name}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java", help="Java 21+ executable")
    parser.add_argument("--pilot-home", type=Path, help="Existing Pilot sysml directory (skips download)")
    parser.add_argument("--model", type=Path, default=REPO / "sysml")
    parser.add_argument("--self-test", action="store_true", help="Evaluate synthetic pass/fail/inconclusive fixtures")
    parser.add_argument("--negative-tests", action="store_true", help="Check missing imports/features and type mismatch in temporary copies")
    args = parser.parse_args()
    java = java_command(args.java)
    home = pilot_home(args.pilot_home)
    model = args.model.resolve()
    architecture_checks(model)
    state_machine_checks(model)
    if (REPO / "chapters").is_dir() and model == (REPO / "sysml").resolve():
        documentation_checks(REPO)
    result = invoke(java, home, model, args.self_test)
    print(result.stdout, end="")
    print(result.stderr, end="", file=sys.stderr)
    if result.returncode:
        return result.returncode
    if args.negative_tests:
        negative_checks(java, home, model)
        negative_state_machine_check(model)
        if (REPO / "chapters").is_dir() and model == (REPO / "sysml").resolve():
            inheritance_check()
        if (REPO / "chapters").is_dir() and model == (REPO / "sysml").resolve():
            negative_documentation_check()
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, subprocess.SubprocessError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(2)
