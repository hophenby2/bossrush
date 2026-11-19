-- 六作的原始切片与动画；坐标换算只在渲染出口执行一次。
local V={data=dofile('THlib/native_player_visual_data.lua')}
local D=V.data
local floor=math.floor
local function texture(key)
    local id='native_source_'..key
    if not CheckRes('tex',id) then
        local pool=GetResourceStatus();SetResourceStatus('global')
        LoadTexture(id,'Resources/native_players/source/'..key..'.png')
        SetResourceStatus(pool)
    end
    return id
end
V.texture=texture
function V.image(key,x,y,w,h,ox,oy)
    local id='native_source_'..key..'_'..x..'_'..y..'_'..w..'_'..h
    if not CheckRes('img',id) then
        local tex=texture(key);local pool=GetResourceStatus();SetResourceStatus('global')
        LoadImage(id,tex,x,y,w,h);SetImageCenter(id,ox or w/2,oy or h/2)
        SetResourceStatus(pool)
    end
    return id
end
function V.sprite(key)
    if not key then return end
    local p=D.unity.sprites[key];local size=D.images[key]
    return V.image(key,0,0,size[1],size[2],p.ox,p.oy),p.scale
end
function V.clipSprite(key,t)
    local c=D.unity.clips[key];if not c then return end
    t=c.loop==1 and t%math.max(.0001,c.length) or math.min(t,c.length)
    local sprite
    for _,track in ipairs(c.tracks) do for _,f in ipairs(track.keys) do if f[1]<=t then sprite=f[2] end end end
    return V.sprite(sprite)
end
local function draw(p,img,x,y,rot,sx,sy)
    local tint=p.native_tint or {255,255,255,255}
    SetImageState(img,'',unpack(tint))
    Render(img,x,y,rot or 0,sx or 1,sy or sx or 1)
end
local function direction(p)
    local dx=p.__move_dx or 0
    return dx<-.01 and 2 or dx>.01 and 3 or 1
end
function V.bind(p)
    local level=p.native_level;local config=D.players[level..'_'..p.machine.art]
    if not config then return end
    local state={clock=0,dir=1,turn=0,parts={}}
    p.native_visual=state
    p._wisys={frame=function()
        local death=p.native_death_clock
        if not (level==37 and death and death>0 and death<=50) then state.clock=state.clock+1 end
        local dir=direction(p)
        if dir~=state.dir then state.turn=0 end
        state.turn=state.turn+1;state.dir=dir
        if level==37 then
            local name=({'Idle','Left','Right'})[dir]..'1'
            -- Old由衰老状态触发，低速键不更换为衰老贴图。
            if p.mhj3_old then name=({'IdleOld','LeftOld','RightOld'})[dir]..'1' end
            for i,part in ipairs(config.parts) do
                local a=part.states[name]
                local s=state.parts[i] or {x=p.x,y=p.y,dx=0,dy=0,rot=0};state.parts[i]=s
                s.anim=a
                if a then
                    s.x=s.x+(p.x-s.x)/math.max(1,a.follow)
                    s.y=s.y+(p.y-s.y)/math.max(1,a.follow)
                    local n=math.max(1,a.change)
                    s.dx=s.dx+(a.dx*config.scale-s.dx)/n
                    s.dy=s.dy+(-a.dy*config.scale-s.dy)/n
                    s.rot=s.rot+(-a.rotation-s.rot)/n
                end
            end
        end
        p.a,p.b=p.A,p.B
    end,render=function()
        if p.native_body_hidden then return end
        local dir,t=state.dir,state.clock
        if level==35 then
            local n=floor(t/6)%7
            if dir~=1 and state.turn>=3 then
                n=(dir==2 and 7 or 11)+(state.turn<7 and 0 or 1+floor((state.turn-7)/3)%3)
            end
            draw(p,V.image(config.tex,n*config.w,config.row*config.h,config.w,config.h,config.ox,config.oy),p.x,p.y,0,config.scale)
        elseif level==36 then
            local name=p.machine.art
            if p.altForm then name=({reimu='yukari',yukari='reimu',byakuren='miko',miko='byakuren'})[name] or name end
            if state.unityForm~=name then
                state.unityForm,state.unitySprite=name,p.unity_body_sprite
                state.unityStart=t
            end
            local cfg=D.players['36_'..name];local c=D.unity.clips[cfg.clips[dir]]
            local time=(dir==1 and t-state.unityStart or state.turn)/60
            time=c.loop==1 and time%math.max(.0001,c.length) or math.min(time,c.length)
            for _,track in ipairs(c.tracks) do
                -- 原动画的首关键帧晚于 0；此前沿用 prefab 初始 Sprite。
                local key=state.unitySprite or p.unity_body_sprite
                for _,f in ipairs(track.keys) do if f[1]<=time then key=f[2] end end
                state.unitySprite=key
                local img,scale
                if D.unity.sprites[key] then img,scale=V.sprite(key)
                elseif p.unity_body_image then img,scale=p.unity_body_image(key) end
                if img then draw(p,img,p.x,p.y,0,scale) end
            end
        elseif level==37 then
            if p.native_source_render then p.native_source_render();return end
            for _,s in ipairs(state.parts) do
                local a=s.anim
                if a then
                    local n=floor(t/math.max(1,a.interval))%7
                    local img=V.image(a.tex,a.x+n*config.w,a.y,config.w,config.h,config.ox,config.oy)
                    draw(p,img,s.x+s.dx,s.y+s.dy,s.rot,config.scale)
                end
            end
        elseif level==41 then
            local key=config.textures[({'normal','left','right'})[dir]]
            local size=D.images[key];local w,h=size[1]/4,size[2]/3
            local n=dir==1 and floor(t/4)%12 or state.turn<=16 and floor((state.turn-1)/4) or 4+floor((state.turn-17)/4)%8
            draw(p,V.image(key,n%4*w,floor(n/4)*h,w,h),p.x,p.y,0,config.scale)
        end
    end}
