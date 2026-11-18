-- 第一面三条 0x32：0x0c0aa910 构造，0x0c0aba90 更新，0x0c0a9120 执行 Original 发弹。
-- 3584 HP 的两块判定共用本体，十八组振动各留六份历史，轨迹保留 108 个定点位置。
-- 差异 1：全局对象池占用及原版随机序列尚未接入，随机数走 LuaSTG 录像序列。
-- 差异 2：受伤色、投影和尾气混色采用 LuaSTG 近似，击破音效尚待移植。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/longfly_data.lua')
local pose=dofile('mod/GAME/th46/longfly_pose.lua')
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local death=dofile('mod/GAME/th46/longfly_death.lua')
local object,unit,vector,heading=object,direction.unit,direction.vector,direction.heading
local floor,trunc,abs,min,max=math.floor,math.modf,math.abs,math.min,math.max
local texture='th46_longfly'
local spawns={{3934,268,342,1,428},{4638,-14,341,2,472},{4814,257,344,1,483}}
local shapes={{64,64,32,20,0},{12,12,8,8,-20}}
local waves={
    {0xfc,50,0},{0x144,49,4},{0x18c,49,4},{0x1d4,49,4},{0x21c,52,0},
    {0x264,50,3},{0x2ac,50,3},{0x2f4,50,3},{0x33c,50,3},
    {0x384,53,0},{0x3cc,53,0},{0x414,53,0},{0x45c,50,0},
    {0x4a4,51,3},{0x4ec,51,3},{0x534,51,3},{0x57c,51,3},
}

local function turn(a,b,v) return (a+max(-v,min(v,(b-a+256)%512-256)))%512 end
local function program(o)
    o.programClock=o.programClock-1
    if o.programClock>=0 then return end
    while true do
        local row=o.program[o.programIndex]
        if not row then return end
        o.programIndex=o.programIndex+1
        if row[1]==4 then o.raw[20]=row[3]
        elseif row[1]==3 then o.raw[24],o.programClock=row[2],row[3];return
        elseif row[1]==5 then o.hitEnabled=false
        else error('0x32 未移植的移动指令 '..row[1]) end
    end
end
local function place(o)
    o.boardX,o.boardY=o.raw[4],o.raw[8]
    o.x,o.y=o.boardX/unit-120,o.boardY/unit-160
    o.angle=o.raw[24]
    for _,box in ipairs(o.boxes) do
        local s=box.shape
        box.x,box.y=o.x,o.y+s[5]+(s[3]-s[4])/2
    end
end
local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    exhaust.detach(o)
    for _,box in ipairs(o.boxes) do box.colli=false;object.RawDel(box) end
    o.run.roadLongflies[o]=nil;object.RawDel(o)
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
    o.hitPending=true
    if o.raw[0xec]>0 then return end
    o.hp=o.hp-amount;o.raw[28]=o.hp
    for _,part in ipairs(o.boxes) do part.hp=o.hp end
    if o.hp<=0 then
        for _,part in ipairs(o.boxes) do part.colli=false end
        o.defeat(o,flags or 0)
    end
