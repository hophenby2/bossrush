-- 关底换段、最终击破的离体关节与粒子调度；坐标取本步姿态，不读取录像轨迹。
-- c1be6f0/c1be960 共用四分之一模板，c1bebd0 改为二分之一；不能按外观合并比例。
local data=dofile('mod/GAME/th46/boss5_tasks_data.lua')
local vector=dofile('mod/GAME/th46/direction.lua').vector
local trunc,floor=math.modf,math.floor
local unit=65536
return function(api)
    local register,allocate,switch,remove=api.register,api.allocate,api.switch,api.remove
    local invoke,spawn,tick=api.invoke,api.spawn,api.tick
    local random=api.random
    local function particle(o,kind,x,y,d)return invoke(o,'particle',kind,x,y,d)end
    local function set(o,p,method,...)invoke(o,'particle_set',method,p,...)end
    local function fragments(o,x,y,d,angle)
        for _,kind in ipairs({0,24,24})do
            local p=invoke(o,'fragment',kind,x,y,d)
            invoke(o,'fragment_angle',p,angle+random(o,64)-32)
        end
    end
    local function provenance(o,v,b,p)
        local a=0x2694+v[56]*20
        if b[a]==1 then
            local value=invoke(o,'root_field12')
            invoke(o,'particle_source',p,value,b[a+4],b[a+8],b[a+12],b[a+16])
        end
    end
    local initial={
        left_break_init={0xc1bd0a0,0x20b8,-1,'limb_break',10,true},
        right_break_init={0xc1bd130,0x210c,1,'limb_break',10,true},
        left_lower_break_init={0xc1bd1c0,0x1f68,-1,'lower_break',10,true},
        right_lower_break_init={0xc1bd250,0x1fbc,1,'lower_break',10,true},
        left_final_break_init={0xc1bd2e0,0x2010,-1,'final_limb_break',10},
        right_final_break_init={0xc1bd370,0x2064,1,'final_limb_break',10},
        body_break_init={0xc1bd400,0x1dc4,0,'body_break',9,true},
        lower_body_break_init={0xc1bd4a0,0x22b0,0,'lower_body_break',9,true},
        core_break_init={0xc1bd540,0x21b4,nil,'core_break',7},
    }
    for name,r in pairs(initial)do
        register(name,r[1],function(o,v,b)
            allocate(o,60);v[0],v[4]=0,r[2]
            v[8]=assert(o.host.renderDepth)+r[5]
            if r[3]then v[28]=r[3]end
            if r[5]~=10 then v[12]=b[32]end
            if r[6]then v[56]=o.config[1]end
            invoke(o,'service',r[5]==10 and 0xc10ef10 or 0xc10ee90)
            switch(o,r[4])
        end)
    end
    local function begin(v,b,core,keepState)
        local a=v[4]
        b[a+64],b[a+72]=1,1
        if not keepState then b[a+68]=core and 6 or 1 end
        v[16],v[20],v[24],v[0]=0,2,0,v[0]+1
    end
    local function limbs(o,v,b,half,final)
        if v[0]==0 then
            begin(v,b,false,final)
            b[36]=48;b[40]=208*v[28]+256+random(o,16)-5
        elseif v[0]~=1 then return end
        if tick(v,16)>=0 then return end
        v[16]=v[20]
        local row=assert(data.limbs[v[24]+1])
        local divisor=half and 2 or 4
        local x=b[v[4]+12]+(trunc(row[3]/divisor)+24*unit)*v[28]
        local y=b[v[4]+16]+trunc(row[4]/divisor)
        local d=v[8]+1
        local p=particle(o,row[1],x,y,d)
        local angle=256-40*v[28]+random(o,16)-8
        local speed=72+random(o,16)
        set(o,p,0xc096830,speed,angle);set(o,p,0xc096930,row[2]%65536)
        set(o,p,0xc096890,b[32])
        if not final then provenance(o,v,b,p)end
        fragments(o,x,y,d,angle)
        v[24]=v[24]+1
        if v[24]>22 then v[24]=0;remove(o)end
    end
    register('limb_break',0xc1be6f0,function(o,v,b)limbs(o,v,b,false,false)end)
    register('lower_break',0xc1be960,function(o,v,b)limbs(o,v,b,false,false)end)
    register('final_limb_break',0xc1bebd0,function(o,v,b)limbs(o,v,b,true,true)end)
    local function body(o,v,b,lower)
        local d=v[8]
        if v[0]==0 then
            begin(v,b)
            for _,a in ipairs({0x2250,0x22a4,0x1e60})do b[a]=1 end
        elseif v[0]~=1 then return end
        if tick(v,16)>=0 then return end
        v[16]=v[20]
        local row=assert(data.body[v[24]+1])
        local x=b[v[4]+12]+trunc(row[3]/4)
        local y=b[v[4]+16]+trunc(row[4]/4)+64*unit
        local p=particle(o,row[1],x,y,d)
        local angle=-96*v[28]+random(o,16)+248
        local speed=72+random(o,16)
        set(o,p,0xc096830,speed,angle);set(o,p,0xc096930,row[2]%65536)
        provenance(o,v,b,p)
        p=particle(o,row[1],x,y,d+1);set(o,p,0xc096870,2)
        speed=144+random(o,16)*2
        local other=angle+random(o,32)-16
        set(o,p,0xc096830,speed,other);set(o,p,0xc0968d0,112);set(o,p,0xc096930,4)
        fragments(o,x,y,d+1,angle)
        v[24]=v[24]+1
        if v[24]>11 then
            v[24]=0
            if lower then spawn(o,0xc1bcd70)end
            remove(o)
        end
    end
    register('body_break',0xc1bedc0,function(o,v,b)body(o,v,b,false)end)
    register('lower_body_break',0xc1bf060,function(o,v,b)body(o,v,b,true)end)
    register('core_break',0xc1bf320,function(o,v,b)
        if v[0]==0 then begin(v,b,true)elseif v[0]~=1 then return end
        if tick(v,16)>=0 then return end
        v[16]=v[20]
        local row=assert(data.core[v[24]+1])
        local x,y=b[v[4]+12]+row[3],b[v[4]+16]+row[4]
        local p=particle(o,row[1],x,y,v[8])
        local angle=240+random(o,32)
        set(o,p,0xc096830,72+random(o,16),angle);set(o,p,0xc096930,row[2]%65536)
        p=particle(o,row[1],x,y,v[8]+1);set(o,p,0xc096870,2)
        local speed=144+random(o,16)*2
        local other=angle+random(o,32)-16
        set(o,p,0xc096830,speed,other);set(o,p,0xc0968d0,112);set(o,p,0xc096930,10)
        fragments(o,x,y,v[8]+1,angle)
        v[24]=v[24]+1
        if v[24]>5 then v[24]=0;remove(o)end
    end)
    register('morph_init',0xc1bcd70,function(o,v,b)
        allocate(o,16);b[0x1a30]=1
        v[4],v[8],v[12]=16,1,0
        b[0x21f8],b[0x21b4]=1,0
        switch(o,'morph')
    end)
    register('morph',0xc1bcc40,function(o,v,b)
        if b[0x1a30]~=1 then remove(o);return end
        if tick(v,4)>0 then return end
        v[4]=v[8]
        local n=b[0x1a20]
        if n<=128 then n=n+3 end
        n=n+4;b[0x1a20]=n
        if v[12]==0 then
            if b[0x21b4]<=10 then
                b[0x21b4]=b[0x21b4]+1
                if b[0x21b4]>10 then b[0x21b4]=11;spawn(o,0xc1bc550)end
            end
            if n>119 then v[12],v[4],v[8]=1,16,2 end
        elseif v[12]==1 then
            b[0x21f8]=3;spawn(o,0xc1bc900);v[12]=2
        end
        if n>191 then b[0x1a20],b[0x1a30]=192,0;remove(o)end
    end)
    local function dust(o,x,y,d)
        local color=random(o,15)
        local p=invoke(o,'dust',2,x,y,d,color)
        local speed=random(o,32)+4
        invoke(o,'dust_motion',p,speed,(272-random(o,31))%512)
    end
    register('left_scale_init',0xc1bcb80,function(o,v)
        allocate(o,20);v[4],v[8],v[12],v[16]=0,0,1,-1;switch(o,'scale')
    end)
    register('right_scale_init',0xc1bcbe0,function(o,v)
        allocate(o,20);v[4],v[8],v[12],v[16]=24,0,1,1;switch(o,'scale')
    end)
    register('scale',0xc1be330,function(o,v,b)
        if tick(v,4)>0 then return end
        v[4]=v[8]
        local _,dy=vector(v[12],256);v[12]=v[12]+3
        if assert(o.host.controlCounter)%4==0 and(v[16]==-1 or v[16]==1)then
            local a=v[16]==-1 and 0x275c or 0x2764
            dust(o,b[a],b[a+4],88)
        end
        local a=v[16]==-1 and 0xfc or v[16]==1 and 0x100
        if a then b[a]=b[a]+dy;if b[a]<=0 then b[a]=0;remove(o)end end
    end)
end
