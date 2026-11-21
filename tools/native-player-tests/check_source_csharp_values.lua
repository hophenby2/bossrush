-- 核对共享单精度转换与官方 FFI 标量转换的位模式，并覆盖 C# 矩形的值复制和属性。
local ffi=require('ffi')
local C=dofile('mod/GAME/ports/source_csharp.lua').new()
local scalar=ffi.typeof('float')
local bits=ffi.new('union { float value; uint32_t bits; }')
local function check(x)
    local expected=tonumber(scalar(x));local actual=C.f(x)
    if expected~=expected then assert(actual~=actual,('NaN 转换不同：输入 %s，结果 %s'):format(tostring(x),tostring(actual)));return end
    bits.value=expected;local before=tonumber(bits.bits)
    bits.value=actual;assert(tonumber(bits.bits)==before,'单精度转换的位模式改变')
end
for _,x in ipairs({0,-0.,1,-1,1+2^-24,1+3*2^-24,-1-2^-24,2^-149,-2^-149,2^-150,
    3.4028234663852886e38,-3.4028234663852886e38,1e40,-1e40,math.huge,-math.huge,0/0}) do check(x) end
local seed,checked=12345,0
while checked<20000 do
    seed=(seed*16807)%2147483647;bits.bits=seed*2
    -- 任意 NaN 载荷可能碰到 LuaJIT 的 NaN 标签保留位；这里只生成有限 Lua 数值，标准 NaN 另测。
    if bit.band(bits.bits,0x7f800000)~=0x7f800000 then
        check(tonumber(bits.value));checked=checked+1
    end
end
-- 强制该函数解释执行，防止测试循环消除临时 cdata 而掩盖真实的分配问题。
jit.off(C.f,true)
collectgarbage('collect');collectgarbage('stop')
local before=collectgarbage('count');local sum=0
for i=1,100000 do sum=sum+C.f(i/7) end
local allocated=collectgarbage('count')-before
collectgarbage('restart');assert(allocated<32,'解释执行仍逐次分配 float cdata：'..allocated)
jit.on(C.f,true)
local a,b=C.Rectangle(2,3,4,5),C.Rectangle(6,7,8,9)
assert(getmetatable(a)==getmetatable(b),'矩形仍逐个创建元表及闭包')
assert(a.Left==2 and a.Top==3 and a.Right==6 and a.Bottom==8)
local copy=C.copy(a);a:Inflate(1,2)
assert(a.X==1 and a.Y==1 and a.Width==6 and a.Height==9)
assert(copy.X==2 and copy.Y==3 and copy.Width==4 and copy.Height==5 and b.Right==14)
local list=C.List();list:Add('a');list:Add('b')
local observed={}
for i,v in C.each(list) do
    observed[#observed+1]=i..v
    if i==0 then list:Add('c') end
end
assert(table.concat(observed,',')=='0a,1b,2c','零基索引或实时 Count 改变')
local nested=0
for _,v in C.each(list) do for _,w in C.each(list) do nested=nested+1 end end
assert(nested==9,'嵌套遍历串用了游标')
local dictionary=C.Dictionary();dictionary:Add('a',1);dictionary:Add('b',2);dictionary:Add('c',3)
dictionary:Remove('b');observed={}
for i,pair in C.each(dictionary) do observed[#observed+1]=i..pair.Key..pair.Value end
assert(table.concat(observed,',')=='0a1,2c3','字典删除空位或 KeyValue 值语义改变')
print(('单精度边界与 20000 组位模式、矩形值语义通过；解释执行 100000 次转换增量 %.2f KB'):format(allocated))
