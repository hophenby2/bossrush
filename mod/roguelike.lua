-- roguelike 模式持续战斗至生命耗尽；所选卡池抽完后重新洗牌，不重置生命和强化。
-- 复用原卡的标定值，阶段倍率只作用于运行中的敌机，不改共享卡表、时限或弹幕。
local R={COUNT=10,MISS_LIMIT=10,NAME='RogueTen',BATTLE='RogueTen@RogueTen',RESULT='RogueResult@RogueTen',
    CHAIN_HP=0.15,CHAIN_TIME_FRAMES=3*60}
local titles=dofile('mod/rogue_titles.lua')
R.modes={single={name=R.NAME,battle=R.BATTLE,result=R.RESULT,title='混沌模式',width=1,record='rogue10'},
    staged={name='RogueTwo',battle='RogueTwo@RogueTwo',result='RogueTwoResult@RogueTwo',title='挑战模式',width=1,record='rogue2',count=38,progression=true},
    dual={name='RogueDuo',battle='RogueDuo@RogueDuo',result='RogueDuoResult@RogueDuo',title='双Boss随机十战',width=2,record='rogue_dual10'},
    chain={name='RogueChain',battle='RogueChain@RogueChain',result='RogueChainResult@RogueChain',title='接续模式',width=1,record='rogue_chain10',chain=true}}
local function misses() return lstg.var.dead end
local function mode(run) return R.modes[run and run.mode or 'single'] or R.modes.single end
function R.usesTitleOverlay()
    local run=lstg.var.rogue_run
    return run and not run.finished and stage.current_stage and stage.current_stage.stage_name==mode(run).battle
end
local function chainDone(b)
    if not IsValid(b) then return true,'gone' end
    if not b.is_combat or b.__is_waiting then return false end
    local maxhp=tonumber(b.maxhp)
    if maxhp and maxhp>0 and b.hp and b.hp<=maxhp*R.CHAIN_HP then return true,'hp' end
    local t3,timer=tonumber(b.t3),tonumber(b.timer)
    if t3 and timer and t3-timer<R.CHAIN_TIME_FRAMES then return true,'time' end
    return false
