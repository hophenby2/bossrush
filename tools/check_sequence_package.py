#!/usr/bin/env python3
"""核对顺序发行包的实际Lua与原曲字节、完整Ogg解码及原作循环点。"""
from pathlib import Path
import argparse
import io
import json
import zipfile
import soundfile as sf
from verify_release import inputs

def check(package,root,decode):
    with zipfile.ZipFile(package) as z:
        assert z.testzip() is None,'发行包CRC错误'
        prefix=next(n[:-len('core.lua')] for n in z.namelist() if n.endswith('/core.lua'))
        android=prefix=='assets/game/'
        scripts=0
        for path in inputs(root):
            if path.suffix!='.lua':continue
            name=path.relative_to(root).as_posix();source=path.read_bytes();payload=z.read(prefix+name)
            if android:
                source=source.decode('utf-8-sig').replace('\r\n','\n').encode()
            assert payload==source,'发行包脚本与源码不一致：'+name
            scripts+=1
        manifest=json.loads((root/'mod/GAME/original/std/music.json').read_text())
        for name,m in manifest.items():
            relative='music/ORIG_'+name+'.ogg';payload=z.read(prefix+relative)
            assert payload==(root/relative).read_bytes(),relative
            with sf.SoundFile(io.BytesIO(payload)) as audio:
                assert (audio.frames,audio.samplerate,audio.channels)==(m['loop_end'],m['rate'],m['channels']),relative
                if decode:
                    count=0
                    for block in audio.blocks(blocksize=32768):count+=len(block)
                    assert count==m['loop_end'],relative
        return {'package':package.name,'lua_files':scripts,'original_tracks':len(manifest),
            'full_ogg_decode':decode,'loop_frames_unchanged':True,'source_bytes_match':True}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('package',type=Path)
    p.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1]);p.add_argument('--decode',action='store_true')
    p.add_argument('--output',type=Path);a=p.parse_args();report=check(a.package,a.root,a.decode)
    if a.output:a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(report,ensure_ascii=False))

if __name__=='__main__':main()
