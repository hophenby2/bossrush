"""读取《怒首领蜂大往生》V101 解密程序中的关卡记录和对象回调。"""

import argparse
import csv
import hashlib
import struct
from pathlib import Path


PROGRAM_SIZE = 0x300000
PROGRAM_SHA256 = 'de434aaee487ad2cafb89b74d316bb79bb712e899a8dc8c16122a1465749ad83'
STAGE_TABLE = 0x161BC4
ENEMY_TABLES = (0x1660B0, 0x17CCD8)
BULLET_TEMPLATES = 0x180152
BULLET_SETUP = 0x17FE26
BULLET_INIT = 0x1807E4


def read_program(path):
    with path.open('rb') as source:
        data = source.read(PROGRAM_SIZE)
    if hashlib.sha256(data).hexdigest() != PROGRAM_SHA256:
        raise ValueError('需要 ShmupMAME 从 68000 地址 0 读出的日版 V101 解密程序')
    return data


def word(data, address):
    return struct.unpack_from('>H', data, address)[0]


def pointer(data, address):
    return struct.unpack_from('>I', data, address)[0]


def enemy_callbacks(data, kind):
    # 0x161e84 调用分配回调。0x161eba 挂上逐帧回调，0x161ede 初始化部件。
    table = ENEMY_TABLES[kind // 0x80]
    return struct.unpack_from('>II', data, table + (kind % 0x80) * 8)


def stage_rows(data, stage):
    records, path_index, path_base = struct.unpack_from('>III', data, STAGE_TABLE + (stage - 1) * 16)
    for address in range(records, path_index, 8):
        counter, parameter, kind, flags, path_word = struct.unpack_from('>HHBBH', data, address)
        if counter == 0xFFFF:
            return
        # 0x161c4c 只比较主卷轴计数。记录第二字写到槽 +0x0a。
        # 0x145fd8 通过 IGS027A 取回 0x161c3a 为当前面登记的路径基址。
        index = path_word & 0xFFF
        offset = struct.unpack_from('>h', data, path_index + 2 * index)[0]
        init, update = enemy_callbacks(data, kind)
        yield address, counter, parameter, kind, flags, index, path_base + offset, init, update
    raise ValueError(f'第 {stage} 面的生成表缺少结束字')


def bullet_rows(data):
    # 0x18005c 把模板写入 0x40 字节弹槽。初始化附加字段由 0x17fdfc 再分派。
    for kind in range(36):
        address = pointer(data, BULLET_TEMPLATES + kind * 4)
        setup = pointer(data, BULLET_SETUP + kind * 4)
        init = pointer(data, BULLET_INIT + kind * 4)
        flags, draw_h, draw_l, image, size, parameter, speed, with_setup, extra = struct.unpack_from(
            '>HhhIHHHHH', data, address
        )
        yield kind, address, flags, draw_h, draw_l, image, size, parameter, speed, extra, setup if with_setup else 0, init


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path)
    parser.add_argument('--spawns', type=Path, help='导出五面的生成记录为 CSV')
    parser.add_argument('--bullets', type=Path, help='导出原版弹体模板和回调为 CSV')
    args = parser.parse_args()
    data = read_program(args.program)
    stages = [list(stage_rows(data, stage)) for stage in range(1, 6)]
    bullets = list(bullet_rows(data))
    for stage, rows in enumerate(stages, 1):
        print(f'第 {stage} 面 {len(rows)} 条生成指令，{len({row[3] for row in rows})} 种敌机类型')
    print(f'{len(bullets)} 种原版弹体模板')
    if args.spawns:
        with args.spawns.open('w', newline='', encoding='utf-8') as output:
            writer = csv.writer(output)
            writer.writerow(('关卡', '记录地址', '卷轴计数', '槽参数', '类型', '标志',
                             '路径编号', '路径地址', '初始化', '逐帧更新'))
            for stage, rows in enumerate(stages, 1):
                writer.writerows((stage, *(hex(value) for value in row)) for row in rows)
    if args.bullets:
        with args.bullets.open('w', newline='', encoding='utf-8') as output:
            writer = csv.writer(output)
            writer.writerow(('类型', '模板地址', '标志', '纵偏移', '横偏移', '图像', '尺寸',
                             '参数', '基础速度索引', '附加字', '发射参数初始化', '弹体首帧回调'))
            writer.writerows(map(hex, row) for row in bullets)


if __name__ == '__main__':
    main()
