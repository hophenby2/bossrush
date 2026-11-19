-- 原作 C# 自机逻辑，由语法树导出；不可手工修改。
return function(CS)
local _ENV=setmetatable({CS=CS},{__index=CS.env})
setfenv(1,_ENV)
-- Character.cs SHA256 5678657787c62b08ab35868f8670dcf41541daf1c966f8ab2bd89647b369b655
Character={__get={},__set={}}
Character.__index=function(o,k) local getter=Character.__get[k];if getter then return getter(o) end;return Character[k] end
Character.__newindex=function(o,k,v) local setter=Character.__set[k];if setter then setter(o,v) else rawset(o,k,v) end end
function Character.__get.LightSurrounding(self) local value=(CS.choose(self.equip.HideLantern,function() return CS.f(1) end,function() return self.LightParameters[(CS.trunc(((self.type - 1))) * 10)] end))
if (self.slowingTime > 0) then
do return CS.invoke(MathHelper,"Lerp",CS.f(1),value,CS.invoke(Math,"Min",CS.f(1),(CS.f(self.slowingTime) / CS.f(10)))) end
end
if (self.noSlowTime > 0) then
do return CS.invoke(MathHelper,"Lerp",CS.f(1),value,CS.invoke(Math,"Max",CS.f(0),(CS.f(1) - (CS.f(self.noSlowTime) / CS.f(10))))) end
end
do return CS.f(1) end end
function Character.__get.LightCenterLerp(self) if self.equip.HideLantern then
do return CS.f(0) end
end
if (self.slowingTime > 0) then
do return CS.invoke(MathHelper,"Lerp",CS.f(0),CS.f(1),CS.invoke(Math,"Min",CS.f(1),(CS.f(self.slowingTime) / CS.f(10)))) end
end
if (self.noSlowTime > 0) then
do return CS.invoke(MathHelper,"Lerp",CS.f(0),CS.f(1),CS.invoke(Math,"Max",CS.f(0),(CS.f(1) - (CS.f(self.noSlowTime) / CS.f(10))))) end
end
do return CS.f(0) end end
function Character.__get.LightSegment(self) local lanternPos=CS.copy(self.LanternPos)
local num=self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 1)]
local num2=self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 2)]
local num3=self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 3)]
local num4=self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 4)]
do local __switch1=self.type
repeat
if __switch1==Cname.REIMU then
local num5=CS.invoke(MathHelper,"ToRadians",(CS.f(270) + (CS.choose(((self.equipType == EquipType.B)),function() return ((self.equip.TurnFactor * CS.f(25))) end,function() return CS.f(0) end))))
lanternPos=CS.copy((lanternPos + (CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",num5)),CS.f(CS.invoke(Math,"Sin",num5))) * num2)))
do return CS.new("Vector4",lanternPos.X,lanternPos.Y,lanternPos.X,lanternPos.Y) end
elseif __switch1==Cname.MARISA then
do return CS.new("Vector4",(lanternPos.X + num),(lanternPos.Y + num2),(lanternPos.X + num3),(lanternPos.Y + num4)) end
elseif __switch1==Cname.SANAE then
if (self.equipType == EquipType.A) then
do return CS.new("Vector4",(lanternPos.X + num),(lanternPos.Y + num2),(lanternPos.X + num),(lanternPos.Y + num2)) end
end
do return CS.new("Vector4",lanternPos.X,lanternPos.Y,lanternPos.X,lanternPos.Y) end
elseif __switch1==Cname.MOKOU then
do return CS.new("Vector4",(lanternPos.X + num),(lanternPos.Y + num2),(lanternPos.X + num),(lanternPos.Y + num2)) end
elseif true then
do return CS.new("Vector4",CS.f(1),CS.f(1),CS.f(1),CS.f(1)) end
end
until true
end end
function Character.__get.LightSize(self) local vector=CS.new("Vector4",self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 5)],self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 6)],self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 7)],self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 8)])
if (Program.main.game.LanternLighting and (Program.main.game.LanternStatus ~= LanternStatus.LOSTCONTROL)) then
vector=CS.invoke(CalHelper,"Lerp",vector,(vector * CS.f(1.4)),CS.invoke(Math,"Min",CS.f(1),(CS.f(Program.main.game.LanternStayTime) / CS.f(10))))
else
if (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) then
vector=CS.invoke(CalHelper,"Lerp",(vector * CS.f(1.4)),(vector * CS.f(2)),CS.invoke(Math,"Min",CS.f(1),(CS.f(Program.main.game.LanternStayTime) / CS.f(10))))
else
if ((Program.main.game.LanternStatus == LanternStatus.BREAKCLOSING) or (Program.main.game.LanternStatus == LanternStatus.OVERCLOSING)) then
vector=CS.invoke(CalHelper,"Lerp",(vector * CS.f(1.4)),CS.new("Vector4",CS.f(1),CS.f(1),CS.f(1),CS.f(1)),CS.invoke(Math,"Min",CS.f(1),(CS.f(Program.main.game.LanternStayTime) / CS.f(10))))
end
end
end
if (self.slowingTime > 0) then
do return CS.invoke(CalHelper,"Lerp",CS.new("Vector4",CS.f(1),CS.f(1),CS.f(1),CS.f(1)),vector,CS.invoke(Math,"Min",CS.f(1),(CS.f(self.slowingTime) / CS.f(10)))) end
end
if (self.noSlowTime > 0) then
do return CS.invoke(CalHelper,"Lerp",CS.new("Vector4",CS.f(1),CS.f(1),CS.f(1),CS.f(1)),vector,CS.invoke(Math,"Max",CS.f(0),(CS.f(1) - (CS.f(self.noSlowTime) / CS.f(10))))) end
end
do return CS.new("Vector4",CS.f(1),CS.f(1),CS.f(1),CS.f(1)) end end
function Character.__get.LightAttenBand(self) return self.LightParameters[((CS.trunc(((self.type - 1))) * 10) + 9)] end
function Character.__get.SelfPowerAlpha(self) if (self.SelfPowerDisplayType == 2) then
do return CS.f(0.6) end
end
if (self.SelfPowerDisplayType == 3) then
do return CS.f(0.2) end
end
do return CS.f(1) end end
function Character.__get.SelfDisplayScale(self) if (self.SelfDisplaySizeType == 2) then
do return CS.f(0.875) end
end
if (self.SelfDisplaySizeType == 3) then
do return CS.f(0.81249994) end
end
do return CS.f(1) end end
function Character.__get.IsPlayerShoot(self) if (not CS.invoke(Main,"IsKeyDown",InputKeys.Shoot)) then
do return (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL) end
end
do return true end end
function Character.__get.Wudi(self) if (((((not self.BWudi) and (not self.SWudi)) and (not self.FWudi)) and (not self.PWudi)) and (not self.EWudi)) then
do return self.Leaving end
end
do return true end end
function Character.__get.Auto(self) if (((not self.BAuto) and (not self.BEAuto)) and (not self.SAuto)) then
do return self.PAuto end
end
do return true end end
function Character.__get.Dis(self) return self.dis end
function Character.__get.Free(self) return self.__prop_Free end
function Character.__get.Free(self) return self.__prop_Free end
function Character.__get.BanShoot(self) if (((((not self.spawn) and (not self.BBanShoot)) and (not self.PBanShoot)) and (not self.SBanShoot)) and (not self.CBanShoot)) then
do return self.LBanShoot end
end
do return true end end
function Character.__get.Moving(self) return self.moving end
function Character.__get.DisableTime(self) return self.disableTime end
function Character.__get.SlowingTime(self) return self.slowingTime end
function Character.__get.NoSlowTime(self) return self.noSlowTime end
function Character.__get.DashTime(self) return self.dashTime end
function Character.__get.NoDashTime(self) return self.noDashTime end
function Character.__get.NoShootTime(self) return self.noShootTime end
function Character.__get.Equip(self) return self.equip end
function Character.__get.EquipType(self) return self.equipType end
function Character.__get.Spawning(self) return self.spawn end
function Character.__get.Leaving(self) return self.leave end
function Character.__get.Jue(self) return self.jue end
function Character.__get.IsBombing(self) if (self.bomb ~= nil) then
do return self.bomb.Active end
end
do return false end end
function Character.__get.IsJueBombing(self) if (self.bomb ~= nil) then
do return self.bomb.Jue end
end
do return false end end
function Character.__get.IsPetrifying(self) return self.petrifying end
function Character.__get.TeammateExit(self) return self.teammateExit end
function Character.__get.IsControling(self) return self.controling end
function Character.__get.ControlTarget(self) return self.controlTarget end
function Character.__get.LanternPos(self) if (self.equip == nil) then
do return Character.Position(self) end
end
do return CS.invoke(self.equip,"GetLanternPos",self.configSet.scale,false) end end
function Character.__get.LanternDisplayPos(self) if (self.equip == nil) then
do return Character.Position(self) end
end
do return CS.invoke(self.equip,"GetLanternPos",(self.configSet.scale * self.SelfDisplayScale),true) end end
function Character:ctor(configs,sb,pos,t,stand)

