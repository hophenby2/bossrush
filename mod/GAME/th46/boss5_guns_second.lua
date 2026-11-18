-- 第二段两组炮台：双肩螺旋与主体交替扇、两侧三拍扇与中央连扇。
-- 射速、角速度、加速上限和 FX 挂载保留 c1c0b40～c1c13bc 的各自计数器。
local unit=65536
local min=math.min
return function(api)
    local register,allocate,switch,remove=api.register,api.allocate,api.switch,api.remove
    local invoke,tick,random,aim=api.invoke,api.tick,api.random,api.aim
    local fan,bullet,spawn=api.fan,api.bullet,api.spawn
    local function put(v,values)for a,n in pairs(values)do v[a]=n end end
    register('second_a_init',0xc1c0b40,function(o,v)
        allocate(o,60)
        put(v,{[0]=64,[4]=18,[8]=9,[12]=9,[16]=3,[20]=0,[28]=384,[32]=128,
            [36]=-12,[40]=16,[44]=-30,[48]=0})
        v[52]=random(o,1);v[56]=0
        spawn(o,0xc1bcde0);invoke(o,'target_flip');invoke(o,'collision',true)
        switch(o,'second_a')
    end)
    register('second_b_init',0xc1c0c00,function(o,v)
        allocate(o,100)
        put(v,{[4]=80,[0]=192,[28]=4,[32]=4,[8]=0,[12]=2,[16]=2,[20]=2,[24]=7,[36]=2,
            [52]=0,[68]=0,[76]=3,[72]=512,[64]=64})
        v[80]=random(o,1)
        put(v,{[92]=7,[96]=7,[84]=15});switch(o,'second_b')
    end)
    register('second_a',0xc1c0c90,function(o,v,b)
        local x,y=b[8],b[12]+52*unit
        if tick(v,40)<0 then
            v[40]=3
            bullet(o,19,b[0x2734],b[0x2738],v[44]-16,v[28],0)
            bullet(o,19,b[0x273c],b[0x2740],v[44]-16,v[32],0)
            if v[44]<=45 then v[44]=v[44]+2 end
            if v[56]==0 then
                v[28],v[32]=v[28]-4,v[32]+4
                if v[28]<=256 then v[28],v[32],v[56]=256,256,1 end
            else
                v[28]=api.turn(aim(o,x,y),v[28],1);v[32]=v[28]
            end
            if invoke(o,'weapon_flag')then v[48]=1
            elseif v[48]~=0 then v[48],v[28],v[32]=0,384,128 end
        end
        if tick(v,0)>=0 then return end
        v[0]=v[4];v[24]=aim(o,x,y);v[52]=v[52]+1
        local phase=v[52]%4
        local spread=random(o,2)==0 and 10 or 3
        local angle=phase==0 and 266 or phase==1 and 246 or phase==2 and v[24]+10 or v[24]-10
        fan(o,46,x,y,v[36]-26,angle,phase<2 and 4 or 5,spread,0)
        if phase~=0 then bullet(o,51,x,y,-53,v[24]+random(o,15)-8,1)end
        if tick(v,8)>=0 then return end
        if tick(v,16)>=0 then v[4],v[8],v[36]=v[4]-2,v[12],v[36]+4
        elseif tick(v,20)>=0 then v[8]=v[12]
        else remove(o)end
    end)
    register('second_b',0xc1c0f40,function(o,v,b)
        if tick(v,64)<0 then
            v[64]=3;v[80]=v[80]+1
            local odd=v[80]%2==1
            local x,y=odd and b[0x275c]or b[0x2764],odd and b[0x2760]or b[0x2768]
            local angle=odd and v[68]or v[72]
            local speed=angle>=128 and angle<=384 and -30 or -10
            bullet(o,46,x,y,speed,angle,0)
            angle=(angle+256)%512
            if angle>=128 and angle<=384 then speed=-30 end
            bullet(o,46,x,y,speed,angle,0)
            v[68],v[72]=(v[68]+v[76])%512,(v[72]-v[76])%512
        end
        if tick(v,0)>=0 then return end
        v[0]=v[12]
        local lx,ly,rx,ry=b[0x2714],b[0x2718],b[0x271c],b[0x2720]
        if v[16]==v[20]then v[40],v[44]=aim(o,lx,ly),aim(o,rx,ry)
        else
            v[40]=api.turn(aim(o,lx,ly),v[40],2)
            v[44]=api.turn(aim(o,rx,ry),v[44],2)
        end
        if v[28]==0 then
            local x,y=b[8],b[12]+52*unit
            fan(o,19,x,y,v[84]-16,aim(o,x,y),v[92],8,0)
            v[84],v[92]=min(80,v[84]+6),min(15,v[92]+2)
        else
            local phase=v[16]%3
            local left=v[28]%2==1
            local x,y=left and lx or rx,left and ly or ry
            local dx=phase==0 and -15 or phase==1 and -5 or 8
            local dy=phase==0 and 8 or phase==1 and -8 or -22
            fan(o,phase==0 and 19 or 18,x+(left and dx or-dx)*unit,y+dy*unit,
                v[52]-phase*5-16,left and v[40]or v[44],7,12+phase*2,0)
        end
        if tick(v,16)>=0 then return end
        if tick(v,28)>=0 then
            if v[28]~=0 then v[0],v[12],v[16]=80-v[8],2,v[20]
            else
                v[16],v[0],v[24],v[12]=v[24],88-v[8],v[24]+2,24
                spawn(o,0xc1bcde0)
            end
            return
        end
        if tick(v,36)<0 then remove(o)else invoke(o,'target_flip')end
        -- 原程序在移除之后仍走到复位及演出挂载，旧指针写入由共享池保留。
        v[32]=v[32]+1;v[28]=v[32]
        v[0],v[12],v[16],v[8],v[52]=160,2,v[20],v[8]+12,v[52]+6
        v[88]=min(80,v[88]+5);v[84]=v[88]
        v[96]=min(15,v[96]+2);v[92]=v[96]
        spawn(o,0xc1bcea0)
    end)
end
