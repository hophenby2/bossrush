"""用独立的原始ECL标量探针读取血量、阶段阈值、时限及符卡编号。"""
from pathlib import Path
import argparse
import json
import math
import re
import sys
from source import ROOT, Variable, active, load, programs, f32
from expand import lit

# 显示名采用中文；编号来自原作的spell指令，不按日文名称猜测难度。
NAMES={1:'怪奇「钓瓶落之怪」',5:'蜘蛛「石窟中的蜘蛛巢」',9:'瘴气「原因不明的热病」',
13:'妒符「看不见的绿眼怪兽」',17:'嫉妒「丑时参拜第七日」',21:'舌切雀「大葛笼与小葛笼」',25:'恨符「丑时参拜」',
29:'鬼符「怪力乱神」',33:'怪轮「地狱之苦轮」',37:'枷符「咎人之枷」',41:'四天王奥义「三步必杀」',45:'脑符「恐怖的催眠术」',
49:'回忆「二重黑死蝶」',53:'回忆「飞行虫之巢」',57:'回忆「波与粒的境界」',
61:'回忆「风神木叶隐身术」',65:'回忆「天狗巨暴流」',69:'回忆「鸟居旋风」',
73:'回忆「延展手臂」',77:'回忆「抱头蹲防」',81:'回忆「大江山岚」',
85:'回忆「春之京人偶」',89:'回忆「稻草人偶神风」',93:'回忆「回归虚无」',
97:'回忆「水银之海」',101:'回忆「公主天狐」',105:'回忆「红色巨石」',
109:'回忆「非定向光束」',113:'回忆「贤者之石」',117:'回忆「闪耀的水底创伤」',
121:'猫符「怨灵猫乱步」',125:'咒精「怨灵凭依妖精」',129:'丧志「食人怨灵」',133:'赎罪「古时之针与痛楚的怨灵」',137:'「死灰复燃」',141:'妖怪「火焰的车轮」',
145:'核热「核反应失控」',149:'爆符「千兆耀斑」',153:'炽击「地狱的人工太阳」',157:'「地狱极乐熔毁」',161:'「地底太阳」',
162:'秘法「九字切」',163:'奇迹「神秘果」',164:'神德「五谷丰登米之浴」',165:'表象「列祖列宗在梦中」',
166:'表象「弹幕偏执症」',167:'本能「本我的解放」',168:'抑制「超我」',169:'反应「妖怪测谎机」',170:'潜意识「弹幕的墨迹测验」',
171:'复燃「恋爱的埋火」',172:'深层「潜意识的基因」',173:'「被厌恶者的哲学」',174:'「地底的蔷薇」'}
ROUTES=('00A','00B','00C','01A','01B','01C')
ROUTE_NAMES=('灵梦／紫','灵梦／萃香','灵梦／文','魔理沙／爱丽丝','魔理沙／帕秋莉','魔理沙／荷取')
ROLES={1:('黑谷山女','Yamame',1),2:('水桥帕露西','Parsee',1),3:('星熊勇仪','Yugi',0),4:('古明地觉','Satori',0),5:('火焰猫燐','Rin',0),6:('灵乌路空','Utsuho',0),7:('古明地恋','Koishi',0)}
MID_ROLES={1:('琪斯美','Kisume',0),2:('水桥帕露西','Parsee',0),3:('星熊勇仪','Yugi',0),4:('火焰猫燐','Rin',6),5:('火焰猫燐','Rin',0),6:('火焰猫燐','Rin',6),7:('东风谷早苗','Sanae',0)}


