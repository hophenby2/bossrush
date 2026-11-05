-- 四道中270号创建：STD相机位置、0x40000逐拍相机位移和生成时的D3DX投影。
-- 原stage04.std SHA256 c463e52db2fd289608c446c216f0b0477d924ecf93a27aab3d1305ebfd870d7d
-- 原PE：40EA22/40EA3D取491D7C/80（相机位置）；40DE9D..40DEBC取491E6C..74（相机位移）。
-- 复原源码将两组extern误用了同一名字；这里以原二进制地址区分。
local H={}
local curve={
    {0,"p",{-0.0,0.0,-550.0}}, -- STD 0x614
    {0,"p_to",{0.0,100.0,-450.0},200,0}, -- STD 0x628
    {0,"d",{20.0,240.0,330.0}}, -- STD 0x644
    {0,"d_to",{0.0,240.0,330.0},160,4}, -- STD 0x658
    {200,"d_to",{0.0,-300.0,330.0},440,4}, -- STD 0x690
    {200,"p_to",{0.0,1500.0,-450.0},2800,0}, -- STD 0x6ac
    {3000,"p",{0.0,476.0,-450.0}}, -- STD 0x6c8
    {3000,"d_to",{120.0,-300.0,330.0},400,4}, -- STD 0x6dc
    {3000,"p_to",{-200.0,876.0,-330.0},800,4}, -- STD 0x6f8
    {3640,"p_to",{-200.0,1226.0,-330.0},300,1}, -- STD 0x730
    {3940,"p",{-200.0,202.0,-330.0}}, -- STD 0x74c
    {3940,"p_to",{-200.0,1226.0,-330.0},512,0}, -- STD 0x760
    {4452,"p",{-200.0,202.0,-330.0}}, -- STD 0x77c
    {4452,"p_to",{-200.0,482.0,-330.0},152,0}, -- STD 0x790
    {4592,"p_to",{-200.0,1506.0,-330.0},512,0}, -- STD 0x7ac
    {5104,"p",{-200.0,482.0,-330.0}}, -- STD 0x7c8
    {5104,"p_to",{0.0,1506.0,-450.0},512,0}, -- STD 0x7dc
    {5104,"d_to",{0.0,-300.0,330.0},512,4}, -- STD 0x7f8
    {5616,"p",{0.0,482.0,-450.0}}, -- STD 0x830
    {5616,"p_to",{0.0,1506.0,-450.0},512,0}, -- STD 0x844
    {6128,"p",{0.0,482.0,-450.0}}, -- STD 0x860
    {6128,"p_to",{0.0,1506.0,-450.0},512,0}, -- STD 0x874
    {6640,"p",{0.0,482.0,-450.0}}, -- STD 0x890
    {6640,"p_to",{0.0,1506.0,-450.0},512,0}, -- STD 0x8a4
    {7152,"p",{0.0,482.0,-450.0}}, -- STD 0x8c0
    {7152,"p_to",{0.0,1506.0,-450.0},512,0}, -- STD 0x8d4
    {7152,"d_to",{0.0,500.0,330.0},1024,0}, -- STD 0x8f0
    {7664,"p",{0.0,482.0,-450.0}}, -- STD 0x928
    {7664,"p_to",{0.0,994.0,-450.0},256,0}, -- STD 0x93c
    {7920,"p",{0.0,482.0,-450.0}}, -- STD 0x958
    {7920,"p_to",{0.0,1506.0,-450.0},512,4}, -- STD 0x96c
    {8432,"p_to",{0.0,994.0,-450.0},256,1}, -- STD 0x988
    {8688,"p",{0.0,2018.0,-450.0}}, -- STD 0x9c8
    {8688,"p_to",{0.0,994.0,-450.0},256,0}, -- STD 0x9dc
}
local function vector(v) return {v[1],v[2],v[3]} end
local function camera(o)
    local root=o.t10_root or o
    -- root在ECL结束时才自增；出生嵌套更新发生在自增前，其余子机在自增后。
    local in_root=root.t10_in_update or root.t10_ecl_birth
    local age=math.max(0,(root.__t10frames or 0)-(in_root and 0 or 1))
    local c=root.t10_stage04_camera
    if not c then
        c={age=-1,clock=0,index=1,p={0,0,-600},d={0,300,600},delta={0,0,0},interps={}}
        root.t10_stage04_camera=c
    end
    while c.age<age do
        c.delta={0,0,0}
        if c.clock==8944 then c.clock=8688;c.index=#curve-1 end
        while curve[c.index] and curve[c.index][1]<=c.clock do
            local e=curve[c.index]
            if e[2]=='p' or e[2]=='d' then
                if e[2]=='p' then
                    c.delta={class.t10_motion_f32(e[3][1]-c.p[1]),class.t10_motion_f32(e[3][2]-c.p[2]),class.t10_motion_f32(e[3][3]-c.p[3])}
                end
                c[e[2]]=vector(e[3])
            else
                local key=e[2]:sub(1,1)
                c.interps[key]={from=vector(c[key]),to=e[3],n=0,duration=e[4],mode=e[5]}
            end
            c.index=c.index+1
        end
        for key,s in pairs(c.interps) do
            s.n=math.min(s.duration,s.n+1)
            local u=class.t10_motion_ease(s.mode,s.n/s.duration)
            for i=1,3 do c[key][i]=class.t10_motion_f32(s.from[i]+(s.to[i]-s.from[i])*u) end
        end
        c.age=c.age+1;c.clock=c.clock+1
    end
    return c
end
function H.attach(o)
    local c=camera(o)
    o.t10_stage04_global={z=-2,bz=0}
    o.ecs.off.x=class.t10_motion_f32(o.ecs.off.x+c.p[1])
    o.ecs.off.y=class.t10_motion_f32(o.ecs.off.y+c.p[2])
end
function H.step(o)
    if not o.t10_stage04_global then return end
    local c=camera(o)
    o.ecs.base.x=class.t10_motion_f32(o.ecs.base.x+c.delta[1])
    o.ecs.base.y=class.t10_motion_f32(o.ecs.base.y+c.delta[2])
    local g=o.t10_stage04_global
    g.bz=class.t10_motion_f32(g.bz+c.delta[3])
end
function H.position(o)
    local c=camera(o)
    local g=o.t10_stage04_global
    local x,y,z=o.ecs.wx-c.p[1],o.ecs.wy-c.p[2],g.z+g.bz-c.p[3]
    local dx,dy,dz=c.d[1],c.d[2],c.d[3]
    local norm=math.sqrt(dx*dx+dy*dy+dz*dz)
    dx,dy,dz=dx/norm,dy/norm,dz/norm
    -- D3DXMatrixLookAtLH：right=normalize(up×forward)，up=forward×right。
    local rn=math.sqrt(dz*dz+dx*dx)
    local rx,rz=dz/rn,-dx/rn
    local ux,uy,uz=dy*rz,dz*rx-dx*rz,-dy*rx
    local depth=x*dx+y*dy+z*dz
    local focal=224/math.tan(0.6283185482025146/2)
    return class.t10_motion_f32(focal*(x*rx+z*rz)/depth),
        class.t10_motion_f32(224-focal*(x*ux+y*uy+z*uz)/depth)
end
function H.sync(o)
    if not o.t10_stage04_global then return end
    local x,y=H.position(o)
    o.x,o.y=x,224-y
end
return H
