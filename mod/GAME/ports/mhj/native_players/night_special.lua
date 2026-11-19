-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- SpecialSystem.cs SHA256 92fa3a9119e1c98da5d177887c2f63dc086ce23e1ed8848fb780e9aa9e67b65c
SpecialSystem={__get={},__set={}}
SpecialSystem.__index=function(o,k) local getter=SpecialSystem.__get[k];if getter then return getter(o) end;return SpecialSystem[k] end
SpecialSystem.__newindex=function(o,k,v) local setter=SpecialSystem.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function SpecialSystem.__get.Status(self) return self.status end
function SpecialSystem.__get.Closing(self) if (self.status ~= LanternStatus.BREAKCLOSING) then
do return (self.status == LanternStatus.OVERCLOSING) end
end
do return true end end
function SpecialSystem.__get.Power(self) do return self.power end end
function SpecialSystem.__set.Power(self,value) if ((self.protectChance == 0) and (Program.main.game.CurrentHyperChallenge ~= 2)) then
local num=(value - self.power)
if ((num > 0) and (Program.main.game.CurrentEnergyChallenge == 1)) then
num=(num / 2)
self.power=(CS.choose(((self.power > self.setting.HiPower)),function() return ((self.power + CS.idiv(num,2))) end,function() return ((self.power + num)) end))
else
self.power=(CS.choose(((self.power > self.setting.HiPower)),function() return ((self.power + CS.idiv(num,2))) end,function() return value end))
end
end end
function SpecialSystem.__set.PowerRaw(self,value) self.power=value end
function SpecialSystem.__get.Blue(self) do return self.blue end end
function SpecialSystem.__set.Blue(self,value) self.blue=value end
function SpecialSystem.__get.MaxBlue(self) do return self.maxBlue end end
function SpecialSystem.__set.MaxBlue(self,value) self.maxBlue=value end
function SpecialSystem.__get.Graze(self) do return self.graze end end
function SpecialSystem.__set.Graze(self,value) self.graze=value end
function SpecialSystem.__get.Energy(self) do return self.energy end end
function SpecialSystem.__set.Energy(self,value) if (value > self.energy) then
self.energyGetTime=0
else
if (value < self.energy) then
self.enegryUseTime=0
end
end
self.energy=CS.invoke(MathHelper,"Clamp",value,0,3)
if ((value == 3) and (self.itemEnergy > 0)) then
self.itemEnergy=0
self.itemProduced=true
end end
function SpecialSystem.__set.EnergyRaw(self,value) self.energy=CS.invoke(MathHelper,"Clamp",value,0,3) end
function SpecialSystem.__get.ItemEnergy(self) do return self.itemEnergy end end
function SpecialSystem.__set.ItemEnergy(self,value) if (((((not self.itemProduced) and (self.energy < 3)) and (not self.banTeammate)) and (((self.status == LanternStatus.OPENING) or (((((not Main.Replay) or CS.invoke(RPYInfo,"VersionEnergyItemWhenLanternReleasing",Main.ReplayContent))) and (self.status == LanternStatus.RELEASING)))))) and (Program.main.game.CurrentCrystalChallenge ~= 2)) then
self.itemEnergy=value
end end
function SpecialSystem.__set.ItemEnergyRaw(self,value) self.itemEnergy=value end
function SpecialSystem.__get.ItemEnergyLimit(self) local num=self.setting.ItemEnergyLimit
if (Main.Level == Difficulty.LUNATIC) then
num=CS.trunc(((CS.f(num) * CS.f(1.5))))
else
if (Main.Level == Difficulty.ULTRA) then
num=CS.trunc(((CS.f(num) * CS.f(2))))
end
end
if (Program.main.game.CurrentCrystalChallenge == 1) then
num=(num * 3)
end
do return num end end
function SpecialSystem.__get.ItemProduced(self) return self.itemProduced end
function SpecialSystem.__get.BanTeammate(self) do return self.BanTeammate end end
function SpecialSystem.__set.BanTeammate(self,value) self.banTeammate=value end
function SpecialSystem.__get.StayTime(self) return self.stayTime end
function SpecialSystem.__get.BossDamageLimit(self) return self.bossDamageLimit end
function SpecialSystem.__get.RecordScore(self) return self.recordscore end
function SpecialSystem.__get.ProtectChance(self) return self.protectChance end
function SpecialSystem.__get.OverCountInStage(self) do return self.overCountInStage end end
function SpecialSystem.__set.OverCountInStage(self,value) self.overCountInStage=value end
function SpecialSystem.__set.LSCConditionShow(self,value) self.lscConditionShow=value end
function SpecialSystem.__set.LSCConditionTip(self,value) self.lscConditionTip=value end
function SpecialSystem.__get.Teammate(self) return self.teammate end
function SpecialSystem:ctor(spscore_t,spset)

self.spscore=spscore_t
self.fire=CS.new("Sprite",self.spscore,CS.new("Rectangle",1088,0,80,180))
self.fire.position=CS.copy(CS.new("Vector2",CS.f(34),CS.f(558)))
self.fire.scale=CS.copy(CS.new("Vector2",CS.f(0.75),CS.f(0.75)))
local clip=CS.initialize(CS.new("AnimationClip"),{["name"]="Fire",["interval"]=5,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0,[14]=7,[15]=0,[16]=8,[17]=0,[18]=9,[19]=0,[20]=10,[21]=0,[22]=11,[23]=0})})
CS.invoke(self.fire,"AddClip",clip)
CS.invoke(self.fire,"Play","Fire")
local character=CS.trunc(Main.Character)
local level=CS.trunc(Main.Level)
local array=spset[0]
local array2=spset[(1 + (((character - 1)) * 2))]
local array3=spset[(2 + (((character - 1)) * 2))]
local array4=spset[(8 + level)]
local array5=spset[((8 + CS.invoke(Enum,"GetNames","Difficulty").Length) + 1)]
local array6=spset[((8 + CS.invoke(Enum,"GetNames","Difficulty").Length) + 2)]
self.setting=CS.initialize(CS.new("SpecialSystemSet"),{["HiPower"]=array[0],["PowerUpSecond"]=CS.arrayValues({[0]=array[1],[1]=array[2],[2]=array[3],[3]=array[4]}),["PowerLostSpeed"]=CS.arrayValues({[0]=array[5],[1]=array[6],[2]=array[7],[3]=array[8]}),["BossDamageLimits"]=CS.arrayValues({[0]=CS.arrayValues({[0]=array2[0],[1]=array2[1],[2]=array2[4],[3]=array2[5],[4]=array2[7],[5]=array2[7],[6]=array2[7]}),[1]=CS.arrayValues({[0]=array3[0],[1]=array3[1],[2]=array3[4],[3]=array3[5],[4]=array3[7],[5]=array3[7],[6]=array2[7]})}),["GreenPower"]=CS.arrayValues({[0]=array4[0],[1]=array4[1],[2]=array4[2],[3]=array4[3]}),["GrazePower"]=array4[4],["BluePowerClosed"]=array4[5],["BluePowerOpened"]=array4[6],["BigBluePowerClosed"]=array4[7],["BigBluePowerOpened"]=array4[8],["BreakPower"]=CS.arrayValues({[0]=array4[9],[1]=array4[10]}),["LostPower"]=CS.arrayValues({[0]=array5[(((character - 1)) * 2)],[1]=array5[((((character - 1)) * 2) + 1)]}),["ItemGrowSpeed"]=array6[0],["ItemEnergyLimit"]=array6[1]})
end
function SpecialSystem:Reset(savePower)