class Probe:
    """只执行标量与控制流；发弹/生成对象记事件，不借用移植版的任何Lua函数。"""
    def __init__(self, pp, stage, hp=10000, shot=0):
        self.pp,self.stage,self.hp,self.shot=pp,stage,hp,shot
        self.vars={};self.interrupts={};self.spell=None;self.invul=0;self.frame=0;self.events=[]

    def read(self,x,l,s):
        if not isinstance(x,Variable):return x[1:-1] if isinstance(x,str) and x.startswith('"') else x
        i=x.index
        if i>=0:return l.get(i,0)
        if i==-1:return s.pop()
        if i==-9959:return 4 if self.stage==7 else 3
        if i==-9954:return self.hp
        if i==-9945:return self.shot
        if i==-9947:return 1
        if i in (-9999,-9987):return .5
        if i==-9998:return .25
        if i==-10000:return 123
        return self.vars.get(i,0)

    def run(self,sub,frames=360):
        src,rows=self.pp[sub];labels=src.labels
        lookup={r.address:i for i,r in enumerate(rows)}
        stack=[{'sub':sub,'rows':rows,'lookup':lookup,'pc':0,'time':0,'l':{},'s':[]}]
        steps=0
        for frame in range(frames):
            self.frame=frame
            while stack:
                v=stack[-1];rows=v['rows']
                if v['pc']>=len(rows):stack.pop();continue
                r=rows[v['pc']]
                if r.time>v['time']:break
                v['pc']+=1
                if not r.mask&(16 if self.stage==7 else 8):continue
                steps+=1;assert steps<300000,(sub,frame)
                x=r.args;op=r.op;l,s=v['l'],v['s']
                get=lambda z:self.read(z,l,s)
                def put(dst,n):
                    if dst.index>=0:l[dst.index]=n
                    else:self.vars[dst.index]=n
                if op in (0,40):pass
                elif op in (1,10):
                    stack.pop()
                    if not stack:return self
                elif op in (42,44):s.append(get(x[0]))
                elif op in (43,45):put(x[0],f32(s.pop()) if op==45 else int(s.pop()))
                elif op in (11,):
                    name=get(x[0]);params=[get(z) for z in x[1:]];cs,cr=self.pp[name]
                    stack.append({'sub':name,'rows':cr,'lookup':{z.address:i for i,z in enumerate(cr)},'pc':0,'time':0,'l':{i*4:n for i,n in enumerate(params)},'s':[]})
                elif op in (12,13,14):
                    condition=True if op==12 else s.pop()==0 if op==13 else s.pop()!=0
                    if condition:v['pc']=v['lookup'][self.pp[v['sub']][0].labels[x[0]]];v['time']=x[1]
                elif op in (50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,73):
                    b,a=s.pop(),s.pop()
                    n= a+b if op in (50,51) else a-b if op in (52,53) else a*b if op in (54,55) else a/b if op in (56,57) else math.fmod(a,b) if op==58 else int(a==b) if op in (59,60) else int(a!=b) if op in (61,62) else int(a<b) if op in (63,64) else int(a<=b) if op in (65,66) else int(a>b) if op in (67,68) else int(a>=b) if op in (69,70) else int(bool(a or b))
                    s.append(f32(n) if op in (51,53,55,57) else int(n))
                elif op==78:n=get(x[0]);s.append(n);put(x[0],n-1)
                elif op==81:
                    angle,radius=get(x[2]),get(x[3]);put(x[0],f32(math.cos(angle)*radius));put(x[1],f32(math.sin(angle)*radius))
                elif op==82:
                    n=f32(get(x[0]));pi=f32(math.pi);tau=f32(pi*2)
                    while n>pi:n=f32(n-tau)
                    while n< -pi:n=f32(n+tau)
                    put(x[0],n)
                elif op==85:s.append(-s.pop())
                elif op in (83,368):v['time']-=get(x[0] if op==83 else x[3])
                elif op in (355,356):put(x[0],get(x[4]))
                else:
                    args=[get(z) for z in x]
                    self.events.append((frame,v['sub'],op,args))
                    if op==331:self.hp=args[0]
                    elif op==334:self.interrupts[args[0]]={'threshold':args[1],'timeout':args[2],'next':args[3]}
                    elif op==335:self.invul=args[0]
                    elif op in (342,357,358,359):
                        number=args[0]+(0 if op==342 else (4 if self.stage==7 else 3) if op==357 else 2 if op==358 else 1)
                        self.spell=(number,args[1],args[3])
            if not stack:return self
            stack[-1]['time']+=1
        return self


