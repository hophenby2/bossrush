-----------------------------------------
---东方栖霞园道中 Stage1
-----------------------------------------
---@class  EISlib.stage.stage1.road
--现在整个道中也是一个对象
local R = Class(object)
function R:init()
    self.timer = 0
    self.sence = 0 --道中第几段
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
    local res_name = "s1_"
    local path = "res/background/stage1/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
end

--导入其他包
local no_info = 0
local no_info_t = 9999
local velch = EGGlib.ObjectEvent.velocityChange
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local tri_circle3 = EGGlib.BulletGroup.TriAngleStroke.circle3
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1

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
end
--region Pointer Defined
--基础道中自机狙发射点
P.pointer1 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 1, 1, 1
            })
            if diff > 2 then
                way = way + switch(rank, {
                    0, 0, 0, 0, 2
                })
            end
            local da = switch1(diff, {
                no_info, no_info, 45, 45, 45
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                0, 1.5, 2, 2.5, 3
            }) + switch(rank, {
                0, 0.25, 0.5, 0.75, 1.5
            })
            --case：每层弹速差
            local dv = switch1(diff, {
                no_info, no_info, no_info, no_info, no_info
            })
            local style, color = stg.ball_mid, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                if diff >= 2 or rank == 4 then
                    PlaySound("tan00")
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
--单层扇形弹幕1
P.pointer2 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            --case:总way数
            local way_c = switch1(diff, {
                1, 1, 3, 3, 3
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da_c = 360/way_c
            --case：每way之间角度差
            local da = switch1(diff, {
                7.5, 7.5, 7.5, 7.5, 10
            }) --每way间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.5, 2, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.arrow_big, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, dv, a, way)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for i = 0, way_c - 1 do
                                sect_normal1(x, y, v0 + dv, a + da_c*i, way, da, --base
                                        bullet_func
                                )
                            end
                        end)
            end
            return attack
        end
)
--三角型描边弹幕
P.pointer3 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            --case：一侧边有多少个
            local bunch = switch1(diff, {
                1, 2, 3, 4, 4
            })
            --case:way数
            local way = switch1(diff, {
                3, 3, 3, 3, 3
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：每way之间角度差
            local da = switch1(diff, {
                1.5, 1.5, 1.5, 1.5, 1.5
            }) --每way间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.75, 2, 2.5, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：相邻弹幕速度差
            local dv0 = switch1(diff, {
                0.1, 0.1, 0.125, 0.15, 0.2
            })
            local style, color = stg.ball_mid_c, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            tri_circle3(x, y, v0 + dv0*(bunch - 1), -dv0, a, da, bunch, --base
                                    way, --way
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)
--向下的弹幕发射
P.pointer4 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 1, 1, 1
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 2, 2.5, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv0 = switch1(diff, {
                no_info, no_info, no_info, no_info, no_info
            })
            local style, color = stg.arrow_big, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, dv)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            circle_layer1(x, y, v0 + dv, -90, way, --base
                                    layer, dv0, 0, 0, --layer, dv_l, da_l, dway
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)
--单发单向鳞弹
P.pointer5 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 3, 5, 5
            })
            local da = 360/way
            --case：层数
            local layer = switch1(diff, {
                1, 2, 2, 2, 2
            })
            local hyper_rate = switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                1, 0.75, 0.875, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.arrow_big, COLOR_BLUE
            local function attack(x, y, _dv, a)
                local function bullet_func(x, y, i, a)
                    local w
                    for j = 0, layer - 1 do
                        w = j/2*hyper_rate
                        for k = -w, w do
                            stg.newSimpleStraight(x - k*10*sin(a), y + k*10*cos(a), v0 + _dv + dv*(1 - j), a, style, color)
                        end
                    end
                end
                if diff >= 2 or rank == 4 then
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, 0, a, way, da, --base
                                        1, 1, 0, --layer, dv_l, da_l
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
--基础道中自机狙发射器
S.shooter1 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                30, 25, 20, 15, 15
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                300, 300, 300, 300, 300
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                90, 60, 40, 30, 30
            })
            local function shooter(e, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer1.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--三角型弹幕发射器
S.shooter2 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 30
            --case：持续攻击时间
            local total_time = 240
            --case：攻击间隔
            local wait = switch1(diff, {
                60, 60, 60, 57, 60
            })
            --case：一次攻击打出的层数
            local layer = switch1(diff, {
                2, 3, 4, 5, 5
            })
            --case：初始way数
            local way0 = switch1(diff, {
                1, 1, 1, 1, 2
            }) - 1
            --case：每层速度差
            local dv = switch1(diff, {
                0.3, 0.3, 0.4, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            local function shooter(e)
                enemy.createShooter(e,
                        start_time_left, total_time, --start_time_left total_time
                        function()
                            local a, way
                            for i = 1, 3 do
                                a = Angle(e, player)
                                for i = 0, layer - 1 do
                                    way = layer - i
                                    P.pointer2.attack(e.x, e.y,
                                            dv*i, a, --dv, a
                                            way + way0) --way
                                    task.Wait(3)
                                end
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--三角型描边弹幕发射器
S.shooter3 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                80, 70, 60, 60, 60
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                300, 300, 300, 300, 300
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                16, 14, 12, 10, 8
            })
            --case：每次攻击的角度差
            local da = switch1(diff, {
                24, 24, 24, 24, 24
            })
            local function shooter(e, u, a)
                enemy.createShooter(e,
                        start_time_left, total_time, --start_time_left total_time
                        function()
                            local a = a or ran:Float(0, 360)
                            a = a + 90
                            local i = 0
                            while true do
                                P.pointer3.attack(e.x, e.y, a + da*i)
                                task.Wait(wait)
                                i = i + u
                            end
                        end
                )
            end
            return shooter
        end
)
--向下连续发弹幕
S.shooter4 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                0, 0, 0, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                40, 20, 20, 20, 20
            })
            --case：每次攻击的连发次数
            local count = switch1(diff, {
                1, 2, 3, 4, 5
            })
            --case：连发时每次攻击速度差
            local dv = switch1(diff, {
                0.2, 0.2, 0.2, 0.2, 0.2
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        0, total_time, --start_time_left total_time
                        function()
                            task.Wait(dt)
                            for i = 0, count - 1 do
                                P.pointer4.attack(e.x, e.y, dv*i)
                                task.Wait(2)
                            end
                            task.Wait(start_time_left)
                            while true do
                                for i = 0, count - 1 do
                                    P.pointer4.attack(e.x, e.y, dv*i)
                                    task.Wait(2)
                                end
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--往一个固定方向发射一颗子弹
S.shooter5 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
               30, 25, 20, 15, 0
            })
            --case：持续攻击时间(实际上只攻击一次）
            local total_time = switch1(diff, {
                120, 120, 120, 150, 150
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                65, 55, 45, 35, 90
            })
            --case：每次攻击的连发次数（U难度与前面的攻击方式不同）
            local count = switch1(diff, {
                1, 1, 1, 1, 4
            })
            --case：连发时每次攻击速度差
            local dv = switch1(diff, {
                no_info, no_info, no_info, no_info, 0.2
            })
            local function shooter(e, a, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                for i = 0, count - 1 do
                                    P.pointer5.attack(e.x, e.y, dv*i, a)
                                    task.Wait(2)
                                end
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--endregion

--region Enemy Defined
--最普通的自机狙杂鱼
E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_BLUE, --style
                        5, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1.main(obj) --给这个小怪装上发射器
                T.move1(obj)
            end
            return create
        end
)
--三角型弹幕中型妖精
E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, u)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        90, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                S.shooter2.main(obj) --给这个小怪装上发射器
                T.move2(obj, u)
            end
            return create
        end
)
--用作使魔的自机狙鬼火
E.enemy3 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, mst, a, u)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        99999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                obj.group = GROUP_INDES
                --S.shooter1.main(obj) --给这个小怪装上发射器
                T.move3(obj, mst, a, 2*u) --跟随主人
                obj.show_aura = true
            end
            return create
        end
)
--发三角型描边弹的大型妖精
E.enemy4 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, u, a)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_RED, --style
                        160, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                enemy.changeAura(obj, COLOR_RED, "middle")
                --生成小弟
                for i = 0, 2 do
                    E.enemy3.create(x, y, obj, 120*i, -u)
                end
                S.shooter3.main(obj, u, a) --发三角型描边弹
                T.move4(obj) --先减速，再匀速，最后加速的向下运动
            end
            return create
        end
)

