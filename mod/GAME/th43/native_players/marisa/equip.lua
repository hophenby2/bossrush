-------------------------------------------
---东方栖霞园-自机-魔理沙装备配置--
-------------------------------------------

local res_path = "res/player/marisa/"
local player_name = "marisa" -- 自机名字
local res_name = "_"..player_name -- 与本自机相关的素材名字（注意前面加一个下划线，是要和同名的boss素材分开）

-- 导入其他包
local sizeChange = EGGlib.ObjectEvent.sizeChange
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local disappear = EGGlib.ObjectEvent.disappearByAlpha


-- 加载自身素材

local equip_names = EISlib.Player.makeResourcesName(res_name) -- 生成资源名
local bomb_magic_img = res_name.."_bomb_magic"
local bomb_huge_imgs = {} --魔炮
for i = 1, 19 do
    bomb_huge_imgs[i] = res_name .. "_bomb_huge" .. i
end
local bomb_effect_imgs = {} --丝带特效
for i = 1, 19 do
    bomb_effect_imgs[i] = res_name .. "_bomb_effect" .. i
end
local boundary_imgs = {} --结界圈
for i = 1, 3 do
    boundary_imgs[i] = res_name .. "_boundary" .. i
end
local laser_head = res_name .. "_laser_head"
local hyper_laser_img = res_name .. "_laser3" -- hyper激光纹理
local hyper_laser_source_img = res_name .. "_laser3_point"
local hyper_main_bullet_img = res_name .. "_hyper_main_bullet"
local hyper_sup_bullet_ani = res_name.."_hyper_sup_bullet_ani"
local hyper_sup_bullet_eff_ani = res_name.."_hyper_sup_bullet_eff_ani"
local hyper_sup_shoot_eff_imgs = {}
for i = 1, 2 do
    hyper_sup_shoot_eff_imgs[i] = res_name.."_hyper_shoot_eff"..i
end

local main_size = 1 --主枪贴图缩放比例
local high_sup_size = 1 --散枪贴图缩放比例
local laser_size = 1 --激光贴图宽度缩放比例
local hyper_main_size = 1.75 --hyper模式主枪贴图缩放比例
local hyper_laser_size = 1.75 --hyper模式激光贴图缩放比例
--获取素材名
local main_bullet_img = equip_names[1][1]
local spread_bullet_img = equip_names[4][1]
--local hyper_main_bullet_img = equip_names[1][1] --hyper主枪贴图
local sup_img = equip_names[2][2] --子机
local hyper_sup_img = equip_names[3][2]
local main_bullet_img_ef = equip_names[1][2]
local laser_img = equip_names[5][1] --激光纹理
local laser_source_img = equip_names[5][2] --激光发射源
local laser_hit_eff_img = equip_names[5][3] --激光击中特效

