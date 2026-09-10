---=====================================
---player
---=====================================
player_lib = {}
local player_lib = player_lib

----------------------------------------
---加载资源
LoadPS("player_death_ef", "THlib\\player\\player_death_ef.psi", "parimg12")
Include("THlib\\player\\player_system.lua")

----------------------------------------
---player class
---@class player
player_class = Class(object)
local player_class = player_class

player_lib.player_class = player_class

function player_class:init(slot)
    SetCurSystem(lstg.var.current_system or "")
    New(System)
    New(BulletBreak_Table)
    self.group = GROUP.PLAYER
    self.layer = LAYER.PLAYER
    lstg.var.timeslow = 1
    lstg.var.CYFPS = 60
    self.bound = false
    self.own_gray = false
    self.gray = false
    self.graysmear = {}
    self.x = 0
    self.y = -176
    self._blend = ""
    self._a, self._r, self._g, self._b = 255, 255, 255, 255
    self._wisys = PlayerWalkImageSystem(self) --by OLC，自机行走图系统
    self._playersys = player_lib.system(self, slot) --by OLC，自机逻辑系统
    --self.class = player_class--
    lstg.player = self
    player = self
    if not lstg.var.init_player_data then
        error("Player data has not been initialized. (Call function item.PlayerInit.)")
    end
end

function player_class:frame()
    if self.realrealreal_lock then
        return
    end
    task.Do(self)
    self._playersys:doFrameBeforeEvent()
    self._playersys:frame()
    self._playersys:doFrameAfterEvent()
    if lstg.var.gray or self.own_gray then
        table.insert(self.graysmear,
                { x = self.x, y = self.y, rot = self.rot,
                  alpha = 80, img = self.img, hscale = self.hscale, vscale = self.vscale })
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

function player_class:render()
    if self.realrealreal_lock then
        return
    end
    for _, s in ipairs(self.graysmear) do
        SetImageState(s.img, "add+alpha", s.alpha, 255, 255, 255)
        Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
    end
    self._playersys:doRenderBeforeEvent()
    self._playersys:render()
    self._playersys:doRenderAfterEvent()
end

function player_class:colli(other)
    self._playersys:doColliBeforeEvent(other)
    local p = self._playersys:colli(other)
    self._playersys:doColliBeforeEvent(other)
    return p
end

function player_class:findtarget()
    self.target = nil
    local maxpri = -1
    local dx, dy, pri
    object.EnemyNontjtDo(function(o)
        if o.colli and o.class.base.take_damage then
            dx = self.x - o.x
            dy = self.y - o.y
            pri = abs(dy) / (abs(dx) + 0.01)
            if pri > maxpri then
                maxpri = pri
                self.target = o
            end
        end
    end)
end

local SetImageState = SetImageState
local Render = Render
local SearchStageLevel = SearchStageLevel

---@class grazer
grazer = Class(object)
function grazer:other_frame()
    if self.grazed_add then
        if self.grazed < 30 then
            self.grazed = self.grazed + 1
        end
        self.grazed_add = nil
    else
        if self.grazed > 0 then
            self.grazed = self.grazed - 1
        end
    end
end
function grazer:other_render()
    OriginalSetImageState('Grazer2', 'mul+rev', Color(3.2 * self.grazed, 255, 255, 255))
    Render('Grazer2', self.x, self.y, -self.ani, 4.3 - 2.3 * task.SetMode[2](min(12, self.grazed) / 12))
end
function grazer:other_colli(other)
    if other.graze2 then
        self.grazed_add = true
        other.graze2 = other.graze2 + 1
        other.graze2ing = true
        if other.graze2 >= 40 then
            PlaySound('item01', 0.5, 0)
            for _ = 1, 5 do
                New(item.obj.graze, other.x, other.y, ran:Float(-0.15, 0.15))
            end
            other.graze2 = nil
        end
    elseif other.IsLaser then
        self.grazed = 30
    end
end
function grazer:init(player)
    self.layer = LAYER.ENEMY_BULLET_EF + 50
    self.group = GROUP.PLAYER
    self.player = player or lstg.player
    --self.player=lstg.player
    self.gzz = SearchStageLevel[9]
    self.aura = 0
    self.aura_d = 0
    self.log_state = self.player.slow
    self._slowTimer = 0
    self._pause = 0
    self.gp = {}

    self.a = self.gzz and 48 or 24
    self.b = self.a
    self.grazed = 0
    if self.gzz then

        self.other_frame = grazer.other_frame
        self.other_render = grazer.other_render
        self.other_colli = grazer.other_colli
    else
        self.other_frame = function()
        end
        self.other_render = function()
        end
        self.other_colli = function()
        end
    end
