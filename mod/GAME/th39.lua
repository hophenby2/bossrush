-- TH39 东方幕华祭·永夜篇。练习与顺序模式共用同一份离线展开数据。
local R=dofile('mod/GAME/th39/runtime.lua')
local D=R.data
local Media=dofile('mod/GAME/th39/media.lua')
local variants=dofile('mod/GAME/th39/media_variants.lua')
local LEVEL=37
local C={runtime=R,data=D,level=LEVEL,chapters={},cards={},rows={}}
TH39=C
_editor_class.TH39=R.classes
local function valid(o) return o and IsValid(o) end
local function flag(meta,label)
    for _,name in ipairs(meta.flags) do if name==label then return true end end
    return false
end
local function detachRoad(o)
    o.hide=true
    if o.ui then o.ui.hide=true end
    for i=#boss_group,1,-1 do if boss_group[i]==o then table.remove(boss_group,i) end end
end
local function drawBoss(o,actor)
    if o.mhj3_hidden then return end
    local p=D.bossTypes[actor]
    local a=p.animations.idle
    local n=a[10]+math.floor((o.ani or 0)/math.max(1,a[13]+1))%math.max(1,a[11])
    local wrap=a[7]>0 and a[7] or 9999
    local name='mhj3_boss_'..actor..'_'..n
    R.sprite(name,'bosses',a[1]+n%wrap*a[3],a[2]+math.floor(n/wrap)*a[4],a[3],a[4],a[5],a[6])
    SetImageState(name,'',255,255,255,255)
    Render(name,o.x,o.y,0,p.scale*2/3)
end
local actorBase=Class(enemy,{take_damage=function(o,dmg) if valid(o.owner) then boss.take_damage(o.owner,dmg) end end})
R.classes.actor=Class(actorBase,{
    init=function(o,b,actor,x,y)
        enemybase.init(o,1e9,true)
        o.owner,o.actor=b,actor;o.x,o.y=x,y
        local p=D.bossTypes[actor]
        o.a,o.b=p.size[1]/3,p.size[2]/3
        o.bound=false;o.layer=LAYER.ENEMY
    end,
    frame=function(o)
        if not valid(o.owner) then object.Del(o);return end
        local b=o.owner
        o.colli=b.colli and not o.mhj3_hidden
        SetAttr(o,'colli',o.colli)
    end,
    render=function(o) drawBoss(o,o.actor) end,
})
local function entry(host)
    if host.entry==0 then return R.project(336,-150) end
    if host.entry==1 then return R.project(-200,50) end
    if host.entry==2 then return R.project(854,50) end
    return R.project(host.x,host.y)
end
local function specialCue(meta)
    if meta.number==5801 then return 'sakuya' end
    if meta.kind==3 or meta.number==5802 then return 'eirin' end
end

