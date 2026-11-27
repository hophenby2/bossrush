#!/usr/bin/env python3
"""核对Windows压缩包的实际资源、原生字体依赖和完整引擎，不读取玩家数据。"""
from pathlib import Path
import argparse
import hashlib
import io
import json
import re
import struct
import subprocess
import sys
import zipfile
import soundfile as sf
from verify_release import inputs


def check_profile(a):
    """逐项核对与安卓相同的媒体及Windows保留的脚本、字体、引擎。"""
    sys.path.insert(0,str(a.root/'android'))
    from asset_policy import include_asset, native_font_images
    from release_version import game_version
    prepared=a.root/'android/build/assets/game'
    metadata=json.loads((prepared/'android/build-profile.json').read_text(encoding='utf-8'))
    variants=dict(re.findall(r'\["(.*?)"\]="(.*?)"',(prepared/'asset_variants.lua').read_text(encoding='utf-8')))
    count=media=0
    with zipfile.ZipFile(a.package) as z:
        assert z.testzip() is None
        prefix=next(n[:-len('core.lua')] for n in z.namelist() if n.endswith('/core.lua'))
        profile=json.loads(z.read(prefix+'windows/build-profile.json'))
        assert profile['version']==game_version(a.root)==metadata['version']
        assert profile['source_commit']==metadata['source_commit'] and profile['profile']==metadata['profile']
        assert a.package.stat().st_size<profile['max_bytes']
        aliases=dict(re.findall(r'\["(.*?)"\]="(.*?)"',z.read(prefix+'windows/asset_aliases.lua').decode()))
        assert z.read(prefix+'windows/assets.lua')==(a.root/'windows/assets.lua').read_bytes()
        assert not any('/User/' in '/'+n or '/replay/' in '/'+n for n in z.namelist())
        for source in inputs(a.root):
            relative=source.relative_to(a.root).as_posix()
            if not include_asset(relative):
                assert prefix+relative not in z.namelist();continue
            actual=aliases.get(relative,relative);assert actual not in aliases
            payload=z.read(prefix+actual)
            if relative=='launch':
                assert payload.decode().replace('lstg.DoFile("windows/assets.lua")\n','')==source.read_text(encoding='utf-8-sig')
            else:
                if source.suffix.lower() in {'.png','.wav','.flac','.ogg'}:
                    expected=prepared/variants.get(relative,relative);media+=1
                else:expected=source
                assert payload==expected.read_bytes(),relative
            count+=1
        for bitmap in native_font_images(a.root):
            relative=bitmap.relative_to(a.root).as_posix()
            assert relative not in aliases and prefix+relative in z.namelist(),relative
        for name in ['LuaSTGSub.exe','d3dcompiler_47.dll','xaudio2_9redist.dll']:
            assert z.read(prefix+name)==(a.root/name).read_bytes(),name
        exe=z.read(prefix+'LuaSTGSub.exe');offset=struct.unpack_from('<I',exe,0x3c)[0]
        assert exe[:2]==b'MZ' and struct.unpack_from('<H',exe,offset+4)[0]==0x8664
        assert any('/licenses/' in n for n in z.namelist())
    report={'package':a.package.name,'bytes':a.package.stat().st_size,
            'sha256':hashlib.file_digest(a.package.open('rb'),'sha256').hexdigest(),
            'profile':profile,'source_files_checked':count,'identical_android_media':media,
            'font_bitmap_dependencies_kept':True,'windows_fonts_original':True,'crc':True,'user_data_excluded':True}
    if a.output:a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('package',type=Path)
    p.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument('--output',type=Path)
    a=p.parse_args()
    with zipfile.ZipFile(a.package) as z:
        if any(n.endswith('/windows/build-profile.json') for n in z.namelist()):
            check_profile(a);return
    subprocess.run([sys.executable,str(a.root/'tools/check_android_image_package.py'),str(a.package),'--root',str(a.root),'--windows'],check=True)
    count,audio=0,0
    with zipfile.ZipFile(a.package) as z:
        assert z.testzip() is None
        prefix=next(n[:-len('core.lua')] for n in z.namelist() if n.endswith('/core.lua'))
        assert not any('/User/' in '/'+n or '/replay/' in '/'+n for n in z.namelist())
        mapping=dict(re.findall(r'\["(.*?)"\]="(.*?)"',z.read(prefix+'windows/asset_aliases.lua').decode()))
        assert z.read(prefix+'windows/assets.lua')==(a.root/'windows/assets.lua').read_bytes()
        for source in inputs(a.root):
            relative=source.relative_to(a.root).as_posix()
            payload=z.read(prefix+mapping.get(relative,relative))
            if relative=='launch':
                assert payload.decode().replace('lstg.DoFile("windows/assets.lua")\n','')==source.read_text(encoding='utf-8-sig')
            elif source.suffix=='.png':pass
            elif source.suffix=='.wav':
                x,y=sf.info(source),sf.info(io.BytesIO(payload))
                assert (x.frames,x.channels,x.samplerate)==(y.frames,y.channels,y.samplerate),relative
                decoded,_=sf.read(io.BytesIO(payload));assert len(decoded)==x.frames,relative
                audio+=1
            else:assert source.read_bytes()==payload,relative
            count+=1
            if source.suffix=='.fnt':
                for bitmap in re.findall(r'(?im)^Bitmap\s*=\s*([^\r\n]+)',source.read_text(encoding='utf-8-sig')):
                    path=(Path(relative).parent/bitmap.strip().strip('"')).as_posix()
                    assert path not in mapping and prefix+path in z.namelist(),path
        exe=z.read(prefix+'LuaSTGSub.exe');offset=struct.unpack_from('<I',exe,0x3c)[0]
        assert exe[:2]==b'MZ' and struct.unpack_from('<H',exe,offset+4)[0]==0x8664
        for dll in ['d3dcompiler_47.dll','xaudio2_9redist.dll']:assert prefix+dll in z.namelist()
        assert any('/licenses/' in n for n in z.namelist())
    report={'package':a.package.name,'bytes':a.package.stat().st_size,'sha256':hashlib.sha256(a.package.read_bytes()).hexdigest(),
            'source_files_checked':count,'audio_checked':audio,'aliases':len(mapping),'x64_engine_and_dlls':True,
            'font_bitmap_dependencies_kept':True,'user_data_excluded':True,'crc':True}
    if a.output:a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print('Windows发行包全量资源、音频、字体依赖、引擎和CRC检查通过：',report)


if __name__=='__main__':main()
