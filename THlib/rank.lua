-- 动态 Rank 只增加温和的全局倍率，不改原卡的速度常量、HP 表或计时。
-- 每点 1200 个整数单位：每逻辑帧 +1，避免长局浮点累加与恢复误差。
local R={VERSION=1,INITIAL=50,MAX=100,UNITS=1200,CAPTURE=3,MISS=8}
local rawNew=New
local groups={1,5,12}
local function projectile(o) local g=o.group;return g==1 or g==5 or g==12 end
function R.enabled() return lstg.var.__rank_version==R.VERSION end
function R.state()
    if not R.enabled() then return end
    if not lstg.var.rank then lstg.var.rank={units=R.INITIAL*R.UNITS,frames=0,captures=0,misses=0} end
    return lstg.var.rank
end
function R.reset() lstg.var.rank=nil;R.state() end
-- 显示层只读，不能因绘制 HUD 而改变零帧续玩点的状态。
function R.value()
    local s=R.enabled() and lstg.var.rank
    return math.max(0,math.min(R.MAX,s and s.units/R.UNITS or R.INITIAL))
end
function R.factor() return R.enabled() and (0.9+R.value()/500) or 1 end
function R.add(points)
    local s=R.state();if not s then return end
    s.units=math.max(0,math.min(R.MAX*R.UNITS,s.units+math.floor(points*R.UNITS+0.5)))
end
function R.step()
    local s=R.state();if not s or not stage.current_stage or stage.current_stage.is_menu then return end
    s.frames=s.frames+1;s.units=math.max(0,math.min(R.MAX*R.UNITS,s.units+1))
end
function R.miss()
    local s=R.state();if not s then return end
    s.misses=s.misses+1;R.add(-R.MISS)
end
function R.beginCard(b,card)
    b._rank_hp_factor=nil;b._rank_hp_ready=nil;b._rank_hp_last=nil;b._rank_hp_proxy=false
    b._rank_card_id=card.card_id;b._rank_captured=false
    local uses=rawget(b,'_rank_card_uses') or {};b._rank_card_uses=uses
    if card.card_id then uses[card.card_id]=(uses[card.card_id] or 0)+1;b._rank_phase=uses[card.card_id] end
    if R.enabled() then b._rank_hp_factor=R.factor() end
end
function R.capture(b)
    local s=R.state();if not s or not b.is_sc or b._rank_captured then return end
    b._rank_captured=true
    local id,phase=b._rank_card_id,b._rank_phase
    local awards=rawget(b,'_rank_awards') or {}
    if id and (awards[id] or 0)>=(phase or 1) then return end
    -- 按卡号的出现次数共享收卡标记，不依赖两位 Boss 是否已切入下一张卡。
    local function mark(o)
        if not id then return end
        local seen=rawget(o,'_rank_awards') or {};seen[id]=math.max(seen[id] or 0,phase or 1);rawset(o,'_rank_awards',seen)
    end
    mark(b);for _,other in ipairs(b.otherboss or {}) do mark(other) end
    s.captures=s.captures+1;R.add(R.CAPTURE)
end
local function eligible(b,maxhp)
    local c=b.current_card
    return type(maxhp)=='number' and maxhp>0 and maxhp<1e9
        and (not c or (c.is_combat~=false and c.t1~=c.t3))
end
function R.health(b,maxhp,hp)
    hp=hp or maxhp
    if not R.enabled() or not eligible(b,maxhp) then return maxhp,hp end
    local factor=b._rank_hp_factor or R.factor();b._rank_hp_factor=factor
    b._rank_hp_ready=true;b._rank_hp_last=maxhp*factor
    return maxhp*factor,hp*factor
end
function R.verifyHealth(b)
    if R.enabled() and b._rank_hp_ready and not b._rank_hp_proxy and eligible(b,b.maxhp) and b.maxhp~=b._rank_hp_last then
        b.maxhp,b.hp=R.health(b,b.maxhp,b.hp)
    end
end
function R.observe(o)
    if not R.inObjects or not IsValid(o) or not projectile(o) or o._rank_move_stamp==R.stamp then return end
    o._rank_move_stamp=R.stamp;o._rank_move_x=o.x;o._rank_move_y=o.y
end
function R.beforeObjects()
    R.inObjects=false
    if not R.enabled() or not stage.current_stage or stage.current_stage.is_menu then return end
    R.stamp=(R.stamp or 0)+1;R.frameFactor=R.factor();R.inObjects=true
    for _,group in ipairs(groups) do for _,o in ObjList(group) do R.observe(o) end end
end
function R.afterObjects()
    if not R.inObjects then return end
    local extra=R.frameFactor-1
    for _,group in ipairs(groups) do
        for _,o in ObjList(group) do
            if IsValid(o) and o.status=='normal' and o.rank_speed~=false then
                local dx,dy
                if o._rank_move_stamp==R.stamp then dx,dy=o.x-o._rank_move_x,o.y-o._rank_move_y
                else dx,dy=o.vx or 0,o.vy or 0 end -- 本帧刚转为敌弹的原生速度积分。
                local vx,vy=o.vx or 0,o.vy or 0
                -- 传送/穿屏跳跃不按弹速放大，避免越界后被错误回收。
                if dx*dx+dy*dy<=math.max(4096,4*(vx*vx+vy*vy)) then
                    o.x=o.x+dx*extra;o.y=o.y+dy*extra
                end
            end
        end
    end
    R.inObjects=false
end
-- 构造完成后记录出生坐标，覆盖在 ObjFrame 内生成并于同帧移动的新弹。
local function new(class,...)
    local o=rawNew(class,...);R.observe(o);return o
end
New,lstg.New=new,new
GameRank=R
return R
