-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- Beilvcao.cs SHA256 4ab41348efb862f205881dcd92b1f4a3cca3d17e1c4cec7382e428f30696c0b0
Beilvcao={__get={},__set={}}
Beilvcao.__index=function(o,k) local getter=Beilvcao.__get[k];if getter then return getter(o) end;return Beilvcao[k] end
Beilvcao.__newindex=function(o,k,v) local setter=Beilvcao.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Beilvcao.__base="MonoBehaviour"
function Beilvcao:FixedUpdate()

if (Sincos.if_change ~= self.last_ifqiehuan) then
if Sincos.if_change then
if (not Sincos.kaiguan_a) then
self.waittime_a=60
local num=CS.trunc(((((Sincos.suipian_beilv_hong - CS.f(1))) * CS.f(330))))
if (num >= 33) then
Sincos.hyper_time=(Sincos.hyper_time + num)
end
if (Sincos.hyper_time > 660) then
Sincos.hyper_time=660
end
end
Sincos.kaiguan_a=true
self.jiangdi_a=CS.f((((Sincos.suipian_beilv_hong - CS.f(1))) / CS.f(600)))
else
if (not Sincos.kaiguan_b) then
self.waittime_b=60
local num2=CS.trunc(((((Sincos.suipian_beilv_zi - CS.f(1))) * CS.f(330))))
if (num2 >= 33) then
Sincos.hyper_time=(Sincos.hyper_time + num2)
end
if (Sincos.hyper_time > 660) then
Sincos.hyper_time=660
end
end
Sincos.kaiguan_b=true
self.jiangdi_b=CS.f((((Sincos.suipian_beilv_zi - CS.f(1))) / CS.f(600)))
end
end
if Sincos.kaiguan_a then
if (Sincos.suipian_beilv_hong > CS.f(1)) then
if (self.waittime_a == 0) then
Sincos.suipian_beilv_hong=(Sincos.suipian_beilv_hong - self.jiangdi_a)
else
self.waittime_a=self.waittime_a-1
end
else
Sincos.suipian_beilv_hong=CS.f(1)
Sincos.kaiguan_a=false
end
end
if Sincos.kaiguan_b then
if (Sincos.suipian_beilv_zi > CS.f(1)) then
if (self.waittime_b == 0) then
Sincos.suipian_beilv_zi=(Sincos.suipian_beilv_zi - self.jiangdi_b)
else
self.waittime_b=self.waittime_b-1
end
else
Sincos.suipian_beilv_zi=CS.f(1)
Sincos.kaiguan_b=false
end
end
self.last_ifqiehuan=Sincos.if_change
end
function Beilvcao.defaults(self)
self.alpha=0
self.beilv_int=0
self.sr=CS.array(4,function() return nil end)
self.red=nil
self.zi=nil
self.number=CS.array(2,function() return nil end)
self.dian=nil
self.dian_hong=nil
self.dian_zi=nil
self.kuang_hong=nil
self.kuang_zi=nil
self.jiangdi_a=0
self.jiangdi_b=0
self.waittime_a=0
self.waittime_b=0
self.last_ifqiehuan=false
end
return _ENV
end
