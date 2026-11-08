-- TH36 东方地灵殿：原版日文1.00a的Lunatic／Extra整关及逐阶段练习。
-- 七条main按原ECL顺序驱动道中、中Boss、主Boss；觉的六条回忆路线均另列练习。
-- 20份源文件、掩码和SHA-256见th36/sources.json。运行时只执行Lua函数与LuaSTG对象。
-- 血量保留原作累计血槽的分段差值，不作DPS、密度或难度校准。
-- 差异3：沿用本项目TH11的背景、BGM和界面；没有移植原版STD三维场景与MSG对白。
-- 差异4：自机、道具及碰撞由LuaSTG框架接管，原版PE的逐像素GPU输出不在此保证。
local class={}
_editor_class.TH36=class
local LEVEL=34
local boss,object=boss,object
local H=assert(loadfile('mod/GAME/th36/runtime.lua'))(class)
local catalogue=dofile('mod/GAME/th36/catalogue.lua')
class.catalogue=catalogue
class.boss_order={}
local labels,phases={},{}
for _,meta in ipairs(catalogue) do
    phases[meta.stage..':'..meta.sub]=meta
    if meta.spell then labels[meta.stage..':'..meta.spell]=meta end
end
class.overlay=Class(object,{
    init=function(o,s) o.session=s;o.group,o.layer,o.colli,o.bound=GROUP.GHOST,LAYER.TOP+2,false,false end,
    frame=function(o) if o.session.done then object.RawDel(o) end end,
    render=function(o)
        local s=o.session;local a=s.boss
        if not a or a.dead or require('bit').band(a.flags,0x20)~=0 then return end
        local m=phases[s.stage..':'..a.sub] or labels[s.stage..':'..tostring(s.spell)]
        local threshold,timeout=0,0
        for i=0,7 do local q=a.interrupts[i];if q and q.hp>=0 then threshold,timeout=q.hp,q.time;break end end
        local hp=m and m.hp or math.max(1,a.o.maxhp-threshold)
        local fraction=math.max(0,math.min(1,(a.o.hp-threshold)/hp))
        SetImageState('white','',Color(160,32,32,48));RenderRect('white',-184,184,210,214)
        SetImageState('white','',Color(255,240,240,255));RenderRect('white',-184,-184+368*fraction,210,214)
        if ui and ui.RenderText then
            local label=labels[s.stage..':'..tostring(s.spell)]
            ui:RenderText('sc_menu',label and label.name or m and m.role or '',-184,202,.45,Color(255,255,255,255),'left')
            if timeout>0 then ui:RenderText('sc_menu',('%.2f'):format(math.max(0,timeout-a.phase_time)/60),184,202,.45,Color(255,255,255,255),'right') end
        end
    end,
},true)
local function before(b,road)
    H.close(b.th36_session);b.th36_session=nil;b.th11_actor=nil
    b._original_actor=nil
    if b._wisys then b._wisys.original=true end
    b.img='img_void';b.no_hp_render=road;b.NotPlayTimeOutSound=road
    if boss.show_aura and b._bosssys then boss.show_aura(b,false) end
    if b.ui then b.ui.no_timeCounter=road;b.ui.no_infobar=road;b.ui.no_pointer=road end
    b._original_hidden=road;b.colli=not road
end
local function tick(b)
    if not b.th36_session then return end
    H.step(b.th36_session)
end
local function draw(b)
    if not b.th11_actor or b.th11_actor.dead then return end
    local a=b.th11_actor
    if require('bit').band(a.flags,0x20)~=0 then return end
    for _,vm in pairs(a.anm) do OriginalANM.draw(vm,b.x,b.y,a.anm_angle and -math.deg(a.anm_angle) or nil) end
end
local function finish(b)
    H.close(b.th36_session);b.th36_session=nil;b.th11_actor=nil
    b._original_actor=nil;b._original_hidden=nil
end
for _,meta in ipairs(catalogue) do
    local group=tostring(meta.id)
    local stage_name=meta.stage==7 and 'Extra' or tostring(meta.stage)..'面'
    local location=stage_name..(meta.mid and '中Boss' or 'Boss')
    local label='地灵殿·'..location..'·'..meta.role..'·'..(meta.name~='' and meta.name or '非符·'..meta.sub)
    if meta.route~='' then label=label..'（'..meta.route..'）' end
    local scbg=(_editor_class.TH11 or {})['SCBG'..(meta.stage<=3 and 1 or meta.stage==4 and 2 or 3)]
    boss.Define(group..'a',meta.role,'TH11_0',TH11_bg,{0,96},scbg,meta.image,LEVEL)
    local survival=meta.stage==7 and meta.sub=='BossCard5'
    local t=meta.timeout/60
    local card=boss.card.New(meta.name,survival and t or 0,survival and t or 0,t,meta.hp,nil,meta.stage==7)
    card.th11_source=meta
    card.phase_name=label
    card.before=function(self) before(self,false) end
    card.init=function(self) H.session(self,meta.stage,meta.sub,meta) end
    card.frame=tick;card.render=draw;card.del=finish
    -- 逐卡练习不重复插入整关流程；完整关卡由下方main直接创建原作Boss对象。
    boss.card.add({{card,group..'a'}},LEVEL,label,meta.id)
end
for stage=1,7 do
    local group='r'..stage
    local name='地灵殿·'..(stage==7 and 'Extra' or stage..'面')..'整关'
    boss.Define(group..'a',name,'TH11_0',TH11_bg,{0,400},nil,'img_void',LEVEL)
    -- 原作main含Boss等待，不能把600帧道中等待改成固定长度后跳过战斗。
    local limit=3600
    local card=boss.card.New('',limit,limit,limit,10000000)
    card.is_sc=false;card.phase_name=name;card.th11_source={stage=stage,sub='main',road=true}
    card.before=function(self) before(self,true) end
    card.init=function(self)
        local s=H.session(self,stage,'main')
        s.effects[#s.effects+1]=New(class.overlay,s)
    end
    card.frame=tick;card.render=draw;card.del=finish
    boss.card.add({{card,group..'a'}},LEVEL,name,11100+stage)
    class.boss_order[#class.boss_order+1]=group
end
