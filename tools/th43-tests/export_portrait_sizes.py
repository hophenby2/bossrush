#!/usr/bin/env python3
"""只读提取栖霞园立绘原始尺寸；入包缩图时保留原作的绘制大小。"""
import argparse
import hashlib
from pathlib import Path
import struct

from export_release_effects import Archive, executable_key

ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game', type=Path, required=True)
    args = parser.parse_args()
    game = args.game.resolve()
    key, _ = executable_key(game / 'game.exe')
    archive = Archive(game / 'story.res', key)
    lines = ['-- 发行版 story.res 的原始立绘尺寸；由 tools/th43-tests/export_portrait_sizes.py 导出。',
             '-- story.res SHA-256: ' + hashlib.sha256((game / 'story.res').read_bytes()).hexdigest(),
             'return {']
    count = 0
    for name in sorted(archive.zip.namelist()):
        if not name.startswith('res/performer/') or not name.endswith('.png'):
            continue
        data = archive.read(name)
        if data[:8] != b'\x89PNG\r\n\x1a\n':
            raise ValueError('立绘不是 PNG：' + name)
        width, height = struct.unpack_from('>II', data, 16)
        lines.append(f'    ["{name}"]={{{width},{height}}},')
        count += 1
    lines.append('}')
    (ROOT / 'mod/GAME/th43/portrait_sizes.lua').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(f'已导出 {count} 张立绘的原始尺寸')


if __name__ == '__main__':
    main()
