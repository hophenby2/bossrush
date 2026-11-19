-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- MyPlane_Reimu.cs SHA256 2d7544a77aaa3bb3a9aad072f79e731fc930a63a81ccc978bd5b1958b45e8698
MyPlane_Reimu={__get={},__set={}}
MyPlane_Reimu.__index=function(o,k) local getter=MyPlane_Reimu.__get[k];if getter then return getter(o) end;return MyPlane_Reimu[k] end
MyPlane_Reimu.__newindex=function(o,k,v) local setter=MyPlane_Reimu.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
MyPlane_Reimu.__base="BaseMyPlane_Touhou"
function MyPlane_Reimu:Shoot()

if (CS.rem(self.Time,3) == 0) then
CS.invoke(self.StageData,"SoundPlay","se_plst00.wav",(self.OriginalPosition.X / CS.f(self.BoundRect.Width)))
local x=self.OriginalPosition.X
local y=self.OriginalPosition.Y
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"ReimuBullet",CS.new("PointF",(x - CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou.Damage=14
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"ReimuBullet",CS.new("PointF",(x + CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou2.Damage=14
end
if (CS.rem(self.Time,4) == 0) then
do
local i=0
while (i < self.PowerLevel) do
local __break1,__continue1=false,false
repeat
CS.invoke(self.SubPlaneList[i],"Shoot")
until true
if __break1 then break end
i=i+1
end
end
end
end
function MyPlane_Reimu:SubPlaneCtrl()

if self.KClass.Key_Shift then
do local __switch2=self.PowerLevel
repeat
if __switch2==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(70)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(0)),(self.OriginalPosition.Y - CS.f(70)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(0)),(self.OriginalPosition.Y - CS.f(70)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==3 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(70)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(24)),(self.OriginalPosition.Y - CS.f(0)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(24)),(self.OriginalPosition.Y - CS.f(0)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=CS.f(4.756022211684548)
self.SubPlaneList[2].ShootDirection=CS.f(4.6687557490848315)
break
elseif __switch2==4 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(0)),(self.OriginalPosition.Y - CS.f(70)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(0)),(self.OriginalPosition.Y - CS.f(70)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X - CS.f(24)),(self.OriginalPosition.Y - CS.f(0)))

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X + CS.f(24)),(self.OriginalPosition.Y - CS.f(0)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=CS.f(4.756022211684548)
self.SubPlaneList[3].ShootDirection=CS.f(4.6687557490848315)
break
end
until true
end
else
do local __switch3=self.PowerLevel
repeat
if __switch3==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(48)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(0)),(self.OriginalPosition.Y - CS.f(48)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(0)),(self.OriginalPosition.Y + CS.f(48)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==3 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(48)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(48)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(48)),(self.OriginalPosition.Y + CS.f(0)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==4 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(48)))

