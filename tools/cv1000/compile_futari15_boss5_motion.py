"""把第五面关底完整姿态/移动入口与返回整理为独立状态对照。"""
import argparse
import re
import struct
from pathlib import Path

SIZE = 0x27A8


def fields(module, name):
    text = re.search(name + r'=\{(.*?)\},\n', module, re.S)[1]
    return {int(a): int(b) for a, b in re.findall(r'\{(\d+),([124])\}', text)}


def read(raw, at, width=4):
    return struct.unpack_from({1: '<b', 2: '<h', 4: '<i'}[width], raw, at ^ {1: 7, 2: 6, 4: 4}[width])[0]


def digest(h, row):
    for n in row:
        h = (h * 131 + n) % 16777213
    return h


def lua(value):
    if isinstance(value, str):
        return '"' + value + '"'
    if isinstance(value, dict):
        return '{' + ','.join(f'[{lua(a)}]={lua(b)}' for a, b in sorted(value.items())) + '}'
    if isinstance(value, (tuple, list)):
        return '{' + ','.join(map(lua, value)) + '}'
    return str(value)


def compile_pose(prefix, output):
    module = Path('mod/GAME/th46/boss5_pose.lua').read_text(encoding='utf-8')
    inputs, outputs = fields(module, 'inputFields'), fields(module, 'outputFields')
    covered = {a + i for a, width in outputs.items() for i in range(width)}
    initial, previous, steps, checkpoints, h = None, None, [], {}, 0
    with Path(str(prefix) + '.pose').open('rb') as stream:
        while block := stream.read(32 + SIZE * 2):
            if len(block) != 32 + SIZE * 2:
                raise ValueError('姿态记录被截断')
            frame, ident, caller, dx, camera, px, py, active = struct.unpack_from('>3I4iI', block)
            before, after = block[32:32 + SIZE], block[32 + SIZE:]
            for at in range(SIZE):
                if before[at ^ 7] != after[at ^ 7] and at not in covered:
                    raise ValueError(f'第 {frame} 帧遗漏写入字段 {at:x}')
            values = {a: read(before, a, width) for a, width in inputs.items()}
            if initial is None:
                initial = values.copy()
            delta = [n for a in sorted(values) if previous is not None and values[a] != previous[a] for n in (a, values[a])]
            steps.append([frame, dx, camera, px, py, active, delta])
            h = digest(h, [frame] + [read(after, a, width) for a, width in sorted(outputs.items())])
            if len(steps) % 256 == 0:
                checkpoints[len(steps)] = h
            previous = {a: read(after, a, width) for a, width in inputs.items()}
    if not steps:
        raise ValueError('没有姿态调用')
    checkpoints[len(steps)] = h
    text = [f'-- 第五面原版 {len(steps)} 次完整姿态，每次核对 {len(outputs)} 个输出字段。',
            '-- 首次状态之后只记录两次调用之间的外部改动，游戏模块不读取此回归文件。',
            'return {states=' + str(len(steps)) + ',hash=' + str(h) + ',',
            'initial=' + lua(initial) + ',checkpoints=' + lua(checkpoints) + ',steps={']
    text.extend('    ' + lua(row) + ',' for row in steps)
    text.append('}}')
    output.write_bytes(('\n'.join(text) + '\n').encode('utf-8'))
    print(f'{len(steps)} 次姿态，{len(inputs)} 个输入、{len(outputs)} 个输出，校验 {h}')


