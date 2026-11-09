-- 私有 profile 诊断才安装；按帧汇总，递归调用只计最外层耗时。
local P,clock={samples={},ordered={},maxFrames=512},lstg.AndroidClock
local function sample(name)
    local s=P.samples[name]
    if not s then
        s={name=name,depth=0,elapsed=0,calls=0,frames={}}
        for i=1,math.min(P.frameIndex or 0,P.maxFrames) do s.frames[i]=0 end
        P.samples[name]=s;P.ordered[#P.ordered+1]=s
    end
    return s
end
function P.begin(name)
    local s=sample(name)
    if s.depth==0 then s.started=clock() end
    s.depth=s.depth+1;s.calls=s.calls+1
end
function P.finish(name)
    local s=sample(name);s.depth=s.depth-1
    assert(s.depth>=0,'性能计时未配对：'..name)
    if s.depth==0 then s.elapsed=s.elapsed+clock()-s.started end
end
local function wrap(namespace,key,name)
    local fn=namespace and namespace[key]
    if not fn then return end
    local function finish(...) P.finish(name);return ... end
    namespace[key]=function(...) P.begin(name);return finish(fn(...)) end
end
-- 保留多返回值和 nil 空位，诊断不能改变被包装接口的语义。
for _,key in ipairs({'ObjFrame','BoundCheck','UpdateXY','AfterFrame','ObjRender'}) do wrap(_G,key,key) end
local collision=CollisionCheck
if collision then
    local function finish(name,...) P.finish(name);P.finish('CollisionCheck');return ... end
    CollisionCheck=function(a,b,...)
        local name=type(a)=='number' and type(b)=='number' and ('collision.group.'..a..'.'..b) or 'collision.custom'
        P.begin('CollisionCheck');P.begin(name)
        return finish(name,collision(a,b,...))
    end
end
for _,key in ipairs({'begin','shots','secondary','finish'}) do wrap(OriginalCollision,key,'collision.'..key) end
for _,key in ipairs({'step','draw'}) do wrap(OriginalANM,key,'anm.'..key) end
for _,namespace in ipairs({lstg,_G}) do
    for _,key in ipairs({'Render','RenderTexture','RenderTTF','RenderText','Render4V','AndroidRenderSprite',
        'SetFog','SetImageState','SetViewMode','BeginScene','EndScene','PlaySound','LoadTexture','LoadImage','SaveTexture'}) do
        wrap(namespace,key,(namespace==lstg and 'native.' or '')..key)
    end
end
if lstg.AndroidTextProfile then lstg.AndroidTextProfile(true) end
P.previousKB=collectgarbage('count')
function P.frame(elapsed,timestamp)
    if timestamp and P.previousFrameAt then
        local interval=sample('frame.interval')
        interval.elapsed=interval.elapsed+timestamp-P.previousFrameAt;interval.calls=interval.calls+1
    end
    P.previousFrameAt=timestamp
    local s=sample('frame.cpu');s.elapsed=s.elapsed+elapsed;s.calls=s.calls+1
    for _,row in ipairs(P.ordered) do
        row.frames[#row.frames+1]=row.elapsed*1000
        row.total=(row.total or 0)+row.elapsed;row.elapsed=0
        if #row.frames>P.maxFrames then table.remove(row.frames,1) end
    end
    P.frameIndex=(P.frameIndex or 0)+1
end
function P.report(frames)
    lstg.SystemLog('BOSSRUSH_PROFILE_WINDOW: frames='..frames)
    for _,s in ipairs(P.ordered) do
        local values=s.frames;table.sort(values)
        if s.calls>0 then
            lstg.SystemLog(string.format('BOSSRUSH_PROFILE: %s=%.3f/%.3f/%.3fms,%.1fcalls',s.name,
                (s.total or 0)*1000/frames,values[math.max(1,math.ceil(#values*.95))] or 0,
                values[math.max(1,math.ceil(#values*.99))] or 0,s.calls/frames))
        end
        s.total,s.calls=0,0;s.frames={}
    end
    -- 各项有嵌套，不能直接相加；分行避免 logcat 截断。
    local kb=collectgarbage('count')
    lstg.SystemLog(string.format('BOSSRUSH_MEMORY: lua_kb=%.1f delta_kb=%.1f',kb,kb-P.previousKB));P.previousKB=kb
    if lstg.AndroidTextProfile then
        local lookup,setup,visit,calls=lstg.AndroidTextProfile()
        lstg.SystemLog(string.format('BOSSRUSH_TEXT: lookup=%.3f setup=%.3f visit=%.3f ms/frame calls=%.1f',
            lookup*1000/frames,setup*1000/frames,visit*1000/frames,calls/frames))
    end
    P.frameIndex=0
end
AndroidProfiler=P
return P