local function setupCard(meta,group)
    local opening=30+(flag(meta,'DELAY') and 150 or 60)+(flag(meta,'TRANS') and 100 or 0)
    local timeout=opening+meta.seconds*60
    local endurance=flag(meta,'TIME') or flag(meta,'TIMENOTHIDE')
    local feast=flag(meta,'FEAST')
    local immune=endurance and timeout or math.min(timeout,opening+30+meta.immune)
    local card=boss.card.New(meta.kind~=0 and meta.title or '',immune/60,immune/60,timeout/60,meta.hp)
    card.phase_name,card.phase_kind=meta.title,group.role
    card.mhj3_source=meta
    card.nativeBombFactor=group.extraBoss and (meta.kind==0 and .5 or 0) or 1
    local start=60+(flag(meta,'DELAY') and 150 or 0)+(flag(meta,'TRANS') and 100 or 0)
    function card:nativeDamage(timer)
        if endurance or timer<=start+meta.immune then return 0 end
        return timer<=start+90 and (timer-start)/180 or 1
    end
    function card:before() self.mhj3_card=nil end
    function card:init()
        Media.card(meta.kind~=0,variants[meta.id])
        local state=NativePlayers and NativePlayers.state()
        if state then state.cardMisses=lstg.var.dead end
        self.mhj3_card={clock=0,actors={},configs={}}
        self.mhj3_hidden=false
        local ctx=self.mhj3_card
        for id,config in pairs(meta.familiars) do ctx.configs[tonumber(id)]=config end
        for i,host in ipairs(group.hosts) do
            local x,y=R.project(host.x,host.y)
            local ox,oy=entry(host)
            local track=meta.tracks[tostring(i)]
            if track then
                local pattern=R.loadPattern(track[1].pattern)
                if pattern.centerAvailable then x,y=R.project(pattern.center[1]-145,pattern.center[2]) end
            end
            local actor=i==1 and self or New(R.classes.actor,self,host.actor,ox,oy)
            local layer=LAYER.ENEMY+(meta.order==1 and i or -i)*.01
            actor.layer=layer
            if i==1 then
                if self.mhj3_group~=group then self.x,self.y=ox,oy end
                self.mhj3_group=group
            end
            actor.mhj3_hidden=track==nil or flag(meta,'TIME')
            ctx.actors[i]={object=actor,x=x,y=y,track=track,index=1,phaseClock=0}
        end
    end
    function card:frame()
        local ctx=self.mhj3_card;if not ctx then return end
        ctx.clock=ctx.clock+1
        local running=ctx.clock>opening
        local remaining=feast and meta.seconds or meta.seconds-math.floor((ctx.clock-opening)/60)
        for _,a in ipairs(ctx.actors) do
            local o=a.object
            if not running then
                o.x,o.y=(o.x*19+a.x)/20,(o.y*19+a.y)/20
            elseif a.track and valid(o) then
                local active=a.track[a.index]
                local following=a.track[a.index+1]
                local slot=following and following.familiar or active.familiar
                local dead=a.controller and slot>0 and a.phaseClock>=30 and (a.controller.deadFamiliars[slot] or 0)>0
                if following and (dead or following.time>0 and remaining<=following.time or following.hp>0 and self.hp<=following.hp) then
                    R.clear(a.controller);a.controller=nil;a.index=a.index+1;a.phaseClock=0
                    active=following
                elseif not following and dead and feast then
                    self.hp=0
                end
                if not a.controller then a.controller=R.controller(o,active.pattern,false,ctx.configs) end
                a.phaseClock=a.phaseClock+1
                R.tick(a.controller)
            end
        end
    end
    function card:del()
        local ctx=self.mhj3_card
        if ctx then
            for i,a in ipairs(ctx.actors) do
                R.clear(a.controller)
                if NativePlayers and NativePlayers.enabled(nil,37) and self.hp<=0 and not self.timeout then
                    local state=NativePlayers.state()
                    if state and state.cardMisses==lstg.var.dead then
                        NativePlayers.drop(37,a.object.x,a.object.y,group.hosts[i].items,true,meta.kind==0)
                    end
                end
                if i>1 and valid(a.object) then object.Del(a.object) end
            end
        end
        self.mhj3_card=nil;self.mhj3_hidden=nil
    end
    return card
end
local function advance(s,t)
    local jump=s.gotoTick;s.gotoTick=nil
    return jump and (jump>t and jump or jump+1) or t+1
end
local function stageStep(chapter,s,t)
    local step=chapter.driver[t]
    if step then step(R,s) end
    return advance(s,t)
end
local function roadWait(s)
    if s.pause then
        s.pause=s.pause-1
        if s.pause<=0 then s.pause=nil end
        return true
    end
    if valid(s.waitEnemy) then return true end
    s.waitEnemy=nil
    return false
end
local function register(chapter,card,band,id,title,role,practiceOnly)
    boss.card.add({{card,band}},LEVEL,title,id)
    C.cards[id]=card
    C.rows[#C.rows+1]={id=id,chapter=chapter.name,
        role=role,practiceOnly=practiceOnly}
