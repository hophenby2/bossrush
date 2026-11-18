"""导出第五面关底八类敌弹的全部朝向、出生和消弹裁片。"""
import argparse
import sys
from pathlib import Path

sys.dont_write_bytecode=True
from export_futari15_boss1_bullets import export

# 原构造入口写入的图号、拍数、动画间隔、朝向及出生闪光的深度增量。
BANKS={18:(0x8f7,4,1,True,1),19:(0x93b,4,1,True,1),
       21:(0xca1,6,1,False,0),37:(0xde3,4,1,True,0),
       46:(0xc61,4,1,False,0),51:(0xf07,4,1,False,0),
       58:(0xeaf,4,1,True,0),59:(0xc47,4,1,False,0)}


def main(ram,vram,output,data):
    indices=set(range(0xa4b,0xa8f))|set(range(0xa9f,0xaaf))
    for base,_,_,oriented,_ in BANKS.values():
        indices.update(range(base,base+(68 if oriented else 4)))
    export(ram,vram,output,data,indices)
    text=data.read_text(encoding='utf-8').replace(
        '-- 0x13/0x25/0x31/0x34 的全部朝向、出生及消弹图，不从实战轨迹截取弹型。',
        '-- 第五面关底八类弹的全部朝向、出生及消弹图；六拍偏移来自 0x0c285170。')
    banks=','.join('[%d]={%d,%d,%d,%s,%d}'%(k,*v[:3],str(v[3]).lower(),v[4])for k,v in BANKS.items())
    text=text.replace('return {sprites={','return {banks={'+banks+'},animationOffsets={0,1,2,3,2,1},sprites={')
    data.write_bytes(text.encode('utf-8'))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    for name in ('ram','vram','output','data'):parser.add_argument(name,type=Path)
    args=parser.parse_args();main(args.ram,args.vram,args.output,args.data)
