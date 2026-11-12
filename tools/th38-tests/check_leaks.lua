-- 对普通弹、绑定、多Boss、最终攻击扫描两倍时长；原作1500普通弹池上限不能丢失。
local output=arg[1] or '/tmp/th38-leaks.json'
local selected={[38004]=true,[38012]=true,[38035]=true,[38047]=true,[38089]=true}
local current,rows
rows={}
local H={quiet=true}
function H.select_card(_,entry) return selected[entry.card.card_id] end
function H.frame_limit() return 7200 end
function H.set_player() player.x,player.y=0,-176;return true end
function H.on_card(_,entry) current={id=entry.card.card_id,first=0,last=0,emitters=0};rows[#rows+1]=current end
function H.on_frame(_,frame,_,objects)
    local n=0
    for _,o in ipairs(objects) do if IsValid(o) and o.asl then n=n+1 end end
    if frame<=3600 then current.first=math.max(current.first,n) end
    current.last=math.max(current.last,n)
    for c in pairs(TH38.runtime.controllers) do current.emitters=math.max(current.emitters,#c.emitters) end
    assert(TH38.runtime.bulletCount<=1500,'超出原作固定普通弹池上限')
end
function H.on_error(_,why) error(why) end
function H.on_card_end()
    assert(TH38.runtime.bulletCount==0,'清场后普通弹池未归零')
    for o in pairs(TH38.runtime.objects) do assert(not IsValid(o),'清场后残留引擎对象') end
    print(('卡%d：3600峰值%d、7200峰值%d、发射器峰值%d，清场0'):format(current.id,current.first,current.last,current.emitters));io.stdout:flush();collectgarbage('collect')
end
rawset(_G,'STAGE_HOOK',H);arg={'mod/GAME/th38.lua','7200'};dofile('tools/check_stage.lua')
assert(#rows==5)
local out={}
for _,r in ipairs(rows) do out[#out+1]=('{"id":%d,"peak3600":%d,"peak7200":%d,"emitters":%d,"remaining":0}'):format(r.id,r.first,r.last,r.emitters) end
local f=assert(io.open(output,'w'));f:write('{"seed":'..(os.getenv('STAGE_SEED') or '20260916')..',"rows":['..table.concat(out,',')..']}\n');f:close()
