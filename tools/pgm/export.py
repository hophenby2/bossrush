"""从 PGM 街机的 68000 对象池及显存导出 LuaSTG 关卡。"""
import argparse
from dataclasses import dataclass, replace
from math import atan2, hypot, pi
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from ketsui.export import Atlas, Graphics, ROOT, decode_palette, enemy_sprite, save_level, shape, signed, sprites


TILE = 4 + 0x20000
PALETTE = TILE + 0x1000 + 0x1C0
ROW_SIZE = PALETTE + 0x1200 + 6


@dataclass(frozen=True)
class Board:
    code: str
    program: str
    digest: str
    chips: str
    groups: int
    parts: tuple
    bullet: int
    pointer: int
    pilot: int
    first: int
    last: int
    bosses: tuple
    ship: tuple
    fire: tuple
    scenery: tuple


BOARDS = {
    'ket': Board(
        'th43', 'ketsui_v100.u38', 'baa58d1ce47a707f84f65779ac0689894793e9d9', '047',
        0x12744, (0x13964,0x15aa2,42), 0x1719e, 0x0f, 0x0fea2,
        2434, 60500,
        ((0x8080,0x1770d4,0x17bdf8,(15,16,17,18),0x0d00,32,38),
         (0x7080,0x587ec,0x6c168,(19,20,21,22),0x22200,35,48)),
        (), (0x4a9c,1,16,2), ()),
    'ddpdoj': Board(
        'th44', 'ddp3_v101.u36', 'f18d791c034b0a3d85888a92fb5d326ee3deb04f', '044',
        0x13288, (0x144A8, 0x17000, 32), 0x17D30, 0x18, 0x1035A,
        1465, 12500,
        ((0x0D81, 0x11E1FC, 0x128CFF, (16,), 0x3500, 38, 34),
         (0x0E80, 0x6539C, 0x85DFC, (19, 21, 22), 0x7FFF, 37, 40)),
        tuple((offset, 3, 32, 0) for offset in range(0x1200, 0x1841, 0x64)),
        (0x4970, 3, 8, 2),
        ((0x19C000, 0x1B6000), (0x22CBCC, 0x233FFF))),
    'espgal': Board(
        'th45', 'espgaluda_v100.u38', 'bce2e7fb9105ed51603d09cbd3a9eeb5b8f47ee2', '048',
        0x14410, (0x15500, 0x18200, 36), 0x18352, 0x17, 0xEE96,
        2850, 12500,
        ((0x8080, 0x1D0000, 0x1DA000, (19,), 0x3500, 48, 32),
         (0x6080, 0xFF000, 0x113000, (11, 19), 0x7FFF, 43, 30)),
        tuple((offset, 4, 40, 0) for offset in range(0x3F34, 0x48D1, 0xA4)),
        (0x4498C, 2, 16, 2),
        ((0x2F2500, 0x2F4DFF), (0x302000, 0x311AE8))),
}


class Trace:
    def __init__(self, path, first, last):
        with path.open('rb') as stream:
            header = stream.read(12)
        self.ram = struct.unpack_from('>2I', header, 4) if header[:4] == b'PGM2' else None
        offset = 12 if self.ram else 0
        ram_size = 0xa00 + self.ram[1] - self.ram[0] + 1 if self.ram else 0x20000
        size = ROW_SIZE - 0x20000 + ram_size
        count, leftover = divmod(path.stat().st_size - offset, size)
        assert not leftover, path
        self.rows = np.memmap(path, dtype='u1', mode='r', offset=offset, shape=(count, size))
        self.start = struct.unpack_from('>I', self.rows[0])[0]
        end = struct.unpack_from('>I', self.rows[-1])[0]
        assert self.start <= first <= last <= end and count == end - self.start + 1, path
        self.end = end

    def __getitem__(self, frame):
        assert self.start <= frame <= self.end, frame
        row = self.rows[frame - self.start]
        if not self.ram:
            return row
        start, end = self.ram
        out = np.zeros(ROW_SIZE, dtype='u1')
        out[:4+0xa00] = row[:4+0xa00]
        out[4+start-0x800000:5+end-0x800000] = row[4+0xa00:5+0xa00+end-start]
        out[TILE:] = row[5+0xa00+end-start:]
        return out


class JoinedTrace:
    def __init__(self, first, second):
        assert first.start < second.start <= first.end + 1 <= second.end
        self.first, self.second = first, second
        self.start, self.end = first.start, second.end

    def __getitem__(self, frame):
        return (self.first if frame < self.second.start else self.second)[frame]


