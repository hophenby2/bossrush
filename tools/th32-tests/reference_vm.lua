-- 仅供测试的独立顺序取指参照器：输入是测试时从原生二进制导出的记录。
-- 游戏不加载此文件；它与离线展开的静态 Lua 控制流使用同一套原生几何组件。
return function(H,P,data)
    local names={[-10001]='i0',[-10002]='i1',[-10003]='i2',[-10004]='i3',[-10005]='f0',[-10006]='f1',[-10007]='f2',[-10008]='f3',[-10009]='c0',[-10010]='c1',[-10011]='c2',[-10012]='c3'}
    local function tr(n) return n<0 and math.ceil(n) or math.floor(n) end
    local function norm(n) while n>math.pi do n=n-2*math.pi end;while n< -math.pi do n=n+2*math.pi end;return n end
    local function compare(n,a,b)
        if n==0 then return a<b elseif n==1 then return a<=b elseif n==2 then return a==b elseif n==3 then return a>b elseif n==4 then return a>=b else return a~=b end
    end
    local function run(stage,sub,b,v)
        local rows=data[stage][sub];local index=1
        local a=b.th06_actor
        local function get(x)
            if names[x] then return v[names[x]] end
            if x==-10013 then return stage==7 and 4 or 3 elseif x==-10014 then return a.rank
            elseif x==-10015 then return b.x+192 elseif x==-10016 then return 224-b.y elseif x==-10017 then return a.z
            elseif x==-10018 then return player.x+192 elseif x==-10019 then return 224-player.y elseif x==-10020 then return 0
            elseif x==-10021 then return H.player_angle(b) elseif x==-10022 then return a.phase elseif x==-10023 then return H.distance(b)
            elseif x==-10024 then return H.life(b) elseif x==-10025 then return a.meta.shot or 0 end
            return x
        end
        local function put(id,n)
            if names[id] then v[names[id]]=n
            elseif id==-10015 then b.x=n-192 elseif id==-10016 then b.y=224-n elseif id==-10017 then a.z=n
            elseif id==-10022 then a.phase=n elseif id==-10024 and not a.main then b.hp=n else error('不可写变量 '..id) end
        end
        local function jump(row,time,offset)
            local pos=row[1]+offset
            index=1
            while index<#rows and rows[index][1]<pos do index=index+1 end
            v.time=time
        end
        while index<=#rows do
            local row=rows[index];local t,op,x=row[2],row[3],row[4]
            H.wait(b,v,t);index=index+1
            if op==1 then H.erase(b)
            elseif op==2 then jump(row,x[1],x[2])
            elseif op==3 then put(x[3],get(x[3])-1);if get(x[3])>0 then jump(row,x[1],x[2]) end
            elseif op==4 or op==5 then put(x[1],get(x[2]))
            elseif op==6 or op==7 then put(x[1],H.random_int(get(x[2]))+(op==7 and get(x[3]) or 0))
            elseif op==8 or op==9 then put(x[1],ran:Float(0,get(x[2]))+(op==9 and get(x[3]) or 0))
            elseif op>=10 and op<=12 then put(x[1],({b.x+192,224-b.y,a.z})[op-9])
            elseif op>=13 and op<=17 or op>=20 and op<=24 then
                local k=op<20 and op or op-7;local l,r=get(x[2]),get(x[3]);local n
                if k==13 then n=l+r elseif k==14 then n=l-r elseif k==15 then n=l*r elseif k==16 then n=l/r;if op<20 then n=tr(n) end else n=math.fmod(l,r) end
                put(x[1],n)
            elseif op==18 or op==19 then put(x[1],get(x[1])+(op==18 and 1 or -1))
            elseif op==25 then put(x[1],math.atan2(get(x[5])-get(x[3]),get(x[4])-get(x[2])))
            elseif op==26 then put(x[1],norm(get(x[1])))
            elseif op==27 or op==28 then v.cmp=get(x[1])-get(x[2])
            elseif op>=29 and op<=34 then if compare(op-29,v.cmp,0) then jump(row,x[1],x[2]) end
            elseif op==35 then
                if stage==7 and x[1]==60 and a.main and a.sub==59 then H.erase(b) end
                H.call(b,v,P[stage][x[1]],get(x[2]),get(x[3]))
            elseif op==36 then return
            elseif op>=37 and op<=42 then if compare(op-37,get(x[4]),get(x[5])) then H.call(b,v,P[stage][x[1]],get(x[2]),get(x[3])) end
            elseif op==43 then H.position(b,get(x[1]),get(x[2]),get(x[3]));H.clamp(b)
            elseif op==44 then a.axisx,a.axisy,a.z=get(x[1]),get(x[2]),get(x[3]);a.mode='axis'
            elseif op==45 then a.angle,a.speed=get(x[1]),get(x[2]);a.mode='velocity'
            elseif op>=46 and op<=48 then a[({'angular','speed','accel'})[op-45]]=get(x[1]);a.mode='velocity'
            elseif op==49 or op==50 then H.rand_angle(b,get(x[1]),get(x[2]),op==50)
            elseif op==51 then a.angle=H.player_angle(b)+get(x[1]);a.speed=get(x[2]);a.mode='velocity'
            elseif op>=52 and op<=55 then H.move_dir(b,get(x[1]),get(x[2]),get(x[3]),op-51)
            elseif op>=56 and op<=60 then H.move_to(b,get(x[1]),get(x[2]),get(x[3]),get(x[4]),op-56)
            elseif op>=61 and op<=64 then H.move_dir(b,get(x[1]),a.angle,a.speed,op-60)
            elseif op==65 then a.bounds={get(x[1]),get(x[2]),get(x[3]),get(x[4])}
            elseif op==66 then a.bounds=nil
            elseif op>=67 and op<=75 then H.pattern(b,op-66,get(x[1]),get(x[2]),get(x[3]),get(x[4]),get(x[5]),get(x[6]),get(x[7]),get(x[8]),get(x[9]))
            elseif op==76 or op==77 then H.interval(b,get(x[1]),op==77)
            elseif op==78 or op==79 then a.muted=op==78
            elseif op==80 then H.fire(b)
            elseif op==81 then a.offsetx,a.offsety,a.offsetz=get(x[1]),get(x[2]),get(x[3])
            elseif op==82 then a.extra={};for i=1,8 do a.extra[i]=get(x[i]) end
            elseif op==83 then H.cancel(b)
            elseif op==84 then a.sound=get(x[1]);if a.pattern and a.sound>=0 then a.pattern.flags=bit.bor(a.pattern.flags,512) end
            elseif op==85 or op==86 then H.laser(b,op==86,get(x[1]),get(x[2]),get(x[3]),get(x[4]),get(x[5]),get(x[6]),get(x[7]),get(x[8]),get(x[9]),get(x[10]),get(x[11]),get(x[12]),get(x[13]),get(x[14]))
            elseif op==87 then a.laser_index=get(x[1])
            elseif op==88 or op==89 then H.rotate_laser(b,get(x[1]),get(x[2]),op==89)
            elseif op==90 then H.offset_laser(b,get(x[1]),get(x[2]),get(x[3]))
            elseif op==91 then v.cmp=H.laser_test(b,get(x[1]))
            elseif op==92 then H.laser_cancel(b,get(x[1]))
            elseif op==93 then H.cancel(b);H.reset_rank(a);H.trace(b,'spell',x[2])
            elseif op==94 then H.trace(b,'spell_end')
            elseif op==95 then H.spawn(b,stage,get(x[1]),get(x[2]),get(x[3]),get(x[4]),get(x[5]))
            elseif op==96 then H.clear_helpers(b)
            elseif op==97 then H.sprite(b,get(x[1]))
            elseif op==103 then b.a,b.b,b.rect=get(x[1])/2,get(x[2])/2,true
            elseif op==104 then a.collidable=x[1]~=0
            elseif op==105 then a.damageable=x[1]~=0
            elseif op==108 then a.death=P[stage][x[1]]
            elseif op==111 then if not a.main then b.hp=get(x[1]) end
            elseif op==112 then a.phase=get(x[1])
            elseif op==113 then a.life_threshold=get(x[1])
            elseif op==114 then a.life_fn=P[stage][x[1]]
            elseif op==115 then a.timeout=get(x[1]);a.phase=0
            elseif op==116 then a.timeout_fn=P[stage][x[1]]
            elseif op==117 then a.interactable=x[1]~=0
            elseif op==121 then H.extra(b,v,x[1],get(x[2]),false)
            elseif op==122 then v.repeat_func=x[1]>=0 and x[1] or nil
            elseif op==131 then a.rank_lo,a.rank_hi,a.rank_n1_lo,a.rank_n1_hi,a.rank_n2_lo,a.rank_n2_hi=get(x[1]),get(x[2]),get(x[3]),get(x[4]),get(x[5]),get(x[6])
            elseif op==132 then a.invisible=x[1]~=0
            elseif op==133 then a.phase=0
            elseif op==134 then a.lasers={}
            elseif op==135 then a.survival=x[1]~=0
            end
        end
    end
    for stage,subs in pairs(data) do
        for sub in pairs(subs) do
            local st,ss=stage,sub
            P[stage][sub]=function(b,v) return run(st,ss,b,v) end
        end
    end
end
