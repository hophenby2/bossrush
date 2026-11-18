#!/usr/bin/env python3
"""Compare native Lua behaviors with the local Like Dreamer C++ reconstruction.

Covers Stage 9's six midbosses and their children, and movement IDs 0x00–0x3c.
The reference sources remain external. Rendering, collisions, audio, and the
global projectile cap are omitted in both fixtures.
"""
import argparse
import itertools
import math
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

PROJECT = Path(__file__).resolve().parent.parent
FIXTURES = PROJECT / "tools/likedreamer_parity"
PROJECTILE_METHODS = (
    "updateProjectileCommonMotion",
    "updateProjectileReflectOnBoundary",
    "updateProjectileHomingSteering",
    "updateProjectileScriptedEmitter",
    "updateProjectileOrbitArcPair",
    "updateProjectileExpandingSpiralPair",
)
PROJECTILE_HELPERS = (
    "clampFloat", "stageScriptRandFromFrame", "scriptRandomHundredth",
    "scriptRandomAngle", "normalizeAngle16", "fixedAngleToRadians",
    "fixedAngleToRadiansDouble", "radiansToFixedAngleTrunc",
    "approachAngle16", "projectileHorizontalOrigin",
)


def extract_function(source, name):
    signature = re.search(
        rf"(?m)^[\w:<>]+ {re.escape(name)}\([^;{{}}]*?\)(?: const)?\s*\{{",
        source,
    )
    if signature is None:
        raise ValueError(f"Reference function missing: {name}")
    position = signature.end()
    depth = 1
    while depth:
        if source[position] == "{":
            depth += 1
        elif source[position] == "}":
            depth -= 1
        position += 1
    return source[signature.start():position]


def extract_struct(header, name):
    start = header.index(f"    struct {name} {{")
    end = header.index("\n    };", start) + len("\n    };")
    return header[start:end]


def prepare_stage9(reference, output, header):
    behavior = []
    declarations = []
    for filename in ("stage_runtime_midboss09.cpp", "stage_runtime_midboss09_tail.cpp"):
        source = (reference / filename).read_text()
        # Drawing follows all gameplay methods in these two translation units.
        source = source[:source.index("bool StageRuntime::draw")]
        source = re.sub(r"^#include.*\n", "", source, flags=re.MULTILINE)
        declarations.extend(
            declaration.replace("StageRuntime::", "") + ";"
            for declaration in re.findall(
                r"(?:bool|void) StageRuntime::[^{}]+(?=\{)", source,
            )
        )
        behavior.append(source + "\n}\n")
    (output / "reference_enemy.inc").write_text(extract_struct(header, "StageEnemy"))
    (output / "reference_declarations.inc").write_text("\n".join(declarations))
    (output / "reference_behavior.inc").write_text("\n".join(behavior))


def prepare_projectiles(reference, output, header):
    source = (reference / "stage_runtime.cpp").read_text()
    methods = [
        extract_function(source, "StageRuntime::" + name)
        for name in PROJECTILE_METHODS
    ]
    # FUN_14006ecf0 uses these double constants in the EXE. The reconstruction
    # approximates this one phase with its float kTau, changing integer turns.
    methods = [
        method.replace(
            "(projectile.age + 30) * static_cast<double>(kTau) / 120.0",
            "(projectile.age+30)*546.1333333333333*3.14159265358979*3.0517578125e-5",
        )
        for method in methods
    ]
    helpers = [extract_function(source, name) for name in PROJECTILE_HELPERS]
    used = "\n".join(methods + helpers)
    constants = []
    for definition in re.findall(r"(?m)^constexpr [^;]+;", source):
        name = re.search(r"\b(k\w+)\b", definition).group(1)
        if re.search(rf"\b{name}\b", used) or name == "kPi":
            constants.append(definition)
    constants.sort(key=lambda definition: 0 if re.search(r"\bkPi\s*=", definition) else 1)
    (output / "reference_helpers.inc").write_text("\n".join(constants + helpers))
    (output / "reference_projectile.inc").write_text(extract_struct(header, "StageProjectile"))
    (output / "reference_behavior.inc").write_text("\n".join(methods))


