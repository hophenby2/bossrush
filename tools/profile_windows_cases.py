#!/usr/bin/env python3
"""使用独立 User/replay 运行 Windows 背景和弹幕采样，不改写玩家数据。"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main():
    sys.stdout.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--case', choices=['th37-stage6', 'th39-39060', 'window', 'frame-pacing', 'image-state', 'object-image-state', 'target-query', 'source-audio', 'catalogue', 'practice', 'sequence'], required=True)
    parser.add_argument('--level', type=int, help='正式练习的内部 level，保留原编号')
    parser.add_argument('--card', type=int, help='正式练习 card_id')
    parser.add_argument('--machine', help='原作机体 ID；省略时使用该作默认机体')
    parser.add_argument('--sequence', help='顺序路线 key，配合 sequence 场景')
    parser.add_argument('--chapter', help='关卡练习章节，不跳过章内原作逻辑')
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--frames', type=int, default=6000)
    parser.add_argument('--clock', type=int, default=0)
    parser.add_argument('--no-draw', action='store_true')
    parser.add_argument('--sample', action='store_true')
    parser.add_argument('--warm', action='store_true', help='沿正式关卡准备入口预载背景模型')
    parser.add_argument('--cpu', action='store_true', help='关闭原生网格，仅用于画面对照')
    parser.add_argument('--capture', action='store_true')
    parser.add_argument('--capture-at', type=int, action='append', default=[], help='额外截图的正式逻辑帧，可重复指定')
    parser.add_argument('--return-menu-at', type=int, help='在指定逻辑帧经正式入口返回标题，检查切关清理')
    parser.add_argument('--full-game', action='store_true', help='通过正式符卡练习入口运行天月祝鸣，保留界面与碰撞流程')
    parser.add_argument('--operations', action='store_true', help='只用于分解出生尖峰，不与无探针耗时直接比较')
    parser.add_argument('--frame-detail', action='store_true', help='分解正式练习的框架、对象和碰撞耗时，仅用于定位')
    parser.add_argument('--engine-stats', action='store_true', help='采集引擎整帧等待、更新、绘制与提交计时')
    parser.add_argument('--trace', action='store_true', help='记录 LuaJIT 轨迹编译时间')
    parser.add_argument('--jit-cache', action='store_true', help='隔离对照较大的 LuaJIT 轨迹缓存，不改弹幕参数')
    parser.add_argument('--jit-default', action='store_true', help='隔离对照 LuaJIT 官方默认缓存容量')
    parser.add_argument('--gc-probe', action='store_true', help='仅用于诊断：在集中发弹窗口暂停自动 GC，结束后恢复，不用于正式性能结论')
    parser.add_argument('--checkpoints', action='store_true', help='保存弹体检查点；轨迹核对与纯耗时采样分开')
    parser.add_argument('--rich-checkpoints', action='store_true', help='检查外观、判定、插值执行器及发弹尖峰前后状态')
    parser.add_argument('--checkpoint-step', type=int, default=600)
    parser.add_argument('--baseline-runtime', action='store_true', help='仅在隔离目录使用 HEAD 中的永夜运行时作对照')
    parser.add_argument('--runtime-file', type=Path, help='仅在隔离目录载入指定的对照运行时')
    parser.add_argument('--night-system-file', type=Path, help='仅在隔离目录载入指定的永夜自机系统桥接作对照')
    parser.add_argument('--engine-file', type=Path, help='仅在隔离目录使用指定引擎作对照')
    parser.add_argument('--override-dir', type=Path, help='仅在隔离目录用指定目录内的 Lua 源码作前后对照')
    parser.add_argument('--lantern', action='store_true', help='正式练习中按原作输入开启灯笼，核对消弹路径')
    parser.add_argument('--shoot', action='store_true', help='正式练习持续射击；采样夹具恢复 Boss 血量以覆盖完整集中发弹阶段')
    parser.add_argument('--shield', action='store_true', help='覆盖闭灯保护消弹分支及其 61/60 帧边界')
    parser.add_argument('--fps', type=int, default=60)
    args = parser.parse_args()
    if args.case in ('catalogue','practice','sequence'):
        args.full_game=True
    if args.case=='practice' and (args.level is None or args.card is None):
        parser.error('practice 必须指定 --level 和 --card')
    if args.case=='sequence' and (args.level is None or args.sequence is None or args.chapter is None):
        parser.error('sequence 必须指定 --level、--sequence 和 --chapter')
    if args.checkpoint_step < 1:
        parser.error('--checkpoint-step 必须为正数')
    if args.runtime_file and args.baseline_runtime:
        parser.error('--runtime-file 与 --baseline-runtime 不能同时使用')
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    for directory in ['THlib', 'Resources', 'mod', 'music', 'shader', 'tools']:
        # 引擎校验路径的真实大小写，目录 junction 会被识别成源目录而拒绝加载。
        shutil.copytree(ROOT / directory, out / directory, copy_function=os.link)
    for name in ['d3dcompiler_47.dll', 'xaudio2_9redist.dll', 'launch.lua', 'launcher.lua']:
        shutil.copy2(ROOT / name, out / name)
    shutil.copy2(args.engine_file or ROOT/'LuaSTGSub.exe',out/'LuaSTGSub.exe')
    shutil.copy2(ROOT / 'core.lua', out / 'game-core.lua')
    shutil.copy2(ROOT / 'tools/profile_windows_cases.lua', out / 'core.lua')
    for directory in ['User', 'replay', 'snapshot', 'userdata']:
        (out / directory).mkdir()
    if args.baseline_runtime or args.runtime_file:
        target=out/'mod/GAME/th39/runtime.lua'
        target.unlink()  # 只解除隔离目录中的硬链接，随后写入独立副本。
        target.write_bytes(args.runtime_file.read_bytes() if args.runtime_file else
            subprocess.check_output(['git','show','HEAD:mod/GAME/th39/runtime.lua'],cwd=ROOT))
    if args.night_system_file:
        target=out/'mod/GAME/ports/mhj/native_players/night_system.lua'
        target.unlink()
        target.write_bytes(args.night_system_file.read_bytes())
    if args.override_dir:
        overlay=args.override_dir.resolve()
        for source in overlay.rglob('*.lua'):
            relative=source.relative_to(overlay)
            if relative.parts[0] not in ('THlib','mod') and relative.as_posix() not in ('launch.lua','core.lua'):
                continue
            target=out/('game-core.lua' if relative.as_posix()=='core.lua' else relative)
            if not target.resolve().is_relative_to(out): raise RuntimeError('对照文件超出隔离目录')
            target.parent.mkdir(parents=True,exist_ok=True)
            if target.exists():target.unlink()
            shutil.copy2(source,target)
    configuration = json.loads((ROOT / 'config.json').read_text(encoding='utf-8'))
    (out / 'config.json').write_text(json.dumps(configuration), encoding='utf-8')
    (out / 'case.json').write_text(json.dumps(vars(args), default=str), encoding='utf-8')
    width, height = (480, 640) if args.case == 'window' else (960, 720)
    (out / 'launch').write_text(
        "for _,name in ipairs({'SetBGMVolume','SetSEVolume'}) do\n"
        " local original=lstg[name];local silent=function() return original(0) end\n"
        " lstg[name]=silent;_G[name]=silent;silent()\n"
        "end\n"
        "lstg.DoFile('launch.lua')\nsetting.mod='launcher'\n"
        f"setting.resx={width};setting.resy={height};setting.windowed=true;setting.vsync=false\n"
        f"SetResolution({width},{height});SetWindowed(true);SetVsync(false)\n"
        "setting.bgmvolume=0;setting.sevolume=0\n",
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
    digest=hashlib.sha256();count=0
    for directory in ('THlib','mod'):
        for path in sorted((out/directory).rglob('*.lua')):
            digest.update(path.relative_to(out).as_posix().encode('utf-8')+b'\0'+path.read_bytes());count+=1
    result['lua_tree']={'files':count,'sha256':digest.hexdigest()}
    result['sha256'] = {name: hashlib.sha256((out / name).read_bytes()).hexdigest() for name in
        ['LuaSTGSub.exe', 'mod/GAME/th37/background.lua', 'mod/GAME/th37/source_mesh.lua',
         'mod/GAME/th39/runtime.lua', 'mod/GAME/ports/binding_index.lua',
         'mod/GAME/ports/mhj/native_players/night_system.lua',
         'mod/GAME/ports/mhj/native_players/night_barrage_view.lua','THlib/lib/Lresources.lua',
         'mod/GAME/ports/source_csharp.lua','launch.lua']}
    if args.engine_file:
        result['engine']['override_note']='版本锁来自当前工作区；覆盖引擎的补丁以该文件指纹及其构建记录为准'
    result['wall_seconds'] = time.monotonic() - started
    report.write_text(json.dumps(result, ensure_ascii=False, default=str), encoding='utf-8')
    if result.get('error'):
        raise RuntimeError(result['error'])
    print(json.dumps({k: v for k, v in result.items() if k not in ['frames', 'stacks', 'checkpoints', 'operations', 'traces', 'catalogue']}, ensure_ascii=False, default=str))


if __name__ == '__main__':
    main()
