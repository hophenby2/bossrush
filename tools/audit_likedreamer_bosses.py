#!/usr/bin/env python3
"""逐阶段核对 Like Dreamer 关底 Boss 的直接发弹，并输出差异证据。

参照函数从用户本地的 C++ 复原目录读取，不随项目分发。夹具分别运行
根对象和子部件，不模拟新建对象、受击、渲染、音频或全局弹数上限。
零条记录只表示该对象不直接发弹，不能作为整个阶段通过的依据。
复原代码也可能有误；数值微差必须回查 EXE，不能自动改写移植版。
"""
import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from check_likedreamer_parity import extract_function, extract_struct

PROJECT = Path(__file__).resolve().parent.parent
FIXTURES = PROJECT / "tools/likedreamer_parity"
MAIN = "stage_runtime.cpp"
LATE = "stage_runtime_late.cpp"
S7 = "stage_runtime_boss07.cpp"
S8 = "stage_runtime_boss08.cpp"
S9 = "stage_runtime_boss09.cpp"
AUX = "stage_runtime_boss10_aux.cpp"
PORT_FILES = [PROJECT / "mod/GAME/ports/dreamer/LikeDreamer" / (name + ".lua")
              for name in ("core", "projectile", "boss_early", "boss_middle", "boss_late", "boss_recovered")]
PORT_FILES += sorted((PROJECT / "mod/GAME/ports/dreamer/LikeDreamer/recovered").glob("*.lua"))
PORT_FILES += [PROJECT / "mod/GAME/th42.lua"]

ROOT_METHODS = [(stage, MAIN, f"emitStage{stage:02}BossProjectiles") for stage in range(1, 5)] + [
    (5, LATE, "emitStage05BossProjectiles"),
    (6, LATE, "updateStage06Boss"),
    (8, S8, "emitStage08BossProjectiles"),
    (9, S9, "emitStage09BossProjectiles"),
]
NODE_METHODS = [
    (1, MAIN, "updateStage01BossChild"), (1, MAIN, "emitStage01BossChildProjectiles"),
    (2, MAIN, "updateStage02BossChild"), (2, MAIN, "emitStage02BossChildProjectiles"),
    (3, MAIN, "updateStage03BossChild"), (3, MAIN, "updateStage03Type30"),
    (3, MAIN, "updateStage03Type31"), (3, MAIN, "updateStage03Type32Or33"),
    (3, MAIN, "updateStage03Type34"),
    (4, MAIN, "updateStage04BossChild"), (4, MAIN, "updateStage04Type40"),
    (4, MAIN, "updateStage04Type41"), (4, MAIN, "updateStage04Type42Or43"),
    (5, LATE, "updateStage05BossChild"), (6, LATE, "updateStage06BossNode"),
    (7, S7, "updateStage07BossNode"), (8, S8, "updateStage08BossNode"),
    (9, S9, "updateStage09BossNode"), (10, LATE, "updateStage10FinalBossNode"),
    (10, AUX, "isStage10FinalBossEmitterType"), (10, AUX, "updateStage10FinalBossEmitter"),
]

