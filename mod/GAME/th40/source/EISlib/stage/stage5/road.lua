-----------------------------------------
---东方栖霞园道中 stage5
-----------------------------------------
---@class  EISlib.stage.stage5.road
--现在整个道中也是一个对象
local R = Class(object)
function R:init()
    self.timer = 0
    lstg.tmpvar.current_road = self --当前道中对象是自己
end
function R:frame()
    task.Do(self)
end
--获取当前场景阶段
function R:getSence()
    return self.sence
end

--素材加载
local function loadRes()
    local res_name = "s5_road_"
    local path = "res/stage/stage5/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
end

local path = EISlib.stage.path.."stage5/"
local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_info_t = 9999
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local simPar = EGGlib.ObjectEvent.simPar
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local curve_layerDv1 = EGGlib.BulletGroup.Curve.layerDv1
local curve_layerDv4 = EGGlib.BulletGroup.Curve.layerDv4
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local omigaChangeTask = EGGlib.ObjectEvent.omigaChangeTask
local clearEnemyAndBullet = EGGlib.ObjectEvent.clearEnemyAndBullet
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local tranRot = EGGlib.Math.TranRot
local boundWait = EGGlib.ObjectEvent.boundWait
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local accDecVelchange = EGGlib.ObjectEvent.accDecVelocityChange
local LS = EISlib.Bullet.Laser.laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local clearBulletAndLaserInRangeCircle = EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle
local newSimpleClass = EGGlib.Class.newSimpleClass
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local argbChangeToMax = EGGlib.ObjectEvent.argbChangeToMax
local Basic_movement = EGGlib.Class.Frequently.Basic_movement --基础运动接口

local Big_Dipper_Controller = newSimpleClass()
local Star_unit = newSimpleClass()
local Laser_unit = newSimpleClass()


local E = {} --enemy define
R.E = E
local B = {} --bullet define
R.B = B
local P = {} --pointer define(one point)
R.P = P
local S = {} --shooter define
R.S = S
local T = {} --task define
R.T = T
local O = {} --object define
R.O = O
local D = {} --death define
R.D = D

--每次rank变化时都要update一次
function R.updateByRankChange()
    local diff = difficulty
    local rank = system.PowerRank.getRank()
    for _, v in pairs(P) do
        v.update(diff, rank)
    end
    for _, v in pairs(S) do
        v.update(diff, rank)
    end
    for _, v in pairs(E) do
        v.update(diff, rank)
    end
    for _, v in pairs(O) do
        v.update(diff, rank)
    end
    for _, v in pairs(T) do
        v.update(diff, rank)
    end
    for _, v in pairs(B) do
        v.update(diff, rank)
    end
    for _, v in pairs(D) do
        v.update(diff, rank)
    end
end


--整个北斗七星控制类
do
    local this = Big_Dipper_Controller
    --使用星星单位表直接完成构造
    function this.constructor(self, x, y, star_unit_list)
        Basic_movement.implement(self, x, y) --继承基础运动类接口
        self.star_unit_list = star_unit_list
    end
    function this.update(self)
        task.Do(self)
        Basic_movement.update(self) --执行基础运动类的功能
        local dx, dy
        for _, star_unit in pairs(self.star_unit_list) do
            dx, dy = star_unit:getOffset() --获取偏移量
            star_unit.x, star_unit.y = self.x + dx, self.y + dy --更新一次位置
            star_unit:update()
        end
    end
    function this.createLaser(self, index)
        self.star_unit_list[index]:createLaser()
    end
end


--北斗七星其中一颗星的单位实现
do
    local this = Star_unit
    function this.constructor(self, x, y, enemy, prev_star_unit, next_star_unit)
        self.x, self.y = x, y
        self.offset_x, self.offset_y = x, y --传进来的x, y即离控制类中心偏移量
        self.enemy = enemy
        self.bullet = nil --bullet
        self.laser = nil
        --链式结构
        self.prev = prev_star_unit --上一个实例
        self.next = next_star_unit --下一个实例
        --是否已经释放激光
        self.isRelease = false
    end
    function this.update(self)
        local enemy = self.enemy
        local bullet = self.bullet
        local laser = self.laser
        --三个实体如果都无效，则此帧逻辑几乎等于没做任何事
        if IsValid(enemy) then
            enemy.x, enemy.y = self.x, self.y + 40
        else --如果绑定的敌机被击破或者解除绑定了，就释放两侧的激光并解除星星
            self:releaseLaser()
        end
        if IsValid(bullet) then
            bullet.x, bullet.y = self.x, self.y
        end
        if laser then
            laser:update()
        end
    end
    function this.setPrev(self, prev_star_unit)
        self.prev = prev_star_unit
    end
    function this.setNext(self, next_star_unit)
        self.next = next_star_unit
    end
    function this.getPrev(self)
        return self.prev
    end
    function this.getNext(self)
        return self.next
    end
    function this.getLaser(self)
        return self.laser
    end
    function this.setRelease(self, boolean)
        self.isRelease = boolean
    end
    function this.IsRelease(self)
        return self.isRelease
    end
    function this.createLaser(self)
        self.bullet = B.bullet_star.create(self.x, self.y)
        --必须要有下一个结点才能连线创建激光
        if self:getNext() and not self.laser then
            self.laser = Laser_unit.new(self, self:getNext(), 6) --mst1, mst2, v, n
        end
    end
    function this.releaseLaser(self)
        --只能release一次
        if not self:IsRelease() then
            if self.prev and self.prev:getLaser() then
                self.prev:getLaser():del(1)
            end
            if self:getLaser() then
                self:getLaser():del(2)
            end
        end
        --大星星移除
        local bullet = self.bullet
        if IsValid(bullet) then
            _del(bullet, true)
        end
        --妖精也爆掉
        local enemy = self.enemy
        if IsValid(enemy) then
            clearBulletAndLaserInRangeCircle(enemy.x, enemy.y, 50, 2, 0, 20, true) --最后一个参数如果填true则不起消弹作用
            Kill(enemy)
        end
        self:setRelease(true)
    end
    --获取偏移量
    function this.getOffset(self)
        return self.offset_x, self.offset_y
    end
