-------------------------------------------
---东方栖霞园-自机-灵梦装备配置--
-------------------------------------------

local res_path = "res/player/reimu/" -- 资源路径
local player_name = "reimu" -- 自机名字
local res_name = "_" .. player_name -- 与本自机相关的素材名字（注意前面加一个下划线，是要和同名的boss素材分开）
local ran = lstg.Rand()

--导入其他包
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local newSimpleClass = EGGlib.Class.newSimpleClass
local Basic_movement = EGGlib.Class.Frequently.Basic_movement
local Multi_ObjectEvent_Core = EGGlib.Class.Frequently.Multi_ObjectEvent_Core
local TrackEvent = EGGlib.Class.Frequently.TrackEvent
local tranRot = EGGlib.Math.TranRot
local setV = EGGlib.ObjectEvent.setV
local clearBulletAndLaserInRange = EGGlib.ObjectEvent.clearBulletAndLaserInRange
local clearBulletInRange = EGGlib.ObjectEvent.clearBulletInRange
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local defaultRenderAni = EGGlib.RenderEffect.defaultRenderAni
local sizeChange = EGGlib.ObjectEvent.sizeChange
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local disappear = EGGlib.ObjectEvent.disappearByAlpha
local BreakEffect = EGGlib.RenderEffect.BreakEffect
local addV1 = EGGlib.ObjectEvent.addV1
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local getRank = system.PowerRank.getRank

-- 加载自身素材

local equip_names = EISlib.Player.makeResourcesName(res_name, res_path) -- 生成资源名
local trail_tex1 = res_name .. "_trail_tex1"
local trail_tex2 = res_name .. "_trail_tex2"
local trail_img1 = res_name .. "_trail_img1"
local trail_img2 = res_name .. "_trail_img2"
local trail_ani1 = res_name .. "_trail_ani1"
local trail_ani2 = res_name .. "_trail_ani2"
local trail_eff1 = res_name .. "_trail_eff1"
local trail_eff2 = res_name .. "_trail_eff2"
local bomb_ball_img = res_name .. "_bomb_ball"
local bomb_square_imgs = {}
for i = 1, 4 do
    bomb_square_imgs[i] = res_name .. "_bomb_square" .. i
end
--region 新bomb
local bomb_magic_img = res_name.."_bomb_magic"
local bomb_line_red = res_name.."bomb_line_red"
local bomb_line_green = res_name.."bomb_line_green"
local bomb_line_blue = res_name.."bomb_line_blue"
local bomb_boom_red_ani = res_name.."bomb_boom_red"
local bomb_boom_green_ani = res_name.."bomb_boom_green"
local bomb_boom_blue_ani = res_name.."bomb_boom_blue"
local bomb_head_red_img = res_name.."bomb_head_red"
local bomb_head_green_img = res_name.."bomb_head_green"
local bomb_head_blue_img = res_name.."bomb_head_blue"
--endregion

local boundary_imgs = {}
for i = 1, 4 do
    boundary_imgs[i] = res_name .. "_boundary" .. i
end

local main_bullet_img = equip_names[1][1]
local sup_img = equip_names[2][2]
local hyper_sup_img = equip_names[3][2]
local straight_bullet_img = equip_names[2][1]
local trail_bullet_img = trail_img1

