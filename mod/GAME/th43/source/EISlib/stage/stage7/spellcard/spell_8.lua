-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_8.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local setSize = EGGlib.ObjectEvent.setSize
local moveWithTask = EGGlib.ObjectEvent.moveWithTask
local accDecVelChange = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local sty = EISlib.Enemy.Style
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect

local mask = Class(object)
function mask:init()
    self.x, self.y = 0, 0
    self.layer = LAYER_BG+1
    self.img = "white"
    self.hscale, self.vscale = 60, 70
    robject.set_color(self, "", 0, 50, 0, 0)
    task.New(self, function()
        local t = 60
        local d_a = 200/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
    end)
end
function mask:frame()
    task.Do(self)
end
function mask:render()
    defaultRenderImg(self)
end
function mask:close()
    task.New(self, function()
        local t = 60
        local d_a = -self._a/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
        Del(self)
    end)
end


local sizeChangeAlwaysTask = function(obj, s, s_range, phase0, t)
    local c = {} --controller
    s_range = 0.5*s_range
    task.New(obj, function()
        c.s, c.ds = 0, s/t
        c.phase, c.dphase = phase0, 5
        local SIN
        for _ = 1, t do
            c.s = c.s + c.ds
            c.phase = c.phase + c.dphase
            SIN = sin(c.phase)
            obj.hscale, obj.vscale = c.s + s_range*SIN, c.s + s_range*SIN
            task.Wait(1)
        end
        for _ = 1, _infinite do
            c.phase = c.phase + c.dphase
            SIN = sin(c.phase)
            obj.hscale, obj.vscale = c.s + s_range*SIN, c.s + s_range*SIN
            task.Wait(1)
        end
    end)
    return c
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local cat_king --猫王控制者索引
    local mask_inst --遮障
    local performed_cat_list = {}
    --region Bullet 自定义子弹
    --猫王控制者
    B.cat_king_controller = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED, true)
                    obj.hide = true
                    obj.bound = false
                    obj.group = GROUP_ENEMY
                    obj.colli = false
                    obj.hp = 999999
                    cat_king = obj
                end
                return create
            end
    )

    --演出用的猫
    B.cat_performer = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local co_list = {COLOR_RED, COLOR_DEEP_RED}
                local da = 0.2
                local radius = 5 --单个猫头活动半径
                local function create(layer, a, u)
                    local color = co_list[ran:Int(1, #co_list)]
                    local r = ran:Float(450, 600)
                    local a0 = ran:Float(0, 360)
                    local obj = New(Bclass.servant2, cat_king.x + r*cos(a0), cat_king.y + r*sin(a0),
                            9999, false, system.DROP_NONE, --hp, show_hpbar, drop,
                            nil, color --death_func, color
                    )
                    obj.rot = ran:Float(0, 360)
                    obj.omiga = 3*ran:Sign()
                    obj.bound = false
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    obj.group = GROUP_GHOST
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY + 1 + 0.1*(10 - layer)
                        alphaChangeTask(obj, 0, 255, 90)
                        local t = 120
                        --B.cat_trail.create(obj, 120, color)
                        local dr = -r/t
                        local d_dr = 2*dr/t
                        dr = 0
                        local function move()
                            if IsValid(cat_king) then
                                dr = dr + d_dr
                                r = r + dr
                                a0 = a0 + da*u
                                obj.x, obj.y = cat_king.x + r*cos(a0), cat_king.y + r*sin(a0)
                            else
                                Del(obj)
                            end
                            task.Wait(1)
                        end
                        for _ = 1, t - 20 do
                            move()
                        end
                        --透明度变化消失
                        alphaChangeTask(obj, 255, 0, 20)
                        for _ = 1, 20 do
                            move()
                        end
                        --再变回来
                        setSize(obj, 0, 0)
                        obj._a = 255
                        obj.rot = ran:Float(0, 360)
                        obj.omiga = 0
                        sizeChangeAlwaysTask(obj, 1, 0.3, ran:Int(-90, 90), 20)
                        r = 25 + 20*layer
                        local x0, y0 = r*cos(a), r*sin(a)
                        if IsValid(cat_king) then
                            task.New(obj, function()
                                task.Wait(10)
                                --P.cat_appear.attack(obj.x, obj.y, a)
                            end)
                            task.MoveTo(obj, cat_king.x + x0, cat_king.y + y0, 20, MOVE_DECEL)
                        else
                            Del(obj)
                        end
                        --鬼畜抖动+跟随
                        local x, y, dx, dy, a0 = 0, 0
                        --当接收到释放信号，猫头爆裂形成血细胞
                        while not obj.release do
                            a0 = ran:Float(0, 360)
                            dx, dy = 0.5*cos(a0), 0.5*sin(a0)
                            --预移动，判断情况，限制范围
                            if Dist(0, 0, x + dx, y + dy) >= radius then
                                dx, dy = -dx, -dy
                            end
                            x, y = x + dx, y + dy
                            obj.x, obj.y = cat_king.x + x0 + x, cat_king.y + y0 + y
                            task.Wait(1)
                        end
                        task.clear(obj, true)
                        --变成血细胞
                        B.ceil.create(x0, y0, x, y, a, layer)
                        alphaAndSizeChange(obj, -255, 4, 20)
                        _del(obj, false)
                    end)
                    table.insert(performed_cat_list, obj)
                end
                return create
            end
    )

    --内脏
    B.ceil = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local radius = 5 --单个猫头活动半径
                local function create(dx0, dy0, x, y, a, layer)
                    local obj = stg.newSimpleBullet(cat_king.x + dx0, cat_king.y + dy0, stg.ball_mid, COLOR_RED, true)
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 100, 0, 0)
                    setSize(obj, 0, 0)
                    sizeChangeAlwaysTask(obj, 4.5, 1.5, ran:Int(-90, 90), 10)
                    --向外膨胀
                    task.New(obj, function()
                        local t = 30
                        local dx, dy = cos(a), sin(a)
                        local v = 1*layer
                        local dv = -v/t
                        for _ = 1, t do
                            v = v + dv
                            dx0, dy0 = dx0 + v*dx, dy0 + v*dy
                            task.Wait(1)
                        end
                    end)
                    --鬼畜抖动+跟随
                    task.New(obj, function()
                        local dx, dy, a
                        while IsValid(cat_king) do
                            a = ran:Float(0, 360)
                            dx, dy = 0.5*cos(a), 0.5*sin(a)
                            --预移动，判断情况，限制范围
                            if Dist(0, 0, x + dx, y + dy) >= radius then
                                dx, dy = -dx, -dy
                            end
                            x, y = x + dx, y + dy
                            obj.x, obj.y = cat_king.x + dx0 + x, cat_king.y + dy0 + y
                            task.Wait(1)
                        end
                        Del(obj)
                    end)
                end
                return create
            end
    )

    --big eye
    B.big_eye = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create()
                    local obj = stg.newSimpleBullet(0, 224, stg.ball_huge, COLOR_RED, true)
                    obj.bound = false
                    --套娃
                    local mid_eye = B.eye.create(obj, 0)
                    task.New(mid_eye, function()
                        --有个邪恶的东西在盯着你.jpg
                        local a
                        while IsValid(obj) do
                            a = Angle(mid_eye, player)
                            mid_eye.x, mid_eye.y = obj.x + 20*cos(a), obj.y + 20*sin(a)
                            task.Wait(1)
                        end
                    end)
                    sizeChangeAlwaysTask(obj, 2, 0.2, 0, 30)
                    task.New(obj, function()
                        task.Wait(90)
                        while IsValid(mid_eye) do
                            P.big_eye.attack(mid_eye.x, mid_eye.y, Angle(mid_eye, player))
                            task.Wait(60)
                        end
                    end)
                    return obj
                end
                return create
            end
    )

    --eye
    B.eye = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, phase0)
                    local obj = stg.newSimpleBullet(mst.x, mst.y, stg.ball_big, COLOR_RED, true)
                    local eye_ball = B.eye_ball.create(obj)
                    sizeChangeAlwaysTask(obj, 1.5, 0.4, phase0, 30)
                    task.New(obj, function()
                        task.Wait(90 + ran:Int(0, 30))
                        while IsValid(eye_ball) and obj.y > -100 do
                            P.eye.attack(eye_ball.x, eye_ball.y, Angle(eye_ball, player) + ran:Float(-10, 10))
                            if system.PowerRank.getRank() == 4 then
                                task.Wait(60 + ran:Int(0, 15))
                            else
                                task.Wait(90 + ran:Int(0, 15))
                            end
                        end
                    end)
                    return obj
                end
                return create
            end
    )

    --眼珠子
    B.eye_ball = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst)
                    local obj = stg.newSimpleBullet(mst.x, mst.y, stg.ball_mid, COLOR_RED, true)
                    task.New(obj, function()
                        obj.layer = mst.layer + 0.00000001
                        local a
                        --有个邪恶的东西在盯着你.jpg
                        while IsValid(mst) do
                            obj.hscale, obj.vscale = mst.hscale, mst.vscale
                            a = Angle(obj, player)
                            obj.x, obj.y = mst.x + 7.5*cos(a), mst.y + 7.5*sin(a)
                            task.Wait(1)
                        end
                        _del(obj, false)
                    end)
                    return obj
                end
                return create
            end
    )

    --装饰用光玉粒子
    B.perform_ball_light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local sin_list = {}
                local t = 30
                local phase, dphase = 0, 120/t
                for i = 1, t do
                    phase = phase + dphase
                    sin_list[i] = sin(phase)
                end
                local t2 = 60
                local v0 = 1.5
                local wait = 16
                local function create(x, y, dv, a, i)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, COLOR_RED, true)
                    obj.colli_size_rate = obj.a/obj.hscale
                    setSize(obj, 0, 0)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    velchTask(obj, 0, v0 + dv, a, t)
                    task.New(obj, function()
                        --alphaAndSizeChange(obj, 255, 0, 30)
                        local s, ds = 0, 0.4*sin_list[t]/t
                        for i = 1, t do
                            s = s + ds
                            obj.hscale, obj.vscale = s*sin_list[i], s*sin_list[i]
                            obj.a, obj.b = obj.hscale*obj.colli_size_rate, obj.vscale*obj.colli_size_rate
                            task.Wait(1)
                        end
                        ds = -s/t2
                        for _ = 1, t2 do
                            s = s + ds
                            obj.hscale, obj.vscale = s, s
                            obj.a, obj.b = obj.hscale*obj.colli_size_rate, obj.vscale*obj.colli_size_rate
                            task.Wait(1)
                        end
                        if i % wait == 0 then
                            local b = stg.newSimpleBullet(obj.x, obj.y, stg.ball_mid, COLOR_RED)
                            setSizeAndColli(b, 0.01, 0.01)
                            b.vx, b.vy = obj.vx, obj.vy
                            sizeAndColliChangeTask(b, 0.99, 30)
                        end
                        _del(obj, false)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --从眼睛里发出来的自机狙
    P.eye = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v0 = 1.25*defaultSwitchVelocityByRank(rank)
                local v1 = 3.5*defaultSwitchVelocityByRank(rank)
                local way = 2
                local da = 90
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                stg.newSimpleStrChV(x, y, 0, v0, a, 30, 0, style, color)
                                sect_normal1(x, y, v1, a, way, da, bullet_func)
                            end)
                end
                return attack
            end
    )

    --中间大眼睛
    P.big_eye = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v0 = 5
                local v = 1.25*defaultSwitchVelocityByRank(rank)
                local way = switch(rank, {
                    10, 10, 10, 10, 16
                })
                local da = 160/way
                local style, color = stg.ball_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v0, v, a, 30, 40, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --eye
    E.eye = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, hp)
                    local obj = New(enemy, x, y, sty.FAIRY_LARGE_RED, --style
                            hp or 60, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            D.eye_death.main, --death_func 被打爆了就解除附属弹幕
                            false --type
                    )
                    obj.bound_protect = false
                    local dmg_rate = 1
                    if player.name and player.name == "marisa" then
                        dmg_rate = 0.3
                    end
                    obj.dmgrate = dmg_rate --针对不同机体的减伤机制
                    _connect(_boss, obj, 1, true)
                    obj.hide = true
                    obj.entity = B.eye.create(obj, ran:Float(0, 360))
                    moveWithTask(obj.entity, obj, 0, 0, _infinite)
                    return obj
                end
                return create
            end
    )
    --解除附属眼球弹幕
    D.eye_death = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(e)
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                local obj = e.entity
                                if IsValid(obj) then
                                    task.clear(obj)
                                    task.New(obj, function()
                                        spSizeAndColliChange(obj, -obj.hscale, 30, 120)
                                        _del(obj, false)
                                    end)
                                end
                            end)
                end
                return main
            end)
    --endregion
    --region Tasker 任务执行器
    --单个触手
    T.tentacle = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local rb_ra_rate = 0.75
                local da = 0.15
                local function main(ra, a, u)
                    local rb = ra*rb_ra_rate
                    boss.createTasker(_boss, cat_king.x + ra*cos(a), cat_king.y + rb*sin(a),
                            function(obj)
                                task.New(obj, function()
                                    local dv = ran:Float(-0.25, 0.25)
                                    local a_range, da0 = 5*ran:Sign(), 0
                                    local phase, dphase = ran:Float(0, 360), 3
                                    for i = 1, _infinite do
                                        phase = phase + dphase
                                        da0 = a_range*sin(phase)
                                        a = a + da*u
                                        obj.x, obj.y = cat_king.x + ra*cos(a), cat_king.y + rb*sin(a)
                                        if i%4 == 0 then
                                            B.perform_ball_light.create(obj.x + ra*cos(a + da0), obj.y + rb*sin(a + da0), dv, a, i)
                                        end
                                        task.Wait(1)
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
                local function main()
                    task.New(_boss, function()
                        B.big_eye.create()
                        task.Wait(10)
                        local eye_list = {}
                        local way, da, r
                        for i = 0, 3 do
                            way = 6 + i
                            da = (180 - 25*i)/(way - 1)
                            r = 150 + 60*i
                            way = (way - 1)/2
                            for j = -way, way do
                                local info = { x = 0 + 0.7*r*cos(-90 + da*j), y = 224 + 0.5*r*sin(-90 + da*j)}
                                info.inst = E.eye.create(info.x + 0*ran:Float(-10, 10), info.y + 0*ran:Float(-10, 10), 45)
                                table.insert(eye_list, info)
                                task.Wait(2)
                            end
                        end
                        task.Wait(60)
                        --一定时间间隔生成新的眼球，如果原来的眼球还存在， 则把它顶下去
                        local n, info, obj = #eye_list
                        while true do
                            info = eye_list[ran:Int(1, n)]
                            --原来的眼球脱落
                            obj = info.inst
                            if IsValid(obj) then
                                task.New(obj, function()
                                    obj.vx = ran:Float(-0.25, 0.25)
                                    velchTask(obj, 0, 3, -90, 30)
                                end)
                            end
                            --生成新的眼球
                            info.inst = E.eye.create(info.x + 0*ran:Float(-10, 10), info.y + 0*ran:Float(-10, 10), 90)
                            task.Wait(20)
                        end
                    end)
                end
                return main
            end)

    --触手生成器
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    task.New(_boss, function()
                        local u
                        for i = 1, _infinite do
                            u = tranU(i)
                            T.tentacle.main(ran:Int(125, 165), -90 - 45*u, u) --ra, a, u
                            task.Wait(60)
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

    local function bossAction(b)
        mask_inst = New(mask)
        --生成猫王
        B.cat_king_controller.create(b.x, b.y)
        local da, way
        local list = {}
        local num_list = {}
        local index, a0
        task.New(cat_king, function()
            effect.shakeScreen(360, 10)
            task.Wait(60)
            for _ = 1, 5 do
                New(AbsorbEffect2, cat_king.x, cat_king.y, 255, 100, 100, "mul+add")
                task.Wait(30)
            end
        end)
        tasker(function()
            PlaySound("gluttony01")
            task.Wait(180)
            PlaySound("gluttony01")
        end)
        for i = 0, 7 do
            a0 = ran:Float(0, 360)
            way = 6+4*i
            da = 360/way
            for j = 1, way do
                list[j] = j
            end
            for j = 1, #list do
                index = ran:Int(1, #list)
                num_list[j] = list[index]
                table.remove(list, index)
            end
            for j = 1, #num_list do
                B.cat_performer.create(i, a0 + da*num_list[j], 1, false)
                task.Wait(1)
            end
        end
        b.hide = true
        b.colli = false
        boss.show_aura(b, false)
        task.New(cat_king, function()
            task.Wait(80)
            effect.shakeScreen(120, 20)
            for _ = 1, 2 do
                New(AbsorbEffect2, cat_king.x, cat_king.y, 255, 100, 100, "mul+add")
                task.Wait(20)
            end
            PlaySound("explode") --这一团全炸了
            b.breakEffect(b, 0)
            task.New(cat_king, function()
                local r = 0
                for _ = 1, 60 do
                    r = r + 5
                    sp.UnitListUpdate(performed_cat_list)
                    for _, obj in pairs(performed_cat_list) do
                        if Dist(obj, cat_king) < r and not obj.release then
                            obj.release = true
                        end
                    end
                    task.Wait(1)
                end
            end)
            task.MoveTo(cat_king, 0, 300, 180, MOVE_ACC_DEC)
        end)
        task.Wait(150)
        b.hide = true
        b.colli = false
        --setNextCardNoScOpenEffect(b)
    end

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card8", --非/符卡名
            "extrafinal", --类型
            {3, 3, 60}, --时间
            4500, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                bossAction(b)
                PlaySound("gluttony02")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                bossAction(b)
                PlaySound("gluttony02")
            end,
            function(b) --main
                --播放音效
                task.New(b, function()
                    while true do
                        PlaySound("fire")
                        task.Wait(1800)
                    end
                end)
                reFresh()
                C.FIRST.main()
                C.SECOND.main()
            end,
            function(b) --finish
                --b.hide = false
                --b.colli = true
                if IsValid(mask_inst) then
                    mask.close(mask_inst)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
