"""用Windows真实引擎验证时符筛选、星形生命/Bomb、属性条、阶段数字和无答题结算。"""
from pathlib import Path
import argparse
import importlib.util
import json
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
    anchor = '                if started and #records==#entries then'
    assert source.count(anchor) == 1
    source = source.replace(anchor, anchor + "\n                    if settle==0 then lstg.var.dead=10 end")
    anchor = '                    if settle>=120 then complete=true;save(true);break end'
    assert source.count(anchor) == 1
    source = source.replace(anchor, anchor + '\n                    if settle==1 or settle==90 then break end')
    anchor = '                -- 大批推进只改变验证的墙钟时间'
    assert source.count(anchor)==1
    source=source.replace(anchor,'                if HUDNeedRender() then break end\n'+anchor)
    path.write_text(source, encoding='utf-8')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    engine.prepare = prepare_hud
    args.games, args.cases = '31,32,34,35', '3433,3912,4444,3601,3621'
    args.frames, args.speed, args.seed = 960, 960, 20261108
    args.mode, args.flow = 'timeout', 'single'
    try:
        engine.run(args)
    except SystemExit as status:
        if status.code == 0:
            report=json.loads((args.output / 'hud-death-result.json').read_text(encoding='utf-8'))
            assert report['revive']==0 and report['dead']==10 and report['current']==5 and report['rank']==0 and report['finished'] and not report['quiz'],report
            for name in ('hp-menu-collapsed.png','hp-menu-expanded.png','hp-stage-01-age-01.png','hp-stage-01-settled.png','hud-result.png','hp-colors.png'):
                assert (args.output / 'snapshot' / name).is_file(),name
            growth=json.loads((args.output/'growth-ui.json').read_text(encoding='utf-8'))
            assert len(growth)==5 and all('e' not in row['multiplier'].lower() for row in growth)
            assert growth[1]['power']>1000 and len(growth[1]['lines'])>1
            assert growth[-1]['dual']
            for row in growth:
                assert (args.output/'snapshot'/(row['snapshot']+'.png')).is_file()
            print('阶段HP、首次入场动画、折叠菜单、配色和无Rank结算检查通过。',flush=True)
        raise
