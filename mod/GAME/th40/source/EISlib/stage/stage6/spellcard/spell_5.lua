-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_5.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local clearBulletAndLaserInRangeCircle = EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle
local argbChange = EGGlib.ObjectEvent.argbChange
local extendClass = EGGlib.Math.extendClass
local alphaChange = EGGlib.ObjectEvent.alphaChange
local newTrail = EGGlib.RenderEffect.newTrail
local involuteMoveTask = EGGlib.ObjectEvent.involuteMoveTask
local boundWait = EGGlib.ObjectEvent.boundWait
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local laser = EISlib.Bullet.Laser.laser
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local Bclass = EISlib.BossDefinition.Sonia
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1

local moon_img = "Sonia_red_moon"
local moon_eff_img = "Sonia_scbg3"

--闪白
local flash = Class(object)
function flash:init(t0, t1, t2)
    self.x, self.y = 0, 0
    self.img = "white"
    self.hscale, self.vscale = 100, 100
    self.layer = LAYER_BG + 52
    robject.set_color(self, "", 0, 255, 255, 255)
    task.New(self, function()
        local d_a = 255/t0
        for _ = 1, t0 do
            self._a = self._a + d_a
            task.Wait(1)
        end
        task.Wait(t1)
        d_a = -255/t2
        for _ = 1, t2 do
            self._a = self._a + d_a
            task.Wait(1)
        end
        Del(self)
    end)
end
function flash:frame()
    task.Do(self)
end
function flash:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end


--本张符卡的特殊血灵碎片
local sp_chip = extendClass(item.Blood) --完全继承item.Blood的方法，记得是用create来创建的对象，style填item.Blood.Small
local old_collect = sp_chip.collect
--override
function sp_chip.collect(self)
    old_collect(self)
    local range = switch1(difficulty, {
        80, 70, 65, 60, 60
    })
    local cd = switch1(difficulty, {
        75, 60, 50, 45, 45
    })
    local obj = clearBulletAndLaserInRangeCircle(player.x, player.y, range, 3, cd, nil, false, true) --x, y, range, index, cd
    obj._a = 100
end
function sp_chip.create(x, y, style)
    return lstg.New(sp_chip, x, y, style)
end

local moon_size = 1
local moon_center_x, moon_center_y = 0, 300

local moon_flash = Class(object)
function moon_flash:init()
    self.bound = false
    self.x, self.y = moon_center_x, moon_center_y
    self.hscale, self.vscale = moon_size, moon_size
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY - 1
    robject.set_color(self, "mul+add", 0, 255, 255, 255)
    task.New(self, function()
        alphaChange(self, 0, 255, 10)
        alphaChange(self, 255, 0, 80)
        Del(self)
    end)
end
function moon_flash:frame()
    task.Do(self)
