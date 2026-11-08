-- roguelike 模式持续战斗至生命耗尽；所选卡池抽完后重新洗牌，不重置生命和强化。
-- 只组合已经注册的卡，不修改卡片本身的血量、时限、弹幕或奖励。
local R={POOL_VERSION=5,COUNT=10,MISS_LIMIT=10,NAME='RogueTen',BATTLE='RogueTen@RogueTen',RESULT='RogueResult@RogueTen',
    CHAIN_HP=0.15,CHAIN_TIME_FRAMES=3*60}
R.modes={single={name=R.NAME,battle=R.BATTLE,result=R.RESULT,title='roguelike模式',width=1,record='rogue10'},
    dual={name='RogueDuo',battle='RogueDuo@RogueDuo',result='RogueDuoResult@RogueDuo',title='双Boss随机十战',width=2,record='rogue_dual10'},
    chain={name='RogueChain',battle='RogueChain@RogueChain',result='RogueChainResult@RogueChain',title='接续模式',width=1,record='rogue_chain10',chain=true}}
local function misses() return GameRevive and GameRevive.misses() or lstg.var.dead end
local function mode(run) return R.modes[run and run.mode or 'single'] or R.modes.single end
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
R.sources=poolSource.sources
R.defaultFilters=poolSource.defaults
R.copyFilters=poolSource.copy
R.buildPool=poolSource.build
-- 新的单人模式只需一个候选；显式指定宽度时仍校验旧十战模式的卡数。
function R.poolStatus(filters,width) return poolSource.status(filters,width and R.COUNT*width or 1) end

