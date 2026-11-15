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


def lua_bytes(data, indent):
    chunks = []
    for offset in range(0, len(data), 48):
        chunks.append("'" + ''.join(f'\\{byte:03d}' for byte in data[offset:offset + 48]) + "'")
    return (' ..\n' + indent).join(chunks) if chunks else "''"


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


def pilot_shot(program, address, model, sprite):
    flags, h, l, draw_h, draw_l, flash, size, front, back, right, left, damage, speed, angle = (
        struct.unpack_from('>HhhhhI6HBB', program, address))
    motion = pointer(program, address + 0x1e)
    variant = struct.unpack_from('>H', program, address + 0x24)[0]
    flight = pointer(program, (0x14D0D8 if model == 0 else 0x14D814) + variant)
    fly_h, fly_l, fly_size, fly_shift = struct.unpack_from('>hhHh', program, flight)
    hit = pointer(program, (0x14D1B4 if model == 0 else 0x14D8F0) + variant)
    hit_h, hit_l, hit_size, hit_images, _, hit_clock = struct.unpack_from('>hhHIHH', program, hit)

    def images(table, count, size):
        return [sprite(pointer(program, table + 4 * index), size, 2) for index in range(count)]

    return ((flags, h, l, draw_h, draw_l, front, back, right, left, damage, speed, angle, variant),
            (fly_h, fly_l, fly_shift), (hit_h, hit_l), images(flash, 3, size), images(motion, 2, fly_size),
            images(hit_images, hit_clock // 4, hit_size))


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
        'tail': {bank: table(0x190E32, 112, 0xA40, bank) for bank in (22, 25, 31)},
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
    for bank, address in ((0, 0x122878), (2, 0x122978), (10, 0x1238B8), (11, 0x123878), (12, 0x1237F8),
                          (13, 0x123838), (14, 0x1239B8), (15, 0x123938), (17, 0x123378),
                          (18, 0x124538), (19, 0x1244B8), (25, 0x1252B8),
                          (26, 0x1243F8), (28, 0x124338), (30, 0x124438), (31, 0x125278),
                          (47, 0x1233B8), (48, 0x123338), (49, 0x123378),
                          (50, 0x122BF8), (51, 0x1251B8)):
        sprite_palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors = decode_palette(sprite_palette)

    colors_boss1 = list(sprite_palette)
    for bank, address in ((17, 0x122C38), (18, 0x145F24), (19, 0x122AF8), (21, 0x122B38),
                          (22, 0x122B78), (23, 0x122BB8)):
        colors_boss1[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', program, address)
    colors_boss1 = decode_palette(colors_boss1)

    def sprite(address, size, bank):
        return atlas.get((address & 0x3FFFFF, size >> 9, size & 511, bank, 0), colors)

    # 同名调色板槽在关底初始化时被重装。图集键保留两种来源。
    def boss_sprite(address, size, bank):
        key = (address & 0x3FFFFF, size >> 9, size & 511, bank, 0, 1)
        return atlas.get(key, colors_boss1)

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
        3: [sprite(address, 0x410, 26) for address in range(0x1BFEF4, 0x1BFF84, 0x24)],
        4: [sprite(address, 0x410, 26) for address in range(0x1BFF84, 0x1C0014, 0x24)],
        5: [sprite(address, 0x410, 26) for address in range(0x1C0014, 0x1C00A4, 0x24)],
        6: [sprite(address, 0x410, 26) for address in range(0x1C00A4, 0x1C0134, 0x24)],
        9: [sprite(address, 0x210, 26) for address in range(0x1C0260, 0x1C02B0, 0x14)],
        11: [sprite(address, 0x410, 26) for address in range(0x1C0E0C, 0x1C0E9C, 0x24)],
        12: [sprite(address, 0x210, 26) for address in range(0x1C0CA4, 0x1C0CF4, 0x14)],
        13: [sprite(address, 0x210, 26) for address in range(0x1C0D1C, 0x1C0D94, 0x14)],
        19: [sprite(address, 0x410, 26) for address in range(0x1C1B68, 0x1C1E38, 0x24)],
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
    fade = [[sprite(start + i * 0x24, 0x410, 26) for i in range(1, 17)]
            for start in (0x1C1658, 0x1C1418)]
    pilots = []
    for index in range(2):
        table = pointer(program, 0x154544 + index * 4)
        shape = [sprite(pointer(program, table + turn * 4), 0x620, 0) for turn in range(-8, 9)]
        speeds = [struct.unpack_from('>2B', program, 0x15440A + 4 * doll + 2 * index) for doll in range(3)]
        front, back = struct.unpack_from('>HH', program, 0x1543F8 + index * 8)
        pilots.append((shape, speeds, front, back))
    effects = {kind: list(effect_frames(program, kind, sprite))
               for kind in (1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 16, 0x84, 0x85, 0x87)}
    ground = [sprite(address, 0x618, 28) for address in (0x1BCA34, 0x1BCA80)]
    chips = [sprite(address, 0x410, 28) for address in range(0x1BCACC, 0x1BCD0C, 0x24)]
    stars = [sprite(address, 0x418, 28) for address in range(0x1BE2CC, 0x1BE60C, 0x34)]
    weapons = []
    for model in range(2):
        profiles = []
        for doll in range(3):
            delay, burst = struct.unpack_from('>BB', program, 0x1544CE + doll * 8 + model * 4)
            count_table = pointer(program, 0x154416 + 4 * (doll * 4 + model * 2))
            shot_table = pointer(program, (0x1546F4 if model == 0 else 0x154724) + doll * 8)
            second_table = pointer(program, 0x15470C + doll * 8) if model == 0 else 0
            levels = []
            for level in range(5):
                first = pointer(program, shot_table + level * 4)
                shots = [pilot_shot(program, first, model, sprite)]
                if doll != 1:
                    second = pointer(program, second_table + level * 4) if model == 0 else first + 0x26
                    shots.append(pilot_shot(program, second, model, sprite))
                capacity = struct.unpack_from('>H', program, count_table + level * 2)[0]
                levels.append((capacity, shots))
            profiles.append((delay, burst, levels))
        weapons.append(profiles)
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
        stream.write('  pilotWeapons={\n')
        for profiles in weapons:
            stream.write('    {\n')
            for delay, burst, levels in profiles:
                stream.write(f'      {{delay={delay},burst={burst},levels={{\n')
                for capacity, shots in levels:
                    stream.write(f'        {{capacity={capacity},\n')
                    for record in shots:
                        stream.write('          {' + ','.join(map(lua_row, record)) + '},\n')
                    stream.write('        },\n')
                stream.write('      }},\n')
            stream.write('    },\n')
        stream.write('  },\n')
        stream.write('  pilotJitter=' + lua_row(struct.unpack_from('>64i', program, 0x14336E)) + ',\n')
        stream.write('  muzzles={\n')
        for kind, start, count, stride in ((0x07, 0x1687D4, 32, 4), (0x10, 0x166D20, 32, 4),
                                           (0x11, 0x1673AA, 16, 8), (0x80, 0x171CE2, 32, 4),
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
            packed = '{' + ','.join(map(lua_row, images)) + '}' if kind == 7 else lua_row(images)
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
            struct.iter_unpack('>hh', program[0x194032:0x19406A]))) + '},\n')

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
