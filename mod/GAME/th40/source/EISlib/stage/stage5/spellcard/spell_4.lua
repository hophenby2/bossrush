-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/spell_4.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local lead_laser = EISlib.Bullet.Laser.lead_laser
local laser_setRot = EISlib.Bullet.Laser.laser.setRot
local accDecChVTask = EGGlib.ObjectEvent.accDecVelocityChangeTask
local accDecChV = EGGlib.ObjectEvent.accDecVelocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local accDecMoveToPointTask = EGGlib.ObjectEvent.accDecMoveToPointTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local alphaChange = EGGlib.ObjectEvent.alphaChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local omigaChange = EGGlib.ObjectEvent.omigaChange
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local warning_laser = EISlib.Bullet.Laser.warning_laser
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local boundWait = EGGlib.ObjectEvent.boundWait

local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local cleft_imgs = {}
for i = 1, 21 do
    cleft_imgs[i] = boss_name.."cleft"..(i - 1)
end

--拉进弹幕、boss、自机
local cleft = Class(object)
function cleft:init(x, y, rot)
    self.bound = false
    self.trail_x, self.trail_y = x, y
    self.group = GROUP_INDES
    self.layer = LAYER_ENEMY - 2
    self.x, self.y = x, y
    self.colli = false
    self.rot = rot
    self._dx, self._dy = cos(rot), sin(rot)
    robject.set_color(self, "", 255, 255, 255, 255)
end
function cleft:frame()
    task.Do(self)
    local len = 0.5*cleft.getLength(self)
    self.x, self.y = self.trail_x + len*self._dx, self.trail_y + len*self._dy
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
        PlaySound("kira00")
        for _ = 1, t do
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
function cleft:getLength()
    return self.hscale*450
end
function cleft:getWide()
    return self.vscale*20
end

