"""从大往生 V101 的程序及图形 ROM 导出原生对象参数。"""

import argparse
from pathlib import Path
import struct
import sys

from inspect_ddpdoj import STAGE_TABLE, bullet_rows, enemy_callbacks, pointer, read_program, stage_rows

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from ketsui.export import Atlas, Graphics, decode_palette


SCROLL_TABLE = 0x15FDCC
MAP_TABLE = 0x15FAF8
PALETTE_TABLE = 0x15FAE4
SCROLL_ARITY = {0: 1, 4: 3, 8: 1, 12: 0, 16: 3, 20: 1, 24: 1}


def lua_row(values):
    return '{' + ','.join(str(value) for value in values) + '}'


def lua_bytes(data, indent, separator=' ..\n'):
    chunks = []
    for offset in range(0, len(data), 48):
        chunks.append("'" + ''.join(f'\\{byte:03d}' for byte in data[offset:offset + 48]) + "'")
    return (separator + indent).join(chunks) if chunks else "''"


def scroll_commands(program, address):
    result = []
    while True:
        counter = struct.unpack_from('>H', program, address)[0]
        if counter == 0xFFFF:
            return result
        _, parameter, opcode = struct.unpack_from('>HHH', program, address)
        size = SCROLL_ARITY[opcode]
        arguments = struct.unpack_from(f'>{size}H', program, address + 6)
        result.append((counter, parameter, opcode, *arguments))
        address += 6 + 2 * size


def stage_data(program, stage):
    table = STAGE_TABLE + 16 * (stage - 1)
    path_base = pointer(program, table + 8)
    path_end = pointer(program, table + 16) if stage < 5 else 0x139FB6
    scroll_table = pointer(program, SCROLL_TABLE + (stage - 1) * 4)
    scroll = [scroll_commands(program, pointer(program, scroll_table + i * 4) + 8) for i in range(2)]
    return path_base, program[path_base:path_end], scroll, list(stage_rows(program, stage))


def write_vectors(program, output):
    with output.open('wb') as stream:
        for speed in range(256):
            start = pointer(program, 0x100920 + 4 * speed)
            for angle in range(65):
                h, l = struct.unpack_from('>ii', program, start + 8 * angle)
                stream.write(struct.pack('>hh', h >> 4, l >> 4))


def effect_frames(program, kind, sprite):
    # 0x187170 在每张图之前读取尺寸、绘图偏移和定点位移。
    images, delays = struct.unpack_from('>II', program, (0x121630 if kind & 0x80 else 0x121520)
                                       + (kind & 0x7f) * 8)
    size = draw_h = draw_l = 0
    while True:
        clock = struct.unpack_from('>H', program, delays)[0]
        if clock == 0xffff:
            return
        delays += 2
        shift_h = shift_l = 0
        while program[images] & 0x80:
            opcode = struct.unpack_from('>H', program, images)[0]
            if opcode == 0xffff:
                size, draw_h, draw_l = struct.unpack_from('>Hhh', program, images + 2)
            else:
                assert opcode == 0xfffe
                h, l = struct.unpack_from('>hh', program, images + 4)
                shift_h += h
                shift_l += l
            images += 8
        address = pointer(program, images)
        images += 4
        yield clock, draw_h, draw_l, shift_h, shift_l, sprite(address, size, 30)


