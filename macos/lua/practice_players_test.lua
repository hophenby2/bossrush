-- 经实际标题/练习/机体菜单进入战斗，核对一次选择、两类自机及跨模式重进。
local T={}
function T.install()
    ext.Debugging=function()end;AndroidFocus=function()end;SaveSpellCardData=function()end
    local portrait=os.getenv('BOSSRUSH_MAC_TEST_PORTRAIT')=='1'
    if portrait then
        local width,height=setting.resx,setting.resy
        local P=dofile('android/portrait.lua');AndroidPortrait=P
        P.enabled=function()return true end;P.configure=function()end
        P.resetScreen=function()
            screen.width,screen.height,screen.scale=540,960,height/960
            setting.resx=540*screen.scale;screen.dx=(width-setting.resx)/2;screen.dy=0
            ResetWorld();ResetWorldOffset();P.layoutWorld();return true
        end
        local configure=loadConfigure
        loadConfigure=function()configure();setting.resx=540*height/960 end
    end
    local cases={{level=35,key='project:marisa_player'},{level=35,key='original:reimu'},
        {level=30,key='original:reimua'},{level=35,key='project:reimu_player',chapter=true},
        {level=35,key='original:sanae',chapter=true},{level=30,key='original:marisab',chapter=true},
        {level=39,key='project:marisa_player'},{level=39,key='project:reimu_player',chapter=true},
        {level=40,key='original:dream'}}
    local instances,results={},{}
    local new=New
    New=function(cls,...)local o=new(cls,...);instances[cls]=o;return o end
    local function ready(cls)local o=instances[cls];return o and IsValid(o) and not o.locked and o.alpha>0 and o end
    local function choose(o,key)
        for i,row in ipairs(o.content)do if row.key==key or row[1]==key then o.pos=i;o.func[i]();return end end
        error('练习菜单缺少 '..key)
    end
    GetInput=function()LoadSaveInputState(stage.current_stage and not stage.current_stage.is_menu and {shoot=true} or {})end
    local index,phase,age=1,0,0
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=6000 end
        for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=b.maxhp end end
        local quit=frame();age=age+1
        local c=cases[index];local scene=stage.current_stage
        local title=GameDebug.title
        local function step(n)phase=n;age=0 end
        if phase==0 and scene.is_menu and scene.timer>90 and title and not title.locked then
            if portrait then ResetScreen() end
            choose(title,c.chapter and '关卡练习' or '符卡练习');step(1)
        elseif phase==1 then
            assert(not ready(player_system_select),'练习仍先打开了无效的第一层机体选择')
            if c.chapter and ready(stage_select)then
                local o=ready(stage_select)
                for i,row in ipairs(o.stage_selects)do if row.id==c.level then o.pos=i;o.choose_func(i);step(2);break end end
            elseif not c.chapter and ready(sc_pr_menu)then
                local o=ready(sc_pr_menu);o.onlyshowcard,o.onlyshowspecialcard=c.level~=40,false
                sc_pr_menu.TweakCard(o,o.onlyshowcard,false)
                for tab,work in ipairs(dofile('mod/original_practice.lua').stages)do if work.level==c.level then o.diffpos=tab end end
                o.spell=o.spells[o.diffpos];o.pos=1
                if c.level==40 then for i,row in ipairs(o.spell)do
                    local card=_sc_pr_table[row[4]][row[1]].sc_group[1].card
                    if card.port_source and card.port_source.phase then o.pos=i;break end
                end end
                assert(#o.spell>0,'机体菜单测试误用了空筛选列表')
                o:yes();step(3)
            end
        elseif phase==2 and ready(main_menu) and ready(main_menu)~=title then
            local o=ready(main_menu);choose(o,o.content[1].key);step(3)
        elseif phase==3 and ready(main_menu) and ready(main_menu)~=title then
            local o=ready(main_menu);local project,original=0,0
            for _,row in ipairs(o.content)do
                if row.key and row.key:match('^project:')then project=project+1 end
                if row.key and row.key:match('^original:')then original=original+1 end
            end
            assert(project==#player_list and original>0,'两类机体未列入同一列表')
            if c.level==30 or c.level==40 then
                plus.CreateDirectory('snapshot');Snapshot('snapshot/practice-players-'..index..'.png')
            end
            choose(o,c.key);step(c.level==40 and 4 or 5)
        elseif phase==4 and ready(main_menu) and ready(main_menu)~=title then choose(ready(main_menu),'开始');step(5)
        elseif phase==5 and not scene.is_menu and scene.timer>180 then
            assert(lstg.var.practice_player==c.key,'机体选择被覆盖')
            assert(IsValid(player),'没有创建自机')
            if c.key:match('^project:')then
                assert(not NativePlayers.enabled() and not SequenceResources.enabled(),'项目机体被原作系统覆盖')
                assert(player.class==_G[c.key:sub(9)],'创建的不是所选项目机体')
            elseif SequenceResources.gameByLevel[c.level]then
                assert(SequenceResources.enabled() and player.original_game==6,'原作机体未走原始射击桥')
                assert(player.original_machine.id==c.key:sub(10),'原作A/B机型不一致')
            else assert(NativePlayers.enabled() and player.native_level==c.level,'原作机体未生效') end
            if c.chapter then assert(lstg.var.sequence_run.total==1,'关卡练习进入了整条路线') end
            results[#results+1]={level=c.level,key=c.key,chapter=c.chapter==true}
            stage.group.ReturnToTitle(false,0);index=index+1;step(0)
            if index>#cases then
                local f=assert(io.open('User/practice-players.json','wb'));f:write(Serialize({passed=true,portrait=portrait,cases=results}));f:close()
                lstg.SystemLog('PRACTICE_PLAYERS_PASS');return true
            end
        end
        assert(age<900,'练习机体测试停在 '..index..'/'..phase)
        return quit
    end
end
return T
