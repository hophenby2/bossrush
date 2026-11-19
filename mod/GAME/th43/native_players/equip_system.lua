-------------------------------------
---装备系统  By S7UPID
-------------------------------------
EISlib.Player.Equipment = {} --装备分支
local M = EISlib.Player.Equipment
local scale = EISlib.Player.scale
--与PowerRank系统联动内容
local getRank = system.PowerRank.getRank
--0到3级相关参数
M.INTERVAL = {6, 6, 6, 6} --与rank有关的攻击间隔
--M.DMGRATE = {0.9, 1, 1.1, 1.2} --伤害倍率
M.DMGRATE = {1.2, 1.2, 1.2, 1.2} --伤害倍率
M.NUMBER = {0, 0, 0, 0} --子弹数量
M.NORMAL_DMGTOVALUE = 3 --伤害对槽值转化率
M.HYPER_DMGTOVALUE = 4 --hyper下伤害对槽值转化率
M.BULLET_COLOR = {{255, 255, 255}, {255, 255, 255}, {255, 255, 255}, {255, 255, 255}, {255, 255, 255}} --不同rank级别下，子弹的色调
--M.BULLET_SIZE = {0.8, 0.95, 1.1, 1.25, 1.4} --不同rank级别下，子弹的体积
M.BULLET_SIZE = {1.25, 1.25, 1.25, 1.25, 1.4} --不同rank级别下，子弹的体积

--自机能开火的条件
---@param self equip 装备类对象
---@param player player 自机对象
function M.canShoot(self, player)
    if KeyIsDown("shoot")
            and (self.nextshoot <= 0)
            and (player.lockshoot <= 0)
            and not player_class.isInDeathSentence(player) --决死时间也不能攻击
            and not player_class.isInRevive(player)  --复活时间也不能攻击
            and not player.dialog   --对话不能攻击
        then
        return true
    else
        return false
    end
end
function M.canLaser(self, player)
    if KeyIsDown("shoot")
            and player.lockshoot <= 0
            and not player_class.isInDeathSentence(player) --决死时间也不能攻击
            and not player_class.isInRevive(player)--复活时间也不能攻击
            and not player.dialog --对话不能攻击
    then
        return true
    else
        return false
    end
end

---@class equip 装备类
--region 创建普通的自机装备组合
---@param res_name string 素材名前缀
---@param attack_interval number 攻击间隔（现在定死主枪副枪、高低速攻击间隔一致）
---@param high_suppos table 高速子机排布表{{x1, y1, rot1},{x2, y2, rot2},{x3, y3, rot3},{x4, y4, rot4}}
---@param slow_suppos table 低速子机排布表{{x1, y1, rot1},{x2, y2, rot2},{x3, y3, rot3},{x4, y4, rot4}}
---@param high_shoot_func function 高速射击函数
---@param slow_shoot_func function 低速射击函数
---@param sup_render_func function 单个子机渲染模块
---@return equip
function M.create_normal_shoot_equip(attack_interval, high_suppos, slow_suppos, high_shoot_func, slow_shoot_func, sup_render_func, sound_name, sound_interval)
    local shoot_equip = plus.Class()
    function shoot_equip:init(player)
        self.player = player
        self.nextshoot = attack_interval
        self.interval = attack_interval --攻击间隔
        self.high_suppos = high_suppos
        self.slow_suppos = slow_suppos
        self:setSound(sound_name or "plst00", sound_interval or 0)
    end
    --改变攻击间隔
    function shoot_equip:changeInterval(interval)
        self.interval = interval
    end
    function shoot_equip:getSupPos(i)
        local player = self.player
        local x = player.x + self.slow_suppos[i][1] + player.shift*(self.high_suppos[i][1]-self.slow_suppos[i][1])
        local y = player.y + self.slow_suppos[i][2] + player.shift*(self.high_suppos[i][2]-self.slow_suppos[i][2])
        local rot = self.slow_suppos[i][3] + player.shift*(self.high_suppos[i][3]-self.slow_suppos[i][3])
        return x, y, rot
    end
    --获取高低速配置的角度
    function shoot_equip:getSupAngleHighAndSlow(i)
        return self.high_suppos[i][3], self.slow_suppos[i][3]
    end
    function shoot_equip:shoot()
        local player = self.player
        if M.canShoot(self, player) then
            --PlaySound("plst00")
            if self.next_play_sound == 0 then
                PlaySound(self.current_sound)
                self.next_play_sound = self.next_play_sound + self.max_next_play_sound
            end
            --高低速攻击
            if player.slow == 0 then
                high_shoot_func(self)
            else
                slow_shoot_func(self)
            end
            self.nextshoot = self.nextshoot + self.interval --间隔
        end
    end
    function shoot_equip:update()
        self.next_play_sound = max(0, self.next_play_sound - 1)
        self.nextshoot = max(0, self.nextshoot - 1)
    end
    function shoot_equip:draw()
        sup_render_func(self)
    end
    function shoot_equip:setSound(name, interval)
        self.current_sound = name
        self.max_next_play_sound = interval --最大音效播放间隔
        self.next_play_sound = interval --当前音效播放间隔
    end
    return shoot_equip
