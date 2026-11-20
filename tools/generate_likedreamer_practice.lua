-- 离线记录各攻击开放前一帧；复用正式状态机与节点创建，运行时直接恢复初态。
local fixture=dofile('tools/likedreamer_parity/boss_fixture.lua')
LikeDreamer.Projectile.spawn=function()end
LikeDreamer.Projectile.spread=function()end
LikeDreamer.Projectile.clear=function()end
Del=function(o)o.removeRequested=true end
local function copy(v,skip)
 if type(v)~='table' then assert(type(v)~='function' and type(v)~='userdata');return v end
 if v.entityId and v.spawnType then return {__enemy_id=v.entityId} end
 local r={}
 for k,x in pairs(v)do if not (skip and skip[k]) then r[k]=copy(x) end end
 return r
end
local result={}
local counts={3,4,4,4,6,5,5,7,4,16}
local coords={{360,200},{360,180},{360,200},{360,120},{360,200},{480,150},{360,250},{360,180},{360,190},{360,320}}
local types={0x138,0x139,0x13a,0x13b,0x13c,0x13d,0x13e,0x13f,0x140,0x141,0x14c}
for stageIndex=1,11 do
 local stage=math.min(stageIndex,10);local kind=types[stageIndex];local total=counts[stageIndex] or 3
 local first=({5760,9760,9560,11760,11860,12560,12560,21480,17960,18000,11900})[stageIndex]
 local rt={stage=stage,difficulty=3,frame=first,nextEntityId=1,enemiesById={},enemyCount=0}
 local objects={}
 function rt:spawn(k,hp,x,y) return self:spawnChild(nil,k,hp,x,y) end
 function rt:spawnChild(parent,k,hp,x,y)
  local o={spawnType=k,hp=hp,maxhp=hp,ldX=x,ldY=y,originX=x,originY=y,active=true,age=0,helperTimer=0,state=0,speed=1,radius=40,angle16=0x4000,secondaryAngle16=0x4000,targetAngle16=0x4000,entityId=self.nextEntityId,parent=parent,parentEntityId=parent and parent.entityId or 0,parentSpawnType=parent and parent.spawnType or 0,targetable=false,protect=false,runtime=self}
  self.nextEntityId=self.nextEntityId+1;self.enemiesById[o.entityId]=o;self.enemyCount=self.enemyCount+1;objects[#objects+1]=o;return o
 end
 local x,y=unpack(coords[stage]);if stageIndex==11 then y=-2400 end;local root=rt:spawn(kind,100000,x,y)
 local entries={};result[kind]=entries
 local function snapshot()
  local s={objects={},next_id=rt.nextEntityId,elapsed=rt.frame-first,spawn_delay=stageIndex<=9 and 60 or 0,root_id=root.entityId}
  for _,o in ipairs(objects)do
   local fields={}
   local omit={runtime=true,parent=true,_ldExactView=true,_blSceneRt=true,_blRuntime=true,_blSceneBodyRenderProxy=true,_blGaugeRenderProxy=true,_blSceneMarkerRenderProxy=true}
   for k,v in pairs(o)do if not omit[k] then fields[k]=copy(v)end end
   s.objects[#s.objects+1]=fields
  end
  if rt._ldExactWorld then s.world=copy(rt._ldExactWorld.state,{rootObject=true}) end
  return s
 end
 for t=0,24000 do
  local before=snapshot()
  rt.frame=first+t;fixture.frame=t;player.ldX,player.ldY=360,600
  local i=1
  while i<=#objects do local o=objects[i];i=i+1
   if o.active then
    fixture.update(o,rt)
    if o.removeRequested then o.active=false;rt.enemiesById[o.entityId]=nil;rt.enemyCount=rt.enemyCount-1
    else o.helperTimer,o.age=o.helperTimer+1,o.age+1;if o.targetable then o.targetableTimer=(o.targetableTimer or 0)+1 end end
   end
  end
  local phase=root.portPhase
  local combat=root._bmCombat or root._bePhaseMode==1 or kind==0x14c and root.targetable
  if phase and combat then
   if not entries[phase] then before.expected={phase=phase,hp=root.hp,state=root.state,countdown=root.countdown,x=root.ldX,y=root.ldY};entries[phase]=before;print('ENTRY',stageIndex,phase,t,#before.objects) end
   if phase==total then break end
   root.countdown=0
  end
  if t==24000 then error('未达到目标阶段 '..stageIndex..' '..tostring(phase)..' state='..root.state..' target='..tostring(root.targetable))end
 end
 for p=1,total do assert(entries[p],'遗漏练习初态 '..stageIndex..':'..p)end
end
local function literal(v)
 local t=type(v)
 if t=='number' then assert(v==v and math.abs(v)<math.huge);return string.format('%.17g',v)
 elseif t=='boolean' then return tostring(v) elseif t=='string' then return string.format('%q',v)
 elseif t=='table' then local keys={};for k in pairs(v)do keys[#keys+1]=k end;table.sort(keys,function(a,b)return tostring(a)<tostring(b)end)
  local a={};for _,k in ipairs(keys)do a[#a+1]='['..literal(k)..']='..literal(v[k])end;return '{'..table.concat(a,',')..'}'
 end
 error(t)
end
-- 仅保留仍存活的节点及其显式引用；不会把前面阶段已经回收的所有节点带入练习。
for _,entries in pairs(result)do for _,entry in pairs(entries)do
 local byid,keep={},{}
 for _,o in ipairs(entry.objects)do byid[o.entityId]=o end
 local visit
 local function scan(v)
  if type(v)~='table' then return end
  if v.__enemy_id then visit(v.__enemy_id) else for _,x in pairs(v)do scan(x)end end
 end
 visit=function(id) if keep[id] then return end;keep[id]=true;scan(assert(byid[id],'引用了不存在的节点'))end
 for _,o in ipairs(entry.objects)do if o.active then visit(o.entityId)end end
 local filtered={};for _,o in ipairs(entry.objects)do if keep[o.entityId]then filtered[#filtered+1]=o end end
 entry.objects=filtered
end end
local out=assert(io.open(arg[1] or 'mod/GAME/ports/dreamer/LikeDreamer/practice_entries.lua','w'))
out:write('-- 由 tools/generate_likedreamer_practice.lua 从正式状态机离线记录；勿手工修改。\nreturn {\n')
for _,kind in ipairs(types)do out:write('[',kind,']={\n');for phase,entry in ipairs(result[kind])do out:write('[',phase,']=',literal(entry),',\n')end;out:write('},\n')end
out:write('}\n');out:close()
