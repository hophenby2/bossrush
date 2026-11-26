-- 反馈卡片专项：正式挑战入口、原有发弹/渲染/碰撞，固定随机种子并隔离存档。
local T={}
function T.install()
    ext.Debugging=function()end
    local shooting=os.getenv('BOSSRUSH_REPORTED_SHOOT')=='1'
    GetInput=function()
        local current=stage.current_stage
        LoadSaveInputState(shooting and current and current.stage_name=='RogueTwo@RogueTwo' and {shoot=true,slow=true} or {})
    end
    local clock=lstg.AndroidClock
    local id=tonumber(os.getenv('BOSSRUSH_REPORTED_CARD') or '38040')
    local limit=tonumber(os.getenv('BOSSRUSH_REPORTED_FRAMES') or '1800')
    if os.getenv('BOSSRUSH_REPORTED_RING_FALLBACK')=='1' then lstg.AndroidUpdateQuadBatch=nil end
    if os.getenv('BOSSRUSH_REPORTED_CURVE_FALLBACK')=='1' then lstg.AndroidRenderSourceCurve=nil end
    local report={platform='macOS Metal，共用移动端逻辑，非安卓设备FPS',card=id,seed=739,
        label=os.getenv('BOSSRUSH_REPORTED_LABEL') or 'current',shooting=shooting,
        frames={},checkpoints={},stacks={},familiar_hits=0,familiar_damage=0,familiar_kills=0,deaths={}}
    local instrumented=false
    local function instrument()
        if instrumented then return end
        instrumented=true
        if os.getenv('BOSSRUSH_REPORTED_POOL_OFF')=='1' then TH39.runtime.useStatePool=false end
        report.pooling=TH39.runtime.useStatePool~=false
        local deathEffect=TH39.runtime.enemyDeathEffect
        TH39.runtime.enemyDeathEffect=function(b,...)
            if b.mhj and b.mhj.familiarConfig and b.hp<=0 then
                report.familiar_kills=report.familiar_kills+1
                report.deaths[#report.deaths+1]={frame=#report.frames+1,slot=b.mhj.familiar,hp=b.hp}
            end
            return deathEffect(b,...)
        end
        local damage=Damage
        Damage=function(b,...)
            local before=b.hp
            local result=damage(b,...)
            if b.mhj and b.mhj.familiarConfig and b.hp<before then
                report.familiar_hits=report.familiar_hits+1
                report.familiar_damage=report.familiar_damage+before-b.hp
            end
            return result
        end
    end
    report.curve_api=type(lstg.AndroidRenderSourceCurve);report.curve_calls=0
    if lstg.AndroidRenderSourceCurve then
        local curve=lstg.AndroidRenderSourceCurve
        lstg.AndroidRenderSourceCurve=function(...)
            report.curve_calls=report.curve_calls+1;return curve(...)
        end
    end
    local started,age=false,0
    local profile=require('jit.profile')
    local sampling=false
    local function sample(thread,n,state)
        local key=state..' '..profile.dumpstack(thread,'pl;',5)
        report.stacks[key]=(report.stacks[key] or 0)+n
    end
    jit.off(sample,true)
    local function checkpoint()
        local rows,motion,effectRows={},{},{};local total,curves,segments,invisible,outside=0,0,0,0,0
        local deathEffects,deathParticles,familiars=0,0,0
        for group=0,15 do for _,o in ObjList(group)do
            total=total+1
            local s=o.asl or o.mhj
            if s and s.familiarConfig then familiars=familiars+1 end
            if o.source_enemy_death then
                deathEffects=deathEffects+1;deathParticles=deathParticles+#o.effect.particles
                for _,p in ipairs(o.effect.particles)do
                    effectRows[#effectRows+1]=table.concat({p.age,p.type,p.fx,p.fy,p.head,p.alpha,p.wscale,p.hscale},',')
                end
            end
            if o.asl and s.kind=='curve' then curves=curves+1;segments=segments+math.max(0,#s.path-1)end
            if s and (s.kind=='bullet' or s.is_projectile)then
                rows[#rows+1]=table.concat({s.serial or 0,s.age or 0,s.x or s.fx or 0,s.y or s.fy or 0,
                    s.speed or 0,s.direction or s.head or 0,s.alpha or 0,tostring(s.dis)},',')
                motion[#motion+1]=table.concat({s.serial or 0,s.age or 0,s.type or s.shape or 0,
                    s.fx or s.x or 0,s.fy or s.y or 0,s.mx or 0,s.my or 0,s.ax or 0,s.ay or 0,
                    s.head or s.rotation or 0,s.alpha or 0,s.wscale or s.scaleX or 0,s.hscale or s.scaleY or 0,tostring(s.dis)},',')
                if (s.alpha or 100)<=0 then invisible=invisible+1 end
                if o.x<lstg.world.l or o.x>lstg.world.r or o.y<lstg.world.b or o.y>lstg.world.t then outside=outside+1 end
            end
        end end
        table.sort(rows)
        table.sort(motion)
        table.sort(effectRows)
        local row={age=age,objects=total,projectiles=#rows,curves=curves,segments=segments,state=SaveCodec.sha256(table.concat(rows,'\n')),
            motion_state=SaveCodec.sha256(table.concat(motion,'\n')),invisible=invisible,outside=outside,lua_kb=collectgarbage('count'),
            familiars=familiars,familiar_hits=report.familiar_hits,familiar_kills=report.familiar_kills,
            death_effects=deathEffects,death_particles=deathParticles,effect_state=SaveCodec.sha256(table.concat(effectRows,'\n'))}
        local emitters,children,spawned=0,0,0
        for c in pairs(TH39.runtime.controllers)do if not c.closed then
            spawned=spawned+c.serial
            for _,e in ipairs(c.emitters)do emitters=emitters+1;for _ in pairs(e.children or {})do children=children+1 end end
        end end
        row.emitters,row.children,row.spawned=emitters,children,spawned
        if TH39.runtime.statePoolStats then row.state_pool=TH39.runtime.statePoolStats() end
        if lstg.AndroidDrawCounts then row.draws,row.vertices=lstg.AndroidDrawCounts()end
        report.checkpoints[#report.checkpoints+1]=row
    end
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local run=lstg.var.rogue_run
        local active=run and run.encounter and not run.preparing and stage.current_stage.stage_name=='RogueTwo@RogueTwo'
        if active then
            instrument()
            age=age+1
            for _,b in ipairs(boss_group)do if IsValid(b)then b.hp=b.maxhp end end
            if age==500 and id==38040 then
                local b=assert(boss_group[1]);assert(IsValid(b))
                local slot=lstg.var.upgrades.players[1]
                local red,hp,protect=slot.red,b.hp,b.protect
                b.protect=false
                local shot={dmg=10,_drop_owner=1,killflag=true,mute=true}
                slot.red=10000;enemybase.colli(b,shot);local base=hp-b.hp;b.hp=hp
                slot.red=11500;enemybase.colli(b,shot);local boosted=hp-b.hp
                slot.red,b.hp,b.protect=red,hp,protect
                assert(base>0 and math.abs(boosted/base-1.15)<1e-7,'雪莲华强化未进入实际受伤路径')
                report.damage={base=base,boosted=boosted,ratio=boosted/base,hp=b.maxhp}
            end
            if age==120 then profile.start('li10',sample);sampling=true end
        end
        local t=clock();local quit=frame();local elapsed=(clock()-t)*1000
        if active then
            report.frames[#report.frames+1]={age=age,logic_ms=elapsed}
            if age%120==0 then checkpoint()end
            if age>=limit then
                if sampling then profile.stop()end
                if shooting then assert(report.familiar_hits>0 and report.familiar_kills>0,'未覆盖真实自机弹命中及击破使魔')end
                if TH39.runtime.statePoolStats then
                    TH39.runtime.clearAll()
                    report.after_clear=TH39.runtime.statePoolStats()
                    assert(report.after_clear.pending==0,'清场后仍有弹体等待引用释放')
                end
                local f=assert(io.open('User/reported-card-'..id..'.json','wb'));f:write(Serialize(report));f:close()
                lstg.SystemLog('REPORTED_CARD_PASS: '..id);return true
            end
        elseif not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true
            local originalTime=os.time
            os.time=function(value)return value and originalTime(value) or 739 end
            local filters=RogueTen.defaultFilters('staged');filters.rules.enhanced=false
            local chosen
            for _,bucket in ipairs(RogueTen.buildPool(filters))do for _,entry in ipairs(bucket.cards)do
                if entry.cardId==id then chosen=entry end
            end end
            assert(chosen,'专项卡未进入挑战卡池：'..id)
            RogueTen.drawStages=function()return {chosen}end
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
        if age==900 then plus.CreateDirectory('snapshot');Snapshot('snapshot/reported-card-'..id..'.png')end
        return result
    end
end
return T