self.SubPlanePoint[1]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y + CS.f(48)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X - CS.f(48)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X + CS.f(48)),(self.OriginalPosition.Y + CS.f(0)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[3].ShootDirection=((-Math.PI) / CS.f(2.0))
break
end
until true
end
end
do
local i=0
while (i < self.PowerLevel) do
local __break4,__continue4=false,false
repeat
self.SubPlaneList[i].Enabled=true
self.SubPlaneList[i].DestPoint=self.SubPlanePoint[i]
CS.invoke(self.SubPlaneList[i],"Ctrl")
until true
if __break4 then break end
i=i+1
end
end
do
local i=self.PowerLevel
while (i < self.SubPlaneList.Count) do
local __break5,__continue5=false,false
repeat
self.SubPlaneList[i].Enabled=false
self.SubPlaneList[i].Position=CS.copy(self.Position)
until true
if __break5 then break end
i=i+1
end
end
end
function MyPlane_Reimu.defaults(self)
end
-- MyPlane_Marisa.cs SHA256 1592f94feaebcab9f5a3290d560dc10586184c6dba82eb6c64b9589f56afbf55
MyPlane_Marisa={__get={},__set={}}
MyPlane_Marisa.__index=function(o,k) local getter=MyPlane_Marisa.__get[k];if getter then return getter(o) end;return MyPlane_Marisa[k] end
MyPlane_Marisa.__newindex=function(o,k,v) local setter=MyPlane_Marisa.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
MyPlane_Marisa.__base="BaseMyPlane_Touhou"
function MyPlane_Marisa:Shoot()

if (self.SpellList.Count <= 0) then
if (CS.rem(self.Time,3) == 0) then
CS.invoke(self.StageData,"SoundPlay","se_plst00.wav",(self.OriginalPosition.X / CS.f(self.BoundRect.Width)))
local x=self.OriginalPosition.X
local y=self.OriginalPosition.Y
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"MarisaBullet00",CS.new("PointF",(x + CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou.Damage=15
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"MarisaBullet00",CS.new("PointF",(x - CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou2.Damage=15
end
do
local i=0
while (i < self.PowerLevel) do
local __break1,__continue1=false,false
repeat
CS.invoke(self.SubPlaneList[i],"Shoot")
until true
if __break1 then break end
i=i+1
end
end
end
end
function MyPlane_Marisa:SubPlaneCtrl()

if self.KClass.Key_Shift then
do local __switch2=self.PowerLevel
repeat
if __switch2==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(40)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))
self.SubPlaneList[0].ShootDirection=CS.f(4.834562028024293)
self.SubPlaneList[1].ShootDirection=CS.f(4.590215932745087)
break
elseif __switch2==3 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(40)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=CS.f(4.834562028024293)
self.SubPlaneList[2].ShootDirection=CS.f(4.590215932745087)
break
elseif __switch2==4 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y - CS.f(10)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X - CS.f(14)),(self.OriginalPosition.Y - CS.f(35)))

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X + CS.f(14)),(self.OriginalPosition.Y - CS.f(35)))
self.SubPlaneList[0].ShootDirection=CS.f(4.834562028024293)
self.SubPlaneList[1].ShootDirection=CS.f(4.590215932745087)
self.SubPlaneList[2].ShootDirection=CS.f(4.76474885794452)
self.SubPlaneList[3].ShootDirection=CS.f(4.6600291028248595)
break
end
until true
end
else
do local __switch3=self.PowerLevel
repeat
if __switch3==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(50)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y - CS.f(0)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y - CS.f(0)))
self.SubPlaneList[0].ShootDirection=CS.f(4.677482395344803)
self.SubPlaneList[1].ShootDirection=CS.f(4.747295565424577)
break
elseif __switch3==3 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(50)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y + CS.f(0)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=CS.f(4.677482395344803)
self.SubPlaneList[2].ShootDirection=CS.f(4.747295565424577)
break
elseif __switch3==4 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(31)),(self.OriginalPosition.Y - CS.f(0)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(31)),(self.OriginalPosition.Y - CS.f(0)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X - CS.f(14)),(self.OriginalPosition.Y - CS.f(50)))

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X + CS.f(14)),(self.OriginalPosition.Y - CS.f(50)))
self.SubPlaneList[0].ShootDirection=CS.f(4.677482395344803)
self.SubPlaneList[1].ShootDirection=CS.f(4.747295565424577)
self.SubPlaneList[2].ShootDirection=CS.f(4.71238898038469)
self.SubPlaneList[3].ShootDirection=CS.f(4.71238898038469)
break
end
until true
end
end
do
local i=0
while (i < self.PowerLevel) do
local __break4,__continue4=false,false
repeat
self.SubPlaneList[i].Enabled=true
self.SubPlaneList[i].DestPoint=self.SubPlanePoint[i]
CS.invoke(self.SubPlaneList[i],"Ctrl")
until true
if __break4 then break end
i=i+1
end
end
do
local i=self.PowerLevel
while (i < self.SubPlaneList.Count) do
local __break5,__continue5=false,false
repeat
self.SubPlaneList[i].Enabled=false
self.SubPlaneList[i].Position=CS.copy(self.Position)
until true
if __break5 then break end
i=i+1
end
end
end
function MyPlane_Marisa.defaults(self)
end
-- MyPlane_Sanae.cs SHA256 037b5a0bbfe61246b3b1408ff401878e3d3ef5d24349d5cf145715c6d6a1abfb
MyPlane_Sanae={__get={},__set={}}
MyPlane_Sanae.__index=function(o,k) local getter=MyPlane_Sanae.__get[k];if getter then return getter(o) end;return MyPlane_Sanae[k] end
MyPlane_Sanae.__newindex=function(o,k,v) local setter=MyPlane_Sanae.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
MyPlane_Sanae.__base="BaseMyPlane_Touhou"
function MyPlane_Sanae:Shoot()