def capture(exe, roms, directory, game, mode):
    board = BOARDS[game]
    trace = directory / f'{game}-{mode}.bin'
    if trace.exists():
        return trace
    with tempfile.TemporaryDirectory(prefix=f'{game}-', dir=directory) as folder:
        pending = Path(folder) / 'ram.bin'
        env = dict(os.environ, PGM_GAME=game, PGM_MODE=mode, PGM_TRACE=str(pending),
                   PGM_LAST=str(board.last))
        subprocess.run(
            [str(exe), game, '-noreadconfig', '-rompath', str(roms), '-video', 'none',
             '-sound', 'none', '-nothrottle', '-skip_gameinfo', '-autoboot_delay', '0',
             '-autoboot_script', str(Path(__file__).with_name('capture.lua')),
             '-seconds_to_run', '235'],
            cwd=folder, env=env, check=True)
        Trace(pending, board.first, board.last)
        pending.replace(trace)
    return trace


def colors(row):
    return decode_palette(np.frombuffer(row, dtype='>u2', offset=PALETTE, count=0x900))


def groups(row, board):
    low, high, stride = board.parts
    max_parts = 32 if board.code == 'th43' else 24
    for slot in range(board.groups, board.groups + 58 * 80, 80):
        flags, _, count, bank, pointer, _, kind = struct.unpack_from('>7H', row, 4 + slot)
        first = 0x10000 + pointer
        if not flags & 0x8000 or bank != 0x81 or count > max_parts or not low <= first < high:
            continue
        for index in range(count + 1):
            offset=first+index*stride
            if offset+stride>high:
                break
            part = struct.unpack_from('>16H', row, 4+offset)
            if part[0] & 0x8000:
                yield slot, kind, index, part


def boss_layers(available, profile, x, y):
    kind, low, high, banks, *_ = profile
    return [s for s in available if low <= s[2][0] <= high
            and (s[2][3] in banks or s[2][3] == 31)
            and (kind==0x7181 or abs(s[0] - x) < 220 and abs(s[1] - y) < 165)]


def bullets(row, board):
    count = 200 if board.pointer == 0x17 else 210
    pool = memoryview(row)[4 + board.bullet:4 + board.bullet + count * 64]
    for index, record in enumerate(struct.iter_unpack('>32H', pool)):
        if record[0] & 0x8000:
            yield index, record


def continues(before, after):
    return all(abs(signed(before[i]) - signed(after[i])) < 2048 for i in (1, 2))


def born(previous, index, record):
    return index not in previous or not continues(previous[index], record)


def pilot(row, board):
    return tuple(signed(v) for v in struct.unpack_from('>2H', row, 4 + board.pilot + 2))


class KetsuiAim:
    """原版横移采样的弹池，与本轮关卡采样共用发弹对照。"""
    def __init__(self,path):
        from ketsui.export import Trace as LegacyTrace
        self.trace=LegacyTrace(path,12000)
        self.start,self.end=1880,12000

    def __getitem__(self,frame):
        from ketsui.export import REGIONS
        old=self.trace[frame]
        row=np.zeros(ROW_SIZE,dtype='u1')
        cursor=4
        for start,size in REGIONS:
            if 0x800000<=start<0x820000:
                index=4+start-0x800000
                row[index:index+size]=old[cursor:cursor+size]
            cursor+=size
        _,camera,scroll,*_,control=struct.unpack('>8H',old[-16:])
        struct.pack_into('>3H',row,ROW_SIZE-6,camera,scroll,control)
        return row


def aimed(record, alternatives, origin, target):
    x, y, vx, vy = (signed(record[i]) for i in (1, 2, 15, 16))
    if origin == target or hypot(vx, vy) < 16:
        return False
    original_angle = atan2(origin[1] - y, origin[0] - x)
    for other in alternatives:
        if record[17:19] != other[17:19] or shape(record) != shape(other):
            continue
        ox, oy, sx, sy = (signed(other[i]) for i in (1, 2, 15, 16))
        if hypot(ox - x, oy - y) > 640 or abs(hypot(vx, vy) - hypot(sx, sy)) > 18:
            continue
        expected = atan2(target[1] - oy, target[0] - ox) - original_angle
        expected = (expected + pi) % (2 * pi) - pi
        residual = (atan2(sy, sx) - atan2(vy, vx) - expected + pi) % (2 * pi) - pi
        if abs(expected) >= 0.075 and abs(residual) < 0.04:
            return True
    return False