if (not savePower) then
self.power=0
self.energy=0
self.itemEnergy=0
self.freakCount=0
end
self.blue=0
self.maxBlue=0
self.graze=0
self.time=0
self.teammate=nil
self.itemProduced=false
end
function SpecialSystem:StartProtect(player,protectEffect,breakEffect1,breakEffect2,breakEffect3)

self.protectChance=3
if (self.protectingEffect ~= nil) then
CS.invoke(self.protectingEffect,"Break")
end
local vector=CS.copy(CS.invoke(player,"Position"))
CS.invoke(Program.main.game,"PlaySound","protect",false,CS.f(0))
self.protectingEffect=CS.invoke(Program.main.game,"PlayEffect",true,protectEffect,vector)
self.protectingEffect.order=CrazyStorm.Order.UnderBarrage
CS.invoke(self.protectingEffect,"SetOPos",vector)
CS.invoke(self.protectingEffect,"BanSound",true)
self.breakEffectNames=CS.arrayValues({[0]=breakEffect3,[1]=breakEffect2,[2]=breakEffect1})
SpecialSystem.Over(self,player)
SpecialSystem.Pause(self)
player.PAuto=true
self.chargeTime=120
SpecialSystem.TeammateWork(self,player)
end
function SpecialSystem:BreakProtect(player,motivated)

if (((self.protectChance ~= 0) and ((motivated or (not player.Wudi)))) and (((not motivated) or (self.protectTime <= 60)))) then
self.protectChance=self.protectChance-1
self.protectTime=90
player.PWudi=true
if (self.protectingEffect ~= nil) then
CS.invoke(self.protectingEffect,"Break")
end
local vector=CS.copy(CS.invoke(player,"Position"))
CS.invoke(Program.main.game,"PlaySound","break",true,vector.X)
self.protectingEffect=CS.invoke(Program.main.game,"PlayEffect",true,self.breakEffectNames[self.protectChance],vector)
self.protectingEffect.order=CrazyStorm.Order.UnderBarrage
CS.invoke(self.protectingEffect,"SetOPos",vector)
CS.invoke(self.protectingEffect,"BanSound",true)
if (self.protectChance == 0) then
self.protectingEffect=nil
player.PAuto=false
self.fire.color.a=CS.f(0)
SpecialSystem.Recover(self)
end
end
end
function SpecialSystem:EndProtect(player,endEffect)

if (self.protectChance ~= 0) then
local vector=CS.copy(CS.invoke(player,"Position"))
CS.invoke(Program.main.game,"PlaySound","bonus",true,vector.X)
local num=self.protectChance
if (Program.main.game.CurrentResourceChallenge == 1) then
num=(num / 2)
else
if (Program.main.game.CurrentResourceChallenge == 2) then
num=0
end
end
do
local i=0
while (i < num) do
local __break1,__continue1=false,false
repeat
CS.invoke(Program.main.game,"BombItem",CS.new("Vector2",vector.X,(-CS.f(20))))
until true
if __break1 then break end
i=i+1
end
end
if (self.protectChance == 3) then
CS.invoke(Program.main.achivmanager,"Check",7)
end
self.protectChance=0
if (self.protectingEffect ~= nil) then
CS.invoke(self.protectingEffect,"Break")
self.protectingEffect=nil
end
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,endEffect,vector)
crazyStorm.order=CrazyStorm.Order.UnderBarrage
CS.invoke(crazyStorm,"SetOPos",vector)
CS.invoke(crazyStorm,"BanSound",true)
player.PAuto=false
self.fire.color.a=CS.f(0)
SpecialSystem.Recover(self)
end
end
function SpecialSystem:EnterRampage(player)

if (Main.Replay and (not CS.invoke(RPYInfo,"VersionAutoSpecialItem",Main.ReplayContent))) then
if (self.status >= LanternStatus.LOSINGCONTROL) then
do return  end
end
if (self.status == LanternStatus.CLOSED) then
self.fire.color.a=CS.f(1)
end
else
if ((self.status == LanternStatus.LOSINGCONTROL) or (self.status == LanternStatus.LOSTCONTROL)) then
do return  end
end
if (((self.status == LanternStatus.CLOSED) or (self.status == LanternStatus.BREAKCLOSING)) or (self.status == LanternStatus.OVERCLOSING)) then
self.fire.color.a=CS.f(1)
end
end
self.power=(self.setting.HiPower * 2)
self.warnEffect=CS.invoke(Program.main.game,"PlayEffect",true,"21",CrazyStorm.DefaultCenter)
self.warnEffect.order=CrazyStorm.Order.Overtop
self.status=LanternStatus.LOSINGCONTROL
player.SWudi=true
self.wudiTime=120
self.stayTime=0
end
function SpecialSystem:Pause()

self.pause=true
end
function SpecialSystem:Recover()

self.pause=false
if (self.status == LanternStatus.OPENING) then
self.recoverTime=180
end
end
function SpecialSystem:Break(player,motivated,source,lostAll,cardTex)
if cardTex==nil then cardTex=nil end
if ((self.status == LanternStatus.CLOSED) or self.Closing) then
do return  end
end
if (self.status == LanternStatus.LOSTCONTROL) then
player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
CS.invoke(self.freakEffect,"Break")
self.freakEffect=nil
end
if motivated then
if (source == BreakSource.Dialog) then
SpecialSystem.Bonus(self,player)
else
SpecialSystem.BaseBonus(self,player)
end
else
self.maxBlue=0
self.graze=0
self.blue=0
end
self.status=LanternStatus.BREAKCLOSING
self.power=(CS.choose(((not lostAll)),function() return (CS.trunc(((CS.f(CS.invoke(Math,"Min",self.power,self.setting.HiPower)) * CS.f(0.99))))) end,function() return 0 end))
player.SWudi=true
self.wudiTime=120
self.stayTime=0
if (((not motivated) and (player.type == Cname.MOKOU)) and ((((source == BreakSource.Boss) or (source == BreakSource.Enemy)) or (source == BreakSource.Familiar)))) then
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,"41",CS.invoke(player,"Position"))
CS.invoke(crazyStorm.shoot,"AddRange",CS.List({[0]=2,[1]=0,[2]=CS.trunc(player.damageSet.A.other3)}))
crazyStorm.isforshoot=true
crazyStorm.ignoreAlpha=true
crazyStorm.clearb=true
self.wudiTime=240
self.power=CS.invoke(Math,"Max",self.power,CS.trunc(((CS.f(self.setting.HiPower) * CS.f(0.5)))))
self.cardDisplay=CS.new("CardDisplay",cardTex,CharacterCard.Special)
Program.main.game.DrawCardDisplay=(Program.main.game.DrawCardDisplay + self.cardDisplay.Draw)
CS.invoke(Program.main.achivmanager,"Check",16)
end
end
function SpecialSystem:Over(player)