if (CS.rem(self.Time,3) == 0) then
CS.invoke(self.StageData,"SoundPlay","se_plst00.wav",(self.OriginalPosition.X / CS.f(self.BoundRect.Width)))
local x=self.OriginalPosition.X
local y=self.OriginalPosition.Y
CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeBullet00",CS.new("PointF",(x + CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeBullet00",CS.new("PointF",(x - CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
end
if (CS.rem(self.Time,4) == 0) then
do
local i=0
while (i < self.PowerLevel) do
local __break1,__continue1=false,false
repeat
CS.invoke(self.SubPlaneList[i],"Shoot")
until true
if __break1 then break end
i=i+1
end
end
end
end
function MyPlane_Sanae:SubPlaneCtrl()

if self.KClass.Key_Shift then
do local __switch2=self.PowerLevel
repeat
if __switch2==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(30)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(10)),(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(10)),(self.OriginalPosition.Y - CS.f(30)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==3 then

self.SubPlanePoint[2]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(7)),(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(7)),(self.OriginalPosition.Y - CS.f(30)))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==4 then

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X - CS.f(6)),(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(6)),(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(12)),(self.OriginalPosition.Y - CS.f(30)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(12)),(self.OriginalPosition.Y - CS.f(30)))
self.SubPlaneList[3].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
end
until true
end
else
do local __switch3=self.PowerLevel
repeat
if __switch3==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y + CS.f(30)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(36)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(36)),(self.OriginalPosition.Y - CS.f(0)))
self.SubPlaneList[0].ShootDirection=(-CS.f(1.6607963303711752))
self.SubPlaneList[1].ShootDirection=(-CS.f(1.4807963232186179))
break
elseif __switch3==3 then

self.SubPlanePoint[2]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y + CS.f(30)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(36)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(36)),(self.OriginalPosition.Y + CS.f(0)))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=(-CS.f(1.6607963303711752))
self.SubPlaneList[0].ShootDirection=(-CS.f(1.4807963232186179))
break
elseif __switch3==4 then

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X - CS.f(36)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(36)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(66)),(self.OriginalPosition.Y + CS.f(0)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(66)),(self.OriginalPosition.Y + CS.f(0)))
self.SubPlaneList[3].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=(-CS.f(1.6607963303711752))
self.SubPlaneList[0].ShootDirection=(-CS.f(1.4807963232186179))
break
end
until true
end
end
do
local i=0
while (i < self.PowerLevel) do
local __break4,__continue4=false,false
repeat
self.SubPlaneList[i].Enabled=true
self.SubPlaneList[i].DestPoint=self.SubPlanePoint[i]
CS.invoke(self.SubPlaneList[i],"Ctrl")
until true
if __break4 then break end
i=i+1
end
end
do
local i=self.PowerLevel
while (i < self.SubPlaneList.Count) do
local __break5,__continue5=false,false
repeat
self.SubPlaneList[i].Enabled=false
self.SubPlaneList[i].Position=CS.copy(self.Position)
until true
if __break5 then break end
i=i+1
end
end
end
function MyPlane_Sanae.defaults(self)
end
-- MyPlane_Koishi.cs SHA256 fa251f8493bfeccab75fcc5bb845abce12b53446adeaa5d3ad688b02cbbf6140
MyPlane_Koishi={__get={},__set={}}
MyPlane_Koishi.__index=function(o,k) local getter=MyPlane_Koishi.__get[k];if getter then return getter(o) end;return MyPlane_Koishi[k] end
MyPlane_Koishi.__newindex=function(o,k,v) local setter=MyPlane_Koishi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
MyPlane_Koishi.__base="BaseMyPlane_Touhou"
function MyPlane_Koishi:Shoot()

