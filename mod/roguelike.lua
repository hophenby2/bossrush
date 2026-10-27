-- 简易随机十战：借鉴参考项目的事件抽取与逐步推进，不引入天气、道具或商店。
-- 只组合已经注册的卡，不修改卡片本身的血量、时限、弹幕或奖励。
local R={COUNT=10,MISS_LIMIT=10,NAME='RogueTen',BATTLE='RogueTen@RogueTen',RESULT='RogueResult@RogueTen'}
local sources={{level=29,code='TH31'},{level=32,code='TH34'},{level=33,code='TH35'}}
function R.buildPool()
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
                    title=label~='' and label or (first.card.is_sc and first.card.name or '非符'),spell=first.card.is_sc==true}
            end
        end
        assert(#bucket.cards>0,'随机十战缺少卡池：'..source.code)
        pool[#pool+1]=bucket
    end
    return pool
end
function R.draw(seed)
    local pool=R.buildPool();local gen=Rand();gen:Seed(seed)
    local cards={}
    for step=1,R.COUNT do
        local available={};for _,bucket in ipairs(pool) do if #bucket.cards>0 then available[#available+1]=bucket end end
        assert(#available>0,'随机十战卡池不足')
        local bucket=available[gen:Int(1,#available)]
        cards[step]=table.remove(bucket.cards,gen:Int(1,#bucket.cards))
    end
    return cards
end
function R.start()
    lstg.var.current_system=''
    stage.group.Start(stage.groups[R.NAME])
end
function R.finish(self,won)
    if self.rogue_finished then return end
    self.rogue_finished=true
    local run=lstg.var.rogue_run
    run.won=won and lstg.var.dead<R.MISS_LIMIT
    run.finished=true
    run.score=lstg.var.score;run.misses=lstg.var.dead;run.captures=lstg.var.getsc
    run.elapsed=self.stop_watch:GetElapsed()
    if IsValid(player) then player.lock=true;player.protect=600 end
    if ext.replay.IsReplay() then
        ext.rep_over=true;ext.pop_pause_menu=true
        lstg.tmpvar.pause_menu_text={'再放送','返回标题菜单'}
    else
        if SaveResume then SaveResume.clear() end
        -- 结算单独换场景，回收旧卡的子机、弹池和协程；录像只保留战斗部分。
        stage.Set('none',R.RESULT)
    end
end
local function runCards(self)
    local run=lstg.var.rogue_run
    task.Wait(60)
    for index,entry in ipairs(run.cards) do
        if lstg.var.dead>=R.MISS_LIMIT then R.finish(self,false);return end
        run.current=index
        local unit=assert(_sc_pr_table[entry.level][entry.index],'随机卡片已移除')
        local class=unit.sc_group[1].boss
        self.level=entry.level
        if class._bg then background.Create(class._bg) end
        if self.now_music~=class.bgm then
            if self.now_music then StopMusic(self.now_music) end
            self.now_music=class.bgm
            if class.bgm then PlayMusic(class.bgm) end
        end
        player.protect=math.max(player.protect or 0,90)
        task.Wait(45)
        local active={}
        for i,part in ipairs(unit.sc_group) do active[i]=New(part.boss,{part.card}) end
        for i,b in ipairs(active) do
            for j,other in ipairs(active) do if i~=j then table.insert(b.otherboss,other) end end
        end
        for _,b in ipairs(active) do while IsValid(b) do task.Wait() end end
        if lstg.var.dead>=R.MISS_LIMIT then R.finish(self,false);return end
        run.completed=index
        if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_ROGUE: cleared '..index..'/'..R.COUNT..' '..entry.key) end
        task.Wait(90)
    end
    R.finish(self,true)
end
local panel=Class(object)
local group=stage.group.New('menu',{},R.NAME,false)
local battle=stage.group.AddStage(R.NAME,R.BATTLE,false)
battle.displayname='随机十战'
function battle:init()
    self.rogue_finished=false
    self:Option()
    lstg.var.rogue_run={seed=lstg.var.ran_seed,cards=R.draw(lstg.var.ran_seed),current=0,completed=0}
    self.level=29
    task.New(self,function() runCards(self) end)
    New(panel)
    if lstg.SystemLog then
        local keys={};for _,e in ipairs(lstg.var.rogue_run.cards) do keys[#keys+1]=e.key end
        lstg.SystemLog('BOSSRUSH_ROGUE: start seed='..lstg.var.ran_seed..' cards='..table.concat(keys,','))
    end
end
function battle:frame()
    if self.rogue_finished then stage.group.frame(self);return end
    if lstg.var.dead>=R.MISS_LIMIT then R.finish(self,false);return end
    stage.group.frame(self)
end
function battle:render()
    stage.group.render(self)
end
-- 单独的 UI 对象在场景渲染之后显示进度，不遮挡战斗区和右侧原有数据。
function panel:init() self.group=GROUP.GHOST;self.layer=LAYER.TOP end
function panel:render()
    local run=lstg.var.rogue_run
    if not run then return end
    SetViewMode('ui')
    local color=Color(255,220,239,250)
    ui:RenderText('title','随机十战',150,450,1.15,color,'centerpoint')
    ui:RenderText('title',string.format('第 %d / %d 战',math.max(1,run.current),R.COUNT),150,420,0.85,color,'centerpoint')
    for i=1,R.COUNT do
        local x=45+((i-1)%5)*43;local y=380-math.floor((i-1)/5)*32
        local done=i<=run.completed;local current=i==run.current
        SetImageState('white','',Color(220,done and 90 or 30,current and 160 or (done and 165 or 55),done and 135 or 80))
        RenderRect('white',x,x+34,y,y+24)
        ui:RenderText('title',tostring(i),x+17,y+12,0.55,color,'centerpoint')
    end
    local entry=run.cards[run.current]
    ui:RenderText('title',entry and entry.source..' · '..(entry.spell and '符卡' or '非符') or '准备开始',150,315,0.7,color,'centerpoint')
    ui:RenderText('title',string.format('失误 %d / %d',lstg.var.dead,R.MISS_LIMIT),150,285,0.7,color,'centerpoint')
end
local result=stage.New(R.RESULT,false,true)
result.group=group
function result:init()
    ext.notUIdraw=true
    mask_fader:Do('open')
    self.run=assert(lstg.var.rogue_run)
    self.lockUntil=45
    if not ext.replay.IsReplay() then
        local record=type(scoredata.rogue10)=='table' and scoredata.rogue10 or {}
        for _,key in ipairs({'played','cleared','best_score','best_completed'}) do
            if type(record[key])~='number' or record[key]<0 then record[key]=0 end
        end
        record.played=record.played+1;record.cleared=record.cleared+(self.run.won and 1 or 0)
        record.best_score=math.max(record.best_score,self.run.score)
        record.best_completed=math.max(record.best_completed,self.run.completed)
        scoredata.rogue10=record;SaveScoreData();SaveSpellCardData()
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
    elseif again then R.start() end
end
function result:render()
    SetViewMode('ui');RenderClear(Color(255,12,21,36))
    local c=Color(255,225,241,250);local run=self.run
    ui:RenderText('title',run.won and '十战达成！' or '本局结束',480,410,1.7,c,'centerpoint')
    ui:RenderText('title',string.format('完成 %d / %d 战',run.completed,R.COUNT),480,345,1,c,'centerpoint')
    ui:RenderText('title',string.format('得分 %s    收卡 %d    失误 %d',tostring(run.score),run.captures,run.misses),480,285,0.8,c,'centerpoint')
    ui:RenderText('title',string.format('用时 %.1f 秒 · 种子 %d',run.elapsed,run.seed),480,235,0.65,c,'centerpoint')
    for _,b in ipairs({{300,465,'返回标题 ESC'},{495,660,'再来一局 ENTER'}}) do
        SetImageState('white','',Color(255,29,64,85));RenderRect('white',b[1],b[2],85,125)
        ui:RenderText('title',b[3],(b[1]+b[2])/2,105,0.65,c,'centerpoint')
    end
end
RogueTen=R
return R
