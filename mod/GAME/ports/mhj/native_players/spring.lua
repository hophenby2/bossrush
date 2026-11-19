-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- EquipShoot.cs SHA256 3f6785279c7f4d069b4ee2620108ff3f663ddba5f7415f1d9758a1ab058a1b73
EquipShoot={__get={},__set={}}
EquipShoot.__index=function(o,k) local getter=EquipShoot.__get[k];if getter then return getter(o) end;return EquipShoot[k] end
EquipShoot.__newindex=function(o,k,v) local setter=EquipShoot.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function EquipShoot:Init()

self.btime=CS.f(CS.f(0))
self.ctime=CS.f(CS.f(0))
end
function EquipShoot:BEquipShoot(s,t,p)

self.btime=CS.f((self.btime + Time.Stop))
EquipShoot.NORMAL(self,s,t,p)
end
function EquipShoot:CEquipShoot(b,em,s,t,p,sprt)

self.ctime=CS.f((self.ctime + Time.Stop))
do local __switch1=t
repeat
if __switch1==Cname.REIMU then
EquipShoot.H_AMULET(self,s,p,sprt)
break
elseif __switch1==Cname.MARISA then
EquipShoot.D_TORPEDO(self,b,em,s,p,sprt)
break
elseif __switch1==Cname.SANAE then
EquipShoot.S_BOMB(self,s,p,sprt)
break
elseif true then
EquipShoot.EM_BLAST(self,s,p,sprt)
break
end
until true
end
end
function EquipShoot:NORMAL(s,t,p)

if (self.btime >= CS.f(3)) then
CS.invoke(Program.main.game,"PlaySound","plst",true,p.X)
local r=CS.copy(CS.Rectangle())
local o=CS.copy(CS.Vector2())
local alpha_f=CS.f(0)
local scale_v=CS.copy(CS.Vector2())
local power=CS.f(0)
do local __switch2=t
repeat
if __switch2==Cname.REIMU then
r=CS.copy(CS.new("Rectangle",8,0,28,59))
o=CS.copy(CS.new("Vector2",CS.f(14),CS.f(26)))
scale_v=CS.copy(CS.new("Vector2",CS.f(0.9),CS.f(0.9)))
alpha_f=CS.f(CS.f(0.7))
power=CS.f(CS.f(13))
break
elseif __switch2==Cname.MARISA then
r=CS.copy(CS.new("Rectangle",43,7,23,38))
o=CS.copy(CS.new("Vector2",CS.f(11),CS.f(15)))
scale_v=CS.copy(CS.new("Vector2",CS.f(0.9),CS.f(0.9)))
alpha_f=CS.f(CS.f(0.7))
power=CS.f(CS.f(7))
break
elseif __switch2==Cname.SANAE then
r=CS.copy(CS.new("Rectangle",78,6,22,40))
o=CS.copy(CS.new("Vector2",CS.f(11),CS.f(19)))
scale_v=CS.copy(CS.new("Vector2",CS.f(0.9),CS.f(0.9)))
alpha_f=CS.f(CS.f(0.8))
power=CS.f(CS.f(13))
break
elseif __switch2==Cname.YOUMU then
r=CS.copy(CS.new("Rectangle",108,9,25,44))
o=CS.copy(CS.new("Vector2",CS.f(12),CS.f(17)))
scale_v=CS.copy(CS.new("Vector2",CS.f(0.9),CS.f(0.9)))
alpha_f=CS.f(CS.f(0.5))
power=CS.f(CS.f(17))
break
end
until true
end
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",s,r,o,CS.new("Vector2",(p.X - CS.f(10)),(p.Y + CS.f(10))),CS.f(4),alpha_f,scale_v)
selfBarrage.speed=CS.f(CS.f(22))
selfBarrage.speedd=CS.f((-CS.f(90)))
selfBarrage.power=CS.f(power)
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",s,r,o,CS.new("Vector2",(p.X + CS.f(10)),(p.Y + CS.f(10))),CS.f(4),alpha_f,scale_v)
selfBarrage2.speed=CS.f(CS.f(22))
selfBarrage2.speedd=CS.f((-CS.f(90)))
selfBarrage2.power=CS.f(power)
self.btime=CS.f(CS.f(0))
end
end
function EquipShoot:H_AMULET(s,p,sprt)

if (self.ctime >= CS.f(7)) then
do
local i=0
while (i < sprt.Count) do
local __break3,__continue3=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",s,CS.new("Rectangle",22,111,13,42),CS.new("Vector2",CS.f(6),CS.f(20)),(sprt[i].position + p),CS.f(0),CS.f(1),CS.new("Vector2",CS.f(1),CS.f(1)))
selfBarrage.chase=true
selfBarrage.power=CS.f(CS.f(16))
selfBarrage.speed=CS.f(CS.f(9))
selfBarrage.speedd=CS.f(CS.f(270))
until true
if __break3 then break end
i=i+1
end
end
self.ctime=CS.f(CS.f(0))
end
end
function EquipShoot:D_TORPEDO(boss,em,s,p,sprt)

