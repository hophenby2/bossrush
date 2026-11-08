-- 真实引擎捕获缓时窗口内的背景VM及画面，避免固定t300/t900截图错过短暂反色遮罩。
local rows,pending={},nil
local function save()
    local file=assert(io.open('slow-result.json','w'));file:write(Serialize(rows));file:close()
end
local render=EndScene
EndScene=function()
    local result=render()
    if pending then Snapshot('snapshot/'..pending..'.png');pending=nil;save() end
    return result
end
function SlowNeedRender() return pending~=nil end
local function background()
    for _,o in ObjList(GROUP.GHOST) do
        if o._original_background and o._original_background_game==7 and o.active then return o end
    end
end
return function(owner,frames,current)
    local id=tostring(current.cardId)
    local row=rows[id]
    if not row then row={activeFrames=0,normalFrames=0};rows[id]=row end
    if owner.th07_slow_active then
        row.first=row.first or frames
        row.activeFrames=row.activeFrames+1
        row.factor=lstg.var.timeslow
        if row.activeFrames~=8 then return end
        local overlay=0
        for _,o in ObjList(GROUP.GHOST) do
            if o.owner==owner and o.class==_editor_class.TH34.TH34_slow_effect then overlay=overlay+1 end
        end
        row.overlays=overlay
        local bg=assert(background(),'缓时期间缺少原作背景')
        row.slow={}
        for i,vm in ipairs(bg.vms) do
            row.slow[i]={alpha=vm.alpha[1],color=vm.color,omega=vm.omega[3],rotation=vm.rotation[3],blend=vm.blend}
        end
        row.slowFrame=frames;pending='slow-'..id..'-active'
    elseif row.activeFrames>0 and not row.restored then
        row.normalFrames=row.normalFrames+1
        if row.normalFrames~=8 then return end
        local bg=assert(background(),'恢复后缺少原作背景')
        row.normal={}
        for i,vm in ipairs(bg.vms) do
            row.normal[i]={alpha=vm.alpha[1],color=vm.color,omega=vm.omega[3],blend=vm.blend}
        end
        row.restored=true;row.normalFactor=lstg.var.timeslow
        pending='slow-'..id..'-restored'
    end
end
