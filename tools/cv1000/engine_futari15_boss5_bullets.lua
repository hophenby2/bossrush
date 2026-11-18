-- 仅在隔离 Windows Sub 副本 core.lua 尾部载入；验证敌弹组件、队列、三段挂载及实际碰撞。
local originalInit=GameInit
function GameInit()
    originalInit()
    setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua')
    local body=dofile('mod/GAME/th46/boss5_body.lua')
    local factory=body.bulletFactory;factory.bullets.load()
    InitAllClass();InitGameSaveData();scoredata.PlayerBrand='CV1000 verification';scoredata.version=ui.version
    stage.next_stage=stage.stages.init;SaveResume.INTERVAL=math.huge
    local bulletReference=dofile('tools/cv1000/fixtures/futari15_boss5_bullets.lua')
    local factoryReference=dofile('tools/cv1000/fixtures/futari15_boss5_bullet_factory.lua')
    local bulletTest,factoryTest,cleanup,linked=nil,nil,nil,nil
    local started,finished=false,false
    local demo,demoRun,contact,contactRun,contactLife,contactDead,contactPhase
    local picture=false
    local input,render=GetInput,RenderFunc
    local function write(msg)
        local f=assert(io.open('result-native-boss5-bullets.txt','a'));f:write(msg,'\n');f:close()
    end
    function GetInput()
        input()
        if started then
            KeyState.shoot,KeyState.slow,KeyState.spell=false,false,false
            KeyState.up,KeyState.down,KeyState.left,KeyState.right=false,false,false,false
        end
    end
    function RenderFunc()
        render()
        if picture then Snapshot('native-boss5-bullets.png');picture=false end
    end
    function FrameFunc()
        if finished then return true end
        local ok,err=xpcall(function()
            for _=1,(bulletTest or factoryTest)and 16 or 1 do
                local scene=stage.current_stage
                if scene and scene.pgmRun and scene.pgmRun.roadClock then scene.pgmRun.roadClock.player.protect=100 end
                if bulletTest and not cleanup and bulletTest.step()then cleanup=2 end
                if factoryTest and not cleanup and factoryTest.step()then cleanup=2 end
                if demo then demoRun.serial=demoRun.serial+1;factory.step(demo)end
                if contact and contactPhase==2 then contactRun.serial=contactRun.serial+1 end
                DoFrame();scene=stage.current_stage
                if scene.stage_name=='menu'and not started then
                    assert(stage.group.PracticeStart('TH46@BossRush',false,'reco')~=false);started=true
                end
                local actual=scene.pgmRun
                if actual and actual.roadClock then
                    local p=actual.roadClock.player;p.protect=100
                    if contact then
                        if contactPhase==1 then
                            assert(contact.cancelAge==0 and not contact.colli and IsValid(contact))
                            assert(NativePlayers.state().life==contactLife and lstg.var.dead==contactDead)
                            contactPhase=2
                        elseif contactPhase==2 and contact.closed then
                            assert(contactRun.serial==32 and contact.phase==16,'真实碰撞后消弹时序不符')
                            contactPhase=3;cleanup=2
                        elseif contactPhase==3 then
                            cleanup=cleanup-1
                            if cleanup==0 then
                                assert(not IsValid(contact)and contactRun.boss5BulletCount==0)
                                factory.bullets.close(contactRun)
                                write('PASS: protected native-player collision, no life loss, 32-step cancel and reclamation')
                                finished=true
                            end
                        end
                    elseif demo then
                        if demoRun.serial==20 then picture=true end
                        if demoRun.serial>=24 then
                            factory.close(demo);demo=nil
                            contactRun={serial=0,roadFrame=0,roadRank=128,roadFlash=0,roadCameraDelta=0}
                            contactLife,contactDead=NativePlayers.state().life,lstg.var.dead
                            contact=factory.bullets.emit(contactRun,p.pilotPosition.x,p.pilotPosition.y+4*65536,
                                256,-30,19,{baseSpeed=54})
                            contactPhase=1
                            write('PASS: eight original bullet types loaded and rendered through native batch queue')
                        end
                    elseif linked then
                        cleanup=cleanup-1
                        if cleanup==0 then
                            for _,o in ipairs(linked)do assert(not IsValid(o))end
                            linked=nil;cleanup=nil
                            demoRun={serial=0,roadFrame=0,roadRank=128,roadFlash=0}
                            demo=factory.create(demoRun,{baseSpeed=54,allocated=function(_,_,o)if o then o.colli=false end end})
                            for i,kind in ipairs({18,19,21,37,46,51,58,59})do
                                local x=(i%2==1 and 80 or 160)*65536
                                local y=(285-math.floor((i-1)/2)*55)*65536
                                factory.enqueue(demo,'fan',{kind,x,y,0,256,3,12,(kind==51 or kind==58)and 1 or 0})
                            end
                        end
                    elseif factoryTest then
                        if cleanup then
                            cleanup=cleanup-1
                            if cleanup==0 then
                                for _,o in ipairs(factoryTest.objects)do assert(not IsValid(o))end
                                local cases,calls,failed=factoryTest.result()
                                write(('PASS: %d original requests and %d allocation attempts, %d original failures on native objects'):format(cases,calls,failed))
                                factoryTest=nil;cleanup=nil
                                local requests,created,rejected
                                linked,requests,created,rejected=dofile('tools/cv1000/verify_futari15_boss5_gun_binding.lua')(body,p,true)
                                write(('PASS: three main controllers and nine guns created %d native bullets of eight types, %d requests, %d rejected allocations'):format(created,requests,rejected))
                                cleanup=2
                            end
                        end
                    elseif bulletTest then
                        if cleanup then
                            cleanup=cleanup-1
                            if cleanup==0 then
                                for _,o in ipairs(bulletTest.objects)do assert(not IsValid(o))end
                                local count,states,sprites,cancels=bulletTest.result()
                                write(('PASS: %d original bullet objects, %d states, %d sprite requests, %d real cancel callbacks'):format(count,states,sprites,cancels))
                                bulletTest=nil;cleanup=nil
                                factoryTest=dofile('tools/cv1000/verify_futari15_boss5_bullet_factory.lua')(factory,factoryReference)
                            end
                        end
                    else
                        bulletTest=dofile('tools/cv1000/verify_futari15_boss5_bullets.lua')(factory.bullets,bulletReference)
                    end
                end
                if finished then break end
            end
        end,debug.traceback)
        if not ok then write('FAIL: '..tostring(err));finished=true end
        return finished
    end
end