do
local i=0
while (i < sprt.Count) do
local __break4,__continue4=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",s,CS.new("Rectangle",50,110,33,40),CS.new("Vector2",CS.f(16),(-CS.f(9))),(sprt[i].position + p),CS.f(0),CS.f(1),CS.new("Vector2",CS.f(1),CS.f(1)))
selfBarrage.color.a=CS.f(1)
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
selfBarrage.alpha=CS.f(CS.f(0.5))
end
selfBarrage.straight=true
selfBarrage.dx=CS.f((sprt[i].position.X - CS.f(93)))
selfBarrage.dy=CS.f(sprt[i].position.Y)
selfBarrage.scale.X=CS.f(CS.f(1))
selfBarrage.speed=CS.f(CS.f(39.52))
if (selfBarrage.dx > (-CS.f(72))) then
selfBarrage.speedd=CS.f((-CS.f(86)))
else
if (selfBarrage.dx < (-CS.f(114))) then
selfBarrage.speedd=CS.f((-CS.f(94)))
else
selfBarrage.speedd=CS.f((-CS.f(90)))
end
end
local dir=CS.copy(CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",selfBarrage.speedd))),CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",selfBarrage.speedd)))))
CS.invoke(dir,"Normalize")
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
CS.invoke(em,"JudgeRay",selfBarrage.Position,dir,(CS.f(5.2) * Time.Stop))
CS.optionalCall(boss,"JudgeRay",selfBarrage.Position,dir,(CS.f(4.4) * Time.Stop))
else
CS.invoke(em,"JudgeRay",selfBarrage.Position,dir,(CS.f(7.8) * Time.Stop))
CS.optionalCall(boss,"JudgeRay",selfBarrage.Position,dir,(CS.f(6.6) * Time.Stop))
end
until true
if __break4 then break end
i=i+1
end
end
if (not ((self.ctime >= CS.f(10)))) then
do return  end
end
local flag=false
do
local j=0
while (j < sprt.Count) do
local __break5,__continue5=false,false
repeat
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",s,CS.new("Rectangle",51,159,31,17),CS.new("Vector2",CS.f(15),CS.f(0)),(sprt[j].position + p),CS.f(0),CS.f(1),CS.new("Vector2",CS.f(1),CS.f(1)))
selfBarrage2.label=2
selfBarrage2.ignore=true
selfBarrage2.straight=true
selfBarrage2.dx=CS.f((sprt[j].position.X - CS.f(93)))
selfBarrage2.dy=CS.f(sprt[j].position.Y)
selfBarrage2.speed=CS.f(CS.f(10))
if (selfBarrage2.dx > (-CS.f(72))) then
selfBarrage2.speedd=CS.f((-CS.f(86)))
else
if (selfBarrage2.dx < (-CS.f(114))) then
selfBarrage2.speedd=CS.f((-CS.f(94)))
else
selfBarrage2.speedd=CS.f((-CS.f(90)))
end
end
selfBarrage2.scale=CS.copy(CS.new("Vector2",CS.f(0.8),CS.f(0.8)))
flag=true
until true
if __break5 then break end
j=j+1
end
end
if flag then
CS.invoke(Program.main.game,"PlaySound","lazer02",true,p.X)
end
self.ctime=CS.f(CS.f(0))
end
function EquipShoot:S_BOMB(s,p,sprt)

if (not ((self.ctime >= CS.f(6)))) then
do return  end
end
local list=CS.List({})
local extend=CS.f(10)
do
local i=0
while (i < sprt.Count) do
local __break6,__continue6=false,false
repeat
local selfBarrage=CS.invoke(SelfBarrageManager,"Get",s,CS.new("Rectangle",101,115,25,27),CS.new("Vector2",CS.f(13),CS.f(14)),(sprt[i].position + p),extend,CS.f(1),CS.new("Vector2",CS.f(1),CS.f(1)))
local selfBarrage2=CS.invoke(SelfBarrageManager,"Get",s,CS.new("Rectangle",101,115,25,27),CS.new("Vector2",CS.f(13),CS.f(14)),(sprt[i].position + p),extend,CS.f(1),CS.new("Vector2",CS.f(1),CS.f(1)))
CS.invoke(list,"Add",selfBarrage)
CS.invoke(list,"Add",selfBarrage2)
selfBarrage.label=((function() selfBarrage2.label=1;return selfBarrage2.label end)())
selfBarrage.scale=CS.copy(((function() selfBarrage2.scale=CS.copy(CS.new("Vector2",CS.f(0.8),CS.f(0.8)));return selfBarrage2.scale end)()))
selfBarrage.rotate=((function() selfBarrage2.rotate=true;return selfBarrage2.rotate end)())
selfBarrage.speed=CS.f(((function() selfBarrage2.speed=CS.f(CS.f(9));return selfBarrage2.speed end)()))
selfBarrage.power=CS.f(((function() selfBarrage2.power=CS.f(CS.f(0));return selfBarrage2.power end)()))
selfBarrage.instantDead=((function() selfBarrage2.instantDead=true;return selfBarrage2.instantDead end)())
until true
if __break6 then break end
i=i+1
end
end
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
do local __switch7=sprt.Count
repeat
if __switch7==1 then
list[0].speedd=CS.f(269)
list[1].speedd=CS.f(271)
break
elseif __switch7==2 then
list[0].speedd=CS.f(270)
list[2].speedd=CS.f(270)
list[1].speedd=CS.f(272)
list[3].speedd=CS.f(268)
break
elseif __switch7==3 then
list[0].speedd=CS.f(271)
list[1].speedd=CS.f(269)
list[2].speedd=CS.f(270)
list[3].speedd=CS.f(284)
list[4].speedd=CS.f(270)
list[5].speedd=CS.f(256)
break
elseif __switch7==4 then
list[0].speedd=CS.f(272)
list[1].speedd=CS.f(284)
list[2].speedd=CS.f(268)
list[3].speedd=CS.f(256)
list[4].speedd=CS.f(270)
list[5].speedd=CS.f(272)
list[6].speedd=CS.f(270)
list[7].speedd=CS.f(268)
break
end
until true
end
else
do local __switch8=sprt.Count
repeat
if __switch8==1 then
list[0].speedd=CS.f(280)
list[1].speedd=CS.f(260)
break
elseif __switch8==2 then
list[0].speedd=CS.f(270)
list[2].speedd=CS.f(270)
list[1].speedd=CS.f(255)
list[3].speedd=CS.f(285)
break
elseif __switch8==3 then
list[0].speedd=CS.f(280)
list[1].speedd=CS.f(260)
list[2].speedd=CS.f(255)
list[3].speedd=CS.f(240)
list[4].speedd=CS.f(285)
list[5].speedd=CS.f(300)
break
elseif __switch8==4 then
list[0].speedd=CS.f(267)
list[1].speedd=CS.f(257)
list[2].speedd=CS.f(273)
list[3].speedd=CS.f(283)
list[4].speedd=CS.f(250)
list[5].speedd=CS.f(240)
list[6].speedd=CS.f(290)
list[7].speedd=CS.f(300)
break
end
until true
end
end
self.ctime=CS.f(CS.f(0))
end
function EquipShoot:EM_BLAST(s,p,sprt)


