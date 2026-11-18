#!/usr/bin/env python3
"""核对顺序发行包的实际Lua与原曲字节、完整Ogg解码及原作循环点。"""
from pathlib import Path
import argparse
import io
import json
import sys
import zipfile
import soundfile as sf
from verify_release import inputs
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'android'))
from asset_policy import include_asset

def check(package,root,decode,compact_music=False):
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
        original_music_exact=True
        for name,m in manifest.items():
            relative='music/ORIG_'+name+'.ogg';payload=z.read(prefix+relative)
            exact=payload==(root/relative).read_bytes()
            original_music_exact=original_music_exact and exact
            assert exact or compact_music,relative
            with sf.SoundFile(io.BytesIO(payload)) as audio:
                assert (audio.frames,audio.samplerate,audio.channels)==(m['loop_end'],m['rate'],m['channels']),relative
                if decode:
                    count=0
                    for block in audio.blocks(blocksize=32768):count+=len(block)
                    assert count==m['loop_end'],relative
        native_music=0
        music_folders=('music','Resources/ports/theis/res/music',
            'Resources/ports/dreamer/res/likedreamer/bgm','Resources/th43/music') if compact_music else ('Resources/ports/theis/res/music',)
        sources=[p for folder in music_folders for p in sorted((root/folder).glob('*.ogg'))
                 if include_asset(p.relative_to(root)) and not p.name.startswith('ORIG_')]
        for source in sources:
            relative=source.relative_to(root).as_posix()
            original=sf.info(source)
            with sf.SoundFile(io.BytesIO(z.read(prefix+relative))) as audio:
                assert (audio.frames,audio.samplerate,audio.channels)==(
                    original.frames,original.samplerate,original.channels),relative
                if decode:
                    count=sum(len(block) for block in audio.blocks(blocksize=32768))
                    assert count==original.frames,relative
            native_music+=1
        return {'package':package.name,'lua_files':scripts,'original_tracks':len(manifest),
            'native_tracks':native_music,
            'full_ogg_decode':decode,'loop_frames_unchanged':True,'source_bytes_match':original_music_exact,
            'source_scripts_match':True,'original_music_bytes_match':original_music_exact}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('package',type=Path)
    p.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1]);p.add_argument('--decode',action='store_true')
    p.add_argument('--compact-music',action='store_true',help='允许BGM重编码，并核对全部曲目的帧数、采样率和声道')
    p.add_argument('--output',type=Path);a=p.parse_args();report=check(a.package,a.root,a.decode,a.compact_music)
    if a.output:a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(report,ensure_ascii=False))

if __name__=='__main__':main()
