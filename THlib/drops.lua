-- 击破或超时阶段后的紫黄蓝三选一。成长和选择过程都保存在var中，供录像与关内恢复重建。
local D={VERSION=8,UNIT=100,TIME=2*60,MIN=100,MAX=100000,HITBOX_MIN=2500,BOMB_FRAMES=30*60,BOMB_MAX=9,BOMB_INITIAL=3}
-- red/green/blue保留为成长逻辑键；条、文字、遮罩和选项中玉共用显示配色。
D.palette={red={205,145,255,name='紫',bullet=4},green={255,225,100,name='黄',bullet=12},blue={110,190,255,name='蓝',bullet=6}}
-- 数值以百分之一为整数单位；只做加法和有理数乘法，避免长局累计浮点误差。
D.pool={
    {{'red','add',5}},{{'blue','add',5}},{{'red','mul',11,10}},{{'blue','mul',11,10}},
    {{'red','add',10},{'blue','add',-5}},{{'red','add',-5},{'blue','add',10}},
    {{'red','add',15},{'blue','add',-10}},{{'red','add',-10},{'blue','add',15}},
    {{'red','mul',6,5},{'blue','mul',9,10}},{{'red','mul',9,10},{'blue','mul',6,5}},
}
-- 前十项沿用红蓝版本的编号；绿色降低原判定尺寸的百分比，避免改写旧录像的选项含义。
D.colorPool={
    {{'red','add',5}},{{'blue','add',5}},{{'red','add',10}},{{'blue','add',10}},
    {{'red','add',15}},{{'blue','add',15}},{{'red','mul',11,10}},{{'blue','mul',11,10}},
    {{'red','mul',6,5}},{{'blue','mul',6,5}},
    {{'green','add',-5}},{{'green','add',-10}},{{'green','add',-15}},
    {{'green','mul',9,10}},{{'green','mul',4,5}},
}
local function three() local v=lstg.var.__drops_version;return v and v>=3 and v<=D.VERSION end
local function modern() return three() or lstg.var.__drops_version==2 end
-- 库存规则进入初态版本，旧录像的三枚上限不能因新UI改动而变成九枚。
function D.bombLimit() local v=lstg.var.__drops_version;return v and v>=5 and v<=D.VERSION and D.BOMB_MAX or 3 end
local function fresh()
    local p={red=10000,blue=10000,clock=-1,fraction=0}
    if modern() then p.bombs=D.BOMB_INITIAL;p.bomb_fraction=0 end
    if three() then p.green=10000 end
    return p
end
local function allowDrops(scene)
    scene=scene or (stage and stage.current_stage)
    return not (scene and scene.group and scene.group._name=='RogueChain')
end
function D.enabled() return modern() or lstg.var.__drops_version==1 end
D.bombsEnabled=modern
function D.reset()
    lstg.var.upgrades=D.enabled() and {version=lstg.var.__drops_version,seed=lstg.var.ran_seed or 1,count=0,players={fresh(),fresh()},queue={}} or nil
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
    return p and p.red/100 or 100,p and p.blue/100 or 100,p and (p.green or 10000)/100 or 100
end
function D.hitboxScale(o)
    if not three() then return 1 end
    local _,_,green=D.values(o)
    return green/100
end
function D.updateHitbox(p)
    if not three() and not p._drop_hitbox then return end
    local box=p._drop_hitbox
    if not box then box={baseA=p.A,baseB=p.B};p._drop_hitbox=box
    else
        -- 行走图每帧会把A/B复制给a/b；只保存未缩小的基础值，不能逐帧重复相乘。
        if p.A~=box.A then box.baseA=p.A end
        if p.B~=box.B then box.baseB=p.B end
    end
    local scale=D.hitboxScale(p)
    box.A,box.B=box.baseA*scale,box.baseB*scale
    p.A,p.B=box.A,box.B
    p.a,p.b=box.A,box.B -- 原作手动激光/体术读A/B，引擎普通弹判定读a/b。
end
function D.laserInset(p,angle)
    local box=p._drop_hitbox
    if not three() or not box or box.A==box.baseA and box.B==box.baseB then return 0 end
    local a=angle*math.pi/180
    local x,y=math.abs(math.sin(a)),math.abs(math.cos(a))
    local function radius(w,h)
        if p.rect then return w*x+h*y end
        return math.sqrt((w*x)^2+(h*y)^2)
    end
    -- 旧直线激光直接比较自机中心到光轴的距离；扣除缩小量，100%时沿用原阈值。
    return math.max(0,radius(box.baseA,box.baseB)-radius(box.A,box.B))
