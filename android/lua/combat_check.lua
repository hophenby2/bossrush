-- 私有 combat 诊断开关：在测试槽的首战模拟一次失败，验证真实引擎答题与强杀恢复。
-- 放在逻辑入口内，重建输入时也会按相同关卡帧触发；不替玩家作答、不改弹幕参数。
local C={}
function C.install(mode)
    local original=GameRevive.frame
    local last,booted,paused
    local automatic=mode and (mode:match('combat%-new') or mode:match('combat%-resume'))
    local rankCheck=mode and mode:match('rank') and GameRank
    local movement
    if rankCheck then
        local after=GameRank.afterObjects
        GameRank.afterObjects=function()
            local sample
            if not movement and GameRank.inObjects and GameRank.state().captures>0 then
                for _,o in ObjList(GROUP.ENEMY_BULLET) do
                    if o._rank_move_stamp==GameRank.stamp and o.status=='normal' and o.rank_speed~=false then
                        local dx,dy=o.x-o._rank_move_x,o.y-o._rank_move_y
                        if dx*dx+dy*dy>0.01 and dx*dx+dy*dy<4096 then
                            sample={o=o,x=o._rank_move_x,y=o._rank_move_y,dx=dx,dy=dy,factor=GameRank.frameFactor};break
                        end
                    end
                end
            end
            after()
            if sample and IsValid(sample.o) then
                assert(math.abs(sample.o.x-(sample.x+sample.dx*sample.factor))<0.001,'Rank 实际横向位移不符')
                assert(math.abs(sample.o.y-(sample.y+sample.dy*sample.factor))<0.001,'Rank 实际纵向位移不符')
                movement={factor=sample.factor,dx=sample.dx,dy=sample.dy,verified=true}
            end
        end
    end
    GameRevive.frame=function(scene)
        -- 自动入口避免依赖菜单动画时长；仍通过游戏正常的开局与续玩 API。
        if automatic and not booted and scene and scene.stage_name=='menu' and scene.timer>=120 then
            booted=true
            if rankCheck then
                local draw=RogueTen.draw
                RogueTen.draw=function(seed,width)
                    local plan=draw(seed,width);local chosen={}
                    for _,bucket in ipairs(RogueTen.buildPool()) do for _,entry in ipairs(bucket.cards) do
                        if entry.cardId==3660 then chosen[1]=entry elseif entry.cardId==384 then chosen[2]=entry end
                    end end
                    assert(chosen[1] and chosen[2]);local result={chosen[1],chosen[2]}
                    for _,entry in ipairs(plan) do
                        if entry.cardId~=3660 and entry.cardId~=384 and #result<20 then result[#result+1]=entry end
                    end
                    return result
                end
            end
            if mode:match('combat%-resume') then SaveResume.request();paused=true
            else lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start('dual') end
        end
        local run=lstg.var.rogue_run
        if rankCheck and scene and not scene.is_menu and run and not run.__rank_check_capture and scene.timer>=120 then
            run.__rank_check_capture=true
            local b={is_sc=true,otherboss={}};GameRank.beginCard(b,{card_id=0,t1=1,t3=2});GameRank.capture(b)
        end
        if scene and not scene.is_menu and scene.revive_miss_limit and run and not run.__combat_check_miss and scene.timer>=160 then
            run.__combat_check_miss=true
            lstg.var.dead=scene.revive_miss_limit+1
            if GameRank then GameRank.miss() end
        end
        local frozen=original(scene)
        local s=lstg.var.revive;local q=s and s.quiz
        if automatic and q and q.age>=20 and not paused and not SaveResume.recovering then
            paused=true;ext.pop_pause_menu=true
        end
        if scene and not scene.is_menu and s then
            local phase=q and (q.result==nil and 'question' or 'feedback') or 'battle'
            local marker=phase..':'..s.used
            if marker~=last then
                last=marker
                local output={phase=phase,frame=scene.timer,dead=lstg.var.dead,used=s.used,quiz=q,seed=lstg.var.ran_seed}
                if rankCheck then
                    local health={}
                    for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do for _,b in ObjList(group) do
                        if b.IsBoss and b._rank_hp_ready then
                            assert(math.abs(b.maxhp-b.current_card.hp*b._rank_hp_factor)<0.001,'Rank 实际 Boss 血量不符')
                            health[#health+1]={hp=b.maxhp,base=b.current_card.hp,factor=b._rank_hp_factor}
                        end
                    end end
                    output.rank=lstg.var.rank;output.movement=movement;output.health=health
                end
                local f=assert(io.open('User/android-combat-check.json','w'));f:write(Serialize(output));f:close()
                lstg.SystemLog('BOSSRUSH_COMBAT_CHECK: '..Serialize(output))
            end
        end
        return frozen
    end
end
return C
