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
                      sx = 0, sy = 0, hs = b.hscale or 1, vs = b.vscale or 1 }
                g[key] = r
            end
            local x, y = b.x or 0, b.y or 0
            r.c = r.c + 1
            if x < r.x0 then r.x0 = x end
            if x > r.x1 then r.x1 = x end
            if y < r.y0 then r.y0 = y end
            if y > r.y1 then r.y1 = y end
            r.sx = r.sx + x; r.sy = r.sy + y
        end
    end

    local keys = {}
    for k in pairs(g) do keys[#keys + 1] = k end
    table.sort(keys)

    --★ 把该帧自机位置也打出来：这张卡有跟自机的发射点（fx=-99999），
    --  自机位置不同而图案完全不变，就说明「跟自机」根本没实现 —— 必须能看见这一点，
    --  否则钉自机到底有没有生效都无从判断。
    print(("=== 第 %d 帧   存活子弹 %d   贴图数 %d   自机(%.0f,%.0f) ===")
            :format(f, n, #keys, _G.player.x or 0, _G.player.y or 0))
    print(("  %-16s %5s  %-25s %-25s %s"):format("贴图", "数量", "包围盒 x[..]", "包围盒 y[..]", "质心 / 缩放"))
    for _, k in ipairs(keys) do
        local r = g[k]
        print(("  %-16s %5d  [%8.1f,%8.1f]  [%8.1f,%8.1f]  (%7.1f,%7.1f)  %.3f,%.3f")
                :format(k, r.c, r.x0, r.x1, r.y0, r.y1, r.sx / r.c, r.sy / r.c, r.hs, r.vs))
    end
end

_G.STAGE_HOOK = hook
dofile("tools/check_stage.lua")
