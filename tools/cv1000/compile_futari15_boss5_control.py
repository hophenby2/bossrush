"""整理第五面独立主任务入口/返回；只输出已移植入口，未知写入立即失败。"""
import argparse
import sys
import struct
from collections import defaultdict
from pathlib import Path

sys.dont_write_bytecode = True
from compile_futari15_boss5_motion import lua, read

SIZE = 0x27A8
RECORD = 28 + SIZE * 2 + 80 + 256
MODES = {0xC1B6990: 'entry_init', 0xC1B6750: 'entry',
         0xC1B95F0: 'pattern_init', 0xC1B9650: 'pattern',
         0xC1BA520: 'second_init', 0xC1BA580: 'second',
         0xC1BAE60: 'third_init', 0xC1BAEB0: 'third',
         0xC1B6DF0: 'change1_init', 0xC1B69F0: 'change1',
         0xC1B7400: 'change2_init', 0xC1B6E80: 'change2',
         0xC1B9050: 'defeat_init', 0xC1B7470: 'defeat'}
FIELDS = [16, 20, 28, 64, 68, 0x1D10, 0x1D64, 0x1C68, 0x1CBC, 0x2788, 0x278C, 0x2790]
# c1bbac0 的两个零件根对象句柄由外部工厂持有，主任务不解引用其数值。
EXTERNAL = {0x104, 0x108}
MOTION = {0xC1B59C0: 'simple_init', 0xC1B5B90: 'move_init', 0xC1B5A00: 'wander',0xC1B5E50:'retreat_init'}


def operation(values, parts=None, state=None):
    _, helper, caller, a, b, c, d, *tail = values
    result = tail[-1]
    config = tail[:8]
    if helper == 0xC0680B0:
        state['weapon'] = b
        return None
    if helper == 0xC06B920:
        return ['weapon_active', state['weapon']], result
    if helper == 0xC075BD0:
        return ['root_field96', b], None
    if helper == 0xC0966D0:
        return ['particle', a, b, c, d], result
    if helper in (0xC096830,0xC096930,0xC096870,0xC096890,0xC0968B0,0xC0968D0):
        return ['particle_set', helper, a, b] + ([c] if helper==0xC096830 else []), None
    if helper == 0xC0992C0:
        return ['fragment', a, b, c, d], result
    if helper == 0xC099380:
        return ['fragment_angle', a, b], None
    if helper == 0xC099C90:
        return ['burst', a, b, c, d, tail[8], tail[9]], None
    if helper == 0xC1B92F0:
        item=parts.pop(0);assert item[:3]==values[:3]
        return ['parts','batch']+item[3:],None
    if helper in (0xC1BBF40,0xC1BBEA0,0xC1BBFE0):
        return ['parts_control',helper],None
    if helper in (0xC10F9B0,0xC10EE50,0xC10ED70,0xC10EFD0,0xC068D00):
        return ['service',helper],None
    if helper in (0xC0689E0,0xC068A00,0xC09C4C0):
        return ['service',helper,a],None
    if helper == 0xC1B45F0:
        return ['view_flag',b,c],None
    if helper == 0xC076850:
        return ['retire'],None
    if helper == 0xC078470:
        return ['switch', MODES[c]], None
    if helper == 0xC41B4A4:
        return ['signal', 'boss_scene', a], None
    if helper in (0xC41B4A0, 0xC41B49C, 0xC41B498):
        return ['signal', {0xC41B4A0: 'phase_one', 0xC41B49C: 'phase_two', 0xC41B498: 'defeat'}[helper], a], None
    if helper in (0xC1B9160, 0xC1B9440):
        item = parts.pop(0)
        assert item[:3] == values[:3]
        return ['parts', 'scatter' if helper == 0xC1B9160 else 'burst'] + item[3:], None
    if helper == 0xC0631F0:
        if caller >= 0xC1B9160:
            return None  # 爆件公共工厂内部的随机数属于该工厂，主任务只提交其调用参数。
        return ['random', a], result
    if helper == 0xC10EF10:
        return ['command', 5, 95, 50, 35, 0], None
    if helper in (0xC110A10, 0xC110A30, 0xC1BBBC0, 0xC1BBD30, 0xC1BBDA0):
        if helper in (0xC110A10, 0xC110A30):
            return ['command', 6, 217 if helper == 0xC110A10 else 218, 125, 254, 2], None
        return ['parts_control', helper], None
    if helper == 0xC0768F0:
        if caller >= 0xC1B9160:
            return None
        return ['root_field12'], result
    if helper == 0xC076870:
        return ['player_field80'], result
    if helper == 0xC093E90:
        return ['reward', 'create', a, b, c, d, tail[8]], None
    if helper == 0xC06B370:
        return ['reward', 'resolve', a, b, c], None
    if helper == 0xC1B4650:
        return ['signal', 'open_view'], None
    if helper == 0xC075D30:
        assert caller == 0xC1B6818
        return None
    if helper == 0xC1BBAC0:
        return ['signal', 'opening_parts'], None
    if helper == 0xC10EA20:
        return ['signal', 'stage_scroll', a], None
    if helper == 0xC068150:
        return ['signal', 'activate_boss', b], None
    if helper == 0xC1B06F0:
        return ['collision', bool(b)], None
    if helper == 0xC1B0250:
        return ['box', 3, bool(b)], None
    if helper in (0xC078130, 0xC077EA0):
        args = ['spawn', 'task' if helper == 0xC078130 else 'gun', b]
        if b in (0xC1BD400, 0xC1BD0A0, 0xC1BD130, 0xC1BD1C0, 0xC1BD250, 0xC1BD4A0):
            args.append(config[0])
        return args, result
    if helper in (0xC078330, 0xC0780A0):
        return ['alive', 'task' if helper == 0xC078330 else 'gun', b], bool(result)
    if helper == 0xC078810:
        assert b == 0xC1B5A00
        return ['motion_is', MOTION[b]], bool(result)
    if helper == 0xC078730:
        return ['motion', 'ensure', MOTION[b]] + (config[:5] if c else []), None
    if helper == 0xC0786A0:
        if caller in (0xC1B6BDE, 0xC1B723C, 0xC1B728E, 0xC1B730E):
            return ['motion', 'replace', MOTION[b]] + config[:5], None
        return None  # ensure 内部调用 replace，原生接口已经负责此语义。
    if helper == 0xC0783F0:
        return ['control', MODES[b]], result
    if helper == 0xC0784E0:
        return ['remove'], None
    raise ValueError(f'未知挂载接口 {helper:x}，调用位置 {caller:x}')


