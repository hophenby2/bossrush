#!/usr/bin/env python3
"""在隔离存档中核对原作 Bomb、锁速、禁射和冷却。"""
import argparse,hashlib,json,os,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--variant',default='high');ap.add_argument('--machine');ap.add_argument('--out',type=Path,required=True);ap.add_argument('--levels',default='39')
ap.add_argument('--card',type=int,help='改为实际符卡练习，覆盖存在 Boss 的自机更新')
ap.add_argument('--chapter',help='从关卡练习进入指定章节，只运行这一面')
ap.add_argument('--frames',type=int,help='指定逻辑帧数')
args=ap.parse_args();args.out=args.out.resolve();args.out.mkdir(parents=True,exist_ok=True)
cases={35:('thmhj2_lunatic','reimu'),36:('thasl_lunatic','reimu'),37:('thmhj3_lunatic','reimu'),
    38:('thsss_lunatic','A'),39:('theis_lunatic','reimu'),41:('thbdb_lunatic','reimu')}
binary=ROOT/'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD';rows=[]
for level in map(int,args.levels.split(',')):
    sequence,machine=cases[level];machine=args.machine or machine;data=args.out/str(level);data.mkdir(exist_ok=True)
    fingerprints={}
    if args.variant=='mechanics':
        game,pattern={35:('th37','652'),36:('th38','L_stage6_boss1_9')}[level]
        for rel in ['THlib/ext/ext.lua','THlib/native_time.lua','THlib/native_players.lua',f'mod/GAME/{game}/runtime.lua',
                    f'mod/GAME/{game}/patterns/{pattern}.lua','macos/lua/test.lua','macos/lua/source_logic_probe.lua','macos/lua/source_logic_mechanics.lua']:
            path=ROOT/rel;bundled=binary.parents[1]/'Resources/game'/rel.replace('macos/lua/','macos/',1)
            assert path.read_text()==bundled.read_text(),'Mac资源不是当前源码：'+rel
            fingerprints[rel]=hashlib.sha256(path.read_bytes()).hexdigest()
    env=dict(os.environ,BOSSRUSH_MAC_DATA=str(data),BOSSRUSH_MAC_TEST='battle',BOSSRUSH_MAC_TEST_SEQUENCE='' if args.card else sequence,
        BOSSRUSH_MAC_TEST_MACHINE=machine,BOSSRUSH_MAC_TEST_SOURCE_LOGIC='1',BOSSRUSH_MAC_TEST_LOGIC_VARIANT=args.variant,BOSSRUSH_MAC_TEST_CARD=str(args.card or 0),
        BOSSRUSH_MAC_TEST_LOGIC_FRAMES=str(args.frames or (1200 if level==41 else 700)),BOSSRUSH_MAC_TEST_FRAMES=str(args.frames or (1200 if level==41 else 700)),BOSSRUSH_MAC_TEST_SHOOT='0')
    env.pop('BOSSRUSH_MAC_TEST_PRACTICE_CHAPTER',None)
    if args.chapter:env['BOSSRUSH_MAC_TEST_PRACTICE_CHAPTER']=args.chapter
    with (data/'stdout.log').open('w') as log:
        p=subprocess.Popen([str(binary)],cwd=data,env=env,stdout=log,stderr=subprocess.STDOUT)
        limit=100 if args.variant=='mechanics' else 55
        deadline=time.monotonic()+limit;error=None
        while p.poll() is None and time.monotonic()<deadline:
            trace=data/'lstg_log.txt'
            if trace.exists():
                errors=[s for s in trace.read_text(errors='replace').splitlines() if 'BOSSRUSH_ERROR:' in s]
                if errors:error=errors[-1];p.terminate();break
            time.sleep(.2)
        if p.poll() is None:
            if error:p.wait(timeout=5)
            else:p.kill();p.wait();error=f'测试未在{limit}秒内结束'
    report=data/'bossrush/User/mac-test.json'
    text=(data/'lstg_log.txt').read_text(errors='replace') if (data/'lstg_log.txt').exists() else ''
    passed=p.returncode==0 and report.exists() and 'SOURCE_LOGIC:' in text
    row={'level':level,'passed':passed,'exit':p.returncode,'error':error,'source_sha256':fingerprints};rows.append(row)
    print(json.dumps(row,ensure_ascii=False),flush=True)
(args.out/'results.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
raise SystemExit(0 if all(r['passed'] for r in rows) else 1)
