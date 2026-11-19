-- 自机逻辑回归只运行于隔离测试存档。
local T={}
local slow=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='slow'
local checked={}
local duration={reimu={270,400},marisa={300,180},mokou={180,420}}
local initialBombs
function T.before(p)
    local t=stage.current_stage.timer
    local key=AndroidInput.keys
    key[setting.keys.shoot]=t>=10 and t<20
    key[setting.keys.slow]=slow
    key[setting.keys.spell]=t==30
    if t==5 then
        NativePlayers.state().bombs=50
        initialBombs=50
        p.protect=100000
    end
    if t==31 then
        local s=NativePlayers.state()
        assert(s.bombs==initialBombs-1,'原作 Bomb 没有扣一次库存')
        assert(p.cancelOnlyBomb,'原作 Bomb 仍叠加宿主统一伤害')
        local expect=duration[p.machine.id][slow and 2 or 1]
        assert(p.bombTime==expect-1,'原作 Bomb 时长不符')
        checked.bomb=true
        if p.machine.id=='marisa' and slow then assert(p.shield,'幽幽子没有开启护盾') end
    end
    if t==60 and p.machine.id=='marisa' and slow then
        local adapter=NativePlayers.adapters[39]
        assert(adapter.beforeHit(p),'幽幽子护盾没有拦截被弹')
        assert(not p.shield and p.nextspell==60,'幽幽子护盾破裂状态不符')
        checked.shield=true
    end
    if t==650 then
        assert(not p.bombTime and p.nextspell==0,'原作 Bomb 冷却没有结束')
        assert(p.lock_player_shoot==0 and p.lock_player_shift==0,'原作禁射/锁速没有解除')
        if p.machine.id=='mokou' and not slow then assert(p.hspeed==5,'妹红 Bomb 后速度没有恢复') end
        checked.endBomb=true
    end
end
function T.after() end
function T.checkpoint()
    assert(checked.bomb and checked.endBomb,'缺少原作 Bomb 阶段检查')
    lstg.SystemLog('SOURCE_LOGIC: 原作 Bomb、锁速、禁射和冷却通过')
end
return T
