-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local accDecMoveToPointTask = EGGlib.ObjectEvent.accDecMoveToPointTask
local sin = EGGlib.Math.phaseToSin
local highEfficiencyTranRot = EGGlib.Math.highEfficiencyTranRot

--计数器定义
local eat_count_displayer = Class(object)
function eat_count_displayer:init(mst)
    self.x, self.y = mst.x, mst.y
    self.mst = mst
end
function eat_count_displayer:frame()
    local mst = self.mst
    if IsValid(mst) then
        self.x, self.y = mst.x, mst.y
    else
        Del(self)
    end
end
function eat_count_displayer:render()
    local mst = self.mst
    if IsValid(mst) then
        if mst.eat_count >= 60 then
            RenderTTF('Mono24', string.format("%d", mst.eat_count), mst.x, mst.y + 10, mst.x, mst.y + 10, 2, Color(255, 255, 0, 0), 'left', 'noclip')
        else
            RenderTTF('Mono24', string.format("%d", mst.eat_count), mst.x, mst.y + 10, mst.x, mst.y + 10, 2, Color(255, 255, 255, 0), 'left', 'noclip')
        end
    end
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --鱼干弹幕表
    local fish_list = {}
    --region Bullet 自定义子弹
    --鱼干弹幕
    B.fish = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local vxmin, vxmax = 0*defaultSwitchVelocityByRank(rank), 2*defaultSwitchVelocityByRank(rank)
                --vy只影响掉落速度不影响上升速度
                local vymin, vymax = 1*defaultSwitchVelocityByRank(rank), 5*defaultSwitchVelocityByRank(rank)
                local function create(x, y, u)
                    local obj = stg.newSimpleBullet(x, y, stg.ellipse, COLOR_BLUE)
                    B.fish_eye.create(obj, u)
                    B.fish_trail.create(obj, u)
                    obj.vscale = -u --咸鱼翻身
                    obj.navi = true
                    obj.vx = ran:Float(vxmin, vxmax)*u
                    task.New(obj, function()
                        --向上减速
                        velch(obj, ran:Float(5, 8), 0, 90, 120)
                        --向下加速
                        velch(obj, 0, ran:Float(vymin, vymax), -90, 180)
                    end)
                    table.insert(fish_list, obj)
                end
                return create
            end
    )

    --鱼眼
    B.fish_eye = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, u)
                    local a = mst.rot
                    local dx, dy = highEfficiencyTranRot(5, 0, a)
                    local obj = stg.newSimpleBullet(mst.x + dx, mst.y + dy, stg.ball_small, COLOR_DEEP_BLUE)
                    obj.rot = a
                    obj.hscale = 0.5
                    obj.vscale = 0.5*u
                    --跟随逻辑
                    task.New(obj, function()
                        obj.layer = mst.layer
                        while IsValid(mst) and not mst.fade_out do
                            a = mst.rot
                            dx, dy = highEfficiencyTranRot(5, 0, a)
                            obj.x, obj.y = mst.x + dx, mst.y + dy
                            obj.rot = a
                            task.Wait(1)
                        end
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --鱼尾巴
    B.fish_trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, u)
                    local a = mst.rot + 180
                    local dx, dy = highEfficiencyTranRot(12, 0, a)
                    local obj = stg.newSimpleBullet(mst.x + dx, mst.y + dy, stg.ellipse, COLOR_BLUE)
                    obj.rot = mst.rot - 90*u
                    obj.hscale = 0.4
                    obj.vscale = 0.9*u
                    --跟随逻辑
                    task.New(obj, function()
                        obj.layer = mst.layer - 0.0000001
                        while IsValid(mst) and not mst.fade_out do
                            a = mst.rot + 180
                            dx, dy = highEfficiencyTranRot(12, 0, a)
                            obj.x, obj.y = mst.x + dx, mst.y + dy
                            obj.rot = mst.rot - 90*u
                            task.Wait(1)
                        end
                        _del(obj, true)
                    end)

                end
                return create
            end
    )

    --猫
    B.cat = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --吃鱼干函数
                local function eat(obj)
                    sp.UnitListUpdate(fish_list)
                    for _, fish in pairs(fish_list) do
                        if Dist(obj, fish) < 20 and obj.eat_count < 72 and not fish.isDel then
                            PlaySound("pop")
                            obj.eat_count = obj.eat_count + 1 --吃的数量加1
                            if obj.eat_count == 72 then
                                achievement.unlock("s7_sc1", true, true)  -- AchievementReminder.unlock("s7_sc1", "虔诚的猫奴")
                            end
                            fish.isDel = true
                            Del(fish)
                        end
                    end
                end
                --猫被扔出去纵向减到初速度的负数与横向减到最低速度的时间
                local t0 = 60
                --猫下落的初速度和饱和速度
                local vy0, vymax = 2, -4
                --从纵向速度为初速度的负数到饱和速度需要的时间
                local t1 = (vymax + vy0)/(-2*vy0/t0)
                --猫被横向扔出的初速度与末速度
                local vx0, vx1 = 3.75, 0.25
                --鱼干转化为心弹的比率
                local heart_rate = switch(rank, {
                    0.8, 0.8, 0.8, 0.8, 1
                })
                local function create(x, y, vx_w)
                    local obj = New(Bclass.servant1, x, y,
                            9999, false, system.DROP_NONE, --hp, show_hpbar, drop,
                            nil, COLOR_DEEP_PURPLE --death_func, color
                    )
                    obj.group = GROUP_INDES
                    B.cat_trail.create(obj) --生成尾巴
                    _connect(_boss, obj, 0, true)
                    obj.bound = false
                    obj.eat_count = 0 --吃掉的鱼干数
                    --New(eat_count_displayer, obj) --测试，用于显示吃了多少条鱼
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    alphaChangeTask(obj, 0, 255, 30, false, true)
                    setSizeAndColli(obj, 0.1, 0.1)
                    spSizeAndColliChangeTask(obj, 0.6, 30, 120)
                    --通用移动逻辑
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET+1
                        velchTask(obj, vx0*vx_w, vx1*vx_w, 0, t0)
                        velch(obj, vy0, -vy0, 90, t0)
                        velch(obj, -vy0, vymax, 90, t1)
                    end)
                    --x坐标上偏移实现自机狙逻辑
                    task.New(obj, function()
                        --算出移动到自机y上需要的时间
                        local t
                        --分自机在boss下方和头顶两种情况（其实可以用min来优化的，但是为了可读性选择用if）
                        if player.y - y < 0 then --boss下方
                            t = t0 + (player.y - y)/((-vy0 + vymax)/2)
                        else --boss头顶
                            t = t0
                        end
                        --算出x偏移量所对应的速度
                        local vx = 2*(player.x - x)/t
                        velchTask(obj, vx, 0, 0, t)
                    end)
                    --吃鱼干逻辑
                    task.New(obj, function()
                        while obj.y > -224 do
                            eat(obj)
                            task.Wait(1)
                        end
                        --发出的弹幕数取决于吃掉的鱼干数
                        P.heart.attack(obj.x, obj.y, math.floor(heart_rate*obj.eat_count), 90)
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    --猫拖尾
    B.cat_trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(cat)
                    local obj = New(bent_laser_effection, Bclass.servant_trail_tex, cat.x, cat.y, cat.rot, 30, 20) --tex, x, y, rot, len, wide
                    robject.set_color(obj, "mul+add", 255, 255, 0, 255)
                    task.New(obj, function()
                        moveWith(obj, cat, 0, 0, _infinite)
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )

    --吃完鱼后发出来的爱心弹幕
    B.heart = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local s = 30
                local v = 1.25*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a)
                    local obj = stg.newSimpleBullet(x - s*cos(a), y - s*sin(a), stg.heart, COLOR_PURPLE)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    obj.colli = false
                    obj.bound = false
                    obj.rot = a
                    setSize(obj, 3, 3)
                    accDecMoveToPointTask(obj, x, y, 15, 14, 1)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.bound = true
                        obj.colli = true
                        obj._blend = ""
                        velch(obj, 1.5, 0.5, a, 30)
                        velch(obj, 0, (v - 0.5), a, 90)
                    end)
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    P.fish = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --一轮鱼干的鱼干数量
                local count = switch(rank, {
                    60, 60, 60, 60, 75
                })
                local style, color = stg.ellipse, COLOR_BLUE
                local function attack(x, y, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for _ = 1, count do
                                    B.fish.create(x, y, u)
                                end
                            end)
                end
                return attack
            end
    )

    --吃饱了发出爱心
    P.heart = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local function bullet_func(x, y, v, a)
                    B.heart.create(x, y, a)
                end
                local function attack(x, y, way, a)
                    PlaySound("kira00")
                    circle_normal1(x, y, 0, a, way, bullet_func)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --一轮鱼、一轮猫
    T.fishAndCat = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = 5
                local function main(u)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for u = -1, 1, 2 do
                                        P.fish.attack(-192*u, -224, u)
                                    end
                                    task.Wait(60)
                                    local w = (way - 1)/2
                                    for i = -w, w do
                                        B.cat.create(_boss.x, _boss.y, i*u)
                                        task.Wait(10)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    T.fishAndCat.main(u)
                    task.Wait(190)
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

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card1", --非/符卡名
            "extra", --类型
            {3, 3, 50}, --时间
            2400, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                PlaySound("cat01")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                PlaySound("cat01")
            end,
            function(b) --main
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
