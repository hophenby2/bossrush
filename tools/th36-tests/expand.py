"""把TH11 ECL离线展开为Lua函数；发行版不读取ECL、不保存指令数组。"""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import re
import sys
from source import ROOT, Variable, active, load, programs


def lit(value):
    if value is None: return 'nil'
    if isinstance(value, bool): return str(value).lower()
    if isinstance(value, str): return json.dumps(value, ensure_ascii=False)
    if isinstance(value, (tuple, list)): return '{' + ','.join(map(lit, value)) + '}'
    if isinstance(value, dict): return '{' + ','.join('['+lit(k)+']='+lit(v) for k,v in value.items()) + '}'
    return repr(value)


def value(x):
    if isinstance(x, Variable):
        return f'H.read(a,v,{x.index})' if x.index < 0 else f'(v.l[{x.index}] or 0)'
    if isinstance(x, str) and x.startswith('"'): return lit(x[1:-1])
    return lit(x)


def put(x, expression, floating=False):
    assert isinstance(x, Variable), x
    expression = f'H.f32({expression})' if floating else f'H.int({expression})'
    if x.index < 0: return f'H.write(a,{x.index},{expression})'
    return f'v.l[{x.index}]={expression}'


def statement(row, stage, block):
    op, x = row.op, row.args
    args = ','.join(value(a) for a in x)
    invoke = lambda fn, extra='': [f'H.{fn}(a{"," if args else ""}{args}{extra})']
    if op in (0,40): return [], False
    if op == 1: return ['H.erase(a);return'], True
    if op == 10: return ['return'], True
    if op in (11,15,16):
        target=value(x[0]); rest=x[2:] if op==16 else x[1:]
        actual=','.join(value(a) for a in rest)
        if op == 11: return [f'H.call(a,v,P[{target}],{target}{"," if actual else ""}{actual})'],False
        return [f'H.async(a,P[{target}],{target},{value(x[1]) if op==16 else "nil"}{"," if actual else ""}{actual})'],False
    if op == 17: return invoke('stop_thread'),False
    if op == 21: return ['H.stop_threads(a)'],False
    if op in (12,13,14):
        label=block(x[0]); expr=f'v.origin=H.clock(a)-({value(x[1])});return B.{label}(a,v)'
        if op==12:return [expr],True
        return [f'if H.pop(v){"==" if op==13 else "~="}0 then {expr} end'],False
    if op in (42,44):return [f'H.push(v,{value(x[0])})'],False
    if op in (43,45):return [put(x[0],'H.pop(v)',op==45)],False
    arithmetic={50:'+',51:'+',52:'-',53:'-',54:'*',55:'*',56:'/',57:'/'}
    compare={59:'==',60:'==',61:'~=',62:'~=',63:'<',64:'<',65:'<=',66:'<=',67:'>',68:'>',69:'>=',70:'>='}
    if op in arithmetic or op in compare or op in (58,73):
        expr=f'left{arithmetic[op]}right' if op in arithmetic else f'(left{compare[op]}right and 1 or 0)' if op in compare else 'math.fmod(left,right)' if op==58 else '((left~=0 or right~=0) and 1 or 0)'
        if op in (50,52,54,56,58):expr=f'H.int({expr})'
        elif op in (51,53,55,57):expr=f'H.f32({expr})'
        return [f'do local right=H.pop(v);local left=H.pop(v);H.push(v,{expr}) end'],False
    if op == 78:return [f'H.push(v,{value(x[0])})',put(x[0],value(x[0])+'-1')],False
    if op == 81:
        return [f'do local r={value(x[3])};local angle={value(x[2])};{put(x[0],"math.cos(angle)*r",True)};{put(x[1],"math.sin(angle)*r",True)} end'],False
    if op == 82:return [put(x[0],f'H.angle({value(x[0])})',True)],False
    if op in (83,368):return [f'v.origin=v.origin+H.int({value(x[0] if op==83 else x[3])})'],False
    if op == 85:return ['H.push(v,-H.pop(v))'],False
    if op in (355,356):return [put(x[0],value(x[4]),op==356)],False
    if op in (256,257,260,261,265,266,267,268):
        return [f'H.spawn(a,{op},{args})'],False
    if op in (258,259,262,263,264,269,275,276,277,278):
        fn={258:'select_anm',259:'anm_slot',262:'anm_main',263:'effect',264:'effect_abs',269:'anm_cast',275:'anm_switch',276:'anm_reset',277:'anm_rotate',278:'anm_death'}[op]
        return invoke(fn),False
    if op in (280,281,282,283,284,285,286,287,288,289,290,291,292,300,302,305):
        fn={280:'position',281:'position_time',282:'position',283:'position_time',284:'velocity',285:'velocity_time',286:'velocity',287:'velocity_time',288:'circle',289:'circle_time',290:'circle',291:'circle_time',292:'wander',300:'ellipse',302:'ellipse',305:'bezier'}[op]
        channel=1 if op in (282,283,286,287,290,291,302) else 0
        return [f'H.{fn}(a,{channel},{args})'],False
    if op==307:return ['H.motion_reset(a)'],False
    if op in (320,321):return [f'H.{"hurtbox" if op==320 else "hitbox"}(a,{args})'],False
    if op in (322,323):return [f'H.flags(a,{args},{str(op==322).lower()})'],False
    if op==324:return invoke('limit'),False
    if op==325:return ['a.limit=nil'],False
    if op in (326,327,328,329,330):return [f'H.{ {326:"drop_clear",327:"drop_extra",328:"drop_area",329:"drop",330:"drop_main"}[op]}(a{"," if args else ""}{args})'],False
    if op==331:return invoke('life'),False
    if op==332:return invoke('boss_slot'),False
    if op==333:return ['a.phase_time=0'],False
    if op==334:return invoke('interrupt'),False
    if op==335:return [f'a.invul={value(x[0])}'],False
    if op==336:return invoke('sound'),False
    if op==337:return invoke('shake'),False
    if op==338:return invoke('dialog'),False
    if op==339:return ['H.dialog_wait(a,v)'],False
    if op==340:return ['H.boss_wait(a,v)'],False
    if op==341:return invoke('timeout'),False
    if op in (342,357,358,359):
        return [f'H.spell(a,{args},{op})'],False
    if op==343:return ['H.spell_end(a)'],False
    if op==344:return [f'a.chapter={value(x[0])}'],False
    if op==345:return ['H.kill_all(a)'],False
    if op==346:return [f'a.protect={value(x[0])}'],False
    if op==347:return invoke('life_marker'),False
    if op==360:return [f'a.stars={value(x[0])}'],False
    if op==362:return ['a.survival=true'],False
    if op==363:return ['H.background_end(a)'],False
    if op==365:return ['H.mark_effects(a)'],False
    if op==367:return invoke('time_scale'),False
    if op in (369,370,371):return [f'H.actor_group(a,{op},{args})'],False
    if op in (400,401,402,403,404,405,406,407,408,409,411,435,436,437,438,439):
        fn={400:'gun_new',401:'fire',402:'gun_sprite',403:'gun_offset',404:'gun_angle',405:'gun_speed',406:'gun_count',407:'gun_aim',408:'gun_sound',409:'gun_transform',411:'gun_copy',435:'gun_speed_diff',436:'gun_count_diff',437:'gun_polar',438:'gun_distance',439:'gun_absolute'}[op]
        return invoke(fn),False
    if op in (410,420,421,447):return [f'H.cancel(a,{args if args else "1e9"},{str(op in (410,420)).lower()})'],False
    if op in (412,413,431,433):return [f'H.laser(a,{op},{args})'],False
    if op==440:return invoke('fog'),False
    if op==441:return invoke('stage_label'),False
    if op==442:return [f'a.hide_life={value(x[0])}~=0'],False
    if op in (443,444,445,449):return [f'H.callback(a,{op},{args})'],False
    if op==448:return invoke('laser_clear_id'),False
    if op==450:return invoke('score'),False
    if op==500:return [f'H.debug_entry(a,{args})'],False
    raise ValueError(('未实现离线展开',stage,op,row))


