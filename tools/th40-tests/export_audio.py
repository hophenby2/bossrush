#!/usr/bin/env python3
"""复制原音效，将原WAV曲目转为LuaSTG可用的OGG；不改变原文件。"""
import argparse,concurrent.futures,json,subprocess,wave,re,shutil
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--game',required=True,type=Path);p.add_argument('--source',type=Path);a=p.parse_args();root=Path(__file__).resolve().parents[2]
sounds={};target=root/'Resources/th38/Sound';target.mkdir(parents=True,exist_ok=True)
for f in (a.game/'Sound').glob('*.wav'):
 shutil.copy2(f,target/f.name);sounds[f.name]=str((target/f.name).relative_to(root))
(root/'mod/GAME/th38/sounds.lua').write_text('-- 原音效路径，与公共音库隔离。\nreturn '+ '{'+','.join('['+json.dumps(k)+']='+json.dumps(v) for k,v in sounds.items())+'}\n')
names=['Stage01','Stage02','Stage03','Stage04','Stage05','Stage06','StageEx','Boss01','Boss02','Boss03','Boss04','Boss05','Boss06','Boss06FSC','BossEx']
def convert(name):
 source=a.game/'BGM'/(name+'.wav');out=root/'music'/('TH38_'+name+'.ogg')
 with wave.open(str(source)) as f:duration=f.getnframes()/f.getframerate()
 if not out.exists() or out.stat().st_size==0:subprocess.run(['ffmpeg','-v','error','-y','-i',str(source),'-c:a','vorbis','-strict','-2','-q:a','5',str(out)],check=True)
 return name,duration
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:durations=dict(executor.map(convert,names))
data={k:{'last':v,'length':v} for k,v in durations.items()}
if a.source:
 for f in sorted(a.source.rglob('*.cs')):
  if not f.name.startswith(('GameState_SSS','Story_SSS','EndBoss_FSC06')):continue
  for m in re.finditer(r'ChangeBGM\("[^"\n]*\\([^"\\]+)\.wav",[^;]*,\s*(\d+),\s*(\d+)\);',f.read_text()):
   name,begin,end=m[1],int(m[2]),int(m[3])
   if name not in data:continue
   with wave.open(str(a.game/'BGM'/(name+'.wav'))) as wav:rate=wav.getframerate()
   last=end/rate if end>begin else durations[name]
   data[name]={'last':last,'length':last-begin/rate}
(root/'mod/GAME/th38/music.lua').write_text('-- 秒数来自原PCM采样率；循环点提取自GameState/Story的ChangeBGM。\nreturn {'+','.join('['+json.dumps(k)+']={last='+repr(v['last'])+',length='+repr(v['length'])+'}' for k,v in data.items())+'}\n')
print('导出音效',len(sounds),'音乐',len(data))
