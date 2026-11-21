-- 对照原 Add_bentlaser_texture_16 的十六行 UV、独立样式、节点和消失绘制。
local base={RenderFunc={},RenderFuncDeath={}}
local sizes,nodes=0,0
GetTextureSize=function(tex) assert(tex=='tex/single');sizes=sizes+1;return 128,32 end
Color=function(a,r,g,b) return {a,r,g,b} end
SetImageState=function() end
Render=function() nodes=nodes+1 end
base.init=function(o,index,x,y,len,width,style,node)
    o.index,o.sample,o.node,o._l=index,style,node,len/4
    o._blend,o._a,o._r,o._g,o._b='',200,10,20,30
    o.alpha,o.timer,o.prex,o.prey=.5,1,x,y
end
local M=dofile('mod/GAME/th43/bent_laser_adapter.lua')(base,function(n) return 'tex/'..n end,function(n) return 'img/'..n end)
M.addTexture16(4,'atlas',256,256);M.addEnvelope(4,0,.5,.8,4)
M.addTexture('custom','single')
for i=1,16 do
    local actual,envelope
    local o={data={Render=function(_,...) actual={...} end,SetEnvelope=function(_,...) envelope={...} end}}
    M.init(o,i,0,0,40,8,4,16)
    assert(o.img4=='img/preimg'..i and table.concat(envelope,',')=='0,0.5,0.8,4')
    base.RenderFunc[o.sample](o)
    assert(actual[1]=='tex/atlas' and actual[4]==0 and actual[5]==(i-1)*16 and actual[6]==256 and actual[7]==16)
    assert(actual[3][1]==100)
    o.timer=15;base.RenderFuncDeath[o.sample](o);assert(actual[3][1]==100 and actual[5]==(i-1)*16)
end
local o={data={Render=function(_,tex,blend,c,x,y,w,h) assert(tex=='tex/single' and x==0 and y==0 and w==128 and h==32) end}}
M.init(o,5,0,0,40,8,'custom',0);base.RenderFunc[o.sample](o);base.RenderFunc[o.sample](o)
assert(sizes==1 and nodes==36 and base.RenderFunc[4]==nil,'样式污染或逐帧查询尺寸')
print('栖霞园曲线激光十六行 UV、颜色索引、包络、节点、消失和资源隔离通过。')
