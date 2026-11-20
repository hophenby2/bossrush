-- 隔离数据目录内的移植机制检查，不影响正常游戏入口。
local T={}
function T.install()
    local phase,age=0,0
    local rows={}
    local id=tonumber(os.getenv('BOSSRUSH_MECHANICS_CARD') or '39088')
    local spring=id<38000
    local natural=os.getenv('BOSSRUSH_MECHANICS_NATURAL')=='1'
    local stats={card=id,top_draws=0,moved=false,phase_carried=false}
    local wrapped
    local original=FrameFunc
    GetLastKey=function() return KEY.NULL end
    GetMouseState=function() return false end
    function FrameFunc()
        AndroidFocus=function() end
        for _=1,8 do
            AndroidInput.keys={};AndroidInput.toggles={}
            if not spring and setting and age>=600 and age<680 then
                -- 胡桃钳先石化操控端；使用方向键按下沿解除，再测试长按移动。
                local direction=age%4<2 and 'left' or 'right'
                AndroidInput.keys[setting.keys[direction]]=true
            elseif not spring and setting and age>=680 and age<770 then AndroidInput.keys[setting.keys.right]=true end
            if IsValid(player) then player.protect=600 end
            local quit=original()
            local scene=stage.current_stage
            if phase==0 and scene and scene.stage_name=='menu' and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
                setting.displayBG=false
                local level=id<38000 and 35 or 37
                local index
                for i,u in ipairs(_sc_pr_table[level]) do if u.sc_group[1].card.card_id==id then index=i end end
                assert(index,'缺少机制检查符卡')
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';lstg.var.sc_group={level,index}
                stage.group.PracticeStart('Spell Practice@Spell Practice',true,'reimu')
                phase=1
            elseif phase==1 and scene and not scene.is_menu and IsValid(player) then
                age=age+1
                local source=player.mhj_source
                local c=source and source.character
                local eq=source and source.equipment
                local controlPos=eq and eq.lanternControlPos
                if not spring and eq and not wrapped then
                    wrapped=eq
                    local draw=eq.DrawOverTop
                    eq.DrawOverTop=function(self,...)
                        for i=0,self.sprites.Count-1 do
                            if self.sprites[i].depth==-1 then stats.top_draws=stats.top_draws+1 end
                        end
                        return draw(self,...)
                    end
                end
                local actor
                for _,boss in ipairs(boss_group) do if IsValid(boss) then
                    if spring then
                        if age>=400 and boss.mhj_actor then
                            assert(boss.mhj_actor.alpha<.001,'TIME 耐久卡本体没有按原作隐去')
                        end
                    elseif boss.mhj3_card then actor=boss.mhj3_card.actors[2] end
                end end
                if controlPos and age==681 then stats.right_start=controlPos.X end
                if controlPos and age==769 then
                    stats.right_end=controlPos.X
                    stats.moved=stats.right_start and stats.right_end>stats.right_start+1 or false
                end
                if not spring and c and c.controling and age>=610 then
                    assert(c.LanternDisplayPos.X>=62.99 and c.LanternDisplayPos.X<=609.01,'控制灯笼被钳到了场外')
                    assert(c.LanternDisplayPos.Y>=38.99 and c.LanternDisplayPos.Y<=686.01,'控制灯笼纵向范围不符原作')
                end
                if actor and actor.index>=2 and c and c.controling then stats.phase_carried=true end
                if age%30==0 then
                    local light=eq and eq.cs and eq.cs.light
                    local count=0
                    if light then for o in pairs(light.controller.bullets) do if IsValid(o) then count=count+1 end end end
                    rows[#rows+1]={age=age,phase=actor and actor.index,x=player.x,y=player.y,control=c and c.controling,
                        control_time=c and c.controlTime,ban=c and c.CBanShoot,light=light and light.Id,
                        light_objects=count,lantern_x=c and c.LanternDisplayPos.X,lantern_y=c and c.LanternDisplayPos.Y,
                        right=player._playersys.keyState.right,petrifying=c and c.petrifying,
                        control_x=controlPos and controlPos.X,control_y=controlPos and controlPos.Y}
                end
                if age==(spring and 1800 or 780) then plus.CreateDirectory('snapshot');Snapshot('snapshot/port-mechanics.png') end
                if not spring and not natural and age==850 then
                    for _,boss in ipairs(boss_group) do if IsValid(boss) and boss.mhj3_card then
                        local a=boss.mhj3_card.actors[2]
                        -- 独立触发原卡的使魔死亡通知，只检查换段是否误解除控制，不代替伤害验证。
                        assert(a and a.controller,'胡桃钳没有创建第二组弹幕')
                        a.controller.deadFamiliars[4]=1
                    end end
                end
                if age>=(spring and 5500 or natural and 2200 or 1100) then
                    if not spring then
                        local f=assert(io.open('User/port-mechanics.json','wb'));f:write(Serialize(stats));f:close()
                        assert(stats.top_draws>0,'被控制灯笼未进入顶层装备绘制')
                        assert(stats.moved,'按键解除石化后灯笼没有独立移动')
                        assert(stats.phase_carried,'同卡切换弹幕后错误解除了控制')
                        assert(c and c.controling,'胡桃钳控制状态没有保持')
                    end
                    stats.passed=true;stats.samples=rows
                    local f=assert(io.open('User/port-mechanics.json','wb'));f:write(Serialize(stats));f:close()
                    return true
                end
            end
            if quit then return true end
        end
    end
end
return T
