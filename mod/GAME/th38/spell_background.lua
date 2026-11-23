-- Boss_fuka_creat动态背景；原作prefab层级、精灵、中心点、120Hz运动。
local A=...
local D=A.data
local B={}
local function backgroundKey(key)
    local phase=D.phases[key]
    return phase and D.spellMap and D.spellMap[phase.number]
end
function B.prepare(key)
    for _,n in ipairs(D.backgrounds[backgroundKey(key)] or {}) do
        A.picture(n.sprite)
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
end
local current
local function clone(t)
    local r={};for k,v in pairs(t) do r[k]=type(v)=='table' and clone(v) or v end;return r
end
local function script(n,name) local s=n.scripts[name];return s and s.enabled~=0 and s end
local function fade(s,t)
    local span=s.a_kuadu~=0 and s.a_kuadu or 1
    return math.max(0,math.min(1,(t-s.time_yanshi+1)/math.max(1,s.time_long)))*span*(s.jianxian_or_jianyin==1 and 1 or -1)
end
local Scene=Class(object,{
    init=function(o,key)
        o.nodes=clone(D.backgrounds[key]);o.clock=0;o.seed=379
        o.layer,o.group,o.colli,o.bound=LAYER.BG+.02,GROUP.GHOST,false,false
        for _,n in ipairs(o.nodes) do
            n.x,n.y,n.sx,n.sy,n.rot=n.pos[1],n.pos[2],n.scale[1],n.scale[2],n.rotation
            n.startX,n.startY=n.x,n.y;n.alpha=n.color and n.color[4] or 1
            n.age,n.inheritedAlpha=0,0
            local osc=script(n,'Tongyong_baidong')
            if osc and osc.all_random==1 then
                local function rand() o.seed=o.seed*16807%2147483647;return o.seed/2147483647 end
                osc.A_x=osc.A_x+(rand()*2-1)*osc.r_a;osc.A_z=osc.A_z+(rand()*2-1)*osc.r_a
                osc.T_x=osc.T_x+(rand()*2-1)*osc.r_t;osc.T_z=osc.T_z+(rand()*2-1)*osc.r_t
                osc.ph_x=math.floor(rand()+.5);osc.ph_z=math.floor(rand()+.5)
            end
        end
    end,
    frame=function(o)
        for _=1,2 do
            o.clock=o.clock+1
            local t=o.clock-1
            for _,n in ipairs(o.nodes) do
                local c=script(n,'Boss3_cardback')
                if c and o.clock%c.zhouqi==0 then
                    local targets={15,-15,10};local turn=math.floor(o.clock/c.zhouqi)%2==1
                    for j,index in ipairs(c.zuni) do
                        local z=o.nodes[index].scripts.Tongyong_rotate_zuni
                        if j<=2 then z.mubiao_z=z.mubiao_z+(j==1 and -25 or 25)
                        else z.mubiao_z=turn and targets[j-2] or (j==5 and -10 or 0);z.chaotiaoliang_up_down=(j==4)==turn and 1 or 0 end
                    end
                end
                local scroll=script(n,'Tongyong_xunhuangundong')
                if scroll and t>=scroll.time_wait then
                    local p=((t-scroll.time_wait+1)%math.max(1,scroll.time_xunhuan))/math.max(1,scroll.time_xunhuan)
                    n.x,n.y=n.startX+(scroll.x-n.startX)*p,n.startY+(scroll.y-n.startY)*p
                end
                local rotate=script(n,'Tongyong_xuanzhuan')
                if rotate then n.rot=n.rot+rotate.zhuansu end
                local zuni=script(n,'Tongyong_rotate_zuni')
                if zuni then
                    if zuni.mubiao_z~=n.target then n.target=zuni.mubiao_z;n.zuniTime=0 end
                    local age=n.zuniTime or 0;local duration=zuni.zhouqi*zuni.zhouqi_time_long_per
                    if age<duration then
                        local over=math.abs(zuni.chaotiaoliang)*(zuni.chaotiaoliang_up_down==1 and -1 or 1)*(duration-age-1)/duration
                        local target=zuni.mubiao_z+sin(age/zuni.zhouqi_time_long_per*360)*over
                        local difference=(target-n.rot+180)%360-180
                        n.rot=n.rot+math.max(-2,math.min(2,zuni.hot_add*difference));n.zuniTime=age+1
                    end
                end
                local osc=script(n,'Tongyong_baidong')
                n.projectionY=1
                if osc then
                    if osc.T_z~=0 then n.rot=n.rotation+osc.A_z*sin((t/osc.T_z+osc.ph_z)*360) end
                    if osc.T_x~=0 then n.projectionY=cos(osc.A_x*sin((t/osc.T_x+osc.ph_x)*360)) end
                end
                local flash=script(n,'Back_flash_fixed')
                if flash and t>=5 then n.sx,n.sy=flash.scale.x,flash.scale.y end
                local bob=script(n,'Boss_move_doudong')
                if bob then n.y=n.y+.001*sin((t+bob.time_start)%(bob.time_zhouqi==0 and 360 or bob.time_zhouqi))*(bob.A==0 and 1 or bob.A) end
                n.alpha=n.color and n.color[4] or 1
                local f=script(n,'Tongyong_jianxianjianyin')
                n.fade=f and fade(f,t) or 0
                n.alpha=n.alpha+n.fade
                local pulse=script(n,'Tongyong_minganbianhua')
                if pulse and t>=pulse.time_start and pulse.zhouqi>0 then
                    n.alpha=(pulse.max+pulse.min+(pulse.max-pulse.min)*sin((t-pulse.time_start)/pulse.zhouqi*360))*.5
                end
            end
        end
    end,
    render=function(o)
        if not setting.displayBG then return end
        SetViewMode('world')
        local resolved={}
        local function transform(index)
            if resolved[index] then return resolved[index] end
            local n=o.nodes[index];local p=n.parent>0 and transform(n.parent)
            local c,s=p and cos(p.rot) or 1,p and sin(p.rot) or 0
            local x,y=n.x,n.y
            local follow=script(n,'Tongyong_pos_base')
            if follow and follow.father~=index and follow.father>0 then
                local target=transform(follow.father)
                x,y=target.x+follow.pianyi.x,target.y+follow.pianyi.y
            elseif p then x,y=p.x+x*p.sx*c-y*p.sy*s,p.y+x*p.sx*s+y*p.sy*c end
            local f=script(n,'Tongyong_jianxianjianyin')
            local inherited=p and p.fade or 0
            local v={x=x,y=y,sx=n.sx*(p and p.sx or 1),sy=n.sy*(p and p.sy or 1),rot=n.rot+(p and p.rot or 0),
                alpha=n.alpha+inherited,fade=inherited+(f and f.yingyongziwuti==1 and n.fade or 0),active=n.active==1 and (not p or p.active)}
            resolved[index]=v;return v
        end
        local order={}
        for i,n in ipairs(o.nodes) do if n.sprite then order[#order+1]=i end end
        table.sort(order,function(a,b)
            local aa,bb=o.nodes[a],o.nodes[b]
            if aa.order~=bb.order then return aa.order<bb.order end
            if aa.pos[3]~=bb.pos[3] then return aa.pos[3]>bb.pos[3] end
            return a<b
        end)
        for _,i in ipairs(order) do
            local n=o.nodes[i];local v=transform(i)
            if v.active and v.alpha>0 then
                local id,scale=A.picture(n.sprite);local rgb=n.color
                SetImageState(id,n.blend or '',math.min(1,v.alpha)*255,rgb[1]*255,rgb[2]*255,rgb[3]*255)
                Render(id,(v.x-4.5)*48,(v.y+4.8)*48,v.rot,scale*v.sx,scale*v.sy*(n.projectionY or 1))
            end
        end
    end,
})
function B.close()
    if current and IsValid(current) then Del(current) end
    current=nil
end
function B.open(key)
    B.close()
    local which=backgroundKey(key)
    if which and D.backgrounds[which] then current=New(Scene,which) end
end
return B
