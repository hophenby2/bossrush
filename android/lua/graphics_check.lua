-- 私有诊断开关 graphics：验证宽屏 RT 坐标、NPOT 平铺和 2D/3D 批次切换。
local Q = {}
function Q.run()
    local s = stage.New('android_graphics', true, true)
    function s:init()
        LoadTexture('android:checker', 'android/test-sampler.png')
        SetTextureSamplerState('android:checker', 'nearest+wrap')
        CreateRenderTarget('android:coordinates')
    end
    function s:render()
        SetViewMode('ui'); RenderClear(Color(255,0,0,0))
        PushRenderTarget('android:coordinates')
        RenderClear(Color(255,0,0,0)); SetViewMode('world')
        local w = lstg.world
        local rectangles = {
            {w.l,0,0,w.t,Color(255,255,0,0)}, {0,w.r,0,w.t,Color(255,0,255,0)},
            {w.l,0,w.b,0,Color(255,0,0,255)}, {0,w.r,w.b,0,Color(255,255,255,0)},
        }
        for _,r in ipairs(rectangles) do SetImageState('white','',r[5]); RenderRect('white',r[1],r[2],r[3],r[4]) end
        PopRenderTarget('android:coordinates')
        local x1,y1=WorldToScreen(w.l,w.t); local x2,y2=WorldToScreen(w.r,w.b)
        local white=Color(255,255,255,255)
        RenderTexture('android:coordinates','',
            {w.l,w.t,.5,x1,y1,white}, {w.r,w.t,.5,x2,y1,white},
            {w.r,w.b,.5,x2,y2,white}, {w.l,w.b,.5,x1,y2,white})
        SetViewMode('ui')
        RenderTexture('android:checker','',
            {20,450,.5,0,0,white}, {240,450,.5,12,0,white},
            {240,90,.5,12,8,white}, {20,90,.5,0,8,white})
        local k,dx,dy=screen.scale,screen.dx,screen.dy
        SetViewport(760*k+dx,920*k+dx,270*k+dy,430*k+dy)
        SetPerspective(0,0,4,0,0,0,0,1,0,math.pi/2,1,.1,20)
        SetImageState('white','',Color(255,180,60,220))
        Render4V('white',-2,2,0,2,2,0,2,-2,0,-2,-2,0)
        SetViewMode('ui')
        RenderTTF('title','Android 2D / RT / NPOT / 3D',480,520,white,'centerpoint')
    end
    stage.Set('none','android_graphics')
end
return Q
