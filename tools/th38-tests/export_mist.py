#!/usr/bin/env python3
"""只读导出雪莲华弹雾原图、尺寸、收缩速度和对象池参数。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct

ROOT = Path(__file__).resolve().parents[2]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--source', type=Path, required=True)
a = p.parse_args()
source = a.source.resolve() / 'Assets'
hashes = {}
def read(path):
    raw = path.read_bytes()
    hashes[path.relative_to(source).as_posix()] = hashlib.sha256(raw).hexdigest()
    return raw.decode('utf-8-sig')
def profile(name):
    text = read(source / 'Scripts' / name)
    switch = re.search(r'switch \(a6_4\)\s*\{(.*?)\}', text, re.S).group(1)
    scales = {}
    for case, body in re.findall(r'case (\d+):(.*?)(?=case \d+:|$)', switch, re.S):
        scales[int(case)] = float(re.search(r'owhbl = ([\d.]+)f;', body).group(1))
    shrink = float(re.search(r'owhbl_pre = owhbl \* ([\d.]+)f;', text).group(1))
    initial = float(re.search(r'owhbl_wu = owhbl \* ([\d.]+)f;', text).group(1))
    return dict(scales=scales, shrink=shrink, initial=initial)
data = dict(root=profile('Basic.cs'), child=profile('Basic_zi.cs'))
wuhua = read(source / 'Scripts/Wuhua.cs')
data['first_life'] = int(re.search(r'private int time = (\d+);', wuhua).group(1))
data['reused_life'] = int(re.search(r'time = (\d+);', wuhua[wuhua.index('private void FixedUpdate'):]).group(1))
sincos = read(source / 'Scripts/Sincos.cs')
data['limit'] = int(re.search(r'wuhua_chi = new GameObject\[(\d+)\]', sincos).group(1))
read(source / 'Scripts/Loading0.cs')
read(source / 'Resources/xuelianhua/prefab/dam_wuhua.prefab')
data['sprites'] = []
target = ROOT / 'Resources/th38/mist'
target.mkdir(parents=True, exist_ok=True)
for i in range(8):
    name = f'wuhua{i}.png'
    image = source / 'Resources/xuelianhua/image/Bullet/雾化' / name
    meta = read(Path(str(image) + '.meta'))
    raw = image.read_bytes()
    hashes[image.relative_to(source).as_posix()] = hashlib.sha256(raw).hexdigest()
    w, h = struct.unpack('>II', raw[16:24])
    ppu = float(re.search(r'spritePixelsToUnits: ([\d.]+)', meta).group(1))
    px, py = map(float, re.search(r'spritePivot: \{x: ([\d.]+), y: ([\d.]+)\}', meta).groups())
    shutil.copy2(image, target / name)
    data['sprites'].append(dict(file='Resources/th38/mist/' + name, width=w, height=h,
                                x=w * px, y=h * (1 - py), scale=48 / ppu))
def lua(v):
    if isinstance(v, str): return json.dumps(v, ensure_ascii=False)
    if isinstance(v, (int, float)): return repr(v)
    if isinstance(v, list): return '{' + ','.join(map(lua, v)) + '}'
    return '{' + ','.join('[' + lua(k) + ']=' + lua(x) for k, x in v.items()) + '}'
out = ROOT / 'mod/GAME/th38'
(out / 'mist_data.lua').write_text('-- 原作Basic/Basic_zi、Wuhua及Sprite导出参数。\nreturn ' + lua(data) + '\n')
(out / 'mist_sources.json').write_text(json.dumps(hashes, ensure_ascii=False, indent=2) + '\n')
print('已导出雪莲华8张原弹雾贴图及原收缩/对象池参数')