end

--北斗七星中连线激光实现
do
    local this = Laser_unit
    this.del_v = -5
    function this.constructor(self, mst1, mst2, v)
        self.mst1, self.mst2 = mst1, mst2
        self.x, self.y = mst1.x, mst1.y
        self.v = v
        self.ls_dx, self.ls_dy = 0, 0
        self.ls_vdx, self.ls_vdy = 0, 0
        self.laser = New(lead_laser,
                1, COLOR_PURPLE, --type, co
                self.x, self.y, v, Angle(mst1.x, mst1.y, mst2.x, mst2.y), --x, y, v, a
                Dist(mst1.x, mst1.y, mst2.x, mst2.y), 15, 15, 1, --len, w0, w1, 1
                true, false, _infinite --islock, isshoot, last_time
        )
        LS.setMaxLength(self.laser, 1, 2)
        LS.setMaxLength(self.laser, 2, Dist(mst1.x, mst1.y, mst2.x, mst2.y))
        LS.setMaxLength(self.laser, 3, 2)
        self.laser.bound = false
        self.isDel = false
        self.killing_timer = 0 --被消除的计数器
        self.total_time = math.ceil(abs(LS.getMaxTotalLength(self.laser)/this.del_v)) --被消除的总时间
    end
    function this.update(self)
        local ls = self.laser
        local mst1, mst2  = self.mst1, self.mst2
        self.x, self.y = mst1.x, mst1.y
        self.ls_dx, self.ls_dy = self.ls_dx + self.ls_vdx, self.ls_dy + self.ls_vdy
        --激光实体失效的话，此帧逻辑几乎没做任何事
        if IsValid(ls) then
            local head_len, trail_len = LS.getMaxLength(ls, 1), LS.getMaxLength(ls, 3)
            ls.x, ls.y = self.x + self.ls_dx, self.y + self.ls_dy
            local a, d = Angle(mst1.x, mst1.y, mst2.x, mst2.y), Dist(mst1.x, mst1.y, mst2.x, mst2.y)
            LS.setRot(ls, a)
            LS.setMaxLength(ls, 2, d - head_len - trail_len)
            --删除逻辑
            if self.isDel then
                local len = LS.getTotalLength(ls)
                local dx, dy = LS.getCosSinRot(ls)
                if len <= 0 then
                    _del(ls, true)
                    --影响两侧的其他北斗七星实例
                    mst1:releaseLaser()
                    mst2:releaseLaser()
                end
                --从尾部开始消弹
                if mst1:IsRelease() then
                    local da
                    if mst2:getLaser() and IsValid(mst2:getLaser().laser) then
                        local a0, a1 = LS.getRot(ls), LS.getRot(mst2:getLaser().laser)
                        da = a0 + (a1 - a0)*self.killing_timer/self.total_time
                    else
                        da = LS.getRot(ls) + (- 3*self.killing_timer)
                    end
                    New(BulletBreak, ls.x, ls.y, ls._index)
                    P.laser_kill.attack(ls.x, ls.y, da, self.killing_timer)
                end
                --从头部开始消弹
                if mst2:IsRelease() then
                    local da
                    if mst1:getPrev() and mst1:getPrev():getLaser() and IsValid(mst1:getPrev():getLaser().laser) then
                        local a0, a1 = LS.getRot(ls), LS.getRot(mst1:getPrev():getLaser().laser)
                        da = a0 + (a1 - a0)*self.killing_timer/self.total_time
                    else
                        da = LS.getRot(ls) + (3*self.killing_timer)
                    end
                    New(BulletBreak, ls.x + len*dx, ls.y + len*dy, ls._index)
                    P.laser_kill.attack(ls.x + len*dx, ls.y + len*dy, da, self.killing_timer)
                end
                self.killing_timer = self.killing_timer + 1
            end
        end
    end
    ---@param mst_index number 填1或者2，代表self.mst1或self.mst2
    function this.del(self, mst_index)
        --这么写的意思是只有实例第一次调用该函数有效果
        local ls = self.laser
        if IsValid(ls) then
            local mst
            --支持从两侧同时释放
            if mst_index == 1 then
                mst = self.mst1
                if not mst:IsRelease() then
                    LS.setV(ls, this.del_v)
                    --[[if LS.getV(ls) > 0 then --另一端还没释放
                        LS.setV(ls, -LS.getTotalLength(ls)/this.del_time)
                    else --另一端已经释放了
                        LS.setV(ls, 2*LS.getV(ls))
                    end]]
                end
            elseif mst_index == 2 then
                mst = self.mst2
                if not mst:IsRelease() then
                    self.ls_vdx, self.ls_vdy = LS.getCosSinRot(ls)
                    local v = -this.del_v
                    self.ls_vdx, self.ls_vdy = v*self.ls_vdx, v*self.ls_vdy
                    LS.setV(ls, this.del_v)
                    --[[if LS.getV(ls) > 0 then --另一端还没释放
                        LS.setV(ls, -LS.getTotalLength(ls)/this.del_time)
                    else --另一端已经释放了
                        LS.setV(ls, 2*LS.getV(ls))
                    end]]
                end
            end
        end
        self.isDel = true
    end
end

--The Big Dipper
B.bullet_star = EISlib.Bullet.Shooter.createBulletClass(
        function(diff, rank)
            local function create(x, y)
                local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_DEEP_PURPLE, true)
                setSizeAndColli(obj, 0.1, 0.1)
                obj.hide = true
                boundWait(obj, 900)
                obj.omiga = 6
                --产生激光逻辑
                task.New(obj, function()
                    obj.hide = false
                    spSizeAndColliChangeTask(obj, 0.99, 20, 150)
                end)
                return obj
            end
            return create
        end
)

