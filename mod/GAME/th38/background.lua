-- Unity 摄像机使用整窗的 16:9 投影，LuaSTG 只绘制其中的战斗区。
local scenes=dofile('mod/GAME/th38/background_scenes.lua')
local pi=math.pi
local floor,min,max,sin,cos=math.floor,math.min,math.max,math.sin,math.cos
local canvasHeight=9.6
local canvasWidth=canvasHeight*16/9
local resolutionScale=(16/9)/(4/3)
local fieldWidth=8

local function elapsed(t,event)
    return max(0,min(t-event[1],event[2]))
end

local function motion(t,origin,velocity,events)
    local x,y,z=origin[1]+velocity[1]*t,origin[2]+velocity[2]*t,origin[3]+velocity[3]*t
    for _,change in ipairs(events) do
        local dt=elapsed(t,change)
        local distance=(dt*(dt-1)/2+dt*max(0,t-change[1]-dt))/max(1,change[2])
        x,y,z=x+change[3]*distance,y+change[4]*distance,z+change[5]*distance
    end
    return x,y,z
end

local function eased(t,event)
    return (1-cos(pi*elapsed(t,event)/max(1,event[2])))/2
end

local function cameraAxes(cam,t)
    if #cam[2]==0 then return cam[3],cam[4] end
    local x,y,z=unpack(cam[2])
    for i,event in ipairs(cam[11]) do
        if t<event[1] then break end
        local mix=eased(t,event)
        local a=cam[13][i]
        if a then
            x,y,z=a[1],a[2],a[3]
        end
        x,y,z=x+mix*event[3],y+mix*event[4],z+mix*event[5]
    end
    x,y,z=x*pi/180,y*pi/180,z*pi/180
    local sx,cx,sy,cy,sz,cz=sin(x),cos(x),sin(y),cos(y),sin(z),cos(z)
    -- Quaternion.Euler 的旋转顺序为 Z、X、Y。
    return {sy*cx,-sx,cy*cx},
           {-cy*sz+sy*sx*cz,cx*cz,sy*sz+cy*sx*cz}
end

local function cycles(t,loop)
    local period=loop[3]+1
    local tick,step=period,0
    for _,change in ipairs(loop[4]) do
        if change[1]>t then break end
        if tick<change[1] then
            local count=math.ceil((change[1]-tick)/period)
            tick,step=tick+count*period,step+count
        end
        period=change[2]+1
    end
    return step+max(0,floor((t-tick)/period)+1)
end

local function center(row,t,loops,steps)
    local x,y,z=unpack(row[4])
    for _,reference in ipairs(row[8]) do
        local id,child=unpack(reference)
        local loop=loops[id]
        local d=loop[1]
        local n=floor((steps[id]+loop[2]-1-child)/loop[2])
        x,y,z=x+n*d[1],y+n*d[2],z+n*d[3]
    end
    for _,event in ipairs(row[9]) do
        local mix=eased(t,event)
        x,y,z=x+mix*event[3],y+mix*event[4],z+mix*event[5]
    end
    return x,y,z
end

local function projection(cam,t)
    local f,u=cameraAxes(cam,t)
    local r={u[2]*f[3]-u[3]*f[2],u[3]*f[1]-u[1]*f[3],u[1]*f[2]-u[2]*f[1]}
    local x,y,z=motion(t,cam[1],cam[9],cam[10])
    local yfov=cam[5]*pi/180
    local center=canvasWidth*(.5+cam[8]/resolutionScale)-6.4+4.5
    local shear=math.tan(yfov*.5)*2*center/canvasHeight
    return {
        x=x,y=y,z=z,right=r,up=u,forward=f,
        fov=yfov,shear=shear,near=cam[6],far=cam[7],mask=cam[12],
    }
end

local function dot(a,x,y,z)
    return a[1]*x+a[2]*y+a[3]*z
end

local function point(camera,x,y,z)
    local d=dot(camera.forward,x,y,z)
    return dot(camera.right,x,y,z)+d*camera.shear,dot(camera.up,x,y,z),d
end

local function draw(camera,img,x,y,z,h,v)
    local cx,cy,cz=point(camera,x-camera.x,y-camera.y,z-camera.z)
    local hx,hy,hz=point(camera,unpack(h))
    local vx,vy,vz=point(camera,unpack(v))
    Render4V(img,
        cx-hx+vx,cy-hy+vy,cz-hz+vz, cx+hx+vx,cy+hy+vy,cz+hz+vz,
        cx+hx-vx,cy+hy-vy,cz+hz-vz, cx-hx-vx,cy-hy-vy,cz-hz-vz)
end

