-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- SpecialSystem.cs SHA256 771f9d23347a5bbcfed2688222ccaaf42648acba05282d4a8ac3a8579dd86783
SpecialSystem={__get={},__set={}}
SpecialSystem.__index=function(o,k) local getter=SpecialSystem.__get[k];if getter then return getter(o) end;return SpecialSystem[k] end
SpecialSystem.__newindex=function(o,k,v) local setter=SpecialSystem.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function SpecialSystem.__get.Status(self) return self.status end
function SpecialSystem.__get.Power(self) do return self.power end end
function SpecialSystem.__set.Power(self,value) self.power=value end
function SpecialSystem.__get.Blue(self) do return self.blue end end
function SpecialSystem.__set.Blue(self,value) self.blue=value end
function SpecialSystem.__get.MaxBlue(self) do return self.maxBlue end end
function SpecialSystem.__set.MaxBlue(self,value) self.maxBlue=value end
function SpecialSystem.__get.Graze(self) do return self.graze end end
function SpecialSystem.__set.Graze(self,value) self.graze=value end
function SpecialSystem.__get.RecordScore(self) return self.recordscore end
function SpecialSystem.__get.BonusOrder(self) do return self.bonusOrder end end
function SpecialSystem.__set.BonusOrder(self,value) self.bonusOrder=value end
function SpecialSystem.__get.CurrentLevel(self) return self.currentLevel end
function SpecialSystem.__get.OpenCount(self) return self.opencount end
function SpecialSystem:ctor(gb,sps,bl)

self.hipower=self.Hipower[CS.trunc(((Main.Level - 1)))]
self.color=CS.f(CS.f(1))
self.grazebox=gb
self.spscore=sps
self.bosslist=bl
self.opencount=0
end
function SpecialSystem:Reset()

self.power=0
self.hipower=self.Hipower[CS.trunc(((Main.Level - 1)))]
self.blue=0
self.maxBlue=0
self.maxBlueDisplay=0
self.bonusOrder=0
self.bonusOrderDisplay=0
self.bonusLevelDisplay=0
self.graze=0
self.lightx=0
self.color=CS.f(CS.f(1))
end
function SpecialSystem:Pause()

self.pause=true
end
function SpecialSystem:Recover()

self.pause=false
end
function SpecialSystem:Break(player,motivated)

if (self.status ~= SakuraStatus.OPENING) then
do return  end
end
CS.invoke(self.e29,"Break")
CS.invoke(self.e30,"Break")
CS.invoke(Program.main.game,"PlaySound","sakura01",true,CS.invoke(player,"Position").X)
CS.invoke(Program.main.game,"StopSound","sakura00")
self.e31=CS.invoke(Program.main.game,"PlayEffect",true,"31",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e31,"UnderActor")
CS.invoke(self.e31,"SetOPos",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e31,"BanSound",true)
self.e31.effect=true
self.bonusOrder=self.bonusOrder+1
if (CS.rem(self.bonusOrder,3) == 0) then
do
local i=0
while (i < self.currentLevel) do
local __break1,__continue1=false,false
repeat
CS.invoke(Program.main.game,"LifeItem",CS.new("Vector2",player.body.position.X,(-CS.f(20))))
until true
if __break1 then break end
i=i+1
end
end
else
do
local j=0
while (j < self.currentLevel) do
local __break2,__continue2=false,false
repeat
CS.invoke(Program.main.game,"BombItem",CS.new("Vector2",player.body.position.X,(-CS.f(20))))
until true
if __break2 then break end
j=j+1
end
end
end
self.power=0
self.blue=0
self.maxBlue=0
self.maxBlueDisplay=0
self.graze=0
self.opentime=0
self.closetime=0
self.flashalpha=CS.f(CS.f(0))
player.SWudi=true
self.status=SakuraStatus.CLOSING
player.breakedInBoss=true
self.breaking=true
if motivated then
SpecialSystem.BaseBonus(self,player)
end
end
function SpecialSystem:Over(player)

