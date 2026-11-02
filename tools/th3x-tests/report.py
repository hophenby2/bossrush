"""合并原生引擎逐卡日志；保留每次运行的代码指纹，区分运行覆盖与ECL事件对照。"""
from pathlib import Path
import argparse
import json
from collections import Counter
import hashlib
import re
from datetime import date

ROOT=Path(__file__).resolve().parents[2]
GAME_FILES={g:{f'mod/GAME/th{g}.lua'} for g in range(31,36)}
GAME_FILES[31].add('mod/GAME/th31_keine.lua')
GAME_FILES[34].update(('mod/GAME/th34_prism_nonspells.lua','mod/GAME/th34_prism.lua','mod/GAME/th34_visual.lua'))
GAME_FILES[31].add('mod/GAME/th31_combat.lua')

def changed_balance_games(before,after):
    """只有生成表的单作数据可局部替代；换算公式、系数或公共代码变化必须全量重跑。"""
    pattern=re.compile(rb'^H\.entries\[(7|8|10)\]=\{\n.*?^\}',re.M|re.S)
    before=before.replace(b'\r\n',b'\n');after=after.replace(b'\r\n',b'\n')
    old={int(m[1]):m[0] for m in pattern.finditer(before)}
    new={int(m[1]):m[0] for m in pattern.finditer(after)}
    if set(old)!={7,8,10} or set(new)!=set(old):return None
    if pattern.sub(b'<entries>',before)!=pattern.sub(b'<entries>',after):return None
    return {{7:34,8:31,10:35}[game] for game in old if old[game]!=new[game]}

def fingerprints(folder,supersede_games=()):
    config=json.loads((folder/'native-run.json').read_text(encoding='utf-8'))
    ending_only=[];changed_games=set()
    current_names={name for name in ('core.lua','launch.lua','launcher.lua')}
    for directory in ('THlib','mod','Resources'):
        current_names.update(p.relative_to(ROOT).as_posix() for p in (ROOT/directory).rglob('*.lua'))
    # 新增文件也要核对；否则旧快照中根本没有的新模块会逃过哈希检查。
    for name in current_names.symmetric_difference(config['hashes']):
        matches=[g for g in supersede_games if name in GAME_FILES[g]]
        assert matches, ('验证后新增或删除源码，必须重跑受影响批次',folder,name)
        changed_games.update(matches)
    for name,expected in config['hashes'].items():
        source=ROOT/name
        if not source.exists():continue  # 上面的文件集合比较已拒绝未声明的删除。
        current=source.read_bytes()
        if hashlib.sha256(current).hexdigest()!=expected:
            lf=current.replace(b'\r\n',b'\n')
            if source.suffix in ('.lua','.py') and expected in {
                    hashlib.sha256(lf).hexdigest(),hashlib.sha256(lf.replace(b'\n',b'\r\n')).hexdigest()}:
                ending_only.append(name)
            else:
                # 显式重跑整作时才可排除旧记录；框架、共享模块、素材改变仍拒绝所有旧结果。
                matches=[g for g in supersede_games if name in GAME_FILES[g]]
                if name=='mod/GAME/original/low_speed_hp.lua':
                    snapshot=(folder/name).read_bytes()
                    assert hashlib.sha256(snapshot).hexdigest()==expected, ('验证副本已改变',folder,name)
                    changed=changed_balance_games(snapshot,current)
                    if changed and changed.issubset(set(supersede_games)):
                        matches=changed
                if not matches:
                    raise AssertionError(('验证后代码或素材改变，必须重跑受影响的批次',folder,name))
                changed_games.update(matches)
    return config,ending_only,changed_games


