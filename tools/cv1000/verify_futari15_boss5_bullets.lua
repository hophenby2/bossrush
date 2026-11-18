-- 构造输入来自出膛参数及原版相机查询；每步位置与绘制摘要只用于核对返回。
return function(bullets,reference)
    local function digest(values)
        local n=0;for _,v in ipairs(values)do n=(n*131+v)%16777213 end;return n
    end
    local caseIndex,stepIndex,o,run=1,1,nil,nil
    local objects,states,sprites,cancels={},0,0,0
    return{objects=objects,step=function()
        local case=reference.cases[caseIndex]
        if not case then return true end
        local c=case.input
        if not o then
            run={serial=c[1],roadRank=c[7],roadFlash=c[8],roadCameraDelta=0}
            o=bullets.create(run,c[3],c[4],c[5],c[6],c[2],{motion=#c[9]>0 and c[9]or nil,
                depthFlag=c[10],camera=c[11],baseSpeed=c[12]})
            o.colli=false -- 外部碰撞回调由独立记录输入，实际自机碰撞另测。
            objects[#objects+1]=o
        end
        local r=assert(case.steps[stepIndex])
        run.serial,run.roadCameraDelta=r[1],r[3]
        local dropIndex=0
        local function drop(...)
            dropIndex=dropIndex+1
            local expected=assert(r[8][dropIndex],'消弹多请求道具')
            for i,n in ipairs({...})do assert(n==expected[i],'消弹道具参数不符')end
        end
        if r[2]==4 then
            bullets.cancel(o,0,r[9],drop)
            stepIndex=stepIndex+1;return false
        end
        o.drop=drop
        if r[2]==1 or r[2]==3 then bullets.step(o)
        elseif r[2]==2 then
            local rows=o.rows;bullets.cancel(o,r[7])
            assert(o.rows==rows,'消弹覆盖了本步图形');cancels=cancels+1
        end
        assert(o.closed==(r[2]==3),'原版回调的自然回收不符')
        assert(dropIndex==#r[8],'原版消弹道具接口未执行')
        local values={}
        for _,field in ipairs(reference.fields)do values[#values+1]=assert(o[field])end
        values[#values+1]=o.motion and 1 or 0
        if o.motion then for _,field in ipairs(reference.motionFields)do values[#values+1]=assert(o[field])end end
        assert(digest(values)==r[4],('第 %d 帧弹型 %d 状态：%d / %d'):format(r[1],c[2],digest(values),r[4]))
        if r[2]~=2 then
            local draw,count={},0
            bullets.draw(o,function(...)
                count=count+1;for _,v in ipairs({...})do draw[#draw+1]=v end
            end)
            assert(count==r[6]and digest(draw)==r[5],('第 %d 帧弹型 %d 绘图：%d/%d / %d/%d')
                :format(r[1],c[2],count,digest(draw),r[6],r[5]))
            sprites=sprites+count
        end
        states=states+1;stepIndex=stepIndex+1
        if stepIndex>#case.steps then
            bullets.close(run);bullets.close(run)
            assert(o.closed and not run.boss5Bullets)
            o,run=nil,nil;caseIndex,stepIndex=caseIndex+1,1
        end
        return false
    end,result=function()return #reference.cases,states,sprites,cancels end}
end