if (CS.rem(self.Time,3) == 0) then
CS.invoke(self.StageData,"SoundPlay","se_plst00.wav",(self.OriginalPosition.X / CS.f(self.BoundRect.Width)))
local x=self.OriginalPosition.X
local y=self.OriginalPosition.Y
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"KoishiBullet",CS.new("PointF",(x + CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou.Damage=13
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"KoishiBullet",CS.new("PointF",(x - CS.f(7)),y),CS.f(30),((-Math.PI) / CS.f(2.0)))
baseMyBullet_Touhou2.Damage=13
end
if (CS.rem(self.Time,10) == 0) then
do
local i=0
while (i < self.PowerLevel) do
local __break1,__continue1=false,false
repeat
CS.invoke(self.SubPlaneList[i],"Shoot")
until true
if __break1 then break end
i=i+1
end
end
end
end
function MyPlane_Koishi:SubPlaneCtrl()

if self.KClass.Key_Shift then
do local __switch2=self.PowerLevel
repeat
if __switch2==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(44)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(7)),(self.OriginalPosition.Y - CS.f(36)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(7)),(self.OriginalPosition.Y - CS.f(36)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==3 then

self.SubPlanePoint[2]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(36)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(16)),(self.OriginalPosition.Y - CS.f(29)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(16)),(self.OriginalPosition.Y - CS.f(29)))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch2==4 then

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X - CS.f(7)),(self.OriginalPosition.Y - CS.f(36)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(7)),(self.OriginalPosition.Y - CS.f(36)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(16)),(self.OriginalPosition.Y - CS.f(29)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(16)),(self.OriginalPosition.Y - CS.f(29)))
self.SubPlaneList[3].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[2].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=((-Math.PI) / CS.f(2.0))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
end
until true
end
else
do local __switch3=self.PowerLevel
repeat
if __switch3==1 then

self.SubPlanePoint[0]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y - CS.f(44)))
self.SubPlaneList[0].ShootDirection=((-Math.PI) / CS.f(2.0))
break
elseif __switch3==2 then

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X - CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X + CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))
self.SubPlaneList[0].ShootDirection=CS.f(3.9269908169872414)
self.SubPlaneList[1].ShootDirection=CS.f(5.497787143782138)
break
elseif __switch3==3 then

self.SubPlanePoint[2]=CS.new("PointF",self.OriginalPosition.X,(self.OriginalPosition.Y + CS.f(44)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))
self.SubPlaneList[2].ShootDirection=(Math.PI / CS.f(2.0))
self.SubPlaneList[1].ShootDirection=CS.f(3.9269908169872414)
self.SubPlaneList[0].ShootDirection=CS.f(5.497787143782138)
break
elseif __switch3==4 then

self.SubPlanePoint[3]=CS.new("PointF",(self.OriginalPosition.X - CS.f(32)),(self.OriginalPosition.Y + CS.f(32)))

self.SubPlanePoint[2]=CS.new("PointF",(self.OriginalPosition.X + CS.f(32)),(self.OriginalPosition.Y + CS.f(32)))

self.SubPlanePoint[1]=CS.new("PointF",(self.OriginalPosition.X - CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))