--第二种小怪的星弹
B.bullet2 = BS.createBulletClass(
        function(diff, rank)
            --case：层数
            local count = switch1(diff, {
                2, 3, 4, 5, 5
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local dv = switch1(diff, {
                0.2, 0.2, 0.2, 0.2, 0.2
            })*defaultSwitchVelocityByRank(rank)
            local wait = 42/count
            local function create(x, y, v, a)
                local obj = stg.newBullet(x, y, stg.star_big, COLOR_PURPLE, false)
                obj.omiga = 3
                SetV(obj, v, a)
                task.New(obj, function()
                    task.Wait(10)
                    PlaySound("kira00")
                    for i = 0, count - 1 do
                        stg.newStrChV(obj.x, obj.y, 0, v + dv*i, a, 60, 30, stg.star_small, COLOR_PURPLE).omiga = 3
                        task.Wait(wait)
                    end
                    _del(obj, true)
                end)
                return obj
            end
            return create
        end
)

--第四种小怪发的分裂弹
B.bullet4 = BS.createBulletClass(
        function(diff, rank)
            local v0 = switch1(diff, {
                2, 2.5, 3, 3.5, 3.5
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_big, COLOR_DEEP_PURPLE
            local function create(x, y, a)
                local obj = stg.newBullet(x, y, style, color, false)
                omigaChangeTask(obj, 0, 6, 60)
                velchTask(obj, 0, v0, a, 30)
                task.New(obj, function()
                    task.Wait(60)
                    PlaySound("kira00")
                    P.pointer4.attack(obj.x, obj.y, a)
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)

--第五种中怪发的分裂弹
B.bullet5 = BS.createBulletClass(
        function(diff, rank)
            --case：层数
            local layer = switch1(diff, {
                1, 2, 3, 4, 4
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0.1, 0.125, 0.15, 0.15
            })*defaultSwitchVelocityByRank(rank)
            local function create(x, y, a)
                local obj = stg.newBullet(x, y, stg.star_big, COLOR_PURPLE, false)
                omigaChangeTask(obj, 6, 2, 30)
                velchTask(obj, v0, 0, a, 90)
                task.New(obj, function()
                    task.Wait(60)
                    PlaySound("kira00")
                    for i = 0, layer - 1 do
                        stg.newStraight(obj.x, obj.y, v0 + dv*i, a, stg.arrow_big, COLOR_PURPLE)
                    end
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)

--第五种中怪发的衍生自机狙弹幕
B.bullet5_1 = BS.createBulletClass(
        function(diff, rank)
            --case：层数
            local count = switch1(diff, {
                2, 3, 4, 5, 5
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local wait = 42/count
            local function create(x, y, v, a)
                local obj = stg.newBullet(x, y, stg.star_big, COLOR_PURPLE, false)
                obj.omiga = 3
                SetV(obj, v, a)
                task.New(obj, function()
                    task.Wait(10)
                    PlaySound("kira00")
                    for _ = 0, count - 1 do
                        B.bullet5_1_1.create(obj.x, obj.y, a)
                        task.Wait(wait)
                    end
                    _del(obj, true)
                end)
                return obj
            end
            return create
        end
)

B.bullet5_1_1 = BS.createBulletClass(
        function(diff, rank)
            --case：层数
            local v = switch1(diff, {
                2, 2.5, 3, 3.5, 3.5
            })*defaultSwitchVelocityByRank(rank)
            local function create(x, y, a)
                local obj = stg.newBullet(x, y, stg.star_small, COLOR_DEEP_PURPLE, false)
                obj.omiga = 3
                task.New(obj, function()
                    obj.layer = LAYER_ENEMY_BULLET - 1
                    velch(obj, 1, 0, a, 40)
                    velch(obj, 0, v, Angle(obj, player), 30)
                end)
                return obj
            end
            return create
        end
)

--region Pointer Defined
--连弹
P.pointer1_1 = BS.createPointer(
        function(diff, rank)
            --case：层数
            local layer = switch1(diff, {
                1, 2, 3, 4, 4
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1, 1, 1, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv0 = switch1(diff, {
                0.5, 0.5, 0.5, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            --case：初始的基础上增加的弹速
            local v1 = switch1(diff, {
                1.5, 1.5, 1.6, 1.8, 1.8
            })*defaultSwitchVelocityByRank(rank)
            local dv1 = switch1(diff, {
                0.325, 0.325, 0.35, 0.4, 0.4
            })*defaultSwitchVelocityByRank(rank)
            --case：弹速差
            local style, color = stg.arrow_big, COLOR_ORANGE
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            local v00, v10
                            for i = 0, layer - 1 do
                                v00 = v0 + dv0*i
                                v10 = v0 + v1 + dv1*(layer - 1 - i) --注意是v0
                                stg.newSimpleStrChV(x, y, v00, v10, a, 60, 0, style, color)
                            end
                        end)
            end
            return attack
        end
)

--扇形弹
P.pointer1_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 5, 7, 9, 9
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = switch1(diff, {
                12, 12, 12, 10, 10
            }) --每way间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_small, COLOR_ORANGE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color).omiga = 3
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_normal1(x, y, v0, a, way, da, --base
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--高速中玉
P.pointer2_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local bunch = switch1(diff, {
                4, 7, 10, 13, 13
            })
            --case：每层弹速差
            local dv = 0.5*defaultSwitchVelocityByRank(rank)
            local da = switch1(diff, {
                90, 90, 90, 90, 90
            })/(bunch - 1) --每way间的间隔
            --case：层数
            local layer = 1
            local da_l = 0
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2, 2, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0, 1, 0.5, 0.5, 0
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_big, COLOR_PURPLE
            local function bullet_func(x, y, v, a)
                B.bullet2.create(x, y, v, a)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for i = 0, layer - 1 do
                                for u = -1, 1, 2 do
                                    curve_layerDv1(x, y, v0 + dv_l*i, a, bunch + i, dv, (da + da_l*i)*u, --x, y, v0, a, bunch, dv, da
                                            1, 0, 0, 0, --layer, dv_l, da_l, d_bunch,
                                            bullet_func
                                    )
                                end
                            end
                        end)
            end
            return attack
        end
)

--散弹
P.pointer2_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local bunch = switch1(diff, {
                2, 2, 3, 3, 3
            })
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0, 0.5, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            local da = switch1(diff, {
                0, 0, 20, 10, 10
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 2, 2, 3, 3
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                3, 3.5, 4, 4.5, 4
            })*defaultSwitchVelocityByRank(rank)
            --case：平稳后的弹速
            local v1 = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0, 0.5, 0.5, 0.5, 0.5
            })
            --case:初始扩散角
            local sp = switch1(diff, {
                20, 18, 16, 15, 15
            })/2
            local style, color = stg.grain_e, COLOR_ORANGE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, v0, v, a, 30, 0, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for u = -1, 1, 2 do
                                curve_layerDv1(x, y, v1, a + sp*u, bunch, dv, da*u, --x, y, v0, a, bunch, dv, da
                                        layer, dv_l, 0, -1, --layer, dv_l, da_l, d_bunch,
                                        bullet_func
                                )
                            end
                        end)
            end
            return attack
        end
)

--三角弹
P.pointer3_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                5, 7, 7, 9, 8
            })
            --case:连弹数
            local bunch = 4 + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：每层弹速差
            local dv_b = switch1(diff, {
                -0.1, -0.1, -0.1, -0.1, -0.1
            })*defaultSwitchVelocityByRank(rank)
            local da = switch1(diff, {
                45, 40, 35, 30, 30
            }) --每way间的间隔
            local sp = switch1(diff, {
                9, 10, 11, 12, 12
            })/2
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            })
            local dv_l = switch1(diff, {
                0, 0, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2, 2.5, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.grain_b, COLOR_GREEN
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for j = 1, layer do
                                local way = (way - j)/2
                                for i = -way, way do
                                    for u = -1, 1, 2 do
                                        curve_layerDv4(x, y, v0 + dv_l*(j - 1), a + da*i, bunch, dv_b, sp*u, --x, y, v0, a, bunch, dv, sp
                                                1, 0, 0, 0, --layer, dv_l, da_l, d_bunch,
                                                bullet_func
                                        )
                                    end
                                end
                            end
                        end)
            end
            return attack
        end
)

--向下连弹
P.pointer3_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 2, 3, 3
            })
            local sp = switch1(diff, {
                0, 0, 20, 25, 25
            }) --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.grain_a, COLOR_PURPLE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer2(x, y, v0, a, way, sp, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--3way
P.pointer4 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 3, 3, 3, 3
            })
            local da = switch1(diff, {
                2, 2, 2, 2, 2
            }) --每way间的间隔
            --case：层数
            local layer = 1 + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2.5, 3, 3.5, 3.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0.13, 0.17, 0.21, 0.25, 0.25
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_small, COLOR_DEEP_GREEN
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color).omiga = 3
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a, way, da, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--扩散弹
P.pointer5 = BS.createPointer(
        function(diff, rank)
            local da = 40
            local style, color = stg.ball_mid_c, COLOR_DEEP_RED
            local function bullet_func(x, y, v, a)
                B.bullet5.create(x, y, a)
            end
            local function attack(x, y, a, way)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, 0, a, way, da, --base
                                    1, 0, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--大扩散弹
P.pointer5_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local bunch = switch1(diff, {
                6, 8, 10, 12, 12
            })
            --case：每层弹速差
            local dv_b = switch1(diff, {
                0.75, 0.75, 0.75, 0.75, 0.75
            })*defaultSwitchVelocityByRank(rank)
            local da = switch1(diff, {
                12, 9, 7.5, 6, 6
            }) --每way间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1, 1, 1, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                1, 1, 1, 1, 1
            })

            local sp0 = switch1(diff, {
                30, 25, 20, 15, 15
            })/2
            local style, color = stg.star_big, COLOR_DEEP_PURPLE
            local function bullet_func(x, y, v, a)
                B.bullet5_1.create(x, y, v, a)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for u = -1, 1, 2 do
                                curve_layerDv1(x, y, v0, a + sp0*u, bunch, dv_b, da*u, --x, y, v0, a, bunch, dv, da
                                        1, dv_l, 0.5*da*u, 0, --layer, dv_l, da_l, d_bunch,
                                        bullet_func
                                )
                            end
                        end)
            end
            return attack
        end
)
--激光边消除边产生的弹幕
P.laser_kill = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                2, 2, 2, 2, 2
            })
            local da = 180 --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 2, 3, 4, 4
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.5, 2.5, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0.5, 0.5, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            --case:隔几帧生成一次
            local n = switch1(diff, {
                5, 4, 3, 3, 3
            })
            local style, color = stg.arrow_big, COLOR_PURPLE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color).omiga = 0
            end
            local function attack(x, y, a, timer)
                if timer%n == 0 then
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v0, a, way, da, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
            end
            return attack
        end
)