self.body=CS.new("Sprite")
self.body.color.a=CS.f(1)
self.configSet=configs
self.selfb=sb
self.type=t
for _,part in CS.each(self.configSet.parts) do
local __break2,__continue2=false,false
repeat
local value=part.Value
value.currentPos=CS.copy(self.body.position)
for _,anim in CS.each(value.anims) do
local __break3,__continue3=false,false
repeat
local value2=anim.Value
local clip=CS.initialize(CS.new("AnimationClip"),{["name"]="Default",["interval"]=value2.playInterval,["frames"]=CS.List({[0]=0,[1]=0,[2]=1,[3]=0,[4]=2,[5]=0,[6]=3,[7]=0,[8]=4,[9]=0,[10]=5,[11]=0,[12]=6,[13]=0})})
CS.invoke(value2.sprite,"AddClip",clip)
CS.invoke(value2.sprite,"Play","Default")
until true
if __break3 then break end
end
until true
if __break2 then break end
end
self.equip=CS.new("Equipment",self.selfb)
CS.invoke(self.equip,"Reinit")
local num=(Game.ScreenRange.Width / 2)
self.teammateStand=stand
if (not self.teammateStand) then
self.teammateInitAngle=CS.f(CS.invoke(MathHelper,"ToRadians",CS.choose((((pos.X - CS.f(Game.ScreenRange.X)) > CS.f(num))),function() return 90 end,function() return 0 end)))
Character.ResetPos(self,self.SpawnPoint.X,(self.SpawnPoint.Y + CS.f(380)))
else
Character.ResetPos(self,pos.X,pos.Y)
end
end
function Character:ResetPos(x,y)

