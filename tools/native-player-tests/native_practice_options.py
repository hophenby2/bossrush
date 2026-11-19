#!/usr/bin/env python3
"""在隔离存档中验证实际菜单往返、初次启动与练习选项持久化。"""
import argparse,json,os,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',type=Path,required=True);ap.add_argument('--restore',action='store_true');args=ap.parse_args()
args.out=args.out.resolve();args.out.mkdir(parents=True,exist_ok=True)
env=dict(os.environ,BOSSRUSH_MAC_DATA=str(args.out),BOSSRUSH_MAC_TEST='practice-options')
env.pop('BOSSRUSH_MAC_TEST_RESTORE',None)
if args.restore:env['BOSSRUSH_MAC_TEST_RESTORE']='1'
with (args.out/'stdout.log').open('w') as log:
 p=subprocess.Popen([str(ROOT/'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD')],cwd=args.out,env=env,stdout=log,stderr=subprocess.STDOUT)
 deadline=time.monotonic()+100
 while p.poll() is None and time.monotonic()<deadline:
  trace=args.out/'lstg_log.txt'
  if trace.exists() and 'BOSSRUSH_ERROR:' in trace.read_text(errors='replace'):
   p.terminate();p.wait(timeout=5);break
  time.sleep(.2)
 if p.poll() is None:p.kill();p.wait()
report=args.out/'bossrush/User/mac-test.json'
assert p.returncode==0 and report.exists(),('菜单回归失败，见',str(args.out),p.returncode)
result=json.loads(report.read_text());assert result['passed'];print(json.dumps(result,ensure_ascii=False))
