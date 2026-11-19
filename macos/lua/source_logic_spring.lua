-- 春雪篇八套 Bomb：执行原始 SingleBomb/CrazyStorm，核对解锁和冷却。
local T={}
local checked={}
local slow=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='slow'
local patterns={reimu={33,15},marisa={34,16},sanae={17,19},youmu={35,18}}
local duration
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();local key=AndroidInput.keys
    key[setting.keys.shoot]=t>=10 and t<20
    key[setting.keys.slow]=slow
    key[setting.keys.spell]=t==30
    if t==5 then s.bombs=50;p.protect=100000 end
    if t==31 then
        duration=TH37.runtime.loadPattern('e'..patterns[p.machine.id][slow and 2 or 1]).total+40
        assert(s.bombs==45,'春雪篇 Bomb 没有扣除五分片库存')
        assert(p.bombTime==duration and p.nextspell==duration,'春雪篇 Bomb 时长不符')
        assert(p.cancelOnlyBomb,'春雪篇仍叠加宿主统一伤害')
        if slow then assert(p.mhj_source.character.BanBEShoot and p.mhj_source.character.BanEShoot,'低速 Bomb 未禁止主炮/副武器') end
        checked.bomb=true
    end
    if t==690 then
        assert(not p.bombTime and p.nextspell==0,'春雪篇 Bomb 冷却未结束')
        assert(not p.mhj_source.character.BanBEShoot and not p.mhj_source.character.BanEShoot,'春雪篇 Bomb 后禁射未解除')
        local speed=p.mhj_source.character.speedadd;assert(speed.X==1 and speed.Y==1,'春雪篇 Bomb 后移动速度未恢复')
        checked.finish=true
    end
end
function T.after() end
function T.checkpoint()
    assert(checked.bomb and checked.finish)
    lstg.SystemLog('SOURCE_LOGIC: 春雪篇原始 Bomb、自机禁射、减速和恢复通过')
end
return T