-- 旧录像初态没有筛选版本，保留旧抽取算法与来源顺序。新局不会走这条路径。
local sources={{level=29,code='TH31'},{level=32,code='TH34'},{level=33,code='TH35'}}
local function replayPoolV1()
    local pool={}
    for _,source in ipairs(sources) do
        local bucket={code=source.code,level=source.level,cards={}}
        for index,unit in ipairs(_sc_pr_table[source.level] or {}) do
            local first=unit.sc_group and unit.sc_group[1]
            local label=unit.CardName or ''
            -- TH34 的最初八张为整段道中载体；其余道中搬运卡由注册标题辨认。
            local id=first and first.card.card_id
            local route=label:find('道中',1,true) or (source.level==32 and id and id>=3400 and id<=3407)
            if first and not route and first.card.is_combat~=false then
                bucket.cards[#bucket.cards+1]={key=source.code..':'..index,index=index,level=source.level,source=source.code,
                    cardId=id,title=label~='' and label or (first.card.is_sc and first.card.name or '非符'),spell=first.card.is_sc==true}
            end
        end
        assert(#bucket.cards>0,'随机十战缺少卡池：'..source.code)
        pool[#pool+1]=bucket
    end
    return pool
end
function R.draw(seed,width,filters,poolVersion,wholePool)
    width=width or 1;assert(width==1 or width==2)
    local pool,total
    if poolVersion==1 then pool=replayPoolV1()
    else
        pool,total=R.buildPool(filters or (width==2 and R.defaultFilters('dual') or nil),poolVersion)
        assert(total>=(wholePool and 1 or R.COUNT*width),'所选随机卡池不足，不能跨池补抽')
    end
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
    local options=R.copyFilters(variant=='single' and (filters or scoredata.rogue10_filters) or R.defaultFilters(variant),variant)
    local endless=variant=='single'
    local status=endless and R.poolStatus(options) or R.poolStatus(options,config.width)
    if not status.valid then return false,status.message end
    -- stage.group.Start立即序列化录像初态；筛选必须先写入lstg.var，不能只放在菜单对象里。
    lstg.var.__rogue_pool_version=R.POOL_VERSION
    -- 是否无限必须进入录像初态，旧十战录像不能因当前模式改动而继续抽卡。
    lstg.var.__rogue_endless_version=endless and 1 or nil
    lstg.var.rogue_filters=options
    lstg.var.rogue_variant=variant
    lstg.var.rogue_run=nil
    if variant=='single' then scoredata.rogue10_filters=R.copyFilters(options) end
    StopMusic('SCORE')
    lstg.var.current_system=''
    stage.group.Start(stage.groups[config.name])
    return true
end
function R.finish(self,won)
    if self.rogue_finished then return end
    self.rogue_finished=true
    local run=lstg.var.rogue_run
    run.won=not run.endless and won and misses()<R.MISS_LIMIT
    run.finished=true
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
    local function prepare(entry)
        local unit=assert(_sc_pr_table[entry.level][entry.index],'随机卡片已移除')
        local class=unit.sc_group[1].boss
        self.level=entry.level
        -- 整局沿用首位 Boss 的场景；符卡背景仍由当前 Boss 自己的 _bg 管理。
        if not self.rogue_scene_ready then
            self.rogue_scene_ready=true
            if class._bg then background.Create(class._bg) end
            self.now_music=class.bgm
            if class.bgm then PlayMusic(class.bgm) end
        end
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
    while run.endless or index<R.COUNT do
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
                run.cards=R.draw(seed,1,run.filters,run.poolVersion,true)
                if #run.cards>1 and run.cards[1].cardId==previous.cardId then
                    run.cards[1],run.cards[2]=run.cards[2],run.cards[1]
                end
                run.cardIndex=1
            end
        end
        local first=run.endless and run.cardIndex or (index-1)*config.width+1
        local entry=run.cards[first]
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
            for _,b in ipairs(active) do while IsValid(b) do task.Wait() end end
        end
        if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
        run.completed=index
        if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_ROGUE: cleared '..index..(run.endless and '' or '/'..R.COUNT)..' '..entry.key) end
        if config.width==2 then task.Wait(90) end
    end
    R.finish(self,true)
end
local panel=Class(object)
local function register(variant,config)
    local group=stage.group.New('menu',{},config.name,false)
    local battle=stage.group.AddStage(config.name,config.battle,false)
    battle.displayname=config.title
    battle.revive_miss_limit=R.MISS_LIMIT-1
    function battle:init()
        self.rogue_finished=false
        self.rogue_scene_ready=false
        self.rogue_chain_ghosts=nil
        self:Option()
        local version=lstg.var.__rogue_pool_version or (ext.replay.IsReplay() and 1 or R.POOL_VERSION)
        local filters=version>=2 and R.copyFilters(lstg.var.rogue_filters,variant,version) or nil
        local endless=variant=='single' and lstg.var.__rogue_endless_version==1
        lstg.var.rogue_run={mode=variant,seed=lstg.var.ran_seed,filters=filters,poolVersion=version,
            cards=R.draw(lstg.var.ran_seed,config.width,filters,version,endless),current=0,completed=0,
            endless=endless,cycle=1,cardIndex=0}
        self.level=29
        task.New(self,function() runCards(self) end)
        New(panel)
        if lstg.SystemLog then
            local keys={};for _,e in ipairs(lstg.var.rogue_run.cards) do keys[#keys+1]=e.key end
            lstg.SystemLog('BOSSRUSH_ROGUE: start seed='..lstg.var.ran_seed..' cards='..table.concat(keys,','))
        end
    end
    function battle:frame()
        releaseChainGhosts(self)
        if self.rogue_finished then stage.group.frame(self);return end
        if misses()>=R.MISS_LIMIT then R.finish(self,false);return end
        stage.group.frame(self)
    end
    function battle:render()
        stage.group.render(self)
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
        SetViewMode('ui');RenderClear(Color(255,12,21,36))
        local c=Color(255,225,241,250);local run=self.run
        local won_title=config.chain and '接续十战达成！' or (config.width==2 and '双Boss十战达成！' or '十战达成！')
        local lost_title=config.chain and '接续本局结束' or (config.width==2 and '双Boss本局结束' or '本局结束')
        ui:RenderText('title',run.won and won_title or lost_title,480,410,1.7,c,'centerpoint')
        local progress=run.endless and string.format('完成 %d 战',run.completed) or string.format('完成 %d / %d 战',run.completed,R.COUNT)
        ui:RenderText('title',progress,480,345,1,c,'centerpoint')
        ui:RenderText('title',string.format('得分 %s    收卡 %d    失误 %d',tostring(run.score),run.captures,run.misses),480,285,0.8,c,'centerpoint')
        ui:RenderText('title',string.format('用时 %.1f 秒 · 种子 %d · 复活 %d / 3',run.elapsed,run.seed,run.revives or 0),480,235,0.65,c,'centerpoint')
        for _,b in ipairs({{300,465,'返回标题 ESC'},{495,660,'再来一局 ENTER'}}) do
            SetImageState('white','',Color(255,29,64,85));RenderRect('white',b[1],b[2],85,125)
            ui:RenderText('title',b[3],(b[1]+b[2])/2,105,0.65,c,'centerpoint')
        end
    end
end
-- 单独的 UI 对象在场景渲染之后显示进度，不遮挡战斗区和右侧原有数据。
function panel:init() self.group=GROUP.GHOST;self.layer=LAYER.TOP end
function panel:render()
    local run=lstg.var.rogue_run
    if not run then return end
    local previous=lstg.viewmode
    SetViewMode('ui')
    local color=Color(255,220,239,250)
    ui:RenderText('title',mode(run).title,150,450,1.0,color,'centerpoint')
    local progress=run.endless and string.format('第 %d 战',math.max(1,run.current)) or string.format('第 %d / %d 战',math.max(1,run.current),R.COUNT)
    ui:RenderText('title',progress,150,420,0.85,color,'centerpoint')
    if run.endless then
        ui:RenderText('title',string.format('已完成 %d 战',run.completed),150,380,0.75,color,'centerpoint')
        ui:RenderText('title',string.format('第 %d 轮 · %d / %d',run.cycle,run.cardIndex,#run.cards),150,347,0.65,color,'centerpoint')
    else
        for i=1,R.COUNT do
            local x=45+((i-1)%5)*43;local y=380-math.floor((i-1)/5)*32
            local done=i<=run.completed;local current=i==run.current
            SetImageState('white','',Color(220,done and 90 or 30,current and 160 or (done and 165 or 55),done and 135 or 80))
            RenderRect('white',x,x+34,y,y+24)
            ui:RenderText('title',tostring(i),x+17,y+12,0.55,color,'centerpoint')
        end
    end
    local config=mode(run)
    for side=1,config.width do
        local first=run.endless and run.cardIndex or (run.current-1)*config.width+1
        local entry=run.cards[first+side-1]
        local text='准备开始'
        if entry then
            local difficulty=entry.difficulty and (entry.difficulty=='extra' and 'Extra/Phantasm · ' or 'Lunatic · ') or ''
            text=entry.source..' · '..difficulty..(entry.kind=='road' and '道中' or (entry.spell and '符卡' or '非符'))
        end
        if config.width==2 then text=(side==1 and '右侧 ' or '左侧 ')..text end
        ui:RenderText('title',text,150,315-(side-1)*25,entry and entry.difficulty=='extra' and 0.55 or 0.65,color,'centerpoint')
    end
    local lives=run.endless and string.format('剩余生命 %d',math.max(0,R.MISS_LIMIT-misses())) or string.format('失误 %d / %d',lstg.var.dead,R.MISS_LIMIT+((lstg.var.revive and lstg.var.revive.credits) or 0))
    ui:RenderText('title',lives,150,mode(run).width==2 and 260 or 285,0.7,color,'centerpoint')
    ui:RenderText('title',string.format('答题复活 %d / 3',(lstg.var.revive and lstg.var.revive.used) or 0),150,mode(run).width==2 and 230 or 255,0.65,color,'centerpoint')
    if previous then SetViewMode(previous) end
end
register('single',R.modes.single)
register('dual',R.modes.dual)
register('chain',R.modes.chain)
RogueTen=R
return R
