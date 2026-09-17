---=====================================
---子弹威胁计算器（独立工具，引擎不会载入）
---
---按《什么是好的弹设.md》实现：
---
---  二、子弹威胁度 = Σ_帧 [该帧会打到自机] × 权重
---       权重 = 危险方向数 / 16
---       一个方向"安全"= 沿它量过去有 (5 + 自机判定半径) px 以上的空隙
---       **奇数狙不计入"会被打到"的帧数**（不动的自机必中，微移就能躲），
---       但它封死 16 方向里的 9 个（发弹源连线上的 2 个 + 某一侧的 7 个），
---       两侧分别算一遍取更小的那个安全数。
---  三、合理展开 = 至少一种限位 + 至少一种威胁
---  四、限位 = 安全区周期性出现（左→右→左），或成一个随时间收缩的单一安全区
---  五、同一时刻作用于自机的威胁组数应当是 1 或 2；总威胁度应在 **0.5 ~ 1.5**
---
---  用法：
---    luajit tools/threat.lua mod/GAME/th04.lua                  # 全部卡
---    luajit tools/threat.lua mod/GAME/th04.lua 1800             # 指定帧数
---    THREAT_CARDS=3,4 luajit tools/threat.lua mod/GAME/th04.lua # 只测某几张
---    THREAT_POS=0,-176 luajit tools/threat.lua mod/GAME/th04.lua  # 自机钉死在一点
---    THREAT_PLAYER_R=1 luajit tools/threat.lua …                # 自机判定半径（默认 1）
---
---复用 `check_stage.lua` 的整套引擎桩件与逐帧调度（它暴露了 STAGE_HOOK）。
---=====================================

local PATH = arg[1]
if not PATH then
    print("用法: luajit tools/threat.lua <关卡文件> [帧数]")
    print("  THREAT_CARDS=1,3      只测这几张")
    print("  THREAT_POS=x,y        自机钉死在这点（默认用躲避机器人）")
    print("  THREAT_PLAYER_R=n     自机判定半径（默认 1）")
    os.exit(1)
end
local FRAMES = tonumber(arg[2]) or 1800

----------------------------------------------------------------------
-- 参数
----------------------------------------------------------------------
---文档原话是「(5 + 自机碰撞半径或半边长) 像素以上的空隙」。
---  自机半宽在 `THlib/player/*/[自机].lua` 里写 A/B（灵梦 0.5、魔理沙/文 1），取 1。
---  所以要求的空隙 = 5 + 1 = 6 px，**量到弹的表面**（要减掉弹自己的半径，
---  弹半径取自 `bulletStyle.lua` 的 LoadImageGroup 末两参，见 check_stage 的 STYLE_RADIUS）。
local PLAYER_R = tonumber(os.getenv("THREAT_PLAYER_R")) or 1
local GAP = 5 + PLAYER_R
---自机被判定的距离（引擎里是「自机 + 弹」两个椭圆求交，实测 ≈5 px）——见 check_stage 的 HIT_R
local HIT_R = 5
---16 个方向（文档明写 16，不是 8 也不是 24）
local NDIR = 16
local DIRSTEP = 360 / NDIR
---"已经会打到你"的预测窗口：这个窗口内会打中自机所在位置的弹，才算当下的威胁
local HIT_HORIZON = 60
---限位分析用的格子（自机合法活动范围）
local GX = { -160, -80, 0, 80, 160 }
local GY = { -192, -96, 0, 96, 192 }
---安全区判定：这一格在 LOOKAHEAD 帧内都不会被弹覆盖 = 可待
local LOOKAHEAD = 45

local CARDSET = nil
if os.getenv("THREAT_CARDS") then
    CARDSET = {}
    for w in os.getenv("THREAT_CARDS"):gmatch("%d+") do CARDSET[tonumber(w)] = true end
end
local PIN = nil
if os.getenv("THREAT_POS") then
    local x, y = os.getenv("THREAT_POS"):match("(-?%d+)%s*,%s*(-?%d+)")
    if x then PIN = { tonumber(x), tonumber(y) } end
end

----------------------------------------------------------------------
-- 分析状态
----------------------------------------------------------------------
local CUR                       -- 当前卡的分析累加器
local B = nil                   -- 本帧的弹表（由钩子传进来；它是 check_stage 的局部变量）
local RESULTS = {}