--endregion

--region Shooter Defined
S.shooter1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = 300
            --case:攻击次数
            local count = switch1(diff, {
                1, 2, 3, 4, 4
            })
            local wait = 90/count
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                for _ = 0, count - 1 do
                                    P.pointer1_1.attack(e.x, e.y, Angle(e, player))
                                    task.Wait(wait)
                                end
                                P.pointer1_2.attack(e.x, e.y, Angle(e, player))
                                task.Wait(20)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = 100
            --中玉攻击间隔
            local wait1 = switch1(diff, {
                120, 110, 89, 90, 90
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function(obj)
                            --中玉
                            task.New(obj, function()
                                while true do
                                    P.pointer2_1.attack(e.x, e.y, Angle(e, player))
                                    task.Wait(wait1)
                                end
                            end)
                        end
                )
            end
            return shooter
        end
)

S.shooter3 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                360, 360, 360, 360, 360
            })
            local wait = switch1(diff, {
                45, 40, 33, 30, 30
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer3_1.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter3_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local wait = switch1(diff, {
                9, 8, 7, 6, 6
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local u = e.u
                            while true do
                                P.pointer3_2.attack(e.x, e.y, -90 + 15*u)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)


S.shooter4 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                99, 100, 120, 180, 180
            })
            local wait = switch1(diff, {
                100, 60, 50, 40, 40
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                --B.bullet4.create(e.x, e.y, Angle(e, player))
                                P.pointer4.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter5 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local wait = switch1(diff, {
                999, 999, 135, 105, 105
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer5_1.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter5_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local layer = switch1(diff, {
                2, 3, 3, 4, 4
            })
            local count = switch1(diff, {
                1, 1, 2, 2, 2
            })
            local wait = 75/layer
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                task.Wait(30)
                                for i = 0, layer - 1 do
                                    P.pointer5.attack(e.x, e.y, Angle(e, player), i+1)
                                    task.Wait(wait)
                                end
                            end
                        end
                )
            end
            return shooter
        end
)
--endregion

--region Tasker Defined
--出现，减速，再往另一个方向拐
T.move1_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, da)
                task.New(obj, function()
                    velch(obj, 3, 0, a, 45, 45)
                    task.Wait(100)
                    --simPar(obj, 1, a, 0.025, a + da) --o, v, a, acc, acca
                    velch(obj, 0, 2, Angle(obj.x, obj.y, 0, -75), 120)
                end)
            end
            return main
        end
)

T.move1_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, dt)
                task.New(obj, function()
                    velch(obj, 3, 0, a, 20, 30 + dt)
                    accDecVelchange(obj, 1.5, a + 180, 40, 0, 40)
                    task.Wait(150)
                    --simPar(obj, 1, a + 180, 0.025, 90) --o, v, a, acc, acca
                    velch(obj, 0, 2, Angle(obj, player), 120)
                end)
            end
            return main
        end
)

