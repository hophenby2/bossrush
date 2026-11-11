-- 对同一个真实STD/ANM状态同时走旧逐面与新模型批次，逐顶点核对顺序、深度、颜色和UV。
local f=assert(io.open('tools/check_original_anm.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('local pellet=',1,true))-1)))()
background={init=function() end}
SetImageState=function() end;RenderRect=function() end;Set3D=function() end;ClearZBuffer=function() end
lstg.world={l=-192,r=192,b=-224,t=224}
local images,load={},LoadImage
LoadImage=function(name,texture,...) images[name]={texture=texture};return load(name,texture,...) end
FindResSprite=function(name) return assert(images[name],name) end
lstg.AndroidRenderSprite=function() end
local depth,draws=0,{}
SetZBufferEnable=function(n) depth=n end
RenderTexture=function(texture,blend,...)
    local row={texture=texture,blend=blend,depth=depth,vertices={}}
    for i,v in ipairs({...}) do row.vertices[i]={v[1],v[2],v[3],v[4],v[5],v[6].a,v[6].r,v[6].g,v[6].b} end
    draws[#draws+1]=row
end
local batchCalls=0
local function batch(packets,ix,iy,iz,ox,oy,oz,flip)
    batchCalls=batchCalls+1
    for _,p in ipairs(packets) do if p[1] then
        depth=p[3];local vertices={}
        local x,y,z
        if p[10]==0 then
            x,y,z=p[5]+ix-ox,p[6]+iy-oy,p[7]+iz-oz
            if flip then y=-y end
            x,y=x+p[8],y+p[9]
        end
        for i=0,3 do
            local xx,yy,zz
            if p[10]==1 then xx,yy,zz=p[27+i*3]+ix-ox,p[28+i*3]+iy-oy,p[29+i*3]+iz-oz
            else xx,yy,zz=x,y,z end
            vertices[i+1]={xx+p[11+i*3],yy+p[12+i*3],zz+p[13+i*3],
                (i==0 or i==3) and p[23] or p[25],i<2 and p[24] or p[26],p[4]}
        end
        RenderTexture(p[1].texture,p[2],unpack(vertices))
    end end
end
lstg.AndroidUpdateQuadBatch=function(_,packets) return packets end
local B=dofile('mod/sequence_background.lua')
local works={{6,{'stage1','stage2','stage3','stage4','stage5','stage6','stage7'}},
    {7,{'stage1','stage2','stage3','stage4','stage5','stage6','stage7','stage8'}},
    {8,{'stage1','stage2','stage3','stage4a','stage4b','stage5','stage6','stage7','stage8'}},
    {95,{'world01','world02','world03','world04','world05','world06','world07','world08','world09','world10'}},
    {10,{'stage01','stage02','stage03','stage04','stage05','stage06','stage07'}}}
local samples,vertices=0,0
for _,work in ipairs(works) do for _,key in ipairs(work[2]) do
    local s={};B.class.init(s,work[1],key)
    for time=0,1800 do
        if time==0 or time==300 or time==1800 then
            lstg.AndroidRenderQuadBatch=nil;draws={};B.render(s);local expected=draws
            lstg.AndroidRenderQuadBatch=batch;draws={};B.render(s)
            assert(#draws==#expected,'背景面数改变：'..work[1]..'/'..key)
            for i,row in ipairs(expected) do
                local actual=draws[i]
                assert(row.texture==actual.texture and row.blend==actual.blend and row.depth==actual.depth,'绘制顺序/材质/深度改变')
                for j,v in ipairs(row.vertices) do for k,value in ipairs(v) do
                    assert(math.abs(value-actual.vertices[j][k])<1e-7,
                        ('顶点偏移：%d/%s t%d face%d v%d field%d %.17g/%.17g'):format(work[1],key,time,i,j,k,value,actual.vertices[j][k]))
                end;vertices=vertices+1 end
            end
            samples=samples+1
        end
        B.step(s)
    end
end end
assert(batchCalls>0,'必须实际覆盖模型批次路径')
-- 绘制采集仍使用原接口，不能让原生批次绕过联机的画面/透明度记录。
local saved=GameNet;GameNet={Capture={active=true},active=function() return false end}
local s={};B.class.init(s,6,'stage1');local before=batchCalls
B.render(s);assert(batchCalls==before,'采集画面时必须使用可记录的原路径');GameNet=saved
print(('背景几何对照通过：%d个原作状态，%d个顶点的坐标/UV/颜色/顺序/深度一致，画面采集兼容'):format(samples,vertices))
