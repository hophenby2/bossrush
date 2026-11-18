-- 第一面四条 0x42–0x44：0x0c0a6f00 构造，0x0c0a7520 更新，0x0c0a56c0 发弹。
-- 三种外形共用 1536 HP、60 点轨迹和十组附肢历史；地面本体不与自机发生撞机。
-- 差异 1：全局随机序列及对象池调度未接入，击破使用 LuaSTG 录像随机数。
-- 差异 2：全局画面偏移、受伤色、投影混色及击破音效尚未完整移植。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/groundbug_data.lua')
local death=dofile('mod/GAME/th46/groundbug_death.lua')
local poses={
    [0x42]=dofile('mod/GAME/th46/groundbug_pose42.lua'),
    [0x43]=dofile('mod/GAME/th46/groundbug_pose43.lua'),
    [0x44]=dofile('mod/GAME/th46/groundbug_pose44.lua'),
}
local object,unit,vector,heading=object,direction.unit,direction.vector,direction.heading
local floor,min,max=math.floor,math.min,math.max
local texture='th46_groundbug'
local spawns=data.spawns
local function turn(a,b)return(a+max(-2,min(2,(b-a+256)%512-256)))%512 end
local function program(o)
    if not o.programActive then return end
    o.programClock=o.programClock-1
    if o.programClock>=0 then return end
    while true do
        local row=o.program[o.programIndex]
        if not row then return end
        o.programIndex=o.programIndex+1
        if row[1]==4 then o.raw[16],o.hitEnabled=row[3],true
        elseif row[1]==5 then o.hitEnabled=false
        elseif row[1]==3 or row[1]==2 then
            o.raw[20],o.programClock=row[2],row[3]
            if row[1]==2 then o.raw[16],o.raw[20]=0,row[2]+512 end
            if row[3]==0 then o.programActive=false end
            return
        else error('地面敌机未移植的移动指令 '..row[1]) end
    end
end
local function place(o)
    o.boardX,o.boardY=o.raw[4],o.raw[8]
    o.x,o.y=o.boardX/unit-120,o.boardY/unit-160
    o.box.x,o.box.y=o.x,o.y
    o.box.colli=o.hitEnabled and not o.closed and o.hp>0
end
local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.box.colli=false;object.RawDel(o.box)
    o.run.roadGroundbugs[o]=nil;object.RawDel(o)
