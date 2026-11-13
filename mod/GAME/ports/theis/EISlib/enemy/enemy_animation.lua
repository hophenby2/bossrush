---=====================================
---小怪行走图
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

local ipairs = ipairs
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil
local Color = lstg.Color
local SetImageState = lstg.SetImageState
local Render = lstg.Render

----------------------------------------
---enemy walk image

---@class EISlib.Enemy.WalkImageSystem : etc.class
local wisys = etc.class(false, false)

local wisys_default_image = "img_void"
local wisys_default_aniv = 8
local wisys_default_action = { hflip = false, vflip = false }
local wisys_default_cache = { wisys_default_image }

---@param obj lstg.GameObject
---@param images string @prefix of a series of images
---@param aniv number @default to 8
---@return EISlib.Enemy.WalkImageSystem
function wisys:constructor(obj, images, aniv)
	self.obj = obj
	self.img = images or wisys_default_image
	self.aniv = aniv or wisys_default_aniv
	self.lr = 0
	self.hscale = 1
	self.vscale = 1
	self.alpha = 1
	self.hflip = 1
	self.vflip = 1
	self.normal_ani = 0
	self.loop_ani = 0
	self.imgindex = {
		normal = wisys_default_action,
		left = wisys_default_action,
		leftloop = wisys_default_action,
		right = wisys_default_action,
		rightloop = wisys_default_action,
		cast = wisys_default_action,
		castloop = wisys_default_action,
	}
	self.imgs = {
		normal = wisys_default_cache,
		left = wisys_default_cache,
		leftloop = wisys_default_cache,
		right = wisys_default_cache,
		rightloop = wisys_default_cache,
		cast = wisys_default_cache,
		castloop = wisys_default_cache,
	}
	self.targetimg = wisys_default_image
	self.normaln = 0
	self.leftn = 0
	self.rightn = 0
	self.leftloopn = 0
	self.rightloopn = 0
	self.normalv = 0
	self.leftv = 0
	self.rightv = 0
	self.leftloopv = 0
	self.rightloopv = 0
	self.dirty = false
	return self
end

function wisys:updateIndex()
	self.normaln = #self.imgindex.normal
	self.leftn = #self.imgindex.left
	self.rightn = #self.imgindex.right
	self.leftloopn = #self.imgindex.leftloop
	self.rightloopn = #self.imgindex.rightloop
	self.normalv = self.normaln * self.aniv
	self.leftv = self.leftn * 2
	self.rightv = self.rightn * 2
	self.leftloopv = self.leftloopn * self.aniv
	self.rightloopv = self.rightloopn * self.aniv
end

---make resource string cache
function wisys:makeCache()
	local imgs = self.imgs
	imgs.normal = {}
	for i, v in ipairs(self.imgindex.normal) do
		imgs.normal[i] = self.img .. v
	end
	imgs.left = {}
	for i, v in ipairs(self.imgindex.left) do
		imgs.left[i] = self.img .. v
	end
	imgs.right = {}
	for i, v in ipairs(self.imgindex.right) do
		imgs.right[i] = self.img .. v
	end
	imgs.leftloop = {}
	for i, v in ipairs(self.imgindex.leftloop) do
		imgs.leftloop[i] = self.img .. v
	end
	imgs.rightloop = {}
	for i, v in ipairs(self.imgindex.rightloop) do
		imgs.rightloop[i] = self.img .. v
	end
end

---@param h number @default to 1
---@param v number @default to h
function wisys:setScale(h, v)
	self.hscale = h or 1
	self.vscale = v or self.hscale
end

---@param a number @default to 1
function wisys:setAlpha(a)
	a = a or 1
	self.alpha = a
end

---@param action string | '"normal"' | '"left"' | '"right"' | '"leftloop"' | '"rightloop"'
---@param hflip boolean @default to false
---@param vflip boolean @default to false
function wisys:setAction(action, hflip, vflip, ...)
	local args = { ... }
	args.hflip = hflip
	args.vflip = vflip
	self.imgindex[action] = args
	self.dirty = true
end

---@param images string @prefix of a series of images
---@param aniv number @default to 8
function wisys:setImages(images, aniv)
	self.img = images
	self.aniv = aniv or wisys_default_aniv
	self.dirty = true
	self:updateImage()
end

function wisys:updateImage()
	if self.dirty then
		self:updateIndex()
		self:makeCache()
		self.dirty = false
	end
	--local obj = self.obj
	local imgindex = self.imgindex.normal
	local imgs = self.imgs.normal
	local selectindex = 1
	if self.lr == 0 then
		--imgindex = self.imgindex.normal
		--imgs = self.imgs.normal
		local timer = floor(self.normal_ani / self.aniv)
		selectindex = ((timer - 1) % self.normaln) + 1
	elseif self.lr >= self.rightv then
		imgindex = self.imgindex.rightloop
		imgs = self.imgs.rightloop
		local timer = floor(self.loop_ani / self.aniv)
		selectindex = ((timer - 1) % self.rightloopn) + 1
	elseif self.lr <= (-self.leftv) then
		imgindex = self.imgindex.leftloop
		imgs = self.imgs.leftloop
		local timer = floor(self.loop_ani / self.aniv)
		selectindex = ((timer - 1) % self.leftloopn) + 1
	elseif self.lr > 0 then
		imgindex = self.imgindex.right
		imgs = self.imgs.right
		selectindex = ceil(self.lr / self.aniv)
	elseif self.lr < 0 then
		imgindex = self.imgindex.left
		imgs = self.imgs.left
		selectindex = ceil(-self.lr / self.aniv)
	end
	if (#imgindex) > 0 then
		self.targetimg = imgs[selectindex]
		if imgindex.hflip then
			self.hflip = -1
		else
			self.hflip = 1
		end
		if imgindex.vflip then
			self.vflip = -1
		else
			self.vflip = 1
		end
	else
		self.targetimg = wisys_default_image
	end
end

function wisys:update()
	local obj = self.obj
	if obj.dx > 0.1 then
		self.lr = self.lr + 1
		self.lr = min(self.lr, self.rightv)
	elseif obj.dx < (-0.1) then
		self.lr = self.lr - 1
		self.lr = max(self.lr, -self.leftv)
	else
		if self.lr > 0 then
			self.lr = self.lr - 1
		elseif self.lr < 0 then
			self.lr = self.lr + 1
		end
	end
	self:updateImage()
	if self.lr >= self.rightv or self.lr <= (-self.leftv) then
		self.loop_ani = self.loop_ani + 1
	elseif self.lr == 0 then
		self.normal_ani = self.normal_ani + 1
	else
		self.normal_ani = 0
		self.loop_ani = 0
	end
end

---@param dmgt number @[[0, maxdmgt]]
---@param maxdmgt number
function wisys:draw(dmgt, maxdmgt)
	local obj = self.obj
	local c = 0
	if dmgt and maxdmgt then
		c = dmgt / maxdmgt
	end
	if obj._blend then
		SetImageState(self.targetimg, obj._blend, Color(self.alpha * obj._a, obj._r - obj._r * 0.75 * c, obj._g - obj._g * 0.75 * c, obj._b))
	else
		SetImageState(self.targetimg, "", Color(self.alpha * 255, 255 - 255 * 0.75 * c, 255 - 255 * 0.75 * c, 255))
	end
	Render(self.targetimg, obj.x, obj.y, obj.rot, self.hscale * self.hflip * obj.hscale, self.vscale * self.vflip * obj.vscale)
end

return wisys
