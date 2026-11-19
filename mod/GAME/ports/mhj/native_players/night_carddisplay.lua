-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- CardDisplay.cs SHA256 49a209efdeb35619396a16a2a3db81be5c390f4e1ddf027f5c465cf7b4c7e35a
CardDisplay={__get={},__set={}}
CardDisplay.__index=function(o,k) local getter=CardDisplay.__get[k];if getter then return getter(o) end;return CardDisplay[k] end
CardDisplay.__newindex=function(o,k,v) local setter=CardDisplay.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function CardDisplay.__get.CardName(self) return self.cardname end
function CardDisplay:ctor_4(tex_t,id,name,infinite)

self.tex=tex_t
self.fontpos=CS.copy(CS.new("Vector2",CS.f(628),CS.f(501)))
self.ppos=CS.copy(CS.new("Vector2",CS.f(312),CS.f(500)))
self.cardname=name
if (id ~= nil) then
if (Main.GameMode ~= GameMode.SPELLPRACTICE) then
ReadSCRecord(id)
else
if (Main.GameMode == GameMode.SPELLPRACTICE) then
ReadSPRecord(id)
end
end
end
self.fontpl=CS.f(((CS.invoke(Main.scfont,"MeasureString",self.cardname).X * CS.f(0.5)) + CS.f(10)))
if (self.fontpl >= CS.f(435)) then
self.scaleX=CS.f((CS.f(435) / self.fontpl))
self.fontpl=CS.f((self.fontpl * self.scaleX))
end
self.infinite=infinite
end
function CardDisplay:ctor_3(tex_t,type,subType)
if subType==nil then subType=0 end
self.tex=tex_t
self.fontpos=CS.copy(CS.new("Vector2",CS.f(628),CS.f(651)))
self.ppos=CS.copy(CS.new("Vector2",CS.f(312),CS.f(650)))
do local __switch1=type
repeat
if __switch1==CharacterCard.Bomb then
self.cardname=self.BombCardNames[CS.trunc((((Main.Character - 1) + (Main.Language * 4))))]
break
elseif __switch1==CharacterCard.JueBomb then
self.cardname=self.JueBombCardNames[CS.trunc((((Main.Character - 1) + (Main.Language * 4))))]
break
elseif __switch1==CharacterCard.Special then
self.cardname=self.SpecialCardNames[(subType + (Main.Language * 2))]
break
end
until true
end
self.fontpl=CS.f(((CS.invoke(Main.scfont,"MeasureString",self.cardname).X * CS.f(0.5)) + CS.f(10)))
if (self.fontpl >= CS.f(435)) then
self.scaleX=CS.f((CS.f(435) / self.fontpl))
self.fontpl=CS.f((self.fontpl * self.scaleX))
end
end
function CardDisplay:TextureUpdate(tex_t)

self.tex=tex_t
end
function CardDisplay:Update_1(bonus_i)

self.bonus=bonus_i
self.time=self.time+1
if (self.time <= 50) then
self.palpha=CS.f((self.palpha + CS.f(0.1)))
if (self.palpha >= CS.f(1)) then
self.palpha=CS.f(CS.f(1))
end
self.fontalpha=CS.f((self.fontalpha + CS.f(0.05)))
if (self.fontalpha >= CS.f(1)) then
self.fontalpha=CS.f(CS.f(1))
end
self.fontpos.X=CS.f((self.fontpos.X + ((((CS.f(625) - self.fontpl) - self.fontpos.X)) / CS.f(10))))
else
if ((self.time >= 50) and (self.time <= 170)) then
self.fontpos.Y=CS.f((self.fontpos.Y + (((CS.f(45) - self.fontpos.Y)) / CS.f(20))))
self.ppos.Y=CS.f((self.ppos.Y + (((CS.f(44) - self.ppos.Y)) / CS.f(20))))
else
if (self.time == 171) then
self.fontpos.Y=CS.f(CS.f(45.5))
self.ppos.Y=CS.f(CS.f(44))
end
end
end
if ((self.time > 100) and (self.time <= 140)) then
self.nalpha=CS.f((self.nalpha + CS.f(0.025)))
end
end
function CardDisplay:Update_0()

