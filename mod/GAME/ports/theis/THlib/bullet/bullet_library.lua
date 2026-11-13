---=====================================
---弹型库
---=====================================

---弹型库管理
---@class BulletLibrary
local library = {}

---弹型库
---@type table<string|number, table>
library.styles = {}

---using队列
---@type string[]|number[]
library.styleArray = {}

local MIN_FLOAT = 0.01
local abs = math.abs
local floor = math.floor
local min = math.min
local max = math.max
local SetImgState = lstg.SetImgState
local SetImageState = lstg.SetImageState
local BoxCheck = lstg.BoxCheck
local Render = lstg.Render
local DefaultRenderFunc = lstg.DefaultRenderFunc
local RegisterClass = lstg.RegisterClass

----------------------------------------
---基本弹型

local bullet_class = Class(object)

function bullet_class:init(imgclass, index, stay, destroyable)
	--class
	self.logclass = self.class
	self.imgclass = imgclass
	--des
	if destroyable then
		self.group = GROUP_ENEMY_BULLET
	else
		self.group = GROUP_INDES
	end
	--color
	index = min(max(1, index), 16)
	self._index = index
	self.index = floor((index + 1) / 2)
	--stay
	self.stay = stay
	--imgclass stage
	self.class = imgclass
	imgclass.init(self, index)
end

function bullet_class:frame()
	task.Do(self)
end

function bullet_class:render()
	if self._blend then
		SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
		DefaultRenderFunc(self)
		SetImgState(self, '', 255, 255, 255, 255)
	else
		DefaultRenderFunc(self)
	end
end

function bullet_class:del()
	local w = lstg.world
	if self.imgclass.size >= 2.0 then
		self.imgclass.del(self)
	elseif BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt) then
		New(BulletBreak, self.x, self.y, self._index, self.imgclass.size * max(self.hscale, self.vscale))
	end
end

function bullet_class:kill()
	local w = lstg.world
	if self.imgclass.size >= 2.0 then
		self.imgclass.del(self)
	elseif BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt) then
		New(item_faith_minor, self.x, self.y)
		New(BulletBreak, self.x, self.y, self._index, self.imgclass.size * max(self.hscale, self.vscale))
	end
end

bullet = bullet_class

----------------------------------------
---消失

local bubble = RenderClass(object)

function bubble:init(img, x, y, rot, vx, vy, life_time, hsize1, vsize1, hsize2, vsize2, color1, color2, layer, blend)
	self.img = img
	self.x = x
	self.y = y
	self.rot = rot
	self.vx = vx
	self.vy = vy
	self.group = GROUP_GHOST
	self.life_time = life_time
	self.hsize1 = hsize1
	self.vsize1 = vsize1
	self.hsize2 = hsize2
	self.vsize2 = vsize2
	self.color1 = color1
	self.color2 = color2
	self.layer = layer
	self._blend = blend or ""
	self._color = color1
end

function bubble:frame()
	local t = (self.life_time - self.timer) / self.life_time
	self.hscale = self.hsize1 * t + self.hsize2 * (1 - t)
	self.vscale = self.vsize1 * t + self.vsize2 * (1 - t)
	self._color = self.color1 * t + self.color2 * (1 - t)
	if self.timer >= self.life_time - 1 then
		self.status = "del"
	end
end

----------------------------------------
---定义弹型

---检查是否存在某弹型库
local function checkLibrary(libraryName)
	if type(library.styles[libraryName]) ~= "table" then
		library.styles[libraryName] = {}
	end
end

---雾化贴图
local _preimg = {}
for i = 1, 16 do
	_preimg[i] = "preimg" .. i
end

