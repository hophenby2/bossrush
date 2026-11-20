-- 栖霞园场景脚本直接驱动透视相机、雾和贴图几何。
local R,resolve=...
local E=R.env
local function visualRand()
    local state=1729
    local function sample()
        state=(state*48271)%2147483647
        return state/2147483647
    end
    return {
        Float=function(_,a,b) return a+(b-a)*sample() end,
        Int=function(_,a,b) return a+math.floor((b-a+1)*sample()) end,
        Sign=function() return sample()<.5 and -1 or 1 end,
    }
end

-- 纯画面随机数独立于弹幕随机数。相机近平面必须大于零。
E.database={setting={effect={background=true,background_mask=0}}}
local drawing=false
E.Set3D=function(key,a,b,c)
    if not drawing then return end
    if key=='z' then a=math.max(.01,a) end
    Set3D(key,a,b,c)
end
E.Render4V=function(name,...) return Render4V(resolve('img',name),...) end
E.GetTextureSize=function(name) return GetTextureSize(resolve('tex',name)) end
local rand=E.lstg.Rand
E.lstg.Rand=visualRand
R.load('EISlib/EGGlib/Background/Background.lua')
R.load('EISlib/EGGlib/Background/BgObj.lua')
for n=1,7 do
    R.load('EISlib/background/stage'..n..'bg.lua')
    local class=E['stage'..n..'_background']
    local init,render=class.init,class.render
    -- 复用原脚本私有 loadRes，仅提前资源 I/O，不调用背景 init 或消耗画面随机数。
    for i=1,100 do
        local name,fn=debug.getupvalue(init,i)
        if not name then break end
        if name=='loadRes' then class.prepareRogueResources=fn;break end
    end
    class.init=function(o,...)
        background.DelBG()
        init(o,...)
        o.layer=LAYER.BG-.1
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
    end
    class.render=function(o)
        if not setting.displayBG then return end
        local previous=lstg.view3d
        lstg.view3d={}
        SetViewMode('world')
        drawing=true
        render(o)
        drawing=false
        lstg.view3d=previous
        SetViewMode('world')
    end
end
E.lstg.Rand=rand
