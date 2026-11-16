-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local sty = EISlib.Enemy.Style
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local stopV = EGGlib.ObjectEvent.stopV
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local setSize = EGGlib.ObjectEvent.setSize
local boundWait = EGGlib.ObjectEvent.boundWait
local sin = EGGlib.Math.phaseToSin
local cos = EGGlib.Math.phaseToCos
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask

local fur = Class(object)
function fur:init(x, y, img)
    self.x, self.y = x, y
    self.img = img
    self.hscale, self.vscale = 1, 1
    self.a, self.b = 4, 4
    self.rot = 0
    self.group = GROUP_ENEMY_BULLET
    self.layer = LAYER_ENEMY_BULLET
    robject.set_color(self, "", 255, 255, 255, 255)
end
function fur:frame()
    task.Do(self)
end
function fur:render()
    defaultRenderImg(self)
end
function fur:kill()
    item.PointSmall.create(self.x, self.y)
end
function fur:del()
    
end

local function createCard(difficulty)
    local cat --本张卡对猫实例的引用声明

    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    B.fur = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local va0 = 9*defaultSwitchVelocityByRank(rank)
                local va1 = 7.5*defaultSwitchVelocityByRank(rank)

                local vb0 = 4*defaultSwitchVelocityByRank(rank)
                local vb1 = 3*defaultSwitchVelocityByRank(rank)

                local v = 4*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a)
                    local obj = New(fur, x, y, Bclass.fur_img_list[1])
                    boundWait(obj, 60)
                    obj.rot = a
                    velchTask(obj, 6, 0, 90, 30)
                    velchTask(obj, va0*cos(a), va1*cos(a), 0, 30)
                    velchTask(obj, vb0*sin(a), vb1*sin(a), 90, 30)
                    obj._a = 0
                    obj._blend = ""
                    setSize(obj, 3, 3)
                    obj.colli = false
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.layer = LAYER_ENEMY_BULLET + 1
                        obj._blend = ""
                        obj.colli = true
                    end)
                end
                return create
            end
    )

    --彩虹拖尾（跟着猫屁股后面的）
    B.rainbow_trail1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, t)
                    local obj = New(bent_laser_effection, Bclass.rainbow_tex, mst.x, mst.y, mst.rot, t, 20) --tex, x, y, rot, len, wide
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        moveWith(obj, mst, 0, 0, t)
                        bent_laser_effection.disappear(obj, t)
                    end)
                end
                return create
            end
    )

    --彩虹拖尾（从两侧出来的）
    B.rainbow_trail2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, u, t)
                    local u0 = ran:Sign()
                    local a = 90 + 45*u*u0
                    local obj = New(bent_laser_effection, Bclass.rainbow_tex, x, y, a, t, 20) --tex, x, y, rot, len, wide
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        halfMoveLengthWithPar(obj, 300*u, y + ran:Float(-80, 80), 0, a, t, 1, 0, 0) --x, y, vy, a, t0, t1, t2, t3
                        obj.isDel = true
                        bent_laser_effection.disappear(obj, t)
                    end)
                end
                return create
            end
    )

    --彩虹拖尾（制造龙卷风的单元）
    B.rainbow_trail3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, y, phase, t)
                    local obj = New(bent_laser_effection, Bclass.rainbow_tex, mst.x, mst.y, phase + 90, 30, 20) --tex, x, y, rot, len, wide
                    local x0, y0 = mst.x, mst.y
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    alphaChangeTask(obj, 0, 255, 30)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET
                        local x = 0
                        local function doAction()
                            x = x + 3
                            y = y + 3
                            phase = phase + 6
                            obj.x, obj.y = x0 + x*cos(phase), y0 + y
                            task.Wait(1)
                        end
                        for i = 1, t - 30 do
                            doAction()
                        end
                        alphaChangeTask(obj, 255, 0, 30)
                        for i = 1, 30 do
                            doAction()
                        end
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --龙卷风
    B.cyclone = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local wait = switch(rank, {
                    10, 10, 10, 10, 7
                })
                local function create(x, y, u)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_huge, COLOR_RED, true)
                    obj.bound = false
                    obj.hide = true
                    --攻击逻辑
                    task.New(obj, function()
                        task.Wait(120)
                        for i = 0, _infinite do
                            P.fur.attack(obj.x, obj.y -(obj.hscale - 1)*30 , -90 + ran:Float(-2.5, 2.5))
                            task.Wait(wait)
                        end
                    end)
                    --变大逻辑
                    task.New(obj, function()
                        obj.a, obj.b = 1*obj.a, 1.5*obj.b
                        sizeAndColliChangeTask(obj, 3, 480)
                    end)
                    --产生旋风逻辑
                    task.New(obj, function()
                        for i = 1, _infinite do
                            PlaySound("wind")
                            for j = 1, 3 do
                                B.rainbow_trail3.create(obj, -obj.hscale*30, -30*i + 120*j, 20 + obj.hscale*20) --mst, y0, phase, t
                                task.Wait(2)
                            end
                        end
                    end)
                    --移动逻辑
                    task.New(obj, function()
                        local t = 420
                        local phase, dphase = 0, 1800/t
                        local A, dA = 0, 60/t*u
                        local vy, dvy = 0, 5/t
                        local y0, dy0, v = 120, (-10 - 120)/t
                        for _ = 1, t do
                            phase = phase + dphase
                            A = A + dA
                            obj.x = A*sin(phase)
                            vy = vy + dvy
                            v = vy*ran:Sign()
                            y0 = y0 + dy0
                            if obj.y + v > y0 + 44 or obj.y + v < y0 then
                                v = -v
                            end
                            obj.y = obj.y + v
                            task.Wait(1)
                        end
                        stopV(obj, 60)
                        if IsValid(cat) then
                            cat.x, cat.y = obj.x, obj.y
                            alphaChangeTask(cat, 0, 255, 20, false, true)
                        end
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --
    --endregion
    --region 子弹发射点定义
    --发一圈
    P.fur = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 36
                local layer = 1
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, _, a)
                    B.fur.create(x, y, a)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    circle_layer1(x, y, 0, a, way, layer, 0, 0, 0, bullet_func)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    E.cat = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(enemy, x, y, sty.CAT, --style
                            _infinite, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    setSize(obj, 0.75, 0.75)
                    sizeChangeTask(obj, 0.25, 8)
                    enemy.setBoundTime(obj, _infinite)
                    obj.colli = false
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --其它彩虹屁产生器
    T.rainbow_creator = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(u)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    task.Wait(90)
                                    local wait = 30
                                    for _ = 1, 30 do
                                        PlaySound("wind")
                                        B.rainbow_trail2.create(-224*u, obj.y, u, 20)
                                        B.rainbow_trail2.create(224*u, obj.y, -u, 20)
                                        task.Wait(wait)
                                        wait = max(3, wait - 10)
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
                local function main(u)
                    T.rainbow_creator.main(u)
                    for i = 0, 3 do
                        B.rainbow_trail1.create(cat, 60)
                        halfMoveLengthWithPar(cat, -300*tranU(i)*u, 144 - 5*i, 0, 90 + 45*tranU(i)*u, max(10, 50 - 12*i), 1, 0, 0) --x, y, vy, a, t0, t1, t2, t3
                        --task.Wait(30 - 6*i)
                    end
                    B.cyclone.create(0, 120, u)
                    task.Wait(480)
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

    local function bossAction(b)
        b.changeToHuman()
        cat = E.cat.create(b.x, b.y - 3)
        b.cat_inst = cat
        task.Wait(30)
    end


    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card2", --非/符卡名
            "extra", --类型
            {3, 3, 50}, --时间
            3000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                bossAction(b)
                PlaySound("cat01")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                bossAction(b)
                PlaySound("cat01")
            end,
            function(b) --main
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(u)
                    end
                end
            end,
            function(b) --finish
                if not b.spell_timeout then
                    item.PlayerBomb.create(b.x, b.y)
                end
                if system.isDoubleGetSpellCardBonus(b) then
                    achievement.unlock("s7_sc2", true, true) -- AchievementReminder.unlock("s7_sc2", "无情之人", "成功双倍收取可莱娜的符卡「可爱毛球风暴」")
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
