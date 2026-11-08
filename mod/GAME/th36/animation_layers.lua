-- 原作ANM68写绘制层：回归虚无的175号红色本体在12层，174号白色辉光在14层。
-- 普通敌弹在中间绘制。必须跨敌机先画完全部本体、再画全部辉光，不能按敌机交替画。
local H,class=...
local A,object=OriginalANM,object
local band=require('bit').band
local planes={[12]=LAYER.ENEMY_BULLET-1,[14]=LAYER.ENEMY_BULLET+1}
function H.draw_actor(a,plane)
    if a.dead or band(a.flags,0x20)~=0 then return end
    local rows={}
    for slot,root in pairs(a.anm) do
        local vms=A.collect_draw_vms(root,{})
        for _,vm in ipairs(vms) do
            if vm.render_layer==plane or plane==nil and not planes[vm.render_layer] then
                rows[#rows+1]={vm=vm,slot=slot}
            end
        end
    end
    table.sort(rows,function(a,b) return a.vm.draw_sequence<b.vm.draw_sequence end)
    local angle=a.anm_angle and -math.deg(a.anm_angle) or nil
    for _,row in ipairs(rows) do
        local override=row.slot==0 and a.flash_magenta and {color={255,0,255},alpha=255} or nil
        A.draw_vm(row.vm,a.o.x,a.o.y,angle,nil,nil,nil,nil,override)
    end
end
class.animation_plane=Class(object,{
    init=function(o,s,plane)
        o.session,o.plane=s,plane
        o.group,o.layer,o.colli,o.bound=GROUP.GHOST,planes[plane],false,false
    end,
    frame=function(o) if o.session.done then object.RawDel(o) end end,
    render=function(o)
        if o.session.done then return end
        for _,a in ipairs(o.session.actors) do H.draw_actor(a,o.plane) end
    end,
},true)
function H.create_animation_planes(s)
    for _,plane in ipairs({12,14}) do s.effects[#s.effects+1]=New(class.animation_plane,s,plane) end
end
