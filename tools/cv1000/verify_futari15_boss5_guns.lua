-- 炮台从独立原版回调的前置状态执行；自机输入供原生 heading 计算，不回放瞄准角。
return function(guns,reference)
    local objects,calls,index={},0,0
    local row,opindex
    local function compare(kind,args)
        local op=assert(row[11][opindex+1],row[4]..' 多调用炮台接口：'..kind)
        assert(op[1][1]==kind,row[4]..' 接口顺序：'..kind..' / '..op[1][1])
        assert(#args+1==#op[1],kind..' 参数数量不符')
        for i,value in ipairs(args)do
            assert(value==op[1][i+1],('%s 帧 %d %s 参数 %d：%s / %s'):format(
                row[4],row[1],kind,i,tostring(value),tostring(op[1][i+1])))
        end
        return op
    end
    local function invoke(_,kind,args)return compare(kind,args)[2]end
    local function observe(_,kind,args,value)
        local op=compare(kind,args)
        if kind=='aim'then
            assert(value==op[2],('%s 帧 %d 原生瞄准不符：%s / %s'):format(row[4],row[1],value,op[2]))
        end
        opindex,calls=opindex+1,calls+1
    end
    return{objects=objects,step=function()
        index=index+1;row=reference.steps[index]
        if not row then return true end
        opindex=0
        local host={run={serial=row[1]},raw={},renderDepth=row[13],
            controlCounter=row[12][1],motionInput={0,0,row[12][2],row[12][3],row[12][4]==0}}
        for i,a in ipairs(reference.fields)do host.raw[a]=row[7][i]end
        local manager=guns.create(host,{invoke=invoke,observe=observe})
        local _,o=guns.add(manager,row[4])
        if not row[4]:match('_init$')then
            guns.context.allocate(o,reference.sizes[row[4]])
            for i,n in ipairs(row[9])do o.vars[(i-1)*4]=n end
        end
        guns.stepSlot(o)
        assert(opindex==#row[11],row[4]..' 原版炮台接口未用完')
        assert(o.mode==row[5]and o.closed==not row[6],row[4]..' 切换或结束不符')
        for i,a in ipairs(reference.fields)do
            assert(host.raw[a]==row[8][i],('%s 帧 %d 身体 %x：%s / %s'):format(
                row[4],row[1],a,tostring(host.raw[a]),tostring(row[8][i])))
        end
        if row[6]then
            for i=1,#row[10],3 do
                local a,width,n=row[10][i],row[10][i+1],row[10][i+2]
                local actual=guns.parameters.read(o.block,a,width)
                assert(actual==n,('%s 帧 %d 私有 %x：%s / %s'):format(row[4],row[1],a,actual,n))
            end
        end
        objects[#objects+1]=o;objects[#objects+1]=manager
        guns.close(manager);guns.close(manager)
        for i=0,399 do assert(not host.nativeParameters.used[i],'炮台参数没有归还')end
        return false
    end,result=function()return index-1,calls end}
end
