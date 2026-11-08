-- 由 tools/th36-tests/expand.py 离线生成。手工改行为应同步修改展开器并核对原二进制。

local H,P=...

-- default.ecl：Ecl_EtBreak，0xb0；只编译Extra掩码。
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

-- default.ecl：Ecl_EtBreak2，0x1e8；只编译Extra掩码。
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

-- default.ecl：Ecl_EtBreak2_ni，0x320；只编译Extra掩码。
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

-- default.ecl：Ecl_EtBreak_ni，0x458；只编译Extra掩码。
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

-- default.ecl：et_ofs_r，0x590；只编译Extra掩码。
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

-- default.ecl：test，0x638；只编译Extra掩码。
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

-- stage07.ecl：BGirl00，0x2c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2c8，40号。
        H.at(a,v,0)
        -- 源0x2dc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x2f0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x304，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x31c，11号。
        H.call(a,v,P["Girl00"],"Girl00",0,1)
        H.at(a,v,0)
        -- 源0x348，1号。
        H.erase(a);return
    end
    P["BGirl00"]=B.part1
end

-- stage07.ecl：BGirl03，0x368；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x368，40号。
        H.at(a,v,0)
        -- 源0x37c，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x390，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3a4，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x3bc，11号。
        H.call(a,v,P["Girl03"],"Girl03",0)
        H.at(a,v,0)
        -- 源0x3e0，1号。
        H.erase(a);return
    end
    P["BGirl03"]=B.part1
end

-- stage07.ecl：BGirl05，0x400；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x400，40号。
        H.at(a,v,0)
        -- 源0x414，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x428，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x43c，262号。
        H.anm_main(a,1,45)
        H.at(a,v,0)
        -- 源0x454，11号。
        H.call(a,v,P["Girl05"],"Girl05",0)
        H.at(a,v,0)
        -- 源0x478，1号。
        H.erase(a);return
    end
    P["BGirl05"]=B.part1
end

-- stage07.ecl：GGirl00，0x498；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x498，40号。
        H.at(a,v,0)
        -- 源0x4ac，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x4c0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4d4，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x4ec，11号。
        H.call(a,v,P["Girl00"],"Girl00",10,1)
        H.at(a,v,0)
        -- 源0x518，1号。
        H.erase(a);return
    end
    P["GGirl00"]=B.part1
end

-- stage07.ecl：GGirl03，0x538；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x538，40号。
        H.at(a,v,0)
        -- 源0x54c，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x560，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x574，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x58c，11号。
        H.call(a,v,P["Girl03"],"Girl03",10)
        H.at(a,v,0)
        -- 源0x5b0，1号。
        H.erase(a);return
    end
    P["GGirl03"]=B.part1
end

-- stage07.ecl：GGirl05，0x5d0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5d0，40号。
        H.at(a,v,0)
        -- 源0x5e4，330号。
        H.drop_main(a,3)
        H.at(a,v,0)
        -- 源0x5f8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x60c，262号。
        H.anm_main(a,1,47)
        H.at(a,v,0)
        -- 源0x624，11号。
        H.call(a,v,P["Girl05"],"Girl05",10)
        H.at(a,v,0)
        -- 源0x648，1号。
        H.erase(a);return
    end
    P["GGirl05"]=B.part1
end

-- stage07.ecl：Girl00，0x668；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x668，40号。
        H.at(a,v,0)
        -- 源0x67c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x690，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6a8，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x6bc，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x6d0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x6e8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x700，44号。
        H.push(v,-1.5707963705062866)
        H.at(a,v,0)
        -- 源0x714，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x728，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x73c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x74c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x75c，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x770，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x784，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x794，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7a4，284号。
        H.velocity(a,0,H.read(a,v,-1),8.0)
        H.at(a,v,30)
        -- 源0x7bc，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,80)
        -- 源0x7dc，15号。
        H.async(a,P["RGirl00_at"],"RGirl00_at",nil,(v.l[4] or 0))
        H.at(a,v,230)
        -- 源0x804，284号。
        H.velocity(a,0,0.39269909262657166,0.0)
        H.at(a,v,230)
        -- 源0x81c，285号。
        H.velocity_time(a,0,100,0,0.39269909262657166,3.0)
        H.at(a,v,6230)
        -- 源0x83c，0号。
        H.at(a,v,6230)
        -- 源0x84c，10号。
        return
    end
    P["Girl00"]=B.part1
end

-- stage07.ecl：Girl01，0x86c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x86c，40号。
        H.at(a,v,0)
        -- 源0x880，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x894，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x8ac，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x8c0，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x8d8，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x8f0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x900，327号。
        H.drop_extra(a,1,5)
        H.at(a,v,0)
        -- 源0x918，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0x930，327号。
        H.drop_extra(a,3,10)
        H.at(a,v,0)
        -- 源0x948，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x960，284号。
        H.velocity(a,0,1.5707963705062866,0.699999988079071)
        H.at(a,v,0)
        -- 源0x978，15号。
        H.async(a,P["RGirl01_at"],"RGirl01_at",nil)
        H.at(a,v,6000)
        -- 源0x998，0号。
        H.at(a,v,6000)
        -- 源0x9a8，1号。
        H.erase(a);return
    end
    P["Girl01"]=B.part1
end

-- stage07.ecl：Girl01b，0x9c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9c8，40号。
        H.at(a,v,0)
        -- 源0x9dc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x9f0，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0xa08，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xa1c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xa34，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xa4c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xa5c，327号。
        H.drop_extra(a,1,5)
        H.at(a,v,0)
        -- 源0xa74，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0xa8c，327号。
        H.drop_extra(a,3,10)
        H.at(a,v,0)
        -- 源0xaa4，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0xabc，284号。
        H.velocity(a,0,1.5707963705062866,0.699999988079071)
        H.at(a,v,0)
        -- 源0xad4，15号。
        H.async(a,P["RGirl01_at"],"RGirl01_at",nil)
        H.at(a,v,6000)
        -- 源0xaf4，0号。
        H.at(a,v,6000)
        -- 源0xb04，1号。
        H.erase(a);return
    end
    P["Girl01b"]=B.part1
end

-- stage07.ecl：Girl02，0xb24；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb24，40号。
        H.at(a,v,0)
        -- 源0xb38，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xb4c，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0xb64，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xb78，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xb90，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xba8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xbb8，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0xbd0，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0xbe8，327号。
        H.drop_extra(a,3,10)
        H.at(a,v,0)
        -- 源0xc00，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xc18，284号。
        H.velocity(a,0,1.5707963705062866,1.7000000476837158)
        H.at(a,v,0)
        -- 源0xc30，15号。
        H.async(a,P["RGirl02_at"],"RGirl02_at",nil)
        H.at(a,v,80)
        -- 源0xc50，285号。
        H.velocity_time(a,0,60,0,-999999.0,0.0)
        H.at(a,v,240)
        -- 源0xc70，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,240)
        -- 源0xc88，285号。
        H.velocity_time(a,0,60,0,-999999.0,1.0)
        H.at(a,v,6240)
        -- 源0xca8，0号。
        H.at(a,v,6240)
        -- 源0xcb8，1号。
        H.erase(a);return
    end
    P["Girl02"]=B.part1
end

-- stage07.ecl：Girl03，0xcd8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcd8，40号。
        H.at(a,v,0)
        -- 源0xcec，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd00，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd18，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xd2c，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0xd40，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xd58，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xd70，15号。
        H.async(a,P["RGirl03_at"],"RGirl03_at",nil)
        H.at(a,v,0)
        -- 源0xd90，284号。
        H.velocity(a,0,0.0,5.0)
        H.at(a,v,50)
        -- 源0xda8，285号。
        H.velocity_time(a,0,30,0,3.1415927410125732,-999999.0)
        H.at(a,v,6050)
        -- 源0xdc8，0号。
        H.at(a,v,6050)
        -- 源0xdd8，10号。
        return
    end
    P["Girl03"]=B.part1
end

-- stage07.ecl：Girl04，0xdf8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xdf8，40号。
        H.at(a,v,0)
        -- 源0xe0c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xe20，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0xe38，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0xe4c，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xe64，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xe7c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xe8c，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0xea4，327号。
        H.drop_extra(a,2,6)
        H.at(a,v,0)
        -- 源0xebc，327号。
        H.drop_extra(a,3,6)
        H.at(a,v,0)
        -- 源0xed4，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xeec，284号。
        H.velocity(a,0,1.5707963705062866,5.699999809265137)
        H.at(a,v,0)
        -- 源0xf04，15号。
        H.async(a,P["RGirl04_at"],"RGirl04_at",nil)
        H.at(a,v,10)
        -- 源0xf24，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,170)
        -- 源0xf44，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,170)
        -- 源0xf5c，285号。
        H.velocity_time(a,0,60,0,-999999.0,3.0)
        H.at(a,v,6170)
        -- 源0xf7c，0号。
        H.at(a,v,6170)
        -- 源0xf8c，1号。
        H.erase(a);return
    end
    P["Girl04"]=B.part1
end

-- stage07.ecl：Girl05，0xfac；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfac，40号。
        H.at(a,v,0)
        -- 源0xfc0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xfd4，262号。
        H.anm_main(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xfec，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x1000，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x1014，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x102c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1044，15号。
        H.async(a,P["RGirl05_at"],"RGirl05_at",nil)
        H.at(a,v,0)
        -- 源0x1064，284号。
        H.velocity(a,0,0.0,5.0)
        H.at(a,v,50)
        -- 源0x107c，285号。
        H.velocity_time(a,0,30,0,3.1415927410125732,-999999.0)
        H.at(a,v,6050)
        -- 源0x109c，0号。
        H.at(a,v,6050)
        -- 源0x10ac，10号。
        return
    end
    P["Girl05"]=B.part1
end

-- stage07.ecl：Girl06，0x10cc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x10cc，40号。
        H.at(a,v,0)
        -- 源0x10e0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x10f4，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x110c，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x1120，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x1138，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1150，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1160，327号。
        H.drop_extra(a,1,2)
        H.at(a,v,0)
        -- 源0x1178，327号。
        H.drop_extra(a,2,6)
        H.at(a,v,0)
        -- 源0x1190，327号。
        H.drop_extra(a,3,6)
        H.at(a,v,0)
        -- 源0x11a8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x11c0，284号。
        H.velocity(a,0,1.5707963705062866,5.699999809265137)
        H.at(a,v,0)
        -- 源0x11d8，15号。
        H.async(a,P["RGirl06_at"],"RGirl06_at",nil)
        H.at(a,v,10)
        -- 源0x11f8，285号。
        H.velocity_time(a,0,30,0,-999999.0,0.0)
        H.at(a,v,170)
        -- 源0x1218，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,170)
        -- 源0x1230，285号。
        H.velocity_time(a,0,60,0,-999999.0,2.0)
        H.at(a,v,6170)
        -- 源0x1250，0号。
        H.at(a,v,6170)
        -- 源0x1260，1号。
        H.erase(a);return
    end
    P["Girl06"]=B.part1
end

-- stage07.ecl：Girl07，0x1280；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1280，40号。
        H.at(a,v,0)
        -- 源0x1294，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x12a8，262号。
        H.anm_main(a,0,40)
        H.at(a,v,0)
        -- 源0x12c0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x12d4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x12ec，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1304，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1314，327号。
        H.drop_extra(a,1,3)
        H.at(a,v,0)
        -- 源0x132c，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,0)
        -- 源0x1344，327号。
        H.drop_extra(a,3,10)
        H.at(a,v,0)
        -- 源0x135c，328号。
        H.drop_area(a,32.0,32.0)
        H.at(a,v,0)
        -- 源0x1374，284号。
        H.velocity(a,0,1.5707963705062866,0.699999988079071)
        H.at(a,v,0)
        -- 源0x138c，15号。
        H.async(a,P["RGirl01_at"],"RGirl01_at",nil)
        H.at(a,v,6000)
        -- 源0x13ac，0号。
        H.at(a,v,6000)
        -- 源0x13bc，1号。
        H.erase(a);return
    end
    P["Girl07"]=B.part1
end

