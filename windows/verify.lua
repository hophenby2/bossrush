-- 独立发行包验证：真实Windows引擎逐个解码资源，再运行五作练习入口。
local f=assert(io.open('native-config.json','rb'));local config=DeSerialize(f:read('*a'));f:close()
local result={ok=false,images=0,audio=0,entries={}}
local finished=false
local function save(ok,err)
    finished=true;result.ok=ok;result.error=err
    local out=assert(io.open('native-result.json','wb'));out:write(Serialize(result));out:close()
end
function GameInit()
    local ok,err=xpcall(function()
        result.version=lstg.GetVersionName()
        SetResourceStatus('global')
        for _,image in ipairs(config.images) do
            LoadTexture('release:verify',image.path)
            local w,h=GetTextureSize('release:verify')
            assert(w==image.width and h==image.height,image.path)
            RemoveResource('global',1,'release:verify');result.images=result.images+1
        end
        for _,path in ipairs(config.audio) do
            LoadSound('release:verify',path);RemoveResource('global',5,'release:verify');result.audio=result.audio+1
        end
        lstg.DoFile('game-core.lua')
        local initialize=GameInit;initialize()
        setting.mod='Boss Rush HD';cur_setting=DeSerialize(Serialize(setting))
        Include('mod/root.lua');InitAllClass();InitGameSaveData();stage.next_stage=stage.stages.init
        scoredata.PlayerBrand='Windows发行验证';scoredata.version=ui.version
        local frame,render=FrameFunc,RenderFunc
        local index,active,ticks=1,false,0
        local function step()
            if finished then return true end
            ticks=ticks+1;assert(ticks<18000,'练习入口验证超时')
            if player and IsValid(player) then player.protect=120 end
            local quit=frame();local scene=stage.current_stage
            if scene and scene.stage_name=='menu' and scene.timer>=45 and not active then
                lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
                lstg.var.current_system='';lstg.var.sc_group={config.levels[index],1}
                assert(stage.group.PracticeStart('Spell Practice@Spell Practice',true)~=false)
                active=true
            elseif active and scene and scene.stage_name=='Spell Practice@Spell Practice' and scene.timer>=300 then
                result.entries[#result.entries+1]={level=config.levels[index],frames=scene.timer}
                index=index+1;active=false
                if index>#config.levels then save(true);return true end
                stage.group.ReturnToTitle(false,0)
            end
            return quit
        end
        FrameFunc=function()
            local good,quit=xpcall(step,debug.traceback)
            if not good then save(false,quit);return true end
            return quit
        end
        RenderFunc=function()
            if finished then return end
            local good,message=xpcall(render,debug.traceback)
            if not good then save(false,message) end
        end
    end,debug.traceback)
    if not ok then save(false,err) end
end
function FrameFunc() return finished end
function RenderFunc() end
function GameExit() end
function FocusLoseFunc() end
function FocusGainFunc() end