end
function EquipShoot.defaults(self)
self.btime=0
self.ctime=0
end
-- Equipment.cs SHA256 ae9605012699d9f0039bed97556c1349c4a5b9b41e9b1d9a58263dcfdc670846
Equipment={__get={},__set={}}
Equipment.__index=function(o,k) local getter=Equipment.__get[k];if getter then return getter(o) end;return Equipment[k] end
Equipment.__newindex=function(o,k,v) local setter=Equipment.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
Equipment.__base="EquipShoot"
function Equipment:ctor(tex_i)

self.tex=tex_i
self.sprites=CS.List({})
end
function Equipment:Reinit()

self.time=CS.f(CS.f(0))
self.inited=false
CS.invoke(self.sprites,"Clear")
end
function Equipment:Init()

self.time2=CS.f(CS.f(0))
Equipment.Reinit(self)
EquipShoot.Init(self)
end
function Equipment:Update(b,em,t,l,pos,Ban)

self.player=CS.copy(pos)
if (l ~= self.level) then
Equipment.Reinit(self)
end
self.level=l
do local __switch1=t
repeat
if __switch1==Cname.REIMU then
Equipment.H_AMULET(self,l,pos,Ban)
break
elseif __switch1==Cname.MARISA then
Equipment.D_TORPEDO(self,l,pos,Ban)
break
elseif __switch1==Cname.SANAE then
Equipment.S_BOMB(self,l,pos,Ban)
break
elseif true then
Equipment.EM_BLAST(self,l,pos,Ban)
break
end
until true
end
if ((not Ban) and ((CS.invoke(Main,"IsKeyDown",Keys.Z) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.ShootOrConfirm)))))) then
EquipShoot.CEquipShoot(self,b,em,self.tex,t,pos,self.sprites)
end
self.time=CS.f((self.time + Time.Stop))
end
function Equipment:Draw(s,quake)

do
local i=0
while (i < self.sprites.Count) do
local __break2,__continue2=false,false
repeat
local position=CS.copy(self.sprites[i].position)
self.sprites[i].position=CS.copy(CS.new("Vector2",((position.X + self.player.X) + quake.X),((position.Y + self.player.Y) + quake.Y)))
CS.invoke(self.sprites[i],"Draw",s,SpriteEffects.None,CS.f(0))
self.sprites[i].position=CS.copy(position)
until true
if __break2 then break end
i=i+1
end
end
end
function Equipment:H_AMULET(l,p,Ban)

