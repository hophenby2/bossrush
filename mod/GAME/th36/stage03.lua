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

-- stage03.ecl：BCir00，0x7bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7bc，40号。
        H.at(a,v,0)
        -- 源0x7d0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x7e8，11号。
        H.call(a,v,P["Cir00"],"Cir00",87,45,1)
        H.at(a,v,0)
        -- 源0x81c，1号。
        H.erase(a);return
    end
    P["BCir00"]=B.part1
end

-- stage03.ecl：BCir01，0x83c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x83c，40号。
        H.at(a,v,0)
        -- 源0x850，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x864，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x878，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x890，11号。
        H.call(a,v,P["Cir01"],"Cir01",75,1)
        H.at(a,v,0)
        -- 源0x8bc，1号。
        H.erase(a);return
    end
    P["BCir01"]=B.part1
end

-- stage03.ecl：BCir01Boss1，0x8dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8dc，40号。
        H.at(a,v,0)
        -- 源0x8f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x904，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x918，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x930，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x944，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x958，11号。
        H.call(a,v,P["Cir01Boss1"],"Cir01Boss1",87,1)
        H.at(a,v,0)
        -- 源0x988，1号。
        H.erase(a);return
    end
    P["BCir01Boss1"]=B.part1
end

-- stage03.ecl：BCir01Boss12，0x9a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9a8，40号。
        H.at(a,v,0)
        -- 源0x9bc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9d0，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x9e4，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x9fc，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xa10，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa24，11号。
        H.call(a,v,P["Cir01Boss12"],"Cir01Boss12",87,1)
        H.at(a,v,0)
        -- 源0xa54，1号。
        H.erase(a);return
    end
    P["BCir01Boss12"]=B.part1
end

-- stage03.ecl：BCir01Boss2，0xa74；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa74，40号。
        H.at(a,v,0)
        -- 源0xa88，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa9c，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xab0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xac8，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xadc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xaf0，11号。
        H.call(a,v,P["Cir01Boss2"],"Cir01Boss2",87,1)
        H.at(a,v,0)
        -- 源0xb20，1号。
        H.erase(a);return
    end
    P["BCir01Boss2"]=B.part1
end

-- stage03.ecl：BCir01Boss22，0xb40；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb40，40号。
        H.at(a,v,0)
        -- 源0xb54，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb68，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xb7c，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xb94，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xba8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xbbc，11号。
        H.call(a,v,P["Cir01Boss22"],"Cir01Boss22",87,1)
        H.at(a,v,0)
        -- 源0xbec，1号。
        H.erase(a);return
    end
    P["BCir01Boss22"]=B.part1
end

-- stage03.ecl：BCir01MBoss，0xc0c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc0c，40号。
        H.at(a,v,0)
        -- 源0xc20，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xc34，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xc48，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xc60，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xc74，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc88，11号。
        H.call(a,v,P["Cir01MBoss"],"Cir01MBoss",87,1)
        H.at(a,v,0)
        -- 源0xcb8，1号。
        H.erase(a);return
    end
    P["BCir01MBoss"]=B.part1
end

-- stage03.ecl：BCir01MBoss2，0xcd8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcd8，40号。
        H.at(a,v,0)
        -- 源0xcec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd00，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xd14，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xd2c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xd40，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xd54，11号。
        H.call(a,v,P["Cir01MBoss2"],"Cir01MBoss2",87,1)
        H.at(a,v,0)
        -- 源0xd84，1号。
        H.erase(a);return
    end
    P["BCir01MBoss2"]=B.part1
end

-- stage03.ecl：BCir02，0xda4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xda4，40号。
        H.at(a,v,0)
        -- 源0xdb8，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xdd0，11号。
        H.call(a,v,P["Cir02"],"Cir02",87,45,1)
        H.at(a,v,0)
        -- 源0xe04，1号。
        H.erase(a);return
    end
    P["BCir02"]=B.part1
end

-- stage03.ecl：BCir03，0xe24；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe24，40号。
        H.at(a,v,0)
        -- 源0xe38，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xe50，11号。
        H.call(a,v,P["Cir03"],"Cir03",87,45,1)
        H.at(a,v,0)
        -- 源0xe84，1号。
        H.erase(a);return
    end
    P["BCir03"]=B.part1
end

-- stage03.ecl：BGirl00，0xea4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xea4，40号。
        H.at(a,v,0)
        -- 源0xeb8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xecc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xee0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xef8，11号。
        H.call(a,v,P["Girl00"],"Girl00",0,1)
        H.at(a,v,0)
        -- 源0xf24，1号。
        H.erase(a);return
    end
    P["BGirl00"]=B.part1
end

