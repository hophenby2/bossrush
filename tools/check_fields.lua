---=====================================
---静态字段审计：把「frame/render 里读了、但 init 顶层从没赋值」的字段全揪出来
---
---为什么需要它：`attempt to compare nil with number` / `attempt to perform
---arithmetic on a nil value` 这一整类崩溃，`check_stage.lua` 是**测不出来**的 ——
---它的桩件太宽容（引擎给的字段、任务执行顺序、渲染时机都和真机不完全一样），
---而且只有**真的走到那一行**才会炸。真机上就是第一帧当场崩。
---
---规则：`init` 的**顶层**（不在任何 `function`/`if`/`for` 里面）必须把一个字段
---赋值过，之后 `frame`/`render` 才允许读它。写在 `task.New(function() ... end)`
---里的赋值**不算** —— 那个协程要下一帧才跑，而 `frame` 这一帧就跑了。
---
---   luajit tools/check_fields.lua mod/GAME/th20.lua [更多文件...]
---
---它**认**这几种安全写法，不会误报：
---   · `self.X or 默认值` / `if self.X then` / `self.X and`   —— 显式守卫
---   · 同一个函数体里先赋值后使用（例如 frame 开头先算的）
---   · `frame` 里算出来、`render` 里直接用（frame 一定先于 render）
---   · 基类 init 设的字段（`Class(laser, {...})` 里的 `self.alpha` 等 ——
---     基类字段表是从 THlib 源码现场读出来的，不靠手抄）
---
---它**认不出**的写法（报了也请先人工看一眼，多半是安全的）：
---   · 先 `local p = self.X` 再判 `if not p` —— 局部变量这层它看不穿
---   （想让它认，就把守卫**直接写在 self.X 上**：
---     `if not self.X then return end  local p = self.X`）
---=====================================

local files = {}
for i = 1, #arg do files[#files + 1] = arg[i] end
if #files == 0 then
    print("用法: luajit tools/check_fields.lua <文件...>")
    os.exit(1)
end

---去掉行注释（够用：本项目的字符串里没有 `--`）
local function strip(l) return (l:gsub("%-%-.*$", "")) end
local function cnt(l, w) local _, c = l:gsub("%f[%a]" .. w .. "%f[%A]", ""); return c end
---深度：+1 = function/if/repeat/do ； -1 = end/until ； for/while 本身不计（它们的 do 计）
local function ddepth(l)
    return cnt(l, "function") + cnt(l, "if") + cnt(l, "repeat") + cnt(l, "do")
            - cnt(l, "end") - cnt(l, "until")
end

---一行里所有「被赋值的 self.X」（含 `self.a, self.b = ...` 这种多重赋值）
local function assigned(l)
    local s = {}
    local t = l:gsub("==", "@"):gsub("~=", "@"):gsub("<=", "@"):gsub(">=", "@")
    local eq = t:find("=")
    if not eq then return s end
    local lhs = t:sub(1, eq - 1)
    if lhs:find("[;%(%)]") then return s end   -- 不是一条纯赋值语句
    for f in lhs:gmatch("self%.([%w_]+)") do s[f] = true end
    return s
end

---★ 基类 init 会设的字段。`Class(laser, {init = function(self,...) laser.init(self,...) end})`
---  这种写法里 `self.alpha` / `self.w` 是**基类 init 设的**，子类自己的 init 当然没有。
---  静态审计不知道这件事，就会把 th01 的 `th01_ray` 报成崩溃 —— 而真机根本不崩。
---  所以从 THlib 源码里**直接把每个基类 init 赋的字段读出来**，不靠手抄。
local BASE_FIELDS = {}
do
    local h = io.popen("find THlib -name '*.lua' 2>/dev/null")
    if h then
        for file in h:lines() do
            local fh = io.open(file)
            if fh then
                local src = fh:read("*a")
                fh:close()
                for nm, body in src:gmatch("function%s+([%w_]+)[%.:]init%s*%b()(.-)\nend") do
                    BASE_FIELDS[nm] = BASE_FIELDS[nm] or {}
                    for fld in body:gmatch("self%.([%w_]+)%s*=[^=]") do
                        BASE_FIELDS[nm][fld] = true
                    end
                end
            end
        end
        h:close()
    end
end

---引擎/基类自己就会给的字段，不算漏
local ENGINE_FIELDS = {
    x = true, y = true, rot = true, vx = true, vy = true, omiga = true,
    timer = true, ani = true, group = true, layer = true, bound = true,
    colli = true, hide = true, img = true, navi = true, hscale = true,
    vscale = true, a = true, r = true, g = true, b = true, class = true,
}

