"""按 Futari 1.5 第一面原始精灵表，从显存导出道中图集。"""

import argparse
import re
from hashlib import blake2b
from pathlib import Path

import numpy as np
from PIL import Image, ImageOps

from analyze import decode_sprite


DIRECTIONS = 17
WINGS = 4
CELL = 80
BODY_SPRITE = 0x26FF
SHOT_SPRITE = 0x06D3
FLASH_SPRITE = 0x0A4B
WORM_SHOT_SPRITE = 0x093B
THIN_SHOT_SPRITE = 0x0C28
CANCEL_SPRITE = 0x0A9F
SHOT_CELL = 32
# 0x0c28bd50 的十二种粒子。各行给出类型、帧间隔、帧数、绘制表与锚点表的 RAM 偏移。
PART_ANIMATIONS = (
    (0, 0x28BE18, 0x28BF5C, 0x28BE74, 0x28BE37),
    (1, 0x28BF60, 0x28C0E4, 0x28BFCC, 0x28BF83),
    (2, 0x28C0E8, 0x28C2C4, 0x28C16C, 0x28C113),
    (3, 0x28C2C8, 0x28C478, 0x28C340, 0x28C2EF),
    (4, 0x28C47C, 0x28C5A8, 0x28C4D0, 0x28C497),
    (5, 0x28C5AC, 0x28C718, 0x28C610, 0x28C5CD),
    (6, 0x28C71C, 0x28C8A8, 0x28C788, 0x28C740),
    (7, 0x28CE50, 0x28CFA8, 0x28CEB0, 0x28CE6F),
    (8, 0x28CFAC, 0x28D0D8, 0x28D000, 0x28CFC7),
    (9, 0x28D0DC, 0x28D208, 0x28D130, 0x28D0F7),
    (10, 0x28C8AC, 0x28CA38, 0x28C918, 0x28C8D0),
    (11, 0x28CA3C, 0x28CBC0, 0x28CAA8, 0x28CA5F),
)


