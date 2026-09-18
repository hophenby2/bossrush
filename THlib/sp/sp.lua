sp = {}

--SP+系 geometry 函数库
Include 'THlib\\sp\\spGeom.lua'

--SP+系 math 函数库
Include 'THlib\\sp\\spMath.lua'

--SP+系 string 函数库
Include 'THlib\\sp\\spString.lua'



----------------------------------------
---table

local table, string, ipairs, pairs, type, setmetatable, getmetatable = table, string, ipairs, pairs, type, setmetatable, getmetatable
local IsValid = IsValid
local unpack = unpack
local int, abs, Forbid = int, abs, Forbid

---对一个对象表进行更新，去除无效的luastg object对象
---@param lst table
---@return number @表长度
function sp:UnitListUpdate(lst)
    local n = #lst
    local j = 0
    local z
    for i = 1, n do
        z = lst[i]
        if IsValid(z) then
            j = j + 1
            lst[j] = z
            if i ~= j then
                lst[i] = nil
            end
        else
            lst[i] = nil
        end
    end
    return j
end

---添加一个luastg object对象或者luastg object对象表到已有的对象表上
---@param lst table
---@param obj object|table
---@return number @表长度
function sp:UnitListAppend(lst, obj)
    if IsValid(obj) then
        local n = #lst
        lst[n + 1] = obj
        return n + 1
    elseif IsValid(obj[1]) then
        return self:UnitListAppendList(lst, obj)
    else
        return #lst
    end
end

---连接两个对象表
---@param lst table
---@param objlist table
---@return number @两个对象表的对象总和
function sp:UnitListAppendList(lst, objlist)
    local n = #lst
    local n2 = #objlist
    for i = 1, n2 do
        lst[n + i] = objlist[i]
    end
    return n + n2
end

---返回指定对象在对象表中的位置
---@param lst table
---@param obj any
---@return number
function sp:UnitListFindUnit(lst, obj)
    local n = #lst
    for i = 1, n do
        local z = lst[i]
        if z == obj then
            return i
        end
    end
    return 0
end

---添加一个luastg object对象或者luastg object对象表到已有的对象表上
---如果已有则返回目标当前的所在位置
---@param lst table
---@param obj object|table
---@return number @表长度
function sp:UnitListInsertEx(lst, obj)
    local l = self:UnitListFindUnit(lst, obj)
    if l == 0 then
        return self:UnitListUpdate(lst, obj)
    else
        return l
    end
end

---拆解表至同一层级
function sp:GetUnpackList(...)
    local ref, p = {}, { ... }
    for _, v in ipairs(p) do
        if type(v) ~= 'table' then
            table.insert(ref, v)
        else
            local tmp = self:GetUnpackList(unpack(v))
            for _, t in ipairs(tmp) do
                table.insert(ref, t)
            end
        end
    end
    return ref
end

---复制表
---@param t table @要复制的表
function sp:CopyTable(t)
    local ref = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            ref[k] = self:CopyTable(v)
        else
            ref[k] = v
        end
    end
    return setmetatable(ref, getmetatable(t))
end

