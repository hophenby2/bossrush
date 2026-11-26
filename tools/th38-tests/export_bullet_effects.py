#!/usr/bin/env python3
"""只读导出雪莲华发行版的消弹动画、八色蓄力和八色爆发 prefab。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
sys.dont_write_bytecode=True
from UnityPy.classes import PPtr
from UnityPy.export.Texture2DConverter import get_image_from_texture2d
from UnityPy.export.SpriteHelper import MeshHandler
from release_source import Source
from export_release_presentation import lua

ROOT=Path(__file__).resolve().parents[2]


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--data',type=Path,required=True)
    args=ap.parse_args();source=Source(args.data)
    art=ROOT/'Resources/th38/bullet_effects';art.mkdir(exist_ok=True)
    sprites,textures,prefabs,sprite_sources={},{},{},{}
    manager=source.load('globalgamemanagers')
    manager=next(o for o in manager.objects.values() if o.type.name=='ResourceManager').read()
    def sprite(pointer):
        key=str(pointer.path_id)
        if key in sprites:return key
        s=pointer.read();tex=s.m_RD.texture
        assert not s.m_SpriteAtlas and not s.m_RD.alphaTexture,key
        s.assets_file._cache[tex.path_id]=get_image_from_texture2d(tex.deref().read(check_read=False),False)
        im=s.image;file=art/('sprite_'+key+'.png');im.save(file,optimize=True)
        # 发行图集使用 Tight Mesh，解包图的大小不是 m_Rect；中心取实际网格边界。
        mesh=MeshHandler(s.m_RD,s.object_reader.version);mesh.process()
        if mesh.m_UV0 and any(u or v for u,v in mesh.m_UV0):
            px=-min(v[0] for v in mesh.m_Vertices)*s.m_PixelsToUnits
            py=max(v[1] for v in mesh.m_Vertices)*s.m_PixelsToUnits
        else:
            px=s.m_Rect.width*s.m_Pivot.x-s.m_RD.textureRectOffset.x
            py=im.height-(s.m_Rect.height*s.m_Pivot.y-s.m_RD.textureRectOffset.y)
        sprites[key]={'file':file.relative_to(ROOT).as_posix(),'size':list(im.size),
                      'center':[px,py],'ppu':s.m_PixelsToUnits}
        sprite_sources[key]={'name':s.m_Name,'texture':tex.path_id,'rect':{k:getattr(s.m_Rect,k) for k in ('x','y','width','height')},
                             'sha256':hashlib.sha256(file.read_bytes()).hexdigest()}
        return key
    def material(pointer):
        mat=pointer.read();shader=mat.m_Shader.deref().read_typetree(check_read=False)
        name=shader.get('m_Name') or shader['m_ParsedForm']['m_Name']
        assert name in ('Sprites/Default','Legacy Shaders/Particles/Additive','Legacy Shaders/Particles/Additive (Soft)'),name
        colors={}
        for prop in shader['m_ParsedForm']['m_PropInfo']['m_Props']:
            if prop['m_Type']==0:colors[prop['m_Name']]=[prop['m_DefValue[%d]'%i] for i in range(4)]
        for key,c in mat.m_SavedProperties.m_Colors:colors[key]=[c.r,c.g,c.b,c.a]
        out={'shader':name,'colors':colors}
        for key,value in mat.m_SavedProperties.m_TexEnvs:
            if key!='_MainTex' or not value.m_Texture.path_id:continue
            key=str(value.m_Texture.path_id)
            if key not in textures:
                t=value.m_Texture.deref().read(check_read=False);im=get_image_from_texture2d(t,False)
                file=art/('texture_'+key+'.png');im.save(file,optimize=True)
                textures[key]={'file':file.relative_to(ROOT).as_posix(),'size':list(im.size)}
            out.update(texture=key,scale=[value.m_Scale.x,value.m_Scale.y],offset=[value.m_Offset.x,value.m_Offset.y])
        return out
    supported={'Tongyong_death','Tongyong_suofang','Tongyong_jianxianjianyin','Soundyinliangkongzhi','Xiaodan'}
    def node(go):
        out={'name':go.m_Name,'scripts':[],'children':[]}
        objects=[c.component.deref() for c in go.m_Component]
        for o in objects:
            if o.type.name=='Transform':
                t=o.read();out.update(position=[t.m_LocalPosition.x,t.m_LocalPosition.y],
                    scale=[t.m_LocalScale.x,t.m_LocalScale.y],rotation=[t.m_LocalRotation.z,t.m_LocalRotation.w])
                out['children']=[node(p.read().m_GameObject.read()) for p in t.m_Children]
            elif o.type.name=='SpriteRenderer':
                r=o.read();out.update(sprite=sprite(r.m_Sprite),color=[r.m_Color.r,r.m_Color.g,r.m_Color.b,r.m_Color.a],
                    order=r.m_SortingOrder,material=material(r.m_Materials[0]))
            elif o.type.name=='MonoBehaviour':
                name,_=source.script(o);assert name in supported,(go.m_Name,name)
                out['scripts'].append({'kind':name,**{k:v for k,v in source.fields(o).items() if not k.startswith('m_')}})
            elif o.type.name=='AudioSource':
                a=o.read();assert not a.Loop
                out['audio']={'clip':a.m_audioClip.read().m_Name,'volume':a.m_Volume,'playOnAwake':a.m_PlayOnAwake}
            elif o.type.name=='ParticleSystem':
                cfg=o.read_typetree(check_read=False)
                allowed={'InitialModule','ShapeModule','EmissionModule','RotationModule','ColorModule'}
                enabled={k for k,v in cfg.items() if k.endswith('Module') and v.get('enabled')}
                assert enabled<=allowed,(go.m_Name,enabled-allowed)
                cfg={k:v for k,v in cfg.items() if not k.endswith('Module') or k in enabled}
                assert cfg['ShapeModule']['type']==10 and cfg['EmissionModule']['m_BurstCount']==0
                r=next(x for x in objects if x.type.name=='ParticleSystemRenderer').read()
                assert r.m_RenderMode==0 and r.m_RenderAlignment==0
                cfg['renderer']={**material(r.m_Materials[0]),'order':r.m_SortingOrder,
                                 'minSize':r.m_MinParticleSize,'maxSize':r.m_MaxParticleSize}
                out['particles']=cfg
            elif o.type.name=='Animator':
                a=o.read();clips=a.m_Controller.read().m_AnimationClips
                assert len(clips)==1
                c=clips[0].deref();d=c.read_typetree(check_read=False)
                binding=d['m_ClipBindingConstant'];assert len(binding['genericBindings'])==1
                assert binding['genericBindings'][0]['isPPtrCurve']==1
                mapping=[sprite(PPtr(**p,assetsfile=c.assets_file)) for p in binding['pptrCurveMapping']]
                stream=d['m_MuscleClip']['m_Clip']['data']['m_StreamedClip']
                raw=struct.pack('<'+'I'*len(stream['data']),*stream['data']);at=0;keys=[]
                while at<len(raw):
                    time,count=struct.unpack_from('<fI',raw,at);at+=8
                    for _ in range(count):
                        index,*coeff=struct.unpack_from('<I4f',raw,at);at+=20
                        assert index==0 and coeff[:3]==[0,0,0]
                        keys.append([max(0,time),mapping[int(coeff[3])]])
                out['animation']=keys
            elif o.type.name!='ParticleSystemRenderer':raise ValueError((go.m_Name,o.type.name))
        return out
    keys={'xuelianhua/prefab/xiaodantexiao'}
    keys|={f'xuelianhua/prefab/enemy/xuli_texiao/{name}_{i}' for name in ('xuli','baozha') for i in range(8)}
    for key,pointer in manager.m_Container:
        if key in keys and pointer.deref().type.name=='GameObject':prefabs[key.rsplit('/',1)[-1]]=node(pointer.read())
    assert len(prefabs)==17,len(prefabs)
    ilspy=shutil.which('ilspycmd') or str(Path.home()/'.dotnet/tools/ilspycmd')
    def script(name):return subprocess.run([ilspy,'-t',name,str(args.data/'Managed/Assembly-CSharp.dll')],check=True,capture_output=True,text=True).stdout
    xiaodan,sincos=script('Xiaodan'),script('Sincos')
    life=int(re.search(r'private int time = (\d+);',xiaodan).group(1))
    limit=int(re.search(r'endbullet_chi = new GameObject\[(\d+)\]',sincos).group(1))
    data={'prefabs':prefabs,'sprites':sprites,'textures':textures,'endLife':life,'endLimit':limit}
    output=ROOT/'mod/GAME/th38'
    (output/'bullet_effects_data.lua').write_text('-- 发行包消弹动画和八色蓄力/爆发组件；由 export_bullet_effects.py 生成。\nreturn '+lua(data)+'\n')
    hashes={name:hashlib.file_digest((args.data/name).open('rb'),'sha256').hexdigest()
            for name in ('globalgamemanagers','resources.assets','resources.assets.resS','Managed/Assembly-CSharp.dll')}
    (output/'bullet_effects_sources.json').write_text(json.dumps({'source_sha256':hashes,
        'resources':sorted(keys),'sprites':sprite_sources,'end_life':life,'end_limit':limit},ensure_ascii=False,indent=2)+'\n')
    print('导出',len(prefabs),'个原特效 prefab，',len(sprites),'张精灵，',len(textures),'张粒子纹理；消弹寿命',life)


if __name__=='__main__':main()
