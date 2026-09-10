local lstg, item, object, task, ext, ran, sp, cos, sin, abs, table = lstg, item, object, task, ext, ran, sp, cos, sin, abs, table
local New = New
local Dist = Dist
local max = max
local IsValid = IsValid
local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Render = Render
local PlaySound = PlaySound
local Color = Color
local manual = ext.manual

---@class Beast
local Beast = {}
_G.Beast = Beast
Beast.valid = setmetatable({ }, {
    __call = function(t)
        sp:UnitListUpdate(t)
        return #t
    end })
Beast.stay_in = {}
Beast.statements = {
    { true, true, true, true, true, true, true, true, true, }, --块
    { true, true, true, true, false, true, true, true, true, }, --箱子
    { true, false, true, true, true, true, true, true, true, }, --胸甲
    { true, true, true, true, false, true, true, false, true, }, --护腿
    { true, true, true, true, true, true, false, false, false, }, --火把门
    { false, false, false, true, true, true, true, true, true, }, --火把门
    { true, true, false, true, true, false, true, true, false, }, --门
    { false, true, true, false, true, true, false, true, true, }, --门
    { true, true, true, true, false, true, false, false, false, }, --头盔
    { false, false, false, true, true, true, true, false, true, }, --头盔
    { true, false, true, true, false, true, false, false, false, }, --靴
    { false, false, false, true, false, true, true, false, true, }--靴
}
function Beast:CheckState(now, target)
    local main, other = {}, {}
    for i = 1, 9 do
        table.insert(target[i] and main or other, now[i])
    end
    --local main_str = table.concat(main)
    --local other_str = table.concat(other)
    for i = 1, #main - 1 do
        if main[i] ~= main[i + 1] then
            --检测要提取的位置的动物灵是否相同
            return false
        end
    end
    local m = main[1]
    for i = 1, #other do
        if m == other[i] then
            --检测和不提取的位置的动物灵是否不同
            return false
        end
    end
    return true
end
Beast.getHyperAchievement = { 103, 104, 105, 106, 107, 107, 108, 108, 109, 109, 110, 110 }
function Beast:check()
    if #lstg.var.beast >= 9 then
        PlaySound("release")
        lstg.var.beast_charging = true
        local turn = { 0, 0, 0 }
        for _, p in ipairs(lstg.var.beast) do
            turn[p] = turn[p] + 1
        end
        for i, s in ipairs(self.statements) do
            if self:CheckState(lstg.var.beast, s) then
                ext.achievement:get(self.getHyperAchievement[i])
                break
            end
        end
        local count = max(unpack(turn))
        local hyper
        if count == turn[1] then
            hyper = 1
        elseif count == turn[2] then
            hyper = 2
        elseif count == turn[3] then
            hyper = 3
        end
        if count < 5 then
            hyper = nil
        end
        New(beast_back, hyper)
        if hyper then
            lstg.var.beast_charging_time = count * 100
            lstg.var.max_beast_charging_time = count * 100
            lstg.var.get_beast_hyper = true
            lstg.var.hyper_mode = hyper
        else
            lstg.var.beast_charging_time = 400
            lstg.var.max_beast_charging_time = 400
        end
    end
end

local base = Class(object)
Beast.base = base
function base:init(x, y, index)
    self.x, self.y = x, y
    self.index = index
    self.img = "Beast_" .. self.index
    self.group = GROUP.ITEM2
    self.layer = LAYER.ITEM
    self.colli = false
    local a = ran:Float(-50, 50) + ran:Sign() * 90 + 90
    self._vx, self._vy = cos(a), sin(a)
    self.flag = 1
    self.hscale = 0
    self.vscale = 0
    self.index_time = 0
    self.flick = 5000
    self.colorful = true
    self.change_times = 0
    sp:UnitListAppend(Beast.valid, self)
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
    self.rot = sin(self.ani * 4) * 15
    if Dist(self, player) < 40 then
        self.flag = 0.5
    else
        self.flag = 1
    end --玩家靠近时减速
    if Dist(self, player) < 16 then
        Beast.base.colli(self, player)
    end --这样处理碰撞
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
    end --反弹
    self.vx, self.vy = self._vx * self.flag, self._vy * self.flag
    if Dist(self, player) > 40 then
        self.index_time = self.index_time + 1
        self.in_player = nil
    else
        self.in_player = true
    end
    if self.index_time >= 240 then
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
    elseif self.index_time >= 190 then
        self.flick = 8
    elseif self.index_time >= 140 then
        self.flick = 16
    end
    if self.change_times >= 45 then
        self.go_out = true
    end
    if self.index_time % self.flick < self.flick / 2 and not self.in_player then
        self.img = "Beast_" .. self.index
    else
        self.img = "Beast_Flicker_" .. self.index
    end
