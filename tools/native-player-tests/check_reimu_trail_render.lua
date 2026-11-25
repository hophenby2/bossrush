-- 对比宿主灵梦雷弹的两条绘制路径，检查顺序、颜色、混合、缩放及共享图片最终状态。
local noop=function() end
for _,key in ipairs({'LoadTexture','LoadImage','LoadImageGroup','LoadAnimation','LoadPS',
    'SetImageCenter','SetAnimationState','CopyImage'}) do _G[key]=noop end
function Class(base) return {base=base} end
player_class={};player_bullet_straight={};player_bullet_trail={};object={}
lstg={};max=math.max
function FindResSprite(name) return {name=name} end
local state,rows,changes
function SetImageState(img,blend,a,r,g,b)
    state={blend,a,r,g,b};changes=changes+1
end
local function draw(img,x,y,rot,h,v,color)
    local row={img,x,y,rot,h,v}
    for _,value in ipairs(color) do row[#row+1]=value end
    rows[#rows+1]=row
end
function Render(img,x,y,rot,h,v) draw(img,x,y,rot,h,v,state) end
function player_bullet_trail.render(o) draw(o.img,o.x,o.y,o.rot,o.hscale,o.vscale,state) end
changes=0
dofile('THlib/player/reimu/reimu.lua')
local render=reimu_player.bullets.trail.render
local checks=0
for _,factor in ipairs({.01,1,1.98,12}) do for _,scale in ipairs({-.5,1,2}) do for count=0,7 do
    local o={img='reimu_bullet_blue',x=3,y=-5,rot=90,hscale=scale,vscale=.75,smear={}}
    for i=1,count do o.smear[i]={x=i*5,y=-i*7,rot=i*37,alpha=i*5} end
    GameDrops={power=function() return factor end}
    lstg.AndroidRenderSprite=nil;rows={};changes=0;render(o)
    local original,originalState=rows,state
    assert(changes==count+1)
    lstg.AndroidRenderSprite=function(resource,blend,x,y,rot,h,v,a,r,g,b)
        assert(type(resource)=='table','原生绘制接口需要资源句柄，不能传图像名')
        draw(resource.name,x,y,rot,h,v,{blend,a,r,g,b})
    end
    rows={};changes=0;render(o)
    assert(changes==1,'安卓残影仍逐片改动共享图像状态')
    assert(#rows==#original,'改变了残影或弹体数量')
    for i,row in ipairs(rows) do for k,value in ipairs(row) do
        assert(value==original[i][k],'改变了绘制顺序、位置、旋转、缩放或颜色')
    end end
    for k,value in ipairs(state) do assert(value==originalState[k],'改变了共享图像的最终状态') end
    assert(o.hscale==scale and o.vscale==.75)
    checks=checks+1
end end end
print(('灵梦雷弹残影：%d 组有序绘制与图片状态对照通过'):format(checks))
