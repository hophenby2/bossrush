"""按 Futari 1.5 第一面原始精灵表，从显存导出道中图集。"""

import argparse
from pathlib import Path

import numpy as np
from PIL import Image

from analyze import decode_sprite


DIRECTIONS = 17
WINGS = 4
CELL = 80
BODY_SPRITE = 0x26FF
SHOT_SPRITE = 0x06D3
FLASH_SPRITE = 0x0A4B
WORM_SHOT_SPRITE = 0x093B
CANCEL_SPRITE = 0x0A9F
SHOT_CELL = 32


def export(ram, vram, output, worm=False, midboss=False):
    memory = ram.read_bytes()
    if len(memory) != 0x800000:
        raise ValueError('工作 RAM 必须是 8 MiB 的 SH-3 保存项')
    pixels = np.memmap(vram, dtype='<u4', mode='r', shape=(4096, 8192))

    def byte(address):
        return memory[address ^ 7]

    def word(address):
        return byte(address) * 256 + byte(address + 1)

    def signed_byte(address):
        value = byte(address)
        return value - 256 if value & 128 else value

    def sprite(index):
        # 0x0c063740 解码的十字节精灵描述与 VRAM 页索引。
        record = 0x20BF14 + 10 * index
        page = word(0x051854 + 2 * word(record)) - 1
        height, width = word(record + 4), word(record + 6)
        sx = word(0x052420 + page) + 256 - byte(record + 3) - width
        sy = word(0x052422 + page) + byte(record + 2)
        return decode_sprite(pixels, sx, sy, width, height, 0x100)

    if midboss:
        # 0x0c11f480 共用同一组锚点绘制翅、腹部与头部；破损翅另有两个精灵号。
        indices = [*range(0x3DBD, 0x3E0F), 0x4373, 0x4374]
        width, height, columns = 160, 112, 12
        sheet = Image.new('RGBA', (columns * width, 7 * height))
        for slot, index in enumerate(indices):
            art = sprite(index)
            sheet.alpha_composite(art, (slot % columns * width + (width - art.width) // 2,
                                        slot // columns * height + (height - art.height) // 2))
        sheet.save(output)
        return

    if worm:
        # 0x0c2dc9b0 与 0x0c2dcaa0 共用按朝向排列的贴图，锚点在 0x0c2dbc04 等表。
        banks = [(0x2901, 33, 0x2dbc04), (0x2922, 33, 0x2dbc46),
                 (0x2943, 17, 0x2dbc88), (0x2954, 9, 0x2dbcaa),
                 (0x295d, 1, None), (0x3dbb, 1, None)]
        cell = 144
        sheet = Image.new('RGBA', (12 * cell, 8 * cell))
        slot = 0
        for first, count, anchor in banks:
            for direction in range(count):
                art = sprite(first + direction)
                dx = signed_byte(anchor + 2 * direction) if anchor is not None else 0
                dy = signed_byte(anchor + 2 * direction + 1) if anchor is not None else 0
                x, y = slot % 12 * cell, slot // 12 * cell
                sheet.alpha_composite(art, (x + (cell - art.width) // 2 + dx,
                                            y + (cell - art.height) // 2 - dy))
                slot += 1
        sheet.save(output)
        return

    sheet = Image.new('RGBA', (DIRECTIONS * CELL, WINGS * (CELL + 3 * SHOT_CELL)))
    for direction in range(DIRECTIONS):
        for wing in range(WINGS):
            index = direction * WINGS + wing
            art = sprite(BODY_SPRITE + index)
            anchor = 0x2DAFB4 + 2 * index
            dx, dy = signed_byte(anchor), signed_byte(anchor + 1)
            # 裁片已经旋转到 LuaSTG 的方向。以原程序的绘制锚点为单元中心。
            sheet.alpha_composite(art, (direction * CELL + (CELL - art.width) // 2 + dx,
                                        wing * CELL + (CELL - art.height) // 2 - dy))
            # 0x0c06f0a0 使用朝向折叠后的 17 列，每列四帧。
            for row, bank in enumerate((SHOT_SPRITE, FLASH_SPRITE, WORM_SHOT_SPRITE)):
                shot = sprite(bank + index)
                sheet.alpha_composite(shot, (direction * SHOT_CELL + (SHOT_CELL - shot.width) // 2,
                                             CELL * WINGS + (row * WINGS + wing) * SHOT_CELL
                                             + (SHOT_CELL - shot.height) // 2))
    # 子弹被击中后切到 0x0c06e6f0 设定的 16 帧消弹图，放在弹图右侧。
    for phase in range(16):
        sheet.alpha_composite(sprite(CANCEL_SPRITE + phase), (DIRECTIONS * SHOT_CELL + phase * 16, 576))
    sheet.save(output)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ram', type=Path)
    parser.add_argument('vram', type=Path)
    parser.add_argument('output', type=Path)
    bank = parser.add_mutually_exclusive_group()
    bank.add_argument('--worm', action='store_true', help='导出两只蜈蚣共用的身体及阴影')
    bank.add_argument('--midboss', action='store_true', help='导出中 Boss 身体的原始裁片')
    args = parser.parse_args()
    export(args.ram, args.vram, args.output, args.worm, args.midboss)
