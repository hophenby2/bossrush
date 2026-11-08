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

-- stage05.ecl：BCir00，0x3dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3dc，40号。
        H.at(a,v,0)
        -- 源0x3f0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x408，11号。
        H.call(a,v,P["Cir00"],"Cir00",87,45,1)
        H.at(a,v,0)
        -- 源0x43c，1号。
        H.erase(a);return
    end
    P["BCir00"]=B.part1
end

-- stage05.ecl：BCir01，0x45c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x45c，40号。
        H.at(a,v,0)
        -- 源0x470，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x488，11号。
        H.call(a,v,P["Cir01"],"Cir01",87,45,1)
        H.at(a,v,0)
        -- 源0x4bc，1号。
        H.erase(a);return
    end
    P["BCir01"]=B.part1
end

-- stage05.ecl：BCir02，0x4dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4dc，40号。
        H.at(a,v,0)
        -- 源0x4f0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x508，11号。
        H.call(a,v,P["Cir02"],"Cir02",75,45,1)
        H.at(a,v,0)
        -- 源0x53c，1号。
        H.erase(a);return
    end
    P["BCir02"]=B.part1
end

-- stage05.ecl：BPhantom00，0x55c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x55c，40号。
        H.at(a,v,0)
        -- 源0x570，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x584，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x598，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x5b0，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",98,1)
        H.at(a,v,0)
        -- 源0x5e0，1号。
        H.erase(a);return
    end
    P["BPhantom00"]=B.part1
end

-- stage05.ecl：BPhantom01，0x600；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x600，40号。
        H.at(a,v,0)
        -- 源0x614，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x628，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x63c，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x654，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",98,1)
        H.at(a,v,0)
        -- 源0x684，1号。
        H.erase(a);return
    end
    P["BPhantom01"]=B.part1
end

-- stage05.ecl：BPhantom02，0x6a4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6a4，40号。
        H.at(a,v,0)
        -- 源0x6b8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6cc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6e0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x6f8，11号。
        H.call(a,v,P["Phantom02"],"Phantom02",98,1)
        H.at(a,v,0)
        -- 源0x728，1号。
        H.erase(a);return
    end
    P["BPhantom02"]=B.part1
end

-- stage05.ecl：Cir00，0x748；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x748，40号。
        H.at(a,v,0)
        -- 源0x75c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x770，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x784，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x798，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7b0，322号。
        H.flags(a,15,true)
        H.at(a,v,0)
        -- 源0x7c4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x7dc，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x7f4，336号。
        H.sound(a,34)
        H.at(a,v,0)
        -- 源0x808，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x818，327号。
        H.drop_extra(a,1,1)
        H.at(a,v,0)
        -- 源0x830，327号。
        H.drop_extra(a,2,4)
        H.at(a,v,0)
        -- 源0x848，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x860，288号。
        H.circle(a,0,H.read(a,v,-9998),0.09817477315664291,72.0,-1.0)
        H.at(a,v,0)
        -- 源0x880，286号。
        H.velocity(a,1,-1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0x898，287号。
        H.velocity_time(a,1,60,4,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x8b8，323号。
        H.flags(a,15,false)
        H.at(a,v,60)
        -- 源0x8cc，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,60)
        -- 源0x8e4，288号。
        H.circle(a,0,-999999.0,-999999.0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x904，15号。
        H.async(a,P["RCir00_at"],"RCir00_at",nil)
        H.at(a,v,180)
        -- 源0x924，286号。
        H.velocity(a,1,1.5707963705062866,0.0)
        H.at(a,v,180)
        -- 源0x93c，287号。
        H.velocity_time(a,1,60,4,-999999.0,1.0)
        H.at(a,v,180)
        -- 源0x95c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,180)
        -- 源0x970，287号。
        H.velocity_time(a,1,120,1,-999999.0,-1.0)
        H.at(a,v,180)
        -- 源0x990，12号。
        v.origin=H.clock(a)-(180);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,180)
        -- 源0x9a8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,180)
        -- 源0x9bc，42号。
        H.push(v,1)
        H.at(a,v,180)
        -- 源0x9d0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(180);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,180)
        -- 源0x9e8，10号。
        return
    end
    P["Cir00"]=B.part1
end

-- stage05.ecl：Cir01，0xa08；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa08，40号。
        H.at(a,v,0)
        -- 源0xa1c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa30，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa44，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa58，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa70，322号。
        H.flags(a,15,true)
        H.at(a,v,0)
        -- 源0xa84，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa9c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xab4，336号。
        H.sound(a,34)
        H.at(a,v,0)
        -- 源0xac8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xad8，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0xaf0，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0xb08，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xb20，288号。
        H.circle(a,0,H.read(a,v,-9998),0.09817477315664291,72.0,-1.0)
        H.at(a,v,0)
        -- 源0xb40，286号。
        H.velocity(a,1,-1.5707963705062866,1.0)
        H.at(a,v,0)
        -- 源0xb58，287号。
        H.velocity_time(a,1,60,4,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0xb78，323号。
        H.flags(a,15,false)
        H.at(a,v,60)
        -- 源0xb8c，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,60)
        -- 源0xba4，288号。
        H.circle(a,0,-999999.0,-999999.0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0xbc4，15号。
        H.async(a,P["RCir01_at"],"RCir01_at",nil)
        H.at(a,v,560)
        -- 源0xbe4，286号。
        H.velocity(a,1,-1.5707963705062866,0.0)
        H.at(a,v,560)
        -- 源0xbfc，287号。
        H.velocity_time(a,1,120,1,-999999.0,1.0)
        H.at(a,v,560)
        -- 源0xc1c，12号。
        v.origin=H.clock(a)-(560);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,560)
        -- 源0xc34，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,560)
        -- 源0xc48，42号。
        H.push(v,1)
        H.at(a,v,560)
        -- 源0xc5c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(560);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,560)
        -- 源0xc74，10号。
        return
    end
    P["Cir01"]=B.part1
end

