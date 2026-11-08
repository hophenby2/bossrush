"""从TH11的SHT、ANM和二进制ECL生成活跃TTK中位数血量；不改原始ECL元数据。

沿用既有持续全命中口径，忽略飞行、走位和脱靶，保留15帧射击时钟、
256发弹池、穿透弹残余伤害、ANM寿命及逐帧两段软上限。不是移动Boss实测TTK。
"""
from pathlib import Path
import argparse
import hashlib
import json
import math
import re
import statistics
import struct
import subprocess
import sys
from catalogue import catalogue
from source import ROOT, load
from expand import lit

TARGET_DPS=115.5
CYCLE=30000
NAMES=('灵梦／紫','灵梦／萃香','灵梦／文','魔理沙／爱丽丝','魔理沙／帕秋莉','魔理沙／荷取')


def descriptors(path, multiplier=0):
    data=path.read_bytes()
    power=struct.unpack_from('<i',data,0x20)[0]
    # 帕秋莉的focus不换表，由切换键选择五种元素；默认multiplier=0。
    level=power+(power+1)*multiplier if path.stem=='pl01b' else power*2+1
    offset=struct.unpack_from('<I',data,0x268+8*level)[0]
    result=[]
    while struct.unpack_from('<b',data,offset)[0]>=0:
        period,phase,damage=struct.unpack_from('<bbh',data,offset)
        index,kind,initial,hit=struct.unpack_from('<bBhh',data,offset+0x1c)
        result.append(dict(period=period,phase=phase,damage=damage,kind=kind,index=index,
                           initial=initial+5,hit=hit+5))
        assert struct.unpack_from('<I',data,offset+0x30)[0]==0,'需要单独还原非空onHit回调'
        offset+=0x34
    return power,level,result


def lifetimes(text):
    result={}
    for match in re.finditer(r'script script(\d+)\s*\{(.*?)\n\}',text,re.S):
        time=0
        for line in match[2].splitlines():
            delta=re.match(r'\+(\d+):',line.strip())
            if delta:time+=int(delta[1])
            jump=re.search(r'\bins_4\(\w+,\s*(-?\d+)\);',line)
            if jump and int(jump[1])<time:
                # pl00的ANM9每2帧无条件回到0；尾部10000帧终止不可达。
                result[int(match[1])]=None
                break
            if re.search(r'\bins_[12]\(\);',line):
                result[int(match[1])]=time
                break
    return result