def pilot_shot(program, address, model, sprite, bank=2):
    flags, h, l, draw_h, draw_l, flash, size, front, back, right, left, damage, speed, angle = (
        struct.unpack_from('>HhhhhI6HBB', program, address))
    motion = pointer(program, address + 0x1e)
    variant = struct.unpack_from('>H', program, address + 0x24)[0]
    flight = pointer(program, (0x14D0D8 if model == 0 else 0x14D814) + variant)
    fly_h, fly_l, fly_size, fly_shift = struct.unpack_from('>hhHh', program, flight)
    hit = pointer(program, (0x14D1B4 if model == 0 else 0x14D8F0) + variant)
    hit_h, hit_l, hit_size, hit_images, _, hit_clock = struct.unpack_from('>hhHIHH', program, hit)

    def images(table, count, size):
        return [sprite(pointer(program, table + 4 * index), size, bank) for index in range(count)]

    return ((flags, h, l, draw_h, draw_l, front, back, right, left, damage, speed, angle, variant),
            (fly_h, fly_l, fly_shift), (hit_h, hit_l), images(flash, 3, size), images(motion, 2, fly_size),
            images(hit_images, hit_clock // 4, hit_size))


def option_shot(program, address, model, sprite, orbiting, bank=2):
    flags, h, l, draw_h, draw_l, flash, size, front, back, right, left, damage, speed, angle = (
        struct.unpack_from('>HhhhhI6HBB', program, address))
    variant = struct.unpack_from('>H', program, address + (0x20 if orbiting else 0x24))[0]
    fly = pointer(program, (0x14EF90 if model == 0 else 0x14FC2E) + variant)
    hit = pointer(program, (0x14F44E if model == 0 else 0x1500EC) + variant)
    fly_h, fly_l, fly_size = struct.unpack_from('>hhH', program, fly)
    hit_h, hit_l, hit_size, hit_images, _, hit_clock = struct.unpack_from('>hhHIHH', program, hit)

    def images(table, count, size):
        return [sprite(pointer(program, table + 4 * index), size, bank) for index in range(count)]

    if orbiting:
        positions = []
        table = pointer(program, address + 2)
        for index in range(17):
            dh, dl, motion = struct.unpack_from('>hhI', program, pointer(program, table + 4 * index))
            positions.append((dh, dl, images(motion, 1, fly_size)[0]))
        h, l, motion = 0, 0, []
    else:
        positions = []
        motion = images(pointer(program, address + 0x1E), 1, fly_size)
    return ((flags, h, l, draw_h, draw_l, front, back, right, left, damage, speed, angle, variant),
            (fly_h, fly_l, 0), (hit_h, hit_l), images(flash, 3, size), motion,
            images(hit_images, hit_clock // 4, hit_size), positions)


def pilot_weapons(program, sprite, hyper=False):
    bank = 4 if hyper else 2
    models = []
    for model in range(2):
        dolls = []
        for doll in range(3):
            delay, burst = struct.unpack_from('>BB', program, 0x1544CE + doll * 8 + model * 4)
            variant = doll * 8 + 4 * hyper
            count_table = pointer(program, 0x154416 + 4 * (doll * 4 + model * 2))
            table = pointer(program, (0x1546F4, 0x154724)[model] + variant)
            second_table = pointer(program, 0x15470C + variant) if model == 0 and doll != 1 else 0
            levels = []
            for level in range(5):
                first = pointer(program, table + level * 4)
                shots = [pilot_shot(program, first, model, sprite, bank)]
                if doll != 1:
                    second = pointer(program, second_table + level * 4) if second_table else first + 0x26
                    shots.append(pilot_shot(program, second, model, sprite, bank))
                capacity = 6 if hyper else struct.unpack_from('>H', program, count_table + level * 2)[0]
                levels.append((capacity, shots))
            dolls.append((2 if hyper else delay, burst, levels))
        models.append(dolls)
    return models


def option_weapons(program, sprite, hyper=False):
    bank = 4 if hyper else 2
    models = []
    for model in range(2):
        dolls = []
        for doll in range(3):
            delay, burst = struct.unpack_from('>BB', program, 0x1544D0 + doll * 8 + model * 4)
            count_table = pointer(program, 0x15441A + 4 * (doll * 4 + model * 2))
            tables = ((0x14C5FE, 0x14C65E), (0x14C6BE,), (0x14C71E,))[doll]
            tables = [pointer(program, table + model * 8 + 4 * hyper) for table in tables]
            levels = []
            for level in range(5):
                source = pointer(program, tables[0] + level * 4)
                shots = [option_shot(program, source, model, sprite, doll == 1, bank)]
                if doll != 1:
                    second = pointer(program, tables[1] + level * 4) if doll == 0 else source + 0x26
                    shots.append(option_shot(program, second, model, sprite, False, bank))
                capacity = 6 if hyper else struct.unpack_from('>H', program, count_table + level * 2)[0]
                levels.append((capacity, shots))
            dolls.append((2 if hyper else delay, burst, levels))
        models.append(dolls)
    return models


def laser_profiles(program, sprite, hyper=False):
    bank = 4 if hyper else 0

    def images(table, count, size):
        return [sprite(pointer(program, table + index * 4), size, bank) for index in range(count)]

    options = []
    for doll, count in enumerate((32, 33, 16)):
        source = pointer(program, 0x14AEAC + doll * 4)
        normal = pointer(program, source + 0x3C)
        focused = pointer(program, source + 0x26)
        options.append((images(normal, count, 0x410), sprite(pointer(program, focused), 0x418, 0),
                        program[source + 0x2C], program[source + 0x34], program[source + 0x35],
                        struct.unpack_from('>H', program, 0x14BC2A + 2 * doll)[0],
                        struct.unpack_from('>H', program, 0x14BC30 + 2 * doll)[0]))
    orbit = tuple(struct.iter_unpack('>hh', program[0x14B1C8:0x14B24C]))
    profiles = []
    for model in range(2):
        dolls = []
        for doll in range(3):
            levels = []
            stream_table = (0x14C364 if hyper else
                            pointer(program, 0x14C320 + 4 * model) if doll == 0 else 0x14C350)
            leading_table = (0x14C3D8 if hyper else
                             pointer(program, (0x14C378 if doll == 0 else 0x14C3A8) + 4 * model))
            for level in range(5):
                index = level if hyper else 5 * model + level
                table = 0x14C30C if hyper else (0x14C2BC if doll == 0 else 0x14C2E4)
                descriptor = pointer(program, table + index * 4)
                draw_h, draw_l, size = struct.unpack_from('>hhH', program, descriptor + 2)
                scripts = pointer(program, descriptor + 0x14)
                base = pointer(program, descriptor + 0x1E)
                hitbox = pointer(program, descriptor + 0x22)
                frames = []
                while True:
                    command = struct.unpack_from('>H', program, scripts)[0]
                    if command == 0xFF80:
                        break
                    frames.append((int(bool(command & 0x8000)), sprite(pointer(program, scripts + 2), size, bank)))
                    scripts += 6
                _, dh, dl, length, right, left, _ = struct.unpack_from('>Hhh4H', program, hitbox)
                damage_table = 0x149B62 if hyper else 0x149B26 + (doll + 3 * model) * 10
                damage = struct.unpack_from('>H', program, damage_table + level * 2)[0]
                base_h, base_l, base_size, front, back, base_right, base_left = struct.unpack_from('>hh5H', program, base + 2)
                base_images = images(pointer(program, base + 0x12), 6, base_size)
                stream = pointer(program, stream_table + level * 4)
                stream_h, stream_l, stream_images, stream_size, stream_end = struct.unpack_from('>hhIHH', program, stream + 2)
                leading = pointer(program, leading_table + level * 4)
                lead_h, lead_l, lead_size = struct.unpack_from('>hhH', program, leading + 2)
                lead_images = images(pointer(program, leading + 0x14), 2, lead_size)
                tip_offset = level + 5 * (3 if hyper else model if doll == 0 else 2)
                tip_table = pointer(program, 0x14AE10 + 8 * tip_offset)
                tip = []
                for i in range(4):
                    tip_h, tip_l, tip_address, tip_size = struct.unpack_from('>hhIH', program, tip_table + i * 10)
                    tip.append((tip_h, tip_l, sprite(tip_address, tip_size, bank)))
                levels.append(((draw_h, draw_l, struct.unpack_from('>h', program, descriptor + 0x1C)[0]), frames,
                               (dh, dl, length, right, left, damage),
                               (base_h, base_l, front, back, base_right, base_left), base_images,
                               (stream_h, stream_l), images(stream_images, stream_end // 4, stream_size),
                               (lead_h, lead_l), lead_images, tip))
            dolls.append(levels)
        profiles.append(dolls)
    return options, orbit, profiles


def bomb_profiles(program, sprite):
    def images(table, count, size, laser):
        return [sprite(pointer(program, table + index * 4), size, laser) for index in range(count)]

    profiles = []
    for model in range(2):
        opening = []
        for i in range(4):
            h, l, address, size, _ = struct.unpack_from('>hhIHH', program, (0x15573C, 0x15576E)[model] + i * 12)
            opening.append((h, l, sprite(address, size, False)))
        primary = images((0x1557C2, 0x1557E2)[model], 8, 0x22C0, False)
        closing = images((0x155822 - 4, 0x155832)[model], 4, 0x22C0, False)
        laser = []
        laser_sizes = (0x1070, 0xE60, 0xA60, 0xC70)
        tables = ((0x155846, 0x15585E, 0x155852, 0x15586A), (0x155B6A, 0x155B82, 0x155B76, 0x155B8E))[model]
        for table, size in zip(tables, laser_sizes):
            laser.append(images(table, 3, size, True))
        shaft = [images(pointer(program, (0x155876, 0x155B9A)[model] + i * 4), 3, 0x240, True) for i in range(8)]
        release = []
        cursor = (0x1558F6, 0x155C1A)[model]
        while pointer(program, cursor) != 0xFFFFFFFF:
            row = [sprite(pointer(program, cursor + i * 4), size, True) for i, size in enumerate(laser_sizes)]
            release.append((row, images(pointer(program, cursor + 16), 8, 0x240, True)))
            cursor += 20
        profiles.append((opening, primary, closing, laser, shaft, release))
    return profiles


def map_images(program, graphics, resources):
    atlas = Atlas('native_tiles', lambda key, colors: graphics.tile(key[1:], colors))
    stages = []
    mid1_wreck = []
    for index in range(5):
        start = pointer(program, MAP_TABLE + index * 4)
        end = pointer(program, PALETTE_TABLE + index * 4)
        tile_offset = pointer(program, 0x140CEA + index * 4)
        colors = decode_palette([0] * 1024 + list(struct.unpack_from('>1024H', program, end)))
        assert (end - start) % 36 == 0
        rows = []
        for row in range(start, end, 36):
            images = []
            for record in struct.unpack_from('>9I', program, row):
                value = record + tile_offset
                images.append(atlas.get((index, value >> 16 & 0xffff, value & 0xffff), colors))
            rows.append(images)
        stages.append(rows)
        # 0x16aa82 从地图尾部取 23 行，用另一段图块编号替换原背景。
        if index == 0:
            for row in range(0x127AF8, 0x127AF8 + 23 * 36, 36):
                images = []
                for record in struct.unpack_from('>9I', program, row):
                    images.append(atlas.get((index, (record >> 16) + 0x32A9, record & 0xffff), colors))
                mid1_wreck.append(images)
    atlas.save(resources)
    return stages, atlas.rects, mid1_wreck


def boss1_images(program, sprite):
    def table(address, count, size, bank):
        return [sprite(pointer(program, address + index * 4), size, bank) for index in range(count)]

    return {
        'hull': {bank: sprite(0x6539C, 0x1A60, bank) for bank in (19, 25, 31)},
        'left': {bank: table(0x190C90, 32, 0x1460, bank) for bank in (21, 25, 31)},
        'right': {bank: table(0x190D82, 32, 0x1460, bank) for bank in (21, 25, 31)},
        'tail': {bank: table(0x190E32, 120, 0xA40, bank) for bank in (22, 25, 31)},
        'guns': table(0x1910D2, 32, 0x418, 23),
        'base': sprite(pointer(program, 0x19103A), 0x420, 21),
        'charge': table(0x1951B2, 16, 0x618, 17),
        'wipe': [sprite(0x1E8F74, 0x3800 | (height * 0x20 + 1 if height < 7 else 0xe0), 18)
                 for height in range(1, 9)],
        'hatch': [(sprite(address, size, 19), h, l)
                  for address, h, l, size in (struct.unpack_from('>IhhH', program, 0x19118C + 16 * i)
                                               for i in range(24))],
    }


def write_native(program, rom, output, resources):
    output.mkdir(parents=True, exist_ok=True)
    resources.mkdir(parents=True, exist_ok=True)
    graphics = Graphics(rom, 'ddp3_v101.u36', 'f18d791c034b0a3d85888a92fb5d326ee3deb04f', '044')
    atlas = Atlas('native_sprites', lambda key, palette: graphics.sprite(key[:5], palette))
    sprite_palette = [0] * (64 * 32)
    # 一面 0x38 至 0x3a 的三条 0x16096c 指令向 0x141492 传入这些调色板。
    for bank, address in ((0, 0x122878), (2, 0x122978), (4, 0x1229F8), (5, 0x122A38),
                          (10, 0x1238B8), (11, 0x123878), (12, 0x1237F8),
                          (13, 0x123838), (14, 0x1239B8), (15, 0x123938), (17, 0x123378),
                          (18, 0x124538), (19, 0x1244B8), (25, 0x1252B8),
                          (26, 0x1243F8), (27, 0x1242F8), (28, 0x124338), (29, 0x124378), (30, 0x124438), (31, 0x125278),
                          (47, 0x1233B8), (48, 0x123338), (49, 0x123378),
                          (50, 0x122BF8), (51, 0x1251B8)):
        sprite_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors = decode_palette(sprite_palette)

    colors_boss1 = list(sprite_palette)
    for bank, address in ((17, 0x122C38), (18, 0x145F24), (19, 0x122AF8), (21, 0x122B38),
                          (22, 0x122B78), (23, 0x122BB8)):
        colors_boss1[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_boss1 = decode_palette(colors_boss1)
    colors_stage2 = list(sprite_palette)
    # 第二面 0x160168 的第一条卷轴指令写入 0x1600b2 的前 20 个调色板。
    for i in range(20):
        address, bank = struct.unpack_from('>IH', program, 0x1600B2 + 6 * i)
        colors_stage2[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_stage2 = decode_palette(colors_stage2)

    def sprite(address, size, bank):
        return atlas.get((address & 0x3FFFFF, size >> 9, size & 511, bank, 0), colors)

    bomb_palettes = []
    for address in (0x122A78, 0x122AB8):
        palette = sprite_palette.copy()
        palette[6 * 32:7 * 32] = struct.unpack_from('>32H', program, address)
        bomb_palettes.append(decode_palette(palette))

    def bomb_sprite(address, size, laser):
        key = (address & 0x3FFFFF, size >> 9, size & 511, 6, 0, 16 + int(laser))
        return atlas.get(key, bomb_palettes[laser])

    # 同名调色板槽在关底初始化时被重装。图集键保留两种来源。
    def boss_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 1)
        return atlas.get(key, colors_boss1)

    def stage2_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 2)
        return atlas.get(key, colors_stage2)

    stage3_palette = list(sprite_palette)
    for i in range(24):
        address, bank = struct.unpack_from('>IH', program, 0x160246 + 6 * i)
        stage3_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_stage3 = decode_palette(stage3_palette)

    def stage3_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 5)
        return atlas.get(key, colors_stage3)

    colors_boss2 = list(sprite_palette)
    for bank, address in ((0x10, 0x122C78), (0x11, 0x122CB8), (0x12, 0x122CF8),
                          (0x13, 0x122DB8), (0x16, 0x145F24), (0x17, 0x122D38), (0xd, 0x122D78)):
        colors_boss2[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_boss2 = decode_palette(colors_boss2)

    def boss2_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 3)
        return atlas.get(key, colors_boss2)

    colors_boss3 = list(stage3_palette)
    for bank in range(16, 21):
        address = 0x122DF8 + (bank - 16) * 0x40
        colors_boss3[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_boss3[10 * 32:11 * 32] = struct.unpack_from('>32H', program, 0x145F24)
    colors_boss3 = decode_palette(colors_boss3)

    def boss3_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 6)
        return atlas.get(key, colors_boss3)

    aircraft = {}
    for kind, body, turret, size, bank in ((0x10, 0x166E20, 0x166F20, 0x830, 11),
                                           (0x11, 0x16742A, 0x16752A, 0x620, 10)):
        aircraft[kind] = {
            'body': [[sprite(pointer(program, body + index * 4), size, color) for index in range(64)]
                     for color in (bank, 31)],
            'turret': [[sprite(pointer(program, turret + index * 4), size, color) for index in range(32)]
                       for color in (bank, 31)],
        }
    tanks = [[sprite(pointer(program, 0x1686D4 + index * 4), 0x628, bank) for index in range(32)]
             for bank in (11, 31)]
    carrier = {bank: (sprite(0x1928BC, 0x28BC, bank),
                      [sprite(pointer(program, 0x171662 + index * 4), 0x620, bank) for index in range(32)])
               for bank in (14, 15, 25, 31)}
    ship = {bank: (sprite(0x1727C4, 0x1488, bank),
                   [sprite(pointer(program, 0x1717E2 + index * 4), 0x628, bank) for index in range(32)])
            for bank in (12, 18, 25, 31)}
    artillery = {bank: (sprite(0x1735FC, 0xC58, bank),
                        [sprite(pointer(program, 0x171662 + index * 4), 0x620, bank) for index in range(32)])
                 for bank in (12, 18, 25, 31)}
    groundgun = {bank: [sprite(pointer(program, 0x1716E2 + index * 4), 0x838, bank) for index in range(32)]
                 for bank in (14, 17, 25, 31)}
    heavy = {bank: (sprite(0x17D480, 0xC60, bank),
                    [sprite(pointer(program, 0x174C8E + 4 * i), 0x458, bank) for i in range(4)],
                    [sprite(pointer(program, 0x1715E2 + 4 * i), 0x418, bank) for i in range(32)])
             for bank in (13, 19, 25, 31)}
    flyby = [sprite(0x7E8AC, 0x1488, 50)]
    flyby += [sprite(pointer(program, 0x195322 + 4 * i), 0x1488, 50) for i in range(16)]
    warning = []
    for index in range(0x230 // 8):
        address, delay = struct.unpack_from('>IH', program, 0x16819A + index * 8)
        warning.append((sprite(address, 0x8E0, 51), delay))
    bullet = {
        1: [sprite(address, 0x210, 26) for address in range(0x1BF5D4, 0x1BF714, 0x14)],
        3: [sprite(address, 0x410, 26) for address in range(0x1BFEF4, 0x1BFF84, 0x24)],
        4: [sprite(address, 0x410, 26) for address in range(0x1BFF84, 0x1C0014, 0x24)],
        5: [sprite(address, 0x410, 26) for address in range(0x1C0014, 0x1C00A4, 0x24)],
        6: [sprite(address, 0x410, 26) for address in range(0x1C00A4, 0x1C0134, 0x24)],
        9: [sprite(address, 0x210, 26) for address in range(0x1C0260, 0x1C02B0, 0x14)],
        11: [sprite(address, 0x410, 26) for address in range(0x1C0E0C, 0x1C0E9C, 0x24)],
        12: [sprite(address, 0x210, 26) for address in range(0x1C0CA4, 0x1C0CF4, 0x14)],
        13: [sprite(address, 0x210, 26) for address in range(0x1C0D1C, 0x1C0D94, 0x14)],
        18: [sprite(0x1C0014, 0x410, 26)],
        19: [sprite(address, 0x410, 26) for address in range(0x1C1B68, 0x1C1E38, 0x24)],
        22: [sprite(address, 0x410, 26) for address in range(0x1C1E38, 0x1C2108, 0x24)],
    }
    bullet[7] = [[sprite(pointer(program, 0x180EBC + bank * 4) + offset, 0x410, 26)
                  for offset in range(0, 0x6c, 0x24)] for bank in range(9)]
    mid1 = {
        'body': {bank: [sprite(pointer(program, 0x16A85E + 4 * i), 0x24d0, bank)
                        for i in range(5)] for bank in (49,)},
        'hatch': {bank: [sprite(pointer(program, 0x16A7B8 + 4 * i), 0x1A60, bank)
                         for i in range(32)] for bank in (48, 31)},
        'gun': {bank: [sprite(pointer(program, 0x16A6E6 + 4 * i), 0x420, bank)
                       for i in range(8)] for bank in (47, 31)},
        'gunBase': {bank: [sprite(pointer(program, 0x16A706 + 4 * i), 0x620, bank)
                           for i in range(32)] for bank in (47, 31)},
    }
    boss1 = boss1_images(program, boss_sprite)
    boss2_layers = (
        ('motor', 0x1956E2, 8, 0x1480, 0x12),
        ('rotor', 0x19572C, 9, 0x1230, 0x10),
        ('hull', 0x19578A, 16, 0x1298, 0x17),
        ('bottom', 0x1957FA, 14, 0xC98, 0x13),
        ('rightWing', 0x1958D8, 16, 0xA20, 0x13),
        ('leftWing', 0x195866, 16, 0xA20, 0x0D),
        ('sideGun', 0x19594E, 32, 0x620, 0x11),
        ('wingGun', 0x195A38, 32, 0xA30, 0x12),
        ('topGun', 0x195B22, 32, 0x418, 0x11),
    )
    boss2 = {
        name: {bank: [boss2_sprite(pointer(program, address + i * 4), size, bank) for i in range(count)]
               for bank in (base, 25, 31)}
        for name, address, count, size, base in boss2_layers
    }
    boss2_trail = [boss2_sprite(pointer(program, 0x199EC2 + i * 4), 0x620, 23) for i in range(8)]
    stage3_scout = {
        bank: [stage3_sprite(pointer(program, 0x163F26 + i * 4), 0x628, bank) for i in range(64)]
        for bank in (13, 15, 31)
    }
    stage3_carrier = {
        bank: (stage3_sprite(0x178C8C, 0x2450, bank),
               [stage3_sprite(pointer(program, 0x171662 + i * 4), 0x620, bank) for i in range(32)],
               [stage3_sprite(pointer(program, 0x171562 + i * 4), 0x620, bank) for i in range(32)])
        for bank in (16, 31)
    }
    bunker_profiles = (
        (0x162FFC, 0x163018, -0x80, -0x280),
        (0x1634D2, 0x1634EE, -0x180, 0),
        (0x16353A, 0x163556, -0x400, 0),
        (0x1635A8, 0x1635C4, -0x600, -0x400),
    )
    bunkers = [stage3_sprite(pointer(program, address + 18), struct.unpack_from('>H', program, address + 16)[0], 21)
               for address, _, _, _ in bunker_profiles]
    bunker_guns = {bank: [stage3_sprite(pointer(program, 0x163214 + i * 4), 0xC50, bank) for i in range(128)]
                   for bank in (19, 31)}
    side_hatches = {bank: [stage3_sprite(address, size, bank) for address, size in
                          ((0x174040, 0xE38), (0x1741CC, 0xE28), (0x1742E8, 0xE28))]
                    for bank in (17, 31)}
    spinners = {
        bank: ([stage3_sprite(pointer(program, 0x163B5E + i * 4), 0x22A8, bank) for i in range(16)],
               stage3_sprite(pointer(program, 0x163B9E), 0x418, bank))
        for bank in (18, 31)
    }
    escort_images = {
        bank: ([stage3_sprite(pointer(program, 0x16742A + i * 4), 0x620, bank) for i in range(64)],
               [stage3_sprite(pointer(program, 0x16752A + i * 4), 0x620, bank) for i in range(32)])
        for bank in (10, 18, 31)
    }
    mid3_backdrop = [stage3_sprite(pointer(program, 0x164468 + i * 4), 0x3920, 23) for i in range(4)]
    colors_mid3 = list(stage3_palette)
    for bank, address in ((18, 0x1234B8), (19, 0x1234F8), (10, 0x123538)):
        colors_mid3[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_mid3 = decode_palette(colors_mid3)
    mid3 = {}
    for name, address, size, banks in (
        ('hull', 0x16BB3C, 0xE78, (18, 31)), ('leftWing', 0x16BBD8, 0x1038, (19, 31)),
        ('leftHatch', 0x16BBF8, 0xE38, (18, 31)), ('rightWing', 0x16BC74, 0x1038, (19, 31)),
        ('rightHatch', 0x16BC94, 0xE38, (18, 31)), ('child', 0x16BEB6, 0x820, (10, 31)),
    ):
        count = 16 if name == 'child' else 8
        mid3[name] = {
            bank: [atlas.get((pointer(program, address + i * 4) & 0x3fffff,
                              size >> 9, size & 511, bank, 0, 4), colors_mid3) for i in range(count)]
            for bank in banks
        }
    stage3_flypast = [stage3_sprite(address, size, 22) for address, size in (
        (0x28EA40, 0x1EA0), (0x28F3A4, 0x1EA0), (0x28FD08, 0x2090), (0x29060C, 0x2090))]
    stage3_gate_hull = []
    for table, size, bank in ((0x1648E6, 0x2870, 21), (0x164E36, 0x2A80, 20)):
        stage3_gate_hull.append({
            color: [stage3_sprite(pointer(program, table + i * 4), size, color) for i in range(16)]
            for color in (bank, 31)
        })
    stage3_cannon = {
        bank: [[stage3_sprite(pointer(program, 0x16596C + frame * 0x80 + i * 4), 0xA30, bank)
                for i in range(32)] for frame in range(2)]
        for bank in (15, 16, 31)
    }
    stage3_airship = {
        bank: stage3_sprite(0x17388C, 0x1270, bank) for bank in (12, 18, 19, 25, 31)
    }
    colors_stage4 = list(sprite_palette)
    for bank, address in ((13, 0x1237B8), (15, 0x123A38), (17, 0x1237B8), (18, 0x124CF8),
                          (20, 0x124CB8), (22, 0x124E78), (23, 0x124D78), (24, 0x145EE4)):
        colors_stage4[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_stage4 = decode_palette(colors_stage4)

    def stage4_sprite(address, size, bank):
        key = (address & 0x3fffff, size >> 9, size & 511, bank, 0, 7)
        return atlas.get(key, colors_stage4)

    stage4_bridge = {
        bank: (stage4_sprite(0x2AF6CC, 0x20B0, bank), stage4_sprite(0x2AECC8, 0x20A0, bank))
        for bank in (20, 22)
    }
    stage4_hatches = {
        bank: [stage4_sprite(pointer(program, 0x17BC46 + i * 4), 0x1C58, bank) for i in range(23)]
        for bank in (15, 17, 18, 25, 31)
    }
    stage4_turrets = {bank: [stage4_sprite(pointer(program, 0x176F94 + i * 4), 0x828, bank)
                             for i in range(32)] for bank in (13, 18, 25, 31)}
    stage4_flame = [stage4_sprite(pointer(program, 0x177014 + i * 4), 0x410, 24)
                    for i in range(32)]
    stage4_fleet = {bank: [stage4_sprite(pointer(program, 0x179922 + i * 4), 0x1AA0, bank)
                          for i in range(4)] for bank in (23, 25, 31)}
    stage4_crafts = {}
    for kind, table, turret, size, bank in ((0x10, 0x166E20, 0x166F20, 0x830, 11),
                                             (0x11, 0x16742A, 0x16752A, 0x620, 10)):
        stage4_crafts[kind] = {
            color: ([stage4_sprite(pointer(program, table + i * 4), size, color) for i in range(64)],
                    [stage4_sprite(pointer(program, turret + i * 4), size, color) for i in range(32)])
            for color in (bank, 31)
        }
    mid4_colors = colors_stage4.copy()
    for bank, address in ((15, 0x124AF8), (16, 0x124BF8), (17, 0x124C38)):
        mid4_colors[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, address))

    def mid4_sprite(address, size, bank):
        return atlas.get((address & 0x3fffff, size >> 9, size & 511, bank, 0, 8), mid4_colors)

    mid4_art = {
        'hull': {bank: [mid4_sprite(pointer(program, 0x17AA6A + i * 4), 0x34B0, bank)
                        for i in range(16)] for bank in (15, 25, 31)},
        'wings': {bank: [mid4_sprite(address, 0x2880, bank)
                         for address in (0x2C5DE4, 0x2C71EC, 0x2C67E8, 0x2C7BF0)]
                  for bank in (15, 25, 31)},
        'cover': {17: [mid4_sprite(pointer(program, 0x17AAAA + i * 4), 0x2470, 17) for i in range(4)]},
        'daughter': {bank: [mid4_sprite(pointer(program, 0x17AD26 + i * 4), 0xE50, bank)
                            for i in range(32)] for bank in (16, 25, 31)},
    }
    stage4_late = {
        'towerTop': {bank: [stage4_sprite(0x186FD8, 0x920, bank)] for bank in (10, 25, 31)},
        'towerGun': {bank: [stage4_sprite(pointer(program, 0x17C302 + i * 4), 0xE48, bank)
                             for i in range(8)] for bank in (12, 25, 31)},
        'scenery': {18: [stage4_sprite(pointer(program, 0x17B80A + i * 4), 0x3B10, 18)
                         for i in range(16)]},
    }
    stage4_colors = colors_stage4.copy()
    for bank, address in ((19, 0x124CF8), (20, 0x124D38), (21, 0x124C78), (51, 0x124B78)):
        stage4_colors[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, address))

    def facility_sprite(address, size, bank):
        return atlas.get((address & 0x3fffff, size >> 9, size & 511, bank, 0, 9), stage4_colors)

    stage4_facility = {
        'body': {bank: [facility_sprite(0x2EF328, 0x3920, bank)] for bank in (19, 25, 31)},
        'door': {21: [facility_sprite(pointer(program, 0x17B420 + i * 4), 0x1F20, 21) for i in range(15)]},
        'lift': {20: [facility_sprite(0x2F3230, 0x1860, 20)]},
        'wreck': {51: [facility_sprite(0x2F12AC, 0x3920, 51)]},
        'smoke': {21: [facility_sprite(0x052C1C + i * 0x34, 0x418, 21) for i in range(24)]},
    }
    boss4_palette = colors_stage4.copy()
    for bank, address in ((19, 0x122F38), (20, 0x122F78), (21, 0x122FB8)):
        boss4_palette[bank * 32:(bank + 1) * 32] = decode_palette(
            struct.unpack_from('>32H', program, address))
    boss4_entry_palette = boss4_palette.copy()
    boss4_entry_palette[21 * 32:22 * 32] = decode_palette(struct.unpack_from('>32H', program, 0x122FF8))

    def boss4_sprite(address, size, bank, entry=False):
        colors = boss4_entry_palette if entry else boss4_palette
        key = (address & 0x3fffff, size >> 9, size & 511, bank, 0, 11 if entry else 10)
        return atlas.get(key, colors)

    boss4 = {}
    for key, start, count, size, banks in (
        ('hull', 0x19D2C4, 8, 0x1290, (19, 25, 31)),
        ('transformedHull', 0x19D314, 16, 0x1AB0, (19, 25, 31)),
        ('vanishingHull', 0x19D3A8, 16, 0x14E8, (19, 25, 31)),
        ('armor', 0x19D412, 8, 0x18A0, (20, 25, 31)),
        ('cover', 0x19D45C, 8, 0xA30, (21, 25, 31)),
        ('cannon', 0x19D4AC, 24, 0x830, (21, 25, 31)),
        ('turret', 0x19D570, 32, 0x628, (20, 25, 31)),
        ('leftWing', 0x19D648, 8, 0x1040, (19, 31)),
        ('rightWing', 0x19D6E2, 8, 0x1040, (19, 31)),
        ('wingHatch', 0x19D668, 9, 0x620, (19, 31)),
        ('entry', 0x19D726, 16, 0x28C0, (21,)),
        ('entryFront', 0x19D78A, 8, 0x2490, (21,)),
    ):
        boss4[key] = {bank: [boss4_sprite(pointer(program, start + 4 * i), size, bank,
                                         key.startswith('entry')) for i in range(count)] for bank in banks}
    boss4['tail'] = {bank: [boss4_sprite(0xDAFC4, 0xA50, bank)] for bank in (19, 25, 31)}
    boss4['seed'] = {26: [boss4_sprite(pointer(program, 0x1809A2 + struct.unpack_from('>H', program,
                         0x180A94 + i * 8)[0]), 0x210, 26) for i in range(32)]}
    boss4['orb'] = {bank: [boss4_sprite(pointer(program, 0x1A2584 + i * 4), 0x620, bank)
                          for i in range(8)] for bank in (26, 22)}
    stage5_palette = sprite_palette.copy()
    for address, bank in struct.iter_unpack('>IH', program[0x1605A6:0x160618]):
        stage5_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_stage5 = decode_palette(stage5_palette)
    for bank, address in ((16, 0x124F38), (18, 0x123578), (19, 0x1235B8), (20, 0x1236B8), (21, 0x123AB8)):
        stage5_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_mid5 = decode_palette(stage5_palette)

    def stage5_sprite(address, size, bank, mid=False):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 12 if mid else 11)
        return atlas.get(key, colors_mid5 if mid else colors_stage5)

    stage5_ship = {
        bank: (stage5_sprite(0x172E5C, 0x1090, bank),
               [stage5_sprite(pointer(program, 0x171662 + i * 4), 0x620, bank) for i in range(32)],
               [stage5_sprite(pointer(program, 0x172E72 + i * 4), 0x428, bank) for i in range(6)])
        for bank in (13, 17, 25, 31)
    }
    stage5_sweeper = {
        bank: (stage5_sprite(0x17E064, 0xC48, bank),
               [stage5_sprite(pointer(program, 0x167FA8 + i * 4), 0x230, bank) for i in range(4)],
               [stage5_sprite(pointer(program, 0x167FB8 + i * 4), 0x430, bank) for i in range(8)])
        for bank in (10, 25, 31)
    }
    mid5_entry = [stage5_sprite(pointer(program, 0x16C768 + i * 4), 0x1AD0, 19, True) for i in range(16)]
    mid5_hull = {bank: [stage5_sprite(address, size, bank, True) for address, size in (
        (0x13DF28, 0x10D0), (0x13D3AC, 0x16D0), (0x13DCA0, 0xA40), (0x13DDE4, 0xA40),
    )] for bank in (18, 31)}
    mid5_fast_flash = [stage5_sprite(pointer(program, 0x16D664 + i * 4), 0x220, 20, True) for i in range(24)]
    mid5_glow = [(stage5_sprite(image, size, 20, True), h, l)
                 for image, h, l, size in struct.iter_unpack('>IhhH6x', program[0x16D70C:0x16D79C])]
    mid5_flame = [(stage5_sprite(image, size, 20, True), h, l, dh, dl)
                  for image, h, l, size, dh, dl in struct.iter_unpack('>IhhH2xhh', program[0x16D7E4:0x16D8B4])]
    stage5_doors = {
        key: {bank: [stage5_sprite(pointer(program, address + 4 * i), size, bank)
                     for i in range(8)] for bank in banks}
        for key, address, size, banks in (
            ('gun', 0x16F874, 0x420, (22, 31)), ('hatch', 0x16FACC, 0x1080, (22,)),
        )
    }
    stage5_platform = {
        bank: [(stage5_sprite(image, size, bank, True), h, l) for image, h, l, size in
               struct.iter_unpack('>IhhH6x', program[0x170FB8:0x1710B8])] for bank in (21, 31)
    }
    fifth_gun = {bank: [stage5_sprite(pointer(program, 0x1715E2 + 4 * i), 0x418, bank, True)
                        for i in range(32)] for bank in (0, 16, 17, 25, 30, 31)}
    fifth_fort = {bank: stage5_sprite(pointer(program, 0x16C35C), 0x1CB0, bank, True) for bank in (16, 31)}
    mid5b_palette = stage5_palette.copy()
    for bank, address in ((18, 0x1235F8), (19, 0x123638), (20, 0x123678)):
        mid5b_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_mid5b = decode_palette(mid5b_palette)

    def mid5b_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 13)
        return atlas.get(key, colors_mid5b)

    mid5b_art = {bank: [mid5b_sprite(address, size, bank) for address, size in (
        (0x14985C, 0xA38), (0x1494A0, 0xE88), (0x148EEC, 0xED0),
        (0x1499CC, 0x608), (0x149978, 0xA10),
    )] for bank in (18, 31)}
    mid5b_children = {
        key: {bank: [mid5b_sprite(pointer(program, start + 4 * i), size, bank) for i in range(count)]
              for bank in banks} for key, start, count, size, banks in (
            ('small', 0x16EC22, 16, 0x620, (20,)),
            ('large', 0x16EE64, 14, 0xA30, (20,)),
            ('mine', 0x16F1DA, 8, 0x620, (19, 31)),
        )
    }
    mid5b_spin = []
    for bank in (19, 31):
        mid5b_spin.append([
            (mid5b_sprite(first, 0x620, bank), mid5b_sprite(second, 0x620, bank),
             mid5b_sprite(third, 0x620, bank), flags)
            for first, second, third, flags in struct.iter_unpack('>IIII', program[0x16F244:0x16F444])
        ])
    tail_palette = stage5_palette.copy()
    tail_palette[22 * 32:23 * 32] = struct.unpack_from('>32H', program, 0x124FB8)
    colors_stage5_tail = decode_palette(tail_palette)

    def stage5_tail_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 14)
        return atlas.get(key, colors_stage5_tail)

    stage5_towers = {
        kind: {bank: [stage5_tail_sprite(pointer(program, start + 4 * i), size, bank)
                      for i in range(count)] for bank in (22, 31)}
        for kind, start, count, size in (
            (0x48, 0x16FDA0, 8, 0xA50), (0x49, 0x170004, 30, 0x1050),
            (0x4A, 0x170470, 8, 0x12A0), (0x4B, 0x170710, 30, 0x1EB0),
        )
    }
    stage5_large_tank = {
        bank: ([stage5_tail_sprite(pointer(program, 0x167AD2 + i * 4), 0x1060, bank) for i in range(4)],
               [stage5_tail_sprite(pointer(program, 0x1714E2 + i * 4), 0x620, bank) for i in range(32)])
        for bank in (21, 25, 31)
    }
    boss5_palette = sprite_palette.copy()
    for bank in range(16,24):
        boss5_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, 0x123038 + (bank - 16) * 64)
    colors_boss5 = decode_palette(boss5_palette)

    def boss5_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 15)
        return atlas.get(key, colors_boss5)

    boss5_art = {}
    for key, table, count, size, banks in (
        ('lower', 0x1A2AA6, 6, 0x1670, (18,25,31)), ('upper', 0x1A2E72, 6, 0x12A0, (16,25,31)),
        ('turret', 0x1A2D28, 64, 0xE50, (22,25,31)),
        ('shell', 0x1A2F68, 3, 0x1110, (20,25,31)),
        ('coreSecond', 0x1A3070, 8, 0xC38, (23,25,31)),
        ('gunSecond', 0x1A30C8, 18, 0x208, (23,25,31)),
        ('barrier', 0x1A3148, 16, 0x1040, (23,25,31)),
    ):
        boss5_art[key] = {bank: [boss5_sprite(pointer(program, table + 4 * i), size, bank)
                                 for i in range(count)] for bank in banks}
    boss5_art['core'] = {bank: [boss5_sprite(0x116768, 0x2120, bank)] for bank in (17,25,31)}
    boss5_art['tail'] = {bank: [boss5_sprite(0x101728, 0xC38, bank)] for bank in (18,25,31)}
    boss5_art['bridge'] = {bank: [boss5_sprite(0x11796C, 0xE60, bank)] for bank in (17,25,31)}
    boss5_hatches = [boss5_sprite(address, 0xF00, bank) for address, bank in
                     struct.iter_unpack('>IH', program[0x1A2F9E:0x1A302E])]
    stage4_smoke_vectors = bytearray()
    for speed in range(0, 128, 2):
        source = pointer(program, 0x100920 + speed * 4)
        for h, l in struct.iter_unpack('>ii', program[source:source + 65 * 8]):
            stage4_smoke_vectors.extend(struct.pack('>HH', h, l))
    boss3 = {}
    for name, address, count, size, banks in (
        ('tail', 0x19A196, 16, 0x14C0, (18, 25, 31)),
        ('wingLeft', 0x19A2AE, 8, 0x1C48, (17, 25, 31)),
        ('wingRight', 0x19A2FC, 8, 0x1C48, (17, 25, 31)),
        ('podFolded', 0x19A260, 8, 0x1020, (17, 25, 31)),
        ('pod', 0x19CC8E, 8, 0x1220, (17, 25, 31)),
        ('turret', 0x1715E2, 32, 0x418, (17, 25, 31)),
        ('cover', 0x19A348, 7, 0xA60, (17, 25, 31)),
        ('charge', 0x19CF2A, 4, 0x418, (26,)),
    ):
        boss3[name] = {bank: [boss3_sprite(pointer(program, address + i * 4), size, bank)
                                for i in range(count)] for bank in banks}
    boss3['body'] = {bank: [boss3_sprite(0xA3514, 0x22A0, bank)] for bank in (16, 25, 31)}
    boss3_opening = [(boss3_sprite(image, size, bank), h, l)
                     for image, h, l, size, bank in struct.iter_unpack('>IhhHH', program[0x19A3F6:0x19A5D6])]
    airframe = {bank: (stage2_sprite(0x1744F8, 0xE60, bank),
                       [stage2_sprite(pointer(program, 0x176672 + 4 * i), 0x648, bank) for i in range(8)])
                for bank in (12, 18, 25, 31)}
    stage2_turrets = {}
    for kind, table, debris, size, banks in ((0x8D,0x175606,0x193B4C,0x820,(16,20,25,31)),
                                            (0x8F,0x171762,0x155B90,0x828,(13,14,17,25,31))):
        stage2_turrets[kind] = {
            bank: (stage2_sprite(debris, size, bank),
                   [stage2_sprite(pointer(program, table + 4 * i), size, bank) for i in range(32)])
            for bank in banks
        }
    rotors = [stage2_sprite(pointer(program, 0x175686 + 4 * i), 0x428, 13) for i in range(6)]
    ground_ship = {
        bank: ([stage2_sprite(pointer(program, 0x174032 + 4 * i), 0x440, bank) for i in range(4)],
               [stage2_sprite(address, size, bank) for address, size in
                ((0x17D994, 0x1040), (0x17DB98, 0x1438), (0x17DE10, 0x810), (0x17DDCC, 0x810))])
        for bank in (16, 18, 25, 31)
    }
    ground_ship[15] = (
        [stage5_tail_sprite(pointer(program, 0x174032 + 4 * i), 0x440, 15) for i in range(4)],
        [stage5_tail_sprite(address, size, 15) for address, size in
         ((0x17D994, 0x1040), (0x17DB98, 0x1438), (0x17DE10, 0x810), (0x17DDCC, 0x810))],
    )
    battleship_frames = list(struct.iter_unpack('>IHH', program[0x17929E:0x17931E]))
    battleship = {
        bank: [stage2_sprite(address, 0x1A80, bank) for address, _, _ in battleship_frames]
        for bank in (18, 25, 31)
    }
    battleship_wreck = stage2_sprite(0x2799F4, 0x1A80, 18)
    supply_ship = {bank: stage2_sprite(0x2351AC, 0x1058, bank) for bank in (16, 17, 25, 31)}
    mid2 = {
        'body': {bank: [stage2_sprite(0x12D650, 0x1278, bank)] for bank in (21, 25, 31)},
        'rotor': {bank: [stage2_sprite(pointer(program, 0x177E50 + 4 * i), 0x1290, bank)
                         for i in range(8)] for bank in (22, 31)},
        'hatch': {bank: [stage2_sprite(pointer(program, 0x177E70 + 4 * i), 0x1670, bank)
                         for i in range(24)] for bank in (23, 31)},
        'turret': {bank: [stage2_sprite(pointer(program, 0x1715E2 + 4 * i), 0x418, bank)
                          for i in range(32)] for bank in (21, 25, 31)},
    }
    freight = []
    for kind, palette, address, size in (
        (0x91, 0x178390, 0x235470, 0x1240), (0x92, 0x1785CE, 0x23624C, 0x1430),
        (0x93, 0x1787B0, 0x237470, 0x1440),
    ):
        palettes = list(struct.iter_unpack('>BB', program[palette:palette + 10]))
        banks = sorted({25, 31, *(bank for bank, _ in palettes)})
        freight.append((kind, palettes, {bank: stage2_sprite(address, size, bank) for bank in banks}))
    side_turret = list(struct.iter_unpack('>IHH', program[0x178C7E:0x178CFE]))
    side_sprites = {bank: [stage2_sprite(address, 0x840, bank) for address, _, _ in side_turret]
                    for bank in (18, 19, 25, 31)}
    late_cruiser = {
        bank: ([stage2_sprite(pointer(program, 0x176B2A + 4 * i), 0xC40, bank) for i in range(4)],
               [stage2_sprite(pointer(program, 0x1714E2 + 4 * i), 0x620, bank) for i in range(32)])
        for bank in (10, 19, 22, 25, 31)
    }
    bounce = [sprite(0x1C1B68 + i * 0x24, 0x410, 26) for i in range(40)]
    fade = [[sprite(start + i * 0x24, 0x410, 26) for i in range(1, 17)]
            for start in (0x1C1658, 0x1C1418)]
    # 二周目的特殊弹与主线敌弹共用 0x1a 号调色板。
    for kind, address, size, count, stride in (
        (0, 0x1BF58C, 0x208, 6, 0xC), (10, 0x1C02D8, 0x210, 6, 0x14),
        (0x14, 0x1C0134, 0x210, 6, 0x14), (0x17, 0x1C0E0C, 0x410, 4, 0x24),
        (0x1B, 0x1BFEF4, 0x410, 4, 0x24),
    ):
        bullet[kind] = [sprite(address + i * stride, size, 26) for i in range(count)]
    bullet[0x18], bullet[0x1C] = bounce[20:], bounce[:20]
    bullet[0x15] = [[sprite(pointer(program, 0x181436 + bank * 4) + offset, 0x210, 26)
                     for offset in range(0, 0x50, 0x14)] for bank in range(9)]
    pilots = []
    for index in range(2):
        table = pointer(program, 0x154544 + index * 4)
        shape = [sprite(pointer(program, table + turn * 4), 0x620, 0) for turn in range(-8, 9)]
        speeds = [struct.unpack_from('>2B', program, 0x15440A + 4 * doll + 2 * index) for doll in range(3)]
        front, back = struct.unpack_from('>HH', program, 0x1543F8 + index * 8)
        pilots.append((shape, speeds, front, back))
    effects = {kind: list(effect_frames(program, kind, sprite))
               for kind in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 20,
                            0x82, 0x83, 0x84, 0x85, 0x87, 0x88, 0x8C, 0x8D)}
    ground = [sprite(address, 0x618, 28) for address in (0x1BCA34, 0x1BCA80)]
    chips = [sprite(address, 0x410, 28) for address in range(0x1BCACC, 0x1BCD0C, 0x24)]
    stars = [sprite(address, 0x418, 28) for address in range(0x1BE2CC, 0x1BE60C, 0x34)]
    large_stars = [sprite(address, 0x830, 28) for address in range(0x1BE94C, 0x1BF58C, 0xC4)]
    weapons = pilot_weapons(program, sprite)
    options, option_orbit, lasers = laser_profiles(program, sprite)
    support_weapons = option_weapons(program, sprite)
    bombs = bomb_profiles(program, bomb_sprite)
    hyper_shots = pilot_weapons(program, sprite, True)
    hyper_options = option_weapons(program, sprite, True)
    _, _, hyper_lasers = laser_profiles(program, sprite, True)
    hyper_item = (sprite(0x1B8B28, 0x638, 5),
                  [sprite(pointer(program, 0x17D7D6 + 4 * i), 0x418, 5) for i in range(16)])
    hyper_text = [sprite(pointer(program, 0x17DCCE + 4 * i), 0x450, 29) for i in range(30)]
    supply = {}
    for kind, poses, size, bank, dh, dl in (
            (0, 0x17D2E0, 0x618, 27, -0x600, -0x300),
            (4, 0x17D492, 0x420, 27, -0x400, -0x400),
            (8, 0x17D642, 0x618, 27, -0x600, -0x300),
            (0x10, 0x17DA5C, 0x420, 28, -0x400, -0x400)):
        box = struct.unpack_from('>4H', program, pointer(program, 0x17E00C + kind) + 10)
        images = [sprite(pointer(program, poses + 4 * i), size, bank) for i in range(4)]
        supply[kind] = (box, (dh, dl), images)
    supply_text = {}
    for kind, address, count in ((0, 0x17DD46, 30), (8, 0x17DC46, 30),
                                 (0x10, 0x17DBC6, 30), (-1, 0x17DDC6, 17)):
        dh, dl, size = struct.unpack_from('>hhH', program, address)
        images = [sprite(pointer(program, address + 8 + 4 * i), size, 29) for i in range(count)]
        supply_text[kind] = ((dh, dl), images)
    hyper_chips = [sprite(address, 0x830, 28) for address in range(0x1BD68C, 0x1BE2CC, 0xC4)]
    hyper_aura = [sprite(address, 0xE50, 4) for address in range(0x530FC, 0x56EAC, 0x234)]
    hyper_end = [sprite(pointer(program, 0x185832 + i * 4), 0xE50, 4) for i in range(1, 19)]
    atlas.save(resources)
    maps, tile_rects, mid1_wreck = map_images(program, graphics, resources)
    write_vectors(program, output / 'rom_vectors.bin')

    with (output / 'rom_data.lua').open('w', encoding='utf-8', newline='\n') as stream:
        stream.write('-- 由 tools/pgm/export_ddpdoj.py 从日版 V101 原程序导出。\nreturn {\n')
        stream.write('  aim=' + lua_bytes(program[0x14207E:0x1420FF], '    ') + ',\n')
        stream.write('  boss1Angle=' + lua_bytes(program[0x142B4A:0x142C4A], '    ') + ',\n')
        stream.write('  boss1Jitter=' + lua_row(struct.unpack_from('>128h', program, 0x14324C)) + ',\n')
        stream.write('  aim256=' + lua_bytes(program[0x1422EA:0x14232C], '    ') + ',\n')
        stream.write('  random=' + lua_bytes(program[0x142DE0:0x142E60], '    ') + ',\n')
        stream.write('  directions=' + lua_bytes(program[0x1544E6:0x1544F6], '    ') + ',\n')
        stream.write('  pilotStart=' + lua_row(struct.unpack_from('>HH', program, 0x1543E4)) + ',\n')
        stream.write('  pilot={\n')
        for shape, speeds, front, back in pilots:
            stream.write('    {images=' + lua_row(shape) + ', speeds={' + ','.join(map(lua_row, speeds))
                         + f'}}, front={front}, back={back}' + '},\n')
        stream.write('  },\n  pilotBoxes={\n')
        table = pointer(program, 0x1545D4)
        for turn in range(-8, 9):
            stream.write('    ' + lua_row(struct.unpack_from('>HH', program, table + turn * 4)) + ',\n')
        stream.write('  },\n')
        for key, models in (('pilotWeapons', weapons), ('pilotOptionWeapons', support_weapons),
                            ('pilotHyperWeapons', hyper_shots), ('pilotHyperOptionWeapons', hyper_options)):
            stream.write(f'  {key}={{\n')
            for profiles in models:
                stream.write('    {\n')
                for delay, burst, levels in profiles:
                    stream.write(f'      {{delay={delay},burst={burst},levels={{\n')
                    for capacity, shots in levels:
                        stream.write(f'        {{capacity={capacity},\n')
                        for record in shots:
                            stream.write('          {' + ','.join(map(lua_row, record[:6])))
                            if len(record) > 6 and record[6]:
                                stream.write(',{' + ','.join(map(lua_row, record[6])) + '}')
                            stream.write('},\n')
                        stream.write('        },\n')
                    stream.write('      }},\n')
                stream.write('    },\n')
            stream.write('  },\n')
        stream.write('  pilotOptions={\n')
        for option in options:
            images, *setup = option
            stream.write('    {' + lua_row(images) + ',' + lua_row(setup) + '},\n')
        stream.write('  },\n  pilotOptionOrbit={' + ','.join(map(lua_row, option_orbit)) + '},\n')
        for key, models in (('pilotLasers', lasers), ('pilotHyperLasers', hyper_lasers)):
            stream.write(f'  {key}={{\n')
            for dolls in models:
                stream.write('    {\n')
                for levels in dolls:
                    stream.write('      {\n')
                    for head, frames, hitbox, halo, halo_frames, shaft, shaft_frames, lead, lead_frames, tip in levels:
                        stream.write('        {head=' + lua_row(head) + ',start={' + ','.join(map(lua_row, frames))
                                     + '},box=' + lua_row(hitbox) + ',halo=' + lua_row(halo)
                                     + ',haloFrames=' + lua_row(halo_frames) + ',shaft=' + lua_row(shaft)
                                     + ',shaftFrames=' + lua_row(shaft_frames) + ',lead=' + lua_row(lead)
                                     + ',leadFrames=' + lua_row(lead_frames) + ',tip={' + ','.join(map(lua_row, tip)) + '}},\n')
                    stream.write('      },\n')
                stream.write('    },\n')
            stream.write('  },\n')
        stream.write('  pilotBombCount=' + lua_row(program[0x154404:0x15440A:2]) + ',\n')
        stream.write('  pilotBombRecoil=' + lua_row(struct.unpack_from('>24h', program, 0x1544F6)) + ',\n')
        stream.write('  pilotBombShake=' + lua_bytes(program[0x142FB8:0x1430B8], '    ') + ',\n')
        stream.write('  pilotBombs={\n')
        for opening, primary, closing, laser, shaft, release in bombs:
            stream.write('    {opening={' + ','.join(map(lua_row, opening)) + '},primary=' + lua_row(primary)
                         + ',closing=' + lua_row(closing) + ',laser={' + ','.join(map(lua_row, laser))
                         + '},shaft={' + ','.join(map(lua_row, shaft)) + '},release={\n')
            for row, shaft_images in release:
                stream.write('      {' + lua_row(row) + ',' + lua_row(shaft_images) + '},\n')
            stream.write('    }},\n')
        stream.write('  },\n')
        stream.write('  pilotHyper={\n')
        stream.write('    rank=' + lua_row(struct.unpack_from('>16H', program, 0x151E46)) + ',\n')
        stream.write('    comboMax=' + lua_row(struct.unpack_from('>2H', program, 0x186142))
                     + ',comboRefill=' + lua_row(struct.unpack_from('>2H', program, 0x186146)) + ',\n')
        stream.write('    killCharge=' + lua_row(struct.unpack_from('>5H', program, 0x185214))
                     + ',activeKillCharge=' + lua_row(struct.unpack_from('>5H', program, 0x18521E))
                     + ',stockCharge=' + lua_row(struct.unpack_from('>6h', program, 0x184A94)) + ',\n')
        stream.write('    item=' + str(hyper_item[0]) + ',shine=' + lua_row(hyper_item[1])
                     + ',chips=' + lua_row(hyper_chips) + ',\n')
        stream.write('    text=' + lua_row(hyper_text) + ',aura=' + lua_row(hyper_aura)
                     + ',ending=' + lua_row(hyper_end) + ',\n')
        stream.write('    motion={\n')
        for stride, clock, dh, dl in struct.iter_unpack('>BBhh', program[0x17D9C0:0x17DA5C]):
            stream.write('      ' + lua_row((stride // 6 + 1, clock, dh, dl)) + ',\n')
        stream.write('    },\n  },\n')
        stream.write('  pilotSupply={\n')
        for kind, (box, offset, images) in supply.items():
            stream.write(f'    [{kind}]={{' + ','.join(map(lua_row, (box, offset, images))) + '},\n')
        stream.write('  },\n  pilotSupplyText={\n')
        for kind, (offset, images) in supply_text.items():
            stream.write(f'    [{kind}]={{' + ','.join(map(lua_row, (offset, images))) + '},\n')
        stream.write('  },\n')
        stream.write('  pilotJitter=' + lua_row(struct.unpack_from('>64i', program, 0x14336E)) + ',\n')
        stream.write('  muzzles={\n')
        for kind, start, count, stride in ((0x07, 0x1687D4, 32, 4), (0x10, 0x166D20, 32, 4),
                                           (0x11, 0x1673AA, 32, 4), (0x80, 0x171CE2, 32, 4),
                                           (0x85, 0x171AE2, 32, 4), (0x88, 0x171A62, 32, 4),
                                           (0x89, 0x171B62, 32, 8)):
            stream.write(f'    [{kind}]={{\n')
            for index in range(count):
                form = '>4h' if kind == 0x89 else '>hh'
                stream.write('      ' + lua_row(struct.unpack_from(form, program, start + index * stride)) + ',\n')
            stream.write('    },\n')
        stream.write('  },\n  bulletOffsets={\n')
        for index in range(32):
            l, h = struct.unpack_from('>hh', program, 0x1821BE + index * 12)
            stream.write('    ' + lua_row((h // 2, l // 2)) + ',\n')
        stream.write('  },\n  aimBounds={\n')
        for loop in range(2):
            stream.write('    {\n')
            for index in range(5):
                height, h = struct.unpack_from('>HH', program, 0x1424EA + loop * 40 + index * 4)
                width, l = struct.unpack_from('>HH', program, 0x1424FE + loop * 40 + index * 4)
                stream.write('      ' + lua_row((h, height, l, width)) + ',\n')
            stream.write('    },\n')
        stream.write('  },\n  aimDistances=' + lua_row(struct.unpack_from('>5H', program, 0x16692E)) + ',\n')
        stream.write('  aircraft={\n')
        for kind, poses in aircraft.items():
            stream.write(f'    [{kind}]={{\n')
            for name, variants in poses.items():
                stream.write(f'      {name}={{' + ','.join(lua_row(images) for images in variants) + '},\n')
            stream.write('    },\n')
        stream.write('  },\n  bullet={\n')
        for kind, images in bullet.items():
            packed = '{' + ','.join(map(lua_row, images)) + '}' if kind in (7, 0x15) else lua_row(images)
            stream.write(f'    [{kind}]=' + packed + ',\n')
        stream.write('  },\n')
        stream.write('  fade={' + ','.join(map(lua_row, fade)) + '},\n')
        stream.write('  mid1={\n')
        for part, variants in mid1.items():
            stream.write(f'    {part}={{\n')
            for bank, images in variants.items():
                stream.write(f'      [{bank}]=' + lua_row(images) + ',\n')
            stream.write('    },\n')
        stream.write('    destruction={\n')
        for address in range(0x169AA0, 0x169B10, 8):
            delay, kind, h, l = struct.unpack_from('>HHhh', program, address)
            stream.write('      ' + lua_row((kind, delay, h, l))[:-1] + ',scrolls=true},\n')
        stream.write('    },\n  },\n')
        stream.write('  boss1={\n')
        for name in ('hull', 'left', 'right', 'tail'):
            stream.write(f'    {name}={{\n')
            for bank, images in boss1[name].items():
                stream.write(f'      [{bank}]=' + (str(images) if name == 'hull' else lua_row(images)) + ',\n')
            stream.write('    },\n')
        stream.write('    guns=' + lua_row(boss1['guns']) + ',\n')
        stream.write('    charge=' + lua_row(boss1['charge']) + ',\n')
        stream.write('    wipe=' + lua_row(boss1['wipe']) + ',\n')
        stream.write(f"    base={boss1['base']},\n")
        stream.write('    hatch={' + ','.join(map(lua_row, boss1['hatch'])) + '},\n')
        stream.write('    health=' + lua_row(struct.unpack_from('>IIIH', program, 0x1909FE)) + ',\n')
        stream.write('    wingZoom=' + lua_row(v & 0xffff for v in struct.unpack_from('>32I', program,0x190C10)) + ',\n')
        stream.write('    zoomMasks=' + lua_row(struct.unpack_from('>16I', program,0x13C54A)) + ',\n')
        stream.write('    boxes={\n')
        for i in range(9):
            row = struct.unpack_from('>14H', program, 0x190A0E + 28 * i)
            stream.write('      ' + lua_row((row[0], *row[6:11])) + ',\n')
        stream.write('    },\n    targets={\n')
        for phase, address in ((2, 0x191682), (4, 0x191758), (7, 0x191894)):
            rows = struct.iter_unpack('>HH', program[address:address + 32])
            stream.write(f'      [{phase}]={{' + ','.join(map(lua_row, rows)) + '},\n')
        stream.write('    },\n')
        stream.write('    tailMuzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x194032:0x19406E]))) + '},\n')

        def burst_rows(address, moving=False):
            rows = []
            while struct.unpack_from('>H', program, address)[0] != 0xffff:
                delay, kind, flip, h, l, parameter = struct.unpack_from('>HHHhhH', program, address)
                speed, angle = (parameter >> 8, parameter & 0xff) if moving else (0, 0)
                rows.append(lua_row((kind, delay, h, l, speed, angle))[:-1]
                            + (',flip=true' if flip & 0x40 else '') + '}')
                address += 12
            return '{' + ','.join(rows) + '}'

        stream.write('    wingBursts={' + burst_rows(0x191CEE) + ',' + burst_rows(0x191F32) + '},\n')
        stream.write('    wingDebris={' + burst_rows(0x191D50, True) + ',' + burst_rows(0x191F94, True) + '},\n')
        for name, address in (('hullBurst',0x1923C0), ('tailBurst',0x192422), ('hullDebris',0x192554)):
            stream.write(f'    {name}=' + burst_rows(address, name == 'hullDebris') + ',\n')
        stream.write('    hullFragments={\n')
        for i in range(16):
            kind, flip, h, l, velocity = struct.unpack_from('>HHhhH', program, 0x192454 + 16 * i)
            stream.write('      ' + lua_row((kind, 0, h, l, velocity >> 8, velocity & 0xff))[:-1]
                         + (',flip=true' if flip & 0x40 else '') + '},\n')
        stream.write('    },\n  },\n')
        stream.write('  arrowColors=' + lua_row(value // 4 + 1 for value in struct.unpack_from('>32H', program, 0x1820BE)) + ',\n')
        stream.write('  shipFan={\n')
        for kind, start in ((3, 0x171D62), (4, 0x171E62), (5, 0x171F62)):
            stream.write(f'    [{kind}]={{\n')
            for index in range(64):
                stream.write('      ' + lua_row(struct.unpack_from('>hh', program, start + 4 * index)) + ',\n')
            stream.write('    },\n')
        stream.write('  },\n')
        stream.write('  tank={' + ','.join(map(lua_row, tanks)) + '},\n')
        stream.write('  boss2={\n    engineTrail=' + lua_row(boss2_trail) + ',\n    boxes={\n')
        for i in range(9):
            row = struct.unpack_from('>14H', program, 0x19549A + 28 * i)
            stream.write('      ' + lua_row((row[0], *row[6:12])) + ',\n')
        stream.write('    },\n    images={\n')
        for name, palettes in boss2.items():
            stream.write(f'      {name}={{\n')
            for bank, images in palettes.items():
                stream.write(f'        [{bank}]=' + lua_row(images) + ',\n')
            stream.write('      },\n')
        stream.write('    },\n')
        for key, address, count, layout in (
            ('patrol', 0x195DF2, 16, '>hh'), ('retreat', 0x1960B4, 8, '>hh'),
            ('jitter', 0x14324C, 128, '>h'), ('rightMuzzles', 0x197C46, 32, '>hh'),
            ('leftMuzzles', 0x197BC6, 32, '>hh'), ('rearMuzzles', 0x197CC6, 4, '>hh'),
            ('arrowMuzzles', 0x171E62, 64, '>hh'), ('smallMuzzles', 0x171AE2, 32, '>hh'),
            ('fanMuzzles', 0x171D62, 64, '>hh'), ('outerWreckR', 0x196D7E, 3, '>HHHhhH'),
            ('outerWreckL', 0x196DF6, 3, '>HHHhhH'), ('bodyWreck', 0x196FDA, 4, '>HHHhhH'),
            ('deathBlasts', 0x197320, 16, '>HHhhh'), ('finalMuzzles', 0x19937A, 8, '>hh'),
        ):
            table = program[address:address + count * struct.calcsize(layout)]
            rows = list(struct.iter_unpack(layout, table))
            output_rows = (lua_row(row) if len(row) > 1 else str(row[0]) for row in rows)
            stream.write(f'    {key}={{' + ','.join(output_rows) + '},\n')
        stream.write('  },\n')
        stream.write('  airframe={palettes={')
        for row in struct.iter_unpack('>BB', program[0x17620C:0x176216]):
            stream.write(lua_row(row) + ',')
        stream.write('}, muzzles=' + lua_row(struct.unpack_from('>4h', program, 0x17666A)) + ', images={\n')
        for bank, (body, hatch) in airframe.items():
            stream.write(f'    [{bank}]={{{body},' + lua_row(hatch) + '},\n')
        stream.write('  }},\n  stage2Turrets={\n    palettes={\n')
        for kind, address in ((0x8D,0x17527A), (0x8F,0x175E50)):
            table = struct.iter_unpack('>BB', program[address:address + 10])
            stream.write(f'      [{kind}]={{' + ','.join(map(lua_row,table)) + '},\n')
        stream.write('    },\n    images={\n')
        for kind, palettes in stage2_turrets.items():
            stream.write(f'      [{kind}]={{debris={{')
            for bank, (debris, _) in palettes.items():
                stream.write(f'[{bank}]={debris},')
            stream.write('},\n')
            for bank, (_, sprites) in palettes.items():
                stream.write(f'        [{bank}]=' + lua_row(sprites) + ',\n')
            stream.write('      },\n')
        stream.write('    },\n    rotors=' + lua_row(rotors) + ',\n')
        stream.write('    bob=' + lua_row(struct.unpack_from('>256h',program,0x17571E)) + ',\n')
        stream.write('    muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh',program[0x17569E:0x17571E]))) + '},\n  },\n')
        stream.write('  stage3Scout={\n')
        for bank, frames in stage3_scout.items():
            stream.write(f'    [{bank}]=' + lua_row(frames) + ',\n')
        stream.write('  },\n')
        stream.write('  stage3Carrier={images={\n')
        for bank, (hull, front, back) in stage3_carrier.items():
            stream.write(f'    [{bank}]={{{hull},' + lua_row(front) + ',' + lua_row(back) + '},\n')
        stream.write('  }, rearMuzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x1718E2:0x1719E2]))) + '},\n')
        stream.write('    wreck={' + ','.join(map(lua_row,
            struct.iter_unpack('>HHHhhH', program[0x1624C0:0x162508]))) + '}},\n')
        stream.write('  stage3Bunkers={profiles={\n')
        for shape, (state, part, dh, dl) in zip(bunkers, bunker_profiles):
            h, l = struct.unpack_from('>hh', program, state + 22)
            mh, ml = struct.unpack_from('>hh', program, part + 2)
            box = struct.unpack_from('>hhhhH', program, part + 12)
            clock, burst_clock = struct.unpack_from('>BB', program, state + 10)
            stream.write('    {' + ','.join(map(lua_row, ((shape,h,l),(mh,ml),(dh,dl),(clock,burst_clock),box))) + '},\n')
        stream.write('  }, guns={\n')
        for bank, images in bunker_guns.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  }, muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x163414:0x163494]))) + '},\n')
        stream.write('  },\n  stage3Hatches={images={\n')
        for bank, images in side_hatches.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  }, muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x165256:0x16526E]))) + '},\n')
        stream.write('    angles=' + lua_row(program[0x165588:0x16558E]) + ',\n')
        stream.write('    fireAt=' + lua_row(pointer(program, i) == 0x1654FE and 1 or 0
                                              for i in range(0x165492, 0x1654C2, 4)) + ',\n')
        stream.write('    wreck={' + ','.join(map(lua_row,
            struct.iter_unpack('>HHHhhH', program[0x165594:0x1655B8]))) + '}},\n')
        stream.write('  stage3Spinner={images={\n')
        for bank, (hull, rotor) in spinners.items():
            stream.write(f'    [{bank}]={{' + lua_row(hull) + f',{rotor}}},\n')
        stream.write('  }, wreck={' + ','.join(map(lua_row,
            struct.iter_unpack('>HHHhhH', program[0x163C2A:0x163C72]))) + '}},\n')
        stream.write('  mid3={images={\n')
        for name, banks in mid3.items():
            stream.write(f'    {name}={{' + ','.join(f'[{bank}]=' + lua_row(frames)
                                                    for bank, frames in banks.items()) + '},\n')
        stream.write('  },\n')
        for key, start, end, layout in (
            ('route', 0x16B5C2, 0x16B5D2, '>hh'), ('bodyBoxes', 0x16BB5C, 0x16BB7C, '>hh'),
            ('wingMuzzles', 0x171E62, 0x171F62, '>hh'),
            ('wingBreak', 0x16AED0, 0x16AF48, '>HHHhhH'),
            ('bodyFire', 0x16B1B0, 0x16B1F8, '>HHHhhH'),
            ('bodyBreak', 0x16B1FA, 0x16B242, '>HHHhhH'),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack(layout, program[start:end]))) + '},\n')
        stream.write('    childScale=' + lua_row(program[0x16BEF6:0x16BF56:4]) + ',\n')
        stream.write('    backdrop=' + lua_row(mid3_backdrop) + ',\n  },\n')
        stream.write('  stage3Escort={flame=' +
                     lua_row(sprite(0x22C59C + i * 0x24, 0x410, 30) for i in range(4)) + ',\n')
        stream.write('    palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x165BF2:0x165BFC]))) + '},\n    images={\n')
        for bank, (hull, turret) in escort_images.items():
            stream.write(f'      [{bank}]={{' + lua_row(hull) + ',' + lua_row(turret) + '},\n')
        stream.write('    }},\n')
        stream.write('  stage3After={flypast=' + lua_row(stage3_flypast) + ',\n    hulls={\n')
        for hull in stage3_gate_hull:
            stream.write('      {' + ','.join(f'[{bank}]=' + lua_row(frames)
                                               for bank, frames in hull.items()) + '},\n')
        stream.write('    }, airship={' + ','.join(f'[{bank}]={image}' for bank, image in stage3_airship.items()) + '},\n')
        stream.write('    airshipTail=' + str(stage3_sprite(0x173F24, 0xA38, 24)) + ',\n')
        stream.write('    cannon={' + ','.join(f'[{bank}]={{' + ','.join(map(lua_row, frames)) + '}'
                                               for bank, frames in stage3_cannon.items()) + '},\n')
        for key, start, end, layout in (
            ('gunMuzzles', 0x165640, 0x1656C0, '>hh'), ('airshipMuzzles', 0x171D62, 0x171E62, '>hh'),
            ('airshipSalvo', 0x17396A, 0x1739B4, '>h'), ('airshipPalettes', 0x17346C, 0x173476, '>BB'),
            ('gateMuzzles', 0x16506A, 0x165082, '>hh'), ('gateWreck', 0x164F62, 0x164FB6, '>HHHhhH'),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack(layout, program[start:end]))) + '},\n')
        stream.write('    gateAngles=' + lua_row(program[0x165082:0x165088]) + ',\n  },\n')
        stream.write('  boss3={images={\n')
        for name, banks in boss3.items():
            stream.write(f'    {name}={{' + ','.join(f'[{bank}]=' + lua_row(frames)
                                                    for bank, frames in banks.items()) + '},\n')
        stream.write('    opening={' + ','.join(map(lua_row, boss3_opening)) + '},\n')
        stream.write('  }, boxes={')
        for offset in range(0x19A006, 0x19A11E, 28):
            box = struct.unpack_from('>5H', program, offset + 12)
            stream.write(lua_row(box) + ',')
        stream.write('},\n')
        for key, start, end, layout in (
            ('wingShift', 0x19A9C4, 0x19AA5C, '>hh'),
            ('turretMuzzles', 0x171A62, 0x171AE2, '>hh'),
            ('podMuzzles', 0x19CCAE, 0x19CD1A, '>Hhh'),
            ('sweepMuzzles', 0x19C550, 0x19C574, '>hh'),
            ('wreck', 0x19B1BC, 0x19B23C, '>HHhh'),
            ('wreckKinds', 0x19B56E, 0x19B57E, '>H'),
            ('wreckOffsets', 0x143A5C, 0x143B5C, '>i'),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack(layout, program[start:end]))) + '},\n')
        for key, address, words in (
            ('ring', 0x19B676, 10), ('spiral', 0x19B81C, 5), ('wingLaunch', 0x19BABC, 4),
            ('wing', 0x19BC42, 9), ('core', 0x19BF84, 6), ('outer', 0x19C150, 7),
            ('sweep', 0x19C344, 11), ('largeSweep', 0x19C58C, 12), ('pod', 0x19C912, 4),
        ):
            start = pointer(program, address + 4 * 4)
            stream.write(f'    {key}=' + lua_row(struct.unpack_from(f'>{words}H', program, start)) + ',\n')
        stream.write('  },\n')
        stream.write('  stage4Opening={bridge={')
        for bank, frames in stage4_bridge.items():
            stream.write(f'[{bank}]=' + lua_row(frames) + ',')
        stream.write('}, hatch={')
        for bank, frames in stage4_hatches.items():
            stream.write(f'[{bank}]=' + lua_row(frames) + ',')
        stream.write('}, palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x17B8C4:0x17B8CE]))) + '}, turret={')
        for bank, frames in stage4_turrets.items():
            stream.write(f'[{bank}]=' + lua_row(frames) + ',')
        stream.write('}, flame=' + lua_row(stage4_flame) + ',\n    turretPalettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x176D42:0x176D4C]))) + '},\n    turretMuzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x177094:0x177114]))) + '}},\n')
        stream.write('  stage4Fleet={hull={')
        for bank, frames in stage4_fleet.items():
            stream.write(f'[{bank}]=' + lua_row(frames) + ',')
        stream.write('}, craft={\n')
        for kind, colors in stage4_crafts.items():
            stream.write(f'    [{kind}]={{' + ','.join(f'[{bank}]={{' + lua_row(body) + ',' + lua_row(turret) + '}'
                                                     for bank, (body, turret) in colors.items()) + '},\n')
        stream.write('  }, fire=' + lua_row(sprite(0x22C59C + i * 0x24, 0x410, 30) for i in range(4)) + ',\n')
        stream.write('    craftWreckRandom=' + lua_bytes(program[0x143112:0x143192], '    ') + ',\n')
        for key, start, end, layout in (
            ('mounts', 0x179700, 0x17972A, '>hhH'),
            ('wreckedCraft', 0x17CC98, 0x17CCC8, '>I'),
        ):
            rows = list(struct.iter_unpack(layout, program[start:end]))
            if key == 'wreckedCraft':
                rows = [(stage4_sprite(address, 0x61E, 30),) for address, in rows]
            stream.write(f'    {key}={{' + ','.join(map(lua_row, rows)) + '},\n')
        stream.write('  },\n')
        stream.write('  mid4={\n')
        for key, palettes in mid4_art.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(ids)
                                                    for bank, ids in palettes.items()) + '},\n')
        stream.write('  },\n')
        stream.write('  stage4Late={\n')
        for key, palettes in stage4_late.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(ids)
                                                    for bank, ids in palettes.items()) + '},\n')
        stream.write('    bearings={' + ','.join(map(lua_row,
            struct.iter_unpack('>4h', program[0x17C322:0x17C332]))) + '},\n  },\n')
        stream.write('  stage4Facility={\n')
        for key, palettes in stage4_facility.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(ids)
                                                    for bank, ids in palettes.items()) + '},\n')
        stream.write('    smokeVectors=table.concat({\n      ' + lua_bytes(stage4_smoke_vectors, '      ', ',\n')
                     + '}),\n  },\n')
        stream.write('  boss4={images={\n')
        for key, palettes in boss4.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(ids)
                                                    for bank, ids in palettes.items()) + '},\n')
        stream.write('  }, boxes={')
        for index in range(13):
            stream.write(lua_row(struct.unpack_from('>5H', program, 0x19D0BC + 28 * index)) + ',')
        stream.write('},\n')
        for key, start, end in (
            ('patrol', 0x19DB04, 0x19DB14), ('orbit', 0x19DC7C, 0x19DC8C),
            ('fastOrbit', 0x19DD84, 0x19DD94), ('finalOrbit', 0x19DE44, 0x19DE64),
            ('cannonMuzzles', 0x19F9F6, 0x19FA56),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack('>hh', program[start:end]))) + '},\n')
        stream.write('    cannonAngles=' + lua_row(program[0x19FA5A:0x19FA72]) + ',\n')
        for key, start, count in (
            ('turretMuzzles', 0x171AE2, 32), ('hullMuzzles', 0x1A1704, 4),
            ('finalMuzzles', 0x1A1B1E, 4),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack('>hh', program[start:start + count * 4]))) + '},\n')
        stream.write('    seedMuzzles={')
        for start in (0x19F9D6, 0x19F9E6):
            stream.write('{' + ','.join(map(lua_row,struct.iter_unpack('>hh', program[start:start + 16]))) + '},')
        stream.write('},\n    launcher={' + ','.join(map(lua_row,
            struct.iter_unpack('>BBHBB', program[0x19F02A:0x19F048]))) + '},\n')
        stream.write('    orbitShots={')
        for index in range(4):
            start = pointer(program, 0x1A1484 + index * 4)
            stream.write(lua_row((program[start], *program[start + 2:start + 2 + program[start + 1]])) + ',')
        start = pointer(program, 0x1A153A)
        stream.write('}, finalOrbits={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[start + 2:start + 2 + 2 * program[start + 1]]))) + '},\n')
        stream.write('    effects={\n')
        for key, start in (
            ('leftWing', 0x19E26C), ('rightWing', 0x19E2EC), ('turret', 0x19E768),
            ('cannons', 0x19E782), ('cover', 0x19E790), ('armor', 0x19E7CE),
            ('death', 0x19EBEA), ('deathCycle', 0x19EC34),
        ):
            rows = []
            while program[start:start + 2] != b'\xff\xff':
                rows.append(struct.unpack_from('>HHHhhH', program, start))
                start += 12
            stream.write(f'      {key}={{' + ','.join(map(lua_row, rows)) + '},\n')
        stream.write('    }},\n')
        stream.write('  stage5Opening={\n')
        for key, palettes in (('ship', stage5_ship), ('sweeper', stage5_sweeper)):
            stream.write(f'    {key}={{' + ','.join(
                f'[{bank}]={{{body},' + lua_row(turrets) + ',' + lua_row(hatches) + '}'
                for bank, (body, turrets, hatches) in palettes.items()) + '},\n')
        stream.write('    sweeperDrops={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x167F98:0x167FA8]))) + '},\n  },\n')
        stream.write('  mid5={ entry=' + lua_row(mid5_entry) + ',\n    hull={')
        stream.write(','.join(f'[{bank}]=' + lua_row(images) for bank, images in mid5_hull.items()) + '},\n')
        stream.write('    fastFlash=' + lua_row(mid5_fast_flash) + ',\n')
        for key, rows in (('glow', mid5_glow), ('flame', mid5_flame)):
            stream.write(f'    {key}={{' + ','.join(map(lua_row, rows)) + '},\n')
        for key, start, end in (
            ('patrol', 0x16CC42, 0x16CC66), ('patrolSpeed', 0x16CC66, 0x16CCC6),
            ('diveSpeed', 0x16CD8E, 0x16CDEE), ('returnSpeed', 0x16CFCA, 0x16D02A),
            ('flameBounds', 0x16D8B4, 0x16D91C),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row, struct.iter_unpack(
                '>4h' if key == 'flameBounds' else '>hh', program[start:end]))) + '},\n')
        for key, start, end in (
            ('wreckCycle', 0x16D3AE, 0x16D3F6), ('wreckFinal', 0x16D3F8, 0x16D440),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row,
                struct.iter_unpack('>HHHhhH', program[start:end]))) + '},\n')
        stream.write('  },\n')
        stream.write('  stage5Doors={\n')
        for key, palettes in stage5_doors.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(images)
                                                    for bank, images in palettes.items()) + '},\n')
        stream.write('    platform={\n')
        for bank, rows in stage5_platform.items():
            stream.write(f'      [{bank}]={{' + ','.join(map(lua_row, rows)) + '},\n')
        stream.write('    }, wreck={' + ','.join(map(lua_row,
            struct.iter_unpack('>HHHhhH', program[0x1710B8:0x1710F4]))) + '}},\n')
        stream.write('  fifthGun={palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x174D56:0x174D60]))) + '}, images={')
        stream.write(','.join(f'[{bank}]=' + lua_row(images) for bank, images in fifth_gun.items()) + '}},\n')
        fort_wreck = []
        address = 0x16C554
        while struct.unpack_from('>H', program, address)[0] != 0xFFFF:
            fort_wreck.append(struct.unpack_from('>HHHhhH', program, address))
            address += 12
        stream.write('  fifthFort={images={' + ','.join(f'[{bank}]={image}' for bank, image in fifth_fort.items())
                     + '}, wreck={' + ','.join(map(lua_row, fort_wreck)) + '}},\n')
        stream.write('  mid5b={images={' + ','.join(f'[{bank}]=' + lua_row(images)
                                                  for bank, images in mid5b_art.items()) + '},\n')
        for key, palettes in mid5b_children.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(images)
                                                    for bank, images in palettes.items()) + '},\n')
        stream.write('    spin={' + ','.join(f'[{bank}]={{' + ','.join(map(lua_row, frames)) + '}'
                                              for bank, frames in zip((19,31), mid5b_spin)) + '},\n')
        for key, start, end, layout in (
            ('patrol', 0x16E1EC, 0x16E1F4, '>hh'), ('podMuzzles', 0x16E53A, 0x16E55A, '>hh'),
            ('wreckCycle', 0x16E99C, 0x16E9E4, '>HHHhhH'), ('wreckFinal', 0x16E9E6, 0x16EA2E, '>HHHhhH'),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row, struct.iter_unpack(layout, program[start:end])))
                         + '},\n')
        stream.write('  },\n')
        stream.write('  boss5={images={\n')
        for key, palettes in boss5_art.items():
            stream.write(f'    {key}={{' + ','.join(f'[{bank}]=' + lua_row(images)
                                                    for bank, images in palettes.items()) + '},\n')
        stream.write('  }, boxes={')
        for index in range(16):
            row = struct.unpack_from('>14H', program, 0x1A2778 + 28 * index)
            stream.write(lua_row((row[0], *row[6:12])) + ',')
        stream.write('},\n')
        for key, start, end, layout in (
            ('turretAnchors',0x1A75B4,0x1A75CC,'>hh'), ('turretMuzzles',0x1A791C,0x1A7A1C,'>hh'),
            ('extraFans',0x1A78E0,0x1A791C,'>5h'), ('hullMuzzles',0x1A825E,0x1A829A,'>3h'),
            ('ringMuzzles',0x16A872,0x16A972,'>hh'), ('deathPoints',0x1A3FAE,0x1A4002,'>hh'),
            ('loop2Fans',0x1A59AC,0x1A59E8,'>5h'), ('loop2CenterMuzzles',0x1A67A2,0x1A67BA,'>hh'),
            ('loop2Death',0x1A4972,0x1A49F2,'>4h'),
        ):
            stream.write(f'    {key}={{' + ','.join(map(lua_row, struct.iter_unpack(layout, program[start:end])))
                         + '},\n')
        stream.write('    loop2CrossMuzzles={\n')
        for i in range(3):
            address = pointer(program, 0x1A6956 + 4 * i)
            stream.write('      {' + ','.join('{' + lua_row(struct.unpack_from('>4h', program, address + 16 * j))
                         + ',' + lua_row(struct.unpack_from('>4h', program, address + 16 * j + 8)) + '}'
                         for j in range(5)) + '},\n')
        stream.write('    }, loop2FinalMuzzles={\n')
        for address in (0x171D62, 0x171E62, 0x171F62):
            stream.write('      {' + ','.join(map(lua_row, struct.iter_unpack('>hh', program[address:address + 256])))
                         + '},\n')
        stream.write('    }, hatches=' + lua_row(boss5_hatches) + ',\n')
        stream.write('    deathKinds=' + lua_row(struct.unpack_from('>8H', program, 0x1A40B0)) + '},\n')
        stream.write('  bounceBullet=' + lua_row(bounce) + ',\n')
        stream.write('  fifthTowers={\n')
        for kind, palettes in stage5_towers.items():
            stream.write(f'    [{kind}]={{' + ','.join(f'[{bank}]=' + lua_row(images)
                                                       for bank, images in palettes.items()) + '},\n')
        stream.write('    wreck={\n')
        for kind, address in ((0x48, 0x16FDC0), (0x49, 0x1701E4), (0x4A, 0x170498), (0x4B, 0x170788)):
            rows = []
            while struct.unpack_from('>H', program, address)[0] != 0xFFFF:
                rows.append(struct.unpack_from('>HHHhhH', program, address))
                address += 12
            stream.write(f'      [{kind}]={{' + ','.join(map(lua_row, rows)) + '},\n')
        stream.write('    },\n')
        for name, address, count, layout in (
            ('muzzle49', 0x17007C, 30, '>hh'), ('muzzle4b', 0x1707D2, 30, '>hh'),
            ('side48', 0x16FDFE, 2, '>hh'), ('side4a', 0x170490, 2, '>hh'),
            ('angle49', 0x17016C, 30, '>H'), ('angle49Flip', 0x1700F4, 30, '>H'),
            ('angle4b', 0x17084A, 30, '>H'), ('angle4bFlip', 0x170886, 30, '>H'),
        ):
            rows = struct.iter_unpack(layout, program[address:address + count * struct.calcsize(layout)])
            values = (str(row[0]) if len(row) == 1 else lua_row(row) for row in rows)
            stream.write(f'    {name}={{' + ','.join(values) + '},\n')
        stream.write('  },\n')
        stream.write('  fifthHeavy={images={\n')
        for bank, (hull, turret) in stage5_large_tank.items():
            stream.write(f'    [{bank}]={{{lua_row(hull)},{lua_row(turret)}}},\n')
        stream.write('  }, muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x171862:0x1718E2]))) + '}, jitter='
                     + lua_bytes(program[0x142B4A:0x142C4A], '    ') + '},\n')
        stream.write('  groundShip={palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x173A80:0x173A8A]))) + '},\n')
        stream.write('    hatch=' + lua_row(struct.unpack_from('>11h', program, 0x174042)) + ',\n')
        stream.write('    muzzles=' + lua_row(struct.unpack_from('>3h', program, 0x174058)) + ',\n')
        stream.write('    stars={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x17405E:0x17407A]))) + '},\n    images={\n')
        for bank, (rotor_frames, parts) in ground_ship.items():
            stream.write(f'      [{bank}]={{' + lua_row(rotor_frames) + ',' + lua_row(parts) + '},\n')
        stream.write('    }},\n')
        stream.write('  stage2Battleship={boxes={' +
                     ','.join(lua_row((right, left)) for _, right, left in battleship_frames) + '},\n')
        stream.write('    muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x171F62:0x172062]))) + '},\n    images={\n')
        for bank, frames in battleship.items():
            stream.write(f'      [{bank}]=' + lua_row(frames) + ',\n')
        stream.write(f'    }}, wreck={battleship_wreck}}},\n')
        stream.write('  stage2Supply={palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x178108:0x178112]))) + '},\n')
        stream.write('    offsets=' + lua_row(struct.unpack_from('>4h', program, 0x178344)) + ',\n')
        stream.write('    images={' + ','.join(f'[{bank}]={image}' for bank, image in supply_ship.items()) + '}},\n')
        stream.write('  mid2={\n')
        for layer, palettes in mid2.items():
            stream.write(f'    {layer}={{\n')
            for bank, frames in palettes.items():
                stream.write(f'      [{bank}]=' + lua_row(frames) + ',\n')
            stream.write('    },\n')
        for key, address, count, layout in (
            ('boxes', 0x177ED0, 24, '>h3H'), ('mainOffsets', 0x177F90, 12, '>hh'),
            ('mainMuzzles', 0x16A872, 64, '>hh'), ('wingMuzzles', 0x171A62, 32, '>hh'),
            ('spreadOffsets', 0x177FC0, 4, '>hh'), ('spread', 0x177FD0, 4, '>HH'),
        ):
            table = program[address:address + count * struct.calcsize(layout)]
            stream.write(f'    {key}={{' + ','.join(map(lua_row, struct.iter_unpack(layout, table))) + '},\n')
        stream.write('  },\n')
        stream.write('  stage2Freight={\n')
        for kind, palettes, images in freight:
            stream.write(f'    [{kind}]={{palettes={{' + ','.join(map(lua_row, palettes)) + '}, images={')
            stream.write(','.join(f'[{bank}]={image}' for bank, image in images.items()) + '}},\n')
        stream.write('  },\n  stage2SideTurret={boxes=' + lua_row(row[1] for row in side_turret) + ', images={\n')
        for bank, images in side_sprites.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  }},\n  stage2Cruiser={images={\n')
        for bank, (body, turrets) in late_cruiser.items():
            stream.write(f'    [{bank}]={{' + lua_row(body) + ',' + lua_row(turrets) + '},\n')
        stream.write('  }, palettes={' + ','.join(map(lua_row,
            struct.iter_unpack('>BB', program[0x176764:0x17676E]))) + '}, muzzles={' + ','.join(map(lua_row,
            struct.iter_unpack('>hh', program[0x171862:0x1718E2]))) + '}},\n')
        stream.write('  carrier={\n')
        for bank, (body, turret) in carrier.items():
            stream.write(f'    [{bank}]={{{body},' + lua_row(turret) + '},\n')
        stream.write('  },\n')
        stream.write('  ship={\n')
        for bank, (body, turret) in ship.items():
            stream.write(f'    [{bank}]={{{body},' + lua_row(turret) + '},\n')
        stream.write('  },\n')
        stream.write('  artillery={\n')
        for bank, (body, turret) in artillery.items():
            stream.write(f'    [{bank}]={{{body},' + lua_row(turret) + '},\n')
        stream.write('  },\n')
        stream.write('  groundgun={\n')
        for bank, images in groundgun.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  },\n')
        stream.write('  heavy={\n')
        for bank, (body, tread, turret) in heavy.items():
            stream.write(f'    [{bank}]={{{body},' + lua_row(tread) + ',' + lua_row(turret) + '},\n')
        stream.write('    drops={\n')
        for index in range(7):
            stream.write('      ' + lua_row(struct.unpack_from('>hh', program, 0x174C9E + index * 4)) + ',\n')
        stream.write('    },\n  },\n')
        stream.write('  flyby=' + lua_row(flyby) + ',\n')
        stream.write('  warning={' + ','.join(map(lua_row, warning)) + '},\n')
        stream.write('  effects={\n')
        for kind, frames in effects.items():
            stream.write(f'    [{kind}]={{' + ','.join(map(lua_row, frames)) + '},\n')
        stream.write('  },\n')
        stream.write('  ground=' + lua_row(ground) + ',\n  chips=' + lua_row(chips)
                     + ',\n  stars=' + lua_row(stars) + ',\n')
        stream.write('  largeStars=' + lua_row(large_stars) + ',\n')
        stream.write('  dropRandom=' + lua_bytes(program[0x142E7C:0x142F7C], '    ') + ',\n')
        stream.write('  dropAngle=' + lua_bytes(program[0x142FB8:0x1430B8], '    ') + ',\n')
        stream.write('  dropSpeed=' + lua_bytes(program[0x1431EC:0x14322C], '    ') + ',\n')
        stream.write('  beeScore=' + lua_row(int(f'{value:x}') for value in struct.unpack_from('>10I', program, 0x17E5BA)) + ',\n')
        stream.write('  beeMotion={\n')
        for offset in range(0, 0x9c, 6):
            stream.write('    ' + lua_row(struct.unpack_from('>BBhh', program, 0x17E60A + offset)) + ',\n')
        stream.write('  },\n')
        stream.write('  actorCallbacks={\n')
        for kind in range(256):
            init, update = enemy_callbacks(program, kind)
            if 0x160000 < init < 0x300000 and 0x160000 < update < 0x300000:
                stream.write(f'    [{kind}]=' + lua_row((init, update)) + ',\n')
        stream.write('  },\n')
        stream.write('  sprites={\n')
        for rect in atlas.rects:
            stream.write('    ' + lua_row(rect) + ',\n')
        stream.write('  },\n  tileRects={\n')
        for rect in tile_rects:
            stream.write('    ' + lua_row(rect) + ',\n')
        stream.write('  },\n  mid1Wreck={\n')
        for row in mid1_wreck:
            stream.write('    ' + lua_row(row) + ',\n')
        stream.write('  },\n  bulletTemplates={\n')
        for kind, address, flags, draw_h, draw_l, image, size, parameter, speed, extra, setup, init in bullet_rows(program):
            fade_type = struct.unpack_from('>H', program, address - 2)[0]
            stream.write(f'    [{kind}]=' + lua_row((flags, speed, setup, init, extra, 2 if fade_type == 1 else 1)) + ',\n')
        stream.write('  },\n  stages={\n')
        for number in range(1, 6):
            base, paths, scroll, rows = stage_data(program, number)
            stream.write('    {\n      pathBase=' + str(base) + ',\n      paths=' + lua_bytes(paths, '        ') + ',\n')
            stream.write('      tiles={\n')
            for row in maps[number - 1]:
                stream.write('        ' + lua_row(row) + ',\n')
            stream.write('      },\n')
            stream.write('      scroll={\n')
            for commands in scroll:
                stream.write('        {\n')
                for row in commands:
                    stream.write('          ' + lua_row(row) + ',\n')
                stream.write('        },\n')
            stream.write('      },\n      spawns={\n')
            for row in rows:
                address, counter, parameter, kind, flags, path_index, path, init, update = row
                stream.write('        ' + lua_row((counter, parameter, kind, flags, path, init, update)) + ',\n')
            stream.write('      },\n    },\n')
        stream.write('  },\n}\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path)
    parser.add_argument('rom', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--resources', type=Path, required=True)
    args = parser.parse_args()
    write_native(read_program(args.program), args.rom, args.output, args.resources)


if __name__ == '__main__':
    main()
