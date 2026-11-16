-- 只在显式设置 BOSSRUSH_MAC_TEST 时运行；数据目录由宿主放入临时目录。
local T={}
function T.install()
    local mode=os.getenv('BOSSRUSH_MAC_TEST')
    if not mode then return end
    local fixedSeed=tonumber(os.getenv('BOSSRUSH_MAC_TEST_SEED') or '')
    local sequenceKey=os.getenv('BOSSRUSH_MAC_TEST_SEQUENCE')
    if sequenceKey=='' then sequenceKey=nil end
    local bdbChapter=os.getenv('BOSSRUSH_MAC_TEST_TH40_CHAPTER')
    local fanChapter=os.getenv('BOSSRUSH_MAC_TEST_FAN_CHAPTER') or bdbChapter
    local fanVisual=os.getenv('BOSSRUSH_MAC_TEST_FAN_VISUAL')=='1'
    local fanDraws,fanHUD,fanDeathWave=0,0,0
    local bdbAdvance=tonumber(os.getenv('BOSSRUSH_MAC_TEST_TH40_ADVANCE') or '')
    local bdbSeen={}
    local bdbChapterDone=false
    local bdbRequireMotion=os.getenv('BOSSRUSH_MAC_TEST_TH40_MOTION')=='1'
    local bdbCheckHP=os.getenv('BOSSRUSH_MAC_TEST_TH40_BOSS_HP')=='1'
    local bdbTarget,bdbHit
    local bdbMotion,bdbSample=0,0
    local bdbPrevious=setmetatable({},{__mode='k'})
    local nativeMachine=os.getenv('BOSSRUSH_MAC_TEST_MACHINE')
    local nativeProbe=nativeMachine and dofile('macos/native_player_probe.lua')
    if fanVisual then
        local texture,rect,quad,post=RenderTexture,RenderRect,Render4V,PostEffect
        RenderTexture=function(name,...)
            if name:match('^th37_mesh_') then fanDraws=fanDraws+1 end
            if name:match('^mhj_hud_') or name=='th40_hud' then fanHUD=fanHUD+1 end
            return texture(name,...)
        end
        RenderRect=function(name,...)
            if name:match('^th39_scene_') then fanDraws=fanDraws+1 end
            if name:match('^th38_meter_') or name:match('^th40_hud') then fanHUD=fanHUD+1 end
            return rect(name,...)
        end
        Render4V=function(name,...)
            if lstg.viewmode=='3d' and (name:match('^th38_bg_') or name:match('^th40/')) then fanDraws=fanDraws+1 end
            return quad(name,...)
        end
        PostEffect=function(name,...)
            if name=='th38_death_invert' then fanDeathWave=fanDeathWave+1 end
            return post(name,...)
        end
    end
    local battleCard=tonumber(os.getenv('BOSSRUSH_MAC_TEST_CARD') or '') or 3638
    local fixedFocus=os.getenv('BOSSRUSH_MAC_TEST_FOCUS')=='1'
    local battleShoot=os.getenv('BOSSRUSH_MAC_TEST_SHOOT')~='0'
    local visuals
    if os.getenv('BOSSRUSH_MAC_TEST_VISUAL')=='1' then
        visuals={trails=0,halos=0,low_primary=0}
        local textureDraw=RenderTexture
        RenderTexture=function(name,...)
            if name:match('^original/7/stg%d+enm/') then visuals.trails=visuals.trails+1 end
            return textureDraw(name,...)
        end
        local draw=OriginalANM.draw
        OriginalANM.draw=function(vm,...)
            if vm.data.key=='8/etama' and vm.id>=48 and vm.id<=50 then visuals.halos=visuals.halos+1 end
            local args={...};if args[8] then visuals.low_primary=visuals.low_primary+1 end
            return draw(vm,...)
        end
    end
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
    local mhjRepeated,mhjFirstHash=false,nil
    local mhjDamageChecked,mhjDamageProbe=false,nil
    local mhjMoves,mhjSamples=0,0
    local aslPatterns={}
    local mhjPrevious=setmetatable({},{__mode='k'})
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
            if scene and (scene.stage_name=='RogueTen@RogueTen' or scene.stage_name=='Spell Practice@Spell Practice' or sequenceKey and scene.group and scene.group.sequence_key==sequenceKey) and scene.timer==logicalTarget and not checkpoint then
                if nativeProbe then nativeProbe.checkpoint() end
                local rows={}
                for _,group in ipairs({1,2,3,4,5,7,8,10}) do
                    for _,o in ObjList(group) do
                        if (o.mhj or o.asl) and o.img and (o.img:match('^mhj2_') or o.img:match('^mhj3_') or o.img:match('^asl_')) then assert(CheckRes('img',o.img)=='global','幕华祭动态精灵落入临时关卡池') end
                        rows[#rows+1]=string.format('%d,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%.5f,%d',group,o.x,o.y,o.vx,o.vy,o.rot,o.a,o.b,o.timer)
                    end
                end
                table.sort(rows)
                local hash=SaveCodec.sha256(table.concat(rows,';'))
                if os.getenv('BOSSRUSH_MAC_TEST_TH37_REPEAT')=='1' and not mhjRepeated then
                    mhjFirstHash=hash;mhjRepeated=true;stage.Restart();return
                end
                if mhjFirstHash then assert(hash==mhjFirstHash,'练习重试后的同种子弹幕状态不一致') end
                checkpoint=hash
                checkpointAt=scene.timer
                beforeCaptureFPS=lstg.GetFPS()
            end
        end
    end
    local original=FrameFunc
    function FrameFunc()
        if mode=='battle' then AndroidFocus=function() end end
        if player and IsValid(player) then
            player.protect=120
            if mode=='battle' or mode=='input' then AndroidInput.keys[setting.keys.shoot]=true end
            if mode=='battle' and not battleShoot then AndroidInput.keys[setting.keys.shoot]=false;AndroidInput.toggles.shoot=false end
            if fixedFocus then AndroidInput.keys[setting.keys.slow]=true;AndroidInput.toggles.slow=true end
        end
        local p=player and IsValid(player) and player
        if bdbCheckHP and p then
            if not bdbTarget then
                for _,b in ipairs(boss_group) do
                    if IsValid(b) and b.is_combat and b.th40_card then
                        assert(b.hp==b.current_card.hp and b.group==GROUP.NONTJT and b.a==32,'栖霞园 Boss 初始血量或受击框错误')
                        bdbTarget=b
                        break
                    end
                end
            end
            if bdbTarget and IsValid(bdbTarget) then
                p.x=bdbTarget.x
                bdbHit=bdbHit or bdbTarget.hp<bdbTarget.maxhp
                AndroidInput.keys[setting.keys.shoot]=not bdbHit
            end
        end
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
        if nativeProbe and p and p.machine then nativeProbe.before(p) end
        if not (logicalTarget and captured) then quit=original() end
        if nativeProbe and p and IsValid(p) and p.machine then nativeProbe.after(p) end
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
        if bdbAdvance and sequenceKey then
            if scene and scene.timer>0 and scene.timer%10000==0 then
                local run=lstg.var.sequence_run
                lstg.SystemLog(string.format('TH40 顺序第 %d 帧 [%s]',scene.timer,run and run.chapter_name or ''))
            end
            for _,b in ipairs(boss_group) do
                local card=IsValid(b) and b.current_card
                if card and b.is_combat and b.th40_card then
                    local id=tostring(card.card_id or card.phase_name)
                    if not bdbSeen[id] then
                        bdbSeen[id]=true
                        lstg.SystemLog(string.format('TH40 第 %d 帧进入卡段 %s',scene.timer,id))
                    end
                    if b.timer>=bdbAdvance then b.hp=0 end
                end
            end
        end
        local mhj3Damage=os.getenv('BOSSRUSH_MAC_TEST_TH39_DAMAGE')=='1'
        if not nativeProbe and (mhj3Damage or os.getenv('BOSSRUSH_MAC_TEST_TH37_DAMAGE')=='1' or os.getenv('BOSSRUSH_MAC_TEST_TH38_DAMAGE')=='1') and sequenceKey and scene and scene.group and scene.group.sequence_key==sequenceKey then
            local probeAt=mhj3Damage and 120 or 90
            if scene.timer==probeAt and not mhjDamageProbe then
                local fairy
                if mhj3Damage then
                    local R=TH39.runtime
                    fairy=New(R.classes.fairy,R.stageState(1),
                        {type=2,x=336,y=255,speed=0,speedf=0,life=300,hp=100,id=-1,events={}})
                    fairy.mhj.age=32
                elseif os.getenv('BOSSRUSH_MAC_TEST_TH38_DAMAGE')=='1' then
                    local s={c={closed=false},alive=true,kind='enemy',x=4.5,y=70/48-4.8,life=100,color=5,enemyStyle=1,collision=true,age=1,immune=0,hit=.3}
                    fairy=New(TH38.runtime.classes.fairy,s)
                else
                    fairy=New(TH37.runtime.classes.fairy,TH37.runtime.stageState(1),
                        {type=7,x=224,y=170,speed=0,speedf=0,life=300,hp=100,id=-1})
                end
                local shotClass=Class(object,{
                    init=function(o) o.x,o.y=0,70;o.a,o.b=3,3;o.group=GROUP.PLAYER_BULLET;o.layer=LAYER.PLAYER_BULLET;o.dmg=30;o.mute=true end,
                },true)
                mhjDamageProbe={enemy=fairy,shot=New(shotClass)}
            elseif scene.timer==probeAt+4 and mhjDamageProbe and not mhjDamageChecked then
                assert(IsValid(mhjDamageProbe.enemy) and mhjDamageProbe.enemy.hp==70,'原生道中敌机未通过真实碰撞扣除30血量')
                assert(not IsValid(mhjDamageProbe.shot),'命中敌机的自机弹未消耗')
                object.Del(mhjDamageProbe.enemy);mhjDamageChecked=true
            end
        end
        if scene and scene.stage_name=='menu' and scene.timer>=90 and not started then
            started=true;frames=0;benchmarkStart=lstg.AndroidClock()
            if mode=='battle' or mode=='input' then
                if fanChapter then
                    local entry=assert(OriginalSequence.catalog.get(sequenceKey))
                    local port=assert(_G['TH'..(entry.level+2)])
                    local run=port.runChapter
                    port.runChapter=function(scene,chapter)
                        if chapter.name==fanChapter then run(scene,chapter);bdbChapterDone=true end
                    end
                end
                if sequenceKey then
                    OriginalSequence.start(sequenceKey,nativeMachine or 'reimu')
                elseif battleCard>=41000 and battleCard<48000 and TH40 then
                    local index
                    for _,row in ipairs(TH40.units()) do if row.id==battleCard then index=row.index end end
                    assert(index,'缺少栖霞园测试阶段：'..battleCard)
                    lstg.var.sc_index,lstg.var.sc_group=index,{38,index}
                    stage.group.PracticeStart('Spell Practice@Spell Practice',true,nativeMachine)
                elseif battleCard>=39000 and battleCard<40000 and TH39 then
                    local index
                    for _,row in ipairs(TH39.units()) do
                        if row.unit.sc_group[1].card.card_id==battleCard then index=row.index end
                    end
                    assert(index,'缺少永夜篇测试阶段：'..battleCard)
                    lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
                    lstg.var.sc_index,lstg.var.sc_group=index,{37,index}
                    stage.group.PracticeStart('Spell Practice@Spell Practice',true,nativeMachine)
                elseif battleCard>=38000 and battleCard<39000 and TH38 then
                    local index
                    for i,unit in ipairs(_sc_pr_table[36]) do if unit.sc_group[1].card.card_id==battleCard then index=i end end
                    assert(index,'缺少雪莲华测试阶段：'..battleCard)
                    lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
                    lstg.var.sc_index,lstg.var.sc_group=index,{36,index}
                    stage.group.PracticeStart('Spell Practice@Spell Practice',true,nativeMachine)
                elseif battleCard>=37000 and battleCard<38000 and TH37 then
                    local index
                    for i,unit in ipairs(_sc_pr_table[35]) do if unit.sc_group[1].card.card_id==battleCard then index=i end end
                    assert(index,'缺少幕华祭测试阶段：'..battleCard)
                    lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
                    lstg.var.sc_index,lstg.var.sc_group=index,{35,index}
                    stage.group.PracticeStart('Spell Practice@Spell Practice',true,nativeMachine)
                else
                local draw=RogueTen.draw
                RogueTen.draw=function(seed,width)
                    local plan=draw(seed,width);local chosen
                    for _,bucket in ipairs(RogueTen.buildPool()) do for _,entry in ipairs(bucket.cards) do
                        if entry.cardId==battleCard then chosen=entry end
                    end end
                    assert(chosen,'缺少测试卡：'..battleCard);local out={chosen}
                    for _,entry in ipairs(plan) do if entry.cardId~=battleCard and #out<10 then out[#out+1]=entry end end
                    return out
                end
                setting.touchUnlimited=unlimited
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start()
                end
            elseif mode=='graphics' then
                assert(loadstring(cc.FileUtils:getInstance():getStringFromFile('game/android/graphics_check.lua')))().run()
            elseif mode=='fog' then
                assert(loadstring(cc.FileUtils:getInstance():getStringFromFile('game/android/fog_check.lua')))().run()
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
            if TH38 then for c in pairs(TH38.runtime.controllers) do if not c.closed then aslPatterns[c.key]=true end end end
            local count=0
            for _,o in ObjList(GROUP.ENEMY_BULLET) do count=count+1 end
            for _,o in ObjList(GROUP.INDESTRUCTIBLE or GROUP.INDES) do count=count+1 end
            for _,o in ObjList(GROUP.LASER) do count=count+1 end
            maxBullets=math.max(maxBullets,count)
            if bdbRequireMotion then
                for _,o in ObjList(GROUP.ENEMY_BULLET) do
                    if o.th40_bullet then
                        local prior=bdbPrevious[o]
                        if prior and o.timer>16 and (math.abs(o.vx)+math.abs(o.vy))>.1 then
                            bdbSample=bdbSample+1
                            if math.abs(o.x-prior[1])+math.abs(o.y-prior[2])>.01 then bdbMotion=bdbMotion+1 end
                        end
                        bdbPrevious[o]={o.x,o.y}
                    end
                end
            end
            if sequenceKey or battleCard>=37000 then
                for _,group in ipairs({GROUP.ENEMY_BULLET,GROUP.INDES,GROUP.LASER}) do
                    for _,o in ObjList(group) do if o.mhj or o.asl then
                        local old=mhjPrevious[o]
                        local motion=o.asl or o.mhj
                        local speed=o.asl and motion.speed or motion.sonspeed
                        if old and motion.age>16 and math.abs(speed or 0)>0.1 then
                            mhjSamples=mhjSamples+1
                            if math.abs(o.x-old[1])+math.abs(o.y-old[2])>0.01 then mhjMoves=mhjMoves+1 end
                        end
                        mhjPrevious[o]={o.x,o.y}
                    end end
                end
            end
            if bdbAdvance and scene and (scene.sequence_finished or bdbChapterDone) and not checkpoint then
                checkpoint='sequence-finished'
                checkpointAt=scene.timer
                beforeCaptureFPS=lstg.GetFPS()
            end
            local ready=logicalTarget and checkpoint or (not logicalTarget and frames>=tonumber(os.getenv('BOSSRUSH_MAC_TEST_FRAMES') or (mode=='battle' and '600' or '180')))
            if mode=='fog' then ready=scene.stage_name=='android_fog' and scene.timer>=181 end
            if ready and not captured then
                beforeCaptureFPS=beforeCaptureFPS or lstg.GetFPS()
                plus.CreateDirectory('snapshot');Snapshot('snapshot/mac-'..mode..'.png');captured=true
            end
            if captured then
                afterCapture=afterCapture+1
                if afterCapture>=30 and not finished then
                    if bdbAdvance and sequenceKey then
                        local entry=OriginalSequence.catalog.get(sequenceKey)
                        if entry and entry.native=='thbdb' then
                            assert(checkpoint=='sequence-finished','栖霞园顺序流程未结束')
                            for _,chapter in ipairs(OriginalSequence.catalog.chapters(sequenceKey,'reimu')) do
                                for _,row in ipairs(chapter.units) do
                                    assert(bdbChapter and chapter.name~=bdbChapter or row.role=='road' or bdbSeen[tostring(row.id)],
                                        '栖霞园顺序漏过阶段 '..row.id)
                                end
                            end
                        end
                    end
                    if bdbRequireMotion then assert(bdbMotion>0 and bdbSample>0,'栖霞园实体弹未随速度移动') end
                    if bdbCheckHP then assert(bdbHit,'实际自机射击未扣除栖霞园 Boss 血量') end
                    if fanVisual then
                        assert(fanDraws>0 and fanHUD>0,'背景或原作 HUD 未提交绘制')
                        if nativeProbe and sequenceKey=='thasl_lunatic' then
                            assert(fanDeathWave>0,'雪莲华掉命反色波未提交')
                        end
                    end
                    local f=assert(io.open('User/mac-test.json','wb'))
                    f:write(Serialize({mode=mode,card=battleCard,fan_draws=fanDraws,fan_hud=fanHUD,fan_death_wave=fanDeathWave,bdb_motion=bdbMotion,bdb_sample=bdbSample,bdb_seen=bdbSeen,asl_patterns=aslPatterns,asl_bullet_pool=TH38 and TH38.runtime.bulletCount,mhj_moves=mhjMoves,mhj_samples=mhjSamples,mhj_damage_checked=mhjDamageChecked,mhj_repeated=mhjRepeated,focus=fixedFocus,visuals=visuals,stage=scene.stage_name,frames=frames,peak=maxBullets,
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
    local step=tonumber(os.getenv('BOSSRUSH_MAC_TEST_TH40_STEP') or '')
    if step and step>1 then
        local frame=FrameFunc
        function FrameFunc()
            for _=1,step do if frame() then return true end end
        end
    end
end
return T
