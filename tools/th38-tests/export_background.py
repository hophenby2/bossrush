#!/usr/bin/env python3
"""从雪莲华 Unity 场景导出摄像机、背景精灵和循环位移。"""
import argparse
import json
import re
import struct
from collections import defaultdict
from functools import lru_cache
from pathlib import Path

import yaml
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / 'Resources/th38/media'
YAML_LOADER = getattr(yaml, 'CSafeLoader', yaml.SafeLoader)


def quote_arrays(body):
    return re.sub(r'(?m)^(  (?:time_change|time_change_long|set_time|set_speed|start_time|time_long): )([0-9A-Fa-f]{8,})$',
                  r'\1"\2"', body)


def unity_documents(path, kinds):
    source = path.read_text(encoding='utf-8-sig')
    pattern = r'^--- !u!(\d+) &(-?\d+)(?: stripped)?\n(.*?)(?=^---|\Z)'
    return {int(i): (int(kind), next(iter(yaml.load(quote_arrays(body), Loader=YAML_LOADER).values())))
            for kind, i, body in re.findall(pattern, source, re.M | re.S)
            if int(kind) in kinds}


def vector(value):
    return [value[key] for key in 'xyz']


def transform(rotation, scale):
    x, y, z = vector(rotation)
    w = rotation['w']
    return [[value * scale[j] for j, value in enumerate(row)] for row in (
        (1 - 2*(y*y + z*z), 2*(x*y - z*w), 2*(x*z + y*w)),
        (2*(x*y + z*w), 1 - 2*(x*x + z*z), 2*(y*z - x*w)),
        (2*(x*z - y*w), 2*(y*z + x*w), 1 - 2*(x*x + y*y)),
    )]


def multiply(matrix, point):
    return [sum(a * b for a, b in zip(row, point)) for row in matrix]


def references(value):
    return [ref['fileID'] for ref in value]


def integers(value, count):
    if not count:
        return []
    # Unity 的十六进制数组只有数字时也可能被 YAML 当成十进制。
    raw = str(value).zfill(8 * count)
    return struct.unpack(f'<{count}i', bytes.fromhex(raw))


def events(script, value, start='time_change', length='time_change_long'):
    changes = script[value]
    times = integers(script[start], len(changes))
    durations = integers(script[length], len(changes))
    return [[t, d, *vector(v)] for t, d, v in zip(times, durations, changes)]


def lua(value):
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return f'{value:.7g}'
    return '{' + ','.join(lua(x) for x in value) + '}'


