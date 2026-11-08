"""在独立 Windows 发行目录运行 TH31–TH36，保留逐卡进度、错误和截图。"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time
import uuid
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[2]
sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')


def prepare(output):
    output.mkdir(parents=True, exist_ok=True)
    def link_or_copy(source, target):
        # Lua可能在加载画面之后才Include；硬链接会让运行中的验证读到后续编辑。
        # 源码必须保存为本次独立副本，素材仍可共用只读硬链接。
        if Path(source).suffix == '.lua':
            if Path(target).exists() and os.path.samefile(source, target):
                Path(target).unlink()
            return shutil.copy2(source, target)
        if Path(target).exists() and os.path.samefile(source, target):
            return target
        try:
            os.link(source, target)
        except OSError:
            shutil.copy2(source, target)
    for name in ('THlib', 'mod', 'Resources', 'music', 'shader', 'BadApple'):
        target = output / name
        if target.is_junction():
            assert target.resolve() == (ROOT / name).resolve(), target
            os.rmdir(target)  # 仅移除这个目录联接，不能递归删除指向的发行目录。
        shutil.copytree(ROOT / name, target, copy_function=link_or_copy, dirs_exist_ok=True)
    # 引擎拒绝目录联接；只读素材和脚本使用硬链接，存档和录像单独创建。
    for name in ('LuaSTGSub.exe', 'd3dcompiler_47.dll', 'xaudio2_9redist.dll', 'launch.lua', 'launcher.lua', 'core.lua', 'manual', 'Update.txt'):
        shutil.copy2(ROOT / name, output / name)
    for name in ('User', 'replay', 'snapshot'):
        (output / name).mkdir(exist_ok=True)
        assert not (output / name).is_symlink()
    shutil.copy2(Path(__file__).with_suffix('.lua'), output / 'native_test.lua')
    (output / 'launch').write_text(
        "package.cpath=package.cpath..';.\\\\?.dll'\n"
        "start_game=false;args=args or {}\n"
        "lstg.DoFile('launch.lua')\n"
        "setting.mod='launcher';setting.resx=960;setting.resy=540\n"
        "setting.windowed=true;setting.vsync=false;setting.bgmvolume=0;setting.sevolume=0\n"
        "lstg.SetTitle('TH31-TH36 native verification')\n"
        "lstg.SetWindowed(true);lstg.SetResolution(960,540);lstg.SetVsync(false)\n",
        encoding='utf-8')
    core = (output / 'core.lua').read_text(encoding='utf-8-sig')
    core += "\nlocal original_init=GameInit\nfunction GameInit()\n"
    core += " local f=assert(io.open('native-boot.log','w'))\n"
    core += " local ok,err=xpcall(function() original_init();setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua');InitAllClass();InitGameSaveData();stage.next_stage=stage.stages.init;dofile('native_test.lua').install() end,debug.traceback)\n"
    core += " if not ok then f:write(err);FrameFunc=function() return true end;RenderFunc=function() end;GameExit=function() end end;f:close()\nend\n"
    (output / 'core.lua').write_text(core, encoding='utf-8')


def run(args):
    try:
        requested = {int(token) for token in args.cases.split(',')} if args.cases else set()
    except ValueError:
        raise SystemExit('--cases只接受逗号分隔的数字卡ID；作品范围用--games，不能静默漏跑无效ID。')
    output = args.output.resolve()
    if output == ROOT or output in ROOT.parents:
        raise SystemExit('验证目录不能是发行目录本身或其父目录；源码、存档和录像必须隔离。')
    # 旧进度或结果可能把早退的新进程误判成通过；每次运行必须使用独立目录。
    if any((output / name).exists() for name in ('process.json', 'native-run.json',
                                                'native-progress.json', 'native-result.json',
                                                'native-result.retry.json')):
        raise SystemExit(f'验证目录已有运行记录，请指定新的 --output：{output}')
    prepare(output)
    sources = [ROOT / name for name in ('core.lua', 'launch.lua', 'launcher.lua')]
    for name in ('THlib', 'mod', 'Resources'):
        sources.extend((ROOT / name).rglob('*.lua'))
    # 启动时固定代码指纹；硬链接目录里的文件可能在长测期间被后续修改。
    run_id = uuid.uuid4().hex
    config = dict(run_id=run_id, started_utc=datetime.now(timezone.utc).isoformat(),
                  frames=args.frames, speed=args.speed, games=args.games,
                  cases=args.cases, mode=args.mode, flow=args.flow, seed=args.seed,
                  harness_sha256=hashlib.sha256(Path(__file__).with_suffix('.lua').read_bytes()).hexdigest(),
                  hashes={p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in sorted(sources)})
    (output / 'native-run.json').write_text(json.dumps(config, ensure_ascii=False, indent=2), encoding='utf-8')
    env = dict(os.environ, TH3X_GAMES=args.games, TH3X_FRAMES=str(args.frames),
               TH3X_SPEED=str(args.speed), TH3X_MODE=args.mode,
               TH3X_SEED=str(args.seed), TH3X_CASES=args.cases, TH3X_RUN_ID=run_id,
               TH3X_FLOW=args.flow)
    # 不创建可见交互窗口；用户自己的游戏进程不会被触碰。
    startup = subprocess.STARTUPINFO()
    startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
    startup.wShowWindow = 0
    process = subprocess.Popen([str(output / 'LuaSTGSub.exe')], cwd=output, env=env,
                               startupinfo=startup)
    (output / 'process.json').write_text(json.dumps({'pid': process.pid, 'root': str(output), 'run_id': run_id}))
    print(f'已启动独立引擎 PID={process.pid}，日志：{output}', flush=True)
    last_text = ''
    while process.poll() is None:
        time.sleep(2)
        progress = output / 'native-progress.json'
        if progress.exists():
            try:
                data = json.loads(progress.read_text(encoding='utf-8'))
            except (ValueError, OSError):
                continue
            if data.get('run_id') != run_id:
                continue
            text = f"{len(data['records'])}/{data['expected']} 当前 {data.get('current')} 错误 {len(data['errors'])}"
            if text != last_text:
                print(text, flush=True)
                last_text = text
    result = output / 'native-result.json'
    if not result.exists() and (output / 'native-result.retry.json').exists():
        result = output / 'native-result.retry.json'
    if not result.exists():
        print((output / 'native-boot.log').read_text(encoding='utf-8'), flush=True)
        raise SystemExit('引擎没有生成结果；请检查 engine.log 与 native-boot.log')
    data = json.loads(result.read_text(encoding='utf-8'))
    if data.get('run_id') != run_id:
        raise SystemExit('结果运行编号与启动记录不一致，不能判为通过')
    if process.returncode != 0:
        raise SystemExit(f'引擎异常退出：{process.returncode}；不能仅凭结果文件判为通过')
    if requested and {row['id'] for row in data['records']} != requested:
        raise SystemExit('实际完成的卡片集合与--cases不同，不能把漏跑判为通过')
    print(json.dumps({k: data[k] for k in ('expected', 'completed', 'errors')}, ensure_ascii=False), flush=True)
    raise SystemExit(1 if data['errors'] or data['completed'] != data['expected'] else 0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--games', default='31,32,33,34,35')
    parser.add_argument('--cases', default='', help='按卡ID筛选，逗号分隔')
    parser.add_argument('--frames', type=int, default=0, help='0跑完整时限；其他值只用于冒烟排错')
    parser.add_argument('--speed', type=int, default=60, help='一次显示帧执行的真实逻辑帧数')
    parser.add_argument('--mode', choices=['timeout', 'defeat', 'cancel', 'photo'], default='timeout')
    parser.add_argument('--flow', choices=['single', 'grouped'], default='single', help='每张卡重建Boss，或同一Boss连续换卡')
    parser.add_argument('--seed', type=int, default=20261031)
    run(parser.parse_args())
