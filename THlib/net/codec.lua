-- 联机绘制报文使用有界二进制值编码；只允许数据，不反序列化 Lua 代码。
local ffi=require('ffi')
local C={MAX=2*1024*1024,DEPTH=12}
local f=ffi.new('float[1]');local u=ffi.cast('uint8_t*',f)
local little=ffi.abi('le')
local function word(n) return string.char(math.floor(n/256),n%256) end
function C.encode(value)
    local out,strings,serial,size={},{},0,0
    local tables,active,tableCount={},{},0
    local function put(s) size=size+#s;assert(size<=C.MAX,'绘制报文过大');out[#out+1]=s end
    local encode
    encode=function(v,depth)
        assert(depth<=C.DEPTH,'绘制数据嵌套过深')
        local t=type(v)
        if v==nil then put('\0')
        elseif t=='boolean' then put(v and '\2' or '\1')
        elseif t=='number' then
            assert(v==v and math.abs(v)<=1e12,'绘制数值无效')
            if v%1==0 and v>=0 and v<65536 then put('\3'..word(v))
            else f[0]=v;local bytes=ffi.string(u,4);put('\4'..(little and bytes or bytes:reverse())) end
        elseif t=='string' then
            assert(#v<=65535,'绘制字符串过长')
            local id=strings[v]
            if id then put('\5'..word(id))
            else serial=serial+1;assert(serial<65536,'绘制字符串过多');strings[v]=serial;put('\6'..word(#v)..v) end
        elseif t=='table' then
            assert(not active[v],'绘制数据含循环引用')
            if tables[v] then put('\10'..word(tables[v]));return end
            tableCount=tableCount+1;if tableCount<=65535 then tables[v]=tableCount end;active[v]=true
            local map=false
            for k in pairs(v) do if k~='n' and (type(k)~='number' or k%1~=0 or k<1) then map=true;break end end
            if map then
                local keys={};for k in pairs(v) do assert(type(k)=='string' and #k<=128,'绘制字典键无效');keys[#keys+1]=k end
                table.sort(keys);assert(#keys<=256,'绘制字典过大');put('\9'..word(#keys))
                for _,k in ipairs(keys) do encode(k,depth+1);encode(v[k],depth+1) end
            else
                local n=v.n or #v;assert(n%1==0 and n>=0 and n<=65535,'绘制数组无效');put('\7'..word(n))
                for i=1,n do encode(v[i],depth+1) end
            end
            active[v]=nil
        elseif t=='userdata' and v.ARGB then
            local a,r,g,b=v:ARGB();put('\8'..string.char(math.floor(math.max(0,math.min(255,a))),r,g,b))
        else error('绘制报文含不支持的类型：'..t) end
    end
    encode(value,0);return table.concat(out)
end
function C.decode(bytes,color)
    assert(type(bytes)=='string' and #bytes<=C.MAX,'绘制报文过大')
    local p,strings,count=1,{},0
    local tables,tableCount={},0
    local function take(n) assert(p+n-1<=#bytes,'绘制报文不完整');local s=bytes:sub(p,p+n-1);p=p+n;return s end
    local function w() local a,b=take(2):byte(1,2);return a*256+b end
    local decode
    decode=function(depth)
        count=count+1;assert(count<1000000 and depth<=C.DEPTH,'绘制数据过多')
        local tag=take(1):byte()
        if tag==0 then return nil elseif tag==1 then return false elseif tag==2 then return true
        elseif tag==3 then return w()
        elseif tag==4 then
            local s=take(4);if not little then s=s:reverse() end;ffi.copy(u,s,4);local value=tonumber(f[0]);assert(value==value and math.abs(value)<=1e12,'绘制数值无效');return value
        elseif tag==5 then return assert(strings[w()],'绘制字符串编号无效')
        elseif tag==6 then local s=take(w());strings[#strings+1]=s;return s
        elseif tag==7 then
            tableCount=tableCount+1;local id=tableCount;local n=w();local v={n=n};for i=1,n do v[i]=decode(depth+1) end
            if id<=65535 then tables[id]=v end;return v
        elseif tag==8 then local a,r,g,b=take(4):byte(1,4);return color(a,r,g,b)
        elseif tag==9 then
            tableCount=tableCount+1;local id=tableCount;local n=w();assert(n<=256,'绘制字典过大');local v={}
            for _=1,n do local k=decode(depth+1);assert(type(k)=='string' and #k<=128 and v[k]==nil,'绘制字典键无效');v[k]=decode(depth+1) end
            if id<=65535 then tables[id]=v end;return v
        elseif tag==10 then return assert(tables[w()],'绘制表编号无效')
        else error('绘制数据类型无效') end
    end
    local value=decode(0);assert(p==#bytes+1,'绘制报文有多余内容');return value
end
NetCodec=C
return C
