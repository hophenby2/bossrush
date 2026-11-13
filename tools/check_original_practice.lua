-- 载入真实注册与练习菜单，验证原作入口、历史槽位、阶段顺序和道中波次分段。
-- 只使用内存中的成绩表，不读写User/或replay/。
arg[1]='original-practice-registry'
local file=assert(io.open('tools/check_stage.lua','rb'));local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
dofile('THlib/enemy/boss_card.lua')
_sc_table,_sc_pr_table={},{}
local tracing,events,tick=false,{},0
local serialize
local originalNew=New
local controllerClass,controller
New=function(cls,...)
    if tracing then
        if cls==controllerClass then
            local _,x,y,main=...
            local p={_live=true,timer=0,class=cls,ecs={base={x=0,y=0},off={x=x,y=y}},
                I0=0,I1=0,I2=0,I3=0,F0=0,F1=0,F2=0,F3=0}
            task.New(p,function() main(p) end)
            controller=p
            return p
        end
        events[#events+1]={tick=tick,cls=cls,payload=tostring(cls)..serialize({...})}
        return {_live=true,timer=0,class=cls,ecs={base={x=0,y=0},off={x=0,y=0}}}
    end
    return originalNew(cls,...)
end
dofile('mod/_editor_output.lua')
for game=31,35 do dofile('mod/GAME/th'..game..'.lua') end
dofile('mod/GAME/th37.lua')
dofile('mod/GAME/th38.lua')
dofile('mod/GAME/th39.lua')
dofile('mod/GAME/th40.lua')
dofile('tools/native-ports/register.lua')
local F=OriginalStageFlow
local legacy,hosts={},{}
for level=29,33 do
    legacy[level]={}
    for index,unit in ipairs(_sc_pr_table[level]) do
        legacy[level][index]=unit
        for _,part in ipairs(unit.sc_group) do hosts[part.boss]=#part.boss.cards end
    end
end
F.install()
local count=0
local function check(value,label) assert(value,label);count=count+1 end
for level,units in pairs(legacy) do
    for index,unit in ipairs(units) do check(_sc_pr_table[level][index]==unit,'旧录像的注册索引必须原位保留') end
end
for host,n in pairs(hosts) do check(#host.cards==n,'追加练习分段不污染旧整关卡链或随机池') end
local byId,seen={},{}
for level=29,33 do
    byId[level]={}
    for _,unit in ipairs(_sc_pr_table[level]) do
        local card=unit.sc_group[1].card
        check(not seen[card.card_id],'跨作品历史槽位重复：'..card.card_id)
        seen[card.card_id]=true;byId[level][card.card_id]=unit
    end
end
for _,range in ipairs({{453,460},{470,476}}) do for id=range[1],range[2] do
    check(byId[29][id] and byId[31][33000+id],'冲突作品必须分别注册独立槽位')
    check(byId[31][33000+id].sc_group[1].card.source_card_id==id,'文花帖保留原作来源键')
end end
local catalog=dofile('mod/original_practice.lua')
for level=1,40 do check(catalog.allowed(level)==((level>=29 and level<=33) or level>=35),'练习范围：'..level) end
lstg.var={sc_group={29,1}}
check(catalog.canStart('TH31@BossRush',false),'允许指定原作整关')
check(not catalog.canStart('TH36@BossRush',false),'拒绝范围外整关')
check(catalog.canStart('Spell Practice@Spell Practice',true),'允许原作符卡练习')
lstg.var.sc_group={34,1}
check(not catalog.canStart('Spell Practice@Spell Practice',true),'拒绝范围外符卡')
-- 直接执行真实PracticeStart入口，检查拒绝发生在状态写入前，版本标记先于录像快照。
local group,snapshot={},nil
local state={var={rogue_run='原状态',__original_flow_version='旧标记',sc_group={34,1}}}
local env=setmetatable({stg=group,lstg=state,setting={},GameNet=false,AndroidInput=false,
    GameDrops={VERSION=7},stage={stages={menu={},['TH34@BossRush']={group={title='menu'}},
        ['Spell Practice@Spell Practice']={group={title='menu'}}}}},{__index=_G})
env.dofile=function(path)
    local chunk=assert(loadfile(path));setfenv(chunk,env);return chunk()
end
env.stage.Set=function(mode,name) snapshot={mode=mode,name=name,version=state.var.__original_flow_version,asl=state.var.__th38_version,mhj3=state.var.__th39_version} end
local entryFile=assert(io.open('THlib/ext/ext_stage_group.lua','rb'))
local entrySource=entryFile:read('*a');entryFile:close()
local first=assert(entrySource:find('function stg.PracticeStart(',1,true))
local last=assert(entrySource:find('function stg.FinishStage()',first,true))
local entry=assert(loadstring(entrySource:sub(first,last-1)));setfenv(entry,env);entry()
check(group.PracticeStart('TH06@BossRush',false)==false and not snapshot,'范围外整关不能写入录像')
check(state.var.rogue_run=='原状态' and state.var.__original_flow_version=='旧标记','拒绝练习不得污染当前状态')
check(group.PracticeStart('Spell Practice@Spell Practice',true)==false and not snapshot,'范围外符卡不能绕过入口')
group.PracticeStart('TH34@BossRush',false)
check(snapshot.name=='TH34@BossRush' and snapshot.version==F.VERSION,'整关录像开始前保存流程版本')
state.var.sc_group={32,legacy[32][1].index}
group.PracticeStart('Spell Practice@Spell Practice',true)
check(snapshot.name=='Spell Practice@Spell Practice' and state.var.cheat==true,'允许五作符卡入口及练习无敌')
state.var.sc_group={36,1}
group.PracticeStart('Spell Practice@Spell Practice',true)
check(snapshot.asl==1,'雪莲华来源版本先于录像快照，避免与旧AEX串线')
state.var.sc_group={37,1}
group.PracticeStart('Spell Practice@Spell Practice',true)
check(snapshot.mhj3==1,'永夜篇来源版本先于录像快照，避免与旧AEX串线')
local expected={137,105,85,129,80,121,91,123,90,128,111}
for i,entry in ipairs(catalog.stages) do
    local units=F.units(entry.level)
    check(#units==expected[i],'原作条目覆盖数：'..entry.code)
    for _,row in ipairs(units) do
        check(_sc_pr_table[entry.level][row.index]==row.unit,'显示顺序保留真实注册索引')
        check(not F.hidden[row.unit.sc_group[1].card],'旧整段道中不能重复进入新列表')
    end
end
local function sequence(level,first,ids)
    local units=F.units(level)
    for i,id in ipairs(ids) do
        local card=units[first+i-1].unit.sc_group[1].card
        check(card.source_card_id==id or card.card_id==id,'阶段相邻顺序：'..level..':'..id)
    end
end
sequence(29,1,{3409,470,471,3410,472,474,473,475,476})
sequence(30,1,{4000,3900,3901,4001,3902,3903,3904,3905})
sequence(31,1,{533,536,534,537,535,538})
sequence(32,25,{64005,4474,64006,4430,4431,64007})
sequence(33,1,{65001,3642,3630,65002,3643,3631,3644,3632})
for _,split in ipairs(F.order.splits) do
    local total,last=0,0
    for _,part in ipairs(split.parts) do
        local c=byId[split.level][part.id].sc_group[1].card
        check(part.first==last and part.last>part.first,'道中分段连续且不重叠')
        check(c.t1==part.last-part.first and c.t3==c.t1,'道中分段时限使用原帧数')
        total=total+c.t3;last=part.last
    end
    check(total==byId[split.level][split.source].sc_group[1].card.t3,'道中分段总时长不变')
end
ui={version='test',menu={}}
dofile('THlib/UI/menu.lua')
stage_selects={}
for level=1,40 do stage_selects[level]={id=level,title='旧关卡'} end
local menu={pos=35}
stage_select.fresh(menu)
check(menu.stage_count==11 and menu.pos==11,'关卡练习显示官方五作、幕华祭两作与雪莲华并夹住旧游标')
for i,entry in ipairs(catalog.stages) do check(menu.stage_selects[i].id==entry.level,'关卡入口按五作顺序排列') end
dofile('THlib/UI/menus/scpr_menu.lua')
local spellMenu={}
KeyCodeToName=function() return {} end
sc_pr_menu.TweakCard(spellMenu,false,false)
check(#spellMenu.spells==12 and #spellMenu.spells[12]==748+#TH39.units()+90+128+111,'符卡练习包含官方五作、幕华祭两作、雪莲华和全部')
for tab,entry in ipairs(catalog.stages) do
    local rows=spellMenu.spells[tab]
    for i,row in ipairs(rows) do
        check(row[4]==entry.level and row[1]==F.units(entry.level)[i].index,'练习视图映射真实关卡与索引')
    end
end
-- 执行整关调度器：宿主存活时必须等待，全部阶段及多Boss配对按列表完整出场。
local savedNew,savedValid=New,IsValid
for level=29,33 do
    local actual,actors,chapters,roles={},{},{},{}
    for _,row in ipairs(F.units(level)) do
        for _,part in ipairs(row.unit.sc_group) do chapters[part.card]=row.chapter;roles[part.card]=row.role end
    end
    New=function(cls,cards)
        local o={otherboss={},checks=0}
        actors[#actors+1]=o
        for _,card in ipairs(cards) do
            check(chapters[card]==chapters[cards[1]],'不同面的Boss必须分别创建')
            check(roles[card]==roles[cards[1]] and (roles[card]~='road' or #cards==1),'道中、中Boss和关底分别使用宿主')
            actual[#actual+1]={boss=cls,card=card}
        end
        return o
    end
    IsValid=function(o) o.checks=o.checks+1;return o.checks==1 end
    local runner=coroutine.create(function() F.run(level) end)
    local frames=0
    repeat
        local ok,message=coroutine.resume(runner)
        check(ok,'整关调度不得报错：'..tostring(message))
        frames=frames+1
        assert(frames<100000,'整关调度未结束')
    until coroutine.status(runner)=='dead'
    local expectedParts={}
    for _,row in ipairs(F.units(level)) do
        for _,part in ipairs(row.unit.sc_group) do expectedParts[#expectedParts+1]=part end
    end
    check(#actual==#expectedParts,'整关覆盖所有练习阶段：'..level)
    for i,part in ipairs(expectedParts) do
        check(actual[i].card==part.card and actual[i].boss==part.boss,'整关出场顺序与练习一致：'..level..':'..i)
    end
    for _,actor in ipairs(actors) do check(actor.checks>=2,'整关必须等待宿主退场') end
end
New,IsValid=savedNew,savedValid
-- 执行实际道中生成协程，比较原整段与分段合并后的时间、敌机类型及创建参数。
serialize=function(value,depth)
    if type(value)=='number' then return ('%.17g'):format(value) end
    if type(value)~='table' then return tostring(value) end
    if (depth or 0)>3 then return '<table>' end
    local out={}
    local keys={}
    if value.task or value.ecs then keys={'I0','I1','I2','I3','F0','F1','F2','F3'}
    else for key in pairs(value) do keys[#keys+1]=key end;table.sort(keys,function(a,b) return tostring(a)<tostring(b) end) end
    for _,key in ipairs(keys) do out[#out+1]=tostring(key)..'='..serialize(value[key],(depth or 0)+1) end
    return '{'..table.concat(out,',')..'}'
end
local function capture(level,id)
    local card=byId[level][id].sc_group[1].card
    local owner={_live=true,timer=0,current_card=card}
    events={};tracing=true;tick=0;math.randomseed(20261109)
    card.before(owner);card.init(owner)
    for frame=0,card.t3-1 do
        tick=frame
        if level==32 then task.Do(owner) else
            if frame>0 then _editor_class.TH35.t10_run_tasks(controller) end
        end
    end
    card.del(owner);tracing=false
    local out={}
    for _,event in ipairs(events) do
        if level==32 or event.cls==_editor_class.TH35.th10_midfairy then
            out[#out+1]={tick=event.tick,payload=event.payload}
        end
    end
    return out
end
local cl=_editor_class.TH35
-- 原脚本捕获同一张ran表；每次对照从同一固定随机流起步。
ran.Float=function(_,a,b) return a+(b-a)*math.random() end
ran.Int=function(_,a,b) return math.floor(a+(b-a+1)*math.random()) end
ran.Sign=function() return math.random()<.5 and -1 or 1 end
cl.th10_enemy_schedule.ensure=function() end
cl.th10_enemy_schedule.append=function() end
cl.th10_enemy_schedule.birth=function(o) if o.class==controllerClass then cl.t10_run_tasks(o) end end
cl.t10_fx.ensure=function() end;cl.t10_fx.clear=function() end;cl.t10_fx.fire=function() end
cl.t10_dive.attach=function() end;cl.t10_dive.sync=function() end
controllerClass=cl.th10_ecs_pod
for _,split in ipairs(F.order.splits) do
    local baseline=capture(split.level,split.source)
    local joined={}
    for _,part in ipairs(split.parts) do
        for _,event in ipairs(capture(split.level,part.id)) do
            joined[#joined+1]={tick=part.first+event.tick,payload=event.payload}
        end
    end
    check(#baseline==#joined,'道中分段敌机总数：'..split.source..' '..#baseline..'/'..#joined)
    for i,event in ipairs(baseline) do
        check(event.tick==joined[i].tick and event.payload==joined[i].payload,
            '道中分段创建顺序/时间/参数：'..split.source..' #'..i..' t='..event.tick..'/'..joined[i].tick)
    end
end
print(('原作练习注册、来源、排序与分段检查通过：%d 项。'):format(count))
