"""从指定的 ket ROM 和 ShmupMAME 5.4 实测轨迹导出第一面的 LuaSTG 数据。"""
import argparse
from collections import Counter
import hashlib
import os
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
from zipfile import ZipFile

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[2]
START = 2434
END = 12000
SECOND_START = 10400
SECOND_END = 12000
REGIONS = (
    (0x800000, 0xA00), (0x80FEA0, 0x72), (0x812440, 0x110),
    (0x812744, 0x335E), (0x81719E, 0x348A), (0x900000, 0x1000),
    (0x907000, 0x1C0), (0xA00000, 0x1200),
)
RECORD_SIZE = 4 + sum(size for _, size in REGIONS) + 16
ROM_SHA1 = 'baa58d1ce47a707f84f65779ac0689894793e9d9'
PROGRAM_SIZE = 0x200000


def signed(value, bits=16):
    sign = 1 << (bits - 1)
    return (value ^ sign) - sign


def words(row, address, count):
    offset = 4
    for start, size in REGIONS:
        if start <= address and address + count * 2 <= start + size:
            return struct.unpack_from(f'>{count}H', row, offset + address - start)
        offset += size
    raise ValueError(hex(address))


class Trace:
    def __init__(self, path, last):
        assert path.stat().st_size >= PROGRAM_SIZE + (last - 1879) * RECORD_SIZE, path
        self.rows = np.memmap(path, dtype='u1', mode='r', offset=PROGRAM_SIZE,
                              shape=(last - 1879, RECORD_SIZE))
        with path.open('rb') as file:
            self.code = file.read(PROGRAM_SIZE)
        assert self.code[:8] == bytes.fromhex('00820000000a693a'), path
        assert struct.unpack_from('>I', self.rows[0])[0] == 1880, path
        assert struct.unpack_from('>I', self.rows[-1])[0] == last, path

    def __getitem__(self, frame):
        return self.rows[frame - 1880]


def capture(exe, rom, directory, mode):
    trace = directory / f'{mode}.bin'
    if trace.exists():
        return trace
    env = dict(os.environ, KET_MODE=mode)
    with tempfile.TemporaryDirectory(prefix='ket-mame-', dir=directory) as run:
        rom_dir = Path(run) / 'roms'
        rom_dir.mkdir()
        shutil.copyfile(rom, rom_dir / 'ket.zip')
        env['KET_TRACE'] = str(Path(run) / 'capture.bin')
        subprocess.run(
            [str(exe), 'ket', '-noreadconfig', '-rompath', str(rom_dir),
             '-video', 'none', '-sound', 'none', '-nothrottle', '-skip_gameinfo',
             '-autoboot_delay', '0', '-autoboot_script', str(Path(__file__).with_name('capture.lua')),
             '-seconds_to_run', '260'],
            env=env, cwd=run, check=True,
        )
        Trace(Path(env['KET_TRACE']), END)
        Path(env['KET_TRACE']).replace(trace)
    return trace


def sprites(row):
    for x, y, attr, low, size in struct.iter_unpack('>5H', memoryview(row)[4:4 + 0xA00]):
        if not size & 0x7FFF:
            break
        yield (signed(x & 0x7FF, 11), signed(y & 0x3FF, 10),
               ((attr & 0x7F) << 16 | low, size >> 9 & 63, size & 511, attr >> 8 & 31),
               attr >> 13 & 3)