def soft_cap(damage):
    if damage>=30:
        damage=(damage*3-90)//5+30
        if damage>=70:damage=min(80,(damage-50)//5+50)
    return damage


def damage_cycle(rows, lifetime):
    # UpdateSecondaryPattern发射0..14后减14，下一帧从0重新发射，不能按无限周期取模。
    # 萃香穿透弹的ANM9无限循环；忽略脱靶/出界后残余1伤害持续到填满弹池。
    slots=[None]*256
    samples=[]
    for frame in range(CYCLE*3):
        for i,p in enumerate(slots):
            if p and frame>=p['end']:slots[i]=None
        for row in rows:
            if frame%15%row['period']!=row['phase']:continue
            assert row['kind'] in (0,1,2),'满火力配置出现未建模弹型'
            try:i=slots.index(None)
            except ValueError:continue
            life=lifetime[row['initial'] if row['kind']==1 else row['hit']]
            slots[i]=dict(row=row,end=frame+life if life is not None else math.inf,damage=row['damage'],hit=False)
        damage=0
        for p in slots:
            if not p:continue
            if p['row']['kind']==1:
                damage+=p['damage']
                if p['damage']>1:p['damage']=max(1,p['damage']//10)
            elif not p['hit']:
                damage+=p['damage'];p['hit']=True
        if frame>=CYCLE:samples.append(soft_cap(damage))
    # 两个连续30000帧窗口必须已稳定；不拿尚在增长的穿透弹伤害当稳态。
    first=sum(samples[:CYCLE])*60/CYCLE
    second=sum(samples[CYCLE:])*60/CYCLE
    assert abs(first-second)<1e-9,(first,second)
    return first


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--assets',type=Path,required=True,help='六份SHT、pl00/01.anm与thanm -l 11的pl00/01.txt')
    ap.add_argument('--archive',type=Path,help='指定时，先在assets目录解包原版th11.dat；不写入原游戏目录')
    ap.add_argument('--thtk',type=Path,default=Path('E:/workspace/thtkGUI-th20tr/thtk/thtk-th20'))
    ap.add_argument('--ecl',type=Path,required=True)
    ap.add_argument('--source',type=Path,default=Path('E:/workspace/th11/src'))
    args=ap.parse_args()
    if args.archive:
        args.assets.mkdir(parents=True,exist_ok=True)
        subprocess.run([str(args.thtk/'thdat.exe'),'-C',str(args.assets),'-g','-x','11',str(args.archive),
                        '*.sht','pl00.anm','pl01.anm'],check=True,capture_output=True)
        for name in ('pl00','pl01'):
            text=subprocess.run([str(args.thtk/'thanm.exe'),'-l','11',str(args.assets/(name+'.anm'))],
                                check=True,capture_output=True).stdout
            (args.assets/(name+'.txt')).write_bytes(text)
    samples=[]
    for i,name in enumerate(('pl00a','pl00b','pl00c','pl01a','pl01b','pl01c')):
        path=args.assets/(name+'.sht')
        power,level,rows=descriptors(path)
        life=lifetimes((args.assets/(name[:4]+'.txt')).read_text('utf-8-sig'))
        normal=damage_cycle(rows,life)
        # SecondaryCounter::Subtract先扣scaled，再相对baseline除7；保留余数，非每帧floor(d/7)。
        samples.append(dict(name=NAMES[i],file=path.name,sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                            power=power,level=level,rows=rows,normal=normal,spell=normal/7))
    scales={mode:TARGET_DPS*statistics.median(1/s[mode] for s in samples) for mode in ('normal','spell')}
    cards=[]
    sources=load(args.ecl)
    for c in catalogue(sources):
        spell=c['spell'] is not None
        survival=c['survival']
        mode='spell' if spell else 'normal'
        cards.append(dict(id=c['id'],stage=c['stage'],sub=c['sub'],name=c['name'] or '非符',raw=c['hp'],
                           entry=c['total_hp'],threshold=c['threshold'],spell=spell,survival=survival,
                           hp=c['hp'] if survival else max(1,math.floor(c['hp']*scales[mode]+.5)),
                           immune=c['invul'],timeout=c['timeout'],
                           active_ttk_median=None if survival else statistics.median(c['hp']/s[mode] for s in samples)))
    source_names=('SecondaryPatternDispatch.cpp','SecondaryPattern.cpp','SecondaryProjectile.cpp',
                  'SecondaryProjectileCallbacks.cpp','SecondaryDamage.cpp','SecondaryDamageSupport.cpp',
                  'SecondaryActorUpdate.cpp','SecondaryCounter.cpp','SecondaryActorInstructionControl.inc',
                  'AnimationExecutionInstructions.inc')
    hashes={n:hashlib.sha256((args.source/n).read_bytes()).hexdigest() for n in source_names}
    for n in ('pl00.anm','pl01.anm','pl00.txt','pl01.txt'):
        hashes[n]=hashlib.sha256((args.assets/n).read_bytes()).hexdigest()
    evidence=dict(target_dps=TARGET_DPS,warmup_frames=CYCLE,sample_frames=CYCLE,
                  source_sha256=hashes,ecl_sha256={name:source.sha256 for name,source in sources.items()},
                  samples=samples,scale=scales,cards=cards,
                  model='低速满火力持续全命中；萃香穿透弹忽略脱靶的伤害上界；帕秋莉默认土符；非移动Boss实测')
    out=ROOT/'mod/GAME/original/th11_low_speed_hp.lua'
    entries={c['id']:{k:v for k,v in c.items() if k not in ('id','name','active_ttk_median')} for c in cards}
    out.write_text('-- calibrate_low_speed_hp.py生成；TH11六种原作自机低速满火力活跃TTK中位数。\nreturn '+lit(dict(scale=scales,entries=entries))+'\n','utf-8',newline='\n')
    (ROOT/'tools/th36-tests/low_speed_hp.json').write_text(json.dumps(evidence,ensure_ascii=False,indent=2)+'\n','utf-8')
    doc=ROOT/'mod/GAME/th31_th34_th35_original_player_ttk_hp_calibration.md'
    start='<!-- TH36_LOW_SPEED_HP_BEGIN -->';end='<!-- TH36_LOW_SPEED_HP_END -->'
    section=[start,'## TH36：地灵殿的道中、关底与逐卡练习（2026-11-08）','',
             '按同一低速、满火力、持续全命中口径，六种可选自机各占一个样本。帕秋莉取进入游戏的默认土符，未把其内部五种元素当成五个自机重复加权。',
             '本模型忽略飞行、走位、脱靶、出界、炸弹与死亡；萃香穿透弹命中后21→2→1，ANM9每2帧无条件回跳，尾部10000帧终止不可达。持续全命中时它最终填满256发弹池，因此该机体数值是模型上界，不是站桩实际DPS。此机体不属于决定六机体中位数的两个中心样本。',
             '射击计时按原作0..14循环，保留256发弹池、命中动画占槽、ANM寿命，以及30点／70点两段软上限和80点上限。',
             '符卡的七倍精度来自`SecondaryCounter::Subtract`，余数跨帧累计；不逐帧对伤害除7取整。全免时间、耐久与炸弹防御不并入HP。普通道中／使魔未执行spell指令时始终使用非符比例。','',
             '| 原作自机 | 满火力P | 非符DPS | 符卡life DPS |','|---|---:|---:|---:|']
    section += [f"| {s['name']} | {s['power']} | {s['normal']:.6f} | {s['spell']:.6f} |" for s in samples]
    section += ['',f"换算目标为移植灵梦115.5 DPS。非符比例`{scales['normal']:.15f}`，符卡比例`{scales['spell']:.15f}`。", 
                '`hp = round(115.5 × median(raw_effective_life / each_original_DPS))`。Boss按分段有效life逐项取整；普通敌机按浮点比例换算，最低1 HP。隐形控制宿主、999999以上占位血量及耐久不缩放。',
                '框架碰撞期间暴露换算后的HP；ECL执行、专用回调和阈值中断期间恢复原作life。内部切换life、阶段和局部spell状态后重新暴露，残血不会因比例切换回血。勇仪弧形节点收集的框架伤害只转换一次，几何仍读取原始life比例。','',
                '来源与逐机体SHT行、SHA-256、两个连续30000帧稳态窗口和86阶段明细见`tools/th36-tests/low_speed_hp.json`。生成器为`tools/th36-tests/calibrate_low_speed_hp.py`，运行时桥为`mod/GAME/th36/hp.lua`。','',
                '| 卡ID | 阶段 | 类型 | 原有效life | 换算HP | 活跃TTK中位数（秒） |','|---|---|---|---:|---:|---:|']
    for c in cards:
        ttk='耐久' if c['survival'] else f"{c['active_ttk_median']:.6f}"
        section.append(f"| `{c['id']}` | {c['stage']}面 {c['sub']} | {'符卡' if c['spell'] else '非符'} | {c['raw']} | {c['hp']} | {ttk} |")
    section.append(end)
    text=doc.read_text('utf-8');block='\n'.join(section)
    if start in text:text=text[:text.index(start)]+block+text[text.index(end)+len(end):]
    else:text=text.rstrip()+'\n\n'+block+'\n'
    doc.write_text(text,'utf-8',newline='\n')
    print(json.dumps(dict(samples=[{k:s[k] for k in ('name','normal','spell')} for s in samples],scale=scales,phases=len(cards)),ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
