"""Windows真实引擎复现三面中Boss重复倍率、五面二非重设生命漏校准。"""
from pathlib import Path
import argparse
import importlib.util
import json
import os
import shutil

spec=importlib.util.spec_from_file_location('native_engine',Path(__file__).with_name('native_engine.py'))
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare


def instrument(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'),output/'native_th31_hp.lua')
    file=output/'native_test.lua';source=file.read_text('utf-8-sig')
    init="                        init(b);entry.phase='combat';save(false)"
    probe='                    if host.th36_session then'
    assert source.count(init)==source.count(probe)==1
    source=source.replace(init,"                        TH31HPConfigure(b,card)\n"+init)
    source=source.replace(probe,'                    TH31HPProbe(host,frames,current)\n'+probe)
    file.write_text("dofile('native_th31_hp.lua')\n"+source,encoding='utf-8')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--stage',type=int,default=19)
    parser.add_argument('--expect-broken',action='store_true')
    args=parser.parse_args();os.environ['TH31_HP_STAGE']=str(args.stage)
    engine.prepare=instrument
    args.games,args.cases,args.frames,args.speed='31','3436,3433,3434',900,1200
    args.mode,args.flow,args.seed='timeout','single',20261108
    try:engine.run(args)
    except SystemExit as status:
        if status.code:raise
    data=json.loads((args.output/'th31-hp.json').read_text('utf-8'))
    assert set(data['cards'])=={'3436','3433','3434'}
    broken={key:rows[0]['ratio'] for key,rows in data['cards'].items() if not all(row['correct'] for row in rows)}
    if args.expect_broken:
        assert set(broken)=={'3436','3434'},broken
        print('已复现错误血量倍率：',broken)
    else:
        assert not broken,broken
        assert all(len(rows)==4 for rows in data['cards'].values())
        print(f'三面/五面中Boss血量与真实受击检查通过，阶段{args.stage}，倍率{data["factor"]}。')