self.SubPlanePoint[0]=CS.new("PointF",(self.OriginalPosition.X + CS.f(32)),(self.OriginalPosition.Y - CS.f(32)))
self.SubPlaneList[3].ShootDirection=((Math.PI * CS.f(3.0)) / CS.f(4.0))
self.SubPlaneList[2].ShootDirection=(Math.PI / CS.f(4.0))
self.SubPlaneList[1].ShootDirection=CS.f(3.9269908169872414)
self.SubPlaneList[0].ShootDirection=CS.f(5.497787143782138)
break
end
until true
end
end
do
local i=0
while (i < self.PowerLevel) do
local __break4,__continue4=false,false
repeat
self.SubPlaneList[i].Enabled=true
self.SubPlaneList[i].DestPoint=self.SubPlanePoint[i]
CS.invoke(self.SubPlaneList[i],"Ctrl")
until true
if __break4 then break end
i=i+1
end
end
do
local i=self.PowerLevel
while (i < self.SubPlaneList.Count) do
local __break5,__continue5=false,false
repeat
self.SubPlaneList[i].Enabled=false
self.SubPlaneList[i].Position=CS.copy(self.Position)
until true
if __break5 then break end
i=i+1
end
end
end
function MyPlane_Koishi.defaults(self)
self.GodMode=false
end
-- SubPlane_Reimu.cs SHA256 d0bb71d359c834bfbe106b349665d3484621e7bd8f19da9eca758fb90ad9e041
SubPlane_Reimu={__get={},__set={}}
SubPlane_Reimu.__index=function(o,k) local getter=SubPlane_Reimu.__get[k];if getter then return getter(o) end;return SubPlane_Reimu[k] end
SubPlane_Reimu.__newindex=function(o,k,v) local setter=SubPlane_Reimu.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SubPlane_Reimu.__base="BaseSubPlane"
function SubPlane_Reimu:Shoot()

if self.KClass.Key_Shift then
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"MaruBullet",self.OriginalPosition,CS.f(18),(self.ShootDirection + (Math.PI / CS.f(60.0))))
baseMyBullet_Touhou.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou.Damage=5
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"MaruBullet",self.OriginalPosition,CS.f(18),(self.ShootDirection - (Math.PI / CS.f(60.0))))
baseMyBullet_Touhou2.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou2.Damage=5
else
local bulletGuidance=CS.new("BulletGuidance",self.StageData,"ReimuSubBullet",self.Position,CS.f(8),self.ShootDirection)
bulletGuidance.TransparentValueF=CS.f(180)
bulletGuidance.Angle=CS.f(1.5707963705062866)
bulletGuidance.Damage=9
end
end
function SubPlane_Reimu.defaults(self)
end
-- SubPlane_Marisa.cs SHA256 b6a59fe5e1568c4368472249d6d9b7622eddd2a8773fc46ecac7bb8187417acd
SubPlane_Marisa={__get={},__set={}}
SubPlane_Marisa.__index=function(o,k) local getter=SubPlane_Marisa.__get[k];if getter then return getter(o) end;return SubPlane_Marisa[k] end
SubPlane_Marisa.__newindex=function(o,k,v) local setter=SubPlane_Marisa.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SubPlane_Marisa.__base="BaseSubPlane"
function SubPlane_Marisa:Shoot()

local marisaLaser=CS.new("MarisaLaser",self.StageData,"MarisaSubBullet00",self.OriginalPosition,(-CS.f(96)),self.ShootDirection)
marisaLaser.Angle=CS.f(1.5707963705062866)
marisaLaser.Active=true
local marisaLaser2=marisaLaser
CS.invoke(marisaLaser2,"SetBinding",self)
end
function SubPlane_Marisa.defaults(self)
end
-- SubPlane_Sanae.cs SHA256 dd203c0d9c51d1082b440e136aa849990493d0151bdfdc6ec21b533008ca3cbe
SubPlane_Sanae={__get={},__set={}}
SubPlane_Sanae.__index=function(o,k) local getter=SubPlane_Sanae.__get[k];if getter then return getter(o) end;return SubPlane_Sanae[k] end
SubPlane_Sanae.__newindex=function(o,k,v) local setter=SubPlane_Sanae.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SubPlane_Sanae.__base="BaseSubPlane"
function SubPlane_Sanae:Shoot()

