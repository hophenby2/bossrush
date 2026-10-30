-- 仅由 native_engine.py 安装到临时应用副本；不会进入发行版或读取玩家存档。
local T={}
function T.install()
    scoredata.PlayerBrand=scoredata.PlayerBrand or 'TH32 原生验证'
    scoredata.version=ui.version
    local expected={369,3802,3805,3808,3811}
    for id=3900,3985 do expected[#expected+1]=id end
    local wanted={};for _,id in ipairs(expected) do wanted[id]=true end
    local limit=tonumber(os.getenv('TH32_ENGINE_FRAMES')) or 600
    local speed=tonumber(os.getenv('TH32_ENGINE_SPEED')) or 12
    local selected=tonumber(os.getenv('TH32_ENGINE_CARD') or '')
    if selected then wanted={[selected]=true};expected={selected} end
    local screenshots={[3901]=true,[3910]=true,[3917]=true,[3922]=true,[3955]=true,[3970]=true,[3972]=true,[3974]=true,[3982]=true,[3984]=true,[3985]=true}
    local seen,records,captured={},{},{}
    local current,frames,peak,actors,lasers=nil,0,0,0,0
    local started,complete,settle=false,false,0
    local original=FrameFunc
    local function save()
        local f=assert(io.open('User/th32-progress.json','wb'))
        f:write(Serialize({count=#records,expected=#expected,records=records,renderer=lstg.AndroidRendererInfo(),version=lstg.GetVersionName()}));f:close()
    end
    local function finish_current()
        if current and not seen[current] then
            seen[current]=true
            records[#records+1]={id=current,frames=frames,peak=peak,actors=actors,lasers=lasers}
            lstg.SystemLog(string.format('TH32_ENGINE_CARD: id=%d frames=%d peak=%d actors=%d lasers=%d',current,frames,peak,actors,lasers))
            save()
            if #records==#expected then complete=true end
        end
    end
    function FrameFunc()
        AndroidFocus=function() end
        if complete then
            settle=settle+1
            if settle>=30 then
                local f=assert(io.open('User/th32-engine.json','wb'));f:write(Serialize({count=#records,expected=#expected,records=records,renderer=lstg.AndroidRendererInfo(),version=lstg.GetVersionName()}));f:close()
                lstg.SystemLog('TH32_ENGINE_DONE: '..#records)
                return true
            end
            return false
        end
        for _=1,speed do
            if player and IsValid(player) then player.protect=600;player.lock=true end
            if AndroidInput then
                AndroidInput.keys[setting.keys.shoot]=false
                if AndroidInput.toggles then AndroidInput.toggles.shoot=false end
            end
            local quit=original()
            local scene=stage.current_stage
            if not started and scene and scene.stage_name=='menu' and scene.timer>=90 then
                local count=0
                for _,unit in ipairs(_sc_pr_table[30] or {}) do
                    local card=unit.sc_group[1].card
                    if wanted[card.card_id] then count=count+1 end
                end
                assert(count==#expected,'TH32 原生卡表不完整：'..count..'/'..#expected)
                scoredata.PlayerBrand=scoredata.PlayerBrand or 'TH32 原生验证';scoredata.version=ui.version
                lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
                if selected then
                    RogueTen.COUNT=1
                    RogueTen.draw=function()
                        for index,unit in ipairs(_sc_pr_table[30]) do
                            local card=unit.sc_group[1].card
                            if card.card_id==selected then return {{key='TH32:'..index,index=index,level=30,source='TH32',cardId=selected,title=unit.CardName,spell=card.is_sc}} end
                        end
                    end
                    RogueTen.start()
                else stage.group.PracticeStart('TH32@BossRush',true) end
                started=true
            end
            local b=_boss
            if started and b and IsValid(b) and b.current_card and b.is_combat then
                local id=b.current_card.card_id
                if id~=current then
                    finish_current();current=nil;frames,peak,actors,lasers=0,0,0,0
                    if wanted[id] then current=id end
                end
                if wanted[id] and b.th06 then
                    if seen[id] then b.hp=0 else
                        frames=frames+1
                        local count=0
                        for _,p in pairs(b.th06.pool or {}) do if IsValid(p) and not p.th06_dead then count=count+1 end end
                        peak=math.max(peak,count)
                        count=0
                        for _,a in pairs(b.th06.actors or {}) do if not a.dead and IsValid(a.object) then count=count+1 end end
                        actors=math.max(actors,count)
                        count=0
                        for _,l in pairs(b.th06.laser_pool or b.th06.lasers or {}) do if IsValid(l) and not l.th06_dead then count=count+1 end end
                        lasers=math.max(lasers,count)
                        assert(peak<=640 and actors<=256 and lasers<=64,'TH32 原生对象池上限异常')
                        if screenshots[id] and not captured[id] and frames>=math.floor(limit/2) then
                            captured[id]=true;plus.CreateDirectory('snapshot');Snapshot('snapshot/th32-'..id..'.png')
                        end
                        if frames>=limit or b.hp<=0 then finish_current();b.hp=0 end
                    end
                elseif id==368 then b.hp=0 end
            end
            if complete then break end
            if quit then finish_current();return quit end
        end
        return false
    end
end
return T