def catalogue(sources):
    result=[];next_id=11000
    for stage in range(1,8):
        pp=programs(sources,stage)
        reachable={'main'};pending=['main']
        while pending:
            sub=pending.pop()
            for r in active(pp[sub][1],stage):
                if r.op not in (11,15,16,256,257,260,261,265,266,267,268,334,341):continue
                target=r.args[3] if r.op==334 else r.args[1] if r.op==341 else r.args[0]
                target=target.strip('"')
                if not target:continue
                if target not in reachable:
                    assert target in pp,('缺失原作子程序',stage,target)
                    reachable.add(target);pending.append(target)
        phase_pattern=r'(?:Boss\d+|BossCard\d+(?:_\d\d[A-C])?|MBoss(?:\d+)?|MBossCard\d+)'
        candidates={n for n,(_,rows) in pp.items() if n in reachable and re.fullmatch(phase_pattern,n) and any(r.op==334 for r in active(rows,stage))}
        candidates.update(r.args[3].strip('"') for n,(_,rows) in pp.items() if n in reachable for r in active(rows,stage) if r.op==334 and re.fullmatch(phase_pattern,r.args[3].strip('"')))
        incoming={}
        for n,(_,rows) in pp.items():
            for r in active(rows,stage):
                if r.op==334:incoming[r.args[3].strip('"')]=r.args[1]
        root_hp={}
        for mid in (False,True):
            root='MBoss' if mid else 'Boss'
            if root not in pp:continue
            hp=next((r.args[0] for r in active(pp[root][1],stage) if r.op==331),10000)
            root_hp[mid]=hp
        def order(n):
            mid=n.startswith('MBoss');m=re.search(r'(?:Boss|Card)(\d+)',n);i=int(m[1]) if m else 0
            return (not mid,i*2+(1 if 'Card' in n else 0),n)
        for sub in sorted(candidates,key=order):
            mid=sub.startswith('MBoss');route=next((i for i,r in enumerate(ROUTES) if sub.endswith('_'+r)),None)
            shot=route if route is not None else 0
            base=incoming.get(sub,root_hp.get(mid,10000))
            if base<=0:base=root_hp.get(mid,10000)
            p=Probe(pp,stage,base,shot)
            if mid and sub!='MBoss':
                rp=Probe(pp,stage,root_hp.get(True,10000),shot).run('MBoss',120)
                p.interrupts={i:dict(it) for i,it in rp.interrupts.items() if i>0}
            p.run(sub)
            slots=[it for _,it in sorted(p.interrupts.items()) if it['threshold']>=0]
            if not slots:continue
            it=slots[0];threshold=it['threshold'];hp=p.hp
            if hp<=threshold:hp=root_hp.get(mid,10000)
            number=p.spell[0] if p.spell else None
            role=MID_ROLES[stage] if mid else ROLES[stage]
            label=NAMES.get(number,'') if number is not None else ''
            if number is not None:assert label,('缺少中文卡名',stage,sub,number)
            timeout=next((q['timeout'] for q in slots if q['timeout']>0),3600)+max((f for f,_,op,_ in p.events if op in (342,357,358,359,333)),default=0)
            row=dict(stage=stage,sub=sub,mid=mid,shot=shot,route=ROUTE_NAMES[route] if route is not None else '',
                total_hp=hp,threshold=threshold,hp=hp-threshold,timeout=timeout,invul=p.invul,
                spell=number,name=label,role=role[0],image=role[1],sprite=role[2],x=0,y=128,id=next_id)
            result.append(row);next_id+=1
    return result


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('source',type=Path);args=ap.parse_args()
    rows=catalogue(load(args.source))
    path=ROOT/'mod/GAME/th36/catalogue.lua'
    path.write_text('-- 阶段元数据来自独立原始ECL探针；不把同一Boss的总血量重复分给每张卡。\nreturn '+lit(rows)+'\n','utf-8',newline='\n')
    print(json.dumps({'phases':len(rows),'spells':sum(r['spell'] is not None for r in rows),'by_stage':{i:len([r for r in rows if r['stage']==i]) for i in range(1,8)}},ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
