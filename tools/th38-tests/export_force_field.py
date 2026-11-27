#!/usr/bin/env python3
"""只读导出雪莲华发行包 emy41 力场，保留阴影材质和两个闪烁环。"""
import argparse
import hashlib
import json
from pathlib import Path
import sys
sys.dont_write_bytecode = True

from UnityPy.export.SpriteHelper import MeshHandler
from UnityPy.export.Texture2DConverter import get_image_from_texture2d
from release_source import Source
from export_release_presentation import lua

ROOT = Path(__file__).resolve().parents[2]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--data', type=Path, required=True)
    ap.add_argument('--assets', type=Path, required=True)
    args = ap.parse_args()
    source = Source(args.data)
    art = ROOT / 'Resources/th38/force_field'
    art.mkdir(exist_ok=True)
    manager = next(o for o in source.load('globalgamemanagers').objects.values()
                   if o.type.name == 'ResourceManager').read()
    resource = 'xuelianhua/prefab/enemy/emy41'
    prefab = next(p for name, p in manager.m_Container if name == resource)
    sprites, nodes = {}, []

    def sprite(pointer):
        key = str(pointer.path_id)
        if key in sprites:
            return key
        s = pointer.read()
        assert not s.m_SpriteAtlas and not s.m_RD.alphaTexture
        t = s.m_RD.texture
        s.assets_file._cache[t.path_id] = get_image_from_texture2d(t.deref().read(check_read=False), False)
        image = s.image
        file = art / (s.m_Name + '.png')
        image.save(file, optimize=True)
        mesh = MeshHandler(s.m_RD, s.object_reader.version)
        mesh.process()
        px = -min(v[0] for v in mesh.m_Vertices) * s.m_PixelsToUnits
        py = max(v[1] for v in mesh.m_Vertices) * s.m_PixelsToUnits
        sprites[key] = dict(file=file.relative_to(ROOT).as_posix(), size=list(image.size),
                            center=[px, py], ppu=s.m_PixelsToUnits,
                            sha256=hashlib.sha256(file.read_bytes()).hexdigest())
        return key

    def visit(go):
        out = dict(name=go.m_Name, scripts=[])
        nodes.append(out)
        children = []
        for pair in go.m_Component:
            o = pair.component.deref()
            if o.type.name == 'Transform':
                t = o.read()
                out.update(position=[t.m_LocalPosition.x, t.m_LocalPosition.y],
                           scale=[t.m_LocalScale.x, t.m_LocalScale.y],
                           rotation=[t.m_LocalRotation.z, t.m_LocalRotation.w])
                children = t.m_Children
            elif o.type.name == 'SpriteRenderer':
                r = o.read()
                mat = r.m_Materials[0].read()
                shader = mat.m_Shader.deref().read_typetree(check_read=False)['m_ParsedForm']
                render_pass = shader['m_SubShaders'][0]['m_Passes'][-1]
                blend = render_pass['m_State']['rtBlend0']
                name = shader['m_Name']
                # 发行版 ps_jianqu 使用 SrcAlpha/OneMinusSrcAlpha（重建工程的 shader 不同）。
                assert name in ('Custom/ps_jianqu', 'Particles/Priority Additive'), name
                assert [blend[k]['val'] for k in ('srcBlend', 'destBlend', 'blendOp')] == (
                    [5, 10, 0] if name == 'Custom/ps_jianqu' else [5, 1, 0])
                out.update(sprite=sprite(r.m_Sprite), order=r.m_SortingOrder,
                           color=[r.m_Color.r, r.m_Color.g, r.m_Color.b, r.m_Color.a],
                           shader=name, colors={k: [c.r, c.g, c.b, c.a] for k, c in mat.m_SavedProperties.m_Colors})
            elif o.type.name == 'MonoBehaviour':
                name, _ = source.script(o)
                assert name in ('Enemymove', 'Enemy_lichang', 'Tongyong_sr_Alpha_to_shader',
                                'Tongyong_minganbianhua', 'Tongyong_xuanzhuan'), name
                if name not in ('Enemymove', 'Enemy_lichang', 'Tongyong_sr_Alpha_to_shader'):
                    out['scripts'].append(dict(kind=name, **{k: v for k, v in source.fields(o).items()
                                                            if not k.startswith('m_')}))
        for child in children:
            visit(child.read().m_GameObject.read())

    visit(prefab.read())
    assert len(nodes) == 3 and nodes[0]['scale'] == [0, 0]
    assert all(n['position'] == [0, 0] and n['rotation'] == [0, 1] for n in nodes)
    assert nodes[0]['colors']['_Color'][:3] == [1, 1, 1]
    assert all(n['scale'] == [1, 1] and n['colors']['_TintColor'] == [.5, .5, .5, .5] for n in nodes[1:])
    cs = args.assets / 'Scripts/Enemy_lichang.cs'
    text = cs.read_text(encoding='utf-8-sig')
    assert 'Sincos.jiejiefanghu_val -= 500;' in text and '* 6.4f + Sincos.panding0' in text
    assert 'case 20:\n\t\t\t\tenemy = Sincos.emy[41];' in (args.assets / 'Scripts/Basic.cs').read_text(encoding='utf-8-sig')
    enemy = (args.assets / 'Scripts/Enemymove.cs').read_text(encoding='utf-8-sig')
    assert 'position.x < -0.5f || base.transform.position.x > 9.7f' in enemy
    assert 'position.y < -11f || base.transform.position.y > 1.5f' in enemy
    output = ROOT / 'mod/GAME/th38'
    data = dict(nodes=nodes, sprites=sprites, radius=6.4, drain=500, shield_unit=100000,
                bounds=[-.5, 9.7, -11, 1.5])
    (output / 'force_field_data.lua').write_text('-- 发行包 emy41；来源与阴影混合依据见 force_field_sources.json。\nreturn ' + lua(data) + '\n')
    files = ('globalgamemanagers', 'resources.assets', 'resources.assets.resS', 'Managed/Assembly-CSharp.dll')
    provenance = dict(resource=resource, source_sha256={f: hashlib.sha256((args.data / f).read_bytes()).hexdigest() for f in files},
                      script_sha256={f: hashlib.sha256((args.assets / 'Scripts' / f).read_bytes()).hexdigest()
                                     for f in ('Enemy_lichang.cs', 'Enemymove.cs', 'Basic.cs', 'Tongyong_minganbianhua.cs', 'Tongyong_xuanzhuan.cs', 'Tongyong_sr_Alpha_to_shader.cs')},
                      shadow=dict(shader_path_id=1749, source_blend='SrcAlpha OneMinusSrcAlpha',
                                  pixel_shader='RGB = grab.rgb - texture.rgb * _Color.rgb; A = texture.a * _Color.a',
                                  equivalent='dst - texture.rgb * _Color.rgb * texture.a * _Color.a (mul+rev)',
                                  note='依据发行版 DXBC 反汇编及序列化 Blend，不使用重建工程 shader 的错误混合设置。'))
    (output / 'force_field_sources.json').write_text(json.dumps(provenance, ensure_ascii=False, indent=2) + '\n')
    print('emy41:', len(nodes), '节点，', len(sprites), '原始切片')


if __name__ == '__main__':
    main()
