---@class sp.geom
local lib = {}
sp.geom = lib

local type = type
---构造点
---[1]和[2]可以取到坐标,x和y也可以取到坐标
---@class Point
---@return Point
function lib.NewPoint(x, y)
    if type(x) == "table" then
        if type(x[1]) == "number" and type(x[2]) == "number" then
            return x
        elseif x.x and x.y then
            return { x.x, x.y }
        end
    elseif x and y then
        return { x, y }
    end
end

---@class PointSet
local NewPointSet = { InsertPoint = function(self, point)
    table.insert(self, point)
end }
setmetatable(NewPointSet, { __call = function(t)
    return setmetatable({}, { __index = t })
end })
---构造点集
lib.NewPointSet = NewPointSet

---构造向量
---@param p1 Point
---@class Vector
---@return Vector
function lib.NewVector(p1, p2)
    return { p2[1] - p1[1], p2[2] - p1[2] }
end

---构造直线ax+by+c=0
---需要2个点或直接abc
---@overload fun(p1:Point,p2:Point):Line
---@class Line
---@return Line
function lib.NewLine(a, b, c)
    if c then
        return { a, b, c }
    else
        return { b[2] - a[2], a[1] - b[1], b[1] * a[2] - a[1] * b[2] }
    end

end

---构造矩形ABCD
---@class Rectangle
---@return Rectangle
function lib.NewRectangle(p1, p2, p3, p4)
    local line = lib.NewLine
    local vector = lib.NewVector
    return {
        side = { line(p1, p2), line(p2, p3), line(p3, p4), line(p4, p1) },
        vector = { vector(p1, p2), vector(p2, p3) },
        point = { p1, p2, p3, p4 }
    }
end

---点Point是否在矩形ABCD里
---@param rect Rectangle
---@param point Point
function lib.PointInRectangle(point, rect)
    local p = rect.point[1]
    local V = rect.vector
    local v1, v2, v3, v4 = V[1][1], V[1][2], V[2][1], V[2][2]
    local V1, V2 = point[1] - p[1], point[2] - p[2]
    local para1 = v1 * V1 + v2 * V2
    local para2 = v3 * V1 + v4 * V2
    return para1 > 0 and para1 < v1 * v1 + v2 * v2 and para2 > 0 and para2 < v3 * v3 + v4 * v4
end
local math, cos, sin = math, cos, sin
---同一直线上的点和线段，点是否在线段上
function lib.PointInSegOnSameLine(point, spoint1, spoint2)
    local dx, dy = spoint2[1] - spoint1[1], spoint2[2] - spoint1[2]
    local rot = math.deg(math.atan2(dy, dx))
    local len = math.sqrt(dx * dx + dy * dy)
    local x, y = point[1] - spoint1[1], point[2] - spoint1[2]
    x = x * cos(rot) + y * sin(rot)
    if x >= 0 and x <= len then
        return true
    end
end

local unpack = unpack
local lstg = lstg
---直线ax+by+c=0与屏幕的交点集
---@param line Line
function lib.LinePointWorld(line)
    local La, Lb, Lc = unpack(line)
    local pos = NewPointSet()
    local w = lstg.world
    if Lb ~= 0 then
        pos:InsertPoint(lib.NewPoint(w.l, -(Lc + La * w.l) / Lb))
        pos:InsertPoint(lib.NewPoint(w.r, -(Lc + La * w.r) / Lb))
    end
    if La ~= 0 then
        pos:InsertPoint(lib.NewPoint(-(Lc + Lb * w.b) / La, w.b))
        pos:InsertPoint(lib.NewPoint(-(Lc + La * w.t) / La, w.t))
    end
    return pos

end

local sp = sp
---直线ax+by+c=0与直线ax+by+c=0的交点
---@param line1 Line
---@param line2 Line
---@return Point
function lib.LinePointLine(line1, line2)
    local x, y = sp.math.TwoUnknown({ line1[1], line1[2], -line1[3] }, { line2[1], line2[2], -line2[3] })
    if sp.math.IsRealNumber(x) then
        return lib.NewPoint(x, y)
    else
        return false
    end
end
local ipairs = ipairs
local cache = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 1 } }
---矩形[p1,p2,p3,p4]与直线ax+by+c=0的交点集
---@param rectangle Rectangle
---@param line Line
function lib.RectanglePointLine(rectangle, line)
    local pos
    local point = NewPointSet()
    for t, l in ipairs(rectangle.side) do
        pos = lib.LinePointLine(l, line)
        if pos and lib.PointInSegOnSameLine(pos, rectangle.point[cache[t][1]], rectangle.point[cache[t][2]]) then
            point:InsertPoint(pos)
        end
    end
    return point
end

---点与点的距离
---@param point1 Point
function lib.PointDistPoint(point1, point2)
    local x, y = point1[1] - point2[1], point1[2] - point2[2]
    return sqrt(x * x + y * y)
end

---获取一个直线的垂线
---@param line Line
---@param point Point
function lib.GetPerpendicular(line, point)
    return lib.NewLine(line[2], -line[1], -line[2] * point[1] + line[1] * point[2])
end

---三点画圆
---@param point1 Point
---@param point2 Point
---@param point3 Point
function lib.ThreePointToCircle(point1, point2, point3)
    local line1 = lib.NewLine(point1, point2)
    local line2 = lib.NewLine(point2, point3)
    local middlep1 = lib.NewPoint((point1[1] + point2[1]) / 2, (point1[2] + point2[2]) / 2)
    local middlep2 = lib.NewPoint((point2[1] + point3[1]) / 2, (point2[2] + point3[2]) / 2)
    local point = lib.LinePointLine(lib.GetPerpendicular(line1, middlep1), lib.GetPerpendicular(line2, middlep2))
    return point, lib.PointDistPoint(point, point1)
end