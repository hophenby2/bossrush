"""在隔离的Windows发行目录验证原作结界效果的调度、绘制和清场。"""
from pathlib import Path
import argparse
import importlib.util
import json
import shutil

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('native_engine',Path(__file__).with_name('native_engine.py'))
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare


def prepare_probe(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'),output/'native_warp_barrier.lua')
    path=output/'native_test.lua';source=path.read_text(encoding='utf-8-sig')
    anchor='                    if host.th36_session then'
    assert source.count(anchor)==1
    source="local WarpProbe=dofile('native_warp_barrier.lua')\n"+source.replace(anchor,
        '                    WarpProbe(host,frames,current)\n'+anchor)
    path.write_text(source,encoding='utf-8')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    engine.prepare=prepare_probe
    args.games,args.cases,args.frames,args.speed='31','434,441',1800,900
    args.seed,args.mode,args.flow=20261108,'timeout','single'
    try:
        engine.run(args)
    except SystemExit as status:
        if status.code==0:
            data=json.loads((args.output/'warp-result.json').read_text(encoding='utf-8'))
            assert data['draws']>0 and data['background']>0 and data['cleaned'],data
            for id,expected in [('434',(224,112)),('441',(316.78384,192))]:
                row=data['cards'][id]
                assert 89<=row['first']<=92,row
                for frame in ['frame300','frame900']:
                    assert abs(row[frame]['outer']-expected[0])<1e-4,row
                    assert abs(row[frame]['inner']-expected[1])<1e-4,row
            print('真实引擎两层方框、原作半径、背景反转和换卡清场检查通过。',flush=True)
        raise
