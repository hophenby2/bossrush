-- 私有诊断开关 graphics：验证宽屏 RT 坐标、NPOT 平铺和 2D/3D 批次切换。
local Q = {}
function Q.run()
    local s = stage.New('android_graphics', true, true)
    function s:init()
        LoadTexture('android:checker', 'android/test-sampler.png')
        SetTextureSamplerState('android:checker', 'nearest+wrap')
        LoadImage('android:clip-probe','android:checker',0,0,1,1)
        CreateRenderTarget('android:coordinates')
        CopyImage('android:object-probe','white')
        SetImageState('android:object-probe','',Color(255,70,130,230))
        local function init(o,x)
            o.img='android:object-probe';o.group=GROUP.GHOST;o.layer=1000;o.bound=false;o.colli=false
            o.x,o.y=x,100;o.hscale,o.vscale=1,1
        end
        -- 对照原生默认绘制与自绘回调里的 DefaultRenderFunc，覆盖矩阵惰性更新。
        New(Class(object,{init=init,render=DefaultRenderFunc},true),140)
        New(Class(object,{init=init,render=function(o) DefaultRenderFunc(o) end},true),170)
    end
    function s:frame()
        if self.timer==60 then
            if not plus.DirectoryExists('snapshot') then plus.CreateDirectory('snapshot') end
            Snapshot('snapshot/android-graphics.png')
        end
        if self.timer==90 then lstg.SystemLog('BOSSRUSH_GRAPHICS_READY: 转场后稳定像素画面') end
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
        -- 中心在视口外而角点仍可见：覆盖四边、旋转、负缩放和RT内透明叠加。
        local clips={{-210,40,0,48,30},{210,80,0,-48,30},{-100,240,35,48,60},
            {80,-240,-35,48,-60},{-222,-80,45,90,90},{222,-120,-45,-90,90},
            {-600,0,0,20,20},{600,0,0,20,20}}
        for i,p in ipairs(clips) do
            SetImageState('android:clip-probe',i%2==0 and 'mul+add' or '',Color(160,230,100,190))
            Render('android:clip-probe',unpack(p))
        end
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
        local portrait=AndroidPortrait and AndroidPortrait.enabled()
        local px,py=portrait and 330 or 760,portrait and screen.height-180 or 270
        SetViewport(px*k+dx,(px+160)*k+dx,py*k+dy,(py+160)*k+dy)
        SetPerspective(0,0,4,0,0,0,0,1,0,math.pi/2,1,.1,20)
        SetImageState('white','',Color(255,180,60,220))
        Render4V('white',-2,2,0,2,2,0,2,-2,0,-2,-2,0)
        SetViewMode('ui')
        RenderTTF('title','Android 2D / RT / NPOT / 3D',480,520,white,'centerpoint')
        SetViewMode('world')
    end
    stage.Set('none','android_graphics')
end
return Q