local function loadRes()
    lstg.Print("开始加载自机'" .. player_name .. "'的资源")
    
    -- 基础资源
    EISlib.Player.loadRes(res_name, res_path)
    
    -- 爆hyper的主枪子弹
    LoadImageFromFile(hyper_main_bullet_img, res_path .. "hyper_main_bullet.png")
    
    --激光头
    LoadImageFromFile(laser_head, res_path .. "laser_head.png")
    --hyper 子机射击特效
    do
        local shoot_eff_tex = res_name.."_hyper_shoot_eff"
        LoadTexture(shoot_eff_tex, res_path .. 'hyper_shoot_eff.png')
        for i = 1, 2 do
            LoadImage(hyper_sup_shoot_eff_imgs[i], shoot_eff_tex, 128*(i - 1), 0, 128, 128)
        end
    end
    -- hyperMode大号激光
    LoadTexture(hyper_laser_img, res_path .. 'laser3.png')
    -- hyperMode大号激光源
    LoadAniFromFile(hyper_laser_source_img, res_path .. 'pointer.png',
            false, 5, 2, 4)
    -- hyper子机激光射弹素材
    LoadAniFromFile(hyper_sup_bullet_ani, res_path.."hyper_sup_bullet2.png",
            true, 1, 3, 4)
    -- hyper子机激光射弹爆炸效果
    LoadAniFromFile(hyper_sup_bullet_eff_ani, res_path.."hyper_sup_bullet_eff2.png",
            true, 4, 2, 4)

    LoadImageFromFile(bomb_magic_img, res_path.."magic.png")

    -- 魔炮
    for i = 1, 19 do
        LoadImageFromFile(bomb_huge_imgs[i], res_path.."bomb2/"..(i-1)..".png")
    end
    -- 丝带特效
    for i = 1, 19 do
        LoadImageFromFile(bomb_effect_imgs[i], res_path.."bomb3/"..(i-1)..".png")
    end
    
    -- 结界圈
    for i = 1, 3 do
        LoadImageFromFile(boundary_imgs[i], res_path.."boundary"..i..".png")
    end
    
    SetImageState(sup_img, "", Color(255, 255, 255, 255))
    SetImageState(laser_hit_eff_img, "mul+add", Color(255, 255, 255, 255))
    
    lstg.Print("加载自机'" .. player_name .. "'的资源完成")
end

-- 自机攻击

local E = EISlib.Player.Equipment
local isInLaser = EGGlib.ObjectEvent.isInLaser
local scale = EISlib.Player.scale

--激光击中特效

local size = {}
for i = 1, 20 do
    size[i] = 1 - i/20
end

local laser_hit_effect = Class(object)
function laser_hit_effect:init(x, y)
    self.layer = LAYER_PLAYER_BULLET + 1
    self.x, self.y = x, y
    self.hscale, self.vscale = 1, 1
    self.rot = ran:Float(0, 360)
    self.omiga = ran:Float(6, 8)*ran:Sign()
    EGGlib.ObjectEvent.addV1(self, ran:Float(4, 6), self.rot)
end
function laser_hit_effect:frame()
    if self.timer >= 1 and self.timer <= 20 then
        self.hscale, self.vscale = size[self.timer], size[self.timer]
    else
        self.status = "del"
    end