local function loadRes()
    lstg.Print("开始加载自机'" .. player_name .. "'的资源")
    
    -- 加载基本资源
    EISlib.Player.loadRes(res_name, res_path)
    
    -- 自机雷
    LoadTexture(res_name .. "_bomb1", res_path .. "bomb1.png")
    LoadImage(bomb_ball_img, res_name .. "_bomb1",
            0, 0, 200, 200)
    for i = 1, 4 do
        LoadImage(bomb_square_imgs[i], res_name .. "_bomb1",
                64 * ((i - 1) % 3),
                200 + math.floor(i / 4) * 64,
                64, 64)
    end

    --三色激光
    do
        local path = res_path.."bomb/"
        local img_list = {bomb_line_red, bomb_line_green, bomb_line_blue}
        local file_list = {path.."red_line.png", path.."green_line.png", path.."blue_line.png"}
        for i = 1, #img_list do
            LoadTexture(img_list[i], file_list[i])
            Add_bentlaser_texture(img_list[i], img_list[i])
        end

        --命中后的爆炸效果
        local boom_tex = res_name.."boom_tex"
        LoadTexture(boom_tex, path.."boom.png")
        LoadAnimation(bomb_boom_red_ani, boom_tex, 0, 0, 256, 256, 7, 2, 2)
        LoadAnimation(bomb_boom_blue_ani, boom_tex, 0, 512, 256, 256, 7, 2, 2)
        LoadAnimation(bomb_boom_green_ani, boom_tex, 0, 1024, 256, 256, 7, 2, 2)

        --头
        local head_tex = res_name.."bomb_head"
        LoadTexture(head_tex, path.."head.png")
        LoadImage(bomb_head_red_img, head_tex, 0, 0, 64, 64)
        LoadImage(bomb_head_green_img, head_tex, 64, 0, 64, 64)
        LoadImage(bomb_head_blue_img, head_tex, 128, 0, 64, 64)

        LoadImageFromFile(bomb_magic_img, res_path.."magic.png")
    end
    
    --两个诱导弹幕素材加载
    
    --normal
    LoadTexture(trail_tex1, res_path .. "trail1.png")
    LoadImage(trail_img1, trail_tex1, 0, 0, 128, 128)
    LoadAnimation(trail_ani1, trail_tex1, 0, 0, 128, 128, 4, 2, 4)
    LoadTexture(trail_eff1, res_path .. "trail_eff1.png")
    Add_bentlaser_texture(trail_eff1, trail_eff1)
    
    --hyper
    LoadTexture(trail_tex2, res_path .. "trail2.png")
    LoadImage(trail_img2, trail_tex2, 0, 0, 128, 128)
    LoadAnimation(trail_ani2, trail_tex2, 0, 0, 128, 128, 4, 2, 4)
    SetAnimationState(trail_ani2, "mul+add", Color(100, 255, 255, 255))
    LoadTexture(trail_eff2, res_path .. "trail_eff2.png")
    Add_bentlaser_texture(trail_eff2, trail_eff2)
    
    SetImageState(trail_bullet_img, "", Color(150, 255, 255, 255))
    
    --结界圈
    for i = 1, 4 do
        LoadImageFromFile(boundary_imgs[i], res_path .. "boundary" .. i .. ".png")
    end
    
    lstg.Print("加载自机'" .. player_name .. "'的资源完成")
end

-- 自机攻击

local E = EISlib.Player.Equipment
local scale = EISlib.Player.scale
local BULLET_SIZE = E.BULLET_SIZE

local hyper_trial_hit_effect = Class(object)
function hyper_trial_hit_effect:init(x, y, a)
    self.layer = LAYER_PLAYER_BULLET - 1
    self.x, self.y = x, y
    self.hscale, self.vscale = BULLET_SIZE[getRank() + 1], BULLET_SIZE[getRank() + 1]
    self.rot = a
    --self.omiga = ran:Float(6, 8)*ran:Sign()
    addV1(self, ran:Float(2, 3), self.rot)
end
function hyper_trial_hit_effect:frame()
    if self.timer >= 23 then
        self.status = "del"
    end
end
function hyper_trial_hit_effect:render()
    RenderAnimation(trail_ani2, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local trial_hit_effect = Class(object)
function trial_hit_effect:init(x, y, a)
    self.layer = LAYER_PLAYER_BULLET - 1
    self.x, self.y = x, y
    self.hscale, self.vscale = BULLET_SIZE[getRank() + 1], BULLET_SIZE[getRank() + 1]
    self.rot = a
    addV1(self, ran:Float(2, 3), self.rot)
    local co = E.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, "mul+add", 100, co[1], co[2], co[3])
end
function trial_hit_effect:frame()
    if self.timer >= 23 then
        self.status = "del"
    end
end
function trial_hit_effect:render()
    SetAnimationState(trail_ani1, "mul+add", Color(self._a, self._r, self._g, self._b))
    RenderAnimation(trail_ani1, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local trail_laser_eff = Class(laser_bent)
function trail_laser_eff:init(mst, rot)
    laser_bent.init(self, 1, mst.x, mst.y, 12, 10*BULLET_SIZE[getRank() + 1], trail_eff1, 0)
    self.layer = LAYER_PLAYER_BULLET - 1
    self.rot = rot
    self.alpha = 0.5
    self.group = GROUP_GHOST -- 特效用曲线激光
    self.colli = false -- 特效用曲线激光
    self.bound = false
    self.mst = mst
    self.release = false
    local co = E.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, "mul+add", 255, co[1], co[2], co[3])
end
function trail_laser_eff:frame()
    if not self.release then
        if IsValid(self.mst) then
            self.x, self.y = self.mst.x, self.mst.y
        else
            self.vx, self.vy = self.dx, self.dy
            self.release = true
        end
    elseif self.alpha > 0 then
        self.alpha = max(0, self.alpha - 0.025)
    else
        self.status = "del"
    end

    if self.timer > 60 then
        self.bound = true
    end
    laser_bent.frame(self)
end