T.move1_3 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 3, 0, a, 45, 45)
                    task.Wait(100)
                    velch(obj, 0, 2, Angle(obj, player), 120)
                end)
            end
            return main
        end
)

--出现，减速，再往另一个方向拐
T.move2_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, da)
                task.New(obj, function()
                    velch(obj, 3, 0.5, a, 30, 30)
                    task.Wait(120)
                    velch(obj, 0, 1.5, a + da, 90)
                end)
            end
            return main
        end
)

--出现，减速，然后起飞
T.move3_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 3, -0.25, a, 60, 90)
                    velch(obj, 0, 1.5, 90, 90)
                end)
            end
            return main
        end
)

--出现，减速，然后起飞
T.move3_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                task.New(obj, function()
                    velch(obj, 2, 0, -90, 90, 90)
                    velch(obj, 0, 1.5, 90, 180)
                end)
            end
            return main
        end
)

--出现，减速，再横向离开
T.move4_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, da)
                task.New(obj, function()
                    velch(obj, 3, 0, a, 45, 45)
                    task.Wait(100)
                    simPar(obj, 1, a, 0.025, a + da) --o, v, a, acc, acca
                end)
            end
            return main
        end
)

T.move4_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, da)
                task.New(obj, function()
                    velch(obj, 3, 0.5, a, 30, 60)
                    task.Wait(180)
                    velch(obj, 0, 1.5, a + da, 90)
                end)
            end
            return main
        end
)

--出现，减速，再往另一个方向拐
T.move5_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, da)
                task.New(obj, function()
                    velch(obj, 2, 0.1, a, 30, 30)
                    task.Wait(120)
                    velch(obj, 0, 1.5, Angle(obj, player), 90)
                end)
            end
            return main
        end
)

--北斗七星缓缓下降
T.move6_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                task.New(obj, function()
                    velch(obj, 3, 0, -90, 90, 60)
                    task.Wait(30)
                    velch(obj, 0, 1.5, -90, 240)
                end)
            end
            return main
        end
)


--北极星小妖精离开
T.move6_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                task.New(obj, function()
                    velch(obj, 0, 2, 90, 90)
                end)
            end
            return main
        end
)

--透明度变化入场
T.alphaChange = BS.createTasker(
        function(diff, rank)
            local function main(obj, t)
                t = t or 150
                obj.colli = false
                robject.set_color(obj, "", 200, 120, 120, 120)
                task.New(obj, function()
                    if t <= 120 then
                        alphaAndSizeChange(obj, 0, 0, t - 30)
                        argbChangeToMax(obj, 30) --t
                        task.Wait(30)
                        obj.colli = true
                    else
                        alphaAndSizeChange(obj, 0, 0, 90)
                        task.Wait(t - 120)
                        argbChangeToMax(obj, 30) --t
                        task.Wait(30)
                    end
                    obj.colli = true
                end)
            end
            return main
        end
)
--endregion

--region Death Defined
--北斗七星大妖精爆炸
D.death6 = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                7, 9, 11, 13, 13
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = 360/way --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 3, 3
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0, 0.5, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_big, COLOR_DEEP_PURPLE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color).omiga = 3
            end
            local function main(e)
                local x, y, a = e.x, e.y, Angle(e, player)
                enemy.createDeath(
                        1, --total_time,
                        function()
                            PlaySound("kira00")
                            stg.newFadeEffect(x, y, style, color, false,
                                    function()
                                        sect_layer1(x, y, v0, a, way, da, --base
                                                layer, dv, 0, --layer, dv_l, da_l
                                                bullet_func
                                        )
                                    end)
                        end)
            end
            return main
        end)
--endregion

--region Enemy Defined
--最普通的自机狙杂鱼
E.enemy1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_6_ORANGE, --style
                        hp or 8, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--常见的中玉自机狙中怪
