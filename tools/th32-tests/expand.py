#!/usr/bin/env python3
"""把红魔乡原生 ECL 离线展开为直接调用原生组件的 Lua 函数；游戏不需要此工具或 ECL 文件。"""
import argparse
import bisect
import json
from pathlib import Path
from source import Source,catalogue

REG={-10001:'v.i0',-10002:'v.i1',-10003:'v.i2',-10004:'v.i3',-10005:'v.f0',-10006:'v.f1',-10007:'v.f2',-10008:'v.f3',-10009:'v.c0',-10010:'v.c1',-10011:'v.c2',-10012:'v.c3',-10013:'(a.stage==7 and 4 or 3)',-10014:'a.rank',-10015:'(b.x+192)',-10016:'(224-b.y)',-10017:'a.z',-10018:'(player.x+192)',-10019:'(224-player.y)',-10020:'0',-10021:'H.player_angle(b)',-10022:'a.phase',-10023:'H.distance(b)',-10024:'H.life(b)',-10025:'(a.meta.shot or 0)'}
COND={29:'<',30:'<=',31:'==',32:'>',33:'>=',34:'~='}
CALLCOND={37:'<',38:'<=',39:'==',40:'>',41:'>=',42:'~='}
VISUAL={0,97,98,99,100,101,102,106,107,109,110,117,118,119,120,123,124,125,126,127,128,129,130,136}

def lit(v):
    if v is None:return 'nil'
    if v is True:return 'true'
    if v is False:return 'false'
    if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
    if isinstance(v,(tuple,list)):return '{'+','.join(lit(x) for x in v)+'}'
    if isinstance(v,dict):return '{'+','.join(f'{k}={lit(x)}' for k,x in v.items())+'}'
    return repr(v)

def value(x):return REG.get(int(x),lit(x)) if isinstance(x,(int,float)) and x==int(x) else lit(x)
def vals(args):return ','.join(value(x) for x in args)
def dst(x):
    if x in(-10015,-10016,-10017,-10024):return None
    return REG[x]

def assignment(target,expr):
    if target==-10015:return f'b.x=({expr})-192'
    if target==-10016:return f'b.y=224-({expr})'
    if target==-10017:return f'a.z={expr}'
    if target==-10024:return f'if not a.main then b.hp={expr} end'
    return f'{dst(target)}={expr}'

def reachable(source,cards):
    needed={st:set() for st in range(1,8)}
    for c in cards:needed[c['stage']].add(c['sub'])
    changed=True
    while changed:
        changed=False
        for stage,subs in needed.items():
            for sub in list(subs):
                for r in source.active(stage,sub):
                    if r['op'] in (35,37,38,39,40,41,42,95,108,114,116):
                        target=r['a'][0]
                        if target>=0 and target not in subs:subs.add(target);changed=True
    return needed

