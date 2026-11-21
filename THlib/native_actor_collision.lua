-- 原作受弹与体术形状独立于精灵尺寸和旋转。
local C={objects=setmetatable({},{__mode='k'})}
local active={}
local shots={}
local function rect(shape,a,b)
    if shape=='box' then return true end
    -- Sub 的 false 表示椭圆；LuaSTG-x 必须显式选择，否则只使用 a 作圆半径。
    if AndroidPlatform and a~=b then return 'ellipse' end
    return false
end
local function shape(o) return (o.rect==true or o.rect==1) and 'box' or 'ellipse' end
function C.bind(o,a,b,shape,ca,cb,contact,point)
    local p=o.native_actor_collision or {};o.native_actor_collision=p;C.objects[o]=p
    p.damage=p.damage or {};p.contact=p.contact or {}
    p.damage[1],p.damage[2],p.damage[3]=a,b,shape
    p.contact[1],p.contact[2],p.contact[3]=ca or a,cb or b,contact or shape;p.point=point
    o.a,o.b,o.rect=a,b,rect(shape,a,b)
    if lstg and lstg.SetSourceActorDamageShape then lstg.SetSourceActorDamageShape(o,p,a,b) end
    return p
end
local function apply(o,s,p)
    o.a,o.b,o.rect=s[1],s[2],rect(s[3],s[1],s[2]);if not p.keepRotation then o.rot=0 end
end
function C.begin()
    for i=#active,1,-1 do active[i]=nil end
    for o,p in pairs(C.objects) do
        if IsValid(o) and o.native_actor_collision==p and o.colli then
            if p.followSize and o.a>0 and o.b>0 then
                local s=shape(o)
                p.damage[1],p.damage[2],p.damage[3]=o.a,o.b,s
                p.contact[1],p.contact[2],p.contact[3]=o.a,o.b,s
                if lstg and lstg.SetSourceActorDamageShape then lstg.SetSourceActorDamageShape(o,p,o.a,o.b) end
            end
            active[#active+1]={o,p,o.rot};apply(o,p.contact,p)
        end
    end
end
function C.shots()
    local boxes=false
    for _,r in ipairs(active) do if IsValid(r[1]) then
        apply(r[1],r[2].damage,r[2])
        if r[2].noDamage then SetAttr(r[1],'colli',false);r[4]=true
        else boxes=boxes or r[2].point and r[2].damage[3]=='box' end
    end end
    -- XNA 原作把自机弹半径加到矩形的横纵边界，角落也参与命中。
    -- 因此碰撞阶段使用轴对齐弹框，而不是圆与矩形的圆角相交。
    if boxes then for _,o in ObjList(GROUP.PLAYER_BULLET) do if o.colli then
        shots[#shots+1]={o,o.rot,o.rect};o.rot,o.rect=0,true
    end end end
end
function C.finish()
    for _,r in ipairs(active) do if IsValid(r[1]) then
        local o=r[1];apply(o,r[2].damage,r[2]);o.rot=r[3]
        if r[4] and o.status~='kill' and o.status~='del' then SetAttr(o,'colli',true) end
    end end
    for i=#shots,1,-1 do
        local r=shots[i];if IsValid(r[1]) then r[1].rot,r[1].rect=r[2],r[3] end
        shots[i]=nil
    end
end
function C.contact(player,o)
    local p=o.native_actor_collision;if not p then return true end
    if p.noContact then return false end
    if p.contactTest then return p.contactTest(o,player) end
    if p.keepRotation then return true end -- 原生框由引擎执行完整的旋转相交测试。
    local s=p.contact;local x,y=math.abs(player.x-o.x),math.abs(player.y-o.y)
    local radius=p.point and 0 or player.A or player.a or 0
    local a,b=s[1]+radius,s[2]+radius
    if s[3]=='box' then return x<=a and y<=b end
    if a<=0 or b<=0 then return false end
    return (x/a)^2+(y/b)^2<1
end
function C.preserve(o)
    if o.a>0 and o.b>0 then
        local p=C.bind(o,o.a,o.b,shape(o))
        p.followSize,p.keepRotation=true,true
    end
end
NativeActorCollision=C
return C
