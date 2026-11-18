"""导出第一面关底四种敌弹、共同出生闪光和消弹的原版裁片。"""
import argparse
from pathlib import Path
import numpy as np
from PIL import Image
from analyze import decode_sprite


def export(ram,vram,output,data,indices=None):
    memory=ram.read_bytes()
    if len(memory)!=0x800000:raise ValueError('工作 RAM 必须为 8 MiB')
    byte=lambda a:memory[a^7]
    word=lambda a:byte(a)*256+byte(a+1)
    pixels=np.memmap(vram,dtype='<u4',mode='r',shape=(4096,8192))
    indices=sorted(indices if indices is not None else{
        *range(0x93b,0x97f),*range(0xde3,0xe27),*range(0xbd7,0xbf2),
        *range(0xc61,0xc65),*range(0xa4b,0xa8f),*range(0xa9f,0xaaf)})
    images=[]
    for index in indices:
        at=0x20bf14+index*10;page=word(0x51854+word(at)*2)-1
        h,w=word(at+4),word(at+6)
        x=word(0x52420+page)+256-byte(at+3)-w;y=word(0x52422+page)+byte(at+2)
        images.append(decode_sprite(pixels,x,y,w,h,0x100))
    cell=max(max(im.size)for im in images)
    sheet=Image.new('RGBA',(cell*16,cell*((len(images)+15)//16)));frames=[]
    for i,(index,im)in enumerate(zip(indices,images)):
        x=i%16*cell+(cell-im.width)//2;y=i//16*cell+(cell-im.height)//2
        sheet.alpha_composite(im,(x,y));frames.append((index,x,y,*im.size))
    output.parent.mkdir(parents=True,exist_ok=True);sheet.save(output)
    lines=['-- 0x13/0x25/0x31/0x34 的全部朝向、出生及消弹图，不从实战轨迹截取弹型。',
        'return {sprites={']+['    [%d]={%d,%d,%d,%d},'%r for r in frames]+['}}']
    data.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('ram','vram','output','data'):p.add_argument(name,type=Path)
    a=p.parse_args();export(a.ram,a.vram,a.output,a.data)
