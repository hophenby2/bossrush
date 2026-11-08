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

-- stage01.ecl：BGirl00，0x4a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a8，40号。
        H.at(a,v,0)
        -- 源0x4bc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x4d0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4e4，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x4fc，11号。
        H.call(a,v,P["Girl00"],"Girl00",0,1)
        H.at(a,v,0)
        -- 源0x528，1号。
        H.erase(a);return
    end
    P["BGirl00"]=B.part1
end

-- stage01.ecl：BGirl02，0x548；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x548，40号。
        H.at(a,v,0)
        -- 源0x55c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x570，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x584，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x59c，11号。
        H.call(a,v,P["Girl02"],"Girl02",0,1)
        H.at(a,v,0)
        -- 源0x5c8，1号。
        H.erase(a);return
    end
    P["BGirl02"]=B.part1
end

-- stage01.ecl：BGirl03，0x5e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5e8，40号。
        H.at(a,v,0)
        -- 源0x5fc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x610，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x624，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x63c，11号。
        H.call(a,v,P["Girl03"],"Girl03",0)
        H.at(a,v,0)
        -- 源0x660，1号。
        H.erase(a);return
    end
    P["BGirl03"]=B.part1
end

-- stage01.ecl：BGirl05，0x680；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x680，40号。
        H.at(a,v,0)
        -- 源0x694，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6a8，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6bc，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x6d4，11号。
        H.call(a,v,P["Girl05"],"Girl05",0,1)
        H.at(a,v,0)
        -- 源0x700，1号。
        H.erase(a);return
    end
    P["BGirl05"]=B.part1
end

