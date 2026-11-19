-- C# 自机逻辑的数据兼容层：零基数组、值类型、集合和数值转换。
local M={}
local ffi=require('ffi')
local float=ffi.typeof('float')
local function f(x) return tonumber(float(x)) end
local vector={}
local axes={X=1,Y=2,Z=3,W=4,x=1,y=2,z=3,w=4}
local vectorMeta={
    __index=function(o,k) if axes[k] then return o.values[axes[k]] end;return vector[k] end,
    __newindex=function(o,k,v) if axes[k] then o.values[axes[k]]=f(v) else rawset(o,k,v) end end,
}
local function vec(x,y,z,w) return setmetatable({values={f(x or 0),f(y or x or 0),f(z or 0),f(w or 0)}},vectorMeta) end
function vector:Length() return f(math.sqrt(self.X*self.X+self.Y*self.Y+self.Z*self.Z)) end
function vector:LengthSquared() return f(self.X*self.X+self.Y*self.Y+self.Z*self.Z) end
function vector:Normalize() local len=self:Length();self.X,self.Y,self.Z=f(self.X/len),f(self.Y/len),f(self.Z/len) end
function vector:MoveForward(a,b,c)
    local x,y,d
    if c then x,y,d=a,b,c elseif type(a)=='table' then x,y,d=a.X,a.Y,b else x,y,d=a,a,b end
    self.X,self.Y=self.X+(x-self.X)/d,self.Y+(y-self.Y)/d
end
vectorMeta.__add=function(a,b) return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z,a.W+b.W) end
vectorMeta.__sub=function(a,b) return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z,a.W-b.W) end
vectorMeta.__unm=function(a) return vec(-a.X,-a.Y,-a.Z,-a.W) end
vectorMeta.__mul=function(a,b)
    if type(a)=='number' then a,b=b,a end
    if type(b)=='number' then return vec(a.X*b,a.Y*b,a.Z*b,a.W*b) end
    return vec(a.X*b.X,a.Y*b.Y,a.Z*b.Z,a.W*b.W)
end
vectorMeta.__div=function(a,b) return vec(a.X/b,a.Y/b,a.Z/b,a.W/b) end
vectorMeta.__eq=function(a,b) return a.X==b.X and a.Y==b.Y and a.Z==b.Z end
local collection={}
function collection:Add(value) self.items[self.count]=value;self.count=self.count+1 end
function collection:AddRange(values) for i=0,values.count-1 do self:Add(values[i]) end end
function collection:Clear() self.items={};self.count=0 end
function collection:RemoveAt(i)
    for n=i,self.count-2 do self.items[n]=self.items[n+1] end
    self.items[self.count-1]=nil;self.count=self.count-1
end
function collection:Remove(value)
    for i=0,self.count-1 do if self.items[i]==value then self:RemoveAt(i);return true end end
    return false
