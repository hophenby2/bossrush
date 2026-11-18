"""从原版工作 RAM / 显存导出第一面 0x31 / 0x32 / 地面敌机、尾气、P 道具及拾取文字。"""
import argparse
import re
from hashlib import blake2b
from pathlib import Path

import numpy as np
from PIL import Image, ImageOps

from analyze import decode_sprite


def export(ram, vram, output, mode, data, sampled_stage=None):
    memory = ram.read_bytes()
    if len(memory) != 0x800000:
        raise ValueError('工作 RAM 必须是 8 MiB')
    pixels = np.memmap(vram, dtype='<u4', mode='r', shape=(4096, 8192))

    def byte(a):
        return memory[a ^ 7]

    def word(a):
        return byte(a)*256+byte(a+1)

    def signed(a):
        n = byte(a)
        return n-256 if n >= 128 else n

    def long(a):
        return word(a)*65536+word(a+2)

    def sprite(index):
        record = 0x20BF14+index*10
        page = word(0x51854+2*word(record))-1
        h,w = word(record+4),word(record+6)
        x = word(0x52420+page)+256-byte(record+3)-w
        y = word(0x52422+page)+byte(record+2)
        return decode_sprite(pixels, x, y, w, h, 0x100)

    if mode == 'exhaust':
        indices = [*range(0x1394,0x13A4),*range(0x174,0x18E),*range(0x1344,0x1354),0x199,
                   *range(0x1354,0x1364),*range(0x18E,0x197)]
        cell,columns = 64,8
    elif mode == 'skimmer':
        indices = list(range(0x2823,0x2845))
        cell,columns = 96,8
    elif mode == 'groundbug':
        indices = [*range(0x2899,0x2901),0x3DB1,*range(0x33B,0x34B),0x19D,*range(0x13C4,0x13C8)]
        cell,columns = 128,8
    elif mode == 'worm-death':
        indices = [*range(0x36B,0x37B),0x193,*range(0x13C4,0x13CC)]
        cell,columns = 128,8
    elif mode == 'longfly':
        indices = list(range(0x2845,0x2899))
        cell,columns = 128,8
    else:
        indices = [*range(0x37B,0x37F),0x37F,0x38F,*range(0xF6B,0xF83),*range(0xF0B,0xF23),*range(0x90,0x9A)]
        cell,columns = 128,8
    sheet = Image.new('RGBA',(cell*columns,cell*((len(indices)+columns-1)//columns)))
    for i,index in enumerate(indices):
        art = sprite(index)
        if art.width > cell or art.height > cell:
            raise ValueError(f'裁片 {index:x} 超过 {cell} 像素单元')
        sheet.alpha_composite(art,(i%columns*cell+(cell-art.width)//2,i//columns*cell+(cell-art.height)//2))
    sheet.save(output)
    if data:
        if mode == 'worm-death':
            rows=['-- 0x0c0ace50 的五段击破演出；保留原表的定点坐标、等待、标志和碎片条数。','return {']
            for name,address,count,stride in [('first',0x2DBE3C,9,40),('second',0x2DBFA4,5,40),
                                               ('last',0x2DC06C,22,40),('smoke',0x2DC3DC,11,36),
                                               ('odd',0x2DC568,8,8),('even',0x2DC5A8,8,8)]:
                rows.append('    '+name+'={')
                for i in range(count):
                    rows.append('        {'+','.join(str(long(address+i*stride+j)) for j in range(0,stride,4))+'},')
                rows.append('    },')
            rows.append('    points={'+','.join(f'{{{signed(0x2DC5E8+i*2)},{signed(0x2DC5E9+i*2)}}}' for i in range(16))+'},')
            rows.append('}')
            data.write_text('\n'.join(rows)+'\n',encoding='utf-8')
            return
        if mode == 'groundbug':
            rows=['-- 0x0c0a6f00 的三组地面敌机程序，及 0x0c1d6580 的第二、三层变速指令。','return {',
                  '    phases={344,0,256,256,0,300,256,256,432,0},','    programs={']
            for address in (0x1EEF04,0x1EEE88,0x1EF13C):
                program=[]
                while long(address)!=0xFFFFFFFF:
                    value=long(address)
                    program.append(f'{{{value>>25},{value>>16&511},{value&65535}}}')
                    address+=4
                rows.append('        {'+','.join(program)+'},')
            rows+=['    },','    spawns={']
            programs={32:1,29:2,52:3}
            for address in range(0x1EDE00,0x1EE9C4,12):
                kind=word(address+2)
                if kind not in (0x42,0x43,0x44):continue
                if word(address+6)!=0x0300:raise ValueError('地面敌机的层号或条件发生变化')
                values=(word(address),word(address+10)-40,word(address+8),programs[word(address+4)],kind)
                rows.append('        {'+','.join(map(str,values))+'},')
            rows+=['    },','    scroll={']
            scroll={}
            for i in range(117):
                address=0x1D6580+i*40
                if long(address+4)==14 and long(address+8) in (2,3):
                    scroll.setdefault(long(address),{})[long(address+8)]=long(address+16)
            speeds={2:56,3:56}
            for position,changes in sorted(scroll.items()):
                speeds.update(changes)
                rows.append(f'        {{{position},{speeds[2]},{speeds[3]}}},')
            rows+=['    },','    death={']
            for i in range(11):
                rows.append('        {'+','.join(str(long(0x2DB90C+i*40+j)) for j in range(0,40,4))+'},')
            rows.append('    },')
            if sampled_stage: rows.extend(sampled_matches(sampled_stage,[sprite(i) for i in indices[:105]]))
            rows.append('}')
            data.write_text('\n'.join(rows)+'\n',encoding='utf-8')
            return
        if mode == 'longfly':
            rows=['-- 0x0c0aa910 的振动初值和两组原版移动程序。','return {',
                  '    phases={432,300,344,388,256,432,388,344,300,300,344,388,432,432,344,388,300,0},',
                  '    programs={']
            for address in (0x1EEC28,0x1EF14C):
                program=[]
                while long(address)!=0xFFFFFFFF:
                    value=long(address)
                    program.append(f'{{{value>>25},{value>>16&511},{value&65535}}}')
                    address+=4
                rows.append('        {'+','.join(program)+'},')
            rows.append('    },')
            if sampled_stage: rows.extend(sampled_matches(sampled_stage,[sprite(i) for i in indices]))
            rows.append('}')
            data.write_text('\n'.join(rows)+'\n',encoding='utf-8')
            return
        if mode == 'skimmer':
            rows=['-- 第一面 0x31 的原版振翅、附肢、绘制锚点和移动指令。','return {']
            for name,table,count in [('wing',0x2DBAE4,10),('leg',0x2DBAD4,14)]:
                rows.append('    '+name+'={'+','.join(str(byte(table+i)) for i in range(count))+'},')
            for name,table,count in [('wingAnchor',0x2DBAEE,6),('legAnchor',0x2DBAFA,8)]:
                rows.append('    '+name+'={'+','.join(f'{{{signed(table+i*2)},{signed(table+i*2+1)}}}' for i in range(count))+'},')
            program=[]
            address=0x1EEA2C
            while long(address)!=0xFFFFFFFF:
                value=long(address)
                program.append(f'{{{value>>25},{value>>16&511},{value&65535}}}')
                address+=4
            rows.append('    program={'+','.join(program)+'},')
            if sampled_stage:
                rows.extend(sampled_matches(sampled_stage,[sprite(i) for i in indices]))
            rows.append('}')
            data.write_text('\n'.join(rows)+'\n',encoding='utf-8')
            return
        if mode != 'power':
            raise ValueError('只有 P 道具需要额外动画数据')
        rows = ['-- 0x0c0935f0 的两层拾取文字：画格、锚点均来自原版。','return {']
        for name,table in [('phase',0x28BC7C),('subphase',0x28BCB4)]:
            rows.append('    '+name+'={'+','.join(str(byte(table+i)) for i in range(53))+'},')
        for name,table in [('main',0x28BB8C),('sub',0x28BC4C)]:
            rows.append('    '+name+'={'+','.join(f'{{{signed(table+i*2)},{signed(table+i*2+1)}}}' for i in range(24))+'},')
        rows.append('}')
        data.write_text('\n'.join(rows)+'\n',encoding='utf-8')


def sampled_matches(stage, images):
    # 保留透明掩码，忽略混色带来的 alpha 值；越页拆片必须逐像素验证，不能按尺寸猜归属。
    def normalize(art):
        box=art.getchannel('A').getbbox()
        if not box:
            return None
        rgba=np.array(art.crop(box))
        clear=rgba[:,:,3]==0
        rgba[clear]=0
        rgba[:,:,3]=np.where(clear,0,255)
        return rgba
    def fingerprint(rgba):
        return rgba.shape,blake2b(rgba.tobytes(),digest_size=16).digest()
    native=[]
    for art in images:
        for image in (art,ImageOps.mirror(art),ImageOps.flip(art),ImageOps.mirror(ImageOps.flip(art))):
            rgba=normalize(image)
            if rgba is not None:
                native.append(rgba)
    hashes={fingerprint(a) for a in native}
    def matches(art):
        query=normalize(art)
        if query is None:
            return False
        if fingerprint(query) in hashes:
            return True
        solid=query[:,:,3]!=0
        small=np.count_nonzero(solid)<12
        ay,ax=np.argwhere(solid)[0]
        h,w=query.shape[:2]
        for source in native:
            if h>source.shape[0] or w>source.shape[1]:
                continue
            for py,px in np.argwhere(np.all(source==query[ay,ax],axis=2)):
                left,top=int(px-ax),int(py-ay)
                if left>=0 and top>=0 and left+w<=source.shape[1] and top+h<=source.shape[0]:
                    if np.array_equal(source[top:top+h,left:left+w],query):
                        return 2 if small else 1
        return False
    source=stage.read_text(encoding='utf-8')
    directory=stage.resolve().parents[3]/'Resources'/stage.parent.name/stage.stem
    result=['    sampled={']
    for name in ('sprites','tiles'):
        table=source.split(name+'={')[1].split('\n  },')[0]
        pages,matched,partial={ },[],[]
        for index,row in enumerate(re.findall(r'\{(\d+),(\d+),(\d+),(\d+),(\d+)\}',table),1):
            page,x,y,w,h=map(int,row)
            if page not in pages:
                pages[page]=Image.open(directory/f'{name}{page}.png').convert('RGBA')
            found=matches(pages[page].crop((x,y,x+w,y+h)))
            if found:
                (partial if found==2 else matched).append(f'{{{index},{w},{h}}}')
        result.append('        '+name+'={'+','.join(matched)+'},')
        if name=='sprites':
            # 少于 12 个实心像素的拆片只能辅助确认已命中完整裁片的同一个旧对象。
            result.append('        partialSprites={'+','.join(partial)+'},')
    result.append('    },')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('ram',type=Path)
    parser.add_argument('vram',type=Path)
    parser.add_argument('output',type=Path)
    parser.add_argument('--mode',choices=('exhaust','power','skimmer','longfly','groundbug','worm-death'),required=True)
    parser.add_argument('--data',type=Path)
    parser.add_argument('--sampled-stage',type=Path)
    args = parser.parse_args()
    if args.sampled_stage and (args.mode not in ('skimmer','longfly','groundbug') or not args.data):
        parser.error('--sampled-stage 需要同时指定 --mode skimmer / longfly / groundbug 和 --data')
    export(args.ram,args.vram,args.output,args.mode,args.data,args.sampled_stage)