end
for _,chapter in ipairs(D.chapters) do
    if chapter.difficulty~=9 then C.chapters[chapter.name]=chapter end
    chapter.driver=dofile('mod/GAME/th39/stage_'..chapter.script..'.lua')
    local entries={}
    for _,road in ipairs(chapter.roads) do entries[#entries+1]={tick=road.first,road=road} end
    for _,group in ipairs(chapter.bosses) do entries[#entries+1]={tick=group.time,group=group} end
    table.sort(entries,function(a,b)
        if a.tick==b.tick then return a.group~=nil and b.group==nil end
        return a.tick<b.tick
    end)
    for _,entry in ipairs(entries) do
        if entry.road then
            local window=entry.road
            local band='mhj3road'..window.id..'a'
            local title='幕华祭永夜篇 '..chapter.name..' 道中 '..window.first..'–'..window.last
            boss.Define(band,title,Media.track(chapter.stage,'road'),Media[chapter.stage],{0,300},nil,'Yukari',LEVEL)
            -- 暂停点由敌机死亡或脚本时限控制，不能被静态练习时限提前截断。
            local card=boss.card.New('',1000000,1000000,1000000,1)
            card.phase_name,card.phase_kind=title,'road'
            card.mhj3_source=window
            function card:before() self.mhj3_road=nil;detachRoad(self) end
            function card:init()
                Media.card(false)
                local state=R.stageState(chapter.stage);state.preroll=true
                local t=0
                while t<window.first do t=stageStep(chapter,state,t);state.pause=nil end
                state.preroll=false
                self.mhj3_road={state=state,tick=window.first}
            end
            function card:frame()
                local ctx=self.mhj3_road;if not ctx or roadWait(ctx.state) then return end
                if ctx.tick>=window.last then
                    self.hp=0
                    return
                end
                ctx.tick=stageStep(chapter,ctx.state,ctx.tick)
            end
            function card:del() R.clearAll();self.mhj3_road=nil end
            register(chapter,card,band,window.id,title,'road')
        else
            local group=entry.group
            local band='mhj3boss'..chapter.script..'_'..group.index..'a';group.band=band
            local lead=group.hosts[1]
            local name=D.actors[lead.actor][1]
            local x,y=R.project(lead.x,lead.y)
            local cue=specialCue(group.cards[1]) or (group.role=='mid' and 'road' or 'boss')
            boss.Define(band,name,Media.track(chapter.stage,cue),Media[chapter.stage],{x,y},nil,D.actors[lead.actor][2],LEVEL)
            local cls=_editor_boss[band..LEVEL]
            cls.render=function(b)
                if b._bosssys then b._bosssys:render() end
                drawBoss(b,lead.actor)
            end
            local init=cls.init
            cls.init=function(b,...)
                init(b,...)
                local p=D.bossTypes[lead.actor]
                b.a,b.b=p.size[1]/3,p.size[2]/3
            end
            for _,meta in ipairs(group.cards) do
                local title='幕华祭永夜篇 '..chapter.name..' '..meta.title
                local practiceOnly=chapter.difficulty==9 or meta.kind==2 and (meta.condition or 0)>0
                local card=setupCard(meta,group)
                local special=specialCue(meta)
                if special then card.practice_bgm=Media.track(chapter.stage,special) end
                register(chapter,card,band,meta.id,title,group.role,practiceOnly)
            end
        end
    end
end
function C.units()
    local units={}
    for index,unit in ipairs(_sc_pr_table[LEVEL]) do units[unit.sc_group[1].card.card_id]={index=index,unit=unit} end
    for _,row in ipairs(C.rows) do
        local registered=assert(units[row.id],'永夜篇练习卡未注册')
        row.index,row.unit=registered.index,registered.unit
    end
    return C.rows
end
function C.runChapter(scene,chapter)
    local resources=NativePlayers and NativePlayers.state()
    if resources then resources.chapter=chapter.name end
    local meta=chapter.script and chapter or assert(C.chapters[chapter.name])
    local s=R.stageState(meta.stage)
    Media.enter(scene,meta.stage)
    local groups={}
    for _,group in ipairs(meta.bosses) do groups[group.time]=group end
    local t=0
    while t<=meta.length and not scene.sequence_finished do
        if lstg.var.sequence_run then lstg.var.sequence_run.road_time=t end
        local group=groups[t]
        if group then
            local cards={}
            for _,card in ipairs(group.cards) do
                if card.kind~=2 or (card.condition or 0)==0 then cards[#cards+1]=C.cards[card.id] end
            end
            local cue=specialCue(group.cards[1]) or (group.role=='boss' and 'boss')
            if cue then Media.play(scene,meta.stage,cue) end
            local actor=New(_editor_boss[group.band..LEVEL],cards)
            while valid(actor) and not scene.sequence_finished do task.Wait() end
            Media.card(false)
        end
        local nextTick=stageStep(meta,s,t)
        task.Wait()
        while roadWait(s) and not scene.sequence_finished do task.Wait() end
        t=nextTick
    end
    R.clearAll()
end
return C
