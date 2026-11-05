-- 原作的弹体/敌机判定是轴对齐矩形，精灵自转不参与判定。
-- LuaSTG 的 rect 共用 rot；只在碰撞阶段置零，进入下一帧前恢复运动角。
local C={}
local widths={
    [6]={[0]=4,6,4,6,5,4,16,11,9,32},
    [7]={[0]=4,6,4,6,4,4,4,10,5,8,24},
    [8]={[0]=4,6,4,6,4,4,4,10,5,8,24,4,4,4,8,8,4,4,5,5,5},
    [95]={[0]=4,6,6,4,4,4,4,4,4,0,4,6,10,8,8,8,8,28,6,10,8,8,8,6},
    -- TH10.exe 文件偏移 0x72de0 的 27 项 float；前24项与文花帖一致。
    [10]={[0]=4,6,6,4,4,4,4,4,4,0,4,6,10,8,8,8,8,28,6,10,8,8,8,6,4,6,4},
}
C.widths=widths
local boxes=dofile('mod/GAME/original/unit_boxes.lua')
local interactions8=dofile('mod/GAME/th31_interaction_sources.lua')
function C.bind_events(o,game,key)
    o._original_interaction_events=game==8 and interactions8[key] or nil
    o._original_interaction_index=1
end
function C.events(o,clock)
    local events=o._original_interaction_events
    if not events then return end
    local index=o._original_interaction_index
    o._original_interaction_clock=clock
    while events[index] and events[index][1]<=clock do
        local e=events[index]
        if e[2]==77 then
            o._original_damage_box={e[3],e[4]}
            o.a,o.b,o.rect=e[3]/2,e[4]/2,true
        elseif e[2]==78 then o._original_secondary_box={e[3],e[4]}
        elseif e[2]==160 then o._original_reduction_until=e[1]+e[3]
        elseif e[2]==183 then o._original_no_damage_during_bomb=e[3]~=0 end
        index=index+1
    end
    o._original_interaction_index=index
end
function C.unit(o,game,key,inherit)
    local box=boxes[game] and boxes[game][key]
    if box and box.inherited and not inherit then box=nil end
    o._original_collision_game=game
    if box then
        if box.damage then
            o._original_damage_box=box.damage
            o.a,o.b,o.rect=box.damage[1]/2,box.damage[2]/2,true
        end
        o._original_contact_box=box.contact
    end
end
function C.bullet(o,game,kind)
    local w=assert(widths[game][kind],'原作弹体判定缺失')
    o._original_collision_game=game
    o.a,o.b,o.rect=w/2,w/2,true
end
local saved,count={},0
local function save(o,enemy)
    count=count+1
    -- 弹密时每帧有上千次保存；复用记录，避免每帧制造上千张临时表。
    local s=saved[count]
    if not s then s={};saved[count]=s end
    s[1],s[2],s[3],s[4],s[5],s[6],s[7]=o,o.rot,o.rect,o.a,o.b,enemy,o.colli
    s[8]=false
    o._original_collision_rot=o.rot
    o.rot,o.rect=0,true
    if enemy then
        local box=o._original_contact_box
        if box then o.a,o.b=box[1]/2,box[2]/2
        elseif enemy==6 or enemy==7 or enemy==8 then
            -- 换 img 或旧行走图可能重写 a/b；体术也必须使用 ECL 的全尺寸。
            local damage=o._original_damage_box
            o.a,o.b=(damage and damage[1]/2 or o.a)/1.5,(damage and damage[2]/2 or o.b)/1.5
        end
    end
end
function C.begin()
    count=0
    local active=false
    for _,group in ipairs({GROUP.ENEMY_BULLET,GROUP.ENEMY_BULLET2,GROUP.INDES,GROUP.ENEMY,GROUP.NONTJT}) do
        for _,o in ObjList(group) do
            local actor=o._original_actor
            local game=o._original_collision_game or actor and actor.game
            if game and o.colli then
                local enemy=(group==GROUP.ENEMY or group==GROUP.NONTJT) and game
                save(o,enemy);active=true
                if enemy==8 and o._original_no_damage_during_bomb and player and (player.nextspell or 0)>0 then
                    saved[count][8]=true
                    SetAttr(o,'colli',false)
                end
            end
        end
    end
    if not active then return end
    for _,o in ObjList(GROUP.PLAYER) do if o.colli then save(o) end end
end
function C.shots()
    if count==0 then return end
    for i=1,count do
        local s=saved[i]
        if s[6] and IsValid(s[1]) then
            local box=s[1]._original_damage_box
            s[1].a,s[1].b=box and box[1]/2 or s[4],box and box[2]/2 or s[5]
            if s[1]._original_accepts_damage==false then s[8]=true;SetAttr(s[1],'colli',false) end
        end
    end
    -- 自机弹与原作敌机的相交测试同样使用 AABB。
    for _,o in ObjList(GROUP.PLAYER_BULLET) do if o.colli then save(o) end end
end
-- 原作先主框、后副框；普通弹在主框命中后已消失，穿透弹仍可命中副框。
function C.secondary()
    for i=1,count do
        local s=saved[i]
        local o=s[1]
        local box=s[6]==8 and IsValid(o) and o.status~='kill' and o.status~='del' and o.colli and o._original_secondary_box
        if box and box[1]>0 then
            for _,shot in ObjList(GROUP.PLAYER_BULLET) do
                if not IsValid(o) or o.status=='kill' or o.status=='del' then break end
                if shot.colli and shot.status~='kill' and shot.status~='del' and shot.dmg
                    and math.abs(shot.x-o.x)<=box[1]/2+shot.a
                    and math.abs(shot.y-o.y)<=box[2]/2+shot.b then
                    local amount=shot.dmg
                    local kind=player and player.original_shot_type
                    shot.dmg=amount/((kind==3 or kind==11) and 6.5 or 1.7)
                    o.class.colli(o,shot)
                    if IsValid(shot) then shot.dmg=amount end
                end
            end
        end
    end
end
function C.finish()
    for i=1,count do
        local s=saved[i]
        local o=s[1]
        if IsValid(o) then
            o.rot,o.rect,o.a,o.b=s[2],s[3],s[4],s[5]
            -- 只恢复本模块临时关闭的敌机；不能复活碰撞阶段刚进入消散的弹。
            if s[8] and o.status~='kill' and o.status~='del' then SetAttr(o,'colli',s[7]) end
            o._original_collision_rot=nil
        end
        s[1]=nil
    end
    count=0
end
return C
