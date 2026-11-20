#!/usr/bin/env python3
"""从已导出的夏夜祭图集生成背景不透明区域元数据，不修改原图。"""
import hashlib
import json
import re
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
STRING = r'"(?:\\.|[^"\\])*"'
ROW = re.compile(r'\{(' + STRING + r'),(' + STRING + r'),(\d+),(\d+),(\d+),(\d+)\}')


def export(root=ROOT):
    directory = root / 'mod/GAME/th40'
    regions, hashes = {}, {}
    for match in ROW.finditer((directory / 'atlas.lua').read_text(encoding='utf-8')):
        name, file = map(json.loads, match.group(1, 2))
        if not file.startswith('Resources/th40/Background/'):
            continue
        x, y, width, height = map(int, match.group(3, 4, 5, 6))
        path = root / file
        with Image.open(path) as image:
            alpha = image.convert('RGBA').getchannel('A')
            opaque = alpha.crop((x, y, x + width, y + height)).getextrema() == (255, 255)
            # 连续平铺还需保证边缘双线性采样不会读到图集中的透明邻居。
            seam_opaque = alpha.getextrema() == (255, 255)
        regions[name] = [file, x, y, width, height, opaque, seam_opaque]
        hashes[file] = hashlib.sha256(path.read_bytes()).hexdigest()
    quote = lambda value: json.dumps(value, ensure_ascii=False)
    lines = ['-- 由 export_background_coverage.py 读取原图 alpha 生成；保留图集裁片与图片来源哈希。',
             'return {regions={']
    for name, region in sorted(regions.items()):
        fields = [quote(region[0]), *map(str, region[1:5]), *[str(v).lower() for v in region[5:]]]
        lines.append('[' + quote(name) + ']={' + ','.join(fields) + '},')
    lines.append('},sources={')
    for file, digest in sorted(hashes.items()):
        lines.append('[' + quote(file) + ']=' + quote(digest) + ',')
    lines.append('}}')
    (directory / 'background_coverage.lua').write_text('\n'.join(lines) + '\n', encoding='utf-8')


if __name__ == '__main__':
    export()