-- stage03.ecl：Boss，0xf44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf44，40号。
        H.at(a,v,0)
        -- 源0xf58，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0xf6c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xf80，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xf98，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xfac，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xfc4，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xfdc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xff0，331号。
        H.life(a,8700)
        H.at(a,v,0)
        -- 源0x1004，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x1024，440号。
        H.fog(a,160.0,33023)
        H.at(a,v,60)
        -- 源0x103c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x104c，442号。
        a.hide_life=0~=0
        H.at(a,v,60)
        -- 源0x1060，323号。
        H.flags(a,16,false)
        H.at(a,v,60)
        -- 源0x1074，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,60)
        -- 源0x1094，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x10a8，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x10c0，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x10d4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x10e8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x10fc，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0x1118，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage03.ecl：Boss1，0x1138；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1138，40号。
        H.at(a,v,0)
        -- 源0x114c，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x115c，334号。
        H.interrupt(a,0,1200,2100,"BossCard1")
        H.at(a,v,0)
        -- 源0x1188，347号。
        H.life_marker(a,0,1200.0,-24448)
        H.at(a,v,0)
        -- 源0x11a4，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0x11b8，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x11cc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0x11ec，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1200，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1214，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1228，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x123c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1254，11号。
        H.call(a,v,P["Boss1_at1"],"Boss1_at1")
        H.at(a,v,0)
        -- 源0x1274，368号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x1294，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0x12b0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x12c4，11号。
        H.call(a,v,P["Boss1_at2"],"Boss1_at2")
        H.at(a,v,0)
        -- 源0x12e4，83号。
        v.origin=v.origin+H.int(80)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x12f8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x130c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1324，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage03.ecl：Boss1_at1，0x1344；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1344，40号。
        H.at(a,v,0)
        -- 源0x1358，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x136c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1380，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x1394，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x13a8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x13bc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x13d0，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x13e4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x13fc，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x141c，256号。
        H.spawn(a,256,"RCir01Boss1",(v.l[4] or 0),(v.l[8] or 0),200,1000,0)
        H.at(a,v,0)
        -- 源0x1450，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x1464，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x1478，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1488，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x149c，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x14b0，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x14d0，256号。
        H.spawn(a,256,"RCir01Boss1",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x1504，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x1518，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x152c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x153c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1550，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x1564，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x1584，256号。
        H.spawn(a,256,"RCir01Boss1",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x15b8，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x15cc，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x15e0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x15f0，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1604，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1618，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x162c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1644，10号。
        return
    end
    P["Boss1_at1"]=B.part1
end

-- stage03.ecl：Boss1_at2，0x1664；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1664，40号。
        H.at(a,v,0)
        -- 源0x1678，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x168c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x16a0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x16b4，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x16c8，44号。
        H.push(v,-2.4166100025177)
        H.at(a,v,0)
        -- 源0x16dc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x16f0，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,0)
        -- 源0x1708，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1720，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x1740，256号。
        H.spawn(a,256,"BCir01Boss12",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x1778，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x178c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x17a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x17b0，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x17c4，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x17d8，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x17f8，256号。
        H.spawn(a,256,"BCir01Boss12",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x1830，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x1844，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x1858，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1868，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x187c，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x1890，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x18b0，256号。
        H.spawn(a,256,"BCir01Boss12",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x18e8，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x18fc，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x1910，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1920，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1934，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1948，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x195c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1974，10号。
        return
    end
    P["Boss1_at2"]=B.part1
end

-- stage03.ecl：Boss2，0x1994；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1994，40号。
        H.at(a,v,0)
        -- 源0x19a8，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x19b8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x19c8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x19dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x19f0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1a00，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1a18，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1a2c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1a44，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1a58，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1a68，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1a78，331号。
        H.life(a,9600)
        H.at(a,v,0)
        -- 源0x1a8c，334号。
        H.interrupt(a,0,1800,2100,"BossCard2")
        H.at(a,v,0)
        -- 源0x1ab8，347号。
        H.life_marker(a,0,1800.0,-24448)
        H.at(a,v,0)
        -- 源0x1ad4，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x1ae8，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x1afc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1b10，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1b24，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1b34，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1b4c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x1b60，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1b70，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1b84，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1b98，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1ba8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1bc0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1bd4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1be8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1bfc，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x1c14，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x1c2c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1c44，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1c54，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1c68，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x1c88，0号。
        H.at(a,v,90)
        -- 源0x1c98，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,90)
        -- 源0x1cb8，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x1ccc，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x1ce0，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x1cf4，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x1d08，12号。
        v.origin=H.clock(a)-(90);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x1d20，11号。
        H.call(a,v,P["Boss2_at2"],"Boss2_at2")
        H.at(a,v,90)
        -- 源0x1d40，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,90)
        -- 源0x1d60，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,90)
        -- 源0x1d7c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x1d90，11号。
        H.call(a,v,P["Boss2_at1"],"Boss2_at1")
        H.at(a,v,90)
        -- 源0x1db0，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0x1dc4，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x1dd8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0x1df0，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage03.ecl：Boss2At1，0x1e10；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1e10，40号。
        H.at(a,v,0)
        -- 源0x1e24，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x1e38，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e4c，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x1e60，83号。
        v.origin=v.origin+H.int(8)
        H.at(a,v,0)
        -- 源0x1e74，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1e88，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e9c，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x1eb0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ec4，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1edc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1ef0，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x1f08，402号。
        H.gun_sprite(a,0,3,13)
        H.at(a,v,0)
        -- 源0x1f24，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x1f40，404号。
        H.gun_angle(a,0,0.0,0.15707963705062866)
        H.at(a,v,0)
        -- 源0x1f5c，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0x1f78，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fa8，409号。
        H.gun_transform(a,0,1,0,1024,160,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fd8，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[8] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2008，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x201c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2030，44号。
        H.push(v,0.16362500190734863)
        H.at(a,v,0)
        -- 源0x2044，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2058，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2070，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2084，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x2098，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x20a8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x20bc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x20cc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x20e4，409号。
        H.gun_transform(a,0,3,0,16,40,1,(v.l[16] or 0),1.5)
        H.at(a,v,0)
        -- 源0x2114，409号。
        H.gun_transform(a,0,4,0,-2147483648,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2144，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x215c，409号。
        H.gun_transform(a,0,3,0,16,40,1,(v.l[16] or 0),1.0)
        H.at(a,v,0)
        -- 源0x218c，409号。
        H.gun_transform(a,0,4,0,16777216,3,5,-999999.0,-999999.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x21bc，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x21d8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x21ec，44号。
        H.push(v,0.03926999866962433)
        H.at(a,v,0)
        -- 源0x2200，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2210，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2224，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x2238，44号。
        H.push(v,0.06544999778270721)
        H.at(a,v,0)
        -- 源0x224c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x225c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2270，401号。
        H.fire(a,0)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2284，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2298，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x22b0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x22c4，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x22d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x22e8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x22fc，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2310，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2324，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x2334，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2348，83号。
        v.origin=v.origin+H.int(10)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x235c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x2370，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x2388，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage03.ecl：Boss2_at1，0x23a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x23a8，40号。
        H.at(a,v,0)
        -- 源0x23bc，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x23d0，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x23e4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x23f8，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x240c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2420，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2434，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2448，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x245c，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x2470，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2488，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x24a8，256号。
        H.spawn(a,256,"RCir01Boss2",(v.l[4] or 0),(v.l[8] or 0),220,1000,0)
        H.at(a,v,0)
        -- 源0x24dc，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x24f0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2504，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2514，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2528，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x253c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2550，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2560，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2574，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x2588，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x25a8，256号。
        H.spawn(a,256,"RCir01Boss2",(v.l[4] or 0),(v.l[8] or 0),220,1000,2)
        H.at(a,v,0)
        -- 源0x25dc，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x25f0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2604，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2614，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2628，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x263c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2650，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2660，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2674，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x2688，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x26a8，256号。
        H.spawn(a,256,"RCir01Boss2",(v.l[4] or 0),(v.l[8] or 0),220,1000,2)
        H.at(a,v,0)
        -- 源0x26dc，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x26f0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2704，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2714，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2728，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x273c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2750，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2760，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2774，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2788，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x279c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x27b4，10号。
        return
    end
    P["Boss2_at1"]=B.part1
end

-- stage03.ecl：Boss2_at2，0x27d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x27d4，40号。
        H.at(a,v,0)
        -- 源0x27e8，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x27fc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2810，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2824，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2838，44号。
        H.push(v,-2.4166100025177)
        H.at(a,v,0)
        -- 源0x284c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2860，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,0)
        -- 源0x2878，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2890，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x28b0，256号。
        H.spawn(a,256,"BCir01Boss22",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x28e8，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x28fc，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2910，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2920，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2934，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x2948，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2968，256号。
        H.spawn(a,256,"BCir01Boss22",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x29a0，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x29b4，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x29c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x29d8，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x29ec，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x2a00，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2a20，256号。
        H.spawn(a,256,"BCir01Boss22",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0x2a58，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x2a6c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2a80，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2a90，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2aa4，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2ab8，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2acc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2ae4，10号。
        return
    end
    P["Boss2_at2"]=B.part1
end

-- stage03.ecl：Boss3，0x2b04；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2b04，40号。
        H.at(a,v,0)
        -- 源0x2b18，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x2b28，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2b38，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2b4c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2b60，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b70，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2b88，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2b9c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2bb4，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2bc8，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2bd8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2be8，331号。
        H.life(a,9700)
        H.at(a,v,0)
        -- 源0x2bfc，334号。
        H.interrupt(a,0,2700,2100,"BossCard3")
        H.at(a,v,0)
        -- 源0x2c28，347号。
        H.life_marker(a,0,2700.0,-24448)
        H.at(a,v,0)
        -- 源0x2c44，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x2c58，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x2c6c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2c80，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2c94，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2ca4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2cbc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2cd0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2ce0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2cf4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2d18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2d30，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2d44，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d58，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2d6c，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x2d84，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x2d9c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2db4，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2dc4，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2dd8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x2df8，0号。
        H.at(a,v,90)
        -- 源0x2e08，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,90)
        -- 源0x2e28，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2e3c，12号。
        v.origin=H.clock(a)-(90);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x2e54，269号。
        H.anm_cast(a,0)
        H.at(a,v,90)
        -- 源0x2e68，11号。
        H.call(a,v,P["Boss3_at"],"Boss3_at")
        H.at(a,v,90)
        -- 源0x2e88，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2e9c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,90)
        -- 源0x2eb8，83号。
        v.origin=v.origin+H.int(70)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0x2ecc，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x2ee0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0x2ef8，10号。
        return
    end
    P["Boss3"]=B.part1
end

-- stage03.ecl：Boss3_at，0x2f18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2f18，40号。
        H.at(a,v,0)
        -- 源0x2f2c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2f40，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x2f58，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x2f74，436号。
        H.gun_count_diff(a,0,6,6,8,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0x2fa8，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x2fc4，435号。
        H.gun_speed_diff(a,0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x2ff8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3028，356号。
        v.l[4]=H.f32(0.02777777798473835)
        H.at(a,v,0)
        -- 源0x304c，409号。
        H.gun_transform(a,0,1,1,4,90,-999999,0.018888888880610466,-999999.0)
        H.at(a,v,0)
        -- 源0x307c，409号。
        H.gun_transform(a,0,2,1,256,1,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x30ac，409号。
        H.gun_transform(a,0,3,0,2048,2,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x30dc，355号。
        v.l[12]=H.int(30)
        H.at(a,v,0)
        -- 源0x3100，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3114，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3128，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3140，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3154，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3168，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3178，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3194，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x31a8，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x31c8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x31dc，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x31f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3200，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3214，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x3228，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3240，10号。
        return
    end
    P["Boss3_at"]=B.part1
end

-- stage03.ecl：BossCard1，0x3260；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3260，40号。
        H.at(a,v,0)
        -- 源0x3274，334号。
        H.interrupt(a,0,0,2580,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x32d0，359号。
        H.spell(a,32,2100,500000,"枷符「咎人の外さぬ枷」",359)
        H.at(a,v,0)
        -- 源0x3308，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x331c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x332c，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x334c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3360，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x3374，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x33a8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x33b8，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x33cc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x33e0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x33f0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3408，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x341c，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x342c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3440，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3454，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,30)
        -- 源0x3474，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x348c，0号。
        H.at(a,v,60)
        -- 源0x349c，15号。
        H.async(a,P["BossCard1_at"],"BossCard1_at",nil)
        H.at(a,v,60)
        -- 源0x34c0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x34d4，12号。
        v.origin=H.clock(a)-(60);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x34ec，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x3500，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x3514，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x352c，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage03.ecl：BossCard1At，0x354c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x354c，40号。
        H.at(a,v,0)
        -- 源0x3560，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x3574，334号。
        H.interrupt(a,0,0,-1,"BossCard1At_at")
        H.at(a,v,0)
        -- 源0x35a4，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x35b8，259号。
        H.anm_slot(a,0,12)
        H.at(a,v,0)
        -- 源0x35d0，277号。
        H.anm_rotate(a,0.0,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x35e8，284号。
        H.velocity(a,0,H.read(a,v,-9981),0.699999988079071)
        H.at(a,v,0)
        -- 源0x3600，444号。
        H.callback(a,444,1)
        H.at(a,v,0)
        -- 源0x3614，445号。
        H.callback(a,445,1)
        H.at(a,v,0)
        -- 源0x3628，83号。
        v.origin=v.origin+H.int(8000)
        H.at(a,v,0)
        -- 源0x363c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x3650，275号。
        H.anm_switch(a,0,1)
        H.at(a,v,20)
        -- 源0x3668，1号。
        H.erase(a);return
    end
    P["BossCard1At"]=B.part1
end

-- stage03.ecl：BossCard1At_at，0x3698；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3698，40号。
        H.at(a,v,0)
        -- 源0x36ac，81号。
        do local r=96.0;local angle=H.read(a,v,-9981);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x36cc，282号。
        H.position(a,1,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x36e4，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x36fc，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x3710，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3724，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x373c，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x3758，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x3774，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.2617993950843811)
        H.at(a,v,0)
        -- 源0x3790，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x37ac，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x37dc，409号。
        H.gun_transform(a,0,1,0,512,800,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x380c，409号。
        H.gun_transform(a,0,2,0,4096,330,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x383c，409号。
        H.gun_transform(a,0,3,0,32,1,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x386c，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.004166666883975267,-999999.0)
        H.at(a,v,0)
        -- 源0x389c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x38b0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x38c4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x38d8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x38e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3900，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3914，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x392c，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x3948，406号。
        H.gun_count(a,0,4,1)
        H.at(a,v,0)
        -- 源0x3964，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.2617993950843811)
        H.at(a,v,0)
        -- 源0x3980，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x399c，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x39cc，409号。
        H.gun_transform(a,0,1,0,512,800,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x39fc，409号。
        H.gun_transform(a,0,2,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3a2c，409号。
        H.gun_transform(a,0,3,0,32,1,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3a5c，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.008333333767950535,-999999.0)
        H.at(a,v,0)
        -- 源0x3a8c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3aa0，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3ab8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x3acc，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x3ae0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3af0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3b08，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3b1c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x3b34，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x3b50，406号。
        H.gun_count(a,0,12,1)
        H.at(a,v,0)
        -- 源0x3b6c，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.2617993950843811)
        H.at(a,v,0)
        -- 源0x3b88，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x3ba4，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3bd4，409号。
        H.gun_transform(a,0,1,0,512,800,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3c04，409号。
        H.gun_transform(a,0,2,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3c34，409号。
        H.gun_transform(a,0,3,0,4,120,-999999,0.004999999888241291,-999999.0)
        H.at(a,v,0)
        -- 源0x3c64，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3c78，447号。
        H.cancel(a,80.0,false)
        H.at(a,v,0)
        -- 源0x3c8c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x3ca0，1号。
        H.erase(a);return
    end
    P["BossCard1At_at"]=B.part1
end

-- stage03.ecl：BossCard1_at，0x3cd0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3cd0，40号。
        H.at(a,v,0)
        -- 源0x3ce4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3cf8，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3d10，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x3d24，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x3d38，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d4c，44号。
        H.push(v,2.6179940700531006)
        H.at(a,v,0)
        -- 源0x3d60，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3d74，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3d8c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,3000,10,0)
        H.at(a,v,0)
        -- 源0x3dc0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3dd4，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0x3de8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3df8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3e0c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x3e20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3e38，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x3e4c，16号。
        H.async(a,P["BossCard1_at2"],"BossCard1_at2",0)
        H.at(a,v,0)
        -- 源0x3e74，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3e8c，281号。
        H.position_time(a,0,60,4,-64.0,128.0)
        H.at(a,v,0)
        -- 源0x3eac，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x3ec0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3ed4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3ee8，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,1200,10,0)
        H.at(a,v,0)
        -- 源0x3f1c，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,0)
        -- 源0x3f30，281号。
        H.position_time(a,0,60,4,64.0,128.0)
        H.at(a,v,0)
        -- 源0x3f50，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x3f64，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3f78，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3f8c，256号。
        H.spawn(a,256,"BossCard1At",0.0,0.0,1200,10,0)
        H.at(a,v,0)
        -- 源0x3fc0，83号。
        v.origin=v.origin+H.int(220)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3fd4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3fe8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x4000，83号。
        v.origin=v.origin+H.int(9000)
        H.at(a,v,0)
        -- 源0x4014，17号。
        H.stop_thread(a,0)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x4028，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x403c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x4054，10号。
        return
    end
    P["BossCard1_at"]=B.part1
end

-- stage03.ecl：BossCard1_at2，0x4074；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4074，40号。
        H.at(a,v,0)
        -- 源0x4088，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x409c，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x40b4，402号。
        H.gun_sprite(a,0,0,10)
        H.at(a,v,0)
        -- 源0x40d0，406号。
        H.gun_count(a,0,20,1)
        H.at(a,v,0)
        -- 源0x40ec，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.2617993950843811)
        H.at(a,v,0)
        -- 源0x4108，405号。
        H.gun_speed(a,0,6.5,1.0)
        H.at(a,v,0)
        -- 源0x4124，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4154，356号。
        v.l[12]=H.f32(1.0)
        H.at(a,v,0)
        -- 源0x4178，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x418c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x41a0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x41b4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x41c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x41d4，409号。
        H.gun_transform(a,0,1,0,64,60,1,H.read(a,v,-1),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4204，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x4218，405号。
        H.gun_speed(a,0,6.400000095367432,1.0)
        H.at(a,v,0)
        -- 源0x4234，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4248，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x425c，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x4270，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4284，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0x4298，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x42ac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x42c4，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,0)
        -- 源0x42d8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x42ec，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x4300，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4310，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4320，404号。
        H.gun_angle(a,0,H.read(a,v,-1),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x433c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4350，44号。
        H.push(v,0.03490699827671051)
        H.at(a,v,0)
        -- 源0x4364，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4374，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4388，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x439c，368号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x43bc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x43d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x43e8，10号。
        return
    end
    P["BossCard1_at2"]=B.part1
end

-- stage03.ecl：BossCard2，0x4408；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4408，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4450，359号。
        H.spell(a,36,2400,500000,"力業「大江山颪」",359)
        H.at(a,v,0)
        -- 源0x4484，334号。
        H.interrupt(a,0,0,2400,"Boss3")
        H.at(a,v,0)
        -- 源0x44ac，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x44bc，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x44dc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x44f0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4504，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4518，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4528，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4540，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x4554，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4564，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4578，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x458c，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x45a0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x45b4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x45c8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x45d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x45f0，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4624，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x463c，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4674，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x4684，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4694，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x46a8，324号。
        H.limit(a,0.0,128.0,280.0,128.0)
        H.at(a,v,60)
        -- 源0x46c8，0号。
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x46ec，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,60)
        -- 源0x4704，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x471c，256号。
        H.spawn(a,256,"BossCard2Dummy",0.0,0.0,1000,1000,3)
        H.at(a,v,120)
        -- 源0x4754，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,120)
        -- 源0x4768，42号。
        H.push(v,2)
        H.at(a,v,120)
        -- 源0x477c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,120)
        -- 源0x478c，42号。
        H.push(v,0)
        H.at(a,v,120)
        -- 源0x47a0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,120)
        -- 源0x47b0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(120);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x47c8，42号。
        H.push(v,-128)
        H.at(a,v,120)
        -- 源0x47dc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x47f0，12号。
        v.origin=H.clock(a)-(120);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x4808，42号。
        H.push(v,128)
        H.at(a,v,120)
        -- 源0x481c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x4830，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,120)
        -- 源0x4844，42号。
        H.push(v,2)
        H.at(a,v,120)
        -- 源0x4858，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,120)
        -- 源0x4868，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(120);return B.part13(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x4880，12号。
        v.origin=H.clock(a)-(120);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x4898，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,120)
        -- 源0x48ac，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x48c0，256号。
        H.spawn(a,256,"BossCard2Dummy2",0.0,0.0,1000,1000,3)
        H.at(a,v,120)
        -- 源0x48f8，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,120)
        -- 源0x490c，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,120)
        -- 源0x4924，256号。
        H.spawn(a,256,"BossCard2Dummy",0.0,0.0,1000,1000,3)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,120)
        -- 源0x495c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x4970，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,120)
        -- 源0x4988，12号。
        v.origin=H.clock(a)-(120);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,120)
        -- 源0x49a0，83号。
        v.origin=v.origin+H.int(1000)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,120)
        -- 源0x49b4，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x49c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,120)
        -- 源0x49e0，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage03.ecl：BossCard2Dummy，0x4a00；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a00，40号。
        H.at(a,v,0)
        -- 源0x4a14，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x4a28，280号。
        H.position(a,0,0.0,0.0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4ac4，15号。
        H.async(a,P["BossCard2_at_h"],"BossCard2_at_h",nil,0)
        H.at(a,v,0)
        -- 源0x4af0，15号。
        H.async(a,P["BossCard2_at2_h"],"BossCard2_at2_h",nil,0)
        H.at(a,v,0)
        -- 源0x4b1c，15号。
        H.async(a,P["BossCard2_at3_h"],"BossCard2_at3_h",nil,0)
        H.at(a,v,0)
        -- 源0x4b48，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x4b5c，1号。
        H.erase(a);return
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4b84，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4b98，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4bac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4bc4，1号。
        H.erase(a);return
    end
    P["BossCard2Dummy"]=B.part1
end

-- stage03.ecl：BossCard2Dummy2，0x4be4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4be4，40号。
        H.at(a,v,0)
        -- 源0x4bf8，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x4c0c，280号。
        H.position(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4c24，15号。
        H.async(a,P["BossCard2_at"],"BossCard2_at",nil,0)
        H.at(a,v,0)
        -- 源0x4c50，15号。
        H.async(a,P["BossCard2_at2"],"BossCard2_at2",nil,0)
        H.at(a,v,0)
        -- 源0x4c7c，15号。
        H.async(a,P["BossCard2_at3"],"BossCard2_at3",nil,0)
        H.at(a,v,0)
        -- 源0x4ca8，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x4cbc，1号。
        H.erase(a);return
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4ce4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4cf8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4d0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4d24，1号。
        H.erase(a);return
    end
    P["BossCard2Dummy2"]=B.part1
end

-- stage03.ecl：BossCard2_at，0x4d44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4d44，40号。
        H.at(a,v,0)
        -- 源0x4d58，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4d6c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4d80，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4d94，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4da8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4dbc，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x4dd4，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x4df0，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x4e0c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4e28，405号。
        H.gun_speed(a,0,8.0,2.0)
        H.at(a,v,0)
        -- 源0x4e44，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4e5c，403号。
        H.gun_offset(a,0,223.0,0.0)
        H.at(a,v,0)
        -- 源0x4e78，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x4e8c，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x4ea0，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x4eb4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4ec4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4ed4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4ee8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x4efc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4f0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4f1c，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4f38，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4f4c，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4f60，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4f74，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4f8c，10号。
        return
    end
    P["BossCard2_at"]=B.part1
end

-- stage03.ecl：BossCard2_at2，0x4fac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4fac，40号。
        H.at(a,v,0)
        -- 源0x4fc0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x4fd4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4fe8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4ffc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5010，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x5024，407号。
        H.gun_aim(a,1,1)
        H.at(a,v,0)
        -- 源0x503c，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x5058，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x5074，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5090，405号。
        H.gun_speed(a,1,4.5,2.0)
        H.at(a,v,0)
        -- 源0x50ac，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x50c0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x50d8，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x50ec，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5100，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5110，403号。
        H.gun_offset(a,1,223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x512c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5140，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5154，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5168，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5178，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5188，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x519c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x51b0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x51c0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x51d0，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x51ec，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5200，368号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x5220，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5234，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5248，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x525c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x526c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x527c，403号。
        H.gun_offset(a,1,223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5298，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x52ac，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x52c0，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x52d4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x52e4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x52f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5308，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x531c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x532c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x533c，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5358，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x536c，368号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x538c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x53a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x53b8，10号。
        return
    end
    P["BossCard2_at2"]=B.part1
end

-- stage03.ecl：BossCard2_at2_h，0x53d8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x53d8，40号。
        H.at(a,v,0)
        -- 源0x53ec，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x5400，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5414，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5428，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x543c，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x5450，407号。
        H.gun_aim(a,1,1)
        H.at(a,v,0)
        -- 源0x5468，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x5484，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x54a0，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x54bc，405号。
        H.gun_speed(a,1,4.5,2.0)
        H.at(a,v,0)
        -- 源0x54d8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x54ec，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5504，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5518，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x552c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x553c，403号。
        H.gun_offset(a,1,-223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5558，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x556c，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5580，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5594，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x55a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x55b4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x55c8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x55dc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x55ec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x55fc，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5618，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x562c，368号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x564c，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5660，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5674，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5688，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5698，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x56a8，403号。
        H.gun_offset(a,1,-223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x56c4，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x56d8，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x56ec，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5700，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5710，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5720，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5734，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5748，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5758，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5768，404号。
        H.gun_angle(a,1,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5784，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5798，368号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x57b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x57cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x57e4，10号。
        return
    end
    P["BossCard2_at2_h"]=B.part1
end

-- stage03.ecl：BossCard2_at3，0x5804；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5804，40号。
        H.at(a,v,0)
        -- 源0x5818，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x582c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5840，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5854，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5868，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x587c，407号。
        H.gun_aim(a,2,1)
        H.at(a,v,0)
        -- 源0x5894，402号。
        H.gun_sprite(a,2,17,1)
        H.at(a,v,0)
        -- 源0x58b0，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x58cc，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x58e8，405号。
        H.gun_speed(a,2,3.0,2.0)
        H.at(a,v,0)
        -- 源0x5904，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x5918，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5930，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x5944，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5958，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x596c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x597c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x598c，403号。
        H.gun_offset(a,2,223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x59a8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x59bc，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x59d0，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x59e4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x59f4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5a04，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5a18，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5a2c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5a3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5a4c，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5a68，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x5a7c，368号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x5a9c，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x5ab0，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5ac4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x5ad4，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5ae8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5afc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5b0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5b1c，403号。
        H.gun_offset(a,2,223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5b38，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5b4c，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5b60，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5b74，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5b84，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5b94，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5ba8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x5bbc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5bcc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5bdc，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5bf8，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x5c0c，368号。
        v.origin=v.origin+H.int(18)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5c2c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5c40，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5c58，10号。
        return
    end
    P["BossCard2_at3"]=B.part1
end

-- stage03.ecl：BossCard2_at3_h，0x5c78；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5c78，40号。
        H.at(a,v,0)
        -- 源0x5c8c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x5ca0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5cb4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5cc8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5cdc，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x5cf0，407号。
        H.gun_aim(a,2,1)
        H.at(a,v,0)
        -- 源0x5d08，402号。
        H.gun_sprite(a,2,17,1)
        H.at(a,v,0)
        -- 源0x5d24，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x5d40，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5d5c，405号。
        H.gun_speed(a,2,3.0,2.0)
        H.at(a,v,0)
        -- 源0x5d78，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x5d8c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5da4，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x5db8，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5dcc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5de0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5df0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5e00，403号。
        H.gun_offset(a,2,-223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5e1c，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x5e30，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5e44，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5e58，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5e68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5e78，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5e8c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5ea0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5eb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5ec0，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5edc，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x5ef0，368号。
        v.origin=v.origin+H.int(18)
        H.at(a,v,0)
        -- 源0x5f10，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x5f24，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5f38，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x5f48，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x5f5c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5f70，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5f80，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5f90，403号。
        H.gun_offset(a,2,-223.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5fac，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x5fc0，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x5fd4，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5fe8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5ff8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6008，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x601c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x6030，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6040，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6050，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x606c，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x6080，368号。
        v.origin=v.origin+H.int(18)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x60a0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x60b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x60cc，10号。
        return
    end
    P["BossCard2_at3_h"]=B.part1
end

-- stage03.ecl：BossCard2_at_h，0x60ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x60ec，40号。
        H.at(a,v,0)
        -- 源0x6100，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x6114，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6128，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x613c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6150，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6164，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x617c，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x6198，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x61b4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x61d0，405号。
        H.gun_speed(a,0,8.0,2.0)
        H.at(a,v,0)
        -- 源0x61ec，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6204，403号。
        H.gun_offset(a,0,-223.0,0.0)
        H.at(a,v,0)
        -- 源0x6220，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x6234，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x6248，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x625c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x626c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x627c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6290，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x62a4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x62b4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x62c4，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x62e0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x62f4，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6308，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x631c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6334，10号。
        return
    end
    P["BossCard2_at_h"]=B.part1
end

-- stage03.ecl：BossCard3，0x6354；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6354，40号。
        H.at(a,v,0)
        -- 源0x6368，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x637c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x638c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x63a0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x63b4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x63c4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x63dc，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x63f0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6408，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x641c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x642c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x643c，334号。
        H.interrupt(a,0,0,3000,"BossDead")
        H.at(a,v,0)
        -- 源0x6468，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x647c，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x6490，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x64b0，324号。
        H.limit(a,0.0,128.0,280.0,192.0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x6508，359号。
        H.spell(a,40,3000,500000,"四天王奥義「三歩必殺」",359)
        H.at(a,v,0)
        -- 源0x6540，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x6550，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x6564，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x6578，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x658c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x659c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x65b4，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x65c8，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x65d8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x65ec，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6600，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x6614，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x6628，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x663c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x664c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x6664，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x6698，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x66b0，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x66e8，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x66fc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x6710，12号。
        v.origin=H.clock(a)-(770);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,30)
        -- 源0x6728，263号。
        H.effect(a,0,131)
        H.at(a,v,30)
        -- 源0x6740，337号。
        H.shake(a,30,1,0)
        H.at(a,v,60)
        -- 源0x675c，0号。
        H.at(a,v,60)
        -- 源0x676c，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,60)
        -- 源0x6784，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x6798，15号。
        H.async(a,P["BossCard3_at"],"BossCard3_at",nil)
        H.at(a,v,120)
        -- 源0x67bc，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x67d4，337号。
        H.shake(a,30,1,0)
        H.at(a,v,150)
        -- 源0x67f0，0号。
        H.at(a,v,150)
        -- 源0x6800，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x6814，336号。
        H.sound(a,15)
        H.at(a,v,150)
        -- 源0x6828，15号。
        H.async(a,P["BossCard3_at2"],"BossCard3_at2",nil)
        H.at(a,v,240)
        -- 源0x684c，263号。
        H.effect(a,0,131)
        H.at(a,v,240)
        -- 源0x6864，337号。
        H.shake(a,60,1,1)
        H.at(a,v,300)
        -- 源0x6880，337号。
        H.shake(a,60,4,0)
        H.at(a,v,300)
        -- 源0x689c，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,300)
        -- 源0x68b4，336号。
        H.sound(a,15)
        H.at(a,v,300)
        -- 源0x68c8，15号。
        H.async(a,P["BossCard3_at3b"],"BossCard3_at3b",nil)
        H.at(a,v,500)
        -- 源0x68ec，263号。
        H.effect(a,0,131)
        H.at(a,v,500)
        -- 源0x6904，337号。
        H.shake(a,30,1,0)
        H.at(a,v,530)
        -- 源0x6920，0号。
        H.at(a,v,530)
        -- 源0x6930，336号。
        H.sound(a,15)
        H.at(a,v,530)
        -- 源0x6944，269号。
        H.anm_cast(a,0)
        H.at(a,v,530)
        -- 源0x6958，15号。
        H.async(a,P["BossCard3_atb"],"BossCard3_atb",nil)
        H.at(a,v,590)
        -- 源0x697c，263号。
        H.effect(a,0,131)
        H.at(a,v,590)
        -- 源0x6994，337号。
        H.shake(a,30,1,0)
        H.at(a,v,620)
        -- 源0x69b0，0号。
        H.at(a,v,620)
        -- 源0x69c0，336号。
        H.sound(a,15)
        H.at(a,v,620)
        -- 源0x69d4，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,620)
        -- 源0x69ec，15号。
        H.async(a,P["BossCard3_at2b"],"BossCard3_at2b",nil)
        H.at(a,v,710)
        -- 源0x6a10，263号。
        H.effect(a,0,131)
        H.at(a,v,710)
        -- 源0x6a28，337号。
        H.shake(a,60,1,1)
        H.at(a,v,770)
        -- 源0x6a44，337号。
        H.shake(a,60,4,0)
        H.at(a,v,770)
        -- 源0x6a60，336号。
        H.sound(a,15)
        H.at(a,v,770)
        -- 源0x6a74，269号。
        H.anm_cast(a,0)
        H.at(a,v,770)
        -- 源0x6a88，15号。
        H.async(a,P["BossCard3_at3"],"BossCard3_at3",nil)
        H.at(a,v,770)
        -- 源0x6aac，83号。
        v.origin=v.origin+H.int(170)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,770)
        -- 源0x6ac0，42号。
        H.push(v,1)
        H.at(a,v,770)
        -- 源0x6ad4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,770)
        -- 源0x6aec，12号。
        v.origin=H.clock(a)-(770);return B.part14(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,770)
        -- 源0x6b04，83号。
        v.origin=v.origin+H.int(1000)
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,770)
        -- 源0x6b18，42号。
        H.push(v,1)
        H.at(a,v,770)
        -- 源0x6b2c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(770);return B.part13(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,770)
        -- 源0x6b44，10号。
        return
    end
    P["BossCard3"]=B.part1
end

-- stage03.ecl：BossCard3_at，0x6b64；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6b64，40号。
        H.at(a,v,0)
        -- 源0x6b78，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x6b94，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6ba8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x6bc0，402号。
        H.gun_sprite(a,0,5,6)
        H.at(a,v,0)
        -- 源0x6bdc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x6bf8，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x6c14，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x6c30，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6c60，409号。
        H.gun_transform(a,0,1,0,512,1000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6c90，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x6ca4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x6cb8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6ccc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6ce0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6cf4，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x6d08，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d1c，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x6d30，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d44，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6d5c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x6d70，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x6d84，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6d94，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x6da8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x6db8，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x6dcc，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x6de0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6df0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x6e04，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x6e14，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x6e28，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x6e3c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6e4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6e5c，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x6e8c，409号。
        H.gun_transform(a,0,1,0,512,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6ebc，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6eec，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x6f00，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x6f14，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x6f24，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6f38，355号。
        v.l[20]=H.int(16)
        H.at(a,v,0)
        -- 源0x6f5c，356号。
        v.l[8]=H.f32(0.39269909262657166)
        H.at(a,v,0)
        -- 源0x6f80，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x6f94，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6fa8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6fc0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x6fd4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x6fe8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x6ff8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x700c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7020，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7034，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7044，437号。
        H.gun_polar(a,0,H.read(a,v,-1),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7060，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x707c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7090，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x70a4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x70b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x70c8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x70dc，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x70f0，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x7104，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x711c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7130，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x7144，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7154，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7168，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x717c，44号。
        H.push(v,0.008727000094950199)
        H.at(a,v,0)
        -- 源0x7190，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x71a0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x71b4，83号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x71c8，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x71dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x71f4，10号。
        return
    end
    P["BossCard3_at"]=B.part1
end

-- stage03.ecl：BossCard3_at2，0x7214；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7214，40号。
        H.at(a,v,0)
        -- 源0x7228，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x7244，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7258，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x7270，402号。
        H.gun_sprite(a,0,5,8)
        H.at(a,v,0)
        -- 源0x728c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x72a8，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x72c4，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x72e0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7310，409号。
        H.gun_transform(a,0,2,0,4096,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7340，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x7354，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x7368，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x737c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7390，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x73a4，44号。
        H.push(v,70.0)
        H.at(a,v,0)
        -- 源0x73b8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x73cc，42号。
        H.push(v,380)
        H.at(a,v,0)
        -- 源0x73e0，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x73f4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x740c，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x7420，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x7434，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7444，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7458，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x7468，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x747c，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x7490，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x74a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x74b0，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x74e0，409号。
        H.gun_transform(a,0,1,0,512,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7510，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7540，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x7554，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x7568，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x7578，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x758c，355号。
        v.l[20]=H.int(16)
        H.at(a,v,0)
        -- 源0x75b0，356号。
        v.l[8]=H.f32(0.39269909262657166)
        H.at(a,v,0)
        -- 源0x75d4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x75e8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x75fc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7614，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7628，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x763c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x764c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7660，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7674，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7688，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7698，437号。
        H.gun_polar(a,0,H.read(a,v,-1),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x76b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x76c8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x76dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x76ec，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x7708，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x771c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7730，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7744，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7754，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7768，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x777c，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x7790，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x77a8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x77bc，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x77d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x77e0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x77f4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7808，44号。
        H.push(v,0.008727000094950199)
        H.at(a,v,0)
        -- 源0x781c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x782c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7840，83号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7854，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x7868，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7880，10号。
        return
    end
    P["BossCard3_at2"]=B.part1
end

-- stage03.ecl：BossCard3_at2b，0x78a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x78a0，40号。
        H.at(a,v,0)
        -- 源0x78b4，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x78d0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x78e4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x78fc，402号。
        H.gun_sprite(a,0,5,4)
        H.at(a,v,0)
        -- 源0x7918，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x7934，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x7950，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x796c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x799c，409号。
        H.gun_transform(a,0,1,0,512,1000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x79cc，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x79e0，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x79f4，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a08，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7a1c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a30，44号。
        H.push(v,70.0)
        H.at(a,v,0)
        -- 源0x7a44，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a58，42号。
        H.push(v,360)
        H.at(a,v,0)
        -- 源0x7a6c，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a80，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7a98，409号。
        H.gun_transform(a,0,1,0,512,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7ac8，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7af8，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x7b0c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x7b20，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x7b30，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7b44，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x7b58，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x7b6c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7b7c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7b90，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x7ba0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x7bb4，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x7bc8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7bd8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7be8，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x7c18，355号。
        v.l[20]=H.int(16)
        H.at(a,v,0)
        -- 源0x7c3c，356号。
        v.l[8]=H.f32(0.39269909262657166)
        H.at(a,v,0)
        -- 源0x7c60，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7c74，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7c88，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7ca0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7cb4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7cc8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x7cd8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7cec，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7d00，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7d14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7d24，437号。
        H.gun_polar(a,0,H.read(a,v,-1),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7d40，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7d54，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7d68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7d78，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x7d94，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7da8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7dbc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7dd0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7de0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7df4，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7e08，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x7e1c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7e34，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7e48，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x7e5c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7e6c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7e80，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7e94，44号。
        H.push(v,0.01745299994945526)
        H.at(a,v,0)
        -- 源0x7ea8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7eb8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7ecc，83号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7ee0，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x7ef4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7f0c，10号。
        return
    end
    P["BossCard3_at2b"]=B.part1
end

-- stage03.ecl：BossCard3_at3，0x7f2c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7f2c，40号。
        H.at(a,v,0)
        -- 源0x7f40，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x7f5c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7f70，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x7f88，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,0)
        -- 源0x7fa4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x7fc0，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x7fdc，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x7ff8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8028，409号。
        H.gun_transform(a,0,1,0,512,1000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8058，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,0.01666666753590107,0.01745329238474369)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x809c，402号。
        H.gun_sprite(a,0,17,0)
        H.at(a,v,0)
        -- 源0x80b8，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x80cc，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x80e0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x80f4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8108，44号。
        H.push(v,150.0)
        H.at(a,v,0)
        -- 源0x811c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8130，44号。
        H.push(v,160.0)
        H.at(a,v,0)
        -- 源0x8144，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8158，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x816c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8180，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8198，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x81ac，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x81c0，409号。
        H.gun_transform(a,0,1,0,512,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x81f0，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8220，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8238，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x824c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8260，437号。
        H.gun_polar(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x827c，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x8298，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x82ac，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x82c0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x82d4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x82e4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x82f8，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x830c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x8320，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8338，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x834c，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x8360，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8370，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8384，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x8398，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x83ac，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x83bc，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x83d0，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x83e4，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x83f8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8410，10号。
        return
    end
    P["BossCard3_at3"]=B.part1
end

-- stage03.ecl：BossCard3_at3b，0x8430；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8430，40号。
        H.at(a,v,0)
        -- 源0x8444，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x8460，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x8474，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x848c，402号。
        H.gun_sprite(a,0,0,6)
        H.at(a,v,0)
        -- 源0x84a8，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x84c4，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x84e0，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x84fc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x852c，409号。
        H.gun_transform(a,0,1,0,512,1000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x8570，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0x858c，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x85a0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x85b4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x85c8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x85dc，44号。
        H.push(v,150.0)
        H.at(a,v,0)
        -- 源0x85f0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8604，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x8618，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x862c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8644，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x8658，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x866c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x8680，42号。
        H.push(v,180)
        H.at(a,v,0)
        -- 源0x8694，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x86a4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x86b8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x86c8，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,0.01666666753590107,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x86f8，409号。
        H.gun_transform(a,0,1,0,512,(v.l[20] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8728，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[20] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8758，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8770，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8784，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8798，437号。
        H.gun_polar(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x87b4，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x87d0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x87e4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x87f8，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x880c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x881c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8830，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8844，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x8858，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8870，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8884，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x8898，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x88a8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x88bc，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x88d0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x88e4，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x88f4，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8908，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x891c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x8930，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8948，10号。
        return
    end
    P["BossCard3_at3b"]=B.part1
end

-- stage03.ecl：BossCard3_atb，0x8968；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8968，40号。
        H.at(a,v,0)
        -- 源0x897c，408号。
        H.gun_sound(a,0,15,-1)
        H.at(a,v,0)
        -- 源0x8998，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x89ac，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x89c4，402号。
        H.gun_sprite(a,0,5,2)
        H.at(a,v,0)
        -- 源0x89e0，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x89fc，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x8a18，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x8a34，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8a64，409号。
        H.gun_transform(a,0,1,0,512,1000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8a94，409号。
        H.gun_transform(a,0,2,0,4096,360,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8ac4，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x8ad8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x8aec，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8b00，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8b14，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8b28，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x8b3c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8b50，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x8b64，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8b78，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8b90，409号。
        H.gun_transform(a,0,1,0,512,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8bc0，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8bf0，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x8c04，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x8c18，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x8c28，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8c3c，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x8c50，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x8c64，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8c74，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8c88，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8c98，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x8cac，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x8cc0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8cd0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8ce0，409号。
        H.gun_transform(a,0,3,0,8,60,-999999,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x8d10，355号。
        v.l[20]=H.int(16)
        H.at(a,v,0)
        -- 源0x8d34，356号。
        v.l[8]=H.f32(0.39269909262657166)
        H.at(a,v,0)
        -- 源0x8d58，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8d6c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8d80，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8d98，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8dac，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8dc0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8dd0，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8de4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8df8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x8e0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8e1c，437号。
        H.gun_polar(a,0,H.read(a,v,-1),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8e38，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x8e54，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x8e68，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8e7c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8e90，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8ea0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8eb4，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8ec8，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x8edc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8ef4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8f08，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x8f1c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8f2c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8f40，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8f54，44号。
        H.push(v,0.01745299994945526)
        H.at(a,v,0)
        -- 源0x8f68，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x8f78，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8f8c，83号。
        v.origin=v.origin+H.int(2)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8fa0，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x8fb4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8fcc，10号。
        return
    end
    P["BossCard3_atb"]=B.part1
end

-- stage03.ecl：BossDead，0x8fec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8fec，40号。
        H.at(a,v,0)
        -- 源0x9000，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x9014，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x902c，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x9040，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x9058，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x9070，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9084，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9098，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x90a8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x90c0，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x90f8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9110，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x9148，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x9158，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x9168，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x917c，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0x918c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0x91a0，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x91b4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x91c4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x91dc，330号。
        H.drop_main(a,5)
        H.at(a,v,60)
        -- 源0x91f0，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x9200，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x9214，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x9228，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,60)
        -- 源0x9240，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,60)
        -- 源0x9258，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0x9270，329号。
        H.drop(a)
        H.at(a,v,60)
        -- 源0x9280，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0x929c，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0x92b4，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0x92cc，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0x92e0，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0x92f4，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

-- stage03.ecl：Cir00，0x9324；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9324，40号。
        H.at(a,v,0)
        -- 源0x9338，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x934c，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9360，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9374，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x938c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x93a0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x93b8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x93d0，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x93e4，44号。
        H.push(v,0.01745329238474369)
        H.at(a,v,0)
        -- 源0x93f8，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x940c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x941c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x942c，44号。
        H.push(v,0.0872664600610733)
        H.at(a,v,0)
        -- 源0x9440，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x9454，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9464，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9474，284号。
        H.velocity(a,0,H.read(a,v,-1),0.5)
        H.at(a,v,60)
        -- 源0x948c，323号。
        H.flags(a,3,false)
        H.at(a,v,60)
        -- 源0x94a0，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x94c0，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil,1)
        H.at(a,v,60)
        -- 源0x94e8，258号。
        H.select_anm(a,1)
        H.at(a,v,60)
        -- 源0x94fc，259号。
        H.anm_slot(a,1,(v.l[4] or 0))
        H.at(a,v,360)
        -- 源0x9514，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,360)
        -- 源0x9528，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,360)
        -- 源0x953c，42号。
        H.push(v,16)
        H.at(a,v,360)
        -- 源0x9550，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,360)
        -- 源0x9560，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,360)
        -- 源0x9570，284号。
        H.velocity(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,360)
        -- 源0x9588，285号。
        H.velocity_time(a,0,30,0,-999999.0,4.0)
        H.at(a,v,360)
        -- 源0x95a8，12号。
        v.origin=H.clock(a)-(360);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,360)
        -- 源0x95c0，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,360)
        -- 源0x95d4，42号。
        H.push(v,1)
        H.at(a,v,360)
        -- 源0x95e8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(360);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,360)
        -- 源0x9600，10号。
        return
    end
    P["Cir00"]=B.part1
end

-- stage03.ecl：Cir01，0x9620；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9620，40号。
        H.at(a,v,0)
        -- 源0x9634，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9648，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x965c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9670，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9688，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x969c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x96b4，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x96cc，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x96dc，327号。
        H.drop_extra(a,2,3)
        H.at(a,v,0)
        -- 源0x96f4，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x970c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x9724，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x9738，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x974c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x9760，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x9770，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9780，284号。
        H.velocity(a,0,H.read(a,v,-1),5.0)
        H.at(a,v,0)
        -- 源0x9798，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x97b8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x97cc，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil)
        H.at(a,v,0)
        -- 源0x97ec，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x9800，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x9818，285号。
        H.velocity_time(a,0,60,0,-999999.0,5.0)
        H.at(a,v,6000)
        -- 源0x9838，0号。
        H.at(a,v,6000)
        -- 源0x9848，10号。
        return
    end
    P["Cir01"]=B.part1
end

-- stage03.ecl：Cir01Boss1，0x9868；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9868，40号。
        H.at(a,v,0)
        -- 源0x987c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9890，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x98a4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x98b8，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x98d0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x98e4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x98fc，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x9914，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x992c，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0x9944，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x9964，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9978，15号。
        H.async(a,P["RCir01Boss1_at"],"RCir01Boss1_at",nil)
        H.at(a,v,0)
        -- 源0x999c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x99b0，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0x99c8，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x99e0，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x99f4，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x9a0c，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0x9a2c，1号。
        H.erase(a);return
    end
    P["Cir01Boss1"]=B.part1
end

-- stage03.ecl：Cir01Boss12，0x9a6c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9a6c，40号。
        H.at(a,v,0)
        -- 源0x9a80，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9a94，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9aa8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9abc，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9ad4，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x9ae8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x9b00，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x9b18，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x9b30，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0x9b48，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x9b68，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9b7c，15号。
        H.async(a,P["RCir01Boss1_at2"],"RCir01Boss1_at2",nil)
        H.at(a,v,0)
        -- 源0x9ba0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9bb4，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0x9bcc，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x9be4，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x9bf8，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x9c10，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0x9c30，1号。
        H.erase(a);return
    end
    P["Cir01Boss12"]=B.part1
end

-- stage03.ecl：Cir01Boss2，0x9c70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9c70，40号。
        H.at(a,v,0)
        -- 源0x9c84，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9c98，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9cac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9cc0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9cd8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x9cec，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x9d04，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x9d1c，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x9d34，334号。
        H.interrupt(a,0,0,-1,"Cir01Boss2Dead")
        H.at(a,v,0)
        -- 源0x9d64，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0x9d7c，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x9d9c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9db0，15号。
        H.async(a,P["RCir01Boss2_at"],"RCir01Boss2_at",nil)
        H.at(a,v,0)
        -- 源0x9dd4，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9de8，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0x9e00，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x9e18，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x9e2c，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x9e44，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0x9e64，1号。
        H.erase(a);return
    end
    P["Cir01Boss2"]=B.part1
end

-- stage03.ecl：Cir01Boss22，0x9ea4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9ea4，40号。
        H.at(a,v,0)
        -- 源0x9eb8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9ecc，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9ee0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9ef4，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9f0c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x9f20，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x9f38，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x9f50，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x9f68，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0x9f80，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x9fa0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9fb4，15号。
        H.async(a,P["RCir01Boss2_at2"],"RCir01Boss2_at2",nil)
        H.at(a,v,0)
        -- 源0x9fd8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9fec，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0xa004，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0xa01c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xa030，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xa048，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xa068，1号。
        H.erase(a);return
    end
    P["Cir01Boss22"]=B.part1
end

-- stage03.ecl：Cir01Boss2Dead，0xa0a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa0a8，40号。
        H.at(a,v,0)
        -- 源0xa0bc，448号。
        H.laser_clear_id(a,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0xa0d0，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0xa0e8，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0xa0fc，10号。
        return
    end
    P["Cir01Boss2Dead"]=B.part1
end

-- stage03.ecl：Cir01MBoss，0xa11c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa11c，40号。
        H.at(a,v,0)
        -- 源0xa130，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xa144，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa158，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa16c，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa184，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xa198，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa1b0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xa1c8，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0xa1e0，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0xa1f8，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0xa218，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa22c，15号。
        H.async(a,P["RCir01MBoss_at"],"RCir01MBoss_at",nil)
        H.at(a,v,0)
        -- 源0xa250，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa264，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0xa27c，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0xa294，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xa2a8，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xa2c0，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xa2e0，1号。
        H.erase(a);return
    end
    P["Cir01MBoss"]=B.part1
end

-- stage03.ecl：Cir01MBoss2，0xa320；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa320，40号。
        H.at(a,v,0)
        -- 源0xa334，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xa348，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa35c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa370，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa388，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xa39c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa3b4，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xa3cc，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0xa3e4，284号。
        H.velocity(a,0,H.read(a,v,-9978),2.0)
        H.at(a,v,0)
        -- 源0xa3fc，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0xa41c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa430，15号。
        H.async(a,P["RCir01MBoss_at2"],"RCir01MBoss_at2",nil)
        H.at(a,v,0)
        -- 源0xa454，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa468，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0xa480，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0xa498，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xa4ac，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xa4c4，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xa4e4，1号。
        H.erase(a);return
    end
    P["Cir01MBoss2"]=B.part1
end

-- stage03.ecl：Cir02，0xa524；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa524，40号。
        H.at(a,v,0)
        -- 源0xa538，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa54c，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa560，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa574，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa58c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xa5a0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa5b8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xa5d0，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,60)
        -- 源0xa5e8，323号。
        H.flags(a,3,false)
        H.at(a,v,60)
        -- 源0xa5fc，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0xa61c，15号。
        H.async(a,P["RCir02_at"],"RCir02_at",nil,1)
        H.at(a,v,60)
        -- 源0xa644，258号。
        H.select_anm(a,1)
        H.at(a,v,60)
        -- 源0xa658，259号。
        H.anm_slot(a,1,(v.l[4] or 0))
        H.at(a,v,360)
        -- 源0xa670，322号。
        H.flags(a,3,true)
        H.at(a,v,360)
        -- 源0xa684，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,360)
        -- 源0xa69c，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,360)
        -- 源0xa6b4，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,360)
        -- 源0xa6cc，285号。
        H.velocity_time(a,0,30,0,-999999.0,1.0)
        H.at(a,v,420)
        -- 源0xa6ec，1号。
        H.erase(a);return
    end
    P["Cir02"]=B.part1
end

-- stage03.ecl：Cir03，0xa71c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa71c，40号。
        H.at(a,v,0)
        -- 源0xa730，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa744，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa758，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa76c，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa784，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xa798，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa7b0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xa7c8，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,60)
        -- 源0xa7e0，323号。
        H.flags(a,3,false)
        H.at(a,v,60)
        -- 源0xa7f4，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0xa814，15号。
        H.async(a,P["RCir03_at"],"RCir03_at",nil,1)
        H.at(a,v,60)
        -- 源0xa83c，258号。
        H.select_anm(a,1)
        H.at(a,v,60)
        -- 源0xa850，259号。
        H.anm_slot(a,1,(v.l[4] or 0))
        H.at(a,v,360)
        -- 源0xa868，322号。
        H.flags(a,3,true)
        H.at(a,v,360)
        -- 源0xa87c，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,360)
        -- 源0xa894，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,360)
        -- 源0xa8ac，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,360)
        -- 源0xa8c4，285号。
        H.velocity_time(a,0,30,0,-999999.0,1.0)
        H.at(a,v,420)
        -- 源0xa8e4，1号。
        H.erase(a);return
    end
    P["Cir03"]=B.part1
end

-- stage03.ecl：GCir00，0xa914；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa914，40号。
        H.at(a,v,0)
        -- 源0xa928，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xa93c，11号。
        H.call(a,v,P["Cir00"],"Cir00",84,47,1)
        H.at(a,v,0)
        -- 源0xa970，1号。
        H.erase(a);return
    end
    P["GCir00"]=B.part1
end

-- stage03.ecl：GCir01，0xa990；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa990，40号。
        H.at(a,v,0)
        -- 源0xa9a4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa9b8，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xa9cc，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa9e4，11号。
        H.call(a,v,P["Cir01"],"Cir01",72,1)
        H.at(a,v,0)
        -- 源0xaa10，1号。
        H.erase(a);return
    end
    P["GCir01"]=B.part1
end

-- stage03.ecl：GCir01Boss1，0xaa30；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaa30，40号。
        H.at(a,v,0)
        -- 源0xaa44，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xaa58，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xaa6c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xaa84，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xaa98，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xaaac，11号。
        H.call(a,v,P["Cir01Boss1"],"Cir01Boss1",84,1)
        H.at(a,v,0)
        -- 源0xaadc，1号。
        H.erase(a);return
    end
    P["GCir01Boss1"]=B.part1
end

-- stage03.ecl：GCir01Boss12，0xaafc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaafc，40号。
        H.at(a,v,0)
        -- 源0xab10，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xab24，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xab38，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xab50，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xab64，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xab78，11号。
        H.call(a,v,P["Cir01Boss12"],"Cir01Boss12",84,1)
        H.at(a,v,0)
        -- 源0xaba8，1号。
        H.erase(a);return
    end
    P["GCir01Boss12"]=B.part1
end

-- stage03.ecl：GCir01Boss2，0xabc8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xabc8，40号。
        H.at(a,v,0)
        -- 源0xabdc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xabf0，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xac04，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xac1c，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xac30，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xac44，11号。
        H.call(a,v,P["Cir01Boss2"],"Cir01Boss2",84,1)
        H.at(a,v,0)
        -- 源0xac74，1号。
        H.erase(a);return
    end
    P["GCir01Boss2"]=B.part1
end

-- stage03.ecl：GCir01Boss22，0xac94；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xac94，40号。
        H.at(a,v,0)
        -- 源0xaca8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xacbc，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xacd0，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xace8，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xacfc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xad10，11号。
        H.call(a,v,P["Cir01Boss22"],"Cir01Boss22",84,1)
        H.at(a,v,0)
        -- 源0xad40，1号。
        H.erase(a);return
    end
    P["GCir01Boss22"]=B.part1
end

-- stage03.ecl：GCir01MBoss，0xad60；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xad60，40号。
        H.at(a,v,0)
        -- 源0xad74，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xad88，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xad9c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xadb4，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xadc8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xaddc，11号。
        H.call(a,v,P["Cir01MBoss"],"Cir01MBoss",84,1)
        H.at(a,v,0)
        -- 源0xae0c，1号。
        H.erase(a);return
    end
    P["GCir01MBoss"]=B.part1
end

-- stage03.ecl：GCir01MBoss2，0xae2c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xae2c，40号。
        H.at(a,v,0)
        -- 源0xae40，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xae54，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xae68，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xae80，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xae94，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xaea8，11号。
        H.call(a,v,P["Cir01MBoss2"],"Cir01MBoss2",84,1)
        H.at(a,v,0)
        -- 源0xaed8，1号。
        H.erase(a);return
    end
    P["GCir01MBoss2"]=B.part1
end

-- stage03.ecl：GCir02，0xaef8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaef8，40号。
        H.at(a,v,0)
        -- 源0xaf0c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xaf20，11号。
        H.call(a,v,P["Cir02"],"Cir02",84,47,1)
        H.at(a,v,0)
        -- 源0xaf54，1号。
        H.erase(a);return
    end
    P["GCir02"]=B.part1
end

-- stage03.ecl：GCir03，0xaf74；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaf74，40号。
        H.at(a,v,0)
        -- 源0xaf88，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xaf9c，11号。
        H.call(a,v,P["Cir03"],"Cir03",84,47,1)
        H.at(a,v,0)
        -- 源0xafd0，1号。
        H.erase(a);return
    end
    P["GCir03"]=B.part1
end

-- stage03.ecl：GGirl00，0xaff0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaff0，40号。
        H.at(a,v,0)
        -- 源0xb004，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb018，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xb02c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xb044，11号。
        H.call(a,v,P["Girl00"],"Girl00",10,1)
        H.at(a,v,0)
        -- 源0xb070，1号。
        H.erase(a);return
    end
    P["GGirl00"]=B.part1
end

-- stage03.ecl：Girl00，0xb090；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb090，40号。
        H.at(a,v,0)
        -- 源0xb0a4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb0b8，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb0d0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xb0e4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xb0fc，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xb114，15号。
        H.async(a,P["RGirl00_at"],"RGirl00_at",nil,1)
        H.at(a,v,0)
        -- 源0xb13c，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xb154，285号。
        H.velocity_time(a,0,30,9,0.0,4.0)
        H.at(a,v,30)
        -- 源0xb174，285号。
        H.velocity_time(a,0,30,9,1.1780972480773926,1.0)
        H.at(a,v,60)
        -- 源0xb194，285号。
        H.velocity_time(a,0,10,1,1.919862151145935,0.800000011920929)
        H.at(a,v,70)
        -- 源0xb1b4，276号。
        H.anm_reset(a)
        H.at(a,v,70)
        -- 源0xb1c4，285号。
        H.velocity_time(a,0,120,1,-999999.0,1.5)
        H.at(a,v,70)
        -- 源0xb1e4，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,6070)
        -- 源0xb1f8，0号。
        H.at(a,v,6070)
        -- 源0xb208，10号。
        return
    end
    P["Girl00"]=B.part1
end

-- stage03.ecl：MBoss，0xb228；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb228，40号。
        H.at(a,v,0)
        -- 源0xb23c，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0xb250，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0xb264，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0xb27c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xb290，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xb2a8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xb2bc，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xb2d4，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0xb2ec，331号。
        H.life(a,13400)
        H.at(a,v,0)
        -- 源0xb300，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb314，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb328，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xb338，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,0)
        -- 源0xb34c，334号。
        H.interrupt(a,0,9000,-1,"MBoss2")
        H.at(a,v,0)
        -- 源0xb374，334号。
        H.interrupt(a,1,2000,2700,"MBossCard1")
        H.at(a,v,0)
        -- 源0xb3a0，347号。
        H.life_marker(a,0,9000.0,-3092225)
        H.at(a,v,0)
        -- 源0xb3bc，347号。
        H.life_marker(a,1,2000.0,-24448)
        H.at(a,v,0)
        -- 源0xb3d8，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0xb3ec，440号。
        H.fog(a,160.0,16711680)
        H.at(a,v,0)
        -- 源0xb404，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xb424，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0xb438，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,0)
        -- 源0xb458，11号。
        H.call(a,v,P["MBoss1"],"MBoss1")
        H.at(a,v,0)
        -- 源0xb474，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage03.ecl：MBoss1，0xb494；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb494，40号。
        H.at(a,v,0)
        -- 源0xb4a8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb4bc，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb4d0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb4e4，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb4f8，11号。
        H.call(a,v,P["MBoss_at2"],"MBoss_at2")
        H.at(a,v,0)
        -- 源0xb518，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xb52c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0xb548，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb55c，11号。
        H.call(a,v,P["MBoss_at1"],"MBoss_at1")
        H.at(a,v,0)
        -- 源0xb57c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xb590，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0xb5ac，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb5c0，11号。
        H.call(a,v,P["MBoss_at2"],"MBoss_at2")
        H.at(a,v,0)
        -- 源0xb5e0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xb5f4，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0xb610，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb624，11号。
        H.call(a,v,P["MBoss_at1"],"MBoss_at1")
        H.at(a,v,0)
        -- 源0xb644，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xb658，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0xb674，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb688，11号。
        H.call(a,v,P["MBoss2B"],"MBoss2B")
        H.at(a,v,0)
        -- 源0xb6a4，10号。
        return
    end
    P["MBoss1"]=B.part1
end

-- stage03.ecl：MBoss2，0xb6c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb6c4，40号。
        H.at(a,v,0)
        -- 源0xb6d8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xb6e8，327号。
        H.drop_extra(a,1,1)
        H.at(a,v,0)
        -- 源0xb700，327号。
        H.drop_extra(a,2,2)
        H.at(a,v,0)
        -- 源0xb718，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xb730，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0xb740，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xb750，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xb764，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xb798，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xb7a8，281号。
        H.position_time(a,0,60,4,0.0,144.0)
        H.at(a,v,0)
        -- 源0xb7c8，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0xb7dc，0号。
        H.at(a,v,60)
        -- 源0xb7ec，11号。
        H.call(a,v,P["MBoss2B"],"MBoss2B")
        H.at(a,v,60)
        -- 源0xb808，10号。
        return
    end
    P["MBoss2"]=B.part1
end

-- stage03.ecl：MBoss2B，0xb828；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb828，40号。
        H.at(a,v,0)
        -- 源0xb83c，334号。
        H.interrupt(a,0,-1,-1,"MBoss2")
        H.at(a,v,0)
        -- 源0xb864，347号。
        H.life_marker(a,0,13400.0,-3092225)
        H.at(a,v,0)
        -- 源0xb880，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb898，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xb8ac，11号。
        H.call(a,v,P["MBoss2B_at"],"MBoss2B_at")
        H.at(a,v,0)
        -- 源0xb8cc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xb8e0，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0xb8fc，83号。
        v.origin=v.origin+H.int(70)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb910，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb924，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb93c，10号。
        return
    end
    P["MBoss2B"]=B.part1
end

-- stage03.ecl：MBoss2B_at，0xb95c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb95c，40号。
        H.at(a,v,0)
        -- 源0xb970，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xb984，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xb99c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xb9b8，406号。
        H.gun_count(a,0,4,1)
        H.at(a,v,0)
        -- 源0xb9d4，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0xb9f0，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xba0c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xba3c，356号。
        v.l[4]=H.f32(0.0555555559694767)
        H.at(a,v,0)
        -- 源0xba60，409号。
        H.gun_transform(a,0,1,1,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xba90，409号。
        H.gun_transform(a,0,2,1,256,1,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbac0，409号。
        H.gun_transform(a,0,3,0,2048,2,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbaf0，355号。
        v.l[12]=H.int(60)
        H.at(a,v,0)
        -- 源0xbb14，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xbb28，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbb3c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xbb54，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xbb68，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xbb7c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbb8c，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xbba8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbbbc，368号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xbcc0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xbcd4，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0xbce8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbcf8，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xbd0c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xbd20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbd38，10号。
        return
    end
    P["MBoss2B_at"]=B.part1
end

-- stage03.ecl：MBoss3，0xbd58；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbd58，40号。
        H.at(a,v,0)
        -- 源0xbd6c，15号。
        H.async(a,P["MBoss3b"],"MBoss3b",nil)
        H.at(a,v,0)
        -- 源0xbd88，83号。
        v.origin=v.origin+H.int(1580)
        H.at(a,v,0)
        -- 源0xbd9c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xbdac，11号。
        H.call(a,v,P["Boss"],"Boss")
        H.at(a,v,0)
        -- 源0xbdc8，10号。
        return
    end
    P["MBoss3"]=B.part1
end

-- stage03.ecl：MBoss3_at，0xbde8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbde8，40号。
        H.at(a,v,0)
        -- 源0xbdfc，356号。
        v.l[0]=H.f32(0.19634954631328583)
        H.at(a,v,0)
        -- 源0xbe20，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xbe34，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xbe4c，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0xbe68，436号。
        H.gun_count_diff(a,0,8,16,16,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0xbe9c，404号。
        H.gun_angle(a,0,0.0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbeb8，435号。
        H.gun_speed_diff(a,0,2.0,2.0,2.0,2.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xbeec，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbf1c，355号。
        v.l[4]=H.int(3)
        H.at(a,v,0)
        -- 源0xbf40，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xbf58，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbf6c，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xbf80，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xbf94，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbfac，10号。
        return
    end
    P["MBoss3_at"]=B.part1
end

-- stage03.ecl：MBoss3b，0xbfcc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbfcc，40号。
        H.at(a,v,0)
        -- 源0xbfe0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xbff8，368号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0xc018，292号。
        H.wander(a,0,60,4,1.0)
        H.at(a,v,0)
        -- 源0xc034，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xc048，15号。
        H.async(a,P["MBoss3_at"],"MBoss3_at",nil)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc068，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc07c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc094，10号。
        return
    end
    P["MBoss3b"]=B.part1
end

-- stage03.ecl：MBossCard1，0xc0b4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc0b4，40号。
        H.at(a,v,0)
        -- 源0xc0c8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xc0d8，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0xc0f8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xc10c，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0xc120，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xc154，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0xc164，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xc178，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc18c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xc19c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc1b4，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0xc1c8，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc1d8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc1ec，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc200，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0xc214，338号。
        H.dialog(a,2)
        H.at(a,v,66)
        -- 源0xc228，269号。
        H.anm_cast(a,0)
        H.at(a,v,66)
        -- 源0xc23c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,66)
        -- 源0xc24c，323号。
        H.flags(a,16,false)
        H.at(a,v,66)
        -- 源0xc260，347号。
        H.life_marker(a,0,2000.0,-24448)
        H.at(a,v,66)
        -- 源0xc27c，333号。
        a.phase_time=0
        H.at(a,v,66)
        -- 源0xc28c，334号。
        H.interrupt(a,0,0,2040,"MBossEscape")
        H.at(a,v,66)
        -- 源0xc2b8，357号。
        H.spell(a,26,2040,500000,"鬼符「怪力乱神」",357)
        H.at(a,v,66)
        -- 源0xc2ec，344号。
        a.chapter=43
        H.at(a,v,66)
        -- 源0xc300，324号。
        H.limit(a,0.0,128.0,280.0,256.0)
        H.at(a,v,126)
        -- 源0xc320，263号。
        H.effect(a,0,131)
        H.at(a,v,186)
        -- 源0xc338，0号。
        H.at(a,v,186)
        -- 源0xc348，12号。
        v.origin=H.clock(a)-(186);return B.part23(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,186)
        -- 源0xc360，355号。
        v.l[16]=H.int(12)
        H.at(a,v,186)
        -- 源0xc384，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc398，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc3ac，42号。
        H.push(v,12)
        H.at(a,v,186)
        -- 源0xc3c0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc3d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc3e0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc3f4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc408，42号。
        H.push(v,10)
        H.at(a,v,186)
        -- 源0xc41c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc42c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc43c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc450，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc464，42号。
        H.push(v,8)
        H.at(a,v,186)
        -- 源0xc478，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc488，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc498，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc4ac，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc4c0，42号。
        H.push(v,6)
        H.at(a,v,186)
        -- 源0xc4d4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc4e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc4f4，356号。
        H.write(a,-9981,H.f32(H.read(a,v,-1)))
        H.at(a,v,186)
        -- 源0xc518，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc52c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc540，42号。
        H.push(v,12)
        H.at(a,v,186)
        -- 源0xc554，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc564，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xc574，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc588，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc59c，42号。
        H.push(v,10)
        H.at(a,v,186)
        -- 源0xc5b0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc5c0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xc5d0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc5e4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc5f8，42号。
        H.push(v,8)
        H.at(a,v,186)
        -- 源0xc60c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc61c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xc62c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xc640，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xc654，42号。
        H.push(v,6)
        H.at(a,v,186)
        -- 源0xc668，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xc678，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xc688，356号。
        H.write(a,-9980,H.f32(H.read(a,v,-1)))
        H.at(a,v,186)
        -- 源0xc6ac，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,186)
        -- 源0xc6c0，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc6d4，12号。
        v.origin=H.clock(a)-(186);return B.part12(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,186)
        -- 源0xc6ec，256号。
        H.spawn(a,256,"MBossCard1At",16.0,-48.0,100,10,0)
        H.at(a,v,186)
        -- 源0xc724，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xc738，42号。
        H.push(v,0)
        H.at(a,v,186)
        -- 源0xc74c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xc75c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,186)
        -- 源0xc774，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xc788，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,186)
        -- 源0xc79c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc7ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc7c0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xc7d4，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,186)
        -- 源0xc7e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc7f8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc80c，12号。
        v.origin=H.clock(a)-(186);return B.part12(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,186)
        -- 源0xc824，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xc838，42号。
        H.push(v,1)
        H.at(a,v,186)
        -- 源0xc84c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xc85c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part9(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,186)
        -- 源0xc874，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xc888，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,186)
        -- 源0xc89c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc8ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc8c0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xc8d4，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,186)
        -- 源0xc8e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc8f8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc90c，12号。
        v.origin=H.clock(a)-(186);return B.part12(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,186)
        -- 源0xc924，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xc938，42号。
        H.push(v,2)
        H.at(a,v,186)
        -- 源0xc94c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xc95c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,186)
        -- 源0xc974，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xc988，44号。
        H.push(v,0.6283190250396729)
        H.at(a,v,186)
        -- 源0xc99c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc9ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xc9c0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xc9d4，44号。
        H.push(v,0.6283190250396729)
        H.at(a,v,186)
        -- 源0xc9e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xc9f8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xca0c，12号。
        v.origin=H.clock(a)-(186);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,186)
        -- 源0xca24，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xca38，44号。
        H.push(v,0.5235990285873413)
        H.at(a,v,186)
        -- 源0xca4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xca5c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xca70，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xca84，44号。
        H.push(v,0.5235990285873413)
        H.at(a,v,186)
        -- 源0xca98，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcaa8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,186)
        -- 源0xcabc，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,186)
        -- 源0xcad0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(186);return B.part5(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,186)
        -- 源0xcae8，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,186)
        -- 源0xcafc，292号。
        H.wander(a,0,110,4,1.0)
        H.at(a,v,186)
        -- 源0xcb18，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,186)
        -- 源0xcb2c，269号。
        H.anm_cast(a,0)
        H.at(a,v,186)
        -- 源0xcb40，355号。
        v.l[16]=H.int(12)
        H.at(a,v,186)
        -- 源0xcb64，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcb78，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcb8c，42号。
        H.push(v,12)
        H.at(a,v,186)
        -- 源0xcba0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcbb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcbc0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcbd4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcbe8，42号。
        H.push(v,10)
        H.at(a,v,186)
        -- 源0xcbfc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcc0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcc1c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcc30，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcc44，42号。
        H.push(v,8)
        H.at(a,v,186)
        -- 源0xcc58，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcc68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcc78，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcc8c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcca0，42号。
        H.push(v,4)
        H.at(a,v,186)
        -- 源0xccb4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xccc4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xccd4，356号。
        H.write(a,-9981,H.f32(H.read(a,v,-1)))
        H.at(a,v,186)
        -- 源0xccf8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcd0c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcd20，42号。
        H.push(v,12)
        H.at(a,v,186)
        -- 源0xcd34，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcd44，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xcd54，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcd68，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcd7c，42号。
        H.push(v,10)
        H.at(a,v,186)
        -- 源0xcd90，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcda0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xcdb0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xcdc4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xcdd8，42号。
        H.push(v,8)
        H.at(a,v,186)
        -- 源0xcdec，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xcdfc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xce0c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,186)
        -- 源0xce20，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,186)
        -- 源0xce34，42号。
        H.push(v,4)
        H.at(a,v,186)
        -- 源0xce48，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,186)
        -- 源0xce58，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,186)
        -- 源0xce68，356号。
        H.write(a,-9980,H.f32(H.read(a,v,-1)))
        H.at(a,v,186)
        -- 源0xce8c，44号。
        H.push(v,-0.31415900588035583)
        H.at(a,v,186)
        -- 源0xcea0，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xceb4，12号。
        v.origin=H.clock(a)-(186);return B.part21(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,186)
        -- 源0xcecc，256号。
        H.spawn(a,256,"MBossCard1At",16.0,-48.0,100,10,0)
        H.at(a,v,186)
        -- 源0xcf04，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xcf18，42号。
        H.push(v,0)
        H.at(a,v,186)
        -- 源0xcf2c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xcf3c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part16(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,186)
        -- 源0xcf54，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xcf68，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,186)
        -- 源0xcf7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcf8c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xcfa0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xcfb4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,186)
        -- 源0xcfc8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xcfd8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xcfec，12号。
        v.origin=H.clock(a)-(186);return B.part21(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,186)
        -- 源0xd004，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xd018，42号。
        H.push(v,1)
        H.at(a,v,186)
        -- 源0xd02c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xd03c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part18(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,186)
        -- 源0xd054，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xd068，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,186)
        -- 源0xd07c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd08c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xd0a0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xd0b4，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,186)
        -- 源0xd0c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd0d8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xd0ec，12号。
        v.origin=H.clock(a)-(186);return B.part21(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,186)
        -- 源0xd104，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,186)
        -- 源0xd118，42号。
        H.push(v,2)
        H.at(a,v,186)
        -- 源0xd12c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,186)
        -- 源0xd13c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(186);return B.part20(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,186)
        -- 源0xd154，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xd168，44号。
        H.push(v,0.6283190250396729)
        H.at(a,v,186)
        -- 源0xd17c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd18c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xd1a0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xd1b4，44号。
        H.push(v,0.6283190250396729)
        H.at(a,v,186)
        -- 源0xd1c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd1d8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xd1ec，12号。
        v.origin=H.clock(a)-(186);return B.part21(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,186)
        -- 源0xd204，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,186)
        -- 源0xd218，44号。
        H.push(v,0.5235990285873413)
        H.at(a,v,186)
        -- 源0xd22c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd23c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,186)
        -- 源0xd250，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,186)
        -- 源0xd264，44号。
        H.push(v,0.5235990285873413)
        H.at(a,v,186)
        -- 源0xd278，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,186)
        -- 源0xd288，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part21(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,186)
        -- 源0xd29c，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,186)
        -- 源0xd2b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(186);return B.part14(a,v) end
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,186)
        -- 源0xd2c8，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,186)
        -- 源0xd2dc，292号。
        H.wander(a,0,110,4,1.0)
        H.at(a,v,186)
        -- 源0xd2f8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,186)
        -- 源0xd30c，269号。
        H.anm_cast(a,0)
        return B.part23(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,186)
        -- 源0xd320，42号。
        H.push(v,1)
        H.at(a,v,186)
        -- 源0xd334，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(186);return B.part4(a,v) end
        return B.part24(a,v)
    end
    function B.part24(a,v)
        H.at(a,v,186)
        -- 源0xd34c，12号。
        v.origin=H.clock(a)-(186);return B.part26(a,v)
    end
    function B.part25(a,v)
        H.at(a,v,186)
        -- 源0xd364，83号。
        v.origin=v.origin+H.int(1000)
        return B.part26(a,v)
    end
    function B.part26(a,v)
        H.at(a,v,186)
        -- 源0xd378，42号。
        H.push(v,1)
        H.at(a,v,186)
        -- 源0xd38c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(186);return B.part25(a,v) end
        return B.part27(a,v)
    end
    function B.part27(a,v)
        H.at(a,v,186)
        -- 源0xd3a4，10号。
        return
    end
    P["MBossCard1"]=B.part1
