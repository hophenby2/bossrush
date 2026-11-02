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
    s[1],s[2],s[3],s[4],s[5],s[6]=o,o.rot,o.rect,o.a,o.b,enemy
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
        end
    end
    -- 自机弹与原作敌机的相交测试同样使用 AABB。
    for _,o in ObjList(GROUP.PLAYER_BULLET) do if o.colli then save(o) end end
end
function C.finish()
    for i=1,count do
        local s=saved[i]
        local o=s[1]
        if IsValid(o) then
            o.rot,o.rect,o.a,o.b=s[2],s[3],s[4],s[5]
            o._original_collision_rot=nil
        end
        s[1]=nil
    end
    count=0
end
return C
