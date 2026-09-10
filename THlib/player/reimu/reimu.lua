reimu_player = Class(player_class)
do
    LoadTexture('reimu_player', 'THlib\\player\\reimu\\reimu.png')
    -----------------------------------------
    LoadImageGroup('reimu_player', 'reimu_player', 0, 0, 32, 48, 8, 3, 0.5, 0.5)
    -----------------------------------------
    LoadImage('reimu_bullet_red', 'reimu_player', 192, 160, 64, 16, 16, 16)
    SetImageState('reimu_bullet_red', '', 160, 255, 255, 255)
    SetImageCenter('reimu_bullet_red', 56, 8)
    LoadAnimation('reimu_bullet_red_ef', 'reimu_player', 0, 144, 16, 16, 4, 1, 4)
    SetAnimationState('reimu_bullet_red_ef', 'mul+add', 160, 255, 255, 255)
    LoadImage('reimu_bullet_ef_img', 'reimu_player', 48, 144, 16, 16)
    -----------------------------------------
    LoadImage('reimu_bullet_blue', 'reimu_player', 0, 160, 16, 16, 16, 16)
    SetImageState('reimu_bullet_blue', '', 100, 255, 255, 255)
    LoadAnimation('reimu_bullet_blue_ef', 'reimu_player', 0, 160, 16, 16, 4, 1, 4)
    SetAnimationState('reimu_bullet_blue_ef', 'mul+add', 160, 255, 255, 255)
    -----------------------------------------
    LoadImage('reimu_bullet_orange', 'reimu_player', 0, 208, 80, 32, 64, 16)
    SetImageState('reimu_bullet_orange', '', 90, 255, 255, 255)
    CopyImage('reimu_bullet_orange_ef', 'reimu_bullet_orange')
    -----------------------------------------
    LoadImage('reimu_support', 'reimu_player', 96, 144, 16, 16)
    LoadPS('reimu_bullet_ef', 'THlib\\player\\reimu\\reimu_bullet_ef.psi', 'reimu_bullet_ef_img')
    -----------------------------------------
end
local cos, sin = cos, sin
local max = max
local New = New

function reimu_player:init()
    player_class.init(self)
    self.name = 'Reimu'
    self.hspeed = 4.5
    self.imgs = {}
    self.A = 0.5
    self.B = 0.5
    for i = 1, 24 do
        self.imgs[i] = 'reimu_player' .. i
    end
    self.support_sign = 1
end
function reimu_player:shoot()
    --self.nextshoot = 4
    if self.timer % 4 == 0 then
        PlaySound('plst00', 0.3, self.x / 1024)
        New(self.class.bullets.square, self.x + 10, self.y, 24, 90, 2)
        New(self.class.bullets.square, self.x - 10, self.y, 24, 90, 2)
    end
    if self.timer % 2 == 0 then
        for i = 1, 4 do
            New(self.class.bullets.needle, self.sp[i][1], self.sp[i][2], 26, 90, 0.3)
        end
    end
    if lstg.var.man >= 80 then
        if self.timer % 8 == 0 then
            for i = 1, 4 do
                New(self.class.bullets.trail, self.sp[i][1], self.sp[i][2], 15, 90,900, 0.65)
            end
        end
    end
end
function reimu_player:frame()
    player_class.frame(self)
    player_class.findtarget(self)
    if lstg.var.gray or self.own_gray then
        for i = 1, 4 do
            table.insert(self.graysmear, { x = self.sp[i][1], y = self.sp[i][2], rot = self.timer * 3, alpha = 20, img = 'reimu_support', hscale = 1.5, vscale = 1.5 })
            table.insert(self.graysmear, { x = self.sp[i][1], y = self.sp[i][2], rot = self.timer * 3, alpha = 50, img = 'reimu_support', hscale = 1, vscale = 1 })

        end
    end
end
function reimu_player:render()
    player_class.render(self)
    for i = 1, 4 do
        SetImageState('reimu_support', 'mul+add', 100, 255, 255, 255)
        Render('reimu_support', self.sp[i][1], self.sp[i][2], self.timer * 3, 1.5)
        SetImageState('reimu_support', '', 255, 255, 255, 255)
        Render('reimu_support', self.sp[i][1], self.sp[i][2], self.timer * 3)
    end