end
function laser_hit_effect:render()
    Render(laser_hit_eff_img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local hyper_laser_hit_effect = Class(object)
function hyper_laser_hit_effect:init(x, y, a)
    self.layer = LAYER_PLAYER_BULLET + 1
    self.x, self.y = x, y
    self.hscale, self.vscale = 1, 1
    self.rot = a
    --self.omiga = ran:Float(6, 8)*ran:Sign()
    EGGlib.ObjectEvent.addV1(self, ran:Float(2, 3), self.rot)
end
function hyper_laser_hit_effect:frame()
    if self.timer >= 31 then
        self.status = "del"
    end
end
function hyper_laser_hit_effect:render()
    SetAnimationState(hyper_sup_bullet_eff_ani, "", Color(215, 255, 255, 255))
    RenderAnimation(hyper_sup_bullet_eff_ani, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--创建一个装备配置

local laser_wide = {64, 80, 96, 128} --激光长度

local function create_equip(rank)
    --贯通激光伤害敌人
    local function laserDamageEnemy(self, target, i, x, y)
        --命中后产生粒子效果
        if self.laser_hit_eff_timer[i] == 0 then
            lstg.New(EISlib.Player.Equipment.straight_bullet_ef, main_bullet_img_ef, x, y, 90, 1.5, "mul+add", 0, 0)
            self.laser_hit_eff_timer[i] = self.laser_hit_eff_timer[i] + 12
        end
        enemybase.damage(target, self.laser_dmg[1]) --对目标造成伤害
        system.PowerRank.addValue(self.laser_dmg[1]*E.NORMAL_DMGTOVALUE) --涨槽
    end
    --判断一个对象可否被激光穿透
    local function canPenetration(o)
        if not o.type and o.class.base ~= boss.class then --不是中大型敌人也不是boss
            if o._master and IsValid(o._master) and o._master.type then --去找主人
                return false
            end
            return true
        else
            return false
        end
    end
    local unPenEnemyTable = {}
    local canPenEnemyTable = {}
    --每帧都要更新一次，可否被穿透对象表
    local function updatePenTable()
        unPenEnemyTable = {}
        canPenEnemyTable = {}
        for _, o in ObjList(GROUP_ENEMY) do
            if canPenetration(o) then --可穿透
                table.insert(canPenEnemyTable, o)
            else --不可被穿透，
                table.insert(unPenEnemyTable, o)
            end
        end
        for _, o in ObjList(GROUP_NONTJT) do
            if canPenetration(o) then --可穿透
                table.insert(canPenEnemyTable, o)
            else --不可被穿透，
                table.insert(unPenEnemyTable, o)
            end
        end
    end
    local function damageEnemies(self, i)
        local x, y, rot, d, len, a = self:getSupPos(i)
        self.laser_hit_eff_timer[i] = max(self.laser_hit_eff_timer[i] - 1, 0)
        self.targets[i] = nil
        local target = nil
        self.maxoffset[i] = min(self.maxlength, self.maxoffset[i] + 60) --更新offset
        self.offset[i] = self.maxoffset[i]
        for _, o in pairs(unPenEnemyTable) do --去找不可被穿透的目标
            if o.colli and isInLaser(x, y, rot, 32, o) then
                d = Dist(o.x, o.y, x, y) - (o.a + o.b) / 2
                if d < self.offset[i] then
                    target = o
                    self.offset[i] = d
                end
            end
        end
        if target then
            --要是有命中敌人就会这样
            self.targets[i] = target
            self.offset[i] = max(0, self.offset[i] + 0.5*(target.a + target.b)/2) --将激光缩到该目标身上
            self.maxoffset[i] = self.offset[i] --更新最远距离
            len = self.offset[i]
            laserDamageEnemy(self, target, i, x + len*cos(rot), y + len*sin(rot))
        end
        for _, o in pairs(canPenEnemyTable) do --再找可被穿透的目标并与现在长度比对，判定
            if o.colli and isInLaser(x, y, rot, 32, o) then
                a, d = Angle(x, y, o.x, o.y), Dist(o.x, o.y, x, y) - (o.a + o.b) / 2
                if d < self.offset[i] then
                    d = d + 0.5*(o.a + o.b) / 2
                    laserDamageEnemy(self, o, i, x + d*cos(a), y + d*sin(a))
                end
            end
        end
    end
    local interval = E.INTERVAL[rank + 1]
    local dmg_rate = E.DMGRATE[rank + 1]
    local number = E.NUMBER[rank + 1]
    local wide = laser_wide[rank + 1]
    local high_main_dmg = 0.75*dmg_rate --高速主枪伤害
    local high_sup_dmg = 0.4*dmg_rate --高速副枪伤害
    local slow_main_dmg = 0.75*dmg_rate --低速主枪伤害
    local slow_sup_dmg = 2.5*dmg_rate --低速副枪伤害
    local equip_class = E.create_complete_shoot_equip(
            interval,  --默认攻击间隔(f
    --初始化(下面这个self是装备类对象，不是自机类对象！）
            function(self)
                self.laser_rate = 0 --控制激光粗细比率(0为关，1为激光完整展开)
                self.targets = {nil, nil, nil, nil} --四根激光的碰撞目标
                self.offset = {0, 0, 0, 0} --激光被截断时的长度
                self.maxoffset = {0, 0, 0, 0} --不考虑被阻挡激光应该延伸到的长度
                self.laser_hit_eff_timer = {0, 0, 0, 0} --激光击中特效计时器
                self.maxlength = 600 --激光最大所能达到的长度
                self.laser_dmg = { --激光伤害（由player.slow的值作为索引决定高低速伤害
                    high_sup_dmg,--高速每根激光每帧初始伤害
                    slow_sup_dmg}--低速每根激光每帧初始伤害
                self.laser_value = { --激光击中后每帧涨槽值
                    2*6/interval*(int(rank/3) + 1), --高速
                    2*6/interval*(int(rank/3) + 1) --低速
                }
            end,
    --高速子机排布
            {
                {-72, -10, 90},
                {-40, 10, 90},
                { 42, 10, 90},
                { 72, -10, 90}
            },
    --低速子机排布
            {
                {-36, 30, 90},
                {-12, 40, 90},
                { 12, 40, 90},
                { 36, 30, 90}
            },
    --高速射击函数(下面这个self是装备类对象，不是自机类对象！） dps = 100 或 140 （取决于激光击中条数）
            function(self)
                local player = self.player
                local rot
                --主炮射击 dps = 0.6*2*5*60/6 = 60
                for i = -3, 3, 2 do
                    for u = -number, number, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x + 12*i + 2.5*u, player.y - 15 - 5*abs(i),
                                20, --velocity
                                90, --angle
                                high_main_dmg,--dmg
                                main_size, --scale
                                "mul+add", --blend
                                150,  --_a
                                10, --value
                                24, --colli_a
                                20 --colli_b
                        )
                    end
                end
            end ,
    --低速射击函数 dps = 105
            function(self)
                local player = self.player
                --主炮射击 dps = 0.6*2*5*60/6 = 60
                for i = -3, 3, 2 do
                    for u = -number, number, 2 do
                        New(E.straight_bullet, main_bullet_img, player.x + 12*i + 2.5*u, player.y - 15 - 5*abs(i),
                                20, --velocity
                                90, --angle
                                slow_main_dmg,--dmg
                                main_size, --scale
                                "mul+add", --blend
                                150,  --_a
                                10, --value
                                24, --colli_a
                                20 --colli_b
                        )
                    end
                end
                --副枪射击
                local x, y, rot
                for i = 1, 4 do
                    x, y, rot = self:getSupPos(i)
                    for u = 0, 0, 2 do
                        New(E.straight_bullet, spread_bullet_img, x, y,
                                17, --velocity
                                rot + 2.5*u, --angle
                                slow_sup_dmg,--dmg
                                high_sup_size, --scale
                                "mul+add", --blend
                                150,  --_a
                                12, --value
                                24, --colli_a
                                20 --colli_b
                        )
                    end
                end
                --副枪射击 是激光，写在帧逻辑里
            end ,
    --帧逻辑
            function(self)
                updatePenTable() --更新一下穿透表
                local player = self.player
                if EISlib.Player.Equipment.canLaser(self, player) and player.slow == 0 then
                    self.laser_rate = min(self.laser_rate + 0.1, 1)
                    for i = 1, 4 do --1-4子机攻击
                        damageEnemies(self, i)
                    end
                else
                    self.laser_rate = max(self.laser_rate - 0.1, 0)
                    if self.laser_rate <= 0 then
                        for i = 1, 4 do
                            self.maxoffset[i] = 0 --重置offset
                            self.offset[i] = self.maxoffset[i]
                        end
                    end
                end
            end,
    --子机与激光渲染
            function(self)
                local x, y, rot, len, s
                local timer = self.player.timer
                --子机渲染
                for i = 1, 4 do
                    x, y = self:getSupPos(i)
                    Render(sup_img, x, y, 22.5 - timer, 1.35*scale)
                end
                --激光渲染
                if self.laser_rate > 0 then
                    for i = 1, 4 do
                        x, y, rot = self:getSupPos(i)
                        len = self.offset[i]
                        if self.targets[i] and IsValid(self.targets[i]) then
                            --若有打中目标则变红
                            EGGlib.RenderEffect.CreateLaser(laser_img, x, y, rot, 18*timer, len, laser_size * wide * self.laser_rate, 512, 128, "mul+add", Color(200, 255, 100, 100))
                        else
                            local co = EISlib.Player.Equipment.BULLET_COLOR[system.PowerRank.getRank() + 1]
                            EGGlib.RenderEffect.CreateLaser(laser_img, x, y, rot, 18*timer, len, laser_size * wide * self.laser_rate, 512, 128, "mul+add", Color(200, co[1], co[2], co[3]))
                        end
                        SetImageState(laser_source_img, "mul+add", Color(200, 255, 255, 255))
                        Render(laser_source_img, x, y, timer*6, self.laser_rate * 0.75 * scale)
                        SetImageState(laser_head, "mul+add", Color(200, 255, 255, 255))
                        s = self.laser_rate * scale * (1.25 + 0.1*sin(60*timer))
                        Render(laser_head, x + len*cos(rot), y + len*sin(rot), 0, s, s)
                    end
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

--小激光（只是视觉效果）

local hyper_laser_bullet = Class(object)
function hyper_laser_bullet:init(x, y)
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER_BULLET
    self.x, self.y = x, y
    self.x0, self.y0 = x - player.x, y - player.y
    self.img = hyper_sup_bullet_ani
    self.rot = 90
    self.vy = 20
    self.bound = false
    self.hscale = scale
    self.vscale = 2*scale
    self.rect = true
    robject.set_color(self, "", 255, 255, 255, 255)
end
function hyper_laser_bullet:frame()
    if self.timer <= 5 then
        self.hscale = self.timer*0.2*scale
    elseif self.timer > 45 then
        self.bound = true
    end
end
function hyper_laser_bullet:kill()

end
function hyper_laser_bullet:render()
    SetAnimationState(self.img, "", Color(self._a, 255, 255, 255))
    RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, 1.25*self.vscale)
    SetAnimationState(self.img, "", Color(0.75*self._a, 255, 255, 255))
    RenderAnimation(self.img, self.timer, self.x, self.y - 40, self.rot, 2*self.hscale, 1.25*self.vscale)
end
function hyper_laser_bullet:del()
    --straight_bullet:kill()
end

-- hypermode装备定义

local function create_hyper_equip()
    local wide = 64
    local sup_laser_dmg = 0.5 --副枪激光伤害
    local main_laser_dmg = 0.75 --主枪激光伤害
    local spread_laser_value = 4  --扩散的激光每帧涨槽
    local focus_laser_value = 8 --集中的激光每帧涨槽
    --贯通激光伤害敌人
    local function laserDamageEnemy1(self, target, i, x, y, dmg)
        --命中后产生粒子效果
        if self.laser_hit_eff_timer[i] == 0 then
            lstg.New(hyper_laser_hit_effect, x, y, 90)
            self.resetNextLaserEffectTimer(i)
            PlaySound("damage00")
        end
        enemybase.damage(target, dmg) --对目标造成伤害
        system.PowerRank.addValue(dmg*E.HYPER_DMGTOVALUE) --涨槽
    end
    --高低速配置一样
    local function shoot(self)
        local player = self.player
        for i = -3, 3, 2 do
            New(E.straight_bullet, hyper_main_bullet_img, player.x + 12*i, player.y - 15 - 5*abs(i),
                    20, --velocity
                    90, --angle
                    1.25,--dmg
                    hyper_main_size, --scale
                    "mul+add", --blend
                    150,  --_a
                    10, --value
                    24, --colli_a
                    20, --colli_b
                    main_bullet_img.."_ef" --kill_eff_ani
            )
        end
    end

    local equip_class = E.create_complete_shoot_equip(
            6,  --默认攻击间隔(f
    --初始化(下面这个self是装备类对象，不是自机类对象！）
            function(self)
                self.stop_shoot_timer = 30 --停止射击计数器
                self.laser_rate = 0 --控制激光粗细比率(0为关，1为激光完整展开)
                self.targets = {nil, nil, nil, nil, nil, nil, nil} --七根激光的碰撞目标
                self.hyper_target = nil --与大激光的碰撞目标
                self.offset = {0, 0, 0, 0, 0, 0, 0} --激光被截断时的长度
                self.maxoffset = {0, 0, 0, 0, 0, 0, 0} --不考虑被阻挡激光应该延伸到的长度

                self.shoot_eff_timer = {0, 0, 0, 0, 0, 0} --激光开火特效计时器
                self.laser_hit_eff_timer = {0, 0, 0, 0, 0, 0, 0} --激光击中特效计时器
                self.next_laser_timer = {4, 4, 4, 4, 4, 4} --下一条激光贴图发射计数器
                self.maxlength = 600 --激光最大所能达到的长度
                self.laser_dmg = { --激光伤害（分别是扩散与集中
                    sup_laser_dmg, --贯通的每根激光每帧初始伤害
                    main_laser_dmg} --大的每根激光每帧初始伤害
                self.laser_value = { --激光击中后每帧涨槽值
                    spread_laser_value, --扩散
                    focus_laser_value --集中
                }
                self.startLaserTimer = function()
                    local index = {1, 4, 5, 6, 2, 3}
                    for i = 1, 6 do
                        self.next_laser_timer[index[i]] = 6*i
                        self.laser_hit_eff_timer[index[i]] = 3*i
                    end
                end
                self.resetNextLaserTimer = function(i)
                    if i == 1 or i == 4 then
                        self.next_laser_timer[i] = 23
                    elseif i == 5 or i == 6 then
                        self.next_laser_timer[i] = 20
                    elseif i == 2 or i == 3 then
                        self.next_laser_timer[i] = 17
                    end
                end

                self.resetNextLaserEffectTimer = function(i)
                    if i == 1 or i == 4 then
                        self.laser_hit_eff_timer[i] = 23
                    elseif i == 5 or i == 6 then
                        self.laser_hit_eff_timer[i] = 20
                    elseif i == 2 or i == 3 then
                        self.laser_hit_eff_timer[i] = 17
                    elseif i == 7 then
                        self.laser_hit_eff_timer[i] = 12
                    end
                end

                self:setSound("hyper2", 0)
            end,
    --高速子机排布
            {
                {-96, -10, 110},
                {-32, 50, 95},
                { 32, 50, 85},
                { 96, -10, 70},
                {-64, 10, 90},
                { 64, 10, 90}
            },
    --低速子机排布
            {
                {-57, -10, 80},
                {-38, 10, 87},
                { 38, 10, 93},
                { 57, -10, 100},
                {-19, 50, 90},
                { 19, 50, 90}
            },
    --高速射击函数(下面这个self是装备类对象，不是自机类对象！） dps =
            shoot,
    --低速射击函数 dps =
            shoot,
    --帧逻辑
            function(self)
                local player = self.player
                if EISlib.Player.Equipment.canLaser(self, player) then
                    local x, y
                    --激光贴图发射处理
                    if self.stop_shoot_timer == 30 then
                        self.startLaserTimer()
                        self.stop_shoot_timer = 0 --清零
                    end
                    self.stop_shoot_timer = self.stop_shoot_timer - 1
                    for i = 1, 6 do
                        if self.next_laser_timer[i] <= 0 then
                            x, y = self:getSupPos(i)
                            self.shoot_eff_timer[i] = 9
                            New(hyper_laser_bullet, x, y)
                            self.resetNextLaserTimer(i)
                        else
                            self.next_laser_timer[i] = self.next_laser_timer[i] - 1
                        end
                    end

                    self.laser_rate = min(self.laser_rate + 0.1, 1)
                    local rot, x, y, d, target, rots
                    --todo 激光音效缺失
                    --[[if player.timer % 12 == 0 then
                        PlaySound('lazer02', 0.025)
                    end]]

                    rot = 90
                    for i = 1, 6 do
                        x, y = self:getSupPos(i) --右侧中间
                        self.shoot_eff_timer[i] = max(self.shoot_eff_timer[i] - 1, 0)
                        self.laser_hit_eff_timer[i] = max(self.laser_hit_eff_timer[i] - 1, 0)
                        self.maxoffset[i] = min(self.maxlength, self.maxoffset[i] + 60) --更新offset
                        self.offset[i] = self.maxoffset[i]
                        for _, o in ObjList(GROUP_ENEMY) do
                            if o.colli and isInLaser(x, y, rot, 32, o) then
                                laserDamageEnemy1(self, o, i, x, o.y - o.b, sup_laser_dmg)
                            end
                        end
                        for _, o in ObjList(GROUP_NONTJT) do
                            if o.colli and isInLaser(x, y, rot, 32, o) then
                                laserDamageEnemy1(self, o, i, x, o.y - o.b, sup_laser_dmg)
                            end
                        end
                    end

                    --[[for i = 7, 7, 1 do --7号位攻击
                        x, y = player.x, player.y
                        self.laser_hit_eff_timer[i] = max(self.laser_hit_eff_timer[i] - 1, 0)
                        self.targets[i] = nil
                        target = nil
                        self.maxoffset[i] = min(self.maxlength, self.maxoffset[i] + 60) --更新offset
                        self.offset[i] = self.maxoffset[i]
                        for _, o in ObjList(GROUP_ENEMY) do
                            if o.colli and isInLaser(x, y, rot, 32, o) then
                                laserDamageEnemy1(self, o, i, x, o.y - o.b, main_laser_dmg)
                            end
                        end
                        for _, o in ObjList(GROUP_NONTJT) do
                            if o.colli and isInLaser(x, y, rot, 32, o) then
                                laserDamageEnemy1(self, o, i, x, o.y - o.b, main_laser_dmg)
                            end
                        end
                    end]]
                else
                    self.laser_rate = max(self.laser_rate - 0.1, 0)
                    if self.laser_rate <= 0 then
                        for i = 1, 4 do
                            self.maxoffset[i] = 0 --重置offset
                            self.offset[i] = self.maxoffset[i]
                        end
                    end
                    --停止射击计数器开始增加
                    self.stop_shoot_timer = min(30, self.stop_shoot_timer + 1)
                end
            end,
    --子机与激光渲染
            function(self)
                local x, y, rot
                local player = self.player
                --子机渲染
                local timer = self.player.timer
                if EISlib.Player.Equipment.canLaser(self, player) then
                    for i = 1, 6 do
                        x, y, rot = self:getSupPos(i)
                        Render(hyper_sup_img, x, y, 22.5 - timer, 0.9*scale)
                        if self.shoot_eff_timer[i] > 0 then
                            local t = math.floor(timer/4)%2 + 1
                            Render(hyper_sup_shoot_eff_imgs[t], x, y + 40, 90, 2*scale, 2*scale*self.laser_rate)
                        end
                    end
                else
                    for i = 1, 6 do
                        x, y, rot = self:getSupPos(i)
                        Render(hyper_sup_img, x, y, 22.5 - timer, 0.9*scale)
                    end
                end

                --激光渲染
                --[[if self.laser_rate > 0 then
                    x, y, rot = player.x, player.y, 90
                    if self.targets[5] and IsValid(self.targets[5]) then
                        --若有打中目标则变红
                        EGGlib.RenderEffect.CreateLaser(hyper_laser_img, x, y + 5, rot, 18*timer, self.offset[5], hyper_laser_size * wide * self.laser_rate, 512, 128, "mul+add", Color(200, 255, 100, 100))
                    else
                        EGGlib.RenderEffect.CreateLaser(hyper_laser_img, x, y + 5, rot, 18*timer, self.offset[5], hyper_laser_size * wide * self.laser_rate, 512, 128, "mul+add", Color(200, 255, 255, 255))
                    end
                    SetAnimationState(hyper_laser_source_img, "mul+add", Color(200, 255, 255, 255))
                    RenderAnimation(hyper_laser_source_img, timer, x, y + 23, 0, 1.5*scale, 1.5*scale)
                end]]
            end)
    --导出
    return equip_class
end

table.insert(equip_classes, create_hyper_equip()) --四级hyper

--region bomb定义

local master_spark = Class(object)
function master_spark:init()
    self.dmg = 3.37
    self.bound = false
    self.x, self.y = player.x, player.y + 330
    self.group = GROUP_SPELL
    self.layer = LAYER_ENEMY + 1
    self.huge_size = 0.1
    self.magic_size = 1
    self.a, self.b = 30, 300
    self.colli = false
    robject.set_color(self, "mul+add", 0, 255, 255, 255)
    task.New(self, function()
        effect.shakeScreen(20, 3)
        local d_a, ds = 255/20, -0.75/20
        for _ = 1, 20 do
            self._a = self._a + d_a
            self.magic_size = self.magic_size + ds
            task.Wait(1)
        end
        self.colli = true
        effect.shakeScreen(20, 6)
        local d_size, dcolli = 0.9/30, 100/30
        for _ = 1, 30 do
            self.huge_size = self.huge_size + d_size
            self.a = math.max(0, self.a + dcolli)
            task.Wait(1)
        end
        PlaySound("spark")
        effect.shakeScreen(310, 4)
        task.Wait(310) --轰他六秒
        effect.shakeScreen(30, 2)
        d_a, d_size, dcolli = -255/30, -1/30, -130/30
        for _ = 1, 30 do
            self.a = math.max(0, self.a + dcolli)
            self._a = self._a + d_a
            self.huge_size = self.huge_size + d_size
            task.Wait(1)
        end
        Del(self)
    end)
end
function master_spark:frame()
    self.x, self.y = player.x, player.y + 330
    task.Do(self)
    if self.timer%10 == 0 then
        EISlib.Bullet.Laser.cutLasersByCircle(self.x, self.y, self.b, false)
    end
end
function master_spark:render()
    local i = math.floor(self.timer/2)
    --local img = bomb_magic_imgs[i%20 + 1]
    --SetImageState(img, "mul+add", Color(self._a, 255, 255, 255))
    --Render(img, self.x, self.y - 220, 0, 1.4, 1.4*self.magic_size)
    --Render(img, self.x, self.y - 290, 0, 0.8, 0.8*self.magic_size)
    local img = bomb_huge_imgs[i%19 + 1]
    SetImageState(img, "mul+add", Color(self._a, 255, 255, 255))
    Render(img, self.x, self.y - 120, 0, 1.15*self.huge_size, 1.15)
    img = bomb_effect_imgs[i%19 + 1]
    SetImageState(img, "", Color(self._a, 255, 255, 255))
    Render(img, self.x, self.y - 120, 0, 1.15, 1.15)
end
function master_spark:colli(o)
    if o.group == GROUP_ENEMY_BULLET then
        Del(o)
    elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
        enemybase.damage(o, self.dmg)
    end
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
        for _ = 1, 45 do
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
        effect.shakeScreen(360, 20)
        New(magic)
        New(master_spark)
        self.lockshoot = 360 --禁射击
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
    self.omiga = 0.5
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

--展开hyper结界
local hyperBoundary = Class(object)
function hyperBoundary:init()
    self.boundary = {}
    local hitedCount = system.PowerRank.getHitedCount() --直接开启hyper这个值都是0，只有在切关时，上一关的hyper情况会继承过来，导致这个值有所变化
    self.protect_count = 2 - hitedCount --只允许被弹一次
    self.boundary[1] = New(boundary1)
    self.bound = false
    self.clearBulletRange = {110}
    self.collectRange = {100, 140}
    if hitedCount == 0 then
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

-- 导出资源加载函数
equip_classes.loadRes = loadRes

return equip_classes
