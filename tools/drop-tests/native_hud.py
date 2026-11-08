"""用Windows真实引擎验证三色文字、状态栏和九枚Bomb的角度填充。"""
from pathlib import Path
import argparse
import importlib.util
import shutil

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('native_engine', ROOT / 'tools/th3x-tests/native_engine.py')
engine = importlib.util.module_from_spec(spec)
spec.loader.exec_module(engine)
prepare = engine.prepare


def prepare_hud(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'), output / 'native_hud.lua')
    shutil.copy2(ROOT / 'android/lua/input.lua', output / 'native_android_input.lua')
    path = output / 'native_test.lua'
    source = path.read_text(encoding='utf-8-sig')
    anchor = '                    if host.th36_session then'
    assert source.count(anchor) == 1
    source = "local HUDProbe=dofile('native_hud.lua')\n" + source.replace(
        anchor, '                    HUDProbe(host,frames,current)\n' + anchor)
    path.write_text(source, encoding='utf-8')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    engine.prepare = prepare_hud
    args.games, args.cases = '35', '3601,3602,3603,3604'
    args.frames, args.speed, args.seed = 960, 960, 20261108
    args.mode, args.flow = 'timeout', 'single'
    engine.run(args)
