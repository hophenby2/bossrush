-- 第一面卷轴指令 0x41、0x40 的蜈蚣共用 0x0c0ace50，按节数选择贴图和牵引点。
local direction = dofile('mod/GAME/th46/direction.lua')
local unit, heading, vector = direction.unit, direction.heading, direction.vector
local floor, ceil, min, max, abs = math.floor, math.ceil, math.min, math.max, math.abs

-- 0x0c2dc9b0 / 0x0c2dcaa0：贴图首格、朝向步长、曲线采样点、纵向振动槽与亮度。
local variants = {
    [745] = {
        x=205, y=413, facing=384, flip=-1, bodyY=-8, targetHeight=100, driftAngle=264, scrollRate=4,
        sweepSpread=2, retreatY=100,
        parts={{92,129,0,24,128},{83,16,15,18,192},{83,16,40,15,255},
               {66,8,75,12,255},{33,4,100,6,255},{0,4,125,0,255}},
    },
    [3516] = {
        x=63, y=411, facing=128, flip=1, bodyY=2, targetHeight=130, driftAngle=248, scrollRate=8,
        sweepSpread=4, retreatY=4,
        -- 两份原程序记录中的竖向卷轴分数步从 1 像素逐档降到 1/2 像素。
        slowdowns={167,198,239,288},
        parts={{92,129,0,24,128},{83,16,15,18,192},{83,16,40,15,224},
               {66,8,63,12,255},{33,4,84,6,255},{33,4,105,3,255},{0,4,126,0,255}},
    },
}
local texture = 'th46_worm1'
-- 发弹位置与寻向都使用 7 * trunc(127 / (节数 - 1))，原程序将其截到 128。
local muzzleCurve = 128

local function trunc(n)
    return n<0 and ceil(n) or floor(n)
end

local function turn(current, aim, speed)
    local delta = (aim-current+256)%512-256
    return (current+max(-speed,min(speed,delta)))%512
end

local function curve(t, first, middle, last)
    local s = 128-t
    return floor((s*s*s*first+384*s*t*middle+t*t*t*last)/0x200000)
end

