#!/usr/bin/env python3
"""从发行包补导七面标题 prefab 与原音效，不依赖旧 Unity 工程副本。"""
import argparse
import hashlib
from io import BytesIO
import json
import re
from pathlib import Path
import sys
sys.dont_write_bytecode=True

from UnityPy.classes import PPtr
import UnityPy
from UnityPy.export.Texture2DConverter import get_image_from_texture2d
import soundfile as sf
from release_source import Source

ROOT=Path(__file__).resolve().parents[2]


def lua(value):
    if isinstance(value,dict):return '{'+','.join('['+lua(k)+']='+lua(v) for k,v in value.items())+'}'
    if isinstance(value,list):return '{'+','.join(map(lua,value))+'}'
    if value is None:return 'nil'
    return json.dumps(value,ensure_ascii=False)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--data',type=Path,required=True)
    args=ap.parse_args();source=Source(args.data)
    output=ROOT/'mod/GAME/th38';art=ROOT/'Resources/th38/presentation';art.mkdir(exist_ok=True)
    hashes={};titles={};sounds={};sprites={};audio_prefabs={}
    supported={'Tongyong_death','Tongyong_jianxianjianyin','Tongyong_weiyi','Tongyong_suofang',
               'Tongyong_translate','Tongyong_xuanzhuan'}
    def record(file):hashes[str(file.relative_to(args.data))]=hashlib.sha256(file.read_bytes()).hexdigest()
    def node(go):
        result={'name':go.m_Name,'scripts':[],'children':[]}
        for pair in go.m_Component:
            obj=pair.component.deref()
            if obj.type.name=='Transform':
                t=obj.read();result['position']=[t.m_LocalPosition.x,t.m_LocalPosition.y,t.m_LocalPosition.z]
                result['scale']=[t.m_LocalScale.x,t.m_LocalScale.y,t.m_LocalScale.z]
                result['rotation']=[t.m_LocalRotation.x,t.m_LocalRotation.y,t.m_LocalRotation.z,t.m_LocalRotation.w]
                result['children']=[node(p.read().m_GameObject.read()) for p in t.m_Children]
            elif obj.type.name=='SpriteRenderer':
                r=obj.read();sprite=r.m_Sprite.read();name=sprite.m_Name
                # 此发行包的 Texture2D 尾部另有零填充；原图字段与流式像素完整保留。
                assert not sprite.m_SpriteAtlas and not sprite.m_RD.alphaTexture,name
                pointer=sprite.m_RD.texture
                texture=pointer.deref().read(check_read=False)
                sprite.assets_file._cache[pointer.path_id]=get_image_from_texture2d(texture,False)
                image=sprite.image;image.save(art/(name+'.png'))
                sprites[name]={'file':'Resources/th38/presentation/'+name+'.png',
                    'size':[sprite.m_Rect.width,sprite.m_Rect.height],'pivot':[sprite.m_Pivot.x,sprite.m_Pivot.y],
                    'ppu':sprite.m_PixelsToUnits}
                result['sprite']=name;result['color']=[r.m_Color.r,r.m_Color.g,r.m_Color.b,r.m_Color.a]
                result['order']=r.m_SortingOrder
            elif obj.type.name=='MonoBehaviour':
                name,_=source.script(obj);assert name in supported,(go.m_Name,name)
                fields=source.fields(obj)
                result['scripts'].append({'kind':name,**{k:v for k,v in fields.items() if not k.startswith('m_')}})
        return result
    scenes=source.scene_names()
    for stage in ['1','2','3','4','5','6','EXA']:
        file=scenes['Stage'+stage];level=source.load(file);record(args.data/file)
        for obj in level.objects.values():
            if obj.type.name!='MonoBehaviour' or source.script(obj)[0]!='Tong_creat':continue
            fields=source.fields(obj);go=PPtr(**fields['obj'],assetsfile=obj.assets_file).read()
            if go.m_Name.startswith('guanqia_name'):
                titles[stage]={'time':fields['creat_time'],'root':node(go)}
    manager=source.load('globalgamemanagers')
    manager=next(o for o in manager.objects.values() if o.type.name=='ResourceManager').read()
    prefabs=set(re.findall(r'\["(Resources/[^"\n]+\.prefab)"\]=',
        (output/'native_players/data.lua').read_text(encoding='utf8')))
    prefab_paths={p.removeprefix('Resources/').removesuffix('.prefab').lower():p for p in prefabs}
    def audio_nodes(go,path,rows):
        path=path+'/'+go.m_Name if path else go.m_Name
        for pair in go.m_Component:
            obj=pair.component.deref()
            if obj.type.name=='AudioSource':
                cfg=obj.read();clip=cfg.m_audioClip.read().m_Name if cfg.m_audioClip else None
                rows[path]={'clip':clip,'volume':cfg.m_Volume,'pitch':cfg.m_Pitch,'loop':cfg.Loop,
                            'awake':cfg.m_PlayOnAwake,'mute':cfg.Mute}
            elif obj.type.name=='Transform':
                for child in obj.read().m_Children:audio_nodes(child.read().m_GameObject.read(),path,rows)
    for path,pointer in manager.m_Container:
        if path in prefab_paths and pointer.deref().type.name=='GameObject':
            rows={};audio_nodes(pointer.read(),'',rows)
            if rows:audio_prefabs[prefab_paths[path]]=rows
    audio_env=UnityPy.load(str(args.data/'resources.assets'))
    clips={o.path_id:o for o in audio_env.objects if o.type.name=='AudioClip'}
    for path,pointer in manager.m_Container:
        if not path.startswith('xuelianhua/sound/'):continue
        obj=pointer.deref()
        if obj.type.name!='AudioClip':continue
        assert obj.assets_file.name=='resources.assets',path
        clip=clips[obj.path_id].read()
        try:decoded=clip.samples
        except Exception as error:raise RuntimeError('无法解码原音效：'+path+' / '+clip.m_Name) from error
        assert len(decoded)==1,(path,list(decoded))
        samples,rate=sf.read(BytesIO(next(iter(decoded.values()))),dtype='int16',always_2d=True)
        name=clip.m_Name;target=art/(name+'.flac')
        sf.write(target,samples,rate,subtype='PCM_16')
        check,actual=sf.read(target,dtype='int16',always_2d=True)
        assert actual==rate and (check==samples).all(),path
        sounds[name]={'file':target.relative_to(ROOT).as_posix(),'resource':path,'rate':rate,
                      'samples':len(samples),'pcm_sha256':hashlib.sha256(samples.tobytes()).hexdigest()}
    for file in ['globalgamemanagers','resources.assets','Managed/Assembly-CSharp.dll']:
        record(args.data/file)
    (output/'release_presentation.lua').write_text('-- 发行包中的标题节点、组件参数与音效；来源见同名 JSON。\nreturn '+lua(dict(titles=titles,sprites=sprites,sounds=sounds,audioPrefabs=audio_prefabs))+'\n',encoding='utf8',newline='\n')
    (output/'release_presentation_sources.json').write_text(json.dumps(dict(source_sha256=hashes,
        titles=len(titles),sprites=len(sprites),sounds=sounds),ensure_ascii=False,indent=2)+'\n',encoding='utf8',newline='\n')
    print('标题',len(titles),'切片',len(sprites),'原音效',len(sounds))


if __name__=='__main__':main()