local function drawSprites(o,scene,camera,t)
    local rows={}
    local steps={}
    for i,loop in ipairs(scene.loops) do steps[i]=cycles(t,loop) end
    for i,row in ipairs(scene.sprites) do
        local channel=2^row[2]
        if floor(camera.mask/channel)%2==1 then
            local x,y,z=center(row,t,scene.loops,steps)
            local depth=dot(camera.forward,x-camera.x,y-camera.y,z-camera.z)
            local h,v=row[5],row[6]
            local span=math.abs(dot(camera.forward,unpack(h)))+math.abs(dot(camera.forward,unpack(v)))
            if depth+span>=camera.near and depth-span<=camera.far then
                rows[#rows+1]={row,x,y,z,depth,i}
            end
        end
    end
    table.sort(rows,function(a,b)
        if a[1][3]~=b[1][3] then return a[1][3]<b[1][3] end
        if a[5]~=b[5] then return a[5]>b[5] end
        return a[6]<b[6]
    end)
    local drawn=0
    for _,item in ipairs(rows) do
        local row,x,y,z=unpack(item)
        local img=o.mediaPrefix..row[1]
        local c=row[7]
        local alpha=c[4]
        if row[10] then
            local first,last=row[10][1],row[10][2]
            if row[10][3]==1 then alpha=255*min(1,max(0,(last+240-t)/240))
            elseif row[10][3]==2 then alpha=255*max(0,min(1,(t-first)/240,(last+240-t)/240))
            else alpha=255*min(1,max(0,(t-last)/240)) end
        end
        if alpha>0 then
            SetImageState(img,'',floor(alpha),c[1],c[2],c[3])
            draw(camera,img,x,y,z,row[5],row[6])
            drawn=drawn+1
        end
    end
    return drawn
end

-- 五、六面和 Extra A 含专用材质。以原版纹理重建有深度的河道、两岸和雪地。
local underlay={'1boss','2sky','3sky',nil,'5sky','6sky','7star'}
local caveExit={ground='unity_st4_3',below=4,width=9,length=12,speed=.012}
local forestExit={ground='unity_st3_0',below=4,width=8,length=12.8,speed=.05}
local adapted={
    [5]={ground='5styx',shore='5shore',below=5.5,width=4.5,length=12,speed=.01,span=6},
    [6]={ground='6styx',below=3,width=15,length=12,speed=.04,span=13},
    [7]={ground='7ground',below=5,width=11,length=15,speed=.055,span=11},
}
local function drawTerrain(o,camera,data,t,origin)
    local shift=(t*data.speed-camera.z)%data.length
    local x,y,z=origin[1],origin[2]-data.below,camera.z-shift
    local ground=o.mediaPrefix..data.ground
    local shore=data.shore and o.mediaPrefix..data.shore
    local span=data.span
    SetImageState(ground,'',255,255,255,255)
    if shore then SetImageState(shore,'',255,255,255,255) end
    for i=9,-2,-1 do
        local depth=z+(i+.5)*data.length
        local h,v={data.width,0,0},{0,0,data.length/2}
        draw(camera,ground,x,y,depth,h,v)
        if shore then
            h={span,0,0}
            draw(camera,shore,x-data.width-span,y+.08,depth,h,v)
            draw(camera,shore,x+data.width+span,y+.08,depth,h,v)
        else
            draw(camera,ground,x-data.width*2,y,depth,h,v)
            draw(camera,ground,x+data.width*2,y,depth,h,v)
        end
    end
end

local function drawRoad(o,number)
    local scene=scenes[number]
    local t=o.timer*2+(o.aslBackgroundOffset or 0)
    local sky=underlay[number]
    if sky then
        local w=lstg.world
        local img=o.mediaPrefix..sky
        SetImageState(img,'',255,255,255,255)
        RenderRect(img,w.l,w.r,w.b,w.t)
    end
    local afterGate=number==3 and t>=12320
    local terrain=afterGate and forestExit or adapted[number]
    for _,cam in ipairs(scene.cameras) do
        local camera=projection(cam,t)
        SetPerspective(0,0,0,0,0,1,0,1,0,camera.fov,fieldWidth/canvasHeight,camera.near,camera.far)
        if terrain then
            if cam[14]==1 then drawTerrain(o,camera,terrain,t,cam[1]) end
        else
            local drawn=drawSprites(o,scene,camera,t)
            if drawn==0 and number==4 and cam[14]==1 then
                drawTerrain(o,camera,caveExit,t,{camera.x,camera.y,camera.z})
            end
        end
    end
    SetViewMode('world')
end

local B={}
function B.road(number)
    return function(o) drawRoad(o,number) end
end
function B.load(number)
    local resources={}
    for _,row in ipairs(scenes[number].sprites) do resources[#resources+1]={row[1]} end
    if underlay[number] then resources[#resources+1]={underlay[number]} end
    local data=adapted[number]
    if data then
        resources[#resources+1]={data.ground}
        if data.shore then resources[#resources+1]={data.shore} end
    end
    return resources
end
return B
