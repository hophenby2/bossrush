-- 设置中的空场地预览。只编辑触控/HUD坐标，不创建自机、敌人或录像。
return function(P)
    local E={}
    local ids={'slow','bomb','life','bombs'}
    local names={slow='低速按钮',bomb='Bomb 按钮',life='残机显示',bombs='雷显示'}
    local function copy(value) return DeSerialize(Serialize(value or {})) end
    local function rect(x1,x2,y1,y2,color)
        SetImageState('white','',color);RenderRect('white',x1,x2,y1,y2)
    end
    local function text(value,x,y,size,color)
        ui:RenderText('title',value,x,y,size,color or Color(255,235,241,247),'center','vcenter')
    end
    function E.open(owner)
        P.clearInput();P.layoutWorld()
        return setmetatable({owner=owner,draft=copy(cur_setting.androidPortraitLayout),opened=true},{__index=E})
    end
    function E:close(save)
        if save then
            -- 设置页每帧会重新读取配置，两份内存配置和磁盘必须一同更新。
            cur_setting.androidPortraitLayout=copy(self.draft)
            setting.androidPortraitLayout=copy(self.draft)
            save_setting()
        end
        P.editor=nil;P.restoreWorld();AndroidInput.reset(true)
        PlaySound(save and 'ok00' or 'cancel00',.3)
    end
    function E:frame()
        -- 忽略打开页面所用的同一帧确认键，避免立即保存退出。
        if self.opened then self.opened=false;return end
        local key=GetLastKey()
        if key==27 then self:close(false)
        elseif key==13 then self:close(true) end
    end
    function E:move(id,x,y,phase)
        if phase=='began' then
            local px,py=P.elementPosition(id,self.draft)
            self.drag={id=id,dx=px-x,dy=py-y}
        end
        local drag=self.drag
        if not drag or drag.id~=id then return end
        local w=lstg.world
        self.draft[id]={x=(x+drag.dx-w.scrl)/(w.scrr-w.scrl),y=(y+drag.dy-w.scrb)/(w.scrt-w.scrb)}
        local px,py=P.elementPosition(id,self.draft)
        self.draft[id]={x=(px-w.scrl)/(w.scrr-w.scrl),y=(py-w.scrb)/(w.scrt-w.scrb)}
        if phase=='ended' or phase=='cancelled' then self.drag=nil end
    end
    function E:render()
        P.menuView=nil;P.modal=self.owner
        SetViewMode('ui')
        rect(0,screen.width,0,screen.height,Color(255,0,0,0))
        local w=lstg.world
        rect(w.scrl,w.scrr,w.scrb,w.scrt,Color(255,15,23,35))
        SetImageState('white','',Color(160,105,136,163))
        misc.RenderOutLine('white',w.scrl+1,w.scrr-1,w.scrb+1,w.scrt-1,0,1)
        text('竖屏战斗布局',screen.width/2,screen.height-38,1.2)
        text('拖动按钮和残机、雷显示来调整位置',screen.width/2,screen.height-76,.75)
        text('空场地预览',screen.width/2,(w.scrb+w.scrt)/2,.8,Color(100,175,198,215))
        for _,id in ipairs(ids) do
            local key=id
            local x,y=P.elementPosition(id,self.draft)
            local button=id=='slow' or id=='bomb'
            local x1,x2,y1,y2=x-(button and 32 or 14),x+(button and 32 or 105),y-(button and 32 or 18),y+(button and 32 or 18)
            if button then
                P.drawSlowButton({x=x,y=y},id=='slow')
                text(id=='slow' and '低速 开' or 'Bomb',x,y,.75,id=='slow' and Color(255,12,50,28) or nil)
            else P.drawInventory(id,x,y,id=='life' and 10 or 3,255) end
            SetImageState('white','',self.drag and self.drag.id==id and Color(255,255,222,120) or Color(155,130,183,209))
            misc.RenderOutLine('white',x1,x2,y1,y2,0,1)
            P.bind(self.owner,x1,x2,y1,y2,function()end,function(px,py,phase) self:move(key,px,py,phase) end)
        end
        if self.drag then text(names[self.drag.id],screen.width/2,100,.8,Color(255,255,222,120)) end
        for i,entry in ipairs({{'取消',function()self:close(false)end},{'恢复默认',function()self.draft={};self.drag=nil end},{'保存',function()self:close(true)end}}) do
            local x=screen.width/2+(i-2)*166
            rect(x-74,x+74,32,78,i==3 and Color(255,30,99,67) or Color(255,32,52,72))
            text(entry[1],x,55,.85)
            P.bind(self.owner,x-74,x+74,32,78,entry[2])
        end
    end
    return E
end
