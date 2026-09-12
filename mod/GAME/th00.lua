---=====================================
---TH00
---=====================================

local class = {}
_editor_class["TH00"] = class

local Class = Class
local boss = boss
local task = task
local enemy = enemy
local object = object
local item = item
local sp = sp
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle = Angle
local IsValid = IsValid
local GROUP, LAYER = GROUP, LAYER
local SetImageState = SetImageState
local Render = Render
local lstg = lstg

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th00_0", true, 0, 0, 0, 0, -0.07, 0, "", 1, 1, function(l)
        --BOSS 战已经来到宇宙，把云层染成星云色
        l.r, l.g, l.b = 96, 132, 200
    end)
end


--============================
--道中敌机
--============================
do
    --小妖精：移动到指定位置后瞄准自机三连射，再向下离场
    class.th00_fairy = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 8, 10, false)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 70, 2)
                task.New(self, function()
                    for _ = 1, 3 do
                        local A = Angle(self, player)
                        for i = -1, 1 do
                            NewSimpleBullet(ball_mid, 2, self.x, self.y, 2, A + i * 12)
                        end
                        PlaySound("tan00", 0.05, self.x / 200, true)
                        task.Wait(40)
                    end
                end)
                object.ChangingV(self, 0, 2.4, -90, 60, false)
                task.Wait(180)
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 2, self.x, self.y)
        end
    })

    --编队妖精：斜向切入后停留，打出一圈弹幕再从上方离场
    class.th00_wave = Class(enemy, {
        init = function(self, x, y, mx, my, a)
            enemy.init(self, 9, 40, false)
            self.x, self.y = x, y
            self.protect = true
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                self.protect = false
                for w = 1, 2 do
                    for b in sp.math.AngleIterator(a, 10) do
                        NewSimpleBullet(ball_mid_c, 3, self.x, self.y, 1.5, b + w * 5)
                    end
                    PlaySound("tan00", 0.06, 0, true)
                    task.Wait(50)
                end
                object.ChangingV(self, 0, 4, 90, 90, false)
                task.Wait(120)
                if IsValid(self) then
                    object.RawDel(self)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 5, self.x, self.y)
        end
    })

    --中型妖精：中央停留，环形弹幕，再从上方离场
    class.th00_mid = Class(enemy, {
        init = function(self, x, y, mx, my, a)
            enemy.init(self, 12, 150, false)
            self.x, self.y = x, y
            self.protect = true
            task.New(self, function()
                task.MoveTo(mx, my, 80, 2)
                self.protect = false
                for w = 1, 3 do
                    for b in sp.math.AngleIterator(a + w * 20, 14) do
                        NewSimpleBullet(ball_mid, 5, self.x, self.y, 1.8, b)
                    end
                    PlaySound("kira00", 0.08, 0, true)
                    task.Wait(60)
                end
                task.Wait(60)
                object.ChangingV(self, 0, 4, 90, 90, false)
                task.Wait(120)
                if IsValid(self) then
                    object.RawDel(self)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 8, self.x, self.y)
        end
    })
end


--============================
--大气层预设弹（纯表演，无判定）
--与背景云层严格同速下坠，看起来像钉在天空中
--============================
class.th00_sky_bullet = Class(object, {
    init = function(self, img, x, y, size, k, a, r, g, b)
        self.img = img
        self.x, self.y = x, y
        self.group = GROUP.GHOST
        self.layer = LAYER.ENEMY_BULLET - 30
        self.colli = false
        self.bound = false
        self.rot = -90
        self.hscale, self.vscale = size or 1, size or 1
        self.k = k or 1
        self._a = a or 255
        self._r, self._g, self._b = r or 255, g or 255, b or 255
        self.vy = 0
    end,
    frame = function(self)
        --每帧从云层读取速度：背景多快，子弹就多快
        local bg = TH00_bg.current
        self.vy = -((bg and bg.speed) or 1.2) * self.k
        if self.y < lstg.world.boundb - 90 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        SetImageState(self.img, "mul+add", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
})

boss.Define("1a", "未命名Boss", "TH00_0", TH00_bg_space, { 0, 300 }, class["SCBG1"], "Rumia", 20)
do
    local non1 = boss.card.New("", 1, 1, 60, 600)
    boss.card.add({ { non1, "1a" } }, 20, "非符一", 243)
    function non1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non1:init()
        task.New(self, function()
            task.Wait(60)
        end)
    end
end
