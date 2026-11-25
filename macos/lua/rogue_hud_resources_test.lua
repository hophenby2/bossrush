-- 隔离存档内覆盖永夜篇首张非符、Last Word筛选、同局跨作及ANM显式卸载。
local T={}
function T.install()
    lstg.AndroidSpriteClipping(true)
    ext.Debugging=function()end;AndroidFocus=function()end
    GetInput=function()LoadSaveInputState({})end
    local width,height=setting.resx,setting.resy
    AndroidPortrait=dofile('android/portrait.lua')
    AndroidPortrait.enabled=function()return true end
    AndroidPortrait.resetScreen=function()
        screen.width,screen.height=540,960;screen.scale=height/960
        setting.resx=540*screen.scale;screen.dx=(width-setting.resx)/2;screen.dy=0
        ResetWorld();ResetWorldOffset();AndroidPortrait.layoutWorld();return true
    end
    AndroidInput.preview=true
    local results={samples={},removed=0}
    local phase,age,oldIndex,started=0,0,nil,false
    local removed,oldResource,removedData,removedId
    local render=RenderFunc
    RenderFunc=function()
        local run=lstg.var.rogue_run
        if run and run.current==1 and age==180 and not ui.ResourceLoading.state then
            RogueBossHUD.reset()
            render()
            assert(#RogueBossHUD.current==1 and next(RogueBossHUD.pointers),'首张非符绘制前未补建血条/指示器')
            results.first_render_hud=true
            return
        end
        return render()
    end
    local frame=FrameFunc
    function FrameFunc()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local quit=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;ResetScreen();plus.CreateDirectory('snapshot')
            local filters=RogueTen.defaultFilters('staged');filters.stages={TH39=true,TH31=true,TH41=true,TH43=true}
            local pool=RogueTen.buildPool(filters)
            local byId,old,bySource={},nil,{}
            for _,bucket in ipairs(pool)do for _,entry in ipairs(bucket.cards)do
                local c=_sc_pr_table[entry.level][entry.index].sc_group[1].card
                assert(not c.mhj3_source or c.mhj3_source.kind~=2,'Last Word仍在Lunatic池：'..entry.title)
                byId[entry.cardId]=entry
                if not entry.spell and entry.kind=='boss' and not bySource[entry.source] then bySource[entry.source]=entry end
                if not old and entry.source=='TH31' and entry.stage==1 and not entry.spell then old=entry end
            end end
            local plan={assert(byId[39003]),assert(old),assert(bySource.TH41),assert(bySource.TH43),old}
            assert(not plan[1].spell,'首卡必须为永夜篇非符')
            assert(TH39.cards[39007],'Last Word练习入口被误删')
            RogueTen.drawStages=function()return plan end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local run=lstg.var.rogue_run
            if run.current~=oldIndex then oldIndex=run.current;age=0 end
            age=age+1
            local card=run.encounter
            if card and age==180 and (card.source=='TH41' or card.source=='TH43') then
                local env=card.source=='TH41' and _editor_class.TH41.source or TH43.runtime.env
                local prefix=card.source=='TH41' and 'theis/' or 'th43/'
                local names=select(1,lstg.EnumRes(2))
                local key
                for _,name in ipairs(names)do if name:sub(1,#prefix)==prefix then key=name;break end end
                assert(key,'没有预加载的作品图像')
                local logical=key:sub(#prefix+1)
                local cls=env.Class(object,{init=function(o)o.img=logical;o.hide=true;o.bound=false;o.group=GROUP.GHOST end})
                local probe=env.New(cls)
                assert(probe.img==key,'对象仍绑定裸名图像：'..card.source..' '..tostring(probe.img))
                object.RawDel(probe)
                results[card.source..'_namespaced']=true
            end
            if card and age==240 then
                local row={id=card.cardId,count=#RogueBossHUD.current,bosses={}}
                for _,b in ipairs(boss_group)do row.bosses[#row.bosses+1]={hp=b.hp,maxhp=b.maxhp,x=b.x,y=b.y,hide=b.hide,road=b._sequence_road_carrier,card=b.current_card and b.current_card.card_id}end
                row.screen={screen.width,screen.height,screen.scale,screen.dx}
                row.world={lstg.world.scrl,lstg.world.scrr,lstg.world.scrb,lstg.world.scrt}
                results.samples[#results.samples+1]=row
                Snapshot('snapshot/rogue-first-hud-'..run.current..'.png')
                lstg.SystemLog('ROGUE_HUD_SAMPLE: '..Serialize(row))
            end
            if run.current==2 and age==260 then
                for _,data in pairs(OriginalANM.cache())do for id,s in pairs(data.sprites)do
                    if not removed and s.native_draw_resource and CheckRes('img',s.img)=='stage' then
                        removed,oldResource,removedData,removedId=s,s.native_draw_resource,data,id
                        RemoveResource('stage',2,s.img);results.removed=results.removed+1
                    end
                end end
                assert(removed,'未触发同关资源卸载检查')
            elseif run.current==2 and age==280 then
                OriginalANM.sprite_resource({data=removedData,sprite=removedId})
                assert(removed.native_draw_resource and removed.native_draw_resource~=oldResource,'ANM仍使用卸载前的句柄')
                assert(removed.native_draw_resource==FindResSprite(removed.img),'ANM缓存未绑定当前图像')
                results.resource_rebound=true
            end
            if card and age>=330 then
                if run.current==5 then
                    assert(results.first_render_hud and results.resource_rebound and results.TH41_namespaced and results.TH43_namespaced)
                    results.passed=true
                    local f=assert(io.open('User/rogue-hud-resources.json','wb'));f:write(Serialize(results));f:close()
                    return true
                end
                for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=0 end end
            end
            assert(age<1200,'跨作切卡停滞')
        end
        return quit
    end
end
return T