if (self.status == SakuraStatus.OPENING) then
CS.invoke(self.e29,"Break")
CS.invoke(self.e30,"Break")
CS.invoke(Program.main.game,"PlaySound","sakura01",true,CS.invoke(player,"Position").X)
CS.invoke(Program.main.game,"StopSound","sakura00")
self.e32=CS.invoke(Program.main.game,"PlayEffect",true,"32",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e32,"UnderActor")
CS.invoke(self.e32,"SetOPos",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e32,"BanSound",true)
self.e32.effect=true
self.opentime=0
self.closetime=0
self.flashalpha=CS.f(CS.f(0))
SpecialSystem.Bonus(self,player)
player.SWudi=true
self.status=SakuraStatus.CLOSING
end
end
function SpecialSystem:BaseBonus(player)

self.recordscore=2000000
self.recordposition=CS.copy(player.body.position)
Program.main.game.Score=(Program.main.game.Score + self.recordscore)
self.scorealpha=CS.f(CS.f(1))
self.scoretime=0
end
function SpecialSystem:Bonus(player)

local num=Program.main.game.MaxBlue
self.recordscore=((((((((num + self.maxBlue) + (self.graze * 400))) * self.blue) * CS.invoke(Math,"Pow",CS.f(2.0),(self.currentLevel - 1))) * 2) / 10) + 5000000)
self.recordposition=CS.copy(player.body.position)
self.recordscore=(self.recordscore - CS.rem(self.recordscore,10))
if (self.recordscore >= 0) then
self.bonusOrder=self.bonusOrder+1
Program.main.game.Score=(Program.main.game.Score + self.recordscore)
if (CS.rem(self.bonusOrder,3) == 0) then
do
local i=0
while (i < self.currentLevel) do
local __break3,__continue3=false,false
repeat
CS.invoke(Program.main.game,"LifeItem",CS.new("Vector2",player.body.position.X,(-CS.f(20))))
until true
if __break3 then break end
i=i+1
end
end
else
do
local j=0
while (j < self.currentLevel) do
local __break4,__continue4=false,false
repeat
CS.invoke(Program.main.game,"BombItem",CS.new("Vector2",player.body.position.X,(-CS.f(20))))
until true
if __break4 then break end
j=j+1
end
end
end
end
self.scorealpha=CS.f(CS.f(1))
self.scoretime=0
self.blue=0
Program.main.game.MaxBlue=(Program.main.game.MaxBlue + self.maxBlue)
self.maxBlue=0
self.graze=0
end
function SpecialSystem:IsFullLevel()

do return (self.opentime >= (self.LayerScale * 3)) end
end
function SpecialSystem:Update(csm,em,boss,player)

