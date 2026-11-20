-- 原生网格共用提交与保守裁剪；批次保持调用顺序，摄像机变化前必须提交。
local M={}
local abs,min,max=math.abs,math.min,math.max
function M.available() return lstg.CreateSourceModelMesh and lstg.RenderSourceModelMeshes end
function M.blend(mode)
    if mode=='' or mode=='mul+alpha' then return 3 end
    if mode=='mul+add' then return 4 end
end
function M.newBatch() return {pool={},list={},count=0} end
function M.queue(batch,mesh,t,tint,uv,blend,depth,cutout,cull,fog)
    local i=batch.count+1;batch.count=i
    local command=batch.pool[i]
    if not command then command={nil,{},nil,{}};batch.pool[i]=command end
    command[1],command[3]=mesh,tint
    for j=1,12 do command[2][j]=t[j] end
    for j=1,4 do command[4][j]=uv[j] end
    command[5],command[6],command[7],command[8]=blend,depth,cutout,cull
    if fog then
        command.fog=command.fog or {};command[9]=command.fog
        for j=1,8 do command.fog[j]=fog[j] end
    else command[9]=nil end
    batch.list[i]=command
end
function M.flush(batch)
    if not batch or batch.count==0 then return end
    for i=#batch.list,batch.count+1,-1 do batch.list[i]=nil end
    lstg.RenderSourceModelMeshes(batch.list)
    batch.count=0
end
function M.bounds(vertices)
    local lx,ly,lz,hx,hy,hz=math.huge,math.huge,math.huge,-math.huge,-math.huge,-math.huge
    for i=1,#vertices,5 do
        local x,y,z=vertices[i],vertices[i+1],vertices[i+2]
        lx,ly,lz=min(lx,x),min(ly,y),min(lz,z);hx,hy,hz=max(hx,x),max(hy,y),max(hz,z)
    end
    return {(lx+hx)/2,(ly+hy)/2,(lz+hz)/2,(hx-lx)/2,(hy-ly)/2,(hz-lz)/2}
end
function M.frustum(eye,at,up,travel,fov,aspect,near,far)
    local fx,fy,fz=at[1]-eye[1],at[2]-eye[2],at[3]-eye[3]
    local length=math.sqrt(fx*fx+fy*fy+fz*fz);fx,fy,fz=fx/length,fy/length,fz/length
    local rx,ry,rz=up[2]*fz-up[3]*fy,up[3]*fx-up[1]*fz,up[1]*fy-up[2]*fx
    length=math.sqrt(rx*rx+ry*ry+rz*rz);rx,ry,rz=rx/length,ry/length,rz/length
    local ux,uy,uz=fy*rz-fz*ry,fz*rx-fx*rz,fx*ry-fy*rx
    local tv=math.tan(fov/2);local th=tv*abs(aspect)
    local ex,ey,ez=eye[1]+travel[1],eye[2]+travel[2],eye[3]+travel[3]
    local function plane(x,y,z,d) return {x,y,z,(d or 0)-x*ex-y*ey-z*ez} end
    return {plane(fx,fy,fz,-near),plane(-fx,-fy,-fz,far),
        plane(fx*th+rx,fy*th+ry,fz*th+rz),plane(fx*th-rx,fy*th-ry,fz*th-rz),
        plane(fx*tv+ux,fy*tv+uy,fz*tv+uz),plane(fx*tv-ux,fy*tv-uy,fz*tv-uz)}
end
function M.visible(b,t,planes)
    if not planes then return true end
    local x,y,z=t[1]*b[1]+t[4]*b[2]+t[7]*b[3]+t[10],t[2]*b[1]+t[5]*b[2]+t[8]*b[3]+t[11],t[3]*b[1]+t[6]*b[2]+t[9]*b[3]+t[12]
    local hx,hy,hz=abs(t[1])*b[4]+abs(t[4])*b[5]+abs(t[7])*b[6],abs(t[2])*b[4]+abs(t[5])*b[5]+abs(t[8])*b[6],abs(t[3])*b[4]+abs(t[6])*b[5]+abs(t[9])*b[6]
    for _,p in ipairs(planes) do
        local dot=p[1]*x+p[2]*y+p[3]*z+p[4]
        local radius=abs(p[1])*hx+abs(p[2])*hy+abs(p[3])*hz
        local epsilon=1e-5*(1+abs(p[1]*x)+abs(p[2]*y)+abs(p[3]*z)+abs(p[4])+radius)
        if dot+radius< -epsilon then return false end
    end
    return true
end
return M
