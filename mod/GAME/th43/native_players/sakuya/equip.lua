-------------------------------------------
---东方栖霞园-自机-咲夜装备配置--
-------------------------------------------

local res_path = "res/player/sakuya/"
local player_name = "sakuya" -- 自机名字
local res_name = "_"..player_name -- 与本自机相关的素材名字（注意前面加一个下划线，是要和同名的boss素材分开）

--导入其他包
local BreakEffect = EGGlib.RenderEffect.BreakEffect

-- 加载自身素材

local equip_names = EISlib.Player.makeResourcesName(res_name, res_path) -- 生成资源名
local bomb_magic_imgs = {} --法阵
for i = 0, 1 do
    for j = 1, 2 do
        bomb_magic_imgs[2 * i + j] = res_name .. "_bomb_magic" .. (2 * i + j)
    end
end
local bomb_knife_red_img = res_name.."_bomb_knife_red" --红刀
local bomb_knife_blue_img = res_name.."_bomb_knife_blue" --蓝刀
local boundary_imgs = {} --结界圈
for i = 1, 3 do
    boundary_imgs[i] = res_name .. "_boundary" .. i
end

local main_bullet_img = equip_names[1][1]
local sup_img = equip_names[2][2]
local hyper_sup_img = equip_names[3][2]
local straight_bullet_img = equip_names[4][1]
local spread_bullet_img_yellow = equip_names[2][1]
local spread_bullet_img_green = equip_names[3][1]

local function loadRes()
    lstg.Print("开始加载自机'" .. player_name .. "'的资源")
    
    -- 基础资源
    EISlib.Player.loadRes(res_name, res_path)
    -- 雷
    LoadTexture(res_name.."_bomb1", res_path.."bomb1.png")
    LoadTexture(res_name.."_bomb2", res_path.."bomb2.png")
    -- 法阵
    for i = 0, 1 do
        for j = 1, 2 do
            LoadImage(bomb_magic_imgs[2 * i + j], res_name.."_bomb1", 512*(j - 1), 512*i, 512, 512)
        end
    end
    -- 刀子
    LoadAnimation(bomb_knife_red_img, res_name.."_bomb2", 180, 0, 180, 74, 1, 4, 8)
    LoadAnimation(bomb_knife_blue_img, res_name.."_bomb2", 0, 0, 180, 74, 1, 4, 8)
    -- 结界圈
    for i = 1, 3, 2 do -- 跳过2
        LoadImageFromFile(boundary_imgs[i], res_path.."boundary"..i..".png")
    end
    LoadAniFromFile(boundary_imgs[2], res_path .. "boundary2.png", false, 2, 2, 8)
    
    lstg.Print("加载自机'" .. player_name .. "'的资源完成")
end

-- 自机攻击

local E = EISlib.Player.Equipment
local scale = EISlib.Player.scale

--索敌函数
local maxRange = 900 --最大判断范围（不包含）
local function findTarget(self)
    local dist, target = maxRange
    if IsValid(_boss) and _boss.colli then
        target = _boss
    else
        EGGlib.ObjectEvent.allEnemyAndNontjtDo(
                function(obj)
                    local d = Dist(self, obj)
                    local max_taunt_rank = -1
                    if          obj.colli
                            and BoxCheck(obj, -192, 192, -224, 224)
                            and enemy.getTauntRank(obj) >= max_taunt_rank
                            and d < dist
                    then
                        dist = d
                        max_taunt_rank = enemy.getTauntRank(obj)
                        target = obj
                    end
                end)
    end
    return target
end

