-- 文花帖早期移植复用了永夜抄的15个历史槽位。只移动冲突项，原作来源键保持不变。
-- 已混在旧槽位中的成绩无法按作品拆回；保留旧槽位，文花帖从独立槽位开始记账。
local C={}
local conflicts={}
for id=453,460 do conflicts[id]=true end
for id=470,476 do conflicts[id]=true end
function C.resolve(level,id)
    if level==31 and conflicts[id] then return 33000+id end
    return id
end
return C