end

-- stage03.ecl：MBossCard1At，0xd3c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd3c4，40号。
        H.at(a,v,0)
        -- 源0xd3d8，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0xd3ec，15号。
        H.async(a,P["MBossCard1At_at"],"MBossCard1At_at",nil)
        H.at(a,v,0)
        -- 源0xd410，284号。
        H.velocity(a,0,H.read(a,v,-9981),1.0)
        H.at(a,v,0)
        -- 源0xd428，285号。
        H.velocity_time(a,0,60,0,-999999.0,3.0)
        H.at(a,v,0)
        -- 源0xd448，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xd45c，346号。
        a.protect=32.0
        H.at(a,v,0)
        -- 源0xd470，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0xd484，1号。
        H.erase(a);return
    end
    P["MBossCard1At"]=B.part1
end

-- stage03.ecl：MBossCard1At_at，0xd4b4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd4b4，40号。
        H.at(a,v,0)
        -- 源0xd4c8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd4dc，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xd4f4，402号。
        H.gun_sprite(a,0,7,4)
        H.at(a,v,0)
        -- 源0xd510，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xd52c，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0xd548，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0xd564，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd594，409号。
        H.gun_transform(a,0,1,0,512,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd5c4，409号。
        H.gun_transform(a,0,2,0,4096,90,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd5f4，409号。
        H.gun_transform(a,0,3,0,2048,7,2,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd624，42号。
        H.push(v,600)
        H.at(a,v,0)
        -- 源0xd638，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd64c，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xd660，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd674，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0xd688，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xd69c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd6ac，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd6c0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0xd6d4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd6e8，44号。
        H.push(v,0.0062500000931322575)
        H.at(a,v,0)
        -- 源0xd6fc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd710，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd728，409号。
        H.gun_transform(a,0,4,0,4,240,-999999,(v.l[12] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xd758，404号。
        H.gun_angle(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0xd774，437号。
        H.gun_polar(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd790，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd7a4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xd7b8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd7c8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd7e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd7f4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0xd808，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd818，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd82c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd840，44号。
        H.push(v,H.read(a,v,-9979))
        H.at(a,v,0)
        -- 源0xd854，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xd864，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd878，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0xd88c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd8a0，44号。
        H.push(v,H.read(a,v,-9979))
        H.at(a,v,0)
        -- 源0xd8b4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd8c4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd8d8，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0xd8ec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd900，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xd914，44号。
        H.push(v,1.399999976158142)
        H.at(a,v,0)
        -- 源0xd928，42号。
        H.push(v,240)
        H.at(a,v,0)
        -- 源0xd93c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xd94c，70号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd95c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xd974，44号。
        H.push(v,0.004999999888241291)
        H.at(a,v,0)
        -- 源0xd988，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd99c，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xd9b4，44号。
        H.push(v,0.0062500000931322575)
        H.at(a,v,0)
        -- 源0xd9c8，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xd9dc，83号。
        v.origin=v.origin+H.int(2)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xd9f0，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0xda04，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xda1c，10号。
        return
    end
    P["MBossCard1At_at"]=B.part1
end

-- stage03.ecl：MBossDead，0xda3c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xda3c，40号。
        H.at(a,v,0)
        -- 源0xda50，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0xda64，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xda74，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xda88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xda9c，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xdaac，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xdac4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xdad8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xdaec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xdafc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xdb14，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xdb48，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xdb60，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xdb98，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xdbb0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xdbc4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xdbd8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xdbe8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xdc00，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0xdc14，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xdc2c，421号。
        H.cancel(a,640.0,false)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xdc40，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xdc50，327号。
        H.drop_extra(a,4,1)
        H.at(a,v,0)
        -- 源0xdc68，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,0)
        -- 源0xdc80，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xdc98，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0xdca8，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0xdcbc，337号。
        H.shake(a,30,12,0)
        H.at(a,v,0)
        -- 源0xdcd8，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0xdcf0，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0xdd04，344号。
        a.chapter=0
        H.at(a,v,0)
        -- 源0xdd18，1号。
        H.erase(a);return
    end
    P["MBossDead"]=B.part1
end

-- stage03.ecl：MBossEscape，0xdd48；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdd48，40号。
        H.at(a,v,0)
        -- 源0xdd5c，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0xdd80，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0xdda4，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xddb4，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0xddc4，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xddd8，442号。
        a.hide_life=1~=0
        H.at(a,v,0)
        -- 源0xddec，440号。
        H.fog(a,0.0,16744703)
        H.at(a,v,0)
        -- 源0xde04，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xde14，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0xde24，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xde38，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xde4c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xde5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xde74，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0xde88，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xdea0，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xdeb4，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0xdec8，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0xdedc，441号。
        H.stage_label(a,1)
        H.at(a,v,0)
        -- 源0xdef0，338号。
        H.dialog(a,3)
        H.at(a,v,0)
        -- 源0xdf04，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xdf18，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xdf2c，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xdf44，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,66)
        -- 源0xdf64，339号。
        H.dialog_wait(a,v)
        H.at(a,v,66)
        -- 源0xdf74，332号。
        H.boss_slot(a,-1)
        H.at(a,v,66)
        -- 源0xdf88，441号。
        H.stage_label(a,2)
        H.at(a,v,66)
        -- 源0xdf9c，322号。
        H.flags(a,16,true)
        H.at(a,v,66)
        -- 源0xdfb0，324号。
        H.limit(a,0.0,128.0,128.0,32.0)
        H.at(a,v,66)
        -- 源0xdfd0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,66)
        -- 源0xdfe4，42号。
        H.push(v,0)
        H.at(a,v,66)
        -- 源0xdff8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,66)
        -- 源0xe008，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(66);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,66)
        -- 源0xe020，326号。
        H.drop_clear(a)
        H.at(a,v,66)
        -- 源0xe030，327号。
        H.drop_extra(a,1,8)
        H.at(a,v,66)
        -- 源0xe048，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,66)
        -- 源0xe05c，42号。
        H.push(v,1)
        H.at(a,v,66)
        -- 源0xe070，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,66)
        -- 源0xe080，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(66);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,66)
        -- 源0xe098，330号。
        H.drop_main(a,5)
        H.at(a,v,66)
        -- 源0xe0ac，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,66)
        -- 源0xe0bc，42号。
        H.push(v,1)
        H.at(a,v,66)
        -- 源0xe0d0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,66)
        -- 源0xe0e4，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,66)
        -- 源0xe0fc，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,66)
        -- 源0xe114，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,66)
        -- 源0xe124，344号。
        a.chapter=0
        H.at(a,v,66)
        -- 源0xe138，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,66)
        -- 源0xe14c，332号。
        H.boss_slot(a,0)
        H.at(a,v,66)
        -- 源0xe160，442号。
        a.hide_life=1~=0
        H.at(a,v,66)
        -- 源0xe174，11号。
        H.call(a,v,P["MBoss3"],"MBoss3")
        H.at(a,v,66)
        -- 源0xe190，12号。
        v.origin=H.clock(a)-(66);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,66)
        -- 源0xe1a8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,66)
        -- 源0xe1bc，42号。
        H.push(v,1)
        H.at(a,v,66)
        -- 源0xe1d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(66);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,66)
        -- 源0xe1e8，1号。
        H.erase(a);return
    end
    P["MBossEscape"]=B.part1