# 每个外层列表是一段血条；内层可以含多个状态或发弹部件。
ROOT_PHASES = {
    1: [[1], [3], [5]], 2: [[1], [3], [5], [7]],
    3: [[1], [3], [5], [7]], 4: [[1], [3, 5], [7], [10]],
    5: [[1], [3], [5], [7], [9], [11]],
    6: [[], [], [], [], [9]],
    8: [[1, 2], [11], [21], [31], [41], [51, 52], list(range(62, 68))],
    9: [[1], [6], [*range(11, 28), *range(111, 118)], [61, 62, 161]],
    10: [[1], [], [21], [], [41], [], [61], [], [81], [], [101], [], [121], [131], [141], [151, 152, 153]],
    11: [[2], [4], [6]],  # 第 10 关前置场景 Boss 14c，单列以免与最终 Boss 混淆。
}
NODE_PHASES = {
    1: [[], [(0x15, 3)], [(0x16, 5), (0x17, 5)]],
    2: [[], [(0x22, 3)], [(0x23, 5)], [(0x24, 7)]],
    3: [[(0x30, 1), (0x31, 1)], [], [(0x32, 5), (0x33, 5)], [(0x34, 7)]],
    4: [[(0x40, 1)], [(0x41, 3)], [(0x42, 7)], [(0x43, 10)]],
    5: [[], [], [], [], [(0x54, 9), (0x55, 9)], [(0x56, 11)]],
    6: [[(kind, 1) for kind in range(0x66, 0x6b)], [(kind, 3) for kind in range(0x6b, 0x6e)],
        [(0x6e, 5)], [(0x6f, 7)], []],
    7: [[(kind, 1) for kind in range(0x87, 0x8b)], [(0x83, 11), (0x84, 11)],
        [(0x83, 21), (0x84, 41)], [(0x83, 31), (0x84, 51)], [(0x83, 61), (0x84, 61)]],
    8: [[(kind, 1) for kind in range(0xa7, 0xad)], [(kind, 11) for kind in range(0xad, 0xb0)],
        [(kind, 21) for kind in range(0xb0, 0xb4)], [(0xb4, 31), (0xb5, 31)],
        [(0xb6, 41), (0xb7, 41)], [(0xb8, 51), (0xb9, 52), (0xba, 52)],
        [(kind, state) for kind in range(0xbc, 0xc3) for state in range(62, 68)]],
    9: [[(kind, 1) for kind in (0xce, *range(0xd0, 0xd6))],
        [(kind, 6) for kind in (0xcf, *range(0xd6, 0xda))], [],
        [(0xda, 61), (0xdb, 61), (0xdc, 62), (0xdd, 62)]],
    10: [[(0x105, 1)], [(0x111, 11)], [(0x106, 21)], [(0x112, 31)],
         [(0x107, 41)], [(0x113, 51), (0x114, 51)], [(0x10c, 61), (0x10d, 61)],
         [(kind, 71) for kind in range(0x115, 0x11a)], [(0x10e, 81)],
         [(kind, 91) for kind in range(0x11a, 0x11d)], [(0x108, 101), (0x109, 101)],
         [(kind, 111) for kind in (*range(0x11d, 0x125),)],
         [(0x10f, 121), (0x110, 121)], [(0x125, 131), (0x126, 131)],
         [(kind, 141) for kind in range(0x127, 0x12d)],
         [(kind, 151) for kind in range(0x12d, 0x134)] + [(0x134, 153), (0x135, 153)]],
}


def lambda_method(source, label, name, prefix=""):
    start = source.index("const auto " + label + " =")
    brace = source.index("{", start)
    end, depth = brace + 1, 1
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return f"void StageRuntime::{name}(StageEnemy& enemy){{{prefix}" + source[brace + 1:end - 1] + "}"


def dependencies(source, body):
    found = {}
    pending = [body]
    while pending:
        for name in set(re.findall(r"\b([a-zA-Z]\w*)\(", pending.pop())):
            if name in found or name == "StageRuntime":
                continue
            try:
                function = extract_function(source, name)
            except ValueError:
                continue
            found[name] = function
            pending.append(function)
    return found


