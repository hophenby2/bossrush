-- 完整移动回调含姿态更新，对照原版入口/返回的本体、私有参数、函数切换与随机次序。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local motion=dofile('mod/GAME/th46/boss1_motion.lua')
local fn={simple=0xc14f630,simple_init=0xc14f690,wander=0xc14f6d0,wander_init=0xc14f7e0,
    move_init=0xc14f870,entry=0xc14f960,entry_init=0xc14fa20,move=0xc14fa80}
local fields={move={'state','targetX','targetY','clock','interval','acceleration','half'},
    wander={'anchorX','anchorY','targetX','targetY'},entry={'state','clock'}}
local function check(ref)
local row,randomIndex
local run={serial=ref.steps[1][1]-1}
local host={run=run,raw=ref.initial}
local o=motion.create(host,ref.steps[1][2],ref.steps[1][9],function(limit)
    local tape=row[11]
    assert(tape[randomIndex+1]==limit,'原版移动随机数范围或调用次数改变')
    local value=assert(tape[randomIndex+2]);randomIndex=randomIndex+2;return value
end)
for k,v in pairs(ref.variables)do o[k]=v end
local hash=0
local function add(n)hash=(hash*131+n)%16777213 end
for _,r in ipairs(ref.steps)do
    row,randomIndex=r,0
    if o.mode~=r[2]then motion.switch(o,r[2],r[9])end
    for i=1,#r[10],2 do host.raw[r[10][i]]=r[10][i+1]end
    host.motionInput={r[4],r[5],r[6],r[7],r[8]};run.serial=r[1]
    motion.step(o)
    assert(o.mode==r[3],'第 '..r[1]..' 帧移动入口切换不符：'..o.mode..' / '..r[3])
    assert(randomIndex==#r[11],'原版移动随机调用没有用完')
    add(r[1]);add(fn[o.mode])
    for _,field in ipairs(ref.fields)do add(assert(host.raw[field[1]]))end
    for _,name in ipairs(fields[o.mode]or{})do add(o[name])end
end
assert(hash==ref.hash,'原版移动位置、速度、朝向或私有参数不符：'..hash..' / '..ref.hash)
local x=host.raw[8];motion.step(o);assert(host.raw[8]==x,'同一逻辑步被重复执行')
motion.close(o);motion.close(o);assert(o.deleted and not host.motion)
print(('Futari 1.5 关底 %d 次原生移动、姿态、加减速、入口切换与随机调用通过'):format(ref.states))
end
local fixture=os.getenv('FUTARI15_MOTION_FIXTURE')
if fixture then check(dofile(fixture))
else
    check(dofile('tools/cv1000/fixtures/futari15_boss1_motion.lua'))
    check(dofile('tools/cv1000/fixtures/futari15_boss1_motion_camera.lua'))
end
