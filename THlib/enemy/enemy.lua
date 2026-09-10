LoadTexture('enemy1', 'THlib\\enemy\\enemy1.png')
LoadImageGroup('enemy1_', 'enemy1', 0, 384, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy2_', 'enemy1', 0, 416, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy3_', 'enemy1', 0, 448, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy4_', 'enemy1', 0, 480, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy5_', 'enemy1', 0, 0, 48, 32, 4, 3, 8, 8)
LoadImageGroup('enemy6_', 'enemy1', 0, 96, 48, 32, 4, 3, 8, 8)
LoadImageGroup('enemy7_', 'enemy1', 320, 0, 48, 48, 4, 3, 16, 16)
LoadImageGroup('enemy8_', 'enemy1', 320, 144, 48, 48, 4, 3, 16, 16)
LoadImageGroup('enemy9_', 'enemy1', 0, 192, 64, 64, 4, 3, 16, 16)
LoadImageGroup('kedama', 'enemy1', 256, 320, 32, 32, 2, 2, 8, 8)
LoadImageGroup('enemy_x', 'enemy1', 192, 32, 32, 32, 4, 1, 8, 8)
LoadImageGroup('enemy_orb', 'enemy1', 192, 64, 32, 32, 4, 1, 8, 8)
LoadImageGroup('enemy_orb_ring', 'enemy1', 192, 96, 32, 32, 4, 1)
for i = 1, 4 do
    SetImageState('enemy_orb_ring' .. i, 'add+add', 255, 64, 64, 64)
end
LoadImageGroup('enemy_aura', 'enemy1', 192, 32, 32, 32, 4, 1)
for i = 1, 4 do
    SetImageState('enemy_aura' .. i, '', 128, 255, 255, 255)
end