--直线下来的普通的下落弹狙杂鱼
E.enemy5 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, u)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_BLUE, --style
                        5, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter4.main(obj, 0) --下落弹
                T.move5(obj, u)
            end
            return create
        end
)

--从一侧漂到另一侧的杂鱼
E.enemy6 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, da, dt, u)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_4_BLUE, --style
                        5, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter4.main(obj, dt) --只向下发弹幕
                T.move6(obj, da, u) --从一侧移到另一侧
            end
            return create
        end
)

--从一侧漂到另一侧再飘回来的杂鱼
E.enemy7 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, da, dt, u)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_4_BLUE, --style
                        5, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1.main(obj, dt) --自机狙
                T.move7(obj, da, u) --从一侧漂到另一侧再飘回来
            end
            return create
        end
)

--后半道中鬼火
E.enemy8 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local function create(x, y, v, a, u)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        3, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter5.main(obj, a, 80) --给这个小怪装上发射器
                T.move8(obj, v, a, u)
                obj.show_aura = true
            end
            return create
        end
)
--endregion

--region Show Title

local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s1_title1"
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
                New(white, x, y - 15*u, 2*u, 255, 0, 0)
            end
            task.Wait(8)
        end
    end)
end

--endregion

function R.INIT(sence)
    system.PowerRank.resumeHyper() --从这里计时
    local self = New(R) --创建自己
    self.sence = sence or 0
    New(stage1_background, self.sence)
    loadRes()
    LoadMusicRecord("s1")

    R.updateByRankChange() --初始化一次
    
    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
