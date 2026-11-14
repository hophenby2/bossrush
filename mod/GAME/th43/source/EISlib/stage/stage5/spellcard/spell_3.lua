-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local fog_img = boss_name.."fog"
local wolf_eff_purple_ani = boss_name.."wolf_eff_purple_ani"
local wolf_eff_red_ani = boss_name.."wolf_eff_red_ani"
local warning_laser = EISlib.Bullet.Laser.warning_laser
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local polygon3 = EGGlib.BulletGroup.polygon3

local fog = Class(object)
function fog:init(x, y)
    self.x, self.y = x, y
    self.layer = LAYER_ENEMY_BULLET + 10
    self.hscale, self.vscale = 0.6, 0.6
    self.rot = ran:Float(0, 360)
    self.omiga = 0.1*ran:Sign()
    self.img = fog_img
    self.group = GROUP_INDES
    self.colli = false
    robject.set_color(self, "", 0, 0, 255, 0)
end
function fog:frame()
    if self.status == "normal" then
        task.Do(self)
    end
end
function fog:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

--狼头特效
local wolf_eff = Class(object)
function wolf_eff:init(boss, time)
    self.group = GROUP_INDES
    self.img = wolf_eff_purple_ani
    self.colli = false
    robject.set_color(self, "", 255, 255, 255, 255)
    self.boss = boss
    self.x, self.y = boss.x, boss.y
    self.rot = Anlge(0, 0, boss.dx, boss.dy)
    self.layer = LAYER_ENEMY + 1
    self.hscale, self.vscale = 1, 1
    self.live_time = time
end
function wolf_eff:frame()
    if self.timer <= self.live_time and IsValid(self.boss) then
        self.x, self.y = self.boss.x, self.boss.y
        self.rot = Angle(0, 0, boss.dx, boss.dy)
    else
        self.status = "del"
    end
end
function wolf_eff:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
--搞成函数调用看起来更好看
local function showWolfEffect(boss, time)
    New(wolf_eff, boss, time)
end

