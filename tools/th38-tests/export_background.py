#!/usr/bin/env python3
"""从雪莲华 Unity 场景导出相机、背景节点、材质及网格。"""
import argparse
from collections import Counter
from functools import cache
import json
from pathlib import Path
import re
import shutil
import struct

from PIL import Image
import yaml

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'mod/GAME/th38/scenes'
ART = ROOT / 'Resources/th38/background/unity'
STAGES = ('1', '2', '3', '4', '5', '6', 'EXA')
TYPES = {1, 4, 20, 23, 33, 104, 114, 198, 199, 212, 1001}
HEADER = re.compile(r'^--- !u!(\d+) &(-?\d+)(?: stripped)?\n(.*?)(?=^---|\Z)', re.M | re.S)
TRACKS = {
    'Camara_translate': ('speed_start', 'time_change', 'speed_change', 'time_change_long'),
    'Camara_rotate': ('rotate_start', 'time_change', 'rotate_change', 'time_change_long'),
    'Camara_BG_xunhuan': ('pos_add', 'time_start'),
    'Camara_setBG_speed': ('set_time', 'set_speed'),
    'Camara_death': ('time',),
    'Tongyong_death_shijianzhou': ('death_time',),
    'Tongyong_death_time_kedu': ('death_time',),
    'Tongyong_xuanzhuan': ('zhuansu',),
    'Tongyong_weiyi_add': ('start_time', 'pos_add', 'time_long', 'ifsin'),
    'Tongyong_weiyi_jiaozhun': ('time', 'weizhi'),
    'Tongyong_xuanzhuan2': ('zhuansu',),
    'Tongyong_translate': ('v3',),
    'Tongyong_gensui_gameobj': ('obj', 'pianyi', 'if_camera'),
    'Tongyong_pos_base': ('father', 'pianyi'),
    'Tongyong_minganbianhua_shader': ('time_start', 'zhouqi', 'min', 'max'),
    'Tongyong_minganbianhua_shader2': ('time_start', 'zhouqi', 'min', 'max', 'first_base'),
    'Tongyong_minganbianhua': ('time_start', 'zhouqi', 'min', 'max'),
    'Tongyong_jianxianjianyin': ('time_long', 'time_yanshi', 'jianxian_or_jianyin', 'yingyongziwuti', 'a_kuadu'),
    'ST5_piece_flot': ('time_pianyi', 'time_zhouqi', 'beilv'),
    'St4rock': ('change1', 'change2'),
    'St4BG': ('time1', 'time2', 'a1', 'a2'),
    'ST5_ctrl': ('time_B',),
    'ST5_colorSet': ('light_color',),
    'st6_speed': ('speed', 'speed_add_time', 'speed_add_long', 'speed_add', 'speed_red_time', 'speed_red_long', 'speed_red_zhen'),
    'STEX_came_lock': ('beilv', 'shangxiazhouqi'),
}
ARRAYS = {'time_change', 'time_change_long', 'start_time', 'time_long', 'set_time', 'set_speed'}
REFERENCES = {'obj', 'father'}


def lua(v):
    if isinstance(v, dict):
        return '{' + ','.join(f'[{lua(k)}]={lua(x)}' for k, x in v.items()) + '}'
    if isinstance(v, (list, tuple)):
        return '{' + ','.join(map(lua, v)) + '}'
    if isinstance(v, str):
        return json.dumps(v, ensure_ascii=False)
    if isinstance(v, float):
        return format(v, '.8g')
    if v is None:
        return 'nil'
    return str(v)


def fid(ref):
    return ref.get('fileID', 0) if ref else 0


def xyz(value):
    return [value[k] for k in ('x', 'y', 'z')]


def rgba(value):
    return [value.get(k, 1) for k in ('r', 'g', 'b', 'a')]


def doc(path, types, loader=yaml.CSafeLoader):
    for k, i, text in HEADER.findall(path.read_text(encoding='utf-8-sig')):
        if int(k) in types:
            yield int(k), int(i), next(iter(yaml.load(text, Loader=loader).values()))