end
local function stripSamples(run)
    if not run.data then return end
    local ids,partials,removed={},{},{}
    for _,row in ipairs(data.sampled.sprites) do ids[row[1]]=true end
    for _,row in ipairs(data.sampled.partialSprites or {}) do partials[row[1]]=true end
    for _,entries in pairs(run.data.enemies) do
        for i=#entries,1,-1 do
            local matched,other=false,false
            for _,frame in ipairs(entries[i].frames) do
                for at=6,#frame,6 do
                    local a,b=frame:byte(at,at+1);local id=a*256+b
                    if ids[id] then matched=true elseif not partials[id] then other=true end
                end
            end
            if matched and not other then removed[entries[i].id]=true;table.remove(entries,i) end
        end
    end
    for _,shots in pairs(run.data.shots) do
        for i=#shots,1,-1 do if removed[shots[i].owner] then table.remove(shots,i) end end
    end
    local tiles={}
    for _,row in ipairs(data.sampled.tiles) do tiles[row[1]]=true end
    for _,background in pairs(run.data.backgrounds or {}) do
        if background[4] then
            local kept={}
            for at=1,#background[4],6 do
                local a,b=background[4]:byte(at,at+1)
                if not tiles[a*256+b] then kept[#kept+1]=background[4]:sub(at,at+5) end
            end
            background[4]=table.concat(kept)
        end
    end
end
local function damage(box,amount,flags)
    local o=box.host
    if o.hp<=0 or not o.hitEnabled then return end
    o.hitPending=true;o.hp=o.hp-amount;o.raw[28],box.hp=o.hp,o.hp
    if o.hp<=0 then box.colli=false;o.defeat(o,flags or 0) end
end
local Hitbox=Class(object,{
    init=function(o,host)
        o.run,o.host,o.hp=host.run,host,host.hp
        -- 0x0c0a6f50 的形状 flags=0；飞行敌机为 1。GROUP.NONTJT 保留自弹判定并跳过撞机。
        o.group,o.layer,o.bound,o.colli=GROUP.NONTJT,LAYER.ENEMY,false,true
        o.a,o.b,o.rect,o.hide,o.damage=33,30,true,true,damage
    end,
    colli=function(o,shot)
        if not o.colli or not shot.colli or not shot.dmg then return end
        damage(o,shot.dmg,shot.damageFlags);shot.colli=false;object.RawDel(shot)
    end,
})
local Enemy=Class(object,{
    init=function(o,run,spawn,p,defeat)
        o.run,o.player,o.defeat=run,p,defeat
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY,false,false
        o.birthFrame,o.zone,o.hp,o.closed,o.visible=run.roadFrame,spawn[1],1536,false,false
        o.program,o.programIndex,o.programClock,o.programActive=data.programs[spawn[4]],1,0,true
        o.hitEnabled,o.hitPending,o.raw=true,false,{}
        local m=o.raw
        for at=0,0x544,4 do m[at]=0 end
        m[4],m[8],m[12]=(spawn[2]-run.roadCamera)*unit,spawn[3]*unit,spawn[5]
        m[28],m[32],m[48],m[68],m[80],m[104],m[112],m[0x544]=1536,1536,2,7,3,1,2,7
        for i,phase in ipairs(data.phases) do m[0x94+(i-1)*0x48]=phase end
        for i=0,59 do m[0x364+i*8],m[0x368+i*8]=m[4],m[8] end
        program(o);o.box=New(Hitbox,o);run.roadGroundbugs[o]=true;place(o)
    end,
    render=function(o)
        if o.closed or o.hp<=0 or not o.visible then return end
        poses[o.raw[12]](o.raw,function(sprite,x,y,flip)
            local image=texture..'_'..(sprite==0x3db1 and 104 or sprite-0x2899)
            local c=o.raw[36]
            SetImageState(image,'',(sprite==0x28d4 or sprite==0x2900 or sprite==0x3db1)and 128 or 255,
                min(255,floor(c/65536)*2),min(255,floor(c/256)%256*2),min(255,c%256*2))
            Render(image,floor(x/unit)-120,floor(y/unit)-160,0,flip==1 and -1 or 1,1)
        end)
    end,
})
return function(emit,defeat)
    defeat=defeat or death.defeat
    local function aim(o,dy)
        local p=o.player
        return p.respawn==0 and heading(o.boardX,o.boardY+dy*unit,p.pilotPosition.x,p.pilotPosition.y) or 256
    end
    local function firing(o)
        local m=o.raw
        if m[8]<=192*unit or m[8]>=320*unit then return end
        local mode=m[112]
        if mode==0 then m[124],m[116],m[128],m[140],m[112]=0,2,10,32,1
        elseif mode==1 then
            if m[140]>0 then m[132]=aim(o,16);m[140]=m[140]-1;return end
            m[124]=m[124]-1
            if m[124]<0 then
                m[124]=m[128]
                for i=-2,2 do emit(o.run,m[4],m[8]+16*unit,m[132]+i*30,10,0x13) end
                m[116]=m[116]-1;if m[116]<=0 then m[112]=3 end
            end
        elseif mode==2 or mode==3 then
            m[124],m[120],m[116],m[128],m[140],m[144],m[112]=0,4,4,6,mode==2 and 32 or 72,4,4
        elseif mode==4 then
            if m[140]>0 then
                if m[108]~=0 then
                    m[100]=m[100]-1
                    if m[100]<0 then m[100],m[108]=m[104],max(0,m[108]-1) end
                end
                m[140]=m[140]-1;return
            end
            if m[108]~=7 then
                m[100]=m[100]-1
                if m[100]<0 then m[100],m[108]=m[104],min(7,m[108]+1) end
                return
            end
            m[124]=m[124]-1
            if m[124]<0 then
                m[124]=m[128];if m[116]==m[120] then m[132]=aim(o,16) end
                for i=-1,1 do emit(o.run,m[4],m[8]+16*unit,m[132]+i*40,m[144],0x12) end
                m[116]=m[116]-1;if m[116]<=0 then m[112]=0 end
            end
        end
    end
    local function step(o)
        if o.hp<=0 or o.expired then remove(o);return end
        local m=o.raw
        o.visible=true;m[36]=0x808080
        if o.hitPending then
            if m[40]%2==1 then m[36]=0xc0c000 end;m[40]=m[40]+1
        elseif o.hp<384 and floor((o.run.roadFrame+1207)/2)%8==0 then m[36]=0xff1010 end
        o.hitPending=false;program(o)
        local vx,vy=vector(m[16],m[20]);local dx=o.run.roadCameraDelta
        m[4],m[8]=m[4]+vx+dx,m[8]+vy-o.run.roadGroundDelta
        for i=59,1,-1 do m[0x364+i*8],m[0x368+i*8]=m[0x364+(i-1)*8]+dx,m[0x368+(i-1)*8] end
        m[0x364],m[0x368]=m[4],m[8]
        for base=0x94,0x31c,0x48 do
            for j=5,1,-1 do for k=0,8,4 do m[base+j*12+k]=m[base+(j-1)*12+k] end end
        end
        for _,row in ipairs({{0x94,16},{0x1fc,17},{0x244,17},{0x28c,17},{0x2d4,0}}) do
            local at=row[1];m[at]=(m[at]+4)%512
            local _,y=vector(row[2],m[at]);m[at+8]=m[at+8]+y
        end
        if m[16]~=0 then
            for _,at in ipairs({0xdc,0x124,0x16c,0x1b4}) do
                m[at]=(m[at]-m[0x544])%512
                local _,y=vector(320,m[at]+224);m[at+8]=y
            end
            m[92],m[96]=floor((512-m[0x16c])%512/16),floor((512-m[0x1b4])%512/16)
            m[84],m[88]=floor((512-m[0xdc])%512/16),floor((512-m[0x124])%512/16)
        else
            m[76]=m[76]-1
            if m[76]<0 then
                m[76]=m[80]
                if m[84]~=0 then m[84]=m[84]>16 and (m[84]+1)%32 or max(0,m[84]-1) end
                for _,at in ipairs({88,92,96}) do m[at]=max(0,m[at]-1) end
                for _,at in ipairs({0xdc,0x124,0x16c,0x1b4}) do if m[at+8]>-2 then m[at+8]=max(-2,m[at+8]-unit) end end
            end
        end
        local x,y=vector(2560,m[24]);m[0x320],m[0x324]=x,y+160*unit
        place(o)
        local px=m[4]+o.run.roadCamera*unit
        local inside=px>-72*unit and px<312*unit and m[8]>-48*unit and m[8]<368*unit
        if inside then m[44]=1 elseif m[44]~=0 then o.expired=true;o.box.colli=false;return end
        if m[16]~=0 then
            m[64]=m[64]-1
            if m[64]<0 then m[64],m[72]=m[68],(m[72]+1)%16 end
        end
        m[24]=turn(m[24],max(144,min(368,aim(o,0))));firing(o)
    end
    return {
        open=function(run)
            run.roadGroundbugs,run.nextGroundbug={},1
            death.open(run)
            stripSamples(run)
            if CheckRes('img',texture..'_0') then return end
            LoadTexture(texture,'Resources/th46/stage1/groundbug.png');SetTextureSamplerState(texture,'point+clamp')
            for i=0,125 do LoadImage(texture..'_'..i,texture,i%8*128,floor(i/8)*128,128,128) end
        end,
        step=function(run,frame,p)
            for o in pairs(run.roadGroundbugs) do step(o) end
            local position=floor(run.groundScroll.control/(8*unit))
            local spawn=spawns[run.nextGroundbug]
            while spawn and spawn[1]<=position do
                New(Enemy,run,spawn,p,defeat);run.nextGroundbug=run.nextGroundbug+1
                spawn=spawns[run.nextGroundbug]
            end
        end,
        close=function(run)
            for o in pairs(run.roadGroundbugs or {}) do remove(o) end
            death.close(run);run.roadGroundbugs=nil
        end,
    }
end