-- stage01.ecl：Boss，0x720；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x720，40号。
        H.at(a,v,0)
        -- 源0x734，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x748，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x75c，262号。
        H.anm_main(a,0,1)
        H.at(a,v,0)
        -- 源0x774，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x788，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7a0，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7b8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x7cc，331号。
        H.life(a,9200)
        H.at(a,v,0)
        -- 源0x7e0，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x800，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x814，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x828，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x838，324号。
        H.limit(a,0.0,128.0,280.0,64.0)
        H.at(a,v,60)
        -- 源0x858，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x86c，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x884，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,60)
        -- 源0x89c，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x8b0，440号。
        H.fog(a,160.0,16711808)
        H.at(a,v,60)
        -- 源0x8c8，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0x8e4，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage01.ecl：Boss1，0x904；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x904，40号。
        H.at(a,v,0)
        -- 源0x918，355号。
        v.l[0]=H.int(40)
        H.at(a,v,0)
        -- 源0x93c，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x94c，334号。
        H.interrupt(a,0,1500,2100,"BossCard1")
        H.at(a,v,0)
        -- 源0x978，347号。
        H.life_marker(a,0,1500.0,-24448)
        H.at(a,v,0)
        -- 源0x994，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0x9a8，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x9bc，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x9d0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9e8，356号。
        v.l[4]=H.f32(0.7853981852531433)
        H.at(a,v,0)
        -- 源0xa0c，356号。
        v.l[8]=H.f32(-0.06544984877109528)
        H.at(a,v,0)
        -- 源0xa30，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xa60，83号。
        v.origin=v.origin+H.int(24)
        H.at(a,v,0)
        -- 源0xa74，292号。
        H.wander(a,0,40,4,4.0)
        H.at(a,v,0)
        -- 源0xa90，83号。
        v.origin=v.origin+H.int(41)
        H.at(a,v,0)
        -- 源0xaa4，356号。
        v.l[4]=H.f32(-0.7853981852531433)
        H.at(a,v,0)
        -- 源0xac8，356号。
        v.l[8]=H.f32(0.06544984877109528)
        H.at(a,v,0)
        -- 源0xaec，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xb1c，83号。
        v.origin=v.origin+H.int(24)
        H.at(a,v,0)
        -- 源0xb30，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0xb44，292号。
        H.wander(a,0,40,4,4.0)
        H.at(a,v,0)
        -- 源0xb60，83号。
        v.origin=v.origin+H.int(41)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb74，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb88，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xba0，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage01.ecl：Boss1At1，0xbc0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbc0，40号。
        H.at(a,v,0)
        -- 源0xbd4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xbe8，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbfc，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xc10，83号。
        v.origin=v.origin+H.int(8)
        H.at(a,v,0)
        -- 源0xc24，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xc38，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xc50，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0xc6c，436号。
        H.gun_count_diff(a,0,4,4,4,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0xca0，404号。
        H.gun_angle(a,0,0.0,0.15707963705062866)
        H.at(a,v,0)
        -- 源0xcbc，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xcd8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd08，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd38，403号。
        H.gun_offset(a,0,8.0,-32.0)
        H.at(a,v,0)
        -- 源0xd54，438号。
        H.gun_distance(a,0,24.0)
        H.at(a,v,0)
        -- 源0xd6c，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0xd84，409号。
        H.gun_transform(a,1,2,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xdb4，409号。
        H.gun_transform(a,1,3,0,32,35,1,0.0,1.0)
        H.at(a,v,0)
        -- 源0xde4，409号。
        H.gun_transform(a,1,4,0,2048,1,2,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe14，409号。
        H.gun_transform(a,1,5,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe44，409号。
        H.gun_transform(a,1,6,0,4,120,-999999,0.019166667014360428,-999999.0)
        H.at(a,v,0)
        -- 源0xe74，403号。
        H.gun_offset(a,1,8.0,-32.0)
        H.at(a,v,0)
        -- 源0xe90，438号。
        H.gun_distance(a,1,24.0)
        H.at(a,v,0)
        -- 源0xea8，356号。
        v.l[24]=H.f32(1.0)
        H.at(a,v,0)
        -- 源0xecc，355号。
        v.l[8]=H.int(16)
        H.at(a,v,0)
        -- 源0xef0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf08，405号。
        H.gun_speed(a,0,(v.l[24] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0xf24，404号。
        H.gun_angle(a,0,(v.l[0] or 0),(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xf40，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xf54，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0xf68，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,0)
        -- 源0xf7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf8c，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xfec，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x1000，44号。
        H.push(v,0.004999999888241291)
        H.at(a,v,0)
        -- 源0x1014，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1024，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1038，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x104c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1060，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1070，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1084，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x1098，405号。
        H.gun_speed(a,1,(v.l[24] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x10b4，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x10d0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x10e4，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x10f8，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,0)
        -- 源0x110c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x111c，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x117c，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x1190，44号。
        H.push(v,0.004999999888241291)
        H.at(a,v,0)
        -- 源0x11a4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x11b4，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11c8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x11dc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x11f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1200，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1214，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1228，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x123c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1254，10号。
        return
    end
    P["Boss1At1"]=B.part1
end

-- stage01.ecl：Boss2，0x1274；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1274，40号。
        H.at(a,v,0)
        -- 源0x1288，331号。
        H.life(a,9760)
        H.at(a,v,0)
        -- 源0x129c，334号。
        H.interrupt(a,0,1760,2100,"BossCard2")
        H.at(a,v,0)
        -- 源0x12c8，347号。
        H.life_marker(a,0,1760.0,-24448)
        H.at(a,v,0)
        -- 源0x12e4，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x12f8，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x130c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1320，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1334，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1344，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x135c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1370，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1388，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x139c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x13ac，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x13bc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x13d0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x13e4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x140c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x1420，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1430，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1444，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1458，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1468，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1480，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1494，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x14a8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x14bc，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x14d0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x14e4，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x14f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x150c，327号。
        H.drop_extra(a,1,6)
        H.at(a,v,0)
        -- 源0x1524，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x153c，327号。
        H.drop_extra(a,1,10)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1554，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x156c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1584，329号。
        H.drop(a)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x1594，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x15a8，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,60)
        -- 源0x15c8，0号。
        H.at(a,v,60)
        -- 源0x15d8，324号。
        H.limit(a,0.0,160.0,280.0,64.0)
        H.at(a,v,60)
        -- 源0x15f8，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,60)
        -- 源0x160c，12号。
        v.origin=H.clock(a)-(60);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x1624，356号。
        v.l[0]=H.f32(0.7853981852531433)
        H.at(a,v,60)
        -- 源0x1648，356号。
        v.l[4]=H.f32(-0.09185943752527237)
        H.at(a,v,60)
        -- 源0x166c，11号。
        H.call(a,v,P["Boss2At1"],"Boss2At1",(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x169c，83号。
        v.origin=v.origin+H.int(24)
        H.at(a,v,60)
        -- 源0x16b0，292号。
        H.wander(a,0,40,4,4.0)
        H.at(a,v,60)
        -- 源0x16cc，83号。
        v.origin=v.origin+H.int(41)
        H.at(a,v,60)
        -- 源0x16e0，356号。
        v.l[0]=H.f32(-0.7853981852531433)
        H.at(a,v,60)
        -- 源0x1704，356号。
        v.l[4]=H.f32(0.09185943752527237)
        H.at(a,v,60)
        -- 源0x1728，11号。
        H.call(a,v,P["Boss2At1"],"Boss2At1",(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x1758，83号。
        v.origin=v.origin+H.int(24)
        H.at(a,v,60)
        -- 源0x176c，292号。
        H.wander(a,0,40,4,4.0)
        H.at(a,v,60)
        -- 源0x1788，83号。
        v.origin=v.origin+H.int(41)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x179c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x17b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x17c8，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage01.ecl：Boss2At1，0x17e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x17e8，40号。
        H.at(a,v,0)
        -- 源0x17fc，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x1810，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1824，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x1838，83号。
        v.origin=v.origin+H.int(8)
        H.at(a,v,0)
        -- 源0x184c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1860，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1878，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x1894，436号。
        H.gun_count_diff(a,0,4,4,4,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0x18c8，404号。
        H.gun_angle(a,0,0.0,0.15707963705062866)
        H.at(a,v,0)
        -- 源0x18e4，435号。
        H.gun_speed_diff(a,0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x1918，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1948，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1978，403号。
        H.gun_offset(a,0,8.0,-32.0)
        H.at(a,v,0)
        -- 源0x1994，438号。
        H.gun_distance(a,0,15.0)
        H.at(a,v,0)
        -- 源0x19ac，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0x19c4，409号。
        H.gun_transform(a,1,2,0,4096,30,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x19f4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1a08，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a1c，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1a2c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1a44，409号。
        H.gun_transform(a,1,3,0,64,40,1,1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0x1a74，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1a8c，409号。
        H.gun_transform(a,1,3,0,64,40,1,1.5707963705062866,1.100000023841858)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1abc，409号。
        H.gun_transform(a,1,4,0,2048,1,2,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1aec，403号。
        H.gun_offset(a,1,8.0,-32.0)
        H.at(a,v,0)
        -- 源0x1b08，438号。
        H.gun_distance(a,1,15.0)
        H.at(a,v,0)
        -- 源0x1b20，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1b34，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1b48，355号。
        v.l[8]=H.int(32)
        H.at(a,v,0)
        -- 源0x1b6c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1b84，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x1b98，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1bac，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1bbc，405号。
        H.gun_speed(a,0,(v.l[24] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1bd8，404号。
        H.gun_angle(a,0,(v.l[0] or 0),(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1bf4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1c08，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1c1c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1c30，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1c40，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c54，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x1c74，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x1c88，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1c9c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1cac，405号。
        H.gun_speed(a,1,(v.l[24] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1cc8，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1ce4，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x1cf8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1d0c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1d20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1d30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d44，368号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1d64，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x1d78，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1d90，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage01.ecl：BossCard1，0x1db0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1db0，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1dec，334号。
        H.interrupt(a,0,0,2100,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1e50，359号。
        H.spell(a,4,2100,500000,"蜘蛛「石窟の蜘蛛の巣」",359)
        H.at(a,v,0)
        -- 源0x1e88，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x1e9c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1eac，281号。
        H.position_time(a,0,60,4,0.0,144.0)
        H.at(a,v,0)
        -- 源0x1ecc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x1ee0，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x1ef4，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x1f28，324号。
        H.limit(a,0.0,128.0,280.0,256.0)
        H.at(a,v,0)
        -- 源0x1f48，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1f5c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1f70，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1f80，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1f98，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x1fac，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1fbc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1fd0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x1fe4，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x1ffc，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x2010，0号。
        H.at(a,v,150)
        -- 源0x2020，42号。
        H.push(v,144)
        H.at(a,v,150)
        -- 源0x2034，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x2048，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,150)
        -- 源0x205c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x2070，44号。
        H.push(v,0.006136000156402588)
        H.at(a,v,150)
        -- 源0x2084，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x2098，42号。
        H.push(v,4)
        H.at(a,v,150)
        -- 源0x20ac，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,150)
        -- 源0x20c0，12号。
        v.origin=H.clock(a)-(150);return B.part13(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x20d8，15号。
        H.async(a,P["BossCard1_at"],"BossCard1_at",nil,(v.l[4] or 0),(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,150)
        -- 源0x2114，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,150)
        -- 源0x2128，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,150)
        -- 源0x213c，42号。
        H.push(v,0)
        H.at(a,v,150)
        -- 源0x2150，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,150)
        -- 源0x2160，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(150);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x2178，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,150)
        -- 源0x218c，44号。
        H.push(v,160.0)
        H.at(a,v,150)
        -- 源0x21a0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,150)
        -- 源0x21b0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(150);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x21c8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,150)
        -- 源0x21dc，44号。
        H.push(v,10.0)
        H.at(a,v,150)
        -- 源0x21f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,150)
        -- 源0x2200，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,150)
        -- 源0x2214，12号。
        v.origin=H.clock(a)-(150);return B.part10(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,150)
        -- 源0x222c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,150)
        -- 源0x2240，44号。
        H.push(v,160.0)
        H.at(a,v,150)
        -- 源0x2254，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,150)
        -- 源0x2264，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(150);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,150)
        -- 源0x227c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,150)
        -- 源0x2290，44号。
        H.push(v,12.0)
        H.at(a,v,150)
        -- 源0x22a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,150)
        -- 源0x22b4，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,150)
        -- 源0x22c8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,150)
        -- 源0x22dc，44号。
        H.push(v,16.0)
        H.at(a,v,150)
        -- 源0x22f0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,150)
        -- 源0x2300，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),(v.l[0] or 0))
        H.at(a,v,150)
        -- 源0x2320，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,150)
        -- 源0x2334，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,150)
        -- 源0x2348，44号。
        H.push(v,-1.0)
        H.at(a,v,150)
        -- 源0x235c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,150)
        -- 源0x236c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x2380，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,150)
        -- 源0x2394，44号。
        H.push(v,-1.0)
        H.at(a,v,150)
        -- 源0x23a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,150)
        -- 源0x23b8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x23cc，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,150)
        -- 源0x23e0，42号。
        H.push(v,4)
        H.at(a,v,150)
        -- 源0x23f4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,150)
        -- 源0x2404，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(150);return B.part12(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,150)
        -- 源0x241c，42号。
        H.push(v,10)
        H.at(a,v,150)
        -- 源0x2430，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,150)
        -- 源0x2444，12号。
        v.origin=H.clock(a)-(150);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,150)
        -- 源0x245c，42号。
        H.push(v,4)
        H.at(a,v,150)
        -- 源0x2470，43号。
        v.l[12]=H.int(H.pop(v))
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,150)
        -- 源0x2484，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x2498，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,150)
        -- 源0x24b0，12号。
        v.origin=H.clock(a)-(150);return B.part16(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,150)
        -- 源0x24c8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,150)
        -- 源0x24dc，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x24f0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part15(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,150)
        -- 源0x2508，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage01.ecl：BossCard1_at，0x2528；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2528，40号。
        H.at(a,v,0)
        -- 源0x253c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2550，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2564，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2578，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x2590，402号。
        H.gun_sprite(a,0,3,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x25ac，436号。
        H.gun_count_diff(a,0,6,8,12,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0x25e0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x25fc，405号。
        H.gun_speed(a,0,0.009999999776482582,2.0)
        H.at(a,v,0)
        -- 源0x2618，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2648，409号。
        H.gun_transform(a,0,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2678，409号。
        H.gun_transform(a,0,2,0,512,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x26a8，409号。
        H.gun_transform(a,0,5,0,4,60,-999999,0.06666667014360428,-999999.0)
        H.at(a,v,0)
        -- 源0x26d8，403号。
        H.gun_offset(a,0,8.0,-32.0)
        H.at(a,v,0)
        -- 源0x26f4，42号。
        H.push(v,46)
        H.at(a,v,0)
        -- 源0x2708，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x271c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2730，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2744，42号。
        H.push(v,46)
        H.at(a,v,0)
        -- 源0x2758，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x276c，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x2780，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2794，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x27ac，409号。
        H.gun_transform(a,0,3,0,4096,1500,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x27dc，409号。
        H.gun_transform(a,0,3,0,4096,(v.l[28] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x280c，409号。
        H.gun_transform(a,0,4,0,16,1,1,(v.l[0] or 0),0.009999999776482582)
        H.at(a,v,0)
        -- 源0x283c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2850，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2864，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2874，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2888，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x289c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x28b0，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x28c0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x28d8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x28ec，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x2900，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2910，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x2924，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2934，409号。
        H.gun_transform(a,0,6,0,8,60,-999999,-0.05000000074505806,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2964，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x297c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2990，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x29a4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x29b4，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x29c8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x29d8，409号。
        H.gun_transform(a,0,6,0,8,60,-999999,-0.0416666679084301,H.read(a,v,-1))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2a08，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x2a1c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2a30，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x2a40，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2a54，438号。
        H.gun_distance(a,0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2a6c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x2a80，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2a94，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2aa8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2ab8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2ac8，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x2ae4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2af8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2b0c，44号。
        H.push(v,8.0)
        H.at(a,v,0)
        -- 源0x2b20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2b30，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b44，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2b58，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x2b6c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2b84，10号。
        return
    end
    P["BossCard1_at"]=B.part1
end

-- stage01.ecl：BossCard2，0x2ba4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2ba4，40号。
        H.at(a,v,0)
        -- 源0x2bb8，334号。
        H.interrupt(a,0,0,2400,"BossDead")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x2c20，359号。
        H.spell(a,8,2400,500000,"瘴気「原因不明の熱病」",359)
        H.at(a,v,0)
        -- 源0x2c58，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2c68，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0x2c88，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2c9c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2cb0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2cc4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2cd4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2cec，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x2d00，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2d10，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d24，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2d38，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x2d4c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2d60，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2d74，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2d84，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2d9c，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x2dd0，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2de8，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2e20，344号。
        a.chapter=44
        H.at(a,v,60)
        -- 源0x2e34，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x2e4c，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x2e60，0号。
        H.at(a,v,150)
        -- 源0x2e70，12号。
        v.origin=H.clock(a)-(190);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,150)
        -- 源0x2e88，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0,0.07718900591135025,2)
        H.at(a,v,150)
        -- 源0x2ec4，42号。
        H.push(v,0)
        H.at(a,v,150)
        -- 源0x2ed8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x2eec，44号。
        H.push(v,-0.1547580063343048)
        H.at(a,v,150)
        -- 源0x2f00，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x2f14，42号。
        H.push(v,4)
        H.at(a,v,150)
        -- 源0x2f28，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,150)
        -- 源0x2f3c，257号。
        H.spawn(a,257,"BossCard2At",-100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x2f70，257号。
        H.spawn(a,257,"BossCard2At",100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x2fa4，83号。
        v.origin=v.origin+H.int(380)
        H.at(a,v,150)
        -- 源0x2fb8，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0,-0.1547582596540451,4)
        H.at(a,v,150)
        -- 源0x2ff4，42号。
        H.push(v,0)
        H.at(a,v,150)
        -- 源0x3008，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x301c，44号。
        H.push(v,0.07718899846076965)
        H.at(a,v,150)
        -- 源0x3030，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x3044，42号。
        H.push(v,2)
        H.at(a,v,150)
        -- 源0x3058，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,150)
        -- 源0x306c，257号。
        H.spawn(a,257,"BossCard2At",-100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x30a0，257号。
        H.spawn(a,257,"BossCard2At",100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x30d4，83号。
        v.origin=v.origin+H.int(380)
        H.at(a,v,150)
        -- 源0x30e8，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0,-0.07718900591135025,2)
        H.at(a,v,150)
        -- 源0x3124，42号。
        H.push(v,0)
        H.at(a,v,150)
        -- 源0x3138，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x314c，44号。
        H.push(v,-0.1547580063343048)
        H.at(a,v,150)
        -- 源0x3160，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x3174，42号。
        H.push(v,4)
        H.at(a,v,150)
        -- 源0x3188，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,150)
        -- 源0x319c，257号。
        H.spawn(a,257,"BossCard2At",-100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x31d0，257号。
        H.spawn(a,257,"BossCard2At",100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x3204，83号。
        v.origin=v.origin+H.int(380)
        H.at(a,v,150)
        -- 源0x3218，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0,0.1547582596540451,4)
        H.at(a,v,150)
        -- 源0x3254，42号。
        H.push(v,0)
        H.at(a,v,150)
        -- 源0x3268，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x327c，44号。
        H.push(v,0.07718899846076965)
        H.at(a,v,150)
        -- 源0x3290，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x32a4，42号。
        H.push(v,2)
        H.at(a,v,150)
        -- 源0x32b8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,150)
        -- 源0x32cc，257号。
        H.spawn(a,257,"BossCard2At",-100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x3300，257号。
        H.spawn(a,257,"BossCard2At",100.0,128.0,4000,10000,1)
        H.at(a,v,150)
        -- 源0x3334，83号。
        v.origin=v.origin+H.int(380)
        H.at(a,v,190)
        -- 源0x3348，0号。
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,190)
        -- 源0x3358，42号。
        H.push(v,1)
        H.at(a,v,190)
        -- 源0x336c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,190)
        -- 源0x3384，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage01.ecl：BossCard2At，0x33a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x33a4，40号。
        H.at(a,v,0)
        -- 源0x33b8，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0x33cc，11号。
        H.call(a,v,P["BossCard2At_at"],"BossCard2At_at",0,H.read(a,v,-9981),H.read(a,v,-9980),H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x3410，1号。
        H.erase(a);return
    end
    P["BossCard2At"]=B.part1
end

-- stage01.ecl：BossCard2At_at，0x3440；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3440，40号。
        H.at(a,v,0)
        -- 源0x3454，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3468，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x347c，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3490，407号。
        H.gun_aim(a,(v.l[0] or 0),3)
        H.at(a,v,0)
        -- 源0x34a8，402号。
        H.gun_sprite(a,(v.l[0] or 0),5,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x34c4，406号。
        H.gun_count(a,(v.l[0] or 0),1,1)
        H.at(a,v,0)
        -- 源0x34e0，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x34fc，405号。
        H.gun_speed(a,(v.l[0] or 0),0.009999999776482582,2.0)
        H.at(a,v,0)
        -- 源0x3518，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3548，409号。
        H.gun_transform(a,(v.l[0] or 0),1,0,1024,10,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3578，409号。
        H.gun_transform(a,(v.l[0] or 0),2,0,512,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x35a8，409号。
        H.gun_transform(a,(v.l[0] or 0),4,0,4,60,-999999,0.02666666731238365,-999999.0)
        H.at(a,v,0)
        -- 源0x35d8，403号。
        H.gun_offset(a,(v.l[0] or 0),8.0,-32.0)
        H.at(a,v,0)
        -- 源0x35f4，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3608，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x361c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x362c，411号。
        H.gun_copy(a,H.read(a,v,-1),0)
        H.at(a,v,0)
        -- 源0x3644，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3658，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x366c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x367c，403号。
        H.gun_offset(a,H.read(a,v,-1),8.0,-32.0)
        H.at(a,v,0)
        -- 源0x3698，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x36ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x36c0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x36d0，409号。
        H.gun_transform(a,H.read(a,v,-1),5,0,4,60,-999999,-0.02666666731238365,-999999.0)
        H.at(a,v,0)
        -- 源0x3700，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3714，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3728，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3738，409号。
        H.gun_transform(a,H.read(a,v,-1),6,0,4096,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3768，355号。
        v.l[24]=H.int(70)
        H.at(a,v,0)
        -- 源0x378c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x37a0，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x37b4，42号。
        H.push(v,270)
        H.at(a,v,0)
        -- 源0x37c8，43号。
        v.l[32]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x37dc，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x37f0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3804，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x381c，409号。
        H.gun_transform(a,(v.l[0] or 0),3,0,4096,(v.l[32] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x384c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3860，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3874，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3884，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3898，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x38b0，404号。
        H.gun_angle(a,(v.l[0] or 0),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x38cc，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x38e0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x38f4，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x3908，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3918，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x392c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3940，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3954，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3964，409号。
        H.gun_transform(a,H.read(a,v,-1),3,0,4096,(v.l[32] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3994，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x39a8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x39bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x39cc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x39e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x39f4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x3a08，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3a18，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3a2c，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x3a40，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x3a50，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3a60，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3a74，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3a88，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3a98，409号。
        H.gun_transform(a,H.read(a,v,-1),7,0,64,1,1,H.read(a,v,-1),3.0)
        H.at(a,v,0)
        -- 源0x3ac8，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3adc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3af0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3b00，438号。
        H.gun_distance(a,H.read(a,v,-1),(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3b18，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3b2c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3b40，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3b50，404号。
        H.gun_angle(a,H.read(a,v,-1),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3b6c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3b80，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3b94，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3ba4，401号。
        H.fire(a,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3bb8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3bcc，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x3be0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3bf0，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3c04，409号。
        H.gun_transform(a,(v.l[0] or 0),3,0,4096,(v.l[32] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3c34，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3c48，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3c5c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3c6c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3c80，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3c98，404号。
        H.gun_angle(a,(v.l[0] or 0),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3cb4，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3cc8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3cdc，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x3cf0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3d00，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d14，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3d28，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3d3c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3d4c，409号。
        H.gun_transform(a,H.read(a,v,-1),3,0,4096,(v.l[32] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3d7c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3d90，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3da4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3db4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3dc8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3ddc，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x3df0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3e00，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3e14，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x3e28，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x3e38，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3e48，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3e5c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3e70，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3e80，409号。
        H.gun_transform(a,H.read(a,v,-1),7,0,64,1,1,H.read(a,v,-1),3.0)
        H.at(a,v,0)
        -- 源0x3eb0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3ec4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3ed8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3ee8，438号。
        H.gun_distance(a,H.read(a,v,-1),(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3f00，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3f14，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3f28，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3f38，404号。
        H.gun_angle(a,H.read(a,v,-1),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3f54，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3f68，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3f7c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3f8c，401号。
        H.fire(a,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3fa0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3fb4，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x3fc8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3fd8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4038，42号。
        H.push(v,(v.l[32] or 0))
        H.at(a,v,0)
        -- 源0x404c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x4060，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x4070，43号。
        v.l[32]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4084，368号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x40a4，78号。
        H.push(v,(v.l[24] or 0))
        v.l[24]=H.int((v.l[24] or 0)-1)
        H.at(a,v,0)
        -- 源0x40b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x40d0，10号。
        return
    end
    P["BossCard2At_at"]=B.part1
end

-- stage01.ecl：BossCard2_at，0x40f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x40f0，40号。
        H.at(a,v,0)
        -- 源0x4104，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x4118，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x412c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4140，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x4158，402号。
        H.gun_sprite(a,0,5,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4174，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x4190，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x41ac，405号。
        H.gun_speed(a,0,0.009999999776482582,2.0)
        H.at(a,v,0)
        -- 源0x41c8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x41f8，409号。
        H.gun_transform(a,0,1,0,1024,10,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4228，409号。
        H.gun_transform(a,0,2,0,512,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4258，409号。
        H.gun_transform(a,0,4,0,4,60,-999999,0.02666666731238365,-999999.0)
        H.at(a,v,0)
        -- 源0x4288，403号。
        H.gun_offset(a,0,8.0,-32.0)
        H.at(a,v,0)
        -- 源0x42a4，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0x42bc，403号。
        H.gun_offset(a,1,8.0,-32.0)
        H.at(a,v,0)
        -- 源0x42d8，409号。
        H.gun_transform(a,1,5,0,4,60,-999999,-0.02666666731238365,-999999.0)
        H.at(a,v,0)
        -- 源0x4308，409号。
        H.gun_transform(a,1,6,0,4096,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4338，355号。
        v.l[20]=H.int(130)
        H.at(a,v,0)
        -- 源0x435c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x4370，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4384，42号。
        H.push(v,270)
        H.at(a,v,0)
        -- 源0x4398，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x43ac，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x43c0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x43d4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x43ec，409号。
        H.gun_transform(a,0,3,0,4096,(v.l[28] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x441c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4430，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4444，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4454，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4468，438号。
        H.gun_distance(a,0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4480，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x449c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x44b0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x44c4，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x44d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x44e8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4548，409号。
        H.gun_transform(a,1,3,0,4096,(v.l[28] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4578，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x458c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x45a0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x45b0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x45c4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x45d8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x45ec，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x45fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4610，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x4624，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4634，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4644，409号。
        H.gun_transform(a,1,7,0,64,1,1,H.read(a,v,-1),3.0)
        H.at(a,v,0)
        -- 源0x4674，438号。
        H.gun_distance(a,1,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x468c，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x46a8，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x46bc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x46d0，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x46e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x46f4，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4754，409号。
        H.gun_transform(a,0,3,0,4096,(v.l[28] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4784，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4798，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x47ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x47bc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x47d0，438号。
        H.gun_distance(a,0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x47e8，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x4804，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4818，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x482c，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x4840，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4850，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x48b0，409号。
        H.gun_transform(a,1,3,0,4096,(v.l[28] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x48e0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x48f4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4908，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4918，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x492c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4940，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x4954，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4964，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4978，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x498c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x499c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x49ac，409号。
        H.gun_transform(a,1,7,0,64,1,1,H.read(a,v,-1),3.0)
        H.at(a,v,0)
        -- 源0x49dc，438号。
        H.gun_distance(a,1,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x49f4，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x4a10，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x4a24，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4a38，44号。
        H.push(v,0.14000000059604645)
        H.at(a,v,0)
        -- 源0x4a4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4a5c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4abc，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x4ad0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4ae4，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x4af4，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4b54，368号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4b74，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x4b88，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4ba0，10号。
        return
    end
    P["BossCard2_at"]=B.part1
end

-- stage01.ecl：BossDead，0x4bc0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4bc0，40号。
        H.at(a,v,0)
        -- 源0x4bd4，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x4be8，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x4c00，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x4c14，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x4c2c，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x4c44，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4c58，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4c6c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4c7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4c94，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4ccc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4ce4，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x4d1c，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x4d2c，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x4d3c，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x4d50，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0x4d60，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0x4d74，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x4d88，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x4d98，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x4db0，330号。
        H.drop_main(a,5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x4dc4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x4dd8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x4dec，327号。
        H.drop_extra(a,1,7)
        H.at(a,v,60)
        -- 源0x4e04，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,60)
        -- 源0x4e1c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0x4e34，329号。
        H.drop(a)
        H.at(a,v,60)
        -- 源0x4e44，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0x4e60，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0x4e78，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0x4e90，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0x4ea4，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0x4eb8，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

-- stage01.ecl：GGirl00，0x4ee8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4ee8，40号。
        H.at(a,v,0)
        -- 源0x4efc，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x4f10，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4f24，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x4f3c，11号。
        H.call(a,v,P["Girl00"],"Girl00",10,1)
        H.at(a,v,0)
        -- 源0x4f68，1号。
        H.erase(a);return
    end
    P["GGirl00"]=B.part1
end

-- stage01.ecl：GGirl02，0x4f88；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4f88，40号。
        H.at(a,v,0)
        -- 源0x4f9c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4fb0，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x4fc4，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x4fdc，11号。
        H.call(a,v,P["Girl02"],"Girl02",10,0)
        H.at(a,v,0)
        -- 源0x5008，1号。
        H.erase(a);return
    end
    P["GGirl02"]=B.part1
end

-- stage01.ecl：GGirl03，0x5028；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5028，40号。
        H.at(a,v,0)
        -- 源0x503c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x5050，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x5064，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x507c，11号。
        H.call(a,v,P["Girl03"],"Girl03",10)
        H.at(a,v,0)
        -- 源0x50a0，1号。
        H.erase(a);return
    end
    P["GGirl03"]=B.part1
end

-- stage01.ecl：GGirl05，0x50c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x50c0，40号。
        H.at(a,v,0)
        -- 源0x50d4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x50e8，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x50fc，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x5114，11号。
        H.call(a,v,P["Girl05"],"Girl05",10,0)
        H.at(a,v,0)
        -- 源0x5140，1号。
        H.erase(a);return
    end
    P["GGirl05"]=B.part1
end

-- stage01.ecl：Girl00，0x5160；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5160，40号。
        H.at(a,v,0)
        -- 源0x5174，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x5188，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x51a0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x51b4，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x51c8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x51e0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x51f8，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,0)
        -- 源0x520c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5220，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x5234，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5244，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5254，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5268，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x527c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x528c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x529c，284号。
        H.velocity(a,0,H.read(a,v,-1),8.0)
        H.at(a,v,30)
        -- 源0x52b4，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,80)
        -- 源0x52d4，15号。
        H.async(a,P["RGirl00_at"],"RGirl00_at",nil,(v.l[4] or 0))
        H.at(a,v,230)
        -- 源0x52fc，284号。
        H.velocity(a,0,0.39269909262657166,0.0)
        H.at(a,v,230)
        -- 源0x5314，285号。
        H.velocity_time(a,0,100,0,0.39269909262657166,3.0)
        H.at(a,v,6230)
        -- 源0x5334，0号。
        H.at(a,v,6230)
        -- 源0x5344，10号。
        return
    end
    P["Girl00"]=B.part1
end

-- stage01.ecl：Girl01，0x5364；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5364，40号。
        H.at(a,v,0)
        -- 源0x5378，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x538c，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x53a4，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x53b8，320号。
        H.hurtbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x53d0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x53e8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x53f8，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x5410，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x5428，284号。
        H.velocity(a,0,1.5707963705062866,6.0)
        H.at(a,v,0)
        -- 源0x5440，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,50)
        -- 源0x5460，15号。
        H.async(a,P["Girl01_at"],"Girl01_at",nil)
        H.at(a,v,350)
        -- 源0x5480，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,350)
        -- 源0x5498，285号。
        H.velocity_time(a,0,100,0,-999999.0,3.0)
        H.at(a,v,590)
        -- 源0x54b8，0号。
        H.at(a,v,590)
        -- 源0x54c8，17号。
        H.stop_thread(a,0)
        H.at(a,v,6590)
        -- 源0x54dc，0号。
        H.at(a,v,6590)
        -- 源0x54ec，1号。
        H.erase(a);return
    end
    P["Girl01"]=B.part1
end

-- stage01.ecl：Girl01_at，0x550c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x550c，40号。
        H.at(a,v,0)
        -- 源0x5520，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5534，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x5548，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5558，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5570，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5584，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x559c，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x55b8，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x55d4，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x55f0，405号。
        H.gun_speed(a,0,3.5,2.0)
        H.at(a,v,0)
        -- 源0x560c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x563c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x566c，401号。
        H.fire(a,0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5680，10号。
        return
    end
    P["Girl01_at"]=B.part1
end

-- stage01.ecl：Girl02，0x56b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x56b0，40号。
        H.at(a,v,0)
        -- 源0x56c4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x56d8，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x56f0，322号。
        H.flags(a,68,true)
        H.at(a,v,0)
        -- 源0x5704，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x571c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x5734，15号。
        H.async(a,P["RGirl02_at"],"RGirl02_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x575c，302号。
        H.ellipse(a,1,H.read(a,v,-9981),0.05235987901687622,64.0,0.0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x5784，284号。
        H.velocity(a,0,1.5707963705062866,1.0)
        H.at(a,v,6000)
        -- 源0x579c，0号。
        H.at(a,v,6000)
        -- 源0x57ac，10号。
        return
    end
    P["Girl02"]=B.part1
end

-- stage01.ecl：Girl03，0x57cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x57cc，40号。
        H.at(a,v,0)
        -- 源0x57e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x57f4，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x580c，322号。
        H.flags(a,68,true)
        H.at(a,v,0)
        -- 源0x5820，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x5838，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x5850，15号。
        H.async(a,P["RGirl03_at"],"RGirl03_at",nil)
        H.at(a,v,0)
        -- 源0x5870，302号。
        H.ellipse(a,1,H.read(a,v,-9981),0.03490658476948738,64.0,0.0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x5898，284号。
        H.velocity(a,0,1.5707963705062866,0.800000011920929)
        H.at(a,v,6000)
        -- 源0x58b0，0号。
        H.at(a,v,6000)
        -- 源0x58c0，10号。
        return
    end
    P["Girl03"]=B.part1
end

-- stage01.ecl：Girl04，0x58e0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x58e0，40号。
        H.at(a,v,0)
        -- 源0x58f4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x5908，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x5920，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x5934，320号。
        H.hurtbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x594c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x5964，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x5974，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x598c，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x59a4，284号。
        H.velocity(a,0,1.5707963705062866,6.0)
        H.at(a,v,0)
        -- 源0x59bc，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,50)
        -- 源0x59dc，15号。
        H.async(a,P["Girl04_at"],"Girl04_at",nil)
        H.at(a,v,50)
        -- 源0x59fc，15号。
        H.async(a,P["Girl04_at2"],"Girl04_at2",nil)
        H.at(a,v,50)
        -- 源0x5a1c，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,50)
        -- 源0x5a30，15号。
        H.async(a,P["Girl04_at"],"Girl04_at",nil)
        H.at(a,v,50)
        -- 源0x5a50，15号。
        H.async(a,P["Girl04_at2"],"Girl04_at2",nil)
        H.at(a,v,50)
        -- 源0x5a70，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,50)
        -- 源0x5a84，15号。
        H.async(a,P["Girl04_at"],"Girl04_at",nil)
        H.at(a,v,50)
        -- 源0x5aa4，15号。
        H.async(a,P["Girl04_at2"],"Girl04_at2",nil)
        H.at(a,v,150)
        -- 源0x5ac4，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,150)
        -- 源0x5adc，285号。
        H.velocity_time(a,0,100,0,-999999.0,3.0)
        H.at(a,v,330)
        -- 源0x5afc，0号。
        H.at(a,v,330)
        -- 源0x5b0c，17号。
        H.stop_thread(a,0)
        H.at(a,v,6330)
        -- 源0x5b20，0号。
        H.at(a,v,6330)
        -- 源0x5b30，1号。
        H.erase(a);return
    end
    P["Girl04"]=B.part1
end

-- stage01.ecl：Girl04_at，0x5b50；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5b50，40号。
        H.at(a,v,0)
        -- 源0x5b64，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5b78，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x5b90，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x5bac，436号。
        H.gun_count_diff(a,0,1,3,3,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x5be0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x5bf4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5c08，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x5c1c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5c2c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5c3c，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.15707963705062866)
        H.at(a,v,0)
        -- 源0x5c58，435号。
        H.gun_speed_diff(a,0,2.5,3.0,5.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x5c8c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x5ca8，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5cd8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5cec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5d00，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5d10，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5d28，409号。
        H.gun_transform(a,0,1,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x5d58，409号。
        H.gun_transform(a,0,2,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x5d88，409号。
        H.gun_transform(a,0,3,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x5db8，409号。
        H.gun_transform(a,0,4,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x5de8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5e00，409号。
        H.gun_transform(a,0,1,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x5e30，409号。
        H.gun_transform(a,0,2,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x5e60，409号。
        H.gun_transform(a,0,3,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x5e90，409号。
        H.gun_transform(a,0,4,0,8,16,-999999,0.0,-0.13089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5ec0，409号。
        H.gun_transform(a,0,5,0,4194304,3,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5ef0，355号。
        v.l[0]=H.int(30)
        H.at(a,v,0)
        -- 源0x5f14，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5f2c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5f40，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5f54，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x5f68，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5f80，10号。
        return
    end
    P["Girl04_at"]=B.part1
end

-- stage01.ecl：Girl04_at2，0x5fa0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5fa0，40号。
        H.at(a,v,0)
        -- 源0x5fb4，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x5fc8，407号。
        H.gun_aim(a,1,1)
        H.at(a,v,0)
        -- 源0x5fe0，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x5ffc，436号。
        H.gun_count_diff(a,1,1,3,3,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x6030，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x6044，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x6058，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x606c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x607c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x608c，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.15707963705062866)
        H.at(a,v,0)
        -- 源0x60a8，435号。
        H.gun_speed_diff(a,1,2.5,3.0,5.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x60dc，408号。
        H.gun_sound(a,1,7,-1)
        H.at(a,v,0)
        -- 源0x60f8，409号。
        H.gun_transform(a,1,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6128，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x613c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6150，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6160，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6178，409号。
        H.gun_transform(a,1,1,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x61a8，409号。
        H.gun_transform(a,1,2,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x61d8，409号。
        H.gun_transform(a,1,3,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6208，409号。
        H.gun_transform(a,1,4,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6238，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6250，409号。
        H.gun_transform(a,1,1,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6280，409号。
        H.gun_transform(a,1,2,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x62b0，409号。
        H.gun_transform(a,1,3,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x62e0，409号。
        H.gun_transform(a,1,4,0,8,16,-999999,0.0,0.13089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6310，409号。
        H.gun_transform(a,1,5,0,4194304,3,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6340，355号。
        v.l[0]=H.int(30)
        H.at(a,v,0)
        -- 源0x6364，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x637c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x6390，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x63a4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x63b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x63d0，10号。
        return
    end
    P["Girl04_at2"]=B.part1
end

-- stage01.ecl：Girl05，0x63f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x63f0，40号。
        H.at(a,v,0)
        -- 源0x6404，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6418，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6430，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6444，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x645c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6474，15号。
        H.async(a,P["RGirl05_at"],"RGirl05_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x649c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x64b0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x64c4，284号。
        H.velocity(a,0,H.read(a,v,-9981),4.0)
        H.at(a,v,30)
        -- 源0x64dc，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x64fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x6510，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x6524，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x6534，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,60)
        -- 源0x6548，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x655c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x656c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0x657c，285号。
        H.velocity_time(a,0,80,0,H.read(a,v,-1),4.0)
        H.at(a,v,110)
        -- 源0x659c，15号。
        H.async(a,P["RGirl05_at"],"RGirl05_at",nil,(v.l[4] or 0))
        H.at(a,v,6110)
        -- 源0x65c4，0号。
        H.at(a,v,6110)
        -- 源0x65d4，10号。
        return
    end
    P["Girl05"]=B.part1
end

-- stage01.ecl：Girl06，0x65f4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x65f4，40号。
        H.at(a,v,0)
        -- 源0x6608，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x661c，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x6634，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6648，320号。
        H.hurtbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x6660，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6678，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6688，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x66a0，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x66b8，284号。
        H.velocity(a,0,1.5707963705062866,6.0)
        H.at(a,v,0)
        -- 源0x66d0，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,50)
        -- 源0x66f0，15号。
        H.async(a,P["Girl06_at"],"Girl06_at",nil)
        H.at(a,v,50)
        -- 源0x6710，15号。
        H.async(a,P["Girl06_at2"],"Girl06_at2",nil)
        H.at(a,v,50)
        -- 源0x6730，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,50)
        -- 源0x6744，15号。
        H.async(a,P["Girl06_at"],"Girl06_at",nil)
        H.at(a,v,50)
        -- 源0x6764，15号。
        H.async(a,P["Girl06_at2"],"Girl06_at2",nil)
        H.at(a,v,250)
        -- 源0x6784，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,250)
        -- 源0x679c，285号。
        H.velocity_time(a,0,100,0,-999999.0,3.0)
        H.at(a,v,430)
        -- 源0x67bc，0号。
        H.at(a,v,430)
        -- 源0x67cc，17号。
        H.stop_thread(a,0)
        H.at(a,v,6430)
        -- 源0x67e0，0号。
        H.at(a,v,6430)
        -- 源0x67f0，1号。
        H.erase(a);return
    end
    P["Girl06"]=B.part1
end

-- stage01.ecl：Girl06_at，0x6810；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6810，40号。
        H.at(a,v,0)
        -- 源0x6824，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6838，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x6850，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x686c，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0x68a0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x68b4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x68c8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x68dc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x68ec，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x68fc，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.15707963705062866)
        H.at(a,v,0)
        -- 源0x6918，435号。
        H.gun_speed_diff(a,0,2.5,3.0,5.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x694c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x6968，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6998，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x69ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x69c0，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x69d0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x69e8，409号。
        H.gun_transform(a,0,1,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6a18，409号。
        H.gun_transform(a,0,2,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6a48，409号。
        H.gun_transform(a,0,3,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6a78，409号。
        H.gun_transform(a,0,4,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6aa8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6ac0，409号。
        H.gun_transform(a,0,1,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6af0，409号。
        H.gun_transform(a,0,2,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6b20，409号。
        H.gun_transform(a,0,3,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6b50，409号。
        H.gun_transform(a,0,4,0,8,16,-999999,0.0,-0.13089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6b80，409号。
        H.gun_transform(a,0,5,0,4194304,3,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6bb0，355号。
        v.l[0]=H.int(30)
        H.at(a,v,0)
        -- 源0x6bd4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6bec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x6c00，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x6c14，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x6c28，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x6c40，10号。
        return
    end
    P["Girl06_at"]=B.part1
end

-- stage01.ecl：Girl06_at2，0x6c60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6c60，40号。
        H.at(a,v,0)
        -- 源0x6c74，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x6c88，407号。
        H.gun_aim(a,1,1)
        H.at(a,v,0)
        -- 源0x6ca0，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x6cbc，436号。
        H.gun_count_diff(a,1,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0x6cf0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x6d04，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x6d18，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x6d2c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6d3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6d4c，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.15707963705062866)
        H.at(a,v,0)
        -- 源0x6d68，435号。
        H.gun_speed_diff(a,1,2.5,3.0,5.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x6d9c，408号。
        H.gun_sound(a,1,7,-1)
        H.at(a,v,0)
        -- 源0x6db8，409号。
        H.gun_transform(a,1,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6de8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x6dfc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6e10，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6e20，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6e38，409号。
        H.gun_transform(a,1,1,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6e68，409号。
        H.gun_transform(a,1,2,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6e98，409号。
        H.gun_transform(a,1,3,0,8,30,-999999,0.0,-0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6ec8，409号。
        H.gun_transform(a,1,4,0,8,30,-999999,0.0,0.06981316953897476)
        H.at(a,v,0)
        -- 源0x6ef8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6f10，409号。
        H.gun_transform(a,1,1,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6f40，409号。
        H.gun_transform(a,1,2,0,8,16,-999999,0.0,0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6f70，409号。
        H.gun_transform(a,1,3,0,8,16,-999999,0.0,-0.13089969754219055)
        H.at(a,v,0)
        -- 源0x6fa0，409号。
        H.gun_transform(a,1,4,0,8,16,-999999,0.0,0.13089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6fd0，409号。
        H.gun_transform(a,1,5,0,4194304,3,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7000，355号。
        v.l[0]=H.int(30)
        H.at(a,v,0)
        -- 源0x7024，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x703c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x7050，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7064，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x7078，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7090，10号。
        return
    end
    P["Girl06_at2"]=B.part1
end

-- stage01.ecl：MBoss，0x70b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x70b0，40号。
        H.at(a,v,0)
        -- 源0x70c4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x70d8，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x70ec，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7100，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7114，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7128，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x713c，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x7150，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x7164，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x717c，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0x7194，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x71a8，259号。
        H.anm_slot(a,0,0)
        H.at(a,v,0)
        -- 源0x71c0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x71d4，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x71ec，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x7218，331号。
        H.life(a,9200)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x7264，347号。
        H.life_marker(a,0,5200.0,-3092225)
        H.at(a,v,0)
        -- 源0x7280，347号。
        H.life_marker(a,1,900.0,-24448)
        H.at(a,v,0)
        -- 源0x729c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x7334，334号。
        H.interrupt(a,0,5200,0,"MBoss2")
        H.at(a,v,0)
        -- 源0x735c，334号。
        H.interrupt(a,1,0,1020,"MBossDead")
        H.at(a,v,0)
        -- 源0x7388，341号。
        H.timeout(a,1,"MBossEscape")
        H.at(a,v,0)
        -- 源0x73ac，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x73c0，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x73d4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x73ec，11号。
        H.call(a,v,P["MBoss_at1"],"MBoss_at1")
        H.at(a,v,0)
        -- 源0x740c，284号。
        H.velocity(a,0,1.5707963705062866,5.5)
        H.at(a,v,0)
        -- 源0x7424，285号。
        H.velocity_time(a,0,100,4,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x7444，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x7458，11号。
        H.call(a,v,P["MBoss_at2"],"MBoss_at2")
        H.at(a,v,0)
        -- 源0x7478，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x748c，281号。
        H.position_time(a,0,60,4,H.read(a,v,-9965),128.0)
        H.at(a,v,0)
        -- 源0x74ac，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x74c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x74d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x74ec，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7504，83号。
        v.origin=v.origin+H.int(1000)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7518，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x752c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7544，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage01.ecl：MBoss2，0x7564；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7564，40号。
        H.at(a,v,0)
        -- 源0x7578，344号。
        a.chapter=7
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x75b4，334号。
        H.interrupt(a,0,900,0,"MBossCard1")
        H.at(a,v,0)
        -- 源0x75e0，334号。
        H.interrupt(a,1,0,1020,"MBossDead")
        H.at(a,v,0)
        -- 源0x760c，341号。
        H.timeout(a,1,"MBossEscape")
        H.at(a,v,0)
        -- 源0x7630，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7640，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x7654，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7668，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7678，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7690，330号。
        H.drop_main(a,5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x76a4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x76b8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x76cc，327号。
        H.drop_extra(a,1,1)
        H.at(a,v,0)
        -- 源0x76e4，327号。
        H.drop_extra(a,2,2)
        H.at(a,v,0)
        -- 源0x76fc，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7714，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x7724，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7738，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x774c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7760，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7774，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x7784，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x7798，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x77cc，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x77e0，259号。
        H.anm_slot(a,0,0)
        H.at(a,v,0)
        -- 源0x77f8，281号。
        H.position_time(a,0,60,4,0.0,160.0)
        H.at(a,v,0)
        -- 源0x7818，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x782c，0号。
        H.at(a,v,60)
        -- 源0x783c，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x7854，15号。
        H.async(a,P["MBoss2_at"],"MBoss2_at",nil)
        H.at(a,v,120)
        -- 源0x7874，12号。
        v.origin=H.clock(a)-(120);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,120)
        -- 源0x788c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,120)
        -- 源0x78a0，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x78b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,120)
        -- 源0x78cc，1号。
        H.erase(a);return
    end
    P["MBoss2"]=B.part1
end

-- stage01.ecl：MBoss2_at，0x78ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x78ec，40号。
        H.at(a,v,0)
        -- 源0x7900，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x7914，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7928，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x793c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7950，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7964，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x797c，402号。
        H.gun_sprite(a,0,7,1)
        H.at(a,v,0)
        -- 源0x7998，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x79b4，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x79d0，405号。
        H.gun_speed(a,0,0.4000000059604645,1.0)
        H.at(a,v,0)
        -- 源0x79ec，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7a1c，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.036666665226221085,-999999.0)
        H.at(a,v,0)
        -- 源0x7a4c，438号。
        H.gun_distance(a,0,20.0)
        H.at(a,v,0)
        -- 源0x7a64，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0x7a7c，402号。
        H.gun_sprite(a,1,7,2)
        H.at(a,v,0)
        -- 源0x7a98，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.028333334252238274,-999999.0)
        H.at(a,v,0)
        -- 源0x7ac8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x7adc，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x7af0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7b00，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7b18，409号。
        H.gun_transform(a,1,1,0,4,60,-999999,0.05000000074505806,-999999.0)
        H.at(a,v,0)
        -- 源0x7b48，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.03500000014901161,-999999.0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7b78，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7b90，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7bac，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7bc0，44号。
        H.push(v,3.8832221031188965)
        H.at(a,v,0)
        -- 源0x7bd4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7be4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7bf8，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x7c0c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7c20，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7c3c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7c50，44号。
        H.push(v,7.766444206237793)
        H.at(a,v,0)
        -- 源0x7c64，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x7c74，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7c88，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x7c9c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x7cb0，368号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7cd0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7ce4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7cfc，10号。
        return
    end
    P["MBoss2_at"]=B.part1
end

-- stage01.ecl：MBoss3，0x7d1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7d1c，40号。
        H.at(a,v,0)
        -- 源0x7d30，344号。
        a.chapter=8
        H.at(a,v,0)
        -- 源0x7d44，334号。
        H.interrupt(a,1,0,1020,"MBossDead")
        H.at(a,v,0)
        -- 源0x7d70，341号。
        H.timeout(a,1,"MBossEscape")
        H.at(a,v,0)
        -- 源0x7d94，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7da4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x7db8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7dcc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7ddc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7df4，330号。
        H.drop_main(a,5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7e08，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7e1c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7e30，327号。
        H.drop_extra(a,1,1)
        H.at(a,v,0)
        -- 源0x7e48，327号。
        H.drop_extra(a,2,2)
        H.at(a,v,0)
        -- 源0x7e60，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7e78，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x7e88，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7e9c，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7eb0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x7ec0，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x7ed4，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x7f08，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x7f1c，259号。
        H.anm_slot(a,0,0)
        H.at(a,v,0)
        -- 源0x7f34，281号。
        H.position_time(a,0,60,4,0.0,160.0)
        H.at(a,v,0)
        -- 源0x7f54，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x7f68，0号。
        H.at(a,v,60)
        -- 源0x7f78，15号。
        H.async(a,P["MBoss3_at"],"MBoss3_at",nil)
        H.at(a,v,60)
        -- 源0x7f98，324号。
        H.limit(a,0.0,160.0,280.0,64.0)
        H.at(a,v,60)
        -- 源0x7fb8，12号。
        v.origin=H.clock(a)-(60);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x7fd0，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,60)
        -- 源0x7fec，83号。
        v.origin=v.origin+H.int(100)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x8000，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x8014，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x802c，12号。
        v.origin=H.clock(a)-(60);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x8044，83号。
        v.origin=v.origin+H.int(1000)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x8058，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x806c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x8084，1号。
        H.erase(a);return
    end
    P["MBoss3"]=B.part1
end

-- stage01.ecl：MBoss3_at，0x80a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x80a4，40号。
        H.at(a,v,0)
        -- 源0x80b8，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x80cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x80e0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x80f4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8108，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x811c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x8134，402号。
        H.gun_sprite(a,0,7,3)
        H.at(a,v,0)
        -- 源0x8150，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x816c，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x8188，435号。
        H.gun_speed_diff(a,0,0.4000000059604645,0.4000000059604645,1.399999976158142,2.4000000953674316,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x81bc，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x81ec，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.0416666679084301,-999999.0)
        H.at(a,v,0)
        -- 源0x821c，438号。
        H.gun_distance(a,0,20.0)
        H.at(a,v,0)
        -- 源0x8234，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0x824c，402号。
        H.gun_sprite(a,1,7,4)
        H.at(a,v,0)
        -- 源0x8268，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0x8298，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x82b0，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x82cc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x82e0，44号。
        H.push(v,3.8832221031188965)
        H.at(a,v,0)
        -- 源0x82f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8304，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8318，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x832c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x8340，404号。
        H.gun_angle(a,1,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x835c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8370，44号。
        H.push(v,7.766444206237793)
        H.at(a,v,0)
        -- 源0x8384，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x8394，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x83a8，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x83bc，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x83d0，368号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x83f0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8404，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x841c，10号。
        return
    end
    P["MBoss3_at"]=B.part1
end

-- stage01.ecl：MBossCard1，0x843c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x843c，40号。
        H.at(a,v,0)
        -- 源0x8450，334号。
        H.interrupt(a,0,0,2160,"MBossDead")
        H.at(a,v,0)
        -- 源0x847c，341号。
        H.timeout(a,0,"MBossEscape")
        H.at(a,v,0)
        -- 源0x84a0，324号。
        H.limit(a,0.0,80.0,384.0,64.0)
        H.at(a,v,0)
        -- 源0x84c0，359号。
        H.spell(a,0,2160,500000,"怪奇「釣瓶落としの怪」",359)
        H.at(a,v,0)
        -- 源0x84f8，344号。
        a.chapter=15
        H.at(a,v,0)
        -- 源0x850c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8520，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8534，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8544，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x855c，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x8570，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8580，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8594，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x85a8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x85b8，281号。
        H.position_time(a,0,60,4,0.0,80.0)
        H.at(a,v,0)
        -- 源0x85d8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x85ec，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x8600，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,60)
        -- 源0x8634，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x864c，0号。
        H.at(a,v,150)
        -- 源0x865c，0号。
        H.at(a,v,150)
        -- 源0x866c，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil)
        H.at(a,v,150)
        -- 源0x8690，15号。
        H.async(a,P["MBossCard1_at2"],"MBossCard1_at2",nil)
        H.at(a,v,150)
        -- 源0x86b4，12号。
        v.origin=H.clock(a)-(150);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x86cc，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x86e0，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x86f4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x870c，1号。
        H.erase(a);return
    end
    P["MBossCard1"]=B.part1
end

-- stage01.ecl：MBossCard1_at，0x872c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x872c，40号。
        H.at(a,v,0)
        -- 源0x8740，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x8754，407号。
        H.gun_aim(a,1,1)
        H.at(a,v,0)
        -- 源0x876c，402号。
        H.gun_sprite(a,1,12,4)
        H.at(a,v,0)
        -- 源0x8788，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x87a4，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x87c0，405号。
        H.gun_speed(a,1,0.0,2.0)
        H.at(a,v,0)
        -- 源0x87dc，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x880c，409号。
        H.gun_transform(a,1,1,0,4096,180,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x883c，409号。
        H.gun_transform(a,1,2,0,4,120,-999999,0.06666667014360428,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x886c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8884，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8898，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x88ac，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x88bc，437号。
        H.gun_polar(a,1,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x88d8，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x88ec，368号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x890c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8920，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8938，10号。
        return
    end
    P["MBossCard1_at"]=B.part1
end

-- stage01.ecl：MBossCard1_at2，0x8958；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8958，40号。
        H.at(a,v,0)
        -- 源0x896c，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,0.03333333507180214,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x899c，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0x89b8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x89d0，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x89e4，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x89f8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8a08，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8a20，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8a34，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8a48，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8a58，44号。
        H.push(v,1.5)
        H.at(a,v,0)
        -- 源0x8a6c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8a7c，284号。
        H.velocity(a,0,0.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x8a94，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8aac，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8ac0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8ad4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8ae4，44号。
        H.push(v,1.5)
        H.at(a,v,0)
        -- 源0x8af8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8b08，284号。
        H.velocity(a,0,3.1415927410125732,H.read(a,v,-1))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8b20，285号。
        H.velocity_time(a,0,60,4,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x8b40，431号。
        H.laser(a,431,12,1,1.5707963705062866,4.0,0,224.0,512.0,64.0)
        H.at(a,v,0)
        -- 源0x8b70，431号。
        H.laser(a,431,12,1,1.0471975803375244,4.0,0,224.0,512.0,64.0)
        H.at(a,v,0)
        -- 源0x8ba0，431号。
        H.laser(a,431,12,1,2.094395160675049,4.0,0,224.0,512.0,64.0)
        H.at(a,v,0)
        -- 源0x8bd0，83号。
        v.origin=v.origin+H.int(60)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8be4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8bf8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8c10，10号。
        return
    end
    P["MBossCard1_at2"]=B.part1
end

-- stage01.ecl：MBossDead，0x8c30；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8c30，40号。
        H.at(a,v,0)
        -- 源0x8c44，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x8c58，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8c68，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x8c7c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8c90，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8ca0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8cb8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8ccc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8ce0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8cf0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8d08，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x8d3c，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8d54，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8d8c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8da4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8db8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8dcc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8ddc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8df4，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x8e08，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8e20，421号。
        H.cancel(a,640.0,false)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x8e34，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8e44，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8e58，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8e6c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8e7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x8e94，330号。
        H.drop_main(a,5)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x8ea8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8ebc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8ed0，327号。
        H.drop_extra(a,1,5)
        H.at(a,v,0)
        -- 源0x8ee8，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,0)
        -- 源0x8f00，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x8f18，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x8f28，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x8f3c，337号。
        H.shake(a,30,12,0)
        H.at(a,v,0)
        -- 源0x8f58，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x8f70，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x8f84，344号。
        a.chapter=0
        H.at(a,v,0)
        -- 源0x8f98，1号。
        H.erase(a);return
    end
    P["MBossDead"]=B.part1
end

-- stage01.ecl：MBossEscape，0x8fc8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8fc8，40号。
        H.at(a,v,0)
        -- 源0x8fdc，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0x9000，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0x9024，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x9034，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x9044，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9058，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x906c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x907c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9094，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x90a8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x90c0，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x90d4，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x90e8，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x90fc，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x9110，281号。
        H.position_time(a,0,60,4,0.0,-32.0)
        H.at(a,v,60)
        -- 源0x9130，344号。
        a.chapter=0
        H.at(a,v,60)
        -- 源0x9144，1号。
        H.erase(a);return
    end
    P["MBossEscape"]=B.part1
end

-- stage01.ecl：MBoss_at1，0x9174；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9174，40号。
        H.at(a,v,0)
        -- 源0x9188，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x919c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x91b4，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x91d0，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x91ec，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x9208，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0x9224，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9254，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9284，438号。
        H.gun_distance(a,0,24.0)
        H.at(a,v,0)
        -- 源0x929c，435号。
        H.gun_speed_diff(a,0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x92d0，355号。
        v.l[0]=H.int(11)
        H.at(a,v,0)
        -- 源0x92f4，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x9308，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x931c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9334，406号。
        H.gun_count(a,0,(v.l[0] or 0),1)
        H.at(a,v,0)
        -- 源0x9350，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9364，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9378，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x938c，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x939c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x93b0，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x93c4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x93d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x93f0，10号。
        return
    end
    P["MBoss_at1"]=B.part1
end

-- stage01.ecl：MBoss_at2，0x9410；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9410，40号。
        H.at(a,v,0)
        -- 源0x9424，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x9438，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x9450，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0x946c，436号。
        H.gun_count_diff(a,0,6,8,16,32,1,1,2,2)
        H.at(a,v,0)
        -- 源0x94a0，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x94bc，435号。
        H.gun_speed_diff(a,0,0.800000011920929,0.800000011920929,1.2000000476837158,1.7999999523162842,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x94f0，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9520，438号。
        H.gun_distance(a,0,24.0)
        H.at(a,v,0)
        -- 源0x9538，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x954c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9560，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9570，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9588，407号。
        H.gun_aim(a,0,4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x95a0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x95b4，10号。
        return
    end
    P["MBoss_at2"]=B.part1
end

-- stage01.ecl：MainBossDebug，0x95d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x95d4，40号。
        H.at(a,v,120)
        -- 源0x95e8，338号。
        H.dialog(a,0)
        H.at(a,v,120)
        -- 源0x95fc，500号。
        H.debug_entry(a,3)
        H.at(a,v,120)
        -- 源0x9610，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x9620，257号。
        H.spawn(a,257,"Boss",-144.0,-16.0,40,1000,1)
        H.at(a,v,120)
        -- 源0x9650，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x9660，340号。
        H.boss_wait(a,v)
        H.at(a,v,180)
        -- 源0x9670，338号。
        H.dialog(a,1)
        H.at(a,v,180)
        -- 源0x9684，339号。
        H.dialog_wait(a,v)
        H.at(a,v,180)
        -- 源0x9694，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage01.ecl：MainMBossDebug，0x96c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x96c4，40号。
        H.at(a,v,0)
        -- 源0x96d8，500号。
        H.debug_entry(a,1)
        H.at(a,v,0)
        -- 源0x96ec，257号。
        H.spawn(a,257,"MBoss",0.0,-32.0,40,1000,1)
        H.at(a,v,0)
        -- 源0x971c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9734，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9748，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x975c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9774，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage01.ecl：MainMsgDebug，0x9794；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9794，40号。
        H.at(a,v,0)
        -- 源0x97a8，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0x97bc，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x97d0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0x97e0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x97f0，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0x9804，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x9814，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0x982c，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0x983c，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0x9850，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0x9868，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage01.ecl：MainSub00，0x9888；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9888，40号。
        H.at(a,v,0)
        -- 源0x989c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x98b0，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x98c4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x98d8，257号。
        H.spawn(a,257,"Girl01",0.0,-32.0,1200,1000,2)
        H.at(a,v,0)
        -- 源0x9908，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage01.ecl：MainSub01，0x9928；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9928，40号。
        H.at(a,v,0)
        -- 源0x993c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9950，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9964，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x997c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9990，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x99a4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x99b4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x99c8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x99d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x99f0，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x9a04，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x9a18，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9a2c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9a3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9a4c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9a60，257号。
        H.spawn(a,257,"RGirl00",(v.l[4] or 0),464.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x9a90，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9aa8，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x9abc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x9ad0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9ae4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9af4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x9b04，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9b18，261号。
        H.spawn(a,261,"RGirl00",(v.l[4] or 0),464.0,20,1000,1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9b48，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x9b5c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9b70，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9b84，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x9b94，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9ba8，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9bbc，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x9bd0，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9be0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9bf8，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage01.ecl：MainSub02，0x9c18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9c18，40号。
        H.at(a,v,0)
        -- 源0x9c2c，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x9c40，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9c54，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x9c68，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9c7c，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,0)
        -- 源0x9cac，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9cc0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9cd4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x9ce4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9cf8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x9d0c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0x9d20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9d30，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,20)
        -- 源0x9d44，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,20)
        -- 源0x9d74，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,20)
        -- 源0x9d88，42号。
        H.push(v,32)
        H.at(a,v,20)
        -- 源0x9d9c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,20)
        -- 源0x9dac，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,20)
        -- 源0x9dc0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,20)
        -- 源0x9dd4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,20)
        -- 源0x9de8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,20)
        -- 源0x9df8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,40)
        -- 源0x9e0c，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,40)
        -- 源0x9e3c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,40)
        -- 源0x9e50，42号。
        H.push(v,32)
        H.at(a,v,40)
        -- 源0x9e64，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,40)
        -- 源0x9e74，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,40)
        -- 源0x9e88，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,40)
        -- 源0x9e9c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,40)
        -- 源0x9eb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,40)
        -- 源0x9ec0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x9ed4，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,60)
        -- 源0x9f04，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x9f18，42号。
        H.push(v,32)
        H.at(a,v,60)
        -- 源0x9f2c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0x9f3c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0x9f50，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x9f64，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,60)
        -- 源0x9f78，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x9f88，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,80)
        -- 源0x9f9c，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,80)
        -- 源0x9fcc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,80)
        -- 源0x9fe0，42号。
        H.push(v,32)
        H.at(a,v,80)
        -- 源0x9ff4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,80)
        -- 源0xa004，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0xa018，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,80)
        -- 源0xa02c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,80)
        -- 源0xa040，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,80)
        -- 源0xa050，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,100)
        -- 源0xa064，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,100)
        -- 源0xa094，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,100)
        -- 源0xa0a8，42号。
        H.push(v,32)
        H.at(a,v,100)
        -- 源0xa0bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,100)
        -- 源0xa0cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,100)
        -- 源0xa0e0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,100)
        -- 源0xa0f4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,100)
        -- 源0xa108，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,100)
        -- 源0xa118，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0xa12c，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,120)
        -- 源0xa15c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,120)
        -- 源0xa170，42号。
        H.push(v,32)
        H.at(a,v,120)
        -- 源0xa184，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,120)
        -- 源0xa194，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,120)
        -- 源0xa1a8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0xa1bc，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,120)
        -- 源0xa1d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0xa1e0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,140)
        -- 源0xa1f4，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,140)
        -- 源0xa224，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,140)
        -- 源0xa238，42号。
        H.push(v,32)
        H.at(a,v,140)
        -- 源0xa24c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,140)
        -- 源0xa25c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,140)
        -- 源0xa270，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,140)
        -- 源0xa284，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,140)
        -- 源0xa298，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,140)
        -- 源0xa2a8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,160)
        -- 源0xa2bc，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,160)
        -- 源0xa2ec，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,160)
        -- 源0xa300，42号。
        H.push(v,32)
        H.at(a,v,160)
        -- 源0xa314，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,160)
        -- 源0xa324，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,160)
        -- 源0xa338，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,160)
        -- 源0xa34c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,160)
        -- 源0xa360，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,160)
        -- 源0xa370，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,180)
        -- 源0xa384，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,180)
        -- 源0xa3b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,180)
        -- 源0xa3c8，42号。
        H.push(v,32)
        H.at(a,v,180)
        -- 源0xa3dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,180)
        -- 源0xa3ec，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,180)
        -- 源0xa400，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,180)
        -- 源0xa414，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,180)
        -- 源0xa428，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,180)
        -- 源0xa438，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,200)
        -- 源0xa44c，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,200)
        -- 源0xa47c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,200)
        -- 源0xa490，42号。
        H.push(v,32)
        H.at(a,v,200)
        -- 源0xa4a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,200)
        -- 源0xa4b4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,200)
        -- 源0xa4c8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,200)
        -- 源0xa4dc，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,200)
        -- 源0xa4f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,200)
        -- 源0xa500，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,220)
        -- 源0xa514，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,220)
        -- 源0xa544，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,220)
        -- 源0xa558，42号。
        H.push(v,32)
        H.at(a,v,220)
        -- 源0xa56c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,220)
        -- 源0xa57c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,220)
        -- 源0xa590，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,220)
        -- 源0xa5a4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,220)
        -- 源0xa5b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,220)
        -- 源0xa5c8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,240)
        -- 源0xa5dc，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,240)
        -- 源0xa60c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,240)
        -- 源0xa620，42号。
        H.push(v,32)
        H.at(a,v,240)
        -- 源0xa634，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,240)
        -- 源0xa644，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,240)
        -- 源0xa658，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,240)
        -- 源0xa66c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,240)
        -- 源0xa680，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,240)
        -- 源0xa690，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,260)
        -- 源0xa6a4，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,260)
        -- 源0xa6d4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,260)
        -- 源0xa6e8，42号。
        H.push(v,32)
        H.at(a,v,260)
        -- 源0xa6fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0xa70c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0xa720，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,260)
        -- 源0xa734，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,260)
        -- 源0xa748，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0xa758，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,280)
        -- 源0xa76c，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,280)
        -- 源0xa79c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,280)
        -- 源0xa7b0，42号。
        H.push(v,32)
        H.at(a,v,280)
        -- 源0xa7c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,280)
        -- 源0xa7d4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,280)
        -- 源0xa7e8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,280)
        -- 源0xa7fc，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,280)
        -- 源0xa810，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,280)
        -- 源0xa820，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,300)
        -- 源0xa834，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,300)
        -- 源0xa864，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,300)
        -- 源0xa878，42号。
        H.push(v,32)
        H.at(a,v,300)
        -- 源0xa88c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,300)
        -- 源0xa89c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,300)
        -- 源0xa8b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,300)
        -- 源0xa8c4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,300)
        -- 源0xa8d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,300)
        -- 源0xa8e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,320)
        -- 源0xa8fc，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,320)
        -- 源0xa92c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,320)
        -- 源0xa940，42号。
        H.push(v,32)
        H.at(a,v,320)
        -- 源0xa954，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,320)
        -- 源0xa964，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,320)
        -- 源0xa978，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,320)
        -- 源0xa98c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,320)
        -- 源0xa9a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,320)
        -- 源0xa9b0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,340)
        -- 源0xa9c4，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,340)
        -- 源0xa9f4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,340)
        -- 源0xaa08，42号。
        H.push(v,32)
        H.at(a,v,340)
        -- 源0xaa1c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,340)
        -- 源0xaa2c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,340)
        -- 源0xaa40，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,340)
        -- 源0xaa54，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,340)
        -- 源0xaa68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,340)
        -- 源0xaa78，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,360)
        -- 源0xaa8c，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,360)
        -- 源0xaabc，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage01.ecl：MainSub03，0xaadc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaadc，40号。
        H.at(a,v,0)
        -- 源0xaaf0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xab04，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xab18，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0xab2c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xab40，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xab54，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xab64，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xab74，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xab88，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xab9c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xabb0，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0xabc4，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xabd8，257号。
        H.spawn(a,257,"RockB",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0xac08，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xac1c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xac30，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xac48，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0xac5c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xac70，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xac84，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xac94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaca4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xacb8，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xaccc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xace0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xacf4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xad04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xad14，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xad28，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xad3c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xad50，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xad64，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xad74，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xad84，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xad98，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xadac，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xadc0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xadd0，257号。
        H.spawn(a,257,"RockS",H.read(a,v,-1),-32.0,20,1000,3)
        H.at(a,v,0)
        -- 源0xae00，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xae14，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xae28，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xae40，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage01.ecl：MainSub04，0xae60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xae60，40号。
        H.at(a,v,0)
        -- 源0xae74，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0xae88，257号。
        H.spawn(a,257,"Girl04",128.0,-32.0,700,1000,3)
        H.at(a,v,0)
        -- 源0xaeb8，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0xaecc，257号。
        H.spawn(a,257,"Girl04",-128.0,-32.0,700,1000,3)
        H.at(a,v,0)
        -- 源0xaefc，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage01.ecl：MainSub05，0xaf1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaf1c，40号。
        H.at(a,v,0)
        -- 源0xaf30，11号。
        H.call(a,v,P["MainSub05L"],"MainSub05L")
        H.at(a,v,0)
        -- 源0xaf50，11号。
        H.call(a,v,P["MainSub05R"],"MainSub05R")
        H.at(a,v,0)
        -- 源0xaf70，15号。
        H.async(a,P["MainSub05L"],"MainSub05L",nil)
        H.at(a,v,0)
        -- 源0xaf90，15号。
        H.async(a,P["MainSub05R"],"MainSub05R",nil)
        H.at(a,v,0)
        -- 源0xafb0，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage01.ecl：MainSub05L，0xafd0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xafd0，40号。
        H.at(a,v,0)
        -- 源0xafe4，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0xaff8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb00c，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb03c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb050，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb064，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb078，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb088，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb09c，257号。
        H.spawn(a,257,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb0cc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb0e0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb0f4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb108，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb118，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb12c，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb15c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb170，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb184，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb198，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb1a8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb1bc，257号。
        H.spawn(a,257,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb1ec，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb200，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb214，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb228，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb238，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb24c，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb27c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb290，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb2a4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb2b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb2c8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb2dc，257号。
        H.spawn(a,257,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb30c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb320，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb334，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb348，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb358，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb36c，257号。
        H.spawn(a,257,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb39c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb3b0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb3c4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb3d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb3e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb3fc，10号。
        return
    end
    P["MainSub05L"]=B.part1
end

-- stage01.ecl：MainSub05R，0xb41c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb41c，40号。
        H.at(a,v,0)
        -- 源0xb430，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0xb444，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb458，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb488，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb49c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb4b0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb4c4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb4d4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb4e8，257号。
        H.spawn(a,257,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb518，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb52c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb540，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb554，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb564，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb578，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb5a8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb5bc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb5d0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb5e4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb5f4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb608，257号。
        H.spawn(a,257,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb638，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb64c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb660，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb674，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb684，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb698，257号。
        H.spawn(a,257,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb6c8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb6dc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb6f0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb704，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb714，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb728，257号。
        H.spawn(a,257,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb758，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb76c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb780，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb794，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb7a4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb7b8，257号。
        H.spawn(a,257,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xb7e8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xb7fc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb810，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xb824，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb834，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb848，10号。
        return
    end
    P["MainSub05R"]=B.part1
end

-- stage01.ecl：MainSub06，0xb868；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb868，40号。
        H.at(a,v,0)
        -- 源0xb87c，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xb89c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb8b0，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xb8d0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb8e4，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xb904，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb918，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xb938，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb94c，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xb96c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb980，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xb9a0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb9b4，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xb9d4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb9e8，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xba08，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xba1c，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xba3c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xba50，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xba70，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xba84，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xbaa4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xbab8，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xbad8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xbaec，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xbb0c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xbb20，15号。
        H.async(a,P["MainSub06R"],"MainSub06R",nil)
        H.at(a,v,0)
        -- 源0xbb40，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xbb54，15号。
        H.async(a,P["MainSub06L"],"MainSub06L",nil)
        H.at(a,v,0)
        -- 源0xbb74，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xbb88，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage01.ecl：MainSub06L，0xbba8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbba8，40号。
        H.at(a,v,0)
        -- 源0xbbbc，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0xbbd0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbbe4，266号。
        H.spawn(a,266,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbc14，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbc28，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbc3c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbc50，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbc60，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbc74，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbca4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbcb8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbccc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbce0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbcf0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbd04，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbd34，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbd48，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbd5c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbd70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbd80，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbd94，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbdc4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbdd8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbdec，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbe00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbe10，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbe24，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbe54，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbe68，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbe7c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbe90，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbea0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbeb4，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbee4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbef8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbf0c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbf20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbf30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbf44，266号。
        H.spawn(a,266,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xbf74，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xbf88，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbf9c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xbfb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbfc0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbfd4，10号。
        return
    end
    P["MainSub06L"]=B.part1
end

-- stage01.ecl：MainSub06R，0xbff4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbff4，40号。
        H.at(a,v,0)
        -- 源0xc008，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0xc01c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc030，266号。
        H.spawn(a,266,"RGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc060，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc074，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc088，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc09c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc0ac，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc0c0，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc0f0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc104，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc118，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc12c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc13c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc150，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc180，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc194，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc1a8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc1bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc1cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc1e0，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc210，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc224，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc238，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc24c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc25c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc270，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc2a0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc2b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc2c8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc2dc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc2ec，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc300，266号。
        H.spawn(a,266,"GGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc330，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc344，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc358，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc36c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc37c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc390，266号。
        H.spawn(a,266,"BGirl05",(v.l[0] or 0),-32.0,70,1000,1)
        H.at(a,v,0)
        -- 源0xc3c0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xc3d4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc3e8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xc3fc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc40c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc420，10号。
        return
    end
    P["MainSub06R"]=B.part1
end

-- stage01.ecl：MainSub07，0xc440；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc440，40号。
        H.at(a,v,0)
        -- 源0xc454，257号。
        H.spawn(a,257,"Girl06",-128.0,-32.0,500,1000,3)
        H.at(a,v,0)
        -- 源0xc484，257号。
        H.spawn(a,257,"Girl06",128.0,-32.0,500,1000,3)
        H.at(a,v,0)
        -- 源0xc4b4，10号。
        return
    end
    P["MainSub07"]=B.part1
end

-- stage01.ecl：MainSub08，0xc4d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc4d4，40号。
        H.at(a,v,0)
        -- 源0xc4e8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xc4fc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xc510，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0xc524，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xc538，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xc54c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xc55c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc56c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc580，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xc594，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc5a8，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0xc5bc，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc5d0，257号。
        H.spawn(a,257,"RockB",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0xc600，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xc614，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xc628，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc640，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0xc654，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xc668，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xc67c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xc68c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc69c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc6b0，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xc6c4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xc6d8，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xc6ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc6fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc70c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc720，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xc734，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xc748，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xc75c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc76c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc77c，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc790，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xc7a4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xc7b8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc7c8，257号。
        H.spawn(a,257,"RockS",H.read(a,v,-1),-32.0,20,1000,3)
        H.at(a,v,0)
        -- 源0xc7f8，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc80c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xc820，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc838，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0xc84c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xc860，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xc874，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xc884，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc894，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc8a8，44号。
        H.push(v,2.5999999046325684)
        H.at(a,v,0)
        -- 源0xc8bc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc8d0，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0xc8e4，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc8f8，257号。
        H.spawn(a,257,"RockB",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0xc928，10号。
        return
    end
    P["MainSub08"]=B.part1
end

-- stage01.ecl：MainSub09，0xc948；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc948，40号。
        H.at(a,v,0)
        -- 源0xc95c，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0xc970，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc984，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xc998，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc9ac，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,0)
        -- 源0xc9dc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc9f0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xca04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xca14，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xca28，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xca3c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0xca50，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xca60，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,20)
        -- 源0xca74，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,20)
        -- 源0xcaa4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,20)
        -- 源0xcab8，42号。
        H.push(v,32)
        H.at(a,v,20)
        -- 源0xcacc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,20)
        -- 源0xcadc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,20)
        -- 源0xcaf0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,20)
        -- 源0xcb04，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,20)
        -- 源0xcb18，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,20)
        -- 源0xcb28，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,40)
        -- 源0xcb3c，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,40)
        -- 源0xcb6c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,40)
        -- 源0xcb80，42号。
        H.push(v,32)
        H.at(a,v,40)
        -- 源0xcb94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,40)
        -- 源0xcba4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,40)
        -- 源0xcbb8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,40)
        -- 源0xcbcc，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,40)
        -- 源0xcbe0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,40)
        -- 源0xcbf0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xcc04，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,60)
        -- 源0xcc34，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0xcc48，42号。
        H.push(v,32)
        H.at(a,v,60)
        -- 源0xcc5c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcc6c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0xcc80，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0xcc94，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,60)
        -- 源0xcca8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0xccb8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,80)
        -- 源0xcccc，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,80)
        -- 源0xccfc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,80)
        -- 源0xcd10，42号。
        H.push(v,32)
        H.at(a,v,80)
        -- 源0xcd24，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,80)
        -- 源0xcd34，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0xcd48，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,80)
        -- 源0xcd5c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,80)
        -- 源0xcd70，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,80)
        -- 源0xcd80，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,100)
        -- 源0xcd94，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,100)
        -- 源0xcdc4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,100)
        -- 源0xcdd8，42号。
        H.push(v,32)
        H.at(a,v,100)
        -- 源0xcdec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,100)
        -- 源0xcdfc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,100)
        -- 源0xce10，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,100)
        -- 源0xce24，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,100)
        -- 源0xce38，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,100)
        -- 源0xce48，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0xce5c，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,120)
        -- 源0xce8c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,120)
        -- 源0xcea0，42号。
        H.push(v,32)
        H.at(a,v,120)
        -- 源0xceb4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0xcec4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,120)
        -- 源0xced8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0xceec，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,120)
        -- 源0xcf00，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,120)
        -- 源0xcf10，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,140)
        -- 源0xcf24，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,140)
        -- 源0xcf54，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,140)
        -- 源0xcf68，42号。
        H.push(v,32)
        H.at(a,v,140)
        -- 源0xcf7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,140)
        -- 源0xcf8c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,140)
        -- 源0xcfa0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,140)
        -- 源0xcfb4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,140)
        -- 源0xcfc8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,140)
        -- 源0xcfd8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,160)
        -- 源0xcfec，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,160)
        -- 源0xd01c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,160)
        -- 源0xd030，42号。
        H.push(v,32)
        H.at(a,v,160)
        -- 源0xd044，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,160)
        -- 源0xd054，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,160)
        -- 源0xd068，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,160)
        -- 源0xd07c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,160)
        -- 源0xd090，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,160)
        -- 源0xd0a0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,180)
        -- 源0xd0b4，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,180)
        -- 源0xd0e4，257号。
        H.spawn(a,257,"Girl06",-128.0,-32.0,500,1000,3)
        H.at(a,v,180)
        -- 源0xd114，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,180)
        -- 源0xd128，42号。
        H.push(v,32)
        H.at(a,v,180)
        -- 源0xd13c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,180)
        -- 源0xd14c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,180)
        -- 源0xd160，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,180)
        -- 源0xd174，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,180)
        -- 源0xd188，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,180)
        -- 源0xd198，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,200)
        -- 源0xd1ac，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,200)
        -- 源0xd1dc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,200)
        -- 源0xd1f0，42号。
        H.push(v,32)
        H.at(a,v,200)
        -- 源0xd204，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,200)
        -- 源0xd214，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,200)
        -- 源0xd228，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,200)
        -- 源0xd23c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,200)
        -- 源0xd250，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,200)
        -- 源0xd260，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,220)
        -- 源0xd274，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,220)
        -- 源0xd2a4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,220)
        -- 源0xd2b8，42号。
        H.push(v,32)
        H.at(a,v,220)
        -- 源0xd2cc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,220)
        -- 源0xd2dc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,220)
        -- 源0xd2f0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,220)
        -- 源0xd304，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,220)
        -- 源0xd318，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,220)
        -- 源0xd328，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,240)
        -- 源0xd33c，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,240)
        -- 源0xd36c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,240)
        -- 源0xd380，42号。
        H.push(v,32)
        H.at(a,v,240)
        -- 源0xd394，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,240)
        -- 源0xd3a4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,240)
        -- 源0xd3b8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,240)
        -- 源0xd3cc，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,240)
        -- 源0xd3e0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,240)
        -- 源0xd3f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,260)
        -- 源0xd404，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,260)
        -- 源0xd434，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,260)
        -- 源0xd448，42号。
        H.push(v,32)
        H.at(a,v,260)
        -- 源0xd45c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,260)
        -- 源0xd46c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0xd480，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,260)
        -- 源0xd494，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,260)
        -- 源0xd4a8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,260)
        -- 源0xd4b8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,280)
        -- 源0xd4cc，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,280)
        -- 源0xd4fc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,280)
        -- 源0xd510，42号。
        H.push(v,32)
        H.at(a,v,280)
        -- 源0xd524，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,280)
        -- 源0xd534，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,280)
        -- 源0xd548，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,280)
        -- 源0xd55c，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,280)
        -- 源0xd570，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,280)
        -- 源0xd580，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,300)
        -- 源0xd594，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,300)
        -- 源0xd5c4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,300)
        -- 源0xd5d8，42号。
        H.push(v,32)
        H.at(a,v,300)
        -- 源0xd5ec，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,300)
        -- 源0xd5fc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,300)
        -- 源0xd610，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,300)
        -- 源0xd624，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,300)
        -- 源0xd638，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,300)
        -- 源0xd648，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,320)
        -- 源0xd65c，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,320)
        -- 源0xd68c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,320)
        -- 源0xd6a0，42号。
        H.push(v,32)
        H.at(a,v,320)
        -- 源0xd6b4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,320)
        -- 源0xd6c4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,320)
        -- 源0xd6d8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,320)
        -- 源0xd6ec，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,320)
        -- 源0xd700，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,320)
        -- 源0xd710，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,340)
        -- 源0xd724，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,340)
        -- 源0xd754，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,340)
        -- 源0xd768，42号。
        H.push(v,32)
        H.at(a,v,340)
        -- 源0xd77c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,340)
        -- 源0xd78c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,340)
        -- 源0xd7a0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,340)
        -- 源0xd7b4，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,340)
        -- 源0xd7c8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,340)
        -- 源0xd7d8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,360)
        -- 源0xd7ec，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,360)
        -- 源0xd81c，10号。
        return
    end
    P["MainSub09"]=B.part1
