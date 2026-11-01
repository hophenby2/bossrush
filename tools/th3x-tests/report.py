"""合并原生引擎逐卡日志；保留每次运行的代码指纹，区分运行覆盖与ECL事件对照。"""
from pathlib import Path
import argparse
import json
from collections import Counter
import hashlib

ROOT=Path(__file__).resolve().parents[2]

def fingerprints(folder):
    config=json.loads((folder/'native-run.json').read_text(encoding='utf-8'))
    ending_only=[]
    for name,expected in config['hashes'].items():
        source=ROOT/name
        current=source.read_bytes()
        if hashlib.sha256(current).hexdigest()!=expected:
            lf=current.replace(b'\r\n',b'\n')
            if source.suffix in ('.lua','.py') and expected in {
                    hashlib.sha256(lf).hexdigest(),hashlib.sha256(lf.replace(b'\n',b'\r\n')).hexdigest()}:
                ending_only.append(name)
            else:
                raise AssertionError(('验证后代码或素材改变，必须重跑受影响的批次',folder,name))
    return config,ending_only


def report(runs,output,visual_runs=()):
    cases={};sources=[]
    for folder in runs:
        path=folder/'native-result.json'
        if not path.exists():path=folder/'native-result.retry.json'
        data=json.loads(path.read_text(encoding='utf-8'))
        assert not data['errors'],(folder,data['errors'])
        assert data['completed']==data['expected']==len(data['records']),folder
        assert data.get('limit',0)==0,'冒烟截断结果不能计入整卡时限覆盖'
        config,ending_only=fingerprints(folder)
        sources.append({'path':str(folder.resolve()),'engine':data['version'],
                        'engine_sha256':hashlib.sha256((folder/'LuaSTGSub.exe').read_bytes()).hexdigest(),
                        'mode':data['mode'],'flow':data.get('flow','single'),
                        'seed':data['seed'],'completed':data['completed'],
                        'hashes':config['hashes'],'line_endings_only':ending_only})
        for row in data['records']:
            key=(row['level'],row['id'])
            case=cases.setdefault(key,{'game':row['level']+2,'id':row['id'],'name':row['name'],'runs':{}})
            kind=data['mode']+'/'+data.get('flow','single')
            case['runs'][kind]={'frames':row['frames'],'ended':row.get('ended'),
                'target':row.get('target'),
                'rendered':row.get('rendered',0),'peak':row['peak'],
                'min_rate':row.get('min_rate',1),'max_photos':row.get('max_photos',0),
                'cleanup':row.get('cleanup'),'unmapped_visuals':row.get('unmapped_visuals',{}),'run':len(sources)-1}
            if row.get('original_ecl'):case['original_ecl']=row['original_ecl']
    coverage=Counter(kind for case in cases.values() for kind in case['runs'])
    assert Counter(c['game'] for c in cases.values())=={31:133,32:106,33:85,34:115,35:74}
    assert coverage['timeout/single']==513 and coverage['defeat/single']==513
    assert coverage['defeat/grouped']==513 and coverage['photo/single']==85
    assert all(r['rendered']>0 and r['ended'] in ('timeout','defeat') for c in cases.values() for r in c['runs'].values())
    assert all(c['runs']['photo/single']['max_photos']==c['original_ecl']['photos'] for c in cases.values() if c['game']==33)
    result={'date':'2026-11-01','coverage':dict(coverage),
        'method':['完整Windows发行版、真实资源、Boss状态机、对象池、渲染及碰撞。',
                  '时限模式不主动攻击，运行到超时或原脚本自行结束/换卡；保留实际结束原因与注册时限。',
                  '无敌灵梦，正常输入切换高低速；击破模式保留实际射击并在可受伤阶段追加Damage。',
                  '命中分支模式每480逻辑帧调用实际take_damage2，覆盖拍中本体后的计数与阶段切换。',
                  'grouped在同一个Boss对象中连续换卡，single每张卡重新创建Boss。'],
        'limits':['运行通过证明该种子及输入下的执行、资源与结算可达；不等同于全量ECL逐帧数值对照。',
                  '加速运行的渲染频率与逻辑频率不同，不能据此判断正常帧率的视觉节奏或逐帧画面。',
                  '命中分支模式没有模拟相机取景操作；实际调用项目使用的有效命中入口。',
                  'TH06二进制ECL事件对照另由th32-tests/program_conformance.py覆盖100段流程。'],
        'runs':sources,'cards':sorted(cases.values(),key=lambda c:(c['game'],c['id']))}
    result['normal_rate_visual_checks']=[]
    for folder in visual_runs:
        data=json.loads((folder/'native-result.json').read_text(encoding='utf-8'))
        assert not data['errors'] and data['completed']==data['expected']
        config,ending_only=fingerprints(folder)
        assert config['frames']>0 and len(data['records'])>0
        result['normal_rate_visual_checks'].append({'path':str(folder.resolve()),
            'hashes':config['hashes'],'line_endings_only':ending_only,
            'records':[{k:v for k,v in row.items() if k in ('id','level','frames','rendered','ended')} for row in data['records']],
            'screenshots':[str(p.resolve()) for p in (folder/'snapshot').glob('*.png')]})
    output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'cards':len(cases),'coverage':dict(coverage),'output':str(output)},ensure_ascii=False))

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('runs',nargs='+',type=Path);parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--visual-runs',nargs='*',type=Path,default=[])
    args=parser.parse_args();report(args.runs,args.output,args.visual_runs)