local function newacc(idx, name)
    return {
        idx = idx, name = name, frames = 0,
        hit_frames = 0,             -- 会被打到的帧数（奇数狙已剔除）
        wsum = 0, wmax = 0,         -- 权重（危险方向/16），**全部帧**的
        whit = 0,                   -- 权重，只累加「会被打到」的那些帧
        safemin = NDIR, safesum = 0,
        gapmin = 1e9, gapsum = 0,
        area_sum = 0, area_n = 0, area_min = 1e9, area_max = -1e9,
        cx_min = 1e9, cx_max = -1e9, cy_min = 1e9, cy_max = -1e9,
        grp_sum = 0, grp_max = 0, grp_frames = 0,
        spawned = 0, oddaim = 0,
    }
end

---出膛时登记：按 (帧, 出膛点) 聚类，认出**奇数狙**
local spawns = {}               -- [frame] = { {x,y,dirs={}}, ... }
local oddgroups = {}            -- 活着的奇数狙组：{ line = 角度, born = 帧, n = 发数 }
local cur_frame = 0

local function bullet_spawned(b, style, col, x, y, v, a, aim)
    if not CUR then return end
    CUR.spawned = CUR.spawned + 1
    local list = spawns[cur_frame]
    if not list then list = {}; spawns[cur_frame] = list end
    -- 同一帧、出膛点相近（24 px 内）的算一发「同时发弹」
    local cl
    for _, c in ipairs(list) do
        local dx, dy = c.x - x, c.y - y
        if dx * dx + dy * dy < 24 * 24 then cl = c break end
    end
    if not cl then
        cl = { x = x, y = y, n = 0, rot = {} }
        list[#list + 1] = cl
    end
    cl.n = cl.n + 1
    cl.rot[cl.n] = b.rot or 0
    cl.first = cl.first or b
end

---把本帧的发弹聚类过一遍，挑出奇数狙
local function detect_oddaim(f)
    local list = spawns[f]
    if not list then return end
    for _, c in ipairs(list) do
        if c.n >= 3 and c.n % 2 == 1 then
            --方向是否**均匀排布**
            local rs = {}
            for i = 1, c.n do rs[i] = c.rot[i] end
            table.sort(rs)
            local step = rs[2] - rs[1]
            local even = step > 1
            for i = 3, c.n do
                if math.abs((rs[i] - rs[i - 1]) - step) > 3 then even = false break end
            end
            if even then
                --中心方向是否朝着自机
                local mid = rs[1] + step * (c.n - 1) / 2
                local dir = _G.Angle(c.x, c.y, player.x, player.y)
                local d = math.abs(((mid - dir + 540) % 360) - 180)
                if d <= 6 then
                    --奇数狙：不计入命中帧数，但封死 9 个方向
                    CUR.oddaim = CUR.oddaim + c.n
                    oddgroups[#oddgroups + 1] = {
                        line = dir, born = f, n = c.n, x = c.x, y = c.y,
                    }
                end
            end
        end
    end
    spawns[f] = nil            -- 用完即弃，别攒
end

---一发弹在 px,py 这个点上会不会被打到（HIT_HORIZON 帧内）
local function will_hit(t, px, py)
    local vx, vy = t.vx or 0, t.vy or 0
    local rx, ry = t.x - px, t.y - py
    local a = vx * vx + vy * vy
    if a < 1e-9 then
        return (rx * rx + ry * ry) <= HIT_R * HIT_R
    end
    local b2 = 2 * (rx * vx + ry * vy)
    local c = rx * rx + ry * ry - HIT_R * HIT_R
    local disc = b2 * b2 - 4 * a * c
    if disc < 0 then return false end
    local sq = math.sqrt(disc)
    if (-b2 + sq) / (2 * a) < 0 then return false end
    local k1 = (-b2 - sq) / (2 * a)
    if k1 < 0 then k1 = 0 end
    return k1 <= HIT_HORIZON
end

---自机周围 16 个方向里，有几个是安全的。
---  一个方向安全 = 沿它量过去，到最近一颗弹**表面**的距隙 > GAP。
---  blocked：奇数狙封死的方向集合。
local function safe_dirs(px, py, blocked)
    local cos, sin = _G.cos, _G.sin
    local safe = 0
    local mingap = 1e9
    for k = 0, NDIR - 1 do
        local adeg = k * DIRSTEP
        local dx, dy = cos(adeg), sin(adeg)
        local best = 1e9
        local i = 1
        while true do
            local t = B[i]
            if not t then break end
            if t._live ~= false and t.group ~= 5 then      -- group 5 = 无判定装饰
                local rx, ry = t.x - px, t.y - py
                local proj = rx * dx + ry * dy
                if proj > 0 then
                    local perp2 = rx * rx + ry * ry - proj * proj
                    local rr = t.r or 4
                    if perp2 < rr * rr then
                        local d = proj - math.sqrt(rr * rr - perp2)
                        if d < best then best = d end
                    end
                end
            end
            i = i + 1
        end
        --空隙 = 量到的距离 − 弹半径（上面已经减过了，best 是到"弹表面"的距离）
        if best < mingap then mingap = best end
        local blk = blocked and blocked[k] or false
        if best > GAP and not blk then safe = safe + 1 end
    end
    return safe, mingap
end

---这一格在 LOOKAHEAD 帧内安不安全（限位分析用）
local function cell_safe(px, py)
    local i = 1
    while true do
        local t = B[i]
        if not t then break end
        if t._live ~= false and t.group ~= 5 then
            if will_hit(t, px, py) then return false end
        end
        i = i + 1
    end
    return true
end

----------------------------------------------------------------------
-- 钩子
----------------------------------------------------------------------
local HOOK = {
    quiet = true,
    cards = CARDSET,
    on_card = function(idx, entry)
        CUR = newacc(idx, entry.name)
        spawns, oddgroups = {}, {}
        cur_frame = 0
    end,
    ---默认的参考自机：**跟着安全区质心走**，限速 4 px/帧（不能瞬移）。
    ---  这是文档的模型 —— 限位把自机逼进安全区，威胁度是「对**安全区内**自机」
    ---  还有多少躲避要求（§一）。把自机钉死在某个固定点是不对的：
    ---  安全区会移动的卡，固定点大部分时间都在危险区，读数必然爆表。
    ---  （自机 4 px/帧 是引擎里的常规移动速度上限）
    set_player = function(idx, f, bl)
        B = bl
        if PIN then
            player.x, player.y = PIN[1], PIN[2]
            return true
        end
        --★ 关键：自机**跟着限位做大范围移动，但不做微操**。
        --  当前所在格还安全就**原地不动**（否则会变成「完美躲避」，
        --  按定义恒等于 0，量不出东西）；只有当前格不安全了才挪窝。
        --  这才是文档说的「安全区内的自机」：位置由限位决定，
        --  而威胁度量的是「站在这儿还有多少弹会打过来」。
        do
            local cx, cy = GX[1], GY[1]
            local bd = 1e9
            for iy = 1, #GY do
                for ix = 1, #GX do
                    local dx, dy = GX[ix] - player.x, GY[iy] - player.y
                    local d2 = dx * dx + dy * dy
                    if d2 < bd then bd = d2; cx, cy = GX[ix], GY[iy] end
                end
            end
            if cell_safe(cx, cy) and (player.x - cx) ^ 2 + (player.y - cy) ^ 2 < 26 * 26 then
                return true                 -- 这一格还安全 → 不挪
            end
        end
        --安全区：未来 LOOKAHEAD 帧都不会被覆盖的格子；取离自机最近的那格
        local best, bd, n, sx, sy = nil, 1e9, 0, 0, 0
        for iy = 1, #GY do
            for ix = 1, #GX do
                if cell_safe(GX[ix], GY[iy]) then
                    n = n + 1; sx = sx + GX[ix]; sy = sy + GY[iy]
                    local dx, dy = GX[ix] - player.x, GY[iy] - player.y
                    local d2 = dx * dx + dy * dy
                    if d2 < bd then bd = d2; best = { GX[ix], GY[iy] } end
                end
            end
        end
        local tx, ty
        if best then
            tx, ty = best[1], best[2]
        elseif n > 0 then
            tx, ty = sx / n, sy / n
        else
            tx, ty = player.x, player.y      -- 真的没处可去：原地（这就是死局）
        end
        local dx, dy = tx - player.x, ty - player.y
        local m = math.sqrt(dx * dx + dy * dy)
        local sp = 4
        if m > sp then dx, dy, m = dx / m * sp, dy / m * sp, sp end
        if m > 1 then
            player.x, player.y = player.x + dx, player.y + dy
        end
        return true
    end,
    on_frame = function(idx, f, bl)
        if not CUR then return end
        B = bl
        cur_frame = f
        detect_oddaim(f)

        --奇数狙封死的方向：连线上 2 个 + 某一侧 7 个，两侧取安全数更小的
        local blocked = {}
        for gi = #oddgroups, 1, -1 do
            local g = oddgroups[gi]
            if f - g.born > 240 then table.remove(oddgroups, gi) end
        end
        local px, py = player.x, player.y
        --基线的安全数（不含奇数狙封锁）
        local base
        do
            local bx = {}
            base = safe_dirs(px, py, bx)
        end
        for _, g in ipairs(oddgroups) do
            local line = _G.Angle(px, py, g.x, g.y)
            local k0 = math.floor((line + DIRSTEP / 2) / DIRSTEP) % NDIR
            --两种方案各封 9 个：连线上的 2 个 + 顺时针 7 个 / 逆时针 7 个
            for _, sgn in ipairs({ 1, -1 }) do
                local b2 = {}
                for j = 0, 8 do
                    local kk = (k0 + sgn * j) % NDIR
                    b2[kk] = true
                end
                local s2 = safe_dirs(px, py, b2)
                if s2 < base then
                    base = s2
                    blocked = b2
                end
            end
        end

        local w = (NDIR - base) / NDIR
        CUR.frames = CUR.frames + 1
        CUR.wsum = CUR.wsum + w
        if w > CUR.wmax then CUR.wmax = w end
        CUR.safesum = CUR.safesum + base
        if base < CUR.safemin then CUR.safemin = base end
        local _, mg = safe_dirs(px, py, blocked)
        if mg < 1e9 then
            CUR.gapsum = CUR.gapsum + mg
            if mg < CUR.gapmin then CUR.gapmin = mg end
        end

        --「会被打到」：奇数狙不算（它们不动的自机必中，微移就能躲）
        local hit = false
        local i = 1
        while true do
            local t = B[i]
            if not t then break end
            if t._live ~= false and t.group ~= 5 and not t._oddaim then
                local dx, dy = t.x - px, t.y - py
                if dx * dx + dy * dy <= HIT_R * HIT_R then hit = true break end
            end
            i = i + 1
        end
        if hit then
            CUR.hit_frames = CUR.hit_frames + 1
            CUR.whit = CUR.whit + w
        end

        --文档 §五：同一时刻作用于自机的**威胁组数**应当为 1 或 2。
        --  组 = 一簇发弹源（出膛点相距 60 px 以内算同一簇）；
        --  只要这一簇里有一发弹在 HIT_HORIZON 内会打到自机，这一簇就算一组。
        do
            local src, ng = {}, 0
            local i = 1
            while true do
                local t = B[i]
                if not t then break end
                if t._live ~= false and t.group ~= 5 and not t._oddaim
                        and will_hit(t, px, py) then
                    --⚠ 按「发射事件」聚类，不是按每一颗弹的位置：
                    --  一圈 26 发的环是在**同一帧**从 26 个位置发出来的，那是 1 组，
                    --  不是 26 组（按位置聚类会把环算成 26 组，数字完全失真）。
                    --  判据：出膛帧相差 ≤ 20 帧、且出膛点相距 ≤ 220 px → 同一组。
                    local sx, sy = t._sx or t.x, t._sy or t.y
                    local sf = t._sf or 0
                    local found = false
                    for k = 1, #src do
                        local dx, dy = src[k][1] - sx, src[k][2] - sy
                        if abs(sf - src[k][3]) <= 20 and dx * dx + dy * dy < 220 * 220 then
                            found = true break
                        end
                    end
                    if not found then
                        src[#src + 1] = { sx, sy, sf }
                        ng = ng + 1
                    end
                end
                i = i + 1
            end
            CUR.grp_sum = CUR.grp_sum + ng
            if ng > CUR.grp_max then CUR.grp_max = ng end
            if ng > 0 then CUR.grp_frames = CUR.grp_frames + 1 end
        end

        --限位：安全区（哪些格子还能待）的大小与质心
        local n, sx, sy = 0, 0, 0
        for iy = 1, #GY do
            for ix = 1, #GX do
                if cell_safe(GX[ix], GY[iy]) then
                    n = n + 1; sx = sx + GX[ix]; sy = sy + GY[iy]
                end
            end
        end
        CUR.area_sum = CUR.area_sum + n
        CUR.area_n = CUR.area_n + 1
        if n < CUR.area_min then CUR.area_min = n end
        if n > CUR.area_max then CUR.area_max = n end
        if n > 0 then
            local cx, cy = sx / n, sy / n
            if cx < CUR.cx_min then CUR.cx_min = cx end
            if cx > CUR.cx_max then CUR.cx_max = cx end
            if cy < CUR.cy_min then CUR.cy_min = cy end
            if cy > CUR.cy_max then CUR.cy_max = cy end
        end
    end,
    on_card_end = function(idx)
        if CUR then RESULTS[#RESULTS + 1] = CUR; CUR = nil end
    end,
}
---奇数狙标记：出膛回调里认出之后，把那一组弹标上（供 on_frame 剔除）
_G.STAGE_BULLET_CB = bullet_spawned
_G.STAGE_HOOK = HOOK

----------------------------------------------------------------------
-- 跑（复用 check_stage 的桩件与调度）
----------------------------------------------------------------------
dofile("tools/check_stage.lua")

----------------------------------------------------------------------
-- 报告
----------------------------------------------------------------------
local function verdict(v, lo, hi)
    if v < lo then return "偏低" elseif v > hi then return "偏高" end
    return "合格"
end

print("")
print("================================================================")
print("子弹威胁度报告（《什么是好的弹设.md》）")
print(("  关卡 %s   每张卡 %d 帧   自机判定半径 %g → 要求空隙 %g px"):format(PATH, FRAMES, PLAYER_R, GAP))
print(("  文档要求：总威胁度 0.5~1.5   同时作用威胁组数 1~2   展开要有限位+威胁"))
print("================================================================")
print(("%-3s %-26s %8s %8s %8s %10s %8s"):format("#", "卡名", "威胁度", "被弹帧", "权重均", "安全方向", "安全区"))
print(("-"):rep(80))
for _, r in ipairs(RESULTS) do
    local secs = math.max(r.frames, 1) / 60
    --威胁度（文档：被弹帧的数量 × 权重，权重取那些帧上的危险方向/16）
    --  = (每秒会被打到的帧数) × (那些帧平均有多被堵)
    --  化简 = whit/frames*60
    local threat = r.whit / math.max(r.frames, 1) * 60
    local sarea = r.area_n > 0 and r.area_sum / r.area_n or 0
    print(("%-3d %-26s %8.2f %8s %8.2f %10s %8.1f"):format(
            r.idx, r.name, threat,
            ("%d"):format(r.hit_frames),
            r.hit_frames > 0 and r.whit / r.hit_frames or 0,
            ("%.1f/%d"):format(r.safesum / math.max(r.frames, 1), NDIR),
            sarea))
    local mvx = r.cx_max - r.cx_min
    local mvy = r.cy_max - r.cy_min
    print(("      └ 威胁度 %s(0.5~1.5) | 最少安全方向 %d | 最小空隙 %.1f px | 奇数狙 %d 发 / 共出膛 %d 发")
            :format(verdict(threat, 0.5, 1.5), r.safemin, r.gapmin, r.oddaim, r.spawned))
    local mov = (mvx > 40 or mvy > 40)
    --收缩的判据看**面积的变化幅度**：有的限位（比如两排刀刃向内收）
    --质心基本不动，缩的是安全区本身。
    local shrin = (r.area_max - r.area_min) >= 4
    print(("      └ 限位：安全区 %d/25 格（最少 %d）  质心移动范围 x %.0f px / y %.0f px  → %s")
            :format(math.floor(r.area_sum / math.max(r.area_n, 1)), r.area_min, mvx, mvy,
                    mov and "**有周期**（安全区在移动）"
                    or (shrin and "**会收缩**（安全区的面积在变）" or "**没有限位**（安全区不动也不缩）")))
    local g = r.grp_sum / math.max(r.frames, 1)
    print(("      └ 威胁组数 均 %.2f  最多 %d  → %s(文档要求 1~2)   |  有威胁的帧占 %.0f%%")
            :format(g, r.grp_max,
                    (g >= 0.8 and g <= 2.2) and "合格" or (g < 0.8 and "偏少" or "偏多"),
                    r.grp_frames / math.max(r.frames, 1) * 100))
    print(("      └ 展开：%s")
            :format((mov or shrin) and "有限位" or "★ 缺限位" ..
                    " + " .. (r.hit_frames > 0 and "有威胁" or "★ 缺威胁")))
end
print("")
print("说明：威胁度 = Σ_帧[会被打到] × 危险方向/16，已剔除非奇数狙的自机狙必中项；")
print("      安全区 = 25 个格子里「未来 45 帧都不会被弹覆盖」的格子。")