end

-- stage01.ecl：MainSub10，0xd83c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd83c，40号。
        H.at(a,v,0)
        -- 源0xd850，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0xd864，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd878，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xd88c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xd8a0，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,0)
        -- 源0xd8d0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd8e4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xd8f8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xd908，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd91c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xd930，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,0)
        -- 源0xd944，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd954，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,20)
        -- 源0xd968，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,20)
        -- 源0xd998，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,20)
        -- 源0xd9ac，42号。
        H.push(v,32)
        H.at(a,v,20)
        -- 源0xd9c0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,20)
        -- 源0xd9d0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,20)
        -- 源0xd9e4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,20)
        -- 源0xd9f8，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,20)
        -- 源0xda0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,20)
        -- 源0xda1c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,40)
        -- 源0xda30，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,40)
        -- 源0xda60，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,40)
        -- 源0xda74，42号。
        H.push(v,32)
        H.at(a,v,40)
        -- 源0xda88，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,40)
        -- 源0xda98，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,40)
        -- 源0xdaac，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,40)
        -- 源0xdac0，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,40)
        -- 源0xdad4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,40)
        -- 源0xdae4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xdaf8，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,60)
        -- 源0xdb28，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0xdb3c，42号。
        H.push(v,32)
        H.at(a,v,60)
        -- 源0xdb50，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0xdb60，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0xdb74，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0xdb88，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,60)
        -- 源0xdb9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xdbac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,80)
        -- 源0xdbc0，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,80)
        -- 源0xdbf0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,80)
        -- 源0xdc04，42号。
        H.push(v,32)
        H.at(a,v,80)
        -- 源0xdc18，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,80)
        -- 源0xdc28，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0xdc3c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,80)
        -- 源0xdc50，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,80)
        -- 源0xdc64，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,80)
        -- 源0xdc74，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,100)
        -- 源0xdc88，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,100)
        -- 源0xdcb8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,100)
        -- 源0xdccc，42号。
        H.push(v,32)
        H.at(a,v,100)
        -- 源0xdce0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,100)
        -- 源0xdcf0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,100)
        -- 源0xdd04，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,100)
        -- 源0xdd18，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,100)
        -- 源0xdd2c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,100)
        -- 源0xdd3c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0xdd50，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,120)
        -- 源0xdd80，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,120)
        -- 源0xdd94，42号。
        H.push(v,32)
        H.at(a,v,120)
        -- 源0xdda8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,120)
        -- 源0xddb8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,120)
        -- 源0xddcc，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0xdde0，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,120)
        -- 源0xddf4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0xde04，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,140)
        -- 源0xde18，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,140)
        -- 源0xde48，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,140)
        -- 源0xde5c，42号。
        H.push(v,32)
        H.at(a,v,140)
        -- 源0xde70，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,140)
        -- 源0xde80，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,140)
        -- 源0xde94，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,140)
        -- 源0xdea8，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,140)
        -- 源0xdebc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,140)
        -- 源0xdecc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,160)
        -- 源0xdee0，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,160)
        -- 源0xdf10，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,160)
        -- 源0xdf24，42号。
        H.push(v,32)
        H.at(a,v,160)
        -- 源0xdf38，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,160)
        -- 源0xdf48，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,160)
        -- 源0xdf5c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,160)
        -- 源0xdf70，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,160)
        -- 源0xdf84，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,160)
        -- 源0xdf94，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,180)
        -- 源0xdfa8，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,180)
        -- 源0xdfd8，257号。
        H.spawn(a,257,"Girl06",128.0,-32.0,500,1000,3)
        H.at(a,v,180)
        -- 源0xe008，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,180)
        -- 源0xe01c，42号。
        H.push(v,32)
        H.at(a,v,180)
        -- 源0xe030，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,180)
        -- 源0xe040，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,180)
        -- 源0xe054，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,180)
        -- 源0xe068，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,180)
        -- 源0xe07c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,180)
        -- 源0xe08c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,200)
        -- 源0xe0a0，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,200)
        -- 源0xe0d0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,200)
        -- 源0xe0e4，42号。
        H.push(v,32)
        H.at(a,v,200)
        -- 源0xe0f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,200)
        -- 源0xe108，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,200)
        -- 源0xe11c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,200)
        -- 源0xe130，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,200)
        -- 源0xe144，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,200)
        -- 源0xe154，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,220)
        -- 源0xe168，257号。
        H.spawn(a,257,"RGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,220)
        -- 源0xe198，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,220)
        -- 源0xe1ac，42号。
        H.push(v,32)
        H.at(a,v,220)
        -- 源0xe1c0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,220)
        -- 源0xe1d0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,220)
        -- 源0xe1e4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,220)
        -- 源0xe1f8，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,220)
        -- 源0xe20c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,220)
        -- 源0xe21c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,240)
        -- 源0xe230，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,240)
        -- 源0xe260，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,240)
        -- 源0xe274，42号。
        H.push(v,32)
        H.at(a,v,240)
        -- 源0xe288，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,240)
        -- 源0xe298，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,240)
        -- 源0xe2ac，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,240)
        -- 源0xe2c0，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,240)
        -- 源0xe2d4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,240)
        -- 源0xe2e4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,260)
        -- 源0xe2f8，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,260)
        -- 源0xe328，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,260)
        -- 源0xe33c，42号。
        H.push(v,32)
        H.at(a,v,260)
        -- 源0xe350，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0xe360，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0xe374，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,260)
        -- 源0xe388，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,260)
        -- 源0xe39c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0xe3ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,280)
        -- 源0xe3c0，257号。
        H.spawn(a,257,"BGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,280)
        -- 源0xe3f0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,280)
        -- 源0xe404，42号。
        H.push(v,32)
        H.at(a,v,280)
        -- 源0xe418，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,280)
        -- 源0xe428，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,280)
        -- 源0xe43c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,280)
        -- 源0xe450，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,280)
        -- 源0xe464，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,280)
        -- 源0xe474，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,300)
        -- 源0xe488，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,300)
        -- 源0xe4b8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,300)
        -- 源0xe4cc，42号。
        H.push(v,32)
        H.at(a,v,300)
        -- 源0xe4e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,300)
        -- 源0xe4f0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,300)
        -- 源0xe504，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,300)
        -- 源0xe518，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,300)
        -- 源0xe52c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,300)
        -- 源0xe53c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,320)
        -- 源0xe550，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,320)
        -- 源0xe580，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,320)
        -- 源0xe594，42号。
        H.push(v,32)
        H.at(a,v,320)
        -- 源0xe5a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,320)
        -- 源0xe5b8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,320)
        -- 源0xe5cc，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,320)
        -- 源0xe5e0，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,320)
        -- 源0xe5f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,320)
        -- 源0xe604，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,340)
        -- 源0xe618，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,340)
        -- 源0xe648，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,340)
        -- 源0xe65c，42号。
        H.push(v,32)
        H.at(a,v,340)
        -- 源0xe670，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,340)
        -- 源0xe680，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,340)
        -- 源0xe694，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,340)
        -- 源0xe6a8，44号。
        H.push(v,0.20943999290466309)
        H.at(a,v,340)
        -- 源0xe6bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,340)
        -- 源0xe6cc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,360)
        -- 源0xe6e0，257号。
        H.spawn(a,257,"GGirl02",(v.l[0] or 0),-32.0,60,1000,2)
        H.at(a,v,360)
        -- 源0xe710，10号。
        return
    end
    P["MainSub10"]=B.part1
