"""独立读取 TH07 ANM 二进制布局，核对导出表；不使用导出器的解析函数。"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import struct

ROOT = Path(__file__).resolve().parents[2]


def check(cache):
    manifest = json.loads((ROOT / 'mod/GAME/original/manifest.json').read_text(encoding='utf-8'))['7']
    checks = 0
    for archive, info in manifest.items():
        raw = (cache / (archive + '.anm')).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == info['sha256'], archive + ' 原始文件指纹不符'
        text = (ROOT / 'mod/GAME/original/7' / (archive + '.lua')).read_text(encoding='utf-8')
        sprites = text.split('["sprites"]={', 1)[1].split('},["scripts"]=', 1)[0]
        actual_sprites = {int(k): [float(v) for v in a.split(',')] for k, a in
                          re.findall(r'\[(\d+)\]=\{([^{}]+)\}', sprites)}
        ids = text.split('["ids"]={', 1)[1].split('}', 1)[0]
        actual_ids = {int(k): int(v) for k, v in re.findall(r'\[(\d+)\]=(\d+)', ids)}
        bases = text.split('["sprite_bases"]={', 1)[1].split('}', 1)[0] if '["sprite_bases"]=' in text else ''
        actual_bases = {int(k): int(v) for k, v in re.findall(r'\[(\d+)\]=(\d+)', bases)}
        expected_sprites, expected_ids, expected_bases = {}, {}, {}
        offset = base = logical = entry = 0
        while True:
            ns, nc = struct.unpack_from('<ii', raw, offset)
            next_offset, = struct.unpack_from('<I', raw, offset + 56)
            largest = 0
            for i in range(ns):
                ptr, = struct.unpack_from('<I', raw, offset + 64 + i * 4)
                sid, x, y, w, h = struct.unpack_from('<i4f', raw, offset + ptr)
                expected_sprites[base + sid] = [entry, x, y, w, h]
                largest = max(largest, sid)
            for i in range(nc):
                sid, ptr = struct.unpack_from('<iI', raw, offset + 64 + ns * 4 + i * 8)
                expected_ids[base + sid] = logical
                if base:
                    expected_bases[logical] = base
                logical += 1
                largest = max(largest, sid)
            if not next_offset:
                break
            base += largest + 1
            offset += next_offset
            entry += 1
        assert actual_sprites == expected_sprites, archive + ' 精灵坐标/纹理页编号不符'
        assert actual_ids == expected_ids, archive + ' 原始动画编号不符'
        assert actual_bases == expected_bases, archive + ' 动画的精灵基址不符'
        assert info['sprites'] == len(expected_sprites) and info['scripts'] == logical, archive + ' manifest 计数不符'
        checks += len(expected_sprites) + len(expected_ids) + len(expected_bases) + 2
    print(f'TH07 原始 ANM 二进制布局核对通过：{len(manifest)} 份，{checks} 项')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cache', type=Path, default=Path(r'E:\workspace\.bossrush-validation\original-anm\7'))
    check(parser.parse_args().cache)