def encode(value):
    if value is None:
        return 'nil'
    if isinstance(value, bool):
        return str(value).lower()
    if isinstance(value, (list, tuple)):
        return '{' + ','.join(map(encode, value)) + '}'
    return lua(value)


def compile_reference(prefix, output, phase):
    selected = {'first': {'entry_init', 'entry', 'pattern_init', 'pattern'},
                'second': {'second_init', 'second'}, 'third': {'third_init', 'third'},
                'change1': {'change1_init', 'change1', 'second_init'},
                'change2': {'change2_init', 'change2', 'third_init'},
                'defeat': {'defeat_init','defeat'}}[phase]
    widths = {a: 4 for a in FIELDS}
    external = EXTERNAL.copy()
    if phase.startswith('change')or phase=='defeat':
        widths.update({a: 4 for a in (8, 12, 32, 36, 40, 0x128, 0x12C, 0x1DD0, 0x1DD4,
                                      0x20C4, 0x20C8, 0x2118, 0x211C, 0x1F74, 0x1F78,
                                      0x1FC8, 0x1FCC, 0x1D0C, 0x21F8)})
        widths.update({a: 4 for a in range(0x2694, 0x26BC, 4)})
        widths.update({0x2634: 2, 0x2636: 2, 0x263C: 2})
        external.update((0x10C, 0x110, 0x114, 0x118))
    if phase=='defeat':
        widths.pop(0x1D10)
        widths.update({a:4 for a in (48,52,56,0x140,0x1DB4,0x201C,0x2020,0x2070,0x2074,
                                    0x21C0,0x21C4,0x2618,0x2678,0x2348)})
        widths[0x1D12]=2
        widths.update({a:4 for a in range(0x26BC,0x26D0,4)})
        external.update((0x11C,0x120,0x124))
    field_list = sorted(widths)
    ops = defaultdict(list)
    for line in Path(str(prefix) + '.control-ops').read_text().splitlines():
        values = list(map(int, line.split()))
        assert len(values) == 24
        ops[values[0]].append(values)
    contexts = {}
    context_path = Path(str(prefix) + '.control-context')
    if context_path.exists():
        for line in context_path.read_text().splitlines():
            ident, *values = map(int, line.split())
            assert len(values) == 14
            contexts[ident] = values
    parts = defaultdict(list)
    counters = {}
    counter_path=Path(str(prefix)+'.control-counter')
    if counter_path.exists():
        counters=dict(tuple(map(int,line.split()))for line in counter_path.read_text().splitlines())
    parts_path = Path(str(prefix) + '.control-parts')
    if parts_path.exists():
        for line in parts_path.read_text().splitlines():
            values = list(map(int, line.split()))
            assert len(values) == 10
            parts[values[0]].append(values)
    covered = {a + i for a, width in widths.items() for i in range(width)}
    covered.update(a + i for a in external for i in range(4))
    previous, initial, steps, active = None, None, [], {}
    calls, external_writes = 0, 0
    with Path(str(prefix) + '.control').open('rb') as stream:
        while record := stream.read(RECORD):
            if len(record) != RECORD:
                raise ValueError('主任务记录被截断')
            frame, ident, slot, handle, before_mode, after_mode, enabled = struct.unpack_from('>7I', record)
            if MODES.get(before_mode) not in selected:
                if steps:
                    break
                continue
            before = record[28:28 + SIZE]
            after = record[28 + SIZE:28 + SIZE * 2]
            for a in range(SIZE):
                if before[a ^ 7] != after[a ^ 7] and a not in covered:
                    raise ValueError(f'{frame} 帧 {before_mode:x} 未覆盖写入 {a:x}')
            external_writes += sum(read(before, a) != read(after, a) for a in external)
            values = {a: read(before, a, width) for a, width in widths.items()}
            if initial is None:
                initial = values.copy()
            patch = [n for a in field_list if previous is not None and previous[a] != values[a]
                     for n in (a, values[a])]
            variables = record[-128:]
            old_variables = record[-256:-128]
            initialized = active.setdefault(handle, set())
            if MODES[before_mode].endswith('_init'):
                initialized.update({0xC1B6990: (0, 4, 8), 0xC1B6DF0: (0,), 0xC1B7400: (0, 36),
                                    0xC1B9050:(0,56)}.get(before_mode, (0, 4)))
            elif enabled:
                limit = 60 if phase=='defeat'else 44 if phase.startswith('change') else 24
                initialized.update(a for a in range(0, limit, 4) if read(old_variables, a) != read(variables, a))
                for a in range(limit, 64):
                    assert old_variables[a ^ 7] == variables[a ^ 7], f'未覆盖私有字段 {a}'
            # 回收后原槽的参数指针已置零；只核对仍有效且初始化过的私有项。
            private = [n for a in sorted(initialized) if enabled for n in (a, read(variables, a))]
            requests, sprites, alpha, local_state = [], [], {}, {}
            callback_ops=ops.pop(ident,[])
            # 分配结果取第一次实际使用它的 setter 的 r4；深层绘图调用会让通用返回栈探针误报 r0。
            # 这里读取的是原版随后使用的指针，不用移植代码生成句柄或按地址猜测。
            for at,values in enumerate(callback_ops):
                setter={0xC0966D0:0xC096930,0xC0992C0:0xC099380}.get(values[1])
                if setter is not None:
                    for following in callback_ops[at+1:]:
                        assert following[1]!=values[1],'分配结果没有对应的首次使用'
                        if following[1]==setter:
                            values[-1]=following[3];break
                    else:raise ValueError('分配结果缺少原版 setter 实参')
            for values in callback_ops:
                if values[1]==0xC063740:
                    i=len(sprites)
                    assert values[3:7]==[368,(i%8)*2**21,(i//8)*2**21,135]
                    sprites.append(values[-1]);continue
                if values[1]==0xC05E424:
                    assert values[4:6]==[2,3] and values[15]==0
                    alpha[values[3]]=values[6];continue
                r=operation(values,parts[ident],local_state)
                if r is not None:requests.append(r)
            if sprites:
                assert len(sprites)==80
                opacity=read(after,56)%256
                assert len(alpha)==80 and all(n==opacity for n in alpha.values())
                requests.append((['overlay',opacity],None))
            assert not parts[ident]
            if phase == 'change1' and before_mode == 0xC1B6DF0:
                assert contexts[ident][-1] == 37
                requests.insert(1, (['hit_effect', 1, 37], None))
            if phase.startswith('change')or phase=='defeat':
                # 全局标志和第一盒效果号另有独立快照，不能只比较自己归一化后的接口。
                context = contexts[ident]
                expected = context[:7].copy()
                names = {'defeat': 2, 'phase_two': 3, 'phase_one': 4, 'boss_scene': 5}
                for args, _ in requests:
                    if args[0] == 'signal' and args[1] in names:
                        expected[names[args[1]]] = args[2]
                    elif args[0] == 'hit_effect':
                        expected[6] = args[2]
                    elif args[0]=='root_field96':expected[1]=args[1]
                assert expected == context[7:], f'{frame} 帧外部标志/判定元数据遗漏写入'
            calls += len(requests)
            steps.append([frame, handle, slot + 1, MODES[before_mode], MODES[after_mode], bool(enabled),
                          patch, [read(after, a, widths[a]) for a in field_list], private, requests,
                          contexts.get(ident, [83])[0],counters.get(ident)])
            previous = {a: read(after, a, width) for a, width in widths.items()}
    assert steps and calls
    same_frame = sum(a[0] == b[0] for a, b in zip(steps, steps[1:]))
    lines = ['-- 原版第五面主任务的独立入口、返回和接口调用。',
             '-- 仅两次调用之间的本体改动与子任务查询结果作为外部输入；不保存供游戏使用的轨迹。',
             f'return {{states={len(steps)},calls={calls},sameFrame={same_frame},externalHandles={external_writes},',
             'fields=' + lua(field_list) + ',initial=' + lua(initial) + ',steps={']
    lines.extend('    ' + encode(row) + ',' for row in steps)
    lines.append('}}')
    output.write_bytes(('\n'.join(lines) + '\n').encode('utf-8'))
    print(f'{len(steps)} 次主任务、{calls} 次接口；{external_writes} 个外部零件句柄写入单独归属工厂')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--phase', choices=('first', 'second', 'third', 'change1', 'change2','defeat'), default='first')
    args = parser.parse_args()
    compile_reference(args.prefix, args.output, args.phase)
