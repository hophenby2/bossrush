#!/usr/bin/env python3
"""补导发行包自机 prefab 的粒子组件和原纹理，源目录只读。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys
sys.dont_write_bytecode=True
from UnityPy.export.Texture2DConverter import get_image_from_texture2d
from release_source import Source
from export_release_presentation import lua

ROOT=Path(__file__).resolve().parents[2]


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--data',type=Path,required=True)
    args=ap.parse_args();s=Source(args.data)
    manager=s.load('globalgamemanagers')
    manager=next(o for o in manager.objects.values() if o.type.name=='ResourceManager').read()
    prefabs=set(re.findall(r'\["(Resources/[^"\n]+\.prefab)"\]=',
        (ROOT/'mod/GAME/th38/native_players/data.lua').read_text(encoding='utf8')))
    paths={p.removeprefix('Resources/').removesuffix('.prefab').lower():p for p in prefabs}
    rows={};textures={};art=ROOT/'Resources/th38/presentation';art.mkdir(exist_ok=True)
    allowed={'InitialModule','ShapeModule','EmissionModule','SizeModule','RotationModule','ColorModule','RotationBySpeedModule'}

    def visit(go,path,out):
        path=path+'/'+go.m_Name if path else go.m_Name
        objects=[p.component.deref() for p in go.m_Component]
        ps=next((o for o in objects if o.type.name=='ParticleSystem'),None)
        if ps:
            cfg=ps.read_typetree(check_read=False)
            enabled={k for k,v in cfg.items() if isinstance(v,dict) and v.get('enabled')}
            assert enabled<=allowed,(path,enabled-allowed)
            cfg={k:v for k,v in cfg.items() if not k.endswith('Module') or k in enabled}
            assert cfg['EmissionModule']['m_BurstCount']==0,path
            shape=cfg['ShapeModule'];assert shape['type'] in (6,10,12),path
            assert not shape['m_Mesh']['m_PathID'],path
            renderer=next(o for o in objects if o.type.name=='ParticleSystemRenderer').read()
            assert renderer.m_RenderMode==0 and renderer.m_RenderAlignment==0,path
            mat=renderer.m_Materials[0].read()
            shader_data=mat.m_Shader.deref().read_typetree(check_read=False)
            shader=shader_data.get('m_Name') or shader_data['m_ParsedForm']['m_Name']
            assert shader in ('Legacy Shaders/Particles/Additive','Legacy Shaders/Particles/Additive (Soft)','Sprites/Default'),shader
            material={'shader':shader,'colors':{},'order':renderer.m_SortingOrder,
                      'minSize':renderer.m_MinParticleSize,'maxSize':renderer.m_MaxParticleSize}
            for prop in shader_data['m_ParsedForm']['m_PropInfo']['m_Props']:
                if prop['m_Type']==0:
                    material['colors'][prop['m_Name']]=[prop['m_DefValue[%d]'%i] for i in range(4)]
            for name,color in mat.m_SavedProperties.m_Colors:
                material['colors'][name]=[color.r,color.g,color.b,color.a]
            for name,value in mat.m_SavedProperties.m_TexEnvs:
                if name!='_MainTex':continue
                tex=value.m_Texture.deref().read(check_read=False)
                key=str(value.m_Texture.path_id)
                if key not in textures:
                    image=get_image_from_texture2d(tex,False)
                    file=art/('particle_'+key+'.png');image.save(file)
                    textures[key]={'file':file.relative_to(ROOT).as_posix(),'size':list(image.size),
                        'sha256':hashlib.sha256(file.read_bytes()).hexdigest()}
                material.update(texture=key,scale=[value.m_Scale.x,value.m_Scale.y],offset=[value.m_Offset.x,value.m_Offset.y])
            cfg['renderer']=material;out[path]=cfg
        for obj in objects:
            if obj.type.name=='Transform':
                for child in obj.read().m_Children:visit(child.read().m_GameObject.read(),path,out)
    for name,pointer in manager.m_Container:
        if name in paths and pointer.deref().type.name=='GameObject':
            result={};visit(pointer.read(),'',result)
            if result:rows[paths[name]]=result
    target=ROOT/'mod/GAME/th38/release_particles.lua'
    target.write_text('-- 自机原始粒子组件；仅保留实际启用模块，来源见同名 JSON。\nreturn '+lua(dict(prefabs=rows,textures=textures))+'\n',encoding='utf8',newline='\n')
    hashes={name:hashlib.sha256((args.data/name).read_bytes()).hexdigest()
        for name in ['resources.assets','globalgamemanagers','Managed/UnityEngine.ParticleSystemModule.dll']}
    target.with_name('release_particles_sources.json').write_text(json.dumps(dict(source_sha256=hashes,
        systems=sum(map(len,rows.values())),textures=textures),ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('原作粒子组件',sum(map(len,rows.values())),'纹理',len(textures))


if __name__=='__main__':main()
