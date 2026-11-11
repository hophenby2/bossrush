#!/usr/bin/env python3
"""从五作原始音效表与PCM导入完整SoundIdx，保留原音量和优先级。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
def metadata(workspace,originals,game):
    folder='th095' if game==95 else f'th{game:02}'
    if game==10:
        origin=next(p for p in originals.iterdir() if p.is_dir() and p.name.startswith('[th10]'))
        raw=(origin/'th10.exe').read_bytes();pe=struct.unpack_from('<I',raw,0x3c)[0]
        count=struct.unpack_from('<H',raw,pe+6)[0];section=pe+24+struct.unpack_from('<H',raw,pe+20)[0]
        rva=0x4749c8-0x400000
        for i in range(count):
            size,va,_,pointer=struct.unpack_from('<IIII',raw,section+40*i+8)
            if va<=rva<va+size:offset=pointer+rva-va;break
        else:raise ValueError('TH10原版音效表不存在')
        records=[struct.unpack_from('<ihh',raw,offset+i*8) for i in range(47)]
        code=(workspace/folder/'src/Sound.cpp').read_text()
        block=re.search(r'g_SoundFileNames\[37\]\s*=\s*\{(.*?)\};',code,re.S)[1]
    else:
        source=workspace/folder/'src'
        if game==7:source=source/'th07'
        code=(source/'SoundPlayer.cpp').read_text()
        block=re.search(r'(?:g_SoundBufferIdxVol|SOUND_BUFFER_IDX_VOL)[^=]*=\s*\{(.*?)\};',code,re.S)[1]
        records=[tuple(map(int,m)) for m in re.findall(r'\{\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}',block)]
        block=re.search(r'g_SFXList[^=]*=\s*\{(.*?)\};',code,re.S)[1]
    names=[Path(n).name for n in re.findall(r'"([^"]+\.wav)"',block)]
    assert records and names
    assert all(0<=r[0]<len(names) and -10000<=r[1]<=0 for r in records)
    return [(names[i],volume,priority) for i,volume,priority in records]

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--workspace',type=Path,required=True)
    p.add_argument('--originals',type=Path,required=True)
    p.add_argument('--thdat',type=Path,required=True)
    a=p.parse_args();lines=['-- 原作SoundIdx、PCM、DirectSound音量和优先级；由export_sequence_sounds.py导出。','return {'];evidence=[]
    for game in [6,7,8,95,10]:
        records=metadata(a.workspace,a.originals,game)
        prefix='[th095]' if game==95 else f'[th{game:02}]'
        source=next(p for p in a.originals.iterdir() if p.is_dir() and p.name.startswith(prefix))
        dest=ROOT/'Resources/OriginalAudio'/str(game);dest.mkdir(exist_ok=True,parents=True)
        with tempfile.TemporaryDirectory(prefix='bossrush-se-') as temp:
            if game==6:
                archive=next(source.rglob('紅魔郷IN.DAT'))
                subprocess.run([str(a.thdat),'-C',temp,'-x','6',str(archive),*sorted({r[0] for r in records})],check=True,capture_output=True)
                wave=Path(temp)
            else:wave=source/'data'
            lines.append(f'    [{game}]={{')
            for index,(name,volume,priority) in enumerate(records):
                raw=(wave/name).read_bytes();assert raw[:4]==b'RIFF' and raw[8:12]==b'WAVE'
                (dest/name).write_bytes(raw)
                path=(dest/name).relative_to(ROOT).as_posix()
                lines.append(f'        [{index}]={{"{path}",{volume},{priority}}},')
                evidence.append(dict(game=game,id=index,path=path,volume=volume,priority=priority,sha256=hashlib.sha256(raw).hexdigest()))
            lines.append('    },')
    lines.append('}')
    (ROOT/'mod/GAME/original/sounds.lua').write_text('\n'.join(lines)+'\n')
    (ROOT/'mod/GAME/original/sequence_sounds_manifest.json').write_text(json.dumps(evidence,ensure_ascii=False,indent=2)+'\n')
    print('原作音效表',len(evidence),'项')
if __name__=='__main__':main()
