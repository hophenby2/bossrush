-- TH08 ECL ExIns0 / AsciiManager夜盲；原etama.anm脚本105和精灵229。
local N={}
local profiles={
    [47]={320,96,64},[50]={440,224},[56]={224,64,48},[60]={320,64,48},[57]={224,224},
}
N.effect=Class(object,{
    init=function(o,kind,owner,alpha,radius)
        o.kind,o.owner,o.age=kind or 47,owner,0
        o.alpha=alpha or ((o.kind==56 or o.kind==57) and 255 or 0)
        o.radius=radius or (profiles[o.kind] and profiles[o.kind][1] or 48)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.TOP-1,false,false
        o.vm=OriginalANM.new(8,'etama',105)
    end,
    frame=function(o)
        if o.owner and (not IsValid(o.owner) or o.owner.status=='del' or o.owner.status=='kill') then object.RawDel(o);return end
        local p=profiles[o.kind]
        if p then
            local t=o.age
            o.alpha=(o.kind==56 or o.kind==57) and 255 or math.floor(math.min(1,t/10)*255)
            o.radius=p[1]+(p[2]-p[1])*math.min(1,t/120)
            -- 125次计数循环后安装第二段，Configure在插值更新之前读取本拍值。
            if p[3] and t>=125 then o.radius=p[2]+(p[3]-p[2])*math.min(1,(t-125)/1800) end
        end
        o.age=o.age+1
    end,
    render=function(o)
        local a,r=o.alpha,o.radius
        if a<=0 or r<=0 then return end
        local w=lstg.world
        local x,y=player.x,player.y
        local l,rr=math.max(w.l,x-r),math.min(w.r,x+r)
        SetImageState('white','',a,0,0,0)
        if x-r>w.l then RenderRect('white',w.l,x-r,w.b,w.t) end
        if x+r<w.r then RenderRect('white',x+r,w.r,w.b,w.t) end
        if y-r>w.b and rr>l then RenderRect('white',l,rr,w.b,y-r) end
        if y+r<w.t and rr>l then RenderRect('white',l,rr,y+r,w.t) end
        o.vm.scale[1],o.vm.scale[2]=r/63,r/63
        o.vm.alpha[1]=a
        OriginalANM.draw(o.vm,x,y)
    end,
},true)
function N.install(owner,kind)
    if owner.th08_blind and IsValid(owner.th08_blind) then object.RawDel(owner.th08_blind) end
    owner.th08_blind=New(N.effect,kind,owner)
    return owner.th08_blind
end
function N.hold(owner,alpha,radius)
    if owner.th08_blind and IsValid(owner.th08_blind) then object.RawDel(owner.th08_blind) end
    owner.th08_blind=New(N.effect,0,owner,alpha,radius)
end
function N.release(owner)
    local o=owner.th08_blind
    if o and IsValid(o) then
        owner.th08_blind_carry={o.alpha,o.radius}
        object.RawDel(o)
    end
    owner.th08_blind=nil
end
return N
