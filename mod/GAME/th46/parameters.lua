-- 0x0c078ab0：400 个 64 字节块，首个连续空段；分配块数为 floor(size/64)+1。
-- 释放只清占用标志，旧字节保留。任务初始化没有写过的字段不能自动归零。
local floor=math.floor
local function create()return{used={},bytes={}}end
local function allocate(pool,size)
    local count=floor(size/64)+1
    local first,free=0,0
    for i=0,399 do
        if pool.used[i]then free=0;first=i+1 else free=free+1 end
        if free==count then
            for j=first,first+count-1 do pool.used[j]=true end
            return{pool=pool,index=first,count=count,closed=false}
        end
    end
end
local function release(block)
    if not block or block.closed then return end
    block.closed=true
    for i=block.index,block.index+block.count-1 do block.pool.used[i]=nil end
end
local function read(block,offset,width)
    assert(not block.closed and offset>=0 and offset+width<=block.count*64,'任务参数读取越界')
    local n=0
    for i=0,width-1 do n=n*256+(block.pool.bytes[block.index*64+offset+i]or 0)end
    return n>=2^(width*8-1)and n-2^(width*8)or n
end
local function write(block,offset,width,n)
    assert(not block.closed and offset>=0 and offset+width<=block.count*64,'任务参数写入越界')
    n=n%2^(width*8)
    for i=width-1,0,-1 do block.pool.bytes[block.index*64+offset+i]=n%256;n=floor(n/256)end
end
return{create=create,allocate=allocate,release=release,read=read,write=write}
