--祈华梦ex道中boss
s7_mid_boss = {}
local path = "EISlib/stage/stage5/"
--boss相关的素材全部在以下脚本文件里
Include(path.."Jinguuji_boss.lua")

--五boss蓄力特效
local eff, dark_eff, bkeff, laser_eff = s5_boss.eff, s5_boss.dark_eff, s5_boss.bkeff, s5_boss.laser_eff
--五boss默认的随机x朝向自机移动函数
local move_rd
do
    function move_rd(t, y0, dy, self)
        y0 = y0 or 144
        dy = dy or 25
        if self then
            task.New(self, function()
                task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
            end)
        else
            task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
        end
    end
end
--ex面boss自带的鬼火
local ghost_fire = Class(enemy)
function ghost_fire:init(x, y, st, co)
    enemy.init(self, st, 60, false, true, false, nil, co, 0, 1, true)
    self.x, self.y = x, y
    self.group = GROUP_NONTJT
    self.deathBullet = function() end --死尸弹
end
--红鬼火死尸弹
function ghost_fire:kill()
    enemy.kill(self)
    self.deathBullet(self)
end

--[[local _deathChecker = Class(object)
function _deathChecker:init()

end
function _deathChecker:frame()
    task.Do(self)
end]]


local lscSpecialEvent = Class(object)
function lscSpecialEvent:init(mst)
    self.hide = true
    self.colli = false
    self.bound = false
    self.mst = mst
    self.mst.playerIsDeath = false
    if ext.sc_pr then
        self.status = "del" -- 符卡练习就不需要了
    else
        self.open = true -- 标记自己处于正常运行状态
        self.done = false -- 是否已经执行过一次
        lstg.tmpvar._last_spell_host_instance = self -- 提供给UI
        self.mst = mst
        self.player_death = player.death
        self.player_shield = player.shield -- 专门针对魔理沙罩子情况
        --self.bomb_num = lstg.var.bomb
        self.disp_times = 0 -- 延迟消失计数器
        if IsValid(player.shield_high) then
            player.shield_high.over = true -- 开启LSC时强制移除魔理沙的无敌罩子
        end
        player.lockspell = 2 --不允许放雷
    end
end
function lscSpecialEvent:frame()
    if self.open then
        -- 只有自己处于正常运行状态才执行以下逻辑
        task.Do(self)
        -- 延迟处理功能，在boss死亡后的一段时间里面都继续执行一些逻辑
        if IsValid(self.mst) then
            self.disp_times = 0
            player.lockspell = 2 --不允许放雷
        else
            self.disp_times = self.disp_times + 1
        end
        if player.death > 0 then
            if IsValid(self.mst) then
                self.mst.playerIsDeath = true
            end
            Del(self)
        end
        if self.disp_times > 2 then
            self.status = "del"
        else
            -- 清空符卡分已经写进自机的colli里面
            -- 但是掉落物清空得写在这
            if player.death > self.player_death then
                boss.ClearBonus(false, false, true)
            end
            if not self.done then
                if (player.death >= 90) then
                    player.death = 0 -- 死者回生
                    if IsValid(self.mst) then
                        boss.ClearBonus(false, false, true)
                        self.mst.hp = 0
                        self.done = true
                    end
                elseif (self.player_shield ~= player.shield) then
                    if IsValid(self.mst) then
                        boss.ClearBonus(false, false, true)
                        self.mst.hp = 0
                        self.done = true
                    end
                end
            end
        end
    end
end
--特殊的符卡工具人
local function deathChecker(self)
    self.playerIsDeath = false
    return New(tasker, function()
        while true do
            if player.death > 0 then
                break
            end
            task.Wait(1)
        end
        if IsValid(self) then
            player.death = 0
            self.playerIsDeath = true
            Kill(self)
        end
    end)
end


local function accbullet(st, co, x, y, v, a, t)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end

local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出
local function boss_show(self, x, y, IsDialog)
    self.aura_alpha = 0
    boss.show_aura(self, false)
    task.Wait(60)
    x, y = x or 0, y or 144
    task.MoveTo(0, 144, 60, MOVE_DECEL)
    if not IsDialog then
        boss.show_aura(self, true)
    end
