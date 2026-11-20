-- 正常符卡练习入口：全部攻击直接到段，检查实际引擎创建的节点与重进资源。
local T={}
function T.install()
    local phase,index,frames,loaded,seen=0,0,0,nil,false
    local plan,results={},{}
    local original=FrameFunc
    GetLastKey=function() return KEY.NULL end
    GetMouseState=function() return false end
    local function launch()
        index=index+1
        if not plan[index] then
            local f=assert(io.open('User/dreamer-practice.json','wb'))
            f:write(Serialize({passed=true,cases=results}));f:close();return true
        end
        lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';lstg.var.sc_group={40,plan[index].index}
        loaded,seen=nil,false
        stage.group.PracticeStart('Spell Practice@Spell Practice',true)
        phase=1
    end
    function FrameFunc()
        AndroidFocus=function() end
        for _=1,8 do
            frames=frames+1
            AndroidInput.keys={};AndroidInput.toggles={}
            if IsValid(player) then player.protect=600 end
            local quit=original()
            local scene=stage.current_stage
            if phase==0 and scene and scene.stage_name=='menu' and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
                local L=GameContent.ports[40].source
                for i,unit in ipairs(_sc_pr_table[40]) do
                    local card=unit.sc_group[1].card
                    if card.port_source.phase then plan[#plan+1]={index=i,id=card.card_id,source=card.port_source} end
                end
                assert(#plan==61,'攻击练习入口不完整')
                local start=L.Practice.start
                L.Practice.start=function(...)
                    local root=start(...);loaded=frames;return root
                end
                if launch() then return true end
            elseif phase==1 and loaded then
                local L=GameContent.ports[40].source
                local root=L.runtime and L.runtime.boss
                local source=plan[index].source
                if root and root.portPhase==source.phase and L.Practice.inCombat(root) then
                    if not seen then
                        local latency=frames-loaded
                        assert(latency<=1,'仍在逐段跳转：'..plan[index].id..' / '..latency)
                        local counts={}
                        for _,o in pairs(L.runtime.enemiesById) do if o.active then
                            counts[tostring(o.spawnType)]=(counts[tostring(o.spawnType)] or 0)+1
                        end end
                        results[#results+1]={id=plan[index].id,stage=source.stage,phase=source.phase,
                            startup_frames=latency,hp=root.hp,state=root.state,nodes=counts}
                        lstg.SystemLog('DREAMER_PRACTICE: '..plan[index].id..' 直接进入 '..source.phase)
                        seen=frames
                    end
                    if frames-seen>=60 then stage.group.ReturnToTitle(false,0);phase=2 end
                end
                assert(frames-loaded<300,'没有直接进入目标攻击：'..plan[index].id)
            elseif phase==2 and scene and scene.stage_name=='menu' and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
                if launch() then return true end
            end
            if quit then return true end
        end
    end
end
return T
