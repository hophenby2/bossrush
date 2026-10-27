-- LuaJIT FFI 的非阻塞 IPv4 HTTP 传输。每帧有收发预算，不阻塞游戏线程。
local ffi=require('ffi')
local windows,mac=ffi.os=='Windows',ffi.os=='OSX'
local N={MAX_BODY=SaveCodec.MAX_TOKEN+65536,MAX_CLIENTS=8}
local socketType=windows and 'uintptr_t' or 'int'
ffi.cdef(([[
typedef %s br_socket_t;
br_socket_t socket(int,int,int); int bind(br_socket_t,const void*,int); int listen(br_socket_t,int);
br_socket_t accept(br_socket_t,void*,int*); int connect(br_socket_t,const void*,int);
int getsockname(br_socket_t,void*,int*); int getsockopt(br_socket_t,int,int,void*,int*);
int setsockopt(br_socket_t,int,int,const void*,int);
int gethostname(char*,int);
struct br_hostent { char* name; char** aliases; short type; short length; char** addresses; };
struct br_hostent* gethostbyname(const char*);
]]):format(socketType))
local lib
if windows then
    ffi.cdef[[int WSAStartup(unsigned short,void*); int WSAGetLastError(void); int closesocket(br_socket_t);
        int ioctlsocket(br_socket_t,long,unsigned long*); int recv(br_socket_t,char*,int,int); int send(br_socket_t,const char*,int,int);
        unsigned long long GetTickCount64(void);]]
    lib=ffi.load('ws2_32'); assert(lib.WSAStartup(0x202,ffi.new('uint8_t[512]'))==0,'网络初始化失败')
else
    ffi.cdef[[int close(int); int fcntl(int,int,...); long recv(int,void*,size_t,int); long send(int,const void*,size_t,int);
        struct br_timeval { long sec; long usec; }; int gettimeofday(struct br_timeval*,void*);
        struct br_ifaddrs { struct br_ifaddrs* next; char* name; unsigned int flags; void* addr; void* netmask; void* broad; void* data; };
        int getifaddrs(struct br_ifaddrs**); void freeifaddrs(struct br_ifaddrs*);]]
    lib=ffi.C
end
function N.now()
    if windows then return tonumber(ffi.C.GetTickCount64())/1000 end
    local t=ffi.new('struct br_timeval[1]'); ffi.C.gettimeofday(t,nil); return tonumber(t[0].sec)+tonumber(t[0].usec)/1e6
end
local function invalid(s) return tonumber(ffi.cast('intptr_t',s))==-1 end
local function close(s) if windows then lib.closesocket(s) else lib.close(s) end end
local function nonblock(s)
    if windows then assert(lib.ioctlsocket(s,0x8004667e,ffi.new('unsigned long[1]',1))==0)
    else assert(lib.fcntl(s,4,ffi.new('int',mac and 4 or 2048))==0) end
    if mac then lib.setsockopt(s,65535,0x1022,ffi.new('int[1]',1),4) end
end
local function again()
    local e=windows and lib.WSAGetLastError() or ffi.errno()
    return e==11 or e==35 or e==36 or e==57 or e==107 or e==115 or e==10035 or e==10036 or e==10057
end
function N.private(ip)
    if type(ip)~='string' then return false end
    local a,b,c,d=ip:match('^(%d+)%.(%d+)%.(%d+)%.(%d+)$'); a,b,c,d=tonumber(a),tonumber(b),tonumber(c),tonumber(d)
    if not a or a>255 or b>255 or c>255 or d>255 or d==255 then return false end
    return a==10 or a==127 or (a==172 and b>=16 and b<=31) or (a==192 and b==168) or (a==169 and b==254)