end
function V.shot(p,o,img,scale)
    o.native_alpha=255
    if p.native_level==35 then o.native_alpha=({reimu=.7,marisa=.7,sanae=.8,youmu=.5})[p.machine.art]*255 end
    if p.native_level==39 then o.native_rotation_offset=0 end
    if p.native_level==41 then
        local part=img:match('_([^_]+)$');local key='43_'..p.machine.art..'_bullets'
        local col=({main=0,straight=1,trail=2,spread=3})[part]
        if col then
            o.img=V.image(key,col*128,0,128,128);o.rot=o.dir;o.native_rotation_offset=0
            local s=NativePlayers.state();local size=(s.rank or 0)>=4 and 1.4 or 1.25
            local factor=2*.85*size
            o.hscale,o.vscale=o.hscale*factor,o.vscale*factor
            if p.machine.art=='reimu' and part=='trail' then o.hscale,o.vscale=.85*size*.5,.85*size*.5 end
            o.native_alpha=p.machine.art=='sakuya' and 120 or 125
            o.native_hitkey='43_'..p.machine.art..'_'..part..'_eff'
        end
    elseif p.native_level==36 then
        local name=p.altForm and ({reimu='yukari',yukari='reimu',byakuren='miko',miko='byakuren'})[p.machine.art] or p.machine.art
        local prefab=D.unity.prefabs['zhuqiang_'..({reimu='lingmeng',yukari='zi',marisa='molisha',byakuren='bailian',miko='shenzi'})[name]]
        if prefab and o.native_main then
            local id,k=V.sprite(prefab.sprite);o.img=id
            o.hscale,o.vscale=k*prefab.sx,k*prefab.sy
        elseif img=='native_asl_sub' then
            local which=({reimu='lingmeng_youdao',yukari='lingmeng_youdao',marisa='molisha_youdao',byakuren='ziji_xuli3zidan',miko='zhuqiang_shenzi'})[name]
            local prefab=D.unity.prefabs[which]
            if prefab then local id,k=V.sprite(prefab.sprite);o.img=id;o.hscale,o.vscale=k*prefab.sx,k*prefab.sy end
        end
    end
end
function V.beam(p,beam)
    local x,y,dir=unpack(beam);local length=math.max(0,(lstg.world.t-y)/math.max(.25,sin(dir)))
    if p.native_level==35 then
        local img=V.image('37_selfbarrage',50,110,33,40,16,-9)
        SetImageState(img,'',p.slow==1 and 127.5 or 255,255,255,255)
        for at=(p.timer%4)*39.52,length,39.52 do Render(img,x+at*cos(dir),y+at*sin(dir),dir-90,1) end
        return true
    end
    local key,width
    if p.native_level==41 then
        key='43_marisa_laser';local rank=NativePlayers.state().rank or 0
        width=({64,80,96,128,112})[math.min(5,rank+1)]
    elseif p.native_level==36 then
        key=p.machine.art=='marisa' and D.unity.playerlasers[p.altForm and 'CenterObject_molishaC' or 'CenterObject_molishaB']
            or D.unity.playerlasers.shenzi_laser1
        if key then width=D.images[key][2]*D.unity.sprites[key].scale end
    end
    if not key then return false end
    local size=D.images[key];local tex=texture(key);local co,si=cos(dir),sin(dir);local nx,ny=-si*width/2,co*width/2
    local color=Color(200,255,255,255);local scroll=(p.timer*18)%size[1]
    RenderTexture(tex,'mul+add',{x+nx,y+ny,.5,scroll,0,color},{x+length*co+nx,y+length*si+ny,.5,scroll+length,size[2]*0,color},
        {x+length*co-nx,y+length*si-ny,.5,scroll+length,size[2],color},{x-nx,y-ny,.5,scroll,size[2],color})
    return true