end

-------------------------------------------------------
local bullets = {}
reimu_player.bullets = bullets

local square = Class(player_bullet_straight)
function square:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "reimu_bullet_red", x, y, v, a, dmg)
end
function square:kill()
    New(bullets.square_ef, self.x, self.y, self.rot)
end
bullets.square = square
-------------------------------------------------------
local square_ef = Class(object)
function square_ef:init(x, y, rot)
    self.x = x
    self.y = y
    self.img = 'reimu_bullet_red_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
    self.group = GROUP.GHOST
    self.vy = 2.25
    self.omiga = ran:Sign()
    self.rot = rot
end
function square_ef:frame()
    if self.timer == 15 then
        object.RawDel(self)
    end
    self.hscale = self.hscale + 0.1
    self.vscale = self.hscale
end
bullets.square_ef = square_ef
-------------------------------------------------------
local needle = Class(player_bullet_straight)
function needle:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "reimu_bullet_orange", x, y, v, a, dmg)
end
function needle:kill()
    New(bullets.needle_ef, self.x, self.y, self.rot)
end
bullets.needle = needle
-------------------------------------------------------
local needle_ef = Class(object)
function needle_ef:init(x, y, rot)
    self.x = x
    self.y = y + 32
    self.img = 'reimu_bullet_orange_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
    self.group = GROUP.GHOST
    self.hscale = 1.5
    self.rot = rot
end
function needle_ef:frame()
    self.hscale = self.hscale + 0.4
    if self.timer > 15 then
        object.RawDel(self)
    end
end
function needle_ef:render()
    SetImageState(self.img, 'mul+add', 70 - 70 * self.timer / 16, 255, 255, 255)
    DefaultRenderFunc(self)
end
bullets.needle_ef = needle_ef

-------------------------------------------------------
local trail = Class(player_bullet_trail)
function trail:init(x, y, v, angle, Trail, dmg)
    player_bullet_trail.init(self, "reimu_bullet_blue", x, y, v, angle, nil, Trail, dmg)
    self.master = player
    self.smear = {}
end
function trail:frame()
    if not IsValid(self.master) then
        object.RawDel(self)
        return
    end
    self.target = self.master.target
    player_bullet_trail.frame(self)
    table.insert(self.smear, { x = self.x, y = self.y, rot = self.rot, alpha = 40 })
    local s
    for i = #self.smear, 1, -1 do
        s = self.smear[i]
        s.alpha = max(0, s.alpha - 5)
        if s.alpha == 0 then
            table.remove(self.smear, i)
        end
    end
end
function trail:render()
    for _, s in ipairs(self.smear) do
        SetImageState(self.img, 'mul+add', s.alpha, 255, 255, 255)
        Render(self.img, s.x, s.y, s.rot)
    end
    SetImageState(self.img, '', 100, 255, 255, 255)
    DefaultRenderFunc(self)
end
function trail:kill()
    New(bullets.trail_ef, self.x, self.y, self.rot)
end
bullets.trail = trail
-------------------------------------------------------
local trail_ef = Class(object)
function trail_ef:init(x, y, rot)
    self.x = x
    self.y = y
    self.rot = rot
    self.img = 'reimu_bullet_blue_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
    self.group = GROUP.GHOST
    self.vx = cos(rot)
    self.vy = sin(rot)
    self.alpha = 160
end
function trail_ef:frame()
    task.Do(self)
    self.hscale = self.hscale + 0.2
    self.vscale = self.hscale
    if self.timer == 10 then
        task.New(self, function()
            for _ = 1, 4 do
                self.alpha = self.alpha - 160 / 4
                task.Wait()
            end
            object.Del(self)
        end)
    end
end
function trail_ef:render()
    SetAnimationState(self.img, 'mul+add', self.alpha, 255, 255, 255)
    DefaultRenderFunc(self)
end
bullets.trail_ef = trail_ef
-------------------------------------------------------