end
--endregion

--region 创建完整自机装备组合
---@param res_name string 素材名前缀
---@param attack_interval number 攻击间隔（现在定死主枪副枪、高低速攻击间隔一致）
---@param sup_init_func function 初始化
---@param high_suppos table 高速子机排布表{{x1, y1, rot1},{x2, y2, rot2},{x3, y3, rot3},{x4, y4, rot4}}
---@param slow_suppos table 低速子机排布表{{x1, y1, rot1},{x2, y2, rot2},{x3, y3, rot3},{x4, y4, rot4}}
---@param high_shoot_func function 高速射击函数
---@param slow_shoot_func function 低速射击函数
---@param sup_frame_func function 帧逻辑
---@param sup_render_func function 单个子机渲染模块
---@return equip
function M.create_complete_shoot_equip(attack_interval, sup_init_func, high_suppos, slow_suppos, high_shoot_func, slow_shoot_func, sup_frame_func, sup_render_func)
    local shoot_equip = M.create_normal_shoot_equip(attack_interval, high_suppos, slow_suppos, high_shoot_func, slow_shoot_func, sup_render_func)
    local old = shoot_equip.init
    function shoot_equip:init(player)
        old(self, player)
        sup_init_func(self) --注意这个传入的是装备类创建的对象不是自机类对象！
    end
    function shoot_equip:update()
        self.nextshoot = max(0, self.nextshoot - 1)
        sup_frame_func(self)
    end
    return shoot_equip
end
--endregion


--region 自机通用直线子弹定义
--消失特效（帧动画）
M.straight_bullet_ef = Class(object)
function M.straight_bullet_ef:init(img, x, y, rot, s, blend, vx, vy, _a)
    self.x, self.y = x, y
    self.img = img
    self.layer = LAYER_PLAYER_BULLET + 50
    self.hscale, self.vscale = s*M.BULLET_SIZE[getRank() + 1], s*M.BULLET_SIZE[getRank() + 1]
    self._blend = blend
    self.vx, self.vy = 0.25*vx, 0.25*vy
    self.rot = rot
    local co = M.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, blend, _a or 150, co[1], co[2], co[3])
end
function M.straight_bullet_ef:frame()
    if self.timer == 21 then
        self.hscale = self.hscale + 0.01
        self.vscale = self.hscale
        self.status = "del"
    end
end
function M.straight_bullet_ef:render()
    lstg.SetAnimationState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    RenderAnimation(self.img, math.ceil(self.timer/3), self.x, self.y, self.rot, self.hscale, self.vscale)
    --lstg.DefaultRenderFunc(self)
end

--用帧动画消失的子弹
M.straight_bullet = Class(object)
function M.straight_bullet:init(img, x, y, v, rot, dmg, s, blend, _a, value, colli_a, colli_b, kill_eff_ani, eff_a)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.bound = false
    self.x = x
    self.y = y
    self.img = img
    self.rot = rot
    self.vx = v * cos(rot)
    self.vy = v * sin(rot)
    self.hscale = s * scale*M.BULLET_SIZE[getRank() + 1]
    self.vscale = s * scale*M.BULLET_SIZE[getRank() + 1]
    self.a = colli_a or 12
    self.b = colli_b or 24
    self.rect = true
    self.effblend = blend
    self.dmg = dmg
    self.value = value or 10 --一发子弹所增加的槽值
    local co = M.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, "", _a, co[1], co[2], co[3])
    self.kill_eff_ani = kill_eff_ani or self.img .. "_ef"
    self.eff_a = eff_a
end
function M.straight_bullet:frame()
    if self.timer > 60 then
        self.bound = true
    end
end
function M.straight_bullet:kill()
    PlaySound("damage00")
    New(M.straight_bullet_ef, self.kill_eff_ani,
            self.x, self.y, self.rot, self.hscale, self.effblend, self.vx, self.vy, self.eff_a)