def export(source):
    assets = {}
    refs = (source / 'Scripts', source / 'Resources/xuelianhua/image/background')
    for meta in (p for folder in refs for p in folder.rglob('*.meta')):
        with meta.open(encoding='utf-8-sig', errors='replace') as f:
            for line in f:
                if line.startswith('guid: '):
                    assets[line[6:].strip()] = meta.with_suffix('')
                    break
    @lru_cache(None)
    def sprite_info(guid, file_id):
        path = assets.get(guid)
        if not path or '/image/background/' not in path.as_posix():
            return
        if '_cut' in path.as_posix():
            return
        settings = yaml.load(Path(str(path) + '.meta').read_text(encoding='utf-8-sig'), Loader=YAML_LOADER)['TextureImporter']
        pixels = float(settings['spritePixelsToUnits'])
        sheets = settings.get('spriteSheet', {}).get('sprites', [])
        name = path.parent.name + '_' + path.stem
        with Image.open(path) as image:
            width, height = image.size
            if sheets:
                # 同一贴图的分片由 fileID 关联，有些旧版 Unity 用顺序编号。
                index = (file_id - 21300000) // 2
                region = next((s for s in sheets if s.get('internalID') == file_id),
                              sheets[index] if 0 <= index < len(sheets) else None)
                if not region:
                    raise ValueError((path, file_id))
                rect = region['rect']
                x, y, width, height = (int(rect[k]) for k in ('x', 'y', 'width', 'height'))
                name += '_' + str(file_id)
                image = image.crop((x, image.height-y-height, x+width, image.height-y))
            image.thumbnail((896, 896), Image.Resampling.LANCZOS)
            image.save(OUTPUT / ('unity_' + name + '.png'), optimize=True)
        return 'unity_' + name, width/pixels, height/pixels

    result = []
    for stage in ('1', '2', '3', '4', '5', '6', 'EXA'):
        objects = unity_documents(source / 'Scene' / f'Stage{stage}.unity', {1, 4, 20, 114, 212})
        components = defaultdict(dict)
        scripts = defaultdict(dict)
        transform_ids = {}
        for tid, (kind, obj) in objects.items():
            if 'm_GameObject' not in obj:
                continue
            go = obj['m_GameObject']['fileID']
            if kind != 114:
                components[go][kind] = obj
                if kind == 4:
                    transform_ids[go] = tid
                continue
            path = assets.get(obj.get('m_Script', {}).get('guid'))
            if path and obj.get('m_Enabled'):
                scripts[go][path.stem] = obj

        def chain(go):
            while go:
                transform_data = components[go][4]
                yield go, transform_data
                parent = transform_data['m_Father']['fileID']
                go = objects[parent][1]['m_GameObject']['fileID'] if parent else 0

        cameras = []
        for go, parts in components.items():
            if 20 not in parts:
                continue
            name = objects[go][1]['m_Name']
            if name not in ('Camera_3D', 'Camera_3D_back'):
                continue
            node, cam, motions = parts[4], parts[20], scripts[go]
            rotation = motions.get('Camara_rotate')
            angles = vector(rotation['mcxzksjd'][0]) if rotation and rotation.get('mcxzksjd') else None
            axes = transform(node['m_LocalRotation'], [1, 1, 1])
            translate = motions.get('Camara_translate')
            cameras.append((cam['m_Depth'], [
                vector(node['m_LocalPosition']), angles or [],
                [row[2] for row in axes], [row[1] for row in axes],
                cam['field of view'], cam['near clip plane'], cam['far clip plane'],
                cam['m_NormalizedViewPortRect']['x'],
                vector(translate['speed_start']) if translate else [0, 0, 0],
                events(translate, 'speed_change') if translate else [],
                events(rotation, 'rotate_change') if rotation else [],
                cam['m_CullingMask']['m_Bits'],
                [vector(x) for x in rotation['mcxzksjd']] if angles else [],
                int(name == 'Camera_3D'),
            ]))

        groups, group_index, sprites = [], {}, []
        for go, parts in components.items():
            renderer = parts.get(212)
            if not renderer or not renderer['m_Enabled']:
                continue
            hierarchy = list(chain(go))
            nodes = [objects[parent][1] for parent, _ in hierarchy]
            if not all(node['m_IsActive'] for node in nodes) or nodes[-1]['m_Name'] == 'Effect_cut':
                continue
            if stage in ('5', '6', 'EXA'):
                # 这些场景的主要物件使用 Unity MeshRenderer 或专用材质。
                continue
            sprite = renderer['m_Sprite']
            info = sprite_info(sprite.get('guid'), sprite['fileID'])
            if not info:
                continue
            name, width, height = info
            center, span_x, span_y = [0, 0, 0], [width/2, 0, 0], [0, height/2, 0]
            if renderer['m_FlipX']:
                span_x[0] *= -1
            if renderer['m_FlipY']:
                span_y[1] *= -1
            actions, loops = [], []
            for j, (ancestor, t) in enumerate(hierarchy):
                matrix = transform(t['m_LocalRotation'], vector(t['m_LocalScale']))
                center = [x + y for x, y in zip(multiply(matrix, center), vector(t['m_LocalPosition']))]
                span_x, span_y = multiply(matrix, span_x), multiply(matrix, span_y)
                motions = scripts[ancestor]
                if 'Tongyong_weiyi_add' in motions:
                    script = motions['Tongyong_weiyi_add']
                    if script['ifsin']:
                        actions.extend(events(script, 'pos_add', 'start_time', 'time_long'))
                if 'Camara_BG_xunhuan' in motions and j:
                    if ancestor not in group_index:
                        children = references(t['m_Children'])
                        speed = motions.get('Camara_setBG_speed')
                        change = []
                        if speed:
                            # 两个同长的 Unity 序列，保留起点和循环间距。
                            count = len(str(speed['set_time'])) // 8
                            change = list(map(list, zip(integers(speed['set_time'], count),
                                                        integers(speed['set_speed'], count))))
                        delta = vector(motions['Camara_BG_xunhuan']['pos_add'])
                        for _, parent in hierarchy[j:]:
                            delta = multiply(transform(parent['m_LocalRotation'], vector(parent['m_LocalScale'])), delta)
                        group_index[ancestor] = len(groups) + 1
                        groups.append([delta, len(children), motions['Camara_BG_xunhuan']['time_start'], change])
                    child_id = transform_ids[hierarchy[j-1][0]]
                    child = references(t['m_Children']).index(child_id)
                    loops.append([group_index[ancestor], child])
            if (stage == '1' and nodes[0]['m_Name'] == 'sky') or (stage == '3' and name == 'unity_st3_tian2'):
                # 安全区外延展远景，避免宽屏裁切后露出贴图的竖直边。
                span_x = [i * 2 for i in span_x]
            order = renderer['m_SortingLayer'] * 100 + renderer['m_SortingOrder']
            color = [round(renderer['m_Color'][k]*255) for k in 'rgba']
            row = [name, nodes[0]['m_Layer'], order, center, span_x, span_y, color, loops, actions]
            rock = next((scripts[parent]['St4rock'] for parent, _ in hierarchy
                         if 'St4rock' in scripts[parent]), None)
            if rock:
                row.append([rock['change1'], rock['change2'], int(nodes[0]['m_Name'][1:])])
            sprites.append(row)
        result.append(([camera for _, camera in sorted(cameras)], groups, sprites))

    out = ROOT / 'mod/GAME/th38/background_scenes.lua'
    with out.open('w', encoding='utf-8') as fp:
        fp.write('-- 由 tools/th38-tests/export_background.py 从 Unity 场景导出。\nreturn {\n')
        for cameras, groups, sprites in result:
            fp.write('    {cameras=' + lua(cameras) + ',loops=' + lua(groups) + ',sprites={\n')
            for sprite in sprites:
                fp.write('        ' + lua(sprite) + ',\n')
            fp.write('    }},\n')
        fp.write('}\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path, help='雪莲华工程根目录')
    export(parser.parse_args().source.resolve() / 'Assets')