def statement(stage,r,target):
    op,x=r['op'],r['a']
    if op==1:return ['H.erase(b)'],True
    if op==2:return [f'v.time={x[0]};return B.{target(r["pos"]+x[1])}(b,v)'],True
    if op==3:return [f'{dst(x[2])}={dst(x[2])}-1',f'if {dst(x[2])}>0 then v.time={x[0]};return B.{target(r["pos"]+x[1])}(b,v) end'],False
    if op in (4,5):return [assignment(x[0],value(x[1]))],False
    if op in (6,7):return [assignment(x[0],f'H.random_int({value(x[1])})'+(f'+{value(x[2])}' if op==7 else ''))],False
    if op in (8,9):return [assignment(x[0],f'ran:Float(0,{value(x[1])})'+(f'+{value(x[2])}' if op==9 else ''))],False
    if 10<=op<=12:return [assignment(x[0],['b.x+192','224-b.y','a.z'][op-10])],False
    if 13<=op<=17 or 20<=op<=24:
        kind=op if op<20 else op-7;a,b=value(x[1]),value(x[2])
        expr={13:f'({a})+({b})',14:f'({a})-({b})',15:f'({a})*({b})',16:f'({a})/({b})',17:f'math.fmod({a},{b})'}[kind]
        if kind==16 and op<20:expr=f'trunc({expr})'
        return [assignment(x[0],expr)],False
    if op in (18,19):return [assignment(x[0],value(x[0])+(' + 1' if op==18 else ' - 1'))],False
    if op==25:return [assignment(x[0],f'atan2(({value(x[4])})-({value(x[2])}),({value(x[3])})-({value(x[1])}))')],False
    if op==26:return [assignment(x[0],f'normal_angle({value(x[0])})')],False
    if op in(27,28):return [f'v.cmp=({value(x[0])})-({value(x[1])})'],False
    if op in COND:return [f'if v.cmp{COND[op]}0 then v.time={x[0]};return B.{target(r["pos"]+x[1])}(b,v) end'],False
    if op==35:
        boundary=['if a.main and a.sub==59 then H.erase(b) end'] if stage==7 and x[0]==60 else []
        return boundary+[f'H.call(b,v,P[{stage}][{x[0]}],{value(x[1])},{value(x[2])})'],False
    if op==36:return ['return'],True
    if op in CALLCOND:return [f'if ({value(x[3])}){CALLCOND[op]}({value(x[4])}) then H.call(b,v,P[{stage}][{x[0]}],{value(x[1])},{value(x[2])}) end'],False
    if op==43:return [f'H.position(b,{vals(x)});H.clamp(b)'],False
    if op==44:return [f'a.axisx,a.axisy,a.z={vals(x)};a.mode="axis"'],False
    if op==45:return [f'a.angle,a.speed={vals(x)};a.mode="velocity"'],False
    if op in(46,47,48):return [f'a.{ {46:"angular",47:"speed",48:"accel"}[op]}={value(x[0])};a.mode="velocity"'],False
    if op in(49,50):return [f'H.rand_angle(b,{vals(x)},{lit(op==50)})'],False
    if op==51:return [f'a.angle=H.player_angle(b)+({value(x[0])});a.speed={value(x[1])};a.mode="velocity"'],False
    if 52<=op<=55:return [f'H.move_dir(b,{vals(x)},{op-51})'],False
    if 56<=op<=60:return [f'H.move_to(b,{vals(x)},{op-56})'],False
    if 61<=op<=64:return [f'H.move_dir(b,{value(x[0])},a.angle,a.speed,{op-60})'],False
    if op==65:return [f'a.bounds={{{vals(x)}}}'],False
    if op==66:return ['a.bounds=nil'],False
    if 67<=op<=75:return [f'H.pattern(b,{op-66},{vals(x)})'],False
    if op in(76,77):return [f'H.interval(b,{value(x[0])},{lit(op==77)})'],False
    if op in(78,79):return [f'a.muted={lit(op==78)}'],False
    if op==80:return ['H.fire(b)'],False
    if op==81:return [f'a.offsetx,a.offsety,a.offsetz={vals(x)}'],False
    if op==82:return [f'a.extra={{{vals(x)}}}'],False
    if op==83:return ['H.cancel(b)'],False
    if op==84:return [f'a.sound={value(x[0])};if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end'],False
    if op in(85,86):return [f'H.laser(b,{lit(op==86)},{vals(x)})'],False
    if op==87:return [f'a.laser_index={value(x[0])}'],False
    if op in(88,89):return [f'H.rotate_laser(b,{value(x[0])},{value(x[1])},{lit(op==89)})'],False
    if op==90:return [f'H.offset_laser(b,{vals(x[:3])})'],False
    if op==91:return [f'v.cmp=H.laser_test(b,{value(x[0])})'],False
    if op==92:return [f'H.laser_cancel(b,{value(x[0])})'],False
    if op==93:return [f'H.cancel(b);H.reset_rank(a);H.trace(b,"spell",{x[1]})'],False
    if op==94:return ['H.trace(b,"spell_end")'],False
    if op==95:return [f'H.spawn(b,{stage},{vals(x[:5])})'],False
    if op==96:return ['H.clear_helpers(b)'],False
    if op==97:return [f'H.sprite(b,{value(x[0])})'],False
    if op==103:return [f'b.a,b.b,b.rect=({value(x[0])})/2,({value(x[1])})/2,true'],False
    if op in(104,105,117,132):return [f'a.{ {104:"collidable",105:"damageable",117:"interactable",132:"invisible"}[op]}={lit(bool(x[0]))}'],False
    if op==108:return [f'a.death=P[{stage}][{x[0]}]'],False
    if op==111:return [f'if not a.main then b.hp={value(x[0])} end'],False
    if op==112:return [f'a.phase={value(x[0])}'],False
    if op==113:return [f'a.life_threshold={value(x[0])}'],False
    if op==114:return [f'a.life_fn=P[{stage}][{x[0]}]'],False
    if op==115:return [f'a.timeout={value(x[0])};a.phase=0'],False
    if op==116:return [f'a.timeout_fn=P[{stage}][{x[0]}]'],False
    if op==121:return [f'H.extra(b,v,{x[0]},{value(x[1])},false)'],False
    if op==122:return [f'v.repeat_func={lit(x[0]) if x[0]>=0 else "nil"}'],False
    if op==131:return [f'a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi={vals(x)}'],False
    if op==133:return ['a.phase=0'],False
    if op==134:return ['a.lasers={}'],False
    if op==135:return [f'a.survival={lit(bool(x[0]))}'],False
    if op in VISUAL:return [],False
    raise ValueError(('没有离线展开映射',stage,r))

