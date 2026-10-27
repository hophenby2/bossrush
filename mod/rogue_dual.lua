-- 双 Boss 专用实例环境：原卡的弹池、子机列表与清场函数不得跨实例共享。
local D={}
local files={TH31='mod/GAME/th31.lua',TH34='mod/GAME/th34.lua',TH35='mod/GAME/th35.lua'}
local compiled={}
local unpack=unpack
local realNew,realBullet,realList=New,NewSimpleBullet,ObjList
local realValid,realTask,realObject=IsValid,task,object
local baseBoss=boss
local function proxy(base) return setmetatable({},{__index=base}) end
local function callback(ctx,fn,b,...)
    if not fn then return end
    -- before 允许等待；每次恢复协程时在原坐标中执行，再将出场位置平移回屏幕。
    local args={...}
    local co=coroutine.create(function() return fn(b,unpack(args)) end)
    while true do
        if realValid(b) then b.x=b.x-ctx.dx end
        local values={coroutine.resume(co)}
        if realValid(b) then b.x=b.x+ctx.dx;b.__NoCleanBullet=true end
        if not values[1] then error(debug.traceback(co,tostring(values[2])),0) end
        if coroutine.status(co)=='dead' then return unpack(values,2) end
        coroutine.yield(unpack(values,2))
    end
end
function D.context(source,dx)
    local path=assert(files[source],'未知双 Boss 卡源')
    local ctx={dx=dx,source=source,objects=setmetatable({},{__mode='k'}),serial=0,units={}}
    local env=proxy(_G);env._G=env;ctx.env=env
    env._editor_class=proxy(_editor_class);env._editor_boss={}
    env._sc_table={};env._sc_pr_table=ctx.units
    function ctx:owns(o) return realValid(o) and o._rogue_owner==self end
    function ctx:track(o)
        if realValid(o) then
            self.serial=self.serial+1;o._rogue_owner=self;o._rogue_order=self.serial;self.objects[o]=true
        end
        return o
    end
    function ctx:cleanup()
        if next(self.objects)==nil then return end
        local live={}
        for o in pairs(self.objects) do if o~=self.root and realValid(o) then live[#live+1]=o end end
        -- 弱引用避免持有已经消亡的每颗子弹；按出生顺序回收，保证重建顺序一致。
        table.sort(live,function(a,b) return a._rogue_order<b._rogue_order end)
        for _,o in ipairs(live) do realTask.Clear(o);realObject.RawDel(o) end
        self.objects=setmetatable({},{__mode='k'})
    end
    env.New=function(class,...) return ctx:track(realNew(class,...)) end
    env.NewSimpleBullet=function(...) return ctx:track(realBullet(...)) end
    env.ObjList=function(group)
        local iterator,state,initial=realList(group);local cursor=initial
        return function()
            while true do
                local index,o=iterator(state,cursor);cursor=index
                if index==nil then return end
                if ctx:owns(o) then return index,o end
            end
        end
    end
    env.UnitList=env.ObjList
    env.object=proxy(realObject)
    for _,name in ipairs({'BulletDo','IndesDo','BulletIndesDo','EnemyDo','NontjtDo','EnemyNontjtDo','LaserDo'}) do
        local operation=realObject[name]
        if operation then env.object[name]=function(fn) return operation(function(o) if ctx:owns(o) then fn(o) end end) end end
    end
    env.lstg=proxy(lstg);env.lstg.ObjList=env.ObjList
    env.lstg.tmpvar=setmetatable({}, {__index=function(_,k) if k=='boss' then return ctx.root end;return lstg.tmpvar[k] end,
        __newindex=function(_,k,v) if k~='boss' then lstg.tmpvar[k]=v end end})
    local facade=proxy(baseBoss);env.boss=facade;facade.card=proxy(baseBoss.card)
    function facade.Define(editname,name,bgm,bg,xy,scbg,img,level,scale)
        local class=Class(baseBoss,{cards={},name=name,StageLevel=level,bgm=bgm,_bg=bg,difficulty='All',id=editname..level,
            init=function(b,cards)
                ctx.root=b;env._boss=b
                baseBoss.init(b,xy[1]+dx,xy[2],cards,scbg,'All',name,img)
                b.otherboss={};b.ID=string.sub(editname,1,-2);b.__NoCleanBullet=true
                b._rogue_dx=dx;b._rogue_source=source
                if scale then b.hscale=scale;b.vscale=scale end
            end})
        env._editor_boss[editname..level]=class
    end
    function facade.DefineGroup(index,group,bgm,bg,scbg,level)
        for _,b in ipairs(index) do facade.Define(group..b.id,b.name,bgm,bg,{b.x,b.y},scbg,b.img,level,b.scale) end
    end
    function facade.card.add(parts,level,label,id,od,inotherstage)
        local unit={CardName=label,sc_group={}}
        for _,part in ipairs(parts) do
            local card,class=part[1],assert(env._editor_boss[part[2]..level])
            card.card_id=id;card.locked_id=od;card.inotherstage=inotherstage
            unit.sc_group[#unit.sc_group+1]={card=card,boss=class}
            class.cards[#class.cards+1]=card
        end
        ctx.units[level]=ctx.units[level] or {};table.insert(ctx.units[level],unit)
    end
    -- 字节码可复用；每次执行都重新建立闭包和可变上值，不复用上一张卡的弹池。
    if not compiled[source] then
        local f=assert(io.open(path,'rb'));local text=f:read('*a');f:close()
        compiled[source]=string.dump(assert(loadstring(text:gsub('^\239\187\191',''),'@'..path)))
    end
    local chunk=assert(loadstring(compiled[source],'@'..path));setfenv(chunk,env);chunk()
    InitAllClass()
    function ctx:spawn(entry)
        local unit=assert(self.units[entry.level] and self.units[entry.level][entry.index],'双 Boss 卡片已移除')
        assert(#unit.sc_group==1,'双 Boss 模式要求每个抽取单元只有一个 Boss')
        local part=unit.sc_group[1];local card=part.card
        assert(card.card_id==entry.cardId,'双 Boss 卡片编号与目录不一致')
        local before,init,del=card.before,card.init,card.del
        card.before=function(b) return callback(self,before,b) end
        card.init=function(b)
            callback(self,init,b)
            if realValid(b) then
                b._rogue_initial_x,b._rogue_initial_y=b.x,b.y
                if lstg.SystemLog then lstg.SystemLog(string.format('BOSSRUSH_DUAL: ready %s dx=%d x=%.3f y=%.3f',entry.key,self.dx,b.x,b.y)) end
            end
        end
        card.del=function(b)
            if del then del(b) end
            self:cleanup()
        end
        local b=self:track(realNew(part.boss,{card}))
        if lstg.SystemLog then lstg.SystemLog(string.format('BOSSRUSH_DUAL: spawn %s id=%s dx=%d x=%.3f y=%.3f',entry.key,tostring(entry.cardId),self.dx,b.x,b.y)) end
        return b
    end
    return ctx
end
RogueDualRuntime=D
return D
