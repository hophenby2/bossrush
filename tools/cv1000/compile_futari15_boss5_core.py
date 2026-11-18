"""把第五面关底独立入口/返回记录整理为原生血量状态机的回归输入。"""
import argparse
import struct
from pathlib import Path

FIELDS = [0x2604, 0x2610, 0x2634, 0x2636, 0x2638, 0x263C, 0x2640,
          0x2664, 0x2668, 0x267C, 0x2680, 0x2684, 0x2688, 0x268C, 0x2690,
          0x2694, 0x2698, 0x269C, 0x26A0, 0x26A4, 0x26A8, 0x26AC, 0x26B0,
          0x26B4, 0x26B8, 0x26BC, 0x26C0, 0x26C4, 0x26C8, 0x26CC]


def calls(path):
    stack = []
    for line in path.read_text(encoding='utf-8').splitlines():
        words = line.split()
        tag = words[0]
        if tag == 'I':
            ident, frame = map(int, words[1:3])
            kind = words[3]
            extra = 5 if kind == 'hit' else 1
            before = list(map(int, words[4+extra:]))
            assert len(before) == len(FIELDS)
            stack.append(dict(ident=ident, frame=frame, kind=kind, before=before,
                              inputs=list(map(int, words[4:4+extra])), queries=[], inhibit=0))
        elif tag == 'Q':
            assert stack[-1]['ident'] == int(words[1])
            stack[-1]['inhibit'] = int(words[2])
        elif tag == 'V':
            assert stack[-1]['ident'] == int(words[1])
            stack[-1]['queries'].append(int(words[3]))
        elif tag == 'R':
            row = stack.pop()
            assert row['ident'] == int(words[1])
            row['result'] = int(words[2])
            row['after'] = list(map(int, words[3:]))
            assert len(row['after']) == len(FIELDS)
            if not stack and row['kind'] in ('hit', 'clock'):
                yield row
    assert not stack


def digest(h, values):
    for value in values:
        h = (h * 131 + value) % 16777213
    return h


def lua(value):
    if isinstance(value, (list, tuple)):
        return '{' + ','.join(map(lua, value)) + '}'
    return str(value)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path, nargs='+')
    parser.add_argument('output', type=Path)
    parser.add_argument('--birth', type=Path)
    args = parser.parse_args()
    rows = [row for path in args.input for row in calls(path)]
    if not rows:
        raise ValueError('没有配对的原版调用')
    previous = initial = rows[0]['before']
    groups, counts, hashes, transitions = [], [0, 0], [0, 0], []
    for row in rows:
        op = 1 if row['kind'] == 'hit' else 2
        delta = [n for i, (a, b) in enumerate(zip(previous, row['before']), 1) if a != b for n in (i, b)]
        info = []
        if row['queries']:
            q = row['queries']
            assert len(q) == 5 and q[1:3] == q[3:5], '来源坐标的两次查询不符'
            info = [q[0], row['inputs'][2], q[3], q[4]]
        inputs = ([row['inputs'][1], row['inputs'][0]] if op == 1 else [row['inputs'][0], 0])
        group = [op, 1, row['frame'], *inputs, row['inhibit'], delta, info]
        # 同一步内连续命中的相同自弹可合并；仍逐次算状态校验值，不能合并伤害。
        if groups and not delta and not info and groups[-1][:1] == [op] and groups[-1][2:6] == group[2:6] and not groups[-1][7]:
            groups[-1][1] += 1
        else:
            groups.append(group)
        counts[op-1] += 1
        hashes[op-1] = digest(hashes[op-1], [row['frame'], *row['after'], row['result'] if op == 1 else 0])
        if row['before'][4:6] != row['after'][4:6]:
            transitions.append([row['frame'], row['after'][4], row['after'][2], row['after'][0], op])
        previous = row['after']
    text = ['-- 第五面原版真实伤害与倒数；外部差量只用于回归，游戏模块不读取本文件。',
            '-- 每组：操作、重复数、原版帧、伤害/暂停、事件标志、击破抑制、外部字段差量、来源。',
            'return {fields='+lua(FIELDS)+',initial='+lua(initial)+',',
            'counts='+lua(counts)+',hashes='+lua(hashes)+',transitions='+lua(transitions)+',calls={']
    text.extend('    '+lua(group)+',' for group in groups)
    text.append('},')
    if args.birth:
        raw = args.birth.read_bytes()
        assert len(raw) == 12 + 0x27A8, '需要一份完整构造返回'
        birth = [[at, struct.unpack_from('<i', raw, 12 + (at ^ 4))[0]]
                 for at in sorted(set(FIELDS + [0x2608, 0x260C, 0x266C, 0x2670, 0x2674]))]
        # 2634/2636/263c 按原宽度读取，不能把相邻半字当成一份长字。
        for row in birth:
            if row[0] in (0x2634, 0x2636, 0x263C):
                row[1] = struct.unpack_from('<h', raw, 12 + (row[0] ^ 6))[0]
        text.append('birth='+lua(birth)+',')
    text.append('}')
    args.output.write_bytes(('\n'.join(text)+'\n').encode('utf-8'))
    print(f'{len(rows)} 次独立调用，{len(groups)} 组输入；受弹/倒数 {counts}，校验 {hashes}，换段 {transitions}')


if __name__ == '__main__':
    main()