def routine(source,stage,sub):
    rows=source.active(stage,sub);positions=[r['pos'] for r in rows]
    def resolve(pos):return positions[min(len(positions)-1,bisect.bisect_left(positions,pos))]
    leaders={positions[0]}
    for i,r in enumerate(rows):
        if r['op'] in (2,3,29,30,31,32,33,34):
            leaders.add(resolve(r['pos']+r['a'][1]))
            if i+1<len(rows):leaders.add(rows[i+1]['pos'])
    leaders=sorted(leaders)
    def name(pos):return '段'+str(leaders.index(resolve(pos))+1)
    # Lua 5.1 标识符用 ASCII；中文说明写在注释中。
    def label(pos):return 'part'+str(leaders.index(resolve(pos))+1)
    out=[f'-- 第 {stage if stage<7 else "Extra"} 面，原生 Sub{sub}，起始 0x{positions[0]:x}。','do','    local B={}']
    for j,start in enumerate(leaders):
        end=leaders[j+1] if j+1<len(leaders) else 1<<30
        block=[r for r in rows if start<=r['pos']<end]
        out.append(f'    function B.{label(start)}(b,v)')
        out.append('        local a=b.th06_actor')
        last_time=None;ended=False
        for r in block:
            if r['t']!=last_time:out.append(f'        H.wait(b,v,{r["t"]})');last_time=r['t']
            lines,ended=statement(stage,r,label)
            for line in lines:out.append('        '+line)
            if ended:break
        if not ended and j+1<len(leaders):out.append(f'        return B.{label(leaders[j+1])}(b,v)')
        out.append('    end')
    out.append(f'    P[{stage}][{sub}]=B.part1')
    out.append('end')
    return '\n'.join(out)

BOSSES={2:('露米娅·中 Boss','Rumia'),3:('露米娅','Rumia'),4:('大妖精','Daiyousei'),5:('琪露诺','Chiruno'),6:('红美铃·中 Boss','Meirin'),7:('红美铃','Meirin'),8:('小恶魔','Daiyousei'),9:('帕秋莉·灵梦Ａ路线','Knowledge'),15:('帕秋莉·灵梦Ｂ路线','Knowledge'),16:('帕秋莉·魔理沙Ａ路线','Knowledge'),17:('帕秋莉·魔理沙Ｂ路线','Knowledge'),10:('咲夜·五面中 Boss','Sakuya'),11:('十六夜咲夜','Sakuya'),12:('咲夜·六面中 Boss','Sakuya'),13:('帕秋莉·Extra','Knowledge'),14:('芙兰朵露·斯卡蕾特','Flandre')}
ROUTES={9:'灵梦Ａ',15:'灵梦Ｂ',16:'魔理沙Ａ',17:'魔理沙Ｂ'}

