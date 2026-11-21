#!/usr/bin/env python3
"""逐作串行运行静音的 Windows 关卡/符卡性能夹具，避免多个游戏互相抢占资源。"""
import argparse
import json
import statistics
import subprocess
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
# 取各作末关、末期弹幕或已反馈的持续发弹场景；这是明确的采样范围，不代表全卡穷举。
GAMES=[
    ('th31',29,367,'th08_lunatic_b','6B'),
    ('th32',30,3985,'th06_lunatic','6'),
    ('th33',31,33460,'th095_extra','EX'),
    ('th34',32,4401,'th07_lunatic','6'),
    ('th35',33,3600,'th10_lunatic','6'),
    ('th37',35,37067,'thmhj2_lunatic','6'),
    ('th38',36,38066,'thasl_lunatic','6'),
    ('th39',37,39060,'thmhj3_lunatic','6'),
    ('th40',38,68041,'thsss_lunatic','6'),
    ('th41',39,70610,'theis_lunatic','6'),
    ('th42',40,72039,'likedreamer_chaos','10'),
    ('th43',41,86410,'thbdb_lunatic','6'),
]

def summarize(data):
    rows=[r for r in data['frames'] if r['frame']>=300 and r['frame']<data['inputs']['frames'] and 'render_ms' in r]
    if not rows:return {'samples':0,'error':data.get('error'),'ended_at':data.get('ended_at')}
    def stats(values):
        a=sorted(values)
        return dict(mean=round(statistics.mean(a),4),p99=round(a[int(len(a)*.99)],4),min=round(a[0],4),max=round(a[-1],4))
    assert all(r['audio_bgm']==0 and r['audio_se']==0 for r in rows),'音量未保持静音'
    return {'samples':len(rows),'logic_ms':stats([r['logic_ms'] for r in rows]),
        'render_ms':stats([r['render_ms'] for r in rows]),
        'combined_ms':stats([r['logic_ms']+r['render_ms'] for r in rows]),
        'fps':stats([r['fps'] for r in rows]),'below55':sum(r['fps']<55 for r in rows),
        'over_budget':sum(r['logic_ms']+r['render_ms']>1000/60 for r in rows),
        'objects':stats([r['objects'] for r in rows]),'heap_kb':stats([r['heap_kb'] for r in rows]),
        'native_machine':rows[-1].get('native_machine'),'sequence_machine':rows[-1].get('sequence_machine'),
        'sequence_resources':rows[-1].get('sequence_resources'),
        'audio_bgm':0,'audio_se':0,'ended_at':data.get('ended_at'),'error':data.get('error')}

def main():
    sys.stdout.reconfigure(encoding='utf-8')
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out',type=Path,required=True)
    ap.add_argument('--games',help='例如 th31,th37；默认当前全部十二作')
    ap.add_argument('--modes',default='practice,sequence')
    ap.add_argument('--frames',type=int,default=1800)
    ap.add_argument('--sample',action='store_true')
    ap.add_argument('--override-dir',type=Path,help='隔离目录中的对照 Lua 源码，不改写工作区')
    args=ap.parse_args();out=args.out.resolve();out.mkdir(parents=True,exist_ok=True)
    selected=set(args.games.split(',')) if args.games else {g[0] for g in GAMES}
    modes=args.modes.split(',');assert all(m in ('practice','sequence') for m in modes)
    results=[]
    for game,level,card,sequence,chapter in GAMES:
        if game not in selected:continue
        for mode in modes:
            case=out/(game+'-'+mode)
            command=[sys.executable,str(ROOT/'tools/profile_windows_cases.py'),'--case',mode,'--level',str(level),
                '--out',str(case),'--frames',str(args.frames),'--fps','60','--shoot','--engine-stats','--frame-detail']
            command+=['--card',str(card)] if mode=='practice' else ['--sequence',sequence,'--chapter',chapter]
            if args.sample:command.append('--sample')
            if args.override_dir:command+=['--override-dir',str(args.override_dir)]
            # 每个结果及原生进程各自独立；失败也保留明确记录，并继续其余作品。
            with (out/(case.name+'.stdout.log')).open('w',encoding='utf-8') as log:
                process=subprocess.run(command,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT)
            report=case/'result.json'
            row={'game':game,'level':level,'mode':mode,'directory':str(case),'exit':process.returncode}
            if report.exists():
                data=json.loads(report.read_text(encoding='utf-8'));row.update(summarize(data))
            else:row['error']='没有原生报告，见对应 stdout.log'
            results.append(row)
            (out/'summary.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
            print(json.dumps(row,ensure_ascii=False),flush=True)
    raise SystemExit(0 if results and all(r['exit']==0 and not r.get('error') and r.get('samples',0)>0 for r in results) else 1)

if __name__=='__main__':main()
