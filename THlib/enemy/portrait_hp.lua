-- 竖屏沿用AEX+的60..64半径白色血弧、两条红色轮廓与阶段节点。
-- 只读取本阶段血量；进场60帧填充与靠近淡化均留在UI对象，不改变战斗状态。
local H={}
local min,max,floor=math.min,math.max,math.floor
local points={}
for i=0,361 do
    local a=math.rad(90+i)
    points[i]={math.cos(a),math.sin(a)}
end
function H.frame(self)
    local b,p=self.boss,player
    local near=p and IsValid(p) and (p.x-b.x)^2+(p.y-b.y)^2<=70^2
    self.portrait_hp_fade=min(18,max(0,(self.portrait_hp_fade or 0)+(near and 1 or -1)))
end
function H.draw(self)
    local b=self.boss
    if not self.drawhp or not b.is_combat or b.__is_waiting or b.no_hp_render or b.time_sc
        or not b.maxhp or b.maxhp<=0 then return end
    local alpha=255*(1-(self.portrait_hp_fade or 0)/30)
    local ratio=min(1,max(0,b.hp/b.maxhp))*min(1,max(0,b.__hpbar_timer or 0)/60)
    SetImageState('portrait_hp_fill','',Color(alpha,255,255,255))
    -- 与参考库misc.Renderhp相同，从90度逆时针按一度线段绘制。
    for i=1,floor(360*ratio) do
        local p,q=points[i+1],points[i]
        Render4V('portrait_hp_fill',
            b.x+p[1]*60,b.y+p[2]*60,.5,b.x+p[1]*64,b.y+p[2]*64,.5,
            b.x+q[1]*64,b.y+q[2]*64,.5,b.x+q[1]*60,b.y+q[2]*60,.5)
    end
    SetImageState('portrait_hp_base','',Color(alpha,255,0,0))
    Render('portrait_hp_base',b.x,b.y,0,.274,.274)
    Render('portrait_hp_base',b.x,b.y,0,.256,.256)
    SetImageState('portrait_hp_node','',Color(alpha,255,255,255))
    local function node(a)
        local r=math.rad(a)
        Render('portrait_hp_node',b.x+61*math.cos(r),b.y+61*math.sin(r),a-90,.5)
    end
    for _,a in ipairs(b.sp_point or {}) do node(a) end
    for _,p in ipairs(b._sp_point_auto or {}) do node(90-p.dmg/b.maxhp*360) end
end
return H