--创建一个装备配置
local function create_equip(rank)
    local interval = E.INTERVAL[rank + 1]
    local dmg_rate = E.DMGRATE[rank + 1]
    local number = E.NUMBER[rank + 1]
    local high_main_dmg = 1.5*dmg_rate --高速主枪伤害
    local high_sup_dmg = 0.75*dmg_rate --高速副枪伤害
    local slow_main_dmg = 1.5*dmg_rate --低速主枪伤害
    local slow_sup_dmg = 0.75*dmg_rate --低速副枪伤害
    local equip_class = E.create_complete_shoot_equip(
            interval,  --默认攻击间隔(f
    --附加的初始化函数
            function(self)
                self.target = nil --被lock的目标
            end,
    --高速子机排布
            {
                {-40, 0, 93},
                {-20, 30, 66},
                { 20, 30, 114},
                { 40, 0, 87}
            },
    --低速子机排布
            {
                {-70, 0, 90},
                {-30, -10, 90},
                { 30, -10, 90},
                { 70, 0, 90}
            },
    --高速射击函数(下面这个self是装备类对象，不是自机类对象！）
            function(self)
                local player = self.player
                --主炮射击
                local angles = {-20, -9, 0, 9, 20}
                for i = 1, 5 do
                    New(E.straight_bullet, main_bullet_img, player.x, player.y,
                            20, --velocity
                            90 + angles[i], --angle
                            high_main_dmg,--dmg
                            1.25, --scale
                            "mul+add", --blend
                            120, --_a
                            20, --value
                            24, --colli_a
                            12, --colli_b
                            nil, --kill_eff_ani
                            50
                    )
                end
                --副枪射击
                local imgs = {spread_bullet_img_green, spread_bullet_img_yellow, spread_bullet_img_yellow, spread_bullet_img_green}
                local x, y, rot
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    for j = -1, 1, 2 do
                        for u = -number, number, 2 do
                            New(E.straight_bullet, imgs[i], x + 8*sin(rot + 6*j)*u, y - 8*cos(rot + 6*j)*u,
                                    20, --velocity
                                    rot + 6*j, --angle
                                    high_sup_dmg, --dmg
                                    1.25, --scale
                                    "mul+add", --blend
                                    150, --_a
                                    10, --value
                                    24, --colli_a
                                    12, --colli_b
                                    nil, --kill_eff_ani
                                    50
                            )
                        end
                    end
                end
            end ,
    --低速射击函数
            function(self)
                local player = self.player
                --主炮射击 dps:1.5*4*60/6 = 60
                local angles = {-12, -6, 0, 6, 12}
                for i = 1, 5 do
                    New(E.straight_bullet, main_bullet_img, player.x, player.y,
                            20, --velocity
                            90 + angles[i], --angle
                            slow_main_dmg,--dmg
                            1.25, --scale
                            "mul+add", --blend
                            120, --_a
                            20, --value
                            24, --colli_a
                            12, --colli_b
                            nil, --kill_eff_ani
                            50
                    )
                end
                --副枪射击 dps:1*4*60/6 = 40
                local x, y, rot
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    if IsValid(self.target) then
                        rot = Angle(x, y, self.target.x, self.target.y)
                    end
                    for u = -1, 1, 2 do
                        New(E.straight_bullet2, straight_bullet_img, x + 5*sin(rot)*u, y - 5*cos(rot)*u,
                                20, --velocity
                                rot, --angle
                                slow_sup_dmg, --dmg
                                1.75, --scale
                                "mul+add", --blend
                                150,  --_a
                                10, --value
                                24, --colli_a
                                12, --colli_b
                                50
                        )
                    end
                end
            end ,
    --帧逻辑
            function(self)
                self.target = findTarget(self.player)
            end,
    --单子机渲染
            function(self)
                local timer, x, y = self.player.timer
                for i = 1, 4 do
                    x, y = self:getSupPos(i)
                    Render(sup_img, x, y, -timer*3, 0.6*scale)
                end
            end)
    --导出
    return equip_class
end

local equip_classes = {}
--创建0-3级rank对应的装备
for rank = 0, 3 do
    table.insert(equip_classes, create_equip(rank))
end

--hyperMode
local function create_hyper_equip()
    local high_main_dmg = 1.25 --高速主枪伤害
    local high_sup_dmg = 0.75 --高速副枪伤害
    local slow_main_dmg = 1.25 --低速主枪伤害
    local slow_sup_dmg = 0.75 --低速副枪伤害

    local equip_class = E.create_complete_shoot_equip(
            6,  --默认攻击间隔(f
    --附加的初始化函数
            function(self)
                self.target = nil --被lock的目标
                self:setSound("hyper3", 0)
            end,
    --高速子机排布
            {
                {-40, 0, 105 - 12},
                {-20, 30, 66},
                { 20, 30, 114},
                { 40, 0, 75 + 12}
            },
    --低速子机排布
            {
                {-90, 0, 90},
                {-40, -10, 90},
                { 40, -10, 90},
                { 90, 0, 90}
            },
    --高速射击函数(下面这个self是装备类对象，不是自机类对象！）
            function(self)
                local player = self.player
                --主炮射击
                local angles = {-31, -20, -9, 0, 9, 20, 31}
                for i = 1, 7 do
                    New(E.straight_bullet, main_bullet_img, player.x, player.y,
                            20, --velocity
                            90 + angles[i], --angle
                            high_main_dmg,--dmg
                            1.25, --scale
                            "mul+add", --blend
                            120, --_a
                            20, --value
                            24, --colli_a
                            12, --colli_b
                            nil, --kill_eff_ani
                            50
                    )
                end
                --副枪射击
                local imgs = {spread_bullet_img_green, spread_bullet_img_yellow, spread_bullet_img_yellow, spread_bullet_img_green}
                local x, y, rot
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    for j = -3, 3, 2 do
                        New(E.straight_bullet, imgs[i], x, y,
                                20, --velocity
                                rot + 6*j, --angle
                                high_sup_dmg, --dmg
                                1.25, --scale
                                "mul+add", --blend
                                150, --_a
                                10, --value
                                24, --colli_a
                                12, --colli_b
                                nil, --kill_eff_ani
                                50
                        )
                    end
                end
            end ,
    --低速射击函数
            function(self)
                local player = self.player
                --主炮射击
                local angles = {-18, -12, -6, 0, 6, 12, 18}
                for i = 1, 7 do
                    New(E.straight_bullet, main_bullet_img, player.x, player.y,
                            20, --velocity
                            90 + angles[i], --angle
                            slow_main_dmg,--dmg
                            1.25, --scale
                            "mul+add", --blend
                            120, --_a
                            20, --value
                            24, --colli_a
                            12, --colli_b
                            nil, --kill_eff_ani
                            50
                    )
                end
                --副枪射击
                local x, y, rot
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    if IsValid(self.target) then
                        rot = Angle(x, y, self.target.x, self.target.y)
                    end
                    for u = -3, 3, 2 do
                        New(E.straight_bullet2, straight_bullet_img, x + 5*sin(rot)*u, y - 5*cos(rot)*u,
                                20, --velocity
                                rot, --angle
                                slow_sup_dmg, --dmg
                                1.75, --scale
                                "mul+add", --blend
                                150,  --_a
                                10, --value
                                24, --colli_a
                                12, --colli_b
                                50
                        )
                    end
                end
            end ,
    --帧逻辑
            function(self)
                --特殊敌人可能需要被锁定，如boss
                if IsValid(self.locked_target) then
                    self.target = self.locked_target
                else
                    self.locked_target = nil
                    self.target = findTarget(self.player)
                end
            end,
    --单子机渲染
            function(self)
                local timer, x, y = self.player.timer
                for i = 1, 4 do
                    x, y = self:getSupPos(i)
                    Render(hyper_sup_img, x, y, 0, 0.8*scale)
                end
            end)
    --导出
    return equip_class
end

table.insert(equip_classes, create_hyper_equip()) --四级hyper先暂时用3级的装备

--region bomb

local knife_blue = Class(object)
function knife_blue:init(x, y, v0, a, da)
    self.dmg = 0.5*1.369
    self.x, self.y = x, y
    self.hscale, self.vscale = 0.25, 0.25
    self.group = GROUP_SPELL
    self.layer = LAYER_PLAYER - 1
    self.colli = false
    self.bound = false
    self.a, self.b = 30, 20
    self.rot = a
    local dx, dy = cos(a), sin(a)
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    EGGlib.RenderEffect.newAniTrail(
            self, --master,
            -1, 5, 4, --dlayer, maxnum, frame,
            bomb_knife_blue_img, 1, "mul+add", --img, size, blend,
            999, 0.3, false--times, _a_rate, Isdsize
    )
    task.New(self, function()
        local r = 0
        local v, dv, dh, dvs = v0, -v0/60, 0.75/60, 0.75/60
        for _ = 1, 60 do
            v = v + dv
            r = r + v
            self.x, self.y = player.x + r*dx, player.y + r*dy
            self.hscale, self.vscale = self.hscale + dh, self.vscale + dvs
            task.Wait(1)
        end
        --转转乐
        self.colli = true
        local t = 20
        da = da/t
        for _ = 1, t do
            self.rot = self.rot + da
            task.Wait(1)
        end
        SetV(self, 10, self.rot)
        --拉长
        local ds, dcolli = 5/20
        dcolli = ds*self.a/self.hscale
        for _ = 1, 20 do
            self.hscale = self.hscale + ds
            self.a = self.a + dcolli
            task.Wait(1)
        end
        task.Wait(60)
        Del(self)
    end)
end
function knife_blue:frame()
    task.Do(self)
    if self.timer%10 == 0 then
        EISlib.Bullet.Laser.cutLasersByCircle(self.x, self.y, self.b, false)
    end --截断激光
end
function knife_blue:render()
    SetAnimationState(bomb_knife_blue_img, "mul+add", Color(self._a, 255, 255, 255))
    RenderAnimation(bomb_knife_blue_img, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function knife_blue:colli(o)
    if o.group == GROUP_ENEMY_BULLET then
        Del(o)
    elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
        enemybase.damage(o, self.dmg)
    end
end

local knife_red = Class(object)
function knife_red:init(x, y, v0, a, da)
    self.dmg = 0.25*1.369
    self.x, self.y = x, y
    self.hscale, self.vscale = 0.25, 0.25
    self.group = GROUP_SPELL
    self.layer = LAYER_PLAYER - 1
    self.colli = false
    self.bound = false
    self.a, self.b = 22.5, 20
    self.rot = a
    local dx, dy = cos(a), sin(a)
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    EGGlib.RenderEffect.newAniTrail(
            self, --master,
            -1, 5, 4, --dlayer, maxnum, frame,
            bomb_knife_red_img, 1, "mul+add", --img, size, blend,
            999, 0.3, false--times, _a_rate, Isdsize
    )
    task.New(self, function()
        local r = 0
        local v, dv, dh, dvs = v0, -v0/60, 0.5/60, 0.75/60
        for _ = 1, 60 do
            v = v + dv
            r = r + v
            self.x, self.y = player.x + r*dx, player.y + r*dy
            self.hscale, self.vscale = self.hscale + dh, self.vscale + dvs
            task.Wait(1)
        end
        --转转乐
        self.colli = true
        local t = 20
        da = da/t
        for _ = 1, t do
            self.rot = self.rot + da
            task.Wait(1)
        end
        local target = findTarget(self)
        if target then
            self.rot = Angle(self, target)
        end
        SetV(self, 10, self.rot)
        --拉长
        local ds, dcolli = 5/20
        dcolli = ds*self.a/self.hscale
        for _ = 1, 20 do
            self.hscale = self.hscale + ds
            self.a = self.a + dcolli
            task.Wait(1)
        end
        task.Wait(60)
        Del(self)
    end)
end
function knife_red:frame()
    task.Do(self)
    if self.timer%10 == 0 then
        EISlib.Bullet.Laser.cutLasersByCircle(self.x, self.y, self.b, false)
    end --截断激光
end
function knife_red:render()
    SetAnimationState(bomb_knife_red_img, "mul+add", Color(self._a, 255, 255, 255))
    RenderAnimation(bomb_knife_red_img, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function knife_red:colli(o)
    if o.group == GROUP_ENEMY_BULLET then
        Del(o)
    elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
        PlaySound("explode")
        enemybase.damage(o, self.dmg)
    end
end

local sizeChange = EGGlib.ObjectEvent.sizeChange
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local disappear = EGGlib.ObjectEvent.disappearByAlpha

local magic_eff = Class(object)
function magic_eff:init(x, y, a)
    self.rot = a
    self.layer = LAYER_PLAYER - 2
    self.x, self.y = x, y
    self.hscale, self.vscale = 0, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    task.New(self, function()
        sizeChangeTask(self, 2, 30)
        disappear(self, 30)
        Del(self)
    end)
end
function magic_eff:frame()
    task.Do(self)
end
function magic_eff:render()
    SetImageState(bomb_magic_imgs[1], "", Color(self._a, 255, 255, 255))
    Render(bomb_magic_imgs[1], self.x, self.y, self.rot, self.hscale, self.vscale)
end

local magic = Class(object)
function magic:init()
    self.x, self.y = player.x, player.y
    self.omiga = 3
    self.layer = LAYER_PLAYER - 2
    self.hscale, self.vscale = 0, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    task.New(self, function()
        sizeChangeTask(self, 1, 30)
        for _ = 1, 30 do
            New(magic_eff, self.x, self.y, self.rot)
            task.Wait(8)
        end
        sizeChange(self, -1, 30)
        Del(self)
    end)
    task.New(self, function()
        while true do
            self.x, self.y = player.x, player.y
            task.Wait(1)
        end
    end)
end
function magic:frame()
    task.Do(self)
end
function magic:render()
    SetImageState(bomb_magic_imgs[1], "", Color(self._a, 255, 255, 255))
    Render(bomb_magic_imgs[1], self.x, self.y, self.rot, self.hscale, self.vscale)
end

function equip_classes.spell(self)
    PlaySound("blade2")
    self.lockshoot = max(self.lockshoot, self.nextspell)
    tasker(function()
        effect.shakeScreen(90, 4)
        New(magic)
        local da = 360/21
        for i = 1, 21 do
            for j = 0, 1 do
                New(knife_blue, self.x, self.y, 4.5, 180*j + da*i, 300*tranU(j))
                New(knife_red, self.x, self.y, 3.5, 180*j - da*i, 360)
            end
            task.Wait(3)
        end
        task.Wait(20)
        effect.shakeScreen(90, 4)
        task.Wait(60)
        --New(BreakEffect, player.x, player.y,  'tree_leaf_white', 'Cherry_eff', 100, 100, 255, "mul+add")
        PlaySound("explode")
        da = 360/16
        for i = 1, 16 do
            for j = 0, 1 do
                New(knife_red, self.x, self.y, 3 + 2*j, da*i + 0.5*da, 240*tranU(i))
                New(knife_blue, self.x, self.y, 2 + 2*j, da*i, -240*tranU(i))
            end
        end
    end)
    tasker(function()
        for i = 1, self.lockshoot do
            self.class.changeSpeedWhenBomb(self) --身体灌铅
            task.Wait(1)
        end
        self.class.recoveredSpeed(self)
    end)
end

--endregion

--region 结界圈定义

local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

local boundary1 = Class(object)
function boundary1:init()
    self.bound = false
    self.layer = LAYER_BG + 51
    self.x, self.y = player.x, player.y
    self.omiga = -0.25
    self.hscale, self.vscale = 0, 0
    self._a = 150
    self.kill_flag = false
    task.New(self, function()
        local t = 90
        local s, ds = 0, (1/sin(170))/t
        local dx, rate = 170/t
        local t_a = 60
        local d_a = (255 - self._a)/t_a
        local wt_a = t - t_a
        for i = 1, t do
            s = s + ds
            rate = sin(dx*i)
            self.hscale, self.vscale = s*rate, s*rate
            if i > wt_a then
                self._a = self._a + d_a
            end
            task.Wait(1)
        end
        self.hscale, self.vscale = 1, 1
    end)
end
function boundary1:frame()
    task.Do(self)
    self.x, self.y = player.x, player.y
end
function boundary1:render()
    local x, y = self.x, self.y
    SetImageState(boundary_imgs[1], "mul+rev", Color(self._a, 255, 255, 255))
    Render(boundary_imgs[1], x, y, self.rot, self.hscale, self.vscale)
    SetAnimationState(boundary_imgs[2], "", Color(self._a, 255, 255, 255))
    RenderAnimation(boundary_imgs[2], self.ani, x, y, self.rot, self.hscale, self.vscale)
end
function boundary1:kill()
    if not self.kill_flag then
        PreserveObject(self)
        self.kill_flag = true
        task.New(self, function()
            alphaAndSizeChange(self, -255, 2, 60)
            self.status = 'del'
        end)
    end
end
function boundary1:del()
    boundary1.kill(self)
end

local boundary2 = Class(object)
function boundary2:init()
    self.bound = false
    self.layer = LAYER_BG + 51
    self.x, self.y = player.x, player.y
    self.omiga = 0.5
    self.hscale, self.vscale = 0, 0
    self._a = 150
    self.kill_flag = false
    task.New(self, function()
        local t = 45
        local s, ds = 0, (1/sin(140))/t
        local dx, rate = 140/t
        local d_a = (255 - self._a)/t
        for i = 1, t do
            s = s + ds
            rate = sin(dx*i)
            self.hscale, self.vscale = s*rate, s*rate
            self._a = self._a + d_a
            task.Wait(1)
        end
        self.hscale, self.vscale = 1, 1
    end)
end
function boundary2:frame()
    task.Do(self)
    self.x, self.y = player.x, player.y
end
function boundary2:render()
    SetImageState(boundary_imgs[3], "", Color(self._a, 255, 255, 255))
    Render(boundary_imgs[3], self.x, self.y, self.rot, self.hscale, self.vscale)
end
function boundary2:kill()
    if not self.kill_flag then
        PreserveObject(self)
        self.kill_flag = true
        task.New(self, function()
            alphaAndSizeChange(self, -255, 2, 60)
            self.status = 'del'
        end)
    end
end
function boundary2:del()
    boundary2.kill(self)
end

--展开hyper结界
local hyperBoundary = Class(object)
function hyperBoundary:init()
    self.boundary = {}
    local hitedCount = system.PowerRank.getHitedCount() --直接开启hyper这个值都是0，只有在切关时，上一关的hyper情况会继承过来，导致这个值有所变化
    self.protect_count = 2 - hitedCount --只允许被弹一次
    self.boundary[1] = New(boundary1)
    self.bound = false
    self.clearBulletRange = {100}
    self.collectRange = {90, 130}
    if hitedCount == 0 then --为0说明上一关没被弹，可以完整得再生成结界
        task.New(self, function()
            task.Wait(45)
            self.boundary[2] = New(boundary2)
        end)
    end
    hyperBoundary.changeCollectRange(self) --会根据被弹次数来设置收取道具范围
end
function hyperBoundary:frame()
    task.Do(self)
end
--抵挡一次攻击（碎掉一层结界）
function hyperBoundary:breakOneBoundary()
    local boundary = self.boundary[self.protect_count]
    if IsValid(boundary) then
        Kill(boundary)
    end
    self.protect_count = self.protect_count - 1
    if self.protect_count <= 0 then
        self.status = 'del'
        player.class.recoveredCollectRange(player) --恢复收集道具范围
    else --第一次撞弹会产生小型消弹圈
        New(system.PowerRank.hited_circle, self.clearBulletRange[self.protect_count], 20, 20, 3) --rmax, r, wt, index
        hyperBoundary.changeCollectRange(self) --会根据被弹次数来设置收取道具范围
    end
end
function hyperBoundary:del()
    for _ = 1, self.protect_count do
        hyperBoundary.breakOneBoundary(self)
    end
end
function hyperBoundary:kill()
    hyperBoundary.del(self)
end
function hyperBoundary:changeCollectRange()
    player._collecter:setCollectRange(50, self.collectRange[self.protect_count])
    player._collecter:setCollectChipRange(50, self.collectRange[self.protect_count])
end

equip_classes.hyperBoundary = hyperBoundary

--endregion

-- 导出资源加载函数
equip_classes.loadRes = loadRes

return equip_classes
