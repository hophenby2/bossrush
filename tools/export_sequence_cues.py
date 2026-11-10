#!/usr/bin/env python3
"""保留妖/永原始ECL中的STD标签与反魂蝶换曲时间点，逐条校验原二进制。"""
from pathlib import Path
import argparse
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent/'th3x-tests'))
from ecl_source import Source
from export_original_anm import lua

def export(workspace):
    output={7:{},8:{}}
    for game in output:
        for path in sorted((workspace/f'original/ECL/th{game:02}').glob('*.ecl')):
            source=Source(workspace/f'decompiled/ecl/{game}/{path.stem}.decl',path,game)
            for sub,body in source.subs.items():
                cues=[]
                for i in body:
                    if not i.mask&8:continue
                    if i.op==(125 if game==7 else 147):cues.append([i.time,'signal',i.args[0]])
                    elif game==7 and i.op==121 and i.args[0] in (19,20):
                        cues.append([i.time,'fade' if i.args[0]==19 else 'resurrection',180])
                if cues:output[game][path.stem+':'+sub.removeprefix('Sub')]=cues
    target=Path(__file__).resolve().parents[1]/'mod/GAME/original/std/cues.lua'
    target.write_text('-- 原始ECL二进制核对过的STD标签与音乐切换，不改变弹幕解释流程。\nreturn '+lua(output)+'\n')
    print('原作STD/音乐信号',sum(len(c) for g in output.values() for c in g.values()))

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('workspace',type=Path);export(p.parse_args().workspace)