-- stage07.ecl：MainBossDebug，0x13dc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13dc，40号。
        H.at(a,v,60)
        -- 源0x13f0，338号。
        H.dialog(a,-1)
        H.at(a,v,60)
        -- 源0x1404，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x1414，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,60)
        -- 源0x1444，500号。
        H.debug_entry(a,100)
        H.at(a,v,60)
        -- 源0x1458，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x1468，340号。
        H.boss_wait(a,v)
        H.at(a,v,120)
        -- 源0x1478，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x148c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x149c，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage07.ecl：MainMBossDebug，0x14cc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x14cc，40号。
        H.at(a,v,0)
        -- 源0x14e0，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x14f4，500号。
        H.debug_entry(a,100)
        H.at(a,v,0)
        -- 源0x1508，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x1538，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1550，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1564，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1578，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1590，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage07.ecl：MainMsgDebug，0x15b0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x15b0，40号。
        H.at(a,v,0)
        -- 源0x15c4，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0x15d8，338号。
        H.dialog(a,0)
        H.at(a,v,120)
        -- 源0x15ec，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x15fc，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,121)
        -- 源0x162c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x163c，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0x1650，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x1660，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0x1678，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0x1688，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0x169c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0x16b4，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage07.ecl：MainSub00，0x16d4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x16d4，40号。
        H.at(a,v,0)
        -- 源0x16e8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x16fc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1710，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1728，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x173c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1750，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x1760，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1774，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1784，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x179c，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x17b0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x17c4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x17d8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x17e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x17f8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x180c，257号。
        H.spawn(a,257,"RGirl00",(v.l[4] or 0),464.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x183c，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1854，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x1868，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x187c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1890，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x18a0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x18b0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x18c4，261号。
        H.spawn(a,261,"RGirl00",(v.l[4] or 0),464.0,20,1000,1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x18f4，83号。
        v.origin=v.origin+H.int(10)
        H.at(a,v,0)
        -- 源0x1908，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x191c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1930，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1940，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1954，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1968，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x197c，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x198c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x19a4，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage07.ecl：MainSub01，0x19c4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x19c4，40号。
        H.at(a,v,0)
        -- 源0x19d8，257号。
        H.spawn(a,257,"Girl01",0.0,-32.0,2000,1000,2)
        H.at(a,v,0)
        -- 源0x1a08，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x1a1c，257号。
        H.spawn(a,257,"Girl01",48.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1a4c，257号。
        H.spawn(a,257,"Girl01",-48.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1a7c，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x1a90，257号。
        H.spawn(a,257,"Girl01",96.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1ac0，257号。
        H.spawn(a,257,"Girl01",-96.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1af0，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x1b04，257号。
        H.spawn(a,257,"Girl01",144.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1b34，257号。
        H.spawn(a,257,"Girl01",-144.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1b64，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage07.ecl：MainSub02，0x1b84；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1b84，40号。
        H.at(a,v,0)
        -- 源0x1b98，257号。
        H.spawn(a,257,"Girl02",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x1bc8，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage07.ecl：MainSub03，0x1be8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1be8，40号。
        H.at(a,v,0)
        -- 源0x1bfc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1c10，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c24，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1c3c，257号。
        H.spawn(a,257,"BGirl03",-224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x1c6c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1c80，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1c94，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1ca8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1cb8，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1ccc，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ce0，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1cf4，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1d04，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1d1c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1d30，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1d44，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1d5c，261号。
        H.spawn(a,261,"BGirl03",224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x1d8c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1da0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1db4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1dc8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1dd8，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1dec，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1e00，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1e14，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1e24，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1e3c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1e50，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e64，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1e7c，257号。
        H.spawn(a,257,"BGirl03",-224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x1eac，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1ec0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ed4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1ee8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1ef8，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x1f0c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1f20，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1f34，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1f44，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x1f5c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1f70，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f84，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x1f9c，261号。
        H.spawn(a,261,"BGirl03",224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x1fcc，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x1fe0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1ff4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2008，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2018，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x202c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2040，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2054，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2064，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x207c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2090，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x20a4，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x20bc，257号。
        H.spawn(a,257,"BGirl03",-224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x20ec，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x2100，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2114，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2128，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2138，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x214c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2160，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2174，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2184，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x219c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x21b0，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x21c4，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x21dc，261号。
        H.spawn(a,261,"BGirl03",224.0,128.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x220c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x2220，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2234，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2248，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2258，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x226c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2280，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2294，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x22a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x22bc，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage07.ecl：MainSub04，0x22dc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x22dc，40号。
        H.at(a,v,0)
        -- 源0x22f0，257号。
        H.spawn(a,257,"Girl04",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x2320，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x2334，257号。
        H.spawn(a,257,"Girl04",128.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x2364，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x2378，257号。
        H.spawn(a,257,"Girl04",64.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x23a8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x23bc，257号。
        H.spawn(a,257,"Girl04",-64.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x23ec，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x2400，257号。
        H.spawn(a,257,"Girl04",-128.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x2430，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x2444，257号。
        H.spawn(a,257,"Girl04",-144.0,-32.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x2474，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2488，257号。
        H.spawn(a,257,"Girl04",-72.0,-32.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x24b8，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x24cc，257号。
        H.spawn(a,257,"Girl04",0.0,-32.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x24fc，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2510，257号。
        H.spawn(a,257,"Girl04",72.0,-32.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x2540，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x2554，257号。
        H.spawn(a,257,"Girl04",144.0,-32.0,500,1000,2)
        H.at(a,v,0)
        -- 源0x2584，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage07.ecl：MainSub05，0x25a4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x25a4，40号。
        H.at(a,v,0)
        -- 源0x25b8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x25cc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x25e0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x25f8，257号。
        H.spawn(a,257,"BGirl05",-224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2628，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x263c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2650，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2664，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2674，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2688，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x269c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x26b0，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x26c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x26d8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x26ec，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2700，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2718，261号。
        H.spawn(a,261,"BGirl05",224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2748，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x275c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2770，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2784，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2794，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x27a8，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x27bc，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x27d0，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x27e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x27f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x280c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2820，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2838，257号。
        H.spawn(a,257,"BGirl05",-224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2868，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x287c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2890，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x28a4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x28b4，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x28c8，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x28dc，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x28f0，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2900，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x2918，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x292c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2940，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x2958，261号。
        H.spawn(a,261,"BGirl05",224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2988，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x299c，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x29b0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x29c4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x29d4，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x29e8，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x29fc，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2a10，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2a20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x2a38，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2a4c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2a60，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x2a78，257号。
        H.spawn(a,257,"BGirl05",-224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2aa8，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x2abc，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2ad0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2ae4，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2af4，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x2b08，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2b1c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2b30，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2b40，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x2b58，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2b6c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b80，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x2b98，261号。
        H.spawn(a,261,"BGirl05",224.0,160.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x2bc8，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x2bdc，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2bf0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2c04，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x2c14，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x2c28，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2c3c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x2c50，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2c60，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x2c78，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage07.ecl：MainSub06，0x2c98；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2c98，40号。
        H.at(a,v,0)
        -- 源0x2cac，257号。
        H.spawn(a,257,"Girl06",0.0,-32.0,1000,1000,2)
        H.at(a,v,0)
        -- 源0x2cdc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2cf0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2d04，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2d18，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2d28，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2d58，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2d6c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2d80，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2d94，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2da4，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2dd4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2de8，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x2dfc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2e10，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2e24，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2e34，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2e44，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2e74，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2e88，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x2e9c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2eb0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2ec4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2ed4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2ee4，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2f14，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2f28，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x2f3c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2f50，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2f64，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2f74，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2f84，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x2fb4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2fc8，42号。
        H.push(v,-96)
        H.at(a,v,0)
        -- 源0x2fdc，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2ff0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x3004，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3014，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3024，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x3054，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x3068，42号。
        H.push(v,-96)
        H.at(a,v,0)
        -- 源0x307c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3090，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x30a4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x30b4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x30c4，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x30f4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x3108，42号。
        H.push(v,-96)
        H.at(a,v,0)
        -- 源0x311c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3130，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x3144，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3154，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3164，257号。
        H.spawn(a,257,"Girl06",H.read(a,v,-1),-32.0,600,1000,2)
        H.at(a,v,0)
        -- 源0x3194，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x31a8，10号。
        return
    end
    P["MainSub06"]=B.part1
end

-- stage07.ecl：MainSub07，0x31c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x31c8，40号。
        H.at(a,v,0)
        -- 源0x31dc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x31f0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3204，257号。
        H.spawn(a,257,"Girl01",0.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3234，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x3248，257号。
        H.spawn(a,257,"Girl01",48.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3278，257号。
        H.spawn(a,257,"Girl01",-48.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x32a8，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x32bc，257号。
        H.spawn(a,257,"Girl01",96.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x32ec，257号。
        H.spawn(a,257,"Girl01",-96.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x331c，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x3330，257号。
        H.spawn(a,257,"Girl01",144.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3360，257号。
        H.spawn(a,257,"Girl01",-144.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3390，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x33a4，257号。
        H.spawn(a,257,"Girl01",0.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x33d4，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x33e8，257号。
        H.spawn(a,257,"Girl01",48.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3418，257号。
        H.spawn(a,257,"Girl01",-48.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3448，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x345c，257号。
        H.spawn(a,257,"Girl01",96.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x348c，257号。
        H.spawn(a,257,"Girl01",-96.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x34bc，83号。
        v.origin=v.origin+H.int(150)
        H.at(a,v,0)
        -- 源0x34d0，257号。
        H.spawn(a,257,"Girl01b",144.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3500，257号。
        H.spawn(a,257,"Girl01b",-144.0,-32.0,800,1000,2)
        H.at(a,v,0)
        -- 源0x3530，10号。
        return
    end
    P["MainSub07"]=B.part1
end

-- stage07.ecl：MapleEnemy，0x3550；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3550，40号。
        H.at(a,v,0)
        -- 源0x3564，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3578，264号。
        H.effect_abs(a,0,179)
        H.at(a,v,3)
        -- 源0x3590，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x35a8，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage07.ecl：MapleEnemy2，0x35c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x35c8，40号。
        H.at(a,v,0)
        -- 源0x35dc，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x35f0，264号。
        H.effect_abs(a,0,190)
        H.at(a,v,3)
        -- 源0x3608，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x3620，1号。
        H.erase(a);return
    end
    P["MapleEnemy2"]=B.part1
end

-- stage07.ecl：RGirl00，0x3640；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3640，40号。
        H.at(a,v,0)
        -- 源0x3654，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3668，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0x3680，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x3694，11号。
        H.call(a,v,P["Girl00"],"Girl00",5,1)
        H.at(a,v,0)
        -- 源0x36c0，1号。
        H.erase(a);return
    end
    P["RGirl00"]=B.part1
end

-- stage07.ecl：RGirl00_at，0x36e0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x36e0，40号。
        H.at(a,v,0)
        -- 源0x36f4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x3708，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x371c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3730，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x3748，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0x3764，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x3780，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x379c，405号。
        H.gun_speed(a,0,5.5,2.0)
        H.at(a,v,0)
        -- 源0x37b8，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x37e8，409号。
        H.gun_transform(a,0,1,1,1,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3818，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3830，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x3844，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3858，404号。
        H.gun_angle(a,0,H.read(a,v,-9989),0.0)
        H.at(a,v,0)
        -- 源0x3874，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x388c，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x38a0，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x38b4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x38c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x38e0，83号。
        v.origin=v.origin+H.int(40)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x38f4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3908，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3920，10号。
        return
    end
    P["RGirl00_at"]=B.part1
end

-- stage07.ecl：RGirl01_at，0x3940；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3940，40号。
        H.at(a,v,0)
        -- 源0x3954，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x3968，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x397c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3990，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x39a8，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x39c4，406号。
        H.gun_count(a,0,56,1)
        H.at(a,v,0)
        -- 源0x39e0，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x39fc，405号。
        H.gun_speed(a,0,1.5,2.0)
        H.at(a,v,0)
        -- 源0x3a18，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3a48，438号。
        H.gun_distance(a,0,48.0)
        H.at(a,v,0)
        -- 源0x3a60，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3a78，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x3a94，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3aa8，83号。
        v.origin=v.origin+H.int(120)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3abc，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x3ad0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3ae8，10号。
        return
    end
    P["RGirl01_at"]=B.part1
end

-- stage07.ecl：RGirl02_at，0x3b08；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3b08，40号。
        H.at(a,v,0)
        -- 源0x3b1c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x3b30，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3b44，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3b58，407号。
        H.gun_aim(a,0,1)
        H.at(a,v,0)
        -- 源0x3b70，402号。
        H.gun_sprite(a,0,4,6)
        H.at(a,v,0)
        -- 源0x3b8c，406号。
        H.gun_count(a,0,2,4)
        H.at(a,v,0)
        -- 源0x3ba8，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x3bc4，405号。
        H.gun_speed(a,0,4.5,2.0)
        H.at(a,v,0)
        -- 源0x3be0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3c10，409号。
        H.gun_transform(a,0,1,0,32,60,1,0.0,3.0)
        H.at(a,v,0)
        -- 源0x3c40，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3c54，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3c68，44号。
        H.push(v,0.17453299462795258)
        H.at(a,v,0)
        -- 源0x3c7c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3c90，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3ca8，404号。
        H.gun_angle(a,0,H.read(a,v,-9989),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3cc4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3cd8，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3cec，44号。
        H.push(v,0.17453299462795258)
        H.at(a,v,0)
        -- 源0x3d00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3d10，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3d24，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x3d38，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3d4c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3d60，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3d78，10号。
        return
    end
    P["RGirl02_at"]=B.part1
end

-- stage07.ecl：RGirl03，0x3d98；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3d98，40号。
        H.at(a,v,0)
        -- 源0x3dac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3dc0，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0x3dd8，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x3dec，11号。
        H.call(a,v,P["Girl03"],"Girl03",5)
        H.at(a,v,0)
        -- 源0x3e10，1号。
        H.erase(a);return
    end
    P["RGirl03"]=B.part1
end

-- stage07.ecl：RGirl03_at，0x3e30；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3e30，40号。
        H.at(a,v,0)
        -- 源0x3e44，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x3e58，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e6c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x3e80，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e94，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3ea8，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x3ec0，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x3edc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x3ef8，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x3f14，405号。
        H.gun_speed(a,0,5.5,2.0)
        H.at(a,v,0)
        -- 源0x3f30，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3f60，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3f78，409号。
        H.gun_transform(a,0,1,0,16,60,1,H.read(a,v,-9998),1.0)
        H.at(a,v,0)
        -- 源0x3fa8，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x3fbc，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3fd0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3fe8，83号。
        v.origin=v.origin+H.int(5)
        H.at(a,v,0)
        -- 源0x3ffc，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4010，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x4024，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x403c，83号。
        v.origin=v.origin+H.int(10)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4050，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x4064，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x407c，10号。
        return
    end
    P["RGirl03_at"]=B.part1
end

-- stage07.ecl：RGirl04_at，0x409c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x409c，40号。
        H.at(a,v,0)
        -- 源0x40b0，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x40c4，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x40d8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x40ec，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x4104，402号。
        H.gun_sprite(a,0,4,6)
        H.at(a,v,0)
        -- 源0x4120，406号。
        H.gun_count(a,0,15,1)
        H.at(a,v,0)
        -- 源0x413c，404号。
        H.gun_angle(a,0,1.5707963705062866,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x4158，405号。
        H.gun_speed(a,0,6.5,2.0)
        H.at(a,v,0)
        -- 源0x4174，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x41a4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x41b8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x41cc，44号。
        H.push(v,0.17453299462795258)
        H.at(a,v,0)
        -- 源0x41e0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x41f4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x420c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x4220，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x4234，44号。
        H.push(v,0.17453299462795258)
        H.at(a,v,0)
        -- 源0x4248，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4258，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x426c，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0x4280，83号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4294，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x42a8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x42c0，10号。
        return
    end
    P["RGirl04_at"]=B.part1
end

-- stage07.ecl：RGirl05，0x42e0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x42e0，40号。
        H.at(a,v,0)
        -- 源0x42f4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4308，262号。
        H.anm_main(a,1,46)
        H.at(a,v,0)
        -- 源0x4320，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x4334，11号。
        H.call(a,v,P["Girl05"],"Girl05",5)
        H.at(a,v,0)
        -- 源0x4358，1号。
        H.erase(a);return
    end
    P["RGirl05"]=B.part1
end

-- stage07.ecl：RGirl05_at，0x4378；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4378，40号。
        H.at(a,v,0)
        -- 源0x438c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x43a0，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x43b4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x43c8，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x43dc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x43f0，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x4408，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x4424，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x4440，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x445c，405号。
        H.gun_speed(a,0,5.5,2.0)
        H.at(a,v,0)
        -- 源0x4478，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x44a8，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x44c0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x44d4，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x44e8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x44f8，409号。
        H.gun_transform(a,0,1,0,16,60,1,H.read(a,v,-1),3.0)
        H.at(a,v,0)
        -- 源0x4528，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x453c，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4550，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4568，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0x457c，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4590，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x45a4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x45bc，83号。
        v.origin=v.origin+H.int(10)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x45d0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x45e4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x45fc，10号。
        return
    end
    P["RGirl05_at"]=B.part1
end

-- stage07.ecl：RGirl06_at，0x461c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x461c，40号。
        H.at(a,v,0)
        -- 源0x4630，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x4644，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4658，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x466c，407号。
        H.gun_aim(a,0,0)
        H.at(a,v,0)
        -- 源0x4684，402号。
        H.gun_sprite(a,0,17,2)
        H.at(a,v,0)
        -- 源0x46a0，406号。
        H.gun_count(a,0,3,1)
        H.at(a,v,0)
        -- 源0x46bc，404号。
        H.gun_angle(a,0,1.5707963705062866,0.7853981852531433)
        H.at(a,v,0)
        -- 源0x46d8，405号。
        H.gun_speed(a,0,2.299999952316284,2.0)
        H.at(a,v,0)
        -- 源0x46f4，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4724，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.05000000074505806,-999999.0)
        H.at(a,v,0)
        -- 源0x4754，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x4768，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4780，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4794，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x47a8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x47b8，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.7853981852531433)
        H.at(a,v,0)
        -- 源0x47d4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x47e8，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x47fc，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x4810，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4828，10号。
        return
    end
    P["RGirl06_at"]=B.part1
end

-- stage07.ecl：RGirl07_at，0x4848；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4848，40号。
        H.at(a,v,0)
        -- 源0x485c，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x4870，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x4884，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x4898，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x48b0，402号。
        H.gun_sprite(a,0,3,6)
        H.at(a,v,0)
        -- 源0x48cc，406号。
        H.gun_count(a,0,56,1)
        H.at(a,v,0)
        -- 源0x48e8，404号。
        H.gun_angle(a,0,0.0,0.03272492438554764)
        H.at(a,v,0)
        -- 源0x4904，405号。
        H.gun_speed(a,0,1.0,2.0)
        H.at(a,v,0)
        -- 源0x4920，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4950，438号。
        H.gun_distance(a,0,48.0)
        H.at(a,v,0)
        -- 源0x4968，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4980，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x499c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x49b0，83号。
        v.origin=v.origin+H.int(100)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x49c4，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x49d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x49f0，10号。
        return
    end
    P["RGirl07_at"]=B.part1
end

-- stage07.ecl：YGirl00，0x4a10；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a10，40号。
        H.at(a,v,0)
        -- 源0x4a24，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4a38，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x4a50，11号。
        H.call(a,v,P["Girl00"],"Girl00",15,1)
        H.at(a,v,0)
        -- 源0x4a7c，1号。
        H.erase(a);return
    end
    P["YGirl00"]=B.part1
end

-- stage07.ecl：YGirl03，0x4a9c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a9c，40号。
        H.at(a,v,0)
        -- 源0x4ab0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4ac4，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x4adc，11号。
        H.call(a,v,P["Girl03"],"Girl03",15)
        H.at(a,v,0)
        -- 源0x4b00，1号。
        H.erase(a);return
    end
    P["YGirl03"]=B.part1
end

-- stage07.ecl：YGirl05，0x4b20；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4b20，40号。
        H.at(a,v,0)
        -- 源0x4b34，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x4b48，262号。
        H.anm_main(a,1,48)
        H.at(a,v,0)
        -- 源0x4b60，11号。
        H.call(a,v,P["Girl05"],"Girl05",15)
        H.at(a,v,0)
        -- 源0x4b84，1号。
        H.erase(a);return
    end
    P["YGirl05"]=B.part1
end

-- stage07.ecl：main，0x4ba4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4ba4，40号。
        H.at(a,v,0)
        -- 源0x4bb8，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x4bcc，257号。
        H.spawn(a,257,"MapleEnemy2",0.0,-16.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x4c00，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x4c14，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,0)
        -- 源0x4c34，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x4c48，11号。
        H.call(a,v,P["MainSub01"],"MainSub01")
        H.at(a,v,0)
        -- 源0x4c68，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x4c7c，11号。
        H.call(a,v,P["MainSub02"],"MainSub02")
        H.at(a,v,0)
        -- 源0x4c9c，83号。
        v.origin=v.origin+H.int(300)
        H.at(a,v,0)
        -- 源0x4cb0，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,0)
        -- 源0x4cd0，83号。
        v.origin=v.origin+H.int(260)
        H.at(a,v,0)
        -- 源0x4ce4，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0x4d04，83号。
        v.origin=v.origin+H.int(260)
        H.at(a,v,0)
        -- 源0x4d18，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x4d2c，257号。
        H.spawn(a,257,"MBoss",-192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x4d5c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x4d6c，340号。
        H.boss_wait(a,v)
        H.at(a,v,0)
        -- 源0x4d7c，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,0)
        -- 源0x4d9c，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x4db0，11号。
        H.call(a,v,P["MainSub06"],"MainSub06")
        H.at(a,v,0)
        -- 源0x4dd0，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x4de4，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,0)
        -- 源0x4e04，11号。
        H.call(a,v,P["MainSub07"],"MainSub07")
        H.at(a,v,0)
        -- 源0x4e24，83号。
        v.origin=v.origin+H.int(400)
        H.at(a,v,0)
        -- 源0x4e38，338号。
        H.dialog(a,0)
        H.at(a,v,0)
        -- 源0x4e4c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x4e5c，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,0)
        -- 源0x4e8c，340号。
        H.boss_wait(a,v)
        H.at(a,v,0)
        -- 源0x4e9c，338号。
        H.dialog(a,1)
        H.at(a,v,0)
        -- 源0x4eb0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x4ec0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4ed8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4eec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4f00，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4f18，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x4f2c，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0x4f40，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x4f54，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x4f84，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x4f94，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4fac，83号。
        v.origin=v.origin+H.int(1000)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4fc0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4fd4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,40000)
        -- 源0x4fec，0号。
        H.at(a,v,40000)
        -- 源0x4ffc，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

-- stage07mboss.ecl：MBoss，0x120；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x120，40号。
        H.at(a,v,0)
        -- 源0x134，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x148，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x15c，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0x174，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x188，262号。
        H.anm_main(a,0,14)
        H.at(a,v,0)
        -- 源0x1a0，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x1b4，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1cc，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x1e4，331号。
        H.life(a,3000)
        H.at(a,v,0)
        -- 源0x1f8，347号。
        H.life_marker(a,0,3000.0,-24448)
        H.at(a,v,0)
        -- 源0x214，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x228，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x23c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x250，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x264，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x284，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,60)
        -- 源0x298，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x2a8，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,60)
        -- 源0x2c8，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x2dc，440号。
        H.fog(a,160.0,8421376)
        H.at(a,v,60)
        -- 源0x2f4，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x308，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x320，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x334，11号。
        H.call(a,v,P["MBossCard1"],"MBossCard1")
        H.at(a,v,60)
        -- 源0x354，12号。
        v.origin=H.clock(a)-(60);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x36c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x380，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x394，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x3ac，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage07mboss.ecl：MBossCard1，0x3cc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3cc，40号。
        H.at(a,v,0)
        -- 源0x3e0，342号。
        H.spell(a,162,3600,0,"秘法「九字刺し」",342)
        H.at(a,v,0)
        -- 源0x414，331号。
        H.life(a,3000)
        H.at(a,v,0)
        -- 源0x428，347号。
        H.life_marker(a,0,3000.0,-24448)
        H.at(a,v,0)
        -- 源0x444，334号。
        H.interrupt(a,0,0,3600,"MBossCard2")
        H.at(a,v,0)
        -- 源0x470，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x480，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x494，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4c8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4d8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4ec，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x500，325号。
        a.limit=nil
        H.at(a,v,30)
        -- 源0x510，263号。
        H.effect(a,0,131)
        H.at(a,v,90)
        -- 源0x528，0号。
        H.at(a,v,90)
        -- 源0x538，322号。
        H.flags(a,12,true)
        H.at(a,v,90)
        -- 源0x54c，42号。
        H.push(v,50)
        H.at(a,v,90)
        -- 源0x560，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0x574，12号。
        v.origin=H.clock(a)-(274);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,90)
        -- 源0x58c，269号。
        H.anm_cast(a,0)
        H.at(a,v,90)
        -- 源0x5a0，15号。
        H.async(a,P["MBossCard1_at3"],"MBossCard1_at3",nil)
        H.at(a,v,150)
        -- 源0x5c4，0号。
        H.at(a,v,150)
        -- 源0x5d4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,150)
        -- 源0x5e8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x5fc，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,150)
        -- 源0x610，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,150)
        -- 源0x624，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,150)
        -- 源0x638，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,150)
        -- 源0x64c，42号。
        H.push(v,2)
        H.at(a,v,150)
        -- 源0x660，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,150)
        -- 源0x670，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,150)
        -- 源0x680，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil,(v.l[4] or 0),3.8832221031188965,H.read(a,v,-1),6)
        H.at(a,v,150)
        -- 源0x6c4，83号。
        v.origin=v.origin+H.int(130)
        H.at(a,v,150)
        -- 源0x6d8，269号。
        H.anm_cast(a,0)
        H.at(a,v,166)
        -- 源0x6ec，262号。
        H.anm_main(a,0,14)
        H.at(a,v,166)
        -- 源0x704，259号。
        H.anm_slot(a,0,14)
        H.at(a,v,166)
        -- 源0x71c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,166)
        -- 源0x730，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,166)
        -- 源0x744，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,166)
        -- 源0x758，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,166)
        -- 源0x76c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,166)
        -- 源0x77c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,166)
        -- 源0x790，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,166)
        -- 源0x7a4，42号。
        H.push(v,2)
        H.at(a,v,166)
        -- 源0x7b8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,166)
        -- 源0x7c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,166)
        -- 源0x7d8，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil,H.read(a,v,-1),-3.8832221031188965,H.read(a,v,-1),10)
        H.at(a,v,166)
        -- 源0x81c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,166)
        -- 源0x830，269号。
        H.anm_cast(a,0)
        H.at(a,v,182)
        -- 源0x844，262号。
        H.anm_main(a,0,14)
        H.at(a,v,182)
        -- 源0x85c，259号。
        H.anm_slot(a,0,14)
        H.at(a,v,182)
        -- 源0x874，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,182)
        -- 源0x888，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,182)
        -- 源0x89c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,182)
        -- 源0x8ac，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,182)
        -- 源0x8c0，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,182)
        -- 源0x8d4，269号。
        H.anm_cast(a,0)
        H.at(a,v,182)
        -- 源0x8e8，15号。
        H.async(a,P["MBossCard1_at3b"],"MBossCard1_at3b",nil)
        H.at(a,v,242)
        -- 源0x90c，0号。
        H.at(a,v,242)
        -- 源0x91c，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,242)
        -- 源0x930，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,242)
        -- 源0x944，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,242)
        -- 源0x958，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,242)
        -- 源0x96c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,242)
        -- 源0x980，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,242)
        -- 源0x994，42号。
        H.push(v,2)
        H.at(a,v,242)
        -- 源0x9a8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,242)
        -- 源0x9b8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,242)
        -- 源0x9c8，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil,(v.l[4] or 0),-3.8832221031188965,H.read(a,v,-1),6)
        H.at(a,v,242)
        -- 源0xa0c，83号。
        v.origin=v.origin+H.int(130)
        H.at(a,v,242)
        -- 源0xa20，269号。
        H.anm_cast(a,0)
        H.at(a,v,258)
        -- 源0xa34，262号。
        H.anm_main(a,0,14)
        H.at(a,v,258)
        -- 源0xa4c，259号。
        H.anm_slot(a,0,14)
        H.at(a,v,258)
        -- 源0xa64，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,258)
        -- 源0xa78，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,258)
        -- 源0xa8c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,258)
        -- 源0xaa0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,258)
        -- 源0xab4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,258)
        -- 源0xac4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,258)
        -- 源0xad8，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,258)
        -- 源0xaec，42号。
        H.push(v,2)
        H.at(a,v,258)
        -- 源0xb00，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,258)
        -- 源0xb10，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,258)
        -- 源0xb20，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil,H.read(a,v,-1),3.8832221031188965,H.read(a,v,-1),10)
        H.at(a,v,258)
        -- 源0xb64，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,258)
        -- 源0xb78，269号。
        H.anm_cast(a,0)
        H.at(a,v,274)
        -- 源0xb8c，262号。
        H.anm_main(a,0,14)
        H.at(a,v,274)
        -- 源0xba4，259号。
        H.anm_slot(a,0,14)
        H.at(a,v,274)
        -- 源0xbbc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,274)
        -- 源0xbd0，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,274)
        -- 源0xbe4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,274)
        -- 源0xbf4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,274)
        -- 源0xc08，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,274)
        -- 源0xc1c，42号。
        H.push(v,1)
        H.at(a,v,274)
        -- 源0xc30，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,274)
        -- 源0xc48，10号。
        return
    end
    P["MBossCard1"]=B.part1