E.enemy2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        hp or 60, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count,
                        nil, --death_func,
                        true --type
                )
                S.shooter2.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--飞机大怪
E.enemy3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        hp or 300, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count,
                        nil, --death_func,
                        true --type
                )
                enemy.changeAura(obj, COLOR_ORANGE, "middle")
                S.shooter3.main(obj, dt + 60) --给这个小怪装上发射器
                --生成小弟
                for i = 1, 2 do
                    for u = -1, 1, 2 do
                        E.enemy3_1.create(obj, 25*(i-0.5)*u, -30 + 25*(i-1), (60 + 30*(i-1))*u, 0 - 30*(i-1), dt)
                    end
                end
                return obj
            end
            return create
        end
)

--飞机大怪的飞行器
E.enemy3_1 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx0, dy0, dx1, dy1, dt)
                local obj = New(enemy, mst.x + dx0, mst.y + dy0, sty.FIRE_BLUE, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1, 1)
                _connect(mst, obj, 1, true)
                if dx1 < 0 then
                    obj.u = -1
                else
                    obj.u = 1
                end
                local dx, dy = dx0, dy0
                S.shooter3_1.main(obj, dt + 30) --给这个小怪装上发射器
                --展开
                task.New(obj, function()
                    task.Wait(dt)
                    local t = 60
                    local r, dr = 0, 1/t
                    for _ = 1, t do
                        r = r + dr
                        dx, dy = dx0 + r*(dx1 - dx0), dy0 + r*(dy1 - dy0)
                        task.Wait(1)
                    end
                end)
                --跟随
                task.New(obj, function()
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + dx, mst.y + dy
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)

--3way小怪
E.enemy4 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_7_GREEN, --style
                        hp or 8, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter4.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--攻击角度不断增大的中怪
E.enemy5 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_2_RED, --style
                        hp or 80, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY --drop
                )
                S.shooter5.main(obj, dt) --给这个小怪装上发射器
                for u = -1, 1, 2 do
                    E.enemy5_1.create(obj, 30*u, -15, dt)
                end
                return obj
            end
            return create
        end
)

--红鬼火使魔
E.enemy5_1 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx, dy, dt)
                local obj = New(enemy, mst.x + dx, mst.y + dy, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                S.shooter5_1.main(obj, dt)
                setSizeAndColli(obj, 1, 1)
                _connect(mst, obj, 1, true)
                --跟随
                task.New(obj, function()
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + dx, mst.y + dy
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)

--北斗七星大妖精
E.enemy6 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_6_BLUE, --style
                        120, --hp
                        true,  --show_hpbar
                        system.DROP_SMALL_ENEMY, --drop
                        false, --no_count,
                        D.death6.main, --death_func,
                        true --type
                )
                --S.shooter2.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

local createCatClass = lstg.DoFile(path.."mid_cat.lua")
--endregion

--region Object Defined
--endregion

--region 标题定义

local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s5_road_title1"
    self.layer = LAYER_BG + 1
    self.hscale, self.vscale = 0.75, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    --形状，透明度变化
    task.New(self, function()
        for x = 0, 90, 90/30 do
            self.vscale = 0.75*sin(x)
            task.Wait(1)
        end
        task.Wait(180)
        for x = 0, 90, 90/30 do
            self._a = 255*cos(x)
            task.Wait(1)
        end
        Del(self)
    end)
end
function title:frame()
    task.Do(self)
end
function title:render()
    --DefaultRenderFunc(self)
    SetImageState(self.img, "", Color(self._a, 255, 255, 255))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--
white = Class(object)
function white:init(x, y, vy, r, g, b)
    self.x, self.y = x, y
    self.img = "white"
    self.layer = LAYER_BG
    self.vy = vy
    self.hscale, self.vscale = 100, 0
    robject.set_color(self, "", 200, r, g, b)
    task.New(self, function()
        for x = 0, 90, 90/45 do
            self.vscale = 5*sin(x)
            self._a = 200*cos(x)
            task.Wait(1)
        end
        Del(self)
    end)
end
function white:frame()
    task.Do(self)
end
function white:render()
    --DefaultRenderFunc(self)
    SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--title生成函数
local function createTitle(x, y)
    tasker(function()
        New(title, x, y)
        for _ = 1, 5 do
            for u = -1, 1, 2 do
                New(white, x, y - 15*u, 2*u, 255, 0, 255)
            end
            task.Wait(8)
        end
    end)
end

--endregion

function R.INIT(sence)
    system.PowerRank.resumeHyper() --从这里计时
    local self = New(R) --创建自己
    self.sence = sence or 1
    New(stage5_background, self.sence)
    loadRes()
    LoadMusicRecord("s5")
    
    --system.PowerRank.setRankWithEvent(0)
    R.updateByRankChange() --初始化一次
    
    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage5/mid_boss.lua")
local mid_bosses = {}
for diff = 1, 4 do
    mid_bosses[diff] = createMidBoss(diff)
end
local function midBossMain()
    local boss = New(mid_bosses[difficulty])
    while IsValid(boss) do
        task.Wait(1)
    end