end
function D.power(o) local red=D.values(o);return D.enabled() and red/100 or 1 end
function D.rate(o) local _,blue=D.values(o);return D.enabled() and not modern() and blue/100 or 1 end
function D.recoveryRate(o) local _,blue=D.values(o);return modern() and blue/100 or 1 end
function D.bombState(o)
    local s=peek();local p=s and s.players[D.slot(o)]
    return p and p.bombs or 0,p and (p.bomb_fraction or 0)/(D.BOMB_FRAMES*10000) or 0
end
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
    if modern() then
        -- 满库存不积攒额外恢复量；恢复使用整数，蓝色只参与 Bomb 计时。
        local limit=D.bombLimit()
        if c.bombs<limit then
            c.bomb_fraction=c.bomb_fraction+c.blue
            local unit=D.BOMB_FRAMES*10000;local restored=math.floor(c.bomb_fraction/unit)
            c.bombs=math.min(limit,c.bombs+restored)
            c.bomb_fraction=c.bombs==limit and 0 or c.bomb_fraction-restored*unit
        else c.bomb_fraction=0 end
        return
    end
    c.fraction=c.fraction+c.blue
    local steps=math.floor(c.fraction/10000);c.fraction=c.fraction-steps*10000
    p._drop_shot_first=c.clock+1;c.clock=c.clock+steps;p._drop_shot_last=c.clock;p._drop_shot_steps=steps;p._drop_cooldown_done=false
end
function D.shoot(p,fn)
    if not D.enabled() or modern() then return fn(p) end
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
    if not D.enabled() or modern() then return 1 end
    return p._drop_cooldown_done and 0 or (p._drop_shot_steps or 1)
end
function D.bombInput(p,key,previous)
    if not modern() or not key.spell or previous.spell then return false end
    local death=p.death or 0
    -- death<50已恢复操作，protect只是无敌计时；不能把复活后的可操作阶段当作死亡演出。
    if p.lock or p.dialog or p.realrealreal_lock or p.hide or p.time_stop or (death>=50 and death<=90) then return false end
    local s=ensure();local c=s.players[D.slot(p)]
    if c.bombs<1 then return false end
    c.bombs=c.bombs-1
    lstg.system:castCharge4(p)
    return true
end
function D.beginCard(b,card)
    b._drop_awarded=false;b._drop_card_id=card.card_id
    b._drop_misses=nil
    local uses=rawget(b,'_drop_uses') or {};b._drop_uses=uses
    if card.card_id then uses[card.card_id]=(uses[card.card_id] or 0)+1;b._drop_phase=uses[card.card_id] end
end
local function misses() return GameRevive and GameRevive.misses() or lstg.var.dead or 0 end
function D.startCard(b)
    -- before演出结束才开始计数；Bomb/Circle_Attack会清掉chip_bonus，不能借收卡标记判断无中弹。
    b._drop_misses=misses()
end
function D.avoided(b)
    if b._drop_misses==nil then return not not b.chip_bonus end
    return misses()==b._drop_misses
