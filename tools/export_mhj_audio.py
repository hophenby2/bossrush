#!/usr/bin/env python3
"""读取原作 XACT cue 和波形，导出无损 FLAC；原目录只读。"""
import argparse
import hashlib
import io
import json
import math
from pathlib import Path
import struct

import soundfile as sf

ROOT = Path(__file__).resolve().parents[1]


def lua(value):
    if isinstance(value, dict):
        return '{'+','.join('['+json.dumps(str(k))+']='+lua(v) for k,v in value.items())+'}'
    if isinstance(value, list):
        return '{'+','.join(map(lua, value))+'}'
    return json.dumps(value, ensure_ascii=False)


def volume(value):
    # XACT 压缩音量的换算见 MonoGame Audio/Xact/XactHelpers.cs。
    db=(-96-67.7385212334047)/(1+(value/80.1748600297963)**0.432254984608615)+67.7385212334047
    return 10**(db/20)


def export(content, number):
    wave=(content/'Sound/02.xna').read_bytes()
    bank=(content/'Sound/03.xna').read_bytes()
    assert wave[:4]==b'WBND' and bank[:4]==b'SDBK'
    segments=[struct.unpack_from('<II',wave,12+8*i) for i in range(5)]
    at=segments[0][0]
    flags,count=struct.unpack_from('<II',wave,at)
    assert not flags & 0x20000, '不支持紧凑波形表'
    stride=struct.unpack_from('<I',wave,at+72)[0]
    assert stride==24
    destination=ROOT/f'Resources/th{number}/sound'
    destination.mkdir(parents=True,exist_ok=True)
    waves=[]
    for index in range(count):
        duration,fmt,offset,length,loop_start,loop_length=struct.unpack_from('<6I',wave,segments[1][0]+index*stride)
        codec,channels,rate,align,bits=fmt&3,(fmt>>2)&7,(fmt>>5)&0x3ffff,(fmt>>23)&255,16 if fmt>>31 else 8
        pcm=wave[segments[4][0]+offset:segments[4][0]+offset+length]
        assert len(pcm)==length
        if codec==2:
            block=(align+22)*channels
            samples=(block//channels-7)*2+2
            coefficients=[256,0,512,-256,0,0,192,64,240,0,460,-208,392,-232]
            header=struct.pack('<HHIIHHHHH14h',2,channels,rate,rate*block//samples,block,4,32,samples,7,*coefficients)
        else:
            assert codec==0,codec
            header=struct.pack('<HHIIHH',1,channels,rate,rate*channels*bits//8,channels*bits//8,bits)
        fact=struct.pack('<4sII',b'fact',4,duration>>4)
        chunks=struct.pack('<4sI',b'fmt ',len(header))+header+fact+struct.pack('<4sI',b'data',len(pcm))+pcm
        raw=b'RIFF'+struct.pack('<I',len(chunks)+4)+b'WAVE'+chunks
        samples,decoded_rate=sf.read(io.BytesIO(raw),dtype='int16',always_2d=True)
        assert decoded_rate==rate
        # XACT 的时长不包含块尾填充样本。
        assert len(samples)>=duration>>4,(index,len(samples),duration>>4)
        samples=samples[:duration>>4]
        file=destination/f'{index:03}.flac'
        sf.write(file,samples,rate,format='FLAC',subtype='PCM_16')
        actual,_=sf.read(file,dtype='int16',always_2d=True)
        assert (actual==samples).all(), 'FLAC 回读与解码 PCM 不同'
        waves.append(dict(path=file.relative_to(ROOT).as_posix(),duration=len(samples)/rate,
                          samples=len(samples),rate=rate,channels=channels,
                          pcm_sha256=hashlib.sha256(samples.tobytes()).hexdigest(),loop=[loop_start,loop_length]))
    simple,complex_count=struct.unpack_from('<HH',bank,19)
    assert complex_count==0
    name_length=struct.unpack_from('<H',bank,30)[0]
    offsets=struct.unpack_from('<10I',bank,34)
    names=bank[offsets[2]:offsets[2]+name_length].split(b'\0')
    cues={}
    for index in range(simple):
        position=struct.unpack_from('<I',bank,offsets[0]+index*5+1)[0]
        sound_flags,category,vol,pitch=struct.unpack_from('<BH Bh',bank,position)
        gain=volume(vol)
        repeat=0
        pitch_min=pitch_max=pitch/1000
        if sound_flags & 1:
            assert bank[position+9]==1
            gain*=volume(bank[position+10])
            event=struct.unpack_from('<I',bank,position+11)[0]
            assert bank[event]==1
            info=struct.unpack_from('<I',bank,event+1)[0]
            assert info&31 in (1,4) and (info>>5)&0xffff==0
            track,wave_bank,repeat=struct.unpack_from('<HBB',bank,event+9)
            if info&31==4:
                pitch_min,pitch_max=(n/1000 for n in struct.unpack_from('<hh',bank,event+17))
                assert bank[event+40]&0x10
        else:
            track,wave_bank=struct.unpack_from('<HB',bank,position+9)
        assert wave_bank==0
        cues[names[index].decode('utf-8')]=dict(wave=track,volume=gain,pitch=[pitch_min,pitch_max],repeat=repeat,category=category)
    result=dict(waves=waves,cues=cues)
    target=ROOT/f'mod/GAME/th{number}/sounds.lua'
    target.write_text('-- 原始 XACT cue 与无损波形；由 tools/export_mhj_audio.py 导出。\nreturn '+lua(result)+'\n',encoding='utf-8')
    manifest=dict(source_sha256={str(content/'Sound/02.xna'):hashlib.sha256(wave).hexdigest(),
                                str(content/'Sound/03.xna'):hashlib.sha256(bank).hexdigest()},**result)
    (target.parent/'sound_sources.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(number,'波形',len(waves),'cue',len(cues))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--spring',type=Path,required=True)
    parser.add_argument('--night',type=Path,required=True)
    args=parser.parse_args()
    export(args.spring,37)
    export(args.night,39)