-- stage05.ecl：Cir02，0xc94；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc94，40号。
        H.at(a,v,0)
        -- 源0xca8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xcbc，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xcd0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xce4，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xcfc，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xd14，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xd2c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xd3c，327号。
        H.drop_extra(a,1,1)
        H.at(a,v,0)
        -- 源0xd54，327号。
        H.drop_extra(a,2,2)
        H.at(a,v,0)
        -- 源0xd6c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xd84，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0xd9c，15号。
        H.async(a,P["RCir02_at"],"RCir02_at",nil)
        H.at(a,v,0)
        -- 源0xdbc，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0xdd4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xde8，285号。
        H.velocity_time(a,0,60,0,0.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe08，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xe1c，285号。
        H.velocity_time(a,0,60,0,1.5707963705062866,-999999.0)
        H.at(a,v,0)
        -- 源0xe3c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe54，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe68，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe7c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe94，10号。
        return
    end
    P["Cir02"]=B.part1
end

-- stage05.ecl：GCir00，0xeb4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xeb4，40号。
        H.at(a,v,0)
        -- 源0xec8，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xedc，11号。
        H.call(a,v,P["Cir00"],"Cir00",84,47,1)
        H.at(a,v,0)
        -- 源0xf10，1号。
        H.erase(a);return
    end
    P["GCir00"]=B.part1
end

-- stage05.ecl：GCir01，0xf30；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf30，40号。
        H.at(a,v,0)
        -- 源0xf44，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xf58，11号。
        H.call(a,v,P["Cir01"],"Cir01",84,47,1)
        H.at(a,v,0)
        -- 源0xf8c，1号。
        H.erase(a);return
    end
    P["GCir01"]=B.part1
end

-- stage05.ecl：GCir02，0xfac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfac，40号。
        H.at(a,v,0)
        -- 源0xfc0，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xfd4，11号。
        H.call(a,v,P["Cir02"],"Cir02",72,47,1)
        H.at(a,v,0)
        -- 源0x1008，1号。
        H.erase(a);return
    end
    P["GCir02"]=B.part1
end

-- stage05.ecl：GPhantom00，0x1028；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1028，40号。
        H.at(a,v,0)
        -- 源0x103c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1050，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x1064，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x107c，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",96,1)
        H.at(a,v,0)
        -- 源0x10ac，1号。
        H.erase(a);return
    end
    P["GPhantom00"]=B.part1
end

-- stage05.ecl：GPhantom01，0x10cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10cc，40号。
        H.at(a,v,0)
        -- 源0x10e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10f4，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x1108，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x1120，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",96,1)
        H.at(a,v,0)
        -- 源0x1150，1号。
        H.erase(a);return
    end
    P["GPhantom01"]=B.part1
end

-- stage05.ecl：GPhantom02，0x1170；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1170，40号。
        H.at(a,v,0)
        -- 源0x1184，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1198，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x11ac，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x11c4，11号。
        H.call(a,v,P["Phantom02"],"Phantom02",96,1)
        H.at(a,v,0)
        -- 源0x11f4，1号。
        H.erase(a);return
    end
    P["GPhantom02"]=B.part1
end

-- stage05.ecl：MainBossDebug，0x1214；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1214，40号。
        H.at(a,v,60)
        -- 源0x1228，338号。
        H.dialog(a,-1)
        H.at(a,v,60)
        -- 源0x123c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x124c，257号。
        H.spawn(a,257,"Boss",216.0,64.0,40,1000,1)
        H.at(a,v,60)
        -- 源0x127c，500号。
        H.debug_entry(a,100)
        H.at(a,v,60)
        -- 源0x1290，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x12a0，340号。
        H.boss_wait(a,v)
        H.at(a,v,120)
        -- 源0x12b0，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x12c4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x12d4，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage05.ecl：MainMBossDebug，0x1304；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1304，40号。
        H.at(a,v,0)
        -- 源0x1318，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x1348，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1360，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1374，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1388，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x13a0，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage05.ecl：MainMsgDebug，0x13c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13c0，40号。
        H.at(a,v,0)
        -- 源0x13d4，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0x13e8，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x13fc，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0x140c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x141c，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0x1430，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x1440，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0x1458，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0x1468，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0x147c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0x1494，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage05.ecl：MainSub00，0x14b4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14b4，40号。
        H.at(a,v,0)
        -- 源0x14c8，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x14dc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x14f0，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x1504，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1518，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x152c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1540，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x1554，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1568，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1580，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1594，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x15a8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x15bc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x15cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x15dc，256号。
        H.spawn(a,256,"BPhantom00",(v.l[0] or 0),H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x1610，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1624，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1638，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x164c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x165c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1670，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1684，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x1698，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x16a8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x16bc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x16d0，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x16e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x16f4，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1708，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x171c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1734，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,0)
        -- 源0x1748，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x175c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1770，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x1784，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1798，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x17ac，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x17c0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x17d4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x17e8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1800，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1814，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1828，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x183c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x184c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x185c，256号。
        H.spawn(a,256,"RPhantom00",(v.l[0] or 0),H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x1890，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x18a4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x18b8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x18cc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x18dc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x18f0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1904，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x1918，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1928，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x193c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1950，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1964，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1974，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1988，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x199c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x19b4，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x19c8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x19dc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x19f0，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x1a04，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a18，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1a2c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a40，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x1a54，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a68，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1a80，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1a94，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1aa8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1abc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1acc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1adc，256号。
        H.spawn(a,256,"BPhantom00",(v.l[0] or 0),H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x1b10，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1b24，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1b38，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1b4c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1b60，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1b70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1b80，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1b94，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ba8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1bb8，256号。
        H.spawn(a,256,"RPhantom00",H.read(a,v,-1),H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x1bec，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1c00，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1c14，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1c28，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1c38，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c4c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1c60，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x1c74，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1c84，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c98，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1cac，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1cc0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1cd0，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1ce4，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1cf8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1d10，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage05.ecl：MainSub00b，0x1d30；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1d30，40号。
        H.at(a,v,0)
        -- 源0x1d44，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1d58，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d6c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1d84，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1d98，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1dac，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1dc0，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x1dd0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1de0，260号。
        H.spawn(a,260,"RCir00",64.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x1e10，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1e24，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1e38，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1e4c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1e60，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x1e70，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1e80，260号。
        H.spawn(a,260,"RCir00",256.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x1eb0，83号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1ec4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1ed8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1ef0，10号。
        return
    end
    P["MainSub00b"]=B.part1
end

-- stage05.ecl：MainSub01，0x1f10；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1f10，40号。
        H.at(a,v,0)
        -- 源0x1f24，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1f38，257号。
        H.spawn(a,257,"BCir00",-96.0,128.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1f68，257号。
        H.spawn(a,257,"BCir00",96.0,128.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1f98，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x1fac，257号。
        H.spawn(a,257,"BCir00",0.0,128.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1fdc，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x1ff0，257号。
        H.spawn(a,257,"BCir00",128.0,128.0,700,1000,2)
        H.at(a,v,0)
        -- 源0x2020，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x2034，257号。
        H.spawn(a,257,"BCir00",-128.0,128.0,700,1000,2)
        H.at(a,v,0)
        -- 源0x2064，83号。
        v.origin=v.origin+H.int(170)
        H.at(a,v,0)
        -- 源0x2078，257号。
        H.spawn(a,257,"BCir00",60.0,128.0,700,1000,2)
        H.at(a,v,0)
        -- 源0x20a8，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x20bc，257号。
        H.spawn(a,257,"BCir00",-60.0,128.0,700,1000,2)
        H.at(a,v,0)
        -- 源0x20ec，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x2100，257号。
        H.spawn(a,257,"BCir00",0.0,128.0,700,1000,2)
        H.at(a,v,0)
        -- 源0x2130，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x2144，257号。
        H.spawn(a,257,"BCir00",-96.0,128.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2174，257号。
        H.spawn(a,257,"BCir00",96.0,128.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x21a4，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage05.ecl：MainSub02，0x21c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x21c4，40号。
        H.at(a,v,0)
        -- 源0x21d8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x21ec，257号。
        H.spawn(a,257,"BCir01",0.0,128.0,4000,1000,2)
        H.at(a,v,0)
        -- 源0x221c，15号。
        H.async(a,P["MainSub02b"],"MainSub02b",nil)
        H.at(a,v,0)
        -- 源0x223c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x2250，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2264，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x227c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2290，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x22a4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x22b8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x22c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x22d8，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x230c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x2320，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2334，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2348，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x235c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x236c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x237c，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x23b0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x23c4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x23d8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x23ec，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2400，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2410，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2420，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x2454，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x2468，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x247c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2490，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x24a4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x24b4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x24c4，257号。
        H.spawn(a,257,"GPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x24f8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x250c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2520，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2534，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2548，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2558，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2568，257号。
        H.spawn(a,257,"RPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x259c，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x25b0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x25c4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x25dc，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage05.ecl：MainSub02b，0x25fc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x25fc，40号。
        H.at(a,v,0)
        -- 源0x2610，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x2624，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2638，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2650，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2664，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2678，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x268c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x269c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x26ac，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x26e0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x26f4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2708，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x271c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2730，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2740，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2750，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x2784，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x2798，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x27ac，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x27c0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x27d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x27e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x27f4，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x2828，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x283c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2850，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2864，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2878，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2888，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2898，261号。
        H.spawn(a,261,"GPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x28cc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x28e0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x28f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2908，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x291c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x292c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x293c，261号。
        H.spawn(a,261,"RPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x2970，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2984，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2998，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x29b0，10号。
        return
    end
    P["MainSub02b"]=B.part1
end

-- stage05.ecl：MainSub03，0x29d0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x29d0，40号。
        H.at(a,v,0)
        -- 源0x29e4，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0x29f8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2a0c，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,3000,1000,2)
        H.at(a,v,0)
        -- 源0x2a3c，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage05.ecl：MainSub04，0x2a5c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2a5c，40号。
        H.at(a,v,0)
        -- 源0x2a70，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x2a84，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2a98，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2ab0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2ac4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2ad8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2aec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2afc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2b0c，268号。
        H.spawn(a,268,"GPhantom02",224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x2b40，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x2b54，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2b68，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2b7c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2b90，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2ba0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2bb0，266号。
        H.spawn(a,266,"GPhantom02",-224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x2be4，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2bf8，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2c0c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2c24，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage05.ecl：MainSub05，0x2c44；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2c44，40号。
        H.at(a,v,0)
        -- 源0x2c58，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2c6c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2c80，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x2c94，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2ca8，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2cbc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2cd0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2ce4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2cf4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2d04，268号。
        H.spawn(a,268,"GPhantom02",224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x2d38，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2d50，266号。
        H.spawn(a,266,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x2d80，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2d94，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2da8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2db8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2dcc，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2de0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x2df4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2e0c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2e20，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e34，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x2e48，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e5c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2e70，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2e84，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2e98，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2ea8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2eb8，266号。
        H.spawn(a,266,"GPhantom02",-224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x2eec，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2f04，268号。
        H.spawn(a,268,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x2f34，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2f48，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2f5c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2f6c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2f80，83号。
        v.origin=v.origin+H.int(20)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2f94，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x2fa8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2fc0，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2fd4，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2fe8，42号。
        H.push(v,-32)
        H.at(a,v,0)
        -- 源0x2ffc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3010，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3024，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3038，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x304c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x305c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x306c，268号。
        H.spawn(a,268,"GPhantom02",224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x30a0，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x30b8，268号。
        H.spawn(a,268,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x30e8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x30fc，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3110，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3120，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3134，83号。
        v.origin=v.origin+H.int(20)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x3148，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x315c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x3174，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x3188，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x319c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x31b0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x31c4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x31d8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x31ec，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3200，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3210，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3220，266号。
        H.spawn(a,266,"GPhantom02",-224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x3254，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x326c，266号。
        H.spawn(a,266,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x329c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x32b0，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x32c4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x32d4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x32e8，83号。
        v.origin=v.origin+H.int(20)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x32fc，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x3310，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x3328，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x333c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3350，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x3364，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3378，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x338c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x33a0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x33b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x33c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x33d4，268号。
        H.spawn(a,268,"GPhantom02",224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x3408，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x3420，266号。
        H.spawn(a,266,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x3450，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3464，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3478，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3488，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x349c，83号。
        v.origin=v.origin+H.int(20)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x34b0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x34c4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x34dc，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x34f0，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3504，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x3518，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x352c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3540，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3554，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3568，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3578，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3588，266号。
        H.spawn(a,266,"GPhantom02",-224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x35bc，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x35d4，268号。
        H.spawn(a,268,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x3604，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3618，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x362c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x363c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3650，83号。
        v.origin=v.origin+H.int(20)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x3664，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x3678，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x3690，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x36a4，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x36b8，42号。
        H.push(v,-32)
        H.at(a,v,0)
        -- 源0x36cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x36e0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x36f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3708，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x371c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x372c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x373c，268号。
        H.spawn(a,268,"GPhantom02",224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x3770，12号。
        v.origin=H.clock(a)-(0);return B.part21(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,0)
        -- 源0x3788，268号。
        H.spawn(a,268,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x37b8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x37cc，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x37e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x37f0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3804，83号。
        v.origin=v.origin+H.int(20)
        return B.part21(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,0)
        -- 源0x3818，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x382c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part20(a,v) end
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,0)
        -- 源0x3844，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x3858，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x386c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x3880，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3894，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x38a8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x38bc，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x38d0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x38e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x38f0，266号。
        H.spawn(a,266,"GPhantom02",-224.0,H.read(a,v,-1),100,1000,2)
        H.at(a,v,0)
        -- 源0x3924，12号。
        v.origin=H.clock(a)-(0);return B.part24(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,0)
        -- 源0x393c，266号。
        H.spawn(a,266,"BCir02",(v.l[0] or 0),-32.0,80,1000,2)
        H.at(a,v,0)
        -- 源0x396c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3980，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3994，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x39a4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x39b8，83号。
        v.origin=v.origin+H.int(20)
        return B.part24(a,v)
    end
    function B.part24(a,v)
        H.at(a,v,0)
        -- 源0x39cc，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x39e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part23(a,v) end
        return B.part25(a,v)
    end
    function B.part25(a,v)
        H.at(a,v,0)
        -- 源0x39f8，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage05.ecl：MainSub06，0x3a18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3a18，40号。
        H.at(a,v,0)
        -- 源0x3a2c，15号。
        H.async(a,P["MainSub06b"],"MainSub06b",nil)
        H.at(a,v,0)
        -- 源0x3a4c，15号。
        H.async(a,P["MainSub06c"],"MainSub06c",nil)
        H.at(a,v,0)
        -- 源0x3a6c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x3a80，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3a94，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3aac，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3ac0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3ad4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3ae8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3af8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3b08，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3b3c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3b50，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3b64，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3b78，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3b8c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3b9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3bac，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3be0，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3bf4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3c08，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3c1c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3c30，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3c40，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3c50，257号。
        H.spawn(a,257,"BPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3c84，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3c98，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3cac，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3cc0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3cd4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3ce4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3cf4，257号。
        H.spawn(a,257,"GPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3d28，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3d3c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3d50，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3d64，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3d78，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3d88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3d98，257号。
        H.spawn(a,257,"RPhantom01",-224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3dcc，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3de0，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x3df4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3e0c，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage05.ecl：MainSub06b，0x3e2c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3e2c，40号。
        H.at(a,v,0)
        -- 源0x3e40，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x3e54，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e68，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3e80，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3e94，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3ea8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3ebc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3ecc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3edc，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3f10，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3f24，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3f38，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3f4c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3f60，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3f70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3f80，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x3fb4，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x3fc8，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x3fdc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3ff0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x4004，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4014，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4024，261号。
        H.spawn(a,261,"BPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x4058，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x406c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x4080，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x4094，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x40a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x40b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x40c8，261号。
        H.spawn(a,261,"GPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x40fc，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x4110，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x4124，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x4138，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x414c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x415c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x416c，261号。
        H.spawn(a,261,"RPhantom01",224.0,H.read(a,v,-1),30,1000,2)
        H.at(a,v,0)
        -- 源0x41a0，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x41b4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x41c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x41e0，10号。
        return
    end
    P["MainSub06b"]=B.part1
end

-- stage05.ecl：MainSub06c，0x4200；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4200，40号。
        H.at(a,v,0)
        -- 源0x4214，257号。
        H.spawn(a,257,"BCir01",0.0,128.0,3000,1000,2)
        H.at(a,v,0)
        -- 源0x4244，83号。
        v.origin=v.origin+H.int(400)
        H.at(a,v,0)
        -- 源0x4258，257号。
        H.spawn(a,257,"BCir01",0.0,128.0,4000,1000,2)
        H.at(a,v,0)
        -- 源0x4288，10号。
        return
    end
    P["MainSub06c"]=B.part1
end

-- stage05.ecl：MapleEnemy，0x42a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x42a8，40号。
        H.at(a,v,0)
        -- 源0x42bc，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x42d0，264号。
        H.effect_abs(a,0,171)
        H.at(a,v,3)
        -- 源0x42e8，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x4300，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage05.ecl：PCir00，0x4320；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4320，40号。
        H.at(a,v,0)
        -- 源0x4334，11号。
        H.call(a,v,P["Cir00"],"Cir00",90,48,1)
        H.at(a,v,0)
        -- 源0x4368，1号。
        H.erase(a);return
    end
    P["PCir00"]=B.part1
end

-- stage05.ecl：PCir01，0x4388；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4388，40号。
        H.at(a,v,0)
        -- 源0x439c，11号。
        H.call(a,v,P["Cir01"],"Cir01",90,48,1)
        H.at(a,v,0)
        -- 源0x43d0，1号。
        H.erase(a);return
    end
    P["PCir01"]=B.part1
end

-- stage05.ecl：PCir02，0x43f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x43f0，40号。
        H.at(a,v,0)
        -- 源0x4404，11号。
        H.call(a,v,P["Cir02"],"Cir02",78,48,1)
        H.at(a,v,0)
        -- 源0x4438，1号。
        H.erase(a);return
    end
    P["PCir02"]=B.part1
end

-- stage05.ecl：Phantom00，0x4458；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4458，40号。
        H.at(a,v,0)
        -- 源0x446c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4480，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4498，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x44ac，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x44c0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x44d8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x44f0，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x4504，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x4518，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x452c，334号。
        H.interrupt(a,0,0,-1,"Phantom00_at")
        H.at(a,v,0)
        -- 源0x455c，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x4574，285号。
        H.velocity_time(a,0,60,0,-999999.0,-0.10000000149011612)
        H.at(a,v,160)
        -- 源0x4594，0号。
        H.at(a,v,160)
        -- 源0x45a4，11号。
        H.call(a,v,P["Phantom00_at2"],"Phantom00_at2")
        H.at(a,v,160)
        -- 源0x45c8，10号。
        return
    end
    P["Phantom00"]=B.part1
end

-- stage05.ecl：Phantom00_at，0x45e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x45e8，40号。
        H.at(a,v,0)
        -- 源0x45fc，11号。
        H.call(a,v,P["Phantom00_atB"],"Phantom00_atB")
        H.at(a,v,0)
        -- 源0x4620，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x4630，327号。
        H.drop_extra(a,2,2)
        H.at(a,v,0)
        -- 源0x4648，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x4660，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x4670，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x4688，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x469c，1号。
        H.erase(a);return
    end
    P["Phantom00_at"]=B.part1
end

-- stage05.ecl：Phantom00_at2，0x46cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x46cc，40号。
        H.at(a,v,0)
        -- 源0x46e0，11号。
        H.call(a,v,P["Phantom00_atB"],"Phantom00_atB")
        H.at(a,v,0)
        -- 源0x4704，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x471c，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x4730，1号。
        H.erase(a);return
    end
    P["Phantom00_at2"]=B.part1
end

-- stage05.ecl：Phantom00_atB，0x4760；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4760，40号。
        H.at(a,v,0)
        -- 源0x4774，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4788，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x47a0，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x47bc，436号。
        H.gun_count_diff(a,0,12,16,20,24,1,3,6,8)
        H.at(a,v,0)
        -- 源0x47f0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x480c，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x4840，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4870，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x48a0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x48b4，10号。
        return
    end
    P["Phantom00_atB"]=B.part1
end

-- stage05.ecl：Phantom01，0x48d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x48d4，40号。
        H.at(a,v,0)
        -- 源0x48e8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x48fc，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4914，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x4928，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x4940，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x4958，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x496c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x4980，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x4994，334号。
        H.interrupt(a,0,0,-1,"Phantom01_at")
        H.at(a,v,0)
        -- 源0x49c4，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x49d8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x49ec，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x4a00，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4a10，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4a20，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4a34，286号。
        H.velocity(a,1,(v.l[8] or 0),1.0)
        H.at(a,v,0)
        -- 源0x4a4c，300号。
        H.ellipse(a,0,H.read(a,v,-9998),0.05235987901687622,0.0,0.25,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0x4a74，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4a8c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4aa0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4ab4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4acc，10号。
        return
    end
    P["Phantom01"]=B.part1
end

-- stage05.ecl：Phantom01_at，0x4aec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4aec，40号。
        H.at(a,v,0)
        -- 源0x4b00，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4b14，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x4b2c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x4b48，436号。
        H.gun_count_diff(a,0,1,1,3,3,1,3,5,5)
        H.at(a,v,0)
        -- 源0x4b7c，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0x4b98，435号。
        H.gun_speed_diff(a,0,2.0999999046325684,2.0999999046325684,3.0999999046325684,4.099999904632568,1.7000000476837158,1.7000000476837158,1.7000000476837158,1.7000000476837158)
        H.at(a,v,0)
        -- 源0x4bcc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4bfc，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4c2c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4c40，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x4c50，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x4c68，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x4c7c，1号。
        H.erase(a);return
    end
    P["Phantom01_at"]=B.part1
end

-- stage05.ecl：Phantom01_at2，0x4cac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4cac，40号。
        H.at(a,v,0)
        -- 源0x4cc0，11号。
        H.call(a,v,P["Phantom01_atB"],"Phantom01_atB")
        H.at(a,v,0)
        -- 源0x4ce4，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x4cfc，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x4d10，1号。
        H.erase(a);return
    end
    P["Phantom01_at2"]=B.part1
end

-- stage05.ecl：Phantom01_atB，0x4d40；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4d40，40号。
        H.at(a,v,0)
        -- 源0x4d54，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4d68，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x4d80，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x4d9c，406号。
        H.gun_count(a,0,1,3)
        H.at(a,v,0)
        -- 源0x4db8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4dd4，405号。
        H.gun_speed(a,0,2.0999999046325684,1.7000000476837158)
        H.at(a,v,0)
        -- 源0x4df0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4e20，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4e50，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4e64，10号。
        return
    end
    P["Phantom01_atB"]=B.part1
end

-- stage05.ecl：Phantom02，0x4e84；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4e84，40号。
        H.at(a,v,0)
        -- 源0x4e98，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4eac，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4ec4，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x4ed8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x4ef0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x4f08，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x4f1c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x4f30，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x4f44，334号。
        H.interrupt(a,0,0,-1,"Phantom02_at")
        H.at(a,v,0)
        -- 源0x4f74，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x4f88，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4f9c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x4fb0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4fc0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4fd0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4fe4，286号。
        H.velocity(a,1,(v.l[8] or 0),1.5)
        H.at(a,v,0)
        -- 源0x4ffc，300号。
        H.ellipse(a,0,H.read(a,v,-9998),0.05235987901687622,0.0,0.25,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0x5024，15号。
        H.async(a,P["Phantom02_at2"],"Phantom02_at2",nil)
        H.at(a,v,0)
        -- 源0x5048，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5060，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5074，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5088，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x50a0，10号。
        return
    end
    P["Phantom02"]=B.part1
end

-- stage05.ecl：Phantom02_at，0x50c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x50c0，40号。
        H.at(a,v,0)
        -- 源0x50d4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x50e8，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x5100，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x511c，436号。
        H.gun_count_diff(a,0,1,1,3,5,1,3,5,5)
        H.at(a,v,0)
        -- 源0x5150，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0x516c，435号。
        H.gun_speed_diff(a,0,2.0999999046325684,2.0999999046325684,3.0999999046325684,4.099999904632568,1.7000000476837158,1.7000000476837158,1.7000000476837158,1.7000000476837158)
        H.at(a,v,0)
        -- 源0x51a0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x51d0，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5200，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5214，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x5224，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x523c，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x5250，1号。
        H.erase(a);return
    end
    P["Phantom02_at"]=B.part1
end

-- stage05.ecl：Phantom02_at2，0x5280；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5280，40号。
        H.at(a,v,0)
        -- 源0x5294，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x52a8，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x52c0，402号。
        H.gun_sprite(a,0,24,15)
        H.at(a,v,0)
        -- 源0x52dc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x52f8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5314，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x5330，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5360，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5390，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x53a4，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x53b8，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x53c8，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x53dc，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x53f4，355号。
        v.l[8]=H.int(32)
        H.at(a,v,0)
        -- 源0x5418，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x542c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5440，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5458，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x546c，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x5480，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5490，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x54a4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x54b4，405号。
        H.gun_speed(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x54d0，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x54ec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5500，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5514，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x5528，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5538，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x554c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5560，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x5574，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x558c，368号。
        v.origin=v.origin+H.int(60)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x55ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x55c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x55d8，1号。
        H.erase(a);return
    end
    P["Phantom02_at2"]=B.part1
end

-- stage05.ecl：RCir00，0x5608；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5608，40号。
        H.at(a,v,0)
        -- 源0x561c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x5630，11号。
        H.call(a,v,P["Cir00"],"Cir00",81,46,1)
        H.at(a,v,0)
        -- 源0x5664，1号。
        H.erase(a);return
    end
    P["RCir00"]=B.part1
end

-- stage05.ecl：RCir00_at，0x5684；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5684，40号。
        H.at(a,v,0)
        -- 源0x5698，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x56ac，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x56c4，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0x56e0，436号。
        H.gun_count_diff(a,0,16,16,16,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0x5714，404号。
        H.gun_angle(a,0,1.5707963705062866,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x5730，435号。
        H.gun_speed_diff(a,0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x5764，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x5780，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x5798，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x57c8，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x57dc，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x57f4，402号。
        H.gun_sprite(a,1,2,2)
        H.at(a,v,0)
        -- 源0x5810，406号。
        H.gun_count(a,1,2,2)
        H.at(a,v,0)
        -- 源0x582c，404号。
        H.gun_angle(a,1,0.0,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x5848，405号。
        H.gun_speed(a,1,2.0,1.0)
        H.at(a,v,0)
        -- 源0x5864，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5894，356号。
        v.l[4]=H.f32(3.0)
        H.at(a,v,0)
        -- 源0x58b8，409号。
        H.gun_transform(a,1,1,0,32,90,1,0.0,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x58e8，15号。
        H.async(a,P["RCir00_at2"],"RCir00_at2",nil)
        H.at(a,v,0)
        -- 源0x5908，355号。
        v.l[8]=H.int(20)
        H.at(a,v,0)
        -- 源0x592c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5944，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5958，368号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5978，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x598c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x59a4，10号。
        return
    end
    P["RCir00_at"]=B.part1
end

-- stage05.ecl：RCir00_at2，0x59c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x59c4，40号。
        H.at(a,v,0)
        -- 源0x59d8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x59f0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5a04，368号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5a24，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5a38，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5a50，10号。
        return
    end
    P["RCir00_at2"]=B.part1
end

-- stage05.ecl：RCir01，0x5a70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5a70，40号。
        H.at(a,v,0)
        -- 源0x5a84，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x5a98，11号。
        H.call(a,v,P["Cir01"],"Cir01",81,46,1)
        H.at(a,v,0)
        -- 源0x5acc，1号。
        H.erase(a);return
    end
    P["RCir01"]=B.part1
end

-- stage05.ecl：RCir01_at，0x5aec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5aec，40号。
        H.at(a,v,0)
        -- 源0x5b00，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5b14，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x5b2c，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0x5b48，436号。
        H.gun_count_diff(a,0,16,16,20,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x5b7c，404号。
        H.gun_angle(a,0,1.5707963705062866,0.05235987901687622)
        H.at(a,v,0)
        -- 源0x5b98，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.0,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x5bcc，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x5be8，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x5c00，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5c30，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x5c44，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x5c5c，402号。
        H.gun_sprite(a,1,2,2)
        H.at(a,v,0)
        -- 源0x5c78，406号。
        H.gun_count(a,1,2,2)
        H.at(a,v,0)
        -- 源0x5c94，404号。
        H.gun_angle(a,1,0.0,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x5cb0，405号。
        H.gun_speed(a,1,2.0,1.0)
        H.at(a,v,0)
        -- 源0x5ccc，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5cfc，409号。
        H.gun_transform(a,1,1,0,32,90,1,0.0,2.0)
        H.at(a,v,0)
        -- 源0x5d2c，355号。
        v.l[8]=H.int(20)
        H.at(a,v,0)
        -- 源0x5d50，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5d68，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5d7c，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5d9c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5db0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5dc8，10号。
        return
    end
    P["RCir01_at"]=B.part1
end

-- stage05.ecl：RCir01_at2，0x5de8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5de8，40号。
        H.at(a,v,0)
        -- 源0x5dfc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5e14，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5e28，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5e48，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5e5c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5e74，10号。
        return
    end
    P["RCir01_at2"]=B.part1
end

-- stage05.ecl：RCir02，0x5e94；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5e94，40号。
        H.at(a,v,0)
        -- 源0x5ea8，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x5ebc，11号。
        H.call(a,v,P["Cir02"],"Cir02",69,46,1)
        H.at(a,v,0)
        -- 源0x5ef0，1号。
        H.erase(a);return
    end
    P["RCir02"]=B.part1
end

-- stage05.ecl：RCir02_at，0x5f10；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5f10，40号。
        H.at(a,v,0)
        -- 源0x5f24，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5f38，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x5f50，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x5f6c，436号。
        H.gun_count_diff(a,0,3,5,5,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0x5fa0，404号。
        H.gun_angle(a,0,0.0,0.01745329238474369)
        H.at(a,v,0)
        -- 源0x5fbc，435号。
        H.gun_speed_diff(a,0,2.0,3.0,4.0,4.0,0.5,0.5,0.5,0.5)
        H.at(a,v,0)
        -- 源0x5ff0，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x600c，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x6024，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6054，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x6068，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x6080，402号。
        H.gun_sprite(a,1,3,10)
        H.at(a,v,0)
        -- 源0x609c，436号。
        H.gun_count_diff(a,1,3,5,5,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0x60d0，404号。
        H.gun_angle(a,1,0.0,0.01745329238474369)
        H.at(a,v,0)
        -- 源0x60ec，435号。
        H.gun_speed_diff(a,1,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5)
        H.at(a,v,0)
        -- 源0x6120，408号。
        H.gun_sound(a,1,7,-1)
        H.at(a,v,0)
        -- 源0x613c，438号。
        H.gun_distance(a,1,32.0)
        H.at(a,v,0)
        -- 源0x6154，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6184，355号。
        v.l[8]=H.int(12)
        H.at(a,v,0)
        -- 源0x61a8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x61c0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x61d4，404号。
        H.gun_angle(a,1,1.5707963705062866,0.01745329238474369)
        H.at(a,v,0)
        -- 源0x61f0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x6204，404号。
        H.gun_angle(a,1,-1.5707963705062866,0.01745329238474369)
        H.at(a,v,0)
        -- 源0x6220，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x6234，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6254，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x6268，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6280，10号。
        return
    end
    P["RCir02_at"]=B.part1
end

-- stage05.ecl：RCir02_at2，0x62a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x62a0，40号。
        H.at(a,v,0)
        -- 源0x62b4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x62cc，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x62e0，368号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6300，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6314，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x632c，10号。
        return
    end
    P["RCir02_at2"]=B.part1
end

-- stage05.ecl：RPhantom00，0x634c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x634c，40号。
        H.at(a,v,0)
        -- 源0x6360，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6374，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x638c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x63a0，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",94,1)
        H.at(a,v,0)
        -- 源0x63d0，1号。
        H.erase(a);return
    end
    P["RPhantom00"]=B.part1
end

-- stage05.ecl：RPhantom01，0x63f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x63f0，40号。
        H.at(a,v,0)
        -- 源0x6404，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6418，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x6430，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x6444，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",94,1)
        H.at(a,v,0)
        -- 源0x6474，1号。
        H.erase(a);return
    end
    P["RPhantom01"]=B.part1
end

-- stage05.ecl：RPhantom02，0x6494；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6494，40号。
        H.at(a,v,0)
        -- 源0x64a8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x64bc，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x64d4，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x64e8，11号。
        H.call(a,v,P["Phantom02"],"Phantom02",94,1)
        H.at(a,v,0)
        -- 源0x6518，1号。
        H.erase(a);return
    end
    P["RPhantom02"]=B.part1
end

-- stage05.ecl：YPhantom00，0x6538；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6538，40号。
        H.at(a,v,0)
        -- 源0x654c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6560，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6574，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x658c，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",100,1)
        H.at(a,v,0)
        -- 源0x65bc，1号。
        H.erase(a);return
    end
    P["YPhantom00"]=B.part1
end

-- stage05.ecl：YPhantom01，0x65dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x65dc，40号。
        H.at(a,v,0)
        -- 源0x65f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6604，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x6618，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x6630，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",100,1)
        H.at(a,v,0)
        -- 源0x6660，1号。
        H.erase(a);return
    end
    P["YPhantom01"]=B.part1
end

-- stage05.ecl：YPhantom02，0x6680；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6680，40号。
        H.at(a,v,0)
        -- 源0x6694，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x66a8，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x66bc，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x66d4，11号。
        H.call(a,v,P["Phantom02"],"Phantom02",100,1)
        H.at(a,v,0)
        -- 源0x6704，1号。
        H.erase(a);return
    end
    P["YPhantom02"]=B.part1
end

-- stage05.ecl：main，0x6724；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6724，40号。
        H.at(a,v,0)
        -- 源0x6738，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x674c，257号。
        H.spawn(a,257,"MapleEnemy",0.0,-16.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x6780，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x6794，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x67a8，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,0)
        -- 源0x67c8，83号。
        v.origin=v.origin+H.int(500)
        H.at(a,v,0)
        -- 源0x67dc，11号。
        H.call(a,v,P["MainSub01"],"MainSub01")
        H.at(a,v,0)
        -- 源0x67fc，83号。
        v.origin=v.origin+H.int(400)
        H.at(a,v,0)
        -- 源0x6810，11号。
        H.call(a,v,P["MainSub02"],"MainSub02")
        H.at(a,v,0)
        -- 源0x6830，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x6844，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,0)
        -- 源0x6864，83号。
        v.origin=v.origin+H.int(1800)
        H.at(a,v,0)
        -- 源0x6878，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0x6898，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x68ac，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,0)
        -- 源0x68cc，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x68e0，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,0)
        -- 源0x6900，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x6914，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,0)
        -- 源0x6934，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x6948，338号。
        H.dialog(a,0)
        H.at(a,v,0)
        -- 源0x695c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x696c，257号。
        H.spawn(a,257,"Boss",216.0,64.0,40,1000,1)
        H.at(a,v,0)
        -- 源0x699c，340号。
        H.boss_wait(a,v)
        H.at(a,v,0)
        -- 源0x69ac，338号。
        H.dialog(a,1)
        H.at(a,v,0)
        -- 源0x69c0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x69d0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x69e8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x69fc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6a10，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,40000)
        -- 源0x6a28，0号。
        H.at(a,v,40000)
        -- 源0x6a38，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

-- stage05mboss.ecl：MBoss，0xe4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe4，40号。
        H.at(a,v,0)
        -- 源0xf8，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x10c，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x120，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0x138，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x14c，262号。
        H.anm_main(a,0,11)
        H.at(a,v,0)
        -- 源0x164，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x178，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x190，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x1a8，331号。
        H.life(a,17000)
        H.at(a,v,0)
        -- 源0x1bc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1d0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1e4，334号。
        H.interrupt(a,0,9000,1620,"MBoss2")
        H.at(a,v,0)
        -- 源0x20c，341号。
        H.timeout(a,0,"MBossEscape")
        H.at(a,v,0)
        -- 源0x230，347号。
        H.life_marker(a,0,9000.0,-3092225)
        H.at(a,v,0)
        -- 源0x24c，347号。
        H.life_marker(a,1,1500.0,-24416)
        H.at(a,v,0)
        -- 源0x268，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x27c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x29c，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0x2b0，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,0)
        -- 源0x2d0，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x2e4，440号。
        H.fog(a,160.0,8421376)
        H.at(a,v,0)
        -- 源0x2fc，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x310，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,0)
        -- 源0x328，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x33c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x350，11号。
        H.call(a,v,P["MBoss1"],"MBoss1")
        H.at(a,v,0)
        -- 源0x36c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x384，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x398，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3ac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3c4，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage05mboss.ecl：MBoss1，0x3e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3e4，40号。
        H.at(a,v,0)
        -- 源0x3f8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x410，15号。
        H.async(a,P["MBoss1_at"],"MBoss1_at",nil)
        H.at(a,v,0)
        -- 源0x430，368号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x450，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x464，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x47c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x490，15号。
        H.async(a,P["MBoss1_at2"],"MBoss1_at2",nil)
        H.at(a,v,0)
        -- 源0x4b0，368号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x4d0，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x4e4，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x4fc，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x510，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x524，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x53c，10号。
        return
    end
    P["MBoss1"]=B.part1
end

-- stage05mboss.ecl：MBoss1_at，0x55c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x55c，40号。
        H.at(a,v,0)
        -- 源0x570，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x584，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x59c，402号。
        H.gun_sprite(a,0,5,6)
        H.at(a,v,0)
        -- 源0x5b8，436号。
        H.gun_count_diff(a,0,16,32,32,32,1,1,1,1)
        H.at(a,v,0)
        -- 源0x5ec，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x608，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x624，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x654，356号。
        v.l[8]=H.f32(0.11666666716337204)
        H.at(a,v,0)
        -- 源0x678，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x6a8，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6bc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d0，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x6e4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6f8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x70c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x720，42号。
        H.push(v,260)
        H.at(a,v,0)
        -- 源0x734，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x748，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x760，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x790，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7ac，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7c4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7d8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7ec，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x800，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x810，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x824，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x838，44号。
        H.push(v,0.15176799893379211)
        H.at(a,v,0)
        -- 源0x84c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x85c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x870，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x884，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x898，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x8a8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8bc，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x8d0，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8e4，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x8f8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x910，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x924，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x938，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x950，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x980，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x99c，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9b4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9c8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9dc，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x9f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa00，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa14，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xa28，44号。
        H.push(v,0.16890299320220947)
        H.at(a,v,0)
        -- 源0xa3c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xa4c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa60，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xa74，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xa88，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0xa98，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xaac，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0xac0，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xad4，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xae8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xb00，10号。
        return
    end
    P["MBoss1_at"]=B.part1
end

-- stage05mboss.ecl：MBoss1_at2，0xb20；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb20，40号。
        H.at(a,v,0)
        -- 源0xb34，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xb48，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xb60，402号。
        H.gun_sprite(a,0,5,6)
        H.at(a,v,0)
        -- 源0xb7c，436号。
        H.gun_count_diff(a,0,16,32,32,32,1,1,1,1)
        H.at(a,v,0)
        -- 源0xbb0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xbcc，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0xbe8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc18，356号。
        v.l[8]=H.f32(0.0833333358168602)
        H.at(a,v,0)
        -- 源0xc3c，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0xc6c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xc80，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xc94，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0xca8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xcbc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xcd0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xce4，42号。
        H.push(v,260)
        H.at(a,v,0)
        -- 源0xcf8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd0c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd24，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd54，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xd70，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd88，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd9c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xdb0，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0xdc4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xdd4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xde8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xdfc，44号。
        H.push(v,0.15176799893379211)
        H.at(a,v,0)
        -- 源0xe10，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe20，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0xe80，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xe94，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xea8，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0xeb8，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xecc，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0xee0，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xef4，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xf08，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf20，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xf34，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf48，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xf60，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf90，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xfac，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xfc4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xfd8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xfec，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1000，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1010，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1024，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1038，44号。
        H.push(v,0.16890299320220947)
        H.at(a,v,0)
        -- 源0x104c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x105c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x10bc，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x10d0，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x10e4，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x10f4，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1108，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x111c，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1130，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1144，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x115c，10号。
        return
    end
    P["MBoss1_at2"]=B.part1
end

-- stage05mboss.ecl：MBoss2，0x117c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x117c，40号。
        H.at(a,v,0)
        -- 源0x1190，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x11a0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x11b0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x11c4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x11d8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x11e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1200，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1214，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x122c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1240，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1250，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1260，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1274，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x1284，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1298，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x12a8，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x12c0，327号。
        H.drop_extra(a,2,6)
        H.at(a,v,0)
        -- 源0x12d8，328号。
        H.drop_area(a,64.0,64.0)
        H.at(a,v,0)
        -- 源0x12f0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1304，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1318，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1328，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1340，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x1354，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1364，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1378，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x138c，334号。
        H.interrupt(a,0,1500,1200,"MBossCard1")
        H.at(a,v,0)
        -- 源0x13b8，341号。
        H.timeout(a,0,"MBossEscape")
        H.at(a,v,0)
        -- 源0x13dc，344号。
        a.chapter=7
        H.at(a,v,0)
        -- 源0x13f0，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1408，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x141c，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x1434，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1448，15号。
        H.async(a,P["MBoss2_at"],"MBoss2_at",nil)
        H.at(a,v,0)
        -- 源0x1468，368号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x1488，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x149c，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x14b4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x14c8，15号。
        H.async(a,P["MBoss2_at2"],"MBoss2_at2",nil)
        H.at(a,v,0)
        -- 源0x14e8，368号。
        v.origin=v.origin+H.int(120)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1508，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x151c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1534，10号。
        return
    end
    P["MBoss2"]=B.part1
end

-- stage05mboss.ecl：MBoss2_at，0x1554；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1554，40号。
        H.at(a,v,0)
        -- 源0x1568，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x157c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1594，402号。
        H.gun_sprite(a,0,5,2)
        H.at(a,v,0)
        -- 源0x15b0，436号。
        H.gun_count_diff(a,0,12,24,24,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0x15e4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1600，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x161c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x164c，356号。
        v.l[8]=H.f32(0.10000000149011612)
        H.at(a,v,0)
        -- 源0x1670，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x16a0，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x16b4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x16c8，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x16dc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x16f0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1704，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1718，42号。
        H.push(v,300)
        H.at(a,v,0)
        -- 源0x172c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1740，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1758，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1788，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x17a4，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x17bc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x17d0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x17e4，44号。
        H.push(v,6.0)
        H.at(a,v,0)
        -- 源0x17f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1808，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x181c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1830，44号。
        H.push(v,0.15176799893379211)
        H.at(a,v,0)
        -- 源0x1844，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1854，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1868，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x187c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1890，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x18a0，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x18b4，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x18c8，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x18dc，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x18f0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1908，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x191c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1930，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1948，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1978，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1994，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x19ac，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x19c0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x19d4，44号。
        H.push(v,6.0)
        H.at(a,v,0)
        -- 源0x19e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x19f8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a0c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1a20，44号。
        H.push(v,0.16890299320220947)
        H.at(a,v,0)
        -- 源0x1a34，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1a44，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a58，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1a6c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1a80，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x1a90，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1aa4，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x1ab8，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1acc，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1ae0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1af8，10号。
        return
    end
    P["MBoss2_at"]=B.part1
end

-- stage05mboss.ecl：MBoss2_at2，0x1b18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1b18，40号。
        H.at(a,v,0)
        -- 源0x1b2c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1b40，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1b58，402号。
        H.gun_sprite(a,0,5,2)
        H.at(a,v,0)
        -- 源0x1b74，436号。
        H.gun_count_diff(a,0,12,24,24,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1ba8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1bc4，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x1be0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1c10，356号。
        v.l[8]=H.f32(0.10000000149011612)
        H.at(a,v,0)
        -- 源0x1c34，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x1c64，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1c78，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c8c，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x1ca0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1cb4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1cc8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1cdc，42号。
        H.push(v,300)
        H.at(a,v,0)
        -- 源0x1cf0，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d04，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1d1c，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1d4c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1d68，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1d80，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1d94，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1da8，44号。
        H.push(v,6.0)
        H.at(a,v,0)
        -- 源0x1dbc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1dcc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1de0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1df4，44号。
        H.push(v,0.15176799893379211)
        H.at(a,v,0)
        -- 源0x1e08，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1e18，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e2c，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x1e40，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1e54，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x1e64，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e78，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x1e8c，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1ea0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1eb4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1ecc，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1ee0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ef4，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1f0c，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1f3c，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1f58，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1f70，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1f84，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1f98，44号。
        H.push(v,6.0)
        H.at(a,v,0)
        -- 源0x1fac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1fbc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1fd0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1fe4，44号。
        H.push(v,0.16890299320220947)
        H.at(a,v,0)
        -- 源0x1ff8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2008，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x201c，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x2030，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x2044，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x2054，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2068，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x207c，83号。
        v.origin=v.origin+H.int(3)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2090，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x20a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x20bc，10号。
        return
    end
    P["MBoss2_at2"]=B.part1
end

-- stage05mboss.ecl：MBossCard1，0x20dc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x20dc，40号。
        H.at(a,v,0)
        -- 源0x20f0，344号。
        a.chapter=15
        H.at(a,v,0)
        -- 源0x2104，334号。
        H.interrupt(a,0,0,2220,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x2168，359号。
        H.spell(a,120,2220,0,"猫符「怨霊猫乱歩」",359)
        H.at(a,v,0)
        -- 源0x219c，334号。
        H.interrupt(a,0,0,2220,"MBossEscape")
        H.at(a,v,0)
        -- 源0x21c8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x21d8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x21ec，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x2200，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x2234，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2244，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2258，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x226c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x227c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2294，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x22a8，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x22b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x22cc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x22e0，325号。
        a.limit=nil
        H.at(a,v,30)
        -- 源0x22f0，263号。
        H.effect(a,0,131)
        H.at(a,v,90)
        -- 源0x2308，0号。
        H.at(a,v,90)
        -- 源0x2318，322号。
        H.flags(a,12,true)
        H.at(a,v,90)
        -- 源0x232c，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,90)
        -- 源0x2340，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x2354，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,90)
        -- 源0x2364，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(90);return B.part8(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,90)
        -- 源0x237c，283号。
        H.position_time(a,1,60,4,0.0,-1040187392)
        H.at(a,v,90)
        -- 源0x239c，12号。
        v.origin=H.clock(a)-(90);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,90)
        -- 源0x23b4，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x23c8，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x23dc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x23f0，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2404，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2414，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2424，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),160.0)
        H.at(a,v,90)
        -- 源0x2444，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2458，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x246c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x24a4，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x24b8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x24cc，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x24e0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x24f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2500，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x2520，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2534，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2548，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2580，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x2594，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x25a8，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x25bc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x25cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x25dc，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x25fc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2610，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2624，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x265c，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x2670，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2684，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2698，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x26a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x26b8，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),256.0)
        H.at(a,v,90)
        -- 源0x26d8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x26ec，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2700，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2738，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x274c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2760，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2774，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2784，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2794，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),288.0)
        H.at(a,v,90)
        -- 源0x27b4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x27c8，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x27dc，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2814，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x2828，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x283c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2850，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2860，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2870，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x2890，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x28a4，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x28b8，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x28f0，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x2904，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2918，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x292c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x293c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x294c，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),354.0)
        H.at(a,v,90)
        -- 源0x296c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2980，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2994，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x29cc，281号。
        H.position_time(a,0,60,4,352.0,354.0)
        H.at(a,v,90)
        -- 源0x29ec，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2a00，280号。
        H.position(a,0,352.0,128.0)
        H.at(a,v,90)
        -- 源0x2a18，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2a2c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x2a4c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,90)
        -- 源0x2a60，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2a74，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x2a88，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2a9c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2ab0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2ac0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2ad0，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),160.0)
        H.at(a,v,90)
        -- 源0x2af0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2b04，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2b3c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2b50，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x2b64，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2b78，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2b8c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2b9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2bac，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x2bcc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2be0，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2c18，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2c2c，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x2c40，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2c54，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2c68，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2c78，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2c88，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x2ca8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2cbc，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2cf4，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2d08，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x2d1c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2d30，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2d44，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2d54，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2d64，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),256.0)
        H.at(a,v,90)
        -- 源0x2d84，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2d98，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2dd0，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2de4，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x2df8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2e0c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2e20，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2e30，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2e40，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),288.0)
        H.at(a,v,90)
        -- 源0x2e60，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2e74，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2eac，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2ec0，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x2ed4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2ee8，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2efc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2f0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2f1c，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x2f3c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x2f50，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x2f88，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x2f9c，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x2fb0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x2fc4，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x2fd8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x2fe8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x2ff8，281号。
        H.position_time(a,0,60,4,H.read(a,v,-1),354.0)
        H.at(a,v,90)
        -- 源0x3018，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x302c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3064，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3078，281号。
        H.position_time(a,0,60,4,-352.0,354.0)
        H.at(a,v,90)
        -- 源0x3098，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x30ac，280号。
        H.position(a,0,-352.0,128.0)
        H.at(a,v,90)
        -- 源0x30c4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,90)
        -- 源0x30d8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x30f8，83号。
        v.origin=v.origin+H.int(200)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,90)
        -- 源0x310c，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x3120，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,90)
        -- 源0x3138，12号。
        v.origin=H.clock(a)-(90);return B.part11(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,90)
        -- 源0x3150，355号。
        v.l[16]=H.int(30)
        H.at(a,v,90)
        -- 源0x3174，283号。
        H.position_time(a,1,(v.l[16] or 0),4,0.0,-1040187392)
        H.at(a,v,90)
        -- 源0x3194，12号。
        v.origin=H.clock(a)-(90);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,90)
        -- 源0x31ac，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x31c0，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x31d4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x31e8，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x31fc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x320c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x321c，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x323c，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3250，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3264，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x329c，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x32b0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x32c4，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x32d8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x32e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x32f8，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x3318，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x332c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3340，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3378，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x338c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x33a0，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x33b4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x33c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x33d4，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),160.0)
        H.at(a,v,90)
        -- 源0x33f4，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3408，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x341c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3454，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3468，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x347c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3490，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x34a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x34b0，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),128.0)
        H.at(a,v,90)
        -- 源0x34d0，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x34e4，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x34f8，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3530，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x3544，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3558，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x356c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x357c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x358c，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x35ac，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x35c0，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x35d4，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x360c，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3620，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3634，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3648，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3658，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3668，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x3688，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x369c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x36b0，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x36e8，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x36fc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3710，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3724，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3734，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3744，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),240.0)
        H.at(a,v,90)
        -- 源0x3764，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3778，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x378c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x37c4，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x37d8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x37ec，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3800，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3810，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3820，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),256.0)
        H.at(a,v,90)
        -- 源0x3840，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3854，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3868，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x38a0，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x38b4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x38c8，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x38dc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x38ec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x38fc，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x391c，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3930，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3944，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x397c，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3990，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x39a4，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x39b8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x39c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x39d8，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),300.0)
        H.at(a,v,90)
        -- 源0x39f8，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3a0c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3a20，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3a58，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x3a6c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3a80，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3a94，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3aa4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3ab4，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x3ad4，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3ae8，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3afc，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3b34，281号。
        H.position_time(a,0,(v.l[16] or 0),4,352.0,354.0)
        H.at(a,v,90)
        -- 源0x3b54，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3b68，280号。
        H.position(a,0,352.0,128.0)
        H.at(a,v,90)
        -- 源0x3b80，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3b94，281号。
        H.position_time(a,0,(v.l[16] or 0),4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x3bb4，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,90)
        -- 源0x3bc8，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3bdc，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x3bf0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3c04，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3c18，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3c28，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3c38，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x3c58，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3c6c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3c80，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3cb8，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3ccc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3ce0，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3cf4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3d04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3d14，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x3d34，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3d48，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3d5c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3d94，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x3da8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3dbc，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3dd0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3de0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3df0，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),160.0)
        H.at(a,v,90)
        -- 源0x3e10，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3e24，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3e38，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3e70，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x3e84，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3e98，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3eac，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3ebc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3ecc，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),128.0)
        H.at(a,v,90)
        -- 源0x3eec，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3f00，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3f14，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x3f4c，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x3f60，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x3f74，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x3f88，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x3f98，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x3fa8，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),192.0)
        H.at(a,v,90)
        -- 源0x3fc8，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x3fdc，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x3ff0，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x4028，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x403c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x4050，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x4064，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x4074，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x4084，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),224.0)
        H.at(a,v,90)
        -- 源0x40a4，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x40b8，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x40cc，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x4104，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x4118，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x412c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x4140，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x4150，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x4160，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),240.0)
        H.at(a,v,90)
        -- 源0x4180，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x4194，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x41a8，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x41e0，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x41f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x4208，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x421c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x422c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x423c，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),256.0)
        H.at(a,v,90)
        -- 源0x425c，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x4270，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x4284，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x42bc，42号。
        H.push(v,148)
        H.at(a,v,90)
        -- 源0x42d0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x42e4，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x42f8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x4308，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x4318，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x4338，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x434c，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x4360，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x4398，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x43ac，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x43c0，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x43d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x43e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x43f4，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),300.0)
        H.at(a,v,90)
        -- 源0x4414，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x4428，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x443c，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x4474，42号。
        H.push(v,-148)
        H.at(a,v,90)
        -- 源0x4488，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,90)
        -- 源0x449c，42号。
        H.push(v,16)
        H.at(a,v,90)
        -- 源0x44b0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,90)
        -- 源0x44c0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,90)
        -- 源0x44d0，281号。
        H.position_time(a,0,(v.l[16] or 0),4,H.read(a,v,-1),320.0)
        H.at(a,v,90)
        -- 源0x44f0，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x4504，336号。
        H.sound(a,15)
        H.at(a,v,90)
        -- 源0x4518，256号。
        H.spawn(a,256,"MBossCard2_et",0.0,0.0,1000,10,0)
        H.at(a,v,90)
        -- 源0x4550，281号。
        H.position_time(a,0,(v.l[16] or 0),4,-352.0,354.0)
        H.at(a,v,90)
        -- 源0x4570，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x4584，280号。
        H.position(a,0,352.0,128.0)
        H.at(a,v,90)
        -- 源0x459c，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x45b0，281号。
        H.position_time(a,0,(v.l[16] or 0),4,0.0,128.0)
        H.at(a,v,90)
        -- 源0x45d0，83号。
        v.origin=v.origin+H.int(200)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,90)
        -- 源0x45e4，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x45f8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,90)
        -- 源0x4610，10号。
        return
    end
    P["MBossCard1"]=B.part1
