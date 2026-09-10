
local cos, sin = cos, sin
local max = max
local table = table
local ChangeImage
--------------------------
---支持妖梦斩击效果变化，开启gray即可
---支持拖影
---@class bullet
local bullet = Class(object)
_G.bullet = bullet
function bullet:frame()
    task.Do(self)
    if (lstg.var.gray or self.own_gray) and (not self._no_gray) then
        if self._index ~= 16 then
            ChangeImage(self, self.imgclass, 16, true)
        end
        table.insert(self.graysmear, { x = self.x, y = self.y, rot = self.rot, alpha = 80, img = self.img, hscale = self.hscale, vscale = self.vscale })
    else
        if self._index ~= self.real_index then
            ChangeImage(self, self.imgclass, self.real_index)
        end
    end
    local s
    for i = #self.graysmear, 1, -1 do
        s = self.graysmear[i]
        s.alpha = max(0, s.alpha - 10)
        if s.alpha == 0 then
            table.remove(self.graysmear, i)
        end
    end
end
function bullet:kill()
    local w = lstg.world
    New(item.obj.faith_minor, self.x, self.y)
    if self._index and BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt) then
        BulletBreak_Table:New(self.x, self.y, self._index)
    end
    if self.imgclass.size == 2.0 then
        self.imgclass.del(self)
    end
end
function bullet:del()
    --	self.imgclass.del(self)
    local w = lstg.world
    if self.imgclass.size == 2.0 then
        self.imgclass.del(self)
    end
    if self._index and BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt) then
        BulletBreak_Table:New(self.x, self.y, self._index)
    end