def packed(value):
    if value is None or value == '':
        return []
    data = bytes.fromhex(f'{value:08d}' if isinstance(value, int) else value)
    return list(struct.unpack('<' + 'i' * (len(data) // 4), data))


def detail_mesh(vertices, parts):
    # 把细分模型按空间与 UV 同时合并。LuaSTG 兼容绘制接口每次提交一个三角形。
    if sum(len(part) for part in parts) < 300:
        return None
    axes = list(zip(*vertices))
    bounds = [(min(axis), max(axis)) for axis in axes]
    resolution = (8, 8, 8, 5, 5)
    cells, mapping = {}, []
    for vertex in vertices:
        key = tuple(round((value-low)/max(high-low, 1e-6)*scale)
                    for value, (low, high), scale in zip(vertex, bounds, resolution))
        if key not in cells:
            cells[key] = len(cells)+1, [0.0]*5, 0
        index, acc, count = cells[key]
        for i, value in enumerate(vertex):
            acc[i] += value
        cells[key] = index, acc, count+1
        mapping.append(index)
    reduced_parts = []
    for part in parts:
        kept, seen = [], set()
        for i in range(0, len(part), 3):
            triangle = [mapping[j-1] for j in part[i:i+3]]
            key = tuple(sorted(triangle))
            if key[0] != key[1] and key[1] != key[2] and key not in seen:
                seen.add(key)
                kept.extend(triangle)
        reduced_parts.append(kept or None)
    if any(part is None for part in reduced_parts) or sum(map(len, reduced_parts)) >= sum(map(len, parts))*.8:
        return None
    return dict(verts=[[v/count for v in acc] for _, acc, count in cells.values()], parts=reduced_parts)


class Source:
    def __init__(self, root):
        self.root = root
        self.guids = {}
        self.counts = Counter()
        self.meshes = {}
        for path in root.rglob('*.meta'):
            match = re.search(r'^guid: (\w+)', path.read_text(encoding='utf-8-sig'), re.M)
            if match:
                self.guids[match[1]] = path.with_suffix('')

    def path(self, ref):
        return self.guids.get(ref.get('guid'))

    @cache
    def texture(self, path):
        key = path.relative_to(self.root).as_posix()
        prefix = 'Resources/xuelianhua/image/background/'
        if key.startswith(prefix):
            key = key[len(prefix):]
        key = str(Path(key).with_suffix('.png'))
        dest = ART / key
        dest.parent.mkdir(parents=True, exist_ok=True)
        with Image.open(path) as image:
            size = image.size
            if image.format == 'PNG':
                shutil.copyfile(path, dest)
            else:
                image.convert('RGBA').save(dest)
        return key, *size

    @cache
    def sprite_info(self, path):
        info = yaml.load(path.with_name(path.name + '.meta').read_text(), Loader=yaml.CSafeLoader)['TextureImporter']
        key, w, h = self.texture(path)
        return key, w, h, info.get('spritePixelsToUnits', 100), info.get('spritePivot', {'x': .5, 'y': .5})

    @cache
    def material(self, path):
        if not path:
            return {}
        _, _, mat = next(doc(path, {21}))
        props = mat['m_SavedProperties']
        colors = {key: v for d in props['m_Colors'] for key, v in d.items()}
        floats = {key: v for d in props['m_Floats'] for key, v in d.items()}
        images = {key: v for d in props['m_TexEnvs'] for key, v in d.items()}
        shader = self.path(mat['m_Shader'])
        shader_id = fid(mat['m_Shader'])
        blend = 'mul+add' if (shader_id == 200 or (shader and 'add' in shader.stem.lower())) else ''
        opaque = (floats.get('_Mode', 0) == 0 and mat['m_CustomRenderQueue'] < 3000
                  and shader_id != 200 and not blend and shader_id != 10753)
        color = rgba(colors.get('_Color', colors.get('_TintColor', {})))
        if 'WaterPro' in path.stem:
            color = rgba(colors['_HorizonColor'])
            color[3] = 1
        texture = images.get('_MainTex', {})
        tex_path = self.path(texture.get('m_Texture', {}))
        out = dict(color=color, blend=blend, opaque=int(opaque), cull=int(opaque and floats.get('_Cull',2)==2))
        if tex_path:
            out.update(tex=self.texture(tex_path)[0], uv=[texture['m_Scale'][k] for k in ('x','y')]
                       + [texture['m_Offset'][k] for k in ('x','y')])
        if path.stem == 'm_sky_blue':
            out['sky'] = self.texture(self.path(images['_Sky']['m_Texture']))[0]
            out['cloud'] = [self.texture(self.path(images[f'_Octave{i}']['m_Texture']))[0] for i in range(4)]
            out['cloudColor'] = rgba(colors['_CloudColor'])
        return out

    @cache
    def mesh(self, path):
        if not path:
            raise ValueError('mesh without asset')
        key = str(path.relative_to(self.root))
        _, _, mesh = next(doc(path, {43}, yaml.CBaseLoader))
        fmt = 'H' if mesh['m_IndexFormat'] == '0' else 'I'
        indexes = bytes.fromhex(mesh['m_IndexBuffer'])
        vd = mesh['m_VertexData']
        data = bytes.fromhex(vd['_typelessdata'])
        channels = vd['m_Channels']
        assert all(c['stream']=='0' for c in channels if int(c['dimension'])), path
        stride = len(data) // int(vd['m_VertexCount'])
        pos, uv = int(channels[0]['offset']), int(channels[4]['offset'])
        assert channels[0]['format'] == '0' and channels[4]['format'] == '0', path
        vertices = []
        for i in range(int(vd['m_VertexCount'])):
            vertices.append((*struct.unpack_from('<fff', data, stride*i+pos),
                             *struct.unpack_from('<ff', data, stride*i+uv)))
        parts = []
        for part in mesh['m_SubMeshes']:
            assert part['topology'] == '0', path
            count, offset = int(part['indexCount']), int(part['firstByte'])
            base = int(part['baseVertex'])
            parts.append([index+base+1 for index in struct.unpack_from('<'+fmt*count, indexes, offset)])
        axes = list(zip(*vertices))[:3]
        bounds = [(min(axis), max(axis)) for axis in axes]
        self.meshes[key] = dict(verts=vertices, parts=parts,
            bounds=[(a+b)*.5 for a,b in bounds] + [(b-a)*.5 for a,b in bounds],
            lod=detail_mesh(vertices,parts))
        return key

    def particle(self, ps, renderer):
        if not ps['playOnAwake'] or renderer['m_RenderMode'] != 0:
            return None
        init, shape, emit = (ps[k] for k in ('InitialModule', 'ShapeModule', 'EmissionModule'))
        mat = self.material(self.path(renderer['m_Materials'][0]))
        if not mat.get('tex') or emit['rateOverTime']['scalar'] <= 0:
            return None

        def range_of(curve):
            high = curve['scalar']
            low = curve['minScalar'] if curve['minMaxState'] == 3 else high
            return [low, high]

        def size_curve(curve):
            return [[k['time'], k['value']*curve['scalar'], k['inSlope']*curve['scalar'],
                     k['outSlope']*curve['scalar']] for k in curve['maxCurve']['m_Curve']]

        start_color = init['startColor']
        color = ps['ColorModule']['gradient']['maxGradient']
        alpha = []
        rgb = []
        if ps['ColorModule']['enabled']:
            alpha = [[color[f'atime{i}']/65535, color[f'key{i}']['a']] for i in range(color['m_NumAlphaKeys'])]
            rgb = [[color[f'ctime{i}']/65535, *rgba(color[f'key{i}'])[:3]] for i in range(color['m_NumColorKeys'])]
        velocity = ps['VelocityModule']
        rotation = ps['RotationModule']
        rotating = range_of(rotation['curve']) if rotation['enabled'] else [0,0]
        drift = [range_of(velocity[k]) for k in ('x','y','z')] if velocity['enabled'] else [[0,0]]*3
        size = size_curve(ps['SizeModule']['curve']) if ps['SizeModule']['enabled'] else []
        self.counts['particles'] += 1
        return dict(tex=mat['tex'], blend=mat['blend'], tint=mat['color'], order=renderer['m_SortingOrder']+65536*renderer['m_SortingLayer'],
            rate=emit['rateOverTime']['scalar'], shape=shape['type'], shapePos=xyz(shape['m_Position']),
            shapeRot=xyz(shape['m_Rotation']), shapeScale=xyz(shape['m_Scale']), radius=shape['radius']['value'],
            thickness=shape['radiusThickness'], length=ps['lengthInSec'], simulation=ps['simulationSpeed'],
            prewarm=ps['prewarm'], localSpace=ps['moveWithTransform'], loop=ps['looping'],
            delay=ps['startDelay']['scalar'], life=range_of(init['startLifetime']), speed=range_of(init['startSpeed']),
            angle=range_of(init['startRotation']), rotating=rotating, drift=drift,
            size=range_of(init['startSize']), sizeCurve=size, alpha=alpha, rgb=rgb,
            color=rgba(start_color['maxColor']), colorMin=rgba(start_color['minColor']) if start_color['minMaxState']==2 else None,
            maxCount=init['maxNumParticles'], maxSize=renderer['m_MaxParticleSize'],
            gravity=init['gravityModifier']['scalar'], seed=ps['randomSeed'])

    def graph(self, path, stage, cameras, prefix, additions=None):
        entries = {}
        raw_arrays = {}
        for k, i, text in HEADER.findall(path.read_text(encoding='utf-8-sig')):
            if int(k) in TYPES:
                entries[int(i)] = int(k), next(iter(yaml.load(text, Loader=yaml.CSafeLoader).values()))
                if int(k)==114:
                    raw_arrays[int(i)] = dict(re.findall(r'^  (\w+): ([A-F0-9]+)\s*$', text,re.M))
        objects = {i: o for i, (k,o) in entries.items() if k == 1}
        transforms = {i: o for i, (k,o) in entries.items() if k == 4}
        object_transform = {fid(o['m_GameObject']): i for i,o in transforms.items()}
        camera_nodes = {}
        if cameras is None:
            cameras = []
            for kind, cam in entries.values():
                if kind != 20:
                    continue
                obj_id = fid(cam['m_GameObject'])
                go = objects[obj_id]
                if go['m_Name'] not in ('Camera_3D', 'Camera_3D_back'):
                    continue
                name = 'main' if go['m_Name'] == 'Camera_3D' else 'far'
                camera_nodes[obj_id] = name
                cameras.append(dict(name=name, mask=cam['m_CullingMask']['m_Bits'], depth=cam['m_Depth'],
                    fov=cam['field of view'], near=cam['near clip plane'], far=cam['far clip plane'],
                    rect=cam['m_NormalizedViewPortRect']['x'], clear=rgba(cam['m_BackGroundColor'])))
            cameras.sort(key=lambda c: c['depth'])
        mask = 0
        for cam in cameras:
            mask |= cam['mask']
        active = {}

        def add(i):
            if not i or i in active:
                return
            t = transforms[i]
            add(fid(t['m_Father']))
            active[i] = len(active) + prefix + 1

        for obj_id,go in objects.items():
            if obj_id not in object_transform:
                continue
            if obj_id in camera_nodes:
                add(object_transform[obj_id])
            if not (mask >> go['m_Layer']) & 1:
                continue
            if any(entries.get(fid(ref['component']), (0,))[0] in (23, 198, 212) for ref in go['m_Component']):
                add(object_transform[obj_id])

        nodes = []
        for i in active:
            tr = transforms[i]
            obj_id = fid(tr['m_GameObject'])
            go = objects[obj_id]
            name = go['m_Name']
            scripts = {}
            for ref in go['m_Component']:
                comp = fid(ref['component'])
                k,c = entries.get(comp, (None,None))
                if k != 114 or not c['m_Enabled']:
                    continue
                script = self.path(c['m_Script'])
                if not script or script.stem not in TRACKS:
                    continue
                fields = {}
                for key in TRACKS[script.stem]:
                    if key not in c:
                        continue
                    value = c[key]
                    if key in REFERENCES:
                        target = fid(value)
                        target = object_transform.get(target,target)
                        value = active.get(target,0)
                    elif isinstance(value, dict):
                        value = xyz(value) if 'x' in value else rgba(value)
                    elif isinstance(value,list):
                        value = [xyz(v) if isinstance(v,dict) else v for v in value]
                    elif key in ARRAYS and (key!='time_long' or script.stem=='Tongyong_weiyi_add'):
                        value = packed(raw_arrays[comp].get(key, value))
                    fields[key] = value
                scripts[script.stem] = fields
            node = dict(name=name, parent=active.get(fid(tr['m_Father']),0),
                pos=xyz(tr['m_LocalPosition']), rot=xyz(tr['m_LocalRotation'])+[tr['m_LocalRotation']['w']],
                scale=xyz(tr['m_LocalScale']), on=go['m_IsActive'], layer=go['m_Layer'])
            if scripts:
                node['scripts'] = scripts
            if obj_id in camera_nodes:
                for cam in cameras:
                    if cam['name']==camera_nodes[obj_id]:
                        cam['node'] = active[i]
            comps = dict(entries.get(fid(ref['component']), (0,{})) for ref in go['m_Component']
                         if fid(ref['component']) in entries)
            if 212 in comps and comps[212]['m_Enabled']:
                sr = comps[212]
                asset = self.path(sr['m_Sprite'])
                if asset:
                    key,w,h,ppu,pivot = self.sprite_info(asset)
                    # SpriteRenderer 的 m_Size 来自 Unity 导入尺寸，保留原作单位。
                    size = sr['m_Size']
                    mat = self.material(self.path(sr['m_Materials'][0]))
                    node['sprite'] = dict(tex=mat.get('sky',key), size=[size['x'] or w/ppu,size['y'] or h/ppu],
                        pivot=[pivot['x'],pivot['y']], flip=[sr['m_FlipX'],sr['m_FlipY']],
                        order=sr['m_SortingOrder']+sr['m_SortingLayer']*65536, color=rgba(sr['m_Color']),
                        blend=mat.get('blend',''), cloud=mat.get('cloud'), cloudColor=mat.get('cloudColor'))
                    self.counts['sprites']+=1
            if 198 in comps and 199 in comps and comps[199]['m_Enabled']:
                ps = self.particle(comps[198], comps[199])
                if ps:
                    node['particles'] = ps
            if 23 in comps and 33 in comps and comps[23]['m_Enabled']:
                materials = [self.material(self.path(ref)) for ref in comps[23]['m_Materials']]
                mesh_ref = self.path(comps[33]['m_Mesh'])
                if mesh_ref:
                    node['mesh'] = dict(key=self.mesh(mesh_ref), materials=materials)
                    if stage=='6' and 'WaterPro' in name:
                        water_tex = self.root/'Resources/xuelianhua/image/background/st6/st6_01/XLH_S6_Styx01.png'
                        node['mesh']['materials'] = [dict(tex=self.texture(water_tex)[0], opaque=1,
                            uv=[1,1,0,0], blend='',color=materials[0]['color'], water=1)]
                    self.counts['meshes']+=1
            if additions and node['parent']==0:
                node.update(additions)
            nodes.append(node)
        for original_index, tr in transforms.items():
            if original_index in active and 'Camara_BG_xunhuan' in nodes[active[original_index]-1-prefix].get('scripts',{}):
                # 比对原来的 sibling index，即使有纯粒子节点也保留它在轮换中的位置。
                nodes[active[original_index]-1-prefix]['children'] = [active.get(fid(ref),0) for ref in tr['m_Children']]
        return nodes,cameras

    def stage(self, name, suffix=''):
        file = self.root/'Scene'/f'Stage{name}{suffix}.unity'
        nodes,cameras = self.graph(file,name,None,0)
        if name=='3' and not suffix:
            bg = self.root/'Resources/xuelianhua/image/background/st3'
            for prefab, tag in [('niaoju','gate'),('ST3_part2','second'),('bai','flash')]:
                extra, _ = self.graph(bg/(prefab+'.prefab'),name,cameras,len(nodes),dict(phase=tag))
                nodes.extend(extra)
        return dict(nodes=nodes, cameras=cameras)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('assets', type=Path)
    args = parser.parse_args()
    source = Source(args.assets.resolve())
    OUT.mkdir(exist_ok=True)
    for name in STAGES:
        for suffix in ('', '_boss', '_spell'):
            if not (source.root/'Scene'/f'Stage{name}{suffix}.unity').exists():
                continue
            data = source.stage(name,suffix)
            if suffix and not data['nodes']:
                continue
            with (OUT/(name+suffix+'.lua')).open('w') as handle:
                handle.write('return {cameras='+lua(data['cameras'])+',nodes={\n')
                for node in data['nodes']:
                    handle.write(lua(node)+',\n')
                handle.write('}}\n')
    with (OUT/'meshes.lua').open('w') as handle:
        handle.write('return {\n')
        for name, m in sorted(source.meshes.items()):
            handle.write(f'[{lua(name)}]={lua(m)},\n')
        handle.write('}\n')
    print(source.counts, len(source.meshes), 'mesh assets')


if __name__ == '__main__':
    main()
