-- 夏夜祭BaseBossTouhou、BackgroundRotate/Move2和FullPic原参数。
local N=...
local V={data=dofile('mod/GAME/th40/visuals.lua')}
local D=V.data
local coverage=dofile('mod/GAME/th40/background_coverage.lua').regions
local tiles={{0,0},{1,0},{1,1},{0,1}}
local blendOrder={false,true}
local function image(name)
    local id=N.images[name]
    if not id and D.assets[name] then
        local p=D.assets[name];id='th40_visual_'..name
        if not CheckRes('img',id) then
            local pool=GetResourceStatus();SetResourceStatus('global')
            LoadTexture(id,p.file);LoadImage(id,id,0,0,p.w,p.h);SetResourceStatus(pool)
        end
        N.images[name]=id
    end
    if id and D.centers[name] then SetImageCenter(id,unpack(D.centers[name])) end
    return id
end
function V.config(meta)
    if not meta or meta.kind~='spell' then return end
    local source=meta.source:gsub('(%d)[ABCD]$',function(n) return n..N.route({}) end)
    return D.configs[source] or D.configs[meta.source]
end
function V.backgrounds(meta)
    local cfg=V.config(meta);local parts={}
    for _,p in ipairs(cfg and cfg.backgrounds or {}) do
        if p.kind=='tensei' then return nil,true end
        local id=image(p.name);assert(id,'夏夜祭背景缺少原图：'..p.name)
        local w,h=GetImageSize(id);local f=p.fields
        local move=p.kind=='BackgroundMove2'
        local scale=f.Scale or (move and 1 or p.kind=='BackgroundRotate' and 2.5 or 1)
        local length=f.Length or 896
        if move then scale=length/h end
        local region,proof=N.regions[p.name],coverage[p.name]
        local opaque=proof and proof[6] and region and w==proof[4] and h==proof[5]
        if opaque then
            for i=1,5 do if proof[i]~=region[i+1] then opaque=false;break end end
        end
        local center=D.centers[p.name]
        parts[#parts+1]={id=id,x=move and 224 or 192,y=224,width=w*scale,height=h*scale,scale=scale,
            move=move,speed=f.Velocity or (move and 2 or 0),direction=f.DirectionDegree or (move and 225 or p.kind=='BackgroundSC' and 90 or 0),
            angle=f.AngleDegree or 0,follow=f.AngleWithDirection~=false,omega=f.AngularVelocityDegree or (p.kind=='BackgroundRotate' and .5 or 0),
            alpha=f.TransparentValueF or 255,initial=f.TransparentValueF or 255,add=f.Active or false,event=p.alphaEvent,age=0,
            opaque=opaque,seamOpaque=opaque and proof[7],w=w,h=h,cx=center and center[1] or w/2,cy=center and center[2] or h/2}
    end
    return parts
end
function V.tickBackground(parts)
    for _,p in ipairs(parts or {}) do
        p.age=p.age+1
        p.x,p.y=p.x+p.speed*cos(p.direction),p.y+p.speed*sin(p.direction)
        p.angle=p.angle+p.omega
        if p.move then
            p.angle=90-p.direction
            if p.x<=-p.width/2 then p.x=p.x+p.width elseif p.x>=p.width/2 then p.x=p.x-p.width end
            if p.y<=-p.height/2 then p.y=p.y+p.height elseif p.y>=p.height/2 then p.y=p.y-p.height end
        end
        local ev=p.event
        if ev then
            if (p.age-1)%ev[3]==0 then p.tween={from=p.alpha,time=0} end
            if p.tween then
                local t=p.tween;t.time=math.min(ev[2],t.time+1)
                p.alpha=t.from+(ev[1]-t.from)*(1-cos(180*t.time/ev[2]))*.5
            end
        end
    end
end
function V.coversBackground(parts,alpha)
    local w=lstg.world;local l,r,b,t=w.l,w.r,w.b,w.t
    local offset=lstg.worldoffset
    if offset then
        local hx,hy=math.abs((r-l)/offset.hscale/2),math.abs((t-b)/offset.vscale/2)
        local x,y=offset.centerx-offset.dx/offset.hscale,offset.centery-offset.dy/offset.vscale
        l,r,b,t=x-hx,x+hx,y-hy,y+hy
    end
    local imageScale=GetImageScale()
    for _,p in ipairs(parts or {}) do
        if p.opaque and not p.add and p.alpha*alpha==255 then
            local rot=90-p.angle-(p.follow and p.direction or 0)
            local ca,sa=cos(rot),sin(rot);local scale=p.scale*imageScale
            if scale~=0 then
                local function inside(x,y,ox,oy)
                    local dx,dy=x-(p.x+ox-192),y-(224-p.y-oy)
                    local u,v=(dx*ca+dy*sa)/scale+p.cx,p.cy-(-dx*sa+dy*ca)/scale
                    -- 留出半个像素，避免图集边缘的线性采样透出下层场景。
                    return u>=.501 and u<=p.w-.501 and v>=.501 and v<=p.h-.501
                end
                for i=1,p.move and 4 or 1 do
                    local tile=tiles[i];local x,y=tile[1]*p.width,tile[2]*p.height
                    if inside(l,b,x,y) and inside(l,t,x,y) and inside(r,b,x,y) and inside(r,t,x,y) then return true end
                end
                if p.move and p.seamOpaque and imageScale==1 and scale>0 and rot%360==0 then
                    local left,top=p.x-192-p.cx*scale,224-p.y+p.cy*scale
                    local edge=.501*scale
                    if l>=left+edge and r<=left+2*p.width-edge and t<=top-edge and b>=top-2*p.height+edge then return true end
                end
            end
        end
    end
    return false