if ((self.status ~= LanternStatus.CLOSED) and (not self.Closing)) then
if (self.status == LanternStatus.LOSTCONTROL) then
self.power=(self.setting.HiPower / 2)
player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
CS.invoke(self.freakEffect,"Break")
self.freakEffect=nil
end
SpecialSystem.Bonus(self,player)
self.status=LanternStatus.OVERCLOSING
player.SWudi=false
self.wudiTime=0
self.stayTime=0
end
end
function SpecialSystem:BaseBonus(player)

self.recordscore=5000000
self.recordposition=CS.copy(player.body.position)
Program.main.game.Score=(Program.main.game.Score + self.recordscore)
self.scorealpha=CS.f(CS.f(1))
self.scoretime=0
self.blue=0
self.maxBlue=0
self.graze=0
end
function SpecialSystem:Bonus(player)

local num=CS.f(0)
do local __switch2=Main.Level
repeat
if __switch2==Difficulty.EASY then
num=CS.f(CS.f(0.8))
break
elseif __switch2==Difficulty.NORMAL then
num=CS.f(CS.f(1))
break
elseif __switch2==Difficulty.HARD then
num=CS.f(CS.f(1.5))
break
elseif __switch2==Difficulty.LUNATIC then
num=CS.f(CS.f(2))
break
elseif __switch2==Difficulty.EXTRA then
num=CS.f(CS.f(1.5))
break
elseif __switch2==Difficulty.EXULTIMATE then
num=CS.f(CS.f(1.5))
break
elseif __switch2==Difficulty.ULTRA then
num=CS.f(CS.f(3))
break
end
until true
end
local num2=(Program.main.game.MaxBlue - Program.main.game.LastStageMaxBlue)
self.recordscore=(((CS.f(20000000) * num)) + (((((num2 + self.maxBlue) + (self.graze * 400))) * self.blue) / 2))
self.recordposition=CS.copy(player.body.position)
self.recordscore=(self.recordscore - CS.rem(self.recordscore,10))
if (self.recordscore >= 0) then
Program.main.game.Score=(Program.main.game.Score + self.recordscore)
end
self.scorealpha=CS.f(CS.f(1))
self.scoretime=0
self.blue=0
Program.main.game.MaxBlue=(Program.main.game.MaxBlue + self.maxBlue)
self.maxBlue=0
self.graze=0
end
function SpecialSystem:GetProgress()

do return ((self.power * 100) / self.setting.HiPower) end
end
function SpecialSystem:TextureUpdate(cardTex)

CS.optionalCall(self.cardDisplay,"TextureUpdate",cardTex)
end
function SpecialSystem:Update(csm,player)

