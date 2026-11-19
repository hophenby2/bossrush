-- 春雪篇结界充能与主动破裂不消耗Bomb库存。
local T={};local checked={}
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();local v=p.mhj_source.sakura;local key=AndroidInput.keys
    key[setting.keys.spell]=t==30
    if t==5 then s.bombs=50;p.protect=100000;v.Power=v.hipower end
    if t==7 then assert(v.Status==1,'樱花结界未开启');checked.open=true end
    if t==15 then
        local before=v.Power;NativePlayers.adapters[35].graze()
        assert(v.Power==before+8,'樱花结界擦弹充能不符');checked.graze=true
    end
    if t==32 then assert(v.Status==2 and s.bombs==50,'主动破裂结界消耗了Bomb');checked.breaking=true end
    if t==120 then assert(v.Status==0,'樱花结界破裂后未关闭');checked.finish=true end
end
function T.after() end
function T.checkpoint()
    assert(checked.open and checked.graze and checked.breaking and checked.finish)
    lstg.SystemLog('SOURCE_LOGIC: 春雪篇樱花结界充能与主动破裂通过')
end
return T
