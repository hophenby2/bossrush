---@class boss
boss = Class(enemybase)

function boss:init(x, y, cards, bg, diff, scname, img)
    enemybase.init(self, 999999999)
    self.x, self.y = x, y
    self.img = "img_void"
    self.IsBoss = true
    --boss系统
    self._bosssys = boss.system(self, cards, bg, diff, scname)

    self.astral_dmg_factor = 1
    self.dmgt, self.dmgmaxt = 0, 2
    --boss行走图系统
    self._blend = ""
    self._a, self._r, self._g, self._b = 255, 255, 255, 255
    self._wisys = BossWalkImageSystem(self)
    self._wisys:SetImageInList(img)
    self._wisys:SetFloat(function(ani)
        return 0, 4 * sin(ani * 4)
    end)
    sp:UnitListAppend(boss_group, self)
    lstg.tmpvar.boss = self
    _boss = self
    boss.CreateDistortion(self, 160, self.self_color3)
    boss.show_aura(self, true)
end

function boss:CreateDistortion(r, color, LAYER_ADDON, x_range_speed_adder, z_range_speed_adder)
    New(distortion_effect_object, self, r, color, LAYER_ADDON, x_range_speed_adder, z_range_speed_adder)
end
function boss:ActiveDistortion(open)
    self.diston = false and open and setting.auradistortion
end
function boss:frame()
    self.astral_dmg_factor = lstg.var.ON_astral and 2.5 or 1
    self._bosssys:frame() --boss系统帧逻辑
    self._wisys:frame() --行走图系统帧逻辑
    --受击闪烁
    if self.dmgt and self.dmgt > 0 then
        self.dmgt = self.dmgt - 1
    end
end
function boss:render()
    self._bosssys:render() --boss系统渲染
    self._wisys:render(self.dmgt, self.dmgmaxt) --行走图渲染
end
function boss:kill()
    self._bosssys:kill() --boss系统kill
end
function boss:del()
    self._bosssys:del() --boss系统del
end
local enemybase = enemybase
function boss:take_damage(dmg)
    enemybase.take_damage(self, dmg)
    if self.dmgmaxt then
        self.dmgt = self.dmgmaxt
    end
    if not self.protect then
        local dmg0 = min(self.hp, dmg * self.dmg_factor * self.DMG_factor * self.astral_dmg_factor)
        self.spell_damage = self.spell_damage + dmg0
        self.hp = min(self.maxhp, self.hp - dmg0)
    end
end
function boss:take_damage2(dmg)
    enemybase.take_damage(self, dmg)
    if self.dmgmaxt then
        self.dmgt = self.dmgmaxt
    end
    if not self.protect then
        local dmg0 = min(self.hp, dmg * self.DMG_factor * self.astral_dmg_factor)
        self.spell_damage = self.spell_damage + dmg0
        self.hp = min(self.maxhp, self.hp - dmg0)
    end
end
local task, sin = task, sin
local Smooth = task.Smooth
function boss:show_aura(show)
    boss.ActiveDistortion(self, show)
    local a = self._bosssys.aura
    if IsValid(a) then
        if show then
            if a._scale < 1 then
                task.Clear(a)
                a.angle = -180
                a.scale = 0
                a._scale = 0
                a._alpha = 1
                a._timer = 0
                task.New(a, function()
                    local self = task.GetSelf()
                    for i = 1, 60 do
                        self.angle = -180 + 360 * sin(i * 1.5)
                        self.scale = 2 * sin(i * 1.5)
                        self._scale = sin(i * 1.5)
                        task.Wait()
                    end
                    --task.Wait(20)
                    for k = 0, 60 do
                        self.angle = self.angle + self.rotspeed
                        self.scale = 2 - 0.4 * Smooth(k / 60)
                        task.Wait()
                    end
                    self.open = true
                end)
            end
        else
            task.Clear(a)
            if a._scale < 1 then
                a._alpha = 0
                a._scale = 0
                self.open = false
            else
                a._alpha = 1
                a._scale = 1
                task.New(a, function()
                    local self = task.GetSelf()
                    for i = 1, 60 do
                        self._alpha = sin(90 - i * 1.5)
                        self._scale = sin(90 - i * 1.5)
                        task.Wait()
                    end
                    self.open = false
                end)
            end
        end
    end
end

function boss:cast(cast_t, force)
    self.cast_t = cast_t + 0.5
    self.cast = 1
    self.cast_force = force--强制施法动作
end
local IsValid = IsValid
local remove = table.remove
function boss:violent()
    local t = #self.otherboss
    if t == 0 then
        return
    end
    while #self.otherboss >= t do
        for i = t, 1, -1 do
            if not IsValid(self.otherboss[i]) then
                remove(self.otherboss, i)
            end
            task.Wait()
        end
    end
end

