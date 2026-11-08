-- Windows真引擎：五种HP实现、倍率动画、折叠菜单和无答题结算；仅写独立验证目录。
local checked,menusCaptured,resultCaptured=false,false,false
local pending,captured=nil,{}
local function growth() return lstg.var.rogue_run and lstg.var.rogue_run.hp_growth end
local function near(a,b) return math.abs(a-b)<1e-7*math.max(1,math.abs(b)) end
function HUDNeedRender()
    local s=growth();if not s then return false end
    RogueTen.MISS_LIMIT=10
    local a=s.animation
    if a then for _,point in ipairs({1,12,30}) do
        local name=('hp-stage-%02d-age-%02d'):format(a.stage,point)
        if a.age>=point and not captured[name] then pending=name;captured[name]=true;return true end
    end end
    local name=('hp-stage-%02d-settled'):format(s.shown_stage)
    if s.shown_stage>0 and not captured[name] then pending=name;captured[name]=true;return true end
    return false
end
local env={lstg={GetKeyState=function() return false end,GetLastKey=function() return 0 end},
    require=function() return setmetatable({},{__index=function(_,key) return key:byte() end}) end}
env._G=env;setmetatable(env,{__index=_G})
local chunk=assert(loadfile('native_android_input.lua'));setfenv(chunk,env);local mobile=chunk()
local endScene=EndScene
EndScene=function()
    if growth() then mobile.render() end
    local result=endScene()
    if pending then
        Snapshot('snapshot/'..pending..'.png')
        local s=growth();local f=assert(io.open('hp-animation.jsonl','a'))
        f:write(Serialize({snapshot=pending,total=s.total,shown=s.shown,shown_stage=s.shown_stage,animation=s.animation}),'\n');f:close();pending=nil
    end
    if growth() and not menusCaptured then
        local U=dofile('THlib/UI/rogue_pool.lua')
        local o={alpha=1,keyname=KeyCodeToName()};U.fresh(o,'roguelike')
        assert(not o.pool_expanded and o.pool_status.count==351 and not o.pool_options.cards.survival and not o.pool_options.encounters.road,'新默认筛选必须生效')
        for _,name in ipairs({'hp-menu-collapsed','hp-menu-expanded'}) do
            BeginScene();SetViewMode('ui');RenderClear(Color(255,12,21,36));U.render(o);endScene();Snapshot('snapshot/'..name..'.png');U.expand(o)
        end
        menusCaptured=true
    end
    local scene=stage.current_stage
    if scene and scene.stage_name==RogueTen.RESULT and not resultCaptured and scene.timer>=45 then
        assert(not GameRevive.active() and not GameRank.enabled(),'新局不能启用答题或Rank')
        Snapshot('snapshot/hud-result.png');resultCaptured=true
        local f=assert(io.open('hud-death-result.json','w'))
        f:write(Serialize({rank=lstg.var.__rank_version,revive=lstg.var.__revive_version,dead=lstg.var.dead,current=lstg.var.rogue_run.current,finished=true,quiz=GameRevive.active()}));f:close()
        BeginScene();SetViewMode('ui');RenderClear(Color(255,12,21,36))
        for i,index in ipairs({9,19,29,39,49,50}) do
            ui:RenderText('title',('×%.2f'):format(1+index/100),160+(i-1)*128,270,2,Color(255,GameHPScale.rgb(index)),'centerpoint')
        end
        endScene();Snapshot('snapshot/hp-colors.png')
    end
    return result
end
return function(host,frames,current)
    if not checked then
        assert(GameHPScale.enabled() and not GameRank.enabled() and lstg.var.__rank_version==0,'新局只启用阶段HP倍率')
        assert(lstg.var.__revive_version==0 and not GameRevive.enabled(),'禁用答题复活')
        local f=RogueTen.defaultFilters();local all,n=RogueTen.buildPool(f)
        assert(n==351 and f.cards.nonspell and f.cards.spell and not f.cards.survival and not f.encounters.road,'默认四作非符/符卡池')
        for _,b in ipairs(all) do for _,e in ipairs(b.cards) do assert(not e.survival and e.kind=='boss','不能混入道中或时符') end end
        checked=true
    end
    if frames==1 or frames==120 then
        local s=growth();local card=host.current_card;local factor=GameHPScale.factor(host)
        assert(near(factor,s.total),'Boss采用本阶段累计HP倍率')
        if not host._rank_hp_proxy then assert(near(host.maxhp,card.hp*factor),'Boss实际maxhp应乘阶段倍率') end
        if host._th06_hp_scale then
            local M=dofile('mod/GAME/th32_hp.lua')
            assert(near(M.raw(host),host.hp/host._th06_hp_scale),'红魔乡原始life保持独立')
        end
        local actors=0
        for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do for _,o in ObjList(group) do
            if o~=host and o._hp_growth_factor then assert(near(o._hp_growth_factor,s.total),'子机使用本阶段倍率');actors=actors+1 end
        end end
        local f=assert(io.open('hp-native.jsonl','a'))
        f:write(Serialize({id=current.cardId,frames=frames,stage=lstg.var.rogue_run.current,factor=factor,maxhp=host.maxhp,base=card.hp,proxy=host._rank_hp_proxy or false,actors=actors}),'\n');f:close()
    end
    if frames==300 then
        lstg.var.dead=2
        local p=lstg.var.upgrades.players[1];p.red,p.blue,p.green=13500,17500,7500;p.bombs,p.bomb_fraction=3,.5*GameDrops.BOMB_FRAMES*10000
    end
end
