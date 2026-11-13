-- Exact early-stage boss and gated set-piece state machines.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Projectile = assert(LikeDreamer.Projectile)
local M = {}
LikeDreamer.BossEarly = M

local sin, cos, pi = math.sin, math.cos, math.pi
local tau = pi * 2
local floor, ceil = math.floor, math.ceil
local abs, min, max = math.abs, math.min, math.max

local function trunc(v)
    return v < 0 and ceil(v) or floor(v)
end

local function atan2(y, x)
    if math.atan2 then return math.atan2(y, x) end
    if x > 0 then return math.atan(y / x) end
    if x < 0 and y >= 0 then return math.atan(y / x) + pi end
    if x < 0 then return math.atan(y / x) - pi end
    if y > 0 then return pi * 0.5 end
    if y < 0 then return -pi * 0.5 end
    return 0
end

local function aimAt(x, y, tx, ty)
    return Core.angle16(trunc(atan2(ty - y, tx - x) * 10430.378350470464))
end

local function playerPosition()
    local p = rawget(_G, "player")
    return p and p.ldX or 360, p and p.ldY or 600
end

local function playStageSound(name, volume)
	if (not lstg.CheckRes or lstg.CheckRes(5, name)) and
			type(lstg.PlaySound) == "function" then
		lstg.PlaySound(name, volume or 0.45, 0)
	end
end

local function aim(self, x, y)
    local px, py = playerPosition()
    return aimAt(x or self.ldX, y or self.ldY, px, py)
end

local function distanceSquared(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return dx * dx + dy * dy
end

local function diff(rt, values)
    return values[Core.clamp(rt.difficulty or 1, 0, 4) + 1]
end

local function move(self, angle, speed)
    local dx, dy = Core.polar(angle or self.angle16, speed or self.speed)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
end

local function fire(visual, behavior, x, y, angle, travel, speed, radius, arg)
    return Projectile.spawn(visual, behavior, x, y, angle, travel or 0,
                            speed or 0, radius or 1, arg or 0)
end

local function spread(visual, behavior, x, y, angle, travel, speed,
                      radius, count, width, arg)
    return Projectile.spread(visual, behavior, x, y, angle, travel or 0,
                             speed or 0, radius or 1, count or 1,
                             width or 0, arg or 0)
end

local function randomSigned(seed, magnitude)
    return Core.frameRand(seed) % (magnitude * 2 + 1) - magnitude
end

local function setInvulnerability(frames)
    local p = rawget(_G, "player")
    if p then p.invulnerableFrames = max(p.invulnerableFrames or 0, frames) end
end

local function spawnPostDeathCounter(enemy, lifetime)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnPostDeathCounter then
        return reward.spawnPostDeathCounter(enemy, lifetime)
    end
end

local function spawnEnemyDeathRewardBurstOnce(enemy, payoutWindow, rewardWeight)
    if enemy._beDeathRewardBurst or enemy._ldRewardSpawned then return false end
    local reward = LikeDreamer.Reward
    if not reward or not reward.spawnEnemyDeathRewardBurst then return false end
    enemy._beDeathRewardBurst = true
    enemy._ldRewardSpawned = true
    enemy.rewardWeight = rewardWeight
    reward.spawnEnemyDeathRewardBurst(enemy, payoutWindow)
    return true
end

local function spawnPlayerCancel(enemy, specialType)
    local p = rawget(_G, "player")
    local playerClass = LikeDreamer.PlayerClass
    if p and playerClass and p.class == playerClass and
            type(playerClass._spawnSpecial) == "function" then
        playerClass._spawnSpecial(p, specialType,
            enemy.ldX, enemy.ldY, 0, 0, 0, 0)
    end
end

local function spawnSetpieceDefeatFeedback(enemy, specialType)
    spawnPlayerCancel(enemy, specialType)
    local reward = LikeDreamer.Reward
    if reward and type(reward.spawnPlayerPortrait) == "function" then
        reward.spawnPlayerPortrait(enemy.runtime or LikeDreamer.runtime, 1, 0x78)
    end
end

local function quietRemove(self)
    if self.hp <= 0 then self.hp = 1 end
    self.targetable = false
    self.removeRequested = true
end

local function queueOwnerDamage(owner, amount)
    amount = max(1, trunc(amount))
    owner._beDamageQueue = owner._beDamageQueue or {}
    owner._beDamageQueue[#owner._beDamageQueue + 1] = {
        remaining = amount,
        chunk = max(1, trunc(amount / 30)),
    }
end

local function applyOwnerDamage(owner)
    local queue = owner._beDamageQueue
    if not queue then return end
    local write = 1
    for i = 1, #queue do
        local node = queue[i]
        local damage = min(node.remaining, node.chunk)
        node.remaining = node.remaining - damage
        owner.hp = owner.hp - damage
        if node.remaining > 0 then
            queue[write] = node
            write = write + 1
        end
    end
    for i = write, #queue do queue[i] = nil end
end

local function killChild(self, owner, damage, countChild)
    if self._beDeathHandled then return end
    self._beDeathHandled = true
    if owner and damage and damage > 0 then queueOwnerDamage(owner, damage) end
    if owner and countChild then
        owner.liveChildCount = max(0, (owner.liveChildCount or 0) - 1)
    end
    LikeDreamer.Enemy.Class.die(self, false)
end

local function spawnChild(rt, owner, typeId, hp, ox, oy, index, note)
    local child = rt:spawnChild(owner, typeId, hp,
        owner.ldX + (ox or 0), owner.ldY + (oy or 0), note)
    if not child then return nil end
    child._beOffsetX, child._beOffsetY = ox or 0, oy or 0
    child._beIndex = index or 0
    child.offsetX, child.offsetY = ox or 0, oy or 0
    child.maxhp = hp
    return child
end

local childRadii = {
    [0x15]=50,[0x16]=50,[0x17]=50,
    [0x22]=50,[0x23]=30,[0x24]=30,
    [0x30]=50,[0x31]=50,[0x32]=30,[0x33]=30,[0x34]=50,
    [0x40]=30,[0x41]=30,[0x42]=50,[0x43]=50,
}

local appearance = {
    [0x138]={"boss",0,1},[0x139]={"boss",10,1},
    [0x13a]={"boss",20,1},[0x13b]={"boss",25,1},
    [0x12]={"l",2,-1},[0x13]={"l",3,-2},[0x14]={"l",4,-2},
    [0x15]={"s",11,2},[0x16]={"s",11,2},[0x17]={"s",11,2},
    [0x22]={"m",39,2},[0x23]={"s",23,-1},[0x24]={"s",23,-1},
    [0x30]={"l",14,2},[0x31]={"m",62,2},
    [0x32]={"s",30,2},[0x33]={"s",30,2},[0x34]={"s",30,2},
    [0x40]={"m",75,2},[0x41]={"s",44,2},
    [0x42]={"m",76,2},[0x43]={"m",76,2},
}

local function exactToLuaLayer(exactLayer)
    if exactLayer<=0x24 then
        return (rawget(_G,"LAYER_ENEMY") or 0)+
            (exactLayer-0x23)*0.01
    end
    return (rawget(_G,"LAYER_ENEMY_BULLET") or -200)+
        exactLayer-0x50
end

local primaryLayerByType = {
    [0x138]=0x1e,[0x12]=0x1d,[0x13]=0x1c,[0x14]=0x1c,
    [0x15]=0x23,[0x16]=0x23,[0x17]=0x23,
    [0x139]=0x1e,[0x22]=0x23,[0x23]=0x1d,[0x24]=0x1d,
    [0x13a]=0x1e,[0x30]=0x1f,[0x31]=0x21,
    [0x32]=0x23,[0x33]=0x23,[0x34]=0x23,
    [0x13b]=0x1e,[0x40]=0x23,[0x42]=0x23,[0x43]=0x23,
}

local function primaryVisualLayer(self)
    if self.spawnType==0x41 then
        return (self.secondaryAngle16 or 0)>0x8000 and 0x1c or 0x1f
    end
    return primaryLayerByType[self.spawnType]
end

local extraVisualLayers = {
    [0x139]={0x0f,0x10,0x11,0x12,0x1f,0x20,0x21},
    [0x22]={0x1e},
    [0x13a]={0x20,0x22},[0x30]={0x1e},
    [0x13b]={0x1b},[0x40]={0x1c},
}

local function setAppearance(self)
    if self._beAppearance then return end
    local value=appearance[self.spawnType]
    if not value then return end
    self._beAppearance=true
    self.sheet,self.visualFrame=value[1],value[2]
    local exactLayer=primaryVisualLayer(self)
    self.layer=exactLayer and exactToLuaLayer(exactLayer) or
        ((rawget(_G,"LAYER_ENEMY") or self.layer or 0)+value[3])
end

local function setBossStatus(self, rt)
    rt.boss = self
    rt.bossState = self.state
    rt.bossTimer = self.helperTimer
    self.phaseIndex = self._bePhaseIndex or 0
end

local function openPhase(self, hp, countdown, radius, phaseIndex, state)
    self.state = state
    self.helperTimer = 0
    self.hp, self.maxhp = hp, hp
    self.countdown = countdown
    self.radius = radius
    self.targetable = true
    self.protect = false
    self._bePhaseIndex = phaseIndex
    self._bePhaseMode = 1
    self.portPhase = (self.portPhase or 0)+1
end

local function beginFinal(self, state)
    self.state = state
    self.helperTimer = 0
    self.targetable = false
    self.protect = true
    self._bePhaseMode = -1
end

local function finishBoss(self, rt)
    self.active = false
    self.targetable = false
    Del(self)
    rt.gate = false
    rt.complete = true
end

local function phaseBreak(self, rt, nextStates, radiusByBreak)
    if self._bePhaseMode ~= 1 or (self.hp > 0 and self.countdown > 0) then
        return false
    end
    local timedOut = self.countdown <= 0
    if timedOut then
        Projectile.clear()
        setInvulnerability(100)
    else
        spawnPlayerCancel(self, 0x18)
    end
    spawnPostDeathCounter(self, 140)
    self.targetable = false
    self.protect = true
    self.helperTimer = 0
    self.liveChildCount = 0
    local remaining = self._beBreaks
    self.state = nextStates[remaining]
    if radiusByBreak and radiusByBreak[remaining] then
        self.radius = radiusByBreak[remaining]
    end
    self._beBreaks = max(0, remaining - 1)
    if self._beBreaks == 0 then self._bePhaseMode = -1
    else self._bePhaseMode = 2 end
    return true
end

local function updateCountdown(self)
    if self._bePhaseMode == 1 then self.countdown = self.countdown - 1 end
end

local function refreshTarget(self, rt, xmod, xbase, ymod, ybase, salt)
    self._beTargetX = Core.randomCoord(rt.frame, xmod, xbase)
    self._beTargetY = Core.randomCoord(rt.frame + (salt or 0), ymod, ybase)
end

local function steer(self, targetAngle, turn)
    self.angle16 = Core.turn16(self.angle16, targetAngle, turn)
    move(self)
end

-- Stage 1 gated set piece ---------------------------------------------------

local function updateSetpiece10(self, rt)
    local t, d = self.helperTimer, rt.difficulty
    if not self._beInitialized then
        self._beInitialized = true
        self._beBaseY = self.ldY
        self.speed = 0.7
    end
    applyOwnerDamage(self)
    if self.state == 0 then
        if t == 0 then
            local offsets = {{160,40},{-160,40},{270,-20},{-270,-20}}
            for i, o in ipairs(offsets) do
                if rt.stage == 1 or i <= 2 then
                    local c = spawnChild(rt, self, 0x11, 7000, o[1], o[2], i - 1,
                                         "S01 set-piece turret 0x11")
                    if c then c._beTransfer = 3500 end
                end
            end
        end
        self._beBaseY = self._beBaseY + 1
        if t < 90 then
            self.ldY = self._beBaseY + 1000 - sin(t * pi / 180) * 1000
        else
            self.ldY = self._beBaseY
        end
        if t == 120 then
            self.state, self.helperTimer = 1, 0
            self.targetable, self.protect = true, false
        end
        return
    end
    if self.state == 2 then
        self.ldY = self.ldY + 0.1
        if t >= 60 then quietRemove(self); rt.gate = false end
        return
    end
    if t < 900 then
        if t % 20 == 0 then
            self._beTargetX = Core.randomCoord(rt.frame, 321, 200)
            self._beTargetY = Core.randomCoord(rt.frame + 0x457, 41, 180)
        end
        local a = aimAt(self.ldX, self.ldY,
            self._beTargetX or 360, self._beTargetY or 200)
        self.angle16 = Core.turn16(self.angle16, a, 0x200)
    else
        self.angle16 = 0xc000
        self.speed = (t - 900) * 0.1
    end
    move(self)

    if t >= 30 and t < 300 then
        local period = diff(rt, {120,60,60,60,60})
        local q = (t - 30) % period
        if q < 20 and q % 3 == 0 then
            local count = diff(rt, {1,3,5,5,7}) + (t > 239 and 2 or 0)
            local speed = diff(rt, {3,4,5,6,7}) + t * 0.01
            spread(0, 0, self.ldX, self.ldY + 70, aim(self, self.ldX, self.ldY + 70),
                   0, speed, 1, count, 0x8000, 0)
            if d > 2 then
                spread(0, 0, self.ldX, self.ldY + 70, aim(self, self.ldX, self.ldY + 70),
                       0, speed - 2, 1, count, 0x8000, 0)
            end
        end
    end
    if t >= 420 and t < 900 then
        local period = diff(rt, {100,80,70,60,50})
        if (t - 420) % period == 0 then
            local volley = floor((t - 420) / period)
            local count = diff(rt, {5,7,9,9,11}) + volley * 2
            local speed = diff(rt, {3.5,4.5,5.5,6.5,8}) + volley * 0.2
            spread(2, 0, self.ldX, self.ldY - 20, aim(self), 0, speed, 1,
                   count, 0x8000, 0)
            if d > 2 then
                spread(2, 0, self.ldX, self.ldY - 20, aim(self), 0, speed + 2, 1,
                       count, 0x8000, 0)
            end
        end
    end
    if self.hp <= 0 then
        spawnEnemyDeathRewardBurstOnce(self, 0x708, 120)
        spawnSetpieceDefeatFeedback(self, 0x18)
        self.hp = 1
        self.state, self.helperTimer = 2, 0
        self.targetable, self.protect = false, true
    end
end

local function updateSetpiece11(self, rt)
    local parent, t = self.parent, self.helperTimer
    if not parent or not parent.active or parent.state == 2 then quietRemove(self); return end
    local ox, oy = self._beOffsetX or 0, self._beOffsetY or 0
    local entry = min(1, t / 120)
    local tx = parent.ldX + ox * entry
    local ty = parent.ldY + oy * entry
    self.ldX = self.ldX + (tx - self.ldX) / 20
    self.ldY = self.ldY + (ty - self.ldY) / 20
    if self.state == 0 and t == 120 then
        self.state, self.helperTimer = 1, 0
        self.targetable = true
    end
    if self.state == 1 then
        local age = self.age
        local sourceAim
        if age < 300 then sourceAim = aimAt(parent.ldX, parent.ldY, playerPosition())
        else sourceAim = aim(self) end
        local step = age < 300 and 0x20 or max(1, floor(abs(Core.angleDelta(self.angle16, sourceAim)) / 20) + 1)
        self.angle16 = Core.turn16(self.angle16, sourceAim, step)
        if age < 300 then
            local period = diff(rt, {60,32,24,20,16})
            if age % period == 0 then
                local speed = diff(rt, {3.5,4.5,5,5,6.5})
                fire(7,0,self.ldX,self.ldY-20,self.angle16,10,speed,1,0)
                fire(7,0,self.ldX,self.ldY-20,self.angle16,10,speed+0.3,1,0)
                if rt.difficulty > 2 then
                    fire(7,0,self.ldX,self.ldY-20,self.angle16,10,speed+2,1,0)
                    fire(7,0,self.ldX,self.ldY-20,self.angle16,10,speed+2.3,1,0)
                end
            end
        end
        local late = age - 390
        if late >= 0 and late < 510 then
            local period = diff(rt, {100,80,70,60,50})
            local q = late % period
            if q < 25 and q % 3 == 0 then
                local layers = diff(rt, {1,1,2,3,3})
                for i = 0, layers - 1 do
                    local speed = diff(rt, {4,5,6,7,8}) + i * 0.7
                    spread(9,0,self.ldX,self.ldY-20,self.angle16,10,speed,1,2,1200+i*600,0)
                end
            end
        end
    end
    if self.hp <= 0 then killChild(self, parent, self._beTransfer or self.maxhp / 2, false) end
end

-- Stage 2 gated set piece ---------------------------------------------------

local function updateSetpiece20(self, rt)
    local t = self.helperTimer
    if not self._beInitialized then self._beInitialized = true end
    self.ldY = self.ldY + (rt.scrollDelta or 1)
    if self.state == 0 then
        if t == 0 and rt.stage == 2 then
            local points = {{420,320},{235,260},{570,210},{125,120},{620,60}}
            local childHp = rt.difficulty == 0 and 0x0a00 or 0x0c80
            for i, p in ipairs(points) do
                local c = rt:spawnChild(self,0x21,childHp,p[1],self.ldY+p[2],
                                        "S02 set-piece turret 0x21")
                if c then
                    c._beIndex = i - 1
                    c._beWorldLocked = true
                end
            end
            self.liveChildCount = 5
        end
        if self.ldY >= -150 then
            self.state, self.helperTimer = 1, 0
            self.targetable = true
            t = 0
        end
        if self.state == 0 then return end
    end
    if self.state == 2 then
        if t >= 60 then quietRemove(self); rt.gate = false end
        return
    end
    if self.ldY < 350 and t >= 50 then
        local q = (t - 50) % 120
        if q < 60 then
            local interval = diff(rt, {45,30,20,15,15})
            if q % interval == 0 then
                local fireY = self.ldY + 85 + 2*sin(t*tau/72)
                local a = Core.angle16(aim(self,self.ldX,fireY) +
                    randomSigned(t,1500))
                spread(3,7,self.ldX,fireY,a,10,
                       diff(rt,{5,6,7,7.5,9.5}),1,
                       diff(rt,{7,11,15,19,21}),0x8000,0)
            end
        end
    end
    if self.hp <= 0 then
        spawnEnemyDeathRewardBurstOnce(self, 0x708, 120)
        spawnSetpieceDefeatFeedback(self, 0x19)
        self.hp = 1; self.state, self.helperTimer = 2, 0
        self.targetable = false
    end
end

local function updateSetpiece21(self, rt)
    local parent, t = self.parent, self.helperTimer
    if not parent or not parent.active or parent.state == 2 then quietRemove(self); return end
    self.ldY = self.ldY + (rt.scrollDelta or 1)
    if self.state == 0 and self.ldY >= -55 then
        self.state, self.helperTimer = 1, 0
        t = 0
    end
    if self.state == 1 and t == 30 then self.targetable = true end
    if self.state == 1 and self.ldY < 350 and t >= 60 and
       Core.inside(self.ldX,self.ldY,0) then
        local period = diff(rt,{180,150,120,120,100})
        local q = (t - 60) % period
        if q == 0 then self.targetAngle16 = aim(self,self.ldX,self.ldY-20) end
        local cadence = diff(rt,{20,14,10,10,8})
        local speed = diff(rt,{4,5,5.5,6,7.5})
        if q < 48 and q % cadence == 0 then
            local fanIndex = floor(q / cadence)
            spread(0x0c,0,self.ldX,self.ldY-20,self.targetAngle16,10,
                   speed,1,fanIndex+1,
                   diff(rt,{6000,4400,3200,3200,2800})*fanIndex,0)
        end
        if rt.difficulty >= 3 and q < 25 and q % 5 == 0 then
            local count = floor(q / 5) + 1
            spread(0x0d,0,self.ldX,self.ldY-20,self.targetAngle16,10,
                   speed+3,1,count,(count-1)*250,0)
        end
    end
    if self.hp <= 0 then killChild(self,parent,0,true) end
end

-- Stage 3 gated set piece ---------------------------------------------------

local function updateSetpiece2e(self, rt)
    local t = self.helperTimer
    if not self._beInitialized then
        self._beInitialized = true; self._beBaseY = self.ldY; self.speed = 0.7
    end
    if self.state == 0 then
        if t == 0 then spawnChild(rt,self,0x2f,self.hp,0,240,0,"S03 shared hitbox 0x2f") end
        self._beBaseY = self._beBaseY + 1
        if t < 90 then
            local entry = sin(t*pi/180)
            self.ldX = self.originX - 1000 + entry*1000
            self.ldY = self._beBaseY + 1000 - entry*1000
        else self.ldX,self.ldY = self.originX,self._beBaseY end
        if t == 120 then
            self.state,self.helperTimer=1,0;self.targetable=true
        end
        return
    end
    if self.state == 2 then
        self.ldY=self.ldY+0.1
        if t>=60 then quietRemove(self);rt.gate=false end
        return
    end
    if t < 1300 then
        if t % 20 == 0 then
            self._beTargetX=Core.randomCoord(rt.frame,241,240)
            self._beTargetY=Core.randomCoord(rt.frame+0x457,61,20)
        end
        self.angle16=Core.turn16(self.angle16,
            aimAt(self.ldX,self.ldY,self._beTargetX or 360,self._beTargetY or 50),0x200)
        if t>=520 and t<620 then self.speed=self.speed+0.01 end
    else self.angle16=0xc000;self.speed=(t-1300)*0.1 end
    move(self)
    local function sideWindow(start, sx)
        if t>=start and t<start+160 then
            local localt=t-start
            local cadence=diff(rt,{24,20,18,18,16})
            if localt%cadence==0 then self.targetAngle16=aim(self,self.ldX+sx,self.ldY) end
            local repeatCount=diff(rt,{3,3,4,6,6})
            for i=0,repeatCount-1 do
                if localt==i*cadence then
                    spread(4,0,self.ldX+sx,self.ldY,self.targetAngle16+(sx>0 and i or -i)*700,
                           0,diff(rt,{4,5,6,6.5,8}),1,diff(rt,{1,3,4,4,5}),5000,0)
                end
            end
        end
    end
    sideWindow(90,-100);sideWindow(320,100)
    if t>=550 and t<1300 then
        local period=diff(rt,{70,48,38,32,28});local q=(t-550)%period
        if q==0 then
            self._beAimL=aim(self,self.ldX-100,self.ldY)
            self._beAimR=aim(self,self.ldX+100,self.ldY)
        end
        if q<20 and q%4==0 then
            local n=floor((t-550)/period)+1
            local count=n+1;local width=n*diff(rt,{6000,4000,3200,2800,2600})
            spread(9,0,self.ldX-100,self.ldY,self._beAimL or aim(self),10,
                   diff(rt,{4,5,6,7,8}),1,count,width,0)
            spread(9,0,self.ldX+100,self.ldY,self._beAimR or aim(self),10,
                   diff(rt,{4,5,6,7,8}),1,count,width,0)
        end
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,0x708,120)
        spawnSetpieceDefeatFeedback(self,0x18)
        self.hp=1;self.state,self.helperTimer=2,0;self.targetable=false
    end
