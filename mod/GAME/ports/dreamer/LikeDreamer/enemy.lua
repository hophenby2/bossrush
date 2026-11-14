-- Like Dreamer enemy/session compatibility runtime.

LikeDreamer = LikeDreamer or {}

local Core = LikeDreamer.Core
local Projectile = LikeDreamer.Projectile
local Reward = LikeDreamer.Reward
local M = {}
LikeDreamer.Enemy = M

local sin, cos, pi = math.sin, math.cos, math.pi
local floor = math.floor
local min, max = math.min, math.max

local earlySpecs = {
    [0x06]={90,8,"m",-100}, [0x07]={90,8,"m",-100}, [0x08]={90,8,"m",-100},
    [0x09]={40,11,"m"}, [0x0a]={50,12,"m"}, [0x0b]={30,4,"s"},
    [0x0c]={30,6,"s",-20}, [0x0d]={30,9,"s"}, [0x0e]={80,16,"m",-100},
    [0x0f]={90,22,"m"}, [0x10]={150,26,"m"}, [0x11]={22,32,"m"},
    [0x19]={40,15,"s"}, [0x1a]={30,18,"s",-20}, [0x1b]={80,34,"m",-100},
    [0x1c]={60,36,"m"}, [0x1d]={40,19,"m"}, [0x1e]={40,39,"m"},
    [0x1f]={100,43,"m"}, [0x20]={150,45,"m"}, [0x21]={50,44,"m"},
    [0x25]={40,24,"s",-20}, [0x26]={90,49,"m",-100},
    [0x27]={70,51,"m"}, [0x28]={20,27,"m"}, [0x29]={70,53,"m"},
    [0x2a]={20,28,"m"}, [0x2b]={100,10,"s",-150}, [0x2c]={40,25,"s"},
    [0x2d]={80,58,"m"}, [0x2e]={240,11,"m"}, [0x2f]={70,60,"m"},
    [0x35]={30,32,"s"}, [0x36]={40,34,"s"}, [0x37]={40,40,"s"},
    [0x38]={90,63,"m",-100}, [0x39]={60,68,"m"}, [0x3a]={60,68,"m"},
    [0x3b]={40,70,"m"}, [0x3c]={40,71,"m"}, [0x3d]={160,73,"m"},
    [0x3e]={40,72,"m"}, [0x3f]={240,74,"m"},
}

local lateRaw = {
    {0x44,0x32,30},{0x45,0x33,40},{0x46,0x34,70},{0x47,0x35,80},
    {0x48,0x35,80},{0x49,0x36,35},{0x4a,0x37,90,-100},{0x4b,0x1c,20},
    {0x4c,0x38,80},{0x4d,0x39,90},{0x4e,0x3a,30},{0x4f,0x3b,160},
    {0x50,0x3c,100},{0x51,0x3c,100},{0x52,0x3c,100},{0x53,0x3d,40},
    {0x54,0x3e,40},{0x55,0x3f,25},{0x56,0x40,40},
    {0x57,0x41,60},{0x58,0x41,60},{0x59,0x42,60},{0x5a,0x43,40},
    {0x5b,0x44,40},{0x5c,0x44,40},{0x5d,0x45,60},{0x5e,0x46,95},
    {0x5f,0x47,120},{0x60,0x48,25},
    {0x70,0x4f,40},{0x71,0x50,80},{0x72,0x50,80},{0x73,0x51,100,-100},
    {0x74,0x52,40},{0x75,0x53,50},{0x76,0x54,110},{0x77,0x55,60},
    {0x78,0x56,40},{0x95,0x62,45},{0x96,0x63,40},{0x97,0x64,50},
    {0x98,0x64,50},{0x99,0x64,50},{0x9a,0x65,140},{0x9b,0x66,70},
    {0x9c,0x66,70},{0x9e,0x66,70},{0x9f,0x66,70},{0xa1,0x66,70},
    {0xa2,0x66,70},{0xa4,0x67,90},{0xad,0x6c,40,-10},
    {0xfa,0x82,45},{0xfb,0x83,45,-20},{0xfc,0x84,60,-60},
    {0xfd,0x85,50,-50},{0xfe,0x86,70},{0xff,0x1c,20},
    {0x100,0x87,70},{0x101,0x1c,20},{0x102,0x88,90,-100},
    {0x103,0x89,90},{0x104,0x89,90},
}
local lateSpecs = {}
for _, v in ipairs(lateRaw) do
    lateSpecs[v[1]] = {
        radius = v[3],
        updateCase = v[2],
        forcedY = v[4],
    }
end

local bossSpecs = {
    [0x138]={160,{60000,55000,60000},{1800,1800,1800}},
    [0x139]={180,{60000,75000,40000,50000},{1800,1800,1800,1800}},
    [0x13a]={150,{70000,66000,40000,50000},{1800,1800,1800,1800}},
    [0x13b]={200,{195000,45000,58000,70000},{4500,1800,1800,2100}},
    [0x13c]={175,{60000,55000,55000,70000,45000,80000},{1500,1500,1500,1800,1800,2100}},
    [0x13d]={175,{100000,86000,68000,70000,80000},{3600,2100,1800,2100,2100}},
    [0x13e]={210,{148000,70000,70000,70000,80000},{3600,2100,2100,2100,2100}},
    [0x13f]={130,{145000,105000,80000,40000,80000,148000},{3300,2700,2400,1500,2400,3300}},
    [0x140]={140,{100000,100000,200000,150000},{2400,2400,5400,6000}},
    [0x141]={80,
        {75000,70000,65000,50000,75000,50000,60000,100000,
         45000,80000,65000,75000,85000,128000,32000,270000},
        {2400,2400,2100,2400,2400,2400,2100,3300,
         2100,2400,2400,2400,2400,3300,5400,6000}},
}

local gateOwners = {
    [1]={[0x10]=true}, [2]={[0x20]=true}, [3]={[0x2e]=true},
    [4]={[0x3f]=true}, [5]={[0x4f]=true}, [6]={[0x143]=true},
    [7]={[0x77]=true,[0x144]=true,[0x145]=true},
    [8]={[0xa4]=true,[0x2e]=true},
    [9]={[0xa4]=true,[0x146]=true,[0x147]=true,[0x148]=true,
         [0x149]=true,[0x14a]=true,[0x14b]=true},
}

local function isFinalBoss(t)
    return t >= 0x138 and t <= 0x141
end

local function isMidboss(t)
    return t >= 0x143 and t <= 0x14b
end

local function play(name, volume)
    if lstg.CheckRes(5, name) then lstg.PlaySound(name, volume or 0.45, 0) end
end

local function playerLD()
    local p = rawget(_G, "player")
    return p and p.ldX or 360, p and p.ldY or 600
end

local function aim(self, x, y)
    local px, py = playerLD()
    return Core.aim16(x or self.ldX, y or self.ldY, px, py)
end

local function move(self, angle, speed)
    local dx, dy = Core.polar(angle or self.angle16, speed or self.speed)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
end

local function scrollDelta(rt)
	return rt.scrollDelta or rt.stageScrollDelta or 1
end

local function fire(self, visual, id, angle, speed, radius, travel, arg, x, y)
    return Projectile.spawn(visual, id, x or self.ldX, y or self.ldY,
        angle or self.angle16, travel or 0, speed or 5, radius or 1, arg or 0)
end

local function fan(self, visual, id, angle, speed, count, spread, radius, x, y, arg)
    return Projectile.spread(visual, id, x or self.ldX, y or self.ldY,
        angle or self.angle16, 0, speed or 5, radius or 1, count or 1,
        spread or 0, arg or 0)
end

local function quantizeAngle(a, step)
    step = step or 0x800
    return Core.angle16(floor((a + step * 0.5) / step) * step)
end

local function sync(self)
    Core.syncObject(self, self.ldX, self.ldY)
    self.a = max(1, self.radius * Core.worldScale())
    self.b = max(0.1, self.radius * Core.worldScaleY())
    self.ldRadius = self.radius
    self.colli = self.targetable and not self.protect
    self.is_combat = self.colli
end

local function setImage(self)
    if isFinalBoss(self.spawnType) or isMidboss(self.spawnType) then
        self.sheet = "boss"
        self.visualFrame = self.visualFrame or 0
    end
    local prefix = self.sheet == "boss" and "ld_boss_"
        or self.sheet == "l" and "ld_enemy_l_"
        or self.sheet == "xl" and "ld_enemy_xl_"
        or self.sheet == "m" and "ld_enemy_m_" or "ld_enemy_s_"
    local frame = self.visualFrame or 0
    if self.spawnType == 0x06 or self.spawnType == 0x08 then
        frame = 8 + self.entityId % 3
    elseif self.spawnType == 0x0e then
        frame = 16 + self.entityId % 6
    elseif self.spawnType == 0x0f then
        frame = 22 + self.entityId % 4
    elseif self.spawnType == 0x10 then
        frame = 26 + self.entityId % 6
    elseif self.spawnType == 0x11 then
        frame = 32 + (((self._ldIndex or 1) - 1) % 2)
    end
    local image = prefix .. tostring(frame + 1)
    if self.img ~= image then
        assert(lstg.CheckRes(2,image), ('Like Dreamer 缺少敌机贴图 %s（第%d面，类型 %x）'):format(image,self.runtime.stage,self.spawnType))
        self.img = image
    end
end

local function activate(self, speed, angle)
    self.state = 1
    self.helperTimer = -1
    self.targetable = true
    self.speed = speed or self.speed
    self.angle16 = Core.angle16(angle or self.angle16)
end

local function effectiveHelpLevel(rt)
	local selected = floor(Core.clamp(rt.helpLevel or 6, 0, 6))
	return selected >= 1 and selected <= 5 and selected or 0
end

local function spawnHelpSatellites(self, rt)
	local route = rt.routeMode or 0
	local enabled = (self.spawnType == 0x06 and (route == 0 or route == 1)) or
		(self.spawnType == 0x07 and route == 0)
	if not enabled then return end
	for index = 0, effectiveHelpLevel(rt) - 1 do
		local hp = rt.difficulty == 0 and 2400 or 3000
		local child = rt:spawnChild(self, 0x09, hp, 0, 0,
			"Help satellite type 0x09")
		if child then
			child.ldX, child.ldY = 0, 0
			child.originX, child.originY = 0, 0
			child.radius = 0x28
			child.visualFrame, child.sheet = 11, "m"
			child.angle16 = 0
			child.sourceAngle16 = Core.randomAngle(rt.frame + index, 0)
			child.secondaryAngle16 = Core.angle16(
				Core.randomAngle(child.entityId + 0x6f, 0) + 0x200)
			local dx, dy = Core.ellipse(child.secondaryAngle16, 1, 1,
				child.sourceAngle16)
			child.ldX, child.ldY = self.ldX + dx, self.ldY + dy
			Core.syncObject(child, child.ldX, child.ldY)
			child.targetable = false
			child._ldHelpSatellite = true
			child._ldIndex = index
		end
	end
end

