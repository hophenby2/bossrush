-- 每个新阶段将已累计的敌方HP再乘(1+阶段号/100)，不改原卡表或弹速。
-- 动画按逻辑帧推进，显示值只在文字落定后更新；录像不依赖实际渲染帧数。
local H={VERSION=1,DURATION=36}
local rawNew=New
local function state()
    local run=lstg.var.rogue_run
    return lstg.var.__hp_scale_version==H.VERSION and run and run.hp_growth
end
function H.enabled() return not not state() end
function H.init(run)
    if lstg.var.__hp_scale_version~=H.VERSION then return end
    run.hp_growth={stage=0,total=1,shown=1,shown_stage=0,queue={}}
end
function H.factor(o)
    local s=state()
    return s and (o and o._hp_growth_factor or s.total) or 1
end
function H.enter(index)
    local s=state();if not s or index<=s.stage then return end
    assert(index==s.stage+1,'血量倍率阶段号必须连续')
    local factor=1+index/100
    s.stage,s.total=index,s.total*factor
    local event={stage=index,factor=factor,total=s.total,age=0}
    if s.animation then s.queue[#s.queue+1]=event else s.animation=event end
end
function H.frame()
    local s=state();local a=s and s.animation
    if not a then return end
    a.age=a.age+1
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
    if value>=10000 then return ('×%.3e'):format(value) end
    return '×'..(('%.4f'):format(value):gsub('%.?0+$',''))
end
function H.render(x,y)
    local s=state();if not s then return end
    local a=s.animation
    local oldAlpha=a and math.max(0,math.min(1,(30-a.age)/6))*255 or 255
    ui:RenderText('title',H.format(s.shown),x,y,1,Color(oldAlpha,H.rgb(s.shown_stage)),'centerpoint')
    if not a then return end
    local t=math.max(0,math.min(1,(a.age-6)/24))
    local move=t*t*(3-2*t)
    local alpha=math.min(1,(H.DURATION-a.age)/6)*255
    ui:RenderText('title',('×%.2f'):format(a.factor),480+(x-480)*move,270+(y-270)*move,
        2.6-1.6*move,Color(alpha,H.rgb(a.stage)),'centerpoint')
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
    local card=o.current_card
    if card and (card.is_combat==false or card.t1==card.t3) then return maxhp,hp end
    local factor=H.factor(o);o._hp_growth_factor=factor
    o._hp_growth_last=maxhp*factor
    return maxhp*factor,hp*factor
end
function H.apply(o)
    if not H.enabled() or not IsValid(o) or o._bosssys or o._rank_hp_proxy then return end
    if not GROUP or (o.group~=GROUP.ENEMY and o.group~=GROUP.NONTJT) then return end
    local maxhp=o.maxhp or o.hp
    -- 999999及以上是不可击破结构/流程宿主；不把占位血量当作真实敌机血槽。
    if not maxhp or maxhp<=0 or maxhp>=999999 or not o.hp or o.hp<=0 or o._hp_growth_last==maxhp then return end
    o.maxhp,o.hp=H.health(o,maxhp,o.hp)
end
function H.verify(o)
    if not H.enabled() or not o._hp_growth_last or o._rank_hp_proxy then return end
    if o.maxhp~=o._hp_growth_last then o.maxhp,o.hp=H.health(o,o.maxhp,o.hp) end
end
local function new(class,...)
    local o=rawNew(class,...);H.apply(o);return o
end
New,lstg.New=new,new
GameHPScale=H
return H