end
local function boss_scpr_show(self, x, y)
    boss.show_aura(self, false)
    for _ = 1, 3 do
        eff(x, y, 20)
    end
    task.Wait(20)
    self.x, self.y = x, y
    boss.show_aura(self, true)
end

--一之力「手玉玲珑」
local function boss_sc1_normal_show(self)
    task.MoveTo(0, 144, 90, MOVE_NORMAL)
    task.Wait(60)
    if EISlib.stage.canDialog() then
        dialog.cacheResource("StageEX_mid")
        dialog.player.playScene("StageEX_mid", true)
        task.Wait(60)
    end
    for _ = 1, 3 do
        eff(self.x, self.y, 20)
    end
    boss.show_aura(self, true)
end
local function boss_sc1_scpr_show(self)
    boss_scpr_show(self, 0, 144)
    self.sc_bonus_max = 20000000
    self.sc_bonus_base = 20000000
end
local function boss_sc1(self)
    if not ext.sc_pr then
        _connect(self, deathChecker(self), 0, true)
    end
    self.lscEvent = _connect(self, New(lscSpecialEvent, self))

    local f1, f1_1, f1_2, f2, f2_1
    do
        --绿光玉的中心
        function f1(x, y, vx, n, u)
            PlaySound("kira00")
            local obj = stg.newBulletStraight(stg.grain_a, 10, true, x, y, 0, 0)
            obj.hide = true
            obj.bound = false
            obj.colli = false
            obj.angle = 0 --这个不是真的角度啊，是相位！
            obj.range = 0 --半径
            --创建旋转绿光玉
            local d = 360/n
            for i = 1, n do
                f1_1(obj, d*i)
            end
            --相位和半径的变化
            local da, dr = 1.75*u, 0
            task.New(obj, function()
                local dda, ddr = -1/60*u, 0.75/60
                for _ = 1, 60 do
                    da = da + dda
                    dr = dr + ddr
                    task.Wait(1)
                end
                dda = 0.4*dda
                for _ = 1, 300 do
                    da = da + dda
                    --dr = dr + ddr
                    task.Wait(1)
                end
            end)
            --相位和半径更新
            task.New(obj, function()
                while true do
                    obj.angle = obj.angle + da
                    obj.range = obj.range + dr
                    task.Wait(1)
                end
            end)
            --自身移动
            task.New(obj, function()
                egg.AddAccDecChV(obj, vx, 0, 60, 60, 60)
                egg.AddAccDecChV(obj, 2.5, -90, 30, 30, 60)
                egg.AddSimStrChV(obj, -2, 0.5, -90, 60)
                while self.y > -300 do
                    task.Wait(1)
                end
                obj.bound = true
            end)
        end
        --绿光玉
        function f1_1(mst, a)
            local obj = stg.newBulletStraight(stg.ball_light, 10, true, mst.x, mst.y, 0, 0)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 90)
            f1_2(obj) -- 创建子鬼火
            --负责转就完事了
            task.New(obj, function()
                local t = 0
                local v, a0 = 4
                while true do
                    if IsValid(mst) then
                        a0 = a + mst.angle
                        obj.x, obj.y = mst.x + mst.range*cos(a0), mst.y + 0.25*mst.range*sin(a0)
                    else
                        Kill(obj)
                    end
                    if t > 60 and t % 5 == 0 then
                        PlaySound("tan00")
                        stg.newBulletStraight(stg.grain_a, 10, true, obj.x, obj.y, v, a0)
                        v = max(1, v - 0.025)
                    end
                    task.Wait(1)
                    t = t + 1
                end
            end)
        end
        --绿鬼火
        function f1_2(mst)
            local obj = New(ghost_fire, mst.x, mst.y, 24, 3)
            if IsValid(self) then
                _connect(self, obj, 0, true)
            else
                Del(self)
            end
            --判断主人
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y = mst.x, mst.y
                    task.Wait(1)
                end
                Del(obj)
            end)
            --死尸弹
            obj.deathBullet = function()
                local a = Angle(obj, player)
                for _ = 1, 6 do
                    stg.newBulletStraight(stg.arrow_small, 9, true, obj.x, obj.y, ran:Float(1, 2), a + ran:Float(-30, 30))
                end
            end
        end
        --正常的甩札弹
        function f2(u1, la)
            if u1 == 1 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            local a, da, r, dr, dx, dy
            for u = u1, -u1, -2*u1 do
                a, da = -90 + 60*u, -180/15*u
                r, dr = 30, 90/15
                for _ = 1, 15 do
                    a = a + da
                    r = r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    for i = 0, la do
                        f2_1(self.x + dx, self.y + dy, 0.5*i, a + 75*u)
                        f2_1(self.x + dx, self.y + dy, 2, a + (75 + 120)*u, 0) --这波是往头上打的，主要是防一波内避
                    end
                    task.Wait(2)
                    PlaySound("tan00")
                end
                task.Wait(10)
            end
        end
        --札弹
        function f2_1(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.square, 1, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 20)
            task.New(obj, function()
                task.Wait(15)
                PlaySound("kira00")
                egg.AddAccDecChV(obj, -1.25 - dv, a, 40, 30, 30)
                task.Wait(240)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1, a, 60)
            end)
        end
    end

    do
        --测试用对象，整合完毕后请务必删除！！！！
        --New(egg.updateFileObject, "EISlib/stage/stage7/s7_mid_boss_defined.lua")
        s5_boss.pic_show()
        task.Wait(90)
        self.colli = false
        egg.SimAlpCh(self, 255, 100, 60)
        eff(self.x, self.y, 60)
        local frame = 120
        local la = 2
        while true do
            for u = -1, 1, 2 do
                f1(self.x, self.y, ran:Float(-0.25, 0.25), 16, u)
                task.Wait(frame)
                f2(u, la)
                eff(self.x, self.y, 60)
                frame = max(frame - 20, 0)
                la = la + 1
            end
        end
    end
