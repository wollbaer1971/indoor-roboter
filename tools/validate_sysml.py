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
                 if re.search(r"\bpart def MobileMaterialRobot\s*\{", text)]
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
    result = invoke(java, home, model, args.self_test)
    print(result.stdout, end="")
    print(result.stderr, end="", file=sys.stderr)
    if result.returncode:
        return result.returncode
    if args.negative_tests:
        negative_checks(java, home, model)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, subprocess.SubprocessError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(2)