end
function M.straight_bullet:render()
    SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function M.straight_bullet:del()
    --straight_bullet:kill()
end

--自身贴图拉长消失的子弹
local bullet_fade_out_class = Class(object)
function bullet_fade_out_class:frame()
    self.hscale = self.hscale + self.dhscale
    self.vscale = self.vscale + self.dvscale
    if self.timer == 12 then
        self.status = "del"
    end
end
function bullet_fade_out_class:render()
    SetImageState(self.img, self.effblend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

M.straight_bullet2 = Class(object)
function M.straight_bullet2:init(img, x, y, v, rot, dmg, s, blend, _a, value, colli_a, colli_b, eff_a)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.bound = false
    self.x = x
    self.y = y
    self.img = img
    self.rot = rot
    self.vx = v * cos(rot)
    self.vy = v * sin(rot)
    self.hscale = s * scale*M.BULLET_SIZE[getRank() + 1]
    self.vscale = s * scale*M.BULLET_SIZE[getRank() + 1]
    self.a = colli_a or 12
    self.b = colli_b or 24
    self.rect = true
    self.effblend = blend
    self.dmg = dmg
    self.value = value or 10
    self._a = _a
    local co = M.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, "", _a, co[1], co[2], co[3])
    self.eff_a = eff_a
end
function M.straight_bullet2:frame()
    if self.timer > 60 then
        self.bound = true
    end
end
function M.straight_bullet2:render()
    SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function M.straight_bullet2:kill()
    PlaySound("damage00")
    New(M.straight_bullet_ef, self.img .. "_ef",
            self.x, self.y, self.rot, self.hscale, self.effblend, self.vx, self.vy, self.eff_a)
    M.straight_bullet2.fade_out_init(self)
end
function M.straight_bullet2:del()
    --straight_bullet2:kill()
end
function M.straight_bullet2:fade_out_init()
    self.status = "normal"
    self.timer = 1
    self.bound = false
    self.group = GROUP_GHOST
    self.dhscale = self.hscale/12
    self.dvscale = -self.vscale/12
    self.class = bullet_fade_out_class
    SetV(self, 5, self.rot)
    local co = M.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, self.effblend, self.eff_a or self._a, co[1], co[2], co[3])
end
--endregion

--region 常见的灵梦诱导
local maxRange = 900 --最大判断范围（不包含）
local function findtarget(self)
    local target, r
    local minr = maxRange
    local x, y = self.x, self.y
    local function it(group)
        for _, o in ObjList(group) do
            if (o.class.base == boss.class or o.Isbacklight) and o.colli then  --如果有boss或者光背就直优先锁定
                target = o
                break
            else
                r = Dist(x, y, o.x, o.y)
                if r < minr and o.colli == true then
                    minr = r
                    target = o
                end
            end
        end
    end
    it(GROUP_NONTJT)
    it(GROUP_ENEMY)
    return target
end
M.trail = Class(object)
function M.trail:init(img, x, y, v, rot, dmg, s, blend, _a, value, eff_a)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.bound = false
    self.img = img
    self.x = x
    self.y = y
    self.rot = rot
    self.v = v
    self.target = findtarget(self) --索敌
    self.dmg = dmg
    self.a = 24
    self.b = 20
    self.rate = 0
    self.rect = true
    self.hscale = s * scale*M.BULLET_SIZE[getRank() + 1]
    self.vscale = self.hscale
    self.effblend = blend
    self.value = value or 10
    self.eff_a = eff_a --产生击中特效的透明度
    local co = M.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, blend, _a, co[1], co[2], co[3])
end
function M.trail:frame()
    if self.timer > 60 then
        self.bound = true
    end
    self.rate = min(1, self.rate + 0.01)
    local target = self.target
    if lstg.IsValid(target) and target.colli then
        local a = math.mod(lstg.Angle(self, target) - self.rot + 720, 360)
        if a > 180 then
            a = a - 360
        end
        self.rot = self.rot + self.rate*a
    else
        self.target = findtarget(self) --目标死了或者失去判定了就再找新的目标
    end
    self.vx = self.v * cos(self.rot)
    self.vy = self.v * sin(self.rot)
end
function M.trail:kill()
    lstg.New(M.straight_bullet_ef, self.img .. "_ef",
            self.x, self.y, self.rot, self.hscale, self.effblend, self.vx, self.vy, self.eff_a)
end
function M.trail:del()
    M.trail.kill(self)
end
--endregion
