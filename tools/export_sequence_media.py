#!/usr/bin/env python3
"""导出五作顺序流程的STD原始模型/镜头与原曲；音乐压成Ogg并保留采样精确循环点。"""
import argparse
import hashlib
import io
import importlib.util
import json
from pathlib import Path
import struct
import subprocess
import wave
import soundfile as sf

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('anm_export',ROOT/'tools/th3x-tests/export_original_anm.py')
anm=importlib.util.module_from_spec(spec);spec.loader.exec_module(anm)

def game_root(root,game):
    code='th095' if game==95 else f'th{game:02}'
    matches=[p for p in root.iterdir() if p.is_dir() and p.name.startswith('['+code+']')]
    assert len(matches)==1,(game,matches)
    directory=matches[0]/'th06' if game==6 else matches[0]
    if game!=6 and not (directory/'thbgm.dat').exists():
        directory=next(directory.rglob('thbgm.dat')).parent
    return directory

def export_std(path,game):
    data=path.read_bytes();count,_,instances_offset,script_offset=struct.unpack_from('<HHII',data)
    modern=game in (95,10);header=0x90 if modern else 0x490
    objects=[]
    for offset in struct.unpack_from('<'+'I'*count,data,header):
        ident,layer,flags,*bounds=struct.unpack_from('<HBB6f',data,offset)
        cursor=offset+28;quads=[]
        while True:
            kind,size,script,_=struct.unpack_from('<hHHH',data,cursor)
            if kind<0:break
            assert (kind,size) in ((0,28),(1,36)),(path,cursor,kind,size)
            if kind==0:quads.append([script,*struct.unpack_from('<5f',data,cursor+8)])
            else:
                x,y,z,ex,ey,ez,width=struct.unpack_from('<7f',data,cursor+8)
                quads.append({'script':script,'start':[x,y,z],'end':[ex,ey,ez],'width':width})
            cursor+=size
        objects.append(dict(id=ident,layer=layer,bounds=bounds,quads=quads))
    instances=[];cursor=instances_offset
    while True:
        ident,_,x,y,z=struct.unpack_from('<hH3f',data,cursor)
        if ident<0:break
        assert ident<len(objects),(path,ident)
        instances.append([ident+1,x,y,z]);cursor+=16
    commands=[];addresses={};cursor=script_offset
    while cursor+8<=len(data):
        time,op,size=struct.unpack_from('<ihH',data,cursor)
        if size==65535:break
        payload=data[cursor+8:cursor+(size if modern else size+8)]
        assert len(payload)%4==0,(path,cursor,size)
        ints=list(struct.unpack('<'+'i'*(len(payload)//4),payload))
        floats=list(struct.unpack('<'+'f'*(len(payload)//4),payload))
        if modern:
            formats={0:'',1:'ii',2:'fff',3:'iifff',4:'fff',5:'iifff',6:'fff',7:'f',8:'iff',9:'iiiff',
                     10:'iifffffffff',11:'iifffffffff',12:'i',13:'i',14:'ii'}
        elif game==6:
            formats={0:'fff',1:'iff',2:'fff',3:'i',4:'i',5:'i'}
        else:
            formats={0:'fff',1:'iff',2:'i',3:'i',4:'ii',5:'fff',6:'ii',7:'fff',8:'ii',9:'fff',10:'ii',
                     11:'f',12:'ii',13:'i',18:'i',23:'i',28:'i',29:'i',30:'i',31:'i',32:'fff',33:'i',34:'i'}
            for o in (14,15,16,17,19,20,21,22,24,25,26,27):formats[o]='fff'
        fmt=formats[op];assert len(payload)>=4*len(fmt),(path,cursor,op,size,fmt)
        args=[floats[i] if t=='f' else ints[i] for i,t in enumerate(fmt)]
        addresses[cursor-script_offset]=len(commands)+1
        commands.append([time,op,*args]);cursor+=(size if modern else size+8)
    for c in commands:
        if modern and c[1]==1:c[2]=addresses[c[2]]
        elif not modern and game!=6 and c[1]==4:c[2]+=1
    archive=data[16:144].split(b'\0')[0].decode('ascii').removeprefix('data/').removesuffix('.anm') if modern else 'stg'+path.stem.removeprefix('stage')+'bg'
    # 永夜抄四面共用stg4abg；魔理沙路线只替换敌机/文字层。
    if game==8 and archive=='stg4bbg':archive='stg4abg'
    result=dict(game=game,archive=archive,objects=objects,instances=instances,commands=commands,
                sha256=hashlib.sha256(data).hexdigest())
    if not modern:
        result['music']=[data[16+5*128+i*128:16+6*128+i*128].split(b'\0')[0].decode('ascii').strip().removeprefix('bgm/').removesuffix('.mid') for i in range(4)]
    return result

def export_music(root,game,needed,cache,thdat,compression_level=.75,output_root=ROOT):
    directory=game_root(root,game);tracks=[]
    if game==6:
        pos_cache=cache/'th06';pos_cache.mkdir(parents=True,exist_ok=True)
        subprocess.run([str(thdat),'-C',str(pos_cache),'-x','6',str(directory/'紅魔郷MD.DAT'),
                        *[name+'.pos' for name in sorted(needed)]],check=True,stdout=subprocess.DEVNULL)
        for name in sorted(needed):
            path=directory/'bgm'/(name+'.wav')
            with wave.open(str(path)) as w:
                channels,rate,bits=w.getnchannels(),w.getframerate(),w.getsampwidth()*8
                samples=w.readframes(w.getnframes())
            start,end=struct.unpack('<II',(pos_cache/(name+'.pos')).read_bytes())
            tracks.append((name,channels,rate,bits,samples,start,end))
    else:
        fmt=(directory/'data/thbgm.fmt').read_bytes()
        with (directory/'thbgm.dat').open('rb') as bank:
            for offset in range(0,len(fmt)-51,52):
                name=fmt[offset:offset+16].split(b'\0')[0].decode('ascii').removesuffix('.wav')
                if name not in needed:continue
                begin,_,intro,length=struct.unpack_from('<IIII',fmt,offset+16)
                encoding,channels,rate,byte_rate,align,bits=struct.unpack_from('<HHIIHH',fmt,offset+32)
                assert encoding==1 and byte_rate==rate*align and align==channels*bits//8
                bank.seek(begin);samples=bank.read(length);assert len(samples)==length
                tracks.append((name,channels,rate,bits,samples,intro//align,length//align))
    assert len(tracks)==len(needed),(game,needed,{t[0] for t in tracks})
    manifest={}
    for name,channels,rate,bits,samples,start,end in tracks:
        align=channels*bits//8;assert 0<=start<end<=len(samples)//align,(name,start,end,len(samples)//align)
        output=output_root/'music'/('ORIG_'+name+'.ogg')
        output.parent.mkdir(parents=True,exist_ok=True)
        raw=io.BytesIO()
        with wave.open(raw,'wb') as wav:
            wav.setnchannels(channels);wav.setsampwidth(bits//8);wav.setframerate(rate);wav.writeframes(samples[:end*align])
        pcm,_=sf.read(io.BytesIO(raw.getvalue()),dtype='float32',always_2d=True)
        # libsndfile的Vorbis编码器不能一次接收整首长曲；分块写入，尾部采样数仍精确保留。
        with sf.SoundFile(output,'w',samplerate=rate,channels=channels,format='OGG',subtype='VORBIS',compression_level=compression_level) as ogg:
            for i in range(0,len(pcm),8192):ogg.write(pcm[i:i+8192])
        info=sf.info(output)
        assert info.frames==end and info.samplerate==rate and info.channels==channels,(name,info)
        manifest[name]=dict(rate=rate,channels=channels,loop_start=start,loop_end=end,
            pcm_bytes=end*align,ogg_bytes=output.stat().st_size,pcm_sha256=hashlib.sha256(samples[:end*align]).hexdigest(),
            ogg_sha256=hashlib.sha256(output.read_bytes()).hexdigest())
        manifest[name]['vorbis_compression_level']=compression_level
        print(name,round(output.stat().st_size/1024),'KiB',flush=True)
    return manifest

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path)
    p.add_argument('--cache',type=Path,default=Path('/tmp/bossrush-sequence-media'))
    p.add_argument('--thdat',default='thdat',help='thtk的原生thdat可执行文件，用于红魔乡循环点')
    p.add_argument('--background-only',action='store_true')
    p.add_argument('--music-only',action='store_true',help='只重导现有曲目，不改背景和曲库')
    p.add_argument('--compression-level',type=float,default=.75,help='Vorbis压缩强度，0优先质量、1优先体积；默认0.75')
    p.add_argument('--output-root',type=Path,default=ROOT,help='可先导出到独立目录评估包体')
    a=p.parse_args();a.cache.mkdir(parents=True,exist_ok=True)
    if not 0<=a.compression_level<=1:p.error('--compression-level必须在0..1范围内')
    if a.music_only and a.background_only:p.error('--music-only与--background-only不能同时使用')
    dest=a.output_root/'mod/GAME/original/std';dest.mkdir(parents=True,exist_ok=True)
    catalog={};manifest={};tracks={}
    if a.music_only:
        previous=json.loads((ROOT/'mod/GAME/original/std/music.json').read_text())
        for name in previous:
            game=6 if name.startswith('th06') else 7 if name.startswith('th07') else 8 if name.startswith('th08') else 10 if name.startswith('th10') else 95
            tracks.setdefault(game,set()).add(name)
    for game in (() if a.music_only else (6,7,8,95,10)):
        catalog[game]={};needed=set()
        for path in sorted((game_root(a.source,game)/'data').glob('*.std')):
            if '_s' in path.stem:continue
            data=export_std(path,game);catalog[game][path.stem]=data
            (dest/(str(game)+'_'+path.stem+'.lua')).write_text('-- 原作STD模型、实例和镜头指令；由tools/export_sequence_media.py导出。\nreturn '+anm.lua(data)+'\n')
            needed.update(m for m in data.get('music',[]) if m)
        if game==7:needed.add('th07_13b')
        if game==10:needed={f'th10_{i:02}' for i in range(17)}-{ 'th10_02','th10_13','th10_14' }
        if game==95:needed={f'th095_{i:02}' for i in range(1,5)}|{'th09_08_2'}
        tracks[game]=needed
    if not a.background_only:
        for game,needed in tracks.items():manifest.update(export_music(a.source,game,needed,a.cache,a.thdat,a.compression_level,a.output_root))
        if a.music_only:
            for name,m in manifest.items():
                for key in ('rate','channels','loop_start','loop_end','pcm_sha256'):
                    assert m[key]==previous[name][key],(name,key,'原始PCM或循环点改变')
        (dest/'music.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
        (dest/'music.lua').write_text('-- 原作PCM采样点换算为秒，播放器使用终点及循环长度。\nreturn '+anm.lua(manifest)+'\n')
    print('STD',sum(map(len,catalog.values())),'原曲',len(manifest))

if __name__=='__main__':main()
