-- TH37 东方幕华祭·春雪篇（Part II）：六面Lunatic、Extra、Phantasm。
-- 56符卡、37非符、28个道中练习窗口；214份CrazyStorm经离线展开，运行时只用LuaSTG对象。
-- 来源、哈希、事件/发射器计数：th37/sources.json。生成命令与已知差异见tools/th37-tests/README.zh-CN.md。
-- 原始血量/弹数/周期不做密度校准。差异1：本项目自机、伤害、Bomb、掉落、BGM和背景代理。
-- 差异2：省略对白、3D场景和剧情演出；Boss立绘用项目现有行走图，弹图和敌机使用原图。
-- 差异3：原作跨对象缓时、射线、深绑定/区域触发的边缘语义仍需原版逐帧对照，见验证说明。
local R=dofile('mod/GAME/th37/runtime.lua')
local D=R.data
local C={runtime=R,data=D,level=35,cards={},chapters={},classes=R.classes}
TH37=C
_editor_class.TH37=R.classes
LoadTexture('mhj2_barrages','Resources/th37/barrages.png')
LoadTexture('mhj2_enemys','Resources/th37/enemys.png')
local function valid(o) return o and IsValid(o) end
local function setupCard(meta)
    local opening=150+(meta.flag=='TRANS' and 100 or 0)
    local total=meta.seconds+opening/60
    local endurance=meta.flag=='TIME' or meta.flag=='TIMENOTHIDE'
    local immune=endurance and total or math.min(total,(opening+meta.immune)/60)
    local card=boss.card.New(meta.spell and meta.title or '',immune,immune,total,meta.hp)
    card.phase_name,card.phase_kind=meta.title,meta.role or 'boss'
    card.mhj_source=meta
    function card:before() self.mhj_controller=nil;self.mhj_clock=nil end
    function card:init()
        self.mhj_clock,self.mhj_index=0,1
        self.mhj_controller=R.controller(self,meta.pattern,false)
        self.mhj_opening=opening
    end
    function card:frame()
        if not self.mhj_clock then return end
        self.mhj_clock=self.mhj_clock+1
        if self.mhj_clock<=opening then
            self.x=self.x+(0-self.x)/20;self.y=self.y+(70-self.y)/20
            return
        end
        local continuation=meta.continuations and meta.continuations[self.mhj_index]
        if continuation and (meta.seconds-(self.mhj_clock-opening)/60<=continuation.time or (self.hp or meta.hp)<=continuation.hp) then
            R.clear(self.mhj_controller)
            self.mhj_controller=R.controller(self,continuation.pattern,false);self.mhj_index=self.mhj_index+1
        end
        R.tick(self.mhj_controller)
    end
    function card:del() R.clear(self.mhj_controller);self.mhj_controller=nil;self.mhj_clock=nil end
    return card
end
local function hideRoad(o)
    o.hide=true
    if o.ui then
        o.ui.hide=true;o.ui.drawhp,o.ui.drawname,o.ui.drawtime,o.ui.drawspell,o.ui.drawpointer=false,false,false,false,false
    end
    for i=#boss_group,1,-1 do if boss_group[i]==o then table.remove(boss_group,i) end end
end
for _,chapter in ipairs(D.chapters) do
    C.chapters[chapter.name]=chapter;chapter.units={}
    local roadBand='mhjroad'..chapter.stage..'a'
    boss.Define(roadBand,'幕华祭'..chapter.name..'道中','TH07_1',TH07_bg,{0,300},nil,'Yukari',35)
    chapter.step=dofile('mod/GAME/th37/stage'..chapter.stage..'.lua')
    local ordered={}
    for _,road in ipairs(chapter.roads) do ordered[#ordered+1]={time=road.first,road=road} end
    for _,group in ipairs(chapter.bosses) do ordered[#ordered+1]={time=group.time,boss=group} end
    -- 同一原作时间点先执行上一段Boss，再进入下一段道中。
    table.sort(ordered,function(a,b) if a.time==b.time then return a.boss~=nil and b.boss==nil end;return a.time<b.time end)
    for _,entry in ipairs(ordered) do
        if entry.road then
            local window=entry.road;local title='幕华祭'..chapter.name..'道中 '..window.first..'–'..window.last
            local duration=(window.last-window.first)/60
            local card=boss.card.New('',duration,duration,duration,1)
            card.phase_name,card.phase_kind=title,'road'
            card.mhj_source={chapter=chapter.name,first=window.first,last=window.last}
            function card:before() self.mhj_road=nil;hideRoad(self) end
            function card:init()
                local state=R.stageState(chapter.stage);state.preroll=true
                -- 独立后半道中仍须建立原始CopyEnemy模板；预滚阶段不创建敌机或弹。
                for t=0,window.first-1 do chapter.step(R,state,t) end
                state.preroll=false;self.mhj_road={clock=window.first,state=state}
            end
            function card:frame()
                if not self.mhj_road then return end
                local s=self.mhj_road
                if s.clock<window.last then chapter.step(R,s.state,s.clock);s.clock=s.clock+1 end
            end
            function card:del() R.clearAll();self.mhj_road=nil end
            boss.card.add({{card,roadBand}},35,title,window.id)
            C.cards[window.id]={card=card,band=roadBand}
            chapter.units[#chapter.units+1]={id=window.id,role='road'}
        else
            local group=entry.boss;local band='mhj'..group.id..'a'
            group.band=band
            local first=group.cards[1]
            boss.Define(band,first.actor,'TH07_1',TH07_bg,{0,70},nil,first.image,35)
            for _,meta in ipairs(group.cards) do
                meta.role=group.source[3]=='1' and 'boss' or 'mid'
                local card=setupCard(meta)
                boss.card.add({{card,band}},35,'幕华祭'..chapter.name..' '..meta.actor..' '..meta.title,meta.id)
                C.cards[meta.id]={card=card,band=band}
                chapter.units[#chapter.units+1]={id=meta.id,role=meta.role}
            end
        end
    end
end
function C.units()
    local out={}
    for _,chapter in ipairs(D.chapters) do for _,row in ipairs(chapter.units) do
        for index,unit in ipairs(_sc_pr_table[35]) do if unit.sc_group[1].card.card_id==row.id then
            out[#out+1]={index=index,unit=unit,chapter=chapter.name,role=row.role};break
        end end
    end end
    return out
end
function C.runChapter(scene,chapter)
    local meta=assert(C.chapters[chapter.name]);local state=R.stageState(meta.stage)
    local marker=1
    for t=0,meta.length do
        if scene.sequence_finished then R.clearAll();return end
        if lstg.var.sequence_run then lstg.var.sequence_run.road_time=t end
        meta.step(R,state,t)
        while meta.bosses[marker] and meta.bosses[marker].time==t do
            local group=meta.bosses[marker];local cards={}
            for _,m in ipairs(group.cards) do cards[#cards+1]=C.cards[m.id].card end
            local actor=New(_editor_boss[group.band..35],cards)
            -- 原作StageManager在Boss存在期间冻结关卡轴；道中敌机和弹仍自然运动。
            while valid(actor) and not scene.sequence_finished do task.Wait() end
            marker=marker+1
        end
        task.Wait()
    end
    R.clearAll()
end
return C
