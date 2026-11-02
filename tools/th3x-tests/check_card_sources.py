"""用原始 ECL 的控制流核对逐卡实现；不把未覆盖部分标成通过。"""
import argparse
import math
from pathlib import Path
import sys

from card_catalogue import runtime, plain
from ecl_source import Source, ScalarTrace


def check(args):
    lua = runtime()
    lua.execute('''
        audit_cards={}
        boss.card.add=function(parts,level,title,id) audit_cards[id]=parts[1][1] end
        dofile('mod/GAME/th31.lua')
        function audit_find(root,wanted)
            local seen={}
            local function walk(v)
                if (type(v)~='table' and type(v)~='function') or seen[v] then return end
                seen[v]=true
                if type(v)=='function' then
                    for i=1,100 do
                        local name,u=debug.getupvalue(v,i);if not name then break end
                        if name==wanted then return u end
                        -- 公共M/class连接全部卡；不能从那里取到另一张卡的同名辅助函数。
                        if name~='M' and name~='class' then
                            local out=walk(u);if out then return out end
                        end
                    end
                else
                    for _,u in pairs(v) do local out=walk(u);if out then return out end end
                end
            end
            return assert(walk(root),wanted)
        end
        function audit_program(block,part,sign)
            local p=audit_find(audit_cards[351],'storm_program')(block,part,sign)
            local out={}
            for i,r in ipairs(p) do
                local a={r.kind,r.allow}
                if r.kind==8192 or r.kind==131072 then a[3]=r.frames
                elseif r.kind==64 then
                    a[3],a[4],a[5],a[6]=r.interval,r.repeats,-r.angle,r.keep_speed and -999 or r.speed
                elseif r.kind==16384 then a[3],a[4]=r.style.native_type,r.color-1
                elseif r.kind==524288 then a[3]=r.index end
                out[i]=a
            end
            return out
        end
    ''')
    sources = {}

    def source(file):
        if file not in sources:
            sources[file] = Source(args.declarations / (file + '.decl'), args.binaries / (file + '.ecl'))
        return sources[file]

    checks = 0

    def equal(actual, expected, context):
        nonlocal checks
        if isinstance(expected, (int, float)):
            assert isinstance(actual, (int, float)) and math.isclose(actual, expected, abs_tol=2e-5), (context, actual, expected)
        else:
            assert actual == expected, (context, actual, expected)
        checks += 1

    # 两个符号、全部96次发弹的变换程序，从原始分支跳转结果生成期望值。
    # 这样 ins_51 的 >= 分支翻反、色号偏一，都不能靠自测常量互相印证。
    for sign in (1, -1):
        events = ScalarTrace(source('ecldata1sp'), 'Sub37', {10057: sign * 0.03926991, 10039: 6}).run(113)
        shots = [e for e in events if e['op'] == 99]
        equal(len(shots), 96, 'Sub37完整的一次CALL')
        for i, shot in enumerate(shots):
            block, part = (i // 2) % 3 + 1, i % 2 + 1
            actual = plain(lua.globals().audit_program(block, part, sign))
            equal(len(actual), len(shot['transforms']), '变换槽数')
            for slot, expected in shot['transforms'].items():
                row = actual[slot]
                for j, value in enumerate(row):
                    equal(value, expected[j], (351, sign, hex(shot['address']), slot, j))

    # 17个生成助手在CALL前设受击框。使用原作指令值，不从Lua常量抄期望。
    for card_id in range(351, 368):
        card = lua.globals().audit_cards[card_id]
        meta = plain(card.th08_lastword_source)
        original = source(meta['file'])
        rows = original.subs['Sub' + str(meta['origin'])]
        at = next(i for i, row in enumerate(rows) if row.op == 52 and row.args == [meta['sub']])
        box = next(row.args for row in reversed(rows[:at]) if row.op == 77)
        boss = lua.table_from(dict(x=0, y=96, timer=0, ani=0))
        card.init(boss)
        equal(boss.a * 2, box[0], (card_id, '受击全宽'))
        equal(boss.b * 2, box[1], (card_id, '受击全高'))
        equal(boss.rect, True, (card_id, '方形判定'))
        card['del'](boss)

    # 盲夜鸟：实际运行Sub48两轮，读取每轮第一条扇形的瞄准结果。
    events = ScalarTrace(source('ecldata2sp'), 'Sub48', external=lambda index, frame:
                         (0.25 if frame < 396 else -0.6) if index == 10048 else 0).run(793)
    firsts = [e for e in events if e['op'] == 97 and e['frame'] in (0, 396, 792)]
    equal(len(firsts), 3, '盲夜鸟每396帧重新进入循环头')
    lua.execute('''
        audit_206={}
        local card=audit_cards[352]
        local b={x=0,y=96,timer=0,ani=0}
        card.init(b)
        local raw_new,raw_valid,raw_float=New,IsValid,ran.Float
        local bullet_class=audit_find(card,'lw206_bullet')
        local current
        New=function(cls,...)
            if cls==bullet_class then
                local a={...}
                if current and not audit_206[current] then audit_206[current]=a[3] end
                return {_live=false}
            end
            return raw_new(cls,...)
        end
        IsValid=function(o) return o and o._live~=false end
        ran.Float=function(_,lo,hi) return (lo+hi)/2 end
        for t=0,962 do
            local a=(t-170)<396 and .25 or -.6
            player.x,player.y=b.x+100*math.cos(a),b.y-100*math.sin(a)
            current=(t==170 or t==566 or t==962) and t-170 or nil
            card.frame(b)
            assert(b.x>=-160 and b.x<=160 and b.y>=96 and b.y<=176,'盲夜鸟越过生成助手活动框')
        end
        card.del(b)
        New,IsValid,ran.Float=raw_new,raw_valid,raw_float
    ''')
    for event in firsts:
        equal(lua.globals().audit_206[event['frame']], -event['args'][6], (352, event['frame'], '每轮瞄准'))

    # 日出之国：以指令解释产生真实经过帧数，不把ECL时间戳直接当物理帧。
    events = ScalarTrace(source('ecldata3sp'), 'Sub57', external=lambda index, frame:
                         .4 if index == 10048 else 0).run(5940)
    lasers = [e for e in events if e['op'] == 114]
    lua.execute('''
        audit_207={}
        local step=audit_find(audit_cards[353],'laser_step')
        local b={x=0,y=96}
        player.x,player.y=100*math.cos(.4),96-100*math.sin(.4)
        local raw_new=New
        local frame=0
        New=function(cls,x,y,angle,color,start)
            audit_207[#audit_207+1]={frame,angle,color-1,start}
            return {_live=false}
        end
        local clock=0
        for t=0,5939 do frame=t;clock=step(b,clock) end
        New=raw_new
    ''')
    actual = plain(lua.globals().audit_207)
    equal(len(actual), len(lasers), (353, '整张卡的激光发射数'))
    for row, event in zip(actual, lasers):
        a = event['args']
        equal(row[0], event['frame'], (353, '发射帧'))
        error = (row[1] + a[2] + math.pi) % (2 * math.pi) - math.pi
        equal(error, 0, (353, event['frame'], '发射方向'))
        equal(row[2], a[1], (353, '色号'))
        equal(row[3], a[8], (353, '预警时长'))
    # 幻胧月睨：只截取根程序的发弹事件；移动、ExIns及另生对象不在这项比较中模拟。
    events = ScalarTrace(source('ecldata5sp'), 'Sub40', effects=(
        64, 91, 95, 105, 110, 113, 122, 132, 134, 135, 136, 153, 160)).run(5940)
    expected = []
    for e in events:
        if e['op'] != 99:
            continue
        kind, color, n, layers, speed, end, base, step, flags = e['args']
        for j in range(layers):
            for i in range(n):
                expected.append((e['frame'], kind, color, speed - (speed - end) * j / layers,
                                 -(base + i * 2 * math.pi / n + j * step), flags))
    lua.execute('''
        audit_208={}
        local card=audit_cards[354]
        local b={x=0,y=96,timer=0,ani=0};card.init(b)
        local cls=audit_find(card,'lw208_bullet')
        local raw_new,raw_float=New,ran.Float
        local frame=0
        New=function(c,x,y,angle,speed,color,flags)
            if c==cls then audit_208[#audit_208+1]={frame,16,color-1,speed,angle,flags} end
            return {_live=false}
        end
        ran.Float=function() return 0 end
        for t=0,5939 do frame=t;card.frame(b) end
        card.del(b);New,ran.Float=raw_new,raw_float
    ''')
    actual = plain(lua.globals().audit_208)
    equal(len(actual), len(expected), (354, '整卡圆环发弹数，未施加弹池上限'))
    for row, exp in zip(actual, expected):
        for j, value in enumerate(exp):
            equal(row[j], value, (354, exp[0], '圆环参数', j))

    # 用原版ANM运行相位图块切换；变速前换色同时验证真实ChangeImage接口。
    lua.execute('''
        audit_208_state={}
        local raw_init,raw_change=bullet.init,bullet.ChangeImage
        bullet.init=function(o,s,c,...) raw_init(o,s,c,...);s.init(o,c) end
        bullet.ChangeImage=function(o,s,c) o.imgclass=s;o._index=c;s.init(o,c) end
        local card=audit_cards[354]
        local b={x=0,y=96,timer=0,ani=0};card.init(b)
        local cls=audit_find(card,'lw208_bullet')
        local raw_new=New
        local shot
        New=function(c,...)
            if c==cls then
                shot={class=c,timer=0,ani=0,x=0,y=0,rot=0};c.init(shot,...);return shot
            end
            return raw_new(c,...)
        end
        audit_find(card,'fire_ring')(b,1,1,5,5,3,0x100000,0)
        local sprite=shot._native_anm.sprite
        local phase=audit_find(card,'advance_phase')
        phase(0x100000)
        audit_208_state[1]={shot._native_anm.sprite-sprite,shot._native_anm.blend,shot._a,shot.colli,shot.vx}
        phase(0x100000)
        for t=1,15 do cls.frame(shot);shot.ani=t end
        audit_208_state[2]={shot._native_anm.sprite-sprite,shot._a,shot.colli}
        phase(0x100000)
        audit_208_state[3]={shot._native_anm.sprite-sprite,shot._native_anm.blend,shot._a,shot.colli,shot.vx}
        New=raw_new;card.del(b)
        local gun=audit_find(card,'lw208_gun_bullet')
        local g={class=gun,timer=0,ani=0,x=0,y=0,rot=0};gun.init(g,0,0,0,0,4)
        audit_208_gun={}
        for t=1,242 do
            gun.frame(g);g.ani=t
            audit_208_gun[t]={g.imgclass.native_type,g._native_color,g.vx}
        end
        -- 弹池是槽位登记；离屏但尚未死亡的对象仍占槽，不能在发下一波时偷删。
        audit_pools={}
        for _,id in ipairs({353,354,355,364}) do
            local c=audit_cards[id];local owner={x=0,y=96,timer=0,ani=0};c.init(owner)
            local used=audit_find(c,'pool_used')
            local pool=audit_find(used,'pool')
            pool[#pool+1]={x=9999,y=9999,_live=true}
            audit_pools[#audit_pools+1]=used()
            pool[1]._live=false
            audit_pools[#audit_pools+1]=used()
            c.del(owner)
        end
        local tree=audit_find(audit_cards[356],'lw210_bullet')
        local g={class=tree,timer=0,ani=0,x=0,y=0,rot=0}
        tree.init(g,0,0,0,2.1,3,true)
        g.lw210_state=nil;g.lw210_prog=2
        audit_find(audit_cards[356],'bullet_advance')(g)
        audit_210_sprite={g.imgclass.native_type,g._native_color}
        bullet.init,bullet.ChangeImage=raw_init,raw_change
    ''')
    # AdvanceReisenBulletPhase的三个分支：EclExIns.cpp:669..717。
    for row, exp in zip(plain(lua.globals().audit_208_state), (
            [16, 'mul+add', 0, False, .1], [16, 255, False], [0, '', 255, True, 5])):
        for value, want in zip(row, exp):
            equal(value, want, (354, '相位精灵与判定'))
    descriptor = next(e for e in ScalarTrace(source('ecldata5sp'), 'Sub41').run(1) if e['op'] == 97)
    wait, sprite, accel = (descriptor['transforms'][i] for i in range(3))
    for t, row in enumerate(plain(lua.globals().audit_208_gun), 1):
        started = t > wait[2] + 1
        equal(row[0], sprite[2] if started else descriptor['args'][0], (354, t, '枪弹类型'))
        equal(row[1], sprite[3] if started else descriptor['args'][1], (354, t, '枪弹色号'))
        equal(row[2], min(max(t - wait[2] - 1, 0), accel[2]) * accel[4], (354, t, '枪弹加速度'))
    equal(plain(lua.globals().audit_pools), [1,0,1,0,1,0,1,0], '出屏宽限期仍占弹池槽位')
    transform = next(r.args for r in source('ecldata7sp').subs['Sub80'] if r.op == 111 and r.args[0] == 2)
    equal(plain(lua.globals().audit_210_sprite), [transform[3],2], (356, '树弹转向后换弹型，保留树的色号'))
    print(f'原作指令回归通过：{checks}项；覆盖LW205分支、LW206瞄准与活动框、LW207整卡激光发射、LW208圆环及相位、LW210换弹图、17张LW入口判定。')
    print('范围外仍未通过逐条核对：完整运动、弹体生命周期、激光、其他卡的指令语义。')


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--declarations', type=Path, default=Path(r'E:\workspace\.bossrush-validation\original-anm\ecl\8'))
    parser.add_argument('--binaries', type=Path, default=Path(r'E:\workspace\原作\ECL\th08'))
    check(parser.parse_args())
