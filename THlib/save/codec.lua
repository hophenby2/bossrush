-- 存档交换格式：有长度上限的 LZ 编码、Base64URL、SHA-256；只解码数据，不执行代码。
local C = { MAX_RAW = 16 * 1024 * 1024, MAX_TOKEN = 24 * 1024 * 1024 }
local bit = require('bit')
local band, bxor, bnot, ror, rshift = bit.band, bit.bxor, bit.bnot, bit.ror, bit.rshift
local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
function C.base64(s)
    local out,chunk = {},{}
    for i = 1, #s, 3 do
        local a, b, c = s:byte(i, i+2); b, c = b or 0, c or 0
        local n = a*65536+b*256+c
        local piece=alphabet:sub(math.floor(n/262144)+1,math.floor(n/262144)+1)..alphabet:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1)
        if i+1<=#s then piece=piece..alphabet:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1) end
        if i+2<=#s then piece=piece..alphabet:sub(n%64+1,n%64+1) end
        chunk[#chunk+1]=piece
        if #chunk==1024 then out[#out+1]=table.concat(chunk);chunk={} end
    end
    out[#out+1]=table.concat(chunk)
    return table.concat(out)
end
local values = {}; for i=1,#alphabet do values[alphabet:byte(i)] = i-1 end
function C.unbase64(s)
    assert(type(s)=='string' and #s <= C.MAX_TOKEN and #s%4~=1 and not s:find('[^%w_-]'), '口令编码无效')
    if #s%4==2 then assert(values[s:byte(-1)]%16==0,'口令编码不规范') end
    if #s%4==3 then assert(values[s:byte(-1)]%4==0,'口令编码不规范') end
    local out,chunk = {},{}
    for i=1,#s,4 do
        local a,b,c,d=s:byte(i,i+3)
        local n=assert(values[a])*262144+assert(values[b])*4096+(values[c] or 0)*64+(values[d] or 0)
        local piece=string.char(math.floor(n/65536))
        if c then piece=piece..string.char(math.floor(n/256)%256) end
        if d then piece=piece..string.char(n%256) end
        chunk[#chunk+1]=piece
        if #chunk==1024 then out[#out+1]=table.concat(chunk);chunk={} end
    end
    out[#out+1]=table.concat(chunk)
    local result=table.concat(out)
    return result
end
local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
  0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
  0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
  0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
  0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
  0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
  0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
  0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function be(n) return string.char(band(rshift(n,24),255),band(rshift(n,16),255),band(rshift(n,8),255),band(n,255)) end
function C.sha256(s)
    local n=#s
    s=s..'\128'..string.rep('\0',(55-n)%64)..be(math.floor(n/536870912))..be(n*8)
    local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
    local w={}
    for p=1,#s,64 do
        for i=0,15 do local a,b,c,d=s:byte(p+i*4,p+i*4+3); w[i]=bit.tobit(a*16777216+b*65536+c*256+d) end
        for i=16,63 do
            local x,y=w[i-15],w[i-2]
            w[i]=bit.tobit(w[i-16]+bxor(ror(x,7),ror(x,18),rshift(x,3))+w[i-7]+bxor(ror(y,17),ror(y,19),rshift(y,10)))
        end
        local a,b,c,d,e,f,g,j=unpack(h)
        for i=0,63 do
            local t=bit.tobit(j+bxor(ror(e,6),ror(e,11),ror(e,25))+bxor(band(e,f),band(bnot(e),g))+K[i+1]+w[i])
            local u=bit.tobit(bxor(ror(a,2),ror(a,13),ror(a,22))+bxor(band(a,b),band(a,c),band(b,c)))
            j,g,f,e,d,c,b,a=g,f,e,bit.tobit(d+t),c,b,a,bit.tobit(t+u)
        end
        for i,v in ipairs({a,b,c,d,e,f,g,j}) do h[i]=bit.tobit(h[i]+v) end
    end
    local out={}; for i,v in ipairs(h) do out[i]=bit.tohex(v) end; return table.concat(out)
end
function C.equal(a,b)
    if type(a)~='string' or type(b)~='string' or #a~=#b then return false end
    local n=0; for i=1,#a do n=bit.bor(n,bxor(a:byte(i),b:byte(i))) end; return n==0
end
-- 每段：0..127 + 1..128 个原字节；128..255 + 两字节回溯距离（长度 3..130）。
function C.compress(s)
    assert(#s<=C.MAX_RAW,'存档超过 16 MiB 交换上限')
    local out,dict,literal={}, {}, {}; local i=1
    local function remember(position,key)
        local expired=position-65536
        if expired>0 then local old=s:sub(expired,expired+2);if dict[old]==expired then dict[old]=nil end end
        dict[key]=position
    end
    local function flush() if #literal>0 then out[#out+1]=string.char(#literal-1)..table.concat(literal); literal={} end end
    while i<=#s do
        local key=s:sub(i,i+2); local previous=dict[key]; remember(i,key)
        local count=0
        if #key==3 and previous and i-previous<=65535 then
            while count<130 and i+count<=#s and s:byte(previous+count)==s:byte(i+count) do count=count+1 end
        end
        if count>=3 then
            flush(); local distance=i-previous
            out[#out+1]=string.char(128+count-3,math.floor(distance/256),distance%256)
            for j=i+1,i+count-1 do remember(j,s:sub(j,j+2)) end
            i=i+count
        else
            literal[#literal+1]=s:sub(i,i); i=i+1
            if #literal==128 then flush() end
        end
    end
    flush(); return table.concat(out)
end
function C.decompress(s)
    local out,window={},{}; local p,total=1,0; local chunk={}
    local function put(byte)
        total=total+1; assert(total<=C.MAX_RAW,'存档解压超出上限')
        window[(total-1)%65536]=byte; chunk[#chunk+1]=string.char(byte)
        if #chunk==4096 then out[#out+1]=table.concat(chunk); chunk={} end
    end
    while p<=#s do
        local control=s:byte(p); p=p+1
        if control<128 then
            assert(p+control<=#s,'存档片段不完整')
            for i=p,p+control do put(s:byte(i)) end; p=p+control+1
        else
            local a,b=s:byte(p,p+1); assert(b,'存档片段不完整'); p=p+2
            local distance=a*256+b; assert(distance>0 and distance<=total,'存档回溯无效')
            for _=1,control-128+3 do put(window[(total-distance)%65536]) end
        end
    end
    out[#out+1]=table.concat(chunk); return table.concat(out)
end
function C.pack(value)
    local raw=Serialize(value); assert(#raw<=C.MAX_RAW,'存档太大，请取消附带继续游戏数据或分批导出')
    return 'BRS1.'..C.sha256(raw)..'.'..C.base64(C.compress(raw))
end
function C.unpack(token)
    assert(type(token)=='string' and #token<=C.MAX_TOKEN,'口令过大')
    token=token:gsub('%s','')
    local digest,body=token:match('^BRS1%.([0-9a-f]+)%.([%w_-]+)$')
    assert(digest and #digest==64,'不是 Boss Rush 存档口令')
    local raw=C.decompress(C.unbase64(body)); assert(C.equal(C.sha256(raw),digest),'存档校验失败，内容可能缺失或损坏')
    local value=DeSerialize(raw); assert(type(value)=='table','存档数据无效'); return value
end
local passwords={2,3,5,7,11,13,17,19,23,29,31,37,41}
function C.lock(s,decode)
    local out={}; for i=1,#s do out[i]=string.char((s:byte(i)+(decode and -1 or 1)*passwords[i%13+1]-1)%127+1) end
    return table.concat(out)
end
function C.random(bytes)
    local ffi=require('ffi')
    if ffi.os=='Windows' then
        pcall(ffi.cdef,'long BCryptGenRandom(void*, unsigned char*, unsigned long, unsigned long);')
        local buffer=ffi.new('unsigned char[?]',bytes)
        assert(ffi.load('bcrypt').BCryptGenRandom(nil,buffer,bytes,2)==0,'无法生成配对密钥')
        return ffi.string(buffer,bytes)
    end
    local f=assert(io.open('/dev/urandom','rb')); local s=f:read(bytes); f:close(); assert(s and #s==bytes,'无法生成配对密钥'); return s
end
function C.id() return (C.random(16):gsub('.',function(c) return string.format('%02x',c:byte()) end)) end
SaveCodec=C
return C
