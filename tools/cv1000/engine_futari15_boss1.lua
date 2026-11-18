-- Windows Sub 隔离发行目录的关底组件实测入口；不得挂到正常发行入口。
-- 在副本 core.lua 的末尾 dofile 本文件，启动设置须为 launcher。
-- 自动进入 TH46，检查第一段任务、火球、自弹碰撞及默认四弹型；演出效果仍只核对请求。
-- 日志 result-native-boss-bindings-full.txt 位于该副本，测试不会接入顺序模式。
local originalInit=GameInit
function GameInit()
 originalInit();setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua')
 local body=dofile('mod/GAME/th46/boss1_body.lua');body.children.load()
 local verify=dofile('tools/cv1000/verify_futari15_boss1_bindings.lua')
 local Shot=Class(object,{init=function(o,x,y)
  o.group,o.layer,o.bound,o.colli=GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,true
  o.x,o.y,o.a,o.b,o.dmg=x,y,1,1,999999
 end})
 InitAllClass();InitGameSaveData();scoredata.PlayerBrand='CV1000 verification';scoredata.version=ui.version
 stage.next_stage=stage.stages.init;SaveResume.INTERVAL=math.huge
 local render,input=RenderFunc,GetInput
 local started,finished=false,false
 local host,run,manager,state,ref,cleanup,taskGroup,clock
 local factoryHost,factoryRun,factoryAPI,factoryGun,factoryCleanup,factoryHead
 local factorySeen,factoryBulletSeen,factoryKinds={},{},{}
 local factoryLandings,factoryLandingFrames=0,0
 local contact,contactRun,contactPhase,contactCleanup,contactLife,contactDead=nil,nil,0,nil,nil,nil
 local picture,pictureDone=false,false
 local fireball,fireRun,fireParent,firePhase,shot,explosions,fireCleanup=nil,nil,nil,0,nil,0,nil
 local function write(msg)local f=assert(io.open('result-native-boss-bindings-full.txt','a'));f:write(msg,'\n');f:close()end
 function GetInput()
  input()
  if started then
   KeyState.shoot,KeyState.slow,KeyState.spell=false,false,false
   KeyState.up,KeyState.down,KeyState.left,KeyState.right=false,false,false,false
  end
 end
 function FrameFunc()
  if finished then return true end
  local ok,err=xpcall(function()
   for _=1,8 do
    if host and not cleanup then run.serial=ref.steps[state()][1]end
    if fireball and not fireCleanup then fireRun.serial=fireRun.serial+1 end
    if factoryHost and not factoryCleanup then
     factoryRun.serial=factoryRun.serial+1;factoryRun.roadFrame=factoryRun.serial
     if factoryRun.serial==50 then body.guns.stop(factoryHead)end
    end
    if contact and contactPhase==2 and not contactCleanup then contactRun.serial=contactRun.serial+1 end
    DoFrame();local scene=stage.current_stage
    if scene.stage_name=='menu'and not started then
     assert(stage.group.PracticeStart('TH46@BossRush',false,'reco')~=false);started=true
    end
    local actual=scene.pgmRun
    if actual and actual.roadClock then
     local p=actual.roadClock.player;p.protect=100
     if contact then
      if contactCleanup then
       contactCleanup=contactCleanup-1
       if contactCleanup==0 then
        assert(not IsValid(contact)and not next(contactRun.boss1Bullets))
        body.bullets.close(contactRun)
        write('PASS: real protected-player collision cancelled native bullet without life loss; 32-step cancel and reclamation passed')
        finished=true
       end
      elseif contactPhase==1 then
       assert(IsValid(contact)and contact.cancelAge==0 and not contact.colli)
       assert(NativePlayers.state().life==contactLife and lstg.var.dead==contactDead)
       contactPhase=2
      elseif contact.closed then assert(contactRun.serial==32);contactCleanup=2 end
     elseif factoryHost then
      if factoryRun.serial>=40 and not pictureDone then picture,pictureDone=true,true end
      for o in pairs(factoryRun.boss1Children or {})do factorySeen[o]=true end
      for o in pairs(factoryRun.boss1Bullets or {})do factoryBulletSeen[o]=true;factoryKinds[o.kind]=true end
      if factoryCleanup then
       factoryCleanup=factoryCleanup-1
       if factoryCleanup==0 then
        assert(not IsValid(factoryHost)and not IsValid(factoryGun))
        local n=0;for o in pairs(factorySeen)do assert(o.closed and not IsValid(o));n=n+1 end
        for _,b in ipairs(factoryHost.boxes)do assert(not IsValid(b))end
        assert(n==48 and not factoryRun.boss1Children)
        local shots=0;for o in pairs(factoryBulletSeen)do assert(o.closed and not IsValid(o));shots=shots+1 end
        assert(shots>100 and factoryKinds[0x13]and factoryKinds[0x25]and factoryKinds[0x31]and factoryKinds[0x34])
        assert(not factoryRun.boss1Bullets and not factoryRun.boss1Guns)
        write('PASS: default five-gun bindings created, rendered and reclaimed 48 fireballs and '..shots..' native bullets of four types')
        factoryHost=nil
        contactRun={serial=0,roadFrame=0,roadRank=31,roadFlash=0,roadCameraDelta=0}
        contactLife,contactDead=NativePlayers.state().life,lstg.var.dead
        contact=body.bullets.emit(contactRun,p.pilotPosition.x,p.pilotPosition.y+4*65536,256,0,0x13)
        contactPhase=1
       end
      elseif factoryGun.closed then
       assert(factoryRun.serial==300)
       assert(factoryLandings==1 and factoryLandingFrames==86 and factoryHost.raw[24]==0 and factoryHost.raw[16]==0)
       factoryAPI.close();body.close(factoryHost);factoryCleanup=2
      else assert(factoryRun.serial<=300)end
     elseif fireball then
      if fireCleanup then
       fireCleanup=fireCleanup-1
       if fireCleanup==0 then
        assert(not IsValid(fireball)and explosions==1 and not next(fireRun.boss1Children))
        body.children.close(fireRun)
        write('PASS: native fireball absorbed a real player bullet, survived, then requested parent-clear explosion and reclaimed')
        fireball=nil
        factoryRun={serial=0,roadFrame=0,roadRank=31,roadFlash=0,roadCamera=0,roadCameraDelta=0}
        factoryHost=body.create(factoryRun,p,0)
        factoryHost.raw[8],factoryHost.raw[12]=120*65536,280*65536
        factoryHost.raw[28],factoryHost.raw[32]=0,0
        factoryHost.boardX,factoryHost.boardY=factoryHost.raw[8],factoryHost.raw[12]
        factoryHost.raw[0x1a8c],factoryHost.raw[0x1a90]=120*65536,160*65536
        factoryAPI=body.makeControlAPI(factoryHost,{
         effect=function(_,kind)
          if kind=='camera_offset'then factoryLandingFrames=factoryLandingFrames+1;return {0,0}end
          return 0
         end,
         motionEvent=function(_,kind)if kind=='land'then factoryLandings=factoryLandings+1 end end,
         side=function()return 0 end,gunRandom=function()return 0 end,
         childPorts={random=function()return 0 end,bomb=function()return false end,
          explode=function()error('factory fireballs should leave naturally')end}})
        factoryGun=factoryAPI.invoke(factoryHost,'spawn',{'wide_gun',0})
        factoryHost.motionInput={0,0,p.pilotPosition.x,p.pilotPosition.y,1}
        factoryHost.raw[24],factoryHost.raw[20]=1,5*65536
        body.motion.create(factoryHost,'simple_init')
        factoryHead=factoryAPI.invoke(factoryHost,'spawn',{'head'})
        factoryAPI.invoke(factoryHost,'spawn',{'burst',2,16})
        factoryAPI.invoke(factoryHost,'spawn',{'side',0,6,4,6})
        factoryAPI.invoke(factoryHost,'spawn',{'leap_gun',2})
       end
      elseif firePhase==0 and fireRun.serial==8 then
       assert(fireball.colli and fireball.visible and fireball.protection==0)
       shot=New(Shot,fireball.x,fireball.y);firePhase=1
      elseif firePhase==1 then
       assert(IsValid(fireball)and not fireball.closed and not IsValid(shot),'native fireball collision did not absorb shot')
       fireParent.raw[0x2314]=1;firePhase=2
      elseif firePhase==2 then assert(fireball.closed);fireCleanup=2 end
     elseif not host then
      host,run,manager,state,ref=verify(body,p)
      taskGroup,clock=host.taskGroup,host.clock
      write('Started parent, five native guns, native pose tasks, fireballs and ordered clock')
     elseif cleanup then
      cleanup=cleanup-1
      if cleanup==0 then
       local _,callbacks,calls,queries,shots,effects,visited=state()
       assert(not IsValid(host)and not IsValid(clock)and not IsValid(manager)and not IsValid(taskGroup))
       assert(rawget(host,'controlGroup')==nil and rawget(host,'taskGroup')==nil and not run.boss1Guns and not run.boss1Children)
       for _,b in ipairs(host.boxes)do assert(not IsValid(b))end
       local n=0;for o in pairs(visited)do assert(o.closed and not IsValid(o));n=n+1 end
       write('PASS: '..callbacks..' callbacks, '..calls..' requests, '..queries..' real life queries, '..shots..' requested bullets, '..effects..' effect requests, '..n..' children reclaimed')
       fireRun={serial=0,roadCamera=0,roadCameraDelta=0};fireParent={raw={[0x2314]=0}}
       fireball=body.children.create(fireRun,120*65536,120*65536,fireParent,256,16,0,{
        random=function()return 0 end,bomb=function()return false end,
        explode=function(o,byParent)assert(byParent and not o.colli);explosions=explosions+1 end})
      end
     else
      assert(clock.serial==run.serial and manager.serial==run.serial and taskGroup.serial==run.serial)
      local once=state();body.step(host);assert(state()==once,'native body advanced twice')
      if state()>#ref.steps then
       local _,callbacks,calls,queries=state();assert(callbacks==2307 and calls==1062 and queries==974)
       body.close(host);body.close(host);cleanup=2
      end
     end
    end
    if finished then return end
   end
  end,debug.traceback)
  if not ok then write(err);finished=true end
  return finished
 end
 function RenderFunc()
  if finished then return end
  local ok,err=xpcall(render,debug.traceback);if not ok then write(err);finished=true end
  if picture then Snapshot('native-boss1-bullets.png');picture=false end
 end
end