end

-- stage03.ecl：MBoss_at1，0xe218；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe218，40号。
        H.at(a,v,0)
        -- 源0xe22c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0xe240，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe254，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0xe268，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe27c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xe290，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe2a4，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xe2b8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe2d0，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe2f0，256号。
        H.spawn(a,256,"RCir01MBoss",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe324，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe338，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe34c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe35c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe370，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xe384，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe3a4，256号。
        H.spawn(a,256,"RCir01MBoss",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe3d8，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe3ec，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe400，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe410，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe424，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xe438，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe458，256号。
        H.spawn(a,256,"RCir01MBoss",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe48c，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe4a0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe4b4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe4c4，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe4d8，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe4ec，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xe500，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe518，10号。
        return
    end
    P["MBoss_at1"]=B.part1
end

-- stage03.ecl：MBoss_at2，0xe538；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe538，40号。
        H.at(a,v,0)
        -- 源0xe54c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0xe560，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe574，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xe588，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe59c，44号。
        H.push(v,-2.4166100025177)
        H.at(a,v,0)
        -- 源0xe5b0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe5c4，259号。
        H.anm_slot(a,0,6)
        H.at(a,v,0)
        -- 源0xe5dc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe5f4，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe614，256号。
        H.spawn(a,256,"BCir01MBoss2",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe64c，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe660，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe674，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe684，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe698，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xe6ac，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe6cc，256号。
        H.spawn(a,256,"BCir01MBoss2",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe704，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe718，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe72c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe73c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe750，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xe764，81号。
        do local r=32.0;local angle=H.read(a,v,-9978);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe784，256号。
        H.spawn(a,256,"BCir01MBoss2",(v.l[4] or 0),(v.l[8] or 0),200,1000,2)
        H.at(a,v,0)
        -- 源0xe7bc，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0xe7d0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0xe7e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe7f4，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe808，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe81c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xe830，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe848，10号。
        return
    end
    P["MBoss_at2"]=B.part1
end

-- stage03.ecl：MainBossDebug，0xe868；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe868，40号。
        H.at(a,v,60)
        -- 源0xe87c，338号。
        H.dialog(a,0)
        H.at(a,v,60)
        -- 源0xe890，257号。
        H.spawn(a,257,"Boss",-144.0,-16.0,40,1000,1)
        H.at(a,v,60)
        -- 源0xe8c0，500号。
        H.debug_entry(a,100)
        H.at(a,v,60)
        -- 源0xe8d4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0xe8e4，340号。
        H.boss_wait(a,v)
        H.at(a,v,120)
        -- 源0xe8f4，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0xe908，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0xe918，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage03.ecl：MainMBossDebug，0xe948；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe948，40号。
        H.at(a,v,0)
        -- 源0xe95c，257号。
        H.spawn(a,257,"MBoss",-144.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0xe98c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe9a4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe9b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe9cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe9e4，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage03.ecl：MainMsgDebug，0xea04；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xea04，40号。
        H.at(a,v,0)
        -- 源0xea18，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0xea2c，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0xea40，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0xea50，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0xea60，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0xea74，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0xea84，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0xea9c，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0xeaac，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0xeac0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0xead8，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage03.ecl：MainSub00，0xeaf8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xeaf8，40号。
        H.at(a,v,0)
        -- 源0xeb0c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xeb20，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xeb34，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xeb44，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xeb58，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xeb68，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),192.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xeb98，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xebac，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xebc0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xebd4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xebe4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xebf8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xec08，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),176.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xec38，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xec4c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xec60，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xec74，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xec84，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xec98，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xeca8，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),160.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xecd8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xecec，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xed00，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xed14，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xed24，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xed38，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xed48，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),144.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xed78，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xed8c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xeda0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xedb4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xedc4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xedd8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xede8，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),128.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xee18，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xee2c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xee40，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xee54，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xee64，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xee78，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xee88，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),112.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xeeb8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xeecc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xeee0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xeef4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xef04，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xef18，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xef28，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),96.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xef58，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xef6c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xef80，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xef94，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xefa4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xefb8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xefc8，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),80.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xeff8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf00c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf020，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xf034，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf044，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf058，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf068，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),64.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xf098，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf0ac，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf0c0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xf0d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf0e4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf0f8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf108，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),48.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xf138，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf14c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf160，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xf174，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf184，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf198，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf1a8，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),32.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xf1d8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf1ec，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf200，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xf214，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf224，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf238，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf248，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),16.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xf278，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf28c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf2a0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xf2b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf2c4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf2d8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf2e8，256号。
        H.spawn(a,256,"RCir00",H.read(a,v,-1),0.0,250,1000,2)
        H.at(a,v,0)
        -- 源0xf318，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xf32c，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage03.ecl：MainSub01，0xf34c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf34c，40号。
        H.at(a,v,0)
        -- 源0xf360，83号。
        v.origin=v.origin+H.int(480)
        H.at(a,v,0)
        -- 源0xf374，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf3a4，261号。
        H.spawn(a,261,"BGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf3d4，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf3e8，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf418，261号。
        H.spawn(a,261,"BGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf448，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf45c，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf48c，261号。
        H.spawn(a,261,"BGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf4bc，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf4d0，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf500，261号。
        H.spawn(a,261,"BGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf530，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf544，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf574，261号。
        H.spawn(a,261,"BGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xf5a4，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage03.ecl：MainSub02，0xf5c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf5c4，40号。
        H.at(a,v,0)
        -- 源0xf5d8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xf5ec，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf600，257号。
        H.spawn(a,257,"PCir01",0.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf630，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xf644，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xf658，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf66c，257号。
        H.spawn(a,257,"PCir01",-64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf69c，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0xf6b0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xf6c4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf6d8，257号。
        H.spawn(a,257,"PCir01",140.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf708，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf71c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xf730，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf744，257号。
        H.spawn(a,257,"PCir01",-144.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf774，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0xf788，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xf79c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf7b0，257号。
        H.spawn(a,257,"PCir01",0.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf7e0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xf7f4，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xf808，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf81c，257号。
        H.spawn(a,257,"PCir01",64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf84c，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0xf860，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xf874，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf888，257号。
        H.spawn(a,257,"PCir01",-160.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf8b8，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf8cc，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xf8e0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf8f4，257号。
        H.spawn(a,257,"PCir01",128.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf924，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xf938，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xf94c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf960，257号。
        H.spawn(a,257,"PCir01",-96.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf990，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0xf9a4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xf9b8，257号。
        H.spawn(a,257,"PCir01",96.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0xf9e8，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xf9fc，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage03.ecl：MainSub03，0xfa1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfa1c，40号。
        H.at(a,v,0)
        -- 源0xfa30，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,0)
        -- 源0xfa44，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfa58，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfa6c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfa7c，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),192.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfaac，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xfac0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfad4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfae8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfaf8，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),176.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfb28，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0xfb3c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfb50，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfb64，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfb74，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xfb88，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xfb98，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),160.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfbc8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xfbdc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfbf0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfc04，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfc14，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xfc28，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xfc38，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),144.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfc68，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0xfc7c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfc90，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfca4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfcb4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xfcc8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfcd8，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),128.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfd08，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xfd1c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfd30，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfd44，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfd54，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xfd68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfd78，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),112.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfda8，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0xfdbc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfdd0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfde4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfdf4，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),192.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfe24，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xfe38，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xfe4c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfe60，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfe70，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),176.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xfea0，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage03.ecl：MainSub04，0xfec0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfec0，40号。
        H.at(a,v,0)
        -- 源0xfed4，257号。
        H.spawn(a,257,"BGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xff04，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xff34，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xff48，257号。
        H.spawn(a,257,"BGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xff78，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xffa8，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0xffbc，257号。
        H.spawn(a,257,"BGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xffec，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x1001c，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x10030，257号。
        H.spawn(a,257,"BGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x10060，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x10090，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x100a4，257号。
        H.spawn(a,257,"BGirl00",-224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x100d4，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x10104，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage03.ecl：MainSub05，0x10124；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10124，40号。
        H.at(a,v,0)
        -- 源0x10138，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x1014c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x10160，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x10174，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10184，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x10198，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x101a8，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),192.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x101d8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x101ec，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x10200，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x10214，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10224，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x10238，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x10248，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),176.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x10278，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1028c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x102a0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x102b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x102c4，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x102d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x102e8，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),128.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x10318，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x1032c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x10340，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x10354，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10364，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x10378，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x10388，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),112.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x103b8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x103cc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x103e0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x103f4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10404，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x10418，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x10428，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),192.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x10458，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1046c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x10480，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10490，42号。
        H.push(v,144)
        H.at(a,v,0)
        -- 源0x104a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x104b4，256号。
        H.spawn(a,256,"BCir02",H.read(a,v,-1),176.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x104e4，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage03.ecl：MainSub06，0x10504；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10504，40号。
        H.at(a,v,0)
        -- 源0x10518，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x1052c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x10540，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10554，257号。
        H.spawn(a,257,"PCir01",0.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10584，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x10598，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x105ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x105c0，257号。
        H.spawn(a,257,"PCir01",-64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x105f0，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0x10604，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x10618，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1062c，257号。
        H.spawn(a,257,"PCir01",140.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x1065c，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x10670，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x10684，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10698，257号。
        H.spawn(a,257,"PCir01",-144.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x106c8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x106dc，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x106f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10704，257号。
        H.spawn(a,257,"PCir01",0.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10734，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x10748，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x1075c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10770，257号。
        H.spawn(a,257,"PCir01",64.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x107a0，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0x107b4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x107c8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x107dc，257号。
        H.spawn(a,257,"PCir01",-160.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x1080c，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x10820，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x10834，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10848，257号。
        H.spawn(a,257,"PCir01",128.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10878，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1088c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x108a0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x108b4，257号。
        H.spawn(a,257,"PCir01",-96.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x108e4，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x108f8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1090c，257号。
        H.spawn(a,257,"PCir01",96.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x1093c，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x10950，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x10964，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10978，257号。
        H.spawn(a,257,"PCir01",-144.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x109a8，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x109bc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x109d0，257号。
        H.spawn(a,257,"PCir01",144.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10a00，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x10a14，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x10a28，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10a3c，257号。
        H.spawn(a,257,"PCir01",-176.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10a6c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x10a80，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10a94，257号。
        H.spawn(a,257,"PCir01",176.0,-32.0,400,1000,2)
        H.at(a,v,0)
        -- 源0x10ac4，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x10ad8，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage03.ecl：MapleEnemy，0x10af8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10af8，40号。
        H.at(a,v,0)
        -- 源0x10b0c，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x10b20，264号。
        H.effect_abs(a,0,173)
        H.at(a,v,3)
        -- 源0x10b38，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x10b50，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage03.ecl：MapleEnemy2，0x10b70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10b70，40号。
        H.at(a,v,0)
        -- 源0x10b84，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x10b98，264号。
        H.effect_abs(a,0,172)
        H.at(a,v,3)
        -- 源0x10bb0，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x10bc8，1号。
        H.erase(a);return
    end
    P["MapleEnemy2"]=B.part1
end

-- stage03.ecl：PCir00，0x10be8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10be8，40号。
        H.at(a,v,0)
        -- 源0x10bfc，11号。
        H.call(a,v,P["Cir00"],"Cir00",90,48,1)
        H.at(a,v,0)
        -- 源0x10c30，1号。
        H.erase(a);return
    end
    P["PCir00"]=B.part1
end

-- stage03.ecl：PCir01，0x10c50；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10c50，40号。
        H.at(a,v,0)
        -- 源0x10c64，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10c78，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x10c90，11号。
        H.call(a,v,P["Cir01"],"Cir01",78,1)
        H.at(a,v,0)
        -- 源0x10cbc，1号。
        H.erase(a);return
    end
    P["PCir01"]=B.part1
end

-- stage03.ecl：PCir01Boss1，0x10cdc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10cdc，40号。
        H.at(a,v,0)
        -- 源0x10cf0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10d04，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x10d18，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x10d30，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x10d44，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10d58，11号。
        H.call(a,v,P["Cir01Boss1"],"Cir01Boss1",90,1)
        H.at(a,v,0)
        -- 源0x10d88，1号。
        H.erase(a);return
    end
    P["PCir01Boss1"]=B.part1
end

-- stage03.ecl：PCir01Boss12，0x10da8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10da8，40号。
        H.at(a,v,0)
        -- 源0x10dbc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10dd0，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x10de4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x10dfc，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x10e10，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10e24，11号。
        H.call(a,v,P["Cir01Boss12"],"Cir01Boss12",90,1)
        H.at(a,v,0)
        -- 源0x10e54，1号。
        H.erase(a);return
    end
    P["PCir01Boss12"]=B.part1
end

-- stage03.ecl：PCir01Boss2，0x10e74；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10e74，40号。
        H.at(a,v,0)
        -- 源0x10e88，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10e9c，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x10eb0，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x10ec8，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x10edc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10ef0，11号。
        H.call(a,v,P["Cir01Boss2"],"Cir01Boss2",90,1)
        H.at(a,v,0)
        -- 源0x10f20，1号。
        H.erase(a);return
    end
    P["PCir01Boss2"]=B.part1
end

-- stage03.ecl：PCir01Boss22，0x10f40；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10f40，40号。
        H.at(a,v,0)
        -- 源0x10f54，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10f68，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x10f7c，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x10f94，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x10fa8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x10fbc，11号。
        H.call(a,v,P["Cir01Boss22"],"Cir01Boss22",90,1)
        H.at(a,v,0)
        -- 源0x10fec，1号。
        H.erase(a);return
    end
    P["PCir01Boss22"]=B.part1
end

-- stage03.ecl：PCir01MBoss，0x1100c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1100c，40号。
        H.at(a,v,0)
        -- 源0x11020，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x11034，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x11048，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x11060，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x11074，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x11088，11号。
        H.call(a,v,P["Cir01MBoss"],"Cir01MBoss",90,1)
        H.at(a,v,0)
        -- 源0x110b8，1号。
        H.erase(a);return
    end
    P["PCir01MBoss"]=B.part1
end

-- stage03.ecl：PCir01MBoss2，0x110d8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x110d8，40号。
        H.at(a,v,0)
        -- 源0x110ec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x11100，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x11114，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x1112c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x11140，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x11154，11号。
        H.call(a,v,P["Cir01MBoss2"],"Cir01MBoss2",90,1)
        H.at(a,v,0)
        -- 源0x11184，1号。
        H.erase(a);return
    end
    P["PCir01MBoss2"]=B.part1
end

-- stage03.ecl：PCir02，0x111a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x111a4，40号。
        H.at(a,v,0)
        -- 源0x111b8，11号。
        H.call(a,v,P["Cir02"],"Cir02",90,48,1)
        H.at(a,v,0)
        -- 源0x111ec，1号。
        H.erase(a);return
    end
    P["PCir02"]=B.part1
end

-- stage03.ecl：PCir03，0x1120c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1120c，40号。
        H.at(a,v,0)
        -- 源0x11220，11号。
        H.call(a,v,P["Cir03"],"Cir03",90,48,1)
        H.at(a,v,0)
        -- 源0x11254，1号。
        H.erase(a);return
    end
    P["PCir03"]=B.part1
end

-- stage03.ecl：RCir00，0x11274；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x11274，40号。
        H.at(a,v,0)
        -- 源0x11288，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x1129c，11号。
        H.call(a,v,P["Cir00"],"Cir00",81,46,1)
        H.at(a,v,0)
        -- 源0x112d0，1号。
        H.erase(a);return
    end
    P["RCir00"]=B.part1
end

-- stage03.ecl：RCir00_at，0x112f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x112f0，40号。
        H.at(a,v,0)
        -- 源0x11304，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x11318，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x11330，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x1134c，436号。
        H.gun_count_diff(a,0,4,4,4,4,1,1,1,1)
        H.at(a,v,0)
        -- 源0x11380，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x1139c，435号。
        H.gun_speed_diff(a,0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x113d0，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x113ec，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1141c，356号。
        v.l[8]=H.f32(0.0555555559694767)
        H.at(a,v,0)
        -- 源0x11440，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x11470，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x11484，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x1149c，402号。
        H.gun_sprite(a,1,2,6)
        H.at(a,v,0)
        -- 源0x114b8，406号。
        H.gun_count(a,1,3,1)
        H.at(a,v,0)
        -- 源0x114d4，404号。
        H.gun_angle(a,1,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x114f0，405号。
        H.gun_speed(a,1,1.0,1.0)
        H.at(a,v,0)
        -- 源0x1150c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x11528，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x11558，409号。
        H.gun_transform(a,1,1,0,4,90,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x11588，355号。
        v.l[12]=H.int(20)
        H.at(a,v,0)
        -- 源0x115ac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x115c4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x115d8，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x115ec，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1160c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x11620，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x11638，10号。
        return
    end
    P["RCir00_at"]=B.part1
end

-- stage03.ecl：RCir01，0x11658；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x11658，40号。
        H.at(a,v,0)
        -- 源0x1166c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x11680，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x11698，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x116ac，11号。
        H.call(a,v,P["Cir01"],"Cir01",69,1)
        H.at(a,v,0)
        -- 源0x116d8，1号。
        H.erase(a);return
    end
    P["RCir01"]=B.part1
end

-- stage03.ecl：RCir01Boss1，0x116f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x116f8，40号。
        H.at(a,v,0)
        -- 源0x1170c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x11720，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x11738，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x1174c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x11760，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x11774，11号。
        H.call(a,v,P["Cir01Boss1"],"Cir01Boss1",81,1)
        H.at(a,v,0)
        -- 源0x117a4，1号。
        H.erase(a);return
    end
    P["RCir01Boss1"]=B.part1
end

-- stage03.ecl：RCir01Boss12，0x117c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x117c4，40号。
        H.at(a,v,0)
        -- 源0x117d8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x117ec，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x11804，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x11818，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1182c，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x11840，11号。
        H.call(a,v,P["Cir01Boss12"],"Cir01Boss12",81,1)
        H.at(a,v,0)
        -- 源0x11870，1号。
        H.erase(a);return
    end
    P["RCir01Boss12"]=B.part1
end

-- stage03.ecl：RCir01Boss1_at，0x11890；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x11890，40号。
        H.at(a,v,0)
        -- 源0x118a4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x118b8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x118d0，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x118ec，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,2,3,4)
        H.at(a,v,0)
        -- 源0x11920，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1193c，435号。
        H.gun_speed_diff(a,0,3.0,4.0,4.0,4.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x11970，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x119a0，409号。
        H.gun_transform(a,0,2,0,2048,2,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x119d0，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x119e4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x119f8，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x11a0c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11a20，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x11a30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11a44，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11a58，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x11a68，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11a7c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11a90，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11aa4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x11abc，409号。
        H.gun_transform(a,0,1,0,16,60,1,(v.l[4] or 0),1.5)
        H.at(a,v,0)
        -- 源0x11aec，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x11b08，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x11b1c，83号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x11b30，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x11b44，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11b58，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x11b6c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x11b7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x11b8c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11ba0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x11bb4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11bc8，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x11bdc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x11bec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x11bfc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11c10，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x11c24，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11c38，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x11c4c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x11c5c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x11c6c，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x11c80，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x11c94，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x11cac，10号。
        return
    end
    P["RCir01Boss1_at"]=B.part1
end

-- stage03.ecl：RCir01Boss1_at2，0x11ccc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x11ccc，40号。
        H.at(a,v,0)
        -- 源0x11ce0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x11cf4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x11d0c，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x11d28，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,2,3,4)
        H.at(a,v,0)
        -- 源0x11d5c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x11d78，435号。
        H.gun_speed_diff(a,0,3.0,4.0,4.0,4.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x11dac，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x11ddc，409号。
        H.gun_transform(a,0,2,0,2048,2,10,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x11e0c，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x11e20，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x11e34，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x11e48，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11e5c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x11e6c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11e80，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11e94，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x11ea4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11eb8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11ecc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11ee0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x11ef8，409号。
        H.gun_transform(a,0,1,0,16,60,1,0.0,1.5)
        H.at(a,v,0)
        -- 源0x11f28，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x11f44，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x11f58，83号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x11f6c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x11f80，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x11f94，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x11fa8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x11fb8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x11fc8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11fdc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x11ff0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12004，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x12018，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12028，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12038，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1204c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x12060，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12074，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x12088，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12098，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x120a8，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x120bc，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x120d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x120e8，10号。
        return
    end
    P["RCir01Boss1_at2"]=B.part1
end

-- stage03.ecl：RCir01Boss2，0x12108；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x12108，40号。
        H.at(a,v,0)
        -- 源0x1211c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x12130，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x12148，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x1215c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x12170，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x12184，11号。
        H.call(a,v,P["Cir01Boss2"],"Cir01Boss2",81,1)
        H.at(a,v,0)
        -- 源0x121b4，1号。
        H.erase(a);return
    end
    P["RCir01Boss2"]=B.part1
end

-- stage03.ecl：RCir01Boss22，0x121d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x121d4，40号。
        H.at(a,v,0)
        -- 源0x121e8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x121fc，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x12214，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x12228，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1223c，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x12250，11号。
        H.call(a,v,P["Cir01Boss22"],"Cir01Boss22",81,1)
        H.at(a,v,0)
        -- 源0x12280，1号。
        H.erase(a);return
    end
    P["RCir01Boss22"]=B.part1
end

-- stage03.ecl：RCir01Boss2_at，0x122a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x122a0，40号。
        H.at(a,v,0)
        -- 源0x122b4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x122c8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x122e0，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x122fc，406号。
        H.gun_count(a,0,1,3)
        H.at(a,v,0)
        -- 源0x12318，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x12334，405号。
        H.gun_speed(a,0,4.0,1.0)
        H.at(a,v,0)
        -- 源0x12350，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x12380，409号。
        H.gun_transform(a,0,2,0,2048,2,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x123b0，355号。
        v.l[12]=H.int(12)
        H.at(a,v,0)
        -- 源0x123d4，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x123e8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x123fc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1240c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12420，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12434，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x12444，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12458，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1246c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12480，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x12498，409号。
        H.gun_transform(a,0,1,0,16,60,1,(v.l[4] or 0),1.5)
        H.at(a,v,0)
        -- 源0x124c8，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x124e4，413号。
        H.laser(a,413,H.read(a,v,-9984),3,2,(v.l[0] or 0),360.0,360.0,50,30,60,30,16.0,4)
        H.at(a,v,0)
        -- 源0x12524，368号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x12544，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12558，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1256c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1257c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x12594，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x125a8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x125bc，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x125d0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x125e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x125f0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12604，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x12618，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1262c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x12640，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12650，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12660，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12674，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x12688，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1269c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x126b0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x126c0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x126d0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x126e4，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x126fc，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12710，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x12724，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x12734，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1274c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12760，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12774，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x12788，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12798，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x127a8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x127bc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x127d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x127e4，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x127f8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12808，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12818，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1282c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x12840，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12854，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x12868，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12878，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x12888，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1289c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x128b4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x128c8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x128dc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x128ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x12904，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12918，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1292c，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x12940，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12950，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12960，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12974，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x12988，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1299c，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x129b0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x129c0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x129d0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x129e4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x129f8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12a0c，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x12a20，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12a30，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x12a40，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12a54，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x12a6c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12a80，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12a94，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x12aa8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12ab8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12ac8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12adc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x12af0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12b04，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x12b18，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12b28，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12b38，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12b4c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x12b60，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12b74，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x12b88，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12b98，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x12ba8，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x12bbc，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x12bd0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x12be8，10号。
        return
    end
    P["RCir01Boss2_at"]=B.part1
end

-- stage03.ecl：RCir01Boss2_at2，0x12c08；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x12c08，40号。
        H.at(a,v,0)
        -- 源0x12c1c，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x12c4c，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x12c7c，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x12cac，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0x12cc8，355号。
        v.l[4]=H.int(12)
        H.at(a,v,0)
        -- 源0x12cec，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x12d00，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12d14，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x12d24，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12d38，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x12d50，431号。
        H.laser(a,431,3,H.read(a,v,-9985),(v.l[0] or 0),6.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x12d80，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12d94，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x12da8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12db8，431号。
        H.laser(a,431,3,H.read(a,v,-9985),H.read(a,v,-1),6.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x12de8，368号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x12e08，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12e1c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x12e30，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x12e40，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x12e58，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12e6c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12e80，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x12e94，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12ea4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12eb4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12ec8，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x12ee0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12ef4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x12f08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x12f18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x12f30，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12f44，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x12f58，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x12f6c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12f7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12f8c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12fa0，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x12fb8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x12fcc，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x12fe0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x12ff0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x13008，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1301c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13030，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x13044，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13054，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13064，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13078，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x13090，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x130a4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x130b8，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x130cc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x130dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x130ec，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x13100，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x13114，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1312c，10号。
        return
    end
    P["RCir01Boss2_at2"]=B.part1
end

-- stage03.ecl：RCir01MBoss，0x1314c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1314c，40号。
        H.at(a,v,0)
        -- 源0x13160，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x13174，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x1318c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x131a0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x131b4，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x131c8，11号。
        H.call(a,v,P["Cir01MBoss"],"Cir01MBoss",81,1)
        H.at(a,v,0)
        -- 源0x131f8，1号。
        H.erase(a);return
    end
    P["RCir01MBoss"]=B.part1
end

-- stage03.ecl：RCir01MBoss2，0x13218；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13218，40号。
        H.at(a,v,0)
        -- 源0x1322c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x13240，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x13258，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x1326c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x13280，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x13294，11号。
        H.call(a,v,P["Cir01MBoss2"],"Cir01MBoss2",81,1)
        H.at(a,v,0)
        -- 源0x132c4，1号。
        H.erase(a);return
    end
    P["RCir01MBoss2"]=B.part1
end

-- stage03.ecl：RCir01MBoss_at，0x132e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x132e4，40号。
        H.at(a,v,0)
        -- 源0x132f8，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x13328，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x13358，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x13388，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0x133a4，355号。
        v.l[4]=H.int(32)
        H.at(a,v,0)
        -- 源0x133c8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x133dc，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x133f0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x13400，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13414，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1342c，431号。
        H.laser(a,431,3,H.read(a,v,-9985),(v.l[0] or 0),6.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x1345c，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x1347c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13490，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x134a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x134b4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x134cc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x134e0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x134f4，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x13508，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13518，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13528，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1353c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x13554，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13568，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1357c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1358c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x135a4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x135b8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x135cc，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x135e0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x135f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13600，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13614，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1362c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13640，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x13654，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13664，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1367c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13690，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x136a4，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x136b8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x136c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x136d8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x136ec，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x13704，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13718，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1372c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x13740，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13750，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13760，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x13774，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x13788，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x137a0，10号。
        return
    end
    P["RCir01MBoss_at"]=B.part1
end

-- stage03.ecl：RCir01MBoss_at2，0x137c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x137c0，40号。
        H.at(a,v,0)
        -- 源0x137d4，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x13804，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x13834，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0x13864，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0x13880，355号。
        v.l[4]=H.int(32)
        H.at(a,v,0)
        -- 源0x138a4，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x138b8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x138cc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x138dc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x138f0，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x13908，431号。
        H.laser(a,431,3,H.read(a,v,-9985),(v.l[0] or 0),6.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x13938，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x13958，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1396c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x13980，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13990，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x139a8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x139bc，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x139d0，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x139e4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x139f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13a04，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13a18，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x13a30，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13a44，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x13a58，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13a68，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x13a80，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13a94，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13aa8，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x13abc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13acc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13adc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13af0，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x13b08，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13b1c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x13b30，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13b40，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x13b58，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13b6c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13b80，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x13b94，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13ba4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13bb4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13bc8，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x13be0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13bf4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13c08，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x13c1c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13c2c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13c3c，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x13c50，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x13c64，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x13c7c，10号。
        return
    end
    P["RCir01MBoss_at2"]=B.part1
end

-- stage03.ecl：RCir01_at，0x13c9c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13c9c，40号。
        H.at(a,v,0)
        -- 源0x13cb0，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.125,-999999.0)
        H.at(a,v,0)
        -- 源0x13ce0，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x13d10，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.125,-999999.0)
        H.at(a,v,0)
        -- 源0x13d40，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0x13d5c，355号。
        v.l[4]=H.int(32)
        H.at(a,v,0)
        -- 源0x13d80，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x13d94，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13da8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x13db8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13dcc，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x13de4，431号。
        H.laser(a,431,3,2,(v.l[0] or 0),8.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x13e14，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13e28，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x13e3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13e4c，431号。
        H.laser(a,431,3,2,H.read(a,v,-1),8.0,0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0x13e7c，368号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x13e9c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13eb0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x13ec4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13ed4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x13eec，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13f00，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13f14，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x13f28，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13f38，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13f48，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13f5c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x13f74，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x13f88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x13f9c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x13fac，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x13fc4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x13fd8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x13fec，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x14000，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x14010，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x14020，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x14034，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1404c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x14060，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x14074，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x14084，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1409c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x140b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x140c4，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x140d8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x140e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x140f8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1410c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x14124，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x14138，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1414c，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x14160，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x14170，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x14180，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x14194，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x141a8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x141c0，10号。
        return
    end
    P["RCir01_at"]=B.part1
end

-- stage03.ecl：RCir02，0x141e0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x141e0，40号。
        H.at(a,v,0)
        -- 源0x141f4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x14208，11号。
        H.call(a,v,P["Cir02"],"Cir02",81,46,1)
        H.at(a,v,0)
        -- 源0x1423c，1号。
        H.erase(a);return
    end
    P["RCir02"]=B.part1
end

-- stage03.ecl：RCir02_at，0x1425c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1425c，40号。
        H.at(a,v,0)
        -- 源0x14270，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x14284，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x1429c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x142b8，406号。
        H.gun_count(a,0,4,1)
        H.at(a,v,0)
        -- 源0x142d4，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x142f0，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x1430c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x14328，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x14358，356号。
        v.l[8]=H.f32(0.0555555559694767)
        H.at(a,v,0)
        -- 源0x1437c，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x143ac，355号。
        v.l[12]=H.int(10)
        H.at(a,v,0)
        -- 源0x143d0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x143e8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x143fc，368号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1441c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x14430，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x14448，10号。
        return
    end
    P["RCir02_at"]=B.part1
end

-- stage03.ecl：RCir03，0x14468；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14468，40号。
        H.at(a,v,0)
        -- 源0x1447c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x14490，11号。
        H.call(a,v,P["Cir03"],"Cir03",81,46,1)
        H.at(a,v,0)
        -- 源0x144c4，1号。
        H.erase(a);return
    end
    P["RCir03"]=B.part1
end

-- stage03.ecl：RCir03_at，0x144e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x144e4，40号。
        H.at(a,v,0)
        -- 源0x144f8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1450c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x14524，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x14540，406号。
        H.gun_count(a,0,4,1)
        H.at(a,v,0)
        -- 源0x1455c，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x14578，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x14594，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x145b0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x145e0，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0x14610，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x14624，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x14638，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x14650，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x14664，83号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x14678，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1468c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x146a4，10号。
        return
    end
    P["RCir03_at"]=B.part1
end

-- stage03.ecl：RGirl00，0x146c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x146c4，40号。
        H.at(a,v,0)
        -- 源0x146d8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x146ec，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x14704，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x14718，11号。
        H.call(a,v,P["Girl00"],"Girl00",5,1)
        H.at(a,v,0)
        -- 源0x14744，1号。
        H.erase(a);return
    end
    P["RGirl00"]=B.part1
end

-- stage03.ecl：RGirl00_at，0x14764；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14764，40号。
        H.at(a,v,0)
        -- 源0x14778，355号。
        v.l[4]=H.int(3)
        H.at(a,v,0)
        -- 源0x1479c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x147b0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x147c4，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x147dc，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x147f8，436号。
        H.gun_count_diff(a,0,1,3,5,7,5,5,5,5)
        H.at(a,v,0)
        -- 源0x1482c，404号。
        H.gun_angle(a,0,0.0,0.5235987901687622)
        H.at(a,v,0)
        -- 源0x14848，435号。
        H.gun_speed_diff(a,0,3.200000047683716,4.199999809265137,4.199999809265137,4.199999809265137,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0x1487c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x148ac，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x148dc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x148f0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x14904，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x14918，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x14928，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x14940，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x14958，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x1496c，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x14980，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x14994，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x149ac，10号。
        return
    end
    P["RGirl00_at"]=B.part1
end

-- stage03.ecl：YGirl00，0x149cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x149cc，40号。
        H.at(a,v,0)
        -- 源0x149e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x149f4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x14a0c，11号。
        H.call(a,v,P["Girl00"],"Girl00",15,1)
        H.at(a,v,0)
        -- 源0x14a38，1号。
        H.erase(a);return
    end
    P["YGirl00"]=B.part1
end

-- stage03.ecl：main，0x14a58；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14a58，40号。
        H.at(a,v,0)
        -- 源0x14a6c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x14a80，257号。
        H.spawn(a,257,"MapleEnemy",0.0,-16.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x14ab4，257号。
        H.spawn(a,257,"MapleEnemy2",0.0,-16.0,20,1000,2)
        H.at(a,v,160)
        -- 源0x14ae8，0号。
        H.at(a,v,160)
        -- 源0x14af8，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,160)
        -- 源0x14b18，11号。
        H.call(a,v,P["MainSub01"],"MainSub01")
        H.at(a,v,160)
        -- 源0x14b38，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,160)
        -- 源0x14b4c，15号。
        H.async(a,P["MainSub02"],"MainSub02",nil)
        H.at(a,v,160)
        -- 源0x14b6c，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,160)
        -- 源0x14b8c，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,160)
        -- 源0x14ba0，257号。
        H.spawn(a,257,"MBoss",-144.0,-16.0,40,10000,1)
        H.at(a,v,160)
        -- 源0x14bd0，340号。
        H.boss_wait(a,v)
        H.at(a,v,160)
        -- 源0x14be0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,160)
        -- 源0x14bf4，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,160)
        -- 源0x14c14，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,160)
        -- 源0x14c34，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,160)
        -- 源0x14c54，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,160)
        -- 源0x14c68，338号。
        H.dialog(a,0)
        H.at(a,v,160)
        -- 源0x14c7c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,160)
        -- 源0x14c8c，340号。
        H.boss_wait(a,v)
        H.at(a,v,160)
        -- 源0x14c9c，338号。
        H.dialog(a,1)
        H.at(a,v,160)
        -- 源0x14cb0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,160)
        -- 源0x14cc0，12号。
        v.origin=H.clock(a)-(160);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,160)
        -- 源0x14cd8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,160)
        -- 源0x14cec，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0x14d00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(160);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,40160)
        -- 源0x14d18，0号。
        H.at(a,v,40160)
        -- 源0x14d28，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

return P
