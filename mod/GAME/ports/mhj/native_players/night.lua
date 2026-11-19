-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- EquipShoot.cs SHA256 92971b952f73d850cf2792df55a58d4eff3a6bf272e278b77657ac46d5c8b2e7
EquipShoot={__get={},__set={}}
EquipShoot.__index=function(o,k) local getter=EquipShoot.__get[k];if getter then return getter(o) end;return EquipShoot[k] end
EquipShoot.__newindex=function(o,k,v) local setter=EquipShoot.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function EquipShoot.__get.TurnFactor(self) return self.accu[0] end
function EquipShoot:InitShoot()

self.HideLantern=false
CS.invoke(Array,"Clear",self.btime,0,self.btime.Length)
CS.invoke(Array,"Clear",self.ctime,0,self.ctime.Length)
CS.invoke(Array,"Clear",self.counter,0,self.counter.Length)
CS.invoke(Array,"Clear",self.accu,0,self.accu.Length)
end
function EquipShoot:BEquipShoot(s,t,et,p,d)

TempArray.Reset(TempArray)
if CS.invoke(Main,"IsKeyUp",InputKeys.Slow) then
self.accu[0]=(self.accu[0] + ((((CS.f(0) - self.accu[0])) / CS.f(4)) * Time.Stop))
if (CS.invoke(Math,"Abs",self.accu[0]) <= CS.f(0.1)) then
self.accu[0]=CS.f(0)
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveLeft) then
self.accu[0]=CS.invoke(Math,"Max",(-CS.f(1)),(self.accu[0] - CS.f(0.25)))
else
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveRight) then
self.accu[0]=CS.invoke(Math,"Min",CS.f(1),(self.accu[0] + CS.f(0.25)))
end
end
end
do
local i=0
while (i < self.btime.Length) do
local __break1,__continue1=false,false
repeat
self.btime[i]=(self.btime[i] + Time.Stop)
until true
if __break1 then break end
i=i+1
end
end
if (et == EquipType.A) then
do local __switch2=t
repeat
if __switch2==Cname.REIMU then
EquipShoot.NORMAL_A(self,s,p,d)
break
elseif __switch2==Cname.MARISA then
EquipShoot.NORMAL_B(self,s,p,d)
break
elseif __switch2==Cname.SANAE then
EquipShoot.NORMAL_C(self,s,p,d)
break
elseif __switch2==Cname.MOKOU then
EquipShoot.NORMAL_D(self,s,p,d)
break
end
until true
end
else
do local __switch3=t
repeat
if __switch3==Cname.REIMU then
EquipShoot.MASTER_A(self,s,p,d)
break
elseif __switch3==Cname.MARISA then
EquipShoot.MASTER_B(self,s,p,d)
break
elseif __switch3==Cname.SANAE then
EquipShoot.MASTER_C(self,s,p,d)
break
elseif __switch3==Cname.MOKOU then
EquipShoot.MASTER_D(self,s,p,d)
break
end
until true
end
end
end
function EquipShoot:CEquipShoot(s,t,et,p,sprt,d)

TempArray.Reset(TempArray)
local game=Program.main.game
do
local i=0
while (i < self.ctime.Length) do
local __break4,__continue4=false,false
repeat
self.ctime[i]=(self.ctime[i] + Time.Stop)
until true
if __break4 then break end
i=i+1
end
end
if (et == EquipType.A) then
do local __switch5=t
repeat
if __switch5==Cname.REIMU then
EquipShoot.H_AMULET(self,game,s,p,sprt,d)
break
elseif __switch5==Cname.MARISA then
EquipShoot.D_TORPEDO(self,game,s,p,sprt,d)
break
elseif __switch5==Cname.SANAE then
EquipShoot.S_BOMB(self,game,s,p,sprt,d)
break
elseif __switch5==Cname.MOKOU then
EquipShoot.EM_BLAST(self,s,p,sprt,d)
break
end
until true
end
else
do local __switch6=t
repeat
if __switch6==Cname.REIMU then
EquipShoot.MASTER_H_AMULET(self,game,s,p,sprt,d)
break
elseif __switch6==Cname.MARISA then
EquipShoot.MASTER_D_TORPEDO(self,s,p,sprt,d)
break
elseif __switch6==Cname.SANAE then
EquipShoot.MASTER_S_BOMB(self,game,s,p,sprt,d)
break
elseif __switch6==Cname.MOKOU then
EquipShoot.MASTER_EM_BLAST(self,game,s,p,sprt,d)
break
end
until true
end
end
end
function EquipShoot:SEquipShoot(s,t,p,d)

TempArray.Reset(TempArray)
do
local i=0
while (i < self.btime.Length) do
local __break7,__continue7=false,false
repeat
self.btime[i]=(self.btime[i] + Time.Stop)
until true
if __break7 then break end
i=i+1
end
end
if (self.btime[0] >= CS.f(6)) then
local t2=nil
local r=CS.copy(CS.Rectangle())
local o=CS.copy(CS.Vector2())
local alpha_f=CS.f(0)
local scale_v=CS.copy(CS.Vector2())
do local __switch8=t
repeat
if __switch8==Cname.REIMU then
t2=s[0]
r=CS.copy(CS.new("Rectangle",0,0,43,165))
o=CS.copy(CS.new("Vector2",CS.f(21),CS.f(47)))
alpha_f=CS.f(CS.f(0.6))
scale_v=CS.copy((Vector2.One * CS.f(0.65)))
break
elseif __switch8==Cname.MARISA then
t2=s[4]
r=CS.copy(CS.new("Rectangle",360,0,58,70))
o=CS.copy(CS.new("Vector2",CS.f(29),CS.f(20)))
alpha_f=CS.f(CS.f(0.8))
scale_v=CS.copy((Vector2.One * CS.f(0.4)))
break
elseif __switch8==Cname.SANAE then
t2=s[2]
r=CS.copy(CS.new("Rectangle",0,0,128,384))
o=CS.copy(CS.new("Vector2",CS.f(64),CS.f(180)))
alpha_f=CS.f(CS.f(0.47))
scale_v=CS.copy((Vector2.One * CS.f(0.2)))
break
elseif __switch8==Cname.MOKOU then
t2=s[3]
r=CS.copy(CS.new("Rectangle",0,0,256,256))
o=CS.copy(CS.new("Vector2",CS.f(128),CS.f(128)))
alpha_f=CS.f(CS.f(0.4))
scale_v=CS.copy((Vector2.One * CS.f(0.67)))
break
end
until true
end
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t2,r,o,p,CS.f(20),alpha_f,scale_v)
if (t == Cname.MOKOU) then
selfBarrage.label=1001
end
selfBarrage.speed=CS.f(CS.f(12))
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f(CS.f(8))
selfBarrage.life=CS.f(CS.f(18))
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.Overtop
selfBarrage.deadScaleSpeed=CS.f((-CS.f(0.05)))
selfBarrage.muteCustomAlpha=true
self.btime[0]=CS.f(0)
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
end
end
function EquipShoot:NORMAL_A(s,p,d)

local t=s[0]
if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",43,0,47,144) end)))
local o=CS.copy(CS.new("Vector2",CS.f(23),CS.f(80)))
local alpha_f=CS.f(0.55)
local scale_v=CS.copy((Vector2.One * CS.f(0.7)))
local num=4
if Program.main.game.LanternLighting then
r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",43,176,47,144) end)))
alpha_f=CS.f(CS.f(0.55))
end
local vector2s=TempArray.Vector2s
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(30)))
vector2s[1]=CS.copy(CS.new("Vector2",(-CS.f(10)),CS.f(10)))
vector2s[2]=CS.copy(CS.new("Vector2",CS.f(10),CS.f(10)))
vector2s[3]=CS.copy(CS.new("Vector2",CS.f(30),CS.f(30)))
do
local i=0
while (i < num) do
local __break9,__continue9=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[i]),CS.f(15),alpha_f,scale_v)
selfBarrage.speed=CS.f(d.A.mainSpeed)
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f(d.A.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.A.other1)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=316
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.2))
selfBarrage.deadHeightFactor=CS.f((CS.f(0.58) - (CS.f(0.2) * CS.f(CS.invoke(Math,"Sin",(((CS.f(i) / ((CS.f(num) - CS.f(1))))) * Math.PI))))))
until true
if __break9 then break end
i=i+1
end
end
self.btime[0]=CS.f(0)
end
function EquipShoot:MASTER_A(s,p,d)

local num=(self.TurnFactor * CS.f(25))
if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",43,0,47,144) end)))
local o=CS.copy(CS.new("Vector2",CS.f(23),CS.f(80)))
local alpha_f=CS.f(0.55)
local scale_v=CS.copy(CS.new("Vector2",CS.f(0.35),CS.f(0.7)))
local num2=6
if Program.main.game.LanternLighting then
r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",43,176,47,144) end)))
alpha_f=CS.f(CS.f(0.55))
end
local floats=TempArray.Floats
TempArray.Set(TempArray,floats,CS.f(260),CS.f(280),CS.f(240),CS.f(300),CS.f(210),CS.f(330))
do
local i=0
while (i < num2) do
local __break10,__continue10=false,false
repeat
local num3=CS.invoke(MathHelper,"ToRadians",(floats[i] + num))
local vector=CS.copy((CS.new("Vector2",CS.f(38),CS.f(38)) * CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",num3)),CS.f(CS.invoke(Math,"Sin",num3)))))
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",s[0],r,o,(p + vector),CS.f(25),alpha_f,scale_v)
selfBarrage.speed=CS.f(d.B.mainSpeed)
selfBarrage.speedd=CS.f(((-CS.f(90)) + num))
selfBarrage.power=CS.f(d.B.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.B.other1)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=316
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.2))
until true
if __break10 then break end
i=i+1
end
end
self.btime[0]=CS.f(0)
end
function EquipShoot:NORMAL_B(s,p,d)

if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[4]
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",307,0,53,161) end)))
local o=CS.copy(CS.new("Vector2",CS.f(27),CS.f(46)))
local alpha_f=CS.f(0.85)
local scale_v=CS.copy((Vector2.One * CS.f(0.6)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",307,161,53,161))
alpha_f=CS.f(CS.f(1))
end
local speed=d.A.mainSpeed
local num=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 27 end,function() return 47 end))
local num2=6
do local __switch11=Program.main.game.LanternStatus
repeat
if __switch11==LanternStatus.OPENING or __switch11==LanternStatus.LOSINGCONTROL or __switch11==LanternStatus.RELEASING then
scale_v=CS.copy((Vector2.One * CS.f(0.7)))
speed=CS.f(d.A.otherSpeed1)
break
elseif __switch11==LanternStatus.LOSTCONTROL then
scale_v=CS.copy((Vector2.One * CS.f(0.8)))
speed=CS.f(d.A.otherSpeed2)
break
end
until true
end
local num3=4
local vector2s=TempArray.Vector2s
local num4=(self.btime[1] * CS.f(num2))
vector2s[0]=CS.copy(CS.new("Vector2",(CS.f(num) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",(CS.f(((-num))) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[2]=CS.copy(CS.new("Vector2",(CS.f(((-num))) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[3]=CS.copy(CS.new("Vector2",(CS.f(num) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
do
local i=0
while (i < num3) do
local __break12,__continue12=false,false
repeat
if ((((((i ~= 0) or (not ((CS.rem(num4,CS.f(360)) >= CS.f(180)))))) and (((i ~= 1) or (not ((CS.rem(num4,CS.f(360)) < CS.f(180))))))) and (((i ~= 2) or (((not ((num4 < CS.f(180)))) and (not ((CS.rem(((num4 - CS.f(180))),CS.f(360)) < CS.f(180))))))))) and (((i ~= 3) or (((not ((num4 < CS.f(180)))) and (not ((CS.rem(((num4 - CS.f(180))),CS.f(360)) >= CS.f(180))))))))) then
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[i]),CS.f(30),alpha_f,scale_v)
selfBarrage.speed=CS.f(speed)
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f(d.A.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.A.other2)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 125)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 164)
selfBarrage.order=(CS.choose(((i >= 2)),function() return SelfBarrage.Order.Bottom end,function() return SelfBarrage.Order.UnderActor end))
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.02))
end
until true
if __break12 then break end
i=i+1
end
end
self.btime[0]=CS.f(0)
end
function EquipShoot:MASTER_B(s,p,d)

if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[4]
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",307,0,53,161) end)))
local o=CS.copy(CS.new("Vector2",CS.f(27),CS.f(46)))
local alpha_f=CS.f(0.85)
local scale_v=CS.copy((Vector2.One * CS.f(0.6)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",307,161,53,161))
alpha_f=CS.f(CS.f(1))
end
local speed=d.B.mainSpeed
local num=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 27 end,function() return 47 end))
local num2=6
do local __switch13=Program.main.game.LanternStatus
repeat
if __switch13==LanternStatus.OPENING or __switch13==LanternStatus.LOSINGCONTROL or __switch13==LanternStatus.RELEASING then
scale_v=CS.copy((Vector2.One * CS.f(0.7)))
speed=CS.f(d.B.otherSpeed1)
break
elseif __switch13==LanternStatus.LOSTCONTROL then
scale_v=CS.copy((Vector2.One * CS.f(0.8)))
speed=CS.f(d.B.otherSpeed2)
break
end
until true
end
local num3=4
local vector2s=TempArray.Vector2s
local num4=(self.btime[1] * CS.f(num2))
vector2s[0]=CS.copy(CS.new("Vector2",(CS.f(num) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",(CS.f(((-num))) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[2]=CS.copy(CS.new("Vector2",(CS.f(((-num))) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
vector2s[3]=CS.copy(CS.new("Vector2",(CS.f(num) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num4)))),CS.f(0)))
do
local i=0
while (i < num3) do
local __break14,__continue14=false,false
repeat
if ((((((i ~= 0) or (not ((CS.rem(num4,CS.f(360)) >= CS.f(180)))))) and (((i ~= 1) or (not ((CS.rem(num4,CS.f(360)) < CS.f(180))))))) and (((i ~= 2) or (((not ((num4 < CS.f(180)))) and (not ((CS.rem(((num4 - CS.f(180))),CS.f(360)) < CS.f(180))))))))) and (((i ~= 3) or (((not ((num4 < CS.f(180)))) and (not ((CS.rem(((num4 - CS.f(180))),CS.f(360)) >= CS.f(180))))))))) then
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[i]),CS.f(30),alpha_f,scale_v)
selfBarrage.speed=CS.f(speed)
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f(d.B.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.A.other2)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 125)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 164)
selfBarrage.order=(CS.choose(((i >= 2)),function() return SelfBarrage.Order.Bottom end,function() return SelfBarrage.Order.UnderActor end))
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.02))
end
until true
if __break14 then break end
i=i+1
end
end
self.btime[0]=CS.f(0)
end
function EquipShoot:NORMAL_C(s,p,d)

if (self.btime[0] >= CS.f(1)) then
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[2]
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",256,72,256,177) end)))
local o=CS.copy(CS.new("Vector2",CS.f(128),CS.f(36)))
local alpha_f=CS.f(0.55)
local scale_v=CS.copy((Vector2.One * CS.f(0.5)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",256,328,256,177))
alpha_f=CS.f(CS.f(0.6))
end
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,p,CS.f(50),alpha_f,scale_v)
selfBarrage.speed=CS.f(d.A.mainSpeed)
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f((CS.choose(Program.main.game.LanternLighting,function() return d.A.other1 end,function() return d.A.main end)))
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.A.other2)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 262)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 292)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.05))
self.btime[0]=CS.f(0)
end
end
function EquipShoot:MASTER_C(s,p,d)

