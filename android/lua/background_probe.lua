-- 隔离背景像素基线；所有STD和ANM仍逐帧推进。
local T={}
function T.install(mode)
    scoredata.PlayerBrand="背景隔离验证";scoredata.version=ui.version
    local works={{6,{'stage1','stage2','stage3','stage4','stage5','stage6','stage7'}},
        {7,{'stage1','stage2','stage3','stage4','stage5','stage6','stage7','stage8'}},
        {8,{'stage1','stage2','stage3','stage4a','stage4b','stage5','stage6','stage7','stage8'}},
        {95,{'world01','world02','world03','world04','world05','world06','world07','world08','world09','world10'}},
        {10,{'stage01','stage02','stage03','stage04','stage05','stage06','stage07'}}}
    local cases={};for _,work in ipairs(works) do for _,key in ipairs(work[2]) do
        for _,time in ipairs({0,300,1800}) do cases[#cases+1]={game=work[1],key=key,time=time} end
    end end
    cases[#cases+1]={game=0,key='fog',time=0}
    if mode:match('only=fog') then cases={{game=0,key='fog',time=0}} end
    if mode:match('only=tail') then local tail={};for _,c in ipairs(cases) do if c.game==10 and c.key>='stage03' then tail[#tail+1]=c end end;cases=tail end
    local frame,started=FrameFunc,false
    local results={}
    FrameFunc=function()
        local quit=frame()
        if not started and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            started=true;lstg.GetFPS=function() return 60 end;GetFPS=lstg.GetFPS
            local B=OriginalSequenceMedia.background
            local scene=stage.New('android_background_probe',true,true)
            local index,age,current,bg=0,0,nil,nil
            local function nextCase()
                index=index+1;current=cases[index];age=0
                if not current then
                    local f=assert(io.open('User/android-performance-probe.json','wb'));f:write(Serialize(results));f:close()
                    f=assert(io.open('User/android-case-state.txt','wb'));f:write('backgrounds='..#results);f:close()
                    lstg.SystemLog('BOSSRUSH_CASE_ACTIONS: backgrounds='..#results);return
                end
                lstg.var.ran_seed=20261111
                if current.game==0 then bg=nil;return end
                local init=background.init;background.init=function() end
                bg={};B.class.init(bg,current.game,current.key);background.init=init
                for _=1,current.time do B.step(bg) end
            end
            function scene:init() nextCase() end
            function scene:frame()
                if not current then return end
                age=age+1
                if age==6 then
                    local id=current.game..'_'..current.key..'_'..current.time
                    local path='snapshot/background-'..id..'.png';os.remove(path);Snapshot(path)
                    local values=bg and {bg.time,bg.pc} or {"fog"}
                    if bg then
                    for _,field in ipairs({'position','direction','up','fov','fog','offset','eyeOffset'}) do
                        for _,v in ipairs(bg[field]) do values[#values+1]=('%.17g'):format(v) end
                    end
                    for _,m in ipairs(bg.models) do for _,v in ipairs(m.vms) do
                        for _,field in ipairs({'id','pc','time','sprite','visible','finished','stopped','u','v','blend'}) do values[#values+1]=tostring(v[field]) end
                        for _,field in ipairs({'position','rotation','scale','color','alpha','color2','alpha2','omega','growth'}) do
                            for _,n in ipairs(v[field]) do values[#values+1]=('%.17g'):format(n) end
                        end
                    end end
                    end
                    results[#results+1]={id=id,state=SaveCodec.sha256(table.concat(values,','))}
                    lstg.SystemLog('BOSSRUSH_BACKGROUND_SAMPLE: '..id)
                elseif age>=8 then
                    local path='snapshot/background-'..current.game..'_'..current.key..'_'..current.time..'.png'
                    local f=io.open(path,'rb');local complete=false
                    if f then local size=f:seek('end');if size>=12 then f:seek('end',-12);complete=f:read('*a')=='\0\0\0\0IEND\174B`\130' end;f:close() end
                    if complete then nextCase() else assert(age<600,'截图异步写入超时：'..path) end
                end
            end
            function scene:render()
                SetViewMode('ui');RenderClear(Color(255,0,0,0))
                if not current then return end
                if current.game==0 then
                    for fog=0,3 do for _,blend in ipairs({'add+alpha','add+add'}) do for _,alpha in ipairs({0,64,128,255}) do
                        local i=fog*8+(blend=='add+add' and 4 or 0)+(alpha==0 and 0 or alpha==64 and 1 or alpha==128 and 2 or 3)
                        local x,y=12+i%8*64,screen.height/2+math.floor(i/8)*60
                        SetPerspective(x+20,y+20,10.5,x+20,y+20,.5,0,1,0,1,1,.1,100)
                        SetViewMode('ui');SetFog();SetImageState('white','',Color(255,20,40,60));RenderRect('white',x,x+40,y,y+40)
                        if fog==1 then SetFog(0,20,Color(255,32,64,96)) elseif fog==2 then SetFog(-1,math.log(2)/10,Color(255,32,64,96))
                        elseif fog==3 then SetFog(-2,math.sqrt(math.log(2))/10,Color(255,32,64,96)) end
                        SetImageState('white',blend,Color(alpha,64,128,192));RenderRect('white',x,x+40,y,y+40)
                    end end end
                    SetFog()
                else B.render(bg) end
                SetViewMode('world')
                SetImageState('white','',Color(255,255,32,16));RenderRect('white',-190,-182,-222,-214)
            end
            plus.CreateDirectory('snapshot')
            lstg.SystemLog('BOSSRUSH_CASE_BEGIN: '..mode)
            stage.Set('none','android_background_probe')
        end
        return quit
    end
end
return T
