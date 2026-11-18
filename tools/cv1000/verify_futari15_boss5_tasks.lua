-- 每次回调从独立原版前置状态执行一次，再比较全量身体写入、私有写入和接口顺序。
-- 外部场景/武器输入来自探针，任务生命周期、关节公式和新任务分配由真实原生对象计算。
return function(tasks,reference)
    local objects,calls={},0
    local row,opindex
    local function compare(kind,args)
        local op=assert(row[12][opindex+1],'原生演出多调用接口：'..kind)
        assert(kind==op[1][1],row[4]..' 接口顺序不符：'..kind..' / '..op[1][1])
        assert(#args+1==#op[1],kind..' 参数数量不符')
        for i,value in ipairs(args)do
            assert(value==op[1][i+1],('%s 帧 %d %s 参数 %d：%s / %s'):format(
                row[4],row[1],kind,i,tostring(value),tostring(op[1][i+1])))
        end
        return op
    end
    local function invoke(_,kind,args)return compare(kind,args)[2]end
    local function observe(_,kind,args,value)
        local expected=compare(kind,args)[2]
        if kind=='spawn'or kind=='alive'then assert(value==expected,kind..' 句柄/存活状态不符')end
        opindex,calls=opindex+1,calls+1
    end
    local index=0
    return{objects=objects,
        step=function()
            index=index+1;row=reference.steps[index]
            if not row then return true end
            opindex=0
            local host={run={serial=row[1]},raw={},renderDepth=row[14]or 83,controlCounter=row[13]}
            for i,a in ipairs(reference.fields)do host.raw[a]=row[7][i]end
            local manager=tasks.create(host,{invoke=invoke,observe=observe})
            local _,o=tasks.add(manager,row[4],row[11])
            -- 组件回归由真实前置槽切入，不执行尚未采样到的父任务或其它槽。
            if not row[4]:match('_init$')and row[4]~='flash_resume'then
                tasks.context.allocate(o,60)
                for i,n in ipairs(row[9])do o.vars[(i-1)*4]=n end
            end
            local generated={}
            for _,op in ipairs(row[12])do if op[1][1]=='spawn'then generated[op[2]]=true end end
            for _,op in ipairs(row[12])do
                if op[1][1]=='alive'and op[2]and not generated[op[1][3]]then
                    local _,external=tasks.add(manager,'scene_init')
                    external.handle=op[1][3]
                end
            end
            for _,op in ipairs(row[12])do
                if op[1][1]=='spawn'then host.nativeHandle=(op[2]-1)%65536;break end
            end
            tasks.stepSlot(o)
            assert(opindex==#row[12],row[4]..' 原版接口未用完')
            assert(o.mode==row[5]and o.closed==not row[6],row[4]..' 切换/结束状态不符')
            for i,a in ipairs(reference.fields)do
                assert(host.raw[a]==row[8][i],('%s 帧 %d 身体 %x：%s / %s'):format(
                    row[4],row[1],a,tostring(host.raw[a]),tostring(row[8][i])))
            end
            if row[6]then
                for i=1,#row[10],2 do
                    local a,n=row[10][i],row[10][i+1]
                    assert(o.vars[a]==n,('%s 帧 %d 私有 %x：%s / %s'):format(
                        row[4],row[1],a,tostring(o.vars[a]),tostring(n)))
                end
            end
            objects[#objects+1]=o;objects[#objects+1]=manager
            local children={};for _,child in pairs(manager.slots)do children[#children+1]=child end
            tasks.close(manager);tasks.close(manager)
            for _,child in ipairs(children)do assert(child.closed);objects[#objects+1]=child end
            for i=0,399 do assert(not host.nativeParameters.used[i],'演出参数未归还')end
            return false
        end,
        result=function()return index-1,calls end,
    }
end
