-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local accdecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local accDecDisplacementTask = EGGlib.ObjectEvent.accDecDisplacementTask
local accDecDisplacementAndReturn = EGGlib.ObjectEvent.accDecDisplacementAndReturn
local simPar = EGGlib.ObjectEvent.simPar
local boundWait = EGGlib.ObjectEvent.boundWait
local oppoVelchTask = EGGlib.ObjectEvent.oppoVelocityChangeTask
local sty = EISlib.Enemy.Style
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local tranRot = EGGlib.Math.TranRot
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local curve_normal1 = EGGlib.BulletGroup.Curve.normal1
local tri_circleLayer3 = EGGlib.BulletGroup.TriAngleStroke.circleLayer3
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1

--彩虹屁拖影
local rainbow = Class(laser_bent)
function rainbow:init(mst, len, wide, wt)
    if IsValid(mst) then
        local a = 0
        self.getPos = function()
            if mst.dx ~= 0 and mst.dy~= 0 then --update
                a = Angle(0, 0, mst.dx, mst.dy)
            end
            local dx, dy = tranRot(0, 0, a)
            return dx, dy
        end
        local dx, dy = self.getPos()
        laser_bent.init(self, 1, mst.x + dx, mst.y + dy, len, wide, "Gluttony_rainbow", 0)
        self.rot = a
        self.alpha = 1
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.colli = false -- 特效用曲线激光
        self.bound = false
        self.mst = mst
        self.release = false
        robject.set_color(self, "mul+add", 255, 255, 255, 255)
        task.New(self, function()
            task.Wait(wt)
            local t = 30
            local l0 = self.l
            local dl = -l0/t
            while l0 + dl > 2 do
                l0 = l0 + dl
                self.l = math.ceil(l0)
                task.Wait(1)
            end
            self.status = 'del'
        end)
    else
        self.status = "del"
    end