local function commonMarker(self, rt)
    local t, d = self.helperTimer, rt.difficulty
	local createHelpSatellites = false
    if self.state == 0 then
		if t ~= 20 then return end
		createHelpSatellites = true
		activate(self, 6, 0x4000)
		-- The original helper continues through active state timer zero in the
		-- transition call; the common frame tail advances it to one.
		self.helperTimer = 0
		t = 0
    end
    if t <= 120 and self.speed > 1 then self.speed = self.speed - 0.1 end
    local a = Core.aim16(self.ldX, self.ldY + 75, playerLD())
    self.secondaryAngle16 = Core.turn16(self.secondaryAngle16, a, 0x14)
    move(self)
	if createHelpSatellites then spawnHelpSatellites(self, rt) end
    local start = Core.diff({40,30,30,30,30}, d)
    local period = Core.diff({100,80,60,60,50}, d)
    local localt = (t - start) % period
    if t >= start and t < 240 and localt < 30 and localt % 5 == 0 then
        local speed = Core.diff({4,6,8,9.5,11}, d) + localt * 0.05
        fan(self, 0, 0, self.secondaryAngle16, speed,
            Core.diff({1,3,5,5,7}, d), 20000, 1, self.ldX, self.ldY + 75)
        if d > 2 then
            fan(self, 0, 0, self.secondaryAngle16, speed - 2,
                Core.diff({1,3,5,5,7}, d), 20000, 1, self.ldX, self.ldY + 75)
        end
    end
end

local function helpSatellite(self)
	local parent = self.parent
	if not parent then self.removeRequested = true; return end
	if parent.hp < 1 then
		if not self._ldHelpRewardSpawned then
			self._ldHelpRewardSpawned = true
			if Reward then
				local angle = Core.angle16(
					Core.frameRand(self.entityId) % 0x4001 + 0x2000)
				Reward.spawnItem(7, self.ldX, self.ldY, angle, 4, 30)
			elseif rawget(_G, "item_extend") then
				New(item_extend, self.x, self.y)
			end
		end
		self.removeRequested = true
		return
	end
	if not parent.active then self.removeRequested = true; return end

	local t = self.helperTimer
	if t == 0 then
		self.secondaryAngle16 = Core.randomAngle(self.entityId + 0x6f, 0)
	end
	self.secondaryAngle16 = Core.angle16(self.secondaryAngle16 + 0x200)
	local radiusA, radiusB = 160, 60
	if t <= 60 then
		local entrance = sin(t * pi / 120)
		radiusA, radiusB = entrance * 160 + 1, entrance * 60 + 1
	end
	local dx, dy = Core.ellipse(self.secondaryAngle16, radiusB, radiusA,
		self.sourceAngle16)
	self.ldX, self.ldY = parent.ldX + dx, parent.ldY + dy
	self.angle16 = 0
	self.targetable = false
end

local function type0A(self, rt)
    local t, d = self.helperTimer, rt.difficulty
    local animationTick = rt.frame + self.entityId * 5
    self.visualFrame = 12 + floor((animationTick % 18) / 6)
    local wingAngle = sin(animationTick * pi / 4) * 3000
    self.targetAngle16 = Core.angle16(
        wingAngle < 0 and math.ceil(wingAngle) or floor(wingAngle))
    if self.state == 0 then
        if not self.entryAngle then
            self.entryAngle = Core.frameRand(self.entityId) % 4001 + 0x3830
            local dx, dy = Core.polar(self.entryAngle, 300)
            self.entryX, self.entryY = self.originX + dx, self.originY + dy
        end
        local q = sin(t * pi / 240)
        self.ldX = self.entryX + q * (self.originX - self.entryX)
        self.ldY = self.entryY + q * (self.originY - self.entryY)
        if t == 120 then activate(self, 0.8, aim(self)) end
        return
    end
    if t < 300 then self.angle16 = Core.turn16(self.angle16, aim(self), 0x100)
    else self.angle16 = Core.turn16(self.angle16, 0xc000, 0x100); self.speed = self.speed + 0.1 end
    move(self)
    local start = Core.diff({20,10,0,0,0}, d)
    local period = Core.diff({150,120,60,40,32}, d)
    local q = (t - start) % period
    if t < 300 and t >= start and q <= 19 and q % 3 == 0 then
        if q == 0 then self.secondaryAngle16 = aim(self, self.ldX, self.ldY - 15) end
        local s = Core.diff({4,5,6.5,7,8}, d)
        for _, ox in ipairs({-25,0,25}) do fire(self,4,0,self.secondaryAngle16,s,1,0,0,self.ldX+ox,self.ldY-15) end
        if d > 2 then fire(self,4,0,self.secondaryAngle16,s+2,1,0,0,self.ldX,self.ldY-15) end
        if d > 3 then
            fire(self,4,0,self.secondaryAngle16-0x457,s+2,1,0,0,self.ldX,self.ldY-15)
            fire(self,4,0,self.secondaryAngle16+0x457,s+2,1,0,0,self.ldX,self.ldY-15)
        end
        self.secondaryAngle16 = Core.turn16(self.secondaryAngle16, aim(self), 0x40)
    end
end

local function enterSide(self, minSpeed, maxSpeed)
    if self.helperTimer ~= 20 then return false end
    local r = Core.frameRand((LikeDreamer.runtime and LikeDreamer.runtime.frame or 0) + self.entityId)
    local hundred = floor(minSpeed * 100) + r % (floor((maxSpeed-minSpeed)*100)+1)
    local a = self.ldX <= 0 and 0 or (self.ldX >= 720 and 0x8000 or 0x4000)
    self.ldX, self.ldY = Core.clampToPlayfield(self.ldX, self.ldY, 20)
    activate(self, hundred / 100, a)
    return true
end

local function type0BOrC(self, rt, typeC)
    local t, d = self.helperTimer, rt.difficulty
    if self.state == 0 then enterSide(self, typeC and 5 or 7, typeC and 7 or 9); return end
    local oldX, oldY = self.ldX, self.ldY
    if t < 200 then
        if self.speed > 1 then self.speed = self.speed - 0.1 end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    else
        self.angle16 = Core.turn16(self.angle16, 0xc000, typeC and 0x100 or 0x200)
        self.speed = self.speed + 0.1
    end
    move(self)
    if typeC then
        local start = Core.diff({30,20,12,10,10},d)
        local period = Core.diff({140,100,80,80,60},d)
        local q = (t-start)%period
        if t < 200 and t >= start then
            if q == 0 then self.secondaryAngle16 = aim(self, oldX, oldY+25) end
            if q < 40 and q%5==0 then
                local s=Core.diff({4.8,6.5,8,8,9.5},d)+q*0.02
                fire(self,7,0,self.secondaryAngle16,s,1,10,0,oldX-20,oldY+25)
                fire(self,7,0,self.secondaryAngle16,s,1,10,0,oldX+20,oldY+25)
                if d>2 then
                    fire(self,7,0,self.secondaryAngle16-700,s-0.8,1,10,0,oldX-20,oldY+25)
                    fire(self,7,0,self.secondaryAngle16+700,s-0.8,1,10,0,oldX+20,oldY+25)
                end
            end
        end
    else
        local start=Core.diff({30,16,12,8,6},d)
        local period=rt.stage<=3 and Core.diff({32,27,20,15,6},d) or Core.diff({24,20,16,12,6},d)
        local q=(t-start)%(period*5)
        if t<200 and t>=start and (q==0 or q==period or q==period*2) and Core.inside(oldX,oldY+25,0) then
            local a=quantizeAngle(aim(self,oldX,oldY+25),0x800)
            local s=Core.diff({4.5,5.5,6.5,6.5,8.5},d)
            fire(self,0,0,a,s,1,0,0,oldX,oldY+25)
            if d>2 then fire(self,0,0,a,s+1.6,1,0,0,oldX,oldY+25) end
        end
    end
end