if (self.btime[0] >= CS.f(1)) then
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[2]
local r=CS.copy((CS.choose(((CS.rem(self.btime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",256,72,256,177) end)))
local o=CS.copy(CS.new("Vector2",CS.f(128),CS.f(36)))
local alpha_f=CS.f(0.55)
local scale_v=CS.copy((Vector2.One * CS.f(0.5)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",256,328,256,177))
alpha_f=CS.f(CS.f(0.6))
end
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,p,CS.f(50),alpha_f,scale_v)
selfBarrage.speed=CS.f(d.B.mainSpeed)
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f((CS.choose(Program.main.game.LanternLighting,function() return d.B.other1 end,function() return d.B.main end)))
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.A.other2)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 262)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 292)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.05))
self.btime[0]=CS.f(0)
end
end
function EquipShoot:NORMAL_D(s,p,d)

local vector2s=TempArray.Vector2s
local floats=TempArray.Floats
if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[3]
local o=CS.copy(CS.new("Vector2",CS.f(34),CS.f(50)))
local alpha_f=CS.f(0.9)
local num=2
local num2=2
local scale_v=CS.copy((Vector2.One * CS.f(0.5)))
local num3=25
local speed=d.A.mainSpeed
do local __switch15=Program.main.game.LanternStatus
repeat
if __switch15==LanternStatus.OPENING or __switch15==LanternStatus.LOSINGCONTROL or __switch15==LanternStatus.RELEASING then
scale_v=CS.copy((Vector2.One * CS.f(0.7)))
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(23)),(-CS.f(10))))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(23),(-CS.f(10))))
num3=31
break
elseif __switch15==LanternStatus.LOSTCONTROL then
num=40
num2=8
speed=CS.f(d.A.otherSpeed1)
do
local i=0
while (i < num) do
local __break16,__continue16=false,false
repeat
floats[i]=((CS.f(((i + 1))) / CS.f(num)) * CS.f(360))
vector2s[i]=CS.copy(CS.new("Vector2",CS.f(0),CS.f(0)))
until true
if __break16 then break end
i=i+1
end
end
break
elseif true then
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(18)),(-CS.f(10))))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(18),(-CS.f(10))))
break
end
until true
end
local r=CS.copy((CS.choose(((CS.rem(self.btime[2],CS.f(((num2 * 2)))) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",300,781,68,157) end)))
if Program.main.game.LanternLighting then
r=CS.copy((CS.choose(((CS.rem(self.btime[2],CS.f(((num2 * 2)))) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",368,781,68,157) end)))
alpha_f=CS.f(CS.f(1))
end
if (self.btime[1] >= CS.f(num2)) then
do
local j=0
while (j < num) do
local __break17,__continue17=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[j]),num3,alpha_f,scale_v)
selfBarrage.speed=CS.f(speed)
selfBarrage.speedd=CS.f(floats[j])
selfBarrage.power=CS.f(d.A.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.B.other4)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=(not Program.main.game.LanternLighting)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.02))
until true
if __break17 then break end
j=j+1
end
end
self.btime[1]=CS.f(0)
end
self.btime[0]=CS.f(0)
end
function EquipShoot:MASTER_D(s,p,d)

local vector2s=TempArray.Vector2s
local floats=TempArray.Floats
if (not ((self.btime[0] >= CS.f(1)))) then
do return  end
end
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local t=s[3]
local o=CS.copy(CS.new("Vector2",CS.f(34),CS.f(50)))
local alpha_f=CS.f(0.9)
local num=2
local num2=2
local scale_v=CS.copy((Vector2.One * CS.f(0.5)))
local num3=25
local speed=d.B.mainSpeed
do local __switch18=Program.main.game.LanternStatus
repeat
if __switch18==LanternStatus.OPENING or __switch18==LanternStatus.LOSINGCONTROL or __switch18==LanternStatus.RELEASING then
scale_v=CS.copy((Vector2.One * CS.f(0.7)))
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(23)),(-CS.f(10))))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(23),(-CS.f(10))))
num3=31
break
elseif __switch18==LanternStatus.LOSTCONTROL then
num=40
num2=8
speed=CS.f(d.B.otherSpeed1)
do
local i=0
while (i < num) do
local __break19,__continue19=false,false
repeat
floats[i]=((CS.f(((i + 1))) / CS.f(num)) * CS.f(360))
vector2s[i]=CS.copy(CS.new("Vector2",CS.f(0),CS.f(0)))
until true
if __break19 then break end
i=i+1
end
end
break
elseif true then
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(18)),(-CS.f(10))))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(18),(-CS.f(10))))
break
end
until true
end
local r=CS.copy((CS.choose(((CS.rem(self.btime[2],CS.f(((num2 * 2)))) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",300,781,68,157) end)))
if Program.main.game.LanternLighting then
r=CS.copy((CS.choose(((CS.rem(self.btime[2],CS.f(((num2 * 2)))) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",368,781,68,157) end)))
alpha_f=CS.f(CS.f(1))
end
if (self.btime[1] >= CS.f(num2)) then
do
local j=0
while (j < num) do
local __break20,__continue20=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[j]),num3,alpha_f,scale_v)
selfBarrage.speed=CS.f(speed)
selfBarrage.speedd=CS.f(floats[j])
selfBarrage.power=CS.f(d.B.main)
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
selfBarrage.power=CS.f(d.B.other4)
end
selfBarrage.affectFamiliar=true
selfBarrage.additive=(not Program.main.game.LanternLighting)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.02))
until true
if __break20 then break end
j=j+1
end
end
self.btime[1]=CS.f(0)
end
self.btime[0]=CS.f(0)
end
function EquipShoot:H_AMULET(game,s,p,sprt,d)

local t=s[0]
local rectangle=CS.copy(CS.Rectangle())
local vector=CS.copy(CS.Vector2())
local num=CS.f(0)
local vector2=CS.copy(CS.Vector2())
local num2=0
local floats=TempArray.Floats
local floatsEXT=TempArray.FloatsEXT1
local floatsEXT2=TempArray.FloatsEXT2
do local __switch21=Program.main.game.LanternStatus
repeat
if __switch21==LanternStatus.OPENING or __switch21==LanternStatus.LOSINGCONTROL or __switch21==LanternStatus.RELEASING then
num2=6
TempArray.Set(TempArray,floats,CS.f(30),CS.f(27),CS.f(24),CS.f(21),CS.f(18),CS.f(15))
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
TempArray.Set(TempArray,floatsEXT,(-CS.f(90)),(-CS.f(92)),(-CS.f(94)),(-CS.f(96)),(-CS.f(98)),(-CS.f(100)))
TempArray.Set(TempArray,floatsEXT2,(-CS.f(90)),(-CS.f(88)),(-CS.f(86)),(-CS.f(84)),(-CS.f(82)),(-CS.f(80)))
else
TempArray.Set(TempArray,floatsEXT,(-CS.f(90)),(-CS.f(94)),(-CS.f(98)),(-CS.f(102)),(-CS.f(106)),(-CS.f(110)))
TempArray.Set(TempArray,floatsEXT2,(-CS.f(90)),(-CS.f(86)),(-CS.f(82)),(-CS.f(78)),(-CS.f(74)),(-CS.f(70)))
end
break
elseif __switch21==LanternStatus.LOSTCONTROL then
num2=12
do
local i=0
while (i < num2) do
local __break22,__continue22=false,false
repeat
floats[i]=CS.invoke(game,"RandRange",CS.f(15),CS.f(30))
floatsEXT[i]=CS.invoke(game,"RandRange",(-CS.f(180)),CS.f(180))
floatsEXT2[i]=CS.invoke(game,"RandRange",(-CS.f(180)),CS.f(180))
until true
if __break22 then break end
i=i+1
end
end
break
elseif true then
num2=4
TempArray.Set(TempArray,floats,CS.f(27),CS.f(24),CS.f(21),CS.f(18))
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
TempArray.Set(TempArray,floatsEXT,(-CS.f(88)),(-CS.f(90)),(-CS.f(92)),(-CS.f(94)))
TempArray.Set(TempArray,floatsEXT2,(-CS.f(92)),(-CS.f(90)),(-CS.f(88)),(-CS.f(86)))
else
TempArray.Set(TempArray,floatsEXT,(-CS.f(90)),(-CS.f(94)),(-CS.f(98)),(-CS.f(102)))
TempArray.Set(TempArray,floatsEXT2,(-CS.f(90)),(-CS.f(86)),(-CS.f(82)),(-CS.f(78)))
end
break
end
until true
end
if (not ((self.ctime[0] >= CS.f(7)))) then
do return  end
end
rectangle=CS.copy(CS.new("Rectangle",0,0,43,165))
vector=CS.copy(CS.new("Vector2",CS.f(21),CS.f(47)))
num=CS.f(CS.f(0.6))
vector2=CS.copy((Vector2.One * CS.f(0.65)))
if Program.main.game.LanternLighting then
rectangle=CS.copy(CS.new("Rectangle",0,176,43,165))
num=CS.f(CS.f(0.3))
end
do
local j=0
while (j < num2) do
local __break23,__continue23=false,false
repeat
local floatsEXT3=TempArray.FloatsEXT3
TempArray.Set(TempArray,floatsEXT3,floatsEXT[j],floatsEXT2[j])
do
local k=0
while (k < 2) do
local __break24,__continue24=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,rectangle,vector,(p + sprt[(3 + k)].position),CS.f(25),num,vector2)
selfBarrage.speed=CS.f(floats[j])
selfBarrage.speedd=CS.f(floatsEXT3[k])
selfBarrage.power=CS.f(d.A.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f((-CS.f(0.05)))
until true
if __break24 then break end
k=k+1
end
end
until true
if __break23 then break end
j=j+1
end
end
local rectangle2=CS.copy(CS.new("Rectangle",205,0,85,85))
rectangle=CS.copy(CS.new("Rectangle",90,0,115,115))
local vector3=CS.copy(CS.new("Vector2",CS.f(42),CS.f(42)))
vector=CS.copy(CS.new("Vector2",CS.f(57),CS.f(57)))
num=CS.f(CS.f(0.5))
vector2=CS.copy((Vector2.One * CS.f(0.65)))
if Program.main.game.LanternLighting then
rectangle2=CS.copy(CS.new("Rectangle",205,176,85,85))
rectangle=CS.copy(CS.new("Rectangle",90,176,115,115))
vector2=CS.copy((Vector2.One * CS.f(0.8)))
num=CS.f(CS.f(0.5))
end
local floats2=TempArray.Floats
do local __switch25=Program.main.game.LanternStatus
repeat
if __switch25==LanternStatus.OPENING or __switch25==LanternStatus.LOSINGCONTROL or __switch25==LanternStatus.RELEASING then
num2=3
TempArray.Set(TempArray,floats2,CS.f(0),CS.f(180),CS.invoke(game,"RandRange",(-CS.f(135)),(-CS.f(45))))
break
elseif __switch25==LanternStatus.LOSTCONTROL then
num2=4
do
local l=0
while (l < 4) do
local __break26,__continue26=false,false
repeat
floats2[l]=CS.invoke(game,"RandRange",(-CS.f(180)),CS.f(0))
until true
if __break26 then break end
l=l+1
end
end
break
elseif true then
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
TempArray.Set(TempArray,floats2,(-CS.f(45)),(-CS.f(135)))
else
TempArray.Set(TempArray,floats2,(-CS.f(10)),(-CS.f(170)))
end
num2=2
break
end
until true
end
do
local m=0
while (m < num2) do
local __break27,__continue27=false,false
repeat
do
local n=0
while (n < 2) do
local __break28,__continue28=false,false
repeat
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",t,CS.choose(((n == 0)),function() return rectangle2 end,function() return rectangle end),CS.choose(((n == 0)),function() return vector3 end,function() return vector end),(p + sprt[0].position),CS.f(40),num,vector2)
selfBarrage2.chase=true
selfBarrage2.power=CS.f((CS.choose(((n == 0)),function() return CS.f(0) end,function() return d.A.skill end)))
selfBarrage2.speed=CS.f(CS.f(13))
selfBarrage2.speedd=CS.f(floats2[m])
selfBarrage2.additive=false
selfBarrage2.rotate=true
selfBarrage2.rotateSpeed=CS.f(CS.f(20))
selfBarrage2.deadRect=CS.copy(CS.new("Rectangle",90,CS.choose(Program.main.game.LanternLighting,function() return 176 end,function() return 0 end),115,115))
selfBarrage2.defaultChaseDistance=CS.f(CS.f(200))
selfBarrage2.order=SelfBarrage.Order.UnderActor
selfBarrage2.deadScaleSpeed=CS.f(CS.f(0))
selfBarrage2.enableShadow=(n == 0)
until true
if __break28 then break end
n=n+1
end
end
until true
if __break27 then break end
m=m+1
end
end
self.ctime[0]=CS.f(0)
end
function EquipShoot:MASTER_H_AMULET(game,s,p,sprt,d)

local num=(self.TurnFactor * CS.f(25))
local t=s[0]
local num2=2
local num3=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 40 end,function() return 60 end))
local floats=TempArray.Floats
if (self.ctime[0] >= CS.f(1)) then
local r=CS.copy((CS.choose(((CS.rem(self.ctime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",0,0,43,165) end)))
if Program.main.game.LanternLighting then
r=CS.copy((CS.choose(((CS.rem(self.ctime[1],CS.f(2)) == CS.f(0))),function() return CS.Rectangle() end,function() return CS.new("Rectangle",0,176,43,165) end)))
end
local o=CS.copy(CS.new("Vector2",CS.f(21),CS.f(47)))
local num4=CS.f(0.6)
local scale_v=CS.copy((Vector2.One * CS.f(0.8)))
TempArray.Set(TempArray,floats,num3,CS.f(180),num3,CS.f(0))
local lanternStatus=Program.main.game.LanternStatus
if (lanternStatus == LanternStatus.LOSTCONTROL) then
num2=5
local target=floats
local obj=CS.arrayValues({[0]=CS.f(60),[1]=CS.f(180),[2]=CS.f(60),[3]=CS.f(0),[4]=CS.f(80),[5]=CS.f(180),[6]=CS.f(80),[7]=CS.f(0),[8]=CS.f(0),[9]=CS.f(0)})
obj[8]=CS.invoke(game,"RandRange",(-CS.f(80)),CS.f(80))
obj[9]=(CS.choose(((CS.invoke(game,"Rand") > CS.f(0.5))),function() return 180 end,function() return 0 end))
TempArray.Set(TempArray,target,obj)
end
do
local i=0
while (i < num2) do
local __break29,__continue29=false,false
repeat
local num5=CS.invoke(MathHelper,"ToRadians",(floats[((i * 2) + 1)] + num))
local vector=CS.copy((floats[(i * 2)] * CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",num5)),CS.f(CS.invoke(Math,"Sin",num5)))))
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector),CS.f(25),CS.choose(((i == 4)),function() return CS.f(1) end,function() return num4 end),scale_v)
selfBarrage.speed=CS.f(d.B.mainSpeed)
selfBarrage.speedd=CS.f((CS.f(270) + num))
selfBarrage.power=CS.f(d.B.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f((-CS.f(0.1)))
until true
if __break29 then break end
i=i+1
end
end
self.ctime[0]=CS.f(0)
end
local num6=7
num3=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 60 end,function() return 80 end))
floats=TempArray.FloatsEXT1
do local __switch30=Program.main.game.LanternStatus
repeat
if __switch30==LanternStatus.OPENING or __switch30==LanternStatus.LOSINGCONTROL or __switch30==LanternStatus.RELEASING then
num2=6
num6=3
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
local target5=floats
local obj5=CS.arrayValues({[0]=CS.f(0),[1]=(-CS.f(90)),[2]=CS.f(0),[3]=(-CS.f(93)),[4]=CS.f(0),[5]=(-CS.f(96)),[6]=CS.f(0),[7]=(-CS.f(90)),[8]=CS.f(0),[9]=(-CS.f(87)),[10]=CS.f(0),[11]=(-CS.f(84))})
obj5[0]=(-num3)
obj5[2]=(-num3)
obj5[4]=(-num3)
obj5[6]=num3
obj5[8]=num3
obj5[10]=num3
TempArray.Set(TempArray,target5,obj5)
else
local target6=floats
local obj6=CS.arrayValues({[0]=CS.f(0),[1]=(-CS.f(90)),[2]=CS.f(0),[3]=(-CS.f(96)),[4]=CS.f(0),[5]=(-CS.f(102)),[6]=CS.f(0),[7]=(-CS.f(90)),[8]=CS.f(0),[9]=(-CS.f(84)),[10]=CS.f(0),[11]=(-CS.f(78))})
obj6[0]=(-num3)
obj6[2]=(-num3)
obj6[4]=(-num3)
obj6[6]=num3
obj6[8]=num3
obj6[10]=num3
TempArray.Set(TempArray,target6,obj6)
end
break
elseif __switch30==LanternStatus.LOSTCONTROL then
num2=11
num6=3
local target4=floats
local obj4=CS.arrayValues({[0]=(-CS.f(100)),[1]=(-CS.f(90)),[2]=(-CS.f(100)),[3]=(-CS.f(100)),[4]=(-CS.f(100)),[5]=(-CS.f(110)),[6]=(-CS.f(100)),[7]=(-CS.f(120)),[8]=(-CS.f(100)),[9]=(-CS.f(130)),[10]=CS.f(100),[11]=(-CS.f(90)),[12]=CS.f(100),[13]=(-CS.f(80)),[14]=CS.f(100),[15]=(-CS.f(70)),[16]=CS.f(100),[17]=(-CS.f(60)),[18]=CS.f(100),[19]=(-CS.f(50)),[20]=CS.f(0),[21]=CS.f(0)})
obj4[20]=CS.invoke(game,"RandRange",(-CS.f(100)),CS.f(100))
obj4[21]=CS.invoke(game,"RandRange",(-CS.f(130)),(-CS.f(50)))
TempArray.Set(TempArray,target4,obj4)
break
elseif true then
num2=4
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
local target2=floats
local obj2=CS.arrayValues({[0]=CS.f(0),[1]=(-CS.f(90)),[2]=CS.f(0),[3]=(-CS.f(93)),[4]=CS.f(0),[5]=(-CS.f(90)),[6]=CS.f(0),[7]=(-CS.f(87))})
obj2[0]=(-num3)
obj2[2]=(-num3)
obj2[4]=num3
obj2[6]=num3
TempArray.Set(TempArray,target2,obj2)
else
local target3=floats
local obj3=CS.arrayValues({[0]=CS.f(0),[1]=(-CS.f(90)),[2]=CS.f(0),[3]=(-CS.f(96)),[4]=CS.f(0),[5]=(-CS.f(90)),[6]=CS.f(0),[7]=(-CS.f(84))})
obj3[0]=(-num3)
obj3[2]=(-num3)
obj3[4]=num3
obj3[6]=num3
TempArray.Set(TempArray,target3,obj3)
end
break
end
until true
end
if (self.ctime[2] >= CS.f(num6)) then
local r2=CS.copy(CS.new("Rectangle",0,0,43,165))
local o2=CS.copy(CS.new("Vector2",CS.f(21),CS.f(47)))
local alpha_f=CS.f(0.6)
local scale_v2=CS.copy(CS.new("Vector2",CS.f(0.67),CS.f(0.8)))
if Program.main.game.LanternLighting then
r2=CS.copy(CS.new("Rectangle",0,176,43,165))
alpha_f=CS.f(CS.f(0.6))
end
do
local j=0
while (j < num2) do
local __break31,__continue31=false,false
repeat
local num7=CS.invoke(MathHelper,"ToRadians",num)
local vector2=CS.copy((floats[(j * 2)] * CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",num7)),CS.f(CS.invoke(Math,"Sin",num7)))))
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",t,r2,o2,(p + vector2),CS.f(25),alpha_f,scale_v2)
selfBarrage2.speed=CS.f(CS.f(40))
selfBarrage2.speedd=CS.f((floats[((j * 2) + 1)] + num))
selfBarrage2.power=CS.f(d.B.part)
selfBarrage2.affectFamiliar=true
selfBarrage2.additive=false
selfBarrage2.order=SelfBarrage.Order.UnderActor
selfBarrage2.deadScaleSpeed=CS.f((-CS.f(0.1)))
until true
if __break31 then break end
j=j+1
end
end
self.ctime[2]=CS.f(0)
end
end
function EquipShoot:D_TORPEDO(game,s,p,sprt,d)

if (not ((self.ctime[0] >= CS.f(3)))) then
do return  end
end
local t=s[4]
local r=CS.copy(CS.new("Rectangle",360,0,58,70))
local o=CS.copy(CS.new("Vector2",CS.f(29),CS.f(20)))
local alpha_f=CS.f(0.75)
local scale_v=CS.copy((Vector2.One * CS.f(0.4)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",360,161,58,70))
alpha_f=CS.f(CS.f(1))
end
local num=2
local vector2s=TempArray.Vector2s
local floats=TempArray.Floats
do local __switch32=Program.main.game.LanternStatus
repeat
if __switch32==LanternStatus.OPENING or __switch32==LanternStatus.LOSINGCONTROL or __switch32==LanternStatus.RELEASING then
num=4
scale_v=CS.copy((Vector2.One * CS.f(0.5)))
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(45)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",(-CS.f(75)),CS.f(0)))
vector2s[2]=CS.copy(CS.new("Vector2",CS.f(45),CS.f(0)))
vector2s[3]=CS.copy(CS.new("Vector2",CS.f(75),CS.f(0)))
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(82)),(-CS.f(90)),(-CS.f(98)))
else
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(60)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",(-CS.f(90)),CS.f(0)))
vector2s[2]=CS.copy(CS.new("Vector2",CS.f(60),CS.f(0)))
vector2s[3]=CS.copy(CS.new("Vector2",CS.f(90),CS.f(0)))
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)),(-CS.f(90)),(-CS.f(90)))
end
break
elseif __switch32==LanternStatus.LOSTCONTROL then
num=8
scale_v=CS.copy((Vector2.One * CS.f(0.7)))
do
local i=0
while (i < num) do
local __break33,__continue33=false,false
repeat
if (i < CS.idiv(num,2)) then
vector2s[i]=CS.copy(CS.new("Vector2",(-CS.f(60)),CS.f(0)))
else
vector2s[i]=CS.copy(CS.new("Vector2",CS.f(60),CS.f(0)))
end
floats[i]=CS.invoke(game,"RandRange",(-CS.f(180)),CS.f(0))
until true
if __break33 then break end
i=i+1
end
end
break
elseif true then
num=2
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(45)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(45),CS.f(0)))
else
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(60)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(60),CS.f(0)))
end
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
break
end
until true
end
do
local j=0
while (j < num) do
local __break34,__continue34=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[j]),CS.f(20),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(30))
selfBarrage.speedd=CS.f(floats[j])
selfBarrage.power=CS.f(d.A.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=(Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 125)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 164)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.04))
selfBarrage.enableShadow=true
until true
if __break34 then break end
j=j+1
end
end
self.ctime[0]=CS.f(0)
end
function EquipShoot:MASTER_D_TORPEDO(s,p,sprt,d)

if (self.ctime[0] >= CS.f(3)) then
local t=s[4]
local r=CS.copy(CS.new("Rectangle",360,0,58,70))
local o=CS.copy(CS.new("Vector2",CS.f(29),CS.f(20)))
local alpha_f=CS.f(0.75)
local scale_v=CS.copy((Vector2.One * CS.f(0.4)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",360,161,58,70))
alpha_f=CS.f(CS.f(1))
end
local num=2
local vector2s=TempArray.Vector2s
local floats=TempArray.Floats
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(45)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(45),CS.f(0)))
else
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(60)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(60),CS.f(0)))
end
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(90)))
do
local i=0
while (i < num) do
local __break35,__continue35=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[i]),CS.f(20),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(30))
selfBarrage.speedd=CS.f(floats[i])
selfBarrage.power=CS.f(d.B.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=(Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 125)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 164)
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.04))
selfBarrage.enableShadow=true
until true
if __break35 then break end
i=i+1
end
end
self.ctime[0]=CS.f(0)
end
end
function EquipShoot:MASTER_S_BOMB(game,s,p,sprt,d)

