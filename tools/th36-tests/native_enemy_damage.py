"""隔离Windows引擎，复现/回归TH36道中敌机实际自机弹碰撞；不访问玩家存档。"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import sys

ROOT=Path(__file__).resolve().parents[2]


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--cases',default='11201,11202,11203,11204,11205,11206,11207,11018')
    ap.add_argument('--frames',type=int,default=0)
    ap.add_argument('--expect-broken',action='store_true')
    ap.add_argument('--report',type=Path,default=ROOT/'tools/th36-tests/verification-enemy-damage-2026-11-08.json')
    args=ap.parse_args()
    spec=importlib.util.spec_from_file_location('native_engine',ROOT/'tools/th3x-tests/native_engine.py')
    engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
    prepare=engine.prepare
    probe=Path(__file__).with_suffix('.lua').read_text('utf-8')
    def instrument(output):
        prepare(output)
        target=output/'native_test.lua'
        source=target.read_text('utf-8')
        anchor='                    if host.th36_session then'
        assert source.count(anchor)==1
        source=source.replace(anchor,'                    NativeEnemyDamageProbe(host,frames,current)\n'+anchor)
        target.write_text(probe+'\n'+source,'utf-8',newline='\n')
    engine.prepare=instrument
    config=argparse.Namespace(output=args.output,cases=args.cases,frames=args.frames,speed=6000,
                              games='36',mode='timeout',flow='single',seed=20261031)
    try:engine.run(config)
    except SystemExit as result:
        if result.code:raise
    data=json.loads((args.output/'native-enemy-damage.json').read_text('utf-8'))
    rows=data['rows'];assert rows,'没有遇到可受弹敌机'
    run=json.loads((args.output/'native-run.json').read_text('utf-8'))
    native=json.loads((args.output/'native-result.json').read_text('utf-8'))
    broken=[r for r in rows if not r['hit'] or not r['consumed']]
    result=dict(probed=len(rows),hits=sum(r['hit'] for r in rows),broken=len(broken),rows=rows,
                probe_sha256=hashlib.sha256(probe.encode('utf-8')).hexdigest(),
                run_id=run['run_id'],cases=[r['id'] for r in native['records']],
                source_sha256={p:h for p,h in run['hashes'].items() if p.startswith('mod/GAME/th36/')},
                scope='真实LuaSTG Sub：测试自机弹→碰撞检查→enemybase.colli→实际扣血；非直接Damage或仅检查标志')
    (args.output/'enemy-damage-result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(json.dumps({k:v for k,v in result.items() if k!='rows'},ensure_ascii=False))
    if args.expect_broken:assert broken,'预期复现失败，但实际全部命中'
    else:
        assert not broken,broken
        for card in result['cases']:
            if 11201<=card<=11207:assert any(r['stage']==card-11200 for r in rows)
            if card==11018:assert any(r.get('ring') for r in rows),'怪轮受击节点未覆盖'
        args.report.write_text(
            json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
