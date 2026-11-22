#!/usr/bin/env python3
"""补导原作关卡轴上的普通特效与音效，不重新导出战斗弹幕。"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import sys
sys.dont_write_bytecode=True

HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('background_export',HERE/'export_background.py')
background=importlib.util.module_from_spec(spec);spec.loader.exec_module(background)


class PresentationExport(background.BackgroundExport):
    def action(self,action,kind):
        if action.startswith('PlaySound('):
            return 'R.playEventSound(o,'+background.lua(action[10:-1])+')'
        return super().action(action,kind)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--content',type=Path,required=True)
    args=ap.parse_args()
    content=args.content.resolve()
    ex=PresentationExport(None,content);stages={};timings={}
    for stage in range(1,7):ex.pattern('99'+str(stage),'e',background.SCENES)
    for script in background.STAGES:
        events={};groups=[];group=None;card=None;previous=[]
        for tick,raw in background.commands(ex.text(script),'灵'):
            op,args=background.split_command(raw)
            values=list(map(background.atom,args))
            if op=='SetBossStage':
                group={};groups.append(group);previous=[];card=None
            elif op=='SetBossCard':
                kind,number=values[:2]
                delay=100 if len(values)>4 and values[4]=='TRANS' else 0
                card={'practice':delay,'sequence':(90 if any(n!=number for n in previous) else 150) if kind>=2 else delay,'open':60}
                group[str(number)]=card
                if kind>=2:previous.append(number)
            elif op=='SetBossCardLabel' and card is not None:
                if values[0]=='TRANS':card['practice']=card['sequence']=100
                elif values[0]=='DELAY':card['open']=150
            if op=='RaiseEffect':
                ex.pattern(args[0],'e',background.SCENES)
                event=[op,'e'+args[0],float(args[1])+145,float(args[2]),int(args[3])]
            elif op in ('PlaySound','FadeinEnvSound','FadeoutEnvSound'):
                event=[op,*map(background.atom,args)]
            else:continue
            events.setdefault(tick,[]).append(event)
        stages[script]=events
        timings[script]=groups
    logic=content.parents[4]/'THMHJ'
    boss=(logic/'Boss.cs').read_text(encoding='utf-8-sig')
    final=re.search(r'FinalLSC\s*=.*?\{(.*?)\}',boss,re.S)[1]
    final=re.findall(r'"([^"]+)"',final)
    target=background.SCENES/'presentation.lua'
    target.write_text('-- 原作关卡特效、开场延迟与音效时间轴；快进不播放历史声音。\nreturn '+background.lua(dict(stages=stages,timings=timings,finalLSC=final,textureHeights=ex.textures))+'\n',encoding='utf-8',newline='\n')
    manifest=dict(source_sha256=ex.hashes,statistics=dict(ex.counts),
                  cues=sum(len(v) for stage in stages.values() for v in stage.values()))
    manifest['logic_sha256']={name:hashlib.sha256((logic/name).read_bytes()).hexdigest() for name in ('StageManager.cs','BossCard.cs','BossStage.cs','Boss.cs')}
    (target.parent/'presentation_sources.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
    print('原作时间点',manifest['cues'],'特效',len(ex.patterns),'纹理',len(ex.textures))


if __name__=='__main__':main()
