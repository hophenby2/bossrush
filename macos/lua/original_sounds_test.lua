-- 五作练习入口依次实际加载、发声和切换；不接触用户存档。
local T={}
function T.install()
    ext.Debugging=function()end;AndroidFocus=function()end
    GetInput=function()LoadSaveInputState({})end
    local ids={3436,3802,523,3405,3632}
    local games={8,6,95,7,10}
    local samples,started,current,age={},false,0,0
    local play=lstg.PlaySound
    lstg.PlaySound=function(name,...)
        local result=play(name,...)
        local game=name:match('^th3x%.original%.(%d+)%.')
        if game and tonumber(game)==games[current] then
            local row=samples[current]
            if not row then row={card=ids[current],sounds={},playing={}};samples[current]=row end
            row.sounds[name]=(row.sounds[name] or 0)+1
            row.playing[name]=GetSoundState(name)
        end
        return result
    end
    local function startCard(index)
        current,age=index,0
        local level=28+index
        local slot
        for i,unit in ipairs(_sc_pr_table[level])do if unit.sc_group[1].card.card_id==ids[index] then slot=i;break end end
        assert(slot,'音效测试卡未注册：'..ids[index])
        lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
        lstg.var.sc_index,lstg.var.sc_group=slot,{level,slot}
        stage.group.PracticeStart('Spell Practice@Spell Practice',true)
    end
    local frame=FrameFunc
    FrameFunc=function()
        if IsValid(player)then player.protect=60000 end
        local quit=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true;startCard(1)
        elseif started and stage.current_stage.stage_name=='Spell Practice@Spell Practice' then
            age=age+1
            if age>=660 then
                local row=assert(samples[current],'本卡没有播放原作音效：'..ids[current])
                local count=0
                for name,state in pairs(row.playing)do
                    assert(state=='playing','实际音频未开始：'..name..' '..state);count=count+1
                end
                assert(count>0,'本作音效没有接入')
                if current==#ids then
                    assert(row.sounds['th3x.original.10.7'] and row.sounds['th3x.original.10.16'],'风神录发弹或激光提示音缺失')
                    local f=assert(io.open('User/original-sounds-native.json','wb'));f:write(Serialize({passed=true,samples=samples}));f:close()
                    lstg.SystemLog('ORIGINAL_SOUNDS_PASS: '..Serialize(samples));return true
                end
                startCard(current+1)
            end
        end
        return quit
    end
end
return T