local num=2
local vector2s=TempArray.Vector2s
vector2s[0]=CS.copy(CS.new("Vector2",CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((-25)) end,function() return ((-40)) end),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 25 end,function() return 40 end),CS.f(0)))
local floats=TempArray.Floats
local floatsEXT=TempArray.FloatsEXT1
local lanternStatus=Program.main.game.LanternStatus
if (lanternStatus == LanternStatus.LOSTCONTROL) then
num=12
do
local i=0
while (i < 12) do
local __break36,__continue36=false,false
repeat
floats[i]=CS.invoke(game,"RandRange",(-CS.f(180)),CS.f(0))
floatsEXT[i]=CS.f(4)
until true
if __break36 then break end
i=i+1
end
end
else
num=2
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
TempArray.Set(TempArray,floats,(-CS.f(92)),(-CS.f(88)))
else
TempArray.Set(TempArray,floats,(-CS.f(95)),(-CS.f(85)))
end
TempArray.Set(TempArray,floatsEXT,CS.f(2),CS.f(2))
end
do
local j=0
while (j < num) do
local __break37,__continue37=false,false
repeat
local t=s[2]
local r=CS.copy(CS.new("Rectangle",0,0,128,384))
local o=CS.copy(CS.new("Vector2",CS.f(64),CS.f(180)))
local alpha_f=CS.f(0.47)
local scale_v=CS.copy((Vector2.One * CS.f(0.3)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",128,0,128,384))
scale_v=CS.copy((Vector2.One * CS.f(0.6)))
alpha_f=CS.f(CS.f(0.6))
end
if (self.ctime[j] >= floatsEXT[j]) then
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[CS.rem(j,2)]),CS.f(25),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(50))
selfBarrage.speedd=CS.f(floats[j])
selfBarrage.power=CS.f(d.B.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f((CS.choose(Program.main.game.LanternLighting,function() return ((-CS.f(0.05))) end,function() return ((-CS.f(0.025))) end)))
self.ctime[j]=CS.f(0)
end
until true
if __break37 then break end
j=j+1
end
end
end
function EquipShoot:S_BOMB(game,s,p,sprt,d)

local lanternStatus=Program.main.game.LanternStatus
local num=(CS.choose(((lanternStatus ~= LanternStatus.LOSTCONTROL)),function() return 2 end,function() return 12 end))
local vector2s=TempArray.Vector2s
local floats=TempArray.Floats
local floatsEXT=TempArray.FloatsEXT1
do
local i=0
while (i < num) do
local __break38,__continue38=false,false
repeat
vector2s[i]=CS.copy(CS.new("Vector2",CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((-25)) end,function() return ((-40)) end),CS.f(0)))
vector2s[(i + 1)]=CS.copy(CS.new("Vector2",CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 25 end,function() return 40 end),CS.f(0)))
floats[i]=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((-92)) end,function() return ((-95)) end))
floats[(i + 1)]=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((-88)) end,function() return ((-85)) end))
floatsEXT[i]=((function() floatsEXT[(i + 1)]=CS.f(2);return floatsEXT[(i + 1)] end)())
until true
if __break38 then break end
i=(i + 2)
end
end
do
local j=0
while (j < num) do
local __break39,__continue39=false,false
repeat
local t=s[2]
local r=CS.copy(CS.new("Rectangle",0,0,128,384))
local o=CS.copy(CS.new("Vector2",CS.f(64),CS.f(180)))
local alpha_f=CS.f(0.47)
local scale_v=CS.copy((Vector2.One * CS.f(0.3)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",128,0,128,384))
scale_v=CS.copy((Vector2.One * CS.f(0.6)))
alpha_f=CS.f(CS.f(0.6))
end
if (self.ctime[j] >= floatsEXT[j]) then
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[j]),CS.f(25),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(50))
selfBarrage.speedd=CS.f(floats[j])
selfBarrage.power=CS.f(d.A.part)
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f((CS.choose(Program.main.game.LanternLighting,function() return ((-CS.f(0.05))) end,function() return ((-CS.f(0.025))) end)))
self.ctime[j]=CS.f(0)
end
until true
if __break39 then break end
j=j+1
end
end
local sprite=sprt[0]
local num2=8
local num3=2
local num4=self.ctime[(num + num3)]
local num5=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((-60)) end,function() return ((-45)) end))
local num6=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return 240 end,function() return 225 end))
local num7=(CS.f(20) * CS.f(CS.invoke(Math,"Sin",((((num4 * CS.f(2))) * Math.PI) / CS.f(15.0)))))
TempArray.Set(TempArray,floats,((CS.f(num5) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7),((CS.f(num6) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7))
do local __switch40=Program.main.game.LanternStatus
repeat
if __switch40==LanternStatus.OPENING or __switch40==LanternStatus.LOSINGCONTROL or __switch40==LanternStatus.RELEASING then
num2=6
num7=CS.f((CS.f(30) * CS.f(CS.invoke(Math,"Sin",((((num4 * CS.f(2))) * Math.PI) / CS.f(15.0))))))
TempArray.Set(TempArray,floats,((CS.f(num5) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7),((CS.f(num6) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7))
break
elseif __switch40==LanternStatus.LOSTCONTROL then
num2=4
num7=CS.f((CS.f(4) * num4))
TempArray.Set(TempArray,floats,(((-CS.f(45)) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7),((CS.f(135) + CS.invoke(game,"RandRange",(-CS.f(10)),CS.f(10))) + num7))
break
end
until true
end
do
local k=0
while (k < num3) do
local __break41,__continue41=false,false
repeat
local t2=s[2]
local r2=CS.copy(CS.new("Rectangle",1267,106,47,393))
local alpha_f2=CS.f(0.5)
local scale_v2=CS.copy((CS.new("Vector2",CS.f(1.5),CS.f(2)) * CS.f(0.8)))
if Program.main.game.LanternLighting then
r2=CS.copy(CS.new("Rectangle",1220,106,47,393))
scale_v2=CS.copy((CS.new("Vector2",CS.f(1.5),CS.f(2)) * CS.f(0.8)))
alpha_f2=CS.f(CS.f(0.7))
end
if ((((k == 0) and (self.ctime[(k + num)] >= CS.f(num2)))) or (((k == 1) and ((self.ctime[(k + num)] + CS.f(4)) >= CS.f(num2))))) then
self.ctime[(k + num)]=(CS.choose(((k ~= 0)),function() return ((-4)) end,function() return 0 end))
local p2=CS.copy((sprite.position + p))
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",t2,r2,CS.Vector2(),p2,CS.f(25),alpha_f2,scale_v2)
selfBarrage2.curveChase=true
selfBarrage2.speed=CS.f(CS.f(20))
selfBarrage2.speedd=CS.f(floats[k])
selfBarrage2.power=CS.f(d.A.skill)
selfBarrage2.additive=(not Program.main.game.LanternLighting)
selfBarrage2.order=SelfBarrage.Order.UnderActor
selfBarrage2.deadScaleSpeed=CS.f(CS.f(0.025))
if (k == 0) then
selfBarrage2.defaultChaseAngle=CS.f((-CS.f(120)))
else
selfBarrage2.defaultChaseAngle=CS.f((-CS.f(60)))
end
selfBarrage2.life=CS.f(CS.f(90))
end
until true
if __break41 then break end
k=k+1
end
end
end
function EquipShoot:EM_BLAST(s,p,sprt,d)

local num=3
local scale_v=CS.copy(CS.new("Vector2",CS.f(0.15),CS.f(0.75)))
local lanternStatus=Program.main.game.LanternStatus
if (((lanternStatus - 1)) <= 3) then
num=2
scale_v=CS.copy(CS.new("Vector2",CS.f(0.15),CS.f(0.9)))
end
if (self.ctime[0] >= CS.f(num)) then
self.counter[0]=self.counter[0]+1
local t=s[3]
local r=CS.copy(CS.new("Rectangle",0,256,256,256))
local o=CS.copy(CS.new("Vector2",CS.f(128),CS.f(128)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",256,256,256,256))
end
local num2=50
local alpha_f=CS.f(0.01)
local floats=TempArray.Floats
local c=CS.new("Color",255,66,66,0)
if CS.invoke(Main,"IsKeyDown",InputKeys.Slow) then
TempArray.Set(TempArray,floats,CS.f(24),CS.f(220),CS.f(24),(-CS.f(40)))
else
TempArray.Set(TempArray,floats,CS.f(72),CS.f(180),CS.f(72),CS.f(0))
end
do
local i=0
while (i < 2) do
local __break42,__continue42=false,false
repeat
local vector=CS.copy((floats[(i * 2)] * CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",floats[((i * 2) + 1)]))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",floats[((i * 2) + 1)]))))))
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector),num2,alpha_f,scale_v)
selfBarrage.label=((1000 * ((i + 1))) + self.counter[0])
selfBarrage.power=CS.f(d.A.part)
selfBarrage.JudgeDuration=5
selfBarrage.speedx=CS.f((CS.f(2) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",floats[((i * 2) + 1)])))))
selfBarrage.speedy=CS.f((CS.f(2) * CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",floats[((i * 2) + 1)])))))
selfBarrage.speedd=CS.f(((function() selfBarrage.speed=CS.f(CS.f(0));return selfBarrage.speed end)()))
selfBarrage.color=CS.new("Colors",c)
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.deadRect.X=(selfBarrage.deadRect.X + 561)
selfBarrage.deadRect.Y=(selfBarrage.deadRect.Y + 161)
selfBarrage.deadOrigin.Y=CS.f((selfBarrage.deadOrigin.Y + CS.f(80)))
selfBarrage.order=SelfBarrage.Order.UnderActor
selfBarrage.deadScaleSpeed=CS.f(CS.f(0.02))
selfBarrage.hitSound="fireball"
until true
if __break42 then break end
i=i+1
end
end
if (self.counter[0] >= 4) then
self.counter[0]=0
end
self.ctime[0]=CS.f(0)
end
end
function EquipShoot:MASTER_EM_BLAST(game,s,p,sprt,d)

if (self.ctime[0] >= CS.f(5)) then
local t=s[3]
local r=CS.copy(CS.new("Rectangle",0,0,256,256))
local o=CS.copy(CS.new("Vector2",CS.f(128),CS.f(128)))
if Program.main.game.LanternLighting then
r=CS.copy(CS.new("Rectangle",256,0,256,256))
end
local alpha_f=CS.f(0.01)
local scale_v=CS.copy((Vector2.One * CS.f(0.67)))
local vector2s=TempArray.Vector2s
vector2s[0]=CS.copy(CS.new("Vector2",(-CS.f(90)),CS.f(0)))
vector2s[1]=CS.copy(CS.new("Vector2",CS.f(90),CS.f(0)))
local num=3
local floats=TempArray.Floats
TempArray.Set(TempArray,floats,(-CS.f(90)),(-CS.f(80)),(-CS.f(70)),(-CS.f(90)),(-CS.f(100)),(-CS.f(110)))
local lanternStatus=Program.main.game.LanternStatus
if (((lanternStatus - 1)) <= 3) then
num=4
TempArray.Set(TempArray,floats,CS.f(240),CS.f(260),CS.f(280),CS.f(300),CS.f(240),CS.f(260),CS.f(280),CS.f(300))
end
do
local i=0
while (i < 2) do
local __break43,__continue43=false,false
repeat
do
local j=0
while (j < num) do
local __break44,__continue44=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",t,r,o,(p + vector2s[i]),CS.f(5),alpha_f,scale_v)
selfBarrage.label=1001
selfBarrage.power=CS.f(d.B.part)
selfBarrage.speed=CS.f(CS.f(20))
selfBarrage.speedd=CS.f(floats[((i * num) + j)])
selfBarrage.affectFamiliar=true
selfBarrage.additive=false
selfBarrage.order=SelfBarrage.Order.Bottom
selfBarrage.deadScaleSpeed=CS.f((-CS.f(0.02)))
selfBarrage.color=CS.new("Colors",CS.choose(Program.main.game.LanternLighting,function() return CS.f(0.76) end,function() return CS.f(1) end),CS.f(0.76),CS.f(0.76),CS.f(0))
until true
if __break44 then break end
j=j+1
end
end
until true
if __break43 then break end
i=i+1
end
end
self.ctime[0]=CS.f(0)
end
local num2=6
local num3=CS.f(22.5)
local lanternStatus2=Program.main.game.LanternStatus
if (((lanternStatus2 - 1)) <= 3) then
num2=4
num3=CS.f(CS.f(40))
end
if (self.ctime[1] >= CS.f(num2)) then
local t2=s[3]
local r2=CS.copy(CS.new("Rectangle",0,256,256,256))
local o2=CS.copy(CS.new("Vector2",CS.f(128),CS.f(128)))
if Program.main.game.LanternLighting then
r2=CS.copy(CS.new("Rectangle",256,256,256,256))
end
local alpha_f2=CS.f(0.01)
local scale_v2=CS.copy((Vector2.One * CS.f(0.67)))
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",t2,r2,o2,p,CS.f(5),alpha_f2,scale_v2)
selfBarrage2.label=1001
selfBarrage2.power=CS.f(d.B.part)
selfBarrage2.speed=CS.f(CS.f(0.1))
selfBarrage2.speedd=CS.f(((-CS.f(90)) + CS.invoke(game,"RandRange",(CS.f(0) - num3),num3)))
selfBarrage2.affectFamiliar=true
selfBarrage2.additive=false
selfBarrage2.deadRect.X=(selfBarrage2.deadRect.X + 561)
selfBarrage2.deadRect.Y=(selfBarrage2.deadRect.Y + 161)
selfBarrage2.deadOrigin.Y=CS.f((selfBarrage2.deadOrigin.Y + CS.f(80)))
selfBarrage2.order=SelfBarrage.Order.UnderActor
selfBarrage2.deadScaleSpeed=CS.f(CS.f(0.02))
selfBarrage2.hitSound="fireball"
self.ctime[1]=CS.f(0)
end
end
function EquipShoot.defaults(self)
self.HideLantern=false
self.btime=CS.array(20,function() return 0 end)
self.ctime=CS.array(20,function() return 0 end)
self.counter=CS.array(20,function() return 0 end)
self.accu=CS.array(20,function() return 0 end)
end
TempArray={__get={},__set={}}
TempArray.__index=function(o,k) local getter=TempArray.__get[k];if getter then return getter(o) end;return TempArray[k] end
TempArray.__newindex=function(o,k,v) local setter=TempArray.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function TempArray:Reset()

CS.invoke(Array,"Clear",self.Vector2s,0,40)
CS.invoke(Array,"Clear",self.FloatsEXT1,0,40)
CS.invoke(Array,"Clear",self.FloatsEXT2,0,40)
CS.invoke(Array,"Clear",self.FloatsEXT3,0,40)
end
function TempArray:Set(target,...)
local arr=CS.params(...)
do
local i=0
while (i < arr.Length) do
local __break45,__continue45=false,false
repeat
target[i]=arr[i]
until true
if __break45 then break end
i=i+1
end
end
end
function TempArray:Forward(duration,target,...)
local arr=CS.params(...)
do
local i=0
while (i < arr.Length) do
local __break46,__continue46=false,false
repeat
target[i]=(target[i] + (((arr[i] - target[i])) / duration))
until true
if __break46 then break end
i=i+1
end
end
end
function TempArray.defaults(self)
self.capacity=40
self.Vector2s=CS.array(40,function() return CS.Vector2() end)
self.Floats=CS.array(40,function() return 0 end)
self.FloatsEXT1=CS.array(40,function() return 0 end)
self.FloatsEXT2=CS.array(40,function() return 0 end)
self.FloatsEXT3=CS.array(40,function() return 0 end)
end
TempArray.defaults(TempArray)
-- Equipment.cs SHA256 ef944d7dc27b204497dfc531e1c80a2affab6fa007bc41f11da1437874c6238b
Equipment={__get={},__set={}}
Equipment.__index=function(o,k) local getter=Equipment.__get[k];if getter then return getter(o) end;return Equipment[k] end
Equipment.__newindex=function(o,k,v) local setter=Equipment.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Equipment.__base="EquipShoot"
function Equipment:ctor(tex_i)

self.tex=tex_i
self.sprites=CS.List({})
self.cs=CS.Dictionary({})
self.sb=CS.Dictionary({})
self.ec=CS.Dictionary({})
self.fc=CS.Dictionary({})
self.playerChase=CS.copy(((function() self.playerChase2x=CS.copy(Character.SpawnPoint);return self.playerChase2x end)()))
end
function Equipment:Reinit()

self.inited=false
CS.invoke(self.sprites,"Clear")
for _,c in CS.each(self.cs) do
local __break1,__continue1=false,false
repeat
CS.optionalCall(c.Value,"ReturnComponentToPool")
until true
if __break1 then break end
end
CS.invoke(self.cs,"Clear")
for _,item in CS.each(self.sb) do
local __break2,__continue2=false,false
repeat
CS.invoke(SelfBarrageManager,"Return",item.Value)
until true
if __break2 then break end
end
CS.invoke(self.sb,"Clear")
CS.invoke(self.ec,"Clear")
CS.invoke(self.fc,"Clear")
CS.invoke(SelfBarrageManager,"Clear")
EquipShoot.InitShoot(self)
self.reactTime=CS.f(CS.f(0))
self.time=0
end
function Equipment:ResetPlayerPos(character)

self.playerPos=CS.copy(CS.invoke(character,"Position"))
self.playerChase=CS.copy(self.playerPos)
self.playerChase2x=CS.copy(self.playerPos)
end
function Equipment:Update_7(bs,em,csm,t,et,character,Ban)

local game=Program.main.game
self.playerPos=CS.copy(CS.invoke(character,"Position"))
self.playerChase=CS.copy((self.playerChase + (((self.playerPos - self.playerChase)) / CS.f(5))))
self.playerChase2x=CS.copy((self.playerChase2x + (((self.playerPos - self.playerChase2x)) / CS.f(2))))
Equipment.UpdateLantern(self,character,t,false)
do local __switch3=t
repeat
if __switch3==Cname.REIMU then
Equipment.H_AMULET(self,Ban)
break
elseif __switch3==Cname.MARISA then
Equipment.D_TORPEDO(self,game,bs,em,character,Ban)
break
elseif __switch3==Cname.SANAE then
Equipment.S_BOMB(self,game,bs,em,character,Ban)
break
elseif __switch3==Cname.MOKOU then
Equipment.EM_BLAST(self,bs,em,csm,character,Ban)
break
end
until true
end
local flag=(((not Ban) and Character.IsPlayerShoot) and (not self.HideLantern))
if flag then
EquipShoot.CEquipShoot(self,self.tex,t,et,self.playerPos,self.sprites,character.damageSet)
end
if (character.IsControling and (not character.IsPetrifying)) then
local num=(-1)
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveUp) then
num=(-90)
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveDown) then
num=90
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveLeft) then
num=180
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveUp) then
num=225
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveDown) then
num=135
end
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveRight) then
num=0
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveUp) then
num=(-45)
end
if CS.invoke(Main,"IsKeyDown",InputKeys.MoveDown) then
num=45
end
end
if (num ~= (-1)) then
local sprite=self.sprites[0]
local num2=(CS.choose(CS.invoke(Main,"IsKeyDown",InputKeys.Slow),function() return ((character.configSet.lowSpeed * CS.f(0.5))) end,function() return ((CS.f(2.5) + (character.configSet.highSpeed * CS.f(0.5)))) end))
self.lanternControlPos.X=CS.f((self.lanternControlPos.X + ((num2 * CS.f(CS.invoke(Math,"Cos",((num * Math.PI) / CS.f(180.0))))) * Time.Stop)))
self.lanternControlPos.Y=CS.f((self.lanternControlPos.Y + ((num2 * CS.f(CS.invoke(Math,"Sin",((num * Math.PI) / CS.f(180.0))))) * Time.Stop)))
self.lanternControlPos.X=CS.f(CS.invoke(MathHelper,"Clamp",self.lanternControlPos.X,((character.rangex.X - self.playerPos.X) - sprite.position.X),((character.rangex.Y - self.playerPos.X) - sprite.position.X)))
self.lanternControlPos.Y=CS.f(CS.invoke(MathHelper,"Clamp",self.lanternControlPos.Y,((character.rangey.X - self.playerPos.Y) - sprite.position.Y),((character.rangey.Y - self.playerPos.Y) - sprite.position.Y)))
end
if Character.IsPlayerShoot then
EquipShoot.SEquipShoot(self,self.tex,t,character.LanternPos,character.damageSet)
end
else
if (not character.IsPetrifying) then
self.lanternControlPos=CS.copy((self.lanternControlPos + (((CS.Vector2() - self.lanternControlPos)) / CS.f(16))))
end
end
if (self.lastShootable ~= flag) then
do local __switch4=t
repeat
if __switch4==Cname.MARISA then
if flag then
CS.invoke(Program.main.game,"PlaySound","lazer02",true,self.playerPos.X)
else
CS.invoke(Program.main.game,"StopSound","lazer02")
end
break
elseif __switch4==Cname.SANAE then
if flag then
CS.invoke(Program.main.game,"PlaySound","storm",false,CS.f(0))
CS.invoke(Sound,"FadeInFadeable",CS.f(0.5))
else
CS.invoke(Sound,"FadeOutFadeable",CS.f(0.5))
end
Equipment.S_BOMB(self,game,bs,em,character,Ban)
break
elseif __switch4==Cname.MOKOU then
if flag then
CS.invoke(Program.main.game,"PlaySound","fireshot",true,self.playerPos.X)
end
Equipment.EM_BLAST(self,bs,em,csm,character,Ban)
break
end
until true
end
end
self.lastShootable=flag
Equipment.SpecialUpdate(self,bs,em,character)
self.time=self.time+1
end
function Equipment:Update_3(t,character,familiarAlive)

self.playerPos=CS.copy(CS.invoke(character,"Position"))
self.playerChase=CS.copy((self.playerChase + (((self.playerPos - self.playerChase)) / CS.f(5))))
self.playerChase2x=CS.copy((self.playerChase2x + (((self.playerPos - self.playerChase2x)) / CS.f(2))))
Equipment.UpdateLantern(self,character,t,true)
if (not self.inited) then
self.inited=true
end
local lanternDisplayPos=CS.copy(character.LanternDisplayPos)
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","absorb"),function() return self.cs["absorb"] end,function() return nil end))
if ((crazyStorm == nil) and (Program.main.game.LanternStatus == LanternStatus.OPENING)) then
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"500",lanternDisplayPos)
crazyStorm.order=CrazyStorm.Order.Underneath
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",lanternDisplayPos)
else
if (crazyStorm ~= nil) then
crazyStorm.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm,"SetPos",lanternDisplayPos,true)
if (Program.main.game.LanternStatus ~= LanternStatus.OPENING) then
CS.invoke(crazyStorm,"Close")
if (CS.invoke(crazyStorm,"BarrageCount") == 0) then
crazyStorm=nil
end
end
end
end
self.cs["absorb"]=crazyStorm
local crazyStorm2=(CS.choose(CS.invoke(self.cs,"ContainsKey","protect"),function() return self.cs["protect"] end,function() return nil end))
if ((crazyStorm2 == nil) and (((Program.main.game.ProtectChance > 0) or familiarAlive))) then
local num=CS.trunc((((CS.choose(((Program.main.game.ProtectChance > 0)),function() return 500 end,function() return 504 end)) + Main.Character)))
crazyStorm2=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(num,"ToString"),CS.invoke(character,"Position"))
crazyStorm2.order=(CS.choose(((Program.main.game.ProtectChance > 0)),function() return CrazyStorm.Order.Underneath end,function() return CrazyStorm.Order.UnderBarrage end))
crazyStorm2.specialnotkill=true
crazyStorm2.effect=(not familiarAlive)
CS.invoke(crazyStorm2,"BanSound",true)
CS.invoke(crazyStorm2,"SetOPos",CS.invoke(character,"Position"))
else
if (crazyStorm2 ~= nil) then
crazyStorm2.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm2,"SetPos",CS.invoke(character,"Position"),(Program.main.game.ProtectChance > 0))
if (familiarAlive and (crazyStorm2.time.now == 180)) then
local crazyStorm3=CS.invoke(Program.main.game,"PlayEffect",true,"901",CS.new("Vector2",CS.f(336),CS.f(350)))
crazyStorm3.Status=1
CS.invoke(crazyStorm3,"BanSound",true)
end
if ((Program.main.game.ProtectChance <= 0) and (not familiarAlive)) then
CS.invoke(crazyStorm2,"Break")
crazyStorm2=nil
end
end
end
self.cs["protect"]=crazyStorm2
end
function Equipment:UpdateSprite()

do
local i=0
while (i < self.sprites.Count) do
local __break5,__continue5=false,false
repeat
CS.invoke(self.sprites[i],"Update")
until true
if __break5 then break end
i=i+1
end
end
end
function Equipment:SpecialUpdate(bossStage,em,player)

self.lanternStatus=CS.trunc(Program.main.game.LanternStatus)
self.inBossStage=(bossStage ~= nil)
if (Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL) then
do return  end
end
local num=Program.main.game.LanternSetting.LostPower[CS.trunc(player.EquipType)]
local rectangle=CS.copy(CS.new("Rectangle",(CS.trunc(player.rangex.X) - 10),(CS.trunc(player.rangey.X) - 10),(CS.trunc(((player.rangex.Y - player.rangex.X))) + 20),(CS.trunc(((player.rangey.Y - player.rangey.X))) + 20)))
do
local i=0
while (i < em.EnemyArray.Count) do
local __break6,__continue6=false,false
repeat
if (((not em.EnemyArray[i].die) and (em.EnemyArray[i].hp > CS.f(0))) and CS.invoke(rectangle,"Contains",CS.invoke(em.EnemyArray[i],"GetPos"))) then
CS.invoke(em.EnemyArray[i],"DecreasingHp",num,true,false)
end
until true
if __break6 then break end
i=i+1
end
end
if (bossStage ~= nil) then
do
local j=0
while (j < bossStage.Bosses.Count) do
local __break7,__continue7=false,false
repeat
local boss=bossStage.Bosses[j]
CS.invoke(boss,"DecreasingHp",num,true,false)
until true
if __break7 then break end
j=j+1
end
end
end
end
function Equipment:UpdateLantern(character,t,teammate)

local sprite=(CS.choose(self.inited,function() return self.sprites[0] end,function() return nil end))
do local __switch8=t
repeat
if __switch8==Cname.REIMU then
if (not self.inited) then
sprite=CS.new("Sprite",self.tex[0],CS.new("Rectangle",478,0,100,100))
sprite.label=9
sprite.position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(80)))
sprite.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
local animationClip4=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0,[20]=10,[21]=0,[22]=11,[23]=0,[24]=12,[25]=0})})
CS.invoke(sprite,"AddClip",animationClip4)
CS.invoke(sprite,"Play",animationClip4.name)
CS.invoke(self.sprites,"Add",sprite)
end
break
elseif __switch8==Cname.MARISA then
if (not self.inited) then
sprite=CS.new("Sprite",self.tex[4],CS.new("Rectangle",418,0,100,100))
sprite.label=8
sprite.position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(75))))
sprite.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
local animationClip2=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0,[20]=10,[21]=0,[22]=11,[23]=0,[24]=12,[25]=0})})
CS.invoke(sprite,"AddClip",animationClip2)
CS.invoke(sprite,"Play",animationClip2.name)
CS.invoke(self.sprites,"Add",sprite)
end
break
elseif __switch8==Cname.SANAE then
if (not self.inited) then
sprite=CS.new("Sprite",self.tex[2],CS.new("Rectangle",512,0,100,100))
sprite.label=9
sprite.position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(80))))
sprite.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
local animationClip3=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0,[20]=10,[21]=0,[22]=11,[23]=0,[24]=12,[25]=0})})
CS.invoke(sprite,"AddClip",animationClip3)
CS.invoke(sprite,"Play",animationClip3.name)
CS.invoke(self.sprites,"Add",sprite)
end
break
elseif __switch8==Cname.MOKOU then
if (not self.inited) then
sprite=CS.new("Sprite",self.tex[3],CS.new("Rectangle",500,0,100,100))
sprite.label=9
sprite.position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(60)))
sprite.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
local animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0,[20]=10,[21]=0,[22]=11,[23]=0,[24]=12,[25]=0})})
CS.invoke(sprite,"AddClip",animationClip)
CS.invoke(sprite,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite)
end
break
end
until true
end
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","light"),function() return self.cs["light"] end,function() return nil end))
if (((not character.Dis) and character.IsControling) and (crazyStorm == nil)) then
self.lanternControlPos=CS.copy(CS.Vector2())
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"350",character.LanternDisplayPos)
crazyStorm.Status=CS.trunc(((Main.Character - 1)))
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",character.LanternDisplayPos)
else
if (((not character.Dis) and character.IsControling) and (crazyStorm ~= nil)) then
CS.invoke(crazyStorm,"SetPos",character.LanternDisplayPos,false)
else
if (crazyStorm ~= nil) then
CS.invoke(crazyStorm,"Break")
crazyStorm=nil
end
end
end
self.cs["light"]=crazyStorm
sprite.depth=(CS.choose(character.IsControling,function() return ((-1)) end,function() return 0 end))
local t2=(CS.choose(self.HideLantern,function() return CS.f(0) end,function() return (CS.choose(character.IsControling,function() return CS.f(0.8) end,function() return CS.f(0.5) end)) end))
CS.invoke(sprite.scale,"MoveForward",t2,(CS.f(10) / Time.Stop))
if ((Program.main.game.ProtectChance > 0) and teammate) then
sprite.color.a=(sprite.color.a + (((CS.f(0) - sprite.color.a)) / CS.f(10)))
else
sprite.color.a=(sprite.color.a + (((CS.f(1) - sprite.color.a)) / CS.f(10)))
end
end
function Equipment:GetLanternPos(bodyScale,display)

if (self.sprites.Count == 0) then
do return self.playerPos end
end
local sprite=self.sprites[0]
local position=CS.copy(sprite.position)
local scale=CS.copy(sprite.scale)
local a=sprite.color.a
local vector=CS.copy(self.playerPos)
do local __switch9=sprite.label
repeat
if __switch9==1 or __switch9==5 then
vector=CS.copy((CS.choose(display,function() return self.playerChase end,function() return self.playerPos end)))
break
elseif __switch9==2 or __switch9==6 then
vector=CS.copy(Vector2.Zero)
break
elseif __switch9==3 or __switch9==7 then
vector=CS.copy((CS.choose(display,function() return self.playerChase2x end,function() return self.playerPos end)))
break
elseif __switch9==8 then
vector=CS.copy((self.playerPos + self.lanternControlPos))
break
elseif __switch9==9 then
vector=CS.copy(((CS.choose(display,function() return self.playerChase end,function() return self.playerPos end)) + self.lanternControlPos))
break
elseif __switch9==10 then
vector=CS.copy(self.lanternControlPos)
break
elseif __switch9==11 then
vector=CS.copy(((CS.choose(display,function() return self.playerChase2x end,function() return self.playerPos end)) + self.lanternControlPos))
break
end
until true
end
local num=(CS.choose(((sprite.label > 3)),function() return CS.f(1) end,function() return ((bodyScale / CS.f(0.8))) end))
do return CS.new("Vector2",((position.X * num) + vector.X),((position.Y * num) + vector.Y)) end
end
function Equipment:Draw_5(s,quake,sprite,bodyScale,bodyAlpha)

local position=CS.copy(sprite.position)
local scale=CS.copy(sprite.scale)
local a=sprite.color.a
local vector=CS.copy(self.playerPos)
do local __switch10=sprite.label
repeat
if __switch10==1 or __switch10==5 then
vector=CS.copy(self.playerChase)
break
elseif __switch10==2 or __switch10==6 then
vector=CS.copy(Vector2.Zero)
break
elseif __switch10==3 or __switch10==7 then
vector=CS.copy(self.playerChase2x)
break
elseif __switch10==8 then
vector=CS.copy((self.playerPos + self.lanternControlPos))
break
elseif __switch10==9 then
vector=CS.copy((self.playerChase + self.lanternControlPos))
break
elseif __switch10==10 then
vector=CS.copy(self.lanternControlPos)
break
elseif __switch10==11 then
vector=CS.copy((self.playerChase2x + self.lanternControlPos))
break
end
until true
end
local num=(CS.choose(((sprite.label > 3)),function() return CS.f(1) end,function() return ((bodyScale / CS.f(0.8))) end))
sprite.position=CS.copy(CS.new("Vector2",(((position.X * num) + vector.X) + quake.X),(((position.Y * num) + vector.Y) + quake.Y)))
sprite.color.a=(sprite.color.a * bodyAlpha)
num=CS.f((bodyScale / CS.f(0.8)))
sprite.scale=CS.copy((sprite.scale * num))
CS.invoke(sprite,"Draw",s)
sprite.scale=CS.copy(scale)
sprite.color.a=a
sprite.position=CS.copy(position)
end
function Equipment:Draw_4(s,quake,bodyScale,bodyAlpha)

