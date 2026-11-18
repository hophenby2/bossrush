-- 比对所有跳跃/宽幅炮回调；自机坐标与 rank 是输入，出膛及子敌机请求由原生对象计算。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local guns=dofile('mod/GAME/th46/boss1_guns.lua')
local ref=dofile('tools/cv1000/fixtures/futari15_boss1_guns_extra.lua')
local run={serial=0};local player={pilotPosition={}}
local host={run=run,player=player,raw={}}
local objects={};local row,opIndex
local calls,shots,children,closed=0,0,0,0
local function operation(kind,...)
    local args={kind,...};local op=assert(row[14][opIndex+1],'多调用炮台接口 '..kind)
    assert(#args==#op[1]and args[1]==op[1][1],'炮台接口参数数目不符：'..kind)
    for i,v in ipairs(args)do
        if v==host then v='host'end
        assert(v==op[1][i],'第 '..row[1]..' 帧 '..kind..' 参数 '..i..' 不符：'..tostring(v)..' / '..tostring(op[1][i]))
    end
    opIndex,calls=opIndex+1,calls+1;return op[2]
end
local ports={}
ports.random=function(n)return operation('random',n)end
ports.rank=function()return row[12]end
ports.motionFan=function(_,...)operation('motionFan',...);shots=shots+1 end
ports.fan=function(_,...)operation('fan',...);shots=shots+1 end
ports.child=function(_,...)operation('child',...);children=children+1 end
ports.pose=function(_,a,m)operation('pose',a,m);host.raw[76],host.raw[80]=a,m end
for _,r in ipairs(ref.steps)do
    row,opIndex=r,0;run.serial=r[1]
    for i,at in ipairs(ref.fields)do host.raw[at]=r[8][i]end
    host.boardX,host.boardY=host.raw[8],host.raw[12]
    player.pilotPosition.x,player.pilotPosition.y=r[10][1],r[10][2];player.respawn=r[11]
    local o=objects[r[3]]
    if r[4]=='leap_init'then assert(not o);o=guns.leap(host,ports,r[7]);objects[r[3]]=o
    elseif r[4]=='wide_init'then assert(not o);o=guns.wide(host,ports,r[7]);objects[r[3]]=o
    else assert(o and not o.closed);guns.step(run)end
    assert(opIndex==#row[14],'原版炮台接口没有用完')
    for field,value in pairs(r[13])do
        assert(o[field]==value,'第 '..r[1]..' 帧 '..r[4]..' 字段 '..field..' 不符：'..tostring(o[field])..' / '..value)
    end
    for i,at in ipairs(ref.fields)do assert(host.raw[at]==r[9][i],'炮台本体写回不符')end
    assert(o.closed==not r[6],'炮台结束时机不符')
    if o.closed then closed=closed+1 end
    local once=calls;guns.step(run);assert(calls==once,'同一步重复更新炮台')
end
assert(closed==4 and children==96)
guns.close(run);for _,o in pairs(objects)do assert(o.closed and o.deleted)end
print(('Futari 1.5 关底 %d 次跳跃/宽幅炮回调、%d 次接口、%d 组扇弹及 %d 只子敌机请求通过')
    :format(#ref.steps,calls,shots,children))
