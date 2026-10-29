-- 击破阶段后的弹幕二选一。成长和选择过程都保存在 var 中，供录像与关内恢复重建。
local D={VERSION=1,UNIT=100,TIME=500,MIN=100,MAX=100000}
-- 数值以百分之一为整数单位；只做加法和有理数乘法，避免长局累计浮点误差。
D.pool={
    {{'red','add',5}},{{'blue','add',5}},{{'red','mul',11,10}},{{'blue','mul',11,10}},
    {{'red','add',10},{'blue','add',-5}},{{'red','add',-5},{'blue','add',10}},
    {{'red','add',15},{'blue','add',-10}},{{'red','add',-10},{'blue','add',15}},
    {{'red','mul',6,5},{'blue','mul',9,10}},{{'red','mul',9,10},{'blue','mul',6,5}},
}
local function fresh() return {red=10000,blue=10000,clock=-1,fraction=0} end
local function allowDrops(scene)
    scene=scene or (stage and stage.current_stage)
    return not (scene and scene.group and scene.group._name=='RogueChain')
end
function D.enabled() return lstg.var.__drops_version==D.VERSION end
function D.reset()
    lstg.var.upgrades=D.enabled() and {version=D.VERSION,seed=lstg.var.ran_seed or 1,count=0,players={fresh(),fresh()},queue={}} or nil
end
local function peek() return D.enabled() and lstg.var.upgrades end
function D.active()
    local s=peek();return s and s.active~=nil and stage.current_stage and not stage.current_stage.is_menu
end
local function ensure()
    if not D.enabled() then return end
    local s=peek();if not s then D.reset();s=peek() end;return s
end
function D.slot(o)
    if type(o)=='number' then return o==2 and 2 or 1 end
    if type(o)=='table' then
        local slot=o._drop_owner or o._net_slot
        if slot==1 or slot==2 then return slot end
    end
    return 1
end
-- HUD 只读，不能因渲染而改变零帧保存点。
function D.values(o)
    local s=peek();local p=s and s.players[D.slot(o)]
    return p and p.red/100 or 100,p and p.blue/100 or 100
end
function D.power(o) local red=D.values(o);return D.enabled() and red/100 or 1 end
function D.rate(o) local _,blue=D.values(o);return D.enabled() and blue/100 or 1 end
function D.damage(amount,o) return amount*D.power(o) end
function D.renderBullet(o)
    local factor=D.power(o)
    if factor==1 then return DefaultRenderFunc(o) end
    -- 只在绘制时放大，保持原始缩放、碰撞半径与命中倍率；联机捕获实际绘制尺寸。
    local h,v=o.hscale,o.vscale;o.hscale=h*factor;o.vscale=v*factor
    local ok,result=pcall(DefaultRenderFunc,o)
    o.hscale=h;o.vscale=v
    if not ok then error(result,0) end
    return result
end
function D.bind(p)
    local s=ensure();if not s then return end
    local c=s.players[D.slot(p)];c.clock=(p.timer or 0)-1;c.fraction=0;p._drop_first_frame=true
end
function D.playerStep(p)
    local s=ensure();if not s then return end
    local c=s.players[D.slot(p)]
    if p._drop_first_frame then c.clock=(p.timer or 0)-1;p._drop_first_frame=false end
    c.fraction=c.fraction+c.blue
    local steps=math.floor(c.fraction/10000);c.fraction=c.fraction-steps*10000
    p._drop_shot_first=c.clock+1;c.clock=c.clock+steps;p._drop_shot_last=c.clock;p._drop_shot_steps=steps;p._drop_cooldown_done=false
end
function D.shoot(p,fn)
    if not D.enabled() then return fn(p) end
    local timer=p.timer;p._drop_cooldown_done=true
    local ok,err=pcall(function()
        for t=p._drop_shot_first or timer,p._drop_shot_last or timer do
            p.timer=t
            if p.nextshoot<=0 then fn(p) end
            p.nextshoot=math.max(0,p.nextshoot-1)
        end
    end)
    p.timer=timer
    if not ok then error(err,0) end
end
function D.cooldownStep(p)
    if not D.enabled() then return 1 end
    return p._drop_cooldown_done and 0 or (p._drop_shot_steps or 1)
end
function D.beginCard(b,card)
    b._drop_awarded=false;b._drop_card_id=card.card_id
    local uses=rawget(b,'_drop_uses') or {};b._drop_uses=uses
    if card.card_id then uses[card.card_id]=(uses[card.card_id] or 0)+1;b._drop_phase=uses[card.card_id] end
