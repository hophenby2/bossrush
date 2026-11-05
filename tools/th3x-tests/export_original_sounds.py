"""按复原SoundIdx映射保留新增原生演出使用的PCM，不转码、不归一化。"""
from pathlib import Path
import argparse,importlib.util,re,shutil,json
from ecl_source import Source
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('serializer',Path(__file__).with_name('export_original_anm.py'))
serializer=importlib.util.module_from_spec(spec);spec.loader.exec_module(serializer)
def export(workspace,originals):
 table={};evidence=[]
 for game in (8,95):
  root=workspace/'reconstructions'/('th095' if game==95 else 'th08')/'src'
  code=(root/'SoundPlayer.cpp').read_text()
  block=re.search(r'g_SoundBufferIdxVol[^=]*=\s*\{(.*?)\};',code,re.S)[1]
  records=[list(map(int,m)) for m in re.findall(r'\{\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}',block)]
  block=re.search(r'g_SFXList[^=]*=\s*\{(.*?)\};',code,re.S)[1]
  names=re.findall(r'"([^"]+\.wav)"',block)
  needed={15,18,38,45} if game==95 else set()
  for f in (workspace/'original/ECL'/('th095' if game==95 else 'th08')).glob('*.ecl'):
   src=Source(workspace/'decompiled/ecl'/str(game)/(f.stem+'.decl'),f,game)
   for body in src.subs.values():
    if any(i.op in (139,140) if game==8 else i.op==150 for i in body) and all(i.op<63 or i.op in (79,80,81,106,124,139,140,143,144,150,151,152) for i in body):
     needed.update(i.args[0] for i in body if i.op==(106 if game==95 else 124) and i.args and isinstance(i.args[0],int))
  dest=ROOT/'Resources/OriginalAudio'/str(game);dest.mkdir(parents=True,exist_ok=True)
  prefix='[th095]' if game==95 else '[th08]'
  origin=next(p/'data' for p in originals.iterdir() if p.name.startswith(prefix))
  result={}
  for i in sorted(needed):
   idx,volume,priority=records[i];name=names[idx]
   shutil.copyfile(origin/name,dest/name)
   result[i]=[str((dest/name).relative_to(ROOT)),volume,priority]
   evidence.append(dict(game=game,sound=i,buffer=idx,file=name,volume=volume,priority=priority))
  table[game]=result
 (ROOT/'mod/GAME/original/sounds.lua').write_text('-- 原版SoundIdx、波形及DirectSound音量；由export_original_sounds.py导出。\nreturn '+serializer.lua(table)+'\n')
 return evidence
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path);p.add_argument('originals',type=Path);p.add_argument('--evidence',type=Path)
 a=p.parse_args();r=export(a.workspace,a.originals)
 if a.evidence:a.evidence.write_text(json.dumps(r,ensure_ascii=False,indent=2)+'\n')
 print('原始音效映射',len(r))