end
local max = max
function grazer:frame()
    local p = self.player
    self.x = p.x
    self.y = p.y
    self.hide = p.hide
    if not p.time_stop then
        if self.log_state ~= p.slow then
            self.log_state = p.slow
            self._pause = 30
        end
        if p.slow == 1 then
            if self._slowTimer < 30 then
                self._slowTimer = self._slowTimer + 1
            end
        else
            self._slowTimer = 0
        end
        if self._pause == 0 then
            self.aura = self.aura + 1.5
        end
        if self._pause > 0 then
            self._pause = self._pause - 1
        end
        local S = cos(90 * self._slowTimer / 30)
        S = S * S
        self.aura_d = 180 * S
    end
    --
    local g
    for i = #self.gp, 1, -1 do
        g = self.gp[i]
        g.x = g.x + cos(g.a) * g.v
        g.y = g.y + sin(g.a) * g.v
        if g.timer >= 10 then
            g.alpha = max(0, g.alpha - 16)
        end
        g.v = max(0.1, g.v - 0.03)
        g.rot = g.rot + g.omiga
        g.timer = g.timer + 1
        if g.alpha == 0 then
            table.remove(self.gp, i)
        end
    end
    if lstg.var.gray or self.own_gray then
        table.insert(p.graysmear, {
            x = self.x, y = self.y, rot = self.aura, alpha = 100 * self.player.lh,
            img = "player_aura", hscale = 2 - self.player.lh, vscale = 2 - self.player.lh })

    end
    self:other_frame()
end

function grazer:render()
    for _, g in ipairs(self.gp) do
        SetImageState("white", "mul+add", g.alpha, 255, 227, 132)
        Render("white", g.x, g.y, g.rot, 0.25)
        SetImageState("white", "mul+add", g.alpha / 2, 255, 227, 132)
        Render("white", g.x, g.y, g.rot, 0.25)
    end
    SetImageState("player_aura", "", 192, 255, 255, 255)
    Render("player_aura", self.x, self.y, -self.aura + self.aura_d, self.player.lh)
    SetImageState("player_aura", "", Color(0xC0FFFFFF) * self.player.lh + Color(0x00FFFFFF) * (1 - self.player.lh))
    Render("player_aura", self.x, self.y, self.aura, 2 - self.player.lh)
    self:other_render()
end

function grazer:colli(other, new, x, y)
    if other.group ~= GROUP.ENEMY then
        self:other_colli(other)
        if (not (other._graze) or other._inf_graze) or (other.IsLaser and new) then
            item.PlayerGraze()
            PlaySound("graze", 0.5, self.x / 120)
            table.insert(self.gp, { x = self.x, y = self.y,
                                    a = ran:Float(0, 360), v = ran:Float(4, 5),
                                    alpha = 180, timer = 1, rot = ran:Float(0, 360), omiga = ran:Sign() * 5 })
            if SearchStageLevel[10] then
                x = x or other.x
                y = y or other.y
                Season.drop(x, y, nil, true, 1, Angle(self, x, y), 0.5)
            end
            if not (other._inf_graze) or (other.IsLaser and new) then
                other._graze = true
            end
        end
    end
end

----------------------------------------
---一些自机组件

player_bullet_straight = Class(object)

function player_bullet_straight:init(img, x, y, v, angle, dmg)
    self.group = GROUP.PLAYER_BULLET
    self.layer = LAYER.PLAYER_BULLET
    self.img = img
    self.x = x
    self.y = y
    self.rot = angle
    self.vx = v * cos(angle)
    self.vy = v * sin(angle)
    self.dmg = dmg
    if self.a ~= self.b then
        self.rect = true
    end
end

player_bullet_trail = Class(object)

function player_bullet_trail:init(img, x, y, v, angle, target, trail, dmg)
    self.group = GROUP.PLAYER_BULLET
    self.layer = LAYER.PLAYER_BULLET
    self.img = img
    self.x = x
    self.y = y
    self.rot = angle
    self.v = v
    self.target = target
    self.trail = trail
    self.dmg = dmg
end

function player_bullet_trail:frame()
    if IsValid(self.target) and self.target.colli and self.target.class.base.take_damage then
        local a = (Angle(self, self.target) - self.rot) % 360
        if a > 180 then
            a = a - 360
        end
        local da = self.trail / (Dist(self, self.target) + 1)
        if da >= abs(a) then
            self.rot = Angle(self, self.target)
        else
            self.rot = self.rot + sign(a) * da
        end
    end
    self.vx = self.v * cos(self.rot)
    self.vy = self.v * sin(self.rot)
end

player_death_ef = Class(object)

function player_death_ef:init(x, y)
    self.x = x
    self.y = y
    self.img = "player_death_ef"
    self.layer = LAYER.PLAYER + 50
end

function player_death_ef:frame()
    if self.timer == 4 then
        ParticleStop(self)
    end
    if self.timer == 60 then
        Del(self)
    end
end

----------------------------------------
---加载自机

---储存自机的信息表
---@type table @{{displayname,classname,replayname}, ... }
player_list = {}

---添加自机信息到自机信息表
---@param displayname string @显示在菜单中的名字
---@param classname string @全局中的自机类名
---@param replayname string @显示在rep信息中的名字
---@param pos number @插入的位置
---@param _replace boolean @是否取代该位置
function AddPlayerToPlayerList(displayname, classname, replayname, pos, _replace)
    if _replace then
        player_list[pos] = { displayname, classname, replayname }
    elseif pos then
        table.insert(player_list, pos, { displayname, classname, replayname })
    else
        table.insert(player_list, { displayname, classname, replayname })
    end
end