end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})
--二之力「涅槃不死」
local function boss_sc2_normal_show(self)
    egg.SimAlpCh(self, 100, 255, 30)
    task.Wait(30)
    self.colli = true
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc2_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc2(self)
    if not ext.sc_pr then
        _connect(self, deathChecker(self), 0, true)
    end
    self.lscEvent = New(lscSpecialEvent, self)
    local f1, f1_1, f1_2, f1_3, f1_4
    do
        function f1(u1, n)
            if u1 == 1 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            local a, da, r, dr, dx, dy
            for u = u1, -u1, -2*u1 do
                a, da = -90 + 60*u, -180/15*u
                r, dr = 30, 90/15
                for _ = 1, 15 do
                    a = a + da
                    r = r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    for i = 0, 3 + n do
                        f1_4(self.x + dx, self.y + dy, 0.5*i, a + 75*u)
                        f1_4(self.x + dx, self.y + dy, 2, a + (75 + 120)*u, 0) --这波是往头上打的，主要是防一波内避
                    end
                    for i = 0, n do
                        f1_1(self.x, self.y, 0.2*i, a + 180*u, -u)
                    end
                    task.Wait(2)
                    PlaySound("tan00")
                end
                task.Wait(10)
            end
        end
        --红光玉
        function f1_1(x, y, dv, a, u)
            local obj = stg.newBulletStraight(stg.ball_light, 1, true, x, y, 0, 0)
            if IsValid(self) then
                _connect(self, obj, 0, true)
            else
                Del(self)
            end
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.AddSimStrChV(obj, 3, 1.5 + dv, a, 30)
            task.New(obj, function()
                egg.SimSizeCh(obj, 3, 0, 60)
                egg.SimAlpCh(obj, 0, 200, 30)
                task.Wait(30)
                local v, a = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy)
                f1_2(obj.x, obj.y, v, v + 1, a, 90*u)
                egg.SimAlpCh(obj, 200, 0, 30)
                Del(obj)
            end)
        end
        --红鬼火
        function f1_2(x, y, v0, v1, a0, da)
            local obj = New(ghost_fire, x, y, 20, 1)
            if IsValid(self) then
                _connect(self, obj, 0, true)
            else
                Del(self)
            end
            egg.ChV(obj, v0, v1, a0, da, 180, 180)
            obj.bound = true
            --攻击
            task.New(obj, function()
                for _ = 1, 3 do
                    f1_3(obj.x, obj.y, Angle(obj.vx, obj.vy, 0, 0))
                    PlaySound("tan00")
                    task.Wait(20)
                end
                for _ = 1, 9 do
                    --f1_3(obj.x, obj.y, Angle(obj.vx, obj.vy, 0, 0))
                    stg.newBulletStraight(stg.arrow_big, 10, true, obj.x, obj.y, 1, Angle(obj, player) + ran:Float(-2, 2))
                    PlaySound("tan00")
                    task.Wait(20)
                end
            end)
            --[[判断主人
            task.New(obj, function()
                while IsValid(self) do
                    task.Wait(1)
                end
                Del(obj)
            end)]]
            --死尸弹
            obj.deathBullet = function()
                local a = Angle(obj, player)
                for _ = 1, 6 do
                    stg.newBulletStraight(stg.arrow_small, 1, true, obj.x, obj.y, ran:Float(1, 2), a + ran:Float(-30, 30))
                end
            end
        end
        --红色滞留弹
        function f1_3(x, y, a)
            local obj = stg.newBulletStraight(stg.square, 4, true, x, y, 0.1, a)
            egg.AddSimStrChV(obj, 0, 1, a, 120, 60)
        end
        --札弹
        function f1_4(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.square, 5, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 20)
            task.New(obj, function()
                task.Wait(15)
                PlaySound("kira00")
                egg.AddAccDecChV(obj, -1.25 - dv, a, 40, 30, 30)
                task.Wait(240)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 0.5, a, 60)
            end)
        end
    end

    do
        --New(egg.updateFileObject, "EISlib/stage/stage7/s7_mid_boss_defined.lua")
        s5_boss.pic_show()
        task.Wait(90)
        self.colli = false
        egg.SimAlpCh(self, 255, 100, 60)
        eff(self.x, self.y, 60)
        f1(1, 1)
        --task.Wait(60)
        move_rd(60)
        eff(self.x, self.y, 60)
        f1(-1, 1)
        --task.Wait(60)
        move_rd(60)
        eff(self.x, self.y, 60)
        f1(1, 2)
        --task.Wait(60)
        move_rd(60)
        eff(self.x, self.y, 60)
        f1(-1, 3)
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})
--三之力「盈虚祝祷」
local function boss_sc3_normal_show(self)
    egg.SimAlpCh(self, 100, 255, 30)
    task.Wait(30)
    self.colli = true
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc3_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc3(self)
    if not ext.sc_pr then
        _connect(self, deathChecker(self), 0, true)
    end
    self.lscEvent = New(lscSpecialEvent, self)
    local f1, f1_1, f1_2, f1_3, f1_4, f1_5, f3, f4
    do
        function f1(u1, n)
            local a, da = ran:Float(0, 360), 360/(12+4*n)
            task.Wait(30)
            if u1 == 1 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            local a, da, r, dr, dx, dy
            for u = u1, -u1, -2*u1 do
                a, da = ran:Float(0, 360), 360/(16+8*n)
                for i = 1, 16 + 8*n do
                    f1_1(self.x, self.y, 0.7, a + da*i)
                end
                a, da = -90 + (90 + 15*(4-n))*u, -(240 + 30*(4-n))/15*u
                r, dr = 30, 90/15
                for _ = 1, 15 do
                    a = a + da
                    r = r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    for i = 0, 4 + n do
                        for u0 = -1, 1 do
                            f1_4(self.x + dx, self.y + dy, 0.25*i, a + 75*u + 7.5*u0)
                        end
                    end
                    task.Wait(2)
                    PlaySound("tan00")
                end
                task.Wait(10)
            end
        end
        --蓝光玉
        function f1_1(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, 0)
            if IsValid(self) then
                _connect(self, obj, 0, true)
            else
                Del(self)
            end
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.AddSimStrChV(obj, 2, 0.8 + dv, a, 30)
            task.New(obj, function()
                egg.SimSizeCh(obj, 2, 0, 60)
                egg.SimAlpCh(obj, 0, 200, 30)
                task.Wait(30)
                local v, a = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy)
                f1_2(obj.x, obj.y, v, a, 160)
                egg.SimAlpCh(obj, 200, 0, 30)
                task.Wait(30)
                Del(obj)
            end)
        end
        --蓝鬼火
        function f1_2(x, y, v, a, t)
            local obj = New(ghost_fire, x, y, 20, 2)
            if IsValid(self) then
                _connect(self, obj, 0, true)
            else
                Del(self)
            end
            egg.AddSimStrChV(obj, 2, v, a, 60)
            obj.bound = true
            --定时变成蓝光玉
            task.New(obj, function()
                while Dist(obj, player) > 50 do
                    task.Wait(1)
                end
                PlaySound("kira00")
                f1_3(obj.x, obj.y, v, a)
                obj.colli = false
                task.Wait(20)
                obj.y = 9999
                Del(obj)
            end)
            --[[判断主人
            task.New(obj, function()
                while IsValid(self) do
                    task.Wait(1)
                end
                Del(obj)
            end)]]
            --死尸弹
            obj.deathBullet = function()
                local a = Angle(0, 0, obj.vx, obj.vy)
                --local a = ran:Float(0, 360)
                for i = 0, 6 do
                    for j = -2, 2 do
                        --stg.newBulletStraight(stg.square, 5, true, obj.x, obj.y, 1.5 + 0.3*i, a + 30*j)
                        f1_5(obj.x, obj.y, 1.5 + 0.3*i, a + 30*j)
                    end
                    --f1_5(obj.x, obj.y, 1.5, a + 22.5*i)
                end
            end
        end
        --超大号蓝光玉
        function f1_3(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, v, a)
            obj.timer = 11
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 30)
            egg.SimSizeCh(obj, 0, 1.5, 30, true)
        end
        --札弹
        function f1_4(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.square, 9, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 20)
            task.New(obj, function()
                task.Wait(15)
                PlaySound("kira00")
                egg.AddAccDecChV(obj, -1.5 - dv, a, 40, 30, 30)
                task.Wait(240)
                PlaySound("kira00")
                --egg.AddSimStrChV(obj, 0, 0.5, a, 60)
            end)
        end
        --炎弹
        function f1_5(x, y, v, a)
            local obj = stg.newBulletStraight(stg.square, 7, true, x, y, 0.5, a)
            --_object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60, 150)
        end
    end

    do
        --New(egg.updateFileObject, "EISlib/stage/stage7/s7_mid_boss_defined.lua")
        s5_boss.pic_show()
        task.Wait(90)
        self.colli = false
        egg.SimAlpCh(self, 255, 100, 60)
        eff(self.x, self.y, 30)
        f1(1, 1)
        move_rd(60)
        eff(self.x, self.y, 30)
        f1(-1, 2)
        move_rd(60)
        eff(self.x, self.y, 30)
        f1(1, 3)
        move_rd(60)
        eff(self.x, self.y, 30)
        f1(-1, 4)
        move_rd(60)
        eff(self.x, self.y, 30)
        f1(1, 5)
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})