end
local ShotHit=Class(object,{
    init=function(o,b)
        o.x,o.y,o.rot=b.x,b.y,b.rot;o.vx,o.vy=b.vx*.25,b.vy*.25
        o.key,o.scale=b.native_hitkey,b.hscale
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.PLAYER_BULLET+1,false,false
    end,
    frame=function(o) if o.timer>=24 then object.RawDel(o) end end,
    render=function(o)
        local size=D.images[o.key];if not size then return end
        local w,h=size[1]/4,size[2]/2;local n=math.min(7,math.ceil(o.timer/3))
        local img=V.image(o.key,n%4*w,math.floor(n/4)*h,w,h)
        SetImageState(img,'mul+add',150,255,255,255)
        Render(img,o.x,o.y,o.rot,o.scale+o.timer*.005)
    end,
},true)
function V.shotKill(o) if o.native_hitkey and o.killerenemy then New(ShotHit,o) end end
function V.item(o,level,kind,amount)
    if level==36 then
        local key=D.unity.items[kind=='fragments' and 6 or kind=='points' and 1 or 5]
        local img,scale=V.sprite(key)
        if img then
            local pf=D.unity.prefabs.item_piece
            scale=scale*(pf and pf.sx or 1)
            o.img,o.imgup=img,nil;o.native_item_visual={config={scale=scale},name=kind,level=level}
            o.a,o.b,o.rect=4.8,4.8,true
            o.native_pickup_rect={4.8,4.8}
        end
        return
    elseif level==39 then
        return -- 祈华梦的大小、飞出、动画和混合模式由原作适配器逐帧处理。
    end
    local cfg=D.items[level]
    if not cfg then return end
    local name=kind
    if (kind=='life' or kind=='bombs') and amount>=5 then name=kind..'Big'
    elseif kind=='power' then name=amount>=400 and 'powerFull' or amount>=20 and 'powerBig' or kind end
    local r=cfg.rects[name]
    if level==35 and name=='sakuraGreen' then r={178,16,11,11}
    elseif level==37 and name=='lanternEnergy' then r={1,416,96,96}
    elseif level==37 and name=='lanternGreen' then r={507+ran:Int(0,2)*50,221,50,50} end
    if not r then return end
    o.img=V.image(cfg.tex,unpack(r));o.imgup=nil;o.native_item_visual={config=cfg,name=name}
    o.hscale,o.vscale=cfg.scale,cfg.scale;o.native_item_rotation=0
    -- 原作拾取判定独立于图集切片，换图不能继承LoadImage的零半径。
    local a,b=level==35 and 4 or 16*2/3,level==35 and 4 or 32*2/3
    o.a,o.b,o.rect=a,b,true;o.native_pickup_rect={a,b}
end
function V.itemRender(o)
    local v=o.native_item_visual;if not v then return false end
    local cfg=v.config;local halo=cfg.halos and cfg.halos[v.name]
    if halo then
        local img=V.image(cfg.tex,unpack(halo));SetImageState(img,'',255,255,255,255)
        Render(img,o.x,o.y,-o.timer*.04*180/math.pi,math.min(1,math.max(0,o.timer-50)/60)*.8*cfg.scale)
    end
    SetImageState(o.img,'',255,255,255,255)
    Render(o.img,o.x,o.y,v.level==36 and 0 or o.native_item_rotation or 0,cfg.scale)
    return true
end
function V.focus(p)
    local level=p.native_level
    if p.slow~=1 or p.native_body_hidden then return end
    if level==39 or level==41 then
        local img=V.image(level==39 and '41_pointer' or '43_pointer',192,level==39 and 64 or 0,64,64)
        SetImageState(img,'',255,255,255,255);Render(img,p.x,p.y,0,.5)
    end
end
return V