---按位置截取信息表
---@param list table @目标表
---@param n number @截取最大长度
---@param pos number @选择位标
---@param s number @锁定位标
---@return table, number
function sp:GetListSection(list, n, pos, s)
    n = int(n or #list)
    s = Forbid(int(s or n), 1, n)
    local cut, c, m = {}, #list, pos
    if c <= n then
        cut = list
    elseif pos < s then
        for i = 1, n do
            table.insert(cut, list[i])
        end
    else
        local t = Forbid(pos + (n - s), pos, c)
        for i = t - n + 1, t do
            table.insert(cut, list[i])
        end
        m = Forbid(n - (t - pos), s, n)
    end
    return cut, m
end

---分割字符串
---@param str string@要分割的字符串
---@param delimiter string @分割符
---@return table @分割好的字符串表
function sp:SplitText(str, delimiter)
    if delimiter == "" then
        return false
    end
    local pos, arr = 0, {}
    for st, sp in function()
        return str:find(delimiter, pos, true)
    end do
        table.insert(arr, str:sub(pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, str:sub(pos))
    return arr
end

----------------------------------------
---other

---取模方式整理值
---@param scope number@作用域偏移，默认为0
function sp:TweakValue(value, range, scope)
    scope = scope or 0
    return (value - scope) % range + scope
end

---返回userdata的方法名
function sp:GetMetatableFuncName(t)
    local rs_tb = {}
    local function tmp(T)
        if T then
            for _val, _val_type in pairs(T) do
                if type(_val_type) ~= "userdata" then
                    if not string.find(_val, "_") then
                        table.insert(rs_tb, _val)
                    end
                end
            end
            local ft = getmetatable(T)
            if ft then
                tmp(ft)
            end
        end
    end
    tmp(getmetatable(t))
    table.sort(rs_tb)
    local rs_str = ""
    for i = 1, #rs_tb do
        rs_str = rs_str .. rs_tb[i] .. "\n"
    end
    return rs_str
end

---把一个table转化为string(json)，可参考Serialize操作
---@param t table
---@param enter boolean@自动缩进
---@param level number@初缩进级
function sp:TableToString(t, enter, level)
    level = level or 1
    local num = 0
    local num2 = 0
    local hash
    local function indention()
        return enter and string.rep("    ", level) or ""
    end
    local function judge(str, v, condition, finalnum)
        num2 = num2 + 1
        if type(v) == "table" then
            str = str .. self:TableToString(v, enter, level + 1)
        elseif type(v) == "function" then
            error("Invalid: Can\'t turn function into string")
        else
            str = str .. condition(v)
        end
        if num2 ~= finalnum then
            str = str .. ","
        end
        return str .. (enter and "\n" or "")
    end
    for k, _ in pairs(t) do
        if type(tonumber(k)) ~= "number" then
            hash = true
        end
        num = num + 1
    end
    local str = (hash and "{" or "[") .. (enter and "\n" or "")
    if hash then
        for k, v in pairs(t) do
            str = str .. indention() .. "\"" .. k .. "\"" .. ": "
            str = judge(str, v, function(value)
                return value
            end, num)
        end
    else
        for k = 1, #t do
            str = str .. indention()
            str = judge(str, t[k], function(value)
                return (tostring(value) == "nil") and "null" or tostring(value)
            end, #t)
        end
    end
    str = str .. indention() .. (hash and "}" or "]")
    return str
end

---获取哈希表的键数
function sp:GetHashLength(hash)
    local num = 0
    for _ in pairs(hash) do
        num = num + 1
    end
    return num
end
local max = max
local combinNum = combinNum
local task = task
---获取贝塞尔曲线点集
function sp:GetPointBezier(t, mode, arg)
    local Result = {}
    t = max(int(t), 1)
    local count = (#arg) / 2
    local x = { arg[1] }
    local y = { arg[2] }
    for i = 1, count do
        x[i + 1] = arg[i * 2 - 1]
        y[i + 1] = arg[i * 2]
    end
    local com_num = {}
    for i = 0, count do
        com_num[i + 1] = combinNum(i, count)
    end
    local _x, _y, da
    for s = 1, t do
        s = task.SetMode[mode](s / t)
        _x, _y = 0, 0
        for j = 0, count do
            da = com_num[j + 1] * (1 - s) ^ (count - j) * s ^ j
            _x = _x + x[j + 1] * da
            _y = _y + y[j + 1] * da
        end
        table.insert(Result, { _x, _y })
    end
    return Result
end

---获取直线点集
function sp:GetPointLine(t, x1, y1, x2, y2)
    local Result = {}
    t = max(int(t), 1)
    for s = 1, t do
        table.insert(Result, { x1 + (s / t) * (x2 - x1), y1 + (s / t) * (y2 - y1) })
    end
    return Result
end

---测试一个函数的性能（雾
function sp:TestCode(func, ...)
    local st = os.clock()
    for _ = 1, 500000 do
        func(... or _)
    end
    local et = os.clock()
    Print(et - st)
end

---@param H@色调：0~360
---@param S@饱和度：0~1
---@param V@明度：0~1
function sp:HSVtoRGB(H, S, V)
    H = H%360
    S = Forbid(S, 0, 1)
    V = Forbid(V, 0, 1)
    if S == 0 then
        V = V * 255
        return V, V, V
    end
    local F, P, Q, T
    local R, G, B
    H = H / 60
    local i = int(H)
    F = H - i
    P = V * (1 - S)
    Q = V * (1 - S * F)
    T = V * (1 - S * (1 - F))
    if i == 0 then
        R, G, B = V, T, P
    elseif i == 1 then
        R, G, B = Q, V, P
    elseif i == 2 then
        R, G, B = P, V, T
    elseif i == 3 then
        R, G, B = P, Q, V
    elseif i == 4 then
        R, G, B = T, P, V
    elseif i == 5 then
        R, G, B = V, P, Q
    end
    R, G, B = R * 255, G * 255, B * 255
    return R, G, B
end

---@param H@色调：0~360
---@param S@饱和度：0~1
---@param L@亮度：0~1
function sp:HSLtoRGB(H, S, L)
    H = H % 360
    S = Forbid(S, 0, 1)
    L = Forbid(L, 0, 1)
    if S == 0 then
        L = L * 255
        return L, L, L
    end

    local C = (1 - abs(2 * L - 1)) * S
    local X = C * (1 - abs((H / 60) % 2 - 1))
    local M = L - C / 2
    local R, G, B

    local sector = int(H / 60)
    if sector == 0 then
        R, G, B = C, X, 0
    elseif sector == 1 then
        R, G, B = X, C, 0
    elseif sector == 2 then
        R, G, B = 0, C, X
    elseif sector == 3 then
        R, G, B = 0, X, C
    elseif sector == 4 then
        R, G, B = X, 0, C
    else
        R, G, B = C, 0, X
    end

    return (R + M) * 255, (G + M) * 255, (B + M) * 255
end

local password = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 }
function sp:LockString(str)
    local result = ""
    for i = 1, #str do
        result = result .. string.char(sp:TweakValue(str:sub(i, i):byte() + password[i % #password + 1], 127, 1))
    end
    return result
end

function sp:UnLockString(str)
    local result = ""
    for i = 1, #str do
        result = result .. string.char(sp:TweakValue(str:sub(i, i):byte() - password[i % #password + 1], 127, 1))
    end
    return result
end
