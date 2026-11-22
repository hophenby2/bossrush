#!/usr/bin/env python3
"""从雪莲华发行包恢复 SpriteRenderer 的实际尺寸与中心；不读取或改写存档。"""
import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import struct
import subprocess

import UnityPy

ROOT=Path(__file__).resolve().parents[2]


def lua(v):
    if isinstance(v,dict):
        return '{'+','.join('['+json.dumps(str(k),ensure_ascii=False)+']='+lua(x) for k,x in v.items())+'}'
    if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
    return json.dumps(v,ensure_ascii=False)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--data',type=Path,required=True)
    ap.add_argument('--luajit',type=Path,required=True)
    args=ap.parse_args()
    build=args.data/'globalgamemanagers'
    env=UnityPy.load(str(build))
    raw=next(o.get_raw_data() for o in env.objects if o.type.name=='BuildSettings')
    count=struct.unpack_from('<I',raw)[0];cursor=4;scenes=[]
    for _ in range(count):
        size=struct.unpack_from('<I',raw,cursor)[0];cursor+=4
        scenes.append(Path(raw[cursor:cursor+size].decode()).stem)
        cursor=(cursor+size+3)&~3
    output={};sources={};changes=[];unmatched=[]
    prefabs={}
    resources=args.data/'resources.assets'
    for o in UnityPy.load(str(resources)).objects:
        if o.type.name!='SpriteRenderer':continue
        renderer=o.read();name=renderer.m_GameObject.read().m_Name
        if name not in ('niaoju','sky_break','nightsky'):continue
        sprite=renderer.m_Sprite.read()
        prefabs[name]=dict(size=[sprite.m_Rect.width/sprite.m_PixelsToUnits,sprite.m_Rect.height/sprite.m_PixelsToUnits],
                           pivot=[sprite.m_Pivot.x,sprite.m_Pivot.y])
    sources[resources.name]=hashlib.sha256(resources.read_bytes()).hexdigest()
    for index,name in enumerate(scenes):
        if not name.startswith('Stage'):continue
        key=name[5:]
        path=ROOT/f'mod/GAME/th38/scenes/{key}.lua'
        if not path.exists():continue
        file=args.data/f'level{index}'
        env=UnityPy.load(str(file));objects={o.path_id:o for o in env.objects};sprites=defaultdict(list)
        sources[file.name]=hashlib.sha256(file.read_bytes()).hexdigest()
        for o in env.objects:
            if o.type.name!='SpriteRenderer':continue
            renderer=o.read();go=renderer.m_GameObject.read()
            tr=next((objects[c.component.m_PathID].read() for c in go.m_Component
                     if objects[c.component.m_PathID].type.name=='Transform'),None)
            if tr is None or not renderer.m_Sprite.m_PathID:continue
            sprite=renderer.m_Sprite.read()
            size=[sprite.m_Rect.width/sprite.m_PixelsToUnits,sprite.m_Rect.height/sprite.m_PixelsToUnits]
            if renderer.m_DrawMode!=0:size=[renderer.m_Size.x,renderer.m_Size.y]
            sprites[go.m_Name].append(dict(pos=[tr.m_LocalPosition.x,tr.m_LocalPosition.y,tr.m_LocalPosition.z],
                size=size,pivot=[sprite.m_Pivot.x,sprite.m_Pivot.y]))
        script="local d=dofile('mod/GAME/th38/scenes/%s.lua'); for i,n in ipairs(d.nodes) do if n.sprite then print(i,n.name,table.concat(n.pos,','),table.concat(n.sprite.size,',')) end end"%key
        rows=subprocess.check_output([str(args.luajit.resolve()),'-e',script],cwd=ROOT).decode('utf-8')
        data={}
        for line in rows.splitlines():
            node,node_name,pos,size=line.split('\t')
            pos=list(map(float,pos.split(',')));old=list(map(float,size.split(',')))
            candidates=sprites.get(node_name,[])
            candidate=min(candidates,key=lambda c:sum((a-b)**2 for a,b in zip(c['pos'],pos))) if candidates else None
            if candidate is None and node_name in prefabs:
                candidate=dict(pos=pos,**prefabs[node_name])
            if candidate is None or sum((a-b)**2 for a,b in zip(candidate['pos'],pos))>.001:
                unmatched.append([key,node_name]);continue
            data[node]={k:candidate[k] for k in ('size','pivot')}
            if max(abs(a-b) for a,b in zip(candidate['size'],old))>.001:
                changes.append(dict(scene=key,node=node_name,before=old,after=candidate['size']))
        output[key]=data
    target=ROOT/'mod/GAME/th38/scenes/release_geometry.lua'
    target.write_text('-- 发行包实际精灵几何；Simple 模式忽略 SpriteRenderer.m_Size。\nreturn '+lua(output)+'\n',encoding='utf-8',newline='\n')
    (target.parent/'release_geometry_sources.json').write_text(json.dumps(dict(
        source_sha256=sources,changes=changes,unmatched=unmatched),ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
    print('场景',len(output),'几何修正',len(changes),'未匹配',len(unmatched))
    for row in changes[:10]:print(row)


if __name__=='__main__':main()
