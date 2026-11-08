"""读取地灵殿二进制与 thecl 声明，逐条核对地址、长度、时间和难度掩码。"""
from pathlib import Path
import importlib.util
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/th3x-tests'))
from ecl_source import Source, Variable, f32


def load(directory):
    directory = Path(directory)
    sources = {}
    for path in sorted(directory.glob('*.ecl')):
        source = Source(path.with_suffix('.ecl.txt'), path, 10)
        # TH11 仍用16字节头；Source 的 game=10 仅选择这个二进制布局。
        # 字符串另从-j导出的UTF-8读，不让本机代码页决定卡名。
        utf8 = path.with_suffix('.utf8')
        if utf8.exists():
            names = {}
            for m in re.finditer(r'/\*\s*([0-9a-f]+) \([^*]+\*/\s*ins_(?:342|357|358|359)\([^\n]*?"((?:\\.|[^"\\])*)"\);', utf8.read_text('utf-8')):
                names[int(m[1], 16)] = m[2]
            for rows in source.subs.values():
                for row in rows:
                    if row.address in names:
                        row.args[-1] = '"' + names[row.address] + '"'
        sources[path.stem] = source
    assert len(sources) == 20, ('原作包括default、六条回忆路线及五至EX的独立Boss脚本', len(sources))
    return sources


def programs(sources, stage):
    names = ['default', f'stage{stage:02}']
    if stage == 4:
        names += ['stage4c' + x for x in ('00a', '00b', '00c', '01a', '01b', '01c')]
    if stage >= 5:
        names += [f'stage{stage:02}mboss', f'stage{stage:02}boss']
    result = {}
    for name in names:
        source = sources[name]
        for sub, rows in source.subs.items():
            assert sub not in result, ('原作子程序重名', stage, sub)
            result[sub] = (source, rows)
    return result


def active(rows, stage):
    return [r for r in rows if r.mask & (16 if stage == 7 else 8)]
