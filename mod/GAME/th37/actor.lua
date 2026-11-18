-- Boss.SpecialInit/SpecialUpdate的幽幽子动画及原图切片，坐标、间隔保持原值。
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
    for y=0,4 do
        for x=0,3 do
            local name='mhj2_yuyuko_'..x..'_'..y
            LoadImage(name,'mhj2_bosses',x*100,1000+y*100,100,100)
            SetImageCenter(name,50,50)
        end
    end
    SetResourceStatus(pool);loaded=true
end
local function play(s,name)
    s.clip,s.clock,s.frame,s.advanced=name,0,1,0
end
local function frame(b)
    local s=b.mhj_actor
    local dx=b.x-s.x;s.x=b.x;s.age=s.age+1
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
    SetImageState('mhj2_boss_aura','mul+add',255,255,255,255)
    Render('mhj2_boss_aura',b.x,b.y,-s.age*7,size,size)
    local at=clips[s.clip][2][s.frame]
    local image='mhj2_yuyuko_'..at[1]..'_'..at[2]
    SetImageState(image,'',255,255,255,255)
    Render(image,b.x,b.y,0,1,1)
end
function A.bind(b)
    load()
    if b.mhj_actor then return end
    b.mhj_actor={x=b.x,age=0};play(b.mhj_actor,'Idle')
    b._wisys.frame=function() frame(b) end
    b._wisys.render=function() render(b) end
    if b._bosssys.aura then b._bosssys.aura.hide=true end
end
return A