function R.FIRST(pratice)
    local self = lstg.tmpvar.current_road
    self.sence = 1
    --等待与bgm
    EISlib.stage.playMusic("s1", 0, true) -- 要解锁音乐室
    --开幕杂鱼
    local pos_x = {-120, 120, 0, -80, 60}
    for j = 1, 4 do
        for _ = 0, 3 do
            for u = -1, 1, 2 do
                E.enemy1.create(pos_x[j] + 30*u, 250)
                task.Wait(10)
            end
        end
        if j == 2 then
            E.enemy2.create(90, 250, 1)
        end
    end
    --两只中型妖精
    E.enemy2.create(-90, 250, -1)
    task.Wait(60)
    --一群杂鱼引路
    for i = -1.5, 1.5 do
        for u = -1, 1, 2 do
            E.enemy1.create(20 + 35*i + 10*u, 280 + 30*u)
            task.Wait(5)
        end
    end
    task.Wait(40)
    E.enemy2.create(90, 250, 1)
    task.Wait(90)
    createTitle(0, 100)
    task.Wait(60)
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --800f
    if IsValid(self) then
        if pratice then
            self.timer = 800
            audio.playMusic("s1", 1.0, 800/60)
        else
            --等到800f
            while self.timer < 800 do
                task.Wait(1)
            end
        end
        if self.timer == 800 then
            self.sence = 2
            --生成大型妖精
            E.enemy4.create(0, 250, 1)
            task.Wait(90)
            --生成从一侧到另一侧的杂鱼
            local da = {-3, 2, -8, 5, -8, 8, 3, 1} --由随机数生成器产生的
            local dt = {21, 8, 22, 8, 20, 4, 8, 24} --第一次攻击时间
            local index
            for i = 0, 9 do
                index = i%8 + 1
                E.enemy6.create(224, 100, da[index], dt[index], -1)
                task.Wait(8)
            end
            task.Wait(60)
            for u1 = 1, -1, -2 do
                --两只中妖精
                for i = 0, 1 do
                    E.enemy2.create((60 - 120*i)*u1, 250, -u1)
                    task.Wait(40)
                end
                --一群杂鱼引路
                for i = -3, 3 do
                    for u = -1, 1, 2 do
                        E.enemy1.create((-20 + 50*i + 20*u)*u1, 280 + 30*u*u1)
                        task.Wait(6)
                    end
                end
                task.Wait(60)
            end
            --生成从一侧到另一侧的杂鱼
            for i = 0, 9 do
                index = i%8 + 1
                E.enemy6.create(-224, 100, da[index], dt[index], 1)
                task.Wait(8)
            end
            task.Wait(60)
            --两中只中妖精
            for i = -1, 1, 2 do
                E.enemy2.create(-60*i, 250, -1)
                task.Wait(40)
            end
            --task:生成一群的交叉妖精
            task.New(self, function()
                task.Wait(30)
                for i = 1, 6 do
                    for j = 0, 1 do
                        for u = -1, 1, 2 do
                            E.enemy7.create(-224*u, 130 + 30*j, da[i], dt[i] + 45, u)
                        end
                        task.Wait(10)
                    end
                end
            end)
            --下落弹杂鱼
            for i = 0.5, 2.5 do
                for u = -1, 1, 2 do
                    --E.enemy5.create(50*i*u + 12.5*u, 280 + 30*u, -u)
                end
                task.Wait(5)
            end
            task.Wait(40)
            --生成大型妖精
            E.enemy4.create(0, 250, 1)
        end
    end
