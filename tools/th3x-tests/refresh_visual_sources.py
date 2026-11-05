"""从带地址的原版反汇编和二进制补齐显示指令；仅替换指定作品的导出表。"""
from pathlib import Path
import argparse
import importlib.util
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('anm_export', Path(__file__).with_name('export_original_anm.py'))
serializer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(serializer)
OPS = {8: set(range(54, 63)) | {79, 80, 81, 83, 174},
       7: {95, 96, 97, 99, 100, 120, 128, 129, 132, 138, 150}}


def profiles(game, declarations, binaries):
    out = {}
    for path in sorted(declarations.glob('*.decl')):
        raw = (binaries / (path.stem + '.ecl')).read_bytes()
        subs = {}
        for block in re.finditer(r'(?:sub|void) (\w+)\([^)]*\)\s*\{(.*?)\n\}',
                                 path.read_text('utf-8', errors='replace'), re.S):
            rows = []
            for row in re.finditer(r'/\*\s*([0-9a-f]+) [^*]*\*/\s*ins_(\d+)\(', block[2]):
                address, op = int(row[1], 16), int(row[2])
                time, actual, size, _, mask, flags = struct.unpack_from('<ihhBBH', raw, address)
                assert actual == op and size >= 12, (path, address, op)
                if not mask & 8 and not (mask & 0x60 and not mask & 15):
                    continue
                values = []
                for i in range((size - 12) // 4):
                    value, = struct.unpack_from('<f' if game == 7 and (op == 150 or op == 100 and i>=1) else '<i', raw, address + 12 + i * 4)
                    values.append({'var': value} if flags & (1 << i) else value)
                rows.append((time, op, values, mask))
            subs[block[1]] = rows

        def expand(name, parents=(), inherited=255):
            if name in parents:
                return []
            result = []
            for time, op, values, mask in subs.get(name, []):
                mask &= inherited
                if op in OPS[game]:
                    result.append(([time, op, *values], mask))
                elif op == (52 if game == 8 else 41) and values and isinstance(values[0], int):
                    for event, childmask in expand('Sub' + str(values[0]), (*parents, name), mask):
                        result.append(([time + event[0], *event[1:]], childmask))
                elif op == (4 if game == 8 else 2) and len(values) >= 2:
                    # 无条件回跳后的淡出指令是死代码，例如妖妖梦Sub63/65的t=800。
                    if isinstance(values[1], int) and values[1] < 0:
                        break
            return result

        for name in subs:
            events = sorted(expand(name), key=lambda pair: pair[0][0])
            if not events:
                continue
            cfg = {'events': [event for event, _ in events]}
            # TH08的0x20/0x40用于人类/妖怪分支；不能把两套动画顺序叠在同一对象上。
            masks = {i: mask for i, (_, mask) in enumerate(events, 1)
                     if game == 8 and mask & 0x60 in (0x20, 0x40)}
            if masks:
                cfg['masks'] = masks
            key = path.stem + ':' + (name[3:] if name.startswith('Sub') else name)
            out[key] = cfg
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game', type=int, choices=OPS, required=True)
    parser.add_argument('--declarations', type=Path, required=True)
    parser.add_argument('--binaries', type=Path, required=True)
    parser.add_argument('--luajit', default='luajit')
    args = parser.parse_args()
    data = profiles(args.game, args.declarations, args.binaries)
    assert data, '未读取到原作显示指令'
    target=ROOT/'mod/GAME/original/visual_ecl.lua'
    text=target.read_text()
    marker=f'[{args.game}]='
    depth=0;quoted=False;escaped=False;i=text.index('return ')+len('return ')
    while i<len(text):
        c=text[i]
        if quoted:
            if escaped:escaped=False
            elif c=='\\':escaped=True
            elif c=='"':quoted=False
        elif c=='"':quoted=True
        elif depth==1 and text.startswith(marker,i):
            start=i+len(marker);end=start;level=0;string=False;escape=False
            while end<len(text):
                c=text[end]
                if string:
                    if escape:escape=False
                    elif c=='\\':escape=True
                    elif c=='"':string=False
                elif c=='"':string=True
                elif c=='{':level+=1
                elif c=='}':
                    level-=1
                    if level==0:break
                end+=1
            assert level==0 and end<len(text)
            target.write_text(text[:start]+serializer.lua(data)+text[end+1:])
            break
        elif c=='{':depth+=1
        elif c=='}':depth-=1
        i+=1
    else:raise AssertionError('未找到顶层作品表')
    print(f'TH{args.game}：已从原始字节校验并更新{len(data)}个显示入口')


if __name__ == '__main__':
    main()
