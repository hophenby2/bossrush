-- 东方夏夜祭～Shining Shooting Star：Lunatic / Extra的原生对象移植。
-- 来源：THSSS.exe中的Boss/SpellCard/GameState与原MBG；离线导出器和SHA见th38目录。
-- 差异1：原作Direct3D场景用原图平面背景代理；不改变发弹、坐标和阶段顺序。
-- 差异2：原作自机与星屑资源系统尚未移植，此入口使用LuaSTG自机；血量保持原值。
-- 差异3：片头对话、FSC入场粒子和结局交给BossRush转场；FSC攻击本身保留。
-- 差异4：顺序入口固定包含全部FSC，不模拟原作结界次数解锁条件。
-- 差异5：单精度属性与特效随机数消耗尚未完整对齐；这是原生移植首版，不声明逐帧等价。
local class={};_editor_class.TH38=class
local N=dofile('mod/GAME/th38/native.lua');class.native=N
local data=dofile('mod/GAME/th38/phases.lua');class.data=data
local floor,cos=math.floor,cos
local LEVEL=35;class.level=LEVEL
if rawget(_G,'DefineAchievement') then DefineAchievement(170,'夏夜祭','完成夏夜祭关卡练习','击破本次练习中的全部阶段',false,2) end
N.load()
for source,path in pairs(dofile('mod/GAME/th38/sounds.lua')) do
    local id='th38.snd.'..source;LoadSound(id,path);N.sounds[source]=id
end
for name,track in pairs(dofile('mod/GAME/th38/music.lua')) do AddMusic('TH38_'..name,track.last,track.length,name,true) end
class.background=Class(background,{
    init=function(o,chapter) background.init(o,false);o.chapter=chapter or '1';o.layer=LAYER.BG end,
    frame=function(o) o.th38_scroll=(o.th38_scroll or 0)+.5 end,
    render=function(o)
        SetImageState('white','',255,10,18,38);RenderRect('white',lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)
        local run=lstg.tmpvar.th38_phase;local list=run and run.backgrounds or {}
        for i,name in ipairs(list) do
            local img=N.images[name]
            if img then SetImageState(img,i==1 and '' or 'mul+add',i==1 and 200 or 100,255,255,255);RenderRect(img,-192,192,-224,224) end
        end
    end,
})
local order={};class.byId={}
local bands={};local function band(meta)
    if meta.kind=='road' then return '1a' end
    return meta.boss..meta.role..'a'
end
boss.Define('1a','夏夜祭道中','TH38_Stage01',class.background,{0,500},nil,'img_void',LEVEL)
for _,meta in ipairs(data.phases) do
    class.byId[meta.id]=meta
    local id=band(meta)
    if meta.kind~='road' and not bands[id] then
        bands[id]=true
        boss.Define(id,meta.boss_name,'TH38_Boss'..(meta.chapter=='EX' and 'Ex' or ('0'..meta.chapter)),class.background,{0,100},nil,N.images['Boss'..meta.boss..'-00'] or 'img_void',LEVEL)
    end
    local title=meta.kind=='road' and meta.title or meta.kind=='nonspell' and '' or meta.title
    local limit=meta.time/60;local immune=meta.kind=='road' or meta.survival
    local card=boss.card.New(title,immune and limit or 100/60,immune and limit or 100/60,limit,meta.hp)
    card.phase_kind=meta.role;card.phase_name=meta.kind=='spell' and meta.title or meta.kind=='road' and meta.title or '夏夜祭'..meta.chapter..(meta.role=='mid' and '道中Boss' or '关底')..'非符'
    card.th38_source=meta;card.source_card_id=meta.id
    card.before=function(o)
        if meta.kind=='spell' and meta.variants and o.current_card then
            local source=meta.source:gsub('(%d)[ABCD]$',function(n) return n..N.route({}) end)
            o.current_card.name=meta.variants[source] or meta.title
        end
        o.th38_run=nil
        if meta.kind=='road' then o.x,o.y=0,500;o.hide=true;o.colli=false
        else task.MoveTo(0,104,60,VALUE_SET.DECEL) end
    end
    card.init=function(o)
        local run=N.new(o,meta);lstg.tmpvar.th38_phase=meta
        if meta.kind=='road' then o.colli=false;o.hide=true;if meta.begin then meta.begin(run.host,N) end
        else o.colli=true;o.hide=false end
    end
    card.frame=function(o)
        if not o.th38_run then return end
        N.tick(o,meta);o.DMG_factor=1-(meta.armor or 0)
        if meta.kind~='road' then
            local run=o.th38_run;local row=run.host.speed*cos(run.host.direction)>0.5 and 1 or run.host.speed*cos(run.host.direction)<-.5 and 2 or 0
            local key='Boss'..meta.boss..'-'..row..(floor((o.ani or 0)/6)%4)
            local img=N.images[key]
            if img and o.img1 then o.img1[1]=img end
        end
    end
    card.del=function(o) N.stop(o);if lstg.tmpvar.th38_phase==meta then lstg.tmpvar.th38_phase=nil end end
    boss.card.add({{card,id}},LEVEL,card.phase_name,meta.id)
