"""从 Espgaluda V100 的 ROM 导出关卡指令、图块与定点速度。"""

import argparse
from pathlib import Path
import struct
import sys

import numpy as np
from PIL import Image

from inspect_espgal import STAGE_TABLE, bullet_rows, enemy_callbacks, read_program, stage_rows

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from ketsui.export import Atlas, Graphics, decode_palette


def pointer(data, address):
    return struct.unpack_from('>I', data, address)[0]


def lua_row(values):
    return '{' + ','.join(map(str, values)) + '}'


def lua_bytes(data):
    return '"' + ''.join(f'\\{value:03d}' for value in data) + '"'


def emit_rows(output, rows, indent):
    for row in rows:
        output.write(indent + lua_row(row) + ',\n')


def map_data(data, graphics, resources):
    atlas = Atlas('native_tiles', lambda key, palette: graphics.tile(key[1:], palette))
    palette = [0] * 0x800
    stages = []
    for stage in range(6):
        address = pointer(data, 0x14A650 + stage * 4)
        width, height = struct.unpack_from('>HH', data, 0x14A668 + stage * 4)
        source, bank, count = struct.unpack_from('>IHH', data, 0x14A620 + stage * 8)
        count = (count + 1) * 32
        start = 0x400 + bank * 32
        palette[start:start + count] = struct.unpack_from(f'>{count}H', data, source)
        colors = decode_palette(palette)
        offset = pointer(data, 0x1175FC + stage * 4)
        rows = []
        for pos in range(address, address + width * height * 4, width * 4):
            row = []
            for raw in struct.unpack_from(f'>{width}I', data, pos):
                tile = (raw + offset) & 0xFFFFFFFF
                row.append(atlas.get((stage, tile >> 16, tile & 0xFFFF), colors))
            rows.append(row)
        stages.append(rows)
    atlas.save(resources)
    return stages, atlas.rects


SCROLL_ARGUMENTS = (1, 3, 2, 0, 3, 1, 1, 0, 0, 0, 4, 0, 0, 1, 1, 1, 3)