def routine(source, rows, sub, stage):
    # 分支指向被难度掩码剔除的指令时，仍保留原始标签和时间。
    leaders={rows[0].address}
    for i,r in enumerate(rows):
        if r.op in (12,13,14):
            leaders.add(source.labels[r.args[0]])
            if i+1<len(rows):leaders.add(rows[i+1].address)
    leaders=sorted(leaders)
    def block(label):return 'part'+str(leaders.index(source.labels[label])+1)
    out=[f'-- {source.binary.name}：{sub}，0x{rows[0].address:x}；只编译{"Extra" if stage==7 else "Lunatic"}掩码。','do','    local B={}']
    for j,start in enumerate(leaders):
        out += [f'    function B.part{j+1}(a,v)']
        end=leaders[j+1] if j+1<len(leaders) else 1<<40
        ended=False
        for r in rows:
            if not start<=r.address<end:continue
            out.append(f'        H.at(a,v,{r.time})')
            if not r.mask&(16 if stage==7 else 8):continue
            out.append(f'        -- 源0x{r.address:x}，{r.op}号。')
            lines,ended=statement(r,stage,block)
            out += ['        '+line for line in lines]
            if ended:break
        if not ended and j+1<len(leaders):out.append(f'        return B.part{j+2}(a,v)')
        out.append('    end')
    out += [f'    P[{lit(sub)}]=B.part1','end']
    return '\n'.join(out)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('source',type=Path)
    ap.add_argument('--check',action='store_true')
    args=ap.parse_args(); sources=load(args.source)
    dest=ROOT/'mod/GAME/th36';dest.mkdir(exist_ok=True)
    manifest={'version':11,'difficulty':{'1-6':'Lunatic','7':'Extra'},'files':{},'programs':{},'unmapped_opcodes':[]}
    for key,s in sources.items():manifest['files'][key+'.ecl']={'sha256':s.sha256,'subroutines':len(s.subs)}
    for stage in range(1,8):
        pp=programs(sources,stage)
        out=['-- 由 tools/th36-tests/expand.py 离线生成。手工改行为应同步修改展开器并核对原二进制。','local H,P=...']
        for sub,(src,rows) in pp.items():out.append(routine(src,rows,sub,stage))
        out.append('return P')
        text='\n\n'.join(out)+'\n';path=dest/f'stage{stage:02}.lua'
        if args.check:assert path.read_text('utf-8')==text,('离线展开产物过期',path)
        else:path.write_text(text,'utf-8',newline='\n')
        manifest['programs'][str(stage)]={'subroutines':len(pp),'instructions':sum(len(active(rows,stage)) for _,rows in pp.values()),'lua_sha256':hashlib.sha256(text.encode()).hexdigest()}
    path=dest/'sources.json';text=json.dumps(manifest,ensure_ascii=False,indent=2)+'\n'
    if args.check:assert path.read_text('utf-8')==text
    else:path.write_text(text,'utf-8',newline='\n')
    print('七面离线展开完成，源文件20份；未识别指令会直接中止生成。')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