def report(runs,output,visual_runs=(),supersede_games=()):
    cases={};sources=[]
    for folder in runs:
        path=folder/'native-result.json'
        if not path.exists():path=folder/'native-result.retry.json'
        data=json.loads(path.read_text(encoding='utf-8'))
        assert not data['errors'],(folder,data['errors'])
        assert data['completed']==data['expected']==len(data['records']),folder
        assert data.get('limit',0)==0,'冒烟截断结果不能计入整卡时限覆盖'
        config,ending_only,changed_games=fingerprints(folder,supersede_games)
        assert data.get('run_id')==config['run_id'], ('结果与启动编号不一致',folder)
        sources.append({'path':str(folder.resolve()),'engine':data['version'],
                        'engine_sha256':hashlib.sha256((folder/'LuaSTGSub.exe').read_bytes()).hexdigest(),
                        'mode':data['mode'],'flow':data.get('flow','single'),
                        'seed':data['seed'],'completed':data['completed'],
                        'hashes':config['hashes'],'line_endings_only':ending_only,
                        'excluded_changed_games':sorted(changed_games)})
        for row in data['records']:
            if row['level']+2 in changed_games:
                continue
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
    from card_catalogue import catalogue
    expected={(c['game'],c['id']) for c in catalogue()}
    assert {(c['game'],c['id']) for c in cases.values()}==expected, '运行结果与当前实际注册集合不一致'
    for kind in ('timeout/single','defeat/single','defeat/grouped'):
        assert coverage[kind]==len(expected),(kind,coverage[kind],len(expected))
    assert coverage['photo/single']==sum(g==33 for g,_ in expected)
    assert all(r['rendered']>0 and r['ended'] in ('timeout','defeat') for c in cases.values() for r in c['runs'].values())
    assert all(c['runs']['photo/single']['max_photos']==c['original_ecl']['photos'] for c in cases.values() if c['game']==33)
    result={'date':str(date.today()),'coverage':dict(coverage),
        'full_original_frame_equivalence':False,
        'method':['完整Windows发行版、真实资源、Boss状态机、对象池、渲染及碰撞。',
                  '时限模式不主动攻击，运行到超时或原脚本自行结束/换卡；保留实际结束原因与注册时限。',
                  '无敌灵梦，正常输入切换高低速；击破模式保留实际射击并在可受伤阶段追加Damage。',
                  '命中分支模式每480逻辑帧调用实际take_damage2，覆盖拍中本体后的计数与阶段切换。',
                  'grouped在同一个Boss对象中连续换卡，single每张卡重新创建Boss。'],
        'limits':['运行通过证明该种子及输入下的执行、资源与结算可达；不等同于全量ECL逐帧数值对照。',
                  '加速运行的渲染频率与逻辑频率不同，不能据此判断正常帧率的视觉节奏或逐帧画面。',
                  '命中分支模式没有模拟相机取景操作；实际调用项目使用的有效命中入口。',
                  'cleanup为换卡边界的全对象计数，可能包含下一卡已创建对象，不能据此证明零残留。',
                  'TH06二进制ECL事件对照另由th32-tests/program_conformance.py覆盖100段流程。'],
        'runs':sources,'cards':sorted(cases.values(),key=lambda c:(c['game'],c['id']))}
    result['normal_rate_visual_checks']=[]
    for folder in visual_runs:
        data=json.loads((folder/'native-result.json').read_text(encoding='utf-8'))
        assert not data['errors'] and data['completed']==data['expected']
        config,ending_only,changed_games=fingerprints(folder,supersede_games)
        assert not changed_games.intersection(row['level']+2 for row in data['records']), '常速截图所测作品已有改动，必须重跑'
        assert config['frames']>0 and len(data['records'])>0
        result['normal_rate_visual_checks'].append({'path':str(folder.resolve()),
            'hashes':config['hashes'],'line_endings_only':ending_only,'other_changed_games':sorted(changed_games),
            'records':[{k:v for k,v in row.items() if k in ('id','level','frames','rendered','ended')} for row in data['records']],
            'screenshots':[str(p.resolve()) for p in (folder/'snapshot').glob('*.png')]})
    output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'cards':len(cases),'coverage':dict(coverage),'output':str(output)},ensure_ascii=False))

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('runs',nargs='+',type=Path);parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--visual-runs',nargs='*',type=Path,default=[])
    parser.add_argument('--supersede-games',nargs='*',type=int,choices=range(31,36),default=[],
        help='仅用于已审阅的单作脚本或生成血量表改动；丢弃该作旧记录并要求补齐所有模式。公共逻辑/系数改变仍须全量重跑。')
    args=parser.parse_args();report(args.runs,args.output,args.visual_runs,args.supersede_games)
