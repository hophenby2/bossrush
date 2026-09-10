Include('THlib\\player\\aya\\shot_bonus.lua')
Include('THlib\\player\\aya\\aya_system.lua')
CreateRenderTarget("PhotoTexture")
local defaultFrameEvent = {
    ["frame.updateDeathState"] = player_lib.defaultFrameEvent['frame.updateDeathState'],
    ["frame.updateSlow"] = { 99, function(self)
        if self.__slow_flag then
            if self.__aya_shoot then
                self.slow = 2
            else
                self.slow = 1
            end
        else
            self.slow = 0
        end
    end },
    ["frame.updateCamera"] = { 98, function(self)
        if self.slow == 2 then
            self.Rpos = 0
        else
            if self.photopre < self.preok then
                self.Rpos = 30
            else
                self.Rpos = 60
            end
        end
        self.posR = 0.9 * self.posR + 0.1 * self.Rpos
        if self.photopre < self.preok and self.cd == 0 then
            self.playsound = false
            if self.slow == 2 then
                self.photopre = self.photopre + 5
                table.insert(self.charge_sp, { x = self.x + ran:Float(-100, 100), y = self.y + ran:Float(-100, 100),
                                               scale = 1, alpha = 0, timer = 0, v = ran:Float(0.05, 0.08),
                                               rot = ran:Float(0, 360), omiga = ran:Sign() * ran:Float(3, 1) })
                if GetSoundState("ch00") == "stopped" then
                    PlaySound("ch00")
                end
            else
                self.photopre = self.photopre + 2
                if GetSoundState("ch00") == "playing" then
                    StopSound("ch00")
                end
            end
        else
            if not self.playsound then
                PlaySound("ch01", 1)
                if GetSoundState("ch00") == "playing" then
                    StopSound("ch00")
                end
                self.nicemoment = 31
                self.playsound = true
            end
        end
    end },
    ["frame.control"] = { 97, function(self)
        if self.lock then
            return
        end
        if self._playersys:keyIsPressed("shoot") and self.photopre > (self.preok - 1) and self.slow == 0 then
            self.photopre = 0
            if not self.camera.photoing then
                self.camera:GetPhoto()
                self.cd = 60
            end
        end
    end },
    ["frame.move"] = { 96, function(self)
        local dx, dy, v = 0, 0, self.hspeed
        local left, right, up, down
        if not (self.lock or self.camera.photoing) then
            if self.slow == 1 then
                v = self.lspeed
            end
            if self.slow == 2 then
                v = self.llspeed
            end
            up = self.__up_flag
            down = self.__down_flag
            left = self.__left_flag
            right = self.__right_flag

            if self.__up_counting > self.__down_counting and self.__down_counting > 0 then
                down = true
                up = false
            end
            if self.__down_counting > self.__up_counting and self.__up_counting > 0 then
                up = true
                down = false
            end
            if self.__left_counting > self.__right_counting and self.__right_counting > 0 then
                right = true
                left = false
            end
            if self.__right_counting > self.__left_counting and self.__left_counting > 0 then
                left = true
                right = false
            end
            dx = dx - (left and 1 or 0)
            dx = dx + (right and 1 or 0)
            dy = dy + (up and 1 or 0)
            dy = dy - (down and 1 or 0)
            if dx * dy ~= 0 then
                v = v * SQRT2_2
            end
            dx = v * dx
            dy = v * dy
            self.x = self.x + dx
            self.y = self.y + dy
            self.x = math.max(math.min(self.x, lstg.world.pr - 8), lstg.world.pl + 8)
            self.y = math.max(math.min(self.y, lstg.world.pt - 32), lstg.world.pb + 16)
        end
        self.__move_dx = dx
        self.__move_dy = dy
    end },
    ["frame.itemCollect"] = player_lib.defaultFrameEvent['frame.itemCollect'],
    ["frame.updateVar"] = { 90, function(self)
        player_lib.defaultFrameEvent['frame.updateVar'][2](self)
        if self.nicemoment > 0 then
            self.nicemoment = self.nicemoment - 1
        end
        if self.cd > 0 then
            self.cd = self.cd - 1
        end
    end }
}