self.body.position.X=CS.f(x)
self.body.position.Y=CS.f(y)
CS.invoke(self.equip,"ResetPlayerPos",self)
for _,part in CS.each(self.configSet.parts) do
local __break4,__continue4=false,false
repeat
local value=part.Value
value.currentPos=CS.copy(self.body.position)
until true
if __break4 then break end
end
end
function Character:IsPositionInLight(pos)

local vector=CS.copy(Character.Position(self))
local vector2=(CS.choose(((self.slowingTime > 0)),function() return self.LightSegment end,function() return CS.new("Vector4",vector.X,vector.Y,vector.X,vector.Y) end))
local vector3=(CS.choose(((self.slowingTime > 0)),function() return self.LightSize end,function() return CS.new("Vector4",CS.f(100),CS.f(100),CS.f(100),CS.f(100)) end))
local vector4=CS.copy(CS.new("Vector2",(vector2.Z - vector2.X),(vector2.W - vector2.Y)))
local value=CS.copy(CS.new("Vector2",(pos.X - vector2.X),(pos.Y - vector2.Y)))
local num=CS.invoke(Math,"Max",CS.f(0.5),CS.invoke(vector4,"Length"))
local num2=CS.invoke(MathHelper,"Clamp",(CS.invoke(Vector2,"Dot",value,vector4) / ((num * num))),CS.f(0),CS.f(1))
local vector5=CS.copy((CS.new("Vector2",vector2.X,vector2.Y) + (num2 * vector4)))
local vector6=CS.copy((pos - vector5))
local vector7=CS.copy(CS.invoke(CalHelper,"Lerp",CS.new("Vector2",vector3.X,vector3.Y),CS.new("Vector2",vector3.Z,vector3.W),num2))
local num3=(CS.choose(((self.slowingTime > 0)),function() return ((self.LightAttenBand / ((vector7.X + vector7.Y)))) end,function() return CS.f(0) end))
vector7=CS.copy((vector7 - CS.new("Vector2",num3,num3)))
local num4=CS.f(CS.invoke(Math,"Sqrt",(((vector6.X * vector6.X) / ((vector7.X * vector7.X))) + ((vector6.Y * vector6.Y) / ((vector7.Y * vector7.Y))))))
do return (num4 < CS.f(1)) end
end
function Character:Petrify(type,limit)

