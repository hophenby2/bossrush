-- 在真实引擎中检查灯笼触发和Time.timeScale，使用隔离存档。
local T={};local checked={};local before,window
local function controller(key)
    for _,b in ipairs(boss_group) do if b[key] then return b[key] end end
end
function T.before(p)
    p.protect=100000
    if p.native_level==35 then
        local c=controller('mhj_controller');if not c or c.pattern.id~='652' then return end
        local lamp,threats
        threats=0
        for b,s in pairs(c.bullets) do if IsValid(b) and s.layerid==2 then
            if s.parentid==5 and s.life>0 then lamp=s end
            if s.parentid==11 and s.life>0 and b.colli then threats=threats+1 end
        end end
        if c.time>=500 and c.time<560 and lamp then assert(threats==0,'尚未追到灯笼就出现Boss有效弹');checked.wait=true end
        if c.time>=500 and c.time<550 and lamp then
            assert(math.abs(lamp.sonspeed-.78)<1e-6,'魂没有按原作进入0.78速度阶段')
            before={soul=lamp,x=lamp.fx,y=lamp.fy,age=lamp.age}
        end
        if c.time>=560 and lamp then p.x,p.y=lamp.fx-317,227-lamp.fy;checked.chase=true end
        if c.time>=560 and c.time<780 and threats>0 then checked.release=true end
    else
        local c=controller('asl_controller');if not c then return end
        local scene=stage.current_stage
        local key=AndroidInput.keys
        key[setting.keys.right]=scene.timer%8<4;key[setting.keys.left]=not key[setting.keys.right]
        before={time=c.time,scene=scene.timer,player=p.unity_source.Sincos.gametime,x=p.x}
        if NativeTime.scale<.34 and not window then window={frames=0,time=c.time,scene=scene.timer,player=before.player,moved=0} end
        if window and not checked.rate then window.frames=window.frames+1 end
        for _,s in ipairs(c.entities) do
            if s.kind=='time' then checked[s.birth]=true;assert(not s.native,'减速控制器生成了实体敌机') end
        end
        if checked[1151] and NativeTime.scale==1 then checked.restore=true end
    end
end
function T.after(p)
    if p.native_level==35 then
        if before and before.soul and before.soul.age==before.age+1 then
            local s=before.soul;local moved=((s.fx-before.x)^2+(s.fy-before.y)^2)^.5
            assert(math.abs(moved-.78)<1e-4,'真实引擎中魂的实际位移不符合原作0.78速度')
            checked.motion=true
        end
        return
    end
    if not before or not window or checked.rate then return end
    local c=controller('asl_controller');if not c then return end
    window.moved=window.moved+(p.x~=before.x and 1 or 0)
    if window.frames==100 then
        local elapsed=stage.current_stage.timer-window.scene
        assert(elapsed>=31 and elapsed<=35,'减速没有覆盖整个游戏时钟：'..elapsed)
        assert(c.time-window.time==elapsed*2,'敌弹与场景减速不同步')
        assert(p.unity_source.Sincos.gametime-window.player==elapsed*2,'自机与射击时钟没有减速')
        assert(window.moved>=31 and window.moved<=35,'自机位移没有减速：'..window.moved)
        checked.rate=true
        lstg.SystemLog('MECHANICS_TIME: 100渲染帧推进'..elapsed..'逻辑帧，自机位移'..window.moved..'次')
    end
end
function T.checkpoint()
    if player.native_level==35 then
        assert(checked.wait and checked.chase and checked.release and checked.motion,'魂的移动/追踪/灯笼触发检查未全部完成')
        lstg.SystemLog('SOURCE_LOGIC: 彷徨的空蝉真实引擎魂位移、追踪和灯笼触发通过')
    else
        assert(checked.rate and checked[181] and checked[781] and checked[1151] and checked.restore,'减速三轮与恢复检查未全部完成')
        lstg.SystemLog('SOURCE_LOGIC: 霜寒亿万劫真实引擎整场减速、三轮与恢复通过')
    end
end
return T
