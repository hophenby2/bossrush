"""从 Espgaluda V100 的 ROM 导出关卡指令、图块与定点速度。"""

import argparse
from pathlib import Path
import struct
import sys

from inspect_espgal import STAGE_TABLE, bullet_rows, read_program, stage_rows

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
    atlas = Atlas('native_sprites', lambda key, palette: graphics.sprite(key, palette))
    palette = [0] * 0x400
    for bank, address in ((2, 0xC3EF8), (10, 0xC5A78), (14, 0x11F4EE), (15, 0xC62B8), (16, 0xC41B8),
                          (18, 0xC5A38), (20, 0xC5CF8), (21, 0xC5FF8), (25, 0xC61F8), (26, 0xC6678),
                          (30, 0xC66F8), (31, 0xC71B8)):
        palette[bank * 32:(bank + 1) * 32] = struct.unpack_from('>32H', data, address)
    colors = decode_palette(palette)

    def sprite(address, size, bank):
        return atlas.get((address & 0x3FFFFF, size >> 9, size & 0x1FF, bank, 0), colors)

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
    atlas.save(resources)
    colored_images = {'patrolImages': patrol, 'scoutImages': scout, 'heavyPatrolImages': heavy,
                      'armoredCarImages': armored_car}
    round_images = {'roundImages': round_bullet, 'heavyRoundImages': heavy_bullet, 'heavyPatrolSmoke': heavy_smoke}
    return atlas.rects, tank, colored_images, round_images, arrow_bullet, flash, hit_bullet, effects, pilot_shots, armored_tracks


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


def pilot_shot_data(data, sprite):
    # 0x122d10 在通常形态中按火力档查炮口。0x1235a0 分别读右炮和镜像左炮。
    levels = []
    for level in range(5):
        address = pointer(data, 0x12884E + level * 4)
        count = struct.unpack_from('>H', data, address)[0]
        sides = []
        for flags, table, damage, speed, attr, _ in struct.iter_unpack('>HIHBBH', data[address + 2:address + 2 + count * 12]):
            variants = []
            for index in range(9):
                variant = pointer(data, table + index * 4)
                h,l,dh,dl,images,size,front,back,right,left,flight,transform = struct.unpack_from('>hhhhIHHHHHIH', data, variant)
                move = pointer(data, 0x128E84 + transform)
                fd_h,fd_l,fs,shift_h,shift_l = struct.unpack_from('>5h', data, move)
                palette = 2
                spawn = [sprite(pointer(data, images + frame * 4), size, palette) for frame in range(3)]
                moving = [sprite(pointer(data, flight + frame * 4), fs, palette) for frame in range(3)]
                hit = pointer(data, 0x1290FA + transform)
                hit_h,hit_l,hit_size,hit_images,hit_period,hit_offset = struct.unpack_from('>hhHIHH', data, hit)
                impact = [sprite(pointer(data, hit_images + frame * 4), hit_size, palette)
                          for frame in range(hit_offset // 4)]
                variants.append(((h,l,dh,dl,front,back,right,left,fd_h,fd_l,shift_h,shift_l), spawn, moving,
                                 (hit_h, hit_l, hit_period >> 8, hit_period & 255), impact))
            sides.append(((flags, damage, speed, attr), variants))
        levels.append(sides)
    return levels


def export(data, graphics, output, resources):
    maps, rectangles = map_data(data, graphics, resources)
    (sprite_rects, tank, colored_images, round_images, arrow_bullet, flash, hit_bullet, effects,
     pilot_shots, armored_tracks) = sprite_data(data, graphics, resources)
    (output / 'rom_vectors.bin').write_bytes(b''.join(vector_data(data)))
    with (output / 'rom_data.lua').open('w', encoding='utf-8', newline='\n') as stream:
        stream.write('-- Espgaluda V100 ROM 表，由 tools/pgm/export_espgal.py 生成。\nreturn {\n')
        stream.write('  aim=' + lua_bytes(data[0x118C1C:0x118C1C + 129]) + ',\n')
        stream.write('  pilotDirections=' + lua_bytes(data[0x1278FC:0x12790C]) + ',\n')
        stream.write('  randomNarrow=' + lua_bytes(data[0x11A19C:0x11A19C + 256]) + ',\n')
        stream.write('  randomHalf=' + lua_bytes(data[0x11A4C8:0x11A4C8 + 128]) + ',\n')
        stream.write('  randomByte=' + lua_bytes(data[0x11A5D4:0x11A5D4 + 256]) + ',\n')
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
        stream.write('  },\n  pilotShots={\n')
        for sides in pilot_shots:
            stream.write('    {\n')
            for meta, variants in sides:
                stream.write('      {meta=' + lua_row(meta) + ',variants={\n')
                for variant in variants:
                    stream.write('        {' + ','.join(map(lua_row, variant)) + '},\n')
                stream.write('      }},\n')
            stream.write('    },\n')
        stream.write('  },\n  stages={\n')
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