def compare_trace(suite, case, expected, actual):
    for row, pair in enumerate(itertools.zip_longest(expected, actual), 1):
        original, port = pair
        context = f"{suite} {case}, row {row}"
        if original is None or port is None:
            raise AssertionError(f"{context}: trace lengths differ")
        left, right = original.split(), port.split()
        if len(left) != len(right) or left[0] != right[0]:
            raise AssertionError(f"{context}: {original!r} != {port!r}")
        for column in range(1, len(left)):
            if suite == "stage9":
                coordinates = (5, 6)
                # Host enemy cleanup requires a positive hp sentinel while
                # scripted death and delayed-damage cleanup finish.
                death_sentinel = (
                    left[0] == b"s" and column == 10
                    and (
                        (left[2] == b"1" and left[3] == b"2")
                        or left[3] == b"-1"
                        or (left[10] == b"0" and left[11] == b"0")
                    )
                )
                if death_sentinel:
                    continue
                tolerance = 0.002 if column in coordinates else 0.000002
            else:
                # Removed Lua objects immediately disable their collision bit.
                if left[0] == b"s" and column == 8 and left[7] == b"0":
                    continue
                coordinates = (2, 3, 6) if left[0] == b"s" else (4, 5)
                tolerance = 0.005 if column in coordinates else 0.000002
            expected_number, actual_number = float(left[column]), float(right[column])
            if (
                not math.isfinite(expected_number)
                or not math.isfinite(actual_number)
                or abs(expected_number - actual_number) > tolerance
            ):
                raise AssertionError(f"{context}: {original!r} != {port!r}")


def run_suite(suite, reference, compiler, luajit):
    header = (reference / "stage_runtime.h").read_text()
    with tempfile.TemporaryDirectory(prefix="likedreamer-parity-") as directory:
        output = Path(directory)
        prepare = prepare_stage9 if suite == "stage9" else prepare_projectiles
        prepare(reference, output, header)
        binary = output / "reference"
        subprocess.run(
            [compiler, "-std=c++17", "-O0", "-ffp-contract=off", "-I", str(output),
             str(FIXTURES / (suite + ".cpp")), "-o", str(binary)],
            check=True,
        )
        cases = (
            itertools.product(range(6), range(5), range(4))
            if suite == "stage9"
            else itertools.product(range(61), range(5), (0, 2, 5), range(3))
        )
        case_count = record_count = 0
        for case in cases:
            args = [str(value) for value in case]
            expected = subprocess.check_output([str(binary), *args], timeout=30).splitlines()
            actual = subprocess.check_output(
                [luajit, str(FIXTURES / (suite + ".lua")), *args],
                cwd=PROJECT, timeout=30,
            ).splitlines()
            compare_trace(suite, case, expected, actual)
            case_count += 1
            record_count += len(expected)
        print(f"{suite}: {case_count} cases, {record_count} matching records", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="Original game folder, or reconstruction src folder")
    parser.add_argument("--suite", choices=("all", "stage9", "projectiles"), default="all")
    args = parser.parse_args()
    reference = args.reference.resolve()
    if not (reference / "stage_runtime.cpp").is_file():
        reference = reference / "reverse/reconstructed/project/src"
    if not (reference / "stage_runtime.h").is_file():
        parser.error("Reference directory must contain stage_runtime.h and stage_runtime.cpp")
    compiler = shutil.which("clang++") or shutil.which("g++")
    luajit = shutil.which("luajit")
    if not compiler or not luajit:
        parser.error("A C++17 compiler and LuaJIT are required")
    suites = ("stage9", "projectiles") if args.suite == "all" else (args.suite,)
    for suite in suites:
        run_suite(suite, reference, compiler, luajit)


if __name__ == "__main__":
    main()
