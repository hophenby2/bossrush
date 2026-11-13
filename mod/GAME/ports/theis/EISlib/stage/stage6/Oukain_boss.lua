lstg.wis = lstg.wis or {}
if not s6_boss then s6_boss = {} end --六boss内容表
local path = ""
local _ACT_NONE_AUTO_Oukain, _ACT_CAST_Oukain
local scbg
local small_fairy, big_fairy

--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Oukain_boss"
local texFile = "res/stage/stage6/Oukain_boss.png"
local tex_u, tex_v, tex_n = 220, 220, 9

--加载资源
local function load_res()
    path = "res/stage/stage6/"
    --载入行走图资源
    LoadTexture(tex, texFile)
    --载入背景变化
    LoadImageFromFile("s6_board_ch", path.."s6_board_ch.png")
    --载入出场特效
    LoadImageGroupFromFile("s6_boss_show_eff", path.."s6_boss_show_eff.png", false, 9, 2)
    --boss背后的树桩
    LoadImageGroup("s6_boss_tree", tex, 0, 880, 220, 220, 6, 1)
    LoadImageGroup("s6_boss_tree_up", tex, 0, 1100, 220, 220, 4, 1)
    LoadImageGroup("s6_boss_tree_back", tex, 880, 1100, 220, 220, 4, 1)
    --立绘加载
    LoadImageFromFile("s6boss_pic", path.."s6boss_pic.png")
    --树枝加载
    LoadTexture("s6_branch", path.."s6_branch.png")
    LoadImage("s6_branch_head", "s6_branch", 35, 0, 9, 20)
    LoadImage("s6_branch_body", "s6_branch", 9, 0, 26, 20)
    --酒罐子加载
    LoadTexture("s6_wine", path.."wine.png")
    LoadImage("s6_wine1", "s6_wine", 0, 0, 256, 256, 12, 12)
    LoadImage("s6_wine2", "s6_wine", 256, 0, 256, 256, 12, 12)
    --speed is power!
    LoadTexture("Speed_is_power", path.."Speed_is_power.png")
    LoadImage("powerUp", "Speed_is_power", 0, 0, 577, 99)
    LoadImage("speedUp", "Speed_is_power", 0, 99, 577, 99)
    path = "res/stage/stage6/back_light/"
    --光背加载
    for i = 1, 6 do
        LoadImageFromFile("s6_boss_back_light_p"..i, path.."purple_"..i..".png")
        LoadImageFromFile("s6_boss_back_light_r"..i, path.."red_"..i..".png")
    end
    --符卡背景加载
    path = "res/background/boss6/"
    for i = 1, 3 do
        LoadImageFromFile("s6_boss_scbg"..i, path .. "scbg"..i..".png")
    end
    path = "res/stage/stage5/"
    --樱花特效(五面
    LoadImageFromFile("Cherry_eff", path.."Cherry_eff.png", false, 8, 8)
    --樱花弹(五面
    LoadImageFromFile("Lily_Cherry_bullet", path.."Lily_Cherry_bullet.png", false, 8, 8)
end
load_res()


--通常
do
    local id, anime, list
    local cutFrame = 8
    local wi = {
        ["normal"] = {
            id = { 1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9 },
        },
        ["left"] = {
            id = { 10, 11, 12, 13, 14, 15},
            loop = 4,
        },
        ["right"] = {
            id = { 19, 20, 21, 22, 23, 24},
            loop = 4,
        },
    }
    function _ACT_NONE_AUTO_Oukain(wisys, self, actionCount, actionCountMax)
        self.lr = self.lr or 1
        if self.dx > 0.005 then
            self.lr = min(self.lr + 2, 28)
        elseif self.dx < -0.005 then
            self.lr = max(self.lr - 2, -28)
        end
        if self.lr == 0 then
            if self.dx < 0 then
                self.lr = self.lr - 2
            else
                self.lr = self.lr + 2
            end
        end
        if self.dx == 0 then
            self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
        end
        if abs(self.lr) == 1 then
            list = wi["normal"]
            anime = int(self.ani / cutFrame) % #list.id + 1
            id = list.id[anime]
        elseif self.lr == 28 then
            list = wi["right"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr == -28 then
            list = wi["left"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr > 1 then
            list = wi["right"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        elseif self.lr < -1 then
            list = wi["left"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        end
        return id, hscale, vscale
    end
end
--施法(甩法杖)
local cast
do
    local cutFrame = 8
    local id = { 28, 29, 30, 31, 32, 33}
    function _ACT_CAST_Oukain(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local anime1 = int((actionCount - absorb_max) / cutFrame)
        local n
        if anime < 6 then
            n = anime + 1 --前三帧动画是一定要的
        else
            n = 6
        end
        return id[n], hscale, vscale
    end

    function cast(self)
        self._wisys:setAction("cast", 48)
    end
end
--能力（加速减速恢复原速
local changeSpeed, recoverSpeed
do
    --文字
    local up = Class(object)
    function up:init(x, y, img)
        self.img = img
        self.layer = LAYER_ENEMY_BULLET-10
        self.x, self.y = x, y
        self.hscale, self.vscale = 0, 0
        _object.set_color(self, "", 0, 255, 255, 255)
        egg.SimAlpCh(self, 0, 255, 30)
        egg.SimSizeCh(self, 0, 1, 30)
        egg.AddSimStrChV(self, 8, 1, 90, 30)
        task.New(self, function()
            task.Wait(60)
            egg.SimAlpCh(self, 255, 0, 30)
            task.Wait(30)
            Del(self)
        end)
    end
    function up:frame()
        task.Do(self)
    end
    function up:render()
        SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end

    --特效
    local eff = Class(object)
    function eff:init()
        self.group = GROUP_GHOST
        self.layer = LAYER_PLAYER-1
        _object.set_color(self, "mul+rev", 0, 100, 255, 100)
        self.x, self.y = player.x or 0, player.y or 0
        self.img = "circle_eff"
        self.hscale, self.vscale = 3, 3
        self.trails = {}
        task.New(self, function()
            egg.SimAlpCh(self, 0, 255, 60)
            egg.SimSizeCh(self, 3, 0, 60)
            for _ = 1, 60 do
                table.insert(self.trails, {self.x, self.y, self.hscale, self.vscale, 20}) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
            task.Wait(30)
            Del(self)
        end)
    end
    function eff:frame()
        if IsValid(player) then
            self.x, self.y = player.x, player.y
        end
        task.Do(self)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 1.5
            if o[5] <= 0 then table.remove(self.trails, 1) end
        end
    end
    function eff:render()
        SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
        SetImageState("starlight", "mul+add", Color(self._a, self._r, self._g, self._b))
        Render("starlight", self.x, self.y, 0, self.hscale, self.vscale)
    end

    --新增BGM变速 by Xiliusha，不影响replay
    local function set_bgm_speed(name, speed)
        if lstg.CheckRes(4, name) then
            lstg.SetBGMSpeed(name, speed)
        end
    end

    function changeSpeed(rate, isChangeSpeed, isSound)
        if isSound then
            PlaySound("alert")
        end
        --如果是加速的话，就要给自机一个特效
        if setting.allow_change_bgm_speed then
            local k = math.max(0, rate - 1)
            set_bgm_speed("s6_boss", 1 + 0.06 * k)
        end
        if rate > 1 then
            New(eff)
            New(up, player.x, player.y, "powerUp")
        end
        if isChangeSpeed then
            player.speed_rate = rate --自机的移动速度率
            if rate ~= 1 then
                New(up, player.x, player.y + 30, "speedUp")
            end
        else
            player.speed_rate = 1.00001 --虽然毫无影响，仅用来加幻影
        end
        player.attack_speed = rate
        player.laser_rate = rate --激光类型的攻击伤害倍率
    end
    function recoverSpeed()
        set_bgm_speed("s6_boss", 1)
        changeSpeed(1, true)
    end
end
s6_boss.changeSpeed = changeSpeed
s6_boss.recoverSpeed = recoverSpeed
--出场特效
local show_eff
do
    --场景颜色效果
    local board_ch = Class(object)
    function board_ch:init()
        self.x, self.y = 0, 0
        self.hscale, self.vscale = 4, 4
        self.img = "s6_board_ch"
        _object.set_color(self, "mul+rev", 0, 0, 255, 0)
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY-2
        task.New(self, function()
            egg.SimAlpCh(self, 0, 255, 30)
            task.Wait(30 + 90)
            egg.SimAlpCh(self, 255, 0, 60)
            task.Wait(60)
            Del(self)
        end)
    end
    function board_ch:frame()
        task.Do(self)
    end
    function board_ch:render()
        SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    --出场光效
    local eff = Class(object)
    function eff:init(x, y)
        self.imgs = {}
        for i = 1, 18 do
            table.insert(self.imgs, "s6_boss_show_eff"..i)
        end
        self.img = self.imgs[1]
        self.x, self.y = x, y
        _object.set_color(self, "mul+add", 255, 255, 255, 255)
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY
        self.hscale, self.vscale = 1, 1
    end
    function eff:render()
        if self.timer < 72 then
            self.img = self.imgs[int(self.timer/4)%18 + 1]
            SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
            Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
        else
            Del(self)
        end
    end
    function show_eff(self, x, y)
        self.x, self.y = x, y
        self.colli = false
        self._a = 0
        New(board_ch)
        for _ = 1, 3 do
            s6_boss.eff(x, y, 20)
        end
        New(eff, x, y)
        egg.SimAlpCh(self, 0, 255, 72)
        task.Wait(72)
        self.colli = true
    end
end

--测试同步用的计时器
local Timer = Class(object)
function Timer:render()
    SetViewMode'ui'
    --RenderText("menu", "time = "..self.timer, 450, 20, 0.5)
	-- "menu"这个字体没了，请用TTF字体"Serif24", "Sans24", "Mono24"等替代
	SetViewMode'world'
end

--树
local tree
do
    tree = Class(object)
    function tree:init(mst)
        self.bound = false
        self.x, self.y = mst.x, mst.y
        self.mst = mst
        self.layer = LAYER_ENEMY-1
        self.rate = 1 --透明度比率
        self.drate = 1/18 --透明度变化率
        self.hscale, self.vscale = 1, 1
        self.img = "s6_boss_tree1"
        self.upimg = "s6_boss_tree_up4"
        self.backimg = "s6_boss_tree_back4"
    end
    function tree:frame()
        self.img = "s6_boss_tree"..(1 + int(self.timer/8)%6)
        self.rate = max(0, min(1, self.rate + self.drate))
        self.hscale, self.vscale = 0.5 + 0.5*self.rate, 1.25 - 0.25*self.rate
        if IsValid(self.mst) then
            self.x, self.y = self.mst.x, self.mst.y
            self.hide = self.mst.hide
        else
            Del(self)
        end
    end
    function tree:render()
        SetImageState(self.upimg, "", Color(self.mst._a*self.rate, 255, 255, 255))
        SetImageState(self.backimg, "", Color(self.mst._a*self.rate, 255, 255, 255))
        Render(self.upimg, self.x, self.y, 0, 2*self.hscale*hscale, 2*self.vscale*vscale)
        Render(self.backimg, self.x, self.y, 0, 2*self.hscale*hscale, 2*self.vscale*vscale)
        SetImgState(self, "", self.mst._a*self.rate, 255, 255, 255)
        Render(self.img, self.x, self.y, 0, 2*self.hscale*hscale, 2*self.vscale*vscale)
    end
end
--变形金刚组装
local back_light
do
    local example = Class(object)
    function example:init(x, y, p, img)
        self.x, self.y = 0, 100
        self.px, self.py = x, y --静止时相对于中心的位置(必须保持不变
        self._dx, self._dy = 0, 0 --实际偏移量(在下面的光背类中涉及到移动函数主要动的就是这个啦
        self.p = 1 --跟随强度(0是完全不跟随，1就是硬跟随
        --self.trail = New(egg.trail, master, maxnum, frame, img, size, blend, times, _a_rate, Isdsize) --new一个拖影出来
        self.hscale, self.vscale = 1, 1
        self.rot = 0
        self.img = img
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY-3
        self.alpha = 0
        self.bound = false
        _object.set_color(self, "", 255, 255, 255, 255)
        self.d_dx, self.d_dy = 0, 0
    end
    function example:frame()
        task.Do(self)
        self.d_dx, self.d_dy = min(self._dx, max(0.1, self._dx * self.p)), min(self._dy, max(0.1, self._dy * self.p))
        self._dx, self._dy = self._dx - self.d_dx, self._dy - self.d_dy
        self.x, self.y = self.x + self.d_dx, self.y + self.d_dy
        self.alpha = min(1, max(0, self.alpha))
    end
    function example:render()
        SetImgState(self, self._blend, self._a*self.alpha, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end


    --左边和右边的翅膀（？
    local p1 = Class(example)
    function p1:init(x, y)
        example.init(self, x, y, 0.75, "s6_boss_back_light_p1")
        self.ratex = 1
        self.ratey = 1
        self.signx = 1
        self.signy = -1
        self.wide = 0 --演出用的宽度变化参数
    end
    function p1:frame()
        example.frame(self)
        self.ratex = (-1+abs(cos(self.timer + 90))^2.5)
        self.ratey = 0.5*(-1-cos(2*self.timer))
        if (self.timer - 90)%180 == 0 then
            self.signx = -self.signx
        end
        if (self.timer - 90)%180 == 0 then
            self.signy = -self.signy
        end
    end
    function p1:render()
        local ratex, ratey = self.ratex, self.ratey
        SetImgState(self, self._blend, self._a*self.alpha, self._r, self._g, self._b)
        Render4V(self.img,
                self.x, self.y + 61, 0.5,
                self.x + ((40 - 10*self.signx)*ratex + 171)*self.hscale*self.wide, self.y + 61 + 10*ratey, 0.5,
                self.x + ((40 - 10*self.signx)*ratex+ 171)*self.hscale*self.wide, self.y - 61 + 10*ratey*self.signy, 0.5,
                self.x, self.y - 61, 0.5)
    end
    --中间的环（？
    local p2 = Class(example)
    function p2:init(x, y)
        example.init(self, x, y, 0.85, "s6_boss_back_light_p2")
    end
    --中间的主要光背部分（？
    local p3 = Class(example)
    function p3:init(x, y)
        example.init(self, x, y, 0.9, "s6_boss_back_light_p3")
        self.size = 1
    end
    function p3:frame()
        example.frame(self)
        self.hscale, self.vscale = self.size*(1.05 + 0.05*sin(2*self.timer)), self.size*(1.05 + 0.05*sin(2*self.timer))
    end
    --中心向外扩散的部分（？
    local p4 = Class(example)
    function p4:init(x, y)
        example.init(self, x, y, 0.9, "s6_boss_back_light_p4")
        self.yy = 0
        self.appeary = 0 --演出用的
    end
    function p4:frame()
        example.frame(self)
        self.yy = 5*sin(2*self.timer)
    end
    function p4:render()
        SetImgState(self, self._blend, self._a*self.alpha, self._r, self._g, self._b)
        Render(self.img, self.x, self.y + self.yy + self.appeary, 0, self.hscale, self.vscale)
    end
    --挂在上边或者下边的花（？
    local p5, p6 = Class(example)
    function p5:init(x, y)
        example.init(self, x, y, 0.5, "s6_boss_back_light_p5")
        self.trails = {} --拖影特效
        self.firecrackers = {} --鞭炮
        self.size = 0
    end
    function p5:frame()
        example.frame(self)
        self.hscale, self.vscale = 1.05 + 0.05*sin(2*self.timer), 1.05 + 0.05*sin(2*self.timer)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 2
            if o[5] <= 0 then table.remove(self.trails, 1) end
        end
        if self.timer%60 == 0 then
            table.insert(self.trails, {self.x, self.y, self.hscale*self.size, self.vscale*self.size, 100}) --x, y, hscale, vscale, _a
        end
    end
    function p5:render()
        SetImgState(self, self._blend, self._a*self.alpha, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale*self.size, self.vscale*self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "mul+add", o[5]*self.alpha, 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end
    --生成鞭炮
    function p5:creatFire(x0, y0, x1, y1)
        task.New(self, function()
            local obj
            for i = 1, 4 do
                obj = New(p6, x0, y0, 0.2 - 0.025*i, self)
                obj.x, obj.y = x1, y1
                obj._dy = obj._dy - 5 - 10*i
                table.insert(self.firecrackers, obj)
                task.Wait(10)
            end
        end)
    end
    --移除鞭炮
    function p5:removeFire()
        task.New(self, function()
            local obj
            for i = 4, 1, -1 do
                obj = self.firecrackers[i]
                if IsValid(obj) then
                    p6.remove(obj)
                    table.remove(self.firecrackers, i)
                end
                task.Wait(5)
            end
        end)
    end
    --挂在花下面的东西（？
    p6 = Class(example)
    function p6:init(x, y, p, mst)
        example.init(self, x, y, p, "s6_boss_back_light_p6")
        self.alpha = 1
        self.mst = mst
        self.size = 1
    end
    function p6:frame()
        if IsValid(self.mst) then
            self._dx, self._dy = self._dx + self.mst.d_dx, self._dy + self.mst.d_dy --这样可以做延迟跟随
        end
        example.frame(self)
        self.hscale = sin(3*self.timer)*self.size
    end
    --移除自己
    function p6:remove()
        task.New(self, function()
            local ds = -self.size/20
            for _ = 1, 20 do
                self.size = self.size + ds
                task.Wait(1)
            end
            Del(self)
        end)
    end

    --光背类
    back_light = Class(object)
    function back_light:init(mst)
        self.Isbacklight = true --光背的标记（用于特殊攻击减伤
        self.x, self.y = mst.x, mst.y
        self.a, self.b = 100, 100
        self.group = GROUP_NONTJT
        self.maxhp = 999999
        self.hp = 999999
        self.dmgrate = 1 --这里是对主人的伤害转换比例
        self.colli = false
        self.mst = mst
        --_connect(mst, self, 0, false)
        self.parts = {} --部件表
        self.flowers = {} --花使魔
        self.flowers_pos = {{-140, -15}, {-95, -60}, {0, -105}, {95, -60}, {140, -15}}
        self.bound = false
        self.delflag = false --自删标记
        do
            self.center = New(p3, 0, 0)
            self.center.x, self.center.y = self.x, self.y
            table.insert(self.parts, self.center)
            self.surround = New(p4, 0, -20)
            self.surround.x, self.surround.y = self.x, self.y - 20
            table.insert(self.parts, self.surround)
            self.center_circle = New(p2, 0, 0)
            self.center_circle.x, self.center_circle.y = self.x, self.y
            table.insert(self.parts, self.center_circle)
            self.left = New(p1, -40, 35)
            self.left.x, self.left.y = self.x - 40, self.y + 35
            self.left.hscale = -1
            table.insert(self.parts, self.left)
            self.right = New(p1, 40, 35)
            self.right.x, self.right.y = self.x + 40, self.y + 35
            table.insert(self.parts, self.right)
            local p = self.flowers_pos
            for i = 1, 5 do
                table.insert(self.flowers, i, New(p5, p[i][1], p[i][2]))
                self.flowers[i].x, self.flowers[i].y = self.x + p[i][1], self.y + p[i][2]
            end
        end
        --back_light.appear(self)
    end
    function back_light:frame()
        task.Do(self)
        if IsValid(self.mst) then
            if self.mst.dx ~= 0 or self.mst.dy ~= 0 then
                back_light.updatePos(self, self.mst.dx, self.mst.dy)
            end
        elseif not self.delflag then
            back_light.delAll(self)
        end
    end
    --碰撞
    function back_light:colli(other)
        if other.dmg then
            local dmg = other.dmg
            back_light.take_damage(self, dmg)
        end
        other.killerenemy = self.mst -- 应该指向boss
        if not (other.killflag) then
            Kill(other)
        end
        if not other.mute and IsValid(self.mst) then
            EISlib.Effect.DamageEnemyEffect(self.mst) -- 受击音效，应该指向master boss
        end
    end
    --伤害
    function back_light:take_damage(dmg)
        if IsValid(self.mst) then
            enemybase.damage(self.mst, dmg)
        elseif not self.delflag then
            back_light.delAll(self)
        end
    end
    --更新位置
    function back_light:updatePos(dx, dy)
        self.x, self.y = self.x + dx, self.y + dy
        for _, o in ipairs(self.parts) do
            o._dx, o._dy = o._dx + dx, o._dy + dy
        end
        for _, o in ipairs(self.flowers) do
            o._dx, o._dy = o._dx + dx, o._dy + dy
        end
    end
    --更新透明度
    function back_light:updateAlpha(dalp)
        for _, o in ipairs(self.parts) do
            o.alpha = o.alpha + dalp
        end
    end
    --透明度在t时间由多少变化到多少
    function back_light:alpChange(t, alp0, alp1)
        task.New(self, function()
            local dalp = (alp1 - alp0)/t
            for _ = 1, t do
                back_light.updateAlpha(self, dalp)
                task.Wait(1)
            end
        end)
    end
    --组装
    function back_light:appear()
        back_light.alpChange(self, 60, 0, 1)
        task.New(self, function()
            for x = 1, 90 do
                self.left.wide = sin(x)
                self.right.wide = sin(x)
                self.center_circle.rot = 360*cos(x)
                self.center.size = sin(x)
                self.surround.appeary = 20*cos(x)
                task.Wait(1)
            end
            for x = 1, 60 do
                for _, o in ipairs(self.flowers) do
                    o.size = sin(1.5*x)
                    o.alpha = sin(1.5*x)
                end
                task.Wait(1)
            end
            local p = self.flowers_pos
            for i, o in ipairs(self.flowers) do
                p5.creatFire(o, p[i][1], p[i][2], self.x + p[i][1], self.y + p[i][2])
            end
            self.mst.colli = false
            self.colli = true
        end)

    end
    --光背消失
    function back_light:disAppear()
        back_light.alpChange(self, 60, 1, 0)
        task.New(self, function()
            self.colli = false
            for _, o in ipairs(self.flowers) do
                p5.removeFire(o)
            end
            for x = 60, 0, -1 do
                for _, o in ipairs(self.flowers) do
                    o.size = sin(1.5*x)
                    o.alpha = sin(1.5*x)
                end
                task.Wait(1)
            end
            for x = 90, 0, -1 do
                self.left.wide = sin(x)
                self.right.wide = sin(x)
                self.center_circle.rot = 360*cos(x)
                self.center.size = sin(x)
                self.surround.appeary = 20*cos(x)
                task.Wait(1)
            end
            self.mst.colli = true
            self.colli = false
        end)
    end
    --光背删除
    function back_light:delAll()
        self.delflag = true
        task.New(self, function()
            back_light.alpChange(self, 39, 1, 0)
            self.colli = false
            for _, o in ipairs(self.flowers) do
                p5.removeFire(o)
            end
            for x = 60, 0, -3 do
                for _, o in ipairs(self.flowers) do
                    o.size = sin(1.5*x)
                    o.alpha = sin(1.5*x)
                end
                task.Wait(1)
            end
            for x = 60, 0, -3 do
                self.left.wide = sin(1.5*x)
                self.right.wide = sin(1.5*x)
                self.center_circle.rot = 360*cos(1.5*x)
                self.center.size = sin(1.5*x)
                self.surround.appeary = 20*cos(1.5*x)
                task.Wait(1)
            end
            do
                for _, o in ipairs(self.parts) do
                    Del(o)
                end
                for _, o in ipairs(self.flowers) do
                    Del(o)
                end
            end
            Del(self)
        end)
    end
    --获取所有花的实际位置表
    function back_light:getFlowersPos()
        local pos = {}
        for _, o in ipairs(self.flowers) do
            table.insert(pos, {o.x, o.y})
        end
        return pos
    end
end
--立绘演出
local pic_show
do
    local pic = Class(object)
    function pic:init()
        self.group = GROUP_GHOST
        _object.set_color(self, "", 0, 255, 255, 255)
        self.x, self.y = 0, 100
        self.img = "s6boss_pic"
        self.size = 0.9
        self.trails = {}
        task.New(self, function()
            for _ = 1, 60 do
                table.insert(self.trails, {self.x, self.y, self.size, self.size, 20}) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
            task.Wait(15)
            egg.SimAlpCh(self, 255, 0, 30)
            task.Wait(30)
            Del(self)
        end)
        task.New(self, function()
            task.MoveTo(0, 0, 60, MOVE_DECEL)
        end)
        egg.SimAlpCh(self, 0, 255, 30)
    end
    function pic:frame()
        task.Do(self)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 1.5
            if o[5] <= 0 then table.remove(self.trails, 1) end
        end
    end
    function pic:render()
        SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.size, self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "mul+add", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end
    local light = Class(object)
    function light:init()
        self.group = GROUP_GHOST
        _object.set_color(self, "mul+add", 255, 255, 255, 255)
        self.img = "s5_light"
        self.bound = false
        self.x, self.y = 0, 300
        self.size = 1.5
        self.trails = {}
        task.New(self, function()
            for _ = 1, 60 do
                table.insert(self.trails, {self.x, self.y, self.size, self.size, 30}) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
        end)
        task.New(self, function()
            task.MoveTo(0, -224, 90, MOVE_DECEL)
            Del(self)
        end)
        --egg.SimAlpCh(self, 0, 255, 30)
    end
    function light:frame()
        pic.frame(self)
    end
    function light:render()
        pic.render(self)
    end
    local cherry = Class(object)
    function cherry:init(x, y, v, a)
        self.x, self.y = x, y
        self.bound = false
        self.size = ran:Float(0.8, 0.9)
        self.hscale, self.vscale = self.size, self.size
        self.img = "Cherry_eff"
        self.rot = ran:Float(0, 360)
        self.timer = ran:Int(0, 120)
        _object.set_color(self, "mul+add", 0, 255, 255, 255)
        task.New(self, function()
            egg.SimAlpCh(self, 0, 150, 10)
            egg.AddAccDecChV(self, v, a, 1, 30, 60)
            task.Wait(60)
            egg.SimAlpCh(self, 150, 0, 30)
            task.Wait(30)
            Del(self)
        end)
    end
    function cherry:frame()
        task.Do(self)
        self.vscale = self.size*sin(6*self.timer)
    end
    function cherry:render()
        SetImgState(self, "mul+add", self._a, 255, 255, 255)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
        SetImgState(self, "", 255, 255, 255, 255)
    end
    function pic_show()
        New(pic)
        New(light)
        New(tasker, function()
            local y, dy, u = 250, -224/10
            for _ = 1, 10 do
                y = y + dy
                for _ = 1, 5 do
                    u = ran:Sign()
                    New(cherry, u*ran:Float(60, 90), y, ran:Float(3, 4), -90 + u*ran:Float(-30, 60))
                end
                task.Wait(1)
            end
        end)
    end
end
--boss蓄力特效
local eff, pinkeff, pinkbkeff, bkeff, scbkeff, laser_eff, appear_eff, lasereff
do
    --蓄力特效
    local absorb_eff = Class(object)
    function absorb_eff:init(x, y, img1, img2, R, G, B, blend)
        blend = blend or "mul+add"
        local imgs = {img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white'}
        self.bound = false
        self.x, self.y = 0, 0
        PlaySound("power02", 0.5)
        task.New(self, function()
            local obj = New(qhm_eff.eff_11, x, y, 4.5, R, G, B, blend)
            obj.img = "starlight"
            local a, r
            for _ = 1, 30 do
                for _ = 1, 3 do
                    a, r = ran:Float(0, 360), ran:Float(350, 600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.5, 1.25), R, G, B, blend)
                end
                task.Wait(1)
            end
            Del(self)
        end)
        task.New(self, function()
            local a, r
            for _ = 1, 20 do
                for _ = 1, 4 do
                    a, r = ran:Float(0,360), ran:Float(300,600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.075,0.125), R, G, B, blend)
                end
                task.Wait(2)
            end
        end)
    end
    function absorb_eff:frame()
        task.Do(self)
    end
    --炸裂特效
    local function Spell_break_eff(x, y, r, g, b, img1, img2, rate, blend)
        rate = rate or 1
        blend = blend or "mul+add"
        PlaySound('enep02', 0.5)
        local obj = New(BkCircle, x, y, 4.5, 255*rate, 255*rate, 255*rate)
        obj.img = "starlight"
        obj = New(BkCircle, x, y, 4.65, r, g, b)
        obj.img = "starlight"
        for _ = 1, 30 do
            New(BkItem, x, y, ran:Float(50,450),ran:Float(0,360),ran:Float(1,1.25),r,g,b, img1, img2, blend)
        end
        for _ = 1, 90 do
            New(BkItem, x, y, ran:Float(50,450),ran:Float(0,360),ran:Float(0.2,0.3),r,g,b, img1, img2, blend)
        end
    end
    function eff(x, y, t)
        PlaySound("ch00")
        New(absorb_eff, x, y, 'tree_leaf', 'Cherry_eff', 255, 255, 255)
        if t then task.Wait(t) end
    end
    function pinkeff(x, y, t)
        PlaySound("ch00")
        New(absorb_eff, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 90, 255)
        if t then task.Wait(t) end
    end
    function pinkbkeff(x, y, t)
        Spell_break_eff(x, y, 255, 90, 255, 'tree_leaf_white', 'Cherry_eff', 0)
        if t then task.Wait(t) end
    end
    function bkeff(x, y)
        Spell_break_eff(x, y, 255, 255, 255, 'tree_leaf', 'Cherry_eff', 1)
    end
    function scbkeff(x, y)
        Spell_break_eff(x, y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff', 0.5)
    end
    function laser_eff(x, y, a, r, g, b)
        return New(lasereff, x, y, a, r, g, b)
    end
    --蓄力特效
    local appear = Class(object)
    function appear:init(x, y, R, G, B, blend)
        blend = blend or "mul+add"
        local imgs = {'tree_leaf_white', 'Cherry_eff'}
        self.bound = false
        self.x, self.y = 0, 0
        PlaySound("power02", 0.5)
        task.New(self, function()
            local a, r
            for _ = 1, 60 do
                for _ = 1, 3 do
                    a, r = ran:Float(0, 360), ran:Float(350, 600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.5, 1.25), R, G, B, blend)
                end
                task.Wait(2)
            end
            Del(self)
        end)
        task.New(self, function()
            local a, r
            for _ = 1, 40 do
                for _ = 1, 4 do
                    a, r = ran:Float(0,360), ran:Float(300,600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.075,0.125), R, G, B, blend)
                end
                task.Wait(4)
            end
        end)
        task.New(self, function()
            task.Wait(90)
            for _ = 1, 1 do
                New(qhm_eff.eff_11, x, y, 3, 100, 100, 100, "mul+add")
                New(qhm_eff.eff_11, x, y, 3.1, R, G, B, blend)
                task.Wait(20)
            end
        end)
    end
    function appear:frame()
        task.Do(self)
    end
    function appear_eff(x, y)
        New(appear, x, y, 255, 0, 255)
    end
    --激光特效
    lasereff = Class(object)
    function lasereff:init(x, y, a, r, g, b, w)
        r, g, b = r or 177, g or 255, b or 97
        w = w or 1
        self.bound = false
        self.x, self.y = x + 300*cos(a), y + 300*sin(a)
        self.rot = a
        self.layer = LAYER_ENEMY_BULLET-1
        self.hscale, self.vscale = 75, 0
        self.img = "white"
        _object.set_color(self, "mul+add", 100, r, g, b)
        task.New(self, function()
            local ds, d_a = 1/50*w, -100/30
            for _ = 1, 20 do
                self.vscale = self.vscale + 2*ds
                task.Wait(1)
            end
            for _ = 1, 30 do
                self.vscale = self.vscale + ds
                self._a = self._a + d_a
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function lasereff:frame()
        task.Do(self)
    end
    function lasereff:render()
        local rate, v = 1, 1
        for _ = 1, 3 do
            SetImgState(self, self._blend, self._a*rate, self._r*rate, self._g*rate, self._b*rate)
            Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale*v)
            rate = rate - 0.2
            v = v + 0.3
        end
    end
end
s6_boss.eff = eff
s6_boss.pinkeff = pinkeff
s6_boss.pinkbkeff = pinkbkeff
s6_boss.laser_eff = laser_eff
s6_boss.bkeff = bkeff
s6_boss.scbkeff = scbkeff
--树枝类
local branch
do
    branch = Class(object)
    function branch:init(x, y, rot, len, w0, w1)
        self.x, self.y = x, y --起始点
        self.hscale, self.vscale = 1, 1
        self.bound = false
        self.branchs = {{x, y, rot, len, w0, w1, {}}} --主干{x, y, rot, length, wide0, wide1, {branch_class...}}
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY_BULLET-1
        self.rate = 0
    end
    function branch:frame()
        task.Do(self)
    end
    function branch:render()
        local rate = self.rate
        if rate >0 and self.branchs[1] then
            local x, y, head, rot, len, w0, w1, dx, dy = self.x, self.y, self.branchs[1]
            --渲染尾
            rot, w0 = head[3] + 180, 0.5*head[5]*self.vscale
            len = (9*head[5]/20)*self.hscale
            dx, dy = cos(rot), sin(rot)
            Render4V("s6_branch_head",
                    x + w0*dy, y - w0*dx, 0.5,
                    x + w0*dy + len*dx, y - w0*dx + len*dy, 0.5,
                    x - w0*dy + len*dx, y + w0*dx + len*dy, 0.5,
                    x - w0*dy, y + w0*dx, 0.5
            )
            --渲染身
            local i = 1
            for _, o in ipairs(self.branchs) do
                if rate <=1  then break end
                x, y, rot, len, w0, w1 = o[1], o[2], o[3], o[4]*self.hscale, 0.5*o[5]*self.vscale, 0.5*o[6]*self.vscale
                dx, dy = cos(rot), sin(rot)
                Render4V("s6_branch_body",
                        x - w0*dy, y + w0*dx, 0.5,
                        x - w1*dy + len*dx, y + w1*dx + len*dy, 0.5,
                        x + w1*dy + len*dx, y - w1*dx + len*dy, 0.5,
                        x + w0*dy, y - w0*dx, 0.5
                )
                rate = rate - 1
                i = i + 1
            end
            --渲染最后一部分
            do
                local o = self.branchs[i]
                x, y, rot, len, w0, w1 = o[1], o[2], o[3], o[4]*self.hscale*rate, 0.5*o[5]*self.vscale, (0.5*o[5] + (0.5*o[6] - 0.5*o[5]*rate))*self.vscale
                dx, dy = cos(rot), sin(rot)
                Render4V("s6_branch_body",
                        x - w0*dy, y + w0*dx, 0.5,
                        x - w1*dy + len*dx, y + w1*dx + len*dy, 0.5,
                        x + w1*dy + len*dx, y - w1*dx + len*dy, 0.5,
                        x + w0*dy, y - w0*dx, 0.5
                )
            end
            --渲染头
            x, y = x + len*dx, y + len*dy
            len = (9*w1/20)*self.hscale
            Render4V("s6_branch_head",
                    x - w1*dy, y + w1*dx, 0.5,
                    x - w1*dy + len*dx, y + w1*dx + len*dy, 0.5,
                    x + w1*dy + len*dx, y - w1*dx + len*dy, 0.5,
                    x + w1*dy, y - w1*dx, 0.5
            )
        end
    end
    function branch:getPos(i)
        return self.branchs[i][1], self.branchs[i][2]
    end
    function branch:addMainBranch(da, length, w1, dlen)
        dlen = dlen or 0 --回退值(有时连接会产生断痕...
        local obj, x, y, rot, len, w0 = self.branchs[#self.branchs]
        x, y, rot, len, w0 = obj[1], obj[2], obj[3], obj[4] - dlen, obj[6]
        x, y = x + len*cos(rot), y + len*sin(rot)
        table.insert(self.branchs, {x, y, rot + da, length, w0, w1, {}})
    end
    function branch:addOtherBranch(i, rate, da, length, w0, w1, dlen) --在主枝的i枝上添加侧枝
        dlen = dlen or 0 --回退值(有时连接会产生断痕...
        local obj, x, y, rot, len = self.branchs[i]
        x, y, rot, len = obj[1], obj[2], obj[3], obj[4]*rate - dlen  --rate决定在树枝的哪个位置长侧枝
        x, y = x + len*cos(rot), y + len*sin(rot)
        obj = New(branch, x, y, rot + da, length, w0, w1)
        table.insert(self.branchs[i][7], obj)
        return obj
    end
    function branch:getOtherBranch(i) --注意这个方法是直接把表的引用返回，操作时务必小心处理数据
        return self.branchs[i][7]
    end
    function branch:getWide(i, rate)
        return self.branchs[i][5] + (self.branchs[i][6] - self.branchs[i][5])*rate
    end
    function branch:updateRate(drate)  --只能用这个方法来更新生长比率
        local maxrate = #self.branchs
        self.rate = min(self.rate + drate, maxrate)
    end
    function branch:grow(t, rate0, rate1, Isntask, func) --在t时间内从rate0生长到rate1
        local maxrate = #self.branchs
        rate0 = min(rate0 or 0, maxrate)
        rate1 = min(rate1 or #self.branchs, maxrate)
        local drate = (rate1 - rate0)/t
        self.rate = rate0
        if func then
            if Isntask then
                for _ = 1, t do
                    branch.updateRate(self, drate)
                    func(self)
                    task.Wait(1)
                end
            else
                task.New(self, function()
                    for _ = 1, t do
                        branch:updateRate(drate)
                        func(self)
                        task.Wait(1)
                    end
                end)
            end
        else
            if Isntask then
                for _ = 1, t do
                    branch.updateRate(self, drate)
                    task.Wait(1)
                end
            else
                task.New(self, function()
                    for _ = 1, t do
                        branch:updateRate(drate)
                        task.Wait(1)
                    end
                end)
            end
        end


    end
    function branch:getHeadRot()
        return self.branchs[int(self.rate + 1)][3]
    end
    function branch:getHeadPos()
        local n = int(self.rate + 1)
        local x, y, rot, len, rate = self.branchs[n][1], self.branchs[n][2], self.branchs[n][3], self.branchs[n][4], self.rate - n + 1
        x, y = x + len*cos(rot)*rate, y + len*sin(rot)*rate
        return x, y
    end
end
s6_boss.branch = branch
s6_boss.pic_show = pic_show
s6_boss.back_light = back_light --导出去测试的(完成后会弃用
--符卡背景
do
    scbg =Class(background)
    function scbg:init()
        background.init(self,true)
        self.connects_x, self.connects_y = 0, 0
    end
    function scbg:frame()
        self.connects_x, self.connects_y = self.connects_x + 0.5, self.connects_y - 0.5
        if self.connects_x >= 256 then
            self.connects_x = self.connects_x - 256
            self.connects_y = self.connects_y + 256
        end
    end
    function scbg:render()
        if self.alpha > 0 then
            background.WarpEffectCapture()
            --底层正常渲染
            SetImageState("s6_boss_scbg1", "", Color(255*self.alpha, 255, 255, 255))
            Render("s6_boss_scbg1", 0, 0, 0, 1)
            --中层加法
            SetImageState("s6_boss_scbg2", "mul+add", Color((155 + 50*sin(self.timer))*self.alpha, 255, 255, 255))
            for i = -2, 1 do
                for j = -1, 2 do
                    Render("s6_boss_scbg2", self.connects_x + 256*i, self.connects_y + 256*j, 0, 1)
                end
            end

            background.WarpEffectApply(self.alpha)
            --顶层减法+极坐标
            EISlib.Render.RenderTexturePolarRing("s6_boss_scbg3", "mul+rev", Color(255*self.alpha, 255, 255, 255),
                    0, 110,
                    0, 400,
                    0, 60, 2,
                    (self.timer * 0.0075) % 1)
        end
    end
end
s6_boss.scbg = scbg
--小妖精与大蝴蝶
do
    small_fairy = Class(enemy)
    function small_fairy:init(x, y, hp)
        enemy.init(self, 29, hp, false, false, true, false, 1, 0, 1)
        self.x, self.y = x, y
    end
    big_fairy = Class(enemy)
    function big_fairy:init(x, y, hp)
        enemy.init(self, 25, hp, false, false, true, true, 1, 0, 1)
        self.x, self.y = x, y
    end
end
s6_boss.small_fairy = small_fairy
s6_boss.big_fairy = big_fairy

--设置行走图
function lstg.wis.Oukain(self)
    boss.show_aura(self, false) --开打前开啥法阵呀
    _object.set_color(self, "", 255, 255, 255, 255)
    self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
    self._wisys:connectAction("normal", _ACT_NONE_AUTO_Oukain)
    self._wisys:connectAction("cast", _ACT_CAST_Oukain)
    self.back_light = New(s6_boss.back_light, self)  --光背对象
    self.tree = New(tree, self) --生成底坐树对象
    self.cast = cast
    self.show_eff = show_eff --出场特效，作为类方法导出
    --New(Timer)
    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 0, "mul+rev"
    self.saoqi = New(boss_saoqi, self)
end
