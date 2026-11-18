-- 每份子敌机完整自然寿命与独立精灵请求；不注入记录的坐标或结束状态。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={ENEMY=1};LAYER={ENEMY=0}
local children=dofile('mod/GAME/th46/boss1_children.lua')
local ref=dofile('tools/cv1000/fixtures/futari15_boss1_children.lua')
local run={serial=0,roadCamera=0,roadCameraDelta=0}
local parent={raw={[0x2314]=0}}
local objects={};local row,randomIndex
local states,draws,closed=0,0,0
local ports={bomb=function()return row[9]end,random=function(n)
    randomIndex=randomIndex+1
    local r=assert(row[7][randomIndex]);assert(n==r[1]);return r[2]
end}
for _,r in ipairs(ref.steps)do
    row,randomIndex=r,0;run.serial,run.roadCameraDelta=r[1],r[8]
    local o=objects[r[3]]
    if r[2]==0 then
        assert(not o or o.closed,'原版根槽重复占用')
        o=children.create(run,r[5][1],r[5][2],parent,r[6][1],r[6][2],r[6][3],ports);objects[r[3]]=o
    elseif r[2]==1 then assert(o and not o.closed);children.step(o);states=states+1
    else
        local index=0
        children.draw(o,function(...)
            index=index+1;local expected=assert(r[11][index]);local actual={...}
            for i=1,4 do assert(actual[i]==expected[i],'原版子敌机绘图参数不符')end
        end)
        assert(index==#r[11]);draws=draws+1
    end
    assert(randomIndex==#r[7],'构造随机调用没有用完')
    assert(o.closed==not r[4],'第 '..r[1]..' 帧子敌机结束时机不符：'..tostring(o.closed)..' / '..tostring(r[4])
        ..'，位置 '..o.boardX..','..o.boardY)
    for key,value in pairs(r[10])do assert(o[key]==value,'第 '..r[1]..' 帧子敌机 '..key..' 不符')end
    if r[2]==1 and o.closed then closed=closed+1 end
end
assert(closed==ref.instances and not next(run.boss1Children))
-- 原版没有普通扣血分支：自弹吸收，Bomb 与主人的清除才要求爆炸。
local explosions={}
ports.explode=function(o,byParent)explosions[#explosions+1]=byParent end
ports.random=function()return 0 end
row={[9]=false};run.serial=run.serial+1
local o=children.create(run,120*65536,160*65536,parent,256,16,0,ports)
for _=1,8 do run.serial=run.serial+1;children.step(o)end
assert(o.colli and o.protection==0)
local shot={colli=true,dmg=999999};o.class.colli(o,shot)
assert(shot.deleted and not shot.colli and not o.closed)
parent.raw[0x2314]=1;run.serial=run.serial+1;children.step(o)
assert(o.closed and explosions[1]==true)
parent.raw[0x2314]=0
o=children.create(run,120*65536,160*65536,parent,256,16,0,ports)
row[9]=true;run.serial=run.serial+1;children.step(o)
assert(o.closed and explosions[2]==false)
children.close(run);children.close(run);assert(not run.boss1Children)
print(('Futari 1.5 关底 %d 只子敌机、%d 次位移、%d 次双层绘图及碰撞/清除分支通过')
    :format(closed,states,draws))
