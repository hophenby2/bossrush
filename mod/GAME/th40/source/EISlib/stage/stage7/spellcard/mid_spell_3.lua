-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/mid_spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local sty = EISlib.Enemy.Style
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local boss_name = "Artemina"  --以boss名来作为其相关素材的前缀
local light_red_tex = boss_name.."_light_red"
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local accDecMoveToPointTask = EGGlib.ObjectEvent.accDecMoveToPointTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local Bclass = EISlib.BossDefinition.Artemina
local boom_effect = Bclass.boom_effect
local setV = EGGlib.ObjectEvent.setV

--反色圈
local invert_color_circle = Class(object)
function invert_color_circle:init(x, y, r3, wait)
    self.layer = LAYER_TOP - 1
    self.group = GROUP_GHOST
    self.x = x
    self.y = y
    self.bound = false
    self.size1 = 0
    self.size2 = 0
    self.size3 = 0
    self.x3, self.y3 = player.x, player.y
    task.New(self, function()
        --player_class.changeSpeed(player, 0, 0) --禁止移动
        PlaySound("alert")
        for t = 1, 30 do
            self.size1 = 800*(1 - cos(3*t))
            self.size3 = r3*(1 - cos(3*t))
            task.Wait(1)
        end
        task.Wait(wait)
        --player.class.recoveredSpeed(player) --恢复移动
        PlaySound("alert")
        for t = 1, 30 do
            self.size2 = 800*(1 - cos(3*t))
            self.size3 = r3*(1 - sin(3*t))
            task.Wait(1)
        end
        Del(self)
    end)
end
function invert_color_circle:frame()
    task.Do(self)
end
function invert_color_circle:render()
    if self.size1 > 0 then
        effect.drawInverseColorCircle2(self.x, self.y, self.size1, 32)
    end
    if self.size2 > 0 then
        effect.drawInverseColorCircle2(self.x, self.y, self.size2, 32)
    end
    if self.size3 > 0 then
        effect.drawInverseColorCircle2(self.x3, self.y3, self.size3, 32)
    end
