-- 顺序模式独立于练习与随机局；路线key、流程版本随录像初态保存。
local S={VERSION=1,MISS_LIMIT=10}
S.catalog=dofile('mod/sequence_catalog.lua')
S.clock=dofile('mod/sequence_clock.lua')
OriginalSequence=S
dofile('mod/sequence_media.lua')
local flow=OriginalStageFlow
local ids=dofile('mod/GAME/original/card_ids.lua')
local function valid(o) return o and IsValid(o) end
function S.enabled() return lstg.var.__sequence_version==S.VERSION end
function S.context()
    local owner=task.stack and task.stack[#task.stack]
    return owner and owner._sequence_road_context
end
local function find(level,id)
    id=ids.resolve(level,id)
    for _,unit in ipairs(_sc_pr_table[level] or {}) do
        if unit.sc_group[1].card.card_id==id then return unit end
    end
    error('顺序模式缺少原作阶段：'..level..':'..id)
end
local function copy(card)
    local out={};for k,v in pairs(card) do out[k]=v end
    if SequenceResources and SequenceResources.enabled() then
        local game=SequenceResources.game()
        local id=card.source_card_id or card.card_id
        local balance=OriginalBalance and OriginalBalance.entries[game] and OriginalBalance.entries[game][id]
        if balance then out.hp=balance.raw end
        if card._original_balance then out.hp=card._original_balance.raw end
    end
    return out
end
local detachRoad
local function spawn(rows,first,last)
    local actors={}
    if #rows[first].unit.sc_group==1 then
        local cls=rows[first].unit.sc_group[1].boss
        local cards={}
        for i=first,last do
            local parts=rows[i].unit.sc_group
            assert(#parts==1 and parts[1].boss==cls,'连续攻击必须使用同一个原作宿主')
            local card=copy(parts[1].card)
            if rows[i].role=='road' then card.is_sc,card.name=false,'' end
            cards[#cards+1]=card
        end
        actors[1]=New(cls,cards)
    else
        assert(first==last,'多Boss组不能串接到单宿主')
        for _,part in ipairs(rows[first].unit.sc_group) do actors[#actors+1]=New(part.boss,{copy(part.card)}) end
        for i,b in ipairs(actors) do
            for j,other in ipairs(actors) do if i~=j then b.otherboss[#b.otherboss+1]=other end end
        end
    end
    if rows[first].role=='road' then for _,b in ipairs(actors) do detachRoad(b) end end
    return actors
end
local function alive(actors)
    for _,b in ipairs(actors) do if valid(b) then return true end end
    return false
end
local function lastContinuous(rows,first)
    local index=first
    local parts=rows[first].unit.sc_group
    if #parts~=1 then return index end
    while rows[index+1] and rows[index+1].role==rows[first].role do
        local following=rows[index+1].unit.sc_group
        if #following~=1 or following[1].boss~=parts[1].boss then break end
        index=index+1
    end
    return index
end
local function media(scene,chapter,kind,row)
    if chapter.level>=35 and chapter.level<=37 then return end
    if OriginalSequenceMedia then OriginalSequenceMedia.enter(scene,chapter,kind,row) end
end
function S.finish(scene,won)
    if scene.sequence_finished then return end
    scene.sequence_finished=true
    local run=lstg.var.sequence_run
    run.finished,run.won=true,won==true
    if OriginalSequenceMedia then OriginalSequenceMedia.stop(scene) end
    if ext.replay.IsReplay() then
        ext.rep_over,ext.pop_pause_menu=true,true
        lstg.tmpvar.pause_menu_text={'再放送','返回标题菜单'}
    else stage.group.ReturnToTitle(true,won and 1 or 0) end
end
local function ordinaryChapter(scene,chapter)
    local rows,index=chapter.units,1
    while index<=#rows do
        local last=chapter.level==31 and index or lastContinuous(rows,index)
        local role=rows[index].role
        media(scene,chapter,role=='boss' and 'boss' or 'stage',rows[index])
        local actors=spawn(rows,index,last)
        while alive(actors) do task.Wait() end
        index=last+1
    end
end
-- 连续道中的宿主不参与boss_group，避免它抢走真实中Boss的符卡背景、名称和指示器。
detachRoad=function(b)
    b._sequence_road_carrier=true
    b.hide=true;b.ui.hide=true
    if b._bosssys and valid(b._bosssys.aura) then b._bosssys.aura.hide=true end
    for i=#boss_group,1,-1 do if boss_group[i]==b then table.remove(boss_group,i) end end
    b.ui.drawhp,b.ui.drawname,b.ui.drawtime,b.ui.drawspell,b.ui.drawpointer=false,false,false,false,false
    b.ui.no_infobar,b.ui.no_timeCounter,b.ui.no_pointer=true,true,true
end
local function roadSource(chapter)
    if chapter.level==32 then
        local n=chapter.name=='EX' and 7 or chapter.name=='PH' and 8 or tonumber(chapter.name)
        return n and 3399+n
    elseif chapter.level==33 then
        return ({['1']=3680,['2']=3681,['3']=3682,['4']=3683,['5']=3684,EX=3685})[chapter.name]
    end
end
local function roadMetadata(chapter)
    if chapter.level~=32 then return end
    local data=dofile('mod/GAME/original/sequence_timeline.lua')
    return assert(data[roadSource(chapter)],'缺少原作道中时间轴归属')
end
local function markerPlan(chapter,metadata)
    local markers,rows={},chapter.units
    local lastRoad
    for i,row in ipairs(rows) do
        if row.role=='road' then lastRoad=row end
        if row.role=='mid' and (not rows[i-1] or rows[i-1].role~='mid') then
            local last=lastContinuous(rows,i)
            local preceding=lastRoad and lastRoad.unit.sc_group[1].card
            local time=preceding and (preceding.road_window and preceding.road_window.last or preceding.t3) or 0
            local m={time=time,timeline=metadata and 0 or 0,first=i,last=last}
            if metadata then
                local source=metadata.midpoints[tostring(time)]
                assert(source,'未核对原作中Boss时间点：'..chapter.level..':'..chapter.name..':'..time)
                m.time,m.timeline,m.order=source[1],source[2],source[3]
            end
            markers[#markers+1]=m
        end
    end
    return markers
end
local function continuousChapter(scene,chapter,source)
    local metadata=roadMetadata(chapter)
    local part=find(chapter.level,source).sc_group[1]
    local original=part.card
    local clock=S.clock.new{native=chapter.level==33,explicitEnd=chapter.level==33 and (chapter.name=='5' or chapter.name=='EX'),
        primary=metadata and metadata.primary or 0,
        length=metadata and metadata.length or original.t3,metadata=metadata,
        -- 三面MBossDummy也占用原作slot0：原2860出生，180帧退场，三次同步调用各耗280帧。
        presence=chapter.level==33 and chapter.name=='3' and {{3700,3880}} or nil,
        markers=markerPlan(chapter,metadata),onMid=function(marker)
            return spawn(chapter.units,marker.first,marker.last)
        end,onTime=function(time)
            lstg.var.sequence_run.road_time=time
        end}
    local card=copy(original)
    card.is_sc,card.name=false,''
    -- 结束由原作时间轴决定，deathWait延长的墙钟时间不能触发旧卡表的固定超时。
    card.t1,card.t2,card.t3=1e9,1e9,1e9
    local before,init=card.before,card.init
    card.before=function(b) b._sequence_road_context=clock;if before then before(b) end end
    card.init=function(b) b._sequence_road_context=clock;init(b) end
    if metadata and metadata.origin>0 then task.Wait(metadata.origin) end
    local road=New(part.boss,{card});detachRoad(road)
    while not clock.done or clock:midAlive() do
        if not valid(road) then error('连续道中宿主提前结束') end
        task.Wait()
    end
    object.Del(road)
    -- 中Boss之后的生成器已经运行过，不能再创建独立“道中后半”练习卡。
    local rows,index=chapter.units,1
    while index<=#rows do
        if rows[index].role=='boss' then
            media(scene,chapter,'boss',rows[index])
            local last=lastContinuous(rows,index)
            local actors=spawn(rows,index,last)
            while alive(actors) do task.Wait() end
            index=last+1
        else index=index+1 end
    end
end
function S.run(scene,key,first)
    local entry=assert(S.catalog.get(key))
    local chapters=S.catalog.chapters(key,lstg.var.player_name)
    if not first then lstg.var.sequence_run={key=key,title=entry.title,chapter=0,completed=0,total=#chapters,road_time=0} end
    for index,chapter in ipairs(chapters) do
        if not first or index>=first then
            local resources=SequenceResources and SequenceResources.state()
            chapter=S.catalog.chapterForRun(entry,chapter,lstg.var.player_name,resources and resources.continues or 0)
            local run=lstg.var.sequence_run
            run.chapter,run.chapter_name,run.road_time=index,chapter.name,0
            scene.level=entry.level
            if SequenceResources then SequenceResources.beginChapter(chapter) end
            media(scene,chapter,'stage')
            local source=roadSource(chapter)
            if entry.native=='thmhj2' then TH37.runChapter(scene,chapter)
            elseif entry.native=='thasl' then TH38.runChapter(scene,chapter)
            elseif entry.native=='thmhj3' then TH39.runChapter(scene,chapter)
            elseif entry.native=='thsss' then _editor_class.TH40.runChapter(scene,chapter,spawn,alive,media)
            elseif GameContent and GameContent.ports[chapter.level] then GameContent.ports[chapter.level].runChapter(scene,chapter)
            elseif source then continuousChapter(scene,chapter,source) else ordinaryChapter(scene,chapter) end
            run.completed=index
            if SequenceResources then SequenceResources.endChapter(index) end
            resources=SequenceResources and SequenceResources.state()
            if resources and resources.game==8 and resources.clock>=12 and index<#chapters then S.finish(scene,false);return end
            if scene.sequence_finished then return end
        end
    end
    S.finish(scene,true)
end
function S.restartChapter(scene)
    local index=lstg.var.sequence_run.chapter
    task.Clear(scene)
    if TH39 and scene.group.sequence_native=='thmhj3' then TH39.runtime.clearAll() end
    ResetPool();boss_group={}
    scene.sequence_background_key=nil;scene.sequence_background=nil;scene.sequence_last_card=nil
    if OriginalSequenceMedia then OriginalSequenceMedia.stop(scene) end
    if NativePlayers and NativePlayers.enabled() then NativePlayers.spawn()
    else SequenceResources.spawnPlayer() end
    if ui.OriginalHUD then ui.OriginalHUD.start() end
    task.New(scene,function() S.run(scene,lstg.var.sequence_key,index) end)
end
function S.machines(entry)
    if entry.native then
        return NativePlayers.machines(entry.level)
    end
    return SequenceResources.machines(SequenceResources.gameByLevel[entry.level])
end
function S.start(key,machine,loadout)
    local entry=assert(S.catalog.get(key),'未知顺序关卡key')
    lstg.var.sequence_key=key
    if entry.native then
        local selected=assert(NativePlayers.machine(entry.level,machine or S.machines(entry)[1].id),
            '未知原作机体 '..tostring(machine))
        lstg.var.sequence_player=selected.id
    elseif SequenceResources and SequenceResources.gameByLevel[entry.level] then
        local game=SequenceResources.gameByLevel[entry.level]
        local selected=assert(SequenceResources.machine(game,machine or SequenceResources.machines(game)[1].id))
        lstg.var.sequence_player=selected.id
        lstg.var.player_name=selected.route
        lstg.var.rep_player=selected.name
        local frames=scoredata and scoredata.OriginalSequencePlayFrames and scoredata.OriginalSequencePlayFrames[game] or 0
        lstg.var.sequence_continue_limit=game==7 and (frames>=14*216000 and 5 or frames>=7*216000 and 4 or 3) or 3
    end
    lstg.var.sc_index,lstg.var.sc_group=nil,nil
    lstg.var.rogue_run,lstg.var.sequence_run,lstg.var.timeslow=nil,nil,nil
    lstg.var.current_system=''
    StopMusic('SCORE')
    stage.group.Start(stage.groups[entry.group],loadout)
    return true
end
for _,entry in ipairs(S.catalog.entries) do
    local selected=entry
    local difficulty=entry.difficulty=='lunatic' and 4 or entry.difficulty=='extra' and 5 or entry.difficulty=='phantasm' and 6 or 1
    local group=stage.group.New('menu',{},entry.group,false,difficulty)
    group.sequence_key,group.sequence_native,group.sequence_level=entry.key,entry.native,entry.level
    local battle=stage.group.AddStage(entry.group,entry.battle,false)
    battle.displayname,battle.level=entry.title,entry.level
    battle.revive_miss_limit=S.MISS_LIMIT-1
    function battle:init()
        assert(lstg.var.sequence_key==selected.key,'顺序关卡与录像路线不一致')
        self.sequence_finished=false
        self:Option()
        task.New(self,function() S.run(self,selected.key) end)
    end
    function battle:frame()
        if self.sequence_finished then return end
        local misses=GameRevive and GameRevive.misses() or lstg.var.dead or 0
        local resources=SequenceResources and SequenceResources.state()
        local native=NativePlayers and NativePlayers.state()
        if native and NativePlayers.out() or not native and not resources and misses>=S.MISS_LIMIT then
            S.finish(self,false)
            return
        end
        stage.group.frame(self)
        if OriginalSequenceMedia then OriginalSequenceMedia.frame(self) end
    end
    battle.render=stage.group.render
    function battle:del()
        if OriginalSequenceMedia then OriginalSequenceMedia.stop(self) end
        lstg.var.timeslow=nil
    end
end
return S