local flag=(self.Wudi and (((not self.SWudi) or (Program.main.game.LanternStayTime <= 7))))
if (self.SWudi and (Program.main.game.LanternStayTime <= 7)) then
CS.invoke(Program.main.achivmanager,"Check",19)
end
if (((self.IsControling or ((((not flag) and (not self.Dis)) and (not self.Free))))) and (((not self.IsControling) or (not self.Dis)))) then
if Program.main.game.LanternLighting then
CS.invoke(Program.main.game,"LanternBreak",true,BreakSource.Petrify,false)
end
CS.invoke(Program.main.game,"LanternPause")
self.petrifying=true
self.petrifyType=type
self.relieveCount=0
self.relieveLimit=limit
self.relieveTime=0
self.relieveOffset=CS.Vector4()
local vector=CS.copy((CS.choose(self.controling,function() return self.LanternDisplayPos end,function() return Character.Position(self) end)))
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((201 + (self.petrifyType * 3))),"ToString"),vector)
CS.invoke(crazyStorm,"SetOPos",vector)
end
end
function Character:Relieve()

if (not self.IsControling) then
CS.invoke(Program.main.game,"LanternRecover")
end
self.petrifying=false
local vector=CS.copy((CS.choose(self.controling,function() return self.LanternDisplayPos end,function() return Character.Position(self) end)))
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((203 + (self.petrifyType * 3))),"ToString"),vector)
crazyStorm.order=(CS.choose(self.controling,function() return CrazyStorm.Order.Overtop end,function() return CrazyStorm.Order.Default end))
CS.invoke(crazyStorm,"SetOPos",vector)
CS.optionalCall(CS.invoke(Program.main.game,"FindEffect",CS.invoke(((201 + (self.petrifyType * 3))),"ToString")),"Break")
end
function Character:ClearNegativeStatus()

if self.petrifying then
Character.Relieve(self)
end
end
function Character:GettingOld()

if (Main.Character ~= Cname.MOKOU) then
if (self.state == CharacterState.Shift) then
self.state=CharacterState.ShiftOld
else
if ((self.state >= CharacterState.Idle1) and (self.state < CharacterState.IdleOld1)) then
self.state=(self.state + 6)
end
end
end
end
function Character:ReturnYouth()

if (Main.Character ~= Cname.MOKOU) then
if (self.state == CharacterState.ShiftOld) then
self.state=CharacterState.Shift
else
if ((self.state >= CharacterState.IdleOld1) and (self.state < CharacterState.Shift)) then
self.state=(self.state - 6)
end
end
end
end
function Character:Control(startup,target,duration,endup,effectID)

self.CBanShoot=true
self.BanMove=true
self.controlStartup=startup
self.controlSource=CS.copy(Character.Position(self))
self.controlTarget=CS.copy(target)
self.controlDuration=duration
self.controlEndup=endup
self.controlEffect=CS.invoke(Program.main.game,"PlayEffect",true,effectID,self.controlSource)
CS.invoke(self.controlEffect,"SetOPos",self.controlSource)
if Program.main.game.LanternLighting then
CS.invoke(Program.main.game,"LanternBreak",true,BreakSource.Control,false)
end
CS.invoke(Program.main.game,"LanternPause")
end
function Character:Lockdown(duration,effectID)

self.LBanShoot=true
self.BanMove=true
self.lockdownTime=0
self.lockdownDuration=duration
if CS.invoke(Program.main.game,"HasEffect",effectID) then
local vector=CS.copy(Character.Position(self))
self.lockdownEffect=CS.invoke(Program.main.game,"PlayEffect",true,effectID,vector)
CS.invoke(self.lockdownEffect,"SetOPos",vector)
end
end
function Character:FreeControl()

if self.controling then
CS.invoke(Program.main.game,"LanternRecover")
self.CBanShoot=false
self.BanMove=false
self.controling=false
if (self.controlEffect ~= nil) then
CS.invoke(self.controlEffect,"Break")
self.controlEffect=nil
end
end
end
function Character:SelectChaseTarget(bossm,em,affectFamiliar,position)

