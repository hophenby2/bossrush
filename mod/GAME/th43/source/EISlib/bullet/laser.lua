---=====================================
---东方祈华梦激光素材
---=====================================
local M = {}
---@class EISlib.Bullet.Laser
EISlib.Bullet.Laser = M

--激光种类信息表，这个表的数组下标作为激光种类type的索引
local laser_style = {
    --{{head_img, body_img, trail_img, length_width_ratio, colli_w}, {...}} --先索引颜色，然后再头、身、尾贴图，头长与宽度之比，宽判定
}

--local path="THlib/laser/"
local sin, cos = lstg.sin, lstg.cos
local abs = math.abs
local min, max = math.min, math.max
local int = math.floor

local laser_data = {}
local laser_texture_num = 1
local lazer_raw_width = 6--7
local createNewLaser2 = EGGlib.RenderEffect.createNewLaser2 --渲染激光函数
local blank_func = function() end
local laser_head_size = 8
local laser_node_size = 8
local laser_head_img = "ball_mid_b"
local laser_node_img = "preimg"--"laser_node"

local res_set = lstg.ResourceSet.create("THlib.laser", "global")

function LoadLaserTextureFromFile(filename, w, h, l1, l2, l3, scale, w0)
    local n = laser_texture_num
    w0=w0 or lazer_raw_width
    local texture = "laser" .. n
    res_set:addTexture(texture, filename, false)
    local dh = h / 16
    res_set:addSpriteSequence(texture .. 1, texture, 0, 0, l1, dh, 1, 16)
    res_set:addSpriteSequence(texture .. 2, texture, l1, 0, l2, dh, 1, 16)
    res_set:addSpriteSequence(texture .. 3, texture, l1 + l2, 0, l3, dh, 1, 16)
    local type = {}
    for co = 1, 16 do
        local color = {}
        for i = 1, 3 do --body head trail
            res_set:setSpriteCenter(texture .. i .. co, 0, dh/2)
            table.insert(color, texture .. i .. co)
        end
        table.insert(color, l1/dh) --长宽比
        table.insert(color, w0/dh) --实际宽判定与贴图宽度之比
        table.insert(type, color)
    end
    laser_data[n] = { l1*scale, l2*scale, l3*scale, w0*scale }
    laser_texture_num = n + 1
    table.insert(laser_style, type) --添加素材的时候就已经把相关信息整理到表了
end

local path= "res/bullet/"

----------------------------------------------------------------------------------------
---res
local function loadRes()
    LoadLaserTextureFromFile(path.."laser1.png", 256, 256, 64, 128, 64,0.5,8)
    LoadLaserTextureFromFile(path.."laser2.png", 256, 256, 5, 236, 15,0.5,8)
    LoadLaserTextureFromFile(path.."laser3.png", 256, 256, 127, 1, 128,0.5,6)
    LoadLaserTextureFromFile(path.."laser4.png", 256, 256, 1, 254, 1,0.5,6)


    lstg.ResourceSet.find("THlib.laser"):addTexture("laser_bent0",path.."laser_bent.png",false)
    Add_bentlaser_texture_16(4, "laser_bent0", 256, 256)
    Add_bentlaser_envelope(4, 0.0, 0.5, 0.8, 4.0)

    --新激光预警
    LoadTexture("warning_laser_effect", "res/effect/warning_laser.png")
    LoadImageGroupFromFile("warning_laser_effect", "res/effect/warning_laser.png", false, 1, 7)
    LoadTexture("warning_laser_head_effect", "res/effect/warning_laser_head.png")
    LoadImageGroupFromFile("warning_laser_head_effect", "res/effect/warning_laser_head.png", false, 1, 7)

    --常用的头宽尾窄式曲线激光
    LoadTexture("laser_bent_2", path.."laser_bent_2.png")
    Add_bentlaser_texture("laser_bent_2", "laser_bent_2")
end
loadRes()
-----------------------------------------------------------------------------------------
local Laser_buffer = {} --缓冲表，所有本类定义的激光创建时会插入这个表，在一帧延迟后才会进入list表（下面那个）
local Laser_list = {} --像group一样，专门储存激光对象的表
--const 常量定义
--激光三部分常量描述
M.LASER_TRAIL = 1
M.LASER_BODY = 2
M.LASER_HEAD = 3

--根据传入的激光种类和颜色获取激光头、激光身、激光尾的贴图
function M.getImages(type, co)
    return laser_style[type][co][1], laser_style[type][co][2], laser_style[type][co][3]
end
--根据传入激光的种类获取激光头尾的长宽比例
function M.getLengthWidthRatio(type)
    return laser_style[type][1][4]
end
--根据传入激光的种类获取默认宽判定
function M.getDefaultColliWideRate(type)
    return laser_style[type][1][5]
end
--将对象插入缓冲表
function M.insertIntoLaserBuffer(obj)
    table.insert(Laser_buffer, obj)
end
--将对象插入激光表
function M.insertIntoLaserList(obj)
    table.insert(Laser_list, obj)
end
--遍历整个缓冲表
function M.forEachLaserInBufferDo(func)
    for _, obj in pairs(Laser_buffer) do
        func(obj)
    end
end
--清除激光表
function M.clearLaserList()
    Laser_list = {}
end
--清除缓冲表
function M.clearLaserBuffer()
    Laser_buffer = {}
end
--遍历整个激光表
function M.forEachLaserDo(func)
    for _, obj in pairs(Laser_list) do
        func(obj)
    end
end
--激光表初始化
function M.init()
    M.clearLaserList()
    M.clearLaserBuffer()
end
EGGlib.TextObject.mainTextObject.addToInit(M.init)
--激光表每帧要做的事
function M.update()
    --将缓冲表的东西扔进激光表
    M.forEachLaserInBufferDo(function(obj)
        M.insertIntoLaserList(obj)
    end)
    --然后清空缓冲表
    M.clearLaserBuffer()
    --剔除激光表中失效的对象
    sp.UnitListUpdate(Laser_list)
