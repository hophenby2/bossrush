#!/usr/bin/env python3
"""在真实Metal引擎中检查背景时间轴与原模型，保存独立日志和截图。"""
import argparse,json,os,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--card',type=int,default=0);p.add_argument('--cases',default='spring:4:0,spring:4:1920,spring:4:3120,spring:4:11100');p.add_argument('--out',type=Path,required=True)
a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
binary=ROOT/'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD';results=[]
for case in a.cases.split(','):
    sequence,machine={'spring':('thmhj2_lunatic','reimu'),'unity':('thasl_lunatic','reimu'),'summer':('thsss_lunatic','A'),'theis':('theis_lunatic','reimu'),'keiwa':('thbdb_lunatic','reimu')}[case.split(':')[0]]
    out=a.out/case.replace(':','-');out.mkdir(exist_ok=True)
    env=dict(os.environ,BOSSRUSH_MAC_DATA=str(out.resolve()),BOSSRUSH_MAC_TEST='battle',BOSSRUSH_MAC_TEST_SEQUENCE=sequence,
        BOSSRUSH_MAC_TEST_MACHINE=machine,BOSSRUSH_MAC_TEST_CARD=str(a.card),BOSSRUSH_MAC_TEST_LOGIC_FRAMES='300',BOSSRUSH_MAC_TEST_SHOOT='0',
        BOSSRUSH_MAC_TEST_SOURCE_SCENE=case)
    if a.card:env.pop('BOSSRUSH_MAC_TEST_SEQUENCE',None)
    with (out/'stdout.log').open('w') as log:
        proc=subprocess.Popen([str(binary)],cwd=out,env=env,stdout=log,stderr=subprocess.STDOUT);deadline=time.monotonic()+55;error=None
        while proc.poll() is None and time.monotonic()<deadline:
            log.flush();trace=(out/'lstg_log.txt').read_text(errors='replace') if (out/'lstg_log.txt').exists() else ''
            if 'BOSSRUSH_ERROR:' in trace:
                error=next(s for s in trace.splitlines() if 'BOSSRUSH_ERROR:' in s);proc.terminate();break
            time.sleep(.2)
        if proc.poll() is None:
            if not error:error='真实引擎超时';proc.kill()
            proc.wait(timeout=10)
    text=(out/'lstg_log.txt').read_text(errors='replace') if (out/'lstg_log.txt').exists() else ''
    row={'case':case,'passed':proc.returncode==0 and 'SOURCE_SCENE:' in text,'error':error};results.append(row);print(json.dumps(row,ensure_ascii=False),flush=True)
(a.out/'results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
raise SystemExit(0 if all(r['passed'] for r in results) else 1)
