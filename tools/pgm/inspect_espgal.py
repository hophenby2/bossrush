"""读取 Espgaluda V100 的关卡生成记录、敌机入口和敌弹模板。"""

import argparse
import csv
import hashlib
import struct
from pathlib import Path


PROGRAM_SIZE = 0x200000
PROGRAM_SHA256 = 'a7a90b60daaff9c34510b740364dc99df907a92ad8934f99a75e8c12b1bec08a'
STAGE_TABLE = 0x14EC4C
ENEMY_TABLES = (0x14F3AE, 0x16D6D8)
BULLET_TABLE = 0x173F86
BULLET_LIMIT = 0x17401E
SPAWN = struct.Struct('>HHBBHI')
BULLET = struct.Struct('>HhhIHHHHII')


def read_program(path):
    with path.open('rb') as source:
        data = source.read(PROGRAM_SIZE)
    if hashlib.sha256(data).hexdigest() != PROGRAM_SHA256:
        raise ValueError('需要 probe_espgal.lua 导出的 V100 解密程序')
    return data


def enemy_callbacks(data, kind):
    # 0x14ef6c 调用第一项取得部件数，入口后八字节初始化部件。0x14ef84 安装第二项。
    table = ENEMY_TABLES[kind // 0x80] + (kind % 0x80) * 8
    allocate, update = struct.unpack_from('>II', data, table)
    return allocate, allocate + 8, update


def stage_rows(data, stage):
    records, path_index, path_base = struct.unpack_from('>III', data, STAGE_TABLE + (stage - 1) * 16)
    # 0x14ed02 核对两个卷轴计数。0x14ed72 将记录的最后四字节写入槽 +0x40。
    for address in range(records, path_index, SPAWN.size):
        major, minor, kind, flags, path_word, offset = SPAWN.unpack_from(data, address)
        if major == 0xFFFF:
            if address + SPAWN.size != path_index:
                raise ValueError(f'第 {stage} 个生成表提前结束')
            return
        index = path_word & 0xFFF
        entry = path_index + index * 2
        if entry >= path_base:
            raise ValueError(f'第 {stage} 个生成表的路径编号 {index:#x} 越界')
        path = path_base + struct.unpack_from('>h', data, entry)[0]
        allocate, init, update = enemy_callbacks(data, kind)
        yield address, major, minor, kind, flags, path_word, path, offset, allocate, init, update
    raise ValueError(f'第 {stage} 个生成表缺少结束字')


def bullet_rows(data):
    # 0x17103e 将弹种限制在表内。0x1710d4 登记逐帧回调，然后执行可选的发射设置。
    count = struct.unpack_from('>H', data, BULLET_LIMIT)[0] + 1
    for kind, (address,) in enumerate(struct.iter_unpack('>I', data[BULLET_TABLE:BULLET_TABLE + count * 4])):
        yield kind, address, *BULLET.unpack_from(data, address)


def verify_opening(trace, rows, templates):
    expected = {(row[3], row[6]): row[-1] for row in rows}
    with trace.open(newline='', encoding='ascii') as source:
        events = list(csv.reader(source, delimiter='\t'))
    attached = {}
    for stream, _, *fields in events:
        if stream == 'enemy':
            kind, path, writer, callback, part = map(lambda value: int(value, 16), fields)
            if writer == 0x14EF84 and (kind, path) in expected:
                if callback != expected[kind, path]:
                    raise ValueError(f'敌机 {kind:#x} 的回调和 ROM 不符')
                attached.setdefault(kind, part)
    parent = attached.get(0x32)
    if not parent or not {0x06, 0x07}.issubset(attached):
        raise ValueError('回调日志须覆盖一面 0x06、0x07、0x32 的开场对象')
    birth = next((i for i, row in enumerate(events) if row[0] == 'bullet' and int(row[2], 16) == parent), None)
    if birth is None or birth + 1 == len(events):
        raise ValueError('开场地炮的第一发未分配')
    first, following = events[birth:birth + 2]
    if (int(first[3], 16) != 0x1710D4 or int(first[4], 16) != templates[0][-1]
            or following != ['bullet', first[1], first[2], '1740a0', '1740b4']):
        raise ValueError('开场地炮弹未通过 ROM 模板切换到逐帧运动回调')
    print(f'开场地炮从 {parent:#x} 发弹，原版第 {first[1]} 帧挂载初始及逐帧运动回调')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path)
    parser.add_argument('--spawns', type=Path, help='导出生成表和敌机回调')
    parser.add_argument('--bullets', type=Path, help='导出敌弹模板和回调')
    parser.add_argument('--verify-opening', type=Path, help='用探针日志核对开场回调')
    args = parser.parse_args()
    data = read_program(args.program)
    stages = [list(stage_rows(data, number)) for number in range(1, 7)]
    bullets = list(bullet_rows(data))
    for number, rows in enumerate(stages, 1):
        print(f'生成表 {number}：{len(rows)} 条指令，{len({row[3] for row in rows})} 种敌机')
    print(f'敌弹模板表：{len(bullets)} 项')
    if args.verify_opening:
        verify_opening(args.verify_opening, stages[0], bullets)
    if args.spawns:
        with args.spawns.open('w', newline='', encoding='utf-8') as output:
            writer = csv.writer(output)
            writer.writerow(('生成表', '记录地址', '主卷轴', '副卷轴', '敌机类型', '标志', '路径字',
                             '路径地址', '坐标偏移', '分配', '初始化', '逐帧更新'))
            for number, rows in enumerate(stages, 1):
                writer.writerows((number, *map(hex, row)) for row in rows)
    if args.bullets:
        with args.bullets.open('w', newline='', encoding='utf-8') as output:
            writer = csv.writer(output)
            writer.writerow(('模板编号', '模板地址', '标志', '纵偏移', '横偏移', '图像', '尺寸',
                             '绘制属性', '基础速度索引', '变换索引', '发射设置', '逐帧更新'))
            writer.writerows(map(hex, row) for row in bullets)


if __name__ == '__main__':
    main()
