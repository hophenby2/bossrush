-- 每个新阶段将已累计的敌方HP再乘(1+阶段号/100)，不改原卡表或弹速。
-- 动画按逻辑帧推进，显示值只在文字落定后更新；录像不依赖实际渲染帧数。
local Titles=dofile('mod/rogue_titles.lua')
local H={VERSION=1,DURATION=Titles.NAME_DURATION}
local rawNew=New
local wrapped=setmetatable({},{__mode='k'})
local damageDepth=0
local damageMethods={'take_damage','take_damage2'}
local function state()
    local run=lstg.var.rogue_run
    return lstg.var.__hp_scale_version==H.VERSION and run and run.hp_growth
end
function H.enabled() return not not state() end
local function sourceHealth()
    local run=lstg.var.rogue_run
    return state() and run.source_hp
end
local function sourceRate(o)
    local run=lstg.var.rogue_run
    local owner=o.owner or o._master
    if run.source_boss_damage and (o.IsBoss or owner and owner.IsBoss) then return run.source_boss_damage end
    return run.source_damage
end
-- 新后端有原始 HP 阈值、共享部件和自行重设血量的状态机。
-- 保留其数值域，受伤除以阶段倍率；等效血量仍乘同一倍率，阈值和百分比不变。
function H.wrapSourceClass(class)
    if not class then return end
    H.wrapSourceClass(class.base)
    wrapped[class]=wrapped[class] or {}
    for _,key in ipairs(damageMethods) do
        local fn=class[key]
        if fn and wrapped[class][key]~=fn then
            local wrapper=function(o,dmg,...)
                if not o._hp_growth_source or damageDepth>0 or not H.enabled() then return fn(o,dmg,...) end
                damageDepth=damageDepth+1
                local ok,result=pcall(fn,o,dmg*(o._hp_growth_source_rate or 1)/H.factor(o),...)
                damageDepth=damageDepth-1
                if not ok then error(result,0) end
                return result
            end
            class[key]=wrapper;wrapped[class][key]=wrapper
        end
    end
end
function H.init(run)
    if lstg.var.__hp_scale_version~=H.VERSION then return end
    run.hp_growth={stage=0,total=1,shown=1,shown_stage=0,queue={}}
end
function H.factor(o)
    local s=state()
    return s and (o and o._hp_growth_factor or s.total) or 1
