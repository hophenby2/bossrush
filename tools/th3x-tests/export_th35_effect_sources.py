"""从TH10二进制校验后的原始ECL导出独立ANM命令及MapleEnemy循环。"""
from pathlib import Path
import argparse,importlib.util,json
from ecl_source import Source,Variable
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('serializer',Path(__file__).with_name('export_original_anm.py'))
serializer=importlib.util.module_from_spec(spec);spec.loader.exec_module(serializer)
def export(workspace):
 out={};evidence=[];ambient={}
 for stage in range(1,8):
  file='stage%02d'%stage
  src=Source(workspace/'decompiled/ecl/10'/(file+'.decl'),workspace/'original/ECL/th10'/(file+'.ecl'),10)
  mask=16 if stage==7 else 8
  for sub,body in src.subs.items():
   rows={}
   for i in body:
    if not i.mask&mask or i.op not in (263,264,272,273):continue
    repeat=False
    for j in body:
     if j.op in (12,13,14) and isinstance(j.args[0],str) and j.args[0] in src.labels:
      if src.labels[j.args[0]]<=i.address<j.address:repeat=True
    args=[{'var':a.index} if isinstance(a,Variable) else a for a in i.args]
    rows[i.address]=dict(time=i.time,op=i.op,bank=args[0],script=args[1],repeatable=repeat)
    if len(args)>2:rows[i.address]['rotation']=args[2]
    evidence.append(dict(file=file,sub=sub,address=hex(i.address),**rows[i.address]))
   if rows:out[file+':'+sub]=rows
  maple=src.subs['MapleEnemy']
  plays=[i.args[1] for i in maple if i.op==264]
  back=[i for i in maple if i.op==12]
  if len(plays)==1:ambient[stage]={'first':plays[0],'period':back[-1].time-back[-1].args[1]}
  else:
   branch=next(i for i in maple if i.op==14)
   counter=next(i.args[0] for i in maple if i.op==42)
   ambient[stage]={'first':plays[0],'second':plays[1],'period':branch.time-branch.args[1],
      'count':counter,'second_period':back[-1].time-back[-1].args[1]}
 out['_ambient']=ambient
 (ROOT/'mod/GAME/th35_effect_sources.lua').write_text('-- 原始ANM独立播放指令及回边归属；export_th35_effect_sources.py导出。\nreturn '+serializer.lua(out)+'\n')
 return evidence
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path);p.add_argument('--evidence',type=Path)
 a=p.parse_args();r=export(a.workspace)
 if a.evidence:a.evidence.write_text(json.dumps(r,ensure_ascii=False,indent=2)+'\n')
 print('独立ANM源点',len(r))