end
function V.drawBackground(parts,alpha)
    for _,add in ipairs(blendOrder) do
        for _,p in ipairs(parts or {}) do
            if p.add==add then
                SetImageState(p.id,add and 'mul+add' or '',p.alpha*alpha,255,255,255)
                local rot=90-p.angle-(p.follow and p.direction or 0)
                if p.move then
                    for _,at in ipairs(tiles) do
                        Render(p.id,p.x+at[1]*p.width-192,224-p.y-at[2]*p.height,rot,p.scale,p.scale)
                    end
                else Render(p.id,p.x-192,224-p.y,rot,p.scale,p.scale) end
            end
        end
    end
end
local CutIn=Class(object,{
    init=function(o,config)
        o.config,o.img=config,image(config.name)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-.1,false,false
        o.px,o.py=config.kind=='FullPic3' and 192 or 440,config.kind=='FullPic3' and 548 or 200
        o.speed,o.accel,o.alpha=9,-.2,255
    end,
    frame=function(o)
        local t=o.timer+1;local third=o.config.kind=='FullPic3';local d=third and -90 or 165
        o.px,o.py=o.px+o.speed*cos(d),o.py+o.speed*sin(d)
        o.speed=math.max(1.2,o.speed+o.accel)
        if t==90 then o.accel=third and .1 or 1 end
        if t>=(third and 90 or 120) then o.alpha=o.alpha-(third and 10 or 6) end
        if t>=200 or o.alpha<=0 then Del(o) end
    end,
    render=function(o)
        if o.img then SetImageState(o.img,'',math.max(0,o.alpha),255,255,255);Render(o.img,o.px-192,224-o.py,0,o.config.scale) end
    end,
})
local SpellAttack=Class(object,{
    init=function(o)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY-.2,false,false
        o.img=image('SpellCircle06')
    end,
    frame=function(o) if o.timer>=50 then Del(o) end end,
    render=function(o)
        if not o.img then return end
        SetImageState(o.img,'',math.max(0,255-math.max(0,o.timer-29)*13),255,255,255)
        for i=0,9 do for j=0,5 do
            local x=-50+j*128*cos(30);local y=200-j*128*sin(30)+i*35
            local v=i%2==0 and -2 or 2
            Render(o.img,x+o.timer*v*cos(-30)-192,224-y-o.timer*v*sin(-30),210)
        end end
    end,
})
function V.prepare(meta)
    local function prepare(cfg)
        for _,part in ipairs(cfg and cfg.backgrounds or {}) do if part.kind~='tensei' then image(part.name) end end
        for _,portrait in ipairs(cfg and cfg.portraits or {}) do image(portrait.name) end
    end
    prepare(V.config(meta))
    -- 主菜单前尚未选择机体；把A–D分支的符卡图层和立绘一起准备。
    if meta.kind=='spell' then
        local prefix=meta.source:match('^(.*%d)[ABCD]$')
        if prefix then for _,route in ipairs({'A','B','C','D'}) do prepare(D.configs[prefix..route]) end end
    end
    image('SpellCircle06')
end
function V.open(meta)
    local cfg=V.config(meta);local objects={}
    if cfg then
        local pics=cfg.portraits;local n=#pics>1 and (({A=1,B=2,C=3,D=4})[N.route({})] or 1) or 1
        if pics[n] then objects[#objects+1]=New(CutIn,pics[n]) end
        objects[#objects+1]=New(SpellAttack)
    end
    return objects
end
function V.bind(o,meta)
    o.no_hp_render=true -- 使用原作HUD血条。
    local previous=o.th40_actor
    o.th40_actor={boss=meta.boss,row=previous and previous.row or 0,index=previous and previous.index or 0,mirror=false,time=previous and previous.time or 0}
    o._wisys.frame=function() end
    o._wisys.render=function()
        local a=o.th40_actor;local id=image('Boss'..a.boss..'-'..a.row..math.floor(a.index))
        if id and not o.hide then SetImageState(id,'',255,255,255,255);Render(id,o.x,o.y,0,a.mirror and -1 or 1,1) end
    end
    if o._bosssys.aura then o._bosssys.aura.hide=true end
end
function V.tickBoss(o,host)
    local a=o.th40_actor;if not a then return end
    a.time=a.time+1
    local vx=host.speed*cos(host.direction)
    local old=a.mirror and a.row or -a.row
    if (host.action or 0)>0 then a.row=2;a.index=a.index+.125;host.action=host.action-1
    elseif math.abs(vx)>.05 then
        a.mirror=vx<0;a.row=1
        if math.abs(vx)>1 then a.index=a.index<2 and a.index+.125 or 2+math.floor(host.age%16/8)
        else a.index=math.abs(vx)>.5 and 1 or 0 end
    else a.row=0;a.mirror=false;a.index=math.floor(a.time%32/8) end
    if old~=(a.mirror and a.row or -a.row) then a.index=0 end
    a.index=math.min(3,a.index)
end
return V
