-- 对照原作 C#：一面激光、羊群、十二提婆、四方金刚以及道中自机狙。
arg={'th37-reported'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
ran.Float=function(_,a,b) return (a+b)/2 end
local R=dofile('mod/GAME/th37/runtime.lua')
local expected={}
local chosen=os.getenv('BOSSRUSH_PATTERN')
for line in io.lines('tools/th37-tests/oracle/reported/reported.tsv') do
    local a={};for word in line:gmatch('%S+') do a[#a+1]=tonumber(word) or word end
    local key=table.concat({a[1],a[2],a[3],a[4],a[5],a[6]},':')
    if not chosen or tostring(a[1])==chosen then
        local group=expected[key] or {};expected[key]=group;group[#group+1]=a
    end
end
local objects,raw={},New
New=function(cls,s,...) local o=raw(cls,s,...);objects[#objects+1]=o;return o end
R.sound=function() end -- 轨迹夹具不推进音频设备；正式原生检查另行覆盖音效载入。
local count,maximum=0,0
for _,id in ipairs({'172','163','584','586','191','2221','33','51'}) do
 if not chosen or chosen==id then
    local c=R.controller({_live=true,x=-2,y=52},id)
    player.x,player.y=0,-180
    player.protect,player.death=999,0
    for tick=1,900 do
        R.tick(c)
        local born=#objects
        for i=1,born do local o=objects[i];if IsValid(o) then o.class.frame(o) end end
        if tick<=120 or tick%30==0 then
            for _,o in ipairs(objects) do
                local s=o.mhj
                if IsValid(o) then
                    local beam=s.kind=='laser'
                    local key=table.concat({id,tick,s.layerid,s.parentid,s.age,beam and 1 or 0},':')
                    local group=assert(expected[key],'原作没有该弹体：'..key)
                    local nearest,distance
                    for i,a in ipairs(group) do
                        local delta=((a[8]-s.fx)^2+(a[9]-s.fy)^2)^.5
                        if not distance or delta<distance then nearest,distance=i,delta end
                    end
                    assert(distance and distance<.03,'位置偏离原作：'..key..' / '..tostring(distance)..' actual='..s.fx..','..s.fy..' expected='..(group[nearest or 1] and table.concat(group[nearest or 1],',') or 'nil'))
                    local a=table.remove(group,nearest)
                    assert(s.type==a[7]+(beam and 0 or 1),'弹型偏离原作：'..key)
                    if beam then
                        assert(math.abs(s.rlongs-a[14])<.01,'激光长度偏离原作：'..key)
                        assert(math.abs(s.wscale-a[15])<.001,'激光宽度偏离原作：'..key)
                    end
                    if #group==0 then expected[key]=nil end
                    count=count+1;maximum=math.max(maximum,distance)
                end
            end
        end
        if tick%60==0 then local live={};for _,o in ipairs(objects) do if IsValid(o) then live[#live+1]=o end end;objects=live end
    end
    R.clear(c);objects={}
 end
end
assert(not next(expected),'漏掉原作仍然存活的弹体：'..tostring(next(expected)))
print(('原作轨迹 %d 个采样匹配，最大位置误差 %.8f 像素。'):format(count,maximum))
