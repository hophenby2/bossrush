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

-- stage04.ecl：BCir00，0x738；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x738，40号。
        H.at(a,v,0)
        -- 源0x74c，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x764，11号。
        H.call(a,v,P["Cir00"],"Cir00",87,45,1)
        H.at(a,v,0)
        -- 源0x798，1号。
        H.erase(a);return
    end
    P["BCir00"]=B.part1
end

-- stage04.ecl：BCir01，0x7b8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7b8，40号。
        H.at(a,v,0)
        -- 源0x7cc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7e0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x7f4，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x80c，11号。
        H.call(a,v,P["Cir01"],"Cir01",75,1)
        H.at(a,v,0)
        -- 源0x838，1号。
        H.erase(a);return
    end
    P["BCir01"]=B.part1
end

-- stage04.ecl：BCir01b，0x858；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x858，40号。
        H.at(a,v,0)
        -- 源0x86c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x880，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x894，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x8ac，11号。
        H.call(a,v,P["Cir01b"],"Cir01b",75,1)
        H.at(a,v,0)
        -- 源0x8d8，1号。
        H.erase(a);return
    end
    P["BCir01b"]=B.part1
end

-- stage04.ecl：BCir02，0x8f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8f8，40号。
        H.at(a,v,0)
        -- 源0x90c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x920，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x934，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x94c，11号。
        H.call(a,v,P["Cir02"],"Cir02",75,1)
        H.at(a,v,0)
        -- 源0x978，1号。
        H.erase(a);return
    end
    P["BCir02"]=B.part1
end

-- stage04.ecl：BCir03，0x998；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x998，40号。
        H.at(a,v,0)
        -- 源0x9ac，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x9c4，11号。
        H.call(a,v,P["Cir03"],"Cir03",87,45,1)
        H.at(a,v,0)
        -- 源0x9f8，1号。
        H.erase(a);return
    end
    P["BCir03"]=B.part1
end

-- stage04.ecl：BGirl00，0xa18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa18，40号。
        H.at(a,v,0)
        -- 源0xa2c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa40，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa54，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xa6c，11号。
        H.call(a,v,P["Girl00"],"Girl00",0,1)
        H.at(a,v,0)
        -- 源0xa98，1号。
        H.erase(a);return
    end
    P["BGirl00"]=B.part1
end

-- stage04.ecl：BGirl00b，0xab8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xab8，40号。
        H.at(a,v,0)
        -- 源0xacc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xae0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xaf4，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xb0c，11号。
        H.call(a,v,P["Girl00b"],"Girl00b",0,1)
        H.at(a,v,0)
        -- 源0xb38，1号。
        H.erase(a);return
    end
    P["BGirl00b"]=B.part1
end

-- stage04.ecl：BGirl01，0xb58；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb58，40号。
        H.at(a,v,0)
        -- 源0xb6c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb80，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb94，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xbac，11号。
        H.call(a,v,P["Girl01"],"Girl01",0,1)
        H.at(a,v,0)
        -- 源0xbd8，1号。
        H.erase(a);return
    end
    P["BGirl01"]=B.part1
end

-- stage04.ecl：BGirl01b，0xbf8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbf8，40号。
        H.at(a,v,0)
        -- 源0xc0c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xc20，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xc34，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xc4c，11号。
        H.call(a,v,P["Girl01b"],"Girl01b",0,1)
        H.at(a,v,0)
        -- 源0xc78，1号。
        H.erase(a);return
    end
    P["BGirl01b"]=B.part1
end

-- stage04.ecl：BGirl02，0xc98；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc98，40号。
        H.at(a,v,0)
        -- 源0xcac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xcc0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xcd4，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xcec，11号。
        H.call(a,v,P["Girl02"],"Girl02",0,1)
        H.at(a,v,0)
        -- 源0xd18，1号。
        H.erase(a);return
    end
    P["BGirl02"]=B.part1
end

-- stage04.ecl：BGirl03，0xd38；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd38，40号。
        H.at(a,v,0)
        -- 源0xd4c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd60，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xd74，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xd8c，11号。
        H.call(a,v,P["Girl03"],"Girl03",0,1)
        H.at(a,v,0)
        -- 源0xdb8，1号。
        H.erase(a);return
    end
    P["BGirl03"]=B.part1
end

-- stage04.ecl：BPhantomMBoss，0xdd8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdd8，40号。
        H.at(a,v,0)
        -- 源0xdec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe00，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xe14，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xe2c，11号。
        H.call(a,v,P["PhantomMBoss"],"PhantomMBoss",98,1)
        H.at(a,v,0)
        -- 源0xe60，1号。
        H.erase(a);return
    end
    P["BPhantomMBoss"]=B.part1
end

-- stage04.ecl：BPhantomMBoss2，0xe80；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe80，40号。
        H.at(a,v,0)
        -- 源0xe94，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xea8，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xebc，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xed4，11号。
        H.call(a,v,P["PhantomMBoss2"],"PhantomMBoss2",98,1)
        H.at(a,v,0)
        -- 源0xf08，1号。
        H.erase(a);return
    end
    P["BPhantomMBoss2"]=B.part1
end