end
local Hitbox=Class(object,{
    init=function(o,host,shape)
        o.run,o.host,o.shape,o.hp,o.serial=host.run,host,shape,host.hp,host.run.serial
        o.group,o.layer,o.bound,o.colli=GROUP.ENEMY,LAYER.ENEMY,false,true
        o.a,o.b,o.rect=shape[1]+1,(shape[3]+shape[4])/2+2,true
        o.hide,o.damage=true,damage
        o.hitPilot=function(box,p)
            local x=floor(p.pilotPosition.x/unit)-floor(host.boardX/unit)
            local y=floor(p.pilotPosition.y/unit)-floor(host.boardY/unit)-shape[5]
            return abs(x)<=shape[1]+2 and y>=-shape[4]-2 and y<=shape[3]+2
        end
    end,
    frame=function(o)
        if o.serial==o.run.serial or not o.colli then return end
        o.serial=o.run.serial
        local p=o.host.player
        if o.run.roadFrame%2==0 and p.respawn==0 and p.run==o.run and o.hitPilot(o,p) then damage(o,1,1) end
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
        o.birthFrame,o.zone,o.hp,o.closed,o.visible=run.roadFrame,spawn[5],3584,false,false
        o.program,o.programIndex,o.programClock=data.programs[spawn[4]],1,0
        o.hitEnabled,o.hitPending,o.boxes,o.raw=true,false,{},{}
        local m=o.raw
        for at=0,0x968,4 do m[at]=0 end
        m[4],m[8]=(spawn[2]-run.roadCamera)*unit,spawn[3]*unit
        m[28],m[32],m[44],m[48],m[56],m[64]=3584,3584,64,16,5,2
        m[80],m[84],m[92],m[100],m[112]=96,64,6,14,spawn[2]>119 and 1 or 0
        m[0xc8],m[0xd4],m[0xe8],m[0xec]=2,3,2,48
        for i,phase in ipairs(data.phases) do m[0xfc+(i-1)*0x48]=phase end
        for i=0,107 do m[0x60c+i*8],m[0x610+i*8]=m[4],m[8] end
        program(o)
        for _,shape in ipairs(shapes) do o.boxes[#o.boxes+1]=New(Hitbox,o,shape) end
        run.roadLongflies[o]=true;place(o)
        exhaust.attach(o,1);exhaust.step(o)
    end,
    render=function(o)
        if o.closed or not o.visible then return end
        pose(o.raw,function(sprite,x,y,flip)
            local image=texture..'_'..(sprite-0x2845)
            if sprite==0x2898 then SetImageState(image,'',128,255,255,255)
            else
                local c=o.raw[0xdc]
                SetImageState(image,'',255,min(255,floor(c/65536)*2),min(255,floor(c/256)%256*2),min(255,c%256*2))
            end
            Render(image,floor(x/unit)-120,floor(y/unit)-160,0,flip==1 and -1 or 1,1)
        end)
    end,
})

return function(emit,defeat)
    defeat=defeat or death.defeat
    local function aim(o,dx,dy)
        local p=o.player
        return p.respawn==0 and heading(o.boardX+dx*unit,o.boardY+dy*unit,p.pilotPosition.x,p.pilotPosition.y) or 256
    end
    local function firing(o)
        local m=o.raw
        if m[8]<=112*unit then return end
        local shoot=false
        if m[60]==0 then
            m[44]=m[44]-1
            if m[44]<0 then m[44],m[60],m[68]=m[48],m[64],4 end
        else
            m[52]=m[52]-1
            if m[52]<0 then m[52]=m[56];shoot=true end
        end
        if shoot then
            if m[60]==m[64] then m[72]=aim(o,0,-24) end
            emit(o.run,m[4],m[8]-24*unit,aim(o,0,-24),m[68],0x13)
            m[60]=m[60]-1
            if m[60]<=0 then m[40]=1 end
        end
        if m[116]>47 then m[116]=max(48,m[116]-2) end
        if m[96]~=0 then
            m[88]=m[88]-1
            if m[88]>=0 then return end
            m[88],m[104],m[108]=m[92],aim(o,-48,-16),aim(o,48,-16)
            emit(o.run,m[4]-48*unit,m[8]-16*unit,m[104]+m[124]+m[116],4,0x12)
            emit(o.run,m[4]+48*unit,m[8]-16*unit,m[108]+m[124]-m[116],4,0x12)
            m[120],m[96]=m[120]+2,m[96]-1
        else
            m[80]=m[80]-1
            if m[80]<0 then m[80],m[96],m[112],m[124],m[116],m[120]=m[84],m[100],m[112]+1,0,112,2 end
        end
    end
    local function step(o)
        if o.hp<=0 then remove(o);return end
        local m=o.raw
        o.visible=true;m[0xdc]=0x808080
        if o.hitPending then
            if m[0xe0]%2==1 then m[0xdc]=0xc0c000 end
            m[0xe0]=m[0xe0]+1
        elseif o.hp<floor(m[32]/4) and floor((o.run.roadFrame+1207)/2)%8==0 then m[0xdc]=0xff1010 end
        o.hitPending=false;program(o)
        local vx,vy=vector(m[20],m[24]);local dx=o.run.roadCameraDelta
        m[4],m[8]=m[4]+vx+dx,m[8]+vy
        for i=107,1,-1 do m[0x60c+i*8],m[0x610+i*8]=m[0x60c+(i-1)*8]+dx,m[0x610+(i-1)*8] end
        m[0x60c],m[0x610]=m[4],m[8]
        for base=0xfc,0x5c4,0x48 do
            for j=5,1,-1 do for k=0,8,4 do m[base+j*12+k]=m[base+(j-1)*12+k] end end
        end
        for _,row in ipairs(waves) do
            local at=row[1];m[at]=(m[at]+8)%512
            local x,y=vector(row[2],m[at]);m[at+8]=m[at+8]+y
            if row[3]~=0 then m[at+4]=m[at+4]+trunc(x/row[3]) end
        end
        local x,y=vector(1280,m[36]);m[0x5c8],m[0x5cc]=x,y+80*unit
        place(o)
        local px=m[4]+o.run.roadCamera*unit
        local inside=px>-104*unit and px<344*unit and m[8]>-64*unit and m[8]<384*unit
        if inside then m[0xe4]=1 elseif m[0xe4]~=0 then remove(o);return end
        m[12],m[16]=m[4],m[8]
        m[36]=turn(m[36],max(192,min(320,aim(o,0,0))),2)
        m[0xc4]=m[0xc4]-1
        if m[0xc4]<0 then m[0xc4],m[0xcc]=m[0xc8],(m[0xcc]+1)%22 end
        m[0xd0]=m[0xd0]-1
        if m[0xd0]<0 then m[0xd0],m[0xd8]=m[0xd4],(m[0xd8]+1)%14 end
        m[0xec]=max(0,m[0xec]-1)
        exhaust.step(o);firing(o)
    end
    return {
        open=function(run)
            run.roadLongflies,run.nextLongfly={},1
            death.open(run)
            stripSamples(run);exhaust.open(run)
            if CheckRes('img',texture..'_0') then return end
            LoadTexture(texture,'Resources/th46/stage1/longfly.png');SetTextureSamplerState(texture,'point+clamp')
            for i=0,83 do LoadImage(texture..'_'..i,texture,i%8*128,floor(i/8)*128,128,128) end
        end,
        step=function(run,frame,p)
            for o in pairs(run.roadLongflies) do step(o) end
            local spawn=spawns[run.nextLongfly]
            if spawn and spawn[1]==frame then New(Enemy,run,spawn,p,defeat);run.nextLongfly=run.nextLongfly+1 end
        end,
        close=function(run)
            for o in pairs(run.roadLongflies or {}) do remove(o) end
            death.close(run)
            run.roadLongflies=nil
        end,
    }
end
