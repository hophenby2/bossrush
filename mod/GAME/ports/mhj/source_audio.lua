-- 原作 XACT cue；波形无损导出，音频随机数独立于弹幕随机数。
local A={}
function A.new(work)
    local data=dofile('mod/GAME/th'..work..'/sounds.lua')
    local loaded,driver={},nil
    local Driver=Class(object,{
        init=function(o)
            o.group,o.bound,o.hide=GROUP.GHOST,false,true
            o.active,o.played,o.environment={}, {}, {};o.envScale=1
        end,
        frame=function(o)
            if o.envFade then
                local f=o.envFade
                f.left=f.left-1;o.envScale=o.envScale+f.step
                if f.left<=0 then o.envScale=f.target;o.envFade=nil end
                for id,gain in pairs(o.environment) do lstg.SetSourceSoundVolume(id,gain*o.envScale) end
            end
            for name,event in pairs(o.active) do
                if o.timer>=event.next then
                    if event.left==0 then o.active[name]=nil
                    else
                        PlaySound(event.id,event.volume*(event.environment and o.envScale or 1),event.pan)
                        event.next=event.next+event.period
                        if event.left~=255 then event.left=event.left-1 end
                    end
                end
            end
        end,
        del=function(o) for _,id in pairs(loaded) do StopSound(id) end end,
    })
    local api={}
    function api.hasCue(name)
        return name and data.cues[name:gsub('%.wav$','')]~=nil
    end
    function api.prepare(name)
        name=name:gsub('%.wav$','')
        local cue=assert(data.cues[name],'未导出的原作音效：'..name)
        if not loaded[name] then
            local id='mhj_source_'..work..'_'..name
            local pool=GetResourceStatus();SetResourceStatus('global')
            LoadSound(id,data.waves[cue.wave+1].path)
            SetResourceStatus(pool);loaded[name]=id
        end
        return loaded[name]
    end
    function api.play(name,position)
        name=name:gsub('%.wav$','')
        local cue=assert(data.cues[name],'未导出的原作音效：'..name)
        if not driver or not IsValid(driver) then driver=New(Driver) end
        local stamp=stage.current_stage and stage.current_stage.timer or driver.timer
        if driver.played[name]==stamp then return end
        driver.played[name]=stamp
        local id=api.prepare(name)
        local pitch=cue.pitch[1]+math.random()*(cue.pitch[2]-cue.pitch[1])
        local speed=2^pitch
        if SetSESpeed then SetSESpeed(id,speed) end
        local center=work==37 and 224 or 336
        local pan=math.max(-1,math.min(1,((position or center)-center)/(center*2)*.75))
        local gain=cue.volume*(work==39 and cue.category==3 and 1 or 3)
        if name:sub(1,3)=='tan' then
            local gap=driver.timer-(driver.lastShot or driver.timer-10)
            driver.tanScale=(1+math.min(1,gap/10))*.5
            driver.lastShot=driver.timer
        end
        if cue.category==3 then gain=gain*(driver.tanScale or 1) end
        local environment=cue.category==4
        if environment then driver.environment[id]=gain end
        PlaySound(id,gain*(environment and driver.envScale or 1),pan)
        if cue['repeat']>0 then
            local period=data.waves[cue.wave+1].duration*60/speed
            driver.active[name]={id=id,volume=gain,pan=pan,next=driver.timer+period,period=period,left=cue['repeat'],environment=environment}
        end
    end
    function api.stop(name)
        name=name:gsub('%.wav$','')
        if loaded[name] then StopSound(loaded[name]) end
        if driver and IsValid(driver) then driver.active[name]=nil end
    end
    function api.clear()
        if driver and IsValid(driver) then Del(driver) end
        driver=nil
    end
    function api.fadeEnvironment(seconds,fadeIn)
        if not driver or not IsValid(driver) then driver=New(Driver) end
        if fadeIn then
            for id in pairs(driver.environment) do StopSound(id) end
            for name,event in pairs(driver.active) do if event.environment then driver.active[name]=nil end end
        end
        local frames=math.max(1,seconds*60)
        local target=fadeIn and 1 or 0
        driver.envFade={left=frames,target=target,step=(target-driver.envScale)/frames}
    end
    return api
end
return A
