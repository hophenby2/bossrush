-- TH32 专用桩件：真实 task.Wait 帧语义；实例不从类表继承任意方法。
local mode, frames, seedmode = arg[1], tonumber(arg[2]) or 2400, arg[3] or 'always'
local bit = require('bit')
local tasks, cards, objects = {}, {}, {}
local noop = function() end
_G._editor_class, _G._editor_boss, _G.TH08_bg = {}, {}, {}
_G.ball_small, _G.arrow_small, _G.ball_big, _G.knife, _G.ball_huge = {}, {}, {}, {}, {}
_G.GROUP={GHOST=0,ENEMY=2,LASER=10};_G.LAYER={ENEMY=0,ENEMY_BULLET=0}
_G.SetAttr=function(b,k,v) rawset(b,k,v) end
_G.BossWalkImageSystem=function() return {SetImageInList=noop,frame=noop,render=noop} end
_G.enemy={init=function(b,style,hp) b.hp=hp;b.maxhp=hp;b._wisys={frame=noop,render=noop};b._a=255;b._r=255;b._g=255;b._b=255 end,render=noop}
_G.item={obj={}}
for _,name in ipairs({'faith','point','addcharge','addmisscount','faith_minor'}) do
    item.obj[name]={init=function(b,x,y) b.x,b.y=x,y end}
