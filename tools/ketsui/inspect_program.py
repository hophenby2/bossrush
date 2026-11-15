"""读取《绊地狱》解密后的关卡生成表、路径入口及对象回调。"""
import argparse
import csv
from dataclasses import dataclass
from pathlib import Path
import struct


PROGRAM_SIZE = 0x200000
STAGE_TABLE = 0x0CF64C
ENEMY_HANDLERS = (0x0CFD86, 0x0F4730)
BULLET_TABLE = 0x0F8250


@dataclass(frozen=True)
class Stage:
    records: int
    path_index: int
    path_base: int


@dataclass(frozen=True)
class Spawn:
    address: int
    major: int
    minor: int
    enemy: int
    flags: int
    params: int
    path_id: int
    path: int
    offset_x: int
    offset_y: int
    count_parts: int
    init: int
    update: int


def word(program, address):
    return struct.unpack_from('>H', program, address)[0]


def pointer(program, address):
    return struct.unpack_from('>I', program, address)[0]


def read_program(path):
    # 旧采集文件也以解密后的 2 MiB 程序开头。
    with path.open('rb') as stream:
        program = stream.read(PROGRAM_SIZE)
    if (len(program) != PROGRAM_SIZE or program[:8] != bytes.fromhex('00820000000a693a')
            or program[0x0CF764:0x0CF768] != bytes.fromhex('21490012')
            or program[0x0F75E8:0x0F75EE] != bytes.fromhex('206e00224e90')):
        raise ValueError('需要 2003/01/01 Master Ver. 从 68000 地址 0 读出的解密程序')
    return program


def stages(program):
    for index in range(5):
        yield Stage(*struct.unpack_from('>III', program, STAGE_TABLE + 16 * index))


def spawns(program, stage):
    # 0xcf6ec 同时比较两级关卡计数。偏移低字要保留 68000 的进位语义。
    for address in range(stage.records, stage.path_index, 12):
        major = word(program, address)
        if major == 0xFFFF:
            return
        minor, enemy, flags, packed, offset_x, offset_y = struct.unpack_from(
            '>HBBHhh', program, address + 2)
        path_id = packed & 0xFFF
        path = stage.path_base + struct.unpack_from('>h', program, stage.path_index + 2 * path_id)[0]
        handlers = ENEMY_HANDLERS[enemy >> 7] + 8 * (enemy & 0x7F)
        count_parts, update = struct.unpack_from('>II', program, handlers)
        init = count_parts + 8
        yield Spawn(address, major, minor, enemy, flags, packed >> 12, path_id, path,
                    offset_x, offset_y, count_parts, init, update)
    raise ValueError(f'关卡表 {stage.records:#08x} 缺少结束标记')


def bullet_descriptor(program, kind):
    maximum = word(program, 0x0F8378)
    if not 0 <= kind <= maximum:
        raise ValueError(f'敌弹类型应在 0 到 {maximum:#x} 之间')
    descriptor = pointer(program, BULLET_TABLE + 4 * kind)
    return descriptor, pointer(program, descriptor + 0x12), pointer(program, descriptor + 0x16)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path, help='logic_probe.lua 导出的 program.bin')
    parser.add_argument('--stage', type=int, choices=range(1, 6))
    parser.add_argument('--csv', type=Path, help='导出关卡表及其路径和回调地址')
    parser.add_argument('--bullet', type=lambda value: int(value, 0), help='查看原版敌弹描述符')
    args = parser.parse_args()
    program = read_program(args.program)
    rows = []
    for number, stage in enumerate(stages(program), 1):
        if args.stage and number != args.stage:
            continue
        entries = list(spawns(program, stage))
        print(f'第 {number} 面  生成表 {stage.records:#08x}  路径索引 {stage.path_index:#08x}'
              f'  路径基址 {stage.path_base:#08x}  记录 {len(entries)} 条')
        for entry in entries:
            rows.append((number, f'{entry.address:#08x}', entry.major, entry.minor, f'{entry.enemy:#04x}',
                         f'{entry.flags:#04x}', f'{entry.params:#03x}', f'{entry.path_id:#05x}', f'{entry.path:#08x}',
                         entry.offset_x, entry.offset_y, f'{entry.count_parts:#08x}', f'{entry.init:#08x}',
                         f'{entry.update:#08x}'))
    if args.csv:
        with args.csv.open('w', encoding='utf-8-sig', newline='') as stream:
            writer = csv.writer(stream)
            writer.writerow(('关卡', '记录地址', '主计数', '子计数', '敌机类型', '分配标志', '分配参数',
                             '路径编号', '路径地址', '坐标高字偏移', '坐标低字偏移',
                             '部件数例程', '初始化', '更新'))
            writer.writerows(rows)
    if args.bullet is not None:
        desc, init, update = bullet_descriptor(program, args.bullet)
        print(f'敌弹 {args.bullet:#04x}  描述符 {desc:#08x}  可选创建回调 {init:#08x}'
              f'  初始逐帧回调 {update:#08x}')


if __name__ == '__main__':
    main()