do
local i=0
while (i < self.sprites.Count) do
local __break11,__continue11=false,false
repeat
if (self.sprites[i].depth == 0) then
Equipment.Draw(self,s,quake,self.sprites[i],bodyScale,bodyAlpha)
end
until true
if __break11 then break end
i=i+1
end
end
end
function Equipment:DrawOverTop(s,quake,bodyScale,bodyAlpha)

do
local i=0
while (i < self.sprites.Count) do
local __break12,__continue12=false,false
repeat
if (self.sprites[i].depth == (-1)) then
Equipment.Draw(self,s,quake,self.sprites[i],bodyScale,bodyAlpha)
end
until true
if __break12 then break end
i=i+1
end
end
end
function Equipment:DrawUnderActor(s,quake,bodyScale,bodyAlpha)

do
local i=0
while (i < self.sprites.Count) do
local __break13,__continue13=false,false
repeat
if (self.sprites[i].depth == 1) then
Equipment.Draw(self,s,quake,self.sprites[i],bodyScale,bodyAlpha)
end
until true
if __break13 then break end
i=i+1
end
end
end
function Equipment:DrawUnderneath(s,quake,bodyScale,bodyAlpha)

do
local i=0
while (i < self.sprites.Count) do
local __break14,__continue14=false,false
repeat
if (self.sprites[i].depth == 2) then
Equipment.Draw(self,s,quake,self.sprites[i],bodyScale,bodyAlpha)
end
until true
if __break14 then break end
i=i+1
end
end
end
function Equipment:MAGIC_FIELD_Init(tex,rectX,rectY)

local sprite=CS.new("Sprite",tex,CS.new("Rectangle",rectX,rectY,300,300))
sprite.origin=CS.copy(CS.new("Vector2",CS.f(151),CS.f(152)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
sprite.depth=2
local sprite2=CS.new("Sprite",tex,CS.new("Rectangle",rectX,rectY,300,300))
sprite2.origin=CS.copy(CS.new("Vector2",CS.f(151),CS.f(152)))
sprite2.scale=CS.copy(Vector2.Zero)
sprite2.color.a=CS.f(1)
sprite2.depth=1
CS.invoke(self.sprites,"Add",sprite)
CS.invoke(self.sprites,"Add",sprite2)
end
function Equipment:MAGIC_FIELD(outer,inner,ban)

local num=(CS.f(5) / Time.Stop)
local num2=CS.f(0.76)
local num3=CS.f(0.66)
local num4=2
local num5=(-1)
if Character.IsPlayerShoot then
local num6=CS.f(1)
do local __switch15=Program.main.game.LanternStatus
repeat
if __switch15==LanternStatus.OPENING or __switch15==LanternStatus.RELEASING then
num2=CS.f(CS.f(0.82))
num3=CS.f(CS.f(0.7))
num6=CS.f(CS.f(2))
break
elseif __switch15==LanternStatus.LOSINGCONTROL then
num2=CS.f(CS.f(0.82))
num3=CS.f(CS.f(0.7))
num6=CS.f(CS.f(3))
break
elseif __switch15==LanternStatus.LOSTCONTROL then
num2=CS.f(CS.f(0.984))
num3=CS.f(CS.f(0.84))
num6=CS.f(CS.f(10))
break
end
until true
end
num4=CS.trunc(((CS.f(2) * num6)))
num5=CS.trunc((((-CS.f(1)) * num6)))
end
if (ban or (not Character.IsPlayerShoot)) then
num2=CS.f(CS.f(0))
num3=CS.f(CS.f(0))
end
outer.scale.X=CS.f((outer.scale.X + (((num2 - outer.scale.X)) / num)))
outer.scale.Y=CS.f((outer.scale.Y + (((num2 - outer.scale.Y)) / num)))
outer.rotation=(outer.rotation + num4)
inner.scale.X=CS.f((inner.scale.X + (((num3 - inner.scale.X)) / num)))
inner.scale.Y=CS.f((inner.scale.Y + (((num3 - inner.scale.Y)) / num)))
inner.rotation=(inner.rotation + num5)
outer.color.a=((function() inner.color.a=Character.SelfPowerAlpha;return inner.color.a end)())
end
function Equipment:GUARD_SHEILD(effect,p,ban)

local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","sheild"),function() return self.cs["sheild"] end,function() return nil end))
if ((Character.IsPlayerShoot and (crazyStorm == nil)) and (not ban)) then
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,effect,p)
crazyStorm.order=CrazyStorm.Order.Underneath
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",p)
end
if ((not Character.IsPlayerShoot) and (crazyStorm ~= nil)) then
CS.invoke(crazyStorm,"Close")
crazyStorm=nil
end
if (crazyStorm ~= nil) then
crazyStorm.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm,"SetPos",p,false)
if ban then
CS.invoke(crazyStorm,"Close")
crazyStorm=nil
end
end
self.cs["sheild"]=crazyStorm
end
function Equipment:CalculateLimitDamage(c,o,damage,max)

if (not CS.invoke(c,"ContainsKey",o)) then
damage=CS.f(CS.invoke(Math,"Min",damage,max))
c[o]=damage
do return damage end
end
if ((c[o] + damage) >= max) then
c[o]=max
do return (max - c[o]) end
end
c[o]=(c[o] + damage)
do return damage end
end
function Equipment:H_AMULET(Ban)

local sprite=nil
local sprite2=nil
if (not self.inited) then
self.inited=true
Equipment.MAGIC_FIELD_Init(self,self.tex[0],0,353)
local animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Idle",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0})})
sprite=CS.new("Sprite",self.tex[0],CS.new("Rectangle",478,300,180,200))
sprite.label=3
sprite.origin=CS.copy(CS.new("Vector2",CS.f(48),CS.f(90)))
sprite.position=CS.copy(((CS.new("Vector2",(-CS.f(15)),CS.f(30)) + sprite.origin) - CS.new("Vector2",CS.f(90),CS.f(80))))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
CS.invoke(sprite,"AddClip",animationClip)
CS.invoke(sprite,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite)
sprite2=CS.new("Sprite",self.tex[0],CS.new("Rectangle",478,100,180,200))
sprite2.label=3
sprite2.origin=CS.copy(CS.new("Vector2",CS.f(132),CS.f(90)))
sprite2.position=CS.copy(((CS.new("Vector2",CS.f(15),CS.f(30)) + sprite2.origin) - CS.new("Vector2",CS.f(90),CS.f(80))))
sprite2.scale=CS.copy(Vector2.Zero)
sprite2.color.a=CS.f(1)
CS.invoke(sprite2,"AddClip",animationClip)
CS.invoke(sprite2,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite2)
end
Equipment.MAGIC_FIELD(self,self.sprites[1],self.sprites[2],Ban)
Equipment.GUARD_SHEILD(self,"17",self.playerPos,Ban)
if self.HideLantern then
do return  end
end
sprite=self.sprites[3]
sprite2=self.sprites[4]
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","expand"),function() return self.cs["expand"] end,function() return nil end))
local crazyStorm2=(CS.choose(CS.invoke(self.cs,"ContainsKey","retract"),function() return self.cs["retract"] end,function() return nil end))
if (self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) then
do local __switch16=Program.main.game.LanternStatus
repeat
if __switch16==LanternStatus.OPENING then
sprite.color.a=((function() sprite2.color.a=CS.f(0);return sprite2.color.a end)())
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"44",self.playerPos)
crazyStorm.order=CrazyStorm.Order.UnderActor
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",self.playerPos)
break
elseif __switch16==LanternStatus.BREAKCLOSING or __switch16==LanternStatus.OVERCLOSING then
if (crazyStorm ~= nil) then
CS.invoke(crazyStorm,"Break")
crazyStorm=nil
end
crazyStorm2=CS.invoke(Program.main.game,"PlayEffect",true,"45",self.playerPos)
crazyStorm2.order=CrazyStorm.Order.UnderActor
crazyStorm2.specialnotkill=true
crazyStorm2.effect=true
CS.invoke(crazyStorm2,"BanSound",true)
CS.invoke(crazyStorm2,"SetOPos",self.playerPos)
sprite.position=CS.copy(((CS.new("Vector2",(-CS.f(15)),CS.f(30)) + sprite.origin) - CS.new("Vector2",CS.f(90),CS.f(80))))
sprite2.position=CS.copy(((CS.new("Vector2",CS.f(15),CS.f(30)) + sprite2.origin) - CS.new("Vector2",CS.f(90),CS.f(80))))
break
end
until true
end
end
CS.optionalCall(crazyStorm,"SetPos",self.playerPos,true)
if (crazyStorm2 ~= nil) then
CS.invoke(crazyStorm2,"SetPos",self.playerPos,true)
if (crazyStorm2.time.now == 25) then
sprite.color.a=((function() sprite2.color.a=CS.f(1);return sprite2.color.a end)())
end
if (crazyStorm2.time.now == 50) then
CS.invoke(crazyStorm2,"Break")
crazyStorm2=nil
self.cs["retract"]=nil
end
end
local t=CS.f(0.8)
CS.invoke(sprite.scale,"MoveForward",t,(CS.f(5) / Time.Stop))
CS.invoke(sprite2.scale,"MoveForward",t,(CS.f(5) / Time.Stop))
if ((not Ban) and CS.invoke(Main,"IsKeyDown",InputKeys.Slow)) then
CS.invoke(sprite.position,"MoveForward",(sprite.origin - CS.new("Vector2",CS.f(90),CS.f(80))),(CS.f(3) / Time.Stop))
CS.invoke(sprite2.position,"MoveForward",(sprite2.origin - CS.new("Vector2",CS.f(90),CS.f(80))),(CS.f(3) / Time.Stop))
else
CS.invoke(sprite.position,"MoveForward",((CS.new("Vector2",(-CS.f(15)),CS.f(30)) + sprite.origin) - CS.new("Vector2",CS.f(90),CS.f(80))),(CS.f(3) / Time.Stop))
CS.invoke(sprite2.position,"MoveForward",((CS.new("Vector2",CS.f(15),CS.f(30)) + sprite2.origin) - CS.new("Vector2",CS.f(90),CS.f(80))),(CS.f(3) / Time.Stop))
end
self.cs["expand"]=crazyStorm
self.cs["retract"]=crazyStorm2
end
function Equipment:D_TORPEDO(game,bossStage,em,player,Ban)

