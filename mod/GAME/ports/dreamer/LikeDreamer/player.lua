LikeDreamer = LikeDreamer or {}

if not LikeDreamer.Resources then
	lstg.DoFile("LikeDreamer/resources.lua")
end

local PI = math.pi
local TAU = PI * 2
local FULL_ANGLE = 0x10000
local UP_ANGLE = 0xc000
local MAX_PLAYER_SHOTS = 0x100

local function clamp(value, minimum, maximum)
	return math.max(minimum, math.min(maximum, value))
end

local function normalize16(value)
	return value % FULL_ANGLE
end

local function angleRadians(angle16)
	return normalize16(angle16) * TAU / FULL_ANGLE
end

local function fallbackAtan2(y, x)
	if math.atan2 then
		return math.atan2(y, x)
	end
	if x > 0 then
		return math.atan(y / x)
	elseif x < 0 and y >= 0 then
		return math.atan(y / x) + PI
	elseif x < 0 then
		return math.atan(y / x) - PI
	elseif y > 0 then
		return PI * 0.5
	elseif y < 0 then
		return -PI * 0.5
	end
	return 0
end

local function aim16(x1, y1, x2, y2)
	local core = LikeDreamer.Core
	if core and core.aim16 then
		return normalize16(core.aim16(x1, y1, x2, y2))
	end
	return normalize16(math.floor(fallbackAtan2(y2 - y1, x2 - x1) * FULL_ANGLE / TAU))
end

local function turn16(current, target, maximumStep)
	local core = LikeDreamer.Core
	if core and core.turn16 then
		return normalize16(core.turn16(current, target, maximumStep))
	end
	local delta = normalize16(target) - normalize16(current)
	if delta > 0x8000 then
		delta = delta - FULL_ANGLE
	elseif delta < -0x8000 then
		delta = delta + FULL_ANGLE
	end
	delta = clamp(delta, -maximumStep, maximumStep)
	return normalize16(current + delta)
end

local function angleDegrees(angle16)
	local core = LikeDreamer.Core
	if core and core.angleToDeg then
		return core.angleToDeg(angle16)
	end
	return -normalize16(angle16) * 360 / FULL_ANGLE
end

local function runtime()
	LikeDreamer.runtime = LikeDreamer.runtime or {}
	return LikeDreamer.runtime
end

local function currentCameraX(owner)
	local rt = runtime()
	if rt.cameraX ~= nil then
		return rt.cameraX
	end
	if owner and owner.ldX then
		return owner.ldX
	end
	return 360
end

local function toWorld(ldX, ldY, owner)
	local core = LikeDreamer.Core
	local cameraX = currentCameraX(owner)
	if core and core.toWorld then
		return core.toWorld(ldX, ldY, cameraX)
	end
	local scale = core and core.SCALE or (28 / 45)
	return (ldX - cameraX / 6 - 300) * scale, (360 - ldY) * scale
end

local function playSound(name, volume)
	if lstg.CheckRes(5, name) then
		lstg.PlaySound(name, volume or 0.5, 0)
	end
end

local function sineEaseIn(frame, duration, maximum)
	if duration <= 0 then return maximum end
	local t = clamp(frame / duration, 0, 1)
	return math.sin(t * PI * 0.5) * maximum
end

local function sineEaseOut(frame, duration, maximum)
	if duration <= 0 then return 0 end
	local t = clamp(frame / duration, 0, 1)
	return math.cos(t * PI * 0.5) * maximum
end

local function rootFlashAlpha(age, lifetime, maximum)
	maximum = maximum or 192
	if age < 0 or age >= lifetime then return 0 end
	if age < 32 then return math.floor(sineEaseIn(age, 32, maximum)) end
	if age >= lifetime - 16 then
		return math.floor(sineEaseOut(age - (lifetime - 16), 16, maximum))
	end
	return maximum
end

local function renderWhiteFlash(alpha)
	local renderer = rawget(_G, "RenderRect") or lstg.RenderRect
	if alpha <= 0 or not renderer or
			(lstg.CheckRes and not lstg.CheckRes(2, "white")) then return end
	local world = lstg.world or {}
	SetImageState("white", "", Color(alpha, 255, 255, 255))
	renderer("white", world.l or -192, world.r or 192,
		world.b or -224, world.t or 224)
	SetImageState("white", "", Color(255, 255, 255, 255))
end

local function frameRandomAngle(frame, salt)
	local core = LikeDreamer.Core
	if core and core.frameRand then
		return normalize16(core.frameRand((frame or 0) + (salt or 0)) % FULL_ANGLE)
	end
	return normalize16((frame or 0) * 999 + (salt or 0) * 0x457)
end

local function targetValid(target)
	if not target or target.active == false then
		return false
	end
	if target.targetable == false then
		return false
	end
	if target.status == "del" or target.status == "kill" then
		return false
	end
	if target.class and lstg.IsValid then
		return lstg.IsValid(target)
	end
	return true
end

local function targetPosition(target)
	if not target then
		return nil, nil
	end
	if target.ldX ~= nil and target.ldY ~= nil then
		return target.ldX, target.ldY
	end
	if target.state and target.state.x ~= nil and target.state.y ~= nil then
		return target.state.x, target.state.y
	end
	return target.x, target.y
end

local function targetRadius(target)
	return math.max(0, target.ldRadius or target.radius or target.a or 0)
end

local function commonTarget(target)
	if not targetValid(target) or target.targetable ~= true then
		return false
	end
	local radius = targetRadius(target)
	local x, y = targetPosition(target)
	if not x or not y then return false end
	local p = rawget(_G, "player")
	local playerX = p and p.ldX or 360
	local horizontalOrigin = playerX / 6
	return x >= horizontalOrigin - radius - 100 and
		x <= horizontalOrigin + radius + 700 and
		y >= -radius - 100 and y <= radius + 820
end

local function findTarget(ldX, ldY, owner, purpose)
	local rt = runtime()
	if rt.enemiesById and rt.nextEntityId then
		local nearest
		local nearestSurfaceDistance = 2000
		for entityId = 1, rt.nextEntityId - 1 do
			local target = rt.enemiesById[entityId]
			if commonTarget(target) then
				local x, y = targetPosition(target)
				local radius = targetRadius(target)
				local eligible = true
				if purpose == "option" then
					eligible = y < ldY and math.abs(x - ldX) < radius + 180
				end
				if eligible then
					local dx, dy = x - ldX, y - ldY
					local surfaceDistance = math.sqrt(dx * dx + dy * dy) - radius
					if surfaceDistance < nearestSurfaceDistance then
						nearestSurfaceDistance = surfaceDistance
						nearest = target
					end
				end
			end
		end
		return nearest
	end
	if rt.findTarget then
		return rt.findTarget(ldX, ldY, owner, purpose)
	end
	return nil
end