end
function bullet:render()
    local c = self.imgclass
    for _, s in ipairs(self.graysmear) do
        c.SetColorFunc(s.img, "add+alpha", s.alpha, 255, 255, 255)
        c.RenderFunc(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
    end
    if self.graze2 and self.graze2 > 0 and self.graze2ing then
        local t = int((self.ani + self.gzz_off) / 6) % 4 * 90
        c.SetColorFunc(self.img, self._blend, self._a, self._r, self._g * 0.7, self._b * 0.7)
        c.RenderFunc(self.img, self.x + cos(t), self.y + sin(t), self.rot, self.hscale, self.vscale, 0.5, self.ani)
        self.graze2ing = nil
    else
        c.SetColorFunc(self.img, self._blend, self._a, self._r, self._g, self._b)
        DefaultRenderFunc(self)
    end
end

---@param imgclass bulletStyle
---@param index number
---@param stay boolean
---@param destroyable boolean
---@param fogtime number@雾化时间
function bullet:init(imgclass, index, stay, destroyable, fogtime)
    self._blend, self._a, self._r, self._g, self._b = "", 255, 255, 255, 255
    self._layer = -200
    self.logclass = self.class
    self.imgclass = imgclass
    self.class = imgclass
    self.own_gray = false
    self._no_gray = false
    self.smear = {}
    self.graysmear = {}
    self.group = destroyable and 1 or 5
    self.fogtime = fogtime or 11
    --绀珠传用的
    self.graze2 = 0
    self.gzz_off = ran:Int(0, 60)
    if tonumber(index) then
        self.colli = true
        self.stay = stay
        index = int(Forbid(index, 1, 16))
        self.layer = self._layer + 100 - imgclass.size * 0.001 + index * 0.00001
        self._index = index
        self.real_index = index
        self.index = int((index + 1) / 2)
    end
    imgclass.init(self, index)
end

---@param layer number
---@param real boolean@图层真正是这个(可能会被覆盖)
function bullet:SetLayer(layer, real)
    if real then
        self.layer = layer
    else
        self._layer = layer or LAYER.ENEMY_BULLET
        self.layer = self._layer + ((self.class == self.logclass) and 0 or 100) - self.imgclass.size * 0.001 + self._index * 0.00001
    end
end

---@param imgclass bulletStyle
---@param index number
---@param fake boolean@设置假颜色，目前用于妖梦时缓子弹变灰效果
function bullet:ChangeImage(imgclass, index, fake)
    if self.class == self.imgclass then
        self.class = imgclass
        self.imgclass = imgclass
    else
        self.imgclass = imgclass
    end
    if not fake then
        self.real_index = index
    end
    self._index = index
    imgclass.init(self, self._index)
end
ChangeImage = bullet.ChangeImage

---取消雾化效果
function bullet:RemoveFog()
    self.timer = self.fogtime
end

---重新雾化
function bullet:RestartFog()
    self.class = self.imgclass
    self.timer = 0
end

bullet.ReBound = object.ReBound
bullet.Shuttle = object.Shuttle

---自动根据style设置角度
---并返回设置速度时是否要设置朝向
function bullet:GetNavi()
    self.rot = (self.imgclass == music) and -90 or self.rot
    return (self.imgclass ~= star_small and self.imgclass ~= star_big and self.imgclass ~= music) and true
end
----------------------------------------------------------------

------bullet_break--------
--牺牲内存优化运行性能
LoadTexture('etbreak', 'THlib\\bullet\\etbreak.png')
for j = 1, 16 do
    LoadImageGroup('etbreak' .. j, 'etbreak', 0, 0, 128, 128, 4, 2)
    for i = 1, 8 do
        SetImageScale('etbreak' .. j .. i, 0.5)
    end
end

BulletBreak_Table = Class(object, { bulletbreak = {}, float = function(a, b)
    if a > b then
        a, b = b, a
    end
    local c = (a + b) / 2
    return c + (math.random() - 0.5) * (b - c) * 2
end })
function BulletBreak_Table:init()
    self.group = GROUP.GHOST
    self.layer = LAYER.ENEMY_BULLET - 50
    self.x, self.y = 0, 0
    self.bound = false
    self.class = BulletBreak_Table
    self.class.bulletbreak = {}
    BulletBreakIndex = {
        Color(192, sp:HSVtoRGB(0, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(0, 0.5, 1)), --red
        Color(192, sp:HSVtoRGB(295, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(295, 0.5, 1)), --purple
        Color(192, sp:HSVtoRGB(240, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(240, 0.5, 1)), --blue
        Color(192, sp:HSVtoRGB(189, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(189, 0.5, 1)), --cyan
        Color(192, sp:HSVtoRGB(113, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(113, 0.5, 1)), --green
        Color(192, sp:HSVtoRGB(61, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(61, 0.5, 1)), --yellow
        Color(192, sp:HSVtoRGB(20, 0.5, 0.75)),
        Color(192, sp:HSVtoRGB(20, 0.5, 1)), --orange
        Color(192, sp:HSVtoRGB(0, 0, 0.75)),
        Color(192, sp:HSVtoRGB(0, 0, 1)), --gray
    }
    for j = 1, 16 do
        for l = 1, 8 do
            SetImageState('etbreak' .. j .. l, 'mul+add', BulletBreakIndex[j])
        end
    end
end
function BulletBreak_Table:frame()
    local b
    for i = #self.class.bulletbreak, 1, -1 do
        b = self.class.bulletbreak[i]
        b.timer = b.timer + 1
        if b.timer == 23 then
            table.remove(self.class.bulletbreak, i)
        end
    end
end
function BulletBreak_Table:render()
    local b
    for i = #self.class.bulletbreak, 1, -1 do
        b = self.class.bulletbreak[i]
        Render("etbreak" .. b.index .. int(b.timer / 3) + 1, b.x, b.y, b.rot, b.scale / 2)
    end
end
function BulletBreak_Table:New(x, y, index)
    table.insert(self.bulletbreak, { x = x, y = y, index = index,
                                     scale = self.float(0.5, 0.75), rot = self.float(0, 360), timer = 0 })
end

Include("THlib\\bullet\\bulletStyle.lua")
Include("THlib\\bullet\\clearbullet.lua")

local straight_bullet = Class(bullet, {
    init = function(self, imgclass, index, x, y, v, angle, aim, omiga, stay, destroyable, _495, through, frame, render)
        bullet.init(self, imgclass, index, stay, destroyable)
        self.x = x
        self.y = y
        self.rot = angle
        if aim then
            self.rot = self.rot + Angle(self, player)
        end
        self.omiga = omiga

        object.SetV(self, v, self.rot, true)
        self._495 = _495
        self.through = through
        self.frame_other = frame
        self.render_other = render
    end,
    frame = function(self)
        bullet.frame(self)
        bullet.Shuttle(self, { "l", "r" }, nil, self.through, function(o)
            o.through = nil
        end)
        bullet.ReBound(self, { "l", "r", "t" }, nil, self._495, function(o)
            o._495 = nil
        end)
        if self.frame_other then
            self.frame_other(self)
        end
    end,
    render = function(self)
        bullet.render(self)
        if self.render_other then
            self.render_other(self)
        end
    end,
    kill = function(self)
        bullet.kill(self)
        if self.kill_other then
            self.kill_other(self)
        end
    end,
    del = function(self)
        bullet.del(self)
        if self.del_other then
            self.del_other(self)
        end
    end
})

---@param style bulletStyle
---@param color number
---@param x number
---@param y number
---@param v number
---@param  a number
---@param aim boolean
---@param omiga number
---@param stay boolean
---@param destroyable boolean
---@param rebound boolean
---@param through boolean
function NewSimpleBullet(style, color, x, y, v, a, aim, omiga, stay, destroyable, rebound, through, frame, render)
    return New(straight_bullet,
            style, color, x, y, v or 0, a or 0, aim,
            omiga or 0,
            (stay or stay == nil) and true,
            (destroyable or destroyable == nil) and true,
            rebound,
            through,
            frame,
            render)
end