---@param editname string   @创建时使用的boss名
---@param BGM string    @BGM
---@param BG object @背景
---@param name string
---@param xy table  @初始x,y坐标
---@param SCBG object @符卡背景
---@param img table  @行走图
---@param level number   @boss所在关卡
---@param scale number  @对自身图像的大小调整
function boss.Define(editname, name, BGM, BG, xy, SCBG, img, level, scale)
    _editor_boss[editname .. level] = Class(boss, {
        cards = {},
        name = name,
        StageLevel = level,
        bgm = BGM,
        _bg = BG,
        difficulty = "All",
        id = editname .. level,
        init = function(self, cards)
            boss.init(self, xy[1], xy[2], cards, SCBG, "All", name, img)
            self.otherboss = {}
            self.ID = string.sub(editname, 1, -2)
            if scale then
                self.hscale = scale
                self.vscale = scale
            end
        end
    })
end

---@param index table|"{{id: string, name: string, x: number, y: number, img: string, scale: number}, ...}"
---@param group number
---@param BGM string
---@param BG object
---@param SCBG object
---@param level number
function boss.DefineGroup(index, group, BGM, BG, SCBG, level)
    for _, b in ipairs(index) do
        _editor_boss[group .. b.id .. level] = Class(boss, {
            cards = {},
            name = b.name,
            StageLevel = level,
            bgm = BGM,
            _bg = BG,
            difficulty = "All",
            id = group .. b.id .. level,
            init = function(self, cards)
                boss.init(self, b.x, b.y, cards, SCBG, "All", b.name, b.img)
                self.otherboss = {}
                self.ID = group
                if b.scale then
                    self.hscale = b.scale
                    self.vscale = b.scale
                end
            end
        })
    end
end

---@param name string
function boss.Create(name)
    return New(_editor_boss[name], _editor_boss[name].cards)
end

local Letter = {
    "a", "b", "c", "d", "e", "f", "g",
    "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z" }

local insert = table.insert
---@param group number
---@param level number
function boss.CreateGroup(group, level, letter, nowait)
    local t = {}
    if letter then
        insert(t, group .. letter .. level)
    else
        for _, l in ipairs(Letter) do
            if _editor_boss[group .. l .. level] then
                insert(t, group .. l .. level)
            else
                break
            end
        end
    end
    local _ref = {}
    for i = 1, #t do
        _ref[i] = boss.Create(t[i])
    end
    for i = 1, #t do
        for j = 1, #t do
            if j ~= i then
                insert(_ref[i].otherboss, _ref[j])
            end
        end
    end
    if not nowait then
        for i = 1, #t do
            while IsValid(_ref[i]) do
                task.Wait()
            end
        end
    end
end

----------------------------------------
---boss函数库和资源
local patch = "THlib\\enemy\\"
local function LoadBossTex()

    LoadTexture("boss", patch .. "boss.png")
    LoadImageGroup("bossring1", "boss", 80, 0, 16, 8, 1, 16)
    --LoadImageGroup("bossring2", "boss", 48, 0, 16, 8, 1, 16)
    LoadImageGroup("bossring3", "boss", 0, 0, 16, 8, 1, 16)
    LoadImage("spell_card_ef", "boss", 96, 0, 16, 128)
    LoadTexture("timesign", patch .. "timesign.png")
    LoadImage("hint.killtimer", "timesign", 0, 0, 128, 32)
    LoadImage("hint.truetimer", "timesign", 0, 32, 128, 32)
    LoadFont("bonus2", patch .. "bonus2.fnt", true)
    LoadTexture("scname_sign", patch .. "scname_sign.png")
    LoadImage("cardui_history", "scname_sign", 0, 32, 64, 32)
    LoadImage("cardui_bonus", "scname_sign", 0, 0, 64, 32)
    LoadTexture("sc_his_stage", patch .. "sc_his_stage.png")
    LoadImage("sc_failed", "sc_his_stage", 0, 0, 64, 32)
    LoadImageFromFile("boss_cardleft", patch .. "boss_cardleft.png")
    LoadImageFromFile("boss_light", patch .. "eff_cnlight.png")
    LoadTexture("boss_ui", patch .. "boss_ui.png")
    LoadImage("boss_spell_name_bg", "boss_ui", 0, 0, 256, 36)
    SetImageCenter("boss_spell_name_bg", 256, 0)

    LoadImage("boss_pointer", "boss_ui", 0, 64, 48, 16)
    SetImageCenter("boss_pointer", 24, 0)

    LoadImage("boss_sc_left", "boss_ui", 64, 64, 32, 32)
    SetImageState("boss_sc_left", "", 255, 128, 255, 128)
end

LoadBossTex()
Include(patch .. "boss_system.lua")--boss行为逻辑
Include(patch .. "boss_card.lua")--boss非符、符卡
Include(patch .. "boss_other.lua")--杂项、boss移动、特效
Include(patch .. "boss_ui.lua")--boss ui