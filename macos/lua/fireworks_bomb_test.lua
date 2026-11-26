-- 正式挑战入口：记录流星花火扔雷前、中、后的消弹回调、对象状态和CPU耗时。
local T={}
function T.install()
    ext.Debugging=function()end
    GetInput=function()LoadSaveInputState({})end
    local clock=lstg.AndroidClock
    local report={platform='macOS原生Metal（共用安卓逻辑，非安卓设备FPS）',card=39004,seed=739,
        label=os.getenv('BOSSRUSH_FIREWORKS_LABEL') or 'current',frames={},checkpoints={}}
    local started,age,bombed=false,0,false
    local calls,repeated=0,0
    local kill=object.Kill
    object.Kill=function(o,...)
        if IsValid(o) and o.mhj then
            calls=calls+1
            if o.mhj.dis then repeated=repeated+1 end
        end
        return kill(o,...)
    end
    local function checkpoint()
        local rows={}
        local total,dying=0,0
        for o in pairs(TH39.runtime.objects)do if IsValid(o) and o.mhj and o.mhj.is_projectile then
            local s=o.mhj;total=total+1;if s.dis then dying=dying+1 end
            rows[#rows+1]=table.concat({s.serial or 0,s.type,s.age,s.fx,s.fy,s.alpha,s.wscale,s.hscale,tostring(s.dis)},',')
        end end
        table.sort(rows)
        report.checkpoints[#report.checkpoints+1]={age=age,total=total,dying=dying,
            state=SaveCodec.sha256(table.concat(rows,'\n')),calls=calls,repeated=repeated,lua_kb=collectgarbage('count')}
    end
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local run=lstg.var.rogue_run
        local active=run and run.encounter and not run.preparing and stage.current_stage.stage_name=='RogueTwo@RogueTwo'
        if active then
            age=age+1
            for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=b.maxhp end end
            if age==600 then
                assert(GameDrops.bombInput(player,{spell=true},{spell=false}),'诊断Bomb未触发');bombed=true
            end
        end
        local t=clock();local quit=frame();local elapsed=(clock()-t)*1000
        if active then
            report.frames[#report.frames+1]={age=age,logic_ms=elapsed}
            if age%60==0 then checkpoint()end
            if age>=1500 then
                assert(bombed);report.calls,report.repeated=calls,repeated
                local f=assert(io.open('User/fireworks-bomb.json','wb'));f:write(Serialize(report));f:close()
                lstg.SystemLog('FIREWORKS_BOMB_PASS: calls='..calls..' repeated='..repeated);return true
            end
        elseif not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true
            local originalTime=os.time
            os.time=function(value)return value and originalTime(value) or 739 end
            local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=false
            local chosen
            for _,bucket in ipairs(RogueTen.buildPool(filters))do for _,entry in ipairs(bucket.cards)do
                if entry.cardId==39004 then chosen=entry end
            end end
            assert(chosen);RogueTen.drawStages=function()return {chosen}end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        end
        return quit
    end
    local render=RenderFunc
    RenderFunc=function()
        local t=clock();local result=render()
        local row=report.frames[#report.frames]
        if row and row.age==age then row.render_ms=(clock()-t)*1000 end
        return result
    end
end
return T