if (self.status == LanternStatus.CLOSED) then
self.power=CS.invoke(MathHelper,"Clamp",self.power,0,CS.trunc((CS.choose(self.pause,function() return ((CS.f(self.setting.HiPower) * CS.f(0.99))) end,function() return (CS.f(self.setting.HiPower)) end))))
else
self.power=CS.invoke(MathHelper,"Clamp",self.power,0,CS.trunc((CS.choose(self.pause,function() return ((CS.f(self.setting.HiPower) * CS.f(1.99))) end,function() return ((CS.f(self.setting.HiPower) * CS.f(2))) end))))
end
local vector=CS.copy(CS.invoke(player,"Position"))
CS.optionalCall(self.openEffect,"SetPos",vector,true)
CS.optionalCall(self.changeEffect,"SetPos",vector,true)
if ((self.changeEffect ~= nil) and (CS.invoke(self.changeEffect,"BarrageCount") == 0)) then
self.changeEffect=nil
end
self.energyGetTime=self.energyGetTime+1
self.enegryUseTime=self.enegryUseTime+1
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
if ((self.cardDisplay ~= nil) and CS.invoke(self.cardDisplay,"Update")) then
Program.main.game.DrawCardDisplay=(Program.main.game.DrawCardDisplay - self.cardDisplay.Draw)
self.cardDisplay=nil
end
self.recoverTime=CS.invoke(Math,"Max",0,(self.recoverTime - 1))
self.bossDamageLimit=CS.f(self.setting.BossDamageLimits[CS.trunc(player.EquipType)][CS.trunc(self.status)])
CS.invoke(self.fire,"Update")
if (self.protectTime > 0) then
self.protectTime=self.protectTime-1
if (self.protectTime > 60) then
for _,item in CS.each(csm.csc) do
local __break3,__continue3=false,false
repeat
local vector2=CS.copy((vector - CrazyStorm.ToScreen))
for _,item2 in CS.each(item.layerm.LayerArray) do
local __break4,__continue4=false,false
repeat
for _,barrage in CS.each(item2.Barrages) do
local __break5,__continue5=false,false
repeat
if (((((not barrage.Dis) and (CS.bitop("|",((barrage.time > 15)),(not barrage.Mist)))) and (barrage.NeedDelete == NeedDeleteType.None)) and (not barrage.Invincible)) and (CS.invoke(Math,"Sqrt",((((barrage.x - vector2.X)) * ((barrage.x - vector2.X))) + (((barrage.y - vector2.Y)) * ((barrage.y - vector2.Y))))) < CS.invoke(Math,"Abs",(((60 - self.protectTime)) * 30)))) then
barrage.time=((1 + barrage.add) + barrage.life)
barrage.Dis=true
barrage.Blend=item.highlightDispel
end
until true
if __break5 then break end
end
until true
if __break4 then break end
end
until true
if __break3 then break end
end
else
if (self.protectTime == 0) then
player.PWudi=false
end
end
end
if (self.protectingEffect ~= nil) then
CS.invoke(self.protectingEffect,"SetPos",vector,true)
end
if (self.chargeTime > 0) then
self.chargeTime=self.chargeTime-1
self.power=(self.power + CS.trunc(((CS.f(0.01) * CS.f(self.setting.HiPower)))))
if (self.protectChance == 0) then
self.chargeTime=0
self.power=self.setting.HiPower
end
if (self.power >= self.setting.HiPower) then
self.power=self.setting.HiPower
self.fire.color.a=CS.f(1)
end
end
if ((((((not player.Dis) and (not player.Equip.HideLantern)) and (not player.IsControling)) and ((CS.invoke(Main,"IsKeyPressed",InputKeys.Switch) or ((CS.invoke(Main,"IsKeyPressed",InputKeys.Charge) and CS.invoke(Main,"IsKeyPressed",InputKeys.Bomb)))))) and (self.changeEffect == nil)) and (self.status ~= LanternStatus.LOSTCONTROL)) then
CS.invoke(Program.main.game,"PlaySound","powerup",false,CS.f(0))
self.changeEffect=CS.invoke(Program.main.game,"PlayEffect",true,"701",vector)
self.changeEffect.order=CrazyStorm.Order.UnderBarrage
CS.invoke(self.changeEffect,"SetOPos",vector)
CS.invoke(self.changeEffect,"BanSound",true)
CS.invoke(player,"ChangeEquip",true)
end
if (self.pause and ((((self.status == LanternStatus.CLOSED) or (self.status == LanternStatus.OPENING)) or (self.status == LanternStatus.LOSINGCONTROL)))) then
do return  end
end
self.time=self.time+1
if ((self.time <= 100) and (not player.Equip.HideLantern)) then
self.alpha=CS.f((self.alpha + CS.f(0.01)))
else
if (not player.Equip.HideLantern) then
SpecialSystem.ChangeAlpha(self,vector)
else
self.alpha=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.alpha - CS.f(0.01))))
end
end
local lanternStatus=self.status
do local __switch6=self.status
repeat
if __switch6==LanternStatus.CLOSED then
local flag=false
if ((((((((not player.Dis) or (player.Jue <= 10))) and (not player.Equip.HideLantern)) and CS.invoke(Main,"IsKeyPressed",InputKeys.Charge)) and CS.invoke(Main,"IsKeyUp",InputKeys.Bomb)) and (self.Energy > 0)) and (self.power < self.setting.HiPower)) then
self.Energy=self.Energy-1
self.power=self.setting.HiPower
CS.invoke(Program.main.game,"PlaySound","powerup",false,CS.f(0))
if player.Dis then
flag=true
CS.invoke(player,"CancelDis")
end
if (Program.main.game.CurrentHyperChallenge == 1) then
self.status=LanternStatus.OPENING
if (not flag) then
CS.invoke(Program.main.game,"PlaySound","charge",false,CS.f(0))
self.openEffect=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((98 + (CS.trunc(player.type) * 3))),"ToString"),vector)
self.openEffect.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.openEffect,"SetOPos",vector)
CS.invoke(self.openEffect,"BanSound",true)
player.SAuto=true
player.SWudi=true
self.wudiTime=30
self.stayTime=0
self.fire.color.a=CS.f(1)
SpecialSystem.TeammateWork(self,player)
self.itemProduced=false
else
SpecialSystem.Break(self,player,true,BreakSource.Jue,true)
end
break
end
end
if (((self.power < self.setting.HiPower) or player.Equip.HideLantern) or player.IsBombing) then
break
end
if (Program.main.game.CurrentHyperChallenge == 1) then
SpecialSystem.BaseBonus(self,player)
CS.invoke(Program.main.game,"EnergyItem",CS.choose(((self.teammate ~= nil)),function() return self.teammate.LanternPos end,function() return CS.invoke(player,"Position") end))
self.power=0
break
end
self.status=LanternStatus.OPENING
if (not flag) then
CS.invoke(Program.main.game,"PlaySound","charge",false,CS.f(0))
self.openEffect=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((98 + (CS.trunc(player.type) * 3))),"ToString"),vector)
self.openEffect.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.openEffect,"SetOPos",vector)
CS.invoke(self.openEffect,"BanSound",true)
player.SAuto=true
player.SWudi=true
self.wudiTime=30
self.stayTime=0
self.fire.color.a=CS.f(1)
SpecialSystem.TeammateWork(self,player)
self.itemProduced=false
else
SpecialSystem.Break(self,player,true,BreakSource.Jue,true)
end
break
elseif __switch6==LanternStatus.OPENING then
self.stayTime=self.stayTime+1
if (self.stayTime >= self.wudiTime) then
player.SWudi=false
end
if ((((self.stayTime >= 30) and CS.invoke(Main,"IsKeyPressed",InputKeys.Charge)) and CS.invoke(Main,"IsKeyUp",InputKeys.Bomb)) and (self.Energy > 0)) then
self.Energy=self.Energy-1
self.power=(self.setting.HiPower * 2)
CS.invoke(Program.main.game,"PlaySound","powerup",false,CS.f(0))
end
if (self.power >= (self.setting.HiPower * 2)) then
self.warnEffect=CS.invoke(Program.main.game,"PlayEffect",true,"21",CrazyStorm.DefaultCenter)
self.warnEffect.order=CrazyStorm.Order.Overtop
self.status=LanternStatus.LOSINGCONTROL
player.SWudi=true
self.power=(self.setting.HiPower * 2)
self.wudiTime=120
self.stayTime=0
else
if (self.recoverTime == 0) then
self.power=(self.power - CS.trunc(((CS.f(self.setting.PowerLostSpeed[0]) * CS.invoke(MathHelper,"Lerp",CS.f(1),CS.f(0.5),CS.invoke(Math,"Min",CS.f(1),(CS.f(player.NoShootTime) / CS.f(20))))))))
end
end
if (self.power <= 0) then
SpecialSystem.Bonus(self,player)
self.status=LanternStatus.OVERCLOSING
self.overCountInStage=self.overCountInStage+1
player.SWudi=true
self.power=0
self.wudiTime=120
self.stayTime=0
else
if (self.stayTime >= (self.setting.PowerUpSecond[0] * 60)) then
self.status=LanternStatus.RELEASING
CS.invoke(Program.main.game,"PlaySound","powerdown",false,CS.f(0))
player.SWudi=true
self.wudiTime=30
self.stayTime=0
end
end
break
elseif __switch6==LanternStatus.RELEASING then
self.stayTime=self.stayTime+1
self.power=(self.power - (self.setting.PowerLostSpeed[0] * 6))
if (self.stayTime >= self.wudiTime) then
player.SWudi=false
end
if ((CS.invoke(Main,"IsKeyPressed",InputKeys.Charge) and CS.invoke(Main,"IsKeyUp",InputKeys.Bomb)) and (self.Energy > 0)) then
self.Energy=self.Energy-1
self.power=(self.setting.HiPower * 2)
CS.invoke(Program.main.game,"PlaySound","powerup",false,CS.f(0))
end
if (self.power >= (self.setting.HiPower * 2)) then
self.warnEffect=CS.invoke(Program.main.game,"PlayEffect",true,"21",CrazyStorm.DefaultCenter)
self.warnEffect.order=CrazyStorm.Order.Overtop
self.status=LanternStatus.LOSINGCONTROL
player.SWudi=true
self.power=(self.setting.HiPower * 2)
self.wudiTime=120
self.stayTime=0
end
if (self.power <= 0) then
SpecialSystem.Bonus(self,player)
self.status=LanternStatus.OVERCLOSING
self.overCountInStage=self.overCountInStage+1
player.SWudi=true
self.power=0
self.wudiTime=120
self.stayTime=0
end
break
elseif __switch6==LanternStatus.LOSINGCONTROL then
self.stayTime=self.stayTime+1
if (self.stayTime < self.wudiTime) then
break
end
self.freakCount=self.freakCount+1
self.freakEffect=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((21 + player.type)),"ToString"),vector)
local type=player.type
if (type == Cname.MOKOU) then
self.freakEffect.bomb=false
CS.invoke(self.freakEffect.shoot,"AddRange",CS.List({[0]=1,[1]=0,[2]=CS.trunc(player.damageSet.A.other4)}))
else
self.freakEffect.bomb=true
end
self.freakEffect.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.freakEffect,"SetOPos",vector)
local num=0
for _,item3 in CS.each(csm.csc) do
local __break7,__continue7=false,false
repeat
local vector4=CS.copy((vector - CrazyStorm.ToScreen))
for _,item4 in CS.each(item3.layerm.LayerArray) do
local __break8,__continue8=false,false
repeat
for _,barrage2 in CS.each(item4.Barrages) do
local __break9,__continue9=false,false
repeat
if ((((barrage2.Dis or (not (CS.bitop("|",((barrage2.time > 15)),(not barrage2.Mist))))) or (barrage2.NeedDelete ~= NeedDeleteType.None)) or barrage2.Invincible) or (not ((CS.invoke(Math,"Sqrt",((((barrage2.x - vector4.X)) * ((barrage2.x - vector4.X))) + (((barrage2.y - vector4.Y)) * ((barrage2.y - vector4.Y))))) < CS.f(900.0))))) then
__continue9=true;break
end
if (((barrage2.life > 2) and (barrage2.alpha >= CS.f(100))) and (not barrage2.centerMasked)) then
local pos=CS.copy(CS.new("Vector2",(barrage2.x + CrazyStorm.ToScreen.X),(barrage2.y + CrazyStorm.ToScreen.Y)))
if (num < 500) then
CS.invoke(Program.main.game,"BlueItem",pos,true,true)
else
CS.invoke(Program.main.game,"SmallItem",true,pos,true,true)
end
end
barrage2.time=((1 + barrage2.add) + barrage2.life)
barrage2.Dis=true
barrage2.Blend=item3.highlightDispel
until true
if __break9 then break end
end
until true
if __break8 then break end
end
until true
if __break7 then break end
end
self.status=LanternStatus.LOSTCONTROL
CS.invoke(Program.main.game,"PlaySound","burst",false,CS.f(0))
CS.invoke(Program.main.game,"PlaySound","nep00",false,CS.f(0))
player.SWudi=false
player.SAuto=((not Main.Replay) or CS.invoke(RPYInfo,"VersionAutoSpecialItem",Main.ReplayContent))
self.wudiTime=0
player.speedadd=CS.copy(CS.new("Vector2",CS.f(0.9),CS.f(0.9)))
self.stayTime=0
break
elseif __switch6==LanternStatus.LOSTCONTROL then
if (self.freakEffect ~= nil) then
CS.invoke(self.freakEffect,"SetPos",vector,true)
end
self.stayTime=self.stayTime+1
self.power=(self.power - self.setting.PowerLostSpeed[3])
if (((((self.stayTime >= 30) and (self.power >= (120 * self.setting.PowerLostSpeed[3]))) and CS.invoke(Main,"IsKeyPressed",InputKeys.Charge)) and CS.invoke(Main,"IsKeyUp",InputKeys.Bomb)) and (self.Energy > 0)) then
self.Energy=self.Energy-1
self.power=CS.invoke(Math,"Min",(self.setting.HiPower * 2),(self.power + (self.setting.HiPower / 2)))
CS.invoke(Program.main.game,"PlaySound","powerup",false,CS.f(0))
end
if (self.power <= (120 * self.setting.PowerLostSpeed[3])) then
if (self.freakEffect.Status ~= 1) then
CS.invoke(Program.main.game,"PlaySound","powerdown",false,CS.f(0))
end
self.freakEffect.Status=1
end
if (self.power > 0) then
break
end
for _,item5 in CS.each(csm.csc) do
local __break10,__continue10=false,false
repeat
local vector5=CS.copy((vector - CrazyStorm.ToScreen))
for _,item6 in CS.each(item5.layerm.LayerArray) do
local __break11,__continue11=false,false
repeat
for _,barrage3 in CS.each(item6.Barrages) do
local __break12,__continue12=false,false
repeat
if (((((not barrage3.Dis) and (CS.bitop("|",((barrage3.time > 15)),(not barrage3.Mist)))) and (barrage3.NeedDelete == NeedDeleteType.None)) and (not barrage3.Invincible)) and (CS.invoke(Math,"Sqrt",((((barrage3.x - vector5.X)) * ((barrage3.x - vector5.X))) + (((barrage3.y - vector5.Y)) * ((barrage3.y - vector5.Y))))) < CS.f(900.0))) then
if (((barrage3.life > 2) and (barrage3.alpha >= CS.f(100))) and (not barrage3.centerMasked)) then
CS.invoke(Program.main.game,"SmallItem",true,CS.new("Vector2",(barrage3.x + CrazyStorm.ToScreen.X),(barrage3.y + CrazyStorm.ToScreen.Y)),true)
end
barrage3.time=((1 + barrage3.add) + barrage3.life)
barrage3.Dis=true
barrage3.Blend=item5.highlightDispel
end
until true
if __break12 then break end
end
until true
if __break11 then break end
end
until true
if __break10 then break end
end
SpecialSystem.Bonus(self,player)
self.status=LanternStatus.OVERCLOSING
self.overCountInStage=self.overCountInStage+1
player.SWudi=true
self.wudiTime=120
self.power=(self.setting.HiPower / 2)
player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
self.stayTime=0
CS.invoke(Program.main.achivmanager,"Check",6)
AchievementBase.IntParams[0]=self.freakCount
CS.invoke(Program.main.achivmanager,"Check",8)
break
elseif __switch6==LanternStatus.OVERCLOSING then
self.stayTime=self.stayTime+1
if (self.stayTime == 1) then
if (self.warnEffect ~= nil) then
CS.invoke(self.warnEffect,"Break")
self.warnEffect=nil
end
if (self.freakEffect ~= nil) then
CS.invoke(self.freakEffect,"StopSound",true)
end
if ((Main.Character == Cname.MARISA) or (Main.Character == Cname.MOKOU)) then
CS.invoke(Program.main.game,"PlaySound","mania2end",false,CS.f(0))
end
CS.invoke(Program.main.game,"PlaySound","over",false,CS.f(0))
CS.invoke(Program.main.game,"PlaySound","boon00",false,CS.f(0))
CS.optionalCall(self.openEffect,"Break")
self.closeEffect=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((100 + (CS.trunc(player.type) * 3))),"ToString"),vector)
self.closeEffect.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.closeEffect,"SetOPos",vector)
CS.invoke(self.closeEffect,"BanSound",true)
self.fire.color.a=CS.f(0)
end
if (self.stayTime >= self.wudiTime) then
if (self.freakEffect ~= nil) then
CS.invoke(self.freakEffect,"Break")
self.freakEffect=nil
end
self.status=LanternStatus.CLOSED
player.SWudi=false
end
player.SAuto=false
break
elseif __switch6==LanternStatus.BREAKCLOSING then
self.stayTime=self.stayTime+1
if (self.stayTime == 1) then
if (self.warnEffect ~= nil) then
CS.invoke(self.warnEffect,"Break")
self.warnEffect=nil
end
if (self.freakEffect ~= nil) then
CS.invoke(self.freakEffect,"Break")
self.freakEffect=nil
end
CS.invoke(Program.main.game,"PlaySound","release",false,CS.f(0))
CS.optionalCall(self.openEffect,"Break")
self.breakEffect=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((99 + (CS.trunc(player.type) * 3))),"ToString"),vector)
self.breakEffect.order=CrazyStorm.Order.UnderActorEquip
CS.invoke(self.breakEffect,"SetOPos",vector)
CS.invoke(self.breakEffect,"BanSound",true)
self.fire.color.a=CS.f(0)
end
if (self.stayTime <= 30) then
for _,item7 in CS.each(csm.csc) do
local __break13,__continue13=false,false
repeat
local vector3=CS.copy((vector - CrazyStorm.ToScreen))
for _,item8 in CS.each(item7.layerm.LayerArray) do
local __break14,__continue14=false,false
repeat
for _,barrage4 in CS.each(item8.Barrages) do
local __break15,__continue15=false,false
repeat
if (((((not barrage4.Dis) and (CS.bitop("|",((barrage4.time > 15)),(not barrage4.Mist)))) and (barrage4.NeedDelete == NeedDeleteType.None)) and (not barrage4.Invincible)) and (CS.invoke(Math,"Sqrt",((((barrage4.x - vector3.X)) * ((barrage4.x - vector3.X))) + (((barrage4.y - vector3.Y)) * ((barrage4.y - vector3.Y))))) < CS.invoke(Math,"Abs",(self.stayTime * 30)))) then
if (((barrage4.life > 2) and (barrage4.alpha >= CS.f(100))) and (not barrage4.centerMasked)) then
CS.invoke(Program.main.game,"SmallItem",true,CS.new("Vector2",(barrage4.x + CrazyStorm.ToScreen.X),(barrage4.y + CrazyStorm.ToScreen.Y)),false)
end
barrage4.time=((1 + barrage4.add) + barrage4.life)
barrage4.Dis=true
barrage4.Blend=item7.highlightDispel
end
until true
if __break15 then break end
end
until true
if __break14 then break end
end
until true
if __break13 then break end
end
end
if ((self.wudiTime == 240) and (self.stayTime <= 60)) then
player.speedadd=CS.copy(CS.new("Vector2",CS.f(0.15),CS.f(0.02)))
else
if ((self.wudiTime == 240) and (self.stayTime == 61)) then
player.speedadd=CS.copy(CS.new("Vector2",CS.f(1),CS.f(1)))
end
end
if (self.stayTime >= self.wudiTime) then
self.status=LanternStatus.CLOSED
player.SWudi=false
end
player.SAuto=false
break
end
until true
end
end
function SpecialSystem:TeammateWork(player)

