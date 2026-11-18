"""从规范化前的 MAME RAM 导出第五面最终击破的固定表，不包含执行器。"""
import argparse
import struct
from pathlib import Path


def export(ram, output):
    raw = ram.read_bytes()
    assert len(raw) == 0x800000
    normalized = b''.join(raw[i:i+8][::-1] for i in range(0, len(raw), 8))

    def read(at):
        return struct.unpack_from('>i', normalized, at-0xC000000)[0]

    tables = {'offsets': (0xC31D588, 8, 2), 'small': (0xC31D468, 8, 9),
              'final': (0xC31CD5C, read(0xC31D464), 10)}
    assert tables['final'][1] == 45
    lines = ['-- 第五面最终击破的原程序固定坐标及粒子模板；运行时不读取 ROM/RAM。', 'return {']
    for name, (at, count, width) in tables.items():
        lines.append('    ' + name + '={')
        for i in range(count):
            values = [read(at + (i*width+j)*4) for j in range(width)]
            lines.append('        {' + ','.join(map(str, values)) + '},')
        lines.append('    },')
    lines.append('}')
    output.write_bytes(('\n'.join(lines) + '\n').encode('utf-8'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ram', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    export(args.ram, args.output)