end
local function address(ip,port)
    local a,b,c,d=ip:match('^(%d+)%.(%d+)%.(%d+)%.(%d+)$')
    assert(a and tonumber(a)<=255 and tonumber(b)<=255 and tonumber(c)<=255 and tonumber(d)<=255,'IPv4 地址无效')
    assert(type(port)=='number' and port%1==0 and port>=0 and port<=65535,'端口无效')
    local out=ffi.new('uint8_t[16]'); if mac then out[0],out[1]=16,2 else out[0]=2 end
    out[2],out[3]=math.floor(port/256),port%256; out[4],out[5],out[6],out[7]=tonumber(a),tonumber(b),tonumber(c),tonumber(d)
    return out
end
local function ipv4(pointer)
    local p=ffi.cast('uint8_t*',pointer)
    if (mac and p[1] or p[0]+p[1]*256)~=2 then return nil end
    return string.format('%d.%d.%d.%d',p[4],p[5],p[6],p[7])
end
function N.addresses()
    local result,seen={},{}
    local function add(ip) if ip and N.private(ip) and ip~='127.0.0.1' and not seen[ip] then seen[ip]=true; result[#result+1]=ip end end
    if windows then
        local hostname=ffi.new('char[256]')
        if lib.gethostname(hostname,256)==0 then
            local host=lib.gethostbyname(hostname)
            if host~=nil then local i=0; while host.addresses[i]~=nil do
                local p=ffi.cast('uint8_t*',host.addresses[i]); add(string.format('%d.%d.%d.%d',p[0],p[1],p[2],p[3])); i=i+1
            end end
        end
    else
        local list=ffi.new('struct br_ifaddrs*[1]')
        if lib.getifaddrs(list)==0 then
            local p=list[0]; while p~=nil do if p.addr~=nil then add(ipv4(p.addr)) end; p=p.next end; lib.freeifaddrs(list[0])
        end
    end
    table.sort(result); return result
end
local function makeSocket()
    local s=lib.socket(2,1,0); assert(not invalid(s),'无法创建网络连接'); nonblock(s); return s
end
local function parseHeader(text,response)
    local first,rest=text:match('^([^\r\n]+)\r\n(.*)$'); if not first then first,rest=text,'' end
    local h={}; for key,value in rest:gmatch('([^\r\n:]+):%s*([^\r\n]*)\r?\n?') do
        key=key:lower(); assert(not h[key],'重复 HTTP 请求头'); h[key]=value:gsub('\r$','')
    end
    assert(not h['transfer-encoding'],'不支持流式请求')
    local length=h['content-length'] and tonumber(h['content-length']) or 0
    assert(length and length>=0 and length%1==0 and length<=N.MAX_BODY,'传输内容超过上限')
    if response then local status=first:match('^HTTP/1%.[01] (%d%d%d)'); assert(status,'响应无效'); return {status=tonumber(status),headers=h,length=length} end
    local method,path=first:match('^(%u+) (/[^ ]*) HTTP/1%.[01]$'); assert(method and (method=='GET' or method=='POST'),'请求无效')
    return {method=method,path=path,headers=h,length=length}
end
local buffer=ffi.new('char[8192]')
local function receive(c,response)
    for _=1,16 do
        local n=tonumber(lib.recv(c.socket,buffer,8192,0))
        if n==0 then return nil,'连接已关闭' end
        if n<0 then if again() then return false end; return nil,'网络读取失败' end
        local part=ffi.string(buffer,n); c.received=c.received+n
        if not c.header then
            c.head=c.head..part; assert(#c.head<=16384+8192,'HTTP 请求头过长')
            local endAt=c.head:find('\r\n\r\n',1,true)
            if endAt then
                c.header=parseHeader(c.head:sub(1,endAt-1),response)
                part=c.head:sub(endAt+4); c.head=''; c.parts={}; c.length=0
            else part='' end
        end
        if c.header then
            c.parts[#c.parts+1]=part; c.length=c.length+#part
            assert(c.length<=c.header.length,'HTTP 内容长度不匹配')
            if c.length==c.header.length then c.header.body=table.concat(c.parts); return c.header end
        end
    end
    return false
end
local sendFlags=(not windows and not mac) and 0x4000 or 0
local function send(c)
    for _=1,16 do
        if c.offset>#c.output then return true end
        local length=math.min(65536,#c.output-c.offset+1)
        local n=tonumber(lib.send(c.socket,c.output:sub(c.offset,c.offset+length-1),length,sendFlags))
        if n<0 then if again() then return false end; return nil,'网络发送失败' end
        if n==0 then return nil,'连接已关闭' end
        c.offset=c.offset+n
    end
    return false
end
local function connection(s) return {socket=s,head='',received=0,started=N.now(),offset=1} end
function N.response(status,body,contentType)
    return 'HTTP/1.1 '..status..' Result\r\nContent-Length: '..#body..'\r\nContent-Type: '..(contentType or 'application/json; charset=utf-8')..
        '\r\nCache-Control: no-store\r\nConnection: close\r\nX-Content-Type-Options: nosniff\r\nReferrer-Policy: no-referrer\r\n'..
        "Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: blob:; media-src blob:; connect-src 'self'; frame-ancestors 'none'\r\n\r\n"..body
end
function N.server(handler,port)
    local s=makeSocket(); lib.setsockopt(s,windows and 65535 or (mac and 65535 or 1),2,ffi.new('int[1]',1),4)
    assert(lib.bind(s,address('0.0.0.0',port or 0),16)==0,'端口绑定失败'); assert(lib.listen(s,8)==0,'无法监听连接')
    local addr=ffi.new('uint8_t[16]'); assert(lib.getsockname(s,addr,ffi.new('int[1]',16))==0)
    local server={socket=s,port=addr[2]*256+addr[3],clients={}}
    function server:poll()
        for _=1,4 do
            if #self.clients>=N.MAX_CLIENTS then break end
            local client=lib.accept(self.socket,nil,nil); if invalid(client) then break end
            nonblock(client); self.clients[#self.clients+1]=connection(client)
        end
        for i=#self.clients,1,-1 do
            local c=self.clients[i]; local done,err
            if N.now()-c.started>120 then err='连接超时'
            elseif c.output then done,err=send(c)
            else
                local ok,request,message=pcall(receive,c,false)
                if not ok then c.output=N.response(400,Serialize({error='请求内容无效'}))
                elseif request then
                    local success,status,body,kind=pcall(handler,request)
                    if success then c.output=N.response(status or 200,body or '',kind)
                    else c.output=N.response(400,Serialize({error=tostring(status)})) end
                elseif request==nil then err=message end
            end
            if done or err then close(c.socket); table.remove(self.clients,i) end
        end
    end
    function server:close() for _,c in ipairs(self.clients) do close(c.socket) end; close(self.socket); self.clients={} end
    return server
end
function N.request(ip,port,path,token,body,callback)
    assert(N.private(ip),'只允许连接同网段、热点或本机 IPv4 地址')
    local s=makeSocket(); local c=connection(s)
    local result=lib.connect(s,address(ip,port),16)
    if result~=0 and not again() then close(s); callback(nil,'无法连接对方，请检查 Wi-Fi、热点和防火墙'); return nil end
    body=body or ''; assert(#body<=N.MAX_BODY,'传输内容过大')
    c.output=(#body>0 and 'POST' or 'GET')..' '..path..' HTTP/1.1\r\nHost: '..ip..':'..port..
        '\r\nAuthorization: Bearer '..token..'\r\nContent-Type: application/json\r\nContent-Length: '..#body..'\r\nConnection: close\r\n\r\n'..body
    function c:poll()
        local response,err
        if N.now()-self.started>120 then err='连接超时，请检查两端网络'
        elseif self.output then local sent; sent,err=send(self); if sent then self.output=nil end
        else
            local ok,value,message=pcall(receive,self,true)
            if not ok then err='对方响应无效' elseif value then response=value elseif value==nil then err=message end
        end
        if response or err then close(self.socket); callback(response,err); return true end
        return false
    end
    return c
end
SaveTransport=N
return N