end
EGGlib.TextObject.mainTextObject.addToFrame(M.update) --把该帧事件添加至测试用的全局更新对象里
--测试功能，显示一下每帧的激光数
function M.displayLaserNumber()
    SetViewMode("ui")
    RenderTTF('Mono24', "ls_number:"..#Laser_list, 530, 530, 80, 80, 1.75, Color(255, 255, 255, 255), 'left', 'noclip')
    SetViewMode("world")
end
EGGlib.TextObject.mainTextObject.addToRender(M.displayLaserNumber) --与上类似

--新的激光
---@class laser
M.laser = Class(object)
function M.laser:init(_type, color, x, y, v, rot, len0, max_len, w0, w1, t, islocked, isshoot, left_time)
    M.laser.ChangeImage(self, _type, color, w0)
    self.x, self.y = x, y
    self.rot = rot --本类对象角度不支持直接设置rot，需要用类方法更新
    --自身朝向的正弦值和余弦值（优化）
    self.cos = cos(rot)
    self.sin = sin(rot)

    self.vscale = 0 --纵向缩放，注意在激光里不能直接修改这个，请用对应的函数修改
    self.dvscale = 0 --每帧宽度变化量
    self.vscale_t = 0 --宽度变化时间
    self.turn_off = false --当宽度小于等于0或者透明度小于等于0的时候，该flag为true时会删除本对象
    self.base_w0, self.base_w1 = w0, w1 --基础边缘宽度，中间宽度
    self.w0, self.w1 = w0, w1 --实际的边缘宽度，中间宽度
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY_BULLET-9 --激光最好别遮挡弹幕
    self.a, self.b = 0, 0  --这个是作为普通子弹的判定，不要有
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    self.d_a = 0 --每帧透明度变化量
    self._a_t = 0 --透明度变化时间
    self.graze_timer = 0 --擦弹计时器
    self._grazed = false --擦弹状态，false表示没被擦过
    self.v = v or M.laser.getTotalLength(self) --延伸速度与运动速度
    self.islocked = islocked --延伸完后是否固定（还是以延伸速度继续发射出去？），不填或false则默认射出去
    M.laser.turnOn(self, t) --默认启动动画（t不填的话默认是1，也就是秒开）
    --初始化长度
    self.max_len = {max_len[1], max_len[2], max_len[3]} --可被延伸的最大长度（l1、l2、l3分别代表尾、身、头长
    self.len = {min(len0[1], max_len[1]), min(len0[2], max_len[2]), min(len0[3], max_len[3])} --实际长度
    self.shoot_len = 0 --用于判断能否发射出去的长度
    self.max_shoot_len = M.laser.getMaxTotalLength(self) --用于判断能否发射出去的总长度
    self.isshoot = isshoot --是否已被发射出去，是否需要有伸展动画
    if isshoot then
        self.shoot_len = self.max_shoot_len
        for i = 1, 3 do
            self.len[i] = self.max_len[i]
        end
    end
    self.left_time = left_time or 9999 --激光关闭倒计时
    self.ex_frame = blank_func --额外帧逻辑
    M.insertIntoLaserBuffer(self) --插入到临时的管理laser的缓冲表中
    self.grow_cd = 0 --激光增长cd（仅适用于固定激光）
    --不可再被碰撞消除的flag，防止一帧内被大量重复消除产生活动块影响性能，每帧逻辑开始时重置为false
    self.no_cut = false
end
--region 帧模块
--宽度与透明度更新模块
function M.laser:updateState()
    --宽度更新模块
    if self.vscale_t > 0 then
        M.laser.updateVscale(self)
        self.vscale_t = self.vscale_t - 1
    end
    --透明度更新模块
    if self._a_t > 0 then
        self._a = max(0, min(255, self._a + self.d_a))
        self._a_t = self._a_t - 1
    end
    --透明度，宽度要求达到其一，再加上删除flag即可删除
    if (self._a <= 0 or self.vscale <= 0) and self.turn_off then
        self.status = "del"
    end
    --存活时间倒计时
    self.left_time = self.left_time - 1
    if self.left_time == 0  then
        M.laser.turnOff(self, 20)
    end
end

--将激光的pos部位向前延长d（并返回延长后的d）
local function growPos(self, pos, d)
    if self.len[pos] <= self.max_len[pos] - d then
        self.len[pos] = self.len[pos] + d
        d = 0
    elseif self.len[pos] < self.max_len[pos] then
        d = d - (self.max_len[pos] - self.len[pos])
        self.len[pos] = self.max_len[pos]
    end
    return d
end

--将激光的pos部位向后缩进d（并返回缩进后的d）d为负数
local function decreasePos(self, pos, d)
    if self.len[pos] + d >= 0 then
        self.len[pos] = self.len[pos] + d
        d = 0
    else
        d = d + self.len[pos]
        self.len[pos] = 0
    end
    return d
end

--延展与发射模块
function M.laser:updateGrow()
    if not self.islocked or self.grow_cd <= 0 then
        local d = self.v
        local cosr, sinr = M.laser.getCosSinRot(self)
        if d >= 0 then --v是正数
            --按头、身、尾的顺序执行延长模块
            for i = 3, 1, -1 do
                if d ~= 0 then
                    d = growPos(self, i, d)
                else
                    break
                end
            end
        else --v是负数
            --按身、头尾巴并行的顺序执行延长模块
            d = decreasePos(self, 2, d)
            if d < 0 then
                if self.len[1] + d/2 >= 0 and self.len[3] + d/2 >= 0 then
                    d = d/2
                    decreasePos(self,1, d)
                    decreasePos(self,3, d)
                elseif self.len[1] + d/2 < 0 then
                    d = decreasePos(self, 1, d)
                    d = decreasePos(self, 3, d)
                else
                    d = decreasePos(self, 3, d)
                    d = decreasePos(self, 1, d)
                end
            end

            --到这里d还不为0的话表明头、身、尾已缩到最小
            if d ~= 0 then
                self.len[1] = 0
                self.len[2] = 0
                self.len[3] = 0
            end
        end

        --仅针对不锁定的激光，来判断何时能从发射源脱离出去
        if not self.islocked then
            local v = self.v
            self.shoot_len = self.shoot_len + v
            if self.shoot_len >= self.max_shoot_len then
                self.isshoot = true --已延伸至最长的标志
                self.x, self.y = self.x + v*cosr, self.y + v*sinr
            end
        end
    else
        self.grow_cd = max(0, self.grow_cd - 1)
    end
end
--擦弹更新模块
function M.laser:grazeUpdate()
    if self._grazed then --被擦过了才会开始计时
        if self.graze_timer > 0 then
            self.graze_timer = self.graze_timer - 1
        else
            self._grazed = false --置为没被擦过
            self.graze_timer = self.graze_timer + 4 --四帧刷新一次擦弹flag（即每四帧算一次擦弹）
        end
    end
end
--激光与自机的判定模块
function M.laser:colliPlayer(player)
    local dx = player.x - self.x
    local dy = player.y - self.y
    local rot = self.rot
    local len, dist = EGGlib.Math.TranRot(dx, dy, -rot) --将坐标系转化为以激光头为原点，激光方向为x轴正方向，自机x，y对应该坐标系的坐标
    dist = abs(dist) --取得自机点到激光直线的距离
    --l为自机所在点到激光源沿平行于激光方向的矢量
    if len > 0 then --表明自机在激光延伸的那个方向，继续判断，否则自机一定不可能被激光覆盖到
        local colli_dist = M.laser.getColliWideByLength(self, len) --获取激光对自机相对位置的判定宽度
        if colli_dist > 0 then -- -1是不行的
            if dist <= colli_dist + player_class.getColliSize(player) then --距离小于判定宽度时就等于被激光命中了
                player.class.colli(player, self)
            elseif dist <= colli_dist + player_class.getGrazeRange(player) then --在擦弹范围内
                player.grazer.class.colli(player.grazer, self)
            end
        end
    end
end
--激光与其他对象的判定（注意，本方法并不会在本类中的Frame里调用，仅用作外部调用手动判定，返回布尔值）
function M.laser:colliOther(obj)
    local dx = obj.x - self.x
    local dy = obj.y - self.y
    local rot = self.rot
    local len, dist = EGGlib.Math.TranRot(dx, dy, -rot) --将坐标系转化为以激光头为原点，激光方向为x轴正方向，obj的x，y对应该坐标系的坐标
    dist = abs(dist) --取得obj点到激光直线的距离
    --l为obj所在点到激光源沿平行于激光方向的矢量
    if len > 0 then --表明obj在激光延伸的那个方向，继续判断，否则obj一定不可能被激光覆盖到
        local colli_dist = M.laser.getColliWideByLength(self, len) --获取激光对自机相对位置的判定宽度
        if colli_dist > 0 and dist <= colli_dist + (obj.a + obj.b)/2 then -- -1是不行的 --距离小于判定宽度时就等于被激光命中了
            return true
        else
            return false
        end
    end
    return false
end
--帧逻辑（包含了上面所有方法）
function M.laser:frame()
    self.no_cut = false --刷新，可被消一次
    task.Do(self)
    --状态变化模块
    M.laser.updateState(self)
    --延展与发射模块
    M.laser.updateGrow(self)
    --擦弹更新模块
    M.laser.grazeUpdate(self)
    --自机距离判定模块
    if self.colli then
        for _, player in pairs({_G.player}) do
            M.laser.colliPlayer(self, player)
        end
    end
    --帧逻辑模块
    self.ex_frame(self)
end
--endregion

--region 渲染模块
local function render_laser(self)
    local l1, l2, l3 = M.laser.getLength(self, M.LASER_TRAIL), M.laser.getLength(self, M.LASER_BODY), M.laser.getLength(self, M.LASER_HEAD)
    local cosr, sinr = M.laser.getCosSinRot(self)
    --来决定实际头、尾、身长度
    local x, y = self.x, self.y
    local w0, w1 = M.laser.getTwoWide(self)
    local wscale = w1/w0 --中间宽度 与 边缘宽度之比
    local len = l1
    w0 = 0.5*w0
    local wx, wy, lx, ly --激光宽的一半对x和y的值，激光长对x和y的值
    local b = self._blend
    local c = Color(self._a, self._r, self._g, self._b)
    local img1, img2, img3 = M.getImages(self._type, self._index)
    --渲染尾
    wx, wy = -w0*sinr, w0*cosr
    lx, ly = len*cosr, len*sinr
    createNewLaser2(img1, b, c, x, y, wx, wy, lx, ly, 1)
    --渲染身后半段
    x, y = x + lx, y + ly --渲染起点前进
    len = 0.5*l2
    lx, ly = len*cosr, len*sinr
    createNewLaser2(img2, b, c, x, y, wx, wy, lx, ly, wscale)
    x, y = x + 2*lx, y + 2*ly
    createNewLaser2(img2, b, c, x, y, wx, wy, -lx, -ly, wscale) --注意这里是反着渲染
    --渲染头
    len = l3
    lx, ly = len*cosr, len*sinr
    createNewLaser2(img3, b, c, x, y, wx, wy, lx, ly, 1)
end

local function render_node(self, b)
    --[[local l = (self.l1 + self.l2 + self.l3)--*0.95
    --头尾的渲染受原始大小影响
    if self.node > 0 then
        local c = Color(self._a * self.w / self.w0, self._r, self._g, self._b)
        SetImageState(self.img4, b, c)
        Render(self.img4, self.x, self.y, self.ani * 8, self.node / laser_node_size)
    end
    if self.head > 0 then
        local c = Color(self._a * self.w / self.w0, self._r, self._g, self._b)
        SetImageState(self.img5, b, c)
        Render(self.img5, self.x + l * cos(self.rot), self.y + l * sin(self.rot), self.ani * 8, self.head / laser_head_size)
    end]]
end

function M.laser:render()
    if self.vscale > 0 and self._a > 0 then
        render_laser(self)
        --render_node(self, b)
    end
end
--endregion

--截取整段激光的每一段做什么（返回有效执行了多少次func）
function M.laser:totalLaserDo(len_start, len_end, dl, func)
    len_start = len_start or 0
    len_end = len_end or M.laser.getTotalLength(self)
    len_end = min(M.laser.getTotalLength(self), len_end)
    len_start = min(len_end, len_start)
    local w = lstg.world
    local cx, cy =  M.laser.getCosSinRot(self)
    local _x, _y = self.x, self.y
    local x, y = 0, 0
    local count = 0
    for l = len_start, len_end, dl do
        x, y = _x + l * cx, _y + l * cy
        if (x <= w.r and x >= w.l) and (y <= w.t and y >= w.b) then
            func(x, y, l, self)
            count = count + 1
        end
    end
    return count
end
--region 删除模块
--删除激光并掉落道具（返回产生了多少个点）
local function drop_item(self, len_start, len_end)
    len_start = len_start or 0
    len_end = len_end or M.laser.getTotalLength(self)
    local count = M.laser.totalLaserDo(self, len_start, len_end, 10,
            function(x, y, l, self)
                item.PointSmall.create(x, y)
                New(BulletBreak, x, y, self._index or self.color)
            end)
    return count
end
--返回产生了多少个点
function M.laser:kill()
    M.laser.turnOff(self)
    local count = drop_item(self)
    return count
end
--删除激光
local function del_laser(self, len_start, len_end)
    len_start = len_start or 0
    len_end = len_end or M.laser.getTotalLength(self)
    M.laser.totalLaserDo(self, len_start, len_end, 10,
            function(x, y, l, self)
                New(BulletBreak, x, y, self._index or self.color)
            end)
end
function M.laser:del()
    del_laser(self)
    --self.status = "del"
     M.laser.turnOff(self)
end
--endregion

--region 截断模块
--传入截断长度，头长和尾长，取得截断后的头长和尾长
local function trailAndHeadCut(left_len, l1, l3)
    left_len = abs(left_len)  --超出激光身长部分取正
    local dl = l1 - l3 --尾长与头长的差
    if dl > 0 then --尾长比头长要长
        if left_len > dl then
            left_len = left_len - dl
            left_len = 0.5*left_len
            l3 = l3 - left_len
            l1 = l3
        else
            l1 = l1 - left_len
        end
    else --头长比尾长要长
        dl = -dl --先取正
        if left_len > dl then
            left_len = left_len - dl
            left_len = 0.5*left_len
            l1 = l1 - left_len
            l3 = l1
        else
            l3 = l3 - left_len
        end
    end
    return l1, l3
end

---@param self laser
---@param cut_len number 被截断的长度，只能为正数
local function cutLaserFromTrailOrHead(self, cut_len)
    local left_len = M.laser.getLength(self, M.LASER_BODY) - cut_len --先与激光身长作比较
    if left_len > 0 then --如果激光身比截断长度更长
        --然后激光身长度缩短为截断后的剩余长度
        if self.islocked then --静态激光只改变当前长度
            M.laser.setLength(self, M.LASER_BODY, left_len)
        else --移动激光则影响全部长度
            M.laser.setMaxLength(self, M.LASER_BODY, left_len)
        end
    else --如果截断长度比激光身更长（但一定会比整根激光短）
        local l1, l3 = trailAndHeadCut(-left_len, M.laser.getLength(self, M.LASER_TRAIL), M.laser.getLength(self, M.LASER_HEAD))
        --取得截断后的l1, l3的长度，传-left_len的原因是它是正数
        if self.islocked then --静态激光只改变当前长度
            M.laser.setLength(self, M.LASER_TRAIL, l1)
            M.laser.setLength(self, M.LASER_BODY, 0)
            M.laser.setLength(self, M.LASER_HEAD, l3)
        else --移动激光则影响全部长度
            M.laser.setMaxLength(self, M.LASER_TRAIL, l1)
            M.laser.setMaxLength(self, M.LASER_BODY, 0)
            M.laser.setMaxLength(self, M.LASER_HEAD, l3)
        end
    end
end

--从激光尾开始截断
function M.laser:cutLaserFromTrail(len_end)
    local cosr, sinr = M.laser.getCosSinRot(self)
    cutLaserFromTrailOrHead(self, len_end - 0)--这个情况下截断的只有len_end - 0的长度
    if self.islocked then --静态激光不会改变激光头位置,而是生成一个激光
        local ori_maxlen = M.laser.getMaxTotalLength(self) --获取自己最大可延伸长度
        local l1, l2, l3 = M.laser.getLength(self, M.LASER_TRAIL), M.laser.getLength(self, M.LASER_BODY), M.laser.getLength(self, M.LASER_HEAD)
        local w0, w1 = M.laser.getTwoWide(self)
        local x, y = self.x + len_end*cosr, self.y + len_end*sinr
        New(M.revive_laser, self._type, self._index, x, y, self.v, self.rot, {l1, l2, l3}, w0, w1, 1, self.islocked, ori_maxlen - len_end - l1 - l2 - l3, self.left_time)
    else
        self.x, self.y = self.x + len_end*cosr, self.y + len_end*sinr  --动态激光实质是改变激光头位置
    end
end

--从激光头开始截断
function M.laser:cutLaserFromHead(len_start)
    local maxlen = M.laser.getTotalLength(self)
    cutLaserFromTrailOrHead(self, maxlen - len_start)--这个情况下截断的只有maxlen - len_start的长度
end

---@param len_start number 以激光头为起点0，距激光头多少位置开始
---@param len_end number 以激光头为起点0，距激光头多少位置结束（截断在start和end之间的激光部分）
---@return number 返回本次截断产生的消弹点数
function M.laser:cut(len_start, len_end, drop)
    local count = -1 --产生点的计数器
    if self.colli and not self.no_cut and not self.turn_off then --没判定你截你马呢？
        local maxlen = M.laser.getTotalLength(self) --获取激光最大长度
        len_start = max(0, len_start) --start最小也是0
        len_end = max(len_start, min(maxlen, len_end)) --限制范围，end最大是maxlen, 且end一定大于等于start
        if len_end == len_start then --无效的截断，直接返回
            return count
        elseif len_end - len_start >= maxlen then --整段截断
            if not self.islocked then --动态的激光直接移除
                if drop then
                    count = M.laser.kill(self)
                else
                    M.laser.del(self)
                    count = 0
                end
            else --静态的激光是无法被清除的
                if drop then
                    count = drop_item(self, 0, maxlen)
                else
                    del_laser(self, 0, maxlen)
                    count = 0
                end
                local w0 = M.laser.getTwoWide(self)
                M.laser.setLength(self, M.LASER_TRAIL, 1*w0) --尾长还是要一点点的，然后要打上不可再被重复消除的标记，防止一帧内被大量重复消除产生活动块影响性能
                self.no_cut = true
                M.laser.setLength(self, M.LASER_BODY, 0)
                M.laser.setLength(self, M.LASER_HEAD, 0) --身长和头长直接清0
            end
        elseif len_start == 0 then--如果是从激光尾的另一端开始截
            if drop then
                count = drop_item(self, 0, len_end)
            else
                del_laser(self, 0, len_end)
                count = 0
            end
            M.laser.cutLaserFromTrail(self, len_end)
        elseif len_end == maxlen then --如果从激光头开始截
            if drop then
                count = drop_item(self, len_start, maxlen)
            else
                del_laser(self, len_start, maxlen)
                count = 0
            end
            M.laser.cutLaserFromHead(self, len_start)
        else --最麻烦的情况，从中间开始截断
            local cosr, sinr = M.laser.getCosSinRot(self)
            if drop then
                count = drop_item(self, len_start, len_end)
            else
                del_laser(self, len_start, len_end)
                count = 0
            end
            local ori_maxlen = M.laser.getMaxTotalLength(self) --获取激光能达到最大的总长度
            local l1, l3 = M.laser.getLength(self, M.LASER_TRAIL), M.laser.getLength(self, M.LASER_HEAD)
            local LL = 1*M.laser.getTwoWide(self) --根据最小宽度的比例来决定截断后新的头尾长
            local left_len
            --然后是end，因为截断了，所以采用生成一个新的激光处理
            left_len = maxlen - len_end --新生成激光的总长度
            left_len = left_len - l3 --减去已知的头长度
            left_len = left_len - LL --减去已知的尾长度
            if left_len > 0 then --减完后还有身长
                local l1, l2, l3 = LL, left_len, l3
                local w1 = M.laser.getWideByLength(self, len_end)
                local x, y = self.x + len_end*cosr, self.y + len_end*sinr
                New(M.revive_laser, self._type, self._index, x, y, self.v, self.rot, {l1, l2, l3}, self.w0, w1, 1, self.islocked, maxlen - (ori_maxlen + l1 + l2 + l3), self.left_time)
            else --减完后没身长了，再从头尾砍
                local l1, l3 = trailAndHeadCut(-left_len, LL, l3)
                local w0 = M.laser.getWideByLength(self, len_end)
                local x, y = self.x + len_end*cosr, self.y + len_end*sinr
                New(M.revive_laser, self._type, self._index, x, y, self.v, self.rot, {l1, 0, l3}, w0, w0, 1, self.islocked, maxlen - (ori_maxlen + l1 + l3), self.left_time)
            end

            --先从start开始
            left_len = len_start - LL
            left_len = left_len - l1
            if left_len > 0 then
                if not self.islocked then --动态的激光可以处理一下粗细变化细节
                    self.base_w1 = M.laser.getWideByLength(self, len_start) --获取截断处的宽度，作为截断后激光的最大宽度
                    self.w1 = self.base_w1*self.vscale --实际判定也要更新上的
                end
                M.laser.setLength(self, M.LASER_BODY, left_len)
                M.laser.setLength(self, M.LASER_HEAD, LL)
            else
                local l1, l3 = trailAndHeadCut(-left_len, l1, LL)
                if not self.islocked then --动态的激光可以处理一下粗细变化细节
                    --同上 -left_len 为正数
                    self.base_w0 = M.laser.getWideByLength(self, len_start) --获取截断处的宽度，作为截断后激光的最大和最小宽度
                    self.base_w1 = self.base_w0
                    self.w0, self.w1 = self.base_w0*self.vscale, self.base_w1*self.vscale --实际判定也要更新上的
                end
                M.laser.setLength(self, M.LASER_TRAIL, l1)
                M.laser.setLength(self, M.LASER_BODY, 0)
                M.laser.setLength(self, M.LASER_HEAD, l3)
            end
        end
    end
    return count
end

--给定一个任意的圆，对激光进行截断（仅针对单个激光）（返回产生了多少个消弹点）
function M.laser:cutLaserByCircle(x1, y1, r, drop)
    local count = 0
    local x0, y0, rot = self.x, self.y, self.rot
    local dx, dy = (x1 - x0), (y1 - y0)
    dx, dy = EGGlib.Math.TranRot(dx, dy, -rot) --坐标系旋转 dx为旋转后的x之差，dy为圆心到激光直线的距离
    if abs(dy) < r then
        local d = sqrt(r*r - dy*dy)
        count = M.laser.cut(self, dx - d, dx + d, drop)
    end
    return count
end

--给定一个任意的圆，对场上所有激光进行截断（注意这个不是M.laser的类方法，是M的类方法）
function M.cutLasersByCircle(x1, y1, r, drop, cd)
    local count = 0
    cd = cd or 0
    local x0, y0, rot, dx, dy, d
    M.forEachLaserDo(function(obj)
        if IsValid(obj) then
            x0, y0, rot = obj.x, obj.y, obj.rot
            dx, dy = (x1 - x0), (y1 - y0)
            dx, dy = EGGlib.Math.TranRot(dx, dy, -rot) --坐标系旋转 dx为旋转后的x之差，dy为圆心到激光直线的距离
            if abs(dy) < r then
                d = sqrt(r*r - dy*dy)
                local maxlen = M.laser.getTotalLength(obj)
                if dx - d < maxlen and dx + d > 0 then --判断有没有被正确截断的方法：截断的起始位置要比激光当前长度小 并且 阶段的最终位置要比激光的起始0位置大）
                    M.laser.setGrowCD(obj, cd)
                end
                count = count + M.laser.cut(obj, dx - d, dx + d, drop, cd)
            end
        end
    end)
    return count
end

--清除场上所有激光及预警并返还消弹点
function M.killAllLasers()
    local count = 0
    M.forEachLaserDo(function(obj)
        if IsValid(obj) then
            count = count + M.laser.kill(obj)
        end
    end)
    return count
end

--清除场上所有激光及预警
function M.delAllLasers()
    M.forEachLaserDo(function(obj)
        if IsValid(obj) then
            Del(obj)
        end
    end)
end
--endregion

function M.laser:ChangeImage(type, color)
    --self.imgid = max(min(type, laser_texture_num - 1), 1) --种类序号
    --self.index = max(min(color, 16), 1) --颜色序号
    self._type = type --种类
    self._index = color --颜色
end
--更新宽
function M.laser:updateWide()
    self.w0, self.w1 = self.base_w0*self.vscale, self.base_w1*self.vscale
end
--更新一次宽比
function M.laser:updateVscale()
    self.vscale = self.vscale + self.dvscale
    M.laser.updateWide(self)
end
--在t时间宽度变化多少
function M.laser:addVscale(dvscale, t)
    t = t or 1
    dvscale = dvscale/t
    self.vscale_t = t
    self.dvscale = dvscale
end
--激光默认启动动画
function M.laser:turnOn(t)
    if t <= 1 then
        self.vscale = 1
        M.laser.updateWide(self)
    else
        M.laser.addVscale(self, 1, t)
    end
end
--激光关闭动画
function M.laser:turnOff(t)
    t = t or 20
    M.laser.addVscale(self, -self.vscale, t)
    self.turn_off = true --标记flag
    self.colli = false
    task.clear(self) --清除所有task逻辑
end
--获取激光某部位的长度
function M.laser:getLength(pos)
    return self.len[pos]
end
--获取激光某部位最大长度
function M.laser:getMaxLength(pos)
    return self.max_len[pos]
end
--设置激光某部位长度
function M.laser:setLength(pos, len)
    len = min(self.max_len[pos], max(0, len))
    self.len[pos] = len
end
--设置激光某部位最大长度
function M.laser:setMaxLength(pos, len)
    len = max(0, len)
    self.max_len[pos] = len
    self.len[pos] = min(self.len[pos], self.max_len[pos])
end
--激光是不是达到最长了
function M.laser:isMaxLength()
    for i = 1, 3 do
        if M.laser.getMaxLength(self, i) ~= M.laser.getLength(self, i) then
            return false
        end
    end
    return true
end
--使激光某部位长度增加或者减少
function M.laser:addLength(pos, dlen)
    self.len[pos] = max(0, self.len[pos] + dlen)
end
--获取激光总长度
function M.laser:getTotalLength()
    return self.len[1] + self.len[2] + self.len[3]
end
--获取激光最大总长度
function M.laser:getMaxTotalLength()
    return self.max_len[1] + self.max_len[2] + self.max_len[3]
end
--获取激光身部位的宽度（也是激光最大宽度）
function M.laser:getTwoWide()
    return self.w0, self.w1
end
--获取激光某部位的宽度
---@param pos number 激光部位，尾部1，身部2，头部3
---@param rate number 取0-1，以激光方向为正方向，在该部位的百分之多少处，如rate = 0.5则表示在激光这个部分的中间处
function M.laser:getWide(pos, rate)
    local w0, w1 = M.laser.getTwoWide(self)
    if pos == 1 then
        return w0*rate
    elseif pos == 2 then
        if rate <= 0.5 then
            rate = 2*rate
        else
            rate = 2*(1 - rate)
        end
        return w0 + (w1 - w0)*rate
    elseif pos == 3 then
        return w0*(1-rate)
    else -- pos 不是 1 2 3则会报错
        error("pos = "..pos.." is not a true pos.")
    end
end
--获取激光某部位的判定
function M.laser:getColliWide(pos, rate)
    return M.laser.getWide(self, pos, rate)*M.getDefaultColliWideRate(self._type)
end
--根据沿激光方向的长度来获取激光某部位宽度
function M.laser:getWideByLength(len)
    local l1, l2, l3 = M.laser.getLength(self, 1), M.laser.getLength(self, 2), M.laser.getLength(self, 3)
    if len >= l1 + l2 + l3 then
        return -1 --超出激光长度部分宽度默认为-1，在比较时永远不会成立
    elseif len >= l1 + l2 then
        return M.laser.getWide(self, M.LASER_HEAD, (len - l1 - l2)/l3)
    elseif len >= l1 then
        return M.laser.getWide(self, M.LASER_BODY, (len - l1)/l2)
    elseif len > 0 then
        return M.laser.getWide(self, M.LASER_TRAIL, len/l1)
    else
        return -1 --小于等于0的部分也是-1，但是应该不会有人无聊到传负数进来吧？
    end
end
--根据沿激光方向的长度来获取激光某部位宽判定
function M.laser:getColliWideByLength(len)
    local w = M.laser.getWideByLength(self, len)
    if w == -1 then
        return w
    else
        return w*M.getDefaultColliWideRate(self._type)/2
    end
end
--获取角度的余弦值和正弦值
function M.laser:getCosSinRot()
    return self.cos, self.sin
end
--设置角度
function M.laser:setRot(rot)
    self.rot = rot
    self.cos, self.sin = cos(rot), sin(rot)
end
--获取角度
function M.laser:getRot()
    return self.rot
end
--角度增加
function M.laser:addRot(drot)
    self.rot = self.rot + drot
    self.cos, self.sin = cos(self.rot), sin(self.rot)
end
--暂停延长
function M.laser:setGrowCD(cd)
    self.grow_cd = max(cd, self.grow_cd)
end
--获取激光延长速度
function M.laser:getV()
    return self.v
end
--设置激光延长速度
function M.laser:setV(v)
    self.v = v
end
--增加激光速度
function M.laser:addV(dv)
    self.v = self.v + dv
end
----------------------考虑到新版激光消除的套娃逻辑，需要一个作为起始发射激光
---@class lead_laser 作为起始发射的激光
M.lead_laser = Class(M.laser)
function M.lead_laser:init(_type, color, x, y, v, rot, L, w0, w1, t, islocked, isshoot, left_time)
    local len0, max_len
    --两种初始化长度的方法
    local trail_w = 1*w0 --先给尾长一定初始值，使得激光生成动画时不会太难看
    if type(L) == "table" then --由表的信息创建激光
        max_len = {L[1], L[2], L[3]} --可被延伸的最大长度（l1、l2、l3分别代表尾、身、头长
        len0 = {min(trail_w, max_len[1]), 0, 0} --实际长度
    else --由总长自动创建激光
        local rate = M.getLengthWidthRatio(_type) --长宽比
        max_len = {w0*rate, max(0, L - 2*w0*rate), w0*rate} --可被延伸的最大长度
        len0 = {min(trail_w, max_len[1]), 0, 0} --实际长度
    end
    M.laser.init(self, _type, color, x, y, v, rot, len0, max_len, w0, w1, t, islocked, isshoot, left_time)
end

---@class revive_laser 常用于被消除后的套娃激光
M.revive_laser = Class(M.lead_laser)
function M.revive_laser:init(_type, color, x, y, v, rot, L, w0, w1, t, islock, begin_move_len, left_time)
    M.lead_laser.init(self, _type, color, x, y, v, rot, L, w0, w1, t, false, true, left_time)
    self.begin_move_len = begin_move_len --创建开始算，以速度v需要往激光头方向移动的距离
    self.master_islock = islock
    self.colli = false
end
function M.revive_laser:frame()
    --就是一开始还会再冲一段
    local d = self.v
    if self.begin_move_len > d then
        self.begin_move_len = self.begin_move_len - d
        --self.x, self.y = self.x + d*cos(self.rot), self.y + d*sin(self.rot) --不需要，因为前进逻辑在laser.frame里
        d = 0
    elseif self.begin_move_len > 0 then
        d = self.begin_move_len
        --self.x, self.y = self.x + d*cos(self.rot), self.y + d*sin(self.rot) --不需要，因为前进逻辑在laser.frame里
        d = self.v - d
    end
    if d ~= 0 and self.master_islock then
        M.laser.cutLaserFromHead(self, M.laser.getMaxTotalLength(self) - d)
    end
    M.lead_laser.frame(self)
end

local virtual_alpha_table = {}
local virtual_width_table = {}
for i = 1, 42 do
    virtual_alpha_table[i] = 255*(1 - i/42)
    virtual_width_table[i] = 3*i/42
end
---@class warning_laser 预警线（注意是线）
M.warning_laser = Class(object)
function M.warning_laser:init(x, y, maxlen, len_t, maxwide, wide_t, rot, b, c, left_time, disappear_time)
    self.x, self.y = x, y
    self.rot = rot --本类对象角度不支持直接设置rot，需要用类方法更新
    --自身朝向的正弦值和余弦值（优化）
    self.cos = cos(rot)
    self.sin = sin(rot)

    self.turn_off = false --当宽度小于等于0或者透明度小于等于0的时候，该flag为true时会删除本对象
    self.group = GROUP_INDES
    self.layer = LAYER_PLAYER + 1 --激光预警可以挡自机贴图但不能挡判定点
    self.a, self.b = 0, 0  --这个是作为普通子弹的判定，不要有
    self.colli = false
    self._blend = b
    self._color = c
    --长度宽度
    self.len = 0 --当前长度
    self.d_len = maxlen/len_t
    self.len_t = len_t
    self.wide = 0 --当前宽度
    self.d_wide = maxwide/wide_t
    self.wide_t = wide_t
    self.turn_off = false --标记关闭的flag
    self.left_time = left_time or 9999 --自动关闭时间
    self.disappear_time = disappear_time or 20 --激光关闭动画时间
    self._index = 1 --播放的img下标
    self.ex_frame = blank_func --额外帧逻辑
    --透明渐变头长、尾长
    self.head_len = 40
    self.trail_len = 0
end

function M.warning_laser:frame()
    task.Do(self)
    --长度更新
    if self.len_t > 0 then
        self.len = self.len + self.d_len
        self.len_t = self.len_t - 1
    end
    --宽度更新
    if self.wide_t > 0 then
        self.wide = self.wide + self.d_wide
        self.wide_t = self.wide_t - 1
    end
    if self.turn_off then
        self._index = min(self._index + 0.25, 7)
        if self.wide <= 0 then
            self.status = "del"
        end
    else
        self._index = min(self._index + 0.25, 6)
    end

    self.left_time = self.left_time - 1
    if self.left_time == 0 then
        M.warning_laser.del(self, self.disappear_time)
    end

    self.ex_frame(self) --额外帧逻辑
end

local function createWarningLaser(self, img, x, y, wx, wy, lx, ly, wscale)
    createNewLaser2(img, self._blend, self._color, x, y, wx, wy, lx, ly, wscale)
    local t = self.timer
    if t <= 42 then
        createNewLaser2(img, self._blend, Color(virtual_alpha_table[t], 255, 255, 0), x, y, wx*virtual_width_table[t], wy*virtual_width_table[t], lx, ly, 1)
    end
end

function M.warning_laser:render()
    local cosr, sinr = M.laser.getCosSinRot(self)
    local w, l = M.warning_laser.getWide(self), M.warning_laser.getLength(self)
    local h_len, t_len = M.warning_laser.getHeadLength(self), M.warning_laser.getTrailLength(self)
    local wx, wy = -w*sinr, w*cosr
    if h_len == 0 and t_len == 0 then --头尾都没渐变时
        local lx, ly = l*cosr, l*sinr
        createWarningLaser(self, "warning_laser_effect"..math.floor(self._index), self.x, self.y, 3*wx, 3*wy, lx, ly, 1)
    elseif t_len == 0 then --仅头有渐变
        if h_len >= l then --渐变比总长要长
            local lx, ly = l*cosr, l*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x, self.y, 3*wx, 3*wy, lx, ly, 1)
        else
            l = l - h_len
            local lx, ly = l*cosr, l*sinr
            createWarningLaser(self, "warning_laser_effect"..math.floor(self._index), self.x, self.y, 3*wx, 3*wy, lx, ly, 1)
            local lx1, ly1 = h_len*cosr, h_len*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lx, self.y + ly, 3*wx, 3*wy, lx1, ly1, 1)
        end
    elseif h_len == 0 then --仅尾有渐变
        if t_len >= l then --渐变比总长要长
            local lx, ly = l*cosr, l*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lx, self.y + ly, 3*wx, 3*wy, -lx, -ly, 1)
        else
            local lx, ly = t_len*cosr, t_len*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lx, self.y + ly, 3*wx, 3*wy, -lx, -ly, 1)
            l = l - t_len
            local lx1, ly1 = l*cosr, l*sinr
            createWarningLaser(self, "warning_laser_effect"..math.floor(self._index), self.x + lx, self.y + ly, 3*wx, 3*wy, lx1, ly1, 1)
        end
    else --头尾都有渐变，好麻烦啊
        if h_len + t_len >= l then --渐变比总长要长
            if l/2 > h_len then
                t_len = l - h_len
            elseif l/2 > t_len then
                h_len = l - t_len
            else
                h_len = l/2
                t_len = l/2
            end
            local lxt, lyt = t_len*cosr, t_len*sinr
            local lxh, lyh = h_len*cosr, h_len*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lxt, self.y + lyt, 3*wx, 3*wy, -lxt, -lyt, 1)
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lxt, self.y + lyt, 3*wx, 3*wy, lxh, lyh, 1)
        else
            l = l - t_len - h_len
            local lxt, lyt = t_len*cosr, t_len*sinr
            local lx, ly = l*cosr, l*sinr
            local lxh, lyh = h_len*cosr, h_len*sinr
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lxt, self.y + lyt, 3*wx, 3*wy, -lxt, -lyt, 1)
            createWarningLaser(self, "warning_laser_effect"..math.floor(self._index), self.x + lxt, self.y + lyt, 3*wx, 3*wy, lx, ly, 1)
            createWarningLaser(self, "warning_laser_head_effect"..math.floor(self._index), self.x + lxt + lx, self.y + lyt + ly, 3*wx, 3*wy, lxh, lyh, 1)
        end
    end
