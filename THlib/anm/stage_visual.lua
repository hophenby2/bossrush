-- TH31–TH35 的原作行走图和符卡背景。角色只选择原作资源，帧序由 ANM 执行。
-- 红/妖的姿态号是 ANM 文件内的原始编号；永/文/风使用载入后连续的脚本索引。
OriginalStageVisual = {}
local S,A=OriginalStageVisual,OriginalANM
local games={ [29]=8,[30]=6,[31]=95,[32]=7,[33]=10 }
local roles={}
S.adapters={}
roles[8]={Nightbug={'stg1enm',0,'eff01'},Lorelei={'stg2enm',0,'eff02'},
    Kamishirasawa={'stg3enm',0,'eff03'},Kamishirasawa2={'stg8enm',0,'eff08'},
    Reisen={'stg5enm',12,'eff05'},Tewi={'stg5enm',0,'eff05'},Yagokoro={'stg6enm',0,'eff06'},
    Neet={'stg7enm',7,'eff07'},Mokou={'stg8enm',6,'eff08'},Reimu={'stg4aenm',0,'eff04a'},
    Marisa={'stg4benm',0,'eff04b'},Sakuya={'stgenm_sk',0,'eff09sk'},Youmu={'stgenm_ym',0,'eff09ym'},
    Alice={'stgenm_al',0,'eff09al'},Remilia={'stgenm_rm',0,'eff09rm'},Yuyuko={'stgenm_yy',0,'eff09yy'},
    Yukari={'stgenm_yk',2,'eff09yk'}}
roles[7]={Chiruno={'stg1enm',128,'eff01'},Whiterock={'stg1enm',132,'eff01'},
    Chen={'stg2enm',128,'eff02'},Alice={'stg3enm',128,'eff03'},
    Lunasa={'stg4enm',128,'eff04'},Merlin={'stg4enm',134,'eff04'},Lyrica={'stg4enm',140,'eff04'},
    Youmu={'stg5enm',128,'eff05'},Yuyuko={'stg6enm',128,'eff06'},
    Ran={'stg7enm',134,'eff07'},Yukari={'stg8enm',128,'eff08'}}
roles[6]={Rumia={'stg1enm2',128,'eff01'},Daiyousei={'stg1enm',0,'eff01'},
    Chiruno={'stg2enm2',128,'eff02'},Meirin={'stg3enm',64,'eff03'},
    Knowledge={'stg4enm',65,'eff04'},Sakuya={'stg5enm2',128,'eff05'},
    Remilia={'stg6enm2',160,'eff06'},Flandre={'stg7enm2',160,'eff07'}}
-- SceneSelect.cpp 的 enm 编号；不能按关卡显示顺序推算。
local names95={'Nightbug','Rumia','Chiruno','Whiterock','Kamishirasawa','Alice','Reisen','Tewi',
    'Medicine','Meirin','Knowledge','Chen','Youmu','Sakuya','Remilia','Ran','Yuyuko','Yagokoro','Neet',
    'Komachi','Shikieiki','Flandre','Yukari','Mokou','Suika'}
roles[95]={}
for i,name in ipairs(names95) do roles[95][name]={'enm'..i,i==23 and 4 or 2,'enm'..i} end
roles[10]={Sizuha={'stgenm01',0},Minoriko={'stgenm01',5},Hina={'stgenm02',5},
    Nitori={'stgenm03',0},Aya={'stgenm04',0},Momizi={'stgenm04',6},
    Sanae={'stgenm05',6},Kanako={'stgenm06',6},Suwako={'stgenm07',0}}
local function resolve_script(game,archive,id)
    local data=A.load(game,archive)
    if game==6 and not data.ids[id] then
        local stem=archive:match('^(stg%d+enm)')
        if stem then
            archive=archive==stem and stem..'2' or stem
            data=A.load(game,archive)
        end
    end
    return archive,(game==6 or game==7) and assert(data.ids[id],archive..'/原始脚本'..id) or id