do local __switch5=self.status
repeat
if __switch5==SakuraStatus.CLOSED then
self.infoDisplayAlpha=CS.f((self.infoDisplayAlpha + (((CS.f(0) - self.infoDisplayAlpha)) / CS.f(20))))
if (((self.power >= self.hipower) and (not self.pause)) and (not player.IsBombing)) then
self.power=self.hipower
CS.invoke(Program.main.game,"PlaySound","sakura00",true,CS.invoke(player,"Position").X)
self.e29=CS.invoke(Program.main.game,"PlayEffect",true,"29",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e29,"UnderActor")
CS.invoke(self.e29,"SetOPos",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e29,"BanSound",true)
self.e29.effect=true
self.e30=CS.invoke(Program.main.game,"PlayEffect",true,"30",CS.new("Vector2",CS.f(315),CS.f(240)))
CS.invoke(self.e30,"UnderActor")
CS.invoke(self.e30,"BanSound",true)
self.e30.effect=true
player.SAuto=true
player.SWudi=true
self.opentime=self.LayerScale
self.currentLevel=1
self.status=SakuraStatus.OPENING
self.opencount=self.opencount+1
self.infoDisplayXPos=CS.f(CS.f(100))
end
break
elseif __switch5==SakuraStatus.OPENING then
self.maxBlueDisplay=self.maxBlue
self.bonusOrderDisplay=self.bonusOrder
self.bonusLevelDisplay=self.currentLevel
self.infoDisplayXPos=CS.f((self.infoDisplayXPos + (((CS.f(60) - self.infoDisplayXPos)) / CS.f(10))))
self.infoDisplayAlpha=CS.f((self.infoDisplayAlpha + (((CS.f(1) - self.infoDisplayAlpha)) / CS.f(10))))
if (CS.idiv(self.opentime,self.LayerScale) > self.currentLevel) then
self.currentLevel=self.currentLevel+1
self.power=self.hipower
end
if (CS.rem(self.opentime,self.LayerScale) == 0) then
self.levelwordscale=CS.f(CS.f(1.5))
self.levelwordalpha=CS.f(CS.f(0))
end
if (self.opentime == (self.LayerScale + 60)) then
player.SWudi=false
end
if (self.opentime <= (self.LayerScale * 3)) then
self.opentime=self.opentime+1
end
self.powertime=self.powertime+1
if ((CS.rem(self.powertime,5) == 0) and (not self.pause)) then
self.power=(self.power - CS.idiv(self.hipower,100))
end
if (self.power <= 0) then
CS.invoke(self.e29,"Break")
CS.invoke(self.e30,"Break")
CS.invoke(Program.main.game,"PlaySound","sakura01",true,CS.invoke(player,"Position").X)
CS.invoke(Program.main.game,"StopSound","sakura00")
self.e32=CS.invoke(Program.main.game,"PlayEffect",true,"32",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e32,"UnderActor")
CS.invoke(self.e32,"SetOPos",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
CS.invoke(self.e32,"BanSound",true)
self.e32.effect=true
self.closetime=0
SpecialSystem.Bonus(self,player)
player.SWudi=true
self.opentime=0
self.status=SakuraStatus.CLOSING
end
self.flashalpha=CS.f((CS.f(self.power) / CS.f(self.hipower)))
CS.invoke(self.e29,"SetPos",CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))),true)
break
elseif __switch5==SakuraStatus.CLOSING then
self.closetime=self.closetime+1
if (self.breaking and (self.closetime <= 60)) then
local vector=CS.copy(CS.new("Vector2",(CS.invoke(player,"Position").X + CS.f(93)),(CS.invoke(player,"Position").Y - CS.f(13))))
if (csm ~= nil) then
for _,item in CS.each(csm.csc) do
local __break6,__continue6=false,false
repeat
for _,item2 in CS.each(item.layerm.LayerArray) do
local __break7,__continue7=false,false
repeat
for _,barrage in CS.each(item2.Barrages) do
local __break8,__continue8=false,false
repeat
if (((((not barrage.Dis) and (CS.bitop("|",((barrage.time > 15)),(not barrage.Mist)))) and (not barrage.NeedDelete)) and (not barrage.Invincible)) and (CS.invoke(Math,"Sqrt",((((barrage.x - vector.X)) * ((barrage.x - vector.X))) + (((barrage.y - vector.Y)) * ((barrage.y - vector.Y))))) < CS.invoke(Math,"Abs",(self.closetime * 10)))) then
if ((barrage.life > 2) and (barrage.alpha >= CS.f(70))) then
CS.invoke(Program.main.game,"SmallItem",CS.new("Vector2",(barrage.x - CS.f(93)),(barrage.y + CS.f(13)))).spbreak=true
end
barrage.time=((1 + barrage.add) + barrage.life)
barrage.Dis=true
barrage.Blend=true
barrage.randf=(CS.f(10) * CS.f(CS.invoke(Main.rand,"NextDouble")))
end
until true
if __break8 then break end
end
until true
if __break7 then break end
end
until true
if __break6 then break end
end
end
end
if (self.closetime >= 60) then
self.breaking=false
player.SAuto=false
player.SWudi=false
self.levelwordscale=CS.f(CS.f(1.5))
self.levelwordalpha=CS.f(CS.f(0))
self.powertime=0
self.currentLevel=0
self.status=SakuraStatus.CLOSED
end
break
end
until true
end
self.levelwordscale=CS.f((self.levelwordscale + (((CS.f(1) - self.levelwordscale)) / CS.f(10))))
self.levelwordalpha=CS.f((self.levelwordalpha + (((CS.f(1) - self.levelwordalpha)) / CS.f(5))))
self.power=CS.trunc(CS.invoke(MathHelper,"Clamp",self.power,CS.f(0),self.hipower))
if ((self.scoretime <= 60) and (self.scorealpha == CS.f(1))) then
self.scoretime=self.scoretime+1
self.recordposition.Y=CS.f((self.recordposition.Y - CS.f(1)))
else
if (self.scorealpha > CS.f(0)) then
self.scorealpha=CS.f((self.scorealpha - CS.f(0.016)))
if (self.scorealpha < CS.f(0)) then
self.scorealpha=CS.f(CS.f(0))
end
end
end
end
function SpecialSystem:Draw(s)