if (((self.teammate == nil) and (Program.main.game.StmStage < 6)) and (not self.banTeammate)) then
local array=CS.arrayValues({[0]=2,[1]=3,[2]=0,[3]=1})
local pos=CS.copy(CS.invoke(player,"Position"))
local num=array[CS.trunc(((Main.Character - 1)))]
self.teammate=CS.new("Character",Program.main.game.CharacterSets[num],Program.main.game.SelfBarrage,pos,((num + 1)),false)
end
end
function SpecialSystem:PlaceTeammate(pos)

local array=CS.arrayValues({[0]=2,[1]=3,[2]=0,[3]=1})
local num=array[CS.trunc(((Main.Character - 1)))]
self.teammate=CS.new("Character",Program.main.game.CharacterSets[num],Program.main.game.SelfBarrage,pos,((num + 1)),true)
end
function SpecialSystem:UpdateTeammate(player,familiarPosition)

if self.banTeammate then
do return  end
end
local flag=(self.status == LanternStatus.OPENING)
if ((not Main.Replay) or CS.invoke(RPYInfo,"VersionEnergyItemWhenLanternReleasing",Main.ReplayContent)) then
flag=((self.status == LanternStatus.OPENING) or (self.status == LanternStatus.RELEASING))
end
if ((((((not self.itemProduced) and (self.energy < 3)) and flag) and (not self.pause)) and (Program.main.game.CurrentHyperChallenge ~= 2)) and (Program.main.game.CurrentCrystalChallenge ~= 2)) then
if (Program.main.game.StmStage < 6) then
self.itemEnergy=(self.itemEnergy + self.setting.ItemGrowSpeed)
else
self.itemEnergy=(self.itemEnergy + CS.trunc(((CS.f(self.setting.ItemGrowSpeed) * CS.f(0.7)))))
end
self.itemEnergy=CS.invoke(Math,"Min",self.itemEnergy,self.ItemEnergyLimit)
end
if ((not self.itemProduced) and (self.itemEnergy >= self.ItemEnergyLimit)) then
self.itemProduced=true
self.itemEnergy=0
CS.invoke(Program.main.game,"EnergyItem",CS.choose(((self.teammate ~= nil)),function() return self.teammate.LanternPos end,function() return CS.invoke(player,"Position") end))
end
if (self.teammate == nil) then
if familiarPosition.HasValue then
SpecialSystem.TeammateWork(self,player)
end
do return  end
end
CS.invoke(self.teammate,"Update",CS.choose(familiarPosition.HasValue,function() return familiarPosition.Value end,function() return CS.invoke(player,"Position") end),familiarPosition.HasValue)
if self.teammate.Dis then
self.teammate=nil
end
end
function SpecialSystem:DrawTeammate(s,q)

