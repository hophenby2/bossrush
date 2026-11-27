-- 隔离存档的真实挑战入口：四张非符、横竖屏、接触耗雷及实际阴影/光环绘制。
local T={}
function T.install()
    ext.Debugging=function()end
    GetInput=function()LoadSaveInputState({})end
    local width,height=setting.resx,setting.resy
    local portrait=false
    AndroidPortrait=dofile('android/portrait.lua')
    AndroidPortrait.enabled=function()return portrait and not stage.current_stage.is_menu end
    AndroidPortrait.resetScreen=function()
        if not AndroidPortrait.enabled()then return false end
        screen.width,screen.height=540,960;screen.scale=height/960
        setting.resx=540*screen.scale;screen.dx=(width-setting.resx)/2;screen.dy=0
        ResetWorld();ResetWorldOffset();AndroidPortrait.layoutWorld();return true
    end
    local started,previous,age=false,nil,0
    local report={platform='macOS Metal，含共用安卓竖屏路径',cards={}}
    local tracked=setmetatable({},{__mode='k'})
    local current
    local function instrument()
        local field=TH38.runtime.forceField;local fieldStep=field.step
        field.step=function(s)
            local selected=tracked[s.c]
            if not selected then selected=s;tracked[s.c]=s end
            if s==selected and IsValid(player) then player.x,player.y=TH38.runtime.project(s.x,s.y) end
            return fieldStep(s)
        end
        local consume=GameDrops.drainBombGauge
        GameDrops.drainBombGauge=function(p,n,d)
            local b=GameDrops.bombState(p)
            consume(p,n,d)
            local after,fill=GameDrops.bombState(p)
            assert(after>=0 and fill>=0,'太阳扣出了负雷数/负雷条')
            if current then
                current.contacts=current.contacts+1
                if after<b then
                    assert(after==b-1 and math.abs(fill-.99)<1e-8,'实际模式耗尽后没有转为99%')
                    current.borrowed=current.borrowed+1
                end
                if after==0 and fill==0 then current.floor=true end
            end
        end
    end
    local quad=Render4V
    Render4V=function(name,...)
        if current and name:match('^asl_force_field_') then current.draws=current.draws+1 end
        return quad(name,...)
    end
    local render=RenderFunc
    RenderFunc=function()
        local result=render()
        if current and age==320 then Snapshot('snapshot/th38-sun-'..current.id..'.png') end
        return result
    end
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player) then player.protect=60000 end
        local result=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;instrument();plus.CreateDirectory('snapshot')
            local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=false
            local entries={}
            for _,bucket in ipairs(RogueTen.buildPool(filters))do for _,e in ipairs(bucket.cards)do entries[e.cardId]=e end end
            local plan={}
            for _,id in ipairs({38046,38048,38050,38052})do plan[#plan+1]=assert(entries[id])end
            RogueTen.drawStages=function()return plan end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local run=lstg.var.rogue_run
            if run.current~=previous and run.current>0 then
                previous,age=run.current,0;portrait=run.current%2==0
                setting.resx,setting.resy=width,height;ResetScreen()
                current={id=run.cards[run.current].cardId,portrait=portrait,contacts=0,borrowed=0,draws=0}
                report.cards[#report.cards+1]=current
                local slot=lstg.var.upgrades.players[1];slot.bombs,slot.bomb_fraction=2,GameDrops.BOMB_FRAMES*10000*.2
            end
            if run.encounter and not run.preparing and not ui.ResourceLoading.state then age=age+1 end
            if age==500 then
                assert(current.contacts>400 and current.borrowed==2 and current.floor,'实际接触没有耗尽两雷和雷条')
                assert(current.draws>300,'太阳没有经过实际绘制')
                if run.current==4 then
                    local f=assert(io.open('User/th38-force-field.json','wb'));f:write(Serialize(report));f:close()
                    lstg.SystemLog('TH38_FORCE_FIELD_PASS: '..Serialize(report));return true
                end
                for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=0 end end
            end
        end
        return result
    end
end
return T
