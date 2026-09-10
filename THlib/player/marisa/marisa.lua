marisa_player = Class(player_class)
do
    LoadTexture('marisa_player', 'THlib\\player\\marisa\\marisa.png')
    LoadTexture('MarisaLaser', 'THlib\\player\\marisa\\MarisaLaser.png')
    LoadImageFromFile('marisa_hit_par', 'THlib\\player\\marisa\\marisa_hit_par.png')
    LoadImageGroup('marisa_player', 'marisa_player', 0, 0, 32, 48, 8, 3, 1, 1)
    LoadImage('marisa_bullet', 'marisa_player', 0, 144, 32, 16, 16, 16)
    LoadAnimation('marisa_bullet_ef', 'marisa_player', 0, 144, 32, 16, 4, 1, 4)
    SetImageState('marisa_bullet', '', 128, 255, 255, 255)
    LoadImage('marisa_missile', 'marisa_player', 192, 224, 32, 16, 8, 8)
    SetImageState('marisa_missile', '', 238, 255, 255, 255)
    LoadAnimation('marisa_missile_ef', 'marisa_player', 64, 224, 32, 32, 4, 1, 2)
    SetAnimationState('marisa_missile_ef', 'mul+add', 128, 255, 255, 255)
    LoadImage('marisa_support', 'marisa_player', 144, 144, 16, 16)
    LoadImage('marisa_laser_light', 'marisa_player', 224, 224, 32, 32)
    SetImageState('marisa_laser_light', 'mul+add', 255, 255, 255, 255)
end
local cos, sin, abs, int = cos, sin, abs, int
local max = max
local New = New

function marisa_player:init()
    player_class.init(self)
    self.name = 'Marisa'
    self.imgs = {}
    self.A = 1
    self.B = 1
    for i = 1, 24 do
        self.imgs[i] = 'marisa_player' .. i
    end
    self.hspeed = 5
    self.lspeed = 2.5
    self.offset = { 0, 0, 0, 0 }
    self.hitting = { false, false, false, false }
    self.bright = {}
    self.support_sign = -1
end
function marisa_player:frame()
    player_class.frame(self)
    local b
    if not self.__shoot_flag then
        self.offset = { 0, 0, 0, 0 }
    end
    for i = #self.bright, 1, -1 do
        b = self.bright[i]
        b.alpha = max(0, b.alpha - 10)
        b.x = b.x + cos(b.a) * b.v
        b.y = b.y + sin(b.a) * b.v
        if b.alpha == 0 then
            table.remove(self.bright, i)
        end
    end
    if lstg.var.gray or self.own_gray then
        for i = 1, 4 do
            table.insert(self.graysmear, { x = self.sp[i][1], y = self.sp[i][2], rot = 0, alpha = 50, img = 'marisa_support', hscale = 1, vscale = 1 })
        end
    end
end
function marisa_player:shoot()
    if self.nextspell <= 0 then
        if self.timer % 4 == 0 then
            PlaySound('plst00', 0.15, self.x / 1024)
            New(self.class.bullets.main, self.x + 6, self.y, 24, 90, 2)
            New(self.class.bullets.main, self.x - 6, self.y, 24, 90, 2)
        end
        if self.timer % 12 == 0 then
            PlaySound('lazer02', 0.025)
        end
        local angle = 90
        local target
        local x, y
        local d
        for i = 1, 4 do
            self.offset[i] = self.offset[i] + 18
            target = nil
            x, y = self.sp[i][1], self.sp[i][2]
            if lstg.var.man >= 80 then
                --人界时激光穿透
                target = {}
                object.EnemyNontjtDo(function(o)
                    if o.colli and marisa_player.IsInLaser(x, y, angle, o, 16) then
                        d = max(0, abs(y - o.y) - sin(acos(abs(x - o.x) / o.a)) * o.a)
                        if d < self.offset[i] then
                            table.insert(target, { o, d })
                        end
                    end
                end)
                self.hitting[i] = false
                for _, t in ipairs(target) do
                    if t[1] and t[1].class.base.take_damage then
                        --self.offset[i] = max(0, self.offset[i] - t.b)
                        self.hitting[i] = true
                        table.insert(self.bright, { x = x, y = y + t[2], alpha = 150, a = math.random() * 360, v = math.random() * 2 + 3 })
                        t[1].class.base.take_damage(t[1], 0.42)
                        if t[1].maxhp then
                            if t[1].hp > t[1].maxhp * 0.1 then
                                PlaySound('damage00', 0.3, t[1].x / 1024)
                            else
                                PlaySound('damage01', 0.6, t[1].x / 1024)
                            end
                        else
                            PlaySound('damage00', 0.3, t[1].x / 1024)
                        end
                    end
                end
            else
                object.EnemyNontjtDo(function(o)
                    if o.colli and marisa_player.IsInLaser(x, y, angle, o, 16) then
                        d = max(0, abs(y - o.y) - sin(acos(abs(x - o.x) / o.a)) * o.a)
                        if d < self.offset[i] then
                            target = o
                            self.offset[i] = d
                        end
                    end
                end)
                if target and target.class.base.take_damage then
                    --self.offset[i] = max(0, self.offset[i] - target.b)
                    self.hitting[i] = true
                    table.insert(self.bright, { x = x, y = y + self.offset[i], alpha = 150, a = math.random() * 360, v = math.random() * 2 + 3 })
                    target.class.base.take_damage(target, 0.34)
                    if target.maxhp then
                        if target.hp > target.maxhp * 0.1 then
                            PlaySound('damage00', 0.3, target.x / 1024)
                        else
                            PlaySound('damage01', 0.6, target.x / 1024)
                        end
                    else
                        PlaySound('damage00', 0.3, target.x / 1024)
                    end
                else
                    self.hitting[i] = false
                end
            end
        end
    end