end
function collection:Contains(value) for i=0,self.count-1 do if self.items[i]==value then return true end end;return false end
function collection:Find(predicate) for i=0,self.count-1 do if predicate(self.items[i]) then return self.items[i] end end end
function collection:Sort(compare)
    local sorted={};for i=0,self.count-1 do sorted[#sorted+1]=self.items[i] end
    table.sort(sorted,function(a,b) return compare(a,b)<0 end)
    for i,v in ipairs(sorted) do self.items[i-1]=v end
end
local listMeta={
    __index=function(o,k) if k=='Count' or k=='Length' then return o.count end;if type(k)=='number' then return o.items[k] end;return collection[k] end,
    __newindex=function(o,k,v) if type(k)=='number' then o.items[k]=v else rawset(o,k,v) end end,
}
local function list(values)
    local o=setmetatable({items={},count=0},listMeta)
    if values then local i=0;while values[i]~=nil do o:Add(values[i]);i=i+1 end end
    return o
end
local dictionary={}
function dictionary:ContainsKey(k) return self.items[k]~=nil end
function dictionary:TryGetValue(k,ref) ref.set(self.items[k]);return self.items[k]~=nil end
function dictionary:Add(k,v) if self.items[k]==nil then self.keys[#self.keys+1]=k end;self.items[k]=v end
function dictionary:Remove(k) self.items[k]=nil end
function dictionary:Clear() self.items={};self.keys={} end
local dictMeta={
    __index=function(o,k)
        if k=='Count' then local n=0;for _ in pairs(o.items) do n=n+1 end;return n end
        return dictionary[k] or o.items[k]
    end,
    __newindex=function(o,k,v) if dictionary[k] then rawset(o,k,v) else dictionary.Add(o,k,v) end end,
}
function M.new(environment)
    local C={env=environment or {},f=f,Vector2=vec,Vector3=vec,Vector4=vec,List=list}
    C.env.float={MaxValue=3.4028234663852886e38,MinValue=-3.4028234663852886e38,PositiveInfinity=math.huge}
    for k,v in pairs({select=select,error=error,tostring=tostring,tonumber=tonumber,pairs=pairs,ipairs=ipairs,unpack=unpack,rawset=rawset}) do C.env[k]=v end
    C.env.Vector2=setmetatable({Zero=vec(),One=vec(1,1),UnitX=vec(1,0),UnitY=vec(0,1),__static=true}, {__call=function(_,...) return vec(...) end})
    C.env.Vector2.Distance=function(a,b) return (a-b):Length() end
    C.env.Vector2.DistanceSquared=function(a,b) return (a-b):LengthSquared() end
    C.env.Vector2.Lerp=function(a,b,t) return a+(b-a)*t end
    C.env.Vector2.Normalize=function(a) local b=C.copy(a);b:Normalize();return b end
    C.env.Vector2.Dot=function(a,b) return f(a.X*b.X+a.Y*b.Y) end
    C.env.Vector3=C.env.Vector2
    C.Vector3=function(a,b,c) if type(a)=='table' then return vec(a.X,a.Y,b or 0) end;return vec(a,b,c) end
    C.env.CalHelper={__static=true,Lerp=function(a,b,t) return a+(b-a)*t end}
    C.env.Math={__static=true,PI=math.pi,Abs=math.abs,Min=math.min,Max=math.max,
        Sqrt=math.sqrt,Sin=math.sin,Cos=math.cos,Tan=math.tan,Atan=math.atan,Atan2=math.atan2,
        Pow=math.pow,Floor=math.floor,Ceiling=math.ceil,Round=function(x) return math.floor(x+.5) end,Sign=function(x) return x>0 and 1 or x<0 and -1 or 0 end}
    C.env.MathHelper={__static=true,Pi=f(math.pi),TwoPi=f(math.pi*2),PiOver2=f(math.pi/2),
        ToRadians=function(x) return f(x*0.0174532924) end,ToDegrees=function(x) return f(x*57.29578) end,
        Clamp=function(x,a,b) return f(math.max(a,math.min(b,x))) end,
        Lerp=function(a,b,t) return f(a+f(b-a)*t) end}
    C.env.Array={__static=true,Clear=function(array,start,count) for i=start,start+count-1 do array[i]=0 end end}
    function C.copy(v)
        if type(v)~='table' then return v end
        if getmetatable(v)==vectorMeta then return vec(v.X,v.Y,v.Z,v.W) end
        local n={};for k,value in pairs(v) do n[k]=value end;return setmetatable(n,getmetatable(v))
    end
    local rectangle={}
    function rectangle:Inflate(x,y) self.X,self.Y=self.X-x,self.Y-y;self.Width,self.Height=self.Width+2*x,self.Height+2*y end
    function rectangle:Contains(p) return p.X>=self.X and p.X<self.X+self.Width and p.Y>=self.Y and p.Y<self.Y+self.Height end
    function C.Rectangle(x,y,w,h) return setmetatable({X=x or 0,Y=y or 0,Width=w or 0,Height=h or 0},{__index=function(o,k)
        if k=='Top' then return o.Y elseif k=='Bottom' then return o.Y+o.Height
        elseif k=='Left' then return o.X elseif k=='Right' then return o.X+o.Width end
        return rectangle[k]
    end}) end
    local colorMeta={}
    function C.Colors(r,g,b,a)
        if type(r)=='table' then return setmetatable({r=r.r,g=r.g,b=r.b,a=g or r.a},colorMeta) end
        return setmetatable({r=r or 0,g=g or 0,b=b or 0,a=a or 0},colorMeta)
    end
    colorMeta.__add=function(a,b) return C.Colors(a.r+b.r,a.g+b.g,a.b+b.b,a.a+b.a) end
    colorMeta.__sub=function(a,b) return C.Colors(a.r-b.r,a.g-b.g,a.b-b.b,a.a-b.a) end
    colorMeta.__mul=function(a,b) if type(a)=='number' then a,b=b,a end;return C.Colors(a.r*b,a.g*b,a.b*b,a.a*b) end
    function C.Sprite(texture,rect)
        return {shape=texture,rect=C.copy(rect or C.Rectangle()),position=vec(),origin=vec(),scale=vec(1,1),color=C.Colors(1,1,1,1),rotation=0,Draw=function() end}
    end
    C.Color=function(r,g,b,a)
        if type(r)=='table' then return C.Colors(r.r,r.g,r.b,g) end
        if math.max(r or 0,g or 0,b or 0,a or 0)>1 then return C.Colors((r or 0)/255,(g or 0)/255,(b or 0)/255,(a or 255)/255) end
        return C.Colors(r,g,b,a or (r~=nil and 1 or 0))
    end
    function C.trunc(n) return n<0 and math.ceil(n) or math.floor(n) end
    function C.byte(n) return C.trunc(n)%256 end
    function C.idiv(x,y) return C.trunc(x/y) end
    function C.rem(x,y) return x-C.trunc(x/y)*y end
    function C.choose(condition,a,b) if condition then return a() else return b() end end
    function C.coalesce(value,fallback) if value~=nil then return value end;return fallback() end
    function C.optional(value,key) if value~=nil then return value[key] end end
    function C.optionalCall(value,key,...) if value~=nil then return C.invoke(value,key,...) end end
    function C.ref(get,set) return {get=get,set=set} end
    function C.bitop(op,a,b)
        if type(a)=='boolean' and type(b)=='boolean' then if op=='|' then return a or b elseif op=='&' then return a and b else return a~=b end end
        return ({['|']=bit.bor,['&']=bit.band,['^']=bit.bxor})[op](a,b)
    end
    function C.array(n,default)
        local a=list();a.count=n
        for i=0,n-1 do a.items[i]=default() end
        return a
    end
    function C.arrayValues(values) return list(values) end
    function C.pack(...) local a=list();a.count=select('#',...);for i=0,a.count-1 do a.items[i]=select(i+1,...) end;return a end
    function C.params(...)
        if select('#',...)==1 and getmetatable((...))==listMeta then return (...) end
        return C.pack(...)
    end
    function C.Dictionary() return setmetatable({items={},keys={}},dictMeta) end
    function C.each(o)
        local index=-1
        if getmetatable(o)==dictMeta then return function()
            repeat index=index+1 until index>=#o.keys or o.items[o.keys[index+1]]~=nil
            local key=o.keys[index+1];if key~=nil then return index,{Key=key,Value=o.items[key]} end
        end end
        return function() index=index+1;if index<o.count then return index,o[index] end end
    end
    function C.invoke(o,key,...)
        if key=='ToString' then return tostring(o) end
        local fn=assert(o and o[key],'原作 C# 接口缺失：'..tostring(key))
        if o.__static then return fn(...) end
        return fn(o,...)
    end
    function C.is(o,kind) return o~=nil and o.__type==kind end
    function C.as(o,kind) if C.is(o,kind) then return o end end
    function C.new(kind,...)
        if C[kind] then return C[kind](...) end
        local class=assert(C.env[kind],'原作 C# 类型缺失：'..kind)
        if class.__new then return class.__new(...) end
        local o=setmetatable({__type=kind},class)
        local function defaults(c)
            local base=c.__base and C.env[c.__base]
            if base and base.defaults then defaults(base) end
            c.defaults(o)
        end
        defaults(class)
        if class.ctor then class.ctor(o,...) end;return o
    end
    function C.initialize(o,values) for k,v in pairs(values) do o[k]=v end;return o end
    return C
end
return M
