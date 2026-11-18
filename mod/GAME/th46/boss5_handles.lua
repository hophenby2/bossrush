-- c077ea0/c078130/c0783f0 共用管理器 +16c6；分配失败不消耗句柄，溢出跳过零。
return{next=function(host)
    local handle=((host.nativeHandle or 0)+1)%65536
    if handle==0 then handle=1 end
    host.nativeHandle=handle
    return handle
end}
