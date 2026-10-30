#!/usr/bin/env python3
"""在独立临时数据目录中测量固定种子 / 固定逻辑帧，不改变游戏内容。"""
from pathlib import Path
import argparse,json,os,subprocess,tempfile,time
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--app',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
parser.add_argument('--frames',type=int,default=900)
parser.add_argument('--seed',type=int,default=20261030)
parser.add_argument('--compare',type=Path,help='与已有 result.json 比较逻辑帧、弹幕峰值和对象状态')
args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='bossrush-mac-benchmark-') as folder:
 env=dict(os.environ,BOSSRUSH_MAC_DATA=folder,BOSSRUSH_MAC_TEST='battle',BOSSRUSH_MAC_TEST_SEED=str(args.seed),BOSSRUSH_MAC_TEST_LOGIC_FRAMES=str(args.frames))
 with (args.output/'run.log').open('w') as log:
  start=time.monotonic()
  process=subprocess.Popen([str(args.app.resolve()/'Contents/MacOS/BossRushHD')],cwd=folder,env=env,stdout=log,stderr=subprocess.STDOUT)
  try:code=process.wait(timeout=60)
  except subprocess.TimeoutExpired:
   process.terminate();process.wait(timeout=10);raise RuntimeError('基准运行超时，见 '+str(args.output/'run.log'))
  assert code==0,code
 data=json.loads((Path(folder)/'bossrush/User/mac-test.json').read_text())
 data.pop('data',None);data['wall_seconds']=time.monotonic()-start
 data['seed']=args.seed
 assert data['logic_frames']==args.frames and data['checkpoint']
 (args.output/'result.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
 if args.compare:
  baseline=json.loads(args.compare.read_text())
  assert baseline.get('seed',args.seed)==args.seed,'对照随机种子不符'
  for field in ('logic_frames','checkpoint','peak','objects'):
   assert data[field]==baseline[field],f'优化前后 {field} 不符：{baseline[field]} / {data[field]}'
  comparison={'state_matches':True,'baseline':str(args.compare),'fps_before':baseline['fps'],'fps_after':data['fps'],
              'elapsed_before':baseline['elapsed'],'elapsed_after':data['elapsed']}
  (args.output/'comparison.json').write_text(json.dumps(comparison,ensure_ascii=False,indent=2)+'\n')
 print(json.dumps(data,ensure_ascii=False),flush=True)
