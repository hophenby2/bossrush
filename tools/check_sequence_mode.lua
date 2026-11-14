-- 检查顺序模式的稳定key、原作路线互斥、难度变体、初态和录像范围。
local f=assert(io.open('tools/sequence_registry.lua','rb'));local setup=f:read('*a');f:close()
setup=setup:sub(1,assert(setup:find('for _,id in ipairs({3400',1,true))-1)
assert(loadstring(setup))()
local C=dofile('mod/sequence_catalog.lua')
local checks=0
local function check(v,why) assert(v,why);checks=checks+1 end
local function ids(chapters)
    local out={}
    for _,chapter in ipairs(chapters) do for _,r in ipairs(chapter.units) do
        local card=r.unit.sc_group[1].card;out[card.source_card_id or card.card_id]=chapter.name
    end end
    return out
end
check(#C.entries==28,'栖霞园 L 和 Extra 使用独立入口')
local continued=C.chapterForRun(C.get('th08_lunatic_b'),{name='6B'},'reimu_player',1)
check(continued.name=='6A' and #continued.units>0,'永夜抄在前五面续关后转入Final A')
for _,e in ipairs(C.entries) do
    check(C.get(e.key)==e,'用key查询入口，不依赖菜单选项编号')
    for _,player in ipairs({'reimu_player','marisa_player'}) do
        local chapters=C.chapters(e.key,player)
        local count=e.level==40 and 10 or e.difficulty=='lunatic' and 6 or e.difficulty=='scenes' and 10 or 1
        check(#chapters==count,'每个入口的原作面数：'..e.key)
        for _,chapter in ipairs(chapters) do
            check(#chapter.units>0,'每一面都有保留内容')
            for _,row in ipairs(chapter.units) do
                check(row.chapter~='Last Word','Last Word不能混入原作整关路线')
                if e.native=='thbdb' then
                    local extra=e.difficulty=='extra'
                    check(row.difficulty==(extra and 5 or 4) and row.id>=81001 and row.id<88000,'栖霞园关卡使用独立编号和正确难度')
                end
            end
        end
        if e.level==29 and e.difficulty=='lunatic' then
            local a=ids(chapters)
            check(a[3409]=='1' and a[3438]==nil,'永夜抄Lunatic不混入Extra')
            check((a[3412]~=nil)==(player=='marisa_player'),'永夜抄四面按原作自机路线选择灵梦/魔理沙')
            check((a[3430]~=nil)==(e.ending=='6A') and (a[3431]~=nil)==(e.ending=='6B'),'Final A/B不能连打或串线')
        elseif e.level==30 and e.difficulty=='lunatic' then
            for _,row in ipairs(chapters[4].units) do
                if row.role=='boss' then
                    check(row.unit.sc_group[1].card.th06_source.group==(player=='marisa_player' and 16 or 9),'帕秋莉只进行所选自机的一条原作符卡路线')
                end
            end
        elseif e.level==32 and e.difficulty=='lunatic' then
            local a=ids(chapters)
            for _,id in ipairs({4457,4470,4468,4471,4439,4472,4473,4475,4476,4408}) do
                check(not a[id],'Lunatic不能混入Normal/Hard符卡：'..id)
            end
            check(a[4441] and a[4447] and a[4448],'骚灵合奏阶段共用，不随单独姐姐路线漏掉')
            check((a[4440]~=nil)==(player=='reimu_player') and (a[4444]~=nil)==(player=='marisa_player'),'骚灵单独阶段按所选自机选姐姐')
        elseif e.level==33 and e.difficulty=='lunatic' then
            local order={}
            for i,row in ipairs(chapters[4].units) do order[row.unit.sc_group[1].card.card_id]=i end
            check(order[3607]<order[3608],'文文L行Boss3→BossCard3→BossCard4，不走Easy的直接BossCard4分支')
        end
    end
end
-- 真实注册流程建立各入口；这里仅模拟stage容器，战斗逻辑另对原始时间轴逐帧核对。
stage={groups={},stages={menu={}},group={}}
stage.group.New=function(title,_,name) local g={_name=name,title=title};stage.groups[name]=g;return g end
stage.group.AddStage=function(name,title)
    local g=stage.groups[name];g[1]=title;local b={name=title,group=g};stage.stages[title]=b;return b
end
CopyImage=function() end
local P=dofile('THlib/native_players.lua')
local S=dofile('mod/original_sequence.lua')
for _,e in ipairs(C.entries) do
    check(stage.groups[e.group].sequence_key==e.key and stage.stages[e.battle].level==e.level,'独立关卡保留实际来源level')
end
local source=assert(io.open('THlib/ext/ext_stage_group.lua','rb')):read('*a'):gsub('\r\n','\n')
local start=assert(source:match('(function stg.Start%b()%s*\n.-\nend)'))
local snapshots={}
local vars={rogue_run={old=true},current_system=''}
local environment=setmetatable({stg=stage.group,lstg={var=vars},setting={},GameDrops={VERSION=8},
    GameNet=false,AndroidInput=false,stage={stages={menu={}},Set=function(mode,name)
        snapshots[#snapshots+1]={version=vars.__sequence_version,key=vars.sequence_key,scale=vars.__hp_scale_version,name=name,native=vars.__native_player_version,machine=vars.native_player_id}
    end}},{__index=_G})
local chunk=assert(loadstring(start));setfenv(chunk,environment);chunk()
-- 入口和Start使用同一份var，版本和key必须在录像快照之前写入。
lstg.var=vars;stage.group.Start=environment.stg.Start;StopMusic=function() end
for _,e in ipairs(C.entries) do
    S.start(e.key)
    local saved=snapshots[#snapshots]
    check(saved.version==1 and saved.key==e.key and saved.name==e.battle,'顺序版本与路线先于录像快照')
    check(saved.scale==nil and vars.rogue_run==nil,'顺序模式不继承随机局血量倍率')
    check(e.native and saved.native==P.VERSION and saved.machine==P.machines(e.level)[1].id or not e.native and saved.native==nil,'机体版本写入录像初态')
end
DeSerialize=function(v) return v end
local content=dofile('mod/content.lua')
for _,e in ipairs(C.entries) do
    local legacy={stageName=e.battle,stageExtendInfo={__sequence_version=1,sequence_key=e.key,
        sequence_player=e.native and e.level<38 and 'reimu' or nil,current_system=''}}
    check(content.supportsRecord(legacy)==(e.native~='thbdb'),'旧顺序录像按来源版本放行')
    check(not content.supportsRecord{stageName=e.battle,stageExtendInfo={__sequence_version=1,sequence_key='错误路线'}},'录像路线不匹配时拒绝串线')
    if e.native then
        for _,machine in ipairs(P.machines(e.level)) do
            local v={__sequence_version=1,sequence_key=e.key,sequence_player=machine.id,
                __native_player_version=P.VERSION,native_player_level=e.level,native_player_id=machine.id,
                __th43_version=e.native=='thbdb' and 1 or nil}
            local record={stageName=e.battle,stageExtendInfo=v}
            check(content.supportsRecord(record),'可播放各原作机体的录像')
            v.native_player_level=0
            check(not content.supportsRecord(record),'拒绝机体来源错误的录像')
        end
    end
end
S.start('likedreamer_nightmare','cool',{1,1,1,3,1,1})
check(vars.like_dreamer_loadout[4]==3 and vars.like_dreamer_loadout[5]==1 and vars.native_player_id=='cool',
    'Like Dreamer 装备随自机写入顺序模式录像初态')
S.start('th07_lunatic')
check(vars.like_dreamer_loadout==nil,'离开 Like Dreamer 清理装备选择')
stage.current_stage={group={_name='Sequence_th07_lunatic'},timer=0}
vars.ran_seed=12345
local D=dofile('THlib/drops.lua');D.reset()
local b={is_combat=true,current_card={is_combat=true},hp=0}
check(not D.award(b,false) and vars.upgrades.count==0 and #vars.upgrades.queue==0,'击破不掉强化，不建立待选项')
b.timeout=true
check(not D.award(b,true) and vars.upgrades.count==0,'超时也不掉强化')
local power,recharge,hitbox=D.values(1)
check(power==100 and recharge==100 and hitbox==100,'初始属性保持中性')
check(D.bombsEnabled() and D.bombState(1)==3,'取消强化保留Bomb库存与控制')
local H=dofile('THlib/rogue_hp.lua')
local maximum,current=H.health({},200,150)
check(not H.enabled() and H.factor()==1 and maximum==200 and current==150,'当前模式不改变原作标定血量')
local drawn=0;ui=ui or {};ui.RenderText=function() drawn=drawn+1 end
ui.RunHUD=dofile('THlib/UI/run_hud.lua')
ui.RunHUD.attributes(720,500,255)
check(drawn==0,'顺序模式不显示强化属性面板')
print('顺序入口、难度/路线互斥、初态与录像检查通过：'..checks)
