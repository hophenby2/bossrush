"""验收冻结源码的Windows真引擎记录；检查逐卡集合、完整流程的符卡覆盖与回收。"""
from pathlib import Path
import argparse
import hashlib
import json
import sys
from source import ROOT,load
from catalogue import catalogue


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('directories',type=Path,nargs='+')
    ap.add_argument('--source',type=Path,required=True)
    ap.add_argument('--output',type=Path)
    args=ap.parse_args();sources=load(args.source);metadata=catalogue(sources);summaries=[]
    by_id={r['id']:r for r in metadata}
    for directory in args.directories:
        config=json.loads((directory/'native-run.json').read_text('utf-8'))
        data=json.loads((directory/'native-result.json').read_text('utf-8'))
        assert config['run_id']==data['run_id'] and data['limit']==0
        assert not data['errors'] and data['completed']==data['expected']
        expected={r['id'] for r in metadata} if data['mode']=='timeout' else set(range(11101,11108))
        assert {r['id'] for r in data['records']}==expected,('遗漏入口',directory)
        checked=0;hashes={}
        for path,digest in config['hashes'].items():
            if path=='mod/GAME/th36.lua' or path.startswith('mod/GAME/th36/') or path.startswith('mod/GAME/original/11/') or path=='THlib/anm/original.lua':
                current=(ROOT/path).read_bytes();current_hash=hashlib.sha256(current).hexdigest()
                assert current_hash==digest,('验收源码已变动，必须重跑真引擎',path)
                checked+=1
                hashes[path]=digest
        for row in data['records']:
            assert row['rendered']>0 and row['frames']>0
            assert all(row['cleanup'][key]==0 for key in ('bullets','lasers','actors')),('残留敌机/弹/激光',row['id'])
            if data['mode']=='timeout':
                spell=by_id[row['id']]['spell'];wanted={spell} if spell is not None else set()
                assert {e[1] for e in row.get('th36_spells',[])}==wanted,('练习入口卡ID不符',row['id'])
            if data['mode']=='defeat':
                stage=row['id']-11100
                wanted={r['spell'] for r in metadata if r['stage']==stage and r['spell'] is not None and r['shot']==0}
                observed={event[1] for event in row.get('th36_spells',[])}
                assert wanted==observed,('整关漏卡',stage,wanted,observed)
                if stage==7:
                    assert row['min_rate']<=.5,('最终零血死亡演出被跳过',row['min_rate'])
                    assert {e[1] for e in row.get('th36_rates',[])}>={.5,.25,1},'死亡缓时序列没有执行完'
                    assert row.get('th36_rate_frames',{}).get('0.25',0)>1,'全场缓时没有持续生效'
        summaries.append(dict(run_id=data['run_id'],directory=str(directory),mode=data['mode'],version=data['version'],
            expected=data['expected'],completed=data['completed'],errors=data['errors'],frozen_lua_files=checked,
            frozen_lua_hashes=hashes,
            frames=sum(r['frames'] for r in data['records']),
            rows=[dict(**{k:r[k] for k in ('id','frames','ended','peak','cleanup')},
                       spell_ids=[e[1] for e in r.get('th36_spells',[])],min_rate=r['min_rate'],
                       time_scale_events=r.get('th36_rates',[]),time_scale_frames=r.get('th36_rate_frames',{})) for r in data['records']]))
    result=dict(scope='真实LuaSTG Sub生命周期、完整时限、整关默认回忆路线、渲染调用与回收；不等同原版逐帧位置/像素对照',
                source_ecl_sha256={name:s.sha256 for name,s in sources.items()},runs=summaries)
    if args.output:args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8',newline='\n')
    print(json.dumps([{k:v for k,v in r.items() if k not in ('rows','frozen_lua_hashes')} for r in summaries],ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
