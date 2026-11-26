-- 实际菜单回归：新存档启动、关卡/符卡练习往返、选择恢复与隐藏菜单下的调试口令。
local T={}
function T.install()
    assert(setting.username=='AAAA' and scoredata.PlayerBrand=='AAAA','默认用户名未统一')
    local restored=os.getenv('BOSSRUSH_MAC_TEST_RESTORE')=='1'
    if restored then
        assert(scoredata.practice_chapters['36']=='thasl_lunatic:4' and scoredata.practice_machines['36']=='original:marisa_b','关卡或机体没有跨进程保存')
        assert(scoredata.menu_sc_pr.level==36 and scoredata.menu_sc_pr.card_id==38010 and scoredata.onlyshowcard,'符卡选项没有跨进程保存')
    end
    local instances,notices={},0
    local create=New
    function New(cls,...)
        local o=create(cls,...);instances[cls]=o
        if cls==SimpleNotice then notices=notices+1 end
        return o
    end
    local function ready(cls)
        local o=instances[cls]
        return o and IsValid(o) and not o.locked and o.alpha>0 and o
    end
    local function choose(o,key)
        for i,row in ipairs(o.content) do if row.key==key or row[1]==key then o.pos=i;o.func[i]();return end end
        error('缺少菜单选项：'..key)
    end
    local frame=FrameFunc
    local phase,age,card,inject,held=0,0,nil,false,false
    local getState,getLast=GetKeyState,GetLastKey
    function GetKeyState(key) if inject and key==KEY['8'] then return held end;return getState(key) end
    function GetLastKey() if inject then return held and KEY['8'] or KEY.NULL end;return getLast() end
    function FrameFunc()
        if inject then held=age%4==0 end
        local quit=frame();age=age+1
        local scene=stage.current_stage
        local title=GameDebug.title
        local atTitle=scene and scene.stage_name=='menu' and scene.timer>=90 and title and not title.locked
        local function nextPhase(n) phase=n;age=0 end
        if phase==0 and atTitle then
            assert(GameDebug.enabled and notices==0,'默认调试或公告开关错误')
            choose(title,'关卡练习');nextPhase(1)
        elseif phase==1 and ready(stage_select) then
            nextPhase(2)
        elseif phase==2 and ready(stage_select) then
            local o=ready(stage_select)
            for i,row in ipairs(o.stage_selects) do if row.id==36 then o.pos=i;o.choose_func(i);nextPhase(3);break end end
        elseif phase==3 and ready(main_menu) and ready(main_menu)~=title then
            choose(ready(main_menu),'thasl_lunatic:4');nextPhase(4)
        elseif phase==4 and ready(main_menu) then
            choose(ready(main_menu),'original:marisa_b');nextPhase(5)
        elseif phase==5 and scene.group and scene.group.sequence_key=='thasl_lunatic' and scene.timer>=30 then
            assert(lstg.var.is_practice and lstg.var.sequence_run.total==1 and lstg.var.sequence_run.chapter_name=='4','关卡练习未只进入四面')
            stage.group.ReturnToTitle(false,0);nextPhase(6)
        elseif phase==6 and atTitle then choose(title,'关卡练习');nextPhase(7)
        elseif phase==7 and ready(stage_select) then nextPhase(8)
        elseif phase==8 and ready(stage_select) then
            local o=ready(stage_select);assert(o.stage_selects[o.pos].id==36,'作品位置未恢复')
            o.choose_func(o.pos);nextPhase(9)
        elseif phase==9 and ready(main_menu) and ready(main_menu)~=title then
            local o=ready(main_menu);assert(o.content[o.pos].key=='thasl_lunatic:4','章节位置未恢复')
            o.func[o.pos]();nextPhase(10)
        elseif phase==10 and ready(main_menu) then
            local o=ready(main_menu);assert(o.content[o.pos].key=='original:marisa_b','原作机体未恢复')
            stage.Set('none','menu');nextPhase(11)
        elseif phase==11 and atTitle then choose(title,'符卡练习');nextPhase(12)
        elseif phase==12 and ready(sc_pr_menu) then nextPhase(13)
        elseif phase==13 and ready(sc_pr_menu) then
            local o=ready(sc_pr_menu);o.onlyshowcard,o.onlyshowspecialcard=true,false
            sc_pr_menu.TweakCard(o,true,false);o.diffpos=7;o.spell=o.spells[7];o.pos=5
            local row=o.spell[5];card=_sc_pr_table[row[4]][row[1]].sc_group[1].card.card_id
            o:yes();nextPhase(14)
        elseif phase==14 and ready(main_menu) then choose(ready(main_menu),'original:marisa_b');nextPhase(15)
        elseif phase==15 and scene.stage_name=='Spell Practice@Spell Practice' and scene.timer>=30 then
            stage.group.ReturnToTitle(false,0);nextPhase(16)
        elseif phase==16 and atTitle then choose(title,'符卡练习');nextPhase(17)
        elseif phase==17 and ready(sc_pr_menu) then nextPhase(18)
        elseif phase==18 and ready(sc_pr_menu) then
            local o=ready(sc_pr_menu);local row=o.spell[o.pos]
            assert(o.diffpos==7 and o.onlyshowcard and _sc_pr_table[row[4]][row[1]].sc_group[1].card.card_id==card,'符卡页签、过滤器或卡号未恢复')
            o.exit_func();nextPhase(19)
        elseif phase==19 and atTitle then nextPhase(20)
        elseif phase==20 and atTitle then
            New(main_menu,'隐藏子菜单',{{'返回',function() end,'Back'}})
            GameDebug.enabled=false;inject=true;nextPhase(21)
        elseif phase==21 then
            assert(age<80,'回到标题后 88888 未生效')
            if GameDebug.enabled then
                local f=assert(io.open('User/mac-test.json','wb'))
                f:write(Serialize({passed=true,mode='practice-options',name=scoredata.PlayerBrand,chapter='4',card=card,debug_reentry=true,notices=notices,restored=restored}));f:close()
                lstg.SystemLog('BOSSRUSH_MAC_TEST: practice-options 通过');return true
            end
        end
        if age>600 then error('菜单回归停在步骤 '..phase) end
        return quit
    end
end
return T
