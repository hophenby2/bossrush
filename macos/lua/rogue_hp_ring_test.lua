-- 真实挑战模式：跨独立/宿主后端检查血圈，横竖屏均走实际渲染。
local T={}
function T.install()
    ext.Debugging=function()end;AndroidFocus=function()end
    GetInput=function()LoadSaveInputState({})end
    local width,height=setting.resx,setting.resy
    local portrait=false
    AndroidPortrait=dofile('android/portrait.lua')
    AndroidPortrait.enabled=function()return portrait and not stage.current_stage.is_menu end
    AndroidPortrait.resetScreen=function()
        if not AndroidPortrait.enabled() then return false end
        screen.width,screen.height=540,960;screen.scale=height/960
        setting.resx=540*screen.scale;screen.dx=(width-setting.resx)/2;screen.dy=0
        ResetWorld();ResetWorldOffset();AndroidPortrait.layoutWorld();return true
    end
    local started,previous,age=false,nil,0
    local samples={}
    local quads=0
    local draw=Render4V
    Render4V=function(name,...)
        if name=='portrait_hp_fill' then quads=quads+1 end
        return draw(name,...)
    end
    local batch=lstg.AndroidRenderQuadBatch
    lstg.AndroidRenderQuadBatch=function(handle,x,y,z,ox,oy,oz,flip,count,color)
        if count then quads=quads+count end
        return batch(handle,x,y,z,ox,oy,oz,flip,count,color)
    end
    local render=RenderFunc
    RenderFunc=function()
        quads=0;local result=render()
        local run=lstg.var.rogue_run
        if run and run.encounter and age==180 then
            local expected,count=0,0
            for _,row in ipairs(RogueBossHUD.current)do
                local state=assert(RogueBossHUD.rings[row.boss],'真实Boss没有血圈数据').boss
                if state.is_combat and not state.__is_waiting and not state.time_sc and state.maxhp>0 then
                    expected=expected+math.floor(360*math.min(1,math.max(0,state.hp/state.maxhp))*math.min(1,math.max(0,state.__hpbar_timer)/60))
                    count=count+1
                end
            end
            assert(expected>0 and quads==expected,'血圈丢失或重复：'..run.encounter.source..' '..quads..'/'..expected)
            samples[#samples+1]={source=run.encounter.source,id=run.encounter.cardId,portrait=portrait,bosses=count,quads=quads}
            if run.encounter.source=='TH41' or run.encounter.source=='TH39' then Snapshot('snapshot/rogue-hp-ring-'..run.current..'.png') end
        end
        return result
    end
    local frame=FrameFunc
    FrameFunc=function()
        -- 平台入口在安装诊断后才设置焦点回调，逐帧覆盖，截图查看不应暂停检查。
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local quit=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;plus.CreateDirectory('snapshot')
            local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=false
            local pool=RogueTen.buildPool(filters)
            local function pick(code,spell)
                for _,bucket in ipairs(pool)do for _,entry in ipairs(bucket.cards)do
                    if entry.source==code and entry.kind=='boss' and entry.stage==1 and entry.spell==spell then
                        local card=_sc_pr_table[entry.level][entry.index].sc_group[1].card
                        if not card.time_sc then return entry end
                    end
                end end
                error('没有血圈检查候选：'..code)
            end
            local plan={pick('TH41',false),pick('TH41',true),pick('TH39',true),pick('TH37',true),
                pick('TH38',true),pick('TH40',true),pick('TH43',true),pick('TH31',true)}
            RogueTen.drawStages=function()return plan end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local run=lstg.var.rogue_run
            if run.current~=previous then
                previous,age=run.current,0;portrait=run.current%2==1
                setting.resx,setting.resy=width,height;ResetScreen()
            end
            if not ui.ResourceLoading.state and run.encounter then age=age+1 end
            if age>=210 then
                if run.current==8 then
                    assert(#samples==8,'没有检查全部后端')
                    local f=assert(io.open('User/rogue-hp-ring.json','wb'));f:write(Serialize({passed=true,samples=samples}));f:close()
                    lstg.SystemLog('ROGUE_HP_RING_PASS: '..Serialize(samples));return true
                end
                for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=0 end end
                local work=GameContent.ports[run.encounter.level]
                if work and work.source and work.source.boss then
                    for _,b in ipairs(work.source.boss.GetBossTable())do if IsValid(b)then b.hp=0 end end
                end
            end
        end
        return quit
    end
end
return T