local enemy=CS.invoke(em,"MinDistance",position)
local familiar=CS.invoke(FamiliarManager.Instance,"MinDistance",position)
do
local i=0
while (i < self.targets.Count) do
local __break5,__continue5=false,false
repeat
self.targets[i]=CS.copy(CS.new("Vector3",CS.f(99999),CS.f(0),CS.f(0)))
until true
if __break5 then break end
i=i+1
end
end
if (bossm ~= nil) then
local nearestTarget=CS.invoke(bossm,"GetNearestTarget",position)
if (nearestTarget ~= nil) then
local x=CS.f(CS.invoke(Math,"Sqrt",((((position.X - nearestTarget.Position.X)) * ((position.X - nearestTarget.Position.X))) + (((position.Y - nearestTarget.Position.Y)) * ((position.Y - nearestTarget.Position.Y))))))
local num=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",nearestTarget.Position.X,nearestTarget.Position.Y,position.X,position.Y))
self.targets[0]=CS.copy(CS.new("Vector3",x,nearestTarget.Position.X,nearestTarget.Position.Y))
do return CS.new("Vector2",self.targets[0].Y,self.targets[0].Z) end
end
end
if (enemy ~= nil) then
local x2=CS.f(CS.invoke(Math,"Sqrt",((((position.X - enemy.Position.X)) * ((position.X - enemy.Position.X))) + (((position.Y - enemy.Position.Y)) * ((position.Y - enemy.Position.Y))))))
local num2=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",enemy.Position.X,enemy.Position.Y,position.X,position.Y))
self.targets[1]=CS.copy(CS.new("Vector3",x2,enemy.Position.X,enemy.Position.Y))
end
if (affectFamiliar and (familiar ~= nil)) then
local x3=CS.f(CS.invoke(Math,"Sqrt",((((position.X - familiar.X)) * ((position.X - familiar.X))) + (((position.Y - familiar.Y)) * ((position.Y - familiar.Y))))))
local num3=CS.invoke(MathHelper,"ToDegrees",CS.invoke(Main,"Twopointangle",familiar.X,familiar.Y,position.X,position.Y))
self.targets[2]=CS.copy(CS.new("Vector3",x3,familiar.X,familiar.Y))
end
CS.invoke(self.targets,"Sort",function(a,b) return CS.trunc(((a.X - b.X))) end)
do return CS.new("Vector2",self.targets[0].Y,self.targets[0].Z) end
end
function Character:Update(newPos,familiarAlive)

