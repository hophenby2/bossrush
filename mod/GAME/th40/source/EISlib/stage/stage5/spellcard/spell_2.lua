-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/spell_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local warning_laser = EISlib.Bullet.Laser.warning_laser
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local isInRect = EGGlib.ObjectEvent.isInRect

local cleft_imgs = {}
for i = 1, 21 do
    cleft_imgs[i] = boss_name.."cleft"..(i - 1)
end


--反色圈
local invert_color_circle = Class(object)
function invert_color_circle:init(x, y)
    self.layer = LAYER_TOP - 1
    self.group = GROUP_GHOST
    self.x = x
    self.y = y
    self.bound = false
    self.size1 = 0
    self.size2 = 0
    task.New(self, function()
        for t = 1, 30 do
            self.size1 = 800*(1 - cos(3*t))
            task.Wait(1)
        end
        task.Wait(60)
        for t = 1, 30 do
            self.size2 = 800*(1 - cos(3*t))
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
end

--拉进弹幕、boss、自机
local cleft = Class(object)
function cleft:init(x, y, rot, h, v)
    self.bound = false
    self.trail_x, self.trail_y = x, y
    self.group = GROUP_INDES
    self.layer = LAYER_ENEMY_BULLET - 1
    self.x, self.y = x, y
    self.colli = true
    self.rect = true
    self.rot = rot
    self._dx, self._dy = cos(rot), sin(rot)
    self.hscale, self.vscale = 0, v
    self.a, self.b = 0, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    task.New(self, function()
        local t = 20
        local dh = 1*h/t
        local db = 15*v/t
        for _ = 1, t do
            self.hscale = self.hscale + dh
            self.a = self.a + 200*dh
            self.b = self.b + db
            task.Wait(1)
        end
        task.Wait(120)
        cleft.close(self)
    end)
end
function cleft:frame()
    task.Do(self)
    local len = 0.5*cleft.getLength(self)
    self.x, self.y = self.trail_x + len*self._dx, self.trail_y + len*self._dy
    if self.timer >= 30 then
        for _, obj in ObjList(GROUP_ENEMY_BULLET) do
            if isInRect(obj, self.x, self.y, self.rot, 2*self.a, 2*self.b) then
                Del(obj)
            end
        end
    end
end
function cleft:render()
    local img = cleft_imgs[1 + math.floor(self.timer/2)%21]
    SetImageState(img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function cleft:close()
    task.New(self, function()
        self.colli = true
        local t = 20
        local dh, db, s = -self.vscale/t, -2*self.b/t, cleft.getWide(self)
        local d_db = -db/t
        local v = 2*s/t
        local dv = -v/t
        PlaySound("kira00")
        for _ = 1, t do
            cleft.pull(self, v)
            v = v + dv
            self.vscale = self.vscale + dh
            self.b = self.b + db
            db = db + d_db
            task.Wait(1)
        end
        self.status = "del"
    end)
end
function cleft:kill()
    self.status = "normal"
    self.colli = false
    task.New(self, function()
        task.clear(self, true)
        local t = 20
        local dh = -self.hscale/t
        for _ = 1, t do
            self.vscale = self.vscale + dh
            task.Wait(1)
        end
        self.status = "del"
    end)
end
function cleft:colli(other)
    if other.group == GROUP_ENEMY_BULLET  then
        Del(other)
    end
end
function cleft:getLength()
    return self.hscale*450
end
function cleft:getWide()
    return self.vscale*20
end
--消除、拉近
function cleft:pull(v)
    local dx, dy, len, dl, dh, u = v*cos(self.rot + 90), v*sin(self.rot + 90), cleft.getLength(self)
    local function pull(obj)
        dl, dh = EGGlib.Math.getLineProjection(obj.x, obj.y, self.trail_x, self.trail_y, self.rot) --point_x, point_y, line_center_x, line_center_y, line_rot
        u = -sign(dh)
        if dl >= 0 and dl <= len then
            obj.x, obj.y = obj.x + dx*u, obj.y + dy*u
        end
    end
    local function pullOtherCleft(obj)
        if obj ~= self and obj.trail_x and obj.trail_y then
            dl, dh = EGGlib.Math.getLineProjection(obj.x, obj.y, self.trail_x, self.trail_y, self.rot) --point_x, point_y, line_center_x, line_center_y, line_rot
            u = -sign(dh)
            if dl >= 0 and dl <= len then
                obj.trail_x, obj.trail_y = obj.trail_x + dx*u, obj.trail_y + dy*u
            end
        end
    end
    for _, obj in ObjList(GROUP_ENEMY_BULLET) do
        pull(obj)
    end
    for _, obj in ObjList(GROUP_INDES) do
        pullOtherCleft(obj)
    end
    if IsValid(_boss) then
        dl, dh = EGGlib.Math.getLineProjection(_boss.x, _boss.y, self.trail_x, self.trail_y, self.rot)
        if abs(dh) > 2*self.b then --boss并不会被吸入
            pull(_boss)
        end
    end
    pull(player)
end


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local purple_arrow_small_list = {} --要消除的紫弹列表
    --region Bullet 自定义子弹
    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            900, 10, 20, 10, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            30 --disappear
                    )
                    obj._blend = "mul+add"
                    obj.bound = false
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )

    --与时停有关的弹幕
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case:弹射出去飞的距离
                local s = 20
                local v = switch1(diff, {
                    1.25, 1.5, 1.5, 2, 2
                })*defaultSwitchVelocityByRank(rank)
                local dv0 = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local function create(x, y, dv, a, i, t)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_small, COLOR_YELLOW)
                    obj.timeStop = false --时停你就别动了！
                    obj.vx, obj.vy = EGGlib.Math.TranRot(dv0*i, 0, a + 90)
                    obj.vx, obj.vy = obj.vx + (v + dv)*cos(a), obj.vy + (v + dv)*sin(a)
                    obj.velocity, obj.angle = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy)
                    obj.rot = obj.angle
                    obj.vx, obj.vy = 0, 0
                    task.New(obj, function()
                        obj.vx, obj.vy = EGGlib.Math.TranRot(dv0*i, 0, a + 90)
                        local v0 = 2*s/t - 0.1
                        velchTask(obj, v0, 0, a, t)
                        local dvx, dvy = -obj.vx/t, -obj.vy/t
                        for _ = 1, t do
                            obj.vx, obj.vy = obj.vx + dvx, obj.vy + dvy
                            task.Wait(1)
                        end
                        while true do
                            if obj.timeStop then
                                obj.x, obj.y = obj.x - obj.vx, obj.y - obj.vy
                            end
                            task.Wait(1)
                        end
                    end)
                end
                return create
            end
    )

    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v0, v1, a0, t0, t1, style, color)
                    local obj = stg.newBullet(x, y, style, color)
                    obj.timeStop = false --时停你就别动了！
                    obj.rot = a0
                    obj.velocity, obj.angle = v1, a0
                    task.New(obj, function()
                        velch(obj, v0, v1, a0, t0, t1)
                        while true do
                            if obj.timeStop then
                                obj.x, obj.y = obj.x - obj.vx, obj.y - obj.vy
                            end
                            task.Wait(1)
                        end
                    end)
                    table.insert(purple_arrow_small_list, obj)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local layer = switch1(diff, {
                    1, 2, 2, 2, 2
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local dv = switch1(diff, {
                    0.2, 0.15, 0.4, 0.5, 0.5
                })
                local function attack(x, y, a, i, t)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for j = 0, layer - 1 do
                                    B.bullet1.create(x, y, dv*j, a, i, t)
                                end
                            end)
                end
                return attack
            end
    )

    --只是简单的少way开花弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --一个子弹单元way数
                local way = switch1(diff, {
                    1, 2, 2, 3, 3
                })
                local tmax = 30
                local da = 360/way
                local layer = switch1(diff, {
                    1, 2, 3, 3, 1
                })
                --case:初始低速匀速阶段的速度
                local v00 = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.1
                })
                local v0 = switch1(diff, {
                    1.5, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0, 0.5, 0.5, 0.75, 0.75
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_small
                local color = COLOR_PURPLE
                local function attack(x, y, t, a)
                    PlaySound("kira00")
                    local a0, dx, dy, v, dt
                    dt = tmax - t
                    for i = 0, way - 1 do
                        a0 = a + da*i
                        dx, dy = dt*v00*cos(a0), dt*v00*sin(a0)
                        for j = 0, layer - 1 do
                            v = v0 + dv*j
                            B.bullet2.create(x + dx, y + dy, v00, v, a0, 60, t, style, color)
                        end
                    end
                end
                return attack
            end
    )

    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_big, COLOR_RED
                local layer = 1
                local v = switch1(diff, {
                    1.25, 1.25, 1.25, 1.25, 1.25
                })*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, v0, dv, a, t)
                    local function bullet_func(x, y, v, a)
                        stg.setBoundTime(B.bullet2.create(x, y, v0, v + dv, a, 40, t, style, color), 60)
                    end
                    PlaySound("kira00")
                    if Dist(x, y, player.x, player.y) > 50 then
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v, a, 1, layer, dv, 0, 0, bullet_func)
                                end, true)
                    end
                end
                return attack
            end
    )

    --直接发射的多层大玉
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --一个子弹单元way数
                local way = switch1(diff, {
                    24, 10, no_info, no_info, no_info
                })
                local da = 360/way
                local layer = switch1(diff, {
                    2, 4, no_info, no_info, no_info
                })
                local dway = switch1(diff, {
                    20, 10, no_info, no_info, no_info
                })
                local v = switch1(diff, {
                    1.5, 1.5, no_info, no_info, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.5, 0.5, no_info, no_info, no_info
                })*switch(rank, {
                    1, 1.1, 1.2, 1.3, 1.5
                })
                local style, color = stg.ball_huge, COLOR_RED
                local function bullet_func(x, y, v, a)
                    robject.set_color(stg.newSimpleStraight(x, y, v, a, style, color), "mul+add", 255, 255, 255, 255)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v + dv*(layer - 1), a + 0.5*da, way, layer, -dv, 0, dway, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local main
                if diff < 3 then --EN
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local x, y, rot
                                        for i = -1, 1 do
                                            x, y, rot = 275*u, 20 + 90*i, 90*(1+u)
                                            for u = -1, 1 do
                                                B.warning_laser.create(x - 15*u*sin(rot), y + 15*u*cos(rot), rot)
                                            end
                                            task.Wait(20)
                                            New(cleft, x, y, rot, 1.25, 1)
                                            for u0 = -1, 1, 2 do
                                                T.tasker2.main(b, x - 20*sin(rot)*u0, y + 20*cos(rot)*u0, rot, -u0)
                                            end
                                        end
                                        Del(obj)
                                    end)
                                end, true) --iswait
                    end
                else --HL
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local a0, x0, y0, len, a, rot = Angle(player, b), player.x, player.y, 0.5*Dist(player, b)
                                        local x, y
                                        for i = -1, 1 do
                                            a = a0 + (80*i - 30)*u
                                            rot = a + 120*u
                                            x, y = x0 + len*cos(a) - 360*cos(rot), y0 + len*sin(a) - 360*sin(rot)
                                            for u = -1, 1 do
                                                B.warning_laser.create(x - 15*u*sin(rot), y + 15*u*cos(rot), rot)
                                            end
                                            task.Wait(20)
                                            New(cleft, x, y, rot, 1.75, 1.5)
                                            for u0 = -1, 1, 2 do
                                                T.tasker2.main(b, x - 20*sin(rot)*u0, y + 20*cos(rot)*u0, rot, -u0)
                                            end
                                        end
                                        Del(obj)
                                    end)
                                end, true) --iswait
                    end
                end
                return main
            end)

    --黄苦无
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --每帧产生的子弹数
                local n = switch1(diff, {
                    2, 3, 3, 3, 3
                })
                --速度
                local v = switch1(diff, {
                    40, 40, 50, 40, 40
                })/n
                local function main(b, x, y, a, u)
                    boss.createTasker(b, x, y,
                            function(obj)
                                obj.bound = false
                                local dx, dy = v*cos(a), v*sin(a)
                                task.New(obj, function()
                                    for i = -10, 10 do
                                        for j = 0, n - 1 do
                                            P.pointer1.attack(obj.x, obj.y, a - 90*u, (i + j/n)*u, 10 - i + 20)
                                            obj.x, obj.y = obj.x + dx, obj.y + dy
                                        end
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --甩出的蓝紫苦无
    T.tasker3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    10, 20, 4, 5, 5
                })
                local way = switch1(diff, {
                    1, 1, 3, 3, 3
                })
                local da_way = 60/way
                local tmax = 30
                local wait = switch1(diff, {
                    2, 1, 2, 2, 2
                })
                local r0 = switch1(diff, {
                    30, 30, 100, 100, 100
                })
                local dr = switch1(diff, {
                    120, 120, 0, 0, 0
                })/(count - 1)
                local n = switch1(diff, {
                    6, 6, 3, 3, 3
                })
                local function main(b, a, u, co, dy)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local x, y, r, a0 = b.x + ran:Float(-5, 5), b.y + ran:Float(-5, 5)
                                    local da0 = 150/count*u
                                    for i = 0, count - 1 do
                                        r = r0 + dr*i
                                        for j = 1, way do
                                            a0 = a + da0*i + da_way*j*u
                                            P.pointer2.attack(x + r*cos(a0), y + r*sin(a0) + dy, tmax - wait*i, a0 - n*da0*i)
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --甩出的中玉
    T.tasker4 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local v0 = 3
                local way = switch1(diff, {
                    20, 20, 24, 30, 30
                })
                local function main(b, x0, y0, dv, a, u, dway)
                    local way = way + dway
                    local wait = 1
                    local da = 360/way
                    local r, dr = -60*v0, wait*v0
                    local da = da*u
                    boss.createTasker(b, x0 + r*cos(a), y0 + r*sin(a),
                            function(obj)
                                obj.bound = false
                                task.New(obj, function()
                                    for i = 0, way - 1 do
                                        obj.x, obj.y = x0 + r*cos(a), y0 + r*sin(a)
                                        P.pointer3.attack(obj.x, obj.y, v0, dv, a, (way - i)*wait)
                                        task.Wait(wait)
                                        r = r + dr
                                        a = a + da
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
                local function main(b, u)
                    T.tasker1.main(b, u)
                    task.Wait(50)
                    b.absorbEffect(b, 30, b.x, b.y)
                    PlaySound("alert")
                    New(invert_color_circle, b.x, b.y)
                    --player_class.changeSpeed(player, 0, 0) --禁止移动
                    player_class.lockMovement(player, true) --禁止移动
                    for _ = 1, 90 do
                        for _, v in ObjList(GROUP_ENEMY_BULLET) do
                            v.timeStop = true
                        end

                        task.Wait(1)
                    end
                    PlaySound("alert")
                    for _, v in ObjList(GROUP_ENEMY_BULLET) do
                        v.timeStop = false
                        v.vx, v.ax, v.vy, v.ay = 0, 0, 0, 0
                        if v.velocity and v.angle then
                            velchTask(v, 0, v.velocity, v.angle, 90)
                        end
                    end
                    --player.class.recoveredSpeed(player) --恢复移动
                    player_class.lockMovement(player, false) --恢复移动
                    for k, obj in pairs(purple_arrow_small_list) do
                        if not IsValid(obj) then
                            table.remove(purple_arrow_small_list, k)
                        end
                    end
                    for k, obj in pairs(purple_arrow_small_list) do
                        if IsValid(obj) then
                            _del(obj, true)
                        end
                    end
                end
                return main
            end)


    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --最后一圈攻击的层数
                local layer = switch1(diff, {
                    1, 1, 3, 4, 4
                })
                --速度差
                local dv = switch1(diff, {
                    0.75, 0.75, 0.75, 0.75, 0.75
                })
                --每层way数差
                local dway = switch1(diff, {
                    4, 4, 15, 10, 10
                })
                local wait = 30/layer
                local main
                if diff < 3 then --EN
                    function main(b, u)
                        local dx, dy = 60*u, (180 - b.y)/4
                        local dy2 = -100
                        local d_dy2 = -dy2/3
                        for _ = 1, 2 do
                            T.tasker3.main(b, 90*(1+u) + ran:Float(-5, 5), u, COLOR_PURPLE, dy2)
                            task.MoveTo(b, b.x + dx, b.y + dy, 20, MOVE_ACC_DEC)
                            dx = -dx
                            dy2 = dy2 + d_dy2
                            T.tasker3.main(b, 90*(1-u) + ran:Float(-5, 5), -u, COLOR_BLUE, dy2)
                            task.MoveTo(b, b.x + dx, b.y + dy, 20, MOVE_ACC_DEC)
                            dx = -dx
                            dy2 = dy2 + d_dy2
                        end
                        P.pointer4.attack(b.x, b.y, Angle(b, player))
                        task.Wait(90)
                    end
                else --HL
                    function main(b, u)
                        local dy = 0
                        local d_dy = 50/3
                        for _ = 1, 2 do
                            T.tasker3.main(b, 90*(1-u) + ran:Float(-5, 5), -u, COLOR_BLUE, dy)
                            dy = dy + d_dy
                            task.Wait(10)
                            T.tasker3.main(b, 90*(1+u) + ran:Float(-5, 5), u, COLOR_PURPLE, dy)
                            dy = dy + d_dy
                            task.Wait(10)
                        end
                        for i = 0, layer - 1 do
                            T.tasker4.main(b, b.x, b.y, dv*i, 90*(1+u), -u, dway*(layer - 1 - i))
                            task.Wait(wait)
                        end
                        task.Wait(70)
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
    
    local names = {
        "name-boss7-card3-E",
        "name-boss7-card3-N",
        "name-boss7-card3-H",
        "name-boss7-card3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
            2400, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                if difficulty < 3 then
                    task.MoveTo(b, 0, 180, 60, MOVE_ACC_DEC)
                else
                    task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                end
                PlaySound("wolf")
            end,
            function(b) --练习模式攻击前动作
                if difficulty < 3 then
                    b.x, b.y = 0, 180
                else
                    b.x, b.y = 0, 144
                end
                boss.show_aura(b, true)
                PlaySound("wolf")
            end,
            function(b) --main
                purple_arrow_small_list = {} --要消除的紫弹列表
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                        C.SECOND.main(b, u)
                    end
                end
            end,
            function(b) --finish
                --player.class.recoveredSpeed(player)
                player_class.lockMovement(player, false)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
