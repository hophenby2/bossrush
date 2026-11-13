-- Like Dreamer 坐标与视口回归。包含非零世界中心和不同方向的显示区。
local dir='mod/GAME/ports/dreamer/LikeDreamer/'
LikeDreamer={}
lstg={}
local C=dofile(dir..'core.lua')
local V=dofile(dir..'viewport.lua')
local function eq(a,b)
    assert(math.abs(a-b)<1e-8,('%g ~= %g'):format(a,b))
end
for _,bounds in ipairs({
    {-192,192,-224,224,288,672,46,494},
    {-192,192,-224,224,0,540,171,801},
    {-180,260,-210,250,36,396,12,492},
}) do
    local l,r,b,t,sl,sr,sb,st=unpack(bounds)
    lstg.world={l=l,r=r,b=b,t=t,scrl=sl,scrr=sr,scrb=sb,scrt=st}
    local box=V.capture()
    assert(box:mapX(340)>=sl-1e-8 and box:mapX(940)<=sr+1e-8)
    assert(box:mapY(0)<=st+1e-8 and box:mapY(720)>=sb-1e-8)
    eq(box:mapX(640),(sl+sr)/2)
    eq(box:mapY(360),(sb+st)/2)
    eq(box:mapX(541)-box:mapX(340),box:mapY(0)-box:mapY(201))
    for _,x in ipairs({l,(l+r)/2,r}) do
        for _,y in ipairs({b,(b+t)/2,t}) do
            local lx,ly=C.playerWorldPosition(x,y)
            local wx,wy=C.toWorld(lx,ly,lx)
            eq(wx,x)
            eq(wy,y)
        end
    end
    local sx,sy=C.renderScale()
    eq(sx*(sr-sl)/(r-l),sy*(st-sb)/(t-b))
end
lstg.viewmode='world'
local calls={}
SetViewMode=function(mode)
    calls[#calls+1]=mode
    lstg.viewmode=mode
end
SetRenderRect=function(l,r,b,t,sl,sr,sb,st)
    assert(lstg.viewmode=='ui')
    eq(l,sl)
    eq(r,sr)
    eq(b,sb)
    eq(t,st)
    calls[#calls+1]='clip'
end
V.draw(function() calls[#calls+1]='draw' end)
assert(table.concat(calls,',')=='ui,clip,draw,world')
print('Like Dreamer 横屏、竖屏、偏移视口的映射和裁切通过')