end
_G.object = {Preserve=noop,RawDel=function(b) b._live=false end, Del=function(b) b._live=false end}
_G.IsValid = function(b) return b and b._live ~= false end
_G.PlaySound = noop
_G.ran = {Float=function(_,a,b) return (a+b)/2 end,Int=function(_,a) return a end}
_G.player = {x=0,y=0}
_G.task = {
    New=function(b,fn) tasks[#tasks+1]=coroutine.create(fn) end,
    Wait=function(n) for _=1,n or 1 do coroutine.yield() end end,
}
_G.bullet = {
    init=function(b,style,index,stay,destroyable)
        assert(type(index)=='number' and index>=1 and index<=16,'原生弹图必须使用有效颜色号')
        b.logclass,b.class,b.imgclass=b.class,style,style
        b._index,b.real_index,b._a,b._live=index,index,255,true
    end,
    ChangeImage=function(b,style,index) b.imgclass,b._index,b.real_index=style,index,index end,
    frame=noop,render=noop,
}
_G.laser = {
    init=function(b,index,x,y,rot,l1,l2,l3,w)
        b.index,b.x,b.y,b.rot,b.l1,b.l2,b.l3,b.w0=index,x,y,rot,l1,l2,l3,w
        b.w,b.alpha,b._live=0,0,true
    end,
    frame=noop,render=noop,
}
_G.Class = function(base,def)
    local c={}
    for k,v in pairs(base or {}) do c[k]=v end
    for k,v in pairs(def or {}) do c[k]=v end
    return c
end
_G.New = function(c,...)
    assert(type(c)=='table','New 第一参必须是原生类')
    local b={class=c,x=0,y=0,vx=0,vy=0,rot=0,timer=0,_live=true}
    c.init(b,...);objects[#objects+1]=b
    return b
end
_G.boss = {Define=function(key,name,bgm,bg,xy,sc,img,level) _editor_boss[key..level]={cards={}} end,card={
    New=function(name,t1,t2,t3,hp) return {name=name,t1=t1,t2=t2,t3=t3,hp=hp} end,
    add=function(group,level,name,id) local c=group[1][1];c.card_id=id;cards[#cards+1]={card=c,id=id};table.insert(_editor_boss[group[1][2]..level].cards,c) end,
}}
dofile('mod/GAME/th32.lua')
assert(#cards==106,'必须是 91 段 Boss 战、14 段道中和原有自制卡')

if mode=='program' then
    local function up(fn,name)
        for i=1,100 do local key,value=debug.getupvalue(fn,i);if not key then break end;if key==name then return value end end
    end
    local first
    for _,item in ipairs(cards) do if item.card.th06_source then first=item;break end end
    local H=assert(up(first.card.init,'H'));local P=assert(up(H.new_actor,'P'))
    if seedmode=='oracle' then dofile('tools/th32-tests/reference_vm.lua')(H,P,dofile(arg[4])) end
    local selected=tonumber(arg[5]);local current,now,count,hash=0,0,0,5381
    local dump=arg[6] and assert(io.open(arg[6],'w'))
    TH32_NATIVE_TRACE=function(b,kind,...)
        local fields={now,b.th06_actor and b.th06_actor.sub or -1,kind}
        for _,v in ipairs({...}) do fields[#fields+1]=type(v)=='number' and string.format('%.10g',v) or tostring(v) end
        local line=table.concat(fields,'|')
        count=count+1
        for i=1,#line do hash=(hash*33+line:byte(i))%4294967296 end
        if dump then dump:write(current,'|',line,'\n') end
    end
    local seed=tonumber(os.getenv('TH32_TEST_SEED')) or 20261030
    ran.Float=function(_,a,b) return a+(b-a)*math.random() end
    ran.Int=function(_,a,b) return math.random(a,b) end
    for _,item in ipairs(cards) do
        local c=item.card
        if c.th06_source and (not selected or item.id==selected) then
            current=item.id;tasks,objects={},{};count,hash=0,5381
            _G.stage={current_stage={}}
            math.randomseed(seed+item.id*7919)
            local b={x=0,y=384,hp=c.hp,maxhp=c.hp,_live=true,a=16,b=16,DMG_factor=1,_a=255}
            if c.frame then c.frame(b) end;c.before(b);c.init(b)
            local peak,peaklasers,peakactors,last=0,0,0,0
            for t=0,math.min(frames,math.ceil(c.t3*60)) do
                now=t;last=t
                player.x,player.y=120*math.sin(t/211),-160+35*math.sin(t/97)
                if c.frame then c.frame(b) end
                for _,co in ipairs(tasks) do if coroutine.status(co)~='dead' then local ok,err=coroutine.resume(co);assert(ok,err) end end
                local i=1
                while i<=#objects do
                    local o=objects[i]
                    if IsValid(o) then
                        if o.class.frame then o.class.frame(o) end
                        o.x,o.y=o.x+(o.vx or 0),o.y+(o.vy or 0);o.timer=o.timer+1
                    end
                    i=i+1
                end
                local bullets,lasers,actors=0,0,0
                for j=#objects,1,-1 do
                    local o=objects[j]
                    if not IsValid(o) then table.remove(objects,j)
                    elseif o.th06_origin_x then lasers=lasers+1 elseif o.th06_sprite then bullets=bullets+1 elseif o.th06_actor then actors=actors+1 end
                end
                peak,peaklasers,peakactors=math.max(peak,bullets),math.max(peaklasers,lasers),math.max(peakactors,actors)
                assert(bullets<=640 and lasers<=64 and actors<=256,string.format('对象池上限失效：卡 %d，弹 %d / 光 %d / 敌机 %d',item.id,bullets,lasers,actors))
                if b.hp<=0 then break end
            end
            c.del(b)
            for _,o in ipairs(objects) do assert(not IsValid(o),'换卡有原生对象残留 '..item.id) end
            print(string.format('%d|%d|%u|%d|%d|%d|%d',item.id,count,hash,peak,peaklasers,peakactors,last))
        end
    end
    if dump then dump:close() end
    return
end

local functions, seen = {}, {}
local function visit(fn)
    if seen[fn] then return end
    seen[fn]=true;functions[#functions+1]=fn
    for i=1,100 do
        local name,value=debug.getupvalue(fn,i)
        if not name then break end
        if type(value)=='function' then visit(value) end
    end
end
for i=1,5 do visit(cards[i].card.init) end
local function find(name)
    for _,fn in ipairs(functions) do
        for i=1,100 do
            local key,value=debug.getupvalue(fn,i)
            if not key then break end
            if key==name then return value end
        end
    end
    error('缺少内部函数 '..name)
end
local function patch(name,value)
    for _,fn in ipairs(functions) do
        for i=1,100 do
            local key=debug.getupvalue(fn,i)
            if not key then break end
            if key==name then debug.setupvalue(fn,i,value) end
        end
    end
end
local function approx(a,b) assert(math.abs(a-b)<1e-7,string.format('%g ~= %g',a,b)) end
local function state() return {pool={},next_slot=1,rank_speed=0,lasers={}} end
if mode=='stress' then
    for i=1,5 do
        tasks,objects={},{}
        local c=cards[i].card
        local b={x=0,y=384}
        c.frame(b);c.before(b);c.init(b)
        local peak,peaklasers,peaklist=0,0,0
        for t=0,frames do
            player.x,player.y=120*math.sin(t/211),-160+35*math.sin(t/97)
            c.frame(b)
            for _,co in ipairs(tasks) do
                if coroutine.status(co)~='dead' then local ok,err=coroutine.resume(co);assert(ok,err) end
            end
            for _,o in ipairs(objects) do
                if IsValid(o) then o.class.frame(o);o.x=o.x+o.vx;o.y=o.y+o.vy;o.timer=o.timer+1 end
            end
            local bullets,lasers=0,0
            for j=#objects,1,-1 do
                if not IsValid(objects[j]) then table.remove(objects,j)
                elseif objects[j].th06_sprite then bullets=bullets+1 else lasers=lasers+1 end
            end
            assert(bullets<=640 and lasers<=48,'对象越过原作弹池上限')
            peak,peaklasers,peaklist=math.max(peak,bullets),math.max(peaklasers,lasers),math.max(peaklist,#b.th06.lasers)
            assert(b.x>=-160 and b.x<=160 and b.y>=104 and b.y<=176,'Boss 越过原作移动边界')
        end
        c.del(b)
        for _,o in ipairs(objects) do assert(not IsValid(o),'换卡后有对象残留') end
        assert(peaklist<=48,'激光登记表积累失效引用')
        print(string.format('通过：id=%d，%d 帧，峰值弹 %d / 激光 %d / 激光登记表 %d，换卡零残留',cards[i].id,frames,peak,peaklasers,peaklist))
    end
    return
end
if mode=='unit' then
    local shoot,single,seed,awake,star=find('shoot'),find('single'),find('seed_small'),find('awaken'),find('star')
    local b={x=0,y=0,th06=state()}
    player.y=-100
    shoot(b,'aim',9,1,8,1,7,2,0,-math.pi/10,516)
    assert(#b.th06.pool==8)
    local first=b.th06.pool[1]
    approx(first.th06_angle,math.pi/2-math.pi/20)
    assert(first.th06_spawn==24 and first._index==6 and first.a==16 and first.rect)
    local distance=0
    for i=1,24 do first.class.frame(first);distance=distance+math.sqrt(first.vx^2+first.vy^2) end
    approx(distance,24*7/2.5+7)
    assert(first.colli and first.th06_tick==1)
    local p=single(state(),8,1,0,0,0,2,544,{100,0,math.pi/100})
    for _=1,100 do p.class.frame(p) end
    approx(p.th06_angle,math.pi);approx(p.vx,-2)
    p.class.frame(p);approx(p.vx,-2)
    assert(p.rect and p.rot==0 and p.a==4.5)
    local a=single(state(),6,3,0,0,0,1.3,528,{120,.015})
    for _=1,120 do a.class.frame(a) end
    approx(a.vx,3.1);a.class.frame(a);approx(a.vx,3.1)
    local s=state();local owner={x=0,y=0,th06=s}
    single(s,9,1,0,0,0,2,512)
    assert(seed(owner)==1 and s.pool[2].th06_sprite==3)
    local small=s.pool[2]
    awake(owner,false)
    assert(small.th06_awake and small._index==2 and small.th06_vx==0)
    for _=1,31 do small.class.frame(small);approx(small.vx,0);approx(small.vy,0) end
    small.class.frame(small);approx(small.vx,.01)
    for _=1,119 do small.class.frame(small) end
    approx(small.vx,1.2);small.class.frame(small);approx(small.vx,1.2)
    s=state();owner.th06=s
    shoot(owner,'ring',9,1,640,1,2,1,0,0,512)
    assert(not single(s,9,1,0,0,0,2,0),'弹池必须限制为 640')
    object.Del(s.pool[127]);assert(single(s,9,1,0,0,0,2,0)==s.pool[127])
    p=single(state(),5,2,201,0,0,1.3,2560,{1,-1})
    p.class.frame(p);approx(p.vx,-1.3);assert(p.th06_flags==512)
    p.x=-201;p.th06_out=0;p.class.frame(p);assert(not IsValid(p),'一次反弹后再次越界必须释放')
    owner.th06=state();star(owner)
    assert(#owner.th06.lasers==48)
    local ray=owner.th06.lasers[1]
    approx(ray.x,32);approx(ray.y,0)
    for i=0,165 do
        ray.class.frame(ray)
        if i<50 then assert(not ray.colli) end
        if i==50 then assert(ray.colli and ray.l2<20) end
        if i==60 then approx(ray.l2,440);approx(ray.w,10) end
        if i==150 then assert(ray.colli and ray.l2<20) end
        local x,y,l,w=ray.x,ray.y,ray.l2,ray.w
        ray.class.render(ray);assert(x==ray.x and y==ray.y and l==ray.l2 and w==ray.w)
    end
    ray.class.frame(ray);assert(not IsValid(ray))
    shoot(owner,'ring',9,1,2,1,2,1,0,0,512)
    cards[1].card.del(owner)
    assert(owner.th06==nil)
    for _,o in ipairs(objects) do if o.th06_x then assert(not IsValid(o)) end end

    -- 后续全关新增的弹效与 ExIns 几何，直接对照 C++ 的公式和分支。
    p=single(state(),3,2,0,0,0,2,576,{10,math.pi/2,2,2})
    for _=1,10 do p.class.frame(p) end;approx(p.vx,.2)
    p.class.frame(p);approx(p.vy,-2);assert(p.th06_turns==1)
    for _=1,10 do p.class.frame(p) end;approx(p.vx,-2);assert(p.th06_flags==512)
    player.x,player.y=100,0
    p=single(state(),3,2,0,0,0,2,128,{3,math.pi/4,3,1})
    for _=1,4 do p.class.frame(p) end;approx(p.vx,3/math.sqrt(2));approx(p.vy,-3/math.sqrt(2))
    p=single(state(),5,2,201,0,0,1.3,1536,{3,-1})
    p.class.frame(p);assert(p.th06_turns==1 and p.th06_flags==1536)
    p.x,p.y=0,233;p.class.frame(p);assert(p.th06_turns==2)
    p.x,p.y=-201,0;p.class.frame(p);assert(p.th06_turns==3 and p.th06_flags==512)
    local function getup(fn,name)
        for i=1,100 do local key,value=debug.getupvalue(fn,i);if key==name then return value elseif not key then break end end
    end
    local H
    for _,item in ipairs(cards) do if item.card.th06_source then H=getup(item.card.init,'H');break end end
    assert(H)
    local function actor(hp)
        local s=state();s.actors={};s.laser_pool={}
        local b={x=0,y=0,hp=hp or 6000,_live=true}
        H.new_actor(s,b,7,23,true,{epoch=0,threshold=0,shot=0})
        return b,b.th06_actor,s
    end
    local b,a,s=actor()
    local cross_colour=single(s,9,5,0,0,0,0,0)
    assert(cross_colour._index==10,'时停 GREEN8 变色要支持四原色泡弹')
    cross_colour=single(s,6,15,0,0,0,0,0)
    assert(cross_colour._index==16,'冻结 WHITE 变色要支持八色大玉')
    local frozen=single(s,3,2,0,0,0,2,0)
    H.extra(b,a.context,0,0,false);assert(frozen.th06_speed==0 and frozen._index==16)
    frozen.class.frame(frozen);approx(frozen.vx,0)
    H.extra(b,a.context,0,1,false);frozen.class.frame(frozen);approx(frozen.vx,.01)
    local tick=frozen.th06_tick;s.time_stopped=true;frozen.class.frame(frozen);approx(frozen.vx,0);assert(frozen.th06_tick==tick)
    s.time_stopped=false;frozen.class.frame(frozen);approx(frozen.vx,.02)
    local function pattern() return {mode='fan',sprite=3,c=2,n=1,l=1,v1=1,v2=.2,angle=0,step=0,flags=0} end
    b,a,s=actor();a.pattern=pattern();a.context.i2=0;a.context.i3=300;a.context.f3=60
    H.extra(b,a.context,2,0,true)
    assert(#s.pool==5 and a.context.i2==1)
    approx(s.pool[1].x,60*math.cos(4*math.pi/5));approx(s.pool[1].y,-60*math.sin(4*math.pi/5))
    b,a,s=actor();a.pattern=pattern();a.context.f2=0;a.context.f3=60;a.context.f1=.4
    H.extra(b,a.context,13,3,false)
    assert(#s.pool==3);approx(s.pool[1].x,60);approx(s.pool[1].y,0)
    approx(s.pool[2].x,60*math.cos(2*math.pi/3));approx(s.pool[2].y,-60*math.sin(2*math.pi/3))
    for _=1,5 do H.extra(b,a.context,13,3,false) end;assert(#s.pool==3)
    H.extra(b,a.context,13,3,false);assert(#s.pool==6)
    b,a,s=actor();a.pattern=pattern()
    local l=H.laser(b,false,1,6,0,0,0,120,120,20,0,100,16,0,16,0)
    H.extra(b,a.context,14,0,false);assert(#s.pool==3 and a.context.i3==1)
    approx(s.pool[1].x,0);approx(s.pool[2].x,48);approx(s.pool[3].x,96)
    b,a,s=actor()
    single(s,9,1,64,0,0,1,0)
    local near=single(s,3,1,48,48,0,0,0);local far=single(s,3,1,200,200,0,0,0)
    H.extra(b,a.context,15,0,true);assert(a.context.i3==1 and near.th06_speed==.01 and far.th06_speed==0)
    approx(near.th06_angle,-math.pi*.55);assert(near._index==2)
    H.extra(b,a.context,16,0,false);approx(a.context.f3,1);assert(a.context.c1==280)
    b.hp=3000;H.extra(b,a.context,16,0,false);approx(a.context.f3,1.5);assert(a.context.c1==160)
    b.hp=6000;a.phase=7200;H.extra(b,a.context,16,0,false);approx(a.context.f3,2);assert(a.context.c1==40)
    local saved=ran.Float;ran.Float=function(_,lo,hi) return lo end
    a.phase=0;H.extra(b,a.context,16,1,false);approx(a.context.f2,112);approx(a.context.f3,64)
    ran.Float=saved
    assert(frozen.rank_speed==false,'原作弹体不能叠加第二套全局弹速倍率')
    local programs=getup(H.new_actor,'P')
    local saved_program=programs[7][0]
    local mirrored_at_birth
    programs[7][0]=function(obj)
        mirrored_at_birth=obj.th06_actor.mirrored
        obj.th06_actor.axisx,obj.th06_actor.axisy=3,-2
    end
    b,a,s=actor();s.road=true;s.road_drop_state={count=0,index=1}
    local child=H.timeline_spawn(b,6,0,-999,-999,-999,30,1,300)
    assert(not mirrored_at_birth and child.th06_actor.mirrored)
    approx(child.x,-8);approx(child.y,16);approx(child.th06_actor.z,400)
    H.actor_motion(child.th06_actor);approx(child.x,-11);approx(child.y,18)
    child.hp=0;H.kill_actor(child.th06_actor)
    assert(child.th06_actor.loot_done and child.th06_actor.dead and not IsValid(child))
    programs[7][0]=saved_program
    local road={}
    for _,entry in ipairs(cards) do if entry.card.th06_source and entry.card.th06_source.road then road[entry.id]=entry.card.th06_source end end
    local function carrier() return {x=0,y=400,hp=10000000,maxhp=10000000,_live=true,a=0,b=0,DMG_factor=1,_a=255} end
    _G.stage={current_stage={}}
    local front=carrier();H.road_init(front,road[4000]);H.road_del(front)
    for _=1,600 do H.road_mid_tick({stage=1,meta={group=2}}) end
    local back=carrier();H.road_init(back,road[4001])
    assert(back.th06_actor.context.epoch==600 and back.t3==2670 and not back._colli and back._a==0)
    H.road_del(back)
    _G.stage.current_stage={}
    back=carrier();H.road_init(back,road[4001]);assert(back.th06_actor.context.epoch==0 and back.t3==3270);H.road_del(back)
    front=carrier();H.road_init(front,road[4004]);H.road_del(front)
    for _=1,600 do H.road_mid_tick({stage=3,meta={group=6}}) end
    back=carrier();H.road_init(back,road[4005]);assert(back.th06_actor.context.epoch==0 and back.t3==2049);H.road_del(back)
    print('通过：道中随机范围、首次执行后镜像、可击破和掉落、非冻结轴追时、冻结轴续接及独立练习')
    print('通过：连续转向、三次反弹、时停、冻结解冻、五角星、皇家烈焰、激光衍生、笼中鸟唤醒和最终符 HP/时间狂暴')
    print('通过：原生对象、24/32 帧出场、向量加速、曲率、全池衍生/唤醒、640 弹上限、一次反弹、48 段激光及清理')
    return
end
assert(mode=='trace')
local ci,now,seedcalls=0,0,0
local function event(kind,...)
    local out={ci,now,kind}
    for _,v in ipairs({...}) do out[#out+1]=type(v)=='number' and string.format('%.12g',v) or v end
    io.write(table.concat(out,'|'),'\n')
end
local function angle(a)
    while a>math.pi do a=a-2*math.pi end
    while a< -math.pi do a=a+2*math.pi end
    return a
end
patch('begin',function(b,y,rank) b.th06=state();b.th06.rank_speed=rank or 0;task.Wait(120) end)
patch('shoot',function(b,kind,sprite,c,n,l,v1,v2,a,step,flags,ex)
    local r=b.th06.rank_speed;ex=ex or {}
    event('shot',kind,sprite,c,n,l,v1~=0 and math.max(.3,v1+r) or 0,math.max(.3,v2+r/2),angle(a),step,flags,
        bit.band(flags,16+32+2048)~=0 and (ex[1] or -1) or -1,
        bit.band(flags,16+32+2048)~=0 and (ex[2] or -1) or -1,
        bit.band(flags,16+32)~=0 and (ex[3] or -999) or -1)
end)
patch('star',function() event('star',0) end)
patch('drift',function(b,v,n) event('drift',v,n) end)
patch('seed_small',function()
    seedcalls=seedcalls+1;event('seed')
    return (seedmode=='zero' or seedmode=='early' and seedcalls%13==0) and 0 or 1
end)
patch('awaken',function(b,each) event('awake',each and 11 or 9) end)
for i=1,5 do
    ci=i;tasks={};seedcalls=0
    local c=cards[i].card;local b={x=0,y=0};player.x,player.y=0,0
    c.frame(b);c.before(b);c.init(b)
    for t=0,frames do
        now=t
        for _,co in ipairs(tasks) do
            if coroutine.status(co)~='dead' then local ok,err=coroutine.resume(co);assert(ok,err) end
        end
    end
end
