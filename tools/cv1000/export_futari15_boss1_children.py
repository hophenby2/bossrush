"""从原版工作 RAM 与显存导出关底 0xa2 子敌机的全部十六帧和叠加层。"""
import argparse
import struct
from pathlib import Path

import numpy as np
from PIL import Image
from analyze import decode_sprite


def export(ram,vram,output,data):
    memory=ram.read_bytes()
    if len(memory)!=0x800000:raise ValueError('工作 RAM 必须为 8 MiB')
    byte=lambda a:memory[a^7]
    word=lambda a:byte(a)*256+byte(a+1)
    signed=lambda a:struct.unpack('b',bytes([byte(a)]))[0]
    pixels=np.memmap(vram,dtype='<u4',mode='r',shape=(4096,8192))
    images=[]
    for index in range(0x6a4d,0x6a6d):
        at=0x20bf14+index*10
        page=word(0x51854+word(at)*2)-1
        h,w=word(at+4),word(at+6)
        x=word(0x52420+page)+256-byte(at+3)-w
        y=word(0x52422+page)+byte(at+2)
        images.append(decode_sprite(pixels,x,y,w,h,0x100))
    cell=max(max(im.size)for im in images)
    sheet=Image.new('RGBA',(cell*8,cell*4));frames=[]
    for i,im in enumerate(images):
        x=i%8*cell+(cell-im.width)//2;y=i//8*cell+(cell-im.height)//2
        sheet.alpha_composite(im,(x,y));frames.append((x,y,*im.size))
    output.parent.mkdir(parents=True,exist_ok=True);sheet.save(output)
    lines=['-- 0x0c15e1a0 的十六帧本体/叠加裁片与 0x0c30a030 的有符号锚点。','return {',
        '    offsets={'+','.join('{%d,%d}'%(signed(0x30a030+i*2),signed(0x30a031+i*2))for i in range(16))+'},',
        '    frames={'+','.join('{%d,%d,%d,%d}'%r for r in frames)+'},','}']
    data.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('ram','vram','output','data'):p.add_argument(name,type=Path)
    args=p.parse_args();export(args.ram,args.vram,args.output,args.data)
