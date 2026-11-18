-- 对照原版完整姿态更新，不使用采样坐标驱动游戏对象。
local pose=dofile('mod/GAME/th46/boss5_pose.lua')
local reference=dofile(os.getenv('FUTARI15_BOSS5_POSE')or'tools/cv1000/fixtures/futari15_boss5_pose.lua')
local b=reference.initial
local h=0
local function add(n)h=(h*131+n)%16777213 end
for i,row in ipairs(reference.steps)do
    local patch=row[7]
    for j=1,#patch,2 do b[patch[j]]=patch[j+1]end
    pose.update(b,row[2],row[3],row[4],row[5],row[6])
    add(row[1])
    for _,field in ipairs(pose.outputFields)do add(assert(b[field[1]]))end
    if reference.checkpoints[i]then
        assert(h==reference.checkpoints[i],'第五面姿态不符：第 '..row[1]..' 帧，校验 '..h..' / '..reference.checkpoints[i])
    end
end
assert(#reference.steps==reference.states and h==reference.hash)
print(('第五面关底 %d 次完整姿态、每次 %d 个输出字段通过'):format(reference.states,#pose.outputFields))

function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2},{ENEMY=-600}
local motion=dofile('mod/GAME/th46/boss5_motion.lua')
local ref=dofile(os.getenv('FUTARI15_BOSS5_MOTION')or'tools/cv1000/fixtures/futari15_boss5_motion.lua')
local host={run={serial=0}}
local test=dofile('tools/cv1000/verify_futari15_boss5_motion.lua')(motion,host,ref)
while true do
    test.prepare();motion.step(test.driver)
    if test.check()then break end
end
assert(test.driver.deleted and test.driver.closed and not host.motion)
print(('第五面关底 %d 次移动、相机输入、寻向与随机调用通过'):format(ref.states))

local body=dofile('mod/GAME/th46/boss5_body.lua')
local o=body.create({serial=0},{})
if ref.birthHash then
    local h=0
    for _,a in ipairs(ref.birthFields)do h=(h*131+a)%16777213;h=(h*131+assert(o.raw[a]))%16777213 end
    assert(h==ref.birthHash,'第五面构造返回不符：'..h..' / '..ref.birthHash)
end
assert(o.raw[8]==0 and o.raw[12]==0 and o.raw[0x2358]==0 and o.raw[0x235c]==0)
assert(o.raw[16]==16 and o.renderDepth==83 and #o.boxes==3)
assert(o.raw[0x2634]==0 and o.raw[0x2636]==0 and o.raw[0x263c]==0)
o.boxes[1].damage(o.boxes[1],1)
assert(o.hp==1807743 and o.raw[0x2610]==1,'第五面本体的半字无敌标记丢失，真实自弹无法扣血')
local shifted=body.initialize(-25*65536,317*65536)
for i=0,71 do assert(shifted[0x2358+i*8]==-25*65536 and shifted[0x235c+i*8]==317*65536)end
body.close(o);body.close(o)
assert(o.deleted and o.clock.deleted)
for _,box in ipairs(o.boxes)do assert(box.deleted)end
local pool=motion.parameters
local arena=pool.create()
local first,second=pool.allocate(arena,0),pool.allocate(arena,64)
assert(first.index==0 and first.count==1 and second.index==1 and second.count==2)
pool.write(first,48,2,-7);pool.write(first,50,1,1)
pool.release(first);pool.release(first)
local reused=pool.allocate(arena,52)
assert(reused.index==0 and pool.read(reused,48,2)==-7 and pool.read(reused,50,1)==1)
pool.release(reused);pool.release(second)
local full=assert(pool.allocate(arena,399*64))
assert(not pool.allocate(arena,0));pool.release(full)
