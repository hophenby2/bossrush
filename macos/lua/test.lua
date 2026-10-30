-- 只在显式设置 BOSSRUSH_MAC_TEST 时运行；数据目录由宿主放入临时目录。
local T={}
function T.install()
    local mode=os.getenv('BOSSRUSH_MAC_TEST')
    if not mode then return end
    scoredata.PlayerBrand=scoredata.PlayerBrand or 'Mac测试'
    scoredata.version=ui.version
    if mode=='interactive' or mode=='interactive-battle' then
        AndroidInput.trace=true
        local frame=FrameFunc;local tick=0;local booted=false
        function FrameFunc()
            if player and IsValid(player) then player.protect=120 end
            local quit=frame();tick=tick+1
            if mode=='interactive-battle' and not booted and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=90 then
                booted=true;lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start()
            end
            if tick%15==0 then
                local p=player and IsValid(player) and player
                local f=assert(io.open('User/mac-input.json','wb'))
                f:write(Serialize({stage=stage.current_stage and stage.current_stage.stage_name,x=p and p.x,y=p and p.y,
                    slow=p and p.slow,shoot=p and p.__shoot_flag,preview=AndroidInput.preview,paused=not ext.pause_menu:IsKilled(),
                    mouse=AndroidInput.lastMouse,targetX=AndroidInput.targetX,targetY=AndroidInput.targetY,system=lstg.var.current_system,bombs=GameDrops and GameDrops.bombState(p),fps=lstg.GetFPS()}));f:close()
            end
            return quit
        end
        return
    end
    local started,captured,finished=false,false,false
    local frames,afterCapture,maxBullets=0,0,0
    local beforeCaptureFPS
    local inputTick,inputStart,inputStopped,inputChecked=0,nil,nil,false
    local timings={}
    for _,name in ipairs({'ObjFrame','CollisionCheck','UpdateXY','AfterFrame'}) do
        local fn=_G[name]
        if fn then _G[name]=function(...) local started=lstg.AndroidClock();local values={fn(...)};timings[name]=(timings[name] or 0)+lstg.AndroidClock()-started;return unpack(values) end end
    end
    local original=FrameFunc
    function FrameFunc()
        if player and IsValid(player) then
            player.protect=120
            if mode~='menu' then AndroidInput.keys[setting.keys.shoot]=true end
        end
        local p=player and IsValid(player) and player
        local canInput=mode=='input' and p and not p.lock and not p.dialog and (p.death or 0)==0
        if canInput then
            inputTick=inputTick+1
            if inputTick==10 then
                inputStart={p.x,p.y};AndroidInput.preview=true;AndroidInput.toggles.slow=true;AndroidInput.toggles.shoot=true
                AndroidInput.touch('mac-frame-test',400,300,'began')
            elseif inputTick==11 then AndroidInput.touch('mac-frame-test',432,324,'moved')
            elseif inputTick==60 then ext.pop_pause_menu=true
            elseif inputTick==35 then
                inputStopped={p.x,p.y};AndroidInput.touch('mac-frame-test',432,324,'ended')
            end
        end
        local beforeX,beforeY=p and p.x,p and p.y
        local quit=original()
        if canInput and inputTick>=11 and inputTick<=20 then
            local distance=math.sqrt((p.x-beforeX)^2+(p.y-beforeY)^2)
            assert(math.abs(distance-p.lspeed)<.001,'Mac 逐帧拖拽移速不符')
        end
        if canInput and inputTick==50 then
            assert(math.abs(p.x-inputStart[1]-32)<.001 and math.abs(p.y-inputStart[2]-24)<.001,'Mac 拖拽终点不符')
            assert(p.x==inputStopped[1] and p.y==inputStopped[2],'Mac 抬手后没有立即停止')
            inputChecked=true
        end
        local scene=stage.current_stage
        if scene and scene.stage_name=='menu' and scene.timer>=90 and not started then
            started=true;frames=0
            if mode=='battle' or mode=='input' then
                local draw=RogueTen.draw
                RogueTen.draw=function(seed,width)
                    local plan=draw(seed,width);local chosen
                    for _,bucket in ipairs(RogueTen.buildPool()) do for _,entry in ipairs(bucket.cards) do
                        if entry.cardId==3638 then chosen=entry end
                    end end
                    assert(chosen,'缺少客星测试卡');local out={chosen}
                    for _,entry in ipairs(plan) do if entry.cardId~=3638 and #out<10 then out[#out+1]=entry end end
                    return out
                end
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start()
            elseif mode=='graphics' then
                assert(loadstring(cc.FileUtils:getInstance():getStringFromFile('game/android/graphics_check.lua')))().run()
            end
        end
        if started then
            frames=frames+1
            local count=0
            for _,o in ObjList(GROUP.ENEMY_BULLET) do count=count+1 end
            for _,o in ObjList(GROUP.INDESTRUCTIBLE or GROUP.INDES) do count=count+1 end
            for _,o in ObjList(GROUP.LASER) do count=count+1 end
            maxBullets=math.max(maxBullets,count)
            if frames>=tonumber(os.getenv('BOSSRUSH_MAC_TEST_FRAMES') or (mode=='battle' and '600' or '180')) and not captured then
                beforeCaptureFPS=lstg.GetFPS()
                plus.CreateDirectory('snapshot');Snapshot('snapshot/mac-'..mode..'.png');captured=true
            end
            if captured then
                afterCapture=afterCapture+1
                if afterCapture>=30 and not finished then
                    local f=assert(io.open('User/mac-test.json','wb'))
                    f:write(Serialize({mode=mode,stage=scene.stage_name,frames=frames,peak=maxBullets,
                        renderer=lstg.AndroidRendererInfo(),fps=beforeCaptureFPS,objects=lstg.GetnObj(),jit=jit.status(),timings=timings,input_checked=inputChecked,paused=not ext.pause_menu:IsKilled(),
                        version=lstg.GetVersionName(),data=AndroidPlatform.writable}))
                    f:close();finished=true
                    lstg.SystemLog('BOSSRUSH_MAC_TEST: '..mode..' 通过')
                    return true
                end
            end
        end
        return quit
    end
end
return T
