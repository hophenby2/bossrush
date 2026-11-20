-- 按原作弹体列表的出生顺序维护绑定宿主；快照只在增删时重建。
-- 快照可在发弹期间继续使用，新出生的宿主从下一次查询起可见。
local B={}
local empty={}
local function compact(bucket)
    local entries=bucket.entries
    local n=0
    for i=1,#entries do
        local pair=entries[i]
        if pair[1] then n=n+1;entries[n]=pair end
    end
    for i=#entries,n+1,-1 do entries[i]=nil end
    bucket.dead=0
end
function B.new()
    return {members={},count=0}
end
function B.add(bucket,b,s)
    bucket.members[b]=s;bucket.count=bucket.count+1
    -- 未被任何发射器查询的弹组只维护成员表，不为每发普通弹分配索引节点。
    if not bucket.entries then return end
    local pair={b,s}
    bucket.nodes[b]=pair
    bucket.entries[#bucket.entries+1]=pair
    bucket.snapshot=nil
end
function B.remove(bucket,b)
    if not bucket or not bucket.members[b] then return end
    bucket.members[b]=nil;bucket.count=bucket.count-1
    if not bucket.entries then return end
    local pair=bucket.nodes[b]
    bucket.nodes[b]=nil
    -- 旧快照也不再持有已删除的引擎对象和状态。
    pair[1],pair[2]=false,false
    bucket.dead=bucket.dead+1;bucket.snapshot=nil
    if bucket.count==0 then bucket.entries={};bucket.dead=0
    elseif bucket.dead>64 and bucket.dead>#bucket.entries/2 then compact(bucket) end
end
function B.snapshot(bucket)
    if not bucket then return empty end
    if not bucket.entries then
        local entries,nodes={},{}
        for b,s in pairs(bucket.members) do
            local pair={b,s};entries[#entries+1]=pair;nodes[b]=pair
        end
        -- 首次查询恢复原作列表顺序，此后按出生顺序追加，不再逐帧排序。
        table.sort(entries,function(a,b) return a[2].serial<b[2].serial end)
        bucket.entries,bucket.nodes,bucket.dead=entries,nodes,0
    end
    if not bucket.snapshot then
        compact(bucket)
        local out={}
        for i=1,#bucket.entries do out[i]=bucket.entries[i] end
        bucket.snapshot=out
    end
    return bucket.snapshot
end
return B
