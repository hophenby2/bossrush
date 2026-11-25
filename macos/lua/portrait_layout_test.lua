-- 仅在显式诊断入口运行：真实设置菜单触控、四控件拖动、保存/取消和实际战斗绘制。
local T={}
function T.install()
    local instances={}
    local new=New
    New=function(cls,...)local o=new(cls,...);instances[cls]=o;return o end
    local windowWidth,windowHeight=setting.resx,setting.resy
    AndroidPortrait=dofile('android/portrait.lua')
    local P,I=AndroidPortrait,AndroidInput
    local virtualWidth=windowHeight*540/960
    P.enabled=function()return true end
    P.configure=function()end
    P.resetScreen=function()
        screen.width,screen.height=540,960;screen.scale=windowHeight/960
        setting.resx=virtualWidth;screen.dx=(windowWidth-virtualWidth)/2;screen.dy=0
        ResetWorld();ResetWorldOffset();P.layoutWorld();return true
    end
    local configure=loadConfigure
    loadConfigure=function()configure();setting.resx=virtualWidth end
    I.preview=true
    AndroidFocus=function()end;ext.Debugging=function()end
    local draw=P.drawSlowButton
    P.drawSlowButton=function(...)assert(not I.loading(),'加载界面仍绘制触控按钮');return draw(...)end
    local frame=FrameFunc
    local phase,age='boot',0
    local initial,expected={},{}
    local report={}
    local function tap(x,y)
        I.touch('layout-test',x,y,'began');I.touch('layout-test',x,y,'ended')
    end
    local function ready()local o=instances[game_setting];return o and not o.locked and o.alpha==1 and o end
    local function snapshot(name)Snapshot('snapshot/portrait-layout-'..name..'.png')end
    function FrameFunc()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local result=frame();age=age+1
        if phase=='boot' then
            local title=GameDebug.title
            if title and not title.locked and stage.current_stage.timer>90 then
                plus.CreateDirectory('snapshot');ResetScreen()
                for i,label in ipairs(title.text)do if label=='其他设置'then title.func[i]() end end
                phase,age='settings',0
            end
        elseif phase=='settings' and ready()then
            if age==45 then tap(80,screen.height-160-5.5*64)
            elseif age==60 then
                assert(ready().menus[ready().pos1].display_name=='触控','未进入触控设置')
                snapshot('settings');tap(340,screen.height-160-4.5*50)
            elseif age==75 then
                assert(P.editor,'设置选项未打开布局编辑器');snapshot('default')
                report.entry=true
            elseif age>=80 and age<=110 and age%10==0 then
                local id=({'slow','bomb','life','bombs'})[(age-80)/10+1]
                local x,y=P.elementPosition(id,P.editor.draft);initial[id]={x,y};expected[id]={x+140,y+30}
                I.touch(id,x+2,y+1,'began');I.touch(id,x+142,y+31,'moved');I.touch(id,x+142,y+31,'ended')
            elseif age==125 then
                for id,pos in pairs(expected)do local x,y=P.elementPosition(id,P.editor.draft);assert(math.abs(x-pos[1])<.01 and math.abs(y-pos[2])<.01,'实际拖动位置错误：'..id)end
                snapshot('dragged');tap(436,55)
            elseif age==140 then
                assert(not P.editor,'保存未关闭编辑页');loadConfigure()
                for id,pos in pairs(expected)do local x,y=P.elementPosition(id);assert(math.abs(x-pos[1])<.01 and math.abs(y-pos[2])<.01,'保存/重读配置未应用：'..id)end
                report.saved=setting.androidPortraitLayout
                tap(340,screen.height-160-4.5*50)
            elseif age==155 then assert(P.editor,'未重新打开编辑页');tap(270,55)
            elseif age==165 then
                local x,y=P.elementPosition('slow',P.editor.draft);assert(x==initial.slow[1] and y==initial.slow[2],'恢复默认未更新草稿');tap(104,55)
            elseif age==180 then
                assert(not P.editor,'取消未关闭编辑页')
                local x,y=P.elementPosition('slow');assert(math.abs(x-expected.slow[1])<.01 and math.abs(y-expected.slow[2])<.01,'取消覆盖了已保存的布局')
                report.cancel=true;ready().exit_func();phase,age='route',0
            end
        elseif phase=='route' and age==60 then
            local filters=RogueTen.defaultFilters('staged');filters.stages={TH35=true}
            lstg.var.score=0;lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters));phase,age='battle',0
        elseif phase=='battle' then
            if ui.ResourceLoading.state and not report.loading then
                assert(I.loading(),'加载状态未屏蔽按钮');snapshot('loading');report.loading=true
            end
            local run=lstg.var.rogue_run
            if run and run.card_title and run.card_title.age>=90 then
                snapshot('battle')
                for id,pos in pairs(expected)do local x,y=P.elementPosition(id);assert(math.abs(x-pos[1])<.01 and math.abs(y-pos[2])<.01,'战斗位置与设置预览不同：'..id)end
                report.battle=true;report.passed=true
                local f=assert(io.open('User/portrait-layout.json','wb'));f:write(Serialize(report));f:close()
                return true
            end
        end
        assert(age<1200,'竖屏布局原生检查超时：'..phase)
        return result
    end
end
return T
