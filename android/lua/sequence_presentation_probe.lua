-- 私有诊断：实际暂停绘制、机体选择空副标题、灵击时间轴；只写隔离测试目录。
local T={}
function T.install(mode)
    local kind=assert(mode:match('kind=(%w+)'))
    setting.androidPortrait=not mode:match('landscape=1');AndroidPortrait.configure(setting)
    local key=mode:match('sequence=([%w_]+)') or 'th10_lunatic'
    local machine=mode:match('machine=([%w_]+)') or 'reimua'
    local entry=assert(dofile('mod/sequence_catalog.lua').get(key))
    local started,done,age,action=false,false,0,false
    local rows,shots={},{}
    local frame=FrameFunc
    local originalTime=os.time
    os.time=function(t) return t and originalTime(t) or 20261111 end
    scoredata.PlayerBrand='顺序演出隔离验证';scoredata.version=ui.version
    local function snapshot(name)
        local path='snapshot/presentation-'..name..'.png';os.remove(path);Snapshot(path);shots[#shots+1]=path
    end
    local function finish()
        if done then return end
        for _,path in ipairs(shots) do
            local f=io.open(path,'rb');if not f then return end
            local size=f:seek('end');f:close();if size<100 then return end
        end
        local f=assert(io.open('User/android-presentation-probe.json','wb'));f:write(Serialize({kind=kind,rows=rows,shots=shots}));f:close()
        done=true;lstg.SystemLog('BOSSRUSH_PRESENTATION_DONE: '..mode)
    end
    local function menuWith(title)
        for _,o in ObjList(GROUP.GHOST) do if o.class==main_menu and o.title==title then return o end end
    end
    local function select(menu,keyOrText)
        for i,content in ipairs(menu.content) do
            if content.key==keyOrText or content[1]==keyOrText then menu.func[i]();return end
        end
        error('缺少菜单选项：'..keyOrText)
    end
    local selected,continued
    FrameFunc=function()
        if player and IsValid(player) then player.protect=120 end
        AndroidInput.toggles.shoot=false;AndroidInput.keys[setting.keys.shoot]=false
        local quit=frame()
        if not started and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            started=true;plus.CreateDirectory('snapshot')
            lstg.SystemLog('BOSSRUSH_PRESENTATION_BEGIN: '..mode)
            if kind=='menu' then select(assert(menuWith('')),'顺序模式')
            else assert(OriginalSequence.start(key,machine)) end
        elseif started and not done then
            local scene=stage.current_stage
            if kind=='menu' then
                age=age+1
                if age==35 then select(assert(menuWith('选择原作关卡')),key) end
                if age==70 then selected=assert(menuWith('选择原作机体'));selected.pos=2;snapshot('menu') end
                if age>=80 then finish() end
            elseif scene.stage_name==entry.battle and player and IsValid(player) then
                age=age+1
                local P=SequenceResources;local s=P.state()
                if kind=='bomb' then
                    if age==10 then
                        s.power=100;player.x,player.y=0,-70
                        assert(P.bombInput(player,{spell=true},{},false));action=true
                    end
                    local b=s.bomb
                    if action and b and ({[1]=true,[20]=true,[40]=true,[80]=true,[120]=true,[160]=true,[179]=true})[b.time] then
                        snapshot(machine..'-'..b.time);rows[#rows+1]={time=b.time,script=player.original_bomb_vms[1].id}
                    end
                    if age>=210 then assert(action and s.bomb==nil,'灵击未按时结束');finish() end
                elseif kind=='continue' then
                    if age==90 then s.lives=-1;player.original_respawn=nil;player.death=0 end
                    local menu=scene.sequence_continue
                    if menu and menu.time==40 then snapshot('continue');rows[#rows+1]={time=menu.time,yes=menu.yes} end
                    if menu and menu.time==60 and not action then
                        assert(AndroidInput.menuMode(),'续关必须关闭自动射击/移动触控')
                        local x,y
                        if AndroidPortrait.enabled() then local w=lstg.world;x,y=(w.scrl+w.scrr)/2,(w.scrb+w.scrt)/2+25
                        else x,y=350,245 end
                        AndroidInput.touch(927,x,y,'began');AndroidInput.touch(927,x,y,'ended');action=true
                    end
                    if action and not menu and not continued then
                        assert(s.continues==1 and s.lives==2,'触控未从原生面板完成续关')
                        rows[#rows+1]={continues=s.continues,lives=s.lives};snapshot('continued');continued=true
                    end
                    if continued then finish() end
                    assert(age<280,'续关面板未响应')
                end
            end
        end
        return quit
    end
end
return T