end

local function updateSetpiece2f(self, rt)
    local parent,t=self.parent,self.helperTimer
    if not parent or not parent.active or parent.state==2 then quietRemove(self);return end
    self.ldX=self.ldX+(parent.ldX-self.ldX)/7
    self.ldY=self.ldY+(parent.ldY+240-self.ldY)/7
    if self.state==0 and t==120 then
        self.state,self.helperTimer=1,0;self.hp=parent.hp;self.maxhp=parent.maxhp;self.targetable=true
    end
    if self.state==1 then
        local windows={10,58,114,178,250,330,418,514}
        for _,start in ipairs(windows) do
            if t<500 and t>=start and t<start+40 then
                local q=t-start
                self.targetAngle16=Core.turn16(self.targetAngle16,aim(self),400)
                if q%4==0 then
                    local speed=diff(rt,{3.5,4.5,5,5,6.5})+q*0.12
                    spread(13,0,self.ldX,self.ldY,self.targetAngle16,0,speed,1,
                           diff(rt,{1,3,5,5,5}),27000,0)
                    if rt.difficulty>=3 then
                        fire(13,0,self.ldX,self.ldY,self.targetAngle16-800,0,speed+1,1,0)
                        fire(13,0,self.ldX,self.ldY,self.targetAngle16+800,0,speed+1,1,0)
                    end
                end
                break
            end
        end
        if self.hp<parent.hp then parent.hp=self.hp elseif parent.hp<self.hp then self.hp=parent.hp end
        if self.hp<=0 then parent.hp=0 end
    end
end

-- Stage 4 gated set piece ---------------------------------------------------

local function updateSetpiece3f(self,rt)
    local t=self.helperTimer
    if not self._beInitialized then self._beInitialized=true;self.speed=0.3 end
    if self.state==0 then
        if t<90 then
            local e=sin(t*pi/180)
            self.ldX=self.originX+(self.originX<360 and -1000 or 1000)*(1-e)
            self.ldY=self.originY+t+1+1000*(1-e)
        else
            self.ldX,self.ldY=self.originX,self.originY+t+1
        end
        if t==120 then self.state,self.helperTimer=1,0;self.targetable=true end
        return
    end
    if self.state==2 then
        self.ldY=self.ldY+0.1
        if t>=60 then quietRemove(self);rt.gate=false end
        return
    end
    if t<900 then
        if t%20==0 then
            self._beTargetX=Core.randomCoord(rt.frame,241,240)
            self._beTargetY=Core.randomCoord(rt.frame+0x457,61,40)
        end
        self.angle16=Core.turn16(self.angle16,
            aimAt(self.ldX,self.ldY,self._beTargetX or 360,self._beTargetY or 70),0x200)
        self.speed=0.3
    else self.angle16=0x4000;self.speed=(t-900)*0.1 end
    move(self)
    if t<900 then
        local half=diff(rt,{70,55,45,40,40});local window=diff(rt,{12,16,20,20,20})
        for gun=0,3 do
            local start=gun*half;local q=(t-start)%(half*4)
            if q<window and q%3==0 then
                local a=aim(self)+gun*0x4000
                local speed=diff(rt,{4.5,5.5,6,7.5,9.5})
                for k=-1,1 do fire(7,0,self.ldX,self.ldY,a+k*2200,10,speed,1,0) end
                if rt.difficulty>2 then
                    for k=-1,1 do fire(7,0,self.ldX,self.ldY,a+k*2200,10,speed+2,1,0) end
                end
            end
        end
        if t>=60 and t<420 then
            local q=(t-60)%90;local cadence=diff(rt,{16,10,8,7,5})
            if q<50 and q%cadence==0 then
                local a=aim(self)+randomSigned(rt.frame,5000)
                local speed=diff(rt,{3,4,4.5,4.5,6})+t*0.005
                fire(4,0,self.ldX,self.ldY,a,0,speed,1,0)
                if rt.difficulty>=3 then fire(4,0,self.ldX,self.ldY,a,0,speed+2,1,0) end
                if rt.difficulty==4 then
                    fire(4,0,self.ldX,self.ldY,a-2000,0,speed,1,0)
                    fire(4,0,self.ldX,self.ldY,a+2000,0,speed,1,0)
                end
            end
        end
        if t>=450 then
            local period=diff(rt,{100,70,60,50,25})
            if (t-450)%period==0 then
                local speed=diff(rt,{4,5,6,7,8})+(t-450)*0.005
                local count=diff(rt,{7,9,11,13,15})
                spread(2,0,self.ldX,self.ldY,aim(self),0,speed,1,count,0x8000,0)
                if rt.difficulty>2 then spread(2,0,self.ldX,self.ldY,aim(self),0,speed+2,1,count,0x8000,0) end
            end
        end
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,0x708,120)
        spawnSetpieceDefeatFeedback(self,0x18)
        self.hp=1;self.state,self.helperTimer=2,0;self.targetable=false
    end
    if not Core.inside(self.ldX,self.ldY,400) then quietRemove(self);rt.gate=false end
end

-- Stage 1 boss --------------------------------------------------------------

local function initBoss138(self)
    if self._beInitialized then return end
    self._beInitialized=true;self._bePhaseMode=0;self._beBreaks=3
    self._beTargetX,self._beTargetY=360,200
    self.state=0;self.helperTimer=0;self.speed=0.3;self.angle16=0
    self.radius=160;self.targetable=false;self.protect=true;self.liveChildCount=0
    self.intro=0
end