end
function rainbow:frame()
    if not self.release then
        if IsValid(self.mst) then
            local dx, dy = self.getPos()
            self.rot = self.mst.rot
            self.x, self.y = self.mst.x + dx, self.mst.y + dy
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

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --射出去的转向自机相关弹幕
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )


    --吊线生成器
    local whole_line = {}
    local line_unit, ball_unit
    function whole_line.new()
        local line_tb = {}
        line_tb.unit = {} --组成线的单元
        line_tb.ball = nil --下端的球
        return line_tb
    end
    function whole_line.addUnit(line_tb, unit)
        table.insert(line_tb.unit, unit)
    end
    function whole_line.getUnitTable(line_tb)
        return line_tb.unit
    end
    function whole_line.getBall(line_tb)
        return line_tb.ball
    end
    function whole_line.setBall(line_tb, ball)
        line_tb.ball = ball
    end
    B.line_creater = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 3
                local acc = 0.02
                local interval = 4
                --count为吊线单位数
                local function create(x, y, count, u)
                    local line_tb = whole_line.new() --装有毛线球的表
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED, true)
                    obj.colli = false
                    obj.hide = true
                    boundWait(obj, 360)
                    local acca = 90*(1-u)
                    simPar(obj, v, -90, acc, acca) --o, v, va, acc, acca
                    task.New(obj, function()
                        --创建吊线小单元
                        line_tb.unit = {}
                        for i = 0, count - 1 do
                            whole_line.addUnit(line_tb, B.line_unit.create(obj.x, obj.y, (obj.x - x), acca, interval*(count - 1 - i), u))
                            task.Wait(interval)
                        end
                        --创建吊线下面的毛线球
                        local ball = B.bool_ball.create(obj.x, obj.y, (obj.x - x), acca, 0, u)
                        whole_line.setBall(line_tb, ball)
                        ball_unit.setLineTb(ball, line_tb)
                        --line_tb.ball.master_tb = line_tb
                    end)
                    return line_tb
                end
                return create
            end
    )

    --吊线小单元及毛线球共有的逻辑
    line_unit = {}
    line_unit.tg0, line_unit.tg1, line_unit.tg2 = 20, 20, 20
    line_unit.tr0, line_unit.tr1, line_unit.tr2 = 30, 0, 30
    function line_unit.init(obj, s, a, dt, u, alpha)
        ---param
        local tg0, tg1, tg2 = line_unit.tg0, line_unit.tg1, line_unit.tg2
        local tr0, tr1, tr2 = line_unit.tr0, line_unit.tr1, line_unit.tr2
        ---
        --反向运动逻辑(不影响最终位置）
        local t = line_unit.getTotalMoveTime() + dt
        local v = 2*abs(2*s/t)
        oppoVelchTask(obj, v, 0, -90 - 20*u, t + 60)
        --
        boundWait(obj, 60)
        obj.rot = a
        obj.omiga = 6
        obj.ready = false --出场运动结束的flag
        alphaChangeTask(obj, 0, alpha, 20)
        task.New(obj, function()
            accDecDisplacementTask(obj, -s*u, a, tg0, tg1 + dt, tg2) --o, s, a, t0, t1, t2
            --回转（也不影响最终位置）
            accDecDisplacementAndReturn(obj, -1*s*u, a,
                    tg0, tg1 + dt, tg2, --tg0, tg1, tg2
                    tr0, tr1, tr2 --tr0, tr1, tr2
            )
            obj.ready = true
        end)
    end
    function line_unit.getTotalMoveTime()
        return line_unit.tg0 + line_unit.tg1 + line_unit.tg2 + line_unit.tr0 + line_unit.tr1 + line_unit.tr2
    end
    function line_unit.isReady(obj)
        return obj.ready
    end


    --组成吊线的每个小单元
    B.line_unit = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local style, color = stg.star_small, COLOR_RED
                local function create(x, y, s, a, dt, u)
                    local obj = stg.newSimpleBullet(x, y, style, color, true, -1)
                    _connect(_boss, obj, 0, true)
                    line_unit.init(obj, s, a, dt, u, 150)
                    return obj
                end
                return create
            end
    )

    ball_unit = {}
    --球被猫碰到后执行的逻辑
    function ball_unit.init(obj, line_tb)
        obj.type = "wool_ball"
        obj.line_tb = line_tb
    end
    function ball_unit.setLineTb(obj, line_tb)
        obj.line_tb = line_tb
    end
    function ball_unit.getLineTb(obj)
        return obj.line_tb
    end
    --球被猫碰到时执行的函数，会先进行存在判断和是否为毛线球判断
    function ball_unit.knocked(obj)
        if IsValid(obj) and obj.type == "wool_ball" then
            P.ball_boom.attack(obj.x, obj.y, -90 + ran:Float(-5, 5))
            --整条链直接散开
            local u = sign(obj.x)
            local line_tb = ball_unit.getLineTb(obj)
            if line_tb ~= nil then
                local line_unit_tb = whole_line.getUnitTable(line_tb)
                T.line_spread.main(line_unit_tb, u)
            end
            Del(obj)
        end
    end
    B.bool_ball = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, s, a, dt, u)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_wool, COLOR_DEEP_RED, true, -0.1)
                    obj.bound = false
                    --T.line_unit_action.main(obj, s, a, dt, u, 255)
                    line_unit.init(obj, s, a, dt, u, 255)
                    ball_unit.init(obj)
                    return obj
                end
                return create
            end
    )

    --猫爪弹
    B.bullet_1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, da, v)
                    local obj = stg.newSimpleBullet(x, y, stg.grain_b, COLOR_RED)
                    obj.rot = a + da
                    task.New(obj, function()
                        velch(obj, 3, 0, a + da, 40)
                        a = Angle(obj, player) + da
                        obj.rot = a
                        velch(obj, 0, v, a, 30)
                    end)
                end
                return create
            end
    )

    --彩虹桥
    B.bullet_2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.star_small, COLOR_GRAY - 1)
                    obj.omiga = 6
                    obj.start_angle = a
                    return obj
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --初始发射大量弹幕
    P.big_break = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    16, 20, 30, 40, 40
                })
                local da = 180/way
                local layer = switch1(diff, {
                    6, 8, 10, 12, 12
                })
                local style, color = stg.star_big, COLOR_DEEP_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color).omiga = 6
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --球被猫搞爆了
    P.ball_boom = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case:way数
                local way = switch1(diff, {
                    12, 12, 15, 18, 18
                })
                --case:层数
                local layer = switch1(diff, {
                    1, 2, 2, 2, no_info
                })
                local dv_l = switch1(diff, {
                    no_info, 0.35, 0.4, 0.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local da_l = 360/way/layer
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.5, 1.75, 2, 2.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                --case：相邻弹幕速度差
                local dv0 = switch1(diff, {
                    0.03, 0.035, 0.04, 0.05, 0.05
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    for i = 1, 0, -1 do
                        for u = -1, 1, 2 do
                            setSizeAndColli(stg.newSimpleStrChV(x, y, 0, v - dv0*i, a + (0.75 + 1*i)*u, 60, 0, style, color, false, -1), 0.65, 0.5)
                        end
                    end
                end
                local way_c = way*2
                local function bullet_func2(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, stg.ball_mid, COLOR_DEEP_RED)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0 + 2*dv0, a, way,
                                        layer, dv_l, da_l, 0,
                                        bullet_func
                                )
                                circle_layer1(x, y, v0, a, way,
                                        layer, dv_l, da_l, 0,
                                        bullet_func2
                                )
                            end)
                end
                return attack
            end
    )

    --星星链散开之后
    P.line_spread = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    1, 2, 2, 3, 3
                })
                local da_w = switch1(diff, {
                    0, 30, 30, 36, 30
                })
                local v = switch1(diff, {
                    1.5, 1.75, 2, 2.25, 2.25
                })*defaultSwitchVelocityByRank(rank)
                local dv0 = switch1(diff, {
                    0.02, 0.023, 0.027, 0.03, 0.03
                })
                local style, color = stg.ball_mid, COLOR_DEEP_RED
                local function attack(x, y, a, i)
                    local function bullet_func(x, y, v, a)
                        --stg.newSimpleStrChV(x, y, 0, v - 2*dv0, a, 60, 0, stg.ball_mid, COLOR_DEEP_RED)
                        if i%2 == 0 then
                            stg.newSimpleStrChV(x, y, 0, v - 2*dv0, a, 60, 0, stg.ball_mid, COLOR_DEEP_RED)
                            for i = 1, 0, -1 do
                                for u = -1, 1, 2 do
                                    setSizeAndColli(stg.newSimpleStrChV(x, y, 0, v - dv0*i, a + (0.75 + 1*i)*u, 60, 0, style, color, false, -1), 0.65, 0.5)
                                end
                            end
                        end
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v, a,
                                        way, da_w,
                                        1, 0, 0, --layer, dv_l, da_l,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )

    --猫边移动边生成的自机狙
    P.pointer_1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.grain_b, COLOR_RED
                local v = switch1(diff, {
                    3, 3, 3, 4, 3
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)*0
                local way = switch1(diff, {
                    1, 3, 5, 3, 5
                })
                local da = switch1(diff, {
                    0, 30, 20, 120, 5
                })
                local function attack(x, y, c_v, a, u)
                    local function bullet_func(x, y, v, a) --注意是da
                        --B.bullet_1.create(x, y, a, da, v)
                        stg.newSimpleStrChV(x, y, 0, v, a, 180, 0, style, color)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v + dv*c_v, a, way, da*u, bullet_func)
                            end)
                end
                return attack
            end
    )

    --彩虹桥
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.star_small, COLOR_DEEP_BLUE
                local v = switch1(diff, {
                    3, 3.5, 3.75, 4, 2
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    1, 2, 3, 3, 3
                })
                local w = max(1, way - 1)
                local da = switch1(diff, {
                    90, 80, 80, 90, 90
                })/w
                local function bullet_func(x, y, v, a) --注意是da
                    stg.newSimpleStrChV(x, y, 0, v, a, 360, 0, style, color).omiga = -3
                end
                local function attack(x, y, a)
                    stg.newFadeEffect(x, y, style, COLOR_GRAY, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --猫
    local cat_class = {}
    do
        local c = cat_class
        c.t0 = 13 --猛扑时间
        c.t1 = 5 --猛扑减速时间
        c.t2 = 5 --开始时回跳时间
        c.t3 = 0 --回跳完到开始猛扑的时间间隔
        c.attack_interval = 1
        function cat_class.init(obj)
            obj.prePounce = false --准备好扑了的flag
            obj.target = nil --要扑的目标
            obj.no_attack = false --本次不攻击flag
            obj.bullet_tb = {} --装控制子弹的table
            obj.colli = false
            task.New(obj, function()
                while true do
                    if not obj.prePounce then
                        task.Wait(1)
                    elseif IsValid(obj.target) then --准备好扑了
                        local target = obj.target
                        local u = sign(target.x - obj.x)
                        New(rainbow, obj, 60, 20, 60) --mst, len, wide, live_time
                        if not obj.no_attack then
                            task.New(obj, function()
                                task.Wait(c.t2)
                                local count = math.floor((c.t0 + c.t1 + c.t3)/c.attack_interval)
                                local a
                                for i = 0, count - 2 do
                                    a = Angle(0, 0, obj.dx, obj.dy)
                                    table.insert(obj.bullet_tb, B.bullet_2.create(obj.x, obj.y, a - (-10 + 3*(count - 1 - i))*u))
                                    task.Wait(c.attack_interval)
                                end
                            end)
                        end
                        halfMoveLengthWithPar(obj, target.x, target.y, 0, Angle(obj, target) + 45*u, c.t0, c.t1, c.t2, c.t3) --x, y, vy, a, t0, t1, t2, t3
                        ball_unit.knocked(obj.target)
                        obj.prePounce = false
                        obj.no_attack = true
                    else
                        obj.prePounce = false
                    end
                end
            end)
        end
        --操纵猫的方法，扑向某个目标，并返回命令执行结果
        function cat_class.pounceToTarget(obj, target, no_attack)
            if obj.prePounce then
                return false
            else
                obj.no_attack = no_attack
                obj.prePounce = true
                obj.target = target
                --todo 为这个target加一个标记符号怎么样？
                return true
            end
        end
        --把滞留在屏幕的子弹全部展开
        function cat_class.releaseBullets(obj)
            task.New(obj, function()
                local o
                local tb = {}
                --deepcopy
                for k, v in pairs(obj.bullet_tb) do
                    tb[k] = v
                end
                obj.bullet_tb = {} --清空
                for i = #tb, 1, -1 do
                    o = tb[i]
                    if IsValid(o) and not obj.release then
                        PlaySound("kira00")
                        P.pointer2.attack(o.x, o.y, o.start_angle)
                        Del(o)
                    end
                    task.Wait(1)
                end
            end)
        end
        function cat_class.getTotalMoveTime()
            return c.t0 + c.t1 + c.t2 + c.t3
        end
    end

    E.cat = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(enemy, x, y, sty.CAT, --style
                            _infinite, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            true --type
                    )
                    enemy.setBoundTime(obj, _infinite)
                    enemy.cancelAura(obj)
                    cat_class.init(obj)
                    obj.layer = LAYER_ENEMY_BULLET
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.line_spread = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --往中间挤压的程度
                local da = switch(rank, {
                    0, 0, 0, 0, 30
                })
                local function main(line_unit_tb, u)
                    boss.createTasker(_boss, 0, 0,
                            function(obj)
                                task.New(obj, function()
                                    local o
                                    local n = #line_unit_tb
                                    for i = n, 1, -1 do
                                        o = line_unit_tb[i]
                                        if IsValid(o) then
                                            P.line_spread.attack(o.x, o.y, -90 - (-120 + da + 9*(n - i))*u, i)
                                        end
                                        _del(o, true)
                                        task.Wait(2)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u0, count)
                    local cat = b.cat
                    local isOver = false --本轮攻击是否结束了
                    --得有个东西接收一整串毛线球
                    local line_tb_tb = {}
                    local dx = 70
                    local d_dx = 25
                    local u, n
                    --给猫扑球的指示
                    task.New(cat, function()
                        task.Wait(120)
                        local obj
                        for i = 0, count - 1 do
                            while true do
                                if line_tb_tb[i] == nil then
                                    task.Wait(1)
                                else
                                    obj = whole_line.getBall(line_tb_tb[i])
                                    if IsValid(obj) and line_unit.isReady(obj) then --球存在且出场运动完了
                                        break
                                    else
                                        task.Wait(1)
                                    end
                                end
                            end
                            while not cat_class.pounceToTarget(cat, obj) do --扑向球
                                task.Wait(1)
                            end
                        end
                        while not cat_class.pounceToTarget(cat, b, true) do --最后一次返回boss身边(不攻击）
                            task.Wait(1)
                        end
                        task.Wait(cat_class.getTotalMoveTime())
                        cat_class.releaseBullets(cat) --释放所有的弹幕
                        isOver = true
                    end)
                    for i = 0, count - 1 do
                        u = tranU(i)*u0
                        n = 8 + 1.5*i
                        line_tb_tb[i] = B.line_creater.create(dx*u, 224, n, u) --x, y, count, u
                        --task.Wait(30)
                        if i%2 == 1 then
                            dx = dx + d_dx
                        end
                    end
                    while not isOver do
                        task.Wait(1)
                    end
                end
                return main
            end)
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        local new_rank = system.PowerRank.getRank()
        if rank ~= new_rank then --以下两个会受rank影响，需要更新
            for _, v in pairs(B) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(P) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(T) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(C) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(E) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(S) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end

    local function summonCat(b)
        b.cat = E.cat.create(-30, 224) --把猫放进来了
        task.New(b.cat, function()
            task.MoveTo(b.cat, b.cat.x, b.y, 60, MOVE_NORMAL)
        end)
        --todo 猫已就位，是不是要加一些摸猫的动作？
    end
    
    local names = {
        "name-boss8-card3-E",
        "name-boss8-card3-N",
        "name-boss8-card3-H",
        "name-boss8-card3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            3000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                summonCat(b)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                summonCat(b)
                task.Wait(60)
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                P.big_break.attack(b.x, b.y, Angle(b, player)) --发射开屏弹幕
                local count = 6
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u, count)
                        count = min(count + 1, 10)
                    end
                end
            end,
            function(b) --finish
                if IsValid(b.cat) then
                    local obj = b.cat
                    local c = cat_class
                    task.clear(obj)
                    --猫猫离场
                    task.New(obj, function()
                        if IsValid(_boss) and not _boss.spell_timeout then
                            item.Blood.create(obj.x, obj.y, item.Blood.Huge)
                        end
                        obj.vx, obj.vy = 0, 0
                        obj.ax, obj.ay = 0, 0
                        task.Wait(60)
                        New(rainbow, obj, 60, 20, 60) --mst, len, wide, live_time
                        if obj.x < 0 then
                            halfMoveLengthWithPar(obj, 300, obj.y + 100, 0, Angle(obj.x, obj.y, 300, obj.y + 100), c.t0, c.t1, c.t2, c.t3)
                        else
                            halfMoveLengthWithPar(obj, -300, obj.y + 100, 0, Angle(obj.x, obj.y, -300, obj.y + 100), c.t0, c.t1, c.t2, c.t3)
                        end
                        _del(obj, false)
                    end)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
