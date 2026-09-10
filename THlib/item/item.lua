LoadTexture('item', 'THlib\\item\\item.png')
LoadImageGroup('item', 'item', 0, 0, 32, 32, 2, 5, 8, 8)
LoadImageGroup('item_up', 'item', 64, 0, 32, 32, 2, 5)
SetImageState('item8', 'mul+add', 192, 255, 255, 255)
LoadTexture('bonus1', 'THlib\\item\\item.png')
LoadTexture('bonus2', 'THlib\\item\\item.png')
LoadTexture('bonus3', 'THlib\\item\\item.png')
local lstg, ran = lstg, ran
local max, min, Forbid = max, min, Forbid
local SearchStageLevel = SearchStageLevel
local SetV = SetV
---@class item
local item = Class(object)
_G.item = item
function item:init(x, y, t, v, angle)
    self.x = Forbid(x, lstg.world.l + 8, lstg.world.r - 8)
    self.y = y
    self.v = v or 1.5
    SetV(self, self.v, angle or 90)
    self.group = 6
    self.layer = -300
    self.bound = false
    self.img = 'item' .. t
    self.imgup = 'item_up' .. t
    self.attract = 0
    self.collect_online = true
    self.py = y
    self.t = 0
    self._vy = 0
    self._scale = 1
    self.gzz_off = ran:Int(0, 60)
end

function item:render()
    if self.y > lstg.world.t and not self.no_up_render and self.imgup then
        Render(self.imgup, self.x, lstg.world.t - 8)
    else
        if self.gzz_flag then
            SetImageState(self.img, "", 255, 255, 178.5, 178.5)
            local t = int((self.ani + self.gzz_off) / 10) % 4 * 90
            Render(self.img, self.x + cos(t) * 0.6, self.y + sin(t) * 0.6, self.rot, self.hscale, self.vscale)
        else
            SetImageState(self.img, "", 255, 255, 255, 255)
            DefaultRenderFunc(self)
        end
    end
end

function item:frame()
    task.Do(self)
    local player = self.target or player
    if self.timer == 1 then
        self.rot = -45
    end
    self.gzz_flag = player.grazer.grazed > 0
    if self.gzz_flag then
        if self.timer % 3 == 0 then
            self.t = self.t + 1
        end
    else
        self.t = self.t + 1
    end
    if self.timer > 24 and self.attract > 0 then
        SetV(self, self.attract, Angle(self, player))
        self.vx = self.vx + player.dx * 0.5
        self.vy = self.vy + player.dy * 0.5
    end
    if self.t == 24 then
        self.py = self.y
    end
    if self.t < 24 then
        self.rot = 45 * self.t + 45
        self.hscale = (self.t + 25) / 48 * self._scale
        self.vscale = self.hscale
        if self.timer < 24 then
            self.y = self.py + self.v * self.t - 0.5 * self.v / 48 * self.t * self.t
        end
        if self.t == 22 then
            self.vx = 0
        end
    else
        if self.attract <= 0 then
            self._vy = max(-1.7, self._vy - 0.03)
            self.vy = self._vy * (self.gzz_flag and 0.4 or 1)
        end
    end
    if self.y < lstg.world.boundb then
        Del(self)
    end
    if self.attract >= 8 then
        self.collected = true
    end
end

function item:colli(other)
    if other == player then
        if self.class.collect then
            self.class.collect(self, other)
        end
        object.Kill(self)
        PlaySound('item00', 0.3, self.x / 200)

    end
end

function item.Additembar(key, value)
    local bar = lstg.var.itembar
    local count = bar.red + bar.blue + bar.green
    if SearchStageLevel[8] and count < 300 then
        bar[key] = bar[key] + min(300 - count, value)
    end
end

item.sc_bonus_max = 2000000
item.sc_bonus_base = 1000000

local items = {}
item.obj = items

items.revdead = Class(item)
function items.revdead:init(x, y)
    item.init(self, x, y, 3)
end
function items.revdead:collect()
    if lstg.var.dead > 0 then
        lstg.var.dead = lstg.var.dead - 1
    end
    PlaySound('bonus', 0.5)
end

items.addmisscount = Class(item)
function items.addmisscount:init(x, y)
    item.init(self, x, y, 7)