end

-- stage05mboss.ecl：MBossCard2_at，0x4630；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4630，40号。
        H.at(a,v,0)
        -- 源0x4644，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4658，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x4670，402号。
        H.gun_sprite(a,0,5,0)
        H.at(a,v,0)
        -- 源0x468c，436号。
        H.gun_count_diff(a,0,16,24,24,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0x46c0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x46dc，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x46f8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4728，409号。
        H.gun_transform(a,0,2,0,16777216,5,6,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4758，356号。
        v.l[8]=H.f32(0.02500000037252903)
        H.at(a,v,0)
        -- 源0x477c，409号。
        H.gun_transform(a,0,3,0,4,120,-999999,(v.l[8] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x47ac，355号。
        v.l[12]=H.int(4)
        H.at(a,v,0)
        -- 源0x47d0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x47e4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x47f8，42号。
        H.push(v,200)
        H.at(a,v,0)
        -- 源0x480c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4820，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4838，409号。
        H.gun_transform(a,0,1,0,4096,(v.l[16] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4868，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4880，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x489c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x48b0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x48c4，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x48d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x48e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x48fc，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x4910，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x4924，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x4934，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4948，83号。
        v.origin=v.origin+H.int(8)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x495c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x4970，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4988，10号。
        return
    end
    P["MBossCard2_at"]=B.part1
end

-- stage05mboss.ecl：MBossCard2_et，0x49a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x49a8，40号。
        H.at(a,v,0)
        -- 源0x49bc，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x49d0，11号。
        H.call(a,v,P["MBossCard2_at"],"MBossCard2_at")
        H.at(a,v,0)
        -- 源0x49f4，1号。
        H.erase(a);return
    end
    P["MBossCard2_et"]=B.part1
end

-- stage05mboss.ecl：MBossEscape，0x4a14；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a14，40号。
        H.at(a,v,0)
        -- 源0x4a28，334号。
        H.interrupt(a,0,-1,0,"")
        H.at(a,v,0)
        -- 源0x4a4c，334号。
        H.interrupt(a,1,-1,0,"")
        H.at(a,v,0)
        -- 源0x4a70，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x4a80，325号。
        a.limit=nil
        H.at(a,v,0)
        -- 源0x4a90，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x4aa4，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x4ab8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4ac8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4ae0，281号。
        H.position_time(a,0,60,4,-160.0,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x4b00，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4b18，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x4b2c，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x4b40，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4b50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4b68，281号。
        H.position_time(a,0,60,4,160.0,H.read(a,v,-9996))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4b88，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4b98，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4bac，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4bc0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4bd0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4be8，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x4bfc，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x4c14，421号。
        H.cancel(a,640.0,false)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x4c28，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x4c38，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4c48，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x4c5c，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x4c6c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4c80，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4c94，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4ca4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x4cbc，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x4ccc，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x4ce4，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x4cfc，328号。
        H.drop_area(a,64.0,64.0)
        H.at(a,v,0)
        -- 源0x4d14，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4d28，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4d3c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4d4c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x4d64，330号。
        H.drop_main(a,5)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x4d78，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x4d88，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x4d9c，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x4db0，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x4dc8，259号。
        H.anm_slot(a,2,-1)
        H.at(a,v,0)
        -- 源0x4de0，440号。
        H.fog(a,0.0,8421376)
        H.at(a,v,0)
        -- 源0x4df8，332号。
        H.boss_slot(a,-1)
        H.at(a,v,0)
        -- 源0x4e0c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x4e20，322号。
        H.flags(a,16,true)
        H.at(a,v,0)
        -- 源0x4e34，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x4e48，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4e5c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4e6c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x4e84，281号。
        H.position_time(a,0,60,4,-224.0,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x4ea4，12号。
        v.origin=H.clock(a)-(0);return B.part14(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x4ebc，281号。
        H.position_time(a,0,60,4,224.0,H.read(a,v,-9996))
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x4edc，344号。
        a.chapter=0
        H.at(a,v,60)
        -- 源0x4ef0，1号。
        H.erase(a);return
    end
    P["MBossEscape"]=B.part1
end

-- stage05boss.ecl：BBoss1Girl，0x570；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x570，40号。
        H.at(a,v,0)
        -- 源0x584，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x598，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x5ac，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x5c4，42号。
        H.push(v,109)
        H.at(a,v,0)
        -- 源0x5d8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5ec，11号。
        H.call(a,v,P["Boss1Girl"],"Boss1Girl",0,1)
        H.at(a,v,0)
        -- 源0x61c，1号。
        H.erase(a);return
    end
    P["BBoss1Girl"]=B.part1
end

-- stage05boss.ecl：BBoss2Phantom，0x63c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x63c，40号。
        H.at(a,v,0)
        -- 源0x650，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x664，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x678，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x690，11号。
        H.call(a,v,P["Boss2Phantom"],"Boss2Phantom",98,1)
        H.at(a,v,0)
        -- 源0x6c4，1号。
        H.erase(a);return
    end
    P["BBoss2Phantom"]=B.part1
end

-- stage05boss.ecl：BBoss3Phantom，0x6e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6e4，40号。
        H.at(a,v,0)
        -- 源0x6f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x70c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x720，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x738，11号。
        H.call(a,v,P["Boss3Phantom"],"Boss3Phantom",98,1)
        H.at(a,v,0)
        -- 源0x76c，1号。
        H.erase(a);return
    end
    P["BBoss3Phantom"]=B.part1
end

-- stage05boss.ecl：BBossCard2Phantom，0x78c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x78c，40号。
        H.at(a,v,0)
        -- 源0x7a0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7b4，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0x7c8，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x7e0，11号。
        H.call(a,v,P["BossCard2Phantom"],"BossCard2Phantom",98,1)
        H.at(a,v,0)
        -- 源0x818，1号。
        H.erase(a);return
    end
    P["BBossCard2Phantom"]=B.part1
end

-- stage05boss.ecl：BBossCard3Phantom，0x838；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x838，40号。
        H.at(a,v,0)
        -- 源0x84c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x860，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x874，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x88c，11号。
        H.call(a,v,P["BossCard3Phantom"],"BossCard3Phantom",98,1)
        H.at(a,v,0)
        -- 源0x8c4，1号。
        H.erase(a);return
    end
    P["BBossCard3Phantom"]=B.part1
end

-- stage05boss.ecl：BBossCard4Phantom，0x8e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8e4，40号。
        H.at(a,v,0)
        -- 源0x8f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x90c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x920，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x938，11号。
        H.call(a,v,P["BossCard4Phantom"],"BossCard4Phantom",98,1)
        H.at(a,v,0)
        -- 源0x970，1号。
        H.erase(a);return
    end
    P["BBossCard4Phantom"]=B.part1
end

-- stage05boss.ecl：Boss，0x990；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x990，40号。
        H.at(a,v,0)
        -- 源0x9a4，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0x9b8，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x9cc，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x9e0，262号。
        H.anm_main(a,0,11)
        H.at(a,v,0)
        -- 源0x9f8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xa0c，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xa24，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xa3c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xa50，331号。
        H.life(a,12500)
        H.at(a,v,0)
        -- 源0xa64，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xa84，440号。
        H.fog(a,160.0,8453888)
        H.at(a,v,0)
        -- 源0xa9c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xab0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xac4，344号。
        a.chapter=24
        H.at(a,v,60)
        -- 源0xad8，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0xae8，344号。
        a.chapter=24
        H.at(a,v,60)
        -- 源0xafc，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0xb10，259号。
        H.anm_slot(a,0,8)
        H.at(a,v,61)
        -- 源0xb28，339号。
        H.dialog_wait(a,v)
        H.at(a,v,61)
        -- 源0xb38，262号。
        H.anm_main(a,0,0)
        H.at(a,v,61)
        -- 源0xb50，344号。
        a.chapter=24
        H.at(a,v,61)
        -- 源0xb64，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,61)
        -- 源0xb84，331号。
        H.life(a,12500)
        H.at(a,v,61)
        -- 源0xb98，258号。
        H.select_anm(a,0)
        H.at(a,v,61)
        -- 源0xbac，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,61)
        -- 源0xbc4，258号。
        H.select_anm(a,2)
        H.at(a,v,61)
        -- 源0xbd8，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,61)
        -- 源0xbf4，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage05boss.ecl：Boss1，0xc14；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc14，40号。
        H.at(a,v,0)
        -- 源0xc28，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0xc38，347号。
        H.life_marker(a,0,1500.0,-24448)
        H.at(a,v,0)
        -- 源0xc54，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0xc68，334号。
        H.interrupt(a,0,1500,3000,"BossCard1")
        H.at(a,v,0)
        -- 源0xc94，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0xca8，360号。
        a.stars=3
        H.at(a,v,0)
        -- 源0xcbc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0xcdc，15号。
        H.async(a,P["Boss1AtNear"],"Boss1AtNear",nil)
        H.at(a,v,0)
        -- 源0xcfc，15号。
        H.async(a,P["Boss1At2"],"Boss1At2",nil)
        H.at(a,v,0)
        -- 源0xd1c，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xd30，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0xd44，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xd58，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,0.03141592815518379,6)
        H.at(a,v,0)
        -- 源0xd88，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xd9c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xdb0，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0xdc4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xdd8，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,-0.03141592815518379,10)
        H.at(a,v,0)
        -- 源0xe08，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0xe1c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe34，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xe48，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0xe5c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xe70，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,0.03141592815518379,6)
        H.at(a,v,0)
        -- 源0xea0，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xeb4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xec8，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0xedc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0xef0，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil,-0.03141592815518379,10)
        H.at(a,v,0)
        -- 源0xf20，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xf34，292号。
        H.wander(a,0,60,4,1.0)
        H.at(a,v,0)
        -- 源0xf50，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf64，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf78，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf90，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage05boss.ecl：Boss1At1，0xfb0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfb0，40号。
        H.at(a,v,0)
        -- 源0xfc4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xfd8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xff0，402号。
        H.gun_sprite(a,0,5,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x100c，436号。
        H.gun_count_diff(a,0,24,32,36,48,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1040，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x105c，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x1078，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x10a8，409号。
        H.gun_transform(a,0,1,0,1024,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x10d8，356号。
        v.l[16]=H.f32(0.0833333358168602)
        H.at(a,v,0)
        -- 源0x10fc，409号。
        H.gun_transform(a,0,3,0,4,60,-999999,(v.l[16] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x112c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x1140，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x1154，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1164，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x1178，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x118c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x119c，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x11b8，346号。
        a.protect=48.0
        H.at(a,v,0)
        -- 源0x11cc，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x11e0，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x11f4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1208，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x121c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1230，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1244，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x1258，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x126c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1284，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x12b4，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x12d0，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x12e8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x12fc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1310，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x1324，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1334，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1348，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x135c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1370，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1380，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1394，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x13a8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x13bc，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x13cc，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x13e0，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x13f4，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1408，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x141c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1434，10号。
        return
    end
    P["Boss1At1"]=B.part1
end

-- stage05boss.ecl：Boss1At2，0x1454；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1454，40号。
        H.at(a,v,0)
        -- 源0x1468，355号。
        v.l[4]=H.int(18)
        H.at(a,v,0)
        -- 源0x148c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x14a0，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x14b4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x14c8，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x14d8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x14e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x14fc，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x1510，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1524，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x153c，256号。
        H.spawn(a,256,"RBoss1Girl",0.0,0.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x1570，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1584，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x1598，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x15ac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x15bc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x15d0，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x15e4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x15f8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1610，10号。
        return
    end
    P["Boss1At2"]=B.part1
end

-- stage05boss.ecl：Boss1AtNear，0x1630；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1630，40号。
        H.at(a,v,0)
        -- 源0x1644，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1658，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x166c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x1680，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1698，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0x16ac，44号。
        H.push(v,96.0)
        H.at(a,v,0)
        -- 源0x16c0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x16d0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x16e8，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x16fc，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x1714，402号。
        H.gun_sprite(a,2,24,6)
        H.at(a,v,0)
        -- 源0x1730，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x174c，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1768，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x1784，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x17b4，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x17c8，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x17dc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x17ec，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x1800，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1814，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1824，439号。
        H.gun_absolute(a,2,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1840，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1854，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1868，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x187c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x188c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x189c，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x18b8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x18cc，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x18e0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x18f0，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x1904，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1914，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x1930，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x1944，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x195c，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x1970，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x1988，402号。
        H.gun_sprite(a,2,24,6)
        H.at(a,v,0)
        -- 源0x19a4，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x19c0，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x19dc，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x19f8，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1a28，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x1a3c，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x1a50，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1a60，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x1a74，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1a88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1a98，439号。
        H.gun_absolute(a,2,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1ab4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ac8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1adc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1af0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1b00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1b10，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x1b2c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1b40，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x1b54，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1b64，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x1b78，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1b88，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x1ba4，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x1bb8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1bcc，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0x1be0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1bf0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c04，368号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1c24，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1c38，44号。
        H.push(v,0.04908699914813042)
        H.at(a,v,0)
        -- 源0x1c4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1c5c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c70，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1c84，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1c98，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1cb0，10号。
        return
    end
    P["Boss1AtNear"]=B.part1
end

-- stage05boss.ecl：Boss1Girl，0x1cd0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1cd0，40号。
        H.at(a,v,0)
        -- 源0x1ce4，278号。
        H.anm_death(a,2)
        H.at(a,v,0)
        -- 源0x1cf8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1d0c，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1d24，322号。
        H.flags(a,1100,true)
        H.at(a,v,0)
        -- 源0x1d38，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x1d50，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1d68，334号。
        H.interrupt(a,0,0,-1,"Boss1GirlDead")
        H.at(a,v,0)
        -- 源0x1d98，284号。
        H.velocity(a,0,H.read(a,v,-9981),5.0)
        H.at(a,v,0)
        -- 源0x1db0，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,60)
        -- 源0x1dd0，0号。
        H.at(a,v,60)
        -- 源0x1de0，12号。
        v.origin=H.clock(a)-(60);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x1df8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x1e0c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1e20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x1e38，10号。
        return
    end
    P["Boss1Girl"]=B.part1
end

-- stage05boss.ecl：Boss1Girl2，0x1e58；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1e58，40号。
        H.at(a,v,0)
        -- 源0x1e6c，42号。
        H.push(v,113)
        H.at(a,v,0)
        -- 源0x1e80，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1e94，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1ea8，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x1ebc，259号。
        H.anm_slot(a,2,119)
        H.at(a,v,0)
        -- 源0x1ed4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1ee8，334号。
        H.interrupt(a,0,0,-1,"Boss1GirlDead2")
        H.at(a,v,0)
        -- 源0x1f18，262号。
        H.anm_main(a,0,20)
        H.at(a,v,0)
        -- 源0x1f30，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x1f48，331号。
        H.life(a,100)
        H.at(a,v,0)
        -- 源0x1f5c，322号。
        H.flags(a,1024,true)
        H.at(a,v,0)
        -- 源0x1f70，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x1f84，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x1f9c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1fb4，15号。
        H.async(a,P["Boss1Girl2_at"],"Boss1Girl2_at",nil)
        H.at(a,v,0)
        -- 源0x1fd8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ff0，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x2004，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2018，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x202c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x203c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x204c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2060，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2074，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2088，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2098，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x20a8，284号。
        H.velocity(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x20c0，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x20d4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x20e8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2100，10号。
        return
    end
    P["Boss1Girl2"]=B.part1
end

-- stage05boss.ecl：Boss1Girl2_at，0x2120；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2120，40号。
        H.at(a,v,0)
        -- 源0x2134，83号。
        v.origin=v.origin+H.int(500)
        H.at(a,v,0)
        -- 源0x2148，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2160，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2174，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x218c，402号。
        H.gun_sprite(a,0,0,6)
        H.at(a,v,0)
        -- 源0x21a8，406号。
        H.gun_count(a,0,3,1)
        H.at(a,v,0)
        -- 源0x21c4，404号。
        H.gun_angle(a,0,0.0,0.19634954631328583)
        H.at(a,v,0)
        -- 源0x21e0，405号。
        H.gun_speed(a,0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x21fc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x222c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x2248，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x225c，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2270，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2284，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x229c，10号。
        return
    end
    P["Boss1Girl2_at"]=B.part1
end

-- stage05boss.ecl：Boss1GirlDead，0x22bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x22bc，40号。
        H.at(a,v,0)
        -- 源0x22d0，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x22e8，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x22fc，285号。
        H.velocity_time(a,0,1,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x231c，276号。
        H.anm_reset(a)
        H.at(a,v,0)
        -- 源0x232c，259号。
        H.anm_slot(a,0,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x2344，322号。
        H.flags(a,1027,true)
        H.at(a,v,0)
        -- 源0x2358，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x236c，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x2384，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2398，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x23ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x23bc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x23d0，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x23e4，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x23f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2404，284号。
        H.velocity(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x241c，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x243c，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x2450，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x2464，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x2478，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x2488，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2498，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x24ac，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x24c0，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x24d4，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x24ec，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x2500，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2514，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2524，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x253c，11号。
        H.call(a,v,P["Boss1Girl2"],"Boss1Girl2")
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x255c，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2570，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2584，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x259c，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x25b4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x25c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x25dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x25f4，10号。
        return
    end
    P["Boss1GirlDead"]=B.part1
end

-- stage05boss.ecl：Boss1GirlDead2，0x2614；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2614，40号。
        H.at(a,v,0)
        -- 源0x2628，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x2640，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x2654，285号。
        H.velocity_time(a,0,1,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x2674，276号。
        H.anm_reset(a)
        H.at(a,v,0)
        -- 源0x2684，259号。
        H.anm_slot(a,0,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0x269c，322号。
        H.flags(a,1027,true)
        H.at(a,v,0)
        -- 源0x26b0，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x26c4，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x26dc，450号。
        H.score(a,1000)
        H.at(a,v,0)
        -- 源0x26f0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2704，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x2718，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2728，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x273c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x2750，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2760，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2770，284号。
        H.velocity(a,0,H.read(a,v,-1),2.5)
        H.at(a,v,0)
        -- 源0x2788，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x27a8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x27bc，407号。
        H.gun_aim(a,0,8)
        H.at(a,v,0)
        -- 源0x27d4，402号。
        H.gun_sprite(a,0,0,6)
        H.at(a,v,0)
        -- 源0x27f0，436号。
        H.gun_count_diff(a,0,5,12,12,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x2824，404号。
        H.gun_angle(a,0,-3.1415927410125732,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x2840，435号。
        H.gun_speed_diff(a,0,2.0,2.0,2.0,3.0,0.6000000238418579,0.6000000238418579,0.6000000238418579,0.6000000238418579)
        H.at(a,v,0)
        -- 源0x2874，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x28a4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x28b8，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x28cc，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x28e0，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x28f4，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x2904，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2914，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x2928，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x293c，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2950，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2968，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x297c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2990，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x29a0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x29b8，11号。
        H.call(a,v,P["Boss1Girl2"],"Boss1Girl2")
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x29d8，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x29ec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2a00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2a18，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2a30，83号。
        v.origin=v.origin+H.int(1000)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2a44，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2a58，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x2a70，10号。
        return
    end
    P["Boss1GirlDead2"]=B.part1
end

-- stage05boss.ecl：Boss2，0x2a90；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2a90，40号。
        H.at(a,v,0)
        -- 源0x2aa4，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x2ab4，449号。
        H.callback(a,449,4)
        H.at(a,v,0)
        -- 源0x2ac8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2ad8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2aec，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2b00，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b10，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2b28，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2b3c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2b54，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2b68，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2b78，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2b88，331号。
        H.life(a,8200)
        H.at(a,v,0)
        -- 源0x2b9c，334号。
        H.interrupt(a,0,2200,2100,"BossCard2")
        H.at(a,v,0)
        -- 源0x2bc8，347号。
        H.life_marker(a,0,2200.0,-24448)
        H.at(a,v,0)
        -- 源0x2be4，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x2bf8，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x2c0c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2c20，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2c34，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2c44，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2c5c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2c70，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x2c80，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2c94，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2ca8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2cb8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2cd0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2ce4，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x2cfc，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0x2d14，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2d2c，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2d3c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2d50，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2d64，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2d78，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2d8c，281号。
        H.position_time(a,0,60,4,120.0,128.0)
        H.at(a,v,60)
        -- 源0x2dac，0号。
        H.at(a,v,60)
        -- 源0x2dbc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x2ddc，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x2df4，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x2e08，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0x2e28，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,60)
        -- 源0x2e3c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x2e5c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2e70，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x2e84，15号。
        H.async(a,P["Boss2At2"],"Boss2At2",nil,6,-0.02617993950843811)
        H.at(a,v,60)
        -- 源0x2eb4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2ec8，281号。
        H.position_time(a,0,60,4,-128.0,128.0)
        H.at(a,v,60)
        -- 源0x2ee8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2efc，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x2f10，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0x2f30，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,60)
        -- 源0x2f44，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x2f64，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2f78，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x2f8c，15号。
        H.async(a,P["Boss2At2"],"Boss2At2",nil,6,0.02617993950843811)
        H.at(a,v,60)
        -- 源0x2fbc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x2fd0，281号。
        H.position_time(a,0,60,4,120.0,128.0)
        H.at(a,v,60)
        -- 源0x2ff0，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x3004，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x3018，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x3030，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage05boss.ecl：Boss2At1，0x3050；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3050，40号。
        H.at(a,v,0)
        -- 源0x3064，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3078，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x308c，355号。
        v.l[16]=H.int(9)
        H.at(a,v,0)
        -- 源0x30b0，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x30c4，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x30d8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x30e8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x30fc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3114，81号。
        do local r=48.0;local angle=(v.l[8] or 0);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x3134，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3148，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x315c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x316c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3180，42号。
        H.push(v,22)
        H.at(a,v,0)
        -- 源0x3194，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x31a4，256号。
        H.spawn(a,256,"BBoss2Phantom",H.read(a,v,-1),H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x31dc，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x31f0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x3204，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3214，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3228，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x323c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3254，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage05boss.ecl：Boss2At2，0x3274；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3274，40号。
        H.at(a,v,0)
        -- 源0x3288，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x329c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x32b4，402号。
        H.gun_sprite(a,0,5,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x32d0，436号。
        H.gun_count_diff(a,0,12,24,32,40,1,1,1,1)
        H.at(a,v,0)
        -- 源0x3304，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3320，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x333c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x336c，409号。
        H.gun_transform(a,0,1,0,1024,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x339c，409号。
        H.gun_transform(a,0,3,0,4,60,-999999,0.0833333358168602,-999999.0)
        H.at(a,v,0)
        -- 源0x33cc，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x33e0，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x33f4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3404，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x3418，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x342c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x343c，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3458，346号。
        a.protect=48.0
        H.at(a,v,0)
        -- 源0x346c，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x3480，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3494，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x34a8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x34bc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x34d0，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x34e4，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x34f8，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x350c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3524，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[20] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3554，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3570，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3588，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x359c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x35b0，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x35c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x35d4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x35e8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x35fc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3610，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3620，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3634，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x3648，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x365c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x366c，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3680，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x3694，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x36a8，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x36bc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x36d4，10号。
        return
    end
    P["Boss2At2"]=B.part1
end

-- stage05boss.ecl：Boss2Phantom，0x36f4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x36f4，40号。
        H.at(a,v,0)
        -- 源0x3708，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x371c，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3734，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x3748，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x375c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x3774，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x378c，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x37a0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x37b4，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x37c8，334号。
        H.interrupt(a,0,0,-1,"Boss2Phantom_at")
        H.at(a,v,0)
        -- 源0x37f8，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x3810，285号。
        H.velocity_time(a,0,60,0,-999999.0,-0.10000000149011612)
        H.at(a,v,160)
        -- 源0x3830，0号。
        H.at(a,v,160)
        -- 源0x3840，11号。
        H.call(a,v,P["Boss2Phantom_at2"],"Boss2Phantom_at2")
        H.at(a,v,160)
        -- 源0x3868，10号。
        return
    end
    P["Boss2Phantom"]=B.part1
end

-- stage05boss.ecl：Boss2Phantom_at，0x3888；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3888，40号。
        H.at(a,v,0)
        -- 源0x389c，11号。
        H.call(a,v,P["Boss2Phantom_atB"],"Boss2Phantom_atB")
        H.at(a,v,0)
        -- 源0x38c4，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x38d4，327号。
        H.drop_extra(a,2,1)
        H.at(a,v,0)
        -- 源0x38ec，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3904，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x3914，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x392c，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x3940，1号。
        H.erase(a);return
    end
    P["Boss2Phantom_at"]=B.part1
end

-- stage05boss.ecl：Boss2Phantom_at2，0x3970；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3970，40号。
        H.at(a,v,0)
        -- 源0x3984，11号。
        H.call(a,v,P["Boss2Phantom_atB"],"Boss2Phantom_atB")
        H.at(a,v,0)
        -- 源0x39ac，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x39c4，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x39d8，1号。
        H.erase(a);return
    end
    P["Boss2Phantom_at2"]=B.part1
end

-- stage05boss.ecl：Boss2Phantom_atB，0x3a08；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3a08，40号。
        H.at(a,v,0)
        -- 源0x3a1c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3a30，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x3a48，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x3a64，436号。
        H.gun_count_diff(a,0,12,16,16,16,1,3,4,5)
        H.at(a,v,0)
        -- 源0x3a98，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3ab4，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x3ae8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3b18，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3b48，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3b5c，10号。
        return
    end
    P["Boss2Phantom_atB"]=B.part1
end

-- stage05boss.ecl：Boss3，0x3b7c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3b7c，40号。
        H.at(a,v,0)
        -- 源0x3b90，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x3ba0，449号。
        H.callback(a,449,4)
        H.at(a,v,0)
        -- 源0x3bb4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x3bc4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3bd8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3bec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3bfc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3c14，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x3c28，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3c40，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3c54，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x3c64，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x3c74，331号。
        H.life(a,13300)
        H.at(a,v,0)
        -- 源0x3c88，334号。
        H.interrupt(a,0,2300,2100,"BossCard3")
        H.at(a,v,0)
        -- 源0x3cb4，347号。
        H.life_marker(a,0,2300.0,-24448)
        H.at(a,v,0)
        -- 源0x3cd0，344号。
        a.chapter=26
        H.at(a,v,0)
        -- 源0x3ce4，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x3cf8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3d0c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3d20，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3d30，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3d48，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3d5c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x3d6c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x3d80，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3d94，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3da4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3dbc，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3dd0，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x3de8，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0x3e00，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3e18，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x3e28，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3e3c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3e50，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x3e64，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x3e84，0号。
        H.at(a,v,60)
        -- 源0x3e94，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x3eb4，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x3ecc，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x3ee0，42号。
        H.push(v,11)
        H.at(a,v,60)
        -- 源0x3ef4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x3f08，15号。
        H.async(a,P["Boss3At1"],"Boss3At1",nil)
        H.at(a,v,60)
        -- 源0x3f28，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,60)
        -- 源0x3f3c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,60)
        -- 源0x3f58，83号。
        v.origin=v.origin+H.int(70)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x3f6c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x3f80，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x3f98，10号。
        return
    end
    P["Boss3"]=B.part1
end

-- stage05boss.ecl：Boss3At1，0x3fb8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3fb8，40号。
        H.at(a,v,0)
        -- 源0x3fcc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3fe0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3ff4，355号。
        v.l[16]=H.int(12)
        H.at(a,v,0)
        -- 源0x4018，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x402c，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x4040，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4050，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4064，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x407c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4090，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x40a4，81号。
        do local r=48.0;local angle=H.read(a,v,-9981);v.l[0]=H.f32(math.cos(angle)*r);v.l[4]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x40c4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x40d8，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x40ec，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x40fc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4110，42号。
        H.push(v,22)
        H.at(a,v,0)
        -- 源0x4124，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4134，256号。
        H.spawn(a,256,"BBoss3Phantom",H.read(a,v,-1),H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x416c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4180，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x4194，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x41a4，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x41b8，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x41cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x41e4，10号。
        return
    end
    P["Boss3At1"]=B.part1
end

-- stage05boss.ecl：Boss3At2，0x4204；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4204，40号。
        H.at(a,v,0)
        -- 源0x4218，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x422c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x4244，402号。
        H.gun_sprite(a,0,5,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4260，436号。
        H.gun_count_diff(a,0,12,24,24,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0x4294，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x42b0，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x42cc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x42fc，409号。
        H.gun_transform(a,0,1,0,1024,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x432c，409号。
        H.gun_transform(a,0,3,0,4,60,-999999,0.01666666753590107,-999999.0)
        H.at(a,v,0)
        -- 源0x435c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x4370，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x4384，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4394，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x43a8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x43bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x43cc，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x43e8，346号。
        a.protect=48.0
        H.at(a,v,0)
        -- 源0x43fc，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x4410，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4424，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x4438，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x444c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4460，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4474，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x4488，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x449c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x44b4，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[20] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x44e4，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x4500，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4518，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x452c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4540，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x4554，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4564，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4578，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x458c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x45a0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x45b0，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x45c4，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x45d8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x45ec，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x45fc，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4610，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x4624，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4638，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x464c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4664，10号。
        return
    end
    P["Boss3At2"]=B.part1
end

-- stage05boss.ecl：Boss3Phantom，0x4684；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4684，40号。
        H.at(a,v,0)
        -- 源0x4698，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x46ac，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x46c4，322号。
        H.flags(a,525,true)
        H.at(a,v,0)
        -- 源0x46d8，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x46ec，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x4704，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x471c，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x4730，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x4744，284号。
        H.velocity(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x475c，15号。
        H.async(a,P["Boss3Phantom_at"],"Boss3Phantom_at",nil)
        H.at(a,v,0)
        -- 源0x4780，285号。
        H.velocity_time(a,0,30,0,-999999.0,1.100000023841858)
        H.at(a,v,0)
        -- 源0x47a0，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x47b4，1号。
        H.erase(a);return
    end
    P["Boss3Phantom"]=B.part1
end

-- stage05boss.ecl：Boss3Phantom_at，0x47e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x47e4，40号。
        H.at(a,v,0)
        -- 源0x47f8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x480c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x4824，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x4840，406号。
        H.gun_count(a,0,7,1)
        H.at(a,v,0)
        -- 源0x485c，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x4878，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0x4894，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x48c4，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0x48f4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x490c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4920，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4934，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4948，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4960，10号。
        return
    end
    P["Boss3Phantom_at"]=B.part1
end

-- stage05boss.ecl：BossCard1，0x4980；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4980，40号。
        H.at(a,v,0)
        -- 源0x4994，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x49a8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x49b8，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x49c8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x49d8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x49ec，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x49fc，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x4a10，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4a44，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4a58，334号。
        H.interrupt(a,0,0,3600,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4abc，357号。
        H.spell(a,122,3600,500000,"呪精「怨霊憑依妖精」",357)
        H.at(a,v,0)
        -- 源0x4af4，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x4b08，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4b18，281号。
        H.position_time(a,0,60,4,0.0,160.0)
        H.at(a,v,0)
        -- 源0x4b38，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,0)
        -- 源0x4b58，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4b6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4b80，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4b90，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4ba8，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x4bbc，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4bcc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4be0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4bf4，449号。
        H.callback(a,449,2)
        H.at(a,v,60)
        -- 源0x4c08，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x4c20，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x4c34，443号。
        H.callback(a,443,3)
        H.at(a,v,120)
        -- 源0x4c48，263号。
        H.effect(a,0,176)
        H.at(a,v,150)
        -- 源0x4c60，0号。
        H.at(a,v,150)
        -- 源0x4c70，15号。
        H.async(a,P["BossCard1At"],"BossCard1At",nil)
        H.at(a,v,150)
        -- 源0x4c90，12号。
        v.origin=H.clock(a)-(150);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,150)
        -- 源0x4ca8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,150)
        -- 源0x4cbc，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x4cd0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,150)
        -- 源0x4ce8，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage05boss.ecl：BossCard1At，0x4d08；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4d08，40号。
        H.at(a,v,0)
        -- 源0x4d1c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4d30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4d44，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x4d58，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4d70，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x4d84，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x4d9c，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x4db8，436号。
        H.gun_count_diff(a,2,1,1,2,3,1,1,1,1)
        H.at(a,v,0)
        -- 源0x4dec，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4e08，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x4e24，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4e54，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x4e68，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x4e7c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4e8c，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x4ea0，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x4eb4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4ec4，439号。
        H.gun_absolute(a,2,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x4ee0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4ef4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4f08，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x4f1c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x4f2c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4f3c，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4f58，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4f6c，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x4f80，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4f90，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,0)
        -- 源0x4fa4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4fb4，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4fd0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x4fe4，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x4ff8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5008，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x501c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x502c，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5048，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x505c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x5070，44号。
        H.push(v,0.13089999556541443)
        H.at(a,v,0)
        -- 源0x5084，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5094，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x50a8，368号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x50c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x50dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x50f4，10号。
        return
    end
    P["BossCard1At"]=B.part1
end

-- stage05boss.ecl：BossCard2，0x5114；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5114，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x5164，357号。
        H.spell(a,126,3000,500000,"屍霊「食人怨霊」",357)
        H.at(a,v,0)
        -- 源0x5198，334号。
        H.interrupt(a,0,0,3000,"Boss3")
        H.at(a,v,0)
        -- 源0x51c0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x51d0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x51e0，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x5200，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x5214，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x5228，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x523c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5250，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5260，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5278，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x52ac，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x52c4，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x52fc，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x5310，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5324，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5334，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x534c，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x5360，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5370，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5384，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5398，344号。
        a.chapter=44
        H.at(a,v,120)
        -- 源0x53ac，0号。
        H.at(a,v,120)
        -- 源0x53bc，12号。
        v.origin=H.clock(a)-(120);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x53d4，11号。
        H.call(a,v,P["BossCard2_at"],"BossCard2_at")
        H.at(a,v,120)
        -- 源0x53f8，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x540c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x5420，292号。
        H.wander(a,0,60,0,1.5)
        H.at(a,v,120)
        -- 源0x543c，368号。
        v.origin=v.origin+H.int(160)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x545c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x5470，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x5488，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage05boss.ecl：BossCard2Phantom，0x54a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x54a8，40号。
        H.at(a,v,0)
        -- 源0x54bc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x54d0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x54e8，322号。
        H.flags(a,15,true)
        H.at(a,v,0)
        -- 源0x54fc，322号。
        H.flags(a,512,true)
        H.at(a,v,0)
        -- 源0x5510，288号。
        H.circle(a,0,H.read(a,v,-9981),H.read(a,v,-9980),128.0,0.0)
        H.at(a,v,0)
        -- 源0x5530，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x5544，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x5558，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5568，289号。
        H.circle_time(a,0,60,4,H.read(a,v,-1),192.0,-999999.0)
        H.at(a,v,0)
        -- 源0x558c，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x55a0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x55b8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x55d0，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x55e4，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x55f8，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x560c，15号。
        H.async(a,P["BossCard2Phantom_at"],"BossCard2Phantom_at",nil)
        H.at(a,v,0)
        -- 源0x5634，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x5648，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x565c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x5670，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x5680，289号。
        H.circle_time(a,0,240,1,H.read(a,v,-1),-16.0,-999999.0)
        H.at(a,v,240)
        -- 源0x56a4，0号。
        H.at(a,v,240)
        -- 源0x56b4，322号。
        H.flags(a,1,true)
        H.at(a,v,240)
        -- 源0x56c8，280号。
        H.position(a,0,H.read(a,v,-9997),H.read(a,v,-9996))
        H.at(a,v,240)
        -- 源0x56e0，258号。
        H.select_anm(a,0)
        H.at(a,v,240)
        -- 源0x56f4，259号。
        H.anm_slot(a,1,178)
        H.at(a,v,260)
        -- 源0x570c，259号。
        H.anm_slot(a,0,-1)
        H.at(a,v,260)
        -- 源0x5724，336号。
        H.sound(a,54)
        H.at(a,v,260)
        -- 源0x5738，322号。
        H.flags(a,512,true)
        H.at(a,v,260)
        -- 源0x574c，42号。
        H.push(v,4)
        H.at(a,v,260)
        -- 源0x5760，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0x5774，42号。
        H.push(v,10)
        H.at(a,v,260)
        -- 源0x5788，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,260)
        -- 源0x579c，12号。
        v.origin=H.clock(a)-(260);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,260)
        -- 源0x57b4，321号。
        H.hitbox(a,(v.l[12] or 0),(v.l[12] or 0))
        H.at(a,v,260)
        -- 源0x57cc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,260)
        -- 源0x57e0，42号。
        H.push(v,8)
        H.at(a,v,260)
        -- 源0x57f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0x5804，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0x5818，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,260)
        -- 源0x582c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,260)
        -- 源0x5840，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(260);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,260)
        -- 源0x5858，42号。
        H.push(v,45)
        H.at(a,v,260)
        -- 源0x586c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,260)
        -- 源0x5880，12号。
        v.origin=H.clock(a)-(260);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,260)
        -- 源0x5898，321号。
        H.hitbox(a,(v.l[12] or 0),(v.l[12] or 0))
        H.at(a,v,260)
        -- 源0x58b0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,260)
        -- 源0x58c4，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,260)
        -- 源0x58d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,260)
        -- 源0x58e8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,260)
        -- 源0x58fc，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,260)
        -- 源0x5910，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,260)
        -- 源0x5924，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(260);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,260)
        -- 源0x593c，322号。
        H.flags(a,3,true)
        H.at(a,v,260)
        -- 源0x5950，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,260)
        -- 源0x5964，1号。
        H.erase(a);return
    end
    P["BossCard2Phantom"]=B.part1
end

-- stage05boss.ecl：BossCard2Phantom_at，0x5994；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5994，40号。
        H.at(a,v,0)
        -- 源0x59a8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x59bc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x59d0，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x59e0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x59f8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5a0c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x5a24，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x5a40，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x5a5c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5a78，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x5a94，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5aac，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5ac0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x5ad8，402号。
        H.gun_sprite(a,0,5,2)
        H.at(a,v,0)
        -- 源0x5af4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x5b10，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5b2c，405号。
        H.gun_speed(a,0,0.0,1.5)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5b48，409号。
        H.gun_transform(a,0,0,0,1024,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5b78，409号。
        H.gun_transform(a,0,1,0,4096,180,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5ba8，356号。
        v.l[4]=H.f32(0.02500000037252903)
        H.at(a,v,0)
        -- 源0x5bcc，409号。
        H.gun_transform(a,0,2,0,4,120,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x5bfc，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x5c10，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5c24，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5c34，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5c4c，409号。
        H.gun_transform(a,0,3,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5c7c，409号。
        H.gun_transform(a,0,4,0,8192,-999999,-999999,-999999.0,-999999.0)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x5cac，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x5cc0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x5cd4，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5cec，44号。
        H.push(v,H.read(a,v,-9971))
        H.at(a,v,0)
        -- 源0x5d00，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x5d14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5d24，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x5d40，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5d54，83号。
        v.origin=v.origin+H.int(2)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x5d68，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x5d7c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x5d94，10号。
        return
    end
    P["BossCard2Phantom_at"]=B.part1
end

-- stage05boss.ecl：BossCard2Phantom_at2，0x5db4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5db4，40号。
        H.at(a,v,0)
        -- 源0x5dc8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5ddc，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x5df4，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x5e10，406号。
        H.gun_count(a,0,16,3)
        H.at(a,v,0)
        -- 源0x5e2c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5e48，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x5e64，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5e94，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5ec4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5ed8，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x5ef0，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x5f04，1号。
        H.erase(a);return
    end
    P["BossCard2Phantom_at2"]=B.part1
end

-- stage05boss.ecl：BossCard2_at，0x5f34；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5f34，40号。
        H.at(a,v,0)
        -- 源0x5f48，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5f5c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x5f70，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x5f84，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5f98，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x5fac，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5fc0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5fd8，257号。
        H.spawn(a,257,"GBossCard2Phantom",H.read(a,v,-9965),H.read(a,v,-9964),200,1000,2)
        H.at(a,v,0)
        -- 源0x6014，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6028，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,0)
        -- 源0x603c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x604c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6060，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x6074，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x608c，10号。
        return
    end
    P["BossCard2_at"]=B.part1
end

-- stage05boss.ecl：BossCard3，0x60ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x60ac，40号。
        H.at(a,v,0)
        -- 源0x60c0，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x60d4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x60e4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x60f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x610c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x611c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6134，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x6148，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6160，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6174，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x6184，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x6194，334号。
        H.interrupt(a,0,0,3000,"BossCard4")
        H.at(a,v,0)
        -- 源0x61c0，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x61d4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x61e8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x61fc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x620c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6224，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x6238，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6248，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x625c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6270，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6280，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x6298，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x62ac，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x62c4，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x62dc，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x62f4，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x6304，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6318，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x632c，336号。
        H.sound(a,15)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x6378，357号。
        H.spell(a,130,3000,500000,"贖罪「昔時の針と痛がる怨霊」",357)
        H.at(a,v,0)
        -- 源0x63b8，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x63cc，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x63ec，0号。
        H.at(a,v,60)
        -- 源0x63fc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x641c，12号。
        v.origin=H.clock(a)-(60);return B.part13(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x6434，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x6448，355号。
        v.l[4]=H.int(7)
        H.at(a,v,60)
        -- 源0x646c，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,60)
        -- 源0x6480，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x6494，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x64a8，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,60)
        -- 源0x64b8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,60)
        -- 源0x64c8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,60)
        -- 源0x64dc，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,60)
        -- 源0x64f0，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,60)
        -- 源0x6504，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0x6514，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x6528，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,60)
        -- 源0x653c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x6550，12号。
        v.origin=H.clock(a)-(60);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x6568，15号。
        H.async(a,P["BossCard3At1"],"BossCard3At1",nil)
        H.at(a,v,60)
        -- 源0x658c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,60)
        -- 源0x65a0，44号。
        H.push(v,H.read(a,v,-9979))
        H.at(a,v,60)
        -- 源0x65b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,60)
        -- 源0x65c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x65d8，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x65ec，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x6600，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,60)
        -- 源0x6614，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,60)
        -- 源0x6624，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x6638，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0x664c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x6664，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x66b8，15号。
        H.async(a,P["BossCard3At2"],"BossCard3At2",nil,2,0.09817477315664291)
        H.at(a,v,60)
        -- 源0x66ec，368号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x6740，15号。
        H.async(a,P["BossCard3At2"],"BossCard3At2",nil,1,-0.09817477315664291)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x6774，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x6788，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x67a0，10号。
        return
    end
    P["BossCard3"]=B.part1
