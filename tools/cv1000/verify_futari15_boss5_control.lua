-- 主任务组件对照：外部子任务的返回值由独立探针提供，主任务自身由原生对象执行。
return function(control,host,reference)
    local run=host.run
    host.raw=host.raw or {}
    for a,n in pairs(reference.initial)do host.raw[a]=n end
    local index,operationIndex,calls,callbacks,multiples,closed=1,0,0,0,0,0
    local row,started
    local allSlots,seen={},{}
    local api={}
    local function operation(kind,args)
        local op=assert(row[10][operationIndex+1],'多调用了第五面接口 '..kind)
        assert(op[1][1]==kind,'第 '..row[1]..' 帧接口不符：'..kind..' / '..op[1][1])
        assert(#op[1]==#args+1,'第五面接口参数数目不符：'..kind)
        for i,value in ipairs(args)do
            if type(value)=='table'then value=value.sourceId end
            assert(value==op[1][i+1],('第 %d 帧 %s 第 %d 参数不符：%s / %s'):format(
                row[1],kind,i,tostring(value),tostring(op[1][i+1])))
        end
        return op
    end
    function api.invoke(_,kind,args)return operation(kind,args)[2]end
    function api.observe(_,kind,args,value)
        local op=operation(kind,args)
        if kind=='control'then
            assert(value~=0,'第五面原生主任务槽不足');value.sourceId=op[2]
        elseif kind=='alive'or kind=='motion_is'or kind=='spawn'or kind=='random'then
            assert(value==op[2],'第五面接口返回值不符')
        end
        operationIndex,calls=operationIndex+1,calls+1
    end
    function api.beforeSlot(_,o)
        if not seen[o]then seen[o]=true;allSlots[#allSlots+1]=o end
        row=assert(reference.steps[index],'原生管理器多执行了一个第五面主任务')
        assert(row[1]==run.serial and row[2]==o.sourceId and row[3]==o.index and row[4]==o.mode,
            '第 '..run.serial..' 帧第五面主任务顺序或入口不符：'..o.mode)
        for i=1,#row[7],2 do host.raw[row[7][i]]=row[7][i+1]end
        host.renderDepth=row[11]or 83
        host.controlCounter=row[12]
        operationIndex=0
    end
    function api.afterSlot(_,o)
        assert(operationIndex==#row[10],'第五面原版接口没有用完')
        assert(o.mode==row[5]and o.closed==not row[6],'第五面入口切换或回收不符')
        for i,at in ipairs(reference.fields)do
            assert(host.raw[at]==row[8][i],('第 %d 帧本体字段 %x 不符：%s / %s'):format(
                row[1],at,tostring(host.raw[at]),tostring(row[8][i])))
        end
        if not o.closed then
            for i=1,#row[9],2 do
                local a,n=row[9][i],row[9][i+1]
                assert(o.vars[a]==n,('第 %d 帧 %s 私有字段 %x 不符：%s / %s'):format(
                    row[1],row[4],a,tostring(o.vars[a]),tostring(n)))
            end
        end
        callbacks,index=callbacks+1,index+1
    end
    function api.close()closed=closed+1 end
    local manager=control.create(host,api,reference.steps[1][4])
    local initial=manager.slots[1]
    -- 分段组件从原版切入时的槽位继续；未执行的换段任务不由此测试伪造。
    local initialSlot=reference.steps[1][3]
    manager.slots[1]=nil;manager.slots[initialSlot]=initial
    initial.index,initial.sourceId=initialSlot,reference.steps[1][2]
    local test={manager=manager}
    function test.prepare()
        assert(not started)
        started=index;run.serial=reference.steps[index][1]
    end
    function test.check()
        assert(started and index>started,'第五面主任务没有推进')
        if index-started>1 then multiples=multiples+1 end
        started=nil
        local once=index;control.step(manager);assert(index==once,'同一步重复执行第五面主任务')
        if index<=#reference.steps then return false end
        assert(callbacks==reference.states and calls==reference.calls and multiples==reference.sameFrame)
        local slots={};for _,o in pairs(manager.slots)do slots[#slots+1]=o end
        control.close(manager);control.close(manager)
        assert(not host.controlGroup and closed==1)
        for _,o in ipairs(slots)do assert(o.closed)end
        test.slots,test.callbacks,test.calls=allSlots,callbacks,calls
        return true
    end
    return test
end