self.runtime=CS.f((self.runtime + Time.Stop))
local num=(-1)
if (not self.teammateStand) then
if (not familiarAlive) then
local degrees=CS.invoke(MathHelper,"Lerp",CS.f(0),CS.f(180),(CS.f(0.5) + (CS.f(0.5) * CS.f(CS.invoke(Math,"Sin",((((-CS.f(Math.PI)) / CS.f(2)) + CS.invoke(MathHelper,"ToRadians",self.teammateInitAngle)) + ((self.runtime / CS.f(1080)) * ((CS.f(Math.PI) * CS.f(2))))))))))
degrees=CS.f(CS.invoke(MathHelper,"ToRadians",degrees))
newPos=CS.copy((newPos + (CS.new("Vector2",CS.f(CS.invoke(Math,"Cos",degrees)),CS.f(CS.invoke(Math,"Sin",degrees))) * CS.f(150))))
if ((Program.main.game.ProtectChance == 0) and (Program.main.game.EndTime == 0)) then
if ((((((Program.main.game.LanternStatus == LanternStatus.OVERCLOSING) or (Program.main.game.LanternStatus == LanternStatus.BREAKCLOSING)) or (Program.main.game.LanternStatus == LanternStatus.LOSINGCONTROL)) or (Program.main.game.LanternStatus == LanternStatus.LOSTCONTROL)) or (Program.main.game.LanternStatus == LanternStatus.CLOSED)) or Program.main.game.LanternItemProduced) then
newPos=CS.copy(CS.new("Vector2",self.SpawnPoint.X,(self.SpawnPoint.Y + CS.f(380))))
self.teammateExit=true
end
if (Program.main.game.LanternStatus == LanternStatus.BREAKCLOSING) then
self.body.scale.X=CS.f(CS.invoke(Math,"Max",CS.f(0),(self.body.scale.X - CS.f(0.05))))
self.body.scale.Y=CS.f((self.body.scale.Y + CS.f(0.1)))
self.body.color.a=CS.invoke(Math,"Max",CS.f(0),(self.body.color.a - CS.f(0.05)))
end
if ((Program.main.game.LanternStatus == LanternStatus.CLOSED) and (self.body.position.Y >= CS.f(((Game.ScreenRange.Bottom + 100))))) then
self.dis=true
end
end
end
local vector=CS.copy((((newPos - self.body.position)) / CS.f(30)))
vector.X=CS.f(CS.invoke(Math,"Min",CS.f(7),vector.X))
vector.Y=CS.f(CS.invoke(Math,"Min",CS.f(7),vector.Y))
newPos=CS.copy((self.body.position + vector))
local vector2=CS.copy((newPos - self.body.position))
if (vector2.Y < CS.f(0)) then
num=(-90)
end
if (vector2.Y > CS.f(0)) then
num=90
end
if (vector2.X < CS.f(0)) then
num=180
if (vector2.Y < CS.f(0)) then
num=225
end
if (vector2.Y > CS.f(0)) then
num=135
end
end
if (vector2.X > CS.f(0)) then
num=0
if (vector2.Y < CS.f(0)) then
num=(-45)
end
if (vector2.Y > CS.f(0)) then
num=45
end
end
self.body.position=CS.copy(newPos)
end
CS.invoke(self.equip,"Update",self.type,self,familiarAlive)
if (not (((self.runtime - self.runtimebf) >= CS.f(1)))) then
do return  end
end
if (self.state < CharacterState.Shift) then
do local __switch6=num
repeat
if __switch6==135 or __switch6==180 or __switch6==225 then
self.state=(((CS.idiv(CS.trunc(self.state),3) * 3) + 1))
break
elseif __switch6==(-45) or __switch6==0 or __switch6==45 then
self.state=(((CS.idiv(CS.trunc(self.state),3) * 3) + 2))
break
elseif true then
self.state=((CS.idiv(CS.trunc(self.state),3) * 3))
break
end
until true
end
end
for _,part in CS.each(self.configSet.parts) do
local __break7,__continue7=false,false
repeat
local value=part.Value
if ((self.disableTime <= 0) or (self.disableTime > 50)) then
for _,anim in CS.each(value.anims) do
local __break8,__continue8=false,false
repeat
local value2=anim.Value
CS.invoke(value2.sprite,"Update")
until true
if __break8 then break end
end
end
local characterAnim=(CS.choose(CS.invoke(value.anims,"ContainsKey",self.state),function() return value.anims[self.state] end,function() return nil end))
if (characterAnim ~= nil) then
local num2=CS.invoke(Math,"Max",0,characterAnim.followDelay)
if (num2 == 0) then
value.currentPos=CS.copy(self.body.position)
else
value.currentPos=(value.currentPos + (((self.body.position - value.currentPos)) / num2))
end
local num3=CS.invoke(Math,"Max",0,characterAnim.changeTime)
if (num3 == 0) then
value.currentOffset=((characterAnim.offset * self.configSet.scale) * self.SelfDisplayScale)
value.currentRotate=characterAnim.rotate
else
value.currentOffset=(value.currentOffset + (((((characterAnim.offset * self.configSet.scale) * self.SelfDisplayScale) - value.currentOffset)) / num3))
value.currentRotate=(value.currentRotate + (((characterAnim.rotate - value.currentRotate)) / CS.f(num3)))
end
else
value.currentPos=CS.copy(self.body.position)
end
until true
if __break7 then break end
end
CS.invoke(self.equip,"UpdateSprite")
self.runtimebf=CS.f(self.runtime)
end
function Character:DrawSprite(s,q,usePetrify)

local key=(CS.choose(usePetrify,function() return (((14 + self.petrifyType))) end,function() return self.state end))
for _,part in CS.each(self.configSet.parts) do
local __break9,__continue9=false,false
repeat
local value=part.Value
local characterAnim=(CS.choose(CS.invoke(value.anims,"ContainsKey",key),function() return value.anims[key] end,function() return nil end))
if (characterAnim ~= nil) then
characterAnim.sprite.position=CS.copy(((value.currentPos + value.currentOffset) + q))
characterAnim.sprite.rotation=value.currentRotate
characterAnim.sprite.scale=CS.copy(((CS.new("Vector2",CS.f(1),CS.f(1)) * self.configSet.scale) * self.SelfDisplayScale))
characterAnim.sprite.color=self.body.color
CS.invoke(characterAnim.sprite,"Draw",s)
end
until true
if __break9 then break end
end
end
function Character:DrawEquip(s,q)

if (self.body.color.a > CS.f(0)) then
CS.invoke(self.equip,"Draw",s,q,(self.configSet.scale * self.SelfDisplayScale),self.body.color.a)
end
end
function Character:Position()

do return self.body.position end
end
function Character:SetPosition(pos)

self.body.position=CS.copy(pos)
for _,part in CS.each(self.configSet.parts) do
local __break10,__continue10=false,false
repeat
local value=part.Value
value.currentPos=CS.copy(self.body.position)
until true
if __break10 then break end
end
end
function Character:NativeNegativeUpdate()

