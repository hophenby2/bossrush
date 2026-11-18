-- 原版坐标均从画布左上角计。战斗逻辑继续使用宿主世界；渲染时才设置视口。
local H={compact=dofile('THlib/UI/native/compact.lua')}
-- 每项依次为画布尺寸、战斗区左上和宽高。
local layouts={
    [35]={640,480,32,16,384,448},
    [36]={1280,960,66,32,768,896},
    [37]={1920,1080,312,36,864,1008},
    [38]={640,480,36,16,384,448},
    [39]={640,360,176,18,288,336},
    [40]={1280,720,340,0,600,720},
    [41]={640,360,176,18,288,336},
}
local function config(scene)
    scene=scene or stage.current_stage
    if scene and not scene.is_menu and NativePlayers and NativePlayers.enabled() then
        local level=lstg.var.native_player_level
        return layouts[level],level
    end
end
local function landscape(c)
    local z=math.min(screen.width/c[1],screen.height/c[2])
    return (screen.width-z*c[1])/2,(screen.height-z*c[2])/2,z
end
function H.layout(scene)
    if AndroidPortrait and AndroidPortrait.enabled() then H.shifted=nil;return end
    local c=config(scene)
    if c then
        local x,y,z=landscape(c)
        local w=lstg.world
        w.scrl,w.scrr=x+c[3]*z,x+(c[3]+c[5])*z
        w.scrt,w.scrb=y+(c[2]-c[4])*z,y+(c[2]-c[4]-c[6])*z
        H.shifted=true
    elseif H.shifted and not (ui.OriginalHUD and ui.OriginalHUD.enabled(scene)) then
        local w,d=lstg.world,GetDefaultWorld()
        w.scrl,w.scrr,w.scrb,w.scrt=d.scrl,d.scrr,d.scrb,d.scrt
        H.shifted=nil
    end
end
function H.isExtra()
    local v=lstg.var
    if v.sequence_key then return v.sequence_key:lower():find('extra',1,true)~=nil end
    local g=v.sc_group
    local entry=g and _sc_pr_table[g[1]] and _sc_pr_table[g[1]][g[2]]
    if not entry then return false end
    local c=entry.sc_group[1].card
    local meta=c.asl_source or c.th38_source or c.mhj3_source or c.port_source or {}
    return meta.stage==7 or tostring(meta.key):upper():match('^EX')~=nil
        or tostring(meta.chapter):upper():match('^EX')~=nil
        or (entry.CardName or ''):upper():match('EX')~=nil
end
local function object(level,s)
    local scene=stage.current_stage
    local h=scene.nativeHud
    if not h or h.state~=s then
        local pool=GetResourceStatus();SetResourceStatus('global')
        if level==39 or level==41 then h=dofile('THlib/UI/native/eis.lua')(level)
        else h=dofile('THlib/UI/native/sprites.lua')(level) end
        SetResourceStatus(pool)
        h.state=s;scene.nativeHud=h
    end
    if h.tick~=scene.timer then h.tick=scene.timer;h.update(s) end
    return h
end
function H.frame()
    local c,level=config()
    if not c then return false end
    SetViewMode('ui')
    SetImageState('white','',Color(255,0,0,0));RenderRect('white',0,screen.width,0,screen.height)
    if level~=40 and NativePlayers.state() then
        local x,y,z=landscape(c)
        SetRenderRect(0,c[1],0,c[2],x,x+c[1]*z,y,y+c[2]*z)
        object(level,NativePlayers.state()).frame()
    end
    SetViewMode('world')
    return true
end
function H.bossPanel(b)
    if AndroidPortrait and AndroidPortrait.enabled() then return false end
    local _,level=config()
    return level and b.class.StageLevel==level and level~=39 and level~=40 and not b._sequence_road_carrier
end
function H.draw()
    local c,level=config()
    if not c then return false end
    if level==40 or not NativePlayers.state() then return true end
    local h=object(level,NativePlayers.state())
    SetViewMode('ui')
    local x,y,z=landscape(c)
    SetRenderRect(0,c[1],0,c[2],x,x+c[1]*z,y,y+c[2]*z)
    h.draw()
    if h.field then h.field() end
    if h.boss then
        for _,b in ipairs(boss_group or {}) do
            if IsValid(b) and H.bossPanel(b) and b.is_combat and not b.__is_waiting
                and not b.hide and b.maxhp and b.maxhp>0 then
                h.boss(b,math.min(1,math.max(0,b.hp/b.maxhp)),math.max(0,b.countdown or 0))
            end
        end
    end
    SetViewMode('world')
    return true
end
function H.dreamerPanels()
    local c=layouts[40]
    local x,y,z=landscape(c)
    local left,right,top=x,x+940*z,y+720*z
    return {origin=0,left=left,right=left+340*z,top=top,sx=z,sy=z},
        {origin=940,left=right,right=right+340*z,top=top,sx=z,sy=z}
end
return H