local function type0D(self, rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==0 then
        if t==20 then activate(self,rt.stage>=4 and 4 or 3,self.ldX<=360 and 0xf2fb or 0x8d05) end
        return
    end
    local dx,dy=Core.polar(self.angle16,self.speed)
    self.originX,self.originY=self.originX+dx,self.originY+dy
    self.ldX=self.originX
    self.ldY=self.originY-sin((t%33)*pi/33)*10
    local period=Core.diff({60,44,24,15,7},d)
    if rt.frame%period==0 and Core.inside(self.ldX,self.ldY+25,0) then
        local a=quantizeAngle(aim(self,self.ldX,self.ldY+25),0x800)
        local s=Core.diff({3,4,4.5,5.5,7.5},d)
        fire(self,0,0,a,s,1,0,0,self.ldX,self.ldY+25)
        fire(self,0,0,a,s,1,10,0,self.ldX,self.ldY+25)
    end
end

local function type0E(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==0 then if t==20 then activate(self,7,aim(self)) end; return end
    if t<=120 and self.speed>1.2 then self.speed=self.speed-0.1 end
    self.angle16=Core.turn16(self.angle16,aim(self),0x80)
    if t>=300 then self.speed=self.speed-0.1 end
    move(self)
    if t>=24 and t<300 then
        local q=(t-24)%150
        local s=Core.diff({6,7.5,8.5,9,11},d)
        local function burst(offsetX)
            local a=aim(self,self.ldX+offsetX,self.ldY+25)
            fire(self,9,0,a,s,1,0,0,self.ldX+offsetX,self.ldY+25)
            if d>1 then fan(self,9,0,a,s-1,3,Core.diff({0,0,1800,3300,2500},d),1,self.ldX+offsetX,self.ldY+25) end
        end
        if q<30 and q%5==0 then burst(35) elseif q>=40 and q<70 and q%5==0 then burst(-35) end
        local interval=Core.diff({40,30,30,15,15},d)
        if q>=80 and q<120 and (q-80)%interval==0 then
            local a=aim(self,self.ldX,self.ldY+25)
            fan(self,0,0,a-200,s-2.5,Core.diff({4,6,10,12,13},d),28000,1,self.ldX,self.ldY+25)
            fan(self,0,0,a+200,s-2.5,Core.diff({4,6,10,12,13},d),28000,1,self.ldX,self.ldY+25)
        end
    end
end

local function type0F(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==0 then if t==20 then activate(self,9,self.ldX<=360 and 0 or 0x8000) end; return end
    if t<=120 and self.speed>1 then self.speed=self.speed-0.1 end
    self.angle16=Core.turn16(self.angle16,aim(self),0x80)
    if t>=300 then self.speed=self.speed-0.1 end
    move(self)
    if t>=40 and t<300 then
        local period=Core.diff({200,120,100,90,90},d)
        local active=Core.diff({30,40,50,50,50},d)
        local q=(t-40)%period
        if q<active then
            local jitter=Core.diff({800,1200,1800,2400,3000},d)
            local a=aim(self)+floor((Core.randomUnit(rt.frame,self.entityId+q)*2-1)*jitter)
            fire(self,q%2==0 and 5 or 1,0,a,Core.diff({4,5,6,7,8},d)+q*0.1,1,0,0,self.ldX-25,self.ldY)
            fire(self,q%2==0 and 1 or 5,0,a,Core.diff({4,5,6,7,8},d)+q*0.1,1,0,0,self.ldX+25,self.ldY)
        elseif q==65 then
            fan(self,4,0,aim(self),Core.diff({4,5,6,7,8},d),Core.diff({5,11,15,17,19},d),10000,1)
        end
    end
end

local function genericEnemy(self,rt)
    local t,d=self.helperTimer,rt.difficulty
    if self.state==0 then
        if t==20 then
            local a=0x4000
            if self.ldX<Core.playfieldOriginX()-10 then a=0
            elseif self.ldX>Core.playfieldOriginX()+610 then a=0x8000
            elseif self.spawnType==0x2c or self.spawnType==0x2d then a=0xc000 end
            activate(self,self.radius>=100 and 1.2 or 3.0,a)
        end
        return
    end
    if self.ldY < -120 then
        move(self,0x4000,max(1,self.speed))
    else
        if t<260 then self.angle16=Core.turn16(self.angle16,aim(self),self.radius>80 and 0x30 or 0x80)
        elseif t>420 then self.angle16=Core.turn16(self.angle16,0xc000,0x100);self.speed=self.speed+0.03 end
        move(self)
    end
    if Core.inside(self.ldX,self.ldY,0) then
        self.seen=true
        local interval=Core.diff({100,72,54,42,32},d)+self.spawnType%7
        if t%interval==0 then
            local count=Core.diff({1,3,5,5,7},d)
            local behavior=({0,1,2,3,4,7,8,0x17})[(self.spawnType%8)+1]
            fan(self,self.spawnType%14,behavior,aim(self),Core.diff({4,5,6,7,8},d),count,min(24000,(count-1)*2200),1)
        end
    end
end

local function earlySpecific(self,rt)
    local id,t,d=self.spawnType,self.helperTimer,rt.difficulty
    if id==0x19 then
        if self.state==0 then if t==20 then self.ldX,self.ldY=Core.clampToPlayfield(self.ldX,self.ldY,20);activate(self,1.4,self.ldX<=20 and 0 or 0x8000) end;return true end
        local ox,oy=self.ldX,self.ldY
        if t<150 then self.angle16=Core.turn16(self.angle16,aim(self),0x80);self.speed=self.speed+0.02
        else self.angle16=Core.turn16(self.angle16,0xc000,0x100);self.speed=self.speed+0.1 end
        move(self)
        local start=Core.diff({36,30,24,20,16},d);local period=Core.diff({150,48,32,32,20},d)
        if t<150 and t>=start and (t-start)%period==0 and Core.inside(ox,oy+10,0) then
            local a=quantizeAngle(aim(self,ox,oy+10));local s=Core.diff({5.5,6.5,7.5,8,9.5},d)
            fire(self,5,0,a,s*1.1,1,0,0,ox,oy+10);fan(self,5,0,a,s,2,Core.diff({900,2800,4000,2500,2500},d),1,ox,oy+10)
            if d>=3 then fan(self,5,0,a,s*0.9,2,Core.diff({900,2800,4000,2500,2500},d)*2,1,ox,oy+10) end
        end
        return true
    elseif id==0x1a then
        if self.state==0 then
            if t==20 then
                activate(self,8.6,0x3b50+Core.frameRand(rt.frame+self.entityId)%0x961)
                self.secondaryAngle16=Core.randomAngle(rt.frame,0)
            end
            return true
        end
        if t<40 then self.angle16=Core.turn16(self.angle16,aim(self),0x80);self.speed=max(0.6,self.speed-0.2) else self.speed=self.speed+0.16 end
        move(self);self.secondaryAngle16=Core.angle16(self.secondaryAngle16+0x378)
        local px,py=playerLD();local start=Core.diff({18,14,12,12,8},d);local period=Core.diff({32,24,16,16,8},d)
        if t<90 and t>=start and (t-start)%period==0 and Core.inside(self.ldX,self.ldY,0) and Core.distance(self.ldX,self.ldY,px,py)>100 then
            local s=Core.diff({5.5,6.5,7.5,8,9.6},d);fire(self,0x0e,0,aim(self),s,1);if d>=3 then fire(self,0x0e,0,aim(self),s-2,1) end
        end
        return true
    elseif id==0x1b then
        if self.state==0 then if t==20 then activate(self,7,0x4000) end;return true end
        if t<=120 and self.speed>1.5 then self.speed=self.speed-0.1 end
        self.angle16=Core.turn16(self.angle16,aim(self),0x80);if t>=240 then self.speed=self.speed-0.1 end;move(self)
        if t>=24 and t<240 then
            local period=Core.diff({120,80,70,70,60},d);local q=(t-24)%period
            if q==0 then
                fan(self,5,0,aim(self,self.ldX,self.ldY+50),Core.diff({4,5,5.5,6,7.2},d),Core.diff({3,5,7,7,9},d),10000,1,self.ldX,self.ldY+50)
            elseif q==30 then self.secondaryAngle16=aim(self,self.ldX,self.ldY-50)
            elseif q>30 and q<60 and q%4==0 then
                self.secondaryAngle16=Core.turn16(self.secondaryAngle16,aim(self),0x30)
                local s=Core.diff({5,6,7,8,9},d);fire(self,0,0,self.secondaryAngle16,s,1,0,0,self.ldX,self.ldY-50)
                if d>=1 then fan(self,0,0,self.secondaryAngle16,s,2,1200,1,self.ldX,self.ldY-50) end
            end
        end
        return true
    elseif id==0x1c then
        if self.state==0 then if t==20 then activate(self,2.5,self.ldX<360 and 6000 or 0x6890) end;return true end
        self.angle16=Core.turn16(self.angle16,0xc000,0x14);move(self)
        if t>=45 and t<300 then
            local period=Core.diff({100,80,60,60,54},d);local q=(t-45)%period
            if q==0 then self.secondaryAngle16=aim(self) end
            if q<Core.diff({21,30,36,36,36},d) and q%3==0 then
                local s=Core.diff({5.5,6.5,8,9,10.5},d);fire(self,9,0,self.secondaryAngle16,s,1)
                if d>=3 then fire(self,9,0,self.secondaryAngle16-3500,s,1);fire(self,9,0,self.secondaryAngle16+3500,s,1) end
            end
            if t>=85 and (t-85)%period==0 then fan(self,4,0,aim(self),Core.diff({3.5,4.5,5,5,6.5},d),Core.diff({4,8,10,10,12},d),27000,1) end
        end
        return true
    elseif id==0x1d or id==0x1e then
        self.ldY=self.ldY+scrollDelta(rt)
        -- These scrolling enemies never reset their helper timer on entry.
        -- Their body animation and type 0x1e firing windows are measured from
        -- the original spawn frame even while they are still above the stage.
        if self.ldY>=0 then self.targetable=true end
        if self.targetable and self.ldY<400 then
            if id==0x1d then
                local period=Core.diff({90,50,40,30,20},d);local q=rt.frame%period
                if q==0 then self.secondaryAngle16=aim(self,self.ldX,self.ldY+30)+0x400 end
                if q==0 or q==3 or q==6 then
                    local a=Core.angle16(floor(self.secondaryAngle16/0x800)*0x800);local s=Core.diff({4.5,5.5,6.5,7,8},d)
                    fire(self,1,0,a,s,1);if d>2 then fire(self,1,0,a,s+1.8,1) end
                end
            else
                local period=Core.diff({140,100,80,80,50},d)
                local shotSpeed=Core.diff({5,6,7,8.5,9.5},d)
                if t>=80 then
                    local q=(t-80)%period
                    if q==0 then self.secondaryAngle16=aim(self,self.ldX,self.ldY-60) end
                    if q<48 and q%12==0 then
                        fire(self,0x0c,0,self.secondaryAngle16,shotSpeed,1)
                    end
                end
                if d>2 and t>=86 then
                    local q=(t-86)%period
                    if q<36 and q%12==0 then
                        fire(self,0x0c,0,self.secondaryAngle16-600,shotSpeed,1)
                        fire(self,0x0c,0,self.secondaryAngle16+600,shotSpeed,1)
                    end
                end
            end
        end
        if self.ldY>=760 then self.removeRequested=true end
        return true
    elseif id==0x1f then
        self.ldY=self.ldY+scrollDelta(rt)
        if self.state==0 and self.ldY>=-100 then self.state=1;self.helperTimer=-1 end
        if self.state==1 and t==50 then self.targetable=true end
        if self.state==1 and t>=50 and self.ldY<350 then
            local a=aim(self,self.ldX,self.ldY+70)
            if t%Core.diff({50,30,30,30,20},d)==0 then fan(self,3,1,a,Core.diff({3,3,4,4,5},d),Core.diff({1,3,5,5,5},d),18000,1,self.ldX,self.ldY+70) end
            local q=(t-60)%Core.diff({90,72,60,50,50},d)
            if t>=60 and q<32 and q%8==0 then
                local count=Core.diff({6,12,14,16,16},d);fan(self,4,0,t*300,Core.diff({4,4,4.5,5,7},d),count,0x10000,1,self.ldX,self.ldY-55)
                fan(self,4,0,-t*300,Core.diff({4,4,4.5,5,7},d)+1,count,0x10000,1,self.ldX,self.ldY-55)
            end
        end
        if self.ldY>=820 then self.removeRequested=true end
        return true
    elseif id==0x25 then
        if self.state==0 then
            if not self.baseX then self.baseX,self.baseY=self.ldX,self.ldY end
            self.ldX=self.baseX+sin((rt.frame-self.entityId*55)*2*pi/320)*100
            if t==20 then self.ldX,self.ldY=Core.clampToPlayfield(self.ldX,self.ldY,20);self.baseX,self.baseY=self.ldX,self.ldY;activate(self,2,0x4000) end
            return true
        end
        if t<180 then
            self.angle16=Core.turn16(self.angle16,Core.aim16(self.baseX,self.baseY,playerLD()),0x40)
            local dx,dy=Core.polar(self.angle16,self.speed);self.baseX,self.baseY=self.baseX+dx,self.baseY+dy
            self.ldX=self.baseX+sin((rt.frame-self.entityId*55)*2*pi/320)*100;self.ldY=self.baseY
        else self.angle16=Core.turn16(self.angle16,0xc000,0xa0);self.speed=self.speed+0.1;move(self) end
        if t<180 and Core.inside(self.ldX,self.ldY,0) then
            local start=Core.diff({24,18,15,15,15},d);local period=Core.diff({120,80,70,60,50},d);local q=(t-start)%period
            if t>=start then
                if q==0 then self.secondaryAngle16=aim(self) end
                if q<30 and q%5==0 then
                    local s=Core.diff({6,7,8,8.8,10.8},d);fire(self,7,0,self.secondaryAngle16,s,1,0,0,self.ldX-20,self.ldY);fire(self,7,0,self.secondaryAngle16,s,1,0,0,self.ldX+20,self.ldY)
                end
            end
        end
        return true
    elseif id==0x26 or id==0x2b then
        local large=id==0x2b;local stop=large and 300 or 210
        if self.state==0 then if t==20 then activate(self,large and 7 or 6,0x4000) end;return true end
        if t<stop then
            if t<=120 and self.speed>(large and 0.8 or 1.5) then self.speed=self.speed-0.1 end
            self.angle16=Core.turn16(self.angle16,aim(self),0x40)
        else self.angle16=Core.turn16(self.angle16,0xc000,0xa0);self.speed=self.speed+0.1 end
        move(self)
        if large and t>=40 and t<300 then
            local interval=Core.diff({18,14,12,12,10},d)
            if t%interval==0 then fan(self,9,0,(t%244)*270,Core.diff({4.5,5.8,6.5,6.5,8},d),Core.diff({2,3,5,5,7},d),(Core.diff({2,3,5,5,7},d)-1)*0xc80,1) end
            local half=Core.diff({55,40,32,26,20},d);if (t-50)%half==0 then fan(self,4,0,aim(self)+(floor((t-50)/half)%2)*0x8000,4+t*0.005,Core.diff({7,13,15,15,17},d),0x8000,1) end
        elseif not large and t>=24 and t<210 then
            local period=Core.diff({110,70,60,60,60},d);local q=(t-24)%period
            if q==0 then self.secondaryAngle16=aim(self) end
            if q<24 and q%4==0 then
                local s=Core.diff({6,7,8,8,9.5},d);fire(self,7,0,self.secondaryAngle16,s,1,0,0,self.ldX-45,self.ldY);fire(self,7,0,self.secondaryAngle16,s,1,0,0,self.ldX+45,self.ldY)
            end
        end
        return true
    elseif id==0x27 or id==0x29 then
        if self.state==0 then
            if not self.destX then self.destX,self.destY=self.ldX,self.ldY;self.ldX,self.ldY=(self.destX<360 and -100 or 820),-100 end
            if t==20 then
                self.angle16=Core.aim16(self.ldX,self.ldY,self.destX,self.destY);activate(self,id==0x27 and 11.5 or 12,self.angle16)
                local offsets=id==0x27 and {{-50,-90},{50,-90},{-100,-50},{100,-50}} or {{-30,80},{30,80},{-70,40},{70,40}}
                for i=1,(d==0 and 2 or 4) do rt:spawnChild(self,id==0x27 and 0x28 or 0x2a,99999999,self.ldX+offsets[i][1],self.ldY+offsets[i][2],"S03 satellite") end
            end
            return true
        end
        if t<60 then self.speed=max(id==0x27 and 2.5 or 3,self.speed-0.15)
        elseif t<240 then
            if t%50==0 then self.targetX=120+Core.frameRand(rt.frame+self.entityId)%481;self.targetY=t+Core.frameRand(rt.frame+0x457)%101 end
        else self.targetX,self.targetY=360,-500;self.speed=self.speed+0.1 end
        self.angle16=Core.turn16(self.angle16,Core.aim16(self.ldX,self.ldY,self.targetX or self.destX,self.targetY or self.destY),0x200);move(self)
        if id==0x27 and t>=60 and t<240 and (t-60)%Core.diff({160,120,90,90,90},d)==0 then
            local s=Core.diff({4.5,6.5,7.5,8,9.5},d);fan(self,3,0,aim(self),s,Core.diff({3,5,7,7,9},d),20000,1);fan(self,2,9,aim(self),s+3,max(1,Core.diff({3,5,7,7,9},d)-1),18000,1)
        end
        return true
    elseif id==0x2c or id==0x2d then
        self.ldY=self.ldY+scrollDelta(rt)
        local ready=id==0x2c and 40 or 60
        if self.state==0 and self.ldY>=(id==0x2c and -40 or -100) then self.state=1;self.helperTimer=-1 end
        self.angle16=Core.turn16(self.angle16,aim(self),0x40)
        if self.state==1 and t==ready then self.targetable=true end
        if self.targetable and self.ldY<350 then
            if id==0x2c and t%Core.diff({60,36,28,24,18},d)==0 then
                local ox,oy=Core.polar(self.angle16,77);local x,y=self.ldX+ox,self.ldY+oy;local s=Core.diff({4.5,5.5,6,6.5,8.5},d);fire(self,6,0,self.angle16,s,1,0,0,x,y);fire(self,6,0,self.angle16,s+0.3,1,0,0,x,y)
            elseif id==0x2d then
                local period=Core.diff({120,80,70,60,45},d);local q=t%period
                if q<Core.diff({16,20,24,24,24},d) and q%4==0 then
                    local s=Core.diff({5.5,6.5,7.5,8,10},d);fan(self,7,0,aim(self),s,Core.diff({1,1,2,2,2},d),0x578,1,self.ldX-70,self.ldY);fan(self,7,0,aim(self),s,Core.diff({1,1,2,2,2},d),0x578,1,self.ldX+70,self.ldY)
                end
            end
        end
        if self.ldY>=(id==0x2c and 800 or 900) then self.removeRequested=true end
        return true
    elseif id==0x35 then
        if self.state==0 then
            if t==20 then
                local entryAngle=self.angle16
                if self.originX<=0 then entryAngle=0
                elseif self.originX>=720 then entryAngle=0x8000 end
                activate(self,12,entryAngle)
            end
            return true
        end
        local oldX,oldY=self.ldX,self.ldY;local turn=(t>=45 and t<=64) and 1300 or 60
        if (self.originX<=0 and self.originY>=300) or
           (self.originX>=720 and self.originY<300) then turn=-turn end
        self.angle16=Core.angle16(self.angle16+turn);move(self)
        if t<200 and Core.inside(oldX,oldY,0) and Core.inside(self.ldX,self.ldY,0) and rt.frame%Core.diff({42,16,10,10,8},d)==0 then local s=Core.diff({5,6,7,7,9},d);fire(self,6,0,aim(self,oldX,oldY+20),s,1,0,0,oldX,oldY+20);if d>2 then fire(self,6,0,aim(self),s+2.2,1) end end
        return true
    elseif id==0x36 then
        if self.state==0 then
            if t==20 then
                local randomPart=Core.frameRand(rt.frame)%5001
                local entryAngle=self.angle16
                if self.originX<=0 then entryAngle=-randomPart-9000
                elseif self.originX>=720 then entryAngle=randomPart-23768 end
                self.ldX,self.ldY=Core.clampToPlayfield(self.ldX,self.ldY,20)
                self.state=1
                self.helperTimer=-1
                self.speed=15
                self.angle16=Core.angle16(entryAngle)
            end
            return true
        end
        if t<80 then self.angle16=Core.turn16(self.angle16,aim(self),floor(sin(t*pi/160)*700));self.speed=max(1,self.speed-0.18)
        elseif t<=200 then self.angle16=Core.turn16(self.angle16,aim(self),0x80);self.targetable=true
        else self.angle16=Core.turn16(self.angle16,0xc000,200);self.speed=self.speed+0.1 end;move(self)
        if t>=80 and t<200 and t%Core.diff({60,40,30,24,16},d)==0 then local a=quantizeAngle(aim(self));local s=Core.diff({4,5.2,6.5,7.5,9},d);fire(self,4,0,a-200,s,1);fire(self,4,0,a+200,s,1);fire(self,4,0,a,s+0.3,1) end
        return true
    elseif id==0x37 then
        if not self.pulseAngle then
            self.pulseAngle=Core.angle16(Core.frameRand(rt.frame)%4001-0x47d0)
        end
        local base=8*min(1,t/120);self.speed=base-sin((t%30)*pi/60)*base;self.angle16=self.pulseAngle;move(self)
        self._ldVisualAngle16=Core.angle16(self.angle16+
            (floor(t/30)%2==0 and 0x0d05 or -0x0d05))
        if self.state==0 and t>=120 then activate(self,self.speed,self.angle16) end
        if self.state==1 and t>=10 then local period=Core.diff({100,60,50,40,32},d);local q=(t-10)%period;if q==0 then self.secondaryAngle16=aim(self) end;if q<24 and q%Core.diff({10,7,5,4,4},d)==0 then local spread=Core.diff({600,800,1000,1200,1400},d);local a=self.secondaryAngle16+floor((Core.randomUnit(rt.frame,self.entityId)*2-1)*spread);fire(self,0,0,a,Core.diff({4.2,5.2,6,6,7.5},d),1);self.secondaryAngle16=Core.turn16(self.secondaryAngle16,aim(self),0x80) end end
        return true
    elseif id==0x38 then
        if self.state==0 then if t==20 then activate(self,7,0x4000) end;return true end
        if t<=120 and self.speed>1.2 then self.speed=self.speed-0.1 end;self.angle16=Core.turn16(self.angle16,aim(self),0x80);if t>=290 then self.speed=self.speed-0.1 end;move(self)
        if t>=24 and t<=289 then local q=(t-24)%120;if q==0 or q==40 then self.secondaryAngle16=aim(self) end;if q<Core.diff({16,24,28,32,36},d) and q%4==0 then local count=q/4+1;fan(self,9,0,self.secondaryAngle16,Core.diff({6,7,7.5,10,11},d),count,(count-1)*Core.diff({320,320,350,450,600},d),1) elseif q>=40 and q<=69 and q%4==0 then fan(self,8,0,self.secondaryAngle16,Core.diff({6,7,7.5,10,11},d)+(q-40)*0.1+1,Core.diff({3,5,7,7,9},d),20000,1) end;self.secondaryAngle16=Core.turn16(self.secondaryAngle16,aim(self),0x20) end
        return true
    elseif id==0x39 or id==0x3a then
        if self.state==0 then
            if t==20 then
                activate(self,2,id==0x39 and 0x4000 or
                    (self.originX<=360 and 0xe4a8 or 0x9b58))
            end
            return true
        end
        local turn
        if id==0x39 then turn=t<120 and 20 or (t<180 and 100 or 40)
        else turn=t<210 and -80 or 60 end
        if self.originX<=360 then turn=-turn end
        self.angle16=Core.angle16(self.angle16+turn);move(self)
        if t%Core.diff({100,70,60,60,40},d)==0 then fan(self,3,1,aim(self),1.2,Core.diff({5,7,9,7,9},d),22000,1) end
        if t>=40 and t<=320 and t%40==0 then rt:spawnChild(self,0x3b,99999999,self.ldX,self.ldY,"S04 carrier segment") elseif t==360 then rt:spawnChild(self,0x3c,99999999,self.ldX,self.ldY,"S04 carrier end") end
        return true
    elseif id==0x3d then
        if self.state==0 then
            if t==0 then for i,o in ipairs({{-148,-80},{-95,-105},{113,-110}}) do local c=rt:spawnChild(self,0x3e,99999999,self.ldX+o[1],self.ldY+o[2],"S04 turret");if c then c._ldIndex=i end end end
            if t==20 then activate(self,2.5,self.ldX<360 and 2000 or 0x7830) end;return true
        end
        move(self);local half=Core.diff({100,80,50,60,50},d);local q=(t-32)%(half*2);local a=aim(self);local s=Core.diff({3.2,3.6,4,5,6.5},d);local count=Core.diff({5,7,9,9,9},d)
        if q==0 then for _,off in ipairs({0,-7000,7000}) do fan(self,5,0,a+off,s,count,9000,1) end elseif q==half then fan(self,5,0,a-3500,s,count,9000,1);fan(self,5,0,a+3500,s,count,9000,1) end
        return true
    end
    return false
end

local function controller(self,rt)
    local t=self.helperTimer
    if self.state==0 then
        if t==0 and self.spawnType==0x10 then
            for i,off in ipairs({{160,40},{-160,40},{270,-20},{-270,-20}}) do
                if rt.stage==1 or i<=2 then
                    local child=rt:spawnChild(self,0x11,7000,self.ldX+off[1],self.ldY+off[2],"0x10 turret")
                    if child then child._ldIndex=i end
                end
            end
		elseif t==0 and self.spawnType==0x20 then
			for _,p in ipairs({{420,320},{235,260},{570,210},{125,120},{620,60}}) do
				rt:spawnChild(self,0x21,5000,p[1],self.ldY+p[2],"0x20 turret")
			end
		elseif t==0 and self.spawnType==0x2e then
			rt:spawnChild(self,0x2f,self.hp,self.ldX,self.ldY+240,"0x2e shared hitbox")
        end
        if t<90 then self.ldY=self.originY+1000-sin(t*pi/180)*1000 else self.ldY=self.originY end
		self.originY=self.originY+1
        if t==120 then activate(self,0.7,0) end
        return
    end
    if t%50==0 then
        self.targetX=200+Core.frameRand(rt.frame+self.entityId)%321
        self.targetY=140+Core.frameRand(rt.frame+self.entityId+0x457)%121
    end
    self.angle16=Core.turn16(self.angle16,Core.aim16(self.ldX,self.ldY,self.targetX or 360,self.targetY or 200),0x200)
    move(self)
    if t%Core.diff({90,60,45,36,30},rt.difficulty)==0 then
        fan(self,8,(self.spawnType+t)%5,aim(self),5.5,Core.diff({5,7,9,11,13},rt.difficulty),0x10000,1)
    end
    self.countdown=self.countdown-1
    if self.countdown<=0 then self.deadRequested=true end
end

local function childUpdate(self,rt)
    local parent=self.parent
	if not parent or not parent.active or parent.hp<1 or parent.state==2 then
		self.removeRequested=true
		return
	end
    local tx=parent.ldX+(self.offsetX or self.originX-parent.originX)
    local ty=parent.ldY+(self.offsetY or self.originY-parent.originY)
	local divisor=(self.spawnType==0x28 or self.spawnType==0x2a) and 8 or
		(self.spawnType==0x2f and 7 or 20)
    self.ldX=self.ldX+(tx-self.ldX)/divisor
    self.ldY=self.ldY+(ty-self.ldY)/divisor
    if self.helperTimer==120 then self.targetable=true end
	if self.spawnType==0x28 or self.spawnType==0x2a then
		self.targetable=false
		local pt=parent.helperTimer
		if pt<240 then
			local period=self.spawnType==0x28 and Core.diff({160,120,90,90,90},rt.difficulty)
				or Core.diff({90,60,50,50,40},rt.difficulty)
			local start=self.spawnType==0x28 and 100 or 75
			local q=(pt-start)%period
			if pt>=start and q< (self.spawnType==0x28 and 40 or 30) and q%5==0 then
				local a=aim(self)+((self._ldIndex or self.entityId)%4-1.5)*700
				local s=self.spawnType==0x28 and Core.diff({5,6,6.5,6.5,8},rt.difficulty)
					or Core.diff({5.6,6.5,7,6.5,8},rt.difficulty)
				fire(self,self.spawnType==0x28 and 9 or 7,0,a,s+q*0.08,1)
			end
		end
		return
	elseif self.spawnType==0x3b or self.spawnType==0x3c then
		self.targetable=true
		if self.spawnType==0x3b and parent.helperTimer%Core.diff({88,55,47,41,31},rt.difficulty)==0 then
			local s=Core.diff({4.5,5,5.5,6,7.7},rt.difficulty);fire(self,8,0,aim(self),s,1)
		end
		self.hp=min(self.hp,parent.hp);parent.hp=min(parent.hp,self.hp)
		return
	elseif self.spawnType==0x3e then
		self.targetable=false
		self.angle16=Core.turn16(self.angle16,aim(self),max(0x30,floor(math.abs(Core.angleDelta(self.angle16,aim(self)))/10)+0x30))
		local phase=30+(parent.entityId-self.entityId)*12
		if self.helperTimer>=phase and (self.helperTimer-phase)%Core.diff({95,60,45,38,27},rt.difficulty)==0 then
			local s=Core.diff({4.6,5.5,6,5.5,7},rt.difficulty);fire(self,6,0,self.angle16,s,1);fire(self,6,0,self.angle16,s+0.4,1)
		end
		return
	elseif self.spawnType==0x2f then
		if self.helperTimer==120 then self.hp=parent.hp;self.maxhp=parent.maxhp;self.targetable=true end
		if self.targetable then self.hp=min(self.hp,parent.hp);parent.hp=min(parent.hp,self.hp) end
	end
    if self.targetable then
        self.angle16=Core.turn16(self.angle16,aim(self),max(1,floor(math.abs(Core.angleDelta(self.angle16,aim(self)))/20)+1))
        if self.helperTimer%Core.diff({60,32,24,20,16},rt.difficulty)==0 then
            fire(self,7,0,self.angle16,Core.diff({3.5,4.5,5,5,6.5},rt.difficulty),1)
        end
    end
end

local function bossPattern(self,rt)
    local p,t,d=self.phaseIndex or max(0,(self.scenePhase or 1)-1),self.helperTimer,rt.difficulty
    local a=aim(self)
    local mode=p%10
    if mode==0 then
        if t%Core.diff({36,24,18,15,12},d)==0 then fan(self,3,0,a,6+p*0.15,Core.diff({5,7,9,11,13},d),16000,1) end
    elseif mode==1 then
        if t%Core.diff({24,16,12,10,9},d)==0 then fan(self,8,1,t*333,3.5+p*0.1,Core.diff({11,15,19,21,25},d),0x10000,1) end
    elseif mode==2 then
        if t%20==0 then
            fan(self,2,0x26,t*240,4.5,Core.diff({3,5,7,7,9},d),14000,1)
            fan(self,3,0x27,-t*240,4.5,Core.diff({3,5,7,7,9},d),14000,1)
        end
    elseif mode==3 then
        if t%45==0 then fan(self,2,0x17,a,5,Core.diff({5,7,9,11,13},d),18000,1) end
        if t%180==0 then fire(self,8,0x18,t*100,2,1);fire(self,9,0x19,-t*100,2,1) end
    elseif mode==4 then
        if t%Core.diff({60,42,30,24,20},d)==0 then fan(self,10,8,a,7,Core.diff({5,7,9,11,13},d),22000,1) end
    elseif mode==5 then
        if t%120==0 then
            fan(self,4,0x1f,t*80,0,Core.diff({7,9,11,13,15},d),0x10000,1)
            fan(self,5,0x20,-t*80,0,Core.diff({7,9,11,13,15},d),0x10000,1)
        end
    elseif mode==6 then
        if t%Core.diff({18,12,9,8,7},d)==0 then
            fire(self,8,0x29,t*270,3,1);fire(self,9,0x2a,-t*270,3,1)
        end
    elseif mode==7 then
        if t%90==0 then fan(self,0x0c,0x2b,a,3,Core.diff({3,5,7,9,11},d),12000,1) end
    elseif mode==8 then
        if t%6==0 then fire(self,4,0x35,t*180,5,1);fire(self,5,0x36,-t*180,5,1) end
    else
        if t%150==0 then
            local count=Core.diff({7,9,11,13,15},d)
            Projectile.spread(10,0x3a,self.ldX,self.ldY,0x4000,120,0,1,count,0x10000,0)
            Projectile.spread(10,0x3b,self.ldX,self.ldY,0x4000,120,0,1,count,0x10000,0)
        end
    end
end

local function openBossPhase(self,index)
    self.phaseIndex=index
    self.hp=self.phaseHp[index+1]
    self.maxhp=self.hp
    self.countdown=self.phaseTimes[index+1]
    self.state=index*10+1
    self.helperTimer=-1
    self.targetable=true
    self.protect=false
end

local function bossBreak(self,rt)
    Projectile.clear()
    local p=rawget(_G,"player")
    if p then p.invulnerableFrames=max(p.invulnerableFrames or 0,100) end
    if self.phaseIndex+1<#self.phaseHp then
        self.transition=180+((self.phaseIndex%2)*20)
        self.nextPhase=self.phaseIndex+1
        self.targetable=false
        self.protect=true
        self.state=(self.phaseIndex+1)*10
        self.helperTimer=-1
    else
        self.dying=0
        self.targetable=false
        self.protect=true
        self.state=200
        if p then p.invulnerableFrames=max(p.invulnerableFrames or 0,360) end
    end
end

local function finalBoss(self,rt)
    if self.dying then
        self.dying=self.dying+1
        self.ldY=self.ldY+self.dying*0.01
        if self.dying>=240 then
            self.active=false;Del(self);rt.gate=false;rt.complete=true
        end
        return
    end
    if self.transition then
        self.transition=self.transition-1
        if self.transition<=0 then self.transition=nil;openBossPhase(self,self.nextPhase) end
        return
    end
    if self.intro>0 then
        self.intro=self.intro-1
        self.ldY=self.ldY+(self.targetY-self.ldY)/12
        if self.intro==0 then openBossPhase(self,0) end
        return
    end
    if rt.frame%50==0 then
        self.targetX=210+Core.frameRand(rt.frame+self.entityId)%301
        self.targetY=150+Core.frameRand(rt.frame+rt.stage*0x457)%101
    end
    local ta=Core.aim16(self.ldX,self.ldY,self.targetX,self.targetY)
    self.angle16=Core.turn16(self.angle16,ta,0x200)
    move(self,self.angle16,self.spawnType==0x13e and 0.2 or 0.3)
    bossPattern(self,rt)
    self.countdown=self.countdown-1
    if self.hp<=0 or self.countdown<=0 then bossBreak(self,rt) end
    rt.bossState=self.state;rt.bossTimer=self.helperTimer;rt.boss=self
    if rt.stage==8 then rt.stage08BossState=self.state;rt.stage08BossTimer=self.helperTimer end
    if rt.stage==9 then rt.stage09BossState=self.state;rt.stage09BossTimer=self.helperTimer end
end

local function sceneBoss(self,rt)
    local f=rt.frame
    if self.dying then
        self.dying=self.dying+1
        if self.dying>=240 then
            rt:spawn(0x141,100000,360,320,"Stage 10 final boss handoff")
            self.active=false;Del(self)
        end
        return
    end
    if self.sceneTransition then
        self.sceneTransition=self.sceneTransition-1
        if self.sceneTransition<=0 then
            self.sceneTransition=nil
            self.scenePhase=self.scenePhase+1
            self.hp=self.scenePhase==3 and 66000 or 55000
            self.maxhp=self.hp;self.countdown=self.scenePhase==3 and 1800 or 1500
            self.targetable=true;self.helperTimer=-1
        end
    elseif self.scenePhase and self.scenePhase>0 then
        bossPattern(self,rt)
        self.countdown=self.countdown-1
        if self.hp<=0 or self.countdown<=0 then
            Projectile.clear();self.targetable=false
            if self.scenePhase>=3 then self.dying=0 else self.sceneTransition=120 end
        end
    end
    local tx,ty=360,-2400
    if f>=1200 and f<4700 then ty=-2400+sin((f-1200)*pi/7000)*1800
    elseif f<9100 then tx=360+sin((f-4700)*pi/2200)*300;ty=-600+(f-4700)*0.12
    elseif f<12000 then ty=-72+(f-9100)*0.075 else ty=150 end
    self.ldX=self.ldX+(tx-self.ldX)/5+sin(f*pi/180)*0.3
    self.ldY=self.ldY+(ty-self.ldY)/5+sin(f*pi/240)*0.2
    if f==11900 then self.scenePhase=1;self.hp=55000;self.maxhp=55000;self.countdown=1500 end
    if f==12000 and self.scenePhase==1 then self.targetable=true;self.helperTimer=-1 end
    rt.bossState=self.scenePhase or 0;rt.bossTimer=self.helperTimer;rt.boss=self
end

local EnemyBehaviorDispatcher={}
EnemyBehaviorDispatcher.__index=EnemyBehaviorDispatcher
M.BehaviorDispatcher=EnemyBehaviorDispatcher

function EnemyBehaviorDispatcher.new()
	return setmetatable({},EnemyBehaviorDispatcher)
end

function EnemyBehaviorDispatcher:updateExactBoss(enemy,rt)
	return (LikeDreamer.BossEarly and LikeDreamer.BossEarly.update and
		LikeDreamer.BossEarly.update(enemy,rt)) or
		(LikeDreamer.BossMiddle and LikeDreamer.BossMiddle.update and
		LikeDreamer.BossMiddle.update(enemy,rt)) or
		(LikeDreamer.BossLate and LikeDreamer.BossLate.update and
		LikeDreamer.BossLate.update(enemy,rt))
end

function EnemyBehaviorDispatcher:updateFallback(enemy,rt)
	if enemy.spawnType==0x09 then
		helpSatellite(enemy)
	elseif enemy.parent then
		childUpdate(enemy,rt)
	elseif isMidboss(enemy.spawnType) or
		(gateOwners[rt.stage] and gateOwners[rt.stage][enemy.spawnType]) then
		controller(enemy,rt)
	elseif enemy.spawnType>=0x06 and enemy.spawnType<=0x08 then
		commonMarker(enemy,rt)
	elseif enemy.spawnType==0x0a then
		type0A(enemy,rt)
	elseif enemy.spawnType==0x0b then
		type0BOrC(enemy,rt,false)
	elseif enemy.spawnType==0x0c then
		type0BOrC(enemy,rt,true)
	elseif enemy.spawnType==0x0d then
		type0D(enemy,rt)
	elseif enemy.spawnType==0x0e then
		type0E(enemy,rt)
	elseif enemy.spawnType==0x0f then
		type0F(enemy,rt)
	elseif not earlySpecific(enemy,rt) then
		genericEnemy(enemy,rt)
	end
end

function EnemyBehaviorDispatcher:update(enemy,rt)
	if self:updateExactBoss(enemy,rt) then
		return
	elseif enemy.spawnType==0x14c then
		sceneBoss(enemy,rt)
		return
	elseif isFinalBoss(enemy.spawnType) then
		finalBoss(enemy,rt)
		return
	elseif LikeDreamer.LateEnemy and LikeDreamer.LateEnemy.update and
		LikeDreamer.LateEnemy.update(enemy,rt) then
		return
	end
	self:updateFallback(enemy,rt)
end

local EnemyVisualDispatcher={}
EnemyVisualDispatcher.__index=EnemyVisualDispatcher
M.VisualDispatcher=EnemyVisualDispatcher

function EnemyVisualDispatcher.new()
	return setmetatable({},EnemyVisualDispatcher)
end

function EnemyVisualDispatcher:renderBoss(enemy)
	return (LikeDreamer.BossEarly and LikeDreamer.BossEarly.render and
		LikeDreamer.BossEarly.render(enemy)) or
		(LikeDreamer.BossMiddle and LikeDreamer.BossMiddle.render and
		LikeDreamer.BossMiddle.render(enemy)) or
		(LikeDreamer.BossLate and LikeDreamer.BossLate.render and
		LikeDreamer.BossLate.render(enemy))
end

function EnemyVisualDispatcher:renderBody(enemy)
	return (LikeDreamer.EnemyVisualStage01 and
		LikeDreamer.EnemyVisualStage01.render and
		LikeDreamer.EnemyVisualStage01.render(enemy)) or
		(LikeDreamer.EnemyVisualEarly and
		LikeDreamer.EnemyVisualEarly.render and
		LikeDreamer.EnemyVisualEarly.render(enemy)) or
		(LikeDreamer.EnemyVisualMid and
		LikeDreamer.EnemyVisualMid.render and
		LikeDreamer.EnemyVisualMid.render(enemy)) or
		(LikeDreamer.EnemyVisualLate and
		LikeDreamer.EnemyVisualLate.render and
		LikeDreamer.EnemyVisualLate.render(enemy))
end

local behaviorDispatcher=EnemyBehaviorDispatcher.new()
local visualDispatcher=EnemyVisualDispatcher.new()
M.behaviorDispatcher=behaviorDispatcher
M.visualDispatcher=visualDispatcher

local damageable = Class(object)
function damageable:take_damage(damage)
    if self.targetable and not self.protect then
        -- 原作双发主炮每五帧造成 2×130，宿主双发主炮每四帧造成 2×2。
        self.hp = self.hp - damage*52
    end
end
local enemyClass=Class(damageable)
M.Class=enemyClass

function enemyClass:init(rt,typeId,hp,x,y,note,parent)
    self.runtime=rt;self.spawnType=typeId;self.sourceNote=note
    self.entityId=rt.nextEntityId;rt.nextEntityId=rt.nextEntityId+1
    self.ldX,self.ldY=x,y;self.originX,self.originY=x,y
    self.hp=hp;self.maxhp=hp;self.radius=40;self.visualFrame=typeId%120;self.sheet="s"
    local spec=earlySpecs[typeId]
    if spec then
        self.radius,self.visualFrame,self.sheet=spec[1],spec[2],spec[3]
        if spec[4] then self.ldY=spec[4];self.originY=spec[4] end
    end
    local lateSpec=lateSpecs[typeId]
    if lateSpec then
        self.radius=lateSpec.radius
        self.updateCase=lateSpec.updateCase
        if lateSpec.forcedY then
            self.ldY=lateSpec.forcedY;self.originY=lateSpec.forcedY
        end
    end
    if bossSpecs[typeId] then
        local b=bossSpecs[typeId];self.radius=b[1];self.phaseHp=b[2];self.phaseTimes=b[3]
        self.sheet="boss";self.visualFrame=0;self.intro=typeId==0x141 and 260 or 240
        self.targetX,self.targetY=360,200;self.phaseIndex=0
    elseif typeId==0x14c then
        self.radius=200;self.sheet="xl";self.visualFrame=0;self.scenePhase=0
    elseif isMidboss(typeId) then
        self.radius=({[0x143]=80,[0x144]=50,[0x145]=50,[0x146]=160,[0x147]=220,
            [0x148]=150,[0x149]=200,[0x14a]=175,[0x14b]=175})[typeId] or 100
        self.sheet="boss";self.visualFrame=(typeId-0x143)*3;self.countdown=1800
    end
	if gateOwners[rt.stage] and gateOwners[rt.stage][typeId] and not self.countdown then
		self.countdown=1800
	end
    self.state=0;self.age=0;self.helperTimer=0;self.speed=1
    self.angle16=(typeId==0x2c or typeId==0x2d) and 0xc000 or 0x4000
    self.secondaryAngle16=self.angle16;self.targetAngle16=self.angle16
    self.targetable=false;self.protect=false;self.active=true;self.seen=false
    self.IsBoss=isFinalBoss(typeId) or isMidboss(typeId) or typeId==0x14c
    self.parent=parent;self.parentEntityId=parent and parent.entityId or 0
    self.parentSpawnType=parent and parent.spawnType or 0
	if Reward then Reward.configureEnemy(self) end
    self.group=GROUP_ENEMY;self.layer=LAYER_ENEMY;self.bound=false;self.rect=false
    setImage(self);sync(self)
    rt.enemiesById[self.entityId]=self;rt.enemyCount=rt.enemyCount+1
end

function enemyClass:colli(other)
    if other and other.class==LikeDreamer.PlayerShot then
        return LikeDreamer.PlayerShot.hit(other,self)
    end
    if self.targetable and not self.protect and other and other.dmg then
        local damage = other.dmg
        damageable.take_damage(self,GameDrops and GameDrops.damage(damage,other) or damage)
        other.killerenemy = self
        if not other.killflag then Kill(other) end
    end
end

function enemyClass:release()
    if self._released then return end
    self._released=true
    local rt=self.runtime
    if rt then rt.enemiesById[self.entityId]=nil;rt.enemyCount=max(0,rt.enemyCount-1) end
end
function enemyClass:del() enemyClass.release(self) end
function enemyClass:kill() enemyClass.release(self) end

function enemyClass:die(silent)
    if not self.active then return end
    self.active=false;self.targetable=false;Del(self)
	if gateOwners[self.runtime.stage] and gateOwners[self.runtime.stage][self.spawnType] then
		self.runtime.gate=false
	end
	if not silent then
		if Reward and Reward.onEnemyDeath then
			Reward.onEnemyDeath(self)
		else
			play(self.radius>=100 and "ld_se_EnemyDown3" or "ld_se_EnemyDown1",0.45)
		end
	end
end

function enemyClass:frame()
	if not self.active then return end
	local rt=self.runtime
	if self._ldDeferredDeath and Reward and Reward.updateDeferredEnemyDeath then
		local drawTimer=self.helperTimer
		local finished=Reward.updateDeferredEnemyDeath(self)
		self._ldDrawState=self.state
		self._ldDrawTimer=drawTimer
		self._ldSourceFrame=max(0,(rt.frame or 0)-1)
		if self._ldDrawBody==nil then self._ldDrawBody=true end
		if finished then enemyClass.die(self,true);return end
		self.age=self.age+1
		setImage(self);sync(self)
		return
	end
	behaviorDispatcher:update(self,rt)

    self._ldDrawState=self.state
    self._ldDrawTimer=self.helperTimer
    self._ldSourceFrame=max(0,(rt.frame or 0)-1)
    if self._ldDrawBody==nil then self._ldDrawBody=true end

	if self.deadRequested or (self.hp<=0 and not isFinalBoss(self.spawnType) and self.spawnType~=0x14c) then
		if Reward and Reward.beginDeferredEnemyDeath and
			Reward.beginDeferredEnemyDeath(self) then
			setImage(self);sync(self);return
		end
		enemyClass.die(self, false);return
    elseif self.removeRequested then enemyClass.die(self, true);return end
	if self.targetable then
		self.targetableTimer=(self.targetableTimer or 0)+1
	end
    self.age=self.age+1;self.helperTimer=self.helperTimer+1
	if Core.inside(self.ldX,self.ldY,0) then self.seen=true end
    if self.seen and not Core.inside(self.ldX,self.ldY,360) and not isFinalBoss(self.spawnType) and not isMidboss(self.spawnType) then
        enemyClass.die(self, true);return
    end
    setImage(self);sync(self)
end

function enemyClass:render()
    if not self.active then return end
    if visualDispatcher:renderBoss(self) then
        return
    end
    local rendered=visualDispatcher:renderBody(self)
    local s=1
    if not rendered then
        if self.sheet=="s" then s=s*0.55 elseif self.sheet=="m" then s=s*0.42 end
        if self.spawnType==0x13e then
            Render("ld_boss_"..tostring((self.phaseIndex*6)%160+1),self.x-50*Core.worldScale(),self.y,0,s,s)
            Render("ld_boss_"..tostring((self.phaseIndex*6+3)%160+1),self.x+50*Core.worldScale(),self.y,0,-s,s)
        else
            Render(self.img,self.x,self.y,Core.angleToDeg(self.angle16)+90,s,s)
        end
    end
    if self.targetable and self.maxhp and self.maxhp>0 and self.radius>=80 then
        local gauge=self.radius>=130 and "ld_boss_gauge_1" or "ld_enemy_gauge_1"
        if lstg.CheckRes(2,gauge) then Render(gauge,self.x,self.y+self.radius*Core.worldScaleY()*0.55,0,0.6,0.6) end
    end
end

local Runtime={}
Runtime.__index=Runtime
M.Runtime=Runtime

local timeWindowHudClass=Class(object)
M.TimeWindowHudClass=timeWindowHudClass

local function timeWindowViewport()
	local world=lstg.world or {}
	local left=world.scrr or 416
	local top=world.scrt or 464
	local uiWidth=(rawget(_G,"screen") and screen.width) or 640
	local sx=max(0,uiWidth-left)/340
	local sy=((world.scrt or 464)-(world.scrb or 16))/720
	return left,top,sx,sy
end

local function drawTimeWindowFrame(frame,x,y,scale,left,top,sx,sy)
	local image="ld_num_s_"..tostring(frame+1)
	if not lstg.CheckRes(2,image) then return end
	Render(image,left+(x-940)*sx,top-y*sy,0,scale*sx,scale*sy)
end

local function drawTimeWindowTime(sourceFrames,x,y,scale,left,top,sx,sy)
	local remaining=max(0,floor(sourceFrames or 0))
	local displaySeconds=remaining>=60
	local step=16*scale
	local function drawRightAligned(value,rightX)
		value=max(0,floor(value))
		repeat
			drawTimeWindowFrame(value%10,rightX,y,scale,left,top,sx,sy)
			rightX=rightX-step
			value=floor(value/10)
		until value==0
	end
	if remaining>=3600 then
		local minutes=min(floor(remaining/3600),99)
		drawRightAligned(minutes,x+step*2)
		drawTimeWindowFrame(13,x+step*3,y,scale,left,top,sx,sy)
		remaining=remaining%3600
	end
	if displaySeconds then
		local seconds=floor(remaining/60)
		drawRightAligned(seconds,x+step*5)
		if seconds<10 then
			drawTimeWindowFrame(0,x+step*4,y,scale,left,top,sx,sy)
		end
		drawTimeWindowFrame(10,x+step*6+5,y,scale,left,top,sx,sy)
		remaining=remaining%60
	end
	local hundredths=min(floor(remaining*5/3),99)
	if hundredths<10 then
		drawTimeWindowFrame(0,x+step*7,y,scale,left,top,sx,sy)
	end
	drawRightAligned(hundredths,x+step*8)
end

local function timeWindowBoundary(boundaries,index)
	if type(boundaries)~="table" then return 0 end
	-- Accept both the source's zero-based indices and a conventional Lua copy.
	-- Runtime stores the latter because replay metadata is serialized as JSON.
	local value
	if rawget(boundaries,0)~=nil then
		value=boundaries[index]
	else
		value=boundaries[index+1]
	end
	return max(0,floor(tonumber(value) or 0))
end

local function copyTimeWindowBoundaries(source)
	local result={}
	for index=0,8 do
		result[index+1]=timeWindowBoundary(source,index)
	end
	return result
end

function timeWindowHudClass:init(rt)
	self.runtime=rt
	self.group=GROUP_GHOST
	self.layer=(rawget(_G,"LAYER_TOP") or 1000)+100
	self.bound=false
	self.colli=false
end

function timeWindowHudClass:frame()
	if not self.runtime or self.runtime.finished or
		LikeDreamer.runtime~=self.runtime or
		not self.runtime.timeWindowEnabled then
		Del(self)
	end
end

function timeWindowHudClass:render()
	local rt=self.runtime
	if not rt or not rt.timeWindowEnabled or
			not lstg.CheckRes(2,"ld_time_window") then return end
	local left,top,sx,sy=timeWindowViewport()
	local previousMode=lstg.viewmode or "world"
	SetViewMode("ui")
	Render("ld_time_window",left+170*sx,top-170*sy,0,sx,sy)
	if lstg.CheckRes(2,"ld_effect_s_2") then
		for i=0,Core.clamp(rt.timeWindowDispatchCount or 1,0,4)-1 do
			Render("ld_effect_s_2",left+(25+i*24)*sx,top-15*sy,
				0,0.4*sx,0.4*sy)
		end
	end
	local elapsed=max(0,floor(tonumber(rt.timeWindowElapsedFrames) or 0))
	if tonumber(rt.routeMode)==1 then
		local currentStage=floor(tonumber(rt.timeWindowStage or
			rt.stageNumber or rt.stage) or 1)
		local boundaries=rt.timeWindowStageBoundaries
		for row=0,7 do
			local stage=row+1
			local y=50+row*26
			if stage<currentStage then
				local start=timeWindowBoundary(boundaries,stage-1)
				local finish=timeWindowBoundary(boundaries,stage)
				drawTimeWindowTime(finish,1030,y,0.7,left,top,sx,sy)
				drawTimeWindowTime(max(0,finish-start),1150,y,0.7,
					left,top,sx,sy)
			elseif stage==currentStage then
				local start=timeWindowBoundary(boundaries,stage-1)
				drawTimeWindowTime(elapsed,1030,y,0.7,left,top,sx,sy)
				drawTimeWindowTime(max(0,elapsed-start),1150,y,0.7,
					left,top,sx,sy)
			end
		end
		drawTimeWindowTime(elapsed,1070,262,1,left,top,sx,sy)
		drawTimeWindowTime(rt.timeWindowBestFrames,1070,295,1,
			left,top,sx,sy)
	elseif tonumber(rt.routeMode)==2 then
		drawTimeWindowTime(elapsed,1070,262,1,left,top,sx,sy)
	end
	SetViewMode(previousMode)
end

function Runtime.new(stageNumber)
    local self=setmetatable({},Runtime)
    local launchContext=LikeDreamer.runtime
    self.stage=stageNumber;self.stageNumber=stageNumber;self.frame=0;self.gate=false
    self.complete=false;self.bulletCount=0;self.enemyCount=0;self.nextEntityId=1
    self.enemiesById={};self.boss=nil;self.bossState=-1;self.bossTimer=0
    self.stage09BossDefeatFrames={-1,-1,-1,-1,-1,-1}
	local var=lstg.var or {}
    self.difficulty=Core.clamp(rawget(_G,"difficulty") or 1,0,4)
    self.setupGroup=Core.clamp((var.like_dreamer_setup_group or var.setupGroup) or 0,0,2)
	local routeMode=tonumber(var.like_dreamer_route_mode)
	if var.is_practice then
		routeMode=2
	elseif routeMode~=0 and routeMode~=1 then
		routeMode=0
	end
	self.routeMode=routeMode
	self.systemConfig=type(launchContext)=="table" and
		launchContext.systemConfig or nil
	self.frameRateMode=tonumber(type(launchContext)=="table" and
		launchContext.frameRateMode or nil)
	local replayPlayback=ext and ext.replay and
		type(ext.replay.IsReplay)=="function" and ext.replay.IsReplay()
	self.replayPlayback=replayPlayback and true or false
	if not self.replayPlayback and (stageNumber==1 or self.routeMode==2) then
		var.like_dreamer_score_item_base=100
		var.like_dreamer_stock_progress=nil
		var.like_dreamer_extend_index=0
	end
	self.helpLevel=floor(Core.clamp(tonumber(var.like_dreamer_help_level) or 6,0,6))
	self.counterMode=tonumber(var.like_dreamer_counter_mode)==1 and 1 or 0
	var.like_dreamer_route_mode=self.routeMode
	var.like_dreamer_help_level=self.helpLevel
	var.like_dreamer_counter_mode=self.counterMode
	local registry=LikeDreamer.Stage and LikeDreamer.Stage.registry
	local practicePhase,rawStartFrame=0,0
	if self.routeMode==2 and registry and registry.get_practice_checkpoint then
		practicePhase,rawStartFrame=registry.get_practice_checkpoint(stageNumber)
	end
	self.practicePhase=practicePhase
	self.rawStartFrame=rawStartFrame
	self.frame=rawStartFrame
	local timeWindow=0
	if self.routeMode==2 then
		if registry and registry.get_practice_time_window then
			timeWindow=registry.get_practice_time_window()
		else
			timeWindow=tonumber(var.like_dreamer_practice_time_window or
				var.like_dreamer_time_window or
				var.like_dreamer_special_stage_flag)==1 and 1 or 0
		end
	elseif self.routeMode==1 then
		timeWindow=(tonumber(var.like_dreamer_time_window)==1 or
			tonumber(var.like_dreamer_special_stage_flag)==1) and 1 or 0
	end
	self.specialStageFlag=timeWindow
	self.timeWindowEnabled=timeWindow==1
	local dataWindow=tonumber(var.like_dreamer_data_window_enabled)
	self.dataWindowEnabled=dataWindow==nil and 1 or (dataWindow==1 and 1 or 0)
	local continuingTimeWindow=self.timeWindowEnabled and self.routeMode==1 and
		stageNumber>1
	self.timeWindowElapsedFrames=continuingTimeWindow and max(0,floor(
		tonumber(var.like_dreamer_time_window_elapsed_frames) or 0)) or 0
	self.timeWindowStage=stageNumber
	self.timeWindowStageBoundaries=continuingTimeWindow and
		copyTimeWindowBoundaries(var.like_dreamer_time_window_stage_boundaries) or
		copyTimeWindowBoundaries(nil)
	if self.timeWindowEnabled and self.routeMode==1 and not continuingTimeWindow then
		var.like_dreamer_time_window_elapsed_frames=0
		var.like_dreamer_time_window_stage_boundaries=
			copyTimeWindowBoundaries(nil)
	end
	-- The original obtains this from its indexed save block.  THEIS has no
	-- equivalent record yet, so only consume an explicitly supplied value.
	local suppliedBestTime=type(launchContext)=="table" and
		(launchContext.initialBestTimeFrames or
			launchContext.timeWindowBestFrames) or nil
	self.timeWindowBestFrames=max(0,floor(tonumber(suppliedBestTime) or 0))
	self.timeWindowDispatchCount=1
	self.scrollDelta=1
	self.mentalStock=floor(Core.clamp(
		tonumber(var.like_dreamer_practice_mental) or 0,0,3))
	self.mentalProgressSteps=floor(Core.clamp(
		tonumber(var.like_dreamer_practice_mental_progress) or 0,0,20))
	self.specialGauge=floor(Core.clamp(
		tonumber(var.like_dreamer_special_gauge) or 0,0,50000))
	if self.routeMode==2 then
		var.lifeleft=8
		var.bomb=self.mentalStock
	end
	self.cameraX=360
    self.findTarget=function(ldX,ldY)
        local best,bestDist
        for _,e in pairs(self.enemiesById) do
            if e.active and e.targetable and not e.protect then
                local dx,dy=e.ldX-ldX,e.ldY-ldY;local q=dx*dx+dy*dy
                if not bestDist or q<bestDist then best,bestDist=e,q end
            end
        end
        return best
    end
    self.damageEnemy=function(target,damage)
        if target and target.active and target.targetable and not target.protect then
            target.hp=target.hp-(damage or 0)
        end
    end
    self.clearEnemyBullets=function() Projectile.clear() end
	self.onGameOver=function()
		self.gameOverPresentation=true
		if system and system.setLife then
			system.setLife(-1,true)
		elseif lstg.var then
			lstg.var.lifeleft=-1
		end
	end
	if Reward then Reward.attachRuntime(self) end
    return self
end

function Runtime:randomCoord(frame,modulus,base) return Core.randomCoord(frame,modulus,base) end
function Runtime:updateTimeWindow()
	local dispatch=1
	if self.timeWindowEnabled then
		local registry=LikeDreamer.Stage and LikeDreamer.Stage.registry
		local stageEnd=registry and registry.stage_end_frames and
			registry.stage_end_frames[self.stage]
		local frame=self.frame or 0
		if stageEnd and frame>230 and frame>=(self.rawStartFrame or 0)+10 and
				frame<stageEnd-360 and not self.gate then
			local activeRadius=0
			for _,enemy in pairs(self.enemiesById) do
				if enemy.active and enemy.targetable then
					activeRadius=activeRadius+(enemy.radius or 0)
				end
			end
			if activeRadius==0 then dispatch=4
			elseif activeRadius<70 then dispatch=3
			elseif activeRadius<140 then dispatch=2 end
		end
		self.timeWindowElapsedFrames=(self.timeWindowElapsedFrames or 0)+1
		lstg.var=lstg.var or {}
		lstg.var.like_dreamer_time_window_elapsed_frames=
			self.timeWindowElapsedFrames
	end
	self.timeWindowDispatchCount=dispatch
	-- Enemy helpers which read the original DAT_1407c77a4 stage-scroll scalar
	-- consume this value in enemy.lua and enemy_late.lua.
	self.scrollDelta=dispatch
	return dispatch
end
function Runtime:commitTimeWindowStage()
	if not self.timeWindowEnabled or self.routeMode~=1 then return end
	local stage=floor(tonumber(self.timeWindowStage or self.stage) or 0)
	if stage<1 or stage>8 then return end
	self.timeWindowStageBoundaries=self.timeWindowStageBoundaries or
		copyTimeWindowBoundaries(nil)
	local boundaryIndex=rawget(self.timeWindowStageBoundaries,0)~=nil and
		stage or stage+1
	self.timeWindowStageBoundaries[boundaryIndex]=max(0,floor(
		tonumber(self.timeWindowElapsedFrames) or 0))
	lstg.var=lstg.var or {}
	lstg.var.like_dreamer_time_window_elapsed_frames=
		self.timeWindowElapsedFrames
	lstg.var.like_dreamer_time_window_stage_boundaries=
		copyTimeWindowBoundaries(self.timeWindowStageBoundaries)
end
function Runtime:spawn(typeId,hp,x,y,note)
    if self.enemyCount>=0x200 then return nil end
    local e=New(enemyClass,self,typeId,hp,x,y,note,nil)
    if gateOwners[self.stage] and gateOwners[self.stage][typeId] then self.gate=true end
    if isFinalBoss(typeId) then
        self.gate=true;self.boss=e
        local bossBgm="ld_bgm_Boss"..min(5,floor((self.stage+1)/2))
        if lstg.CheckRes(4,bossBgm) then PlayMusic(bossBgm,1,0) end
    end
    return e
end
function Runtime:spawnChild(parent,typeId,hp,x,y,note)
    if self.enemyCount>=0x200 then return nil end
    local child=New(enemyClass,self,typeId,hp,x,y,note,parent)
    child.parent=parent;child.parentEntityId=parent.entityId;child.parentSpawnType=parent.spawnType
    child.offsetX=x-parent.ldX;child.offsetY=y-parent.ldY
    return child
end

local Stage={}
LikeDreamer.Stage=Stage

local restoreStageViewport

local function centerStageViewport(rt)
	local world=lstg.world or {}
	local uiWidth=(rawget(_G,"screen") and screen.width) or 640
	local playWidth=max(1,(world.scrr or 416)-(world.scrl or 32))
	local base=LikeDreamer._stageViewportBase
	if not base or (base.world~=world and not LikeDreamer._stageViewportOwner) then
		base={world=world,scrl=world.scrl,scrr=world.scrr,
			scrb=world.scrb,scrt=world.scrt}
		LikeDreamer._stageViewportBase=base
	end
	rt.previousViewport=base
	LikeDreamer._stageViewportOwner=rt
	rt.restoreViewport=function() restoreStageViewport(rt) end
	world.scrl=(uiWidth-playWidth)*0.5
	world.scrr=world.scrl+playWidth
	return world
end

restoreStageViewport=function(rt)
	if LikeDreamer._stageViewportOwner~=rt then return end
	local world=lstg.world
	local previous=rt and rt.previousViewport
	if not world or not previous then return end
	for _,key in ipairs({"scrl","scrr","scrb","scrt"}) do
		if previous[key]~=nil then world[key]=previous[key] end
	end
	LikeDreamer._stageViewportOwner=nil
	LikeDreamer._stageViewportBase=nil
	rt.previousViewport=nil
	rt.restoreViewport=nil
end

if not LikeDreamer._stageViewportListenerRegistered and
	rawget(_G,"EventDispatcher") and rawget(_G,"EVENT") and
	EVENT.STAGE_CHANGE_BEFORE then
	LikeDreamer._stageViewportListenerRegistered=true
	EventDispatcher.AddListener("LikeDreamer.StageViewport.Restore",
		EVENT.STAGE_CHANGE_BEFORE,0,function()
			local owner=LikeDreamer._stageViewportOwner
			if owner and owner.restoreViewport then owner.restoreViewport() end
		end)
end

local viewportGuardClass=Class(object)
M.ViewportGuardClass=viewportGuardClass

function viewportGuardClass:init(rt)
	self.runtime=rt
	self.group=GROUP_GHOST
	self.layer=(rawget(_G,"LAYER_BG") or -700)-1
	self.bound=false
	self.colli=false
end

function viewportGuardClass:del()
	if self.runtime and self.runtime.restoreViewport then
		self.runtime.restoreViewport()
	end
end

viewportGuardClass.kill=viewportGuardClass.del

local function ensurePlayer(rt)
    local p=rawget(_G,"player")
    if not p or p.class~=likedreamer_player then
        if p and lstg.IsValid(p) then Del(p) end
        p=New(likedreamer_player)
    end
	p.setupGroup=rt.setupGroup
	rt.cameraX=p.ldX or 360
	rt.player=p
	return p
end

local StageSession={}
StageSession.__index=StageSession
Stage.SessionClass=StageSession

function StageSession.new(stageNumber)
    assert(stageNumber>=1 and stageNumber<=10,
        "Like Dreamer stage must be 1..10")
	return setmetatable({stageNumber=stageNumber},StageSession)
end

function StageSession:initialize()
	local stageNumber=self.stageNumber
	LikeDreamer.Resources.load(stageNumber)
	local rt=Runtime.new(stageNumber)
	self.runtime=rt
	LikeDreamer.runtime=rt
	centerStageViewport(rt)
	New(viewportGuardClass,rt)
	local p=ensurePlayer(rt)
	self.player=p
	New(LikeDreamer.Background.Class,stageNumber,rt)
	if LikeDreamer.SideHud then LikeDreamer.SideHud.create(rt) end
	if LikeDreamer.BossHud then LikeDreamer.BossHud.create(rt) end
	if LikeDreamer.Presentation then LikeDreamer.Presentation.create(rt) end
	if rt.timeWindowEnabled then New(timeWindowHudClass,rt) end
end

function StageSession:startMusic()
	local stageNumber=self.stageNumber
	local rt=self.runtime
    local bgm="ld_bgm_Stage"..stageNumber
	local registry=LikeDreamer.Stage and LikeDreamer.Stage.registry
	local stageEnd=registry and registry.stage_end_frames and
		registry.stage_end_frames[stageNumber]
	local rawStart=rt.rawStartFrame or 0
	if lstg.CheckRes(4,bgm) and (not stageEnd or rawStart<stageEnd) then
		local timelineOffset=stageNumber==10 and 300 or 0
		local seekSeconds=rawStart==0 and 0 or
			floor(max(0,rawStart-timelineOffset)/60)
		PlayMusic(bgm,1,seekSeconds)
	end
end

function StageSession:runTimeline()
	local stageNumber=self.stageNumber
	local rt=self.runtime
	local p=self.player
    while not rt.complete do
        if p and lstg.IsValid(p) then rt.cameraX=p.ldX or rt.cameraX end
		local dispatchCount=rt:updateTimeWindow()
		for _=1,dispatchCount do
			LikeDreamer.Schedules.run(stageNumber,rt,rt.frame)
			rt.frame=rt.frame+1
			if rt.complete then break end
		end
			task.Wait(1)
	    end
end

function StageSession:finish()
	local rt=self.runtime
	rt:commitTimeWindowStage()
	Projectile.clear()
	for _, enemy in pairs(rt.enemiesById) do
		if enemy.active then enemyClass.die(enemy, true) end
	end
	task.Wait(120)
	rt.finished=true
	restoreStageViewport(rt)
end

function StageSession:run()
	self:initialize()
	self:startMusic()
	self:runTimeline()
	self:finish()
end

function Stage.run(stageNumber)
	StageSession.new(stageNumber):run()
end

return M
