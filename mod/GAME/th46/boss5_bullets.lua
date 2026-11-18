-- 第五面 Original 八种原生敌弹；出生首步走速度 64。
-- 基速来自场景入口的 42+(rank>>3)，这份实战为 54，不能随本步 rank 重算。
-- c06e610 在关号索引 >2 时另加 rank>>4；不能照第一面只加 rank>>5。
-- 0x15 的六拍偏移为 0、1、2、3、2、1；其它七型各自保留朝向、四拍及出生深度。
-- 每步保存原版绘制清单，碰撞后的消弹不覆盖已经提交的本步图形。
-- 差异 1：板上拖影的 2/1 加算混色用 LuaSTG mul+add 代理。
-- 差异 2：原物理池有两千槽，Original 的活动上限为 64；跨关底/道中的池竞争仍待统一。
local direction=dofile('mod/GAME/th46/direction.lua')
local art=dofile('mod/GAME/th46/boss5_bullet_art.lua')
local object,unit,vector=object,direction.unit,direction.vector
local floor,trunc,abs=math.floor,math.modf,math.abs
local texture='th46_boss5_bullets'
local banks=art.banks
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
    o.run.boss5Bullets[o]=nil
    o.run.boss5BulletCount=o.run.boss5BulletCount-1
    local previous,next=rawget(o,'previousBullet'),rawget(o,'nextBullet')
    if previous then previous.nextBullet=next else o.run.boss5BulletHead=next end
    if next then next.previousBullet=previous else o.run.boss5BulletTail=previous end
    object.RawDel(o)
end
local function outside(o)
    return o.boardX<0 or o.boardX>240*unit or o.boardY<0 or o.boardY>320*unit
end
local function row(o,sprite,x,y,depth,flip,alpha)
    o.rowCount=o.rowCount+1
    local r=o.rows[o.rowCount]
    if not r then r={};o.rows[o.rowCount]=r end
    r[1],r[2],r[3],r[4],r[5],r[6]=sprite,x,y,depth,flip,alpha or -1
end
local function cancel(o,flags,mode,drop)
    if o.closed or o.cancelAge then return end
    if flags and floor(flags/0x400)%2==1 then o.boardVX,o.boardVY=0,0 end
    o.colli,o.cancelAge,o.motion=false,0,false
    o.cancelMode,o.drop=mode==nil and-1 or mode,drop
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
    o.rowCount=0
    if o.cancelAge then
        o.cancelAge=o.cancelAge+1
        o.boardX=o.boardX+(o.run.roadCameraDelta or 0)+trunc(o.boardVX/2)
        o.boardY=o.boardY+trunc(o.boardVY/2)
        place(o)
        o.animationClock=o.animationClock-1
        if o.animationClock<0 then
            o.animationClock=o.animationInterval;o.phase=o.phase+1
            if o.phase==12 and o.cancelMode>=0 then
                assert(o.drop,'第五面消弹转金缺少原生道具工厂')(o.cancelMode,o.boardX,o.boardY,140)
            end
        end
        if o.phase>15 then close(o);return end
        row(o,0x0a9f+o.phase,o.boardX,o.boardY,o.depth,0)
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
    local sprite=o.spriteBase+(o.kind==21 and art.animationOffsets[o.phase+1]or o.phase)
    -- 0x15 只给本体设置方向翻转；拖影没有对应的 SetFlip 调用。
    row(o,sprite,o.boardX,o.boardY,o.depth,(o.oriented or o.kind==21)and o.flip or 0)
    if o.speed>=42 then
        for i=1,o.trails do
            row(o,sprite,o.boardX-i*o.boardVX,o.boardY-i*o.boardVY,o.depth,
                o.oriented and o.flip or 0,30-4*(i-1))
        end
    end
end
local Bullet=Class(object,{
    init=function(o,run,x,y,angle,offset,kind,config)
        config=config or{}
        local bank=assert(banks[kind],'关底弹型尚未移植：'..tostring(kind))
        o.run,o.serial,o.closed,o.kind=run,run.serial,false,kind
        o.angle,o.depth=angle%512,(213+(config.depthFlag or 0))%512
        local rank=assert(run.roadRank,'第五面敌弹缺少本步 rank')
        local base=assert(config.baseSpeed or run.roadBulletBase,'第五面敌弹缺少场景基速')
        local speed=(base+offset+floor(rank/32)+32768)%65536-32768
        if(config.stageIndex or 4)>2 then speed=(speed+floor(rank/16)+32768)%65536-32768 end
        o.speed=math.max(16,speed)
        o.trails=trunc(math.min(44,o.speed-44)/8)
        o.boardVX,o.boardVY=vector(o.speed,o.angle)
        local dx,dy=vector(64,o.angle)
        o.boardX,o.boardY=x-(config.camera or(run.roadCamera or 0)*unit)+dx,y+dy
        o.phase,o.animationClock,o.frames,o.animationInterval=0,0,bank[2],bank[3]
        local col,flip=facing(o.angle)
        o.flip,o.oriented=flip,bank[4]
        o.spriteBase=bank[1]+(bank[4]and col*4 or 0)
        local motion=config.motion
        o.motion=motion~=nil
        if motion then
            o.acceleration,o.motionClock,o.motionInterval,o.speedCap=motion[1],motion[2],motion[3],-1
        end
        o.group,o.layer,o.bound,o.colli=GROUP.ENEMY_BULLET,LAYER.ENEMY_BULLET,false,true
        o.a,o.b,o.rect,o.hitPilot=1,2,true,hitPilot
        o.keepOnHit,o.cancelOnContact,o.cancelOnClear=true,cancel,cancel
        o.rows,o.rowCount={},0
        local flash=run.roadFlash or 0;run.roadFlash=(flash+1)%4
        row(o,0x0a4b+col*4+flash,o.boardX,o.boardY,o.depth+bank[5],flip)
        run.boss5Bullets=run.boss5Bullets or {};run.boss5Bullets[o]=true
        run.boss5BulletCount=(run.boss5BulletCount or 0)+1
        o.previousBullet=run.boss5BulletTail
        if o.previousBullet then o.previousBullet.nextBullet=o else run.boss5BulletHead=o end
        run.boss5BulletTail=o
        place(o)
    end,
    frame=function(o)
        if rawget(o,'factory')or o.closed or o.serial==o.run.serial then return end
        step(o)
        if not o.closed and outside(o)then close(o)end
    end,
    render=function(o)
        if o.closed or rawget(o,'factory')then return end
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
    LoadTexture(texture,'Resources/th46/stage5/boss5_bullets.png')
    SetTextureSamplerState(texture,'point+clamp')
    for id,r in pairs(art.sprites)do LoadImage(texture..'_'..id,texture,unpack(r))end
end
local function emit(run,x,y,a,speed,kind,config)
    if run.roadShotResume and run.roadFrame<run.roadShotResume then return end
    load()
    return New(Bullet,run,x,y,a,speed,kind,config)
end
local function fan(run,x,y,a,speed,kind,count,spread,config)
    local base=a-floor((count-1)*spread/2)
    local result={}
    for i=0,count-1 do result[#result+1]=emit(run,x,y,base+i*spread,speed,kind,config)end
    return result
end
return {
    load=load,create=function(...)return New(Bullet,...)end,step=step,cancel=cancel,outside=outside,retire=close,
    emit=emit,
    fan=function(...)return fan(...)end,
    draw=function(o,emitRow)for i=1,o.rowCount do emitRow(unpack(o.rows[i]))end end,
    close=function(run)
        for o in pairs(run.boss5Bullets or {})do close(o)end
        run.boss5Bullets=nil
    end,
}