if (not self.inited) then
self.inited=true
do
local i=0
while (i < l) do
local __break3,__continue3=false,false
repeat
CS.invoke(self.sprites,"Add",CS.new("Sprite",self.tex,CS.new("Rectangle",12,63,45,41)))
self.sprites[(self.sprites.Count - 1)].origin=CS.copy(CS.new("Vector2",CS.f(23),CS.f(21)))
self.sprites[(self.sprites.Count - 1)].scale=CS.copy(Vector2.Zero)
self.sprites[(self.sprites.Count - 1)].color.a=CS.f(1)
until true
if __break3 then break end
i=i+1
end
end
do local __switch4=l
repeat
if __switch4==1 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
break
elseif __switch4==2 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch4==3 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
self.sprites[1].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[2].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch4==4 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(20)),(-CS.f(25))))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(20),(-CS.f(25))))
self.sprites[2].position=CS.copy(CS.new("Vector2",(-CS.f(35)),CS.f(0)))
self.sprites[3].position=CS.copy(CS.new("Vector2",CS.f(35),CS.f(0)))
break
end
until true
end
end
do
local j=0
while (j < self.sprites.Count) do
local __break5,__continue5=false,false
repeat
self.sprites[j].scale=CS.copy((self.sprites[j].scale + CS.new("Vector2",CS.f(0.06),CS.f(0.06))))
if (self.sprites[j].scale.X >= CS.f(0.8)) then
self.sprites[j].scale=CS.copy(CS.new("Vector2",CS.f(0.8),CS.f(0.8)))
end
self.sprites[j].rotation=(self.sprites[j].rotation - (CS.f(5) * Time.Stop))
if (self.sprites[j].rotation < CS.f(0)) then
self.sprites[j].rotation=(CS.f(360) - self.sprites[j].rotation)
end
until true
if __break5 then break end
j=j+1
end
end
if (Time.Stop ~= CS.f(1)) then
do return  end
end
if ((not Ban) and (((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))))) then
do local __switch6=l
repeat
if __switch6==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch6==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(5)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(5) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(30)) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch6==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + ((((-CS.f(10)) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(25)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(10) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(25)) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch6==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(15)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(25)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(15) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(25)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + ((((-CS.f(5)) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(30)) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(5) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + ((((-CS.f(30)) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
else
do local __switch7=l
repeat
if __switch7==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch7==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(30)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + (((CS.f(0) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(30) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch7==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + ((((-CS.f(30)) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(30) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch7==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(20)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(25)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(20) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(25)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + ((((-CS.f(35)) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(35) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + (((CS.f(0) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
end
end
function Equipment:D_TORPEDO(l,p,Ban)

if (not self.inited) then
self.inited=true
do
local i=0
while (i < l) do
local __break8,__continue8=false,false
repeat
CS.invoke(self.sprites,"Add",CS.new("Sprite",self.tex,CS.new("Rectangle",146,61,41,40)))
self.sprites[(self.sprites.Count - 1)].origin=CS.copy(CS.new("Vector2",CS.f(21),CS.f(20)))
self.sprites[(self.sprites.Count - 1)].scale=CS.copy(Vector2.Zero)
self.sprites[(self.sprites.Count - 1)].color.a=CS.f(1)
until true
if __break8 then break end
i=i+1
end
end
do local __switch9=l
repeat
if __switch9==1 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
break
elseif __switch9==2 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(20)),CS.f(0)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(20),CS.f(0)))
break
elseif __switch9==3 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
self.sprites[1].position=CS.copy(CS.new("Vector2",(-CS.f(20)),CS.f(0)))
self.sprites[2].position=CS.copy(CS.new("Vector2",CS.f(20),CS.f(0)))
break
elseif __switch9==4 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(14)),(-CS.f(25))))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(14),(-CS.f(25))))
self.sprites[2].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[3].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
end
until true
end
end
do
local j=0
while (j < self.sprites.Count) do
local __break10,__continue10=false,false
repeat
self.sprites[j].scale=CS.copy((self.sprites[j].scale + CS.new("Vector2",CS.f(0.06),CS.f(0.06))))
if (self.sprites[j].scale.X >= CS.f(0.5)) then
self.sprites[j].scale=CS.copy(CS.new("Vector2",(CS.f(0.5) + (CS.f(0.3) * CS.invoke(Math,"Abs",CS.f(CS.invoke(Math,"Sin",(((self.time / CS.f(40))) * Math.PI)))))),(CS.f(0.5) + (CS.f(0.3) * CS.invoke(Math,"Abs",CS.f(CS.invoke(Math,"Sin",(((self.time / CS.f(40))) * Math.PI))))))))
end
until true
if __break10 then break end
j=j+1
end
end
if (Time.Stop == CS.f(1)) then
if ((not Ban) and (((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))))) then
do local __switch11=l
repeat
if __switch11==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch11==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(0) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(40)) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch11==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(0) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(40)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(0) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(40)) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch11==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(0) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(40)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(0) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(40)) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(0) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + ((((-CS.f(40)) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
else
do local __switch12=l
repeat
if __switch12==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch12==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(50)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + (((CS.f(0) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(50) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch12==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + ((((-CS.f(50)) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(50) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch12==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(20)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(40)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(20) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(40)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + ((((-CS.f(50)) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(50) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + (((CS.f(0) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
end
end
for _,item in CS.each(SelfBarrageManager.SBArray) do
local __break13,__continue13=false,false
repeat
if (((item.label == 2) and CS.invoke(Main,"IsKeyUp",Keys.Z)) and ((Main.Replay or CS.invoke(PadState,"IsKeyUp",JOYKEYS.ShootOrConfirm)))) then
item.Judged=true
else
if ((item.label == 2) and item.Judged) then
item.color.g=(item.color.g - CS.f(0.1))
item.color.b=(item.color.b - CS.f(0.1))
if (item.color.g <= CS.f(0)) then
item.color=CS.new("Colors",CS.f(1),CS.f(0),CS.f(0),CS.f(1))
end
end
end
until true
if __break13 then break end
end
end
function Equipment:S_BOMB(l,p,Ban)

if (not self.inited) then
self.inited=true
do
local i=0
while (i < l) do
local __break14,__continue14=false,false
repeat
CS.invoke(self.sprites,"Add",CS.new("Sprite",self.tex,CS.new("Rectangle",103,61,41,41)))
self.sprites[(self.sprites.Count - 1)].origin=CS.copy(CS.new("Vector2",CS.f(20),CS.f(21)))
self.sprites[(self.sprites.Count - 1)].scale=CS.copy(Vector2.Zero)
self.sprites[(self.sprites.Count - 1)].color.a=CS.f(1)
until true
if __break14 then break end
i=i+1
end
end
do local __switch15=l
repeat
if __switch15==1 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
break
elseif __switch15==2 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch15==3 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),(-CS.f(30))))
self.sprites[1].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[2].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch15==4 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(22)),CS.f(10)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(22),CS.f(10)))
self.sprites[2].position=CS.copy(CS.new("Vector2",(-CS.f(40)),CS.f(0)))
self.sprites[3].position=CS.copy(CS.new("Vector2",CS.f(40),CS.f(0)))
break
end
until true
end
end
do
local j=0
while (j < self.sprites.Count) do
local __break16,__continue16=false,false
repeat
self.sprites[j].scale=CS.copy((self.sprites[j].scale + CS.new("Vector2",CS.f(0.06),CS.f(0.06))))
if (self.sprites[j].scale.X >= CS.f(0.8)) then
self.sprites[j].scale=CS.copy(CS.new("Vector2",CS.f(0.8),CS.f(0.8)))
end
self.sprites[j].rotation=(self.sprites[j].rotation + (CS.f(10) * Time.Stop))
until true
if __break16 then break end
j=j+1
end
end
if (Time.Stop == CS.f(1)) then
if ((not Ban) and (((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))))) then
do local __switch17=l
repeat
if __switch17==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch17==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(17)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(11)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(17) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(11)) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch17==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + ((((-CS.f(20)) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(10)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(20) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(10)) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch17==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(12)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(25)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(12) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + ((((-CS.f(25)) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + ((((-CS.f(26)) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + ((((-CS.f(5)) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(26) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + ((((-CS.f(5)) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
else
do local __switch18=l
repeat
if __switch18==1 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
break
elseif __switch18==2 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(30)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + (((CS.f(0) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(30) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
break
elseif __switch18==3 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + (((CS.f(0) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + ((((-CS.f(30)) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + ((((-CS.f(30)) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(0) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + (((CS.f(30) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
break
elseif __switch18==4 then
self.sprites[0].position.X=CS.f((self.sprites[0].position.X + ((((-CS.f(22)) - self.sprites[0].position.X)) / CS.f(5))))
self.sprites[0].position.Y=CS.f((self.sprites[0].position.Y + (((CS.f(10) - self.sprites[0].position.Y)) / CS.f(5))))
self.sprites[1].position.X=CS.f((self.sprites[1].position.X + (((CS.f(22) - self.sprites[1].position.X)) / CS.f(5))))
self.sprites[1].position.Y=CS.f((self.sprites[1].position.Y + (((CS.f(10) - self.sprites[1].position.Y)) / CS.f(5))))
self.sprites[2].position.X=CS.f((self.sprites[2].position.X + ((((-CS.f(40)) - self.sprites[2].position.X)) / CS.f(5))))
self.sprites[2].position.Y=CS.f((self.sprites[2].position.Y + (((CS.f(0) - self.sprites[2].position.Y)) / CS.f(5))))
self.sprites[3].position.X=CS.f((self.sprites[3].position.X + (((CS.f(40) - self.sprites[3].position.X)) / CS.f(5))))
self.sprites[3].position.Y=CS.f((self.sprites[3].position.Y + (((CS.f(0) - self.sprites[3].position.Y)) / CS.f(5))))
break
end
until true
end
end
end
for _,item in CS.each(SelfBarrageManager.SBArray) do
local __break19,__continue19=false,false
repeat
if ((item.label == 1) and item.Judged) then
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"1",CS.new("Vector2",(item.Position.X + CS.f(93)),(item.Position.Y - CS.f(13))))
CS.invoke(crazyStorm,"UnderBarrage")
crazyStorm.isforshoot=true
CS.invoke(crazyStorm,"BanSound",true)
CS.invoke(crazyStorm.shoot,"AddRange",CS.List({[0]=0,[1]=1}))
crazyStorm.effect=true
crazyStorm.allpan=true
crazyStorm.bomb=true
item.Judged=true
item.label=0
end
until true
if __break19 then break end
end
end
function Equipment:EM_BLAST(l,p,Ban)

if (not self.inited) then
self.inited=true
local crazyStorm=CS.invoke(Program.main.game,"FindEffect","e2")
if (crazyStorm ~= nil) then
crazyStorm=nil
end
do
local i=0
while (i < l) do
local __break20,__continue20=false,false
repeat
CS.invoke(self.sprites,"Add",CS.new("Sprite",self.tex,CS.new("Rectangle",0,200,50,50)))
self.sprites[(self.sprites.Count - 1)].origin=CS.copy(CS.new("Vector2",CS.f(25),CS.f(25)))
self.sprites[(self.sprites.Count - 1)].scale=CS.copy(Vector2.Zero)
self.sprites[(self.sprites.Count - 1)].color.a=CS.f(1)
until true
if __break20 then break end
i=i+1
end
end
do local __switch21=l
repeat
if __switch21==1 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(30)))
break
elseif __switch21==2 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch21==3 then
self.sprites[0].position=CS.copy(CS.new("Vector2",CS.f(0),CS.f(30)))
self.sprites[1].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[2].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
elseif __switch21==4 then
self.sprites[0].position=CS.copy(CS.new("Vector2",(-CS.f(16)),CS.f(21)))
self.sprites[1].position=CS.copy(CS.new("Vector2",CS.f(16),CS.f(21)))
self.sprites[2].position=CS.copy(CS.new("Vector2",(-CS.f(30)),CS.f(0)))
self.sprites[3].position=CS.copy(CS.new("Vector2",CS.f(30),CS.f(0)))
break
end
until true
end
end
do
local j=0
while (j < self.sprites.Count) do
local __break22,__continue22=false,false
repeat
self.sprites[j].rect.X=(CS.rem(CS.idiv(CS.trunc(self.time),5),7) * 50)
self.sprites[j].scale=CS.copy((self.sprites[j].scale + CS.new("Vector2",CS.f(0.06),CS.f(0.06))))
if (self.sprites[j].scale.X >= CS.f(0.8)) then
self.sprites[j].scale=CS.copy(CS.new("Vector2",CS.f(0.8),CS.f(0.8)))
end
self.sprites[j].position.Y=CS.f((self.sprites[j].position.Y + (CS.f(0.1) * CS.f(CS.invoke(Math,"Sin",(((((self.time + CS.f(j))) / CS.f(40))) * Math.PI))))))
until true
if __break22 then break end
j=j+1
end
end
local crazyStorm2=CS.invoke(Program.main.game,"FindEffect","e2")
if (crazyStorm2 ~= nil) then
self.time2=CS.f((self.time2 + Time.Stop))
CS.invoke(crazyStorm2,"SetPos",CS.new("Vector2",(p.X + CS.f(93)),(p.Y - CS.f(13))),true)
if (self.time2 == CS.f(88)) then
CS.invoke(Program.main.game,"PlaySound","battou",true,p.X)
end
if (CS.invoke(Main,"IsKeyUp",Keys.Z) and ((Main.Replay or CS.invoke(PadState,"IsKeyUp",JOYKEYS.ShootOrConfirm)))) then
if (self.time2 < CS.f(65)) then
CS.invoke(Program.main.game,"StopSound","ch00")
CS.invoke(crazyStorm2,"Break")
else
if (self.time2 >= CS.f(65)) then
self.releaseReady=true
if (self.time2 < CS.f(90)) then
self.autoRelease=true
end
end
end
else
if (self.releaseReady and ((CS.invoke(Main,"IsKeyDown",Keys.Z) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.ShootOrConfirm)))))) then
self.releasable=true
end
end
if ((l >= 1) and (((((self.autoRelease and self.releasable) and (self.time2 >= CS.f(90)))) or (((not self.autoRelease) and self.releasable))))) then
if ((CS.invoke(Main,"IsPreKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsPreKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsPreKeyDown",JOYKEYS.Slow,Main.prepadstat)))) then
self.ps=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((2 + l)),"ToString"),CS.new("Vector2",(p.X + CS.f(93)),(p.Y - CS.f(13))))
self.ps.allpan=true
do local __switch23=l
repeat
if __switch23==1 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=2,[1]=44}))
break
elseif __switch23==2 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=3,[1]=4,[2]=22,[3]=22}))
break
elseif __switch23==3 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=4,[1]=5,[2]=6,[3]=22,[4]=22,[5]=22}))
break
elseif __switch23==4 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=5,[1]=6,[2]=7,[3]=8,[4]=22,[5]=22,[6]=22,[7]=22}))
break
end
until true
end
else
self.ps=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((19 + l)),"ToString"),CS.new("Vector2",(p.X + CS.f(93)),(p.Y - CS.f(13))))
do local __switch24=l
repeat
if __switch24==1 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=4,[1]=5,[2]=6,[3]=38,[4]=38,[5]=38}))
break
elseif __switch24==2 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=5,[1]=6,[2]=7,[3]=8,[4]=46,[5]=46,[6]=46,[7]=46}))
break
elseif __switch24==3 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=6,[1]=7,[2]=8,[3]=9,[4]=10,[5]=54,[6]=54,[7]=54,[8]=54,[9]=54}))
break
elseif __switch24==4 then
CS.invoke(self.ps.shoot,"AddRange",CS.List({[0]=7,[1]=8,[2]=9,[3]=10,[4]=11,[5]=12,[6]=62,[7]=62,[8]=62,[9]=62,[10]=62,[11]=62}))
break
end
until true
end
end
self.ptime=CS.f(CS.f(0))
CS.invoke(self.ps,"UnderBarrage")
self.ps.isforshoot=true
CS.invoke(self.ps,"BanSound",true)
self.ps.effect=true
self.ps.bomb=true
CS.invoke(Program.main.game,"PlaySound","iainuki",true,p.X)
self.time2=CS.f(CS.f(0))
self.autoRelease=false
self.releaseReady=false
self.releasable=false
CS.invoke(crazyStorm2,"Break")
end
if Ban then
self.autoRelease=false
self.releaseReady=false
self.releasable=false
CS.invoke(crazyStorm2,"Break")
end
else
if ((((not Ban) and (l >= 1)) and ((CS.invoke(Main,"IsKeyDown",Keys.Z) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.ShootOrConfirm)))))) and (crazyStorm2 == nil)) then
self.time2=CS.f(CS.f(0))
local crazyStorm3=CS.invoke(Program.main.game,"PlayEffect",true,"2",CS.new("Vector2",(p.X + CS.f(93)),(p.Y - CS.f(13))))
CS.invoke(crazyStorm3,"UnderBarrage")
crazyStorm3.isforshoot=true
CS.invoke(crazyStorm3,"BanSound",true)
crazyStorm3.effect=true
crazyStorm3.specialnotkill=true
CS.invoke(crazyStorm3,"SetOPos",CS.new("Vector2",(p.X + CS.f(93)),(p.Y - CS.f(13))))
CS.invoke(Program.main.game,"PlaySound","ch00",true,p.X)
end
end
end
function Equipment.defaults(self)
self.tex=nil
self.sprites=nil
self.time=0
self.time2=0
self.ptime=0
self.inited=false
self.autoRelease=false
self.releaseReady=false
self.releasable=false
self.level=0
self.player=CS.Vector2()
self.ps=nil
end
-- SelfBarrage.cs SHA256 817c01d9aee3d98f66622268672537b8d02ce8bccd70ef0ce086311a3e8b6b24
SelfBarrage={__get={},__set={}}
SelfBarrage.__index=function(o,k) local getter=SelfBarrage.__get[k];if getter then return getter(o) end;return SelfBarrage[k] end
SelfBarrage.__newindex=function(o,k,v) local setter=SelfBarrage.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
SelfBarrage.__base="SelfBarrageManager"
function SelfBarrage:Update(em,target,boss,Player)

local num=(Player.body.position.X + CS.f(93))
local num2=(Player.body.position.Y - CS.f(13))
if (not self.straight) then
self.time=CS.f((self.time + Time.Stop))
else
self.time=CS.f((self.time + CS.f(1)))
end
self.speedx=CS.f((self.speed * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",self.speedd)))))
self.speedy=CS.f((self.speed * CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",self.speedd)))))
self.Position.X=CS.f((self.Position.X + (self.speedx * Time.Stop)))
self.Position.Y=CS.f((self.Position.Y + (self.speedy * Time.Stop)))
if ((self.straight and (not Player.Dis)) and (not Player.Ban)) then
self.Position.X=CS.f(((num + self.dx) + ((self.time * self.speed) * CS.f(CS.invoke(Math,"Cos",CS.invoke(MathHelper,"ToRadians",self.speedd))))))
self.Position.Y=CS.f(((num2 + self.dy) + ((self.time * self.speed) * CS.f(CS.invoke(Math,"Sin",CS.invoke(MathHelper,"ToRadians",self.speedd))))))
end
local num3=CS.f(0)
if (self.speed ~= CS.f(0)) then
if (self.speedy ~= CS.f(0)) then
num3=CS.f(((CS.f(Math.PI) / CS.f(2)) - CS.f(CS.invoke(Math,"Atan",(self.speedx / self.speedy)))))
if (self.speedy < CS.f(0)) then
num3=CS.f((num3 + CS.f(Math.PI)))
end
else
if (self.speedx >= CS.f(0)) then
num3=CS.f(CS.f(0))
end
if (self.speedx < CS.f(0)) then
num3=CS.f(CS.f(Math.PI))
end
end
if (self.speed > CS.f(0)) then
self.speedd=CS.f(CS.invoke(MathHelper,"ToDegrees",num3))
if self.rotate then
self.rotation=CS.f((self.rotation + (CS.f(5) * Time.Stop)))
else
self.rotation=CS.f(self.speedd)
end
else
if self.rotate then
self.rotation=CS.f((self.rotation + (CS.f(5) * Time.Stop)))
else
self.rotation=CS.f(CS.invoke(MathHelper,"ToDegrees",num3))
end
end
end
if ((not self.Judged) or self.straight) then
self.color.a=(self.color.a + CS.f(0.5))
if (self.color.a >= self.alpha) then
self.color.a=self.alpha
end
local vector=CS.copy(CS.new("Vector2",(-CS.f(50)),CS.f(450)))
local vector2=CS.copy(CS.new("Vector2",(-CS.f(50)),CS.f(490)))
if self.chase then
local num4=(-CS.f(1))
local num5=(-CS.f(1))
local num6=(-CS.f(1))
local num7=CS.f(0)
local num8=CS.f(0)
local num9=CS.f(0)
if ((boss ~= nil) and CS.invoke(boss,"IsTarget")) then
num5=CS.f(CS.f(CS.invoke(Math,"Sqrt",((((self.Position.X - boss.Position.X)) * ((self.Position.X - boss.Position.X))) + (((self.Position.Y - boss.Position.Y)) * ((self.Position.Y - boss.Position.Y)))))))
num8=CS.f(CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",boss.Position.X,boss.Position.Y,self.Position.X,self.Position.Y)))
if (num8 <= CS.f(0)) then
num8=CS.f((CS.f(360) + num8))
end
end
if (target ~= nil) then
num6=CS.f(CS.f(CS.invoke(Math,"Sqrt",((((self.Position.X - target.Position.X)) * ((self.Position.X - target.Position.X))) + (((self.Position.Y - target.Position.Y)) * ((self.Position.Y - target.Position.Y)))))))
num9=CS.f(CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",target.Position.X,target.Position.Y,self.Position.X,self.Position.Y)))
if (num9 <= CS.f(0)) then
num9=CS.f((CS.f(360) + num9))
end
end
if (num5 ~= (-CS.f(1))) then
num4=CS.f(num5)
num7=CS.f(num8)
end
if (num6 ~= (-CS.f(1))) then
num4=CS.f(num6)
num7=CS.f(num9)
end
if (((num5 ~= (-CS.f(1))) and (num6 ~= (-CS.f(1)))) and (num5 < num6)) then
num4=CS.f(num5)
num7=CS.f(num8)
else
if ((num5 ~= (-CS.f(1))) and (num6 ~= (-CS.f(1)))) then
num4=CS.f(num6)
num7=CS.f(num9)
end
end
if (((self.speedd > CS.f(180)) and (num7 < CS.f(180))) and (CS.invoke(Math,"Abs",(self.speedd - num7)) > CS.f(180))) then
num7=CS.f((num7 + CS.f(360)))
end
if (num4 ~= (-CS.f(1))) then
self.speedd=CS.f((self.speedd + ((((num7 - self.speedd)) / ((num4 / self.speed))) * CS.f(1.5))))
end
end
if ((((self.Position.X < vector.X) or (self.Position.X > vector.Y)) or (self.Position.Y < vector2.X)) or (self.Position.Y > vector2.Y)) then
self.needDelete=true
end
if (not self.ignore) then
local num10=CS.invoke(em,"Judge",self.Position,(self.power * Time.Stop),self.extend)
if ((num10 ~= CS.f(0)) and (num10 ~= CS.f(0))) then
self.Judged=true
Program.main.game.Score=(Program.main.game.Score + 10)
end
if (boss ~= nil) then
num10=CS.f(CS.invoke(boss,"Judge",self.Position,(self.power * Time.Stop),self.extend))
if (num10 ~= CS.f(0)) then
self.Judged=true
Program.main.game.Score=(Program.main.game.Score + 10)
end
end
end
if (self.Judged and self.straight) then
self.color.g=(self.color.g - CS.f(0.1))
self.color.b=(self.color.b - CS.f(0.1))
if (self.color.g <= CS.f(0)) then
self.color=CS.new("Colors",CS.f(1),CS.f(0),CS.f(0),CS.f(1))
end
end
else
self.speed=CS.f(CS.f(2))
self.scale.X=CS.f((self.scale.X + CS.f(0.2)))
self.scale.Y=CS.f((self.scale.Y + CS.f(0.2)))
self.color.a=(self.color.a - (CS.choose(self.instantDead,function() return CS.f(0.14) end,function() return CS.f(0.07) end)))
if (self.color.a <= CS.f(0)) then
self.needDelete=true
end
end
end
function SelfBarrage:Draw(s,q)

CS.invoke(s,"End")
CS.invoke(s,"Begin",SpriteSortMode.Deferred,BlendState.Additive)
CS.invoke(s,"Draw",self.shape,CS.new("Vector2",(self.Position.X + q.X),(self.Position.Y + q.Y)),self.rect,CS.new("Color",self.color.r,self.color.g,self.color.b,self.color.a),CS.invoke(MathHelper,"ToRadians",(self.rotation + CS.f(90))),self.origin,self.scale,SpriteEffects.None,CS.f(0))
CS.invoke(s,"End")
CS.invoke(s,"Begin",SpriteSortMode.Deferred,BlendState.NonPremultiplied)
end
function SelfBarrage.defaults(self)
self.shape=nil
self.Position=CS.Vector2()
self.rect=CS.Rectangle()
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
self.dx=0
self.dy=0
self.label=0
self.extend=0
self.straight=false
self.ignore=false
self.chase=false
self.rotate=false
self.instantDead=false
self.needDelete=false
self.Judged=false
end
-- SingleBomb.cs SHA256 9afd788d2ac3a80be6babab4c038c94c1a862431d757d232db05229919389a83
SingleBomb={__get={},__set={}}
SingleBomb.__index=function(o,k) local getter=SingleBomb.__get[k];if getter then return getter(o) end;return SingleBomb[k] end
SingleBomb.__newindex=function(o,k,v) local setter=SingleBomb.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function SingleBomb.__get.Die(self) return self.die end
function SingleBomb:ctor(Player,type_C,pos)

self.type=type_C
CS.invoke(Program.main.game,"PlaySound","nep00",true,pos.X)
do local __switch1=self.type
repeat
if __switch1==Cname.REIMU then
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
self.tex=CS.new("Sprite")
self.target=CS.new("Character",self.tex)
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"15",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=15,[1]=36}))
Player.BanBEShoot=true
Player.BanEShoot=true
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"33",CS.new("Vector2",pos.X,CS.f(370)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=8,[1]=9,[2]=8,[3]=8}))
end
break
elseif __switch1==Cname.MARISA then
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"16",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs,"SetOPos",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=2,[1]=30}))
CS.invoke(Program.main.game,"Quake",CS.trunc(((CS.f(self.cs.time.total) * CS.f(0.95)))),2)
Player.BanBEShoot=true
Player.BanEShoot=true
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"34",CS.new("Vector2",CS.f(315),CS.f(240)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=6,[1]=6}))
end
break
elseif __switch1==Cname.SANAE then
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"19",CS.new("Vector2",CS.f(315),CS.f(240)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=16,[1]=40}))
Player.BanBEShoot=true
Player.BanEShoot=true
else
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"17",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=14,[1]=3}))
end
break
elseif __switch1==Cname.YOUMU then
if ((CS.invoke(Main,"IsKeyDown",Keys.LeftShift) or CS.invoke(Main,"IsKeyDown",Keys.RightShift)) or (((not Main.Replay) and CS.invoke(PadState,"IsKeyDown",JOYKEYS.Slow)))) then
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"18",CS.new("Vector2",CS.f(315),CS.f(240)))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=13,[1]=14,[2]=80,[3]=80}))
Player.BanBEShoot=true
Player.BanEShoot=true
else
self.tex=CS.new("Sprite")
self.target=CS.new("Character",self.tex)
self.cs=CS.invoke(Program.main.game,"PlayEffect",false,"35",CS.new("Vector2",pos.X,pos.Y))
CS.invoke(self.cs.shoot,"AddRange",CS.List({[0]=10,[1]=11}))
end
break
end
until true
end
CS.invoke(self.cs,"BanSound",true)
self.cs.effect=true
self.cs.bomb=true
self.cs.allpan=true
self.cs.clearb=true
self.time=0
end
function SingleBomb:Update(Player,csm,em,boss)

