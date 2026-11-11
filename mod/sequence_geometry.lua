-- STD的局部几何由模型共享；实例只补原顺序的平移，不改变镜头、裁剪或ANM时钟。
-- 包中的旧引擎没有批量接口时仍走原RenderTexture路径。
local G={}
local A=OriginalANM
local cos,sin,abs,sqrt=math.cos,math.sin,math.abs,math.sqrt
local function corners(p,w,h,flip,billboard,right,up,ax,ay,az)
    local cx,sx,cy,sy,cz,sz=cos(ax),sin(ax),cos(ay),sin(ay),cos(az),sin(az)
    for i=0,3 do
        local dx=(i==0 or i==3) and -w/2 or w/2
        local dy=i<2 and -h/2 or h/2
        local dz=0
        if billboard then
            dx,dy=dx*cz-dy*sz,dx*sz+dy*cz
            p[11+i*3],p[12+i*3],p[13+i*3]=right[1]*dx+up[1]*dy,right[2]*dx+up[2]*dy,right[3]*dx+up[3]*dy
        else
            if flip then dy=-dy end
            dy,dz=dy*cx-dz*sx,dy*sx+dz*cx
            dx,dz=dx*cy+dz*sy,-dx*sy+dz*cy
            dx,dy=dx*cz-dy*sz,dx*sz+dy*cz
            p[11+i*3],p[12+i*3],p[13+i*3]=dx,dy,dz
        end
    end
end
local function prepare(s,q,v,right,up,p,textures)
    if not v.visible or not v.sprite then p[1]=false;return end
    local sprite=A.sprite_resource(v)
    p[1],p[2],p[3]=sprite.native_draw_resource,v.blend,v.zwrite_disabled and 0 or 1
    local c=q.script and v.color or v.secondary and v.color2 or v.color
    local alpha=q.script and v.alpha[1] or v.secondary and v.alpha2[1] or v.alpha[1]
    if p.ca~=alpha or p.cr~=c[1] or p.cg~=c[2] or p.cb~=c[3] then
        p[4]=Color(alpha,c[1],c[2],c[3]);p.ca,p.cr,p.cg,p.cb=alpha,c[1],c[2],c[3]
    end
    if q.script then
        local a,b=q.start,q['end'];local w=q.width~=0 and q.width or sprite[4]
        local dx,dy,dz=b[1]-a[1],b[2]-a[2],b[3]-a[3]
        local horizontal=dx*right[1]+dy*right[2]+dz*right[3]
        local vertical=dx*up[1]+dy*up[2]+dz*up[3]
        local length=sqrt(horizontal^2+vertical^2)
        if length<1e-6 then p[1]=false;return end
        local ox,oy,oz=(right[1]*vertical-up[1]*horizontal)*w/length/2,
            (right[2]*vertical-up[2]*horizontal)*w/length/2,(right[3]*vertical-up[3]*horizontal)*w/length/2
        p[10]=1
        for i=0,3 do
            local base=i<2 and a or b;local k=(i==0 or i==3) and -1 or 1
            p[11+i*3],p[12+i*3],p[13+i*3]=ox*k,oy*k,oz*k
            p[27+i*3],p[28+i*3],p[29+i*3]=base[1],base[2],base[3]
        end
        p[23],p[24],p[25],p[26]=sprite[2],sprite[3],sprite[2]+sprite[4],sprite[3]+sprite[5]
        return
    end
    local w=q[5]~=0 and q[5] or sprite[4]*v.scale[1]
    local h=q[6]~=0 and q[6] or sprite[5]*v.scale[2]
    local ax,ay,az=v.rotation[1],v.rotation[2],v.rotation[3]
    local billboard=v.position_mode==2
    local basisChanged=billboard and (p.r1~=right[1] or p.r2~=right[2] or p.r3~=right[3]
        or p.u1~=up[1] or p.u2~=up[2] or p.u3~=up[3])
    if p.w~=w or p.h~=h or p.ax~=ax or p.ay~=ay or p.az~=az or p.billboard~=billboard or basisChanged then
        corners(p,w,h,s.data.game==6,billboard,right,up,ax,ay,az)
        p.w,p.h,p.ax,p.ay,p.az,p.billboard=w,h,ax,ay,az,billboard
        p.r1,p.r2,p.r3,p.u1,p.u2,p.u3=right[1],right[2],right[3],up[1],up[2],up[3]
    end
    p[5],p[6],p[7],p[10]=q[2],q[3],q[4],0
    p[8]=(v.anchor==1 or v.anchor_x==1) and abs(w)/2 or v.anchor_x==2 and -abs(w)/2 or 0
    local ysign=s.data.game==6 and -1 or 1
    p[9]=(v.anchor==1 or v.anchor_y==1) and abs(h)/2*ysign or v.anchor_y==2 and -abs(h)/2*ysign or 0
    if p.texture~=sprite.tex then
        p.tw,p.th=GetTextureSize(sprite.tex);p.texture=sprite.tex
    end
    if not textures[sprite.tex] then
        lstg.SetTextureSamplerState(sprite.tex,'linear+wrap');textures[sprite.tex]=true
    end
    local u,w0=sprite[2]+v.u*p.tw,sprite[3]+v.v*p.th
    p[23],p[24],p[25],p[26]=u,w0,u+sprite[4],w0+sprite[5]
end
function G.draw(s,model,instance,right,up,epoch,textures)
    local packets=model.geometry_packets
    if not packets then packets={};model.geometry_packets=packets end
    if model.geometry_epoch~=epoch then
        for i,q in ipairs(model.source.quads) do
            local p=packets[i];if not p then p={};packets[i]=p end
            prepare(s,q,model.vms[i],right,up,p,textures)
        end
        model.geometry_native=lstg.AndroidUpdateQuadBatch(model.geometry_native,packets)
        model.geometry_epoch=epoch
    end
    lstg.AndroidRenderQuadBatch(model.geometry_native,instance[2],instance[3],instance[4],
        s.offset[1],s.offset[2],s.offset[3],s.data.game==6)
end
return G