local fires = {} --会变成火弹的弹幕
--清空火弹表
local function clearFires()
    fires = {}
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x0, y0, x1, y1, t)
                    local a = Angle(x0, y0, x1, y1)
                    local d = Dist(x0, y0, x1, y1)
                    local obj = New(warning_laser,
                            x0, y0,
                            d, 10, 10, 5, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            t --disappear
                    )
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )

    B.fog = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local count = switch1(diff, {
                    4, 5, no_info, no_info, no_info
                })
                local wait = 80/count
                local da0 = 180/(count - 1)
                local v = switch1(diff, {
                    3, 3, 1.5, 1.5, 1.5
                })
                --产生点弹的way数
                local way = switch1(diff, {
                    8, 12, 4, 4, 4
                })
                local da = 360/way
                --衍生点弹弹速
                local v0 = switch1(diff, {
                    1.25, 1.5, 0.1, 0.1, 0.1
                })*defaultSwitchVelocityByRank(rank)
                local create
                if diff < 3 then --EN
                    function create(x, y, a, dt)
                        local obj = New(fog, x, y)
                        obj.bound = false
                        alphaChangeTask(obj, 0, 120, 90)
                        task.New(obj, function()
                            task.New(obj, function()
                                task.Wait(80)
                                local a = Angle(obj, player)
                                local count = (count - 1)/2
                                for i = -count, count do
                                    P.pointer2.attack(obj.x, obj.y, a + da0*i)
                                    task.Wait(wait)
                                end
                            end)
                            velch(obj, v, 0.25, a, 80)
                            task.Wait(dt)
                            --生成绿点弹
                            local a0, a, r = ran:Float(0, 360)
                            for i = 0, way - 1 do
                                a = a0 + da*i
                                r = ran:Float(20, 30)
                                B.bullet1.create(obj.x + r*cos(a), obj.y + r*sin(a), v0 + ran:Float(-0.1, 0.1), a)
                            end
                            alphaAndSizeChange(obj, -95, 0.5, 30)
                            velch(obj, v, 0.75, a, 30)
                            alphaAndSizeChange(obj, -obj._a, 0.5, 120)
                            _del(obj, false)
                        end)
                    end
                else --HL
                    function create(x, y, a, dt)
                        local obj = New(fog, x, y)
                        robject.set_color(obj, "", 0, 200, 0, 200) --紫色的云
                        obj.bound = false
                        alphaChangeTask(obj, 0, 60, 90)
                        task.New(obj, function()
                            obj.layer = LAYER_BG + 50
                            velch(obj, v, 0.3, a, 80)
                            task.Wait(dt)
                            --生成红点弹
                            local a0, a, r, x, y = ran:Float(0, 360)
                            for i = 0, way - 1 do
                                a = a0 + da*i
                                r = ran:Float(20, 30)
                                x, y = obj.x + r*cos(a), obj.y + r*sin(a)
                                if Dist(x, y, player.x, player.y) > 80 then
                                    B.bullet1.create(x, y, v0 + ran:Float(-0.1, 0.1), a)
                                end
                            end
                            alphaAndSizeChange(obj, -obj._a, 0.5, 15)
                            _del(obj, false)
                        end)
                    end
                end
                return create
            end
    )

    --点弹
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --侦测范围
                local range = switch1(diff, {
                    120, 120, 80, 80, 80
                })
                local color = switch1(diff, {
                    COLOR_DEEP_GREEN, COLOR_DEEP_GREEN, COLOR_DEEP_GREEN, COLOR_DEEP_GREEN, COLOR_DEEP_GREEN
                })
                local create
                if diff < 3 then -- EN
                    function create(x, y, v, a)
                        local obj = stg.newSimpleBullet(x, y, stg.ball_small, color)
                        velchTask(obj, v + 1, v, a, 30)
                        task.New(obj, function()
                            while Dist(obj, player) > range do
                                task.Wait(1)
                            end
                            P.pointer1.attack(obj.x, obj.y, a)
                            _del(obj)
                        end)
                    end
                else --HL
                    function create(x, y, v, a)
                        local obj = stg.newSimpleBullet(x, y, stg.ball_small, color)
                        obj.release = false
                        table.insert(fires, obj)
                        velchTask(obj, v + 1, v, a, 30)
                        task.New(obj, function()
                            local flag = false
                            while not obj.release  do
                                if Dist(obj, player) < range then
                                    flag = true
                                    break
                                end
                                task.Wait(1)
                            end
                            --防止屏幕外的弹幕进来偷袭
                            if obj.x > -192 and obj.x < 192 and obj.y > -224 and obj.y < 224 then
                                P.pointer1.attack(obj.x, obj.y, Angle(obj, player), flag)
                            end
                            _del(obj)
                        end)
                    end
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --点弹衍生弹幕
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    1, 3, 2, 3, 3
                })
                local v = switch1(diff, {
                    0.3, 0.3, 2.5, 3, 3
                })*defaultSwitchVelocityByRank(rank)
                local vmax = switch1(diff, {
                    1.5, 2, 0, 0, 0
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_DEEP_PURPLE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v, vmax, a, 120, 180, style, color)
                end
                local attack
                if diff < 3 then --EN
                    function attack(x, y, a)
                        PlaySound("kira00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v, a, way, --x, y, v, a, way
                                            1, 0, 0, 0, --layer, dv, da, dway
                                            bullet_func
                                    )
                                end)
                    end
                else --HL
                    local da = 300/way
                    local style, color = stg.arrow_small, COLOR_DEEP_PURPLE
                    function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, 0.25, v, a, 60, 30, style, color)
                    end
                    function attack(x, y, a, flag)
                        PlaySound("kira00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    if not flag then
                                        stg.newSimpleStrChV(x, y, 0.25, v, a, 30, 30, style, color)
                                    end
                                    local w = (way - 1)/2
                                    for i = -w, w do
                                        stg.newSimpleStrChV(x, y, 0.25, 2*v, a + 180 + da*i, 30, 0, style, COLOR_PURPLE)
                                    end
                                end)
                    end
                end
                return attack
            end
    )

    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case:way数
                local way = switch1(diff, {
                    1, 3, 20, 20, 20
                })
                --
                --case：初始弹速
                local v = switch1(diff, {
                    1.4, 1.6, 1.5, 1.5, 1.3
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_small, COLOR_YELLOW
                --单个子弹
                local function bullet_func(x, y, v, a)
                    --有弹雾的
                    return stg.newStrChV(x, y, 0.25, v, a, 60, 20, style, color)
                end
                local attack
                if diff < 3 then --EN
                    function attack(x, y, a)
                        PlaySound("kira00")
                        polygon3(x + 10*cos(a), y + 10*sin(a), 0, --x, y, dsc,
                                v, 0.025, a, 0, --v, dvc, a, rot
                                way, bullet_func --n, singleBulletFunc
                        )
                    end
                else --HL
                    local da = 180/way
                    local layer = switch1(diff, {
                        no_info, no_info, 2, 3, 3
                    }) + switch(rank, {
                        0, 0, 0, 0, 1
                    })
                    local dv = switch1(diff, {
                        no_info, no_info, 0.5, 0.3, 0.4
                    })*defaultSwitchVelocityByRank(rank)
                    local function bullet_func1(x, y, v, a)
                        polygon3(x + 10*cos(a), y + 10*sin(a), 0, --x, y, dsc,
                                v, 0.025, a, 0, --v, dvc, a, rot
                                3, bullet_func --n, singleBulletFunc
                        )
                    end

                    function attack(x, y, a)
                        PlaySound("kira00")
                        circle_layer1(x, y, v, a, way, --x, y, v, a, way
                                layer, dv, da, 0, --layer, dv, da, dway
                                bullet_func1
                        )
                    end
                end
                return attack
            end
    )


    --pointer2的强化
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case:way数
                local way = switch1(diff, {
                    1, 3, 24, 24, 24
                })
                --
                --case：初始弹速
                local v = switch1(diff, {
                    1.4, 1.6, 1.5, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_small, COLOR_YELLOW
                --单个子弹
                local function bullet_func(x, y, v, a)
                    --有弹雾的
                    return stg.newStrChV(x, y, 0.25, v, a, 60, 0, style, color)
                end
                local attack
                if diff < 3 then --EN
                    function attack(x, y, a)
                        PlaySound("kira00")
                        polygon3(x + 10*cos(a), y + 10*sin(a), 0, --x, y, dsc,
                                v, 0.025, a, 0, --v, dvc, a, rot
                                way, bullet_func --n, singleBulletFunc
                        )
                    end
                else --HL
                    local da = 120/way
                    local layer = switch1(diff, {
                        no_info, no_info, 4, 6, 6
                    }) + switch(rank, {
                        0, 0, 0, 0, 2
                    })
                    local dv = switch1(diff, {
                        no_info, no_info, 0.25, 0.2, 0.2
                    })*defaultSwitchVelocityByRank(rank)
                    local function bullet_func1(x, y, v, a)
                        polygon3(x + 10*cos(a), y + 10*sin(a), 0, --x, y, dsc,
                                v, 0.025, a, 0, --v, dvc, a, rot
                                3, bullet_func --n, singleBulletFunc
                        )
                    end

                    function attack(x, y, a, u)
                        PlaySound("kira00")
                        circle_layer1(x, y, v, a, way, --x, y, v, a, way
                                layer, dv, da*u, 0, --layer, dv, da, dway
                                bullet_func1
                        )
                    end
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = switch1(diff, {
                    8, 8, 6, 8, 8
                })
                local da = 180/(way - 1)
                local wait = 30/way
                local main
                if diff < 3 then --EN
                    function main(b, x, y, a, u, dt)
                        local way = (way - 1)/2
                        boss.createTasker(b, x, y,
                                function(obj)
                                    obj.bound = false
                                    task.New(obj, function()
                                        for i = -way, way do
                                            B.fog.create(x, y, a + da*i*u, dt)
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                else --HL
                    function main(b, x, y, a, dt)
                        boss.createTasker(b, x, y,
                                function(obj)
                                    obj.bound = false
                                    task.New(obj, function()
                                        for i = 0, way - 1 do
                                            for u = -1, 1, 2 do
                                                B.fog.create(b.x, b.y, a + 90*u, dt)
                                            end
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                end
                return main
            end)

    T.warning_creator = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch(rank, {
                    10, 10, 10, 10, 0
                })
                local function main(x, y, count, xmax, ymax, y0, dy, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 2 do
                                        y0 = y0 + dy
                                        B.warning_laser.create(obj.x, obj.y, xmax*u, y0, 120 - 30*(count - 1 - i) + (i+1)*wait)
                                        task.MoveTo(obj, xmax*u, y0, 10, MOVE_ACC_DEC)
                                        u = -u
                                    end
                                    B.warning_laser.create(obj.x, obj.y, xmax*u, y0, 90 + count*wait)
                                    task.MoveTo(obj, xmax*u, y0, 10, MOVE_ACC_DEC)
                                    B.warning_laser.create(obj.x, obj.y, 0, ymax, 120 + (count+1)*wait)
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
                local count = switch1(diff, {
                    2, 3, 4, 4, 4
                })
                local count_max = switch1(diff, {
                    4, 5, 0, 0, 0
                })
                local d_dy = switch1(diff, {
                    -60, -60, -60, -60, -60
                })
                local wait = switch(rank, {
                    10, 10, 10, 10, 0
                })

                local wait_EN = switch(rank, {
                    60, 60, 60, 60, 0
                })
                local main
                if diff < 3 then --EN
                    function main(b, dcount, u)
                        local count = min(count_max, count + dcount  + switch(rank, {
                            0, 0, 0, 0, 1
                        }))
                        local dy = 0
                        for i = 0, count - 1 do
                            T.tasker1.main(b, 0, 350 + dy, -90, u*tranU(i), 40*(count - 1 - i))
                            dy = dy + d_dy
                            task.Wait(20)
                        end
                        task.Wait(120 + wait_EN)
                    end
                else --HL
                    local xmax, ymin, ymax = 150, -180, 192
                    local dt0 = 30 --所有雾解除的基础时间
                    function main(b, dcount, u)
                        local y0 = ymax
                        local dy = (ymin - ymax)/(count - 1)
                        T.warning_creator.main(b.x, b.y, count, xmax, ymax, y0, dy, u)
                        task.Wait(20)
                        for i = 0, count - 2 do
                            y0 = y0 + dy
                            T.tasker1.main(b, b.x, b.y, Angle(b.x, b.y, xmax*u, y0), dt0 + 30*(count - 1 - i))
                            task.MoveTo(b, xmax*u, y0, 30, MOVE_ACC_DEC)
                            P.pointer2.attack(b.x, b.y, Angle(b, player))
                            u = -u
                            task.Wait(wait)
                        end
                        T.tasker1.main(b, b.x, b.y, 90*(1 + u), dt0 + 40)
                        task.MoveTo(b, xmax*u, y0, 30, MOVE_ACC_DEC)
                        task.Wait(wait)
                        P.pointer2.attack(b.x, b.y, Angle(b, player))
                        T.tasker1.main(b, b.x, b.y, 90, dt0)
                        task.MoveTo(b, 0, ymax, 30, MOVE_ACC_DEC)
                        task.Wait(30 + wait)
                        P.pointer3.attack(b.x, b.y, Angle(b, player), u) --比平时还要强一波
                        task.Wait(30)
                        b.absorbEffect(b, 60, b.x, b.y)
                        b.breakEffect(b, 0, b.x, b.y)
                        local r, dr = 0, 600/60
                        for _ = 1, 60 do
                            r = r + dr
                            sp.UnitListUpdate(fires) --先把无效对象剔除
                            --让范围弹幕被释放
                            for _, obj in pairs(fires) do
                                if not obj.release and r > Dist(obj.x, obj.y, b.x, b.y) then
                                    PlaySound("kira00")
                                    obj.release = true
                                end
                            end
                            task.Wait(1)
                        end
                        task.Wait(60)
                        task.MoveTo(b, -xmax*u, ymax, 30, MOVE_ACC_DEC)
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
    
    local hp_list = {2400, 2400, 1800, 1800, 1800}
    local names = {
        "name-boss7-card4-E",
        "name-boss7-card4-N",
        "name-boss7-card4-H",
        "name-boss7-card4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
            hp_list[difficulty], --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                PlaySound("wolf")
            end,
            function(b) --练习模式攻击前动作
                if difficulty < 3 then
                    b.x, b.y = 0, 144
                else
                    b.x, b.y = 0, 144
                end
                boss.show_aura(b, true)
                PlaySound("wolf")
            end,
            function(b) --main
                clearFires()
                if difficulty > 2 then --HL
                    task.MoveTo(b, 150, 192, 60, MOVE_ACC_DEC)
                end
                local n = 0
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, n, u)
                        n = n + 1
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