end
R.chainDone=chainDone
local function holdChainGhost(battle, previous, active)
    local previousAlive=false
    for _,b in ipairs(previous) do
        if IsValid(b) then previousAlive=true;break end
    end
    if not previousAlive then return end
    local watch={previous=previous,active={},groups={}}
    for _,b in ipairs(active) do
        if IsValid(b) then
            watch.active[#watch.active+1]=b
            watch.groups[#watch.groups+1]=b.group or GROUP.ENEMY
            b.group=GROUP.GHOST
        end
    end
    if #watch.active==0 then return end
    battle.rogue_chain_ghosts=battle.rogue_chain_ghosts or {}
    battle.rogue_chain_ghosts[#battle.rogue_chain_ghosts+1]=watch
end
local function releaseChainGhosts(battle)
    local watches=battle.rogue_chain_ghosts
    if not watches then return end
    for i=#watches,1,-1 do
        local watch=watches[i]
        local previousAlive=false
        for _,b in ipairs(watch.previous) do
            if IsValid(b) then previousAlive=true;break end
        end
        for j,b in ipairs(watch.active) do
            if IsValid(b) then b.group=previousAlive and GROUP.GHOST or watch.groups[j] end
        end
        if not previousAlive then table.remove(watches,i) end
    end
end
local poolSource=dofile('mod/rogue_pool.lua')
local staged=assert(loadfile('mod/rogue_staged.lua'))(poolSource)
local rogueMusic=dofile('mod/rogue_music.lua')
local encounter=dofile('mod/rogue_encounter.lua')
RogueBossHUD=dofile('mod/rogue_boss_hud.lua')
R.sources=poolSource.sources
R.defaultFilters=poolSource.defaults
R.copyFilters=poolSource.copy
R.buildPool=poolSource.build
function R.savedFilters(variant)
    if variant=='staged' then
        local options=R.copyFilters(scoredata.rogue2_filters,'staged')
        -- 过去固定包含耐久卡，保存的true不是用户勾选过的新选项。
        if not scoredata.rogue2_survival_configured then options.cards.survival=false end
        return options
    end
    return R.copyFilters(scoredata.rogue10_filters)
end
-- 单人无限模式只需一个候选；双 Boss 与接续模式校验完整十战所需卡数。
function R.poolStatus(filters,width,variant)
    if variant=='staged' then return poolSource.stageStatus(filters) end
    return poolSource.status(filters,width and R.COUNT*width or 1)
end
R.STAGE_COUNTS=poolSource.STAGE_COUNTS
-- 战斗和结算使用同一进度口径；模式2按抽卡路线的每面张数换算，不读取当前作品的面数。
function R.progressLabel(run)
    if mode(run).progression then return staged.label(run) end
    return tostring(math.max(1,math.floor(run.current or run.completed or 1)))
end
R.progressAlpha=staged.alpha
function R.afterLogic(scene)
    local run=lstg.var.rogue_run
    if scene and scene.stage_name==R.modes.staged.battle and run and not run.finished then staged.choiceFrame(run) end
end

R.buildStagePool=poolSource.buildStages
function R.drawStages(seed,filters)
    return staged.draw(seed,filters)
end

function R.draw(seed,width,filters,wholePool)
    width=width or 1;assert(width==1 or width==2)
    local pool,total=R.buildPool(filters or (width==2 and R.defaultFilters('dual') or nil))
    assert(total>=(wholePool and 1 or R.COUNT*width),'所选随机卡池不足，不能跨池补抽')
    local count=wholePool and total or R.COUNT*width
    local gen=Rand();gen:Seed(seed)
    local cards={}
    for step=1,count do
        local available={};for _,bucket in ipairs(pool) do if #bucket.cards>0 then available[#available+1]=bucket end end
        assert(#available>0,'随机十战卡池不足')
        local bucket=available[gen:Int(1,#available)]
        cards[step]=table.remove(bucket.cards,gen:Int(1,#bucket.cards))
        if width==2 then
            for _,other in ipairs(pool) do
                for i=#other.cards,1,-1 do if other.cards[i].cardId==cards[step].cardId then table.remove(other.cards,i) end end
            end
        end
    end
    return cards
end
function R.start(variant,filters)
    variant=variant or 'single'
    local config=assert(R.modes[variant])
    local configurable=variant=='single' or config.progression
    local options=R.copyFilters(configurable and (filters or R.savedFilters(variant)) or R.defaultFilters(variant),variant)
    local endless=variant=='single'
    local status=endless and R.poolStatus(options) or R.poolStatus(options,config.width,variant)
    if not status.valid then return false,status.message end
    -- stage.group.Start立即序列化录像初态；筛选必须先写入lstg.var，不能只放在菜单对象里。
    lstg.var.rogue_filters=options
    lstg.var.rogue_variant=variant
    local record=scoredata[config.record]
    lstg.var.rogue_extend_unlocked=config.progression and type(record)=='table'
        and type(record.cleared)=='number' and record.cleared>0 or false
    lstg.var.rogue_run=nil
    if variant=='single' then scoredata.rogue10_filters=R.copyFilters(options) end
    if config.progression then
        scoredata.rogue2_filters=R.copyFilters(options,variant)
        scoredata.rogue2_survival_configured=true
    end
    StopMusic('SCORE')
    lstg.var.current_system=''
    stage.group.Start(stage.groups[config.name])
    return true
end
function R.finish(self,won)
    if self.rogue_finished then return end
    self.rogue_finished=true
    local run=lstg.var.rogue_run
    staged.clearChoice(run)
    run.stage_banner,run.banner_queue,run.card_title=nil,{},nil
    encounter.stop(self)
    -- 六面已经通关后，无尽挑战耗尽生命仍按胜利结算。
    run.won=run.cleared==true or (not run.endless and won and misses()<R.MISS_LIMIT)
    run.finished=true
    rogueMusic.stop(self)
    if GameNet and GameNet.host() then GameNet.finish(run.won) end
    run.score=lstg.var.score;run.misses=lstg.var.dead;run.captures=lstg.var.getsc
    run.revives=lstg.var.revive and lstg.var.revive.used or 0
    run.elapsed=self.stop_watch:GetElapsed()
    if IsValid(player) then player.lock=true;player.protect=600 end
    if ext.replay.IsReplay() then
        ext.rep_over=true;ext.pop_pause_menu=true
        lstg.tmpvar.pause_menu_text={'再放送','返回标题菜单'}
    else
        if SaveResume then SaveResume.clear() end
        -- 结算单独换场景，回收旧卡的子机、弹池和协程；录像只保留战斗部分。
        stage.Set('none',mode(run).result)
    end
end
local function runCards(self)
    local run=lstg.var.rogue_run
    task.Wait(60)
    local config=mode(run)
    local count=config.count or R.COUNT
    -- 正常入口已在独立资源任务中预载；续玩重建和独立工具入口仍可自行准备。
    if not self.rogue_resources_ready then self:prepareResources() end
    local function prepare(entry)
        local port=encounter.begin(self,entry)
        if GameHPScale then GameHPScale.enter(run.current) end
        local unit=assert(_sc_pr_table[entry.level][entry.index],'随机卡片已移除')
        local class=unit.sc_group[1].boss
        self.level=entry.level
        if port then encounter.prepare(self,entry,unit) end
        -- 首张卡的真实关卡背景整局保留；这里只切换音乐及当前符卡背景。
        if run.mode=='staged' then
            -- 模式2整局连续轮播；换卡只更新攻击和符卡背景，不重启歌曲。
            self.rogue_scene_ready=true
            if not rogueMusic.start(self,class.bgm) then rogueMusic.resume(self) end
        elseif port then
            rogueMusic.stop(self)
            if self.now_music then StopMusic(self.now_music) end
            self.rogue_scene_ready=false
            -- Lua 原作后端须先装载本关资源，再由自身入口播放配乐。
            self.now_music=entry.level<=37 and class.bgm or nil
            if self.now_music then PlayMusic(self.now_music) end
        elseif not self.rogue_scene_ready then
            self.rogue_scene_ready=true
            self.now_music=class.bgm
            if class.bgm and not rogueMusic.start(self,class.bgm) then
                if not rogueMusic.resume(self) then PlayMusic(class.bgm) end
            end
        end
        if config.progression then staged.announce(run) end
        player.protect=math.max(player.protect or 0,90)
        return unit
    end
    local function spawnSingle(unit)
        local active={}
        for i,part in ipairs(unit.sc_group) do active[i]=New(part.boss,{part.card}) end
        for i,b in ipairs(active) do
            for j,other in ipairs(active) do if i~=j then table.insert(b.otherboss,other) end end
        end
        return active
    end
    local function retire(active)
        for _,b in ipairs(active) do
            if IsValid(b) and IsValid(b.ui) then
                b.NotPlayTimeOutSound=true
                b.ui.no_infobar=true;b.ui.no_timeCounter=true;b.ui.no_pointer=true
            end
        end
    end
    if config.chain then
        local previous
        for index=1,R.COUNT do
            if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
            run.current=index
            local entry=run.cards[index]
            local unit=prepare(entry)
            if index==1 then task.Wait(45) end
            local active=spawnSingle(unit)
            titles.announce(run,entry)
            -- 旧 Boss 死亡时不能清掉仍在战斗的其他 Boss 弹幕，结算 / 爆炸共用此开关。
            for _,b in ipairs(active) do b.__NoCleanBullet=true end
            if previous then holdChainGhost(self,previous,active) end
            previous=active
            while true do
                local done=true
                for _,b in ipairs(active) do if not chainDone(b) then done=false;break end end
                if done then break end
                task.Wait()
            end
            if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
            run.completed=index
            if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_CHAIN: advance '..index..'/'..R.COUNT..' '..entry.key) end
            if index==R.COUNT then R.finish(self,true);return end
            retire(active)
        end
        return
    end
    local index=0
    while run.endless or run.overtime or index<count do
        index=index+1
        if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
        run.current=index
        if run.endless then
            run.cardIndex=run.cardIndex+1
            if run.cardIndex>#run.cards then
                local previous=run.cards[#run.cards]
                run.cycle=run.cycle+1
                -- 每轮使用独立种子，抽卡不消耗弹幕随机数；只保留当前轮，避免无限积累路线。
                local seed=(run.seed+(run.cycle-1)*104729)%2147483647
                run.cards=R.draw(seed,1,run.filters,true)
                if #run.cards>1 and run.cards[1].cardId==previous.cardId then
                    run.cards[1],run.cards[2]=run.cards[2],run.cards[1]
                end
                run.cardIndex=1
            end
        end
        local first=run.endless and run.cardIndex or (index-1)*config.width+1
        local entry
        if run.overtime then entry=staged.nextEndless(run) else entry=run.cards[first] end
        local unit=prepare(entry)
        -- 单 Boss 只保留首战入场；后续战在上一位死亡后立即创建。双 Boss 节奏不变。
        if index==1 or config.width==2 then task.Wait(45) end
        local active,owners={},{}
        if config.width==2 then
            for side=1,2 do
                local card=run.cards[first+side-1]
                local owner=RogueDualRuntime.context(card.source,side==1 and 96 or -96)
                owners[side]=owner;active[side]=owner:spawn(card)
            end
            titles.announce(run,entry,run.cards[first+1])
            -- 两张不同卡各自结算，不能使用同卡双人的 otherboss 同步逻辑。
            while true do
                local alive=false
                for side,b in ipairs(active) do
                    if IsValid(b) then alive=true else owners[side]:cleanup() end
                end
                if not alive then break end
                task.Wait()
            end
        else
            active=spawnSingle(unit)
            titles.announce(run,entry)
            for _,b in ipairs(active) do while IsValid(b) do task.Wait() end end
        end
        run.card_title=nil
        local cleared=config.progression and not run.overtime and index==count
        if cleared then run.cleared=true;run.completed=index end
        if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
        run.completed=index
        if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_ROGUE: cleared '..index..((run.endless or run.overtime) and '' or '/'..count)..' '..entry.key) end
        encounter.stop(self)
        if cleared then
            staged.beginChoice(run)
            local choice=run.endless_choice
            while not choice.answer do task.Wait() end
            if choice.answer==2 then R.finish(self,true);return end
            staged.beginEndless(run,choice.answer==3)
        end
        if config.width==2 then task.Wait(90) end
    end
    R.finish(self,true)
end
local panel=Class(object)
local function register(variant,config)
    local group=stage.group.New('menu',{},config.name,false)
    local battle=stage.group.AddStage(config.name,config.battle,false)
    battle.displayname=config.title
    function battle:prepareResources()
        encounter.warmup(self)
        self.rogue_resources_ready=true
    end
    function battle:init()
        self.rogue_resources_ready=false
        self.rogue_finished=false
        self.rogue_scene_ready=false
        self.rogue_chain_ghosts=nil
        self:Option()
        local filters=R.copyFilters(lstg.var.rogue_filters,variant)
        local endless=variant=='single'
        local cards
        if config.progression then cards=R.drawStages(lstg.var.ran_seed,filters)
        else cards=R.draw(lstg.var.ran_seed,config.width,filters,endless) end
        lstg.var.rogue_run={mode=variant,seed=lstg.var.ran_seed,filters=filters,total=config.count or R.COUNT,
            cards=cards,current=0,completed=0,enhanced=filters.rules.enhanced,
            cleared=false,extend_unlocked=lstg.var.rogue_extend_unlocked==true,
            endless=endless,cycle=1,cardIndex=0}
        if GameHPScale then GameHPScale.init(lstg.var.rogue_run) end
        -- 曲库取本模式四作的全部原有配乐，不因只选某一Boss而退化成单曲循环。
        local musicFilters=R.defaultFilters();musicFilters.cards.survival=true;musicFilters.encounters.road=true
        for _,source in ipairs(dofile('mod/rogue_ports.lua').sources) do musicFilters.stages[source.code]=false end
        rogueMusic.init(lstg.var.rogue_run,R.buildPool(musicFilters))
        self.level=29
        task.New(self,function() runCards(self) end)
        New(panel)
        if lstg.SystemLog then
            local keys={};for _,e in ipairs(lstg.var.rogue_run.cards) do keys[#keys+1]=e.key end
            lstg.SystemLog('BOSSRUSH_ROGUE: start seed='..lstg.var.ran_seed..' cards='..table.concat(keys,','))
        end
    end
    function battle:frame()
        encounter.frame(self.timer)
        if GameHPScale then GameHPScale.frame() end
        staged.frame(lstg.var.rogue_run)
        titles.frame(lstg.var.rogue_run)
        releaseChainGhosts(self)
        if self.rogue_finished then stage.group.frame(self);return end
        if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
        stage.group.frame(self)
    end
    function battle:render()
        stage.group.render(self)
    end
    function battle:del()
        staged.clearChoice(lstg.var.rogue_run)
        encounter.stop(self)
        encounter.release()
        rogueMusic.stop(self)
    end
    local result=stage.New(config.result,false,true)
    result.group=group
    function result:init()
        ext.notUIdraw=true
        mask_fader:Do('open')
        self.run=assert(lstg.var.rogue_run)
        self.lockUntil=45
        if not ext.replay.IsReplay() then
            local record=type(scoredata[config.record])=='table' and scoredata[config.record] or {}
            for _,key in ipairs({'played','cleared','best_score','best_completed'}) do
                if type(record[key])~='number' or record[key]<0 then record[key]=0 end
            end
            record.played=record.played+1;record.cleared=record.cleared+(self.run.won and 1 or 0)
            record.best_score=math.max(record.best_score,self.run.score)
            record.best_completed=math.max(record.best_completed,self.run.completed)
            scoredata[config.record]=record;SaveScoreData();SaveSpellCardData()
        end
        PlayMusic('SCORE')
        if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_ROGUE: result won='..tostring(self.run.won)..' completed='..self.run.completed) end
    end
    local function overButton(x,y,left,right) return x>=left and x<=right and y>=85 and y<=125 end
    function result:frame()
        if self.timer<self.lockUntil then return end
        menu:Updatekey()
        local mouse=ext.mouse
        local back=menu:keyNo() or (mouse:isDown(1) and overButton(mouse.x,mouse.y,300,465))
        local again=menu:keyYes() or (mouse:isDown(1) and overButton(mouse.x,mouse.y,495,660))
        if back then stage.group.ReturnToTitle(true,self.run.won and 1 or 0)
        elseif again then R.start(self.run.mode,self.run.filters) end
    end
    -- SCORE 是全局资源，切场景不会卸载它；返回标题、重开和外部切场都须停播。
    function result:del()
        StopMusic('SCORE')
    end
    function result:render()
        if AndroidPortrait and AndroidPortrait.enabled() then return AndroidPortrait.result(self) end
        SetViewMode('ui');RenderClear(Color(255,12,21,36))
        local c=Color(255,225,241,250);local run=self.run
        ui:RenderText('title',run.won and '胜利' or '挑战结束',480,420,1.2,c,'centerpoint')
        ui.RunHUD.stage(R.progressLabel(run),480,270,560)
        for _,b in ipairs({{300,465,'保存录像 ESC'},{495,660,'不保存录像并重新开始 ENTER'}}) do
            SetImageState('white','',Color(255,29,64,85));RenderRect('white',b[1],b[2],85,125)
            ui:RenderText('title',b[3],(b[1]+b[2])/2,105,0.65,c,'centerpoint')
        end
    end
end
-- 战斗和结算共用数字排版，避免阶段号在不同场景采用不同口径。
function panel:init() self.group=GROUP.GHOST;self.layer=LAYER.TOP+90 end
function panel:render()
    local run=lstg.var.rogue_run
    if not run then return end
    if AndroidPortrait and AndroidPortrait.enabled() then
        AndroidPortrait.roguePanel(run);staged.render(run);titles.render(run);return
    end
    local previous=lstg.viewmode
    SetViewMode('ui')
    ui.RunHUD.stage(R.progressLabel(run),lstg.world.scrl/2,270,lstg.world.scrl,nil,staged.alpha(run))
    if run.preparing then
        local text=run.preloadTotal and ('加载资源 '..run.preloadIndex..' / '..run.preloadTotal) or '准备下一战…'
        ui:RenderText('title',text,lstg.world.scrl/2,220,.5,Color(255,255,255,255),'centerpoint')
    end
    if GameHPScale then GameHPScale.render(lstg.world.scrl/2,165) end
    staged.render(run)
    titles.render(run)
    if previous then SetViewMode(previous) end
end
register('single',R.modes.single)
register('staged',R.modes.staged)
register('dual',R.modes.dual)
register('chain',R.modes.chain)
RogueTen=R
return R