---弹型class生成，适用于原版普通弹型
---@param classImage string @使用的贴图资源
---@param colorCount number @颜色种类数目
---@param classSize number|nil @弹型相对大小，默认为0.7（适用于16x16单位的弹型）
---@param a number
---@param b number
---@param rect boolean
---@param lighttype boolean
function library.classCreatorBase(classImage, colorCount, classSize, a, b, rect, lighttype)
	classSize = classSize or 0.7
	a = a or 0
	b = b or 0
	if type(rect) ~= "boolean" then
		rect = false
	end
	if type(lighttype) ~= "boolean" then
		lighttype = false
	end
	local fogtime = 11
	--class
	local image_class = Class(object)
	image_class.size = classSize
	image_class.img = classImage
	image_class.a = a
	image_class.b = b
	image_class.rect = rect
	--region init callback funcion
	if colorCount == 16 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. index
			self.a = a
			self.b = b
			self.rect = rect
		end
	elseif colorCount == 8 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. floor((index + 1) / 2)
			self.a = a
			self.b = b
			self.rect = rect
		end
	elseif colorCount == 4 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. floor((index + 1) / 4)
			self.a = a
			self.b = b
			self.rect = rect
		end
	end
	--endregion
	--frame
	function image_class:frame()
		if not self.stay then
			self.logclass.frame(self)
		else
			self.x = self.x - self.vx
			self.y = self.y - self.vy
			self.rot = self.rot - self.omiga
		end
		if self.timer >= fogtime then
			self.class = self.logclass
			self.layer = LAYER_ENEMY_BULLET - classSize * 0.001 + self._index * 0.00001
			if self.stay then
				self.timer = -1
			end
		end
	end
	--region render callback function
	local _fogscale = {}
	local _fogcolor = {}
	for t = 0, (fogtime + 1) do
		_fogcolor[t] = Color(255 * t / fogtime, 255, 255, 255)
		_fogscale[t] = ((fogtime - t) / fogtime * 3 + 1) * classSize
	end
	local _blend = ""
	if lighttype then
		_blend = "mul+add"
	end
	function image_class:render()
		local img = _preimg[self._index]
		if self._blend then
			SetImageState(img, self._blend, _fogcolor[self.timer])
		else
			SetImageState(img, _blend, _fogcolor[self.timer])
		end
		Render(img, self.x, self.y, self.rot, _fogscale[self.timer] * self.hscale, _fogscale[self.timer] * self.vscale)
	end
	--endregion
	--del
	function image_class:del()
		New(bubble,
				_preimg[self._index],
				self.x, self.y, self.rot, self.dx, self.dy,
				fogtime,
				classSize * self.hscale, classSize * self.vscale, 0, 0,
				Color(0xFFFFFFFF), Color(0xFFFFFFFF),
				self.layer, "mul+add")
	end
	--kill
	function image_class:kill()
		image_class.del(self)
		New(item_faith_minor, self.x, self.y)
	end

	RegisterClass(image_class)
	return image_class
end