local function animationFrame(tick, offset, duration, frames)
	local period = duration * #frames
	local phase = (tick - offset) % period
	return frames[math.min(math.floor(phase / duration) + 1, #frames)]
end

local playerAfterimage = Class(object)

function playerAfterimage:init(owner, ldX, ldY, image)
	self.owner = owner
	self.ldX = ldX
	self.ldY = ldY
	self.img = image
	self.group = GROUP_GHOST
	self.layer = LAYER_PLAYER - 1
	self.bound = false
	self.colli = false
	self.x, self.y = toWorld(ldX, ldY, owner)
end

function playerAfterimage:frame()
	if self.timer >= 24 then
		Del(self)
		return
	end
	self.x, self.y = toWorld(self.ldX, self.ldY, self.owner)
end

function playerAfterimage:render()
	local alpha = math.floor(96 * (1 - self.timer / 24))
	SetImageState(self.img, "", Color(alpha, 255, 255, 255))
	Render(self.img, self.x, self.y, 0, 1, 1)
	SetImageState(self.img, "", Color(255, 255, 255, 255))
end

local playerShot = Class(object)
LikeDreamer.PlayerShot=playerShot

local MAIN_FRAMES = { 0x1c, 0x2c, 0x49 }
local UNFOCUSED_FRAMES = { 0x1d, 0x3a, 0x4a }
local FOCUSED_FRAMES = { 0x2b, 0x3b, 0x58 }
local TRACKING_FRAMES = { 0x59, 0x67, 0x59 }

local function shotFrame(shotType, setupGroup)
	local index = setupGroup + 1
	if shotType <= 1 then
		return MAIN_FRAMES[index]
	elseif shotType <= 4 then
		return UNFOCUSED_FRAMES[index]
	elseif shotType <= 7 then
		return FOCUSED_FRAMES[index]
	end
	return TRACKING_FRAMES[index]
end

function playerShot:init(owner, shotType, ldX, ldY, speed, angle16, damage, radius)
	self.owner = owner
	self.shotType = shotType
	self.ldX = ldX
	self.ldY = ldY
	self.speed = speed
	self.angle16 = normalize16(angle16)
	self.drawAngle16 = self.angle16
	self.damage = damage
    self.a = radius*LikeDreamer.Core.worldScale()
    self.b = radius*LikeDreamer.Core.worldScaleY()
	self.radius = radius
	self.setupGroup = owner.setupGroup
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.bound = false
	self.colli = true
	self.active = true
	self.counted = true
	owner.shotCount = owner.shotCount + 1
	self.img = "ld_player_" .. (shotFrame(shotType, self.setupGroup) + 1)
	self.x, self.y = toWorld(ldX, ldY, owner)
end

function playerShot:releaseCount()
	if self.counted then
		self.counted = false
		if self.owner then
			self.owner.shotCount = math.max(0, self.owner.shotCount - 1)
		end
	end
end

function playerShot:del()
	playerShot.releaseCount(self)
end

function playerShot:kill()
	playerShot.releaseCount(self)
end

function playerShot:finish()
	if not self.active then
		return
	end
	self.active = false
	playerShot.releaseCount(self)
	Del(self)
end

function playerShot:frame()
	if not self.active or not self.owner or not lstg.IsValid(self.owner) then
		playerShot.finish(self)
		return
	end

	local age = self.timer
	local radians = angleRadians(self.angle16)
	self.ldX = self.ldX + math.cos(radians) * self.speed
	self.ldY = self.ldY + math.sin(radians) * self.speed

	if self.shotType == 0 then
		self.damage = age < 0x11 and (0x82 - age * 5) or 0x32
	elseif self.shotType == 1 then
		self.damage = age < 0x11 and (0xa0 - age * 5) or 0x50
	end

	if self.shotType >= 8 and self.shotType <= 10 and age < 60 and self.setupGroup < 2 then
		local target = findTarget(self.ldX, self.ldY, self, "shot")
		if targetValid(target) then
			local targetX, targetY = targetPosition(target)
			if targetX and targetY then
				local desired = aim16(self.ldX, self.ldY, targetX, targetY)
				local step = self.setupGroup == 0 and ((age + 16) * 0x20) or 0x200
				self.angle16 = turn16(self.angle16, desired, step)
			end
		end
	end

	self.drawAngle16 = self.angle16
	if self.shotType >= 8 and self.shotType <= 10 and self.setupGroup == 0 then
		self.drawAngle16 = normalize16(self.angle16 + age * 0x400)
	end

	local horizontalOrigin = currentCameraX(self.owner) / 6
	if self.ldX < horizontalOrigin - self.radius - 160 or
		self.ldX > horizontalOrigin + self.radius + 760 or
		self.ldY < -self.radius - 160 or self.ldY > self.radius + 880 then
		playerShot.finish(self)
		return
	end
	self.x, self.y = toWorld(self.ldX, self.ldY, self.owner)
end

function playerShot:hit(target)
    if not self.active or not target.active or not target.targetable or target.protect then return end
    runtime().damageEnemy(target,self.damage,self)
    playSound("ld_se_Shothit",0.25)
    playerShot.finish(self)
end

function playerShot:render()
	if not self.active then
		return
	end
	local age = self.timer
	local red, green, blue, alpha = 255, 255, 255, 128
	local scale = 1
	if self.shotType == 0 then
		green = age < 0x11 and (0x80 + age * 8) or 0xff
		blue = green
	elseif self.shotType == 1 then
		green = age < 0x11 and (0x80 + age * 8) or 0xff
		blue = 0x80
		alpha = 0xc0
		scale = 2
	elseif self.shotType == 3 or self.shotType == 6 or self.shotType == 9 then
		green = 0x80
		blue = 0x80
		scale = 1.5
	elseif self.shotType == 4 or self.shotType == 7 or self.shotType == 10 then
		alpha = 0xc0
		scale = 2
		if self.owner.specialGauge < 0 then
			green, blue = 0xff, 0x80
		else
			red, green, blue = 0xc0, 0x40, 0x40
		end
	end
	local scaleX = scale
	if self.shotType >= 2 and self.shotType <= 4 then
		scaleX = scaleX * 1.5
	end
	SetImageState(self.img, "", Color(alpha, red, green, blue))
	Render(self.img, self.x, self.y, angleDegrees(self.drawAngle16),
		1 * scaleX, 1 * scale)
	SetImageState(self.img, "", Color(255, 255, 255, 255))
end

local SPECIAL_CANCEL_TYPES = {
	[0x0c] = true, [0x0d] = true, [0x0e] = true, [0x10] = true,
	[0x11] = true, [0x14] = true, [0x15] = true, [0x16] = true,
	[0x18] = true, [0x19] = true, [0x1d] = true, [0x1e] = true,
	-- FUN_1400cd750 handles 0x1a outside the 0x63737000 bit-mask path.
	[0x1a] = true,
}

local playerSpecialObject = Class(object)

local function specialImage(family, index)
	local name = "ld_player_fx_" .. family .. "_" .. tostring(index + 1)
	if lstg.CheckRes(2, name) then return name end
	return nil
end

function playerSpecialObject:init(owner, specialType, ldX, ldY, speed, angle16,
		damageOrLifetime, radius)
	self.owner = owner
	self.specialType = specialType
	self.ldX, self.ldY = ldX, ldY
	self.originX, self.originY = ldX, ldY
	self.speed = speed or 0
	self.angle16 = normalize16(angle16 or 0)
	self.drawAngle16 = self.angle16
	self.damageOrLifetime = damageOrLifetime or 0
	self.radius = radius or 0
	self.targetRadius = self.radius
	self.age = 0
	self.drawAge = 0
	self.active = true
	self.bound = false
	self.rect = false
	self.layer = LAYER_PLAYER_BULLET + 2
	self._counted = true
	owner.specialObjectCount = (owner.specialObjectCount or 0) + 1
	owner.specialObjectSerial = (owner.specialObjectSerial or 0) + 1
	self.serial = owner.specialObjectSerial
	local rt = runtime()
	rt.playerSideObjects = rt.playerSideObjects or {}
	rt.playerSideObjects[#rt.playerSideObjects + 1] = self
	playerSpecialObject._syncCollision(self)
end

function playerSpecialObject:_syncCollision()
	self.x, self.y = toWorld(self.ldX, self.ldY, self.owner)
	local cancel = SPECIAL_CANCEL_TYPES[self.specialType] == true
	self._ldProjectileCancel = cancel
	self._ldCancelIgnoresFlags = self.specialType == 0x18 or
		self.specialType == 0x19 or self.specialType == 0x1a
	self._ldCancelNoReward = self.specialType == 0x16 or
		self.specialType == 0x1e
	local scale = LikeDreamer.Core and LikeDreamer.Core.SCALE or (28 / 45)
	self.a = math.max(0.1, math.max(0, self.radius) * scale)
	self.b = self.a
	self.colli = self.active and cancel and self.radius > 0
	self.group = self.colli and (rawget(_G, "GROUP_SPELL") or GROUP_GHOST) or GROUP_GHOST
end

function playerSpecialObject:_releaseCount()
	if not self._counted then return end
	self._counted = false
	if self.owner then
		self.owner.specialObjectCount = math.max(
			0, (self.owner.specialObjectCount or 1) - 1)
	end
end

function playerSpecialObject:del() playerSpecialObject._releaseCount(self) end
function playerSpecialObject:kill() playerSpecialObject._releaseCount(self) end

function playerSpecialObject:_finish()
	if not self.active then return end
	self.active = false
	local rt = runtime()
	self._ldFinishedFrame = rt and rt.frame or 0
	self.colli = false
	-- The original unlinks on the following update, after drawing the terminal frame.
	self._deleteNextFrame = true
end

function playerSpecialObject:_move()
	local radians = angleRadians(self.angle16)
	self.ldX = self.ldX + math.cos(radians) * self.speed
	self.ldY = self.ldY + math.sin(radians) * self.speed
end

function playerSpecialObject:_reflectAndClamp()
	local horizontalOrigin = self.owner.ldX / 6
	local radius = math.max(0, self.radius)
	local originalAngle = self.angle16
	local reflectedAngle = originalAngle
	if self.ldX < horizontalOrigin + radius or
			self.ldX > horizontalOrigin + 600 - radius then
		reflectedAngle = 0x8000 - originalAngle
	end
	if self.ldY < radius or self.ldY > 720 - radius then
		reflectedAngle = -originalAngle
	end
	self.angle16 = normalize16(reflectedAngle)
	self.ldX = clamp(self.ldX, horizontalOrigin + radius,
		horizontalOrigin + 600 - radius)
	self.ldY = clamp(self.ldY, radius, 720 - radius)
end

function playerSpecialObject:frame()
	if self._deleteNextFrame then
		self._deleteNextFrame = false
		Del(self)
		return
	end
	if not self.active or not self.owner or not lstg.IsValid(self.owner) then
		Del(self)
		return
	end

	local age = self.age
	local specialType = self.specialType
	self.drawAge = age

	if specialType == 0x0b then
		if age == 0 then
			likedreamer_player._spawnSpecial(self.owner, 0x1a, self.owner.ldX, self.owner.ldY,
				0, 0, 0, 300)
		end
		if age == 0 or age == 8 or age == 16 or age == 24 then
			local slot = math.floor(age / 8) + 1
			local angle = self.owner.optionAngle16[slot]
			local radians = angleRadians(angle)
			likedreamer_player._spawnSpecial(self.owner, 0x0c,
				self.owner.optionX[slot] + math.cos(radians) * 40,
				self.owner.optionY[slot] + math.sin(radians) * 40,
				20, angle, 0, 45)
			playSound("ld_se_Bomb2", 0.6)
		end
		if age == 180 then playerSpecialObject._finish(self) end
	elseif specialType == 0x0c then
		playerSpecialObject._move(self)
		if age < 20 then playerSpecialObject._reflectAndClamp(self) end
		local horizontalOrigin = self.owner.ldX / 6
		local terminate = self.ldY < 50 or age == 148
		if age >= 20 then
			terminate = terminate or self.ldX < horizontalOrigin - self.radius or
				self.ldX > horizontalOrigin + 600 + self.radius or
				self.ldY < -self.radius or self.ldY > 720 + self.radius
		end
		if terminate then
			likedreamer_player._spawnSpecial(self.owner, 0x0d, self.ldX, self.ldY, 0, 0, 16, 0)
			playSound("ld_se_Bomb3", 0.5)
			playerSpecialObject._finish(self)
		end
	elseif specialType == 0x0d then
		if age < 10 then
			self.radius = sineEaseIn(age, 10, 160)
		elseif age >= 120 and age < 130 then
			self.radius = sineEaseOut(age - 120, 10, 160)
		else
			self.radius = age < 130 and 160 or 0
		end
		if age == 130 then playerSpecialObject._finish(self) end
	elseif specialType == 0x0e then
		if age == 0 then
			likedreamer_player._spawnSpecial(self.owner, 0x19, self.owner.ldX, self.owner.ldY,
				0, 0, 0, 0)
		end
		if age < 30 then
			self.speed = math.max(0, self.speed - 0.6)
			playerSpecialObject._move(self)
			playerSpecialObject._reflectAndClamp(self)
		else
			if age == 30 then
				playSound("ld_se_Bomb5", 0.5)
				self.speed = 1
				self.damageOrLifetime = 32
			end
			playerSpecialObject._move(self)
			self.radius = age < 40 and sineEaseIn(age - 30, 10, 250) or 250
		end
		if age == 180 then playerSpecialObject._finish(self) end
	elseif specialType == 0x0f then
		self.ldX, self.ldY = self.owner.ldX, self.owner.ldY
		if age % 3 == 0 then
			for slot = 1, 4 do
				likedreamer_player._spawnSpecial(self.owner, 0x10,
					self.owner.optionX[slot], self.owner.optionY[slot],
					50, self.owner.optionAngle16[slot], 90, 60)
			end
			playSound("ld_se_Bomb6", 0.5)
		end
		if age == 180 then playerSpecialObject._finish(self) end
	elseif specialType == 0x10 then
		playerSpecialObject._move(self)
		self.drawAngle16 = self.angle16
		if self.ldY < -500 then playerSpecialObject._finish(self) end
	elseif specialType == 0x11 then
		if age == 0 then
			likedreamer_player._spawnSpecial(self.owner, 0x18, self.owner.ldX, self.owner.ldY,
				0, 0, 0, 0)
			self.owner.shotVariant = 600
		end
		if age == 600 or (age > 59 and self.owner.bombLock == -179) then
			playerSpecialObject._finish(self)
		end
	elseif specialType == 0x12 then
		if age % 40 == 0 and age < 151 then
			local rt = runtime()
			likedreamer_player._spawnSpecial(self.owner, 0x13, self.owner.ldX, self.owner.ldY,
				0, frameRandomAngle(rt.frame, self.serial * 0x457 + age), 0, 0)
		end
		if age == 180 then playerSpecialObject._finish(self) end
	elseif specialType == 0x13 then
		if age % 5 == 0 then
			local distance = 80 + age * 8
			local rt = runtime()
			for index = 0, 2 do
				local radialAngle = normalize16(self.angle16 + age * 999 + index * 0x5555)
				local radians = angleRadians(radialAngle)
				likedreamer_player._spawnSpecial(self.owner, 0x14,
					self.ldX + math.cos(radians) * distance,
					self.ldY + math.sin(radians) * distance,
					0, frameRandomAngle(rt.frame + index,
						self.serial * 0xd05 + age), 5, 120)
			end
			playSound("ld_se_Bomb7", 0.55)
		end
		if age == 90 then playerSpecialObject._finish(self) end
	elseif specialType == 0x14 then
		self.radius = sineEaseIn(age, 30, self.targetRadius)
		if age == 30 then playerSpecialObject._finish(self) end
	elseif specialType == 0x15 then
		self.ldX, self.ldY = self.owner.ldX, self.owner.ldY
		if age < 32 then
			self.radius = sineEaseIn(age, 32, 200)
		elseif age >= 230 and age < 240 then
			self.radius = sineEaseOut(age - 230, 10, 200)
		else
			self.radius = age < 240 and 200 or 0
		end
		if age % 20 == 0 then playSound("ld_se_Bomb8", 0.55) end
		if age == 240 then playerSpecialObject._finish(self) end
	elseif specialType == 0x16 then
		self.radius = age < 32 and
			(20 + sineEaseIn(age, 32, math.max(0, self.targetRadius - 20))) or
			self.targetRadius
		if age == 96 then playerSpecialObject._finish(self) end
	elseif specialType == 0x17 or specialType == 0x18 then
		if age == 0 then
			self.owner.invulnerableFrames = math.max(
				self.owner.invulnerableFrames, 100)
		end
		self.radius = self.radius + 25
		if age == 48 then playerSpecialObject._finish(self) end
	elseif specialType == 0x19 then
		if age == 0 then
			self.owner.invulnerableFrames = math.max(
				self.owner.invulnerableFrames, 100)
		end
		self.radius = self.radius + 50
		if age == 24 then playerSpecialObject._finish(self) end
	elseif specialType == 0x1a then
		self.radius = sineEaseIn(age, 24, self.targetRadius)
		if age == 24 then playerSpecialObject._finish(self) end
	elseif self.damageOrLifetime > 0 and age == self.damageOrLifetime then
		playerSpecialObject._finish(self)
	end

	self.age = self.age + 1
	playerSpecialObject._syncCollision(self)
end

function playerSpecialObject:colli(other)
	if not self.active or not other then return end
	if other.group == GROUP_ENEMY_BULLET and SPECIAL_CANCEL_TYPES[self.specialType] then
		other.active = false
		other.collisionEnabled = false
		other.colli = false
		if lstg.IsValid(other) then Del(other) end
		return
	end
	if other.group ~= GROUP_ENEMY and other.group ~= rawget(_G, "GROUP_NONTJT") then
		return
	end
	local rt = runtime()
	if self.specialType == 0x0c then
		local x, y = self.ldX, self.ldY
		playerSpecialObject._finish(self)
		likedreamer_player._spawnSpecial(self.owner, 0x0d, x, y, 0, 0, 10, 0)
		playSound("ld_se_Bomb3", 0.5)
		return
	end
	local damage = self.damageOrLifetime
	if damage > 0 then
		if rt.damageEnemy then
			rt.damageEnemy(other, damage, self)
		elseif other.hp then
			other.hp = other.hp - damage
		end
		playSound("ld_se_Shothit", 0.25)
	end
	if self.specialType == 0x10 then playerSpecialObject._finish(self) end
end

function playerSpecialObject:render()
	local specialType = self.specialType
	local age = self.drawAge
	if specialType == 0x0b or specialType == 0x0e or
			specialType == 0x0f or specialType == 0x11 or
			specialType == 0x12 or specialType == 0x15 then
		local lifetime = specialType == 0x11 and 600 or
			(specialType == 0x15 and 240 or 180)
		renderWhiteFlash(rootFlashAlpha(age, lifetime))
	end
	local image, scale, alpha, blend = nil, 1, 255, ""
	local angle = self.drawAngle16
	if specialType == 0x0c then
		image = specialImage("m", 6)
		scale = age < 8 and sineEaseIn(age, 8, 1) or 1
		angle = normalize16(self.owner.drawAnimationClock * 999)
	elseif specialType == 0x0d then
		image = specialImage("l", 1)
		scale = self.radius / 180
		alpha = 192
		angle = normalize16(self.owner.drawAnimationClock * 2000)
	elseif specialType == 0x0e and age < 30 then
		image = specialImage("m", 6)
		scale = age < 20 and sineEaseIn(age, 20, 1) or
			sineEaseOut(age - 20, 10, 1)
		angle = normalize16(self.owner.drawAnimationClock * 999)
	elseif specialType == 0x10 then
		image = specialImage("m", 7)
	elseif specialType == 0x14 then
		image = specialImage("m", 12)
		scale = self.radius / 75
		alpha = age < 24 and 192 or sineEaseOut(age - 24, 6, 192)
		blend = "mul+add"
	elseif specialType == 0x15 then
		image = specialImage("l", 4)
		scale = self.radius / 250
		alpha = 160
		angle = normalize16(age * 0x29a)
		blend = "mul+add"
	elseif specialType == 0x16 then
		image = specialImage("l", 6)
		scale = self.radius / 200
		alpha = age < 80 and 255 or sineEaseOut(age - 80, 16, 255)
		angle = normalize16(age * 0x400)
		blend = "mul+add"
	elseif specialType == 0x17 or specialType == 0x18 then
		image = specialImage("l", 0)
		scale = self.radius / 250
		alpha = age < 32 and 255 or sineEaseOut(age - 32, 16, 255)
		blend = "mul+add"
	elseif specialType == 0x19 then
		image = specialImage("l", 0)
		scale = self.radius / 250
		alpha = age < 16 and 255 or sineEaseOut(age - 16, 8, 255)
		blend = "mul+add"
	elseif specialType == 0x1a then
		image = specialImage("m", 5)
		scale = self.radius / 75
		alpha = age < 16 and 96 or sineEaseOut(age - 16, 8, 96)
		blend = "mul+add"
	end
	if not image or scale <= 0 or alpha <= 0 then return end
	SetImageState(image, blend, Color(math.floor(clamp(alpha, 0, 255)), 255, 255, 255))
	Render(image, self.x, self.y, angleDegrees(angle),
		1 * scale, 1 * scale)
	if specialType == 0x15 or specialType == 0x16 then
		Render(image, self.x, self.y, angleDegrees(normalize16(-angle)),
			1 * scale, 1 * scale)
	end
	SetImageState(image, "", Color(255, 255, 255, 255))
end

local UNFOCUSED_OFFSETS = {
	{ 50, 60, -50, 60, 80, 10, -80, 10 },
	{ 50, -30, -50, -30, 80, 30, -80, 30 },
	{ 50, -50, -50, -50, 90, 30, -90, 30 },
	{ 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 70, 60, -70, 60, 150, 0, -150, 0 },
	{ 60, -60, -60, -60, 110, -20, -110, -20 },
}

local UNFOCUSED_ANGLES = {
	{ 0xc5dc, 0xba24, 0xcfa0, 0xb060 },
	{ 0xcbb8, 0xb448, 0xd770, 0xa890 },
	{ 0xc0c8, 0xbf38, 0xc2bc, 0xbd44 },
	{ 0x01f4, 0xfe0c, 0x05dc, 0xfa24 },
	{ 0xc000, 0xc000, 0xc000, 0xc000 },
	{ 0xc000, 0xc000, 0xc3e8, 0xbc18 },
}

local FOCUSED_GROUP0_WIDE = { -160, 0, 160, 0, -80, 40, 80, 40 }
local FOCUSED_NARROW = { -70, -20, 70, -20, -30, -70, 30, -70 }
local FOCUSED_GROUP2_0 = { 30, 50, -30, 50, 70, 0, -70, 0 }
local FOCUSED_GROUP2_1 = { 25, -60, -25, -60, 60, -20, -60, -20 }
local GROUP2_ROTATING = { 70, 60, -70, 60, 150, 0, -150, 0 }
local UP_ANGLES = { UP_ANGLE, UP_ANGLE, UP_ANGLE, UP_ANGLE }
local FOCUSED_GROUP0_1_ANGLES = { 0xc1f4, 0xbe0c, 0xc000, 0xc000 }
local FOCUSED_GROUP1_0_ANGLES = { 0xc3e8, 0xbc18, 0xc1f4, 0xbe0c }
local FOCUSED_GROUP2_1_ANGLES = { 0xc000, 0xc000, 0xc1f4, 0xbe0c }
local RADIAL_ANGLE_OFFSETS = { 0x01f4, -0x01f4, 0x05dc, -0x05dc }
local MOVE_SPEEDS = { { 7.5, 4.0 }, { 7.9, 4.1 }, { 8.3, 4.2 } }
local FEVER_COLORS = {
	{ 255, 120, 120 }, { 255, 200, 110 }, { 255, 255, 120 },
	{ 120, 255, 120 }, { 120, 255, 255 }, { 120, 120, 255 },
	{ 220, 120, 255 },
}
local STOCK_THRESHOLDS = { 56000, 70000, 70000, 70000, 70000 }

local PLAYER_OVERLAY_LAYERS = {
	marker = 0x45,
	gauge_fill = 0x4b,
	gauge_frame = 0x4c,
	aura = 0x4f,
	hitbox = 0x59,
}

local playerOverlayProxy = Class(object)

function playerOverlayProxy:init(owner, pass, exactLayer)
	self.owner = owner
	self.runtime = runtime()
	self.pass = pass
	self.group = GROUP_GHOST
	self.layer = (rawget(_G, "LAYER_ENEMY_BULLET") or -200) + exactLayer - 0x50 + 0.01
	self.bound = false
	self.colli = false
	self.hide = false
end

function playerOverlayProxy:frame()
	local owner = self.owner
	local activeRuntime = LikeDreamer.runtime
	if activeRuntime and activeRuntime ~= self.runtime then
		self.runtime = activeRuntime
	end
	if not owner or (self.runtime and self.runtime.finished) or
			(lstg.IsValid and not lstg.IsValid(owner)) then
		Del(self)
	end
end

function playerOverlayProxy:render()
	local owner = self.owner
	if owner and likedreamer_player and likedreamer_player._renderOverlay then
		likedreamer_player._renderOverlay(owner, self.pass)
	end
end

likedreamer_player = Class(player_class)
LikeDreamer.PlayerClass = likedreamer_player

function likedreamer_player:init()
	player_class.init(self)
	if IsValid(self.grazer) then object.RawDel(self.grazer) end
	LikeDreamer.Resources.loadPlayer()
	local rt = runtime()
	local var = lstg.var or {}
	self.setupGroup = clamp(rt.setupGroup or rt.setup_group or var.ld_setup_group or 0, 0, 2)
	self.optionSlots = rt.optionSlots or rt.option_slots or var.ld_option_slots or { 0, 0, 0, 0 }
	for index = 1, 4 do
		self.optionSlots[index] = self.optionSlots[index] or 0
	end
	self.controlModeEnabled = rt.controlModeEnabled or rt.control_mode or var.ld_control_mode or 1

	self.ldX = 360
	self.ldY = 600
	self.playerStateTimer = 0
	self.shotTimer = 0
	self.focusTransition = 0x20
	self.focusHoldTimer = 0
	self.lateralAnimation = 0
	self.animationClock = 0
	self.drawAnimationClock = 0
	self.hitboxScale = 0
	self.visualFrame = self.setupGroup * 30
	self.img = "ld_player_" .. (self.visualFrame + 1)
	self.movementAngle16 = UP_ANGLE
	self.focused = false
	self.specialGauge = rt.specialGauge or rt.special_gauge or
		var.like_dreamer_special_gauge or 0
	self.specialMode = clamp(rt.specialMode or rt.special_mode or
		var.like_dreamer_special_mode or 0, 0, 1)
	self.shotVariant = 0
	self.shotVariantAuraScale = 0
	self.bombLock = 0
	self.invulnerableFrames = 60
	self.optionDrawScale = 1
	self.optionFormationAngle16 = UP_ANGLE
	self.sharedOptionTargetX = self.ldX
	self.sharedOptionTargetY = self.ldY
	self.optionX = { self.ldX, self.ldX, self.ldX, self.ldX }
	self.optionY = { self.ldY, self.ldY, self.ldY, self.ldY }
	self.optionAngle16 = { UP_ANGLE, UP_ANGLE, UP_ANGLE, UP_ANGLE }
	self.optionTargets = { false, false, false, false }
	self.shotCount = 0
	self.specialObjectCount = 0
	self.specialObjectSerial = 0
	self.beingShotCount = 0
	self.hide = false

	self.group = GROUP_PLAYER
	self.layer = LAYER_PLAYER
	self.bound = false
	self.colli = true
	self.rect = false
	self.a = 3
	self.b = 3
	self.x, self.y = toWorld(self.ldX, self.ldY, self)

	lstg.player = self
	player = self
	rt.player = self
	rt.cameraX = self.ldX
	self.overlayProxies = {}
	for pass, exactLayer in pairs(PLAYER_OVERLAY_LAYERS) do
		self.overlayProxies[#self.overlayProxies + 1] =
			New(playerOverlayProxy, self, pass, exactLayer)
	end
end

function likedreamer_player:_updateFocus(shootDown, rapidFireDown, slowDown)
	if self.controlModeEnabled == 1 then
		self.focused = slowDown
		if slowDown and self.focusTransition > 0 then
			self.focusTransition = -1
		elseif not slowDown and self.focusTransition < 0 then
			self.focusTransition = 1
		end
	else
		if self.focusHoldTimer ~= 0 then
			self.focusHoldTimer = self.focusHoldTimer + 1
		end
		if shootDown then
			if self.focusHoldTimer == 0 then
				self.focusHoldTimer = 1
			elseif self.focusHoldTimer ~= 1 and self.focusHoldTimer > 11 then
				self.focused = true
				if self.focusTransition > 0 then
					self.focusTransition = -1
				end
			end
			if self.focusHoldTimer == 1 and rapidFireDown then
				self.focusHoldTimer = 8
			end
		else
			self.focused = false
			if self.focusTransition < 0 and not slowDown then
				self.focusTransition = 1
			end
			self.focusHoldTimer = 0
		end
		if slowDown then
			self.focused = true
			if self.focusTransition > 0 then
				self.focusTransition = -1
			end
		end
	end
	if self.focusTransition < 0 then
		self.focusTransition = self.focusTransition - 1
	elseif self.focusTransition > 0 then
		self.focusTransition = self.focusTransition + 1
	end
end

function likedreamer_player:_updateMovement()
	local up = KeyIsDown("up")
	local down = KeyIsDown("down")
	local right = KeyIsDown("right")
	local left = KeyIsDown("left")
	if up then self.movementAngle16 = 0xc000 end
	if down then self.movementAngle16 = 0x4000 end
	if right then self.movementAngle16 = 0x0000 end
	if left then self.movementAngle16 = 0x8000 end
	if right and down then self.movementAngle16 = 0x2000 end
	if left and down then self.movementAngle16 = 0x6000 end
	if left and up then self.movementAngle16 = 0xa000 end
	if right and up then self.movementAngle16 = 0xe000 end

	local moving = up or down or right or left
	local verticalOnly = self.movementAngle16 == 0x4000 or self.movementAngle16 == 0xc000
	local movingLeft = self.movementAngle16 == 0x6000 or
		self.movementAngle16 == 0x8000 or self.movementAngle16 == 0xa000
	if not moving or verticalOnly then
		if self.lateralAnimation < 0 then
			self.lateralAnimation = self.lateralAnimation + 1
		elseif self.lateralAnimation > 0 then
			self.lateralAnimation = self.lateralAnimation - 1
		end
	elseif movingLeft then
		if self.lateralAnimation > 0 then self.lateralAnimation = 0 end
		self.lateralAnimation = math.max(self.lateralAnimation - 1, -12)
	else
		if self.lateralAnimation < 0 then self.lateralAnimation = 0 end
		self.lateralAnimation = math.min(self.lateralAnimation + 1, 12)
	end

	local speed = MOVE_SPEEDS[self.setupGroup + 1][self.focused and 2 or 1]
    self.hspeed= MOVE_SPEEDS[self.setupGroup + 1][1]*LikeDreamer.Core.worldScaleY()
    self.lspeed= MOVE_SPEEDS[self.setupGroup + 1][2]*LikeDreamer.Core.worldScaleY()
    local tx,ty
    if TouchInputMovement and self.playerStateTimer<=180 then
        tx,ty=TouchInputMovement(self,KeyState,speed*LikeDreamer.Core.worldScaleY())
    end
    local moved = self.playerStateTimer <= 180 and (moving or tx~=nil)
	if moved then
		local radians = angleRadians(self.movementAngle16)
		local nextX = self.ldX + math.cos(radians) * speed * 1.2
		local nextY = self.ldY + math.sin(radians) * speed
		if tx then nextX,nextY=LikeDreamer.Core.playerWorldPosition(self.x+tx,self.y+ty) end
		local origin = nextX / 6
		self.ldX = clamp(nextX, origin + 4, origin + 596)
		self.ldY = clamp(nextY, 4, 716)
	end
	if self.playerStateTimer >= 181 and self.playerStateTimer <= 220 then
		local dx = 360 - self.ldX
		local dy = 600 - self.ldY
		local distance = math.sqrt(dx * dx + dy * dy)
		if distance > 0 then
			local heading = fallbackAtan2(dy, dx)
			local step = distance / 10 + 1
			self.ldX = self.ldX + math.cos(heading) * step
			self.ldY = self.ldY + math.sin(heading) * step
		end
	end
	return moved
end

function likedreamer_player:_advanceSharedTarget()
	if self.focusTransition == -2 then
		local dx = self.ldX - self.sharedOptionTargetX
		local dy = self.ldY - self.sharedOptionTargetY
		if dx * dx + dy * dy <= 30 * 30 then
			self.sharedOptionTargetX = self.ldX
			self.sharedOptionTargetY = self.ldY
		end
	end
	local target = findTarget(self.sharedOptionTargetX, self.sharedOptionTargetY, self, "shared")
	local targetX, targetY = self.ldX, self.ldY
	if targetValid(target) then
		local x, y = targetPosition(target)
		if x and y then
			targetX, targetY = x, y + 200
		end
	end
	local heading = fallbackAtan2(targetY - self.sharedOptionTargetY,
		targetX - self.sharedOptionTargetX)
	self.sharedOptionTargetX = self.sharedOptionTargetX + math.cos(heading) * 0.1
	self.sharedOptionTargetY = self.sharedOptionTargetY + math.sin(heading) * 0.1
end

function likedreamer_player:_updateOptions()
	local option0 = clamp(self.optionSlots[1], 0, 1)
	local option1 = clamp(self.optionSlots[2], 0, 1)
	self.optionDrawScale = 1
	if self.playerStateTimer >= 180 and self.playerStateTimer < 260 then
		if self.playerStateTimer < 190 then
			self.optionDrawScale = 1 - math.sin((self.playerStateTimer - 180) * PI / 20)
		elseif self.playerStateTimer < 250 then
			self.optionDrawScale = 0
		else
			self.optionDrawScale = 1 - math.sin((self.playerStateTimer - 240) * PI / 20)
		end
	end

	local rotating = not self.focused and
		((self.setupGroup == 1 and option0 == 1) or (self.setupGroup == 2 and option0 == 0))
	if rotating then
		local target = UP_ANGLE
		if KeyIsDown("left") then
			target = 0xae6c
		elseif KeyIsDown("right") then
			target = 0xd194
		end
		self.optionFormationAngle16 = turn16(self.optionFormationAngle16, target, 0x5a)
	end
	if self.focused and self.setupGroup == 1 and option0 == 1 then
		self.optionFormationAngle16 = UP_ANGLE
	end

	for slot = 1, 4 do
		local offsetIndex = (slot - 1) * 2 + 1
		local offsetX, offsetY = 0, 0
		local anchorX, anchorY = self.ldX, self.ldY
		local targetAngle = UP_ANGLE

		if not self.focused then
			local sharedTransition = self.setupGroup == 2 and option1 == 1 and self.focusTransition < 0x11
			if sharedTransition then
				local row = self.setupGroup * 2 + option0 + 1
				anchorX, anchorY = self.sharedOptionTargetX, self.sharedOptionTargetY
				offsetX = UNFOCUSED_OFFSETS[row][offsetIndex]
				offsetY = UNFOCUSED_OFFSETS[row][offsetIndex + 1]
				targetAngle = UNFOCUSED_ANGLES[row][slot]
			elseif self.setupGroup == 1 and option0 == 1 then
				local angle = angleRadians(self.optionFormationAngle16)
				offsetX = math.cos(angle) * 100
				offsetY = math.sin(angle) * 100 + 20
				targetAngle = normalize16(self.optionFormationAngle16 + RADIAL_ANGLE_OFFSETS[slot])
			elseif self.setupGroup == 2 and option0 == 0 then
				offsetX = GROUP2_ROTATING[offsetIndex]
				offsetY = GROUP2_ROTATING[offsetIndex + 1]
				targetAngle = self.optionFormationAngle16
			else
				local row = self.setupGroup * 2 + option0 + 1
				offsetX = UNFOCUSED_OFFSETS[row][offsetIndex]
				offsetY = UNFOCUSED_OFFSETS[row][offsetIndex + 1]
				targetAngle = UNFOCUSED_ANGLES[row][slot]
			end
			if self.setupGroup == 2 and option1 == 1 and not sharedTransition then
				self.sharedOptionTargetX = self.ldX
				self.sharedOptionTargetY = self.ldY
			end
			self.optionTargets[slot] = false
		elseif self.setupGroup == 0 and option1 == 0 then
			offsetX = FOCUSED_GROUP0_WIDE[offsetIndex]
			offsetY = FOCUSED_GROUP0_WIDE[offsetIndex + 1]
			targetAngle = UP_ANGLE
			local canAcquire = self.focusTransition <= -slot * 5 and self.shotTimer >= 1
			if not canAcquire then
				self.optionTargets[slot] = false
			elseif not targetValid(self.optionTargets[slot]) then
				self.optionTargets[slot] = findTarget(
					self.optionX[slot], self.optionY[slot], self, "option")
				if targetValid(self.optionTargets[slot]) then
					targetAngle = 0
					playSound("ld_se_BossSE4", 0.35)
				end
			elseif targetValid(self.optionTargets[slot]) then
				local x, y = targetPosition(self.optionTargets[slot])
				if x and y then
					targetAngle = aim16(self.optionX[slot], self.optionY[slot], x, y)
				end
			end
		elseif self.setupGroup == 0 then
			offsetX = FOCUSED_NARROW[offsetIndex]
			offsetY = FOCUSED_NARROW[offsetIndex + 1]
			targetAngle = FOCUSED_GROUP0_1_ANGLES[slot]
			self.optionTargets[slot] = false
		elseif self.setupGroup == 1 then
			offsetX = FOCUSED_NARROW[offsetIndex]
			offsetY = FOCUSED_NARROW[offsetIndex + 1]
			targetAngle = option1 == 0 and FOCUSED_GROUP1_0_ANGLES[slot] or UP_ANGLES[slot]
			self.optionTargets[slot] = false
		elseif option1 == 0 then
			offsetX = FOCUSED_GROUP2_0[offsetIndex]
			offsetY = FOCUSED_GROUP2_0[offsetIndex + 1]
			targetAngle = self.optionFormationAngle16
			self.optionTargets[slot] = false
		else
			likedreamer_player._advanceSharedTarget(self)
			anchorX, anchorY = self.sharedOptionTargetX, self.sharedOptionTargetY
			offsetX = FOCUSED_GROUP2_1[offsetIndex]
			offsetY = FOCUSED_GROUP2_1[offsetIndex + 1]
			targetAngle = FOCUSED_GROUP2_1_ANGLES[slot]
			self.optionTargets[slot] = false
		end

		local targetX = anchorX + offsetX
		local targetY = anchorY + offsetY
		self.optionX[slot] = self.optionX[slot] + (targetX - self.optionX[slot]) * 0.25
		self.optionY[slot] = self.optionY[slot] + (targetY - self.optionY[slot]) * 0.25
		local current = self.optionAngle16[slot]
		local delta = targetAngle - current
		if delta > 0x8000 then delta = delta - FULL_ANGLE end
		if delta < -0x8000 then delta = delta + FULL_ANGLE end
		self.optionAngle16[slot] = turn16(current, targetAngle, math.floor(math.abs(delta) / 10) + 0x80)
	end
end

function likedreamer_player:_spawnShot(shotType, ldX, ldY, speed, angle16, damage, radius)
	if self.shotCount + self.specialObjectCount >= MAX_PLAYER_SHOTS then
		return
	end
	return New(playerShot, self, shotType, ldX, ldY, speed, angle16, damage, radius)
end

function likedreamer_player:_spawnSpecial(specialType, ldX, ldY, speed, angle16,
		damageOrLifetime, radius)
	if self.shotCount + self.specialObjectCount >= MAX_PLAYER_SHOTS then
		return nil
	end
	return New(playerSpecialObject, self, specialType, ldX, ldY, speed, angle16,
		damageOrLifetime, radius)
end

function likedreamer_player:_emitNormalShot()
	local enhanced = self.shotVariant ~= 0 or self.specialGauge < 0
	local mainType = enhanced and 1 or 0
	local mainSpeed = mainType == 0 and 25 or 40
	local mainDamage = mainType == 0 and 0x82 or 0x96
	local mainRadius = mainType == 0 and 30 or 60
	likedreamer_player._spawnShot(self, mainType, self.ldX + 20, self.ldY - 30,
		mainSpeed, UP_ANGLE, mainDamage, mainRadius)
	likedreamer_player._spawnShot(self, mainType, self.ldX - 20, self.ldY - 30,
		mainSpeed, UP_ANGLE, mainDamage, mainRadius)

	local option0 = clamp(self.optionSlots[1], 0, 1)
	local option1 = clamp(self.optionSlots[2], 0, 1)
	local style = clamp(self.optionSlots[4], 0, 3)
	local powered = self.focused and style >= 2 or (not self.focused and style % 2 == 1)
	local optionType, optionDamage = 0, 0x32
	local optionSpeed = enhanced and 40 or 25
	local muzzleOffset = enhanced and 60 or 40
	local optionRadius = enhanced and 60 or 30

	if not self.focused then
		local alternate = self.setupGroup == 0 and option0 == 1
		if enhanced then
			optionType = alternate and 10 or 4
			optionDamage = alternate and 0x23 or 0x46
		elseif alternate then
			optionType = powered and 9 or 8
			optionDamage = powered and 0x1e or 0x19
		else
			optionType = powered and 3 or 2
			optionDamage = powered and 0x3c or 0x32
		end
	else
		local alternate = self.setupGroup == 1 and option1 == 1
		if enhanced then
			optionType = alternate and 10 or 7
			optionDamage = alternate and 0x3f or 0x46
		elseif alternate then
			optionType = powered and 9 or 8
			optionDamage = powered and 0x36 or 0x2d
		else
			optionType = powered and 6 or 5
			optionDamage = powered and 0x3c or 0x32
		end
		if self.setupGroup == 0 and option1 == 0 then
			optionDamage = enhanced and 0x3f or (powered and 0x36 or 0x2d)
		end
	end
	if not enhanced and powered then
		optionSpeed, muzzleOffset, optionRadius = 30, 50, 45
	end
	for slot = 1, 4 do
		local angle16 = self.optionAngle16[slot]
		local radians = angleRadians(angle16)
		likedreamer_player._spawnShot(self, optionType,
			self.optionX[slot] + math.cos(radians) * muzzleOffset,
			self.optionY[slot] + math.sin(radians) * muzzleOffset,
			optionSpeed, angle16, optionDamage, optionRadius)
	end
	playSound(enhanced and "ld_se_Bomb6" or "ld_se_Shot1", enhanced and 0.5 or 0.3)
end

function likedreamer_player:_updateShot(shootDown, rapidFireDown)
	local rt = runtime()
	local shotLocked = rt.shotLocked or rt.shot_locked or rt.complete or
		(rt.frame or 0) <= (rt.rawStartFrame or 0)
	local firing = self.playerStateTimer < 180 and not shotLocked and
		(shootDown or rapidFireDown)
	if self.playerStateTimer >= 180 or self.bombLock > 0 or shotLocked then
		self.shotTimer = 0
	elseif self.controlModeEnabled == 1 then
		if firing then
			self.shotTimer = self.shotTimer + 1
		elseif self.shotTimer ~= 0 then
			if self.shotTimer % 5 == 4 then
				self.shotTimer = 0
			else
				self.shotTimer = self.shotTimer + 1
			end
		end
	else
		if self.shotTimer ~= 0 then
			self.shotTimer = self.shotTimer + 1
		end
		if firing and self.shotTimer == 0 then
			self.shotTimer = 1
		end
		if not firing and self.shotTimer > 0x10 then
			self.shotTimer = 0
		end
	end
	if self.shotTimer % 5 == 1 then
		likedreamer_player._emitNormalShot(self)
	end
	if self.setupGroup == 0 and self.optionSlots[2] == 0 and
		self.focusTransition < 0 and self.shotTimer == 1 then
		self.focusTransition = -1
	end
end

function likedreamer_player:_startEquippedBomb()
	local roots = { { 0x0b, 0x0e }, { 0x0f, 0x11 }, { 0x12, 0x15 } }
	local speeds = { { 0, 18 }, { 0, 0 }, { 0, 0 } }
	local values = { { 0, 0 }, { 0, 0 }, { 0, 15 } }
	local radii = { { 0, 45 }, { 0, 0 }, { 0, 0 } }
	local locks = { { -210, -210 }, { 1, -180 }, { -210, -270 } }
	local protection = { { 300, 300 }, { 300, 150 }, { 300, 360 } }
	local group = self.setupGroup + 1
	local slot = clamp(self.optionSlots[3], 0, 1) + 1
	likedreamer_player._spawnSpecial(self, roots[group][slot], self.ldX, self.ldY,
		speeds[group][slot], UP_ANGLE, values[group][slot], radii[group][slot])
	self.bombLock = locks[group][slot]
	lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
	self.invulnerableFrames = protection[group][slot]
	LikeDreamer.Reward.spendMental(runtime(),false)
	self.playerStateTimer = 0
	if group == 1 and slot == 2 then playSound("ld_se_Bomb4", 0.5) end
	playSound("ld_se_Bomb1", 0.6)
end

function likedreamer_player:_startFever(manualActivation)
	if manualActivation then
		self.playerStateTimer = 0
		if self.invulnerableFrames > 279 then self.invulnerableFrames = 280 end
	end
	self.specialGauge = -600
	self.bombLock = -120
	self.invulnerableFrames = math.max(self.invulnerableFrames, 150)
	likedreamer_player._spawnSpecial(self, 0x18, self.ldX, self.ldY, 0, 0, 0, 0)
	playSound("ld_se_Fever1", 0.6)
	playSound("ld_se_Fever2", 0.6)
end

function likedreamer_player:_armManualFever()
	self.specialGauge = 9999999
	playSound("ld_se_Fever4", 0.55)
end

function likedreamer_player:_updateBomb()
	local rt = runtime()
	local var = lstg.var or {}
	local manualFever = self.specialMode == 1
	local timerAllowsBomb = self.playerStateTimer < 120 or self.playerStateTimer >= 260
	local invulnerabilityAllowsBomb = self.specialGauge >= 0 or
		self.invulnerableFrames == 0 or self.invulnerableFrames > 279
	local stageClearBombLock = rt.complete or rt.stageClearStarted or
		rt.stage_clear_started or rt.shotLocked or rt.shot_locked
	local triggerAllowed = (rt.frame or 0) > (rt.rawStartFrame or 0) and
		self.bombLock == 0 and
		((var.bomb or 0) > 0 or (manualFever and self.specialGauge >= 50000)) and
		not stageClearBombLock and timerAllowsBomb and invulnerabilityAllowsBomb

	-- FUN_140106be0 tests the action level. bombLock supplies the retrigger edge.
	if KeyIsDown("spell") and triggerAllowed then
		if not manualFever or self.specialGauge < 50000 then
			likedreamer_player._startEquippedBomb(self)
		else
			likedreamer_player._startFever(self, true)
		end
	end
	if self.bombLock ~= 0 then self.bombLock = self.bombLock + 1 end
	if self.bombLock >= 180 then self.bombLock = -30 end
end

local STAGE_END_FRAMES = {
	[1] = 5700, [2] = 9700, [3] = 9500, [4] = 11700, [5] = 11800,
	[6] = 12500, [7] = 12500, [8] = 21420, [9] = 17900, [10] = 12000,
}

function likedreamer_player:_updateSpecialGaugeState(shotTimerBeforeInput)
	local rt = runtime()
	local manualFever = self.specialMode == 1
	if self.specialGauge < 50000 then
		if self.specialGauge < 0 then
			local stageEnd = STAGE_END_FRAMES[rt.stageNumber or rt.stage or 1] or 0
			local hasLiveEnemy = (rt.enemyCount or 0) > 0
			local hasLiveProjectile = (rt.bulletCount or 0) > 0
			local frame = rt.frame or 0
			local timerPaused = (frame < 0xf0 or frame >= stageEnd - 0x14a) and
				not hasLiveEnemy and not hasLiveProjectile
			local idleParityClock = frame
			if (tonumber(rt.specialStageFlag) or 0) ~= 0 then
				idleParityClock = rt.timeWindowElapsedFrames or 0
			end
			if shotTimerBeforeInput == 0 and idleParityClock % 2 ~= 0 then
				timerPaused = true
			end
			if not timerPaused then self.specialGauge = self.specialGauge + 1 end
			if self.specialGauge == 0 then
				playSound("ld_se_Fever3", 0.55)
				likedreamer_player._spawnSpecial(self, 0x18, self.ldX, self.ldY, 0, 0, 0, 0)
			end
		elseif self.specialGauge > 0 and (rt.hudSpecialGaugeFlashTimer or 0) == 0 then
			local stage = rt.stageNumber or rt.stage or 1
			local stageScale = math.max(0.6, 1 - math.floor(stage / 2) * 0.1)
			self.specialGauge = math.max(0,
				self.specialGauge + math.ceil(stageScale * -50))
		end
	elseif not manualFever then
		likedreamer_player._startFever(self, false)
	elseif self.specialGauge <= 9999998 then
		likedreamer_player._armManualFever(self)
	end
	rt.specialGauge = self.specialGauge
	rt.special_gauge = self.specialGauge
	if lstg.var then lstg.var.like_dreamer_special_gauge = self.specialGauge end
end

function likedreamer_player:_takeHit(other)
	if cheat or self.lock or self.dialog or (self.protect or 0)>0 then return end
	if other and (other.group == GROUP_ENEMY_BULLET or other.group == GROUP_ENEMY_BULLET2) and lstg.IsValid(other) then
		local projectile = LikeDreamer.Projectile
		if projectile and other.class == projectile.Class and
				type(projectile.hitPlayer) == "function" then
			projectile.hitPlayer(other)
		else
			other.active = false
			other.collisionEnabled = false
			Del(other)
		end
	end
	if self.invulnerableFrames > 0 or self.playerStateTimer >= 180 then
		return
	end
	self.playerStateTimer = 280
	self.invulnerableFrames = 300
	playSound("ld_se_Miss", 0.7)
end

function likedreamer_player:_settleDeath()
	if self.playerStateTimer ~= 260 then
		return
	end
	local var = lstg.var or {}
	local style = clamp(self.optionSlots[4], 0, 3)
	if (var.bomb or 0) > 0 and style ~= 3 then
		local stock = clamp(var.bomb, 0, 3)
		local guardRadius = style == 0 and 240 or ({ 0, 240, 320, 480 })[stock + 1]
		likedreamer_player._spawnSpecial(self, 0x16, self.ldX, self.ldY, 0, 0, 0, guardRadius)
		LikeDreamer.Reward.spendMental(runtime(),style~=0)
		var.bomb_used=(var.bomb_used or 0)+1
		self.playerStateTimer = 0
		self.bombLock = -120
		self.invulnerableFrames = math.max(self.invulnerableFrames, 150)
		return
	end

	self.shotVariant = 0
	local lives = var.lifeleft or 0
	if lives ~= 0 and (runtime().routeMode or 0) ~= -1 and rawget(_G, "item_bomb") then
		local dropCount = self.beingShotCount > 1 and 2 or 1
		for _ = 1, dropCount do New(item_bomb, self.x, self.y) end
	end
	self.beingShotCount = self.beingShotCount + 1
	if lives > 0 then
		var.lifeleft = var.lifeleft - 1
		local rt = runtime()
		if rt.clearEnemyBullets then
			rt.clearEnemyBullets(false)
		end
		if rt.onPlayerMiss then
			rt.onPlayerMiss(self)
		end
	else
		local rt = runtime()
		if rt.onGameOver then
			rt.onGameOver(self)
		end
	end
end

function likedreamer_player:_updateVisualFrame()
	local base = self.setupGroup * 30
	if self.lateralAnimation == 0 then
		self.visualFrame = base + animationFrame(self.animationClock, 0, 7, { 0, 1, 2, 1 })
	elseif self.lateralAnimation > 0 and self.lateralAnimation < 12 then
		self.visualFrame = base + animationFrame(self.lateralAnimation, 0, 6, { 3, 4, 5 })
	elseif self.lateralAnimation >= 12 then
		self.visualFrame = base + animationFrame(self.animationClock, 12, 7, { 5, 6, 7 })
	elseif self.lateralAnimation > -12 then
		self.visualFrame = base + animationFrame(-self.lateralAnimation, 0, 6, { 8, 9, 10 })
	else
		self.visualFrame = base + animationFrame(self.animationClock, 12, 7, { 10, 11, 12 })
	end
	self.img = "ld_player_" .. (self.visualFrame + 1)
end

function likedreamer_player:frame()
    if not LikeDreamer.runtime or not LikeDreamer.runtime.stage or self.lock then return end
    self._touch_movement_used=nil
    if (self.protect or 0)>0 then self.protect=self.protect-1 end
	self.drawAnimationClock = self.animationClock
	self.shotVariantAuraScale = 0
	local shotTimerBeforeInput = self.shotTimer
	local shootDown = KeyIsDown("shoot")
	local rapidFireDown = KeyIsDown("special")
	local slowDown = KeyIsDown("slow")
	local frameRuntime = runtime()
	self.specialGauge = frameRuntime.specialGauge or frameRuntime.special_gauge or self.specialGauge

	likedreamer_player._updateFocus(self, shootDown, rapidFireDown, slowDown)
	self.slow=self.focused and 1 or 0
	local moved = likedreamer_player._updateMovement(self)
	local rt = runtime()
	rt.cameraX = self.ldX
	rt.player = self
	likedreamer_player._updateOptions(self)
	likedreamer_player._updateShot(self, shootDown, rapidFireDown)
	likedreamer_player._updateBomb(self)
	likedreamer_player._settleDeath(self)
	likedreamer_player._updateVisualFrame(self)

	if moved and not self.focused and self.animationClock % 2 == 0 then
		New(playerAfterimage, self, self.ldX, self.ldY, self.img)
	end
	if self.setupGroup == 1 and self.optionSlots[3] == 1 and self.shotVariant > 0 then
		self.shotVariantAuraScale = self.shotVariant / 600
		self.shotVariant = self.shotVariant - 1
	end
	if self.playerStateTimer > 0 then
		self.playerStateTimer = self.playerStateTimer - 1
	end
	likedreamer_player._updateSpecialGaugeState(self, shotTimerBeforeInput)
	if self.invulnerableFrames > 0 then
		self.invulnerableFrames = self.invulnerableFrames - 1
	end
	self.hide = self.playerStateTimer >= 180 and self.playerStateTimer < 260
	self.x, self.y = toWorld(self.ldX, self.ldY, self)
	local hitRadius = (self.focusTransition + 2 < 0 or self.focusTransition + 2 > 4) and 3 or 4
	self.a = hitRadius*LikeDreamer.Core.worldScale()
	self.b = hitRadius*LikeDreamer.Core.worldScaleY()
	if rt.frame < 60 then
		self.hitboxScale = 0
	elseif rt.frame < 90 then
		self.hitboxScale = math.sin((rt.frame - 60) * PI / 60)
	else
		self.hitboxScale = 1
	end
	self.animationClock = self.animationClock + 1
end

local function overlayImageExists(name)
	return not lstg.CheckRes or lstg.CheckRes(2, name)
end

local function resetOverlayImage(name)
	SetImageState(name, "", Color(255, 255, 255, 255))
end

local function feverColor(clock)
	local colorIndex = math.floor(clock / 20) % #FEVER_COLORS + 1
	local nextIndex = colorIndex % #FEVER_COLORS + 1
	local step = clock % 20
	local color = {}
	for channel = 1, 3 do
		local current = FEVER_COLORS[colorIndex][channel]
		local nextValue = FEVER_COLORS[nextIndex][channel]
		color[channel] = math.floor(current - (current - nextValue) / 20 * step)
	end
	return color
end

local function renderDreamGaugeFill(x, y, percent, red, green, blue)
	if percent <= 0 or not overlayImageExists("ld_dream_gauge_2") then return end
	local renderTexture = rawget(_G, "RenderTexture") or lstg.RenderTexture
	if not renderTexture then
		SetImageState("ld_dream_gauge_2", "", Color(128, red, green, blue))
		Render("ld_dream_gauge_2", x, y, 0, 1, 1)
		resetOverlayImage("ld_dream_gauge_2")
		return
	end
	local fraction = clamp(percent / 100, 0, 1)
	local segments = math.max(1, math.ceil(fraction * 8))
	local logicalScale = LikeDreamer.Core and LikeDreamer.Core.SCALE or (28 / 45)
	local sourceCenterX, sourceCenterY, sourceRadius = 240, 80, 80
	local color = Color(128, red, green, blue)
	for index = 0, segments - 1 do
		local start = index / 8 * TAU - PI * 0.5
		local finish = math.min((index + 1) / 8, fraction) * TAU - PI * 0.5
		local c1, s1 = math.cos(start), math.sin(start)
		local c2, s2 = math.cos(finish), math.sin(finish)
		local edge1 = sourceRadius / math.max(math.abs(c1), math.abs(s1))
		local edge2 = sourceRadius / math.max(math.abs(c2), math.abs(s2))
		local dx1, dy1 = c1 * edge1, s1 * edge1
		local dx2, dy2 = c2 * edge2, s2 * edge2
		renderTexture("ld_tex_dream_gauge", "",
			{ x, y, 0.5, sourceCenterX, sourceCenterY, color },
			{ x + dx1 * logicalScale, y - dy1 * logicalScale, 0.5,
				sourceCenterX + dx1, sourceCenterY + dy1, color },
			{ x + dx2 * logicalScale, y - dy2 * logicalScale, 0.5,
				sourceCenterX + dx2, sourceCenterY + dy2, color },
			{ x, y, 0.5, sourceCenterX, sourceCenterY, color })
	end
end

function likedreamer_player:_renderOverlay(pass)
	if self.hide or (self.playerStateTimer >= 180 and self.playerStateTimer < 260) then
		return
	end
	local clock = math.max(0, self.drawAnimationClock or 0)
	if pass == "marker" then
		if self.setupGroup ~= 0 or clamp(self.optionSlots[2], 0, 1) ~= 0 or
				not self.focused or not overlayImageExists("ld_player_fx_m_17") then
			return
		end
		local image = "ld_player_fx_m_17"
		SetImageState(image, "", Color(64, 255, 64, 64))
		for slot = 1, 4 do
			local target = self.optionTargets[slot]
			if targetValid(target) and target.targetable ~= false then
				local targetX, targetY = targetPosition(target)
				local radius = targetRadius(target)
				if targetX and targetY and radius > 0 then
					local x, y = toWorld(targetX, targetY, self)
					local pulse = radius / 100 * (1 + 0.1 * math.sin(clock * PI / 5))
					Render(image, x, y, angleDegrees(normalize16(clock * 0x29a)),
						1 * pulse, 1 * pulse)
				end
			end
		end
		resetOverlayImage(image)
		return
	end

	if pass == "gauge_fill" or pass == "gauge_frame" then
		local rt = runtime()
		local stage = tonumber(rt.stageNumber or rt.stage) or 1
		local shade = (stage == 2 or stage == 6 or stage == 10) and 0x60 or
			(stage == 1 and 0x80 or 0xff)
		local var = lstg.var or {}
		local stock = clamp(math.floor(tonumber(var.bomb or self.tokenStock or rt.tokenStock) or 0), 0, 3)
		local threshold = STOCK_THRESHOLDS[clamp(math.floor(tonumber(rt.difficulty) or 1), 0, 4) + 1]
		local percent = 100
		if stock < 3 and threshold > 0 then
			percent = clamp(((tonumber(rt.stockProgress) or stock * threshold) -
				stock * threshold) / threshold * 100, 0, 100)
		end
		if pass == "gauge_fill" then
			local red, green, blue = shade, shade, shade
			if stock == 1 then
				red, green, blue = 0x80, 0xff, 0x80
			elseif stock == 2 then
				red, green, blue = 0x80, 0xff, 0xff
			elseif stock == 3 then
				red, green, blue = clock % 2 == 0 and 0x80 or 0xff, 0xff, 0xff
			end
			renderDreamGaugeFill(self.x, self.y, percent, red, green, blue)
		elseif overlayImageExists("ld_dream_gauge_1") then
			SetImageState("ld_dream_gauge_1", "", Color(128, shade, shade, shade))
			Render("ld_dream_gauge_1", self.x, self.y,
				angleDegrees(normalize16(-clock * 0x100)), 1, 1)
			resetOverlayImage("ld_dream_gauge_1")
		end
		return
	end

	if pass == "aura" then
		if not overlayImageExists("ld_enemy_gauge_fill") then return end
		local _, y = toWorld(self.ldX, self.ldY + 80, self)
		local function drawAura(scaleX, red, green, blue)
			if scaleX <= 0 then return end
			SetImageState("ld_enemy_gauge_fill", "", Color(255, red, green, blue))
			Render("ld_enemy_gauge_fill", self.x, y, 0,
				1 * scaleX, 1)
			resetOverlayImage("ld_enemy_gauge_fill")
		end
		drawAura(self.shotVariantAuraScale or 0, 255, 64, 64)
		if self.specialGauge < 0 then
			local color = feverColor(clock)
			drawAura(-self.specialGauge / 600, color[1], color[2], color[3])
		end
		return
	end

	if pass == "hitbox" and self.hitboxScale > 0 and
			overlayImageExists("ld_player_14") then
		Render("ld_player_14", self.x, self.y,
			angleDegrees(normalize16(clock * 0x3c0)),
			1 * self.hitboxScale, 1 * self.hitboxScale)
	end
end

function likedreamer_player:render()
	if not LikeDreamer.runtime then return end
	local scale = 1
	if not self.hide then
		Render(self.img, self.x, self.y, 0, scale, scale)
		if self.specialGauge < 0 or self.specialGauge >= 50000 then
			local colorClock = math.max(0, self.drawAnimationClock)
			local colorIndex = math.floor(colorClock / 20) % #FEVER_COLORS + 1
			local nextIndex = colorIndex % #FEVER_COLORS + 1
			local step = colorClock % 20
			local color = {}
			for channel = 1, 3 do
				local current = FEVER_COLORS[colorIndex][channel]
				local nextValue = FEVER_COLORS[nextIndex][channel]
				color[channel] = math.floor(current - (current - nextValue) / 20 * step)
			end
			local alpha = math.floor(96 + math.sin(colorClock * PI / 15) * 96)
			SetImageState(self.img, "mul+add",
				Color(clamp(alpha, 0, 255), color[1], color[2], color[3]))
			Render(self.img, self.x, self.y, 0, scale, scale)
			SetImageState(self.img, "", Color(255, 255, 255, 255))
		end
		if self.invulnerableFrames > 0 and self.drawAnimationClock % 2 == 0 then
			local overlay = "ld_player_" .. (self.visualFrame + 16)
			Render(overlay, self.x, self.y, 0, scale, scale)
		end
		if self.playerStateTimer > 259 and lstg.CheckRes(2, "ld_effect_m_5") then
			local hitScale = (self.playerStateTimer - 260) * 0.05
			SetImageState("ld_effect_m_5", "", Color(255, 255, 0, 0))
			Render("ld_effect_m_5", self.x, self.y, 0,
				scale * hitScale, scale * hitScale)
			SetImageState("ld_effect_m_5", "", Color(255, 255, 255, 255))
		end
	end

	local optionFrame
	if self.setupGroup == 0 then
		optionFrame = 0x5a + (math.floor(self.drawAnimationClock / 6) % 5)
	elseif self.setupGroup == 1 then
		local frames = { 0x5f, 0x60, 0x61, 0x60 }
		optionFrame = frames[(math.floor(self.drawAnimationClock / 6) % 4) + 1]
	else
		optionFrame = 0x62 + (math.floor(self.drawAnimationClock / 6) % 5)
	end
	local optionImage = "ld_player_" .. (optionFrame + 1)
	for slot = 1, 4 do
		local x, y = toWorld(self.optionX[slot], self.optionY[slot], self)
		Render(optionImage, x, y, angleDegrees(self.optionAngle16[slot]),
			scale * self.optionDrawScale, scale * self.optionDrawScale)
	end

end

function likedreamer_player:colli(other)
	likedreamer_player._takeHit(self, other)
end

function likedreamer_player:kill()
	likedreamer_player._takeHit(self, nil)
	object.Preserve(self)
end

function likedreamer_player:del()
	object.Preserve(self)
end

return likedreamer_player