end
function base:render()
    if self.change_times >= 43 then
        SetImageState(self.img, "", 150, 255, 255, 255)
    else
        SetImageState(self.img, "", 255, 255, 255, 255)
    end
    DefaultRenderFunc(self)
end
local bar = { "red", "green", "blue" }
function base:colli()
    PlaySound("item00", 0, self.x / 120)
    object.Del(self)
    item.Additembar(bar[self.index], 5)
    if lstg.var.beast_charging then
        lstg.var.beast_charging_time = min(lstg.var.max_beast_charging_time, lstg.var.beast_charging_time + 30)
        return
    end
    table.insert(lstg.var.beast, self.index)
    Beast:check()
    New(Beast.insert, self.x, self.y, self.index, #lstg.var.beast)
    New(Beast.render_on, self.index, #lstg.var.beast)
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

---不会变色的动物灵，只在特殊地方出现
local simple=Class(base)
Beast.simple = simple
function simple:init(x, y, index)
    self.x, self.y = x, y
    self.index = index
    self.img = "Beast_Indv_" .. self.index
    self.group = GROUP.ITEM2
    self.layer = LAYER.ITEM
    self.colli = false
    local a = ran:Float(-50, 50) + ran:Sign() * 90 + 90
    self._vx, self._vy = cos(a), sin(a)
    self.flag = 1
    self.hscale = 0
    self.vscale = 0
    self.flick = 5000
    self.change_times = 0
    sp:UnitListAppend(Beast.valid, self)
    task.New(self, function()
        for i = 1, 10 do
            self.hscale = i / 10
            self.vscale = self.hscale
            task.Wait()
        end
    end)
end
function simple:frame()
    task.Do(self)
    if self.kill then
        return
    end
    self.rot = sin(self.ani * 4) * 15
    if Dist(self, player) < 40 then
        self.flag = 0.5
    else
        self.flag = 1
    end --玩家靠近时减速
    if Dist(self, player) < 16 then
        Beast.base.colli(self, player)
    end --这样处理碰撞
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
    end --反弹
    if self.ani >= 10800 then
        self.go_out = true
    end
    self.vx, self.vy = self._vx * self.flag, self._vy * self.flag
end
function simple:render()
    if self.ani >= 43*240 then
        SetImageState(self.img, "", 150, 255, 255, 255)
    else
        SetImageState(self.img, "", 255, 255, 255, 255)
    end
    DefaultRenderFunc(self)
end

Beast.insert = Class(object, { frame = task.Do })
function Beast.insert:init(x, y, index, pos)
    self.x, self.y = x + 480, y + 270
    self.index = index
    self.group = GROUP.GHOST
    self.bound = false
    self.layer = LAYER.ENEMY_BULLET_EF
    self.img = "Beast_" .. index
    task.New(self, function()
        task.Wait(15)
        for i = 1, 15 do
            self.hscale = 1 - i / 15
            self.vscale = self.hscale
            task.Wait()
        end
        object.Del(self)
    end)
    task.New(self, function()
        local j = (pos - 1) % 3 + 1
        local i = math.ceil(pos / 3)
        local w = lstg.world
        task.MoveTo(w.scrl - 150 + j * 32, w.scrb - 42 + 200 - i * 32, 30, 2)
    end)
end
function Beast.insert:render()
    SetViewMode("ui")
    DefaultRenderFunc(self)
    SetViewMode("world")
end

Beast.render_on = Class(object)
function Beast.render_on:init(index, pos)
    Beast.stay_in[pos] = self
    self.index = index
    local j = (pos - 1) % 3 + 1
    local i = math.ceil(pos / 3)
    local w = lstg.world
    self.j, self.i = j, i
    self.x, self.y = w.scrl - 150 + j * 32, w.scrb - 42 + 200 - i * 32
    self.bound = false
    self.group = GROUP.GHOST
    self.layer = 11
    self.hscale = 0
    self.vscale = 0
    self.img = "hint.beast_filled" .. self.index
    task.New(self, function()
        for r = 1, 30 do
            self.hscale = task.SetMode[4](r / 30) * 0.7
            self.vscale = self.hscale
            task.Wait()
        end
    end)
end
function Beast.render_on:frame()
    task.Do(self)
    if ext.notUIdraw then
        object.RawDel(self)
    end
    local w = lstg.world
    self.x, self.y = w.scrl - 150 + self.j * 32, w.scrb - 42 + 200 - self.i * 32
end
function Beast.render_on:del()
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
function Beast.render_on:render()
    SetViewMode("ui")
    if lstg.var.beast_charging then
        RenderAnimation("hint.beast_fillingfire", self.ani, self.x, self.y, 0, 0.8)
    end
    DefaultRenderFunc(self)
    SetViewMode("world")
end

local bullet_killer = Class(object)
function bullet_killer:init(x, y, a, b, kill_indes)
    self.x = x
    self.y = y
    self.a = a
    self.b = b
    self.group = GROUP.PLAYER
    self.hide = true
    self.kill_indes = kill_indes
    self.colli = false
end
function bullet_killer:frame()
    if self.timer == 1 then
        object.Del(self)
    end
    cutLasersByCircle(self.x, self.y, self.a,item.obj.signal)
    object.BulletDo(function(o)
        if Dist(self, o) < self.a then
            object.Del(o)
            New(item.obj.signal, o.x, o.y)
        end
    end)
    object.LaserDo(function(o)
        if Dist(self, o) < self.a and not o.Isradial and not o.Isgrowing then
            object.Kill(o)
        end
    end)
end
Beast.bullet_killer = bullet_killer

local Hyper2, Hyper3
function Beast:Attack()
    local mode = lstg.var.hyper_mode
    if mode == 2 then
        if not IsValid(Hyper2) then
            Hyper2 = New(self.Hyper_2_tool)
        end
    elseif mode == 3 then
        if not IsValid(Hyper3) then
            Hyper3 = New(self.Hyper_3_tool)
        end
    elseif mode == 1 then
        local p = player
        if p.__shoot_flag and p.nextshoot <= 0 then
            if p.timer % 4 == 0 then
                for z = -3, 3 do
                    New(self.Hyper_1_tool, p.x, p.y, 20, 90 + z * (3 + p.timer % 8), 0.18)
                end
            end
        end
    end
end
local Hyper_2_center = Class(object)
function Hyper_2_center:init()
    self.img = "beast_hyper_2"
    self.group = GROUP.GHOST
    self.layer = LAYER.PLAYER
    self.x, self.y = player.x, player.y
    self.bound = false
    self.colli = false
end
function Hyper_2_center:frame()
    for o = 1, 3 do
        o = o * 120 + player.timer * 4
        New(Beast.bullet_killer, player.x + cos(o) * 70, player.y + sin(o) * 70, 45, 45)
    end
    if lstg.var.beast_charging_time == 0 then
        Del(self)
    end
end
function Hyper_2_center:render()
    for o = 1, 3 do
        Render(self.img, player.x, player.y, o * 120 - 135 + player.timer * 4)
    end
end
Beast.Hyper_2_tool = Hyper_2_center

local Hyper_3_center = Class(object)
function Hyper_3_center:init()
    self.tex = "beast_hyper_3"
    self.group = GROUP.GHOST
    self.layer = LAYER.PLAYER - 1
    self.x, self.y = player.x, player.y
    self.bound = false
    self.colli = false
end
function Hyper_3_center:frame()
    local x, y = player.x, player.y
    if player.__shoot_flag and player.nextshoot <= 0 then
        for z = -3, 3 do
            object.EnemyNontjtDo(function(target)
                if target.colli and marisa_player.IsInLaser(x, y, 90 + z * 15, target, 120) and target.class.base.take_damage then
                    if self.timer % 5 == 0 then
                        New(item.obj.signal, target.x, target.y)
                    end
                    target.class.base.take_damage(target, 0.15)
                    if target.maxhp then
                        if target.hp > target.maxhp * 0.1 then
                            PlaySound('damage00', 0.1, target.x / 1024, true)
                        else
                            PlaySound('damage01', 0.2, target.x / 1024, true)
                        end
                    else
                        PlaySound('damage00', 0.1, target.x / 1024, true)
                    end
                end
            end)
        end
    end
    if lstg.var.beast_charging_time == 0 then
        Del(self)
    end
end
function Hyper_3_center:render()
    if player.__shoot_flag and player.nextshoot <= 0 then
        for z = -3, 3 do

            marisa_player.CreateLaser("beast_hyper_3", player.x, player.y, 90 + z * 15, 120, self.timer * 8,
                    Color(120, 255, 255, 255), 600)
        end
    end
end
Beast.Hyper_3_tool = Hyper_3_center

local Hyper_1_needle = Class(player_bullet_straight)
function Hyper_1_needle:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "beast_hyper_1", x, y, v, a, dmg)
end
function Hyper_1_needle:kill()
    New(Hyper_1_needle.needle_ef, self.x, self.y, self.rot)
    New(item.obj.signal, self.x, self.y)
    New(item.obj.signal, self.x, self.y)
end
local ef = Class(object)
function ef:init(x, y, rot)
    self.x = x
    self.y = y + 32
    self.img = 'beast_hyper_1_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
    self.group = GROUP.GHOST
    self.hscale = 1.5
    self.rot = rot
end
function ef:frame()
    self.hscale = self.hscale + 0.4
    if self.timer > 15 then
        object.RawDel(self)
    end
end
function ef:render()
    SetImageState(self.img, 'mul+add', 120 - 120 * self.timer / 16, 255, 255, 255)
    DefaultRenderFunc(self)
end
Hyper_1_needle.needle_ef = ef
Beast.Hyper_1_tool = Hyper_1_needle

function Beast:drop(x, y, state)
    New(self.base, x, y, state or ran:Int(1, 3))
end
