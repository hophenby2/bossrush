#!/usr/bin/env python3
"""本次反馈的原图格式、像素和道具控制器对照。"""
import argparse, hashlib, importlib.util
from io import BytesIO
from pathlib import Path
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--night-content',type=Path,required=True)
ap.add_argument('--theis-source',type=Path,required=True)
args=ap.parse_args()
spec=importlib.util.spec_from_file_location('art',Path(__file__).with_name('export_art.py'))
art=importlib.util.module_from_spec(spec);spec.loader.exec_module(art)
for name in [*('selfbarrage'+str(i) for i in range(1,6)),'spscore','bosslist']:
    path=ROOT/'Resources/native_players/source'/('39_'+name+'.png')
    assert path.read_bytes()[:8]==b'\x89PNG\r\n\x1a\n',('伪 PNG',name)
    original=Image.open(BytesIO(art.read(args.night_content/'Graphics/List'/(name+'.xna'),0))).convert('RGBA')
    current=Image.open(path).convert('RGBA')
    assert original.size==current.size and original.tobytes()==current.tobytes(),('原像素不同',name)
source=args.theis_source/'EISlib/item/itemclass.lua'
raw=source.read_bytes();text=raw.decode('utf-8-sig')
body=text[text.index('local item_fly_controller = {}'):text.index('local item_base_class = Class(object)')]
body='\n'.join(line.rstrip() for line in body.splitlines())
fixture=(ROOT/'macos/lua/oracle_theis_item.lua').read_text()
assert hashlib.sha256(raw).hexdigest() in fixture and body in fixture,'道具对照不是原作控制器'
count=0
for name in ('reimu','marisa','mokou'):
    for source in (args.theis_source.parent/'stage/res/player'/name).glob('*.png'):
        current=ROOT/'Resources/ports/theis/res/player'/name/source.name
        assert current.read_bytes()==source.read_bytes(),('自机原图不同',source.name)
        count+=1
print(f'永夜 7 张图为 PNG 且 RGBA 像素与原 XNA 完全相同；祈华梦 {count} 张原图及原作道具控制器一致')