local function emitBoss138(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==1 and t>=40 then
        local q=(t-40)%720;local cy=self.ldY+70
        local primarySpeed=diff(rt,{4,5,6.5,7.5,9})
        if q%60==0 then self.secondaryAngle16=aim(self,self.ldX,cy) end
        local primary=q<30 or (q>=240 and q<270) or (q>=300 and q<330) or
                      (q>=600 and q<630) or (q>=660 and q<690)
        if primary and q%4==0 then
            fire(11,0,self.ldX,cy,self.secondaryAngle16,10,primarySpeed,1,0)
            if d>2 then
                fire(11,0,self.ldX,cy,self.secondaryAngle16-1500,10,primarySpeed-1,1,0)
                fire(11,0,self.ldX,cy,self.secondaryAngle16+1500,10,primarySpeed-1,1,0)
            end
        end
        local v1=(q>=10 and q<40) or (q>=250 and q<280) or
                 (q>=310 and q<340) or (q>=610 and q<640) or (q>=670 and q<700)
        if d>0 and v1 then
            local phase=(q-10)%60
            if phase%diff(rt,{7,7,5,5,4})==0 then
                spread(1,0,self.ldX,cy,self.secondaryAngle16,0,primarySpeed-0.4,1,2,phase*800+1200,0)
                if d>2 then spread(1,0,self.ldX,cy,self.secondaryAngle16,0,primarySpeed-1.6,1,2,phase*800+2000,0) end
            end
        end
        local right=q>=60 and q<100;local left=q>=125 and q<165
        if q==60 or q==125 then
            local sx=self.ldX+(q==60 and 95 or -95)
            self.targetAngle16=aim(self,sx,self.ldY-5)
        end
        local cadence=diff(rt,{20,14,10,10,10})
        if (right and (q-60)%cadence==0) or (left and (q-125)%cadence==0) then
            local sx=self.ldX+(right and 95 or -95);local a=self.targetAngle16+randomSigned(t,3000)
            local speed=diff(rt,{3.5,4.5,6.5,7,9});local count=diff(rt,{3,5,7,7,8})
            spread(4,0,sx,self.ldY-5,a,0,speed,1,count,12000,0)
            if d>2 then spread(0,0,sx,self.ldY-5,a,0,speed-2,1,count,12000,0) end
        end
        local rr=q>=360 and q<440;local lr=q>=470 and q<560
        local rc=diff(rt,{6,4,3,3,2})
        if (rr and (q-360)%rc==0) or (lr and (q-470)%rc==0) then
            local sx=self.ldX+(rr and 95 or -95);local step=diff(rt,{1000,1400,2060,2060,2900})
            local a=rr and q*step+0x6000 or -0x6000-q*step
            local speed=diff(rt,{3.5,5.5,6,6,7.5})+(q-(rr and 360 or 470))*0.01
            local count=diff(rt,{3,5,7,9,11});local width=count*400-400
            spread(4,0,sx,self.ldY-5,a,0,speed,1,count,width,0)
            if d>2 then spread(4,0,sx,self.ldY-5,a,0,speed+1.2,1,count,width,0) end
        end
    elseif self.state==3 and t>=180 then
        local cadence=diff(rt,{16,12,8,7,6});local count=diff(rt,{1,3,4,5,7})
        local width=diff(rt,{0,7000,10000,12000,16000});local step=diff(rt,{180,240,300,300,350})
        local speed=diff(rt,{3.5,4,4.5,5,7.2});local none=(self.liveChildCount or 0)<1
        if none then speed=speed*1.5 end
        if (t-180)%cadence==0 then
            spread(4,0,self.ldX,self.ldY,(t-180)*step-0x2000,0,speed,1,count,width,0)
            if none then spread(5,0,self.ldX,self.ldY,(t-180)*step+0x2000,0,speed+1,1,count,width,0) end
        end
        if t>=280 and (t-280)%cadence==0 then
            spread(4,0,self.ldX,self.ldY,(280-t)*step-0x6000,0,speed,1,count,width,0)
            if none then spread(5,0,self.ldX,self.ldY,(280-t)*step+0x6000,0,speed+1,1,count,width,0) end
        end
    elseif self.state==5 and t>=160 then
        local destroyed=Core.clamp(4-(self.liveChildCount or 0),0,4)
        local count=diff(rt,{7,9,11,11,13});local period=(5-destroyed)*20
        local speed=diff(rt,{4.5,5.5,6.5,6.5,7.5})+destroyed*0.5
        local a=aim(self,self.ldX,self.ldY-25)
        if self.liveChildCount==0 then a=Core.angle16(a+randomSigned(t,3000)) end
        if (t-160)%period==0 then
            spread(2,0,self.ldX,self.ldY,a,0,speed,1,count,0x8000,0)
            if d>2 then spread(2,0,self.ldX,self.ldY,a,0,speed+1.8,1,count,0x8000,0) end
        end
        if self.liveChildCount==0 and t>=170 and (t-170)%20==0 then
            spread(3,0,self.ldX,self.ldY,a,0,speed,1,count,0x8000,0)
        end
    end
end

local function updateBoss138(self,rt)
    initBoss138(self);applyOwnerDamage(self)
    local target=aimAt(self.ldX,self.ldY,self._beTargetX,self._beTargetY)
    if rt.frame%50==0 then refreshTarget(self,rt,301,210,101,150,rt.stage*111) end
    phaseBreak(self,rt,{[3]=2,[2]=4,[1]=6},{[3]=240})
    self._beDrawState,self._beDrawTimer=self.state,self.helperTimer
    local t=self.helperTimer
    if self.state==0 then
        if t==0 then spawnChild(rt,self,0x12,99999999,0,210,0,"S01 decoration root") end
        if t<180 then
            local a=(t+60)*pi/120;local amp=-600+600*sin(t*pi/360)
            self.ldX=self.originX+trunc(sin(a)*amp)
            self.ldY=600+trunc(sin(a)*(self.originY-600))
        elseif t<191 then self.ldX,self.ldY=self.originX,self.originY
        else self.ldY=self.ldY+0.1 end
        if t==240 then openPhase(self,60000,1800,160,0,1) end
    elseif self.state==1 then steer(self,target,0x200);emitBoss138(self,rt)
    elseif self.state==2 then
        if t<120 then self.ldY=self.ldY+t*0.02 elseif t>=130 then steer(self,target,0x200) end
        if t==380 then openPhase(self,55000,1800,80,1,3) end
    elseif self.state==3 then
        steer(self,target,0x200)
        local data={
            [1]={0x15,0,-30,200,6000},[11]={0x15,1,-30,-200,6000},
            [21]={0x15,2,-140,110,6000},[31]={0x15,3,-140,-110,6000},
        }
        local v=data[t]
        if v then spawnChild(rt,self,v[1],v[5],v[3],v[4],v[2],"S01 phase-two part");self.liveChildCount=self.liveChildCount+1 end
        emitBoss138(self,rt)
    elseif self.state==4 then
        self.ldY=self.ldY+0.1
        if t==180 then openPhase(self,60000,1800,80,2,5) end
    elseif self.state==5 then
        steer(self,target,0x200)
        local data={
            [1]={0x16,0,200,-30,12000},[11]={0x16,1,-200,-30,12000},
            [21]={0x17,0,100,-160,7000},[31]={0x17,1,-100,-160,7000},
        }
        local v=data[t]
        if v then spawnChild(rt,self,v[1],v[5],v[3],v[4],v[2],"S01 final-phase part");self.liveChildCount=self.liveChildCount+1 end
        emitBoss138(self,rt)
    elseif self.state==6 then
        if t==1 then setInvulnerability(360) end
        if t<240 then self.ldY=self.ldY+0.2 end
        if t==480 then finishBoss(self,rt) end
    end
    updateCountdown(self);setBossStatus(self,rt)
end

local function updateDecoration138(self,rt)
    local parent=self.parent
    if not parent or not parent.active then quietRemove(self);return end
    local tx=parent.ldX+(self._beOffsetX or 0);local ty=parent.ldY+(self._beOffsetY or 0)
    if self.helperTimer==0 then self.ldX,self.ldY=parent.ldX,parent.ldY
    else self.ldX=self.ldX+(tx-self.ldX)/5;self.ldY=self.ldY+(ty-self.ldY)/5 end
    if self.spawnType==0x12 and self.helperTimer==0 then
        spawnChild(rt,self,0x13,99999999,60,120,0,"S01 decoration")
        spawnChild(rt,self,0x13,99999999,-60,120,1,"S01 decoration")
        spawnChild(rt,self,0x14,99999999,80,-80,2,"S01 decoration")
        spawnChild(rt,self,0x14,99999999,-80,-80,3,"S01 decoration")
    end
    local root=parent.spawnType==0x138 and parent or parent.parent
    if not root or root.state>2 or (root.state==2 and root.helperTimer>=130) then quietRemove(self) end
end

local function updateChild138(self,rt)
    local parent=self.parent
    if not parent or not parent.active or parent._bePhaseMode~=1 or
       (parent.state~=3 and parent.state~=5) then quietRemove(self);return end
    local t=self.helperTimer;local ox,oy=self._beOffsetX,self._beOffsetY
    local tx,ty=parent.ldX+ox,parent.ldY+oy
    if t==0 then
        self.ldX,self.ldY=parent.ldX+ox*3,parent.ldY+oy*3
        if self.spawnType==0x16 then self.secondaryAngle16=ox>0 and 0xe000 or 0xa000 end
    else self.ldX=self.ldX+(tx-self.ldX)/30;self.ldY=self.ldY+(ty-self.ldY)/30 end
    if self.state==0 and t==60 then self.state,self.helperTimer=1,0;self.targetable=true end
    if self.state==1 then
        local pt=parent.helperTimer;local sy=self.ldY-20;local idx=self._beIndex or 0
        if self.spawnType==0x15 then
            local period=diff(rt,{150,100,80,80,60});local start=(idx+9)*10
            if pt>=start then
                local q=(pt-start)%period;if q==0 then self.targetAngle16=aim(self,self.ldX,sy) end
                if q<12 and q%4==0 then
                    local speed=diff(rt,{5,6,7,9,11});fire(7,0,self.ldX,sy,self.targetAngle16,10,speed,1,0)
                    if rt.difficulty>2 then
                        fire(7,0,self.ldX,sy,self.targetAngle16-700,10,speed-1.4,1,0)
                        fire(7,0,self.ldX,sy,self.targetAngle16+700,10,speed-1.4,1,0)
                    end
                end
            end
        elseif self.spawnType==0x16 then
            if pt>89 and pt<210 then self.secondaryAngle16=Core.angle16(self.secondaryAngle16+(ox>0 and 200 or -200))
            elseif pt>=210 then
                local a=aimAt(parent.ldX,parent.ldY,playerPosition())
                self.secondaryAngle16=Core.clamp(Core.turn16(self.secondaryAngle16,a,0x20),0x3060,0x4fa0)
            end
            if pt>89 and (pt-90)%4==0 then
                spread(7,0,self.ldX,sy,self.secondaryAngle16,10,10,1,
                       diff(rt,{1,1,2,2,2}),diff(rt,{0,0,1500,2400,3000}),0)
            end
            local cadence=diff(rt,{24,11,9,9,5})
            if pt>=380 and (pt-380)%cadence==0 then
                local step=(ox>0 and -1 or 1)*diff(rt,{100,190,160,160,370})
                local speed=diff(rt,{3,4,5,5,6})
                for i=0,2 do
                    local a=i*0x5555+self.helperTimer*step
                    fire(8,0,self.ldX,sy,a,10,speed,1,0)
                    if rt.difficulty>2 then fire(8,0,self.ldX,sy,a,10,speed+1,1,0) end
                end
            end
        else
            local period=diff(rt,{200,120,100,90,80});local start=210+(idx-1)*floor(period/2)
            if pt>=start then
                local q=(pt-start)%period;if q==0 then self.targetAngle16=aim(self,self.ldX,sy) end
                if q<24 and q%4==0 then
                    local speed=diff(rt,{5,6,7,9,11});fire(11,0,self.ldX,sy,self.targetAngle16,10,speed,1,0)
                    if rt.difficulty>1 then
                        fire(11,0,self.ldX,sy,self.targetAngle16-3000,10,speed-0.2,1,0)
                        fire(11,0,self.ldX,sy,self.targetAngle16+3000,10,speed-0.2,1,0)
                    end
                end
            end
        end
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,1000,10)
        killChild(self,parent,self.maxhp,true)
    end
end

-- Stage 2 boss --------------------------------------------------------------

local function initBoss139(self)
    if self._beInitialized then return end
    self._beInitialized=true;self._bePhaseMode=0;self._beBreaks=4
    self._beTargetX,self._beTargetY=360,180;self.state=0;self.helperTimer=0
    self.speed=0.3;self.angle16=0;self.radius=180;self.targetable=false;self.protect=true
    self.liveChildCount=0;self.intro=0
end

