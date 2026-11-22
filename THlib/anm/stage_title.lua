-- 关卡 GUI 在场景载入时启动的 ANM，和 ECL 发弹对象分开管理。
-- 源入口：TH07 Gui.cpp 的 stageTextVm、TH08 Gui::Initialize、TH10 Gui.cpp 的 stageUiAnm。
local M={}
local A=OriginalANM
local function alive(v)
    if not v.finished or v.visible then return true end
    for _,child in ipairs(v.children) do if alive(child) then return true end end
    return false
end
local Title=Class(object,{
    init=function(o,game,archive,count,index)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.TOP-10,false,false
        o.game,o.index=game,index
        o.vms={}
        for i=0,count-1 do o.vms[#o.vms+1]=A.new(game,archive,i) end
    end,
    frame=function(o)
        local active=false
        for _,v in ipairs(o.vms) do
            A.step(v)
            if alive(v) then active=true end
        end
        if not active then object.RawDel(o) end
    end,
    render=function(o)
        for _,v in ipairs(o.vms) do A.draw(v,o.game==6 and -192 or -224,o.game==6 and 224 or 240,0,1,1,1) end
        if o.game==6 and o.vms[1].visible then
            local text=o.index<6 and ('STAGE '..o.index) or o.index==6 and 'FINAL STAGE' or 'EXTRA STAGE'
            local x=o.index<6 and 168 or 136
            for i=1,#text do
                local c=text:byte(i)
                if c~=32 then
                    local s=A.sprite_resource{data=A.load(6,'ascii'),sprite=c-21}
                    SetImageState(s.img,'',o.vms[1].alpha[1],255,255,64)
                    Render(s.img,x-224+s[4]/2,240-198-s[5]/2)
                end
                x=x+14
            end
        end
    end,
})
function M.start(game,key)
    local index=tonumber(key:match('(%d+)$'))
    if game==6 then return New(Title,game,'stage_title'..index,2,index)
    elseif game==7 then return New(Title,game,'std'..index..'txt',5)
    elseif game==8 then
        local archive=({stage4a='stg4atxt',stage4b='stg4btxt'})[key] or 'stg'..index..'txt'
        return New(Title,game,archive,4)
    elseif game==10 then return New(Title,game,('st%02dlogo'):format(index),2) end
end
return M
