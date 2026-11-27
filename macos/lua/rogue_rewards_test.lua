-- 正式挑战入口的横竖屏、库存、圆槽、原生标题/计时器和两种机体的雷子对象。
local T={}
function T.install()
    ext.Debugging=function()end
    local machine=os.getenv('BOSSRUSH_REWARD_MACHINE') or 'reimu_player'
    local width,height=setting.resx,setting.resy
    local portrait,phase,age=false,1,0
    AndroidPortrait=dofile('android/portrait.lua')
    AndroidPortrait.enabled=function()return portrait and stage.current_stage and not stage.current_stage.is_menu end
    AndroidPortrait.resetScreen=function()
        if not AndroidPortrait.enabled()then return false end
        screen.width,screen.height,screen.scale=540,960,height/960
        setting.resx=540*screen.scale;screen.dx=(width-setting.resx)/2;screen.dy=0
        ResetWorld();ResetWorldOffset();AndroidPortrait.layoutWorld();return true
    end
    GetInput=function()LoadSaveInputState({shoot=age>=3 and age<=7,spell=age==140})end
    local objects=setmetatable({},{__mode='k'})
    local create=New
    New=function(cls,...)local o=create(cls,...);if o then objects[o]=true end;return o end
    local report={platform='macOS Metal，共用移动端逻辑',machine=machine,cases={}}
    local current,started,ready,forcedChild=nil,false,false,false
    local apply=GameDrops.apply
    GameDrops.apply=function(slot,option)
        if current then
            local row=assert(lstg.var.upgrades.active)
            assert(option==2 and player.y<GameQuiz.top(row.age,row.duration,row.linear)-GameQuiz.DEPTH+12,
                '奖励没有在色块下沿接触时立即结算')
            current.color_contact=true
        end
        return apply(slot,option)
    end
    local titles=dofile('mod/rogue_titles.lua')
    local renderLabel=boss.sc_name.renderLabel
    boss.sc_name.renderLabel=function(name,p)
        if current then
            if p.background~=false then current.native_names=current.native_names+1 end
            if name:sub(1,#'×')=='×' and p.background==false and not p.align then
                current.hp_flight=true
                local state=lstg.var.rogue_run.hp_growth
                local a=state.animation
                if a and (a.age==6 or a.age==31 or a.age==59) then
                    local rows=titles.nameLayout(lstg.var.rogue_run)
                    if a.age==6 then
                        assert(math.abs(p.size-rows[#rows].size)<1e-6,'倍率入场字号与卡名不同')
                        assert(math.abs(rows[#rows].y-p.y-p.size*32)<1e-6,'倍率没有从中央卡名下方开始')
                    end
                    current.synchronized=current.synchronized+1
                end
            end
        end
        return renderLabel(name,p)
    end
    local counterRender=boss.timeCounter.render
    boss.timeCounter.render=function(self)
        if current and self.header_layout then current.native_timers=current.native_timers+1 end
        return counterRender(self)
    end
    local bulletScale=GameDrops.bulletScale
    GameDrops.bulletScale=function(o)
        local value=bulletScale(o)
        if current and o then
            if o._drop_bomb then
                assert(math.abs(value-math.min(5,GameHPScale.factor()))<1e-6,'雷绘制仍随火力或未封顶')
                current.bomb_scale=math.max(current.bomb_scale,value)
            else current.shot_scale=math.max(current.shot_scale,value)end
        end
        return value
    end
    local damage=GameDrops.damage
    GameDrops.damage=function(n,o)
        local value=damage(n,o)
        if current and n>0 then
            if o and o._drop_bomb then
                assert(math.abs(value/n-GameHPScale.factor())<1e-6,'雷伤倍率错误')
                current.bomb_hits=current.bomb_hits+1
            else current.shot_hits=current.shot_hits+1 end
        end
        return value
    end
    local function begin(run)
        age,forcedChild=0,false
        portrait=phase==2;setting.resx,setting.resy=width,height;ResetScreen()
        AndroidInput.preview=portrait
        run.stage_banner,run.banner_queue=nil,{}
        GameHPScale.init(run)
        local count=portrait and 20 or 2
        for i=1,count do GameHPScale.enter(i)end
        local state=run.hp_growth
        local event=state.queue[#state.queue] or state.animation
        state.animation,state.queue=event,{}
        state.shown,state.shown_stage=event.total/event.factor,event.stage-1
        titles.announce(run,{title='测试符卡「无限库存与恢复圆槽」'})
        local data=lstg.var.upgrades.players[1]
        data.red,data.bombs,data.bomb_fraction=1000000,12,GameDrops.BOMB_FRAMES*10000*.45
        current={portrait=portrait,factor=state.total,native_names=0,native_timers=0,
            shot_scale=0,bomb_scale=0,shot_hits=0,bomb_hits=0,child=false,gauge=false,hp_flight=false,synchronized=0}
        report.cases[#report.cases+1]=current
    end
    local render=RenderFunc
    RenderFunc=function()
        local result=render()
        if current and ready then
            local dots=assert(player._bombGaugeDots,'自机没有库存圆槽')
            assert(dots.count==GameDrops.bombState(player) and dots.count>9,'绿点被9个上限截断')
            current.gauge=true
            local run=lstg.var.rogue_run
            if run.card_title.layout then current.title_size=run.card_title.layout.size end
            if age==6 or age==31 or age==59 or age==66 or age==100 or age==160 or age==340 then
                Snapshot('snapshot/rewards-'..phase..'-'..age..'.png')
            end
        end
        return result
    end
    local frame=FrameFunc
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        if ready then
            -- UI/伤害来源专项保持当前卡，避免大火力提前击破；不作为TTK结果。
            for _,b in ipairs(boss_group)do if IsValid(b)then
                b.hp,b.maxhp,b._hp_growth_last=1e18,1e18,1e18;b._hp_growth_factor=GameHPScale.factor()
            end end
        end
        local quit=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;plus.CreateDirectory('snapshot')
            local filters=RogueTen.defaultFilters('staged');local pool=RogueTen.buildPool(filters)
            local entry
            for _,bucket in ipairs(pool)do for _,e in ipairs(bucket.cards)do
                local card=_sc_pr_table[e.level][e.index].sc_group[1].card
                if not entry and e.level<=33 and e.kind=='boss' and e.spell and card.t3>=45 then entry=e end
            end end
            assert(entry,'没有宿主Boss测试卡')
            RogueTen.drawStages=function()return {entry}end
            lstg.var.player_name,lstg.var.rep_player=machine,machine=='reimu_player' and 'Reimu' or 'Marisa'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            local run=lstg.var.rogue_run
            if not ready then
                for _,b in ipairs(boss_group)do if IsValid(b)and b.is_combat and b.timer>90 then
                    ready=true;begin(run);break
                end end
            else
                age=age+1
                if age==80 then
                    local s=lstg.var.upgrades;s.count=s.count+1
                    s.queue[#s.queue+1]={id=s.count,options={1,2,3},age=0,duration=120,linear=true,colorMask=true,picks={false,false}}
                end
                -- 自机模块缓存了New，按引擎对象池采集实际雷弹与命中特效。
                for _,group in ipairs({GROUP.PLAYER_BULLET,GROUP.GHOST})do
                    for _,o in ObjList(group)do objects[o]=true end
                end
                if age>=150 and not forcedChild then
                    local kind=machine=='reimu_player' and reimu_player.bullets.trail or marisa_player.bullets.missile
                    for o in pairs(objects)do if IsValid(o)and o._drop_bomb and o.class==kind then Kill(o);forcedChild=true;break end end
                end
                local effect=machine=='reimu_player' and reimu_player.bullets.trail_ef or marisa_player.bullets.missile_ef
                for o in pairs(objects)do if IsValid(o)and o.class==effect and o._drop_bomb then
                    assert(o._drop_owner==1,'雷子对象所有者丢失');current.child=true
                end end
                if age==460 then
                    assert(current.shot_scale==5 and current.bomb_scale>0 and current.bomb_hits>0 and current.child,'没有覆盖实际雷/射击/子对象: '..Serialize(current))
                    assert(current.native_names>0 and current.native_timers>60 and current.hp_flight and current.gauge,'原生组件或倍率/圆槽没有绘制')
                    assert(current.color_contact,'没有覆盖实际色块下沿立即接取')
                    assert(current.synchronized>=3,'没有覆盖卡名/倍率同帧出现、起飞与落位前一帧')
                    if phase==2 then
                        local f=assert(io.open('User/rogue-rewards.json','wb'));f:write(Serialize(report));f:close()
                        lstg.SystemLog('ROGUE_REWARDS_PASS: '..Serialize(report));return true
                    end
                    for o in pairs(objects)do if IsValid(o)and o._drop_bomb then object.RawDel(o)end end
                    task.Clear(player);phase=2;begin(run)
                end
            end
        end
        return quit
    end
end
return T