local function emitBoss139(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==1 and t>=30 then
        local q=(t-30)%960;local sx={70,-70,140,-140};local sy={0,0,-80,-80}
        if q<300 then
            for source=1,4 do
                local x,y=self.ldX+sx[source],self.ldY+sy[source]
                if source<=2 then
                    local period=diff(rt,{120,90,80,70,60});local start=period+20
                    if q>=start then
                        local phase=(q-start)%period;local key=source==1 and "_beAimA" or "_beAimB"
                        if phase==0 then self[key]=aim(self,x,y) end
                        if phase<diff(rt,{15,24,30,30,30}) and phase%3==0 then
                            local speed=diff(rt,{5.5,7,8,9,11});fire(3,7,x,y,self[key],10,speed,1,0)
                            if d>=3 then
                                fire(3,7,x,y,self[key]-1400,10,speed-1.5,1,0)
                                fire(3,7,x,y,self[key]+1400,10,speed-1.5,1,0)
                            end
                        end
                        self[key]=Core.turn16(self[key] or aim(self,x,y),aim(self,x,y),0x20)
                    end
                else
                    local interval=diff(rt,{18,11,9,10,9});local stagger=source==3 and 0 or interval
                    if q>=stagger and (q-stagger)%(interval*2)==0 then
                        local count=diff(rt,{3,4,5,5,6});local speed=diff(rt,{4,4.5,5.5,6,7.5})
                        local a=aim(self,x,y)+randomSigned(t,7000)
                        spread(4,0,x,y,a,0,speed,1,count,(count-1)*440,0)
                        if d>=3 then
                            local hc=count-2;local hw=(hc-1)*440
                            spread(4,0,x,y,a-2000,0,speed,1,hc,hw,0)
                            spread(4,0,x,y,a-12000,0,speed,1,hc,hw,0)
                        end
                    end
                end
            end
        elseif q>=330 and q<660 then
            local localt=q-330;local period=diff(rt,{18,9,6,5,4})
            if localt%period==0 then
                local speed=diff(rt,{2.5,3.5,4,4,5.5})+localt*0.01
                local step=diff(rt,{160,250,300,300,440});local offsets={-3000,3000,-9000,9000}
                for i=1,4 do
                    local a=localt*step+offsets[i];local x,y=self.ldX+sx[i],self.ldY+sy[i]
                    fire(9,0,x,y,a,10,speed,1,0);fire(8,0,x,y,-a,10,speed,1,0)
                    if d>=3 then fire(9,0,x,y,a,10,speed+1.2,1,0);fire(8,0,x,y,-a,10,speed+1.2,1,0) end
                end
            end
        elseif q>=690 and q<930 then
            local localt=q-690;local period=diff(rt,{90,60,50,40,40});local phase=localt%period
            if phase==0 then self.secondaryAngle16=aimAt(self.ldX,0,playerPosition()) end
            if phase<diff(rt,{20,20,30,20,30}) and phase%4==0 then
                local offsets={-1000,1000,-2000,2000};local first=d==0 and 3 or 1
                for i=first,4 do
                    local x,y=self.ldX+sx[i],self.ldY+sy[i];local center=self.secondaryAngle16+offsets[i]
                    for opposite=0,1 do
                        local a=center-opposite*0x8000;local speed=diff(rt,{5,6,6.5,7,8})
                        fire(2,0x17,x,y,a,10,speed,1,0)
                        if d>=3 then fire(2,0x17,x,y,a-2000,10,speed,1,0);fire(2,0x17,x,y,a+2000,10,speed,1,0) end
                    end
                end
            end
        end
    elseif self.state==5 and t>59 then
        local q=(t-60)%480
        if q>89 and q<450 then
            local period=diff(rt,{120,80,70,60,60});local phase=(q-90)%period
            local x,y=self.ldX-25,self.ldY-85
            if phase==0 then self.secondaryAngle16=aim(self,x,y) end
            if phase<24 and phase%3==0 then
                local count=diff(rt,{5,7,9,7,9});local speed=diff(rt,{4.5,5.5,7,8,9})+((q-60)%period)*0.07
                spread(16,0,x,y,self.secondaryAngle16,10,speed,1,count,0x8000,0)
                if d>=3 then local hc=count-1;spread(16,0,x,y,self.secondaryAngle16,10,speed-1.4,1,hc,floor(0x8000/hc)*(hc-1),0) end
            end
            self.secondaryAngle16=Core.turn16(self.secondaryAngle16,aim(self,x,y),0x30)
        end
    elseif self.state==7 and t>59 then
        local localt=t-60;local period=diff(rt,{12,9,9,10,10})
        if localt%period<diff(rt,{4,5,5,5,6}) then
            local a=t*300-18000;if localt%600>299 then a=-0x4000-a end
            local count=diff(rt,{1,1,2,3,3})
            spread(16,8,self.ldX-25,self.ldY-85,a,10,diff(rt,{3,3.6,4,4,5}),1,count,count*9000,0)
        end
    end
end

local function updateBoss139(self,rt)
    initBoss139(self);applyOwnerDamage(self)
    local target=aimAt(self.ldX,self.ldY,self._beTargetX,self._beTargetY)
    if rt.frame%50==0 then
        refreshTarget(self,rt,301,210,101,self.state==3 and 220 or 150,(rt.stage-1)*0xde)
    end
    phaseBreak(self,rt,{[4]=2,[3]=4,[2]=6,[1]=8},{[4]=240,[3]=300})
    self._beDrawState,self._beDrawTimer=self.state,self.helperTimer
    local t=self.helperTimer
    if self.state==0 then
        if t<180 then self.ldY=900+trunc(sin(t*2*pi/720)*(self.originY-900))
        elseif t<191 then self.ldY=self.originY else self.ldY=self.ldY+0.1 end
        if t==210 then openPhase(self,60000,1800,180,0,1) end
    elseif self.state==1 then steer(self,target,0x200);emitBoss139(self,rt)
    elseif self.state==2 then
        if t<90 then self.ldY=self.ldY+t*0.01
        elseif t>=100 then
            if t==100 then self.ldY=self.ldY+160 end
            steer(self,target,0x200)
            if t<240 then self.ldY=self.ldY-(1-sin((t-100)*2*pi/560)) end
        end
        if t==180 then
            local p={{70,-50},{-70,-50},{140,-110},{-140,-110}}
            for i,o in ipairs(p) do spawnChild(rt,self,0x22,99999999,o[1],o[2],i-1,"S02 fixed mount") end
        end
        if t==240 then openPhase(self,75000,1800,220,1,3) end
    elseif self.state==3 then steer(self,target,0x200)
    elseif self.state==4 then
        if t<120 then self.ldY=self.ldY+t*0.02
        elseif t>=130 then if t==130 then self.ldY=self.ldY-160 end;steer(self,target,0x200) end
        if t==380 then openPhase(self,40000,1800,80,2,5) end
    elseif self.state==5 then
        steer(self,target,0x200)
        if t==10 then
            local count=diff(rt,{3,5,7,7,9})
            for i=0,count-1 do
                local c=spawnChild(rt,self,0x23,99999999,0,0,i,"S02 orbit child")
                if c then c._beOrbitRadius=140;c.secondaryAngle16=Core.angle16(floor(0x10000/count)*i-0x4000) end
            end
        end
        emitBoss139(self,rt)
    elseif self.state==6 then
        self.ldY=self.ldY+0.1;if t==180 then openPhase(self,50000,1800,80,3,7) end
    elseif self.state==7 then
        steer(self,target,0x200);emitBoss139(self,rt)
        if t==210 then
            for i=0,8 do
                local c=spawnChild(rt,self,0x24,99999999,0,0,i,"S02 final orbit child")
                if c then c._beOrbitRadius=120;c.secondaryAngle16=Core.angle16(i*0x1c71-0x4000) end
            end
        end
    elseif self.state==8 then
        if t==1 then setInvulnerability(360) end
        if t<240 then self.ldY=self.ldY+0.2 end
        if t==480 then finishBoss(self,rt) end
    end
    updateCountdown(self);setBossStatus(self,rt)
end

local function updateChild139(self,rt)
    local parent=self.parent
    if not parent or not parent.active then quietRemove(self);return end
    local t=self.helperTimer;self.targetable=false
    if self.spawnType==0x22 then
        self.ldX=parent.ldX+(self._beOffsetX or 0);self.ldY=parent.ldY+(self._beOffsetY or 0)
        if parent.state~=2 and parent.state~=3 then quietRemove(self);return end
        if self.state==0 and t==50 then self.state,self.helperTimer=1,0 end
        if self.state~=1 then return end
        local q=(self.helperTimer-20)%1200;local idx=self._beIndex or 0
        if self.helperTimer<20 then return end
        local count=diff(rt,{2,4,5,6,7});local spin=diff(rt,{150,180,200,200,200})
        if q==0 then self.secondaryAngle16=Core.angle16(floor(0x10000/(count*4))*idx) end
        self.secondaryAngle16=Core.angle16(self.secondaryAngle16+((idx==0 or idx==3) and 1 or -1)*spin)
        local sy=self.ldY-60
        local function aimedBurst(start)
            if q>=start and q<start+240 then
                local cadence=diff(rt,{120,80,60,48,48});local phase=(q-start)%cadence
                if phase==0 then self.targetAngle16=aim(self,self.ldX,sy) end
                if phase<24 and phase%3==0 then
                    local visual=idx<2 and 12 or 13;local speed=diff(rt,{5,6.6,8,9,11})
                    fire(visual,0,self.ldX,sy,self.targetAngle16,10,speed,1,0)
                    if rt.difficulty>=3 then
                        fire(visual,0,self.ldX,sy,self.targetAngle16-800,10,speed,1,0)
                        fire(visual,0,self.ldX,sy,self.targetAngle16+800,10,speed,1,0)
                    end
                end
            end
        end
        local function spinBurst(visual,phase,period,width)
            if period>0 and phase%period<width and (phase%period)%2==0 then
                local speed=diff(rt,{3.5,4.5,5.5,6,7.5})
                spread(visual,0,self.ldX,sy,self.secondaryAngle16,0,speed,1,count,0x10000,0)
                if rt.difficulty==4 then spread(visual,0,self.ldX,sy,self.secondaryAngle16,0,speed+0.8,1,count,0x10000,0) end
            end
        end
        if idx<2 then
            aimedBurst(60)
            if q>=330 and q<630 then spinBurst(12,q-330,diff(rt,{24,20,18,20,20})-2,diff(rt,{6,8,10,12,12})-2) end
        else
            if q<300 then spinBurst(13,q,diff(rt,{24,20,18,20,20}),diff(rt,{6,8,10,12,12})) end
            aimedBurst(390)
        end
        local rp=diff(rt,{90,60,40,40,36});local rs=650+rp*idx
        if q>=rs and q<=1149 and (q-rs)%(rp*4)==0 then
            local rc=diff(rt,{15,23,27,25,27});local a=aim(self,self.ldX,sy);local behavior=idx%2==0 and 0x18 or 0x19
            spread(3,behavior,self.ldX,sy,a,10,7,1,rc,0x10000,0)
            if rt.difficulty>=3 then spread(3,behavior,self.ldX,sy,a,10,8.2,1,rc,0x10000,0) end
        end
        return
    end
    local expected=self.spawnType==0x23 and 5 or 7
    if parent.state~=expected or parent._bePhaseMode~=1 then quietRemove(self);return end
    local radius=self._beOrbitRadius or 120
    if self.state==0 then
        local e=sin(t*pi/100);self.secondaryAngle16=Core.angle16(self.secondaryAngle16+trunc(e*3000)-3000)
        local dx,dy=Core.polar(self.secondaryAngle16,radius*e);self.ldX,self.ldY=parent.ldX+dx,parent.ldY+dy
        if t==50 then self.state,self.helperTimer=1,0 end
    end
    if self.state==1 then
        local delta=self.spawnType==0x23 and trunc(sin(self.helperTimer*2*pi/480)*777)
                    or trunc(sin(self.helperTimer*2*pi/240)*400)
        self.secondaryAngle16=Core.angle16(self.secondaryAngle16+delta)
        local dx,dy=Core.polar(self.secondaryAngle16,radius);self.ldX,self.ldY=parent.ldX+dx,parent.ldY+dy
        if self.spawnType==0x23 then
            local period=diff(rt,{9,5,5,5,4});local px,py=playerPosition()
            if self.helperTimer%480<420 and self.helperTimer%period==0 and
               distanceSquared(self.ldX,self.ldY,px,py)>=6400 then
                local a=self.secondaryAngle16-parent.helperTimer*180;local speed=diff(rt,{4,5,6,6.5,7.5})
                fire(1,0,self.ldX,self.ldY,a,10,speed,1,0)
                if rt.difficulty>=3 then fire(1,0,self.ldX,self.ldY,a,10,speed+0.6,1,0) end
            end
        elseif self.helperTimer>=30 then
            local period=diff(rt,{240,210,180,180,160});local q=(self.helperTimer-30)%period
            local liveAim=aim(self);if q==0 then self.targetAngle16=liveAim end
            if q<diff(rt,{16,25,32,32,32}) and q%3==0 then
                fire(11,0,self.ldX,self.ldY,self.targetAngle16,10,diff(rt,{4,5,6,6,7.7})+q*0.2,1,0)
            end
            self.targetAngle16=Core.turn16(self.targetAngle16,liveAim,0x30)
        end
    end
end

-- Stage 3 boss --------------------------------------------------------------

local function initBoss13a(self)
    if self._beInitialized then return end
    self._beInitialized=true;self._bePhaseMode=0;self._beBreaks=4
    self._beTargetX,self._beTargetY=360,200;self.state=0;self.helperTimer=0
    self.speed=0.5;self.angle16=0;self.radius=150;self.targetable=false;self.protect=true
    self.liveChildCount=0;self.intro=0
end

local function emitBoss13a(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==1 then
        local p=t%1000;if p>=80 and p<=399 then
            local localt=p-80;local block=floor(localt/80);local q=localt%80;local sy=self.ldY+140
            if q==0 then self.secondaryAngle16=aim(self,self.ldX,sy) end
            if q<diff(rt,{20,36,50,60,60}) and q%4==0 then
                local count=floor(q/4)+1
                spread(12,0,self.ldX,sy,self.secondaryAngle16,10,
                       diff(rt,{4,6,7.5,8,9})+block*0.5,1,count,
                       (count-1)*diff(rt,{300,400,500,500,600}),0)
            end
        end
    elseif self.state==3 then
        local p=t%1200;local cadence=diff(rt,{40,36,30,20,16});local sy=self.ldY+140
        if p>=30 and p<=279 then
            local q=p-30;if q%(cadence*3)==0 then self.secondaryAngle16=aim(self,self.ldX,sy) end
            if q%cadence==0 then
                local count=diff(rt,{5,7,9,9,9});local speed=diff(rt,{4,5.5,6.5,6,7})
                if d>0 then spread(1,0,self.ldX,sy,self.secondaryAngle16,0,speed-1.2,1,count-1,24000,0) end
                spread(5,0,self.ldX,sy,self.secondaryAngle16,0,speed,1,count,24000,0)
            end
        end
        if p>=320 and p<660 then
            local start=320
            for window=0,7 do
                local length=30+window*15
                if p>=start and p<start+length then
                    local q=p-start;if q==0 then self.targetAngle16=aim(self,self.ldX,sy) end
                    if q%5==0 then
                        local speed=3.5+q*diff(rt,{0.10,0.18,0.20,0.20,0.24});local count=diff(rt,{3,5,7,7,9})
                        spread(3,0,self.ldX,sy,self.targetAngle16,0,speed,1,count,27000,0)
                        if d>=3 then spread(3,0,self.ldX,sy,self.targetAngle16,0,speed+1.5,1,count,27000,0) end
                        self.targetAngle16=Core.turn16(self.targetAngle16,aim(self,self.ldX,sy),0x78)
                    end
                    break
                end
                start=start+diff(rt,{70,50,40,40,40})+window*15
            end
        end
    elseif self.state==5 and t>=10 then
        local period=diff(rt,{150,120,100,100,100});local cadence=diff(rt,{10,9,8,8,8})
        local phase=(t-10)%(period*2);local cached=aimAt(self.ldX,-3200,playerPosition())
        if phase<60 and phase%cadence==0 then
            local c=spawnChild(rt,self,0x32,500,0,0,t,"S03 left-right sweep")
            if c then c.ldX,c.ldY=self.ldX,self.ldY;c._beTargetX,c._beTargetY=phase*12,0;c.angle16=cached;c.speed=1 end
        elseif phase>=period and phase<period+60 then
            local q=phase-period
            if q%cadence==0 then
                local c=spawnChild(rt,self,0x33,500,0,0,t,"S03 right-left sweep")
                if c then c.ldX,c.ldY=self.ldX,self.ldY;c._beTargetX,c._beTargetY=720-q*12,0;c.angle16=cached;c.speed=1.5 end
            end
        end
    end
end

local function updateBoss13a(self,rt)
    initBoss13a(self);applyOwnerDamage(self)
    local target=aimAt(self.ldX,self.ldY,self._beTargetX,self._beTargetY)
    phaseBreak(self,rt,{[4]=2,[3]=4,[2]=6,[1]=8},{[4]=200,[3]=200})
    self._beDrawState,self._beDrawTimer=self.state,self.helperTimer
    if rt.frame%50==0 then refreshTarget(self,rt,301,210,101,150,(rt.stage-1)*0x14d) end
    if self.state==3 and rt.frame%25==0 then refreshTarget(self,rt,301,210,101,120,(rt.stage-1)*0x14d) end
    local t=self.helperTimer
    if self.state==0 then
        if t==0 then
            local parts={{0x30,10000,150,120,0},{0x30,10000,-150,120,1},{0x31,99999999,100,-100,0},{0x31,99999999,-100,-100,1}}
            for _,v in ipairs(parts) do spawnChild(rt,self,v[1],v[2],v[3],v[4],v[5],"S03 initial boss part") end
            self.liveChildCount=4
        end
        self.ldX=360
        if t<60 then self.ldY=-200+trunc(sin(t*pi/120)*600)
        elseif t==60 then self.ldY=400
        elseif t<180 then self.ldY=200+trunc(sin((t+60)*pi/240)*200)
        elseif t==180 then self.ldY=200;openPhase(self,70000,1800,150,0,1) end
    elseif self.state==1 then steer(self,target,0x200);emitBoss13a(self,rt)
    elseif self.state==2 then
        if t<90 then self.ldY=self.ldY+t*0.04 end
        if t==90 then self.speed=3 end
        if t>=90 then steer(self,target,0x309) end
        if t==200 then openPhase(self,66000,1800,150,1,3) end
    elseif self.state==3 then steer(self,target,0x309);emitBoss13a(self,rt)
    elseif self.state==4 then
        if t<120 then self.ldY=self.ldY+t*0.02 end
        if t==120 then self.speed=0.5 end
        if t>=130 then steer(self,target,0x200) end
        if t==380 then openPhase(self,40000,1800,80,2,5) end
    elseif self.state==5 then steer(self,target,0x200);emitBoss13a(self,rt)
    elseif self.state==6 then self.ldY=self.ldY+0.1;if t==180 then openPhase(self,50000,1800,80,3,7) end
    elseif self.state==7 then
        steer(self,target,0x200)
        if t==10 then
            local o={{250,-20},{-250,-20},{120,-70},{-120,-70}}
            for i,v in ipairs(o) do spawnChild(rt,self,0x34,9000,v[1],v[2],i-1,"S03 final satellite") end
            self.liveChildCount=4
        end
        if t>99 and self.liveChildCount==0 then self.helperTimer=0 end
    elseif self.state==8 then
        if t==1 then setInvulnerability(360) end
        if t<240 then self.ldY=self.ldY+0.2 end
        if t==480 then finishBoss(self,rt) end
    end
    updateCountdown(self);setBossStatus(self,rt)
end

local function updateChild13a(self,rt)
    local parent=self.parent
    if not parent or not parent.active then quietRemove(self);return end
    local t=self.helperTimer;local id=self.spawnType
    if id==0x30 then
        local tx=parent.ldX+self._beOffsetX;local ty=parent.ldY+self._beOffsetY
        if t==0 then self.ldX,self.ldY=tx,ty else self.ldX=self.ldX+(tx-self.ldX)/5;self.ldY=self.ldY+(ty-self.ldY)/5 end
        if self.state==0 and parent.state==1 then self.state,self.helperTimer=1,0;self.targetable=true end
        if self.state==1 then
            local q=(self.helperTimer-10)%diff(rt,{100,60,40,36,30})
            if self.helperTimer>9 and q<20 and q%4==0 then
                spread(3,0,self.ldX,self.ldY+65,0x4000,0,diff(rt,{5,6,7,8,9}),1,diff(rt,{1,1,1,2,2}),3000,0)
            end
            if self.hp<=0 then
                spawnEnemyDeathRewardBurstOnce(self,1800,48)
                killChild(self,parent,self.maxhp,true);return
            end
            if parent.state==2 then
                self.state,self.helperTimer=2,0
                self.targetable=false
            end
        end
        if parent.state>2 or (parent.state==2 and parent.helperTimer>=130) then quietRemove(self) end
        return
    elseif id==0x31 then
        self.targetable=false
        local oldX,oldY=self.ldX,self.ldY;local dx,dy=Core.polar(self.angle16,70);local mx,my=oldX+dx,oldY+dy
        self.ldX,self.ldY=parent.ldX+self._beOffsetX,parent.ldY+self._beOffsetY
        local aimed=aimAt(oldX,oldY,playerPosition());local turn=floor(abs(Core.angleDelta(self.angle16,aimed))/10)+0x30
        if self.state==0 and parent.state==1 then self.state,self.helperTimer=1,0
        elseif self.state==0 and parent.state==2 then self.state,self.helperTimer=2,0 end
        if self.state==1 then
            local q=self.helperTimer%1000
            if q<400 then
                self.angle16=Core.turn16(self.angle16,aimed,turn)
                local cadence=diff(rt,{100,50,40,40,30})
                if q>=30 and (q-30)%cadence==0 then
                    local count=diff(rt,{1,1,1,3,3});local speed=diff(rt,{4.5,5.5,6,6.5,7.5})
                    spread(7,0,mx,my,self.angle16,10,speed,1,count,2400,0)
                    spread(7,0,mx,my,self.angle16,10,speed+0.3,1,count,2400,0)
                end
            elseif q<700 then
                if q<=430 then self.angle16=Core.turn16(self.angle16,self._beOffsetX<=0 and 0x6000 or 0xe000,0x44c)
                elseif q<570 then self.angle16=Core.angle16(self.angle16+diff(rt,{700,750,800,800,800}))
                else self.angle16=Core.angle16(self.angle16-diff(rt,{700,750,800,800,800})) end
                local divisor=diff(rt,{4,3,2,2,2})
                if q>=430 and (q-430)%divisor==0 then
                    local count=diff(rt,{1,2,3,3,4});local speed=diff(rt,{2,3,4,3,3.5});local width=(count-1)*8888
                    spread(13,1,mx,my,self.angle16,10,speed,1,count,width,0)
                    if rt.difficulty>=3 then spread(13,1,mx,my,self.angle16,10,speed+1.5,1,count,width,0) end
                end
            else
                if q<=730 then self.angle16=Core.turn16(self.angle16,aimed,0x44c) end
                local sequence=q-730;local cadence=diff(rt,{80,45,40,40,40});local block=floor(sequence/cadence);local phase=sequence%cadence
                if sequence>=0 and sequence<270 then
                    if phase==0 then self.targetAngle16=aimed end
                    if phase<40 and phase%4==0 then
                        local speed=diff(rt,{4,6,7,7,8})+block*0.5+phase*0.1;local count=diff(rt,{3,5,7,7,9})
                        spread(6,0,mx,my,self.targetAngle16,10,speed,1,count,22000,0)
                        if rt.difficulty>=3 then spread(6,0,mx,my,self.targetAngle16,10,speed+1.6,1,count,22000,0) end
                    end
                    local delta=30+block*diff(rt,{4,6,8,8,1});if sequence%(cadence*2)>=cadence then delta=-delta end
                    self.targetAngle16=Core.angle16(self.targetAngle16+delta)
                end
            end
            if parent.state==2 then self.state,self.helperTimer=2,0 end
        elseif self.state==2 and parent.state==3 then self.state,self.helperTimer=3,0
        elseif self.state==3 then
            local p=self.helperTimer%1200;local interval=diff(rt,{140,100,90,90,70})
            local start=self._beOffsetX>=0 and 690 or 690+interval
            if p>=start and p<1120 and (p-start)%(interval*2)==0 then
                spread(self._beOffsetX>=0 and 3 or 2,self._beOffsetX>=0 and 26 or 27,
                       mx,my,aimed,10,diff(rt,{7.7,8.5,9,9,9}),1,diff(rt,{3,5,7,7,7}),20000,0)
            end
            self.angle16=Core.turn16(self.angle16,aimed,turn)
            if parent.hp<=0 or parent.countdown<=0 or parent._bePhaseMode~=1 then
                quietRemove(self)
            end
        end
        if parent.state>4 then quietRemove(self) end
        return
    elseif id==0x32 or id==0x33 then
        if self.state==0 then
            if t==0 then self._beStartX,self._beStartY=parent.ldX,parent.ldY end
            local e=sin(t*pi/80);self.ldX=self._beStartX+e*(self._beTargetX-self._beStartX);self.ldY=self._beStartY+e*(self._beTargetY-self._beStartY)
            if t==40 then self._beAnchorX,self._beAnchorY=self._beTargetX,self._beTargetY;self.state,self.helperTimer=1,0;self.targetable=true end
        end
        if self.state==1 then
            local shotX,shotY=self.ldX,self.ldY;local dx,dy=Core.polar(self.angle16,self.speed)
            self._beAnchorX,self._beAnchorY=self._beAnchorX+dx,self._beAnchorY+dy;self.speed=self.speed+0.04
            local wobble=sin(self.helperTimer*pi/75)*30;self.ldX=self._beAnchorX+(id==0x32 and wobble or -wobble);self.ldY=self._beAnchorY
            if parent.helperTimer>=60 then
                local cycle=diff(rt,{80,60,50,50,50});local q=(parent.helperTimer-60)%cycle
                if q==0 then self.targetAngle16=aimAt(parent.ldX,-200,playerPosition()) end
                local px,py=playerPosition()
                if q<diff(rt,{24,32,36,36,40}) and q%4==0 and self.ldY<700 and distanceSquared(self.ldX,self.ldY,px,py)>900 then
                    local speed=diff(rt,{5.5,6.5,7,6,7.5})
                    fire(7,0,shotX,shotY,self.targetAngle16,10,speed,1,0);fire(7,0,shotX,shotY,self.targetAngle16+0x8000,10,speed,1,0)
                    if rt.difficulty>=3 then fire(7,0,shotX,shotY,self.targetAngle16,10,speed+2,1,0);fire(7,0,shotX,shotY,self.targetAngle16+0x8000,10,speed+2,1,0) end
                end
            end
        end
        if self.hp<=0 then
            spawnEnemyDeathRewardBurstOnce(self,500,4)
            local px,py=playerPosition()
            if self.ldY<520 and distanceSquared(self.ldX,self.ldY,px,py)>6400 then
                local a=aim(self);fire(2,3,self.ldX,self.ldY,a,0,diff(rt,{5,6,6.5,6.5,7.5}),1,0)
                if rt.difficulty>=3 then fire(2,3,self.ldX,self.ldY,a,0,rt.difficulty==3 and 8 or 9,1,0) end
            end
            killChild(self,parent,self.maxhp,false);return
        end
        if parent._bePhaseMode~=1 or parent.state~=5 then quietRemove(self) end
        return
    else
        local ox,oy=self._beOffsetX,self._beOffsetY;local goalX=parent.ldX+(self._beMountX or 0);local goalY=parent.ldY+(self._beMountY or 0)
        if self.state==0 then
            if t==0 then self.ldX,self.ldY=parent.ldX,parent.ldY end
            local e=sin(t*pi/80);self._beMountX,self._beMountY=e*ox,e*oy
            goalX,goalY=parent.ldX+self._beMountX,parent.ldY+self._beMountY
            self.ldX=self.ldX+(goalX-self.ldX)/10;self.ldY=self.ldY+(goalY-self.ldY)/10
            if t==40 then self.state,self.helperTimer=1,0;self.targetable=true end
        else
            self.ldX=self.ldX+(goalX-self.ldX)/10;self.ldY=self.ldY+(goalY-self.ldY)/10
        end
        if self.state==1 and parent.helperTimer>=80 then
            local p=(parent.helperTimer-80)%380;local idx=self._beIndex or 0
            if p<=200 then
                local start=idx*50;local ending=diff(rt,{6,9,12,12,12})+idx*56
                if p==start then self.targetAngle16=aim(self) end
                if p<200 and p>=start and p<ending and (p-start)%3==0 and Core.inside(self.ldX,self.ldY,0) then
                    local count=diff(rt,{15,23,27,27,25});local speed=diff(rt,{4.5,6.4,7.5,8,9})+idx*0.6
                    spread(4,0,self.ldX,self.ldY,self.targetAngle16,0,speed,1,count,0x10000,0)
                    if rt.difficulty>=3 then spread(4,0,self.ldX,self.ldY,self.targetAngle16,0,speed+1.2,1,count,0x10000,0) end
                end
                self.targetAngle16=Core.angle16(self.targetAngle16+(idx%2==0 and 1 or -1)*(diff(rt,{50,70,80,80,120})+idx*10))
            end
            if p>=200 then
                local spacing=diff(rt,{32,18,16,16,10});local start=200+idx*spacing
                if p>=start and p<330 and (p-start)%(spacing*5)==0 and Core.inside(self.ldX,self.ldY,0) then
                    local count=diff(rt,{23,31,35,35,35})+idx*2;local speed=diff(rt,{3.6,5,5.5,5.5,6.5})+idx*0.3
                    spread(3,0,self.ldX,self.ldY,Core.randomAngle(p,0),0,speed,1,count,0x10000,0)
                    if rt.difficulty>=3 then spread(3,0,self.ldX,self.ldY,Core.randomAngle(p,0x457),0,speed+1,1,count,0x10000,0) end
                end
            end
        end
        if self.hp<=0 then
            spawnEnemyDeathRewardBurstOnce(self,1800,24)
            killChild(self,parent,max(1,floor(self.maxhp/2)),true);return
        end
        if parent._bePhaseMode~=1 or parent.state~=7 then quietRemove(self) end
    end
end

-- Stage 4 boss --------------------------------------------------------------

local function initBoss13b(self)
    if self._beInitialized then return end
    self._beInitialized=true;self._bePhaseMode=0;self._beBreaks=4
    self._beTargetX,self._beTargetY=360,120;self.state=0;self.helperTimer=0
    self.speed=0.3;self.angle16=0;self.radius=200;self.targetable=false;self.protect=true
    self.liveChildCount=0;self.intro=0
end

local function emitBoss13b(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==1 and t>=64 then
        local interval=diff(rt,{200,160,160,160,120})
        if (t-64)%interval==0 then
            local maximum=diff(rt,{11,17,20,20,20});local base=diff(rt,{4,5,5.5,6,7.2});local a=aim(self)
            for i=0,maximum do
                local width=i*floor(0x10000/maximum);local speed=base-i*(base-1)/maximum
                spread(10,0,self.ldX,self.ldY,a,10,speed,1,2,width,0)
                if d>=3 and i<maximum then
                    local speed2=base-1-i*(base-2.4)/maximum
                    spread(10,0,self.ldX,self.ldY,a,10,speed2,1,2,width+1500,0)
                end
            end
        end
    elseif self.state==7 and t>=60 then
        local p=(t-60)%1200
        for _,start in ipairs({300,460,620}) do
            if p>=start and p<start+80 then
                local interval=diff(rt,{28,24,20,20,16});local q=p-start
                local count=diff(rt,{4,7,7,7,7});local width=0x8000
                if q%(interval*2)==interval then count=count-1;width=floor(0x8000/count)*(count-1)
                elseif q%(interval*2)~=0 then break end
                local a=aim(self,self.ldX,self.ldY-60);local speed=diff(rt,{4.5,6,6.5,7,8.5})
                spread(4,0,self.ldX,self.ldY-60,a,0,speed,1,count,width,0)
                for j=1,diff(rt,{2,2,3,4,4}) do
                    spread(4,0,self.ldX,self.ldY-60,a-j*400,0,speed,1,count,width,0)
                    spread(4,0,self.ldX,self.ldY-60,a+j*400,0,speed,1,count,width,0)
                end
                break
            end
        end
    elseif self.state==10 then
        local x,y=self.ldX,self.ldY-60;local a=aim(self,x,y)
        if t<180 or (t>=360 and t<660) then
            local interval=diff(rt,{44,27,23,18,16});local speed=diff(rt,{4.5,6,5.5,6,7.2})
            if t%(interval*3)==0 then
                local count=diff(rt,{4,7,7,7,9});spread(4,0,x,y,a,0,speed,1,count,0x8000,0)
                for j=1,diff(rt,{2,2,3,3,3}) do spread(4,0,x,y,a-j*400,0,speed,1,count,0x8000,0);spread(4,0,x,y,a+j*400,0,speed,1,count,0x8000,0) end
            end
            if t>=interval and (t-interval)%(interval*3)==0 then spread(0,0,x,y,a,0,speed,1,diff(rt,{9,15,19,21,23}),0x8000,0) end
            if t>=interval*2 and (t-interval*2)%(interval*3)==0 then
                local count=diff(rt,{9,15,19,21,23})-1;spread(0,0,x,y,a,0,speed,1,count,floor(0x8000/count)*(count-1),0)
            end
        end
        if t>=200 and t<350 then
            local cycle=diff(rt,{50,40,30,30,38});local q=(t-200)%cycle
            if q==0 then self.secondaryAngle16=a end
            if q<diff(rt,{20,28,27,30,36}) and q%3==0 then
                local count=floor(q/3)+1;local speed=diff(rt,{4,5.5,6,6,7.5})+q*diff(rt,{0.08,0.12,0.14,0.14,0.16})
                local width=count*600-600;spread(12,0,x,y,self.secondaryAngle16,0,speed,1,count,width,0)
                if d>=3 then spread(12,0,x,y,self.secondaryAngle16-9000,0,speed,1,count,width,0);spread(12,0,x,y,self.secondaryAngle16+9000,0,speed,1,count,width,0) end
            end
        end
        if t>=670 and (t-670)%3==0 then
            for i=0,2 do
                local base=diff(rt,{10000,8000,7500,7500,7000})+i*5000;local width,center=base,a
                if t<800 then width=base*5-trunc(sin((t-670)*pi/260)*base*4)
                else center=a+trunc(sin((t-800)*pi/64)*1200) end
                spread(8,0,x,y,center,10,12,1,2,width,0)
            end
        end
    end
end

local function updateBoss13b(self,rt)
    initBoss13b(self);applyOwnerDamage(self)
    local target=aimAt(self.ldX,self.ldY,self._beTargetX,self._beTargetY)
    phaseBreak(self,rt,{[4]=2,[3]=6,[2]=8,[1]=11},{[4]=240})
    self._beDrawState,self._beDrawTimer=self.state,self.helperTimer
    if rt.frame%50==0 then
        if self.state==1 then refreshTarget(self,rt,201,260,121,60,(rt.stage-1)*444)
        else refreshTarget(self,rt,301,210,101,150,(rt.stage-1)*444) end
    end
    local t=self.helperTimer
    if self.state==0 then
        self.ldX=360;if t<=240 then self.ldY=620-trunc(sin(t*pi/480)*500) end
        if t==180 then
            local o={{60,260},{-60,260},{150,230},{-150,230},{230,170},{-230,170}}
            for i,v in ipairs(o) do spawnChild(rt,self,0x40,12000,v[1],v[2],i-1,"S04 appendage") end
        end
        if t==240 then openPhase(self,195000,4500,200,0,1) end
    elseif self.state==1 then steer(self,target,0x200);emitBoss13b(self,rt);if t==3420 then self.helperTimer=0 end
    elseif self.state==2 then
        if t<120 then self.ldY=self.ldY+t*0.02 end;if t>=130 then steer(self,target,0x200) end
		if t==120 then playStageSound("ld_se_Blast2",0.5) end
		if t==260 or t==284 then playStageSound("ld_se_BossApproach",0.5) end
        if t==380 then openPhase(self,45000,1800,80,1,3) end
    elseif self.state==3 then
        steer(self,target,0x200)
        if t==10 then
            local count=diff(rt,{7,9,11,11,13})
            for i=0,count-1 do
                local c=spawnChild(rt,self,0x41,99999999,0,0,i,"S04 ellipse satellite")
                if c then c._beVerticalRadius=100;c._beHorizontalRadius=200;c.secondaryAngle16=Core.angle16(floor(0x10000/count)*i-0x4000) end
            end
        end
        if t==150 then self.state,self.helperTimer=4,0 end
    elseif self.state==4 or self.state==9 then
        local duration=self.state==4 and 60 or 40
        if t==1 then
            self._beMoveFromX,self._beMoveFromY=self.ldX,self.ldY
            if self.state==4 then
                local r=Core.frameRand(rt.frame);local distance=r%41+80
                local tx=(r%2==0) and self.ldX+distance or self.ldX-distance
                if tx>520 then tx=self.ldX-distance elseif tx<200 then tx=self.ldX+distance end
                self._beMoveToX,self._beMoveToY=tx,Core.randomCoord(rt.frame+444,101,150)
            else self._beMoveToX,self._beMoveToY=440,150 end
        end
        local e=sin(t*pi/(duration*2));self.ldX=self._beMoveFromX+e*(self._beMoveToX-self._beMoveFromX);self.ldY=self._beMoveFromY+e*(self._beMoveToY-self._beMoveFromY)
        if t==duration then self.ldX,self.ldY=self._beMoveToX,self._beMoveToY;self.state,self.helperTimer=self.state+1,0 end
    elseif self.state==5 then steer(self,target,0x200);if t==90 then self.state,self.helperTimer=4,0 end
    elseif self.state==6 then self.ldY=self.ldY+0.1;if t==180 then openPhase(self,58000,1800,self.radius,2,7) end
    elseif self.state==7 then
        steer(self,target,0x200)
        if t==10 then
            for i=0,2 do
                local c=spawnChild(rt,self,0x42,self.maxhp,0,0,i,"S04 shared HP orbit")
                if c then c._beOrbitRadius=180;c.secondaryAngle16=Core.angle16(i*0x5555-0x4000) end
            end
        end
        emitBoss13b(self,rt)
    elseif self.state==8 then self.ldY=self.ldY+0.1;if t==180 then openPhase(self,70000,2100,self.radius,3,9) end
    elseif self.state==10 then
        local amplitude=t<777 and 80+120*sin(t*pi/1554) or 200
        self.ldX=360+amplitude*sin((t+91)*pi/182);self.ldY=200-50*sin((t+120)*pi/240)
        if t==300 then
            for i=0,2 do
                local c=spawnChild(rt,self,0x43,self.maxhp,0,0,i,"S04 final shared HP orbit")
                if c then c._beOrbitRadius=130;c.secondaryAngle16=Core.angle16(i*0x5555-0x4000) end
            end
        end
        emitBoss13b(self,rt)
    elseif self.state==11 then
        if t==1 then setInvulnerability(360) end
        if t<240 then self.ldY=self.ldY+0.2 end
        if t==480 then finishBoss(self,rt) end
    end
    updateCountdown(self);setBossStatus(self,rt)
end

local function updateChild40(self,rt,parent)
    local t,pt,idx=self.helperTimer,parent.helperTimer,self._beIndex or 0
    local mx,my=parent.ldX+self._beOffsetX,parent.ldY+self._beOffsetY
    local function easeMount() self.ldX=self.ldX+(mx-self.ldX)/20;self.ldY=self.ldY+(my-self.ldY)/20 end
    local function followMount()
        local a=aimAt(self.ldX,self.ldY,mx,my);self.secondaryAngle16=Core.turn16(self.secondaryAngle16,a,0x457);move(self,self.secondaryAngle16,self.speed)
    end
    if self.state==0 then
        if t==0 then self.ldX,self.ldY=mx,my end
        if t==60 then self.secondaryAngle16=(idx==0 or idx==3 or idx==4) and 1000 or 0x7c18;self.state,self.helperTimer=1,0;self.speed=1;self.targetable=true;parent.liveChildCount=(parent.liveChildCount or 0)+1 end
    end
    if self.state==1 then
        followMount()
        if self.helperTimer>29 then
            if pt<600 then self.state,self.helperTimer=2,0 elseif pt<940 then self.state,self.helperTimer=3,0
            elseif pt>=1950 and pt<2550 then self.state,self.helperTimer=6,0 end
        end
        if pt==960+idx*150 then self.state,self.helperTimer=4,0 end
        if pt==2600 or pt==2870 or pt==3140 then self.state,self.helperTimer=7,0 end
    end
    if self.state==2 then
        followMount()
        if pt<580 then
            local wave={2222,-2222,-2222,2222,2222,-2222};local a=aimAt(parent.ldX,self.ldY,playerPosition())+trunc(sin((pt-32)*pi/72)*wave[idx+1])
            self.angle16=Core.turn16(self.angle16,a,floor(abs(Core.angleDelta(self.angle16,a))/10)+0x30)
            local start=32+floor(idx/2)*diff(rt,{12,12,10,8,7})
            if pt>=start and (pt-start)%diff(rt,{79,79,61,48,39})==0 then
                local speed=diff(rt,{2.5,3.5,3.8,4.5,5.5});fire(13,0,self.ldX,self.ldY,a,0,speed,1,0)
                if rt.difficulty>0 then fire(13,0,self.ldX,self.ldY,a-4444,0,speed-0.3,1,0);fire(13,0,self.ldX,self.ldY,a+4444,0,speed-0.3,1,0) end
            end
        end
        if pt==600 then self.state,self.helperTimer=3,0 end
    elseif self.state==3 then
        easeMount();self.angle16=Core.turn16(self.angle16,0x4000,floor(abs(Core.angleDelta(self.angle16,0x4000))/10)+0x30)
        if pt>=660 and pt<920 then
            local period=diff(rt,{65,44,38,44,38});local q=(pt-660)%period;local offs={0,0,-1000,1000,-2000,2000}
            if q==0 then self.targetAngle16=aim(self)+offs[idx+1]+trunc(sin((pt-(660-floor(period/2)))*pi/period)*((pt-660)*16)) end
            if q<=20 and q%4==0 then
                local speed=diff(rt,{4.2,5.5,6,6,8})+q*0.1;fire(9,0,self.ldX,self.ldY,self.targetAngle16,0,speed,1,0)
                if rt.difficulty>=3 then fire(9,0,self.ldX,self.ldY,self.targetAngle16-3888,0,speed-0.6,1,0);fire(9,0,self.ldX,self.ldY,self.targetAngle16+3889,0,speed-0.6,1,0) end
            end
        end
        if pt==940 then self.state,self.helperTimer=1,0 end
    elseif self.state==4 or self.state==7 then
        local dashState=self.state
        if t<50 then local a=aim(self);self.angle16=Core.turn16(self.angle16,a,floor(abs(Core.angleDelta(self.angle16,a))/10)+0x30) end
        if t==90 then self.speed=10 end
        if t>=90 then
            move(self,self.angle16,self.speed);self.speed=self.speed+0.2
            if Core.inside(self.ldX,self.ldY,0) then
                local dx,dy=Core.polar(self.angle16,60);local reverse=self.angle16+0x8000
                fire(3,1,self.ldX+dx,self.ldY+dy,reverse+randomSigned(rt.frame+444,1200),0,10,1,0)
                fire(5,1,self.ldX+dx,self.ldY+dy,reverse+randomSigned(rt.frame,1500),0,9,1,0)
                if dashState==4 and (t-90)%diff(rt,{4,1,1,1,1})==0 then
                    local a=self.angle16+(idx%2==0 and -1 or 1)*diff(rt,{2000,3800,3600,3600,3200})*t
                    local count=diff(rt,{1,1,2,2,3});local speed=diff(rt,{2,2.8,3.2,3.6,5})
                    spread(12,3,self.ldX+dx,self.ldY+dy,a,0,speed,1,count,0x10000,0)
                    if rt.difficulty>=3 then spread(12,3,self.ldX+dx,self.ldY+dy,a,0,speed-0.6,1,count,0x10000,0) end
                end
            end
        end
        if t>=100 and (self.ldX<40 or self.ldX>680 or self.ldY<40 or self.ldY>680) then self.state,self.helperTimer=dashState+1,0 end
    elseif self.state==5 or self.state==8 then
        local returnState=self.state;if t>=90 then easeMount();self.angle16=Core.turn16(self.angle16,0x4000,floor(abs(Core.angleDelta(self.angle16,0x4000))/10)+0x30) end
        if returnState==8 then
            local start=idx*12+8
            if t>=start and t<start+diff(rt,{14,18,20,20,23}) and (t-start)%3==0 then
                local ax={50,-50,100,-100,140,-140};local ay={150,150,140,140,120,120};local x,y=parent.ldX+ax[idx+1],parent.ldY+ay[idx+1]
                local a=aimAt(x,y,self.ldX,self.ldY)+0x8000
                for segment=0,19 do if segment%diff(rt,{7,4,3,2,2})==0 then
                    local f=segment/20;local sx=x+(self.ldX-x)*f+4*sin((rt.frame-segment*7)*2*pi/80);local sy=y+(self.ldY-y)*f
                    spread(4,0,sx,sy,a,0,diff(rt,{3.5,4.5,5,5.5,7.5})+(t-start)*0.1,1,2,0x4000+segment*0x666,0)
                end end
            end
        end
        if t==120 or pt==2868 or pt==3138 then self.state,self.helperTimer=1,0;self.speed=1 end
    elseif self.state==6 then
        easeMount();local starts={14,21,7,27,0,35};local offsets={0,0,-2000,2000,-4000,4000}
        local heading=0x4000+offsets[idx+1]+trunc(sin((pt-starts[idx+1])*2*pi/155)*2400)
        local px,py=playerPosition();if self.ldY>=py then heading=heading+0x8000 end
        local start=2000+floor(idx/2)*8
        if pt>=start then
            local rem=pt-start;local period=diff(rt,{72,44,32,32,28});local q=rem%period
            if q<diff(rt,{12,16,16,16,20}) and rem%4==0 then
                local speed=diff(rt,{3,3.8,4.5,4.5,5.5})+(pt-2000)*0.005
                spread(13,0,self.ldX,self.ldY,heading,0,speed,1,diff(rt,{1,1,1,2,2}),0x0d05,0)
                fire(13,0,self.ldX,self.ldY,heading+0x8000-0x2aaa,0,speed,1,0);fire(13,0,self.ldX,self.ldY,heading+0x8000+0x2aab,0,speed,1,0)
            end
        end
        if pt==2550 then self.state,self.helperTimer=1,0 end
    elseif self.state==-1 then
        if parent.state~=1 and t>=80 then quietRemove(self);return end
        if t==200 then
            self.hp=self.maxhp;self.ldX,self.ldY=mx,my;self.state,self.helperTimer=0,0
            self.targetable=false;self._beDeathHandled=false
            self._beDeathRewardBurst=false;self._ldRewardSpawned=false
        end
    end
    if self.hp<=0 and self.state>=1 then
        spawnEnemyDeathRewardBurstOnce(self,2000,15)
        queueOwnerDamage(parent,self.maxhp);parent.liveChildCount=max(0,(parent.liveChildCount or 0)-1)
        self.hp=1;self.targetable=false;self.state,self.helperTimer=-1,0;self._beDeathHandled=true
    elseif self.state>=1 and not (parent.hp>0 and parent.countdown>0 and parent.state<2) then
        self.hp=1;self.targetable=false;self.state,self.helperTimer=-1,0
    end
end

local function updateChild41(self,rt,parent)
    local t=self.helperTimer;local entryState=self.state;local scale=1
    if self.state==0 then scale=sin(t*pi/100);if t==50 then self.state,self.helperTimer=1,0;scale=1 end end
    if self.state==1 then
        local live=self.helperTimer;local maximum=rt.difficulty==0 and 333 or 555;local step=0
        if live<600 then step=trunc(sin(live*pi/1200)*maximum)
        elseif live<1200 then step=maximum
        elseif live<1800 then step=trunc(sin((live-600)*pi/1200)*maximum) end
        self.secondaryAngle16=Core.angle16(self.secondaryAngle16+step)
        local interval=diff(rt,{8,5,3,4,3})
        for wave=0,24 do
            local start=10+24*wave+interval*wave*(wave-1)/2
            if live>=start and live<=start+wave*interval and (live-start)%interval==0 then
                local speed=diff(rt,{4.8,6,7,7,9});fire(3,0,self.ldX,self.ldY+15,self.secondaryAngle16,0,speed,1,0)
                if rt.difficulty>=3 then fire(9,0,self.ldX,self.ldY+15,self.secondaryAngle16,0,speed-2.4,1,0) end
            end
        end
    end
    local vertical=(self._beVerticalRadius or 100)*scale;local horizontal=(self._beHorizontalRadius or 200)*scale;local tilt=0
    if entryState==0 then vertical,horizontal=trunc(vertical),trunc(horizontal)
    else vertical=(self._beVerticalRadius or 100)*sin((t+80)*pi/160);horizontal=self._beHorizontalRadius or 200;tilt=trunc(sin(t*pi/115)*2222) end
    local dx,dy=Core.ellipse(self.secondaryAngle16,horizontal,vertical,tilt);self.ldX,self.ldY=parent.ldX+dx,parent.ldY+dy
    self.layer=exactToLuaLayer(primaryVisualLayer(self))
    if parent._bePhaseMode~=1 or (parent.state~=3 and parent.state~=4 and parent.state~=5) then quietRemove(self) end
end

local function updateChild42Or43(self,rt,parent)
    local t=self.helperTimer;local cx,cy=parent.ldX,parent.ldY-60
    if self.state==0 then
        local e=sin(t*pi/100);local dx,dy=Core.polar(self.secondaryAngle16,(self._beOrbitRadius or 180)*e);self.ldX,self.ldY=cx+dx,cy+dy
        if t==50 then self.maxhp=parent.maxhp;self.hp=parent.hp;self.state,self.helperTimer=1,0;self.targetable=true end
    end
    if self.state~=1 then return end
    local oldX,oldY=self.ldX,self.ldY;local mdx,mdy=Core.polar(self.angle16,50);local mx,my=oldX+mdx,oldY+mdy
    if self.spawnType==0x42 then
        local cycle=self.helperTimer%1200;self.secondaryAngle16=Core.angle16(self.secondaryAngle16+trunc(sin(self.helperTimer*pi/1200)*550))
        local radius=180+sin(cycle*pi/1200)*diff(rt,{-120,-80,-60,-60,-40});local dx,dy=Core.polar(self.secondaryAngle16,radius);self.ldX,self.ldY=cx+dx,cy+dy
        local aimed=aimAt(cx,cy,playerPosition());self.angle16=Core.turn16(self.angle16,aimed,floor(abs(Core.angleDelta(self.angle16,aimed))/10)+0x30)
        if cycle<280 then
            local period=diff(rt,{90,44,33,50,44});local q=cycle%period;if q==0 then self.targetAngle16=self.angle16 end
            if q<diff(rt,{18,21,24,24,24}) and q%3==0 then
                local speed=diff(rt,{4,5,6,6.5,7.5})+q*0.1;fire(13,0,mx,my,self.targetAngle16,10,speed,1,0)
                if rt.difficulty>=3 then fire(13,0,mx,my,self.targetAngle16-0x0d05,10,speed-0.8,1,0);fire(13,0,mx,my,self.targetAngle16+0x0d05,10,speed-0.8,1,0) end
            end
        end
        for _,anchor in ipairs({410,570,730,800}) do
            if cycle==anchor then self.targetAngle16=self.angle16 end
            if cycle>=anchor and cycle<anchor+60 and (cycle-anchor)%4==0 then
                local speed=diff(rt,{3.5,4.5,5,5,6})+(cycle-anchor)*diff(rt,{0.10,0.15,0.20,0.20,0.24})
                fire(2,0,mx,my,self.targetAngle16,10,speed,1,0)
                if rt.difficulty>=3 then fire(2,0,mx,my,self.targetAngle16-0x34bc,10,speed,1,0);fire(2,0,mx,my,self.targetAngle16+0x34bc,10,speed,1,0) end
            end
        end
        if cycle>=880 and cycle<1150 and (cycle-880)%diff(rt,{48,30,18,14,12})==0 then
            local speed=diff(rt,{4,5,5.5,6.5,7.7});fire(13,0,mx,my,self.angle16,10,speed,1,0)
            if rt.difficulty>0 then fire(13,0,mx,my,self.angle16-0x0f30,10,speed,1,0);fire(13,0,mx,my,self.angle16+0x0f31,10,speed,1,0) end
        end
    else
        local live=self.helperTimer;local step=0
        if live<600 then step=trunc(sin(live*pi/1200)*240) elseif live<1200 then step=240 elseif live<1800 then step=240-trunc(sin((live-1200)*pi/1200)*240) end
        self.secondaryAngle16=Core.angle16(self.secondaryAngle16+step);local dx,dy=Core.polar(self.secondaryAngle16,130);self.ldX,self.ldY=cx+dx,cy+dy
        local aimed=aimAt(oldX,oldY,playerPosition());self.angle16=Core.turn16(self.angle16,aimed,floor(abs(Core.angleDelta(self.angle16,aimed))/10)+0x30)
        local period=diff(rt,{75,40,36,32,26});local start=20+(self._beIndex or 0)*period
        if live>=start then
            local q=(live-start)%(period*3);if q==0 then self.targetAngle16=self.angle16 end
            if q<24 and q%3==0 then
                local speed=diff(rt,{5.5,6.5,7,7.5,9.5})+((live-start)%period)*0.07;fire(13,0,mx,my,self.targetAngle16,10,speed,1,0)
                if rt.difficulty>=3 then fire(13,0,mx,my,self.targetAngle16-750,10,speed-0.5,1,0);fire(13,0,mx,my,self.targetAngle16+750,10,speed-0.5,1,0) end
            end
            self.targetAngle16=Core.turn16(self.targetAngle16,aimed,0x30)
        end
    end
    if self.hp<parent.hp then parent.hp=self.hp elseif parent.hp<self.hp then self.hp=parent.hp end
    if self.hp<=0 then parent.hp=0 end
    local expected=self.spawnType==0x42 and 7 or 10
    if parent._bePhaseMode~=1 or parent.state~=expected then quietRemove(self) end
end

local function updateChild13b(self,rt)
    local parent=self.parent
    if not parent or not parent.active then quietRemove(self);return end
    if self.spawnType==0x40 then updateChild40(self,rt,parent)
    elseif self.spawnType==0x41 then updateChild41(self,rt,parent)
    else updateChild42Or43(self,rt,parent) end
end

local handlers = {
    [0x10]=updateSetpiece10,[0x11]=updateSetpiece11,
    [0x20]=updateSetpiece20,[0x21]=updateSetpiece21,
    [0x2e]=updateSetpiece2e,[0x2f]=updateSetpiece2f,
    [0x3f]=updateSetpiece3f,
    [0x138]=updateBoss138,[0x139]=updateBoss139,
    [0x13a]=updateBoss13a,[0x13b]=updateBoss13b,
}

local EarlyBossController = {}
EarlyBossController.__index = EarlyBossController

function EarlyBossController.new(rootHandlers)
    return setmetatable({rootHandlers=rootHandlers},EarlyBossController)
end

function EarlyBossController:_captureVisualState(entity,rt)
    setAppearance(entity)
    entity._beDrawState,entity._beDrawTimer=entity.state,entity.helperTimer
    entity._beSourceFrame=rt.frame
end

function EarlyBossController:_isClaimedChild(entity,id)
    return (id>=0x12 and id<=0x14 and entity.parent) or
        (id>=0x15 and id<=0x17 and entity.parent and entity.parentSpawnType==0x138) or
        (id>=0x22 and id<=0x24 and entity.parent and entity.parentSpawnType==0x139) or
        (id>=0x30 and id<=0x34 and entity.parent and entity.parentSpawnType==0x13a) or
        (id>=0x40 and id<=0x43 and entity.parent and entity.parentSpawnType==0x13b)
end

function EarlyBossController:_updateChild(entity,rt,id)
    if id>=0x12 and id<=0x14 and entity.parent then updateDecoration138(entity,rt);return true end
    if id>=0x15 and id<=0x17 and entity.parent and entity.parentSpawnType==0x138 then updateChild138(entity,rt);return true end
    if id>=0x22 and id<=0x24 and entity.parent and entity.parentSpawnType==0x139 then updateChild139(entity,rt);return true end
    if id>=0x30 and id<=0x34 and entity.parent and entity.parentSpawnType==0x13a then updateChild13a(entity,rt);return true end
    if id>=0x40 and id<=0x43 and entity.parent and entity.parentSpawnType==0x13b then updateChild13b(entity,rt);return true end
    return false
end

function EarlyBossController:update(entity,rt)
	local handler=self.rootHandlers[entity.spawnType]
	if handler then
        self:_captureVisualState(entity,rt)
        handler(entity,rt);entity.seen=false;return true
    end
    local id=entity.spawnType
    if childRadii[id] and not entity._beRadiusSet then
        entity.radius=childRadii[id];entity._beRadiusSet=true
    end
    if self:_isClaimedChild(entity,id) then
        self:_captureVisualState(entity,rt)
        entity.seen=false
    end
    return self:_updateChild(entity,rt,id)
end

local controller=EarlyBossController.new(handlers)

function M.update(self,rt)
    return controller:update(self,rt)
end

local function imageExists(name)
    return not rawget(_G,"lstg") or not lstg.CheckRes or lstg.CheckRes(2,name)
end

local function frameName(family,index)
    return "ld_"..family.."_"..tostring(index+1)
end

local function renderFrame(family,index,x,y,angle,scaleX,scaleY,reverseX)
    if index==nil or index<0 then return false end
    local name=frameName(family,index)
    if not imageExists(name) or not rawget(_G,"Render") then return false end
    local sx=(scaleX or 1)*(reverseX and -1 or 1)
    Render(name,x,y,Core.angleToDeg(angle or 0),sx,scaleY or scaleX or 1)
    return true
end

local function renderFrameStyled(family,index,x,y,angle,scaleX,scaleY,
                                 reverseX,blend,alpha,red,green,blue)
    if index==nil or index<0 then return false end
    local name=frameName(family,index)
    if not imageExists(name) or not rawget(_G,"Render") then return false end
    local setter=rawget(_G,"SetImageState") or
        (rawget(_G,"lstg") and lstg.SetImageState)
    local color=rawget(_G,"Color") or
        (rawget(_G,"lstg") and lstg.Color)
    if setter and color then
        setter(name,blend or "",color(
            Core.clamp(floor(alpha==nil and 255 or alpha),0,255),
            Core.clamp(floor(red==nil and 255 or red),0,255),
            Core.clamp(floor(green==nil and 255 or green),0,255),
            Core.clamp(floor(blue==nil and 255 or blue),0,255)))
    end
    local rendered=renderFrame(family,index,x,y,angle,scaleX,scaleY,reverseX)
    if setter and color then
        setter(name,"",color(255,255,255,255))
    end
    return rendered
end

local function renderOffset(self,family,index,dx,dy,angle,scaleX,scaleY,reverseX)
    local logicalScale=Core.worldScale()
    return renderFrame(family,index,self.x+(dx or 0)*logicalScale,
        self.y-(dy or 0)*Core.worldScaleY(),angle,scaleX,scaleY,reverseX)
end

local function renderOffsetStyled(self,family,index,dx,dy,angle,scaleX,scaleY,
                                  reverseX,blend,alpha,red,green,blue)
    local logicalScale=Core.worldScale()
    return renderFrameStyled(family,index,
        self.x+(dx or 0)*logicalScale,self.y-(dy or 0)*Core.worldScaleY(),
        angle,scaleX,scaleY,reverseX,blend,alpha,red,green,blue)
end

local function onLayer(requested,exact)
    return requested==nil or requested==exact
end

local function renderGauge(self)
    if self.spawnType>=0x138 and self.spawnType<=0x14c then return end
    if not self.targetable or not self.maxhp or self.maxhp<=0 or self.radius<80 then return end
    local name=self.radius>=130 and "ld_boss_gauge_1" or "ld_enemy_gauge_1"
    if imageExists(name) and rawget(_G,"Render") then
        Render(name,self.x,self.y+self.radius*Core.worldScaleY()*0.55,0,0.6,0.6)
    end
end

local gaugeProxyClass
if type(rawget(_G,"Class"))=="function" and
   type(rawget(_G,"object"))=="table" and
   type(rawget(_G,"New"))=="function" then
    gaugeProxyClass=Class(object)

    function gaugeProxyClass:init(owner)
        self.owner=owner
        self.layer=(rawget(_G,"LAYER_ENEMY_BULLET") or -200)+0x14
        self.group=rawget(_G,"GROUP_GHOST") or 0
        self.bound=false
        self.colli=false
        self.x,self.y=owner.x,owner.y
    end

    function gaugeProxyClass:frame()
        local owner=self.owner
        local valid=owner and owner.active~=false and
            owner.status~="del" and owner.status~="kill"
        local engine=rawget(_G,"lstg")
        if valid and engine and type(engine.IsValid)=="function" then
            valid=engine.IsValid(owner)
        end
        if not valid then
            if owner and owner._beGaugeProxy==self then owner._beGaugeProxy=nil end
            Del(self)
            return
        end
        self.x,self.y=owner.x,owner.y
    end

    function gaugeProxyClass:render()
        if self.owner then renderGauge(self.owner) end
    end
end

local function renderGaugeOnExactLayer(self)
    if self.spawnType>=0x138 and self.spawnType<=0x14c then return end
    if not self.maxhp or self.maxhp<=0 or not self.radius or self.radius<80 then return end
    if gaugeProxyClass then
        local proxy=self._beGaugeProxy
        local engine=rawget(_G,"lstg")
        if proxy and engine and type(engine.IsValid)=="function" and
           not engine.IsValid(proxy) then
            proxy=nil
        end
        if not proxy then
            proxy=New(gaugeProxyClass,self)
            self._beGaugeProxy=proxy
        end
        if proxy then return end
    end
    renderGauge(self)
end

local function renderBoss138(self,state,timer)
    local frame,large,scale=-1,false,1
    if state==0 or state==1 then frame,large=0,true
    elseif state==2 then
        if timer<130 then frame,large=0,true else frame=floor(timer/7)%3 end
    elseif state==3 then
        if timer<10 then frame=3+floor(timer/5)%2
        elseif timer<60 then frame=5+floor((timer-10)/5)%3
        elseif timer<70 then frame=4-floor((timer-60)/5)
        else frame=floor((timer-70)/7)%3 end
    elseif state==4 then frame=8+floor(timer/5)%2;scale=1-0.3*sin(timer*pi/180)
    elseif state==5 then
        if timer<80 then frame=floor(timer/7)%3
        elseif timer<90 then frame=3+floor((timer-80)/5)
        else frame=5+floor((timer-90)/5)%3 end
    elseif state==6 and timer<240 then frame=8+floor(timer/5)%2 end
    renderOffset(self,large and "enemy_l" or "boss",frame,0,0,0,scale,scale)
end

local function renderDecoration138(self,timer)
    if self.spawnType==0x12 then
        local wave=sin(timer*tau/99)
        renderOffset(self,"enemy_l",2,0,0,0)
        renderOffset(self,"enemy_l",1,0,wave*2-50,0)
    elseif self.spawnType==0x13 then
        local mirrored=(self._beOffsetX or 0)<0
        local a=trunc(sin((timer-66)*tau/99)*(mirrored and -700 or 700))
        renderOffset(self,"enemy_l",3,0,0,a,1,1,mirrored)
    else
        local mirrored=(self._beOffsetX or 0)<0
        local a=trunc(sin((timer-33)*tau/99)*(mirrored and -900 or 900))+
            (mirrored and -8000 or 8000)
        renderOffset(self,"enemy_l",4,0,0,a,1,1,mirrored)
    end
end

local function renderChild138(self,timer)
    local rear=sin(timer*tau/50);local middle=sin((timer-18)*tau/50)
    local front=sin((timer-36)*tau/50);local flap=trunc(sin(timer*tau/39)*2400)
    local wx,wy=Core.polar(flap,40)
    renderOffset(self,"enemy_s",14,wx,middle+wy,flap)
    renderOffset(self,"enemy_s",14,-wx,middle+wy,-flap,1,1,true)
    renderOffset(self,"enemy_s",13,0,front+16,0)
    renderOffset(self,"enemy_s",12,0,middle,0)
    renderOffset(self,"enemy_s",11,0,rear-32,0)
end

local function renderBoss139(self,state,timer,exactLayer)
    local source=max(0,(self._beSourceFrame or 0)-1)
    if state<=3 or (state==4 and timer<130) then
        local baseLayer=state==0 and 0x0f or 0x1e
        local yShift=(state>2 or (state==2 and timer>100)) and -160 or 0
        local pulse=1+0.1*sin(timer*tau/60)
        if onLayer(exactLayer,baseLayer) then
            for i=0,3 do
                renderOffset(self,"enemy_l",8,0,yShift+250,
                    source*600+i*0x4000)
            end
            renderOffset(self,"enemy_l",7,0,yShift+160,0)
        end
        local orbit={}
        for i=0,12 do
            local a=Core.angle16(source*0xde+i*0x13b1);local dx,dy=Core.ellipse(a,215,120,0)
            orbit[#orbit+1]={a,dx,dy}
        end
        local angles={0,0x2aaa,0x5554,0x7ffe,0xaaa8,0xd552}
        local early=state<2 or (state==2 and timer<=100)
        if onLayer(exactLayer,baseLayer+1) then
            if not early then
                renderOffsetStyled(self,"boss",10+floor(timer/5)%3,
                    0,yShift,0,1,1,false,"",0x40,0,0,0)
            end
            for _,v in ipairs(orbit) do
                if v[1]>0x8000 then
                    renderOffset(self,"enemy_m",48,v[2],
                        yShift+80+v[3],0)
                end
            end
        end
        if onLayer(exactLayer,baseLayer+2) then
            if early then
                renderOffset(self,"enemy_l",6,0,0,0)
                for i=5,6 do
                    local dx,dy=Core.ellipse(angles[i],140,90,0)
                    renderOffset(self,"enemy_m",46,dx,-80+dy,0,pulse,1)
                end
            else
                renderOffset(self,"boss",10+floor(timer/5)%3,0,yShift,0)
            end
            for _,v in ipairs(orbit) do
                if v[1]<=0x8000 then
                    renderOffset(self,"enemy_m",48,v[2],
                        yShift+80+v[3],0)
                end
            end
        end
        if early and onLayer(exactLayer,baseLayer+3) then
            renderOffset(self,"enemy_m",47,0,-90,0)
            for i=1,4 do
                local dx,dy=Core.ellipse(angles[i],140,90,0)
                renderOffset(self,"enemy_m",46,dx,-80+dy,0,pulse,1)
            end
        end
        return
    end
    local frame,scale=-1,1
    if state==4 then frame=10+floor(timer/5)%3
    elseif state==5 or state==7 then frame=timer<10 and 13+floor(timer/5)%2 or 15+floor((timer-10)/5)%3
    elseif state==6 then frame=18+floor(timer/5)%2;scale=1-0.3*sin(timer*tau/360)
    elseif state==8 and timer<240 then frame=18+floor(timer/5)%2 end
    if onLayer(exactLayer,0x1e) then
        renderOffset(self,"boss",frame,0,0,0,scale,scale)
    end
end

local function renderChild139(self,state,timer,exactLayer)
    if self.spawnType==0x22 then
        local sx=1-0.05*sin(timer*tau/25);local sy,core=1,1
        if state==0 and timer<30 then sy,core=sin(timer*pi/60),0
        elseif state==0 and timer<50 then core=sin((timer-30)*pi/40) end
        local frame=39+(self._beIndex or 0)%4
        if onLayer(exactLayer,0x1e) then
            renderOffsetStyled(self,"enemy_m",frame,0,-20,0,
                sx,sy*0.7,false,"",0x40,0,0,0)
        end
        if onLayer(exactLayer,0x23) then
            -- The original uses a bottom pivot at y+50. With LuaSTG's
            -- centered sprites its visual center is y-50 for these frames.
            renderOffset(self,"enemy_m",frame,0,-50,0,sx,sy)
            renderOffset(self,"enemy_s",20+floor(timer/3)%3,
                0,-60,0,core,core)
        end
    elseif onLayer(exactLayer,0x1d) then
        local parentTimer=self.parent and (self.parent._beDrawTimer or self.parent.helperTimer) or 0
        local scale=1+0.1*sin(parentTimer*tau/44)
        local a=Core.angle16(self.secondaryAngle16+parentTimer*333)
        renderOffset(self,"enemy_s",23,0,0,a,scale,scale)
    end
end

local function renderBoss13a(self,state,timer,exactLayer)
    if state<=3 or (state==4 and timer<130) then
        if onLayer(exactLayer,0x20) then
            renderOffset(self,"enemy_l",13,0,0,0)
        end
        if onLayer(exactLayer,0x22) then
            local source=self._beSourceFrame or 0
            for i=0,3 do
                renderOffset(self,"enemy_l",15,0,-255,
                    source*0x500+i*0x4000)
            end
        end
        return
    end
    local frame=-1
    if (state==4 and timer>=130) or state==5 or state==7 then frame=20+floor(timer/7)%3
    elseif state==6 or (state==8 and timer<240) then frame=23+floor(timer/5)%2 end
    if onLayer(exactLayer,0x1e) then
        renderOffset(self,"boss",frame,0,0,0)
    end
end

local leafAngles={0,0x3333,0x6666,-0x6667,-0x3334}
local function renderChild13a(self,state,timer,exactLayer)
    if self.spawnType==0x30 then
        if onLayer(exactLayer,0x1f) then
            renderOffset(self,"enemy_l",state==2 and 16 or 14,
                0,0,0,1,1,(self._beOffsetX or 0)<0)
        end
        if onLayer(exactLayer,0x1e) then
            local accentX=(self._beOffsetX or 0)<0 and 85 or -85
            local orange=timer%4>=2
            renderOffsetStyled(self,"effect_s",0,accentX,-255,0,1,1,
                false,"",0xc0,255,orange and 128 or 255,
                orange and 0 or 255)
        end
    elseif self.spawnType==0x31 and onLayer(exactLayer,0x21) then
        renderOffset(self,"enemy_m",62,0,0,self.angle16)
    elseif self.spawnType>=0x32 and onLayer(exactLayer,0x23) then
        local outer,inner=1,1
        if state==0 and timer<10 then outer=sin(timer*pi/20);inner=0
        elseif state==0 and timer<40 then inner=sin((timer-10)*pi/60) end
        renderOffset(self,"enemy_s",30,0,0,0,outer,outer)
        renderOffset(self,"enemy_s",29,0,0,0,inner,inner)
        local base=Core.angle16(self.secondaryAngle16-2000)
        for _,a in ipairs(leafAngles) do renderOffset(self,"enemy_s",31,0,-30,base+a,inner,inner) end
    end
end

local function stage04BossFrame(self,state,timer)
    if (state==2 and timer>=130) or state==3 or state==5 or state==7 then
        return 25+floor(timer/7)%3,1
    elseif state==4 or state==9 then
        local duration=state==4 and 60 or 40
        if timer>=duration then return 25,1 end
        local right=(self._beMoveToX or self.ldX)>(self._beMoveFromX or self.ldX)
        if timer<10 then return (right and 28 or 33)+floor(timer/5)%2,1
        elseif timer<duration-10 then return (right and 30 or 35)+floor((timer-10)/5)%3,1
        else return (right and 29 or 34)-floor((timer-(duration-10))/5),1 end
    elseif state==6 or state==8 then return 38+floor(timer/5)%2,1-0.3*sin(timer*pi/180)
    elseif state==10 then
        local phase=timer%364
        if phase<15 then return ({26,33,34})[floor(phase/5)+1],1
        elseif phase<167 then return 35+floor((phase-15)/5)%3,1
        elseif phase<197 then return ({34,33,25,26,28,29})[floor((phase-167)/5)+1],1
        elseif phase<349 then return 30+floor((phase-197)/5)%3,1
        else return ({29,28,25})[floor((phase-349)/5)+1],1 end
    elseif state==11 and timer<240 then return 38+floor(timer/5)%2,1 end
    return -1,1
end

local function renderBoss13b(self,state,timer,exactLayer)
    if state==0 or state==1 or (state==2 and timer<130) then
        local scale0,scale1,alpha,brightness=1,1,255,255
        if state==0 then
            scale0=timer<180 and 0.3+0.7*sin(timer*pi/360) or 0.3
            scale1=scale0
            brightness=0
            if timer<60 then alpha=sin(timer*pi/120)*255
            elseif timer<180 then brightness=sin((timer-60)*pi/240)*255 end
        elseif state==2 then
            scale0=1+0.1*sin((self._beSourceFrame or 0)*tau/21)
            scale1=1-0.2*sin(((self._beSourceFrame or 0)%5)*pi/5)
        end
        if state~=2 then
            local phase=(self._beSourceFrame or 0)%40
            if phase<11 then scale1=scale1-scale1*0.1*sin(phase*pi/10) end
        end
        if onLayer(exactLayer,0x1b) then
            renderOffsetStyled(self,"enemy_l",20,0,0,0,scale1,scale1,
                false,"",alpha,brightness,brightness,brightness)
        end
        if onLayer(exactLayer,0x1e) then
            renderOffsetStyled(self,"enemy_l",19,0,0,0,scale0,scale0,
                false,"",alpha,brightness,brightness,brightness)
        end
        return
    end
    local frame,scale=stage04BossFrame(self,state,timer)
    if onLayer(exactLayer,0x1e) then
        renderOffset(self,"boss",frame,0,0,0,scale,scale)
    end
end

local chainX={50,-50,100,-100,140,-140}
local chainY={150,150,140,140,120,120}
local function renderChild13b(self,state,timer,exactLayer)
    if self.spawnType==0x40 then
        local parent=self.parent;local idx=(self._beIndex or 0)+1
        if parent and onLayer(exactLayer,0x1c) then
            local ax,ay=parent.ldX+chainX[idx],parent.ldY+chainY[idx]
            for segment=0,19 do
                if not (state==-1 and timer>60-segment*3) then
                    local scale=1
                    if state==0 then
                        local start=segment*2
                        if timer<start then scale=0 elseif timer<start+8 then scale=sin((timer-start)*pi/16) end
                    end
                    local f=segment/20;local lx=ax+(self.ldX-ax)*f+4*sin(((self._beSourceFrame or 0)-segment*7)*tau/80)
                    local ly=ay+(self.ldY-ay)*f;local wx,wy=Core.toWorld(lx,ly,self.runtime and self.runtime.cameraX)
                    renderFrame("enemy_s",43,wx,wy,self.angle16,scale,scale)
                end
            end
        end
        if state~=-1 and onLayer(exactLayer,0x23) then
            local scale=1
            if state==0 then if timer<40 then scale=0 elseif timer<48 then scale=sin((timer-40)*pi/16) end
            elseif (state==5 or state==8) and timer<9 then scale=1+0.4*sin(timer*pi/8) end
            renderOffset(self,"enemy_m",75,0,0,self.angle16,scale,scale)
            if (state==4 or state==7) and timer%4<2 then renderOffset(self,"enemy_m",75,0,0,self.angle16,scale,scale) end
        end
    elseif self.spawnType==0x41 and
           onLayer(exactLayer,primaryVisualLayer(self)) then
        local entry=state==0 and sin(timer*pi/100) or 1
        local parentTimer=self.parent and (self.parent._beDrawTimer or self.parent.helperTimer) or 0
        local base=entry*(0.9+0.1*sin(Core.angleToRadians(self.secondaryAngle16)))
        renderOffset(self,"enemy_s",44,0,0,0,base*(1+0.1*sin((parentTimer-10)*pi/22)),base)
        renderOffset(self,"enemy_s",45,0,0,0,base*(1+0.1*sin(parentTimer*pi/22)),base)
    elseif self.spawnType>=0x42 and onLayer(exactLayer,0x23) then
        local entry=state==0 and sin(timer*pi/100) or 1
        local parentTimer=self.parent and (self.parent._beDrawTimer or self.parent.helperTimer) or 0
        local pulse0=entry*(1+0.1*sin(parentTimer*pi/33));local pulse12=entry*(1+0.1*sin((parentTimer-12)*pi/33))
        local dx,dy=Core.polar(self.angle16,30*entry)
        renderOffset(self,"enemy_m",77,dx,dy,self.angle16,entry,pulse12)
        renderOffset(self,"enemy_m",76,0,0,0,entry,pulse0)
    end
end

local renderVisualLayer
local visualLayerProxyClass
if type(rawget(_G,"Class"))=="function" and
   type(rawget(_G,"object"))=="table" and
   type(rawget(_G,"New"))=="function" then
    visualLayerProxyClass=Class(object)

    function visualLayerProxyClass:init(owner,exactLayer)
        self.owner=owner
        self.exactLayer=exactLayer
        self.layer=exactToLuaLayer(exactLayer)
        self.group=rawget(_G,"GROUP_GHOST") or 0
        self.bound=false
        self.colli=false
        self.x,self.y=owner.x,owner.y
    end

    function visualLayerProxyClass:frame()
        local owner=self.owner
        local valid=owner and owner.active~=false and
            owner.status~="del" and owner.status~="kill"
        local engine=rawget(_G,"lstg")
        if valid and engine and type(engine.IsValid)=="function" then
            valid=engine.IsValid(owner)
        end
        if not valid then
            Del(self)
            return
        end
        self.x,self.y=owner.x,owner.y
    end

    function visualLayerProxyClass:render()
        if self.owner and renderVisualLayer then
            renderVisualLayer(self.owner,self.exactLayer,false)
        end
    end
end

local VisualLayerProxyPool={}
VisualLayerProxyPool.__index=VisualLayerProxyPool

function VisualLayerProxyPool.new(proxyClass,layersByType,ownerField)
    return setmetatable({
        proxyClass=proxyClass,
        layersByType=layersByType,
        ownerField=ownerField,
    },VisualLayerProxyPool)
end

function VisualLayerProxyPool:ensure(owner)
    local layers=self.layersByType[owner.spawnType]
    if not self.proxyClass or not layers then return false end
    owner[self.ownerField]=owner[self.ownerField] or {}
    local proxies=owner[self.ownerField]
    local engine=rawget(_G,"lstg")
    for _,exactLayer in ipairs(layers) do
        local proxy=proxies[exactLayer]
        if proxy and engine and type(engine.IsValid)=="function" and
           not engine.IsValid(proxy) then
            proxy=nil
        end
        if not proxy then
            proxy=New(self.proxyClass,owner,exactLayer)
            proxies[exactLayer]=proxy
        end
        if not proxy then return false end
    end
    return true
end

local visualLayerProxies=VisualLayerProxyPool.new(
    visualLayerProxyClass,extraVisualLayers,"_beLayerProxies")

renderVisualLayer=function(self,exactLayer,withGauge)
    local state=self._beDrawState or self.state or 0
    local timer=self._beDrawTimer or self.helperTimer or 0
    local id=self.spawnType
    if id==0x138 and onLayer(exactLayer,0x1e) then
        renderBoss138(self,state,timer)
    elseif id>=0x12 and id<=0x14 and
           onLayer(exactLayer,primaryVisualLayer(self)) then
        renderDecoration138(self,timer)
    elseif id>=0x15 and id<=0x17 and onLayer(exactLayer,0x23) then
        renderChild138(self,timer)
    elseif id==0x139 then renderBoss139(self,state,timer,exactLayer)
    elseif id>=0x22 and id<=0x24 then
        renderChild139(self,state,timer,exactLayer)
    elseif id==0x13a then renderBoss13a(self,state,timer,exactLayer)
    elseif id>=0x30 and id<=0x34 then
        renderChild13a(self,state,timer,exactLayer)
    elseif id==0x13b then renderBoss13b(self,state,timer,exactLayer)
    elseif id>=0x40 and id<=0x43 then
        renderChild13b(self,state,timer,exactLayer)
    end
    if withGauge and (id==0x138 or id==0x139 or id==0x13a or id==0x13b) then
        renderGaugeOnExactLayer(self)
    end
    return true
end

function M.render(self)
    if not appearance[self.spawnType] then return false end
    local layered=visualLayerProxies:ensure(self)
    local exactLayer=layered and primaryVisualLayer(self) or nil
    return renderVisualLayer(self,exactLayer,true)
end

M.appearance=appearance

return M
