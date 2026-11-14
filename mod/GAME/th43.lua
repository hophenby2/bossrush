-- 东方栖霞园原作流程。练习和顺序模式共用原脚本定义。
local R=dofile('mod/GAME/th43/runtime.lua')
assert(loadfile('mod/GAME/th43/combat.lua'))(R)
local E=R.env
local LEVEL=41
local C={runtime=R,level=LEVEL,chapters={},rows={},cards={}}
TH43=C
_editor_class.TH43=R
GameContent.ports[LEVEL]=C
assert(loadfile('mod/GAME/th43/player.lua'))(R)
local stageNumber,orderByDifficulty
local Card=E.EGGlib.BossCard
local function keepContact(o)
    if IsValid(o.boss) then object.Preserve(o) end
end
local BossContact=Class(object,{
    init=function(o,b)
        o.boss=b
        o.group=GROUP.INDES
        o.a,o.b=16,16
        o.hide,o.bound,o.colli=true,false,false
        o.IsBoss,o._grazed=true,true
    end,
    frame=function(o)
        local b=o.boss
        if not IsValid(b) or b.status~='normal' then object.RawDel(o);return end
        o.x,o.y=b.x,b.y
        o.is_combat,o.colli=b.is_combat,b.colli and b.is_combat
    end,
    del=keepContact,
    kill=keepContact,
})
local function add(card,band,id,title,role,diff)
    boss.card.add({{card,band}},LEVEL,'栖霞园 '..title,id)
    C.cards[id]=card
    C.rows[#C.rows+1]={id=id,chapter=stageNumber==7 and 'EX' or tostring(stageNumber),
        role=role,difficulty=diff}
end
function Card.createFullCardBoss(editor,res,diff,paths,hidden)
    local band='bdb_'..editor..'_'..diff..'a'
    local role=editor:find('mid') and 'mid' or 'boss'
    local name=R.translate('boss.name.'..res.boss_name)
    if name:find('^boss%.name%.') then name=res.boss_name end
    boss.Define(band,name,nil,nil,{0,384},nil,'Yukari',LEVEL)
    local class=_editor_boss[band..LEVEL]
    local init,render=class.init,class.render
    local cards={}
    class.init=function(o,selected)
        local practice=ext.sc_pr and not (R.chapterScope and IsValid(R.chapterRunner))
        if practice then
            R.reset(diff,true)
            R.playMusic(res.bgm)
        elseif role=='boss' then R.playMusic(res.bgm) end
        if res.bossLoadRes then res.bossLoadRes(o) end
        init(o,selected or cards)
        o.group=GROUP.NONTJT
        o.a,o.b=32,32
        E.New(BossContact,o).th43_bullet=nil
        o.taskers={}
        if practice then
            E.New(res.background,0)
        end
        if practice then o.y=144;R.practiceBoss=o end
        o._a,o._r,o._g,o._b=255,255,255,255
        o.aura_alpha_d,o.aura_alpha=1,255
        if res.bossInitial then res.bossInitial(o) end
        o.scOpenEffect=o.scOpenEffect or E.boss.defaultScOpenEffect
    end
    class.frame=function(o)
        o._bosssys:frame()
        o.DMG_factor=o.dmgrate or 1
        if R.practiceBoss==o then R.update() end
        if IsValid(o) and o.th43_wisys then o.th43_wisys:frame() end
        o.dmgt=math.max(0,(o.dmgt or 0)-1)
    end
    class.render=function(o)
        if o.th43_wisys then
            if o._bosssys then o._bosssys:render() end
            R.renderAura(o)
            o.th43_wisys:render(o.dmgt,o.dmgmaxt)
        else render(o) end
    end
    local del=class.del
    class.del=function(o)
        del(o)
        R.clear(o)
        if R.practiceBoss==o then R.practiceBoss=nil;R.stopMusic() end
    end
    for _,path in ipairs(paths) do
        local definition=R.load(path)(diff)
        local card=definition.main
        card.phase_kind=role
        cards[#cards+1]=card
        local order=(orderByDifficulty[diff] or 0)+1
        orderByDifficulty[diff]=order
        if not hidden and not definition.no_practice then
            add(card,band,80000+stageNumber*1000+diff*100+order,
                (stageNumber==7 and 'EX' or tostring(stageNumber))..'面 '..name..' '..card.phase_name,role,diff)
        end
    end
    return class
end
local RoadRunner=Class(object,{frame=task.Do})
local function withRoad(fn)
    local tick=0
    R.chapterScope={}
    R.scope=R.chapterScope
    local runner=E.New(RoadRunner)
    R.chapterRunner=runner
    task.New(runner,function() fn();runner.finished=true end)
    while IsValid(runner) and not runner.finished do
        tick=tick+1
        if lstg.var.sequence_run then lstg.var.sequence_run.road_time=tick end
        R.update()
        task.Wait()
    end
    R.clear()
    R.stopMusic()
    R.scope,R.chapterScope,R.chapterRunner=nil,nil,nil
end
local segments={'FIRST','SECOND','THIRD','FOURTH','FIFTH','SIXTH'}
local function roadCard(n,road,segment,index)
    local band='bdb_road_'..n..'_'..index..'a'
    local title=(n==7 and 'EX' or n)..'面 道中 '..index
    boss.Define(band,title,nil,nil,{0,384},nil,'Yukari',LEVEL)
    local card=boss.card.New('',10000,10000,10000,1)
    card.phase_name,card.phase_kind=title,'road'
    function card:before()
        self.hide=true
        self._sequence_road_carrier=true
        self.group=GROUP.GHOST
        if self.ui then self.ui.hide=true end
        for i=#boss_group,1,-1 do if boss_group[i]==self then table.remove(boss_group,i) end end
        R.reset(n==7 and 5 or 4,false)
    end
    function card:init()
        task.New(self,function()
            withRoad(function() road.INIT(index);road[segment](true);task.Wait(120) end)
            self.hp=0
        end)
    end
    function card:del() R.clear();R.scope,R.chapterScope=nil,nil end
    add(card,band,80000+n*1000+index,title,'road',n==7 and 5 or 4)
end
for n=1,7 do
    stageNumber,orderByDifficulty=n,{}
    R.load('EISlib/stage/stage'..n..'/StageMain.lua')
    local route=E['s'..n..'_road']
    local road=E.EISlib.stage['stage'..n].road
    local chapter=n==7 and 'EX' or tostring(n)
    C.chapters[chapter]={n=n,main=route.main}
    for index,segment in ipairs(segments) do
        if road[segment] then roadCard(n,road,segment,index) end
    end
end
function C.units()
    if C.indexed then return C.rows end
    local entries={}
    for index,unit in ipairs(_sc_pr_table[LEVEL]) do entries[unit.sc_group[1].card.card_id]={index,unit} end
    for _,row in ipairs(C.rows) do
        local entry=assert(entries[row.id],'栖霞园阶段未注册：'..row.id)
        row.index,row.unit=entry[1],entry[2]
    end
    C.indexed=true
    return C.rows
end
function C.stop()
    R.clear()
    R.stopMusic()
    R.scope,R.chapterScope,R.chapterRunner,R.practiceBoss=nil,nil,nil,nil
end
function C.runChapter(_,chapter,diff)
    local route=assert(C.chapters[chapter.name],'栖霞园未登记章节：'..tostring(chapter.name))
    R.chapterScope=nil
    R.reset(diff or (route.n==7 and 5 or 4),false)
    withRoad(route.main)
end
return C