-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Jinguuji"
    cls.bgm = "s7"
    cls._bg = function() return stage7_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 224, 256, "Jinguuji", cards, New(s5_boss.scbg), group_name)
        lstg.wis.Jinguuji(self)
    end
    return cls
end
-- 创建一个符卡
local function create_card_class(index, name, timet, hp, dropt, mode, advance)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = advance
    if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            if IsValid(self.lscEvent) then Del(self.lscEvent) end
            self.hscale = 1
            self._wisys:setAction("normal")
            bkeff(self.x, self.y)
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end
    --table.insert(boss_class.cards, _sc)
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个符卡练习
local function create_cardpr_class(index, name, timet, hp, dropt, mode, boss_class)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = true
    --[[if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end]]
    function _sc:init()
        task.New(self,function()
            scs[index][1](self)
        end)
    end
    function _sc:del()
        if IsValid(self.lscEvent) then Del(self.lscEvent) end
        self.hscale = 1
        self._wisys:setAction("normal")
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
    table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards+1, true })
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个正常的演出
local function create_normal_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][2](self)
            elseif mode == "spellcard" then
                scs[index][2](self)
            end
        end)
    end
    return _show
end
-- 创建一个符卡练习的演出
local function create_scpr_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][3](self)
            elseif mode == "spellcard" then
                scs[index][3](self)
            end
        end)
    end
    return _show
