local C=dofile('mod/GAME/ports/source_csharp.lua').new()
local keys={}
C.env.Main={__static=true,Replay=true,IsKeyDown=function(k) return keys[k] or false end}
C.env.Keys={Z='shoot',LeftShift='slow',RightShift='slow'}
C.env.Time={Stop=1};C.env.Cname={REIMU=1,MARISA=2,SANAE=3,YOUMU=4}
C.env.PadState={__static=true,IsKeyDown=function()return false end};C.env.JOYKEYS={}
C.env.Program={main={game={PlaySound=function() end}}}
C.env.Main.IsKeyUp=function(k) return not keys[k] end
local emitted={}
C.env.SelfBarrageManager={__static=true,Get=function(tex,r,o,p,e,a,s)
 local b={rect=C.copy(r),origin=C.copy(o),Position=C.copy(p),extend=e,alpha=a,scale=C.copy(s),color=C.Colors(1,1,1,0)}
 emitted[#emitted+1]=b;C.env.SelfBarrageManager.SBArray:Add(b);return b
end}
C.env.SelfBarrageManager.SBArray=C.List()
local source=dofile('mod/GAME/ports/mhj/native_players/spring.lua')(C)
setmetatable(source.Equipment,{__index=source.EquipShoot})
for machine=1,3 do for level=1,4 do
 emitted={};C.env.SelfBarrageManager.SBArray:Clear()
 local o=setmetatable({},source.Equipment)
 source.EquipShoot.defaults(o);source.Equipment.defaults(o);o:ctor('texture');o:Init()
 local em={JudgeRay=function()end}
 for t=1,120 do
  keys.shoot=t<100;keys.slow=t>=40 and t<=80
  local p=C.Vector2(224,420)
  o:Update(nil,em,machine,level,p,false)
  if keys.shoot then source.EquipShoot.BEquipShoot(o,'texture',machine,p) end
 end
 assert(#emitted>0)
 for _,b in ipairs(emitted) do
 local values={machine,level,b.rect.X,b.rect.Y,b.rect.Width,b.rect.Height,b.Position.X,b.Position.Y,b.power or 0,b.speed or 0,b.speedd or 0,b.scale.X,b.scale.Y}
 for i,n in ipairs(values) do values[i]=string.format('%.9g',n) end
 print(table.concat(values,'\t'))
 end
end end