local hyper_trail_laser_eff = Class(laser_bent)
function hyper_trail_laser_eff:init(mst, rot)
    if IsValid(mst) then
        laser_bent.init(self, 1, mst.x, mst.y, 12, 12, trail_eff2, 0)
        self.layer = LAYER_PLAYER_BULLET - 1
        self.rot = rot
        self.alpha = 0.5
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.colli = false -- 特效用曲线激光
        self.bound = false
        self.mst = mst
        self.release = false
    else
        self.status = "del"
    end
end
function hyper_trail_laser_eff:frame()
    if not self.release then
        if IsValid(self.mst) then
            self.x, self.y = self.mst.x, self.mst.y
        else
            self.vx, self.vy = self.dx, self.dy
            self.release = true
        end
    elseif self.alpha > 0 then
        self.alpha = max(0, self.alpha - 0.025)
    else
        self.status = "del"
    end

    if self.timer > 60 then
        self.bound = true
    end
    laser_bent.frame(self)
end

local maxRange = 900 --最大判断范围（不包含）
local function findtarget(self)
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
    --it(GROUP_NONTJT)
    --it(GROUP_ENEMY)
    return target
end

local trail_bullet = Class(object)
function trail_bullet:init(x, y, v, rot, dmg, value)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.bound = false
    self.img = trail_img1
    self.x = x
    self.y = y
    self.rot = rot
    self.v = v
    self.target = findtarget(self) --索敌
    self.dmg = dmg
    self.a = 24
    self.b = 12
    self.rate = 0
    self.rect = true
    self.hscale = scale*BULLET_SIZE[getRank() + 1]
    self.vscale = self.hscale
    self.value = value or 10
    local co = E.BULLET_COLOR[getRank() + 1]
    robject.set_color(self, "", 200, co[1], co[2], co[3])
    --robject.set_color(self, "", 150, 255, 255, 255)
    New(trail_laser_eff, self, rot)
end
function trail_bullet:frame()
    if self.timer > 60 then
        self.bound = true
    end
    local w = lstg.world
    --处于不出屏自删flag或者本身在屏幕内时，执行索敌逻辑，否则直接直线飞出去
    if not self.bound or BoxCheck(self, -192, 192, -224, 224) then
        self.rate = min(1, self.rate + 0.005)
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
end
function trail_bullet:render()
    SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function trail_bullet:kill()
    lstg.New(trial_hit_effect, self.x, self.y, self.rot)
end
function trail_bullet:del()
    trail_bullet.kill(self)
end

local hyper_trail_bullet = Class(trail_bullet)
function hyper_trail_bullet:init(x, y, v, rot, dmg, value)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.bound = false
    self.img = trail_img2
    self.x = x
    self.y = y
    self.rot = rot
    self.v = v
    self.target = findtarget(self) --索敌
    self.dmg = dmg
    self.a = 24
    self.b = 12
    self.rate = 0
    self.rect = true
    self.hscale = 1.25*scale
    self.vscale = self.hscale
    self.value = value or 10
    robject.set_color(self, "", 200, 255, 255, 255)
    New(hyper_trail_laser_eff, self, rot)
end
function hyper_trail_bullet:kill()
    lstg.New(hyper_trial_hit_effect, self.x, self.y, self.rot)
end
function hyper_trail_bullet:del()
    hyper_trail_bullet.kill(self)
end

