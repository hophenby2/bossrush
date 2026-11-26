-- 同一真实弹幕和输入比较池化开关；快照保存数值，不保留可复用的状态表身份。
arg={'port-object-pools'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
AfterFrame=AfterFrame or function()end
local Spring=dofile('mod/GAME/th37/runtime.lua')
local Snow=dofile('mod/GAME/th38/runtime.lua')
Spring.sound=function()end
local originalNew=New
local nativeStub=os.getenv('BOSSRUSH_POOL_NATIVE_STUB')=='1'
do
    local originalStage,originalAPI=stage,lstg.AndroidNewSourceObjectFromTable
    local retired={}
    stage={current_stage={timer=0}}
    New=function(_,s)return {source=s}end
    lstg.AndroidNewSourceObjectFromTable=function(_,body,s)
        assert(retired[body]<stage.current_stage.timer,'同帧复用仍被引擎持有的实例')
        body.source=s;return body
    end
    local pool=dofile('mod/GAME/ports/object_pool.lua').new(8,0)
    local a,b=pool.newObject({},{}),pool.newObject({},{})
    retired[a],retired[b]=0,0;pool.retireObject(a);pool.retireObject(b)
    stage.current_stage.timer=1
    local stillHeld=pool.newObject({},{})
    assert(stillHeld~=a and stillHeld~=b,'关卡计时递增后过早复用原生实例')
    retired[stillHeld]=0;pool.retireObject(stillHeld)
    AfterFrame()
    local first=pool.newObject({},{})
    retired[first]=1;pool.retireObject(first)
    local second=pool.newObject({},{})
    assert(first~=second and (second==a or second==b),'同帧暂存对象挡住了已安全释放的实例')
    assert(pool.stats().bodyCreated==3 and pool.stats().bodyReused==2,'实例复用未命中')
    pool.clearBodies();assert(pool.stats().bodyAvailable==0)
    stage,lstg.AndroidNewSourceObjectFromTable,New=originalStage,originalAPI,originalNew
    print('PASS 原生实例缓存：同帧隔离不阻塞可用实例，跨帧后才复用')
end
local function check(runtime,key,frames)
    local snapshots={}
    for _,enabled in ipairs({false,true})do
        runtime.useStatePool=enabled
        local objects,births={},{}
        local originalAPI=lstg.AndroidNewSourceObjectFromTable
        local function record(o)
            objects[#objects+1]=o
            local s=o.mhj or o.asl
            if s and (s.is_projectile or s.kind=='bullet') then
                births[#births+1]=table.concat({s.type or s.shape,s.fx or s.x,s.fy or s.y,s.life},',')
            end
            return o
        end
        New=function(cls,...)return record(originalNew(cls,...))end
        if nativeStub then
            lstg.AndroidNewSourceObjectFromTable=function(cls,o,...)
                setmetatable(o,{__index=cls})
                o.class,o.timer,o.ani,o.hscale,o.vscale=cls,0,0,1,1
                o.x,o.y,o.rot,o._live=0,0,0,true
                cls.init(o,...)
                return record(o)
            end
        end
        player.x,player.y,player.protect=0,-180,100000
        ran.Float=function(_,a,b)return (a+b)/2 end
        local c=runtime.controller({_live=true,x=0,y=100,hp=20000},key)
        local rows={}
        for tick=1,frames do
            runtime.tick(c)
            if runtime==Spring then
                local n=#objects
                if tick==600 then for i=1,n do local o=objects[i];if IsValid(o) and o.mhj then o.class.kill(o) end end end
                for i=1,n do local o=objects[i];if IsValid(o) and o.class.frame then o.class.frame(o) end end
            end
            if tick%17==0 then
                local states={}
                for _,o in ipairs(objects)do if IsValid(o)then
                    local s=o.mhj or o.asl
                    if s and (s.is_projectile or s.kind=='bullet')then
                        states[#states+1]=table.concat({s.serial or 0,s.age,s.type or s.shape,s.fx or s.x,s.fy or s.y,
                            s.sonspeed or s.speed,s.sonspeedd or s.direction,s.alpha,s.wscale or s.scaleX,s.hscale or s.scaleY,tostring(s.dis)},',')
                        if o.class.render then o.class.render(o)end
                    end
                end end
                table.sort(states);rows[#rows+1]=table.concat(states,'\n')
            end
            if runtime==Snow then runtime.effects.render(c,'attack');runtime.effects.render(c,'end') end
            AfterFrame()
            if nativeStub or tick%60==0 then local live={};for _,o in ipairs(objects)do if IsValid(o)then live[#live+1]=o end end;objects=live end
        end
        rows[#rows+1]=table.concat(births,'\n')
        -- 切场景可能先 RawDel 引擎对象；之后的作品清理仍必须归还状态并解除父子引用。
        for _,o in ipairs(objects)do if IsValid(o)then o._live=false end end
        if runtime==Snow then runtime.transition(c,key,false,true) end
        runtime.clearAll()
        assert(runtime.statePoolStats().pending==0,'清场仍持有已退役状态：'..key)
        local stats=runtime.statePoolStats()
        assert(stats.available==stats.created,'RawDel 后有状态没有归还：'..key)
        snapshots[#snapshots+1]=table.concat(rows,'\n--frame--\n')
        lstg.AndroidNewSourceObjectFromTable=originalAPI
    end
    New=originalNew
    assert(snapshots[1]==snapshots[2],'池化改变了发弹、运动、事件、透明度或消弹：'..key)
    local s=runtime.statePoolStats();assert(s.reused>0,'没有覆盖状态复用')
    print('PASS '..key..'：开关池化的出生/运动/事件/绘制快照一致，复用 '..s.reused..' 次，清场 pending=0')
end
Render4V=function()end
check(Spring,'366',1500)
check(Snow,'L/stage1/boss1/2',900)
check(Snow,'L/stage1/boss2/1',900)
