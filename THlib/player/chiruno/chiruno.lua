chiruno_player = Class(player_class)
do
    --resource
    LoadTexture('Chiruno_player', 'THlib\\player\\chiruno\\chiruno.png')
    LoadImageGroup('Chiruno_player', 'Chiruno_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadImage('chiruno_bullet', 'Chiruno_player', 0, 200, 64, 24, 32, 12)
    SetImageState("chiruno_bullet", "", 150, 255, 255, 255)
    LoadAnimation('chiruno_bullet_ef', 'Chiruno_player', 0, 200, 64, 24, 4, 1, 4, 32, 12)
    SetAnimationState("chiruno_bullet_ef", "mul+add", 150, 255, 255, 255)

    LoadTexture('Chiruno_ice', 'THlib\\player\\chiruno\\ice.png')

    LoadImageGroup("Chiruno_ice1", "Chiruno_ice", 0, 128, 32, 32, 4, 1, 16, 16)
    LoadImageGroup("Chiruno_ice2", "Chiruno_ice", 0, 0, 64, 64, 4, 1, 32, 32)
    LoadImage("Chiruno_ice3", "Chiruno_ice", 64, 160, 96, 96, 48, 48)

    LoadImageGroup("Chiruno_ice_ef1", "Chiruno_ice", 128, 128, 32, 32, 4, 1, 16, 16)
    LoadImageGroup("Chiruno_ice_ef2", "Chiruno_ice", 0, 64, 64, 64, 4, 1, 32, 32)
    LoadImage("Chiruno_ice_ef3", "Chiruno_ice", 160, 160, 96, 96, 48, 48)
end
local New = New
local task, object = task, object
function chiruno_player:init()
    player_class.init(self)
    object.RawDel(self.grazer)
    self.grazer = New(chiruno_grazer, self)
    self.name = 'Chiruno'
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'Chiruno_player' .. i
    end
    self.hscale = 1.2
    self.vscale = 1.2
    self.A = 1
    self.B = 1
    self.hspeed = 5
    self.lspeed = 2
    self.pre = 0
    self.__shoot_count2 = 0
    self.maxpre = 600
    self.can_ice = false
    self.charging_time = 0
    self.charging = false
    self.charged = false
    self.cd = 0
    self.bullet_sp = {}
    self._playersys:addFrameEvent("frame.ice", 98, function(self)
        if self.__aya_shoot then
            self.__shoot_count2 = self.__shoot_count2 + 1
        else
            if self.charged then
                PlaySound("ice")
                self.cd = int(task.SetMode[1](self.pre / self.maxpre) * 120)
                self.pre = 0
                self.charged = false
                self.now_iceCount = 0
                New(self.class.bullets.ice, self.x, self.y, 3, nil, self.cd)
            end
            self.charging_time = 0
            self.charging = false
            self.__shoot_count2 = 0
        end
        if self.__shoot_count2 == 15 then
            self.charging = true
            if self.can_ice then
                PlaySound("ch00", 1)
            end
        end
        if self.__shoot_count2 >= 15 then
            self.__slow_flag = true
            self.slow = 1
        end
        if self.charging and self.can_ice then
            self.charging_time = self.charging_time + 1
            if self.charging_time == 60 then
                PlaySound("ch01", 1)
                self.charged = true
            end
        end
        if self.cd > 0 then
            self.cd = self.cd - 1
        else
            self.pre = min(self.maxpre, self.pre + 1)
        end
        self.can_ice = (self.pre / self.maxpre) >= 0.3
    end)
end
function chiruno_player:shoot()
    if not self.charging then
        local t = self.timer
        local b = self.class.bullets.main
        if t % 4 == 0 then
            PlaySound('plst00', 0.3, self.x / 1024)
        end
        if t % 2 == 0 then
            New(b, self.x + 10, self.y, 24, 90, 1.27)
            New(b, self.x - 10, self.y, 24, 90, 1.27)
        end
        if t % 3 == 0 then
            New(b, self.x + 18, self.y - 5, 22, 90, 0.45)
            New(b, self.x - 18, self.y - 5, 22, 90, 0.45)
        end
        if t % 6 == 0 then
            New(b, self.x, self.y, 22, 100, 0.45)
            New(b, self.x, self.y, 22, 80, 0.45)
        end
        if t % 6 == 3 then
            New(b, self.x + 25, self.y, 22, 97, 0.45)
            New(b, self.x - 25, self.y, 22, 83, 0.45)
        end
        if lstg.var.man >= 80 then
            if t % 6 == 2 then
                for p = -3, 3 do
                    New(b, self.x + 25, self.y, 24 + p % 2, 90 + p * 15, 0.31)
                    New(b, self.x - 25, self.y, 24 + p % 2, 90 + p * 15, 0.31)
                end
            end
        end
    end
end
function chiruno_player:frame()
    player_class.frame(self)
    local Check = sp.math.PointBoundCheck
    local w = lstg.world
    local s
    for i = #self.bullet_sp, 1, -1 do
        s = self.bullet_sp[i]
        task.Do(s)
        s.timer = s.timer + 1
        s.rot = s.rot + s.omiga
        if s.cao or not Check(s.x, s.y, w.boundl, w.boundr, w.boundb, w.boundt) then
            table.remove(self.bullet_sp, i)
        end
    end
end
local SetImageState = SetImageState
local Render = Render
local Color, unpack = Color, unpack
local cos, sin, ran = cos, sin, ran
function chiruno_player:render()
    player_class.render(self)
    for _, s in ipairs(self.bullet_sp) do
        SetImageState("white", "mul+add", s.alpha / 2, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 3 / 8 + sin(s.timer * 8) / 8)
        SetImageState("white", "mul+add", s.alpha, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 2 / 8 + sin(s.timer * 8) / 8)
    end
    SetFontState("Score", "", self.charged and 200 or 160, self.can_ice and 100 or 255, self.can_ice and 100 or 255, 255)
    RenderText("Score", ("%d%%"):format(self.pre / self.maxpre * 100), self.x, self.y + 32, self.charged and 0.6 or 0.4, "centerpoint")
end

function chiruno_player:NewSp(x, y)
    table.insert(self.bullet_sp, { x = x, y = y, rot = ran:Float(0, 360), omiga = ran:Sign(), color = { 200, 200, 200 }, alpha = 60, scale = 0, timer = 0 })
    task.New(self.bullet_sp[#self.bullet_sp], function()
        local unit = task.GetSelf()
        local v, a = ran:Float(1, 3), ran:Float(0, 360)
        for i = 29, 0, -1 do
            unit.scale = sin(90 - i * 3) * 1.6
            unit.x = unit.x + cos(a) * v * sin(i * 3)
            unit.y = unit.y + sin(a) * v * sin(i * 3)
            coroutine.yield()
        end
        task.Wait(ran:Int(1, 30))
        task.MoveToTarget(self, 60, 1)
        PlaySound("item00")
        self.pre = min(self.maxpre,self.pre + 0.08)
        lstg.var.score = lstg.var.score + 50
        unit.color = { 135, 206, 235 }
        v, a = ran:Float(2, 5), ran:Float(0, 360)
        for i = 59, 0, -1 do
            unit.scale = 1.6 - sin(90 - i * 1.5) * 0.6
            unit.x = unit.x + cos(a) * v * sin(i * 1.5)
            unit.y = unit.y + sin(a) * v * sin(i * 1.5)
            coroutine.yield()
        end
        task.New(unit, function()
            for i = 59, 0, -1 do
                unit.scale = sin(i * 1.5)
                coroutine.yield()
            end
        end)
        task.MoveToTarget(self, 60, 1)
        unit.cao = true
    end)
end

chiruno_grazer = Class(grazer)
function chiruno_grazer:colli(other, new)
    if other.group ~= GROUP.ENEMY then
        self:other_colli(other)
        if (not (other._graze) or other._inf_graze) or (other.IsLaser and new) then
            item.PlayerGraze()
            self.player.pre = min(self.player.maxpre, self.player.pre + 1.8)
            PlaySound("graze", 0.5, self.x / 120)
            table.insert(self.gp, { x = self.x, y = self.y,
                                    a = ran:Float(0, 360), v = ran:Float(4, 5),
                                    alpha = 180, timer = 1, rot = ran:Float(0, 360), omiga = ran:Sign() * 5 })
            if SearchStageLevel[10] then
                Season.drop(other.x, other.y, nil, true, 1, Angle(self, other), 0.4)
            end
            if not (other._inf_graze) or (other.IsLaser and new) then
                other._graze = true
            end
        end
    end
end

local bullets = {}
chiruno_player.bullets = bullets

local main = Class(player_bullet_straight)
function main:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "chiruno_bullet", x, y, v, a, dmg)
end
function main:kill()
    player.pre = min(player.maxpre, player.pre + 0.3)
    New(bullets.main_ef, self.x, self.y, self.rot)
end
bullets.main = main
local main_ef = Class(object)
function main_ef:init(x, y, rot)
    self.x = x
    self.y = y
    self.img = 'chiruno_bullet_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
    self.group = GROUP.GHOST
    self.vy = 2.25
    self.omiga = ran:Sign()
    self.rot = rot
end
function main_ef:frame()
    if self.timer == 15 then
        object.RawDel(self)
    end
end
bullets.main_ef = main_ef
local ice = Class(object)
bullets.ice = ice
function ice:init(x, y, size, unit, time)
    self.colli = false
    self.group = GROUP.SPELL
    self.layer = -199
    self.rot = ran:Float(0, 360)
    if size == 3 then
        self.t = 3
    else
        self.t = size .. ran:Int(1, 4)
    end
    self.size = size
    self.x, self.y = x, y
    self.unit = unit
    self.img = "Chiruno_ice_ef" .. self.t
    self.scale = ran:Float(0.9, 1.2)
    self.hscale = self.scale + 0.5
    self.vscale = self.hscale
    self.lifetime = time
    PlaySound("ice", 0.2, 0, true)
    task.New(self, function()
        task.New(self, function()
            for i = 0, 10 do
                i = task.SetMode[4](i / 10)
                self._a = i * 180
                self.hscale = self. scale + 0.5 - 0.5 * i
                self.vscale = self.hscale
                task.Wait()
            end
            self.img = "Chiruno_ice" .. self.t
        end)
        task.Wait(time - self.timer)
        object.Del(self)
    end)
    self._a = 0
end
local ceil = math.ceil
local Forbid = Forbid
function ice:colli(other)
    local data = scoredata
    if not other.wasIced and (other.group == GROUP.ENEMY_BULLET or other.group==GROUP.ENEMY_BULLET2) then
        if not ext.replay.IsReplay() then
            data.total_icecount = data.total_icecount + 1
            if data.total_icecount >= 66666 then
                ext.achievement:get(140)
            elseif data.total_icecount >= 5000 then
                ext.achievement:get(139)
            end
        end
        player.now_iceCount = player.now_iceCount + 1
        if player.now_iceCount >= 2000 then
            ext.achievement:get(143)
        end
        New(ice, other.x, other.y, Forbid(ceil(other.a / 4), 1, 3), other, self.lifetime - self.timer)
        task.Clear(other)
        object.StopMoving(other)
        other.wasIced = true
        other.group = 0
    end
end
function ice:frame()
    task.Do(self)
    if self.unit then
        if IsValid(self.unit) then
            self.unit.x, self.unit.y = self.x, self.y
        else
            object.Del(self)
        end
    end
    self.colli = (self.timer > 2 and not self.dk)
end
local chiruno_player = chiruno_player
function ice:del()
    if not self.dk then
        self.dk = true
        object.Preserve(self)
        task.New(self, function()
            for _ = 1, self.size do
                chiruno_player.NewSp(player, self.x, self.y)
            end

            if self.unit and IsValid(self.unit) then
                object.Del(self.unit)
            end
            for i = 10, 0, -1 do
                i = task.SetMode[4](i / 10)
                self._a = i * 180
                self.hscale = self.scale + 0.5 - 0.5 * i
                self.vscale = self.hscale
                task.Wait()
            end
            object.RawDel(self)
        end)
    end
end
function ice:render()
    SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
    DefaultRenderFunc(self)
end