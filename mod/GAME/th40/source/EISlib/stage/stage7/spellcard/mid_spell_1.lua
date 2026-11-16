-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/mid_spell_1.lua" --当前存放目录
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
local boss_name = "Artemina"  --以boss名来作为其相关素材的前缀
local light_red_tex = boss_name.."_light_red"
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local warning_laser = EISlib.Bullet.Laser.warning_laser
local LS = EISlib.Bullet.Laser.laser
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local sty = EISlib.Enemy.Style
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local addV1 = EGGlib.ObjectEvent.addV1
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_normal2 = EGGlib.BulletGroup.Sector.normal2
local setSize = EGGlib.ObjectEvent.setSize
local Bclass = EISlib.BossDefinition.Artemina
local accDecMoveToPointTask = EGGlib.ObjectEvent.accDecMoveToPointTask
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local boundWait = EGGlib.ObjectEvent.boundWait
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local aimToPoint = EGGlib.ObjectEvent.aimToPoint
local boom_effect = Bclass.boom_effect

local bgch = Class(object)
function bgch:init()
    self.x, self.y = 0, 0
    setSize(self, 2, 2)
    self.img = Bclass.bgch_img_list[1]
    self.layer = LAYER_TOP
    robject.set_color(self, "", 255, 255, 255, 255)
end
function bgch:frame()
    if self.timer < 36 then
        self.img = Bclass.bgch_img_list[1 + math.floor(self.timer/4)]
    else
        self.status = "del"
    end
    task.Do(self)
