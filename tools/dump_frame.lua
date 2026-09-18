---把某一帧场上所有子弹**按贴图分组**汇总倒出来（数量 / 包围盒 / 质心 / 缩放）。
---
---为什么用它：肉眼看渲染图判断「像不像原版」既慢又不准，而且我之前的参考渲染
---本身就坏过（哨兵没解，全部子弹堆在 x=-100000）。按贴图分组一比对，
---「这棵树不在那个位置」「这组弹少了 3/4」「这个缩放差一个量级」都是数字，一眼能看见。
---
---  STAGE_FRAME=300 luajit tools/dump_frame.lua mod/GAME/th21.lua
---  STAGE_FRAME=300 STAGE_CARDS=1 luajit tools/dump_frame.lua mod/GAME/th21.lua
---
---输出的坐标是 **LuaSTG 世界坐标**（+y 向上，场地中心为原点，384×448）。
---和原版数据（Crazy Storm，+y 向下，中心 315,240）比对时要换算：
---    lua_x = cs_x - 315      lua_y = 240 - cs_y
---这个换算在 `mod/GAME/th21.lua` 的 CX/CY 里，也是 NOTES.md §15 那一节的结论。
local FRAME = tonumber(os.getenv("STAGE_FRAME")) or 300
local ONLY = os.getenv("STAGE_CARDS")
--★ 把自机钉死在一点。**比对原版时必须用**：这张卡有跟自机的发射点（fx=-99999），
--  自机位置一不同，光柱的 x、质心全都不一样，测出来的差异分不清是 bug 还是自机在走。
--  取「LuaSTG 世界坐标」，原版那边对应 cs_x = x + 315、cs_y = 240 - y。
local POS = os.getenv("STAGE_POS")

local hook = { quiet = true }
if POS then
    local px, py = POS:match("^(-?[%d.]+),(-?[%d.]+)$")
    px, py = tonumber(px), tonumber(py)
    hook.set_player = function(idx, f, bl, objs)
        _G.player.x, _G.player.y = px, py
        return true     -- 接管自机，跳过躲避机器人
    end
end
if ONLY then
    hook.cards = {}
    for n in tostring(ONLY):gmatch("%d+") do hook.cards[tonumber(n)] = true end
end

hook.on_card = function(idx)
    if not hook.cards or hook.cards[idx] then
        print(("--- 卡 %d ---"):format(idx))
    end
end

hook.on_frame = function(idx, f, bl)
    if f ~= FRAME then return end
    if hook.cards and not hook.cards[idx] then return end

    local g, n = {}, 0
    for i = 1, #bl do
        local b = bl[i]
        if b._live ~= false then
            n = n + 1
            --  子弹对象上贴图存在 `b.style`（bulletStyle 对象），名字要从 `_G.__styleNames` 反查。
            --  直接读 `b.img` 会全部塌成一个 "?"，"贴图数 1" 是假象。
            local names = rawget(_G, "__styleNames") or {}
            local key = names[b.style] or tostring(b.style or "?")
            local r = g[key]
            if not r then
                r = { c = 0, x0 = math.huge, x1 = -math.huge, y0 = math.huge, y1 = -math.huge,
                      sx = 0, sy = 0, hs = b.hscale or 1, vs = b.vscale or 1,
                      --★ 透明度也要看：`alpha` 低到看不见时，子弹**在数据上存在**，
                      --  画面上却是空的。「只有树干没有花」多半就是这一项。
                      a0 = math.huge, a1 = -math.huge, nvis = 0 }
                g[key] = r
            end
            local x, y = b.x or 0, b.y or 0
            r.c = r.c + 1
            if x < r.x0 then r.x0 = x end
            if x > r.x1 then r.x1 = x end
            if y < r.y0 then r.y0 = y end
            if y > r.y1 then r.y1 = y end
            r.sx = r.sx + x; r.sy = r.sy + y
            --  `_a` 是 `spawn()` 写的 0~255 透明度；引擎另有 `alpha`，两个都看
            local av = b._a or b.alpha or 255
            if av < r.a0 then r.a0 = av end
            if av > r.a1 then r.a1 = av end
            if av > 95 * 2.55 then r.nvis = r.nvis + 1 end
        end
    end

    local keys = {}
    for k in pairs(g) do keys[#keys + 1] = k end
    table.sort(keys)

    --★ `STAGE_DUMP=<路径>` 时不打表，改成把每颗弹的原样数据（贴图名 / 坐标 / 旋转 /
    --  缩放 / 不透明度）写成一行行文本，交给同一个渲染脚本画出来。
    --  这是唯一能回答「画面上到底长什么样」的办法 —— 分组统计看不出图案的形状。
    local out = os.getenv("STAGE_DUMP")
    if out then
        --★ 句柄**不能叫 `f`**：`f` 是上面那个帧号，`("# frame=%d"):format(f)` 会拿
        --  userdata 去格式化数字而报错。而报错会被 `check_stage.lua` 的 pcall 吞掉，
        --  表现是「文件被创建了但是 0 字节」，看起来就像「这一帧没有子弹」。
        local fh = assert(io.open(out, "w"))
        fh:write(("# frame=%d player=%.1f,%.1f\n"):format(f, _G.player.x or 0, _G.player.y or 0))
        for i = 1, #bl do
            local b = bl[i]
            if b._live ~= false then
                --  贴图名要读样式对象的 `_imgname`（`styleOf` 里设的）。
                --  只读 `b.style` 拿到的是表地址，没法映射回图集矩形。
                local st = b.style
                local nm = (type(st) == "table" and st._imgname) or "?"
                fh:write(("%s %.2f %.2f %.1f %.4f %.4f %.1f\n"):format(
                        nm, b.x or 0, b.y or 0, b.rot or 0,
                        b.hscale or 1, b.vscale or 1, (b._a or 255) / 2.55))
            end
        end
        fh:close()
        print(("=== 第 %d 帧   存活子弹 %d   贴图数 %d   自机(%.0f,%.0f)   → %s")
                :format(f, n, #keys, _G.player.x or 0, _G.player.y or 0, out))
        return
    end

    print(("=== 第 %d 帧   存活子弹 %d   贴图数 %d   自机(%.0f,%.0f) ===")
            :format(f, n, #keys, _G.player.x or 0, _G.player.y or 0))
    print(("  %-16s %5s  %-25s %-25s %s"):format("贴图", "数量", "包围盒 x[..]", "包围盒 y[..]", "质心 / 缩放 / 不透明度[最低,最高] 可见"))
    for _, k in ipairs(keys) do
        local r = g[k]
        print(("  %-16s %5d  [%8.1f,%8.1f]  [%8.1f,%8.1f]  (%7.1f,%7.1f)  %.3f,%.3f  [%5.0f,%5.0f] %d")
                :format(k, r.c, r.x0, r.x1, r.y0, r.y1, r.sx / r.c, r.sy / r.c, r.hs, r.vs,
                        r.a0, r.a1, r.nvis))
    end
end

_G.STAGE_HOOK = hook
--★ 必须把帧数推给 `check_stage.lua`（它读 `arg[2]`，默认只有 1800 帧）。
--  不推的话 `STAGE_FRAME=2100` 会**一声不吭地什么都不打**，
--  看起来就像「第 2100 帧弹幕全没了」—— 那是工具没跑到，不是关卡的问题。
if not arg[1] then arg[1] = "mod/GAME/th21.lua" end
if not arg[2] or tonumber(arg[2]) < FRAME then arg[2] = tostring(FRAME + 60) end
dofile("tools/check_stage.lua")
