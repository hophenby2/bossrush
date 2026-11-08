-- 由 tools/th36-tests/expand.py 离线生成。手工改行为应同步修改展开器并核对原二进制。

local H,P=...

-- default.ecl：Ecl_EtBreak，0xb0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb0，40号。
        H.at(a,v,0)
        -- 源0xc4，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0xd8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xec，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x100，12号。
        v.origin=H.clock(a)-(1);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x118，420号。
        H.cancel(a,(v.l[4] or 0),true)
        H.at(a,v,0)
        -- 源0x12c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x140，42号。
        H.push(v,10)
        H.at(a,v,1)
        -- 源0x154，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,1)
        -- 源0x164，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,1)
        -- 源0x178，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x18c，44号。
        H.push(v,640.0)
        H.at(a,v,1)
        -- 源0x1a0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,1)
        -- 源0x1b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,1)
        -- 源0x1c8，1号。
        H.erase(a);return
    end
    P["Ecl_EtBreak"]=B.part1
end

-- default.ecl：Ecl_EtBreak2，0x1e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1e8，40号。
        H.at(a,v,0)
        -- 源0x1fc，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x210，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x224，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x238，12号。
        v.origin=H.clock(a)-(1);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x250，420号。
        H.cancel(a,(v.l[4] or 0),true)
        H.at(a,v,0)
        -- 源0x264，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x278，42号。
        H.push(v,6)
        H.at(a,v,1)
        -- 源0x28c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,1)
        -- 源0x29c，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,1)
        -- 源0x2b0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x2c4，44号。
        H.push(v,640.0)
        H.at(a,v,1)
        -- 源0x2d8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,1)
        -- 源0x2e8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,1)
        -- 源0x300，1号。
        H.erase(a);return
    end
    P["Ecl_EtBreak2"]=B.part1
end

-- default.ecl：Ecl_EtBreak2_ni，0x320；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x320，40号。
        H.at(a,v,0)
        -- 源0x334，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x348，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x35c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x370，12号。
        v.origin=H.clock(a)-(1);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x388，421号。
        H.cancel(a,(v.l[4] or 0),false)
        H.at(a,v,0)
        -- 源0x39c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x3b0，42号。
        H.push(v,6)
        H.at(a,v,1)
        -- 源0x3c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,1)
        -- 源0x3d4，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,1)
        -- 源0x3e8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x3fc，44号。
        H.push(v,640.0)
        H.at(a,v,1)
        -- 源0x410，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,1)
        -- 源0x420，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,1)
        -- 源0x438，1号。
        H.erase(a);return
    end
    P["Ecl_EtBreak2_ni"]=B.part1
end

-- default.ecl：Ecl_EtBreak_ni，0x458；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x458，40号。
        H.at(a,v,0)
        -- 源0x46c，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x480，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x494，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x4a8，12号。
        v.origin=H.clock(a)-(1);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4c0，421号。
        H.cancel(a,(v.l[4] or 0),false)
        H.at(a,v,0)
        -- 源0x4d4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x4e8，42号。
        H.push(v,10)
        H.at(a,v,1)
        -- 源0x4fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,1)
        -- 源0x50c，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,1)
        -- 源0x520，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,1)
        -- 源0x534，44号。
        H.push(v,640.0)
        H.at(a,v,1)
        -- 源0x548，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,1)
        -- 源0x558，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,1)
        -- 源0x570，1号。
        H.erase(a);return
    end
    P["Ecl_EtBreak_ni"]=B.part1
end