---弹型class生成，适用于原版大弹型，高光
---@param classImage string @使用的贴图资源
---@param fadeImage string @雾化、消弹贴图资源
---@param colorCount number @颜色种类数目
---@param classSize number|nil @雾化相对大小，默认为1.0（等于自身大小）
---@param a number
---@param b number
---@param rect boolean
---@param darktype boolean @非高光类型
function library.classCreatorBaseHuge(classImage, fadeImage, colorCount, classSize, a, b, rect, darktype)
	classSize = classSize or 1.0
	a = a or 0
	b = b or 0
	if type(rect) ~= "boolean" then
		rect = false
	end
	local fogtime = 11
	local fadetime = 15--!
	--class
	local image_class = Class(object)
	image_class.size = classSize
	image_class.img = classImage
	image_class.fadeimg = fadeImage
	image_class.a = a
	image_class.b = b
	image_class.rect = rect
	--region init callback function
	if colorCount == 16 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. index
			self._fadeimg = fadeImage .. index
			self.a = a
			self.b = b
			self.rect = rect
		end
	elseif colorCount == 8 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. floor((index + 1) / 2)
			self._fadeimg = fadeImage .. floor((index + 1) / 2)
			self.a = a
			self.b = b
			self.rect = rect
		end
	elseif colorCount == 4 then
		function image_class:init(index)
			self.layer = LAYER_ENEMY_BULLET_EF - classSize * 0.001 + index * 0.00001
			self.img = classImage .. floor((index + 1) / 4)
			self._fadeimg = fadeImage .. floor((index + 1) / 4)
			self.a = a
			self.b = b
			self.rect = rect
		end
	end
	--endregion
	--frame
	function image_class:frame()
		if not self.stay then
			self.logclass.frame(self)
		else
			self.x = self.x - self.vx
			self.y = self.y - self.vy
			self.rot = self.rot - self.omiga
		end
		if self.timer >= fogtime then
			self.class = self.logclass
			self.layer = LAYER_ENEMY_BULLET - 2.0 + self.index * 0.00001
			if self.stay then
				self.timer = -1
			end
		end
	end
	--region render callback function
	local _fogscale = {}
	local _fogcolor = {}
	for t = 0, (fogtime + 1) do
		_fogcolor[t] = Color(255 * t / fogtime, 255, 255, 255)
		_fogscale[t] = ((fogtime - t) / fogtime + 1)
	end
	if not darktype then
		function image_class:render()
			SetImageState(self._fadeimg, "mul+add", _fogcolor[self.timer])
			Render(self._fadeimg, self.x, self.y, self.rot, _fogscale[self.timer] * self.hscale, _fogscale[self.timer] * self.vscale)
		end
	else
		function image_class:render()
			SetImageState(self._fadeimg, "", _fogcolor[self.timer])
			Render(self._fadeimg, self.x, self.y, self.rot, _fogscale[self.timer] * self.hscale, _fogscale[self.timer] * self.vscale)
		end
	end
	--endregion
	--region del callback function
	local _blend = "mul+add"
	if darktype then
		_blend = ""
	end
	function image_class:del()
		local _bt = self._blend or _blend
		New(bubble,
				self._fadeimg,
				self.x, self.y, self.rot, self.dx, self.dy,
				fadetime,
				self.hscale, self.vscale, 0, 0,
				Color(0xFFFFFFFF), Color(0xFFFFFFFF),
				self.layer, _bt)
	end
	--endregion
	--kill
	image_class.kill = image_class.del

	RegisterClass(image_class)
	return image_class
end