def shot_visual(record, sprites_by_position, palette, art, board):
    x, y, ox, oy = (signed(record[i]) for i in (1,2,3,4))
    key = shape(record)
    offset, width, height, bank = key
    flip = sprites_by_position.get(((x+ox)//64,(y+oy)//64,key))
    visible = offset and 0 < width <= 10 and 0 < height <= 128 and (
        flip is not None or bank == 26 and record[17] == board.pointer)
    can_hit = not record[0] & (0x5180 if board.pointer==0x18 else 0x4000)
    return (art.get((*key,flip or 0),palette) if visible else 0,ox,oy,int(can_hit))


def continue_shot(shot, x, y, visual):
    shot[-2].append((x,y))
    if visual != shot[-1][-1][1:]:
        shot[-1].append((len(shot[-2])-1,*visual))


def export_stage(primary, shift, board, tiles, art, stop=False, route=False, shot_tail=None):
    tracks, shots, backgrounds = [], [], []
    active, active_shots, banks = {}, {}, {}
    old_tiles, old_view = None, None
    previous = dict(bullets(primary[board.first-1],board)) if route and board.first>primary.start else {}
    old_shift = {}
    loop = None
    boss_profiles = {profile[0]: (2 if profile is board.bosses[-1] else 1, profile)
                     for profile in board.bosses}
    for tick, frame in enumerate(range(board.first, board.last + 1)):
        row = primary[frame]
        palette = colors(row)
        available = list(sprites(row))
        sprite_index = {(sx, sy, key): flip for sx, sy, key, flip in available}
        current = {}
        reset_tiles = False
        parts = list(groups(row, board))
        part_by_address = {}
        children = {}
        for slot, kind, index, part in parts:
            children.setdefault(slot, []).append((index, part))
        for slot, kind, index, part in parts:
            phase, profile = boss_profiles.get(kind, (0, None))
            if phase and index:
                continue
            if not phase and not (part[0] & 0x2000 and 0 < part[12] < 0x7FFF and part[7]):
                continue
            x, y = signed(part[1]), signed(part[2])
            layers = (boss_layers(available, profile, x // 64, y // 64) if phase
                      else enemy_sprite(part, available))
            key = slot, kind, index
            track = active.get(key)
            if not layers and track is None and not (phase==2 and stop):
                continue
            if track is None:
                if phase:
                    hp, a, b = profile[4:]
                    a, b = a * 64, b * 64
                else:
                    hp, a, b = part[12], max(map(abs, map(signed, part[10:12]))), max(map(abs, map(signed, part[8:10])))
                track = [len(tracks) + 1, tick, kind, hp, a, b, phase, []]
                tracks.append(track)
                if phase == 2 and loop is None:
                    loop = tick
                    reset_tiles = True
            current[key] = track
            address = 0x810000 + struct.unpack_from('>H', row, 4+slot+8)[0]
            for j, child in children[slot] if phase else [(index, part)]:
                part_by_address[address + j * board.parts[2]] = track[0]
            pose = []
            for sx, sy, (offset, width, height, bank), flip in reversed(layers):
                if bank == 31 and phase:
                    bank = banks.get(offset, profile[3][0])
                elif phase:
                    banks[offset] = bank
                asset = art.get((offset, width, height, bank, flip), palette)
                pose.append((asset, sx - x // 64, sy - y // 64))
            boxes = []
            if phase == 2 or phase == 1 and board.code=='th43':
                for j, part in children[slot]:
                    if not part[0] & 0x2000:
                        continue
                    front, back, right, left = map(signed, part[8:12])
                    if front + back > 0 and right + left > 0:
                        boxes.append((j, signed(part[1]), signed(part[2]), front, back, right, left))
            track[-1].append((x, y, pose, boxes))
        active = current

        camera, scroll, _ = struct.unpack_from('>3H', row, ROW_SIZE - 6)
        raw_tiles = struct.unpack_from('>2048H', row, TILE)
        cells = []
        for i in range(0, len(raw_tiles), 2):
            if old_tiles is None or reset_tiles or raw_tiles[i:i + 2] != old_tiles[i:i + 2]:
                cells.append((i // 2, tiles.get((raw_tiles[i], raw_tiles[i + 1] & 0xFE), palette)))
        # 建筑和前景装饰走精灵表。地图图块仍按背景寄存器滚动。
        scenery = [(art.get((*key, flip), palette), sx, sy)
                   for sx, sy, key, flip in reversed(available)
                   if (any(lo <= key[0] <= hi for lo, hi in board.scenery)
                       or stop and key[3]==30 and key[0]>0x180000)
                   and 0 < key[1] <= 32 and 0 < key[2] <= 320
                   and sx < 448 and sx + key[1]*16 > 0 and sy < 224 and sy + key[2] > 0]
        view = camera, scroll, scenery
        if cells or old_view != view:
            backgrounds.append((tick, camera, scroll, cells, scenery))
        old_tiles, old_view = raw_tiles, view

        alternatives = []
        origin = target = pilot(row, board)
        if shift and shift.start<=frame<=shift.end:
            other = shift[frame]
            shifted = dict(bullets(other, board))
            # 水平移动同时改变镜头寄存器。纵向卷轴和显示模式才用来对齐。
            if other[-4:].tobytes() == row[-4:].tobytes():
                target = pilot(other, board)
                if origin != target:
                    alternatives = [b for slot, b in shifted.items() if born(old_shift, slot, b)]
            old_shift = shifted
        now = dict(bullets(row, board))
        emitters = [(t[0], *t[-1][-1][:2], t[6]) for t in active.values()]
        next_shots = {}
        for slot, b in now.items():
            x, y = signed(b[1]), signed(b[2])
            visual = shot_visual(b,sprite_index,palette,art,board)
            if not born(previous, slot, b):
                shot = active_shots.get(slot)
                if shot:
                    continue_shot(shot,x,y,visual)
                    next_shots[slot] = shot
                continue
            vx, vy = signed(b[15]), signed(b[16])
            if abs(x) > 32500 or abs(y) > 32500:
                continue
            # 大型机炮口离控制点较远。没有部件指针的弹以原帧中的近邻估计来源。
            owner = min(((((x - ex)**2 + (y - ey)**2) / (8192 if phase else 2350)**2, eid)
                         for eid, ex, ey, phase in emitters), default=(2, 0))
            explicit_owner = part_by_address.get(b[21] << 16 | b[22]) if board.pointer == 0x17 else None
            # P1 的原程序检测把弹心与自机盒比较。LuaSTG 自机已提供自身判定盒。
            shot = [tick, explicit_owner or (owner[1] if owner[0] <= 1 else 0), x, y, vx, vy,
                    0, 0, b[18], b[13], b[14]&31, visual[0],
                    aimed(b, alternatives, origin, target), [(x, y)], [(0, *visual)]]
            shots.append(shot)
            next_shots[slot] = shot
        previous, active_shots = now, next_shots
    # 同一发弹不因导出分段被截断。这里只跟踪段尾已经在场的弹，不补发下一段的新弹。
    for frame in range(board.last+1,(shot_tail or board.last)+1):
        if not active_shots:
            break
        row = primary[frame]
        palette = colors(row)
        sprite_index = {(x,y,key):flip for x,y,key,flip in sprites(row)}
        now = dict(bullets(row,board))
        remaining = {}
        for slot,shot in active_shots.items():
            b = now.get(slot)
            if b and not born(previous,slot,b):
                continue_shot(shot,signed(b[1]),signed(b[2]),shot_visual(b,sprite_index,palette,art,board))
                remaining[slot]=shot
        previous,active_shots=now,remaining
    shots = [shot for shot in shots if any(v[1] or v[4] for v in shot[-1])]
    if loop is None and stop:
        loop = 0
    assert loop is not None
    if not stop:
        assert any(track[6] == 2 and track[1] + len(track[-1]) > board.last - board.first for track in tracks)
    print(f'{board.code} 敌机 {len(tracks)}，敌弹 {len(shots)}，瞄准对照 {sum(s[12] for s in shots)}，关底 {loop}', flush=True)
    return (tracks, shots, backgrounds), loop


def join(sections):
    enemies, shots, backgrounds = [], [], []
    entries = []
    cursor = 0
    for (tracks, launches, views), last in sections:
        entries.append((cursor, cursor + last))
        base = len(enemies)
        for entry in tracks:
            entry[0] += base
            entry[1] += cursor
            enemies.append(entry)
        for event in launches:
            event[0] += cursor
            if event[1]:
                event[1] += base
            shots.append(event)
        backgrounds.extend((frame+cursor, *data) for frame, *data in views)
        cursor += last + 1
    return (enemies, shots, backgrounds), entries


def ketsui_campaign(trace, board, tiles, art, shifted=None):
    # 每一段的起点是对象池里首次出现该血量档的帧。清场以关卡标志的位 15 为准。
    stages = [
        (2434, 11501, board.bosses, ((0x15f01,9441),)),
        (12345, 29485, (
            (0x7481,0x18e000,0x1a5fff,(19,20,21,22),0x22200,45,38),
            (0x9081,0xb8000,0xd9fff,(19,20,21,22),0x38e00,50,43),
        ), ((0x30000,23331),(0x20000,25709),(0x10000,27611))),
        (29986, 50350, (
            (0xa080,0x1a6000,0x1affff,(22,),0x7000,46,50),
            (0x7680,0xd8000,0xebfff,(15,16,17,18),0x3b500,52,46),
        ), ((0x30000,42106),(0x20000,44426),(0x10000,47906))),
        (51103, 78385, (
            (0x7781,0x1ae000,0x1b7fff,(10,15,19),0x32600,48,40),
            (0x7980,0x108000,0x113fff,(15,16,17,21),0x7df00,52,46),
        ), ((0x70000,66705),(0x60000,68733),(0x50000,70965),(0x40000,72497),
            (0x30000,74134),(0x20000,75516),(0x10000,77009))),
        (79017, None, (
            (0x6381,0x1b6000,0x1bbfff,(11,12),0x3b500,48,43),
            (0x6480,0x114000,0x14afff,(15,17,19,25),0x75d00,52,46),
        ), ()),
    ]
    # 第五面结束后机器回到演示状态。用原标志找出最后的清场区间。
    first, _, profiles, _ = stages[-1]
    defeat = next(f for f in range(119400,119470)
                  if struct.unpack_from('>H',trace[f],4+0x124a6)[0]&0x8000)
    phases = []
    slot = next(slot for slot,kind,index,_ in groups(trace[101784],board) if kind==0x6480 and index==0)
    previous = 7
    for frame in range(101784, defeat):
        row = trace[frame]
        hp = struct.unpack_from('>i',row,4+slot+0x16)[0]
        if hp > 0 and hp>>16 < previous:
            previous = hp>>16
            phases.append(((previous+1)<<16,frame))
    end = next(f for f in range(119920,119965)
               if struct.unpack_from('>H',trace[f],4+0x12440)[0]==0)
    stages[-1]=(first,defeat,profiles,phases)

    sections, timings, routes = [], {}, []
    cursor=0
    for index,(first,defeat,profiles,phases) in enumerate(stages,1):
        after=stages[index][0] if index<len(stages) else end
        start=cursor
        points=[first,*(frame for _,frame in phases),defeat,after]
        route_phases=[]
        for phase,(lo,hi) in enumerate(zip(points,points[1:])):
            spec=replace(board,first=lo,last=hi-1,bosses=profiles)
            data,loop=export_stage(trace,shifted if lo==first==board.first else None,spec,tiles,art,
                                   stop=True,route=phase>0,shot_tail=defeat-1 if lo<defeat else None)
            last=cursor+hi-lo-1
            sections.append((data,hi-lo-1))
            if phase==0:
                assert loop is not None, (index,lo,hi)
                suffix=str(index) if index>1 else ''
                timings.update({f'last{suffix}':last,f'loop{suffix}':cursor+loop})
                if index>1:
                    timings[f'stage{index}']=start
            elif lo==defeat:
                kind,_,_,_,hp,*_=profiles[-1]
                routes.append((kind,hp,0,0,0,0,cursor,last,last+1 if index<len(stages) else 0,
                               0,0,0,0,0,1,*route_phases))
            else:
                route_phases.extend((phases[phase-1][0],cursor,last))
            cursor=last+1
    data, _ = join(sections)
    timings['wide']=1
    return data,timings,routes


def campaign(game, primary, shift, damage, tiles, art, right_damage=None, third=None, bosses3=None,
             fourth=None, bosses4=None, fifth=None, bosses5=None, clear=None):
    board = BOARDS[game]
    # 每个区间均由原程序走到对应状态后采样，LuaSTG 根据当前受击状态选择区间。
    if game == 'ddpdoj':
        definitions = [(primary, shift, board.first, board.last, board.bosses),
                       (damage, None, 8351, 9199, board.bosses),
                       (damage, None, 9201, 10075, board.bosses),
                       (damage, None, 10076, 22000, ((0x3080, 0x94000, 0xa4000, (13,16,18,19,23), 0x2bdc0, 45, 45),))]
        route_args = (0x0e80,0x16c00,0x9000,0x9000,0x3080,0x2bdc0)
    else:
        definitions = [(primary, shift, board.first, board.last, board.bosses),
                       (damage, None, 8701, 9549, board.bosses),
                       (damage, None, 9551, 10268, board.bosses),
                       (damage, None, 10269, 22400, ((0x9080, 0x1e9000, 0x1f1000, (7,19), 0x16800, 45, 35),
                                                   (0x6a80, 0x130000, 0x13afff, (13,15,17), 0x49bc0, 47, 38)))]
        route_args = (0x6080,0x32600,0x15200,0x1d400,0x6a80,0x49bc0)
    sections, loops = [], []
    combat = {0,3}
    if third:
        if game=='ddpdoj':
            definitions[3]=(damage,None,10076,21099,definitions[3][4])
            definitions.extend([
                (third,None,21101,21769,definitions[3][4]),
                (third,None,21770,third.end,bosses3),
            ])
        else:
            definitions[3]=(damage,None,10269,20399,definitions[3][4])
            definitions.extend([
                (third,None,20401,21799,definitions[3][4]),
                (third,None,21801,22553,definitions[3][4]),
                (third,None,22554,third.end,bosses3),
            ])
        combat.add(len(definitions)-1)
    third_index = len(definitions)-1
    if fourth:
        trace, shifted, first, _, profiles = definitions[third_index]
        definitions[third_index]=(trace,shifted,first,35199,profiles)
        change_index=len(definitions)
        if game=='ddpdoj':
            definitions.extend([(fourth,None,35201,36499,bosses3),
                                (fourth,None,36501,37193,bosses3),
                                (fourth,None,37194,fourth.end,bosses4)])
        else:
            definitions.extend([(fourth,None,35201,36499,bosses3),
                                (fourth,None,36501,37499,bosses3),
                                (fourth,None,37501,38245,bosses3),
                                (fourth,None,38246,fourth.end,bosses4)])
        combat.add(len(definitions)-1)
    fourth_index=len(definitions)-1
    final_sections = None
    if fifth:
        trace, shifted, first, _, profiles = definitions[fourth_index]
        definitions[fourth_index]=(trace,shifted,first,49749,profiles)
        stage5_begin=51548 if game=='ddpdoj' else 64954
        defeat_start=50851 if game=='ddpdoj' else 64151
        definitions.extend([(fifth,None,49751,50299,bosses4),
                            (fifth,None,50301,50849 if game=='ddpdoj' else 64149,bosses4),
                            (fifth,None,defeat_start,stage5_begin-1,bosses4),
                            (fifth,None,stage5_begin,fifth.end,bosses5)])
        fifth_index=len(definitions)-1
        combat.add(fifth_index)
        if clear:
            fifth=JoinedTrace(fifth,clear)
            # 大往生的主血线由 0x1a5036 比较。觉圣精灵的前段另有计数，先扣掉 0x41000。
            phase,threshold,end=(78301,0x2a000,80443) if game=='ddpdoj' else (76697,0x2a400,80808)
            definitions[fifth_index]=(fifth,None,stage5_begin,phase-1,bosses5)
            definitions.extend([(fifth,None,phase,80100,bosses5),
                                (fifth,None,80101,end-1,bosses5)])
            final_sections=(threshold,fifth_index+1,fifth_index+2)
    for index, (trace, shifted, first, last, profiles) in enumerate(definitions):
        spec = replace(board, first=first, last=last, bosses=profiles, scenery=board.scenery + (
            ((0x237000,0x24efff),) if index==3 and game=='ddpdoj' else ()))
        data, loop = export_stage(trace, shifted, spec, tiles, art,
                                  stop=index not in combat, route=index not in combat,
                                  shot_tail=80100 if final_sections and index==fifth_index else None)
        sections.append((data, last-first))
        loops.append(loop)
    right_index = len(sections)
    if right_damage:
        right = replace(board,first=8351,last=9199)
        right_data, _ = export_stage(right_damage,None,right,tiles,art,stop=True,route=True)
        sections.append((right_data,right.last-right.first))
    data, entries = join(sections)
    (start0,end0),(start1,end1),(start2,end2),(stage2,end3) = entries[:4]
    kind,hp,part1,part2,next_kind,next_hp = route_args
    # 类型、总血量、部件或阶段计数器、时间轴区间及循环入口。
    right_start, right_end = entries[right_index] if right_damage else (start1,end1)
    routes = [(kind,hp,part1,part2,start1,end1,start2,end2,stage2,right_start,right_end),
              (next_kind,next_hp,0,0,0,0,0,0,0)]
    timing = dict(last=end0,loop=start0+loops[0],stage2=stage2,last2=end3,loop2=stage2+loops[3])
    if entries[-1][1]>=65536 or max(map(len,data))>=65536:
        timing['wide']=1
    if third:
        start3_stage,end3_stage = entries[third_index]
        timing.update(stage3=start3_stage,last3=end3_stage,loop3=start3_stage+loops[third_index])
        if game=='ddpdoj':
            defeat, defeat_end = entries[4]
            routes[1]=(next_kind,next_hp,0,0,0,0,defeat,defeat_end,start3_stage)
        else:
            change, change_end = entries[4]
            defeat, defeat_end = entries[5]
            routes[1]=(next_kind,next_hp,next_hp-0x19300,0,change,change_end,defeat,defeat_end,start3_stage)
        boss3=bosses3[-1]
        routes.append((boss3[0],boss3[4],0,0,0,0,0,0,0))
        if fourth:
            fourth_start, fourth_end = entries[fourth_index]
            timing.update(stage4=fourth_start,last4=fourth_end,loop4=fourth_start+loops[fourth_index])
            change, change_end = entries[change_index]
            defeat, defeat_end = entries[fourth_index-1]
            if game=='ddpdoj':
                routes[-1]=(boss3[0],boss3[4],boss3[4]-0x11800,0,change,change_end,
                            defeat,defeat_end,fourth_start,0,0,0,0,0,1)
            else:
                later, later_end=entries[change_index+1]
                routes[-1]=(boss3[0],boss3[4],boss3[4]-0x33cc0,0,change,change_end,
                            defeat,defeat_end,fourth_start,0,0,later,later_end,0x168c0,0)
            boss4=bosses4[-1]
            routes.append((boss4[0],boss4[4],0,0,0,0,0,0,0))
            if fifth:
                stage5,end5=entries[fifth_index]
                timing.update(stage5=stage5,last5=end5,loop5=stage5+loops[fifth_index])
                change, change_end=entries[fourth_index+1]
                later, later_end=entries[fourth_index+2]
                defeat, defeat_end=entries[fourth_index+3]
                threshold1,threshold2 = (0x23000,0xc400) if game=='ddpdoj' else (0x30c00,0x10400)
                routes[-1]=(boss4[0],boss4[4],boss4[4]-threshold1,0,change,change_end,
                            defeat,defeat_end,stage5,0,0,later,later_end,threshold2,int(game=='ddpdoj'))
                boss5=bosses5[-1]
                if final_sections:
                    hp,change_index,defeat_index=final_sections
                    change,change_end=entries[change_index]
                    defeat,defeat_end=entries[defeat_index]
                    routes.append((boss5[0],boss5[4],0,0,0,0,defeat,defeat_end,0,
                                   0,0,0,0,0,1,hp,change,change_end))
                else:
                    routes.append((boss5[0],boss5[4],0,0,0,0,0,0,0))
    return data, timing, routes


def preview(graphics, row, path):
    raw = struct.unpack_from('>2048H', row, TILE)
    camera, scroll, _ = struct.unpack_from('>3H', row, ROW_SIZE - 6)
    palette = colors(row)
    out = Image.new('RGB', (256, 256))
    for y in range(9):
        for x in range(9):
            row_id = (camera // 32 + x) % 16
            col_id = (scroll // 32 + 10 - y) % 64
            offset = 2 * (row_id * 64 + col_id)
            tile = graphics.tile(raw[offset:offset + 2], palette)
            out.paste(tile, (32*x - camera % 32, 32*y + scroll % 32 - 32))
    out.resize((512, 512), Image.Resampling.LANCZOS).save(path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('game', choices=BOARDS)
    parser.add_argument('--roms', type=Path, required=True)
    parser.add_argument('--mame', type=Path)
    parser.add_argument('--traces', type=Path, required=True)
    parser.add_argument('--primary', type=Path)
    parser.add_argument('--shift', type=Path)
    parser.add_argument('--damage', type=Path)
    parser.add_argument('--right-damage', type=Path)
    parser.add_argument('--third', type=Path)
    parser.add_argument('--third-tail', type=Path)
    parser.add_argument('--fourth', type=Path)
    parser.add_argument('--fifth', type=Path)
    parser.add_argument('--fifth-tail', type=Path)
    parser.add_argument('--clear', type=Path)
    parser.add_argument('--ket-code-trace', type=Path)
    parser.add_argument('--ket-tail', type=Path)
    parser.add_argument('--ket-final', type=Path)
    args = parser.parse_args()
    if (bool(args.third) != bool(args.third_tail) or (args.third or args.right_damage) and not args.damage
            or args.fourth and not args.third or args.fifth and not args.fourth
            or bool(args.fifth)!=bool(args.fifth_tail) or args.clear and not args.fifth):
        parser.error('后续采样需按顺序提供，第三面和第五面分别需要两个连续区间')
    args.traces.mkdir(parents=True, exist_ok=True)
    board = BOARDS[args.game]
    if args.game=='ket' and not (args.primary and args.ket_code_trace and args.ket_tail and args.ket_final):
        parser.error('绊地狱需要 --primary、--ket-tail、--ket-final 和原提取器生成的 --ket-code-trace')
    if (args.ket_tail or args.ket_final) and args.game!='ket':
        parser.error('--ket-tail 和 --ket-final 仅适用于 ket')
    if not args.primary and not args.mame:
        parser.error('需要 --primary 或 --mame')
    primary = args.primary or capture(args.mame.resolve(), args.roms.resolve(), args.traces.resolve(), args.game, 'primary')
    shift = args.shift or (args.mame and capture(args.mame.resolve(), args.roms.resolve(), args.traces.resolve(), args.game, 'shift'))
    primary = Trace(primary, board.first - 1, board.last)
    if args.ket_tail:
        primary=JoinedTrace(primary,Trace(args.ket_tail,60499,94000))
        primary=JoinedTrace(primary,Trace(args.ket_final,93999,119964))
    shift = (KetsuiAim(shift) if args.game=='ket' else Trace(shift, board.first - 1, board.last)) if shift else None
    graphics = Graphics(args.roms / f'{args.game}.zip', board.program, board.digest, board.chips)
    tiles, art = Atlas('tiles', graphics.tile), Atlas('sprites', graphics.sprite)
    velocity=[]
    if args.game=='ket':
        data,timing,routes=ketsui_campaign(primary,board,tiles,art,shift)
    elif args.damage:
        damage = Trace(args.damage, 8351 if args.game == 'ddpdoj' else 8701,
                       22000 if args.game == 'ddpdoj' else 22400)
        if args.right_damage and args.game!='ddpdoj':
            parser.error('--right-damage 仅适用于 ddpdoj')
        right = Trace(args.right_damage,8351,9199) if args.right_damage else None
        third, bosses3 = None, None
        if args.third:
            third = JoinedTrace(Trace(args.third,20000,29398),Trace(args.third_tail,29399,35500))
            if args.game=='ddpdoj':
                bosses3=((0xa080,0xa3000,0xb0fff,(16,17,18),0x40c00,55,50),)
            else:
                bosses3=((0xa080,0x1f0000,0x210000,(7,14,19),0x13600,42,38),
                         (0x6d80,0x13b000,0x15cfff,(15,16,17),0x5acc0,50,55))
        fourth, bosses4 = None, None
        if args.fourth:
            fourth=Trace(args.fourth,35201,49900 if args.game=='ddpdoj' else 50500)
            if args.game=='ddpdoj':
                bosses4=((0x4080,0xcb000,0xe7fff,(19,21),0x46000,54,55),)
            else:
                bosses4=((0xb080,0x20f000,0x217fff,(20,21),0x26c00,48,46),
                         (0x7181,0x16b000,0x177fff,(9,14,17),0x64c00,55,50))
        fifth, bosses5 = None, None
        if args.fifth:
            fifth=JoinedTrace(Trace(args.fifth,49749,67498),Trace(args.fifth_tail,67499,81000))
            if args.game=='ddpdoj':
                bosses5=((0xb080,0xfd000,0x116fff,(16,17,18,22),0x69000,64,56),)
            else:
                bosses5=((0xc080,0x108000,0x112fff,(20,),0x6b400,54,54),)
        clear=Trace(args.clear,78300,80808) if args.clear else None
        data, timing, routes = campaign(args.game,primary,shift,damage,tiles,art,right,third,bosses3,
                                        fourth,bosses4,fifth,bosses5,clear)
    else:
        data, loop = export_stage(primary, shift, board, tiles, art)
        timing, routes = dict(last=board.last-board.first, loop=loop), None
    palette = colors(primary[board.first + 450])
    if args.game=='ket':
        with args.ket_code_trace.open('rb') as file:
            code=file.read(0x200000)
        ship_table=struct.unpack_from('>I',code,0xbc6d2)[0]
        ship=[(art.get((struct.unpack_from('>I',code,ship_table+i*4)[0],3,32,0,0),palette),)
              for i in range(-8,9)]
        ship.append((art.get((*board.fire,0),palette),art.get((0x49cb4,1,8,24,0),palette)))
        for index in (0x13,0x10):
            pointer=struct.unpack_from('>I',code,0xd20+index*4)[0]
            velocity.append(tuple(v for angle in (0,8,16) for v in struct.unpack_from('>hh',code,pointer+angle*16)))
    else:
        ship = [(art.get((*key, 0), palette),) for key in (*board.ship, board.fire)]
    x, y = pilot(primary[board.first + 450], board)
    timing.update(shotLifetime=1, scenery=1, bossBoxes=1, shotVisuals=1,
                  aimX=y/64-112, aimY=x/64-224)
    code, resources = ROOT / 'mod/GAME' / board.code, ROOT / 'Resources' / board.code
    code.mkdir(parents=True, exist_ok=True)
    resources.mkdir(parents=True, exist_ok=True)
    save_level(data, code, tiles, art, velocity, ship, timing, 'tools/pgm/export.py', routes)
    tiles.save(resources)
    art.save(resources)
    preview(graphics, primary[board.first + 600], resources / 'preview.png')


if __name__ == '__main__':
    main()