end

-- stage07mboss.ecl：MBossCard1_at，0xc68；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc68，40号。
        H.at(a,v,0)
        -- 源0xc7c，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xc90，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0xca8，402号。
        H.gun_sprite(a,1,3,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xcc4，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0xce0，404号。
        H.gun_angle(a,1,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0xcfc，405号。
        H.gun_speed(a,1,0.10000000149011612,1.5)
        H.at(a,v,0)
        -- 源0xd18，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd48，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0xd5c，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd70，42号。
        H.push(v,219)
        H.at(a,v,0)
        -- 源0xd84，43号。
        v.l[32]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd98，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xdb0，81号。
        do local r=(v.l[24] or 0);local angle=(v.l[0] or 0);v.l[16]=H.f32(math.cos(angle)*r);v.l[20]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xdd0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xde4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xdf8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe08，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe1c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0xe30，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe44，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe58，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe68，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe7c，82号。
        v.l[8]=H.f32(H.angle((v.l[8] or 0)))
        H.at(a,v,0)
        -- 源0xe90，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0xea4，44号。
        H.push(v,0.75)
        H.at(a,v,0)
        -- 源0xeb8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xec8，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xedc，409号。
        H.gun_transform(a,1,1,0,4096,(v.l[32] or 0),-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf0c，409号。
        H.gun_transform(a,1,2,0,4,90,-999999,0.01600000075995922,-999.0)
        H.at(a,v,0)
        -- 源0xf3c，403号。
        H.gun_offset(a,1,(v.l[16] or 0),(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0xf58，404号。
        H.gun_angle(a,1,(v.l[8] or 0),0.028049934655427933)
        H.at(a,v,0)
        -- 源0xf74，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0xf88，42号。
        H.push(v,(v.l[32] or 0))
        H.at(a,v,0)
        -- 源0xf9c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xfb0，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xfc0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xfd4，61号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left~=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xfe4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xffc，83号。
        v.origin=v.origin+H.int(1)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1010，78号。
        H.push(v,(v.l[32] or 0))
        v.l[32]=H.int((v.l[32] or 0)-1)
        H.at(a,v,0)
        -- 源0x1024，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x103c，10号。
        return
    end
    P["MBossCard1_at"]=B.part1
end

-- stage07mboss.ecl：MBossCard1_at2，0x105c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x105c，40号。
        H.at(a,v,0)
        -- 源0x1070，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x1084，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x109c，402号。
        H.gun_sprite(a,1,12,3)
        H.at(a,v,0)
        -- 源0x10b8，406号。
        H.gun_count(a,1,16,1)
        H.at(a,v,0)
        -- 源0x10d4，404号。
        H.gun_angle(a,1,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x10f0，435号。
        H.gun_speed_diff(a,1,1.0,1.5,1.5,1.5,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x1124，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1154，368号。
        v.origin=v.origin+H.int(186)
        H.at(a,v,0)
        -- 源0x1174，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x118c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x11a0，368号。
        v.origin=v.origin+H.int(50)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x11c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x11d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x11ec，10号。
        return
    end
    P["MBossCard1_at2"]=B.part1
end

-- stage07mboss.ecl：MBossCard1_at3，0x120c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x120c，40号。
        H.at(a,v,0)
        -- 源0x1220，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1234，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,0.10000000149011612,-999999.0)
        H.at(a,v,0)
        -- 源0x1264，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x1278，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x128c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x12a0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12b4，42号。
        H.push(v,-208)
        H.at(a,v,0)
        -- 源0x12c8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x12dc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x12f4，439号。
        H.gun_absolute(a,0,-224.0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1310，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1324，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1338，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1348，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x135c，431号。
        H.laser(a,431,3,6,0.0,1.0,0,380.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x138c，83号。
        v.origin=v.origin+H.int(4)
        H.at(a,v,0)
        -- 源0x13a0，439号。
        H.gun_absolute(a,0,(v.l[4] or 0),-32.0)
        H.at(a,v,0)
        -- 源0x13bc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x13d0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x13e4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13f4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1408，431号。
        H.laser(a,431,3,6,1.5707963705062866,1.0,0,380.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x1438，83号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x144c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x1460，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1478，10号。
        return
    end
    P["MBossCard1_at3"]=B.part1
end

-- stage07mboss.ecl：MBossCard1_at3b，0x1498；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1498，40号。
        H.at(a,v,0)
        -- 源0x14ac，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x14c0，409号。
        H.gun_transform(a,0,0,0,4,60,-999999,0.10000000149011612,-999999.0)
        H.at(a,v,0)
        -- 源0x14f0，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x1504，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1518，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x152c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1540，42号。
        H.push(v,208)
        H.at(a,v,0)
        -- 源0x1554，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1568，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1580，439号。
        H.gun_absolute(a,0,224.0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x159c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x15b0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x15c4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x15d4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x15e8，431号。
        H.laser(a,431,3,6,3.1415927410125732,1.0,0,380.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x1618，83号。
        v.origin=v.origin+H.int(4)
        H.at(a,v,0)
        -- 源0x162c，439号。
        H.gun_absolute(a,0,(v.l[4] or 0),-32.0)
        H.at(a,v,0)
        -- 源0x1648，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x165c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x1670，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1680，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1694，431号。
        H.laser(a,431,3,6,1.5707963705062866,1.0,0,380.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x16c4，83号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x16d8，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x16ec，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1704，10号。
        return
    end
    P["MBossCard1_at3b"]=B.part1
end

-- stage07mboss.ecl：MBossCard2，0x1724；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1724，40号。
        H.at(a,v,0)
        -- 源0x1738，331号。
        H.life(a,2200)
        H.at(a,v,0)
        -- 源0x174c，347号。
        H.life_marker(a,0,2200.0,-24448)
        H.at(a,v,0)
        -- 源0x1768，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x177c，334号。
        H.interrupt(a,0,0,3600,"MBossCard3")
        H.at(a,v,0)
        -- 源0x17a8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x17b8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x17cc，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x17e0，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x17f0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1804，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1818，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1828，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1840，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1854，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x186c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1880，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1890，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x18a0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x18b4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x18c8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x18d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x18f0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1900，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1914，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1928，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1938，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1950，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1964，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x197c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1994，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x19a4，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x19b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x19cc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x19e0，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0x19f0，0号。
        H.at(a,v,60)
        -- 源0x1a00，342号。
        H.spell(a,163,3600,0,"奇跡「ミラクルフルーツ」",342)
        H.at(a,v,90)
        -- 源0x1a3c，263号。
        H.effect(a,0,131)
        H.at(a,v,150)
        -- 源0x1a54，0号。
        H.at(a,v,150)
        -- 源0x1a64，322号。
        H.flags(a,12,true)
        H.at(a,v,150)
        -- 源0x1a78，324号。
        H.limit(a,0.0,128.0,128.0,32.0)
        H.at(a,v,150)
        -- 源0x1a98，42号。
        H.push(v,50)
        H.at(a,v,150)
        -- 源0x1aac，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,150)
        -- 源0x1ac0，12号。
        v.origin=H.clock(a)-(150);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,150)
        -- 源0x1ad8，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x1aec，11号。
        H.call(a,v,P["MBossCard2_at"],"MBossCard2_at")
        H.at(a,v,150)
        -- 源0x1b10，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,150)
        -- 源0x1b24，292号。
        H.wander(a,0,40,4,1.5)
        H.at(a,v,150)
        -- 源0x1b40，83号。
        v.origin=v.origin+H.int(70)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,150)
        -- 源0x1b54，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x1b68，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,150)
        -- 源0x1b80，10号。
        return
    end
    P["MBossCard2"]=B.part1
end

-- stage07mboss.ecl：MBossCard2_at，0x1ba0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1ba0，40号。
        H.at(a,v,0)
        -- 源0x1bb4，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x1bc8，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x1be0，402号。
        H.gun_sprite(a,1,13,1)
        H.at(a,v,0)
        -- 源0x1bfc，406号。
        H.gun_count(a,1,8,1)
        H.at(a,v,0)
        -- 源0x1c18，404号。
        H.gun_angle(a,1,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x1c34，405号。
        H.gun_speed(a,1,4.0,1.5)
        H.at(a,v,0)
        -- 源0x1c50，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1c80，409号。
        H.gun_transform(a,1,1,0,16,59,1,0.0,1.0)
        H.at(a,v,0)
        -- 源0x1cb0，409号。
        H.gun_transform(a,1,2,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1ce0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x1cf4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x1d08，449号。
        H.callback(a,449,6)
        H.at(a,v,0)
        -- 源0x1d1c，10号。
        return
    end
    P["MBossCard2_at"]=B.part1
end

-- stage07mboss.ecl：MBossCard2_at2，0x1d3c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1d3c，40号。
        H.at(a,v,0)
        -- 源0x1d50，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x1d64，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1d78，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1d90，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x1dac，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x1dc8，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x1de4，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x1e00，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1e30，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0x1e60，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1e74，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e88，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1e9c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1eb0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ec8，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1ee0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x1ef4，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x1f08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1f18，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f2c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1f40，83号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1f54，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x1f68，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1f80，1号。
        H.erase(a);return
    end
    P["MBossCard2_at2"]=B.part1
end

-- stage07mboss.ecl：MBossCard3，0x1fa0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1fa0，40号。
        H.at(a,v,0)
        -- 源0x1fb4，331号。
        H.life(a,2200)
        H.at(a,v,0)
        -- 源0x1fc8，347号。
        H.life_marker(a,0,2200.0,-24448)
        H.at(a,v,0)
        -- 源0x1fe4，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x1ff8，334号。
        H.interrupt(a,0,0,3600,"MBossDead")
        H.at(a,v,0)
        -- 源0x2024，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2034，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2048，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x205c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x206c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2080，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2094，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x20a4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x20bc，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x20d0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x20e8，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x20fc，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x210c，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x211c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2130，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2144，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2154，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x216c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x217c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2190，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x21a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x21b4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x21cc，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x21e0，327号。
        H.drop_extra(a,2,30)
        H.at(a,v,0)
        -- 源0x21f8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2210，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2220，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2234，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2248，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x225c，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0x226c，0号。
        H.at(a,v,60)
        -- 源0x227c，342号。
        H.spell(a,164,3600,0,"神徳「五穀豊穣ライスシャワー」",342)
        H.at(a,v,60)
        -- 源0x22bc，281号。
        H.position_time(a,0,60,4,20.0,176.0)
        H.at(a,v,90)
        -- 源0x22dc，263号。
        H.effect(a,0,131)
        H.at(a,v,150)
        -- 源0x22f4，0号。
        H.at(a,v,150)
        -- 源0x2304，322号。
        H.flags(a,12,true)
        H.at(a,v,150)
        -- 源0x2318，324号。
        H.limit(a,0.0,128.0,128.0,128.0)
        H.at(a,v,150)
        -- 源0x2338，42号。
        H.push(v,50)
        H.at(a,v,150)
        -- 源0x234c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,150)
        -- 源0x2360，12号。
        v.origin=H.clock(a)-(150);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,150)
        -- 源0x2378，269号。
        H.anm_cast(a,0)
        H.at(a,v,150)
        -- 源0x238c，11号。
        H.call(a,v,P["MBossCard3_at"],"MBossCard3_at")
        H.at(a,v,150)
        -- 源0x23b0，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,150)
        -- 源0x23c4，292号。
        H.wander(a,0,40,4,1.5)
        H.at(a,v,150)
        -- 源0x23e0，83号。
        v.origin=v.origin+H.int(70)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,150)
        -- 源0x23f4，42号。
        H.push(v,1)
        H.at(a,v,150)
        -- 源0x2408，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(150);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,150)
        -- 源0x2420，10号。
        return
    end
    P["MBossCard3"]=B.part1
end

-- stage07mboss.ecl：MBossCard3_at，0x2440；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2440，40号。
        H.at(a,v,0)
        -- 源0x2454，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x246c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x2480，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0x2494，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x24a4，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x24b8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x24cc，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x24dc，280号。
        H.position(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x24f4，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2508，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x251c，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x2530，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0x2544，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2554，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x2568，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x257c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x258c，280号。
        H.position(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x25a4，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x25b8，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x25cc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x25e4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x25f8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2610，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x262c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2648，404号。
        H.gun_angle(a,0,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2664，405号。
        H.gun_speed(a,0,4.0,1.5)
        H.at(a,v,0)
        -- 源0x2680，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x26b0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x26c4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x26d8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x26e8，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x26fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x270c，409号。
        H.gun_transform(a,0,1,0,256,1,13,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x273c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2750，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x2764，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2774，409号。
        H.gun_transform(a,0,2,0,16,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x27a4，409号。
        H.gun_transform(a,0,3,0,2048,3,6,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x27d4，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.01666666753590107,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2804，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2820，403号。
        H.gun_offset(a,0,-20.0,-48.0)
        H.at(a,v,0)
        -- 源0x283c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2850，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2864，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x2878，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2888，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x289c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x28b0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x28c4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x28dc，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x28f8，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2914，404号。
        H.gun_angle(a,0,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2930，405号。
        H.gun_speed(a,0,4.0,1.5)
        H.at(a,v,0)
        -- 源0x294c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x297c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2990，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x29a4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x29b4，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x29c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x29d8，409号。
        H.gun_transform(a,0,1,0,256,1,13,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x2a08，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2a1c，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x2a30，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2a40，409号。
        H.gun_transform(a,0,2,0,16,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x2a70，409号。
        H.gun_transform(a,0,3,0,2048,3,8,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2aa0，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.01666666753590107,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2ad0，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2aec，403号。
        H.gun_offset(a,0,-20.0,-48.0)
        H.at(a,v,0)
        -- 源0x2b08，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2b1c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2b30，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x2b44，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2b54，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2b68，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x2b7c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2b90，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2ba8，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x2bc4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2be0，404号。
        H.gun_angle(a,0,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2bfc，405号。
        H.gun_speed(a,0,4.0,1.5)
        H.at(a,v,0)
        -- 源0x2c18，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2c48，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2c5c，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x2c70，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2c80，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2c94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2ca4，409号。
        H.gun_transform(a,0,1,0,256,1,13,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x2cd4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2ce8，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x2cfc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2d0c，409号。
        H.gun_transform(a,0,2,0,16,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x2d3c，409号。
        H.gun_transform(a,0,3,0,2048,3,10,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2d6c，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.01666666753590107,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x2d9c，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2db8，403号。
        H.gun_offset(a,0,-20.0,-48.0)
        H.at(a,v,0)
        -- 源0x2dd4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2de8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2dfc，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x2e10，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2e20，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e34，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x2e48，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2e5c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2e74，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x2e90，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x2eac，404号。
        H.gun_angle(a,0,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x2ec8，405号。
        H.gun_speed(a,0,4.0,1.5)
        H.at(a,v,0)
        -- 源0x2ee4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2f14，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x2f28，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x2f3c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2f4c，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2f60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2f70，409号。
        H.gun_transform(a,0,1,0,256,1,13,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x2fa0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2fb4，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x2fc8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2fd8，409号。
        H.gun_transform(a,0,2,0,16,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x3008，409号。
        H.gun_transform(a,0,3,0,2048,3,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3038，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.01666666753590107,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x3068，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3084，403号。
        H.gun_offset(a,0,-20.0,-48.0)
        H.at(a,v,0)
        -- 源0x30a0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x30b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x30c8，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x30dc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x30ec，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3100，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x3114，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3128，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x3140，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x315c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x3178，404号。
        H.gun_angle(a,0,0.0,0.39269909262657166)
        H.at(a,v,0)
        -- 源0x3194，405号。
        H.gun_speed(a,0,4.0,1.5)
        H.at(a,v,0)
        -- 源0x31b0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x31e0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x31f4，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x3208，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3218，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x322c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x323c，409号。
        H.gun_transform(a,0,1,0,256,1,13,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x326c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3280，44号。
        H.push(v,2.200000047683716)
        H.at(a,v,0)
        -- 源0x3294，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x32a4，409号。
        H.gun_transform(a,0,2,0,16,1,1,H.read(a,v,-1),-999999.0)
        H.at(a,v,0)
        -- 源0x32d4，409号。
        H.gun_transform(a,0,3,0,2048,3,14,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3304，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.01666666753590107,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x3334，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3350，403号。
        H.gun_offset(a,0,-20.0,-48.0)
        H.at(a,v,0)
        -- 源0x336c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3380，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3394，44号。
        H.push(v,1.2566369771957397)
        H.at(a,v,0)
        -- 源0x33a8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x33b8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x33cc，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x33e0，83号。
        v.origin=v.origin+H.int(3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x33f4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x3408，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3420，83号。
        v.origin=v.origin+H.int(7)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3434，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3448，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3460，10号。
        return
    end
    P["MBossCard3_at"]=B.part1
end

-- stage07mboss.ecl：MBossCard3_at2，0x3480；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3480，40号。
        H.at(a,v,0)
        -- 源0x3494，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x34a8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x34bc，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x34d4，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x34f0，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,0)
        -- 源0x350c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.39269909262657166)
        H.at(a,v,0)
        -- 源0x3528，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x3544，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3574，409号。
        H.gun_transform(a,0,1,0,4,60,-999999,0.03333333507180214,-999999.0)
        H.at(a,v,0)
        -- 源0x35a4，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x35b8，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x35cc，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x35e0，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x35f4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x360c，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3624，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3638，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x364c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x365c，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3670，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3684，83号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3698，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x36ac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x36c4，1号。
        H.erase(a);return
    end
    P["MBossCard3_at2"]=B.part1
end

-- stage07mboss.ecl：MBossDead，0x36e4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x36e4，40号。
        H.at(a,v,0)
        -- 源0x36f8，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0x370c，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0x3724，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0x3738，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0x3750，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0x3768，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x377c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3790，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x37a0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x37b8，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x37f0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3808，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x3840，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0x3850，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0x3860，345号。
        H.kill_all(a)
        H.at(a,v,60)
        -- 源0x3870，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0x3884，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,60)
        -- 源0x3898，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x38ac，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x38bc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0x38d4，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0x38e4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0x38f8，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x390c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x391c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0x3934，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x3948，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x395c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0x3970，327号。
        H.drop_extra(a,1,30)
        H.at(a,v,60)
        -- 源0x3988，327号。
        H.drop_extra(a,2,40)
        H.at(a,v,60)
        -- 源0x39a0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0x39b8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x39c8，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0x39e4，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0x39fc，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0x3a14，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0x3a28，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0x3a3c，1号。
        H.erase(a);return
    end
    P["MBossDead"]=B.part1
end

-- stage07boss.ecl：Boss，0x44c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x44c，40号。
        H.at(a,v,0)
        -- 源0x460，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x474，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x488，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0x4a0，322号。
        H.flags(a,76,true)
        H.at(a,v,0)
        -- 源0x4b4，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x4cc，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x4e4，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4f8，331号。
        H.life(a,13000)
        H.at(a,v,0)
        -- 源0x50c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x52c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x540，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x554，344号。
        a.chapter=24
        H.at(a,v,60)
        -- 源0x568，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x578，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x58c，440号。
        H.fog(a,160.0,16711680)
        H.at(a,v,60)
        -- 源0x5a4，344号。
        a.chapter=24
        H.at(a,v,60)
        -- 源0x5b8，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,60)
        -- 源0x5d8，331号。
        H.life(a,13000)
        H.at(a,v,60)
        -- 源0x5ec，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x600，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x618，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,60)
        -- 源0x630，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x644，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0x660，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage07boss.ecl：Boss1，0x680；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x680，40号。
        H.at(a,v,0)
        -- 源0x694，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x6a4，347号。
        H.life_marker(a,0,3000.0,-24448)
        H.at(a,v,0)
        -- 源0x6c0，334号。
        H.interrupt(a,0,3000,3600,"BossCard1")
        H.at(a,v,0)
        -- 源0x6ec，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0x700，360号。
        a.stars=9
        H.at(a,v,0)
        -- 源0x714，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0x734，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x748，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x760，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x774，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x788，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x79c，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil)
        H.at(a,v,0)
        -- 源0x7bc，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x7d0，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x7e4，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x7f8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x80c，15号。
        H.async(a,P["Boss1At1b"],"Boss1At1b",nil)
        H.at(a,v,0)
        -- 源0x82c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x840，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,0)
        -- 源0x85c，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x870，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x884，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x89c，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage07boss.ecl：Boss1At1，0x8bc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8bc，40号。
        H.at(a,v,0)
        -- 源0x8d0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x8e4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x8fc，402号。
        H.gun_sprite(a,0,3,10)
        H.at(a,v,0)
        -- 源0x918，406号。
        H.gun_count(a,0,28,1)
        H.at(a,v,0)
        -- 源0x934，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x950，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0x96c，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x99c，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9cc，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x9e0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9f4，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xa08，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa1c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xa30，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa44，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa5c，81号。
        do local r=(v.l[0] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xa7c，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xa98，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xab4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xac8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xadc，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0xaf0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb00，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb14，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xb28，44号。
        H.push(v,0.3831210136413574)
        H.at(a,v,0)
        -- 源0xb3c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xb4c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb60，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0xb74，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb88，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0xb9c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbb4，10号。
        return
    end
    P["Boss1At1"]=B.part1
end

-- stage07boss.ecl：Boss1At1b，0xbd4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbd4，40号。
        H.at(a,v,0)
        -- 源0xbe8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xbfc，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xc14，402号。
        H.gun_sprite(a,0,3,8)
        H.at(a,v,0)
        -- 源0xc30，406号。
        H.gun_count(a,0,28,1)
        H.at(a,v,0)
        -- 源0xc4c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xc68，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0xc84，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xcb4，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xce4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0xcf8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd0c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xd20，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xd34，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xd48，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd5c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd74，81号。
        do local r=(v.l[0] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xd94，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xdb0，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xdcc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xde0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xdf4，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0xe08，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe18，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe2c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe40，44号。
        H.push(v,0.3831210136413574)
        H.at(a,v,0)
        -- 源0xe54，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe64，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe78，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0xe8c，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xea0，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0xeb4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xecc，10号。
        return
    end
    P["Boss1At1b"]=B.part1
end

-- stage07boss.ecl：Boss2，0xeec；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xeec，40号。
        H.at(a,v,0)
        -- 源0xf00，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0xf10，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xf20，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xf34，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf48，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xf58，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf70，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0xf84，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf9c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xfb0，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xfc0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xfd0，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0xfe0，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0xff4，331号。
        H.life(a,14300)
        H.at(a,v,0)
        -- 源0x1008，334号。
        H.interrupt(a,0,3300,3600,"BossCard2")
        H.at(a,v,0)
        -- 源0x1034，347号。
        H.life_marker(a,0,3300.0,-24448)
        H.at(a,v,0)
        -- 源0x1050，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x1064，360号。
        a.stars=8
        H.at(a,v,0)
        -- 源0x1078，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x108c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x10a0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x10b4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x10c4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x10dc，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x10ec，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1100，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1114，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1124，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x113c，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1150，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x1168，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x1180，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1198，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x11a8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x11bc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x11d0，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x11e4，0号。
        H.at(a,v,60)
        -- 源0x11f4，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,60)
        -- 源0x1214，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0x1234，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x124c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,60)
        -- 源0x1268，83号。
        v.origin=v.origin+H.int(120)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x127c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1290，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x12a8，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage07boss.ecl：Boss2At1，0x12c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x12c8，40号。
        H.at(a,v,0)
        -- 源0x12dc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x12f0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1308，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x1324，406号。
        H.gun_count(a,0,14,1)
        H.at(a,v,0)
        -- 源0x1340，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x135c，405号。
        H.gun_speed(a,0,5.0,1.5)
        H.at(a,v,0)
        -- 源0x1378，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x13a8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x13bc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x13d0，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x13e8，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x13fc，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1410，44号。
        H.push(v,3.5)
        H.at(a,v,0)
        -- 源0x1424，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1438，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1450，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1464，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,0)
        -- 源0x1478，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1488，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x149c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x14b0，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x14cc，405号。
        H.gun_speed(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x14e8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x14fc，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,0)
        -- 源0x1510，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1520，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1534，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1548，83号。
        v.origin=v.origin+H.int(3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x155c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x1570，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1588，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x159c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x15b4，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage07boss.ecl：Boss3，0x15d4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x15d4，40号。
        H.at(a,v,0)
        -- 源0x15e8，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x15f8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1608，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x161c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1630，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1640，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1658，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x166c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1684，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1698，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x16a8，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x16b8，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x16cc，331号。
        H.life(a,13800)
        H.at(a,v,0)
        -- 源0x16e0，334号。
        H.interrupt(a,0,2800,3600,"BossCard3")
        H.at(a,v,0)
        -- 源0x170c，347号。
        H.life_marker(a,0,2800.0,-24448)
        H.at(a,v,0)
        -- 源0x1728，344号。
        a.chapter=26
        H.at(a,v,0)
        -- 源0x173c，360号。
        a.stars=7
        H.at(a,v,0)
        -- 源0x1750，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1764，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1778，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1788，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x17a0，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x17b4，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x17c4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x17d8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x17ec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x17fc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1814，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1828，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x1840，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x1858，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1870，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1880，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1894，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x18a8，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x18bc，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x18dc，0号。
        H.at(a,v,60)
        -- 源0x18ec，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x190c，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x1920，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x1934，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x1948，15号。
        H.async(a,P["Boss3At1"],"Boss3At1",nil)
        H.at(a,v,60)
        -- 源0x1968，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x1980，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0x1994，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,60)
        -- 源0x19b0，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x19c4，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x19d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x19f0，10号。
        return
    end
    P["Boss3"]=B.part1
end

-- stage07boss.ecl：Boss3At1，0x1a10；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1a10，40号。
        H.at(a,v,0)
        -- 源0x1a24，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1a38，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1a50，402号。
        H.gun_sprite(a,0,13,1)
        H.at(a,v,0)
        -- 源0x1a6c，406号。
        H.gun_count(a,0,14,1)
        H.at(a,v,0)
        -- 源0x1a88，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1aa4，405号。
        H.gun_speed(a,0,5.0,1.5)
        H.at(a,v,0)
        -- 源0x1ac0，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1af0，438号。
        H.gun_distance(a,0,16.0)
        H.at(a,v,0)
        -- 源0x1b08，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x1b1c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1b30，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1b48，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x1b5c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1b70，44号。
        H.push(v,2.5)
        H.at(a,v,0)
        -- 源0x1b84，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1b98，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1bb0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1bc4，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,0)
        -- 源0x1bd8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1be8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1bfc，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x1c10，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1c2c，405号。
        H.gun_speed(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x1c48，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1c5c，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,0)
        -- 源0x1c70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1c80，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1c94，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1ca8，83号。
        v.origin=v.origin+H.int(3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1cbc，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x1cd0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1ce8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1cfc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1d14，10号。
        return
    end
    P["Boss3At1"]=B.part1
end

-- stage07boss.ecl：Boss4，0x1d34；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1d34，40号。
        H.at(a,v,0)
        -- 源0x1d48，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x1d58，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x1d68，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1d7c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1d90，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1da0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1db8，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1dcc，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1de4，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1df8，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x1e08，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x1e18，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x1e2c，331号。
        H.life(a,14200)
        H.at(a,v,0)
        -- 源0x1e40，334号。
        H.interrupt(a,0,3200,3600,"BossCard4")
        H.at(a,v,0)
        -- 源0x1e6c，347号。
        H.life_marker(a,0,3200.0,-24448)
        H.at(a,v,0)
        -- 源0x1e88，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x1e9c，360号。
        a.stars=6
        H.at(a,v,0)
        -- 源0x1eb0，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x1ec4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1ed8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1eec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1efc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1f14，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1f24，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1f38，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1f4c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1f5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1f74，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1f88，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x1fa0，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x1fb8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1fd0，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1fe0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1ff4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2008，336号。
        H.sound(a,15)
        H.at(a,v,120)
        -- 源0x201c，0号。
        H.at(a,v,120)
        -- 源0x202c，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,120)
        -- 源0x204c，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,120)
        -- 源0x2060，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x2078，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x208c，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x20a0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x20b4，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x20d4，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x20e8，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x20fc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x2110，15号。
        H.async(a,P["Boss4At1b"],"Boss4At1b",nil)
        H.at(a,v,120)
        -- 源0x2130，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x2144，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,120)
        -- 源0x2160，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x2174，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x2188，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x21a0，10号。
        return
    end
    P["Boss4"]=B.part1
end

-- stage07boss.ecl：Boss4At1，0x21c0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x21c0，40号。
        H.at(a,v,0)
        -- 源0x21d4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x21e8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2200，402号。
        H.gun_sprite(a,0,3,2)
        H.at(a,v,0)
        -- 源0x221c，406号。
        H.gun_count(a,0,20,1)
        H.at(a,v,0)
        -- 源0x2238，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2254，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0x2270，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x22a0，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x22d0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x22e4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x22f8，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x230c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2320，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2334，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2348，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2360，81号。
        do local r=(v.l[0] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2380，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x239c，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x23b8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x23cc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x23e0，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x23f4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2404，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2418，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x242c，44号。
        H.push(v,0.3831210136413574)
        H.at(a,v,0)
        -- 源0x2440，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2450，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2464，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2478，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x248c，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x24a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x24b8，10号。
        return
    end
    P["Boss4At1"]=B.part1
end

-- stage07boss.ecl：Boss4At1b，0x24d8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x24d8，40号。
        H.at(a,v,0)
        -- 源0x24ec，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2500，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2518，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x2534，406号。
        H.gun_count(a,0,20,1)
        H.at(a,v,0)
        -- 源0x2550，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x256c，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0x2588，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x25b8，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x25e8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x25fc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2610，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2624，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2638，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x264c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2660，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2678，81号。
        do local r=(v.l[0] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x2698，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x26b4，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x26d0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x26e4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x26f8，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x270c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x271c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2730，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2744，44号。
        H.push(v,0.3831210136413574)
        H.at(a,v,0)
        -- 源0x2758，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2768，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x277c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2790，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x27a4，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x27b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x27d0，10号。
        return
    end
    P["Boss4At1b"]=B.part1
end

-- stage07boss.ecl：Boss5，0x27f0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x27f0，40号。
        H.at(a,v,0)
        -- 源0x2804，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x2814，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x2824，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2838，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x284c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x285c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2874，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2888，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x28a0，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x28b4，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x28c4，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x28d4，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x28e8，331号。
        H.life(a,11001)
        H.at(a,v,0)
        -- 源0x28fc，334号。
        H.interrupt(a,0,1,3600,"BossCard5")
        H.at(a,v,0)
        -- 源0x2928，347号。
        H.life_marker(a,0,1.0,-24448)
        H.at(a,v,0)
        -- 源0x2944，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x2958，360号。
        a.stars=5
        H.at(a,v,0)
        -- 源0x296c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x2980，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x2994，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x29a8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x29b8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x29d0，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x29e0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x29f4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2a08，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2a18，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2a30，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2a44，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x2a5c，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x2a74，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x2a8c，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2a9c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2ab0，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2ac4，336号。
        H.sound(a,15)
        H.at(a,v,120)
        -- 源0x2ad8，0号。
        H.at(a,v,120)
        -- 源0x2ae8，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,120)
        -- 源0x2b08，15号。
        H.async(a,P["Boss5At1"],"Boss5At1",nil)
        H.at(a,v,120)
        -- 源0x2b28，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x2b40，292号。
        H.wander(a,0,60,4,1.0)
        H.at(a,v,120)
        -- 源0x2b5c，83号。
        v.origin=v.origin+H.int(120)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x2b70，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x2b84，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x2b9c，10号。
        return
    end
    P["Boss5"]=B.part1
end

-- stage07boss.ecl：Boss5At1，0x2bbc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2bbc，40号。
        H.at(a,v,0)
        -- 源0x2bd0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2be4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2bfc，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x2c18，406号。
        H.gun_count(a,0,16,1)
        H.at(a,v,0)
        -- 源0x2c34，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2c50，405号。
        H.gun_speed(a,0,5.0,1.5)
        H.at(a,v,0)
        -- 源0x2c6c，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2c9c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x2cb0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2cc4，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2cdc，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0x2cf0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2d04，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x2d18，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2d2c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2d44，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x2d58，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,0)
        -- 源0x2d6c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2d7c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2d90，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x2da4，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2dc0，405号。
        H.gun_speed(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x2ddc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2df0，44号。
        H.push(v,0.15000000596046448)
        H.at(a,v,0)
        -- 源0x2e04，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2e14，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e28，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2e3c，83号。
        v.origin=v.origin+H.int(3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2e50，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x2e64，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2e7c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2e90，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2ea8，10号。
        return
    end
    P["Boss5At1"]=B.part1
end

-- stage07boss.ecl：Boss5At1b，0x2ec8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2ec8，40号。
        H.at(a,v,0)
        -- 源0x2edc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2ef0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2f08，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x2f24，406号。
        H.gun_count(a,0,24,1)
        H.at(a,v,0)
        -- 源0x2f40，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2f5c，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0x2f78，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2fa8，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2fd8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2fec，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3000，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x3014，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3028，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x303c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3050，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3068，81号。
        do local r=(v.l[0] or 0);local angle=(v.l[4] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x3088，403号。
        H.gun_offset(a,0,(v.l[8] or 0),(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x30a4，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x30c0，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x30d4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x30e8，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x30fc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x310c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3120，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3134，44号。
        H.push(v,0.3831210136413574)
        H.at(a,v,0)
        -- 源0x3148，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3158，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x316c，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x3180，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3194，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,0)
        -- 源0x31a8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x31c0，10号。
        return
    end
    P["Boss5At1b"]=B.part1
end

-- stage07boss.ecl：Boss6，0x31e0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x31e0，40号。
        H.at(a,v,0)
        -- 源0x31f4，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x3204，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x3214，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3228，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x323c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x324c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3264，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x3278，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3290，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x32a4，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x32b4，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x32c4，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x32d8，331号。
        H.life(a,13200)
        H.at(a,v,0)
        -- 源0x32ec，334号。
        H.interrupt(a,0,3200,3600,"BossCard6")
        H.at(a,v,0)
        -- 源0x3318，347号。
        H.life_marker(a,0,3200.0,-24448)
        H.at(a,v,0)
        -- 源0x3334，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x3348，360号。
        a.stars=4
        H.at(a,v,0)
        -- 源0x335c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3370，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x3380，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x3394，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x33a8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x33b8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x33d0，330号。
        H.drop_main(a,5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x33e4，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x33fc，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x3414，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x342c，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x343c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3450，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3464，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x3478，259号。
        H.anm_slot(a,2,-1)
        H.at(a,v,0)
        -- 源0x3490，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,120)
        -- 源0x34b0，0号。
        H.at(a,v,120)
        -- 源0x34c0，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,120)
        -- 源0x34e0，15号。
        H.async(a,P["Boss6At1"],"Boss6At1",nil)
        H.at(a,v,120)
        -- 源0x3500，12号。
        v.origin=H.clock(a)-(120);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x3518，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,120)
        -- 源0x352c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,120)
        -- 源0x3548，83号。
        v.origin=v.origin+H.int(60)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x355c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x3570，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x3588，10号。
        return
    end
    P["Boss6"]=B.part1
end

-- stage07boss.ecl：Boss6At1，0x35a8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x35a8，40号。
        H.at(a,v,0)
        -- 源0x35bc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x35d0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x35e8，402号。
        H.gun_sprite(a,0,13,2)
        H.at(a,v,0)
        -- 源0x3604，406号。
        H.gun_count(a,0,14,1)
        H.at(a,v,0)
        -- 源0x3620，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x363c，405号。
        H.gun_speed(a,0,5.0,1.5)
        H.at(a,v,0)
        -- 源0x3658，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3688，438号。
        H.gun_distance(a,0,16.0)
        H.at(a,v,0)
        -- 源0x36a0，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x36b4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x36c8，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x36e0，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x36f4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3708，44号。
        H.push(v,2.5)
        H.at(a,v,0)
        -- 源0x371c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3730，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3748，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x375c，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,0)
        -- 源0x3770，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3780，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3794，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x37a8，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x37c4，405号。
        H.gun_speed(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x37e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x37f4，44号。
        H.push(v,0.07999999821186066)
        H.at(a,v,0)
        -- 源0x3808，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3818，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x382c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3840，83号。
        v.origin=v.origin+H.int(3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3854，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x3868，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3880，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3894，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x38ac，10号。
        return
    end
    P["Boss6At1"]=B.part1
end

-- stage07boss.ecl：Boss7，0x38cc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x38cc，40号。
        H.at(a,v,0)
        -- 源0x38e0，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x38f0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x3900，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3914，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3928，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3938，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3950，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x3964，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x397c，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3990，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x39a0，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x39b0，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x39c4，331号。
        H.life(a,13600)
        H.at(a,v,0)
        -- 源0x39d8，334号。
        H.interrupt(a,0,3600,3600,"BossCard7")
        H.at(a,v,0)
        -- 源0x3a04，347号。
        H.life_marker(a,0,3600.0,-24448)
        H.at(a,v,0)
        -- 源0x3a20，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x3a34，360号。
        a.stars=3
        H.at(a,v,0)
        -- 源0x3a48，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3a5c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x3a70，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3a84，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3a94，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3aac，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x3abc，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x3ad0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3ae4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3af4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3b0c，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x3b20，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x3b38，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x3b50，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3b68，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x3b78，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3b8c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3ba0，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x3bb4，259号。
        H.anm_slot(a,2,-1)
        H.at(a,v,0)
        -- 源0x3bcc，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,120)
        -- 源0x3bec，0号。
        H.at(a,v,120)
        -- 源0x3bfc，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,120)
        -- 源0x3c1c，15号。
        H.async(a,P["Boss7At1"],"Boss7At1",nil)
        H.at(a,v,120)
        -- 源0x3c3c，15号。
        H.async(a,P["Boss7At2"],"Boss7At2",nil)
        H.at(a,v,120)
        -- 源0x3c5c，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x3c74，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,120)
        -- 源0x3c88，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,120)
        -- 源0x3ca4，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x3cb8，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x3ccc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x3ce4，10号。
        return
    end
    P["Boss7"]=B.part1
end

-- stage07boss.ecl：Boss7At1，0x3d04；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3d04，40号。
        H.at(a,v,0)
        -- 源0x3d18，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x3d2c，407号。
        H.gun_aim(a,2,2)
        H.at(a,v,0)
        -- 源0x3d44，402号。
        H.gun_sprite(a,2,12,4)
        H.at(a,v,0)
        -- 源0x3d60，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x3d7c，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3d98，405号。
        H.gun_speed(a,2,2.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x3db4，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3de4，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x3df8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3e0c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3e20，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3e38，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x3e4c，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3e60，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3e74，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3e8c，10号。
        return
    end
    P["Boss7At1"]=B.part1
end

-- stage07boss.ecl：Boss7At2，0x3eac；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3eac，40号。
        H.at(a,v,0)
        -- 源0x3ec0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3ed4，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x3eec，402号。
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x3f08，406号。
        H.gun_count(a,0,1,10)
        H.at(a,v,0)
        -- 源0x3f24，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x3f40，405号。
        H.gun_speed(a,0,8.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x3f5c，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3f8c，409号。
        H.gun_transform(a,0,1,0,16,60,1,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x3fbc，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x3fd0，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x3fe8，402号。
        H.gun_sprite(a,1,3,4)
        H.at(a,v,0)
        -- 源0x4004，406号。
        H.gun_count(a,1,1,10)
        H.at(a,v,0)
        -- 源0x4020，404号。
        H.gun_angle(a,1,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x403c，405号。
        H.gun_speed(a,1,8.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x4058，409号。
        H.gun_transform(a,1,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4088，409号。
        H.gun_transform(a,1,1,0,16,60,1,-1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x40b8，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x40cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x40e0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x40f8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x410c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x4120，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4134，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4148，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4160，10号。
        return
    end
    P["Boss7At2"]=B.part1
end

-- stage07boss.ecl：Boss8，0x4180；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4180，40号。
        H.at(a,v,0)
        -- 源0x4194，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x41a4，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x41b4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x41c8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x41dc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x41ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4204，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x4218，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4230，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4244，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x4254，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4264，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x4278，331号。
        H.life(a,12000)
        H.at(a,v,0)
        -- 源0x428c，334号。
        H.interrupt(a,0,2000,3600,"BossCard8")
        H.at(a,v,0)
        -- 源0x42b8，347号。
        H.life_marker(a,0,2000.0,-24448)
        H.at(a,v,0)
        -- 源0x42d4，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x42e8，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x42fc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4310，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4324，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4338，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4348，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4360，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x4370，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4384，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4398，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x43a8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x43c0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x43d4，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0x43ec，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x4404，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x441c，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x442c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4440，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4454，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x4468，259号。
        H.anm_slot(a,2,-1)
        H.at(a,v,0)
        -- 源0x4480，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,120)
        -- 源0x44a0，0号。
        H.at(a,v,120)
        -- 源0x44b0，324号。
        H.limit(a,0.0,128.0,280.0,48.0)
        H.at(a,v,120)
        -- 源0x44d0，15号。
        H.async(a,P["Boss8At1"],"Boss8At1",nil)
        H.at(a,v,120)
        -- 源0x44f0，15号。
        H.async(a,P["Boss8At2"],"Boss8At2",nil)
        H.at(a,v,120)
        -- 源0x4510，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x4528，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,120)
        -- 源0x453c，292号。
        H.wander(a,0,60,4,2.0)
        H.at(a,v,120)
        -- 源0x4558，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x456c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x4580，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x4598，10号。
        return
    end
    P["Boss8"]=B.part1
end

-- stage07boss.ecl：Boss8At1，0x45b8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x45b8，40号。
        H.at(a,v,0)
        -- 源0x45cc，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x45e0，407号。
        H.gun_aim(a,2,2)
        H.at(a,v,0)
        -- 源0x45f8，402号。
        H.gun_sprite(a,2,12,4)
        H.at(a,v,0)
        -- 源0x4614，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x4630，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x464c，405号。
        H.gun_speed(a,2,2.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x4668，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4698，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x46ac，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x46c0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x46d4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x46ec，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x4700，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4714，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4728，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4740，10号。
        return
    end
    P["Boss8At1"]=B.part1
end

-- stage07boss.ecl：Boss8At2，0x4760；只编译Extra掩码。
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
        H.gun_sprite(a,0,3,4)
        H.at(a,v,0)
        -- 源0x47bc，406号。
        H.gun_count(a,0,1,10)
        H.at(a,v,0)
        -- 源0x47d8，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x47f4，405号。
        H.gun_speed(a,0,8.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x4810，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4840，409号。
        H.gun_transform(a,0,1,0,16,60,1,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x4870，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x4884，407号。
        H.gun_aim(a,1,2)
        H.at(a,v,0)
        -- 源0x489c，402号。
        H.gun_sprite(a,1,3,4)
        H.at(a,v,0)
        -- 源0x48b8，406号。
        H.gun_count(a,1,1,10)
        H.at(a,v,0)
        -- 源0x48d4，404号。
        H.gun_angle(a,1,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x48f0，405号。
        H.gun_speed(a,1,8.0,0.20000000298023224)
        H.at(a,v,0)
        -- 源0x490c，409号。
        H.gun_transform(a,1,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x493c，409号。
        H.gun_transform(a,1,1,0,16,60,1,-1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x496c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x4980，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4994，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x49ac，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x49c0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x49d4，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x49e8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x49fc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4a14，10号。
        return
    end
    P["Boss8At2"]=B.part1
end

-- stage07boss.ecl：BossCard1，0x4a34；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a34，40号。
        H.at(a,v,0)
        -- 源0x4a48，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x4a5c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4a6c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x4a7c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4a8c，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x4aa0，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x4ab0，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x4ac4，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4af8，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4b0c，334号。
        H.interrupt(a,0,0,5400,"Boss2")
        H.at(a,v,0)
        -- 源0x4b34，342号。
        H.spell(a,165,5400,500000,"表象「夢枕にご先祖総立ち」",342)
        H.at(a,v,0)
        -- 源0x4b70，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x4b84，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4b94，281号。
        H.position_time(a,0,60,4,0.0,160.0)
        H.at(a,v,0)
        -- 源0x4bb4，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,0)
        -- 源0x4bd4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4be8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4bfc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4c0c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4c24，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4c38，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4c4c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4c5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4c74，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x4c84，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x4c98，329号。
        H.drop(a)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4ca8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4cbc，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,120)
        -- 源0x4cd0，0号。
        H.at(a,v,120)
        -- 源0x4ce0，12号。
        v.origin=H.clock(a)-(120);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,120)
        -- 源0x4cf8，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,120)
        -- 源0x4d0c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x4d20，44号。
        H.push(v,0.005235999822616577)
        H.at(a,v,120)
        -- 源0x4d34，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x4d48，15号。
        H.async(a,P["BossCard1At"],"BossCard1At",nil)
        H.at(a,v,120)
        -- 源0x4d68，15号。
        H.async(a,P["BossCard1At2"],"BossCard1At2",nil)
        H.at(a,v,120)
        -- 源0x4d8c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,120)
        -- 源0x4da0，15号。
        H.async(a,P["BossCard1At3"],"BossCard1At3",nil)
        H.at(a,v,120)
        -- 源0x4dc4，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,120)
        -- 源0x4dd8，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x4df0，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x4e04，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x4e18，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,120)
        -- 源0x4e2c，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,120)
        -- 源0x4e40，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x4e54，44号。
        H.push(v,0.03926999866962433)
        H.at(a,v,120)
        -- 源0x4e68，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x4e7c，15号。
        H.async(a,P["BossCard1At"],"BossCard1At",nil)
        H.at(a,v,120)
        -- 源0x4e9c，15号。
        H.async(a,P["BossCard1At2"],"BossCard1At2",nil)
        H.at(a,v,120)
        -- 源0x4ec0，83号。
        v.origin=v.origin+H.int(120)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,120)
        -- 源0x4ed4，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x4ee8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x4f00，12号。
        v.origin=H.clock(a)-(120);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x4f18，83号。
        v.origin=v.origin+H.int(1000)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x4f2c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x4f40，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x4f58，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage07boss.ecl：BossCard10，0x4f78；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4f78，40号。
        H.at(a,v,0)
        -- 源0x4f8c，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0x4fa0，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4fb0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4fc4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4fd8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4fe8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5000，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x5034，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x504c，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5084，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x5094，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x50a4，449号。
        H.callback(a,449,11)
        H.at(a,v,0)
        -- 源0x50b8，344号。
        a.chapter=52
        H.at(a,v,0)
        -- 源0x50cc，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0x50dc，323号。
        H.flags(a,35,false)
        H.at(a,v,0)
        -- 源0x50f0，331号。
        H.life(a,11200)
        H.at(a,v,0)
        -- 源0x5104，334号。
        H.interrupt(a,0,0,11400,"BossDead")
        H.at(a,v,0)
        -- 源0x5130，347号。
        H.life_marker(a,0,11200.0,-24448)
        H.at(a,v,0)
        -- 源0x514c，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x5160，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x5170，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x5184，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5198，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x51a8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x51c0，330号。
        H.drop_main(a,5)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x51d4，327号。
        H.drop_extra(a,4,2)
        H.at(a,v,0)
        -- 源0x51ec，327号。
        H.drop_extra(a,2,40)
        H.at(a,v,0)
        -- 源0x5204，329号。
        H.drop(a)
        H.at(a,v,0)
        -- 源0x5214，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5228，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x523c，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x5250，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0x5268，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,0)
        -- 源0x527c，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x528c，342号。
        H.spell(a,174,11400,500000,"「サブタレイニアンローズ」",342)
        H.at(a,v,0)
        -- 源0x52c8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x52e8，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0x52f8，0号。
        H.at(a,v,60)
        -- 源0x5308，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x5320，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x5334，15号。
        H.async(a,P["BossCard10EtAt"],"BossCard10EtAt",nil)
        H.at(a,v,60)
        -- 源0x5358，15号。
        H.async(a,P["BossCard10EtAt2"],"BossCard10EtAt2",nil)
        H.at(a,v,60)
        -- 源0x537c，443号。
        H.callback(a,443,12)
        H.at(a,v,60)
        -- 源0x5390，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x53a4，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x53b8，12号。
        v.origin=H.clock(a)-(60);return B.part19(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0x53d0，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x53e4，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0x53f8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x5408，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part11(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x5420，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,60)
        -- 源0x5434，42号。
        H.push(v,8400)
        H.at(a,v,60)
        -- 源0x5448，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x5458，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part10(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x5470，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x5484，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,60)
        -- 源0x5498，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0x54a8，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x54bc，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x54d0，15号。
        H.async(a,P["BossCard10EtAtB"],"BossCard10EtAtB",nil)
        H.at(a,v,60)
        -- 源0x54f4，15号。
        H.async(a,P["BossCard10EtAtB2"],"BossCard10EtAtB2",nil)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x551c，12号。
        v.origin=H.clock(a)-(60);return B.part18(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x5534，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x5548，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x555c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x556c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part15(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x5584，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,60)
        -- 源0x5598，42号。
        H.push(v,5600)
        H.at(a,v,60)
        -- 源0x55ac，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x55bc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part14(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x55d4，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x55e8，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,60)
        -- 源0x55fc，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0x560c，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x5620，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x5634，15号。
        H.async(a,P["BossCard10EtAtC"],"BossCard10EtAtC",nil)
        H.at(a,v,60)
        -- 源0x5658，15号。
        H.async(a,P["BossCard10EtAtC2"],"BossCard10EtAtC2",nil)
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x5680，12号。
        v.origin=H.clock(a)-(60);return B.part18(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0x5698，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,60)
        -- 源0x56ac，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0x56c0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x56d0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part18(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0x56e8，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,60)
        -- 源0x56fc，42号。
        H.push(v,2800)
        H.at(a,v,60)
        -- 源0x5710，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0x5720，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part18(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,60)
        -- 源0x5738，336号。
        H.sound(a,15)
        H.at(a,v,60)
        -- 源0x574c，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,60)
        -- 源0x5760，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0x5770，42号。
        H.push(v,3)
        H.at(a,v,60)
        -- 源0x5784，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x5798，15号。
        H.async(a,P["BossCard10EtAtD"],"BossCard10EtAtD",nil)
        H.at(a,v,60)
        -- 源0x57bc，15号。
        H.async(a,P["BossCard10EtAtD2"],"BossCard10EtAtD2",nil)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,60)
        -- 源0x57e4，83号。
        v.origin=v.origin+H.int(1)
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,60)
        -- 源0x57f8，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x580c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part7(a,v) end
        return B.part20(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,60)
        -- 源0x5824，12号。
        v.origin=H.clock(a)-(60);return B.part22(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,60)
        -- 源0x583c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,60)
        -- 源0x5850，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x5864，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part21(a,v) end
        return B.part23(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,60)
        -- 源0x587c，10号。
        return
    end
    P["BossCard10"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAt，0x589c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x589c，40号。
        H.at(a,v,0)
        -- 源0x58b0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x58c4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x58dc，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x58f8，406号。
        H.gun_count(a,0,64,1)
        H.at(a,v,0)
        -- 源0x5914，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5930，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0x594c，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x597c，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x59ac，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x59c0，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x59d8，402号。
        H.gun_sprite(a,1,1,2)
        H.at(a,v,0)
        -- 源0x59f4，406号。
        H.gun_count(a,1,64,1)
        H.at(a,v,0)
        -- 源0x5a10，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5a2c，405号。
        H.gun_speed(a,1,1.0,1.5)
        H.at(a,v,0)
        -- 源0x5a48，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5a78，409号。
        H.gun_transform(a,1,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5aa8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5ac0，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x5adc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5af0，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x5b04，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x5b20，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5b34，83号。
        v.origin=v.origin+H.int(100)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5b48，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5b5c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5b74，10号。
        return
    end
    P["BossCard10EtAt"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAt2，0x5b94；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5b94，40号。
        H.at(a,v,0)
        -- 源0x5ba8，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x5bbc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5bd0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x5be4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5bf8，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x5c0c，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5c20，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5c38，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x5c4c，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x5c60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5c70，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5c84，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,0)
        -- 源0x5c98，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x5cac，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x5cc0，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5cd0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x5ce4，82号。
        H.write(a,-9980,H.f32(H.angle(H.read(a,v,-9980))))
        H.at(a,v,0)
        -- 源0x5cf8，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5d0c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5d20，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5d38，10号。
        return
    end
    P["BossCard10EtAt2"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtB，0x5d58；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5d58，40号。
        H.at(a,v,0)
        -- 源0x5d6c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x5d80，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x5d98，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x5db4，406号。
        H.gun_count(a,0,48,1)
        H.at(a,v,0)
        -- 源0x5dd0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5dec，405号。
        H.gun_speed(a,0,1.5,1.5)
        H.at(a,v,0)
        -- 源0x5e08，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5e38，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5e68，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x5e7c，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x5e94，402号。
        H.gun_sprite(a,1,1,2)
        H.at(a,v,0)
        -- 源0x5eb0，406号。
        H.gun_count(a,1,48,1)
        H.at(a,v,0)
        -- 源0x5ecc，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5ee8，405号。
        H.gun_speed(a,1,1.5,1.5)
        H.at(a,v,0)
        -- 源0x5f04，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5f34，409号。
        H.gun_transform(a,1,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5f64，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5f7c，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x5f98，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x5fac，83号。
        v.origin=v.origin+H.int(55)
        H.at(a,v,0)
        -- 源0x5fc0，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x5fdc，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x5ff0，83号。
        v.origin=v.origin+H.int(55)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6004，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6018，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6030，10号。
        return
    end
    P["BossCard10EtAtB"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtB2，0x6050；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6050，40号。
        H.at(a,v,0)
        -- 源0x6064，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x6078，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x608c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x60a0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x60b4，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x60c8，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x60dc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x60f4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6108，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x611c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x612c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6140，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,0)
        -- 源0x6154，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x6168，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x617c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x618c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x61a0，82号。
        H.write(a,-9980,H.f32(H.angle(H.read(a,v,-9980))))
        H.at(a,v,0)
        -- 源0x61b4，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x61c8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x61dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x61f4，10号。
        return
    end
    P["BossCard10EtAtB2"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtC，0x6214；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6214，40号。
        H.at(a,v,0)
        -- 源0x6228，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x623c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x6254，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x6270，406号。
        H.gun_count(a,0,64,1)
        H.at(a,v,0)
        -- 源0x628c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x62a8，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0x62c4，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x62f4，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6324，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x6338，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x6350，402号。
        H.gun_sprite(a,1,1,2)
        H.at(a,v,0)
        -- 源0x636c，406号。
        H.gun_count(a,1,64,1)
        H.at(a,v,0)
        -- 源0x6388，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x63a4，405号。
        H.gun_speed(a,1,1.0,1.5)
        H.at(a,v,0)
        -- 源0x63c0，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x63f0，409号。
        H.gun_transform(a,1,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6420，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6438，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x6454，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x6468，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,0)
        -- 源0x647c，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x6498，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x64ac，83号。
        v.origin=v.origin+H.int(100)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x64c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x64d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x64ec，10号。
        return
    end
    P["BossCard10EtAtC"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtC2，0x650c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x650c，40号。
        H.at(a,v,0)
        -- 源0x6520，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x6534，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6548，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x655c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6570，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x6584，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6598，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x65b0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x65c4，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x65d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x65e8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x65fc，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,0)
        -- 源0x6610，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x6624，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,0)
        -- 源0x6638，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x6648，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x665c，82号。
        H.write(a,-9980,H.f32(H.angle(H.read(a,v,-9980))))
        H.at(a,v,0)
        -- 源0x6670，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6684，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6698，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x66b0，10号。
        return
    end
    P["BossCard10EtAtC2"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtD，0x66d0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x66d0，40号。
        H.at(a,v,0)
        -- 源0x66e4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x66f8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x6710，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x672c，406号。
        H.gun_count(a,0,64,1)
        H.at(a,v,0)
        -- 源0x6748，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x6764，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0x6780，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x67b0，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x67e0，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x67f4，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x680c，402号。
        H.gun_sprite(a,1,1,2)
        H.at(a,v,0)
        -- 源0x6828，406号。
        H.gun_count(a,1,64,1)
        H.at(a,v,0)
        -- 源0x6844，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x6860，405号。
        H.gun_speed(a,1,1.0,1.5)
        H.at(a,v,0)
        -- 源0x687c，409号。
        H.gun_transform(a,1,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x68ac，409号。
        H.gun_transform(a,1,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x68dc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x68f4，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x6910，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x6924，83号。
        v.origin=v.origin+H.int(40)
        H.at(a,v,0)
        -- 源0x6938，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x6954，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x6968，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x697c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6990，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x69a8，10号。
        return
    end
    P["BossCard10EtAtD"]=B.part1
end

-- stage07boss.ecl：BossCard10EtAtD2，0x69c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x69c8，40号。
        H.at(a,v,0)
        -- 源0x69dc，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x69f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6a04，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x6a18，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6a2c，44号。
        H.push(v,0.19634999334812164)
        H.at(a,v,0)
        -- 源0x6a40，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6a54，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6a6c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6a80，44号。
        H.push(v,0.020268000662326813)
        H.at(a,v,0)
        -- 源0x6a94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6aa4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6ab8，82号。
        H.write(a,-9981,H.f32(H.angle(H.read(a,v,-9981))))
        H.at(a,v,0)
        -- 源0x6acc，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x6ae0，44号。
        H.push(v,0.020268000662326813)
        H.at(a,v,0)
        -- 源0x6af4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x6b04，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6b18，82号。
        H.write(a,-9980,H.f32(H.angle(H.read(a,v,-9980))))
        H.at(a,v,0)
        -- 源0x6b2c，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6b40，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6b54，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6b6c，10号。
        return
    end
    P["BossCard10EtAtD2"]=B.part1
end

-- stage07boss.ecl：BossCard1At，0x6b8c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6b8c，40号。
        H.at(a,v,0)
        -- 源0x6ba0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6bb4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6bc8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6bdc，409号。
        H.gun_transform(a,0,0,1,4,40,-999999,0.20000000298023224,-999999.0)
        H.at(a,v,0)
        -- 源0x6c0c，409号。
        H.gun_transform(a,0,1,1,256,2,13,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6c3c，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x6c50，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6c64，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x6c78，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6c8c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6ca0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6cb4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6ccc，439号。
        H.gun_absolute(a,0,(v.l[4] or 0),464.0)
        H.at(a,v,0)
        -- 源0x6ce8，431号。
        H.laser(a,431,3,6,(v.l[0] or 0),1.0,0,320.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x6d18，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6d2c，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6d40，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6d50，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d64，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6d78，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x6d8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6d9c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6db0，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6dc4，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x6dd8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6df0，10号。
        return
    end
    P["BossCard1At"]=B.part1
end

-- stage07boss.ecl：BossCard1At2，0x6e10；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6e10，40号。
        H.at(a,v,0)
        -- 源0x6e24，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6e38，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6e4c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x6e60，409号。
        H.gun_transform(a,0,0,1,4,40,-999999,0.15000000596046448,-999999.0)
        H.at(a,v,0)
        -- 源0x6e90，409号。
        H.gun_transform(a,0,1,1,256,1,1,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6ec0，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x6ed4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6ee8，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x6efc，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6f10，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6f24，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6f38，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6f50，439号。
        H.gun_absolute(a,0,(v.l[4] or 0),464.0)
        H.at(a,v,0)
        -- 源0x6f6c，431号。
        H.laser(a,431,3,6,(v.l[0] or 0),1.0,0,320.0,0.0,32.0)
        H.at(a,v,0)
        -- 源0x6f9c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6fb0，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x6fc4，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x6fd4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6fe8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6ffc，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x7010，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x7020，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7034，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7048，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x705c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7074，10号。
        return
    end
    P["BossCard1At2"]=B.part1
end

-- stage07boss.ecl：BossCard1At3，0x7094；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7094，40号。
        H.at(a,v,0)
        -- 源0x70a8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x70bc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x70d0，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x70e4，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x70fc，402号。
        H.gun_sprite(a,2,12,1)
        H.at(a,v,0)
        -- 源0x7118，406号。
        H.gun_count(a,2,1,1)
        H.at(a,v,0)
        -- 源0x7134，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7150，405号。
        H.gun_speed(a,2,4.0,1.5)
        H.at(a,v,0)
        -- 源0x716c，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x719c，409号。
        H.gun_transform(a,2,1,1,32,40,1,0.0,-999999.0)
        H.at(a,v,0)
        -- 源0x71cc，400号。
        H.gun_new(a,3)
        H.at(a,v,0)
        -- 源0x71e0，407号。
        H.gun_aim(a,3,2)
        H.at(a,v,0)
        -- 源0x71f8，402号。
        H.gun_sprite(a,3,1,2)
        H.at(a,v,0)
        -- 源0x7214，406号。
        H.gun_count(a,3,16,1)
        H.at(a,v,0)
        -- 源0x7230，404号。
        H.gun_angle(a,3,0.0,0.0)
        H.at(a,v,0)
        -- 源0x724c，405号。
        H.gun_speed(a,3,3.0,1.5)
        H.at(a,v,0)
        -- 源0x7268，409号。
        H.gun_transform(a,3,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7298，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x72ac，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x72c0，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x72d4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x72e8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x72fc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7310，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7328，404号。
        H.gun_angle(a,2,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7344，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x7358，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x736c，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x7380，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x7390，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x73a4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x73b4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x73cc，401号。
        H.fire(a,3)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x73e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x73f4，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x7408，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7418，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x742c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7440，44号。
        H.push(v,0.3926990032196045)
        H.at(a,v,0)
        -- 源0x7454，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7464，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7478，83号。
        v.origin=v.origin+H.int(10)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x748c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x74a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x74b8，10号。
        return
    end
    P["BossCard1At3"]=B.part1
end

-- stage07boss.ecl：BossCard2，0x74d8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x74d8，40号。
        H.at(a,v,0)
        -- 源0x74ec，342号。
        H.spell(a,166,5400,500000,"表象「弾幕パラノイア」",342)
        H.at(a,v,0)
        -- 源0x7524，334号。
        H.interrupt(a,0,0,5400,"Boss3")
        H.at(a,v,0)
        -- 源0x754c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x755c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x756c，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0x757c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x759c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x75b0，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x75c4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x75d8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x75ec，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x75fc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7614，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x7648，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7660，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7698，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x76ac，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x76c0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x76d0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x76e8，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x76fc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7710，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7720，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7738，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7748，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x775c，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x776c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7780，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7794，344号。
        a.chapter=44
        H.at(a,v,120)
        -- 源0x77a8，0号。
        H.at(a,v,120)
        -- 源0x77b8，324号。
        H.limit(a,0.0,128.0,320.0,6.0)
        H.at(a,v,120)
        -- 源0x77d8，15号。
        H.async(a,P["BossCard2at"],"BossCard2at",nil)
        H.at(a,v,120)
        -- 源0x77f8，15号。
        H.async(a,P["BossCard2at2"],"BossCard2at2",nil)
        H.at(a,v,120)
        -- 源0x781c，12号。
        v.origin=H.clock(a)-(120);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x7834，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x7848，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x785c，292号。
        H.wander(a,0,60,0,1.5)
        H.at(a,v,120)
        -- 源0x7878，83号。
        v.origin=v.origin+H.int(340)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x788c，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x78a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x78b8，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage07boss.ecl：BossCard2at，0x78d8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x78d8，40号。
        H.at(a,v,0)
        -- 源0x78ec，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x7900，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x7918，402号。
        H.gun_sprite(a,0,4,4)
        H.at(a,v,0)
        -- 源0x7934，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x7950，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x796c，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0x7988，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x79b8，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x79e8，409号。
        H.gun_transform(a,0,2,0,1024,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7a18，409号。
        H.gun_transform(a,0,3,0,16,120,1,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0x7a48，409号。
        H.gun_transform(a,0,4,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7a78，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x7a94，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7aac，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7ac0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7ad4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x7ae8，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x7afc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x7b0c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x7b20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7b30，81号。
        do local r=H.read(a,v,-1);local angle=(v.l[0] or 0);v.l[8]=H.f32(math.cos(angle)*r);v.l[12]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0x7b50，44号。
        H.push(v,H.read(a,v,-9964))
        H.at(a,v,0)
        -- 源0x7b64，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x7b78，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7b88，44号。
        H.push(v,H.read(a,v,-9965))
        H.at(a,v,0)
        -- 源0x7b9c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x7bb0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7bc0，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x7bdc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7bf0，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x7c04，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x7c18，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x7c28，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x7c3c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7c4c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7c60，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x7c74，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7c84，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7c94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7ca4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7cb8，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x7cd4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7ce8，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7cfc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7d10，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7d28，10号。
        return
    end
    P["BossCard2at"]=B.part1
end

-- stage07boss.ecl：BossCard2at2，0x7d48；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7d48，40号。
        H.at(a,v,0)
        -- 源0x7d5c，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x7d70，407号。
        H.gun_aim(a,1,0)
        H.at(a,v,0)
        -- 源0x7d88，402号。
        H.gun_sprite(a,1,12,3)
        H.at(a,v,0)
        -- 源0x7da4，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0x7dc0，404号。
        H.gun_angle(a,1,0.0,0.19634954631328583)
        H.at(a,v,0)
        -- 源0x7ddc，405号。
        H.gun_speed(a,1,1.0,1.5)
        H.at(a,v,0)
        -- 源0x7df8，409号。
        H.gun_transform(a,1,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7e28，408号。
        H.gun_sound(a,1,7,-1)
        H.at(a,v,0)
        -- 源0x7e44，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0x7e58，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7e6c，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7e84，406号。
        H.gun_count(a,1,9,1)
        H.at(a,v,0)
        -- 源0x7ea0，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x7eb4，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7ec8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x7edc，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7eec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7f04，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7f18，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x7f2c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x7f3c，43号。
        v.l[20]=H.int(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7f50，83号。
        v.origin=v.origin+H.int((v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7f64，406号。
        H.gun_count(a,1,8,1)
        H.at(a,v,0)
        -- 源0x7f80，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x7f94，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7fa8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x7fbc，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7fcc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7fe4，42号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x7ff8，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0x800c，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x801c，43号。
        v.l[20]=H.int(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8030，83号。
        v.origin=v.origin+H.int((v.l[20] or 0))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8044，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8058，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8070，10号。
        return
    end
    P["BossCard2at2"]=B.part1
end

-- stage07boss.ecl：BossCard3，0x8090；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8090，40号。
        H.at(a,v,0)
        -- 源0x80a4，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x80b8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x80c8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x80dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x80f0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8100，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8118，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x812c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8144，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8158，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8168，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x8178，334号。
        H.interrupt(a,0,0,5400,"Boss4")
        H.at(a,v,0)
        -- 源0x81a0，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x81b4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x81c8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x81dc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x81ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8204，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8218，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x822c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x823c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8254，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8264，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x8278，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8288，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x829c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x82b0，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x82c4，342号。
        H.spell(a,167,5400,500000,"本能「イドの解放」",342)
        H.at(a,v,0)
        -- 源0x82f8，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x830c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x832c，0号。
        H.at(a,v,60)
        -- 源0x833c，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x8354，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x8368，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x837c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x8390，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x83b0，15号。
        H.async(a,P["BossCard3At"],"BossCard3At",nil,0,2,-0.007853982038795948,0.09817477315664291)
        H.at(a,v,60)
        -- 源0x83f0，15号。
        H.async(a,P["BossCard3At"],"BossCard3At",nil,1,1,0.007853982038795948,-0.09817477315664291)
        H.at(a,v,60)
        -- 源0x8430，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x8444，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x845c，83号。
        v.origin=v.origin+H.int(100)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x8470，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x8484，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x849c，10号。
        return
    end
    P["BossCard3"]=B.part1
end

-- stage07boss.ecl：BossCard3At，0x84bc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x84bc，40号。
        H.at(a,v,0)
        -- 源0x84d0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x84e4，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x84f8，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x850c，407号。
        H.gun_aim(a,(v.l[0] or 0),3)
        H.at(a,v,0)
        -- 源0x8524，402号。
        H.gun_sprite(a,(v.l[0] or 0),27,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8540，406号。
        H.gun_count(a,(v.l[0] or 0),12,1)
        H.at(a,v,0)
        -- 源0x855c，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x8578，405号。
        H.gun_speed(a,(v.l[0] or 0),2.5,1.5)
        H.at(a,v,0)
        -- 源0x8594，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x85c4，409号。
        H.gun_transform(a,(v.l[0] or 0),1,0,1024,260,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x85f4，409号。
        H.gun_transform(a,(v.l[0] or 0),2,0,8,260,-999999,-0.008461538702249527,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8624，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x863c，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x8650，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8664，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x8678，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8688，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8698，404号。
        H.gun_angle(a,(v.l[0] or 0),H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x86b4，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x86c8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0x86dc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x86f0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8700，45号。
        v.l[16]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8714，83号。
        v.origin=v.origin+H.int(18)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8728，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x873c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8754，10号。
        return
    end
    P["BossCard3At"]=B.part1
end

-- stage07boss.ecl：BossCard4，0x8774；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8774，40号。
        H.at(a,v,0)
        -- 源0x8788，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x879c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x87ac，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x87c0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x87d4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x87e4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x87fc，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x8830，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8848，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8880，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8890，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x88a0，334号。
        H.interrupt(a,0,0,5400,"Boss5")
        H.at(a,v,0)
        -- 源0x88c8，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x88dc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x88f0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8904，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8914，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x892c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8940，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8954，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8964，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x897c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x898c，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x89a0，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x89b0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x89c4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x89d8，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x89ec，342号。
        H.spell(a,168,5400,500000,"抑制「スーパーエゴ」",342)
        H.at(a,v,0)
        -- 源0x8a24，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x8a38，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x8a58，0号。
        H.at(a,v,60)
        -- 源0x8a68，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x8a80，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x8a94，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x8aa8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x8abc，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0x8adc，15号。
        H.async(a,P["BossCard4At"],"BossCard4At",nil,0,4,-0.008267348632216454,0.09817477315664291,-1.5707963705062866)
        H.at(a,v,60)
        -- 源0x8b24，15号。
        H.async(a,P["BossCard4At"],"BossCard4At",nil,1,3,0.008267348632216454,-0.09817477315664291,1.5707963705062866)
        H.at(a,v,60)
        -- 源0x8b6c，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x8b80，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x8b98，83号。
        v.origin=v.origin+H.int(100)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x8bac，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x8bc0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x8bd8，10号。
        return
    end
    P["BossCard4"]=B.part1
end

-- stage07boss.ecl：BossCard4At，0x8bf8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8bf8，40号。
        H.at(a,v,0)
        -- 源0x8c0c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8c20，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8c34，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x8c48，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8c5c，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8c70，407号。
        H.gun_aim(a,(v.l[0] or 0),5)
        H.at(a,v,0)
        -- 源0x8c88，402号。
        H.gun_sprite(a,(v.l[0] or 0),27,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8ca4，406号。
        H.gun_count(a,(v.l[0] or 0),12,1)
        H.at(a,v,0)
        -- 源0x8cc0，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x8cdc，405号。
        H.gun_speed(a,(v.l[0] or 0),0.30000001192092896,1.5)
        H.at(a,v,0)
        -- 源0x8cf8，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8d28，409号。
        H.gun_transform(a,(v.l[0] or 0),1,0,1024,260,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8d58，409号。
        H.gun_transform(a,(v.l[0] or 0),2,0,16,1,1,(v.l[16] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x8d88，409号。
        H.gun_transform(a,(v.l[0] or 0),4,0,4096,25,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8db8，409号。
        H.gun_transform(a,(v.l[0] or 0),5,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x8de8，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x8e04，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8e18，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8e2c，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8e44，409号。
        H.gun_transform(a,(v.l[0] or 0),3,0,8,(v.l[28] or 0),-999999,0.007692307699471712,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x8e74，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x8e8c，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x8ea0，42号。
        H.push(v,350)
        H.at(a,v,0)
        -- 源0x8eb4，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8ec4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8edc，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x8ef8，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x8f0c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8f20，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8f30，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8f44，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8f5c，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x8f70，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8f84，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x8f98，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x8fa8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x8fb8，404号。
        H.gun_angle(a,(v.l[0] or 0),H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x8fd4，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x8fe8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x8ffc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x900c，45号。
        v.l[20]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9020，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x9038，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x904c，42号。
        H.push(v,260)
        H.at(a,v,0)
        -- 源0x9060，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9070，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9088，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x909c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x90b0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x90c0，43号。
        v.l[28]=H.int(H.pop(v))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x90d4，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x90e8，83号。
        v.origin=v.origin+H.int(20)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x90fc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9110，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x9128，10号。
        return
    end
    P["BossCard4At"]=B.part1
end

-- stage07boss.ecl：BossCard5，0x9148；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9148，40号。
        H.at(a,v,0)
        -- 源0x915c，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0x9170，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x9180，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x9194，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x91a8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x91b8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x91d0，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x9204，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x921c，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9254，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x9264，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x9274，334号。
        H.interrupt(a,0,0,3000,"Boss6")
        H.at(a,v,0)
        -- 源0x929c，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x92b0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x92c4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x92d8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x92e8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9300，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x9314，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9328，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9338，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9350，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x9360，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x9374，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9384，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9398，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x93ac，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x93c0，342号。
        H.spell(a,169,3000,500000,"反応「妖怪ポリグラフ」",342)
        H.at(a,v,0)
        -- 源0x93f8，362号。
        a.session.spell_flag8=true
        H.at(a,v,0)
        -- 源0x9408，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x941c，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x9430，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x9450，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0x9460，0号。
        H.at(a,v,60)
        -- 源0x9470，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x9488，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x949c，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x94b0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x94c4，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x94d8，259号。
        H.anm_slot(a,2,23)
        H.at(a,v,60)
        -- 源0x94f0，323号。
        H.flags(a,2,false)
        H.at(a,v,60)
        -- 源0x9504，42号。
        H.push(v,4)
        H.at(a,v,60)
        -- 源0x9518，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x952c，44号。
        H.push(v,3.534291982650757)
        H.at(a,v,60)
        -- 源0x9540，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x9554，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0x956c，256号。
        H.spawn(a,256,"BossCard5Shadow",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0x95a4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x95b8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0x95cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x95dc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x95f0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0x9604，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x961c，42号。
        H.push(v,4)
        H.at(a,v,60)
        -- 源0x9630，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0x9644，44号。
        H.push(v,4.319690227508545)
        H.at(a,v,60)
        -- 源0x9658，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0x966c，12号。
        v.origin=H.clock(a)-(60);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x9684，256号。
        H.spawn(a,256,"BossCard5Shadow2",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0x96c0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,60)
        -- 源0x96d4，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0x96e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0x96f8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0x970c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0x9720，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0x9738，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x974c，12号。
        v.origin=H.clock(a)-(60);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0x9764，335号。
        a.invul=20
        H.at(a,v,60)
        -- 源0x9778，83号。
        v.origin=v.origin+H.int(10)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0x978c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x97a0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0x97b8，10号。
        return
    end
    P["BossCard5"]=B.part1
end

-- stage07boss.ecl：BossCard5At，0x97d8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x97d8，40号。
        H.at(a,v,0)
        -- 源0x97ec，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9800，45号。
        v.l[20]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9814，42号。
        H.push(v,40)
        H.at(a,v,0)
        -- 源0x9828，43号。
        v.l[28]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x983c，400号。
        H.gun_new(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9850，407号。
        H.gun_aim(a,(v.l[0] or 0),5)
        H.at(a,v,0)
        -- 源0x9868，402号。
        H.gun_sprite(a,(v.l[0] or 0),27,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x9884，406号。
        H.gun_count(a,(v.l[0] or 0),12,1)
        H.at(a,v,0)
        -- 源0x98a0，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x98bc，405号。
        H.gun_speed(a,(v.l[0] or 0),0.30000001192092896,1.5)
        H.at(a,v,0)
        -- 源0x98d8，409号。
        H.gun_transform(a,(v.l[0] or 0),0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9908，409号。
        H.gun_transform(a,(v.l[0] or 0),1,0,1024,260,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9938，409号。
        H.gun_transform(a,(v.l[0] or 0),2,0,16,1,1,(v.l[16] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x9968，409号。
        H.gun_transform(a,(v.l[0] or 0),4,0,4096,25,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9998，409号。
        H.gun_transform(a,(v.l[0] or 0),5,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x99c8，408号。
        H.gun_sound(a,0,7,-1)
        H.at(a,v,0)
        -- 源0x99e4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x99f8，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9a0c，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9a24，409号。
        H.gun_transform(a,(v.l[0] or 0),3,0,8,(v.l[28] or 0),-999999,0.007692307699471712,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x9a54，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x9a6c，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x9a80，42号。
        H.push(v,350)
        H.at(a,v,0)
        -- 源0x9a94，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9aa4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9abc，404号。
        H.gun_angle(a,(v.l[0] or 0),0.0,0.0)
        H.at(a,v,0)
        -- 源0x9ad8，44号。
        H.push(v,(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x9aec，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9b00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9b10，45号。
        v.l[24]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9b24，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9b3c，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x9b50，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9b64，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x9b78，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x9b88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9b98，404号。
        H.gun_angle(a,(v.l[0] or 0),H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x9bb4，44号。
        H.push(v,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0x9bc8，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x9bdc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9bec，45号。
        v.l[20]=H.f32(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9c00，438号。
        H.gun_distance(a,(v.l[0] or 0),(v.l[24] or 0))
        H.at(a,v,0)
        -- 源0x9c18，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x9c2c，42号。
        H.push(v,260)
        H.at(a,v,0)
        -- 源0x9c40，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9c50，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9c68，42号。
        H.push(v,(v.l[28] or 0))
        H.at(a,v,0)
        -- 源0x9c7c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x9c90，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x9ca0，43号。
        v.l[28]=H.int(H.pop(v))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9cb4，401号。
        H.fire(a,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9cc8，83号。
        v.origin=v.origin+H.int(20)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x9cdc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9cf0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x9d08，10号。
        return
    end
    P["BossCard5At"]=B.part1
end

-- stage07boss.ecl：BossCard5Shadow，0x9d28；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9d28，40号。
        H.at(a,v,0)
        -- 源0x9d3c，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x9d50，259号。
        H.anm_slot(a,0,192)
        H.at(a,v,0)
        -- 源0x9d68，275号。
        H.anm_switch(a,0,1)
        H.at(a,v,0)
        -- 源0x9d80，322号。
        H.flags(a,259,true)
        H.at(a,v,0)
        -- 源0x9d94，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x9da8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9dbc，443号。
        H.callback(a,443,7)
        H.at(a,v,0)
        -- 源0x9dd0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x9de4，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x9dfc，402号。
        H.gun_sprite(a,0,5,2)
        H.at(a,v,0)
        -- 源0x9e18，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x9e34，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x9e50，405号。
        H.gun_speed(a,0,1.0099999904632568,1.5)
        H.at(a,v,0)
        -- 源0x9e6c，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9e9c，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x9eb0，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9ec4，11号。
        H.call(a,v,P["BossCard5Shadow2At"],"BossCard5Shadow2At")
        H.at(a,v,0)
        -- 源0x9eec，1号。
        H.erase(a);return
    end
    P["BossCard5Shadow"]=B.part1
end

-- stage07boss.ecl：BossCard5Shadow2，0x9f0c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9f0c，40号。
        H.at(a,v,0)
        -- 源0x9f20，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x9f34，259号。
        H.anm_slot(a,0,192)
        H.at(a,v,0)
        -- 源0x9f4c，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x9f64，322号。
        H.flags(a,259,true)
        H.at(a,v,0)
        -- 源0x9f78，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x9f8c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9fa0，443号。
        H.callback(a,443,7)
        H.at(a,v,0)
        -- 源0x9fb4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x9fc8，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x9fe0，402号。
        H.gun_sprite(a,0,5,6)
        H.at(a,v,0)
        -- 源0x9ffc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xa018，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xa034，405号。
        H.gun_speed(a,0,1.0099999904632568,1.5)
        H.at(a,v,0)
        -- 源0xa050，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa080，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa094，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa0a8，11号。
        H.call(a,v,P["BossCard5Shadow2At"],"BossCard5Shadow2At")
        H.at(a,v,0)
        -- 源0xa0d0，1号。
        H.erase(a);return
    end
    P["BossCard5Shadow2"]=B.part1
end

-- stage07boss.ecl：BossCard5Shadow2At，0xa0f0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa0f0，40号。
        H.at(a,v,0)
        -- 源0xa104，44号。
        H.push(v,0.0017450000159442425)
        H.at(a,v,0)
        -- 源0xa118，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa12c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa140，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa154，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa168，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa17c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xa190，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa1a4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa1b8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa1cc，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa1e4，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa1f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa20c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa21c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa234，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0xa248，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa25c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa26c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa280，44号。
        H.push(v,H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0xa294，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0xa2a8，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa2b8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa2d0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa2e4，43号。
        v.l[0]=H.int(H.pop(v))
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa2f8，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xa310，44号。
        H.push(v,H.read(a,v,-9944))
        H.at(a,v,0)
        -- 源0xa324，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xa338，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xa34c，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xa360，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xa370，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa384，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xa398，44号。
        H.push(v,1.9999999949504854e-06)
        H.at(a,v,0)
        -- 源0xa3ac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa3bc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa3d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xa3e4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xa3f8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa40c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xa41c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xa42c，277号。
        H.anm_rotate(a,0.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xa444，405号。
        H.gun_speed(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xa460，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xa474，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0xa488，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa49c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xa4ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xa4bc，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0xa4d8，83号。
        v.origin=v.origin+H.int(1)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xa4ec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa500，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xa518，10号。
        return
    end
    P["BossCard5Shadow2At"]=B.part1
end

-- stage07boss.ecl：BossCard6，0xa538；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa538，40号。
        H.at(a,v,0)
        -- 源0xa54c，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0xa560，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xa570，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xa584，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa598，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa5a8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa5c0，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xa5f4，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa60c，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa644，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xa654，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xa664，334号。
        H.interrupt(a,0,0,5400,"Boss7")
        H.at(a,v,0)
        -- 源0xa68c，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0xa6a0，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xa6b4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa6c8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa6d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa6f0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xa704，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa718，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa728，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xa740，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xa750，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0xa764，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xa774，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa788，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa79c，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xa7b0，342号。
        H.spell(a,170,5400,500000,"無意識「弾幕のロールシャッハ」",342)
        H.at(a,v,0)
        -- 源0xa7f0，362号。
        a.session.spell_flag8=true
        H.at(a,v,0)
        -- 源0xa800，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xa814，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xa834，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0xa844，0号。
        H.at(a,v,60)
        -- 源0xa854，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0xa86c，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xa880，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xa894，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0xa8b4，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0xa8c8，12号。
        v.origin=H.clock(a)-(60);return B.part17(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0xa8e0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0xa8f4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa908，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,60)
        -- 源0xa91c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa930，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xa944，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa958，44号。
        H.push(v,2.356194019317627)
        H.at(a,v,60)
        -- 源0xa96c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa980，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xa994，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa9a8，42号。
        H.push(v,6)
        H.at(a,v,60)
        -- 源0xa9bc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa9d0，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xa9e4，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xa9f8，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xaa2c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0xaa40，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaa54，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,60)
        -- 源0xaa68，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaa7c，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xaa90，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaaa4，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,60)
        -- 源0xaab8，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaacc，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xaae0，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaaf4，42号。
        H.push(v,6)
        H.at(a,v,60)
        -- 源0xab08，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xab1c，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xab30，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xab44，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xab78，42号。
        H.push(v,5)
        H.at(a,v,60)
        -- 源0xab8c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xaba0，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xabb8，292号。
        H.wander(a,0,50,0,1.0)
        H.at(a,v,60)
        -- 源0xabd4，83号。
        v.origin=v.origin+H.int(50)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0xabe8，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0xabfc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0xac14，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,60)
        -- 源0xac28，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xac3c，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,60)
        -- 源0xac50，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xac64，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xac78，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xac8c，44号。
        H.push(v,1.9634950160980225)
        H.at(a,v,60)
        -- 源0xaca0，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xacb4，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,60)
        -- 源0xacc8，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xacdc，42号。
        H.push(v,10)
        H.at(a,v,60)
        -- 源0xacf0，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xad04，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xad18，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xad2c，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xad60，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,60)
        -- 源0xad74，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xad88，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,60)
        -- 源0xad9c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xadb0，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xadc4，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xadd8，44号。
        H.push(v,1.1780970096588135)
        H.at(a,v,60)
        -- 源0xadec，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xae00，44号。
        H.push(v,0.20000000298023224)
        H.at(a,v,60)
        -- 源0xae14，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xae28，42号。
        H.push(v,10)
        H.at(a,v,60)
        -- 源0xae3c，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xae50，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xae64，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xae78，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xaeac，42号。
        H.push(v,5)
        H.at(a,v,60)
        -- 源0xaec0，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xaed4，12号。
        v.origin=H.clock(a)-(60);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,60)
        -- 源0xaeec，292号。
        H.wander(a,0,50,0,1.0)
        H.at(a,v,60)
        -- 源0xaf08，83号。
        v.origin=v.origin+H.int(50)
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,60)
        -- 源0xaf1c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0xaf30，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,60)
        -- 源0xaf48，44号。
        H.push(v,0.0)
        H.at(a,v,60)
        -- 源0xaf5c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaf70，44号。
        H.push(v,0.05235999822616577)
        H.at(a,v,60)
        -- 源0xaf84，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xaf98，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,60)
        -- 源0xafac，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xafc0，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,60)
        -- 源0xafd4，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xafe8，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,60)
        -- 源0xaffc，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb010，42号。
        H.push(v,4)
        H.at(a,v,60)
        -- 源0xb024，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb038，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xb04c，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb060，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xb094，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,60)
        -- 源0xb0a8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb0bc，44号。
        H.push(v,-0.05235999822616577)
        H.at(a,v,60)
        -- 源0xb0d0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb0e4，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,60)
        -- 源0xb0f8，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb10c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0xb120，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb134，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,60)
        -- 源0xb148，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb15c，42号。
        H.push(v,4)
        H.at(a,v,60)
        -- 源0xb170，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb184，42号。
        H.push(v,120)
        H.at(a,v,60)
        -- 源0xb198，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb1ac，256号。
        H.spawn(a,256,"BossCard6Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xb1e0，42号。
        H.push(v,5)
        H.at(a,v,60)
        -- 源0xb1f4，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xb208，12号。
        v.origin=H.clock(a)-(60);return B.part16(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,60)
        -- 源0xb220，292号。
        H.wander(a,0,50,0,1.0)
        H.at(a,v,60)
        -- 源0xb23c，83号。
        v.origin=v.origin+H.int(50)
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,60)
        -- 源0xb250，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,60)
        -- 源0xb264，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part15(a,v) end
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,60)
        -- 源0xb27c，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xb290，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,60)
        -- 源0xb2a8，10号。
        return
    end
    P["BossCard6"]=B.part1
end

-- stage07boss.ecl：BossCard6Et，0xb2c8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb2c8，40号。
        H.at(a,v,0)
        -- 源0xb2dc，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0xb2f0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xb304，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb318，15号。
        H.async(a,P["BossCard6EtAt"],"BossCard6EtAt",nil)
        H.at(a,v,0)
        -- 源0xb33c，300号。
        H.ellipse(a,0,H.read(a,v,-9981),H.read(a,v,-9980),0.0,1.0,H.read(a,v,-9978),H.read(a,v,-9935))
        H.at(a,v,0)
        -- 源0xb364，83号。
        v.origin=v.origin+H.int(H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0xb378，300号。
        H.ellipse(a,0,-999999.0,-999999.0,-999999.0,0.0,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xb3a0，83号。
        v.origin=v.origin+H.int(400)
        H.at(a,v,0)
        -- 源0xb3b4，1号。
        H.erase(a);return
    end
    P["BossCard6Et"]=B.part1
end

-- stage07boss.ecl：BossCard6EtAt，0xb3e4；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb3e4，40号。
        H.at(a,v,0)
        -- 源0xb3f8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xb40c，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0xb424，402号。
        H.gun_sprite(a,0,2,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0xb440，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xb45c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xb478，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0xb494，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xb4c4，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xb4f4，409号。
        H.gun_transform(a,0,2,0,4096,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xb524，409号。
        H.gun_transform(a,0,3,0,268435456,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xb554，409号。
        H.gun_transform(a,0,4,0,4,120,-999999,0.014999999664723873,-999999.0)
        H.at(a,v,0)
        -- 源0xb584，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb59c，404号。
        H.gun_angle(a,0,H.read(a,v,-9971),0.0)
        H.at(a,v,0)
        -- 源0xb5b8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xb5cc，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb5e0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb5f4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb60c，10号。
        return
    end
    P["BossCard6EtAt"]=B.part1
end

-- stage07boss.ecl：BossCard7，0xb62c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb62c，40号。
        H.at(a,v,0)
        -- 源0xb640，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0xb654，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xb664，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xb678，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb68c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb69c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb6b4，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xb6e8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb700，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb738，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xb748，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xb758，334号。
        H.interrupt(a,0,0,6300,"Boss8")
        H.at(a,v,0)
        -- 源0xb780，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0xb794，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xb7a8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb7bc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb7cc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xb7e4，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xb7f4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xb808，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb81c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb82c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xb844，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xb858，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xb868，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb87c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb890，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xb8a4，342号。
        H.spell(a,171,6300,500000,"復燃「恋の埋火」",342)
        H.at(a,v,0)
        -- 源0xb8d8，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xb8ec，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xb90c，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0xb91c，0号。
        H.at(a,v,60)
        -- 源0xb92c，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0xb944，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xb958，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xb96c，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        -- 源0xb98c，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0xb9a0，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0xb9b4，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xb9c8，443号。
        H.callback(a,443,8)
        H.at(a,v,60)
        -- 源0xb9dc，15号。
        H.async(a,P["BossCard7EtAt2"],"BossCard7EtAt2",nil)
        H.at(a,v,60)
        -- 源0xba00，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xba18，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xba2c，11号。
        H.call(a,v,P["BossCard7EtAt"],"BossCard7EtAt")
        H.at(a,v,60)
        -- 源0xba50，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,60)
        -- 源0xba64，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,60)
        -- 源0xba80，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xba94，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xbaa8，11号。
        H.call(a,v,P["BossCard7EtAt3"],"BossCard7EtAt3")
        H.at(a,v,60)
        -- 源0xbacc，83号。
        v.origin=v.origin+H.int(80)
        H.at(a,v,60)
        -- 源0xbae0，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,60)
        -- 源0xbafc，83号。
        v.origin=v.origin+H.int(120)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0xbb10，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xbb24，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0xbb3c，10号。
        return
    end
    P["BossCard7"]=B.part1
end

-- stage07boss.ecl：BossCard7Et，0xbb5c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbb5c，40号。
        H.at(a,v,0)
        -- 源0xbb70，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0xbb84，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xbb98，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xbbac，15号。
        H.async(a,P["BossCard7EtAt"],"BossCard7EtAt",nil)
        H.at(a,v,0)
        -- 源0xbbd0，300号。
        H.ellipse(a,0,H.read(a,v,-9981),H.read(a,v,-9980),0.0,1.0,H.read(a,v,-9978),H.read(a,v,-9935))
        H.at(a,v,0)
        -- 源0xbbf8，83号。
        v.origin=v.origin+H.int(H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0xbc0c，300号。
        H.ellipse(a,0,-999999.0,-999999.0,-999999.0,0.0,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbc34，83号。
        v.origin=v.origin+H.int(400)
        H.at(a,v,0)
        -- 源0xbc48，1号。
        H.erase(a);return
    end
    P["BossCard7Et"]=B.part1
end

-- stage07boss.ecl：BossCard7EtAt，0xbc78；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbc78，40号。
        H.at(a,v,0)
        -- 源0xbc8c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xbca0，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0xbcb8，402号。
        H.gun_sprite(a,0,27,2)
        H.at(a,v,0)
        -- 源0xbcd4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xbcf0，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xbd0c，405号。
        H.gun_speed(a,0,2.0,1.5)
        H.at(a,v,0)
        -- 源0xbd28，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbd58，409号。
        H.gun_transform(a,0,1,0,512,2000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbd88，409号。
        H.gun_transform(a,0,2,0,256,10,15,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbdb8，403号。
        H.gun_offset(a,0,-32.0,-48.0)
        H.at(a,v,0)
        -- 源0xbdd4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbde8，403号。
        H.gun_offset(a,0,32.0,-48.0)
        H.at(a,v,0)
        -- 源0xbe04，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xbe18，10号。
        return
    end
    P["BossCard7EtAt"]=B.part1
end

-- stage07boss.ecl：BossCard7EtAt2，0xbe38；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbe38，40号。
        H.at(a,v,0)
        -- 源0xbe4c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xbe64，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xbe78，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0xbe90，402号。
        H.gun_sprite(a,1,18,0)
        H.at(a,v,0)
        -- 源0xbeac，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0xbec8，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0xbee4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xbef8，44号。
        H.push(v,0.4000000059604645)
        H.at(a,v,0)
        -- 源0xbf0c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbf1c，405号。
        H.gun_speed(a,1,H.read(a,v,-1),1.5)
        H.at(a,v,0)
        -- 源0xbf38，409号。
        H.gun_transform(a,1,0,0,4096,50,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbf68，409号。
        H.gun_transform(a,1,1,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xbf98，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xbfac，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xbfc0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xbfd0，437号。
        H.gun_polar(a,1,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xbfec，83号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xc000，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0xc014，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0xc02c，402号。
        H.gun_sprite(a,1,25,0)
        H.at(a,v,0)
        -- 源0xc048，406号。
        H.gun_count(a,1,1,1)
        H.at(a,v,0)
        -- 源0xc064，404号。
        H.gun_angle(a,1,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0xc080，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xc094，44号。
        H.push(v,0.4000000059604645)
        H.at(a,v,0)
        -- 源0xc0a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc0b8，405号。
        H.gun_speed(a,1,H.read(a,v,-1),1.5)
        H.at(a,v,0)
        -- 源0xc0d4，409号。
        H.gun_transform(a,1,0,0,4096,50,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc104，409号。
        H.gun_transform(a,1,1,0,8192,-999999,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc134，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xc148，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xc15c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xc16c，437号。
        H.gun_polar(a,1,H.read(a,v,-9998),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xc188，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc19c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc1b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc1c8，10号。
        return
    end
    P["BossCard7EtAt2"]=B.part1
end

-- stage07boss.ecl：BossCard7EtAt3，0xc1e8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc1e8，40号。
        H.at(a,v,0)
        -- 源0xc1fc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xc210，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xc228，402号。
        H.gun_sprite(a,0,27,2)
        H.at(a,v,0)
        -- 源0xc244，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xc260，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xc27c，405号。
        H.gun_speed(a,0,2.0,1.5)
        H.at(a,v,0)
        -- 源0xc298，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc2c8，409号。
        H.gun_transform(a,0,1,0,512,2000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc2f8，409号。
        H.gun_transform(a,0,2,0,256,10,15,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc328，404号。
        H.gun_angle(a,0,0.39269909262657166,0.0)
        H.at(a,v,0)
        -- 源0xc344，403号。
        H.gun_offset(a,0,-32.0,-48.0)
        H.at(a,v,0)
        -- 源0xc360，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xc374，404号。
        H.gun_angle(a,0,2.7488934993743896,0.0)
        H.at(a,v,0)
        -- 源0xc390，403号。
        H.gun_offset(a,0,32.0,-48.0)
        H.at(a,v,0)
        -- 源0xc3ac，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xc3c0，10号。
        return
    end
    P["BossCard7EtAt3"]=B.part1
end

-- stage07boss.ecl：BossCard8，0xc3e0；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xc3e0，40号。
        H.at(a,v,0)
        -- 源0xc3f4，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0xc408，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xc418，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xc42c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xc440，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xc450，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc468，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xc49c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc4b4，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xc4ec，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xc4fc，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xc50c，334号。
        H.interrupt(a,0,0,6300,"BossCard9")
        H.at(a,v,0)
        -- 源0xc538，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0xc54c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xc560，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xc574，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xc584，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xc59c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xc5b0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc5c4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xc5d4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xc5ec，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xc5fc，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0xc610，329号。
        H.drop(a)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xc620，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc634，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc648，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xc65c，342号。
        H.spell(a,172,6300,500000,"深層「無意識の遺伝子」",342)
        H.at(a,v,0)
        -- 源0xc694，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0xc6a8，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xc6c8，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0xc6d8，0号。
        H.at(a,v,60)
        -- 源0xc6e8，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0xc700，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xc714，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xc728，322号。
        H.flags(a,12,true)
        H.at(a,v,60)
        -- 源0xc73c，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0xc750，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0xc764，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc778，276号。
        H.anm_reset(a)
        H.at(a,v,60)
        -- 源0xc788，259号。
        H.anm_slot(a,0,5)
        H.at(a,v,60)
        -- 源0xc7a0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0xc7b4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc7c8，44号。
        H.push(v,0.07853999733924866)
        H.at(a,v,60)
        -- 源0xc7dc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc7f0，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xc804，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc818，44号。
        H.push(v,2.356194019317627)
        H.at(a,v,60)
        -- 源0xc82c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc840，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xc854，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc868，42号。
        H.push(v,6)
        H.at(a,v,60)
        -- 源0xc87c，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc890，42号。
        H.push(v,100)
        H.at(a,v,60)
        -- 源0xc8a4，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc8b8，256号。
        H.spawn(a,256,"BossCard8Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xc8ec，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,60)
        -- 源0xc900，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc914，44号。
        H.push(v,-0.07853999733924866)
        H.at(a,v,60)
        -- 源0xc928，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc93c，44号。
        H.push(v,1.0)
        H.at(a,v,60)
        -- 源0xc950，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc964，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,60)
        -- 源0xc978，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc98c，44号。
        H.push(v,0.30000001192092896)
        H.at(a,v,60)
        -- 源0xc9a0，45号。
        H.write(a,-9935,H.f32(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc9b4，42号。
        H.push(v,10)
        H.at(a,v,60)
        -- 源0xc9c8，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xc9dc，42号。
        H.push(v,100)
        H.at(a,v,60)
        -- 源0xc9f0，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xca04，256号。
        H.spawn(a,256,"BossCard8Et",0.0,0.0,10,10,0)
        H.at(a,v,60)
        -- 源0xca38，12号。
        v.origin=H.clock(a)-(60);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0xca50，42号。
        H.push(v,416)
        H.at(a,v,60)
        -- 源0xca64，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xca78，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xca8c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xca9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcaac，42号。
        H.push(v,-160)
        H.at(a,v,60)
        -- 源0xcac0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcad4，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcae8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcaf8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcb08，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),H.read(a,v,-1),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcb34，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xcb48，42号。
        H.push(v,64)
        H.at(a,v,60)
        -- 源0xcb5c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcb70，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcb84，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcb94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcba4，42号。
        H.push(v,-160)
        H.at(a,v,60)
        -- 源0xcbb8，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcbcc，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcbe0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcbf0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcc00，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),H.read(a,v,-1),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcc2c，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xcc40，42号。
        H.push(v,160)
        H.at(a,v,60)
        -- 源0xcc54，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcc68，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcc7c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcc8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcc9c，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),320.0,H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xccc8，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xccdc，42号。
        H.push(v,160)
        H.at(a,v,60)
        -- 源0xccf0，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcd04，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcd18，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcd28，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcd38，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),64.0,H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcd64，83号。
        v.origin=v.origin+H.int(170)
        H.at(a,v,60)
        -- 源0xcd78，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0xcd8c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xcda0，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-9965),H.read(a,v,-9964),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcdcc，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xcde0，42号。
        H.push(v,416)
        H.at(a,v,60)
        -- 源0xcdf4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xce08，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xce1c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xce2c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xce3c，42号。
        H.push(v,-160)
        H.at(a,v,60)
        -- 源0xce50，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xce64，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xce78，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xce88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xce98，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),H.read(a,v,-1),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcec4，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xced8，42号。
        H.push(v,64)
        H.at(a,v,60)
        -- 源0xceec，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcf00，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcf14，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcf24，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcf34，42号。
        H.push(v,160)
        H.at(a,v,60)
        -- 源0xcf48，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcf5c，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xcf70，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xcf80，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xcf90，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),H.read(a,v,-1),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xcfbc，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xcfd0，42号。
        H.push(v,-160)
        H.at(a,v,60)
        -- 源0xcfe4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xcff8，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xd00c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xd01c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xd02c，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),64.0,H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xd058，83号。
        v.origin=v.origin+H.int(230)
        H.at(a,v,60)
        -- 源0xd06c，42号。
        H.push(v,160)
        H.at(a,v,60)
        -- 源0xd080，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,60)
        -- 源0xd094，42号。
        H.push(v,16)
        H.at(a,v,60)
        -- 源0xd0a8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,60)
        -- 源0xd0b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,60)
        -- 源0xd0c8，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-1),256.0,H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xd0f4，83号。
        v.origin=v.origin+H.int(170)
        H.at(a,v,60)
        -- 源0xd108，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0xd11c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xd130，305号。
        H.bezier(a,0,240,H.read(a,v,-9977),H.read(a,v,-9976),H.read(a,v,-9965),H.read(a,v,-9964),H.read(a,v,-9977),H.read(a,v,-9976))
        H.at(a,v,60)
        -- 源0xd15c，83号。
        v.origin=v.origin+H.int(230)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xd170，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xd184，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0xd19c，10号。
        return
    end
    P["BossCard8"]=B.part1
end

-- stage07boss.ecl：BossCard8Et，0xd1bc；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd1bc，40号。
        H.at(a,v,0)
        -- 源0xd1d0，322号。
        H.flags(a,300,true)
        H.at(a,v,0)
        -- 源0xd1e4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0xd1f8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd20c，15号。
        H.async(a,P["BossCard8EtAt"],"BossCard8EtAt",nil)
        H.at(a,v,0)
        -- 源0xd230，15号。
        H.async(a,P["BossCard8EtMove"],"BossCard8EtMove",nil)
        H.at(a,v,0)
        -- 源0xd254，302号。
        H.ellipse(a,1,H.read(a,v,-9981),H.read(a,v,-9980),0.0,1.0,H.read(a,v,-9978),H.read(a,v,-9935))
        H.at(a,v,0)
        -- 源0xd27c，83号。
        v.origin=v.origin+H.int(H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0xd290，302号。
        H.ellipse(a,1,-999999.0,-999999.0,-999999.0,0.0,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd2b8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd2d0，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd2e4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd2f8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd310，1号。
        H.erase(a);return
    end
    P["BossCard8Et"]=B.part1
end

-- stage07boss.ecl：BossCard8EtAt，0xd330；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd330，40号。
        H.at(a,v,0)
        -- 源0xd344，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xd358，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0xd370，402号。
        H.gun_sprite(a,0,1,H.read(a,v,-9985))
        H.at(a,v,0)
        -- 源0xd38c，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xd3a8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xd3c4，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0xd3e0，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd410，409号。
        H.gun_transform(a,0,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd440，409号。
        H.gun_transform(a,0,2,0,1024,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd470，409号。
        H.gun_transform(a,0,3,0,4096,120,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd4a0，409号。
        H.gun_transform(a,0,4,0,268435456,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xd4d0，409号。
        H.gun_transform(a,0,5,0,4,120,-999999,0.02500000037252903,-999999.0)
        H.at(a,v,0)
        -- 源0xd500，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd514，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd528，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd540，44号。
        H.push(v,H.read(a,v,-9970))
        H.at(a,v,0)
        -- 源0xd554，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd568，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd578，404号。
        H.gun_angle(a,0,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0xd594，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xd5a8，44号。
        H.push(v,0.019634999334812164)
        H.at(a,v,0)
        -- 源0xd5bc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xd5cc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xd5e0，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0xd5f4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xd608，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd61c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd630，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd648，10号。
        return
    end
    P["BossCard8EtAt"]=B.part1
end

-- stage07boss.ecl：BossCard8EtMove，0xd668；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd668，40号。
        H.at(a,v,0)
        -- 源0xd67c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd694，280号。
        H.position(a,0,H.read(a,v,-9963),H.read(a,v,-9962))
        H.at(a,v,0)
        -- 源0xd6ac，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd6c0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd6d4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd6ec，10号。
        return
    end
    P["BossCard8EtMove"]=B.part1
end

-- stage07boss.ecl：BossCard9，0xd70c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xd70c，40号。
        H.at(a,v,0)
        -- 源0xd720，335号。
        a.invul=200
        H.at(a,v,0)
        -- 源0xd734，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0xd744，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xd758，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd76c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd77c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xd794，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xd7c8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd7e0，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xd818，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xd828，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xd838，449号。
        H.callback(a,449,11)
        H.at(a,v,0)
        -- 源0xd84c，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0xd860，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0xd870，322号。
        H.flags(a,15,true)
        H.at(a,v,0)
        -- 源0xd884，331号。
        H.life(a,4000)
        H.at(a,v,0)
        -- 源0xd898，334号。
        H.interrupt(a,0,0,3540,"BossCard10")
        H.at(a,v,0)
        -- 源0xd8c4，347号。
        H.life_marker(a,0,4000.0,-24448)
        H.at(a,v,0)
        -- 源0xd8e0，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0xd8f4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xd908，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xd91c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd92c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xd944，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xd954，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xd968，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xd97c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xd98c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xd9a4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xd9b8，327号。
        H.drop_extra(a,1,10)
        H.at(a,v,0)
        -- 源0xd9d0，327号。
        H.drop_extra(a,2,40)
        H.at(a,v,0)
        -- 源0xd9e8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xd9f8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xda0c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xda20，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xda34，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0xda4c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0xda60，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0xda70，342号。
        H.spell(a,173,3540,500000,"「嫌われ者のフィロソフィ」",342)
        H.at(a,v,0)
        -- 源0xdaac，362号。
        a.session.spell_flag8=true
        H.at(a,v,0)
        -- 源0xdabc，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0xdad0，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0xdaf0，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0xdb00，0号。
        H.at(a,v,60)
        -- 源0xdb10，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0xdb28，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0xdb3c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xdb50，276号。
        H.anm_reset(a)
        H.at(a,v,60)
        -- 源0xdb60，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0xdb74，400号。
        H.gun_new(a,0)
        H.at(a,v,60)
        -- 源0xdb88，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,60)
        -- 源0xdba0，402号。
        H.gun_sprite(a,0,17,1)
        H.at(a,v,60)
        -- 源0xdbbc，406号。
        H.gun_count(a,0,32,1)
        H.at(a,v,60)
        -- 源0xdbd8，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,60)
        -- 源0xdbf4，405号。
        H.gun_speed(a,0,2.0,1.5)
        H.at(a,v,60)
        -- 源0xdc10，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,60)
        -- 源0xdc40，401号。
        H.fire(a,0)
        H.at(a,v,60)
        -- 源0xdc54，42号。
        H.push(v,2)
        H.at(a,v,60)
        -- 源0xdc68，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xdc7c，449号。
        H.callback(a,449,9)
        H.at(a,v,60)
        -- 源0xdc90，443号。
        H.callback(a,443,10)
        H.at(a,v,60)
        -- 源0xdca4，322号。
        H.flags(a,32,true)
        H.at(a,v,60)
        -- 源0xdcb8，440号。
        H.fog(a,0.0,16711680)
        H.at(a,v,60)
        -- 源0xdcd0，15号。
        H.async(a,P["BossCard9EtAtA"],"BossCard9EtAtA",nil)
        H.at(a,v,60)
        -- 源0xdcf4，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xdd08，440号。
        H.fog(a,128.0,16711935)
        H.at(a,v,60)
        -- 源0xdd20，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xdd34，281号。
        H.position_time(a,0,60,4,-128.0,128.0)
        H.at(a,v,60)
        -- 源0xdd54，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xdd68，281号。
        H.position_time(a,0,120,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xdd88，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xdd9c，281号。
        H.position_time(a,0,120,0,-128.0,128.0)
        H.at(a,v,60)
        -- 源0xddbc，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xddd0，281号。
        H.position_time(a,0,120,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xddf0，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xde04，281号。
        H.position_time(a,0,240,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xde24，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,60)
        -- 源0xde38，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,60)
        -- 源0xde4c，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0xde5c，15号。
        H.async(a,P["BossCard9EtAtB1"],"BossCard9EtAtB1",nil)
        H.at(a,v,60)
        -- 源0xde80，15号。
        H.async(a,P["BossCard9EtAtB2"],"BossCard9EtAtB2",nil)
        H.at(a,v,60)
        -- 源0xdea4，281号。
        H.position_time(a,0,60,0,H.read(a,v,-9965),H.read(a,v,-9964))
        H.at(a,v,60)
        -- 源0xdec4，83号。
        v.origin=v.origin+H.int(360)
        H.at(a,v,60)
        -- 源0xded8，281号。
        H.position_time(a,0,160,0,-128.0,128.0)
        H.at(a,v,60)
        -- 源0xdef8，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0xdf0c，281号。
        H.position_time(a,0,160,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xdf2c，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0xdf40，281号。
        H.position_time(a,0,160,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xdf60，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0xdf74，281号。
        H.position_time(a,0,160,0,128.0,128.0)
        H.at(a,v,60)
        -- 源0xdf94，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0xdfa8，281号。
        H.position_time(a,0,120,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xdfc8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xdfdc，281号。
        H.position_time(a,0,120,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xdffc，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xe010，281号。
        H.position_time(a,0,120,0,-128.0,128.0)
        H.at(a,v,60)
        -- 源0xe030，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xe044，281号。
        H.position_time(a,0,120,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe064，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xe078，421号。
        H.cancel(a,640.0,false)
        H.at(a,v,60)
        -- 源0xe08c，440号。
        H.fog(a,144.0,16711935)
        H.at(a,v,60)
        -- 源0xe0a4，21号。
        H.stop_threads(a)
        H.at(a,v,60)
        -- 源0xe0b4，15号。
        H.async(a,P["BossCard9EtAtC1"],"BossCard9EtAtC1",nil)
        H.at(a,v,60)
        -- 源0xe0d8，15号。
        H.async(a,P["BossCard9EtAtC2"],"BossCard9EtAtC2",nil)
        H.at(a,v,60)
        -- 源0xe0fc，281号。
        H.position_time(a,0,60,0,-128.0,112.0)
        H.at(a,v,60)
        -- 源0xe11c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe130，281号。
        H.position_time(a,0,60,0,128.0,112.0)
        H.at(a,v,60)
        -- 源0xe150，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe164，281号。
        H.position_time(a,0,60,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xe184，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe198，281号。
        H.position_time(a,0,60,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe1b8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe1cc，281号。
        H.position_time(a,0,60,0,-128.0,112.0)
        H.at(a,v,60)
        -- 源0xe1ec，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe200，281号。
        H.position_time(a,0,60,0,128.0,112.0)
        H.at(a,v,60)
        -- 源0xe220，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe234，281号。
        H.position_time(a,0,60,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xe254，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe268，281号。
        H.position_time(a,0,60,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe288，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe29c，281号。
        H.position_time(a,0,60,0,-128.0,112.0)
        H.at(a,v,60)
        -- 源0xe2bc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe2d0，281号。
        H.position_time(a,0,60,0,128.0,112.0)
        H.at(a,v,60)
        -- 源0xe2f0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe304，281号。
        H.position_time(a,0,60,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xe324，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe338，281号。
        H.position_time(a,0,60,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe358，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe36c，281号。
        H.position_time(a,0,60,0,-128.0,112.0)
        H.at(a,v,60)
        -- 源0xe38c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe3a0，281号。
        H.position_time(a,0,60,0,128.0,112.0)
        H.at(a,v,60)
        -- 源0xe3c0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe3d4，281号。
        H.position_time(a,0,60,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xe3f4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe408，281号。
        H.position_time(a,0,60,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe428，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe43c，281号。
        H.position_time(a,0,60,0,-128.0,112.0)
        H.at(a,v,60)
        -- 源0xe45c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe470，281号。
        H.position_time(a,0,60,0,128.0,112.0)
        H.at(a,v,60)
        -- 源0xe490，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe4a4，281号。
        H.position_time(a,0,60,0,128.0,360.0)
        H.at(a,v,60)
        -- 源0xe4c4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe4d8，281号。
        H.position_time(a,0,60,0,-128.0,360.0)
        H.at(a,v,60)
        -- 源0xe4f8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0xe50c，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xe524，83号。
        v.origin=v.origin+H.int(1000)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0xe538，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xe54c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0xe564，10号。
        return
    end
    P["BossCard9"]=B.part1
end

-- stage07boss.ecl：BossCard9EtAtA，0xe584；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xe584，40号。
        H.at(a,v,0)
        -- 源0xe598，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xe5ac，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xe5c4，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0xe5e0，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xe5fc，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xe618，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0xe634，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe664，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xe694，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xe6a8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe6bc，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xe6d0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xe6e4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xe6f8，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xe708，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe718，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe72c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xe740，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe754，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xe76c，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe780，42号。
        H.push(v,5)
        H.at(a,v,0)
        -- 源0xe794，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xe7a4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xe7b8，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xe7c8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xe7e0，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xe7f4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xe808，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xe824，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xe83c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe850，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xe864，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xe878，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xe888，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe898，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),-16.0)
        H.at(a,v,0)
        -- 源0xe8b4，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xe8c8，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xe8dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xe8f4，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe908，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xe91c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xe92c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xe940，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe954，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xe968，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xe978，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xe990，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xe9a4，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xe9b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe9c8，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xe9dc，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xe9f0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xea04，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xea14，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xea28，83号。
        v.origin=v.origin+H.int(13)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xea3c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xea50，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xea68，10号。
        return
    end
    P["BossCard9EtAtA"]=B.part1
end

-- stage07boss.ecl：BossCard9EtAtB1，0xea88；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xea88，40号。
        H.at(a,v,0)
        -- 源0xea9c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xeab0，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xeac8，402号。
        H.gun_sprite(a,0,1,13)
        H.at(a,v,0)
        -- 源0xeae4，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xeb00，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xeb1c，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0xeb38，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xeb68，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xeb98，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xebac，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xebc0，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xebd4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xebe8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xebfc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xec0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xec1c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xec30，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xec44，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xec58，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xec70，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xec84，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xec98，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xeca8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xecbc，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xeccc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xece4，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xecf8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xed0c，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xed28，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xed40，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xed54，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xed68，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xed7c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xed8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xed9c，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),464.0)
        H.at(a,v,0)
        -- 源0xedb8，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xedcc，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xede0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xedf8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xee0c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xee20，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xee30，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xee44，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xee58，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xee6c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xee7c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xee94，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xeea8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xeebc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xeecc，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xeee0，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xeef4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xef08，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xef18，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xef2c，83号。
        v.origin=v.origin+H.int(13)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xef40，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xef54，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xef6c，10号。
        return
    end
    P["BossCard9EtAtB1"]=B.part1
end

-- stage07boss.ecl：BossCard9EtAtB2，0xef8c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xef8c，40号。
        H.at(a,v,0)
        -- 源0xefa0，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xefb4，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xefcc，402号。
        H.gun_sprite(a,0,1,13)
        H.at(a,v,0)
        -- 源0xefe8，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xf004，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xf020，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0xf03c，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf06c，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf09c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf0b0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf0c4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf0d8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf0ec，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf0fc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf110，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf124，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf138，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf150，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xf164，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xf178，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xf188，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf19c，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xf1ac，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf1c4，42号。
        H.push(v,7)
        H.at(a,v,0)
        -- 源0xf1d8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf1ec，404号。
        H.gun_angle(a,0,3.1415927410125732,0.0)
        H.at(a,v,0)
        -- 源0xf208，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf220，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xf234，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xf248，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf25c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf26c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf27c，439号。
        H.gun_absolute(a,0,208.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xf298，401号。
        H.fire(a,0)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xf2ac，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xf2c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xf2d8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xf2ec，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xf300，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf310，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf324，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xf338，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf34c，70号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xf35c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xf374，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xf388，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0xf39c，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xf3ac，45号。
        v.l[4]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xf3c0，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xf3d4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf3e8，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf3f8，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf40c，83号。
        v.origin=v.origin+H.int(13)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xf420，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf434，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xf44c，10号。
        return
    end
    P["BossCard9EtAtB2"]=B.part1
end

-- stage07boss.ecl：BossCard9EtAtC1，0xf46c；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf46c，40号。
        H.at(a,v,0)
        -- 源0xf480，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xf494，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xf4ac，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0xf4c8，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xf4e4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xf500，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0xf51c，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf54c，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf57c，409号。
        H.gun_transform(a,0,2,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf5ac，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf5c0，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf5d4，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xf5e8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf5fc，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0xf610，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf620，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf630，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf644，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf658，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf66c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xf684，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0xf698，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf6ac，404号。
        H.gun_angle(a,0,-1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xf6c8，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xf6e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xf6f4，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xf708，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0xf71c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf72c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xf73c，439号。
        H.gun_absolute(a,0,H.read(a,v,-1),464.0)
        H.at(a,v,0)
        -- 源0xf758，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xf76c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xf780，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xf798，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xf7ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf7c0，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xf7d0，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xf7e4，83号。
        v.origin=v.origin+H.int(100)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xf7f8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xf80c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xf824，10号。
        return
    end
    P["BossCard9EtAtC1"]=B.part1
end

-- stage07boss.ecl：BossCard9EtAtC2，0xf844；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xf844，40号。
        H.at(a,v,0)
        -- 源0xf858，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xf86c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xf884，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0xf8a0，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xf8bc，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xf8d8，405号。
        H.gun_speed(a,0,1.0,1.5)
        H.at(a,v,0)
        -- 源0xf8f4，409号。
        H.gun_transform(a,0,0,1,2,2,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf924，409号。
        H.gun_transform(a,0,1,0,512,400,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf954，409号。
        H.gun_transform(a,0,2,0,1024,60,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xf984，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xf998，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf9ac，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0xf9c0，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0xf9d4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xf9e4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xf9f8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xfa0c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xfa20，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xfa38，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0xfa4c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xfa60，404号。
        H.gun_angle(a,0,3.1415927410125732,0.0)
        H.at(a,v,0)
        -- 源0xfa7c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfa94，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xfaa8，42号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xfabc，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0xfad0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0xfae0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xfaf0，439号。
        H.gun_absolute(a,0,208.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xfb0c，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xfb20，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xfb34，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xfb4c，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xfb60，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfb74，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xfb84，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xfb98，83号。
        v.origin=v.origin+H.int(100)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xfbac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xfbc0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xfbd8，10号。
        return
    end
    P["BossCard9EtAtC2"]=B.part1
end

-- stage07boss.ecl：BossDead，0xfbf8；只编译Extra掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfbf8，40号。
        H.at(a,v,0)
        -- 源0xfc0c，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0xfc20，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0xfc38，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0xfc4c，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0xfc64，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0xfc7c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xfc90，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xfca4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xfcb4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xfccc，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xfd04，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xfd1c，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xfd54，367号。
        H.time_scale(a,0.5)
        H.at(a,v,60)
        -- 源0xfd68，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0xfd78，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0xfd88，345号。
        H.kill_all(a)
        H.at(a,v,60)
        -- 源0xfd98，367号。
        H.time_scale(a,0.25)
        H.at(a,v,60)
        -- 源0xfdac，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0xfdc0，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0xfdd4，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0xfdf0，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0xfe08，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0xfe20，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0xfe34，322号。
        H.flags(a,32,true)
        H.at(a,v,60)
        -- 源0xfe48，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,60)
        -- 源0xfe60，42号。
        H.push(v,40)
        H.at(a,v,60)
        -- 源0xfe74，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xfe88，12号。
        v.origin=H.clock(a)-(61);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,61)
        -- 源0xfea0，322号。
        H.flags(a,32,true)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,61)
        -- 源0xfeb4，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,61)
        -- 源0xfec8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,61)
        -- 源0xfee0，367号。
        H.time_scale(a,1.0)
        H.at(a,v,61)
        -- 源0xfef4，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

return P
