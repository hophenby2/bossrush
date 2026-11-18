-- 合成外部场景输入；三段主任务各自等待实际炮台与关节任务自然结束。
-- 默认只校验出膛接口；realBullets 分支接实际队列和八类敌弹，演出图形仍由外部接口提供。
return function(body,player,realBullets)
    local unit=65536
    local objects,emissions={},0
    local created,rejected,kinds=0,0,{}
    local cases={{'pattern_init',{'first_a','first_b','first_c','first_d'}},
        {'second_init',{'second_a','second_b'}},{'third_init',{'third_a','third_b','third_c'}}}
    for index,case in ipairs(cases)do
        local host=body.create({serial=0},player)
        local remembered,seen,ended={},{},{}
        local shots,waits,complete=0,0,false
        local function remember(o)
            if o and not remembered[o]then remembered[o]=true;objects[#objects+1]=o end
        end
        remember(host);remember(host.clock)
        for _,o in ipairs(host.boxes)do remember(o)end
        local api={random=function()return 0 end,
            beforeSlot=function(_,o)remember(o)end,
            afterSlot=function(_,o)
                if o.manager==host.gunGroup then
                    local mode=o.mode:gsub('_init$','')
                    seen[mode]=true
                    if o.closed then ended[mode]=true end
                end
            end,
            observe=function(_,kind,args,value,o)
                if kind=='alive'and args[1]=='gun'and value then waits=waits+1 end
                if realBullets and(kind=='bullet'or kind=='fan')then shots=shots+1;emissions=emissions+1 end
            end,
            invoke=function(_,kind,args)
                if kind=='target_position'then return{120*unit,80*unit}
                elseif kind=='weapon_flag'then return false
                elseif kind=='camera'or kind=='root_offset'then return 0
                elseif kind=='scene_counter'then return 1747
                elseif kind=='queue_get'then return{0,0}
                elseif kind=='weapon_mode'then return{0,-1}
                elseif kind=='fan'or kind=='bullet'then
                    assert(args[1]>=0 and args[2]%1==0 and args[3]%1==0)
                    shots=shots+1;emissions=emissions+1
                elseif kind=='target_flip'or kind=='service'or kind=='timeline_call'
                    or kind=='signal'or kind=='layer'or kind=='queue_set'then
                else error('主任务/炮台合成联动出现未检查接口：'..kind)end
            end}
        remember(body.attachTasks(host,api));remember(body.attachGuns(host,api))
        remember(body.attachControl(host,api,case[1]))
        if realBullets then
            host.run.roadRank,host.run.roadFrame,host.run.roadFlash=128,0,0
            remember(body.attachBullets(host,{baseSpeed=54,allocated=function(_,args,o)
                if o then
                    created=created+1;kinds[args[1]]=true;o.colli=false;remember(o)
                else rejected=rejected+1 end
            end}))
        end
        for serial=1,14000 do
            host.run.serial=serial
            if realBullets then host.run.roadFrame=serial end
            host.inputs={paused=false,inhibitDefeat=false,motion={0,0,120*unit,80*unit,true,serial%256}}
            body.step(host);remember(host.motion)
            local all=true
            for _,mode in ipairs(case[2])do if not seen[mode]then all=false end end
            if all then
                if index<3 then
                    all=ended[case[2][#case[2]]]
                else
                    local slot=host.controlGroup.slots[1]
                    all=slot and slot.mode=='third'and slot.vars[0]==140 and shots>0
                end
                if all then complete=true;break end
            end
        end
        assert(complete and waits>0 and shots>0,'第 '..index..' 段未通过真实炮台寿命推进')
        assert(host.controlGroup.pool==host.gunGroup.pool and host.gunGroup.pool==host.taskGroup.pool)
        body.close(host);body.close(host)
        if realBullets then assert(not host.run.boss5Bullets and host.run.boss5BulletCount==0)end
        for i=0,399 do assert(not host.nativeParameters.used[i],'主任务/炮台/演出共享池没有回收')end
    end
    if realBullets then
        for _,kind in ipairs({18,19,21,37,46,51,58,59})do assert(kinds[kind],'原生队列未产生全部八种弹')end
    end
    return objects,emissions,created,rejected
end
