-- 同一组半径、角度、裁切段数与顶点色，对照旧逐片提交和移动端固定批次。
local H=dofile('THlib/enemy/portrait_hp.lua')
lstg={}
local drawn,color,uploads={}
function Color(...)return {...}end
function SetImageState(_,_,c)color=c end
function Render()end
function Render4V(_,...)drawn[#drawn+1]={...}end
function FindResSprite()return 'hp-fill' end
function GetImageTextureRegion()return 'hp-nodes',4,0,2,2 end
local function equal(a,b)
    assert(#a==#b)
    for i,v in ipairs(a)do if type(v)=='table'then equal(v,b[i])else assert(v==b[i],i..': '..tostring(v)..'/'..tostring(b[i]))end end
end
for _,v in ipairs({{0,0,1,60,0},{-100,80,.491,60,12},{100,-80,.9,13,18},{0,0,0,60,0}})do
    local o={drawhp=true,portrait_hp_fade=v[5],boss={is_combat=true,maxhp=100,hp=v[3]*100,__hpbar_timer=v[4],x=v[1],y=v[2]}}
    lstg.AndroidUpdateQuadBatch=nil;drawn={};H.draw(o)
    local old=drawn
    lstg.AndroidUpdateQuadBatch=function(_,packets)uploads=(uploads or 0)+1;assert(#packets==360);return packets end
    lstg.AndroidRenderQuadBatch=function(batch,x,y,_,_,_,_,_,count,c)
        for i=1,count do
            local p=batch[i];assert(p[1]=='hp-fill' and p[2]=='' and p[3]==0)
            equal({p[23],p[24],p[25],p[26]},{4,0,6,2})
            local row={}
            for j=0,3 do row[#row+1]=p[11+j*3]+x;row[#row+1]=p[12+j*3]+y;row[#row+1]=p[13+j*3] end
            drawn[#drawn+1]=row
        end
        equal(c,Color(255*(1-v[5]/30),255,255,255))
    end
    drawn={};H.draw(o);equal(old,drawn)
end
assert(uploads==1,'固定血圈几何被重复上传')
print('PASS 血圈满血/残血/入场/淡化/空槽的顶点、UV和颜色与逐片路径相同，仅上传一次')
