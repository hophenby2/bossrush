-- 双卡去重、同角色、坐标、状态/清场隔离与双 Boss 生命周期。
return function(f)
    local R,check=f.R,f.check
    local sameBoss=false
    for seed=1,500 do
        local cards=R.draw(seed,2);check(#cards==20,'双模式恰好二十张卡')
        local seen={}
        for i=1,#cards do
            local e=cards[i];assert(not seen[e.cardId],'双模式出现重复符卡');seen[e.cardId]=true
            if i%2==0 then
                local a,b=cards[i-1],cards[i]
                local ca=_sc_pr_table[a.level][a.index].sc_group[1].boss
                local cb=_sc_pr_table[b.level][b.index].sc_group[1].boss
                if ca.name==cb.name then sameBoss=true end
            end
        end
        local again=R.draw(seed,2)
        for i,e in ipairs(cards) do assert(e.key==again[i].key,'双模式种子不稳定') end
    end
    check(sameBoss,'允许抽到两名同角色 Boss，不限制角色去重')
    -- 临时对象后端，执行真实实例环境和真实 TH35 子机初始化/清理。
    local savedNew,savedList,savedBossInit=New,ObjList,boss.init
    local savedBulletDo=object.BulletIndesDo
    local objects={}
    New=function(class,...)
        local o=setmetatable({_live=true,otherboss={},group=0}, {__index=class})
        objects[#objects+1]=o
        if class.init then class.init(o,...) end
        return o
    end
    boss.init=function(b,x,y,cards) b.x=x;b.y=y;b.ctor_x=x;b.ctor_y=y;b.current_card=cards[1] end
    ObjList=function(group)
        local i=0
        return function() repeat i=i+1;if not objects[i] then return end until objects[i].group==group and IsValid(objects[i]);return i,objects[i] end
    end
    object.BulletIndesDo=function(fn) for _,o in ipairs(objects) do if IsValid(o) and (o.group==1 or o.group==5) then fn(o) end end end
    local D=dofile('mod/rogue_dual.lua')
    local left,right=D.context('TH35',96),D.context('TH35',-96)
    local a,b=f.pool[3].cards[2],f.pool[3].cards[3]
    local mainBefore=_sc_pr_table[a.level][a.index].sc_group[1].card.init
    local l,r=left:spawn(a),right:spawn(b)
    check(l.x==96 and r.x==-96 and l.y==r.y and l.y==80,'出生 X 分别 +96/-96，Y 保持原值')
    check(l~=r and #l.otherboss==0 and #r.otherboss==0,'同角色为两份独立对象，不互相同步换卡')
    local original=left.units[a.level][a.index].sc_group[1].card
    local baseline=_sc_pr_table[a.level][a.index].sc_group[1].card
    for _,key in ipairs({'hp','t1','t2','t3','card_id','is_sc'}) do check(original[key]==baseline[key],'原卡数值不变：'..key) end
    l.current_card.init(l);r.current_card.init(r)
    check(l.th10carrier and r.th10carrier and IsValid(l.th10carrier) and IsValid(r.th10carrier),'真实 TH35 两张卡都建立了 ECL 子机')
    l.current_card.del(l)
    check(not IsValid(l.th10carrier) and IsValid(r.th10carrier),'结束一张 TH35 卡不清除另一张的子机')
    check(_sc_pr_table[a.level][a.index].sc_group[1].card.init==mainBefore,'主卡目录的函数未被覆盖')
    local projectile={init=function(o) o.group=1 end}
    local lb=left.env.New(projectile);local rb=right.env.New(projectile);local global=New(projectile)
    left.env.object.BulletIndesDo(object.RawDel)
    check(not IsValid(lb) and IsValid(rb) and IsValid(global),'作用域清弹不影响另一实例和全局对象')
    local count=0;for _ in right.env.ObjList(1) do count=count+1 end
    check(count==1,'实例 ObjList 只返回自己的弹幕')
    right:cleanup();check(not IsValid(rb) and IsValid(global),'实例回收不影响全局弹幕')
    -- 在真实环境的私有卡上替换测试入口，验证 before 的多帧与 init 的瞬时定位。
    local pose=D.context('TH35',96)
    local pc=pose.units[a.level][a.index].sc_group[1].card
    pc.before=function(o) o.x=17;o.y=123;task.Wait(3);o.x=27 end
    pc.init=function(o) o.x=31;o.y=111 end
    local p=pose:spawn(a);task.New(p,function() p.current_card.before(p) end)
    task.Do(p);check(p.x==113 and p.y==123,'before 等待期间保持 +96 横移')
    for _=1,5 do task.Do(p) end
    check(p.x==123 and p.y==123,'before 完成后仍保留横移')
    p.current_card.init(p);check(p.x==127 and p.y==111,'开卡重新定位按原 X+96 / 原 Y 生效')
    left:cleanup()
    local function trackedCount() local n=0;for _ in pairs(left.objects) do n=n+1 end;return n end
    local baselineCount=trackedCount()
    do local transient={_live=true};left:track(transient) end
    collectgarbage('collect');collectgarbage('collect')
    check(trackedCount()==baselineCount,'实例跟踪不会强引用已经无人持有的弹幕')
    local expected,removed={},{}
    for i=1,3 do local o=left.env.New(projectile);expected[i]=o._rogue_order end
    local rawDel=object.RawDel
    object.RawDel=function(o) removed[#removed+1]=o._rogue_order;return rawDel(o) end
    left:cleanup();object.RawDel=rawDel
    check(table.concat(expected,',')==table.concat(removed,','),'弱引用对象按出生顺序回收，保证重建确定性')
    New,ObjList,boss.init=savedNew,savedList,savedBossInit;object.BulletIndesDo=savedBulletDo
    -- 生命周期用短命替身：一名三帧结束，另一名五十帧结束。
    local realContext=D.context
    D.context=function(source,dx)
        return {spawn=function(_,e)
            local part=_sc_pr_table[e.level][e.index].sc_group[1]
            local o=New(part.boss,{part.card});o.life=dx>0 and 3 or 50;o._test_dx=dx
            return o
        end,cleanup=function() end}
    end
    f.setReplay(false)
    local _,run=f.simulate(2027,nil,'dual');local spawned=f.spawns()
    check(run.won and run.completed==10 and #spawned==20,'双模式完整十步、二十 Boss 成功结算')
    check(stage.next_stage==stage.stages[R.modes.dual.result],'双模式进入独立结算')
    for i=1,20,2 do
        check(spawned[i].tick==spawned[i+1].tick,'同一步在同一逻辑帧同时创建')
        check(spawned[i].card.card_id~=spawned[i+1].card.card_id,'同时的两张卡不同')
        if i<19 then check(spawned[i+2].tick-spawned[i].tick>=185,'等待两名 Boss 全部结束才推进') end
    end
    local oldClears=scoredata.rogue10.cleared
    stage.current_stage=stage.next_stage;stage.next_stage=nil;stage.current_stage:init()
    check(scoredata.rogue_dual10.cleared==1 and scoredata.rogue10.cleared==oldClears,'双模式成绩与单模式分开')
    _,run=f.simulate(4000,4,'dual')
    check(not run.won and run.completed<10 and stage.next_stage==stage.stages[R.modes.dual.result],'双模式失误失败进入本模式结算')
    D.context=realContext
end