end

-- stage01.ecl：MapleEnemy，0xe730；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe730，40号。
        H.at(a,v,0)
        -- 源0xe744，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe758，264号。
        H.effect_abs(a,0,132)
        H.at(a,v,3)
        -- 源0xe770，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0xe788，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage01.ecl：RGirl00，0xe7a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe7a8，40号。
        H.at(a,v,0)
        -- 源0xe7bc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe7d0，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0xe7e8，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xe7fc，11号。
        H.call(a,v,P["Girl00"],"Girl00",5,1)
        H.at(a,v,0)
        -- 源0xe828，1号。
        H.erase(a);return
    end
    P["RGirl00"]=B.part1
end

-- stage01.ecl：RGirl00_at，0xe848；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe848，40号。
        H.at(a,v,0)
        -- 源0xe85c，355号。
        v.l[8]=H.int(3)
        H.at(a,v,0)
        -- 源0xe880，355号。
        v.l[4]=H.int(2)
        H.at(a,v,0)
        -- 源0xe8a4，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xe8b8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xe8cc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xe8dc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe8f4，10号。
        return
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe904，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe918，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xe930，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0xe94c，436号。
        H.gun_count_diff(a,0,1,3,3,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0xe980，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xe99c，435号。
        H.gun_speed_diff(a,0,2.0,2.0,3.0,5.5,1.0,1.0,1.0,2.0)
        H.at(a,v,0)
        -- 源0xe9d0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xea00，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xea30，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xea44，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xea5c，83号。
        v.origin=v.origin+H.int((v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xea70，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xea84，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xea98，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xeab0，10号。
        return
    end
    P["RGirl00_at"]=B.part1
end

-- stage01.ecl：RGirl02，0xead0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xead0，40号。
        H.at(a,v,0)
        -- 源0xeae4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xeaf8，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0xeb10，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xeb24，11号。
        H.call(a,v,P["Girl02"],"Girl02",5,0)
        H.at(a,v,0)
        -- 源0xeb50，1号。
        H.erase(a);return
    end
    P["RGirl02"]=B.part1
end

-- stage01.ecl：RGirl02_at，0xeb70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xeb70，40号。
        H.at(a,v,0)
        -- 源0xeb84，356号。
        v.l[12]=H.f32(4.0)
        H.at(a,v,0)
        -- 源0xeba8，355号。
        v.l[8]=H.int(3)
        H.at(a,v,0)
        -- 源0xebcc，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0xebf0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xec04，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xec18，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xec2c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xec40，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xec50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xec68，10号。
        return
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xec78，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xec8c，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0xeca0，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xecb0，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xecc4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xecd4，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xece8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xecfc，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xed14，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xed30，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,3,1)
        H.at(a,v,0)
        -- 源0xed64，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xed80，435号。
        H.gun_speed_diff(a,0,2.5,2.5,3.5,4.5,1.0,1.0,2.0,1.0)
        H.at(a,v,0)
        -- 源0xedb4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xede4，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xee14，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xee28，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xee3c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xee50，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xee60，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xee78，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xee90，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xeea4，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xeeb8，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xeed0，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0xeee4，401号。
        H.fire(a,0)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xeef8，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xef0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xef24，83号。
        v.origin=v.origin+H.int(240)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xef38，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xef4c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xef64，10号。
        return
    end
    P["RGirl02_at"]=B.part1
end

-- stage01.ecl：RGirl03，0xef84；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xef84，40号。
        H.at(a,v,0)
        -- 源0xef98，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xefac，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0xefc4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xefd8，11号。
        H.call(a,v,P["Girl03"],"Girl03",5)
        H.at(a,v,0)
        -- 源0xeffc，1号。
        H.erase(a);return
    end
    P["RGirl03"]=B.part1
end

-- stage01.ecl：RGirl03_at，0xf01c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf01c，40号。
        H.at(a,v,0)
        -- 源0xf030，356号。
        v.l[8]=H.f32(4.0)
        H.at(a,v,0)
        -- 源0xf054，355号。
        v.l[4]=H.int(3)
        H.at(a,v,0)
        -- 源0xf078，355号。
        v.l[0]=H.int(20)
        H.at(a,v,0)
        -- 源0xf09c，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf0b0，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0xf0c4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf0d4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf0e8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf0f8，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xf10c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xf120，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xf138，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xf154，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xf170，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xf18c，405号。
        H.gun_speed(a,0,2.0,1.0)
        H.at(a,v,0)
        -- 源0xf1a8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf1d8，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf208，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xf21c，10号。
        return
    end
    P["RGirl03_at"]=B.part1
end

-- stage01.ecl：RGirl05，0xf23c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf23c，40号。
        H.at(a,v,0)
        -- 源0xf250，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf264，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0xf27c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xf290，11号。
        H.call(a,v,P["Girl05"],"Girl05",5,0)
        H.at(a,v,0)
        -- 源0xf2bc，1号。
        H.erase(a);return
    end
    P["RGirl05"]=B.part1
end

-- stage01.ecl：RGirl05_at，0xf2dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf2dc，40号。
        H.at(a,v,0)
        -- 源0xf2f0，356号。
        v.l[12]=H.f32(4.0)
        H.at(a,v,0)
        -- 源0xf314，355号。
        v.l[8]=H.int(3)
        H.at(a,v,0)
        -- 源0xf338，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0xf35c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf370，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf384，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xf398，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf3ac，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xf3bc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf3d4，10号。
        return
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf3e4，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf3f8，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xf40c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf41c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf430，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf440，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf454，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf468，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf478，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xf48c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf49c，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf4b0，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xf4c4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf4d4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf4e8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf4f8，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf50c，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xf520，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf530，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf544，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf554，368号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xf574，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xf588，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xf5a0，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0xf5bc，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0xf5f0，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xf60c，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.199999809265137,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xf640，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf670，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf688，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xf69c，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf6b0，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf6c4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf6d4，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xf6e8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf6f8，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf70c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf720，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf730，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xf744，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf754，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf768，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xf77c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf78c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf7a0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf7b0，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xf7c4，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xf7d8，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf7e8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xf7fc，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf80c，368号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xf82c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf840，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xf858，10号。
        return
    end
    P["RGirl05_at"]=B.part1
end

-- stage01.ecl：RockB，0xf878；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf878，40号。
        H.at(a,v,0)
        -- 源0xf88c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf8a0，259号。
        H.anm_slot(a,0,63)
        H.at(a,v,0)
        -- 源0xf8b8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xf8cc，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xf8e4，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xf8fc，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0xf914，285号。
        H.velocity_time(a,0,10,4,-999999.0,H.read(a,v,-9979))
        H.at(a,v,0)
        -- 源0xf934，334号。
        H.interrupt(a,0,0,36000,"RockBDead")
        H.at(a,v,6000)
        -- 源0xf960，0号。
        H.at(a,v,6000)
        -- 源0xf970，1号。
        H.erase(a);return
    end
    P["RockB"]=B.part1
end

-- stage01.ecl：RockBDead，0xf990；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf990，40号。
        H.at(a,v,0)
        -- 源0xf9a4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xf9b8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xf9cc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xf9dc，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xf9f0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfa04，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfa14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfa24，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfa38，44号。
        H.push(v,1.600000023841858)
        H.at(a,v,0)
        -- 源0xfa4c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfa60，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xfa74，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfa84，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfa94，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfaa8，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0xfabc，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfad0，256号。
        H.spawn(a,256,"RockM",0.0,0.0,100,500,2)
        H.at(a,v,0)
        -- 源0xfb00，44号。
        H.push(v,1.600000023841858)
        H.at(a,v,0)
        -- 源0xfb14，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfb28，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0xfb3c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfb4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfb5c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfb70，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xfb84，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfb98，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xfbac，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfbc0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfbd0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xfbe4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfbf8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfc08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfc18，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfc2c，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0xfc5c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xfc70，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfc84，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfc94，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xfca8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfcbc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfccc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfcdc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfcf0，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0xfd20，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xfd34，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfd48，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfd58，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xfd6c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xfd80，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xfd90，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfda0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xfdb4，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0xfde4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xfdf8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xfe0c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xfe1c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xfe34，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xfe48，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xfe5c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xfe8c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xfebc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfed4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xfee8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xff00，402号。
        H.gun_sprite(a,0,1,13)
        H.at(a,v,0)
        -- 源0xff1c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xff38，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.03272492438554764)
        H.at(a,v,0)
        -- 源0xff54，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xff68，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0xff7c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xff8c，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xffa0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xffb0，405号。
        H.gun_speed(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0xffcc，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xffe0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xfff4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1000c，263号。
        H.effect(a,0,87)
        H.at(a,v,0)
        -- 源0x10024，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x10038，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x10050，83号。
        v.origin=v.origin+H.int(1000)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x10064，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x10078，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x10090，10号。
        return
    end
    P["RockBDead"]=B.part1
end

-- stage01.ecl：RockM，0x100b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x100b0，40号。
        H.at(a,v,0)
        -- 源0x100c4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x100d8，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x100ec，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x10100，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x10110，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x10124，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10134，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1014c，259号。
        H.anm_slot(a,0,64)
        H.at(a,v,0)
        -- 源0x10164，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1017c，259号。
        H.anm_slot(a,0,65)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x10194，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x101a8，320号。
        H.hurtbox(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x101c0，321号。
        H.hitbox(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x101d8，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x101f0，285号。
        H.velocity_time(a,0,60,4,-999999.0,H.read(a,v,-9979))
        H.at(a,v,0)
        -- 源0x10210，334号。
        H.interrupt(a,0,0,36000,"RockMDead")
        H.at(a,v,6000)
        -- 源0x1023c，0号。
        H.at(a,v,6000)
        -- 源0x1024c，1号。
        H.erase(a);return
    end
    P["RockM"]=B.part1
end

-- stage01.ecl：RockMDead，0x1026c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1026c，40号。
        H.at(a,v,0)
        -- 源0x10280，44号。
        H.push(v,1.600000023841858)
        H.at(a,v,0)
        -- 源0x10294，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x102a8，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x102bc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x102cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x102dc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x102f0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x10304，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10318，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1032c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x10340，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x10350，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x10364，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x10378，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x10388，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x10398，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x103ac，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0x103dc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x103f0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x10404，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x10414，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x10428，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1043c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1044c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1045c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10470，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0x104a0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x104b4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x104c8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x104d8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x104ec，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x10500，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x10510，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x10520，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10534，256号。
        H.spawn(a,256,"RockS",0.0,0.0,50,500,2)
        H.at(a,v,0)
        -- 源0x10564，263号。
        H.effect(a,0,87)
        H.at(a,v,0)
        -- 源0x1057c，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x10590，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x105a8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x105bc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x105d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x105e8，10号。
        return
    end
    P["RockMDead"]=B.part1
end

-- stage01.ecl：RockS，0x10608；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10608，40号。
        H.at(a,v,0)
        -- 源0x1061c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10630，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x10644，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x10658，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x10668，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1067c，42号。
        H.push(v,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x10690，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x106a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x106b4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x106cc，259号。
        H.anm_slot(a,0,66)
        H.at(a,v,0)
        -- 源0x106e4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x106fc，42号。
        H.push(v,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x10710，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x10724，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10734，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1074c，259号。
        H.anm_slot(a,0,67)
        H.at(a,v,0)
        -- 源0x10764，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1077c，259号。
        H.anm_slot(a,0,68)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x10794，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x107a8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x107c0，321号。
        H.hitbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x107d8，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x107f0，285号。
        H.velocity_time(a,0,60,4,-999999.0,H.read(a,v,-9979))
        H.at(a,v,6000)
        -- 源0x10810，0号。
        H.at(a,v,6000)
        -- 源0x10820，1号。
        H.erase(a);return
    end
    P["RockS"]=B.part1
end

-- stage01.ecl：YGirl00，0x10840；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10840，40号。
        H.at(a,v,0)
        -- 源0x10854，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10868，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x10880，11号。
        H.call(a,v,P["Girl00"],"Girl00",15,1)
        H.at(a,v,0)
        -- 源0x108ac，1号。
        H.erase(a);return
    end
    P["YGirl00"]=B.part1
end

-- stage01.ecl：YGirl02，0x108cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x108cc，40号。
        H.at(a,v,0)
        -- 源0x108e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x108f4，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x1090c，11号。
        H.call(a,v,P["Girl02"],"Girl02",15,1)
        H.at(a,v,0)
        -- 源0x10938，1号。
        H.erase(a);return
    end
    P["YGirl02"]=B.part1
end

-- stage01.ecl：YGirl03，0x10958；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10958，40号。
        H.at(a,v,0)
        -- 源0x1096c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10980，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x10998，11号。
        H.call(a,v,P["Girl03"],"Girl03",15)
        H.at(a,v,0)
        -- 源0x109bc，1号。
        H.erase(a);return
    end
    P["YGirl03"]=B.part1
end

-- stage01.ecl：YGirl05，0x109dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x109dc，40号。
        H.at(a,v,0)
        -- 源0x109f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10a04，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x10a1c，11号。
        H.call(a,v,P["Girl05"],"Girl05",15,1)
        H.at(a,v,0)
        -- 源0x10a48，1号。
        H.erase(a);return
    end
    P["YGirl05"]=B.part1
end

-- stage01.ecl：main，0x10a68；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10a68，40号。
        H.at(a,v,0)
        -- 源0x10a7c，322号。
        H.flags(a,32,true)
        H.at(a,v,60)
        -- 源0x10a90，0号。
        H.at(a,v,60)
        -- 源0x10aa0，15号。
        H.async(a,P["MainSub00"],"MainSub00",nil)
        H.at(a,v,60)
        -- 源0x10ac0，15号。
        H.async(a,P["MainSub01"],"MainSub01",nil)
        H.at(a,v,60)
        -- 源0x10ae0，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,60)
        -- 源0x10af4，15号。
        H.async(a,P["MainSub02"],"MainSub02",nil)
        H.at(a,v,60)
        -- 源0x10b14，83号。
        v.origin=v.origin+H.int(700)
        H.at(a,v,60)
        -- 源0x10b28，15号。
        H.async(a,P["MainSub03"],"MainSub03",nil)
        H.at(a,v,60)
        -- 源0x10b48，15号。
        H.async(a,P["MainSub04"],"MainSub04",nil)
        H.at(a,v,60)
        -- 源0x10b68，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,60)
        -- 源0x10b7c，15号。
        H.async(a,P["MainSub05"],"MainSub05",nil)
        H.at(a,v,60)
        -- 源0x10b9c，83号。
        v.origin=v.origin+H.int(450)
        H.at(a,v,60)
        -- 源0x10bb0，257号。
        H.spawn(a,257,"MBoss",0.0,-32.0,40,10000,1)
        H.at(a,v,60)
        -- 源0x10be0，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,60)
        -- 源0x10bf4，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,60)
        -- 源0x10c14，340号。
        H.boss_wait(a,v)
        H.at(a,v,60)
        -- 源0x10c24，15号。
        H.async(a,P["MainSub07"],"MainSub07",nil)
        H.at(a,v,60)
        -- 源0x10c44，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x10c58，15号。
        H.async(a,P["MainSub03"],"MainSub03",nil)
        H.at(a,v,60)
        -- 源0x10c78，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,60)
        -- 源0x10c8c，15号。
        H.async(a,P["MainSub07"],"MainSub07",nil)
        H.at(a,v,60)
        -- 源0x10cac，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x10cc0，11号。
        H.call(a,v,P["MainSub09"],"MainSub09")
        H.at(a,v,60)
        -- 源0x10ce0，11号。
        H.call(a,v,P["MainSub10"],"MainSub10")
        H.at(a,v,60)
        -- 源0x10d00，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x10d14，15号。
        H.async(a,P["MainSub09"],"MainSub09",nil)
        H.at(a,v,60)
        -- 源0x10d34，15号。
        H.async(a,P["MainSub10"],"MainSub10",nil)
        H.at(a,v,60)
        -- 源0x10d54，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,60)
        -- 源0x10d68，338号。
        H.dialog(a,0)
        H.at(a,v,60)
        -- 源0x10d7c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x10d8c，257号。
        H.spawn(a,257,"Boss",-144.0,-16.0,40,10000,1)
        H.at(a,v,60)
        -- 源0x10dbc，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x10dcc，340号。
        H.boss_wait(a,v)
        H.at(a,v,60)
        -- 源0x10ddc，338号。
        H.dialog(a,1)
        H.at(a,v,60)
        -- 源0x10df0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x10e00，12号。
        v.origin=H.clock(a)-(60);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x10e18，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x10e2c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x10e40，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,40060)
        -- 源0x10e58，0号。
        H.at(a,v,40060)
        -- 源0x10e68，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

return P