end
function D.draw(seed,index)
    local gen=Rand();gen:Seed((seed+index*104729)%2147483647)
    if three() then
        -- 保留红、蓝、绿的抽样顺序；新版只交换前两列，旧录像仍按原位置接取。
        local red,blue,green=gen:Int(1,5)*2-1,gen:Int(1,5)*2,gen:Int(11,15)
        if lstg.var.__drops_version>=4 then return {blue,red,green} end
        return {red,blue,green}
    end
    if modern() then return {gen:Int(1,5)*2-1,gen:Int(1,5)*2} end
    local a=gen:Int(1,#D.pool);local b=gen:Int(1,#D.pool-1);if b>=a then b=b+1 end
    return {a,b}
end
function D.award(b,avoided_timeout)
    if not allowDrops() then return false end
    local s=ensure()
    if not s or not b.is_combat or b.cannot_kill or b._drop_awarded then return false end
    if not b.current_card or b.current_card.is_combat==false then return false end
    if b.timeout and not b.time_sc and lstg.var.__drops_version<8 then
        if avoided_timeout==nil then avoided_timeout=D.avoided(b) end
        -- 第八版起普通阶段超时直接给奖励；第七版录像仍需无中弹，更早版本仍需击破。
        if lstg.var.__drops_version<7 or not avoided_timeout then return false end
    end
    b._drop_awarded=true
    local id,phase=b._drop_card_id,b._drop_phase or 1
    local awards=rawget(b,'_drop_awards') or {}
    if id and (awards[id] or 0)>=phase then return false end
    local function mark(other)
        if not id then return end
        local seen=rawget(other,'_drop_awards') or {};seen[id]=math.max(seen[id] or 0,phase);rawset(other,'_drop_awards',seen)
    end
    mark(b);for _,other in ipairs(b.otherboss or {}) do mark(other) end
    s.count=s.count+1;s.queue[#s.queue+1]={id=s.count,options=D.draw(s.seed,s.count),age=0,duration=D.TIME,linear=modern() or nil,colorMask=modern() or nil,picks={false,false}}
    return true
end
function D.apply(slot,option)
    local s=assert(ensure());local p=s.players[D.slot(slot)]
    for _,op in ipairs(assert((modern() and D.colorPool or D.pool)[option])) do
        local value=p[op[1]] or 10000
        if op[2]=='add' then value=value+op[3]*100 else value=math.floor(value*op[3]/op[4]+0.5) end
        local lower,upper=D.MIN,D.MAX
        if op[1]=='green' then lower,upper=D.HITBOX_MIN,10000 end
        -- 火力从第六版起不封顶；旧录像仍按原上限结算，蓝绿规则分别保持原值。
        if op[1]=='red' and lstg.var.__drops_version>=6 then upper=math.huge end
        p[op[1]]=math.max(lower,math.min(upper,value))
    end
end
local function players()
    if GameNet and GameNet.host() then return GameNet.players end
    return {player}
end
local function controllable(p)
    return p and IsValid(p) and not p.lock and not p.dialog and not p.realrealreal_lock and not p.hide and (p.death or 0)==0
end
function D.rowY(row) return GameQuiz.CHOICE_Y-GameQuiz.offset(row.age,row.duration or D.TIME,row.linear) end
function D.suspend()
    local s=peek();local row=s and s.active
    if not row then return end
    row.previous=row.previous or {}
    -- 答题复活期间只隐藏掉落；同步位置，避免复活传送被当成穿过接取线。
    for i,p in ipairs(players()) do if p and IsValid(p) then row.previous[i]={x=p.x,y=p.y} end end
    GameQuiz.setSelectionVisible('drops',false)
end
function D.frame(scene)
    local s=peek()
    if not s or not scene or scene.is_menu then GameQuiz.clearSelection('drops');return false end
    if not allowDrops(scene) then
        -- 接续模式不生成强化选项；兼容已有检查点中排队或正在下落的选项。
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
    -- 仅击破掉落使用 120 帧；复活答题和原 Special 仍沿用它们自己的时长。
    row.duration=row.duration or D.TIME
    row.previous=row.previous or {}
    local oldAge=row.age;row.age=row.age+1
    local lines={}
    for i,id in ipairs(row.options) do lines[i]=D.optionLines(id) end
    GameQuiz.selection('drops',row,nil,lines)
    local count=(GameNet and GameNet.host()) and 2 or 1;local complete=true
    for i=1,count do
        local p=ps[i]
        if controllable(p) then
            local previous=row.previous[i] or {x=p.x,y=p.y}
            if not row.picks[i] then
                local choice=GameQuiz.contact(previous,p,oldAge,row.age,#row.options,row.duration,row.linear)
                if choice then
                    row.picks[i]=choice;D.apply(i,row.options[choice]);p.protect=math.max(p.protect or 0,60)
                    D.updateHitbox(p)
                    PlaySound('item00',0.5)
                end
            end
        end
        if p and IsValid(p) then row.previous[i]={x=p.x,y=p.y} end
        if not row.picks[i] then complete=false end
    end
    if complete or row.age>=row.duration then GameQuiz.clearSelection('drops',true);s.active=nil end
    -- 掉落只叠加演出与接取，不接管自机，也不要求调用方停止战斗。
    return false
end
local function number(value)
    return (string.format('%.2f',value):gsub('%.?0+$',''))
end
function D.optionLines(id)
    local out={}
    for _,op in ipairs((modern() and D.colorPool or D.pool)[id]) do
        local text=op[2]=='add' and string.format('%+d',op[3]) or ('×'..number(op[3]/op[4]))
        if op[1]=='green' and op[2]=='add' then text=text..'个百分点' end
        if op[1]=='green' then
            out[#out+1]={color='green',text=D.palette.green.name..' 判定'}
            out[#out+1]={color='green',text=text}
        else
            local name=op[1]=='red' and '火力' or modern() and 'Bomb恢复速度' or '射速'
            out[#out+1]={color=op[1],text=name,scale=op[1]=='blue' and modern() and .5 or .7}
            out[#out+1]={color=op[1],text=text}
        end
    end
    return out
end
function D.render()
    -- 选项由共用 Question / Choice 与中玉实体随 ObjRender 绘制，不再叠加面板。
end
-- 直接裁切同一张绿色大星的纹理；满星与扇形共用尺寸，避开弹图默认的0.5缩放。
function D.renderStar(image,x,y,size,fraction,alpha)
    if fraction<=0 then return end
    local tex,u,v,w,h=GetImageTextureRegion(image)
    local color=Color(alpha,255,255,255)
    local function vertex(dx,dy)
        return {x+dx*size,y+dy*size,.5,u+(.5+dx)*w,v+(.5-dy)*h,color}
    end
    if fraction>=1 then
        RenderTexture(tex,'',vertex(-.5,.5),vertex(.5,.5),vertex(.5,-.5),vertex(-.5,-.5))
        return
    end
    -- 从正上方顺时针扫过方形，经过每个角补一个三角面，保持原星形轮廓和UV。
    local sweep=fraction*2*math.pi
    local center,previous=vertex(0,0),vertex(0,.5)
    local function edge(angle)
        local dx,dy=math.sin(angle),math.cos(angle)
        local radius=.5/math.max(math.abs(dx),math.abs(dy))
        local nextVertex=vertex(dx*radius,dy*radius)
        RenderTexture(tex,'',center,previous,nextVertex,center)
        previous=nextVertex
    end
    for corner=1,4 do
        local angle=(corner*2-1)*math.pi/4
        if angle>=sweep then break end
        edge(angle)
    end
    edge(sweep)
end
function D.renderBombs(x1,x2,y,alpha,count)
    local limit=D.bombLimit()
    local stock=D.bombState(1)
    local value=count==2 and ('P1 %d / P2 %d'):format(stock,D.bombState(2)) or ('%d / %d'):format(stock,limit)
    local color=Color(alpha,110,235,145)
    ui:RenderText('title','Bomb',x1,y,.8,color,'left','vcenter')
    ui:RenderText('title',value,x2,y,.8,color,'right','vcenter')
    for slot=1,count do
        local bombs,fraction=D.bombState(slot)
        local left=x1+(count==2 and 26 or 0)
        local step=(x2-left)/limit
        local cy=y-25-(slot-1)*28
        local size=count==2 and 23 or 26
        if count==2 then ui:RenderText('title','P'..slot,x1,cy-6,.55,Color(alpha,110,235,145),'left','bottom') end
        for i=1,limit do
            local x=left+(i-.5)*step
            if i<=bombs then D.renderStar('star_big10',x,cy,size,1,alpha)
            else
                D.renderStar('star_big10',x,cy,size,1,alpha*.18)
                if i==bombs+1 then D.renderStar('star_big10',x,cy,size,fraction,alpha) end
            end
        end
    end
end
function D.renderHUD(scrr,scrt,alpha)
    if not D.enabled() then return end
    ui.RunHUD.attributes(scrr,scrt,alpha)
end
function D.signature()
    local s=peek();if not s then return 'drops=none' end
    local out={'drops',s.seed,s.count}
    for _,p in ipairs(s.players) do
        out[#out+1]=table.concat({p.red,p.blue,p.clock,p.fraction},',')
        if modern() then out[#out+1]=table.concat({p.bombs,p.bomb_fraction},',') end
        if three() then out[#out+1]='green='..tostring(p.green or 10000) end
    end
    local function row(r)
        out[#out+1]=table.concat({r.id,r.age,r.options[1],r.options[2],tostring(r.picks[1]),tostring(r.picks[2]),r.duration or D.TIME},',')
        if r.options[3] then out[#out+1]='option3='..r.options[3] end
        for _,p in ipairs(r.previous or {}) do out[#out+1]=string.format('%.6f,%.6f',p.x,p.y) end
    end
    if s.active then row(s.active) else out[#out+1]='no-active' end
    for _,r in ipairs(s.queue) do row(r) end
    return table.concat(out,';')
end
GameDrops=D
return D