end
function class.media(scene,chapter,kind,row)
    scene.sequence_chapter=chapter
    local key=chapter.name
    if not scene.sequence_background or not IsValid(scene.sequence_background) then scene.sequence_background=New(class.background,key) end
    local name=(kind=='boss' and 'Boss' or 'Stage')..(key=='EX' and 'Ex' or '0'..key)
    if row then local m=row.unit.sc_group[1].card.th38_source;if m and m.source:find('SSS06_FSC',1,true) then name='Boss06FSC' end end
    local track='TH38_'..name
    if scene.sequence_music~=track then if scene.sequence_music then StopMusic(scene.sequence_music) end;PlayMusic(track);scene.sequence_music=track end
end
function class.mediaFrame(scene)
    local meta=lstg.tmpvar.th38_phase
    if meta and scene.th38_media_phase~=meta then
        scene.th38_media_phase=meta
        if meta.chapter=='6' and meta.optional and scene.sequence_music~='TH38_Boss06FSC' then
            if scene.sequence_music then StopMusic(scene.sequence_music) end
            scene.sequence_music='TH38_Boss06FSC';PlayMusic(scene.sequence_music)
        end
    end
end
class.boss_order={}
-- 连续道中保持TimeMain：中Boss在场只禁止新根发射器出生，不暂停计时。
local Road=Class(object,{
    init=function(o) o.group=GROUP.GHOST;o.layer=LAYER.BG;o.bound=false;o.hide=true;o.colli=false;N.new(o,{kind='road',hp=1}) end,
    frame=function(o) N.tick(o,{kind='road'}) end,
    del=function(o) N.stop(o) end,
})
function class.runChapter(scene,chapter,spawn,alive,media)
    local source=assert(data.stages[chapter.name]);local rows=chapter.units
    lstg.tmpvar.th38_random=N.random(0) -- 原BaseStage.Drama在每面TimeMain=1重建MyRandom(0)。
    local carrier=New(Road);local run=carrier.th38_run
    local mid,backStarted={},false
    local function startRoad(id,clock)
        local m=id and class.byId[id]
        if m then for _,path in ipairs(m.patterns) do N.road_controller(run.host,path,clock+source.offset) end end
    end
    for t=1,source.clock[3] do
        if t==2 then startRoad(source.road_a_id,t) end
        if #source.bosses>1 and t==source.clock[1] then
            N.clear_bullets(run)
            local first,last
            for i,row in ipairs(rows) do if row.role=='mid' then first=first or i;last=i end end
            if first then media(scene,chapter,'stage',rows[first]);mid=spawn(rows,first,last) end
        end
        local occupied=alive(mid);run.road_blocked=occupied
        if #source.bosses>1 and t>source.clock[2] and not occupied and not backStarted then
            backStarted=true;startRoad(source.road_b_id,t)
        end
        lstg.var.sequence_run.road_time=t
        task.Wait()
    end
    N.stop(carrier);object.Del(carrier)
    -- Boss时钟到达时清空道中；已在场的中Boss先完成，防止宿主重叠。
    while alive(mid) do task.Wait() end
    local index=1
    while index<=#rows do
        if rows[index].role=='boss' then
            local last=index
            while rows[last+1] and rows[last+1].role=='boss' and rows[last+1].unit.sc_group[1].boss==rows[index].unit.sc_group[1].boss do last=last+1 end
            media(scene,chapter,'boss',rows[index]);local actors=spawn(rows,index,last)
            while alive(actors) do task.Wait() end
            index=last+1
        else index=index+1 end
    end
    lstg.tmpvar.th38_random=nil
end
return class
