"""检查 CV1000 的 EP1C12 指令，并从原显存提取单张素材。"""
import argparse
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
import struct

import numpy as np
from PIL import Image


@dataclass(frozen=True)
class MotionPool:
    x: int
    stride: int
    slots: int = 128


MOTION_POOLS = {
    'futari15': MotionPool(0x517ed8, 0x54),
    'espgal2': MotionPool(0x4b5028, 0x2c),
}


def motion_records(path, game):
    # SH-3 保存项使用宿主的 64 位排列。逻辑地址的相邻两组 32 位字在文件里互换。
    if path.stat().st_size != 0x800000:
        raise ValueError(f'{path} 的工作 RAM 长度错误')
    memory = np.memmap(path,dtype='<i4',mode='r')
    pool = MOTION_POOLS[game]
    for slot in range(pool.slots):
        x=pool.x+slot*pool.stride
        row=tuple(int(memory[((x+4*i)^4)//4]) for i in range(4))
        yield slot,row


def check_motion(first, second, game):
    changed, integrated = 0, 0
    for (slot,old), (_,new) in zip(motion_records(first,game),motion_records(second,game)):
        x,y,dx,dy=old
        if old[:2] == new[:2]:
            continue
        changed+=1
        if (x+dx,y+dy)==new[:2] or (x+new[2],y+new[3])==new[:2]:
            integrated+=1
    print(f'{game} 的 128 个槽位中，{changed} 个位置改变，{integrated} 个与记录的定点位移一致')


def frames(path):
    with path.open('rb') as file:
        if file.read(4) != b'CVB1':
            raise ValueError(f'{path} 的命令流格式错误')
        while header := file.read(10):
            frame, clip_x, clip_y, count = struct.unpack('>I3H', header)
            block = file.read(count * 20)
            if len(block) != count * 20:
                raise ValueError(f'{path} 第 {frame} 帧不完整')
            yield frame, clip_x, clip_y, struct.iter_unpack('>10H', block)


def sprite(path, sx, sy, width, height, flags):
    vram = np.memmap(path, dtype='<u4', mode='r', shape=(4096, 8192))
    return decode_sprite(vram, sx, sy, width, height, flags)


def decode_sprite(vram, sx, sy, width, height, flags):
    if not (0 <= sx < sx + width <= vram.shape[1] and 0 <= sy < sy + height <= vram.shape[0]):
        raise ValueError('取图范围超出 EP1C12 显存')
    pixels = vram[sy:sy+height, sx:sx+width]
    rgb = [(pixels >> bit) & 0xf8 for bit in (16, 8, 0)]
    alpha = np.where((pixels & 0x20000000) != 0, 255, 0) if flags & 0x100 else np.full(pixels.shape, 255)
    if flags & 0x800:
        rgb = [np.fliplr(channel) for channel in rgb]
        alpha = np.fliplr(alpha)
    if flags & 0x400:
        rgb = [np.flipud(channel) for channel in rgb]
        alpha = np.flipud(alpha)
    return Image.fromarray(np.stack((*rgb, alpha), axis=-1).astype('u1')).transpose(Image.Transpose.ROTATE_90)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('trace', type=Path)
    parser.add_argument('--frame', type=int)
    parser.add_argument('--sprite', type=int, help='绘制序号从 0 开始')
    parser.add_argument('--output', type=Path)
    parser.add_argument('--motion', choices=MOTION_POOLS, help='比较连续工作 RAM 中的位置及速度')
    parser.add_argument('--next-ram', type=Path)
    args = parser.parse_args()
    if args.motion:
        if not args.next_ram:
            parser.error('--motion 需要 --next-ram')
        check_motion(args.trace,args.next_ram,args.motion)
        return
    if args.frame is None:
        parser.error('分析绘制命令时需要 --frame')
    for frame, cx, cy, commands in frames(args.trace):
        if frame != args.frame:
            continue
        draw = list(commands)
        summary = Counter(((r[6] & 0x1fff)+1, (r[7] & 0x0fff)+1) for r in draw)
        print(f'{frame} 帧，视口原点 ({cx}, {cy})，绘制 {len(draw)} 次，常见尺寸 {summary.most_common(6)}')
        if args.sprite is not None:
            if not args.output:
                parser.error('提取精灵时需要 --output')
            flags, _, x, y, dx, dy, width, height, _, _ = draw[args.sprite]
            print(f'源 ({x}, {y})，目标 ({dx}, {dy})，属性 {flags:#06x}')
            path = args.trace.with_name(args.trace.name + '.vram')
            sprite(path, x & 0x1fff, y & 0x0fff, (width & 0x1fff)+1,
                   (height & 0x0fff)+1, flags).save(args.output)
        break
    else:
        parser.error(f'命令流没有第 {args.frame} 帧')


if __name__ == '__main__':
    main()
