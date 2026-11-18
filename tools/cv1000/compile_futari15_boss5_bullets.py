"""核对第五面八类敌弹的构造输入、定点运动、精灵及真实消弹回调。"""
import argparse
import struct
from collections import defaultdict
from pathlib import Path


def load(prefix):
    fields=[('boardX',20,'i'),('boardY',24,'i'),('boardVX',28,'i'),('boardVY',32,'i'),
        ('speed',36,'h'),('angle',50,'H'),('spriteBase',12,'H'),('phase',11,'b'),
        ('animationClock',40,'b'),('animationInterval',41,'b'),('flip',10,'B'),('trails',43,'b'),('depth',16,'H')]
    motion_fields=[('acceleration',54,'h'),('motionClock',56,'i'),('motionInterval',60,'i'),('speedCap',64,'i')]
    initializers={0xc06ef00,0xc06efd0,0xc06fc10,0xc0710f0,0xc06f6a0,0xc0721b0,0xc070960,0xc06f200}
    operations=defaultdict(list)
    for line in Path(str(prefix)+'.bullet-ops').read_text(encoding='utf-8').splitlines():
        r=list(map(int,line.split()));operations[r[0]].append(r[1:])
    def digest(values):
        n=0
        for value in values:n=(n*131+value)%16777213
        return n
    result_file=Path(str(prefix)+'.bullet-results')
    results=dict(map(int,line.split())for line in result_file.read_text().splitlines())if result_file.exists()else{}
    cases={};previous={};cancelled={};size=68+320
    with Path(str(prefix)+'.bullet-steps').open('rb')as stream:
        while block:=stream.read(size):
            if len(block)!=size:raise ValueError('弹型记录被截断')
            h=struct.unpack_from('>17I',block)
            frame,seq,fn,ptr,identity,kind,x,y,angle,speed,rank,base,flash,mode,flags,depth_flag,camera=h
            shift=ptr%8
            before,after=block[68:228],block[228:]
            def read(raw,at,fmt):return struct.unpack_from('<'+fmt,raw,(at+shift)^{1:7,2:6,4:4}[struct.calcsize(fmt)])[0]
            def signed(n):return(n+2147483648)%4294967296-2147483648
            if mode!=0 or base!=54:raise ValueError('此回归仅支持第五面 Original 基速')
            tag=0 if fn in initializers else 2 if fn==0xc06e6f0 else 1
            if tag==0:
                if identity in cases:raise ValueError('同一弹身份被重复初始化')
                if (read(before,20,'i'),read(before,24,'i'))!=(signed(x)-signed(camera),signed(y)):
                    raise ValueError('首次绘制前的外部坐标输入尚未处理')
                motion=[read(before,54,'h'),read(before,56,'i'),read(before,60,'i')]if read(before,124,'h')else[]
                # +0x92 是原通用构造器保存的深度入参，早于弹型构造回调；不从返回深度反推。
                cases[identity]={'input':[frame,kind,signed(x),signed(y),angle,signed(speed),rank,flash,motion,read(before,146,'h'),signed(camera),base],
                    'steps':[]}
                delta=0
                cancelled[identity]=False
            else:
                if identity not in cases:raise ValueError('缺少弹型构造记录')
                delta=read(before,20,'i')-previous[identity][0]
                if delta not in (-65536,0,65536)or read(before,24,'i')!=previous[identity][1]:
                    raise ValueError('出现非相机的外部位移')
            if fn==0xc06df20:
                if not cancelled[identity]:
                    cases[identity]['steps'].append([frame,4,0,0,0,0,0,[],read(before,42,'b')])
                    cancelled[identity]=True
                if results[seq]==0:tag=3
            elif tag==2:cancelled[identity]=True
            sprites=[];by_pointer={};drops=[]
            for entry,a,b,c,d,result in operations[seq]:
                if entry==0xc063740:
                    row=[a,b,c,d,0,-1];sprites.append(row);by_pointer[result]=row
                elif entry==0xc05e2d8:by_pointer[a][4]=b
                elif entry==0xc05e424:
                    if(b,c)!=(2,1):raise ValueError('出现未处理的混色类型')
                    by_pointer[a][5]=d
                elif entry==0xc093cd0:drops.append([a,b,c,d])
                else:raise ValueError('未知精灵请求')
            values=[read(after,at,fmt)for _,at,fmt in fields]
            active=read(after,124,'h')!=0;values.append(int(active))
            if active:values.extend(read(after,at,fmt)for _,at,fmt in motion_fields)
            cases[identity]['steps'].append([frame,tag,delta,digest(values),
                digest([v for r in sprites for v in r]),len(sprites),flags,drops,read(after,42,'b')])
            previous[identity]=(read(after,20,'i'),read(after,24,'i'))
    if not cases:raise ValueError('没有弹型记录')
    return fields,motion_fields,list(cases.values())


def compile(prefixes,output):
    values=[]
    for prefix in prefixes:
        fields,motion_fields,cases=load(prefix);values.extend(cases)
    def lua(v):
        if isinstance(v,str):return '"'+v+'"'
        if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
        if isinstance(v,dict):return '{'+','.join(k+'='+lua(n)for k,n in v.items())+'}'
        return str(v)
    lines=['-- 原版第五面八类敌弹的独立分配、定点运动、精灵与消弹回调，不加载到游戏。',
        'local cases={}','local function append(rows)for _,r in ipairs(rows)do cases[#cases+1]=r end end']
    for start in range(0,len(values),12):
        lines+=['append((function()return {']+[lua(case)+','for case in values[start:start+12]]+['}end)())']
    lines+=['return {fields='+lua([name for name,_,_ in fields])+',motionFields='+lua([name for name,_,_ in motion_fields])+',cases=cases}']
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    print(len(values),'份原版敌弹及',sum(sum(r[1]!=4 for r in c['steps'])for c in values),'次回调')


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('prefix',type=Path,nargs='+');p.add_argument('output',type=Path)
    a=p.parse_args();compile(a.prefix,a.output)
