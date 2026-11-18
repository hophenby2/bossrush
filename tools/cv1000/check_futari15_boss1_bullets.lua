-- 不读取样本位置驱动子弹；只给原始出膛参数、rank、闪光相位和外部相机位移。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={ENEMY_BULLET=2};LAYER={ENEMY_BULLET=2}
local bullets=dofile('mod/GAME/th46/boss1_bullets.lua')
local ref=dofile(os.getenv('FUTARI15_BULLET_FIXTURE')or'tools/cv1000/fixtures/futari15_boss1_bullets.lua')
local function digest(values)
    local n=0;for _,v in ipairs(values)do n=(n*131+v)%16777213 end;return n
end
local states,sprites,cancels=0,0,0
for _,case in ipairs(ref.cases)do
    local c=case.input
    local run={serial=c[1],roadRank=c[7],roadFlash=c[8],roadCameraDelta=0}
    local o=bullets.create(run,c[3],c[4],c[5],c[6],c[2],#c[9]>0 and c[9]or nil)
    for _,r in ipairs(case.steps)do
        run.serial,run.roadCameraDelta=r[1],r[3]
        if r[2]==1 then bullets.step(o)
        elseif r[2]==2 then
            local rows=o.rows;bullets.cancel(o,r[7]);assert(o.rows==rows,'碰撞覆盖了本步已提交的绘图')
            cancels=cancels+1
        end
        assert(not o.closed,'原版回调仍在执行时提前回收子弹')
        local values={}
        for _,field in ipairs(ref.fields)do values[#values+1]=assert(o[field])end
        values[#values+1]=o.motion and 1 or 0
        if o.motion then for _,field in ipairs(ref.motionFields)do values[#values+1]=assert(o[field])end end
        assert(digest(values)==r[4],'第 '..r[1]..' 帧弹型 '..c[2]..' 状态不符：'..digest(values)..' / '..r[4])
        if r[2]~=2 then
            local draw={};local count=0
            bullets.draw(o,function(...)
                count=count+1;for _,v in ipairs({...})do draw[#draw+1]=v end
            end)
            assert(count==r[6]and digest(draw)==r[5],'第 '..r[1]..' 帧弹型 '..c[2]..' 绘图不符')
            sprites=sprites+count
        end
        states=states+1
    end
    bullets.close(run);bullets.close(run)
    assert(o.closed and o.deleted and not run.boss1Bullets)
end
print(('Futari 1.5 关底 %d 发原生弹、%d 次状态、%d 份精灵及 %d 次真实消弹回调通过')
    :format(#ref.cases,states,sprites,cancels))
