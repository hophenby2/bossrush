"""红魔乡原生数据读取；仅供离线展开和回归测试，游戏不载入。"""
from pathlib import Path
import struct
import math
import hashlib

FORMATS={0:'',1:'i',2:'ii',3:'iii',4:'ii',5:'if',6:'ii',7:'iii',8:'if',9:'iff',25:'i4f',26:'i',27:'ii',28:'ff',35:'iif',36:'',43:'fff',44:'fff',45:'ff',46:'f',47:'f',48:'f',49:'ff',50:'ff',51:'ff',65:'4f',66:'',76:'i',77:'i',78:'',79:'',80:'',81:'fff',82:'4i4f',83:'',84:'i',85:'hh6f6i',86:'hh6f6i',87:'i',88:'if',89:'if',90:'ifff',91:'i',92:'i',93:'hh34s',94:'',95:'ifffhhi',96:'',97:'i',98:'6h',99:'ii',100:'i',101:'i',102:'i4f',103:'3f',109:'ii',118:'iii',121:'ii',125:'',129:'ii',131:'ff4i',133:'',134:''}
for start,end,fmt in [(10,12,'i'),(13,17,'iii'),(18,19,'i'),(20,24,'iff'),(29,34,'ii'),(37,42,'iifii'),(52,55,'iff'),(56,60,'ifff'),(61,64,'i'),(67,75,'hhii4fi'),(104,108,'i'),(110,117,'i'),(119,120,'i'),(122,124,'i'),(126,128,'i'),(130,130,'i'),(132,132,'i'),(135,136,'i')]:
    FORMATS.update({op:fmt for op in range(start,end+1)})