end
s5_road.midBoss = midBossMain
function R.FIRST(pratice)
    local self = lstg.tmpvar.current_road
    --300f
    local t = 0
    if IsValid(self) then
        if pratice then
            self.timer = t
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 1
            --
            local ce1, ce2, ce3, ce4, ce5, ce6
            local ce1group, ce2group, ce4group, ce6group
            do
                function ce1(x, y, da, u)
                    local obj = E.enemy1.create(x, y, 60, 10) --x, y, dt, hp
                    T.alphaChange.main(obj, 60)
                    T.move1_1.main(obj, 90*(u+1) + da*u, 0*-90*u)
                end
                function ce1group(n, x, y, u)
                    tasker(function()
                        for i = 0, n - 1 do
                            ce1(x + 15*i*u, y - 15*i, 2*tranU(i), u)
                            task.Wait(10)
                        end
                    end)
                end
                function ce2(x, y, u)
                    local obj = E.enemy2.create(x, y, 10, 60) --x, y, dt, hp
                    T.move2_1.main(obj, -90, -90*u)
                end
                function ce2group(n, x0, xrange, u, wait)
                    x0 = x0 - 0.5*xrange*u
                    local dx = xrange/(n - 1)*u
                    tasker(function()
                        for _ = 0, n - 1 do
                            ce2(x0, 245, u)
                            x0 = x0 + dx
                            task.Wait(wait)
                        end
                    end)
                end
                function ce3(x, y, u)
                    local obj = E.enemy3.create(x, y, 120, 300) --x, y, dt, hp
                    setProtectTime(obj, 150)
                    T.move3_1.main(obj, 90*(1-u))
                end

                function ce4(x, y, da, u)
                    local obj = E.enemy4.create(x, y, 30, 10) --x, y, dt, hp
                    T.move4_1.main(obj, 90*(u+1) + da*u, 0)
                end
                function ce4group(n, x, y, u)
                    tasker(function()
                        for i = 0, n - 1 do
                            ce4(x + 15*i*u, y - 15*i, 2*tranU(i), u)
                            task.Wait(8)
                        end
                    end)
                end
            end

            --道中本体
            do
                EISlib.stage.playMusic("s5", (t - 300) / 60, true) -- 音乐延后5秒放
                task.Wait(60)
                for u = -1, 1, 2 do
                    ce1group(10, 224*u, 100, u) --n, x, y, u
                end
                task.Wait(180)
                for u = -1, 1, 2 do
                    ce1group(10, 224*u, 135, u) --n, x, y, u
                end
                task.Wait(410)
                --这里用来title啥的
                createTitle(0, 100)
                task.Wait(210)
                for u = -1, 1, 2 do
                    ce2group(3, 30*u, 180, u, 45) --n, x0, xrange, u, wait
                    task.Wait(70)
                    ce3(-254*u, 0, u)
                    task.Wait(250)
                end
                task.Wait(60)
                for u = -1, 1, 2 do
                    ce4group(10, 224*u, 120, u) --n, x, y, u
                end
            end
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    local t = 1680
    if IsValid(self) then
        if pratice then
            self.timer = t
            EISlib.stage.playMusic("s5", t / 60, true)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2
            --
            local ce1, ce2, ce3
            local ce1group, ce2group, ce3group
            do
                function ce1(x, y, u)
                    local obj = E.enemy5.create(x, y, 15, 180) --x, y, dt, hp
                    setProtectTime(obj, 30)
                    T.move5_1.main(obj, -90 - 15*u, 150*u)
                end
                function ce1group(n, x0, xrange, u, wait, dy)
                    wait = wait or 0
                    dy = dy or 0
                    tasker(function()
                        x0 = x0 - 0.5*xrange*u
                        local dx = xrange/(n - 1)*u
                        tasker(function()
                            for _ = 0, n - 1 do
                                ce1(x0, 245 + dy, u)
                                x0 = x0 + dx
                                task.Wait(wait)
                            end
                        end)
                    end)
                end

                function ce2(x, y, da, u)
                    local obj = E.enemy4.create(x, y, 30, 10) --x, y, dt, hp
                    T.move4_1.main(obj, 90*(u+1) + da*u, 0)
                end
                function ce2group(n, x, y, u)
                    tasker(function()
                        for i = 0, n - 1 do
                            ce2(x + 15*i*u, y - 15*i, 2*tranU(i), u)
                            task.Wait(10)
                        end
                    end)
                end
                function ce3(x, y, da, u)
                    local obj = E.enemy1.create(x, y, 60, 10) --x, y, dt, hp
                    T.alphaChange.main(obj, 60)
                    T.move1_3.main(obj, -90 - da)
                end
                function ce3group(n, x0, xrange, u)
                    tasker(function()
                        x0 = x0 - 0.5*xrange*u
                        local dx = xrange/(n - 1)*u
                        for i = 0, n - 1 do
                            ce3(x0, 245, (10 + 2*tranU(i))*u, u)
                            x0 = x0 + dx
                            task.Wait(10)
                        end
                    end)
                end
            end

            --道中本体
            do
                for u = -1, 1, 2 do
                    ce1group(2, 40*u, 100, u, 150) --n, x0, xrange, u, wait
                    task.Wait(30)
                    ce3group(8, 30*u, 150, u)
                    task.Wait(100)
                    ce2group(10, 200*u, 120, u) --n, x, y, u
                    task.Wait(190)
                end
                ce3group(12, 30, 200, -1)
                task.Wait(90)
                --第二次bgm循环
                ce2group(12, -200, 120, -1) --n, x, y, u
                task.Wait(30)
                ce1group(2, -30, -100, -1, 0) --n, x0, xrange, u, wait
                task.Wait(60)
                ce3group(12, -30, 200, 1)
                task.Wait(150)
                ce2group(12, 200, 120, 1) --n, x, y, u
                task.Wait(30)
                ce1group(2, 30, -100, 1, 0) --n, x0, xrange, u, wait
                task.Wait(240)
                ce1group(2, -50, -100, 1, 0, 0) --n, x0, xrange, u, wait, dy
                ce1group(2, 50, -100, -1, 0, 0) --n, x0, xrange, u, wait, dy
                task.Wait(120)
                for u = -1, 1, 2 do
                    ce2group(8, 200*u, 120, u) --n, x, y, u
                    ce3group(8, 30*u, 150, u)
                end
                task.Wait(220)
            end
        end
    end
end


