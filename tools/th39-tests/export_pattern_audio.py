#!/usr/bin/env python3
"""补导 CrazyStorm 的逐弹型音效、中心音效与 Gather；不改写攻击发射器。"""
import argparse
import importlib.util
import json
from pathlib import Path
import re
import sys
sys.dont_write_bytecode=True

HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('presentation_export',HERE/'export_presentation.py')
presentation=importlib.util.module_from_spec(spec);spec.loader.exec_module(presentation)
base=presentation.background


def arguments(text):
    return [base.atom(v) for v in text.split('，')] if text else []


class PatternAudioExport(presentation.PresentationExport):
    def pattern(self,*args,**kwargs):
        previous=getattr(self,'supplement_only',False)
        self.supplement_only=False
        try:return super().pattern(*args,**kwargs)
        finally:self.supplement_only=previous

    def action(self,action,kind):
        if not getattr(self,'supplement_only',False):return super().action(action,kind)
        match=re.fullmatch(r'(Gather|StopSound|PlaySound)(?:\((.*)\))?',action)
        if not match:return None
        name,raw=match.groups()
        if name=='Gather':
            values=arguments(raw)
            effect='100' if not values else values[0] if len(values)==3 else values[1] if len(values) in (5,6) else None
            if effect:self.pattern(str(effect),'e',base.SCENES)
            return 'R.gather(o'+''.join(','+base.lua(v) for v in values)+')'
        if name=='StopSound':return 'R.stopSound('+base.lua(raw)+')'
        return 'R.playEventSound(o,'+base.lua(raw)+')'


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--content',type=Path,required=True)
    args=ap.parse_args()
    ex=PatternAudioExport(None,args.content.resolve())
    ex.supplement_only=True
    base.export.Export.texture(ex,'warning',Path('Graphics/Pattern/warning.xna'))
    base.export.Export.texture(ex,'mist',Path('Graphics/Pattern/mist.xna'))
    # 中心补充事件单独使用次数限制编号，避免与既有中心事件共用编号。
    ex.counts['events']=1000000
    rows=[];profiles={}
    for file in sorted((args.content/'Data').glob('*.xna')):
        if not file.stem.startswith(('b','e')):continue
        try:text=ex.text(file.stem)
        except UnicodeDecodeError:continue
        if not text.startswith('Crazy Storm Data 1.01'):continue
        lines=text.splitlines();sounds={}
        center=next(row for row in lines if row.startswith('Center:'))
        for i,row in enumerate(lines):
            m=re.fullmatch(r'(\d+) Sounds:',row)
            if m:
                for sound in lines[i+1:i+1+int(m[1])]:
                    ident,name=sound.split('_')[:2];sounds[max(1,int(ident))]=name
        fields=center[7:].split(',')
        events=','.join(fields[6:] if fields[0]!='False' else fields[1:])
        group='中心|1|0|'+events
        code=ex.events(group,'center')
        flags=dict(sounds=sounds,useKira='UseKira' in events,banSound=bool(re.search(r'BanSound(?!Laser)',events)),banLaser='BanSoundLaser' in events)
        laser=re.search(r'SetLazerSound\(([^)]+)\)',events)
        if laser:flags['laserSound']=laser[1]
        head=base.lua(flags)[:-1]
        rows.append('['+base.lua(file.stem)+']='+head+',centerEvents='+code+'}')
        profiles[file.stem]=flags
    target=base.OUT/'pattern_audio.lua'
    target.write_text('-- 逐弹型音效及缺失的中心表现事件；与原攻击脚本分开补导。\nreturn {'+',\n'.join(rows)+'}\n',encoding='utf-8',newline='\n')
    (base.OUT/'pattern_audio_sources.json').write_text(json.dumps(dict(source_sha256=ex.hashes,
        patterns=len(rows),effects=list(sorted(ex.patterns)),textureHeights=ex.textures),ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
    (base.SCENES/'pattern_effect_textures.lua').write_text('return '+base.lua(ex.textures)+'\n',encoding='utf-8',newline='\n')
    print('弹幕音效档案',len(rows),'蓄力特效',len(ex.patterns))


if __name__=='__main__':main()
