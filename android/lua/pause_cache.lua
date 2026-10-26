-- 暂停时场景已冻结：只捕获并模糊一次，后续帧仅绘制菜单与缓存图像。
local C = { ready=false }
function C.invalidate() C.ready=false; C.stage=nil end
function C.install()
    local pool=GetResourceStatus()
    SetResourceStatus('global')
    CreateRenderTarget('android:pause-blur')
    LoadFX('android:pause-copy','shader/screen_save.hlsl')
    SetResourceStatus(pool)
    local effect,render=PostEffect,RenderFunc
    local function post(fx,target,sampler,blend,constants,textures)
        if fx~='fx:pause_menu_blur' then return effect(fx,target,sampler,blend,constants,textures) end
        if not C.ready then
            PushRenderTarget('android:pause-blur'); RenderClear(Color(255,0,0,0))
            effect(fx,target,sampler,blend,constants,textures)
            PopRenderTarget('android:pause-blur'); C.ready=true
        end
        return effect('android:pause-copy','android:pause-blur',sampler,blend,{},{})
    end
    PostEffect,lstg.PostEffect=post,post
    RenderFunc=function()
        local current=stage.current_stage
        local paused=current and not current.is_menu and not ext.pause_menu:IsKilled()
        if not paused or C.stage~=current or not C.ready then
            C.ready=false
            render()
            C.stage=paused and current or nil
        else
            BeginScene(); SetViewMode('ui')
            ext.pause_menu:render()
            ext.manual:render(); ext.achievement:render()
            SetViewMode('ui'); ext.RenderFPS()
            EndScene()
        end
    end
end
return C
