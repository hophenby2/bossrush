-- 全时限生命周期扫描；复用项目的严格对象桩，逐帧执行正式卡与对象代码。
-- 输出只是Lua模拟证据；不把它称作Windows原生或像素等价验证。
local output=arg[1] or '/tmp/th37-full.json'
local selection
if arg[2] then selection={};for id in arg[2]:gmatch('%d+') do selection[tonumber(id)]=true end end
local rows,failures,current={},0
local hook={quiet=true}
function hook.select_card(_,entry) return not selection or selection[entry.card.card_id] end
function hook.on_card(_,entry)
    current={id=entry.id,title=entry.name,frames=0,peak=0,peak_bullets=0}
    local c=entry.card;current.id=c.card_id or entry.data_id or current.id
    rows[#rows+1]=current
    current.meta=entry.card.mhj_source;current.patterns={}
    if not TH37.runtime._hp_fixture then
        local controller=TH37.runtime.controller
        TH37.runtime.controller=function(host,id,road)
            if not road and current.meta and current.meta.hp then
                if not current.hp_initialized then host.hp=current.meta.hp;current.hp_initialized=true end
                current.patterns[#current.patterns+1]=id
            end
            return controller(host,id,road)
        end
        TH37.runtime._hp_fixture=true
    end
end
function hook.frame_limit(_,entry) return math.ceil(entry.card.t3*60) end
function hook.set_player() player.x,player.y=0,-176;return true end
function hook.on_frame(_,frame,bullets,objects)
    current.frames=frame
    local n,shots=0,0
    for _,o in ipairs(objects) do if IsValid(o) and o.mhj then
        n=n+1
        if o.group==GROUP.ENEMY_BULLET or o.group==GROUP.INDES or o.group==GROUP.LASER then shots=shots+1 end
        assert(o.x==o.x and o.y==o.y and math.abs(o.x)<1e9 and math.abs(o.y)<1e9,'坐标非有限或越界发散')
    end end
    current.peak=math.max(current.peak,n);current.peak_bullets=math.max(current.peak_bullets,shots)
end
function hook.on_error(_,message) failures=failures+1;current.error=message;print('阶段失败：'..message) end
function hook.on_card_end()
    local n=0
    for o in pairs(TH37.runtime.objects) do if IsValid(o) then n=n+1 end end
    current.remaining=n
    if current.meta and current.meta.continuations then assert(#current.patterns==1+#current.meta.continuations,'最终攻击的CONTINUE未按剩余时间触发') end
    assert(n==0,'卡结束后还有幕华祭对象：'..n)
    io.stdout:write('完成阶段 '..#rows..'：'..current.frames..'帧，峰值'..current.peak..'，残留'..n..'\n');io.stdout:flush()
    collectgarbage('collect')
end
rawset(_G,'STAGE_HOOK',hook)
arg={'mod/GAME/th37.lua','7200'}
dofile('tools/check_stage.lua')
assert(failures==0,'全时限模拟发生运行错误')
local function json(s) return '"'..tostring(s):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n')..'"' end
local lines,total={},0
for _,r in ipairs(rows) do
    total=total+r.frames
    lines[#lines+1]=('{"id":%s,"frames":%d,"peak":%d,"peak_bullets":%d,"remaining":%d}'):format(tostring(r.id or 0),r.frames,r.peak,r.peak_bullets,r.remaining)
end
local file=assert(io.open(output,'w'));file:write('{"kind":"LuaJIT模拟","seed":'..(os.getenv('STAGE_SEED') or '20260916')..',"stages":'..#rows..',"frames":'..total..',"failures":'..failures..',"rows":['..table.concat(lines,',')..']}\n');file:close()
assert(selection or #rows==121,'阶段集合不完整')
print('完整时限检查通过：'..#rows..'段，'..total..'帧。')