-- default.ecl：et_ofs_r，0x590；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x590，40号。
        H.at(a,v,0)
        -- 源0x5a4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5b8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5cc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5dc，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x5fc，403号。
        H.gun_offset(a,(v.l[0] or 0),(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x618，10号。
        return
    end
    P["et_ofs_r"]=B.part1
end

-- default.ecl：test，0x638；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x638，40号。
        H.at(a,v,0)
        -- 源0x64c，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x660，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x670，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x684，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x694，42号。
        H.push(v,-3)
        H.at(a,v,0)
        -- 源0x6a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6b8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6cc，10号。
        return
    end
    P["test"]=B.part1
end

-- stage02.ecl：BCir00，0x584；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x584，40号。
        H.at(a,v,0)
        -- 源0x598，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x5ac，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x5c0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x5d8，11号。
        H.call(a,v,P["Cir00"],"Cir00",75,1)
        H.at(a,v,0)
        -- 源0x604，1号。
        H.erase(a);return
    end
    P["BCir00"]=B.part1
end

-- stage02.ecl：BCir01，0x624；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x624，40号。
        H.at(a,v,0)
        -- 源0x638，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x64c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x660，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x678，11号。
        H.call(a,v,P["Cir01"],"Cir01",75,1)
        H.at(a,v,0)
        -- 源0x6a4，1号。
        H.erase(a);return
    end
    P["BCir01"]=B.part1
end

-- stage02.ecl：BCir01B，0x6c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6c4，40号。
        H.at(a,v,0)
        -- 源0x6d8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6ec，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x700，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x718，11号。
        H.call(a,v,P["Cir01B"],"Cir01B",75,1)
        H.at(a,v,0)
        -- 源0x744，1号。
        H.erase(a);return
    end
    P["BCir01B"]=B.part1
end

-- stage02.ecl：BCir02，0x764；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x764，40号。
        H.at(a,v,0)
        -- 源0x778，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x78c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x7a0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x7b8，11号。
        H.call(a,v,P["Cir02"],"Cir02",75,1)
        H.at(a,v,0)
        -- 源0x7e4，1号。
        H.erase(a);return
    end
    P["BCir02"]=B.part1
end

-- stage02.ecl：BCir02B，0x804；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x804，40号。
        H.at(a,v,0)
        -- 源0x818，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x82c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x840，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x858，11号。
        H.call(a,v,P["Cir02B"],"Cir02B",75,1)
        H.at(a,v,0)
        -- 源0x884，1号。
        H.erase(a);return
    end
    P["BCir02B"]=B.part1
end

-- stage02.ecl：BGirl00，0x8a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8a4，40号。
        H.at(a,v,0)
        -- 源0x8b8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x8cc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x8e0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x8f8，11号。
        H.call(a,v,P["Girl00"],"Girl00",0,1)
        H.at(a,v,0)
        -- 源0x924，1号。
        H.erase(a);return
    end
    P["BGirl00"]=B.part1
end

-- stage02.ecl：BGirl01，0x944；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x944，40号。
        H.at(a,v,0)
        -- 源0x958，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x96c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x980，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x998，11号。
        H.call(a,v,P["Girl01"],"Girl01",0,1)
        H.at(a,v,0)
        -- 源0x9c4，1号。
        H.erase(a);return
    end
    P["BGirl01"]=B.part1
end

-- stage02.ecl：BGirl01B，0x9e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9e4，40号。
        H.at(a,v,0)
        -- 源0x9f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa0c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa20，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xa38，11号。
        H.call(a,v,P["Girl01B"],"Girl01B",0,1)
        H.at(a,v,0)
        -- 源0xa64，1号。
        H.erase(a);return
    end
    P["BGirl01B"]=B.part1
end

-- stage02.ecl：BGirl02，0xa84；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa84，40号。
        H.at(a,v,0)
        -- 源0xa98，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xaac，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xac0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xad8，11号。
        H.call(a,v,P["Girl02"],"Girl02",0,1)
        H.at(a,v,0)
        -- 源0xb04，1号。
        H.erase(a);return
    end
    P["BGirl02"]=B.part1
end

-- stage02.ecl：BGirl03，0xb24；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb24，40号。
        H.at(a,v,0)
        -- 源0xb38，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb4c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb60，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xb78，11号。
        H.call(a,v,P["Girl03"],"Girl03",0,1)
        H.at(a,v,0)
        -- 源0xba4，1号。
        H.erase(a);return
    end
    P["BGirl03"]=B.part1
end

-- stage02.ecl：Boss，0xbc4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbc4，40号。
        H.at(a,v,0)
        -- 源0xbd8，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0xbec，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xc00，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xc18，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xc2c，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xc44，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xc5c，335号。
        a.invul=60
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xc84，331号。
        H.life(a,9200)
        H.at(a,v,0)
        -- 源0xc98，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xcb8，440号。
        H.fog(a,160.0,33023)
        H.at(a,v,0)
        -- 源0xcd0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xce4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xcf8，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0xd08，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,60)
        -- 源0xd28，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0xd3c，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0xd54，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0xd68，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0xd84，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage02.ecl：Boss1，0xda4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xda4，40号。
        H.at(a,v,0)
        -- 源0xdb8，333号。
        a.phase_time=0
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xe10，334号。
        H.interrupt(a,0,1500,2100,"BossCard1")
        H.at(a,v,0)
        -- 源0xe3c，347号。
        H.life_marker(a,0,1500.0,-24448)
        H.at(a,v,0)
        -- 源0xe58，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0xe6c，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0xe80，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0xea0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xeb8，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil)
        H.at(a,v,0)
        -- 源0xed8，368号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0xef8，292号。
        H.wander(a,0,60,4,1.0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf14，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf28，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf40，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage02.ecl：Boss1At1，0xf60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf60，40号。
        H.at(a,v,0)
        -- 源0xf74，355号。
        v.l[4]=H.int(6)
        H.at(a,v,0)
        -- 源0xf98，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xfac，83号。
        v.origin=v.origin+H.int(8)
        H.at(a,v,0)
        -- 源0xfc0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xfd4，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xfe8，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0xffc，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1010，12号。
        v.origin=H.clock(a)-(0);return B.part19(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1028，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x103c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x1054，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x1070，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x108c，404号。
        H.gun_angle(a,0,0.0,0.15707963705062866)
        H.at(a,v,0)
        -- 源0x10a8，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0x10c4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x10f4，409号。
        H.gun_transform(a,0,1,0,1024,160,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1124，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[8] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1154，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x1168，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x117c，44号。
        H.push(v,0.16362500190734863)
        H.at(a,v,0)
        -- 源0x1190，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11a4，12号。
        v.origin=H.clock(a)-(0);return B.part14(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x11bc，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x11d0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x11e4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x11f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1208，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1218，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1230，409号。
        H.gun_transform(a,0,3,0,16,60,1,(v.l[16] or 0),1.0)
        H.at(a,v,0)
        -- 源0x1260，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1274，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1288，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1298，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x12b0，409号。
        H.gun_transform(a,0,4,0,-2147483648,-999999,-999999,-999999.0,-999999.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x12e0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12f4，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x1308，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1318，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1330，409号。
        H.gun_transform(a,0,3,0,16,60,1,(v.l[16] or 0),1.5)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1360，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1378，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x138c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x13a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13b0，409号。
        H.gun_transform(a,0,3,0,16,60,1,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x13e0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1408，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1418，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1430，409号。
        H.gun_transform(a,0,4,0,8192,-999999,-999999,-999999.0,-999999.0)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x1460，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1474，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x1488，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1498，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x14b0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x14c4，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x14d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x14e8，409号。
        H.gun_transform(a,0,3,0,16,60,1,H.read(a,v,-1),2.5)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x1518，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1534，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1548，44号。
        H.push(v,0.03926999866962433)
        H.at(a,v,0)
        -- 源0x155c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x156c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1580，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1594，44号。
        H.push(v,0.06544999778270721)
        H.at(a,v,0)
        -- 源0x15a8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x15b8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x15cc，401号。
        H.fire(a,0)
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x15e0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x15f4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x160c，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1620，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x1634，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1644，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1658，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x166c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1680，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1690，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x16a8，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x16bc，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x16d0，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x16e0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x16f4，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x170c，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1720，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1734，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x1744，43号。
        v.l[8]=H.int(H.pop(v))
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x1758，368号。
        v.origin=v.origin+H.int(6)
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x1778，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x178c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part20(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,0)
        -- 源0x17a4，10号。
        return
    end
    P["Boss1At1"]=B.part1
end

-- stage02.ecl：Boss2，0x17c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x17c4，40号。
        H.at(a,v,0)
        -- 源0x17d8，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x17e8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x17f8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x180c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1820，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1830，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1848，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x185c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1874，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1888，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1898，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x18a8，331号。
        H.life(a,11850)
        H.at(a,v,0)
        -- 源0x18bc，334号。
        H.interrupt(a,0,3050,2100,"BossCard2")
        H.at(a,v,0)
        -- 源0x18e8，347号。
        H.life_marker(a,0,3050.0,-24448)
        H.at(a,v,0)
        -- 源0x1904，347号。
        H.life_marker(a,1,1500.0,-32704)
        H.at(a,v,0)
        -- 源0x1920，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x1934，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x1948，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x195c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1970，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1980，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1998，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x19ac，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x19bc，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x19d0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x19e4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x19f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1a0c，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1a20，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a34，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1a48，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1a5c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a70，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1a80，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1a98，327号。
        H.drop_extra(a,1,6)
        H.at(a,v,0)
        -- 源0x1ab0，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1ac8，327号。
        H.drop_extra(a,1,10)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1ae0，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x1af8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1b10，329号。
        H.drop(a)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x1b20，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1b34，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x1b54，0号。
        H.at(a,v,90)
        -- 源0x1b64，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,90)
        -- 源0x1b84，12号。
        v.origin=H.clock(a)-(90);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,90)
        -- 源0x1b9c，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,90)
        -- 源0x1bbc，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x1bdc，292号。
        H.wander(a,0,60,4,3.0)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,90)
        -- 源0x1bf8，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x1c0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,90)
        -- 源0x1c24，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage02.ecl：Boss2At1，0x1c44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1c44，40号。
        H.at(a,v,0)
        -- 源0x1c58，356号。
        v.l[20]=H.f32(2.5)
        H.at(a,v,0)
        -- 源0x1c7c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x1c90，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ca4，356号。
        v.l[24]=H.f32(2.0)
        H.at(a,v,0)
        -- 源0x1cc8，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x1cdc，83号。
        v.origin=v.origin+H.int(8)
        H.at(a,v,0)
        -- 源0x1cf0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1d04，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d18，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x1d2c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d40，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1d58，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1d6c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x1d84，402号。
        H.gun_sprite(a,0,3,13)
        H.at(a,v,0)
        -- 源0x1da0，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x1dbc，404号。
        H.gun_angle(a,0,0.0,0.15707963705062866)
        H.at(a,v,0)
        -- 源0x1dd8，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0x1df4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1e24，409号。
        H.gun_transform(a,0,1,0,1024,160,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1e54，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[8] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1e84，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x1e98，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1eac，44号。
        H.push(v,0.16362500190734863)
        H.at(a,v,0)
        -- 源0x1ec0，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ed4，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1eec，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1f00，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1f14，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x1f24，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1f38，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1f48，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1f60，409号。
        H.gun_transform(a,0,3,0,16,40,1,(v.l[16] or 0),(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x1f90，409号。
        H.gun_transform(a,0,4,0,-2147483648,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fc0，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1fd8，409号。
        H.gun_transform(a,0,3,0,16,40,1,(v.l[16] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x2008，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x201c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2030，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2040，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2058，409号。
        H.gun_transform(a,0,4,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2088，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x20a0，409号。
        H.gun_transform(a,0,4,0,16777216,3,5,-999999.0,-999999.0)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x20d0，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x20ec，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2100，44号。
        H.push(v,0.03926999866962433)
        H.at(a,v,0)
        -- 源0x2114，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2124，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2138，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x214c，44号。
        H.push(v,0.06544999778270721)
        H.at(a,v,0)
        -- 源0x2160，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2170，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2184，401号。
        H.fire(a,0)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x2198，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x21ac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x21c4，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x21d8，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x21ec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x21fc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2210，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2224，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2238，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x2248，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x225c，83号。
        v.origin=v.origin+H.int(10)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x2270，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x2284，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x229c，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage02.ecl：BossCard1，0x22bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x22bc，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x22f8，334号。
        H.interrupt(a,0,0,2100,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x2364，359号。
        H.spell(a,16,2100,500000,"花咲爺「シロの灰」",359)
        H.at(a,v,0)
        -- 源0x2398，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x23ac，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x23bc，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0x23dc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x23f0，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x2404，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x2438，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,0)
        -- 源0x2458，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x246c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2480，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2490，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x24a8，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x24bc，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x24cc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x24e0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x24f4，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x250c，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x2520，0号。
        H.at(a,v,150)
        -- 源0x2530，15号。
        H.async(a,P["BossCard1_at"],"BossCard1_at",nil)
        H.at(a,v,150)
        -- 源0x2554，15号。
        H.async(a,P["BossCard1_at2"],"BossCard1_at2",nil)
        H.at(a,v,150)
        H.at(a,v,150)
        -- 源0x25a0，300号。
        H.ellipse(a,0,3.1415927410125732,0.012083048932254314,0.0,1.25,1.5707963705062866,0.25)
        H.at(a,v,150)
        -- 源0x25c8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,150)
        -- 源0x25dc，300号。
        H.ellipse(a,0,-999999.0,-999999.0,-999999.0,0.0,-999999.0,-999999.0)
        H.at(a,v,150)
        -- 源0x2604，12号。
        v.origin=H.clock(a)-(150);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x261c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x2630，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x2644，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x265c，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage02.ecl：BossCard1At，0x267c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x267c，40号。
        H.at(a,v,0)
        -- 源0x2690，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x26a4，15号。
        H.async(a,P["BossCard1At_at"],"BossCard1At_at",nil)
        H.at(a,v,0)
        -- 源0x26c8，284号。
        H.velocity(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x26e0，285号。
        H.velocity_time(a,0,30,0,-999999.0,3.0)
        H.at(a,v,0)
        -- 源0x2700，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x2714，1号。
        H.erase(a);return
    end
    P["BossCard1At"]=B.part1
end

-- stage02.ecl：BossCard1At_at，0x2744；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2744，40号。
        H.at(a,v,0)
        -- 源0x2758，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x276c，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x2784，402号。
        H.gun_sprite(a,1,17,2)
        H.at(a,v,0)
        -- 源0x27a0，436号。
        H.gun_count_diff(a,1,1,1,2,6,1,1,1,1)
        H.at(a,v,0)
        -- 源0x27d4，404号。
        H.gun_angle(a,1,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x27f0，405号。
        H.gun_speed(a,1,1.0,1.0)
        H.at(a,v,0)
        -- 源0x280c，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x283c，409号。
        H.gun_transform(a,1,1,0,4,30,-999999,0.10000000149011612,-999999.0)
        H.at(a,v,0)
        -- 源0x286c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x2880，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2894，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x28ac，402号。
        H.gun_sprite(a,0,2,4)
        H.at(a,v,0)
        -- 源0x28c8，406号。
        H.gun_count(a,0,5,1)
        H.at(a,v,0)
        -- 源0x28e4，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x2900，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x291c，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x294c，409号。
        H.gun_transform(a,0,2,0,16777216,3,3,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x297c，409号。
        H.gun_transform(a,0,3,0,4096,90,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x29ac，409号。
        H.gun_transform(a,0,4,0,16777216,3,0,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x29dc，409号。
        H.gun_transform(a,0,5,0,4096,90,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2a0c，409号。
        H.gun_transform(a,0,6,0,16777216,3,1,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2a3c，409号。
        H.gun_transform(a,0,7,0,4096,90,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2a6c，409号。
        H.gun_transform(a,0,8,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2a9c，408号。
        H.gun_sound(a,0,24,-1)
        H.at(a,v,0)
        -- 源0x2ab8，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x2acc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2ae0，42号。
        H.push(v,600)
        H.at(a,v,0)
        -- 源0x2af4，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b08，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2b1c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b30，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2b48，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2b5c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2b70，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b80，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2b98，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[12] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2bc8，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2be0，409号。
        H.gun_transform(a,0,1,0,-2147483648,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2c10，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x2c24，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2c38，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2c48，409号。
        H.gun_transform(a,0,3,0,4096,H.read(a,v,-1),-999999,-999999.0,-999999.0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2c78，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x2c94，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2ca8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2cbc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2ccc，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2cec，282号。
        H.position(a,1,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2d04，438号。
        H.gun_distance(a,0,8.0)
        H.at(a,v,0)
        -- 源0x2d1c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x2d38，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2d4c，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2d60，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2d74，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x2d84，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2d98，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2dac，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x2dc0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2dd0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2de4，83号。
        v.origin=v.origin+H.int(8)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2df8，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x2e0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2e24，10号。
        return
    end
    P["BossCard1At_at"]=B.part1
end

-- stage02.ecl：BossCard1_at，0x2e44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2e44，40号。
        H.at(a,v,0)
        -- 源0x2e58，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x2e6c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2e84，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2e98，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2eac，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x2ee0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x2ef4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x2f08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2f18，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2f2c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x2f60，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x2f74，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x2f88，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2f98，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2fac，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x2fe0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x2ff4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x3008，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3018，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x302c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3060，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3074，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3088，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3098，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x30ac，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x30e0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x30f4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x3108，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3118，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x312c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3160，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x3174，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3188，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x319c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x31d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x31e4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x31f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3208，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x321c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3250，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3264，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3278，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3288，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x329c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x32d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x32e4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x32f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3308，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x331c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3350，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3364，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3378，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3388，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x339c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x33d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x33e4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x33f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3408，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x341c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3450，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x3464，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3478，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x348c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x34c0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x34d4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x34e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x34f8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x350c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3540，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3554，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3568，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3578，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x358c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x35c0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x35d4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x35e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x35f8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x360c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3640，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3654，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3668，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3678，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x368c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x36c0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x36d4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x36e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x36f8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x370c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3740，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x3754，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3768，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x377c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x37b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x37c4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x37d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x37e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x37fc，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3830，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3844，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3858，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3868，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x387c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x38b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x38c4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x38d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x38e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x38fc，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3930，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3944，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3958，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3968，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x397c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x39b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x39c4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x39d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x39e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x39fc，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x3a30，83号。
        v.origin=v.origin+H.int(90)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3a44，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3a58，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3a70，10号。
        return
    end
    P["BossCard1_at"]=B.part1
end

-- stage02.ecl：BossCard1_at2，0x3a90；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3a90，40号。
        H.at(a,v,0)
        -- 源0x3aa4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3ab8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x3ad0，402号。
        H.gun_sprite(a,0,12,5)
        H.at(a,v,0)
        -- 源0x3aec，436号。
        H.gun_count_diff(a,0,8,8,16,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0x3b20，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x3b3c，435号。
        H.gun_speed_diff(a,0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x3b70，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3ba0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3bb4，83号。
        v.origin=v.origin+H.int(360)
        H.at(a,v,0)
        -- 源0x3bc8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3be0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3bf4，368号。
        v.origin=v.origin+H.int(90)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3c14，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3c28，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3c40，10号。
        return
    end
    P["BossCard1_at2"]=B.part1
end

-- stage02.ecl：BossCard2，0x3c60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3c60，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x3cb4，359号。
        H.spell(a,20,2400,500000,"舌切雀「大きな葛籠と小さな葛籠」",359)
        H.at(a,v,0)
        -- 源0x3cf8，334号。
        H.interrupt(a,0,1500,2400,"BossCard3")
        H.at(a,v,0)
        -- 源0x3d24，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x3d34，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x3d54，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3d68，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x3d7c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3d90，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3da4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3db4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3dcc，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x3e00，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3e18，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3e50，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x3e64，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3e78，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3e88，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3ea0，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x3eb4，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3ec4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3ed8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3eec，344号。
        a.chapter=44
        H.at(a,v,60)
        -- 源0x3f00，0号。
        H.at(a,v,60)
        -- 源0x3f10，363号。
        H.background_end(a)
        H.at(a,v,60)
        -- 源0x3f20，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,60)
        -- 源0x3f34，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x3f48，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,60)
        -- 源0x3f58，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x3f6c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x3f7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x3f94，42号。
        H.push(v,-96)
        H.at(a,v,60)
        -- 源0x3fa8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x3fbc，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x3fd4，42号。
        H.push(v,96)
        H.at(a,v,60)
        -- 源0x3fe8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x3ffc，12号。
        v.origin=H.clock(a)-(70);return B.part13(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x4014，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x4028，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x4040，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,60)
        -- 源0x4054，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,60)
        -- 源0x4068，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x407c，256号。
        H.spawn(a,256,"BossCard2Dummy",0.0,0.0,800,1000,3)
        H.at(a,v,60)
        -- 源0x40b4，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,60)
        -- 源0x40cc，322号。
        H.flags(a,1,true)
        H.at(a,v,60)
        -- 源0x40e0，323号。
        H.flags(a,1,false)
        H.at(a,v,60)
        -- 源0x40f4，83号。
        v.origin=v.origin+H.int(26)
        H.at(a,v,60)
        -- 源0x4108，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x411c，42号。
        H.push(v,-1)
        H.at(a,v,60)
        -- 源0x4130，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x4140，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x4154，280号。
        H.position(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x416c，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,60)
        -- 源0x4180，323号。
        H.flags(a,1,false)
        H.at(a,v,60)
        -- 源0x4194，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x41a8，15号。
        H.async(a,P["BossCard2_at4"],"BossCard2_at4",nil,0)
        H.at(a,v,60)
        -- 源0x41d4，368号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,70)
        -- 源0x41f4，0号。
        H.at(a,v,70)
        -- 源0x4204，21号。
        H.stop_threads(a)
        H.at(a,v,70)
        -- 源0x4214，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,70)
        -- 源0x4228，42号。
        H.push(v,0)
        H.at(a,v,70)
        -- 源0x423c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,70)
        -- 源0x424c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(70);return B.part12(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,70)
        -- 源0x4264，42号。
        H.push(v,-96)
        H.at(a,v,70)
        -- 源0x4278，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,70)
        -- 源0x428c，12号。
        v.origin=H.clock(a)-(70);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,70)
        -- 源0x42a4，42号。
        H.push(v,96)
        H.at(a,v,70)
        -- 源0x42b8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,70)
        -- 源0x42cc，42号。
        H.push(v,1)
        H.at(a,v,70)
        -- 源0x42e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part10(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,70)
        -- 源0x42f8，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage02.ecl：BossCard2Dummy，0x4318；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4318，40号。
        H.at(a,v,0)
        -- 源0x432c，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x4340，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x4358，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x436c，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0x4384，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x4398，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x43b0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x43c8，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,0)
        -- 源0x43e0，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0)
        H.at(a,v,0)
        -- 源0x440c，322号。
        H.flags(a,1,true)
        H.at(a,v,0)
        -- 源0x4420，323号。
        H.flags(a,1,false)
        H.at(a,v,0)
        -- 源0x4434，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,0)
        -- 源0x4448，280号。
        H.position(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x4460，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,0)
        -- 源0x4474，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x4488，15号。
        H.async(a,P["BossCard2_at3"],"BossCard2_at3",nil,0)
        H.at(a,v,0)
        -- 源0x44b4，368号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x44d4，263号。
        H.effect(a,0,81)
        H.at(a,v,0)
        -- 源0x44ec，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x4500，1号。
        H.erase(a);return
    end
    P["BossCard2Dummy"]=B.part1
end

-- stage02.ecl：BossCard2_at，0x4520；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4520，40号。
        H.at(a,v,0)
        -- 源0x4534，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4548，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x455c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4570，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4584，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4598，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x45b0，402号。
        H.gun_sprite(a,0,17,2)
        H.at(a,v,0)
        -- 源0x45cc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x45e8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4604，405号。
        H.gun_speed(a,0,2.0,2.0)
        H.at(a,v,0)
        -- 源0x4620，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4650，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x4664，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4678，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x468c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x46a0，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x46b8，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x46cc，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x46e0，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x46f0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4708，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x471c，44号。
        H.push(v,64.0)
        H.at(a,v,0)
        -- 源0x4730，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4740，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x475c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4770，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x4784，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4794，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x47b0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x47c4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x47d8，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x47e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4800，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4814，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x4828，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4838，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x484c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x485c，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4878，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4890，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x48a4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x48b8，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x48c8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x48e0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x48f4，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x4908，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4918，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x492c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x493c，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4958，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x4970，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4984，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x4998，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x49a8，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x49bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x49cc，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x49e8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x49fc，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x4a10，43号。
        v.l[16]=H.int(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x4a24，368号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x4a44，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4a58，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0x4a6c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4a7c，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x4a90，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4aa4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x4abc，10号。
        return
    end
    P["BossCard2_at"]=B.part1
end

-- stage02.ecl：BossCard2_at2，0x4adc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4adc，40号。
        H.at(a,v,0)
        -- 源0x4af0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4b04，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4b18，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x4b2c，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x4b44，402号。
        H.gun_sprite(a,1,0,10)
        H.at(a,v,0)
        -- 源0x4b60，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x4b7c，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4b98，405号。
        H.gun_speed(a,1,2.0,2.0)
        H.at(a,v,0)
        -- 源0x4bb4，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4be4，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x4bf8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4c0c，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4c24，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4c38，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x4c4c，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4c5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4c74，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4c88，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x4c9c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4cac，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4cc8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4cdc，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x4cf0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4d00，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x4d14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4d24，405号。
        H.gun_speed(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4d40，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4d54，44号。
        H.push(v,64.0)
        H.at(a,v,0)
        -- 源0x4d68，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4d78，437号。
        H.gun_polar(a,1,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x4d94，401号。
        H.fire(a,1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4da8，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x4dbc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4dd0，368号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x4df0，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x4e04，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4e18，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x4e2c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4e3c，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4e50，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4e64，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4e7c，10号。
        return
    end
    P["BossCard2_at2"]=B.part1
end

-- stage02.ecl：BossCard2_at3，0x4e9c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4e9c，40号。
        H.at(a,v,0)
        -- 源0x4eb0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4ec4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4ed8，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x4eec，407号。
        H.gun_aim(a,2,2)
        H.at(a,v,0)
        -- 源0x4f04，402号。
        H.gun_sprite(a,2,17,2)
        H.at(a,v,0)
        -- 源0x4f20，406号。
        H.gun_count(a,2,6,1)
        H.at(a,v,0)
        -- 源0x4f3c，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4f58，405号。
        H.gun_speed(a,2,2.0,2.0)
        H.at(a,v,0)
        -- 源0x4f74，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4fa4，438号。
        H.gun_distance(a,2,32.0)
        H.at(a,v,0)
        -- 源0x4fbc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4fd4，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x4fe8，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x4ffc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5010，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0x5024，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5034，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5048，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x505c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5074，10号。
        return
    end
    P["BossCard2_at3"]=B.part1
end

-- stage02.ecl：BossCard2_at4，0x5094；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5094，40号。
        H.at(a,v,0)
        -- 源0x50a8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x50bc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x50d0，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x50e4，407号。
        H.gun_aim(a,2,2)
        H.at(a,v,0)
        -- 源0x50fc，402号。
        H.gun_sprite(a,2,0,10)
        H.at(a,v,0)
        -- 源0x5118，436号。
        H.gun_count_diff(a,2,16,32,32,32,1,1,1,1)
        H.at(a,v,0)
        -- 源0x514c，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5168，435号。
        H.gun_speed_diff(a,2,2.299999952316284,2.5,2.5,2.5,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0x519c，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x51cc，438号。
        H.gun_distance(a,2,32.0)
        H.at(a,v,0)
        -- 源0x51e4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x51fc，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x5210，368号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x5230，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5244，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0x5258，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5268，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x527c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5290，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x52a8，10号。
        return
    end
    P["BossCard2_at4"]=B.part1
end

-- stage02.ecl：BossCard3，0x52c8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x52c8，40号。
        H.at(a,v,0)
        -- 源0x52dc，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x52f0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x5300，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x5314，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5328，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5338，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5350，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x5364，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x537c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5390，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x53a0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x53b0，334号。
        H.interrupt(a,0,0,2580,"BossDead")
        H.at(a,v,0)
        -- 源0x53dc，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x53f0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x5404，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5418，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5428，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5440，335号。
        a.invul=90
        H.at(a,v,0)
        -- 源0x5454，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x5464，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x5478，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x548c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x549c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x54b4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x54c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x54dc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x54f0，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x5508，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x5520，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x5538，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x5548，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x555c，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x5570，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x5590，0号。
        H.at(a,v,90)
        -- 源0x55a0，324号。
        H.limit(a,0.0,128.0,280.0,192.0)
        H.at(a,v,90)
        H.at(a,v,90)
        -- 源0x55f4，359号。
        H.spell(a,24,2580,500000,"恨符「丑の刻参り七日目」",359)
        H.at(a,v,90)
        -- 源0x5630，21号。
        H.stop_threads(a)
        H.at(a,v,90)
        -- 源0x5640，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,90)
        -- 源0x5660，335号。
        a.invul=60
        H.at(a,v,90)
        -- 源0x5674，336号。
        H.sound(a,7)
        H.at(a,v,90)
        -- 源0x5688，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,90)
        -- 源0x569c，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x56b0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,90)
        -- 源0x56c0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(90);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x56d8，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,90)
        -- 源0x570c，12号。
        v.origin=H.clock(a)-(90);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0x5724，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0x575c，344号。
        a.chapter=44
        H.at(a,v,120)
        -- 源0x5770，263号。
        H.effect(a,0,131)
        H.at(a,v,210)
        -- 源0x5788，0号。
        H.at(a,v,210)
        -- 源0x5798，269号。
        H.anm_cast(a,0)
        H.at(a,v,210)
        -- 源0x57ac，12号。
        v.origin=H.clock(a)-(210);return B.part17(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,210)
        -- 源0x57c4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,210)
        -- 源0x57d8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,210)
        -- 源0x57ec，15号。
        H.async(a,P["BossCard3_at"],"BossCard3_at",nil,0,(v.l[0] or 0))
        H.at(a,v,210)
        -- 源0x5820，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,210)
        -- 源0x5834，42号。
        H.push(v,2)
        H.at(a,v,210)
        -- 源0x5848，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,210)
        -- 源0x5858，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(210);return B.part16(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,210)
        -- 源0x5870，42号。
        H.push(v,6)
        H.at(a,v,210)
        -- 源0x5884，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,210)
        -- 源0x5898，12号。
        v.origin=H.clock(a)-(210);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,210)
        -- 源0x58b0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,210)
        -- 源0x58c4，44号。
        H.push(v,0.8975980281829834)
        H.at(a,v,210)
        -- 源0x58d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,210)
        -- 源0x58e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,210)
        -- 源0x58fc，15号。
        H.async(a,P["BossCard3_at"],"BossCard3_at",nil,(v.l[4] or 0),(v.l[0] or 0))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,210)
        -- 源0x5930，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,210)
        -- 源0x5944，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(210);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,210)
        -- 源0x595c，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,210)
        -- 源0x597c，336号。
        H.sound(a,5)
        H.at(a,v,210)
        -- 源0x5990，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,210)
        -- 源0x59a4，336号。
        H.sound(a,15)
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,210)
        -- 源0x59b8，42号。
        H.push(v,1)
        H.at(a,v,210)
        -- 源0x59cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(210);return B.part12(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,210)
        -- 源0x59e4，10号。
        return
    end
    P["BossCard3"]=B.part1
