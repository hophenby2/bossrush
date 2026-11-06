"""把导出的单文件演出调度常量按 ECL 文件拆成多块。

背景：LuaJIT 每个 function 的原型常量表最多 BCMAX_D+1 = 65536 项
（external/luajit2/src/lj_parse.c: fs_fixup_k -> checklimitgt），而一次导出
TH08 + TH095 全部文件约 20 万个字面量常量，直接 dofile 会报
"main function has more than 65536 constants"。拆成「一个 ECL 文件一个块」后，
每块最多 1.4 万个常量，运行时由 THlib/anm/presentation.lua 按需加载。

用法：先跑 export_presentation_programs.py 生成 presentation_programs.lua，再跑本脚本。
"""
from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]  # bossrush 发行目录根
SOURCE = ROOT / 'mod/GAME/original/presentation_programs.lua'
OUTDIR = ROOT / 'mod/GAME/original/presentation_programs.d'
INDEX = ROOT / 'mod/GAME/original/presentation_programs_index.lua'
LIMIT = 60000  # 留余量，单块常量数上限（引擎硬上限 65536）

ENTRY = re.compile(r'\["([A-Za-z0-9_]+)"\]=\{\["scripts"\]')
LITERAL = re.compile(r'(?<![A-Za-z0-9_."])(-?\d+\.\d+|-?\d+)(?![A-Za-z0-9_."])')


def block_end(text, pos):
    start = text.index('{', pos)
    depth = 0
    instr = False
    i = start
    while i < len(text):
        c = text[i]
        if instr:
            if c == '\\':
                i += 2
                continue
            if c == '"':
                instr = False
        elif c == '"':
            instr = True
        elif c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
            if depth == 0:
                return start, i + 1
        i += 1
    raise ValueError('unbalanced braces')


def main():
    raw = SOURCE.read_text(encoding='utf-8')
    if 'return {[8]={' not in raw:
        print('source already split, nothing to do')
        return 0
    lines = raw.split('\n')
    body = lines[1]
    split95 = re.search(r',\[95\]=\{', body)
    if not split95:
        raise SystemExit('unexpected layout: [95] section not found')
    blocks = []
    for m in ENTRY.finditer(body):
        name = m.group(1)
        eq = body.index('=', m.start())
        a, b = block_end(body, eq)
        game = 8 if m.start() < split95.start() else 95
        blocks.append((game, name, body[a:b]))
    rebuilt = ('return {[8]={' + ','.join('["%s"]=%s' % (n, t) for g, n, t in blocks if g == 8)
               + '},[95]={' + ','.join('["%s"]=%s' % (n, t) for g, n, t in blocks if g == 95) + '}}')
    if rebuilt != body:
        raise SystemExit('rebuild mismatch: 切分结果无法还原原文')
    for game, name, text in blocks:
        count = len(LITERAL.findall(text))
        if count > LIMIT:
            raise SystemExit('块过大: %d_%s 有 %d 个常量' % (game, name, count))
    OUTDIR.mkdir(parents=True, exist_ok=True)
    for old in OUTDIR.glob('*.lua'):
        old.unlink()
    for game, name, text in blocks:
        (OUTDIR / ('%d_%s.lua' % (game, name))).write_text('return ' + text + '\n', encoding='utf-8')
    index = {'8': [n for g, n, _ in blocks if g == 8], '95': [n for g, n, _ in blocks if g == 95]}
    # 索引必须是「文件名 -> true」的 set，不能是数组：
    # program_file 用 names[file] 直接查，数组永远查不中会导致数据静默不加载。
    INDEX.write_text('-- presentation_programs.lua 按 ECL 文件切分后的索引，供 THlib/anm/presentation.lua 按需加载。\n'
                     'return {\n'
                     '    ["8"]={' + ','.join('[%s]=true' % json.dumps(n, ensure_ascii=False) for n in index['8']) + '},\n'
                     '    ["95"]={' + ','.join('[%s]=true' % json.dumps(n, ensure_ascii=False) for n in index['95']) + '},\n'
                     '}\n', encoding='utf-8')
    SOURCE.write_text(
        '-- 原 presentation_programs.lua 约 20 万个字面量常量，超过 LuaJIT 单函数 65536 常量上限\n'
        '-- （lj_parse.c: fs_fixup_k -> checklimitgt(..., BCMAX_D+1, "constants")，BCMAX_D = 0xffff）。\n'
        '-- 已按 ECL 文件拆到 presentation_programs.d/，索引见 presentation_programs_index.lua，\n'
        '-- 运行时由 THlib/anm/presentation.lua 按需加载。\n'
        '-- 重新生成：先跑 tools/th3x-tests/export_presentation_programs.py，再跑本脚本。\n'
        "error('presentation_programs.lua 已拆分为 presentation_programs.d/，请从 THlib/anm/presentation.lua 加载，不要直接读取此文件')\n",
        encoding='utf-8')
    print('切分完成：%d 块（TH08 %d / TH095 %d），单块最大 %d 个常量'
          % (len(blocks), len(index['8']), len(index['95']),
             max(len(LITERAL.findall(t)) for _, _, t in blocks)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
