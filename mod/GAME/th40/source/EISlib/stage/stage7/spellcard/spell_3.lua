-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint

local function rotate(self, mst, ra, rb, da, db, angle, omiga, t0, t1, t2)
    local c = {} --controller
    c.angle = angle
    local dx, dy
    c.ra, c.rb = ra, rb
    t0 = t0 or 1
    t1 = t1 or _infinite
    t2 = t2 or 1
    local domiga = 0
    local Expand, dx1, dy1
    Expand = function(t)
        for _ = 1, t do
            if IsValid(mst) then
                c.ra, c.rb = c.ra + da, c.rb + db
                omiga = omiga + domiga
                c.angle = c.angle + omiga
                dx, dy = cos(mst.rot), sin(mst.rot)
                dx1, dy1 = c.ra*cos(c.angle), c.rb*sin(c.angle)
                self.x, self.y = mst.x + dx1*dx - dy1*dy, mst.y + dx1*dy + dy1*dx
            else
                break
            end
            task.Wait(1)
        end
    end
    Expand(t0)
    da, db = 0, 0
    Expand(t1)
    da, db = -c.ra/t2, -c.rb/t2
    Expand(t2)
    return c
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --黑洞中心
    B.cave_center = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local count = switch(rank, {
                    100, 100, 100, 100, 150
                })
                local w_rate = 180/count
                local wait = 1
                local dra = 162/count
                local drb = 108/count
                local da = switch(rank, {
                    -20, -20, -20, -20, -15
                })
                local function create(x, y, x1, y1, rot, u, co)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_RED, true)
                    obj.rot = rot
                    obj.bound = false
                    obj.colli = false
                    obj.omiga = 0.5*u
                    obj.hide = true
                    task.New(obj, function()
                        local j
                        for i = 0, count - 1 do
                            j = (count - i)
                            B.ball_small.create(obj, 75 + dra*j, 50 + drb*j, 90 + da*i*u, u, w_rate*j*(wait + 1), co) --mst, ra, rb, angle, u, dt, co
                            task.Wait(wait)
                        end
                    end)
                    --移动逻辑
                    task.New(obj, function()
                        accDecMoveToPoint(obj, x1, y1, 180, 180, 180)
                        for _ = 1, 60 do
                            stg.newAcceleration(obj.x, obj.y, ran:Float(6, 8), 90 + ran:Float(-10, 10), 0.05, -90, 10, 60, stg.ball_mid, COLOR_RED)
                            task.Wait(3)
                        end
                    end)
                end
                return create
            end
    )

    B.ball_small = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local omiga = switch(rank, {
                    0.15, 0.15, 0.15, 0.15, 0.15
                })
                local function create(mst, ra, rb, angle, u, dt, co)
                    local obj = stg.newSimpleBullet(mst.x, mst.y, stg.ball_mid, co or COLOR_YELLOW, true)
                    obj.bound = false
                    obj.hide = true
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 3, 3)
                    task.New(obj, function()
                        obj.hide = false
                        local c = rotate(obj, mst, ra, rb, -0.1875, -0.125, angle, omiga*u,
                                60, dt, 300) --t0, t1, t2
                        _del(obj, true)
                    end)
                    --变化逻辑
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -2, 20)
                        obj._blend = ""
                        obj.colli = true
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --干扰弹幕
    P.ball_mid_c = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 0.8*defaultSwitchVelocityByRank(rank)
                local layer = switch(rank, {
                    1, 1, 1, 1, 1
                })
                local dv = 0.2*defaultSwitchVelocityByRank(rank)
                local way = switch(rank, {
                    24, 24, 24, 24, 36
                })
                local da_i = 360/2.5/way
                local style, color = stg.ball_mid, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + 1, v, a, 60, 120, style, color)
                end
                local function attack(x, y, a, i)
                    --PlaySound("pop")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a + da_i*i, way, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    for u = -1, 1, 2 do
                        B.cave_center.create(-100*u, 274, -160*u, -224, -90 + 45*(u - 1), -u, COLOR_ORANGE + 0.5*(1+u)*(COLOR_YELLOW - COLOR_ORANGE))
                    end
                    task.Wait(240)
                    for u = -1, 1, 2 do
                        B.cave_center.create(-100*u, 274, -160*u, -224, -90 + 45*(u + 1), -u, COLOR_ORANGE + 0.5*(1+u)*(COLOR_YELLOW - COLOR_ORANGE))
                    end
                    task.Wait(60)
                    PlaySound("gluttony00")
                    task.Wait(180)
                end
                return main
            end)

    --固定干扰弹幕
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    task.New(_boss, function()
                        task.Wait(480)
                        for i = 0, _infinite do
                            P.ball_mid_c.attack(_boss.x, _boss.y, -90, i)
                            task.Wait(90)
                        end
                    end)
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
            "name-boss9-card3", --非/符卡名
            "extra", --类型
            {3, 3, 50}, --时间
            3000, --耐久
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
                reFresh()
                C.SECOND.main()
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
                        C.FIRST.main(u)
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