end
function moon_flash:render()
    SetImageState(moon_img..0, self._blend, Color(self._a, self._r, self._g, self._b))
    for _ = 1, 1 do
        Render(moon_img..0, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
end

local moon_eff = Class(object)
function moon_eff:init()
    self.bound = false
    self.x, self.y = moon_center_x, moon_center_y
    self.hscale, self.vscale = 0, 0
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY - 1
    robject.set_color(self, "mul+add", 0, 255, 255, 255)
    task.New(self, function()
        sizeAndColliChangeTask(self, 3*moon_size, 90)
        alphaChange(self, 0, 50, 20)
        alphaChange(self, self._a, 0, 70)
        Del(self)
    end)
end
function moon_eff:frame()
    task.Do(self)
end
function moon_eff:render()
    SetImageState(moon_eff_img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(moon_eff_img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local moon_eff2 = Class(moon_eff)
function moon_eff2:init()
    self.bound = false
    self.x, self.y = moon_center_x, moon_center_y
    self.hscale, self.vscale = 0, 0
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER - 1
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    task.New(self, function()
        sizeAndColliChangeTask(self, 12*moon_size, 60)
        alphaChange(self, self._a, 0, 60)
        Del(self)
    end)
end
function moon_eff2:render()
    SetImageState(Bclass.ring2_img, "mul+add", Color(self._a, self._r, self._g, self._b))
    Render(Bclass.ring2_img, self.x, self.y, self.rot, self.hscale, self.vscale)
    SetImageState(Bclass.ring1_img, "mul+rev", Color(self._a, self._r, self._g, self._b))
    Render(Bclass.ring1_img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local moon = Class(object)
function moon:init(prac)
    self.bound = false
    self.x, self.y = moon_center_x, moon_center_y + 300
    self.hscale, self.vscale = moon_size, moon_size
    self.group = GROUP_ENEMY
    self.layer = LAYER_ENEMY - 1
    enemy.setTauntRank(self, enemy.BIG_TAUNT)
    self.a, self.b = 190, 190
    self.maxhp = 500
    self.hp = self.maxhp
    self.protect = true
    robject.set_color(self, "", 255, 0, 0, 0)
    self.colli = false
    if not prac then --主线模式的行为
        task.New(self, function()
            task.MoveTo(self, moon_center_x, moon_center_y, 120, MOVE_DECEL)
            --task.Wait(60)
            local t = 60
            local d = 50/t
            for _ = 1, t do
                self._r, self._g, self._b = self._r + d, self._g + d, self._b + d
                task.Wait(1)
            end
            New(moon_flash) --闪一次
            local t = 20
            local d = (255 - 50)/t
            for _ = 1, t do
                self._r, self._g, self._b = self._r + d, self._g + d, self._b + d
                task.Wait(1)
            end
            self.colli = true
        end)
    else --练习模式的行为
        task.New(self, function()
            self.x, self.y = moon_center_x, moon_center_y
            local t = 60
            local d = 50/t
            for _ = 1, t do
                self._r, self._g, self._b = self._r + d, self._g + d, self._b + d
                task.Wait(1)
            end
            New(moon_flash) --闪一次
            local t = 20
            local d = (255 - 50)/t
            for _ = 1, t do
                self._r, self._g, self._b = self._r + d, self._g + d, self._b + d
                task.Wait(1)
            end
            self.colli = true
        end)
    end
end
function moon:frame()
    task.Do(self)
    if self.hp <= 0 then
        moon.broken(self)
    end
end
function moon:render()
    local t = math.floor(self.timer/2)%40
    SetImageState(Bclass.ring1_img, "mul+rev", Color(self._a, self._r, self._g, self._b))
    Render(Bclass.ring1_img, self.x, self.y, self.rot, 2*self.hscale, 2*self.vscale)
    SetImageState(moon_img..t, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(moon_img..t, self.x, self.y, self.rot, moon_size, moon_size)
    SetImageState(moon_eff_img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(moon_eff_img, self.x, self.y, self.rot, 0.75*self.hscale, 0.75*self.vscale)
end
function moon:colli(other)
    enemybase.colli(self, other)
end
function moon:take_damage(dmg)
    if not self.protect then
        self.hp = self.hp - dmg
    end
end
--月亮被击碎一次
function moon:broken()
    PreserveObject(self) --but it refused!
    self.hp = self.maxhp
    local x_list = {-180, -145, -90, 0, 90, 145, 180}
    local n = 7 --一次产出7片碎片
    n = (n - 1)/2
    local x = 0
    PlaySound("enep00")
    --PlaySound("extend")
    for i = -n, n do
        sp_chip.create(
                x + x_list[i+n+1],
                120 + 30*abs(i),
                item.Blood.Small)
    end
    --effect.shakeScreen(30, 1)
    New(moon_eff2)
end

--鲨红了眼
local red_light = Class(object)
function red_light:init(x, y)
    self.img = "ball_light1"
    self.x, self.y = x, y
    self.rot = 0
    self.hscale, self.vscale = 0, 0
    robject.set_color(self, "mul+add", 255, 255, 0, 0)
    task.New(self, function()
        local t = 30
        local dh, dv, da = 0.1/t, 0.1/t, -255/t
        for _ = 1, t do
            self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
            self._a = self._a + da
            task.Wait(1)
        end
        Del(self)
    end)
end
function red_light:frame()
    task.Do(self)
end
function red_light:render()
    defaultRenderImg(self)
end


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --挡路的子弹
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --速度（只有rank=4时触发）
                local v = switch(diff, {
                    1.75, 2, 2.25, 2.5, 2.5
                })
                --消失前的等待时间（只有rank=4时触发）
                local wt = 9999
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.star_small, COLOR_ROYAL_BLUE)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.omiga = 3
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        task.Wait(180)
                        velchTask(obj, 0, v, a, 120, 0)
                        task.Wait(wt)
                        obj.colli = false
                        alphaAndSizeChange(obj, -255, -obj.hscale, 30)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = switch1(diff, {
                    150, 150, 150, 150, 150
                })
                local n = switch1(diff, {
                    2, 3, 3, 4, 4
                })
                local wait = switch1(diff, {
                    60, 50, 40, 30, 30
                })
                local dl = 195/(n - 1)
                local function create(x, y, da)
                    local rot = da
                    local color = COLOR_DEEP_BLUE
                    if da == 0 then
                        color = COLOR_DEEP_RED
                    end
                    local obj = New(lead_laser,
                            1, color, --type, co
                            x + r*cos(rot - 90), y + r*sin(rot - 90), 10, rot - 90, --x, y, v, a
                            600, 20, 20, 1, --len, w0, w1, t
                            true, false, _infinite --islock, isshoot, last_time
                    )
                    laser.setGrowCD(obj, 60)
                    obj.hide = true
                    task.New(obj, function()
                        task.Wait(60)
                        obj.hide = false
                        PlaySound("lazer01")
                        --星星
                        task.Wait(945) --1200f
                        local cos, sin
                        while true do
                            cos, sin = laser.getCosSinRot(obj)
                            for i = 0, n - 1 do
                                B.bullet1.create(obj.x + (65 + dl*i)*cos, obj.y + (65 + dl*i)*sin, obj.rot)
                            end
                            task.Wait(wait)
                        end
                    end)
                    --obj._blend = ""
                    obj.bound = false
                    local alpha = 1
                    local ws = New(warning_laser,
                            obj.x, obj.y,
                            600, 30, --len, l_t
                            10, 10, --wide, w_t
                            obj.rot, "mul+add", Color(255*alpha, 255, 0, 0), 60
                    )
                    warning_laser.setTrailLength(ws, 40)
                    PlaySound("lazer00")
                    ws.bound = false
                    task.New(ws, function()
                        while IsValid(obj) do
                            ws.x, ws.y = obj.x, obj.y
                            laser.setRot(ws, obj.rot)
                            task.Wait(1)
                        end
                        Del(ws)
                    end)
                    return obj
                end
                return create
            end
    )

    --激光控制模块
    B.laser_controler = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = 150
                local way = switch1(diff, {
                    16, 16, 16, 16, 16
                })
                local da = 360/way
                local max_drot0 = switch1(diff, {
                    0.1, 0.1, 0.1, 0.1, 0.1
                })
                local max_ddrot = max_drot0/20 --最大角加速度（可以在20帧内从0加到最大角速度）
                local da_d_drot_rate = max_ddrot/30 --角度差超过30度时，达到最大角加速度
                --角加速度倍率
                local function d_drot_rate()
                    if system.PowerRank.getRank() == 4 then
                        return 1
                    end
                    return 1
                end
                local function create(b)
                    local a = -90 + 0.5*da
                    local ls = {}
                    task.New(b, function()
                        for i = 0, way - 1 do
                            table.insert(ls, B.laser1.create(moon_center_x + r*cos(-90 + da*i), moon_center_y + r*sin(-90 + da*i), da*i))
                            --_connect(b, ls[i + 1], 0, true)
                        end
                        local flag, obj = true
                        local a0, da0, drot, d_drot
                        drot = 0
                        --激光已经发射出来，开始转向逻辑
                        local max_drot = 0 --最大角加速度，从0加到最大
                        local d_max_drot = max_drot0/300 --5秒内加到最大
                        while flag do
                            max_drot = min(max_drot0, max_drot + d_max_drot)
                            a0 = Angle(moon_center_x, moon_center_y, player.x, player.y)
                            da0 = (a0 - a)%360
                            if da0 > 180 then
                                da0 = da0 - 360
                            end
                            d_drot = max(-max_ddrot, min(max_ddrot, da0*da_d_drot_rate*d_drot_rate())) --角加速度计算公式（玩家离的角度越远加速度越大，有上限）,4rank时翻1.5倍
                            drot = max(-max_drot, min(max_drot, drot + d_drot)) --角速度
                            a = a + drot
                            flag = false
                            for i = 0, way - 1 do
                                obj = ls[i+1]
                                if IsValid(obj) then
                                    flag = true --只要还存在一个激光就不会中止判断
                                    laser.setRot(obj, a + da*i)
                                    obj.x, obj.y = moon_center_x + r*cos(a + da*i), moon_center_y + r*sin(a + da*i)
                                end
                            end
                            task.Wait(1)
                        end
                    end)
                    task.New(b, function()
                        task.Wait(405 - 240) --开符后600 - 240f
                        local obj = ls[1]
                        while IsValid(obj) do
                            T.laser1.main(moon_center_x, moon_center_y, obj.rot)
                        end
                    end)
                    task.New(b, function()
                        task.Wait(705 - 120) --开符后900 - 120f
                        local obj = ls[1]
                        while IsValid(obj) do
                            T.laser2.main(moon_center_x, moon_center_y, a)
                        end
                    end)
                    task.New(b, function()
                        task.Wait(1620 - 195 - 120) --开符后1620f
                        local dway = switch1(diff, {
                            6, 8, 10, 12, 12
                        })
                        local obj = ls[1]
                        for i = 1, _infinite do
                            if IsValid(obj) then
                                if i < 10 then
                                    T.laser3.main(moon_center_x, moon_center_y, a, 0)
                                else
                                    T.laser3.main(moon_center_x, moon_center_y, a, dway)
                                end
                            else
                                break
                            end
                        end
                    end)
                end
                return create
            end
    )


    --endregion
    --region 子弹发射点定义
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way_c = switch1(diff, {
                    6, 6, 6, 6, 6
                })
                local da_c = 22.5
                local way = switch1(diff, {
                    3, 3, 4, 5, 5
                })
                local da = 2.5
                local v0 = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    1, 0.5, 0.75, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    1, 2, 2, 2, 2
                })
                --子弹满速前进的时间
                local wt = 60
                local style, color = stg.arrow_small_b, COLOR_DEEP_BLUE
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.setBoundTime(stg.newSimpleStrChV(x, y, v0 + 2, v, a + da_c*i, 30, wt, style, color), 30)

                    end
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(
                                        x, y, v0, a,
                                        way, da,
                                        layer, dv, 0, --layer, dv, da
                                        bullet_func
                                )
                            end, true)
                end
                return attack
            end
    )

    --扩散角更大的
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way_c = switch1(diff, {
                    2, 2, 2, 2, 2
                })
                way_c = max(0, (way_c - 1)/2)
                local da_c = 1
                local way = switch1(diff, {
                    7, 10, 12, 14, 14
                })
                local da = 11.25
                local v = switch1(diff, {
                    1.25, 1.25, 1.375, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local style, color = stg.arrow_small_b, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.setBoundTime(stg.newSimpleStrChV(x, y, 4, v, a + da_c*i, 30, 60, style, color, false, 1), 30)
                    end
                end
                local function attack(x, y, a)
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(
                                        x, y, v, a + 0.5*da,
                                        way, da,
                                        layer, dv, 0, --layer, dv, da
                                        bullet_func
                                )
                            end, true)
                end
                return attack
            end
    )

    --墙
    P.arrow_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way_c = switch1(diff, {
                    6, 6, 6, 6, 6
                })
                local da_c = 22.5
                local way = switch1(diff, {
                    5, 7, 9, 11, 11
                })
                local da = 1
                local v0 = 0.75*defaultSwitchVelocityByRank(rank)
                --子弹满速前进的时间
                local wt = 60
                local style, color = stg.arrow_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.setBoundTime(stg.newSimpleStrChV(x, y, v0 + 2, v, a + da_c*i, 30, wt, style, color, false, -2), 30)

                    end
                end
                local function attack(x, y, a, dway)
                    dway = dway or 0
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(
                                        x, y, v0, a,
                                        way + dway, da,
                                        1, 0, 0, --layer, dv, da
                                        bullet_func
                                )
                            end, true)
                end
                return attack
            end
    )

    --连发无缝弹幕
    P.perform = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 1.75
                local dv = 0.1
                local way_c = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                local da_c = 6/(way_c - 1)
                way_c = (way_c - 1)/2
                local way = switch1(diff, {
                    16, 16, 16, 16, 16
                })
                local da = 360/way
                local style, color = stg.arrow_small_b, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.newSimpleStraight(x, y, v, a + da_c*i, style, color)
                    end
                end
                local function attack(x, y, i)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v + dv*i, -90 + 0.4*da*i, way, bullet_func)
                            end)
                end
                return attack
            end
    )

    --护身弹幕
    P.protect = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 3
                local way_c = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                local da_c = 6/(way_c - 1)
                way_c = (way_c - 1)/2
                local way = switch1(diff, {
                    16, 16, 16, 16, 16
                })
                local da = 360/way
                local style, color = stg.arrow_small_b, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.newSimpleStraight(x, y, v, a + da_c*i, style, color)
                    end
                end
                local function attack(x, y, i)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, -90 + 0.4*da*i, way, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --开幕无缝弹
    T.perform = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    6, 10, 12, 15, 15
                })
                local wait = 5
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        P.perform.attack(_boss.x, _boss.y, i)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --护身弹，禁止自机靠近屏幕一半以上的高度
    T.protect = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 10
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, _infinite do
                                        if player.y > -100 then
                                            P.protect.attack(_boss.x, _boss.y, i)
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --以激光对象作为发射器载体
    T.laser1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch(rank, {
                    40, 40, 40, 40, 40
                })
                local function main(x, y, a)
                    PlaySound("tan00")
                    P.pointer1.attack(x, y, a)
                    task.Wait(wait)
                end
                return main
            end)


    --以激光对象作为发射器载体
    T.laser2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch(rank, {
                    30, 30, 30, 30, 30
                })
                local function main(x, y, a)
                    PlaySound("tan00")
                    P.pointer2.attack(x, y, a)
                    task.Wait(wait)
                end
                return main
            end)

    --狂暴
    T.laser3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 60
                local function main(x, y, a, dway)
                    PlaySound("tan00")
                    P.arrow_big.attack(x, y, a, dway)
                    task.Wait(wait)
                end
                return main
            end)
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    B.laser_controler.create(b)
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
    
    --月亮对象
    local moon_inst

    --背景起飞了
    local function bgChange()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and bg.class.flyToSky then
            bg.class.flyToSky(bg)
        end
    end

    local function bossAction(b)
        --强制结束hyper
        if system.PowerRank.isInHyper() then
            system.PowerRank.hyperNormalEnd(player)
        end
        PlaySound("hell")
        b.absorbAction(b, 60)
        --起飞！~
        bgChange()
        task.MoveTo(b, 0, 300, 20, MOVE_ACCEL)
        --我变黑了
        robject.set_color(b, "", 255, 0, 0, 0)
        moon_inst = New(moon)
        _connect(b, moon_inst, 1, false)
        task.wait(60)
        task.New(b, function()
            for i = 1, 90 do
                for u = -1, 1, 2 do
                    New(red_light, b.x + 3*u, b.y + 22, 90 + 15*i*u, 6*u)
                end
                task.Wait(1)
            end
        end)
        b.colli = false
        task.MoveTo(b, 0, 120, 90, MOVE_DECEL)
        task.Wait(30)
        setNextCardNoScOpenEffect(b) --下一张卡不使用开卡演出
    end

    local function bossAction2(b)
        --我变黑了
        robject.set_color(b, "", 255, 0, 0, 0)
        task.New(b, function()
            --强制结束hyper
            if system.PowerRank.isInHyper() then
                system.PowerRank.hyperNormalEnd(player)
            end
            system.PowerRank.openInfiniteHyperMode()
            system.PowerRank.setHyperTime(system.PowerRank.getHyperMaxTime())
            system.PowerRank.hyperStart()
            system.PowerRank.pauseHyper()
            for _ = 1, 3 do
                New(AbsorbEffect2, b.x, b.y, 0, 255, 255, "mul+add")
                task.Wait(20)
            end
        end)
        task.Wait(60)
    end

    local function bossActionPrac(b)
        do
            local bg = lstg.tmpvar.bg
            if IsValid(bg) and bg.class.flyToSky then
                bg.class.flyToSky(bg, true)
                if bg.class.moonAppear then
                    bg.class.moonAppear(bg)
                end
            end
        end
        b.x, b.y = 0, 120
        b.colli = false
        moon_inst = New(moon)
        _connect(b, moon_inst, 1, false)
        setNextCardNoScOpenEffect(b) --下一张卡不使用开卡演出
        bossAction2(b)
    end
    
    local names = {
        "name-boss8-card5-E",
        "name-boss8-card5-N",
        "name-boss8-card5-H",
        "name-boss8-card5-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "finalspell", --类型
            {3, 3, 55}, --时间
            7800, --耐久
            {0, 50}, --掉落
            function(b) --普通模式攻击前动作
                player_class.setHUDhide(b)
                LoadMusicRecord("s6_boss")
                dialog.utility.cacheResource("Stage6spell")
                -- 喘口气
                task.MoveTo(b, 0, 0, 60, MOVE_NORMAL)
                -- 对话
                dialog.scene.stage6_sps(function()
                    bossAction(b) -- 芜湖~
                    boss.setUInameDisplay(b, true)
                end, true) -- 依然可以解锁BGM
                -- 继续打
                bossAction2(b)
                boss.show_aura(b, true)
            end,
            function(b) --练习模式攻击前动作
                player_class.setHUDhide(b)
                bossActionPrac(b)
                boss.show_aura(b, true)
            end,
            function(b) --main
                local dmg_rate = 1
                if player.name then --针对不同自机伤害倍率调整
                    if player.name == "reimu" then
                        dmg_rate = 1.02
                    elseif player.name == "marisa" then
                        dmg_rate = 0.92
                    end
                end
                b.dmgrate = dmg_rate --针对不同机体的减伤机制

                _connect(b, moon_inst, 1, true)
                moon_inst.protect = false --解除无敌
                b.protect = false --解除自身无敌
                reFresh()
                --boss由黑变亮
                task.New(b, function()
                    local t = 30
                    local d = 255/t
                    for _ = 1, t do
                        b._r, b._g, b._b = b._r + d, b._g + d, b._b + d
                        task.Wait(1)
                    end
                    robject.set_color(b, "", 255, 255, 255, 255)
                end)
                --血灵碎片补给
                local x_list = {{-145, -90, 0, 90, 145}, {-162, -117, -45, 45, 117, 162}}
                local n
                local index
                for j = 0, 3 do
                    index = j%2 + 1
                    n = #x_list[index] --一次产出7片碎片
                    n = (n - 1)/2
                    for i = -n, n do
                        sp_chip.create(
                                x_list[index][i+n+1],
                                200 + 30*abs(i) + 45*j ,
                                item.Blood.Small)
                    end
                end

                --自己再加开卡演出
                b.scOpenEffect(b)
                T.perform.main()
                task.Wait(75)
                T.protect.main()
                C.FIRST.main(b)
            end,
            function(b) --finish
                b.dmgrate = 1 --请恢复
                b.colli = true
                b.openBacklight()
                --effect.shakeScreen(120, 10)
                if IsValid(moon_inst) then --保险措施，防止月亮因意外没删除
                    moon_inst.status = "del"
                end
                if not system.gamemode.isSpellCardPractice() then
                    New(flash, 10, 60, 60)
                    effect.shakeScreen(130, 20)
                    PlaySound("explode")
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )

    local _sc = EGGlib.BossCard.getFullCardMain(card)
    --override
    --在符卡最开始时取消自机hud（先于通用模板的立绘演出和强制等待）
    function _sc.inTheFrontOfInit(b)
        player_class.setHUDhide(b)
    end

    return card
end
return createCard
