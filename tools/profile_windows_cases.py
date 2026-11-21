#!/usr/bin/env python3
"""使用独立 User/replay 运行 Windows 背景和弹幕采样，不改写玩家数据。"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--case', choices=['th37-stage6', 'th39-39060', 'window'], required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--frames', type=int, default=6000)
    parser.add_argument('--clock', type=int, default=0)
    parser.add_argument('--no-draw', action='store_true')
    parser.add_argument('--sample', action='store_true')
    parser.add_argument('--warm', action='store_true', help='沿正式关卡准备入口预载背景模型')
    parser.add_argument('--cpu', action='store_true', help='关闭原生网格，仅用于画面对照')
    parser.add_argument('--capture', action='store_true')
    parser.add_argument('--full-game', action='store_true', help='通过正式符卡练习入口运行天月祝鸣，保留界面与碰撞流程')
    parser.add_argument('--operations', action='store_true', help='只用于分解出生尖峰，不与无探针耗时直接比较')
    parser.add_argument('--frame-detail', action='store_true', help='分解正式练习的框架、对象和碰撞耗时，仅用于定位')
    parser.add_argument('--trace', action='store_true', help='记录 LuaJIT 轨迹编译时间')
    parser.add_argument('--gc-probe', action='store_true', help='仅用于诊断：在集中发弹窗口暂停自动 GC，结束后恢复，不用于正式性能结论')
    parser.add_argument('--checkpoints', action='store_true', help='保存弹体检查点；轨迹核对与纯耗时采样分开')
    parser.add_argument('--rich-checkpoints', action='store_true', help='检查外观、判定、插值执行器及发弹尖峰前后状态')
    parser.add_argument('--checkpoint-step', type=int, default=600)
    parser.add_argument('--baseline-runtime', action='store_true', help='仅在隔离目录使用 HEAD 中的永夜运行时作对照')
    parser.add_argument('--runtime-file', type=Path, help='仅在隔离目录载入指定的对照运行时')
    parser.add_argument('--fps', type=int, default=60)
    args = parser.parse_args()
    if args.checkpoint_step < 1:
        parser.error('--checkpoint-step 必须为正数')
    if args.runtime_file and args.baseline_runtime:
        parser.error('--runtime-file 与 --baseline-runtime 不能同时使用')
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    for directory in ['THlib', 'Resources', 'mod', 'music', 'shader', 'tools']:
        # 引擎校验路径的真实大小写，目录 junction 会被识别成源目录而拒绝加载。
        shutil.copytree(ROOT / directory, out / directory, copy_function=os.link)
    for name in ['LuaSTGSub.exe', 'd3dcompiler_47.dll', 'xaudio2_9redist.dll', 'launch.lua', 'launcher.lua']:
        shutil.copy2(ROOT / name, out / name)
    shutil.copy2(ROOT / 'core.lua', out / 'game-core.lua')
    shutil.copy2(ROOT / 'tools/profile_windows_cases.lua', out / 'core.lua')
    for directory in ['User', 'replay', 'snapshot', 'userdata']:
        (out / directory).mkdir()
    if args.baseline_runtime or args.runtime_file:
        target=out/'mod/GAME/th39/runtime.lua'
        target.unlink()  # 只解除隔离目录中的硬链接，随后写入独立副本。
        target.write_bytes(args.runtime_file.read_bytes() if args.runtime_file else
            subprocess.check_output(['git','show','HEAD:mod/GAME/th39/runtime.lua'],cwd=ROOT))
    configuration = json.loads((ROOT / 'config.json').read_text(encoding='utf-8'))
    (out / 'config.json').write_text(json.dumps(configuration), encoding='utf-8')
    (out / 'case.json').write_text(json.dumps(vars(args), default=str), encoding='utf-8')
    width, height = (480, 640) if args.case == 'window' else (960, 720)
    (out / 'launch').write_text("lstg.DoFile('launch.lua')\nsetting.mod='launcher'\n"
        f"setting.resx={width};setting.resy={height};setting.windowed=true;setting.vsync=false\n"
        f"SetResolution({width},{height});SetWindowed(true);SetVsync(false);SetBGMVolume(0);SetSEVolume(0)\n",
        encoding='utf-8')
    process = subprocess.Popen([str(out / 'LuaSTGSub.exe')], cwd=out)
    (out / 'pid.txt').write_text(str(process.pid))
    started = time.monotonic()
    try:
        process.wait(timeout=max(150, args.frames / min(args.fps, 30) + 90))
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait()
        raise RuntimeError('采样超时，请查看隔离目录日志：' + str(out))
    report = out / 'result.json'
    if not report.exists():
        raise RuntimeError('没有生成采样报告，退出码：' + str(process.returncode))
    result = json.loads(report.read_text(encoding='utf-8'))
    result['frames']=[json.loads(line) for line in (out/'frames.jsonl').read_text(encoding='utf-8').splitlines()]
    result['checkpoints']=[json.loads(line) for line in (out/'checkpoints.jsonl').read_text(encoding='utf-8').splitlines()]
    result['inputs'] = vars(args) | {'out': str(out)}
    result['engine'] = json.loads((ROOT / 'windows/engine.lock.json').read_text(encoding='utf-8'))
    result['sha256'] = {name: hashlib.sha256((out / name).read_bytes()).hexdigest() for name in
        ['LuaSTGSub.exe', 'mod/GAME/th37/background.lua', 'mod/GAME/th37/source_mesh.lua',
         'mod/GAME/th39/runtime.lua', 'mod/GAME/ports/binding_index.lua']}
    result['wall_seconds'] = time.monotonic() - started
    report.write_text(json.dumps(result, ensure_ascii=False, default=str), encoding='utf-8')
    if result.get('error'):
        raise RuntimeError(result['error'])
    print(json.dumps({k: v for k, v in result.items() if k not in ['frames', 'stacks', 'checkpoints', 'operations', 'traces']}, ensure_ascii=False, default=str))


if __name__ == '__main__':
    main()
