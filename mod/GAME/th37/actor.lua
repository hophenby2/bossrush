-- 原作Boss行走图、转向/回正动画及蓝/白莲旋转；幽幽子沿用SpecialUpdate。
local types=dofile("mod/GAME/th37/catalogue.lua").bossTypes
local A={}
local clips={
    Idle={7,{{0,0},{1,0},{2,0},{3,0}}},
    TurnRight={7,{{3,2},{0,3}}},
    RotateRight={6,{{1,3},{2,3},{3,3},{0,4}}},
    StopRight={7,{{1,4}}},
    TurnLeft={7,{{0,1},{1,1}}},
    RotateLeft={6,{{2,1},{3,1},{0,2},{1,2}}},
    StopLeft={7,{{2,2}}},
}
local loaded=false
local function load()
    if loaded then return end
    local pool=GetResourceStatus();SetResourceStatus('global')
    LoadTexture('mhj2_bosses','Resources/th37/bosses.png')
    LoadTexture('mhj2_bosslist','Resources/th37/bosslist.png')
    LoadImage('mhj2_boss_aura','mhj2_bosslist',225,135,138,138)
    SetImageCenter('mhj2_boss_aura',69.5,69.5)
    for id,p in ipairs(types) do
        for y=0,(id==8 and 4 or p[6]) do
            for x=0,p[5] do
                local name='mhj2_actor_'..id..'_'..x..'_'..y
                LoadImage(name,'mhj2_bosses',p[1]+x*p[3],p[2]+y*p[4],p[3],p[4])
                SetImageCenter(name,p[7],p[8])
                if RogueEncounter then RogueEncounter.checkpoint() end
            end
        end
    end
    SetResourceStatus(pool);loaded=true
end
A.prepare=load
local function play(s,name)
    s.clip,s.clock,s.frame,s.advanced=name,0,1,0
end
local function frame(b)
    local s=b.mhj_actor
    local dx=b.x-s.x;s.x=b.x;s.age=s.age+1
    if s.id~=8 then
        local p=types[s.id]
        if math.abs(dx)>=.5 and not s.turned then s.nx=0;s.turned=true;s.back=false
        elseif math.abs(dx)<.5 and s.turned then s.nx=p[5]-1;s.turned=false;s.back=true end
        if s.age%7==0 then
            if s.turned then s.ny=math.max(0,dx>0 and p[6] or p[6]-1) end
            if not s.back then
                s.nx=s.nx+1
                if s.nx>p[5] then s.nx=math.abs(dx)>=.5 and p[5] or 0 end
            else
                s.nx=s.nx-1
                if s.nx<0 then s.nx=0;s.ny=0;s.back=false end
            end
        end
        s.rotation=p[12]==1 and math.abs(dx)>=.5 and s.rotation+20 or 0
        return
    end
    local finished=s.advanced>=#clips[s.clip][2]
    if s.clip=='Idle' then
        if dx>=.5 then play(s,'TurnRight') elseif dx<=-.5 then play(s,'TurnLeft') end
    elseif s.clip=='TurnRight' then
        if finished then play(s,'RotateRight') end
    elseif s.clip=='TurnLeft' then
        if finished then play(s,'RotateLeft') end
    elseif s.clip=='RotateRight' then
        if math.abs(dx)<=.5 then play(s,'StopRight') elseif dx<=-.5 then play(s,'TurnLeft') end
    elseif s.clip=='RotateLeft' then
        if math.abs(dx)<=.5 then play(s,'StopLeft') elseif dx>=.5 then play(s,'TurnRight') end
    elseif finished then play(s,'Idle') end
    local clip=clips[s.clip]
    s.clock=s.clock+1
    if s.clock%clip[1]==0 then s.frame=s.frame%#clip[2]+1;s.advanced=s.advanced+1 end
end
local function render(b)
    local s=b.mhj_actor
    local size=1.5+.2*math.sin(s.age/math.pi/7)
    local alpha=(s.alpha or 1)*255
    SetImageState('mhj2_boss_aura','mul+add',alpha,255,255,255)
    Render('mhj2_boss_aura',b.x,b.y,-s.age*7,size,size)
    local at=s.id==8 and clips[s.clip][2][s.frame] or {s.nx,s.ny}
    local p=types[s.id]
    local image='mhj2_actor_'..s.id..'_'..at[1]..'_'..at[2]
    SetImageState(image,'',alpha,255,255,255)
    Render(image,b.x,b.y,-s.rotation,p[11],p[11])
end
function A.bind(b,id)
    load()
    local collision=NativeActorCollision or dofile('THlib/native_actor_collision.lua')
    local p=types[id];collision.bind(b,35,50,'box',p[9]/2,p[10]/2,'box',true)
    b.no_hp_render=true -- 原作HUD已有血条，撤下宿主的额外白弧红圈。
    if b.mhj_actor then return end
    b.mhj_actor={x=b.x,age=0,id=id,nx=0,ny=0,rotation=0,alpha=1};play(b.mhj_actor,'Idle')
    b._wisys.frame=function() frame(b) end
    b._wisys.render=function() render(b) end
    if b._bosssys.aura then b._bosssys.aura.hide=true end
end
return A