LoadTexture('enemy2', 'THlib\\enemy\\enemy2.png')
LoadImageGroup('enemy10_', 'enemy2', 0, 0, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy11_', 'enemy2', 0, 32, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy12_', 'enemy2', 0, 64, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy13_', 'enemy2', 0, 96, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy14_', 'enemy2', 0, 128, 64, 64, 6, 2, 16, 16)
LoadImageGroup('enemy15_', 'enemy2', 0, 288, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy16_', 'enemy2', 0, 352, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy17_', 'enemy2', 0, 416, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy18_', 'enemy2', 0, 480, 32, 32, 12, 1, 8, 8)
LoadPS('ghost_fire_r', 'THlib\\enemy\\ghost_fire_r.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_b', 'THlib\\enemy\\ghost_fire_b.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_g', 'THlib\\enemy\\ghost_fire_g.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_y', 'THlib\\enemy\\ghost_fire_y.psi', 'parimg1', 8, 8)

LoadTexture('enemy3', 'THlib\\enemy\\enemy3.png')
LoadImageGroup('Ghost1', 'enemy3', 0, 0, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost3', 'enemy3', 0, 32, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost2', 'enemy3', 0, 64, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost4', 'enemy3', 0, 96, 32, 32, 8, 1, 8, 8)
LoadImageFromFile('death_ef3', 'THlib\\enemy\\death_ef3.png')

local cos, sin = cos, sin
---@class enemybase
enemybase = Class(object)

function enemybase:init(hp, nontaijutsu)
    self.layer = LAYER.ENEMY
    self.group = GROUP.ENEMY
    if nontaijutsu then
        self.group = GROUP.NONTJT
    end
    self.bound = false
    self.colli = false
    self.maxhp = hp or 1
    self.hp = hp or 1

    setmetatable(self, {
        __index = GetAttr,
        __newindex = function(t, k, v)
            if k == 'colli' then
                rawset(t, '_colli', v)
            else
                SetAttr(t, k, v)
            end
        end
    })
    self.colli = true
    self._servants = {}
    self._man_damage_counting = 0
    self._sakura_damage_counting = 0
    self._astral_damage_counting = 0
    self._season_damage_counting = 0
    self.dmg_factor = 1
    self.DMG_factor = 1
    self.astral_dmg_factor = 1
end

local lstg, min, max = lstg, min, max
local int = int

function enemybase:frame()
    SetAttr(self, 'colli', BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) and self._colli)
    if self.hp <= 0 then
        object.Kill(self)
    end
    self.astral_dmg_factor = lstg.var.ON_astral and 2.5 or 1
    task.Do(self)
end

local SearchStageLevel = SearchStageLevel
function enemybase:take_damage(dmg)
    lstg.var.score = lstg.var.score + 10
    dmg = min(self.hp, dmg)
    AddMoney(dmg / 60)
    if SearchStageLevel[1] then
        local t = "_sakura_damage_counting"
        self[t] = self[t] + dmg / 5
        if self[t] >= 1 then
            for _ = 1, self[t] do
                if not lstg.var.ON_sakura then
                    if player.__slow_flag then
                        lstg.var.sakura = min(50000, lstg.var.sakura + 10)
                    else
                        lstg.var.sakura = min(50000, lstg.var.sakura + 50)
                    end
                end
                self[t] = self[t] - 1
            end
        end
    end
    if SearchStageLevel[2] and lstg.var.man >= 80 then
        lstg.var.score = lstg.var.score + 60
        local t = "_man_damage_counting"
        self[t] = self[t] + dmg / 5
        if self[t] >= 1 then
            for _ = 1, self[t] do
                object.SetSize(New(item.obj.faith_minor, self.x + ran:Float(-5, 5), self.y + ran:Float(-5, 5)), 0.5)
                self[t] = self[t] - 1
            end
        end
    end
    if SearchStageLevel[7] and not self._no_drop_astral then
        local t = "_astral_damage_counting"
        self[t] = self[t] + dmg * max(0.2, 1 - Dist(self, player) / 200) / 15
        if self[t] >= 1 then
            for _ = 1, self[t] do
                Astral.drop(self.x, self.y, 3, int(self[t]))
                self[t] = self[t] - int(self[t])
            end
        end
    end
    if SearchStageLevel[10] then
        local t = "_season_damage_counting"
        self[t] = self[t] + dmg / 18
        if self[t] >= 1 then
            for _ = 1, self[t] do
                Season.drop(self.x, self.y, nil, nil, ran:Float(3, 4), ran:Float(0, 360))
                self[t] = self[t] - int(self[t])
            end
        end
    end
end
--
function enemybase:colli(other)
    if other.dmg then
        lstg.var.score = lstg.var.score + 10
        local dmg = other.dmg
        Damage(self, dmg)
        if self._master and self._dmg_transfer and IsValid(self._master) then
            Damage(self._master, dmg * self._dmg_transfer)
        end
    end
    other.killerenemy = self
    if not (other.killflag) then
        object.Kill(other)
    end
    if not other.mute then
        if self.dmg_factor then
            if self.hp > 100 then
                PlaySound('damage00', 0.4, self.x / 200)
            else
                PlaySound('damage01', 0.6, self.x / 200)
            end
        else
            if self.hp > 60 then
                if self.hp > self.maxhp * 0.2 then
                    PlaySound('damage00', 0.4, self.x / 200)
                else
                    PlaySound('damage01', 0.6, self.x / 200)
                end
            else
                PlaySound('damage00', 0.35, self.x / 200, true)
            end
        end
    end
end

function enemybase:del()
    object.DelServants(self)
end

function Damage(obj, dmg)
    if obj.class.base.take_damage then
        obj.class.base.take_damage(obj, dmg)
    end
end

enemy = Class(enemybase)

_enemy_aura_tb = { 1, 2, 3, 4, 3, 1, nil, nil, nil, 3, 1, 4, 1, nil, 3, 1, 2, 4, 3, 1, 2, 4, 1, 2, 3, 4, nil, nil, nil, nil, 1, 3, 2, 1 }
_death_ef_tb = { 1, 2, 3, 4, 3, 1, 1, 2, 1, 3, 1, 4, 1, 1, 3, 1, 2, 4, 3, 1, 2, 4, 1, 2, 3, 4, 1, 3, 2, 4, 1, 3, 2, 4 }

function enemy:init(style, hp, clear_bullet, auto_delete, nontaijutsu)
    enemybase.init(self, hp, nontaijutsu or false)
    self.clear_bullet = clear_bullet or false
    self.auto_delete = (auto_delete or auto_delete == nil) and true
    self._blend = ""
    self._a, self._r, self._g, self._b = 255, 255, 255, 255
    self._wisys = EnemyWalkImageSystem(self, style, 8)--by OLC，新行走图系统
end

function enemy:frame()
    enemybase.frame(self)
    self._wisys:frame()--by OLC，新行走图系统
    if self.dmgt and self.dmgt > 0 then
        self.dmgt = self.dmgt - 1
    end
    if self.auto_delete and BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) then
        self.bound = true
    end
end

function enemy:render()
    self._wisys:render(self.dmgt, self.dmgmaxt)--by OLC and ETC，新行走图系统
end

function enemy:take_damage(dmg)
    enemybase.take_damage(self, dmg)
    if self.dmgmaxt then
        self.dmgt = self.dmgmaxt
    end
    if not self.protect then
        self.hp = max(0, self.hp - dmg * self.dmg_factor * self.DMG_factor * self.astral_dmg_factor)
    end
end

local cols = { { 255, 99, 71 }, { 189, 252, 201 }, { 135, 206, 235 }, { 255, 227, 132 } }
function enemy.death_ef(x, y, hp, index)
    New(enemy_death_ef1, index, x, y)
    New(enemy_death_ef2, hp or 10, x, y, cols[index])
    for _ = 1, ran:Int(4, 8) do
        New(enemy_death_ef3, x, y, ran:Float(0.8, 2), ran:Float(0, 360), ran:Int(70, 90), ran:Float(0.9, 1.1), unpack(cols[index]))
    end