-- stage04.ecl：Boss，0xf28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf28，40号。
        H.at(a,v,0)
        -- 源0xf3c，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0xf50，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xf64，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xf7c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xf90，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xfa8，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xfc0，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xfd4，331号。
        H.life(a,9100)
        H.at(a,v,0)
        -- 源0xfe8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x1008，440号。
        H.fog(a,160.0,16711935)
        H.at(a,v,60)
        -- 源0x1020，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x1030，442号。
        a.hide_life=0~=0
        H.at(a,v,60)
        -- 源0x1044，323号。
        H.flags(a,16,false)
        H.at(a,v,60)
        -- 源0x1058，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,60)
        -- 源0x1078，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x108c，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x10a4，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,60)
        -- 源0x10bc，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x10d0，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x10e4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x10f8，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0x1114，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage04.ecl：Boss1，0x1134；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1134，40号。
        H.at(a,v,0)
        -- 源0x1148，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x1158，334号。
        H.interrupt(a,0,1900,2580,"BossCard1")
        H.at(a,v,0)
        -- 源0x1184，347号。
        H.life_marker(a,0,1900.0,-24448)
        H.at(a,v,0)
        -- 源0x11a0，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0x11b4，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x11c8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x11dc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0x11fc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1210，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1224，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1238，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x124c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1264，15号。
        H.async(a,P["Boss1_at1"],"Boss1_at1",nil)
        H.at(a,v,0)
        -- 源0x1284，11号。
        H.call(a,v,P["Boss1_at2"],"Boss1_at2")
        H.at(a,v,0)
        -- 源0x12a4，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x12c4，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0x12e0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x12f4，15号。
        H.async(a,P["Boss1_at1b"],"Boss1_at1b",nil)
        H.at(a,v,0)
        -- 源0x1314，11号。
        H.call(a,v,P["Boss1_at2b"],"Boss1_at2b")
        H.at(a,v,0)
        -- 源0x1334，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,0)
        -- 源0x1350，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1364，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1378，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1390，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage04.ecl：Boss1_at1，0x13b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13b0，40号。
        H.at(a,v,0)
        -- 源0x13c4，355号。
        v.l[0]=H.int(120)
        H.at(a,v,0)
        -- 源0x13e8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x13fc，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1414，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x1430，436号。
        H.gun_count_diff(a,0,1,1,3,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1464，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1480，435号。
        H.gun_speed_diff(a,0,1.600000023841858,1.600000023841858,1.600000023841858,1.600000023841858,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x14b4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x14e4，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1514，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x1528，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x153c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x1550，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1564，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x1578，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x158c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x15a0，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x15b4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x15c8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x15dc，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x15f4，437号。
        H.gun_polar(a,0,(v.l[16] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1610，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x162c，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x1648，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x165c，437号。
        H.gun_polar(a,0,(v.l[20] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1678，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x1694，404号。
        H.gun_angle(a,0,(v.l[8] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x16b0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x16c4，368号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x16e4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x16f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x170c，61号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left~=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x171c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1734，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1748，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x175c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x176c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1780，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x1794，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x17a8，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x17bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x17cc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x17e0，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x17f4，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1808，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x181c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x182c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1840，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x1854，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x1868，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x187c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x188c，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x18a0，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x18b4，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x18cc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x18e0，44号。
        H.push(v,0.13556000590324402)
        H.at(a,v,0)
        -- 源0x18f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1904，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1918，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x192c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1940，44号。
        H.push(v,0.13556000590324402)
        H.at(a,v,0)
        -- 源0x1954，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1964，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1978，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x198c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x19a0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x19b4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x19c4，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x19d8，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x19ec，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x1a00，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x1a14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1a24，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a38，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1a4c，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1a60，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x1a74，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1a84，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1a98，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1aac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1ac4，10号。
        return
    end
    P["Boss1_at1"]=B.part1
end

-- stage04.ecl：Boss1_at1b，0x1ae4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1ae4，40号。
        H.at(a,v,0)
        -- 源0x1af8，355号。
        v.l[0]=H.int(120)
        H.at(a,v,0)
        -- 源0x1b1c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1b30，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1b48，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x1b64，436号。
        H.gun_count_diff(a,0,1,1,1,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1b98，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1bb4，435号。
        H.gun_speed_diff(a,0,1.600000023841858,1.600000023841858,1.600000023841858,1.600000023841858,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x1be8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1c18，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1c48，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x1c5c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c70，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x1c84，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c98，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x1cac，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1cc0，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x1cd4，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ce8，42号。
        H.push(v,50)
        H.at(a,v,0)
        -- 源0x1cfc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d10，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1d28，437号。
        H.gun_polar(a,0,(v.l[16] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1d44，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x1d60，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x1d7c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1d90，437号。
        H.gun_polar(a,0,(v.l[20] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1dac，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x1dc8，404号。
        H.gun_angle(a,0,(v.l[8] or 0),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x1de4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1df8，368号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x1e18，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1e2c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1e40，61号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left~=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1e50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1e68，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1e7c，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x1e90，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1ea0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1eb4，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x1ec8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1edc，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x1ef0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1f00，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f14，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x1f28，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1f3c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x1f50，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1f60，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f74，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x1f88，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x1f9c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x1fb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1fc0，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1fd4，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x1fe8，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2000，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2014，44号。
        H.push(v,0.13556000590324402)
        H.at(a,v,0)
        -- 源0x2028，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2038，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x204c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2060，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2074，44号。
        H.push(v,0.13556000590324402)
        H.at(a,v,0)
        -- 源0x2088，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2098，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x20ac，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x20c0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x20d4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x20e8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x20f8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x210c，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x2120，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x2134，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2148，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2158，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x216c，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2180，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2194，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x21a8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x21b8，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x21cc，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x21e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x21f8，10号。
        return
    end
    P["Boss1_at1b"]=B.part1
end

-- stage04.ecl：Boss1_at2，0x2218；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2218，40号。
        H.at(a,v,0)
        -- 源0x222c，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x2240，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2254，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x2268，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x2280，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x229c，436号。
        H.gun_count_diff(a,1,1,1,1,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x22d0，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x22ec，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x2308，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2338，409号。
        H.gun_transform(a,1,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2368，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x237c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2390，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x23a4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x23b8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x23cc，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x23e0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x23f4，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2408，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x241c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2430，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2448，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x245c，42号。
        H.push(v,13)
        H.at(a,v,0)
        -- 源0x2470，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x2480，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2494，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x24a4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x24bc，402号。
        H.gun_sprite(a,1,17,0)
        H.at(a,v,0)
        -- 源0x24d8，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x24f4，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x2508，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x2524，404号。
        H.gun_angle(a,1,(v.l[8] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x2540，401号。
        H.fire(a,1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2554，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x2568，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x257c，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x2590，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x25a0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x25b4，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x25c8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x25dc，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x25f0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2600，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2614，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x2628，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x263c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2650，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2660，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2674，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x2688，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x269c，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x26b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x26c0，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x26d4，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x26e8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x26fc，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x2710，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2720，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2734，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2748，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2760，10号。
        return
    end
    P["Boss1_at2"]=B.part1
end

-- stage04.ecl：Boss1_at2b，0x2780；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2780，40号。
        H.at(a,v,0)
        -- 源0x2794，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x27a8，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x27bc，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x27d0，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x27e8，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x2804，436号。
        H.gun_count_diff(a,1,1,1,1,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x2838，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2854，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x2870，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x28a0，409号。
        H.gun_transform(a,1,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x28d0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x28e4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x28f8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x290c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2920，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x2934，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2948，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x295c，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2970，42号。
        H.push(v,50)
        H.at(a,v,0)
        -- 源0x2984，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2998，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x29b0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x29c4，42号。
        H.push(v,13)
        H.at(a,v,0)
        -- 源0x29d8，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x29e8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x29fc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2a0c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2a24，402号。
        H.gun_sprite(a,1,17,0)
        H.at(a,v,0)
        -- 源0x2a40，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2a5c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x2a70，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x2a8c，404号。
        H.gun_angle(a,1,(v.l[8] or 0),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2aa8，401号。
        H.fire(a,1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2abc，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x2ad0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2ae4，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x2af8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2b08，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b1c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2b30，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2b44，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x2b58，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2b68，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b7c，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x2b90，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x2ba4，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2bb8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2bc8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2bdc，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x2bf0，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x2c04，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x2c18，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2c28，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2c3c，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x2c50，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2c64，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x2c78，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2c88，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2c9c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2cb0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2cc8，10号。
        return
    end
    P["Boss1_at2b"]=B.part1
end

-- stage04.ecl：Boss2，0x2ce8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2ce8，40号。
        H.at(a,v,0)
        -- 源0x2cfc，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x2d0c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2d1c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2d30，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2d44，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2d54，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2d6c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2d80，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2d98，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2dac，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2dbc，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2dcc，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x2de0，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x2df0，331号。
        H.life(a,8800)
        H.at(a,v,0)
        -- 源0x2e04，334号。
        H.interrupt(a,0,0,2100,"BossCard2Msg")
        H.at(a,v,0)
        -- 源0x2e34，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x2e48，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x2e5c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2e70，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2e84，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2e94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2eac，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2ec0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2ed0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2ee4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2ef8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2f08，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2f20，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2f34，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2f48，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2f5c，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x2f74，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x2f8c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2fa4，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2fb4，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2fc8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x2fe8，0号。
        H.at(a,v,90)
        -- 源0x2ff8，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,90)
        -- 源0x3018，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x302c，43号。
        H.write(a,-9949,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x3040，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3054，43号。
        H.write(a,-9948,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x3068，12号。
        v.origin=H.clock(a)-(90);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x3080，15号。
        H.async(a,P["Boss2_at2"],"Boss2_at2",nil)
        H.at(a,v,90)
        -- 源0x30a0，11号。
        H.call(a,v,P["Boss2_at1"],"Boss2_at1")
        H.at(a,v,90)
        -- 源0x30c0，15号。
        H.async(a,P["Boss2_at2b"],"Boss2_at2b",nil)
        H.at(a,v,90)
        -- 源0x30e0，11号。
        H.call(a,v,P["Boss2_at1b"],"Boss2_at1b")
        H.at(a,v,90)
        -- 源0x3100，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,90)
        -- 源0x311c，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0x3130，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x3144，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0x315c，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage04.ecl：Boss2_at1，0x317c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x317c，40号。
        H.at(a,v,0)
        -- 源0x3190，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x31a4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x31b8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x31cc，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x31e4，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x3200，436号。
        H.gun_count_diff(a,0,1,1,3,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x3234，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3250，405号。
        H.gun_speed(a,0,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x326c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x329c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x32cc，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x32e0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x32f4，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x3308，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x331c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3330，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3344，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3358，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x336c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3380，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3394，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x33ac，437号。
        H.gun_polar(a,0,(v.l[16] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x33c8，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x33e4，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x3400，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3414，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x3428，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x343c，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x344c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3464，437号。
        H.gun_polar(a,0,(v.l[20] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3480，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x349c，404号。
        H.gun_angle(a,0,(v.l[8] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x34b8，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x34cc，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x34e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x34f4，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x3508，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3518，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x352c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x3540，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3554，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x3568，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3578，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x358c，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x35a0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x35b4，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x35c8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x35d8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x35ec，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x3600，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x3614，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x3628，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3638，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x364c，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x3660，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3674，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x3688，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3698，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x36ac，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x36c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x36d8，10号。
        return
    end
    P["Boss2_at1"]=B.part1
end

-- stage04.ecl：Boss2_at1b，0x36f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x36f8，40号。
        H.at(a,v,0)
        -- 源0x370c，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x3720，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3734，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3748，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x3760，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x377c，436号。
        H.gun_count_diff(a,0,1,1,1,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x37b0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x37cc，405号。
        H.gun_speed(a,0,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x37e8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3818，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3848，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x385c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3870，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3884，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3898，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x38ac，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x38c0，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x38d4，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x38e8，42号。
        H.push(v,50)
        H.at(a,v,0)
        -- 源0x38fc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3910，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3928，437号。
        H.gun_polar(a,0,(v.l[16] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3944，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x3960，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x397c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3990，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x39a4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x39b8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x39c8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x39e0，437号。
        H.gun_polar(a,0,(v.l[20] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x39fc，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x3a18，404号。
        H.gun_angle(a,0,(v.l[8] or 0),0.6283185482025146)
        H.at(a,v,0)
        -- 源0x3a34，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3a48，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x3a5c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3a70，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x3a84，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3a94，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3aa8，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x3abc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3ad0，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x3ae4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3af4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3b08，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x3b1c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3b30，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x3b44，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3b54，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3b68，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x3b7c，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x3b90，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x3ba4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3bb4，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3bc8，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x3bdc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3bf0，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3c04，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3c14，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3c28，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x3c3c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3c54，10号。
        return
    end
    P["Boss2_at1b"]=B.part1
end

-- stage04.ecl：Boss2_at2，0x3c74；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3c74，40号。
        H.at(a,v,0)
        -- 源0x3c88，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x3c9c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3cb0，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x3cc4，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x3cdc，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x3cf8，436号。
        H.gun_count_diff(a,1,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0x3d2c，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3d48，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x3d64，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3d94，409号。
        H.gun_transform(a,1,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3dc4，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x3dd8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3dec，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x3e00，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e14，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3e28，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e3c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x3e50，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e64，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3e78，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e8c，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3ea4，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3eb8，42号。
        H.push(v,13)
        H.at(a,v,0)
        -- 源0x3ecc，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x3edc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3ef0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3f00，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3f18，402号。
        H.gun_sprite(a,1,17,0)
        H.at(a,v,0)
        -- 源0x3f34，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3f50，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x3f64，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x3f80，404号。
        H.gun_angle(a,1,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3f9c，401号。
        H.fire(a,1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3fb0，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x3fc4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3fd8，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x3fec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3ffc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4010，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x4024，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4038，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x404c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x405c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4070，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x4084，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x4098，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x40ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x40bc，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x40d0，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x40e4，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x40f8，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x410c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x411c，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4130，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x4144，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4158，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x416c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x417c，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4190，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x41a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x41bc，10号。
        return
    end
    P["Boss2_at2"]=B.part1
end

-- stage04.ecl：Boss2_at2b，0x41dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x41dc，40号。
        H.at(a,v,0)
        -- 源0x41f0，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x4204，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4218，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x422c，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x4244，402号。
        H.gun_sprite(a,1,3,2)
        H.at(a,v,0)
        -- 源0x4260，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x427c，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4298，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x42b4，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x42e4，409号。
        H.gun_transform(a,1,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4314，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x4328，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x433c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x4350，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4364，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x4378，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x438c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x43a0，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x43b4，42号。
        H.push(v,50)
        H.at(a,v,0)
        -- 源0x43c8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x43dc，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x43f4，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4408，42号。
        H.push(v,13)
        H.at(a,v,0)
        -- 源0x441c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x442c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4440，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4450，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4468，402号。
        H.gun_sprite(a,1,17,0)
        H.at(a,v,0)
        -- 源0x4484，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x44a0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x44b4，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x44d0，404号。
        H.gun_angle(a,1,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0x44ec，401号。
        H.fire(a,1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4500，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x4514，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4528，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x453c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x454c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4560，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x4574，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4588，44号。
        H.push(v,0.033890001475811005)
        H.at(a,v,0)
        -- 源0x459c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x45ac，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x45c0，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x45d4，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x45e8，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x45fc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x460c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4620，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x4634，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x4648，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x465c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x466c，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4680，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0x4694，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x46a8，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x46bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x46cc，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x46e0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x46f4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x470c，10号。
        return
    end
    P["Boss2_at2b"]=B.part1
end

-- stage04.ecl：BossCard1，0x472c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x472c，40号。
        H.at(a,v,0)
        -- 源0x4740，334号。
        H.interrupt(a,0,0,2580,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x47a8，359号。
        H.spell(a,44,2580,500000,"想起「恐怖催眠術」",359)
        H.at(a,v,0)
        -- 源0x47dc，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x47f0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4800，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x4820，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4834，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x4848，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x487c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x488c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x48a0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x48b4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x48c4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x48dc，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x48f0，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4900，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4914，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4928，443号。
        H.callback(a,443,1)
        H.at(a,v,0)
        -- 源0x493c，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,30)
        -- 源0x495c，263号。
        H.effect(a,0,131)
        H.at(a,v,150)
        -- 源0x4974，0号。
        H.at(a,v,150)
        -- 源0x4984，12号。
        v.origin=H.clock(a)-(150);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x499c，44号。
        H.push(v,0.010471999645233154)
        H.at(a,v,150)
        -- 源0x49b0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x49c4，15号。
        H.async(a,P["BossCard1_at"],"BossCard1_at",nil,-1.5707963705062866)
        H.at(a,v,150)
        -- 源0x49f0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,150)
        -- 源0x4a04，336号。
        H.sound(a,41)
        H.at(a,v,150)
        -- 源0x4a18，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,150)
        -- 源0x4a2c，336号。
        H.sound(a,16)
        H.at(a,v,150)
        -- 源0x4a40，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,150)
        -- 源0x4a54，356号。
        v.l[12]=H.f32(0.1208304837346077)
        H.at(a,v,150)
        -- 源0x4a78，15号。
        H.async(a,P["BossCard1_at2"],"BossCard1_at2",nil,(v.l[12] or 0))
        H.at(a,v,150)
        -- 源0x4aa4，44号。
        H.push(v,-0.010471999645233154)
        H.at(a,v,150)
        -- 源0x4ab8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,150)
        -- 源0x4acc，15号。
        H.async(a,P["BossCard1_at"],"BossCard1_at",nil,1.5707963705062866)
        H.at(a,v,150)
        -- 源0x4af8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,150)
        -- 源0x4b0c，336号。
        H.sound(a,41)
        H.at(a,v,150)
        -- 源0x4b20，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,150)
        -- 源0x4b34，336号。
        H.sound(a,16)
        H.at(a,v,150)
        -- 源0x4b48，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,150)
        -- 源0x4b5c，356号。
        v.l[12]=H.f32(-0.1208304837346077)
        H.at(a,v,150)
        -- 源0x4b80，15号。
        H.async(a,P["BossCard1_at2"],"BossCard1_at2",nil,(v.l[12] or 0))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x4bac，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x4bc0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x4bd8，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage04.ecl：BossCard1_at，0x4bf8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4bf8，40号。
        H.at(a,v,0)
        -- 源0x4c0c，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x4c20，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4c34，355号。
        v.l[20]=H.int(32)
        H.at(a,v,0)
        -- 源0x4c58，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x4c6c，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x4c80，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4c90，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4ca4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4cbc，81号。
        do local r=64.0;local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x4cdc，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4cf8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4d0c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4d20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4d30，413号。
        H.laser(a,413,0,3,6,H.read(a,v,-1),0.0,460.0,180,20,50,8,16.0,8)
        H.at(a,v,0)
        -- 源0x4d70，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4d84，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x4d98，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4da8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4dbc，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4dd0，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x4de4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4dfc，10号。
        return
    end
    P["BossCard1_at"]=B.part1
end

-- stage04.ecl：BossCard1_at2，0x4e1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4e1c，40号。
        H.at(a,v,0)
        -- 源0x4e30，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x4e44，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4e58，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x4e6c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4e80，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x4e94，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4ea8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4eb8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4ed0，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x4ee4，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x4efc，402号。
        H.gun_sprite(a,1,1,13)
        H.at(a,v,0)
        -- 源0x4f18，436号。
        H.gun_count_diff(a,1,8,8,12,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x4f4c，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4f68，435号。
        H.gun_speed_diff(a,1,1.600000023841858,1.600000023841858,2.0,2.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x4f9c，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4fcc，438号。
        H.gun_distance(a,1,32.0)
        H.at(a,v,0)
        -- 源0x4fe4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x4ff8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x500c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5024，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x5040，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5054，83号。
        v.origin=v.origin+H.int(6)
        H.at(a,v,0)
        -- 源0x5068，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x507c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5090，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x50a0，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x50b4，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x50c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x50e0，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x50f8，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x510c，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x5124，402号。
        H.gun_sprite(a,1,1,13)
        H.at(a,v,0)
        -- 源0x5140，406号。
        H.gun_count(a,1,8,1)
        H.at(a,v,0)
        -- 源0x515c，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5178，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x5194，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x51c4，438号。
        H.gun_distance(a,1,32.0)
        H.at(a,v,0)
        -- 源0x51dc，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x51f0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5204，404号。
        H.gun_angle(a,1,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x5220，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5234，83号。
        v.origin=v.origin+H.int(96)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5248，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x525c，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x5274，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x5290，436号。
        H.gun_count_diff(a,1,1,1,1,1,8,8,24,32)
        H.at(a,v,0)
        -- 源0x52c4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x52d8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x52ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x52fc，404号。
        H.gun_angle(a,1,(v.l[0] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5318，435号。
        H.gun_speed_diff(a,1,1.5,1.5,2.0,2.5,0.5,0.5,0.5,0.5)
        H.at(a,v,0)
        -- 源0x534c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5360，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x5374，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5384，404号。
        H.gun_angle(a,1,(v.l[0] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x53a0，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x53d0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x53e4，10号。
        return
    end
    P["BossCard1_at2"]=B.part1
end

-- stage04.ecl：BossCard2Msg，0x5404；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5404，40号。
        H.at(a,v,0)
        -- 源0x5418，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x5428，281号。
        H.position_time(a,0,60,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0x5448，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x545c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x5470，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5484，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5494，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x54ac，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x54bc，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x54d0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x54e4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x54f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x550c，330号。
        H.drop_main(a,5)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5520，327号。
        H.drop_extra(a,1,15)
        H.at(a,v,0)
        -- 源0x5538，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0x5550，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x5568，329号。
        H.drop(a)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5578，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x558c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x55a0，331号。
        H.life(a,1000)
        H.at(a,v,0)
        -- 源0x55b4，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x55c8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x55dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x55f0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5600，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5618，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x564c，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5664，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x569c，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x56ac，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x56bc，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x56d0，324号。
        H.limit(a,0.0,128.0,280.0,128.0)
        H.at(a,v,0)
        -- 源0x56f0，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x5704，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x5718，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x5728，323号。
        H.flags(a,16,false)
        H.at(a,v,0)
        -- 源0x573c，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x5750，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x5764，11号。
        H.call(a,v,P["BossCardSelect"],"BossCardSelect")
        H.at(a,v,0)
        -- 源0x5788，10号。
        return
    end
    P["BossCard2Msg"]=B.part1
end

-- stage04.ecl：BossCardItem，0x57a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x57a8，40号。
        H.at(a,v,0)
        -- 源0x57bc，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x57d4，327号。
        H.drop_extra(a,2,14)
        H.at(a,v,0)
        -- 源0x57ec，10号。
        return
    end
    P["BossCardItem"]=B.part1
end

-- stage04.ecl：BossCardSelect，0x580c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x580c，40号。
        H.at(a,v,0)
        -- 源0x5820，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x5834，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5848，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5858，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5870，11号。
        H.call(a,v,P["BossCard2_00A"],"BossCard2_00A")
        H.at(a,v,0)
        -- 源0x5894，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x58ac，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x58c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x58d4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x58e4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x58fc，11号。
        H.call(a,v,P["BossCard2_00B"],"BossCard2_00B")
        H.at(a,v,0)
        -- 源0x5920，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5938，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x594c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x5960，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5970，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5988，11号。
        H.call(a,v,P["BossCard2_00C"],"BossCard2_00C")
        H.at(a,v,0)
        -- 源0x59ac，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x59c4，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x59d8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x59ec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x59fc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x5a14，11号。
        H.call(a,v,P["BossCard2_01A"],"BossCard2_01A")
        H.at(a,v,0)
        -- 源0x5a38，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x5a50，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x5a64，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x5a78，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5a88，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x5aa0，11号。
        H.call(a,v,P["BossCard2_01B"],"BossCard2_01B")
        H.at(a,v,0)
        -- 源0x5ac4，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x5adc，42号。
        H.push(v,H.read(a,v,-9945))
        H.at(a,v,0)
        -- 源0x5af0，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x5b04，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5b14，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x5b2c，11号。
        H.call(a,v,P["BossCard2_01C"],"BossCard2_01C")
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x5b50，10号。
        return
    end
    P["BossCardSelect"]=B.part1
end

-- stage04.ecl：BossDead，0x5b70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5b70，40号。
        H.at(a,v,0)
        -- 源0x5b84，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x5b98，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x5bb0，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x5bc4，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x5bdc，285号。
        H.velocity_time(a,0,1,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x5bfc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x5c10，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5c24，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5c34，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5c4c，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x5c84，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5c9c，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x5cd4，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x5ce4，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x5cf4，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x5d08，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0x5d18，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0x5d2c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x5d40，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x5d50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x5d68，330号。
        H.drop_main(a,5)
        H.at(a,v,60)
        -- 源0x5d7c，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x5d8c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x5da0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x5db4，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,60)
        -- 源0x5dcc，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,60)
        -- 源0x5de4，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0x5dfc，329号。
        H.drop(a)
        H.at(a,v,60)
        -- 源0x5e0c，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0x5e28，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0x5e40，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0x5e58，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0x5e6c，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0x5e80，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

-- stage04.ecl：Cir00，0x5eb0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5eb0，40号。
        H.at(a,v,0)
        -- 源0x5ec4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5ed8，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x5eec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x5f00，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5f18，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x5f2c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x5f44，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x5f5c，284号。
        H.velocity(a,0,0.0,8.0)
        H.at(a,v,0)
        -- 源0x5f74，285号。
        H.velocity_time(a,0,60,4,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x5f94，323号。
        H.flags(a,3,false)
        H.at(a,v,120)
        -- 源0x5fa8，284号。
        H.velocity(a,0,H.read(a,v,-9989),0.0)
        H.at(a,v,120)
        -- 源0x5fc0，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil)
        H.at(a,v,120)
        -- 源0x5fe0，285号。
        H.velocity_time(a,0,60,4,H.read(a,v,-9989),2.0)
        H.at(a,v,120)
        -- 源0x6000，12号。
        v.origin=H.clock(a)-(120);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,120)
        -- 源0x6018，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,120)
        -- 源0x602c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x6040，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,120)
        -- 源0x6058，10号。
        return
    end
    P["Cir00"]=B.part1
end

-- stage04.ecl：Cir01，0x6078；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6078，40号。
        H.at(a,v,0)
        -- 源0x608c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x60a0，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x60b4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x60c8，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x60e0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x60f4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x610c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6124，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6134，327号。
        H.drop_extra(a,2,3)
        H.at(a,v,0)
        -- 源0x614c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x6164，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil)
        H.at(a,v,0)
        -- 源0x6184，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x619c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x61b0，285号。
        H.velocity_time(a,0,50,0,-0.7853981852531433,5.0)
        H.at(a,v,0)
        -- 源0x61d0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x61e4，0号。
        H.at(a,v,6000)
        -- 源0x61f4，10号。
        return
    end
    P["Cir01"]=B.part1
end

-- stage04.ecl：Cir01b，0x6214；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6214，40号。
        H.at(a,v,0)
        -- 源0x6228，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x623c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6250，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6264，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x627c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6290，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x62a8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x62c0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x62d0，327号。
        H.drop_extra(a,2,3)
        H.at(a,v,0)
        -- 源0x62e8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x6300，15号。
        H.async(a,P["RCir01b_at"],"RCir01b_at",nil)
        H.at(a,v,0)
        -- 源0x6320，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x6338，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x634c，285号。
        H.velocity_time(a,0,50,0,3.1415927410125732,5.0)
        H.at(a,v,0)
        -- 源0x636c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x6380，0号。
        H.at(a,v,6000)
        -- 源0x6390，10号。
        return
    end
    P["Cir01b"]=B.part1
end

-- stage04.ecl：Cir02，0x63b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x63b0，40号。
        H.at(a,v,0)
        -- 源0x63c4，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x63d8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x63ec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6400，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6418，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x642c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6444，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x645c，15号。
        H.async(a,P["RCir02_at"],"RCir02_at",nil)
        H.at(a,v,0)
        -- 源0x647c，284号。
        H.velocity(a,0,-0.39269909262657166,3.0)
        H.at(a,v,0)
        -- 源0x6494，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x64a8，285号。
        H.velocity_time(a,0,50,0,0.0,4.0)
        H.at(a,v,0)
        -- 源0x64c8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,6000)
        -- 源0x64dc，0号。
        H.at(a,v,6000)
        -- 源0x64ec，10号。
        return
    end
    P["Cir02"]=B.part1
end

-- stage04.ecl：Cir03，0x650c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x650c，40号。
        H.at(a,v,0)
        -- 源0x6520，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6534，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6548，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x655c，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6574，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x6588，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x65a0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x65b8，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,60)
        -- 源0x65d0，323号。
        H.flags(a,3,false)
        H.at(a,v,60)
        -- 源0x65e4，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x6604，15号。
        H.async(a,P["RCir03_at"],"RCir03_at",nil,1)
        H.at(a,v,60)
        -- 源0x662c，258号。
        H.select_anm(a,1)
        H.at(a,v,60)
        -- 源0x6640，259号。
        H.anm_slot(a,1,(v.l[4] or 0))
        H.at(a,v,360)
        -- 源0x6658，322号。
        H.flags(a,3,true)
        H.at(a,v,360)
        -- 源0x666c，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,360)
        -- 源0x6684，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,360)
        -- 源0x669c，284号。
        H.velocity(a,0,1.5707963705062866,0.20000000298023224)
        H.at(a,v,360)
        -- 源0x66b4，285号。
        H.velocity_time(a,0,30,0,-999999.0,1.0)
        H.at(a,v,420)
        -- 源0x66d4，1号。
        H.erase(a);return
    end
    P["Cir03"]=B.part1
end

-- stage04.ecl：GCir00，0x6704；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6704，40号。
        H.at(a,v,0)
        -- 源0x6718，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x672c，11号。
        H.call(a,v,P["Cir00"],"Cir00",84,47,1)
        H.at(a,v,0)
        -- 源0x6760，1号。
        H.erase(a);return
    end
    P["GCir00"]=B.part1
end

-- stage04.ecl：GCir01，0x6780；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6780，40号。
        H.at(a,v,0)
        -- 源0x6794，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x67a8，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x67bc，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x67d4，11号。
        H.call(a,v,P["Cir01"],"Cir01",72,1)
        H.at(a,v,0)
        -- 源0x6800，1号。
        H.erase(a);return
    end
    P["GCir01"]=B.part1
end

-- stage04.ecl：GCir01b，0x6820；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6820，40号。
        H.at(a,v,0)
        -- 源0x6834，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6848，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x685c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6874，11号。
        H.call(a,v,P["Cir01b"],"Cir01b",72,1)
        H.at(a,v,0)
        -- 源0x68a0，1号。
        H.erase(a);return
    end
    P["GCir01b"]=B.part1
end

-- stage04.ecl：GCir02，0x68c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x68c0，40号。
        H.at(a,v,0)
        -- 源0x68d4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x68e8，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x68fc，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6914，11号。
        H.call(a,v,P["Cir02"],"Cir02",72,1)
        H.at(a,v,0)
        -- 源0x6940，1号。
        H.erase(a);return
    end
    P["GCir02"]=B.part1
end

-- stage04.ecl：GCir03，0x6960；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6960，40号。
        H.at(a,v,0)
        -- 源0x6974，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6988，11号。
        H.call(a,v,P["Cir03"],"Cir03",84,47,1)
        H.at(a,v,0)
        -- 源0x69bc，1号。
        H.erase(a);return
    end
    P["GCir03"]=B.part1
end

-- stage04.ecl：GGirl00，0x69dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x69dc，40号。
        H.at(a,v,0)
        -- 源0x69f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6a04，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6a18，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6a30，11号。
        H.call(a,v,P["Girl00"],"Girl00",10,1)
        H.at(a,v,0)
        -- 源0x6a5c，1号。
        H.erase(a);return
    end
    P["GGirl00"]=B.part1
end

-- stage04.ecl：GGirl00b，0x6a7c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6a7c，40号。
        H.at(a,v,0)
        -- 源0x6a90，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6aa4，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6ab8，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6ad0，11号。
        H.call(a,v,P["Girl00b"],"Girl00b",10,1)
        H.at(a,v,0)
        -- 源0x6afc，1号。
        H.erase(a);return
    end
    P["GGirl00b"]=B.part1
end

-- stage04.ecl：GGirl01，0x6b1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6b1c，40号。
        H.at(a,v,0)
        -- 源0x6b30，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6b44，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6b58，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6b70，11号。
        H.call(a,v,P["Girl01"],"Girl01",10,1)
        H.at(a,v,0)
        -- 源0x6b9c，1号。
        H.erase(a);return
    end
    P["GGirl01"]=B.part1
end

-- stage04.ecl：GGirl01b，0x6bbc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6bbc，40号。
        H.at(a,v,0)
        -- 源0x6bd0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6be4，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6bf8，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6c10，11号。
        H.call(a,v,P["Girl01b"],"Girl01b",10,1)
        H.at(a,v,0)
        -- 源0x6c3c，1号。
        H.erase(a);return
    end
    P["GGirl01b"]=B.part1
end

-- stage04.ecl：GGirl02，0x6c5c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6c5c，40号。
        H.at(a,v,0)
        -- 源0x6c70，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6c84，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6c98，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6cb0，11号。
        H.call(a,v,P["Girl02"],"Girl02",10,1)
        H.at(a,v,0)
        -- 源0x6cdc，1号。
        H.erase(a);return
    end
    P["GGirl02"]=B.part1
end

-- stage04.ecl：GGirl03，0x6cfc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6cfc，40号。
        H.at(a,v,0)
        -- 源0x6d10，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6d24，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x6d38，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6d50，11号。
        H.call(a,v,P["Girl03"],"Girl03",10,1)
        H.at(a,v,0)
        -- 源0x6d7c，1号。
        H.erase(a);return
    end
    P["GGirl03"]=B.part1
end

-- stage04.ecl：GPhantomMBoss，0x6d9c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6d9c，40号。
        H.at(a,v,0)
        -- 源0x6db0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6dc4，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6dd8，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6df0，11号。
        H.call(a,v,P["PhantomMBoss"],"PhantomMBoss",96,1)
        H.at(a,v,0)
        -- 源0x6e24，1号。
        H.erase(a);return
    end
    P["GPhantomMBoss"]=B.part1
end

-- stage04.ecl：GPhantomMBoss2，0x6e44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6e44，40号。
        H.at(a,v,0)
        -- 源0x6e58，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6e6c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6e80，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x6e98，11号。
        H.call(a,v,P["PhantomMBoss2"],"PhantomMBoss2",96,1)
        H.at(a,v,0)
        -- 源0x6ecc，1号。
        H.erase(a);return
    end
    P["GPhantomMBoss2"]=B.part1
end

-- stage04.ecl：Girl00，0x6eec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6eec，40号。
        H.at(a,v,0)
        -- 源0x6f00，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6f14，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6f2c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6f40，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6f58，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6f70，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6f80，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x6f98，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x6fb0，284号。
        H.velocity(a,0,0.0,6.0)
        H.at(a,v,0)
        -- 源0x6fc8，285号。
        H.velocity_time(a,0,60,9,0.0,0.0)
        H.at(a,v,60)
        -- 源0x6fe8，15号。
        H.async(a,P["RGirl00_at"],"RGirl00_at",nil,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x7010，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x7024，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,60)
        -- 源0x703c，285号。
        H.velocity_time(a,0,60,0,-999999.0,1.0)
        H.at(a,v,6060)
        -- 源0x705c，0号。
        H.at(a,v,6060)
        -- 源0x706c，10号。
        return
    end
    P["Girl00"]=B.part1
end

-- stage04.ecl：Girl00b，0x708c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x708c，40号。
        H.at(a,v,0)
        -- 源0x70a0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x70b4，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x70cc，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x70e0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x70f8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7110，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7120，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x7138，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x7150，284号。
        H.velocity(a,0,0.0,6.0)
        H.at(a,v,0)
        -- 源0x7168，285号。
        H.velocity_time(a,0,60,9,0.0,0.0)
        H.at(a,v,60)
        -- 源0x7188，15号。
        H.async(a,P["RGirl00b_at"],"RGirl00b_at",nil,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x71b0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x71c4，15号。
        H.async(a,P["RGirl00b_at"],"RGirl00b_at",nil,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x71ec，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x7200，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,60)
        -- 源0x7218，285号。
        H.velocity_time(a,0,60,0,-999999.0,1.0)
        H.at(a,v,6060)
        -- 源0x7238，0号。
        H.at(a,v,6060)
        -- 源0x7248，10号。
        return
    end
    P["Girl00b"]=B.part1
end

-- stage04.ecl：Girl01，0x7268；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7268，40号。
        H.at(a,v,0)
        -- 源0x727c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7290，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x72a8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x72bc，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x72d4，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x72ec，15号。
        H.async(a,P["RGirl01_at"],"RGirl01_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7314，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x732c，285号。
        H.velocity_time(a,0,60,9,3.1415927410125732,3.0)
        H.at(a,v,0)
        -- 源0x734c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,6000)
        -- 源0x7360，0号。
        H.at(a,v,6000)
        -- 源0x7370，10号。
        return
    end
    P["Girl01"]=B.part1
end

-- stage04.ecl：Girl01b，0x7390；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7390，40号。
        H.at(a,v,0)
        -- 源0x73a4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x73b8，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x73d0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x73e4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x73fc，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7414，15号。
        H.async(a,P["RGirl01b_at"],"RGirl01b_at",nil,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x743c，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x7454，285号。
        H.velocity_time(a,0,60,9,3.1415927410125732,3.0)
        H.at(a,v,0)
        -- 源0x7474，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,6000)
        -- 源0x7488，0号。
        H.at(a,v,6000)
        -- 源0x7498，10号。
        return
    end
    P["Girl01b"]=B.part1
end

-- stage04.ecl：Girl02，0x74b8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x74b8，40号。
        H.at(a,v,0)
        -- 源0x74cc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x74e0，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x74f8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x750c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7524，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x753c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x754c，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x7564，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x757c，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x7594，284号。
        H.velocity(a,0,0.0,5.0)
        H.at(a,v,0)
        -- 源0x75ac，285号。
        H.velocity_time(a,0,60,9,0.0,0.0)
        H.at(a,v,60)
        -- 源0x75cc，15号。
        H.async(a,P["RGirl02_at"],"RGirl02_at",nil,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x75f4，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,60)
        -- 源0x7608，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,60)
        -- 源0x7620，285号。
        H.velocity_time(a,0,60,0,-999999.0,1.0)
        H.at(a,v,6060)
        -- 源0x7640，0号。
        H.at(a,v,6060)
        -- 源0x7650，10号。
        return
    end
    P["Girl02"]=B.part1
end

-- stage04.ecl：Girl03，0x7670；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7670，40号。
        H.at(a,v,0)
        -- 源0x7684，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7698，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x76ac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x76c0，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x76d8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x76ec，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7704，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x771c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x772c，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x7744，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x775c，334号。
        H.interrupt(a,0,0,-1,"Girl3Dead")
        H.at(a,v,0)
        -- 源0x7788，281号。
        H.position_time(a,0,60,4,0.0,96.0)
        H.at(a,v,60)
        -- 源0x77a8，15号。
        H.async(a,P["RGirl03_at"],"RGirl03_at",nil,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x77d0，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,60)
        -- 源0x77e4，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0x77f4，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,60)
        -- 源0x780c，285号。
        H.velocity_time(a,0,60,0,-999999.0,1.0)
        H.at(a,v,6060)
        -- 源0x782c，0号。
        H.at(a,v,6060)
        -- 源0x783c，10号。
        return
    end
    P["Girl03"]=B.part1
end

-- stage04.ecl：Girl3Dead，0x785c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x785c，40号。
        H.at(a,v,0)
        -- 源0x7870，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7880，327号。
        H.drop_extra(a,1,20)
        H.at(a,v,0)
        -- 源0x7898，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x78b0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x78c8，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x78dc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x78f0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7900，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7918，330号。
        H.drop_main(a,5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x792c，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x793c，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x7954，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x7968，10号。
        return
    end
    P["Girl3Dead"]=B.part1
end

-- stage04.ecl：MBoss，0x7988；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7988，40号。
        H.at(a,v,0)
        -- 源0x799c，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x79b0，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x79c4，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0x79dc，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x79f0，262号。
        H.anm_main(a,0,7)
        H.at(a,v,0)
        -- 源0x7a08，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7a1c，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7a34，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x7a4c，331号。
        H.life(a,80000)
        H.at(a,v,0)
        -- 源0x7a60，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7a74，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7a88，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x7a9c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x7abc，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0x7ad0，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,0)
        -- 源0x7af0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x7b04，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x7b18，440号。
        H.fog(a,160.0,16711680)
        H.at(a,v,0)
        -- 源0x7b30，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x7b44，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x7b5c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x7b70，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7b84，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x7b98，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7bac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7bc4，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x7bd8，292号。
        H.wander(a,0,40,4,8.0)
        H.at(a,v,0)
        -- 源0x7bf4，336号。
        H.sound(a,34)
        H.at(a,v,0)
        -- 源0x7c08，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7c1c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7c30，81号。
        do local r=32.0;local angle=H.read(a,v,-9981);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x7c50，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x7c64，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7c78，256号。
        H.spawn(a,256,"RPhantomMBoss",(v.l[8] or 0),(v.l[12] or 0),300,1000,2)
        H.at(a,v,0)
        -- 源0x7cb0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x7cc4，44号。
        H.push(v,2.0943949222564697)
        H.at(a,v,0)
        -- 源0x7cd8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7ce8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7cfc，81号。
        do local r=32.0;local angle=H.read(a,v,-9981);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x7d1c，256号。
        H.spawn(a,256,"GPhantomMBoss",(v.l[8] or 0),(v.l[12] or 0),300,1000,2)
        H.at(a,v,0)
        -- 源0x7d54，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x7d68，44号。
        H.push(v,2.0943949222564697)
        H.at(a,v,0)
        -- 源0x7d7c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7d8c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7da0，81号。
        do local r=32.0;local angle=H.read(a,v,-9981);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x7dc0，256号。
        H.spawn(a,256,"BPhantomMBoss",(v.l[8] or 0),(v.l[12] or 0),300,1000,2)
        H.at(a,v,0)
        -- 源0x7df8，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7e0c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x7e20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7e38，11号。
        H.call(a,v,P["MBossEscape"],"MBossEscape")
        H.at(a,v,0)
        -- 源0x7e58，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7e70，83号。
        v.origin=v.origin+H.int(1000)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7e84，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7e98，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7eb0，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage04.ecl：MBoss2，0x7ed0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7ed0，40号。
        H.at(a,v,0)
        -- 源0x7ee4，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x7ef8，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x7f0c，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0x7f24，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x7f38，262号。
        H.anm_main(a,0,7)
        H.at(a,v,0)
        -- 源0x7f50，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x7f64，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7f7c，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x7f94，331号。
        H.life(a,12000)
        H.at(a,v,0)
        -- 源0x7fa8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7fbc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7fd0，334号。
        H.interrupt(a,0,0,1590,"MBossEscape2")
        H.at(a,v,0)
        -- 源0x8000，344号。
        a.chapter=7
        H.at(a,v,0)
        -- 源0x8014，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x8034，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0x8048，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,0)
        -- 源0x8068，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x807c，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x8090，440号。
        H.fog(a,160.0,16711680)
        H.at(a,v,0)
        -- 源0x80a8，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x80bc，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x80d4，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x80e8，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x8100，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x8114，83号。
        v.origin=v.origin+H.int(60)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8128，15号。
        H.async(a,P["MBoss2_at"],"MBoss2_at",nil)
        H.at(a,v,0)
        -- 源0x8148，15号。
        H.async(a,P["MBoss2_at2"],"MBoss2_at2",nil)
        H.at(a,v,0)
        -- 源0x8168，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x817c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8194，42号。
        H.push(v,H.read(a,v,-9946))
        H.at(a,v,0)
        -- 源0x81a8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x81bc，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x81cc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x81e4，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x81f8，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x8210，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x8224，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x823c，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8250，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8264，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x827c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8294，83号。
        v.origin=v.origin+H.int(1000)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x82a8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x82bc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x82d4，1号。
        H.erase(a);return
    end
    P["MBoss2"]=B.part1
end

-- stage04.ecl：MBoss2_at，0x82f4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x82f4，40号。
        H.at(a,v,0)
        -- 源0x8308，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x831c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8330，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x8344，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x835c，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x8378，436号。
        H.gun_count_diff(a,0,32,48,48,64,1,1,1,1)
        H.at(a,v,0)
        -- 源0x83ac，404号。
        H.gun_angle(a,0,0.0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x83c8，435号。
        H.gun_speed_diff(a,0,0.30000001192092896,0.30000001192092896,0.30000001192092896,0.30000001192092896,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x83fc，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x8418，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8448，356号。
        v.l[4]=H.f32(0.02222222276031971)
        H.at(a,v,0)
        -- 源0x846c，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x849c，355号。
        v.l[20]=H.int(30)
        H.at(a,v,0)
        -- 源0x84c0，356号。
        v.l[8]=H.f32(160.0)
        H.at(a,v,0)
        -- 源0x84e4，356号。
        v.l[16]=H.f32(12.0)
        H.at(a,v,0)
        -- 源0x8508，42号。
        H.push(v,2000)
        H.at(a,v,0)
        -- 源0x851c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8530，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8544，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8558，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8570，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8588，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x859c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x85b0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x85c0，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x85dc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x85f0，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x8604，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x8614，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8628，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x863c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x8650，438号。
        H.gun_distance(a,1,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8668，404号。
        H.gun_angle(a,1,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x8684，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x8698，44号。
        H.push(v,0.01636200025677681)
        H.at(a,v,0)
        -- 源0x86ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x86bc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x86d0，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x86e4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x86f8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x870c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x871c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8730，368号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8750，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x8764，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x877c，10号。
        return
    end
    P["MBoss2_at"]=B.part1
end

-- stage04.ecl：MBoss2_at2，0x879c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x879c，40号。
        H.at(a,v,0)
        -- 源0x87b0，355号。
        v.l[20]=H.int(10)
        H.at(a,v,0)
        -- 源0x87d4，356号。
        v.l[12]=H.f32(160.0)
        H.at(a,v,0)
        -- 源0x87f8，356号。
        v.l[16]=H.f32(16.0)
        H.at(a,v,0)
        -- 源0x881c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8834，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x8848，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x885c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8870，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8884，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x889c，81号。
        do local r=(v.l[12] or 0);local angle=(v.l[0] or 0);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x88bc，256号。
        H.spawn(a,256,"BPhantomMBoss2",(v.l[4] or 0),(v.l[8] or 0),160,1000,2)
        H.at(a,v,0)
        -- 源0x88f4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8908，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,0)
        -- 源0x891c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x892c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8940，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8954，78号。
        H.push(v,(v.l[24] or 0))
        v.l[24]=H.int((v.l[24] or 0)-1)
        H.at(a,v,0)
        -- 源0x8968，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8980，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x8994，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x89a8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x89b8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x89cc，368号。
        v.origin=v.origin+H.int(5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x89ec，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x8a00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8a18，10号。
        return
    end
    P["MBoss2_at2"]=B.part1
end

-- stage04.ecl：MBossEscape，0x8a38；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8a38，40号。
        H.at(a,v,0)
        -- 源0x8a4c，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0x8a70，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0x8a94，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8aa4，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x8ab4，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8ac4，327号。
        H.drop_extra(a,1,8)
        H.at(a,v,0)
        -- 源0x8adc，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0x8af4，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x8b0c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8b20，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8b34，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8b44，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8b5c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8b70，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8b84，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8b94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8bac，330号。
        H.drop_main(a,5)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8bc0，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x8bd0，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x8be4，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x8bf8，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x8c0c，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x8c20，281号。
        H.position_time(a,0,60,4,224.0,64.0)
        H.at(a,v,60)
        -- 源0x8c40，344号。
        a.chapter=0
        H.at(a,v,60)
        -- 源0x8c54，1号。
        H.erase(a);return
    end
    P["MBossEscape"]=B.part1
end

-- stage04.ecl：MBossEscape2，0x8c84；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8c84，40号。
        H.at(a,v,0)
        -- 源0x8c98，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0x8cbc，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0x8ce0，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8cf0，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x8d00，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8d14，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8d28，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8d38，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8d50，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x8d64，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8d7c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8d90，371号。
        H.actor_group(a,371,1)
        H.at(a,v,0)
        -- 源0x8da4，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x8db8，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x8dcc，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8ddc，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x8df4，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x8e0c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x8e24，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8e38，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8e4c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8e5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8e74，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8e88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8e9c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8eac，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8ec4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8ed8，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x8ee8，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x8efc，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x8f10，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x8f24，281号。
        H.position_time(a,0,60,4,-224.0,64.0)
        H.at(a,v,60)
        -- 源0x8f44，344号。
        a.chapter=0
        H.at(a,v,60)
        -- 源0x8f58，1号。
        H.erase(a);return
    end
    P["MBossEscape2"]=B.part1
end

-- stage04.ecl：MainBossDebug，0x8f88；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8f88，40号。
        H.at(a,v,60)
        -- 源0x8f9c，338号。
        H.dialog(a,-1)
        H.at(a,v,60)
        -- 源0x8fb0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x8fc0，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,60)
        -- 源0x8ff0，500号。
        H.debug_entry(a,100)
        H.at(a,v,60)
        -- 源0x9004，340号。
        H.boss_wait(a,v)
        H.at(a,v,120)
        -- 源0x9014，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x9028，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x9038，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage04.ecl：MainMBossDebug，0x9068；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9068，40号。
        H.at(a,v,0)
        -- 源0x907c，257号。
        H.spawn(a,257,"MBoss",-144.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x90ac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x90c4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x90d8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x90ec，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9104，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage04.ecl：MainMsgDebug，0x9124；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9124，40号。
        H.at(a,v,0)
        -- 源0x9138，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0x914c，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x9160，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0x9170，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x9180，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0x9194，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x91a4，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0x91bc，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0x91cc，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0x91e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0x91f8，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage04.ecl：MainSub00，0x9218；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9218，40号。
        H.at(a,v,0)
        -- 源0x922c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x9240，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9254，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x926c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9280，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9294，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x92a8，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x92b8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x92c8，256号。
        H.spawn(a,256,"RCir00",-64.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x92f8，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x930c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9320，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9334，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9348，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x9358，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x9368，256号。
        H.spawn(a,256,"RCir00",-256.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x9398，83号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x93ac，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x93c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x93d8，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage04.ecl：MainSub00b，0x93f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x93f8，40号。
        H.at(a,v,0)
        -- 源0x940c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x9420，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9434，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x944c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9460，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9474，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9488，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x9498，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x94a8，260号。
        H.spawn(a,260,"RCir00",64.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x94d8，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x94ec，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9500，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9514，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9528，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x9538，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x9548，260号。
        H.spawn(a,260,"RCir00",256.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x9578，83号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x958c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x95a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x95b8，10号。
        return
    end
    P["MainSub00b"]=B.part1
end

-- stage04.ecl：MainSub01，0x95d8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x95d8，40号。
        H.at(a,v,0)
        -- 源0x95ec，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9600，257号。
        H.spawn(a,257,"MBoss",-224.0,64.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9630，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage04.ecl：MainSub01b，0x9650；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9650，40号。
        H.at(a,v,0)
        -- 源0x9664，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9678，257号。
        H.spawn(a,257,"MBoss2",224.0,64.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x96a8，10号。
        return
    end
    P["MainSub01b"]=B.part1
end

-- stage04.ecl：MainSub02，0x96c8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x96c8，40号。
        H.at(a,v,0)
        -- 源0x96dc，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x96f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9704，257号。
        H.spawn(a,257,"RGirl00",-224.0,64.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9734，261号。
        H.spawn(a,261,"RGirl00",224.0,64.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9764，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x9778，257号。
        H.spawn(a,257,"RGirl00",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x97a8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x97bc，261号。
        H.spawn(a,261,"RGirl00",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x97ec，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9800，257号。
        H.spawn(a,257,"RGirl00",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9830，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9844，261号。
        H.spawn(a,261,"RGirl00",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9874，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9888，257号。
        H.spawn(a,257,"RGirl00",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x98b8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x98cc，261号。
        H.spawn(a,261,"RGirl00",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x98fc，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage04.ecl：MainSub02b，0x991c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x991c，40号。
        H.at(a,v,0)
        -- 源0x9930，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x9944，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9958，257号。
        H.spawn(a,257,"RGirl00b",-224.0,64.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x998c，261号。
        H.spawn(a,261,"RGirl00b",224.0,64.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x99c0，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x99d4，257号。
        H.spawn(a,257,"RGirl00b",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9a08，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9a1c，261号。
        H.spawn(a,261,"RGirl00b",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9a50，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9a64，257号。
        H.spawn(a,257,"RGirl00b",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9a98，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9aac，261号。
        H.spawn(a,261,"RGirl00b",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9ae0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9af4，257号。
        H.spawn(a,257,"RGirl00b",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9b28，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9b3c，261号。
        H.spawn(a,261,"RGirl00b",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9b70，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9b84，257号。
        H.spawn(a,257,"RGirl00b",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9bb8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9bcc，261号。
        H.spawn(a,261,"RGirl00b",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9c00，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9c14，257号。
        H.spawn(a,257,"RGirl00b",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9c48，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x9c5c，261号。
        H.spawn(a,261,"RGirl00b",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x9c90，10号。
        return
    end
    P["MainSub02b"]=B.part1
end

-- stage04.ecl：MainSub03，0x9cb0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9cb0，40号。
        H.at(a,v,0)
        -- 源0x9cc4，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x9cd8，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9d08，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9d1c，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9d4c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9d60，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9d90，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9da4，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9dd4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9de8，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9e18，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9e2c，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9e5c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9e70，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9ea0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9eb4，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9ee4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9ef8，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9f28，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9f3c，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9f6c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9f80，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9fb0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9fc4，261号。
        H.spawn(a,261,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0x9ff4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa008，257号。
        H.spawn(a,257,"BGirl01",0.0,-32.0,300,1000,2)
        H.at(a,v,0)
        -- 源0xa038，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xa04c，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage04.ecl：MainSub03b，0xa06c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa06c，40号。
        H.at(a,v,0)
        -- 源0xa080，42号。
        H.push(v,9)
        H.at(a,v,0)
        -- 源0xa094，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa0a8，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0xa0bc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa0d4，257号。
        H.spawn(a,257,"BGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa108，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa11c，257号。
        H.spawn(a,257,"BGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa150，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa164，257号。
        H.spawn(a,257,"BGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa198，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa1ac，257号。
        H.spawn(a,257,"RGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa1e0，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa1f4，257号。
        H.spawn(a,257,"RGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa228，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa23c，257号。
        H.spawn(a,257,"BGirl01b",128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa270，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa284，261号。
        H.spawn(a,261,"BGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa2b8，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa2cc，261号。
        H.spawn(a,261,"BGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa300，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa314，261号。
        H.spawn(a,261,"BGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa348，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa35c，261号。
        H.spawn(a,261,"RGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa390，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa3a4，261号。
        H.spawn(a,261,"RGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa3d8，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa3ec，261号。
        H.spawn(a,261,"BGirl01b",-128.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0xa420，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa434，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa448，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xa45c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xa46c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa480，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa490，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa4a8，83号。
        v.origin=v.origin+H.int(60)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa4bc，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xa4d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa4e8，10号。
        return
    end
    P["MainSub03b"]=B.part1
end

-- stage04.ecl：MainSub04，0xa508；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa508，40号。
        H.at(a,v,0)
        -- 源0xa51c，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa54c，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa57c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa590，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa5c0，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa5f0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa604，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa634，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa664，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xa678，257号。
        H.spawn(a,257,"BCir01b",-60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa6a8，261号。
        H.spawn(a,261,"RCir01b",60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa6d8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa6ec，257号。
        H.spawn(a,257,"BCir01b",-60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa71c，261号。
        H.spawn(a,261,"RCir01b",60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa74c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa760，257号。
        H.spawn(a,257,"BCir01b",-60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa790，261号。
        H.spawn(a,261,"RCir01b",60.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa7c0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xa7d4，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa804，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa834，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa848，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa878，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa8a8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0xa8bc，257号。
        H.spawn(a,257,"BCir01",-160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa8ec，261号。
        H.spawn(a,261,"RCir01",160.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0xa91c，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage04.ecl：MainSub05，0xa93c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa93c，40号。
        H.at(a,v,0)
        -- 源0xa950，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa964，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa978，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,0)
        -- 源0xa98c，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xa9bc，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xa9d0，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaa00，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaa14，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaa44，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaa58，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaa88，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaa9c，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaacc，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaae0，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xab10，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xab24，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xab54，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xab68，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xab98，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xabac，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xabdc，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xabf0，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xac20，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xac34，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xac4c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xac60，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xac90，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaca4，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xacd4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xace8，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xad18，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xad2c，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xad5c，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xad70，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xada0，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xadb4，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xade4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xadf8，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xae28，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xae3c，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xae6c，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xae80，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaeb0，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaec4，267号。
        H.spawn(a,267,"GCir02",224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaef4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaf08，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xaf1c，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaf4c，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xaf60，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xaf90，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xafa4，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xafd4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xafe8，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb018，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb02c，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb05c，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb070，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb0a0，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb0b4，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb0e4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb0f8，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb128，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb13c，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb16c，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0xb180，265号。
        H.spawn(a,265,"GCir02",-224.0,192.0,40,1000,2)
        H.at(a,v,0)
        -- 源0xb1b0，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb1c4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xb1d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb1f0，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage04.ecl：MainSub06，0xb210；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb210，40号。
        H.at(a,v,0)
        -- 源0xb224，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xb238，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb24c，257号。
        H.spawn(a,257,"RGirl02",-224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb27c，261号。
        H.spawn(a,261,"RGirl02",224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb2ac，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage04.ecl：MainSub06b，0xb2cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb2cc，40号。
        H.at(a,v,0)
        -- 源0xb2e0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xb2f4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb308，257号。
        H.spawn(a,257,"RGirl02",-224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb338，261号。
        H.spawn(a,261,"RGirl02",224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb368，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0xb37c，257号。
        H.spawn(a,257,"RGirl02",-224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb3ac，261号。
        H.spawn(a,261,"RGirl02",224.0,128.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb3dc，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0xb3f0，257号。
        H.spawn(a,257,"RGirl02",-224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb420，261号。
        H.spawn(a,261,"RGirl02",224.0,96.0,500,1000,2)
        H.at(a,v,0)
        -- 源0xb450，83号。
        v.origin=v.origin+H.int(360)
        H.at(a,v,0)
        -- 源0xb464，257号。
        H.spawn(a,257,"RGirl03",0.0,-32.0,3000,1000,2)
        H.at(a,v,0)
        -- 源0xb494，10号。
        return
    end
    P["MainSub06b"]=B.part1
end

-- stage04.ecl：MapleEnemy，0xb4b4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb4b4，40号。
        H.at(a,v,0)
        -- 源0xb4c8，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb4dc，264号。
        H.effect_abs(a,0,173)
        H.at(a,v,3)
        -- 源0xb4f4，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0xb50c，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage04.ecl：MapleEnemy2，0xb52c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb52c，40号。
        H.at(a,v,0)
        -- 源0xb540，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb554，264号。
        H.effect_abs(a,0,172)
        H.at(a,v,3)
        -- 源0xb56c，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0xb584，1号。
        H.erase(a);return
    end
    P["MapleEnemy2"]=B.part1
end

-- stage04.ecl：PCir00，0xb5a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb5a4，40号。
        H.at(a,v,0)
        -- 源0xb5b8，11号。
        H.call(a,v,P["Cir00"],"Cir00",90,48,1)
        H.at(a,v,0)
        -- 源0xb5ec，1号。
        H.erase(a);return
    end
    P["PCir00"]=B.part1
end

-- stage04.ecl：PCir01，0xb60c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb60c，40号。
        H.at(a,v,0)
        -- 源0xb620，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb634，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb64c，11号。
        H.call(a,v,P["Cir01"],"Cir01",78,1)
        H.at(a,v,0)
        -- 源0xb678，1号。
        H.erase(a);return
    end
    P["PCir01"]=B.part1
end

-- stage04.ecl：PCir01b，0xb698；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb698，40号。
        H.at(a,v,0)
        -- 源0xb6ac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb6c0，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb6d8，11号。
        H.call(a,v,P["Cir01b"],"Cir01b",78,1)
        H.at(a,v,0)
        -- 源0xb704，1号。
        H.erase(a);return
    end
    P["PCir01b"]=B.part1
end

-- stage04.ecl：PCir02，0xb724；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb724，40号。
        H.at(a,v,0)
        -- 源0xb738，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb74c，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb764，11号。
        H.call(a,v,P["Cir02"],"Cir02",78,1)
        H.at(a,v,0)
        -- 源0xb790，1号。
        H.erase(a);return
    end
    P["PCir02"]=B.part1
end

-- stage04.ecl：PCir03，0xb7b0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb7b0，40号。
        H.at(a,v,0)
        -- 源0xb7c4，11号。
        H.call(a,v,P["Cir03"],"Cir03",90,48,1)
        H.at(a,v,0)
        -- 源0xb7f8，1号。
        H.erase(a);return
    end
    P["PCir03"]=B.part1
end

-- stage04.ecl：PhantomMBoss，0xb818；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb818，40号。
        H.at(a,v,0)
        -- 源0xb82c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb840，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb858，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xb86c，370号。
        H.actor_group(a,370,1)
        H.at(a,v,0)
        -- 源0xb880，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xb898，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xb8b0，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0xb8c4，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xb8d8，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0xb8ec，15号。
        H.async(a,P["PhantomMBoss_at"],"PhantomMBoss_at",nil)
        H.at(a,v,0)
        -- 源0xb910，284号。
        H.velocity(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0xb928，285号。
        H.velocity_time(a,0,60,0,-999999.0,-0.10000000149011612)
        H.at(a,v,400)
        -- 源0xb948，1号。
        H.erase(a);return
    end
    P["PhantomMBoss"]=B.part1
end

-- stage04.ecl：PhantomMBoss2，0xb978；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb978，40号。
        H.at(a,v,0)
        -- 源0xb98c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb9a0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb9b8，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0xb9cc，370号。
        H.actor_group(a,370,1)
        H.at(a,v,0)
        -- 源0xb9e0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xb9f8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xba10，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0xba24，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xba38，323号。
        H.flags(a,3,false)
        H.at(a,v,400)
        -- 源0xba4c，0号。
        H.at(a,v,400)
        -- 源0xba5c，369号。
        H.actor_group(a,369,1)
        H.at(a,v,460)
        -- 源0xba70，0号。
        H.at(a,v,460)
        -- 源0xba80，11号。
        H.call(a,v,P["PhantomMBoss2_at"],"PhantomMBoss2_at")
        H.at(a,v,460)
        -- 源0xbaa8，1号。
        H.erase(a);return
    end
    P["PhantomMBoss2"]=B.part1
end

-- stage04.ecl：PhantomMBoss2_at，0xbad8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbad8，40号。
        H.at(a,v,0)
        -- 源0xbaec，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0xbb00，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbb14，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xbb28，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0xbb40，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xbb5c，436号。
        H.gun_count_diff(a,0,3,3,5,6,1,1,1,1)
        H.at(a,v,0)
        -- 源0xbb90，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0xbba4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xbbb8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xbbcc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xbbdc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbbec，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.39269909262657166)
        H.at(a,v,0)
        -- 源0xbc08，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0xbc24，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xbc40，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbc70，356号。
        v.l[4]=H.f32(-0.0055555556900799274)
        H.at(a,v,0)
        -- 源0xbc94，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xbcc4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbcd8，10号。
        return
    end
    P["PhantomMBoss2_at"]=B.part1
end

-- stage04.ecl：PhantomMBoss_at，0xbcf8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbcf8，40号。
        H.at(a,v,0)
        -- 源0xbd0c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0xbd20，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbd34，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xbd48，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xbd60，402号。
        H.gun_sprite(a,0,2,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0xbd7c，406号。
        H.gun_count(a,0,8,1)
        H.at(a,v,0)
        -- 源0xbd98，404号。
        H.gun_angle(a,0,0.0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbdb4，405号。
        H.gun_speed(a,0,0.5,1.0)
        H.at(a,v,0)
        -- 源0xbdd0，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xbdec，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbe1c，356号。
        v.l[4]=H.f32(0.035555556416511536)
        H.at(a,v,0)
        -- 源0xbe40，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xbe70，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0xbe88，355号。
        v.l[8]=H.int(15)
        H.at(a,v,0)
        -- 源0xbeac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xbec4，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0xbee0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbef4，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0xbf08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbf18，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbf2c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0xbf40，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbf54，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xbf74，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xbf88，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbfa0，10号。
        return
    end
    P["PhantomMBoss_at"]=B.part1
end

-- stage04.ecl：RCir00，0xbfc0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbfc0，40号。
        H.at(a,v,0)
        -- 源0xbfd4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xbfe8，11号。
        H.call(a,v,P["Cir00"],"Cir00",81,46,1)
        H.at(a,v,0)
        -- 源0xc01c，1号。
        H.erase(a);return
    end
    P["RCir00"]=B.part1
end

-- stage04.ecl：RCir00_at，0xc03c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc03c，40号。
        H.at(a,v,0)
        -- 源0xc050，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xc064，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xc07c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xc098，436号。
        H.gun_count_diff(a,0,4,4,4,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0xc0cc，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0xc0e8，435号。
        H.gun_speed_diff(a,0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xc11c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xc138，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc168，356号。
        v.l[4]=H.f32(0.0555555559694767)
        H.at(a,v,0)
        -- 源0xc18c，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xc1bc，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xc1d0，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0xc1e8，402号。
        H.gun_sprite(a,1,2,6)
        H.at(a,v,0)
        -- 源0xc204，406号。
        H.gun_count(a,1,3,1)
        H.at(a,v,0)
        -- 源0xc220，404号。
        H.gun_angle(a,1,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0xc23c，405号。
        H.gun_speed(a,1,1.0,1.0)
        H.at(a,v,0)
        -- 源0xc258，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xc274，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc2a4，409号。
        H.gun_transform(a,1,1,0,4,90,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xc2d4，355号。
        v.l[8]=H.int(20)
        H.at(a,v,0)
        -- 源0xc2f8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc310，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xc324，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc344，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xc358，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc370，10号。
        return
    end
    P["RCir00_at"]=B.part1
end

-- stage04.ecl：RCir01，0xc390；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc390，40号。
        H.at(a,v,0)
        -- 源0xc3a4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xc3b8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xc3d0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xc3e4，11号。
        H.call(a,v,P["Cir01"],"Cir01",69,1)
        H.at(a,v,0)
        -- 源0xc410，1号。
        H.erase(a);return
    end
    P["RCir01"]=B.part1
end

-- stage04.ecl：RCir01_at，0xc430；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc430，40号。
        H.at(a,v,0)
        -- 源0xc444，356号。
        v.l[4]=H.f32(8.0)
        H.at(a,v,0)
        -- 源0xc468，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0xc498，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc4c8，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.0416666679084301,-999999.0)
        H.at(a,v,0)
        -- 源0xc4f8，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0xc514，355号。
        v.l[8]=H.int(80)
        H.at(a,v,0)
        -- 源0xc538，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xc54c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc560，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc578，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc5a8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc5bc，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xc5d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc5e0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc5f4，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc624，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc638，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xc64c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc65c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc670，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc6a0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc6b4，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xc6c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc6d8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc6ec，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc71c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc730，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xc744，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc754，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc768，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc798，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc7ac，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xc7c0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xc7d0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc7e4，433号。
        H.laser(a,433,3,2,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xc814，368号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc834，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xc848，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc860，10号。
        return
    end
    P["RCir01_at"]=B.part1
end

-- stage04.ecl：RCir01b，0xc880；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc880，40号。
        H.at(a,v,0)
        -- 源0xc894，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xc8a8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xc8c0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xc8d4，11号。
        H.call(a,v,P["Cir01b"],"Cir01b",69,1)
        H.at(a,v,0)
        -- 源0xc900，1号。
        H.erase(a);return
    end
    P["RCir01b"]=B.part1
end

-- stage04.ecl：RCir01b_at，0xc920；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc920，40号。
        H.at(a,v,0)
        -- 源0xc934，356号。
        v.l[4]=H.f32(8.0)
        H.at(a,v,0)
        -- 源0xc958，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,-0.09166666865348816,-999999.0)
        H.at(a,v,0)
        -- 源0xc988，409号。
        H.gun_transform(a,0,1,0,4096,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc9b8，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.0416666679084301,-999999.0)
        H.at(a,v,0)
        -- 源0xc9e8，408号。
        H.gun_sound(a,0,16,-1)
        H.at(a,v,0)
        -- 源0xca04，355号。
        v.l[8]=H.int(80)
        H.at(a,v,0)
        -- 源0xca28，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xca3c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xca50，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xca68，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xca98，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcaac，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xcac0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcad0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcae4，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xcb14，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcb28，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xcb3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcb4c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcb60，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xcb90，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcba4，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xcbb8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcbc8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcbdc，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xcc0c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcc20，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xcc34，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcc44，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcc58，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xcc88，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcc9c，44号。
        H.push(v,1.0471980571746826)
        H.at(a,v,0)
        -- 源0xccb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xccc0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xccd4，433号。
        H.laser(a,433,3,6,(v.l[0] or 0),(v.l[4] or 0),0,128.0,512.0,12.0)
        H.at(a,v,0)
        -- 源0xcd04，368号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xcd24，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xcd38，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xcd50，10号。
        return
    end
    P["RCir01b_at"]=B.part1
end

-- stage04.ecl：RCir02，0xcd70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcd70，40号。
        H.at(a,v,0)
        -- 源0xcd84，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xcd98，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xcdb0，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xcdc4，11号。
        H.call(a,v,P["Cir02"],"Cir02",69,1)
        H.at(a,v,0)
        -- 源0xcdf0，1号。
        H.erase(a);return
    end
    P["RCir02"]=B.part1
end

-- stage04.ecl：RCir02_at，0xce10；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xce10，40号。
        H.at(a,v,0)
        -- 源0xce24，355号。
        v.l[0]=H.int(10)
        H.at(a,v,0)
        -- 源0xce48，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xce5c，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xce74，402号。
        H.gun_sprite(a,0,12,5)
        H.at(a,v,0)
        -- 源0xce90，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,2,2)
        H.at(a,v,0)
        -- 源0xcec4，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xcee0，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,4.199999809265137,4.199999809265137,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xcf14，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xcf44，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0xcf58，356号。
        v.l[4]=H.f32(2.0)
        H.at(a,v,0)
        -- 源0xcf7c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xcf94，405号。
        H.gun_speed(a,0,(v.l[4] or 0),2.0)
        H.at(a,v,0)
        -- 源0xcfb0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xcfc4，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0xcfd8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xcfe8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcffc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd010，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd024，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xd038，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd050，10号。
        return
    end
    P["RCir02_at"]=B.part1
end

-- stage04.ecl：RCir03，0xd070；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd070，40号。
        H.at(a,v,0)
        -- 源0xd084，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xd098，11号。
        H.call(a,v,P["Cir03"],"Cir03",81,46,1)
        H.at(a,v,0)
        -- 源0xd0cc，1号。
        H.erase(a);return
    end
    P["RCir03"]=B.part1
end

-- stage04.ecl：RCir03_at，0xd0ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd0ec，40号。
        H.at(a,v,0)
        -- 源0xd100，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd114，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xd12c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0xd148，406号。
        H.gun_count(a,0,4,1)
        H.at(a,v,0)
        -- 源0xd164，404号。
        H.gun_angle(a,0,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0xd180，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0xd19c，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0xd1b8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd1e8，409号。
        H.gun_transform(a,0,1,0,4,90,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0xd218，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xd22c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd240，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd258，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd26c，83号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd280，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xd294，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd2ac，10号。
        return
    end
    P["RCir03_at"]=B.part1
end

-- stage04.ecl：RGirl00，0xd2cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd2cc，40号。
        H.at(a,v,0)
        -- 源0xd2e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd2f4，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xd30c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xd320，11号。
        H.call(a,v,P["Girl00"],"Girl00",40,1)
        H.at(a,v,0)
        -- 源0xd34c，1号。
        H.erase(a);return
    end
    P["RGirl00"]=B.part1
end

-- stage04.ecl：RGirl00_at，0xd36c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd36c，40号。
        H.at(a,v,0)
        -- 源0xd380，355号。
        v.l[4]=H.int(12)
        H.at(a,v,0)
        -- 源0xd3a4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd3b8，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xd3d0，402号。
        H.gun_sprite(a,0,6,6)
        H.at(a,v,0)
        -- 源0xd3ec，436号。
        H.gun_count_diff(a,0,3,3,3,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0xd420，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xd43c，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,2.200000047683716,2.200000047683716,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xd470，404号。
        H.gun_angle(a,0,0.0,0.8975979089736938)
        H.at(a,v,0)
        -- 源0xd48c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd4bc，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd4ec，356号。
        v.l[12]=H.f32(0.003926991019397974)
        H.at(a,v,0)
        -- 源0xd510，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xd524，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd538，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xd548，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xd55c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xd56c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd580，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd594，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd5a8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xd5b8，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd5cc，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd5e4，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd614，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd628，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd658，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd66c，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05000000074505806,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd69c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd6b0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xd6c4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xd6d8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd6e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd700，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.009999999776482582,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd730，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd744，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd758，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xd76c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xd77c，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xd790，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xd7a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xd7bc，10号。
        return
    end
    P["RGirl00_at"]=B.part1
end

-- stage04.ecl：RGirl00b，0xd7dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd7dc，40号。
        H.at(a,v,0)
        -- 源0xd7f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd804，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xd81c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xd830，11号。
        H.call(a,v,P["Girl00b"],"Girl00b",40,1)
        H.at(a,v,0)
        -- 源0xd85c，1号。
        H.erase(a);return
    end
    P["RGirl00b"]=B.part1
end

-- stage04.ecl：RGirl00b_at，0xd87c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd87c，40号。
        H.at(a,v,0)
        -- 源0xd890，355号。
        v.l[4]=H.int(8)
        H.at(a,v,0)
        -- 源0xd8b4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd8c8，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0xd8e0，402号。
        H.gun_sprite(a,0,6,10)
        H.at(a,v,0)
        -- 源0xd8fc，436号。
        H.gun_count_diff(a,0,3,3,3,6,1,1,1,1)
        H.at(a,v,0)
        -- 源0xd930，404号。
        H.gun_angle(a,0,1.5707963705062866,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xd94c，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,2.200000047683716,2.0,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xd980，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd9b0，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd9e0，356号。
        v.l[12]=H.f32(0.005235987715423107)
        H.at(a,v,0)
        -- 源0xda04，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xda18，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xda2c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xda3c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xda50，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xda60，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xda74，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xda88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xda9c，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xdaac，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xdac0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xdad8，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdb08，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xdb1c，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdb4c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xdb60，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05000000074505806,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdb90，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xdba4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xdbb8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xdbcc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xdbdc，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xdbf0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xdc04，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xdc1c，10号。
        return
    end
    P["RGirl00b_at"]=B.part1
end

-- stage04.ecl：RGirl01，0xdc3c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdc3c，40号。
        H.at(a,v,0)
        -- 源0xdc50，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xdc64，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xdc7c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xdc90，11号。
        H.call(a,v,P["Girl01"],"Girl01",5,1)
        H.at(a,v,0)
        -- 源0xdcbc，1号。
        H.erase(a);return
    end
    P["RGirl01"]=B.part1
end

-- stage04.ecl：RGirl01_at，0xdcdc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdcdc，40号。
        H.at(a,v,0)
        -- 源0xdcf0，355号。
        v.l[4]=H.int(12)
        H.at(a,v,0)
        -- 源0xdd14，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xdd28，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0xdd40，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0xdd5c，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,2,1)
        H.at(a,v,0)
        -- 源0xdd90，404号。
        H.gun_angle(a,0,H.read(a,v,-9989),0.3490658402442932)
        H.at(a,v,0)
        -- 源0xddac，435号。
        H.gun_speed_diff(a,0,1.0,1.0,4.199999809265137,4.199999809265137,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xdde0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xde10，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0xde24，356号。
        v.l[8]=H.f32(1.0)
        H.at(a,v,0)
        -- 源0xde48，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xde60，405号。
        H.gun_speed(a,0,(v.l[8] or 0),1.0)
        H.at(a,v,0)
        -- 源0xde7c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xde90，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0xdea4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdeb4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xdec8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xdedc，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xdef0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xdf04，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xdf1c，10号。
        return
    end
    P["RGirl01_at"]=B.part1
end

-- stage04.ecl：RGirl01b，0xdf3c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdf3c，40号。
        H.at(a,v,0)
        -- 源0xdf50，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xdf64，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xdf7c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xdf90，11号。
        H.call(a,v,P["Girl01b"],"Girl01b",5,1)
        H.at(a,v,0)
        -- 源0xdfbc，1号。
        H.erase(a);return
    end
    P["RGirl01b"]=B.part1
end

-- stage04.ecl：RGirl01b_at，0xdfdc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdfdc，40号。
        H.at(a,v,0)
        -- 源0xdff0，355号。
        v.l[4]=H.int(20)
        H.at(a,v,0)
        -- 源0xe014，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe028，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0xe040，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0xe05c，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0xe090，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xe0ac，435号。
        H.gun_speed_diff(a,0,1.600000023841858,3.0,4.199999809265137,4.199999809265137,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xe0e0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe110，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0xe124，356号。
        v.l[8]=H.f32(4.0)
        H.at(a,v,0)
        -- 源0xe148，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe160，405号。
        H.gun_speed(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0xe17c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe190，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0xe1a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe1b4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe1c8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe1dc，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe1fc，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xe210，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe228，10号。
        return
    end
    P["RGirl01b_at"]=B.part1
end

-- stage04.ecl：RGirl02，0xe248；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe248，40号。
        H.at(a,v,0)
        -- 源0xe25c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe270，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe288，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xe29c，11号。
        H.call(a,v,P["Girl02"],"Girl02",40,1)
        H.at(a,v,0)
        -- 源0xe2c8，1号。
        H.erase(a);return
    end
    P["RGirl02"]=B.part1
end

-- stage04.ecl：RGirl02_at，0xe2e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe2e8，40号。
        H.at(a,v,0)
        -- 源0xe2fc，355号。
        v.l[4]=H.int(12)
        H.at(a,v,0)
        -- 源0xe320，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe334，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xe34c，402号。
        H.gun_sprite(a,0,6,4)
        H.at(a,v,0)
        -- 源0xe368，436号。
        H.gun_count_diff(a,0,3,6,6,6,1,1,1,1)
        H.at(a,v,0)
        -- 源0xe39c，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xe3b8，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,2.200000047683716,2.200000047683716,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xe3ec，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe41c，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe44c，356号。
        v.l[12]=H.f32(0.003926991019397974)
        H.at(a,v,0)
        -- 源0xe470，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe484，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe498，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xe4a8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xe4bc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xe4cc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe4e0，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe4f4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe508，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xe518，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe52c，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe544，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe574，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe588，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe5b8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe5cc，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.014000000432133675,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe5fc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe610，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05000000074505806,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe640，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xe654，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xe668，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe67c，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xe68c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe6a4，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.07000000029802322,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe6d4，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe6e8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe6fc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe710，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe720，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xe734，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xe748，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xe760，10号。
        return
    end
    P["RGirl02_at"]=B.part1
end

-- stage04.ecl：RGirl03，0xe780；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe780，40号。
        H.at(a,v,0)
        -- 源0xe794，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe7a8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xe7c0，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xe7d4，11号。
        H.call(a,v,P["Girl03"],"Girl03",40,1)
        H.at(a,v,0)
        -- 源0xe800，1号。
        H.erase(a);return
    end
    P["RGirl03"]=B.part1
end

-- stage04.ecl：RGirl03_at，0xe820；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe820，40号。
        H.at(a,v,0)
        -- 源0xe834，355号。
        v.l[4]=H.int(8)
        H.at(a,v,0)
        -- 源0xe858，42号。
        H.push(v,18)
        H.at(a,v,0)
        -- 源0xe86c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe880，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe894，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xe8ac，402号。
        H.gun_sprite(a,0,6,10)
        H.at(a,v,0)
        -- 源0xe8c8，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0xe8fc，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xe918，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,2.200000047683716,2.200000047683716,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xe94c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe97c，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe9ac，44号。
        H.push(v,1.7671459913253784)
        H.at(a,v,0)
        -- 源0xe9c0，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe9d4，44号。
        H.push(v,1.374446988105774)
        H.at(a,v,0)
        -- 源0xe9e8，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe9fc，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xea14，356号。
        v.l[16]=H.f32(0.003926991019397974)
        H.at(a,v,0)
        -- 源0xea38，355号。
        v.l[4]=H.int(10)
        H.at(a,v,0)
        -- 源0xea5c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xea70，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xea84，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xea94，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xeaa8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xeab8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xeacc，404号。
        H.gun_angle(a,0,(v.l[20] or 0),0.0)
        H.at(a,v,0)
        -- 源0xeae8，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xeafc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xeb10，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xeb20，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xeb34，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xeb4c，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xeb7c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xeb90，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xebc0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xebd4，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05999999865889549,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xec04，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xec18，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xec2c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xec40，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xec50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xec68，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.07999999821186066,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xec98，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xecac，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xecc0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xecd4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xece4，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xecf8，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xed0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xed24，356号。
        v.l[16]=H.f32(0.003926991019397974)
        H.at(a,v,0)
        -- 源0xed48，355号。
        v.l[4]=H.int(10)
        H.at(a,v,0)
        -- 源0xed6c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xed80，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xed94，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xeda4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xedb8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xedc8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xeddc，404号。
        H.gun_angle(a,0,(v.l[24] or 0),0.0)
        H.at(a,v,0)
        -- 源0xedf8，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xee0c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xee20，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xee30，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xee44，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xee5c，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xee8c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xeea0，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xeed0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xeee4，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05999999865889549,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xef14，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xef28，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xef3c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xef50，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xef60，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xef78，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.07999999821186066,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xefa8，401号。
        H.fire(a,0)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xefbc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xefd0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xefe4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xeff4，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0xf008，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xf01c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0xf034，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0xf048，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0xf05c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf06c，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf080，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0xf094，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0xf0a8，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0xf0bc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf0cc，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf0e0，82号。
        v.l[24]=H.f32(H.angle((v.l[24] or 0)))
        H.at(a,v,0)
        -- 源0xf0f4，83号。
        v.origin=v.origin+H.int(10)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0xf108，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xf11c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0xf134，10号。
        return
    end
    P["RGirl03_at"]=B.part1
end

-- stage04.ecl：RPhantomMBoss，0xf154；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf154，40号。
        H.at(a,v,0)
        -- 源0xf168，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf17c，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xf194，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xf1a8，11号。
        H.call(a,v,P["PhantomMBoss"],"PhantomMBoss",94,1)
        H.at(a,v,0)
        -- 源0xf1dc，1号。
        H.erase(a);return
    end
    P["RPhantomMBoss"]=B.part1
end

-- stage04.ecl：RPhantomMBoss2，0xf1fc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf1fc，40号。
        H.at(a,v,0)
        -- 源0xf210，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf224，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xf23c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xf250，11号。
        H.call(a,v,P["PhantomMBoss2"],"PhantomMBoss2",94,1)
        H.at(a,v,0)
        -- 源0xf284，1号。
        H.erase(a);return
    end
    P["RPhantomMBoss2"]=B.part1
end

-- stage04.ecl：YGirl00，0xf2a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf2a4，40号。
        H.at(a,v,0)
        -- 源0xf2b8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf2cc，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf2e4，11号。
        H.call(a,v,P["Girl00"],"Girl00",15,1)
        H.at(a,v,0)
        -- 源0xf310，1号。
        H.erase(a);return
    end
    P["YGirl00"]=B.part1
end

-- stage04.ecl：YGirl00b，0xf330；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf330，40号。
        H.at(a,v,0)
        -- 源0xf344，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf358，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf370，11号。
        H.call(a,v,P["Girl00b"],"Girl00b",15,1)
        H.at(a,v,0)
        -- 源0xf39c，1号。
        H.erase(a);return
    end
    P["YGirl00b"]=B.part1
end

-- stage04.ecl：YGirl01，0xf3bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf3bc，40号。
        H.at(a,v,0)
        -- 源0xf3d0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf3e4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf3fc，11号。
        H.call(a,v,P["Girl01"],"Girl01",15,1)
        H.at(a,v,0)
        -- 源0xf428，1号。
        H.erase(a);return
    end
    P["YGirl01"]=B.part1
end

-- stage04.ecl：YGirl01b，0xf448；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf448，40号。
        H.at(a,v,0)
        -- 源0xf45c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf470，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf488，11号。
        H.call(a,v,P["Girl01b"],"Girl01b",15,1)
        H.at(a,v,0)
        -- 源0xf4b4，1号。
        H.erase(a);return
    end
    P["YGirl01b"]=B.part1
end

-- stage04.ecl：YGirl02，0xf4d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf4d4，40号。
        H.at(a,v,0)
        -- 源0xf4e8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf4fc，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf514，11号。
        H.call(a,v,P["Girl02"],"Girl02",15,1)
        H.at(a,v,0)
        -- 源0xf540，1号。
        H.erase(a);return
    end
    P["YGirl02"]=B.part1
end

-- stage04.ecl：YGirl03，0xf560；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf560，40号。
        H.at(a,v,0)
        -- 源0xf574，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf588，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf5a0，11号。
        H.call(a,v,P["Girl03"],"Girl03",15,1)
        H.at(a,v,0)
        -- 源0xf5cc，1号。
        H.erase(a);return
    end
    P["YGirl03"]=B.part1
end

-- stage04.ecl：YPhantomMBoss，0xf5ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf5ec，40号。
        H.at(a,v,0)
        -- 源0xf600，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf614，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xf628，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf640，11号。
        H.call(a,v,P["PhantomMBoss"],"PhantomMBoss",100,1)
        H.at(a,v,0)
        -- 源0xf674，1号。
        H.erase(a);return
    end
    P["YPhantomMBoss"]=B.part1
end

-- stage04.ecl：YPhantomMBoss2，0xf694；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf694，40号。
        H.at(a,v,0)
        -- 源0xf6a8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xf6bc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xf6d0，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xf6e8，11号。
        H.call(a,v,P["PhantomMBoss2"],"PhantomMBoss2",100,1)
        H.at(a,v,0)
        -- 源0xf71c，1号。
        H.erase(a);return
    end
    P["YPhantomMBoss2"]=B.part1
end

-- stage04.ecl：main，0xf73c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf73c，40号。
        H.at(a,v,0)
        -- 源0xf750，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0xf764，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xf778，83号。
        v.origin=v.origin+H.int(140)
        H.at(a,v,0)
        -- 源0xf78c，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0xf7a0，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,0)
        -- 源0xf7c0，11号。
        H.call(a,v,P["MainSub01"],"MainSub01")
        H.at(a,v,0)
        -- 源0xf7e0，83号。
        v.origin=v.origin+H.int(1100)
        H.at(a,v,0)
        -- 源0xf7f4，15号。
        H.async(a,P["MainSub03"],"MainSub03",nil)
        H.at(a,v,0)
        -- 源0xf814，11号。
        H.call(a,v,P["MainSub02"],"MainSub02")
        H.at(a,v,0)
        -- 源0xf834，83号。
        v.origin=v.origin+H.int(190)
        H.at(a,v,0)
        -- 源0xf848，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0xf868，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xf87c，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0xf890，11号。
        H.call(a,v,P["MainSub00b"],"MainSub00b")
        H.at(a,v,0)
        -- 源0xf8b0，11号。
        H.call(a,v,P["MainSub01b"],"MainSub01b")
        H.at(a,v,0)
        -- 源0xf8d0，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,0)
        -- 源0xf8f0，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,0)
        -- 源0xf910，83号。
        v.origin=v.origin+H.int(260)
        H.at(a,v,0)
        -- 源0xf924，15号。
        H.async(a,P["MainSub03b"],"MainSub03b",nil)
        H.at(a,v,0)
        -- 源0xf944，11号。
        H.call(a,v,P["MainSub02b"],"MainSub02b")
        H.at(a,v,0)
        -- 源0xf964，83号。
        v.origin=v.origin+H.int(190)
        H.at(a,v,0)
        -- 源0xf978，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0xf998，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0xf9ac，11号。
        H.call(a,v,P["MainSub06b"],"MainSub06b")
        H.at(a,v,0)
        -- 源0xf9cc，83号。
        v.origin=v.origin+H.int(600)
        H.at(a,v,0)
        -- 源0xf9e0，338号。
        H.dialog(a,0)
        H.at(a,v,0)
        -- 源0xf9f4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0xfa04，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,0)
        -- 源0xfa34，340号。
        H.boss_wait(a,v)
        H.at(a,v,0)
        -- 源0xfa44，338号。
        H.dialog(a,1)
        H.at(a,v,0)
        -- 源0xfa58，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0xfa68，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xfa80，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfa94，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfaa8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xfac0，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xfad8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xfaec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfb00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xfb18，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xfb2c，15号。
        H.async(a,P["MainSub02"],"MainSub02",nil)
        H.at(a,v,0)
        -- 源0xfb4c，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,0)
        -- 源0xfb6c，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0xfb8c，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,0)
        -- 源0xfbac，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,0)
        -- 源0xfbcc，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0xfbe0，338号。
        H.dialog(a,0)
        H.at(a,v,0)
        -- 源0xfbf4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0xfc04，340号。
        H.boss_wait(a,v)
        H.at(a,v,40000)
        -- 源0xfc14，0号。
        H.at(a,v,40000)
        -- 源0xfc24，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

-- stage4c00a.ecl：BossCard2_00A，0x100；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x100，40号。
        H.at(a,v,0)
        -- 源0x114，331号。
        H.life(a,8800)
        H.at(a,v,0)
        -- 源0x128，334号。
        H.interrupt(a,0,6000,3000,"BossCard3_00A")
        H.at(a,v,0)
        -- 源0x158，347号。
        H.life_marker(a,0,8800.0,-32513)
        H.at(a,v,0)
        -- 源0x174，347号。
        H.life_marker(a,1,6000.0,-4194112)
        H.at(a,v,0)
        -- 源0x190，347号。
        H.life_marker(a,2,3500.0,-10485664)
        H.at(a,v,0)
        -- 源0x1ac，357号。
        H.spell(a,46,3000,500000,"想起「二重黒死蝶」",357)
        H.at(a,v,0)
        -- 源0x1e0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1f4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x208，0号。
        H.at(a,v,60)
        -- 源0x218，12号。
        v.origin=H.clock(a)-(180);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x230，15号。
        H.async(a,P["BossCardAttack07_00"],"BossCardAttack07_00",nil)
        H.at(a,v,60)
        -- 源0x258，15号。
        H.async(a,P["BossCardAttack07_00b"],"BossCardAttack07_00b",nil)
        H.at(a,v,120)
        -- 源0x284，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x29c，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x2b0，368号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x2d0，292号。
        H.wander(a,0,60,0,1.0)
        H.at(a,v,120)
        -- 源0x2ec，15号。
        H.async(a,P["BossCardAttack07_00"],"BossCardAttack07_00",nil)
        H.at(a,v,120)
        -- 源0x314，15号。
        H.async(a,P["BossCardAttack07_00b"],"BossCardAttack07_00b",nil)
        H.at(a,v,180)
        -- 源0x340，263号。
        H.effect(a,0,131)
        H.at(a,v,180)
        -- 源0x358，336号。
        H.sound(a,41)
        H.at(a,v,180)
        -- 源0x36c，368号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,180)
        -- 源0x38c，292号。
        H.wander(a,0,60,0,1.0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,180)
        -- 源0x3a8，42号。
        H.push(v,1)
        H.at(a,v,180)
        -- 源0x3bc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,180)
        -- 源0x3d4，10号。
        return
    end
    P["BossCard2_00A"]=B.part1
end

-- stage4c00a.ecl：BossCard3_00A，0x3f4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3f4，40号。
        H.at(a,v,0)
        -- 源0x408，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x41c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x42c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x440，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x454，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x464，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x47c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x490，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4a8，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4bc，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x4cc，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4dc，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x4f0，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x500，334号。
        H.interrupt(a,0,3500,3000,"BossCard4_00A")
        H.at(a,v,0)
        -- 源0x530，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x544，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x558，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x56c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x57c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x594，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x5a4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x5b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5cc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5dc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5f4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x608，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x62c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x644，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x654，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x668，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x67c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x690，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x6a4，357号。
        H.spell(a,50,3000,500000,"想起「飛行虫ネスト」",357)
        H.at(a,v,60)
        -- 源0x6dc，0号。
        H.at(a,v,60)
        -- 源0x6ec，15号。
        H.async(a,P["BossCard3_00Aat3"],"BossCard3_00Aat3",nil)
        H.at(a,v,60)
        -- 源0x714，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x72c，15号。
        H.async(a,P["BossCard3_00Aat"],"BossCard3_00Aat",nil)
        H.at(a,v,60)
        -- 源0x750，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,60)
        -- 源0x770，15号。
        H.async(a,P["BossCard3_00Aat2"],"BossCard3_00Aat2",nil)
        H.at(a,v,60)
        -- 源0x798，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,60)
        -- 源0x7b8，292号。
        H.wander(a,0,60,0,1.0)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x7d4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x7e8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x800，10号。
        return
    end
    P["BossCard3_00A"]=B.part1
end

-- stage4c00a.ecl：BossCard3_00Aat，0x820；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x820，40号。
        H.at(a,v,0)
        -- 源0x834，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x848，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x85c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x870，439号。
        H.gun_absolute(a,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0x88c，409号。
        H.gun_transform(a,0,0,0,4,30,-999999,-0.30000001192092896,-999999.0)
        H.at(a,v,0)
        -- 源0x8bc，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x8d0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8e4，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x8f8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x908，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x918，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x92c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x940，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x954，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x96c，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x980，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x994，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9b8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9cc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9e0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x9f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa08，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xa18，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa28，403号。
        H.gun_offset(a,0,H.read(a,v,-1),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xa44，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xa58，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa6c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xa7c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa90，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xaa0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xab4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xac8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xad8，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xae8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb00，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0xb14，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xb28，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xb3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb4c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb74，431号。
        H.laser(a,431,3,4,-1.5707963705062866,12.0,0,128.0,0.0,16.0)
        H.at(a,v,0)
        -- 源0xba4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xbbc，431号。
        H.laser(a,431,3,4,1.5707963705062866,12.0,0,128.0,0.0,16.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xbec，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xc00，44号。
        H.push(v,2.799999952316284)
        H.at(a,v,0)
        -- 源0xc14，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xc24，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xc38，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xc4c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xc60，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xc74，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc84，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xc94，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xca8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcbc，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xcd0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xce0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xcf8，10号。
        return
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xd08，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd1c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0xd30，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd40，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xd58，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xd6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd80，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd90，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xda4，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xdb8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xdcc，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xddc，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xdf0，368号。
        v.origin=v.origin+H.int(6)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0xe10，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe24，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0xe3c，10号。
        return
    end
    P["BossCard3_00Aat"]=B.part1
end

-- stage4c00a.ecl：BossCard3_00Aat2，0xe5c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe5c，40号。
        H.at(a,v,0)
        -- 源0xe70，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe84，439号。
        H.gun_absolute(a,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0xea0，409号。
        H.gun_transform(a,0,0,0,4,30,-999999,-0.30000001192092896,-999999.0)
        H.at(a,v,0)
        -- 源0xed0，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xee4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xef8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xf0c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf1c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf2c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf40，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xf54，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf68，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf80，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0xf94，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xfa8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xfbc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfcc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xfe0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xff4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1008，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x101c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x102c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x103c，403号。
        H.gun_offset(a,0,H.read(a,v,-1),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1058，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x106c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1080，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x1090，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x10a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10b4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x10c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x10dc，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10ec，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10fc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1114，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x1128，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x113c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x1150，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1160，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1170，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1188，431号。
        H.laser(a,431,3,4,-1.5707963705062866,12.0,0,128.0,0.0,16.0)
        H.at(a,v,0)
        -- 源0x11b8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x11d0，431号。
        H.laser(a,431,3,4,1.5707963705062866,12.0,0,128.0,0.0,16.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1200，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1214，44号。
        H.push(v,2.799999952316284)
        H.at(a,v,0)
        -- 源0x1228，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1238，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x124c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1260，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1274，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1288，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1298，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12a8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12bc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x12d0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x12e4，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x12f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x130c，10号。
        return
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x131c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1330，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x1344，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1354，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x136c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1380，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1394，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13a4，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x13b8，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x13cc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x13e0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x13f0，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1404，368号。
        v.origin=v.origin+H.int(6)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x1424，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1438，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x1450，10号。
        return
    end
    P["BossCard3_00Aat2"]=B.part1
end

-- stage4c00a.ecl：BossCard3_00Aat3，0x1470；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1470，40号。
        H.at(a,v,0)
        -- 源0x1484，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x1498，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x14b0，402号。
        H.gun_sprite(a,1,15,3)
        H.at(a,v,0)
        -- 源0x14cc，406号。
        H.gun_count(a,1,5,1)
        H.at(a,v,0)
        -- 源0x14e8，404号。
        H.gun_angle(a,1,0.0,0.09817477315664291)
        H.at(a,v,0)
        -- 源0x1504，405号。
        H.gun_speed(a,1,1.0,2.0)
        H.at(a,v,0)
        -- 源0x1520，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1550，409号。
        H.gun_transform(a,1,1,0,4,120,-999999,0.01666666753590107,-999999.0)
        H.at(a,v,0)
        -- 源0x1580，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x1594，407号。
        H.gun_aim(a,2,0)
        H.at(a,v,0)
        -- 源0x15ac，402号。
        H.gun_sprite(a,2,15,2)
        H.at(a,v,0)
        -- 源0x15c8，406号。
        H.gun_count(a,2,6,1)
        H.at(a,v,0)
        -- 源0x15e4，404号。
        H.gun_angle(a,2,3.1415927410125732,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x1600，405号。
        H.gun_speed(a,2,1.0,2.0)
        H.at(a,v,0)
        -- 源0x161c，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x164c，409号。
        H.gun_transform(a,2,1,1,256,1,15,1.0,-999999.0)
        H.at(a,v,0)
        -- 源0x167c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1690，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x16a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x16b4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x16cc，409号。
        H.gun_transform(a,2,3,0,4,120,-999999,0.02500000037252903,-999999.0)
        H.at(a,v,0)
        -- 源0x16fc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1714，409号。
        H.gun_transform(a,2,3,0,4,120,-999999,0.01666666753590107,-999999.0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1744，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x1758，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1770，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1784，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1798，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x17a8，409号。
        H.gun_transform(a,2,2,0,32,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x17d8，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x17ec，83号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x1800，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1814，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1828，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1838，409号。
        H.gun_transform(a,2,2,0,32,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x1868，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x187c，83号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x1890，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x18a4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x18b8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x18c8，409号。
        H.gun_transform(a,2,2,0,32,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x18f8，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x190c，83号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x1920，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1934，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1948，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1958，409号。
        H.gun_transform(a,2,2,0,32,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x1988，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x199c，83号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x19b0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x19c4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x19d8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x19e8，409号。
        H.gun_transform(a,2,2,0,32,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x1a18，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x1a2c，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x1a40，368号。
        v.origin=v.origin+H.int(130)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1a60，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a74，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1a8c，10号。
        return
    end
    P["BossCard3_00Aat3"]=B.part1
end

-- stage4c00a.ecl：BossCard4_00A，0x1aac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1aac，40号。
        H.at(a,v,0)
        -- 源0x1ac0，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x1ad4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1ae4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1af8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1b0c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1b1c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1b34，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1b48，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1b60，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1b74，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1b84，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1b94，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1ba8，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x1bb8，334号。
        H.interrupt(a,0,0,3600,"BossDead")
        H.at(a,v,0)
        -- 源0x1be4，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x1bf8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1c0c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1c20，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1c30，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1c48，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1c58，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1c6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1c80，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1c90，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1ca8，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1cbc，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x1ce0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1cf8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1d08，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1d1c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1d30，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1d44，281号。
        H.position_time(a,0,90,4,0.0,192.0)
        H.at(a,v,0)
        -- 源0x1d64，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x1d78，357号。
        H.spell(a,54,3600,500000,"想起「波と粒の境界」",357)
        H.at(a,v,60)
        -- 源0x1db0，0号。
        H.at(a,v,60)
        -- 源0x1dc0，15号。
        H.async(a,P["BossCard4_00Aat"],"BossCard4_00Aat",nil)
        H.at(a,v,60)
        -- 源0x1de4，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x1dfc，83号。
        v.origin=v.origin+H.int(100)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x1e10，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1e24，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x1e3c，10号。
        return
    end
    P["BossCard4_00A"]=B.part1
end

-- stage4c00a.ecl：BossCard4_00Aat，0x1e5c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1e5c，40号。
        H.at(a,v,0)
        -- 源0x1e70，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1e84，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x1e9c，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x1eb8，436号。
        H.gun_count_diff(a,0,2,5,8,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1eec，404号。
        H.gun_angle(a,0,0.0,0.09817477315664291)
        H.at(a,v,0)
        -- 源0x1f08，405号。
        H.gun_speed(a,0,1.0,2.0)
        H.at(a,v,0)
        -- 源0x1f24，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1f54，409号。
        H.gun_transform(a,0,1,0,4,120,-999999,0.013333333656191826,-999999.0)
        H.at(a,v,0)
        -- 源0x1f84，438号。
        H.gun_distance(a,0,24.0)
        H.at(a,v,0)
        -- 源0x1f9c，356号。
        H.write(a,-9981,H.f32(1.5707963705062866))
        H.at(a,v,0)
        -- 源0x1fc0，44号。
        H.push(v,-0.07853999733924866)
        H.at(a,v,0)
        -- 源0x1fd4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1fe8，44号。
        H.push(v,0.003926999866962433)
        H.at(a,v,0)
        -- 源0x1ffc，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2010，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2024，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2038，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2050，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2064，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,0)
        -- 源0x2078，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2088，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x209c，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x20d4，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x20e8，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x20fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x210c，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x2128，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x213c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x2150，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x2164，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2174，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2188，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x219c，44号。
        H.push(v,H.read(a,v,-9979))
        H.at(a,v,0)
        -- 源0x21b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x21c0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x21d4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x21e8，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x21fc，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x220c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2224，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2238，44号。
        H.push(v,0.009999999776482582)
        H.at(a,v,0)
        -- 源0x224c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x225c，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2270，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,0)
        -- 源0x2284，82号。
        H.write(a,-9980,H.f32(H.angle(H.read(a,v,-9980))))
        H.at(a,v,0)
        -- 源0x2298，83号。
        v.origin=v.origin+H.int(2)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x22ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x22c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x22d8，10号。
        return
    end
    P["BossCard4_00Aat"]=B.part1
end

-- stage4c00a.ecl：BossCardAttack07_00，0x22f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x22f8，40号。
        H.at(a,v,0)
        -- 源0x230c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2320，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2338，402号。
        H.gun_sprite(a,0,15,3)
        H.at(a,v,0)
        -- 源0x2354，436号。
        H.gun_count_diff(a,0,2,6,8,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0x2388，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x23a4，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x23c0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x23f0，409号。
        H.gun_transform(a,0,1,0,16,180,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2420，409号。
        H.gun_transform(a,0,2,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2450，409号。
        H.gun_transform(a,0,3,0,4096,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2480，409号。
        H.gun_transform(a,0,4,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x24b0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x24c4，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x24d8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x24e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2500，409号。
        H.gun_transform(a,0,5,1,8,240,-999999,0.009166666306555271,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2530，409号。
        H.gun_transform(a,0,6,0,4,120,-999999,0.008333333767950535,-999999.0)
        H.at(a,v,0)
        -- 源0x2560，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2578，409号。
        H.gun_transform(a,0,5,1,8,180,-999999,0.006666666828095913,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x25a8，409号。
        H.gun_transform(a,0,6,0,4,120,-999999,0.0005555555690079927,-999999.0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x25d8，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x25ec，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2600，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2618，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x2634，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2648，44号。
        H.push(v,3.5999999046325684)
        H.at(a,v,0)
        -- 源0x265c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x266c，44号。
        H.push(v,0.4000000059604645)
        H.at(a,v,0)
        -- 源0x2680，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2690，405号。
        H.gun_speed(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x26ac，401号。
        H.fire(a,0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x26c0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x26d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x26ec，10号。
        return
    end
    P["BossCardAttack07_00"]=B.part1
end

-- stage4c00a.ecl：BossCardAttack07_00b，0x270c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x270c，40号。
        H.at(a,v,0)
        -- 源0x2720，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x2734，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x274c，402号。
        H.gun_sprite(a,1,15,1)
        H.at(a,v,0)
        -- 源0x2768，436号。
        H.gun_count_diff(a,1,3,6,8,8,1,1,1,1)
        H.at(a,v,0)
        -- 源0x279c，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x27b8，405号。
        H.gun_speed(a,1,0.0,2.0)
        H.at(a,v,0)
        -- 源0x27d4，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2804，409号。
        H.gun_transform(a,1,1,0,16,180,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2834，409号。
        H.gun_transform(a,1,2,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2864，409号。
        H.gun_transform(a,1,3,0,4096,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2894，409号。
        H.gun_transform(a,1,4,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x28c4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x28d8，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x28ec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x28fc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2914，409号。
        H.gun_transform(a,1,5,1,8,240,-999999,0.009166666306555271,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2944，409号。
        H.gun_transform(a,1,6,0,4,120,-999999,0.008333333767950535,-999999.0)
        H.at(a,v,0)
        -- 源0x2974，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x298c，409号。
        H.gun_transform(a,1,5,1,8,180,-999999,0.006666666828095913,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x29bc，409号。
        H.gun_transform(a,1,6,0,4,120,-999999,0.0005555555690079927,-999999.0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x29ec，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2a00，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2a14，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2a2c，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x2a48，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2a5c，44号。
        H.push(v,3.5999999046325684)
        H.at(a,v,0)
        -- 源0x2a70，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2a80，44号。
        H.push(v,0.4000000059604645)
        H.at(a,v,0)
        -- 源0x2a94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2aa4，405号。
        H.gun_speed(a,1,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x2ac0，401号。
        H.fire(a,1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2ad4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2ae8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2b00，10号。
        return
    end
    P["BossCardAttack07_00b"]=B.part1
end

-- stage4c00b.ecl：BossCard2_00B，0x14c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14c，40号。
        H.at(a,v,0)
        -- 源0x160，331号。
        H.life(a,5700)
        H.at(a,v,0)
        -- 源0x174，334号。
        H.interrupt(a,0,4000,3000,"BossCard3_00B")
        H.at(a,v,0)
        -- 源0x1a4，347号。
        H.life_marker(a,0,5700.0,-8355585)
        H.at(a,v,0)
        -- 源0x1c0，347号。
        H.life_marker(a,1,4000.0,-12566273)
        H.at(a,v,0)
        -- 源0x1dc，347号。
        H.life_marker(a,2,1500.0,-16777024)
        H.at(a,v,0)
        -- 源0x1f8，357号。
        H.spell(a,58,3000,500000,"想起「戸隠山投げ」",357)
        H.at(a,v,0)
        -- 源0x22c，281号。
        H.position_time(a,0,60,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0x24c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x260，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x274，0号。
        H.at(a,v,60)
        -- 源0x284，324号。
        H.limit(a,0.0,128.0,280.0,64.0)
        H.at(a,v,60)
        -- 源0x2a4，355号。
        v.l[4]=H.int(20)
        H.at(a,v,60)
        -- 源0x2c8，12号。
        v.origin=H.clock(a)-(60);return B.part4(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x2e0，15号。
        H.async(a,P["BossCard2_00Bat"],"BossCard2_00Bat",nil)
        H.at(a,v,60)
        -- 源0x304，15号。
        H.async(a,P["BossCard2_00Bat2"],"BossCard2_00Bat2",nil)
        H.at(a,v,60)
        -- 源0x32c，15号。
        H.async(a,P["BossCard2_00Bat3"],"BossCard2_00Bat3",nil)
        H.at(a,v,60)
        -- 源0x354，368号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,60)
        -- 源0x374，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x38c，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x3a0，368号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,60)
        -- 源0x3c0，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x3d4，292号。
        H.wander(a,0,(v.l[4] or 0),0,2.0)
        H.at(a,v,60)
        -- 源0x3f0，83号。
        v.origin=v.origin+H.int((v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x404，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x418，42号。
        H.push(v,20)
        H.at(a,v,60)
        -- 源0x42c，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x43c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x454，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x468，42号。
        H.push(v,5)
        H.at(a,v,60)
        -- 源0x47c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,60)
        -- 源0x48c，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x4a0，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x4b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x4cc，10号。
        return
    end
    P["BossCard2_00B"]=B.part1
end

-- stage4c00b.ecl：BossCard2_00Bat，0x4ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4ec，40号。
        H.at(a,v,0)
        -- 源0x500，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x518，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x52c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x544，402号。
        H.gun_sprite(a,0,1,8)
        H.at(a,v,0)
        -- 源0x560，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x57c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x598，405号。
        H.gun_speed(a,0,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x5b4，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5e4，409号。
        H.gun_transform(a,0,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x614，409号。
        H.gun_transform(a,0,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0x644，355号。
        v.l[0]=H.int(40)
        H.at(a,v,0)
        -- 源0x668，355号。
        v.l[4]=H.int(50)
        H.at(a,v,0)
        -- 源0x68c，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6a4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x6b8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x6cc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x6dc，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x6fc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x710，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x724，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x734，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x748，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x75c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x770，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x784，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x794，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7a4，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7b8，439号。
        H.gun_absolute(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7d4，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x7e8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7fc，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x80c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x824，409号。
        H.gun_transform(a,0,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x854，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x86c，409号。
        H.gun_transform(a,0,2,0,33554432,40,4,(v.l[8] or 0),(v.l[12] or 0))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x89c，409号。
        H.gun_transform(a,0,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8cc，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x8e0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8f4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x904，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x91c，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x930，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x944，44号。
        H.push(v,1.5)
        H.at(a,v,0)
        -- 源0x958，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x968，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x978，42号。
        H.push(v,999)
        H.at(a,v,0)
        -- 源0x98c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9a0，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0x9b4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x9c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9d4，409号。
        H.gun_transform(a,0,5,0,67108864,-999999,-999999,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xa04，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xa1c，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0xa30，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xa44，44号。
        H.push(v,3.5)
        H.at(a,v,0)
        -- 源0xa58，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xa68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa78，42号。
        H.push(v,999)
        H.at(a,v,0)
        -- 源0xa8c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xaa0，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0xab4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xac4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xad4，409号。
        H.gun_transform(a,0,5,0,67108864,-999999,-999999,H.read(a,v,-1),H.read(a,v,-1))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xb04，438号。
        H.gun_distance(a,0,192.0)
        H.at(a,v,0)
        -- 源0xb1c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0xb38，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xb4c，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xb74，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xb88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb9c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0xbac，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xc0c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0xc20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xc38，10号。
        return
    end
    P["BossCard2_00Bat"]=B.part1
end

-- stage4c00b.ecl：BossCard2_00Bat2，0xc58；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc58，40号。
        H.at(a,v,0)
        -- 源0xc6c，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0xc84，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xc98，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0xcb0，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0xccc，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0xce8，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0xd04，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0xd20，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd50，409号。
        H.gun_transform(a,1,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd80，409号。
        H.gun_transform(a,1,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0xdb0，355号。
        v.l[0]=H.int(20)
        H.at(a,v,0)
        -- 源0xdd4，355号。
        v.l[4]=H.int(50)
        H.at(a,v,0)
        -- 源0xdf8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xe0c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe20，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe38，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xe4c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xe60，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xe70，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xe90，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xea4，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0xeb8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xec8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xedc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xef0，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0xf04，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xf18，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf28，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf38，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf4c，439号。
        H.gun_absolute(a,1,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xf68，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0xf7c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf90，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xfa0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfb8，409号。
        H.gun_transform(a,1,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xfe8，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1000，409号。
        H.gun_transform(a,1,2,0,33554432,40,4,(v.l[8] or 0),(v.l[12] or 0))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1030，409号。
        H.gun_transform(a,1,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1060，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1074，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1088，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1098，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x10b0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x10c4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x10d8，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x10ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x10fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x110c，409号。
        H.gun_transform(a,1,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x113c，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1154，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x1168，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x117c，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x1190，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x11a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x11b0，409号。
        H.gun_transform(a,1,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x11e0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x11f4，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0x1208，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1218，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1278，438号。
        H.gun_distance(a,1,160.0)
        H.at(a,v,0)
        -- 源0x1290，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x12ac，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x12c0，368号。
        v.origin=v.origin+H.int(2)
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
        -- 源0x13c4，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x13d8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x13ec，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x13fc，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1410，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1424，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x143c，10号。
        return
    end
    P["BossCard2_00Bat2"]=B.part1
end

-- stage4c00b.ecl：BossCard2_00Bat3，0x145c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x145c，40号。
        H.at(a,v,0)
        -- 源0x1470，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x1488，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x149c，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x14b4，402号。
        H.gun_sprite(a,2,12,4)
        H.at(a,v,0)
        -- 源0x14d0，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x14ec，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1508，405号。
        H.gun_speed(a,2,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x1524，409号。
        H.gun_transform(a,2,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1554，409号。
        H.gun_transform(a,2,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1584，409号。
        H.gun_transform(a,2,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0x15b4，355号。
        v.l[0]=H.int(80)
        H.at(a,v,0)
        -- 源0x15d8，355号。
        v.l[4]=H.int(50)
        H.at(a,v,0)
        -- 源0x15fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1610，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1624，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x163c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1650，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1664，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1674，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x1694，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x16a8，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x16bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x16cc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x16e0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x16f4，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x1708，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x171c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x172c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x173c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1750，439号。
        H.gun_absolute(a,2,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x176c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1780，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1794，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x17a4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x17bc，409号。
        H.gun_transform(a,2,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x17ec，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1804，409号。
        H.gun_transform(a,2,2,0,33554432,40,4,(v.l[8] or 0),(v.l[12] or 0))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1834，409号。
        H.gun_transform(a,2,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1864，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x1878，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x188c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x189c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x18b4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x18c8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x18dc，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x18f0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1900，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1910，409号。
        H.gun_transform(a,2,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1940，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1958，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x196c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1980，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x1994，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x19a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x19b4，409号。
        H.gun_transform(a,2,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x19e4，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x19f8，44号。
        H.push(v,0.07853999733924866)
        H.at(a,v,0)
        -- 源0x1a0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1a1c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1a7c，438号。
        H.gun_distance(a,2,160.0)
        H.at(a,v,0)
        -- 源0x1a94，404号。
        H.gun_angle(a,2,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1ab0，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x1ac4，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1aec，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1b00，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1b14，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x1b24，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1b84，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1b98，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1bb0，10号。
        return
    end
    P["BossCard2_00Bat3"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00B，0x1bd0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1bd0，40号。
        H.at(a,v,0)
        -- 源0x1be4，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x1bf8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1c08，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1c1c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1c30，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1c40，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1c58，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1c6c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1c84，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1c98，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1ca8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1cb8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1ccc，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x1cdc，334号。
        H.interrupt(a,0,1500,3000,"BossCard4_00B")
        H.at(a,v,0)
        -- 源0x1d0c，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x1d20，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1d34，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1d48，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d58，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1d70，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1d80，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1d94，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1da8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1db8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1dd0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1de4，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x1e08，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1e20，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1e30，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1e44，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1e58，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1e6c，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x1e80，357号。
        H.spell(a,62,3000,500000,"想起「百万鬼夜行」",357)
        H.at(a,v,60)
        -- 源0x1eb4，0号。
        H.at(a,v,60)
        -- 源0x1ec4，15号。
        H.async(a,P["BossCard3_00Bat"],"BossCard3_00Bat",nil)
        H.at(a,v,60)
        -- 源0x1ee8，15号。
        H.async(a,P["BossCard3_00Bat2"],"BossCard3_00Bat2",nil)
        H.at(a,v,60)
        -- 源0x1f10，15号。
        H.async(a,P["BossCard3_00Bat3"],"BossCard3_00Bat3",nil)
        H.at(a,v,60)
        -- 源0x1f38，15号。
        H.async(a,P["BossCard3_00Bat4"],"BossCard3_00Bat4",nil)
        H.at(a,v,60)
        -- 源0x1f60，15号。
        H.async(a,P["BossCard3_00Bat5"],"BossCard3_00Bat5",nil)
        H.at(a,v,60)
        -- 源0x1f88，15号。
        H.async(a,P["BossCard3_00Bat6"],"BossCard3_00Bat6",nil)
        H.at(a,v,60)
        -- 源0x1fb0，12号。
        v.origin=H.clock(a)-(160);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,160)
        -- 源0x1fc8，292号。
        H.wander(a,0,30,0,1.0)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,160)
        -- 源0x1fe4，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0x1ff8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,160)
        -- 源0x2010，10号。
        return
    end
    P["BossCard3_00B"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat，0x2030；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2030，40号。
        H.at(a,v,0)
        -- 源0x2044，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2058，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x206c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2080，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2098，402号。
        H.gun_sprite(a,0,19,3)
        H.at(a,v,0)
        -- 源0x20b4，406号。
        H.gun_count(a,0,3,1)
        H.at(a,v,0)
        -- 源0x20d0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x20ec，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x2108，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2138，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2150，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2164，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2178，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2188，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x21a4，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x21c0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x21d4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x21e8，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x21fc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x220c，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2228，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2244，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2258，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x226c，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2280，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2290，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x22ac，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x22c8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x22dc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x22f0，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2304，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2314，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2330，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x234c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2360，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2374，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2388，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2398，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x23b4，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x23d0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x23e4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x23f8，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x240c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x241c，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2438，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2454，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2468，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x247c，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0x2490，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x24a0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x24b4，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x24c8，83号。
        v.origin=v.origin+H.int(24)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x24dc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x24f0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2508，10号。
        return
    end
    P["BossCard3_00Bat"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat2，0x2528；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2528，40号。
        H.at(a,v,90)
        -- 源0x253c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,90)
        -- 源0x2550，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,90)
        -- 源0x2564，400号。
        H.gun_new(a,1)
        H.at(a,v,90)
        -- 源0x2578，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,90)
        -- 源0x2590，402号。
        H.gun_sprite(a,1,12,3)
        H.at(a,v,90)
        -- 源0x25ac，436号。
        H.gun_count_diff(a,1,16,32,32,32,1,1,1,1)
        H.at(a,v,90)
        -- 源0x25e0，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,90)
        -- 源0x25fc，405号。
        H.gun_speed(a,1,1.0,1.0)
        H.at(a,v,90)
        -- 源0x2618，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,90)
        -- 源0x2648，438号。
        H.gun_distance(a,1,32.0)
        H.at(a,v,90)
        -- 源0x2660，12号。
        v.origin=H.clock(a)-(90);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,90)
        -- 源0x2678，401号。
        H.fire(a,1)
        H.at(a,v,90)
        -- 源0x268c，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,90)
        -- 源0x26a0，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x26b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,90)
        -- 源0x26cc，10号。
        return
    end
    P["BossCard3_00Bat2"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat3，0x26ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x26ec，40号。
        H.at(a,v,0)
        -- 源0x2700，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2714，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2728，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x273c，407号。
        H.gun_aim(a,2,5)
        H.at(a,v,0)
        -- 源0x2754，402号。
        H.gun_sprite(a,2,3,6)
        H.at(a,v,0)
        -- 源0x2770，436号。
        H.gun_count_diff(a,2,8,32,32,32,1,1,1,1)
        H.at(a,v,0)
        -- 源0x27a4，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x27c0，405号。
        H.gun_speed(a,2,2.0,1.0)
        H.at(a,v,0)
        -- 源0x27dc，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x280c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2824，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x2838，83号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x284c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2860，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2878，10号。
        return
    end
    P["BossCard3_00Bat3"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat4，0x2898；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2898，40号。
        H.at(a,v,0)
        -- 源0x28ac，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x28c0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x28d4，400号。
        H.gun_new(a,3)
        H.at(a,v,0)
        -- 源0x28e8，407号。
        H.gun_aim(a,3,3)
        H.at(a,v,0)
        -- 源0x2900，402号。
        H.gun_sprite(a,3,19,1)
        H.at(a,v,0)
        -- 源0x291c，406号。
        H.gun_count(a,3,3,1)
        H.at(a,v,0)
        -- 源0x2938，404号。
        H.gun_angle(a,3,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2954，405号。
        H.gun_speed(a,3,2.0,1.0)
        H.at(a,v,0)
        -- 源0x2970，409号。
        H.gun_transform(a,3,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x29a0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x29b8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x29cc，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x29e0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x29f0，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2a0c，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2a28，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2a3c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2a50，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2a64，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2a74，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2a90，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2aac，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2ac0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2ad4，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2ae8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2af8，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2b14，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2b30，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2b44，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2b58，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2b6c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2b7c，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2b98，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2bb4，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2bc8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2bdc，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2bf0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2c00，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2c1c，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2c38，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2c4c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2c60，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x2c74，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2c84，437号。
        H.gun_polar(a,3,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2ca0，404号。
        H.gun_angle(a,3,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2cbc，401号。
        H.fire(a,3)
        H.at(a,v,0)
        -- 源0x2cd0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2ce4，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0x2cf8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2d08，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2d1c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x2d30，83号。
        v.origin=v.origin+H.int(24)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2d44，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d58，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2d70，10号。
        return
    end
    P["BossCard3_00Bat4"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat5，0x2d90；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2d90，40号。
        H.at(a,v,10)
        -- 源0x2da4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,10)
        -- 源0x2db8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,10)
        -- 源0x2dcc，400号。
        H.gun_new(a,4)
        H.at(a,v,10)
        -- 源0x2de0，407号。
        H.gun_aim(a,4,5)
        H.at(a,v,10)
        -- 源0x2df8，402号。
        H.gun_sprite(a,4,1,2)
        H.at(a,v,10)
        -- 源0x2e14，406号。
        H.gun_count(a,4,32,1)
        H.at(a,v,10)
        -- 源0x2e30，404号。
        H.gun_angle(a,4,0.0,0.0)
        H.at(a,v,10)
        -- 源0x2e4c，405号。
        H.gun_speed(a,4,2.0,1.0)
        H.at(a,v,10)
        -- 源0x2e68，409号。
        H.gun_transform(a,4,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,10)
        -- 源0x2e98，12号。
        v.origin=H.clock(a)-(10);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,10)
        -- 源0x2eb0，401号。
        H.fire(a,4)
        H.at(a,v,10)
        -- 源0x2ec4，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,10)
        -- 源0x2ed8，42号。
        H.push(v,1)
        H.at(a,v,10)
        -- 源0x2eec，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(10);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,10)
        -- 源0x2f04，10号。
        return
    end
    P["BossCard3_00Bat5"]=B.part1
end

-- stage4c00b.ecl：BossCard3_00Bat6，0x2f24；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2f24，40号。
        H.at(a,v,120)
        -- 源0x2f38，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,120)
        -- 源0x2f4c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x2f60，400号。
        H.gun_new(a,5)
        H.at(a,v,120)
        -- 源0x2f74，407号。
        H.gun_aim(a,5,2)
        H.at(a,v,120)
        -- 源0x2f8c，402号。
        H.gun_sprite(a,5,12,1)
        H.at(a,v,120)
        -- 源0x2fa8，406号。
        H.gun_count(a,5,32,1)
        H.at(a,v,120)
        -- 源0x2fc4，404号。
        H.gun_angle(a,5,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2fe0，405号。
        H.gun_speed(a,5,2.0,1.0)
        H.at(a,v,120)
        -- 源0x2ffc，409号。
        H.gun_transform(a,5,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,120)
        -- 源0x302c，409号。
        H.gun_transform(a,5,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,120)
        -- 源0x305c，12号。
        v.origin=H.clock(a)-(120);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,120)
        -- 源0x3074，401号。
        H.fire(a,5)
        H.at(a,v,120)
        -- 源0x3088，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,120)
        -- 源0x309c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x30b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,120)
        -- 源0x30c8，10号。
        return
    end
    P["BossCard3_00Bat6"]=B.part1
end

-- stage4c00b.ecl：BossCard4_00B，0x30e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x30e8，40号。
        H.at(a,v,0)
        -- 源0x30fc，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x3110，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x3120，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3134，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3148，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3158，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3170，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x3184，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x319c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x31b0，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x31c0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x31d0，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x31e4，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x31f4，334号。
        H.interrupt(a,0,0,4200,"BossDead")
        H.at(a,v,0)
        -- 源0x3220，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x3234，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3248，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x325c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x326c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3284，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x3294，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x32a8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x32bc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x32cc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x32e4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x32f8，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x331c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3334，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x3344，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x3358，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x336c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3380，281号。
        H.position_time(a,0,90,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x33a0，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x33b0，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x33c4，357号。
        H.spell(a,66,4200,500000,"想起「濛々迷霧」",357)
        H.at(a,v,0)
        -- 源0x33f8，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x340c，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x3420，263号。
        H.effect(a,2,19)
        H.at(a,v,60)
        -- 源0x3438，0号。
        H.at(a,v,60)
        -- 源0x3448，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x345c，276号。
        H.anm_reset(a)
        H.at(a,v,60)
        -- 源0x346c，259号。
        H.anm_slot(a,0,17)
        H.at(a,v,60)
        -- 源0x3484，259号。
        H.anm_slot(a,2,-1)
        H.at(a,v,60)
        -- 源0x349c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x34b0，15号。
        H.async(a,P["BossCard4_00Bat"],"BossCard4_00Bat",nil)
        H.at(a,v,60)
        -- 源0x34d4，356号。
        v.l[4]=H.f32(3.5999999046325684)
        H.at(a,v,60)
        -- 源0x34f8，12号。
        v.origin=H.clock(a)-(60);return B.part12(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x3510，285号。
        H.velocity_time(a,0,40,3,H.read(a,v,-9989),(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x3530，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,60)
        -- 源0x3544，285号。
        H.velocity_time(a,0,40,3,H.read(a,v,-9989),1.0)
        H.at(a,v,60)
        -- 源0x3564，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x3578，44号。
        H.push(v,3.5999999046325684)
        H.at(a,v,60)
        -- 源0x358c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x359c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x35b4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x35c8，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,60)
        -- 源0x35dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x35ec，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x3600，83号。
        v.origin=v.origin+H.int(40)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x3614，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x3628，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x3640，10号。
        return
    end
    P["BossCard4_00B"]=B.part1
end

-- stage4c00b.ecl：BossCard4_00Bat，0x3660；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3660，40号。
        H.at(a,v,0)
        -- 源0x3674，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3688，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x36a0，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x36bc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x36d8，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.09817477315664291)
        H.at(a,v,0)
        -- 源0x36f4，405号。
        H.gun_speed(a,0,0.05000000074505806,2.0)
        H.at(a,v,0)
        -- 源0x3710，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3740，355号。
        v.l[0]=H.int(1300)
        H.at(a,v,0)
        -- 源0x3764，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[0] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3794，409号。
        H.gun_transform(a,0,2,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x37c4，405号。
        H.gun_speed(a,0,0.20000000298023224,0.0)
        H.at(a,v,0)
        -- 源0x37e0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x37f8，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x3814，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3828，44号。
        H.push(v,64.0)
        H.at(a,v,0)
        -- 源0x383c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x384c，437号。
        H.gun_polar(a,0,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3868，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x387c，368号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x389c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x38b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x38c8，10号。
        return
    end
    P["BossCard4_00Bat"]=B.part1
end

-- stage4c00c.ecl：BossCard2_00C，0x10c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10c，40号。
        H.at(a,v,0)
        -- 源0x120，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x134，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x148，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x158，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x170，331号。
        H.life(a,6300)
        H.at(a,v,0)
        -- 源0x184，334号。
        H.interrupt(a,0,4400,3000,"BossCard3_00C")
        H.at(a,v,0)
        -- 源0x1b4，347号。
        H.life_marker(a,0,6300.0,-8355585)
        H.at(a,v,0)
        -- 源0x1d0，347号。
        H.life_marker(a,1,4400.0,-12566273)
        H.at(a,v,0)
        -- 源0x1ec，347号。
        H.life_marker(a,2,2500.0,-16777024)
        H.at(a,v,0)
        -- 源0x208，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x220，331号。
        H.life(a,7000)
        H.at(a,v,0)
        -- 源0x234，334号。
        H.interrupt(a,0,5100,3000,"BossCard3_00C")
        H.at(a,v,0)
        -- 源0x264，347号。
        H.life_marker(a,0,7000.0,-8355585)
        H.at(a,v,0)
        -- 源0x280，347号。
        H.life_marker(a,1,5100.0,-12566273)
        H.at(a,v,0)
        -- 源0x29c，347号。
        H.life_marker(a,2,3200.0,-16777024)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2b8，357号。
        H.spell(a,70,3000,500000,"想起「風神木の葉隠れ」",357)
        H.at(a,v,0)
        -- 源0x2f0，281号。
        H.position_time(a,0,60,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0x310，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x324，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x338，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x34c，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x360，0号。
        H.at(a,v,60)
        -- 源0x370，355号。
        v.l[8]=H.int(16)
        H.at(a,v,60)
        -- 源0x394，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0x3a8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,60)
        -- 源0x3c0，402号。
        H.gun_sprite(a,0,3,10)
        H.at(a,v,60)
        -- 源0x3dc，406号。
        H.gun_count(a,0,(v.l[8] or 0),1)
        H.at(a,v,60)
        -- 源0x3f8，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.13089969754219055)
        H.at(a,v,60)
        -- 源0x414，405号。
        H.gun_speed(a,0,6.0,1.0)
        H.at(a,v,60)
        -- 源0x430，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x460，409号。
        H.gun_transform(a,0,1,0,8,120,-999999,-0.02500000037252903,0.05235987901687622)
        H.at(a,v,60)
        -- 源0x490，409号。
        H.gun_transform(a,0,2,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x4c0，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,60)
        -- 源0x4d8，409号。
        H.gun_transform(a,1,1,0,8,120,-999999,-0.02500000037252903,-0.06283185631036758)
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x524，402号。
        H.gun_sprite(a,1,3,8)
        H.at(a,v,60)
        -- 源0x540，402号。
        H.gun_sprite(a,1,3,6)
        H.at(a,v,60)
        -- 源0x55c，12号。
        v.origin=H.clock(a)-(124);return B.part12(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x574，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,60)
        -- 源0x590，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,60)
        -- 源0x5ac，42号。
        H.push(v,30)
        H.at(a,v,60)
        -- 源0x5c0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x5d4，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x5e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0x5fc，12号。
        v.origin=H.clock(a)-(64);return B.part10(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x614，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,60)
        -- 源0x628，42号。
        H.push(v,3)
        H.at(a,v,60)
        -- 源0x63c，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x64c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x664，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,60)
        -- 源0x678，42号。
        H.push(v,60)
        H.at(a,v,60)
        -- 源0x68c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x69c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x6b0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x6c4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x6d4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x6e4，409号。
        H.gun_transform(a,0,1,0,8,120,-999999,-0.03750000149011612,H.read(a,v,-1))
        H.at(a,v,60)
        -- 源0x714，44号。
        H.push(v,-3.1415927410125732)
        H.at(a,v,60)
        -- 源0x728，42号。
        H.push(v,60)
        H.at(a,v,60)
        -- 源0x73c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x74c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x760，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x774，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x784，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x794，409号。
        H.gun_transform(a,1,1,0,8,120,-999999,-0.03750000149011612,H.read(a,v,-1))
        H.at(a,v,60)
        -- 源0x7c4，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x7dc，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,60)
        -- 源0x7f0，42号。
        H.push(v,60)
        H.at(a,v,60)
        -- 源0x804，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x814，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x828，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x83c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x84c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x85c，409号。
        H.gun_transform(a,0,1,0,8,120,-999999,-0.02916666679084301,H.read(a,v,-1))
        H.at(a,v,60)
        -- 源0x88c，44号。
        H.push(v,-3.1415927410125732)
        H.at(a,v,60)
        -- 源0x8a0，42号。
        H.push(v,60)
        H.at(a,v,60)
        -- 源0x8b4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x8c4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x8d8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x8ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x8fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x90c，409号。
        H.gun_transform(a,1,1,0,8,120,-999999,-0.02916666679084301,H.read(a,v,-1))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x93c，401号。
        H.fire(a,0)
        H.at(a,v,60)
        -- 源0x950，401号。
        H.fire(a,1)
        H.at(a,v,64)
        -- 源0x964，0号。
        H.at(a,v,64)
        -- 源0x974，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,64)
        -- 源0x988，44号。
        H.push(v,1.9999999494757503e-05)
        H.at(a,v,64)
        -- 源0x99c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,64)
        -- 源0x9ac，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,64)
        H.at(a,v,64)
        H.at(a,v,64)
        H.at(a,v,64)
        H.at(a,v,64)
        -- 源0xa0c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,64)
        -- 源0xa20，44号。
        H.push(v,9.999999747378752e-06)
        H.at(a,v,64)
        -- 源0xa34，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,64)
        -- 源0xa44，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,64)
        -- 源0xa58，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,64)
        -- 源0xa6c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,124)
        -- 源0xa84，336号。
        H.sound(a,41)
        H.at(a,v,124)
        H.at(a,v,124)
        -- 源0xaac，83号。
        v.origin=v.origin+H.int(40)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,124)
        -- 源0xac0，42号。
        H.push(v,1)
        H.at(a,v,124)
        -- 源0xad4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part5(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,124)
        -- 源0xaec，10号。
        return
    end
    P["BossCard2_00C"]=B.part1
end

-- stage4c00c.ecl：BossCard2_00Cat，0xb0c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb0c，40号。
        H.at(a,v,0)
        -- 源0xb20，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0xb38，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xb4c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xb64，402号。
        H.gun_sprite(a,0,1,8)
        H.at(a,v,0)
        -- 源0xb80，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xb9c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xbb8，405号。
        H.gun_speed(a,0,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0xbd4，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc04，409号。
        H.gun_transform(a,0,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc34，409号。
        H.gun_transform(a,0,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0xc64，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0xc78，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xc8c，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0xca0，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xcb4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xccc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xce0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xcf4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xd04，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xd24，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xd38，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0xd4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd5c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd70，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xd84，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0xd98，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xdac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xdbc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdcc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xde0，439号。
        H.gun_absolute(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xdfc，409号。
        H.gun_transform(a,0,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe2c，409号。
        H.gun_transform(a,0,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe5c，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0xe70，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0xe84，44号。
        H.push(v,3.5)
        H.at(a,v,0)
        -- 源0xe98，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xea8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xeb8，42号。
        H.push(v,999)
        H.at(a,v,0)
        -- 源0xecc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xee0，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0xef4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xf04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf14，409号。
        H.gun_transform(a,0,5,0,67108864,-999999,-999999,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xf44，438号。
        H.gun_distance(a,0,192.0)
        H.at(a,v,0)
        -- 源0xf5c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0xf78，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xf8c，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0xfa0，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xfb4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfc8，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0xfd8，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfec，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1000，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1018，10号。
        return
    end
    P["BossCard2_00Cat"]=B.part1
end

-- stage4c00c.ecl：BossCard2_00Cat2，0x1038；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1038，40号。
        H.at(a,v,0)
        -- 源0x104c，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x1064，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x1078，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x1090，402号。
        H.gun_sprite(a,1,17,1)
        H.at(a,v,0)
        -- 源0x10ac，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x10c8，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x10e4，405号。
        H.gun_speed(a,1,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x1100，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1130，409号。
        H.gun_transform(a,1,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1160，409号。
        H.gun_transform(a,1,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1190，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x11a4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x11b8，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x11cc，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x11e0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x11f4，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1208，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1220，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1234，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1248，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1258，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x1278，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x128c，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x12a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12b0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12c4，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x12d8，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x12ec，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x1300，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1310，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1320，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1334，439号。
        H.gun_absolute(a,1,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1350，409号。
        H.gun_transform(a,1,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1380，409号。
        H.gun_transform(a,1,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x13b0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x13c4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x13d8，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x13ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x13fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x140c，409号。
        H.gun_transform(a,1,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x143c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1450，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,0)
        -- 源0x1464，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1474，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1488，438号。
        H.gun_distance(a,1,160.0)
        H.at(a,v,0)
        -- 源0x14a0，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x14bc，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x14d0，83号。
        v.origin=v.origin+H.int(4)
        H.at(a,v,0)
        -- 源0x14e4，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x14f8，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x150c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x151c，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1530，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1544，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x155c，10号。
        return
    end
    P["BossCard2_00Cat2"]=B.part1
end

-- stage4c00c.ecl：BossCard2_00Cat3，0x157c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x157c，40号。
        H.at(a,v,0)
        -- 源0x1590，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x15a8，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x15bc，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x15d4，402号。
        H.gun_sprite(a,2,12,4)
        H.at(a,v,0)
        -- 源0x15f0，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x160c，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1628，405号。
        H.gun_speed(a,2,1.600000023841858,1.0)
        H.at(a,v,0)
        -- 源0x1644，409号。
        H.gun_transform(a,2,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1674，409号。
        H.gun_transform(a,2,1,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x16a4，409号。
        H.gun_transform(a,2,3,0,67108864,-999999,-999999,0.0,0.0)
        H.at(a,v,0)
        -- 源0x16d4，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x16e8，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x16fc，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x1710，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1724，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1738，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x174c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1764，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1778，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x178c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x179c，81号。
        do local r=H.read(a,v,-1);local angle=H.read(a,v,-9998);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x17bc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x17d0，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x17e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x17f4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1808，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x181c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x1830，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x1844，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1854，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1864，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1878，439号。
        H.gun_absolute(a,2,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1894，409号。
        H.gun_transform(a,2,2,0,33554432,60,4,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x18c4，409号。
        H.gun_transform(a,2,4,0,4096,(v.l[4] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x18f4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x1908，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x191c，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x1930，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1940，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1950，409号。
        H.gun_transform(a,2,5,0,67108864,-999999,-999999,(v.l[16] or 0),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1980，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1994，44号。
        H.push(v,0.07853999733924866)
        H.at(a,v,0)
        -- 源0x19a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x19b8，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x19cc，438号。
        H.gun_distance(a,2,160.0)
        H.at(a,v,0)
        -- 源0x19e4，404号。
        H.gun_angle(a,2,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1a00，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x1a14，83号。
        v.origin=v.origin+H.int(1)
        H.at(a,v,0)
        -- 源0x1a28，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1a3c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a50，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x1a60，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1a74，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1a88，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1aa0，10号。
        return
    end
    P["BossCard2_00Cat3"]=B.part1
end

-- stage4c00c.ecl：BossCard3_00C，0x1ac0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1ac0，40号。
        H.at(a,v,0)
        -- 源0x1ad4，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x1ae8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1af8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1b0c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1b20，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1b30，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1b48，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1b5c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1b74，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1b88，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1b98，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1ba8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1bbc，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1bfc，334号。
        H.interrupt(a,0,3200,3000,"BossCard4_00C")
        H.at(a,v,0)
        -- 源0x1c2c，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x1c40，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1c54，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1c68，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1c78，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1c90，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1ca0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1cb4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1cc8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1cd8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1cf0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1d04，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x1d28，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1d40，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1d50，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1d64，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1d78，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1d8c，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x1da0，357号。
        H.spell(a,74,3000,500000,"想起「天狗のマクロバースト」",357)
        H.at(a,v,0)
        -- 源0x1de0，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x1df4，0号。
        H.at(a,v,60)
        -- 源0x1e04，15号。
        H.async(a,P["BossCard3_00Cat2"],"BossCard3_00Cat2",nil)
        H.at(a,v,60)
        -- 源0x1e2c，12号。
        v.origin=H.clock(a)-(160);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,160)
        -- 源0x1e44，292号。
        H.wander(a,0,60,0,1.0)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,160)
        -- 源0x1e60，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0x1e74，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,160)
        -- 源0x1e8c，10号。
        return
    end
    P["BossCard3_00C"]=B.part1
end

-- stage4c00c.ecl：BossCard3_00Cat，0x1eac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1eac，40号。
        H.at(a,v,0)
        -- 源0x1ec0，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x1ed4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1ee8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1f00，402号。
        H.gun_sprite(a,0,7,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x1f1c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x1f38，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1f54，405号。
        H.gun_speed(a,0,H.read(a,v,-9980),1.0)
        H.at(a,v,0)
        -- 源0x1f70，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fa0，409号。
        H.gun_transform(a,0,1,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fd0，409号。
        H.gun_transform(a,0,2,0,256,16,12,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2000，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x2014，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2028，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2044，403号。
        H.gun_offset(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2060，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2074，83号。
        v.origin=v.origin+H.int(3)
        H.at(a,v,0)
        -- 源0x2088，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x209c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x20b0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x20c0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x20d4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x20e8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x20fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x210c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2120，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2134，82号。
        v.l[16]=H.f32(H.angle((v.l[16] or 0)))
        H.at(a,v,0)
        -- 源0x2148，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x215c，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2170，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x2184，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2198，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x21ac，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x21c0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x21d8，81号。
        do local r=(v.l[20] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x21f8，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2214，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2228，81号。
        do local r=(v.l[20] or 0);local angle=(v.l[16] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2248，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x2264，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2278，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x228c，44号。
        H.push(v,0.699999988079071)
        H.at(a,v,0)
        -- 源0x22a0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x22b0，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x22c4，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x22d8，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x22ec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x22fc，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2310，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2324，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2338，78号。
        H.push(v,(v.l[28] or 0))
        v.l[28]=H.int((v.l[28] or 0)-1)
        H.at(a,v,0)
        -- 源0x234c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2364，1号。
        H.erase(a);return
    end
    P["BossCard3_00Cat"]=B.part1
end

-- stage4c00c.ecl：BossCard3_00Cat2，0x2394；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2394，40号。
        H.at(a,v,0)
        -- 源0x23a8，356号。
        H.write(a,-9980,H.f32(5.0))
        H.at(a,v,0)
        -- 源0x23cc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x23e4，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x23f8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x240c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2420，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2430，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2440，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2454，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2468，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x247c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2490，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x24a0，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x24b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x24c4，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x24d8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x24e8，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-1),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x2520，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x2540，44号。
        H.push(v,2.356194496154785)
        H.at(a,v,0)
        -- 源0x2554，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2568，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x257c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x258c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x259c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x25b0，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x25c4，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x25d8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x25ec，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x2600，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2610，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x2624，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2634，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-1),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x266c，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x268c，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x26a0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x26b4，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x26c8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x26d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x26e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x26fc，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2710，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2724，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2738，85号。
        H.push(v,-H.pop(v))
        H.at(a,v,0)
        -- 源0x2748，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x275c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x276c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2780，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2790，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-1),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x27c8，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x27e8，44号。
        H.push(v,2.356194496154785)
        H.at(a,v,0)
        -- 源0x27fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2810，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2824，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2834，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2844，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2858，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x286c，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2880，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2894，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x28a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x28b8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x28cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x28dc，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-1),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x2914，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x2934，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x2948，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x295c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2970，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2980，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2990，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x29a4，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x29b8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x29cc，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-9965),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x2a04，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x2a24，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2a38，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2a4c，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x2a60，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2a70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2a80，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2a94，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2aa8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2abc，257号。
        H.spawn(a,257,"BossCard3_00Cat",H.read(a,v,-9965),-64.0,200,1000,0)
        H.at(a,v,0)
        -- 源0x2af4，368号。
        v.origin=v.origin+H.int(15)
        H.at(a,v,0)
        -- 源0x2b14，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x2b28，44号。
        H.push(v,6.0)
        H.at(a,v,0)
        -- 源0x2b3c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b4c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2b64，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x2b78，44号。
        H.push(v,0.25)
        H.at(a,v,0)
        -- 源0x2b8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2b9c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2bb0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2bc4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2bdc，10号。
        return
    end
    P["BossCard3_00Cat2"]=B.part1
end

-- stage4c00c.ecl：BossCard4_00C，0x2bfc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2bfc，40号。
        H.at(a,v,0)
        -- 源0x2c10，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x2c24，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2c34，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2c48，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2c5c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2c6c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2c84，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2c98，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2cb0，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2cc4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2cd8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2cec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2cfc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2d14，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x2d48，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2d60，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2d98，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2da8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2db8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x2dcc，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x2ddc，334号。
        H.interrupt(a,0,0,4200,"BossDead")
        H.at(a,v,0)
        -- 源0x2e08，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x2e1c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2e30，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2e44，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2e54，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2e6c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2e7c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2e90，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2ea4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2eb4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x2ecc，330号。
        H.drop_main(a,5)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x2ee0，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x2f04，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2f1c，329号。
        H.drop(a)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x2f2c，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2f40，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2f54，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2f68，281号。
        H.position_time(a,0,90,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x2f88，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x2f98，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2fac，357号。
        H.spell(a,78,4200,500000,"想起「鳥居つむじ風」",357)
        H.at(a,v,0)
        -- 源0x2fe4，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x2ff8，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x300c，0号。
        H.at(a,v,60)
        -- 源0x301c，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x3030，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x3044，44号。
        H.push(v,2.0)
        H.at(a,v,60)
        -- 源0x3058，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0x306c，15号。
        H.async(a,P["BossCard4_00Cat"],"BossCard4_00Cat",nil,96,0)
        H.at(a,v,60)
        -- 源0x30a0，15号。
        H.async(a,P["BossCard4_00Cat2"],"BossCard4_00Cat2",nil,-96,0)
        H.at(a,v,60)
        -- 源0x30d8，292号。
        H.wander(a,0,40,0,1.0)
        H.at(a,v,60)
        -- 源0x30f4，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x3114，15号。
        H.async(a,P["BossCard4_00Cat2"],"BossCard4_00Cat2",nil,64,0)
        H.at(a,v,60)
        -- 源0x314c，15号。
        H.async(a,P["BossCard4_00Cat"],"BossCard4_00Cat",nil,-64,0)
        H.at(a,v,60)
        -- 源0x3180，292号。
        H.wander(a,0,40,0,1.0)
        H.at(a,v,60)
        -- 源0x319c，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x31bc，12号。
        v.origin=H.clock(a)-(60);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x31d4，42号。
        H.push(v,112)
        H.at(a,v,60)
        -- 源0x31e8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0x31fc，42号。
        H.push(v,56)
        H.at(a,v,60)
        -- 源0x3210，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x3220，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x3230，15号。
        H.async(a,P["BossCard4_00Cat"],"BossCard4_00Cat",nil,H.read(a,v,-1),0)
        H.at(a,v,60)
        -- 源0x3264，42号。
        H.push(v,-112)
        H.at(a,v,60)
        -- 源0x3278，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0x328c，42号。
        H.push(v,56)
        H.at(a,v,60)
        -- 源0x32a0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x32b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x32c0，15号。
        H.async(a,P["BossCard4_00Cat2"],"BossCard4_00Cat2",nil,H.read(a,v,-1),0)
        H.at(a,v,60)
        -- 源0x32f8，292号。
        H.wander(a,0,40,0,1.0)
        H.at(a,v,60)
        -- 源0x3314，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x3334，42号。
        H.push(v,64)
        H.at(a,v,60)
        -- 源0x3348，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0x335c，42号。
        H.push(v,56)
        H.at(a,v,60)
        -- 源0x3370，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x3380，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x3390，15号。
        H.async(a,P["BossCard4_00Cat2"],"BossCard4_00Cat2",nil,H.read(a,v,-1),0)
        H.at(a,v,60)
        -- 源0x33c8，42号。
        H.push(v,-64)
        H.at(a,v,60)
        -- 源0x33dc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0x33f0，42号。
        H.push(v,56)
        H.at(a,v,60)
        -- 源0x3404，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0x3414，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x3424，15号。
        H.async(a,P["BossCard4_00Cat"],"BossCard4_00Cat",nil,H.read(a,v,-1),0)
        H.at(a,v,60)
        -- 源0x3458，292号。
        H.wander(a,0,40,0,1.0)
        H.at(a,v,60)
        -- 源0x3474，368号。
        v.origin=v.origin+H.int(60)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x3494，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x34a8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x34c0，10号。
        return
    end
    P["BossCard4_00C"]=B.part1
end

-- stage4c00c.ecl：BossCard4_00Cat，0x34e0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x34e0，40号。
        H.at(a,v,0)
        -- 源0x34f4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3508，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x3520，402号。
        H.gun_sprite(a,0,7,6)
        H.at(a,v,0)
        -- 源0x353c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x3558，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.09817477315664291)
        H.at(a,v,0)
        -- 源0x3574，405号。
        H.gun_speed(a,0,1.0,2.0)
        H.at(a,v,0)
        -- 源0x3590，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x35c0，409号。
        H.gun_transform(a,0,1,0,1024,200,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x35f0，409号。
        H.gun_transform(a,0,2,1,8,6000,-999999,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x3620，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x3634，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3648，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3658，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3670，409号。
        H.gun_transform(a,0,3,1,134217728,6000,-999999,1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0x36a0，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x36b8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x36cc，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x36e0，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x36f0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3708，409号。
        H.gun_transform(a,0,3,1,134217728,6000,-999999,1.5707963705062866,1.399999976158142)
        H.at(a,v,0)
        -- 源0x3738，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3750，409号。
        H.gun_transform(a,0,3,1,134217728,6000,-999999,1.5707963705062866,2.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3780，439号。
        H.gun_absolute(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x379c，403号。
        H.gun_offset(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x37b8，355号。
        v.l[20]=H.int(90)
        H.at(a,v,0)
        -- 源0x37dc，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x37f0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3804，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3818，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x382c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3840，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3854，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x386c，404号。
        H.gun_angle(a,0,(v.l[16] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3888，405号。
        H.gun_speed(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x38a4，409号。
        H.gun_transform(a,0,2,1,8,6000,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x38d4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x38e8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x38fc，44号。
        H.push(v,3.8832221031188965)
        H.at(a,v,0)
        -- 源0x3910，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3920，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3934，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3948，44号。
        H.push(v,0.9929999709129333)
        H.at(a,v,0)
        -- 源0x395c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x396c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3980，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3994，44号。
        H.push(v,0.012000000104308128)
        H.at(a,v,0)
        -- 源0x39a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x39b8，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x39cc，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x39e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x39f8，10号。
        return
    end
    P["BossCard4_00Cat"]=B.part1
end

-- stage4c00c.ecl：BossCard4_00Cat2，0x3a18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3a18，40号。
        H.at(a,v,0)
        -- 源0x3a2c，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x3a40，407号。
        H.gun_aim(a,1,5)
        H.at(a,v,0)
        -- 源0x3a58，402号。
        H.gun_sprite(a,1,7,6)
        H.at(a,v,0)
        -- 源0x3a74，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x3a90，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.09817477315664291)
        H.at(a,v,0)
        -- 源0x3aac，405号。
        H.gun_speed(a,1,1.0,2.0)
        H.at(a,v,0)
        -- 源0x3ac8，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3af8，409号。
        H.gun_transform(a,1,1,0,1024,200,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3b28，409号。
        H.gun_transform(a,1,2,1,8,6000,-999999,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x3b58，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x3b6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3b80，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3b90，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3ba8，409号。
        H.gun_transform(a,1,3,1,134217728,6000,-999999,1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0x3bd8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3bf0，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x3c04，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x3c18，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3c28，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3c40，409号。
        H.gun_transform(a,1,3,1,134217728,6000,-999999,1.5707963705062866,1.399999976158142)
        H.at(a,v,0)
        -- 源0x3c70，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3c88，409号。
        H.gun_transform(a,1,3,1,134217728,6000,-999999,1.5707963705062866,2.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3cb8，439号。
        H.gun_absolute(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3cd4，403号。
        H.gun_offset(a,1,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3cf0，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x3d04，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d18，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,0)
        -- 源0x3d2c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d40，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3d54，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d68，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3d7c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d90，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3da8，404号。
        H.gun_angle(a,1,(v.l[16] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3dc4，405号。
        H.gun_speed(a,1,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3de0，409号。
        H.gun_transform(a,1,2,1,8,6000,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3e10，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x3e24，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x3e38，44号。
        H.push(v,3.8832221031188965)
        H.at(a,v,0)
        -- 源0x3e4c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3e5c，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e70，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3e84，44号。
        H.push(v,0.9929999709129333)
        H.at(a,v,0)
        -- 源0x3e98，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3ea8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3ebc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3ed0，44号。
        H.push(v,0.012000000104308128)
        H.at(a,v,0)
        -- 源0x3ee4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3ef4，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x3f08，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x3f1c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x3f34，10号。
        return
    end
    P["BossCard4_00Cat2"]=B.part1
end

-- stage4c01a.ecl：BossCard2_01A，0x174；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x174，40号。
        H.at(a,v,0)
        -- 源0x188，331号。
        H.life(a,5800)
        H.at(a,v,0)
        -- 源0x19c，334号。
        H.interrupt(a,0,3600,3000,"BossCard3_01A")
        H.at(a,v,0)
        -- 源0x1cc，347号。
        H.life_marker(a,0,5800.0,-8355585)
        H.at(a,v,0)
        -- 源0x1e8，347号。
        H.life_marker(a,1,3600.0,-12566273)
        H.at(a,v,0)
        -- 源0x204，347号。
        H.life_marker(a,2,2000.0,-16777024)
        H.at(a,v,0)
        -- 源0x220，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x234，357号。
        H.spell(a,82,3000,500000,"想起「春の京人形」",357)
        H.at(a,v,0)
        -- 源0x268，281号。
        H.position_time(a,0,60,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0x288，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x29c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2b0，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x2c4，0号。
        H.at(a,v,60)
        -- 源0x2d4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x2e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x2fc，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,60)
        -- 源0x310，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x324，355号。
        v.l[12]=H.int(16)
        H.at(a,v,60)
        -- 源0x348，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,60)
        -- 源0x35c，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x370，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x380，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0x394，12号。
        v.origin=H.clock(a)-(60);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x3ac，257号。
        H.spawn(a,257,"BossCard2_01Aat",0.0,0.0,1000,1000,0)
        H.at(a,v,60)
        -- 源0x3e4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x3f8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x40c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x41c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x430，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x444，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,60)
        -- 源0x458，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x470，12号。
        v.origin=H.clock(a)-(60);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x488，83号。
        v.origin=v.origin+H.int(220)
        H.at(a,v,60)
        -- 源0x49c，292号。
        H.wander(a,0,60,4,2.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x4b8，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x4cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x4e4，10号。
        return
    end
    P["BossCard2_01A"]=B.part1
end

-- stage4c01a.ecl：BossCard2_01Aat，0x504；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x504，40号。
        H.at(a,v,0)
        -- 源0x518，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x52c，259号。
        H.anm_slot(a,0,103)
        H.at(a,v,0)
        -- 源0x544，322号。
        H.flags(a,15,true)
        H.at(a,v,0)
        -- 源0x558，15号。
        H.async(a,P["BossCard2_01Amove"],"BossCard2_01Amove",nil)
        H.at(a,v,0)
        -- 源0x580，288号。
        H.circle(a,0,H.read(a,v,-9981),H.read(a,v,-9980),0.0,1.5)
        H.at(a,v,90)
        -- 源0x5a0，288号。
        H.circle(a,0,-999999.0,-999999.0,120.0,0.0)
        H.at(a,v,90)
        -- 源0x5c0，15号。
        H.async(a,P["BossCard2_01Amove2"],"BossCard2_01Amove2",nil)
        H.at(a,v,90)
        -- 源0x5e8，44号。
        H.push(v,H.read(a,v,-9971))
        H.at(a,v,90)
        -- 源0x5fc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0x610，356号。
        v.l[8]=H.f32(1.5)
        H.at(a,v,90)
        -- 源0x634，12号。
        v.origin=H.clock(a)-(90);return B.part15(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,90)
        -- 源0x64c，400号。
        H.gun_new(a,0)
        H.at(a,v,90)
        -- 源0x660，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,90)
        -- 源0x678，402号。
        H.gun_sprite(a,0,3,10)
        H.at(a,v,90)
        -- 源0x694，406号。
        H.gun_count(a,0,2,1)
        H.at(a,v,90)
        -- 源0x6b0，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,90)
        -- 源0x6cc，405号。
        H.gun_speed(a,0,(v.l[8] or 0),1.0)
        H.at(a,v,90)
        -- 源0x6e8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,90)
        -- 源0x718，409号。
        H.gun_transform(a,0,1,0,-2147483648,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,90)
        -- 源0x748，42号。
        H.push(v,20)
        H.at(a,v,90)
        -- 源0x75c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0x770，12号。
        v.origin=H.clock(a)-(90);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,90)
        -- 源0x788，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,90)
        -- 源0x7a4，405号。
        H.gun_speed(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,90)
        -- 源0x7c0，401号。
        H.fire(a,0)
        H.at(a,v,90)
        -- 源0x7d4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,90)
        -- 源0x7e8，44号。
        H.push(v,0.16534699499607086)
        H.at(a,v,90)
        -- 源0x7fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x80c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0x820，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,90)
        -- 源0x834，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,90)
        -- 源0x848，44号。
        H.push(v,0.05000000074505806)
        H.at(a,v,90)
        -- 源0x85c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x86c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0x880，83号。
        v.origin=v.origin+H.int(10)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,90)
        -- 源0x894，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,90)
        -- 源0x8a8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,90)
        -- 源0x8c0，409号。
        H.gun_transform(a,0,1,0,8,30,-999999,0.0,-0.05235987901687622)
        H.at(a,v,90)
        -- 源0x8f0，42号。
        H.push(v,20)
        H.at(a,v,90)
        -- 源0x904，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0x918，12号。
        v.origin=H.clock(a)-(90);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,90)
        -- 源0x930，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,90)
        -- 源0x94c，405号。
        H.gun_speed(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,90)
        -- 源0x968，401号。
        H.fire(a,0)
        H.at(a,v,90)
        -- 源0x97c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,90)
        -- 源0x990，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,90)
        -- 源0x9a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x9b4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0x9c8，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,90)
        -- 源0x9dc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,90)
        -- 源0x9f0，44号。
        H.push(v,0.05000000074505806)
        H.at(a,v,90)
        -- 源0xa04，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,90)
        -- 源0xa14，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0xa28，83号。
        v.origin=v.origin+H.int(10)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,90)
        -- 源0xa3c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,90)
        -- 源0xa50，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,90)
        -- 源0xa68，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,90)
        -- 源0xa7c，409号。
        H.gun_transform(a,0,1,0,8,30,-999999,0.0,0.05235987901687622)
        H.at(a,v,90)
        -- 源0xaac，42号。
        H.push(v,20)
        H.at(a,v,90)
        -- 源0xac0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0xad4，12号。
        v.origin=H.clock(a)-(90);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0xaec，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,90)
        -- 源0xb08，405号。
        H.gun_speed(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,90)
        -- 源0xb24，401号。
        H.fire(a,0)
        H.at(a,v,90)
        -- 源0xb38，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,90)
        -- 源0xb4c，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,90)
        -- 源0xb60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0xb70，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0xb84，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,90)
        -- 源0xb98，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,90)
        -- 源0xbac，44号。
        H.push(v,0.05000000074505806)
        H.at(a,v,90)
        -- 源0xbc0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0xbd0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0xbe4，83号。
        v.origin=v.origin+H.int(9)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0xbf8，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,90)
        -- 源0xc0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0xc24，409号。
        H.gun_transform(a,0,1,0,8,30,-999999,0.0,-0.05235987901687622)
        H.at(a,v,90)
        -- 源0xc54，42号。
        H.push(v,20)
        H.at(a,v,90)
        -- 源0xc68，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0xc7c，12号。
        v.origin=H.clock(a)-(90);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,90)
        -- 源0xc94，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,90)
        -- 源0xcb0，405号。
        H.gun_speed(a,0,(v.l[8] or 0),0.0)
        H.at(a,v,90)
        -- 源0xccc，401号。
        H.fire(a,0)
        H.at(a,v,90)
        -- 源0xce0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,90)
        -- 源0xcf4，44号。
        H.push(v,0.31415900588035583)
        H.at(a,v,90)
        -- 源0xd08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0xd18，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0xd2c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,90)
        -- 源0xd40，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,90)
        -- 源0xd54，44号。
        H.push(v,0.05000000074505806)
        H.at(a,v,90)
        -- 源0xd68，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,90)
        -- 源0xd78，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,90)
        -- 源0xd8c，83号。
        v.origin=v.origin+H.int(9)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,90)
        -- 源0xda0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,90)
        -- 源0xdb4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,90)
        -- 源0xdcc，83号。
        v.origin=v.origin+H.int(30)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,90)
        -- 源0xde0，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0xdf4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part2(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,90)
        -- 源0xe0c，12号。
        v.origin=H.clock(a)-(90);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,90)
        -- 源0xe24，83号。
        v.origin=v.origin+H.int(1000)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,90)
        -- 源0xe38，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0xe4c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,90)
        -- 源0xe64，1号。
        H.erase(a);return
    end
    P["BossCard2_01Aat"]=B.part1
end

-- stage4c01a.ecl：BossCard2_01Amove，0xe84；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe84，40号。
        H.at(a,v,0)
        -- 源0xe98，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xeb0，282号。
        H.position(a,1,H.read(a,v,-9963),H.read(a,v,-9962))
        H.at(a,v,0)
        -- 源0xec8，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xedc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xef0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf08，10号。
        return
    end
    P["BossCard2_01Amove"]=B.part1
end

-- stage4c01a.ecl：BossCard2_01Amove2，0xf28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf28，40号。
        H.at(a,v,0)
        -- 源0xf3c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf54，288号。
        H.circle(a,0,-999999.0,-999999.0,-999999.0,-0.75)
        H.at(a,v,0)
        -- 源0xf74，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xf88，288号。
        H.circle(a,0,-999999.0,-999999.0,-999999.0,0.75)
        H.at(a,v,0)
        -- 源0xfa8，83号。
        v.origin=v.origin+H.int(120)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfbc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfd0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xfe8，10号。
        return
    end
    P["BossCard2_01Amove2"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01A，0x1008；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1008，40号。
        H.at(a,v,0)
        -- 源0x101c，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x1030，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1040，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1054，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1068，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1078，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1090，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x10a4，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x10bc，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x10d0，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x10e0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x10f0，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1104，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x1114，334号。
        H.interrupt(a,0,2000,3000,"BossCard4_01A")
        H.at(a,v,0)
        -- 源0x1144，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x1158，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x116c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1180，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1190，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x11a8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x11b8，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x11cc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x11e0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x11f0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1208，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x121c，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x1240，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1258，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1268，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x127c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1290，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x12a4，281号。
        H.position_time(a,0,60,4,-64.0,128.0)
        H.at(a,v,0)
        -- 源0x12c4，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x12d8，357号。
        H.spell(a,86,3000,500000,"想起「ストロードールカミカゼ」",357)
        H.at(a,v,0)
        -- 源0x1318，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x132c，0号。
        H.at(a,v,60)
        -- 源0x133c，356号。
        H.write(a,-9980,H.f32(5.5))
        H.at(a,v,60)
        -- 源0x1360，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0x1374，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x1388，12号。
        v.origin=H.clock(a)-(60);return B.part17(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x13a0，15号。
        H.async(a,P["BossCard3_01Aat"],"BossCard3_01Aat",nil)
        H.at(a,v,60)
        -- 源0x13c4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x13d8，42号。
        H.push(v,32)
        H.at(a,v,60)
        -- 源0x13ec，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x13fc，284号。
        H.velocity(a,0,H.read(a,v,-1),6.0)
        H.at(a,v,60)
        -- 源0x1414，285号。
        H.velocity_time(a,0,60,4,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x1434，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x1448，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x145c，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,60)
        -- 源0x146c，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,60)
        -- 源0x148c，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x14a0，42号。
        H.push(v,80)
        H.at(a,v,60)
        -- 源0x14b4，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x14c4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x14dc，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x14f0，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1504，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,60)
        -- 源0x1514，43号。
        v.l[12]=H.int(H.pop(v))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x1528，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x153c，44号。
        H.push(v,5.0)
        H.at(a,v,60)
        -- 源0x1550，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x1560，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part13(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x1578，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x158c，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,60)
        -- 源0x15a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x15b0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x15c4，15号。
        H.async(a,P["BossCard3_01Aat2"],"BossCard3_01Aat2",nil)
        H.at(a,v,60)
        -- 源0x15ec，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x1600，42号。
        H.push(v,32)
        H.at(a,v,60)
        -- 源0x1614，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x1624，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,60)
        -- 源0x1638，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x1648，284号。
        H.velocity(a,0,H.read(a,v,-1),6.0)
        H.at(a,v,60)
        -- 源0x1660，285号。
        H.velocity_time(a,0,60,4,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x1680，368号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,60)
        -- 源0x16a0，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x16b4，42号。
        H.push(v,80)
        H.at(a,v,60)
        -- 源0x16c8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x16d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part15(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x16f0，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x1704，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1718，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,60)
        -- 源0x1728，43号。
        v.l[12]=H.int(H.pop(v))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0x173c，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x1750，44号。
        H.push(v,5.0)
        H.at(a,v,60)
        -- 源0x1764，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x1774，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part17(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0x178c，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x17a0，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,60)
        -- 源0x17b4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x17c4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,60)
        -- 源0x17d8，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x17ec，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,60)
        -- 源0x1804，10号。
        return
    end
    P["BossCard3_01A"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01ADollA，0x1824；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1824，40号。
        H.at(a,v,0)
        -- 源0x1838，356号。
        v.l[4]=H.f32(5.0)
        H.at(a,v,0)
        -- 源0x185c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1870，259号。
        H.anm_slot(a,0,108)
        H.at(a,v,0)
        -- 源0x1888，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x189c，15号。
        H.async(a,P["BossCard3_01ADollPos"],"BossCard3_01ADollPos",nil)
        H.at(a,v,0)
        -- 源0x18c8，284号。
        H.velocity(a,0,H.read(a,v,-9981),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x18e0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x18f8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x190c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1920，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1938，1号。
        H.erase(a);return
    end
    P["BossCard3_01ADollA"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01ADollAttack0，0x1958；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1958，40号。
        H.at(a,v,0)
        -- 源0x196c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1980，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1998，402号。
        H.gun_sprite(a,0,1,13)
        H.at(a,v,0)
        -- 源0x19b4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x19d0，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x19ec，405号。
        H.gun_speed(a,0,0.0,1.0)
        H.at(a,v,0)
        -- 源0x1a08，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1a38，409号。
        H.gun_transform(a,0,1,0,4096,45,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1a68，409号。
        H.gun_transform(a,0,2,0,4,120,-999999,0.02083333395421505,-999999.0)
        H.at(a,v,0)
        -- 源0x1a98，411号。
        H.gun_copy(a,1,0)
        H.at(a,v,0)
        -- 源0x1ab0，402号。
        H.gun_sprite(a,1,0,12)
        H.at(a,v,0)
        -- 源0x1acc，12号。
        v.origin=H.clock(a)-(2);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ae4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1af8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1b0c，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x1b20，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1b30，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1b40，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x1b5c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1b70，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1b84，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1b94，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ba8，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x1bbc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1bcc，437号。
        H.gun_polar(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1be8，401号。
        H.fire(a,0)
        H.at(a,v,2)
        -- 源0x1bfc，401号。
        H.fire(a,1)
        H.at(a,v,2)
        -- 源0x1c10，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,2)
        -- 源0x1c24，42号。
        H.push(v,1)
        H.at(a,v,2)
        -- 源0x1c38，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,2)
        -- 源0x1c50，10号。
        return
    end
    P["BossCard3_01ADollAttack0"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01ADollPos，0x1c70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1c70，40号。
        H.at(a,v,0)
        -- 源0x1c84，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1c9c，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x1cb0，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x1cc4，66号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1cd4，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x1ce8，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x1cfc，70号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d0c，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d1c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x1d30，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1d44，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d54，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d64，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1d7c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1d94，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1da8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1dbc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1dd4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x1de8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1dfc，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x1e10，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1e20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1e30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e44，284号。
        H.velocity(a,0,(v.l[0] or 0),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x1e5c，15号。
        H.async(a,P["BossCard3_01ADollAttack0"],"BossCard3_01ADollAttack0",nil,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1e94，10号。
        return
    end
    P["BossCard3_01ADollPos"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01Aat，0x1eb4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1eb4，40号。
        H.at(a,v,0)
        -- 源0x1ec8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1edc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ef0，44号。
        H.push(v,-3.1415929794311523)
        H.at(a,v,0)
        -- 源0x1f04，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1f18，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1f30，256号。
        H.spawn(a,256,"BossCard3_01ADollA",0.0,0.0,1000,1000,0)
        H.at(a,v,0)
        -- 源0x1f6c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1f80，44号。
        H.push(v,0.34906598925590515)
        H.at(a,v,0)
        -- 源0x1f94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1fa4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1fb8，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1fcc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1fe4，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x1ff8，10号。
        return
    end
    P["BossCard3_01Aat"]=B.part1
end

-- stage4c01a.ecl：BossCard3_01Aat2，0x2018；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2018，40号。
        H.at(a,v,0)
        -- 源0x202c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2040，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2054，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2068，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x207c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2094，256号。
        H.spawn(a,256,"BossCard3_01ADollA",0.0,0.0,1000,1000,0)
        H.at(a,v,0)
        -- 源0x20d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x20e4，44号。
        H.push(v,0.34906598925590515)
        H.at(a,v,0)
        -- 源0x20f8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2108，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x211c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2130，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2148，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x215c，10号。
        return
    end
    P["BossCard3_01Aat2"]=B.part1
end

-- stage4c01a.ecl：BossCard4_01A，0x217c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x217c，40号。
        H.at(a,v,0)
        -- 源0x2190，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x21a4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x21b4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x21c8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x21dc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x21ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2204，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2218，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2230，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2244，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2254，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2264，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x2278，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x2288，334号。
        H.interrupt(a,0,0,4200,"BossDead")
        H.at(a,v,0)
        -- 源0x22b4，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x22c8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x22dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x22f0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2300，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2318，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2328，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x233c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2350，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2360，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2378，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x238c，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x23b0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x23c8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x23d8，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x23ec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2400，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2414，281号。
        H.position_time(a,0,90,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x2434，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x2444，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2458，357号。
        H.spell(a,90,4200,500000,"想起「リターンイナニメトネス」",357)
        H.at(a,v,0)
        -- 源0x2498，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x24ac，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x24c0，0号。
        H.at(a,v,60)
        -- 源0x24d0，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x24e4，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x24fc，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x2510，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2524，12号。
        v.origin=H.clock(a)-(60);return B.part17(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x253c，355号。
        v.l[16]=H.int(6)
        H.at(a,v,60)
        -- 源0x2560，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,60)
        -- 源0x2574，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x2588，44号。
        H.push(v,2.0)
        H.at(a,v,60)
        -- 源0x259c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x25b0，356号。
        v.l[12]=H.f32(1.0471975803375244)
        H.at(a,v,60)
        -- 源0x25d4，336号。
        H.sound(a,16)
        H.at(a,v,60)
        -- 源0x25e8，12号。
        v.origin=H.clock(a)-(60);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x2600，256号。
        H.spawn(a,256,"BossCard4_01ADollA",0.0,0.0,2000,1000,0)
        H.at(a,v,60)
        -- 源0x263c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x2650，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x2664，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x2674，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x2688，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x269c，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,60)
        -- 源0x26b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x26c8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,60)
        -- 源0x26dc，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x26f0，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x2700，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part16(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x2718，355号。
        v.l[16]=H.int(6)
        H.at(a,v,60)
        -- 源0x273c，356号。
        v.l[12]=H.f32(0.5235987901687622)
        H.at(a,v,60)
        -- 源0x2760，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x2774，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x2788，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x2798，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x27ac，356号。
        v.l[12]=H.f32(1.0471975803375244)
        H.at(a,v,60)
        -- 源0x27d0，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,60)
        -- 源0x27e4，44号。
        H.push(v,5.0)
        H.at(a,v,60)
        -- 源0x27f8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x280c，12号。
        v.origin=H.clock(a)-(60);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x2824，256号。
        H.spawn(a,256,"BossCard4_01ADollA",0.0,0.0,2000,1000,0)
        H.at(a,v,60)
        -- 源0x2860，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x2874，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,60)
        -- 源0x2888，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x2898，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x28ac，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0x28c0，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,60)
        -- 源0x28d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0x28ec，368号。
        v.origin=v.origin+H.int(110)
        H.at(a,v,60)
        -- 源0x290c，292号。
        H.wander(a,0,40,0,1.0)
        H.at(a,v,60)
        -- 源0x2928，83号。
        v.origin=v.origin+H.int(40)
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,60)
        -- 源0x293c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x2950，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,60)
        -- 源0x2968，10号。
        return
    end
    P["BossCard4_01A"]=B.part1
end

-- stage4c01a.ecl：BossCard4_01ADollA，0x2988；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2988，40号。
        H.at(a,v,0)
        -- 源0x299c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x29b0，259号。
        H.anm_slot(a,0,102)
        H.at(a,v,0)
        -- 源0x29c8，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x29dc，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x29f4，285号。
        H.velocity_time(a,0,80,1,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x2a14，0号。
        H.at(a,v,60)
        -- 源0x2a24，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x2a38，259号。
        H.anm_slot(a,1,175)
        H.at(a,v,80)
        -- 源0x2a50，259号。
        H.anm_slot(a,0,-1)
        H.at(a,v,80)
        -- 源0x2a68，284号。
        H.velocity(a,0,H.read(a,v,-9981),0.30000001192092896)
        H.at(a,v,80)
        -- 源0x2a80，336号。
        H.sound(a,54)
        H.at(a,v,80)
        -- 源0x2a94，322号。
        H.flags(a,513,true)
        H.at(a,v,80)
        -- 源0x2aa8，42号。
        H.push(v,8)
        H.at(a,v,80)
        -- 源0x2abc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0x2ad0，42号。
        H.push(v,10)
        H.at(a,v,80)
        -- 源0x2ae4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,80)
        -- 源0x2af8，12号。
        v.origin=H.clock(a)-(80);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,80)
        -- 源0x2b10，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,80)
        -- 源0x2b28，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,80)
        -- 源0x2b3c，42号。
        H.push(v,8)
        H.at(a,v,80)
        -- 源0x2b50，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,80)
        -- 源0x2b60，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0x2b74，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,80)
        -- 源0x2b88，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,80)
        -- 源0x2b9c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(80);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,80)
        -- 源0x2bb4，15号。
        H.async(a,P["BossCard4_01Aat"],"BossCard4_01Aat",nil)
        H.at(a,v,80)
        -- 源0x2bd8，42号。
        H.push(v,90)
        H.at(a,v,80)
        -- 源0x2bec，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,80)
        -- 源0x2c00，12号。
        v.origin=H.clock(a)-(80);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,80)
        -- 源0x2c18，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,80)
        -- 源0x2c30，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,80)
        -- 源0x2c44，44号。
        H.push(v,0.6000000238418579)
        H.at(a,v,80)
        -- 源0x2c58，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,80)
        -- 源0x2c68，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,80)
        -- 源0x2c7c，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,80)
        -- 源0x2c90，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,80)
        -- 源0x2ca4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(80);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,80)
        -- 源0x2cbc，322号。
        H.flags(a,3,true)
        H.at(a,v,80)
        -- 源0x2cd0，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,80)
        -- 源0x2ce4，1号。
        H.erase(a);return
    end
    function B.part8(a,v)
        H.at(a,v,80)
        -- 源0x2d0c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,80)
        -- 源0x2d20，42号。
        H.push(v,1)
        H.at(a,v,80)
        -- 源0x2d34，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(80);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,80)
        -- 源0x2d4c，1号。
        H.erase(a);return
    end
    P["BossCard4_01ADollA"]=B.part1
end

-- stage4c01a.ecl：BossCard4_01Aat，0x2d6c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2d6c，40号。
        H.at(a,v,0)
        -- 源0x2d80，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2d94，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x2dac，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0x2dc8，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2de4，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.09817477315664291)
        H.at(a,v,0)
        -- 源0x2e00，405号。
        H.gun_speed(a,0,0.0,2.0)
        H.at(a,v,0)
        -- 源0x2e1c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2e4c，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2e7c，409号。
        H.gun_transform(a,0,2,1,4,120,-999999,0.008333333767950535,-999999.0)
        H.at(a,v,0)
        -- 源0x2eac，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x2ec0，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x2ed4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2ee8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2f00，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2f14，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2f28，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2f3c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2f4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2f5c，438号。
        H.gun_distance(a,0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2f74，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x2f90，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2fa4，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2fb8，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2fcc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2fe4，10号。
        return
    end
    P["BossCard4_01Aat"]=B.part1
end

-- stage4c01a.ecl：BossCard4_01Aat2，0x3004；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3004，40号。
        H.at(a,v,0)
        -- 源0x3018，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x302c，407号。
        H.gun_aim(a,1,5)
        H.at(a,v,0)
        -- 源0x3044，402号。
        H.gun_sprite(a,1,7,6)
        H.at(a,v,0)
        -- 源0x3060，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x307c，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.09817477315664291)
        H.at(a,v,0)
        -- 源0x3098，405号。
        H.gun_speed(a,1,1.0,2.0)
        H.at(a,v,0)
        -- 源0x30b4，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x30e4，409号。
        H.gun_transform(a,1,1,0,1024,200,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3114，409号。
        H.gun_transform(a,1,2,1,8,6000,-999999,0.0,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x3144，409号。
        H.gun_transform(a,1,3,1,134217728,6000,-999999,1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0x3174，439号。
        H.gun_absolute(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3190，403号。
        H.gun_offset(a,1,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x31ac，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x31c0，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x31d4，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,0)
        -- 源0x31e8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x31fc，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3210，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3224，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3238，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x324c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3264，404号。
        H.gun_angle(a,1,(v.l[16] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3280，405号。
        H.gun_speed(a,1,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x329c，409号。
        H.gun_transform(a,1,2,1,8,6000,-999999,0.0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x32cc，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x32e0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x32f4，44号。
        H.push(v,3.8832221031188965)
        H.at(a,v,0)
        -- 源0x3308，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3318，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x332c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3340，44号。
        H.push(v,0.9929999709129333)
        H.at(a,v,0)
        -- 源0x3354，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3364，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3378，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x338c，44号。
        H.push(v,0.012000000104308128)
        H.at(a,v,0)
        -- 源0x33a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x33b0，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x33c4，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x33d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x33f0，10号。
        return
    end
    P["BossCard4_01Aat2"]=B.part1
end

-- stage4c01b.ecl：BossCard2_01B，0x10c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10c，40号。
        H.at(a,v,0)
        -- 源0x120，331号。
        H.life(a,6600)
        H.at(a,v,0)
        -- 源0x134，334号。
        H.interrupt(a,0,4400,3000,"BossCard3_01B")
        H.at(a,v,0)
        -- 源0x164，347号。
        H.life_marker(a,0,6600.0,-8355585)
        H.at(a,v,0)
        -- 源0x180，347号。
        H.life_marker(a,1,4400.0,-12566273)
        H.at(a,v,0)
        -- 源0x19c，347号。
        H.life_marker(a,2,2400.0,-16777024)
        H.at(a,v,0)
        -- 源0x1b8，357号。
        H.spell(a,94,3000,500000,"想起「マーキュリポイズン」",357)
        H.at(a,v,0)
        -- 源0x1f4，281号。
        H.position_time(a,0,60,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0x214，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x228，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x23c，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x250，0号。
        H.at(a,v,60)
        -- 源0x260，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,60)
        -- 源0x280，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x294，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x2a8，12号。
        v.origin=H.clock(a)-(60);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x2c0，42号。
        H.push(v,8)
        H.at(a,v,60)
        -- 源0x2d4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x2e8，12号。
        v.origin=H.clock(a)-(60);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x300，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,60)
        -- 源0x314，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x328，355号。
        v.l[16]=H.int(28)
        H.at(a,v,60)
        -- 源0x34c，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,60)
        -- 源0x360，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,60)
        -- 源0x374，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x388，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,60)
        -- 源0x398，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,60)
        -- 源0x3a8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x3bc，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0x3d0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,60)
        -- 源0x3e8，402号。
        H.gun_sprite(a,0,1,14)
        H.at(a,v,60)
        -- 源0x404，436号。
        H.gun_count_diff(a,0,(v.l[16] or 0),(v.l[16] or 0),(v.l[16] or 0),(v.l[16] or 0),1,1,2,2)
        H.at(a,v,60)
        -- 源0x438，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,60)
        -- 源0x454，435号。
        H.gun_speed_diff(a,0,1.5,1.5,1.5,1.600000023841858,1.0,1.0,1.0,1.0)
        H.at(a,v,60)
        -- 源0x488，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x4b8，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x4e8，409号。
        H.gun_transform(a,0,2,0,8,90,-999999,0.003000000026077032,0.012271846644580364)
        H.at(a,v,60)
        -- 源0x518，401号。
        H.fire(a,0)
        H.at(a,v,60)
        -- 源0x52c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,60)
        -- 源0x540，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0x554，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,60)
        -- 源0x56c，402号。
        H.gun_sprite(a,0,1,8)
        H.at(a,v,60)
        -- 源0x588，436号。
        H.gun_count_diff(a,0,(v.l[16] or 0),(v.l[16] or 0),(v.l[16] or 0),(v.l[16] or 0),1,1,2,2)
        H.at(a,v,60)
        -- 源0x5bc，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,60)
        -- 源0x5d8，435号。
        H.gun_speed_diff(a,0,1.5,1.5,1.5,1.600000023841858,1.0,1.0,1.0,1.0)
        H.at(a,v,60)
        -- 源0x60c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x63c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x66c，409号。
        H.gun_transform(a,0,2,0,8,90,-999999,0.003000000026077032,-0.012271846644580364)
        H.at(a,v,60)
        -- 源0x69c，401号。
        H.fire(a,0)
        H.at(a,v,60)
        -- 源0x6b0，83号。
        v.origin=v.origin+H.int(20)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x6c4，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,60)
        -- 源0x6d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x6f0，292号。
        H.wander(a,0,90,4,1.5)
        H.at(a,v,60)
        -- 源0x70c，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,60)
        -- 源0x720，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x734，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,60)
        -- 源0x744，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x758，83号。
        v.origin=v.origin+H.int(50)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x76c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x780，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x798，10号。
        return
    end
    P["BossCard2_01B"]=B.part1
end

-- stage4c01b.ecl：BossCard3_01B，0x7b8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7b8，40号。
        H.at(a,v,0)
        -- 源0x7cc，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x7e0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x7f0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x804，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x818，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x828，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x840，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x854，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x86c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x880，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x890，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x8a0，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x8b4，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x8c4，334号。
        H.interrupt(a,0,2400,3000,"BossCard4_01B")
        H.at(a,v,0)
        -- 源0x8f4，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x908，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x91c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x930，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x940，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x958，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x968，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x97c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x990，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9a0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9b8，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9cc，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x9f0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xa08，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xa18，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa2c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa40，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xa54，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xa74，324号。
        H.limit(a,0.0,128.0,280.0,64.0)
        H.at(a,v,0)
        -- 源0xa94，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0xaa8，357号。
        H.spell(a,98,3000,500000,"想起「プリンセスウンディネ」",357)
        H.at(a,v,0)
        -- 源0xae8，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0xafc，0号。
        H.at(a,v,60)
        -- 源0xb0c，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,60)
        -- 源0xb20，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0xb34，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xb48，16号。
        H.async(a,P["BossCard3_01Bat"],"BossCard3_01Bat",1)
        H.at(a,v,60)
        -- 源0xb70，12号。
        v.origin=H.clock(a)-(60);return B.part18(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xb88，292号。
        H.wander(a,0,90,4,1.5)
        H.at(a,v,60)
        -- 源0xba4，42号。
        H.push(v,4)
        H.at(a,v,60)
        -- 源0xbb8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xbcc，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0xbe0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xbf4，12号。
        v.origin=H.clock(a)-(60);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0xc0c，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0xc20，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,60)
        -- 源0xc38，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,60)
        -- 源0xc54，436号。
        H.gun_count_diff(a,0,1,1,9,10,1,1,2,3)
        H.at(a,v,60)
        -- 源0xc88，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.4487989544868469)
        H.at(a,v,60)
        -- 源0xca4，435号。
        H.gun_speed_diff(a,0,2.0,2.0,2.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,60)
        -- 源0xcd8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0xd08，401号。
        H.fire(a,0)
        H.at(a,v,60)
        -- 源0xd1c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0xd30，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,60)
        -- 源0xd44，44号。
        H.push(v,0.22439900040626526)
        H.at(a,v,60)
        -- 源0xd58，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xd68，44号。
        H.push(v,0.11219999939203262)
        H.at(a,v,60)
        -- 源0xd7c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0xd8c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0xd9c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xdb0，83号。
        v.origin=v.origin+H.int(20)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0xdc4，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,60)
        -- 源0xdd8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0xdf0，42号。
        H.push(v,12)
        H.at(a,v,60)
        -- 源0xe04，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xe18，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,60)
        -- 源0xe2c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xe40，12号。
        v.origin=H.clock(a)-(60);return B.part16(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0xe58，412号。
        H.laser(a,412,3,6,H.read(a,v,-9989),4.0,0.0,96.0,0,12.0)
        H.at(a,v,60)
        -- 源0xe88，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,60)
        -- 源0xe9c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xeb0，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0xec0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part15(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0xed8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,60)
        -- 源0xeec，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0xf00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xf10，412号。
        H.laser(a,412,3,6,H.read(a,v,-1),4.0,0.0,96.0,0,12.0)
        H.at(a,v,60)
        -- 源0xf40，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0xf54，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0xf68，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0xf78，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xf8c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,60)
        -- 源0xfa0，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0xfb4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xfc4，412号。
        H.laser(a,412,3,6,H.read(a,v,-1),4.0,0.0,96.0,0,12.0)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0xff4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x1008，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,60)
        -- 源0x101c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0x102c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x1040，336号。
        H.sound(a,16)
        H.at(a,v,60)
        -- 源0x1054，83号。
        v.origin=v.origin+H.int(10)
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0x1068，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,60)
        -- 源0x107c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part13(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,60)
        -- 源0x1094，292号。
        H.wander(a,0,90,4,1.5)
        H.at(a,v,60)
        -- 源0x10b0，83号。
        v.origin=v.origin+H.int(50)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,60)
        -- 源0x10c4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x10d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,60)
        -- 源0x10f0，10号。
        return
    end
    P["BossCard3_01B"]=B.part1
end

-- stage4c01b.ecl：BossCard3_01Bat，0x1110；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1110，40号。
        H.at(a,v,0)
        -- 源0x1124，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x1138，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x1150，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x116c，436号。
        H.gun_count_diff(a,2,16,16,20,24,1,2,3,3)
        H.at(a,v,0)
        -- 源0x11a0，404号。
        H.gun_angle(a,2,3.1415927410125732,0.0)
        H.at(a,v,0)
        -- 源0x11bc，435号。
        H.gun_speed_diff(a,2,3.5,3.5,4.199999809265137,4.300000190734863,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x11f0，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1220，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1238，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x124c，83号。
        v.origin=v.origin+H.int(22)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1260，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1274，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x128c，10号。
        return
    end
    P["BossCard3_01Bat"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B，0x12ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x12ac，40号。
        H.at(a,v,0)
        -- 源0x12c0，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x12d4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x12e4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x12f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x130c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x131c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1334，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1348，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1360，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1374，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1384，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1394，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x13a8，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x13b8，334号。
        H.interrupt(a,0,0,4200,"BossDead")
        H.at(a,v,0)
        -- 源0x13e4，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x13f8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x140c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1420，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1430，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1448，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1458，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x146c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1480，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1490，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x14a8，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x14bc，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x14e0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x14f8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1508，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x151c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1530，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1544，281号。
        H.position_time(a,0,90,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x1564，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x1574，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x1588，357号。
        H.spell(a,102,4200,500000,"想起「賢者の石」",357)
        H.at(a,v,0)
        -- 源0x15bc，322号。
        H.flags(a,12,true)
        H.at(a,v,60)
        -- 源0x15d0，0号。
        H.at(a,v,60)
        -- 源0x15e0，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x15f4，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x160c，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x1620，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x1634，336号。
        H.sound(a,7)
        H.at(a,v,60)
        -- 源0x1648，257号。
        H.spawn(a,257,"BossCard4_01B_Book00",0.0,144.0,60000,1000,0)
        H.at(a,v,60)
        -- 源0x1688，257号。
        H.spawn(a,257,"BossCard4_01B_Book01",128.0,112.0,60000,1000,0)
        H.at(a,v,60)
        -- 源0x16c8，257号。
        H.spawn(a,257,"BossCard4_01B_Book02",64.0,96.0,60000,1000,0)
        H.at(a,v,60)
        -- 源0x1708，257号。
        H.spawn(a,257,"BossCard4_01B_Book03",-128.0,112.0,60000,1000,0)
        H.at(a,v,60)
        -- 源0x1748，257号。
        H.spawn(a,257,"BossCard4_01B_Book04",-64.0,96.0,60000,1000,0)
        H.at(a,v,60)
        -- 源0x1788，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x17a0，83号。
        v.origin=v.origin+H.int(120)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x17b4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x17c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x17e0，10号。
        return
    end
    P["BossCard4_01B"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B_Book00，0x1800；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1800，40号。
        H.at(a,v,0)
        -- 源0x1814，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1828，259号。
        H.anm_slot(a,0,46)
        H.at(a,v,0)
        -- 源0x1840，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x1854，83号。
        v.origin=v.origin+H.int(32)
        H.at(a,v,0)
        -- 源0x1868，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1880，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1894，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x18ac，402号。
        H.gun_sprite(a,0,25,0)
        H.at(a,v,0)
        -- 源0x18c8，436号。
        H.gun_count_diff(a,0,10,10,10,10,6,6,6,6)
        H.at(a,v,0)
        -- 源0x18fc，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1918，435号。
        H.gun_speed_diff(a,0,2.0,2.0,3.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x194c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1960，368号。
        v.origin=v.origin+H.int(90)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1980，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1994，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x19ac，1号。
        H.erase(a);return
    end
    P["BossCard4_01B_Book00"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B_Book01，0x19cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x19cc，40号。
        H.at(a,v,0)
        -- 源0x19e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x19f4，259号。
        H.anm_slot(a,0,45)
        H.at(a,v,0)
        -- 源0x1a0c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x1a20，83号。
        v.origin=v.origin+H.int(64)
        H.at(a,v,0)
        -- 源0x1a34，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1a4c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1a60，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1a78，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x1a94，406号。
        H.gun_count(a,0,11,2)
        H.at(a,v,0)
        -- 源0x1ab0，404号。
        H.gun_angle(a,0,0.0,0.2617993950843811)
        H.at(a,v,0)
        -- 源0x1acc，405号。
        H.gun_speed(a,0,3.0,1.0)
        H.at(a,v,0)
        -- 源0x1ae8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1b18，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1b2c，368号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1b4c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1b60，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1b78，1号。
        H.erase(a);return
    end
    P["BossCard4_01B_Book01"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B_Book02，0x1b98；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1b98，40号。
        H.at(a,v,0)
        -- 源0x1bac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1bc0，259号。
        H.anm_slot(a,0,47)
        H.at(a,v,0)
        -- 源0x1bd8，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x1bec，83号。
        v.origin=v.origin+H.int(16)
        H.at(a,v,0)
        -- 源0x1c00，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1c18，355号。
        v.l[4]=H.int(30)
        H.at(a,v,0)
        -- 源0x1c3c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1c54，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1c68，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x1c80，402号。
        H.gun_sprite(a,0,13,5)
        H.at(a,v,0)
        -- 源0x1c9c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x1cb8，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1cd4，405号。
        H.gun_speed(a,0,1.0,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x1cf0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1d20，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1d50，409号。
        H.gun_transform(a,0,2,0,4,120,-999999,0.009999999776482582,2.356194496154785)
        H.at(a,v,0)
        -- 源0x1d80，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1d94，368号。
        v.origin=v.origin+H.int(1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1db4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x1dc8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1de0，368号。
        v.origin=v.origin+H.int(130)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1e00，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1e14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1e2c，1号。
        H.erase(a);return
    end
    P["BossCard4_01B_Book02"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B_Book03，0x1e4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1e4c，40号。
        H.at(a,v,0)
        -- 源0x1e60，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1e74，259号。
        H.anm_slot(a,0,46)
        H.at(a,v,0)
        -- 源0x1e8c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x1ea0，368号。
        v.origin=v.origin+H.int(48)
        H.at(a,v,0)
        -- 源0x1ec0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ed8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1eec，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1f04，402号。
        H.gun_sprite(a,0,14,7)
        H.at(a,v,0)
        -- 源0x1f20，436号。
        H.gun_count_diff(a,0,6,16,20,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1f54，404号。
        H.gun_angle(a,0,1.5707963705062866,-3.1415927410125732)
        H.at(a,v,0)
        -- 源0x1f70，405号。
        H.gun_speed(a,0,4.0,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x1f8c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1fbc，409号。
        H.gun_transform(a,0,1,0,64,60,1,H.read(a,v,-9989),1.5)
        H.at(a,v,0)
        -- 源0x1fec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2000，83号。
        v.origin=v.origin+H.int(170)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2014，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2028，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2040，1号。
        H.erase(a);return
    end
    P["BossCard4_01B_Book03"]=B.part1
end

-- stage4c01b.ecl：BossCard4_01B_Book04，0x2060；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2060，40号。
        H.at(a,v,0)
        -- 源0x2074，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x2088，259号。
        H.anm_slot(a,0,48)
        H.at(a,v,0)
        -- 源0x20a0，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x20b4，368号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,0)
        -- 源0x20d4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x20ec，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x2100，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2114，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x212c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2140，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x2158，402号。
        H.gun_sprite(a,0,12,6)
        H.at(a,v,0)
        -- 源0x2174，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2190，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x21a4，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x21b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x21c8，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x21e4，405号。
        H.gun_speed(a,0,2.4000000953674316,1.0)
        H.at(a,v,0)
        -- 源0x2200，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2230，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2260，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2274，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2288，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x229c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x22ac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x22bc，409号。
        H.gun_transform(a,0,2,0,16,100,1,H.read(a,v,-1),1.0)
        H.at(a,v,0)
        -- 源0x22ec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2300，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2314，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x232c，402号。
        H.gun_sprite(a,0,12,6)
        H.at(a,v,0)
        -- 源0x2348，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2364，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2378，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x238c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x239c，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x23b8，405号。
        H.gun_speed(a,0,2.4000000953674316,1.0)
        H.at(a,v,0)
        -- 源0x23d4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2404，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2434，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2448，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x245c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2470，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2480，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2490，409号。
        H.gun_transform(a,0,2,0,16,100,1,H.read(a,v,-1),1.0)
        H.at(a,v,0)
        -- 源0x24c0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x24d4，83号。
        v.origin=v.origin+H.int(40)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x24e8，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x24fc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2514，368号。
        v.origin=v.origin+H.int(120)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2534，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2548，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2560，1号。
        H.erase(a);return
    end
    P["BossCard4_01B_Book04"]=B.part1
end

-- stage4c01c.ecl：Boss2Et_at2，0xf4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf4，40号。
        H.at(a,v,0)
        -- 源0x108，44号。
        H.push(v,2.356194019317627)
        H.at(a,v,0)
        -- 源0x11c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x130，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x144，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x158，11号。
        H.call(a,v,P["Boss2Et_at2h"],"Boss2Et_at2h")
        H.at(a,v,0)
        -- 源0x17c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x190，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x1a4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1b8，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x1d0，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x1ec，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x208，404号。
        H.gun_angle(a,0,1.5707963705062866,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x224，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x240，12号。
        v.origin=H.clock(a)-(5);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x2ac，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2c0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2e4，403号。
        H.gun_offset(a,0,H.read(a,v,-1),-12.0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x378，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x394，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3a8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3bc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3cc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x47c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x490，44号。
        H.push(v,0.04908699914813042)
        H.at(a,v,0)
        -- 源0x4a4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4b4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4c8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x4dc，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x4f0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x500，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x518，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x52c，43号。
        v.l[8]=H.int(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x540，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x558，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x56c，44号。
        H.push(v,0.04908699914813042)
        H.at(a,v,0)
        -- 源0x580，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x590，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5a4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5b8，44号。
        H.push(v,2.356194496154785)
        H.at(a,v,0)
        -- 源0x5cc，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5dc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x608，43号。
        v.l[8]=H.int(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x61c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        H.at(a,v,5)
        -- 源0x644，0号。
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,5)
        -- 源0x654，42号。
        H.push(v,1)
        H.at(a,v,5)
        -- 源0x668，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,5)
        -- 源0x680，1号。
        H.erase(a);return
    end
    P["Boss2Et_at2"]=B.part1
end

-- stage4c01c.ecl：Boss2Et_at2h，0x6a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6a0，40号。
        H.at(a,v,0)
        -- 源0x6b4，44号。
        H.push(v,2.356194019317627)
        H.at(a,v,0)
        -- 源0x6c8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x6f0，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x704，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x718，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x72c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x740，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x758，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x774，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x790，404号。
        H.gun_angle(a,0,1.5707963705062866,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x7ac，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x7c8，409号。
        H.gun_transform(a,0,0,0,16,60,1,0.0,0.10000000149011612)
        H.at(a,v,0)
        -- 源0x7f8，409号。
        H.gun_transform(a,0,1,0,4096,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x828，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x840，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x854，44号。
        H.push(v,0.029999999329447746)
        H.at(a,v,0)
        -- 源0x868，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x878，44号。
        H.push(v,0.017999999225139618)
        H.at(a,v,0)
        -- 源0x88c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x89c，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,H.read(a,v,-1),-999.0)
        H.at(a,v,0)
        -- 源0x8cc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8e0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8f4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x904，403号。
        H.gun_offset(a,0,H.read(a,v,-1),-12.0)
        H.at(a,v,0)
        -- 源0x920，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x934，44号。
        H.push(v,0.4000000059604645)
        H.at(a,v,0)
        -- 源0x948，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x958，44号。
        H.push(v,4.400000095367432)
        H.at(a,v,0)
        -- 源0x96c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x97c，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x998，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x9b4，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x9c8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9dc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xa50，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa64，44号。
        H.push(v,0.028049999848008156)
        H.at(a,v,0)
        -- 源0xa78，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xa88，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa9c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xab0，44号。
        H.push(v,0.7853981852531433)
        H.at(a,v,0)
        -- 源0xac4，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xad4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xaec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb00，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xb14，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xb78，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xb8c，44号。
        H.push(v,0.028049999848008156)
        H.at(a,v,0)
        -- 源0xba0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xbb0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbc4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xbd8，44号。
        H.push(v,2.356194496154785)
        H.at(a,v,0)
        -- 源0xbec，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xbfc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xc14，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xc28，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xc3c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xc64，83号。
        v.origin=v.origin+H.int(5)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xc78，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc8c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xca4，10号。
        return
    end
    P["Boss2Et_at2h"]=B.part1
end

-- stage4c01c.ecl：BossCard2_01C，0xcc4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcc4，40号。
        H.at(a,v,0)
        -- 源0xcd8，355号。
        v.l[28]=H.int(32)
        H.at(a,v,0)
        -- 源0xcfc，331号。
        H.life(a,6600)
        H.at(a,v,0)
        -- 源0xd10，334号。
        H.interrupt(a,0,4400,3000,"BossCard3_01C")
        H.at(a,v,0)
        -- 源0xd40，347号。
        H.life_marker(a,0,6600.0,-8355585)
        H.at(a,v,0)
        -- 源0xd5c，347号。
        H.life_marker(a,1,4400.0,-12566273)
        H.at(a,v,0)
        -- 源0xd78，347号。
        H.life_marker(a,2,2400.0,-16777024)
        H.at(a,v,0)
        -- 源0xd94，357号。
        H.spell(a,106,3000,500000,"想起「のびーるアーム」",357)
        H.at(a,v,0)
        -- 源0xdcc，281号。
        H.position_time(a,0,60,0,0.0,128.0)
        H.at(a,v,0)
        -- 源0xdec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe00，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xe14，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0xe28，0号。
        H.at(a,v,120)
        -- 源0xe38，263号。
        H.effect(a,0,131)
        H.at(a,v,180)
        -- 源0xe50，262号。
        H.anm_main(a,0,0)
        H.at(a,v,180)
        -- 源0xe68，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,180)
        -- 源0xe88，42号。
        H.push(v,0)
        H.at(a,v,180)
        -- 源0xe9c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,180)
        -- 源0xeb0，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,180)
        -- 源0xec4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,180)
        -- 源0xed8，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,180)
        -- 源0xeec，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,180)
        -- 源0xf00，42号。
        H.push(v,0)
        H.at(a,v,180)
        -- 源0xf14，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,180)
        -- 源0xf28，42号。
        H.push(v,0)
        H.at(a,v,180)
        -- 源0xf3c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,180)
        -- 源0xf50，42号。
        H.push(v,1)
        H.at(a,v,180)
        -- 源0xf64，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,180)
        -- 源0xf78，12号。
        v.origin=H.clock(a)-(380);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,180)
        -- 源0xf90，15号。
        H.async(a,P["BossCard2_01Cat"],"BossCard2_01Cat",nil)
        H.at(a,v,180)
        -- 源0xfb4，292号。
        H.wander(a,0,160,4,2.0)
        H.at(a,v,380)
        -- 源0xfd0，0号。
        H.at(a,v,380)
        -- 源0xfe0，400号。
        H.gun_new(a,0)
        H.at(a,v,380)
        -- 源0xff4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,380)
        -- 源0x100c，402号。
        H.gun_sprite(a,0,8,6)
        H.at(a,v,380)
        -- 源0x1028，436号。
        H.gun_count_diff(a,0,(v.l[28] or 0),(v.l[28] or 0),(v.l[28] or 0),(v.l[28] or 0),2,2,2,3)
        H.at(a,v,380)
        -- 源0x105c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.19634954631328583)
        H.at(a,v,380)
        -- 源0x1078，435号。
        H.gun_speed_diff(a,0,2.5,2.5,2.5,3.5,1.0,1.0,1.0,1.0)
        H.at(a,v,380)
        -- 源0x10ac，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,380)
        -- 源0x10dc，401号。
        H.fire(a,0)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,380)
        -- 源0x10f0，42号。
        H.push(v,1)
        H.at(a,v,380)
        -- 源0x1104，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(180);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,380)
        -- 源0x111c，10号。
        return
    end
    P["BossCard2_01C"]=B.part1
end

-- stage4c01c.ecl：BossCard2_01Cat，0x113c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x113c，40号。
        H.at(a,v,0)
        -- 源0x1150，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1164，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1178，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x118c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x11a0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x11b4，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x11c8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x11d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x11e8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x11fc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1214，336号。
        H.sound(a,24)
        H.at(a,v,0)
        -- 源0x1228，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x123c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x1250，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1264，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1274，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1284，81号。
        do local r=64.0;local angle=H.read(a,v,-1);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x12a4，403号。
        H.gun_offset(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1320，412号。
        H.laser(a,412,3,9,(v.l[8] or 0),6.0,0.0,520.0,0,14.0)
        H.at(a,v,0)
        -- 源0x1350，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1364，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x1378，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x138c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x139c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13ac，81号。
        do local r=64.0;local angle=H.read(a,v,-1);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x13cc，403号。
        H.gun_offset(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1448，412号。
        H.laser(a,412,3,9,(v.l[8] or 0),6.0,0.0,520.0,0,14.0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x14c4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x14d8，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,0)
        -- 源0x14ec，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x14fc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1524，368号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1544，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1558，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x156c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1584，336号。
        H.sound(a,16)
        H.at(a,v,0)
        -- 源0x1598，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x15ac，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x15c0，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x15d4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x15e4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x15f4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1608，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x161c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1630，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1648，336号。
        H.sound(a,24)
        H.at(a,v,0)
        -- 源0x165c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1670，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x1684，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1698，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x16a8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x16b8，81号。
        do local r=64.0;local angle=H.read(a,v,-1);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x16d8，403号。
        H.gun_offset(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1754，412号。
        H.laser(a,412,3,9,(v.l[8] or 0),5.0,0.0,520.0,0,14.0)
        H.at(a,v,0)
        -- 源0x1784，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1798，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x17ac，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x17c0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x17d0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x17e0，81号。
        do local r=64.0;local angle=H.read(a,v,-1);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x1800，403号。
        H.gun_offset(a,0,(v.l[0] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x187c，412号。
        H.laser(a,412,3,9,(v.l[8] or 0),5.0,0.0,520.0,0,14.0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x18f8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x190c，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,0)
        -- 源0x1920，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1930，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x1958，368号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1978，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x198c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x19a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x19b8，10号。
        return
    end
    P["BossCard2_01Cat"]=B.part1
end

-- stage4c01c.ecl：BossCard2_at，0x19d8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x19d8，40号。
        H.at(a,v,0)
        -- 源0x19ec，10号。
        return
    end
    P["BossCard2_at"]=B.part1
end

-- stage4c01c.ecl：BossCard3_01C，0x1a0c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1a0c，40号。
        H.at(a,v,0)
        -- 源0x1a20，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x1a34，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1a44，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1a58，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1a6c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1a7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1a94，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1aa8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1ac0，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1ad4，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1ae4，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1af4，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1b08，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x1b18，334号。
        H.interrupt(a,0,2400,3000,"BossCard4_01C")
        H.at(a,v,0)
        -- 源0x1b48，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x1b5c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1b70，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1b84，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1b94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1bac，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1bbc，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1bd0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1be4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1bf4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1c0c，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1c20，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x1c44，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1c5c，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1c6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1c80，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1c94，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1ca8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x1cc8，324号。
        H.limit(a,0.0,128.0,280.0,64.0)
        H.at(a,v,0)
        -- 源0x1ce8，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x1cfc，357号。
        H.spell(a,110,3000,500000,"想起「河童のポロロッカ」",357)
        H.at(a,v,0)
        -- 源0x1d38，336号。
        H.sound(a,41)
        H.at(a,v,90)
        -- 源0x1d4c，0号。
        H.at(a,v,90)
        -- 源0x1d5c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,90)
        -- 源0x1d70，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x1d84，61号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left~=right and 1 or 0)) end
        H.at(a,v,90)
        -- 源0x1d94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(95);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x1dac，257号。
        H.spawn(a,257,"Boss2Et_at2",160.0,0.0,240,1000,0)
        H.at(a,v,91)
        -- 源0x1de0，257号。
        H.spawn(a,257,"Boss2Et_at2",96.0,0.0,240,1000,0)
        H.at(a,v,92)
        -- 源0x1e14，257号。
        H.spawn(a,257,"Boss2Et_at2",32.0,0.0,240,1000,0)
        H.at(a,v,93)
        -- 源0x1e48，257号。
        H.spawn(a,257,"Boss2Et_at2",-160.0,0.0,240,1000,0)
        H.at(a,v,94)
        -- 源0x1e7c，257号。
        H.spawn(a,257,"Boss2Et_at2",-96.0,0.0,240,1000,0)
        H.at(a,v,95)
        -- 源0x1eb0，257号。
        H.spawn(a,257,"Boss2Et_at2",-32.0,0.0,240,1000,0)
        H.at(a,v,95)
        -- 源0x1ee4，12号。
        v.origin=H.clock(a)-(97);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,95)
        -- 源0x1efc，257号。
        H.spawn(a,257,"Boss2Et_at2",128.0,0.0,240,1000,0)
        H.at(a,v,96)
        -- 源0x1f30，257号。
        H.spawn(a,257,"Boss2Et_at2",0.0,0.0,240,1000,0)
        H.at(a,v,97)
        -- 源0x1f64，257号。
        H.spawn(a,257,"Boss2Et_at2",-128.0,0.0,240,1000,0)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,97)
        -- 源0x1f98，12号。
        v.origin=H.clock(a)-(247);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,197)
        -- 源0x1fb0，0号。
        H.at(a,v,197)
        -- 源0x1fc0，292号。
        H.wander(a,0,50,0,2.0)
        H.at(a,v,247)
        -- 源0x1fdc，0号。
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,247)
        -- 源0x1fec，42号。
        H.push(v,1)
        H.at(a,v,247)
        -- 源0x2000，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(97);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,247)
        -- 源0x2018，10号。
        return
    end
    P["BossCard3_01C"]=B.part1
end

-- stage4c01c.ecl：BossCard4At，0x2038；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2038，40号。
        H.at(a,v,0)
        -- 源0x204c，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x2060，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2074，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x2088，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x209c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x20b0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x20c8，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x20e4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2100，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x211c，405号。
        H.gun_speed(a,0,1.2999999523162842,1.0)
        H.at(a,v,0)
        -- 源0x2138，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2168，12号。
        v.origin=H.clock(a)-(20);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2180，401号。
        H.fire(a,0)
        H.at(a,v,20)
        -- 源0x2194，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,20)
        -- 源0x21a4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,20)
        -- 源0x21b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,20)
        -- 源0x21d0，1号。
        H.erase(a);return
    end
    P["BossCard4At"]=B.part1
end

-- stage4c01c.ecl：BossCard4AtH，0x21f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x21f0，40号。
        H.at(a,v,0)
        -- 源0x2204，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x2218，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x222c，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x2240，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x2254，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2268，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2280，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x229c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x22b8，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x22d4，405号。
        H.gun_speed(a,0,1.2999999523162842,1.0)
        H.at(a,v,0)
        -- 源0x22f0，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2320，42号。
        H.push(v,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x2334，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x2348，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x2358，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x236c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x237c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2394，409号。
        H.gun_transform(a,0,1,0,1024,320,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x23c4，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x23f4，409号。
        H.gun_transform(a,0,3,0,8,120,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2424，409号。
        H.gun_transform(a,0,4,0,8,120,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2454，409号。
        H.gun_transform(a,0,5,0,8,60,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2484，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x249c，409号。
        H.gun_transform(a,0,1,0,1024,320,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x24cc，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x24fc，409号。
        H.gun_transform(a,0,3,0,8,120,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x252c，409号。
        H.gun_transform(a,0,4,0,8,120,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x255c，409号。
        H.gun_transform(a,0,5,0,8,60,-999999,0.0,0.013089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x258c，12号。
        v.origin=H.clock(a)-(20);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x25a4，401号。
        H.fire(a,0)
        H.at(a,v,20)
        -- 源0x25b8，0号。
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,20)
        -- 源0x25c8，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,20)
        -- 源0x25dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,20)
        -- 源0x25f4，1号。
        H.erase(a);return
    end
    P["BossCard4AtH"]=B.part1
end

-- stage4c01c.ecl：BossCard4AtH2，0x2614；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2614，40号。
        H.at(a,v,0)
        -- 源0x2628，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x263c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2650，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x2664，322号。
        H.flags(a,268,true)
        H.at(a,v,0)
        -- 源0x2678，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x268c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x26a4，402号。
        H.gun_sprite(a,0,18,0)
        H.at(a,v,0)
        -- 源0x26c0，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x26dc，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x26f8，405号。
        H.gun_speed(a,0,1.2999999523162842,1.0)
        H.at(a,v,0)
        -- 源0x2714，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2744，42号。
        H.push(v,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x2758，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x276c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x277c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2790，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x27a0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x27b8，409号。
        H.gun_transform(a,0,1,0,1024,320,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x27e8，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2818，409号。
        H.gun_transform(a,0,3,0,8,120,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2848，409号。
        H.gun_transform(a,0,4,0,8,120,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2878，409号。
        H.gun_transform(a,0,5,0,8,60,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x28a8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x28c0，409号。
        H.gun_transform(a,0,1,0,1024,320,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x28f0，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2920，409号。
        H.gun_transform(a,0,3,0,8,120,-999999,0.0,0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2950，409号。
        H.gun_transform(a,0,4,0,8,120,-999999,0.0,-0.013089969754219055)
        H.at(a,v,0)
        -- 源0x2980，409号。
        H.gun_transform(a,0,5,0,8,60,-999999,0.0,0.013089969754219055)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x29b0，12号。
        v.origin=H.clock(a)-(20);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x29c8，401号。
        H.fire(a,0)
        H.at(a,v,20)
        -- 源0x29dc，0号。
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,20)
        -- 源0x29ec，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,20)
        -- 源0x2a00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,20)
        -- 源0x2a18，1号。
        H.erase(a);return
    end
    P["BossCard4AtH2"]=B.part1
end

-- stage4c01c.ecl：BossCard4_01C，0x2a38；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2a38，40号。
        H.at(a,v,0)
        -- 源0x2a4c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2a60，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2a74，356号。
        v.l[4]=H.f32(0.19634954631328583)
        H.at(a,v,0)
        -- 源0x2a98，355号。
        v.l[12]=H.int(9)
        H.at(a,v,0)
        -- 源0x2abc，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x2ad0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2ae0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2af4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2b08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2b30，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2b44，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2b5c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2b70，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2b80，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2b90，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x2ba4，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x2bb4，334号。
        H.interrupt(a,0,0,4200,"BossDead")
        H.at(a,v,0)
        -- 源0x2be0，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x2bf4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2c08，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2c1c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2c2c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2c44，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2c54，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2c68，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2c7c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2c8c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2ca4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2cb8，11号。
        H.call(a,v,P["BossCardItem"],"BossCardItem")
        H.at(a,v,0)
        -- 源0x2cdc，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2cf4，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2d04，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2d18，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d2c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2d40，281号。
        H.position_time(a,0,90,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x2d60，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2d74，357号。
        H.spell(a,114,4200,500000,"想起「光り輝く水底のトラウマ」",357)
        H.at(a,v,0)
        -- 源0x2db4，322号。
        H.flags(a,12,true)
        H.at(a,v,0)
        -- 源0x2dc8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2ddc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2df0，12号。
        v.origin=H.clock(a)-(160);return B.part16(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x2ea0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2eb4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2ec8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2ed8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2eec，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x2f00，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2f14，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2f28，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2f3c，12号。
        v.origin=H.clock(a)-(40);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x2f54，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x2f68，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2f7c，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x2f90，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2fa4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2fb4，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x2fc8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2fd8，257号。
        H.spawn(a,257,"BossCard4AtH",H.read(a,v,-1),(v.l[0] or 0),50,1000,1)
        H.at(a,v,0)
        -- 源0x3010，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x3024，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3038，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x3048，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x305c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x306c，257号。
        H.spawn(a,257,"BossCard4AtH2",H.read(a,v,-1),(v.l[0] or 0),50,1000,1)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x313c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3150，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x3164，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3174，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,20)
        -- 源0x3188，44号。
        H.push(v,0.0)
        H.at(a,v,20)
        -- 源0x319c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,20)
        -- 源0x31b0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,20)
        -- 源0x31c4，42号。
        H.push(v,192)
        H.at(a,v,20)
        -- 源0x31d8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,20)
        -- 源0x31e8，42号。
        H.push(v,16)
        H.at(a,v,20)
        -- 源0x31fc，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,20)
        -- 源0x320c，257号。
        H.spawn(a,257,"BossCard4AtH",H.read(a,v,-1),(v.l[0] or 0),50,1000,1)
        H.at(a,v,20)
        -- 源0x3244，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,20)
        -- 源0x3258，42号。
        H.push(v,192)
        H.at(a,v,20)
        -- 源0x326c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,20)
        -- 源0x327c，42号。
        H.push(v,16)
        H.at(a,v,20)
        -- 源0x3290，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,20)
        -- 源0x32a0，257号。
        H.spawn(a,257,"BossCard4AtH2",H.read(a,v,-1),(v.l[0] or 0),50,1000,1)
        H.at(a,v,40)
        -- 源0x32d8，0号。
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        H.at(a,v,40)
        -- 源0x3380，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,40)
        -- 源0x3394，42号。
        H.push(v,32)
        H.at(a,v,40)
        -- 源0x33a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,40)
        -- 源0x33b8，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,40)
        -- 源0x33cc，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,40)
        -- 源0x33e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,40)
        -- 源0x33f8，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,60)
        -- 源0x3414，0号。
        H.at(a,v,60)
        -- 源0x3424，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0x3438，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,60)
        -- 源0x3450，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,60)
        -- 源0x346c，406号。
        H.gun_count(a,0,(v.l[12] or 0),1)
        H.at(a,v,60)
        -- 源0x3488，404号。
        H.gun_angle(a,0,0.0,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x34a4，435号。
        H.gun_speed_diff(a,0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,60)
        -- 源0x34d8，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0x3508，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,60)
        -- 源0x351c，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x3530，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x3540，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(160);return B.part14(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x3558，401号。
        H.fire(a,0)
        H.at(a,v,80)
        -- 源0x356c，401号。
        H.fire(a,0)
        H.at(a,v,100)
        -- 源0x3580，401号。
        H.fire(a,0)
        H.at(a,v,120)
        -- 源0x3594，401号。
        H.fire(a,0)
        H.at(a,v,140)
        -- 源0x35a8，401号。
        H.fire(a,0)
        H.at(a,v,160)
        -- 源0x35bc，401号。
        H.fire(a,0)
        H.at(a,v,160)
        -- 源0x35d0，12号。
        v.origin=H.clock(a)-(160);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,160)
        -- 源0x35e8，83号。
        v.origin=v.origin+H.int(100)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,160)
        -- 源0x35fc，42号。
        H.push(v,H.read(a,v,-9985))
        H.at(a,v,160)
        -- 源0x3610，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0x3624，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,160)
        -- 源0x3634，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,160)
        -- 源0x3648，42号。
        H.push(v,1)
        H.at(a,v,160)
        -- 源0x365c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,160)
        -- 源0x3674，10号。
        return
    end
    P["BossCard4_01C"]=B.part1
end

return P