end
local function new_script(game,archive,id)
    local file,index=resolve_script(game,archive,id)
    return A.new(game,file,index)
end
function S.actor(o,game,archive,id,poses)
    o._original_actor={game=game,archive=archive,poses=poses,direction=255,
        vm=new_script(game,archive,id),slots={},tick=o.ani}
    o.hide=false
    return o._original_actor
end
function S.set_script(o,id,archive)
    local state=assert(o._original_actor)
    state.archive=archive or state.archive
    state.vm=new_script(state.game,state.archive,id)
end
-- TH10的ECL设置主ANM时保存可视范围，之后的动画缩放不持续改写此快照。
function S.capture_visibility(o)
    local actor=o._original_actor
    local v=actor and actor.vm
    local sprite=v and v.data.sprites[v.sprite]
    if not sprite then return end
    -- 原码+0x13a4=VM.spriteHeight*scaleY，+0x13a8=VM.spriteWidth*scaleX，保留交换。
    o._original_visibility={sprite[5]*v.scale[2],sprite[4]*v.scale[1]}
end
function S.main_script(o,game,archive,id)
    local old=o._original_actor
    if old and old.game==game and old.archive==archive then S.set_script(o,id);return end
    local slots=old and old.game==game and old.slots
    S.actor(o,game,archive,id)
    -- 设置主动画只替换主 VM；法阵等附属槽由各自的清除指令释放。
    if slots then o._original_actor.slots=slots end
end
function S.poses(o,poses)
    local state=assert(o._original_actor)
    state.poses=poses;state.direction=255
end
function S.slot(o,index,id,archive)
    local s=assert(o._original_actor)
    s.slots[index]=id>=0 and new_script(s.game,archive or s.archive,id) or nil
end
-- 附着使魔的光环取etama.anm，独立于enemy.anm的主动画及附属槽。
function S.familiar(o,youkai,variant)
    local state=o._original_alignment
    if not state or variant~=nil then
        variant=variant or 0
        assert(variant>=0 and variant<=2,'未支持的原作使魔光环变体')
        state={vm=A.new(8,'etama',48+variant),variant=variant,tick=o.ani,particles=state and state.particles or {}}
        o._original_alignment=state
    end
    if state.youkai~=youkai then
        A.interrupt(state.vm,youkai and 2 or 1)
        state.youkai=youkai
    end
    state.vm.secondary=o._original_familiar_collision or false
    return state
end
local alignment_fade=Class(object,{
    init=function(o,source,vm)
        o.x,o.y,o.vm,o.layer=source.x,source.y,vm,source.layer or LAYER.ENEMY
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
    end,
    frame=function(o) A.step(o.vm);if o.vm.finished then object.RawDel(o) end end,
    render=function(o) A.draw(o.vm,o.x,o.y) end,
},true)
function S.release_familiar(o)
    local state=o._original_alignment
    if not state then return end
    o._original_alignment=nil
    for _,p in ipairs(state.particles) do New(alignment_fade,p,p.vm) end
    A.interrupt(state.vm,3)
    New(alignment_fade,o,state.vm)
end
local function draw_alignment(o)
    local state=o._original_alignment
    if not state then return end
    for _,p in ipairs(state.particles) do A.draw(p.vm,p.x,p.y) end
    A.draw(state.vm,o.x,o.y)