end

--道中片段3（道中boss）
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage1/mid_boss.lua")
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
s1_road.midBoss = midBossMain
function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --2040f(34s)
    if IsValid(self) then
        if pratice then
            self.timer = 2040
            audio.playMusic("s1", 1.0, 2040/60)
        else
            --等到2040f
            while self.timer < 2040 do
                task.Wait(1)
            end
        end
        if self.timer == 2040 then
            self.sence = 3
            EGGlib.ObjectEvent.clearEnemyAndBullet()
            --⑨出场
            self.midboss = New(mid_bosses[difficulty])
            while self.timer < 3000 do
                task.Wait(1)
            end
            --增援
            tasker(function()
                local x0, dx = 180, -40
                local flag = true
                while flag do
                    for _ = 0, 3 do
                        if not flag then break end
                        for u = -1, 1, 2 do
                            if not flag then break end
                            if not IsValid(self.midboss) then
                                E.enemy1.create(x0*u, 280)
                            end
                            if self.timer > 3500 then
                                flag = false
                            end
                        end
                        task.Wait(10)
                        x0 = x0 + dx
                    end
                    dx = -dx
                end
            end)
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --3500f
    if IsValid(self) then
        if pratice then
            self.timer = 3600
            audio.playMusic("s1", 1.0, 3600/60)
        else
            --等待到3600f
            while self.timer < 3600 do
                task.Wait(1)
            end
        end
        if self.timer == 3600 then
            self.sence = 4
            local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
            local function createGhostFireFunc(u)
                return function (x, y, v, a)
                    E.enemy8.create(x, y, v, a, u)
                end
            end
            --创建一串鬼火团函数(u表示鬼火离场的方向（顺时针还是逆时针
            local function createGhostFireGroup(x, y, a, u, n)
                curve_normalDv1(x, y, 1.75 + 1.25*(4-n), a, n, 1.25, 15*u, --x, y, v0, a, bunch, dv, da
                        createGhostFireFunc(u))
            end
            ----以下才是真正创建鬼火群
            local n = 1
            for _ = 1, 2 do
                for u = 1, -1, -2 do
                    for i = 0, 7 do
                        if not IsValid(self.midboss) then  --这个算正常的道中部分也算增援
                            createGhostFireGroup(-40*u, 240, -90 + (-80 + 14*i)*u, u, n)
                        end
                        task.Wait(4)
                    end
                    task.Wait(65 + 30*n)
                    n = n + 1
                end
            end
            --再搞一些白给杂鱼
            local x0, dx = 180, -40
            for u0 = -1, 1, 2 do
                --两只中蝴蝶
                task.New(self, function()
                    task.Wait(80)
                    for u = -u0, u0, 2*u0 do
                        if not IsValid(self.midboss) then
                            E.enemy2.create(-90*u, 250, u)
                        end
                    end
                end)

                for _ = 0, 3 do
                    for _ = 0, 3 do
                        for u = -1, 1, 2 do
                            if not IsValid(self.midboss) then
                                E.enemy1.create(x0*u, 280)
                            end
                        end
                        task.Wait(10)
                        x0 = x0 + dx
                    end
                    dx = -dx
                end
                task.Wait(120)
            end
        end
    end
end

function R.FIFTH(pratice)
    local self = lstg.tmpvar.current_road
    --4880f
    if IsValid(self) then
        if pratice then
            self.timer = 4880
            audio.playMusic("s1", 1.0, 4880/60)
        else
            --等待到3600f
            while self.timer < 4880 do
                task.Wait(1)
            end
        end
        if self.timer == 4880 then
            self.sence = 5
            local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
            local function createGhostFireFunc(u)
                return function (x, y, v, a)
                    E.enemy8.create(x, y, v, a, u)
                end
            end
            --创建一串鬼火团函数(u表示鬼火离场的方向（顺时针还是逆时针
            local function createGhostFireGroup(x, y, a, u, n, maxn)
                curve_normalDv1(x, y, 1.75 + 1.25*(maxn-n), a, n, 1.25, 15*u, --x, y, v0, a, bunch, dv, da
                        createGhostFireFunc(u))
            end
            --创建鬼火群
            local function spawnGhostFire(u, n, maxn)
                for i = 0, 7 do
                    createGhostFireGroup(10*u, 240, -90 + (-80 + 14*i)*u, u, n, maxn)
                    task.Wait(4)
                end
            end

            ---道中内容从这开始
            for u = -1, 1, 2 do
                spawnGhostFire(-u, 2, 4)
                task.Wait(90)
                for u0 = -1, 1 do
                    E.enemy2.create(90*u*u0, 250, u)
                    task.Wait(60)
                end
                --生成从一侧到另一侧的杂鱼
                local da = {-3, 2, -8, 5, -8, 8, 3, 1} --由随机数生成器产生的
                local dt = {21, 8, 22, 8, 20, 4, 8, 24} --第一次攻击时间
                local index
                for i = 0, 14 do
                    index = i%8 + 1
                    E.enemy6.create(224*u, 100, da[index], dt[index], -u)
                    task.Wait(6)
                end
            end
            --两组三只中怪+小怪
            local u0 = -1
            for i = -1, 1 do
                for j = -2, 2 do
                    E.enemy1.create((50*i + 30*j*u0), 280 + 15*j)
                    task.Wait(5)
                end
                u0 = -u0
                E.enemy2.create(90*i, 250, -i)
            end
            task.Wait(150)
            --最后一波，两组阴阳玉方向相反
            spawnGhostFire(1, 2, 4)
            spawnGhostFire(-1, 2, 2)
            task.Wait(120)
            --两只大妖精
            local a = ran:Float(-180, 180)
            E.enemy4.create(-90, 250, 1, a)
            E.enemy4.create(90, 250, -1, -a)
            task.Wait(400)
            EGGlib.ObjectEvent.clearEnemyAndBullet()
            system.PowerRank.pauseHyper() --从这里停止计时
        end
    end
end

--region movement
--移动任务
function T.move1(obj)
    task.New(obj, function()
        local a = Angle(obj, player)
        velch(obj, 3, 0, a, 40, 40)
        task.Wait(120)
        velch(obj, 0, 3, -a, 60)
        obj.bound = true
    end)
end

--竖直向下移动然后从一边离开
local vach2 = EGGlib.ObjectEvent.addChangeVelocity
function T.move2(obj, u)
    task.New(obj, function()
        velch(obj, 3, 0.5, -90, 30, 20)
        task.Wait(150)
        velch(obj, 0, 2.5, -90, 120)
        --vach2(obj, 2, 90*u, 90, 60) --dv, da, tv, ta
        obj.bound = true
    end)
end

--旋转跟随
function T.move3(obj, mst, a, omiga)
    _connect(mst, obj, 1, true)
    EGGlib.ObjectEvent.rotateMoveWith2Task(obj, mst,
            60, a, --rmax, a
            omiga, --omiga
            60, _infinite, --t0, t1
            false --IsRotChange
    )
end

--先减速后匀速最后加速的竖直向下移动
function T.move4(obj)
    task.New(obj, function()
        velch(obj, 2.75, 0.25, -90, 30, 20)
        velch(obj, 0.5, 3, -90, 30, 240)
        obj.bound = true
    end)
end

--小怪的竖直向下移动然后从一边离开
local vach2 = EGGlib.ObjectEvent.addChangeVelocity
function T.move5(obj, u)
    task.New(obj, function()
        velch(obj, 3, 0.5, -90, 30, 20)
        vach2(obj, 2, 90*u, 90, 60) --dv, da, tv, ta
        obj.bound = true
    end)
end

--小怪从一侧移动到另一侧
local simPar = EGGlib.ObjectEvent.simPar --简单的抛物线运动
function T.move6(obj, da, u)
    task.New(obj, function()
        local a = 90 - (100 + da)*u
        simPar(obj, 4, a, 0.025, a + 90*u) --v , va, acc, acca
        obj.bound = true
    end)
end

--小怪从远处飞到近处再飞回来
local accdec2 = EGGlib.ObjectEvent.accDecVelocityChange2
local arbgCh = EGGlib.ObjectEvent.argbChange
function T.move7(obj, da, u)
    arbgCh(obj, 100, 100, 100, 100, 120, false, true)
    task.New(obj, function()
        local a = 90 - (100 + da)*u
        accdec2(obj,
                3.5, a, 90, 60, 120, 180, --vx, a, wt, tx0, tx1, tx2,
                75, --dt,
                -2.5, u, 40, 0, 40, --vy, u, ty0, ty1, ty2,
                true --isTask
        )
        obj.bound = true
    end)
end

--鬼火移动+渐入+离开
function T.move8(obj, v, a, u)
    arbgCh(obj, 100, 100, 100, 100, 80, false, true)
    task.New(obj, function()
        velch(obj, v, 0, a, 60, 20)
        velch(obj, 0, 3, a + 150*u, 120, 20)
        obj.bound = true
    end)
end
--endregion
return R