end

function enemy:kill()
    PlaySound('enep00', 0.3, self.x / 200, true)
    enemy.death_ef(self.x, self.y, self.maxhp, self.death_ef)
    if self.drop then
        item.Dropitem_PFP(self.x, self.y, self.drop)
    end
    if self.class.drop then
        self.class.drop(self)
    end

    if self.clear_bullet then
        New(bullet_cleaner, player.x, player.y, 800, 40, 40, true, false, 0, 0)
        --New(bullet_killer, player.x, player.y, false)
    end
    object.KillServants(self)
end
function enemy:del()
    enemy.death_ef(self.x, self.y, self.maxhp, self.death_ef)
end
enemy_death_ef1 = Class(object)
function enemy_death_ef1:init(index, x, y)
    self.img = 'bubble' .. index
    self.layer = LAYER.ENEMY + 50
    self.group = GROUP.GHOST
    self.x = x
    self.y = y
    self.rot = ran:Float(0, 360)
end
function enemy_death_ef1:render()
    local alpha = 1 - self.timer / 30
    alpha = 255 * alpha * alpha
    SetImageState(self.img, 'mul+add', alpha, 255, 255, 255)
    Render(self.img, self.x, self.y, self.rot + 15, 0.4 - self.timer * 0.01, self.timer * 0.2 + 0.7)
    Render(self.img, self.x, self.y, self.rot + 45, 0.4 - self.timer * 0.01, self.timer * 0.2 + 0.7)
    Render(self.img, self.x, self.y, self.rot + 75, 0.4 - self.timer * 0.01, self.timer * 0.2 + 0.7)
end
function enemy_death_ef1:frame()
    if self.timer == 30 then
        object.Kill(self)
    end
end

enemy_death_ef2 = Class(object)
function enemy_death_ef2:init(hp, x, y, color)
    self.color = color
    self.x = x
    self.y = y
    self.group = GROUP.GHOST
    self.layer = LAYER.ENEMY + 50
    self.circle, self.circle2 = {}, {}
    self.c = int(hp / 20) + 1
    for i = 1, self.c do
        self.circle[i] = { x + ran:Float(-15, 15), y + ran:Float(-15, 15) }
    end
    for i = 1, 6 do
        self.circle2[i] = { x + ran:Float(-25, 25), y + ran:Float(-25, 25) }
    end

end
function enemy_death_ef2:render()
    SetImageState("white", 'mul+add', 200 - 200 * sin(self.timer * 2), 255, 255, 255)
    for _, t in ipairs(self.circle) do
        misc.SectorRender(t[1], t[2], sin(self.timer * 2) * 30 * 0.98, sin(self.timer * 2) * 30, 0, 360, 18)
    end
    SetImageState("white", 'mul+add', 200 - 200 + 200 * sin(90 - self.timer * 2), unpack(self.color))
    for _, t in ipairs(self.circle2) do
        misc.SectorRender(t[1], t[2], sin(self.timer * 2) * 50 * 0.98, sin(self.timer * 2) * 50, 0, 360, 6)
    end


end
function enemy_death_ef2:frame()
    if self.timer == 45 then
        object.Kill(self)
    end
end

enemy_death_ef3 = Class(object)
function enemy_death_ef3:init(x, y, v, a, lifetime, size, r, g, b)
    self.img = 'death_ef3'
    self.x, self.y = x, y
    self.rot = ran:Float(0, 360)

    self.omiga = ran:Float(0.8, 1.2) * ran:Sign()
    self.hscale = size
    self.vscale = size

    self.layer = LAYER.ENEMY + 50
    self.group = GROUP.GHOST

    self.size = size
    self.v = v
    self.angle = a
    self.lifetime = lifetime
    self._x, self._y = x, y
    self.r, self.g, self.b = r, g, b
    self._s = ran:Float(1, 3)

end
function enemy_death_ef3:render()
    SetImageState(self.img, 'mul+add', 125 - 125 + 125 * sin(90 - self.timer / self.lifetime * 90), self.r, self.g, self.b)
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function enemy_death_ef3:frame()
    if self.timer >= self.lifetime then
        self.hide = true
        object.Del(self)
    end
    local i = 0 + (90 / self.lifetime) * (self.timer - 1)
    local l = self.v * self.lifetime
    self.x = self._x + l * cos(self.angle) * sin(i)
    self.y = self._y + l * sin(self.angle) * sin(i)
    self.hscale = self.size + (-self._s * self.size / self.lifetime) * (self.timer - 1)
end

Include 'THlib\\enemy\\boss.lua'