end
function S.tick(o,vx)
    local s=o._original_actor
    if not s then return end
    if o.th07_visual_clock and o.th07_visual_stamp~=o.ani then
        S.source_frame(o,o.th07_visual_clock)
        o.th07_visual_clock=o.th07_visual_clock+1
        o.th07_visual_stamp=o.ani
        s=o._original_actor
    end
    if s.tick==o.ani then return end
    s.tick=o.ani
    local p=s.poses
    if p and p[2] and p[2]>=0 then
        vx=vx or o.dx or 0
        local limit=s.game==6 and 0 or s.game==10 and .1 or .01
        local dir=vx< -limit and 1 or vx>limit and 2 or 0
        if dir~=s.direction then
            local id=dir==1 and p[2] or dir==2 and p[3]
                or s.direction==1 and p[4] or s.direction==2 and p[5] or p[1]
            local data=A.load(s.game,s.archive)
            local index=(s.game==6 or s.game==7) and data.ids[id] or id
            if index and data.scripts[index] then S.set_script(o,id);s.direction=dir end
        end
    end
    A.step(s.vm)
    for _,vm in pairs(s.slots) do A.step(vm) end
    local alignment=o._original_alignment
    if alignment and alignment.tick~=o.ani then
        alignment.tick=o.ani;A.step(alignment.vm)
        for i=#alignment.particles,1,-1 do
            local p=alignment.particles[i];A.step(p.vm)
            if p.vm.finished then table.remove(alignment.particles,i) end
        end
        if o.th08_attached and o._original_form_effect_enabled and not alignment.youkai and o.ani%2==0 then
            alignment.particles[#alignment.particles+1]={vm=A.new(8,'etama',71),x=o.x,y=o.y,layer=o.layer}
        end
    end
    local adapter=S.adapters[s.game]
    if adapter and adapter.tick then adapter.tick(o) end
end
function S.draw(o)
    if o._original_hidden then draw_alignment(o);return true end
    local s=o._original_actor
    if not s then draw_alignment(o);return o._original_alignment~=nil or o._original_no_sprite or false end
    local adapter=S.adapters[s.game]
    if adapter and adapter.draw and adapter.draw(o) then return true end
    if o._original_rotate_with_movement then
        local x,y=o.dx or 0,o.dy or 0
        local angle=o._angdir or ((x~=0 or y~=0) and math.deg(math.atan2(y,x))) or o._original_collision_rot or o.rot
        s.vm.rotation[3]=-angle*math.pi/180
    end
    local alpha=(o._original_source or o._original_explicit) and 1 or (o._a or 255)/255
    local tint=not (o._original_source or o._original_explicit) and {o._r or 255,o._g or 255,o._b or 255} or nil
    for _,vm in pairs(s.slots) do A.draw(vm,o.x,o.y,o.rot,1,1,alpha,tint) end
    local override=o._original_enemy_color and {color=o._original_enemy_color,alpha=s.vm.alpha[1]/2}
    A.draw(s.vm,o.x,o.y,o.rot,1,1,alpha,tint,override)
    draw_alignment(o)
    return true
end
local source_data
local visual_loops=dofile('mod/GAME/original/visual_loops.lua')
local function source_archive(game,file,alternate)
    if game==10 then return 'stgenm'..assert(file:match('stage(%d+)')) end
    if game==95 then return 'enm'..assert(file:match('ecl(%d+)_')) end
    if game==7 then return 'stg'..assert(file:match('ecldata([1-8])'))..'enm' end
    if not alternate then return 'enemy' end
    local stage=file:match('ecldata([1-8][ab]?)')
    if stage then return 'stg'..stage..'enm' end
    return 'stgenm_'..assert(file:match('ecldata_(%a+)'))
end
local function animation_event(o,game,file,c)
    local op=c[2]
    if game==8 and op==83 then o._original_form_effect_enabled=c[3]~=0;return end
    if game==8 and op==174 then
        S.familiar(o,o.th08_youkai or false,c[3]);return
    end
    if (game==8 or game==95) and op>=79 and op<=81 then
        -- NO_SPRITE 仍会播放动画、执行发弹，只禁止绘制本体。
        local hidden=math.floor(c[3]/8)%2==1
        if game==8 then
            local accepts=math.floor(c[3])%2==1
            local damageable=math.floor(c[3]/4)%2==1
            local no_death=math.floor(c[3]/32)%2==1
            if op==79 then
                o._original_accepts_damage=not accepts
                o._original_damageable=not damageable
                o._original_no_death=no_death
            else
                if accepts then o._original_accepts_damage=op==81 end
                if damageable then o._original_damageable=op==81 end
                if no_death then o._original_no_death=op==80 end
            end
            local collision=math.floor(c[3]/2)%2==1
            if op==79 then o._original_familiar_collision=not collision
            elseif collision then o._original_familiar_collision=op==81 end
        end
        if op==79 then o._original_hidden=hidden
        elseif hidden then o._original_hidden=op==80 end
        return
    end
    if game==10 then
        local source=o._original_source
        local function val(a)
            if type(a)~='table' then return a end
            return o['I'..math.floor(a.arg/4)] or 0
        end
        if op==258 then source.bank=val(c[3]);return end
        local archive=source.bank==0 and 'bullet' or source.bank==1 and 'enemy' or source_archive(game,file)
        if op==259 or op==262 then
            local slot,id=val(c[3]),val(c[4])
            if id<0 then
                local actor=o._original_actor
                if actor then
                    if slot==0 then actor.vm.visible=false;actor.vm.finished=true;actor.poses=nil
                    else actor.slots[slot]=nil end
                end
                return
            end
            if slot==0 then
                S.main_script(o,game,archive,id)
                if op==262 then S.poses(o,{id,id+1,id+2,id+3,id+4});o._original_actor.special=id+5 end
                S.capture_visibility(o)
            else
                if not o._original_actor then S.actor(o,game,archive,id);o._original_actor.vm.visible=false end
                o._original_actor.slots[slot]=A.new(game,archive,id)
            end
        elseif op==269 and o._original_actor and o._original_actor.special then
            S.set_script(o,o._original_actor.special)
            S.capture_visibility(o)
        end
        return
    end
    local source=o._original_source
    -- 57先按当前库创建附属VM，再清alternate标志；61先切到角色库再创建。
    local alternate=(op>=58 and op<=61) or (op==57 and source and source.alternate)
    local archive=source_archive(game,file,alternate)
    if game==7 then
        if op==95 then
            local old=o._original_actor
            if old then S.set_script(o,c[3]) else S.actor(o,game,archive,c[3]) end
        elseif op==96 then
            local p
            if c[6]~=nil then p={c[3],c[6],c[7],c[4],c[5]}
            else
                -- TH07原始96的五个姿态是short，导出表保留了三项32位原始字。
                local function short(word,high)
                    local n=math.floor(word/(high and 65536 or 1))%65536
                    return n>=32768 and n-65536 or n
                end
                p={short(c[3]),short(c[4],true),short(c[5]),short(c[3],true),short(c[4])}
            end
            if p[1]<0 then if o._original_actor then o._original_actor.poses=nil end;return end
            if not o._original_actor then S.actor(o,game,archive,p[1],p) else S.poses(o,p) end
        elseif op==97 and o._original_actor then S.slot(o,c[3],c[4])
        elseif op==128 and o._original_actor then A.interrupt(o._original_actor.vm,c[3])
        elseif op==129 and o._original_actor and o._original_actor.slots[c[3]] then A.interrupt(o._original_actor.slots[c[3]],c[4])
        elseif op==132 then o._original_hidden=c[3]~=0
        elseif S.adapters[7] and S.adapters[7].event then S.adapters[7].event(o,c) end
        return
    end
    if op==54 or op==58 then
        S.main_script(o,game,archive,c[3])
    elseif op==55 or op==59 or op==56 or op==60 then
        local p={}
        for i=1,6 do p[i]=(op==55 or op==59) and c[3]+i-1 or c[i+2] end
        local old=o._original_actor
        if old and old.game==game and old.archive==archive then old.poses=p;old.direction=255
        else S.actor(o,game,archive,p[1],p) end
    elseif (op==57 or op==61) and o._original_actor then
        local s=o._original_actor
        s.slots[c[3]]=c[4]>=0 and new_script(game,archive,c[4]) or nil
    elseif op==62 and o._original_actor then
        local s=o._original_actor
        if s.poses and s.poses[6] then S.set_script(o,s.poses[6],source_archive(game,file,source and source.alternate)) end
    end
    if source and op>=54 and op<=61 then source.alternate=op>=58 end
end
function S.bind_source(o,game,key,preserve,events_override)
    if OriginalCollision then OriginalCollision.unit(o,game,key) end
    if OriginalCollision then OriginalCollision.bind_events(o,game,key) end
    source_data=source_data or dofile('mod/GAME/original/visual_ecl.lua')
    local file=key:match('^([^:]+)')
    local cfg=events_override or source_data[game] and source_data[game][key]
    local bank=game==10 and 0 or 2
    if game==10 and preserve then
        local old=o._original_source
        local actor=o._original_actor
        -- Boss 的符卡子程序继承入场时选择的 ANM；子机则由原作构造器清零成 bullet 槽。
        bank=old and old.bank or actor and (actor.archive=='bullet' and 0 or actor.archive=='enemy' and 1 or 2) or 0
        -- Boss/MBoss 是新敌机的构造入口；其中会先在默认槽创建370号效果，再选角色槽。
        local sub=key:match(':([^:]+)$')
        if sub=='Boss' or sub=='MBoss' then bank=0 end
    end
    o._original_source={game=game,key=key,file=file,cfg=cfg,index=1,bank=bank}
    if game==95 then o.layer=LAYER.ENEMY-.1 end
    if not preserve then
        o._original_actor=nil;o._original_no_sprite=true;o._original_hidden=false
        if o._original_trail_source then o.th07_trail=nil;o._original_trail_source=nil end
    end
    S.source_frame(o,0)
end
function S.visual_program(game,key)
    source_data=source_data or dofile('mod/GAME/original/visual_ecl.lua')
    return {game=game,key=key,file=key:match('^([^:]+)'),cfg=source_data[game][key],index=1}
end
function S.source_frame(o,clock,program)
    if not program and OriginalCollision then OriginalCollision.events(o,clock) end
    local state=program or o._original_source
    if not state or not state.cfg then return end
    local events=state.cfg.events
    local loop=state.game==95 and visual_loops[state.key]
    local resume_clock
    if loop and clock>=loop[2] then
        local cycle=math.floor((clock-loop[1])/(loop[2]-loop[1]))
        local local_clock=loop[1]+(clock-loop[1])%(loop[2]-loop[1])
        if cycle>(state.visual_cycle or 0) then
            -- 先执行回跳前的末帧事件，再恢复到跳转标签之后；不重播入口姿态。
            resume_clock=local_clock;clock=loop[2]
            state.visual_cycle=cycle
        else clock=local_clock end
    end
    repeat
    while events[state.index] and events[state.index][1]<=clock do
        local c=events[state.index]
        local mask=state.cfg.masks and state.cfg.masks[state.index]
        local combat=_editor_class and _editor_class.TH31 and _editor_class.TH31.th08_combat
        local youkai=o.th08_attached and combat and combat.youkai(o) or false
        local enabled=not mask or math.floor(mask/(youkai and 64 or 32))%2==1
        local resolved={c[1],c[2]}
        for i=3,#c do
            local v=c[i]
            if type(v)=='table' and v.var then
                local n=v.var-10000
                v=o['li'..n] or o['I'..n]
                if v==nil then enabled=false end
            end
            resolved[i]=v
        end
        if enabled then animation_event(o,state.game,state.file,resolved) end
        state.index=state.index+1
    end
    if resume_clock then
        state.index=loop[3];clock=resume_clock;resume_clock=nil
    else break end
    until false
end
function S.wrap_actor(cls,game,key)
    local init,frame,render=cls.init,cls.frame,cls.render
    cls.init=function(o,...)
        init(o,...)
        if not IsValid(o) then return end
        if type(key)=='function' then o._original_visual_args={...} end
        local resolved=key
        if type(key)=='function' then resolved=key(o,...) end
        if resolved then S.bind_source(o,game,resolved) end
        if OriginalBalance and not o._bosssys then OriginalBalance.unit(o,game,false) end
        o._original_visual_origin=o.timer
    end
    cls.frame=function(o)
        if type(key)=='function' then
            local resolved=key(o,unpack(o._original_visual_args))
            if resolved and (not o._original_source or resolved~=o._original_source.key) then
                S.bind_source(o,game,resolved);o._original_visual_origin=o.timer
            end
        end
        S.source_frame(o,o.timer-o._original_visual_origin)
        frame(o)
        if IsValid(o) then S.tick(o) end
    end
    cls.render=function(o) if not S.draw(o) then render(o) end end
    cls[1],cls[3],cls[4]=cls.init,cls.frame,cls.render
end
function S.actor_class(base,game,key,definition)
    local cls=Class(base,definition)
    S.wrap_actor(cls,game,key)
    return cls
end
S.functions={}
function S.register_function(fn,game,key)
    if type(fn)~='function' then return end
    source_data=source_data or dofile('mod/GAME/original/visual_ecl.lua')
    if source_data[game][key] then S.functions[fn]=key end
end
function S.register_functions(game,file,tab,aliases)
    if not tab then return end
    source_data=source_data or dofile('mod/GAME/original/visual_ecl.lua')
    local names={}
    for key in pairs(source_data[game]) do
        if key:sub(1,#file+1)==file..':' then names[key:sub(#file+2):lower()]=key end
    end
    for name,fn in pairs(tab) do
        if type(fn)=='function' then
            local translated=aliases and aliases[name] or name
            translated=translated:gsub('^go?(%d+)',function(n)return 'Girl'..(#n==1 and '0'..n or n)end)
            translated=translated:gsub('^de(%d+)','DiveEnemy%1'):gsub('^sp(%d+)','SpCir%1')
            local key=names[translated:lower()]
            -- Girl 工作者的[0]/[4]是调用实参，不能误读成敌机的I0/I1。
            -- 缺少颜色包装名的旧入口使用原作蓝色包装；保留了原名的入口会在生成前覆盖它。
            if key and names['b'..translated:lower()] then
                local parameterized=false
                for _,c in ipairs(source_data[game][key].events) do
                    for _,a in ipairs(c) do if type(a)=='table' and a.arg then parameterized=true end end
                end
                if parameterized then key=names['b'..translated:lower()] end
            end
            if key then S.functions[fn]=key end
        end
    end
end
local backgrounds={}
local function background_class(game,archive,name)
    local key=game..'/'..archive..'/'..name
    if backgrounds[key] then return backgrounds[key] end
    local bg=Class(object,{
        init=function(o)
            o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.BG+1,false,false
            o.alpha=0;o.vms={};o.active=false
            o._original_background=true;o.age=0
        end,
        frame=function(o)
            local owner=boss_group[1]
            if not owner or not IsValid(owner) then return end
            local card=owner.current_card
            local active=game==95 or (owner.__show_scbg and card and card.is_sc)
            if active and (not o.active or o.card~=card) then
                o.vms={};o.card=card
                o.age=0
                local count=game==6 and 1 or (game==7 and (archive=='eff01' or archive=='eff02' or archive=='eff03') and 1 or 2)
                local base=0
                if game==8 and (archive=='eff06' or archive=='eff07' or archive=='eff08') then
                    -- 原作中 Boss 与本体共用同一份 ANM 的两对背景。
                    base=(name=='Kamishirasawa2') and 0 or 2
                end
                if game==10 then
                    local data=A.load(game,archive)
                    -- 风神录的两个 cdbg 精灵位于 Boss ANM 中，与行走图分开播放。
                    local found={}
                    for id,script in pairs(data.scripts) do
                        for _,c in ipairs(script) do
                            local spr=c.op=='sprite' and data.sprites[c[3]]
                            if spr and spr[4]==384 and spr[5]==448 then found[#found+1]=id;break end
                        end
                    end
                    table.sort(found)
                    for _,id in ipairs(found) do o.vms[#o.vms+1]=A.new(game,archive,id) end
                else
                    for i=0,count-1 do
                        local file=(game==7 and archive=='eff04' and i==1) and 'eff04b' or archive
                        o.vms[#o.vms+1]=A.new(game,file,file~=archive and 0 or base+i)
                    end
                end
            end
            o.active=active
            if active then
                -- 淡入已由原作 ANM 的 60 帧 alpha 控制，不能再乘本项目的 40 帧淡入。
                o.age=o.age+1;o.alpha=math.min(1,o.age/60)
                for _,vm in ipairs(o.vms) do A.step(vm) end
            else o.alpha=0 end
        end,
        render=function(o)
            if not o.active then return end
            SetViewMode('world')
            for _,vm in ipairs(o.vms) do
                -- 红/妖/永/风使用640×480屏幕坐标；文花帖则是场地上沿中心(0,0)。
                -- 必须分别换算，不能把风神录的(224,240)再当局部坐标叠加一次。
                if game==95 then A.draw(vm,0,224) else A.draw(vm,-224,240) end
            end
        end,
    },true)
    backgrounds[key]=bg;return bg
end
function S.bind_boss(wisys,name)
    local o=wisys.obj
    local level=o.class and o.class.StageLevel
    local game=games[level]
    if o.th07_prism_side then game=7 end
    local cfg=game and roles[game][name]
    wisys.original=game~=nil
    if not cfg then
        o._original_actor=nil
        if game then o.WALKIMGID=name;o.img='img_void';o._bg=nil end
        return game~=nil
    end
    local archive,base=cfg[1],cfg[2]
    local bgarchive=cfg[3] or archive
    if game==7 then
        if name=='Chen' and o.th07_visual_file=='ecldata7.ecl' then
            -- EX入场先加载eff02，蓝的Boss对话才将背景索引改到eff07的两层。
            archive,base,bgarchive='stg7enm',128,'eff02'
        elseif name=='Ran' and o.th07_visual_file=='ecldata8.ecl' then
            archive,base,bgarchive='stg8enm',134,'eff07'
        end
    end
    local poses
    if game==6 then
        poses={base,base+1,base+2,base+3,base+4}
        if name=='Knowledge' then poses={65,67,68,69,70} end
        if name=='Meirin' or name=='Daiyousei' then poses=nil end
    elseif game==7 then
        poses={base,base+1,base+2,base+3,base+4}
        if name=='Whiterock' then poses={base,133,134,135,136}
        elseif name=='Chiruno' then poses={128,129,130,129,130}
        elseif name=='Lunasa' or name=='Merlin' or name=='Lyrica' then poses={base,base+2,base+3,base+4,base+5} end
    else poses={base,base+1,base+2,base+3,base+4} end
    local actor=S.actor(o,game,archive,base,poses)
    if game==10 then
        actor.special=base+5
        if OriginalCollision then OriginalCollision.unit(o,10,archive:gsub('stgenm','stage')..':Boss') end
    end
    local a,b=o.a,o.b
    o.WALKIMGID=name;o.img='img_void'
    -- 只替换绘制资源；img_void 的零判定不能覆盖 ECL 的受击框。
    local box=o._original_damage_box
    o.a,o.b,o.rect=box and box[1]/2 or a,box and box[2]/2 or b,true
    o._bg=background_class(game,bgarchive,name)
    return true
end
function S.th06_script(o,stage,id)
    local first='stg'..stage..'enm'
    local archive=A.load(6,first).ids[id] and first or first..'2'
    local s=o._original_actor
    S.main_script(o,6,archive,id)
end
