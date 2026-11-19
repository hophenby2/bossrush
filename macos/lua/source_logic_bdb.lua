-- 栖霞园发行版装备、Bomb 与 Hyper 的真实引擎回归。
local T={}
local checked={}
local shots={}
local variant=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')
local slow=variant=='slow'
function T.before(p)
    local t=stage.current_stage.timer
    local R=TH43.runtime;local power=R.env.system.PowerRank
    local s=NativePlayers.state();local adapter=NativePlayers.adapters[41]
    local key=AndroidInput.keys
    if variant=='passive' then
        if t==5 then s.bombs=10;p.protect=100000;power.setRankWithEvent(3);power.setChip(6) end
        if t==30 then
            assert(adapter.beforeHit(p),'满槽自动Hyper没有吸收被弹')
            assert(power.isInHyper() and s.bombs==0,'自动Hyper没有扣两Bomb');checked.passive=true
        end
        if t==50 then power.setHyperTime(1200);power.pauseHyper();s.bombs=5 end
        if t==55 then
            assert(adapter.beforeHit(p) and s.bombs==0,'暂停Hyper未以一Bomb吸收被弹');checked.insurance=true
        end
        if t==60 then assert(not adapter.beforeHit(p),'暂停Hyper零库存仍免疫被弹');power.resumeHyper();power.setHyperTime(0) end
        return
    end
    key[setting.keys.shoot]=t>=10 and t<390
    key[setting.keys.slow]=slow
    key[setting.keys.spell]=t==400
    if t==5 then s.bombs=50;p.protect=100000 end
    if t==401 then
        local duration=({reimu=240,marisa=360,sakuya=300})[p.machine.id]
        assert(s.bombs==45,'栖霞园 Bomb 库存扣除不符')
        assert(p.bombTime==duration-1 and p.nextspell==duration-1,'栖霞园 Bomb 时长不符')
        assert(p.cancelOnlyBomb,'栖霞园仍叠加宿主统一伤害')
        checked.bomb=true
    end
    if t==55 or t==155 or t==255 then
        shots[#shots+1]=p.bdb_emitted or 0
        power.setRankWithEvent((t-55)/100+1)
    end
    if t==385 then
        shots[#shots+1]=p.bdb_emitted or 0
        for i=2,#shots do assert(shots[i]>shots[i-1],'切换 Rank 后原作武器未开火 '..table.concat(shots,',')..' lock='..p.lockshoot..' death='..p.death..' nextshoot='..p._shoot_equip.nextshoot..' dialog='..tostring(p.dialog)..' hit='..tostring(p.hit)) end
        checked.ranks=true
    end
    if t==800 then
        power.setRankWithEvent(3);power.setChip(6)
        assert(R.tryHyper(),'满 Rank 碎片无法开启 Hyper')
        assert(power.getRank()==4 and power.getHyperTime()==1620,'Hyper 初始状态不符')
        checked.hyper=true
    end
    if t==922 then power.pauseHyper();checked.pausedTime=power.getHyperTime() end
    if t==926 then
        assert(power.getHyperTime()==checked.pausedTime,'Hyper 暂停仍流逝')
        power.resumeHyper();checked.pause=true
    end
    if t==950 or t==960 or t==970 then
        if power.isInHyper() then
            assert(adapter.beforeHit(p),'Hyper 没有吸收被弹')
            if t==950 then assert(power.isInHyper() and power.getHitedCount()==1,'首次 Hyper 被弹状态不符') end
            if t==960 and p.machine.id=='reimu' then assert(power.isInHyper() and power.getHitedCount()==2,'灵梦第二次护盾错误破裂') end
        end
        if t==970 then assert(not power.isInHyper() and power.getRank()==0,'Hyper 被击碎后没有回到 Rank 0');checked.breakHyper=true end
    end
    if t==1000 then
        power.setRankWithEvent(3);power.setChip(6);assert(R.tryHyper())
        power.setHyperTime(0)
    end
    if t==1150 then
        assert(not power.isInHyper() and power.getRank()==0,'Hyper 自然结束状态不符')
        assert(not p.bombTime and p.nextspell==0,'Bomb 冷却没有结束')
        assert(p.lockshoot==0 and p.lockspell==0,'禁射/禁雷没有解除')
        local fast=({reimu=4.4,marisa=4.8,sakuya=4})[p.machine.id]
        assert(p.hspeed==fast,'Bomb 后移动速度没有恢复')
        checked.finish=true
    end
end
function T.after() end
function T.checkpoint()
    if variant=='passive' then
        assert(checked.passive and checked.insurance);lstg.SystemLog('SOURCE_LOGIC: 栖霞园自动Hyper和暂停保险通过');return
    end
    assert(checked.bomb and checked.ranks and checked.hyper and checked.pause and checked.breakHyper and checked.finish)
    lstg.SystemLog('SOURCE_LOGIC: 栖霞园三档装备、Bomb、Hyper 护盾与结束状态通过')
end
return T