local vector=CS.copy(CS.invoke(player,"Position"))
if (not self.inited) then
self.inited=true
Equipment.MAGIC_FIELD_Init(self,self.tex[4],0,0)
if (player.EquipType == EquipType.B) then
local animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Idle",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0})})
do
local i=0
while (i < 20) do
local __break17,__continue17=false,false
repeat
local sprite=CS.new("Sprite",self.tex[4],CS.new("Rectangle",624,94,80,80))
sprite.depth=1
sprite.origin=CS.copy(CS.new("Vector2",CS.f(40),CS.f(40)))
sprite.position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(0)))
sprite.scale=CS.copy(Vector2.Zero)
sprite.color.a=CS.f(1)
CS.invoke(sprite,"AddClip",animationClip)
CS.invoke(sprite,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite)
until true
if __break17 then break end
i=i+1
end
end
self.childrenPos=CS.array(16,function() return CS.Vector2() end)
self.childrenTime=CS.array(16,function() return 0 end)
self.shadowPos=CS.array(40,function() return CS.Vector2() end)
self.shadowPosIndex=0
self.csRefs=CS.array(8,function() return nil end)
self.sbRefs=CS.array(24,function() return nil end)
end
end
Equipment.MAGIC_FIELD(self,self.sprites[1],self.sprites[2],Ban)
Equipment.GUARD_SHEILD(self,"18",vector,Ban)
if self.HideLantern then
do return  end
end
local sprite2=self.sprites[0]
if (player.EquipType == EquipType.B) then
if (player.Moving or player.Leaving) then
self.shadowPos[self.shadowPosIndex]=(vector + CS.new("Vector2",CS.f(0),CS.f(80)))
self.shadowPosIndex=CS.rem(((self.shadowPosIndex + 1)),self.shadowPos.Length)
end
do
local j=0
while (j < 4) do
local __break18,__continue18=false,false
repeat
local sprite3=self.sprites[(j + 3)]
if (player.Dis or player.Spawning) then
sprite3.label=4
sprite3.position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(80)))
do
local k=0
while (k < CS.idiv(self.shadowPos.Length,4)) do
local __break19,__continue19=false,false
repeat
self.shadowPos[(CS.idiv((j * self.shadowPos.Length),4) + k)]=(vector + CS.new("Vector2",CS.f(0),CS.f(80)))
until true
if __break19 then break end
k=k+1
end
end
else
sprite3.label=6
local num=(self.shadowPosIndex - (CS.idiv(self.shadowPos.Length,4) * j))
if (num < 0) then
num=(num + self.shadowPos.Length)
end
sprite3.position=CS.copy(self.shadowPos[num])
end
CS.invoke(sprite3.scale,"MoveForward",CS.f(0.8),CS.f(5))
until true
if __break18 then break end
j=j+1
end
end
if ((Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) and (CS.rem(self.time,10) == 0)) then
do
local l=0
while (l < self.childrenTime.Length) do
local __break20,__continue20=false,false
repeat
if (self.childrenTime[l] == 0) then
self.childrenTime[l]=1
local sprite4=self.sprites[(l + 4)]
sprite4.label=6
sprite4.position=CS.copy(vector)
local num2=CS.invoke(game,"RandRange",CS.f(0),(CS.f(Math.PI) * CS.f(2)))
self.childrenPos[l]=(vector + CS.new("Vector2",(CS.f(160) * CS.f(CS.invoke(Math,"Cos",num2))),(CS.f(40) * CS.f(CS.invoke(Math,"Sin",num2)))))
__break20=true;break
end
until true
if __break20 then break end
l=l+1
end
end
end
do
local m=0
while (m < self.childrenTime.Length) do
local __break21,__continue21=false,false
repeat
if (self.childrenTime[m] <= 0) then
__continue21=true;break
end
local sprite5=self.sprites[(m + 4)]
CS.invoke(sprite5.position,"MoveForward",self.childrenPos[m],CS.f(20))
self.childrenTime[m]=self.childrenTime[m]+1
if (self.childrenTime[m] <= 120) then
CS.invoke(sprite5.scale,"MoveForward",CS.f(0.5),CS.f(10))
__continue21=true;break
end
CS.invoke(sprite5.scale,"MoveForward",CS.f(0),CS.f(10))
if (self.childrenTime[m] >= 159) then
self.childrenTime[m]=0
end
until true
if __break21 then break end
m=m+1
end
end
end
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","starAbove"),function() return self.cs["starAbove"] end,function() return nil end))
if (crazyStorm == nil) then
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"46",vector)
crazyStorm.order=CrazyStorm.Order.UnderBarrage
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",vector)
end
if (crazyStorm ~= nil) then
crazyStorm.alpha=(CS.invoke(Math,"Min",CS.f(1),((player.body.color.a * sprite2.scale.X) * CS.f(2))) * Character.SelfPowerAlpha)
CS.invoke(crazyStorm,"SetPos",vector,true)
local num3=(CS.choose(Program.main.game.LanternLighting,function() return 1 end,function() return 0 end))
if (num3 ~= crazyStorm.Status) then
crazyStorm.Status=num3
end
end
self.cs["starAbove"]=crazyStorm
local crazyStorm2=(CS.choose(CS.invoke(self.cs,"ContainsKey","starUnder"),function() return self.cs["starUnder"] end,function() return nil end))
if (crazyStorm2 == nil) then
crazyStorm2=CS.invoke(Program.main.game,"PlayEffect",true,"47",vector)
crazyStorm2.order=CrazyStorm.Order.UnderActor
crazyStorm2.specialnotkill=true
CS.invoke(crazyStorm2,"BanSound",true)
CS.invoke(crazyStorm2,"SetOPos",vector)
end
if (crazyStorm2 ~= nil) then
crazyStorm2.alpha=(CS.invoke(Math,"Min",CS.f(1),((player.body.color.a * sprite2.scale.X) * CS.f(2))) * Character.SelfPowerAlpha)
CS.invoke(crazyStorm2,"SetPos",vector,true)
local num4=(CS.choose(Program.main.game.LanternLighting,function() return 1 end,function() return 0 end))
if (num4 ~= crazyStorm2.Status) then
crazyStorm2.Status=num4
end
end
self.cs["starUnder"]=crazyStorm2
local crazyStorm3=(CS.choose(CS.invoke(self.cs,"ContainsKey","hitflare"),function() return self.cs["hitflare"] end,function() return nil end))
local selfBarrage=(CS.choose(CS.invoke(self.sb,"ContainsKey","lazer"),function() return self.sb["lazer"] end,function() return nil end))
local num5=1024
local dir=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",(-CS.f(90))))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",(-CS.f(90)))))))
local damageSet=player.damageSet
local num6=(CS.choose(((player.EquipType == EquipType.A)),function() return damageSet.A.skill end,function() return damageSet.B.skill end))
local num7=(CS.choose(((player.EquipType == EquipType.A)),function() return damageSet.A.other1 end,function() return damageSet.B.other1 end))
local array=CS.arrayValues({[0]=num6,[1]=num6,[2]=num6,[3]=num7,[4]=num6,[5]=num6,[6]=num6})
if (selfBarrage ~= nil) then
local boss=nil
if (bossStage ~= nil) then
do
local n=0
while (n < bossStage.Bosses.Count) do
local __break22,__continue22=false,false
repeat
local boss2=bossStage.Bosses[n]
if CS.invoke(boss2,"JudgeRay",vector,dir,CS.new("Vector2",CS.f(0),CS.f(0))) then
local num8=CS.trunc(CS.invoke(Math,"Abs",(vector.Y - boss2.Position.Y)))
if (num8 < num5) then
num5=num8
boss=boss2
end
end
until true
if __break22 then break end
n=n+1
end
end
end
local enemy=CS.invoke(em,"JudgeRay",vector,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
local familiar=CS.invoke(FamiliarManager.Instance,"JudgeRay",vector,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
if ((boss ~= nil) and (((((((((enemy ~= nil) and (familiar ~= nil)) and (boss.Position.Y > enemy.Position.Y)) and (boss.Position.Y > familiar.Y))) or (((enemy == nil) and (familiar == nil)))) or (((familiar == nil) and (boss.Position.Y > enemy.Position.Y)))) or (((enemy == nil) and (boss.Position.Y > familiar.Y)))))) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(boss,"DecreasingHp",(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop),true,false)
end
if ((enemy ~= nil) and (((((((((boss ~= nil) and (familiar ~= nil)) and (enemy.Position.Y > boss.Position.Y)) and (enemy.Position.Y > familiar.Y))) or (((boss == nil) and (familiar == nil)))) or (((familiar == nil) and (enemy.Position.Y > boss.Position.Y)))) or (((boss == nil) and (enemy.Position.Y > familiar.Y)))))) then
num5=CS.trunc(CS.invoke(Math,"Abs",(vector.Y - enemy.Position.Y)))
CS.invoke(enemy,"DecreasingHp",(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop),true,false)
if (CS.rem(enemy.DamagedTime,8) == 0) then
local vector2=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItem",false,(enemy.Position + vector2),false)
end
Program.main.game.Score=(Program.main.game.Score + 10)
end
if ((familiar ~= nil) and (((((((((boss ~= nil) and (enemy ~= nil)) and (familiar.Y > boss.Position.Y)) and (familiar.Y > enemy.Position.Y))) or (((boss == nil) and (enemy == nil)))) or (((boss == nil) and (familiar.Y > enemy.Position.Y)))) or (((enemy == nil) and (familiar.Y > boss.Position.Y)))))) then
num5=CS.trunc(CS.invoke(Math,"Abs",(vector.Y - familiar.Y)))
local vector3=CS.copy(CS.new("Vector2",FamiliarManager.Instance.LastDamaged.X,FamiliarManager.Instance.LastDamaged.Y))
local flag=CS.invoke(player,"IsPositionInLight",vector3)
local num9=(CS.choose(((flag or familiar.LikeEnemy)),function() return CS.f(1) end,function() return CS.f(0.5) end))
Program.main.game.Score=(Program.main.game.Score + CS.trunc(((CS.f(20) * num9))))
CS.invoke(familiar,"DecreasingHp",((array[CS.trunc(Program.main.game.LanternStatus)] * num9) * Time.Stop),true,true)
if (CS.rem(familiar.DamagedTime,8) == 0) then
local vector4=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItemFromFamliar",flag,(vector3 + vector4))
end
end
selfBarrage.rect.X=(CS.choose(((not Program.main.game.LanternLighting)),function() return 706 end,function() return 834 end))
selfBarrage.rect.Height=(num5 + CS.trunc(sprite2.position.Y))
selfBarrage.origin.Y=CS.f((num5 + CS.trunc(sprite2.position.Y)))
selfBarrage.speed=CS.f(CS.f(0))
selfBarrage.position=CS.copy((vector + sprite2.position))
selfBarrage.additive=(not Program.main.game.LanternLighting)
local num10=CS.f(0.6)
do local __switch23=Program.main.game.LanternStatus
repeat
if __switch23==LanternStatus.OPENING or __switch23==LanternStatus.LOSINGCONTROL or __switch23==LanternStatus.RELEASING then
num10=CS.f(CS.f(0.8))
break
elseif __switch23==LanternStatus.LOSTCONTROL then
num10=CS.f(CS.f(1))
break
end
until true
end
if (player.EquipType == EquipType.B) then
num10=CS.f((num10 * CS.f(0.5)))
end
selfBarrage.scale.X=CS.f((selfBarrage.scale.X + (((num10 - selfBarrage.scale.X)) / CS.f(5))))
local vector5=CS.copy((vector - CS.new("Vector2",CS.f(0),num5)))
if (crazyStorm3 == nil) then
crazyStorm3=CS.invoke(Program.main.game,"PlayEffect",true,CS.choose(((not Program.main.game.LanternLighting)),function() return "30" end,function() return "49" end),vector5)
crazyStorm3.order=CrazyStorm.Order.UnderActorEquip
crazyStorm3.indestructible=true
crazyStorm3.specialnotkill=true
CS.invoke(crazyStorm3,"BanSound",true)
CS.invoke(crazyStorm3,"SetOPos",vector5)
else
if ((crazyStorm3 ~= nil) and (((((crazyStorm3.Id == "e30") and Program.main.game.LanternLighting)) or (((crazyStorm3.Id == "e49") and (not Program.main.game.LanternLighting)))))) then
CS.invoke(crazyStorm3,"Break")
crazyStorm3=nil
else
if (crazyStorm3 ~= nil) then
crazyStorm3.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm3,"SetPos",vector5,true)
end
end
end
if ((crazyStorm3 ~= nil) and Ban) then
CS.invoke(crazyStorm3,"Break")
crazyStorm3=nil
end
end
if ((not Ban) and Character.IsPlayerShoot) then
local r=CS.copy(CS.new("Rectangle",706,0,128,0))
local o=CS.copy(CS.new("Vector2",CS.f(64),CS.f(0)))
local alpha_f=CS.f(1)
local scale_v=CS.copy(CS.new("Vector2",CS.f(0.6),CS.f(1)))
if ((selfBarrage == nil) or selfBarrage.needDelete) then
selfBarrage=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r,o,(vector + sprite2.position),CS.f(0),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(0.001))
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(30)))
selfBarrage.order=SelfBarrage.Order.Underneath
selfBarrage.straight=true
selfBarrage.ignoreDamage=true
end
else
if (selfBarrage ~= nil) then
selfBarrage.needDelete=true
selfBarrage=nil
end
if (crazyStorm3 ~= nil) then
CS.invoke(crazyStorm3,"Break")
crazyStorm3=nil
end
end
self.cs["hitflare"]=crazyStorm3
self.sb["lazer"]=selfBarrage
CS.invoke(self.ec,"Clear")
CS.invoke(self.fc,"Clear")
local other=player.damageSet.B.other2
do
local num11=0
while (num11 < 4) do
local __break24,__continue24=false,false
repeat
if (player.EquipType ~= EquipType.B) then
__break24=true;break
end
self.csRefs[num11]=(CS.choose(CS.invoke(self.cs,"ContainsKey",("hitflare"..tostring((num11 + 1)))),function() return self.cs[("hitflare"..tostring((num11 + 1)))] end,function() return nil end))
self.sbRefs[num11]=(CS.choose(CS.invoke(self.sb,"ContainsKey",("lazer"..tostring((num11 + 1)))),function() return self.sb[("lazer"..tostring((num11 + 1)))] end,function() return nil end))
num5=1024
local sprite6=self.sprites[(num11 + 3)]
if (self.sbRefs[num11] ~= nil) then
local boss3=nil
if (bossStage ~= nil) then
do
local num12=0
while (num12 < bossStage.Bosses.Count) do
local __break25,__continue25=false,false
repeat
local boss4=bossStage.Bosses[num12]
if CS.invoke(boss4,"JudgeRay",sprite6.position,dir,CS.new("Vector2",CS.f(0),CS.f(0))) then
local num13=CS.trunc(CS.invoke(Math,"Abs",(sprite6.position.Y - boss4.Position.Y)))
if (num13 < num5) then
num5=num13
boss3=boss4
end
end
until true
if __break25 then break end
num12=num12+1
end
end
end
local enemy2=CS.invoke(em,"JudgeRay",sprite6.position,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
local familiar2=CS.invoke(FamiliarManager.Instance,"JudgeRay",sprite6.position,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
if ((boss3 ~= nil) and (((((((((enemy2 ~= nil) and (familiar2 ~= nil)) and (boss3.Position.Y > enemy2.Position.Y)) and (boss3.Position.Y > familiar2.Y))) or (((enemy2 == nil) and (familiar2 == nil)))) or (((familiar2 == nil) and (boss3.Position.Y > enemy2.Position.Y)))) or (((enemy2 == nil) and (boss3.Position.Y > familiar2.Y)))))) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(boss3,"DecreasingHp",(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop),true,false)
end
if ((enemy2 ~= nil) and (((((((((boss3 ~= nil) and (familiar2 ~= nil)) and (enemy2.Position.Y > boss3.Position.Y)) and (enemy2.Position.Y > familiar2.Y))) or (((boss3 == nil) and (familiar2 == nil)))) or (((familiar2 == nil) and (enemy2.Position.Y > boss3.Position.Y)))) or (((boss3 == nil) and (enemy2.Position.Y > familiar2.Y)))))) then
num5=(CS.choose(((Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)),function() return (CS.trunc(CS.invoke(Math,"Abs",(sprite6.position.Y - enemy2.Position.Y)))) end,function() return num5 end))
local damage=(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop)
local power=Equipment.CalculateLimitDamage(self,self.ec,enemy2,damage,other)
CS.invoke(enemy2,"DecreasingHp",power,true,false)
if (CS.rem(enemy2.DamagedTime,8) == 0) then
local vector6=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItem",false,(enemy2.Position + vector6),false)
end
Program.main.game.Score=(Program.main.game.Score + 10)
end
if ((familiar2 ~= nil) and (((((((((boss3 ~= nil) and (enemy2 ~= nil)) and (familiar2.Y > boss3.Position.Y)) and (familiar2.Y > enemy2.Position.Y))) or (((boss3 == nil) and (enemy2 == nil)))) or (((boss3 == nil) and (familiar2.Y > enemy2.Position.Y)))) or (((enemy2 == nil) and (familiar2.Y > boss3.Position.Y)))))) then
num5=(CS.choose(((Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)),function() return (CS.trunc(CS.invoke(Math,"Abs",(sprite6.position.Y - familiar2.Y)))) end,function() return num5 end))
local vector7=CS.copy(CS.new("Vector2",FamiliarManager.Instance.LastDamaged.X,FamiliarManager.Instance.LastDamaged.Y))
local flag2=CS.invoke(player,"IsPositionInLight",vector7)
local num14=(CS.choose(((flag2 or familiar2.LikeEnemy)),function() return CS.f(1) end,function() return CS.f(0.5) end))
Program.main.game.Score=(Program.main.game.Score + CS.trunc(((CS.f(20) * num14))))
local damage2=((array[CS.trunc(Program.main.game.LanternStatus)] * num14) * Time.Stop)
local num15=Equipment.CalculateLimitDamage(self,self.fc,familiar2,damage2,other)
local flag3=CS.is(familiar2.Master,"Enemy")
CS.invoke(familiar2,"DecreasingHp",num15,true,(not flag3))
if (flag3 and (not familiar2.Independent)) then
local power2=Equipment.CalculateLimitDamage(self,self.ec,CS.as(familiar2.Master,"Enemy"),(num15 * CS.f(0.5)),other)
CS.invoke(familiar2.Master,"DecreasingHp",power2,true,true)
end
if (CS.rem(familiar2.DamagedTime,8) == 0) then
local vector8=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItemFromFamliar",flag2,(vector7 + vector8))
end
end
self.sbRefs[num11].rect.X=(CS.choose(((not Program.main.game.LanternLighting)),function() return 706 end,function() return 834 end))
self.sbRefs[num11].rect.Height=num5
self.sbRefs[num11].origin.Y=CS.f(num5)
self.sbRefs[num11].speed=CS.f(0)
self.sbRefs[num11].position=CS.copy(sprite6.position)
self.sbRefs[num11].additive=(not Program.main.game.LanternLighting)
local num16=CS.f(0.1)
do local __switch26=Program.main.game.LanternStatus
repeat
if __switch26==LanternStatus.OPENING or __switch26==LanternStatus.LOSINGCONTROL or __switch26==LanternStatus.RELEASING then
num16=CS.f(CS.f(0.15))
break
elseif __switch26==LanternStatus.LOSTCONTROL then
num16=CS.f(CS.f(0.2))
break
end
until true
end
if __continue24 then break end
self.sbRefs[num11].scale.X=CS.f((self.sbRefs[num11].scale.X + (((num16 - self.sbRefs[num11].scale.X)) / CS.f(5))))
local vector9=CS.copy((sprite6.position - CS.new("Vector2",CS.f(0),num5)))
if (self.csRefs[num11] == nil) then
self.csRefs[num11]=CS.invoke(Program.main.game,"PlayEffect",true,CS.choose(((not Program.main.game.LanternLighting)),function() return "30" end,function() return "49" end),vector9)
self.csRefs[num11].Status=1
self.csRefs[num11].order=CrazyStorm.Order.UnderActorEquip
self.csRefs[num11].indestructible=true
self.csRefs[num11].specialnotkill=true
CS.invoke(self.csRefs[num11],"BanSound",true)
CS.invoke(self.csRefs[num11],"SetOPos",vector9)
else
if ((self.csRefs[num11] ~= nil) and (((((self.csRefs[num11].Id == "e30") and Program.main.game.LanternLighting)) or (((self.csRefs[num11].Id == "e49") and (not Program.main.game.LanternLighting)))))) then
CS.invoke(self.csRefs[num11],"Break")
self.csRefs[num11]=nil
else
if (self.csRefs[num11] ~= nil) then
self.csRefs[num11].alpha=Character.SelfPowerAlpha
CS.invoke(self.csRefs[num11],"SetPos",vector9,true)
end
end
end
if ((self.csRefs[num11] ~= nil) and Ban) then
CS.invoke(self.csRefs[num11],"Break")
self.csRefs[num11]=nil
end
end
if ((not Ban) and Character.IsPlayerShoot) then
local r2=CS.copy(CS.new("Rectangle",706,0,128,0))
local o2=CS.copy(CS.new("Vector2",CS.f(64),CS.f(0)))
local alpha_f2=CS.f(1)
local scale_v2=CS.copy(CS.new("Vector2",CS.f(0.6),CS.f(1)))
if ((self.sbRefs[num11] == nil) or self.sbRefs[num11].needDelete) then
self.sbRefs[num11]=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r2,o2,(vector + sprite2.position),CS.f(0),alpha_f2,scale_v2)
self.sbRefs[num11].speed=CS.f(0.001)
self.sbRefs[num11].speedd=(-CS.f(90))
self.sbRefs[num11].uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(30)))
self.sbRefs[num11].order=SelfBarrage.Order.Underneath
self.sbRefs[num11].straight=true
self.sbRefs[num11].ignoreDamage=true
end
else
if (self.sbRefs[num11] ~= nil) then
self.sbRefs[num11].needDelete=true
self.sbRefs[num11]=nil
end
if (self.csRefs[num11] ~= nil) then
CS.invoke(self.csRefs[num11],"Break")
self.csRefs[num11]=nil
end
end
self.cs[("hitflare"..tostring((num11 + 1)))]=self.csRefs[num11]
self.sb[("lazer"..tostring((num11 + 1)))]=self.sbRefs[num11]
until true
if __break24 then break end
num11=num11+1
end
end
do
local num17=8
while (num17 < 24) do
local __break27,__continue27=false,false
repeat
if (player.EquipType ~= EquipType.B) then
__break27=true;break
end
self.sbRefs[num17]=(CS.choose(CS.invoke(self.sb,"ContainsKey",("lazer"..tostring((num17 - 3)))),function() return self.sb[("lazer"..tostring((num17 - 3)))] end,function() return nil end))
num5=1024
local sprite7=self.sprites[(num17 - 4)]
if (self.sbRefs[num17] ~= nil) then
local num18=CS.f(0)
if ((self.childrenTime[(num17 - 8)] >= 60) and (self.childrenTime[(num17 - 8)] < 90)) then
num18=CS.f(CS.f(0.05))
else
if (self.childrenTime[(num17 - 8)] == 90) then
num18=CS.f(CS.f(0.3))
self.sbRefs[num17].scale.X=CS.f(num18)
end
end
self.sbRefs[num17].scale.X=CS.f((self.sbRefs[num17].scale.X + (((num18 - self.sbRefs[num17].scale.X)) / CS.f(5))))
if (num18 > CS.f(0)) then
local boss5=nil
if (bossStage ~= nil) then
do
local num19=0
while (num19 < bossStage.Bosses.Count) do
local __break28,__continue28=false,false
repeat
local boss6=bossStage.Bosses[num19]
if CS.invoke(boss6,"JudgeRay",sprite7.position,dir,CS.new("Vector2",CS.f(0),CS.f(0))) then
local num20=(CS.choose(((Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)),function() return (CS.trunc(CS.invoke(Math,"Abs",(sprite7.position.Y - boss6.Position.Y)))) end,function() return num5 end))
if (num20 < num5) then
num5=num20
boss5=boss6
end
end
until true
if __break28 then break end
num19=num19+1
end
end
end
local enemy3=CS.invoke(em,"JudgeRay",sprite7.position,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
local familiar3=CS.invoke(FamiliarManager.Instance,"JudgeRay",sprite7.position,dir,CS.new("Vector2",CS.f(0),CS.f(0)))
if ((boss5 ~= nil) and (((((((((enemy3 ~= nil) and (familiar3 ~= nil)) and (boss5.Position.Y > enemy3.Position.Y)) and (boss5.Position.Y > familiar3.Y))) or (((enemy3 == nil) and (familiar3 == nil)))) or (((familiar3 == nil) and (boss5.Position.Y > enemy3.Position.Y)))) or (((enemy3 == nil) and (boss5.Position.Y > familiar3.Y)))))) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(boss5,"DecreasingHp",(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop),true,false)
end
if ((enemy3 ~= nil) and (((((((((boss5 ~= nil) and (familiar3 ~= nil)) and (enemy3.Position.Y > boss5.Position.Y)) and (enemy3.Position.Y > familiar3.Y))) or (((boss5 == nil) and (familiar3 == nil)))) or (((familiar3 == nil) and (enemy3.Position.Y > boss5.Position.Y)))) or (((boss5 == nil) and (enemy3.Position.Y > familiar3.Y)))))) then
num5=(CS.choose(((Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)),function() return (CS.trunc(CS.invoke(Math,"Abs",(sprite7.position.Y - enemy3.Position.Y)))) end,function() return num5 end))
local damage3=(array[CS.trunc(Program.main.game.LanternStatus)] * Time.Stop)
local power3=Equipment.CalculateLimitDamage(self,self.ec,enemy3,damage3,other)
CS.invoke(enemy3,"DecreasingHp",power3,true,false)
if (CS.rem(enemy3.DamagedTime,8) == 0) then
local vector10=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItem",false,(enemy3.Position + vector10),false)
end
Program.main.game.Score=(Program.main.game.Score + 10)
end
if ((familiar3 ~= nil) and (((((((((boss5 ~= nil) and (enemy3 ~= nil)) and (familiar3.Y > boss5.Position.Y)) and (familiar3.Y > enemy3.Position.Y))) or (((boss5 == nil) and (enemy3 == nil)))) or (((boss5 == nil) and (familiar3.Y > enemy3.Position.Y)))) or (((enemy3 == nil) and (familiar3.Y > boss5.Position.Y)))))) then
num5=(CS.choose(((Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)),function() return (CS.trunc(CS.invoke(Math,"Abs",(sprite7.position.Y - familiar3.Y)))) end,function() return num5 end))
local vector11=CS.copy(CS.new("Vector2",FamiliarManager.Instance.LastDamaged.X,FamiliarManager.Instance.LastDamaged.Y))
local flag4=CS.invoke(player,"IsPositionInLight",vector11)
local num21=(CS.choose(((flag4 or familiar3.LikeEnemy)),function() return CS.f(1) end,function() return CS.f(0.5) end))
Program.main.game.Score=(Program.main.game.Score + CS.trunc(((CS.f(20) * num21))))
local damage4=((array[CS.trunc(Program.main.game.LanternStatus)] * num21) * Time.Stop)
local num22=Equipment.CalculateLimitDamage(self,self.fc,familiar3,damage4,other)
local flag5=CS.is(familiar3.Master,"Enemy")
CS.invoke(familiar3,"DecreasingHp",num22,true,(not flag5))
if (flag5 and (not familiar3.Independent)) then
local power4=Equipment.CalculateLimitDamage(self,self.ec,CS.as(familiar3.Master,"Enemy"),(num22 * CS.f(0.5)),other)
CS.invoke(familiar3.Master,"DecreasingHp",power4,true,true)
end
if (CS.rem(familiar3.DamagedTime,8) == 0) then
local vector12=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItemFromFamliar",flag4,(vector11 + vector12))
end
end
end
self.sbRefs[num17].rect.X=(CS.choose(((not Program.main.game.LanternLighting)),function() return 706 end,function() return 834 end))
self.sbRefs[num17].rect.Height=num5
self.sbRefs[num17].origin.Y=CS.f(num5)
self.sbRefs[num17].speed=CS.f(0)
self.sbRefs[num17].position=CS.copy(sprite7.position)
self.sbRefs[num17].additive=(not Program.main.game.LanternLighting)
end
if (self.childrenTime[(num17 - 8)] > 0) then
local r3=CS.copy(CS.new("Rectangle",706,0,128,0))
local o3=CS.copy(CS.new("Vector2",CS.f(64),CS.f(0)))
local alpha_f3=CS.f(1)
local scale_v3=CS.copy(CS.new("Vector2",CS.f(0),CS.f(1)))
if ((self.sbRefs[num17] == nil) or self.sbRefs[num17].needDelete) then
self.sbRefs[num17]=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r3,o3,(vector + sprite2.position),CS.f(0),alpha_f3,scale_v3)
self.sbRefs[num17].speed=CS.f(0.001)
self.sbRefs[num17].speedd=(-CS.f(90))
self.sbRefs[num17].uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(30)))
self.sbRefs[num17].order=SelfBarrage.Order.Underneath
self.sbRefs[num17].straight=true
self.sbRefs[num17].ignoreDamage=true
end
else
if (self.sbRefs[num17] ~= nil) then
self.sbRefs[num17].needDelete=true
self.sbRefs[num17]=nil
end
end
self.sb[("lazer"..tostring((num17 - 3)))]=self.sbRefs[num17]
until true
if __break27 then break end
num17=num17+1
end
end
local lanternStatus=Program.main.game.LanternStatus
local flag6=((not Ban) and (((lanternStatus == LanternStatus.LOSINGCONTROL) or (lanternStatus == LanternStatus.LOSTCONTROL))))
local flag7=(((player.EquipType == EquipType.A) and (not Ban)) and (lanternStatus == LanternStatus.LOSTCONTROL))
local selfBarrage2=(CS.choose(CS.invoke(self.sb,"ContainsKey","flashl"),function() return self.sb["flashl"] end,function() return nil end))
local selfBarrage3=(CS.choose(CS.invoke(self.sb,"ContainsKey","flashll"),function() return self.sb["flashll"] end,function() return nil end))
local selfBarrage4=(CS.choose(CS.invoke(self.sb,"ContainsKey","flashr"),function() return self.sb["flashr"] end,function() return nil end))
local selfBarrage5=(CS.choose(CS.invoke(self.sb,"ContainsKey","flashrr"),function() return self.sb["flashrr"] end,function() return nil end))
local vector13=CS.copy(CS.new("Vector2",(-CS.f(40)),CS.f(0)))
local vector14=CS.copy(CS.new("Vector2",CS.f(40),CS.f(0)))
if (selfBarrage2 ~= nil) then
selfBarrage2.rect.X=346
selfBarrage2.rect.Height=(num5 + CS.trunc(sprite2.position.Y))
selfBarrage2.origin.Y=CS.f((num5 + CS.trunc(sprite2.position.Y)))
selfBarrage2.speed=CS.f(CS.f(0))
selfBarrage2.rotation=CS.f((CS.choose(flag7,function() return ((-110)) end,function() return ((-90)) end)))
selfBarrage2.position=CS.copy(((vector + sprite2.position) + vector13))
selfBarrage2.additive=false
if (not flag6) then
selfBarrage2.needDelete=true
selfBarrage2=nil
end
selfBarrage4.rect.X=346
selfBarrage4.rect.Height=(num5 + CS.trunc(sprite2.position.Y))
selfBarrage4.origin.Y=CS.f((num5 + CS.trunc(sprite2.position.Y)))
selfBarrage4.speed=CS.f(CS.f(0))
selfBarrage4.rotation=CS.f((CS.choose(flag7,function() return ((-70)) end,function() return ((-90)) end)))
selfBarrage4.position=CS.copy(((vector + sprite2.position) + vector14))
selfBarrage4.additive=false
if (not flag6) then
selfBarrage4.needDelete=true
selfBarrage4=nil
end
end
if (selfBarrage3 ~= nil) then
selfBarrage3.rect.Height=(num5 + CS.trunc(sprite2.position.Y))
selfBarrage3.origin.Y=CS.f((num5 + CS.trunc(sprite2.position.Y)))
selfBarrage3.speed=CS.f(CS.f(0))
selfBarrage3.position=CS.copy(((vector + sprite2.position) + vector13))
if (not flag7) then
selfBarrage3.needDelete=true
selfBarrage3=nil
end
selfBarrage5.rect.Height=(num5 + CS.trunc(sprite2.position.Y))
selfBarrage5.origin.Y=CS.f((num5 + CS.trunc(sprite2.position.Y)))
selfBarrage5.speed=CS.f(CS.f(0))
selfBarrage5.position=CS.copy(((vector + sprite2.position) + vector14))
if (not flag7) then
selfBarrage5.needDelete=true
selfBarrage5=nil
end
end
if Character.IsPlayerShoot then
local r4=CS.copy(CS.new("Rectangle",0,0,138,0))
local o4=CS.copy(CS.new("Vector2",CS.f(69),CS.f(0)))
local alpha_f4=CS.f(0.8)
local scale_v4=CS.copy(CS.new("Vector2",CS.f(0.6),CS.f(1)))
if ((CS.coalesce(CS.optional(selfBarrage2,"needDelete"),function() return true end)) and flag6) then
selfBarrage2=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r4,o4,((vector + sprite2.position) + vector13),CS.f(0),alpha_f4,scale_v4)
selfBarrage2.speed=CS.f(CS.f(0.001))
selfBarrage2.fixRotation=true
selfBarrage2.rotation=CS.f((CS.choose(flag7,function() return ((-110)) end,function() return ((-90)) end)))
selfBarrage2.uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(7)))
selfBarrage2.order=SelfBarrage.Order.Underneath
selfBarrage2.straight=true
selfBarrage2.ignoreDamage=true
selfBarrage4=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r4,o4,((vector + sprite2.position) + vector13),CS.f(0),alpha_f4,scale_v4)
selfBarrage4.speed=CS.f(CS.f(0.001))
selfBarrage4.fixRotation=true
selfBarrage4.rotation=CS.f((CS.choose(flag7,function() return ((-70)) end,function() return ((-90)) end)))
selfBarrage4.uv=CS.copy(CS.new("Vector2",CS.f(0),CS.f(500)))
selfBarrage4.uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(7)))
selfBarrage4.order=SelfBarrage.Order.Underneath
selfBarrage4.straight=true
selfBarrage4.ignoreDamage=true
selfBarrage4.effect=SpriteEffects.FlipHorizontally
end
local r5=CS.copy(CS.new("Rectangle",491,0,215,0))
local o5=CS.copy(CS.new("Vector2",CS.f(108),CS.f(0)))
if ((CS.coalesce(CS.optional(selfBarrage3,"needDelete"),function() return true end)) and flag7) then
selfBarrage3=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r5,o5,((vector + sprite2.position) + vector13),CS.f(0),alpha_f4,scale_v4)
selfBarrage3.speed=CS.f(CS.f(0.001))
selfBarrage3.fixRotation=true
selfBarrage3.rotation=CS.f((-CS.f(135)))
selfBarrage3.uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(14)))
selfBarrage3.order=SelfBarrage.Order.Underneath
selfBarrage3.straight=true
selfBarrage3.ignoreDamage=true
selfBarrage3.additive=false
selfBarrage5=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r5,o5,((vector + sprite2.position) + vector13),CS.f(0),alpha_f4,scale_v4)
selfBarrage5.speed=CS.f(CS.f(0.001))
selfBarrage5.fixRotation=true
selfBarrage5.rotation=CS.f((-CS.f(45)))
selfBarrage5.uv=CS.copy(CS.new("Vector2",CS.f(0),CS.f(500)))
selfBarrage5.uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(14)))
selfBarrage5.order=SelfBarrage.Order.Underneath
selfBarrage5.straight=true
selfBarrage5.ignoreDamage=true
selfBarrage5.additive=false
selfBarrage5.effect=SpriteEffects.FlipHorizontally
end
end
if (not Character.IsPlayerShoot) then
if (selfBarrage2 ~= nil) then
selfBarrage2.needDelete=true
selfBarrage2=nil
end
if (selfBarrage4 ~= nil) then
selfBarrage4.needDelete=true
selfBarrage4=nil
end
if (selfBarrage3 ~= nil) then
selfBarrage3.needDelete=true
selfBarrage3=nil
end
if (selfBarrage5 ~= nil) then
selfBarrage5.needDelete=true
selfBarrage5=nil
end
end
self.sb["flashl"]=selfBarrage2
self.sb["flashll"]=selfBarrage3
self.sb["flashr"]=selfBarrage4
self.sb["flashrr"]=selfBarrage5
do
local num23=4
while (num23 < 8) do
local __break29,__continue29=false,false
repeat
if (player.EquipType ~= EquipType.B) then
__break29=true;break
end
local sprite8=self.sprites[(num23 - 1)]
self.sbRefs[num23]=(CS.choose(CS.invoke(self.sb,"ContainsKey",("flash"..tostring((num23 - 3)))),function() return self.sb[("flash"..tostring((num23 - 3)))] end,function() return nil end))
if (self.sbRefs[num23] ~= nil) then
self.sbRefs[num23].rect.X=346
self.sbRefs[num23].rect.Height=num5
self.sbRefs[num23].origin.Y=CS.f(num5)
self.sbRefs[num23].speed=CS.f(0)
self.sbRefs[num23].rotation=(-CS.f(90))
self.sbRefs[num23].position=CS.copy(sprite8.position)
self.sbRefs[num23].additive=false
if (not flag6) then
self.sbRefs[num23].needDelete=true
self.sbRefs[num23]=nil
end
end
if Character.IsPlayerShoot then
local r6=CS.copy(CS.new("Rectangle",0,0,138,0))
local o6=CS.copy(CS.new("Vector2",CS.f(69),CS.f(0)))
local alpha_f5=CS.f(0.8)
local scale_v5=CS.copy(CS.new("Vector2",CS.f(0.3),CS.f(1)))
if ((((self.sbRefs[num23] == nil) or self.sbRefs[num23].needDelete)) and flag6) then
self.sbRefs[num23]=CS.invoke(SelfBarrageManager,"Get",self.tex[1],r6,o6,sprite8.position,CS.f(0),alpha_f5,scale_v5)
self.sbRefs[num23].speed=CS.f(0.001)
self.sbRefs[num23].fixRotation=true
self.sbRefs[num23].rotation=(-CS.f(90))
self.sbRefs[num23].uv=CS.copy(CS.new("Vector2",CS.f(0),(250 * ((num23 - 4)))))
self.sbRefs[num23].uvSpeed=CS.copy(CS.new("Vector2",CS.f(0),CS.f(7)))
self.sbRefs[num23].order=SelfBarrage.Order.Underneath
self.sbRefs[num23].straight=true
self.sbRefs[num23].ignoreDamage=true
end
end
if ((not Character.IsPlayerShoot) and (self.sbRefs[num23] ~= nil)) then
self.sbRefs[num23].needDelete=true
self.sbRefs[num23]=nil
end
self.sb[("flash"..tostring((num23 - 3)))]=self.sbRefs[num23]
until true
if __break29 then break end
num23=num23+1
end
end
local crazyStorm4=(CS.choose(CS.invoke(self.cs,"ContainsKey","outflare"),function() return self.cs["outflare"] end,function() return nil end))
if ((not Ban) and Character.IsPlayerShoot) then
if (crazyStorm4 == nil) then
crazyStorm4=CS.invoke(Program.main.game,"PlayEffect",true,CS.choose(((not Program.main.game.LanternLighting)),function() return "30" end,function() return "49" end),(vector + sprite2.position))
crazyStorm4.order=CrazyStorm.Order.Underneath
crazyStorm4.specialnotkill=true
CS.invoke(crazyStorm4,"BanSound",true)
CS.invoke(crazyStorm4,"SetOPos",(vector + sprite2.position))
else
if ((crazyStorm4 ~= nil) and (((((crazyStorm4.Id == "e30") and Program.main.game.LanternLighting)) or (((crazyStorm4.Id == "e49") and (not Program.main.game.LanternLighting)))))) then
CS.invoke(crazyStorm4,"Break")
crazyStorm4=nil
end
end
end
if (crazyStorm4 ~= nil) then
crazyStorm4.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm4,"SetPos",(vector + sprite2.position),true)
end
if (((Ban or (not Character.IsPlayerShoot))) and (crazyStorm4 ~= nil)) then
CS.invoke(crazyStorm4,"Break")
crazyStorm4=nil
end
self.cs["outflare"]=crazyStorm4
do
local num24=4
while (num24 < 8) do
local __break30,__continue30=false,false
repeat
if (player.EquipType ~= EquipType.B) then
__break30=true;break
end
self.csRefs[num24]=(CS.choose(CS.invoke(self.cs,"ContainsKey",("outflare"..tostring((num24 + 1)))),function() return self.cs[("outflare"..tostring((num24 + 1)))] end,function() return nil end))
local vector15=CS.copy((self.sprites[(num24 - 1)].position + CS.new("Vector2",CS.f(0),(-CS.f(16)))))
if ((not Ban) and Character.IsPlayerShoot) then
if (self.csRefs[num24] == nil) then
self.csRefs[num24]=CS.invoke(Program.main.game,"PlayEffect",true,CS.choose(((not Program.main.game.LanternLighting)),function() return "30" end,function() return "49" end),vector15)
self.csRefs[num24].Status=1
self.csRefs[num24].order=CrazyStorm.Order.Underneath
self.csRefs[num24].specialnotkill=true
CS.invoke(self.csRefs[num24],"BanSound",true)
CS.invoke(self.csRefs[num24],"SetOPos",vector15)
else
if ((self.csRefs[num24] ~= nil) and (((((self.csRefs[num24].Id == "e30") and Program.main.game.LanternLighting)) or (((self.csRefs[num24].Id == "e49") and (not Program.main.game.LanternLighting)))))) then
CS.invoke(self.csRefs[num24],"Break")
self.csRefs[num24]=nil
end
end
end
if (self.csRefs[num24] ~= nil) then
self.csRefs[num24].alpha=Character.SelfPowerAlpha
CS.invoke(self.csRefs[num24],"SetPos",vector15,true)
end
if (((Ban or (not Character.IsPlayerShoot))) and (self.csRefs[num24] ~= nil)) then
CS.invoke(self.csRefs[num24],"Break")
self.csRefs[num24]=nil
end
self.cs[("outflare"..tostring((num24 + 1)))]=self.csRefs[num24]
until true
if __break30 then break end
num24=num24+1
end
end
end
function Equipment:S_BOMB(game,bossStage,em,player,Ban)