do
local i=0
while (i < 40) do
local __break9,__continue9=false,false
repeat
self.grazebox.position=CS.copy(CS.new("Vector2",(27 + (i * 3)),CS.f(428)))
self.grazebox.rect=CS.copy(CS.new("Rectangle",(i * 3),0,3,40))
self.grazebox.color.a=(CS.f(0.8) * self.color)
if (CS.invoke(Math,"Abs",((33 + (i * 3)) - self.lightx)) <= 25) then
self.grazebox.color.a=(((CS.f(1) - ((CS.f(CS.invoke(Math,"Abs",((33 + (i * 3)) - self.lightx))) / CS.f(25)) * CS.f(0.2)))) * self.color)
end
CS.invoke(self.grazebox,"Draw",s,SpriteEffects.None,CS.f(0))
until true
if __break9 then break end
i=i+1
end
end
local num=(CS.f(self.power) / CS.f(self.hipower))
if (num >= CS.f(1)) then
num=CS.f(CS.f(1))
end
self.grazebox.position=CS.copy(CS.new("Vector2",CS.f(27),CS.f(428)))
self.grazebox.rect=CS.copy(CS.new("Rectangle",0,200,(31 + CS.trunc(((CS.f(67) * num)))),40))
self.grazebox.color.a=(CS.f(0.8) * self.color)
CS.invoke(self.grazebox,"Draw",s,SpriteEffects.None,CS.f(0))
if (self.flashalpha > CS.f(0)) then
CS.invoke(s,"End")
CS.invoke(s,"Begin",SpriteSortMode.Deferred,BlendState.Additive)
self.grazebox.rect=CS.copy(CS.new("Rectangle",0,200,120,40))
self.grazebox.color.a=(self.flashalpha * self.color)
CS.invoke(self.grazebox,"Draw",s,SpriteEffects.None,CS.f(0))
CS.invoke(s,"End")
CS.invoke(s,"Begin",SpriteSortMode.Deferred,BlendState.NonPremultiplied)
end
self.grazebox.position=CS.copy(CS.new("Vector2",CS.f(27),CS.f(428)))
self.grazebox.rect=CS.copy(CS.new("Rectangle",0,(((self.currentLevel + 1)) * 40),120,40))
self.grazebox.scale=CS.copy((CS.new("Vector2",CS.f(1),CS.f(1)) * self.levelwordscale))
self.grazebox.color.a=((CS.f(0.8) * self.color) * self.levelwordalpha)
CS.invoke(self.grazebox,"Draw",s,SpriteEffects.None,CS.f(0))
self.grazebox.scale=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
self.lightx=self.lightx+1
if (self.lightx >= 160) then
self.lightx=(-30)
end
local num2=CS.invoke(StringHelper,"IntParse",self.scoreChars,self.recordscore)
local num3=(self.scoreChars.Length - num2)
CS.invoke(s,"Draw",self.bosslist,(self.recordposition - CS.new("Vector2",((CS.f(12) * CS.f(((num3 + 1)))) / CS.f(2)),CS.f(15))),CS.new("Rectangle",12,234,12,16),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),(self.scorealpha * self.color)),CS.f(0),Vector2.Zero,CS.f(1),SpriteEffects.None,CS.f(0))
do
local j=num2
while (j < self.scoreChars.Length) do
local __break10,__continue10=false,false
repeat
local num4=(self.scoreChars[j] - 48)
CS.invoke(s,"Draw",self.bosslist,(self.recordposition - CS.new("Vector2",(((CS.f(12) * CS.f(((num3 - 1)))) / CS.f(2)) - CS.f(((((j - num2)) * 12)))),CS.f(15))),CS.new("Rectangle",(24 + (num4 * 12)),234,12,16),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),(self.scorealpha * self.color)),CS.f(0),Vector2.Zero,CS.f(1),SpriteEffects.None,CS.f(0))
until true
if __break10 then break end
j=j+1
end
end
CS.invoke(StringHelper,"IntParse",self.PowerChars,self.power,false," ")
do
local k=0
while (k < self.PowerChars.Length) do
local __break11,__continue11=false,false
repeat
if (self.PowerChars[k] ~= " ") then
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(81 + (k * 4)),CS.f(446)),CS.new("Rectangle",(((self.PowerChars[k] - 48)) * 4),0,4,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),self.color))
end
until true
if __break11 then break end
k=k+1
end
end
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(101),CS.f(446)),CS.new("Rectangle",44,0,4,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),self.color))
CS.invoke(StringHelper,"IntParse",self.HiPowerChars,self.hipower,false," ")
do
local l=0
while (l < self.HiPowerChars.Length) do
local __break12,__continue12=false,false
repeat
if (self.HiPowerChars[l] ~= " ") then
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(105 + (l * 4)),CS.f(446)),CS.new("Rectangle",(((self.HiPowerChars[l] - 48)) * 4),0,4,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),self.color))
end
until true
if __break12 then break end
l=l+1
end
end
if (CS.rem(((self.bonusOrderDisplay + 1)),3) == 0) then
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(self.infoDisplayXPos - CS.f(7)),CS.f(431)),CS.new("Rectangle",73,0,9,9),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
else
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(self.infoDisplayXPos - CS.f(7)),CS.f(431)),CS.new("Rectangle",64,0,9,9),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
end
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",((self.infoDisplayXPos - CS.f(7)) + CS.f(10)),CS.f(432)),CS.new("Rectangle",50,8,5,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",((self.infoDisplayXPos - CS.f(7)) + CS.f(15)),CS.f(432)),CS.new("Rectangle",(self.bonusLevelDisplay * 5),8,5,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(self.infoDisplayXPos + CS.f(20)),CS.f(432)),CS.new("Rectangle",55,0,9,9),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",((self.infoDisplayXPos + CS.f(20)) + CS.f(10)),CS.f(432)),CS.new("Rectangle",50,8,5,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
local bitCountOfInt=CS.invoke(StringHelper,"GetBitCountOfInt",self.maxBlueDisplay)
do
local m=0
while (m < bitCountOfInt) do
local __break13,__continue13=false,false
repeat
local bitByBigEndian=CS.invoke(StringHelper,"GetBitByBigEndian",self.maxBlueDisplay,bitCountOfInt,m)
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",(((self.infoDisplayXPos + CS.f(20)) + CS.f(15)) + CS.f(((m * 5)))),CS.f(432)),CS.new("Rectangle",(bitByBigEndian * 5),8,5,8),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),((self.color * self.infoDisplayAlpha) * CS.f(0.8))))
until true
if __break13 then break end
m=m+1
end
end
end
function SpecialSystem:ChangeAlpha(pp)