if (self.teammate ~= nil) then
CS.invoke(self.teammate,"DrawSprite",s,q,false)
CS.invoke(self.teammate,"DrawEquip",s,q)
end
end
function SpecialSystem:Draw(s)

local color=CS.new("Color",Color.White,self.alpha)
if (Program.main.game.CurrentHyperChallenge == 2) then
CS.invoke(s,"Draw",Game.Res.challengeIcons,CS.new("Vector2",CS.f(44),CS.f(664)),CS.new("Rectangle",0,114,144,38),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
do return  end
end
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(36),CS.f(544)),CS.new("Rectangle",0,26,154,353),color,CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
if self.lscConditionShow then
self.lscTipAlpha=CS.f(CS.invoke(Math,"Min",CS.f(1),(self.lscTipAlpha + CS.f(0.02))))
else
self.lscTipAlpha=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.lscTipAlpha - CS.f(0.02))))
end
if (self.lscTipAlpha > CS.f(0)) then
self.lscTimeChars[0]=((CS.invoke(Math,"Min",9,self.overCountInStage) + 48))
CS.invoke(s,"DrawSpriteNumberWithShadow",Game.Res.number,self.lscTimeChars,true,CS.new("Vector2",CS.f(62),CS.f(534)),TextureAlign.Left,CS.new("Colors",CS.f(1),CS.f(1),CS.f(1),(self.alpha * self.lscTipAlpha)),CS.f(0.45))
self.lscTimeChars[0]=":"
CS.invoke(s,"DrawSpriteNumberWithShadow",Game.Res.number,self.lscTimeChars,true,CS.new("Vector2",CS.f(73),CS.f(534)),TextureAlign.Left,CS.new("Colors",CS.f(1),CS.f(1),CS.f(1),(self.alpha * self.lscTipAlpha)),CS.f(0.45))
self.lscTimeChars[0]=((CS.invoke(Math,"Min",9,self.lscConditionTip) + 48))
CS.invoke(s,"DrawSpriteNumberWithShadow",Game.Res.number,self.lscTimeChars,true,CS.new("Vector2",CS.f(84),CS.f(534)),TextureAlign.Left,CS.new("Colors",CS.f(1),CS.f(1),CS.f(1),(self.alpha * self.lscTipAlpha)),CS.f(0.45))
end
do
local i=0
while (i < CS.invoke(Math,"Max",1,self.energy)) do
local __break16,__continue16=false,false
repeat
if (i < self.energy) then
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(82),(661 - (i * 18))),CS.new("Rectangle",259,0,34,34),color,CS.f(0),CS.new("Vector2",CS.f(17.5),CS.f(17.5)),CS.f(0.45),SpriteEffects.None,CS.f(0))
end
CS.invoke(s,"End")
CS.invoke(s,"Begin",BlendState.Additive)
if (i < self.energy) then
local scale=CS.f(0.6)
CS.invoke(s,"Draw",CS.new("Color",Color.White,(CS.f(0.3) + (CS.f(0.7) * CS.invoke(Math,"Abs",CS.f(CS.invoke(Math,"Sin",((CS.f(self.energyGetTime) / CS.f(120)) * ((CS.f(Math.PI) * CS.f(2)))))))))),self.spscore,CS.new("Vector2",CS.f(82),(661 - (i * 18))),CS.new("Rectangle",292,0,52,52),CS.f(0),CS.new("Vector2",CS.f(26.5),CS.f(26.5)),scale,SpriteEffects.None,CS.f(0))
do
local j=0
while (j < 2) do
local __break17,__continue17=false,false
repeat
scale=CS.f((CS.f(CS.invoke(Math,"Sin",((CS.f((CS.rem(CS.invoke(Math,"Max",0,(self.energyGetTime - (j * 30))),60))) / CS.f(60)) * ((CS.f(Math.PI) / CS.f(2)))))) * CS.f(0.8)))
CS.invoke(s,"Draw",CS.new("Color",Color.White,(self.alpha * ((CS.f(1) - (CS.f((CS.rem(CS.invoke(Math,"Max",0,(self.energyGetTime - (j * 30))),60))) / CS.f(60)))))),self.spscore,CS.new("Vector2",CS.f(82),(661 - (i * 18))),CS.new("Rectangle",259,0,34,34),CS.f(0),CS.new("Vector2",CS.f(17.5),CS.f(17.5)),scale,SpriteEffects.None,CS.f(0))
until true
if __break17 then break end
j=j+1
end
end
if (i == (self.energy - 1)) then
scale=CS.f((CS.f(CS.invoke(Math,"Sin",((CS.f(self.energyGetTime) / CS.f(30)) * ((CS.f(Math.PI) / CS.f(2)))))) * CS.f(3)))
CS.invoke(s,"Draw",CS.new("Color",Color.White,(self.alpha * ((CS.f(1) - CS.invoke(Math,"Min",CS.f(1),(CS.f(self.energyGetTime) / CS.f(40))))))),self.spscore,CS.new("Vector2",CS.f(82),(661 - (i * 18))),CS.new("Rectangle",345,0,30,30),CS.f(0),CS.new("Vector2",CS.f(15.5),CS.f(15.5)),scale,SpriteEffects.None,CS.f(0))
end
else
if (i == self.energy) then
local scale=(CS.f(CS.invoke(Math,"Sin",((CS.f(self.enegryUseTime) / CS.f(30)) * ((CS.f(Math.PI) / CS.f(2)))))) * CS.f(3))
CS.invoke(s,"Draw",CS.new("Color",Color.White,(self.alpha * ((CS.f(1) - CS.invoke(Math,"Min",CS.f(1),(CS.f(self.enegryUseTime) / CS.f(40))))))),self.spscore,CS.new("Vector2",CS.f(82),(661 - (i * 18))),CS.new("Rectangle",345,0,30,30),CS.f(0),CS.new("Vector2",CS.f(15.5),CS.f(15.5)),scale,SpriteEffects.None,CS.f(0))
end
end
CS.invoke(s,"End")
CS.invoke(s,"Begin")
until true
if __break16 then break end
i=i+1
end
end
local a=self.fire.color.a
self.fire.color.a=(self.fire.color.a * self.alpha)
CS.invoke(self.fire,"Draw",s)
self.fire.color.a=a
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(36),CS.f(544)),CS.new("Rectangle",154,26,96,353),color,CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
local num=CS.trunc((((CS.f(CS.invoke(Math,"Min",self.power,self.setting.HiPower)) / CS.f(self.setting.HiPower)) * CS.f(232))))
local x=(CS.choose((((self.status == LanternStatus.OPENING) or (self.status == LanternStatus.RELEASING))),function() return 279 end,function() return 253 end))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(58),(CS.f(581) + (CS.f(((232 - num))) * CS.f(0.45)))),CS.new("Rectangle",x,(225 + ((232 - num))),26,num),color,CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
local num2=(CS.f(CS.invoke(Math,"Max",(self.power - self.setting.HiPower),0)) / CS.f(self.setting.HiPower))
num=CS.trunc(((num2 * CS.f(232))))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(58),(CS.f(581) + (CS.f(((232 - num))) * CS.f(0.45)))),CS.new("Rectangle",305,(225 + ((232 - num))),26,num),color,CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
CS.invoke(s,"Draw",CS.new("Color",color,CS.invoke(Math,"Min",CS.f(1),(self.alpha * num2))),self.spscore,CS.new("Vector2",CS.f(58),(CS.f(581) + (CS.f(((232 - num))) * CS.f(0.45)))),CS.new("Rectangle",331,(225 + ((232 - num))),26,num),CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
CS.invoke(s,"End")
CS.invoke(s,"Begin",BlendState.Additive)
local num3=CS.f(CS.invoke(Math,"Abs",CS.invoke(Math,"Sin",(CS.f(self.time) * CS.f(0.05)))))
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",CS.f(46),CS.f(572)),CS.new("Rectangle",357,223,81,281),((color * num3) * self.fire.color.a),CS.f(0),Vector2.Zero,CS.f(0.45),SpriteEffects.None,CS.f(0))
CS.invoke(s,"End")
CS.invoke(s,"Begin")
local progress=SpecialSystem.GetProgress(self)
CS.invoke(StringHelper,"IntParse",self.percentChars,progress,false," ")
local num4=55
local num5=678
local num6=CS.f(CS.invoke(Math,"Abs",CS.invoke(Math,"Sin",(CS.f(self.time) / CS.invoke(MathHelper,"Lerp",CS.f(50),CS.f(10),num2)))))
local color2=CS.new("Color",CS.f(1),(CS.f(1) - (num6 * num2)),(CS.f(1) - (num6 * num2)),self.alpha)
do
local k=0
while (k < self.percentChars.Length) do
local __break18,__continue18=false,false
repeat
if (self.percentChars[k] ~= " ") then
local num7=(self.percentChars[k] - 48)
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",num4,num5),CS.new("Rectangle",(48 + (num7 * 19)),0,19,26),color2,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
end
num4=(num4 + 12)
until true
if __break18 then break end
k=k+1
end
end
if (Program.main.game.CurrentEnergyChallenge == 1) then
CS.invoke(s,"Draw",Game.Res.challengeIcons,CS.new("Vector2",(num4 + 10),(num5 - 3)),CS.new("Rectangle",0,152,144,38),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
end
if (Program.main.game.CurrentHyperChallenge == 1) then
CS.invoke(s,"Draw",Game.Res.challengeIcons,CS.new("Vector2",CS.f(44),CS.f(568)),CS.new("Rectangle",0,114,144,38),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
end
if (Program.main.game.CurrentCrystalChallenge == 1) then
CS.invoke(s,"Draw",Game.Res.challengeIcons,CS.new("Vector2",(num4 - 24),(num5 - 80)),CS.new("Rectangle",0,76,144,38),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
else
if (Program.main.game.CurrentCrystalChallenge == 2) then
CS.invoke(s,"Draw",Game.Res.challengeIcons,CS.new("Vector2",(num4 - 28),(num5 - 80)),CS.new("Rectangle",0,114,144,38),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
end
end
CS.invoke(s,"Draw",self.spscore,CS.new("Vector2",num4,num5),CS.new("Rectangle",238,0,19,26),color,CS.f(0),Vector2.Zero,CS.f(0.7),SpriteEffects.None,CS.f(0))
local num8=CS.invoke(StringHelper,"IntParse",self.scoreChars,self.recordscore)
local num9=(self.scoreChars.Length - num8)
CS.invoke(s,"Draw",self.spscore,(self.recordposition - CS.new("Vector2",((CS.f(16) * CS.f(((num9 + 1)))) / CS.f(2)),CS.f(26))),CS.new("Rectangle",26,0,19,26),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),self.scorealpha),CS.f(0),Vector2.Zero,CS.f(1),SpriteEffects.None,CS.f(0))
do
local l=num8
while (l < self.scoreChars.Length) do
local __break19,__continue19=false,false
repeat
local num10=(self.scoreChars[l] - 48)
CS.invoke(s,"Draw",self.spscore,(self.recordposition - CS.new("Vector2",(((CS.f(16) * CS.f(((num9 - 1)))) / CS.f(2)) - CS.f(((((l - num8)) * 16)))),CS.f(26))),CS.new("Rectangle",(48 + (num10 * 19)),0,19,26),CS.new("Color",CS.f(1),CS.f(1),CS.f(1),self.scorealpha),CS.f(0),Vector2.Zero,CS.f(1),SpriteEffects.None,CS.f(0))
until true
if __break19 then break end
l=l+1
end
end
if (not self.itemProduced) then
CS.invoke(s,"End")
CS.invoke(s,"Begin",EffectHelper.Circle)
CS.invoke(EffectHelper,"DrawCircle",s,CS.new("Vector2",CS.f(83),(662 - (self.energy * 18))),CS.f(9),CS.f(2.5),CS.f(45),(CS.invoke(Math,"Min",CS.f(1),(CS.f(self.itemEnergy) / CS.f(self.ItemEnergyLimit))) * CS.f(360)),Color.White)
CS.invoke(s,"End")
CS.invoke(s,"Begin")
end
end
function SpecialSystem:ChangeAlpha(pp)

local num=CS.invoke(Math,"Sqrt",(((((pp.X - CS.f(50))) * ((pp.X - CS.f(50)))) * CS.f(16)) + (((pp.Y - CS.f(690))) * ((pp.Y - CS.f(690))))))
if ((num >= CS.f(150.0)) and (num <= CS.f(300.0))) then
num=(num / CS.f(300.0))
self.alpha=CS.f(CS.f((((num * num) * num))))
else
if (num > CS.f(300.0)) then
self.alpha=CS.f(CS.f(1))
end
end
end
function SpecialSystem.defaults(self)
self.setting=nil
self.status=0
self.power=0
self.blue=0
self.maxBlue=0
self.graze=0
self.energy=0
self.energyGetTime=0
self.enegryUseTime=60
self.itemEnergy=0
self.itemProduced=false
self.banTeammate=false
self.freakCount=0
self.percentChars=CS.array(3,function() return nil end)
self.lscTimeChars=CS.array(1,function() return nil end)
self.time=0
self.openEffect=nil
self.breakEffect=nil
self.closeEffect=nil
self.changeEffect=nil
self.alpha=0
self.stayTime=0
self.wudiTime=0
self.bossDamageLimit=0
self.scoreChars=CS.array(9,function() return nil end)
self.recordscore=0
self.recordposition=CS.Vector2()
self.scorealpha=0
self.scoretime=60
self.pause=false
self.warnEffect=nil
self.freakEffect=nil
self.cardDisplay=nil
self.spscore=nil
self.fire=nil
self.protectChance=0
self.overCountInStage=0
self.lscConditionShow=false
self.lscConditionTip=0
self.lscTipAlpha=0
self.protectTime=0
self.chargeTime=0
self.recoverTime=0
self.protectingEffect=nil
self.breakEffectNames=nil
self.teammate=nil
end
return _ENV
end
