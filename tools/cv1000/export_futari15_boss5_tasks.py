"""导出第五面演出的固定粒子模板与场景时间线；游戏不读取 ROM/RAM。"""
import argparse
import struct
from pathlib import Path


def export(ram, output):
    raw = ram.read_bytes()
    assert len(raw) == 0x800000
    data = b''.join(raw[i:i+8][::-1] for i in range(0, len(raw), 8))
    def read(at):
        return struct.unpack_from('>i', data, at-0xC000000)[0]
    tables = {'limbs': (0xC31E358, 23, 9), 'body': (0xC31E694, 12, 9),
              'core': (0xC31E844, 6, 9)}
    lines = ['-- 第五面演出固定表；模板与时间线离线导出，运行时没有指令解释器。', 'return {']
    for name, (at, count, width) in tables.items():
        lines.append('    '+name+'={')
        for i in range(count):
            lines.append('        {'+','.join(str(read(at+(i*width+j)*4)) for j in range(width))+'},')
        lines.append('    },')
    lines.append('    timelines={')
    for at, count in [(0xC31E070, 3),(0xC31E094, 3),(0xC31E0B8, 1),(0xC31E0C4, 1),
                      (0xC31E0D0, 1),(0xC31E0DC, 1),(0xC31E0E8, 1)]:
        rows = ['{'+','.join(str(read(at+(i*3+j)*4)) for j in range(3))+'}' for i in range(count)]
        lines.append('        ['+str(at)+']={'+','.join(rows)+'},')
    lines.extend(['    },','}'])
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ram', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    export(args.ram, args.output)
