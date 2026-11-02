"""逐入口读取原作参数核对卡表；不会把参数相符冒充整卡行为相符。"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import struct
import sys

from card_catalogue import catalogue, runtime, ROOT
from card_sources import attach
from ecl_source import Source
from entry_windows import prefix, factor, prefix08, factor08, prefix10, factor10

# 同一阶段的隐形共享血槽与可见Boss不是同一个对象。
CONTROLLERS = {4440:44,4441:46,4442:44,4443:48,4444:44,4445:48,
               4446:48,4447:49,4448:51,4475:48,4476:49,5480:45,5481:45,5482:45,5483:47,5484:47,5485:47}
# 这两段在超时之前主动CALL下一张卡；不是99999/5940帧耐久。
TRANSITIONS = {(31,467):(52,52),(34,4434):(41,48)}


def check(args):
    rows = catalogue()
    lua=runtime()
    actual_factor=lua.execute("local H=dofile('mod/GAME/original/low_speed_hp.lua');return H.factor")
    attach(rows,args.cache,args.binaries)
    sources,records,failures={},[],[]
    count=0

    def get(g,f):
        key=g,f
        if key not in sources:
            directory=args.cache.parent/'source-assets/th095' if g==95 else args.cache/'ecl'/str(g)
            sources[key]=Source(directory/(f+'.decl'),args.binaries/('th095' if g==95 else f'th{g:02}')/(f+'.ecl'),g)
        return sources[key]

    for card in rows:
        game,id=card['game'],card['id']
        src=card['source']
        row={'game':game,'id':id,'name':card['name'],'checks':[],
             'status':'行为未逐帧核对','pending':['运动与发弹逐帧轨迹','生成对象及激光状态机','ANM与碰撞/回收逐帧状态']}
        records.append(row)
        if src['kind']!='子程序':
            row['pending'].insert(0,'时间轴裁剪及派生对象' if src['kind']=='时间轴' else '仓库自制条目，无原作ECL')
            continue
        g,f=src['game'],Path(src['file']).stem
        original=get(g,f)
        row['source']={'file':src['file'],'sha256':original.sha256,'roots':src['roots']}
        body=[i for sub in src['roots'] for i in original.subs[sub] if i.mask&8]
        entry_events=None
        if game==34 and id not in CONTROLLERS and card['metadata'].get('balance'):
            info=card['metadata']['th07_motion_source']
            try:
                entry_events=prefix(original,info['sub'],info.get('difficulty',3))
            except (AssertionError,NotImplementedError) as error:
                row['pending'].append('入口受击轨迹：'+str(error))
        elif game==31 and id not in (422,3433,470) and card['metadata'].get('balance'):
            try:
                entry_events=prefix08(original,src['roots'][0])
            except (AssertionError,NotImplementedError) as error:
                row['pending'].append('入口受击轨迹：'+str(error))

        def verify(label,actual,expected,evidence):
            nonlocal count
            record={'field':label,'actual':actual,'expected':expected,'evidence':evidence,'pass':actual==expected}
            row['checks'].append(record);count+=1
            if not record['pass']:failures.append((game,id,record))

        def evidence(ins,sub=None):
            # 计时指令的整数参数也核验原始字节，防止陈旧decl只碰巧保持了相同地址/时间。
            if ins.op in ({7:114,8:134,95:114,10:334}.get(g),141):
                offset=16 if g==10 else 12
                expected=ins.args[:3] if g==10 else ins.args[:1]
                actual=list(struct.unpack_from('<'+'i'*len(expected),original.binary.read_bytes(),ins.address+offset))
                assert actual==expected,(f,hex(ins.address),actual,expected)
            return {'sub':sub,'address':hex(ins.address),'op':ins.op,'time':ins.time,'args':ins.args}

        if (game,id) in TRANSITIONS:
            op,target=TRANSITIONS[game,id]
            ins=next(i for i in body if i.op==op and i.args[0]==target)
            verify('阶段结束帧',card['t3'],ins.time,evidence(ins))
        elif game==31 and id==422:
            # Sub16是生成助手；时间轴第21帧通过槽1切入Sub17。
            rows17=original.subs['Sub17']
            ins=next(i for i in rows17 if i.op==134)
            verify('发弹阶段时限',card['t3'],ins.args[0],evidence(ins,'Sub17'))
            row['pending'].append('Sub16→17的21帧入场与计时关系')
        elif game==34 and id in CONTROLLERS:
            sub='Sub'+str(CONTROLLERS[id]);controller=original.subs[sub]
            ins=next(i for i in controller if i.op==114)
            verify('共享控制器时限',card['t3'],ins.args[0],evidence(ins,sub))
        elif entry_events and any(e['op']==(114 if g==7 else 134) for e in entry_events):
            timer=next(e for e in reversed(entry_events) if e['op']==(114 if g==7 else 134))
            verify('含计时重置前入场的总时限',card['t3'],timer['frame']+timer['value'],timer)
        elif g in (7,8):
            timers=[i for i in body if i.op==(114 if g==7 else 134) and i.args[0]>=0]
            if len({i.args[0] for i in timers})==1:
                ins=timers[0];verify('入口时限',card['t3'],ins.args[0],evidence(ins))
            else:row['pending'].append('多分支或继承时限')
        elif g==95:
            ins=next(i for i in body if i.op==114)
            verify('拍照阶段结束帧',card['t3'],ins.time+ins.args[0],evidence(ins))
            photos=next(i for i in body if i.op==141)
            verify('所需照片数',card['metadata']['original_ecl']['photos'],photos.args[0],evidence(photos))
            verify('原作文件指纹',card['metadata']['original_ecl']['sha256'],original.sha256,{'file':f})
        elif g==10:
            timers=[i for i in body if i.op==334 and i.args[2]>0]
            if len({i.args[2] for i in timers})==1:
                ins=timers[0];verify('中断时限',card['t3'],ins.args[2],evidence(ins))
            else:row['pending'].append('多分支或继承时限')
        else:row['pending'].append('TH06另见原始字节参照器program_conformance.py')

        if entry_events:
            profile=lua.table_from(card['metadata']['balance'],recursive=True)
            reference=factor if g==7 else factor08
            def transitions(values):
                return [[t,v] for t,v in enumerate(values) if t==0 or v!=values[t-1]]
            verify('入口前600帧受击窗口', transitions([actual_factor(profile,t) for t in range(600)]),
                   transitions([reference(entry_events,t) for t in range(600)]),
                   {'frames':600,'events':entry_events})

        # 未翻译过的日文卡名用于发现误指向另一张卡；中文译名不拿字面相等作判断。
        if g==8 and (re.search('[ぁ-ヿ]',card['name']) or id==462):
            names=[i for i in body if i.op==122]
            if names:
                normalized=lambda s:re.sub(r'\s+','',s.strip('"'))
                verify('入口卡名',normalized(card['name']) in [normalized(i.args[3]) for i in names],True,
                       {'addresses':[hex(i.address) for i in names]})

        if game==31 and id in (383,392,393,394,395,396):
            off=[i for i in body if i.op==80 and i.args[0]&1]
            assert len(off)==1
            # 闭包中也没有恢复受击；Sub149的前90帧由DAMAGEABLE=0覆盖。
            assert not any(i.op==81 and i.args[0]&1 for sub in src['closure'] for i in original.subs[sub])
            if off[0].time:
                assert any(i.op==80 and i.time==0 and i.args[0]&4 for i in body)
            verify('原作持续关闭受击的耐久属性',card['t1']==card['t2']==card['t3'],True,evidence(off[0]))

        balance=card['metadata'].get('balance')
        if g==10 and balance:
            guards=[i for i in body if i.op==335]
            if len(guards)==1 and guards[0].time==0 and isinstance(guards[0].args[0],int):
                verify('入口全免帧数',balance['immune'],guards[0].args[0],evidence(guards[0]))
            elif id in (3600,3608,3610,3611,3641):
                root=src['roots'][0]
                events=prefix10(original,root)
                assert events==prefix10(original,root,visual_branch=1), (id,'演出分支改变了保护时间')
                profile=lua.table_from(balance,recursive=True)
                transitions=lambda values:[[t,v] for t,v in enumerate(values) if t==0 or v!=values[t-1]]
                verify('TH10前600帧受击窗口',transitions([actual_factor(profile,t) for t in range(600)]),
                       transitions([factor10(events,t) for t in range(600)]), {'frames':600,'events':events})
            elif id in (3643,3645,3660,3663):
                constructor=original.subs['Boss']
                call=next(i for i in constructor if i.op==11 and i.args[0].strip('"')==src['roots'][0])
                inherited=[i for i in constructor if i.op==335 and i.address<call.address]
                assert len(inherited)==1 and not guards
                guard=inherited[0]
                assert not any(i.op in (12,13,14,83) for i in constructor if i.address<call.address)
                verify('构造后第一非符剩余无敌',balance['immune'],max(0,guard.time+guard.args[0]-call.time),
                       {'constructor':evidence(guard,'Boss'),'call':evidence(call,'Boss'),
                        'note':'移植入口从Boss1开始；构造时的60帧已在CALL前用完，不能重置保护。'})
            elif id==3642:
                assert not guards
                constructor=Path('E:/workspace/th10/src/Enemy.cpp').read_text('utf-8')
                assert 'enemy->runtime.damageReductionTimer.current = 2;' in constructor
                verify('原作新敌机默认出生保护',balance['immune'],2,
                       {'file':'th10/src/Enemy.cpp','statement':'enemy->runtime.damageReductionTimer.current = 2;',
                        'note':'stage01:MBoss从新敌机入口开始，子程序未执行335覆盖默认值。'})
            else:
                row['pending'].append('TH10多次写入、同步等待或上一阶段继承的无敌计时')
            lives=[i.args[0] for i in body if i.op==331]
            inherited=[]
            if not lives:
                for sub,ins in original.subs.items():
                    for i in ins:
                        if i.op==334 and i.mask&8 and i.args[3].strip('"') in src['roots'] and i.args[1]>0:
                            inherited.append((sub,i));lives.append(i.args[1])
                if not lives:
                    # 第一非符的构造入口同步CALL；只接受唯一的常量life来源。
                    for sub,ins in original.subs.items():
                        if any(i.op==11 and i.args[0].strip('"') in src['roots'] for i in ins):
                            for i in ins:
                                if i.op==331 and i.mask&8:inherited.append((sub,i));lives.append(i.args[0])
            thresholds=[i.args[1] for i in body if i.op==334 and i.args[1]>=0]
            if len(set(lives))==1 and all(isinstance(n,int) for n in lives+thresholds):
                verify('换算前有效血量',balance['raw'],lives[0]-max(thresholds or [0]),
                       {'inherited':[evidence(i,sub) for sub,i in inherited],
                        'entry':[evidence(i) for i in body if i.op in(331,334)]})
            else:
                row['pending'].append('TH10有效血量的多来源继承或动态分支')
        if g in (7,8) and balance:
            health_body=body
            if game==34 and id in CONTROLLERS:
                health_body=[i for i in original.subs['Sub'+str(CONTROLLERS[id])] if i.mask&8]
            if game==31 and id==422:
                health_body=body+[i for i in original.subs['Sub17'] if i.mask&8]
            lives=[i for i in health_body if i.op==(110 if g==7 else 131)]
            thresholds=([i.args[0] for i in health_body if i.op==112]+
                        [i.args[1] for i in health_body if i.op==148]) if g==7 else [
                            i.args[1] for i in health_body if i.op==133]
            if (len(lives)==1 and isinstance(lives[0].args[0],int)
                    and all(isinstance(t,int) for t in thresholds)):
                # 按所有生命回调槽的最大阈值结算，不把进场life当有效HP。
                verify('换算前有效血量',balance['raw'],lives[0].args[0]-max(thresholds or [0]),
                       {'life':evidence(lives[0]),'thresholds':thresholds})
            else:
                row['pending'].append('有效血量的跨子程序继承')
            guards=[i for i in health_body if i.op==(142 if g==7 else 160)]
            if len(guards)==1:
                guard=guards[0]
                disables=[i for i in health_body if i.op==80 and i.time==0 and i.args[0]&4] if g==8 else []
                enables=[i for i in health_body if i.op==81 and i.time==guard.time and i.args[0]&4] if g==8 else []
                if disables and enables:
                    verify('入场全免帧数',balance['immune'],guard.time,
                           {'disable':evidence(disables[0]),'enable':evidence(enables[0])})
                    verify('入场后九倍减伤帧数',balance['guard'],guard.args[0],evidence(guard))
                elif balance['immune']==guard.time:
                    verify('入口九倍减伤帧数',balance['guard'],guard.args[0],evidence(guard))
                else:
                    row['pending'].append('受击开关、减伤计时及跨阶段继承')
        if game==34 and id==4434:
            enabled=[i for i in body if i.op==103]
            assert [(i.time,i.args[0]) for i in enabled]==[(0,0),(340,1)]
            verify('过渡期间全免',card['metadata']['balance']['immune'],340,{'addresses':[hex(i.address) for i in enabled]})

    report={'说明':'逐入口独立参数核验。所有行为项仍须逐条逐帧核对，不能用检查数或引擎不崩溃代替。',
            'cards':records,'checks':count,'failures':failures,'full_original_frame_equivalence':False,
            'implementation_sha256':{f'mod/GAME/th{g}.lua':hashlib.sha256((ROOT/f'mod/GAME/th{g}.lua').read_bytes()).hexdigest() for g in range(31,36)}}
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(f'全量{len(rows)}个入口：{count}项参数比较，{len(failures)}项不一致；逐帧行为未据此判为通过。')
    for game,id,failure in failures:print(game,id,failure['field'],failure['actual'],failure['expected'])
    return bool(failures)


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cache',type=Path,default=Path(r'E:\workspace\.bossrush-validation\original-anm'))
    parser.add_argument('--binaries',type=Path,default=Path(r'E:\workspace\原作\ECL'))
    parser.add_argument('--output',type=Path,default=Path('tools/th3x-tests/entry-audit-2026-11-02.json'))
    raise SystemExit(check(parser.parse_args()))
