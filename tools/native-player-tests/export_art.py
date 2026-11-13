#!/usr/bin/env python3
"""Export player sprites from the two XNA Content directories and the ASL Assets directory."""
import argparse
from io import BytesIO
from pathlib import Path
import re

from Crypto.Cipher import DES3
from PIL import Image

ROOT = Path(__file__).resolve().parents[2] / 'Resources/native_players'
KEYS = ('CA90D8D3BCD6F4B4AEC2BC652816BDB7', '4D3C3F50123A4577898C758F7E9E1187')
CELL = 128


def read(path, key):
    data = DES3.new(bytes.fromhex(KEYS[key]), DES3.MODE_ECB).decrypt(path.read_bytes())
    size = data[-1]
    assert 1 <= size <= 8 and data.endswith(bytes([size]) * size), path
    return data[:-size]


def texture(content, name):
    return Image.open(BytesIO(read(content / 'Graphics/List' / (name + '.xna'), 0))).convert('RGBA')


def body(name, rows, scale, target=None):
    atlas = Image.new('RGBA', (CELL * 8, CELL * 3))
    for j, row in enumerate(rows):
        for i in range(8):
            frame, ox, oy = row[i % len(row)]
            size = (max(1, round(frame.width * scale)), max(1, round(frame.height * scale)))
            img = frame.resize(size, Image.Resampling.LANCZOS)
            atlas.alpha_composite(img, (i * CELL + 64 - round(ox * scale),
                                        j * CELL + 64 - round(oy * scale)))
    atlas.save(ROOT / (name + '.png'), optimize=True)


def clip(image, x, y, w, h):
    return image.crop((x, y, x + w, y + h))


def part2(content):
    src = texture(content, 'actor')
    ox, oy, w, h, *_ = map(int, read(content / 'Data/10.xna', 1).decode().strip().split(','))
    for j, name in enumerate(('reimu', 'marisa', 'sanae', 'youmu')):
        rows = [[(clip(src, i * w, j * h, w, h), ox, oy) for i in indices]
                for indices in (range(7), range(7, 11), range(11, 15))]
        body('37_' + name, rows, 1)
    texture(content, 'selfbarrage').save(ROOT / '37_shots.png', optimize=True)