def export(ram, vram, output, worm=False, midboss=False, part_data=None, items=False, plants_data=None, sampled_stage=None, beetle_data=None):
    memory = ram.read_bytes()
    if len(memory) != 0x800000:
        raise ValueError('工作 RAM 必须是 8 MiB 的 SH-3 保存项')
    pixels = np.memmap(vram, dtype='<u4', mode='r', shape=(4096, 8192))

    def byte(address):
        return memory[address ^ 7]

    def word(address):
        return byte(address) * 256 + byte(address + 1)

    def long(address):
        value = word(address) * 65536 + word(address + 2)
        return value if value < 0x80000000 else value - 0x100000000

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

    if beetle_data:
        cell, columns = 96, 12
        entries, banks = [], {}
        for name, first, count, anchor in (
            ('body', 0x25BE, 32, None), ('gun', 0x25DE, 33, 0x2E43E4),
            ('wing', 0x25FF, 32, 0x2E43A4),
        ):
            rows = []
            for i in range(count):
                dx = signed_byte(anchor + i * 2) if anchor else 0
                dy = signed_byte(anchor + i * 2 + 1) if anchor else 0
                rows.append(f'{{{len(entries)},{dx},{dy},{first+i}}}')
                entries.append(first + i)
            banks[name] = rows
        shot_y = ((len(entries)+columns-1)//columns)*cell
        sheet = Image.new('RGBA', (columns * cell, shot_y+4*SHOT_CELL))
        for slot, index in enumerate(entries):
            art = sprite(index)
            if art.width > cell or art.height > cell:
                raise ValueError(f'大型飞虫裁片 {index:x} 超出单元')
            sheet.alpha_composite(art, (slot % columns * cell + (cell-art.width)//2,
                                        slot // columns * cell + (cell-art.height)//2))
        for col in range(17):
            for phase in range(4):
                art = sprite(0x08F7+col*4+phase)
                sheet.alpha_composite(art, (col*SHOT_CELL+(SHOT_CELL-art.width)//2,
                                            shot_y+phase*SHOT_CELL+(SHOT_CELL-art.height)//2))
        lines = ['-- 第一面 0x30：0x0c0fa440 的身体与炮口图，及 0x0c1eea88 的移动指令。', 'return {']
        for name, rows in banks.items():
            lines.extend([f'    {name}={{', '        '+','.join(rows), '    },'])
        lines.append('    muzzle={'+','.join(f'{{{signed_byte(0x2E4426+i*2)},{signed_byte(0x2E4427+i*2)}}}' for i in range(32))+'},')
        program = []
        address = 0x1EEA8C
        while long(address) != -1:
            value = long(address) & 0xFFFFFFFF
            program.append(f'{{{value >> 25},{value >> 16 & 511},{value & 65535}}}')
            address += 4
        lines.extend(['    program={'+','.join(program)+'},', '}'])
        if sampled_stage:
            def fingerprint(art):
                box = art.getchannel('A').getbbox()
                if not box:
                    return None
                art = art.crop(box)
                rgba = np.array(art)
                transparent = rgba[:, :, 3] == 0
                rgba[transparent] = 0
                rgba[:, :, 3] = np.where(transparent, 0, 255)
                return art.size, blake2b(rgba.tobytes(), digest_size=16).digest()

            native = set()
            native_crops = []
            for index in entries:
                art = sprite(index)
                for image in (art, ImageOps.mirror(art), ImageOps.flip(art), ImageOps.flip(ImageOps.mirror(art))):
                    native.add(fingerprint(image))
                    box = image.getchannel('A').getbbox()
                    if box:
                        rgba = np.array(image.crop(box))
                        clear = rgba[:, :, 3] == 0
                        rgba[clear] = 0
                        rgba[:, :, 3] = np.where(clear, 0, 255)
                        native_crops.append(rgba)
            native.discard(None)

            def matches(art):
                if fingerprint(art) in native:
                    return True
                box = art.getchannel('A').getbbox()
                if not box:
                    return False
                query = np.array(art.crop(box))
                clear = query[:, :, 3] == 0
                query[clear] = 0
                query[:, :, 3] = np.where(clear, 0, 255)
                if np.count_nonzero(~clear) < 12:
                    return False
                ay,ax = np.argwhere(~clear)[0]
                h,w = query.shape[:2]
                # 绘制器会把越过页边界的精灵切成小裁片，必须核对整个裁片的像素和透明掩码。
                for image in native_crops:
                    if h > image.shape[0] or w > image.shape[1]:
                        continue
                    for py,px in np.argwhere(np.all(image == query[ay,ax], axis=2)):
                        left,top = int(px-ax),int(py-ay)
                        if left >= 0 and top >= 0 and left+w <= image.shape[1] and top+h <= image.shape[0]:
                            if np.array_equal(image[top:top+h,left:left+w],query):
                                return True
                return False
            source = sampled_stage.read_text(encoding='utf-8')
            stage_path = sampled_stage.resolve()
            directory = stage_path.parents[3]/'Resources'/stage_path.parent.name/stage_path.stem
            lines.insert(-1,'    sampled={')
            for name in ('sprites','tiles'):
                table = source.split(name+'={')[1].split('\n  },')[0]
                pages, matched = {}, []
                for index, record in enumerate(re.findall(r'\{(\d+),(\d+),(\d+),(\d+),(\d+)\}', table), 1):
                    page,x,y,w,h = map(int,record)
                    if page not in pages:
                        pages[page] = Image.open(directory/f'{name}{page}.png').convert('RGBA')
                    if matches(pages[page].crop((x,y,x+w,y+h))):
                        matched.append(f'{{{index},{w},{h}}}')
                lines.insert(-1,'        '+name+'={'+','.join(matched)+'},')
            lines.insert(-1,'    },')
        sheet.save(output)
        beetle_data.write_text('\n'.join(lines)+'\n', encoding='utf-8')
        return

    if plants_data:
        cell, columns = 128, 12
        entries, bodies, particles = [], {}, {}

        def append(sprite_id, dx=0, dy=0, wait=0):
            entries.append(sprite_id)
            return f'{{{len(entries)-1},{dx},{dy},{wait},{sprite_id}}}'

        for kind, bank, anchor, count in (
            (0, 0x2B06, 0x2DA840, 24), (1, 0x2AEE, 0x2DA870, 24),
            (2, 0x2AD6, 0x2DA8A0, 24), (3, 0x2A8E, 0x2DA8D0, 16),
        ):
            bodies[kind] = [append(bank+i, signed_byte(anchor+i*2), signed_byte(anchor+i*2+1))
                            for i in range(count)]
        shadows = [append(i) for i in (0x194, 0x1A0, 0x1A3)]
        for kind, clock, frame_count, visuals, anchors in (
            (18, 0x28D4CC, 0x28D62C, 0x28D52C, 0x28D4EB),
            (19, 0x28D630, 0x28D7BC, 0x28D69C, 0x28D654),
            (20, 0x28D7C0, 0x28D92C, 0x28D824, 0x28D7E1),
            (21, 0x28D930, 0x28DA70, 0x28D988, 0x28D94D),
        ):
            particles[kind] = [append(word(visuals+i*8), signed_byte(anchors+i*2),
                                      signed_byte(anchors+i*2+1), byte(clock+i))
                               for i in range(word(frame_count))]
        sheet = Image.new('RGBA', (cell*columns, cell*((len(entries)+columns-1)//columns)))
        for slot, sprite_id in enumerate(entries):
            art = sprite(sprite_id)
            if art.width > cell or art.height > cell:
                raise ValueError(f'植物裁片 {sprite_id:#x} 超过图集单元')
            sheet.alpha_composite(art, (slot%columns*cell+(cell-art.width)//2,
                                        slot//columns*cell+(cell-art.height)//2))
        lines = ['-- 第一面植物及击破裁片；槽号、横纵锚点、等待步数、原版精灵号。', 'return {body={']
        for kind, frames in bodies.items():
            lines.append(f'    [{kind}]={{' + ','.join(frames) + '},')
        lines.append('}, shadow={' + ','.join(shadows) + '}, particle={')
        for kind, frames in particles.items():
            lines.append(f'    [{kind}]={{' + ','.join(frames) + '},')
        lines.append('}, sampled={')
        if sampled_stage:
            # 旧采样将植物拆进敌机与背景两个图集；忽略全透明像素的 RGB 和混色透明度后匹配。
            def fingerprint(art):
                box = art.getchannel('A').getbbox()
                if not box:
                    return None
                art = art.crop(box)
                rgba = np.array(art)
                transparent = rgba[:, :, 3] == 0
                rgba[transparent] = 0
                rgba[:, :, 3] = np.where(transparent, 0, 255)
                return art.size, blake2b(rgba.tobytes(), digest_size=16).digest()

            native = set()
            for frames in bodies.values():
                for frame in frames:
                    slot = int(frame[1:].split(',')[0])
                    art = sheet.crop((slot%columns*cell,slot//columns*cell,(slot%columns+1)*cell,(slot//columns+1)*cell))
                    native.update(fingerprint(a) for a in (art,ImageOps.mirror(art),ImageOps.flip(art),ImageOps.flip(ImageOps.mirror(art))))
            shadow_keys = {fingerprint(sprite(i)) for i in (0x194,0x1A0,0x1A3)}
            native.discard(None)
            shadow_keys.discard(None)
            source = sampled_stage.read_text(encoding='utf-8')
            stage_path = sampled_stage.resolve()
            sampled_directory = stage_path.parents[3]/'Resources'/stage_path.parent.name/stage_path.stem
            for name in ('sprites', 'tiles'):
                table = source.split(name+'={')[1].split('\n  },')[0]
                records = re.findall(r'\{(\d+),(\d+),(\d+),(\d+),(\d+)\}', table)
                pages, matched, shadow_ids = {}, [], []
                for index, record in enumerate(records, 1):
                    page,x,y,w,h = map(int,record)
                    if page not in pages:
                        pages[page] = Image.open(sampled_directory/f'{name}{page}.png').convert('RGBA')
                    key = fingerprint(pages[page].crop((x,y,x+w,y+h)))
                    if key in native:
                        matched.append(f'{{{index},{w},{h}}}')
                    if key in shadow_keys:
                        shadow_ids.append(f'{{{index},{w},{h}}}')
                lines.append(f'    {name}={{' + ','.join(matched) + '},')
                if name=='tiles':
                    lines.append('    shadows={' + ','.join(shadow_ids) + '},')
        lines.extend(['}}'])
        sheet.save(output)
        plants_data.write_text('\n'.join(lines)+'\n', encoding='utf-8')
        return

    if items:
        # 0x0c094590 / 0x0c0948b0 的十六格金块、吸附光晕与 0x0c0957a0 的数字。
        indices = [*range(0x35B, 0x36B), *range(0x34B, 0x35B), *range(0x110, 0x11A), 0x193]
        cell, columns = 64, 8
        sheet = Image.new('RGBA', (cell * columns, cell * 6))
        for slot, index in enumerate(indices):
            art = sprite(index)
            if art.width > cell or art.height > cell:
                raise ValueError(f'道具精灵 {index:#x} 超过图集单元')
            sheet.alpha_composite(art, (slot % columns * cell + (cell - art.width) // 2,
                                        slot // columns * cell + (cell - art.height) // 2))
        sheet.save(output)
        return

    if part_data:
        cell, columns = 128, 15
        # 蜈蚣末段使用 2–7 类；24 类仍与 0 类共用旋转裁片。
        debris_kinds = range(8)
        count = sum(word(entry[2]) for entry in PART_ANIMATIONS)
        count += sum(word(0x28E0D2 + kind * 8) for kind in debris_kinds)
        sheet = Image.new('RGBA', (cell * columns, cell * ((count + columns - 1) // columns)))
        lines = ['-- 取自第一面中 Boss 击破时的工作 RAM，由 export_futari15_road.py 导出。',
                 '-- 动画每格保留等待步数、横纵锚点与原版精灵号。', 'return {']
        slot = 0
        for kind, clock, frame_count, visuals, anchors in PART_ANIMATIONS:
            lines.append(f'    [{kind}]={{ first={slot}, frames={{')
            row = []
            for i in range(word(frame_count)):
                sprite_id = word(visuals + i * 8)
                art = sprite(sprite_id)
                if art.width > cell or art.height > cell:
                    raise ValueError(f'粒子 {kind} 第 {i} 格超过图集单元')
                x, y = slot % columns * cell, slot // columns * cell
                sheet.alpha_composite(art, (x + (cell - art.width) // 2, y + (cell - art.height) // 2))
                row.append(f'{{{byte(clock+i)},{signed_byte(anchors+i*2)},{signed_byte(anchors+i*2+1)},{sprite_id}}}')
                if len(row) == 6:
                    lines.append('        ' + ', '.join(row) + ',')
                    row.clear()
                slot += 1
            if row:
                lines.append('        ' + ', '.join(row) + ',')
            lines.append('    }},')
        lines.append('    debris={')
        for kind in debris_kinds:
            address = 0x28E0D0 + kind * 8
            first, count, anchor = word(address), word(address + 2), long(address + 4) - 0x0C000000
            lines.append(f'        [{kind}]={{ first={slot}, frames={{')
            for i in range(count):
                sprite_id = first + i
                art = sprite(sprite_id)
                if art.width > cell or art.height > cell:
                    raise ValueError(f'碎片 {kind} 第 {i} 格超过图集单元')
                x, y = slot % columns * cell, slot // columns * cell
                sheet.alpha_composite(art, (x + (cell - art.width) // 2, y + (cell - art.height) // 2))
                dx, dy = (0, 0) if anchor == -0x0C000000 else (signed_byte(anchor + i * 2), signed_byte(anchor + i * 2 + 1))
                lines.append(f'            {{0,{dx},{dy},{sprite_id}}},')
                slot += 1
            lines.append('        }},')
        lines.append('    },')
        # 发射表由原版回调按每行 36 / 40 字节读取，保留同一行的顺序。
        lines.append('    emissions={')
        for name, address, count, stride in (
            ('coreLeft', 0x2FA410, 6, 36), ('coreRight', 0x2FA4E8, 6, 36),
            ('part', 0x2FA5C0, 5, 36),
            ('final', 0x2FA674, 41, 40), ('ripple', 0x2FAEDC, 12, 36),
            ('flame', 0x2FB0FC, 10, 36),
        ):
            lines.append(f'        {name}={{')
            for i in range(count):
                row = [long(address + i * stride + j * 4) for j in range(stride // 4)]
                lines.append('            {' + ','.join(map(str, row)) + '},')
            lines.append('        },')
        lines.extend(['    },', '}'])
        sheet.save(output)
        part_data.write_text('\n'.join(lines) + '\n', encoding='utf-8')
        return

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

    base_height = WINGS * (CELL + 3 * SHOT_CELL)
    shadow_y = base_height + 3 * SHOT_CELL
    sheet = Image.new('RGBA', (DIRECTIONS * CELL, shadow_y + CELL))
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
    # 0x0c071570 取普通朝向列的一半，0x0c071640 每列循环三帧。
    for direction in range(9):
        for phase in range(3):
            shot = sprite(THIN_SHOT_SPRITE + direction * 3 + phase)
            sheet.alpha_composite(shot, (direction * SHOT_CELL + (SHOT_CELL - shot.width) // 2,
                                         base_height + phase * SHOT_CELL + (SHOT_CELL - shot.height) // 2))
    # 0x0c0a2580 的地面投影另取十七个朝向，锚点不能沿用空中本体。
    for direction in range(DIRECTIONS):
        shadow = sprite(0x3DA9 + direction)
        anchor = 0x2DB1C4 + direction * 2
        dx, dy = signed_byte(anchor), signed_byte(anchor + 1)
        x = (CELL - shadow.width) // 2 + dx
        y = (CELL - shadow.height) // 2 - dy
        if x < 0 or y < 0 or x + shadow.width > CELL or y + shadow.height > CELL:
            raise ValueError(f'飞虫投影 {direction} 超出图集单元')
        sheet.alpha_composite(shadow, (direction * CELL + x, shadow_y + y))
    sheet.save(output)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ram', type=Path)
    parser.add_argument('vram', type=Path)
    parser.add_argument('output', type=Path)
    bank = parser.add_mutually_exclusive_group()
    bank.add_argument('--worm', action='store_true', help='导出两只蜈蚣共用的身体及阴影')
    bank.add_argument('--midboss', action='store_true', help='导出中 Boss 身体的原始裁片')
    bank.add_argument('--part-data', type=Path, help='导出中 Boss 零件爆炸图集与 Lua 动画表')
    bank.add_argument('--items', action='store_true', help='导出原版金块、光晕与拾取浮字')
    bank.add_argument('--plants-data', type=Path, help='导出第一面植物、击破裁片及动画数据')
    bank.add_argument('--beetle-data', type=Path, help='导出第一面大型飞虫图集与移动指令')
    parser.add_argument('--sampled-stage', type=Path, help='同时识别已有采样图集中需替换的植物裁片')
    args = parser.parse_args()
    if args.sampled_stage and not (args.plants_data or args.beetle_data):
        parser.error('--sampled-stage 需要与 --plants-data 或 --beetle-data 一起使用')
    export(args.ram, args.vram, args.output, args.worm, args.midboss, args.part_data, args.items, args.plants_data, args.sampled_stage, args.beetle_data)
