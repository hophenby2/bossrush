-- TH34/TH35 原版弹幕与跨卡清场回归；使用真实协程、子弹样式和激光实现。
-- 在游戏根目录运行：luajit tools/check_th35_patterns.lua
arg[1] = 'th35-patterns'
local f = assert(io.open('tools/check_stage.lua', 'rb'))
local setup = f:read('*a'); f:close()
assert(loadstring(setup:sub(1, assert(setup:find('if path == "--all" then', 1, true)) - 1)))()
-- 只补资源入口；运动、出膛、协程和光柱判定均加载游戏本身的代码。
EnumRes2 = function() return {} end
CopyImage = function() end
local image_geometry, drawn = {}, {}
LoadImage = function(name, _, _, _, w, h)
    image_geometry[name] = { w = w, h = h, cx = w / 2, cy = h / 2 }
end
LoadImageGroup = function(prefix, tex, x, y, w, h, cols, rows)
    for i = 1, cols * rows do LoadImage(prefix .. i, tex, x, y, w, h) end
end
SetImageCenter = function(name, cx, cy)
    local g = image_geometry[name]
    if g then g.cx, g.cy = cx, cy end
end
Render = function(name, x, y, rot, hs, vs)
    drawn[#drawn + 1] = { name = name, x = x, y = y, rot = rot, hs = hs, vs = vs }
end
SetImageScale = function() end
SetAnimationScale = function() end
SetAnimationCenter = function() end
dofile('THlib/lib/Ltask.lua')
dofile('THlib/bullet/bullet.lua')
dofile('THlib/bullet/bulletStyle.lua')
dofile('THlib/laser/laser.lua')
player.class = { colli = function() end }
player.grazer = { a = 16, class = { colli = function() end } }
local objects, shots, cards, laser_births = {}, {}, {}, {}
New = function(c, ...)
    -- 不把类表用作 __index：实例只能读自己的字段，回调由引擎显式从类表调用。
    local o = setmetatable({ class = c, timer = 0, ani = 0, x = 0, y = 0, rot = 0, vx = 0, vy = 0,
        dx = 0, dy = 0, omiga = 0, hscale = 1, vscale = 1, bound = true, colli = true, _live = true }, {
            -- 真引擎在 __index / __newindex 中验证对象句柄；回收后不能再清空 task。
            __index = function(o)
                assert(rawget(o, '_live'), 'invalid lstg object')
            end,
            __newindex = function(o, key, value)
                assert(rawget(o, '_live'), 'invalid lstg object')
                rawset(o, key, value)
            end,
        })
    objects[#objects + 1] = o
    c.init(o, ...)
    if o.IsLaser then
        o.test_laser_shooter = #task.stack > 0 and task.GetSelf() or nil
        laser_births[#laser_births + 1] = o
    end
    if o.frame_other then
        local shooter = task.GetSelf()
        o.test_owner = shooter and shooter.t10_root
        shots[#shots + 1] = o
    end
    return o
end
IsValid = function(o) return o ~= nil and rawget(o, '_live') == true end
-- status='del' 到帧尾才真正释放句柄，当前 frame 可以正常返回。
object.RawDel = function(o) o._pending_delete = true end
object.Del = object.RawDel
object.Preserve = function(o) o._pending_delete = nil end
GetnObj = function() return #objects end
boss.card.add = function(parts, _, _, id) cards[id] = parts[1][1] end
dofile('mod/GAME/th35.lua')
local checks = 0
local function check(value, message)
    assert(value, message); checks = checks + 1
end
local function near(a, b) return math.abs(a - b) < 1e-6 end
local function start(id)
    local b = { x = 0, y = 80, _live = true }
    b.current_card = assert(cards[id]); b.current_card.init(b)
    return b
end
local function stop(b) b.current_card.del(b); b._live = false end
local function step(n)
    for _ = 1, n do
        local count = #objects
        for i = 1, count do
            local o = objects[i]
            if IsValid(o) and not o._pending_delete then
                o.class.frame(o)
                if IsValid(o) and not o._pending_delete then
                    o.dx, o.dy = o.vx, o.vy
                    o.x, o.y = o.x + o.vx, o.y + o.vy
                    o.rot = o.rot + o.omiga
                    if o.bound and (o.x < -224 or o.x > 224 or o.y < -256 or o.y > 256) then o._live = false end
                    o.timer, o.ani = o.timer + 1, o.ani + 1
                end
            end
        end
        for i = #objects, 1, -1 do
            local o = objects[i]
            if rawget(o, '_pending_delete') then
                if o.class.del then o.class.del(o) end
                if rawget(o, '_pending_delete') then rawset(o, '_live', false) end
            end
            if not IsValid(o) then table.remove(objects, i) end
        end
    end
end
local function lasers(root, stationary)
    local result = {}
    for _, o in ipairs(objects) do
        if IsValid(o) and not o._pending_delete and o.IsLaser and o.t10_root == root and ((o.t10_state ~= nil) == stationary) then
            result[#result + 1] = o
        end
    end
    return result
end
local function count_shots(root)
    local n = 0
    for _, b in ipairs(shots) do if b.test_owner == root then n = n + 1 end end
    return n
end
local function check_laser_quad(l, width, message)
    drawn = {}
    l.class.render(l)
    local along_min, along_max, across_min, across_max = 1e9, -1e9, 1e9, -1e9
    local dx, dy = math.cos(math.rad(l.rot)), math.sin(math.rad(l.rot))
    for _, draw in ipairs(drawn) do
        local g = assert(image_geometry[draw.name], '激光图片未注册：' .. draw.name)
        local a = math.rad(draw.rot)
        for _, corner in ipairs({ {0, 0}, {g.w, 0}, {g.w, g.h}, {0, g.h} }) do
            local x, y = (corner[1] - g.cx) * draw.hs, (g.cy - corner[2]) * draw.vs
            x, y = x * math.cos(a) - y * math.sin(a) + draw.x - l.x,
                x * math.sin(a) + y * math.cos(a) + draw.y - l.y
            local along, across = x * dx + y * dy, -x * dy + y * dx
            along_min, along_max = math.min(along_min, along), math.max(along_max, along)
            across_min, across_max = math.min(across_min, across), math.max(across_max, across)
        end
    end
    check(near(along_min, 0) and near(along_max, l.l1 + l.l2 + l.l3)
        and near(across_min, -width / 2) and near(across_max, width / 2), message)
end
-- 旧卡晚于新卡结束：原实现会把新卡载体一起删掉，之后 600 帧仍是 0 发。
local old = start(3638); step(20)
local inheritor = start(3637); step(1)
check(IsValid(old.th10carrier), '新卡的 enmKillAll 不能删除仍在战斗的旧 Boss')
stop(old)
check(IsValid(inheritor.th10carrier), '旧卡 del 不能删除一子相传的主载体')
step(100)
local expired_pod
for _, o in ipairs(objects) do
    if IsValid(o) and o.class == _editor_class.TH35.th10_ecs_pod and o ~= inheritor.th10carrier then
        expired_pod = o; break
    end
end
check(expired_pod ~= nil, '一子相传的 Dummy 子机已启动')
step(120)
check(not IsValid(expired_pod), 'Dummy 自然结束并释放句柄，留下待清理的旧引用')
check(count_shots(inheritor.th10carrier) == 1500, '二进制 stage05.ecl：三只 Dummy 各 5×20×5，一轮共 1500 发')
local live = 0
for _, b in ipairs(shots) do if b.test_owner == inheritor.th10carrier and IsValid(b) and b.img then live = live + 1 end end
check(live > 0, '真实子弹样式完成出膛，屏幕中有可绘制的弹')
step(420)
check(count_shots(inheritor.th10carrier) == 3000, '后续 420 帧仍按原 ECL 周期再发 1500 发')
stop(inheritor)
step(1)
stop(inheritor)
check(true, '换卡清理跳过已释放子机，重复清理也不会写入失效句柄')
-- 客星：op433 从 etOffset(0,±128,0) 出生，64 帧长到 128，随后以 2 px/帧平移。
local guest = start(3638); step(95)
local rays = lasers(guest.th10carrier, false)
check(#rays >= 2, '客星的两条异步激光枪均已启动')
local right, left
for _, l in ipairs(rays) do
    if near(l.x, 128) then right = right or l end
    if near(l.x, -128) then left = left or l end
end
check(right and left, '左右发射点分别为 Boss X±128，不能把额外参数静默丢掉')
check(right.index == 6 and right.l1 == 0 and right.l3 == 0, '按原作色号画整段光柱，不能用白色三角判定代替')
local first, x, y = right, right.x, right.y
while first.t10_age < 64 do step(1) end
check(near(first.x, x) and near(first.y, y) and near(first.l2, 128), '增长阶段固定尾端，64 帧达到原作长度')
check_laser_quad(first, 16, '客星绘制矩形长 128、全宽 16，不能按 THlib w/7 放大')
check(first.t10_sprite == 'th35_laser_3_6' and image_geometry[first.t10_sprite].h == 14,
    '客星使用原版 sprite70 的 16×14 透明边缘与亮芯')
step(1)
check(near(first.x - x, 2 * math.cos(first.t10_ang)) and near(first.y - y, -2 * math.sin(first.t10_ang)), '长满后的下一帧整段向前飞')
while first.t10_age < 100 do step(1) end
check(IsValid(first), '长满后超过 30 帧仍在场内，不能按旧伪寿命提前删除')
local line_class = first.class
local source_program = { { a = 1, k = 134217728, i0 = 1, i1 = -999999, f0 = -999999, f1 = -999999 } }
local independent1 = New(line_class, 0, 0, 3, 6, 0, 0, 128, 2, 0, 16, source_program)
local independent2 = New(line_class, 0, 0, 3, 6, 0, 0, 128, 2, 0, 16, source_program)
step(1)
check(source_program[1].i0 == 1 and independent1.t10_program[1].i0 == 0
    and independent2.t10_program[1].i0 == 0, '每根激光独立消耗一次反射，不修改枪或其他激光的预算')
object.RawDel(independent1); object.RawDel(independent2)
-- op433 复制的 etEx 不能丢掉：七石七木先减速转向、等 120 帧，再沿原方向加速。
local program = {
    { a = 0, k = 64, i0 = 120, i1 = 1, f0 = 0, f1 = 0.01 },
    { a = 0, k = 32768, i0 = 120, i1 = -999999, f0 = -999999, f1 = -999999 },
    { a = 0, k = 16, i0 = 120, i1 = -999999, f0 = 0.03, f1 = -999999 },
}
local accelerated = New(line_class, 0, 200, 3, 4, math.pi / 2, 0, 320, 8, 0, 16, program)
step(130)
check(IsValid(accelerated) and near(accelerated.t10_spd, 0.01), '激光按复制的 etEx 转向减速，再进入等待')
step(120)
check(IsValid(accelerated) and accelerated.t10_spd > 0.01, 'etEx 等待结束后恢复加速，不能把整条程序忽略')
object.RawDel(accelerated)
local reflected = New(line_class, 180, 0, 3, 6, 0, 0, 128, 2, 0, 16,
    { { a = 1, k = 134217728, i0 = 1, i1 = -999999, f0 = -999999, f1 = -999999 } })
reflected.t10_root = guest.th10carrier
step(8)
local reflection
for _, l in ipairs(lasers(guest.th10carrier, false)) do
    if near(l.x, 192) and near(math.abs(l.t10_ang), math.pi) then reflection = l; break end
end
check(reflection and reflected.t10_ang == 0, '客星在头端碰到侧边时另生反射段，原光柱继续飞出')
check(reflection.t10_root == guest.th10carrier, '反射段继承卡片所有者，换卡时不会漏清')
check(reflection.t10_program[1].i0 == 0, '客星的反射段继承已消耗的计数，不能再次反射')
object.RawDel(reflected)
-- 原作 LaserLine：terminalDistance=20 时，头在 20 处停止、尾继续追上，最后回收。
local terminal = New(line_class, 0, 0, 3, 6, 0, 0, 10, 2, 20, 16)
step(5); check(near(terminal.l2, 10) and near(terminal.x, 0), '有限行程光柱先长到 maximumLength')
step(6); check(near(terminal.x, 12) and near(terminal.l2, 8), '到终点后长度收缩，不能整段突然消失')
step(4); check(not IsValid(terminal), '尾端走完总行程后回收')
local leaving = New(line_class, 0, 0, 3, 6, 0, 0, 128, 2, 0, 16)
step(200); check(not IsValid(leaving), '无终点的移动激光按头尾出界回收')
check(#lasers(guest.th10carrier, false) > 0, '持续射击不会因旧激光回收而停枪')
local function primary_count(root)
    local n = 0
    for _, l in ipairs(laser_births) do if rawget(l, 'test_laser_shooter') == root then n = n + 1 end end
    return n
end
local peak, emitted_before = 0, primary_count(guest.th10carrier)
for _ = 1, 7200 do
    step(1)
    local n = #lasers(guest.th10carrier, false)
    assert(n <= 256, '客星反射激光超过原作 256 槽上限')
    peak = math.max(peak, n)
end
check(peak < 256, '客星一次反射的正常轨迹不会长期耗尽激光槽')
check(primary_count(guest.th10carrier) - emitted_before == 3600, '7200 帧中两把枪每 4 帧各生一根，3600 次原始发射全部成功')
print(('客星长测：7200 帧原始发射 3600/3600，激光峰值 %d/256'):format(peak))
stop(guest)
check(#lasers(guest.th10carrier, false) == 0, '换卡清理本卡全部移动激光及反射段')
-- 摩西：op413 的初始长度=最大长度，1/10/30/1 帧预警/变粗/保持/消散。
local moses = start(3639); step(100)
local walls = lasers(moses.th10carrier, true)
check(#walls > 0, '摩西的固定激光已生成')
local wall = walls[1]
check(near(math.abs(wall.x), 224), '固定激光也保留 etOffset 的场边发射位置')
check_laser_quad(wall, wall.w, '固定激光也按原版当前宽度绘制，不放大到 16/7 倍')
local wx, wy = wall.x, wall.y
step(2); check(near(wall.x, wx) and near(wall.y, wy), 'laserStOn 保持固定位置')
step(45); check(not IsValid(wall), '固定激光完成四段状态后回收')
stop(moses)
-- 穀物：原先把 op413 误当移动激光，还把 op412 的 speed=20 写成 2.5。
local harvest = start(3632); step(160)
local warning = lasers(harvest.th10carrier, true)
check(#warning == 64, '穀物的 Lunatic 行一轮生成 64 根固定预警激光')
local preview = warning[1]
check(preview.t10_state == 3 and not preview.colli and near(preview.w, 2), '预警期间只有细线，无命中判定')
step(72)
check(preview.t10_state == 2 and preview.colli and near(preview.w, 16), '预警和变粗结束后进入全宽有效阶段')
step(20)
local mobile = lasers(harvest.th10carrier, false)
check(#mobile > 0 and near(mobile[1].t10_spd, 20), '穀物的另一把枪按二进制 ECL 以 20 px/帧射出')
step(90); check(not IsValid(preview), '穀物的固定激光按 60/20/60/20 帧消散')
stop(harvest)
local wide = New(line_class, 0, 0, 13, 1, 0, 128, 512, 8, 0, 46)
check_laser_quad(wide, 46, '神奈子 46px 宽激光使用原版 30×30 精灵归一化')
check(wide.t10_sprite == 'th35_laser_13_1', '其他形状也使用各自原作精灵')
object.RawDel(wide); step(1)
check(not IsValid(wide), '原版出界/清理直接释放激光槽，不被 THlib del 保留 30 帧')
local fading = New(line_class, 1000, 1000, 3, 6, 0, 128, 128, 2, 0, 16)
fading.class.kill(fading)
check(fading.group == GROUP.GHOST, '消弹特效移出激光碰撞组，不继续占用发射槽')
check_laser_quad(fading, 16, '消散特效继续使用原版精灵与宽度，不切回 THlib 放大贴图')
step(31)
check(not IsValid(fading), '消散特效按框架原有 30 帧淡出并释放')
-- stage02.ecl 的 BossTrace/op294 复制 specialEnemySlots[0]，不取玩家坐标。
player.x, player.y = 123, -176
local dolls = start(3636); step(140)
local arms = {}
for _, o in ipairs(objects) do
    if IsValid(o) and o.class == _editor_class.TH35.th10_ecs_pod
        and o.t10_root == dolls.th10carrier and o ~= dolls.th10carrier then arms[#arms + 1] = o end
end
check(#arms == 4, '流刑人形按原作生成四只旋转子机')
step(90)
for _, o in ipairs(arms) do
    check(near(o.ecs.off.x, dolls.th10carrier.ecs.wx) and near(o.ecs.off.y, dolls.th10carrier.ecs.wy),
        '人形圆心跟随 Boss，不跟随自机')
    check(near(o.ecs.base.r, 80), '人形保留原作 80px 圆轨道')
end
player.x, player.y = -137, -201; step(3)
for _, o in ipairs(arms) do
    check(near(o.ecs.off.x, dolls.th10carrier.ecs.wx) and near(o.ecs.off.y, dolls.th10carrier.ecs.wy),
        '自机大幅移动不会拖动人形圆心')
end
stop(dolls)

-- TH07 ecldata6.ecl sub67/68：六条刀光每组 60 帧总共转约 60°，接口只收弧度。
dofile('mod/GAME/th34.lua')
local butterfly = New({
    init = function(o) o.bound = false; o.current_card = cards[4401]; o.current_card.init(o) end,
    frame = function(o) o.current_card.frame(o); task.Do(o) end,
})
local swords
for _ = 1, 800 do
    step(1)
    local found = {}
    for _, o in ipairs(objects) do if IsValid(o) and o.pl_t then found[#found + 1] = o end end
    if #found == 6 then swords = found; break end
end
check(swords ~= nil, '反魂蝶首轮生成左右两组三条激光')
local angles = { -math.pi, math.pi / 3, -math.pi / 3, 0, -2 * math.pi / 3, 2 * math.pi / 3 }
local initial = {}
for i, o in ipairs(swords) do
    initial[i] = o.pl_ang
    check(near(o.pl_ang, angles[i]), '刀光初始角只转换坐标方向，不预乘角度系数')
end
step(60)
local turn = (1 - (1 - 59 / 60)^2) * math.pi / 3
for i, o in ipairs(swords) do
    local expected = initial[i] + (i <= 3 and turn or -turn)
    check(near(o.pl_ang, expected), '刀光按原作缓动旋转，左右各约 60°')
    check(near(o.rot, expected * 180 / math.pi), '只在写入引擎 rot 时转成度')
    check(near(o.x, o.pl_x + math.cos(expected) * 64)
        and near(o.y, o.pl_y + math.sin(expected) * 64), '激光尾端停在正确的 64px 偏移位置')
end
butterfly.current_card.del(butterfly); task.Clear(butterfly); object.RawDel(butterfly)
-- 同一弧度接口的五连激光也不能预先转成度，防止只修反魂蝶而遗留相同错误。
local exile = New({
    init = function(o) o.bound = false; o.current_card = cards[4393]; o.current_card.init(o) end,
    frame = function(o) o.current_card.frame(o); task.Do(o) end,
})
local fan
for _ = 1, 700 do
    step(1)
    local found = {}
    for _, o in ipairs(objects) do if IsValid(o) and o.pl_t and not o._pending_delete then found[#found + 1] = o end end
    if #found == 5 then fan = found; break end
end
check(fan ~= nil, '共用接口的亡我乡五连激光正常生成')
for _, o in ipairs(fan) do check(near(o.pl_ang, math.pi), '五连激光初始角为 π 弧度，不重复换算') end
exile.current_card.del(exile); task.Clear(exile); object.RawDel(exile)
print(('通过：TH34/TH35 原版弹幕与跨卡清场 %d 项回归检查'):format(checks))
