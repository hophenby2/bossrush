local lstg, item, object, task, ext, ran, sp, cos, sin, abs, table, string = lstg, item, object, task, ext, ran, sp, cos, sin, abs, table, string
local New = New
local Dist = Dist
local max = max
local IsValid = IsValid
local SetImageState = SetImageState
local SetViewMode = SetViewMode
local SetFontState = SetFontState
local Render = Render
local RenderText = RenderText
local RenderRect = RenderRect
local PlaySound = PlaySound
local manual = ext.manual

---@class UFO
local UFO = {}
_G.UFO = UFO
UFO.valid = setmetatable({ }, {
    __call = function(t)
        sp:UnitListUpdate(t)
        return #t
    end })
UFO.stay_in = {}
UFO.big_ufo = nil
function UFO.GetColor(index)
    return index == 1 and 255 or 64,
    index == 3 and 255 or 64,
    index == 2 and 255 or 64
end
function UFO.ShouldPoint(index)
    local ufo = lstg.var.UFO
    if #ufo ~= 2 then
        return
    end
    if ufo[1] == ufo[2] and ufo[2] == index then
        return true
    elseif ufo[1] ~= ufo[2] and ufo[2] ~= index and index ~= ufo[1] then
        return true
    end
end

---检查lstg.var.UFO的情况
function UFO:check()
    if #lstg.var.UFO < 3 then
        return
    end
    local ufo = lstg.var.UFO
    if ufo[1] == ufo[2] and ufo[2] == ufo[3] then
        New(self.summoned, ufo[1])
    elseif ufo[1] ~= ufo[2] and ufo[2] ~= ufo[3] and ufo[3] ~= ufo[1] then
        New(self.summoned, ufo[3], true)
    else
        if ufo[1] == 1 and ufo[2] == 1 and ufo[3] == 2 then
            ext.achievement:get(20)
        end
        table.remove(ufo, 1)
        Del(self.stay_in[1])
        table.remove(self.stay_in, 1)
        task.New(self.stay_in[1], function()
            local w = lstg.world
            task.GetSelf().pos = 1
            task.MoveTo(w.scrl - 140 + 24 - 8, w.scrb - 120 + 330, 30, 2)
        end)
    end
end

---通过系统自动给予的UFO
function UFO:New(x, y)
    if lstg.var.UFO_mode == 1 then
        New(self.Simple, x, y, lstg.var.UFO_next)
    else
        New(self.Colorful, x, y, lstg.var.UFO_next)
    end
    lstg.var.UFO_next = ran:Int(1, 3)
    lstg.var.UFO_mode = ran:Int(1, 2)
end

---ufo的击破奖励
function UFO:bonus(boss, index, colorful)
    if colorful then
        self:New(boss.x, boss.y)
        object.EnemyNontjtDo(function(o)
            Damage(o, 200)
        end)
    else
        if index == 1 then
            item.Dropitem(item.obj.revdead, 1, boss.x, boss.y)
            if SearchStageLevel[1] then
                local b
                for _ = 1, 20 do
                    b = New(item.obj.sakura, boss.x + ran:Float(-30, 30), boss.y + ran:Float(-30, 30), nil, nil, 350)
                    b.attract = 8
                    b.target = player
                end
            end
        elseif index == 2 then
            item.Dropitem(item.obj.point, 30, boss.x, boss.y)
            lstg.var.grazetimes = lstg.var.grazetimes + 4
        elseif index == 3 then
            item.Dropitem(item.obj.faith, 4, boss.x, boss.y)
            item.Dropitem(item.obj.addcharge, 1, boss.x, boss.y)
            --SetChargeLevel(lstg.var.charge + 1)
        end
    end
end