end

-- stage02.ecl：BossCard3_at，0x5a04；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5a04，40号。
        H.at(a,v,0)
        -- 源0x5a18，408号。
        H.gun_sound(a,(v.l[0] or 0),15,-1)
        H.at(a,v,0)
        -- 源0x5a34，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5a48，407号。
        H.gun_aim(a,(v.l[0] or 0),3)
        H.at(a,v,0)
        -- 源0x5a60，402号。
        H.gun_sprite(a,(v.l[0] or 0),5,2)
        H.at(a,v,0)
        -- 源0x5a7c，406号。
        H.gun_count(a,(v.l[0] or 0),1,1)
        H.at(a,v,0)
        -- 源0x5a98，404号。
        H.gun_angle(a,(v.l[0] or 0),1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x5ab4，405号。
        H.gun_speed(a,(v.l[0] or 0),1.0,2.0)
        H.at(a,v,0)
        -- 源0x5ad0，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5b00，409号。
        H.gun_transform(a,(v.l[0] or 0),1,1,4,60,-999999,0.06666667014360428,-999999.0)
        H.at(a,v,0)
        -- 源0x5b30，409号。
        H.gun_transform(a,(v.l[0] or 0),2,0,256,1,15,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5b60，409号。
        H.gun_transform(a,(v.l[0] or 0),5,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5b90，409号。
        H.gun_transform(a,(v.l[0] or 0),8,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5bc0，355号。
        v.l[20]=H.int(20)
        H.at(a,v,0)
        -- 源0x5be4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x5bf8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5c0c，356号。
        v.l[16]=H.f32(1.2000000476837158)
        H.at(a,v,0)
        -- 源0x5c30，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5c48，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5c5c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5c70，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5c80，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5c98，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5cac，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x5cc0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5cd0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5ce4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5cf4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5d08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5d18，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5d2c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5d44，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5d58，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5d6c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5d7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5d94，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5da8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x5dbc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5dcc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5de0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5df0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5e04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5e14，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5e28，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5e40，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5e54，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x5e68，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5e78，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5e90，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5ea4，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x5eb8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5ec8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5edc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5eec，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5f00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5f10，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5f24，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x5f3c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5f50，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x5f64，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5f74，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5f88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5f98，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5fac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5fbc，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x5fd0，409号。
        H.gun_transform(a,(v.l[0] or 0),3,0,524288,51511304,1,(v.l[16] or 0),0.0)
        H.at(a,v,0)
        -- 源0x6000，409号。
        H.gun_transform(a,(v.l[0] or 0),4,0,1048576,1,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x6030，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x6044，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x6058，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x6068，437号。
        H.gun_polar(a,(v.l[0] or 0),H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x6084，404号。
        H.gun_angle(a,(v.l[0] or 0),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x60a0，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x60b4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x60c8，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x60dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x60ec，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6100，368号。
        v.origin=v.origin+H.int(7)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x6120，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x6134，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x614c，10号。
        return
    end
    P["BossCard3_at"]=B.part1
end

-- stage02.ecl：BossDead，0x616c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x616c，40号。
        H.at(a,v,0)
        -- 源0x6180，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x6194，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x61ac，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x61c0，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x61d8，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x61f0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x6204，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x6218，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6228，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6240，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x6278，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6290，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x62c8，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x62d8，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x62e8，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x62fc，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0x630c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0x6320，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x6334，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x6344，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x635c，330号。
        H.drop_main(a,5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x6370，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x6384，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x6398，327号。
        H.drop_extra(a,1,8)
        H.at(a,v,60)
        -- 源0x63b0，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,60)
        -- 源0x63c8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0x63e0，329号。
        H.drop(a)
        H.at(a,v,60)
        -- 源0x63f0，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0x640c，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0x6424，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0x643c，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0x6450，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0x6464，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

-- stage02.ecl：Cir00，0x6494；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6494，40号。
        H.at(a,v,0)
        -- 源0x64a8，355号。
        v.l[16]=H.int(2)
        H.at(a,v,0)
        -- 源0x64cc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x64e0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x64f8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x650c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6524，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x653c，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x6550，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6564，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6578，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6588，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6598，284号。
        H.velocity(a,0,H.read(a,v,-1),12.0)
        H.at(a,v,0)
        -- 源0x65b0，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x65d0，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x65e4，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x660c，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x6620，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6638，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,0)
        -- 源0x664c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6660，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6674，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6684，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6694，284号。
        H.velocity(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x66ac，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x66cc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x66e0，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6708，368号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x6728，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x673c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6750，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6764，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6774，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6784，284号。
        H.velocity(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x679c，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x67bc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x67d0，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x67f8，368号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6818，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x682c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6844，284号。
        H.velocity(a,0,-1.5707963705062866,6.0)
        H.at(a,v,6000)
        -- 源0x685c，0号。
        H.at(a,v,6000)
        -- 源0x686c，10号。
        return
    end
    P["Cir00"]=B.part1
end

-- stage02.ecl：Cir01，0x688c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x688c，40号。
        H.at(a,v,0)
        -- 源0x68a0，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x68b4，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x68c8，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x68dc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x68f0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6908，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x691c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6934，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x694c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x695c，327号。
        H.drop_extra(a,2,6)
        H.at(a,v,0)
        -- 源0x6974，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x698c，328号。
        H.drop_area(a,64.0,64.0)
        H.at(a,v,0)
        -- 源0x69a4，300号。
        H.ellipse(a,0,3.1415927410125732,0.05235987901687622,224.0,-1.244444489479065,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x69cc，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x69e0，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x69f8，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,0,6,2.200000047683716,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x6a38，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,1,8,1.2999999523162842,-0.04908738657832146)
        H.at(a,v,0)
        -- 源0x6a78，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x6a8c，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,0,6,2.200000047683716,-0.03272492438554764)
        H.at(a,v,0)
        -- 源0x6acc，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,1,8,1.2999999523162842,0.04908738657832146)
        H.at(a,v,0)
        -- 源0x6b0c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x6b20，323号。
        H.flags(a,12,false)
        H.at(a,v,0)
        -- 源0x6b34，300号。
        H.ellipse(a,0,3.1415927410125732,0.05235987901687622,0.0,1.244444489479065,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x6b5c，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x6b70，1号。
        H.erase(a);return
    end
    P["Cir01"]=B.part1
end

-- stage02.ecl：Cir01B，0x6bb0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6bb0，40号。
        H.at(a,v,0)
        -- 源0x6bc4，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x6bd8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6bec，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x6c00，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6c14，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6c2c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6c40，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6c58，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6c70，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6c80，327号。
        H.drop_extra(a,2,6)
        H.at(a,v,0)
        -- 源0x6c98，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x6cb0，328号。
        H.drop_area(a,64.0,64.0)
        H.at(a,v,0)
        -- 源0x6cc8，300号。
        H.ellipse(a,0,0.0,-0.05235987901687622,224.0,-1.244444489479065,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x6cf0，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x6d04，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x6d1c，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,0,10,2.200000047683716,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x6d5c，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,1,11,1.2999999523162842,-0.04908738657832146)
        H.at(a,v,0)
        -- 源0x6d9c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x6db0，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,0,10,2.200000047683716,-0.03272492438554764)
        H.at(a,v,0)
        -- 源0x6df0，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil,1,11,1.2999999523162842,0.04908738657832146)
        H.at(a,v,0)
        -- 源0x6e30，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x6e44，323号。
        H.flags(a,12,false)
        H.at(a,v,0)
        -- 源0x6e58，300号。
        H.ellipse(a,0,0.0,-0.05235987901687622,0.0,1.244444489479065,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x6e80，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x6e94，1号。
        H.erase(a);return
    end
    P["Cir01B"]=B.part1
end

-- stage02.ecl：Cir02，0x6ed4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6ed4，40号。
        H.at(a,v,0)
        -- 源0x6ee8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x6efc，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6f10，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x6f24，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6f38，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6f50，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6f64，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6f7c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6f94，15号。
        H.async(a,P["RCir02_at"],"RCir02_at",nil)
        H.at(a,v,0)
        -- 源0x6fb4，300号。
        H.ellipse(a,0,3.1415927410125732,0.10471975803375244,224.0,-2.48888897895813,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x6fdc，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x6ff0，300号。
        H.ellipse(a,0,3.1415927410125732,0.10471975803375244,0.0,2.48888897895813,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x7018，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x702c，1号。
        H.erase(a);return
    end
    P["Cir02"]=B.part1
end

-- stage02.ecl：Cir02B，0x705c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x705c，40号。
        H.at(a,v,0)
        -- 源0x7070，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x7084，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7098，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x70ac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x70c0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x70d8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x70ec，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7104，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x711c，15号。
        H.async(a,P["RCir02_at"],"RCir02_at",nil)
        H.at(a,v,0)
        -- 源0x713c，300号。
        H.ellipse(a,0,0.0,-0.10471975803375244,224.0,-2.48888897895813,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x7164，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x7178，300号。
        H.ellipse(a,0,0.0,-0.10471975803375244,0.0,2.48888897895813,1.5707963705062866,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x71a0，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x71b4，1号。
        H.erase(a);return
    end
    P["Cir02B"]=B.part1
end

-- stage02.ecl：GCir00，0x71e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x71e4，40号。
        H.at(a,v,0)
        -- 源0x71f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x720c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7220，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7238，11号。
        H.call(a,v,P["Cir00"],"Cir00",72,1)
        H.at(a,v,0)
        -- 源0x7264，1号。
        H.erase(a);return
    end
    P["GCir00"]=B.part1
end

-- stage02.ecl：GCir01，0x7284；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7284，40号。
        H.at(a,v,0)
        -- 源0x7298，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x72ac，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x72c0，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x72d8，11号。
        H.call(a,v,P["Cir01"],"Cir01",72,1)
        H.at(a,v,0)
        -- 源0x7304，1号。
        H.erase(a);return
    end
    P["GCir01"]=B.part1
end

-- stage02.ecl：GCir01B，0x7324；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7324，40号。
        H.at(a,v,0)
        -- 源0x7338，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x734c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7360，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7378，11号。
        H.call(a,v,P["Cir01B"],"Cir01B",72,1)
        H.at(a,v,0)
        -- 源0x73a4，1号。
        H.erase(a);return
    end
    P["GCir01B"]=B.part1
end

-- stage02.ecl：GCir02，0x73c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x73c4，40号。
        H.at(a,v,0)
        -- 源0x73d8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x73ec，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7400，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7418，11号。
        H.call(a,v,P["Cir02"],"Cir02",72,1)
        H.at(a,v,0)
        -- 源0x7444，1号。
        H.erase(a);return
    end
    P["GCir02"]=B.part1
end

-- stage02.ecl：GCir02B，0x7464；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7464，40号。
        H.at(a,v,0)
        -- 源0x7478，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x748c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x74a0，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x74b8，11号。
        H.call(a,v,P["Cir02B"],"Cir02B",72,1)
        H.at(a,v,0)
        -- 源0x74e4，1号。
        H.erase(a);return
    end
    P["GCir02B"]=B.part1
end

-- stage02.ecl：GGirl00，0x7504；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7504，40号。
        H.at(a,v,0)
        -- 源0x7518，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x752c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7540，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7558，11号。
        H.call(a,v,P["Girl00"],"Girl00",10,1)
        H.at(a,v,0)
        -- 源0x7584，1号。
        H.erase(a);return
    end
    P["GGirl00"]=B.part1
end

-- stage02.ecl：GGirl01，0x75a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x75a4，40号。
        H.at(a,v,0)
        -- 源0x75b8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x75cc，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x75e0，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x75f8，11号。
        H.call(a,v,P["Girl01"],"Girl01",10,1)
        H.at(a,v,0)
        -- 源0x7624，1号。
        H.erase(a);return
    end
    P["GGirl01"]=B.part1
end

-- stage02.ecl：GGirl01B，0x7644；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7644，40号。
        H.at(a,v,0)
        -- 源0x7658，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x766c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7680，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7698，11号。
        H.call(a,v,P["Girl01B"],"Girl01B",10,1)
        H.at(a,v,0)
        -- 源0x76c4，1号。
        H.erase(a);return
    end
    P["GGirl01B"]=B.part1
end

-- stage02.ecl：GGirl02，0x76e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x76e4，40号。
        H.at(a,v,0)
        -- 源0x76f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x770c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x7720，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x7738，11号。
        H.call(a,v,P["Girl02"],"Girl02",10,1)
        H.at(a,v,0)
        -- 源0x7764，1号。
        H.erase(a);return
    end
    P["GGirl02"]=B.part1
end

-- stage02.ecl：GGirl03，0x7784；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7784，40号。
        H.at(a,v,0)
        -- 源0x7798，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x77ac，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x77c0，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x77d8，11号。
        H.call(a,v,P["Girl03"],"Girl03",10,1)
        H.at(a,v,0)
        -- 源0x7804，1号。
        H.erase(a);return
    end
    P["GGirl03"]=B.part1
end

-- stage02.ecl：Girl00，0x7824；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7824，40号。
        H.at(a,v,0)
        -- 源0x7838，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x784c，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7864，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7878，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7890，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x78a8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x78bc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x78d0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x78e0，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x7900，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7914，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x7928，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x793c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x794c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x795c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7970，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7984，44号。
        H.push(v,128.0)
        H.at(a,v,0)
        -- 源0x7998，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x79a8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x79c0，44号。
        H.push(v,128.0)
        H.at(a,v,0)
        -- 源0x79d4，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x79e8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x79fc，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x7a10，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7a20，305号。
        H.bezier(a,0,90,0.0,512.0,H.read(a,v,-1),(v.l[12] or 0),0.0,0.0)
        H.at(a,v,90)
        -- 源0x7a4c，15号。
        H.async(a,P["RGirl00_at"],"RGirl00_at",nil,1)
        H.at(a,v,90)
        -- 源0x7a74，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,90)
        -- 源0x7a88，284号。
        H.velocity(a,0,H.read(a,v,-9989),0.0)
        H.at(a,v,90)
        -- 源0x7aa0，285号。
        H.velocity_time(a,0,60,0,-999999.0,4.0)
        H.at(a,v,6090)
        -- 源0x7ac0，0号。
        H.at(a,v,6090)
        -- 源0x7ad0，10号。
        return
    end
    P["Girl00"]=B.part1
end

-- stage02.ecl：Girl01，0x7af0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7af0，40号。
        H.at(a,v,0)
        -- 源0x7b04，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7b18，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7b30，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7b44，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7b5c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7b74，284号。
        H.velocity(a,0,-0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7b8c，285号。
        H.velocity_time(a,0,60,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7bac，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7bc0，15号。
        H.async(a,P["RGirl01_at"],"RGirl01_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7be8，285号。
        H.velocity_time(a,0,60,0,0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7c08，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x7c1c，0号。
        H.at(a,v,6000)
        -- 源0x7c2c，10号。
        return
    end
    P["Girl01"]=B.part1
end

-- stage02.ecl：Girl01B，0x7c4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7c4c，40号。
        H.at(a,v,0)
        -- 源0x7c60，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7c74，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7c8c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7ca0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7cb8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7cd0，284号。
        H.velocity(a,0,-0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7ce8，285号。
        H.velocity_time(a,0,60,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7d08，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7d1c，285号。
        H.velocity_time(a,0,60,0,0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7d3c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x7d50，0号。
        H.at(a,v,6000)
        -- 源0x7d60，10号。
        return
    end
    P["Girl01B"]=B.part1
end

-- stage02.ecl：Girl02，0x7d80；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7d80，40号。
        H.at(a,v,0)
        -- 源0x7d94，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7da8，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7dc0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7dd4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7dec，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7e04，284号。
        H.velocity(a,0,-0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7e1c，285号。
        H.velocity_time(a,0,60,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7e3c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7e50，15号。
        H.async(a,P["RGirl02_at"],"RGirl02_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7e78，285号。
        H.velocity_time(a,0,60,0,0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7e98，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x7eac，0号。
        H.at(a,v,6000)
        -- 源0x7ebc，10号。
        return
    end
    P["Girl02"]=B.part1
end

-- stage02.ecl：Girl03，0x7edc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7edc，40号。
        H.at(a,v,0)
        -- 源0x7ef0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7f04，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7f1c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7f30，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7f48，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7f60，284号。
        H.velocity(a,0,-0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7f78，285号。
        H.velocity_time(a,0,60,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7f98，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7fac，15号。
        H.async(a,P["RGirl03_at"],"RGirl03_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7fd4，285号。
        H.velocity_time(a,0,60,0,0.39269909262657166,6.0)
        H.at(a,v,0)
        -- 源0x7ff4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x8008，0号。
        H.at(a,v,6000)
        -- 源0x8018，10号。
        return
    end
    P["Girl03"]=B.part1
end

-- stage02.ecl：MBoss，0x8038；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8038，40号。
        H.at(a,v,0)
        -- 源0x804c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8060，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8074，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8088，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x809c，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x80b0，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x80c4，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x80dc，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x80f0，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0x8108，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x811c，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x8134，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x814c，331号。
        H.life(a,7600)
        H.at(a,v,0)
        -- 源0x8160，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x8170，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,0)
        -- 源0x8184，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8198，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x81ac，334号。
        H.interrupt(a,0,1000,1800,"MBossCard1")
        H.at(a,v,0)
        -- 源0x81d8，341号。
        H.timeout(a,0,"MBossEscape")
        H.at(a,v,0)
        -- 源0x81fc，347号。
        H.life_marker(a,0,1000.0,-24448)
        H.at(a,v,0)
        -- 源0x8218，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x822c，440号。
        H.fog(a,160.0,16744703)
        H.at(a,v,0)
        -- 源0x8244，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x825c，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0x827c，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0x8290，11号。
        H.call(a,v,P["MBoss_at1"],"MBoss_at1")
        H.at(a,v,0)
        -- 源0x82b0，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x82c4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x82d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x82f0，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8308，83号。
        v.origin=v.origin+H.int(1000)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x831c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8330，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8348，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage02.ecl：MBossCard1，0x8368；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8368，40号。
        H.at(a,v,0)
        -- 源0x837c，334号。
        H.interrupt(a,0,0,2040,"MBossEscape")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x83ec，359号。
        H.spell(a,12,2040,500000,"嫉妬「緑色の眼をした見えない怪物」",359)
        H.at(a,v,0)
        -- 源0x8430，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x8444，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8458，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x846c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x847c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8494，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x84a8，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x84b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x84cc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x84e0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x8510，281号。
        H.position_time(a,0,60,4,128.0,224.0)
        H.at(a,v,0)
        -- 源0x8530，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x8544，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x8558，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x858c，324号。
        H.limit(a,0.0,128.0,280.0,256.0)
        H.at(a,v,60)
        -- 源0x85ac，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x85c4，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x85d8，0号。
        H.at(a,v,150)
        -- 源0x85e8，322号。
        H.flags(a,2,true)
        H.at(a,v,150)
        -- 源0x85fc，256号。
        H.spawn(a,256,"MBossCard1At",0.0,0.0,100,10,0)
        H.at(a,v,150)
        -- 源0x8634，83号。
        v.origin=v.origin+H.int(440)
        H.at(a,v,150)
        -- 源0x8648，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,150)
        -- 源0x8660，322号。
        H.flags(a,1,true)
        H.at(a,v,150)
        -- 源0x8674，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x8688，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        H.at(a,v,150)
        -- 源0x86b4，280号。
        H.position(a,0,-128.0,224.0)
        H.at(a,v,150)
        -- 源0x86cc，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        -- 源0x86e0，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x86f4，256号。
        H.spawn(a,256,"MBossCard1At2",0.0,0.0,100,10,0)
        H.at(a,v,150)
        -- 源0x872c，83号。
        v.origin=v.origin+H.int(440)
        H.at(a,v,150)
        -- 源0x8740，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,150)
        -- 源0x8758，322号。
        H.flags(a,1,true)
        H.at(a,v,150)
        -- 源0x876c，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x8780，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        H.at(a,v,150)
        -- 源0x87ac，280号。
        H.position(a,0,128.0,224.0)
        H.at(a,v,150)
        -- 源0x87c4，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        -- 源0x87d8，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x87ec，256号。
        H.spawn(a,256,"MBossCard1At3",0.0,0.0,100,10,0)
        H.at(a,v,150)
        -- 源0x8824，83号。
        v.origin=v.origin+H.int(440)
        H.at(a,v,150)
        -- 源0x8838，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,150)
        -- 源0x8850，322号。
        H.flags(a,1,true)
        H.at(a,v,150)
        -- 源0x8864，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x8878，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        H.at(a,v,150)
        -- 源0x88a4，280号。
        H.position(a,0,-128.0,224.0)
        H.at(a,v,150)
        -- 源0x88bc，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,150)
        -- 源0x88d0，323号。
        H.flags(a,1,false)
        H.at(a,v,150)
        -- 源0x88e4，256号。
        H.spawn(a,256,"MBossCard1At4",0.0,0.0,100,10,0)
        H.at(a,v,150)
        -- 源0x891c，12号。
        v.origin=H.clock(a)-(150);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x8934，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x8948，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x895c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x8974，10号。
        return
    end
    P["MBossCard1"]=B.part1
end

-- stage02.ecl：MBossCard1At，0x8994；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8994，40号。
        H.at(a,v,0)
        -- 源0x89a8，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x89bc，15号。
        H.async(a,P["MBossCard1At_at"],"MBossCard1At_at",nil)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x89f8，280号。
        H.position(a,0,192.0,64.0)
        H.at(a,v,0)
        -- 源0x8a10，305号。
        H.bezier(a,0,20,0.0,0.0,-64.0,100.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8a3c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8a50，305号。
        H.bezier(a,0,20,256.0,0.0,-160.0,200.0,-256.0,0.0)
        H.at(a,v,0)
        -- 源0x8a7c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8a90，305号。
        H.bezier(a,0,20,-256.0,0.0,-64.0,300.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8abc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8ad0，305号。
        H.bezier(a,0,20,256.0,0.0,-128.0,400.0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8afc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8b10，324号。
        H.limit(a,0.0,224.0,384.0,448.0)
        H.at(a,v,0)
        -- 源0x8b30，42号。
        H.push(v,9)
        H.at(a,v,0)
        -- 源0x8b44，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8b58，356号。
        v.l[8]=H.f32(3.5999999046325684)
        H.at(a,v,0)
        -- 源0x8b7c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8b94，284号。
        H.velocity(a,0,H.read(a,v,-9989),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8bac，368号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8bcc，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x8be0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8bf8，1号。
        H.erase(a);return
    end
    P["MBossCard1At"]=B.part1
end

-- stage02.ecl：MBossCard1At2，0x8c28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8c28，40号。
        H.at(a,v,0)
        -- 源0x8c3c，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x8c50，15号。
        H.async(a,P["MBossCard1At_at"],"MBossCard1At_at",nil)
        H.at(a,v,0)
        -- 源0x8c74，280号。
        H.position(a,0,160.0,32.0)
        H.at(a,v,0)
        -- 源0x8c8c，305号。
        H.bezier(a,0,20,0.0,0.0,160.0,100.0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8cb8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8ccc，305号。
        H.bezier(a,0,20,0.0,0.0,140.0,160.0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8cf8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8d0c，305号。
        H.bezier(a,0,20,0.0,0.0,160.0,224.0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8d38，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8d4c，324号。
        H.limit(a,0.0,224.0,384.0,448.0)
        H.at(a,v,0)
        -- 源0x8d6c，355号。
        v.l[4]=H.int(12)
        H.at(a,v,0)
        -- 源0x8d90，356号。
        v.l[8]=H.f32(4.300000190734863)
        H.at(a,v,0)
        -- 源0x8db4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8dcc，284号。
        H.velocity(a,0,H.read(a,v,-9989),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8de4，368号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8e04，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x8e18，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8e30，1号。
        H.erase(a);return
    end
    P["MBossCard1At2"]=B.part1
end

-- stage02.ecl：MBossCard1At3，0x8e60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8e60，40号。
        H.at(a,v,0)
        -- 源0x8e74，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x8e88，15号。
        H.async(a,P["MBossCard1At_at"],"MBossCard1At_at",nil)
        H.at(a,v,0)
        -- 源0x8eac，280号。
        H.position(a,0,-224.0,32.0)
        H.at(a,v,0)
        -- 源0x8ec4，305号。
        H.bezier(a,0,20,0.0,0.0,-160.0,64.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8ef0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8f04，305号。
        H.bezier(a,0,20,0.0,0.0,-160.0,440.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8f30，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x8f44，305号。
        H.bezier(a,0,10,0.0,0.0,0.0,32.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8f70，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x8f84，305号。
        H.bezier(a,0,10,0.0,0.0,192.0,32.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x8fb0，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x8fc4，324号。
        H.limit(a,0.0,224.0,384.0,448.0)
        H.at(a,v,0)
        -- 源0x8fe4，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0x9008，356号。
        v.l[8]=H.f32(5.0)
        H.at(a,v,0)
        -- 源0x902c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9044，284号。
        H.velocity(a,0,H.read(a,v,-9989),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x905c，368号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x907c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x9090，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x90a8，1号。
        H.erase(a);return
    end
    P["MBossCard1At3"]=B.part1
end

-- stage02.ecl：MBossCard1At4，0x90d8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x90d8，40号。
        H.at(a,v,0)
        -- 源0x90ec，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x9100，15号。
        H.async(a,P["MBossCard1At_at"],"MBossCard1At_at",nil)
        H.at(a,v,0)
        -- 源0x9124，280号。
        H.position(a,0,224.0,32.0)
        H.at(a,v,0)
        -- 源0x913c，305号。
        H.bezier(a,0,20,0.0,0.0,160.0,64.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x9168，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x917c，305号。
        H.bezier(a,0,20,0.0,0.0,160.0,440.0,256.0,0.0)
        H.at(a,v,0)
        -- 源0x91a8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x91bc，324号。
        H.limit(a,0.0,224.0,384.0,448.0)
        H.at(a,v,0)
        -- 源0x91dc，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0x9200，356号。
        v.l[8]=H.f32(5.5)
        H.at(a,v,0)
        -- 源0x9224，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x923c，284号。
        H.velocity(a,0,H.read(a,v,-9989),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x9254，368号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9274，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x9288，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x92a0，1号。
        H.erase(a);return
    end
    P["MBossCard1At4"]=B.part1
end

-- stage02.ecl：MBossCard1At_at，0x92d0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x92d0，40号。
        H.at(a,v,0)
        -- 源0x92e4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x92f8，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x9310，402号。
        H.gun_sprite(a,0,2,10)
        H.at(a,v,0)
        -- 源0x932c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x9348，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x9364，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x9380，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x93b0，409号。
        H.gun_transform(a,0,2,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x93e0，42号。
        H.push(v,440)
        H.at(a,v,0)
        -- 源0x93f4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9408，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x941c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9430，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9448，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[0] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9478，402号。
        H.gun_sprite(a,0,2,10)
        H.at(a,v,0)
        -- 源0x9494，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x94a8，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x94bc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x94cc，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x94e8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x94fc，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9510，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9524，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x9534，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9548，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x955c，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[0] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x958c，402号。
        H.gun_sprite(a,0,12,5)
        H.at(a,v,0)
        -- 源0x95a8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x95bc，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x95d0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x95e0，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x95fc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9610，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9624，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9638，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x9648，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x965c，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9670，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x9684，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x969c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x96b4，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[0] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x96e4，402号。
        H.gun_sprite(a,0,2,10)
        H.at(a,v,0)
        -- 源0x9700，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x9714，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x9728，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9738，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x9754，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9768，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x977c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x9790，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x97a0，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x97b4，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x97c8，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[0] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x97f8，402号。
        H.gun_sprite(a,0,12,5)
        H.at(a,v,0)
        -- 源0x9814，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x9828，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x983c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x984c，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x9868，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x987c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9890，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x98a4，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x98b4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x98c8，83号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x98dc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x98f0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9908，10号。
        return
    end
    P["MBossCard1At_at"]=B.part1
end

-- stage02.ecl：MBossDead，0x9928；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9928，40号。
        H.at(a,v,0)
        -- 源0x993c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x9950，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x9960，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x9974，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9988，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9998，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x99b0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x99c4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x99d8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x99e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9a00，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x9a34，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9a4c，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9a84，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9a9c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9ab0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9ac4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9ad4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9aec，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x9b00，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x9b18，421号。
        H.cancel(a,640.0,false)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x9b2c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x9b3c，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0x9b54，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x9b6c，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x9b7c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x9b90，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9ba4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9bb4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x9bcc，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x9be0，329号。
        H.drop(a)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x9bf0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9c04，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9c18，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x9c2c，337号。
        H.shake(a,30,12,0)
        H.at(a,v,0)
        -- 源0x9c48，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x9c60，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x9c74，344号。
        a.chapter=0
        H.at(a,v,0)
        -- 源0x9c88，1号。
        H.erase(a);return
    end
    P["MBossDead"]=B.part1
end

-- stage02.ecl：MBossEscape，0x9cb8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9cb8，40号。
        H.at(a,v,0)
        -- 源0x9ccc，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0x9cf0，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0x9d14，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x9d24，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x9d34，440号。
        H.fog(a,0.0,16744703)
        H.at(a,v,0)
        -- 源0x9d4c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x9d5c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9d70，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9d84，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9d94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9dac，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x9dc0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9dd8，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9dec，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9e00，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9e14，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9e24，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9e3c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x9e4c，327号。
        H.drop_extra(a,4,1)
        H.at(a,v,0)
        -- 源0x9e64，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x9e78，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9e8c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9e9c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9eb4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9ec8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9edc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9ef0，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x9f08，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0x9f20，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x9f38，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x9f48，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x9f5c，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x9f70，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x9f84，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x9f98，281号。
        H.position_time(a,0,60,4,-32.0,-32.0)
        H.at(a,v,60)
        -- 源0x9fb8，344号。
        a.chapter=0
        H.at(a,v,60)
        -- 源0x9fcc，1号。
        H.erase(a);return
    end
    P["MBossEscape"]=B.part1
end

-- stage02.ecl：MBoss_at1，0x9ffc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9ffc，40号。
        H.at(a,v,0)
        -- 源0xa010，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xa024，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xa03c，402号。
        H.gun_sprite(a,0,7,6)
        H.at(a,v,0)
        -- 源0xa058，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xa074，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xa090，405号。
        H.gun_speed(a,0,2.0,1.0)
        H.at(a,v,0)
        -- 源0xa0ac，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa0dc，438号。
        H.gun_distance(a,0,64.0)
        H.at(a,v,0)
        -- 源0xa0f4，409号。
        H.gun_transform(a,0,1,0,32,60,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0xa124，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xa140，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xa154，436号。
        H.gun_count_diff(a,0,1,1,1,2,1,1,2,1)
        H.at(a,v,0)
        -- 源0xa188，435号。
        H.gun_speed_diff(a,0,2.0,2.0,3.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xa1bc，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xa1d0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa1e4，44号。
        H.push(v,1.5)
        H.at(a,v,0)
        -- 源0xa1f8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa20c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xa220，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa234，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa24c，44号。
        H.push(v,-3.1415929794311523)
        H.at(a,v,0)
        -- 源0xa260，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa274，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0xa288，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa29c，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa2b4，409号。
        H.gun_transform(a,0,2,0,16,1,1,(v.l[0] or 0),1.600000023841858)
        H.at(a,v,0)
        -- 源0xa2e4，409号。
        H.gun_transform(a,0,3,0,16,60,1,(v.l[4] or 0),0.800000011920929)
        H.at(a,v,0)
        -- 源0xa314，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xa330，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xa344，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xa358，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa36c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa37c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa394，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xa3a8，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0xa3bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa3cc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa3e0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa3f4，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0xa408，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa418，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa42c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa444，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xa458，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0xa46c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa47c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa490，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa4a4，44号。
        H.push(v,0.06544999778270721)
        H.at(a,v,0)
        -- 源0xa4b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa4c8，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xa4dc，368号。
        v.origin=v.origin+H.int(1)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xa4fc，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0xa510，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xa528，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa53c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xa554，10号。
        return
    end
    P["MBoss_at1"]=B.part1
end

-- stage02.ecl：MBoss_at2，0xa574；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa574，40号。
        H.at(a,v,0)
        -- 源0xa588，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xa59c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xa5b4，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0xa5d0，406号。
        H.gun_count(a,0,8,1)
        H.at(a,v,0)
        -- 源0xa5ec，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xa608，405号。
        H.gun_speed(a,0,0.800000011920929,1.0)
        H.at(a,v,0)
        -- 源0xa624，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa654，438号。
        H.gun_distance(a,0,24.0)
        H.at(a,v,0)
        -- 源0xa66c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xa680，10号。
        return
    end
    P["MBoss_at2"]=B.part1
end

-- stage02.ecl：MainBossDebug，0xa6a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa6a0，40号。
        H.at(a,v,120)
        -- 源0xa6b4，338号。
        H.dialog(a,0)
        H.at(a,v,120)
        -- 源0xa6c8，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0xa6dc，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0xa6ec，257号。
        H.spawn(a,257,"Boss",-144.0,-16.0,40,1000,1)
        H.at(a,v,120)
        -- 源0xa71c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0xa72c，340号。
        H.boss_wait(a,v)
        H.at(a,v,180)
        -- 源0xa73c，338号。
        H.dialog(a,1)
        H.at(a,v,180)
        -- 源0xa750，339号。
        H.dialog_wait(a,v)
        H.at(a,v,180)
        -- 源0xa760，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage02.ecl：MainMBossDebug，0xa790；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa790，40号。
        H.at(a,v,0)
        -- 源0xa7a4，257号。
        H.spawn(a,257,"MBoss",128.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0xa7d4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa7ec，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa800，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa814，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa82c，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage02.ecl：MainMsgDebug，0xa84c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa84c，40号。
        H.at(a,v,0)
        -- 源0xa860，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0xa874，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0xa888，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0xa898，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0xa8a8，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0xa8bc，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0xa8cc，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0xa8e4，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0xa8f4，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0xa908，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0xa920，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage02.ecl：MainSub00，0xa940；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa940，40号。
        H.at(a,v,0)
        -- 源0xa954，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0xa968，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xa97c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xa990，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xa9a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa9b0，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa9e0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa9f4，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0xaa08，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xaa1c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xaa30，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xaa40，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaa50，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xaa80，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xaa94，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xaaa8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xaabc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xaad0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xaae0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaaf0，257号。
        H.spawn(a,257,"BGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xab20，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xab34，42号。
        H.push(v,-128)
        H.at(a,v,0)
        -- 源0xab48，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xab5c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xab70，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xab80，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xab90，257号。
        H.spawn(a,257,"BGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xabc0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xabd4，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0xabe8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xabfc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xac10，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xac20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xac30，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xac60，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xac74，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0xac88，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xac9c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xacb0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xacc0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xacd0，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xad00，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xad14，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0xad28，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xad3c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xad50，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xad60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xad70，257号。
        H.spawn(a,257,"BGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xada0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xadb4，42号。
        H.push(v,-96)
        H.at(a,v,0)
        -- 源0xadc8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xaddc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xadf0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xae00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xae10，257号。
        H.spawn(a,257,"BGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xae40，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xae54，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xae68，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xae7c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xae90，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xaea0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaeb0，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xaee0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xaef4，42号。
        H.push(v,-128)
        H.at(a,v,0)
        -- 源0xaf08，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xaf1c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xaf30，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xaf40，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaf50，257号。
        H.spawn(a,257,"RGirl00",H.read(a,v,-1),-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xaf80，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xaf94，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage02.ecl：MainSub01，0xafb4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xafb4，40号。
        H.at(a,v,0)
        -- 源0xafc8，83号。
        v.origin=v.origin+H.int(260)
        H.at(a,v,0)
        -- 源0xafdc，257号。
        H.spawn(a,257,"RGirl02",-224.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb00c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb020，257号。
        H.spawn(a,257,"RGirl02",-240.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb050，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb064，257号。
        H.spawn(a,257,"RGirl02",-256.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb094，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb0a8，257号。
        H.spawn(a,257,"RGirl02",-272.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb0d8，261号。
        H.spawn(a,261,"BGirl01",224.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb108，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb11c，261号。
        H.spawn(a,261,"BGirl01",240.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb14c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb160，261号。
        H.spawn(a,261,"BGirl01",256.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb190，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb1a4，261号。
        H.spawn(a,261,"BGirl01",272.0,192.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb1d4，257号。
        H.spawn(a,257,"RGirl01",-224.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb204，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb218，257号。
        H.spawn(a,257,"RGirl01",-240.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb248，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb25c，257号。
        H.spawn(a,257,"RGirl01",-256.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb28c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb2a0，257号。
        H.spawn(a,257,"RGirl01",-272.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb2d0，261号。
        H.spawn(a,261,"BGirl02",224.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb300，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb314，261号。
        H.spawn(a,261,"BGirl02",240.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb344，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb358，261号。
        H.spawn(a,261,"BGirl02",256.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb388，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb39c，261号。
        H.spawn(a,261,"BGirl02",272.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb3cc，257号。
        H.spawn(a,257,"RGirl01",-224.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb3fc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb410，257号。
        H.spawn(a,257,"RGirl02",-240.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb440，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb454，257号。
        H.spawn(a,257,"RGirl01",-256.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb484，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb498，257号。
        H.spawn(a,257,"RGirl02",-272.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb4c8，261号。
        H.spawn(a,261,"RGirl02",224.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb4f8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb50c，261号。
        H.spawn(a,261,"RGirl01",240.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb53c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb550，261号。
        H.spawn(a,261,"RGirl02",256.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb580，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb594，261号。
        H.spawn(a,261,"RGirl01",272.0,224.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb5c4，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage02.ecl：MainSub03，0xb5e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb5e4，40号。
        H.at(a,v,0)
        -- 源0xb5f8，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,0)
        -- 源0xb60c，257号。
        H.spawn(a,257,"BCir00",0.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb63c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb650，257号。
        H.spawn(a,257,"BCir00",128.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb680，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb694，257号。
        H.spawn(a,257,"BCir00",-128.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb6c4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb6d8，257号。
        H.spawn(a,257,"BCir00",64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb708，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb71c，257号。
        H.spawn(a,257,"BCir00",-128.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb74c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb760，257号。
        H.spawn(a,257,"BCir00",-64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xb790，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage02.ecl：MainSub04，0xb7b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb7b0，40号。
        H.at(a,v,0)
        -- 源0xb7c4，257号。
        H.spawn(a,257,"PCir01",0.0,160.0,1800,1000,2)
        H.at(a,v,0)
        -- 源0xb7f4，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,0)
        -- 源0xb808，257号。
        H.spawn(a,257,"PCir01B",-32.0,176.0,1200,1000,2)
        H.at(a,v,0)
        -- 源0xb838，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,0)
        -- 源0xb84c，257号。
        H.spawn(a,257,"PCir01",32.0,192.0,1200,1000,2)
        H.at(a,v,0)
        -- 源0xb87c，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage02.ecl：MainSub05，0xb89c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb89c，40号。
        H.at(a,v,0)
        -- 源0xb8b0，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xb8c4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xb8d8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb8f0，266号。
        H.spawn(a,266,"GGirl03",-224.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb920，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb934，266号。
        H.spawn(a,266,"GGirl03",-240.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb964，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb978，266号。
        H.spawn(a,266,"GGirl03",-256.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb9a8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb9bc，266号。
        H.spawn(a,266,"GGirl03",-272.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xb9ec，268号。
        H.spawn(a,268,"BGirl03",224.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xba1c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xba30，268号。
        H.spawn(a,268,"BGirl03",240.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xba60，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xba74，268号。
        H.spawn(a,268,"BGirl03",256.0,96.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xbaa4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbab8，268号。
        H.spawn(a,268,"BGirl03",272.0,96.0,100,1000,2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xbae8，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xbafc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbb14，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage02.ecl：MainSub06，0xbb34；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbb34，40号。
        H.at(a,v,0)
        -- 源0xbb48，266号。
        H.spawn(a,266,"BCir02",0.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xbb78，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbb8c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xbba0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbbb4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbbc8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbbd8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbbe8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbbfc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbc10，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbc20，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xbc50，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbc64，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xbc78，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbc8c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbca0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbcb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbcc0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbcd4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbce8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbcf8，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xbd28，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbd3c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xbd50，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbd64，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbd78，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbd88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbd98，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbdac，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbdc0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbdd0，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xbe00，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbe14，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xbe28，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbe3c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbe50，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbe60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbe70，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbe84，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbe98，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbea8，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xbed8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xbeec，266号。
        H.spawn(a,266,"BCir02B",0.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xbf1c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbf30，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xbf44，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbf58，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbf6c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbf7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbf8c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbfa0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbfb4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbfc4，266号。
        H.spawn(a,266,"RCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xbff4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc008，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc01c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc030，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc044，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc054，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc064，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc078，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc08c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc09c，266号。
        H.spawn(a,266,"BCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc0cc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc0e0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc0f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc108，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc11c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc12c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc13c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc150，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc164，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc174，266号。
        H.spawn(a,266,"RCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc1a4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc1b8，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc1cc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc1e0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc1f4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc204，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc214，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc228，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc23c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc24c，266号。
        H.spawn(a,266,"BCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc27c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xc290，266号。
        H.spawn(a,266,"BCir02",0.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xc2c0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc2d4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc2e8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc2fc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc310，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc320，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc330，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc344，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc358，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc368，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc398，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc3ac，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc3c0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc3d4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc3e8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc3f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc408，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc41c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc430，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc440，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc470，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc484，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc498，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc4ac，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc4c0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc4d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc4e0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc4f4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc508，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc518，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc548，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc55c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc570，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc584，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc598，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc5a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc5b8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc5cc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc5e0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc5f0，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc620，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc634，266号。
        H.spawn(a,266,"BCir02B",0.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xc664，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc678，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc68c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc6a0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc6b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc6c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc6d4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc6e8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc6fc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc70c，266号。
        H.spawn(a,266,"RCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc73c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc750，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc764，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc778，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc78c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc79c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc7ac，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc7c0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc7d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc7e4，266号。
        H.spawn(a,266,"BCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc814，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc828，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc83c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc850，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc864，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc874，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc884，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc898，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc8ac，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc8bc，266号。
        H.spawn(a,266,"RCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc8ec，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc900，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc914，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc928，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc93c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc94c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc95c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc970，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc984，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc994，266号。
        H.spawn(a,266,"BCir02B",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xc9c4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc9d8，266号。
        H.spawn(a,266,"BCir02",0.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xca08，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xca1c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xca30，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xca44，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xca58，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xca68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xca78，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xca8c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcaa0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcab0，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xcae0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xcaf4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xcb08，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcb1c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcb30，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcb40，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcb50，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcb64，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcb78，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcb88，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xcbb8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xcbcc，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xcbe0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcbf4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcc08，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcc18，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcc28，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcc3c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcc50，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcc60，266号。
        H.spawn(a,266,"RCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xcc90，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xcca4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xccb8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcccc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcce0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xccf0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcd00，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xcd14，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcd28，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xcd38，266号。
        H.spawn(a,266,"BCir02",H.read(a,v,-1),H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0xcd68，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xcd7c，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage02.ecl：MapleEnemy，0xcd9c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcd9c，40号。
        H.at(a,v,0)
        -- 源0xcdb0，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xcdc4，264号。
        H.effect_abs(a,0,171)
        H.at(a,v,3)
        -- 源0xcddc，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0xcdf4，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage02.ecl：PCir00，0xce14；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xce14，40号。
        H.at(a,v,0)
        -- 源0xce28，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xce3c，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xce54，11号。
        H.call(a,v,P["Cir00"],"Cir00",78,1)
        H.at(a,v,0)
        -- 源0xce80，1号。
        H.erase(a);return
    end
    P["PCir00"]=B.part1
end

-- stage02.ecl：PCir01，0xcea0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcea0，40号。
        H.at(a,v,0)
        -- 源0xceb4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xcec8，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xcee0，11号。
        H.call(a,v,P["Cir01"],"Cir01",78,1)
        H.at(a,v,0)
        -- 源0xcf0c，1号。
        H.erase(a);return
    end
    P["PCir01"]=B.part1
end

-- stage02.ecl：PCir01B，0xcf2c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcf2c，40号。
        H.at(a,v,0)
        -- 源0xcf40，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xcf54，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xcf6c，11号。
        H.call(a,v,P["Cir01B"],"Cir01B",78,1)
        H.at(a,v,0)
        -- 源0xcf98，1号。
        H.erase(a);return
    end
    P["PCir01B"]=B.part1
end

-- stage02.ecl：PCir02，0xcfb8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcfb8，40号。
        H.at(a,v,0)
        -- 源0xcfcc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xcfe0，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xcff8，11号。
        H.call(a,v,P["Cir02"],"Cir02",78,1)
        H.at(a,v,0)
        -- 源0xd024，1号。
        H.erase(a);return
    end
    P["PCir02"]=B.part1
end

-- stage02.ecl：PCir02B，0xd044；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd044，40号。
        H.at(a,v,0)
        -- 源0xd058，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd06c，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xd084，11号。
        H.call(a,v,P["Cir02B"],"Cir02B",78,1)
        H.at(a,v,0)
        -- 源0xd0b0，1号。
        H.erase(a);return
    end
    P["PCir02B"]=B.part1
end

-- stage02.ecl：RCir00，0xd0d0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd0d0，40号。
        H.at(a,v,0)
        -- 源0xd0e4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd0f8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xd110，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xd124，11号。
        H.call(a,v,P["Cir00"],"Cir00",69,1)
        H.at(a,v,0)
        -- 源0xd150，1号。
        H.erase(a);return
    end
    P["RCir00"]=B.part1
end

-- stage02.ecl：RCir00_at，0xd170；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd170，40号。
        H.at(a,v,0)
        -- 源0xd184，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd198，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xd1b0，402号。
        H.gun_sprite(a,0,13,3)
        H.at(a,v,0)
        -- 源0xd1cc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xd1e8，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xd204，405号。
        H.gun_speed(a,0,1.5,1.0)
        H.at(a,v,0)
        -- 源0xd220，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd250，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd280，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd294，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd2a8，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xd2bc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd2d0，355号。
        v.l[12]=H.int(16)
        H.at(a,v,0)
        -- 源0xd2f4，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd30c，409号。
        H.gun_transform(a,0,2,0,32,45,1,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd33c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd350，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd364，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd378，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd388，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd3a0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd3b4，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0xd3c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd3d8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd3ec，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd400，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0xd414，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd424，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd438，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd450，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd464，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd478，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd488，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xd4a0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd4b4，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,0)
        -- 源0xd4c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd4d8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd4ec，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd500，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0xd514，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd524，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd538，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xd550，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd564，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xd578，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd588，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xd5a0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd5b4，44号。
        H.push(v,0.15707999467849731)
        H.at(a,v,0)
        -- 源0xd5c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd5d8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd5ec，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd600，44号。
        H.push(v,0.3499999940395355)
        H.at(a,v,0)
        -- 源0xd614，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd624，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd638，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xd650，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd664，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0xd678，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd688，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd69c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd6b0，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0xd6c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd6d4，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xd6e8，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xd6fc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xd714，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd728，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xd740，402号。
        H.gun_sprite(a,0,13,3)
        H.at(a,v,0)
        -- 源0xd75c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xd778，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xd794，405号。
        H.gun_speed(a,0,1.5,1.0)
        H.at(a,v,0)
        -- 源0xd7b0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd7e0，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd810，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd824，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd838，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xd84c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd860，355号。
        v.l[12]=H.int(16)
        H.at(a,v,0)
        -- 源0xd884，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0xd89c，409号。
        H.gun_transform(a,0,2,0,32,45,1,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd8cc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd8e0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd8f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd908，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd918，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0xd930，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd944，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0xd958，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xd968，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd97c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd990，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0xd9a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd9b4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd9c8，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0xd9e0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd9f4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xda08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xda18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part15(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0xda30，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xda44，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,0)
        -- 源0xda58，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xda68，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xda7c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xda90，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0xdaa4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdab4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdac8，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0xdae0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xdaf4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xdb08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xdb18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0xdb30，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xdb44，44号。
        H.push(v,0.15707999467849731)
        H.at(a,v,0)
        -- 源0xdb58，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xdb68，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdb7c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdb90，44号。
        H.push(v,0.3499999940395355)
        H.at(a,v,0)
        -- 源0xdba4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdbb4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdbc8，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0xdbe0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xdbf4，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0xdc08，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xdc18，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdc2c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdc40，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0xdc54，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdc64，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0xdc78，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xdc8c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0xdca4，10号。
        return
    end
    P["RCir00_at"]=B.part1
end

-- stage02.ecl：RCir01，0xdcc4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdcc4，40号。
        H.at(a,v,0)
        -- 源0xdcd8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xdcec，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xdd04，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xdd18，11号。
        H.call(a,v,P["Cir01"],"Cir01",69,1)
        H.at(a,v,0)
        -- 源0xdd44，1号。
        H.erase(a);return
    end
    P["RCir01"]=B.part1
end

-- stage02.ecl：RCir01B，0xdd64；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdd64，40号。
        H.at(a,v,0)
        -- 源0xdd78，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xdd8c，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xdda4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xddb8，11号。
        H.call(a,v,P["Cir01B"],"Cir01B",69,1)
        H.at(a,v,0)
        -- 源0xdde4，1号。
        H.erase(a);return
    end
    P["RCir01B"]=B.part1
end

-- stage02.ecl：RCir01_at，0xde04；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xde04，40号。
        H.at(a,v,0)
        -- 源0xde18，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xde2c，407号。
        H.gun_aim(a,(v.l[0] or 0),3)
        H.at(a,v,0)
        -- 源0xde44，402号。
        H.gun_sprite(a,(v.l[0] or 0),1,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xde60，436号。
        H.gun_count_diff(a,(v.l[0] or 0),16,16,22,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0xde94，404号。
        H.gun_angle(a,(v.l[0] or 0),1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xdeb0，435号。
        H.gun_speed_diff(a,(v.l[0] or 0),(v.l[8] or 0),(v.l[8] or 0),(v.l[8] or 0),(v.l[8] or 0),1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xdee4，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xdf14，409号。
        H.gun_transform(a,(v.l[0] or 0),1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xdf44，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0xdf58，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdf6c，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xdf80，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdf94，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xdfa8，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xdfbc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xdfd4，404号。
        H.gun_angle(a,(v.l[0] or 0),(v.l[16] or 0),0.0)
        H.at(a,v,0)
        -- 源0xdff0，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xe004，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xe018，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe02c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe03c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe050，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe064，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0xe078，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe090，10号。
        return
    end
    P["RCir01_at"]=B.part1
end

-- stage02.ecl：RCir02，0xe0b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe0b0，40号。
        H.at(a,v,0)
        -- 源0xe0c4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe0d8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe0f0，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe104，11号。
        H.call(a,v,P["Cir02"],"Cir02",69,1)
        H.at(a,v,0)
        -- 源0xe130，1号。
        H.erase(a);return
    end
    P["RCir02"]=B.part1
end

-- stage02.ecl：RCir02B，0xe150；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe150，40号。
        H.at(a,v,0)
        -- 源0xe164，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe178，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe190，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe1a4，11号。
        H.call(a,v,P["Cir02B"],"Cir02B",69,1)
        H.at(a,v,0)
        -- 源0xe1d0，1号。
        H.erase(a);return
    end
    P["RCir02B"]=B.part1
end

-- stage02.ecl：RCir02_at，0xe1f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe1f0，40号。
        H.at(a,v,0)
        -- 源0xe204，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe218，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xe230，402号。
        H.gun_sprite(a,0,1,13)
        H.at(a,v,0)
        -- 源0xe24c，436号。
        H.gun_count_diff(a,0,1,1,1,4,2,2,3,4)
        H.at(a,v,0)
        -- 源0xe280，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xe29c，435号。
        H.gun_speed_diff(a,0,4.0,4.0,5.0,6.0,0.800000011920929,0.800000011920929,0.800000011920929,0.800000011920929)
        H.at(a,v,0)
        -- 源0xe2d0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe300，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xe314，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0xe32c，402号。
        H.gun_sprite(a,1,1,9)
        H.at(a,v,0)
        -- 源0xe348，406号。
        H.gun_count(a,1,1,2)
        H.at(a,v,0)
        -- 源0xe364，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0xe380，405号。
        H.gun_speed(a,1,2.0,0.800000011920929)
        H.at(a,v,0)
        -- 源0xe39c，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe3cc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xe3e0，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xe3f4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe408，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe420，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe434，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xe448，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xe45c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xe470，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xe480，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0xe49c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0xe4b0，368号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe4d0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xe4e4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe4fc，10号。
        return
    end
    P["RCir02_at"]=B.part1
end

-- stage02.ecl：RGirl00，0xe51c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe51c，40号。
        H.at(a,v,0)
        -- 源0xe530，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe544，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe55c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe570，11号。
        H.call(a,v,P["Girl00"],"Girl00",5,1)
        H.at(a,v,0)
        -- 源0xe59c，1号。
        H.erase(a);return
    end
    P["RGirl00"]=B.part1
end

-- stage02.ecl：RGirl00_at，0xe5bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe5bc，40号。
        H.at(a,v,0)
        -- 源0xe5d0，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0xe5f4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe608，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xe620，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0xe63c，436号。
        H.gun_count_diff(a,0,1,1,6,12,1,1,1,1)
        H.at(a,v,0)
        -- 源0xe670，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xe68c，435号。
        H.gun_speed_diff(a,0,1.5,2.5,3.5,4.5,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xe6c0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe6f0，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe720，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe734，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe74c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0xe760，401号。
        H.fire(a,0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe774，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xe788，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe7a0，10号。
        return
    end
    P["RGirl00_at"]=B.part1
end

-- stage02.ecl：RGirl01，0xe7c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe7c0，40号。
        H.at(a,v,0)
        -- 源0xe7d4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe7e8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe800，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe814，11号。
        H.call(a,v,P["Girl01"],"Girl01",5,1)
        H.at(a,v,0)
        -- 源0xe840，1号。
        H.erase(a);return
    end
    P["RGirl01"]=B.part1
end

-- stage02.ecl：RGirl01B，0xe860；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe860，40号。
        H.at(a,v,0)
        -- 源0xe874，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe888，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe8a0，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe8b4，11号。
        H.call(a,v,P["Girl01B"],"Girl01B",5,1)
        H.at(a,v,0)
        -- 源0xe8e0，1号。
        H.erase(a);return
    end
    P["RGirl01B"]=B.part1
end

-- stage02.ecl：RGirl01_at，0xe900；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe900，40号。
        H.at(a,v,0)
        -- 源0xe914，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe928，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xe940，402号。
        H.gun_sprite(a,0,12,2)
        H.at(a,v,0)
        -- 源0xe95c，436号。
        H.gun_count_diff(a,0,6,12,20,20,1,1,1,2)
        H.at(a,v,0)
        -- 源0xe990，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xe9ac，435号。
        H.gun_speed_diff(a,0,1.2999999523162842,1.5,2.5,3.5,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xe9e0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xea10，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xea40，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xea54，10号。
        return
    end
    P["RGirl01_at"]=B.part1
end

-- stage02.ecl：RGirl02，0xea74；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xea74，40号。
        H.at(a,v,0)
        -- 源0xea88，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xea9c，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xeab4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xeac8，11号。
        H.call(a,v,P["Girl02"],"Girl02",5,1)
        H.at(a,v,0)
        -- 源0xeaf4，1号。
        H.erase(a);return
    end
    P["RGirl02"]=B.part1
end

-- stage02.ecl：RGirl02_at，0xeb14；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xeb14，40号。
        H.at(a,v,0)
        -- 源0xeb28，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xeb3c，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xeb54，402号。
        H.gun_sprite(a,0,13,3)
        H.at(a,v,0)
        -- 源0xeb70，436号。
        H.gun_count_diff(a,0,1,5,5,5,1,1,2,3)
        H.at(a,v,0)
        -- 源0xeba4，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xebc0，435号。
        H.gun_speed_diff(a,0,2.5,3.0,3.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xebf4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xec24，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xec54，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xec68，10号。
        return
    end
    P["RGirl02_at"]=B.part1
end

-- stage02.ecl：RGirl03，0xec88；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xec88，40号。
        H.at(a,v,0)
        -- 源0xec9c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xecb0，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xecc8，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xecdc，11号。
        H.call(a,v,P["Girl03"],"Girl03",5,1)
        H.at(a,v,0)
        -- 源0xed08，1号。
        H.erase(a);return
    end
    P["RGirl03"]=B.part1
end

-- stage02.ecl：RGirl03_at，0xed28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xed28，40号。
        H.at(a,v,0)
        -- 源0xed3c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xed50，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xed68，402号。
        H.gun_sprite(a,0,12,2)
        H.at(a,v,0)
        -- 源0xed84，436号。
        H.gun_count_diff(a,0,6,12,14,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0xedb8，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xedd4，435号。
        H.gun_speed_diff(a,0,2.0,3.5,4.5,5.5,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xee08，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xee38，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xee68，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xee7c，10号。
        return
    end
    P["RGirl03_at"]=B.part1
end

-- stage02.ecl：YGirl00，0xee9c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xee9c，40号。
        H.at(a,v,0)
        -- 源0xeeb0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xeec4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xeedc，11号。
        H.call(a,v,P["Girl00"],"Girl00",15,1)
        H.at(a,v,0)
        -- 源0xef08，1号。
        H.erase(a);return
    end
    P["YGirl00"]=B.part1
end

-- stage02.ecl：YGirl01，0xef28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xef28，40号。
        H.at(a,v,0)
        -- 源0xef3c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xef50，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xef68，11号。
        H.call(a,v,P["Girl01"],"Girl01",15,1)
        H.at(a,v,0)
        -- 源0xef94，1号。
        H.erase(a);return
    end
    P["YGirl01"]=B.part1
end

-- stage02.ecl：YGirl01B，0xefb4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xefb4，40号。
        H.at(a,v,0)
        -- 源0xefc8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xefdc，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xeff4，11号。
        H.call(a,v,P["Girl01B"],"Girl01B",15,1)
        H.at(a,v,0)
        -- 源0xf020，1号。
        H.erase(a);return
    end
    P["YGirl01B"]=B.part1
end

-- stage02.ecl：YGirl02，0xf040；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf040，40号。
        H.at(a,v,0)
        -- 源0xf054，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf068，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf080，11号。
        H.call(a,v,P["Girl02"],"Girl02",15,1)
        H.at(a,v,0)
        -- 源0xf0ac，1号。
        H.erase(a);return
    end
    P["YGirl02"]=B.part1
end

-- stage02.ecl：YGirl03，0xf0cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf0cc，40号。
        H.at(a,v,0)
        -- 源0xf0e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf0f4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf10c，11号。
        H.call(a,v,P["Girl03"],"Girl03",15,1)
        H.at(a,v,0)
        -- 源0xf138，1号。
        H.erase(a);return
    end
    P["YGirl03"]=B.part1
end

-- stage02.ecl：main，0xf158；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf158，40号。
        H.at(a,v,0)
        -- 源0xf16c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0xf180，257号。
        H.spawn(a,257,"MapleEnemy",0.0,-16.0,20,1000,2)
        H.at(a,v,160)
        -- 源0xf1b4，0号。
        H.at(a,v,160)
        -- 源0xf1c4，15号。
        H.async(a,P["MainSub00"],"MainSub00",nil)
        H.at(a,v,160)
        -- 源0xf1e4，15号。
        H.async(a,P["MainSub01"],"MainSub01",nil)
        H.at(a,v,160)
        -- 源0xf204，83号。
        v.origin=v.origin+H.int(800)
        H.at(a,v,160)
        -- 源0xf218，15号。
        H.async(a,P["MainSub03"],"MainSub03",nil)
        H.at(a,v,160)
        -- 源0xf238，83号。
        v.origin=v.origin+H.int(760)
        H.at(a,v,160)
        -- 源0xf24c，15号。
        H.async(a,P["MainSub04"],"MainSub04",nil)
        H.at(a,v,160)
        -- 源0xf26c，83号。
        v.origin=v.origin+H.int(800)
        H.at(a,v,160)
        -- 源0xf280，257号。
        H.spawn(a,257,"MBoss",128.0,-32.0,40,10000,1)
        H.at(a,v,160)
        -- 源0xf2b0，83号。
        v.origin=v.origin+H.int(800)
        H.at(a,v,160)
        -- 源0xf2c4，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,160)
        -- 源0xf2e4，340号。
        H.boss_wait(a,v)
        H.at(a,v,160)
        -- 源0xf2f4，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,160)
        -- 源0xf308，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,160)
        -- 源0xf328，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,160)
        -- 源0xf33c，338号。
        H.dialog(a,0)
        H.at(a,v,160)
        -- 源0xf350，339号。
        H.dialog_wait(a,v)
        H.at(a,v,160)
        -- 源0xf360，257号。
        H.spawn(a,257,"Boss",-144.0,-16.0,40,10000,1)
        H.at(a,v,160)
        -- 源0xf390，339号。
        H.dialog_wait(a,v)
        H.at(a,v,160)
        -- 源0xf3a0，340号。
        H.boss_wait(a,v)
        H.at(a,v,160)
        -- 源0xf3b0，338号。
        H.dialog(a,1)
        H.at(a,v,160)
        -- 源0xf3c4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,160)
        -- 源0xf3d4，12号。
        v.origin=H.clock(a)-(160);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,160)
        -- 源0xf3ec，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,160)
        -- 源0xf400，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0xf414，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(160);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,40160)
        -- 源0xf42c，0号。
        H.at(a,v,40160)
        -- 源0xf43c，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

return P
