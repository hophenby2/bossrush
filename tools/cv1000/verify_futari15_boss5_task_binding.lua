-- 合成场景只提供相机、场景计数及武器输入；主任务等待真实演出槽自然结束。
return function(body,player)
    local host=body.create({serial=0},player)
    local services=0
    local api={invoke=function(_,kind,args)
        if kind=='camera'or kind=='root_offset'then return 0
        elseif kind=='scene_counter'then return 1747
        elseif kind=='queue_get'then return{0,0}
        elseif kind=='weapon_mode'then return{0,-1}
        elseif kind=='service'or kind=='timeline_call'then services=services+1
        elseif kind=='signal'or kind=='layer'or kind=='queue_set'then
        else error('合成入场出现未检查接口：'..kind)end
    end}
    body.attachTasks(host,api)
    body.attachControl(host,api)
    local reached,waited,released=false,false,false
    for serial=1,900 do
        host.run.serial=serial
        host.inputs={paused=false,inhibitDefeat=false,motion={0,0,120*65536,80*65536,true,serial%256}}
        body.step(host)
        for _,slot in pairs(host.controlGroup.slots)do
            if slot.mode=='entry'and slot.vars[0]==1 then
                local handle=slot.vars[8]
                if body.tasks.alive(host.taskGroup,handle)then waited=true
                else assert(not released,'主任务在演出结束后仍卡住');released=true end
            elseif slot.mode=='pattern'then reached=true end
        end
        if reached then break end
    end
    assert(reached and waited and services>0,'主任务没有等待原生演出槽自然完成')
    assert(host.boxes[1].colli and host.boxes[2].colli,'演出结束没有恢复本体碰撞')
    local slots={host.clock,host.controlGroup,host.taskGroup,host.motion}
    for _,manager in ipairs({host.controlGroup,host.taskGroup})do
        for _,slot in pairs(manager.slots)do slots[#slots+1]=slot end
    end
    body.close(host);body.close(host)
    for i=0,399 do assert(not host.nativeParameters.used[i],'主任务/演出共享池回收失败')end
    return host,slots
end
