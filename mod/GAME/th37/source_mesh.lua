-- Windows 原生网格适配：保持顶点、材质次序和 XNA 的变换顺序。
local M={}
local abs,min,max=math.abs,math.min,math.max
function M.available()
    return lstg.CreateSourceModelMesh and lstg.RenderSourceModelMesh
end
local function bounds(vertices)
    local lx,ly,lz,hx,hy,hz=math.huge,math.huge,math.huge,-math.huge,-math.huge,-math.huge
    for i=1,#vertices,5 do
        local x,y,z=vertices[i],vertices[i+1],vertices[i+2]
        lx,ly,lz=min(lx,x),min(ly,y),min(lz,z)
        hx,hy,hz=max(hx,x),max(hy,y),max(hz,z)
    end
    return {(lx+hx)/2,(ly+hy)/2,(lz+hz)/2,(hx-lx)/2,(hy-ly)/2,(hz-lz)/2}
end
function M.prepare(parts)
    local list={}
    local i=1
    while i<=#parts do
        local first=parts[i]
        local vertices={}
        -- 只合并连续的同材质部件，透明表面的先后次序不变。
        repeat
            local source=parts[i][3]
            for j=1,#source do vertices[#vertices+1]=source[j] end
            i=i+1
        until not parts[i] or parts[i].texture~=first.texture or parts[i][2]~=first[2]
        list[#list+1]={mesh=lstg.CreateSourceModelMesh(first.texture,vertices),bounds=bounds(vertices)}
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    return list
end
function M.transform(pos,scale,rotation,t)
    t=t or {}
    local cx,sx=math.cos(rotation[1]),math.sin(rotation[1])
    local cy,sy=math.cos(rotation[2]),math.sin(rotation[2])
    local cz,sz=math.cos(rotation[3]),math.sin(rotation[3])
    -- 原式为 (顶点 + 位移) * 缩放 * Rx * Ry * Rz，位移也经过缩放和旋转。
    t[1],t[2],t[3]=cy*cz*scale[1],cy*sz*scale[1],-sy*scale[1]
    t[4],t[5],t[6]=(sx*sy*cz-cx*sz)*scale[2],(sx*sy*sz+cx*cz)*scale[2],sx*cy*scale[2]
    t[7],t[8],t[9]=(cx*sy*cz+sx*sz)*scale[3],(cx*sy*sz-sx*cz)*scale[3],cx*cy*scale[3]
    t[10]=t[1]*pos[1]+t[4]*pos[2]+t[7]*pos[3]
    t[11]=t[2]*pos[1]+t[5]*pos[2]+t[8]*pos[3]
    t[12]=t[3]*pos[1]+t[6]*pos[2]+t[9]*pos[3]
    return t
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
local function visible(b,t,planes)
    if not planes then return true end
    local x,y,z=t[1]*b[1]+t[4]*b[2]+t[7]*b[3]+t[10],t[2]*b[1]+t[5]*b[2]+t[8]*b[3]+t[11],t[3]*b[1]+t[6]*b[2]+t[9]*b[3]+t[12]
    local hx,hy,hz=abs(t[1])*b[4]+abs(t[4])*b[5]+abs(t[7])*b[6],abs(t[2])*b[4]+abs(t[5])*b[5]+abs(t[8])*b[6],abs(t[3])*b[4]+abs(t[6])*b[5]+abs(t[9])*b[6]
    for _,p in ipairs(planes) do
        local dot=p[1]*x+p[2]*y+p[3]*z+p[4]
        local radius=abs(p[1])*hx+abs(p[2])*hy+abs(p[3])*hz
        -- 包围盒只用于保守排除，边界余量覆盖 GPU 单精度舍入。
        local epsilon=1e-5*(1+abs(p[1]*x)+abs(p[2]*y)+abs(p[3]*z)+abs(p[4])+radius)
        if dot+radius< -epsilon then return false end
    end
    return true
end
function M.draw(list,t,tint,uv,blend,depth,cutout,cull,planes)
    for _,part in ipairs(list) do
        if visible(part.bounds,t,planes) then
            lstg.RenderSourceModelMesh(part.mesh,t,tint,uv,blend,depth,cutout,cull)
        end
    end
end
return M
