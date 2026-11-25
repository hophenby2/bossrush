-- 显式诊断入口：祈华梦资源隔离、横竖屏标题，以及练习页连续点击和滑动。
local T={}
function T.install()
    lstg.AndroidSpriteClipping(true)
    local time=os.time
    os.time=function(value) if value then return time(value) end;return 739 end
    local instances={}
    local create=New
    New=function(cls,...) local o=create(cls,...);instances[cls]=o;return o end
    local titles=dofile('mod/rogue_titles.lua')
    local portrait=os.getenv('BOSSRUSH_MAC_TEST_PORTRAIT')=='1'
    if portrait then
        local windowWidth,windowHeight=setting.resx,setting.resy
        AndroidPortrait=dofile('android/portrait.lua')
        AndroidPortrait.enabled=function() return stage.current_stage and not stage.current_stage.is_menu end
        AndroidPortrait.resetScreen=function()
            if not AndroidPortrait.enabled() then return false end
            screen.width,screen.height=540,960
            screen.scale=windowHeight/960
            setting.resx=540*screen.scale
            screen.dx=(windowWidth-setting.resx)/2;screen.dy=0
            return true
        end
    end
    ext.Debugging=function()end
    AndroidFocus=function()end
    GetInput=function()LoadSaveInputState({})end
    local scene=stage.New('RogueDisplayRegression')
    local env,probes
    local class=Class(object,{render=empty,init=function(o,x)
        o.img='ball_mid1';o.x=x;o.y=0;o.hscale=1;o.vscale=1
        o.a,o.b=3,4;o.bound=false;o.colli=false;o.hide=true
    end},true)
    local cases={'bullets','stage','final','name-center','name-corner','dual'}
    local current=1
    local report={portrait=portrait,cases={}}
    function scene:init()
        lstg.var.score=0
        ResetScreen()
        report.width,report.height=screen.width,screen.height
        local font=FindResFont('title'):calcSize('国')
        report.font_width,report.font_height=font.x*.5,font.y*.5
        ext.notUIdraw=true
        ui.ResourceLoading.state=nil
        ui.ResourceLoading.beforeFrame=function()return false end
        ui.ResourceLoading.afterFrame=function()end
        env=GameContent.ports[39].source
        local host=FindResSprite('ball_mid1'):getSprite():getContentSize()
        local source=FindResSprite('theis/ball_mid1'):getSprite():getContentSize()
        assert(host.width==16 and host.height==16,'祈华梦覆盖了宿主子弹切片')
        assert(source.width==50 and source.height==36,'祈华梦没有使用原作高清切片')
        report.host_bullet,report.source_bullet=host,source
        probes={New(class,-100),New(class,0),New(class,100)}
        plus.CreateDirectory('snapshot')
    end
    function scene:render()
        SetViewMode('ui');RenderClear(Color(255,12,21,36))
        local key=cases[current]
        if key=='bullets' then
            SetViewMode('world')
            -- 左：宿主原图；中、右：原作高清图的显式绘制和对象默认绘制。
            SetImageState('ball_mid1','',Color(255,255,255,255))
            env.SetImageState('ball_mid1','',Color(255,255,255,255))
            Render('ball_mid1',-100,0,0,1,1)
            env.Render('ball_mid1',0,0,0,1,1)
            env.DefaultRenderFunc(probes[3])
            assert(GetImageScale()==1,'祈华梦默认绘制泄漏全局缩放')
            assert(probes[3].hscale==1 and probes[3].a==3 and probes[3].b==4,'显示修复改变了物理缩放或判定')
        elseif key=='stage' or key=='final' then
            titles.stage({text=key=='stage' and 'Stage 1' or 'Final Spell !',stage=key=='stage' and 1 or 6,age=6})
        else
            local run={}
            titles.announce(run,{title='祈华梦1面道中2非'},key=='dual' and {title='梦符「二重结界」'} or nil)
            run.card_title.age=key=='name-corner' and 60 or 6
            titles.render(run)
        end
        SetViewMode('world')
    end
    local frame,started=FrameFunc,false
    local route,center,corner=false,false,false
    local menuPhase,menuAge,action,expected=nil,0,0,nil
    local actions={1,1,-1,-1,1,1,-1,-1}
    function FrameFunc()
        AndroidFocus=function()end
        if IsValid(player) then player.protect=60000 end
        local quit=frame()
        if not started and stage.current_stage.is_menu and stage.current_stage.timer>=90 and GameDebug.title and not GameDebug.title.locked then
            started=true;stage.Set('none','RogueDisplayRegression')
        elseif stage.current_stage==scene then
            local age=scene.timer%40
            if age==20 then
                local name=cases[current]
                Snapshot('snapshot/rogue-display-'..name..'.png')
                report.cases[#report.cases+1]=name
            elseif age==39 then
                current=current+1
                if current>#cases then
                    if portrait then AndroidPortrait.enabled=function() return true end end
                    AndroidInput.preview=true
                    menuPhase='title';stage.Set('none','menu')
                end
            end
        elseif menuPhase then
            menuAge=menuAge+1
            local title=GameDebug.title
            local function ready(cls) local o=instances[cls];return o and IsValid(o) and not o.locked and o.alpha>0 and o end
            if menuPhase=='title' and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=90 and title and not title.locked then
                assert(title.text[1]=='挑战模式','挑战模式不是第一项')
                local chaos=false
                for i,text in ipairs(title.text) do
                    if text=='混沌模式' then chaos=true end
                    if text=='符卡练习' then title.func[i]() end
                end
                assert(chaos,'主菜单没有混沌模式');menuPhase='player';menuAge=0
            elseif menuPhase=='player' and ready(player_system_select) then
                ready(player_system_select):yes();menuPhase='practice';menuAge=0
            elseif menuPhase=='practice' and ready(sc_pr_menu) then
                local o=ready(sc_pr_menu)
                if menuAge%20==10 then
                    if expected then assert(o.diffpos==expected,'练习作品点击/滑动未切换：'..action);expected=nil end
                    action=action+1
                    if action>#actions then
                        Snapshot('snapshot/rogue-display-practice.png')
                        report.practice_actions=#actions
                        local filters=RogueTen.defaultFilters('staged');filters.stages={TH41=true}
                        lstg.var.score=0;lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
                        assert(RogueTen.start('staged',filters),'祈华梦模式2无法开始')
                        menuPhase=nil;route=true
                    else
                        local delta=actions[action]
                        expected=(o.diffpos-1+delta)%#o.difficulty+1
                        local x,y
                        if action<=4 then
                            x=portrait and (delta==1 and 510 or 30) or 480+delta*130
                            y=portrait and screen.height-150 or 450
                            AndroidInput.touch(72,x,y,'began');AndroidInput.touch(72,x,y,'ended')
                        else
                            x,y=screen.width/2,screen.height/2
                            AndroidInput.touch(72,x,y,'began')
                            AndroidInput.touch(72,x-delta*100,y+2,'moved')
                            AndroidInput.touch(72,x-delta*100,y+2,'ended')
                        end
                    end
                end
            end
            assert(menuAge<900,'练习触控检查超时：'..tostring(menuPhase))
        elseif route and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local run=lstg.var.rogue_run
            local a=run.card_title
            if a then
                assert(RogueTen.usesTitleOverlay(),'随机战斗没有启用统一卡名')
                assert(a.names[1]==run.encounter.title,'卡名未取当前卡池条目')
                if a.age==6 then Snapshot('snapshot/rogue-display-battle-center.png');center=true end
                if a.age==60 then Snapshot('snapshot/rogue-display-battle-corner.png');corner=true end
                if a.age==480 then Snapshot('snapshot/rogue-display-battle-bullets.png') end
                if a.age>=500 then
                    assert(center and corner,'实际入场缺少中央或右上角阶段')
                    report.passed=true;report.title=a.names[1]
                    local f=assert(io.open('User/rogue-display.json','wb'));f:write(Serialize(report));f:close()
                    return true
                end
            end
        end
        return quit
    end
end
return T
