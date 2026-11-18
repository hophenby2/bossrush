-- 同一验证器既供 LuaJIT 使用，也供真正的 Sub 引擎对象生命周期测试使用。
return function(core,fixture)
    local run={serial=0}
    local p={pilotPosition={x=120*65536,y=160*65536}}
    local events={}
    local o=core.create(run,p,function(_,event)events[#events+1]=event end)
    for _,r in ipairs(fixture.birth or{})do assert(o.raw[r[1]]==r[2],'原版构造器血量字段不符')end
    for i,at in ipairs(fixture.fields)do
        assert(core.fields[i]==at,'回归字段次序改变')
        o.raw[at]=fixture.initial[i]
    end
    core.enable(o,true)
    local hashes,counts={0,0},{0,0}
    local function hash(h,n)return(h*131+n)%16777213 end
    for _,c in ipairs(fixture.calls)do
        local op,n,frame,input,flags,inhibit,delta,info=unpack(c)
        for i=1,#delta,2 do o.raw[fixture.fields[delta[i]]]=delta[i+1]end
        core.refresh(o)
        o.defeatInhibited=inhibit~=0
        for _=1,n do
            local result=0
            if op==1 then
                result=o.boxes[1].damage(o.boxes[1],input,{damageFlags=flags,sourceInfo=#info>0 and info or nil})
            else core.advance(o,input~=0,inhibit~=0)end
            local h=hash(hashes[op],frame)
            for _,at in ipairs(fixture.fields)do h=hash(h,o.raw[at])end
            hashes[op]=hash(h,result)
            counts[op]=counts[op]+1
        end
    end
    for i=1,2 do
        assert(counts[i]==fixture.counts[i],'原版回调数量不符')
        assert(hashes[i]==fixture.hashes[i],'第五面受弹/倒数状态不符：'..i..' '..hashes[i]..' / '..fixture.hashes[i])
    end
    assert(#events==#fixture.transitions,'换段请求数量不符')
    for i,e in ipairs(events)do
        local r=fixture.transitions[i]
        assert(e.phase==(r[3]~=0 and 3 or r[2]))
        assert(e.score==(r[5]==2 and 0 or 900000+e.phase*100000))
        assert(e.cause==(r[5]==2 and'timeout'or'damage'))
    end
    core.close(o);core.close(o)
    return counts,#events,o
end