def generate(source,cards):
    out=['-- TH06_EXPANDED_START','-- 此段由 tools/th32-tests/expand.py 从原生二进制离线展开；不要在游戏里载入原始 ECL。']
    for stage,digest in source.hashes.items():out.append(f'-- ecldata{stage}.ecl SHA-256：{digest}')
    needed=reachable(source,cards)
    for stage,subs in needed.items():
        for sub in sorted(subs):out.append(routine(source,stage,sub))
    out.append('-- 卡表只注册实际 L / Extra 分支；保留帕秋莉四条机体路线的完整原作顺序。')
    for group,(name,img) in BOSSES.items():
        bg='TH06_bg'
        background=1 if group in (2,3,4,5) else (2 if group in (6,7,8,9,13,15,16,17) else 3)
        sc=f'(_editor_class["TH06"] or {{}})["SCBG{background}"]'
        out.append(f'boss.Define("{group}a",{lit(name)},"TH06_{1 if group==14 else 0}",{bg},{{0,384}},{sc},{lit(img)},LEVEL)')
    for c in cards:
        if c.get('manual'):continue
        meta={k:v for k,v in c.items() if k not in('label','name','manual')}
        mode='Extra' if c['stage']==7 else 'Lunatic'
        label=(c['label'] or c['name'])+'（'+mode+('·'+ROUTES[c['group']] if c['group'] in ROUTES else '')+'）'
        out += ['do',f'    local meta={lit(meta)}',f'    local card=boss.card.New({lit(c["name"])},{c["invul"]/60},{c["invul"]/60},{c["timeout"]/60},{c["hp"]},nil,{lit(c["stage"]==7)})',
        '    card.th06_source=meta;card.th06_order=meta.order',
        '    function card:before() self.th06=nil end','    function card:init() H.card_init(self,meta) end','    function card:del() H.card_del(self) end',
        f'    boss.card.add({{{{card,"{c["group"]}a"}}}},LEVEL,{lit(label)},{c["id"]})','end']
    out += ['do','    local remilia=_editor_boss["1a"..LEVEL]','    if remilia and remilia.cards then',
            '        local order={'+','.join(f'[{c["id"]}]={c["order"]}' for c in cards if c['group']==1)+'}',
            '        for _,card in ipairs(remilia.cards) do card.th06_order=order[card.card_id] or 100 end',
            '        table.sort(remilia.cards,function(a,b) return a.th06_order<b.th06_order end)','    end','end',
            'class.boss_order={2,3,4,5,6,7,8,9,15,16,17,10,11,12,1,13,14}',
            '-- TH06_EXPANDED_END']
    return '\n\n'.join(out)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('data',type=Path);p.add_argument('--write',action='store_true');p.add_argument('--output',type=Path)
    args=p.parse_args();source=Source(args.data);cards=catalogue(source);out=generate(source,cards)
    if args.output:args.output.write_text(out+'\n')
    if args.write:
        path=Path('mod/GAME/th32.lua');text=path.read_text()
        if '-- TH06_EXPANDED_START' in text:
            start=text.index('-- TH06_EXPANDED_START');end=text.index('-- TH06_EXPANDED_END',start)+len('-- TH06_EXPANDED_END')
            text=text[:start]+out+text[end:]
        else:
            marker='\nend\n\nlocal function NewText('
            text=text.replace(marker,'\n'+out+'\n'+marker,1)
        path.write_text(text)
    print(f'离线展开：{len(cards)} 段，{sum(bool(c["name"]) for c in cards)} 条符卡路线，{sum(not c["name"] for c in cards)} 段非符，{len(out.splitlines())} 行直接 Lua 代码')

if __name__=='__main__':main()