end
function D.draw(seed,index)
    local gen=Rand();gen:Seed((seed+index*104729)%2147483647)
    local a=gen:Int(1,#D.pool);local b=gen:Int(1,#D.pool-1);if b>=a then b=b+1 end
    return {a,b}
end
function D.award(b)
    if not allowDrops() then return false end
    local s=ensure()
    if not s or not b.is_combat or b.cannot_kill or b._drop_awarded or (b.timeout and not b.time_sc) then return false end
    if not b.current_card or b.current_card.is_combat==false then return false end
    b._drop_awarded=true
    local id,phase=b._drop_card_id,b._drop_phase or 1
    local awards=rawget(b,'_drop_awards') or {}
    if id and (awards[id] or 0)>=phase then return false end
    local function mark(other)
        if not id then return end
        local seen=rawget(other,'_drop_awards') or {};seen[id]=math.max(seen[id] or 0,phase);rawset(other,'_drop_awards',seen)
    end
    mark(b);for _,other in ipairs(b.otherboss or {}) do mark(other) end
    s.count=s.count+1;s.queue[#s.queue+1]={id=s.count,options=D.draw(s.seed,s.count),age=0,picks={false,false}}
    return true
end
function D.apply(slot,option)
    local s=assert(ensure());local p=s.players[D.slot(slot)]
    for _,op in ipairs(assert(D.pool[option])) do
        local value=p[op[1]]
        if op[2]=='add' then value=value+op[3]*100 else value=math.floor(value*op[3]/op[4]+0.5) end
        p[op[1]]=math.max(D.MIN,math.min(D.MAX,value))
    end
end
local function players()
    if GameNet and GameNet.host() then return GameNet.players end
    return {player}
end
local function controllable(p)
    return p and IsValid(p) and not p.lock and not p.dialog and not p.realrealreal_lock and not p.hide and (p.death or 0)==0
end
function D.rowY(row) return GameQuiz.CHOICE_Y-GameQuiz.offset(row.age) end
function D.frame(scene)
    local s=peek()
    if not s or not scene or scene.is_menu then GameQuiz.clearSelection('drops');return false end
    if not allowDrops(scene) then
        -- 兼容已有检查点中排队 / 正在下落的选项，接续战斗不再为强化选择冻结。
        if s.active or #s.queue>0 then s.active=nil;s.queue={} end
        GameQuiz.clearSelection('drops',true);return false
    end
    local ps=players()
    if not s.active and #s.queue>0 then
        -- 死亡、对话或过场仍正常推进，等两位玩家都能移动后再开始下落。
        for i=1,(GameNet and GameNet.host()) and 2 or 1 do if not controllable(ps[i]) then return false end end
        s.active=table.remove(s.queue,1);s.active.previous={}
        for i,p in ipairs(ps) do s.active.previous[i]={x=p.x,y=p.y} end
    end
    local row=s.active;if not row then return false end
    local oldAge=row.age;row.age=row.age+1
    GameQuiz.selection('drops',row,nil,{D.optionLines(row.options[1]),D.optionLines(row.options[2])})
    local count=(GameNet and GameNet.host()) and 2 or 1;local complete=true
    for i=1,count do
        local p=ps[i]
        if controllable(p) then
            GameQuiz.move(p,p.key or KeyState)
            local previous=row.previous[i] or {x=p.x,y=p.y}
            if not row.picks[i] then
                local choice=GameQuiz.contact(previous,p,oldAge,row.age,2)
                if choice then
                    row.picks[i]=choice;D.apply(i,row.options[choice]);p.protect=math.max(p.protect or 0,60)
                    PlaySound('item00',0.5)
                end
            end
            row.previous[i]={x=p.x,y=p.y}
        end
        if not row.picks[i] then complete=false end
    end
    if complete or row.age>=D.TIME then GameQuiz.clearSelection('drops',true);s.active=nil end
    return true
end
local function number(value)
    return (string.format('%.2f',value):gsub('%.?0+$',''))
end
function D.optionLines(id)
    local out={}
    for _,op in ipairs(D.pool[id]) do
        local text=op[2]=='add' and string.format('%+d',op[3]) or ('×'..number(op[3]/op[4]))
        out[#out+1]={color=op[1],text=(op[1]=='red' and '红 ' or '蓝 ')..text}
    end
    return out
end
function D.render()
    -- 选项由共用 Question / Choice 与中玉实体随 ObjRender 绘制，不再叠加面板。
end
function D.renderHUD(scrr,scrt,alpha)
    if not D.enabled() then return end
    local count=(GameNet and GameNet.host()) and 2 or 1
    for i=1,count do
        local red,blue=D.values(i);local y=scrt-240-(i-1)*24;local label=count==2 and ('P'..i..' ') or ''
        ui:RenderText('title',label..'火力 '..number(red),scrr+6,y,0.65,Color(alpha,255,120,125),'left','bottom')
        ui:RenderText('title','射速 '..number(blue),scrr+150,y,0.65,Color(alpha,110,190,255),'left','bottom')
    end
end
function D.signature()
    local s=peek();if not s then return 'drops=none' end
    local out={'drops',s.seed,s.count}
    for _,p in ipairs(s.players) do out[#out+1]=table.concat({p.red,p.blue,p.clock,p.fraction},',') end
    local function row(r)
        out[#out+1]=table.concat({r.id,r.age,r.options[1],r.options[2],tostring(r.picks[1]),tostring(r.picks[2])},',')
        for _,p in ipairs(r.previous or {}) do out[#out+1]=string.format('%.6f,%.6f',p.x,p.y) end
    end
    if s.active then row(s.active) else out[#out+1]='no-active' end
    for _,r in ipairs(s.queue) do row(r) end
    return table.concat(out,';')
end
GameDrops=D
return D