local reFresh
local function createCard(difficulty)
    local small_eye_ball = {}
    local small_eye_stroke = {}
    local mid_eye_ball = {}
    local mid_eye_stroke = {}
    local big_eye_ball = {}
    local big_eye_stroke = {}

    local other_bullets = {} --HL限定，可以被传送的弹幕

    --重置管理这些眼睛的表
    local function resetAll()
        small_eye_ball = {}
        small_eye_stroke = {}
        mid_eye_ball = {}
        mid_eye_stroke = {}
        big_eye_ball = {}
        big_eye_stroke = {}
        other_bullets = {}
    end

    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, 20, 10, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            60 --disappear
                    )
                    obj._blend = "mul+add"
                    obj.bound = false
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )

    --召唤眼睛的黑洞
    B.cleft1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, h, v)
                    local obj = New(cleft, x, y, a)
                    obj.hscale, obj.vscale = 0, v
                    task.New(obj, function()
                        local t = 20
                        local dh = h/t
                        for _ = 1, t do
                            obj.hscale = obj.hscale + dh
                            obj.a = obj.a + 150*dh
                            task.Wait(1)
                        end
                        task.Wait(120)
                        cleft.close(obj)
                    end)
                end
                return create
            end
    )

    --常驻黑洞
    B.cleft2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, h, v, i)
                    local obj = New(cleft, x, y, 0)
                    obj.hscale, obj.vscale = 0, v
                    obj.bound = false
                    obj.num = i --编号
                    task.New(obj, function()
                        local t = 20
                        local dh = h/t
                        for _ = 1, t do
                            obj.hscale = obj.hscale + dh
                            obj.a = obj.a + 150*dh
                            task.Wait(1)
                        end
                        while true do
                            sp.UnitListUpdate(other_bullets)
                            for _, bullet in ipairs(other_bullets) do
                                --正在删除动画的obj和刚被传送的弹幕不参与再次传送计算
                                if not bullet.isDel and not (bullet.isTp and not bullet.bound) and bullet.timer > 11 then
                                    if (obj.y > 0 and bullet.y > obj.y) then
                                        bullet.isDel = true
                                        Del(bullet)
                                    elseif (obj.y < 0 and bullet.y < obj.y) then
                                        if not bullet.isTp then
                                            local b = stg.newStraight(bullet.x, (bullet.y - obj.y) - obj.y, Dist(0, 0, bullet.vx, bullet.vy), bullet.rot, stg.arrow_small, COLOR_DEEP_RED, false, 1)
                                            stg.setBoundTime(b, 60)
                                            b.isTp = true
                                            table.insert(other_bullets, b)
                                        end
                                        bullet.isDel = true
                                        Del(bullet)
                                    end
                                end
                            end
                            task.Wait(1)
                        end
                    end)
                    return obj
                end
                return create
            end
    )

    --眼睛弹幕控制器
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = switch1(diff, {
                    35, 35, 20, 20, 20
                })
                local way = switch1(diff, {
                    28, 28, 20, 20, 20
                })
                local size = 0.6
                local omiga = switch1(diff, {
                    1, 1, 0.25, 0.25, 0.25
                })
                local create
                if diff < 3 then --EN
                    function create(x, y)
                        local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_RED)
                        obj.group = GROUP_GHOST
                        obj.colli = false
                        obj.hide = true
                        --画圆
                        task.New(obj, function()
                            local da = 360/way
                            local way = (way - 1)/2
                            for i = -way, way do
                                table.insert(small_eye_ball, B.bullet4.create(obj, -r*cos(da*i), r*sin(da*i), r, 2*(way - 0.5 - i)))
                                task.Wait(2)
                            end
                            --PlaySound("wolf03")
                        end)
                        --两侧对称的抛物线
                        task.New(obj, function()
                            local way = way
                            local dx = 4*r/(way - 1)
                            way = (way - 1)/2
                            local rate_x = r/(dx*way*dx*way)
                            for i = -way, way do
                                for u = -1, 1, 2 do
                                    table.insert(small_eye_stroke, B.bullet4.create(obj, dx*i*u, (rate_x*dx*i*dx*i - r)*u, r, 2*(way - i)))
                                end
                                task.Wait(2)
                            end
                            PlaySound("wolf02")
                            --重新排序
                            local pos1 --奇数弹幕要被换到的下标
                            local tmp
                            for i = 2, 4*way - 2, 2 do
                                pos1 = 1 + i/2
                                tmp = small_eye_stroke[i + 1]
                                for j = i, pos1, -1 do
                                    small_eye_stroke[j + 1] = small_eye_stroke[j]
                                end
                                small_eye_stroke[pos1] = tmp
                            end
                            task.Wait(45 + 120)
                            omigaChange(obj, 0, 1, 60)
                        end)
                        --绑定boss
                        task.New(obj, function()
                            task.Wait(180)
                            _connect(_boss, obj, 0, true)
                        end)
                        return obj
                    end
                else --HL
                    function create(x, y)
                        local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_RED)
                        obj.group = GROUP_GHOST
                        obj.colli = false
                        obj.hide = true
                        --画圆
                        task.New(obj, function()
                            local da = 360/way
                            local way = (way - 1)/2
                            for i = -way, way do
                                table.insert(small_eye_ball, B.bullet4.create(obj, -r*cos(da*i), r*sin(da*i), r, 2*(way - 0.5 - i), size))
                                task.Wait(2)
                            end
                            PlaySound("wolf03")
                        end)
                        --两侧对称的抛物线
                        task.New(obj, function()
                            local way = way
                            local dx = 4*r/(way - 1)
                            way = (way - 1)/2
                            local rate_x = r/(dx*way*dx*way)
                            for i = -way, way do
                                for u = -1, 1, 2 do
                                    table.insert(small_eye_stroke, B.bullet4.create(obj, dx*i*u, (rate_x*dx*i*dx*i - r)*u, r, 2*(way - i), size))
                                end
                                task.Wait(2)
                            end
                            PlaySound("wolf03")
                            --重新排序
                            local pos1 --奇数弹幕要被换到的下标
                            local tmp
                            for i = 2, 4*way - 2, 2 do
                                pos1 = 1 + i/2
                                tmp = small_eye_stroke[i + 1]
                                for j = i, pos1, -1 do
                                    small_eye_stroke[j + 1] = small_eye_stroke[j]
                                end
                                small_eye_stroke[pos1] = tmp
                            end
                            task.Wait(75 + 120)
                            local domiga = omiga/60
                            omigaChange(obj, 0, omiga, 60)
                            --爆Hyper转速会加快
                            while true do
                                if system.PowerRank.getRank() == 4 then
                                    obj.omiga = min(obj.omiga + domiga, 0.375)
                                else
                                    obj.omiga = max(obj.omiga - domiga, omiga)
                                end
                                task.Wait(1)
                            end
                        end)
                        --绑定boss
                        task.New(obj, function()
                            task.Wait(180)
                            _connect(_boss, obj, 0, true)
                        end)
                        return obj
                    end
                end
                return create
            end
    )

    --眼睛弹幕控制器2
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = switch1(diff, {
                    70, 70, 45, 45, 45
                })
                local way = switch1(diff, {
                    36, 36, 24, 24, 24
                })
                local size = 1.00
                local omiga = switch1(diff, {
                    1, 1, 0.25, 0.25, 0.25
                })
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                    obj.group = GROUP_GHOST
                    obj.colli = false
                    obj.hide = true
                    --画圆
                    task.New(obj, function()
                        local da = 360/way
                        local way = way/2
                        for i = -way, way do
                            table.insert(mid_eye_ball, B.bullet4.create(obj, -r*cos(da*i), r*sin(da*i), r, 2*(way - 0.5 - i), size))
                            task.Wait(2)
                        end
                    end)
                    --两侧对称的抛物线
                    task.New(obj, function()
                        local way = way
                        local dx = 4*r/(way - 1)
                        way = (way - 1)/2
                        local rate_x = r/(dx*way*dx*way)
                        for i = -way, way do
                            for u = -1, 1, 2 do
                                table.insert(mid_eye_stroke, B.bullet4.create(obj, dx*u*i, (rate_x*dx*i*dx*i - r)*u, r, 2*(way - i), size))
                            end
                            task.Wait(2)
                        end
                        --PlaySound("wolf03")
                        --重新排序
                        local pos1 --奇数弹幕要被换到的下标
                        local tmp
                        for i = 2, 4*way - 2, 2 do
                            pos1 = 1 + i/2
                            tmp = mid_eye_stroke[i + 1]
                            for j = i, pos1, -1 do
                                mid_eye_stroke[j + 1] = mid_eye_stroke[j]
                            end
                            mid_eye_stroke[pos1] = tmp
                        end
                        task.Wait(75 + 120)
                        local domiga = -omiga/60
                        omigaChange(obj, 0, -omiga, 60)
                        --爆Hyper转速会加快
                        while true do
                            if system.PowerRank.getRank() == 4 then
                                obj.omiga = max(obj.omiga + domiga, -0.375)
                            else
                                obj.omiga = min(obj.omiga - domiga, -omiga)
                            end
                            task.Wait(1)
                        end
                    end)
                    --绑定boss
                    task.New(obj, function()
                        task.Wait(180)
                        _connect(_boss, obj, 0, true)
                    end)
                    return obj
                end
                return create
            end
    )
    --眼睛弹幕控制器3(HL限定
    B.bullet3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = 150
                local way = 36
                local size = 2
                local omiga = switch1(diff, {
                    no_info, no_info, 0.25, 0.25, 0.25
                })
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                    obj.group = GROUP_GHOST
                    obj.colli = false
                    obj.hide = true
                    --画圆
                    task.New(obj, function()
                        local da = 360/way
                        local way = way/2
                        for i = -way, way do
                            table.insert(big_eye_ball, B.bullet4.create(obj, -r*cos(da*i), r*sin(da*i), r, 2*(way - 0.5 - i), size))
                            task.Wait(2)
                        end
                        --PlaySound("wolf03")
                    end)
                    --两侧对称的抛物线
                    task.New(obj, function()
                        local way = way
                        local dx = 4*r/(way - 1)
                        way = (way - 1)/2
                        local rate_x = r/(dx*way*dx*way)
                        for i = -way, way do
                            for u = -1, 1, 2 do
                                table.insert(big_eye_stroke, B.bullet4.create(obj, dx*u*i, (rate_x*dx*i*dx*i - r)*u, r, 2*(way - i), size))
                            end
                            task.Wait(2)
                        end
                        PlaySound("wolf02")
                        --重新排序
                        local pos1 --奇数弹幕要被换到的下标
                        local tmp
                        for i = 2, 4*way - 2, 2 do
                            pos1 = 1 + i/2
                            tmp = big_eye_stroke[i + 1]
                            for j = i, pos1, -1 do
                                big_eye_stroke[j + 1] = big_eye_stroke[j]
                            end
                            big_eye_stroke[pos1] = tmp
                        end
                        task.Wait(75 + 120)
                        local domiga = omiga/60
                        omigaChange(obj, 0, omiga, 60)
                        --爆Hyper转速会加快
                        while true do
                            if system.PowerRank.getRank() == 4 then
                                obj.omiga = min(obj.omiga + domiga, 0.375)
                            else
                                obj.omiga = max(obj.omiga - domiga, omiga)
                            end
                            task.Wait(1)
                        end
                    end)
                    --绑定boss
                    task.New(obj, function()
                        task.Wait(180)
                        _connect(_boss, obj, 0, true)
                    end)
                    return obj
                end
                return create
            end
    )

    --构成眼睛的弹幕
    B.bullet4 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local create
                if diff < 3 then --EN
                    function create(mst, dx, dy, r0, t)
                        local obj = stg.newBullet(dx, mst.y, stg.ball_mid, COLOR_PURPLE, true, -1)
                        obj.bound = false
                        obj.group = GROUP_GHOST
                        obj.v_rate = Dist(0, 0, dx, dy)/r0
                        robject.set_color(obj, "mul+add", 100, 255, 255, 255)
                        _connect(mst, obj, 1, true)
                        setSizeAndColli(obj, 1, 1)
                        task.New(obj, function()
                            obj.layer = LAYER_ENEMY_BULLET - 1
                            local rot = Angle(0, 0, dx, dy)
                            task.Wait(t)
                            for i = 1, 30 do
                                _set_rel_pos(obj, dx, dy*i/30, rot, true)
                                task.Wait(1)
                            end
                            task.Wait(120)
                            alphaChange(obj, 100, 255, 30)
                            obj.group = GROUP_INDES
                            obj.colli = true
                            while true do
                                _set_rel_pos(obj, dx, dy, rot, true)
                                task.Wait(1)
                            end
                        end)
                        return obj
                    end
                else --HL
                    function create(mst, dx, dy, r0, t, s)
                        local obj = stg.newBullet(dx, mst.y, stg.ball_mid, COLOR_PURPLE,  true, -1)
                        obj.colli = false
                        obj.bound = false
                        obj.group = GROUP_GHOST
                        obj.v_rate = Dist(0, 0, dx, dy)/r0
                        robject.set_color(obj, "mul+add", 100, 255, 255, 255)
                        _connect(mst, obj, 1, true)
                        setSizeAndColli(obj, s, s)
                        task.New(obj, function()
                            obj.layer = LAYER_ENEMY_BULLET - 1
                            local rot = Angle(0, 0, dx, dy)
                            task.Wait(t)
                            for i = 1, 30 do
                                _set_rel_pos(obj, dx, dy*i/30, rot, true)
                                task.Wait(1)
                            end
                            task.Wait(120)
                            alphaChange(obj, 100, 255, 30)
                            obj.group = GROUP_INDES
                            obj.colli = true
                            while true do
                                _set_rel_pos(obj, dx, dy, rot, true)
                                task.Wait(1)
                            end
                        end)
                        return obj
                    end
                end
                return create
            end
    )

    --变向中玉
    B.ball_mid_c = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --这个参数和圆的半径有关，不能受rank影响
                local v = switch1(diff, {
                    2, 2, 2, 2, 3
                })
                local v0 = switch1(diff, {
                    2, 2.25, 2.5, 3, 3
                })*defaultSwitchVelocityByRank(rank)
                local dvc = switch1(diff, {
                    -0.3, -0.25, -0.5, -0.6, -0.6
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, x1, y1, a0, rot)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_mid_c, COLOR_DEEP_RED)
                    boundWait(obj, 180)
                    task.New(obj, function()
                        accDecChV(obj, v, a0, 20, 20, 20)
                        PlaySound("kira00")
                        SetV(obj, dvc, a0)
                        velch(obj, 0, v0, rot, 60)
                    end)

                    --移动到固定点以及渐入效果
                    setSize(obj, 3, 3)
                    robject.set_color(obj, "mul+add", 50, 255, 255, 255)
                    obj.colli = false
                    task.New(obj, function()
                        accDecMoveToPointTask(obj, x1, y1, 40, 0, 20)
                        alphaAndSizeChange(obj, 205, -2, 20)
                        obj._blend = ""
                        obj.colli = true
                    end)
                    return obj
                end
                return create
            end
    )

    --类似非符的中玉
    B.ball_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --这个参数和圆的半径有关，不能受rank影响
                local v = switch1(diff, {
                    1.5, 1.75, 1.25, 1.25, 1.25
                })
                local v0 = switch1(diff, {
                    1.5, 1.75, 1.75, 2, 2
                })*defaultSwitchVelocityByRank(rank)
                local dvc = switch1(diff, {
                    -0.1, -0.1, 0.2, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, x1, y1, a0)
                    local obj = stg.newBullet(x, y, stg.ball_big, COLOR_RED)
                    --移动逻辑
                    task.New(obj, function()
                        accDecChV(obj, v, a0, 20, 20, 20)
                        PlaySound("kira00")
                        SetV(obj, dvc, a0)
                        velch(obj, 0, v0, -90, 60)
                    end)

                    --移动到固定点以及渐入效果
                    setSize(obj, 3, 3)
                    robject.set_color(obj, "mul+add", 50, 255, 255, 255)
                    obj.colli = false
                    task.New(obj, function()
                        accDecMoveToPointTask(obj, x1, y1, 40, 0, 20)
                        alphaAndSizeChange(obj, 205, -2, 20)
                        obj._blend = ""
                        obj.colli = true
                    end)
                    return obj
                end
                return create
            end
    )

    --激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local create
                if diff < 3 then
                    function create(x, y, a, da)
                        local obj = New(lead_laser, 1, COLOR_RED, --type, co
                                x, y, 10, a, --x, y, v, a,
                                450, 30, 30, 1, --len, w0, w1, dt
                                true, false, 180
                        )
                        _connect(_boss, obj, 0, true)
                        --激光转起来了
                        task.New(obj, function()
                            local t = 180
                            da = da/t
                            for _ = 1, t do
                                laser_setRot(obj, a)
                                a = a + da
                                task.Wait(1)
                            end
                        end)
                    end
                else
                    function create(x, y, a)
                        local obj = New(warning_laser,
                                x, y,
                                600, 10, 5, 10, a, --len, l_t, wide, w_t, a
                                "", Color(255, 255, 0, 0), --blend, color
                                45 --disappear
                        )
                        obj._blend = "mul+add"
                        obj.bound = false
                        warning_laser.setTrailLength(obj, 40)
                        _connect(_boss, obj, 0, true)
                        task.New(obj, function()
                            task.Wait(30)
                            local ls = New(lead_laser, 1, COLOR_RED, --type, co
                                    x, y, 10, a, --x, y, v, a,
                                    450, 20, 20, 1, --len, w0, w1, dt
                                    true, false, 60
                            )
                            _connect(_boss, ls, 0, true)
                        end)
                    end
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    --眼眶向外发射弹幕1
    P.small_eye_stroke = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small, COLOR_PURPLE
                local v0 = switch1(diff, {
                    1.25, 1.5, 1.25, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local d = switch1(diff, {
                    3, 2, 2, 1, 1
                })
                local function attack()
                    PlaySound("tan00")
                    for i, obj in ipairs(small_eye_stroke) do
                        if i%d == 0 and IsValid(obj) then
                            stg.newStraight(obj.x, obj.y, v0*obj.v_rate, obj.rot, style, color)
                        end
                    end
                end
                return attack
            end
    )

    --眼眶向外发射弹幕2
    P.mid_eye_stroke = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small, COLOR_PURPLE
                local v0 = switch1(diff, {
                    1.25, 1.5, 1.25, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local d = switch1(diff, {
                    3, 2, 1, 1, 1
                })
                local attack
                if diff < 3 then --EN
                    function attack()
                        PlaySound("tan00")
                        for i, obj in ipairs(mid_eye_stroke) do
                            if  i%d == 0 and IsValid(obj) then
                                stg.newStraight(obj.x, obj.y, v0*obj.v_rate, obj.rot, style, color)
                            end
                        end
                    end
                else --HL
                    function attack()
                    end
                end
                return attack
            end
    )

    --眼眶向外发射弹幕3(HL
    P.big_eye_stroke = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small, COLOR_PURPLE
                local v0 = switch1(diff, {
                    0, 0, 1.5, 1.75, 1.75
                })*defaultSwitchVelocityByRank(rank)
                local d = switch1(diff, {
                    2, 1, 1, 1, 1
                })
                local attack
                if diff < 3 then --EN
                    function attack()
                    end
                else --HL
                    function attack()
                        PlaySound("tan00")
                        for i, obj in ipairs(big_eye_stroke) do
                            if  i%d == 0 and IsValid(obj) then
                                local b = stg.newStraight(obj.x, obj.y, v0*obj.v_rate, obj.rot, style, color, false, 1)
                                stg.setBoundTime(b, 60)
                                table.insert(other_bullets, b)
                            end
                        end
                    end
                end
                return attack
            end
    )

    --眼球向外发中玉自机相关弹1
    P.small_eye_ball = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    6, 6, 8, 10, 10
                })
                local da = 360/way
                local function attack(x1, y1, a0, u)
                    PlaySound("tan00")
                    local a
                    for i = 0, way - 1 do
                        a = a0 + da*i
                        B.ball_big.create(_boss.x + 120*u, _boss.y - 50, x1, y1, a)
                    end
                end
                return attack
            end
    )

    --眼球向外发中玉自机相关弹2
    P.mid_eye_ball = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    6, 9, 9, 12, 12
                })
                local da = 360/way
                local function attack(x1, y1, a0, rot, u)
                    PlaySound("tan00")
                    local a, dx, dy
                    for i = 0, way - 1 do
                        a = a0 + da*i
                        dx, dy = 25*cos(a), 25*sin(a)
                        B.ball_mid_c.create(_boss.x + 120*u, _boss.y - 50, x1, y1, a, rot)
                    end
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.warning_laser = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    local u0
                                    for u = -1, 1, 2 do
                                        B.warning_laser.create(-224*u, 15*u, 90 - 90*u)
                                    end
                                    task.Wait(20)
                                    for i = 0, 6 do
                                        u0 = tranU(i)
                                        for u = -1, 1, 2 do
                                            B.warning_laser.create(-224*u0, (-224 + 20*i)*u, 90 - 90*u0)
                                        end
                                        task.Wait(5)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --垂直中玉攻击（扩张）
    T.small_eye_ball = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {40, 40, 20, 20})
                local a_range = switch1(diff, {
                    0, 0, 10, 10, 10
                })/2
                local function main(u0)
                    boss.createTasker(_boss, 0, 0,
                            function(obj)
                                local x0 = ran:Float(-10, 10)
                                task.New(obj, function()
                                    for u = -u0, u0, u0 do
                                        P.small_eye_ball.attack(x0 + 120*u, 144, -90 + ran:Float(-a_range, a_range), u0)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --垂直中玉攻击（收缩）
    T.mid_eye_ball = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    4, 5, 5, 6, 6
                })
                local wait = 60/count
                local dx = 360/(count - 1)
                local main
                if diff < 3 then --EN
                    local da = switch1(diff, {
                        45, 30, 0, 0, 0
                    })
                    function main(u)
                        boss.createTasker(_boss, 0, 0,
                                function(obj)
                                    task.New(obj, function()
                                        local c = (count - 1)/2
                                        local a0, a = Angle(_boss, player)
                                        for i = -c*u, c*u, u do
                                            a = a0 + da*i
                                            P.mid_eye_ball.attack(_boss.x - 100*cos(a), _boss.y - 100*sin(a), a, a, u)
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                else --HL
                    function main(u)
                        boss.createTasker(_boss, 0, 0,
                                function(obj)
                                    task.New(obj, function()
                                        local c = (count - 1)/2
                                        local x0 = ran:Float(-20, 20)
                                        for i = -c*u, c*u, u do
                                            P.mid_eye_ball.attack(x0 + dx*i, 150, -90, -90, u)
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                end
                return main
            end)

    --endregion
    --region 组合攻击
    --生成眼球
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local x, y = 0, switch1(diff, {
                    100, 100, 0, 0, 0
                })
                local main
                if diff < 3 then --EN
                    function main()
                        resetAll() --先将存储弹幕的表重置一次
                        B.cleft1.create(x - 120, 144, 0, 0.625, 0.5)
                        B.bullet1.create(x, 144)
                        B.bullet2.create(x, 144)
                        --PlaySound("wolf")
                        return {}
                    end
                else --HL
                    function main()
                        resetAll() --先将存储弹幕的表重置一次
                        B.cleft1.create(x - 224, y, 0, 1, 1)
                        --创建一对门
                        B.cleft2.create(x - 336, 180, 1.5, 4, 1)
                        B.cleft2.create(x - 336, -200, 1.5, 3, 2)
                        --创建眼睛
                        local eyes = {}
                        table.insert(eyes, B.bullet1.create(x, y))
                        task.Wait(15)
                        table.insert(eyes, B.bullet2.create(x, y))
                        task.Wait(15)
                        B.bullet3.create(x, y)
                        --PlaySound("wolf")
                        return eyes
                    end
                end
                return main
            end)

    --第一层紫弹
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local main
                if diff < 3 then --EN
                    function main(b)
                        task.New(b, function()
                            while true do
                                reFresh()
                                P.small_eye_stroke.attack()
                                task.Wait(60)
                            end
                        end)
                    end
                else --HL
                    local wait = switch1(diff, {
                        0, 0, 40, 30, 30
                    })
                    function main(b)
                        task.New(b, function()
                            while true do
                                reFresh()
                                P.big_eye_stroke.attack()
                                task.Wait(wait)
                            end
                        end)
                    end
                end
                return main
            end)

    --第一层黄弹
    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    150, 150, 150, 150, 120
                })
                local function main(b)
                    task.New(b, function()
                        local u0
                        for i = 1, _infinite do
                            reFresh()
                            u0 = tranU(i)
                            T.small_eye_ball.main(u0)
                            task.Wait(wait)
                        end
                    end)
                end
                return main
            end)

    --激光
    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local da = switch1(diff, {
                    60, 80, 80, 80, 80
                }) + switch(rank, {
                    0, 0, 0, 0, 5
                })
                local main
                if diff < 3 then --EN
                    function main(b)
                        task.New(b, function()
                            while true do
                                reFresh()
                                for u = -1, 1, 2 do
                                    for i = -1, 1 do
                                        B.laser1.create(0, 144, 10*i + 90*(1+u), da*u)
                                    end
                                    task.Wait(180)
                                end
                            end
                        end)
                    end
                else --HL
                    local way = switch1(diff, {
                        0, 0, 6, 8, 8
                    })
                    local da = 360/way
                    function main(b, eyes)
                        task.New(b, function()
                            while true do
                                reFresh()
                                for i = 0, way - 1 do
                                    B.laser1.create(0, 0, Angle(0, 0, player.x, player.y) + da*(i + 0.5))
                                end
                                task.Wait(180)
                            end
                        end)
                    end
                end
                return main
            end)


    --第二层诱导蓝弹
    C.FIFTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    75, 75, 75, 75, 60
                })*switch1(diff, {
                    2, 2, 1, 1, 1
                })
                local function main(b)
                    task.New(b, function()
                        while true do
                            reFresh()
                            for u = -1, 1, 2 do
                                T.mid_eye_ball.main(u)
                                task.Wait(wait)
                            end
                        end
                    end)
                end
                return main
            end)


    --第二层黄弹
    C.SIXTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local main
                if diff < 3 then --EN
                    function main(b)
                        task.New(b, function()
                            while true do
                                reFresh()
                                P.mid_eye_stroke.attack()
                                task.Wait(60)
                            end
                        end)
                    end
                else --HL
                    function main(b)
                    end
                end
                return main
            end)
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    function reFresh()
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
        for _ = 1, 3 do
            b.absorbEffect(b, 20)
        end
        reFresh()
        effect.shakeScreen(180, 5)

        if difficulty > 2 then
            T.warning_laser.main()
        end
        task.Wait(40)
        b.eyes = C.FIRST.main()
        task.Wait(120)
        PlaySound("wolf")
    end
    
    local names = {
        "name-boss7-card5-E",
        "name-boss7-card5-N",
        "name-boss7-card5-H",
        "name-boss7-card5-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "finalspell", --类型
            {3, 3, 70}, --时间
            3600, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                if difficulty < 3 then
                    task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                else
                    task.MoveTo(b, 0, 169, 60, MOVE_ACC_DEC)
                end
                bossAction(b)
            end,
            function(b) --练习模式攻击前动作
                if difficulty < 3 then
                    b.x, b.y = 0, 144
                else
                    b.x, b.y = 0, 169
                end
                boss.show_aura(b, true)
                b.show_backlight()
                task.Wait(60)
                bossAction(b)
            end,
            function(b) --main
                task.Wait(180)
                C.SECOND.main(b)
                task.Wait(120)
                C.THIRD.main(b)
                task.Wait(120)
                C.FORTH.main(b, b.eyes)
                task.Wait(120)
                C.FIFTH.main(b)
                task.Wait(210)
                C.SIXTH.main(b)
            end,
            function(b) --finish
                b.close_backlight()
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