end


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local knife_list = {}
    local function stopAllKnifeAndChangeRot()
        sp.UnitListUpdate(knife_list)
        for _, knife in pairs(knife_list) do
            knife.vx, knife.vy, knife.ax, knife.ay = 0, 0, 0, 0
        end
    end


    local function changeAllKnifeRot(wait)
        local w = math.floor(wait/6)
        for i = 0, 5 do
            for j, knife in pairs(knife_list) do
                if j%6 == i then
                    if IsValid(knife) and knife.change and Dist(knife, player) > 80 then
                        knife.rot = Angle(knife, player) + 30*ran:Sign() --r = 80*sin(30)
                        stg.setBulletStyle(knife, stg.knife, COLOR_GREEN)
                        knife.v = knife.v + ran:Float(1.5, 2)
                        knife.change = true
                    end
                end
            end
            task.Wait(w)
        end
        task.Wait(wait%6)
    end

    local function resumeAllKnife()
        sp.UnitListUpdate(knife_list)
        for _, knife in pairs(knife_list) do
            velchTask(knife, 0, knife.v, knife.rot, 20)
            knife.change = true --可以变向
        end
    end

    local function changeStyle(obj)
        New(boom_effect, obj.x, obj.y)
        enemy.change_style(obj, sty.FAIRY_SAKUYA)
        task.New(obj, function()
            --发弹间隔
            local wait = 3
            local n = 0
            local x, y = obj.center_x, obj.center_y
            local r, a = obj.radius, obj.angle
            local t = 20
            local da = 1.5*obj.u
            local d_da = da/t
            da = 0
            for _ = 1, t do
                da = da + d_da
                a = a + da
                obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                task.Wait(1)
            end
            obj.bound = true
            for i = 0, _infinite do
                a = a + da
                obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                if i%wait == n then
                    P.knife.attack(obj.x, obj.y, a, obj.u)
                end
                task.Wait(1)
            end
            _del(obj, true)
        end)
    end

    local function changeStyle2(obj)
        New(boom_effect, obj.x, obj.y)
        enemy.change_style(obj, sty.FAIRY_SAKUYA)
        task.New(obj, function()
            task.Wait(90)
            S.aimToPlayer.main(obj)
            task.Wait(60)
            _del(obj, true)
        end)
    end
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

    --用来攻击动物灵的箭
    B.perform_arrow = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local function create(x, y, target)
                    local r, angle = target.radius, target.angle
                    local x1, y1 =  target.center_x + r*cos(angle), target.center_y + r*sin(angle)
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED, true)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    local a = Angle(x, y, x1, y1)
                    obj.rot = a
                    obj.navi = true
                    B.light.create(obj, x, y, a)
                    task.New(obj, function()
                        task.MoveTo(obj, x1, y1, 30, MOVE_NORMAL)
                        --命中后目标变身
                        changeStyle(target)
                        --销毁自己
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --用来攻击动物灵的箭2
    B.perform_arrow2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local function create(x, y, target, dx, dy)
                    local x1, y1 =  target.x + dx, target.y + dy
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED, true)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    local a = Angle(x, y, x1, y1)
                    obj.rot = a
                    obj.navi = true
                    B.light.create(obj, x, y, a)
                    task.New(obj, function()
                        task.MoveTo(obj, x1, y1, 30, MOVE_NORMAL)
                        --命中后目标变身
                        changeStyle2(target)
                        --销毁自己
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --受时停影响的刀子
    B.knife = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a)
                    local obj = stg.newSimpleBullet(x - 60*cos(a), y - 60*sin(a), stg.knife, COLOR_BLUE, true)
                    accDecMoveToPointTask(obj, x, y, 15, 0, 15)
                    obj.v = v
                    obj.rot = a
                    obj.change = false --受时停变化
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    setSize(obj, 3, 3)
                    obj.colli = false
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.colli = true
                    end)
                    table.insert(knife_list, obj)
                end
                return create
            end
    )

    --受时停影响的刀子2
    B.knife2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a, co)
                    local obj = stg.newBullet(x, y, stg.knife, co or COLOR_RED, true)
                    obj.v = v
                    obj.rot = a
                    setV(obj, v, a)
                    obj.change = true --受时停变化
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    table.insert(knife_list, obj)
                end
                return create
            end
    )

    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, x, y, a)
                    local obj = New(bent_laser_effection, light_red_tex, x, y, a,
                            60, 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x + 5*cos(mst.rot), mst.y + 5*sin(mst.rot)
                            task.Wait(1)
                        end
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.pointer_demo = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --一波刀子
    P.knife = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 1*defaultSwitchVelocityByRank(rank)
                local layer = switch(rank, {
                    2, 2, 2, 2, 3
                })
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local da = 2
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    B.knife.create(x, y, v, a)
                end
                local function attack(x, y, a, u)
                    PlaySound("tan00")
                    --正后方发射3way高速刀子
                    sect_normal1(x, y, 1, a + 180,
                            3, 45, --way, da,
                            bullet_func)
                    --正前方发射3条刀子
                    curve_normalDv1(x, y, v, a, layer, dv, da*u, bullet_func)
                end
                return attack
            end
    )

    --高速散枪
    P.spread = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch(rank, {
                    5, 5, 5, 5, 5
                })
                local da = 7.5
                local v = 8*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_GREEN
                local function bullet_func(x, y, v, a)
                    B.knife2.create(x, y, v, a, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a,
                                        way, da, --way, da,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    E.rabbit = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, r, a, u)
                    local x1, y1 = x + r*cos(a), y + r*sin(a)
                    local obj = New(enemy, x1 + 100*u, y1, sty.RABBIT_YELLOW, --style
                            9999, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    _connect(_boss, obj, 0, true)
                    obj.colli = false
                    obj.center_x, obj.center_y = x, y
                    obj.radius, obj.angle = r, a
                    obj.u = u
                    setSizeAndColli(obj, 0.01, 0.01)
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 0.99, 30, 120)
                        --跑
                        local c = 2
                        local dx, dy = (x1 - obj.x)/c, (y1 - obj.y)/c
                        for _ = 0, c - 1 do
                            accDecMoveToPoint(obj, obj.x + dx, obj.y + dy, 10, 0, 10)
                        end
                    end)
                    return obj
                end
                return create
            end
    )

    --自机狙
    E.rabbit2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, dx, dy, a)
                    local obj = New(enemy, x, y, sty.RABBIT_YELLOW, --style
                            9999, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    obj.angle = a
                    _connect(_boss, obj, 0, true)
                    obj.colli = false
                    setSizeAndColli(obj, 0.01, 0.01)
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 0.99, 30, 120)
                        --跑
                        local c = 2
                        dx, dy = dx/c, dy/c
                        for _ = 0, c - 1 do
                            accDecMoveToPoint(obj, obj.x + dx, obj.y + dy, 10, 0, 10)
                        end
                    end)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region shooter 敌机发弹逻辑
    S.aimToPlayer = EISlib.Bullet.Shooter.createShooter(
            function (diff, rank)
                --case：初始攻击等待
                local start_time_left = 0
                --case：持续攻击时间
                local total_time = _infinite
                local v0 = 4*defaultSwitchVelocityByRank(rank)
                local count = 10
                local way = switch(rank, {
                    2, 2, 2, 2, 4
                })
                local dr = 10
                local function shooter(e)
                    enemy.createShooter(e,
                            start_time_left, total_time, --start_time_left total_time
                            function()
                                local w = (way - 1)/2
                                local u = sign(e.x)
                                local dx, dy, x, y, a
                                local x0, y0 = player.x, player.y
                                for i = 0, count - 1 do
                                    a = Angle(e, player)
                                    dx, dy = -sin(a), cos(a)
                                    for j = -w, w do
                                        x, y = e.x + dr*j*dx, e.y + dr*j*dy
                                        B.knife2.create(x, y, v0, Angle(x, y, x0, y0))
                                    end
                                    P.spread.attack(e.x, e.y, e.angle + 4*(i%2)*u)
                                    PlaySound("tan00")
                                    task.Wait(6)
                                end
                            end
                    )
                end
                return shooter
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.changeAllKnifeRot = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --飞刀是否变向的分界半径
                local r = switch(rank, {
                    80, 80, 80, 80, 60
                })
                --飞刀变向对自机的偏角
                local da = 30
                --自机反色环的半径
                local r_circle = r*sin(da)
                local function main(wait)
                    --时停特效
                    New(invert_color_circle, _boss.x, _boss.y, r_circle, wait - 20)
                    local w = math.floor(wait/6)
                    for i = 0, 5 do
                        for j, knife in pairs(knife_list) do
                            if j%6 == i then
                                if IsValid(knife) and knife.change and Dist(knife, player) > r then
                                    knife.rot = Angle(knife, player) + da*ran:Sign() --r_circle = r*sin(da)
                                    stg.setBulletStyle(knife, stg.knife, COLOR_GREEN)
                                    knife.v = knife.v + ran:Float(1.5, 2)
                                    knife.change = true
                                end
                            end
                        end
                        task.Wait(w)
                    end
                    task.Wait(wait%6)
                end
                return main
            end)

    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = 90
                local function main(b, y, u)
                    y = max(250, y)
                    local enemy_list = {}
                    local enemy_list2 = {}
                    for i = 0, 5 do
                        table.insert(enemy_list, E.rabbit.create(0, y, 400 - 50*i, -90 - 30*u*tranU(i), u*tranU(i))) --x, y, r, a, u
                        task.Wait(5)
                    end
                    --另外四只使魔兔
                    local pos_list = {
                        {-150, -50}, {-50, -50}, {50, -50}, {150, -50}
                    }
                    local angle_list = {
                        -90, -90 - 20, -90 + 20, -90
                    }
                    for i = 1, 4 do
                        table.insert(enemy_list2, E.rabbit2.create(b.x, b.y, pos_list[i][1], pos_list[i][2], angle_list[i]))
                    end
                    --用箭攻击
                    task.Wait(10)
                    for i = 0, 5 do
                        B.perform_arrow.create(b.x, b.y, enemy_list[i+1])
                        task.Wait(5)
                    end
                    for i = 1, 4 do
                        B.perform_arrow2.create(b.x, b.y, enemy_list2[i], pos_list[i][1], pos_list[i][2])
                    end
                    task.Wait(20)
                    --时停
                    stopAllKnifeAndChangeRot()
                    --改变飞刀方向（时停特效由以下task生成）
                    T.changeAllKnifeRot.main(wait)
                    --时停结束
                    resumeAllKnife()
                    task.Wait(60)
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

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) then
            Del(bg)
        end
        New(stage7_background, true)
    end
    
    local card = EGGlib.BossCard.createFullCard(
            "name-boss3-card7", --非/符卡名
            "timespell", --类型
            {23, 23, 23}, --时间
            1800, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                robject.set_color(b, "", 100, 255, 255, 255)
                b.colli = false
                local y = 400
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, y, u)
                        y = y - 50
                    end
                end
            end,
            function(b) --finish
                if system.isDoubleGetSpellCardBonus(b) and b.is_get_double_sc_bonus_list then
                    b.is_get_double_sc_bonus_list[3] = true
                    if b.is_get_double_sc_bonus_list[1] and b.is_get_double_sc_bonus_list[2] and b.is_get_double_sc_bonus_list[3] then
                        achievement.unlock("ex_mid", true, true) -- AchievementReminder.unlock("ex_mid", "对盗版重拳出击", "在单次Extra模式中，成功双倍收取三张道中符卡")
                    end
                end
                item.PlayerBomb.create(b.x, b.y)
                --player.class.recoveredSpeed(player)
                b._a = 255
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
