-- 每份原版请求独立建立原生队列；其它原版对象的占用数是显式外部输入。
return function(factory,reference)
    local index,calls,failed=0,0,0
    local objects={}
    return{objects=objects,step=function()
        index=index+1;local row=reference[index]
        if not row then return true end
        local frame,c,expected=row[1],row[2],row[3]
        local run={serial=frame,roadFrame=frame,roadRank=128,roadCamera=0,roadFlash=0}
        local offset=0
        local manager=factory.create(run,{baseSpeed=54,externalCount=function()return c[14]end,
            allocated=function(_,args,o)
                offset=offset+1;calls=calls+1
                local e=assert(expected[offset],'队列多分配敌弹')
                for i,n in ipairs(args)do assert(n==e[i],'原版队列展开参数不符')end
                assert((o~=nil)==(e[7]==1),'原版许可上限或分配失败不符')
                if o then o.colli=false;objects[#objects+1]=o else failed=failed+1 end
            end})
        objects[#objects+1]=manager
        local args={c[1],c[2],c[3],c[4],c[5],c[6]}
        local kind='bullet'
        if c[7]==2 then kind='fan';args={c[1],c[2],c[3],c[4],c[5],c[8],c[9],c[6]}end
        assert(factory.enqueue(manager,kind,args))
        factory.flush(manager)
        assert(offset==#expected,'原版队列分配未用完')
        factory.close(manager);factory.close(manager)
        assert(not run.boss5BulletFactory and not run.boss5Bullets and run.boss5BulletCount==0)
        return false
    end,result=function()return #reference,calls,failed end}
end