function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --3550f
    local t = 3380
    if IsValid(self) then
        if pratice then
            self.timer = t
            EISlib.stage.playMusic("s5", t / 60, true)
        else
            --等到3550f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 3
            --
            local ce1
            do

            end

            --道中本体
            do
                clearEnemyAndBullet()
                createCatClass(difficulty, -224, 144)
                task.Wait(720) --12*60
                local boss = New(mid_bosses[difficulty])
                while IsValid(boss) do
                    task.Wait(1)
                end
            end
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --5240f
    local t = 5200
    if IsValid(self) then
        if pratice then
            self.timer = t
            EISlib.stage.playMusic("s5", t / 60, true)
        else
            --等待到5240f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 4
            --
            local ce1, ce2, ce3
            local ce1group, ce3group
            do
                function ce1(x, y)
                    local obj = E.enemy6.create(x, y, 60)
                    setProtectTime(obj, 120)
                    enemy.setBoundTime(obj, 750)
                    return obj
                end
                function ce1group(x, y, s, u)
                    --北斗七星相对坐标表（以正中间为0, 0)
                    local pos = {
                        {-435*s*u, -48*s}, {-243*s*u, 65*s}, {-95*s*u, 40*s}, {100*s*u, 12*s}, {186*s*u, -144*s}, {443*s*u, -59*s}, {426*s*u, 140*s}
                    }

                    local star_unit_list = {}
                    --创建结点实例，把enemy和star实例作为参数传入结点参与构造
                    local e
                    for i = 1, 7 do
                        e = ce1(x + pos[i][1], y + pos[i][2] + 245)
                        if i ~= 1 and not (i%2 == 0) then --除了1以外的奇数妖精不掉血灵碎片的
                            --enemy.changeDropBlood(e, false)
                            enemy.changeAura(e, COLOR_BLUE, "normal")
                        end
                        table.insert(star_unit_list,
                                Star_unit.new(x + pos[i][1], y + pos[i][2] + 15, --x, y
                                        e --enemy
                                )
                        )
                    end
                    --设置每个结点的前一个结点和后一个结点
                    for k, star_unit in pairs(star_unit_list) do
                        star_unit:setPrev(star_unit_list[k-1])
                        star_unit:setNext(star_unit_list[k+1])
                    end
                    --直接创建北斗七星控制器
                    local obj = Big_Dipper_Controller.new(x, y, star_unit_list)
                    T.move6_1.main(obj)

                    --连接激光
                    task.New(obj, function()
                        task.Wait(90)
                        for index, star_unit in pairs(star_unit_list) do
                            obj:createLaser(index)
                            task.Wait(10)
                        end
                    end)

                    --帧逻辑控制
                    tasker(function()
                        for _ = 1, 750 do
                            obj:update()
                            task.Wait(1)
                        end
                    end)
                end
                function ce3(x, y, da, u)
                    local obj = E.enemy4.create(x, y, 30, 10) --x, y, dt, hp
                    T.move4_1.main(obj, 90*(u+1) + da*u, 0)
                end
                function ce3group(n, x, y, u)
                    tasker(function()
                        for i = 0, n - 1 do
                            ce3(x + 15*i*u, y - 15*i, 2*tranU(i), u)
                            task.Wait(10)
                        end
                    end)
                end
            end

            --道中本体
            do
                for i = 1, 4 do
                    ce3group(10, 224*tranU(i), 150, tranU(i))
                    ce1group(0, 224, 0.425, tranU(i))
                    if i ~= 4 then
                        task.Wait(240)
                    else
                        task.Wait(90)
                    end
                end
            end
        end
    end
end

function R.FIFTH(pratice)
    local self = lstg.tmpvar.current_road
    --6570f
    local t = 6270
    if IsValid(self) then
        if pratice then
            self.timer = t
            EISlib.stage.playMusic("s5", t / 60, true)
        else
            --等待到6570f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 5
            --
            local ce1, ce2, ce3, ce4, ce5
            local ce1group, ce2group
            do
                function ce1(x, y, u, dt)
                    local obj = E.enemy1.create(x, y, 150, 10) --x, y, dt, hp
                    setProtectTime(obj, 30)
                    T.move1_2.main(obj, 90*(1-u), dt)
                    T.alphaChange.main(obj)
                end
                function ce2(x, y, u)
                    local obj = E.enemy4.create(x, y, 150, 10) --x, y, dt, hp
                    setProtectTime(obj, 30)
                    T.move4_2.main(obj, -90, 180)
                    T.alphaChange.main(obj)
                end
                local dt = 10
                function ce1group()
                    tasker(function()
                        for i = 0, 9 do
                            for u = -1, 1, 2 do
                                ce1(-200*u, 180 - 20*i, u, 5*(9-i)) --x, y, u, dt
                            end
                            task.Wait(dt)
                        end
                    end)
                end
                function ce2group()
                    tasker(function()
                        for i = 0, 9 do
                            for u = -1, 1, 2 do
                                ce2((180 - 20*i)*u, 400 - 20*i, u)
                            end
                            task.Wait(dt)
                        end
                    end)
                end
                function ce3(x, y)
                    local obj = E.enemy3.create(x, y, 120, 300) --x, y, dt, hp
                    setProtectTime(obj, 180)
                    T.move3_2.main(obj)
                end

                function ce4(x, y, u)
                    local obj = E.enemy2.create(x, y, 10, 60) --x, y, dt, hp
                    T.move2_1.main(obj, -90, -90*u)
                end
                function ce5(x, y, u)
                    local obj = E.enemy5.create(x, y, 10, 180) --x, y, dt, hp
                    enemy.changeAura(obj, COLOR_ORANGE, "normal")
                    setProtectTime(obj, 150)
                    T.move5_1.main(obj, -90, -90*u)
                end
            end

            --道中本体
            do
                --SystemLog("开始时间:"..self.timer)
                --ce3(0, 245)
                --task.Wait(90)
                ce1group()
                task.Wait(40)
                ce2group()
                task.Wait(240)
                ce5(-64, 245, 1)
                ce5(64, 245, 1)
                task.Wait(420)
                clearEnemyAndBullet()
                system.PowerRank.pauseHyper()
                task.Wait(180)
            end
        end
    end
end


return R