local bar = { "red", "blue", "green" }
function UFO:Insert(index, x, y)
    table.insert(lstg.var.UFO, index)
    item.Additembar(bar[index], 5)
    UFO:check()
    New(UFO.render_on, index, #lstg.var.UFO)
    if x and y then
        New(UFO.insert, x, y, index, #lstg.var.UFO)
    end
end

local base = Class(object)
UFO.base = base
function base:init(x, y, index)
    self.x, self.y = x, y
    self.index = index
    self.img = "UFO_" .. self.index
    self.group = GROUP.ITEM2
    self.layer = LAYER.ITEM
    self.colli = false
    if UFO.valid() % 2 == 1 then
        self._vx, self._vy = 1, -ran:Float(0.4, 0.5)
    else
        self._vx, self._vy = -1, -ran:Float(0.4, 0.5)
    end--场上不同的UFO数量设置不同的移动方向
    self.flag = 1.6
    self.hscale = 0
    self.vscale = 0
    sp:UnitListAppend(UFO.valid, self)
    PlaySound("piyo", 0, self.x / 120)
    task.New(self, function()
        for i = 1, 10 do
            self.hscale = i / 10
            self.vscale = self.hscale
            task.Wait()
        end
    end)
end
function base:frame()
    task.Do(self)
    if self.kill then
        return
    end
    self.rot = sin(self.ani * 5) * 15
    if Dist(self, player) < 40 then
        self.flag = 1
    else
        self.flag = 1.6
    end--玩家靠近时减速
    if Dist(self, player) < 16 then
        UFO.base.colli(self, player)
    end--这样处理碰撞
    if not self.go_out then
        local w = lstg.world
        if self.x < w.l + 12 then
            self._vx = -self._vx
            self.x = w.l * 2 + 24 - self.x
        end
        if self.x > w.r - 12 then
            self._vx = -self._vx
            self.x = w.r * 2 - 24 - self.x
        end
        if self.y < w.b + 60 then
            self._vy = -self._vy
            self.y = w.b * 2 + 120 - self.y
        end
        if self.y > w.t - 60 then
            self._vy = -self._vy
            self.y = w.t * 2 - 120 - self.y
        end
    end--反弹
    if not self.colorful and self.ani >= 1200 then
        self.go_out = true
    end
    self.vx, self.vy = self._vx * self.flag, self._vy * self.flag
end
function base:Pointrender()
    if UFO.ShouldPoint(self.index) then
        SetImageState("white", "mul+add", 200, UFO.GetColor(self.index))
        for i = 72, 360, 72 do
            i = i + self.timer
            Render("white", self.x + cos(i) * 15 * self.hscale, self.y + sin(i) * 15 * self.hscale,
                    i, 0.07, cos(36) * 15 / 8 * self.hscale)
        end
    end
end
function base:render()
    UFO.base.Pointrender(self)
    DefaultRenderFunc(self)
end

function base:colli()
    PlaySound("item00", 0, self.x / 120)
    Del(self)
    if #lstg.var.UFO >= 3 then
        return
    end
    UFO:Insert(self.index, self.x, self.y)
end
function base:del()
    if not self.kill then
        object.Preserve(self)
        self.kill = true
        task.New(self, function()
            for i = 1, 10 do
                self.hscale = 1 - i / 10
                self.vscale = self.hscale
                task.Wait()
            end
            object.RawDel(self)
        end)
    end
end

UFO.insert = Class(object, { frame = task.Do })
function UFO.insert:init(x, y, index, pos)
    self.x, self.y = x + 480, y + 270
    self.index = index
    self.group = GROUP.GHOST
    self.bound = false
    self.layer = LAYER.ENEMY_BULLET_EF
    self.img = "UFO_" .. self.index
    task.New(self, function()
        task.Wait(15)
        for i = 1, 15 do
            self.hscale = 1 - i / 15
            self.vscale = self.hscale
            task.Wait()
        end
        Del(self)
    end)
    task.New(self, function()
        local w = lstg.world
        task.MoveTo(w.scrl - 140 + pos * 24 - 8, w.scrb - 120 + 330, 30, 2)
    end)
end
function UFO.insert:render()
    SetViewMode("ui")
    DefaultRenderFunc(self)
    SetViewMode("world")
end

UFO.render_on = Class(object)
function UFO.render_on:init(index, pos)
    UFO.stay_in[pos] = self
    self.index = index
    local w = lstg.world
    self.pos = pos
    self.x, self.y = w.scrl - 140 + self.pos * 24 - 8, w.scrb - 120 + 330
    self.bound = false
    self.group = GROUP.GHOST
    self.layer = 11
    self.hscale = 0
    self.vscale = 0
    self.img = "hint.UFO_filled" .. self.index
    task.New(self, function()
        for i = 1, 30 do
            self.hscale = task.SetMode[4](i / 30)
            self.vscale = self.hscale
            task.Wait()
        end
    end)
end
function UFO.render_on:frame()
    local w = lstg.world
    self.x, self.y = w.scrl - 140 + self.pos * 24 - 8, w.scrb - 120 + 330
    task.Do(self)
    if ext.notUIdraw then
        object.RawDel(self)
    end
    if lstg.var.UFO_charging then
        if UFO.big_ufo.timer % 10 < 5 then
            self.img = "hint.UFO_charging" .. self.index
        else
            self.img = "hint.UFO_filled" .. self.index
        end
    else
        self.img = "hint.UFO_filled" .. self.index
    end
end
function UFO.render_on:del()
    object.Preserve(self)
    self.kill = true
    task.New(self, function()
        for i = 1, 10 do
            self.hscale = 1 - i / 10
            self.vscale = self.hscale
            task.Wait()
        end
        object.RawDel(self)
    end)
end
function UFO.render_on:render()
    SetViewMode("ui")
    DefaultRenderFunc(self)
    SetViewMode("world")
end

SimpleUFO = UFO.base--可能为了整洁的传递
UFO.Simple = SimpleUFO
ColorfulUFO = Class(UFO.base)
function ColorfulUFO:init(x, y, init_index)
    UFO.base.init(self, x, y, init_index)
    self.index_time = 0
    self.flick = 5000
    self.colorful = true
    self.change_times = 0
end
function ColorfulUFO:frame()
    UFO.base.frame(self)
    if Dist(self, player) > 40 then
        self.index_time = self.index_time + 1
        self.in_player = nil
    else
        self.in_player = true
    end
    if self.index_time >= 150 then
        self.change_times = self.change_times + 1
        PlaySound("changeitem", 0, self.x / 120)
        task.New(self, function()
            for i = 1, 10 do
                self.hscale = abs(1 - i / 5)
                self.vscale = self.hscale
                task.Wait()
            end
        end)
        self.index_time = 0
        self.index = self.index % 3 + 1
        self.flick = 5000
    elseif self.index_time >= 100 then
        self.flick = 8
    elseif self.index_time >= 50 then
        self.flick = 16
    end
    if self.change_times >= 8 then
        self.go_out = true
    end
    if self.index_time % self.flick < self.flick / 2 and not self.in_player then
        self.img = "UFO_Flicker_" .. self.index
    else
        self.img = "UFO_" .. self.index
    end
end
function ColorfulUFO:render()
    UFO.base.Pointrender(self)
    DefaultRenderFunc(self)
end
UFO.Colorful = ColorfulUFO

local summoned = Class(enemy)
UFO.summoned = summoned
function summoned:init(index, colorful)
    UFO.big_ufo = self
    enemybase.init(self, 320)
    self.mx, self.my = self.x, self.y
    self.x, self.y = self.mx, self.my
    self.dropUFO = index
    self.colorful = colorful
    self.index = index
    self.img = "BIG_UFO_" .. self.index
    self.aura = _enemy_aura_tb[1]
    self.death_ef = _death_ef_tb[1]
    self.group = GROUP.NONTJT
    self.hscale = 0
    self.vscale = 0
    self.a = 0
    self.b = 0
    self.bound = false
    lstg.var.UFO_charging = true
    task.New(self, function()
        PlaySound("ufo")
        Newcharge_in(self.x, self.y, UFO.GetColor(self.index))
        New(bullet_cleaner, self.x, self.y, 180, 20, 30, true)
        for i = 1, 60 do
            self.hscale = sin(i * 1.5)
            self.vscale = self.hscale
            self.a = self.hscale * 24
            self.b = self.a
            task.Wait()
        end
        local a, c = 0, 0
        while true do
            if c < 90 then
                c = c + 1
            end
            a = a + sin(c) * 2
            self.a = 24
            self.b = 24
            self.rot = sin(a * 1.5) * 16
            self.x, self.y = self.mx + cos(a) * sin(a / 3) * 20, self.my + sin(a) * sin(a / 3) * 20
            task.Wait()
        end
    end)
    task.New(self, function()
        task.Wait(300)
        task.SmoothSetValueTo("mx", player.x, 60, 3)
        task.SmoothSetValueTo("my", lstg.world.t + 64, 360, 1)
        UFO.big_ufo = nil
        Del(self)
    end)
end
function summoned:over()
    UFO.big_ufo = nil
    lstg.var.UFO_charging = false
    for _ = 1, 3 do
        Del(UFO.stay_in[1])
        table.remove(lstg.var.UFO, 1)
        table.remove(UFO.stay_in, 1)
    end
end
function summoned:kill()
    enemy.kill(self)
    UFO.summoned.over(self)
    New(ColorfulUFO, self.x, self.y, self.dropUFO)
    Newcharge_out(self.x, self.y, UFO.GetColor(self.dropUFO))
    New(bullet_cleaner, self.x, self.y, 600, 30, 40, true)
    UFO:bonus(self, self.index, self.colorful)
end
function summoned:del()
    enemy.del(self)
    UFO.summoned.over(self)
end
function summoned:frame()
    enemybase.frame(self)
    if self.colorful then
        if self.ani / 15 % 1 == 0 then
            self.index = self.index % 3 + 1
            self.img = "BIG_UFO_" .. self.index
        end
    end
end
function summoned:render()
    DefaultRenderFunc(self)
    local _a = min(1, self.timer / 60)
    SetImageState("white", "", _a * 255, 0, 0, 0)
    RenderRect("white", self.x - 21, self.x + 21, self.y + 30, self.y + 35)
    SetImageState("white", "", _a * 255, 255, 100, 100)
    RenderRect("white", self.x - 20, self.x - 20 + 40 * (self.hp / self.maxhp), self.y + 31, self.y + 34)

    SetFontState("Score", "add+alpha", _a * 180, UFO.GetColor(self.index))
    RenderText("Score", string.format("%0.2f", (720 - self.ani) / 60), self.x, self.y - 30, 0.6, "centerpoint")
end
