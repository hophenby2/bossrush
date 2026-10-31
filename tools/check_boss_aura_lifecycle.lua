-- 骚灵三姐妹击破回归：宿主已被帧尾回收时，光环不能恢复读取宿主的协程。
-- 可用 LuaJIT 运行；AURA_LIFECYCLE_NATIVE 接入发行版引擎的真实对象池。
local native=rawget(_G,'AURA_LIFECYCLE_NATIVE')
local objects,checks={},0
local function check(ok,msg) assert(ok,msg);checks=checks+1 end
max,int=math.max,math.floor
cos=function(a) return math.cos(a*math.pi/180) end
sin=function(a) return math.sin(a*math.pi/180) end
ran={Float=function(_,a,b) return (a+b)/2 end}
lstg=lstg or {}
DefaultRenderFunc=function() end
dofile('THlib/lib/Lobject.lua')
dofile('THlib/lib/Ltask.lua')
IsValid=function(o)
    if native then return o~=nil and native.IsValid(o) end
    return o~=nil and rawget(o,'_live')==true
end
object.RawDel=function(o)
    if native then o.status='del' else rawset(o,'_live',false) end
end
New=function(cls,...)
    InitAllClass()
    local o
    if native then o=native.New(cls,...)
    else
        local attrs={class=cls,x=0,y=0,timer=0,ani=0}
        o=setmetatable({_live=true},{
            __index=function(t,k)
                assert(rawget(t,'_live'),'访问已回收对象：'..k)
                return attrs[k]
            end,
            __newindex=function(t,k,v)
                assert(rawget(t,'_live'),'写入已回收对象：'..k)
                attrs[k]=v
            end,
        })
        if cls.init then cls.init(o,...) end
    end
    objects[#objects+1]=o
    return o
end
local f=assert(io.open('THlib/ext/ext_boss.lua','rb'));local source=f:read('*a');f:close()
local begin=assert(source:find('local DefaultRenderFunc = DefaultRenderFunc',1,true))
assert(loadstring(source:sub(begin),'@THlib/ext/ext_boss.lua'))()
local Boss=Class(object,{init=function(o,aura)
    o.x,o.y=12,34
    if aura then o._bosssys={aura={_alpha=255}} end
end})
local function tick()
    local n=#objects
    for i=1,n do local o=objects[i]
        if IsValid(o) and o.class.frame then o.class.frame(o) end
    end
    if native then native.AfterFrame() end
end
for _,active in ipairs({false,true}) do
    for phase=0,8 do
        objects={}
        local owner=New(Boss,active)
        local glow=New(SaoqiMain,12,34,owner,{255,64,64},{64,64,255})
        for _=1,phase do tick() end
        object.RawDel(owner)
        if native then native.AfterFrame() end
        local count=#objects
        -- 包括wait(3)、wait(1)、wait(2)、wait(6)的各个恢复点。
        for _=1,40 do tick() end
        check(not IsValid(glow),'宿主回收后清理光环：'..tostring(active)..'/'..phase)
        check(#objects==count,'宿主回收后不再生成新光环：'..tostring(active)..'/'..phase)
        local alive=0
        for _,o in ipairs(objects) do if IsValid(o) then alive=alive+1 end end
        check(alive==0,'光环及已生成的子特效全部回收')
    end
end
print(('Boss光环击破生命周期回归通过：%d 项'):format(checks))
