"""把thanm导出的原始THTX像素无损封装为PNG；仅变更像素格式/容器，不改图像。"""
from pathlib import Path
import argparse
import struct
import zlib

def convert(source,target,width,height,format):
    raw=source.read_bytes()
    if format==1:
        assert len(raw)==width*height*4
        rgba=bytearray(raw)
        rgba[0::4],rgba[2::4]=raw[2::4],raw[0::4]
    elif format==5:
        assert len(raw)==width*height*2
        rgba=bytearray()
        for (pixel,) in struct.iter_unpack('<H',raw):
            rgba.extend(((pixel>>8&15)*17,(pixel>>4&15)*17,(pixel&15)*17,(pixel>>12)*17))
    else: raise ValueError('仅处理A8R8G8B8和A4R4G4B4')
    def chunk(name,data):
        return struct.pack('>I',len(data))+name+data+struct.pack('>I',zlib.crc32(name+data)&0xffffffff)
    stride=width*4
    rows=b''.join(b'\0'+rgba[y*stride:(y+1)*stride] for y in range(height))
    target.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',width,height,8,6,0,0,0))
                       +chunk(b'IDAT',zlib.compress(rows))+chunk(b'IEND',b''))

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path);parser.add_argument('target',type=Path)
    parser.add_argument('--width',type=int,required=True);parser.add_argument('--height',type=int,required=True)
    parser.add_argument('--format',type=int,choices=[1,5],required=True)
    args=parser.parse_args();convert(args.source,args.target,args.width,args.height,args.format)
