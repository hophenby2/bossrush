-- 第一面关底的 0x13 / 0x25 / 0x31 / 0x34 弹；出生首步走速度 64，之后才用 rank 合成速度。
-- c0722c0 的加速先递减首次等待，再按重置间隔增加有符号速度；跳跃扇是 +1 / 32→4 / 2。
-- 每步保存原版绘制清单，碰撞后的消弹不覆盖已经提交的本步图形。
-- 差异 1：板上拖影的 2/1 加算混色用 LuaSTG mul+add 代理。
-- 差异 2：共用的两千弹槽竞争尚未统一；出生闪光沿用已移植道中的 roadFlash 计数器。
local direction=dofile('mod/GAME/th46/direction.lua')
local art=dofile('mod/GAME/th46/boss1_bullet_art.lua')
local rank=dofile('mod/GAME/th46/rank.lua').get
local object,unit,vector=object,direction.unit,direction.vector
local floor,trunc,abs=math.floor,math.modf,math.abs
local texture='th46_boss1_bullets'
local banks={[0x13]={0x093b,4,1,true},[0x25]={0x0de3,4,1,true},
    [0x31]={0x0bd7,3,2,true},[0x34]={0x0c61,4,1,false}}
local function place(o)o.x,o.y=o.boardX/unit-120,o.boardY/unit-160 end
local function facing(angle)
    local s=floor(((angle+4)%512)/8)
    if s<=16 then return s,0 end
    if s<=32 then return 32-s,2 end
    if s<=48 then return s-32,3 end
    return 64-s,1
end
local function close(o)
    if o.closed then return end
    o.closed,o.colli,o.hide=true,false,true
    o.run.boss1Bullets[o]=nil
    object.RawDel(o)
end
local function outside(o)
    return o.boardX<0 or o.boardX>240*unit or o.boardY<0 or o.boardY>=320*unit
end
local function row(o,sprite,x,y,depth,flip,alpha)
    o.rowCount=o.rowCount+1
    local r=o.rows[o.rowCount]
    if not r then r={};o.rows[o.rowCount]=r end
    r[1],r[2],r[3],r[4],r[5],r[6]=sprite,x,y,depth,flip,alpha or -1
end
local function cancel(o,flags)
    if o.closed or o.cancelAge then return end
    if flags and floor(flags/0x400)%2==1 then o.boardVX,o.boardVY=0,0 end
    o.colli,o.cancelAge,o.motion=false,0,false
    o.spriteBase,o.phase,o.animationClock,o.animationInterval=0x0a9f,0,1,1
end
local function hitPilot(o,p)
    local s=p.pilotPosition
    return abs(floor(o.boardX/unit)-floor(s.x/unit))<=2
        and abs(floor(o.boardY/unit)-(floor(s.y/unit)-1))<=2
end
local function step(o)
    if o.closed or o.serial==o.run.serial then return end
    o.serial=o.run.serial
    if outside(o)then close(o);return end
    o.rowCount=0
    if o.cancelAge then
        o.cancelAge=o.cancelAge+1
        if o.cancelAge>=32 then close(o);return end
        o.boardX=o.boardX+(o.run.roadCameraDelta or 0)+trunc(o.boardVX/2)
        o.boardY=o.boardY+trunc(o.boardVY/2)
        place(o)
        row(o,0x0a9f+floor(o.cancelAge/2),o.boardX,o.boardY,o.depth,0)
        return
    end
    if o.motion then
        o.motionClock=o.motionClock-1
        if o.motionClock<=0 then
            o.motionClock=o.motionInterval
            o.speed=(o.speed+o.acceleration+32768)%65536-32768
            if o.speedCap>0 and o.speed>=o.speedCap then o.speed=o.speedCap end
            o.boardVX,o.boardVY=vector(o.speed,o.angle)
        end
    end
    o.boardX=o.boardX+(o.run.roadCameraDelta or 0)+o.boardVX;o.boardY=o.boardY+o.boardVY
    place(o)
    o.animationClock=o.animationClock-1
    if o.animationClock<0 then
        o.animationClock=o.animationInterval;o.phase=(o.phase+1)%o.frames
    end
    local sprite=o.spriteBase+o.phase
    row(o,sprite,o.boardX,o.boardY,o.depth,o.oriented and o.flip or 0)
    if o.speed>=42 then
        for i=1,o.trails do
            row(o,sprite,o.boardX-i*o.boardVX,o.boardY-i*o.boardVY,o.depth,
                o.oriented and o.flip or 0,58-6*(i-1))
        end
    end
