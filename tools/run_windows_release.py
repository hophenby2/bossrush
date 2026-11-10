#!/usr/bin/env python3
"""在Windows隔离解压目录验证发行包的真实引擎、资源解码和五作入口。"""
import argparse
import io
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time
import zipfile
from PIL import Image


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('package',type=Path)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--timeout',type=int,default=360)
    a=p.parse_args()
    if os.name!='nt':raise SystemExit('真实引擎验证须在Windows执行')
    a.output.mkdir(parents=True,exist_ok=False)
    with zipfile.ZipFile(a.package) as z:
        prefix=next(n[:-len('core.lua')] for n in z.namelist() if n.endswith('/core.lua'))
        aliases=dict(re.findall(r'\["(.*?)"\]="(.*?)"',z.read(prefix+'windows/asset_aliases.lua').decode()))
        paths={n[len(prefix):] for n in z.namelist() if n.startswith(prefix)}|set(aliases)
        images=[]
        for path in sorted(paths):
            if path.endswith('.png'):
                with Image.open(io.BytesIO(z.read(prefix+aliases.get(path,path)))) as image:
                    images.append({'path':path,'width':image.width,'height':image.height})
        audio=sorted(path for path in paths if path.endswith('.wav'))
        z.extractall(a.output)
    game=a.output/Path(prefix.rstrip('/'))
    (game/'User').mkdir();(game/'replay').mkdir();(game/'snapshot').mkdir()
    (game/'native-config.json').write_text(json.dumps({'images':images,'audio':audio,'levels':[29,30,31,32,33]}),encoding='utf-8')
    shutil.move(game/'core.lua',game/'game-core.lua')
    shutil.copy2(Path(__file__).resolve().parents[1]/'windows/verify.lua',game/'core.lua')
    entry=(game/'launch').read_text(encoding='utf-8-sig')
    entry+="\nsetting.resx=640;setting.resy=480;setting.windowed=true;setting.vsync=false\nSetResolution(640,480);SetWindowed(true);SetVsync(false);SetBGMVolume(0);SetSEVolume(0)\n"
    (game/'launch').write_text(entry,encoding='utf-8')
    startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
    process=subprocess.Popen([str((game/'LuaSTGSub.exe').resolve())],cwd=game,startupinfo=startup)
    deadline=time.monotonic()+a.timeout
    try:
        while process.poll() is None and time.monotonic()<deadline:
            time.sleep(1)
        if process.poll() is None:raise TimeoutError('Windows引擎验证超时，见隔离目录日志')
        report=json.loads((game/'native-result.json').read_text(encoding='utf-8'))
        (a.output/'native-result.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
        assert report['ok'],report
        assert report['images']==len(images) and report['audio']==len(audio)
        assert len(report['entries'])==5
        print(json.dumps(report,ensure_ascii=False))
    finally:
        if process.poll() is None:process.kill();process.wait()


if __name__=='__main__':main()