if self.KClass.Key_Shift then
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeSubBullet02",self.OriginalPosition,CS.f(40),(self.ShootDirection - CS.f(0.029999999329447746)))
baseMyBullet_Touhou.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou.Damage=3
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeSubBullet02",self.OriginalPosition,CS.f(40),(self.ShootDirection + CS.f(0.029999999329447746)))
baseMyBullet_Touhou2.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou2.Damage=3
do return  end
end
local baseMyBullet_Touhou3=CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeSubBullet00",self.OriginalPosition,CS.f(30),(self.ShootDirection - CS.f(0.15000000596046448)))
baseMyBullet_Touhou3.Angle=CS.f(3.1415927410125732)
baseMyBullet_Touhou3.Damage=7
baseMyBullet_Touhou3.Mirrored=self.Mirrored
local baseMyBullet_Touhou4=CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeSubBullet00",self.OriginalPosition,CS.f(30),(self.ShootDirection + CS.f(0.15000000596046448)))
baseMyBullet_Touhou4.Angle=CS.f(3.1415927410125732)
baseMyBullet_Touhou4.Damage=7
baseMyBullet_Touhou4.Mirrored=self.Mirrored
local baseMyBullet_Touhou5=CS.new("BaseMyBullet_Touhou",self.StageData,"SanaeSubBullet00",self.OriginalPosition,CS.f(30),self.ShootDirection)
baseMyBullet_Touhou5.Angle=CS.f(3.1415927410125732)
baseMyBullet_Touhou5.Damage=7
baseMyBullet_Touhou5.Mirrored=self.Mirrored
end
function SubPlane_Sanae.defaults(self)
end
-- SubPlane_Koishi.cs SHA256 941f5cc86967be0e69fd08f8a0da04ad643c7252e27eac8a7a278973733886ff
SubPlane_Koishi={__get={},__set={}}
SubPlane_Koishi.__index=function(o,k) local getter=SubPlane_Koishi.__get[k];if getter then return getter(o) end;return SubPlane_Koishi[k] end
SubPlane_Koishi.__newindex=function(o,k,v) local setter=SubPlane_Koishi.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SubPlane_Koishi.__base="BaseSubPlane"
function SubPlane_Koishi:Shoot()

if self.KClass.Key_Shift then
local num=5
local num2=CS.f(24.0)
local num3=(((num2 * Math.PI) / CS.f(180.0)) / ((num - 1)))
local num4=(self.ShootDirection - ((((num - 1)) * num3) / CS.f(2.0)))
local num5=num4
do
local i=0
while (i < num) do
local __break1,__continue1=false,false
repeat
local baseMyBullet_Touhou=CS.new("BaseMyBullet_Touhou",self.StageData,"KoishiSubBullet00",self.OriginalPosition,CS.f(15),num5)
baseMyBullet_Touhou.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou.Damage=6
num5=(num5 + num3)
until true
if __break1 then break end
i=i+1
end
end
else
local num=15
local num2=CS.f(120.0)
local num3=(((num2 * Math.PI) / CS.f(180.0)) / ((num - 1)))
local num4=(self.ShootDirection - ((((num - 1)) * num3) / CS.f(2.0)))
local num5=num4
do
local i=0
while (i < num) do
local __break2,__continue2=false,false
repeat
local baseMyBullet_Touhou2=CS.new("BaseMyBullet_Touhou",self.StageData,"KoishiSubBullet01",self.OriginalPosition,CS.f(8),num5)
baseMyBullet_Touhou2.Angle=CS.f(1.5707963705062866)
baseMyBullet_Touhou2.Damage=15
num5=(num5 + num3)
until true
if __break2 then break end
i=i+1
end
end
end
end
function SubPlane_Koishi.defaults(self)
end
return _ENV
end