def prepare(reference, output, suite):
    sources = {name: (reference / name).read_text() for name in (MAIN, LATE, S7, S8, S9, AUX)}
    methods = [(stage, name, extract_function(sources[file], "StageRuntime::" + name), sources[file])
               for stage, file, name in (ROOT_METHODS if suite == "roots" else NODE_METHODS)]
    if suite == "roots":
        aim = ("const auto aimFrom=[this](float x,float y){return radiansToAngle16("
               "std::atan2(static_cast<double>(player_.y-y),static_cast<double>(player_.x-x)));};")
        for stage, label, name, prefix in ((10, "emitFinalRootPattern", "emitFinalRootPattern", aim),
                                          (11, "emitStage10ScenePattern", "emitScenePattern", "")):
            methods.append((stage, name, lambda_method(sources[LATE], label, name, prefix), sources[LATE]))
    helpers = {}
    for _, _, body, source in methods:
        helpers.update(dependencies(source, body))
        helpers.update(dependencies(sources[MAIN], body))
    ordered, visiting = {}, set()

    def order(name):
        if name in ordered or name in visiting:
            return
        visiting.add(name)
        for child in re.findall(r"\b([a-zA-Z]\w*)\(", helpers[name])[1:]:
            if child in helpers and child != name:
                order(child)
        ordered[name] = helpers[name]
    for name in helpers:
        order(name)
    used = "\n".join([method[2] for method in methods] + list(ordered.values()))
    constants = {}
    for source in sources.values():
        for definition in re.findall(r"(?m)^constexpr [^;]+;", source):
            match = re.search(r"\b(k\w+)\b", definition)
            if match and re.search(r"\b" + match[1] + r"\b", used):
                constants[match[1]] = definition
    # EXE 的 0x14053a020 是 double 3.14159265358979；早期复原中的
    # float kPi 会让轨道积累、散射种子及整数角产生伪差异。
    constants.pop("kPi", None)
    constants.pop("kTau", None)
    precision = ("#ifdef LD_EARLY\nconstexpr double kPi=3.14159265358979;\n"
                 "constexpr double kTau=kPi*2.0;\n#else\n"
                 "constexpr double kPi=3.14159265358979323846;\n"
                 "constexpr double kTau=kPi*2.0;\n#endif\n")
    (output / "reference_constants.inc").write_text(precision + "\n".join(constants.values()))
    (output / "reference_helpers.inc").write_text("\n".join(ordered.values()))
    header = (reference / "stage_runtime.h").read_text()
    enemy = extract_struct(header, "StageEnemy")
    if suite == "nodes":
        late = sources[LATE]
        enemy = (late[late.index("struct Stage10FinalBossNodeSpec"):late.index("// FUN_1400630f0")]
                 + late[late.index("const Stage10FinalBossNodeSpec* stage10FinalBossNodeSpec"):
                        late.index("bool isStage10FinalBossAuxNodeType")] + enemy)
    (output / "reference_enemy.inc").write_text(enemy)
    (output / "reference_declarations.inc").write_text("\n".join(
        method[:method.index("{")].replace("StageRuntime::", "") + ";" for _, _, method, _ in methods))
    (output / "reference_behavior.inc").write_text("\n".join(method[2] for method in methods))


def first_difference(expected, actual):
    for row, (left, right) in enumerate(itertools.zip_longest(expected, actual), 1):
        if left is None or right is None:
            return {"row": row, "reference": left, "port": right, "reason": "记录条数不同"}
        a, b = left.split(), right.split()
        if len(a) != len(b) or a[0] != b[0]:
            return {"row": row, "reference": left, "port": right, "reason": "记录类型不同"}
        for column in range(1, len(a)):
            # 坐标允许 0.01 原版像素；时点、角度、ID、半径与条数要求一致。
            tolerance = 0.01 if column in (4, 5) else 0.00002
            x, y = float(a[column]), float(b[column])
            if not math.isfinite(x) or not math.isfinite(y) or abs(x - y) > tolerance:
                return {"row": row, "column": column, "reference": left, "port": right,
                        "reason": "坐标差异" if column in (4, 5) else "发弹参数或时点不同"}
    return None


