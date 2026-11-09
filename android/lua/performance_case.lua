-- 仅私有 profile/benchmark case=N 诊断使用，正常游玩不安装。
local T={}
function T.install(mode)
    local card=tonumber(mode:match('case=(%d+)'));if not card then return end
    local target=tonumber(mode:match('frames=(%d+)')) or 900
    local seed=tonumber(mode:match('seed=(%d+)')) or 20261109
    local bombAt,clearAt=tonumber(mode:match('bomb=(%d+)')),tonumber(mode:match('clear=(%d+)'))
    local bombed,cleared=false,false
    scoredata.PlayerBrand=scoredata.PlayerBrand or 'Android性能测试'
    scoredata.version=ui.version
    local originalTime=os.time
    os.time=function(value) return value and originalTime(value) or seed end
    local frame,after=FrameFunc,AfterFrame
    local started,done,caseStarted=false,false
    AfterFrame=function(...)
        after(...)
        local scene=stage.current_stage
        if not done and scene and scene.stage_name=='RogueTen@RogueTen' and scene.timer==target then
            local rows={}
            local groups={1,2,3,4,5,7,8,10}
            if mode:match('all_groups=1') then groups={};for i=0,15 do groups[#groups+1]=i end end
            for _,group in ipairs(groups) do for _,o in ObjList(group) do
                rows[#rows+1]=string.format('%d,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%d',group,o.x,o.y,o.vx,o.vy,o.rot,o.a,o.b,o.timer)
            end end
            lstg.SystemLog(string.format('BOSSRUSH_CASE_DONE: card=%d seed=%d logic_frames=%d objects=%d checkpoint=%s elapsed_s=%.6f',
                card,seed,target,#rows,SaveCodec.sha256(table.concat(rows,'\n')),lstg.AndroidClock()-caseStarted))
            assert(not bombAt or bombed,'未执行测试 Bomb');assert(not clearAt or cleared,'未执行测试换卡')
            local state=assert(io.open('User/android-case-state.txt','wb'))
            state:write(table.concat(rows,'\n'));state:close()
            lstg.SystemLog('BOSSRUSH_CASE_ACTIONS: bomb='..tostring(bombed)..' clear='..tostring(cleared))
            done=true;ext.pop_pause_menu=true
        end
    end
    FrameFunc=function()
        if player and IsValid(player) then player.protect=120 end
        local scene=stage.current_stage
        if started and scene and scene.stage_name=='RogueTen@RogueTen' then
            if not bombed and bombAt and scene.timer==bombAt then
                assert(GameDrops.bombInput(player,{spell=true},{spell=false}),'测试 Bomb 未触发');bombed=true
            end
            if not cleared and clearAt and scene.timer==clearAt then
                assert(_boss and IsValid(_boss),'缺少测试 Boss');_boss.hp=0;cleared=true
            end
        end
        local quit=frame()
        if not started and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            if OriginalCollision then OriginalCollision.use_native=not mode:match('legacy=1') end
            started=true;lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
            local draw=RogueTen.draw
            RogueTen.draw=function(...)
                local plan=draw(...);local chosen
                for _,bucket in ipairs(RogueTen.buildPool()) do for _,entry in ipairs(bucket.cards) do
                    if entry.cardId==card then chosen=entry end
                end end
                assert(chosen,'缺少性能测试卡：'..card)
                local out={chosen};for _,entry in ipairs(plan) do if entry.cardId~=card then out[#out+1]=entry end end
                return out
            end
            assert(RogueTen.start())
            caseStarted=lstg.AndroidClock()
            lstg.SystemLog('BOSSRUSH_CASE_BEGIN: '..mode)
        end
        return quit
    end
end
return T
