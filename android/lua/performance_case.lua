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
    local probe
    local stateTrace
    AfterFrame=function(...)
        after(...)
        local scene=stage.current_stage
        if probe and not done then probe.after(scene) end
        if not done and mode:match('snap=1') and scene and scene.stage_name=='RogueTen@RogueTen' and
            (scene.timer==630 or scene.timer==720 or scene.timer==780) then
            if not plus.DirectoryExists('snapshot') then plus.CreateDirectory('snapshot') end
            Snapshot('snapshot/android-case-'..scene.timer..'.png')
        end
        if stateTrace and not done and scene and scene.stage_name=='RogueTen@RogueTen' then
            local records={}
            for group=0,15 do for _,o in ObjList(group) do
                records[#records+1]=string.format('%d,%d,%.17g,%.17g,%.17g,%.17g,%.17g,%.17g,%.17g,%d,%s',
                    scene.timer,group,o.x,o.y,o.vx,o.vy,o.rot,o.a,o.b,o.timer,tostring(o.colli))
                local function vm(v)
                    if not (v and v.data and v.data.key and v.id) then return end
                    local values={v.data.key,tostring(v.id),tostring(v.pc),string.format('%.17g',v.time),
                        tostring(v.visible),tostring(v.finished),tostring(v.stopped),tostring(v.sprite),v.blend}
                    for _,field in ipairs({'position','rotation','scale','color','alpha','color2','alpha2','omega','growth'}) do
                        for _,n in ipairs(v[field]) do values[#values+1]=string.format('%.17g',n) end
                    end
                    records[#records+1]='vm,'..table.concat(values,',')
                    for _,child in ipairs(v.children) do vm(child) end
                end
                vm(o._native_anm or o.vm)
            end end
            stateTrace:write(table.concat(records,'\n'),'\n')
        end
        if not done and scene and scene.stage_name=='RogueTen@RogueTen' and scene.timer==target then
            local rows={}
            local groups={1,2,3,4,5,7,8,10}
            if mode:match('all_groups=1') then groups={};for i=0,15 do groups[#groups+1]=i end end
            for _,group in ipairs(groups) do for _,o in ObjList(group) do
                rows[#rows+1]=string.format('%d,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%d',group,o.x,o.y,o.vx,o.vy,o.rot,o.a,o.b,o.timer)
            end end
            local current=_boss and IsValid(_boss) and _boss.current_card
            lstg.SystemLog(string.format('BOSSRUSH_CASE_DONE: card=%d active_card=%s seed=%d logic_frames=%d objects=%d checkpoint=%s elapsed_s=%.6f',
                card,tostring(current and current.card_id or 'none'),seed,target,#rows,SaveCodec.sha256(table.concat(rows,'\n')),lstg.AndroidClock()-caseStarted))
            assert(not bombAt or bombed,'未执行测试 Bomb');assert(not clearAt or cleared,'未执行测试换卡')
            if probe then probe.finish() end
            if stateTrace then stateTrace:close();stateTrace=nil end
            local state=assert(io.open('User/android-case-state.txt','wb'))
            state:write(table.concat(rows,'\n'));state:close()
            lstg.SystemLog('BOSSRUSH_CASE_ACTIONS: bomb='..tostring(bombed)..' clear='..tostring(cleared))
            done=true;ext.pop_pause_menu=true
        end
    end
    FrameFunc=function()
        if player and IsValid(player) then player.protect=120 end
        if mode:match('shoot=0') then
            AndroidInput.toggles.shoot=false;AndroidInput.keys[setting.keys.shoot]=false
        end
        local scene=stage.current_stage
        if started and scene and scene.stage_name=='RogueTen@RogueTen' then
            if mode:match('hold=1') and _boss and IsValid(_boss) then _boss.hp=_boss.maxhp end
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
            if mode:match('probe=1') then
                probe=dofile('android/performance_probe.lua');probe.install(mode)
            end
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
            if mode:match('state=full') then stateTrace=assert(io.open('User/android-case-frames.txt','wb')) end
            caseStarted=lstg.AndroidClock()
            lstg.SystemLog('BOSSRUSH_CASE_BEGIN: '..mode)
        end
        return quit or done and mode:match('quit=1')~=nil
    end
end
return T