class Source:
    def __init__(self,root):
        self.stages={};self.hashes={};self.timeline={};self.timeline_records={}
        for stage in range(1,8):
            data=(Path(root)/f'ecldata{stage}.ecl').read_bytes()
            self.hashes[stage]=hashlib.sha256(data).hexdigest()
            count,=struct.unpack_from('<H',data)
            offsets=struct.unpack_from('<'+'I'*count,data,16)
            subs={}
            for sub,start in enumerate(offsets):
                pos=start;rows=[];end=offsets[sub+1] if sub+1<count else len(data)
                while pos+12<=end:
                    t,op,size=struct.unpack_from('<ihh',data,pos)
                    if t<0 or size<12:break
                    fmt=FORMATS[op]
                    if op==99 and size==16:fmt='2h'
                    assert struct.calcsize('<'+fmt)==size-12,(stage,sub,pos,op,size,fmt)
                    args=list(struct.unpack_from('<'+fmt,data,pos+12))
                    if op==93:args[-1]=args[-1].split(b'\0')[0].decode('cp932')
                    rows.append(dict(t=t,op=op,a=args,pos=pos,size=size,mask=data[pos+9]))
                    pos+=size
                subs[sub]=rows
            self.stages[stage]=subs
            pos=struct.unpack_from('<I',data,4)[0];entries=[];records=[]
            while pos+8<=len(data):
                t,sub,op,size=struct.unpack_from('<4h',data,pos)
                if t<0 or size<8:break
                if op<8:
                    if op%2==0:args=list(struct.unpack_from('<fffhhI',data,pos+8))
                    else:args=[*struct.unpack_from('<fff',data,pos+8),-1,-1,-1]
                    entries.append((t,sub,tuple(args)))
                else:args=list(struct.unpack_from('<'+'i'*((size-8)//4),data,pos+8))
                records.append(dict(t=t,sub=sub,op=op,a=args,pos=pos,size=size))
                pos+=size
            self.timeline[stage]=entries
            self.timeline_records[stage]=records
    def active(self,stage,sub):
        return [r for r in self.stages[stage][sub] if r['mask']&(16 if stage==7 else 8)]

    def scout(self,stage,sub,shot=0,initial_life=1):
        """只执行入场设置，读出实际 L/Ex 分支的阈值；不把其他难度混入卡表。"""
        rows=self.active(stage,sub);lookup={r['pos']:i for i,r in enumerate(rows)}
        v={-10013:4 if stage==7 else 3,-10025:shot,-10024:initial_life}
        def get(x):return v.get(int(x),0) if -10025<=x<=-10001 else x
        out={'life':initial_life,'threshold':0,'timeout':None,'invulnerable':0,'epoch':0,'bounds':None,'bounds_changed':False}
        cmp=0;i=0;first=True;steps=0;damage=True
        while i<len(rows):
            r=rows[i];op,a=r['op'],r['a'];steps+=1
            if steps>5000:break
            if r['t']>0:
                if out['timeout'] is not None and out.get('spell') is None:break
                if out.get('spell') is not None and r['t']>out['epoch']:
                    break
            if op in(4,5):v[a[0]]=get(a[1])
            elif op==27:cmp=get(a[0])-get(a[1])
            elif op==28:cmp=get(a[0])-get(a[1])
            elif op in(2,29,30,31,32,33,34):
                take=op==2 or {29:cmp<0,30:cmp<=0,31:cmp==0,32:cmp>0,33:cmp>=0,34:cmp!=0}.get(op,False)
                if take:
                    target=r['pos']+a[1]
                    i=next(j for j,z in enumerate(rows) if z['pos']>=target)
                    continue
            elif op==65:out['bounds']=tuple(a);out['bounds_changed']=True
            elif op==66:out['bounds']=None;out['bounds_changed']=True
            elif op==93:out.update(spell=a[1],original=a[2],epoch=r['t'])
            elif op==105:damage=bool(a[0])
            elif op==111:out['life']=a[0];v[-10024]=a[0]
            elif op==113:out['threshold']=max(0,a[0])
            elif op==114:out['next']=a[0]
            elif op==115:out['timeout']=a[0]
            elif op in(35,37,38,39,40,41,42) or op==3:break
            i+=1
        return out

# 元素和组合的原作中文卡名；不把只出现在 N/H 的名字加入 L 卡表。
NAMES={0:'月符「月光」',1:'夜符「夜雀」',2:'暗符「境界线」',4:'雹符「冰雹暴风」',5:'冻符「完美冻结」',6:'雪符「钻石风暴」',8:'华符「绚烂华灵」',9:'虹符「彩虹的风铃」',10:'幻符「华想梦葛」',12:'彩符「彩光乱舞」',13:'彩符「极彩台风」',19:'火符「火神之光上级」',20:'木符「风灵角笛上级」',21:'土符「三石塔上级」',22:'火符「火神之光辉」',23:'水符「湖葬」',24:'木符「翠绿风暴」',25:'土符「三石塔的震动」',26:'金符「银龙」',27:'火＆土符「熔岩巨石」',28:'木＆火符「森林大火」',29:'水＆木符「水精灵」',30:'金＆水符「水银之毒」',31:'土＆金符「翡翠巨石」',33:'奇术「迷惑误导」',37:'幻幽「夜雾幻影杀人鬼」',38:'幻世「世界」',39:'女仆秘技「杀人玩偶」',40:'奇术「永恒的温柔」',46:'神罚「年幼的恶魔之王」',47:'狱符「千根针的针山」',48:'神术「吸血鬼幻想」',49:'红符「绯红之主」',50:'「红色的幻想乡」',51:'月符「沉默的月神」',52:'日符「皇家烈焰」',53:'火水木金土符「贤者之石」',54:'禁忌「红莓陷阱」',55:'禁忌「莱瓦汀」',56:'禁忌「四重存在」',57:'禁忌「笼中鸟」',58:'禁忌「恋之迷宫」',59:'禁弹「星弧破碎」',60:'禁弹「折反射」',61:'禁弹「刻着过去的钟表」',62:'秘弹「之后就一个人都没有了吗？」',63:'ＱＥＤ「４９５年的波纹」'}

def catalogue(source):
    cards=[]
    entries={2:(1,8),3:(1,10),4:(2,20),5:(2,21),6:(3,9),7:(3,17),8:(4,21),9:(4,26),15:(4,26),16:(4,26),17:(4,26),10:(5,12),11:(5,21),12:(6,8),1:(6,15),13:(7,16),14:(7,31)}
    entrypoints={group:next(((r['a'][1]-192,224-r['a'][2]) for r in reversed(source.active(st,sub)) if r['op'] in (56,57,58,59,60) and r['t']<=120),(0,128)) for group,(st,sub) in entries.items()}
    bounds={group:next((tuple(r['a']) for r in source.active(st,sub) if r['op']==65),None) for group,(st,sub) in entries.items()}
    hitboxes={group:next((tuple(r['a'][:2]) for r in source.active(st,sub) if r['op']==103),(12,12)) for group,(st,sub) in entries.items()}
    hitboxes[13]=(40,56)
    def add(stage,sub,group,life,threshold=None,label=None,shot=0,order=None):
        meta=source.scout(stage,sub,shot,life)
        if meta['bounds_changed']:bounds[group]=meta['bounds']
        meta['bounds']=bounds[group]
        entry_hitboxes=[tuple(r['a'][:2]) for r in source.active(stage,sub) if r['op']==103 and r['t']==0]
        if entry_hitboxes:hitboxes[group]=entry_hitboxes[-1]
        if threshold is None:threshold=meta['threshold']
        sid=meta.get('spell')
        # 对最后一个带 60 帧前奏的 SC、以及有 CALL 的 Extra 中 Boss，从子程序本身取 SC 数据。
        spells=[r for r in source.active(stage,sub) if r['op']==93]
        if spells:sid=spells[0]['a'][1];meta['epoch']=spells[0]['t']
        name=NAMES[sid] if sid is not None else ''
        timeout=next((r['a'][0] for r in source.active(stage,sub) if r['op']==115 and r['a'][0]>0),meta['timeout'])
        if timeout is None:raise ValueError((stage,sub,meta))
        # Spell 的 HP 是上一阶段回调保留下来的血；非符是 SETLIFE - 下一阶段阈值。
        hp=max(1,(life if sid is not None else meta['life'])-threshold)
        active=source.active(stage,sub);damaged=False;invul=0
        for r in active:
            if r['op']==105:
                if r['a'][0]: invul=max(0,r['t']-meta['epoch']);damaged=True;break
        if not damaged:invul=0
        if sid==62:invul=timeout
        info=dict(stage=stage,sub=sub,group=group,life=life,threshold=threshold,hp=hp,name=name,label=label or name,shot=shot,timeout=timeout,epoch=meta['epoch'],invul=invul,bounds=meta['bounds'],order=order if order is not None else len(cards)+1)
        info['entry_x'],info['entry_y']=entrypoints[group]
        info['hitbox']=hitboxes[group]
        if info['bounds']:
            box=info['bounds'];info['entry_x']=min(box[2]-192,max(box[0]-192,info['entry_x']));info['entry_y']=min(224-box[1],max(224-box[3],info['entry_y']))
        cards.append(info);return info
    add(1,8,2,6000,label='一面中 Boss 非符');add(1,9,2,500)
    add(1,11,3,7000,label='露米娅 非符一');add(1,22,3,900);add(1,16,3,7500,label='露米娅 非符二');add(1,23,3,800)
    add(2,20,4,10000,label='大妖精 非符')
    add(2,22,5,10000,label='琪露诺 非符一');add(2,30,5,1500);add(2,25,5,13000,label='琪露诺 非符二');add(2,31,5,3200,1400);add(2,32,5,1400,0)
    add(3,9,6,13000,label='三面中 Boss 非符');add(3,14,6,1300)
    add(3,18,7,14000,label='红美铃 非符一');add(3,29,7,1900);add(3,20,7,12000,label='红美铃 非符二');add(3,30,7,1400)
    add(3,26,7,16500,label='红美铃 非符三');add(3,32,7,3400,2000);add(3,33,7,2000,0)
    add(4,21,8,7000,label='小恶魔 非符')
    combos=[[55,58,56],[57,58,59],[56,59,55],[59,57,58]]
    for shot,group in enumerate((9,15,16,17)):
        a=source.scout(4,27,shot);b=source.scout(4,37,shot)
        for root,label,meta in [(27,'帕秋莉 非符一',a),(37,'帕秋莉 非符二',b)]:
            add(4,root,group,meta['life'],label=label,shot=shot)
            add(4,meta['next'],group,meta['threshold'],0,shot=shot)
        for sub in combos[shot]:add(4,sub,group,1700,0,shot=shot)
    add(5,13,10,15000,label='五面中 Boss 非符');add(5,18,10,710)
    for root,sub,life,threshold,label in [(22,45,19000,1400,'咲夜 非符一'),(34,47,17000,1400,'咲夜 非符二'),(41,50,16000,1700,'咲夜 非符三')]:
        add(5,root,11,life,threshold,label=label);add(5,sub,11,threshold,0)
    add(6,9,12,6000,1100,label='六面中 Boss 非符');add(6,14,12,1100)
    for i,(root,sub,life,threshold) in enumerate([(17,31,13000,1200),(19,33,15500,1600),(23,35,11000,1600),(26,39,13000,1300)]):
        add(6,root,1,life,threshold,label=f'蕾米莉亚 非符{("一","二","三","四")[i]}',order=i*2+1)
        add(6,sub,1,threshold,0,order=i*2+2)
    add(6,44,1,5300,0,order=9)
    for sub,life in [(22,1800),(23,1450),(24,1100)]:add(7,sub,13,life)
    for i,(root,sub,life,threshold) in enumerate([(32,33,10000,1800),(35,36,8000,1200),(38,39,8000,1900),(43,44,8000,2400),(47,48,10000,1400),(49,50,10000,2200),(53,54,10000,1520),(56,57,10000,1800),(59,60,1000,1000)]):
        add(7,root,14,life,threshold,label=f'芙兰朵露 非符{("一","二","三","四","五","六","七","八","九")[i]}');add(7,sub,14,threshold,0)
    add(7,68,14,6000,0)
    preserved={31:3802,33:3805,35:3808,39:3811,44:369}
    new=3900
    for c in cards:
        if c['stage']==6 and c['sub'] in preserved:c['id']=preserved[c['sub']];c['manual']=True
        else:c['id']=new;new+=1
    return cards


MID_BOSS={1:8,2:20,3:9,4:21,5:12,6:8,7:16}
MAIN_BOSS={1:10,2:21,3:17,4:26,5:21,6:15,7:31}
MID_GROUP={1:2,2:4,3:6,4:8,5:10,6:12,7:13}

def road_catalogue(source):
    """按主时间轴的中 Boss 出生/等待边界拆分；不把 Boss 宿主混入普通敌机。"""
    roads=[]
    for stage in range(1,8):
        rows=source.timeline_records[stage]
        middle=next(r for r in rows if r['op']<8 and r['sub']==MID_BOSS[stage])
        boss=next(r for r in rows if r['op']<8 and r['sub']==MAIN_BOSS[stage])
        gates=[r for r in rows if middle['t']<=r['t']<boss['t'] and r['op']==12]
        # 三、六、Extra 面明确 WAIT_FOR_BOSS；其余轴在中 Boss 期间仍推进并抑制生成。
        frozen=bool(gates)
        base=gates[0]['t'] if frozen else middle['t']
        # 五面先等对话再用 IRQ 启动 Sub13，原生攻击时钟从此帧开始。
        if not frozen:
            interrupts=[r for r in rows if middle['t']<=r['t']<middle['t']+20 and r['op']==10]
            if interrupts:base=interrupts[-1]['t']
        ending=min([boss['t']]+[r['t'] for r in rows if r['op']==8 and r['a']==[] and r['sub']==0 and r['t']>base])
        for part,start,end in [('before',0,middle['t']),('after',base,ending)]:
            spawns=[dict(r) for r in rows if r['op']<8 and start<=r['t']<end and r['sub'] not in (MID_BOSS[stage],MAIN_BOSS[stage])]
            index=(stage-1)*2+(part=='after')
            label=('Extra' if stage==7 else ('一','二','三','四','五','六')[stage-1]+'面')+'道中·'+('前半' if part=='before' else '后半')
            if not spawns:label+='（入场等待）'
            roads.append(dict(id=4000+index,group=18+index,stage=stage,sub='road_'+part,road=True,part=part,
                frozen=frozen,base=start,ending=end,timeout=end-start,epoch=0,invul=end-start,hp=10000000,
                threshold=0,bounds=None,entry_x=0,entry_y=400,hitbox=(0,0),name=label,label=label,
                mid_group=MID_GROUP[stage],spawns=spawns))
    assert len(roads)==14 and sum(len(r['spawns']) for r in roads)==2177
    return roads