--创建一个装备配置
local function create_equip(rank)
    local interval = E.INTERVAL[rank + 1]
    local dmg_rate = E.DMGRATE[rank + 1]
    local number = E.NUMBER[rank + 1]
    local high_main_dmg = 1.5*dmg_rate --高速主枪伤害
    local high_sup_dmg = 1.25*dmg_rate --高速副枪伤害
    local slow_main_dmg = 1.25*dmg_rate --低速主枪伤害
    local slow_sup_dmg = 1.5*dmg_rate --低速副枪伤害
    --创建一个装备配置
    local equip_class = E.create_normal_shoot_equip(
            interval,  --默认攻击间隔(f
    --高速子机排布
            {
                {-40, 0, 112},
                {-20, 30, 100},
                { 20, 30, 80},
                { 40, 0, 68}
            },
    --低速子机排布
            {
                {-30, 0, 90},
                {-15, 30, 90},
                { 15, 30, 90},
                { 30, 0, 90}
            },
    --高速射击函数(下面这个self是装备类对象，不是自机类对象！） dps = 105
            function(self)
                local player = self.player
                --主炮射击 dps = 2*3*60/6 = 60
                for i = -1.5, 1.5 do
                    for u = -number, number, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x, player.y,
                                20, --velocity
                                90 + 4*i + 3*u, --angle
                                high_main_dmg,--dmg
                                1.5, --scale
                                "mul+add", --blend
                                125, --_a
                                15, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
                --副枪射击 dps = 1.125*4*60/6 = 45
                local t = math.floor((self.player.timer%18)/6)
                local x, y, rot, u
                for i = 1, 4 do --子机射击
                    u = sign(i - 2.5)
                    x, y, rot = self:getSupPos(i)
                    New(trail_bullet, x, y,
                            9, --velocity
                            rot + 6*t*u, --angle
                            high_sup_dmg, --dmg
                            20 --value
                    )
                end
            end ,
    --低速射击函数 dps = 105
            function(self)
                local player = self.player
                --主炮射击
                for i = -2.5, 2.5 do
                    for u = -number, number, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x, player.y,
                                20, --velocity
                                90 + 4*i + 1.5*u, --angle
                                slow_main_dmg,--dmg
                                1.5, --scale
                                "mul+add", --blend
                                125,  --_a
                                10, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
                --副枪射击
                local x, y, rot
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    for u = -number, number, 2 do
                        New(E.straight_bullet2, straight_bullet_img, x + 5*sin(rot)*u, y + 5*cos(rot),
                                20, --velocity
                                rot, --angle
                                slow_sup_dmg, --dmg
                                1.5, --scale
                                "mul+add", --blend
                                125, --_a
                                20, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
            end ,
    --单子机渲染
            function(self)
                local timer, x, y = self.player.timer
                for i = 1, 4 do
                    x, y = self:getSupPos(i)
                    Render(sup_img, x, y, -timer*3, 1.2*scale)
                end
            end)
    --导出
    return equip_class
end

--自机装备组
local equip_classes = {}
--创建0-3级rank对应的装备
for rank = 0, 3 do
    table.insert(equip_classes, create_equip(rank))
end

--hypermode装备定义
local function create_hyper_equip()
    local high_main_dmg = 1.5 --高速主枪伤害
    local slow_main_dmg = 1.25 --低速主枪伤害
    local straight_dmg = 1.25 --直线子弹伤害
    local trail_dmg = 2.25 --诱导子弹伤害
    local angle_list = {2, 6, 10, 14} --主枪一侧子弹与90度的偏差

    --创建一个装备配置
    local equip_class = E.create_normal_shoot_equip(
            6,  --默认攻击间隔(f
    --高速子机排布
            {
                {-60, 0, 112},
                {-30, 40, 100},
                { 30, 40, 80},
                { 60, 0, 68}
            },
    --低速子机排布
            {
                {-36, 0, 90},
                {-24, 30, 90},
                { 24, 30, 90},
                { 36, 0, 90}
            },
    --高速射击函数
            function(self)
                local player = self.player
                --主炮射击
                for i = 1, 3 do
                    for u = -1, 1, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x, player.y,
                                20, --velocity
                                90 + angle_list[i]*u, --angle
                                high_main_dmg,--dmg
                                1.5, --scale
                                "mul+add", --blend
                                120, --_a
                                10, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
                --诱导射击  dps = 1.125*4*60/6 = 45
                local t = math.floor((self.player.timer%18)/6)
                local x, y, rot, u
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    u = sign(i - 2.5)
                    New(hyper_trail_bullet, x, y,
                            9, --velocity
                            rot + 6*u*t, --angle
                            trail_dmg, --dmg
                            20 --value
                    )
                end
            end,
    --低速射击函数
            function(self)
                local player = self.player
                --主炮射击
                for i = 1, 4 do
                    for u = -1, 1, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x, player.y,
                                20, --velocity
                                90 + angle_list[i]*u, --angle
                                slow_main_dmg,--dmg
                                1.5, --scale
                                "mul+add", --blend
                                120, --_a
                                10, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
                local x, y, rot
                --直线射击
                for i = 1, 4 do --子机射击
                    x, y, rot = self:getSupPos(i)
                    for u = -1, 1, 2 do
                        New(E.straight_bullet2, straight_bullet_img, x + 12*u + 12*sign(2.5-i), y,
                                20, --velocity
                                90, --angle
                                straight_dmg, --dmg
                                1.5, --scale
                                "mul+add", --blend
                                120, --_a
                                10, --value
                                24, --colli_a
                                12 --colli_b
                        )
                    end
                end
            end,
    --单子机渲染
            function(self)
                local timer, x, y = self.player.timer
                for i = 1, 4 do
                    x, y = self:getSupPos(i)
                    Render(hyper_sup_img, x, y, -timer*3, 0.8*scale)
                end
            end,
    --音效名称
            "hyper1",
    --音效间隔
            0
    )
    --导出
    return equip_class
end
table.insert(equip_classes, create_hyper_equip()) --hyper装备

--region 新bomb定义
local bomb_head = Class(object)
local bomb_boom = Class(object)
local BombController = newSimpleClass()
local SpiritBomb = newSimpleClass()
local Missile = newSimpleClass()
local Target = newSimpleClass()

--一次bomb的控制器
do
    local this = BombController
    this.current_inst = nil
    function this.constructor(self)
        self.SpiritBomb_list = {} --包含的元气弹
        self.target_list = {} --被选为目标的敌人的表
        this.current_inst = self --标记当前对象
    end
    --创建一个新的元气弹
    function this.createNewSpiritBomb(self, x, y)
        local obj = SpiritBomb.new(x, y)
        table.insert(self.SpiritBomb_list, obj)
        return obj
    end
    --添加一个新的目标
    function this.addTarget(self, enemy_inst)
        table.insert(self.target_list, Target.new(enemy_inst))
    end
    function this.update(self)
        --整理目标敌人表
        self:updateTargetList()
        task.Do(self)
        --对每个元气弹单位进行更新
        for k, spiritBomb in pairs(self.SpiritBomb_list) do
            if spiritBomb:isValid() then
                spiritBomb:update() --元气弹更新模块在这里
            else --失效的对象会被直接回收，不再更新
                spiritBomb:destroy()
                table.remove(self.SpiritBomb_list, k)
            end
        end
    end
    function this.isValid(self)
        return (#self.SpiritBomb_list > 0)
    end
    function this.getTargetList(self)
        return self.target_list
    end
    --整理目标表，更新有效目标，清理无效的目标
    function this.updateTargetList(self)
        --先清理一次无效目标
        for k, target in pairs(self.target_list) do
            if not target:isValid() then
                table.remove(self.target_list, k)
            end
        end

        --创建一个工具表，深度拷贝target_list
        local cur_list = {}
        for k, target in pairs(self.target_list) do
            cur_list[k] = target
        end
        --对于敌人组的每一个对象，先判断在不在这个表里，如果在，则移除工具表此项记录，减小下次遍历的规模，如果不在则加入
        for _, enemy in ObjList(GROUP_NONTJT) do
            local flag = false
            for k, target in pairs(cur_list) do
                if enemy == target:getEnemyInst() then
                    flag = true
                    table.remove(cur_list, k)
                    break
                end
            end
            if not flag then --检查了一遍，这个敌人都不在，需要加入表中
                self:addTarget(enemy)
            end
        end
    end
    --创建一次bomb事件的重要函数
    function this.createBombEvent()
        --移动事件
        local function moveEvent(spiritBomb, a)
            setV(spiritBomb, 15, a)
            spiritBomb.ay = -spiritBomb.vy/30
            spiritBomb.ax = -spiritBomb.vx/30
            task.New(spiritBomb, function()
                task.Wait(30)
                spiritBomb:Release()
                spiritBomb.ay = 0
                spiritBomb.ax = 0
            end)
        end
        tasker(function()
            local bombController = this.new() --产生一个bomb控制器
            task.New(bombController, function()
                local wait_list = {15, 45, 15, 45, 0}
                for j = 1, 4 do
                    if j % 2 == 1 then
                        PlaySound("bomb")
                    end
                    for i = -2.5, 2.5 do
                        local spiritBomb = bombController:createNewSpiritBomb(player.x, player.y) --生成新的元气弹
                        moveEvent(spiritBomb, -90 + 30*i*tranU(j))
                    end
                    task.Wait(wait_list[j])
                end
                PlaySound("enep04")
                --New(BreakEffect, player.x, player.y,  'tree_leaf_white', 'Cherry_eff', 255, 100, 100, "mul+add")
                for i = -5.5, 5.5 do
                    local spiritBomb = bombController:createNewSpiritBomb(player.x, player.y) --生成新的元气弹
                    moveEvent(spiritBomb, -90 + 30*i)
                end
            end)
            local timer = 0

            bombController:update()
            task.Wait(1)
            timer = timer + 1
            while bombController:isValid() do
                bombController:update()
                task.Wait(1)
                timer = timer + 1
            end
            --SystemLog("本次bomb管理器用时："..timer)
        end)
    end
end
--元气弹
do
    local this = SpiritBomb
    this.COLOR_LIST = {COLOR_RED, COLOR_GREEN, COLOR_BLUE}
    function this.constructor(self, x, y)
        Basic_movement.implement(self, x, y)
        self.rot = 0
        --导弹处理模块
        self.missile_list = {}
        for i = 1, 3 do
            table.insert(self.missile_list, Missile.new(this.COLOR_LIST[i], 120*i))
        end
    end
    function this.update(self)
        task.Do(self)
        Basic_movement.update(self)
        self.rot = Angle(0, 0, self.vx, self.vy)
        --对每个导弹单位进行更新
        for k, missile in pairs(self.missile_list) do
            if missile:isValid() then
                if not missile:isRelease() then --没被释放就老老实实跟着走吧
                    local x, y = missile.x, missile.y
                    missile.x, missile.y = self.x, self.y
                    missile.dx, missile.dy = missile.x - x, missile.y - y
                elseif not missile:hasTarget(self) then --被释放了则查看target情况，如果没有target则重新指派一个
                    missile:findTarget()
                end
                missile.rot = self.rot
                missile:update() --导弹更新模块在这里
            else --失效的missile对象会被直接回收，不再更新
                missile:destroy()
                table.remove(self.missile_list, k)
            end
        end
    end
    function this.Release(self)
        --释放所有包含的导弹
        for _, missile in pairs(self.missile_list) do
            missile:Release()
        end
    end
    function this.destroy(self)
        --先销毁自己管理的导弹实例
        for _, missile in pairs(self.missile_list) do
            missile:destroy(self)
        end
    end
    function this.isValid(self)
        return (#self.missile_list > 0)
    end
end
--单发导弹
do
    local this = Missile
    this.img_list = {}
    this.img_list[COLOR_RED] = bomb_line_red
    this.img_list[COLOR_GREEN] = bomb_line_green
    this.img_list[COLOR_BLUE] = bomb_line_blue
    this.dphase = 20
    this.SIN_list = {}
    for i = 0, 360/this.dphase do
        this.SIN_list[i] = sin(i*this.dphase)
    end
    this.amplitude = 10 --振幅
    function this.constructor(self, color, phase)
        Basic_movement.implement(self, 0, 0)
        Multi_ObjectEvent_Core.implement(self) --多对象事件核心
        self.rot = Angle(0, 0, self.vx, self.vy)
        self.head = New(bomb_head, self.x, self.y, color)
        self.body = New(bent_laser_effection, this.img_list[color], self.x, self.y, self.rot, 15, 12) --tex, x, y, rot, len, wide
        robject.set_color(self.body, "mul+add", 255, 255, 255, 255)
        self.body.bound = false
        self.release = false --被释放出去的标记
        self.phase = phase
        self.target = nil
        self.dx, self.dy = 0, 0 --记录本帧与上一帧的坐标变化量
        --计时器
        self.timer = 0

        self.acc = 0
        self.dacc = 0.02
    end
    function this.update(self)
        if self.timer == 120 then
            self.head.bound = true
            self.body.bound = true
        else
            self.timer = self.timer + 1
        end
        if self:isRelease() then --已经被释放出去的话，就更新自己的运动逻辑
            local x, y = self.x, self.y
            --更新跟踪逻辑
            if not self.track_event:isValidTarget() then
                if not self:hasTarget() then
                    self:findTarget()
                end
                --就算进行查找一遍也是非常有可能没有目标的
                if self:hasTarget() then
                    self.track_event:setTarget(self:getTarget():getEnemyInst())
                end
            end
            self.acc = self.acc + self.dacc
            self.track_event:setAcceleration(min(self.acc, 0.25)) --加速度增加
            self.track_event:addTight(0.05) --跟踪紧密度增加
            task.Do(self)
            Multi_ObjectEvent_Core.update(self) --多对象事件更新
            Basic_movement.update(self)
            self.dx, self.dy = self.x - x, self.y - y
            --更新朝向
            self.rot = Angle(0, 0, self.dx, self.dy)
            --子成员运动逻辑
            self.head.x, self.head.y = self.x, self.y
            self.body.x, self.body.y = self.x, self.y
            clearBulletInRange(self.x, self.y, 30, true)
            if self.timer%10 == 0 then --每10帧检测一次激光消除
                EISlib.Bullet.Laser.cutLasersByCircle(self.x, self.y, 30, false)
            end --截断激光
            --碰撞处理
            if self:hasTarget() then
                local obj = self:getTarget():getEnemyInst()
                if Dist(self.x, self.y, obj.x, obj.y) < 20 then
                    PlaySound("explode")
                    self:getTarget():takeDamage() --执行一次受击
                    self:destroy()
                end
            else
                self.bound = true
            end
            --bomb持续时间到了就自动消除机制
            if not player_class.isInBomb(player) then
                PlaySound("explode")
                self:destroy()
            end
        else --没被释放出去就让子成员正弦运动
            self.phase = self.phase + this.dphase
            local dx, dy = tranRot(0, this.amplitude*self:getSinPhase(), self.rot) --没释放出去时self.rot由元气弹主人更新
            --子成员运动逻辑
            local x, y = self.head.x, self.head.y
            self.head.x, self.head.y = self.x + dx, self.y + dy
            self.body.x, self.body.y = self.x + dx, self.y + dy
            self.dx, self.dy = self.head.x - x, self.head.y - y
        end
    end
    function this.isRelease(self)
        return self.release
    end
    function this.Release(self)
        self.release = true
        self.x, self.y = self.head.x, self.head.y --移动模式切换
        self.vx, self.vy = self.dx, self.dy
        self.body.x, self.body.y = self.x, self.y
        self.track_event = TrackEvent.new(self, self.target, Dist(0, 0, self.dx, self.dy), 0) --mst, target, v, tight
        self.track_event:setAcceleration(0)
        Multi_ObjectEvent_Core.addObjectEvent(self, self.track_event) --加入追踪事件
    end
    function this.getSinPhase(self)
        return this.SIN_list[math.floor((self.phase%360)/this.dphase)]
    end
    function this.isValid(self)
        return (IsValid(self.head) and IsValid(self.body))
    end
    function this.destroy(self)
        if IsValid(self.head) then
            _del(self.head, true)
        end
        if IsValid(self.body) then
            _del(self.body, true)
        end
    end
    function this.hasTarget(self)
        if self.target and self.target:isValid() then
            return true
        end
        return false
    end
    function this.getTarget(self)
        return self.target
    end
    function this.setTarget(self, target)
        self.target = target
    end
    function this.findTarget(self)
        local bomb_controller = BombController.current_inst
        --访问敌机表
        local min_d = 999
        local target_key = nil
        local target_list = bomb_controller:getTargetList()
        for k, target in pairs(target_list) do
            if target:canLocked() then
                local obj = target:getEnemyInst()
                local d = Dist(self.x, self.y, obj.x, obj.y)
                if obj.colli and d < min_d and not obj.protect then
                    min_d = d
                    target_key = k
                end
            end
        end

        if not target_key then --还是没找到的话，那就挑选个最远的倒霉蛋吧
            for k, target in pairs(target_list) do
                local obj = target:getEnemyInst()
                if IsValid(obj) then
                    local d = Dist(self.x, self.y, obj.x, obj.y)
                    if obj.colli and d < min_d  and not obj.protect then
                        min_d = d
                        target_key = k
                    end
                end
            end
        end

        --如果表是空的，那怎么找也找不到的，所以判断还是有必要的
        if target_key then
            self.track_event:setTight(min(0.25, self.track_event:getTight()))
            --对这个target做锁定
            local target = target_list[target_key]
            self:setTarget(target)
            target:beLockedEvent() --触发一次被锁定的事件
        end
    end
end

--本例专用的target对象
do
    local this = Target
    this.dmgToSmallEnemy = 999 --对小型敌人的伤害
    this.dmgToBigEnemy = 50 --对中大型敌人的伤害
    this.dmgToBoss = 6.94 --对boss伤害
    function this.constructor(self, enemy_inst)
        self.enemy_inst = enemy_inst
        --设置最大锁定数
        if enemy_inst == _boss then
            self.max_locked_count = _infinite
        elseif not enemy_inst.type then --小型机
            self.max_locked_count = 1
        else --中大型机
            self.max_locked_count = math.ceil(enemy_inst.hp/this.dmgToBigEnemy)
        end
        --已锁定数初始化
        self.locked_count = 0
    end
    function this.getEnemyInst(self)
        return self.enemy_inst
    end
    function this.isValid(self)
        return IsValid(self.enemy_inst)
    end
    --由子弹打中enemy时调用一次
    function this.takeDamage(self)
        local enemy_inst = self:getEnemyInst()
        --if enemy_inst.class.take_damage then
            local dmg
            if enemy_inst == _boss then
                dmg = this.dmgToBoss
            elseif not enemy_inst.type then --小型机
                dmg = this.dmgToSmallEnemy
            else --中大型机
                dmg = this.dmgToBigEnemy
            end
            --enemy_inst.class.take_damage(enemy_inst, dmg)
        enemybase.damage(enemy_inst, dmg)
            --_del(enemy_inst, true)
        --end
        self.max_locked_count = self.max_locked_count - 1
        self.locked_count = self.locked_count - 1
    end
    --被锁定一次
    function this.addLockedCount(self)
        self.locked_count = self.locked_count + 1
    end
    --外面调用，被锁定一次的事件
    function this.beLockedEvent(self)
        self:addLockedCount()
    end
    --判断能不能再被作为lock目标
    function this.canLocked(self)
        --SystemLog(string.format("self.locked_count %d < self.max_locked_count %d", self.locked_count, self.max_locked_count))
        return (self:isValid() and self.locked_count < self.max_locked_count)
    end
end


--lstg对象，bomb激光头
bomb_head.img_list = {
    [COLOR_RED] = bomb_head_red_img,
    [COLOR_BLUE] = bomb_head_blue_img,
    [COLOR_GREEN] = bomb_head_green_img
}
function bomb_head:init(x, y, co)
    self.x, self.y = x, y
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    self.hscale, self.vscale = 2, 2
    self.group = GROUP_GHOST
    self.bound = false
    self.img = bomb_head.img_list[co]
    self.co = co
end
function bomb_head:frame()
    task.Do(self)
end
function bomb_head:render()
    defaultRenderImg(self)
end
function bomb_head:del()
    effect.shakeScreen(10, 10)
    New(bomb_boom, self.x, self.y, self.co)
    clearBulletAndLaserInRange(self.x, self.y, 50, 0, true)
end
function bomb_head:kill()
    bomb_head.del(self)
end

--lstg对象，bomb爆炸特效
bomb_boom.ani_list = {
    [COLOR_RED] = bomb_boom_red_ani,
    [COLOR_BLUE] = bomb_boom_blue_ani,
    [COLOR_GREEN] = bomb_boom_green_ani
}
function bomb_boom:init(x, y, co)
    self.x, self.y = x, y
    self.rot = ran:Float(0, 360)
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    self.hscale, self.vscale = 1, 1
    self.group = GROUP_GHOST
    self.img = bomb_boom.ani_list[co]
end
function bomb_boom:frame()
    if self.timer < 27 then
        self.hscale, self.vscale = self.hscale + 0.04, self.vscale + 0.04
    else
        Del(self)
    end
end
function bomb_boom:render()
    defaultRenderAni(self)
end
function bomb_boom:del()

end
function bomb_boom:kill()

end

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
    SetImageState(bomb_magic_img, "", Color(self._a, 255, 255, 255))
    Render(bomb_magic_img, self.x, self.y, self.rot, self.hscale, self.vscale)
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
    SetImageState(bomb_magic_img, "", Color(self._a, 255, 255, 255))
    Render(bomb_magic_img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

function equip_classes.spell(self)
    tasker(function()
        New(magic)
        self.lockshoot = max(self.lockshoot, self.nextspell) --禁射击
        effect.shakeScreen(240, 10)
        BombController.createBombEvent()
        for _ = 1, self.lockshoot do
            self.class.changeSpeedWhenBomb(self) --身体灌铅
            task.Wait(1)
        end
        self.class.recoveredSpeed(self)
    end)
end
--endregion

--region 结界圈定义

local boundary1 = Class(object)
function boundary1:init()
    self.bound = false
    self.layer = LAYER_BG + 51
    self.x, self.y = player.x, player.y
    self.omiga = 0.6
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
    SetImageState(boundary_imgs[2], "", Color(self._a, 255, 255, 255))
    Render(boundary_imgs[2], x, y, self.rot, self.hscale, self.vscale)
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
    self.omiga = -0.5
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

local boundary3 = Class(object)
function boundary3:init()
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
function boundary3:frame()
    task.Do(self)
    self.x, self.y = player.x, player.y
end
function boundary3:render()
    SetImageState(boundary_imgs[4], "", Color(self._a, 255, 255, 255))
    Render(boundary_imgs[4], self.x, self.y, self.rot, self.hscale, self.vscale)
end
function boundary3:kill()
    if not self.kill_flag then
        PreserveObject(self)
        self.kill_flag = true
        task.New(self, function()
            alphaAndSizeChange(self, -255, 2, 60)
            self.status = 'del'
        end)
    end
end
function boundary3:del()
    boundary3.kill(self)
end

--展开hyper结界
local hyperBoundary = Class(object)
function hyperBoundary:init()
    self.boundary = {}
    local hitedCount = system.PowerRank.getHitedCount() --直接开启hyper这个值都是0，只有在切关时，上一关的hyper情况会继承过来，导致这个值有所变化
    self.protect_count = 3 - hitedCount
    self.boundary[1] = New(boundary1)
    self.bound = false
    self.clearBulletRange = {85, 100}
    self.collectRange = {90, 110, 130}
    task.New(self, function()
        task.Wait(45)
        if hitedCount <= 1 then
            self.boundary[2] = New(boundary2)
        end
        task.Wait(15)
        if hitedCount == 0 then
            self.boundary[3] = New(boundary3)
        end
    end)
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
    else --前两次撞弹会产生小型消弹圈
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

-- 导入其他函数
equip_classes.loadRes = loadRes

return equip_classes