end
function items.addmisscount:collect()
    local sg = stage.current_stage
    if sg.AllowMissCount then
        sg.AllowMissCount = sg.AllowMissCount + 1
    end
    PlaySound('extend', 0.5)
end

items.addcharge = Class(item)
function items.addcharge:init(x, y)
    item.init(self, x, y, 9)
end
function items.addcharge:collect()
    if SearchStageLevel[3] then
        SetChargeLevel(lstg.var.charge + 1)
        PlaySound('bonus2', 0.5)
    else
        PlaySound("invalid")
    end

end

items.faith = Class(item)
function items.faith:init(x, y)
    item.init(self, x, y, 5)
end
function items.faith:collect()
    lstg.var.score = lstg.var.score + 1000
    if SearchStageLevel[4] then
        lstg.var.faith = lstg.var.faith + 100
    end
    item.Additembar("green", 3)
end

items.faith_minor = Class(object, { colli = item.colli })
function items.faith_minor:init(x, y)
    item.init(self, x, y, 8)
    SetImageState(self.img, "mul+add")
    if not BoxCheck(self, lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t) then
        object.RawDel(self)
    end
    self.vx = ran:Float(-0.15, 0.15)
    self._vy = ran:Float(3.25, 3.75)
    self.flag = 1
    self.is_minor = true
    self.target = player
end
function items.faith_minor:frame()
    local player = self.target
    if player.death > 80 and player.death < 90 then
        self.flag = 0
        self.attract = 0
    end
    if self.timer < 45 then
        self.vy = self._vy - self._vy * self.timer / 45
    end
    if self.timer >= 54 and self.flag == 1 then
        SetV(self, 8, Angle(self, player))
    end
    if self.timer >= 54 and self.flag == 0 then
        if self.attract > 0 then
            SetV(self, self.attract, Angle(self, player))
            self.vx = self.vx + player.dx * 0.5
            self.vy = self.vy + player.dy * 0.5
        else
            self.vy = max(self.dy - 0.03, -2.5)
            self.vx = 0
        end
        if self.y < lstg.world.boundb then
            Del(self)
        end
    end
end
function items.faith_minor:collect()
    if SearchStageLevel[4] then
        lstg.var.faith = lstg.var.faith + self.hscale
    end
    lstg.var.score = lstg.var.score + 500
    item.Additembar("green", 0.05)
end

items.graze = Class(object, { frame = items.faith_minor.frame, colli = item.colli })
function items.graze:init(x, y, vx)
    item.init(self, x, y, 8)
    SetImageState(self.img, "mul+add")
    self.hscale = 0.5
    self.vscale = 0.5
    self.vx = vx
    self.vy = 0
    self.flag = 1
    self._vy = ran:Float(3.25, 3.75) / 2
    self.is_minor = true
    self.target = player
end
function items.graze:collect()
    PlaySound('item00', 0.1, self.x / 200, true)
    local var = lstg.var
    var.graze = var.graze + 1
    if SearchStageLevel[5] then
        var.grazetimes = var.grazetimes + 0.0008
    end
    var.score = var.score + 10

end

items.signal = Class(object, { frame = items.faith_minor.frame, colli = item.colli })
function items.signal:init(x, y)
    item.init(self, x, y, 8)
    SetImageState(self.img, "mul+add")
    self.hscale = 0.4
    self.vscale = 0.4
    self.vx = 0
    self.vy = 0
    self.flag = 1
    self._vy = ran:Float(3.25, 3.75) / 2
    self.is_minor = true
    self.target = player
end
function items.signal:collect()
    local var = lstg.var
    if SearchStageLevel[4] then
        lstg.var.faith = lstg.var.faith + 1
    end
    if SearchStageLevel[5] then
        var.grazetimes = var.grazetimes + 0.008
        var.grazerevp = 50
    end
    var.score = var.score + 100
    item.Additembar("green", 0.06)
end

items.point = Class(item)
function items.point:init(x, y)
    item.init(self, x, y, 2)
