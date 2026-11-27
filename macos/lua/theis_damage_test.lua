-- 正式挑战入口，核对终符光背的强化碰撞、直接伤害及索敌；存档由启动器隔离。
local T={}
function T.install()
    ext.Debugging=function()end
    SaveSpellCardData=function()end
    GetLastKey,lstg.GetLastKey=function()return KEY.NULL end,function()return KEY.NULL end
    GetMouseState,lstg.GetMouseState=function()return false end,function()return false end
    GetInput=function()LoadSaveInputState({})end
    local Shot=Class(object,{
        init=function(o,x,y)
            o.x,o.y,o.a,o.b=x,y,2,2
            o.group,o.bound,o.dmg,o.killflag,o.mute=GROUP.PLAYER_BULLET,false,10,true,true
        end,
    })
    local started=false
    local frame=FrameFunc
    local function near(a,b,label)assert(math.abs(a-b)<1e-6*math.max(1,math.abs(b)),label..': '..tostring(a)..' / '..tostring(b))end
    function FrameFunc()
        AndroidFocus=function()end
        for _=1,8 do
            if IsValid(player)then player.protect=6000 end
            local quit=frame()
            local scene=stage.current_stage
            if not started and GameDebug.title and not GameDebug.title.locked and scene.timer>90 then
                started=true
                ran:Seed(739)
                local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=true
                local chosen
                for _,bucket in ipairs(RogueTen.buildPool(filters))do for _,entry in ipairs(bucket.cards)do
                    if entry.level==39 then
                        local source=_sc_pr_table[39][entry.index].sc_group[1].card.port_source
                        if source.class=='stage6boss:Lunatic' and source.index==20 then chosen=entry end
                    end
                end end
                assert(chosen,'挑战卡池缺少祗园精舍终符')
                RogueTen.drawStages=function()return{chosen}end
                lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
                assert(RogueTen.start('staged',filters))
            elseif scene.stage_name=='RogueTwo@RogueTwo' and IsValid(player)then
                local env=GameContent.ports[39].source
                local b=env._boss
                local light=b and b.back_light
                if b and IsValid(b) and light and IsValid(light) and light.colli and b.timer>=600 then
                    assert(lstg.var.rogue_run.enhanced and GameDrops.enabled() and GameHPScale.enabled(),'未进入实际强化路径')
                    assert(player_lib.CanTarget(light) and not b.colli,'受击目标没有切换到光背')
                    player_class.findtarget(player);assert(player.target==light,'实际索敌没有锁定光背')
                    lstg.var.upgrades.players[1].red=1000000
                    local shot=New(Shot,light.x,light.y)
                    local input=shot.dmg
                    local factor=GameHPScale.factor(light)
                    local expected=input*GameDrops.power(shot)*light._hp_growth_source_rate/factor*b.dmg_factor*b.dmgrate
                    local sourceCollision
                    for i=1,20 do
                        local name,value=debug.getupvalue(light.class.colli,i)
                        if not name then break end
                        if name=='sourceCollision' then sourceCollision=value;break end
                    end
                    local hp=b.hp;assert(sourceCollision,'缺少原作碰撞对照')
                    sourceCollision(light,shot)
                    local legacy=hp-b.hp
                    hp=b.hp
                    CollisionCheck(GROUP.NONTJT,GROUP.PLAYER_BULLET)
                    local collision=hp-b.hp
                    near(collision,expected,'原生碰撞未应用火力或重复换算阶段倍率')
                    near(collision,legacy*GameDrops.power(shot),'原作独立回调漏乘火力的对照不符')
                    hp=b.hp;Damage(light,GameDrops.damage(input,shot))
                    local direct=hp-b.hp
                    near(direct,expected,'宿主直接伤害未转交Boss')
                    assert(shot.dmg==input and shot.killerenemy==b,'命中改写原始伤害或击中目标归属错误')
                    object.RawDel(shot)
                    local result={platform='macOS Metal，共用移动端逻辑',mode='挑战模式强化开启',
                        card=lstg.var.rogue_run.encounter.cardId,power=100,factor=factor,
                        legacy_collision=legacy,collision=collision,direct=direct,expected=expected,
                        target_light=true,boss_colli=b.colli,passed=true}
                    local f=assert(io.open('User/theis-damage.json','wb'));f:write(Serialize(result));f:close()
                    lstg.SystemLog('THEIS_DAMAGE_PASS: '..Serialize(result))
                    return true
                end
            end
            if quit then return true end
        end
    end
end
return T
