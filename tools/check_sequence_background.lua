-- 载入全部原始STD/ANM并逐帧推进，核对实际纹理、三维顶点和镜头有限性。
local f=assert(io.open('tools/check_original_anm.lua','rb'));local setup=f:read('*a');f:close()
setup=setup:sub(1,assert(setup:find('local pellet=',1,true))-1)
assert(loadstring(setup))()
background={init=function() end}
SetImageState=function() end;RenderRect=function() end
Set3D=function() end;ClearZBuffer=function() end;SetZBufferEnable=function() end
lstg.world={l=-192,r=192,b=-224,t=224}
local quads=0
RenderTexture=function(tex,blend,...)
    quads=quads+1
    for _,v in ipairs({...}) do for i=1,5 do assert(v[i]==v[i] and math.abs(v[i])<1e12,'三维顶点必须有限：'..tex) end end
end
local B=dofile('mod/sequence_background.lua')
local works={
    [6]={'stage1','stage2','stage3','stage4','stage5','stage6','stage7'},
    [7]={'stage1','stage2','stage3','stage4','stage5','stage6','stage7','stage8'},
    [8]={'stage1','stage2','stage3','stage4a','stage4b','stage5','stage6','stage7','stage8'},
    [95]={'world01','world02','world03','world04','world05','world06','world07','world08','world09','world10'},
    [10]={'stage01','stage02','stage03','stage04','stage05','stage06','stage07'},
}
local count=0
for game,keys in pairs(works) do for _,key in ipairs(keys) do
    local o={};B.class.init(o,game,key)
    for frame=0,1200 do
        if game==8 and key=='stage1' and frame==300 then
            assert(math.abs(o.position[3]+400)<1e-6 and o.position[2]>130 and o.position[2]<140,
                '先设duration后写target：永夜抄1面镜头Z保持-400，Y沿原700帧ease-out曲线推进')
        end
        for _,v in ipairs({o.position,o.direction,o.up,o.fov,o.fog}) do
            for _,n in ipairs(v) do assert(n==n and math.abs(n)<1e12,'镜头插值必须有限：'..game..'/'..key) end
        end
        if frame%300==0 then B.render(o) end
        B.step(o)
    end
    count=count+1
end end
print('原作STD模型、ANM资源和镜头推进检查通过：'..count..' 个背景，绘制 '..quads..' 个三维面')
