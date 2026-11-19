-- 保留宿主残机和录像管理，执行原作武器、子机与行走动画类。
local B={}
local cache={}
function B.load(name)
    if cache[name] then return cache[name] end
    local source=assert(_editor_class.TH41.source)
    local env=setmetatable({}, {__index=source});local api=setmetatable({}, {__index=source.lstg})
    env.lstg=api
    env.player_class={init=function(p)
        p.attack_speed,p.speed_rate,p.fire_buff,p.laser_rate=1,1,1,1
        p.supportx,p.supporty=p.x,p.y;p.support_follow=.5
        p.lock_player_shoot,p.lock_player_shift=0,0
    end,frame=function() end,render=function() end}
    local classes={}
    env.Class=function(base,define)
        local c=Class(base,define);classes[#classes+1]=c;return c
    end
    local function new(class,...)
        local o=source.New(class,...)
        if o.group==GROUP.PLAYER_BULLET then o.native_alpha=255 end
        return o
    end
    env.New,api.New=new,new
    for key,kind in pairs({LoadTexture='tex',LoadImage='img',LoadAnimation='ani',LoadImageFromFile='img'}) do
        local original=source[key]
        env[key]=function(id,...)
            if CheckRes(kind,id) then return end
            local pool=GetResourceStatus();SetResourceStatus('global');original(id,...);SetResourceStatus(pool)
        end
    end
    env.LoadImageGroup=function(id,...)
        if CheckRes('img',id..'1') then return end
        local pool=GetResourceStatus();SetResourceStatus('global');source.LoadImageGroup(id,...);SetResourceStatus(pool)
    end
    api.LoadTexture,api.LoadImage,api.LoadAnimation=env.LoadTexture,env.LoadImage,env.LoadAnimation
    local chunk=assert(loadfile('mod/GAME/ports/theis/native_players/'..name..'.lua'));setfenv(chunk,env)()
    for _,class in ipairs(classes) do source.lstg.RegisterClass(class) end
    local result={class=assert(env['theis_'..name..'_player']),env=env}
    cache[name]=result;return result
end
function B.bind(p)
    local s=B.load(p.machine.id);p.theis_source=s
    s.class.init(p)
    p.theis_support={p.x,p.y}
end
function B.frame(p)
    local s=p.theis_source;if not s then return end
    local support=p.theis_support
    support[1],support[2]=p.x+(support[1]-p.x)*.5,p.y+(support[2]-p.y)*.5
    p.supportx,p.supporty=support[1],support[2]
    p.lock_player_shoot=math.max(0,(p.lock_player_shoot or 0)-1)
    p.lock_player_shift=math.max(0,(p.lock_player_shift or 0)-1)
    s.env.player=p;s.env.lstg.player=p
    s.class.frame(p)
end
function B.shoot(p) local s=p.theis_source;s.env.player=p;s.class.shoot(p) end
function B.spell(p)
    local s=p.theis_source;s.env.player=p;s.env.lstg.player=p
    s.class.spell(p)
end
function B.shieldHit(p)
    if not p.shield then return false end
    p.shield=false;p.nextspell=60;p.protect=math.max(120,p.protect)
    local s=p.theis_source
    s.env.New(s.env.bullet_cleaner,p.x,p.y,600,60,60,false,false,0)
    return true
end
function B.render(p) local s=p.theis_source;s.env.player=p;s.class.render(p) end
return B