def run_suite(reference, output, suite, compiler, luajit, stages, frames):
    prepare(reference, output, suite)
    binaries = {}
    for early in (True, False):
        binary = output / (suite + ("-early" if early else "-late"))
        subprocess.run([compiler, "-std=c++17", "-O0", "-ffp-contract=off", *(["-DLD_EARLY"] if early else []),
                        "-I", str(output), str(FIXTURES / f"boss_{suite}.cpp"), "-o", str(binary)], check=True)
        binaries[early] = binary
    inventory = ROOT_PHASES if suite == "roots" else NODE_PHASES
    results = []
    for stage, phases in inventory.items():
        if stages and stage not in stages:
            continue
        for phase, probes in enumerate(phases, 1):
            for probe in probes:
                values = (probe,) if suite == "roots" else probe
                record = {"suite": suite, "stage": stage, "phase": phase, "probe": list(values),
                          "cases": 0, "matching_cases": 0, "reference_shots": 0,
                          "port_shots": 0, "differences": []}
                variants = itertools.product(range(5), (0, 4)) if suite == "roots" else ((d,) for d in range(5))
                for variant in variants:
                    args = [str(value) for value in (stage, *values, *variant, frames)]
                    expected = subprocess.check_output([str(binaries[stage <= 4]), *args], timeout=30).decode().splitlines()
                    run = subprocess.run([luajit, str(FIXTURES / f"boss_{suite}.lua"), *args],
                                         cwd=PROJECT, capture_output=True, text=True, timeout=30)
                    actual = run.stdout.splitlines()
                    difference = first_difference(expected, actual)
                    if run.returncode:
                        difference = {"reason": "Lua 夹具运行错误", "error": run.stderr[:1500]}
                    record["cases"] += 1
                    record["reference_shots"] += len(expected)
                    record["port_shots"] += len(actual)
                    if difference:
                        record["differences"].append({"difficulty": variant[0],
                                                      "live_children": variant[1] if suite == "roots" else 4,
                                                      "reference_shots": len(expected), "port_shots": len(actual),
                                                      **difference})
                    else:
                        record["matching_cases"] += 1
                # 不把两个空轨迹标为通过。
                record["status"] = ("存在差异" if record["differences"] else "直接发弹轨迹一致"
                                    if record["reference_shots"] else "无直接发弹，须检查创建链")
                print(f"{suite} stage={stage} phase={phase} probe={values}: {record['status']}", flush=True)
                results.append(record)
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="原版游戏目录或复原项目 src 目录")
    parser.add_argument("--output", type=Path, required=True, help="写入 JSON 诊断报告")
    parser.add_argument("--suite", choices=("all", "roots", "nodes"), default="all")
    parser.add_argument("--frames", type=int, default=2400, help="逐对象核对帧数；7200 可覆盖长周期")
    parser.add_argument("--stage", type=int, action="append", help="11 表示第 10 关前置场景 Boss")
    args = parser.parse_args()
    reference = args.reference.resolve()
    if not (reference / MAIN).is_file():
        reference /= "reverse/reconstructed/project/src"
    compiler, luajit = shutil.which("clang++") or shutil.which("g++"), shutil.which("luajit")
    if not compiler or not luajit or not (reference / "stage_runtime.h").is_file():
        parser.error("需要 C++17 编译器、LuaJIT 和原版本地复原源码")
    report = {"reference": str(reference), "frames_per_case": args.frames,
              "record_columns": ["b", "frame", "visual", "movement_id", "x", "y", "angle16", "speed", "travel", "radius", "aux"],
              "limitations": ["逐对象诊断，不等于整场实机或全行为对齐验收", "不自动推进新建的子对象",
                              "不包含受击、超时、渲染、音频、全局弹数上限", "复原源码数值微差须回查 EXE"],
              "source_sha256": {name: hashlib.sha256((reference / name).read_bytes()).hexdigest()
                                for name in (MAIN, LATE, S7, S8, S9, AUX, "stage_runtime.h")},
              "port_sha256": {str(path.relative_to(PROJECT)): hashlib.sha256(path.read_bytes()).hexdigest()
                              for path in PORT_FILES}, "probes": []}
    with tempfile.TemporaryDirectory(prefix="likedreamer-boss-audit-") as directory:
        for suite in (("roots", "nodes") if args.suite == "all" else (args.suite,)):
            report["probes"].extend(run_suite(reference, Path(directory), suite, compiler, luajit, args.stage, args.frames))
    phase_keys = sorted({(probe["stage"], probe["phase"]) for probe in report["probes"]})
    report["phase_summary"] = []
    for stage, phase in phase_keys:
        probes = [probe for probe in report["probes"] if (probe["stage"], probe["phase"]) == (stage, phase)]
        report["phase_summary"].append({
            "stage": stage, "phase": phase,
            "label": f"第{stage}关第{phase}阶段" if stage != 11 else f"第10关场景Boss第{phase}阶段",
            "cases": sum(probe["cases"] for probe in probes),
            "matching_cases": sum(probe["matching_cases"] for probe in probes),
            "reference_shots": sum(probe["reference_shots"] for probe in probes),
            "status": "存在差异" if any(probe["differences"] for probe in probes) else "所测直接发弹轨迹一致，非整阶段验收",
        })
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(f"报告：{args.output.resolve()}；{sum(p['cases'] for p in report['probes'])} 个逐对象场景")


if __name__ == "__main__":
    main()
