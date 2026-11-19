-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- Curve.cs SHA256 20e5c00944a633ad7e8c4f556126c46a59579a38edf48ced7263fd9faa99d5ed
Curve={__get={},__set={}}
Curve.__index=function(o,k) local getter=Curve.__get[k];if getter then return getter(o) end;return Curve[k] end
Curve.__newindex=function(o,k,v) local setter=Curve.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function Curve.__get.CurrentCount(self) return self.__prop_CurrentCount end
function Curve.__get.CurrentCount(self) return self.__prop_CurrentCount end
function Curve.__get.PoolState(self) return self.__prop_PoolState end
function Curve.__get.PoolState(self) return self.__prop_PoolState end
function Curve.__get.Points(self) return self.points end
function Curve.__get.Indices(self) return self.indices end
function Curve.__get.Vertices(self) return self.vertices end
function Curve:Rotate(v,deg)

local num=(((deg / CS.f(180))) * Math.PI)
local num2=CS.f(CS.invoke(Math,"Cos",num))
local num3=CS.f(CS.invoke(Math,"Sin",num))
do return CS.new("Vector2",((num2 * v.X) - (num3 * v.Y)),((num2 * v.Y) + (num3 * v.X))) end
end
function Curve:Update(pos,width,length)

self.points[self.current]=CS.copy(pos)
local vector=CS.copy(self.points[CS.choose((((self.current - ((self.points.Length - 1))) < 0)),function() return ((self.current + 1)) end,function() return ((self.current - ((self.points.Length - 1)))) end)])
local vector2=CS.copy(self.points[CS.choose((((self.current - ((self.points.Length - 2))) < 0)),function() return ((self.current + 2)) end,function() return ((self.current - ((self.points.Length - 2)))) end)])
self.actualLength=CS.f((self.actualLength - CS.invoke(((vector - vector2)),"Length")))
self.actualLength=CS.f((self.actualLength + CS.invoke(((self.points[self.current] - self.points[CS.choose((((self.current - 1) < 0)),function() return ((self.points.Length - 1)) end,function() return ((self.current - 1)) end)])),"Length")))
local num=CS.invoke(Math,"Min",self.actualLength,length)
local num2=(width * CS.f(0.5))
local num3=self.current
local num4=0
local num5=0
local num6=CS.f(0)
do
local i=0
while (i < (self.points.Length - 1)) do
local __break1,__continue1=false,false
repeat
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=((i * 2))
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=(((i * 2) + 1))
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=(((i * 2) + 2))
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=(((i * 2) + 1))
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=(((i * 2) + 3))
self.indices[(function() local old=num5;num5=num5+1;return old end)()]=(((i * 2) + 2))
local vector3=CS.copy(self.points[num3])
num3=(CS.choose((((num3 - 1) < 0)),function() return ((self.points.Length - 1)) end,function() return ((num3 - 1)) end))
local vector4=CS.copy(self.points[num3])
local vector5=CS.copy((CS.choose(((vector4 == vector3)),function() return CS.new("Vector2",CS.f(0),CS.f(0)) end,function() return CS.invoke(Vector2,"Normalize",(vector3 - vector4)) end)))
local num7=CS.invoke(((vector3 - vector4)),"Length")
if ((num6 + num7) > num) then
vector4=CS.copy((vector3 - (vector5 * ((num - num6)))))
num6=CS.f(num)
else
num6=CS.f((num6 + num7))
end
local vector6=CS.copy((Curve.Rotate(self,vector5,(-CS.f(90))) * num2))
local vector7=CS.copy((Curve.Rotate(self,vector5,CS.f(90)) * num2))
if (i == 0) then
self.vertices[num4].Position=CS.copy(CS.new("Vector3",(vector3 + vector6),CS.f(0)))
self.vertices[num4].TextureCoordinate=CS.copy(CS.new("Vector2",CS.f(0),CS.f(0)))
num4=num4+1
self.vertices[num4].Position=CS.copy(CS.new("Vector3",(vector3 + vector7),CS.f(0)))
self.vertices[num4].TextureCoordinate=CS.copy(CS.new("Vector2",CS.f(1),CS.f(0)))
num4=num4+1
end
local y=(num6 / num)
self.vertices[num4].Position=CS.copy(CS.new("Vector3",(vector4 + vector6),CS.f(0)))
self.vertices[num4].TextureCoordinate=CS.copy(CS.new("Vector2",CS.f(0),y))
num4=num4+1
self.vertices[num4].Position=CS.copy(CS.new("Vector3",(vector4 + vector7),CS.f(0)))
self.vertices[num4].TextureCoordinate=CS.copy(CS.new("Vector2",CS.f(1),y))
num4=num4+1
until true
if __break1 then break end
i=i+1
end
end
self.current=self.current+1
if (self.current >= self.points.Length) then
self.current=0
end
end
function Curve.defaults(self)
self.CurvePool=nil
self.instanceID=0
self.tex=nil
self.points=nil
self.current=0
self.actualLength=0
self.indices=nil
self.vertices=nil
end
return _ENV
end
