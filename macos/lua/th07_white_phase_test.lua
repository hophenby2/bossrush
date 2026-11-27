-- 实际挑战入口：一念无量劫白弹期间变色/加算背景，仍以正常速度运行。
local T={}
function T.install()
    ext.Debugging=function()end
    GetInput=function()LoadSaveInputState({})end
    local started,active,normal,pending=false,0,0,nil
    local report={card=4391,platform='macOS Metal，共用移植绘制',draws=0}
    local draw=OriginalANM.draw
    OriginalANM.draw=function(vm,x,y,a,sx,sy,alpha,tint,override,rotation)
        if vm.data.key=='7/eff06' and override then
            assert(override.alpha==64 or override.alpha==255,'白弹背景没有接入源颜色指令')
            if override.alpha==255 then assert(override.blend=='mul+add','缺少白弹加算背景')end
            report.draws=report.draws+1
        end
        return draw(vm,x,y,a,sx,sy,alpha,tint,override,rotation)
    end
    local render=RenderFunc
    RenderFunc=function()
        local value=render()
        if pending then Snapshot('snapshot/th07-white-'..pending..'.png');pending=nil end
        return value
    end
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local result=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;plus.CreateDirectory('snapshot')
            local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=false
            local entry
            for _,bucket in ipairs(RogueTen.buildPool(filters))do for _,e in ipairs(bucket.cards)do if e.cardId==4391 then entry=e end end end
            assert(entry,'挑战卡池缺少一念无量劫')
            RogueTen.drawStages=function()return {entry}end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local owner=boss_group[1]
            if owner and owner.th07_motion_live==4391 then
                local bg
                for _,o in ObjList(GROUP.GHOST)do if o._original_background_game==7 and o.active then bg=o end end
                if owner.th07_slow_active then
                    assert(lstg.var.timeslow==1,'白弹错误地触发了缓时')
                    active=active+1
                    if active==8 then
                        assert(bg and #bg.vms==2,'没有两层符卡背景')
                        local a,b=bg.vms[1],bg.vms[2]
                        assert(a.data.key=='7/eff06' and b.data.key=='7/eff06','替换了六面背景贴图')
                        assert(a.interrupt_style.alpha[1]==64 and a.interrupt_style.color[2]==64)
                        assert(b.interrupt_style.blend=='mul+add' and b.interrupt_style.color[2]==96)
                        report.active=true;pending='active'
                    end
                elseif active>0 then
                    normal=normal+1
                    if normal==8 then
                        assert(bg and not bg.vms[1].interrupt_style and not bg.vms[2].interrupt_style,'背景表现没有恢复')
                        assert(bg.vms[1].alpha[1]==255 and bg.vms[2].alpha[1]==224,'六面背景透明度未恢复')
                        report.restored=true;pending='normal'
                    elseif normal==24 then
                        assert(report.draws>10 and report.active and report.restored,'缺少实际变色绘制')
                        local f=assert(io.open('User/th07-white-phase.json','wb'));f:write(Serialize(report));f:close()
                        lstg.SystemLog('TH07_WHITE_PASS: '..Serialize(report));return true
                    end
                end
            end
        end
        return result
    end
end
return T