def part3(content):
    rows = iter(read(content / 'Data/10.xna', 1).decode('utf-8-sig').splitlines())
    textures = {}
    for name in ('reimu', 'marisa', 'sanae', 'mokou'):
        count, w, h, ox, oy, scale, *_ = map(float, next(rows).split(','))
        w, h, ox, oy = map(int, (w, h, ox, oy))
        next(rows)
        next(rows)
        parts = {}
        for _ in range(int(count)):
            desc, tex, x, y, interval, delay, dx, dy, angle, change = next(rows).split(',')
            part, _, states = desc.rstrip(']').partition('[')
            if tex not in textures:
                textures[tex] = texture(content, 'actor' + tex)
            vals = (textures[tex], int(x), int(y), max(1, int(interval)),
                    float(dx), float(dy), float(angle))
            parts.setdefault(part, {}).update(dict.fromkeys(states.split('|'), vals))
        frames = []
        for state in ('Idle1', 'Left1', 'Right1'):
            row = []
            for t in range(8):
                canvas = Image.new('RGBA', (300, 300))
                for states in parts.values():
                    if state not in states:
                        continue
                    img, x, y, interval, dx, dy, angle = states[state]
                    # Character.InitSprite plays a horizontal row for each part.
                    n = (t * 6 // interval) % 7
                    layer = clip(img, x + w * n, y, w, h)
                    if angle:
                        layer = layer.rotate(-angle, center=(ox, oy), resample=Image.Resampling.BICUBIC)
                    canvas.alpha_composite(layer, (150 - ox + round(dx), 150 - oy + round(dy)))
                row.append((canvas, 150, 150))
            frames.append(row)
        body('39_' + name, frames, scale * 2 / 3)
    shots = Image.new('RGBA', (512, 256))
    for idx, sx, sy, w, h, dx in [(1,43,0,47,144,0),(5,307,0,53,161,48),
                                   (3,256,72,256,177,102),(4,300,781,68,157,358)]:
        shots.alpha_composite(clip(texture(content, f'selfbarrage{idx}'), sx, sy, w, h), (dx, 0))
    shots.save(ROOT / '39_shots.png', optimize=True)


def unity_sprites(png):
    img = Image.open(png).convert('RGBA')
    meta = png.with_suffix('.png.meta').read_text()
    sprites = {}
    for block in re.split(r'^    - serializedVersion: ', meta, flags=re.M)[1:]:
        rect = re.search(r'        x: ([\d.-]+)\n        y: ([\d.-]+)\n        width: ([\d.]+)\n        height: ([\d.]+)', block)
        pivot = re.search(r'pivot: \{x: ([\d.-]+), y: ([\d.-]+)\}', block)
        internal = re.search(r'internalID: (-?\d+)', block)
        if rect and pivot and internal:
            x, y, w, h = map(lambda v: round(float(v)), rect.groups())
            ox, oy = map(float, pivot.groups())
            sprites[internal[1]] = (clip(img, x, img.height - y - h, w, h), ox * w, (1 - oy) * h)
    guid = re.search(r'^guid: (\w+)', meta, re.M)[1]
    return guid, sprites


def unity_frames(clip_file, png):
    guid, sprites = unity_sprites(png)
    curve = clip_file.read_text().split('attribute: m_Sprite')[0]
    return [sprites[sid] for sid in re.findall(r'value: \{fileID: (-?\d+), guid: '+guid, curve)]


def asl(assets):
    src = assets / 'Resources/xuelianhua/prefab'
    specs = {
        'reimu': ('lingmeng/lingmeng.png', 'lingmeng', 'basic_lingmeng', 'lingmeng_left_basic', 'lingmeng_right_basic'),
        'yukari': ('lingmeng/zi/zi.png', 'lingmeng/zi', 'zi_basic', 'zi_basicleft', 'zi_basicright'),
        'marisa': ('molisha/Marisa.png', 'molisha/move', 'molisha_basic', 'molisha_basic_left', 'molisha_basic_right'),
        'byakuren': ('bailian/shengbailian.png', 'bailian', 'basic', 'left', 'right'),
        'miko': ('bailian/shenzi/shenzi.png', 'bailian/shenzi', 'shenzi_basic', 'shenzi_left', 'shenzi_right'),
    }
    for name, (png, folder, *clips) in specs.items():
        rows = [unity_frames(src / folder / (anim + '.anim'), src / png) for anim in clips]
        assert all(rows), name
        body('38_' + name, rows, 48 / 100)
    shots = Image.new('RGBA', (1024, 128))
    for i, (png, sid) in enumerate([
        ('lingmeng/lingmeng_item.png', '21300010'),
        ('lingmeng/zi/zi_item.png', '21300004'),
        ('molisha/MarisaA.png', '21300054'),
        ('bailian/shengbailian.png', '21300048'),
        ('bailian/shenzi/shenzizhupao.png', '21300000'),
    ]):
        _, sprites = unity_sprites(src / png)
        if sid in sprites:
            frame, ox, oy = sprites[sid]
        else:
            frame = Image.open(src / png).convert('RGBA')
            ox, oy = frame.width / 2, frame.height / 2
        scale = 48 / 100
        img = frame.resize((max(1, round(frame.width * scale)), max(1, round(frame.height * scale))),
                           Image.Resampling.LANCZOS)
        shots.alpha_composite(img, (i * CELL + 64 - round(ox * scale), 64 - round(oy * scale)))
    shots.save(ROOT / '38_shots.png', optimize=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('part2', type=Path)
    parser.add_argument('asl', type=Path)
    parser.add_argument('part3', type=Path)
    args = parser.parse_args()
    ROOT.mkdir(exist_ok=True)
    part2(args.part2)
    asl(args.asl)
    part3(args.part3)