local num=CS.invoke(Math,"Sqrt",((((pp.X - CS.f(27))) * ((pp.X - CS.f(27)))) + ((((pp.Y - CS.f(458))) * ((pp.Y - CS.f(458)))) * CS.f(4))))
if ((num >= CS.f(80.0)) and (num <= CS.f(150.0))) then
num=(num / CS.f(150.0))
self.color=CS.f(CS.f((((num * num) * num))))
else
if (num > CS.f(150.0)) then
self.color=CS.f(CS.f(1))
end
end
end
function SpecialSystem.defaults(self)
self.Hipower=CS.arrayValues({[0]=5000,[1]=8000,[2]=9000,[3]=10000,[4]=8000,[5]=8000})
self.LayerScale=600
self.status=0
self.e29=nil
self.e30=nil
self.e31=nil
self.e32=nil
self.opentime=0
self.powertime=0
self.closetime=0
self.scoretime=60
self.power=0
self.PowerChars=CS.array(5,function() return nil end)
self.hipower=0
self.HiPowerChars=CS.array(5,function() return nil end)
self.blue=0
self.maxBlue=0
self.maxBlueDisplay=0
self.graze=0
self.scoreChars=CS.array(9,function() return nil end)
self.recordscore=0
self.recordposition=CS.Vector2()
self.scorealpha=0
self.lightx=0
self.color=0
self.grazebox=nil
self.spscore=nil
self.bosslist=nil
self.flashalpha=0
self.pause=false
self.infoDisplayAlpha=0
self.infoDisplayXPos=0
self.levelwordalpha=0
self.levelwordscale=CS.f(1.5)
self.bonusOrder=0
self.bonusOrderDisplay=0
self.breaking=false
self.currentLevel=0
self.bonusLevelDisplay=0
self.opencount=0
end
return _ENV
end
