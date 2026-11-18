-- 只供独立 Windows Sub 发行副本使用；正常入口不载入本文件。
-- 在副本 core.lua 尾部 dofile 本文件，启动设置须为 launcher。
local originalInit=GameInit
function GameInit()
    originalInit()
    setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting));Include('mod/root.lua')
    local body=dofile('mod/GAME/th46/boss5_body.lua')
    local core=body.core
    local verify=dofile('tools/cv1000/verify_futari15_boss5_core.lua')
    local Shot=Class(object,{
        init=function(o,x,y)
            o.group,o.layer,o.bound,o.colli,o.hide=GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,true,true
            o.x,o.y,o.a,o.b,o.dmg=x,y,1,1,100
        end,
    })
    InitAllClass();InitGameSaveData();scoredata.PlayerBrand='CV1000 verification';scoredata.version=ui.version
    stage.next_stage=stage.stages.init;SaveResume.INTERVAL=math.huge
    local fixture=dofile('tools/cv1000/fixtures/futari15_boss5_core.lua')
    local timeouts=dofile('tools/cv1000/fixtures/futari15_boss5_timeout.lua')
    local movement=dofile('tools/cv1000/fixtures/futari15_boss5_motion.lua')
    local verifyMotion=dofile('tools/cv1000/verify_futari15_boss5_motion.lua')
    local verifyControl=dofile('tools/cv1000/verify_futari15_boss5_control.lua')
    local verifyTransition=dofile('tools/cv1000/verify_futari15_boss5_transition.lua')
    local verifyTasks=dofile('tools/cv1000/verify_futari15_boss5_tasks.lua')
    local taskFixture=dofile('tools/cv1000/fixtures/futari15_boss5_tasks.lua')
    local verifyGuns=dofile('tools/cv1000/verify_futari15_boss5_guns.lua')
    local gunFixture=dofile('tools/cv1000/fixtures/futari15_boss5_guns.lua')
    local controlFixtures={dofile('tools/cv1000/fixtures/futari15_boss5_control.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_second.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_third.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_change1.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_change2.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_change1_timeout.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_change2_timeout.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_defeat.lua'),
        dofile('tools/cv1000/fixtures/futari15_boss5_defeat_timeout.lua')}
    local input=GetInput
    local started,finished,phase,host,shot,closed=false,false,0,nil,nil,{}
    local motionTest,motionHost,motionCleanup
    local controlTest,controlHost,controlCleanup,controlIndex
    local transitionObjects,transitionCleanup
    local taskTest,taskCleanup
    local gunTest,gunCleanup
    local enginePlayer
    local function startControl(index,p)
        controlIndex=index
        controlHost=body.create({serial=0},p)
        controlTest=verifyControl(body.control,controlHost,controlFixtures[index])
        controlHost.clock.active=true
    end
    local function write(msg)
        local f=assert(io.open('result-native-boss5-core.txt','a'));f:write(msg,'\n');f:close()
    end
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
          for _=1,(motionTest or controlTest or taskTest or gunTest)and 16 or 1 do
            local current=stage.current_stage
            if current and current.pgmRun and current.pgmRun.roadClock then current.pgmRun.roadClock.player.protect=100 end
            if motionTest and not motionCleanup then
                motionTest.prepare()
                motionHost.inputs={paused=false,inhibitDefeat=false,motion=motionHost.motionInput}
            end
            if controlTest and not controlCleanup then
                controlTest.prepare()
                controlHost.inputs={paused=false,inhibitDefeat=false,
                    motion={dx=0,camera=0,px=120*65536,py=80*65536,alive=true,globalLogicCounter=0}}
            end
            if taskTest and not taskCleanup and taskTest.step()then taskCleanup=2 end
            if gunTest and not gunCleanup and gunTest.step()then gunCleanup=2 end
            DoFrame()
            if transitionCleanup then
                transitionCleanup=transitionCleanup-1
                if transitionCleanup==0 then
                    for _,o in ipairs(transitionObjects)do
                        assert(not IsValid(o)and not IsValid(o.clock))
                        for _,box in ipairs(o.boxes)do assert(not IsValid(box))end
                        for _,child in ipairs(o.transitionObjects)do assert(not IsValid(child))end
                    end
                    for _,o in ipairs(transitionObjects.linked or{})do assert(not IsValid(o))end
                    write('PASS: full-body hit and natural timeout notifications, both changes and defeat, cancellation order, retained motion, native collision switch, invulnerability resume and retirement reclamation')
                    finished=true
                end
            elseif gunTest then
                if gunCleanup then
                    gunCleanup=gunCleanup-1
                    if gunCleanup==0 then
                        for _,o in ipairs(gunTest.objects)do assert(not IsValid(o))end
                        local callbacks,calls=gunTest.result()
                        write(('PASS: %d original gun callbacks and %d emission/mount requests on native objects; thirty slots and shared parameter blocks reclaimed'):format(callbacks,calls))
                        local linked,shots=dofile('tools/cv1000/verify_futari15_boss5_gun_binding.lua')(body,enginePlayer)
                        local owner,slots=dofile('tools/cv1000/verify_futari15_boss5_task_binding.lua')(body,enginePlayer)
                        transitionObjects=verifyTransition(body,enginePlayer)
                        owner.transitionObjects=slots
                        transitionObjects[#transitionObjects+1]=owner
                        for _,o in ipairs(linked)do
                            if rawget(o,'boxes')then
                                o.transitionObjects={}
                                transitionObjects[#transitionObjects+1]=o
                            end
                        end
                        -- 同时核对已自然结束、从各管理器槽表移出的对象。
                        transitionObjects.linked=linked
                        write(('PASS: three main controllers waited for real native guns and effect slots; %d emission requests, shared pools and natural termination checked'):format(shots))
                        gunTest=nil;transitionCleanup=2
                    end
                end
            elseif taskTest then
                if taskCleanup then
                    taskCleanup=taskCleanup-1
                    if taskCleanup==0 then
                        for _,o in ipairs(taskTest.objects)do assert(not IsValid(o))end
                        local callbacks,calls=taskTest.result()
                        write(('PASS: %d original effect callbacks and %d requests on native objects; twenty-slot objects and shared parameter blocks reclaimed'):format(callbacks,calls))
                        gunTest=verifyGuns(body.guns,gunFixture)
                        taskTest=nil
                    end
                end
            elseif motionTest then
                if motionCleanup then
                    motionCleanup=motionCleanup-1
                    if motionCleanup==0 then
                        assert(not IsValid(motionHost)and not IsValid(motionHost.clock)and not IsValid(motionTest.driver))
                        for _,b in ipairs(motionHost.boxes)do assert(not IsValid(b))end
                        write(('PASS: %d original movement callbacks ran through automatic native frame; full integer pose, random calls, retreat requests and all six objects reclaimed'):format(movement.states))
                        motionTest=nil
                        startControl(1,enginePlayer)
                    end
                elseif motionTest.check()then body.close(motionHost);motionCleanup=2 end
            elseif controlTest then
                if controlCleanup then
                    controlCleanup=controlCleanup-1
                    if controlCleanup==0 then
                        assert(not IsValid(controlHost)and not IsValid(controlHost.clock)and not IsValid(controlTest.manager))
                        for _,b in ipairs(controlHost.boxes)do assert(not IsValid(b))end
                        for _,o in ipairs(controlTest.slots)do assert(not IsValid(o))end
                        for i=0,399 do assert(not controlHost.nativeParameters.used[i])end
                        write(('PASS: controller sample %d, %d original callbacks and %d requests through automatic native frame; all slots and parameter blocks reclaimed'):format(
                            controlIndex,controlTest.callbacks,controlTest.calls))
                        if controlIndex<#controlFixtures then
                            controlCleanup=nil;startControl(controlIndex+1,enginePlayer)
                        else
                            controlTest=nil
                            taskTest=verifyTasks(body.tasks,taskFixture)
                        end
                    end
                elseif controlTest.check()then body.close(controlHost);controlCleanup=2 end
            else
            local scene=stage.current_stage
            if scene.stage_name=='menu'and not started then
                assert(stage.group.PracticeStart('TH46@BossRush',false,'reco')~=false);started=true
            end
            local run=scene.pgmRun
            if run and run.roadClock then
                local p=run.roadClock.player;p.protect=100
                if phase==0 then
                    local counts,n,o=verify(core,fixture)
                    closed[#closed+1]=o
                    write(('PASS: %d real hit callbacks, %d clocks and %d transitions matched on native objects'):format(counts[1],counts[2],n))
                    local timeoutCounts,timeoutEvents,timeoutHost=verify(core,timeouts)
                    closed[#closed+1]=timeoutHost;phase=1
                    write(('PASS: %d original clocks and %d natural timeouts matched on native objects'):format(timeoutCounts[2],timeoutEvents))
                elseif phase==1 then
                    for _,o in ipairs(closed)do
                        assert(not IsValid(o))
                        for _,b in ipairs(o.boxes)do assert(not IsValid(b))end
                    end
                    host=body.create(run,p)
                    core.sync(host,{{120*65536,160*65536},{80*65536,100*65536}})
                    core.enable(host,true)
                    -- 前两盒在 y=16..21 重叠，检查真正碰撞扫描只消耗一次自弹。
                    shot=New(Shot,0,18);phase=2
                elseif phase==2 then
                    assert(host.hp==1807644 and not IsValid(shot),'原生重叠盒重复扣血或自弹未回收')
                    assert(host.boxes[1].y==-28 and host.boxes[1].b==49 and host.boxes[2].y==48)
                    core.setBox(host,3,true);assert(host.boxes[3].colli)
                    core.setBox(host,3,false);assert(not host.boxes[3].colli)
                    body.close(host);body.close(host);phase=3
                elseif phase==3 then
                    assert(not IsValid(host))
                    for _,b in ipairs(host.boxes)do assert(not IsValid(b))end
                    write('PASS: real player-shot collision on two overlapping boxes, asymmetric centers, third-box switch and all native objects reclaimed')
                    enginePlayer=p
                    motionHost=body.create({serial=0},p)
                    local birthHash=0
                    for _,a in ipairs(movement.birthFields)do
                        birthHash=(birthHash*131+a)%16777213
                        birthHash=(birthHash*131+assert(motionHost.raw[a]))%16777213
                    end
                    assert(birthHash==movement.birthHash,'原生构造返回不符')
                    motionTest=verifyMotion(body.motion,motionHost,movement)
                    motionHost.clock.active=true
                end
            end
            end
            if finished then break end
          end
        end,debug.traceback)
        if not ok then write('FAIL: '..tostring(err));finished=true end
        return finished
    end
end
