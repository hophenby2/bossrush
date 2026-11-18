-- 第三段主炮台：独立的上侧追踪连射、长列双射和随机轴对向扇。
-- 后两组会更换移动入口、写身体开合标志；这些副作用仍在原调用位置发生。
local unit=65536
local min,max=math.min,math.max
return function(api)
    local register,allocate,switch,remove=api.register,api.allocate,api.switch,api.remove
    local invoke,tick,random,aim=api.invoke,api.tick,api.random,api.aim
    local fan,bullet,spawn=api.fan,api.bullet,api.spawn
    local function put(v,values)for a,n in pairs(values)do v[a]=n end end
    register('third_a_init',0xc1c13f0,function(o,v)
        allocate(o,92)
        put(v,{[0]=48,[4]=5,[8]=16,[40]=19,[16]=3,[20]=3,[24]=1,[28]=1,[32]=5,
            [44]=-10,[48]=-10,[52]=3,[56]=48,[60]=4,[64]=1})
        if random(o,1)~=0 then v[60],v[64]=-4,-1 end
        v[72]=0;api.parameters.write(o.block,68,1,0)
        v[80],v[88]=3,4
        if random(o,1)~=0 then v[88]=-4 end
        spawn(o,0xc1bcde0);invoke(o,'target_flip');invoke(o,'collision',true)
        switch(o,'third_a')
    end)
    register('third_b_init',0xc1c14e0,function(o,v,b)
        allocate(o,36)
        put(v,{[0]=32,[4]=1,[8]=313,[12]=2,[32]=0,[20]=-25,[16]=4})
        b[0x27a0]=1;invoke(o,'target_flip');switch(o,'third_b')
    end)
    register('third_c_init',0xc1c1570,function(o,v)
        allocate(o,84)
        put(v,{[4]=64,[8]=1,[0]=32,[12]=0,[16]=0,[20]=14,[24]=14,[36]=14,[40]=5,[44]=0,
            [48]=32,[52]=32,[56]=4,[60]=4,[80]=0,[64]=29,[68]=29,[72]=5,[76]=5})
        switch(o,'third_c')
    end)
    register('third_a',0xc1c1600,function(o,v,b)
        if tick(v,72)<0 then
            v[72]=3
            local x,y=b[0x2764],b[0x2768]+24*unit
            if v[80]==3 then v[84]=aim(o,x,y)else v[84]=v[84]+v[88]end
            bullet(o,58,x,y,-3*v[80]-23,v[84],1)
            if tick(v,80)<0 then
                if v[32]<0 then remove(o);return end
                v[80],v[72],v[88]=3,16,-v[88]
            end
        end
        if v[32]<0 or tick(v,0)>=0 then return end
        v[0]=v[4]
        local x,y=b[0x275c],b[0x2760]
        if v[16]==v[20]then v[36]=aim(o,x,y)end
        fan(o,v[40],x,y,v[44]-16,v[36]+v[60]*v[16],v[52],v[56],0)
        if tick(v,16)>=0 then return end
        invoke(o,'target_flip')
        api.parameters.write(o.block,68,1,api.parameters.read(o.block,68,1)+1)
        v[48]=v[48]+1;v[44]=v[48];v[16],v[0]=v[20],v[8]
        v[60],v[64]=-v[60],-v[64]
        if tick(v,24)>=0 then return end
        v[32]=v[32]-1;v[20]=min(8,v[20]+1)
        v[60]=v[60]+v[64];v[64]=v[64]>0 and 2 or-2
        v[52]=min(6,v[52]+1);v[16],v[0],v[24]=v[20],16,v[28]
        v[56]=v[56]-2
    end)
    register('third_b',0xc1c1830,function(o,v,b)
        if tick(v,0)>=0 then return end
        v[0]=v[4]
        local x,y=b[0x2754],b[0x2758]
        if v[32]==0 then
            if v[8]==0 then bullet(o,37,x,y,v[20]-16,256,0)
            else
                bullet(o,37,x,y,v[20]-16,v[16],0)
                bullet(o,37,x,y,v[20]-16,-v[16],0)
            end
            if tick(v,12)<0 then v[12],v[20]=2,min(45,v[20]+1)end
            v[16]=v[16]+9
            if tick(v,8)<0 then
                put(v,{[4]=16,[0]=40,[8]=1,[20]=10,[24]=31,[28]=16,[32]=1})
            end
        else
            if v[8]==1 then v[16]=aim(o,x,y)end
            fan(o,37,x,y,v[20]-16,v[16],v[24],v[28],0)
            if tick(v,8)<0 then b[0x27a0]=0;remove(o);return end
            v[28],v[24],v[20],v[16]=8,35,v[20]+30,v[16]+8
            invoke(o,'motion','replace','wander_init',16,120*unit,270*unit,16*unit,-16*unit,4*unit,-4*unit)
        end
    end)
    register('third_c',0xc1c1a60,function(o,v,b)
        local x,y=b[0x274c],b[0x2750]
        if v[44]==0 then
            if tick(v,0)>=0 then
                if v[0]==32 and v[20]==v[24]then spawn(o,0xc1bc880)end
                return
            end
            v[0]=v[8];v[28]=random(o,127)*4
            fan(o,46,x,y,v[36]-16,v[28],v[40],12,0)
            fan(o,46,x,y,v[36]-16,(v[28]+256)%512,v[40],12,0)
            if tick(v,12)>=0 then return end
            invoke(o,'target_flip');v[12],v[0]=v[16],8
            if tick(v,20)>=0 then return end
            v[4]=max(48,v[4]-8);v[0]=v[4]
            v[24]=min(79,v[24]+4);v[20]=v[24]
            v[36],v[40]=min(50,v[36]+10),min(9,v[40]+1)
            b[0x2788],b[0x278c],v[44]=1,10,1
            return
        end
        if tick(v,48)>=0 then return end
        v[48]=v[56];v[28]=aim(o,x,y)
        if v[64]%4==0 then
            local points={{b[0x271c]-8*unit,b[0x2720]-22*unit,-21,4},
                {b[0x271c]+5*unit,b[0x2720]-8*unit,-11,0},
                {b[0x271c]+15*unit,b[0x2720]+8*unit,-1,-4},
                {b[0x2714]+8*unit,b[0x2718]-22*unit,-21,-4},
                {b[0x2714]-5*unit,b[0x2718]-8*unit,-11,0},
                {b[0x2714]-15*unit,b[0x2718]+8*unit,-1,4}}
            for _,p in ipairs(points)do bullet(o,19,p[1],p[2],v[72]+p[3],aim(o,p[1],p[2])+p[4],0)end
        end
        if v[80]>3 then fan(o,19,x,y,v[72]-16,v[28],2,160,0)end
        if v[80]>1 then fan(o,19,x,y,v[72]-16,v[28],2,80,0)end
        bullet(o,19,x,y,v[72]-16,v[28]+random(o,24)-12,0)
        if tick(v,64)>=0 then return end
        invoke(o,'target_flip')
        v[52]=max(28,v[52]-1);v[48]=v[52]
        v[68]=min(79,v[68]+10);v[64]=v[68]
        v[76]=min(45,v[76]+10);v[72]=v[76]
        if v[76]==45 or v[76]==85 or v[76]==125 then v[60]=max(2,v[60]-1)end
        if v[76]==15 or v[76]==25 then v[80]=v[80]+2 end
        v[56]=v[60];b[0x2788]=0
        spawn(o,0xc1bc900);v[44]=0
    end)
end
