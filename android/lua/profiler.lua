-- 仅在应用私有 User/android-diagnostics 内容为 profile 时启用。
local P, clock = { samples={} }, lstg.AndroidClock
if lstg.AndroidTextProfile then lstg.AndroidTextProfile(true) end
for _, namespace in ipairs({lstg,_G}) do
for _, name in ipairs({'Render','RenderTexture','RenderTTF','RenderText','Render4V',
    'SetFog','SetImageState','SetViewMode','BeginScene','EndScene'}) do
    local fn = namespace[name]
    if fn then
        local sample = {name=(namespace==lstg and 'native.' or '')..name,time=0,calls=0}; P.samples[#P.samples+1]=sample
        namespace[name] = function(...)
            local started=clock()
            local result=fn(...)
            sample.time=sample.time+clock()-started; sample.calls=sample.calls+1
            return result
        end
    end
end
end
function P.report(frames)
    table.sort(P.samples,function(a,b) return a.time>b.time end)
    local parts={}
    for i,s in ipairs(P.samples) do
        if i<=8 then parts[#parts+1]=string.format('%s=%.2fms/%.1fcalls',s.name,s.time*1000/frames,s.calls/frames) end
        s.time,s.calls=0,0
    end
    lstg.SystemLog('BOSSRUSH_PROFILE: '..table.concat(parts,' '))
    if lstg.AndroidTextProfile then
        local lookup,setup,visit,calls=lstg.AndroidTextProfile()
        lstg.SystemLog(string.format('BOSSRUSH_TEXT: lookup=%.2f setup=%.2f visit=%.2f ms/frame calls=%.1f',
            lookup*1000/frames,setup*1000/frames,visit*1000/frames,calls/frames))
    end
end
return P
