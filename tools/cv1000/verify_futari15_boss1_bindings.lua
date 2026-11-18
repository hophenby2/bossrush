-- 第一段全部主任务查询真实的原生子对象；移动和跳跃物理由外部输入，不在此替代运动回归。
-- 随机数是外部输入，存活查询返回值不能从样本代入。
-- 图形/声音请求在这里计数；不据此声称特效、轨迹或整场战斗已还原。
return function(body,player)
    local ref=dofile('tools/cv1000/fixtures/futari15_boss1_control.lua')
    local run={serial=ref.steps[1][1]-1}
    local host=body.create(run,player,0)
    local index,operationIndex,callbacks,calls,queries,shots,effects=1,0,0,0,0,0,0
    local row
    local visited={}
    local function operation(kind,args)
        local op=assert(row[9][operationIndex+1],'多调用了原版接口 '..kind)
        assert(op[1][1]==kind and #op[1]==#args+1,'原版接口不符：'..kind)
        for i,value in ipairs(args)do
            if type(value)=='table'then value=value.sourceId end
            assert(value==op[1][i+1],'第 '..run.serial..' 帧 '..kind..' 第 '..i..' 参数不符')
        end
        return op
    end
    local ports={}
    ports.random=function(n)return operation('random',{n})[2]end
    ports.side=function()return 0 end
    ports.gunRandom=function()return 0 end
    ports.rank=function()return 43 end
    ports.motion=function()end
    ports.signal=function()end
    ports.emit=function()shots=shots+1 end
    ports.emitFan=function(_,_,_,_,_,_,count)shots=shots+count end
    ports.emitMotionFan=ports.emitFan
    ports.child=function(r,_,x,y,owner,angle,speed,flags)
        local o=body.children.create(r,x,y,owner,angle,speed,flags,{
            bomb=function()return false end,random=function()return 0 end,
            explode=function()error('联动用例的子敌机不应触发爆炸')end})
        visited[o]=true;return o
    end
    ports.effect=function()effects=effects+1 end
    ports.gunDone=function()
        for _,o in pairs(host.taskGroup.slots)do visited[o]=true end
    end
    ports.observe=function(_,kind,args,result)
        local op=operation(kind,args)
        if kind=='spawn'or kind=='control'then
            assert(result~=0,'原生子任务分配失败');result.sourceId=op[2];visited[result]=true
        elseif kind=='alive'then
            assert(result==op[2],'第 '..run.serial..' 帧真实子对象结束时机与原版不同')
            queries=queries+1
        elseif kind=='random'then assert(result==op[2])end
        calls,operationIndex=calls+1,operationIndex+1
    end
    ports.beforeSlot=function(_,o)
        row=assert(ref.steps[index],'主任务多执行了一次')
        assert(row[1]==run.serial and row[2]==o.sourceId and row[3]==o.mode,
            '第 '..run.serial..' 帧主任务顺序或入口不符：'..o.mode)
        for i=1,#row[6],2 do
            -- 其余字段由本体/主任务/演出自己产生，不能用样本修正子对象的状态。
            local at=row[6][i]
            if at==20 or at==24 or at==28 or at==32 then host.raw[at]=row[6][i+1]end
        end
        operationIndex=0
    end
    ports.afterSlot=function(_,o)
        assert(operationIndex==#row[9],'原版接口没有用完')
        assert(o.mode==row[4]and o.closed==not row[5],'主任务切换或回收不符')
        for i,at in ipairs(ref.fields)do
            assert(host.raw[at]==row[7][i],'第 '..run.serial..' 帧本体字段 '..at..' 不符')
        end
        for i=1,#row[8],2 do
            local value=o.vars[row[8][i]]
            if type(value)=='table'then value=value.sourceId end
            assert(value==row[8][i+1],'主任务私有字段不符：'..row[8][i])
        end
        callbacks,index=callbacks+1,index+1
    end
    ports.observeTask=function(_,kind,_,result)
        if kind=='spawn'then visited[result]=true end
    end
    local api=body.makeControlAPI(host,ports)
    local manager=body.attachControl(host,api)
    manager.slots[1].sourceId=ref.steps[1][2];visited[manager.slots[1]]=true
    local function state()
        return index,callbacks,calls,queries,shots,effects,visited
    end
    return host,run,manager,state,ref
end