def compile_motion(prefix, output, extra=None, birth_path=None):
    module = Path('mod/GAME/th46/boss5_pose.lua').read_text(encoding='utf-8')
    outputs = fields(module, 'outputFields')
    outputs.update({a: 4 for a in (8, 12, 16, 20, 36, 40, 0xF8, 0x128, 0x12C,
                                  0x130, 0x134, 0x138, 0x13C, 0x1DA0,
                                  0x2778, 0x277C, 0x2780, 0x2784)})
    inputs = fields(module, 'inputFields') | outputs | {0x2348: 4, 0xB7C: 4}
    covered = {a+i for a, width in outputs.items() for i in range(width)}
    modes = {0xC1B59C0: 'simple_init', 0xC1B5990: 'simple', 0xC1B5B10: 'wander_init',
             0xC1B5A00: 'wander', 0xC1B5B90: 'move_init', 0xC1B65C0: 'move',
             0xC1B5E50: 'retreat_init', 0xC1B5C90: 'retreat'}
    variables = {
        'wander': [(16, 'targetX', 4), (20, 'targetY', 4), (48, 'turnTarget', 2), (50, 'turning', 1)],
        'move': [(0, 'state', 4), (16, 'targetX', 4), (20, 'targetY', 4), (24, 'clock', 4),
                 (28, 'interval', 4), (32, 'acceleration', 4), (36, 'half', 4)],
        'retreat': [(0, 'state', 4), (4, 'clock', 4), (16, 'targetX', 4), (20, 'targetY', 4)],
    }
    def effective_variables(kind, raw):
        values = {name: read(raw, a, width) for a, name, width in variables.get(kind, [])}
        # 退场第 0 状态尚未写入倒数；原参数池可保留上一任务的无关字节。
        if kind=='retreat' and values['state']==0:
            values['clock']=0
        if kind=='wander' and values['turning']==0:
            values['turnTarget']=0
        return values
    limits = {0xC1B5AC8: 15, 0xC1B5AB8: 15, 0xC1B5AA8: 15, 0xC1B5A88: 15,
              0xC1B5D78: 16, 0xC1B5D84: 16, 0xC1B5D90: 1, 0xC1B5DAE: 8, 0xC1B5DB6: 16}
    extra = extra or prefix
    counters = {}
    effects = {}
    counter_path = Path(str(extra)+'.motion-inputs')
    fx_path = Path(str(extra)+'.motion-fx')
    if counter_path.exists():
        counters = dict(map(int, line.split()) for line in counter_path.read_text().splitlines())
    if fx_path.exists():
        for line in fx_path.read_text().splitlines():
            frame, *row = map(int, line.split())
            effects.setdefault(frame, []).append(row)
    randoms = {}
    for line in Path(str(prefix)+'.motion-randoms').read_text().splitlines():
        frame, caller, value = map(int, line.split())
        if caller not in limits:
            raise ValueError(f'未实现的移动随机调用 {caller:x}')
        randoms.setdefault(frame, []).extend((limits[caller], value))
    initial, previous, steps, checkpoints, h, initial_vars = None, None, [], {}, 0, {}
    with Path(str(prefix)+'.motion').open('rb') as stream:
        while block := stream.read(60+SIZE*2+128):
            if len(block) != 60+SIZE*2+128:
                raise ValueError('移动记录被截断')
            frame, fn, dx, camera, px, py, active, *config, after_fn = struct.unpack_from('>2I4iI7iI', block)
            if fn not in modes or after_fn not in modes:
                raise ValueError(f'尚未移植的移动入口 {fn:x} -> {after_fn:x}，帧 {frame}')
            before, after = block[60:60+SIZE], block[60+SIZE:60+SIZE*2]
            before_vars, after_vars = block[-128:-64], block[-64:]
            for at in range(SIZE):
                if before[at ^ 7] != after[at ^ 7] and at not in covered:
                    raise ValueError(f'第 {frame} 帧遗漏移动写入字段 {at:x}')
            values = {a: read(before, a, width) for a, width in inputs.items()}
            if initial is None:
                initial = values.copy()
                initial_vars = effective_variables(modes[fn], before_vars)
            patch = [n for a in sorted(values) if previous is not None and values[a] != previous[a] for n in (a, values[a])]
            if modes[fn]=='retreat' and frame not in counters:
                raise ValueError(f'第 {frame} 帧缺少原版逻辑计数')
            fx = effects.get(frame, [])
            # 0x0c1b5b10 不写这三个字节；它们是共享参数池中其它任务留下的外部输入。
            memory = [read(after_vars,48,2),read(after_vars,50,1)] if modes[fn]=='wander_init' else []
            steps.append([frame, modes[fn], modes[after_fn], dx, camera, px, py, active, config, patch,
                          randoms.pop(frame, []), counters.get(frame, 0), fx, memory])
            h = digest(h, [frame, after_fn]+[read(after, a, width) for a, width in sorted(outputs.items())]
                       + list(effective_variables(modes[after_fn], after_vars).values())
                       + [len(fx)] + [n for row in fx for n in row])
            if len(steps) % 128 == 0:
                checkpoints[len(steps)] = h
            previous = {a: read(after, a, width) for a, width in inputs.items()}
    if not steps or randoms:
        raise ValueError('没有完整的移动调用或有未使用的随机返回')
    checkpoints[len(steps)] = h
    text = ['-- 第五面原版完整移动槽；两次调用之间只注入外部控制改动。',
            '-- 游走初始化另记录共享参数池的三个未写字节，不含预计算位置与速度。',
            f'return {{states={len(steps)},hash={h},initial='+lua(initial)+',initialVars='+lua(initial_vars)+',',
            'fields='+lua(sorted(outputs.items()))+',variables='+lua({kind: [r[1] for r in rows] for kind, rows in variables.items()})+',',
            'checkpoints='+lua(checkpoints)+',steps={']
    text.extend('    '+lua(row)+',' for row in steps)
    text.append('},')
    if birth_path:
        birth = birth_path.read_bytes()
        assert len(birth)==12+SIZE
        raw = birth[12:]
        indices = [a for a in range(0, SIZE, 4) if a not in (0, 4, 24, 0x25A0)]
        birth_hash = digest(0, [n for a in indices for n in (a, read(raw, a))])
        text.append('birthHash='+str(birth_hash)+',birthFields='+lua(indices)+',')
    text.append('}')
    output.write_bytes(('\n'.join(text)+'\n').encode('utf-8'))
    print(f'{len(steps)} 次移动，{len(outputs)} 个输出，校验 {h}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--mode', choices=('pose', 'motion'), default='pose')
    parser.add_argument('--inputs', type=Path, help='原版逻辑计数与粒子接口的额外记录前缀')
    parser.add_argument('--birth', type=Path)
    args = parser.parse_args()
    if args.mode=='pose':compile_pose(args.prefix, args.output)
    else:compile_motion(args.prefix, args.output, args.inputs, args.birth)


if __name__ == '__main__':
    main()
