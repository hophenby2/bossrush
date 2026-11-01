"""在独立 Windows 发行目录运行 TH31–TH35，保留逐卡进度、错误和截图。"""
from pathlib import Path
import argparse
import json
import os
import shutil
import subprocess
import sys
import time
import hashlib

ROOT = Path(__file__).resolve().parents[2]
sys.stdout.reconfigure(encoding='utf-8')


def prepare(output):
    output.mkdir(parents=True, exist_ok=True)
    def link_or_copy(source, target):
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
        "lstg.SetTitle('TH31-TH35 native verification')\n"
        "lstg.SetWindowed(true);lstg.SetResolution(960,540);lstg.SetVsync(false)\n",
        encoding='utf-8')
    core = (output / 'core.lua').read_text(encoding='utf-8-sig')
    core += "\nlocal original_init=GameInit\nfunction GameInit()\n"
    core += " local f=assert(io.open('native-boot.log','w'))\n"
    core += " local ok,err=xpcall(function() original_init();setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua');InitAllClass();InitScoreData();stage.next_stage=stage.stages.init;dofile('native_test.lua').install() end,debug.traceback)\n"
    core += " if not ok then f:write(err);FrameFunc=function() return true end;RenderFunc=function() end;GameExit=function() end end;f:close()\nend\n"
    (output / 'core.lua').write_text(core, encoding='utf-8')


def run(args):
    output = args.output.resolve()
    assert output!=ROOT and not output.is_relative_to(ROOT), '测试目录必须位于发行目录之外'
    prepare(output)
    for name in ('native-result.json','native-result.retry.json','native-progress.json'):
        path=output/name
        if path.exists(): path.unlink()
    sources=list((ROOT/'mod/GAME').glob('th3[12345]*.lua'))
    for folder in ('THlib/bullet','THlib/laser','THlib/enemy','THlib/lib','THlib/anm','mod/GAME/original'):
        sources.extend((ROOT/folder).glob('*.lua'))
    sources.extend((ROOT/'mod/GAME/original').glob('*/*.lua'))
    sources.extend((ROOT/'Resources/Original').glob('*/*.png'))
    sources.extend((ROOT/'THlib/WalkImageSystem.lua',ROOT/'tools/th3x-tests/native_engine.lua',ROOT/'mod/GAME/original/manifest.json'))
    (output/'native-run.json').write_text(json.dumps({
        'seed':args.seed,'mode':args.mode,'flow':args.flow,'frames':args.frames,'games':args.games,
        'hashes':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    },ensure_ascii=False,indent=2),encoding='utf-8')
    env = dict(os.environ, TH3X_GAMES=args.games, TH3X_FRAMES=str(args.frames),
               TH3X_SPEED=str(args.speed), TH3X_MODE=args.mode,
               TH3X_SEED=str(args.seed), TH3X_CASES=args.cases,TH3X_FLOW=args.flow)
    # 不创建可见交互窗口；用户自己的游戏进程不会被触碰。
    startup = subprocess.STARTUPINFO()
    startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
    startup.wShowWindow = 0
    process = subprocess.Popen([str(output / 'LuaSTGSub.exe')], cwd=output, env=env,
                               startupinfo=startup)
    (output / 'process.json').write_text(json.dumps({'pid': process.pid, 'root': str(output)}))
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
            text = f"{len(data['records'])}/{data['expected']} 当前 {data.get('current')} 错误 {len(data['errors'])}"
            if text != last_text:
                print(text, flush=True)
                last_text = text
    result = output / 'native-result.json'
    if not result.exists(): result=output/'native-result.retry.json'
    if not result.exists():
        print((output / 'native-boot.log').read_text(encoding='utf-8'), flush=True)
        raise SystemExit('引擎没有生成结果；请检查 engine.log 与 native-boot.log')
    data = json.loads(result.read_text(encoding='utf-8'))
    print(json.dumps({k: data[k] for k in ('expected', 'completed', 'errors')}, ensure_ascii=False), flush=True)
    raise SystemExit(1 if data['errors'] or data['completed'] != data['expected'] else 0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--games', default='31,32,33,34,35')
    parser.add_argument('--cases', default='', help='按卡ID筛选，逗号分隔')
    parser.add_argument('--frames', type=int, default=0, help='0跑完整时限；其他值只用于冒烟排错')
    parser.add_argument('--speed', type=int, default=60, help='一次显示帧执行的真实逻辑帧数')
    parser.add_argument('--mode', choices=['timeout', 'defeat', 'photo'], default='timeout')
    parser.add_argument('--flow',choices=['single','grouped'],default='single',help='grouped在同一个Boss对象上依次换卡')
    parser.add_argument('--seed', type=int, default=20261031)
    run(parser.parse_args())