end

function M.warning_laser:getWide()
    return self.wide
end

function M.warning_laser:getLength()
    return self.len
end

function M.warning_laser:setHeadLength(len)
    self.head_len = len
end

function M.warning_laser:setTrailLength(len)
    self.trail_len = len
end

function M.warning_laser:getHeadLength()
    return self.head_len
end

function M.warning_laser:getTrailLength()
    return self.trail_len
end

function M.warning_laser:turnOff(t)
    self.d_wide = -M.warning_laser.getWide(self)/t
    self.wide_t = _infinite --修复了，之前设置值为t，可能会因为浮点数原因而达不到删除判定条件，造成对象残余。
    self.turn_off = true
    self.group = GROUP_GHOST
    task.clear(self) --清除所有task
end

function M.warning_laser:kill()
    M.warning_laser.turnOff(self, 20)
    self.status = "normal"
end

function M.warning_laser:del(t)
    t = t or 20
    M.warning_laser.turnOff(self, t)
    self.status = "normal"
end


---@class warning_laser2 双色预警线
--先继承常规预警线的所有方法
M.warning_laser2 = Class(M.warning_laser)
for key, func in pairs(M.warning_laser) do
    M.warning_laser2[key] = func
end
--override
function M.warning_laser2:init(x, y, maxlen, len_t, maxwide, wide_t, rot, b1, c1, b2, c2, left_time, disappear_time)
    M.warning_laser.init(self, x, y, maxlen, len_t, maxwide, wide_t, rot, b1, c1, left_time, disappear_time)
    self._blend2 = b2
    self._color2 = c2
    self.alpha = 1
end
function M.warning_laser2:render()
    local cosr, sinr = M.laser.getCosSinRot(self)
    local w, l = M.warning_laser.getWide(self), M.warning_laser.getLength(self)
    local wx, wy = -w*sinr, w*cosr
    local lx, ly = l*cosr, l*sinr
    local alpha, c1, c2 = self.alpha, self._color, self._color2
    createNewLaser2("warning_laser_effect"..math.floor(self._index), self._blend2, Color(c2.a*alpha, c2.r, c2.g, c2.b), self.x, self.y, 3*wx, 3*wy, lx, ly, 1)
    createNewLaser2("warning_laser_effect"..math.floor(self._index), self._blend, Color(c1.a*alpha, c1.r, c1.g, c1.b), self.x, self.y, 1*wx, 1*wy, lx, ly, 1)
end
function M.warning_laser2:setAlpha(a)
    self.alpha = a
end
