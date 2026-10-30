-- 只在显式设置 BOSSRUSH_MAC_TEST 时运行；数据目录由宿主放入临时目录。
local T={}
function T.install()
    local mode=os.getenv('BOSSRUSH_MAC_TEST')
    if not mode then return end
    local fixedSeed=tonumber(os.getenv('BOSSRUSH_MAC_TEST_SEED') or '')
    if fixedSeed then
        local time=os.time
        os.time=function(value) if value then return time(value) end;return fixedSeed end
    end
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
    local checkpoint,checkpointAt
    local logicalTarget=tonumber(os.getenv('BOSSRUSH_MAC_TEST_LOGIC_FRAMES') or '')
    local benchmarkStart
    local audioCalls,audioChecked,audioMusic=0,false,nil
    local settingsObject,settingsChecked,bombBefore,inputBombChecked
    local unlimited=os.getenv('BOSSRUSH_MAC_TEST_UNLIMITED')=='1'
    local inputTick,inputStart,inputStopped,inputChecked=0,nil,nil,false
    local timings={}
    for _,name in ipairs({'ObjFrame','CollisionCheck','UpdateXY','AfterFrame'}) do
        local fn=_G[name]
        if fn then _G[name]=function(...) local started=lstg.AndroidClock();local values={fn(...)};timings[name]=(timings[name] or 0)+lstg.AndroidClock()-started;return unpack(values) end end
    end
    if logicalTarget then
        local after=AfterFrame
        function AfterFrame(...)
            after(...)
            local scene=stage.current_stage
            if scene and scene.stage_name=='RogueTen@RogueTen' and scene.timer==logicalTarget and not checkpoint then
                local rows={}
                for _,group in ipairs({1,2,3,4,5,7,8,10}) do
                    for _,o in ObjList(group) do
                        rows[#rows+1]=string.format('%d,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%d',group,o.x,o.y,o.vx,o.vy,o.rot,o.a,o.b,o.timer)
                    end
                end
                table.sort(rows)
                checkpoint=SaveCodec.sha256(table.concat(rows,';'))
                checkpointAt=scene.timer
                beforeCaptureFPS=lstg.GetFPS()
            end
        end
    end
    local original=FrameFunc
    function FrameFunc()
        if player and IsValid(player) then
            player.protect=120
            if mode=='battle' or mode=='input' then AndroidInput.keys[setting.keys.shoot]=true end
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
        local quit=false
        if not (logicalTarget and captured) then quit=original() end
        if canInput and inputTick>=11 and inputTick<=20 then
            local distance=math.sqrt((p.x-beforeX)^2+(p.y-beforeY)^2)
            local expected=unlimited and (inputTick==11 and 40 or 0) or p.lspeed
            assert(math.abs(distance-expected)<.001,'Mac 逐帧拖拽移速不符')
        end
        if canInput and inputTick==50 then
            assert(math.abs(p.x-inputStart[1]-32)<.001 and math.abs(p.y-inputStart[2]-24)<.001,'Mac 拖拽终点不符')
            assert(p.x==inputStopped[1] and p.y==inputStopped[2],'Mac 抬手后没有立即停止')
            inputChecked=true
        end
        if canInput and inputTick==51 then
            bombBefore=GameDrops.bombState(p)
            AndroidInput.touch('mac-tap',400,300,'began');AndroidInput.touch('mac-tap',400,300,'ended')
        elseif canInput and inputTick==52 then
            AndroidInput.touch('mac-tap',400,300,'began');AndroidInput.touch('mac-tap',400,300,'ended')
        elseif canInput and inputTick==54 then
            assert(GameDrops.bombState(p)==bombBefore-1,'双击未在真实引擎中释放一枚 Bomb')
            inputBombChecked=true
        end
        local scene=stage.current_stage
        if scene and scene.stage_name=='menu' and scene.timer>=90 and not started then
            started=true;frames=0;benchmarkStart=lstg.AndroidClock()
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
                setting.touchUnlimited=unlimited
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start()
            elseif mode=='graphics' then
                assert(loadstring(cc.FileUtils:getInstance():getStringFromFile('game/android/graphics_check.lua')))().run()
            elseif mode=='audio' then
                -- 自动化运行不因切回编辑器而暂停；使用固定循环曲，避免菜单曲切换影响断言。
                AndroidFocus=function() end
                audioMusic='SCORE';PlayMusic(audioMusic)
            elseif mode=='settings' then
                settingsObject=New(game_setting,function() end)
                assert(#settingsObject.menus==6 and settingsObject.menus[6].display_name=='触控','缺少触控设置页')
                assert(cur_setting.touchBombInterval==100 and cur_setting.touchUnlimited==false,'触控默认值错误')
                settingsObject.menus[1].choosing=false;settingsObject.menus[6].choosing=true
                settingsObject.pos1=6;settingsObject.alpha=1;settingsObject.locked=false
                settingsObject.menus[6].setting_item[1].choosing=true
                cur_setting.touchBombInterval=250;cur_setting.touchUnlimited=true;save_setting();loadConfigure()
                assert(setting.touchBombInterval==250 and setting.touchUnlimited==true,'触控设置未持久保存')
                settingsChecked=true
            end
        end
        if started then
            frames=frames+1
            if mode=='audio' and frames<=120 then
                if not audioMusic then for _,name in ipairs(EnumRes2('bgm')) do if GetMusicState(name)=='playing' then audioMusic=name;break end end end
                for i=1,16 do lstg.PlaySound('damage00',.05,.25);audioCalls=audioCalls+1 end
                assert(GetSoundState('damage00')=='playing','高频音效未正常播放')
                if frames==60 then
                    PauseSound('damage00');assert(GetSoundState('damage00')=='paused','音效暂停状态不符')
                    ResumeSound('damage00');assert(GetSoundState('damage00')=='playing','音效恢复状态不符')
                elseif frames==61 then
                    -- x 引擎把已释放的音源也归入 paused；这里只验证停止后不再播放。
                    StopSound('damage00');assert(GetSoundState('damage00')~='playing','音效未停止播放')
                elseif frames==120 then
                    assert(audioMusic and GetMusicState(audioMusic)=='playing','高频音效打断了 BGM')
                    audioChecked=true;StopSound('damage00')
                end
            end
            local count=0
            for _,o in ObjList(GROUP.ENEMY_BULLET) do count=count+1 end
            for _,o in ObjList(GROUP.INDESTRUCTIBLE or GROUP.INDES) do count=count+1 end
            for _,o in ObjList(GROUP.LASER) do count=count+1 end
            maxBullets=math.max(maxBullets,count)
            local ready=logicalTarget and checkpoint or (not logicalTarget and frames>=tonumber(os.getenv('BOSSRUSH_MAC_TEST_FRAMES') or (mode=='battle' and '600' or '180')))
            if ready and not captured then
                beforeCaptureFPS=beforeCaptureFPS or lstg.GetFPS()
                plus.CreateDirectory('snapshot');Snapshot('snapshot/mac-'..mode..'.png');captured=true
            end
            if captured then
                afterCapture=afterCapture+1
                if afterCapture>=30 and not finished then
                    local f=assert(io.open('User/mac-test.json','wb'))
                    f:write(Serialize({mode=mode,stage=scene.stage_name,frames=frames,peak=maxBullets,
                        input_bomb_checked=inputBombChecked,unlimited=unlimited,settings_checked=settingsChecked,audio_calls=audioCalls,audio_checked=audioChecked,checkpoint=checkpoint,logic_frames=checkpointAt,elapsed=benchmarkStart and lstg.AndroidClock()-benchmarkStart,workers=lstg.GetThreadPoolSize(),audio=lstg.MacAudioInfo and lstg.MacAudioInfo(),renderer=lstg.AndroidRendererInfo(),fps=beforeCaptureFPS,objects=lstg.GetnObj(),jit=jit.status(),timings=timings,input_checked=inputChecked,paused=not ext.pause_menu:IsKilled(),
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
