-- 原版分层贴图的 LuaSTG 背景和曲目切换。坐标以当前战斗区为准。
local M={}
local function drawLayers(o,layers,alpha)
    local w=lstg.world
    local width,height=w.r-w.l,w.t-w.b
    for _,layer in ipairs(layers or {}) do
        local name,rate,opacity,rect=unpack(layer)
        local x1,y1,x2,y2=0,0,1,1
        if rect then x1,y1,x2,y2=unpack(rect) end
        local l,r=w.l+width*x1,w.l+width*x2
        local b,t=w.b+height*y1,w.b+height*y2
        local key=o.mediaPrefix..name
        SetImageState(key,'',math.floor((opacity or 255)*alpha),255,255,255)
        if rate and rate~=0 then
            local h=t-b
            local y=b+(o.timer*rate)%h
            RenderRect(key,l,r,y,y+h)
            RenderRect(key,l,r,y-h,y)
        else
            RenderRect(key,l,r,b,t)
        end
    end
end

function M.background(prefix,road,boss)
    return Class(background,{
        init=function(o)
            o.android_direct_background=true
            background.init(o,false)
            o.mediaPrefix=prefix
        end,
        frame=function(o)
            local goal=o.mediaSpell and 1 or 0
            local a=o.mediaAlpha or 0
            o.mediaAlpha=a+math.max(-.05,math.min(.05,goal-a))
        end,
        render=function(o)
            SetViewMode('world')
            RenderClearViewMode(Color(255,14,18,33))
            if setting.displayBG==false then return end
            drawLayers(o,road,1)
            if (o.mediaAlpha or 0)>0 then
                drawLayers(o,boss and (boss[o.mediaVariant or 2] or boss[2]),o.mediaAlpha)
            end
        end,
    })
end

function M.loadLayers(prefix,directory,...)
    for _,layers in ipairs({...}) do
        for _,layer in ipairs(layers) do
            local name=layer[1]
            local key=prefix..name
            if not CheckRes('img',key) then LoadImageFromFile(key,directory..name..'.png') end
        end
    end
end

function M.bgm(scene,id,seconds)
    if scene.sequence_music==id then return end
    if scene.sequence_music then StopMusic(scene.sequence_music) end
    scene.sequence_music=id
    if id and (not GetMusicState or GetMusicState(id)~='playing') then PlayMusic(id,1,seconds) end
end

function M.install(game,sets,cues)
    local prefix=('TH%d_'):format(game)
    local directory=('Resources/th%d/media/'):format(game)
    for id,track in pairs(dofile(('mod/GAME/th%d/media_tracks.lua'):format(game))) do
        AddMusic(prefix..('%02d'):format(id),track[1],track[2],prefix..id,true)
    end
    local T={sets=sets}
    function T.track(number,kind)
        local cue=cues[number]
        return prefix..('%02d'):format(assert(cue[kind] or cue.boss))
    end
    function T.play(scene,number,kind,seconds)
        M.bgm(scene,T.track(number,kind),seconds)
    end
    function T.fade(scene,seconds)
        local id=scene.sequence_music
        if not id then return end
        task.New(scene,function()
            local frames=math.max(1,math.floor(seconds*60))
            for i=1,frames do
                if scene.sequence_music~=id then return end
                SetBGMVolume(id,1-i/frames)
                task.Wait()
            end
            if scene.sequence_music==id then M.bgm(scene,nil) end
        end)
    end
    for number,set in ipairs(sets) do
        local key=prefix..number..'_'
        local class=M.background(key,set.road,set.spells)
        local init=class.init
        class.init=function(o)
            init(o)
            M.loadLayers(key,directory,set.road)
            for _,layers in pairs(set.spells) do M.loadLayers(key,directory,layers) end
        end
        T[number]=class
    end
    function T.enter(scene,number)
        local current=lstg.tmpvar.bg
        if not IsValid(current) or current.class~=T[number] then New(T[number]) end
        T.play(scene,number,'road')
    end
    function T.card(spell,variant)
        local current=lstg.tmpvar.bg
        if IsValid(current) and current.mediaPrefix then
            current.mediaSpell,current.mediaVariant=spell,variant
        end
    end
    return T
end
return M