def scroll_rows(data, cursor):
    palette, effects = struct.unpack_from('>II', data, cursor)
    cursor += 8
    rows = []
    while True:
        major, minor, command = struct.unpack_from('>HHH', data, cursor)
        if major == minor == 0xFFFF:
            return rows
        if command % 4 or command // 4 >= len(SCROLL_ARGUMENTS):
            raise ValueError(f'卷轴指令 {cursor:#x} 的编号 {command:#x} 无效')
        count = SCROLL_ARGUMENTS[command // 4]
        args = struct.unpack_from(f'>{count}H', data, cursor + 6)
        if command == 0 and args[0]:
            entries = []
            for _ in range(args[0]):
                address = pointer(data, palette)
                if address == 0xFFFFFFFF:
                    break
                entries.extend((address, struct.unpack_from('>H', data, palette + 4)[0]))
                palette += 6
            args += tuple(entries)
        elif command == 20 and args[0]:
            # 0x14c5a4 由另一条数据流依次登记关卡演出回调。
            entries = []
            for _ in range(args[0]):
                op = struct.unpack_from('>H', data, effects)[0]
                if op == 0xFFFF:
                    break
                entries.append(effects)
                effects += (8, 2, 4)[op]
            args += tuple(entries)
        rows.append((major, minor, command, *args))
        cursor += 6 + count * 2


def vector_data(data):
    # 0x1181c6 每个方向跨过 16 字节；0x174068 读取同表内四分之一角的连续记录。
    for table in (0xD20, 0x61D20):
        for speed in range(256):
            address = pointer(data, table + speed * 4)
            yield data[address:address + 0x400]


def sprite_data(data, graphics, resources):
    def decode_sprite(key, palette):
        image = graphics.sprite(key[:5], palette)
        if len(key) == 5:
            return image
        zoom = key[5:]
        if len(zoom) == 2:
            zoom *= 2
        pixels = np.asarray(image)
        for axis, (size, mask, grow) in enumerate(zip(pixels.shape[:2], zoom[::2], zoom[1::2])):
            copies = [1 + grow * ((mask >> (i % 32)) & 1) for i in range(size)]
            pixels = np.repeat(pixels, copies[::-1] if axis == 0 else copies, axis=axis)
        return Image.fromarray(pixels)

    atlas = Atlas('native_sprites', decode_sprite)
    palette = [0] * 0x400
    for bank, address in ((0, 0xC3D78), (2, 0xC3EF8), (3, 0xC3F38), (4, 0xC3DB8),
                          (10, 0xC5A78), (14, 0x11F4EE), (15, 0xC62B8), (16, 0xC41B8),
                          (18, 0xC5A38), (19, 0xC84B8), (20, 0xC5CF8), (21, 0xC5FF8), (22, 0xC4778),
                          (25, 0xC61F8), (26, 0xC6678),
                          (28, 0xC5DF8), (30, 0xC66F8), (31, 0xC71B8)):
        palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', data, address)
    # 各面载入的色板会覆盖相同的硬件槽。用 ROM 地址分别保留图集中的版本。
    extra_colors = {}
    for address in (0xC4938, 0xC71F8, 0xC42B8, 0xC4238, 0xC6778, 0xC48F8, 0xC68B8, 0xC5738,
                    0xC4978, 0xC49B8, 0xC49F8, 0xC66B8, 0xC4A38, 0xC4438, 0xC4478, 0xC6A38, 0xC43B8,
                    0xC5778, 0xC57B8, 0xC57F8, 0xC67F8, 0xC4838, 0xC4178,
                    0xC4C78, 0xC4CB8, 0xC4CF8, 0xC4D38, 0xC4378, 0xC58B8, 0xC5878, 0xC4338, 0xC6C38,
                    0xC6C78, 0xC4678, 0xC46F8, 0xC4DB8, 0xC4DF8, 0xC4E38, 0xC4E78,
                    0xC4578, 0xC4538, 0xC44F8, 0xC58F8, 0xC44B8,
                    0xC4F38, 0xC4F78, 0xC4FB8, 0xC6D38, 0xC4FF8, 0xC5038, 0xC5078, 0xC45F8, 0xC45B8,
                    0xC4738, 0x11F52E, 0xC59B8, 0xC48B8, 0xC55B8, 0xC55F8, 0xC5638,
                    0xC5578, 0xC5338, 0xC52F8, 0xC5678, 0xC52B8,
                    0xC50B8, 0xC50F8, 0xC56B8, 0xC56F8, 0xC5AF8,
                    0xC5138, 0xC51F8, 0xC5238, 0xC5178, 0xC51B8, 0xC5378, 0xC7B78, 0xC5F38, 0xC6478):
        extra_colors[address] = len(palette) // 32
        palette.extend(struct.unpack_from('>32H', data, address))
    colors = decode_palette(palette)

    def sprite(address, size, bank, zoom=()):
        return atlas.get((address & 0x3FFFFF, size >> 9, size & 0x1FF, bank, 0) + zoom, colors)

    tank = {bank: [sprite(pointer(data, 0x1593DE + i * 4), 0x830, bank) for i in range(128)] for bank in (16, 31)}
    patrol = {}
    scout = {}
    heavy = {}
    for bank in (15, 18, 31):
        patrol[bank] = (
            [sprite(pointer(data, 0x15C042 + i * 4), 0x830, bank) for i in range(64)],
            [sprite(pointer(data, 0x15C142 + i * 4), 0x620, bank) for i in range(32)],
        )
        scout[bank] = (
            [sprite(pointer(data, 0x15038A + i * 4), 0x630, bank) for i in range(128)],
            [sprite(pointer(data, 0x15D252 + i * 4), 0x620, bank) for i in range(32)],
        )
    for bank in (14, 21, 31):
        heavy[bank] = (
            [sprite(pointer(data, 0x15C652 + i * 4), 0x838, bank) for i in range(64)],
            [sprite(pointer(data, 0x15D452 + i * 4), 0x830, bank) for i in range(32)],
        )
    round_bullet = [sprite(0x28CF50 + 0x14 * index, 0x210, 26) for index in range(4)]
    heavy_bullet = [sprite(0x28D260 + 0x14 * index, 0x210, 26) for index in range(4)]
    heavy_smoke = [sprite(0x2ED268 + 0x24 * index, 0x410, 30) for index in range(4)]
    hit_bullet = [sprite(0x290008 + 0x14 * index, 0x210, 26) for index in range(16)]
    arrow_bullet = [[sprite(pointer(data, address + index * 4), 0x410, 26) for index in range(3)]
                    for (address,) in struct.iter_unpack('>I', data[0x17466A:0x17468E])]
    flash = [[sprite(pointer(data, address) + 0x44 * index, 0x420, 26) for index in range(3)]
             for address in range(0x173A28, 0x173A28 + 32 * 12, 12)]
    armored_body = pointer(data, 0x164F92)
    armored_size = struct.unpack_from('>H', data, 0x164F96)[0]
    armored_car = {bank: (
        [sprite(armored_body, armored_size, bank)],
        [sprite(pointer(data, 0x15E052 + i * 4), 0x620, bank) for i in range(32)],
    ) for bank in (16, 18, 20, 25, 31)}
    armored_tracks = {bank: [sprite(pointer(data, 0x1652BC + i * 4), 0x628, bank) for i in range(16)]
                      for bank in (10, 25, 31)}
    effects = {kind: effect_frames(data, sprite, kind, bank)
               for kind, bank in ((2, 30), (3, 30), (4, 30), (5, 30), (7, 30), (13, 25), (14, 14),
                                  (0x84, 30), (0x88, 30))}
    pilot_shots = pilot_shot_data(data, sprite)
    body = pointer(data, 0x1649B8)
    body_size = struct.unpack_from('>H', data, 0x1649BC)[0]
    twin_tank = {bank: [sprite(body, body_size, color)] + [
        sprite(pointer(data, 0x15DFD2 + i * 4), 0x620, color) for i in range(32)
    ] for bank, color in ((14, extra_colors[0xC6778]), (15, extra_colors[0xC4238]), (19, 19), (22, 22),
                          (25, extra_colors[0xC71F8]), (31, 31))}
    twin_tracks = {bank: [sprite(pointer(data, 0x1652BC + i * 4), 0x628, color) for i in range(16)]
                   for bank, color in ((10, extra_colors[0xC4938]), (25, extra_colors[0xC71F8]))}
    twin_tracks[31] = armored_tracks[31]
    twin_bullets = [[sprite(pointer(data, address + i * 4), 0x410, 26) for i in range(3)]
                    for (address,) in struct.iter_unpack('>I', data[0x174AB6:0x174ADA])]
    hovercraft = {bank: [[sprite(pointer(data, table + i * 4), 0xC60, color) for i in range(16)]
                       for table in (0x150AEE, 0x150B58, 0x150BC2)]
                  for bank, color in ((9, extra_colors[0xC42B8]), (10, extra_colors[0xC4938]),
                                      (13, extra_colors[0xC48F8]), (14, extra_colors[0xC6778]), (31, 31))}
    for kind, color in ((0x85, 30), (0x89, 30), (0x8F, extra_colors[0xC71F8])):
        effects[kind] = effect_frames(data, sprite, kind, color)
    gunship = gunship_data(data, sprite, extra_colors)
    for kind in (8, 10, 11, 0x8C):
        effects[kind] = effect_frames(data, sprite, kind, 30)
    ageha_loss = []
    # 0x1287fc 在通常形态经 0x136e7a 和帧指针表读取坠机动画。
    ageha_loss_table = pointer(data, 0x136E7A)
    for index in range(32):
        address = pointer(data, ageha_loss_table + index * 4)
        offset, shift, image, size, duration, drift, _ = struct.unpack_from('>iiI4H', data, address)
        h, l = struct.unpack('>hh', struct.pack('>I', (offset + shift) & 0xFFFFFFFF))
        ageha_loss.append((duration, drift, h, l, sprite(image, size, 0)))
    mid1 = mid1_data(data, sprite, extra_colors)
    for kind in (6, 9, 0x10, 0x87, 0x8B):
        effects[kind] = effect_frames(data, sprite, kind, 30)
    dual_cannon = dual_cannon_data(data, sprite)
    boss1 = boss1_images(data, sprite, extra_colors)
    boss1_core = boss1_core_images(data, sprite, extra_colors)
    stage2_turret = {palette: (
        [sprite(pointer(data, 0x15DD52+i*4), 0xA30, color) for i in range(32)],
        sprite(0xE465C, 0x830, color))
        for palette, color in ((14, 14), (17, extra_colors[0xC49F8]), (20, extra_colors[0xC4438]),
                               (25, extra_colors[0xC71F8]), (31, 31))}
    stage2_carriers = stage2_carrier_images(data, sprite, extra_colors)
    stage2_forts = stage2_fort_images(data, sprite, extra_colors)
    mid2 = mid2_images(data, sprite, extra_colors)
    stage2_tail = stage2_tail_images(data, sprite, extra_colors)
    boss2, boss2_round = boss2_images(data, sprite, extra_colors)
    stage3_airships = stage3_airship_images(data, sprite, extra_colors)
    mid3 = mid3_images(data, sprite, extra_colors)
    stage3_tail = stage3_tail_images(data, sprite, extra_colors)
    stage3_guns = stage3_gun_images(data, sprite, extra_colors)
    stage3_heavy = stage3_heavy_images(data, sprite, extra_colors)
    boss3 = boss3_images(data, sprite, extra_colors)
    stage4_armor = stage4_armor_images(data, sprite, extra_colors)
    mid4 = mid4_images(data, sprite, extra_colors)
    stage4_gunship = stage4_gunship_images(data, sprite, extra_colors)
    boss4 = boss4_images(data, sprite, extra_colors)
    stage5_gunship = stage5_gunship_images(data, sprite, extra_colors)
    stage5_turret_ship = stage5_turret_ship_images(data, sprite, extra_colors)
    stage5_ark = stage5_ark_images(data, sprite, extra_colors)
    boss5 = boss5_images(data, sprite, extra_colors)
    stage6_patrol = stage6_patrol_images(data, sprite, extra_colors)
    effects[0x13] = effect_frames(data, sprite, 0x13, 25)
    boss6_opening = boss6_opening_images(data, sprite, extra_colors)
    effects[0x86] = effect_frames(data, sprite, 0x86, 30)
    effects[0x88] = effect_frames(data, sprite, 0x88, 30)
    ageha = ageha_data(data, sprite, extra_colors)
    pilot_awakened_shots = pilot_shot_data(data, sprite, awakened=True)
    atlas.save(resources)
    colored_images = {'patrolImages': patrol, 'scoutImages': scout, 'heavyPatrolImages': heavy,
                      'armoredCarImages': armored_car}
    round_images = {'roundImages': round_bullet, 'heavyRoundImages': heavy_bullet, 'heavyPatrolSmoke': heavy_smoke}
    return (atlas.rects, tank, colored_images, round_images, arrow_bullet, flash, hit_bullet, effects, pilot_shots,
            armored_tracks, twin_tank, twin_tracks, twin_bullets, hovercraft, gunship, ageha_loss, mid1, dual_cannon, boss1,
            boss1_core, stage2_turret, stage2_carriers, stage2_forts, mid2, stage2_tail, boss2, boss2_round,
            stage3_airships, mid3, stage3_tail, stage3_guns, stage3_heavy, boss3,
            stage4_armor, mid4, stage4_gunship, boss4, stage5_gunship, stage5_turret_ship, stage5_ark, boss5,
            stage6_patrol, boss6_opening, ageha, pilot_awakened_shots)


def gunship_data(data, sprite, extra_colors):
    shapes = list(struct.iter_unpack('>hhIHii', data[0x16C9B6:0x16C9B6 + 64 * 18]))
    turrets = list(struct.iter_unpack('>iI', data[0x16CE36:0x16CF36]))
    images = {bank: ([sprite(address, size, color) for _, _, address, size, _, _ in shapes],
                     [sprite(address, 0x420, color) for _, address in turrets])
              for bank, color in ((17, extra_colors[0xC68B8]), (25, extra_colors[0xC71F8]), (31, 31))}
    arrows = [[sprite(pointer(data, address + i * 4), 0x410, 26) for i in range(3)]
              for (address,) in struct.iter_unpack('>I', data[0x175538:0x17555C])]
    rounds = [sprite(0x28D0E0 + 0x24 * index, 0x410, 26) for index in range(4)]
    return shapes, turrets, images, arrows, rounds


def explosion_rows(data, address):
    record = struct.Struct('>HHhhHHHHH')
    while struct.unpack_from('>H', data, address)[0] != 0xFFFF:
        kind, _, dh, dl, ground, velocity, _, _, delay = record.unpack_from(data, address)
        yield kind, dh, dl, ground, velocity, delay
        address += record.size


def mid1_data(data, sprite, extra_colors):
    tables = (
        ('engine', 0x1AF74C, 8, 0xA48), ('hatch', 0x1AF9F2, 8, 0x410),
        ('tailA', 0x1AFA9A, 8, 0xC50), ('tailB', 0x1AFAE8, 8, 0xC50),
        ('podA', 0x1AF7AA, 8, 0xA28), ('podB', 0x1AF7F8, 8, 0xA28),
        ('wingA', 0x1AF846, 32, 0xC38), ('wingB', 0x1AF8F4, 32, 0xC38),
        ('cannon', 0x15D552, 32, 0x418),
    )
    banks = {}
    for bank, color in ((19, extra_colors[0xC5738]), (25, extra_colors[0xC71F8]), (31, 31)):
        banks[bank] = {name: [sprite(pointer(data, address + i * 4), size, color) for i in range(count)]
                       for name, address, count, size in tables}
        banks[bank]['body'] = [sprite(0x1D9068, 0xC40, color)]
        banks[bank]['wreck'] = [sprite(address, 0xA28, color) for address in (0x1D8F9C, 0x1D8870)]
    color = extra_colors[0xC5738]
    warning = []
    zoom_table = struct.unpack_from('>16I', data, 0x112FD2)
    for index in range(32):
        table_index = index if index < 16 else 32 - index
        mask = 0 if table_index == 16 else 1 if table_index == 15 else zoom_table[table_index]
        zoom = (mask, -1 if index < 16 else 1)
        # 0x116578 按未缩放的宽高和缩放索引校正精灵原点。
        correction = 16 - index
        warning.append((sprite(0x1DA4EC, 0x1270, color, zoom), -0x1200+144*correction, -0xE00+112*correction))
    approach = []
    for address in range(0x1AFDAC, 0x1AFECC, 12):
        image, offset, size = struct.unpack_from('>IiH', data, address)
        approach.append((sprite(image, size, color), offset))
    round_images = [sprite(0x28D040 + i * 0x14, 0x210, 26) for i in range(8)]
    ring_images = [sprite(pointer(data, 0x176694 + i * 4), 0x410, 26) for i in range(6)]
    ring_images.append(sprite(0x28D620, 0x410, 26))
    return banks, warning, approach, round_images, ring_images


def emit_mid1(stream, data, art):
    banks, warning, approach, rounds, rings = art
    core, wing_a, wing_b, timeout = struct.unpack_from('>3IH', data, 0x1AF48A)
    assert wing_a == wing_b
    stream.write(f'  mid1={{coreHP={core},wingHP={wing_a},timeout={timeout},\n')
    offsets = {1: 0xB00, 2: 0xF500, 3: 0xF6001100, 4: 0xF600EF00}
    stream.write('    parts={\n')
    for index in range(1, 12):
        address = 0x1AF498 + index * 0x20
        flags = struct.unpack_from('>H', data, address)[0]
        front, back, right, left, hp = struct.unpack_from('>5h', data, address + 12)
        emit_rows(stream, [(flags, front, back, right, left, hp, offsets.get(index, 0))], '      ')
    # 0x1af3cc 预留第十二个附属槽，0x1af498 只写到前一个。
    stream.write('      {32768,0,0,0,0,0,0},\n    },\n    wander={\n')
    boundaries = (
        (0x3C00, 0x4C00, 0x5A00, 0x5E00, 0x3000, 0x4000),
        (0x4000, 0x4800, 0x5000, 0x5800, 0x3400, 0x3C00),
        (0x3A00, 0x4E00, 0x4C00, 0x5400, 0x2E00, 0x4200),
    )
    emit_rows(stream, boundaries, '      ')
    stream.write('    },\n    warning={\n')
    emit_rows(stream, warning, '      ')
    stream.write('    },\n    approach={\n')
    emit_rows(stream, approach, '      ')
    stream.write('    },\n    images={\n')
    for bank, groups in banks.items():
        stream.write(f'      [{bank}]={{\n')
        for name, entries in groups.items():
            stream.write(f'        {name}=' + lua_row(entries) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n    explosions={\n')
    for address in (0x1B049E, 0x1B057C, 0x1B081C):
        stream.write('      {\n')
        emit_rows(stream, explosion_rows(data, address), '        ')
        stream.write('      },\n')
    stream.write('    },\n    fragments={\n')
    emit_rows(stream, explosion_rows(data, 0x1B091A), '      ')
    stream.write('    },\n    rings={\n')
    emit_rows(stream, ((step, last + 1) for step, last in struct.iter_unpack('>HH', data[0x1B1C3E:0x1B1C4A])),
              '      ')
    stream.write('    },\n')
    for name, address, count in (('cannonCenters', 0x15D5D2, 32), ('ringOffsets', 0x15CE52, 64)):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from(f'>{count}i', data, address)) + ',\n')
    stream.write('    roundImages=' + lua_row(rounds) + ',\n    ringImages=' + lua_row(rings) + ',\n  },\n')


def dual_cannon_data(data, sprite):
    tables = ((0x1637EE, 96, 0x1060), (0x15C952, 32, 0x620), (0x15CA52, 32, 0x620))
    images = {bank: [[sprite(pointer(data, address + i*4), size, bank) for i in range(count)]
                     for address, count, size in tables] for bank in (13, 14, 31)}
    rounds = [sprite(pointer(data, 0x17634C + i*4), 0x210, 26) for i in range(6)]
    rounds.append(sprite(0x28D300, 0x210, 26))
    large = [sprite(pointer(data, 0x1764F0 + i*4), 0x410, 26) for i in range(6)]
    large.append(sprite(0x28D470, 0x410, 26))
    return images, rounds, large


def emit_dual_cannon(stream, data, art):
    images, rounds, large = art
    flags = struct.unpack_from('>H', data, 0x163358)[0]
    bounds = struct.unpack_from('>5H', data, 0x163364)
    start = data[0x16332E:0x163358]
    init = (start[2], start[4], start[7], start[8], start[41] // 4, start[38], start[39])
    stream.write('  dualCannon={part=' + lua_row((flags, *bounds)) + ',init=' + lua_row(init) + ',\n')
    stream.write('    palettes={\n')
    emit_rows(stream, struct.iter_unpack('>BB', data[0x163322:0x16332E]), '      ')
    stream.write('    },\n    images={\n')
    for bank, groups in images.items():
        stream.write(f'      [{bank}]={{' + ','.join(map(lua_row, groups)) + '},\n')
    stream.write('    },\n    turrets={\n')
    emit_rows(stream, struct.iter_unpack('>ii', data[0x16396E:0x163A6E]), '      ')
    stream.write('    },\n    centers={\n')
    emit_rows(stream, (struct.unpack_from('>32i', data, address) for address in (0x15C9D2, 0x15CAD2)), '      ')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>64i', data, 0x15CD52)) + ',\n')
    stream.write('    destruction={\n')
    for address in range(0x1637AC, 0x1637EC, 16):
        kind, h, l, ground, velocity, _, _, delay = struct.unpack_from('>Hhh5H', data, address)
        emit_rows(stream, [(kind, h, l, ground, velocity, delay)], '      ')
    stream.write('    },\n    roundImages=' + lua_row(rounds) + ',\n    largeImages=' + lua_row(large) + ',\n  },\n')


def boss1_images(data, sprite, extra_colors):
    tables = (
        (0x188AF6, 32, 0x1678), (0x188B9C, 8, 0x820), (0x188BE2, 16, 0x830),
        (0x188C48, 16, 0xA38), (0x188CAE, 16, 0xA30), (0x188FAE, 16, 0xE48),
    )
    def read(table, count, size, color):
        return [sprite(pointer(data, table + i * 4), size, color) for i in range(count)]

    normal = extra_colors[0xC4978]
    warning_body = read(0x1892E4, 16, 0xC50, normal)
    warning_wings = []
    for i in range(16):
        addr, offset, size, split = struct.unpack_from('>IiII', data, 0x189324 + i * 16)
        warning_wings.append((sprite(addr, size, extra_colors[0xC49B8]), offset, split))
    wing = {0xb: read(*tables[0], extra_colors[0xC49B8]), 0x1f: read(*tables[0], 31)}
    wing_crack = read(0x188FEE, 16, 0x2078, extra_colors[0xC49B8])
    shell = {0x13: [read(*table, normal) for table in tables[1:]],
             0x1f: [read(*table, 31) for table in tables[1:]]}
    arms = {0x11: read(0x18A028, 256, 0x828, extra_colors[0xC49F8]),
            0x1f: read(0x18A028, 256, 0x828, 31)}
    arc = [sprite(0x28D590 + i * 0x24, 0x410, 26) for i in range(4)]
    arrows = [[[sprite(pointer(data, address + i * 4), 0x410, 26) for i in range(3)]
               for (address,) in struct.iter_unpack('>I', data[table:table + 36])]
              for table in (0x17575E, 0x175984)]
    round_shot = sprite(0x28D350, 0x410, 26)
    turning = [sprite(address, size, normal) for address, _, size in
               struct.iter_unpack('>IiH2x', data[0x188D0E:0x188F42])]
    zoom_table = struct.unpack_from('>16I', data, 0x112FD2)

    def breaking_zoom(word):
        index = word >> 11
        table_index = min(index, 32-index)
        mask = 0 if table_index == 16 else zoom_table[table_index]
        return (mask, -1 if index < 16 else 1), -0xC00 + 96*(16-index)

    breaking = []
    scales = struct.iter_unpack('>HH', data[0x189126:0x189166])
    for index, (h, l) in enumerate(scales):
        vertical, dh = breaking_zoom(h)
        horizontal, dl = breaking_zoom(l)
        asset = sprite(pointer(data, 0x1890E6 + index*4), 0xC60, normal, vertical + horizontal)
        breaking.append((asset, dh, dl))
    return warning_body, warning_wings, wing, wing_crack, shell, arms, arc, arrows, round_shot, turning, breaking


def emit_boss1(stream, data, images):
    warning_body, warning_wings, wing, wing_crack, shell, arms, arc, arrows, round_shot, turning, breaking = images
    stream.write('  boss1={\n    health=' + lua_row(struct.unpack_from('>3I', data, 0x188926)) + ',\n')
    stream.write(f'    timeout={struct.unpack_from(">H", data, 0x188932)[0]},\n    parts={{\n')
    for index in range(9):
        row = 0x188936 + index * 0x20
        flags = struct.unpack_from('>H', data, row)[0]
        emit_rows(stream, [(flags, *struct.unpack_from('>5h', data, row + 12))], '      ')
    stream.write('    },\n    movement={\n')
    emit_rows(stream, ((clock, delta) for clock, delta in struct.iter_unpack('>2H', data[0x1895CC:0x18960C])),
              '      ')
    stream.write('    },\n    offset=' + lua_row(struct.unpack_from('>64i', data, 0x11AF12)) + ',\n')
    stream.write('    displacement=' + lua_row(struct.unpack_from('>128h', data, 0x11AAE0)) + ',\n')
    stream.write('    trig={\n')
    rows = zip(struct.unpack_from('>256i', data, 0x119754), struct.unpack_from('>256i', data, 0x119B54))
    emit_rows(stream, rows, '      ')
    stream.write('    },\n    warningBody=' + lua_row(warning_body) + ',\n    warningWings={\n')
    emit_rows(stream, warning_wings, '      ')
    stream.write('    },\n    wing={\n')
    for palette, sprites in wing.items():
        stream.write(f'      [{palette}]=' + lua_row(sprites) + ',\n')
    stream.write('    },\n    wingCrack=' + lua_row(wing_crack) + ',\n    shell={\n')
    for palette, groups in shell.items():
        stream.write(f'      [{palette}]={{' + ','.join(map(lua_row, groups)) + '},\n')
    stream.write('    },\n    arms={\n')
    for palette, sprites in arms.items():
        stream.write(f'      [{palette}]=' + lua_row(sprites) + ',\n')
    stream.write('    },\n    shieldBreak={\n')
    for address in (0x18BAC2, 0x18BB1E):
        stream.write('      {\n')
        emit_rows(stream, explosion_rows(data, address), '        ')
        stream.write('      },\n')
    stream.write('    },\n    armCallbacks=' + lua_row(enemy_callbacks(data, 0x62)) + ',\n')
    stream.write('    carrierCallbacks=' + lua_row(enemy_callbacks(data, 0x64)) + ',\n')
    stream.write(f'    carrierRamp={struct.unpack_from(">H", data, 0x188A44)[0]},\n')
    stream.write('    escortCallbacks=' + lua_row(enemy_callbacks(data, 0x61)) + ',\n')
    stream.write('    rotationSteps=' + lua_bytes(data[0x11A84C:0x11A94C]) + ',\n')
    stream.write('    escortSpeeds={\n')
    emit_rows(stream, struct.iter_unpack('>HH', data[0x189D4E:0x189DAE]), '      ')
    stream.write('    },\n    bodyTurn=' + lua_row(turning) + ',\n')
    stream.write('    turnOffsets=' + lua_row([struct.unpack_from('>i', data, address+4)[0]
                                             for address in range(0x188D0E, 0x188F42, 12)]) + ',\n')
    stream.write('    bodyBreaking={\n')
    emit_rows(stream, breaking, '      ')
    stream.write('    },\n    hullBreak={\n')
    emit_rows(stream, ((delay, kind, attr, offset, velocity >> 8, velocity & 255)
                       for delay, kind, attr, offset, velocity in
                       struct.iter_unpack('>HHHiH', data[0x18BD76:0x18BDBE])), '      ')
    stream.write('    },\n    sweepArrows={\n')
    for arrow in arrows:
        stream.write('      {\n')
        emit_rows(stream, arrow, '        ')
        stream.write('      },\n')
    stream.write('    },\n    sweepRound=' + lua_row([round_shot]) + ',\n')
    stream.write('    arcImages=' + lua_row(arc) + ',\n  },\n')


def boss1_core_images(data, sprite, extra_colors):
    def read(table, count, size, color):
        return [sprite(pointer(data, table+i*4), size, color) for i in range(count)]

    zoom_table = struct.unpack_from('>16I', data, 0x112FD2)
    zoom = (zoom_table[12], 1)
    return {
        'coreImages': {17: read(0x189054, 24, 0x1848, extra_colors[0xC49F8]),
                       31: read(0x189054, 24, 0x1848, 31)},
        'vessels': {7: [sprite(pointer(data, 0x18E79C+i*4), 0x620, extra_colors[0xC66B8], zoom) for i in range(4)],
                    31: [sprite(pointer(data, 0x18E79C+i*4), 0x620, 31, zoom) for i in range(4)]},
        'satellites': {13: read(0x18B604, 32, 0x830, extra_colors[0xC4A38]),
                       31: read(0x18B604, 32, 0x830, 31)},
        'chargeRing': [sprite(0x28D0E0+i*0x24, 0x410, 26) for i in range(4)],
        'chargeOrb': {1: [sprite(0x28CF50+i*0x14, 0x210, 26) for i in range(4)],
                      2: [sprite(0x28CFA0+i*0x14, 0x210, 26) for i in range(4)]},
        'vesselGlow': read(0x18E77C, 8, 0xA18, 26),
        'ringBullet': [sprite(0x28D500, 0x410, 26)],
    }


def emit_boss1_core(stream, data, images):
    stream.write('  boss1Core={\n    callbacks={\n')
    for kind in (0x63, 0x65, 0x66, 0x67, 0x68):
        stream.write(f'      [{kind}]=' + lua_row(enemy_callbacks(data, kind)) + ',\n')
    stream.write('    },\n')
    for name, start, end, fmt in (('escortOffsets', 0x18A740, 0x18A750, '>hh'),
                                  ('rendezvousSpeeds', 0x1899A4, 0x189A04, '>HH'),
                                  ('coreSpeeds', 0x18CAFA, 0x18CB5A, '>HH')):
        stream.write(f'    {name}={{\n')
        emit_rows(stream, struct.iter_unpack(fmt, data[start:end]), '      ')
        stream.write('    },\n')
    stream.write('    satelliteMuzzles=' + lua_row(struct.unpack_from('>64i', data, 0x15CF52)) + ',\n')
    for name, group in images.items():
        if isinstance(group, dict):
            stream.write(f'    {name}={{\n')
            for key, row in group.items():
                stream.write(f'      [{key}]=' + lua_row(row) + ',\n')
            stream.write('    },\n')
        else:
            stream.write(f'    {name}=' + lua_row(group) + ',\n')
    stream.write('  },\n')


def emit_stage2_turret(stream, data, images):
    base = 0x166576
    flags = struct.unpack_from('>H', data, base)[0]
    stream.write('  stage2Turret={\n    body=' +
                 lua_row((flags, *struct.unpack_from('>5H', data, base+12))) + ',\n')
    stream.write('    state=' + lua_row(data[0x16656E:0x166574]) + ',\n')
    stream.write('    palettes={\n')
    emit_rows(stream, struct.iter_unpack('>BB', data[0x16655E:0x16656A]), '      ')
    stream.write('    },\n    images={\n')
    for palette, (turret, wreck) in images.items():
        stream.write(f'      [{palette}]={{' + lua_row(turret) + f',{wreck}}},\n')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>32i', data, 0x15DDD2)) + ',\n')
    stream.write('  },\n')


def stage2_carrier_images(data, sprite, extra_colors):
    palettes = (14, 15, 18, 19, 20, 21, 22, 25, 31)
    colors = {20: extra_colors[0xC4438], 21: extra_colors[0xC4478], 25: extra_colors[0xC71F8]}
    images = {}
    for bank in palettes:
        color = colors.get(bank, bank)
        images[bank] = {
            'largeBody': [sprite(pointer(data, 0x165868), 0x1858, color)],
            'body': [sprite(pointer(data, 0x1660BA), 0xE40, color)],
            'sideTurrets': [sprite(pointer(data, 0x15DE52+i*4), 0x620, color) for i in range(32)],
            'turrets': [sprite(pointer(data, 0x15DED2+i*4), 0x620, color) for i in range(32)],
            'caps': [sprite(address, 0x818, color) for address in (0xCD138, 0xCD0D4, 0xCDEBC)],
            'lightsA': [sprite(pointer(data, 0x165F44+i*4), 0x210, color) for i in range(8)],
            'lightsB': [sprite(pointer(data, 0x165F64+i*4), 0x210, color) for i in range(8)],
        }
    colors[10] = extra_colors[0xC4938]
    treads = {name: {bank: [sprite(pointer(data, address+i*4), size, colors.get(bank, bank)) for i in range(16)]
                     for bank in (10, 25, 31)}
              for name,address,size in (('largeTracks',0x164804,0xA50),('smallTracks',0x1652BC,0x628))}
    return images, treads


def emit_stage2_carriers(stream, data, images):
    stream.write('  stage2Carriers={\n')
    for name, base, state, end, colors, destruction in (
        ('large', 0x165862, 0x165838, 0x165862, 0x16582C, 0x165E90),
        ('small', 0x1660B4, 0x166092, 0x1660B4, 0x166086, 0x166470),
    ):
        stream.write(f'    {name}={{\n      parts={{\n')
        for address in (base, base+0x20):
            flags = struct.unpack_from('>H', data, address)[0]
            emit_rows(stream, [(flags, *struct.unpack_from('>5H', data, address+12))], '        ')
        stream.write('      },\n      state=' + lua_row(struct.unpack_from(f'>{end-state}B', data, state)) + ',\n')
        stream.write(f'      health={struct.unpack_from(">I", data, base+0x36)[0]},\n')
        stream.write('      palettes={\n')
        emit_rows(stream, struct.iter_unpack('>BB', data[colors:colors+12]), '        ')
        stream.write('      },\n      destruction={\n')
        emit_rows(stream, explosion_rows(data, destruction), '        ')
        stream.write('      },\n    },\n')
    stream.write('    images={\n')
    banks,treads = images
    for bank, groups in banks.items():
        stream.write(f'      [{bank}]={{\n')
        for name,row in groups.items():
            stream.write(f'        {name}=' + lua_row(row) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n')
    for name,groups in treads.items():
        stream.write(f'    {name}={{\n')
        for bank,row in groups.items():
            stream.write(f'      [{bank}]=' + lua_row(row) + ',\n')
        stream.write('    },\n')
    stream.write('    muzzles=' + lua_row(struct.unpack_from('>32i', data, 0x15E0D2)) + ',\n')
    for name,address in (('hatchOffsetsA',0x165F84),('hatchOffsetsB',0x165FB0)):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from('>11i', data, address)) + ',\n')
    stream.write('  },\n')


def stage2_fort_images(data, sprite, extra_colors):
    shed = {}
    for palette, color in ((13, extra_colors[0xC6A38]), (14, 14), (25, extra_colors[0xC71F8]), (26, 26), (31, 31)):
        shed[palette] = [sprite(address, size, color) for address, size in
                         ((0x3135EC, 0x1010), (0x313670, 0x1010), (0x3136F4, 0x1428))]
    cannons = {}
    colors = {20: extra_colors[0xC4438], 22: extra_colors[0xC43B8], 25: extra_colors[0xC71F8]}
    for palette in (19, 20, 22, 25, 31):
        color = colors.get(palette, palette)
        cannons[palette] = {
            'body': [sprite(pointer(data, 0x166FD2), 0xE88, color)],
            'tracks': [sprite(pointer(data, 0x167666+i*4), 0x458, color) for i in range(4)],
            'hullDetail': [sprite(pointer(data, 0x167676), 0x438, color)],
            'turrets': [sprite(pointer(data, 0x15CB52+i*4), 0x830, color) for i in range(32)],
        }
    return shed, cannons, sprite(0x28D2B0, 0x210, 26)


def emit_stage2_forts(stream, data, images):
    shed, cannons, bullet = images
    stream.write('  stage2Forts={\n')
    for name, base, state, end, colors in (('shed', 0x166888, 0x166880, 0x166888, 0x166874),
                                           ('cannons', 0x166FCC, 0x166FA2, 0x166FCC, 0x166F96)):
        flags = struct.unpack_from('>H', data, base)[0]
        stream.write(f'    {name}={{\n      body=' + lua_row((flags, *struct.unpack_from('>5H', data, base+12))) + ',\n')
        stream.write('      state=' + lua_row(data[state:end]) + ',\n      palettes={\n')
        emit_rows(stream, struct.iter_unpack('>BB', data[colors:colors+12]), '        ')
        stream.write('      },\n      destruction={\n')
        address = 0x166A72 if name == 'shed' else 0x167580
        rows = []
        while struct.unpack_from('>H', data, address)[0] != 0xFFFF:
            kind, dh, dl, ground, velocity, _, _, delay = struct.unpack_from('>HhhHHHHH', data, address)
            rows.append((kind, dh, dl, ground, velocity, delay))
            address += 16
        emit_rows(stream, rows, '        ')
        stream.write('      },\n    },\n')
    stream.write('    shedImages={\n')
    for palette,row in shed.items():
        stream.write(f'      [{palette}]=' + lua_row(row) + ',\n')
    stream.write('    },\n    cannonImages={\n')
    for palette,group in cannons.items():
        stream.write(f'      [{palette}]={{\n')
        for name,row in group.items():
            stream.write(f'        {name}=' + lua_row(row) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n    roundImage=' + lua_row([bullet]) + ',\n')
    stream.write('    muzzle=' + lua_row(struct.unpack_from('>32i', data, 0x15CBD2)) + ',\n  },\n')


def emit_gunship(stream, data, gunship):
    shapes, turrets, images, arrows, rounds = gunship
    flags = struct.unpack_from('>H', data, 0x16C34A)[0]
    front, back, right, left, hp = struct.unpack_from('>5H', data, 0x16C356)
    status = struct.unpack_from('>BBHH', data, 0x16C324)
    stream.write('  gunshipStart={\n')
    stream.write('    body=' + lua_row((flags, hp, front, back, right, left, data[0x16C360])) + ',\n')
    stream.write('    status=' + lua_row(status) + ',\n')
    for name, address in (('main', 0x16C32C), ('wing', 0x16C332)):
        stream.write(f'    {name}=' + lua_row(data[address:address + 6:2]) + ',\n')
    stream.write('  },\n')
    stream.write('  gunshipShapes={\n')
    emit_rows(stream, ((h, l, size, wing_a, wing_b) for h, l, _, size, wing_a, wing_b in shapes), '    ')
    stream.write('  },\n  gunshipImages={\n')
    for bank, groups in images.items():
        stream.write(f'    [{bank}]={{' + ','.join(map(lua_row, groups)) + '},\n')
    stream.write('  },\n  gunshipArrowImages={\n')
    emit_rows(stream, arrows, '    ')
    stream.write('  },\n  gunshipRoundImages=' + lua_row(rounds) + ',\n')
    stream.write('  gunshipWingSprites=' + lua_row([offset for offset, _ in turrets]) + ',\n')
    stream.write('  gunshipSmoke=' + lua_row(struct.unpack_from('>8H', data, 0x16C9A6)) + ',\n')
    for name, address, count in (('gunshipMainMuzzles', 0x16CF36, 64), ('gunshipMainShotOffsets', 0x15CC52, 64),
                                 ('gunshipWingMuzzles', 0x16D036, 32), ('gunshipSmokeH', 0x11B056, 64),
                                 ('gunshipSmokeL', 0x11AF12, 64)):
        stream.write(f'  {name}=' + lua_row(struct.unpack_from(f'>{count}i', data, address)) + ',\n')
    stream.write('  gunshipDestruction={\n')
    emit_rows(stream, explosion_rows(data, 0x16C938), '    ')
    stream.write('  },\n')


def effect_frames(data, sprite, kind, bank):
    base = 0xC29C0 if kind & 0x80 else 0xC2920
    command, timer = struct.unpack_from('>II', data, base + (kind & 0x7F) * 8)
    frames = []
    while True:
        duration = struct.unpack_from('>H', data, timer)[0]
        if duration == 0xFFFF:
            return frames
        timer += 2
        change = 0
        address = pointer(data, command)
        while address & 0x80000000:
            op = address >> 16
            if op == 0xFFFF:
                size, dh, dl = struct.unpack_from('>Hhh', data, command + 2)
                command += 8
            elif op == 0xFFFE:
                change += struct.unpack_from('>i', data, command + 4)[0]
                command += 8
            else:
                raise ValueError(f'未知效果指令 {command:#x}')
            address = pointer(data, command)
        command += 4
        frames.append((duration, dh, dl, change, sprite(address, size, bank)))


def pilot_shot_data(data, sprite, awakened=False):
    # 0x122d10 在通常形态中按火力档查炮口。0x1235a0 分别读右炮和镜像左炮。
    levels = []
    for level in range(5):
        address = pointer(data, (0x1297E4 if awakened else 0x12884E) + level * 4)
        count = struct.unpack_from('>H', data, address)[0]
        sides = []
        for flags, table, damage, speed, attr, _ in struct.iter_unpack('>HIHBBH', data[address + 2:address + 2 + count * 12]):
            variants = []
            for index in range(9):
                variant = pointer(data, table + index * 4)
                h,l,dh,dl,images,size,front,back,right,left,flight,transform = struct.unpack_from('>hhhhIHHHHHIH', data, variant)
                move = pointer(data, (0x129E1A if awakened else 0x128E84) + transform)
                fd_h,fd_l,fs,shift_h,shift_l = struct.unpack_from('>5h', data, move)
                palette = 3 if awakened else 2
                spawn = [sprite(pointer(data, images + frame * 4), size, palette) for frame in range(3)]
                moving = [sprite(pointer(data, flight + frame * 4), fs, palette) for frame in range(3)]
                hit = pointer(data, (0x12A090 if awakened else 0x1290FA) + transform)
                hit_h,hit_l,hit_size,hit_images,hit_period,hit_offset = struct.unpack_from('>hhHIHH', data, hit)
                impact = [sprite(pointer(data, hit_images + frame * 4), hit_size, palette)
                          for frame in range(hit_offset // 4)]
                variants.append(((h,l,dh,dl,front,back,right,left,fd_h,fd_l,shift_h,shift_l), spawn, moving,
                                 (hit_h, hit_l, hit_period >> 8, hit_period & 255), impact))
            sides.append(((flags, damage, speed, attr), variants))
        levels.append(sides)
    return levels


def ageha_data(data, sprite, colors):
    # 模式号来自 0x131c5a 的字节偏移。每个二级指针指向同一模式的逐帧机体。
    poses = (
        (0,0x131CBA,16),(1,0x1321CA,44),(2,0x1321CA,44),(3,0x132F9A,28),(4,0x13386A,28),
        (5,0x13413A,4),(6,0x13413A,4),(7,0x13428A,4),(8,0x1343DA,4),(9,0x13452A,16),
        (10,0x134A3A,44),(11,0x134A3A,44),(12,0x13580A,4),(13,0x13580A,4),(14,0x13595A,16),
        (15,0x135E6A,4),(18,0x13610A,16),(19,0x13661A,8),(20,0x1368AA,6),
        (21,0x136A9A,8),(22,0x136D2A,4),
    )
    forms = []
    lasers = []
    for form in range(2):
        moves = {}
        for pose,table,count in poses:
            sequence = pointer(data,table + 4*form)
            rows = []
            for frame in range(count):
                address = pointer(data,sequence + 4*frame)
                base,offset,image,size,resume = struct.unpack_from('>iiIHH',data,address)
                h,l = struct.unpack('>hh',struct.pack('>I',(base + offset) & 0xffffffff))
                rows.append((sprite(image,size,4*form),h,l,resume//4))
            moves[pose] = rows
        forms.append(moves)
        fire = []
        table = (0x12C7CA,0x12C7DE)[form]
        for power in range(5):
            address = pointer(data,table + 4*power)
            mounts,sequence = struct.unpack_from('>II',data,address)
            muzzle = list(struct.iter_unpack('>hh',data[mounts:mounts + 4*(2+2*form)]))
            _,head,_ = struct.unpack_from('>HIH',data,sequence)
            head_images = []
            for i in range(2):
                _,size,h,l,image = struct.unpack_from('>HHhhI',data,head + 12*i)
                head_images.append((sprite(image,size,2+form),h,l))
            _,h,l,size,beam = struct.unpack_from('>HhhHI',data,sequence+8)
            beam_images = [sprite(pointer(data,beam+4*i),size,2+form) for i in range(4)]
            _,tip_h,tip_l,tip_size,tip = struct.unpack_from('>HhhHI',data,sequence+8+13*12)
            tip_images = [sprite(pointer(data,tip+4*i),tip_size,2+form) for i in range(4)]
            _,length,width,_,damage,_,tip_length = struct.unpack_from('>7H',data,sequence+0xb6)
            fire.append((muzzle,(length,width,damage,tip_length,h,l,tip_h,tip_l),
                         head_images,beam_images,tip_images))
        lasers.append(fire)
    # 0x16fd26 把类型记录挂进 100 槽池，移动和拾取均使用同一槽。
    rewards = {}
    gold_scores = (10,15,20,30,35,40,60,65,70,90)
    gold_strides = (0x14,0x24,0x24,0x24,0x24,0x34,0x34,0x34,0x34,0x64)
    kinds = [(i*4,stride,0,score) for i,(stride,score) in enumerate(zip(gold_strides,gold_scores))]
    kinds += [(0x28,0x34,2,0),(0x2C,0x24,1,0)]
    for kind,step,value,score in kinds:
        row = pointer(data,0x16FDF2+kind)
        h,l,address,size,speed,angle = struct.unpack_from('>hhIHbB',data,row)
        images = [sprite(address+step*i,size,28) for i in range(16)]
        rewards[kind] = (h,l,speed,angle,value,score,images)
    converted = []
    for index in range(100):
        address,h,l,size = struct.unpack_from('>IhhH',data,0x170212+index*10)
        converted.append((h,l,sprite(address,size,colors[0xC5F38]),sprite(address,size,colors[0xC6478])))
    return forms,lasers,rewards,converted,list(guard_data(data,sprite))


def guard_data(data,sprite):
    # 0x131b6e 的护罩、0x124dca 的放射束和 0x124f2e 的收束记录分别有自己的格式。
    for palette in (2,3):
        opening = []
        start = pointer(data,0x12DEAA)
        for i in range(27):
            address,h,l,size,front,back,right,left = struct.unpack_from('>Ihh5H',data,start+i*18)
            opening.append((sprite(address,size,palette),h,l,front,back,right,left,128))
        charge = []
        for base,count in ((0x12E0BC,56),(0x12E4DC,8)):
            for i in range(count):
                h,l,address,size,zoom,front,back,right,left = struct.unpack_from('>hhIHI4H',data,base+22*i)
                charge.append((sprite(address,size,palette),h,l,front,back,right,left,zoom >> 24))

        def beam_shape(row,step):
            frames = []
            while data[row:row+2] != b'\xff\xff':
                address,h,l,size = struct.unpack_from('>IhhH',data,row)
                frames.append((sprite(address,size,palette),h,l))
                row += step
            return frames

        def fade_shape(row,count):
            frames = []
            for i in reversed(range(count)):
                address,h,l,size,width = struct.unpack_from('>IhhHH',data,row+12*i)
                frames.append((sprite(address,size,palette),h,l,width))
            return frames

        levels = []
        for table in (0x12E880,0x12EA36,0x12ECC2,0x12F024):
            count,positions,sequence = struct.unpack_from('>HII',data,table)
            closing = pointer(data,0x12F722+(count-1)*4)
            lanes = []
            for i in range(count):
                h,l = struct.unpack_from('>hh',data,positions+4*i)
                row,tail = sequence+210*i,closing+102*i
                lead = pointer(data,row+2)
                start = []
                while data[lead:lead+2] != b'\xff\xff':
                    _,size,address,dh,dl = struct.unpack_from('>HHIhh',data,lead)
                    start.append((sprite(address,size,palette),dh,dl))
                    lead += 12
                end_body = pointer(data,lead+2)
                dh,dl,size,images = struct.unpack_from('>hhHI',data,end_body)
                head = (dh,dl,[sprite(pointer(data,images+n*4),size,palette) for n in range(4)])
                bh,bl,bsize,body = struct.unpack_from('>hhHI',data,row+10)
                body = (bh,bl,[sprite(pointer(data,body+n*4),bsize,palette) for n in range(4)])
                th,tl,tsize,tip = struct.unpack_from('>hhHI',data,row+178)
                tip = (th,tl,[sprite(pointer(data,tip+n*4),tsize,palette) for n in range(4)])
                _,length,back,width,_,damage,_,_ = struct.unpack_from('>8H',data,row+194)
                fade,offset,reload = struct.unpack_from('>IHH',data,tail+2)
                fade_head = fade_shape(fade,offset//12)
                fade_body = fade_shape(pointer(data,tail+12),offset//12)
                tip_end = beam_shape(pointer(data,tail+96),10)
                lanes.append(((h,l,length,back,width,damage,reload+1),start,head,body,tip,fade_head,fade_body,tip_end))
            levels.append(lanes)
        yield opening,charge,levels


def emit_ageha(stream,data,art):
    poses,lasers,rewards,converted,guard = art
    stream.write('  agehaForm={\n')
    for address in (0x12786A, 0x12787A):
        stream.write('    '+lua_row(struct.unpack_from('>4H4B',data,address))+',\n')
    stream.write('  },\n  agehaAwakeBurst='+lua_row(struct.unpack_from('>5H',data,0x1278BA))+',\n')
    stream.write('  agehaPose={\n')
    for form in poses:
        stream.write('    {\n')
        for key,rows in form.items():
            stream.write(f'      [{key}]={{\n')
            emit_rows(stream,rows,'        ')
            stream.write('      },\n')
        stream.write('    },\n')
    stream.write('  },\n  agehaLaser={\n')
    for form in lasers:
        stream.write('    {\n')
        for mounts,fields,heads,beam,tip in form:
            stream.write('      {mounts={\n')
            emit_rows(stream,mounts,'        ')
            stream.write('      },field='+lua_row(fields)+',heads={\n')
            emit_rows(stream,heads,'        ')
            stream.write('      },beam='+lua_row(beam)+',tip='+lua_row(tip)+'},\n')
        stream.write('    },\n')
    stream.write('  },\n  agehaMotion={\n')
    for address in (0x131C1A,0x131C2A,0x131C3A,0x131C4A):
        stream.write('    '+lua_row(v//4 for v in struct.unpack_from('>8H',data,address))+',\n')
    stream.write('  },\n  rewardScatter='+lua_row(struct.unpack_from('>64i',data,0x11B056))+',\n')
    stream.write('  rewardSpeed='+lua_bytes(data[0x11A19C:0x11A29C])+',\n')
    stream.write('  rewards={\n')
    for kind,(h,l,speed,angle,value,score,images) in rewards.items():
        stream.write(f'    [{kind}]={{field='+lua_row((h,l,speed,angle,value,score))+',images='+lua_row(images)+'},\n')
    stream.write('  },\n  conversionJitter='+lua_bytes(data[0x11A38C:0x11A48C])+',\n')
    stream.write('  goldFlash={\n')
    emit_rows(stream,converted,'    ')
    stream.write('  },\n')
    stream.write('  agehaGuard={\n')
    for opening,charge,levels in guard:
        stream.write('    {opening={\n')
        emit_rows(stream,opening,'      ')
        stream.write('    },charge={\n')
        emit_rows(stream,charge,'      ')
        stream.write('    },levels={\n')
        for lanes in levels:
            stream.write('      {\n')
            for fields,start,head,body,tip,fade_head,fade_body,tip_end in lanes:
                stream.write('        {field='+lua_row(fields)+',start={\n')
                emit_rows(stream,start,'          ')
                for name,(h,l,images) in zip(('head','body','tip'),(head,body,tip)):
                    stream.write(f'        }},{name}={{'+f'{h},{l},'+lua_row(images))
                for name,frames in zip(('fadeHead','fadeBody','fadeTip'),(fade_head,fade_body,tip_end)):
                    stream.write(f'        }},{name}={{\n')
                    emit_rows(stream,frames,'          ')
                stream.write('        }},\n')
            stream.write('      },\n')
        stream.write('    }},\n')
    stream.write('  },\n')


def mid2_images(data, sprite, colors):
    groups = (
        (0x1B1F80, 16, 0xE68), (0x1B210A, 48, 0xE68),
        (0x1B24D8, 8, 0xC50), (0x1B24F8, 8, 0x618), (0x1B2518, 8, 0x438),
        (0x1B2602, 8, 0xC50), (0x15D652, 32, 0x628),
        (0x1B2770, 8, 0xC50), (0x1B2790, 20, 0x628), (0x1B27E0, 8, 0x410),
    )
    images = []
    for body, wings in ((0xC57F8, 0xC57B8), (0xC57F8, 0xC5778), (0xC71F8, 0xC71F8)):
        images.append([[sprite(pointer(data, a + i*4), size, colors[body if j < 2 else wings])
                        for i in range(n)] for j,(a,n,size) in enumerate(groups)])
    turret = []
    for body, wings in ((0xC57F8, 0xC57B8), (0xC57F8, 0xC5778), (0xC71F8, 0xC71F8)):
        shapes = (struct.unpack_from('>IiH', data, a) for a in range(0x1B2622, 0x1B2682, 12))
        turret.append([(sprite(a, size, colors[wings]), offset) for a, offset, size in shapes])
    puff = [(sprite(address, size, colors[0xC67F8]), h, l) for address, h, l, _, size in
            struct.iter_unpack('>IhhHH', data[0x16561E:0x16579E])]
    drone = [sprite(pointer(data,0x1B53D2+i*4),0x628,colors[0xC57B8]) for i in range(8)]
    rounds = [sprite(pointer(data,pointer(data,0x175312+i*4)+4),0x210,26) for i in range(3)]
    return images, turret, puff, drone, rounds


def emit_mid2(stream, data, images):
    banks, turret, puff, drone, rounds = images
    health = pointer(data,0x1B1D42)
    threshold = pointer(data,0x1B1D4C)
    stream.write(f'  mid2={{health={health},threshold={threshold},\n    parts={{\n')
    for index in range(1,10):
        addr = 0x1B1D50 + index * 0x20
        flags = struct.unpack_from('>H', data, addr)[0]
        emit_rows(stream, [(flags, *struct.unpack_from('>5h', data, addr+12))], '      ')
    stream.write('    },\n    orbit={\n')
    offsets = struct.unpack_from('>256h', data, 0x118528)
    for radius in range(0x51):
        source = pointer(data, 0x920 + radius*4)
        row = bytearray()
        for angle, offset in enumerate(offsets):
            h, l = struct.unpack_from('>2i', data, source + offset)
            h, l = h >> 1, l >> 1
            quadrant = angle >> 6
            if quadrant in (1,2):
                h = -h
            if quadrant in (2,3):
                l = -l
            row.extend(struct.pack('>hh', h,l))
        stream.write('      ' + lua_bytes(row) + ',\n')
    stream.write('    },\n    images={\n')
    for bank in banks:
        stream.write('      {\n')
        emit_rows(stream, bank, '        ')
        stream.write('      },\n')
    stream.write('    },\n    turret={\n')
    for bank in turret:
        stream.write('      {\n')
        emit_rows(stream, bank, '        ')
        stream.write('      },\n')
    stream.write('    },\n    exhaust={\n')
    emit_rows(stream, puff, '      ')
    stream.write('    },\n')
    stream.write('    drone=' + lua_row(drone) + ',\n    rounds=' + lua_row(rounds) + ',\n')
    for i,(address,count) in enumerate(((0x1B47D6,16),(0x1B48DA,22),(0x1B4A72,14),
                                      (0x1B4B76,16),(0x1B4C46,22),(0x1B4D44,16))):
        stream.write(f'    event{i}=' + lua_row(data[address:address+count]) + ',\n')
    for name,address,count in (('muzzle0',0x15CC52,64),('muzzle1',0x15CE52,64),('gunOffset',0x15D6D2,32)):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from(f'>{count}i', data, address)) + ',\n')
    stream.write('    volley={\n')
    emit_rows(stream, struct.iter_unpack('>hi', data[0x1B4B52:0x1B4B76]), '      ')
    stream.write('    },\n    explosions={\n')
    for address in (0x1B2DEC,0x1B2F06,0x1B3020,0x1B3338,0x1B347E):
        stream.write('      {\n')
        emit_rows(stream, explosion_rows(data,address), '        ')
        stream.write('      },\n')
    stream.write('    },\n')
    stream.write('    patternRandom=' + lua_bytes(data[0x11A9A6:0x11AA26]) + ',\n  },\n')


def stage2_tail_images(data, sprite, colors):
    colors = {12: colors[0xC4838], 14: 14, 16: 16, 17: colors[0xC4178],
              22: colors[0xC4838], 25: colors[0xC71F8], 31: 31}

    def images(table, count, size, palettes):
        pointers = struct.unpack_from(f'>{count}I', data, table)
        return {bank: [sprite(addr, size, colors[bank]) if addr else 0 for addr in pointers] for bank in palettes}

    wreck = [sprite(pointer(data,pointer(data,0x167E24+i*4)),0x210,colors[25]) for i in range(4)]
    return {
        'leadBody': images(0x167AA0,64,0xE50,(14,16,17,22,25,31)),
        'leadTurret': images(0x15E152,32,0x628,(14,16,17,22,25,31)),
        'childBody': images(0x16853A,64,0xC40,(12,14,17,31)),
        'childTurret': images(0x15D252,32,0x620,(14,17,25,31)),
    }, wreck


def emit_stage2_tail(stream, data, art):
    banks, wreck = art
    stream.write('  stage2Tail={\n')
    for name,path_addr,part_addr,state_len in (('lead',0x167756,0x16776A,20),
                                             ('child',0x167E34,0x167E5E,42),
                                             ('tank',0x15A6B6,0x15A6D2,28)):
        flags,dh,dl = struct.unpack_from('>Hhh',data,part_addr)
        bounds = struct.unpack_from('>5h',data,part_addr+12)
        stream.write(f'    {name}={{body=' + lua_row((flags,*bounds)) + ',draw=' + lua_row((dh,dl))
                     + ',state=' + lua_row(data[path_addr:path_addr+state_len]) + '},\n')
    for name,addr in (('leadPalettes',0x16774A),('childPalettes',0x167E0C),('childPortPalettes',0x167E18)):
        stream.write(f'    {name}={{\n')
        emit_rows(stream,struct.iter_unpack('>BB',data[addr:addr+12]),'      ')
        stream.write('    },\n')
    for name,addr,count,fmt in (('leadPivot',0x167BA0,64,'>i'),('childPivots',0x16863A,64,'>ii'),
                                ('leadMuzzle',0x15E1D2,32,'>i'),('childMuzzle',0x15D2D2,32,'>i'),
                                ('tankMuzzle',0x15966E,32,'>i'),('leadFireBand',0x11917A,6,'>HH')):
        row = struct.Struct(fmt)
        values = list(row.iter_unpack(data[addr:addr+row.size*count]))
        if len(values[0])==1:
            stream.write(f'    {name}=' + lua_row(v[0] for v in values) + ',\n')
        else:
            stream.write(f'    {name}={{\n')
            emit_rows(stream,values,'      ')
            stream.write('    },\n')
    for name,group in banks.items():
        stream.write(f'    {name}={{\n')
        for palette,entries in group.items():
            stream.write(f'      [{palette}]=' + lua_row(entries) + ',\n')
        stream.write('    },\n')
    stream.write('    wreck=' + lua_row(wreck) + ',\n')
    stream.write('    wreckRandom=' + lua_bytes(data[0x11AA80:0x11AAC0]) + ',\n  },\n')


def boss2_images(data, sprite, colors):
    tables = (
        ('cockpit',0x18F1E0,8,0xE70,15), ('hull',0x18F174,8,0xE70,15),
        ('core',0x18F254,16,0x820,17), ('rotor',0x18F2C2,8,0xA48,17),
        ('wing',0x18F340,8,0xE58,17), ('damagedWing',0x18F38E,16,0x1458,17),
        ('cannon',0x18F4FE,32,0xA40,17),
    )
    banks = {13: colors[0xC4CB8], 15: colors[0xC4C78], 17: colors[0xC4CF8]}
    images = {}
    for name,addr,count,size,palette in tables:
        images[name] = {bank: [sprite(pointer(data,addr+i*4),size,color) for i in range(count)]
                        for bank,color in ((palette,banks[palette]),(25,colors[0xC71F8]),(31,31))}
    for name,addr,size,bank in (('openCockpit',0x1304DC,0xA40,15), ('nose',0x130620,0x650,13),
                               ('engine',0x131FB4,0x1A48,13)):
        images[name] = {i: [sprite(addr,size,color)] for i,color in ((bank,banks[bank]),(25,colors[0xC71F8]),(31,31))}
    images['orb'] = {26: [sprite(pointer(data,0x192F22+i*4),0x410,26) for i in range(4)]}
    images['mine'] = {bank: [sprite(pointer(data,0x192DC8+i*4),0x620,color) for i in range(8)]
                      for bank,color in ((14,colors[0xC4D38]),(31,31))}
    return images, sprite(0x28D3E0,0x410,26)


def emit_boss2(stream, data, images, round_image):
    stream.write('  boss2={\n')
    stream.write('    health=' + lua_row(struct.unpack_from('>4I',data,0x18EF36)) + ',\n')
    stream.write('    timeout=' + lua_row(struct.unpack_from('>3H',data,0x18EF46)) + ',\n')
    stream.write('    parts={\n')
    for i in range(10):
        addr = 0x18EF4C+i*0x20
        flags = struct.unpack_from('>H',data,addr)[0]
        aim = data[addr+22]
        bounds = struct.unpack_from('>5h',data,addr+12)
        emit_rows(stream,[(flags,*bounds,aim)],'      ')
    stream.write('    },\n    images={\n')
    for name,banks in images.items():
        stream.write(f'      {name}={{\n')
        for bank,frames in banks.items():
            stream.write(f'        [{bank}]=' + lua_row(frames) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n')
    stream.write(f'    round={round_image},\n')
    stream.write('    ringOrder=' + lua_bytes(data[0x11AA80:0x11AAC0]) + ',\n    ringPorts={\n')
    emit_rows(stream, ((i + 3 for i in row) for row in struct.iter_unpack('>4H',data[0x191AE0:0x191B00])),
              '      ')
    stream.write('    },\n')
    for name,addr,n in (('cannonMuzzle',0x19162A,32),('wanderH',0x11AF12,64),('wanderL',0x11ADCE,64)):
        rows = struct.unpack_from(f'>{n}i',data,addr)
        if name!='cannonMuzzle':
            rows = [((v+32768)&65535)-32768 for v in rows]
        stream.write(f'    {name}=' + lua_row(rows) + ',\n')
    stream.write('    wanderPacked=' + lua_row(struct.unpack_from('>64i',data,0x11AF12)) + ',\n')
    stream.write('    innerMuzzle=' + lua_row(struct.unpack_from('>64i',data,0x15D152)) + ',\n')
    stream.write('    sweepAngles=' + lua_row(n & 255 for n in struct.unpack_from('>3H',data,0x19231A)) + ',\n')
    stream.write('    sweepOffsets=' + lua_row(struct.unpack_from('>6i',data,0x190966)) + ',\n')
    stream.write('    recoilEffects=' + lua_row(struct.unpack_from('>8H',data,0x19053C)) + ',\n')
    stream.write('    recoilOffsets=' + lua_row(row[1] for row in struct.iter_unpack('>hh',data[0x11B056:0x11B156])) + ',\n')
    stream.write('    finalTurn=' + lua_bytes(data[0x11A84C:0x11A94C]) + ',\n')
    stream.write('    defeatOffsets=' + lua_row(struct.unpack_from('>3i',data,0x190250)) + ',\n')
    for name,addr in (('defeatCycle',0x1902BE),('defeatBlast',0x13BA8C)):
        stream.write(f'    {name}={{\n')
        struct_row = struct.Struct('>HHhhHHHHH')
        while struct.unpack_from('>H',data,addr)[0]!=0xFFFF:
            emit_rows(stream,[struct_row.unpack_from(data,addr)],'      ')
            addr += struct_row.size
        stream.write('    },\n')
    stream.write('    minePart=' + lua_row(struct.unpack_from('>H10x5H',data,0x192C38)) + ',\n')
    stream.write('    wingBounds={\n')
    emit_rows(stream,struct.iter_unpack('>hhhh',data[0x18FDD6:0x18FE56]),'      ')
    stream.write('    },\n    explosions={\n')
    for addr in (0x191240,0x191410,0x191464,0x1914AA,0x1914F0,0x1901D6):
        stream.write('      {\n')
        while struct.unpack_from('>H',data,addr)[0]!=0xFFFF:
            delay,kind,_,dh,dl,motion = struct.unpack_from('>HHHhhH',data,addr)
            emit_rows(stream,[(kind,dh,dl,motion,delay)],'        ')
            addr += 12
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage3_airship_images(data, sprite, extra_colors):
    layouts = [
        (
            (0xDD2F4,0xE18,0xF8010A00,1), (0xDD3A0,0x1010,0xF4010600,1),
            (0xDD424,0x1010,0xF1010200,1), (0xDD4A8,0x1018,0xF040FC00,1),
            (0xDD56C,0x1010,0xECC0F800,1), (0xDD5F0,0xE10,0xEC00F400,1),
            (0xDD704,0xC10,0xEC00F000,1), (0x151AE4,0x210,0x0400FEC0,8),
            (0x151B04,0x408,0xF4010400,8), (0x151B24,0x210,0xF100FB00,8),
            (0x151B44,0x210,0xFA010800,8),
        ),
        (
            (0xDD948,0xA10,0xFC010C00,1), (0xDD99C,0xE18,0xF8010600,1),
            (0xDDA48,0x1018,0xF2010000,1), (0xDDB0C,0x1010,0xF0C0FC00,1),
            (0xDDB90,0x1018,0xEEC0F600,1), (0xDDC54,0xE18,0xEE00F000,1),
            (0x1528C6,0x210,0x0500FD00,8), (0x1528E6,0x408,0xF3010000,8),
            (0x152906,0x210,0xFA010400,8), (0x152926,0x210,0xF100F700,8),
        ),
        (
            (0xDDF80,0xC18,0xFA010900,1), (0xDE014,0xE18,0xF6010300,1),
            (0xDE0C0,0xE10,0xF280FF00,1), (0xDE134,0xE10,0xF000FB00,1),
            (0xDE1A8,0xE10,0xEE00F700,1), (0xDE21C,0xC10,0xEE80F300,1),
            (0xDE320,0x408,0xF200F100,1), (0x1535EA,0x210,0xFB810840,8),
            (0x15360A,0x210,0xF280F940,8), (0xDE478,0x620,0x06810440,1),
            (0xDE4DC,0x620,0xFE80F540,1),
        ),
        (
            (0xDD948,0xA10,0xFC00F000,1), (0xDD99C,0xE18,0xF800F400,1),
            (0xDDA48,0x1018,0xF200FA00,1), (0xDDB0C,0x1010,0xF0C10000,1),
            (0xDDB90,0x1018,0xEEC10400,1), (0xDDC54,0xE18,0xEE010A00,1),
            (0x1528C6,0x210,0x0500FF00,8), (0x1528E6,0x408,0xF300FE00,8),
            (0x152906,0x210,0xFA00F800,8), (0x152926,0x210,0xF1010500,8),
        ),
        (
            (0xDDF80,0xC18,0xFA00F100,1), (0xDE014,0xE18,0xF600F700,1),
            (0xDE0C0,0xE10,0xF280FD00,1), (0xDE134,0xE10,0xF0010100,1),
            (0xDE1A8,0xE10,0xEE010500,1), (0xDE21C,0xC10,0xEE810900,1),
            (0xDE320,0x408,0xF2010D00,1), (0x1535EA,0x210,0xFB80F3C0,8),
            (0x15360A,0x210,0xF28102C0,8), (0xDE334,0x828,0x0101F2C0,1),
        ),
        (),
        (
            (0xDD2F4,0xE18,0xF800F000,1), (0xDD3A0,0x1010,0xF400F600,1),
            (0xDD424,0x1010,0xF100FA00,1), (0xDD4A8,0x1018,0xF040FE00,1),
            (0xDD56C,0x1010,0xECC10400,1), (0xDD5F0,0xE10,0xEC010800,1),
            (0xDD704,0xC10,0xEC010C00,1), (0x151AE4,0x210,0x0400FD40,8),
            (0x151B04,0x408,0xF400FA00,8), (0x151B24,0x210,0xF1010100,8),
            (0x151B44,0x210,0xFA00F400,8),
        ),
        (),
    ]
    layouts[5] = layouts[4][:-1] + ((0xDE478,0x620,0x0680F3C0,1), (0xDE4DC,0x620,0x0302F740,1))
    layouts[7] = layouts[2][:-2] + ((0xDE334,0x828,0x0080FB40,1),)
    colors = {11: extra_colors[0xC4378], 25: extra_colors[0xC71F8], 31: extra_colors[0xC4238]}

    def frames(addr, size, count, color):
        addresses = (addr,) if count == 1 else (pointer(data,addr+i*4) for i in range(count))
        return [sprite(address,size,color) for address in addresses]

    images = []
    for layout in layouts:
        images.append({bank: [(offset,*frames(addr,size,n,color)) for addr,size,offset,n in layout]
                       for bank,color in colors.items()})
    turrets = {bank: frames(0x15E352,0x828,32,color) for bank,color in colors.items()}
    sweep_turrets = {bank: frames(0x15E252,0xA38,32,color) for bank,color in colors.items()}
    colors = {20: extra_colors[0xC4438], 25: extra_colors[0xC71F8], 31: extra_colors[0xC4238]}
    raider = {bank: [sprite(0xE22E8,0x838,color),*frames(0x155880,0x210,8,color)]
              for bank,color in colors.items()}
    colors[10] = extra_colors[0xC4938]
    rotors = {bank: frames(0x1652BC,0x628,16,colors[bank]) for bank in (10,25,31)}
    colors = {12: extra_colors[0xC4178], 19: 19, 21: 21, 25: extra_colors[0xC71F8], 31: extra_colors[0xC4238]}
    platform = {bank: [sprite(0xCB36C,0x830,color),*frames(0x15D752,0x830,32,color)]
                for bank,color in colors.items()}
    return images,turrets,sweep_turrets,platform,raider,rotors


def emit_stage3_airships(stream, data, art):
    images, turrets, sweep_turrets, platform, raider, rotors = art
    stream.write('  stage3Airships={\n')
    stream.write('    palette=' + lua_row(struct.unpack_from('>BB',data,0x151490)) + ',\n    turrets={\n')
    for bank,frames in turrets.items():
        stream.write(f'      [{bank}]=' + lua_row(frames) + ',\n')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>32i',data,0x15E3D2)) + ',\n')
    stream.write('    sweepTurrets={\n')
    for bank,frames in sweep_turrets.items():
        stream.write(f'      [{bank}]=' + lua_row(frames) + ',\n')
    stream.write('    },\n    sweepMuzzle=' + lua_row(struct.unpack_from('>32i',data,0x15E2D2)) + ',\n')
    stream.write('    variants={\n')
    for i,(part,init,burst,destruction) in enumerate(((0x151BF0,0x151BD4,0x152214,0x1521EE),
                                                     (0x1529D2,0x1529B6,0x152FB8,0x152F92),
                                                     (0x154262,0x15424C,0,0x15482A),
                                                     (0x1522D0,0x1522B4,0x152896,0x152870),
                                                     (0x153060,0x153040,0,0x1535C4),
                                                     (0x153C32,0x153C1C,0,0x1541CE),
                                                     (0x1514B4,0x151498,0x151AB4,0x151A8E),
                                                     (0x153698,0x153682,0,0x153B9E))):
        stream.write('      {\n        parts={\n')
        for j in range(2):
            emit_rows(stream,[struct.unpack_from('>H10x5H',data,part+j*0x20)],'          ')
        stream.write('        },\n        health=' + str(pointer(data,init+4)) + ',\n')
        if burst:
            stream.write('        guns={\n')
            emit_rows(stream,struct.iter_unpack('>iB3x',data[burst:burst+48]),'          ')
            stream.write('        },\n')
        stream.write('        destruction={\n')
        while struct.unpack_from('>H',data,destruction)[0]!=0xFFFF:
            delay,kind,_,dh,dl,motion = struct.unpack_from('>HHHhhH',data,destruction)
            emit_rows(stream,[(kind,dh,dl,1,motion,delay)],'          ')
            destruction += 12
        stream.write('        },\n        images={\n')
        for bank,rows in images[i].items():
            stream.write(f'          [{bank}]={{\n')
            emit_rows(stream,rows,'            ')
            stream.write('          },\n')
        stream.write('        },\n      },\n')
    stream.write('    },\n  },\n')
    stream.write('  stage3Platform={\n    body=' + lua_row(struct.unpack_from('>H10x5H',data,0x166BC8)) + ',\n')
    stream.write('    palettes={\n')
    emit_rows(stream,struct.iter_unpack('>BB',data[0x166BAC:0x166BB8]),'      ')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>32i',data,0x15D7D2)) + ',\n')
    stream.write('    images={\n')
    for bank,rows in platform.items():
        stream.write(f'      [{bank}]=' + lua_row(rows) + ',\n')
    stream.write('    },\n  },\n')
    stream.write('  stage3Raider={\n    palette=' + lua_row(struct.unpack_from('>BB',data,0x155458)) + ',\n')
    stream.write('    health=' + str(pointer(data,0x155464)) + ',\n    parts={\n')
    emit_rows(stream,[struct.unpack_from('>H10x5H',data,0x155480+i*0x20) for i in range(2)],'      ')
    stream.write('    },\n    destruction={\n')
    delay,kind,_,dh,dl,motion = struct.unpack_from('>HHHhhH',data,0x1558A0)
    emit_rows(stream,[(kind,dh,dl,1,motion,delay)],'      ')
    stream.write('    },\n')
    for name,frames in (('images',raider),('rotors',rotors)):
        stream.write(f'    {name}={{\n')
        for bank,rows in frames.items():
            stream.write(f'      [{bank}]=' + lua_row(rows) + ',\n')
        stream.write('    },\n')
    stream.write('  },\n')


def mid3_images(data, sprite, colors):
    banks = {}
    for bank,color in ((19,19), (25,colors[0xC71F8]), (31,colors[0xC4238])):
        body = [(sprite(0x1F6B2C,0x810,color),0xE200FE00), (sprite(0x1F68E8,0x1240,color),0xEE00F800)]
        doors = [[(sprite(image,size,color),(offset+side-0xC000000)&0xffffffff)
                  for image,offset,side,size in struct.iter_unpack('>IihH',data[a:a+16*12])]
                 for a in (0x1B57D6,0x1B58C0)]
        wreck = [[sprite(pointer(data,a+i*4),size,color) for i in range(8)]
                 for a,size in ((0x1B59AE,0x1248),(0x1B59FC,0x1050))]
        banks[bank] = body,doors,wreck,[sprite(pointer(data,0x15DB52+i*4),0x628,color) for i in range(32)]
    treads = {bank: [sprite(pointer(data,0x164804+i*4),0xA50,color) for i in range(16)]
              for bank,color in ((20,colors[0xC4438]),(25,colors[0xC71F8]),(31,colors[0xC4238]))}
    ramps = [(sprite(a,size,colors[0xC58B8]),offset)
             for a,offset,size,_ in struct.iter_unpack('>IIHH',data[0x1B5A72:0x1B5B32])]
    drones = {bank: [sprite(pointer(data,0x1B7C5C+i*4),0xC40,color) for i in range(8)]
              for bank,color in ((21,colors[0xC5878]),(25,colors[0xC71F8]),(31,colors[0xC4238]))}
    return banks,treads,ramps,drones


def emit_mid3(stream, data, graphics):
    banks,treads,ramps,drones = graphics
    stream.write('  mid3={\n    parts={\n')
    for i in range(8):
        addr = 0x1B55C0+32*i
        emit_rows(stream,[struct.unpack_from('>H10x5h',data,addr)],'      ')
    stream.write('    },\n    droneParts={\n')
    for i in range(2):
        emit_rows(stream,[struct.unpack_from('>H10x5h',data,0x1B797A+32*i)],'      ')
    stream.write('    },\n    health=' + str(pointer(data,0x1B55B2)) + ',\n')
    stream.write('    muzzle=' + lua_row(struct.unpack_from('>32i',data,0x15DBD2)) + ',\n')
    stream.write('    banks={\n')
    for palette,(body,doors,wreck,turret) in banks.items():
        stream.write(f'      [{palette}]={{\n        body={{\n')
        emit_rows(stream,body,'          ')
        stream.write('        },\n        doors={\n')
        for side in doors:
            stream.write('          {\n')
            emit_rows(stream,side,'            ')
            stream.write('          },\n')
        stream.write('        },\n        wreck={\n')
        emit_rows(stream,wreck,'          ')
        stream.write('        },\n        turret=' + lua_row(turret) + ',\n      },\n')
    stream.write('    },\n    ramps={\n')
    emit_rows(stream,ramps,'      ')
    stream.write('    },\n')
    for name,rows in (('treads',treads),('drones',drones)):
        stream.write(f'    {name}={{\n')
        for palette,frames in rows.items():
            stream.write(f'      [{palette}]=' + lua_row(frames) + ',\n')
        stream.write('    },\n')
    for name,address,count in (('doorBox',0x1B5C1E,32),('wreckBox',0x1B5D80,16)):
        stream.write(f'    {name}={{\n')
        emit_rows(stream,struct.iter_unpack('>hh',data[address:address+count*4]),'      ')
        stream.write('    },\n')
    stream.write('    aimed={\n')
    for address in struct.unpack_from('>4I',data,0x1B7398):
        stream.write('      {\n')
        emit_rows(stream,struct.iter_unpack('>4h',data[address:address+128]),'        ')
        stream.write('      },\n')
    stream.write('    },\n    blasts={\n')
    for a in (0x1B65BA,0x1B6616,0x1B6062):
        stream.write('      {\n')
        while struct.unpack_from('>H',data,a)[0] != 0xFFFF:
            kind,_,dh,dl,_,motion,_,_,delay = struct.unpack_from('>HHhhHHHHH',data,a)
            emit_rows(stream,[(kind,dh,dl,0,motion,delay)],'        ')
            a += 18
        stream.write('      },\n')
    stream.write('    },\n    sparks={\n')
    for a in range(0x1B61A8,0x1B62C8,18):
        kind,_,dh,dl,_,motion,_,_,_ = struct.unpack_from('>HHhhHHHHH',data,a)
        emit_rows(stream,[(kind,dh,dl,motion)],'      ')
    stream.write('    },\n  },\n')


def stage3_tail_images(data, sprite, colors):
    escort = {bank: [sprite(pointer(data,0x15AF5A+i*4),0x828,color) for i in range(64)]
              for bank,color in ((13,colors[0xC4338]),(31,31))}
    vent = {bank: [sprite(pointer(data,0x160802+i*4),0x848,color) for i in range(4)]
            for bank,color in ((13,colors[0xC4338]),(14,14),(19,19),(22,colors[0xC6C38]))}
    deck = []
    for address,size,offset,flip in (
        (0x321E58,0x3890,0xC800DC00,0), (0x321E58,0x3890,0xC8000000,1),
        (0x32640C,0xC20,0x29FFDC00,1), (0x326318,0xC28,0x29FFE400,1),
        (0x32640C,0xC20,0x2A001C00,0), (0x326318,0xC28,0x2A001200,0),
    ):
        deck.append((offset,flip,sprite(address,size,colors[0xC6C38])))
    for table,base in ((0x162A4E,0x29FFDC00),(0x162A2A,0x2A002400)):
        for addr,offset,_,size in struct.iter_unpack('>IiHH',data[table:table+36]):
            frames = [sprite(pointer(data,addr+i*4),size,colors[0xC6C38]) for i in range(8)]
            deck.append(((base+offset)&0xffffffff,0,*frames))
    cover = [sprite(pointer(data,0x16BE96+i*4),0x620,31) for i in range(4)]
    return escort,vent,deck,cover


def emit_stage3_tail(stream, data, graphics):
    escort,vents,deck,cover = graphics
    stream.write('  stage3Tail={\n')
    stream.write('    escortBody=' + lua_row(struct.unpack_from('>H10x5H',data,0x15B2AE)) + ',\n')
    stream.write('    escortMuzzle=' + lua_row(struct.unpack_from('>32i',data,0x15B15A)) + ',\n')
    stream.write('    deckDelays=' + lua_row(struct.unpack_from('>17H',data,0x162A72)) + ',\n')
    stream.write('    ventPalettes={\n')
    emit_rows(stream,struct.iter_unpack('>2B',data[0x160774:0x160780]),'      ')
    stream.write('    },\n')
    for name,bank in (('escortImages',escort),('ventImages',vents)):
        stream.write(f'    {name}={{\n')
        for palette,frames in bank.items():
            stream.write(f'      [{palette}]=' + lua_row(frames) + ',\n')
        stream.write('    },\n')
    stream.write('    deck={\n')
    emit_rows(stream,deck,'      ')
    stream.write('    },\n    coverBody=' + lua_row(struct.unpack_from('>H10x5H',data,0x16BD6E)) + ',\n')
    stream.write('    coverImages=' + lua_row(cover) + ',\n    coverBlast={\n')
    emit_rows(stream,explosion_rows(data,0x16BEA6),'      ')
    stream.write('    },\n  },\n')


def stage3_gun_images(data, sprite, colors):
    hull = {}
    for bank,color in ((22,colors[0xC6C38]),(25,colors[0xC71F8]),(31,31)):
        rows = [(offset,flip,sprite(addr,size,color))
                for addr,size,offset,flip in ((0x32640C,0xC20,0x0000F800,0), (0x32640C,0xC20,0,1),
                                              (0x326318,0xC28,0x0000EE00,0), (0x326318,0xC28,0x800,1))]
        for addr,offset,size in struct.iter_unpack('>III',data[0x160EEE:0x160F36]):
            rows.append((offset,0,*[sprite(pointer(data,addr+i*4),size,color) for i in range(8)]))
        hull[bank] = rows
    turrets = []
    for base,table,count in ((0x161BE8,0x161574,32),(0x1615F4,0x161574,32),(0x162336,0x162236,64)):
        banks = {}
        for bank,color in ((17,colors[0xC6C78]),(25,colors[0xC71F8]),(31,31)):
            rows = []
            for address,attributes in struct.iter_unpack('>HH',data[table:table+count*4]):
                image,offset,size,shift = struct.unpack_from('>IiIi',data,base+address)
                flip = bool(attributes & 0x40)
                if flip:
                    dl = struct.unpack('>h',(shift%65536).to_bytes(2,'big'))[0]
                    shift = (shift&~0xffff) | ((-dl)&0xffff)
                rows.append((sprite(image,size,color),(offset+shift)&0xffffffff,int(flip)))
            banks[bank] = rows
        turrets.append(banks)
    craft = {bank: [sprite(pointer(data,0x155BBE+i*4),0xA30,color) for i in range(3)]
             for bank,color in ((21,colors[0xC46F8]),(25,colors[0xC71F8]),(31,31))}
    return hull,turrets,craft


def timed_stage3_blast(data, address):
    while struct.unpack_from('>H', data, address)[0] != 0xffff:
        delay, kind, _, dh, dl, motion = struct.unpack_from('>HHHhhH', data, address)
        yield kind, dh, dl, 0, motion, delay
        address += 12


def emit_stage3_guns(stream, data, graphics):
    hull,turrets,craft = graphics
    stream.write('  stage3Hull={\n    boxes={\n')
    emit_rows(stream,[struct.unpack_from('>H10x5H',data,0x1608B8+i*32) for i in range(2)],'      ')
    stream.write('    },\n    images={\n')
    for bank,rows in hull.items():
        stream.write(f'      [{bank}]={{\n')
        emit_rows(stream,rows,'        ')
        stream.write('      },\n')
    stream.write('    },\n    blasts={\n')
    for address in (0x161140,0x1611D2):
        stream.write('      {\n')
        emit_rows(stream, timed_stage3_blast(data, address), '        ')
        stream.write('      },\n')
    stream.write('    },\n  },\n  stage3Guns={variants={\n')
    for i,(body,warning,palette,bounds,muzzles,blast) in enumerate((
        (0x16183A,0x2aa,17,(0x1800,0x6800,0x1000,0x9000),(0x161CF8,0x161D78),0x161B9E),
        (0x1612F8,0x155,17,(0x1000,0x5800,0x800,0x8000),(0x161704,),0x161566),
        (0x155960,0x100,21,(0xe00,0x5400,0xa00,0x8400),(),0x155BB0),
        (0x161E84,0x400,17,(0x1800,0x6800,0x1800,0xa000),(0x162546,0x162746,0x162646),0x1621E0),
    )):
        stream.write('    {box=' + lua_row(struct.unpack_from('>H10x5H',data,body)) + ',\n')
        stream.write(f'      warning={warning},palette={palette},flash={palette^31},bounds=' + lua_row(bounds) + ',\n')
        stream.write('      blast={\n')
        emit_rows(stream,timed_stage3_blast(data,blast),'        ')
        stream.write('      },\n      guns={\n')
        emit_rows(stream,[struct.unpack_from('>64i' if i==3 else '>32i',data,a) for a in muzzles],'        ')
        stream.write('      },\n      images={\n')
        for bank,rows in (craft if i==2 else turrets[i if i<2 else i-1]).items():
            if i==2:
                stream.write(f'        [{bank}]=' + lua_row(rows) + ',\n')
            else:
                stream.write(f'        [{bank}]={{\n')
                emit_rows(stream,rows,'          ')
                stream.write('        },\n')
        stream.write('      },\n    },\n')
    stream.write('  }},\n')


def stage3_heavy_images(data, sprite, colors):
    def packed(value):
        return value&0xffffffff

    banks = {}
    for bank,color in ((19,colors[0xC4678]),(25,colors[0xC71F8]),(31,31)):
        body = [
            (sprite(0xE1F64,0xA18,color),packed(0xF600FD00+0xF3FFFBC0)),
            (sprite(0xE1FE0,0xA18,color),packed(0xF600FD00+0xF3FFFBC0+0x880)),
        ]
        for address,offset,side in (
            (0xE1E94,0xEEFFFA40,-1),(0xE1EC8,0xEF7FFD40,1),
            (0xE1EFC,0xEF800300,-1),(0xE1F30,0xEF8005C0,1),
        ):
            body.append((sprite(address,0x610,color),packed(0xFA00FE00+offset),side))
        body.append((sprite(0xE1D40,0xC38,color),0xF400F900))
        wreck = [(sprite(0xE215C,0x410,color),packed(0xFC00FE00+0xF8BFFB40)),
                 (sprite(0xE2180,0x410,color),packed(0xFC00FE00+0xF8BFFB40+0x980)), body[-1]]
        lid = [(sprite(image,size,color),packed(offset+0xFE800000))
               for image,offset,_,size,_ in struct.iter_unpack('>IIIHH',data[0x155136:0x1551B6])]
        banks[bank] = body,wreck,lid
    rotors = {}
    for bank,color in ((10,colors[0xC4938]),(25,colors[0xC71F8]),(31,31)):
        rows = []
        for image,offset,shift,size,_ in struct.iter_unpack('>IIIHH',data[0x1551B6:0x155396]):
            mirror = (shift&~0xffff) | (-shift&0xffff)
            rows.append((sprite(image,size,color),packed(0x09BFF740+offset+shift),packed(0x09C008C0+offset+mirror)))
        rotors[bank] = rows
    return banks,rotors


def emit_stage3_heavy(stream, data, graphics):
    banks,rotors = graphics
    stream.write('  stage3Heavy={\n    parts={\n')
    emit_rows(stream,[struct.unpack_from('>H10x5H',data,0x1548DC+i*32) for i in range(4)],'      ')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>64i',data,0x15CD52)) + ',\n    images={\n')
    for bank,groups in banks.items():
        stream.write(f'      [{bank}]={{\n')
        for name,rows in zip(('body','wreck','lid'),groups):
            stream.write(f'        {name}={{\n')
            emit_rows(stream,rows,'          ')
            stream.write('        },\n')
        stream.write('      },\n')
    stream.write('    },\n    rotors={\n')
    for bank,rows in rotors.items():
        stream.write(f'      [{bank}]={{\n')
        emit_rows(stream,rows,'        ')
        stream.write('      },\n')
    stream.write('    },\n    blasts={\n')
    stream.write('      {\n')
    # 1549dc 比 14ff98 的通用表多一字，供首次动画更新登记二级效果。
    first = struct.iter_unpack('>HHHhhHH', data[0x155396:0x1553CE])
    emit_rows(stream, ((kind, dh, dl, 0, motion, delay)
                       for delay, kind, _, dh, dl, motion, _ in first), '        ')
    stream.write('      },\n      {\n')
    emit_rows(stream, timed_stage3_blast(data, 0x1553D0), '        ')
    stream.write('      },\n')
    stream.write('    },\n  },\n')


def boss3_images(data, sprite, colors):
    palettes = {15: colors[0xC4DB8], 16: colors[0xC4DF8], 17: colors[0xC4E38],
                18: colors[0xC4E78], 25: colors[0xC71F8], 31: 31}
    layers = (
        ('hull', 0x193208, 16, 0x1AA0, (15, 16, 25, 31)),
        ('openHull', 0x19327C, 16, 0x20E0, (15, 25, 31)),
        ('engine', 0x1932F8, 8, 0x16F0, (16, 25, 31)),
        ('wing', 0x193354, 16, 0x1CD0, (18, 25, 31)),
        ('openWing', 0x1933D0, 16, 0x1058, (18, 25, 31)),
        ('chainHead', 0x195CAE, 128, 0xC50, (17, 31)),
        ('flyer', 0x1960F6, 32, 0xA38, (17, 31)),
    )
    images = {name: {bank: [sprite(pointer(data, address + i * 4), size, palettes[bank])
                           for i in range(count)] for bank in banks}
              for name, address, count, size, banks in layers}
    images['chainLink'] = {bank: [sprite(0x158DB8, 0x628, palettes[bank])] for bank in (17, 31)}
    return images


def emit_boss3(stream, data, images):
    stream.write('  boss3={\n')
    stream.write('    health=' + lua_row(struct.unpack_from('>4I', data, 0x1930A8)) + ',\n')
    stream.write('    timeout=' + lua_row(struct.unpack_from('>3H', data, 0x1930B8)) + ',\n')
    stream.write('    flightRates={\n')
    emit_rows(stream, struct.iter_unpack('>BBH', data[0x194148:0x194188]), '      ')
    stream.write('    },\n    parts={\n')
    emit_rows(stream, (struct.unpack_from('>H10x5h', data, 0x1930BE + i * 32) for i in range(3)), '      ')
    stream.write('    },\n    chainSpeed={\n')
    for address, maximum in struct.iter_unpack('>II', data[0x193EF2:0x193F02]):
        stream.write('      {maximum=' + str(maximum) + ',limits={\n')
        while (limit := struct.unpack_from('>H', data, address)[0]) != 0xffff:
            emit_rows(stream, [struct.unpack_from('>HH', data, address)], '        ')
            address += 4
        stream.write('      }},\n')
    stream.write('    },\n    chainRingMuzzles=' + lua_row(struct.unpack_from('>64i', data, 0x15CE52)) + ',\n')
    stream.write('    lastWander=' + lua_row(struct.unpack_from('>64i', data, 0x11AC68)) + ',\n')
    stream.write('    chargeTargets=' + lua_row(struct.unpack_from('>4i', data, 0x194BFE)) + ',\n')
    stream.write('    finalMuzzles=' + lua_row(struct.unpack_from('>256i', data, 0x1970A6)) + ',\n')
    stream.write('    finalAttack=' + lua_row(struct.unpack_from('>14H', data, 0x19791C)) + ',\n')
    stream.write('    flyerOrigins=' + lua_row(struct.unpack_from('>3i', data, 0x196BC2)) + ',\n')
    stream.write('    defeatPorts=' + lua_row(struct.unpack_from('>3i', data, 0x1948AA)) + ',\n')
    for name, address in (('phaseOneBlast', 0x19389A), ('phaseTwoBlast', 0x1939A8),
                          ('defeatBlast', 0x194830), ('defeatSmoke', 0x194918), ('finalBlast', 0x13BA8C)):
        stream.write(f'    {name}={{\n')
        if name in ('defeatSmoke', 'finalBlast'):
            emit_rows(stream, explosion_rows(data, address), '      ')
        else:
            emit_rows(stream, timed_stage3_blast(data, address), '      ')
        stream.write('    },\n')
    stream.write('    images={\n')
    for name, banks in images.items():
        stream.write(f'      {name}={{\n')
        for bank, frames in banks.items():
            stream.write(f'        [{bank}]=' + lua_row(frames) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage4_armor_images(data, sprite, colors):
    palettes = {7: colors[0xC4578], 8: colors[0xC4538], 9: colors[0xC44F8],
                10: colors[0xC4938], 25: colors[0xC71F8], 31: 31}
    assets = {}
    for bank in (9, 25, 31):
        color = palettes[bank]
        assets.setdefault('air', {})[bank] = [sprite(0xCF4F4, 0x640, color),
            *(sprite(pointer(data, 0x169072 + i*4), 0x410, color) for i in range(8))]
    for bank in (10, 25, 31):
        color = palettes[bank]
        rows = []
        for image, offset, shift, size, _ in struct.iter_unpack('>IIIHH', data[0x1551B6:0x155396]):
            left = (0x0F40F6C0 + offset + shift) & 0xffffffff
            right = (left & 0xffff0000) | ((left + 0x1240) & 0xffff)
            rows.append((sprite(image, size, color), left, right))
        assets.setdefault('rotors', {})[bank] = rows
    for bank in (8, 25, 31):
        color = palettes[bank]
        assets.setdefault('tank', {})[bank] = [sprite(pointer(data, 0x169578+i*4), 0xE48, color) for i in range(24)]
        assets.setdefault('tankTurret', {})[bank] = [sprite(pointer(data, 0x15D852+i*4), 0x838, color) for i in range(32)]
    for bank in (7, 25, 31):
        color = palettes[bank]
        assets.setdefault('carrier', {})[bank] = [sprite(0xD41D8, 0x1258, color)]
        assets.setdefault('carrierTurret', {})[bank] = [sprite(pointer(data, 0x15D952+i*4), 0x828, color) for i in range(32)]
        assets.setdefault('carrierTreads', {})[bank] = [sprite(pointer(data, 0x16A65E+i*4), 0x620, color) for i in range(12)]
        assets.setdefault('carrierDoors', {})[bank] = [sprite(pointer(data, 0x16A68E+i*4), 0x620, color) for i in range(16)]
    return assets


def emit_stage4_armor(stream, data, assets):
    stream.write('  stage4Armor={\n')
    for name, address, count, state, state_words in (
        ('air', 0x168AF8, 2, 0x168AD0, 20), ('tank', 0x1691C8, 1, 0x1691A2, 19),
        ('carrier', 0x1697EA, 3, 0x1697C6, 18),
    ):
        stream.write(f'    {name}={{state=' + lua_row(struct.unpack_from(f'>{state_words}H',data,state)) + ',boxes={\n')
        emit_rows(stream, (struct.unpack_from('>H10x5h', data, address + index*32)
                           for index in range(count)), '      ')
        stream.write('    }},\n')
    for name, address, attrs in (
        ('airBlast', 0x168FCC, True), ('tankBlast', 0x169526, False),
        ('carrierBlast', 0x16A5FA, False), ('mirroredBlast', 0x16A62C, False),
    ):
        stream.write(f'    {name}={{\n')
        if attrs:
            emit_rows(stream, explosion_rows(data, address), '      ')
        else:
            record = struct.Struct('>HhhHHHHH')
            while struct.unpack_from('>H', data, address)[0] != 0xffff:
                kind, dh, dl, ground, velocity, _, _, delay = record.unpack_from(data, address)
                emit_rows(stream, [(kind, dh, dl, ground, velocity, delay)], '      ')
                address += record.size
        stream.write('    },\n')
    for name, address in (('tankMuzzles', 0x15D8D2), ('carrierMuzzles', 0x15D9D2)):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from('>32i',data,address)) + ',\n')
    stream.write('    images={\n')
    for name, banks in assets.items():
        stream.write(f'      {name}={{\n')
        for bank, frames in banks.items():
            if name == 'rotors':
                stream.write(f'        [{bank}]={{\n')
                emit_rows(stream, frames, '          ')
                stream.write('        },\n')
            else:
                stream.write(f'        [{bank}]=' + lua_row(frames) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def mid4_images(data, sprite, colors):
    palettes = ((20, colors[0xC58F8]), (25, colors[0xC71F8]), (31, 31))
    image_tables = (
        ('engine', 0x1B81B2, 8, 0xC48), ('coreHatch', 0x1B8192, 8, 0x430),
        ('rightWing', 0x1B8220, 16, 0xC50), ('leftWing', 0x1B82B4, 16, 0xC50),
        ('rightTail', 0x1B8322, 8, 0xC50), ('leftTail', 0x1B8370, 8, 0xC50),
        ('cannon', 0x15DC52, 32, 0x628),
    )
    static_images = (
        ('body', 0x20F350, 0x1030), ('core', 0x2170E8, 0x210), ('pod', 0x21427C, 0xE18),
        ('rightWingBase', 0x2134A8, 0x418), ('leftWingBase', 0x211634, 0x418),
    )
    banks = {}
    for bank, color in palettes:
        images = {name: sprite(address, size, color) for name, address, size in static_images}
        for name, table, count, size in image_tables:
            images[name] = [sprite(pointer(data, table+i*4), size, color) for i in range(count)]
        banks[bank] = images
    return banks


def emit_mid4(stream, data, images):
    health = pointer(data, 0x1B7EB4)
    stream.write(f'  mid4={{health={health},parts={{\n')
    emit_rows(stream, (struct.unpack_from('>H10x5h', data, 0x1B7EC2+i*32) for i in range(11)), '    ')
    # 0x1b8022 是没有判定盒的第十二个预留槽。
    emit_rows(stream, [(0x8000, 0, 0, 0, 0, 0)], '    ')
    stream.write('  },\n')
    for name, address, layout in (
        ('coreOffsets', 0x1B8172, '>8i'), ('podOffsets', 0x1B83F2, '>23h'),
        ('cannonMuzzles', 0x15DCD2, '>32i'), ('cannonFan', 0x1B9A24, '>12B'),
        ('wingFan', 0x1BA2EC, '>22B'), ('openWingFan', 0x1B9BBC, '>20B'),
        ('coreFan', 0x1B9DB0, '>22B'), ('podFan', 0x1B9F9E, '>20B'),
        ('aimedFan', 0x1BA176, '>16B'), ('phaseEffectKinds', 0x1B9364, '>8H'),
        ('phaseOffsets', 0x11B056, '>64i'),
    ):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from(layout, data, address)) + ',\n')
    for name, address in (('rightWingBlast', 0x1B8A8C), ('leftWingBlast', 0x1B8B5A),
                          ('finalBlast', 0x1B8DF4), ('initialBlast', 0x1B8F3A)):
        stream.write(f'    {name}={{\n')
        emit_rows(stream, explosion_rows(data, address), '      ')
        stream.write('    },\n')
    stream.write('    images={\n')
    for bank, sprites in images.items():
        stream.write(f'      [{bank}]={{\n')
        for name, frames in sprites.items():
            value = lua_row(frames) if isinstance(frames, list) else str(frames)
            stream.write(f'        {name}={value},\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage4_gunship_images(data, sprite, colors):
    banks = {}
    for bank, color in ((19, colors[0xC44B8]), (25, colors[0xC71F8]), (31, 31)):
        images = {}
        for name, table, frames, pieces in (
            ('closed', 0x156948, 8, 1), ('opening', 0x1569C8, 8, 7), ('open', 0x156D48, 12, 7),
        ):
            groups = []
            for frame in range(frames):
                part = []
                for piece in range(pieces):
                    address, offset, shift, size = struct.unpack_from('>IiiI', data, table+(frame*pieces+piece)*16)
                    part.append((sprite(address, size, color), offset+shift))
                groups.append(part)
            images[name] = groups
        images['strut'] = sprite(0xFF458, 0x818, color)
        banks[bank] = images
    for bank, color in ((10, colors[0xC4938]), (25, colors[0xC71F8]), (31, 31)):
        rotor = [sprite(pointer(data, 0x164804+i*4), 0xA50, color) for i in range(16)]
        banks.setdefault(bank, {})['rotor'] = rotor
    return banks


def emit_stage4_gunship(stream, data, banks):
    health = pointer(data, 0x155CCE)
    stream.write(f'  stage4Gunship={{health={health},parts={{\n')
    emit_rows(stream, (struct.unpack_from('>H10x5h', data, 0x155C98+i*32) for i in range(4)), '    ')
    stream.write('  },scratch=' + lua_row(struct.unpack_from('>12B', data, 0x155CFA)) + ',\n')
    stream.write('    state=' + lua_row(struct.unpack_from('>36B', data, 0x155C72)) + ',\n')
    for name, address in (('hitBlast', 0x15666E), ('retreatBlast', 0x15686C), ('finalBlast', 0x1566B8)):
        stream.write(f'    {name}={{\n')
        rows = explosion_rows(data, address)
        emit_rows(stream, (next(rows) for _ in range(6)) if name == 'retreatBlast' else rows, '      ')
        stream.write('    },\n')
    stream.write('    images={\n')
    for bank, images in banks.items():
        stream.write(f'      [{bank}]={{\n')
        for name, frames in images.items():
            if name == 'strut':
                stream.write(f'        {name}={frames},\n')
            elif name == 'rotor':
                stream.write(f'        {name}=' + lua_row(frames) + ',\n')
            else:
                stream.write(f'        {name}={{\n')
                for frame in frames:
                    stream.write('          {' + ','.join(lua_row(row) for row in frame) + '},\n')
                stream.write('        },\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def boss4_images(data, sprite, colors):
    palette = {9: colors[0xC4F38], 14: colors[0xC4F78], 17: colors[0xC4FB8], 18: colors[0xC4FF8], 19: colors[0xC5038],
               20: colors[0xC5078], 25: colors[0xC71F8], 26: 26, 30: 30, 31: 31}
    definitions = (
        ('frontBase', (0x1698F8,), 0x1450, (9,25,31)),
        ('frontTop', (0x17246C,), 0x618, (9,25,31)),
        ('leftInset', (0x1724B8,), 0xC10, (9,25,31)),
        ('rightInset', (0x17251C,), 0xC10, (9,25,31)),
        ('frontRotor', (0x198002,16), 0xA18, (9,25,31)),
        ('frontEngine', (0x198062,16), 0xE78, (9,25,31)),
        ('gun', (0x1980A2,32), 0x420, (9,25,31)),
        ('rotorFlash', (0x198042,8), 0xA18, (30,)),
        ('lowerLeft', (0x198184,8), 0x1030, (9,25,31)),
        ('lowerRight', (0x198206,8), 0x1030, (9,25,31)),
        ('upperLeft', (0x19828C,16), 0x1030, (9,25,31)),
        ('upperRight', (0x198332,16), 0x1038, (9,25,31)),
        ('lowerLeftWreck', (0x16A83C,), 0x1028, (9,25,31)),
        ('lowerRightWreck', (0x16B7A0,), 0x1030, (9,25,31)),
        ('upperLeftWreck', (0x170624,), 0x1020, (9,25,31)),
        ('upperRightWreck', (0x172368,), 0x1020, (9,25,31)),
        ('rearBase', (0x174B44,), 0x1460, (14,25,31)),
        ('rearVent', (0x19843C,8), 0xC80, (14,25,31)),
        ('rearRotor', (0x19845C,16), 0x1438, (17,25,31)),
        ('rearCore', (0x174560,), 0xE30, (14,25,31)),
        ('rearLeft', (0x1746B4,), 0xC30, (14,25,31)),
        ('rearRight', (0x1748CC,), 0xC40, (14,25,31)),
        ('rearLeftWreck', (0x1747D8,), 0xC28, (14,25,31)),
        ('rearRightWreck', (0x174A50,), 0xC28, (14,25,31)),
        ('drone', (0x19F24C,8), 0x418, (19,31)),
        ('ringPoint', (0x19E862,4), 0x410, (26,)),
        ('crossingDrone', (0x19D4C0,8), 0x620, (20,31)),
        ('rearSpark', (0x19F082,6), 0x410, (26,)),
        ('rearSparkEnd', (0x19DB84,16), 0x210, (26,)),
        ('returnDrone', (0x19D144,40), 0x418, (18,31)),
    )
    images = {}
    for name, source, size, banks in definitions:
        addresses = [source[0]] if len(source)==1 else [pointer(data,source[0]+i*4) for i in range(source[1])]
        images[name] = {bank: [sprite(address,size,palette[bank]) for address in addresses] for bank in banks}
    images['finalProjectile'] = {26: [sprite(0x28D620+i*0x24,0x410,26) for i in range(4)]}
    cover = [sprite(0x33A050,0x38D0,colors[0xC6D38]),sprite(0x33B714,0x8D0,colors[0xC6D38])]
    return images,cover


def emit_boss4(stream, data, assets):
    images,cover = assets
    stream.write('  boss4={health=' + lua_row(struct.unpack_from('>4I', data, 0x197BE8)) + ',parts={\n')
    emit_rows(stream, (struct.unpack_from('>H10x5h',data,0x197BFE+i*32) for i in range(12)), '    ')
    stream.write('  },\n    cover=' + lua_row(cover) + ',\n')
    for name,address,count,layout in (
        ('randomOffset',0x11AAE0,128,'h'), ('staggeredLeft',0x19B724,4,'i'),
        ('staggeredRight',0x19B734,4,'i'), ('crossingPorts',0x19BC6A,12,'i'),
        ('droneBox',0x19F0F8,1,'H10x5h'), ('droneWaveNoise',0x11A84C,256,'b'),
        ('rearSeedBox',0x19ED5A,1,'H10x5h'),
        ('returnDroneBox',0x19CF40,1,'H10x5h'), ('returnRingBox',0x19D858,1,'H10x5h'),
        ('defeatOffsets',0x19A948,3,'i'),
    ):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from(f'>{count}{layout}',data,address)) + ',\n')
    stream.write('    timeout=' + lua_row(struct.unpack_from('>3H',data,0x197BF8)) + ',\n')
    stream.write('    ringBox=' + lua_row(struct.unpack_from('>H10x5h',data,0x19DC76)) + ',\n')
    stream.write('    crossingDroneBoxes={\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,address) for address in (0x19D28C,0x19D2AC)), '      ')
    stream.write('    },\n')
    stream.write('    rotation={\n')
    emit_rows(stream, struct.iter_unpack('>ii',data[0x1A9394:0x1A9B94]), '      ')
    stream.write('    },\n')
    record = struct.Struct('>HHHiBB')
    for name, address, count in (
        ('separationSmoke',0x19A626,8), ('separationBurst',0x19A9AE,None),
        ('rearBreakBlast',0x19A8CE,None),
        ('lowerLeftBreak',0x199B7A,None), ('lowerRightBreak',0x199BEC,None),
        ('upperLeftBreak',0x199C62,None), ('upperRightBreak',0x199CD8,None),
    ):
        rows = []
        while (count is None or len(rows)<count) and struct.unpack_from('>H',data,address)[0]!=0xffff:
            delay,kind,_,offset,speed,angle = record.unpack_from(data,address)
            rows.append((kind,offset,speed,angle,delay))
            address += record.size
        stream.write(f'    {name}={{\n')
        emit_rows(stream, rows, '      ')
        stream.write('    },\n')
    stream.write('    images={\n')
    for name,banks in images.items():
        stream.write(f'      {name}={{\n')
        for bank,frames in banks.items():
            stream.write(f'        [{bank}]=' + lua_row(frames) + ',\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage5_gunship_images(data, sprite, colors):
    images, rotors = {}, {}
    for bank, color in ((19, colors[0xC45F8]), (25, colors[0xC71F8]), (31, 31)):
        images[bank] = {
            'center': [sprite(pointer(data, 0x16B8FC+i*4), 0x610, color) for i in range(8)],
            'side': [sprite(pointer(data, 0x16B91C+i*4), 0x410, color) for i in range(8)],
            'hatch': [sprite(a, 0x618, color) for a in (0xDCE84, 0xDCED0)],
            'hull': [sprite(0xDCBE4, 0x1030, color)],
            'port': [sprite(0xDCF1C, 0x610, color)],
        }
    for bank, color in ((10, colors[0xC4938]), (25, colors[0xC71F8]), (31, 31)):
        rotors[bank] = [(sprite(image, size, color), (0xD00F880+offset+shift)&0xffffffff)
                        for image, offset, shift, size, _ in struct.iter_unpack('>IIIHH',data[0x1551B6:0x155396])]
    return images,rotors


def emit_stage5_gunship(stream, data, assets):
    images,rotors = assets
    stream.write('  stage5Gunship={state=' + lua_row(struct.unpack_from('>21H',data,0x16B1E4)) + ',boxes={\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,a) for a in (0x16B20E,0x16B22E)), '    ')
    stream.write('    },\n')
    for name,address in (('centerOffsets',0x16B93C), ('rightOffsets',0x16B984), ('leftOffsets',0x16B9CC)):
        stream.write(f'    {name}=' + lua_row(struct.unpack_from('>18i',data,address)) + ',\n')
    stream.write('    blast={\n')
    emit_rows(stream,explosion_rows(data,0x16B856), '      ')
    stream.write('    },\n    images={\n')
    for bank,items in images.items():
        values = (f'{name}=' + (str(ids[0]) if len(ids)==1 else lua_row(ids)) for name,ids in items.items())
        stream.write(f'      [{bank}]={{' + ','.join(values) + '},\n')
    stream.write('    },\n    rotors={\n')
    for bank,rows in rotors.items():
        stream.write(f'      [{bank}]={{\n')
        emit_rows(stream,rows,'        ')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage5_turret_ship_images(data, sprite, colors):
    tables = [pointer(data,0x16AF6C+i*8) for i in range(8)]
    images = {}
    for bank, color in ((20,colors[0xC45B8]), (25,colors[0xC71F8]), (31,31)):
        hull = [[sprite(pointer(data,address+i*4),0xC40,color) for i in range(14)] for address in tables]
        guns = [sprite(pointer(data,0x15DA52+i*4),0x418,color) for i in range(32)]
        images[bank] = hull,guns
    return images


def emit_stage5_turret_ship(stream, data, images):
    stream.write('  stage5TurretShip={box=' + lua_row(struct.unpack_from('>H10x5h',data,0x16ABE8)) + ',\n')
    stream.write('    ports=' + lua_row(struct.unpack_from('>i',data,0x16AF68+8*i)[0] for i in range(8)) + ',\n')
    stream.write('    muzzles=' + lua_row(struct.unpack_from('>32i',data,0x15DAD2)) + ',\n    blast={\n')
    for i in range(2):
        kind,dh,dl,_,velocity,ground,_,delay = struct.unpack_from('>HhhHHHHH',data,0x16AF46+16*i)
        emit_rows(stream,[(kind,dh,dl,ground,velocity,delay)],'      ')
    stream.write('    },\n    images={\n')
    for bank,(hull,guns) in images.items():
        stream.write(f'      [{bank}]={{hull={{\n')
        emit_rows(stream,hull,'        ')
        stream.write('      },guns=' + lua_row(guns) + '},\n')
    stream.write('    },\n  },\n')


def stage5_ark_images(data, sprite, colors):
    images, rotors = {}, {}
    for bank, color in ((12,colors[0xC4738]), (25,colors[0xC71F8]), (31,31)):
        images[bank] = {
            'hull': [sprite(0xE4720,0x1C60,color)],
            'ports': [sprite(pointer(data,0x164844+i*4),0x410,color) for i in range(8)],
            'wing': [sprite(0xE65A4,0x818,color)],
            'guns': [sprite(pointer(data,0x15DF52+i*4),0x838,color) for i in range(32)],
        }
    for bank, color in ((10,colors[0xC4938]), (25,colors[0xC71F8]), (31,31)):
        rotors[bank] = [sprite(pointer(data,0x164804+i*4),0xA50,color) for i in range(16)]
    return images,rotors


def emit_stage5_ark(stream, data, assets):
    images,rotors = assets
    health, = struct.unpack_from('>I',data,0x164142)
    stream.write(f'  stage5Ark={{health={health},boxes={{\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,a) for a in (0x164108,0x164128)), '      ')
    stream.write('    },\n')
    stream.write('    wingOffsets=' + lua_row(struct.unpack_from('>20i',data,0x164864)) + ',\n')
    stream.write('    muzzles=' + lua_row(struct.unpack_from('>32i',data,0x15E0D2)) + ',\n')
    stream.write('    blast={\n')
    emit_rows(stream,explosion_rows(data,0x16468A), '      ')
    stream.write('    },\n    images={\n')
    for bank,items in images.items():
        values = (f'{name}=' + (str(ids[0]) if len(ids)==1 else lua_row(ids)) for name,ids in items.items())
        stream.write(f'      [{bank}]={{' + ','.join(values) + '},\n')
    stream.write('    },\n    rotors={\n')
    for bank,rows in rotors.items():
        stream.write(f'      [{bank}]=' + lua_row(rows) + ',\n')
    stream.write('    },\n  },\n')


def boss5_images(data, sprite, colors):
    banks = {19: colors[0x11F52E],20: colors[0x11F52E],21: colors[0xC59B8],
             25: colors[0xC71F8],31: 31}
    images = {}
    for name,table,count,size,slots in (
        ('wings',0x188AF6,32,0x1678,(20,25,31)),
        ('hull',0x1BA7A0,16,0xA40,(19,25,31)),
        ('hullTurn',0x1BA808,36,0xC40,(19,25,31)),
        ('wingFold',0x1BAA3C,16,0x2078,(20,25,31)),
        ('detached',0x1BAB3C,8,0xE40,(21,25,31)),
        ('retreat',0x1BABC8,16,0xA30,(19,25,31)),
    ):
        images[name] = {bank: [sprite(pointer(data,table+i*4),size,banks[bank]) for i in range(count)]
                        for bank in slots}
    images['hatch'] = {bank: [(sprite(address,size,banks[bank]),offset)
                             for address,offset,size in struct.iter_unpack('>IiH2x',data[0x1BA8BA:0x1BA9DA])]
                       for bank in (19,25,31)}
    images['wreck'] = {25: [sprite(pointer(data,0x16A9AE+i*4),0x210,banks[25]) for i in range(16)]}
    return images


def emit_boss5(stream, data, images):
    stream.write('  boss5={health=' + lua_row(struct.unpack_from('>3I',data,0x1BA54E)) + ',\n')
    stream.write('    clocks=' + lua_row(struct.unpack_from('>2H',data,0x1BA55A)) + ',parts={\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,0x1BA562+32*i) for i in range(12)), '      ')
    stream.write('    },\n    firstPorts={\n')
    emit_rows(stream,struct.iter_unpack('>hi',data[0x1BCDC4:0x1BCDE8]), '      ')
    stream.write('    },\n    arcPorts=' + lua_row(struct.unpack_from('>64i',data,0x15D052)) + ',\n')
    for name,address in (('entryBlast',0x1BB032),('leftBreak',0x1BB7FC),
                         ('rightBreak',0x1BB858),('detachedBlast',0x1BCA24),
                         ('retreatLeft',0x1BBD0E),('retreatRight',0x1BBDC6)):
        stream.write(f'    {name}={{\n')
        emit_rows(stream,explosion_rows(data,address),'      ')
        stream.write('    },\n')
    stream.write('    retreatSmoke={\n')
    rows = struct.iter_unpack('>HHHih',data[0x1BBBAC:0x1BBBF4])
    emit_rows(stream,((delay,kind,offset,velocity) for delay,kind,_,offset,velocity in rows),'      ')
    stream.write('    },\n    hatchSpread={\n')
    emit_rows(stream,struct.iter_unpack('>HH',data[0x1BDA00:0x1BDA98]),'      ')
    stream.write('    },\n')
    stream.write('    images={\n')
    for name,slots in images.items():
        stream.write(f'      {name}={{\n')
        for bank,rows in slots.items():
            value = '{'+','.join(map(lua_row,rows))+'}' if name=='hatch' else lua_row(rows)
            stream.write(f'        [{bank}]=' + value + ',\n')
        stream.write('      },\n')
    stream.write('    },\n  },\n')


def stage6_patrol_images(data, sprite, colors):
    return {bank: (
        [[(sprite(address, size, color), flags != 0)
          for address, flags in struct.iter_unpack('>II', data[start:start + count * 8])]
         for start, count, size in ((0x15777C, 64, 0x828), (0x15797C, 32, 0x820))],
        [(sprite(address, size, color), origin+offset)
         for address, origin, size, offset in struct.iter_unpack('>IiIi',data[0x1581B0:0x1584B0])],
        sprite(0xF474C,0x210,color))
        for bank, color in ((9, colors[0xC48B8]), (13, colors[0xC48B8]), (19, colors[0xC48B8]),
                            (20, colors[0xC48B8]), (31, 31))}


def emit_stage6_patrol(stream, data, images):
    stream.write('  stage6Patrol={box=' + lua_row(struct.unpack_from('>H10x5h',data,0x15732E)) + ',\n')
    stream.write('    palettes={\n')
    emit_rows(stream,struct.iter_unpack('>BB',data[0x1572F8:0x157304]),'      ')
    stream.write('    },\n    muzzle=' + lua_row(struct.unpack_from('>32i',data,0x157A7C)) + ',\n')
    stream.write('    smallOffset=' + lua_row(struct.unpack_from('>64h',data,0x11ADCE)) + ',\n    images={\n')
    for bank, (poses, jumps, shadow) in images.items():
        stream.write(f'      [{bank}]={{\n')
        for frames in poses:
            stream.write('        {' + ','.join(lua_row((image,int(flip))) for image,flip in frames) + '},\n')
        stream.write('        jump={\n')
        emit_rows(stream,jumps,'          ')
        stream.write(f'        }},shadow={shadow},\n      }},\n')
    stream.write('    },\n  },\n')


def boss6_opening_images(data, sprite, colors):
    def frames(table,count,size,bank):
        return [sprite(pointer(data,table+i*4),size,colors.get(bank,bank)) for i in range(count)]

    def pieces(rows,bank):
        return [(sprite(image,size,colors[bank]),left,right) for image,size,left,right in rows]

    def escort_frames(table,bank,shift=0):
        rows=struct.iter_unpack('>IiIi',data[table:table+88*16])
        return [(sprite(image,size,colors[bank]),position+offset+shift) if image else (0,0)
                for image,position,size,offset in rows]

    unfold = []
    for image,position,size,offset in struct.iter_unpack('>IIIi',data[0x1A85A0:0x1A8820]):
        reflected = (position & 0xffff0000) | (-position & 0xffff)
        unfold.append((sprite(image,size,colors[0xC55B8]),position+offset,reflected+offset))
    images = {
        'panel': pieces([(0x1B3F3C,0x1A40,0xE8FFF7C0+0xE600F800,0xE9000840+0xE600F800)],0xC5638),
        'wing': pieces([(0x1B5CD4,0x1C28,0xFEBFFB00+0xE400FB00,0xFEC00500+0xE400FB00)],0xC55B8),
        'upper': pieces([(0x1B3B54,0x1048,0x243FF540+0xF000F700,0x24400AC0+0xF000F700)],0xC55B8),
        'lower': pieces([(0x1B3D98,0x868,0x16BFF040+0xF800F300,0x16C00FC0+0xF800F300)],0xC55B8),
        'outer': pieces([(0x1B5F08,0x430,0x2CBFEA00+0xFC00FA00,0x2CC01600+0xFC00FA00),
                         (0x1B5F80,0x638,0x24BFEA40+0xFA00F900,0x24C015C0+0xFA00F900),
                         (0x1B6060,0x838,0x1EBFEC40+0xF800F900,0x1EC013C0+0xF800F900),
                         (0x1B6178,0x630,0x187FF140+0xFA00FA00,0x18800EC0+0xFA00FA00),
                         (0x1B6230,0x830,0x14BFF340+0xF800FA00,0x14C00CC0+0xF800FA00)],0xC55F8),
        'inner': pieces([(0x1B6328,0x628,0x163FE440+0xFA00FB00,0x16401BC0+0xFA00FB00),
                         (0x1B63C8,0xA30,0x107FE6C0+0xF600FA00,0x10801940+0xF600FA00),
                         (0x1B64F0,0xC28,0xC7FEBC0+0xF400FB00,0xC801440+0xF400FB00),
                         (0x1B6618,0xA18,0x87FF000+0xF600FD00,0x8801000+0xF600FD00),
                         (0x1B66B8,0xA10,0x6FFF4C0+0xF600FE00,0x7000B40+0xF600FE00)],0xC55F8),
        'unfold': unfold,
        'center': [sprite(0x1B5B80,0xC38,colors[0xC55B8])],
        'rotor': frames(0x1A8168,16,0x828,0xC5578),
        'nozzle': frames(0x1A81A8,8,0x410,0xC55B8),
        'escort': frames(0x1ADF7E,8,0x818,0xC52F8),
        'escortBody': escort_frames(0x1ADF9E,0xC52F8),
        'escortAura': escort_frames(0x1AE51E,0xC52B8,0xF2000100),
        'escortCape': escort_frames(0x1AEB9E,0xC5338,0x08FFF900),
    }
    for name,table,size in (('cover0',0x1A7FE4,0xA30),('cover1',0x1A8024,0xA38),('cover2',0x1A8064,0xA38)):
        images[name]=frames(table,16,size,0xC55F8)
    for suffix,bank in (('Warning',colors[0xC71F8]),('Hit',31)):
        for name,image,size in (('wing',0x1B5CD4,0x1C28),('upper',0x1B3B54,0x1048),
                                ('lower',0x1B3D98,0x868),('center',0x1B5B80,0xC38)):
            images[name+suffix]=[sprite(image,size,bank)]
        images['nozzle'+suffix]=frames(0x1A81A8,8,0x410,bank)
    images['ring']=frames(0x1AB4A4,80,0x620,0xC5678)
    images['ringFlash']=[sprite(pointer(data,0x1AB4A4+i*4),0x620,31) for i in range(48)]
    images['wreckWide']=frames(0x1AF24C,32,0x1030,30)
    images['wreckNarrow']=frames(0x1AF2CC,32,0x1028,30)
    for suffix,body,wing in (('',0xC50B8,0xC50F8),('Hit',31,31),('Warning',0xC71F8,0xC71F8)):
        images['finalBody'+suffix]=frames(0x19F7B2,16,0xA30,body)
        images['finalTurn'+suffix]=frames(0x19F8D6,16,0xA30,body)
        images['finalSide'+suffix]=frames(0x19F864,16,0xA30,body)
        images['finalWing'+suffix]=frames(0x19F7F2,16,0xA38,wing)
        images['finalOpen'+suffix]=frames(0x19F948,16,0xA40,body)
        images['finalWheel'+suffix]=frames(0x19F9BA,29,0xA40,body)
        images['finalTwist'+suffix]=frames(0x19FAAE,16,0xE38,body)
        images['finalTwistWing'+suffix]=frames(0x19FAEE,16,0xE38,wing)
    for suffix,body,wing in (('',0xC56B8,0xC56F8),('Hit',31,31),('Warning',0xC71F8,0xC71F8)):
        images['finalSecond'+suffix]=frames(0x1A0734,16,0xA38,body)
        images['finalSecondWing'+suffix]=frames(0x1A06F4,16,0x630,wing)
        images['finalCharge'+suffix]=frames(0x1A0878,16,0xA38,body)
        images['finalBurst'+suffix]=frames(0x1A08E4,28,0xA38,body)
        images['finalFold'+suffix]=frames(0x1A0986,16,0xC38,body)
    images['finalRing']=frames(0x1A76C8,1,0x410,26)
    images['finalEdge']=frames(0x1A70D8,32,0x828,0xC48B8)
    images['finalEdgeHit']=frames(0x1A70D8,32,0x828,31)
    images['finalTailArrows']=[frames(pointer(data,0x174890+4*i),3,0x410,26) for i in range(9)]
    images['finalReassembly']=frames(0x1A794E,16,0x418,28)
    images['finalCoreShards']=frames(0x1A794E,16,0x418,0xC5378)
    images['finalCrossing']=[frames(pointer(data,0x176A3C+4*i),3,0x410,26) for i in range(9)]
    images['finalCoreAura']=frames(0x1A0AA8,32,0x1468,0xC51B8)
    images['finalCoreFlash']=frames(0x1A1FEC,10,0x1CE0,0xC7B78)
    for suffix,bank in (('',0xC5178),('Hit',31),('Warning',0xC71F8)):
        images['finalCore'+suffix]=frames(0x1A0A68,16,0xE38,bank)
        images['finalCoreOpen'+suffix]=[
            (sprite(image,size,colors.get(bank,bank)),position+offset)
            for image,position,size,offset in struct.iter_unpack('>IiIi',data[0x1A0BC4:0x1A0BC4+24*16])
        ]
    images['finalArmorCenter'] = [
        (sprite(image,size,colors[0xC5138]),position)
        for image,position,size,_ in struct.iter_unpack('>IiII',data[0x19FB5C:0x19FB5C+41*16])
    ]
    images['finalArmorWings'] = [
        (sprite(image,size,colors[0xC51F8]),position+offset,position+offset-2*(offset & 0xffff))
        for image,position,size,offset in struct.iter_unpack('>IiIi',data[0x1A0120:0x1A0400])
    ]
    for suffix,body,joint in (('',0xC5138,0xC5238),('Hit',31,31),('Warning',0xC71F8,0xC71F8)):
        images['finalArmorBody'+suffix]=frames(0x1A0100,8,0xA40,body)
        images['finalArmorBreak'+suffix]=frames(0x1A062A,16,0x1048,body)
        images['finalArmorJointWide'+suffix]=frames(0x19FFD8,30,0x620,joint)
        images['finalArmorJoint'+suffix]=frames(0x1A0050,30,0x418,joint)
        images['finalArmorCharge'+suffix]=[
            (sprite(image,size,colors.get(body,body)),position+offset)
            for image,position,size,offset in struct.iter_unpack('>IiIi',data[0x1A0428:0x1A0428+29*16])
        ]
    return images


def emit_boss6_opening(stream,data,images):
    stream.write('  boss6={health=' + lua_row(struct.unpack_from('>3I',data,0x1A7CA8)) + ',\n')
    stream.write('    armor=' + lua_row(struct.unpack_from('>4H',data,0x1A7CB4)) + ',\n')
    stream.write('    attack=' + lua_row(struct.unpack_from('>3H',data,0x1A7CC0+11*32+22)) + ',\n')
    stream.write('    clocks=' + lua_row(struct.unpack_from('>2H',data,0x1A7CBC)) + ',parts={\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,0x1A7CC0+32*i) for i in range(13)),'      ')
    for name, addresses in (('firstPorts',(0x1AC8E8,0x1AC8FC)),('rearPorts',(0x1AC910,0x1AC924))):
        stream.write(f'    }},\n    {name}={{\n')
        for address in addresses:
            stream.write('      '+lua_row(struct.unpack_from('>5i',data,address))+',\n')
    stream.write('    },\n    signs='+lua_bytes(data[0x11A84C:0x11A94C])+',\n    wingBlast={\n')
    for address in (0x1ABC62,0x1ABD92,0x1ABEC2,0x1ABFF2):
        stream.write('      {\n')
        while struct.unpack_from('>H',data,address)[0]!=0xffff:
            delay,kind,_,offset,velocity=struct.unpack_from('>HHHih',data,address)
            stream.write('        '+lua_row((delay,kind,offset,velocity))+',\n')
            address+=12
        stream.write('      },\n')
    stream.write('    },\n    ringModes='+lua_row(struct.unpack_from('>5H',data,0x1AC484))+',\n')
    stream.write('    ringOffsets='+lua_row(struct.unpack_from('>12i',data,0x1AB064))+',\n')
    stream.write('    nodeBox='+lua_row(struct.unpack_from('>H10x5h',data,0x1AB0CC))+',\n')
    stream.write('    nodeZoom='+lua_row(struct.unpack_from('>16I',data,0x1AB464))+',\n')
    stream.write('    escortTargets='+lua_row(struct.unpack_from('>64i',data,0x11AF12))+',\n')
    stream.write('    finalHealth='+lua_row(struct.unpack_from('>9I',data,0x19F43A))+',\n')
    stream.write('    finalSpiralTargets='+lua_row(struct.unpack_from('>4i',data,0x1A2922))+',\n')
    stream.write('    finalArmorPorts='+lua_row(struct.unpack_from('>12i',data,0x1A5DD2))+',\n')
    stream.write('    finalArmorOrder='+lua_row(struct.unpack_from('>12H',data,0x1A2CE0))+',\n')
    stream.write('    finalArmorSweep='+lua_row(struct.unpack_from('>64i',data,0x15CC52))+',\n')
    stream.write('    finalWingSweep='+lua_row(struct.unpack_from('>64i',data,0x15CD52))+',\n')
    stream.write('    finalWingTurns='+lua_bytes(data[0x11AA80:0x11AAC0])+',\n')
    stream.write('    finalArmorFanPorts='+lua_row(struct.unpack_from('>4i',data,0x1A62F8))+',\n')
    stream.write('    finalCoreShards='+lua_row(struct.unpack_from('>16i',data,0x1A7A3C))+',\n')
    stream.write('    finalCoreBlast='+lua_row(struct.unpack_from('>8H',data,0x1A1DD0))+',\n')
    stream.write('    finalArmorBlasts={\n')
    for address in (0x1A4FD6,0x1A5056,0x1A4DA6,0x1A4E3E,0x1A4ED6,0x1A4F56):
        stream.write('      {\n')
        while struct.unpack_from('>H',data,address)[0]!=0xffff:
            delay,kind,_,offset,motion=struct.unpack_from('>HHHiH',data,address)
            stream.write('        '+lua_row((delay,kind,offset,motion))+',\n')
            address+=12
        stream.write('      },\n')
    stream.write('    },\n')
    stream.write('    finalReassemblySpeed={\n')
    emit_rows(stream,struct.iter_unpack('>HH',data[0x1A79DA:0x1A79DA+24*4]),'      ')
    stream.write('    },\n')
    stream.write('    finalEdgeParts={\n')
    for (address,) in struct.iter_unpack('>I',data[0x1A2ADC:0x1A2AEC]):
        count,=struct.unpack_from('>H',data,address)
        stream.write('      {\n')
        emit_rows(stream,(struct.unpack_from('>BbhHH2x',data,address+2+i*10) for i in range(count)),'        ')
        stream.write('      },\n')
    stream.write('    },\n')
    stream.write('    finalParts={\n')
    emit_rows(stream,(struct.unpack_from('>H10x5h',data,0x19F45E+32*i) for i in range(18)),'      ')
    stream.write('    },\n    finalSpeed={\n')
    emit_rows(stream,struct.iter_unpack('>4B',data[0x1A0F4A:0x1A0F8A]),'      ')
    stream.write('    },\n    finalRoamSpeed={\n')
    emit_rows(stream,struct.iter_unpack('>4B',data[0x1A12A0:0x1A12E0]),'      ')
    stream.write('    },\n    finalRingSpeed={\n')
    emit_rows(stream,struct.iter_unpack('>HH',data[0x1A7666:0x1A76C6]),'      ')
    stream.write('    },\n')
    stream.write('    wreckOffsets='+lua_row(struct.unpack_from('>6i',data,0x1ABBF4))+',\n')
    stream.write('    blastCenters='+lua_row(struct.unpack_from('>4i',data,0x1A9062))+',\n')
    for name,address in (('heavySmoke',0x1A8DC2),('lightSmoke',0x1A8EE4),('largeBlast',0x1A9006)):
        stream.write(f'    {name}={{\n')
        while struct.unpack_from('>H',data,address)[0]!=0xffff:
            kind,_,offset,flags,speed,angle,_,_,delay=struct.unpack_from('>HHiHBBHHH',data,address)
            stream.write('      '+lua_row((kind,offset,flags,speed,angle,delay))+',\n')
            address+=18
        stream.write('    },\n')
    stream.write('    rotation={\n')
    emit_rows(stream,struct.iter_unpack('>ii',data[0x1A9394:0x1A9B94]),'      ')
    stream.write('    },\n    images={\n')
    for name,rows in images.items():
        if isinstance(rows[0],int):
            stream.write(f'      {name}='+lua_row(rows)+',\n')
        else:
            stream.write(f'      {name}={{\n')
            emit_rows(stream,rows,'        ')
            stream.write('      },\n')
    stream.write('    },\n  },\n')


def export(data, graphics, output, resources):
    maps, rectangles = map_data(data, graphics, resources)
    (sprite_rects, tank, colored_images, round_images, arrow_bullet, flash, hit_bullet, effects,
     pilot_shots, armored_tracks, twin_tank, twin_tracks, twin_bullets, hovercraft, gunship,
     ageha_loss, mid1, dual_cannon, boss1, boss1_core, stage2_turret, stage2_carriers,
     stage2_forts, mid2, stage2_tail, boss2, boss2_round, stage3_airships, mid3,
     stage3_tail, stage3_guns, stage3_heavy, boss3, stage4_armor, mid4, stage4_gunship,
     boss4, stage5_gunship, stage5_turret_ship, stage5_ark, boss5, stage6_patrol, boss6_opening,
     ageha, pilot_awakened_shots) = sprite_data(data, graphics, resources)
    (output / 'rom_vectors.bin').write_bytes(b''.join(vector_data(data)))
    with (output / 'rom_data.lua').open('w', encoding='utf-8', newline='\n') as stream:
        stream.write('-- Espgaluda V100 ROM 表，由 tools/pgm/export_espgal.py 生成。\nreturn {\n')
        stream.write('  aim=' + lua_bytes(data[0x118C1C:0x118C1C + 129]) + ',\n')
        stream.write('  aim8=' + lua_bytes(data[0x118F3C:0x118F3C + 65]) + ',\n')
        stream.write('  pilotDirections=' + lua_bytes(data[0x1278FC:0x12790C]) + ',\n')
        stream.write('  randomNarrow=' + lua_bytes(data[0x11A19C:0x11A19C + 256]) + ',\n')
        stream.write('  randomHalf=' + lua_bytes(data[0x11A4C8:0x11A4C8 + 128]) + ',\n')
        stream.write('  randomByte=' + lua_bytes(data[0x11A5D4:0x11A5D4 + 256]) + ',\n')
        stream.write('  formationKinds={\n')
        kinds = set()
        for stage in range(1, 7):
            for row in stage_rows(data, stage):
                if row[-1] != 0x14FCC2:
                    continue
                header = row[6] + 4
                if data[header] == 0x89 and data[header + 1] != 0:
                    header += 2
                if data[header + 1] == 2:
                    header += 2
                kinds.add(data[header + 1])
        for kind in sorted(kinds):
            stream.write(f'    [{kind}]=' + lua_row(enemy_callbacks(data, kind)) + ',\n')
        stream.write('  },\n')
        stream.write('  debrisOffsets={\n')
        emit_rows(stream, struct.iter_unpack('>i', data[0x11ADCE:0x11ADCE + 256]), '    ')
        stream.write('  },\n  shotJitter=' + lua_row([struct.unpack_from('>h', data, 0x11AC6A + 4 * n)[0]
                                                       for n in range(64)]) + ',\n')
        stream.write('  fireBounds={\n')
        emit_rows(stream, (struct.unpack_from('>HH', data, 0x119162 + index * 4)
                           + struct.unpack_from('>HH', data, 0x11917A + index * 4) for index in range(6)), '    ')
        stream.write('  },\n  tankMuzzles={\n')
        emit_rows(stream, struct.iter_unpack('>hh', data[0x15966E:0x15966E + 0x80]), '    ')
        stream.write('  },\n  bulletLaunch={\n')
        emit_rows(stream, ((h // 2, l // 2, image, blend) for l, h, image, blend in
                           struct.iter_unpack('>hhIB3x', data[0x173A24:0x173A24 + 32 * 12])), '    ')
        stream.write('  },\n')
        stream.write('  scoutMuzzles={\n')
        emit_rows(stream, struct.iter_unpack('>hh', data[0x15D2D2:0x15D2D2 + 0x80]), '    ')
        stream.write('  },\n  patrolMuzzles={\n')
        emit_rows(stream, struct.iter_unpack('>hh', data[0x15C1C2:0x15C1C2 + 0x40]), '    ')
        stream.write('  },\n  heavyPatrolMuzzles={\n')
        emit_rows(stream, struct.iter_unpack('>hh', data[0x15D4D2:0x15D4D2 + 0x40]), '    ')
        stream.write('  },\n  armoredCarMuzzles={\n')
        emit_rows(stream, (((muzzle + 0x057FFFC0) >> 16, ((muzzle + 0x057FFFC0 + 0x8000) & 0xFFFF) - 0x8000)
                           for (muzzle,) in struct.iter_unpack('>i', data[0x15E0D2:0x15E152])), '    ')
        flags = struct.unpack_from('>H', data, 0x164F8C)[0]
        front, back, right, left, health = struct.unpack_from('>5H', data, 0x164F98)
        stream.write('  },\n  armoredCarBody=' + lua_row((flags, health, front, back, right, left)) + ',\n')
        stream.write('  armoredCarPalettes={\n')
        emit_rows(stream, struct.iter_unpack('>BB', data[0x164F66:0x164F72]), '    ')
        stream.write('  },\n  armoredCarDestruction={\n')
        emit_rows(stream, ((kind, dh, dl, ground, velocity, delay) for kind, _, dh, dl, ground, velocity, _, _, delay
                           in struct.iter_unpack('>HHhhHHHHH', data[0x165284:0x1652BA])), '    ')
        stream.write('  },\n  patrolFireDistance=' + lua_row(struct.unpack_from('>6H', data, 0x15BC60)) + ',\n')
        stream.write('  twinTankParts={\n')
        for address in (0x1649B2, 0x1649D2):
            flags = struct.unpack_from('>H', data, address)[0]
            front, back, right, left, health = struct.unpack_from('>5H', data, address + 12)
            emit_rows(stream, [(flags, health, front, back, right, left)], '    ')
        health = pointer(data, 0x1649E8)
        stream.write(f'  }},\n  twinTankHealth={health},\n  twinTankPalettes={{\n')
        emit_rows(stream, struct.iter_unpack('>BB', data[0x16497C:0x164988]), '    ')
        stream.write('  },\n  twinTankMuzzles=' + lua_row([value for (value,) in
                     struct.iter_unpack('>i', data[0x15E0D2:0x15E152])]) + ',\n')
        stream.write('  twinTankShotOffsets=' + lua_row([value for (value,) in
                     struct.iter_unpack('>i', data[0x15CD52:0x15CE52])]) + ',\n')
        for name, address in (('twinTankTimeout', 0x164E18), ('twinTankDestruction', 0x164E74)):
            stream.write(f'  {name}={{\n')
            emit_rows(stream, explosion_rows(data, address), '    ')
            stream.write('  },\n')
        stream.write('  twinTankImages={\n')
        for bank, images in twin_tank.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  },\n  twinTankTracks={\n')
        for bank, images in twin_tracks.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  },\n  twinTankBulletImages={\n')
        emit_rows(stream, twin_bullets, '    ')
        stream.write('  },\n')
        flags = struct.unpack_from('>H', data, 0x1507BC)[0]
        front, back, right, left, hp = struct.unpack_from('>5H', data, 0x1507C8)
        stream.write('  hovercraftBody=' + lua_row((flags, hp, front, back, right, left, data[0x1507D2])) + ',\n')
        stream.write('  hovercraftRandom=' + lua_row(struct.unpack_from('>128h', data, 0x11AAE0)) + ',\n')
        stream.write('  hovercraftSpeeds={\n')
        emit_rows(stream, struct.iter_unpack('>BBH', data[0x150642:0x150652]), '    ')
        stream.write('  },\n  hovercraftPalettes={\n')
        emit_rows(stream, struct.iter_unpack('>BB', data[0x15078A:0x150796]), '    ')
        stream.write('  },\n  hovercraftImages={\n')
        for bank, images in hovercraft.items():
            stream.write(f'    [{bank}]={{' + ','.join(map(lua_row, images)) + '},\n')
        stream.write('  },\n')
        emit_gunship(stream, data, gunship)
        emit_mid1(stream, data, mid1)
        emit_dual_cannon(stream, data, dual_cannon)
        emit_boss1(stream, data, boss1)
        emit_boss1_core(stream, data, boss1_core)
        emit_stage2_turret(stream, data, stage2_turret)
        emit_stage2_carriers(stream, data, stage2_carriers)
        emit_stage2_forts(stream, data, stage2_forts)
        emit_mid2(stream, data, mid2)
        emit_stage2_tail(stream, data, stage2_tail)
        emit_boss2(stream, data, boss2, boss2_round)
        emit_stage3_airships(stream, data, stage3_airships)
        emit_mid3(stream, data, mid3)
        emit_stage3_tail(stream, data, stage3_tail)
        emit_stage3_guns(stream, data, stage3_guns)
        emit_stage3_heavy(stream, data, stage3_heavy)
        emit_boss3(stream, data, boss3)
        emit_stage4_armor(stream, data, stage4_armor)
        emit_mid4(stream, data, mid4)
        emit_stage4_gunship(stream, data, stage4_gunship)
        emit_boss4(stream, data, boss4)
        emit_stage5_gunship(stream, data, stage5_gunship)
        emit_stage5_turret_ship(stream, data, stage5_turret_ship)
        emit_stage5_ark(stream, data, stage5_ark)
        emit_boss5(stream, data, boss5)
        emit_stage6_patrol(stream, data, stage6_patrol)
        emit_boss6_opening(stream, data, boss6_opening)
        stream.write('  agehaLoss={\n')
        emit_rows(stream, ageha_loss, '    ')
        stream.write('  },\n')
        stream.write('  bulletTemplates={\n')
        emit_rows(stream, bullet_rows(data), '    ')
        stream.write('  },\n  tileRects={\n')
        emit_rows(stream, rectangles, '    ')
        stream.write('  },\n  spriteRects={\n')
        emit_rows(stream, sprite_rects, '    ')
        stream.write('  },\n  tankImages={\n')
        for bank, images in tank.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  },\n')
        stream.write('  armoredCarTracks={\n')
        for bank, images in armored_tracks.items():
            stream.write(f'    [{bank}]=' + lua_row(images) + ',\n')
        stream.write('  },\n')
        for name, kinds in colored_images.items():
            stream.write('  ' + name + '={\n')
            for bank, images in kinds.items():
                stream.write(f'    [{bank}]={{' + ','.join(map(lua_row, images)) + '},\n')
            stream.write('  },\n')
        for name, images in round_images.items():
            stream.write(f'  {name}=' + lua_row(images) + ',\n')
        stream.write('  bulletHitImages=' + lua_row(hit_bullet) + ',\n')
        direction = [struct.unpack_from('>H', data, 0x1735BC + index * 8)[0] // 4 + 1 for index in range(32)]
        stream.write('  arrowDirection=' + lua_row(direction) + ',\n  arrowImages={\n')
        emit_rows(stream, arrow_bullet, '    ')
        stream.write('  },\n  flashImages={\n')
        emit_rows(stream, flash, '    ')
        stream.write('  },\n  effects={\n')
        for kind, frames in effects.items():
            stream.write(f'    [{kind}]={{\n')
            emit_rows(stream, frames, '      ')
            stream.write('    },\n')
        stream.write('  },\n')
        for name,levels in (('pilotShots',pilot_shots),('pilotAwakenedShots',pilot_awakened_shots)):
            stream.write(f'  {name}={{\n')
            for sides in levels:
                stream.write('    {\n')
                for meta, variants in sides:
                    stream.write('      {meta=' + lua_row(meta) + ',variants={\n')
                    for variant in variants:
                        stream.write('        {' + ','.join(map(lua_row, variant)) + '},\n')
                    stream.write('      }},\n')
                stream.write('    },\n')
            stream.write('  },\n')
        emit_ageha(stream,data,ageha)
        stream.write('  stages={\n')
        for index, tiles in enumerate(maps):
            entry = STAGE_TABLE + index * 16
            path_base = pointer(data, entry + 8)
            path_end = pointer(data, entry + 16) if index < 5 else 0xE0E3A
            table = pointer(data, 0x14B0BA + index * 4)
            stream.write(f'    {{pathBase={path_base},paths=table.concat{{\n')
            for cursor in range(path_base, path_end, 40):
                stream.write('      ' + lua_bytes(data[cursor:min(path_end, cursor + 40)]) + ',\n')
            stream.write('    },\n    spawns={\n')
            emit_rows(stream, (row[1:] for row in stage_rows(data, index + 1)), '      ')
            stream.write('    },\n    scroll={\n')
            for layer in range(2):
                stream.write('      {\n')
                emit_rows(stream, scroll_rows(data, pointer(data, table + layer * 4)), '        ')
                stream.write('      },\n')
            stream.write('    },\n    tiles={\n')
            emit_rows(stream, tiles, '      ')
            stream.write('    }},\n')
        stream.write('  },\n}\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path)
    parser.add_argument('rom', type=Path)
    parser.add_argument('--output', type=Path, default=Path('mod/GAME/th45/native'))
    parser.add_argument('--resources', type=Path, default=Path('Resources/th45/native'))
    args = parser.parse_args()
    data = read_program(args.program)
    graphics = Graphics(args.rom, 'espgaluda_v100.u38', 'bce2e7fb9105ed51603d09cbd3a9eeb5b8f47ee2', '048')
    args.output.mkdir(parents=True, exist_ok=True)
    args.resources.mkdir(parents=True, exist_ok=True)
    export(data, graphics, args.output, args.resources)


if __name__ == '__main__':
    main()
