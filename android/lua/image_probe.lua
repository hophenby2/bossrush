-- 只在私有images诊断中，将源PNG与入包贴图在相同混合条件下并排绘制。
local T={}
function T.install(mode)
    local file=assert(io.open('User/image-probe/list.tsv','rb'))
    local paths={};for line in file:lines() do paths[#paths+1]=line end;file:close()
    local frame,started=FrameFunc,false
    FrameFunc=function()
        local quit=frame()
        if not started and stage.current_stage.stage_name=='menu' and stage.current_stage.timer>=45 then
            started=true
            local scene=stage.New('android_images',true,true)
            local index,done,age,packed=0,false,0,false
            local function nextImage()
                if index>0 then RemoveResource('stage',1,'probe:source');RemoveResource('stage',1,'probe:packed') end
                index=index+1
                age,packed=0,false
                if index>#paths then
                    done=true;lstg.SystemLog('BOSSRUSH_CONTENT_DONE: images='..#paths..' '..mode);return
                end
                SetResourceStatus('stage')
                LoadTexture('probe:source','User/image-probe/'..index..'.png')
                LoadTexture('probe:packed',paths[index])
                local w,h=GetTextureSize('probe:source');local x,y=GetTextureSize('probe:packed')
                assert(w==x and h==y,'入包贴图尺寸发生变化：'..paths[index])
            end
            function scene:init() nextImage() end
            function scene:frame()
                if done then return end
                age=age+1
                if age==6 then Snapshot(('snapshot/android-image-%03d-source.png'):format(index)) end
                if age==7 then packed=true end
                if age==12 then Snapshot(('snapshot/android-image-%03d-packed.png'):format(index)) end
                if age==13 then nextImage() end
            end
            function scene:render()
                SetViewMode('ui');RenderClear(Color(255,18,18,18))
                if done then return end
                for side=0,1 do
                    local texture=(side==0 or not packed) and 'probe:source' or 'probe:packed'
                    local w,h=GetTextureSize(texture)
                    local left,right=6+side*270,264+side*270
                    for row=0,1 do
                        local bottom,top=32+row*274,290+row*274
                        for y=0,7 do for x=0,7 do
                            local c=(x+y)%2==0 and 64 or 192
                            SetImageState('white','',Color(255,c,c,c))
                            RenderRect('white',left+x*258/8,left+(x+1)*258/8,bottom+y*258/8,bottom+(y+1)*258/8)
                        end end
                        local color=Color(row==0 and 128 or 255,255,255,255)
                        RenderTexture(texture,row==0 and 'mul+add' or '',
                            {left,top,.5,0,0,color},{right,top,.5,w,0,color},
                            {right,bottom,.5,w,h,color},{left,bottom,.5,0,h,color})
                    end
                end
                RenderTTF('title',('PNG / packed  %d/%d'):format(index,#paths),270,590,Color(255,255,255,255),'centerpoint')
            end
            plus.CreateDirectory('snapshot')
            lstg.SystemLog('BOSSRUSH_CONTENT_BEGIN: '..mode)
            stage.Set('none','android_images')
        end
        return quit
    end
end
return T
