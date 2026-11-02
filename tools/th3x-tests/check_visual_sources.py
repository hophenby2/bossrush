"""逐字节核对使魔形态特效和伪激光拖尾配置，避免筛选导出再次漏指令。"""
from pathlib import Path
import argparse
import struct
import subprocess

from ecl_source import Source

ROOT = Path(__file__).resolve().parents[2]


def check(source, declarations):
    code = '''local d=dofile('mod/GAME/original/visual_ecl.lua')
for _,game in ipairs({7,8})do for key,cfg in pairs(d[game])do
 for _,c in ipairs(cfg.events)do if c[2]==138 or c[2]==174 then
  local row={game,key};for _,v in ipairs(c)do row[#row+1]=v end
  print(unpack(row))
 end end
end end'''
    output = subprocess.check_output(['luajit', '-e', code], cwd=ROOT, text=True)
    actual = set()
    for line in output.splitlines():
        game, key, *values = line.split('\t')
        actual.add((int(game), key, *(int(value) for value in values)))
    counts = {7: 0, 8: 0}
    folders = {7: '[th07] 东方妖妖梦 (日文版)', 8: '[th08] 东方永夜抄 (日文版)'}
    for game, folder in folders.items():
        for path in sorted((declarations / str(game)).glob('*.decl')):
            original = Source(path, source / folder / 'data' / (path.stem + '.ecl'), game)
            binary = original.binary.read_bytes()
            for sub, rows in original.subs.items():
                for row in rows:
                    if not row.mask & 8 or row.op != (138 if game == 7 else 174):
                        continue
                    fmt = '<4i' if game == 7 else '<i'
                    values = struct.unpack_from(fmt, binary, row.address + 12)
                    assert list(values) == row.args, (path, sub, row.address, values, row.args)
                    key = path.stem + ':' + sub.removeprefix('Sub')
                    assert (game, key, row.time, row.op, *values) in actual, (key, row.time, row.op, values)
                    counts[game] += 1
    assert counts == {7: 24, 8: 38}, ('原件范围或指令数量变化', counts)
    print(f'原作字节核对通过：TH08全部{counts[8]}处形态特效替换，TH07全部{counts[7]}处拖尾配置')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True, help='包含各原作游戏目录的thtkGUI根目录')
    parser.add_argument('--declarations', type=Path, required=True, help='带地址反汇编的7/8子目录')
    args = parser.parse_args()
    check(args.source, args.declarations)