end
function H.enter(index)
    -- 只停止累乘；保留基础倍率1的状态，供新作伤害单位换算和共享血槽使用。
    local run=lstg.var.rogue_run
    if run and run.enhanced==false then return end
    local s=state();if not s or index<=s.stage then return end
    assert(index==s.stage+1,'血量倍率阶段号必须连续')
    local factor=1+index/100
    s.stage,s.total=index,s.total*factor
    local event={stage=index,factor=factor,total=s.total,age=0}
    if s.animation then s.queue[#s.queue+1]=event else s.animation=event end
end
function H.announceTitle(run)
    local s=state();if not s then return end
    -- 新卡直接绑定最新一次强化提示；快速切卡不补播已经过去的中央动画。
    if #s.queue>0 then s.animation=s.queue[#s.queue];s.queue={} end
    if s.animation then s.animation.age=0;s.animation.syncTitle=true end
end
function H.frame()
    local s=state();local a=s and s.animation
    if not a then return end
    local run=lstg.var.rogue_run
    if run.stage_banner or run.preparing then return end
    if a.syncTitle and run.card_title then a.age=run.card_title.age else a.age=a.age+1 end
    if a.age>=H.DURATION then
        s.shown,s.shown_stage=a.total,a.stage
        s.animation=table.remove(s.queue,1)
    end
end
function H.rgb(index)
    if index<=9 then return 255,255,255
    elseif index<=19 then return 110,235,145
    elseif index<=29 then return 110,190,255
    elseif index<=39 then return 255,235,100
    elseif index<=49 then return 255,165,75
    else return 255,90,100 end
end
function H.format(value)
    return '×'..(('%.4f'):format(value):gsub('%.?0+$',''))
end
-- RenderTTF实际按字体尺寸的0.5倍绘制，title数字字宽按11像素留余量，两侧各留12像素。
-- 只在多行仍超出底部时缩小整组，先保证常见的大倍率能用正常字号换行。
-- ×只出现在首行，数字不断位、不省略，排版不参与实际血量计算。
function H.layout(value,width,height,maxSize)
    local digits=H.format(value):sub(#'×'+1)
    local scale,lines=math.min(1,maxSize or 1),{}
    repeat
        local capacity=math.max(2,math.floor((width-24)/(11*scale)))
        lines={'×'..digits:sub(1,capacity-1)}
        for i=capacity,#digits,capacity do lines[#lines+1]=digits:sub(i,i+capacity-1) end
        if #lines*22*scale<=height then break end
        scale=scale*.9
    until false
    return lines,scale,22*scale
end
function H.render(x,y,width,height,align)
    local s=state();if not s then return end
    local a=s.animation
    local run=lstg.var.rogue_run
    local blocked=run.stage_banner or run.preparing
    if run.card_title and not blocked then Titles.nameLayout(run) end
    local title=run.card_title and run.card_title.layout
    -- 原有累计倍率常驻原位，入场文字到达目标后由frame统一更新。
    local lines,scale,gap=H.layout(s.shown,width or x*2,height or math.max(1,y-8))
    Titles.canvas(function()
        for i,line in ipairs(lines) do
            ui:RenderText('title',line,x,y-(i-1)*gap,scale,Color(255,H.rgb(s.shown_stage)),align or 'centerpoint','vcenter')
        end
        if not a or blocked then return end
        local text=('×%.2f'):format(a.factor)
        local right=align=='right' and x or x+Titles.textWidth(text,'sc_menu')*scale/2
        local targetY,small=y,scale
        if title then
            local header=Titles.headerLayout(#title.groups)
            right,targetY,small=header.nameRight,header.y-title.small*32,title.small
        end
        local p=Titles.flightLayout(text,a.age,right,targetY,small,nil,title and title.size,title and Titles.captionStartY(title))
        p.color=Color(p.alpha,H.rgb(a.stage))
        boss.sc_name.renderLabel(text,p)
    end)
end
function H.beginCard(o)
    o._hp_growth_factor=H.enabled() and H.factor() or nil
    o._hp_growth_last=nil
end
function H.mark(o)
    if H.enabled() then o._hp_growth_factor=H.factor(o);o._hp_growth_last=o.maxhp end
end
function H.health(o,maxhp,hp)
    hp=hp or maxhp
    if not H.enabled() then return maxhp,hp end
    if sourceHealth() then
        o._hp_growth_source=true;o._hp_growth_factor=H.factor(o)
        o._hp_growth_source_rate=sourceRate(o)
        return maxhp,hp
    end
    local card=o.current_card
    if card and (card.is_combat==false or card.t1==card.t3) then return maxhp,hp end
    local factor=H.factor(o);o._hp_growth_factor=factor
    o._hp_growth_last=maxhp*factor
    return maxhp*factor,hp*factor
end
function H.apply(o)
    if not H.enabled() or not IsValid(o) then return end
    if sourceHealth() and GROUP and (o.group==GROUP.ENEMY or o.group==GROUP.NONTJT) then
        o._hp_growth_source=true;o._hp_growth_factor=H.factor(o)
        o._hp_growth_source_rate=sourceRate(o)
        return
    end
    if o._bosssys or o._rank_hp_proxy then return end
    if not GROUP or (o.group~=GROUP.ENEMY and o.group~=GROUP.NONTJT) then return end
    local maxhp=o.maxhp or o.hp
    -- 999999及以上是不可击破结构/流程宿主；不把占位血量当作真实敌机血槽。
    if not maxhp or maxhp<=0 or maxhp>=999999 or not o.hp or o.hp<=0 or o._hp_growth_last==maxhp then return end
    o.maxhp,o.hp=H.health(o,maxhp,o.hp)
end
function H.verify(o)
    if not H.enabled() or o._hp_growth_source or not o._hp_growth_last or o._rank_hp_proxy then return end
    if o.maxhp~=o._hp_growth_last then o.maxhp,o.hp=H.health(o,o.maxhp,o.hp) end
end
local function new(class,...)
    if sourceHealth() then H.wrapSourceClass(class) end
    local o=rawNew(class,...);H.apply(o);return o
end
New,lstg.New=new,new
GameHPScale=H
return H