end
function marisa_player:render()
    --support
    SetImageState('marisa_support', '', 255, 255, 255, 255)
    for i = 1, 4 do
        Render('marisa_support', self.sp[i][1], self.sp[i][2])
    end
    --support deco
    SetImageState('marisa_support', '', 128, 255, 255, 255)
    for i = 1, 4 do
        Render('marisa_support', self.sp[i][1], self.sp[i][2], 0, 1.2 + 0.1 * sin(self.timer * 0.2))
    end
    SetImageState('bright', "mul+add", 255, 135, 206, 235)
    if self.fire == 1 and self.nextshoot <= 0 then
        local timer = self.timer * 16
        local angle = 90
        local x, y
        for i = 1, 4 do
            x, y = self.sp[i][1], self.sp[i][2]
            marisa_player.CreateLaser("MarisaLaser", x, y, angle, 28, timer,
                    Color(200, (self.hitting[i] and 40) or 255, (self.hitting[i] and 40) or 255, 255), self.offset[i])
            Render('bright', x, y + self.offset[i], 0, 0.15)
            Render('bright', x, y + self.offset[i], 0, 0.15)
            Render('marisa_laser_light', x, y, self.timer * 5, 1 + 0.4 * sin(self.timer * 45 + i * 90))
        end
    end
    for _, b in ipairs(self.bright) do
        SetImageState('bright', "mul+add", b.alpha, 135, 206, 235)
        Render('bright', b.x, b.y, 0, 0.05)
    end
    player_class.render(self)
end

local bullets = {}
marisa_player.bullets = bullets
local main = Class(player_bullet_straight)
function main:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "marisa_bullet", x, y, v, a, dmg)
end
function main:kill()
    for _, v in ipairs({ 3, 4, 5 }) do
        New(bullets.main_ef, self.x, self.y, self.rot, v)
    end
end
bullets.main = main

local main_ef = Class(object)
function main_ef:init(x, y, rot, v)
    self.x = x
    self.y = y
    self.rot = rot
    self.vx = v * cos(rot)
    self.vy = v * sin(rot)
    self.img = 'marisa_bullet_ef'
    self.layer = LAYER.PLAYER_BULLET + 50
end
function main_ef:frame()
    if self.timer == 7 then
        Del(self)
    end
end
function main_ef:render()
    SetAnimationState('marisa_bullet_ef', '', 128 - 8 * self.timer, 255, 255, 255)
    DefaultRenderFunc(self)
end
bullets.main_ef = main_ef

local missile = Class(player_bullet_straight)
function missile:init(x, y, v, a, dmg)
    player_bullet_straight.init(self, "marisa_missile", x, y, v, a, dmg)
end
function missile:kill()
    PlaySound('msl2', 0.3)
    local a, r = ran:Float(0, 360), ran:Float(0, 6)
    New(bullets.missile_ef, self.x + r * cos(a), self.y + r * sin(a), self.dmg, 5)
end
bullets.missile = missile