local total = 0
for _, path in ipairs(files) do
    local f = io.open(path)
    if not f then
        print("打不开 " .. path)
    else
        local lines = {}
        for l in (f:read("*a") .. "\n"):gmatch("([^\n]*)\n") do lines[#lines + 1] = l end
        f:close()

        --分段：每个 `class["名字"] = Class(...)` 或每张卡（boss.card.New 起）
        local segs, cur = {}, nil
        for i, raw in ipairs(lines) do
            local l = strip(raw)
            --⚠ 前面允许缩进：th01/th02 把类定义**缩进在 `do ... end` 里**，
            --  要求顶格会整段漏掉（th01 的 `self.alpha` 就是这么漏到真机上的）。
            local cls, base = l:match('^%s*class%["([%w_]+)"%]%s*=%s*Class%s*%(%s*([%w_]+)')
            if cls then
                if cur then segs[#segs + 1] = cur end
                cur = { name = cls, base = base, head = i, body = {} }
            elseif l:match("boss%.card%.New") then
                if cur then segs[#segs + 1] = cur end
                local nm = raw:match('boss%.card%.New%("([^"]*)"')
                cur = { name = (nm ~= "" and nm) or "（非符）", head = i, body = {} }
            end
            if cur then cur.body[#cur.body + 1] = raw end
        end
        if cur then segs[#segs + 1] = cur end

        for _, s in ipairs(segs) do
            local F, depth, kind, topd = {}, 0, nil, nil
            for _, raw in ipairs(s.body) do
                local l = strip(raw)
                local hdr = l:match("^%s*([%w_]+)%s*=%s*function%s*%(")
                        or l:match("^%s*function%s+card[%.:]([%w_]+)")
                if hdr and depth == 0 then
                    kind = hdr
                    F[kind] = F[kind] or { set = {}, read = {}, guard = {}, selfset = {} }
                    depth = depth + ddepth(l)
                    topd = depth
                else
                    if kind then
                        for fld in l:gmatch("self%.([%w_]+)") do F[kind].read[fld] = true end
                        --守卫：`self.X or 默认值` / `not self.X` / `self.X and`
                        --  —— 这样的读法即使 nil 也不会崩，不算问题
                        for fld in l:gmatch("self%.([%w_]+)%s+or") do F[kind].guard[fld] = true end
                        for fld in l:gmatch("not%s+self%.([%w_]+)") do F[kind].guard[fld] = true end
                        for fld in l:gmatch("if%s+self%.([%w_]+)%s+then") do F[kind].guard[fld] = true end
                        for fld in l:gmatch("self%.([%w_]+)%s+and") do F[kind].guard[fld] = true end
                        --**同一函数体内**赋值过就算安全（例如 frame 开头先算再用的）
                        for fld in pairs(assigned(l)) do F[kind].selfset[fld] = true end
                        if depth == topd then
                            for fld in pairs(assigned(l)) do F[kind].set[fld] = true end
                        end
                    end
                    depth = depth + ddepth(l)
                    if depth <= 0 then depth = 0; kind = nil end
                end
            end
            local bad = {}
            for k in pairs(F) do
                if k ~= "init" and k ~= "before" then
                    for fld in pairs(F[k].read) do
                        local bf = s.base and BASE_FIELDS[s.base]
                        --`frame` 一定先于 `render` 跑：在 frame 里算出来的量，
                        --render 直接用是安全的（工具跨函数看不到这一点，会假报）
                        local from_frame = (k == "render") and F.frame and F.frame.set[fld]
                        if not ENGINE_FIELDS[fld] and not (F.init and F.init.set[fld])
                                and not (bf and bf[fld]) and not from_frame
                                and not F[k].guard[fld] and not F[k].selfset[fld] then
                            bad[#bad + 1] = ("%s 读了 self.%s"):format(k, fld)
                        end
                    end
                end
            end
            if #bad > 0 then
                table.sort(bad)
                print(("★ %s:%d  %s"):format(path, s.head, s.name))
                for _, t in ipairs(bad) do
                    print("      " .. t .. "（init 顶层没赋值 —— 真机上第一帧就是 nil 比较/运算）")
                    total = total + 1
                end
            end
        end
    end
end

if total == 0 then
    print("通过：frame/render 里没有「init 顶层未赋值」的字段")
else
    print(("\n共 %d 处，全部要改成 init 顶层赋值、或在读取处 `or 默认值`"):format(total))
    os.exit(1)
end
