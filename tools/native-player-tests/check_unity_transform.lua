-- 对照原桥接层的向量表达式，核对多层父子、缩放、旋转与运行中修改后的逐位结果。
local ffi=require('ffi')
local C=dofile('mod/GAME/ports/source_csharp.lua').new()
sin=function(a) return math.sin(a*math.pi/180) end
cos=function(a) return math.cos(a*math.pi/180) end
local fast=dofile('mod/GAME/ports/source_unity_transform.lua')(C)
local V=C.Vector4
local function rotate(v,a) return C.Vector3(v.x*cos(a)-v.y*sin(a),v.x*sin(a)+v.y*cos(a),v.z) end
local meta={__index=function(t,k)
    local parent=rawget(t,'_parent')
    if k=='position' then return parent and parent.position+rotate(t._local*parent.lossyScale,parent.eulerAngles.z) or C.copy(t._local)
    elseif k=='lossyScale' then return parent and parent.lossyScale*t._scale or C.copy(t._scale)
    elseif k=='eulerAngles' then return C.Vector3(0,0,t._angle+(parent and parent.eulerAngles.z or 0)) end
end}
local bits=ffi.new('union { float f; uint32_t u; }')
local function same(a,b)
    bits.f=a;local expected=tonumber(bits.u);bits.f=b
    assert(tonumber(bits.u)==expected,('变换舍入改变：%.17g %.17g'):format(a,b))
end
local nodes={}
local seed=28371
local function value() seed=seed*16807%2147483647;return (seed/2147483647-.5)*12 end
for i=1,8 do
    nodes[i]=setmetatable({_parent=nodes[i-1],_local=V(value(),value(),value(),value()),
        _scale=V(value(),value(),value(),value()),_angle=value()*360},meta)
end
for step=1,2500 do
    local t=nodes[step%8+1]
    t._local=V(value(),value(),value(),value());t._scale=V(value(),value(),value(),value());t._angle=value()*360
    for _,node in ipairs(nodes) do
        local a,b=node.position,fast.position(node)
        local s,u=node.lossyScale,fast.scale(node)
        for _,axis in ipairs({'x','y','z','w'}) do same(a[axis],b[axis]);same(s[axis],u[axis]) end
        same(node.eulerAngles.z,fast.angle(node))
    end
end
-- 每次读取仍返回独立值，修改结果不能影响后续读取或局部坐标。
local a=fast.position(nodes[8]);local x=a.x;a.x=111
assert(fast.position(nodes[8]).x==x)
nodes[8]._parent=nodes[2]
same(nodes[8].position.x,fast.position(nodes[8]).x)
print('Unity 变换 20000 组多层/动态修改逐位一致，返回值保持独立。')
