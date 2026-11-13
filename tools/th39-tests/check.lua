-- 用正式类与严格引擎桩逐帧检查卡链、道中等待和首波弹。
local mode=arg[1] or 'cards'
local selection=arg[2]
local function loader()
    local f=assert(io.open('tools/check_stage.lua'));local source=f:read('*a');f:close()
    arg={'th39-check'}
    KeyIsPressed=function() return false end
    assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
    dofile('THlib/lib/Ltask.lua')
    dofile('mod/GAME/th39.lua')
end

if mode=='flow' then
    loader()
    local pending,seen,wall,peak,objects
    New=function(cls,...)
        if cls.StageLevel==37 then
            for _,card in ipairs((...)) do seen[#seen+1]=card.mhj3_source.id end
            pending={_live=true,ttl=3};return pending
        end
        local o={class=cls,_live=true,timer=0,ani=0,del=cls.del}
        cls.init(o,...)
        objects[#objects+1]=o
        return o
    end
    for _,chapter in ipairs(TH39.data.chapters) do
        if chapter.difficulty~=9 then
            pending,seen,wall,peak,objects=nil,{},0,0,{}
            lstg.var.sequence_run={}
            local co=coroutine.create(function() TH39.runChapter({},chapter) end)
            while coroutine.status(co)~='dead' do
                wall=wall+1;assert(wall<chapter.length+10000,'关卡未自然结束')
                local frozen=pending and pending._live
                local before=lstg.var.sequence_run.road_time
                local ok,msg=coroutine.resume(co);assert(ok,msg)
                if frozen and pending._live then
                    assert(lstg.var.sequence_run.road_time==before,'Boss在场时关卡轴前进')
                    pending.ttl=pending.ttl-1;if pending.ttl==0 then pending._live=false end
                end
                local active=objects
                objects={}
                for _,o in ipairs(active) do
                    if IsValid(o) then
                        o.timer=o.timer+1;o.ani=o.timer
                        if o.class.frame then o.class.frame(o) end
                        if IsValid(o) then objects[#objects+1]=o end
                    end
                end
                peak=math.max(peak,#objects)
            end
            local expected={}
            for _,group in ipairs(chapter.bosses) do
                for _,c in ipairs(group.cards) do
                    if c.kind~=2 or (c.condition or 0)==0 then expected[#expected+1]=c.id end
                end
            end
            assert(#seen==#expected,'阶段数不符 '..chapter.name..' '..#seen..'/'..#expected)
            for i,id in ipairs(expected) do assert(id==seen[i],'Boss顺序不符') end
            for o in pairs(TH39.runtime.objects) do assert(not IsValid(o),'关末残留对象') end
            print(('关卡 %s，%d 战斗，%d 帧，峰值 %d'):format(chapter.name,#seen,wall,peak))
            io.stdout:flush()
        end
    end
    return
end

if mode=='motion' then
    loader()
    local R=TH39.runtime
    local host={_live=true,x=0,y=100}
    local c=R.controller(host,'1420',true)
    local new=New;local shots={}
    New=function(cls,s,...)
        local o=new(cls,s,...)
        if cls==R.classes.projectile then shots[#shots+1]=o end
        return o
    end
    for _=1,35 do R.tick(c) end
    assert(#shots==0,'首个发射器周期之前提前出弹')
    R.tick(c)
    assert(#shots==2,'首轮出弹数应为2')
    for _,o in ipairs(shots) do
        local x,y=o.x,o.y
        for _=1,15 do o.class.frame(o) end
        assert(o.x==x and o.y==y,'雾化期提前运动')
        o.class.frame(o)
        local d=math.sqrt((o.x-x)^2+(o.y-y)^2)
        assert(math.abs(d-o.mhj.sonspeed*2/3)<1e-6,'首个有效帧没有按源速度位移')
        assert(o.vx==0 and o.vy==0,'引擎速度重复积分')
    end
    R.clear(c)
    for _,o in ipairs(shots) do assert(not IsValid(o),'清场残留子弹') end
    print('b1420 首轮2发，15帧雾化，原速度投影及清场通过')
    return
end

if mode=='transitions' then
    loader()
    local runtime=TH39.runtime
    local newController=runtime.controller
    local checked=0
    for _,chapter in ipairs(TH39.data.chapters) do
        for _,group in ipairs(chapter.bosses) do
            for _,meta in ipairs(group.cards) do
                local changes=0
                for _,track in pairs(meta.tracks) do changes=changes+#track-1 end
                if changes>0 then
                    local phase=TH39.cards[meta.id]
                    local host={_live=true,x=0,y=70,hp=meta.hp,colli=true}
                    local started={}
                    runtime.controller=function(owner,id,...)
                        started[id]=true
                        return newController(owner,id,...)
                    end
                    phase.init(host)
                    for _=1,250 do phase.frame(host) end
                    local ctx=host.mhj3_card
                    for _,a in ipairs(ctx.actors) do
                        if a.track then
                            for i=2,#a.track do
                                local threshold=a.track[i]
                                if threshold.familiar>0 then
                                    a.phaseClock=30
                                    a.controller.deadFamiliars[threshold.familiar]=1
                                elseif threshold.hp>0 then host.hp=threshold.hp
                                else ctx.clock=300+(meta.seconds-threshold.time)*60 end
                                phase.frame(host)
                                assert(started[threshold.pattern],'未进入分段 '..threshold.pattern)
                                checked=checked+1
                            end
                        end
                    end
                    phase.del(host)
                    assert(runtime.bulletCount==0,'分段测试后弹池未归零')
                end
            end
        end
    end
    assert(checked>0)
    print(('%d 个 Boss 分段按血量、剩余时限或使魔击破切换。'):format(checked))
    return
end

local current,done,frames,earlyPeak,overflow=0,0,0,0,0
local H={quiet=true}
function H.select_card(_,entry)
    return not selection or (','..selection..','):find(','..entry.card.card_id..',',1,true)~=nil
end
function H.on_card(_,entry) current=entry.card;current.testPeak=0;frames=0;earlyPeak=0;overflow=TH39.runtime.overflow end
function H.frame_limit(_,entry)
    if mode=='long' then return 7200 end
    local cap=entry.card.phase_kind=='road' and 16500 or math.ceil(entry.card.t3*60)+2
    return mode=='short' and math.min(cap,720) or cap
end
function H.set_player() player.x,player.y=0,-176;return true end
function H.on_frame(_,frame,_,objects)
    frames=frame
    local n=0
    for _,o in ipairs(objects) do if IsValid(o) and o.mhj then
        assert(o.x==o.x and o.y==o.y and math.abs(o.x)<1e9 and math.abs(o.y)<1e9,'无效坐标')
        n=n+1
    end end
    current.testPeak=math.max(current.testPeak,n)
    if frame<=3600 then earlyPeak=math.max(earlyPeak,n) end
end
function H.on_error(_,message) error(message) end
function H.on_card_end()
    for o in pairs(TH39.runtime.objects) do assert(not IsValid(o),'阶段清场后残留对象') end
    assert(TH39.runtime.bulletCount==0,'弹池未归零')
    collectgarbage('collect')
    done=done+1
    print(('阶段 %d，%d 帧，3600帧峰值 %d，总峰值 %d，溢出 %d'):format(
        current.card_id,frames,earlyPeak,current.testPeak,TH39.runtime.overflow-overflow));io.stdout:flush()
end
KeyIsPressed=function() return false end
rawset(_G,'STAGE_HOOK',H)
arg={'mod/GAME/th39.lua','720'}
dofile('tools/check_stage.lua')
assert(selection or done==123,'练习集合不完整')