if (self.CBanShoot and (not self.controling)) then
if (self.controlEffect ~= nil) then
CS.invoke(self.controlEffect,"SetPos",Character.Position(self),true)
end
self.controlTime=self.controlTime+1
local num=(CS.f(CS.invoke(MathHelper,"Clamp",(self.controlTime - self.controlStartup),0,self.controlDuration)) / CS.f(self.controlDuration))
num=CS.f((CS.f(1) - CS.f(CS.invoke(Math,"Pow",(CS.f(1) - num),CS.f(1.5)))))
num=CS.f(CS.f(((((CS.f(0.0) - ((CS.invoke(Math,"Cos",(Math.PI * num)) - CS.f(1.0))))) * CS.f(0.5)))))
Character.SetPosition(self,CS.invoke(Vector2,"Lerp",self.controlSource,self.controlTarget,num))
if (self.controlTime >= ((self.controlStartup + self.controlDuration) + self.controlEndup)) then
self.controling=true
CS.optionalCall(self.controlEffect,"Break")
self.controlEffect=nil
end
end
if self.LBanShoot then
if (self.lockdownEffect ~= nil) then
CS.invoke(self.lockdownEffect,"SetPos",Character.Position(self),true)
end
self.lockdownTime=self.lockdownTime+1
if (self.lockdownTime >= self.lockdownDuration) then
self.LBanShoot=false
self.BanMove=false
CS.optionalCall(self.lockdownEffect,"Break")
self.lockdownEffect=nil
end
end
if self.petrifying then
self.relieveTime=self.relieveTime+1
local num2=CS.f(((((CS.f(CS.invoke(Math,"Max",(10 - self.relieveTime),0)) * CS.f(0.1))) * CS.invoke(Math,"Sin",self.relieveTime))))
self.relieveOffset.X=CS.f((num2 * self.relieveOffset.Z))
self.relieveOffset.Y=CS.f((num2 * self.relieveOffset.W))
if CS.invoke(Main,"IsKeyPressed",InputKeys.MoveUp) then
CS.invoke(Controller,"Rumble",16384,32768,100)
self.relieveCount=self.relieveCount+1
self.relieveOffset.Z=CS.f(CS.f(0))
self.relieveOffset.W=CS.f((-CS.f(3)))
self.relieveTime=0
else
if CS.invoke(Main,"IsKeyPressed",InputKeys.MoveDown) then
CS.invoke(Controller,"Rumble",16384,32768,100)
self.relieveCount=self.relieveCount+1
self.relieveOffset.Z=CS.f(CS.f(0))
self.relieveOffset.W=CS.f(CS.f(3))
self.relieveTime=0
else
if CS.invoke(Main,"IsKeyPressed",InputKeys.MoveLeft) then
CS.invoke(Controller,"Rumble",16384,32768,100)
self.relieveCount=self.relieveCount+1
self.relieveOffset.Z=CS.f((-CS.f(3)))
self.relieveOffset.W=CS.f(CS.f(0))
self.relieveTime=0
else
if CS.invoke(Main,"IsKeyPressed",InputKeys.MoveRight) then
CS.invoke(Controller,"Rumble",16384,32768,100)
self.relieveCount=self.relieveCount+1
self.relieveOffset.Z=CS.f(CS.f(3))
self.relieveOffset.W=CS.f(CS.f(0))
self.relieveTime=0
end
end
end
end
if (self.relieveCount >= self.relieveLimit) then
Character.Relieve(self)
else
if (self.relieveTime == 0) then
local vector=CS.copy((CS.choose(self.controling,function() return self.LanternDisplayPos end,function() return Character.Position(self) end)))
local crazyStorm=CS.invoke(Program.main.game,"PlayEffect",true,CS.invoke(((202 + (self.petrifyType * 3))),"ToString"),vector)
crazyStorm.order=(CS.choose(self.controling,function() return CrazyStorm.Order.Overtop end,function() return CrazyStorm.Order.Default end))
CS.invoke(crazyStorm,"SetOPos",vector)
end
end
do return  end
end
end
function Character.defaults(self)
self.Label=CS.arrayValues({[0]="[灵]",[1]="[魔]",[2]="[早]",[3]="[妹]"})
self.Name=CS.arrayValues({[0]="Hakurei Reimu",[1]="Kirisame Marisa",[2]="Kochiya Sanae",[3]="Fujiwara no Mokou",[4]="博丽 灵梦",[5]="雾雨 魔理沙",[6]="东风谷 早苗",[7]="藤原 妹红",[8]="博麗 霊夢",[9]="霧雨 魔理沙",[10]="東風谷 早苗",[11]="藤原 妹紅",[12]="博麗 霊夢",[13]="霧雨 魔理沙",[14]="東風谷 早苗",[15]="藤原 妹紅",[16]="Хакурей Рейму",[17]="Кирисаме Мариса",[18]="Котия Санаэ",[19]="Фудзивара-но Моко"})
self.EquipName=CS.arrayValues({[0]="Type A",[1]="Type B",[2]="普通型",[3]="特化型",[4]="普通型",[5]="特化型",[6]="普通型",[7]="特化型",[8]="Обычный",[9]="Особый"})
self.LightParameters=CS.arrayValues({[0]=CS.f(1),[1]=CS.f(0),[2]=CS.f(160),[3]=CS.f(0),[4]=CS.f(0),[5]=CS.f(220),[6]=CS.f(220),[7]=CS.f(220),[8]=CS.f(220),[9]=CS.f(40),[10]=CS.f(1),[11]=CS.f(0),[12]=CS.f(100),[13]=CS.f(0),[14]=(-CS.f(300)),[15]=CS.f(40),[16]=CS.f(40),[17]=CS.f(150),[18]=CS.f(150),[19]=CS.f(40),[20]=CS.f(1),[21]=CS.f(0),[22]=(-CS.f(160)),[23]=CS.f(0),[24]=CS.f(0),[25]=CS.f(200),[26]=CS.f(200),[27]=CS.f(200),[28]=CS.f(200),[29]=CS.f(40),[30]=CS.f(1),[31]=CS.f(0),[32]=(-CS.f(200)),[33]=CS.f(0),[34]=CS.f(0),[35]=CS.f(180),[36]=CS.f(250),[37]=CS.f(180),[38]=CS.f(250),[39]=CS.f(40)})
self.SelfPowerDisplayType=2
self.SelfDisplaySizeType=2
self.HitPointDisplayType=2
self.HitPointHue=0
self.SpawnPoint=CS.new("Vector2",CS.f(336),CS.f(560))
self.runtime=0
self.runtimebf=0
self.itemm=nil
self.eqlevel=0
self.body=nil
self.bpos=CS.Vector2()
self.BWudi=false
self.SWudi=false
self.FWudi=false
self.PWudi=false
self.EWudi=false
self.BAuto=false
self.BEAuto=false
self.SAuto=false
self.PAuto=false
self.dis=false
self.BBanShoot=false
self.PBanShoot=false
self.SBanShoot=false
self.CBanShoot=false
self.LBanShoot=false
self.pBanShootTime=0
self.moving=false
self.BanMove=false
self.deadInBoss=false
self.shotInBoss=false
self.shotInStage=false
self.deadInAllStage=false
self.bombedInBoss=false
self.bombedInAllStage=false
self.breakedInBoss=false
self.shiftedInBoss=false
self.shiftedInStage=false
self.disableTime=0
self.slowingTime=0
self.noSlowTime=0
self.dashTime=0
self.noDashTime=0
self.noShootTime=0
self.speedadd=CS.Vector2()
self.bombMoveFactor=CS.f(1)
self.rangex=CS.Vector2()
self.rangey=CS.Vector2()
self.configSet=nil
self.damageSet=nil
self.state=0
self.judge=nil
self.judgeBright=nil
self.frontSight=nil
self.jueEffect=nil
self.selfb=nil
self.cardDisplay=nil
self.cardTex=nil
self.type=nil
self.equip=nil
self.equipType=0
self.f=0
self.flash=0
self.spawn=false
self.leave=false
self.leaveSpeed=0
self.jue=0
self.bomb=nil
self.petrifying=false
self.petrifyType=0
self.relieveCount=0
self.relieveLimit=0
self.relieveTime=0
self.relieveOffset=CS.Vector4()
self.teammateStand=false
self.teammateInitAngle=0
self.teammateExit=false
self.controling=false
self.controlStartup=0
self.controlDuration=0
self.controlEndup=0
self.controlTime=0
self.controlSource=CS.Vector2()
self.controlTarget=CS.Vector2()
self.controlEffect=nil
self.lockdownTime=0
self.lockdownDuration=0
self.lockdownEffect=nil
self.OnDis=nil
self.OnDisCancel=nil
self.targets=CS.List({[0]=CS.Vector3(),[1]=CS.Vector3(),[2]=CS.Vector3()})
end
return _ENV
end
