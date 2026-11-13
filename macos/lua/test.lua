-- 只在显式设置 BOSSRUSH_MAC_TEST 时运行；数据目录由宿主放入临时目录。
local T={}
function T.install()
    local mode=os.getenv('BOSSRUSH_MAC_TEST')
    if not mode then return end
    local fixedSeed=tonumber(os.getenv('BOSSRUSH_MAC_TEST_SEED') or '')
    local sequenceKey=os.getenv('BOSSRUSH_MAC_TEST_SEQUENCE')
    local nativeMachine=os.getenv('BOSSRUSH_MAC_TEST_MACHINE')
    local nativeProbe=nativeMachine and
        mode~='native-port-practice' and mode~='native-port-sequence' and mode~='th38-sequence'
        and dofile('macos/native_player_probe.lua')
    local battleCard=tonumber(os.getenv('BOSSRUSH_MAC_TEST_CARD') or '') or 3638
    local fixedFocus=os.getenv('BOSSRUSH_MAC_TEST_FOCUS')=='1'
    local battleShoot=os.getenv('BOSSRUSH_MAC_TEST_SHOOT')~='0'
    local nativePort=mode=='native-port-sequence' or mode=='native-port-practice'
    local portShoot=nativePort and os.getenv('BOSSRUSH_MAC_TEST_SHOOT')=='1'
    local portRules=nativePort and os.getenv('BOSSRUSH_MAC_TEST_RULES')=='1'
    local portLoadout=portRules and {1,1,1,3,1,1} or nil
    local portRulesChecked=false
    local portInitialLife,portInitialBombs
    local hazard=portRules and Class(object,{
        init=function(o,p)
            o.group=GROUP.ENEMY_BULLET
            o.x,o.y,o.a,o.b,o.colli=p.x,p.y,3,3,true
        end,
    },true)
    local isSequence=mode=='th38-sequence' or mode=='native-port-sequence'
    local sequenceSpeed=(isSequence or mode=='native-port-practice') and tonumber(os.getenv('BOSSRUSH_MAC_TEST_SPEED') or '1') or 1
    local sequenceKill=tonumber(os.getenv('BOSSRUSH_MAC_TEST_KILL') or '')
    local sequenceEnd=os.getenv('BOSSRUSH_MAC_TEST_END')=='1'
    local sequenceResult,sequencePhases={},{}
    local portBoss,portPhase,portPhaseTime
    if sequenceSpeed>1 then
        -- 加速只验对象/流程；音效在正常帧率另测，避免超实时重启耗尽OpenAL音源队列。
        PlaySound=function() end;lstg.PlaySound=function() end
    end
    local nativePortrait=nativePort and os.getenv('BOSSRUSH_MAC_TEST_PORTRAIT')=='1'
    if nativePortrait then
        AndroidPortrait=assert(loadfile("android/portrait.lua"))()
        setting.androidPortrait=true
        -- 在 16:9 原生窗口内以竖屏逻辑画布和竖屏裁切执行同一渲染路径。
        AndroidPortrait.enabled=function() return stage.current_stage and not stage.current_stage.is_menu end
        AndroidPortrait.resetScreen=function()
            if not AndroidPortrait.enabled() then return false end
            screen.width,screen.height=540,960
            screen.scale=setting.resy/960
            screen.dx=(setting.resx-540*screen.scale)/2
            screen.dy=0
            return true
        end
    end
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
    local frames,afterCapture,maxBullets,maxLasers=0,0,0,0
    local portDamage=0
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
            if mode=='battle' or mode=='input' or portShoot then
                AndroidInput.keys[setting.keys.shoot]=true
            end
            if mode=='battle' and not battleShoot then AndroidInput.keys[setting.keys.shoot]=false;AndroidInput.toggles.shoot=false end
            if fixedFocus then AndroidInput.keys[setting.keys.slow]=true;AndroidInput.toggles.slow=true end
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
        if nativeProbe and p and p.machine then nativeProbe.before(p) end
        if not (logicalTarget and captured) then
            for _=1,sequenceSpeed do
                if isSequence then
                    if player and IsValid(player) then player.protect=120 end
                    if portRules and p and p.native_level then
                        local t=stage.current_stage.timer
                        local s=assert(NativePlayers.state())
                        if t==90 then
                            portInitialLife,portInitialBombs=s.life,s.bombs
                            assert(portInitialLife==2 and portInitialBombs==2 and p.machine.id==nativeMachine)
                            if p.native_level==40 then
                                assert(p.setupGroup==p.machine.character and p.optionSlots[4]==3 and p.specialMode==1)
                            end
                            AndroidInput.keys[setting.keys.spell]=true
                        elseif t==91 then
                            AndroidInput.keys[setting.keys.spell]=false
                        elseif t==100 then
                            assert(s.life==portInitialLife and s.bombs==portInitialBombs-1,
                                ('原作自机 Bomb 库存未扣除，残机 %s，库存 %s，原始库存 %s，锁 %s，Fever %s'):format(
                                    s.life,s.bombs,lstg.var.bomb,tostring(p.bombLock),tostring(p.specialGauge)))
                        elseif t==460 then
                            p.protect=0
                            New(hazard,p)
                        elseif t==461 then
                            assert(p.hit or (p.playerStateTimer or 0)>=260,'原作自机未收到原生碰撞')
                        elseif t==530 then
                            assert(s.life==portInitialLife-1 and lstg.var.dead==1,'受击后残机未扣除')
                            portRulesChecked=true
                        end
                    end
                    for _,b in ipairs(boss_group or {}) do
                        local run=b.th38_run
                        if run then
                            local meta=b.current_card and b.current_card.th38_source
                            if meta and not sequencePhases[tostring(meta.id)] then sequencePhases[tostring(meta.id)]=true;lstg.SystemLog('BOSSRUSH_TH38_PHASE: '..meta.id) end
                            if sequenceKill and run.host.age>=sequenceKill then b.hp=0 end
                        end
                    end
                    local current=lstg.var.sequence_run
                    if current then
                        if nativePort and current.chapter~=sequenceResult.chapter then
                            lstg.SystemLog('BOSSRUSH_PORT_CHAPTER: '..current.chapter)
                        end
                        sequenceResult={chapter=current.chapter,road_time=current.road_time,completed=current.completed,total=current.total,finished=current.finished,won=current.won}
                        local rt=nativePort and GameContent.ports[40].source.runtime
                        local actor=rt and rt.boss
                        if actor and IsValid(actor) then
                            sequenceResult.boss={type=actor.spawnType,state=actor.state,phase=actor.portPhase,time=actor.helperTimer,hp=actor.hp}
                        elseif rt then
                            sequenceResult.enemies=rt.enemyCount
                        end
                    end
                end
                if sequenceKill and nativePort and GameContent and GameContent.ports[40] then
                    local theis=GameContent.ports[39].source
                    local b=theis._boss
                    if b and IsValid(b) and b.current_card and b.current_card.is_combat
                        and b.timer>=sequenceKill and b.dmg_factor>0 then
                        b.hp=0
                    end
                    local rt=GameContent.ports[40].source.runtime
                    local o=rt and rt.boss
                    if o and IsValid(o) then
                        if o~=portBoss or o.portPhase~=portPhase then
                            portBoss,portPhase,portPhaseTime=o,o.portPhase,0
                        end
                        if o.targetable and not o.protect then
                            portPhaseTime=portPhaseTime+1
                            if portPhaseTime>=sequenceKill then o.hp=0 end
                        end
                    end
                end
                quit=original();if quit then break end
            end
        end
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
            if isSequence then
                AndroidFocus=function() end
                local first=tonumber(os.getenv('BOSSRUSH_MAC_TEST_FIRST_CHAPTER') or '')
                if first then
                    local run=OriginalSequence.run
                    OriginalSequence.run=function(s,key,resume)
                        if not resume then
                            local entry=OriginalSequence.catalog.get(key)
                            local chapters=OriginalSequence.catalog.chapters(key,lstg.var.player_name)
                            assert(first>=1 and first<=#chapters,'测试起始章节超出范围')
                            lstg.var.sequence_run={key=key,title=entry.title,total=#chapters,completed=first-1}
                        end
                        return run(s,key,resume or first)
                    end
                end
                OriginalSequence.start(os.getenv('BOSSRUSH_MAC_TEST_SEQUENCE') or 'thsss_lunatic',
                    nativeMachine or os.getenv('BOSSRUSH_MAC_TEST_ROUTE'),portLoadout)
            elseif mode=='native-port-practice' or (mode=='battle' or mode=='input') and battleCard>=68000 and battleCard<69000 then
                AndroidFocus=function() end
                local index
                local level=battleCard>=71100 and 40 or battleCard>=70100 and 39 or 38
                for i,u in ipairs(_sc_pr_table[level]) do if u.sc_group[1].card.card_id==battleCard then index=i end end
                assert(index,'缺少原作测试卡：'..battleCard)
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';lstg.var.sc_group={level,index}
                stage.group.PracticeStart('Spell Practice@Spell Practice',true,nativeMachine)
            elseif mode=='battle' or mode=='input' then
                if sequenceKey then
                    OriginalSequence.start(sequenceKey,nativeMachine or 'reimu')
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
            if nativePortrait and AndroidPortrait.enabled() then AndroidPortrait.resetScreen() end
            frames=frames+1
            if portShoot then
                local s=NativePlayers.state()
                if s and s.level==38 then
                    for _,actor in ipairs(boss_group) do
                        if actor.th38_run and actor.colli and actor.maxhp then
                            portDamage=math.max(portDamage,actor.maxhp-actor.hp)
                        end
                    end
                elseif s then
                    local source=GameContent.ports[s.level].source
                    local actor=s.level==39 and source._boss or source.runtime and source.runtime.boss
                    if actor and IsValid(actor) and actor.maxhp then
                        portDamage=math.max(portDamage,actor.maxhp-actor.hp)
                    end
                end
            end
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
            local laserCount=0
            for _,o in ObjList(GROUP.LASER) do
                count=count+1;laserCount=laserCount+1
                if o.run and o.IsBentLaser then assert(bent_laser.RenderFunc[o.sample],'夏夜祭曲线激光没有渲染器') end
            end
            maxLasers=math.max(maxLasers,laserCount)
            maxBullets=math.max(maxBullets,count)
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
            local ready=logicalTarget and checkpoint or (not logicalTarget and frames>=tonumber(os.getenv('BOSSRUSH_MAC_TEST_FRAMES') or (mode=='battle' and '600' or '180')))
            if isSequence and sequenceEnd then ready=sequenceResult.finished==true end
            if mode=='fog' then ready=scene.stage_name=='android_fog' and scene.timer>=181 end
            if ready and not captured then
                beforeCaptureFPS=beforeCaptureFPS or lstg.GetFPS()
                plus.CreateDirectory('snapshot');Snapshot('snapshot/mac-'..mode..'.png');captured=true
            end
            if captured then
                afterCapture=afterCapture+1
                if afterCapture>=30 and not finished then
                    if portRules then assert(portRulesChecked,'原作自机资源检查未完成') end
                    local f=assert(io.open('User/mac-test.json','wb'))
                    f:write(Serialize({mode=mode,card=battleCard,sequence=sequenceResult,sequence_phases=sequencePhases,focus=fixedFocus,visuals=visuals,stage=scene.stage_name,frames=frames,peak=maxBullets,peak_lasers=maxLasers,port_damage=portShoot and portDamage or nil,port_rules=portRules and portRulesChecked or nil,
                        asl_patterns=aslPatterns,asl_bullet_pool=TH38 and TH38.runtime.bulletCount,mhj_moves=mhjMoves,mhj_samples=mhjSamples,mhj_damage_checked=mhjDamageChecked,mhj_repeated=mhjRepeated,
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
