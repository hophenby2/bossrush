"""保留TH095普通敌机112拍摄回调的退场常量，不运行脚本。"""
from pathlib import Path
import argparse,importlib.util,json
from ecl_source import Source
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('serializer',Path(__file__).with_name('export_original_anm.py'))
serializer=importlib.util.module_from_spec(spec);spec.loader.exec_module(serializer)
def export(workspace):
 result={};evidence=[]
 for path in sorted((workspace/'original/ECL/th095').glob('*.ecl')):
  src=Source(workspace/'decompiled/ecl/95'/(path.stem+'.decl'),path,95)
  for sub,body in src.subs.items():
   for i in body:
    if i.op!=112 or not i.mask&8:continue
    target=i.args[0].strip('"');code=src.subs[target]
    cfg={'callback':path.stem+':'+target[3:],'life':next(j.time for j in code if j.op==1)}
    script=next((j.args[0] for j in code if j.op==54),None)
    if script is not None:cfg['script']=script
    if any(j.op==64 for j in code):cfg.update(drop=64,mode=1)
    interrupt=next((j.args for j in code if j.op==152),None)
    if interrupt:cfg['interrupt']=interrupt
    cfg['box']=next((j.args for j in body if j.op==77),[24,24])
    result[path.stem+':'+sub[3:]]=cfg
    evidence.append(dict(file=path.name,sub=sub,target=target,address=hex(i.address),config=cfg))
 (ROOT/'mod/GAME/th33_photo_sources.lua').write_text('-- 原始112拍摄回调；export_th095_capture_sources.py逐地址与原始二进制校验。\nreturn '+serializer.lua(result)+'\n')
 return evidence
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path);p.add_argument('--evidence',type=Path)
 a=p.parse_args();r=export(a.workspace)
 if a.evidence:a.evidence.write_text(json.dumps(r,ensure_ascii=False,indent=2)+'\n')
 print('普通敌机拍摄回调',len(r))
