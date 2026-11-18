-- 第一段四组炮台；所有私有项仍按原参数块偏移保存，未初始化的项保留池中旧值。
local unit=65536
local min,max,trunc=math.min,math.max,math.modf
local function signed32(n)return(n+2147483648)%4294967296-2147483648 end
return function(api)
    local register,allocate,switch,remove=api.register,api.allocate,api.switch,api.remove
    local invoke,tick,random,aim=api.invoke,api.tick,api.random,api.aim
    local fan,bullet,spawn=api.fan,api.bullet,api.spawn
    local function put(v,values)for a,n in pairs(values)do v[a]=n end end
    register('first_a_init',0xc1bf540,function(o,v)
        allocate(o,124)
        put(v,{[88]=96,[108]=11,[96]=28,[92]=192,[100]=0,[104]=0})
        v[68]=random(o,1)
        put(v,{[4]=128,[8]=36,[72]=19,[76]=-15,[80]=-15,[12]=5,[16]=5,[32]=10,[56]=5,
            [36]=7,[0]=16,[20]=0,[40]=12,[44]=0,[60]=16,[28]=1,[64]=-28,[84]=0})
        api.parameters.write(o.block,112,1,random(o,1))
        invoke(o,'collision',true);switch(o,'first_a')
    end)
    register('first_b_init',0xc1bf610,function(o,v)
        allocate(o,124)
        put(v,{[0]=32,[4]=7,[8]=10,[12]=10,[20]=-10,[16]=256,[32]=64,[36]=64})
        v[40]=random(o,4)+8;v[44]=v[40]
        put(v,{[48]=3,[56]=-23,[60]=-23,[24]=0,[28]=0,[64]=1,[68]=1,[72]=24,[76]=12,
            [80]=12,[84]=-35,[88]=-35})
        spawn(o,0xc1bcde0);switch(o,'first_b')
    end)
    register('first_c_init',0xc1bf6c0,function(o,v)
        allocate(o,76)
        put(v,{[0]=64,[4]=32,[8]=16,[12]=2,[16]=2,[20]=13,[24]=24,[36]=37,[52]=3,[40]=20,
            [44]=7,[48]=21})
        v[56]=random(o,1)
        put(v,{[60]=0,[68]=8,[64]=8,[72]=1});switch(o,'first_c')
    end)
    register('first_d_init',0xc1bf760,function(o,v)
        allocate(o,136)
        put(v,{[0]=32,[8]=6,[12]=59,[16]=59,[4]=112,[20]=3,[32]=46})
        v[36]=random(o,3)-20;v[40]=random(o,3)-20;v[44]=-20
        v[60]=random(o,6)+6;v[64]=random(o,6)+6
        if random(o,1)~=0 then v[60],v[64]=-v[60],-v[64]end
        local r=random(o,511);v[28]=r
        v[24]=(128+r) -- 下式照原版的按位与，不能用“随机半圈”重写。
        v[24]=require('bit').band(v[24],479+random(o,63))
        put(v,{[76]=3,[80]=3,[72]=96,[84]=0,[88]=0,[92]=0,[96]=-5,[100]=20,[112]=1,
            [116]=4,[120]=4,[124]=-7})
        v[68]=random(o,1);v[104],v[108]=5,5;v[128],v[132]=0,0
        switch(o,'first_d')
    end)
    -- 第一组同时推进主体六口扇、中央连射和六点交错狙，三个倒数互不替代。
    register('first_a',0xc1bf870,function(o,v,b)
        if tick(v,88)<0 then
            v[88]=v[96]
            local points={{b[0x26dc]+24*unit,b[0x26e0]-14*unit},
                {b[0x26e4]-24*unit,b[0x26e8]-14*unit},{b[0x26dc],b[0x26e0]},
                {b[0x26e4],b[0x26e8]},
                {b[0x26dc]-16*unit,b[0x26e0]+14*unit},
                {b[0x26e4]+16*unit,b[0x26e8]+14*unit}}
            local index=v[100]%6+1
            -- 原版两份跳转表只交换六个发射点；下列顺序来自各自的表项。
            local orders=v[68]~=0 and{1,2,3,4,5,6}or{2,1,4,3,6,5}
            local p=points[orders[index]]
            local angle=aim(o,p[1],p[2])
            fan(o,59,p[1],p[2],v[64]-16,angle,v[56],v[60],0)
            v[100]=v[100]+1
            if v[100]>v[108]then
                v[100],v[60],v[64],v[88],v[96],v[56]=v[104],16,-28,v[92],28,5
                v[68]=random(o,1);v[20],v[24]=24,1;spawn(o,0xc1bcde0)
            elseif v[100]==6 then
                v[88],v[96],v[56],v[64],v[60]=72,10,3,0,12
            elseif v[100]==12 then
                v[88],v[96],v[56],v[64],v[60]=56,7,3,28,4
            end
        end
        if v[20]~=0 and tick(v,20)<=0 then
            local x,y=b[8],b[12]+52*unit
            local angle=v[24]==1 and 256 or aim(o,x,y)
            fan(o,46,x,y,v[32]-35*v[24]-16,angle,v[36],v[40]+v[24]*4,0)
            v[36],v[24]=v[36]+4,v[24]-1
            if v[24]<0 then
                v[28]=v[28]-1
                if v[28]<0 then remove(o);return end
                v[32],v[40],v[44]=v[32]+10,v[40]-2,32
            else v[20]=32 end
        end
        if v[44]~=0 and tick(v,44)<=0 then spawn(o,0xc1bcea0)end
        if tick(v,0)>=0 then return end
        v[0]=v[8]
        local a=aim(o,b[8],b[12])
        v[48],v[52]=a-8,a+8
        local emit={
            {b[0x26e4]-24*unit,b[0x26e8]-14*unit,v[76]-16,v[48]+32},
            {b[0x26dc]+24*unit,b[0x26e0]-14*unit,v[76]-16,v[52]-32},
            {b[0x26e4]-4*unit,b[0x26e8],v[76]-8,v[48]+16},
            {b[0x26dc]+4*unit,b[0x26e0],v[76]-8,v[52]-16},
            {b[0x26e4]+12*unit,b[0x26e8]+14*unit,v[76],v[48]},
            {b[0x26dc]-12*unit,b[0x26e0]+14*unit,v[76],v[52]},
        }
        for _,p in ipairs(emit)do fan(o,19,p[1],p[2],p[3],p[4],1,16,0)end
        if tick(v,12)<0 then
            invoke(o,'target_flip');v[8]=max(14,v[8]-6)
            v[80]=v[80]+3;v[76]=v[80];v[12]=v[16];v[0]=40
        end
    end)
    register('first_b',0xc1bfd20,function(o,v,b)
        local x,y=b[8],b[12]+52*unit
        if tick(v,0)<0 then
            v[0]=v[4]
            local a=aim(o,x,y)
            if v[8]==v[12]then v[16]=a;v[8]=v[8]-1
            else v[16]=api.turn(a,v[16],4)end
            bullet(o,59,x,y,v[20]-16,v[16],0)
        end
        if v[28]~=0 then
            if tick(v,72)>=0 then return end
            v[72]=2
            local x1,y1,x2,y2=b[0x26ec],b[0x26f0],b[0x26f4],b[0x26f8]
            v[92],v[96]=aim(o,x1,y1),aim(o,x2,y2)
            bullet(o,21,x1,y1,v[84]-16,v[92],0)
            bullet(o,21,x2,y2,v[84]-16,v[96],0)
            v[84]=min(80,v[84]+5)
            if tick(v,76)>=0 then return end
            if tick(v,48)<0 then remove(o);return end
            invoke(o,'target_flip')
            v[88]=v[88]+10;v[84]=v[88]
            v[80]=v[80]+4;v[76]=v[80];v[28]=0
            return
        end
        if tick(v,32)>=0 then return end
        v[32]=4
        if v[40]==v[44]then
            v[24]=v[24]+1
            local odd=v[24]%2==1
            local d=trunc(v[44]*(odd and 6 or 3)/8)*8
            local first,second=aim(o,b[8],b[0x26f0]),aim(o,b[8],b[0x26f0])
            v[92],v[96]=first+(odd and -d or d),second+(odd and d or -d)
            v[52]=odd and 8 or -8
        end
        local spread=trunc(512/v[64])
        fan(o,58,b[0x26ec],b[0x26f0],v[56]-16,v[96],v[64],spread,0)
        fan(o,58,b[0x26f4],b[0x26f8],v[56]-16,v[92],v[64],spread,0)
        v[96],v[92]=(v[96]-v[52])%512,(v[92]+v[52])%512
        v[56]=v[56]+3
        if tick(v,40)>=0 then return end
        invoke(o,'target_flip');v[64]=v[68]
        v[44]=min(16,v[44]+2)
        v[32],v[36]=v[36],v[36]-8
        v[40],v[60]=v[44],v[60]+1;v[56]=v[60]
        local a=random(o,511)
        v[96],v[92]=(-a)%512,a;v[28]=1
    end)
    -- 第三组在直射展开与目标点回射之间切换；两种路径的比例、奇偶取整各自保留。
    register('first_c',0xc1c00d0,function(o,v,b)
        local x,y=b[0x26fc],b[0x2700]+24*unit
        if tick(v,0)>=0 then return end
        v[0]=v[8]
        local dx,dy=api.vector(768,aim(o,x,y))
        local angle=aim(o,x+dx,y+trunc(dy*3/4)+24*unit)
        v[56]=v[56]+1
        local count=v[44]+v[56]%2
        if v[72]==0 then
            local target=invoke(o,'target_position')
            local tx,ty
            if count%2==1 then
                tx=signed32(x+trunc(signed32(3*signed32(target[1]-x))/2))
                ty=signed32(y+trunc(signed32(3*signed32(target[2]-y)-48*unit)/2)+16*unit)
            else
                tx=signed32(x+trunc(signed32(signed32(target[1]-x)*40)/100))
                ty=signed32(y+trunc(signed32(signed32(target[2]-y)*40-640*unit)/100)+16*unit)
            end
            v[60]=v[60]+1
            local da=v[60]%2==1 and v[48]or-v[48]
            local start=256-(count%2==1 and da*trunc((count-1)/2)or trunc((count-1)*da/2))
            for i=0,count-1 do
                dx,dy=api.vector(768,start+i*da)
                local px,py=x+2*dx,y+3*dy+120*unit
                local a=api.heading(px,py,tx,ty)
                bullet(o,19,px,py,trunc(80*v[40]/100)-51,a,0)
            end
        else
            angle=angle-v[48]*trunc((count-1)/2)
            if count%2==0 then count=count-1 end
            for i=0,count-1 do
                local a=angle+i*v[48]
                dx,dy=api.vector(768,a)
                bullet(o,37,x+dx,y+trunc(dy/2),v[40]-51,a,0)
            end
        end
        if tick(v,12)<0 then
            invoke(o,'target_flip')
            v[24]=v[24]-1;v[0]=v[24];v[12]=v[16]
            v[40]=v[40]+5;v[48]=max(10,v[48]-2);v[44]=min(15,v[44]+1)
            v[56]=v[56]+1;v[68]=max(2,v[68]-1)
            if tick(v,20)<0 then remove(o);return end
        end
        if v[44]<=7 then v[72]=1;return end
        local old=v[72]
        v[72]=random(o,2)
        if v[72]~=0 then
            if old==0 then v[0]=trunc(3*v[8]/2)end
        else
            count=v[44]+(v[56]+1)%2
            if old==0 then v[0]=2*v[8]
            elseif count%2==0 then v[0]=trunc(v[8]/2)
            else v[0]=v[8]end
        end
    end)
    register('first_d',0xc1c0540,function(o,v,b)
        local leftX,leftY,rightX,rightY=b[0x2704],b[0x2708],b[0x270c],b[0x2710]
        if tick(v,0)<0 then
            v[0]=v[8]
            local restricted=v[76]==0 and v[112]==0 and v[84]==0
            local function fire(x,y,speed,a)
                if not restricted or(a%512-128)%4294967296<=256 then bullet(o,46,x,y,speed,a,0)end
            end
            fire(rightX,rightY,v[36]-16,v[24])
            fire(rightX,rightY,v[36]-16,v[24]+256)
            fire(leftX,leftY,v[40]-16,v[28])
            fire(leftX,leftY,v[40]-16,v[28]+256)
            v[24],v[28]=(v[24]+v[60])%512,(v[28]-v[64])%512
            if tick(v,12)<0 then
                v[8]=max(3,v[8]-1);v[36]=min(-4,v[36]+3);v[40]=min(-4,v[40]+3)
                v[12]=random(o,19)*2+59
                local old=v[60]
                v[60],v[64]=random(o,6)+6,random(o,6)+6
                if old>0 then v[60],v[64]=-v[60],-v[64]end
                v[0]=6
            end
        end
        if tick(v,72)>=0 then return end
        if v[128]==0 then
            v[72]=64
            local a=aim(o,leftX,leftY)
            for i=0,4 do bullet(o,19,leftX,leftY,v[88]+i*v[96]-16,a,0)end
            a=aim(o,rightX,rightY)
            for i=0,4 do bullet(o,19,rightX,rightY,v[88]+i*v[96]-16,a,0)end
            invoke(o,'target_flip');v[88]=v[88]+6
            if tick(v,76)<0 then
                v[128],v[72]=1,80;v[68]=random(o,1)
                v[92]=v[92]+4;v[88]=v[92]
                v[80]=v[80]+2;v[96]=v[96]-1;v[76]=v[108]
            end
            return
        end
        if v[76]==1 and v[112]==0 and v[84]==0 then v[72]=v[100]+48
        elseif v[76]~=0 or v[112]~=0 or v[84]~=0 then v[72]=v[100]end
        if v[76]==0 and v[112]==0 and v[84]==0 then
            local left=aim(o,leftX,leftY)-2
            local right=aim(o,rightX,rightY)+2
            for i=0,18 do
                local a=left+i*4
                local dx,dy=api.vector(640,a+256)
                bullet(o,37,leftX+dx,leftY+dy,-48,a,0)
                a=right-i*4;dx,dy=api.vector(640,a+256)
                bullet(o,37,rightX+dx,rightY+dy,-48,a,0)
            end
            remove(o);return
        end
        local count=v[112]==0 and 2 or 3
        local a=aim(o,leftX,leftY)+random(o,3)*4-8
        for i=0,count-1 do bullet(o,19,leftX,leftY,v[116]+i*v[124]-16,a,0)end
        a=aim(o,rightX,rightY)+random(o,3)*4-8
        for i=0,count-1 do bullet(o,19,rightX,rightY,v[116]+i*v[124]-16,a,0)end
        invoke(o,'target_flip');v[116]=v[116]+(v[112]==0 and 3 or 2)
        if tick(v,76)>=0 then return end
        if tick(v,112)>=0 then
            v[108]=v[108]+2;v[72],v[100],v[76]=40,8,v[108]
        elseif tick(v,84)<0 then remove(o)
        else
            v[128],v[72]=0,96;v[68]=random(o,1)
            v[120]=v[120]+1;v[116]=v[120];v[76]=v[80]
            v[100],v[112],v[124]=20,1,v[124]-1
        end
    end)
end