local characterPart=nil
local sprite=nil
local sprite2=nil
local sprite3=nil
local sprite4=nil
if (not self.inited) then
self.inited=true
characterPart=player.configSet.parts["坐骑"]
sprite=characterPart.anims[CharacterState.Shift].sprite
sprite2=characterPart.anims[CharacterState.ShiftOld].sprite
local clip=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Henshin",["interval"]=7,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0})})
CS.invoke(sprite,"AddClip",clip)
CS.invoke(sprite2,"AddClip",clip)
local clip2=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Riding",["interval"]=7,["frames"]=CS.List({[0]=6,[1]=0})})
CS.invoke(sprite,"AddClip",clip2)
CS.invoke(sprite2,"AddClip",clip2)
local clip3=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Modoru",["interval"]=7,["frames"]=CS.List({[0]=5,[1]=0,[2]=4,[3]=0,[4]=3,[5]=0,[6]=2,[7]=0,[8]=1,[9]=0,[10]=0,[11]=0})})
CS.invoke(sprite,"AddClip",clip3)
CS.invoke(sprite,"Connect","Henshin","Riding")
CS.invoke(sprite,"Connect","Modoru","Default")
CS.invoke(sprite2,"AddClip",clip3)
CS.invoke(sprite2,"Connect","Henshin","Riding")
CS.invoke(sprite2,"Connect","Modoru","Default")
Equipment.MAGIC_FIELD_Init(self,self.tex[2],0,582)
local animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Idle",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0})})
sprite3=CS.new("Sprite",self.tex[2],CS.new("Rectangle",512,200,100,100))
sprite3.label=3
sprite3.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite3.position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(5)))
sprite3.scale=CS.copy(Vector2.Zero)
sprite3.color.a=CS.f(1)
CS.invoke(sprite3,"AddClip",animationClip)
CS.invoke(sprite3,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite3)
sprite4=CS.new("Sprite",self.tex[2],CS.new("Rectangle",512,100,100,100))
sprite4.label=3
sprite4.origin=CS.copy(CS.new("Vector2",CS.f(50),CS.f(50)))
sprite4.position=CS.copy(CS.new("Vector2",CS.f(35),(-CS.f(20))))
sprite4.scale=CS.copy(Vector2.Zero)
sprite4.color.a=CS.f(1)
CS.invoke(sprite4,"AddClip",animationClip)
CS.invoke(sprite4,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite4)
end
characterPart=player.configSet.parts["坐骑"]
sprite=characterPart.anims[CharacterState.Shift].sprite
sprite2=characterPart.anims[CharacterState.ShiftOld].sprite
Equipment.MAGIC_FIELD(self,self.sprites[1],self.sprites[2],Ban)
Equipment.GUARD_SHEILD(self,"19",self.playerPos,Ban)
if self.HideLantern then
do return  end
end
local sprite5=self.sprites[0]
sprite3=self.sprites[3]
sprite4=self.sprites[4]
if (self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) then
do local __switch31=Program.main.game.LanternStatus
repeat
if __switch31==LanternStatus.OPENING then
if ((player.state >= CharacterState.Idle1) and (player.state < CharacterState.IdleOld1)) then
player.state=CharacterState.Shift
CS.invoke(sprite,"Play","Henshin")
else
if ((player.state >= CharacterState.IdleOld1) and (player.state < CharacterState.Shift)) then
player.state=CharacterState.ShiftOld
CS.invoke(sprite2,"Play","Henshin")
end
end
sprite3.color.a=((function() sprite4.color.a=CS.f(0);return sprite4.color.a end)())
break
elseif __switch31==LanternStatus.BREAKCLOSING or __switch31==LanternStatus.OVERCLOSING then
if ((player.state >= CharacterState.Idle1) and (player.state < CharacterState.IdleOld1)) then
player.state=CharacterState.Shift
CS.invoke(sprite,"Play","Modoru")
else
if ((player.state >= CharacterState.IdleOld1) and (player.state < CharacterState.Shift)) then
player.state=CharacterState.ShiftOld
CS.invoke(sprite2,"Play","Modoru")
end
end
sprite3.position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(5)))
sprite4.position=CS.copy(CS.new("Vector2",CS.f(35),(-CS.f(20))))
break
end
until true
end
end
local currentClip=CS.invoke(sprite,"GetCurrentClip")
if (currentClip ~= nil) then
if ((player.state == CharacterState.Shift) and (((((currentClip.name == "Henshin") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Riding")))) then
player.state=CharacterState.Idle2
else
if ((player.state == CharacterState.Shift) and (((((currentClip.name == "Modoru") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Default")))) then
player.state=CharacterState.Idle1
sprite3.color.a=((function() sprite4.color.a=CS.f(1);return sprite4.color.a end)())
end
end
end
currentClip=CS.invoke(sprite2,"GetCurrentClip")
if (currentClip ~= nil) then
if ((player.state == CharacterState.ShiftOld) and (((((currentClip.name == "Henshin") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Riding")))) then
player.state=CharacterState.IdleOld2
else
if ((player.state == CharacterState.ShiftOld) and (((((currentClip.name == "Modoru") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Default")))) then
player.state=CharacterState.IdleOld1
sprite3.color.a=((function() sprite4.color.a=CS.f(1);return sprite4.color.a end)())
end
end
end
local t=CS.f(0.8)
CS.invoke(sprite3.scale,"MoveForward",t,(CS.f(5) / Time.Stop))
CS.invoke(sprite4.scale,"MoveForward",t,(CS.f(5) / Time.Stop))
if ((not Ban) and CS.invoke(Main,"IsKeyDown",InputKeys.Slow)) then
CS.invoke(sprite3.position,"MoveForward",CS.new("Vector2",(-CS.f(20)),CS.f(10)),(CS.f(3) / Time.Stop))
CS.invoke(sprite4.position,"MoveForward",CS.new("Vector2",CS.f(25),CS.f(0)),(CS.f(3) / Time.Stop))
else
CS.invoke(sprite3.position,"MoveForward",CS.new("Vector2",(-CS.f(30)),CS.f(5)),(CS.f(3) / Time.Stop))
CS.invoke(sprite4.position,"MoveForward",CS.new("Vector2",CS.f(35),(-CS.f(20))),(CS.f(3) / Time.Stop))
end
if (player.EquipType == EquipType.B) then
local vector=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(160))))
if ((not Ban) and Character.IsPlayerShoot) then
local vector2=CS.copy(CS.invoke(player,"SelectChaseTarget",bossStage,em,true,(CS.invoke(player,"Position") - CS.new("Vector2",CS.f(0),CS.f(200)))))
if (CS.invoke(vector2,"LengthSquared") > CS.f(0)) then
vector=CS.copy((vector2 - CS.invoke(player,"Position")))
end
else
vector=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(80))))
end
local num=(CS.f(10) / Time.Stop)
sprite5.position.X=CS.f((sprite5.position.X + (((vector.X - sprite5.position.X)) / num)))
sprite5.position.Y=CS.f((sprite5.position.Y + (((vector.Y - sprite5.position.Y)) / num)))
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","storm"),function() return self.cs["storm"] end,function() return nil end))
local id="26"
do local __switch32=Program.main.game.LanternStatus
repeat
if __switch32==LanternStatus.OPENING or __switch32==LanternStatus.RELEASING then
id="27"
break
elseif __switch32==LanternStatus.LOSINGCONTROL then
id="28"
break
elseif __switch32==LanternStatus.LOSTCONTROL then
id="29"
break
end
until true
end
if ((not Ban) and Character.IsPlayerShoot) then
local pos=CS.copy((sprite5.position + CS.invoke(player,"Position")))
local vector3=CS.copy((sprite5.position + self.playerChase))
local flag=(bossStage ~= nil)
if (crazyStorm == nil) then
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,id,vector3)
crazyStorm.order=CrazyStorm.Order.UnderActorEquip
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",vector3)
else
crazyStorm.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm,"SetPos",vector3,false)
local num2=CS.f(1)
CS.invoke(self.ec,"Clear")
CS.invoke(self.fc,"Clear")
local other=player.damageSet.B.other4
local num3=player.damageSet.B.skill
do local __switch33=Program.main.game.LanternStatus
repeat
if __switch33==LanternStatus.OPENING or __switch33==LanternStatus.LOSINGCONTROL or __switch33==LanternStatus.RELEASING then
num3=CS.f(player.damageSet.B.other2)
num2=CS.f(CS.f(1.2))
break
elseif __switch33==LanternStatus.LOSTCONTROL then
num3=CS.f(player.damageSet.B.other3)
num2=CS.f(CS.f(1.5))
break
end
until true
end
local extend=(CS.f(100) * num2)
local enemy=CS.invoke(em,"Judge",pos,extend)
if (enemy ~= nil) then
local power=Equipment.CalculateLimitDamage(self,self.ec,enemy,(num3 * Time.Stop),other)
CS.invoke(enemy,"DecreasingHp",power,true,false)
Program.main.game.Score=(Program.main.game.Score + 10)
end
local num4=(CS.choose(flag,function() return ((num3 * CS.f(0.5))) end,function() return num3 end))
local familiar=CS.invoke(FamiliarManager.Instance,"Judge",pos,extend)
if (familiar ~= nil) then
local vector4=CS.copy(CS.new("Vector2",FamiliarManager.Instance.LastDamaged.X,FamiliarManager.Instance.LastDamaged.Y))
local flag2=CS.invoke(player,"IsPositionInLight",vector4)
local num5=(CS.choose(((flag2 or familiar.LikeEnemy)),function() return CS.f(1) end,function() return CS.f(0.5) end))
Program.main.game.Score=(Program.main.game.Score + CS.trunc(((CS.f(20) * num5))))
local num6=Equipment.CalculateLimitDamage(self,self.fc,familiar,((num4 * num5) * Time.Stop),other)
local flag3=CS.is(familiar.Master,"Enemy")
CS.invoke(familiar,"DecreasingHp",num6,true,(not flag3))
if (flag3 and (not familiar.Independent)) then
local power2=Equipment.CalculateLimitDamage(self,self.ec,CS.as(familiar.Master,"Enemy"),(num6 * CS.f(0.5)),other)
CS.invoke(familiar.Master,"DecreasingHp",power2,true,true)
end
if (CS.rem(familiar.DamagedTime,8) == 0) then
local vector5=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItemFromFamliar",flag2,(vector4 + vector5))
end
end
if (bossStage ~= nil) then
do
local i=0
while (i < bossStage.Bosses.Count) do
local __break34,__continue34=false,false
repeat
local boss=bossStage.Bosses[i]
local num7=CS.invoke(boss,"Judge",pos,extend)
if (num7 > CS.f(0)) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(boss,"DecreasingHp",(num3 * Time.Stop),true,false)
__break34=true;break
end
until true
if __break34 then break end
i=i+1
end
end
end
if ((self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) or (self.inBossStage ~= flag)) then
CS.invoke(crazyStorm,"Close")
crazyStorm=nil
end
end
else
if (crazyStorm ~= nil) then
CS.invoke(crazyStorm,"Close")
crazyStorm=nil
end
end
self.cs["storm"]=crazyStorm
end
if (player.EquipType == EquipType.A) then
sprite5.position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(80)))
end
end
function Equipment:EM_BLAST(bossStage,em,csm,player,Ban)

local characterPart=nil
local sprite=nil
local sprite2=nil
local sprite3=nil
if (not self.inited) then
self.inited=true
characterPart=player.configSet.parts["爆发"]
sprite=characterPart.anims[CharacterState.Shift].sprite
local clip=CS.invoke(sprite,"GetClip","Default")
clip.mode=ClipMode.Once
clip.frames=CS.List({[0]=6,[1]=0})
local clip2=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Bakuhatsu",["interval"]=7,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0})})
CS.invoke(sprite,"AddClip",clip2)
local clip3=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Hyper",["interval"]=7,["frames"]=CS.List({[0]=6,[1]=0})})
CS.invoke(sprite,"AddClip",clip3)
local clip4=CS.initialize(CS.new("AnimationClip"),{["mode"]=ClipMode.Once,["name"]="Modoru",["interval"]=7,["frames"]=CS.List({[0]=6,[1]=0})})
CS.invoke(sprite,"AddClip",clip4)
CS.invoke(sprite,"Connect","Bakuhatsu","Hyper")
CS.invoke(sprite,"Connect","Modoru","Default")
Equipment.MAGIC_FIELD_Init(self,self.tex[3],0,582)
sprite2=CS.new("Sprite",self.tex[3],CS.new("Rectangle",500,100,150,150))
sprite2.position=CS.copy(CS.new("Vector2",(-CS.f(45)),(-CS.f(10))))
sprite2.origin=CS.copy(CS.new("Vector2",CS.f(75),CS.f(75)))
sprite2.color.a=CS.f(1)
local animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0})})
CS.invoke(sprite2,"AddClip",animationClip)
CS.invoke(sprite2,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite2)
sprite3=CS.new("Sprite",self.tex[3],CS.new("Rectangle",500,250,150,150))
sprite3.position=CS.copy(CS.new("Vector2",CS.f(45),(-CS.f(10))))
sprite3.origin=CS.copy(CS.new("Vector2",CS.f(75),CS.f(75)))
sprite3.color.a=CS.f(1)
animationClip=CS.initialize(CS.new("AnimationClip"),{["name"]="Burn",["interval"]=5,["frames"]=CS.List({[0]=9,[1]=0,[2]=0,[3]=0,[4]=1,[5]=0,[6]=2,[7]=0,[8]=3,[9]=0,[10]=4,[11]=0,[12]=5,[13]=0,[14]=6,[15]=0,[16]=7,[17]=0,[18]=8,[19]=0})})
CS.invoke(sprite3,"AddClip",animationClip)
CS.invoke(sprite3,"Play",animationClip.name)
CS.invoke(self.sprites,"Add",sprite3)
end
characterPart=player.configSet.parts["爆发"]
sprite=characterPart.anims[CharacterState.Shift].sprite
if (self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) then
do local __switch35=Program.main.game.LanternStatus
repeat
if __switch35==LanternStatus.OPENING then
player.state=CharacterState.Shift
CS.invoke(sprite,"Play","Bakuhatsu")
CS.invoke(Program.main.game,"PlaySound","flameburst",true,self.playerPos.X)
break
elseif __switch35==LanternStatus.BREAKCLOSING or __switch35==LanternStatus.OVERCLOSING then
player.state=CharacterState.Shift
CS.invoke(sprite,"Play","Modoru")
break
end
until true
end
end
local currentClip=CS.invoke(sprite,"GetCurrentClip")
if (currentClip ~= nil) then
if ((player.state == CharacterState.Shift) and (((((currentClip.name == "Bakuhatsu") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Hyper")))) then
player.state=CharacterState.Idle2
else
if ((player.state == CharacterState.Shift) and (((((currentClip.name == "Modoru") and (currentClip.CurrentFrame == (CS.idiv(currentClip.frames.Count,2) - 1)))) or (currentClip.name == "Default")))) then
player.state=CharacterState.Idle1
end
end
end
local sprite4=self.sprites[0]
sprite2=self.sprites[3]
sprite3=self.sprites[4]
sprite2.color.a=((function() sprite3.color.a=(sprite4.scale.X * CS.f(2));return sprite3.color.a end)())
sprite2.scale.X=CS.f((CS.f(1) + (self.TurnFactor * CS.f(0.2))))
sprite3.scale.X=CS.f((CS.f(1) - (self.TurnFactor * CS.f(0.2))))
Equipment.MAGIC_FIELD(self,self.sprites[1],self.sprites[2],Ban)
Equipment.GUARD_SHEILD(self,"20",self.playerPos,Ban)
if self.HideLantern then
do return  end
end
local crazyStorm=(CS.choose(CS.invoke(self.cs,"ContainsKey","fire"),function() return self.cs["fire"] end,function() return nil end))
local id=(CS.choose(Program.main.game.LanternLighting,function() return "40" end,function() return "39" end))
if (((not player.BanShoot) and (crazyStorm == nil)) and (((player.DashTime > 15) or (player.NoShootTime > 30)))) then
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,id,self.playerPos)
crazyStorm.alpha=Character.SelfPowerAlpha
crazyStorm.order=CrazyStorm.Order.UnderActorEquip
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",self.playerPos)
CS.invoke(Program.main.game,"PlaySound","firesmall",false,CS.f(0))
else
if (((not player.BanShoot) and (crazyStorm ~= nil)) and (((player.DashTime > 15) or (player.NoShootTime > 30)))) then
if (self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) then
CS.invoke(crazyStorm,"Close")
crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,id,self.playerPos)
crazyStorm.alpha=Character.SelfPowerAlpha
crazyStorm.order=CrazyStorm.Order.UnderActorEquip
crazyStorm.specialnotkill=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm,"SetOPos",self.playerPos)
CS.invoke(Program.main.game,"PlaySound","firesmall",false,CS.f(0))
end
else
if ((crazyStorm ~= nil) and ((player.BanShoot or (((player.NoDashTime > 8) and (player.NoShootTime <= 30)))))) then
CS.invoke(crazyStorm,"Close")
crazyStorm=nil
CS.invoke(Program.main.game,"StopSound","firesmall")
end
end
end
CS.optionalCall(crazyStorm,"SetPos",self.playerPos,false)
self.cs["fire"]=crazyStorm
for _,item in CS.each(em.EnemyArray) do
local __break36,__continue36=false,false
repeat
if (CS.invoke(item,"IsInWudi") or item.die) then
__continue36=true;break
end
for _,item2 in CS.each(csm.esc) do
local __break37,__continue37=false,false
repeat
if ((item2.Id ~= "e39") and (item2.Id ~= "e40")) then
__continue37=true;break
end
for _,item3 in CS.each(item2.layerm.LayerArray) do
local __break38,__continue38=false,false
repeat
local flag=false
for _,barrage in CS.each(item3.Barrages) do
local __break39,__continue39=false,false
repeat
if ((((not barrage.Dis) and (((barrage.time > 15) or (not barrage.Mist)))) and (barrage.NeedDelete == NeedDeleteType.None)) and (barrage.parentid == 0)) then
local w=(CS.f((CS.choose(((barrage.type >= csm.stockCount)),function() return item2.bgset[(barrage.type - csm.stockCount)].rect.Width end,function() return csm.bgset[barrage.type].rect.Width end))) + item.judgesize.X)
local h=(CS.f((CS.choose(((barrage.type >= csm.stockCount)),function() return item2.bgset[(barrage.type - csm.stockCount)].rect.Height end,function() return csm.bgset[barrage.type].rect.Height end))) + item.judgesize.Y)
if CS.invoke(barrage,"Judge",barrage.x,barrage.y,(item.Position.X - CrazyStorm.ToScreen.X),(item.Position.Y - CrazyStorm.ToScreen.Y),barrage.head,w,h) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(item,"DecreasingHp",CS.choose(Program.main.game.LanternLighting,function() return player.damageSet.A.other1 end,function() return player.damageSet.A.skill end),false,false)
flag=true
__break39=true;break
end
end
until true
if __break39 then break end
end
if flag then
__break38=true;break
end
until true
if __break38 then break end
end
until true
if __break37 then break end
end
until true
if __break36 then break end
end
if (bossStage ~= nil) then
do
local i=0
while (i < bossStage.Bosses.Count) do
local __break40,__continue40=false,false
repeat
local boss=bossStage.Bosses[i]
for _,item4 in CS.each(csm.esc) do
local __break41,__continue41=false,false
repeat
if ((((item4.Id ~= "e39") and (item4.Id ~= "e40"))) or (bossStage.CardArray.Count == 0)) then
__continue41=true;break
end
for _,item5 in CS.each(item4.layerm.LayerArray) do
local __break42,__continue42=false,false
repeat
local flag2=false
for _,barrage2 in CS.each(item5.Barrages) do
local __break43,__continue43=false,false
repeat
if ((((not barrage2.Dis) and (((barrage2.time > 15) or (not barrage2.Mist)))) and (barrage2.NeedDelete == NeedDeleteType.None)) and (barrage2.parentid == 0)) then
local w2=(CS.f((CS.choose(((barrage2.type >= csm.stockCount)),function() return item4.bgset[(barrage2.type - csm.stockCount)].rect.Width end,function() return csm.bgset[barrage2.type].rect.Width end))) + boss.JudgeSize.X)
local h2=(CS.f((CS.choose(((barrage2.type >= csm.stockCount)),function() return item4.bgset[(barrage2.type - csm.stockCount)].rect.Height end,function() return csm.bgset[barrage2.type].rect.Height end))) + boss.JudgeSize.Y)
if CS.invoke(barrage2,"Judge",barrage2.x,barrage2.y,(boss.Position.X - CrazyStorm.ToScreen.X),(boss.Position.Y - CrazyStorm.ToScreen.Y),barrage2.head,w2,h2) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(bossStage.CardArray[0],"DeHp",player.damageSet.A.other2,true,true,item4)
flag2=true
__break43=true;break
end
end
until true
if __break43 then break end
end
if flag2 then
__break42=true;break
end
until true
if __break42 then break end
end
until true
if __break41 then break end
end
until true
if __break40 then break end
i=i+1
end
end
end
if (player.EquipType == EquipType.A) then
local flag3=CS.invoke(Main,"IsKeyDown",InputKeys.Slow)
for _,item6 in CS.each(SelfBarrageManager.SBArray) do
local __break44,__continue44=false,false
repeat
if (((not item6.needDelete) and (not item6.Judged)) and (item6.label >= 1000)) then
local num=CS.idiv(item6.label,1000)
local num2=CS.rem(item6.label,1000)
local num3=0
local vector=CS.copy(CS.Vector2())
if (num2 == 1) then
num3=(CS.choose(((not flag3)),function() return (CS.choose(((num == 1)),function() return 295 end,function() return 245 end)) end,function() return (CS.choose(((num == 1)),function() return 280 end,function() return 260 end)) end))
vector=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num3))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",num3)))))
end
if (num2 == 2) then
num3=(CS.choose(((not flag3)),function() return (CS.choose(((num == 1)),function() return 280 end,function() return 260 end)) end,function() return (CS.choose(((num == 1)),function() return 275 end,function() return 265 end)) end))
vector=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num3))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",num3)))))
end
if (num2 == 3) then
num3=(CS.choose(((not flag3)),function() return (CS.choose(((num == 1)),function() return 265 end,function() return 275 end)) end,function() return (CS.choose(((num == 1)),function() return 270 end,function() return 270 end)) end))
vector=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num3))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",num3)))))
end
if (num2 == 4) then
num3=(CS.choose(((not flag3)),function() return (CS.choose(((num == 1)),function() return 250 end,function() return 290 end)) end,function() return (CS.choose(((num == 1)),function() return 260 end,function() return 280 end)) end))
vector=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",num3))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",num3)))))
end
item6.speedx=CS.f((item6.speedx + ((vector.X * (CS.choose(((flag3 and (num2 == 3))),function() return CS.f(0.4) end,function() return CS.f(1) end))) * Time.Stop)))
item6.speedy=CS.f((item6.speedy + ((vector.Y * (CS.choose(((flag3 and (num2 == 3))),function() return CS.f(0.4) end,function() return CS.f(1) end))) * Time.Stop)))
item6.alpha=CS.f(CS.invoke(Math,"Min",CS.f(0.7),(item6.alpha + (CS.f(0.07) * Time.Stop))))
item6.color.g=CS.invoke(Math,"Min",(CS.f(35) / CS.f(51)),(item6.color.g + (CS.f(0.01709804) * Time.Stop)))
item6.color.b=CS.invoke(Math,"Min",(CS.f(35) / CS.f(51)),(item6.color.b + (CS.f(0.01709804) * Time.Stop)))
local num4=(CS.choose(Program.main.game.LanternLighting,function() return CS.f(0.9) end,function() return CS.f(0.75) end))
item6.scale.X=CS.f(CS.invoke(Math,"Min",num4,(item6.scale.X + ((((num4 - CS.f(0.15))) / CS.f(12)) * Time.Stop))))
end
until true
if __break44 then break end
end
end
if (player.EquipType ~= EquipType.B) then
do return  end
end
local crazyStorm2=(CS.choose(CS.invoke(self.cs,"ContainsKey","shootFire"),function() return self.cs["shootFire"] end,function() return nil end))
local status=1
do local __switch45=Program.main.game.LanternStatus
repeat
if __switch45==LanternStatus.OPENING or __switch45==LanternStatus.RELEASING then
status=2
break
elseif __switch45==LanternStatus.LOSINGCONTROL then
status=3
break
end
until true
end
if ((not Ban) and Character.IsPlayerShoot) then
if ((crazyStorm2 == nil) and (Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)) then
crazyStorm2=CS.invoke(Program.main.game,"PlayEffect",true,"39",self.playerPos)
crazyStorm2.Id="shootFire"
crazyStorm2.Status=status
crazyStorm2.order=CrazyStorm.Order.UnderActorEquip
crazyStorm2.specialnotkill=true
CS.invoke(crazyStorm2,"BanSound",true)
CS.invoke(crazyStorm2,"SetOPos",self.playerPos)
else
if (crazyStorm2 ~= nil) then
crazyStorm2.alpha=Character.SelfPowerAlpha
CS.invoke(crazyStorm2,"SetPos",self.playerPos,false)
if (self.lanternStatus ~= CS.trunc(Program.main.game.LanternStatus)) then
CS.invoke(crazyStorm2,"Close")
crazyStorm2=nil
end
end
end
else
if (crazyStorm2 ~= nil) then
CS.invoke(crazyStorm2,"Close")
crazyStorm2=nil
end
end
self.cs["shootFire"]=crazyStorm2
for _,item7 in CS.each(csm.esc) do
local __break46,__continue46=false,false
repeat
if (item7.Id ~= "shootFire") then
__continue46=true;break
end
for _,item8 in CS.each(item7.layerm.LayerArray) do
local __break47,__continue47=false,false
repeat
for _,barrage3 in CS.each(item8.Barrages) do
local __break48,__continue48=false,false
repeat
if ((((barrage3.Dis or (((barrage3.time <= 15) and barrage3.Mist))) or (barrage3.NeedDelete ~= NeedDeleteType.None)) or (barrage3.time >= 75)) or ((barrage3.y + CrazyStorm.ToScreen.Y) < CS.f(10))) then
__continue48=true;break
end
local rectangle=CS.copy((CS.choose(((barrage3.type >= csm.stockCount)),function() return item7.bgset[(barrage3.type - csm.stockCount)].rect end,function() return csm.bgset[barrage3.type].rect end)))
for _,item9 in CS.each(FamiliarManager.Instance.FamiliarArray) do
local __break49,__continue49=false,false
repeat
if (((not CS.invoke(item9,"IsInWudi")) and (not item9.Die)) and (not item9.Dying)) then
local w3=(((CS.f(rectangle.Width) * barrage3.wscale) * CS.f(0.4)) + item9.JudgeSize.X)
local h3=(((CS.f(rectangle.Height) * barrage3.hscale) * CS.f(0.6)) + item9.JudgeSize.Y)
if CS.invoke(barrage3,"Judge",barrage3.x,barrage3.y,(item9.X - CrazyStorm.ToScreen.X),(item9.Y - CrazyStorm.ToScreen.Y),barrage3.head,w3,h3) then
barrage3.speed=CS.f(0.4)
__break49=true;break
end
end
until true
if __break49 then break end
end
for _,item10 in CS.each(em.EnemyArray) do
local __break50,__continue50=false,false
repeat
if ((not CS.invoke(item10,"IsInWudi")) and (not item10.die)) then
local w4=(((CS.f(rectangle.Width) * barrage3.wscale) * CS.f(0.4)) + item10.judgesize.X)
local h4=(((CS.f(rectangle.Height) * barrage3.hscale) * CS.f(0.6)) + item10.judgesize.Y)
if CS.invoke(barrage3,"Judge",barrage3.x,barrage3.y,(item10.Position.X - CrazyStorm.ToScreen.X),(item10.Position.Y - CrazyStorm.ToScreen.Y),barrage3.head,w4,h4) then
barrage3.speed=CS.f(0.4)
__break50=true;break
end
end
until true
if __break50 then break end
end
if ((bossStage == nil) or (bossStage.CardArray.Count <= 0)) then
__continue48=true;break
end
do
local j=0
while (j < bossStage.Bosses.Count) do
local __break51,__continue51=false,false
repeat
local boss2=bossStage.Bosses[j]
local w5=(((CS.f(rectangle.Width) * barrage3.wscale) * CS.f(0.4)) + boss2.JudgeSize.X)
local h5=(((CS.f(rectangle.Height) * barrage3.hscale) * CS.f(0.6)) + boss2.JudgeSize.Y)
if CS.invoke(barrage3,"Judge",barrage3.x,barrage3.y,(boss2.Position.X - CrazyStorm.ToScreen.X),(boss2.Position.Y - CrazyStorm.ToScreen.Y),barrage3.head,w5,h5) then
barrage3.speed=CS.f(0.4)
__break51=true;break
end
until true
if __break51 then break end
j=j+1
end
end
until true
if __break48 then break end
end
until true
if __break47 then break end
end
until true
if __break46 then break end
end
CS.invoke(self.ec,"Clear")
CS.invoke(self.fc,"Clear")
local other=player.damageSet.B.other3
for _,item11 in CS.each(em.EnemyArray) do
local __break52,__continue52=false,false
repeat
if (CS.invoke(item11,"IsInWudi") or item11.die) then
__continue52=true;break
end
for _,item12 in CS.each(csm.esc) do
local __break53,__continue53=false,false
repeat
if (item12.Id ~= "shootFire") then
__continue53=true;break
end
local num5=0
for _,item13 in CS.each(item12.layerm.LayerArray) do
local __break54,__continue54=false,false
repeat
for _,barrage4 in CS.each(item13.Barrages) do
local __break55,__continue55=false,false
repeat
if (((((not barrage4.Dis) and (((barrage4.time > 15) or (not barrage4.Mist)))) and (barrage4.NeedDelete == NeedDeleteType.None)) and (barrage4.time < 75)) and (not (((barrage4.y + CrazyStorm.ToScreen.Y) < CS.f(10))))) then
local rectangle2=CS.copy((CS.choose(((barrage4.type >= csm.stockCount)),function() return item12.bgset[(barrage4.type - csm.stockCount)].rect end,function() return csm.bgset[barrage4.type].rect end)))
local w6=(((CS.f(rectangle2.Width) * barrage4.wscale) * CS.f(0.4)) + item11.judgesize.X)
local h6=(((CS.f(rectangle2.Height) * barrage4.hscale) * CS.f(0.6)) + item11.judgesize.Y)
if CS.invoke(barrage4,"Judge",barrage4.x,barrage4.y,(item11.Position.X - CrazyStorm.ToScreen.X),(item11.Position.Y - CrazyStorm.ToScreen.Y),barrage4.head,w6,h6) then
local num6=(CS.choose(Program.main.game.LanternLighting,function() return player.damageSet.B.other1 end,function() return player.damageSet.B.skill end))
local power=Equipment.CalculateLimitDamage(self,self.ec,item11,(num6 * Time.Stop),other)
CS.invoke(item11,"DecreasingHp",power,false,false)
Program.main.game.Score=(Program.main.game.Score + 10)
num5=num5+1
__break55=true;break
end
end
until true
if __break55 then break end
end
if (num5 == 3) then
__break54=true;break
end
until true
if __break54 then break end
end
until true
if __break53 then break end
end
until true
if __break52 then break end
end
for _,item14 in CS.each(FamiliarManager.Instance.FamiliarArray) do
local __break56,__continue56=false,false
repeat
if ((CS.invoke(item14,"IsInWudi") or item14.Die) or item14.Dying) then
__continue56=true;break
end
for _,item15 in CS.each(csm.esc) do
local __break57,__continue57=false,false
repeat
if (item15.Id ~= "shootFire") then
__continue57=true;break
end
local num7=0
for _,item16 in CS.each(item15.layerm.LayerArray) do
local __break58,__continue58=false,false
repeat
for _,barrage5 in CS.each(item16.Barrages) do
local __break59,__continue59=false,false
repeat
if ((((barrage5.Dis or (((barrage5.time <= 15) and barrage5.Mist))) or (barrage5.NeedDelete ~= NeedDeleteType.None)) or (barrage5.time >= 75)) or ((barrage5.y + CrazyStorm.ToScreen.Y) < CS.f(10))) then
__continue59=true;break
end
local rectangle3=CS.copy((CS.choose(((barrage5.type >= csm.stockCount)),function() return item15.bgset[(barrage5.type - csm.stockCount)].rect end,function() return csm.bgset[barrage5.type].rect end)))
local w7=(((CS.f(rectangle3.Width) * barrage5.wscale) * CS.f(0.4)) + item14.JudgeSize.X)
local h7=(((CS.f(rectangle3.Height) * barrage5.hscale) * CS.f(0.6)) + item14.JudgeSize.Y)
if CS.invoke(barrage5,"Judge",barrage5.x,barrage5.y,(item14.X - CrazyStorm.ToScreen.X),(item14.Y - CrazyStorm.ToScreen.Y),barrage5.head,w7,h7) then
local num8=(CS.choose(Program.main.game.LanternLighting,function() return player.damageSet.B.other1 end,function() return player.damageSet.B.skill end))
local num9=Equipment.CalculateLimitDamage(self,self.fc,item14,(num8 * Time.Stop),other)
local flag4=CS.is(item14.Master,"Enemy")
CS.invoke(item14,"DecreasingHp",num9,false,(not flag4))
if (flag4 and (not item14.Independent)) then
local power2=Equipment.CalculateLimitDamage(self,self.ec,CS.as(item14.Master,"Enemy"),(num9 * CS.f(0.5)),other)
CS.invoke(item14.Master,"DecreasingHp",power2,false,true)
end
Program.main.game.Score=(Program.main.game.Score + 10)
num7=num7+1
__break59=true;break
end
until true
if __break59 then break end
end
if (num7 == 3) then
__break58=true;break
end
until true
if __break58 then break end
end
until true
if __break57 then break end
end
until true
if __break56 then break end
end
if ((bossStage ~= nil) and (bossStage.CardArray.Count > 0)) then
do
local k=0
while (k < bossStage.Bosses.Count) do
local __break60,__continue60=false,false
repeat
local boss3=bossStage.Bosses[k]
for _,item17 in CS.each(csm.esc) do
local __break61,__continue61=false,false
repeat
if (item17.Id ~= "shootFire") then
__continue61=true;break
end
local num10=0
for _,item18 in CS.each(item17.layerm.LayerArray) do
local __break62,__continue62=false,false
repeat
for _,barrage6 in CS.each(item18.Barrages) do
local __break63,__continue63=false,false
repeat
if (((((not barrage6.Dis) and (((barrage6.time > 15) or (not barrage6.Mist)))) and (barrage6.NeedDelete == NeedDeleteType.None)) and (barrage6.time < 75)) and (not (((barrage6.y + CrazyStorm.ToScreen.Y) < CS.f(10))))) then
local rectangle4=CS.copy((CS.choose(((barrage6.type >= csm.stockCount)),function() return item17.bgset[(barrage6.type - csm.stockCount)].rect end,function() return csm.bgset[barrage6.type].rect end)))
local w8=(((CS.f(rectangle4.Width) * barrage6.wscale) * CS.f(0.4)) + boss3.JudgeSize.X)
local h8=(((CS.f(rectangle4.Height) * barrage6.hscale) * CS.f(0.6)) + boss3.JudgeSize.Y)
if CS.invoke(barrage6,"Judge",barrage6.x,barrage6.y,(boss3.Position.X - CrazyStorm.ToScreen.X),(boss3.Position.Y - CrazyStorm.ToScreen.Y),barrage6.head,w8,h8) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(bossStage.CardArray[0],"DeHp",player.damageSet.B.other2,true,true,item17)
num10=num10+1
__break63=true;break
end
end
until true
if __break63 then break end
end
if (num10 == 3) then
__break62=true;break
end
until true
if __break62 then break end
end
until true
if __break61 then break end
end
until true
if __break60 then break end
k=k+1
end
end
end
for _,item19 in CS.each(SelfBarrageManager.SBArray) do
local __break64,__continue64=false,false
repeat
if (not item19.needDelete) then
if (item19.label == 1000) then
item19.alpha=CS.f(CS.invoke(Math,"Min",CS.f(0.8),(item19.alpha + (CS.f(0.13) * Time.Stop))))
else
if (item19.label == 1001) then
item19.alpha=CS.f(CS.invoke(Math,"Min",CS.f(0.7),(item19.alpha + (CS.f(0.13) * Time.Stop))))
item19.speed=CS.f(CS.invoke(Math,"Min",CS.f(40),(item19.speed + (CS.f(0.5) * Time.Stop))))
end
end
end
until true
if __break64 then break end
end
end
function Equipment:Update(...) local n=select("#",...);if n==7 then return Equipment.Update_7(self,...);elseif n==3 then return Equipment.Update_3(self,...) end;error("原作方法参数数目不符：Equipment.Update") end
function Equipment:Draw(...) local n=select("#",...);if n==5 then return Equipment.Draw_5(self,...);elseif n==4 then return Equipment.Draw_4(self,...) end;error("原作方法参数数目不符：Equipment.Draw") end
function Equipment.defaults(self)
self.tex=nil
self.sprites=nil
self.cs=nil
self.csRefs=nil
self.sb=nil
self.sbRefs=nil
self.ec=nil
self.fc=nil
self.reactTime=0
self.inited=false
self.playerPos=CS.Vector2()
self.lanternControlPos=CS.Vector2()
self.playerChase=CS.Vector2()
self.playerChase2x=CS.Vector2()
self.shadowPos=nil
self.shadowPosIndex=0
self.childrenPos=nil
self.childrenTime=nil
self.lanternStatus=0
self.lastShootable=false
self.inBossStage=false
self.time=0
end
-- SelfBarrage.cs SHA256 f69da72457d2c3a8c977ba0402fd8ece48824178dd63ac72237218fe299b0a80
SelfBarrage={__get={},__set={}}
SelfBarrage.__index=function(o,k) local getter=SelfBarrage.__get[k];if getter then return getter(o) end;return SelfBarrage[k] end
SelfBarrage.__newindex=function(o,k,v) local setter=SelfBarrage.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SelfBarrage.__base="SelfBarrageManager"
SelfBarrage.Order={Default=0,Bottom=1,Underneath=2,UnderActor=3,Overtop=4}
function SelfBarrage:ctor()

