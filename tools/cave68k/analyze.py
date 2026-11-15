"""检查 Atlus Cave 离线采样中的精灵表。"""
import argparse
from collections import Counter
from pathlib import Path
import struct


def frames(path, zoom):
    header = 4+2+0x80
    row_size = header+0x10000+0x4000+0x10000+3*6+(0x18000 if zoom else 0x14000)
    with path.open('rb') as stream:
        if stream.read(4)!=b'CV68':
            raise ValueError(f'{path} 的采样标识错误')
        while row:=stream.read(row_size):
            if len(row)!=row_size:
                raise ValueError(f'{path} 的末帧不完整')
            frame,bank=struct.unpack_from('>IH',row)
            registers=struct.unpack_from('>64H',row,6)
            objects=memoryview(row)[header+0x10000:header+0x14000]
            yield frame,bank,registers,struct.iter_unpack('>8H',objects)


def sprites(records, registers, zoom):
    fractional=bool(registers[5]&0x3000)
    for slot,row in enumerate(records):
        if zoom:
            x,y,attr,code,zx,zy,size,_=row
        else:
            attr,code,x,y,size,*_=row
            zx=zy=256
        width,height=(size>>8&31)*16,(size&31)*16
        if not width or not height:
            continue
        code+=(attr&3)<<16
        w,h=max(1,width*zx//256),max(1,height*zy//256)
        if zoom and fractional:
            x,y=x<<2,y<<2
            if w==1: x-=128
            if h==1: y-=128
            if attr&8 and zx!=256: x+=(width<<8)-width*zx-128
            if attr&4 and zy!=256: y+=(height<<8)-height*zy-128
            x,y=x>>8,y>>8
        else:
            x,y=x&1023,y&1023
            if zoom and w==1: x-=1
            if zoom and h==1: y-=1
            if attr&8 and zx!=256: x+=width-w
            if attr&4 and zy!=256: y+=height-h
        if x>511: x-=1024
        if y>511: y-=1024
        if registers[0]&0x8000: x=320-x-w
        if registers[1]&0x8000: y=240-y-h
        if x+w>0 and y+h>0 and x<320 and y<240:
            yield slot,code,x,y,w,h,(attr>>8)&63,(attr>>4)&3


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('trace',type=Path)
    parser.add_argument('game',choices=('ddonpach','guwange'))
    parser.add_argument('--frame',required=True,type=int)
    args=parser.parse_args()
    zoom=args.game=='guwange'
    for frame,bank,registers,records in frames(args.trace,zoom):
        if frame==args.frame:
            objects=list(sprites(records,registers,zoom))
            sizes=Counter(row[4:6] for row in objects)
            print(f'{frame} 帧，精灵库 {bank}，画面候选 {len(objects)} 个，常见尺寸 {sizes.most_common(8)}')
            return
    parser.error(f'采样没有第 {args.frame} 帧')


if __name__=='__main__':
    main()
