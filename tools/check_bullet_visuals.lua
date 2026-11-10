-- 对真实映射表和贴图资源验收：不缩放子弹、保留旧判定、激光显示与命中分开。
arg[1] = 'bullet-visuals'
local f = assert(io.open('tools/check_stage.lua', 'rb')); local setup = f:read('*a'); f:close()
assert(loadstring(setup:sub(1, assert(setup:find('if path == "--all" then', 1, true)) - 1)))()
local resources, textures, calls = {}, {}, {}
local function pngsize(path)
    local f = assert(io.open(path:gsub('\\', '/'), 'rb')); local h = f:read(24); f:close()
    local function n(i) local a,b,c,d = h:byte(i,i+3); return ((a*256+b)*256+c)*256+d end
    return n(17), n(21)
end
LoadTexture = function(name, path) textures[name] = { pngsize(path) } end
LoadImage = function(name, _, _, _, w, h, a, b, rect)
    resources[name] = { w=w, h=h, a=a or 0, b=b or a or 0, rect=rect or false, scale=1 }
end
LoadImageGroup = function(prefix, tex, x, y, w, h, cols, rows, a, b, rect)
    for i=1,cols*rows do LoadImage(prefix..i,tex,x,y,w,h,a,b,rect) end
end
LoadImageGroupFromFile = function(prefix, path, mip, cols, rows, a, b, rect)
    LoadTexture(prefix,path); local z=textures[prefix]
    LoadImageGroup(prefix,prefix,0,0,z[1]/cols,z[2]/rows,cols,rows,a,b,rect)
end
CopyImage = function(name, other)
    local copy={};for k,v in pairs(assert(resources[other],other)) do copy[k]=v end;resources[name]=copy
