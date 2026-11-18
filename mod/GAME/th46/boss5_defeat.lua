-- 第五面 Original 最终击破：c1b9050 / c1b7470 的十个状态。
-- 固定模板独立于流程；所有等待、随机调用、零件及粒子参数均按原指令顺序提交。
-- 粒子、碎片、指令队列和绘图工厂仍为显式接口，缺少实现时不伪造完成。
local data=dofile('mod/GAME/th46/boss5_defeat_data.lua')
local bit=require('bit')
local floor,min,max,trunc=math.floor,math.min,math.max,math.modf
local unit=65536
return function(api)
    local h,source=api.handlers,api.source
    local invoke,spawn,allocate,switch=api.invoke,api.spawn,api.allocate,api.switch
    source.defeat_init,source.defeat=0xc1b9050,0xc1b7470
    local meta,debris=0x26bc,0xc31cb64
    local function random(o,n)
        local r=invoke(o,'random',n)
        assert(type(r)=='number'and r>=0 and r<=n and floor(r)==r,'第五面击破随机数越界')
        return r
    end
    local function particle(o,kind,x,y,depth)
        local p=invoke(o,'particle',kind,x,y,depth)
        assert(p~=nil,'第五面粒子工厂必须返回对象或失败的 0');return p
    end
    local function set(o,p,method,...)invoke(o,'particle_set',method,p,...)end
    local function fragments(o,kind,x,y,depth,angle)
        local p=invoke(o,'fragment',kind,x,y,depth)
        assert(p~=nil,'第五面碎片工厂必须返回对象或失败的 0')
        invoke(o,'fragment_angle',p,angle)
    end
    local function parts(o,b,tableId,count,x,y,depth)
        invoke(o,'parts','scatter',meta,tableId,count,x,y,depth,b[32])
    end
    local function batch(o,b,tableId,count,x,y,depth)
        invoke(o,'parts','batch',-1,tableId,count,x,y,depth,b[32])
    end
    local function burst(o,kind,x,y,depth,angle,flag)
        invoke(o,'burst',kind,x,y,depth,angle,flag)
    end
    local function service(o,entry,...)invoke(o,'service',entry,...)end
    local function rgb(n)return bit.bor(bit.lshift(n,16),bit.lshift(n,8),n)end
    local function small(o,v,b,depth)
        local x,y=b[8],b[12]-50*unit
        local offset=assert(data.offsets[v[12]+1])
        local row=assert(data.small[v[16]+1])
        local px,py=x+trunc(offset[1]/2),y+offset[2]+40*unit
        local angle=random(o,511)
        local p=particle(o,row[1],px,py,depth+1)
        set(o,p,0xc096930,row[2]%65536)
        set(o,p,0xc096830,16+random(o,16),angle)
        set(o,p,0xc096890,0)
        if random(o,10)<=4 then set(o,p,0xc0968b0,1)end
        p=particle(o,10,px,py,depth)
        set(o,p,0xc096930,row[2]%65536)
        set(o,p,0xc096830,16+random(o,16),angle)
        set(o,p,0xc096890,0)
        px=x+(random(o,32)-16)*unit
        py=y+random(o,32)*unit+64*unit
        p=particle(o,11,px,py,depth+2)
        set(o,p,0xc096930,4);set(o,p,0xc096890,0)
        set(o,p,0xc096830,28,angle);set(o,p,0xc096870,3);set(o,p,0xc0968d0,80)
        v[12],v[16]=(v[12]+1)%8,(v[16]+1)%8
        for _=1,row[9]do fragments(o,row[8],x+row[3],y+row[4],depth+1,angle)end
    end
    local function extras(o,b,depth,state)
        local x,y=b[8]+b[0x128],b[12]+b[0x12c]
        local px=x+(random(o,96)-48)*unit
        local py=y-random(o,state==20 and 32 or 24)*unit-32*unit
        burst(o,12,px,py,depth+2,0,0)
        if state==20 then return end
        local delta=random(o,32)-16
        px=x+delta*unit
        py=y+random(o,(state==34 or state==35)and 48 or 32)*unit+16*unit
        burst(o,13,px,py,depth+5,delta%512,0)
    end
    local function explosion(o,v,b,depth)
        service(o,0xc10efd0)
        invoke(o,'command',6,217,125,254,2)
        local d=depth+4
        for i,row in ipairs(data.final)do
            local p=particle(o,row[1],b[8]+row[3],b[12]+row[4],d)
            set(o,p,0xc096930,row[2]%65536)
            set(o,p,0xc096830,trunc(3*row[5]/4)+40,row[6]+480)
            set(o,p,0xc096870,row[7]);set(o,p,0xc0968b0,row[10]);set(o,p,0xc0968d0,112)
            if(i-1)%8==0 then
                p=particle(o,11,b[8],b[12]-50*unit,d+1)
                set(o,p,0xc096930,4);set(o,p,0xc096830,48,random(o,511))
                set(o,p,0xc096870,0);set(o,p,0xc0968d0,160)
            end
            for _=1,row[9]do
                local f=invoke(o,'fragment',row[8],b[8]+row[3],b[12]+row[4],d+1)
                assert(f~=nil,'第五面碎片分配结果缺失')
                invoke(o,'fragment_angle',f,480+random(o,63))
            end
        end
        batch(o,b,0xc31d728,12,b[8],b[12],d+1)
        b[36],b[40]=48,(random(o,8)-4)%512
        service(o,0xc09c4c0,4)
        invoke(o,'view_flag',0,0)
        b[0x2348]=8
        invoke(o,'parts_control',0xc1bbfe0)
        local x,y=b[8]+b[0x128],b[12]+b[0x12c]
        batch(o,b,0xc31dc38,18,x,y,d+1)
        batch(o,b,0xc31da88,12,x,y,d+2)
        service(o,0xc0689e0,1);service(o,0xc068a00,1)
        v[0],v[24],b[56]=34,18,208
    end
    h.defeat_init=function(o,v,b)
        allocate(o,60);v[0],v[56]=0,0
        assert(b[28]==0,'第五面最终击破目前只支持 Original')
        if b[meta]==1 then
            if invoke(o,'weapon_active',0)==0 then invoke(o,'weapon_active',1)end
        end
        invoke(o,'root_field96',0)
        if b[16]>0 then b[16]=1 end
        b[20]=256
        invoke(o,'signal','boss_scene',1)
        invoke(o,'signal','stage_scroll',0)
        switch(o,'defeat')
        invoke(o,'signal','defeat',1)
    end
    h.defeat=function(o,v,b)
        local depth=assert(o.host.renderDepth)+10
        local state=v[0]
        local even=assert(o.host.controlCounter,'第五面击破缺少原版逻辑计数')%2==0
        if state==0 then
            invoke(o,'command',5,95,50,35,0)
            service(o,0xc10f9b0)
            invoke(o,'motion','ensure','retreat_init')
            parts(o,b,0xc31d698,4,b[8],b[12]-50*unit,depth+1)
            parts(o,b,0xc31c9b4,6,b[8],b[12]-50*unit,depth)
            parts(o,b,0xc31ca8c,6,b[8],b[12]-50*unit,depth)
            parts(o,b,0xc31cc60,7,b[8]+b[0x128],b[12]+b[0x12c],depth+1)
            v[24],v[28],v[32]=46+random(o,4),14+random(o,4),22+random(o,4)
            b[36],b[40]=48,(random(o,32)-16)%512
            b[0x1d12],b[0x140]=1,1
            invoke(o,'parts_control',0xc1bbf40)
            b[0x1db4]=2
            spawn(o,'task',0xc1bd020)
            invoke(o,'parts_control',0xc1bbea0)
            v[0]=1
            -- c1b7670 写状态后直接落入状态 1；三个初值都大于零，当步也要倒数。
            v[24],v[28],v[32]=v[24]-1,v[28]-1,v[32]-1
        elseif state==1 then
            for _,spec in ipairs({{24,0x21c0,0xc1bd540},{28,0x201c,0xc1bd2e0},{32,0x2070,0xc1bd370}})do
                local at=spec[1]
                if v[at]>0 then
                    v[at]=v[at]-1
                    if v[at]<=0 then
                        parts(o,b,debris,7,b[spec[2]],b[spec[2]+4],depth+2)
                        spawn(o,'task',spec[3])
                    end
                end
            end
            if v[24]+v[28]+v[32]==0 then v[24],v[0]=0,2 end
        elseif state==2 then
            v[24]=v[24]-1
            if v[24]<0 then
                v[4],v[8]=0,4
                v[12],v[16],v[20]=random(o,7),0,34
                v[0],b[48],b[52]=10,4,4
            end
        elseif state==10 then
            b[48]=b[48]-1
            if b[48]<0 then
                b[48]=b[52]
                service(o,random(o,1)==0 and 0xc10ed70 or 0xc10ee50)
            end
            v[4]=v[4]-1
            if v[4]<0 then
                v[4]=v[8];small(o,v,b,depth)
                b[0x2678]=min(255,b[0x2678]+1)
                b[0x2618]=rgb(b[0x2678]+128)
                v[20]=v[20]-1
                if v[20]<=0 then
                    v[24]=16;spawn(o,'task',0xc1bc360)
                    v[20],b[0x2678],v[0]=34,128-b[0x2678],20
                end
            end
        elseif state==20 then
            if v[24]<=0 then
                extras(o,b,depth,20)
                b[0x2678]=b[0x2678]+2
                if b[0x2678]>254 then
                    b[0x2678],v[24],v[0]=255,50,25
                    service(o,0xc0689e0,1);service(o,0xc068a00,0)
                end
            else
                if even then extras(o,b,depth,20)end
                v[24]=v[24]-1
            end
            b[0x2618]=rgb(b[0x2678])
            if v[20]~=0 then
                v[4]=v[4]-1
                if v[4]<0 then v[4]=v[8];small(o,v,b,depth);v[20]=v[20]-1 end
            end
        elseif state==25 then
            if even then extras(o,b,depth,25)end
            v[24]=v[24]-1
            if v[24]<0 then service(o,0xc0689e0,0);v[24],v[0]=0,30 end
        elseif state==30 then
            if even then extras(o,b,depth,30)end
            v[24]=v[24]-1
            if v[24]<0 then explosion(o,v,b,depth)end
        elseif state==34 or state==35 then
            if even then extras(o,b,depth,state)end
            b[56]=max(0,b[56]-2)
            v[24]=v[24]-1
            if v[24]<0 then
                if state==34 then v[0],v[24]=35,72 else v[0],v[24]=40,90 end
            end
        elseif state==40 then
            b[56]=min(255,b[56]+3)
            if v[24]==16 then service(o,0xc068d00);service(o,0xc0689e0,0)end
            v[24]=v[24]-1
            if v[24]<0 then invoke(o,'retire');return end
        end
        if b[56]~=0 then invoke(o,'overlay',b[56]%256)end
    end
end