local missile_ef = Class(object)
function missile_ef:init(x, y, dmg, t)
    self.x = x
    self.y = y
    self.a = 4
    self.b = 4
    self.img = 'marisa_missile_ef'
    self.group = GROUP.PLAYER_BULLET
    self.dmg = dmg / 20
    self.killflag = true
    self.layer = LAYER.PLAYER_BULLET
    self.mute = true
    self.t = t
end
function missile_ef:frame()
    if self.timer == 3 and self.t > 0 then
        local a, r = ran:Float(0, 360), ran:Float(8, 16)
        New(bullets.missile_ef, self.x + r * cos(a), self.y + r * sin(a), self.dmg * 20, self.t - 1)
    end
    if self.timer == 15 then
        Del(self)
    end
end
bullets.missile_ef = missile_ef

function marisa_player.IsInLaser(x0, y0, a, unit, w)
    local a1 = a - Angle(x0, y0, unit.x, unit.y)
    if a % 180 == 90 then
        if abs(unit.x - x0) < ((unit.a + unit.b + w) / 2) and cos(a1) >= 0 then
            return true
        else
            return false
        end
    else
        local A = tan(a)
        local C = y0 - A * x0
        if abs(A * unit.x - unit.y + C) / sqrt(A * A + 1) < ((unit.a + unit.b + w) / 2) and cos(a1) >= 0 then
            return true
        else
            return false
        end
    end
end

function marisa_player.CreateLaser(tex, x, y, a, w, t, c, offset)
    local width = w / 2
    local n = int(offset / 256)
    local length = t % 256
    local endl = int(offset - n * 256)
    local _, texh = GetTextureSize(tex)
    local w_x = width * cos(a)
    local w_y = width * sin(a)
    local blend = 'mul+add'
    local vx1, vy1, vx2, vy2, vx3, vy3
    for i = 1, n do
        vx1 = x + (length + 256 * (i - 1)) * cos(a)
        vy1 = y + (length + 256 * (i - 1)) * sin(a)
        vx2 = x + 256 * i * cos(a)
        vy2 = y + 256 * i * sin(a)
        vx3 = x + 256 * (i - 1) * cos(a)
        vy3 = y + 256 * (i - 1) * sin(a)
        RenderTexture(tex, blend,
                { vx1 - w_y, vy1 + w_x, 0.5, 0, 0, c },
                { vx2 - w_y, vy2 + w_x, 0.5, 256 - length, 0, c },
                { vx2 + w_y, vy2 - w_x, 0.5, 256 - length, texh, c },
                { vx1 + w_y, vy1 - w_x, 0.5, 0, texh, c })
        RenderTexture(tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, 256 - length, 0, c },
                { vx1 - w_y, vy1 + w_x, 0.5, 256, 0, c },
                { vx1 + w_y, vy1 - w_x, 0.5, 256, texh, c },
                { vx3 + w_y, vy3 - w_x, 0.5, 256 - length, texh, c })
    end

    vx2 = x + (endl + 256 * n) * cos(a)
    vy2 = y + (endl + 256 * n) * sin(a)
    vx3 = x + 256 * n * cos(a)
    vy3 = y + 256 * n * sin(a)
    if length <= endl then
        vx1 = x + (length + 256 * n) * cos(a)
        vy1 = y + (length + 256 * n) * sin(a)
        RenderTexture(tex, blend,
                { vx1 - w_y, vy1 + w_x, 0.5, 0, 0, c },
                { vx2 - w_y, vy2 + w_x, 0.5, endl - length, 0, c },
                { vx2 + w_y, vy2 - w_x, 0.5, endl - length, texh, c },
                { vx1 + w_y, vy1 - w_x, 0.5, 0, texh, c })
        RenderTexture(tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, 256 - length, 0, c },
                { vx1 - w_y, vy1 + w_x, 0.5, 256, 0, c },
                { vx1 + w_y, vy1 - w_x, 0.5, 256, texh, c },
                { vx3 + w_y, vy3 - w_x, 0.5, 256 - length, texh, c })
    else
        RenderTexture(tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, 256 - length, 0, c },
                { vx2 - w_y, vy2 + w_x, 0.5, endl + 256 - length, 0, c },
                { vx2 + w_y, vy2 - w_x, 0.5, endl + 256 - length, texh, c },
                { vx3 + w_y, vy3 - w_x, 0.5, 256 - length, texh, c })
    end
end
