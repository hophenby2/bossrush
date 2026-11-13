#!/usr/bin/env python3
"""在隔离数据目录运行Mac真实引擎；不访问玩家User/replay。"""
import argparse,hashlib,json,os,shutil,subprocess,tempfile,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--card',type=int);p.add_argument('--sequence',choices=['thasl_lunatic','thasl_extra_a','thmhj3_lunatic','thmhj3_extra','thmhj3_phantasm']);p.add_argument('--repeat',action='store_true');p.add_argument('--damage',action='store_true');p.add_argument('--frames',type=int,default=900);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
env=dict(os.environ,BOSSRUSH_MAC_TEST='battle',BOSSRUSH_MAC_TEST_SEED='20261112',BOSSRUSH_MAC_TEST_SHOOT='0',BOSSRUSH_MAC_TEST_LOGIC_FRAMES=str(a.frames))
if a.card:env['BOSSRUSH_MAC_TEST_CARD']=str(a.card)
if a.sequence:env['BOSSRUSH_MAC_TEST_SEQUENCE']=a.sequence
game='th39' if (a.card and a.card>=39000) or (a.sequence and a.sequence.startswith('thmhj3_')) else 'th38'
if a.damage:env['BOSSRUSH_MAC_TEST_'+game.upper()+'_DAMAGE']='1'
if a.repeat:env['BOSSRUSH_MAC_TEST_TH37_REPEAT']='1'
exe=ROOT/'macos/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD'
code=[ROOT/p for p in ['core.lua','mod/content.lua','mod/original_practice.lua','mod/GAME/original/stage_flow.lua','mod/main_stage.lua','THlib/ext/ext_stage_group.lua','THlib/UI/UI.lua','mod/_editor_output.lua']]+[ROOT/f'mod/GAME/{game}.lua',ROOT/'mod/original_sequence.lua',ROOT/'mod/sequence_catalog.lua',ROOT/'macos/lua/test.lua']+sorted((ROOT/f'mod/GAME/{game}').rglob('*.lua'))
fingerprints={}
for path in code:
 rel=path.relative_to(ROOT).as_posix();bundled=exe.parents[1]/'Resources/game'/rel
 bundle_path=exe.parents[1]/'Resources/game/macos/test.lua' if rel=='macos/lua/test.lua' else bundled
 assert path.read_text()==bundle_path.read_text(),'Mac资源不是当前源码，请先 --update-assets：'+rel
 # Mac打包器统一Lua换行；正文相同，仍记录工作区原始字节的哈希。
 fingerprints[rel]=hashlib.sha256(path.read_bytes()).hexdigest()
with tempfile.TemporaryDirectory(prefix=f'bossrush-{game}-native-') as tmp:
 env['BOSSRUSH_MAC_DATA']=tmp
 with (a.out/'run.log').open('w') as log:
  started=time.monotonic();proc=subprocess.Popen([str(exe),'-ApplePersistenceIgnoreState','YES'],cwd=tmp,env=env,stdout=log,stderr=subprocess.STDOUT)
  try:code=proc.wait(timeout=max(70,a.frames*(2 if a.repeat else 1)/30+30))
  except subprocess.TimeoutExpired:
   proc.terminate();proc.wait(timeout=10);raise RuntimeError('真实引擎超时：'+str(a.out/'run.log'))
 report=Path(tmp)/'bossrush/User/mac-test.json'
 if not report.exists():
  logs=Path(tmp)/'bossrush/LuaSTG.log'
  if logs.exists():shutil.copy2(logs,a.out/'engine.log')
  raise RuntimeError('引擎未完成，退出码'+str(code)+'，见 '+str(a.out/'run.log'))
 result=json.loads(report.read_text());result.pop('data',None);result['wall_seconds']=time.monotonic()-started
 result['sequence']=a.sequence;result['native_platform']='macOS / LuaSTG-x / Metal';result['source_sha256']=fingerprints
 (a.out/'result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
 assert code==0,code
 assert result['logic_frames']==a.frames and result['checkpoint'],result
 assert result['peak']>0,'没有生成弹幕'
 if a.card or a.sequence:assert result['mhj_moves']>0,'有速度的弹体没有产生实际位移'
 if a.damage:assert result['mhj_damage_checked'],'真实碰撞扣血检查未执行'
 if a.repeat:assert result['mhj_repeated'],'练习重试检查未执行'
 for image in (Path(tmp)/'bossrush/snapshot').glob('*.png'):shutil.copy2(image,a.out/image.name)
 print(json.dumps({k:v for k,v in result.items() if k!='source_sha256'},ensure_ascii=False))
