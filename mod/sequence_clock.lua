-- 原作道中有各自独立的时钟：只在WAIT_BOSS处冻结，不能用击破后的整段重播替代。
-- TH07时间轴普通创建受BossPresent控制；TH10仅265..268/271的条件创建受控制。
local C={}
function C.new(options)
    local c={times={},blocked={},markers=options.markers or {},actors={},primary=options.primary or 0,
        length=assert(options.length),native=options.native,explicitEnd=options.explicitEnd,metadata=options.metadata,onMid=options.onMid,
        onTime=options.onTime,presence=options.presence or {}}
    for _,m in ipairs(c.markers) do m.fired=false end
    return setmetatable(c,{__index=C})
end
function C:midAlive()
    for _,o in ipairs(self.actors) do if IsValid(o) then return true end end
    return false
end
function C:fire(marker)
    if marker.fired then return end
    marker.fired=true
    assert(not self:midAlive(),'下一组道中Boss不能覆盖仍在场的上一组')
    self.actors=assert(self.onMid(marker),'道中Boss创建没有返回实例')
end
function C:setTime(timeline,time)
    self.times[timeline]=time
    if self.native and not self.explicitEnd then
        for _,m in ipairs(self.markers) do
            if (m.timeline or self.primary)==timeline and time>=m.time then self:fire(m) end
        end
    end
    if self.native and self.explicitEnd then
        -- 五面/EX的原始main永久等待，实际流程由异步链续接；入口子线程结束后仍显示后继进度。
        if time>=(self.displayTime or 0) then self.displayTime=time;if self.onTime then self.onTime(time) end end
    elseif timeline==self.primary then
        if self.onTime then self.onTime(time) end
        if not self.explicitEnd and time>=self.length then self.done=true end
    end
end
function C:wait(timeline,frames)
    local time=self.times[timeline] or 0
    for _=1,frames do
        task.Wait()
        time=time+1;self:setTime(timeline,time)
    end
end
function C:waitBoss(timeline)
    while self:midAlive() do
        self.blocked[timeline]=(self.blocked[timeline] or 0)+1
        task.Wait()
    end
end
function C:canSpawn(opcode)
    if self.native then
        if opcode and ((opcode>=265 and opcode<=268) or opcode==271) then
            if self:midAlive() then return false end
            local time=self.times[self.primary] or 0
            for _,range in ipairs(self.presence) do if time>=range[1] and time<range[2] then return false end end
        end
        return true
    end
    return not self:midAlive()
end
-- TH10手写/导出程序的主协程和异步子协程分别计时；deathWait只阻塞调用者。
function C:nativeWait(frames)
    local co=coroutine.running()
    if not self.mainCo then self.mainCo=co;self.coTimes=self.coTimes or setmetatable({},{__mode='k'}) end
    local timeline=co==self.mainCo and self.primary or co
    if self.times[timeline]==nil then self.times[timeline]=self.coTimes[co] or 0 end
    self:wait(timeline,frames)
end
function C:nativeAsync(co,primary)
    self.coTimes=self.coTimes or setmetatable({},{__mode='k'})
    local caller=coroutine.running()
    local timeline=caller==self.mainCo and self.primary or caller
    self.coTimes[co]=self.times[timeline] or self.coTimes[caller] or 0
    if primary then self.mainCo=co end
end
function C:nativeBossWait()
    local co=coroutine.running()
    self:waitBoss(co==self.mainCo and self.primary or co)
end
-- 每条TH07时间轴单独执行：某条等待Boss时，其它时间轴继续前进并跳过被压制的创建。
function C:eachWave(owner,waves,spawn)
    local metadata=assert(self.metadata)
    assert(#waves==#metadata.waves,'原作波表与时间轴归属数量不一致')
    local lists={}
    for timeline=0,metadata.count-1 do lists[timeline]={} end
    local time=0
    for i,w in ipairs(waves) do
        time=time+w[1]
        local source=metadata.waves[i]
        local list=lists[source[1]]
        list[#list+1]={time=time,order=source[2],wave=w}
    end
    for timeline,waits in pairs(metadata.waits) do
        for _,w in ipairs(waits) do
            lists[timeline][#lists[timeline]+1]={time=w[1],order=w[2],wait=true}
        end
    end
    for _,m in ipairs(self.markers) do
        lists[m.timeline][#lists[m.timeline]+1]={time=m.time,order=m.order or 0,marker=m}
    end
    for timeline=0,metadata.count-1 do
        local id,events=timeline,lists[timeline]
        table.sort(events,function(a,b) return a.time==b.time and a.order<b.order or a.time<b.time end)
        task.New(owner,function()
            local previous=0
            self:setTime(id,0)
            for _,e in ipairs(events) do
                if e.time>self.length then break end
                if e.time>previous then self:wait(id,e.time-previous) end
                previous=e.time
                if e.marker then self:fire(e.marker)
                elseif e.wait then self:waitBoss(id)
                elseif self:canSpawn() then spawn(e.wave) end
            end
            if previous<self.length then self:wait(id,self.length-previous) end
        end)
    end
end
return C