end

--boss定义
local stage7mid_boss
do
    stage7mid_boss = create_boss_class("stage7mid_boss", "Lunatic")
    local card_info = {
        {"一之力「手玉玲珑」", {18, 18, 18}, 1000, {0,0,0}, "spellcard", false},
        {"二之力「涅槃不死」", {15, 15, 15}, 1500, {0,0,0}, "spellcard", false},
        {"三之力「盈虚祝祷」", {17.5, 17.5, 17.5}, 800,  {0,0,0}, "spellcard", false},
    }
    stage7mid_boss.cards={}
    local info
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage7mid_boss.cards
    for i = 1, 3 do
        info = card_info[i]
        table.insert(stage7mid_boss.cards, create_normal_show_class(i, info[5]))
        table.insert(stage7mid_boss.cards, create_card_class(i, info[1], info[2], info[3], info[4], info[5], info[6]))
    end
    local _sc = stage7mid_boss.cards[n+2] --定位到一符，玩家no miss就奖雷
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        bkeff(self.x, self.y)
        if not self.playerIsDeath then
            item.DropItem(self.x, self.y, {0, 100, 0})
            _drop_item(item_bomb, 1, self.x, self.y)
        end
    end
    _sc = stage7mid_boss.cards[n+4] --定位到二符，玩家no miss就奖残
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        bkeff(self.x, self.y)
        if not self.playerIsDeath then
            item.DropItem(self.x, self.y, {100, 0, 0})
            _drop_item(item_extend, 1, self.x, self.y)
        end
    end
    _sc = stage7mid_boss.cards[n+6] --定位到三符，玩家no miss就奖残奖分
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        bkeff(self.x, self.y)
        if not self.playerIsDeath then
            _drop_item(item_extend, 1, self.x, self.y)
            item.DropItem(self.x, self.y, {0, 0, 100})
        end
    end

    --最后boss的离场演出
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                boss.show_aura(self, false)
                egg.SimAlpCh(self, 100, 255, 30)
                task.Wait(60)
                if EISlib.stage.canDialog() then
                    dialog.cacheResource("StageEX_mid_after")
                    dialog.player.playScene("StageEX_mid_after", true)
                    task.Wait(60)
                end
                --跑了
                _drop_item(item_bomb, 1, self.x, self.y)
                task.MoveTo(260, 260, 90, MOVE_ACC_DEC)
                Del(self)
            end)
        end
        table.insert(stage7mid_boss.cards,_tmp_sc)
    end