local player=Player
self.time=self.time+1
if (self.time <= 40) then
Program.main.game.bgcolor.a=(Program.main.game.bgcolor.a + CS.f(0.015))
if (Program.main.game.bgcolor.a >= CS.f(1)) then
Program.main.game.bgcolor.a=CS.f(1)
end
end
if (Player.BWudi and (CS.rem(self.time,6) < 3)) then
Player.body.color.r=CS.f(0)
Player.body.color.g=CS.f(0)
else
Player.body.color.r=CS.f(1)
Player.body.color.g=CS.f(1)
end
if (self.cs ~= nil) then
if (self.target ~= nil) then
local vector=CS.copy(CS.new("Vector2",CS.f(42),CS.f(406)))
local vector2=CS.copy(CS.new("Vector2",CS.f(43),CS.f(453)))
self.target.body.position.X=CS.f(CS.f(224))
self.target.body.position.Y=CS.f(CS.f(144))
for _,item in CS.each(em.EnemyArray) do
local __break2,__continue2=false,false
repeat
if (((((not item.die) and (item.Position.X >= vector.X)) and (item.Position.X <= vector.Y)) and (item.Position.Y >= vector2.X)) and (item.Position.Y <= vector2.Y)) then
self.target.body.position=CS.copy(item.Position)
__break2=true;break
end
until true
if __break2 then break end
end
if ((boss ~= nil) and (not boss.leave)) then
self.target.body.position=CS.copy(boss.Position)
end
player=self.target
end
do local __switch3=self.type
repeat
if __switch3==Cname.MARISA then
if (self.cs.Id == "e16") then
CS.invoke(self.cs,"SetPos",CS.new("Vector2",(Player.body.position.X + CS.f(93)),(Player.body.position.Y - CS.f(13))),true)
Player.speedadd=CS.copy(CS.new("Vector2",CS.f(0.15),CS.f(0.02)))
end
break
elseif __switch3==Cname.SANAE then
if ((self.cs.Id == "e17") and (self.time == 300)) then
Player.BWudi=false
end
break
elseif __switch3==Cname.YOUMU then
if (self.time == 120) then
CS.invoke(Program.main.game,"Quake",100,2)
end
break
end
until true
end
end
if (self.cs == nil) then
if (self.wait == 0) then
local cname=self.type
if (cname == Cname.MARISA) then
Player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
end
Player.BanEShoot=false
Player.BanBEShoot=false
end
self.wait=self.wait+1
Program.main.game.bgcolor.a=(Program.main.game.bgcolor.a - CS.f(0.015))
if (Program.main.game.bgcolor.a <= CS.f(0)) then
Program.main.game.bgcolor.a=CS.f(0)
end
if (self.wait == 40) then
Player.body.color.r=CS.f(1)
Player.body.color.g=CS.f(1)
self.wait=0
self.die=true
end
else
if CS.invoke(self.cs,"IsClosing") then
CS.invoke(self.cs,"EndStart")
CS.invoke(self.cs,"Break")
CS.invoke(self.cs,"ReturnComponentToPool")
self.cs=nil
else
if CS.invoke(self.cs,"Run") then
CS.invoke(self.cs,"Update",player,em,boss)
end
end
end
end
function SingleBomb.defaults(self)
self.target=nil
self.cs=nil
self.tex=nil
self.type=nil
self.time=0
self.wait=0
self.die=false
end
return _ENV
end