do
local i=0
while (i < self.shadows.Length) do
local __break1,__continue1=false,false
repeat
self.shadows[i]=CS.new("Shadows")
until true
if __break1 then break end
i=i+1
end
end
do
local j=0
while (j < 3) do
local __break2,__continue2=false,false
repeat
CS.invoke(self.targets,"Add",CS.Vector2())
until true
if __break2 then break end
j=j+1
end
end
end
function SelfBarrage:Update(em,enemyTarget,familiarTarget,bossm,Player)

local game=Program.main.game
if self.curveChase then
if (self.curve == nil) then
self.curve=CS.invoke(Curve,"Get",self.position,60)
self.curve.tex=self.shape
else
CS.invoke(self.curve,"Update",self.position,(CS.f(self.rect.Width) * self.scale.X),(CS.f(self.rect.Height) * self.scale.Y))
end
end
self.uv.X=CS.f((self.uv.X + CS.trunc(((self.uvSpeed.X * Time.Stop)))))
self.uv.Y=CS.f((self.uv.Y + CS.trunc(((self.uvSpeed.Y * Time.Stop)))))
local x=Player.body.position.X
local y=Player.body.position.Y
if ((self.speed ~= CS.f(0)) and (self.speedd ~= CS.f(0))) then
self.speedx=CS.f((self.speed * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",self.speedd)))))
self.speedy=CS.f((self.speed * CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",self.speedd)))))
end
self.position.X=CS.f((self.position.X + (self.speedx * Time.Stop)))
self.position.Y=CS.f((self.position.Y + (self.speedy * Time.Stop)))
local num=CS.f(0)
if (self.speedy ~= CS.f(0)) then
num=CS.f(((CS.f(Math.PI) / CS.f(2)) - CS.f(CS.invoke(Math,"Atan",(self.speedx / self.speedy)))))
if (self.speedy < CS.f(0)) then
num=CS.f((num + CS.f(Math.PI)))
end
else
if (self.speedx ~= CS.f(0)) then
if (self.speedx >= CS.f(0)) then
num=CS.f(CS.f(0))
end
if (self.speedx < CS.f(0)) then
num=CS.f(CS.f(Math.PI))
end
end
end
if (self.speed > CS.f(0)) then
self.speedd=CS.f(CS.invoke(MathHelper,"ToDegrees",num))
if self.rotate then
self.rotation=CS.f((self.rotation + (self.rotateSpeed * Time.Stop)))
else
if (not self.fixRotation) then
self.rotation=CS.f(self.speedd)
end
end
else
if ((self.speedx ~= CS.f(0)) and (self.speedy ~= CS.f(0))) then
if self.rotate then
self.rotation=CS.f((self.rotation + (self.rotateSpeed * Time.Stop)))
else
if (not self.fixRotation) then
self.rotation=CS.f(CS.invoke(MathHelper,"ToDegrees",num))
end
end
end
end
if self.enableShadow then
self.shadows[self.shadowIndex].alpha=(CS.f(0.4) * self.color.a)
self.shadows[self.shadowIndex].x=self.position.X
self.shadows[self.shadowIndex].y=self.position.Y
self.shadows[self.shadowIndex].d=self.rotation
self.shadowIndex=self.shadowIndex+1
if (self.shadowIndex >= (self.shadows.Length - 1)) then
self.shadowIndex=0
end
end
if ((not self.Judged) or self.straight) then
self.color.a=(self.color.a + CS.f(0.5))
if (self.color.a >= self.alpha) then
self.color.a=self.alpha
end
if (self.chase or self.curveChase) then
do
local i=0
while (i < self.targets.Count) do
local __break3,__continue3=false,false
repeat
self.targets[i]=CS.copy(CS.new("Vector2",CS.f(99999),CS.f(99999)))
until true
if __break3 then break end
i=i+1
end
end
if (bossm ~= nil) then
local nearestTarget=CS.invoke(bossm,"GetNearestTarget",self.position)
if (nearestTarget ~= nil) then
local x2=CS.f(CS.invoke(Math,"Sqrt",((((self.position.X - nearestTarget.Position.X)) * ((self.position.X - nearestTarget.Position.X))) + (((self.position.Y - nearestTarget.Position.Y)) * ((self.position.Y - nearestTarget.Position.Y))))))
local y2=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",nearestTarget.Position.X,nearestTarget.Position.Y,self.position.X,self.position.Y))
self.targets[0]=CS.copy(CS.new("Vector2",x2,y2))
end
end
if (enemyTarget ~= nil) then
local x3=CS.f(CS.invoke(Math,"Sqrt",((((self.position.X - enemyTarget.Position.X)) * ((self.position.X - enemyTarget.Position.X))) + (((self.position.Y - enemyTarget.Position.Y)) * ((self.position.Y - enemyTarget.Position.Y))))))
local y3=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",enemyTarget.Position.X,enemyTarget.Position.Y,self.position.X,self.position.Y))
self.targets[1]=CS.copy(CS.new("Vector2",x3,y3))
end
if ((familiarTarget ~= nil) and ((self.affectFamiliar or familiarTarget.LikeEnemy))) then
local x4=CS.f(CS.invoke(Math,"Sqrt",((((self.position.X - familiarTarget.X)) * ((self.position.X - familiarTarget.X))) + (((self.position.Y - familiarTarget.Y)) * ((self.position.Y - familiarTarget.Y))))))
local y4=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",familiarTarget.X,familiarTarget.Y,self.position.X,self.position.Y))
self.targets[2]=CS.copy(CS.new("Vector2",x4,y4))
end
CS.invoke(self.targets,"Sort",function(a,b) return CS.trunc(((a.X - b.X))) end)
if (self.targets[0].X ~= CS.f(99999)) then
if ((self.speedd - self.targets[0].Y) > CS.f(180)) then
self.targets[0]=CS.copy(CS.new("Vector2",self.targets[0].X,(self.targets[0].Y + CS.f(360))))
end
if ((self.speedd - self.targets[0].Y) < (-CS.f(180))) then
self.targets[0]=CS.copy(CS.new("Vector2",self.targets[0].X,(self.targets[0].Y - CS.f(360))))
end
if (not self.curveChase) then
self.speedd=CS.f((self.speedd + ((((self.targets[0].Y - self.speedd)) / ((self.targets[0].X / self.speed))) * CS.f(1.5))))
else
self.speed=CS.f((self.speed + CS.f(0.1)))
self.speedd=CS.f((self.speedd + ((((self.targets[0].Y - self.speedd)) / ((self.targets[0].X / self.speed))) * CS.invoke(Math,"Min",(self.time / CS.f(10)),CS.f(2)))))
end
else
local num2=self.defaultChaseAngle
if ((self.speedd - num2) > CS.f(180)) then
num2=CS.f((num2 + CS.f(360)))
end
if ((self.speedd - num2) < (-CS.f(180))) then
num2=CS.f((num2 - CS.f(360)))
end
if (not self.curveChase) then
self.speedd=CS.f((self.speedd + ((((num2 - self.speedd)) / ((self.defaultChaseDistance / self.speed))) * CS.f(1.5))))
else
self.speed=CS.f((self.speed + CS.f(0.1)))
self.speedd=CS.f((self.speedd + ((((num2 - self.speedd)) / ((self.defaultChaseDistance / self.speed))) * CS.invoke(Math,"Min",(self.time / CS.f(10)),CS.f(2)))))
end
end
end
local screenRange=CS.copy(Game.ScreenRange)
if (not self.curveChase) then
CS.invoke(screenRange,"Inflate",300,100)
else
CS.invoke(screenRange,"Inflate",(CS.f(self.rect.Height) * self.scale.Y),(CS.f(self.rect.Height) * self.scale.Y))
end
if (not CS.invoke(screenRange,"Contains",self.position)) then
self.needDelete=true
end
self.JudgedEnemy=nil
self.JudgedFamiliar=nil
self.JudgedBoss=nil
if (not self.ignoreDamage) then
local enemy=CS.invoke(em,"Judge",self.position,self.extend)
if (enemy ~= nil) then
self.Judged=true
self.JudgedEnemy=enemy
if (enemy.judgesize.Y > CS.f(130)) then
self.judgedByBig=true
end
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(enemy,"DecreasingHp",(self.power * Time.Stop),true,false)
if (self.curve == nil) then
self.position.Y=CS.f(((CS.invoke(enemy,"GetPos").Y + ((enemy.judgesize.Y * enemy.Scale.Y) * CS.f(0.5))) + ((CS.f(self.rect.Height) * self.scale.Y) * self.deadHeightFactor)))
end
if (CS.rem(enemy.DamagedTime,8) == 0) then
local vector=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItem",false,(enemy.Position + vector),false)
end
end
local familiar=CS.invoke(FamiliarManager.Instance,"Judge",self.position,self.extend)
if ((familiar ~= nil) and ((self.affectFamiliar or familiar.LikeEnemy))) then
self.Judged=true
self.JudgedFamiliar=familiar
if (familiar.JudgeSize.Y > CS.f(130)) then
self.judgedByBig=true
end
local vector2=CS.copy(CS.new("Vector2",FamiliarManager.Instance.LastDamaged.X,FamiliarManager.Instance.LastDamaged.Y))
local flag=CS.invoke(Player,"IsPositionInLight",vector2)
local num3=(CS.choose(((flag or familiar.LikeEnemy)),function() return CS.f(1) end,function() return CS.f(0.5) end))
Program.main.game.Score=(Program.main.game.Score + CS.trunc(((CS.f(20) * num3))))
CS.invoke(familiar,"DecreasingHp",((self.power * num3) * Time.Stop),true,true)
if (CS.rem(familiar.DamagedTime,8) == 0) then
local vector3=CS.copy(CS.new("Vector2",CS.invoke(MathHelper,"Lerp",(-CS.f(40)),CS.f(40),CS.f(CS.invoke(game,"Rand"))),CS.invoke(MathHelper,"Lerp",(-CS.f(30)),CS.f(0),CS.f(CS.invoke(game,"Rand")))))
CS.invoke(Program.main.game,"SmallItemFromFamliar",flag,(vector2 + vector3))
end
if (self.curve == nil) then
self.position.Y=CS.f(((familiar.Y + ((familiar.JudgeSize.Y * familiar.Scale.Y) * CS.f(0.5))) + ((CS.f(self.rect.Height) * self.scale.Y) * self.deadHeightFactor)))
end
end
if (bossm ~= nil) then
do
local num4=0
while (num4 < bossm.Bosses.Count) do
local __break4,__continue4=false,false
repeat
local num5=CS.invoke(bossm.Bosses[num4],"Judge",self.position,self.extend)
if (num5 ~= (-CS.f(1))) then
self.Judged=true
self.JudgedBoss=bossm.Bosses[num4]
end
if (num5 > CS.f(0)) then
Program.main.game.Score=(Program.main.game.Score + 10)
CS.invoke(self.JudgedBoss,"DecreasingHp",(self.power * Time.Stop),true,false)
if (self.curve == nil) then
self.position.Y=CS.f(((CS.invoke(bossm.Bosses[num4],"GetPos").Y + ((bossm.Bosses[num4].JudgeSize.Y * bossm.Bosses[num4].Scale) * CS.f(0.5))) + ((CS.f(self.rect.Height) * self.scale.Y) * self.deadHeightFactor)))
end
__break4=true;break
end
until true
if __break4 then break end
num4=num4+1
end
end
end
if (self.Judged and (self.hitSound ~= nil)) then
CS.invoke(Program.main.game,"PlaySound",self.hitSound,true,self.position.X)
end
end
else
if (not self.curveChase) then
self.speed=CS.f(CS.f(0))
self.speedx=CS.f(((function() self.speedy=CS.f(CS.f(0));return self.speedy end)()))
self.JudgeDuration=CS.invoke(Math,"Max",0,(self.JudgeDuration - 1))
if (self.JudgeDuration > 0) then
if ((self.JudgedEnemy ~= nil) and (not self.JudgedEnemy.die)) then
CS.invoke(self.JudgedEnemy,"DecreasingHp",(self.power * Time.Stop),true,false)
end
if ((((self.JudgedFamiliar ~= nil) and (not self.JudgedFamiliar.Die)) and (not self.JudgedFamiliar.Dying)) and (not CS.invoke(self.JudgedFamiliar,"IsInWudi"))) then
CS.invoke(self.JudgedFamiliar,"DecreasingHp",(self.power * Time.Stop),true,true)
end
if ((self.JudgedBoss ~= nil) and (not CS.invoke(self.JudgedBoss,"IsDead"))) then
CS.invoke(self.JudgedBoss,"DecreasingHp",(self.power * Time.Stop),true,false)
end
end
self.scale.X=CS.f((self.scale.X + self.deadScaleSpeed))
self.color.a=(self.color.a - CS.f(0.05))
self.additive=true
self.rect=CS.copy(self.deadRect)
self.origin=CS.copy(self.deadOrigin)
self.order=(CS.choose(self.judgedByBig,function() return Order.Overtop end,function() return Order.Default end))
if (self.color.a <= CS.f(0)) then
self.needDelete=true
end
else
self.speed=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.speed - CS.f(1))))
self.color.a=(self.color.a - CS.f(0.05))
if (self.color.a <= CS.f(0)) then
self.needDelete=true
end
end
end
self.time=CS.f((self.time + CS.f(1)))
if ((self.life > CS.f(0)) and (self.time > self.life)) then
self.Judged=true
end
end
function SelfBarrage:Draw(s,c,q)

self.displayTime=self.displayTime+1
if (self.displayTime < self.displayInterval) then
do return  end
end
self.displayTime=0
local num=Character.SelfPowerAlpha
if self.muteCustomAlpha then
num=CS.f(CS.invoke(Math,"Max",num,CS.f(0.5)))
end
local value=CS.copy(self.rect)
if (self.uv.X ~= CS.f(0)) then
value.X=CS.trunc((((self.position.X + q.X) + self.uv.X)))
end
if (self.uv.Y ~= CS.f(0)) then
value.Y=CS.trunc((((self.position.Y + q.Y) + self.uv.Y)))
end
if self.enableShadow then
local array=self.shadows
for _,shadows in CS.each(array) do
local __break5,__continue5=false,false
repeat
if (shadows.alpha > CS.f(0)) then
shadows.alpha=(shadows.alpha - (CS.f(1) / CS.f(self.shadows.Length)))
CS.invoke(s,"Draw",self.shape,CS.new("Vector2",(shadows.x + q.X),(shadows.y + q.Y)),value,CS.new("Color",self.color.r,self.color.g,self.color.b,(shadows.alpha * num)),CS.invoke(MathHelper,"ToRadians",(self.rotation + CS.f(90))),self.origin,self.scale,self.effect,CS.f(0))
end
until true
if __break5 then break end
end
end
if (self.curve == nil) then
CS.invoke(s,"Draw",self.shape,CS.new("Vector2",(self.position.X + q.X),(self.position.Y + q.Y)),value,CS.new("Color",self.color.r,self.color.g,self.color.b,(self.color.a * num)),CS.invoke(MathHelper,"ToRadians",(self.rotation + CS.f(90))),self.origin,self.scale,self.effect,CS.f(0))
else
CS.invoke(c,"Draw",self.curve,value,q,CS.new("Color",self.color.r,self.color.g,self.color.b,(self.color.a * num)))
end
end
function SelfBarrage.defaults(self)
self.shape=nil
self.curve=nil
self.position=CS.Vector2()
self.rect=CS.Rectangle()
self.uv=CS.Vector2()
self.uvSpeed=CS.Vector2()
self.color=CS.new("Colors",CS.f(1),CS.f(1),CS.f(1),CS.f(0))
self.alpha=0
self.rotation=0
self.origin=Vector2.Zero
self.scale=CS.new("Vector2",CS.f(1),CS.f(1))
self.speed=0
self.speedx=0
self.speedy=0
self.speedd=0
self.power=0
self.time=0
self.life=0
self.dx=0
self.dy=0
self.label=0
self.extend=0
self.straight=false
self.ignoreDamage=false
self.chase=false
self.curveChase=false
self.defaultChaseDistance=CS.f(400)
self.defaultChaseAngle=(-CS.f(90))
self.rotate=false
self.rotateSpeed=CS.f(5)
self.fixRotation=false
self.needDelete=false
self.Judged=false
self.JudgeDuration=0
self.JudgedEnemy=nil
self.JudgedFamiliar=nil
self.JudgedBoss=nil
self.affectFamiliar=false
self.additive=true
self.deadRect=CS.Rectangle()
self.deadOrigin=CS.Vector2()
self.deadScaleSpeed=CS.f(0.2)
self.deadHeightFactor=CS.f(0.38)
self.order=0
self.shadows=CS.array(25,function() return nil end)
self.shadowIndex=0
self.enableShadow=false
self.effect=0
self.judgedByBig=false
self.displayTime=0
self.displayInterval=0
self.hitSound=nil
self.muteCustomAlpha=false
self.targets=CS.List({})
end
-- SingleBomb.cs SHA256 89fb8185eedf653bd3ae176c2097e14db2d117c6245d71abf5218cf4ddcca9f7
SingleBomb={__get={},__set={}}
SingleBomb.__index=function(o,k) local getter=SingleBomb.__get[k];if getter then return getter(o) end;return SingleBomb[k] end
SingleBomb.__newindex=function(o,k,v) local setter=SingleBomb.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function SingleBomb.__get.Die(self) return self.die end
function SingleBomb.__get.Jue(self) return self.__prop_Jue end
function SingleBomb.__get.Jue(self) return self.__prop_Jue end
function SingleBomb.__get.Active(self) if (self.cs ~= nil) then
do return (not CS.invoke(self.cs,"IsClosing")) end
end
do return false end end
function SingleBomb:ctor(cardTex,Player,bossStage,type_C,pos,special)

self.type=type_C
self.Jue=special
Player.BWudi=true
Player.BAuto=true
if (not self.Jue) then
Player.BBanShoot=true
end
CS.invoke(Program.main.game,"PlaySound","nep00",true,pos.X)
CS.invoke(Controller,"Rumble",32768,ushort.MaxValue,400)
local num=CS.trunc(Player.damageSet.bombEnemy)
local shootFactorForBoss=(Player.damageSet.bombBoss / CS.f(num))
local num2=CS.trunc(Player.damageSet.bombEnemyJue)
local shootFactorForBoss2=(Player.damageSet.bombBossJue / CS.f(num2))
self.cardDisplay=CS.new("CardDisplay",cardTex,CS.choose(special,function() return CharacterCard.JueBomb end,function() return CharacterCard.Bomb end))
Program.main.game.DrawCardDisplay=(Program.main.game.DrawCardDisplay + self.cardDisplay.Draw)
do local __switch1=self.type
repeat
if __switch1==Cname.REIMU then
if special then
self.target=nil
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"32",CS.new("Vector2",((((pos.X - CrazyStorm.DefaultCenter.X)) * CS.f(0.5)) + CrazyStorm.DefaultCenter.X),CS.f(360)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=2,[1]=0,[2]=num2}))
self.cs.shootFactorForBoss=shootFactorForBoss2
CS.optionalCall(bossStage,"OpenSideTeammate",3)
else
self.target=CS.new("Character",CS.new("Sprite"))
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"31",pos)
CS.invoke(self.cs,"SetOPos",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=3,[1]=0,[2]=num,[3]=3,[4]=2,[5]=num}))
self.cs.shootFactorForBoss=shootFactorForBoss
end
break
elseif __switch1==Cname.MARISA then
if special then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"34",CrazyStorm.DefaultCenter)
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=3,[1]=0,[2]=num2}))
self.cs.shootFactorForBoss=shootFactorForBoss2
CS.optionalCall(bossStage,"OpenSideTeammate",4)
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"33",pos)
CS.invoke(self.cs,"SetOPos",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=0,[1]=8,[2]=num}))
self.cs.shootFactorForBoss=shootFactorForBoss
end
break
elseif __switch1==Cname.SANAE then
if special then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"36",pos)
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=0,[1]=0,[2]=num2}))
self.cs.shootFactorForBoss=shootFactorForBoss2
CS.optionalCall(bossStage,"OpenSideTeammate",1)
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"35",pos)
CS.invoke(self.cs,"SetOPos",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=0,[1]=0,[2]=num}))
self.cs.shootFactorForBoss=shootFactorForBoss
end
break
elseif __switch1==Cname.MOKOU then
if special then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"38",CS.new("Vector2",((((pos.X - CrazyStorm.DefaultCenter.X)) * CS.f(0.5)) + CrazyStorm.DefaultCenter.X),CS.f(360)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=3,[1]=2,[2]=num2}))
self.cs.shootFactorForBoss=shootFactorForBoss2
CS.optionalCall(bossStage,"OpenSideTeammate",2)
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"37",CrazyStorm.DefaultCenter)
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=3,[1]=4,[2]=num}))
self.cs.shootFactorForBoss=shootFactorForBoss
end
break
end
until true
end
self.cs.shootFactorForFamiliar=CS.f(0)
self.cs.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.cs,"BanSound",true)
self.cs.bomb=true
self.cs.ignoreAlpha=true
self.cs.clearb=true
self.time=0
end
function SingleBomb:TextureUpdate(cardTex)