end

-- stage05boss.ecl：BossCard3At1，0x67c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x67c0，40号。
        H.at(a,v,0)
        -- 源0x67d4，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x67e8，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x67fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6810，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6824，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x683c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x6850，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6864，256号。
        H.spawn(a,256,"BBossCard3Phantom",22.0,-24.0,200,1000,2)
        H.at(a,v,0)
        -- 源0x68a0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x68b4，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x68c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x68d8，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x68ec，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x6900，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6918，10号。
        return
    end
    P["BossCard3At1"]=B.part1
end

-- stage05boss.ecl：BossCard3At2，0x6938；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6938，40号。
        H.at(a,v,0)
        -- 源0x694c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6960，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x6978，402号。
        H.gun_sprite(a,0,5,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6994，436号。
        H.gun_count_diff(a,0,18,20,24,24,1,1,1,1)
        H.at(a,v,0)
        -- 源0x69c8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x69e4，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x6a00，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6a30，409号。
        H.gun_transform(a,0,1,0,1024,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6a60，356号。
        v.l[16]=H.f32(0.03333333507180214)
        H.at(a,v,0)
        -- 源0x6a84，409号。
        H.gun_transform(a,0,3,0,4,60,-999999,(v.l[16] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x6ab4，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x6ac8，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x6adc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x6aec，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x6b00，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x6b14，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6b24，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x6b40，346号。
        a.protect=48.0
        H.at(a,v,0)
        -- 源0x6b54，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x6b68，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6b7c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x6b90，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6ba4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6bb8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6bcc，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x6be0，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6bf4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6c0c，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[24] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6c3c，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x6c58，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x6c70，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x6c84，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x6c98，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x6cac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6cbc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6cd0，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x6ce4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6cf8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6d08，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d1c，42号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x6d30，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x6d44，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x6d54，43号。
        v.l[24]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d68，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x6d7c，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6d90，78号。
        H.push(v,(v.l[20] or 0))
        v.l[20]=H.int((v.l[20] or 0)-1)
        H.at(a,v,0)
        -- 源0x6da4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6dbc，10号。
        return
    end
    P["BossCard3At2"]=B.part1
end

-- stage05boss.ecl：BossCard3Phantom，0x6ddc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6ddc，40号。
        H.at(a,v,0)
        -- 源0x6df0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x6e04，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6e1c，322号。
        H.flags(a,525,true)
        H.at(a,v,0)
        -- 源0x6e30，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x6e44，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6e5c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x6e74，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x6e88，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6e9c，284号。
        H.velocity(a,0,H.read(a,v,-9979),0.0)
        H.at(a,v,0)
        -- 源0x6eb4，285号。
        H.velocity_time(a,0,300,0,-999999.0,4.0)
        H.at(a,v,0)
        -- 源0x6ed4，290号。
        H.circle(a,1,H.read(a,v,-9981),H.read(a,v,-9980),0.0,0.0)
        H.at(a,v,0)
        -- 源0x6ef4，291号。
        H.circle_time(a,1,60,1,H.read(a,v,-9980),48.0,0)
        H.at(a,v,0)
        -- 源0x6f18，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x6f2c，1号。
        H.erase(a);return
    end
    P["BossCard3Phantom"]=B.part1
end

-- stage05boss.ecl：BossCard3Phantom_at，0x6f5c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6f5c，40号。
        H.at(a,v,0)
        -- 源0x6f70，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6f84，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x6f9c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x6fb8，406号。
        H.gun_count(a,0,16,3)
        H.at(a,v,0)
        -- 源0x6fd4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x6ff0，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x700c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x703c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x706c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7080，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7090，327号。
        H.drop_extra(a,2,1)
        H.at(a,v,0)
        -- 源0x70a8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x70c0，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x70d0，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x70e8，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x70fc，1号。
        H.erase(a);return
    end
    P["BossCard3Phantom_at"]=B.part1
end

-- stage05boss.ecl：BossCard3Phantom_at2，0x712c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x712c，40号。
        H.at(a,v,0)
        -- 源0x7140，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7154，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x716c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x7188，406号。
        H.gun_count(a,0,16,3)
        H.at(a,v,0)
        -- 源0x71a4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x71c0，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x71dc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x720c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x723c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7250，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x7268，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x727c，1号。
        H.erase(a);return
    end
    P["BossCard3Phantom_at2"]=B.part1
end

-- stage05boss.ecl：BossCard4，0x72ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x72ac，40号。
        H.at(a,v,0)
        -- 源0x72c0，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x72d0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x72e0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x72f4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7308，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7318，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7330，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x7344，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x735c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7370，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x7380，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x7390，335号。
        a.invul=160
        H.at(a,v,0)
        -- 源0x73a4，331号。
        H.life(a,1500)
        H.at(a,v,0)
        -- 源0x73b8，334号。
        H.interrupt(a,0,0,3600,"BossDead")
        H.at(a,v,0)
        -- 源0x73e4，347号。
        H.life_marker(a,0,1500.0,-24448)
        H.at(a,v,0)
        -- 源0x7400，344号。
        a.chapter=27
        H.at(a,v,0)
        -- 源0x7414，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x7428，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x743c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7450，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7460，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7478，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x748c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x749c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x74b0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x74c4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x74d4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x74ec，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x7500，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x7518，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0x7530，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x7548，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x7558，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x756c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7580，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x7594，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x75a8，324号。
        H.limit(a,0.0,224.0,280.0,320.0)
        H.at(a,v,0)
        -- 源0x75c8，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,60)
        -- 源0x75e8，0号。
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x7628，357号。
        H.spell(a,134,3600,500000,"「小悪霊復活せし」",357)
        H.at(a,v,60)
        -- 源0x765c，344号。
        a.chapter=46
        H.at(a,v,60)
        -- 源0x7670，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x7684，15号。
        H.async(a,P["BossCard4At1"],"BossCard4At1",nil)
        H.at(a,v,60)
        -- 源0x76a8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x76bc，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x76d0，263号。
        H.effect(a,0,176)
        H.at(a,v,60)
        -- 源0x76e8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x76fc，449号。
        H.callback(a,449,2)
        H.at(a,v,60)
        -- 源0x7710，443号。
        H.callback(a,443,3)
        H.at(a,v,60)
        -- 源0x7724，15号。
        H.async(a,P["BossCard5At"],"BossCard5At",nil)
        H.at(a,v,60)
        -- 源0x7744，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x775c，83号。
        v.origin=v.origin+H.int(100)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x7770，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x7784，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x779c，10号。
        return
    end
    P["BossCard4"]=B.part1
end

-- stage05boss.ecl：BossCard4At1，0x77bc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x77bc，40号。
        H.at(a,v,0)
        -- 源0x77d0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x77e4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x77f8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x780c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7820，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0x7834，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7848，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7860，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7874，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7888，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x789c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x78b0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x78c4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x78d4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x78e4，257号。
        H.spawn(a,257,"BBossCard4Phantom",H.read(a,v,-1),(v.l[4] or 0),20000,1000,2)
        H.at(a,v,0)
        -- 源0x7920，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x7934，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7948，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x795c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x796c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x797c，257号。
        H.spawn(a,257,"BBossCard4Phantom",H.read(a,v,-1),(v.l[4] or 0),20000,1000,2)
        H.at(a,v,0)
        -- 源0x79b8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x79cc，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x79e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x79f0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a04，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7a18，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x7a2c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x7a3c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7a50，83号。
        v.origin=v.origin+H.int(8)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7a64，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x7a78，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7a90，10号。
        return
    end
    P["BossCard4At1"]=B.part1
end

-- stage05boss.ecl：BossCard4At2，0x7ab0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7ab0，40号。
        H.at(a,v,0)
        -- 源0x7ac4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7ad8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x7af0，402号。
        H.gun_sprite(a,0,5,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7b0c，406号。
        H.gun_count(a,0,24,1)
        H.at(a,v,0)
        -- 源0x7b28，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7b44，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x7b60，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7b90，409号。
        H.gun_transform(a,0,1,0,1024,20,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7bc0，409号。
        H.gun_transform(a,0,3,0,4,60,-999999,0.01666666753590107,-999999.0)
        H.at(a,v,0)
        -- 源0x7bf0，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x7c04，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x7c18，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x7c28，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x7c3c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x7c50，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7c60，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x7c7c，346号。
        a.protect=48.0
        H.at(a,v,0)
        -- 源0x7c90，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x7ca4，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7cb8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x7ccc，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7ce0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7cf4，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7d08，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x7d1c，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7d30，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7d48，409号。
        H.gun_transform(a,0,2,0,4096,(v.l[20] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7d78，404号。
        H.gun_angle(a,0,(v.l[12] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7d94，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7dac，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7dc0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7dd4，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x7de8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7df8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7e0c，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7e20，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7e34，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7e44，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7e58，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7e6c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x7e80，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x7e90，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7ea4，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        H.at(a,v,0)
        -- 源0x7eb8，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7ecc，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x7ee0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7ef8，10号。
        return
    end
    P["BossCard4At2"]=B.part1
end

-- stage05boss.ecl：BossCard4Girl，0x7f18；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7f18，40号。
        H.at(a,v,0)
        -- 源0x7f2c，42号。
        H.push(v,113)
        H.at(a,v,0)
        -- 源0x7f40，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7f54，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x7f68，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x7f7c，259号。
        H.anm_slot(a,2,119)
        H.at(a,v,0)
        -- 源0x7f94，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7fa8，334号。
        H.interrupt(a,0,0,-1,"BossCard4GirlDead2")
        H.at(a,v,0)
        -- 源0x7fdc，262号。
        H.anm_main(a,0,20)
        H.at(a,v,0)
        -- 源0x7ff4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x800c，331号。
        H.life(a,200)
        H.at(a,v,0)
        -- 源0x8020，322号。
        H.flags(a,1024,true)
        H.at(a,v,0)
        -- 源0x8034，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x8048，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x8060，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x8078，15号。
        H.async(a,P["BossCard4Girl_at"],"BossCard4Girl_at",nil)
        H.at(a,v,0)
        -- 源0x80a0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x80b4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x80c8，12号。
        v.origin=H.clock(a)-(0);return B.part16(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x80e0，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x80f4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x8108，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8118，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8130，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8144，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8158，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8168，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8180，42号。
        H.push(v,18)
        H.at(a,v,0)
        -- 源0x8194，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x81a8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x81c0，42号。
        H.push(v,25)
        H.at(a,v,0)
        -- 源0x81d4，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x81e8，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0x81fc，42号。
        H.push(v,256)
        H.at(a,v,0)
        -- 源0x8210，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8220，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8238，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x824c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8260，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8274，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8284，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8294，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x82a8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x82bc，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x82d0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x82e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x82f0，281号。
        H.position_time(a,0,200,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x8310，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x8324，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x833c，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0x8350，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x8364，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8374，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x838c，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x83a0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x83b4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x83c8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x83d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x83e8，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x83fc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8410，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8424，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8434，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8444，281号。
        H.position_time(a,0,150,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x8464，83号。
        v.origin=v.origin+H.int(190)
        H.at(a,v,0)
        -- 源0x8478，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x8490，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0x84a4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x84b8，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x84c8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part12(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x84e0，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x84f4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8508，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x851c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x852c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x853c，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x8550，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8564，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8578，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8588，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8598，281号。
        H.position_time(a,0,100,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x85b8，83号。
        v.origin=v.origin+H.int(140)
        H.at(a,v,0)
        -- 源0x85cc，12号。
        v.origin=H.clock(a)-(0);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x85e4，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x85f8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x860c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8620，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8630，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8640，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x8654，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x8668，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x867c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x868c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x869c，281号。
        H.position_time(a,0,60,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x86bc，83号。
        v.origin=v.origin+H.int(40)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x86d0，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x86e8，42号。
        H.push(v,18)
        H.at(a,v,0)
        -- 源0x86fc，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8710，11号。
        H.call(a,v,P["BossCard4Girl_at2"],"BossCard4Girl_at2")
        H.at(a,v,0)
        -- 源0x8738，42号。
        H.push(v,-1)
        H.at(a,v,0)
        -- 源0x874c，43号。
        v.l[8]=H.int(H.pop(v))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x8760，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8774，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8788，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x8798，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x87ac，83号。
        v.origin=v.origin+H.int(1)
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x87c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x87d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x87ec，10号。
        return
    end
    P["BossCard4Girl"]=B.part1
end

-- stage05boss.ecl：BossCard4GirlDead，0x880c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x880c，40号。
        H.at(a,v,0)
        -- 源0x8820，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x8838，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x884c，285号。
        H.velocity_time(a,0,1,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x886c，276号。
        H.anm_reset(a)
        H.at(a,v,0)
        -- 源0x887c，259号。
        H.anm_slot(a,0,109)
        H.at(a,v,0)
        -- 源0x8894，322号。
        H.flags(a,1027,true)
        H.at(a,v,0)
        -- 源0x88a8，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x88bc，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x88d4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x88e8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x88fc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x890c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8920，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x8934，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8944，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8954，284号。
        H.velocity(a,0,H.read(a,v,-1),2.0)
        H.at(a,v,0)
        -- 源0x896c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8980，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8994，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x89ac，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x89c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x89d4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x89e4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x89fc，11号。
        H.call(a,v,P["BossCard4Girl"],"BossCard4Girl")
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8a20，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8a34，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8a48，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8a60，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8a78，83号。
        v.origin=v.origin+H.int(1000)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8a8c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8aa0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x8ab8，10号。
        return
    end
    P["BossCard4GirlDead"]=B.part1
end

-- stage05boss.ecl：BossCard4GirlDead2，0x8ad8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8ad8，40号。
        H.at(a,v,0)
        -- 源0x8aec，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x8b04，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x8b18，281号。
        H.position_time(a,0,1,0,H.read(a,v,-9997),H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x8b38，276号。
        H.anm_reset(a)
        H.at(a,v,0)
        -- 源0x8b48，259号。
        H.anm_slot(a,0,113)
        H.at(a,v,0)
        -- 源0x8b60，322号。
        H.flags(a,1027,true)
        H.at(a,v,0)
        -- 源0x8b74，331号。
        H.life(a,100000)
        H.at(a,v,0)
        -- 源0x8b88，259号。
        H.anm_slot(a,1,-1)
        H.at(a,v,0)
        -- 源0x8ba0，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x8bb4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x8bc8，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x8bd8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8bec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8bfc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8c14，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8c28，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8c3c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8c4c，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8c60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8c70，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x8c84，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x8c98，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x8ca8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8cbc，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x8cd0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8ce0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8cf0，284号。
        H.velocity(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x8d08，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8d20，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x8d34，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8d48，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x8d58，44号。
        H.push(v,4.0)
        H.at(a,v,0)
        -- 源0x8d6c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8d7c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x8d90，44号。
        H.push(v,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x8da4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8db4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8dc8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x8ddc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8dec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8dfc，284号。
        H.velocity(a,0,H.read(a,v,-1),H.read(a,v,-1))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8e14，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x8e34，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x8e48，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x8e5c，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x8e70，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x8e80，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x8e90，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x8ea4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8eb8，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8ecc，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8ee4，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x8ef8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8f0c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8f1c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8f34，11号。
        H.call(a,v,P["BossCard4Girl"],"BossCard4Girl")
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8f58，83号。
        v.origin=v.origin+H.int(1)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8f6c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8f80，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x8f98，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x8fb0，83号。
        v.origin=v.origin+H.int(1000)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x8fc4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8fd8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x8ff0，10号。
        return
    end
    P["BossCard4GirlDead2"]=B.part1
end

-- stage05boss.ecl：BossCard4Girl_at，0x9010；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9010，40号。
        H.at(a,v,0)
        -- 源0x9024，42号。
        H.push(v,90)
        H.at(a,v,0)
        -- 源0x9038，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x904c，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x9060，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9074，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x908c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x90a0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x90b8，402号。
        H.gun_sprite(a,0,H.read(a,v,-9983),0)
        H.at(a,v,0)
        -- 源0x90d4，436号。
        H.gun_count_diff(a,0,1,1,2,4,1,1,1,1)
        H.at(a,v,0)
        -- 源0x9108，404号。
        H.gun_angle(a,0,1.5707963705062866,0.19634954631328583)
        H.at(a,v,0)
        -- 源0x9124，405号。
        H.gun_speed(a,0,0.009999999776482582,1.0)
        H.at(a,v,0)
        -- 源0x9140，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9170，409号。
        H.gun_transform(a,0,1,0,4096,30,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x91a0，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.01666666753590107,-999999.0)
        H.at(a,v,0)
        -- 源0x91d0，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x91e4，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x91f8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9208，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9220，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x923c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9250，83号。
        v.origin=v.origin+H.int((v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x9264，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x9278，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x928c，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x929c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x92b4，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x92c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x92dc，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x92ec，43号。
        v.l[4]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9300，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9314，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x9328，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9338，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9350，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9364，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x9378，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9388，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x939c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x93b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x93c8，10号。
        return
    end
    P["BossCard4Girl_at"]=B.part1
end

-- stage05boss.ecl：BossCard4Girl_at2，0x93e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x93e8，40号。
        H.at(a,v,0)
        -- 源0x93fc，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x9410，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x9428，402号。
        H.gun_sprite(a,1,17,0)
        H.at(a,v,0)
        -- 源0x9444，436号。
        H.gun_count_diff(a,1,4,6,9,7,1,1,1,1)
        H.at(a,v,0)
        -- 源0x9478，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.19634954631328583)
        H.at(a,v,0)
        -- 源0x9494，435号。
        H.gun_speed_diff(a,1,1.2999999523162842,1.600000023841858,2.5999999046325684,2.5999999046325684,1.0,1.0,1.0,1.0)
        H.at(a,v,0)
        -- 源0x94c8，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x94f8，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x9514，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x9528，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x953c，10号。
        return
    end
    P["BossCard4Girl_at2"]=B.part1
end

-- stage05boss.ecl：BossCard4Phantom，0x955c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x955c，40号。
        H.at(a,v,0)
        -- 源0x9570，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9584，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x959c，322号。
        H.flags(a,1037,true)
        H.at(a,v,0)
        -- 源0x95b0，336号。
        H.sound(a,46)
        H.at(a,v,0)
        -- 源0x95c4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x95dc，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x95f4，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x9608，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x961c，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x9630，334号。
        H.interrupt(a,0,0,-1,"BossCard4GirlDead")
        H.at(a,v,0)
        -- 源0x9664，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x967c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9690，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x96a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x96bc，284号。
        H.velocity(a,0,H.read(a,v,-9979),0.0)
        H.at(a,v,0)
        -- 源0x96d4，285号。
        H.velocity_time(a,0,300,0,-999999.0,4.0)
        H.at(a,v,0)
        -- 源0x96f4，290号。
        H.circle(a,1,H.read(a,v,-9981),H.read(a,v,-9980),0.0,0.0)
        H.at(a,v,0)
        -- 源0x9714，291号。
        H.circle_time(a,1,60,1,H.read(a,v,-9980),48.0,0)
        H.at(a,v,0)
        -- 源0x9738，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x974c，1号。
        H.erase(a);return
    end
    P["BossCard4Phantom"]=B.part1
end

-- stage05boss.ecl：BossCard4Phantom_at，0x977c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x977c，40号。
        H.at(a,v,0)
        -- 源0x9790，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x97a4，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x97bc，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x97d8，406号。
        H.gun_count(a,0,16,3)
        H.at(a,v,0)
        -- 源0x97f4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x9810，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x982c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x985c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x988c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x98a0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x98b0，327号。
        H.drop_extra(a,2,1)
        H.at(a,v,0)
        -- 源0x98c8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x98e0，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x98f0，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x9908，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x991c，1号。
        H.erase(a);return
    end
    P["BossCard4Phantom_at"]=B.part1
end

-- stage05boss.ecl：BossCard4Phantom_at2，0x994c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x994c，40号。
        H.at(a,v,0)
        -- 源0x9960，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x9974，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x998c，402号。
        H.gun_sprite(a,0,2,6)
        H.at(a,v,0)
        -- 源0x99a8，406号。
        H.gun_count(a,0,16,3)
        H.at(a,v,0)
        -- 源0x99c4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x99e0，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x99fc，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9a2c，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9a5c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9a70，263号。
        H.effect(a,0,78)
        H.at(a,v,0)
        -- 源0x9a88，336号。
        H.sound(a,2)
        H.at(a,v,0)
        -- 源0x9a9c，1号。
        H.erase(a);return
    end
    P["BossCard4Phantom_at2"]=B.part1
end

-- stage05boss.ecl：BossCard5At，0x9acc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9acc，40号。
        H.at(a,v,0)
        -- 源0x9ae0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x9af4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9b08，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9b20，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x9b34，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x9b4c，402号。
        H.gun_sprite(a,2,24,6)
        H.at(a,v,0)
        -- 源0x9b68，406号。
        H.gun_count(a,2,2,1)
        H.at(a,v,0)
        -- 源0x9b84，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x9ba0，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x9bbc，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9bec，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x9c00，42号。
        H.push(v,24)
        H.at(a,v,0)
        -- 源0x9c14，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x9c24，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x9c38，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x9c4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9c5c，439号。
        H.gun_absolute(a,2,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x9c78，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x9c90，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9ca4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9cb8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9ccc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x9cdc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9cec，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x9d08，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x9d1c，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,0)
        -- 源0x9d30，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x9d40，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0x9d54，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9d64，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x9d80，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x9d94，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9da8，44号。
        H.push(v,0.11180000007152557)
        H.at(a,v,0)
        -- 源0x9dbc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9dcc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9de0，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9df4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9e08，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9e20，10号。
        return
    end
    P["BossCard5At"]=B.part1
end

-- stage05boss.ecl：BossDead，0x9e40；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9e40，40号。
        H.at(a,v,0)
        -- 源0x9e54，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x9e68，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x9e80，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x9e94，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x9eac，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x9ec4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9ed8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9eec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9efc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9f14，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x9f4c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9f64，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x9f9c，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x9fac，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x9fbc，449号。
        H.callback(a,449,4)
        H.at(a,v,60)
        -- 源0x9fd0，345号。
        H.kill_all(a)
        H.at(a,v,60)
        -- 源0x9fe0，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x9ff4，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0xa004，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0xa018，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xa02c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0xa03c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0xa054，330号。
        H.drop_main(a,5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0xa068，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xa07c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa090，327号。
        H.drop_extra(a,1,8)
        H.at(a,v,60)
        -- 源0xa0a8，327号。
        H.drop_extra(a,2,8)
        H.at(a,v,60)
        -- 源0xa0c0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0xa0d8，329号。
        H.drop(a)
        H.at(a,v,60)
        -- 源0xa0e8，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0xa104，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0xa11c，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0xa134，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0xa148，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0xa15c，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

-- stage05boss.ecl：GBoss1Girl，0xa18c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa18c，40号。
        H.at(a,v,0)
        -- 源0xa1a0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa1b4，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0xa1c8，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa1e0，42号。
        H.push(v,111)
        H.at(a,v,0)
        -- 源0xa1f4，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa208，11号。
        H.call(a,v,P["Boss1Girl"],"Boss1Girl",10,1)
        H.at(a,v,0)
        -- 源0xa238，1号。
        H.erase(a);return
    end
    P["GBoss1Girl"]=B.part1
end

-- stage05boss.ecl：GBoss2Phantom，0xa258；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa258，40号。
        H.at(a,v,0)
        -- 源0xa26c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa280，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa294，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa2ac，11号。
        H.call(a,v,P["Boss2Phantom"],"Boss2Phantom",96,1)
        H.at(a,v,0)
        -- 源0xa2e0，1号。
        H.erase(a);return
    end
    P["GBoss2Phantom"]=B.part1
end

-- stage05boss.ecl：GBoss3Phantom，0xa300；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa300，40号。
        H.at(a,v,0)
        -- 源0xa314，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa328，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa33c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa354，11号。
        H.call(a,v,P["Boss3Phantom"],"Boss3Phantom",96,1)
        H.at(a,v,0)
        -- 源0xa388，1号。
        H.erase(a);return
    end
    P["GBoss3Phantom"]=B.part1
end

-- stage05boss.ecl：GBossCard2Phantom，0xa3a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa3a8，40号。
        H.at(a,v,0)
        -- 源0xa3bc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa3d0，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xa3e4，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa3fc，11号。
        H.call(a,v,P["BossCard2Phantom"],"BossCard2Phantom",96,1)
        H.at(a,v,0)
        -- 源0xa434，1号。
        H.erase(a);return
    end
    P["GBossCard2Phantom"]=B.part1
end

-- stage05boss.ecl：GBossCard3Phantom，0xa454；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa454，40号。
        H.at(a,v,0)
        -- 源0xa468，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa47c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa490，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa4a8，11号。
        H.call(a,v,P["BossCard3Phantom"],"BossCard3Phantom",96,1)
        H.at(a,v,0)
        -- 源0xa4e0，1号。
        H.erase(a);return
    end
    P["GBossCard3Phantom"]=B.part1
end

-- stage05boss.ecl：GBossCard4Phantom，0xa500；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa500，40号。
        H.at(a,v,0)
        -- 源0xa514，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa528，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xa53c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0xa554，11号。
        H.call(a,v,P["BossCard4Phantom"],"BossCard4Phantom",96,1)
        H.at(a,v,0)
        -- 源0xa58c，1号。
        H.erase(a);return
    end
    P["GBossCard4Phantom"]=B.part1
end

-- stage05boss.ecl：RBoss1Girl，0xa5ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa5ac，40号。
        H.at(a,v,0)
        -- 源0xa5c0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xa5d4，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xa5ec，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xa600，42号。
        H.push(v,110)
        H.at(a,v,0)
        -- 源0xa614，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa628，11号。
        H.call(a,v,P["Boss1Girl"],"Boss1Girl",5,1)
        H.at(a,v,0)
        -- 源0xa658，1号。
        H.erase(a);return
    end
    P["RBoss1Girl"]=B.part1
end

-- stage05boss.ecl：RBoss1Girl_at，0xa678；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa678，40号。
        H.at(a,v,0)
        -- 源0xa68c，355号。
        v.l[4]=H.int(8)
        H.at(a,v,0)
        -- 源0xa6b0，42号。
        H.push(v,18)
        H.at(a,v,0)
        -- 源0xa6c4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa6d8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xa6ec，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xa704，402号。
        H.gun_sprite(a,0,6,10)
        H.at(a,v,0)
        -- 源0xa720，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0xa754，404号。
        H.gun_angle(a,0,0.0,1.0471975803375244)
        H.at(a,v,0)
        -- 源0xa770，435号。
        H.gun_speed_diff(a,0,1.600000023841858,2.0,4.199999809265137,4.199999809265137,2.0,2.0,2.0,2.0)
        H.at(a,v,0)
        -- 源0xa7a4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa7d4，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa804，44号。
        H.push(v,1.7671459913253784)
        H.at(a,v,0)
        -- 源0xa818，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa82c，44号。
        H.push(v,1.374446988105774)
        H.at(a,v,0)
        -- 源0xa840，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa854，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa86c，44号。
        H.push(v,0.005235999822616577)
        H.at(a,v,0)
        -- 源0xa880，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa894，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xa8a8，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa8bc，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xa8d0，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xa8e4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xa8f4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa908，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xa918，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa92c，404号。
        H.gun_angle(a,0,(v.l[20] or 0),0.0)
        H.at(a,v,0)
        -- 源0xa948，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xa95c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa970，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xa980，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa994，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa9ac，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xa9dc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xa9f0，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaa20，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xaa34，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05999999865889549,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaa64，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xaa78，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.07999999821186066,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaaa8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xaabc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaad0，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xaae4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xaaf4，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xab08，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xab1c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xab34，44号。
        H.push(v,0.005235999822616577)
        H.at(a,v,0)
        -- 源0xab48，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xab5c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xab70，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xab84，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xab98，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xabac，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xabbc，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xabd0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xabe0，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xabf4，404号。
        H.gun_angle(a,0,(v.l[24] or 0),0.0)
        H.at(a,v,0)
        -- 源0xac10，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xac24，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xac38，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xac48，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xac5c，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xac74，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.0,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaca4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xacb8，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.007000000216066837,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xace8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xacfc，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.05999999865889549,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xad2c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xad40，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,-0.07999999821186066,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xad70，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xad84，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xad98，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xadac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xadbc，45号。
        v.l[12]=H.f32(H.pop(v))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xadd0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0xade4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xadfc，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0xae10，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0xae24，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xae34，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xae48，82号。
        v.l[20]=H.f32(H.angle((v.l[20] or 0)))
        H.at(a,v,0)
        -- 源0xae5c，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0xae70，44号。
        H.push(v,0.26179900765419006)
        H.at(a,v,0)
        -- 源0xae84，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xae94，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xaea8，82号。
        v.l[24]=H.f32(H.angle((v.l[24] or 0)))
        H.at(a,v,0)
        -- 源0xaebc，83号。
        v.origin=v.origin+H.int(10)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xaed0，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xaee4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xaefc，10号。
        return
    end
    P["RBoss1Girl_at"]=B.part1
end

-- stage05boss.ecl：RBoss2Phantom，0xaf1c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xaf1c，40号。
        H.at(a,v,0)
        -- 源0xaf30，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xaf44，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xaf5c，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xaf70，11号。
        H.call(a,v,P["Boss2Phantom"],"Boss2Phantom",94,1)
        H.at(a,v,0)
        -- 源0xafa4，1号。
        H.erase(a);return
    end
    P["RBoss2Phantom"]=B.part1
end

-- stage05boss.ecl：RBoss3Phantom，0xafc4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xafc4，40号。
        H.at(a,v,0)
        -- 源0xafd8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xafec，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xb004，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xb018，11号。
        H.call(a,v,P["Boss3Phantom"],"Boss3Phantom",94,1)
        H.at(a,v,0)
        -- 源0xb04c，1号。
        H.erase(a);return
    end
    P["RBoss3Phantom"]=B.part1
end

-- stage05boss.ecl：RBossCard2Phantom，0xb06c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb06c，40号。
        H.at(a,v,0)
        -- 源0xb080，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb094，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xb0a8，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xb0bc，11号。
        H.call(a,v,P["BossCard2Phantom"],"BossCard2Phantom",94,1)
        H.at(a,v,0)
        -- 源0xb0f4，1号。
        H.erase(a);return
    end
    P["RBossCard2Phantom"]=B.part1
end

-- stage05boss.ecl：RBossCard3Phantom，0xb114；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb114，40号。
        H.at(a,v,0)
        -- 源0xb128，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb13c，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xb154，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xb168，11号。
        H.call(a,v,P["BossCard3Phantom"],"BossCard3Phantom",94,1)
        H.at(a,v,0)
        -- 源0xb1a0，1号。
        H.erase(a);return
    end
    P["RBossCard3Phantom"]=B.part1
end

-- stage05boss.ecl：RBossCard4Phantom，0xb1c0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb1c0，40号。
        H.at(a,v,0)
        -- 源0xb1d4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb1e8，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xb200，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0xb214，11号。
        H.call(a,v,P["BossCard4Phantom"],"BossCard4Phantom",94,1)
        H.at(a,v,0)
        -- 源0xb24c，1号。
        H.erase(a);return
    end
    P["RBossCard4Phantom"]=B.part1
end

-- stage05boss.ecl：YBoss1Girl，0xb26c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb26c，40号。
        H.at(a,v,0)
        -- 源0xb280，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb294，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb2ac，42号。
        H.push(v,112)
        H.at(a,v,0)
        -- 源0xb2c0，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb2d4，11号。
        H.call(a,v,P["Boss1Girl"],"Boss1Girl",15,1)
        H.at(a,v,0)
        -- 源0xb304，1号。
        H.erase(a);return
    end
    P["YBoss1Girl"]=B.part1
end

-- stage05boss.ecl：YBoss2Phantom，0xb324；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb324，40号。
        H.at(a,v,0)
        -- 源0xb338，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb34c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb360，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb378，11号。
        H.call(a,v,P["Boss2Phantom"],"Boss2Phantom",100,1)
        H.at(a,v,0)
        -- 源0xb3ac，1号。
        H.erase(a);return
    end
    P["YBoss2Phantom"]=B.part1
end

-- stage05boss.ecl：YBoss3Phantom，0xb3cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb3cc，40号。
        H.at(a,v,0)
        -- 源0xb3e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb3f4，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb408，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb420，11号。
        H.call(a,v,P["Boss3Phantom"],"Boss3Phantom",100,1)
        H.at(a,v,0)
        -- 源0xb454，1号。
        H.erase(a);return
    end
    P["YBoss3Phantom"]=B.part1
end

-- stage05boss.ecl：YBossCard2Phantom，0xb474；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb474，40号。
        H.at(a,v,0)
        -- 源0xb488，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb49c，330号。
        H.drop_main(a,0)
        H.at(a,v,0)
        -- 源0xb4b0，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb4c8，11号。
        H.call(a,v,P["BossCard2Phantom"],"BossCard2Phantom",100,1)
        H.at(a,v,0)
        -- 源0xb500，1号。
        H.erase(a);return
    end
    P["YBossCard2Phantom"]=B.part1
end

-- stage05boss.ecl：YBossCard3Phantom，0xb520；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb520，40号。
        H.at(a,v,0)
        -- 源0xb534，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb548，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb55c，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb574，11号。
        H.call(a,v,P["BossCard3Phantom"],"BossCard3Phantom",100,1)
        H.at(a,v,0)
        -- 源0xb5ac，1号。
        H.erase(a);return
    end
    P["YBossCard3Phantom"]=B.part1
end

-- stage05boss.ecl：YBossCard4Phantom，0xb5cc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb5cc，40号。
        H.at(a,v,0)
        -- 源0xb5e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb5f4，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0xb608，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0xb620，11号。
        H.call(a,v,P["BossCard4Phantom"],"BossCard4Phantom",100,1)
        H.at(a,v,0)
        -- 源0xb658，1号。
        H.erase(a);return
    end
    P["YBossCard4Phantom"]=B.part1
end

return P
