-- 在独立发行目录记录真实字体、掉落文字和Bomb扇形；不接触玩家存档。
local checked=false
local coop=false
local drawHUD=ui.RunHUD.draw
ui.RunHUD.draw=function(...)
    local net=GameNet
    if coop then GameNet={host=function() return true end} end
    local ok,err=pcall(drawHUD,...);GameNet=net
    if not ok then error(err,0) end
end
-- 只借用正式触控绘制函数，所有输入包装都限制在私有环境中。
local env={lstg={GetKeyState=function() return false end,GetLastKey=function() return 0 end},
    require=function() return setmetatable({},{__index=function(_,key) return key:byte() end}) end}
env._G=env;setmetatable(env,{__index=_G})
local chunk=assert(loadfile('native_android_input.lua'));setfenv(chunk,env)
local mobile=chunk()
local endScene=EndScene
local menuCaptured,resultCaptured,zeroCaptured=false,false,false
EndScene=function()
    local preview=not menuCaptured and lstg.var.rogue_run
    if preview then
        SetViewMode('ui');RenderClear(Color(255,12,21,36))
        local options=RogueTen.defaultFilters();options.cards.survival=false
        local o={alpha=1,pool_focus=9,pool_options=options,pool_status=RogueTen.poolStatus(options),pool_notice_time=0,keyname=KeyCodeToName()}
        dofile('THlib/UI/rogue_pool.lua').render(o)
    elseif coop then mobile.render() end
    local result=endScene()
    if preview then Snapshot('snapshot/hud-time-filter.png');menuCaptured=true end
    local scene=stage.current_stage
    if scene and scene.stage_name==RogueTen.RESULT and not resultCaptured and scene.timer>=45 then
        assert(not GameRevive.active() and lstg.var.__revive_version==0,'耗尽生命不能进入答题')
        Snapshot('snapshot/hud-result.png');resultCaptured=true
        local f=assert(io.open('hud-death-result.json','w'))
        f:write(Serialize({revive=lstg.var.__revive_version,dead=lstg.var.dead,current=lstg.var.rogue_run.current,finished=lstg.var.rogue_run.finished,quiz=GameRevive.active()}));f:close()
    elseif lstg.var.dead==10 and not zeroCaptured and scene and scene.stage_name==RogueTen.BATTLE then
        Snapshot('snapshot/hud-zero-life.png');zeroCaptured=true
    end
    return result
end
return function(host,frames,current)
    if not checked then
        RogueTen.MISS_LIMIT=10 -- 通用弹幕测试放宽了失误上限；此处恢复正式生命规则。
        assert(GameDrops.VERSION==5 and lstg.var.__drops_version==5,'新局必须采用九枚库存版本')
        assert(lstg.var.__revive_version==0 and not GameRevive.enabled(),'新局禁用答题复活')
        local noTime=RogueTen.defaultFilters();noTime.cards.survival=false
        local filtered,total=RogueTen.buildPool(noTime)
        local all,allCount=RogueTen.buildPool();local timed={}
        for _,bucket in ipairs(all) do for _,e in ipairs(bucket.cards) do
            if e.survival then timed[#timed+1]={id=e.cardId,source=e.source} end
        end end
        local f=assert(io.open('hud-time-filter.json','w'));f:write(Serialize({all=allCount,filtered=total,timed=timed}));f:close()
        assert(total==395,'真实引擎时符筛选必须与注册回归一致：'..total)
        for _,bucket in ipairs(filtered) do for _,e in ipairs(bucket.cards) do assert(not e.survival,'不能漏入时符') end end
        assert(GameDrops.bombState(1)==3,'新局初始持有三枚')
        local image={GetImageTextureRegion('star_big10')}
        assert(image[1]=='v310_bullet2' and image[2]==224 and image[3]==128,'核对绿色大星图集')
        checked=true
    end
    if frames==300 then
        coop=current.cardId==3604
        lstg.var.rogue_run.current=42;lstg.var.dead=2
        local parts={[3601]=.25,[3602]=.5,[3603]=.75,[3604]=.99}
        local p=lstg.var.upgrades.players[1]
        p.red,p.blue,p.green=13500,17500,7500
        p.bombs,p.bomb_fraction=3,assert(parts[current.cardId])*GameDrops.BOMB_FRAMES*10000
        local p2=lstg.var.upgrades.players[2]
        p2.red,p2.blue,p2.green,p2.bombs,p2.bomb_fraction=11500,14000,8500,2,.5*GameDrops.BOMB_FRAMES*10000
        local row={age=38,duration=120,linear=true,colorMask=true}
        GameQuiz.selection('hud-verification',row,nil,{GameDrops.optionLines(8),GameDrops.optionLines(3),GameDrops.optionLines(11)})
        current.hud_progress=parts[current.cardId]
        local f=assert(io.open('hud-progress.jsonl','a'))
        f:write(Serialize({id=current.cardId,progress=current.hud_progress,bombs=GameDrops.bombState(1)}),'\n');f:close()
    elseif frames==900 then
        local p=lstg.var.upgrades.players[1];p.bombs,p.bomb_fraction=9,0
        if current.cardId==3604 then
            p.red,p.blue,p.green=100000,100000,2500
            GameRank.state().units=GameRank.MAX*GameRank.UNITS
        end
        GameQuiz.clearSelection('hud-verification',true)
    end
end