local function collision(o)
    local variant = o.variant
    local t = variant.parts[#variant.parts][3]
    o.boardX = (curve(t,o.firstX,o.midX,o.lastX)+24*variant.flip)*unit
    o.boardY = (curve(t,o.firstY,o.midY,o.lastY)+variant.bodyY)*unit
    o.x, o.y = o.boardX/unit-120, o.boardY/unit-160
end

local function hitPilot(o, p)
    local s = p.pilotPosition
    return abs(o.boardX/unit-floor(s.x/unit))<=50
       and abs(o.boardY/unit-floor(s.y/unit-1))<=50
end

local function damage(o, amount)
    -- 0x0c0acc70 在进场触发 0x0c0ad682 后才从 0x0e4 扣除伤害。
    if o.hp<0 or not o.entered then return end
    o.hp = o.hp-amount
    o.hitFrame = o.run.roadFrame
    if o.hp<0 then
        o.colli = false
        o.defeated = o.run.roadFrame
    end
end

local function firing(o, p, emit)
    local variant = o.variant
    local x = curve(muzzleCurve,o.firstX,o.midX,o.lastX)*unit
    local y = curve(muzzleCurve,o.firstY,o.midY,o.lastY)*unit
    if o.auxSpeed==12 then
        o.facing = o.facing+2*variant.flip
        o.sweepClock = o.sweepClock-1
        if o.sweepClock<0 then
            o.sweepClock = 8
            if p.respawn==0 then
                -- 0x0c0ad9e0 / 0x0c0ad7f0 将一发与两发的小扇分别入队。
                local vx,vy = vector(128,o.facing)
                local sx,sy = x+7*vx,y+7*vy+16*unit
                local aim = o.facing+trunc((o.facing-(variant.facing+256)/2)/3)
                emit(o.run,sx,sy,aim,8)
                emit(o.run,sx,sy,aim-variant.sweepSpread,4)
                emit(o.run,sx,sy,aim+variant.sweepSpread,4)
            end
        end
        if o.facing==256 then o.auxSpeed=8 end
    else
        -- 0x0c0adbd0 在曲线末端向自机转头，两只蜈蚣的朝向限制互相对称。
        local pos = p.pilotPosition
        local aim = p.respawn==0 and heading(x,y,pos.x,pos.y) or 256
        o.facing = turn(o.facing,max(o.minFacing,min(o.maxFacing,aim)),o.baseY<variant.retreatY*unit and 2 or 1)
    end
    if o.auxSpeed~=8 or o.baseY<100*unit then return end

    -- 0x0c0ac080 在扫射结束当步开始递减同一个计时器。
    o.fanClock = o.fanClock-1
    if o.fanClock>=0 then return end
    o.fanClock = 64
    local vx,vy = vector(128,o.facing)
    local sx,sy = x+5*vx,y+5*vy
    if sy>440*unit then return end
    local count = o.fanCount
    o.fanCount = count+1
    if p.respawn~=0 then return end
    local gap = 16+2*count
    for i = 1, count do
        emit(o.run,sx,sy,o.facing+gap*(i-(count+1)/2),8)
    end
end

local function scrollY(o, age)
    local slowdowns = o.variant.slowdowns
    if slowdowns and age==slowdowns[o.scrollPhase] then
        o.scrollRate, o.scrollPhase = o.scrollRate-1, o.scrollPhase+1
    end
    local total = o.scrollRest+o.scrollRate
    o.scrollRest = total%8
    return -floor(total/8)*unit
end

local function update(o, frame, p, dx, emit)
    if o.baseY<=-112*unit or (o.defeated and frame-o.defeated>=123) then return false end
    local variant,age = o.variant,frame-o.birth
    local dy = scrollY(o,age)
    o.baseX, o.baseY = o.baseX+dx, o.baseY+dy
    for i = 0, 4 do
        for slot = i*6+5, i*6+1, -1 do o.wave[slot]=o.wave[slot-1] end
        local _, waveY = vector(20-i,256+i*60+age*4)
        o.wave[i*6] = o.wave[i*6]+waveY
    end
    if o.baseY<=-112*unit then
        o.colli, o.hide = false, true
        return true
    end

    local driftX, driftY = vector(o.drift,variant.driftAngle)
    local _, pitchY = vector(128,o.facing)
    local targetX = o.baseX+driftX+o.seekX
    local targetY = o.baseY+variant.targetHeight*unit+pitchY+driftY+o.seekY
    o.auxHeading = turn(o.auxHeading,heading(o.auxX,o.auxY,targetX,targetY),4)
    if o.auxSpeed==8 then
        local x,y = abs(targetX-o.auxX),abs(targetY-o.auxY)
        -- 0x0c0ae5d0 到达牵引点附近后为下一个逻辑步抽取位置，单位为 8 像素。
        if max(x,y)+floor(min(x,y)/2)<24*unit then
            o.seekX,o.seekY = (ran:Int(0,4)-2)*8*unit,(ran:Int(0,4)-2)*8*unit
        end
    end
    local vx, vy = vector(o.auxSpeed,o.auxHeading)
    o.auxX, o.auxY = o.auxX+vx+dx, o.auxY+vy+dy
    if o.baseY<320*unit then o.drift=max(0,o.drift-12) end

    o.firstX, o.firstY = trunc(o.baseX/unit), trunc(o.baseY/unit)
    o.lastX, o.lastY = trunc(o.auxX/unit), trunc(o.auxY/unit)
    o.midX = trunc((o.auxX-trunc(driftX/2)-trunc(driftX/3))/unit)
    o.midY = trunc((o.baseY-trunc((o.baseY-o.auxY)/2))/unit)
    if o.baseY<0 then o.auxY=o.auxY-unit end

    collision(o)
    o.colli = o.hp>=0 and o.y>=-208 and o.y<=208

    if o.hp<0 or o.baseY>=240*unit then return true end
    if not o.entered and o.baseY>=100*unit then o.entered,o.run.wormGate = true,true end
    firing(o,p,emit)
    return true
end

return function(emit)
    local Worm = Class(object, {
        init = function(o, run, frame, variant)
            o.run, o.hp = run, 3456
            o.birth, o.variant = frame, variant
            o.scrollRate, o.scrollRest, o.scrollPhase = variant.scrollRate, 0, 1
            -- 多留一像素给连续坐标判定，hitPilot 再比较板上的整数边界。
            o.group, o.layer, o.a, o.b = GROUP.ENEMY, LAYER.ENEMY, 49, 50
            o.rect, o.bound, o.colli = true, false, false
            o.damage, o.hitPilot = damage, hitPilot
            o.baseX, o.baseY = (variant.x-run.roadCamera)*unit, variant.y*unit
            local driftX,driftY = vector(1024,variant.driftAngle)
            o.auxX = o.baseX+(variant.flip>0 and driftX or 0)
            o.auxY = o.baseY+variant.targetHeight*unit+driftY
            o.facing, o.auxHeading, o.auxSpeed, o.drift = variant.facing, 0, 12, 1024
            o.minFacing,o.maxFacing = min(256,o.facing),max(256,o.facing)
            o.sweepClock, o.fanClock, o.fanCount = 0, ran:Int(36,44), 4
            o.seekX, o.seekY, o.wave = 0, 0, {}
            for slot = 0, 29 do o.wave[slot]=0 end
        end,
        colli = function(o, shot)
            if not shot.dmg or not shot.colli or not o.colli then return end
            damage(o,shot.dmg)
            object.RawDel(shot)
        end,
        render = function(o)
            if not o.firstX then return end
            local variant = o.variant
            local flash = o.hitFrame and o.run.roadFrame-o.hitFrame<=3 and o.run.roadFrame%2==1
            local fade = o.defeated and max(0,255-6*max(0,o.run.roadFrame-o.defeated-80)) or 255
            if fade==0 then return end
            SetImageState(texture..'_93','',floor(fade*0.4),255,255,255)
            Render(texture..'_93',o.firstX-120,o.firstY-160,0,variant.flip,1)
            -- 0x0c0ac610 在第一、二节使用独立亮度，最后一节的碰撞盒先于振动计算。
            for i, part in ipairs(variant.parts) do
                local t = part[3]
                local x = curve(t,o.firstX,o.midX,o.lastX) + (i==#variant.parts and 24*variant.flip or 0)
                local y = curve(t,o.firstY,o.midY,o.lastY)+variant.bodyY
                y = y+trunc(o.wave[part[4]]/10)/unit
                local image = texture..'_'..(part[1]+trunc(abs(o.facing-variant.facing)/part[2]))
                local tone = flash and 255 or part[5]
                SetImageState(image,'',fade,tone,tone,tone)
                Render(image,x-120,floor(y)-160,0,variant.flip,1)
            end
        end,
    })

    local function close(run)
        if IsValid(run.worm) then run.worm.hide=true; object.RawDel(run.worm) end
        run.worm, run.wormGate = nil, false
    end

    return {
        open = function()
            if CheckRes('img',texture..'_0') then return end
            LoadTexture(texture,'Resources/th46/stage1/worm1.png')
            SetTextureSamplerState(texture,'point+clamp')
            for slot = 0, 93 do
                LoadImage(texture..'_'..slot,texture,slot%12*144,floor(slot/12)*144,144,144)
            end
        end,
        step = function(run, frame, p, dx)
            if variants[frame] then
                run.worm = New(Worm,run,frame,variants[frame])
            elseif IsValid(run.worm) and not update(run.worm,frame,p,dx,emit) then
                close(run)
            end
        end,
        close = close,
    }
end
