#!/usr/bin/env python3
"""从雪莲华发行包只读导出实际加载的弹雾精灵及脚本参数。"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess

import UnityPy
from UnityPy.export.Texture2DConverter import get_image_from_texture2d

ROOT = Path(__file__).resolve().parents[2]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--data', type=Path, required=True, help='发行包 THasl_Data 目录')
p.add_argument('--ilspycmd', type=Path, default=Path(shutil.which('ilspycmd') or
               Path.home() / '.dotnet/tools/ilspycmd'))
a = p.parse_args()
source = a.data.resolve()
hashes = {}
for name in ('globalgamemanagers', 'resources.assets', 'resources.assets.resS',
             'Managed/Assembly-CSharp.dll'):
    with (source / name).open('rb') as stream:
        hashes[name] = hashlib.file_digest(stream, 'sha256').hexdigest()
scripts = {}
for name in ('Basic', 'Basic_zi', 'Wuhua', 'Sincos'):
    scripts[name] = subprocess.run(
        [str(a.ilspycmd), '-t', name, str(source / 'Managed/Assembly-CSharp.dll')],
        check=True, capture_output=True, text=True).stdout

def profile(name):
    text = scripts[name]
    switch = re.search(r'switch \(a6_4\)\s*\{(.*?)\}', text, re.S).group(1)
    scales = {}
    for case, body in re.findall(r'case (\d+):(.*?)(?=case \d+:|$)', switch, re.S):
        scales[int(case)] = float(re.search(r'owhbl = ([\d.]+)f;', body).group(1))
    shrink = float(re.search(r'owhbl_pre = owhbl \* ([\d.]+)f;', text).group(1))
    initial = float(re.search(r'owhbl_wu = owhbl \* ([\d.]+)f;', text).group(1))
    return dict(scales=scales, shrink=shrink, initial=initial)
data = dict(root=profile('Basic'), child=profile('Basic_zi'))
wuhua = scripts['Wuhua']
data['first_life'] = int(re.search(r'private int time = (\d+);', wuhua).group(1))
data['reused_life'] = int(re.search(r'time = (\d+);', wuhua[wuhua.index('private void FixedUpdate'):]).group(1))
sincos = scripts['Sincos']
data['limit'] = int(re.search(r'wuhua_chi = new GameObject\[(\d+)\]', sincos).group(1))
# 必须匹配发行版 LoadAll 的资源键，不能按 wuhua 文件名选择重建工程的另一套散图。
resource_key = re.search(r'wh = Resources.LoadAll<Sprite>\("([^"]+)"\)', sincos).group(1).lower()
env = UnityPy.load(str(source / 'globalgamemanagers'), str(source / 'resources.assets'))
manager = next(obj for obj in env.objects if obj.type.name == 'ResourceManager').read()
sprites = [ptr for key, ptr in manager.m_Container
           if key == resource_key and ptr.deref().type.name == 'Sprite']
if len(sprites) != 8:
    raise ValueError(f'{resource_key} 应包含八张弹雾精灵，实际为 {len(sprites)}')
data['sprites'] = []
sprite_sources = []
target = ROOT / 'Resources/th38/mist'
target.mkdir(parents=True, exist_ok=True)
for i, ptr in enumerate(sprites):
    sprite = ptr.read()
    name = f'wuhua{i}.png'
    texture_ptr = sprite.m_RD.texture
    # 原发行包 Texture2D 含尾随字节；沿现有导出器方式解码并交给 SpriteHelper 切片。
    sprite.assets_file._cache[texture_ptr.path_id] = get_image_from_texture2d(
        texture_ptr.deref().read(check_read=False), False)
    image = sprite.image
    w, h = int(sprite.m_Rect.width), int(sprite.m_Rect.height)
    if image.size != (w, h) or (sprite.m_RD.textureRectOffset.x, sprite.m_RD.textureRectOffset.y) != (0, 0):
        raise ValueError(f'{sprite.m_Name} 存在额外裁切偏移，需要按发行包几何处理')
    image.save(target / name)
    ppu = sprite.m_PixelsToUnits
    px, py = sprite.m_Pivot.x, sprite.m_Pivot.y
    data['sprites'].append(dict(file='Resources/th38/mist/' + name, width=w, height=h,
                                x=w * px, y=h * (1 - py), scale=48 / ppu))
    sprite_sources.append(dict(name=sprite.m_Name, path_id=ptr.path_id,
                               texture_path_id=texture_ptr.path_id,
                               rect={key: getattr(sprite.m_Rect, key)
                                     for key in ('x', 'y', 'width', 'height')},
                               pixels_per_unit=ppu, pivot=dict(x=px, y=py)))
def lua(v):
    if isinstance(v, str): return json.dumps(v, ensure_ascii=False)
    if isinstance(v, (int, float)): return repr(v)
    if isinstance(v, list): return '{' + ','.join(map(lua, v)) + '}'
    return '{' + ','.join('[' + lua(k) + ']=' + lua(x) for k, x in v.items()) + '}'
out = ROOT / 'mod/GAME/th38'
(out / 'mist_data.lua').write_text('-- 发行版DLL及Resources.LoadAll实际使用的wuhua图集精灵；不要替换为雾化目录散图。\nreturn ' + lua(data) + '\n')
manifest = dict(data_directory=str(source), sha256=hashes, resource_key=resource_key,
                scripts={name: hashlib.sha256(text.encode()).hexdigest()
                         for name, text in scripts.items()}, sprites=sprite_sources)
(out / 'mist_sources.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
print('已从发行包导出八张弹雾图集精灵及原收缩/对象池参数')