---弹型class生成
---@param classImage string @使用的贴图资源
---@param colorCount number @颜色种类数目
---@param classSize number|nil @弹型相对大小，默认为0.7（适用于16x16单位的弹型）
---@param a number
---@param b number
---@param rect boolean
---@param fogtime number
---@param fogblend string
---@param deadblend string
function library.classCreator(classImage, colorCount, classSize, a, b, rect, fogtime, fogblend, deadblend)
	--class
	local image_class = Class(object)
	image_class.size = classSize or 0.7
	image_class.img = classImage
	image_class.a = a
	image_class.b = b
	image_class.rect = rect
	image_class.fogtime = fogtime
	image_class.fogblend = fogblend
	image_class.deadblend = deadblend
	--var
	fogtime = fogtime or 11
	local _fogscale = {}
	local _fogcolor = {}
	for t = 0, fogtime do
		_fogcolor[t] = Color(255 * t / fogtime, 255, 255, 255)
		_fogscale[t] = ((fogtime - t) / fogtime * 3 + 1) * classSize
	end
	--init
	if fogtime > 0 then
		if colorCount == 16 then
			function image_class:init(index)
				self.layer = LAYER_ENEMY_BULLET_EF - image_class.size * 0.001 + index * 0.00001
				self.img = classImage .. index
				self.a = a
				self.b = b
				self.rect = rect
			end
		elseif colorCount == 8 then
			function image_class:init(index)
				self.layer = LAYER_ENEMY_BULLET_EF - image_class.size * 0.001 + index * 0.00001
				self.img = classImage .. floor((index + 1) / 2)
				self.a = a
				self.b = b
				self.rect = rect
			end
		elseif colorCount == 4 then
			function image_class:init(index)
				self.layer = LAYER_ENEMY_BULLET_EF - image_class.size * 0.001 + index * 0.00001
				self.img = classImage .. floor((index + 1) / 4)
				self.a = a
				self.b = b
				self.rect = rect
			end
		end
	else
		if colorCount == 16 then
			function image_class:init(index)
				self.img = classImage .. index
				self.a = a
				self.b = b
				self.rect = rect
				self.class = self.logclass
				self.layer = LAYER_ENEMY_BULLET - self.imgclass.size * 0.001 + self._index * 0.00001
			end
		elseif colorCount == 8 then
			function image_class:init(index)
				self.img = classImage .. floor((index + 1) / 2)
				self.a = a
				self.b = b
				self.rect = rect
				self.class = self.logclass
				self.layer = LAYER_ENEMY_BULLET - self.imgclass.size * 0.001 + self._index * 0.00001
			end
		elseif colorCount == 4 then
			function image_class:init(index)
				self.img = classImage .. floor((index + 1) / 4)
				self.a = a
				self.b = b
				self.rect = rect
				self.class = self.logclass
				self.layer = LAYER_ENEMY_BULLET - self.imgclass.size * 0.001 + self._index * 0.00001
			end
		end
	end
	--frame
	function image_class:frame()
		if not self.stay then
			self.logclass.frame(self)
		else
			self.x = self.x - self.vx
			self.y = self.y - self.vy
			self.rot = self.rot - self.omiga
		end
		if self.timer >= fogtime then
			self.class = self.logclass
			self.layer = LAYER_ENEMY_BULLET - self.imgclass.size * 0.001 + self._index * 0.00001
			if self.stay then
				self.timer = -1
			end
		end
	end
	--render
	if fogblend then
		function image_class:render()
			SetImageState('preimg' .. self.index, fogblend, _fogcolor[self.timer])
			Render('preimg' .. self.index, self.x, self.y, self.rot, _fogscale[self.timer])
		end
	else
		function image_class:render()
			if self._blend and self._a and self._r and self._g and self._b then
				SetImageState('preimg' .. self.index, self._blend, Color(self._a * self.timer / fogtime, self._r, self._g, self._b))
			else
				SetImageState('preimg' .. self.index, "", _fogcolor[self.timer])
			end
			Render('preimg' .. self.index, self.x, self.y, self.rot, _fogscale[self.timer])
		end
	end
	--del
	if deadblend then
		function image_class:del()
			local _vx, _vy = self.dx, self.dy
			if abs(self.dx) < MIN_FLOAT then
				_vx = self.vx
			end
			if abs(self.dy) < MIN_FLOAT then
				_vy = self.vy
			end
			New(bubble2, 'preimg' .. self.index,
					self.x, self.y, _vx, _vy,
					fogtime, self.imgclass.size, 0, Color(0xFFFFFFFF), Color(0xFFFFFFFF),
					self.layer, deadblend)
		end
	else
		function image_class:del()
			local _vx, _vy = self.dx, self.dy
			if abs(self.dx) < MIN_FLOAT then
				_vx = self.vx
			end
			if abs(self.dy) < MIN_FLOAT then
				_vy = self.vy
			end
			if self._blend and self._a and self._r and self._g and self._b then
				local _color = Color(self._a, self._r, self._g, self._b)
				New(bubble2, 'preimg' .. self.index,
						self.x, self.y, _vx, _vy,
						fogtime, self.imgclass.size, 0, _color, _color,
						self.layer, self._blend)
			else
				New(bubble2, 'preimg' .. self.index,
						self.x, self.y, _vx, _vy,
						fogtime, self.imgclass.size, 0, Color(0xFFFFFFFF), Color(0xFFFFFFFF),
						self.layer, "mul+add")
			end
		end
	end
	--kill
	function image_class:kill()
		image_class.del(self)
		New(item_faith_minor, self.x, self.y)
	end

	RegisterClass(image_class)
	return image_class
