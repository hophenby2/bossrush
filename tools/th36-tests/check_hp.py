"""核对TH36全阶段的标定公式、实际扣血、原始life窗口和道中残血映射。"""
from pathlib import Path
import json
import math
import os
import statistics
import sys
from run_lua import ROOT,runtime


def main():
    os.chdir(ROOT)
    evidence=json.loads((ROOT/'tools/th36-tests/low_speed_hp.json').read_text('utf-8'))
    for c in evidence['cards']:
        if c['survival']:
            assert c['hp']==c['raw']
            continue
        mode='spell' if c['spell'] else 'normal'
        ttk=statistics.median(c['raw']/s[mode] for s in evidence['samples'])
        assert c['hp']==max(1,math.floor(115.5*ttk+.5))
        assert abs(c['hp']/115.5-ttk)<=.5/115.5+1e-10
    lua=runtime();lua.globals().arg=lua.table_from(['血量核对'])
    setup=(ROOT/'tools/check_stage.lua').read_text('utf-8-sig').split('if path == "--all" then',1)[0]
    lua.execute(setup);lua.execute("dofile('THlib/anm/original.lua');dofile('mod/GAME/th36.lua')")
    result=lua.execute('''
        local C=_editor_class.TH36
        local H,HP=C.runtime,C.runtime.hp
        H.emit_pattern=function() end
        H.fire_laser=function() end
        H.laser=function() end
        local function near(a,b) assert(math.abs(a-b)<1e-7,('%s ~= %s'):format(a,b)) end
        local function inert(a)
            a.threads={{name='血量检查宿主',co=coroutine.create(function() while true do coroutine.yield() end end)}}
        end
        -- 处于符卡中的普通敌机仍按非符倍率；全场spell状态变化不能重置残血。
        local s=H.session({_live=true},1,'main')
        HP.enter(s)
        local a=H.attach({_live=true},s,'main',0,100,100)
        inert(a);HP.leave(s)
        near(a.o.hp,100*HP.scale.normal)
        a.o.hp=a.o.hp-2
        local raw=100-2/HP.scale.normal
        near(HP.raw(a),raw)
        HP.enter(s);H.spell(s.root,0,100,0,'检查',342);HP.leave(s)
        near(HP.raw(a),raw);near(a.o.maxhp,100*HP.scale.normal)
        HP.enter(s);H.write(a,-9954,42);near(H.read(a,{s={}},-9954),42);HP.leave(s)
        near(a.o.hp,42*HP.scale.normal)
        -- 低血量下限、隐形控制器和共享血量占位不缩放。
        HP.enter(s)
        local tiny=H.attach({_live=true},s,'main',0,100,1)
        local hidden=H.attach({_live=true},s,'main',0,100,100);hidden.flags=32
        local shared=H.attach({_live=true},s,'main',0,100,999999)
        HP.leave(s)
        near(tiny.o.hp,1);near(hidden.o.hp,100);near(shared.o.hp,999999)
        -- 引擎可能先触发kill；此时不能把换算HP拿去和原始阈值比较。
        HP.enter(s)
        a.is_boss=true;a.hp_phase=HP.entries[11000];H.life(a,9200)
        H.interrupt(a,0,5200,1020,'MBoss2');HP.leave(s)
        near(a.o.maxhp,HP.entries[11000].hp)
        a.o.hp=0;H.transition(a,true)
        assert(a.sub=='MBoss2' and a.transition_pending)
        near(HP.raw(a),5200)
        H.close(s)
        -- 怪轮是可击破的从属演员，不是Boss本体；须另走31个弧形节点的真实收集入口。
        local r=H.session({_live=true},3,'main');inert(r.root)
        local wheel=H.spawn(r.root,256,'BossCard1At',0,0,3000,0,0)
        for i=1,5 do H.step(r) end
        assert(wheel.damage_callback and wheel.ring_nodes[1])
        near(wheel.o.maxhp,3000*HP.scale.normal)
        local node=wheel.ring_nodes[1]
        local before=HP.raw(wheel)
        node.class.base.take_damage(node,3.85);H.step(r)
        near(HP.raw(wheel),before-3.85/HP.scale.normal)
        near(wheel.o.hp,(before*HP.scale.normal)-3.85)
        H.close(r)
        local tested,ring,survivals=0,1,0
        for _,meta in ipairs(C.catalogue) do
            local entry=assert(HP.entries[meta.id])
            local host={_live=true,x=0,y=96}
            local session=H.session(host,meta.stage,meta.sub,meta)
            near(host.hp,entry.hp);near(host.maxhp,entry.hp)
            near(HP.raw(session.root),meta.total_hp)
            local dealt,steps=0,0
            while not session.done and steps<meta.timeout+10 do
                local actor=session.root
                if host._original_accepts_damage and not actor.damage_callback and not entry.survival then
                    local damage=math.min(host.hp,115.5/60)
                    host.hp=host.hp-damage;dealt=dealt+damage
                elseif actor.damage_callback and host._original_accepts_damage and not entry.survival then
                    -- 使用真实节点收集入口，同一笔框架伤害只能换算一次。
                    local node=assert(actor.ring_nodes[1])
                    local damage=math.min(host.hp,115.5/60)
                    node.class.base.take_damage(node,damage);dealt=dealt+damage
                end
                H.step(session);steps=steps+1
            end
            assert(session.done,('阶段未结束：%d %s hp=%s raw=%s time=%s dealt=%s flags=%s'):format(meta.id,meta.sub,host.hp,HP.raw(session.root),session.root.phase_time,dealt,session.root.flags))
            if entry.survival then
                assert(dealt==0);survivals=survivals+1
            else
                assert(not host.timeout,('标定后仍超时：%d %s dealt=%s target=%s raw=%s time=%s flags=%s'):format(meta.id,meta.sub,dealt,entry.hp,HP.raw(session.root),session.root.phase_time,session.root.flags))
                assert(math.abs(dealt-entry.hp)<1e-6,('扣血不等于换算HP：%d %.12f %.12f'):format(meta.id,dealt,entry.hp))
            end
            if session.root.damage_callback then ring=ring+1 end
            H.close(session);tested=tested+1
        end
        return tested,ring,survivals
    ''')
    output=dict(phases=result[0],ring_units=result[1],survivals=result[2],formula=True,
                raw_thresholds=True,road_units=True,partial_life=True,minimum_hp=True,
                scope='LuaJIT中全阶段115.5 DPS扣血；发弹关闭，不替代真引擎碰撞与原作移动Boss TTK实测')
    (ROOT/'tools/th36-tests/verification-hp-2026-11-08.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n','utf-8')
    print(json.dumps(output,ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
