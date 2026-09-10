local item, task, object, lstg, misc, ran = item, task, object, lstg, misc, ran
local int, min, max, cos, sin = int, min, max, cos, sin
local New, Dist = New, Dist
---@class Season
local Season = {}
_G.Season = Season

function Season.Addseason(value)
    local before = int(lstg.var.season / 100)
    lstg.var.season = min(600, lstg.var.season + value)
    if int(lstg.var.season / 100) > before then
        PlaySound("lgodsget", 0.5, 0, true)
    end
end

local barMap = { "red", "green", "red", "blue" }
local main_item = Class(item)
function main_item:init(x, y, v, a, collect, wait, value)
    item.init(self, x, y, 1, v, a)
    self.itemid = barMap[lstg.var.seasonid]
    self.img = "season_item" .. lstg.var.seasonid
    self.omiga = ran:Float(1, 3) * ran:Sign()
    self._scale = 1
    self.attract = collect and 8 or self.attract
    self.value = value or 1
    if wait then
        self.group = 0
        task.New(self, function()
            task.Wait(60)
            self.group = 6
        end)
    end
end
function main_item:collect()
    if lstg.var.ON_sakura then
        lstg.var.score = lstg.var.score + 50
    else
        lstg.var.score = lstg.var.score + 10
    end
    Season.Addseason(self.value / 2)
    item.Additembar(self.itemid, 0.1)
end
function main_item:render()
    if self.gzz_flag then
        SetImageState(self.img, "mul+add", 100, 255, 150, 150)
        local t = int((self.ani + self.gzz_off) / 10) % 4 * 90
        Render(self.img, self.x + cos(t) * 0.6, self.y + sin(t) * 0.6, self.rot, self.hscale, self.vscale)
    else
        SetImageState(self.img, "mul+add", 100, 255, 255, 255)
        DefaultRenderFunc(self)
    end
end
Season.main_item = main_item

local BigItem = Class(item.obj.faith_minor)
function BigItem:init(x, y, scale, index)
    item.obj.faith_minor.init(self, x, y)
    self.hscale = scale or 2
    self.vscale = self.hscale
    self.index = index or 1000
end
function BigItem:collect()
    if SearchStageLevel[4] then
        lstg.var.faith = lstg.var.faith + 3
    end
    lstg.var.score = lstg.var.score + self.index
    item.Additembar("green", 0.09)
end

local Attack = Class(object)
function Attack:init(col, dmg)
    self.x, self.y = player.x, player.y
    self.group = 3
    self.layer = -401
    self.bound = false
    self.colli = true
    self.alpha = 0
    self.col = col
    self.a = 0
    self.dmg = dmg
    self.killflag = true
    self.count = 0
    function self:drop_item(x, y)
        New(main_item, x, y, nil, nil, true, nil, 0.6)
        self.count = self.count + 1
        if self.count > 9 then
            New(BigItem, x + ran:Float(-5, 5), y + ran:Float(-5, 5))
            self.count = self.count - 9
        end
    end
end
function Attack:frame()
    task.Do(self)
    self.b = self.a
    if self.colli then
        cutLasersByCircle(self.x, self.y, self.a, function(x, y)
            self:drop_item(x, y)
        end)
        object.BulletDo(function(o)
            if Dist(self, o) < self.a then
                object.Del(o)
                self:drop_item(o.x, o.y)
                --New(main_item, o.x, o.y, nil, nil, true, nil, 0.6)
            end
        end)
        object.LaserDo(function(o)
            if Dist(self, o) < self.a and not o.Isradial and not o.Isgrowing then
                object.Del(o)
                self:drop_item(o.x, o.y)
                --New(main_item, o.x, o.y, nil, nil, true, nil, 0.6)
            end
        end)
    end
end
function Attack:render()
    SetImageState("white", "mul+add", self.alpha / 2.7, unpack(self.col))
    misc.SectorRender(self.x, self.y, 0, self.a, 0, 360, 40)
    misc.SectorRender(self.x, self.y, self.a - 8, self.a, 0, 360, 40)
end

local Spring_Attack = Class(Attack)
function Spring_Attack:init(rank)
    Attack.init(self, { 230, 40, 40 }, 2)
    self.alpha = 255
    lstg.var.season = 0
    lstg.var.seasoncd = 82 + rank * 6
    player.protect = player.protect + 20 + rank * 3
    task.New(self, function()
        task.SmoothSetValueTo("a", 50 + rank * 28, 12, 2)
        task.Wait(30 + rank * 6)
        self.colli = false
        task.SmoothSetValueTo("alpha", 0, 30, 2)
        object.Del(self)
    end)
end
Season.Spring_Attack = Spring_Attack

local Summer_Attack = Class(Attack)
function Summer_Attack:init(rank)
    Attack.init(self, { 40, 90, 230 }, 2.4 + rank * 0.1)
    lstg.var.season = max(0, lstg.var.season - 100)
    lstg.var.seasoncd = 120 + rank * 2
    player.protect = player.protect + 30
    self.alpha = 0
    self.a = 55
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 255, 12, 2)
        task.Wait(60 + rank * 2)
        self.colli = false
        task.SmoothSetValueTo("alpha", 0, 30, 2)
        object.Del(self)
    end)
end
Season.Summer_Attack = Summer_Attack

local Autumn_Attack = Class(Attack)
function Autumn_Attack:init(rank)
    Attack.init(self, { 230, 80, 20 }, 1.6 + rank * 0.1)
    lstg.var.season = 0
    lstg.var.seasoncd = 45 + rank * 18
    player.protect = player.protect + 30
    self.alpha = 0
    self.a = 50 + rank * 3
    self.hspeed, self.lspeed, self.llspeed = player.hspeed, player.lspeed, player.llspeed
    player.hspeed = self.hspeed * 1.5
    player.lspeed = self.lspeed * 1.5
    player.llspeed = self.llspeed * 1.5
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 255, 20, 2)
        task.Wait(15 + rank * 18)
        self.colli = false
        player.hspeed, player.lspeed, player.llspeed = self.hspeed, self.lspeed, self.llspeed
        task.SmoothSetValueTo("alpha", 0, 30, 2)
        object.Del(self)
    end)
end
function Autumn_Attack:frame()
    Attack.frame(self)
    self.x, self.y = player.x, player.y
end
Season.Autumn_Attack = Autumn_Attack

local Winter_Attack = Class(Attack)
function Winter_Attack:init(rank)
    Attack.init(self, { 60, 100, 235 }, 1.8 + rank * 0.1)
    lstg.var.season = 0
    lstg.var.seasoncd = 90 + rank * 22
    player.protect = player.protect + 90 + rank * 22
    self.alpha = 0
    self.a = 60 + rank * 2
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 255, 20, 2)
        task.Wait(60 + rank * 22)
        self.colli = false
        task.SmoothSetValueTo("alpha", 0, 30, 2)
        object.Del(self)
    end)
end
Season.Winter_Attack = Winter_Attack

Season.Attack = { Spring_Attack, Summer_Attack, Autumn_Attack, Winter_Attack }

function Season.drop(x, y, collect, wait, v, a, value)
    New(main_item, x, y, v, a, collect, wait, value)
end

