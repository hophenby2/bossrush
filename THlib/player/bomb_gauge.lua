-- 复用Like Dreamer的DreamGauge：恢复槽、外框与不封顶的库存点。
-- 直接使用世界顶点，避免横竖屏或原作绘制倍率再次缩放。
local G={RADIUS=30,DOT_RADIUS=37}
local texture='bossrush_bomb_gauge'
function G.prepare()
    if CheckRes('tex',texture) then return end
    local previous=GetResourceStatus();SetResourceStatus('global')
    LoadTexture(texture,'Resources/ports/dreamer/res/likedreamer/player/DreamGauge.png')
    SetResourceStatus(previous)
end
local function wedge(x,y,fraction)
    local color=Color(215,110,255,155)
    local scale=G.RADIUS/80
    for i=0,math.ceil(fraction*8)-1 do
        local a,b=i/8*2*math.pi-math.pi/2,math.min((i+1)/8,fraction)*2*math.pi-math.pi/2
        local ca,sa,cb,sb=math.cos(a),math.sin(a),math.cos(b),math.sin(b)
        local ra,rb=80/math.max(math.abs(ca),math.abs(sa)),80/math.max(math.abs(cb),math.abs(sb))
        RenderTexture(texture,'',{x,y,.5,240,80,color},
            {x+ca*ra*scale,y-sa*ra*scale,.5,240+ca*ra,80+sa*ra,color},
            {x+cb*rb*scale,y-sb*rb*scale,.5,240+cb*rb,80+sb*rb,color},{x,y,.5,240,80,color})
    end
end
local function dots(p,count,alpha)
    if count==0 then return end
    local state=p._bombGaugeDots
    if not state or state.count~=count then
        state=state or {};p._bombGaugeDots=state
        state.count,state.points=count,{}
        local size=math.min(2,math.pi*G.DOT_RADIUS/count*.38)
        local packets={}
        local native=lstg.AndroidUpdateQuadBatch
        local resource=native and assert(FindResSprite('white'))
        local _,u,v,w,h=GetImageTextureRegion('white')
        local color=Color(255,80,255,120)
        for i=1,count do
            local a=(i-1)*2*math.pi/count
            local x,y=math.sin(a)*G.DOT_RADIUS,math.cos(a)*G.DOT_RADIUS
            state.points[i]={x,y,size}
            if native then
                packets[i]={resource,'',0,color,0,0,0,0,0,0,
                    x-size,y+size,.5,x+size,y+size,.5,x+size,y-size,.5,x-size,y-size,.5,u,v,u+w,v+h}
            end
        end
        if native then state.batch=lstg.AndroidUpdateQuadBatch(state.batch,packets) end
    end
    local color=Color(alpha,80,255,120)
    if state.batch and lstg.AndroidRenderQuadBatch then
        lstg.AndroidRenderQuadBatch(state.batch,p.x,p.y,0,0,0,0,false,count,color)
    else
        SetImageState('white','',color)
        for _,point in ipairs(state.points) do
            local x,y,r=p.x+point[1],p.y+point[2],point[3]
            Render4V('white',x-r,y+r,.5,x+r,y+r,.5,x+r,y-r,.5,x-r,y-r,.5)
        end
    end
end
function G.render(p,stock,fraction)
    if p.hide or p.realrealreal_lock or p.dialog then return end
    local r=G.RADIUS;local color=Color(145,220,240,225)
    RenderTexture(texture,'',{p.x-r,p.y+r,.5,0,0,color},{p.x+r,p.y+r,.5,160,0,color},
        {p.x+r,p.y-r,.5,160,160,color},{p.x-r,p.y-r,.5,0,160,color})
    wedge(p.x,p.y,math.max(0,math.min(1,fraction)))
    local alpha=110+145*(.5+.5*math.sin((p.timer or 0)*math.pi/18))
    dots(p,math.max(0,math.floor(stock)),alpha)
end
return G
