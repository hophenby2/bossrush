-- TH38 东方雪莲华 ～ Abyss Soul Lotus. 原生对象接入初版。
-- 原始数值表离线导出；Lunatic六面与Extra A，分支/Last Spell另列练习。
-- 原版曲目和贴图由媒体模块处理，自机及结界由 NativePlayers 接入。
-- 运动/绑定/激光代理仍须与原版逐帧对照，来源和差异见tools/th38-tests/README.zh-CN.md。
local R=dofile('mod/GAME/th38/runtime.lua')
local D=R.data
local Media=dofile('mod/GAME/th38/media.lua')
local C={runtime=R,data=D,cards={},chapters={},level=36}
TH38=C;_editor_class.TH38=R.classes
local function valid(o) return o and IsValid(o) end
local function hideRoad(o)
    o.hide=true
    if o.ui then o.ui.hide=true;o.ui.drawhp,o.ui.drawname,o.ui.drawtime,o.ui.drawspell,o.ui.drawpointer=false,false,false,false,false end
    for i=#boss_group,1,-1 do if boss_group[i]==o then table.remove(boss_group,i) end end
end
local function phaseLabel(meta)
    local n=meta.key:match('/stage(%d+)/')
    local chapter=n and n..'面' or 'Extra A'
    local role=meta.role=='mid' and '中Boss' or meta.role=='alternate' and 'Boss B' or meta.role=='lastspell' and 'Last Spell' or 'Boss'
    return '雪莲华 '..chapter..' '..role..' '..meta.title
end
local function addCard(meta,band)
    local opening=90
    local duration=meta.ticks/120+opening/60
    local immune=meta.endurance and duration or min(duration,(opening+meta.immune/2)/60)
    local card=boss.card.New(meta.spell and meta.title or '',immune,immune,duration,meta.hp)
    card.phase_name,card.phase_kind,card.asl_source=phaseLabel(meta),meta.role,meta
    function card:before() self.asl_controller=nil;self.asl_clock=nil end
    function card:init()
        Media.card(meta.spell)
        R.clearAll();self.asl_clock=0;self.asl_transition=1;self.asl_controller=R.controller(self,meta.key)
    end
    function card:frame()
        if not self.asl_clock or not self.asl_controller then return end
        self.asl_clock=self.asl_clock+1
        if self.asl_clock>opening then
            local nextPhase=meta.transitions and meta.transitions[self.asl_transition]
            if nextPhase and ((self.hp or meta.hp)<=nextPhase.hp or meta.ticks-(self.asl_clock-opening)*2<=nextPhase.time) then
                R.transition(self.asl_controller,nextPhase.key,nextPhase.reset,nextPhase.clear)
                self.asl_transition=self.asl_transition+1
            end
            R.tick(self.asl_controller)
        end
    end
    function card:del() R.clear(self.asl_controller);self.asl_controller=nil;self.asl_clock=nil end
    boss.card.add({{card,band}},36,phaseLabel(meta),meta.id)
    C.cards[meta.id]={card=card,band=band}
    return card
