-- 对普通弹、激光、绑定弹和最终攻击比较3600/7200帧的对象峰值；保留原作密度。
local output=arg[1] or '/tmp/th37-leaks.json'
local selected={[37004]=true,[37006]=true,[37023]=true,[37093]=true}
local rows,current={},nil
local H={quiet=true}
function H.select_card(_,entry) return selected[entry.card.card_id] end
function H.frame_limit() return 7200 end
function H.set_player() player.x,player.y=0,-176;return true end
function H.on_card(_,entry) current={id=entry.card.card_id,first=0,last=0};rows[#rows+1]=current end
function H.on_frame(_,f,_,objects)
    local n=0;for _,o in ipairs(objects) do if IsValid(o) and o.mhj then n=n+1 end end
    if f<=3600 then current.first=math.max(current.first,n) end
    current.last=math.max(current.last,n)
end
function H.on_error(_,message) error(message) end
function H.on_card_end()
    for o in pairs(TH37.runtime.objects) do assert(not IsValid(o),'阶段结束仍有原生对象') end
    print(('卡%d：3600峰值%d，7200峰值%d，清场0'):format(current.id,current.first,current.last));io.stdout:flush()
    collectgarbage('collect')
end
rawset(_G,'STAGE_HOOK',H);arg={'mod/GAME/th37.lua','7200'};dofile('tools/check_stage.lua')
assert(#rows==4)
local out={}
for _,r in ipairs(rows) do out[#out+1]=('{"id":%d,"peak3600":%d,"peak7200":%d,"remaining":0}'):format(r.id,r.first,r.last) end
local f=assert(io.open(output,'w'));f:write('{"seed":'..(os.getenv('STAGE_SEED') or '20260916')..',"rows":['..table.concat(out,',')..']}\n');f:close()
