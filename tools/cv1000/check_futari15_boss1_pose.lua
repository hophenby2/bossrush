-- 对照原版关节入口与返回，不把采样姿态直接拿来绘制。
local pose=dofile('mod/GAME/th46/boss1_pose.lua')
local reference=dofile('tools/cv1000/fixtures/futari15_boss1_pose.lua')
local b=reference.initial
local fields={};for _,f in ipairs(pose.outputFields)do fields[#fields+1]=f end
for _,at in ipairs({16,20,24})do fields[#fields+1]={at,4}end
table.sort(fields,function(a,c)return a[1]<c[1]end)
local hash,landings=0,0
local function add(n)hash=(hash*131+n)%16777213 end
for _,row in ipairs(reference.steps)do
    local patches=row[8]
    for i=1,#patches,2 do b[patches[i]]=patches[i+1]end
    local landed=pose.update(b,row[2],row[3],row[4],row[5],row[6])
    assert(landed==(row[7]~=0),'第 '..row[1]..' 帧落地事件不符')
    if landed then landings=landings+1 end
    add(row[1]);for _,field in ipairs(fields)do add(assert(b[field[1]]))end
end
assert(#reference.steps==reference.states and hash==reference.hash,'原版关节位置、振动或历史状态不符：'..hash..' / '..reference.hash)
assert(landings==reference.landings)
print(('Futari 1.5 关底 %d 次完整姿态、每次 %d 个字段、%d 次落地通过'):format(reference.states,#fields,landings))
