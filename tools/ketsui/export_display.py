"""从 ket 程序与图形 ROM 导出街机画面追加的显示资源。"""
import argparse
from pathlib import Path
import struct

import numpy as np
from PIL import Image

from export import Atlas, Graphics, ROOT, decode_palette
from export_native import rows
from inspect_program import pointer, read_program


def export(program, graphics, target, resources):
    sprite_colors = np.zeros((0x400, 3), dtype='u1')
    # 两种机体都用 P1 的硬件槽位，移植图集中用不同编号保留各自的颜色。
    for bank, address in ((0, 0x628a0), (1, 0x62920), (4, 0x62a20), (5, 0x62a60),
                          (22, 0x64c20), (23, 0x65ee0)):
        sprite_colors[bank*32:(bank+1)*32] = decode_palette(
            struct.unpack_from('>32H', program, address))
    text_colors = {
        bank: decode_palette(struct.unpack_from('>16H', program, address))
        for bank, address in ((1, 0x625c0), (6, 0x625c0), (7, 0x62740),
                              (9, 0x626a0), (10, 0x626c0), (11, 0x62780), (12, 0x62680))
    }

    def decode(key, colors):
        if key[0] == 'sprite':
            return graphics.sprite(key[1:], colors)
        if key[0] == 'beam':
            image = graphics.sprite(key[1:], colors)
            return image.crop(image.getchannel('A').getbbox())
        _, code, bank, flip = key
        raw = np.frombuffer(graphics.tiles, dtype='u1', count=32, offset=code*32)
        pens = np.stack((raw & 15, raw >> 4), axis=1).reshape(8, 8)
        if flip:
            pens = np.flipud(pens)
        rgba = np.empty((8, 8, 4), dtype='u1')
        rgba[:, :, :3] = colors[bank][pens]
        rgba[:, :, 3] = np.where(pens == 15, 0, 255)
        return Image.fromarray(np.rot90(rgba))

    atlas = Atlas('display', decode)

    def art(addr, size, bank, flip=0):
        return atlas.get(('sprite', addr, size >> 9, size & 511, bank, flip), sprite_colors)

    def text(code, bank, flip=False):
        return atlas.get(('text', code, bank, flip), text_colors)

    def text_row(start, count, bank):
        return [text(start+i, bank) for i in range(count)]

    target.mkdir(parents=True, exist_ok=True)
    resources.mkdir(parents=True, exist_ok=True)
    with (target / 'rom_display.lua').open('w', encoding='utf-8', newline='\n') as out:
        out.write('-- 由 tools/ketsui/export_display.py 从绊地狱 ROM 导出。\nreturn {\n')

        def array(name, values):
            out.write(f'  {name}={{' + ','.join(map(str, values)) + '},\n')

        def table(name, values):
            out.write(f'  {name}={{\n' + rows(values) + '  },\n')

        # 0xb55ba 的部件模板写入机身尺寸。0xbc64e 的对应字段是精灵指针。
        hull_size = struct.unpack_from('>H', program, 0xb55ba+0x0e)[0]
        table('hull', ([art(pointer(program, pointer(program, 0xbc6d2+4*ship)+4*i),
                            hull_size, ship) for i in range(-8, 9)] for ship in range(2)))
        # 0xb6130 的保护环按 0x28 倒序读十六张图。0xb5e0e 为两机体的影子转向表。
        table('shield', ([art(pointer(program, 0xbc8f2+4*i), 0xa38, 4+ship)
                          for i in range(16)] for ship in range(2)))
        table('shadow', ([art(pointer(program, pointer(program, 0xbc84e+4*ship)+4*i), 0x410, 24)
                          for i in range(-8, 9)] for ship in range(2)))
        out.write('  options={\n')
        for ship, base in enumerate((0xbce14, 0xbd0b4)):
            out.write('    {\n' + rows(
                (tuple(art(pointer(program, pointer(program, base+4*i)+4*j), 0x410, ship)
                       for j in range(8)) for i in range(32)), '      ') + '    },\n')
        out.write('  },\n')
        # 0xb619c 的旋转片随自机侧倾选择四帧和横轴偏移。
        out.write('  shieldFan={\n')
        for ship in range(2):
            base = pointer(program, 0xbc932+4*ship)
            offsets = pointer(program, 0xbcbf2+4*ship)
            h, size = struct.unpack_from('>hH', program, pointer(program, 0xbcbe2+4*ship))
            out.write('    {\n' + rows(
                ((h, struct.unpack_from('>h', program, offsets+2*i)[0],
                  *(art(pointer(program, pointer(program, base+4*i)+4*j), size, ship) for j in range(4)))
                 for i in range(-8, 9)), '      ') + '    },\n')
        out.write('  },\n')

        # 0x10ca46 的云图及实际用到的两种翻转。
        table('clouds', ([art(pointer(program, 0x10ca46+4*i), 0x38e0, 23, flip) for i in range(4)]
                         for flip in (0, 2)))

        # 0x904000 的 8×8 文本层。纵屏从原来的列坐标换算画面纵轴。
        array('digits', text_row(0xc0b0, 10, 1))
        table('life', (text_row(0xc396, 2, 9), text_row(0xc398, 2, 10)))
        table('title', (text_row(start, 8, 7) for start in range(0xc446, 0xc476, 8)))
        table('insertCoin', (text_row(0xc3c6, 10, 6), text_row(0xc3d0, 10, 6)))
        table('bombPanel', ([text(code+i*2, 12, flip) for i in range(3)]
                            for code, flip in ((0xc358, False), (0xc358, True), (0xc346, False),
                                               (0xc347, False), (0xc34c, False), (0xc34d, False),
                                               (0xc352, False), (0xc353, False))))
        # 0x103f22 / 0x10407a 的 Boss 血条框和填充动画。图集槽位 22 保存其独立调色板。
        table('bossPanel', (text_row(start, 28, 12) for start in (0xc35e, 0xc37a)))
        array('bossMeter', [art(pointer(program, 0x1040fc+i*4), 0x2d0, 22) for i in range(6)])
        table('pleaseWait', (text_row(0xc4be+i*24, 24, 11) for i in range(6)))
        # 取 0xbd89c 的正向飞行图，去掉透明边距后让光束两端落在僚机和目标上。
        out.write('  optionBeam={\n')
        for ship, flight in enumerate((0xb8e48, 0xba5f2)):
            base = pointer(program, 0xbd89c+ship*4)
            beam_frames = []
            for level in range(5):
                shot = pointer(program, pointer(program, base+level*4))
                frames = pointer(program, shot+30)
                size = struct.unpack_from('>H', program, pointer(program, flight+level*36)+4)[0]
                beam_frames.append(tuple(atlas.get(('beam', pointer(program, frames+4*i),
                                                  size >> 9, size & 511, 4+ship, 0),
                                                 sprite_colors) for i in range(3)))
            out.write('    {\n' + rows(beam_frames, '      ') + '    },\n')
        out.write('  },\n')
        table('rects', atlas.rects)
        out.write('}\n')
    atlas.save(resources)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('program', type=Path)
    parser.add_argument('rom', type=Path)
    parser.add_argument('--output', type=Path, default=ROOT / 'mod/GAME/th43/native')
    parser.add_argument('--resources', type=Path, default=ROOT / 'Resources/th43/native')
    args = parser.parse_args()
    export(read_program(args.program), Graphics(args.rom), args.output, args.resources)


if __name__ == '__main__':
    main()