end
function items.point:collect()
    if self.attract == 8 then
        local score = item.TweakScore(10000 * lstg.var.grazetimes)
        New(float_text, "Score", score, self.x, self.y + 6, 0.75, 90, 60, 0.3, 0.3, Color(0x40FFFF00), Color(0x00FFFF00))
        lstg.var.score = lstg.var.score + score
    else
        local score = item.TweakScore(10000 * lstg.var.grazetimes / 20 * max(10, min(20, 20 + (player.y - player.collect_line) / 10)))
        New(float_text, "Score", score, self.x, self.y + 6, 0.75, 90, 60, 0.3, 0.3, Color(0x40FFFFFF), Color(0x00FFFFFF))
        lstg.var.score = lstg.var.score + score
    end
    item.Additembar("blue", 2)
end

items.sakura = Class(item)
function items.sakura:init(x, y, v, a, get, no)
    item.init(self, x, y, 11, v, a)
    self.get = get or 80
    self.no_up_render = no or nil
    self.omiga = ran:Float(1, 3) * ran:Sign()
end
function items.sakura:collect()
    if lstg.var.ON_sakura then
        lstg.var.score = lstg.var.score + 50
    else
        lstg.var.score = lstg.var.score + 10
    end
    if not lstg.var.ON_sakura then
        lstg.var.sakura = min(50000, lstg.var.sakura + self.get)
    end
    item.Additembar("red", self.get / 120)
end
local sqrt = sqrt
function item.Dropitem_PFP(x, y, drop)
    local m
    if drop[1] >= 400 then
        m = drop[1]
    else
        m = drop[1] / 100 + drop[1] % 100
    end
    local n = m + drop[2] + drop[3]
    local r = sqrt(n - 1) * 5
    local r2
    local a
    for _ = 1, drop[2] do
        r2 = sqrt(ran:Float(1, 4)) * r
        a = ran:Float(0, 360)
        New(item.obj.faith, x + r2 * cos(a), y + r2 * sin(a))
    end
    for _ = 1, drop[3] do
        r2 = sqrt(ran:Float(1, 4)) * r
        a = ran:Float(0, 360)
        New(item.obj.point, x + r2 * cos(a), y + r2 * sin(a))
    end
end

item.DropSwitch = {
    [item.obj.faith] = function(num, x, y)
        item.Dropitem_PFP(x, y, { 0, num, 0 })
    end,
    [item.obj.point] = function(num, x, y)
        item.Dropitem_PFP(x, y, { 0, 0, num })
    end,
    [item.obj.sakura] = function(num, x, y)
        local r2, a
        for _ = 1, num do
            r2 = sqrt(ran:Float(1, 4)) * sqrt(num - 1) * 5
            a = ran:Float(0, 360)
            New(item.obj.sakura, x + r2 * cos(a), y + r2 * sin(a))
        end
    end,
    [item.obj.faith_minor] = function(num, x, y)
        local r2, a
        for _ = 1, num do
            r2 = sqrt(ran:Float(1, 4)) * sqrt(num - 1) * 5
            a = ran:Float(0, 360)
            New(item.obj.faith_minor, x + r2 * cos(a), y + r2 * sin(a))
        end
    end,
    [item.obj.revdead] = function(num, x, y)
        local r2, a
        for _ = 1, num do
            r2 = sqrt(ran:Float(1, 4)) * sqrt(num - 1) * 5
            a = ran:Float(0, 360)
            New(item.obj.revdead, x + r2 * cos(a), y + r2 * sin(a))
        end
    end,
    [item.obj.addmisscount] = function(num, x, y)
        local r2, a
        for _ = 1, num do
            r2 = sqrt(ran:Float(1, 4)) * sqrt(num - 1) * 5
            a = ran:Float(0, 360)
            New(item.obj.addmisscount, x + r2 * cos(a), y + r2 * sin(a))
        end
    end,
    [item.obj.addcharge] = function(num, x, y)
        local r2, a
        for _ = 1, num do
            r2 = sqrt(ran:Float(1, 4)) * sqrt(num - 1) * 5
            a = ran:Float(0, 360)
            New(item.obj.addcharge, x + r2 * cos(a), y + r2 * sin(a))
        end
    end
}

function item.Dropitem(itemclass, num, x, y)
    item.DropSwitch[itemclass](num, x, y)
end

Include("THlib\\item\\item_func.lua")
