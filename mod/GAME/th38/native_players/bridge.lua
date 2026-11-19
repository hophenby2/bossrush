-- 雪莲华的 Unity 自机行为兼容层。每个宿主帧执行两次原始 FixedUpdate。
local M={lateFrame=true,ownBomb=true}
local P=NativePlayers
local D=dofile('mod/GAME/th38/native_players/data.lua')
local CS=dofile('mod/GAME/ports/source_csharp.lua').new()
local E=CS.env
local V=CS.Vector3
local units,components,mainShots={}, {}, {}
local p,center,form,config,alternate,clock
local releases,initialGain,initialLeft,rate,lastState={},0,0,nil,nil
local instantiate,destroy
local function position(o) return V(o.x/48+4.5,o.y/48-4.8,0) end
local function valid(o) return o and IsValid(o) end
local function rotate(v,a) return V(v.x*cos(a)-v.y*sin(a),v.x*sin(a)+v.y*cos(a),v.z) end
local transform={}
local transformMeta={__index=function(t,k)
    local parent=rawget(t,'_parent')
    if k=='position' then return parent and parent.position+rotate(t._local*parent.lossyScale,parent.eulerAngles.z) or CS.copy(t._local)
    elseif k=='localPosition' then return t._local
    elseif k=='localScale' then return t._scale
    elseif k=='lossyScale' then return parent and parent.lossyScale*t._scale or CS.copy(t._scale)
    elseif k=='eulerAngles' then return V(0,0,t._angle+(parent and parent.eulerAngles.z or 0))
    elseif k=='rotation' then return {x=0,y=0,z=0,eulerAngles=t.eulerAngles}
    elseif k=='localRotation' then return {x=0,y=0,z=0,eulerAngles=V(0,0,t._angle)}
    elseif k=='parent' then return parent
    elseif k=='transform' then return t
    elseif k=='childCount' then return #t.children end
    return transform[k]
end,__newindex=function(t,k,v)
    local parent=rawget(t,'_parent')
    if k=='position' then
        local q=parent and rotate(v-parent.position,-parent.eulerAngles.z) or CS.copy(v)
        if parent then local s=parent.lossyScale;q=V(q.x/s.x,q.y/s.y,q.z) end
        rawset(t,'_local',q)
    elseif k=='localPosition' then rawset(t,'_local',CS.copy(v))
    elseif k=='localScale' then rawset(t,'_scale',CS.copy(v))
    elseif k=='rotation' then rawset(t,'_angle',v.eulerAngles.z-(parent and parent.eulerAngles.z or 0))
    elseif k=='localRotation' then rawset(t,'_angle',v.eulerAngles.z)
    elseif k=='parent' then
        local old,angle=t.position,t.eulerAngles.z
        if parent then for i,c in ipairs(parent.children) do if c==t then table.remove(parent.children,i);break end end end
        rawset(t,'_parent',v);if v then v.children[#v.children+1]=t end
        t.position=old;t.rotation={eulerAngles=V(0,0,angle)}
    else rawset(t,k,v) end
end}
function transform:Translate(a,b,c) self.position=self.position+rotate(type(a)=='table' and a or V(a,b,c),self.eulerAngles.z) end
function transform:Rotate(a,b,c) self._angle=self._angle+(type(a)=='table' and a.z or c or a) end
function transform:GetChild(i) return self.children[i+1] end
function transform:Find(name)
    local first,rest=name:match('^([^/]+)/(.+)$');first=first or name
    for _,child in ipairs(self.children) do if child.gameObject.name==first then return rest and child:Find(rest) or child end end
end
local function material() return {SetFloat=function(t,k,v) t[k]=v end,SetColor=function(t,k,v) t[k]=v end} end
local function media()
    local emission=setmetatable({_rate={constant=0}}, {__index=function(t,k) if k=='rateOverTime' then return t._rate end end,
        __newindex=function(t,k,v) if k=='rateOverTime' then t._rate=type(v)=='number' and {constant=v} or v else rawset(t,k,v) end end})
    return {isPlaying=false,Play=function(t) t.isPlaying=true end,Stop=function(t) t.isPlaying=false end,Clear=function() end,material=material(),emission=emission,shape={radius=0}}
end
local function get(go,kind)
    if kind=='Transform' then return go.transform end
    for _,c in ipairs(go.components) do if c.__type==kind and not c._dead then return c end end
    if kind=='AudioSource' or kind=='ParticleSystem' then local c=media();c.gameObject,c.transform,c.__type=go,go.transform,kind;go.components[#go.components+1]=c;return c end
end
function transform:GetComponent(kind) return get(self.gameObject,kind) end
local function add(go,kind)
    local c=CS.new(kind);c.gameObject,c.transform,c.enabled=go,go.transform,true
    c.GetComponent=function(_,k) return get(go,k) end
    c.AddComponent=function(_,k) return add(go,k) end
    go.components[#go.components+1]=c;components[#components+1]=c;return c
end
function transform:AddComponent(kind) return add(self.gameObject,kind) end
local function gameObject(name)
    local go={name=name,components={},activeSelf=true}
    go.transform=setmetatable({_local=V(),_scale=V(1,1,1),_angle=0,gameObject=go,children={}},transformMeta)
    go.GetComponent=function(_,k) return get(go,k) end;go.AddComponent=function(_,k) return add(go,k) end
    go.SetActive=function(_,v) go.activeSelf=v end
    return go
end
local function active(go)
    if go._dead or not go.activeSelf then return false end
    local t=go.transform.parent
    return not t or active(t.gameObject)
end
local function resolve(v,refs)
    if type(v)~='table' then return v end
    if v.fileID then return refs[v.fileID] end
    if v.prefab then return {prefab=v.prefab} end
    if v.sprite then return v.sprite end
    if v.asset then return v end
    if v.x~=nil and v.y~=nil then return V(v.x,v.y,v.z) end
    if v.r~=nil then return CS.Colors(v.r,v.g,v.b,v.a) end
    if #v>0 then local a=CS.List();for _,c in ipairs(v) do a:Add(resolve(c,refs)) end;return a end
    local a={};for k,c in pairs(v) do a[k]=resolve(c,refs) end;return a
end
instantiate=function(asset,where,rotation)
    if not asset or not asset.prefab then return nil end
    local defs=assert(D.prefabs[asset.prefab],asset.prefab);local refs,nodes={},{};local root
    for _,d in ipairs(defs) do
        local go=gameObject(d.name);local t=go.transform
        t._local=V(unpack(d.pos));t._scale=V(unpack(d.scale));t._angle=d.angle
        go.activeSelf=d.active~=0;refs[d.id],refs[d.transform]=go,t
        nodes[#nodes+1]=go
        if d.parent=='0' then root=go end
    end
    for i,d in ipairs(defs) do
        local go=nodes[i];local t=go.transform
        if d.parent~='0' then rawset(t,'_parent',refs[d.parent]);t.parent.children[#t.parent.children+1]=t end
        for _,cd in ipairs(d.components) do
            local c
            if E[cd.type] then c=add(go,cd.type)
            elseif cd.type=='SpriteRenderer' then c={__type=cd.type,material=material(),enabled=true};go.components[#go.components+1]=c
            elseif cd.type=='Animator' then c={__type=cd.type,enabled=true,Play=function() end,SetBool=function() end};go.components[#go.components+1]=c
            elseif cd.type=='ParticleSystem' then c=media();c.__type=cd.type;go.components[#go.components+1]=c end
            if c then c.gameObject,c.transform=go,t;refs[cd.id]=c;c._definition=cd;c.enabled=cd.enabled~=0 end
        end
    end
    for _,go in ipairs(nodes) do for _,c in ipairs(go.components) do if c._definition then
        for k,v in pairs(c._definition.fields) do
            local value=resolve(v,refs)
            if type(value)=='table' and next(value)==nil and type(c[k])=='table' and c[k].Count~=nil then value=CS.List() end
            if type(c[k])=='boolean' and type(value)=='number' then value=value~=0 end
            c[k]=value
        end
    end end end
    root.transform.position=where or root.transform.position
    if rotation then root.transform.rotation=rotation end
    local unit={root=root,nodes=nodes,prefab=asset.prefab,age=0};root.unit=unit
    units[#units+1]=unit
    return root
end
destroy=function(o)
    if not o or o._dead then return end
    if o.components then
        o._dead=true
        for _,t in ipairs(o.transform.children) do destroy(t.gameObject) end
        for _,c in ipairs(o.components) do c._dead=true end
    elseif o.gameObject then o._dead=true end
end
E.Object={__static=true,Instantiate=instantiate,Destroy=destroy,DestroyImmediate=destroy}
E.UnityEngine={Object=E.Object,Random={__static=true,Range=function(a,b) return ran:Float(a,b) end}}
E.Quaternion={__static=true,Euler=function(x,y,z) return {eulerAngles=type(x)=='table' and CS.copy(x) or V(x,y,z),x=0,y=0,z=0} end}
E.MathF=E.Math;E.MathF.PI=math.pi
E.Mathf={__static=true,PI=math.pi,Atan2=math.atan2,Sin=math.sin,Cos=math.cos,Abs=math.abs,Pow=math.pow,Sqrt=math.sqrt,Min=math.min,Max=math.max,Clamp=function(x,a,b) return math.max(a,math.min(b,x)) end,Lerp=function(a,b,t) return a+(b-a)*math.max(0,math.min(1,t)) end}
local S={__static=true,anjian_now={},enemy=CS.List(),boss=CS.List(),suipian_beilv_hong=1,suipian_beilv_zi=1,hyper_time=0,effect_cut=0,dam6_chengfa=0,se_enemy_hurt_count=0,if_bayunlan=0,select_nandu=3}
E.Sincos=S
E['Sincos.Xiaodan_im']={__new=function() return {position=V(),r=0,time=0,index=0,no_daoju=false} end}
E['Sincos.Renwu']={__new=function() return {time=0} end}
S.Dsin,S.Dcos=sin,cos
S.Seedrandom=function(a,b) return ran:Float(a,b) end
S.Seedrandom2=function(a) return ran:Float(-a,a) end
S.Jiaodu_ads=function(a) return a%360 end
S.Distance=function(a,b) a=a.position or a;b=b.position or b;return (a-b):Length() end
S.Point_to_line_Chuidianzuobiao=function(m,a,b) local d=b-a;return a+d*(E.Vector2.Dot(d,m-a)/E.Vector2.Dot(d,d)) end
S.DistanceLine=function(a,b,c) local d=b-a;local t=math.max(0,math.min(1,E.Vector2.Dot(d,c-a)/E.Vector2.Dot(d,d)));return (c-(a+d*t)):Length() end
setmetatable(S,{__index=function(_,k)
    local state=P.state()
    if k=='jiejiefanghu_val' then return state.barrier elseif k=='fenshu_now' then return lstg.var.score or 0
    elseif k=='if_change' then return p.altForm elseif k=='ifduihua' then return p.dialog
    elseif k=='iffuka' then
        local b=boss.GetFirstBoss and boss.GetFirstBoss()
        return b and valid(b) and b.current_card and b.current_card.is_sc or false
    elseif k=='zijix' then return p.x/48+4.5 elseif k=='zijiy' then return p.y/48-4.8 end
    if D.staticTypes[k]=='bool' then return false elseif D.staticTypes[k] then return 0 end
end,__newindex=function(t,k,v)
    if k=='jiejiefanghu_val' then P.state().barrier=v elseif k=='fenshu_now' then lstg.var.score=v else rawset(t,k,v) end
end})
local model=dofile('mod/GAME/th38/native_players/source.lua')(CS)
for k,v in pairs(model) do E[k]=v end
local targetMap=setmetatable({},{__mode='k'})
local function targets()
    S.enemy:Clear();S.boss:Clear()
    object.EnemyNontjtDo(function(o)
        if not valid(o) or not o.colli or o._sequence_road_carrier then return end
        local go=targetMap[o]
        if not go then
            go=gameObject('target');go._native=o;targetMap[o]=go
            local c=setmetatable({gameObject=go,transform=go.transform,__type=o.IsBoss and 'Bossmove' or 'Enemymove',xuruo=false,panding_off=false,zidanwudi=false}, {
                __index=function(_,k)
                    if k=='life' then return o.hp elseif k=='wudi_time' then return o.protect and 1 or 0
                    elseif k=='sdbj' then local a=o.native_actor_collision;return (a and a.damage[1] or o.a or 0)/48 end
                end,
                __newindex=function(t,k,v) if k=='life' then Damage(o,math.max(0,o.hp-v)) else rawset(t,k,v) end end,
            })
            c.GetComponent=function(_,kind) return get(go,kind) end
            c.AddComponent=function(_,kind) return add(go,kind) end
            go.components[1]=c
        end
        go.transform.position=position(o)
        if o.IsBoss then S.boss:Add(go.components[1]) else S.enemy:Add(go.transform) end
    end)
end
S.Ins_zhuqiang=function(where,death,sprite,charging)
    local n=0;for _,o in pairs(mainShots) do if not o._dead then n=n+1 end end;if n>=20 then return -1 end
    local go=instantiate({prefab='Resources/xuelianhua/prefab/zhuqiang.prefab'},where)
    local d=get(go,'Damage_zhuqiang');d.order=#mainShots+1;d.damage=p.machine.damage;d.chongneng_add=charging;d.zhuqiang_death=death
    get(go,'SpriteRenderer').sprite=sprite;mainShots[d.order]=go;return d.order
end
S.Delete_zhuqiang=function(i) destroy(mainShots[i]) end
local images={}
local function image(key)
    if not key or not D.sprites[key] then return nil end
    if images[key] then return images[key] end
    local d=D.sprites[key];local id='native_unity_player_'..key
    local pool=GetResourceStatus();SetResourceStatus('global');LoadTexture(id,'Resources/th38/player/'..key..'.png');LoadImage(id,id,0,0,d.w,d.h);SetImageCenter(id,d.ox,d.oy);SetResourceStatus(pool)
    images[key]=id;return id
end
local Unit=Class(object,{
    init=function(o,u) o.unit=u;o.group,o.layer=GROUP.GHOST,LAYER.PLAYER_BULLET;o.bound,o.colli=false,false;o.native_alpha=255 end,
    frame=function(o)
        local u=o.unit;if u.root._dead then object.RawDel(o);return end
        local q=u.root.transform.position;o.x,o.y=(q.x-4.5)*48,(q.y+4.8)*48
        for _,go in ipairs(u.nodes) do for _,c in ipairs(go.components) do if c.damage and c.damage>0 then
            o.group=GROUP.PLAYER_BULLET;o.a,o.b=math.max(.01,c.damage_r or .01)*48,math.max(.01,c.damage_r or .01)*48
        end end end
    end,
    render=function(o)
        local u=o.unit
        if u.root._dead or u.attached and p.native_body_hidden then return end
        for _,go in ipairs(u.nodes) do if active(go) and not (u.center and go.name=='anim') then
            local sr=get(go,'SpriteRenderer')
            if sr and sr.enabled and sr.sprite then
                local img=image(sr.sprite)
                if img then local t=go.transform;local q,s=t.position,t.lossyScale;local a=D.sprites[sr.sprite].scale;local c=sr.color or CS.Colors(1,1,1,1)
                    SetImageState(img,'',math.max(0,math.min(255,c.a*255)),c.r*255,c.g*255,c.b*255)
                    Render(img,(q.x-4.5)*48,(q.y+4.8)*48,t.eulerAngles.z,s.x*a,s.y*a)
                end
            end
        end end
    end,
})
local function resetForm()
    if form then destroy(form) end
    local useB=p.altForm
    local ref=useB and config.ziji_change or config.ziji_pre
    form=instantiate(ref,position(p));form.unit.attached=true
    S.ziji_ziji_now=form;alternate=p.altForm
end
function M.bind(player)
    p=player;units,components,mainShots={},{},{};clock=0
    center=instantiate({prefab=D.roots[p.machine.id] or D.roots[p.machine.art]},position(p));center.unit.attached,center.unit.center=true,true
    for _,d in ipairs(D.prefabs[D.roots[p.machine.id] or D.roots[p.machine.art]]) do for _,c in ipairs(d.components) do if c.type=='Centeryidong' then config=c.fields end end end
    if lastState~=P.state() then S.suipian_beilv_hong,S.suipian_beilv_zi,S.kaiguan_a,S.kaiguan_b,S.hyper_time=3,1,false,false,0;lastState=P.state() end
    S.xiaodan_huishou={xiaodan=false,r=0,x=0,y=0};S.xiaodan3=CS.List()
    S.hyper_system_ready,S.if_now_huiliu,S.jiejie_weichi=false,false,false
    S.liankai_beilv,S.liankai_count=10,0
    E.Beilvcao=dofile('mod/GAME/th38/native_players/rate.lua')(CS).Beilvcao;rate=CS.new('Beilvcao')
    S.ziji_now=center;resetForm();p.unity_source={Sincos=S,model=model,data=D,units=units}
    releases={};initialLeft=P.state().barrier<200000 and 100 or 0
    P.state().pointrate=P.state().pointrate or 10000
    initialGain=math.floor((200000-P.state().barrier)/100)+1
    p.protect=math.max(p.protect,210)
    p._playersys:addFrameEvent('frame.itemCollect',95,function(o)
        local auto=o.y>((p.machine.art=='marisa' and -3.75 or -3.15)+4.8)*48 or S.zidonghuishou
        local radius=(p.machine.damage==11 and 1 or .65)*48*(o.slow==1 and 2 or 1)
        for _,item in ObjList(GROUP.ITEM) do if auto or Dist(o,item)<radius then item.target,item.attract=o,auto and 12 or 8 end end
    end)
end
local function advance()
    if initialLeft>0 then P.state().barrier=math.min(299999,P.state().barrier+initialGain);initialLeft=initialLeft-1 end
    rate:FixedUpdate()
    if S.hyper_time>0 then S.hyper_time=S.hyper_time-1 end
    for i=#releases,1,-1 do local release=releases[i]
        local t,c=release.time,release.config
        release.radius=release.radius+c.kuosan_spreed
        release.go.transform.localScale=V(release.radius*.25,release.radius*.25,1)
        if t<c.wudi_time then p.protect=math.max(p.protect,2) end
        TH38.runtime.deathClear(release.x,release.y,release.radius*48)
        release.time=t+1
        if t>=c.kuosan_chixushijian then
            S.hyper_system_ready=true;S.if_now_shifang=false
            instantiate(c.jiejiehuiliu)
            destroy(release.go);table.remove(releases,i)
        end
    end
    local count=#components
    for i=1,count do local c=components[i]
        if not c._dead and active(c.gameObject) and c.enabled then
            for k,v in pairs(c) do if type(v)=='table' then
                local go=v.gameObject or v.transform and v.transform.gameObject
                if go and go._native and not valid(go._native) then c[k]=nil end
            end end
            if not c._started then c._started=true;if c.Start then c:Start() end end
            if not c._dead and c.FixedUpdate then c:FixedUpdate() end
        end
    end
    local refund=S.xiaodan_huishou
    if S.xiaodan_huiliu_bug and refund.xiaodan then
        TH38.runtime.deathClear((refund.x-4.5)*48,(refund.y+4.8)*48,refund.r*48,true,S.jiejie_cengshu_beforhuiliu==3 and 'aslRefund' or 'points')
    end
    for i=S.xiaodan3.Count-1,0,-1 do
        local c=S.xiaodan3[i]
        TH38.runtime.deathClear((c.position.x-4.5)*48,(c.position.y+4.8)*48,c.r*48,false,not c.no_daoju and 'points' or nil)
        c.time=c.time-1;if c.time<=0 then S.xiaodan3:RemoveAt(i) end
    end
    for _,u in ipairs(units) do
        if not u.object then u.object=New(Unit,u) end
        if not u.root._dead then
            u.age=u.age+1
            for _,go in ipairs(u.nodes) do
                local anim=get(go,'Animator');local sr=get(go,'SpriteRenderer')
                local clip=anim and D.clips[anim.clip]
                if clip and sr then
                    local time=u.age/120;time=clip.loop==1 and time%math.max(.0001,clip.length) or math.min(time,clip.length)
                    for _,track in ipairs(clip.tracks) do for _,k in ipairs(track.keys) do if k[1]<=time then sr.sprite=k[2] end end end
                end
            end
        end
    end
end
function M.frame(player,state)
    if p~=player then M.bind(player) end
    center.transform.position=position(p);form.transform.position=position(p)
    if alternate~=p.altForm then resetForm() end
    targets()
    S.zidonghuishou=p.y>((p.machine.art=='marisa' and -3.75 or -3.15)+4.8)*48
    local key=p._playersys.keyState
    S.chuliluo_speed=NativeTime and NativeTime.scale or 1
    for i,k in pairs({[0]='up',[1]='down',[2]='left',[3]='right',[4]='slow',[5]='shoot',[6]='spell',[7]='special'}) do S.anjian_now[i]=key[k] or false end
    if p.native_body_hidden then S.anjian_now[5]=false end
    for _=1,2 do clock=clock+1;S.gametime=clock;advance() end
    state.multiplierRed,state.multiplierPurple,state.hyperTime=S.suipian_beilv_hong,S.suipian_beilv_zi,S.hyper_time
    for i=#components,1,-1 do if components[i]._dead or components[i].gameObject._dead then table.remove(components,i) end end
    for i=#units,1,-1 do if units[i].root._dead then table.remove(units,i) end end
end
function M.shoot() end
function M.collect(state,kind,amount)
    if kind=='points' then
        state.pointrate=(state.pointrate or 0)+16*amount
        return true
    elseif kind=='aslRefund' then
        local base=({720,420,300,240,240,240})[math.max(1,math.min(6,(stage.current_stage.group.difficulty or 4)))]
        local count=P.barriers(state);local gain=math.floor(base*(count==1 and .75 or count==2 and .5 or 1))
        if boss.GetFirstBoss and boss.GetFirstBoss() and boss.GetFirstBoss().current_card and boss.GetFirstBoss().current_card.is_sc then gain=math.floor(gain*.5) end
        state.barrier=math.min(299999,state.barrier+gain*amount)
        lstg.var.score=(lstg.var.score or 0)+math.floor((state.pointrate or 0)/120*((S.liankai_beilv or 10)/10))*amount
        return true
    end
    return false
end
function M.bomb(player,state)
    if S.hyper_system_ready then
        S.jiejie_cengshu_beforhuiliu=P.barriers(state)
        S.hyper_system_ready=false;S.xiaodan_huishou.xiaodan=true
    end
    if P.barriers(state)<3 or player.nextspell>0 or S.if_now_huiliu then return false end
    local cfg
    for _,node in ipairs(D.prefabs[config.BOMB.prefab]) do for _,c in ipairs(node.components) do if c.type=='Jiejie_shifang' then cfg=c.fields end end end
    local go=instantiate(config.BOMB,position(player))
    releases[#releases+1]={go=go,config=cfg,time=0,radius=1,x=player.x,y=player.y}
    state.barrier,state.barrierReward=0,0
    player.bombTime,player.nextspell,player.cancelOnlyBomb=101,101,true
    player.protect=math.max(player.protect,math.ceil(cfg.wudi_time/2))
    PlaySound('nep00',.5)
    return true
end
P.adapters[36]=M
return M
