"""整理 0xa2 子敌机的独立构造、更新与绘图探针，保留完整自然寿命。"""
import argparse
import struct
from collections import defaultdict
from pathlib import Path


def compile(prefix,output):
    fields={'boardX':4,'boardY':8,'randomSpeed':12,'protection':16,'randomAngle':24,
        'speed':68,'angle':76,'animationClock':96,'animationInterval':100,'animation':104,
        'turnWait':140,'turnInterval':144}
    operations=defaultdict(list)
    for line in Path(str(prefix)+'.child-ops').read_text(encoding='utf-8').splitlines():
        r=list(map(int,line.split()));operations[r[0]].append(r[1:])
    read=lambda raw,at:struct.unpack_from('<i',raw,at^4)[0]
    steps=[];size=36+320+48;instances=0
    with Path(str(prefix)+'.child-steps').open('rb')as stream:
        while r:=stream.read(size):
            if len(r)!=size:raise ValueError('子敌机记录被截断')
            frame,seq,kind,root,handle,body,active,x,y=struct.unpack_from('>9I',r)
            before,after,config=r[36:196],r[196:356],r[356:]
            ops=operations[seq]
            randoms=[[a[1],a[-1]]for a in ops if a[0]==0xc0631f0]
            requests=[[a[1],a[2],a[3],a[4]]for a in ops if a[0]==0xc063740]
            delta=[a[-1]for a in ops if a[0]==0xc076030]
            bomb=[a[-1]for a in ops if a[0]==0xc068c80]
            # 旧探针只保存根槽 active；c075a90 延后回收，用独立可视检查的退出分支校正。
            # 新探针已保存 +112 待回收标记，二者应相同。
            visible=[a[-1]for a in ops if a[0]==0xc076780]
            if kind==1 and visible and visible[0]==0:active=0
            expected={key:read(after,at)for key,at in fields.items()}if active else{}
            inputs=[read(config,16),read(config,20),struct.unpack_from('<h',config,26^6)[0]]if kind==0 else[]
            if kind==0:instances+=1
            steps.append([frame,kind,handle,bool(active),[(v+2147483648)%4294967296-2147483648 for v in (x,y)],
                inputs,randoms,delta[0]if delta else 0,bool(bomb[0])if bomb else False,expected,requests])
    def lua(v):
        if isinstance(v,bool):return str(v).lower()
        if isinstance(v,dict):return '{'+','.join(k+'='+lua(n)for k,n in v.items())+'}'
        if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
        return str(v)
    if not instances:raise ValueError('没有子敌机构造记录')
    output.write_bytes(('\n'.join(['-- 原版 0xa2 的独立入口/返回与绘制请求，不加载到游戏。',
        f'return {{instances={instances},steps={{']+['    '+lua(r)+','for r in steps]+['}}'])+'\n').encode('utf-8'))


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('prefix',type=Path);p.add_argument('output',type=Path)
    args=p.parse_args();compile(args.prefix,args.output)