CS.optionalCall(self.cardDisplay,"TextureUpdate",cardTex)
end
function SingleBomb:Update(Player,csm,em,bossStage)

local player=Player
self.time=self.time+1
if (self.time <= 40) then
Program.main.game.bombcolor.a=(Program.main.game.bombcolor.a + CS.f(0.015))
if (Program.main.game.bombcolor.a >= CS.f(1)) then
Program.main.game.bombcolor.a=CS.f(1)
end
end
if (Player.BWudi and (CS.rem(self.time,6) < 3)) then
Player.body.color.r=CS.f(0)
Player.body.color.g=CS.f(0)
else
Player.body.color.r=CS.f(1)
Player.body.color.g=CS.f(1)
end
if ((self.cardDisplay ~= nil) and CS.invoke(self.cardDisplay,"Update")) then
Program.main.game.DrawCardDisplay=(Program.main.game.DrawCardDisplay - self.cardDisplay.Draw)
self.cardDisplay=nil
end
if (self.cs == nil) then
do return  end
end
self.cs.alpha=Character.SelfPowerAlpha
if (self.target ~= nil) then
self.target.body.position=CS.copy(CrazyStorm.DefaultCenter)
for _,item in CS.each(em.EnemyArray) do
local __break2,__continue2=false,false
repeat
if (((((not item.die) and (item.Position.X >= CS.f(Game.ScreenRange.Left))) and (item.Position.X <= CS.f(Game.ScreenRange.Right))) and (item.Position.Y >= CS.f(Game.ScreenRange.Top))) and (item.Position.Y <= CS.f(Game.ScreenRange.Bottom))) then
self.target.body.position=CS.copy(item.Position)
__break2=true;break
end
until true
if __break2 then break end
end
if (bossStage ~= nil) then
local num=float.MaxValue
do
local i=0
while (i < bossStage.Bosses.Count) do
local __break3,__continue3=false,false
repeat
local boss=bossStage.Bosses[i]
local num2=CS.invoke(((boss.Position - CS.invoke(Player,"Position"))),"Length")
if ((boss ~= nil) and (num > num2)) then
num=CS.f(num2)
self.target.body.position=CS.copy(boss.Position)
end
until true
if __break3 then break end
i=i+1
end
end
end
player=self.target
end
if CS.invoke(self.cs,"Run") then
CS.invoke(self.cs,"Update",player,em,bossStage)
end
if (not CS.invoke(self.cs,"IsClosing")) then
do local __switch4=self.type
repeat
if __switch4==Cname.REIMU then
if (self.cs.Id == "e31") then
CS.invoke(self.cs,"SetPos",Player.body.position,false)
Player.speedadd=CS.invoke(Vector2,"Lerp",CS.new("Vector2",CS.f(1),CS.f(1)),CS.new("Vector2",CS.f(0.15),CS.f(0.02)),Player.bombMoveFactor)
end
break
elseif __switch4==Cname.MARISA then
if (self.cs.Id == "e33") then
CS.invoke(self.cs,"SetPos",Player.body.position,true)
Player.speedadd=CS.invoke(Vector2,"Lerp",CS.new("Vector2",CS.f(1),CS.f(1)),CS.new("Vector2",CS.f(0.15),CS.f(0.02)),Player.bombMoveFactor)
end
break
elseif __switch4==Cname.SANAE then
if (self.cs.Id == "e35") then
CS.invoke(self.cs,"SetPos",Player.body.position,true)
Player.speedadd=CS.invoke(Vector2,"Lerp",CS.new("Vector2",CS.f(1),CS.f(1)),CS.new("Vector2",CS.f(0.15),CS.f(0.02)),Player.bombMoveFactor)
end
break
elseif __switch4==Cname.MOKOU then
break
end
until true
end
do return  end
end
if (self.wait == 0) then
Player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
if (not self.Jue) then
Player.BBanShoot=false
end
end
self.wait=self.wait+1
Program.main.game.bombcolor.a=(Program.main.game.bombcolor.a - CS.f(0.015))
if (Program.main.game.bombcolor.a <= CS.f(0)) then
Program.main.game.bombcolor.a=CS.f(0)
end
if (self.wait == 120) then
Player.body.color.r=CS.f(1)
Player.body.color.g=CS.f(1)
Player.BAuto=false
Player.BWudi=false
self.wait=0
self.die=true
if (self.cs ~= nil) then
CS.invoke(self.cs,"EndStart")
CS.invoke(self.cs,"ReturnComponentToPool")
self.cs=nil
end
end
end
function SingleBomb.defaults(self)
self.target=nil
self.cs=nil
self.cardDisplay=nil
self.type=nil
self.time=0
self.wait=0
self.die=false
end
-- AnimationClip.cs SHA256 84e564cb28aa7ddabf972bd44bf634cf17f7268695a2075b909356bc7f7ba9db
AnimationClip={__get={},__set={}}
AnimationClip.__index=function(o,k) local getter=AnimationClip.__get[k];if getter then return getter(o) end;return AnimationClip[k] end
AnimationClip.__newindex=function(o,k,v) local setter=AnimationClip.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function AnimationClip.__get.CurrentFrame(self) return CS.trunc(self.currentFrame) end
function AnimationClip:IsFinished()

do return (self.currentFrame >= CS.f((CS.idiv(self.frames.Count,2)))) end
end
function AnimationClip:Play()

self.currentFrame=CS.f(CS.f(0))
end
function AnimationClip:Update(delta)

self.currentFrame=CS.f((self.currentFrame + delta))
do local __switch1=self.mode
repeat
if __switch1==ClipMode.Loop then
self.currentFrame=CS.f((self.currentFrame % CS.idiv(self.frames.Count,2)))
break
elseif __switch1==ClipMode.Once then
self.currentFrame=CS.f(CS.invoke(Math,"Min",self.currentFrame,CS.idiv(self.frames.Count,2)))
break
end
until true
end
end
function AnimationClip:GetXIndex()

local num=CS.invoke(Math,"Min",CS.trunc(self.currentFrame),(CS.idiv(self.frames.Count,2) - 1))
do return self.frames[(num * 2)] end
end
function AnimationClip:GetYIndex()

local num=CS.invoke(Math,"Min",CS.trunc(self.currentFrame),(CS.idiv(self.frames.Count,2) - 1))
do return self.frames[((num * 2) + 1)] end
end
function AnimationClip:Copy()

do return CS.as(CS.copy(self),"AnimationClip") end
end
function AnimationClip.defaults(self)
self.mode=0
self.name=nil
self.frames=CS.List({})
self.interval=1
self.currentFrame=0
end
-- AnimationMachine.cs SHA256 ddebd864d5003e03fa1bde094df38c836bbc708b7cf849d4c4636c7f2206686f
AnimationMachine={__get={},__set={}}
AnimationMachine.__index=function(o,k) local getter=AnimationMachine.__get[k];if getter then return getter(o) end;return AnimationMachine[k] end
AnimationMachine.__newindex=function(o,k,v) local setter=AnimationMachine.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function AnimationMachine:AddClip(clip)

CS.invoke(self.clips,"Add",CS.invoke(clip,"Copy"))
end
function AnimationMachine:Connect(a,b)

local animationClip=AnimationMachine.Get(self,a)
local animationClip2=AnimationMachine.Get(self,b)
if ((animationClip ~= nil) and (animationClip2 ~= nil)) then
self.connections[animationClip]=animationClip2
end
end
function AnimationMachine:Play(name)

local animationClip=AnimationMachine.Get(self,name)
if (animationClip ~= nil) then
self.playingclip=animationClip
CS.invoke(self.playingclip,"Play")
end
end
function AnimationMachine:Get(name)

do return CS.invoke(self.clips,"Find",function(item) return (item.name == name) end) end
end
function AnimationMachine:GetCurrent()

do return self.playingclip end
end
function AnimationMachine:Update()

if (self.playingclip ~= nil) then
CS.invoke(self.playingclip,"Update",(Time.Stop / CS.f(self.playingclip.interval)))
if (CS.invoke(self.playingclip,"IsFinished") and CS.invoke(self.connections,"ContainsKey",self.playingclip)) then
self.playingclip=self.connections[self.playingclip]
CS.invoke(self.playingclip,"Play")
end
end
end
function AnimationMachine:GetXIndex()

if (self.playingclip ~= nil) then
do return CS.invoke(self.playingclip,"GetXIndex") end
end
do return (-1) end
end
function AnimationMachine:GetYIndex()

if (self.playingclip ~= nil) then
do return CS.invoke(self.playingclip,"GetYIndex") end
end
do return (-1) end
end
function AnimationMachine.defaults(self)
self.clips=CS.List({})
self.connections=CS.Dictionary({})
self.playingclip=nil
end
return _ENV
end
