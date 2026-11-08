"""在隔离Windows发行目录验证TH31–TH35的Boss身份，包含实际UI名字绘制。"""
from pathlib import Path
import argparse
import importlib.util
import json
import shutil

spec=importlib.util.spec_from_file_location('native_engine',Path(__file__).with_name('native_engine.py'))
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
prepare=engine.prepare


def prepare_probe(output):
    prepare(output)
    shutil.copy2(Path(__file__).with_suffix('.lua'),output/'native_boss_identity.lua')
    path=output/'native_test.lua';source=path.read_text('utf-8-sig')
    anchor='                    if host.th36_session then';assert source.count(anchor)==1
    source="local IdentityProbe=dofile('native_boss_identity.lua')\n"+source.replace(anchor,
        '                    IdentityProbe(host,frames,current)\n'+anchor)
    # 身份检查到900帧结束；紫的耐久会在保护状态下停ECL。只在观测结束后释放，允许正常结算。
    ending='if limit>0 then host.hp=0';assert source.count(ending)==1
    source=source.replace(ending,'if limit>0 then host._original_ecl_hold=nil;host.hp=0')
    path.write_text(source,encoding='utf-8')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--games',default='31,32,33,34,35');args=parser.parse_args()
    engine.prepare=prepare_probe
    args.cases,args.frames,args.speed='',900,1200
    args.seed,args.mode,args.flow=20261108,'timeout','single'
    try:
        engine.run(args)
    except SystemExit as status:
        if status.code==0:
            result=json.loads((args.output/'identity-result.json').read_text('utf-8'))
            if '34' in args.games.split(','):
                assert result['cards']['4400']['name']=='西行寺幽幽子'
                assert result['cards']['4400']['firstScript']==147
            assert all(row.get('renderedName') for row in result['cards'].values())
            assert {row['level'] for row in result['cards'].values()}=={int(game)-2 for game in args.games.split(',')}
            print(f"真实引擎Boss身份检查通过：{len(result['cards'])}张，作品{args.games}；左上角名字已实际绘制。",flush=True)
        raise