end
for _,chapter in ipairs(D.chapters) do
    C.chapters[chapter.name]=chapter;chapter.units={}
    local number=tonumber(chapter.name) or 7
    local ordered={}
    for _,road in ipairs(chapter.roads) do ordered[#ordered+1]={time=road.first,road=road} end
    for _,group in ipairs(chapter.bosses) do ordered[#ordered+1]={time=group.time,boss=group} end
    table.sort(ordered,function(a,b) return a.time<b.time end)
    for _,entry in ipairs(ordered) do
        if entry.road then
            local road=entry.road;local band='aslroad'..road.id..'a'
            boss.Define(band,'雪莲华道中',Media.track(number,'road'),Media[number],{0,300},nil,'Yukari',36)
            local duration=(road.last-road.first)/120
            local card=boss.card.New('',duration,duration,duration,1)
            local chapterLabel=chapter.name=='EXA' and 'Extra A' or chapter.name..'面'
            card.phase_name,card.phase_kind='雪莲华 '..chapterLabel..' 道中'..(road.key:sub(-1)=='a' and '前段' or '后段'),'road'
            card.asl_source=road
            function card:before() self.asl_controller=nil;hideRoad(self) end
            function card:init()
                Media.card(false)
                local bg=lstg.tmpvar.bg
                if valid(bg) then bg.aslBackgroundOffset=road.first-bg.timer*2 end
                R.clearAll()
                self.asl_controller=R.controller(nil,road.key,road.first)
            end
            function card:frame() if self.asl_controller then R.tick(self.asl_controller) end end
            function card:del() R.clear(self.asl_controller);self.asl_controller=nil end
            boss.card.add({{card,band}},36,card.phase_name,road.id)
            C.cards[road.id]={card=card,band=band}
            chapter.units[#chapter.units+1]={id=road.id,role='road'}
        else
            local group=entry.boss;local band='asl'..group.cards[1].id..'a';group.band=band
            local cue=group.cards[1].role=='mid' and 'road' or 'boss'
            boss.Define(band,'雪莲华 '..chapter.name..'面',Media.track(number,cue),Media[number],{0,110},nil,'Yukari',36)
            for _,meta in ipairs(group.cards) do addCard(meta,band);chapter.units[#chapter.units+1]={id=meta.id,role=meta.role} end
        end
    end
end
for _,meta in ipairs(D.extra) do
    local number=tonumber(meta.key:match('/stage(%d+)/')) or 7
    local cue=meta.role=='lastspell' and 'last' or 'boss'
    local band='asl'..meta.id..'a';boss.Define(band,'雪莲华分支',Media.track(number,cue),Media[number],{0,110},nil,'Yukari',36)
    addCard(meta,band)
end
function C.units()
    local out={}
    for _,chapter in ipairs(D.chapters) do for _,row in ipairs(chapter.units) do
        for index,unit in ipairs(_sc_pr_table[36]) do if unit.sc_group[1].card.card_id==row.id then
            out[#out+1]={index=index,unit=unit,chapter=chapter.name,role=row.role};break
        end end
    end end
    for _,meta in ipairs(D.extra) do
        for index,unit in ipairs(_sc_pr_table[36]) do if unit.sc_group[1].card.card_id==meta.id then
            out[#out+1]={index=index,unit=unit,chapter=meta.role=='lastspell' and 'Last Spell' or '分支',role=meta.role};break
        end end
    end
    return out
end
function C.runChapter(scene,chapter)
    R.clearAll()
    local resources=NativePlayers and NativePlayers.state()
    if resources then resources.chapter=chapter.name end
    local meta=assert(C.chapters[chapter.name]);local roadIndex,bossIndex=1,1;local c
    local number=tonumber(meta.name) or 7
    Media.enter(scene,number)
    local length=meta.bosses[#meta.bosses].time
    for t=0,length do
        if scene.sequence_finished then R.clear(c);return end
        if lstg.var.sequence_run then lstg.var.sequence_run.road_time=t end
        local group=meta.bosses[bossIndex]
        if group and group.time==t then
            R.clear(c);c=nil
            local cards={};for _,m in ipairs(group.cards) do cards[#cards+1]=C.cards[m.id].card end
            if group.cards[1].role~='mid' then Media.play(scene,number,'boss') end
            local actor=New(_editor_boss[group.band..36],cards)
            while valid(actor) and not scene.sequence_finished do task.Wait() end
            Media.card(false)
            bossIndex=bossIndex+1
        end
        local road=meta.roads[roadIndex]
        if road and road.first==t then R.clear(c);c=R.controller(nil,road.key,t);roadIndex=roadIndex+1 end
        -- tick可在奇数时刻切换场景；这里逐原作tick推进，保持Boss_creat的16801不丢失。
        if c then R.step(c) end
        if t%2==1 then task.Wait() end
    end
    R.clear(c)
end
return C