end
function bgch:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --敌人变身
    local function changeStyle(obj)
        local v = 2
        local da = 40
        local a = -90 + da*obj.u
        local vy = v*sin(a) - v*cos(a)*tan(a - 90*obj.u)
        New(boom_effect, obj.x, obj.y)
        enemy.change_style(obj, sty.FAIRY_REIMU)
        task.New(obj, function()
            obj.layer = LAYER_TOP --可以适当把图层拉高点
            velch(obj, 0, vy, 90, 30)
            S.square.main(obj, v, da, obj.u)
        end)
    end
    --region Bullet 自定义子弹
    --用来攻击动物灵的箭
    B.perform_arrow = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local v = 20*defaultSwitchVelocityByRank(rank)
                local function create(x, y, target, a)
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED, true)
                    setSizeAndColli(obj, 1.5, 1.5)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    obj.navi = true
                    obj.a = 6
                    obj.rect = true
                    B.light.create(obj, x, y, a)
                    boundWait(obj, 180)
                    task.New(obj, function()
                        velch(obj, 15, 0, a, 30)
                        if IsValid(target) then
                            movePointWithPar(obj, target.x, target.y, 2, 15, target.u)
                            --命中后目标变身
                            changeStyle(target)
                            --销毁自己
                            _del(obj, false)
                        end
                    end)
                end
                return create
            end
    )

    --假装要攻击玩家的箭
    B.perform_arrow2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local xmin = switch(rank, {
                    60, 60, 60, 60, 50
                })
                --case：初速度
                local function create(x, y, a)
                    PlaySound("tan00")
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED, true)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    obj.navi = true
                    B.light.create(obj, x, y, a)
                    boundWait(obj, 180)
                    task.New(obj, function()
                        obj.a = 6
                        obj.rect = true
                        velch(obj, 10, 0.01, a, 30)
                        if player.y > 0 then --你跑太高我就直接打你了
                            aimToTarget(obj, player, 20, 30, 0.25)
                            --aimToPoint(obj, player.x, player.y + ran:Float(-30, 30), 20, 30, 0.25)
                        else
                            aimToPoint(obj, ran:Float(xmin, 192)*ran:Sign(), -192, 20, 30, 0.25)
                        end
                        --aimToPoint(obj, player.x, player.y, 20, 30, 0.25) --超级厉害的跟踪弹
                    end)
                end
                return create
            end
    )

    --用来攻击玩家的箭
    B.arrow = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local function create(x, y, v, a0, da)
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED)
                    obj.hide = true
                    obj.colli = false
                    B.warning_laser.create(x, y, a0, da)
                    setSizeAndColli(obj, 1.5, 1.5)
                    task.New(obj, function()
                        task.Wait(40)
                        PlaySound("lazer01")
                        obj.hide = false
                        obj.colli = true
                        obj.a = 6
                        obj.rect = true
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        local a = a0 + da
                        obj.rot = a
                        B.light.create(obj, x, y, a, 24)
                        SetV(obj, v, a)
                        task.New(obj, function()
                            for i = 1, 60 do
                                robject.set_color(stg.newSimpleStrChV(obj.x, obj.y, 0, v - 0.2*i, a, 60, 0, stg.arrow_mid, COLOR_DEEP_RED), "mul+add", 255, 255, 255, 255)
                                task.Wait(1)
                            end
                        end)
                    end)
                end
                return create
            end
    )

    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a0, da)
                    local obj =  New(warning_laser, x, y,
                            600, 10, --len, l_t
                            3, 20, --wide, w_t
                            a0, "mul+add", Color(255, 255, 0, 0), 60)
                    PlaySound("lazer00")
                    task.New(obj, function()
                        local t = 30
                        local x0, dx = 0, 90/t
                        for _ = 1, t do
                            x0 = x0 + dx
                            LS.setRot(obj, a0 + da*sin(x0))
                            task.Wait(1)
                        end
                    end)
                end
                return create
            end
    )

    --箭拖尾
    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, x, y, a, w)
                    local obj = New(bent_laser_effection, light_red_tex, x, y, a,
                            60, w or 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x - 0*cos(mst.rot), mst.y - 0*sin(mst.rot)
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

    --由使魔小怪发射的札弹
    P.enemy_square = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --白札弹的额外弹速
                local vv = 2
                local style, color = stg.square, COLOR_DEEP_RED
                local function attack(x, y, v, da, u, index)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                --向正上和正下发札弹
                                stg.newSimpleStraight(x, y, v, 90, style, COLOR_YELLOW - 1)
                                --砌墙札弹
                                stg.newSimpleStraight(x, y, v, -90 + da*u, style, color)
                                --过马路札弹
                                if index%2 == 0 then
                                    local obj = stg.newSimpleStraight(x, y, v, -90 + da*u, stg.square, COLOR_GRAY)
                                    addV1(obj, vv, -90 + (90 + da)*u)
                                    obj.rot = -90 + (90 + da)*u
                                end
                            end)
                end
                return attack
            end
    )

    --多way弓箭
    P.arrow = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v0 = 20*defaultSwitchVelocityByRank(rank)
                local v1 = 24*defaultSwitchVelocityByRank(rank)
                local da = 10
                local style, color = stg.arrow_big, COLOR_RED
                local function attack(x, y, a)
                    local function bullet_func(x, y, v, da)
                        B.arrow.create(x, y, v, a, da)
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v0, 0, 20, da, --base
                                        1, 0, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                                sect_layer1(x, y, v1, 0, 21, da, --base
                                        1, 0, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )

    P.ball_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch(rank, {
                    24, 24, 24, 24, 36
                })
                local da = 180/way
                local v = 3*defaultSwitchVelocityByRank(rank)
                local layer = switch(rank, {
                    4, 4, 4, 4, 6
                })
                local dv = 1*defaultSwitchVelocityByRank(rank)
                local sp0 = 360
                local dsp = 0/(layer - 1)
                local style, color = stg.ball_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function bullet_func2(x, y, v, a, sp)
                    sect_normal2(x, y, v, a, way, sp, bullet_func)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    for i = 0, layer - 1 do
                        bullet_func2(x, y, v + dv*i, a + da, sp0 + dsp*i)
                    end
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    E.enemy = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, u)
                    local obj = New(enemy, x, y, sty.RABBIT_GREEN, --style
                            999, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    obj.bound = true
                    obj.u = u
                    obj.colli = false
                    --兔兔出现
                    setSizeAndColli(obj, 0.01, 0.01)
                    spSizeAndColliChangeTask(obj, 0.99, 60, 150)
                    _connect(_boss, obj, 0, true)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region shooter 敌机发弹逻辑
    S.square = EISlib.Bullet.Shooter.createShooter(
            function (diff, rank)
                --case：初始攻击等待
                local start_time_left = 0
                --case：持续攻击时间
                local total_time = _infinite
                local wait = switch(rank, {
                    7, 7, 7, 7, 5
                })
                local function shooter(e, v, da, u)
                    enemy.createShooter(e,
                            start_time_left, total_time, --start_time_left total_time
                            function()
                                for i = 0, _infinite do
                                    P.enemy_square.attack(e.x, e.y, v, da, u, i)
                                    task.Wait(wait)
                                end
                            end
                    )
                end
                return shooter
            end
    )
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u0)

                    local enemy_list = {}
                    for i = 0, 3 do
                        for u = -u0, u0, 2*u0 do
                            table.insert(enemy_list, E.enemy.create(-180*u, 0 + 60*i + 15*u0*u, u))
                        end
                        task.Wait(5)
                    end

                    P.ball_big.attack(b.x, b.y, 90)

                    --再给你随机搞点乱箭（不动就不会有事）
                    task.New(b, function()
                        for i = 1, 54 do
                            B.perform_arrow2.create(b.x, b.y, 90 - ran:Float(45, 90)*tranU(i))
                            task.Wait(3)
                        end
                    end)
                    local i = 1
                    for _ = 0, 3 do
                        for u = -u0, u0, 2*u0 do
                            B.perform_arrow.create(b.x, b.y, enemy_list[i], 90 - ran:Float(0, 30)*u)
                            i = i + 1
                            task.Wait(20)
                        end
                    end
                    task.Wait(180)
                    P.arrow.attack(0, 224, Angle(0, 224, player.x, player.y))
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

    --帅气的出场特效
    local function bossAction(b)
        b.x, b.y = 0, 300
        local way = 5
        for i = 0, way - 1 do
            PlaySound("ch00")
            if i == 0 then
                New(warning_laser, 0, 245,
                        484, 15, --len, l_t
                        30, 30, --wide, w_t
                        -90, "mul+add", Color(255, 255, 0, 0), 40)
            else
                for u = -1, 1, 2 do
                    New(warning_laser, 40*i*u, 224,
                            484, 15, --len, l_t
                            30, 30, --wide, w_t
                            -90, "mul+add", Color(255, 255, 0, 0), 40)
                end
            end
            task.Wait(5)
        end
        task.Wait(20)
        b.x, b.y = 0, 384
        effect.shakeScreen(30, 20)
        --生成红色幕布特效
        New(bgch)
        --向两侧横向扩展
        for u = -1, 1, 2 do
            local obj = New(bgch)
            obj.bound = false
            obj._blend = "mul+add"
            obj.x, obj.y = -50*u, 0
            obj.rot = 90
            obj.hscale = 2
            obj.vscale = 0.5*u
            local t = 18
            alphaChangeTask(obj, 255, 0, 18)
            accDecMoveToPointTask(obj, 192*u, 0, 1, 0, 35)
            task.New(obj, function()
                local ds = -obj.vscale/t
                for _ = 1, t do
                    obj.vscale = obj.vscale + ds
                    task.Wait(1)
                end
                _del(obj, false)
            end)
        end
        --自上而下快速刷过
        local obj = New(bgch)
        obj._blend = "mul+add"
        obj.bound = false
        obj.y = 224
        setSize(obj, 2, 0)
        local t = 20
        accDecMoveToPointTask(obj, 0, -600, 1, 34, 1)
        alphaChangeTask(obj, 255, 0, 36)
        task.New(obj, function()
            local ds = 1/t
            for _ = 1, t do
                obj.vscale = obj.vscale + ds
                task.Wait(1)
            end
            _del(obj, false)
        end)
        local bg = lstg.tmpvar.bg
        if IsValid(bg) then
            bg.class.changeToRed(bg)
        end
    end

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) then
            Del(bg)
        end
        lstg.tmpvar.bg = New(stage7_background, true)
    end
    
    local card = EGGlib.BossCard.createFullCard(
            "name-boss3-card5", --非/符卡名
            "spellcard", --类型
            {3, 3, 30}, --时间
            2000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                b.is_get_double_sc_bonus_list = {false, false, false} --初始化道中三张符卡收取表
                bossAction(b)
                system.PowerRank.pauseHyper()
                --瞬间出现，黑影+一脸杀气
                b.x, b.y = 0, 120
                robject.set_color(b, "", 255, 0, 0, 0)
                task.Wait(60)
                local t = 30
                local d = 255/t
                for _ = 1, t do
                    b._r, b._g, b._b = b._r + d, b._g + d, b._b + d
                    task.Wait(1)
                end
                system.record.unlockPerformer("Artemina") -- 确保正确解锁
                system.record.unlockPerformer("ArteminaEX") -- 仅作为标记
                -- 红眼病
                boss.setUInameDisplay(b, true) -- 啊，是熟人，还黑化了
                dialog.scene.stage7_mid()
                -- 开打
                system.PowerRank.resumeHyper() --从这里计时
                boss.show_aura(b, true)
                task.wait(60)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 120
                boss.show_aura(b, true)
                bgChangePr()
            end,
            function(b) --main
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                if system.isDoubleGetSpellCardBonus(b) and b.is_get_double_sc_bonus_list then
                    b.is_get_double_sc_bonus_list[1] = true
                end
                if not b.spell_timeout then
                    item.PlayerBomb.create(b.x, b.y)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
