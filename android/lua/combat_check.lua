-- 私有 combat 诊断开关：在测试槽的首战模拟一次失败，验证真实引擎答题与强杀恢复。
-- 放在逻辑入口内，重建输入时也会按相同关卡帧触发；不替玩家作答、不改弹幕参数。
local C={}
function C.install()
    local original=GameRevive.frame
    local last
    GameRevive.frame=function(scene)
        local run=lstg.var.rogue_run
        if scene and not scene.is_menu and scene.revive_miss_limit and run and not run.__combat_check_miss and scene.timer>=160 then
            run.__combat_check_miss=true
            lstg.var.dead=scene.revive_miss_limit+1
        end
        local frozen=original(scene)
        local s=lstg.var.revive;local q=s and s.quiz
        if scene and not scene.is_menu and s then
            local phase=q and (q.result==nil and 'question' or 'feedback') or 'battle'
            local marker=phase..':'..s.used
            if marker~=last then
                last=marker
                local output={phase=phase,frame=scene.timer,dead=lstg.var.dead,used=s.used,quiz=q,seed=lstg.var.ran_seed}
                local f=assert(io.open('User/android-combat-check.json','w'));f:write(Serialize(output));f:close()
                lstg.SystemLog('BOSSRUSH_COMBAT_CHECK: '..Serialize(output))
            end
        end
        return frozen
    end
end
return C
