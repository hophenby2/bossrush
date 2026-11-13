-- 完整时限模拟所有注册阶段；核对真实坐标、绑定对象、转阶段和清场。
local output=arg[1] or '/tmp/th38-full.json'
local selection
if arg[2] then selection={};for id in arg[2]:gmatch('%d+') do selection[tonumber(id)]=true end end
local rows,failures,current={},0
local H={quiet=true}
function H.select_card(_,e) return not selection or selection[e.card.card_id] end
function H.on_card(_,e)
    current={id=e.card.card_id,frames=0,peak=0,shots=0,emitters=0};rows[#rows+1]=current
    current.meta=e.card.asl_source;current.transitions=0
    if not TH38.runtime._hpFixture then
        local controller,transition=TH38.runtime.controller,TH38.runtime.transition
        TH38.runtime.controller=function(host,key,first)
            if host and current.meta.hp and not current.hpInitialized then host.hp=current.meta.hp;current.hpInitialized=true end
            return controller(host,key,first)
        end
        TH38.runtime.transition=function(...)
            current.transitions=current.transitions+1;return transition(...)
        end
        TH38.runtime._hpFixture=true
    end
end
function H.frame_limit(_,e) return math.ceil(e.card.t3*60) end
function H.set_player() player.x,player.y=0,-176;return true end
function H.on_frame(_,frame,_,objects)
    current.frames=frame
    local n,shots=0,0
    for _,o in ipairs(objects) do if IsValid(o) and o.asl then
        n=n+1
        if o.group==GROUP.ENEMY_BULLET or o.group==GROUP.INDES or o.group==GROUP.LASER then shots=shots+1 end
        assert(o.x==o.x and o.y==o.y and math.abs(o.x)<1e8 and math.abs(o.y)<1e8,'原生坐标非有限或发散')
    end end
    local emitters=0;for c in pairs(TH38.runtime.controllers) do emitters=emitters+#c.emitters end
    current.peak=math.max(current.peak,n);current.shots=math.max(current.shots,shots);current.emitters=math.max(current.emitters,emitters)
end
function H.on_error(_,message) failures=failures+1;current.error=message;print('阶段失败：'..message) end
function H.on_card_end()
    for o in pairs(TH38.runtime.objects) do assert(not IsValid(o),'卡结束后残留原生对象') end
    for c in pairs(TH38.runtime.controllers) do assert(c.closed,'卡结束后残留发射器状态') end
    if current.meta.transitions then assert(current.transitions==#current.meta.transitions,'分段攻击没有执行全部时间阈值') end
    current.remaining=0
    print(('完成%d：id%d %d帧，对象峰值%d，弹峰值%d，发射器峰值%d，清场0'):format(#rows,current.id,current.frames,current.peak,current.shots,current.emitters));io.stdout:flush()
    collectgarbage('collect')
end
rawset(_G,'STAGE_HOOK',H);arg={'mod/GAME/th38.lua','7200'};dofile('tools/check_stage.lua')
assert(failures==0,'完整时限模拟存在错误')
local total,out=0,{}
for _,r in ipairs(rows) do total=total+r.frames;out[#out+1]=('{"id":%d,"frames":%d,"peak":%d,"bullets":%d,"emitters":%d,"transitions":%d,"remaining":0}'):format(r.id,r.frames,r.peak,r.shots,r.emitters,r.transitions) end
local f=assert(io.open(output,'w'));f:write('{"kind":"LuaJIT模拟","stages":'..#rows..',"frames":'..total..',"failures":0,"rows":['..table.concat(out,',')..']}\n');f:close()
assert(selection or #rows==91,'注册阶段数量不完整')
print('完整时限检查通过：'..#rows..'段，'..total..'帧。')