def enemy_parts(row):
    pool = words(row, 0x812744, 0x335E // 2)
    for first, count in ((0x812744, 10), (0x812A64, 48)):
        for slot in range(first, first + count * 80, 80):
            off = (slot - 0x812744) // 2
            active, _, parts, high, low, _, kind = pool[off:off + 7]
            if not active & 0x8000 or high != 0x81 or not 0x3964 <= low < 0x5AA2 or parts > 24:
                continue
            for index in range(parts + 1):
                address = 0x810000 + low + index * 42
                off = (address - 0x812744) // 2
                e = pool[off:off + 21]
                if len(e) == 21 and e[0] & 0x8000:
                    yield slot, kind, index, e


def bullet_slots(row):
    pool = words(row, 0x81719E, 210 * 32)
    for slot in range(210):
        b = pool[slot * 32:(slot + 1) * 32]
        if b[0] & 0x8000:
            yield slot, b


def shape(b):
    return ((b[5] << 16 | b[6]) & 0x3FFFFF, b[7] >> 9, b[7] & 511, b[14] & 31)


class Graphics:
    def __init__(self, path, program='ketsui_v100.u38', digest=ROM_SHA1, chips='047'):
        with ZipFile(path) as rom:
            assert hashlib.sha1(rom.read(program)).hexdigest() == digest, path

            def read(name):
                return rom.read(name if name in rom.namelist() else 'cave_' + name)

            self.tiles = bytearray(0xA00000)
            self.tiles[:0x200000] = read('pgm_t01s.rom')
            self.tiles[0x180000:0x980000] = read(f't{chips}01w064.u19')
            self.mask = np.frombuffer(read(f'b{chips}01w064.u1'), dtype='<u2')
            self.color = np.frombuffer(read(f'a{chips}01w064.u7') + read(f'a{chips}02w064.u8'), dtype='<u2')

    def tile(self, key, palette):
        code, attr = key
        # IGS023 把 16 位编号传给 tile_data::set，由后者按图块总数取模。
        code %= len(self.tiles) // 640
        raw = np.frombuffer(self.tiles, dtype='u1', count=640, offset=code * 640)
        bits = np.unpackbits(raw, bitorder='little').reshape(32, 32, 5)
        pixels = bits @ (1 << np.arange(5))
        if attr & 0x40:
            pixels = np.fliplr(pixels)
        if attr & 0x80:
            pixels = np.flipud(pixels)
        colors = palette[0x400 + (attr >> 1 & 31) * 32 + pixels]
        return Image.fromarray(np.rot90(colors))

    def sprite(self, key, palette, grow_x=0):
        offset, width, height, bank, flip = key
        start = (int(self.mask[offset + 1]) << 16 | int(self.mask[offset])) >> 2
        bits = np.unpackbits(self.mask[offset + 2:offset + 2 + width * height].view('u1'),
                             bitorder='little').reshape(height, width * 16) == 0
        seq = np.arange(bits.sum(), dtype=np.int32)
        pen = (self.color[(start + seq // 3) & (len(self.color) - 1)] >> (seq % 3 * 5)) & 31
        pixels = np.zeros((height, width * 16, 4), dtype='u1')
        pixels[bits, :3] = palette[bank * 32 + pen]
        pixels[bits, 3] = 255
        if grow_x:
            copies = [1 + ((grow_x >> (x & 31)) & 1) for x in range(width * 16)]
            pixels = np.repeat(pixels, copies, axis=1)
        if flip & 1:
            pixels = np.fliplr(pixels)
        if flip & 2:
            pixels = np.flipud(pixels)
        return Image.fromarray(np.rot90(pixels))


def palette(row):
    return decode_palette(words(row, 0xA00000, 0x900))


def decode_palette(words):
    values = np.asarray(words, dtype=np.uint16)
    colors = np.stack([(values >> shift) & 31 for shift in (10, 5, 0)], axis=1)
    return ((colors << 3) | (colors >> 2)).astype('u1')


class Atlas:
    def __init__(self, name, decode):
        self.name = name
        self.decode = decode
        self.ids = {}
        self.rects = []
        self.pages = []
        self.x = self.y = self.height = 0

    def get(self, key, colors):
        if key not in self.ids:
            image = self.decode(key, colors)
            w, h = image.size
            if self.x + w + 1 > 2048:
                self.x, self.y, self.height = 0, self.y + self.height + 1, 0
            if not self.pages or self.y + h + 1 > 2048:
                self.pages.append(Image.new(image.mode, (2048, 2048)))
                self.x = self.y = self.height = 0
            self.pages[-1].paste(image, (self.x, self.y))
            self.rects.append((len(self.pages), self.x, self.y, w, h))
            self.ids[key] = len(self.rects)
            self.x += w + 1
            self.height = max(self.height, h)
        return self.ids[key]

    def save(self, directory):
        for i, page in enumerate(self.pages, 1):
            right = max(x + w for j, x, _, w, _ in self.rects if i == j)
            bottom = max(y + h for j, _, y, _, h in self.rects if i == j)
            page.crop((0, 0, right, bottom)).save(directory / f'{self.name}{i}.png', optimize=True)


def enemy_sprite(e, available):
    key = shape(e)
    if key[0] == 0 or not 0 < key[1] <= 25 or not 0 < key[2] <= 320:
        return []
    px, py = (signed(e[1]) + signed(e[3])) // 64, (signed(e[2]) + signed(e[4])) // 64
    candidates = [(abs(sx - px) + abs(sy - py), sx, sy, k, flip)
                  for sx, sy, k, flip in available if k[:3] == key[:3]
                  and abs(sx - px) <= 2 and abs(sy - py) <= 2]
    if candidates:
        _, px, py, key, flip = min(candidates)
    else:
        flip = 0
    return [(px, py, key, flip)]


def boss_sprite(kind, x, y, available):
    if kind == 0x8080:
        return [s for s in available if 0x1770D4 <= s[2][0] <= 0x17BDF8
                and abs(s[0] - x) < 180 and abs(s[1] - y) < 105]
    return [s for s in available if 0x587EC <= s[2][0] <= 0x6C168
            and abs(s[0] - x) < 180 and abs(s[1] - y) < 160]


def compare_shots(shifted):
    result = {}
    previous = {}
    for frame in range(2700, END + 1):
        current = dict(bullet_slots(shifted[frame]))
        result[frame] = [b for i, b in current.items() if i not in previous]
        previous = current
    return result


def capture_level(primary, shifted, follow, tiles, art):
    aim_samples = compare_shots(shifted)
    aim_counts = Counter()
    tracks, active, shots, backgrounds = [], {}, [], []
    last_tiles = ()
    previous = {}
    shot_tracks = {}
    previous_scroll = None
    stable_colors = palette(primary[9000])
    boss_banks = {}
    for tick, (trace, frame) in enumerate(
        [(primary, f) for f in range(START, END + 1)] +
        [(follow, f) for f in range(SECOND_START, SECOND_END + 1)]
    ):
        row = trace[frame]
        colors = palette(row)
        available = list(sprites(row))
        if tick == END - START + 1:
            active, previous, shot_tracks = {}, dict(bullet_slots(trace[frame-1])), {}
        _, camera, scroll, *_ = struct.unpack('>8H', row[-16:])
        raw_tiles = words(row, 0x900000, 2048)
        if not last_tiles or tick == END - START + 1 or trace is primary and frame == 8944:
            last_tiles = (-1,) * len(raw_tiles)
        changes = []
        for index in range(0, len(raw_tiles), 2):
            key = (raw_tiles[index], raw_tiles[index + 1] & 0xFE)
            if raw_tiles[index:index + 2] != last_tiles[index:index + 2]:
                changes.append((index // 2, tiles.get(key, colors)))
        if changes or previous_scroll != (camera, scroll):
            backgrounds.append((tick, camera, scroll, changes))
        previous_scroll = (camera, scroll)
        last_tiles = raw_tiles

        current = {}
        for slot, kind, index, e in enemy_parts(row):
            is_mid, is_boss = kind == 0x8080 and index == 0, kind == 0x7080 and index == 0
            if kind in (0x8080, 0x7080) and not (is_mid or is_boss):
                continue
            # 子弹、控制器、不可击破的部件各走原来的池，避免把它们当普通敌机。
            if not (is_mid or is_boss or 0 < e[12] < 0x7FFF and e[7] and e[0] & 0x2000):
                continue
            x, y = signed(e[1]), signed(e[2])
            components = (boss_sprite(kind, x // 64, y // 64, available)
                          if is_mid or is_boss else enemy_sprite(e, available))
            if not components:
                continue
            is_boss_stage = 2 if is_boss else 1 if is_mid else 0
            key = (slot, kind, index)
            track = active.get(key)
            if track is None:
                hp = 0x4600 if is_boss else 0xD00 if is_mid else e[12]
                if trace is follow and is_boss:
                    hp = 0x3200
                # 原作长方形判定：旋转后，硬件 Y 尺寸变为水平。
                hit_x = 35 * 64 if is_boss else 32 * 64 if is_mid else max(e[10], e[11])
                hit_y = 48 * 64 if is_boss else 38 * 64 if is_mid else max(e[8], e[9])
                track = [len(tracks) + 1, tick, kind, hp, hit_x, hit_y, is_boss_stage, []]
                tracks.append(track)
            current[key] = track
            layers = []
            for sx, sy, k, flip in reversed(components):
                colors_for_sprite = colors
                if is_mid or is_boss:
                    # ROM 用 31 号调色板闪白。调试采样中的受击色不写入普通机体图。
                    offset, width, height, bank = k
                    if bank != 31:
                        boss_banks[offset] = bank
                    else:
                        bank = boss_banks.get(offset, 15 if is_mid else
                            19 if offset == 0x587EC else 22 if 0x602FC <= offset <= 0x60848 else 21)
                        k = (offset, width, height, bank)
                    if is_boss:
                        colors_for_sprite = stable_colors
                layers.append((art.get((*k, flip), colors_for_sprite), sx - x // 64, sy - y // 64))
            track[-1].append((x, y, layers))
        active = current

        current_bullets = dict(bullet_slots(row))
        emitters = [(t[0], t[-1][-1][0], t[-1][-1][1], t[6]) for t in active.values()]
        for slot, b in current_bullets.items():
            if slot in previous:
                shot = shot_tracks.get(slot)
                if shot is not None:
                    shot[-1].append((signed(b[1]), signed(b[2])))
                continue
            key = shape(b)
            if not key[0] or key[1] == 0 or key[2] == 0 or b[18] == 0x6B40:
                continue
            x, y = signed(b[1]), signed(b[2])
            vx, vy = signed(b[15]), signed(b[16])
            if not (vx or vy):
                continue
            def distance(obj):
                return (obj[1] - x)**2 + (obj[2] - y)**2

            nearby = min(emitters, default=(0, x + 32767, y + 32767, 0), key=distance)
            owner, ox, oy, boss = nearby
            # 中型机和关底的两侧炮口都可以在本体坐标以外发弹。
            if b[18] in (0x8406, 0x84F6, 0x85E8):
                for candidate in emitters:
                    if candidate[3] and distance(candidate) <= 8192**2:
                        owner, ox, oy, boss = candidate
                        break
            if distance((owner, ox, oy, boss)) > (8192 if boss else 2304)**2:
                owner = 0
            aim = False
            if trace is primary and frame in aim_samples:
                for other in aim_samples[frame]:
                    if (other[18] == b[18] and other[29] >> 8 == b[29] >> 8 and
                        abs(signed(other[1]) - x) <= 240 and
                        abs(signed(other[2]) - y) <= 300 and
                        abs(signed(other[16]) - vy) >= 18):
                        aim = True
                        aim_counts[(b[18], b[14])] += 1
                        break
            shot = [tick, owner, x, y, vx, vy, b[10], b[11], b[18], b[13], b[14] & 31,
                    art.get((*key, 0), colors), aim, [(x, y)]]
            shots.append(shot)
            shot_tracks[slot] = shot
        for slot in previous.keys() - current_bullets.keys():
            shot_tracks.pop(slot, None)
        previous = current_bullets
    print('瞄准对照', sum(aim_counts.values()), '次，敌机', len(tracks), '组，敌弹', len(shots), '次')
    return tracks, shots, backgrounds


def save_level(data, output, tiles, art, velocity, initial_art, timing=None,
               generator='tools/ketsui/export.py', boss_routes=None, stage_number=None):
    tracks, shots, backgrounds = data
    # 大数组用大端16位字段保存，加载时逐段读取。
    def pack(file, fmt, *values):
        file.write(struct.pack('>' + fmt, *values))

    filename = f'stage{stage_number}.bin' if stage_number else 'stage1.bin'
    with (output / filename).open('wb') as f:
        wide = timing and timing.get('wide')
        f.write(b'PGM3' if wide else b'KET1')
        counter = 'I' if wide else 'H'
        pack(f, counter*3, len(tracks), len(shots), len(backgrounds))
        for _, start, kind, hp, ax, ay, boss, poses, *extra in tracks:
            pack(f, counter+'6H', start, kind, min(hp, 65535), ax, ay, boss, len(poses))
            for x, y, layers, *pose_extra in poses:
                pack(f, 'hhB', x, y, len(layers))
                for image, sx, sy in layers:
                    pack(f, 'Hhh', image, sx, sy)
                if timing and timing.get('bossBoxes'):
                    boxes, = pose_extra
                    pack(f, 'B', len(boxes))
                    for box in boxes:
                        pack(f, 'B6h', *box)
        for tick, owner, x, y, vx, vy, ax, ay, proc, speed, bank, image, aimed, points, *extra in shots:
            # 直线弹复用原速度。变速及转向弹逐次保存速度变化，初始速度以第一步实测为准。
            steps = [(i, x2 - x1, y2 - y1) for i, ((x1, y1), (x2, y2)) in
                     enumerate(zip(points, points[1:]), 1)
                     if abs(x2 - x1) < 2048 and abs(y2 - y1) < 2048]
            if steps:
                _, vx, vy = steps[0]
            changes = []
            dx, dy = vx, vy
            tolerance = 0 if timing and timing.get('shotVisuals') else 1
            for age, sx, sy in steps:
                if abs(sx - dx) > tolerance or abs(sy - dy) > tolerance:
                    changes.append((age, sx, sy))
                    dx, dy = sx, sy
            pack(f, counter+'H4h7H', tick, owner, x, y, vx, vy, ax, ay, proc, speed, bank, image, int(aimed))
            pack(f, 'H', len(changes))
            for change in changes:
                pack(f, 'Hhh', *change)
            if timing and timing.get('shotLifetime'):
                pack(f, 'H', len(points))
            if timing and timing.get('shotVisuals'):
                visuals, = extra
                pack(f, 'H', len(visuals))
                for age, image, ox, oy, contact in visuals:
                    pack(f, 'HHhhB', age, image, ox, oy, contact)
        for tick, camera, scroll, changes, *extra in backgrounds:
            pack(f, counter+'3H', tick, camera, scroll, len(changes))
            for change in changes:
                pack(f, '2H', *change)
            if timing and timing.get('scenery'):
                scenery, = extra
                pack(f, 'H', len(scenery))
                for image, x, y in scenery:
                    pack(f, 'Hhh', image, x, y)

    if stage_number:
        return

    def rows(values):
        return '\n'.join('    {' + ','.join(str(x) for x in row) + '},' for row in values)

    if timing is None:
        timing = dict(last=END-START, second=END-START+1,
                      finish=END-START+1+SECOND_END-SECOND_START)
    manifest = (
        f'-- 由 {generator} 生成。\nreturn {{\n'
        + ''.join(f'  {name}={value},\n' for name, value in timing.items())
        + ('  routes={\n' + rows(boss_routes) + '\n  },\n' if boss_routes else '') +
        '  tiles={\n' + rows(tiles.rects) + '\n  },\n'
        '  sprites={\n' + rows(art.rects) + '\n  },\n'
        '  player={\n' + rows(initial_art) + '\n  },\n'
        '  velocity={\n' + rows(velocity) + '\n  },\n}\n'
    )
    (output / 'assets.lua').write_text(manifest, encoding='utf-8', newline='\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mame', type=Path)
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--traces', type=Path, required=True)
    parser.add_argument('--traces-only', action='store_true', help='只采集一面原程序和横移对照')
    args = parser.parse_args()
    args.traces.mkdir(parents=True, exist_ok=True)
    modes = ('stable', 'shift') if args.traces_only else ('stable', 'shift', 'short')
    for name in modes:
        if not (args.traces / f'{name}.bin').exists():
            if not args.mame:
                parser.error('缺少采样文件时需要 --mame')
            capture(args.mame.resolve(), args.rom.resolve(), args.traces.resolve(), name)
    if args.traces_only:
        return
    source = Trace(args.traces / 'stable.bin', END)
    shift = Trace(args.traces / 'shift.bin', END)
    second = Trace(args.traces / 'short.bin', END)
    graphics = Graphics(args.rom)
    tiles, art = Atlas('tiles', graphics.tile), Atlas('sprites', graphics.sprite)
    content = capture_level(source, shift, second, tiles, art)
    colors = palette(source[2800])
    frames = []
    ship_table = struct.unpack_from('>I', source.code, 0xBC6D2)[0]
    for index in range(-8, 9):
        # B5D98 的 A 型倾斜帧表，左右按 0x44(a6) 的方向索引。
        offset = struct.unpack_from('>I', source.code, ship_table + index * 4)[0]
        frames.append((art.get((offset, 3, 32, 0, 0), colors),))
    frames.append((art.get((0x4A9C, 1, 16, 2, 0), colors),
                   art.get((0x49CB4, 1, 8, 24, 0), colors)))
    speed = []
    for index in (0x13, 0x10):
        pointer = struct.unpack_from('>I', source.code, 0xD20 + index * 4)[0]
        speed.append(tuple(v for a in (0, 8, 16) for v in
                           struct.unpack_from('>hh', source.code, pointer + a * 16)))
    data_dir, resource_dir = ROOT / 'mod/GAME/th43', ROOT / 'Resources/th43'
    save_level(content, data_dir, tiles, art, speed, frames)
    tiles.save(resource_dir)
    art.save(resource_dir)
    # 预览使用同一张图块表，坐标与 PGM 的可视区一致。
    row = source[3050]
    tile_map = words(row, 0x900000, 2048)
    _, camera, scroll, *_ = struct.unpack('>8H', row[-16:])
    preview = Image.new('RGB', (512, 2048))
    for index in range(1024):
        y, x = divmod(index, 64)
        tile = graphics.tile(tile_map[index * 2:index * 2 + 2], palette(row))
        preview.paste(tile, (y * 32, (63 - x) * 32))
    size = 224
    top = 2048 - scroll - 336
    preview = preview.crop((camera, top, camera + size, top + size))
    preview.resize((512, 512), Image.Resampling.LANCZOS).save(resource_dir / 'preview.png')


if __name__ == '__main__':
    main()