self.time=self.time+1
if (self.time <= 171) then
self.palpha=CS.f((self.palpha + CS.f(0.1)))
if (self.palpha >= CS.f(1)) then
self.palpha=CS.f(CS.f(1))
end
self.fontalpha=CS.f((self.fontalpha + CS.f(0.05)))
if (self.fontalpha >= CS.f(1)) then
self.fontalpha=CS.f(CS.f(1))
end
self.fontpos.X=CS.f((self.fontpos.X + ((((CS.f(625) - self.fontpl) - self.fontpos.X)) / CS.f(10))))
else
if (self.time <= 191) then
self.palpha=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.palpha - CS.f(0.1))))
self.fontalpha=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.fontalpha - CS.f(0.05))))
end
end
do return (self.time >= 191) end
end
function CardDisplay:ctor(...) local n=select("#",...);if n==4 then return CardDisplay.ctor_4(self,...);elseif (n>=2 and n<=3) then return CardDisplay.ctor_3(self,...) end;error("原作方法参数数目不符：CardDisplay.ctor") end
function CardDisplay:Update(...) local n=select("#",...);if n==1 then return CardDisplay.Update_1(self,...);elseif n==0 then return CardDisplay.Update_0(self,...) end;error("原作方法参数数目不符：CardDisplay.Update") end
function CardDisplay.defaults(self)
self.BombCardNames=CS.arrayValues({[0]="\"Eternal Night Dream Born\"",[1]="Mad Love \"Overload Extreme Spark\"",[2]="Summon Wind \"Raging Waves and Angry Tides\"",[3]="Mount Fuji \"Eastern Sea's Breathtaking View\"",[4]="「永夜梦想天生」",[5]="狂恋「过载极限火花」",[6]="唤风「狂澜怒涛」",[7]="富岳「东海天绝景」",[8]="「永夜夢想天生」",[9]="狂戀「過載極限火花」",[10]="喚風「狂瀾怒濤」",[11]="富嶽「東海天絕景」",[12]="「永夜夢想天生」",[13]="狂恋「オーバーロードマスタースパーク」",[14]="喚風「狂瀾怒涛」",[15]="富嶽「東海天絶景」",[16]="«Рождённая мечтой вечной ночи»",[17]="Перегруженные искры",[18]="Волна ветра",[19]="Гора Фуюэ «Вид на небо Японии»"})
self.JueBombCardNames=CS.arrayValues({[0]="Miracle \"Kōan's Divine Wind\"",[1]="\"Phoenix - The Legend of Immortality\"",[2]="Divine Tech \"Eight Directions Dragon Slaying Formation\"",[3]="\"Comet\"",[4]="奇迹「弘安的神风」",[5]="「火鸟 -不死传说-」",[6]="神技「八方龙杀阵」",[7]="「彗星」",[8]="奇迹「弘安的神風」",[9]="「火鳥 -不死傳説-」",[10]="神技「八方龍殺陣」",[11]="「彗星」",[12]="奇跡「弘安の神風」",[13]="「火の鳥 -不死伝説-」",[14]="神技「八方龍殺陣」",[15]="「ブレイジングスター」",[16]="Чудо «Камикадзе Хироана»",[17]="Жар-птица - Легенда о бессмертном",[18]="Хакурей «Убийственная форма дракона»",[19]="«Комета»"})
self.SpecialCardNames=CS.arrayValues({[0]="\"Immortal Sacrifice\"",[1]="\"Phoenix Rebirth\"",[2]="「不死之身的舍身击」",[3]="「不死鸟重生」",[4]="「不死之身的捨身擊」",[5]="「不死鳥重生」",[6]="「不死身の捨て身」",[7]="「不死鳥の再生」",[8]="«Бессмертное самопожертвование»",[9]="«Возрождение бессмертной птицы»"})
self.tex=nil
self.cardname=nil
self.time=0
self.fontalpha=0
self.fontpos=CS.Vector2()
self.fontpl=0
self.scaleX=CS.f(1)
self.palpha=0
self.ppos=CS.Vector2()
self.nalpha=0
self.bonus=0
self.BonusChars=CS.array(9,function() return nil end)
self.timeStr=""
self.infinite=false
end
return _ENV
end
