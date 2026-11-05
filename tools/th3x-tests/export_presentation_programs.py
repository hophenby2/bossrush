"""离线保留TH08/TH095的演出调度常量；不运行ECL、Lua或游戏。

运动、发弹、生命及判定仍由关卡实现执行。保留地址对应的占位项，避免删除非演出指令后破坏跳转。
"""
from pathlib import Path
import argparse,importlib.util,json
from ecl_source import Source,Variable
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('anm_serializer',Path(__file__).with_name('export_original_anm.py'))
serializer=importlib.util.module_from_spec(spec);spec.loader.exec_module(serializer)
CONTROL=set(range(54))
EXTRA={8:{63,90,91,92,93,94,110,124,135,136,137,139,140},95:set(range(54,66))|{70,71,77,79,80,81,83,84,100,106,108,109,112,115,116,117,118,119,124,143,144,150,151,152}}
FX={8:{136,137,139,140},95:set(range(54,63))|{77,79,80,81,118,119,124,143,144,150,151,152}}
def has_effect(game, instruction):
 if game==8 and instruction.op in (136,137):
  return instruction.args and instruction.args[0] == (1 if instruction.op==136 else 13)
 return instruction.op in FX[game]
def export(workspace):
 output={};evidence=[]
 for game in (8,95):
  bank={}
  for path in sorted((workspace/'original/ECL'/('th095' if game==95 else 'th08')).glob('*.ecl')):
   src=Source(workspace/'decompiled/ecl'/str(game)/(path.stem+'.decl'),path,game)
   subs={};active={};motion={}
   for name,body in src.subs.items():
    # 数据位置不裁剪；难度与人/妖掩码由调度端按原指令选择。
    pos={i.address:n+1 for n,i in enumerate(body)}
    rows=[];active[name]=any(has_effect(game,i) for i in body)
    motion[name]=any(64<=i.op<=74 for i in body)
    for i in body:
     op=i.op if i.op in CONTROL|EXTRA[game] else 0
     args=[]
     for n,a in enumerate(i.args if op else []):
      if isinstance(a,Variable):a={'var':a.index}
      elif isinstance(a,str):
       if a in src.labels and ((op in (4,5) and n==1) or (40<=op<=51 and n==3)):
        a=pos[src.labels[a]]
       else:a=a.strip('"')
      args.append(a)
     rows.append([i.time,op,i.mask,*args])
     if i.op in FX[game]:evidence.append(dict(game=game,file=path.name,sub=name,address=hex(i.address),time=i.time,op=i.op))
    subs[name]=rows
   changed=True
   while changed:
    changed=False
    for name,body in src.subs.items():
     if active[name]:continue
     for i in body:
      j=0 if i.op==52 else 1 if i.op==(135 if game==8 else 117) else None
      if j is not None and isinstance(i.args[j],str) and active.get(i.args[j].strip('"')):
       active[name]=True;changed=True;break
   changed=True
   while changed:
    changed=False
    for name,body in src.subs.items():
     if motion[name]:continue
     for i in body:
      j=0 if i.op==52 else 1 if i.op==(135 if game==8 else 117) else None
      if j is not None and isinstance(i.args[j],str) and motion.get(i.args[j].strip('"')):
       motion[name]=True;changed=True;break
   pure_actor={name:True for name,body in src.subs.items() if active[name] and
    any(i.op in FX[game] for i in body) and all(i.op in CONTROL|{63,79,80,81}|FX[game] for i in body)}
   if game==95:
    allowed=CONTROL|set(range(54,66))|{70,71,77,79,80,81,100,106,108,109,112,117,118,119,124,132,143,144,150,151,152}
    safe={name for name,body in src.subs.items() if all(i.op in allowed for i in body) and
      all(i.args and i.args[0] in (6,7,8,12,13,-1) for i in body if i.op in (118,119))}
    changed=True
    while changed:
     changed=False
     for name in tuple(safe):
      for i in src.subs[name]:
       n=0 if i.op==52 else 1 if i.op==117 else None
       if n is not None and isinstance(i.args[n],str) and i.args[n].strip('"') not in safe:
        safe.remove(name);changed=True;break
    pure_actor={name:True for name in safe if active[name]}
   sound_scripts={name:True for name,body in src.subs.items() if
    any(i.op in (139,140) if game==8 else i.op==150 for i in body) and
    all(i.op<63 or i.op in (79,80,81,106,124,139,140,143,144,150,151,152) for i in body)}
   bank[path.stem]={'scripts':subs,'active':active,'motion':motion,'pure_actor':pure_actor,'sound_scripts':sound_scripts,'sha256':src.sha256}
  output[game]=bank
 target=ROOT/'mod/GAME/original/presentation_programs.lua'
 target.write_text('-- 原始二进制校验后导出的演出调度常量；不包含ECL原文件。\nreturn '+serializer.lua(output)+'\n')
 return evidence
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path);p.add_argument('--evidence',type=Path)
 a=p.parse_args();e=export(a.workspace)
 if a.evidence:a.evidence.write_text(json.dumps(e,ensure_ascii=False,indent=2)+'\n')
 print('导出演出源点',len(e))
