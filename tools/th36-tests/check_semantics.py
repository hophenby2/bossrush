"""用独立二进制ECL标量探针对比离线Lua的发弹时刻和完整枪槽，失败即非零退出。"""
from pathlib import Path
import argparse
import copy
import json
import math
import os
import sys
from source import ROOT, active, load, programs
from catalogue import Probe
from run_lua import runtime


def plain(v):
    if hasattr(v,'items'):
        d=dict(v.items())
        if d and set(d)==set(range(1,len(d)+1)):return [plain(d[i]) for i in range(1,len(d)+1)]
        return {str(k):plain(n) for k,n in d.items()}
    return v


def patterns(events):
    guns={i:dict(type=0,color=0,angle=0,step=0,s1=2,s2=0,n=1,layers=1,ox=0,oy=0,dist=0,aim=0,ex={}) for i in range(8)};result=[]
    for frame,sub,op,x in events:
        if op==400:guns[x[0]]=dict(type=0,color=0,angle=0,step=0,s1=2,s2=0,n=1,layers=1,ox=0,oy=0,dist=0,aim=0,ex={})
        elif op in (402,403,404,405,406,407,409,411,435,436,437,438):
            if x[0] not in guns:guns[x[0]]=dict(type=0,color=0,angle=0,step=0,s1=2,s2=0,n=1,layers=1,ox=0,oy=0,dist=0,aim=0,ex={})
            p=guns[x[0]]
            if op==402:p['type'],p['color']=x[1:]
            elif op==403:p['ox'],p['oy']=x[1:]
            elif op==404:p['angle'],p['step']=x[1:]
            elif op==405:p['s1'],p['s2']=x[1:]
            elif op==406:p['n'],p['layers']=x[1:]
            elif op==407:p['aim']=x[1]
            elif op==409:
                p['ex'][str(x[1])]=dict(zip(('allow','kind','i0','i1','f0','f1'),x[2:]));p['ex'][str(x[1])]['kind']%=4294967296
            elif op==411:guns[x[0]]=copy.deepcopy(guns[x[1]])
            elif op==435:p['s1'],p['s2']=x[4],x[8]
            elif op==436:p['n'],p['layers']=x[4],x[8]
            elif op==437:p['ox'],p['oy']=math.cos(x[1])*x[2],math.sin(x[1])*x[2]
            elif op==438:p['dist']=x[1]
        elif op==401:result.append(dict(frame=frame,slot=x[0],gun=copy.deepcopy(guns[x[0]])))
    return result


def compare(a,b,path=''):
    if isinstance(a,dict):
        assert set(a)==set(b),(path,set(a),set(b))
        for k in a:compare(a[k],b[k],path+'/'+str(k))
    elif isinstance(a,list):
        assert len(a)==len(b),(path,len(a),len(b))
        for i,(x,y) in enumerate(zip(a,b)):compare(x,y,path+'/'+str(i))
    elif isinstance(a,(int,float)) and not isinstance(a,bool):assert abs(a-b)<1e-5*max(1,abs(a)),(path,a,b)
    else:assert a==b,(path,a,b)


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('source',type=Path);ap.add_argument('--frames',type=int,default=480);ap.add_argument('--output',type=Path);args=ap.parse_args()
    os.chdir(ROOT);sources=load(args.source);lua=runtime();lua.globals().arg=lua.table_from(['语义核对'])
    setup=(ROOT/'tools/check_stage.lua').read_text('utf-8-sig').split('if path == "--all" then',1)[0]
    lua.execute(setup);lua.execute("dofile('THlib/anm/original.lua');dofile('mod/GAME/th36.lua')")
    lua.execute('''
        H=_editor_class.TH36.runtime
        H.emit_pattern=function() end
        local read=H.read
        H.read=function(a,v,i)
            if i==-10000 then return 123 end
            if i==-9999 or i==-9987 then return .5 end
            if i==-9998 then return .25 end
            if i<0 and i~=-1 and not (i>=-9985 and i<=-9978) and i~=-9954 and i~=-9959 and i~=-9947 then return 0 end
            return read(a,v,i)
        end
        H.on_fire=function(a,i,p)
            local gun={}
            for _,k in ipairs({'type','color','angle','step','s1','s2','n','layers','ox','oy','dist','aim'}) do gun[k]=p[k] end
            gun.ex={};for k,r in pairs(p.ex) do gun.ex[tostring(k)]={allow=r.allow,kind=r.kind,i0=r.i0,i1=r.i1,f0=r.f0,f1=r.f1} end
            observed[#observed+1]={frame=a.session.frame,slot=i,gun=gun}
        end
        H.fire=function(a,i) H.on_fire(a,i,a.guns[i]) end
        function run_leaf(stage,name,n)
            observed={};player.x,player.y=0,224
            local host={x=0,y=96,hp=10000000,maxhp=10000000,_live=true}
            local s=H.session(host,stage,name)
            for f=0,n-1 do s.frame=f;H.update(s.root) end
            return observed
        end
    ''')
    checked=[]
    for stage in range(1,8):
        pp=programs(sources,stage)
        for name,(_,rows) in pp.items():
            ops={r.op for r in active(rows,stage)}
            if 401 not in ops or ops&{11,15,16,256,257,260,261,265,266,267,268,334,443,444,445,449}:continue
            probe=Probe(pp,stage,10000000).run(name,args.frames)
            expected=patterns(probe.events)
            if not expected:continue
            actual=plain(lua.globals().run_leaf(stage,name,args.frames))
            if actual=={}:actual=[]
            try:compare(expected,actual)
            except AssertionError as e:raise AssertionError((stage,name,*e.args))
            checked.append(dict(stage=stage,sub=name,shots=len(expected)))
    # 随机数另验原版Random.cpp，不能只证明相同桩下的控制流一致。
    rng=lua.table_from(dict(random_seed=12345,random_calls=0));seed=12345
    for _ in range(1000):
        high=((seed^0x9630)-0x6553)&65535;seed=((high>>14)+(high<<2))&65535
        low=((seed^0x9630)-0x6553)&65535;seed=((low>>14)+(low<<2))&65535
        assert lua.globals().H.random32(rng)==high*65536+low
    result=dict(checked=len(checked),shots=sum(r['shots'] for r in checked),frames=args.frames,rng_values=1000,cases=checked,
                scope='独立标量控制流与枪槽对照；不宣称运动、渲染、碰撞全量一致')
    if args.output:args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(json.dumps({k:v for k,v in result.items() if k!='cases'},ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
