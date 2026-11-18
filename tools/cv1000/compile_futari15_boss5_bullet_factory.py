"""保存原版队列配置与分配器收到的独立角度、速度和成功/失败结果。"""
import argparse
from pathlib import Path


def compile(prefix,output):
    cases=[];pending=None
    for line in Path(str(prefix)+'.bullet-factories').read_text().splitlines():
        tag,*values=line.split();values=list(map(int,values))
        if tag=='J':
            assert pending is None,'队列请求未结束'
            frame,identity,*config=values
            assert len(config)==15 and config[9:13]==[1,0,1,0],config
            assert config[14]==64,'非 Original 的活动上限'
            pending=[identity,frame,config,[]]
        elif tag=='A':
            identity,*args=values
            assert pending and identity==pending[0]and len(args)==7
            pending[3].append(args)
        elif tag=='E':
            assert pending and values==[pending[0]]
            cases.append(pending[1:]);pending=None
        else:raise ValueError('未知队列记录')
    assert pending is None and cases,'队列记录不完整'
    def lua(value):return '{'+','.join(map(lua,value))+'}'if isinstance(value,list)else str(value)
    lines=['-- 原版队列输入及独立分配结果；只供回归工具使用。','return {']
    lines.extend(lua(case)+','for case in cases);lines.append('}')
    output.write_bytes(('\n'.join(lines)+'\n').encode('utf-8'))
    print(len(cases),'份原版出膛队列',sum(len(c[2])for c in cases),'次分配')


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix',type=Path);parser.add_argument('output',type=Path)
    args=parser.parse_args();compile(args.prefix,args.output)