end
local Bullet=Class(object,{
    init=function(o,run,x,y,angle,offset,kind,motion)
        local bank=assert(banks[kind],'关底弹型尚未移植：'..tostring(kind))
        o.run,o.serial,o.closed,o.kind=run,run.serial,false,kind
        o.angle,o.depth=angle%512,213
        o.speed=math.max(16,43+offset+floor(rank(run)/32))
        o.trails=trunc(math.min(44,o.speed-44)/8)
        o.boardVX,o.boardVY=vector(o.speed,o.angle)
        local dx,dy=vector(64,o.angle)
        o.boardX,o.boardY=x+dx,y+dy
        o.phase,o.animationClock,o.frames,o.animationInterval=0,0,bank[2],bank[3]
        local col,flip=facing(o.angle)
        o.flip,o.oriented=flip,bank[4]
        o.spriteBase=bank[1]+(kind==0x34 and 0 or kind==0x31 and floor(col/2)*3 or col*4)
        o.motion=motion~=nil
        if motion then
            o.acceleration,o.motionClock,o.motionInterval,o.speedCap=motion[1],motion[2],motion[3],-1
        end
        o.group,o.layer,o.bound,o.colli=GROUP.ENEMY_BULLET,LAYER.ENEMY_BULLET,false,true
        o.a,o.b,o.rect,o.hitPilot=1,2,true,hitPilot
        o.keepOnHit,o.cancelOnContact,o.cancelOnClear=true,cancel,cancel
        o.rows,o.rowCount={},0
        local flash=run.roadFlash or 0;run.roadFlash=(flash+1)%4
        row(o,0x0a4b+col*4+flash,o.boardX,o.boardY,o.depth+(kind==0x13 and 1 or 0),flip)
        run.boss1Bullets=run.boss1Bullets or {};run.boss1Bullets[o]=true
        place(o)
    end,
    frame=step,
    render=function(o)
        if o.closed then return end
        for i=1,o.rowCount do
            local r=o.rows[i]
            local image=texture..'_'..r[1]
            SetImageState(image,r[6]<0 and''or'mul+add',r[6]<0 and 255 or r[6],255,255,255)
            Render(image,floor(r[2]/unit)-120,floor(r[3]/unit)-160,0,r[5]%2==1 and -1 or 1,
                floor(r[5]/2)%2==1 and -1 or 1)
        end
    end,
})
local function load()
    if CheckRes('tex',texture)then return end
    LoadTexture(texture,'Resources/th46/stage1/boss1_bullets.png')
    SetTextureSamplerState(texture,'point+clamp')
    for id,r in pairs(art.sprites)do LoadImage(texture..'_'..id,texture,unpack(r))end
end
local function emit(run,x,y,a,speed,kind,motion)
    if run.roadShotResume and run.roadFrame<run.roadShotResume then return end
    load()
    return New(Bullet,run,x,y,a,speed,kind,motion)
end
local function fan(run,x,y,a,speed,kind,count,spread,motion)
    local base=a-floor((count-1)*spread/2)
    local result={}
    for i=0,count-1 do result[#result+1]=emit(run,x,y,base+i*spread,speed,kind,motion)end
    return result
end
return {
    load=load,create=function(...)return New(Bullet,...)end,step=step,cancel=cancel,
    emit=emit,
    fan=function(...)return fan(...)end,
    motionFan=function(run,x,y,a,speed,kind,count,spread,acceleration,wait,interval)
        return fan(run,x,y,a,speed,kind,count,spread,{acceleration,wait,interval})
    end,
    draw=function(o,emitRow)for i=1,o.rowCount do emitRow(unpack(o.rows[i]))end end,
    close=function(run)
        for o in pairs(run.boss1Bullets or {})do close(o)end
        run.boss1Bullets=nil
    end,
}