end
EnumRes2 = function(kind) local out={};if kind=='img' then for k,v in pairs(resources) do if not v.animation then out[#out+1]=k end end end;return out end
SetImageCenter = function() end
SetAnimationCenter = function() end
SetAnimationState = function() end
SetImageScale = function(name, scale) assert(resources[name],name).scale=scale end
SetAnimationScale = SetImageScale
LoadAnimation = function(name,tex,x,y,w,h,cols,rows,interval,a,b,rect)
    LoadImage(name,tex,x,y,w,h,a,b,rect); resources[name].animation=true
end
Render = function(name,x,y,rot,h,v) calls[#calls+1]={name=name,x=x,y=y,rot=rot,h=h or 1,v=v or h or 1} end
RenderAnimation = function(name,ani,x,y,rot,h,v)
    assert(type(ani)=='number','动画弹与灰色拖影需要有效动画帧号')
    Render(name,x,y,rot,h,v)
end
CheckRes = function(kind,name) return kind=='img' and resources[name]~=nil end
local fields={class=true,img=true,x=true,y=true,rot=true,hscale=true,vscale=true,a=true,b=true,rect=true,vx=true,vy=true,dx=true,dy=true,ani=true,timer=true,omiga=true}
local collecting
New = function(class,...)
    local attrs={class=class,x=0,y=0,rot=0,hscale=1,vscale=1,a=0,b=0,rect=false,vx=0,vy=0,dx=0,dy=0,timer=0,ani=0,omiga=0}
    local o=setmetatable({_live=true},{
        __index=function(_,k) if fields[k] then return attrs[k] end end,
        __newindex=function(t,k,v)
            if fields[k] then
                attrs[k]=v
                if k=='img' then local r=assert(resources[v],v);attrs.a,attrs.b,attrs.rect=r.a,r.b,r.rect end
            else rawset(t,k,v) end
        end,
    })
    class.init(o,...)
    if collecting then collecting[#collecting+1]=o end
    return o
end
IsValid=function(o) return o~=nil and rawget(o,'_live')~=false end
object.RawDel=function(o) o._live=false end
Include=function() end
dofile('THlib/lib/Ltask.lua'); dofile('THlib/bullet/bullet.lua'); dofile('THlib/bullet/bulletStyle.lua')
dofile('THlib/bullet/visual_match.lua'); dofile('THlib/laser/laser.lua')
local checks=0
local function check(v,label) assert(v,label); checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-7 end
local roots, actual_lasers = {}, {}
boss.card.add=function(parts) for _,p in ipairs(parts) do roots[#roots+1]=p[1] end end
local function find(name,root)
    local seen={}
    local function visit(v)
        if (type(v)~='function' and type(v)~='table') or seen[v] then return end
        seen[v]=true
        if type(v)=='function' then
            for i=1,100 do
                local n,u=debug.getupvalue(v,i);if not n then break end
                if n==name then return u end
                local found=visit(u);if found then return found end
            end
        else
            for _,u in pairs(v) do local found=visit(u);if found then return found end end
        end
    end
    return assert(visit(root or roots),name)
end
local expected={
    th31={[2]=grain_a,[4]=arrow_small,[5]=grain_b,[6]=arrow_big_c,[8]=butterfly,[9]=knife,[16]=grain_b,[17]=grain_c,[18]=gun_bullet,[19]=water_drop,[20]=knife},
    th33={[3]=grain_a,[10]=grain_c,[14]=knife,[18]=water_drop,[21]=knife},
    th34={[2]=grain_a,[9]=knife},
    th35={[3]=grain_a,[10]=grain_c,[14]=knife,[18]=water_drop,[21]=knife,[25]=water_drop,[26]=grain_a},
}
local mapper_names={th31='style_of',th33='sg_style',th34='th07_style',th35='t10_style'}
-- 从真正的发弹入口收集对象；只给渲染器手填spawn计时，会漏掉枪与弹体之间的断链。
local function emitted(fn)
    local saved,made=collecting,{}
    collecting=made
    local ok,err=xpcall(fn,debug.traceback)
    collecting=saved
    assert(ok,err)
    return made
end
local function step_native(o)
    o.class.frame(o)
    o.x,o.y=o.x+o.vx,o.y+o.vy
    o.ani,o.timer=o.ani+1,o.timer+1
end
for _,game in ipairs({'th31','th33','th34','th35'}) do
    roots={};dofile('mod/GAME/'..game..'.lua');local mapper=find(mapper_names[game])
    if game=='th34' then
        local owner={x=0,y=112,dir=1}
        local made=emitted(function() find('volley',_editor_class.TH34.TH34_ghost)(owner) end)
        check(#made==10,'六面道中齐射保留原始10发')
        for _,o in ipairs(made) do
            OriginalBulletVisual.sync_spawn(o)
            check(o.c_spawn_left==10 and not o.colli and o._native_spawn_started,
                '六面道中真实齐射进入快速弹雾')
            o._live=false
        end
        local shot=emitted(function()
            find('volley3')(owner,1,function() return mapper(1),2,2,0 end,false)
        end)[1]
        OriginalBulletVisual.sync_spawn(shot)
        check(near(shot.x,-8) and shot.c_spawn_left==10 and not shot.colli,'普通弹出生退四倍速度')
        for t=1,9 do
            step_native(shot)
            check(not shot.colli and near(shot.x,-8+t),'快速弹雾逐帧半速移动且无判定')
        end
        step_native(shot);check(shot.colli and near(shot.x,4),'出生结束当帧执行半步及完整飞行步')
        step_native(shot);check(near(shot.x,6),'末帧额外半步不能残留到下一帧')
        made=emitted(function() find('gh3_fire11a')(owner,0) end)
        for _,o in ipairs(made) do
            OriginalBulletVisual.sync_spawn(o)
            check(o.c_spawn_left==0 and o.colli and not o._native_spawn_started,
                '原作flags0x200的慢环保持直接出弹')
            o._live=false
        end
        local spread=find('w5_spread')
        shot=emitted(function() spread(owner,6,2,1,1,2,1,0,0,0,0,nil,0x205) end)[1]
        check(shot.c_spawn_left==16 and near(shot.x,-8) and not shot.colli,'五面0x205进入普通出生而非快速出生')
        shot=New(_editor_class.TH34.TH34_exbigbullet78,mapper(0),2,0,112,2,0,6,3)
        for _=1,31 do step_native(shot) end
        check(not shot.colli and shot.t0==0 and shot.t1==-1,'EX慢速出生期间不提前执行两段运动命令')
        step_native(shot);check(shot.colli and shot.t0==1,'EX慢速出生结束后才开始转向')
        local shoot=find('shoot6')
        for _,flags in ipairs({0x200,0x204}) do
            shot=emitted(function() shoot(owner,0,0,65,1,2,1,1,2,1,0,0,{list={},flags=flags},false) end)[1]
            check(shot.c_spawn_left==(flags==0x200 and 0 or 16),'Boss普通发弹保留明确的无出生/普通出生旗标')
        end
    elseif game=='th35' then
        local fire=find('fire')
        for _,kind in ipairs({2,4,8}) do
            local o=emitted(function()
                fire({pat={},ecs={wx=0,wy=112}},{sprite={1,0},count={1,1},aim=3,speed={2,1},
                    steps={{allow=1,kind=kind},{allow=0,kind=0x8000,i0=3}}})
            end)[1]
            OriginalBulletVisual.sync_spawn(o)
            check(o.tb.spawn==8 and not o.colli and o._native_spawn_started,
                'TH10真实fire入口采用etNew默认0x203，空操作kind不能改出生模式')
            for t=1,7 do
                step_native(o)
                check(not o.colli and o.tb.st.wait.t==3 and near(o.x,-8+t),'TH10出生期不消耗WAIT并逐帧半速移动')
            end
            step_native(o)
            check(o.tb.spawn==0 and o.colli and o.tb.st.wait.t==2 and near(o.x,2),
                'TH10出生结束同帧推进WAIT与完整飞行步')
            o._live=false
        end
        local owner={pat={},ecs={wx=0,wy=112}}
        find('et_new')(owner,0);find('et_ex')(owner,0,0,1,4,-999999,-999999,-999999,-999999)
        local o=emitted(function() find('fire_slot')(owner,0) end)[1]
        check(o.tb.spawn==8 and not o.colli,'etNew/etEx/fire_slot链路保留原作默认快速出生')
        o=emitted(function() find('spawn_bullet')(0,112,0,.02,20,2) end)[1]
        OriginalBulletVisual.sync_spawn(o)
        check(o.th10_spawn_left==8 and not o.colli and o._native_spawn_started,'神德专用发弹入口同样播放出生动画')
        for _=1,7 do step_native(o) end
        check(o.th_wait==20 and not o.colli,'神德出生期不提前消耗等待时间')
        step_native(o);check(o.th_wait==19 and o.colli,'神德出生结束当帧开始WAIT')
    elseif game=='th33' then
        for _,flags in ipairs({512,514}) do
            local o=emitted(function() find('SpawnPhoto')(flags,mapper(1)[1],2,0,112,2,0,false,0,false) end)[1]
            OriginalBulletVisual.sync_spawn(o)
            check((o.th095_spawn_left or 0)==(flags==514 and 8 or 0)
                and o.colli==(flags==512),'文花帖真实发弹入口区分出生旗标与单独音效旗标')
            o._live=false
        end
    end
    if game=='th31' then
        actual_lasers.th08=find('lw209_laser')
        -- 真正执行构造并验证资源名，单纯载入卡片抓不到 ellipse/ellipse16 混用。
        local orb=New(find('c452_orb'),45,117,0,1)
        check(resources[orb.img] and orb.img=='th31_master_spark','Final Master Spark使用原作火花图片资源')
        for _,name in ipairs({'bullet_cls_23a','bullet_cls_23b','bullet_cls_4','bullet_cls_7'}) do
            local cls=find(name)
            local shot=New(cls,45,117,0.3,1.2,0.16,0)
            check(near(shot.x,45) and near(shot.y,117),'无余涅槃各发弹分支从Boss坐标出生：'..name)
            check(shot.class==cls,'无SPAWN位的LW弹出生即进入飞行状态')
        end
        local cls=find('emitter_neg_cls')
        local emitter=New(cls,45,117,4)
        calls={};cls.render(emitter)
        check(emitter.img==nil and #calls==0,'无余涅槃逻辑发射器不绘制占位黑框')
        cls.frame(emitter)
        local beam=assert(emitter.lw_slots[1])
        local before=beam.rot
        for _=1,20 do cls.frame(emitter);beam.class.frame(beam) end
        check(beam.rot~=before and near(beam.x,45+64*cos(beam.rot))
            and near(beam.y,117+64*sin(beam.rot)),'LW激光旋转围绕原始发射点保持64px偏移')
        -- 原作模板执行过t=0；逐帧核对半速出生、最后一帧的双位移与无判定窗口。
        local function step_shot(o)
            o.class.frame(o);o.x,o.y=o.x+o.vx,o.y+o.vy;o.ani=o.ani+1;o.timer=o.timer+1
        end
        local cases={
            {'storm_bullet',{0,0,0,2,{},1,0,15},15,.4,'bvx'},
            {'lw206_bullet',{0,0,0,2,6,1,10},10,.5,'bvx'},
            {'bullet_218',{0,0,0,2,1,1,2},10,.5,'alice_speed'},
            {'lw209_bullet',{0,0,0,2},10,.5},
            {'lw210_bullet',{0,0,0,2,1,false},10,.5,'lw210_bvx'},
            {'lw211_bullet',{0,0,0,2,1,5,10,.5,0,0,0},10,.5,'lw211_bvx'},
            {'lw211_bullet',{0,0,0,2,1,19,10,.5,0,0,0},30,.5,'lw211_bvx'},
            {'lw211_bullet',{0,0,0,2,1,10,15,.4,0,0,0},24,.4,'lw211_bvx'},
            {'lw212_aim_bullet',{0,0,0,2},10,.5},
            {'lw213_bullet',{0,0,0,2,1,2,10,100},10,.5},
            {'lw214_bullet',{0,0,0,2,1},10,.5},
            {'lw215_bullet',{0,0,0,2,1,14,0},30,.5},
            {'lw216_bullet',{0,0,0,2,1,30},30,.5},
            {'BIG_CLS',{0,0,0,2},30,.5},
            {'MID_CLS',{0,0,0,2},24,.5},
        }
        for _,case in ipairs(cases) do
            local o=New(find(case[1]),unpack(case[2]))
            check(not o.colli and near(o.x,-8),case[1]..'出生退四倍速度，关闭判定')
            for t=1,case[3]-1 do
                step_shot(o)
                check(not o.colli and near(o.x,-8+t*2*case[4]),case[1]..'弹雾半速位移与无判定：'..t)
            end
            if o.alice_wait then check(o.alice_wait==120,'爱丽丝弹雾不消耗WAIT计时') end
            local x=o.x;step_shot(o)
            local fired=case[5] and o[case[5]] or o.vx
            check(o.colli and near(o.x,x+2*case[4]+fired),case[1]..'结束当帧保留出生位移，再完整执行FIRED')
            if o.lw213_wait then check(o.lw213_wait==99,'弹雾结束当帧推进WAIT') end
        end
        local direct=New(find('storm_bullet'),45,117,0,2,{},1,8,nil)
        check(direct.colli and direct.x==45 and direct.y==117,'无出生旗标的蝶弹从发射器原点出现')
        for _,name in ipairs({'lw207_bullet','lw208_bullet','lw208_gun_bullet'}) do
            local cls=find(name)
            local o=New(cls,45,117,0,2,1,0)
            check(o.x==45 and o.y==117 and not o.bound,name..'必须记录发射器坐标并关闭引擎提前回收')
            step_shot(o)
            check(near(o.x,47) and near(o.y,117),name..'第一帧从发射器坐标积分')
            local edge=New(cls,192,0,0,0,1,0)
            edge.x=192+edge.imgclass.native_profile.w/2
            step_shot(edge)
            check(IsValid(edge),name..'精灵边缘仍接触场地时保留')
            edge.x=edge.x+.01;step_shot(edge)
            check(not IsValid(edge),name..'精灵整体出屏后回收')
        end
        local turning=New(find('bullet_218'),0,0,0,2,1,math.pi,2)
        for _=1,10 do step_shot(turning) end
        turning.alice_wait=0;turning.alice_turn_armed=true;turning.alice_turn_timer=1
        turning.x=210;step_shot(turning)
        check(IsValid(turning) and turning.alice_off==1,'转向变换执行时保留出屏子弹')
        turning.alice_turn=nil;turning.alice_speed=0;step_shot(turning)
        check(IsValid(turning) and turning.alice_off==0,'转向结束后消耗累计出屏帧数')
        step_shot(turning);check(not IsValid(turning),'原作出屏宽限耗尽后回收')
        local stopped=New(find('lw217_bullet'),0,0,0,.1)
        for _=1,9 do step_shot(stopped) end
        check(not stopped.colli,'小弹快速弹雾前9帧不碰撞')
        step_shot(stopped);check(stopped.colli,'小弹快速弹雾第10帧进入FIRED')
        local EX=find('EX')
        for _,kind in ipairs({0,10}) do
            local o=New(EX.bullet,{x=0,y=0,angle=0,speed=2,style=mapper(kind),color=1,
                half=32,btype=kind,flags=0,recs={}})
            local pool=EX.pool;EX.pool={o};EX.pool_cancel();EX.pool=pool
            local duration=kind==10 and 16 or 12
            check(o.ex_despawn==duration,'原生消散时限由弹型选择：'..kind)
            for _=1,duration-1 do step_shot(o) end
            check(IsValid(o) and not o.colli,'原生消散保留弹槽到ANM最后一帧：'..kind)
            step_shot(o);check(not IsValid(o),'原生消散动画结束后释放：'..kind)
        end
    end
    if game=='th35' then actual_lasers.th10=find('th10_laser') end
    if game=='th33' then
        local fixed=find('sg_visual')
        local mapped=fixed(butterfly,18)
        local old=NewSimpleBullet(butterfly,2,0,0,1,0,false,0,false)
        local changed=NewSimpleBullet(mapped,2,0,0,1,0,false,0,false)
        check(mapped.visual_style==water_drop and changed.a==3 and changed.b==3 and changed.rect,
            'TH33 type18 使用文花帖原生6×6方形判定')
        local parts=find('sg_parts')
        check(parts(mapped)==mapped,'TH33 样式类本身不能被误认为 type 描述数组')
        local body,t=parts(mapper(3));check(body.visual_style==grain_a and t==3,'TH33 描述数组仍只查一次色表')
    end
    for t,visual in pairs(expected[game]) do
        local mapped=mapper(t);if game=='th33' then mapped=mapped[1] end
        check(mapped.visual_style==visual,game..' type'..t..' 选用默认大小接近的样式')
        local old=assert(mapped.collision_style)
        for color=1,OriginalBulletVisual.color_count(mapped.native_game,t) do
            local original=NewSimpleBullet(old,color,0,0,1,0,false,0,false)
            local changed=NewSimpleBullet(mapped,color,0,0,1,0,false,0,false)
            local width=OriginalCollision.widths[mapped.native_game][t]
            check(near(changed.a,width/2) and near(changed.b,width/2) and changed.rect,
                game..' 使用原作的轴对齐方形判定')
            check(changed.hscale==1 and changed.vscale==1,game..' 不额外缩放子弹')
            calls={};bullet.render(changed)
            local vm=changed._native_anm
            local native=vm.data.sprites[vm.sprite]
            check(#calls==1 and calls[1].name==native.img and calls[1].h==vm.scale[1] and calls[1].v==vm.scale[2],game..' 使用原作精灵与ANM缩放')
            if visual==water_drop or visual==gun_bullet then
                changed.graysmear={{img=changed.img,x=0,y=0,rot=0,hscale=1,vscale=1,alpha=80}}
                calls={};bullet.render(changed)
                check(#calls==1 and calls[1].name==native.img,game..' 原作弹不叠项目的代理灰色拖影')
            end
            local white=OriginalBulletVisual.color_count(mapped.native_game,t)
            bullet.ChangeImage(changed,mapped,white)
            local gray=NewSimpleBullet(old,white,0,0,1,0,false,0,false)
            check(near(changed.a,width/2) and near(changed.b,width/2),game..' 飞行中换色/换图仍保留原判定')
        end
    end
end
-- 接收真实 laser.frame 的命中回调，用矩形内外两点校验宽度和轴向裁剪。
local hits=0
player={x=0,y=0,grazer={a=0,class={colli=function() end}},class={colli=function() hits=hits+1 end}}
local function ray(game,full,factor,start,straight)
    local cls=OriginalBulletVisual.laser(laser,game)
    local o=New(cls,1,0,0,0,0,100,0,full/(factor or 1),0,0)
    o.w=full/(factor or 1);o.alpha=1;o.colli=true;o.bound=false
    o._visual_width_factor=factor;o._native_laser_start=start;o._native_laser_straight=straight
    return o
end
for _,game in ipairs({7,8,95}) do
    local o=ray(game,16)
    check(rawget(o.class,'CyGrow')==laser.CyGrow and rawget(o.class,'_TurnOn')==laser._TurnOn,
        '真实 Class 只复制六个回调，代理类必须显式保留激光静态方法')
    player.x,player.y=50,3.9;hits=0;o.class.frame(o);check(hits==1,'原作 16px 光束命中半宽 4px：内点命中')
    player.y=4.1;hits=0;o.class.frame(o);check(hits==0,'原作光束判定外点不命中')
    calls={};o.class.render(o)
    local middle=calls[game==8 and 1 or 2];local g=resources[middle.name]
    check(near((game==8 and g.w*middle.h or g.h*middle.v)*g.scale,16),'激光显示全宽 16px')
    check(o.w==16 and o.w0==16,'渲染后不污染碰撞宽度和最大宽度')
end
local half=ray(8,16,2)
player.x,player.y=50,3.9;hits=0;half.class.frame(half);check(hits==1,'已减半的 TH31 激光不重复减半')
player.y=4.1;hits=0;half.class.frame(half);check(hits==0,'TH31 半宽口径仍与原版一致')
local shifted=ray(8,16,nil,64)
player.x,player.y=10,0;hits=0;shifted.class.frame(shifted);check(hits==0,'起点偏移正数时，原作两端各裁去 15%')
player.x=20;hits=0;shifted.class.frame(shifted);check(hits==1,'原作中间 70% 保持有判定')
local th07shifted=ray(7,16,nil,64)
player.x=10;hits=0;th07shifted.class.frame(th07shifted);check(hits==1,'TH07 不套用 TH08 的 70% 长度规则')
local straight=ray(95,16,nil,0,true)
player.x,player.y=50,0;hits=0;straight.class.frame(straight);check(hits==0,'TH095 ins145 保留原版 width>40 的判定闸')
for _,game in ipairs({7,8}) do
    local o=ray(game,16)
    if game==7 then o.pl_state,o.pl_t,o.pl_lw,o.pl_hbEnd=2,1,16,20
    else o._native_laser_phase={'phase','clock',20,16};o.phase,o.clock=3,1 end
    o.colli=false;o.w=8
    player.x,player.y=10,0;hits=0;o.class.frame(o);check(hits==0,'收束只保留中点小矩形，不能整条仍有判定')
    player.x,player.y=50,3.9;hits=0;o.class.frame(o);check(hits==1,'原作收束期的中点判定不能被完全删掉')
    if game==7 then o.pl_t=21 else o.clock=21 end
    hits=0;o.class.frame(o);check(hits==0,'原作 hitboxEndDelay 到点关闭中点判定')
end
local wide95=ray(95,64)
player.x,player.y=50,23.9;hits=0;wide95.class.frame(wide95);check(hits==1,'TH095 大于32的宽激光使用 width−16 的判定全宽')
player.y=24.1;hits=0;wide95.class.frame(wide95);check(hits==0,'TH095 宽光束外点不命中')
local box=ray(7,32);box._native_laser_box=true
player.x,player.y=50,10.5;hits=0;box.class.frame(box);check(hits==1,'横斩按敌人接触框除以1.5，框内命中')
player.y=10.8;hits=0;box.class.frame(box);check(hits==0,'横斩接触框外不命中')
player.x,player.y=10,0;hits=0;box.class.frame(box);check(hits==0,'横斩的长度同样除以1.5，围绕原框中心裁剪')
OriginalBulletVisual.native_laser(box,3,0,32,4)
player.x=50;hits=0;box.class.frame(box);check(hits==0,'横斩实体寿命结束后不增加激光消散期伤害')
local live=New(actual_lasers.th08,0,0,0)
player.x,player.y=300,2.4
for _=1,111 do live.class.frame(live) end
hits=0;live.class.frame(live);check(hits==1,'真实 TH31 卡209 满宽期命中半宽2.5px')
player.y=2.6;hits=0;live.class.frame(live);check(hits==0,'真实 TH31 卡209 满宽期外点不命中')
for _=1,50 do live.class.frame(live) end
player.x,player.y=10,0;hits=0;live.class.frame(live);check(hits==0,'真实 TH31 卡209 收束期不留下整根判定')
player.x=300;hits=0;live.class.frame(live);check(hits==1,'真实 TH31 卡209 收束期恢复原作中点小判定')
local wide10=New(actual_lasers.th10,0,0,13,1,0,128,128,0,0,46)
player.x,player.y=64,7.4;hits=0;wide10.class.frame(wide10);check(hits==1,'TH35 原作宽46激光命中半宽7.5px')
player.y=7.6;hits=0;wide10.class.frame(wide10);check(hits==0,'TH35 宽激光碰撞公式保持原版')
-- 原生ANM的朝向不随代理图样改变；自转只影响绘制，不能反过来驱动物理rot。
for _,case in ipairs({{6,2,grain_a},{7,9,knife},{8,11,square},{95,16,star_big},{10,16,star_big}}) do
    local style=OriginalBulletVisual.native_style(case[1],case[2],case[3])
    local o=NewSimpleBullet(style,2,0,0,2,90,false,0,false)
    o.dx,o.dy,o.vx,o.vy=2,0,0,2
    check(near(bullet.GetRenderRotation(o),90),'原生ANM随当前弹道旋转，忽略上一帧dx及代理星弹默认值')
    calls={};bullet.render(o)
    check(near(calls[#calls].rot,0),'原作贴图朝上，弹道90度对应绘制角0度')
end
for _,case in ipairs({{8,12,star_small,0.05235988},{8,13,star_small,-0.05235988},
    {8,14,star_big,0.03141593},{8,15,star_big,-0.03141593},
    {95,17,ball_huge,0.7853982},{10,17,ball_huge,0.7853982},
    {10,24,ball_small,0.19634955},{10,26,grain_a,0.10471976}}) do
    local o=NewSimpleBullet(OriginalBulletVisual.native_style(case[1],case[2],case[3]),2,0,0,2,13,false,0,false)
    for frame=1,30 do o.ani=frame;OriginalBulletVisual.step_anm(o) end
    local before={o.rot,o.vx,o.vy}
    calls={};bullet.render(o)
    local ticks=(((case[1]==95 or case[1]==10) and case[2]==17) or (case[1]==10 and case[2]==26)) and 32 or 31
    -- 大玉在脚本前导段就设置自转，其余旋转弹在主弹段开始设置或重置旋转。
    check(near(calls[#calls].rot,-ticks*case[4]*180/math.pi),('ANM自转角速度：TH%d type%d 实测%.9f 预期%.9f'):format(case[1],case[2],calls[#calls].rot,-ticks*case[4]*180/math.pi))
    check(o.rot==before[1] and o.vx==before[2] and o.vy==before[3],'贴图自转不改变逻辑角和弹道')
end
local changing=NewSimpleBullet(OriginalBulletVisual.native_style(8,12,star_small),2,0,0,2,0,false,0,false)
bullet.ChangeImage(changing,OriginalBulletVisual.native_style(8,2,grain_a),2)
changing.vx,changing.vy=0,2
check(near(bullet.GetRenderRotation(changing),90),'飞行中换弹型时同步切换ANM朝向策略')
changing.ani=90
bullet.ChangeImage(changing,OriginalBulletVisual.native_style(8,12,star_small),2)
check(near(bullet.GetRenderRotation(changing),-0.05235988*180/math.pi),'飞行中换成自转弹时从新ANM首帧开始')
changing.ani=91
bullet.ChangeImage(changing,changing.imgclass,16,true)
check(near(bullet.GetRenderRotation(changing),-2*0.05235988*180/math.pi),'缓时灰化换色不重置ANM自转相位')
check(changing.rank_speed==false,'原作弹不会被全局Rank叠加第二段位移')
-- 使用实际消弹圈和实际TH31激光，防止清场复制无寿命的代理光束、耗尽对象池。
dofile('THlib/bullet/clearbullet.lua')
local beam=New(actual_lasers.th08,0,0,0)
beam.lw209_state,beam.lw209_timer,beam.w,beam.colli=2,40,5,true
laser.CutOnUnit(beam,{x=30,y=0})
check(beam.lw209_state==2 and beam.l2==600,'无敌自机接触不能截出脱离原作弹池的激光片段')
local old_lasers=object.LaserDo
object.LaserDo=function(fn) fn(beam) end
local drops=0
cutLasersByCircle(0,0,800,function() drops=drops+1 end)
check(drops==19 and beam.lw209_state==3 and beam.lw209_timer==0,
    '600px原作激光只按32px采样19个掉落，并进入自身的消散状态')
check(beam.class==actual_lasers.th08 and not beam.colli,'消原作激光不替换成失去寿命的THlib片段')
cutLasersByCircle(0,0,800,function() drops=drops+1 end)
check(drops==19,'同一个消弹圈后续帧不重复转换原作激光')
local natural=New(actual_lasers.th08,0,0,0)
natural.lw209_state=3
local fade_drops=0
OriginalBulletVisual.laser_drops(natural,function() fade_drops=fade_drops+1 end)
check(fade_drops==0,'原本已在DESPAWNING的激光不再次转成道具')
object.LaserDo=old_lasers
local beam10=New(actual_lasers.th10,0,0,3,1,0,128,128,0,0,16)
local count10=0
OriginalBulletVisual.laser_drops(beam10,function() count10=count10+1 end)
check(count10==10,'TH10消激光从6px起每12px采样，末端留6px，不能套用TH08的32px')
local length10=beam10.l2
laser.CutOnUnit(beam10,{x=64,y=0})
check(beam10.l2==length10,'TH10无敌自机接触也不能生成丢失ECL变换程序的THlib光段')
local protected=ray(7,16)
protected.pl_flags=4
local protected_drops=0
OriginalBulletVisual.laser_drops(protected,function() protected_drops=protected_drops+1 end)
OriginalBulletVisual.cancel_laser(protected)
check(protected_drops==0 and not protected._native_cancelled,'TH07 flags4激光保留普通消弹免疫')
OriginalBulletVisual.cancel_laser(protected,false,true)
check(protected._native_cancelled,'TH07强制结算清场仍可回收flags4激光')
local cleaned=New(actual_lasers.th08,0,0,0)
cleaned.lw209_state,cleaned.lw209_timer,cleaned.w,cleaned.colli=2,40,5,true
local old_bullets=object.BulletDo
local old_dist=Dist
Dist=function(a,b,...)
    if type(a)=='table' and type(b)=='table' then return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2) end
    return old_dist(a,b,...)
end
object.BulletDo=function() end
object.LaserDo=function(fn) fn(cleaned) end
local cleaner=New(bullet_cleaner,0,0,800,0,30,false,true,0,0)
cleaner.class.frame(cleaner)
check(IsValid(cleaned) and cleaned.lw209_state==3 and cleaned.class==actual_lasers.th08,
    '完整消弹圈的第二轮扫描不再次Del已进入原生退场状态的光柱')
local corner=New(actual_lasers.th08,700,700,0)
corner.lw209_state,corner.w,corner.colli=2,5,true
object.LaserDo=function(fn) fn(corner) end
cutLasersByCircle(0,0,800)
check(not corner._native_cancelled,'原生激光在消弹圈外的角落不能被投影包围盒误清除')
object.BulletDo,object.LaserDo=old_bullets,old_lasers
Dist=old_dist
-- 对象自转不能把原作AABB旋成菱形；受弹框和接触框分别切换，随后完整恢复。
local C=OriginalCollision
local victim={rot=37,rect=false,a=24,b=32,colli=true,_live=true}
C.unit(victim,7,'ecldata1:48',true)
check(victim.a==24 and victim.b==32,'实际中断链继承蕾蒂48×64受弹框')
local hero={rot=19,rect=false,a=2,b=3,colli=true,_live=true}
local shot={rot=70,rect=false,a=3,b=8,colli=true,_live=true}
local lists={[GROUP.ENEMY]={victim},[GROUP.PLAYER]={hero},[GROUP.PLAYER_BULLET]={shot}}
local oldList=ObjList
ObjList=function(group) return ipairs(lists[group] or {}) end
C.begin()
check(victim.rot==0 and victim.rect and near(victim.a,16) and near(victim.b,64/3),'接触阶段除以1.5，取消精灵自转')
check(hero.rect and hero.rot==0,'自机角落参与原作矩形碰撞')
C.shots();check(victim.a==24 and victim.b==32 and shot.rot==0 and shot.rect,'自机弹阶段恢复完整受弹框')
C.finish();check(victim.rot==37 and victim.a==24 and hero.rot==19 and not hero.rect and shot.rot==70 and not shot.rect,'碰撞结束恢复运动角、原判定形状与尺寸')
victim.a,victim.b=48,48 -- 模拟行走图切换覆盖资源默认半径。
C.begin()
check(near(victim.a,16) and near(victim.b,64/3),'换图覆盖a/b之后，体术仍使用ECL判定尺寸')
C.shots();check(victim.a==24 and victim.b==32,'换图覆盖a/b之后，受弹仍使用ECL判定尺寸')
C.finish()
local inherited={}
C.unit(inherited,8,'ecldata2:44',true)
check(inherited.a==24 and inherited.b==24,'二面普通战斗沿时间轴Sub17继承48×48，不混入未生成的Sub25')
C.unit(inherited,8,'ecldata2:58',true)
check(inherited.a==12 and inherited.b==12,'另生的Last Spell从24×24模板初始化，不能沿用中Boss判定')
C.unit(inherited,8,'ecldata8:65',true)
check(inherited.a==24 and inherited.b==40,'Extra普通战斗构造入口的48×80判定')
C.unit(inherited,8,'ecldata8:84',true)
check(inherited.a==12 and inherited.b==12,'Extra Last Spell的独立构造入口重置判定')
local collisionArrow=NewSimpleBullet(OriginalBulletVisual.native_style(7,4,arrow_mid),2,0,0,0,37,false,0,false)
collisionArrow.th07_cull_managed=true;collisionArrow.rot=37
lists[GROUP.ENEMY_BULLET]={collisionArrow}
C.begin()
check(collisionArrow.rot==0 and bullet.GetRenderRotation(collisionArrow)==37,'碰撞期间分离零角AABB和真实弹道朝向')
OriginalBulletVisual.emit_despawn(collisionArrow,false)
check(near(collisionArrow.angle,-53),'碰撞触发的消散特效保留弹道角，不能跟着判定框归零')
C.finish()
check(collisionArrow._original_collision_rot==nil,'碰撞结束清除临时角度记录')
ObjList=oldList
local visual=OriginalBulletVisual
local slowArrow=NewSimpleBullet(visual.native_style(7,6,arrow_big_c),2,0,0,2,0,false,0,false)
local arrowVM,arrowSprite=slowArrow._native_anm,slowArrow._native_anm.sprite
slowArrow.own_gray=true;visual.render_anm(slowArrow)
check(calls[#calls].name==arrowVM.data.sprites[arrowSprite-slowArrow._native_color+15].img,
    '妖梦缓时使用原作白色箭头精灵')
check(slowArrow._native_anm==arrowVM and arrowVM.sprite==arrowSprite,'缓时换色不重开动画或污染弹型状态')
slowArrow.own_gray=false;visual.render_anm(slowArrow)
check(calls[#calls].name==arrowVM.data.sprites[arrowSprite].img,'恢复速度同时恢复原箭头颜色')
local smoke=NewSimpleBullet(visual.native_style(6,0,ball_small),2,0,0,0,0,false,0,false)
smoke.th06_spawn=10;visual.sync_spawn(smoke)
check(smoke._native_anm.id==14,'红魔乡小颗粒出生使用14，不误取大一号弹雾17')
check(not visual.can_cancel(smoke,false) and visual.can_cancel(smoke,true),'红魔乡出生期不接受玩家消弹，换卡强制清场仍有效')
for _,game in ipairs({6,7,8,95,10}) do
    local a=NewSimpleBullet(visual.native_style(game,0,ball_small),2,0,0,0,0,false,0,false)
    local b=NewSimpleBullet(visual.native_style(game,0,ball_small),2,0,0,0,0,false,0,false)
    local key=({[6]='th06_spawn',[7]='c_spawn_left',[8]='ex_spawn',[95]='th095_spawn_left'})[game]
    local function remaining(o,n) if key then o[key]=n else o.tb={spawn=n,cancel=0,angle=0} end end
    remaining(a,8);remaining(b,8)
    visual.render_anm(a) -- 比较出生当帧绘制过与从未绘制过的两条路径。
    local ref=OriginalANM.new(game,a._native_anm.data.archive,a._native_anm.id)
    if game==95 or game==10 then OriginalANM.interrupt(ref,7) end
    for t=1,7 do
        remaining(a,8-t);remaining(b,8-t);a.ani,b.ani=t,t
        visual.step_anm(a);visual.step_anm(b);OriginalANM.step(ref)
        check(near(a._native_anm.time,b._native_anm.time) and near(a._native_anm.time,ref.time)
            and near(a._native_anm.scale[1],ref.scale[1]),'弹雾ANM每逻辑帧执行一次，不依赖是否绘制：'..game..'/'..t)
    end
end
local immune=NewSimpleBullet(visual.native_style(8,3,ball_small),2,0,0,0,0,false,0,false)
immune.ex_flags=4096
check(not visual.can_cancel(immune,false) and visual.can_cancel(immune,true),'永夜抄 CANCEL_IMMUNE 与强制清场区分')
immune.ex_flags=0;immune.ex_spawn=4
visual.cancel_bullet(immune,'Del')
check(immune._original_cancel_pending=='Del' and IsValid(immune),'永夜抄出生期只记录取消标志')
immune.ex_spawn=0;immune.ani=immune.ani+1;visual.step_anm(immune)
check(not immune._original_cancel_pending and IsValid(immune),'永夜抄出生结束的activateBullet保留弹体，不能误做延迟删除')
local protected=NewSimpleBullet(visual.native_style(10,3,ball_small),2,0,0,0,0,false,0,false)
protected.tb={cancel=20}
check(not visual.can_cancel(protected,false),'风神录消弹保护计时未结束时保留子弹')
protected.tb.cancel=0;check(visual.can_cancel(protected,false),'风神录消弹保护到点恢复')
-- 所有原生弹型的消散都实际推进至ANM结束，避免新增无期限的无判定对象。
for _,game in ipairs({6,7,8,95,10}) do
    for kind in pairs(visual.profiles[game]) do
        local o=NewSimpleBullet(visual.native_style(game,kind,ball_small),math.min(2,visual.color_count(game,kind)),0,0,2,0,false,0,false)
        -- 不依赖simple_bullet参数口径，明确物理字段供退场验证。
        o.vx,o.vy=4,2
        local effect=o
        check(visual.emit_despawn(o,false) and effect.vm~=nil and IsValid(o),
            '原作消散保留同一对象占槽，不提前释放弹池位置')
        check(effect.vx==2 and effect.vy==1 and not effect.colli,'消散按半速移动且无判定')
        check(effect.group~=GROUP.GHOST,'碰撞回调中的消散保留原分组到遍历结束')
        effect.class.frame(effect)
        check(effect.group==GROUP.GHOST,'消散在下一次对象更新切入无害分组')
        for _=1,90 do if not effect.vm.finished then effect.class.frame(effect) end end
        check(effect.vm.finished,'原作消散ANM能正常结束：'..game..'/'..kind)
    end
end
-- 真实命中入口必须在C.shots把rot暂时归零时仍生成正确朝向的特效。
do
    local f=assert(io.open('THlib/player/player.lua','rb'));local code=f:read('*a');f:close()
    local first=assert(code:find('player_bullet_straight = Class(object)',1,true))
    local last=assert(code:find('player_death_ef = Class(object)',first,true))
    assert(loadstring(code:sub(first,last-1)))()
    player_class=Class(object);grazer=Class(object)
    LoadPS=function() end
    dofile('THlib/player/reimu/reimu.lua');dofile('THlib/player/marisa/marisa.lua');dofile('THlib/player/chiruno/chiruno.lua')
    local savedList=ObjList
    local target={_live=true,colli=true,rot=0,rect=true,a=12,b=12,_original_collision_game=8}
    local oldPre,oldMax=player.pre,player.maxpre;player.pre,player.maxpre=0,100
    for _,cls in ipairs({reimu_player.bullets.square,reimu_player.bullets.needle,reimu_player.bullets.trail,
                         marisa_player.bullets.main,chiruno_player.bullets.main}) do
        for _,angle in ipairs({-90,0,37,90}) do
            local shot=New(cls,0,0,10,angle,1,1);shot.colli=true
            ObjList=function(group) return ipairs(group==GROUP.ENEMY and {target} or group==GROUP.PLAYER_BULLET and {shot} or {}) end
            C.begin();C.shots();check(shot.rot==0,'原作受击框仍使用AABB角度')
            local effects=emitted(function() cls.kill(shot) end)
            check(#effects>0,'命中回调实际生成特效')
            for _,effect in ipairs(effects) do check(near(effect.rot,angle),'三种自机命中特效保留碰撞前方向') end
            C.finish();check(near(shot.rot,angle),'命中演出不干扰碰撞阶段的角度恢复')
        end
    end
    ObjList=savedList;player.pre,player.maxpre=oldPre,oldMax
end
print(('子弹映射、旋转与激光尺寸回归通过：%d 项'):format(checks))