end

---添加某种弹型库
---@param libraryName string|number @弹型库ID
---@param resLoad table
---@param classDefine table
---@param classCreator function
function library.addBulletStyles(libraryName, resLoad, classDefine, classCreator)
	checkLibrary(libraryName)
	--读取资源
	local path = resLoad.path
	--tex res name , tex file , mipmap
	for _, v in ipairs(resLoad.texture) do
		LoadTexture(v[1], path .. v[2], v[3])
	end
	--imagename,texturefile,x,y,width,height,col,row,cx,cy,blend,color
	local img, tex, x, y, w, h, col, row, cx, cy, blend, color
	for _, v in ipairs(resLoad) do
		img, tex = v[1], v[2]
		x, y = v[3], v[4]
		w, h = v[5], v[6]
		col, row = v[7], v[8]
		cx, cy = v[9], v[10]
		blend, color = v[11], v[12]
		for i = 1, (col * row) do
			local image = img .. i
			LoadImage(
					image, tex,
					x + w * ((i - 1) % col),
					y + h * floor((i - 1) / col),
					w, h)
			if cx and cy then
				SetImageCenter(image, cx, cy)
			end
			if blend then
				if color then
					SetImageState(image, blend, Color(color[1], color[2], color[3], color[4]))
				else
					SetImageState(image, blend)
				end
			end
		end
	end
	--创建class
	--name,image,colorcnt,size,a,b,rect,fogtime,fogblend,deadblend
	for _, v in ipairs(classDefine) do
		if classCreator then
			local class = classCreator(v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10])
			library.styles[libraryName][v[1]] = class
		else
			local class = library.classCreator(v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10])
			library.styles[libraryName][v[1]] = class
		end
	end
	--记录
	--library.styles[libraryName]._res=resLoad
	--library.styles[libraryName]._def=classDefine
end

---添加某种弹型库
---@param libraryName string|number @弹型库ID
---@param classDefine table @{{name, class}, ... }
function library.addBulletStyles2(libraryName, classDefine)
	checkLibrary(libraryName)
	--复制class
	--name,class
	for _, v in ipairs(classDefine) do
		library.styles[libraryName][v[1]] = v[2]
	end
end

---移除某种弹型库
---@param libraryName string|number @弹型库ID
function library.removeBulletStyles(libraryName)
	library.cancelBulletStyles(libraryName)
	library.styles[libraryName] = nil
end

---使用某种弹型库
---@param libraryName string|number @弹型库ID
---@param unrecordToStack boolean @不记录到using队列中
---@return boolean @如果弹型库存在则返回真
function library.usingBulletStyles(libraryName, unrecordToStack)
	local lib = library.styles[libraryName]
	if lib then
		if not unrecordToStack then
			table.insert(library.styleArray, libraryName)
		end
		for k, v in pairs(lib) do
			if _G[k] ~= v then
				_G[k] = v
			end
		end
		BULLETSTYLE:Refresh()
		return true
	else
		return false
	end
end

---取消使用某种弹型库
---@param libraryName string|number @弹型库ID
---@param uncancelAll boolean @不完全清理
function library.cancelBulletStyles(libraryName, uncancelAll)
	--清理using栈记录
	for s = #library.styleArray, 1, -1 do
		if library.styleArray[s] == libraryName then
			table.remove(library.styleArray, s)
			if uncancelAll then
				break
			end
		end
	end
	--清空全局中的
	local lib = library.styles[libraryName]
	if lib then
		for k, v in pairs(lib) do
			if _G[k] == v then
				_G[k] = nil
			end
		end
	end
	--刷新
	for _, v in ipairs(library.styleArray) do
		library.usingBulletStyles(v, true)
	end
end

----------------------------------------
---导出

---@type BulletLibrary
BulletLibrary = library
