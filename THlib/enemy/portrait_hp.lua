-- 横竖屏共用AEX+的60..64半径白色血弧、两条红色轮廓与阶段节点。
-- 只读取本阶段血量；进场60帧填充与靠近淡化均留在UI对象，不改变战斗状态。
local H={}
local min,max,floor=math.min,math.max,math.floor
local points={}
local ringBatch
for i=0,361 do
    local a=math.rad(90+i)
    points[i]={math.cos(a),math.sin(a)}
end
local function nativeRing(x,y,count,color)
    if not lstg.AndroidUpdateQuadBatch then return false end
    if not ringBatch then
        local resource=assert(FindResSprite('portrait_hp_fill'))
        local _,u,v,w,h=GetImageTextureRegion('portrait_hp_fill')
        local packets={}
        for i=1,360 do
            local p,q=points[i+1],points[i]
            packets[i]={resource,'',0,color,0,0,0,0,0,0,
                p[1]*60,p[2]*60,.5,p[1]*64,p[2]*64,.5,
                q[1]*64,q[2]*64,.5,q[1]*60,q[2]*60,.5,u,v,u+w,v+h}
        end
        ringBatch=lstg.AndroidUpdateQuadBatch(nil,packets)
    end
    lstg.AndroidRenderQuadBatch(ringBatch,x,y,0,0,0,0,false,count,color)
    return true
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
    local color=Color(alpha,255,255,255)
    -- 与参考库misc.Renderhp相同，从90度逆时针按一度线段绘制。
    if not nativeRing(b.x,b.y,floor(360*ratio),color) then
        SetImageState('portrait_hp_fill','',color)
        for i=1,floor(360*ratio) do
            local p,q=points[i+1],points[i]
            Render4V('portrait_hp_fill',
                b.x+p[1]*60,b.y+p[2]*60,.5,b.x+p[1]*64,b.y+p[2]*64,.5,
                b.x+q[1]*64,b.y+q[2]*64,.5,b.x+q[1]*60,b.y+q[2]*60,.5)
        end
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
-- 多个身体共用血槽时，位置取各身体，HP仍取唯一控制器；不把使魔占位HP画成独立血槽。
local function visible(b)
    return IsValid(b) and b.status~='del' and b.status~='kill' and not b.hide and not b.mhj3_hidden
end
local function actors(b)
    local result,seen,ownHealth={},{},{}
    local function add(o,independent)
        if o~=b and not seen[o] and visible(o) then
            seen[o]=true;result[#result+1]=o;ownHealth[o]=independent
        end
    end
    if b.mhj3_card then for _,a in ipairs(b.mhj3_card.actors) do add(a.object) end end
    if b.asl_controller then for _,s in ipairs(b.asl_controller.entities) do
        if s.kind=='boss' and not s.main and s.alive then add(s.native) end
    end end
    if b.th07_instruments then for _,o in pairs(b.th07_instruments.roles or {}) do add(o) end end
    -- 红魔乡入场时先建立控制状态，ECL执行器随后才建立actors。
    if b.th06 and b.th06.actors then for _,a in ipairs(b.th06.actors) do
        if a.clone and not a.dead then add(a.object,true) end
    end end
    return result,ownHealth
end
local sharedFields={'hp','maxhp','is_combat','__is_waiting','time_sc','no_hp_render','__hpbar_timer','sp_point','_sp_point_auto'}
local function synchronizeActors(self,advance)
    local owner=self.actorBoss or self.boss
    local states=self.sharedHPRings or {};self.sharedHPRings=states
    if not IsValid(owner) then self.sharedHPRings={};return {} end
    local current,seen={},{}
    local bodies,ownHealth=actors(owner)
    for _,body in ipairs(bodies) do
        local ring=states[body]
        if not ring then ring={boss={}};states[body]=ring end
        ring.drawhp=self.drawhp
        for _,key in ipairs(sharedFields) do ring.boss[key]=self.boss[key] end
        if ownHealth[body] then ring.boss.hp,ring.boss.maxhp=body.hp,body.maxhp end
        ring.boss.x,ring.boss.y=body.x,body.y
        if advance then H.frame(ring) end
        current[#current+1]=ring;seen[body]=true
    end
    for body in pairs(states) do if not seen[body] then states[body]=nil end end
    return current
end
function H.frameActors(self)
    H.frame(self)
    synchronizeActors(self,true)
end
function H.drawActors(self)
    if visible(self.actorBoss or self.boss) then H.draw(self) end
    for _,ring in ipairs(synchronizeActors(self,false)) do H.draw(ring) end
end
return H
