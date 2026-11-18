-- 入场与第二次换段的场景任务；场景计数、队列、武器状态由本步原生场景接口读取。
-- 时间线的函数地址只是固定表的接口标识，不取指、不解释 SH-3，也不播放坐标采样。
local data=dofile('mod/GAME/th46/boss5_tasks_data.lua')
local vector=dofile('mod/GAME/th46/direction.lua').vector
local trunc=math.modf
local unit=65536
return function(api)
    local register,allocate,switch,remove=api.register,api.allocate,api.switch,api.remove
    local invoke,spawn,alive,tick=api.invoke,api.spawn,api.alive,api.tick
    local random=api.random
    local function dust(o,x,y,d,span,base)
        local p=invoke(o,'dust',2,x,y,d,random(o,15))
        local speed=random(o,span)+4
        invoke(o,'dust_motion',p,speed,(base-random(o,span==16 and 63 or 31))%512)
    end
    local function timeline(at)
        for base,rows in pairs(data.timelines)do
            local i=(at-base)/12+1
            if i==math.floor(i)and i>=1 and i<=#rows then return rows[i]end
        end
        error('第五面时间线位置越界')
    end
    local entries={
        timeline_a_init={0xc1bc150,0xc31e070,0xc31e094,3,true},
        timeline_b_init={0xc1bc200,0xc31e0b8,0xc31e0c4,1,false},
        timeline_c_init={0xc1bc2b0,0xc31e0d0,0xc31e0dc,1,true},
        timeline_d_init={0xc1bc360,0xc31e0e8,0xc31e0e8,1,true},
    }
    for name,r in pairs(entries)do
        register(name,r[1],function(o,v)
            allocate(o,20);v[0],v[4]=0,0
            local mode=invoke(o,'weapon_mode')
            assert(mode[1]==0 or mode[1]==1,'第五面演出不支持该武器模式')
            v[12]=mode[1]==0 and r[2]or r[3]
            v[8]=r[4];v[16]=r[5]and mode[2]or 0
            switch(o,'timeline')
        end)
    end
    register('timeline',0xc1bd680,function(o,v)
        if v[16]==-1 then remove(o);return end
        local row=timeline(v[12])
        if v[0]==0 then v[4],v[0]=row[1],1 elseif v[0]~=1 then return end
        if tick(v,4)>=0 then return end
        if row[3]~=0 then
            local active=invoke(o,'weapon_active',v[16])
            assert(type(active)=='boolean','第五面演出武器存活接口必须返回布尔值')
            if not active then remove(o);return end
            invoke(o,'timeline_call',row[3],v[16])
        else invoke(o,'timeline_call',row[2])end
        v[12],v[8]=v[12]+12,v[8]-1
        if v[8]<=0 then remove(o)else v[4]=timeline(v[12])[1]end
    end)
    register('scene_init',0xc1bc040,function(o,v)
        allocate(o,20);v[0],v[4]=0,0;switch(o,'scene')
    end)
    register('scene',0xc1bd5d0,function(o,v)
        if v[0]==0 then v[0],v[8],v[12],v[16]=1,1,1,1 elseif v[0]~=1 then return end
        for i=1,3 do invoke(o,'queue_set',i,0,v[8])end
        if tick(v,12)>=0 then return end
        v[12],v[8]=v[16],v[8]+1
        if v[8]>23 then v[8]=24;remove(o)end
    end)
    register('entry_init',0xc1bc410,function(o,v,b)
        allocate(o,48);v[0],v[4]=0,1
        b[8],b[12]=120*unit-invoke(o,'camera',1),568*unit
        switch(o,'entry')
    end)
    register('entry',0xc1bd770,function(o,v,b)
        if v[0]==0 then v[44],v[8],v[36],v[40],v[4],v[0]=0,32,52,48,48,1 end
        if v[0]==1 then
            b[12]=b[12]+invoke(o,'root_offset',1)
            if v[4]~=0 and tick(v,4)<=0 then
                v[4]=0;invoke(o,'service',0xc062bac,0,96)
            end
            if invoke(o,'scene_counter',2)>1746 then v[0],v[4]=10,32 end
        elseif v[0]==10 then
            b[12]=b[12]+invoke(o,'root_offset',1)
            if v[4]~=0 and tick(v,4)<=0 then
                v[4]=0;invoke(o,'service',0xc0e51a0)
                spawn(o,0xc1bc150);v[44]=spawn(o,0xc1bc200);v[40]=v[40]+4
            end
            local queue=invoke(o,'queue_get',2)
            if queue[2]>0 and tick(v,36)<0 then
                v[36]=v[40]
                for _,i in ipairs({1,3,2})do
                    queue=invoke(o,'queue_get',i)
                    if queue[2]>0 then invoke(o,'queue_set',i,queue[1],queue[2]-1)end
                end
            end
            if v[44]~=0 and not alive(o,v[44])then v[0],v[4]=20,0 end
        elseif v[0]==20 then
            if tick(v,4)<0 then spawn(o,0xc1bc040);remove(o)end
        end
    end)
    register('change_init',0xc1bc490,function(o,v)
        allocate(o,48);v[0],v[4]=0,1;switch(o,'change')
    end)
    register('change',0xc1bd9d0,function(o,v,b)
        if v[0]==0 then
            if b[0x124]==0 then
                b[0x124]=invoke(o,'joint_effect',2,0x1d7c,0,16*unit,o.host.renderDepth+4,
                    o.host.renderDepth+8,0x1da0,256,0,1)
            end
            b[0x1db4],b[0x1eb4],b[0x138]=2,1,64
            v[12],v[16]=64*unit,-36*unit
            b[0x13c]=random(o,16)+8
            v[8],v[0]=32,1
        end
        if v[0]==1 then
            local x,y=vector(v[8],0)
            b[0x128],b[0x12c]=b[0x128]+x,b[0x12c]+y
            if assert(o.host.controlCounter)%4==0 then
                dust(o,b[8]+b[0x128],b[12]+b[0x12c],b[0xb7c],32,272)
            end
            if b[12]+b[0x12c]>384*unit then
                b[0x128]=v[12];b[0x1d70]=7
                v[0],v[8]=10,4;spawn(o,0xc1bcb00)
                v[24],v[28]=b[0x12c]-v[16],0
            end
        elseif v[0]==10 then
            local x=vector(trunc(v[24]/4096),v[28])
            b[0x12c]=v[16]+v[24]-x
            if v[28]>79 then b[0x1db4]=1 end
            if assert(o.host.controlCounter)%2==0 and v[28]>79 then
                for _=1,2 do
                    local px,py=b[8]+v[12],b[12]+v[16]-16*unit
                    dust(o,px,py,b[0xb7c],32,136);dust(o,px,py,b[0xb7c],32,408)
                end
            end
            v[28]=v[28]+2
            if v[28]>127 then
                local px,py=b[8]+v[12],b[12]+v[16]-16*unit
                for _=1,8 do dust(o,px,py,b[0xb7c],16,152);dust(o,px,py,b[0xb7c],16,424)end
                b[0x128],b[0x12c]=v[12],v[16]
                spawn(o,0xc1bc2b0);remove(o)
            end
        end
    end)
end