end
_editor_class["stage7mid_boss"] = stage7mid_boss

--符卡练习定义
local stage7mid_bossScpr
do
    stage7mid_bossScpr = create_boss_class("stage7mid_bossScpr", "Extra")
    local card_info = {
        {"一之力「手玉玲珑」", {18, 18, 18}, 1000, {15,15,10}, "spellcard", false},
        {"二之力「涅槃不死」", {15, 15, 15}, 1500, {15,15,10}, "spellcard", false},
        {"三之力「盈虚祝祷」", {17.5, 17.5, 17.5}, 800, {15, 15, 10}, "spellcard", false},
    }
    stage7mid_bossScpr.cards={}
    local info
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage7mid_bossScpr.cards
    --五boss比较特殊，手动插入
    for i = 1, 3 do
        info = card_info[i]
        table.insert(stage7mid_bossScpr.cards, create_scpr_show_class(i, info[5]))
        table.insert(stage7mid_bossScpr.cards, create_cardpr_class(i, info[1], info[2], info[3], info[4], info[5], stage7mid_bossScpr))
    end
end
_editor_class["stage7mid_bossScpr"] = stage7mid_bossScpr

function s7_mid_boss.main()
    local boss = New(_editor_class["stage7mid_boss"], _editor_class["stage7mid_boss"].cards)
    while IsValid(boss) do
        task.Wait(1)
    end
end