aya_player = Class(player_class)
do
    --resource
    LoadTexture('Aya_player', 'THlib\\player\\aya\\aya.png')
    LoadImageGroup('Aya_player', 'Aya_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadImageGroup('player_photoing', 'Aya_player', 0, 175, 32, 48, 8, 1, 0, 0)
    LoadImageFromFile("photoa", "THlib\\player\\aya\\photoa.png")
    LoadImageFromFile("photob", "THlib\\player\\aya\\photob.png")
    LoadImageFromFile("photoPRE", "THlib\\player\\aya\\photoPRE.png")
    LoadImageFromFile("photoc", "THlib\\player\\aya\\photoc.png")
    SetImageState("photoa", "mul+add", 155, 255, 255, 255)
    SetImageState("photob", "mul+add", 155, 255, 255, 255)
    SetImageState("photoPRE", "mul+add", 155, 255, 255, 255)
    SetImageState("photoc", "mul+add")
end

local cos, sin = cos, sin
local max, min = max, min

function aya_player:init()
    player_class.init(self)
    self.name = 'Aya'
    self._wisys = nil
    self._wisys = AyaWalkImageSystem(self) --自机行走图系统
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'Aya_player' .. i
    end
    self.img_photoing = {}
    for i = 1, 8 do
        self.img_photoing[i] = 'player_photoing' .. i
    end
    self.A = 1
    self.B = 1
    --
    self.hspeed = 6.5
    self.lspeed = 2
    self.llspeed = 0.5
    --
    self.VV = 60 * 0.3  --取景框宽
    self.HH = 87 * 0.3    --取景框长
    self.preok = 600  --蓄力量
    self.RR3 = 150    --拍照瞬间取景框一角到中心大小
    self.decay = 1.6
    self.camera_move_speed = 4 --相机取景框移动速度

    self.moveSpeed = 5
    --
    self.cd = 0 --拍照cd
    --
    self.charge_sp = {}
    self.bullet_sp = {}
    self.photopre = 0
    self.posR = 50
    self.Rpos = 50
    --
    self.nicemoment = 0

    self.listener = nil
    self.listener = eventListener()
    for name, event in pairs(defaultFrameEvent) do
        self._playersys:addFrameEvent(name, unpack(event))
    end
    --
    self.camera = TenguCamera(self, self.VV, self.HH, self.preok, self.RR3, "photob", "photoPRE", "photoOK", self.decay, self.camera_move_speed)
end
function aya_player:frame()
    player_class.frame(self)
    self.camera:frame()
    local s
    for i = #self.charge_sp, 1, -1 do
        s = self.charge_sp[i]
        s.x = s.x + (self.x - s.x) * s.v
        s.y = s.y + (self.y - s.y) * s.v
        s.rot = s.rot + s.omiga
        s.scale = max(s.scale - 1 / 20, 0)
        s.alpha = min(s.alpha + 120 / 20, 150)
        s.timer = s.timer + 1
        if s.timer >= 20 then
            table.remove(self.charge_sp, i)
        end
    end
    local Check = sp.math.PointBoundCheck
    local w = lstg.world
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
local Color = Color
local unpack = unpack
function aya_player:render()
    for _, s in ipairs(self.charge_sp) do
        SetImageState("white", "mul+add", s.alpha / 2, 250, 85, 85)
        Render("white", s.x, s.y, s.rot, s.scale * 10 / 8)
        SetImageState("white", "mul+add", s.alpha, 250, 85, 85)
        Render("white", s.x, s.y, s.rot, s.scale * 6 / 8)
    end
    for _, s in ipairs(self.bullet_sp) do
        SetImageState("white", "mul+add", s.alpha / 2, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 3 / 8 + sin(s.timer * 8) / 8)
        SetImageState("white", "mul+add", s.alpha, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 2 / 8 + sin(s.timer * 8) / 8)
    end
    player_class.render(self)
    self.camera:render()
end
local ran = ran
function aya_player:NewSp(x, y, sign)
    table.insert(self.bullet_sp, { x = x, y = y, rot = ran:Float(0, 360), omiga = ran:Sign(), color = { 200, 200, 200 }, alpha = 60, scale = 0, timer = 0 })
    task.New(self.bullet_sp[#self.bullet_sp], function()
        local cao = self
        local self = task.GetSelf()
        local v, a = ran:Float(1, 3), ran:Float(0, 360)
        for i = 29, 0, -1 do
            self.scale = sin(90 - i * 3) * 1.6
            self.x = self.x + cos(a) * v * sin(i * 3)
            self.y = self.y + sin(a) * v * sin(i * 3)
            coroutine.yield()
        end
        task.Wait(ran:Int(1, 30))
        task.MoveToTarget(cao, 60, 1)
        PlaySound("item00")
        cao.photopre = cao.photopre + (sign and 0.5 or 1)
        self.color = { 85, 85, 250 }
        v, a = ran:Float(2, 5), ran:Float(0, 360)
        for i = 59, 0, -1 do
            self.scale = 1.6 - sin(90 - i * 1.5) * 0.6
            self.x = self.x + cos(a) * v * sin(i * 1.5)
            self.y = self.y + sin(a) * v * sin(i * 1.5)
            coroutine.yield()
        end
        task.New(self, function()
            for i = 59, 0, -1 do
                self.scale = sin(i * 1.5)
                coroutine.yield()
            end
        end)
        task.MoveToTarget(cao, 60, 1)
        self.cao = true
    end)
end

AyaWalkImageSystem = plus.Class(PlayerWalkImageSystem)
function AyaWalkImageSystem:UpdateImage()
    if self.camera and self.camera.photoing then
        local AngP = Angle(self.camera.centerx, self.camera.centery, player.x, player.y) + 180
        local a = 15
        local c
        for i = 8, 1, -1 do
            c = ({ 60, 30 })[i % 2 + 1]
            if AngP > a and AngP < (a + c) % 360 then
                self.img = self.img_photoing[i]
                break
            end
            if AngP == a or AngP == (a + c) % 360 then
                self.img = self.img_photoing[i]
                break
            end
            a = a + c
        end
    else
        PlayerWalkImageSystem.UpdateImage(self)
    end
    self.a = self.A
    self.b = self.B
end

