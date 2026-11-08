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

-- stage06.ecl：BPhantom00，0x294；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x294，40号。
        H.at(a,v,0)
        -- 源0x2a8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x2bc，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x2d0，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x2e8，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",98,1)
        H.at(a,v,0)
        -- 源0x318，1号。
        H.erase(a);return
    end
    P["BPhantom00"]=B.part1
end

-- stage06.ecl：BPhantom01，0x338；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x338，40号。
        H.at(a,v,0)
        -- 源0x34c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x360，259号。
        H.anm_slot(a,1,45)
        H.at(a,v,0)
        -- 源0x378，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",98,1)
        H.at(a,v,0)
        -- 源0x3a8，1号。
        H.erase(a);return
    end
    P["BPhantom01"]=B.part1
end

-- stage06.ecl：Crow00，0x3c8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3c8，40号。
        H.at(a,v,0)
        -- 源0x3dc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3f0，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x408，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x41c，262号。
        H.anm_main(a,0,12)
        H.at(a,v,0)
        -- 源0x434，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x44c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x464，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x478，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x48c，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x4a0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4c0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x4d4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4e8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x4fc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x50c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x51c，284号。
        H.velocity(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x534，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x548，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x55c，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x570，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x580，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x590，285号。
        H.velocity_time(a,0,60,0,-999999.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x5b0，15号。
        H.async(a,P["Crow00_at"],"Crow00_at",nil)
        H.at(a,v,600)
        -- 源0x5d0，0号。
        H.at(a,v,600)
        -- 源0x5e0，12号。
        v.origin=H.clock(a)-(600);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,600)
        -- 源0x5f8，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,600)
        -- 源0x60c，42号。
        H.push(v,1)
        H.at(a,v,600)
        -- 源0x620，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(600);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,600)
        -- 源0x638，1号。
        H.erase(a);return
    end
    P["Crow00"]=B.part1
end

-- stage06.ecl：Crow00_at，0x658；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x658，40号。
        H.at(a,v,0)
        -- 源0x66c，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x680，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x698，402号。
        H.gun_sprite(a,0,1,6)
        H.at(a,v,0)
        -- 源0x6b4，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,2,3,4)
        H.at(a,v,0)
        -- 源0x6e8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x704，435号。
        H.gun_speed_diff(a,0,2.0,3.0,4.0,5.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x738，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x768，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x77c，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x790，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x7a0，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x7b4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7cc，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x7e0，368号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x800，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x814，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x82c，10号。
        return
    end
    P["Crow00_at"]=B.part1
end

-- stage06.ecl：Crow01，0x84c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x84c，40号。
        H.at(a,v,0)
        -- 源0x860，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x874，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x88c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x8a0，262号。
        H.anm_main(a,0,12)
        H.at(a,v,0)
        -- 源0x8b8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x8d0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x8e8，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8f8，327号。
        H.drop_extra(a,3,2)
        H.at(a,v,0)
        -- 源0x910，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0x928，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x940，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x954，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x968，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x97c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x98c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x99c，284号。
        H.velocity(a,0,H.read(a,v,-1),4.0)
        H.at(a,v,0)
        -- 源0x9b4，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x9c8，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x9dc，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x9f0，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xa00，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xa10，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xa24，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0xa44，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0xa58，15号。
        H.async(a,P["Crow01_at"],"Crow01_at",nil)
        H.at(a,v,0)
        -- 源0xa78，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0xa8c，285号。
        H.velocity_time(a,0,60,0,-999999.0,4.0)
        H.at(a,v,600)
        -- 源0xaac，0号。
        H.at(a,v,600)
        -- 源0xabc，12号。
        v.origin=H.clock(a)-(600);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,600)
        -- 源0xad4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,600)
        -- 源0xae8，42号。
        H.push(v,1)
        H.at(a,v,600)
        -- 源0xafc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(600);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,600)
        -- 源0xb14，1号。
        H.erase(a);return
    end
    P["Crow01"]=B.part1
end

-- stage06.ecl：Crow01_at，0xb34；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb34，40号。
        H.at(a,v,0)
        -- 源0xb48，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xb5c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xb74，402号。
        H.gun_sprite(a,0,4,6)
        H.at(a,v,0)
        -- 源0xb90，436号。
        H.gun_count_diff(a,0,5,5,5,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0xbc4，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0xbe0，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0xc14，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xc44，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xc5c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xc70，368号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xc90，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xca4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xcbc，10号。
        return
    end
    P["Crow01_at"]=B.part1
end

-- stage06.ecl：Crow02，0xcdc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xcdc，40号。
        H.at(a,v,0)
        -- 源0xcf0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0xd04，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0xd1c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xd30，262号。
        H.anm_main(a,0,12)
        H.at(a,v,0)
        -- 源0xd48，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0xd60，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0xd78，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xd88，327号。
        H.drop_extra(a,3,8)
        H.at(a,v,0)
        -- 源0xda0，327号。
        H.drop_extra(a,2,5)
        H.at(a,v,0)
        -- 源0xdb8，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xdd0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xde4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xdf8，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0xe0c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xe1c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xe2c，284号。
        H.velocity(a,0,H.read(a,v,-1),4.0)
        H.at(a,v,0)
        -- 源0xe44，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0xe58，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0xe6c，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0xe80，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0xe90，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0xea0，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0xeb4，285号。
        H.velocity_time(a,0,50,0,-999999.0,0.0)
        H.at(a,v,0)
        -- 源0xed4，83号。
        v.origin=v.origin+H.int(50)
        H.at(a,v,0)
        -- 源0xee8，15号。
        H.async(a,P["Crow02_at"],"Crow02_at",nil)
        H.at(a,v,0)
        -- 源0xf08，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0xf1c，285号。
        H.velocity_time(a,0,60,0,-999999.0,4.0)
        H.at(a,v,600)
        -- 源0xf3c，0号。
        H.at(a,v,600)
        -- 源0xf4c，12号。
        v.origin=H.clock(a)-(600);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,600)
        -- 源0xf64，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,600)
        -- 源0xf78，42号。
        H.push(v,1)
        H.at(a,v,600)
        -- 源0xf8c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(600);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,600)
        -- 源0xfa4，1号。
        H.erase(a);return
    end
    P["Crow02"]=B.part1
end

-- stage06.ecl：Crow02_at，0xfc4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xfc4，40号。
        H.at(a,v,0)
        -- 源0xfd8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xfec，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1004，402号。
        H.gun_sprite(a,0,4,6)
        H.at(a,v,0)
        -- 源0x1020，436号。
        H.gun_count_diff(a,0,5,5,5,5,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1054，404号。
        H.gun_angle(a,0,1.5707963705062866,0.0)
        H.at(a,v,0)
        -- 源0x1070，435号。
        H.gun_speed_diff(a,0,3.0,3.0,4.0,5.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x10a4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x10d4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x10ec，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1100，368号。
        v.origin=v.origin+H.int(4)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1120，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1134，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x114c，10号。
        return
    end
    P["Crow02_at"]=B.part1
end

-- stage06.ecl：Crow03，0x116c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x116c，40号。
        H.at(a,v,0)
        -- 源0x1180，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1194，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x11ac，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x11c0，262号。
        H.anm_main(a,0,12)
        H.at(a,v,0)
        -- 源0x11d8，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x11f0，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x1208，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x121c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1230，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1244，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1254，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1264，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x1278，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x128c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x12a0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x12b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x12c0，284号。
        H.velocity(a,0,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x12d8，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x12ec，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x1300，44号。
        H.push(v,2.0)
        H.at(a,v,0)
        -- 源0x1314，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1324，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1334，285号。
        H.velocity_time(a,0,60,0,-999999.0,H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1354，15号。
        H.async(a,P["Crow03_at"],"Crow03_at",nil)
        H.at(a,v,600)
        -- 源0x1374，0号。
        H.at(a,v,600)
        -- 源0x1384，12号。
        v.origin=H.clock(a)-(600);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,600)
        -- 源0x139c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,600)
        -- 源0x13b0，42号。
        H.push(v,1)
        H.at(a,v,600)
        -- 源0x13c4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(600);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,600)
        -- 源0x13dc，1号。
        H.erase(a);return
    end
    P["Crow03"]=B.part1
end

-- stage06.ecl：Crow03_at，0x13fc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x13fc，40号。
        H.at(a,v,0)
        -- 源0x1410，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1424，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x143c，402号。
        H.gun_sprite(a,0,12,3)
        H.at(a,v,0)
        -- 源0x1458，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0x1474，404号。
        H.gun_angle(a,0,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x1490，405号。
        H.gun_speed(a,0,0.10000000149011612,1.5)
        H.at(a,v,0)
        -- 源0x14ac，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x14dc，409号。
        H.gun_transform(a,0,1,0,4,120,-999999,0.03333333507180214,1.5707963705062866)
        H.at(a,v,0)
        -- 源0x150c，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x1520，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0x1534，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x1544，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x1558，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1570，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1584，368号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x15a4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x15b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x15d0，10号。
        return
    end
    P["Crow03_at"]=B.part1
end

-- stage06.ecl：GPhantom00，0x15f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x15f0，40号。
        H.at(a,v,0)
        -- 源0x1604，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x1618，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x162c，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x1644，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",96,1)
        H.at(a,v,0)
        -- 源0x1674，1号。
        H.erase(a);return
    end
    P["GPhantom00"]=B.part1
end

-- stage06.ecl：GPhantom01，0x1694；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1694，40号。
        H.at(a,v,0)
        -- 源0x16a8，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x16bc，259号。
        H.anm_slot(a,1,47)
        H.at(a,v,0)
        -- 源0x16d4，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",96,1)
        H.at(a,v,0)
        -- 源0x1704，1号。
        H.erase(a);return
    end
    P["GPhantom01"]=B.part1
end

-- stage06.ecl：MainBossDebug，0x1724；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1724，40号。
        H.at(a,v,60)
        -- 源0x1738，338号。
        H.dialog(a,-1)
        H.at(a,v,60)
        -- 源0x174c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x175c，257号。
        H.spawn(a,257,"Boss",216.0,64.0,40,1000,1)
        H.at(a,v,60)
        -- 源0x178c，500号。
        H.debug_entry(a,100)
        H.at(a,v,60)
        -- 源0x17a0，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x17b0，340号。
        H.boss_wait(a,v)
        H.at(a,v,120)
        -- 源0x17c0，338号。
        H.dialog(a,1)
        H.at(a,v,120)
        -- 源0x17d4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,120)
        -- 源0x17e4，10号。
        return
    end
    P["MainBossDebug"]=B.part1
end

-- stage06.ecl：MainMBossDebug，0x1814；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1814，40号。
        H.at(a,v,0)
        -- 源0x1828，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0x183c，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x1850，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x1880，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1898，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x18ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x18c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x18d8，10号。
        return
    end
    P["MainMBossDebug"]=B.part1
end

-- stage06.ecl：MainMsgDebug，0x18f8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x18f8，40号。
        H.at(a,v,0)
        -- 源0x190c，500号。
        H.debug_entry(a,100)
        H.at(a,v,120)
        -- 源0x1920，338号。
        H.dialog(a,0)
        H.at(a,v,120)
        -- 源0x1934，339号。
        H.dialog_wait(a,v)
        H.at(a,v,121)
        -- 源0x1944，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x1954，338号。
        H.dialog(a,1)
        H.at(a,v,181)
        -- 源0x1968，339号。
        H.dialog_wait(a,v)
        H.at(a,v,181)
        -- 源0x1978，12号。
        v.origin=H.clock(a)-(4181);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,4181)
        -- 源0x1990，0号。
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,4181)
        -- 源0x19a0，42号。
        H.push(v,1)
        H.at(a,v,4181)
        -- 源0x19b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(181);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,4181)
        -- 源0x19cc，10号。
        return
    end
    P["MainMsgDebug"]=B.part1
end

-- stage06.ecl：MainSub00，0x19ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x19ec，40号。
        H.at(a,v,0)
        -- 源0x1a00，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1a14，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1a28，15号。
        H.async(a,P["MainSub00b"],"MainSub00b",nil)
        H.at(a,v,0)
        -- 源0x1a48，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1a60，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1a74，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1a88，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1a9c，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x1aac，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1abc，256号。
        H.spawn(a,256,"Crow00",-224.0,H.read(a,v,-1),50,1000,1)
        H.at(a,v,0)
        -- 源0x1aec，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1b00，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1b14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1b2c，10号。
        return
    end
    P["MainSub00"]=B.part1
end

-- stage06.ecl：MainSub00b，0x1b4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1b4c，40号。
        H.at(a,v,0)
        -- 源0x1b60，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x1b74，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1b88，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ba0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1bb4，42号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0x1bc8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x1bdc，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0x1bec，50号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left+right)) end
        H.at(a,v,0)
        -- 源0x1bfc，260号。
        H.spawn(a,260,"Crow00",224.0,H.read(a,v,-1),50,1000,1)
        H.at(a,v,0)
        -- 源0x1c2c，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1c40，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1c54，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1c6c，10号。
        return
    end
    P["MainSub00b"]=B.part1
end

-- stage06.ecl：MainSub01，0x1c8c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1c8c，40号。
        H.at(a,v,0)
        -- 源0x1ca0，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1cb4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1cc8，15号。
        H.async(a,P["MainSub01b"],"MainSub01b",nil)
        H.at(a,v,0)
        -- 源0x1ce8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1d00，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x1d14，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1d28，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1d3c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1d4c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1d5c，256号。
        H.spawn(a,256,"Crow01",-224.0,H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x1d8c，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1da0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1db4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1dcc，10号。
        return
    end
    P["MainSub01"]=B.part1
end

-- stage06.ecl：MainSub01b，0x1dec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1dec，40号。
        H.at(a,v,0)
        -- 源0x1e00，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0x1e14，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e28，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1e40，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x1e54，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x1e68，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x1e7c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x1e8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1e9c，260号。
        H.spawn(a,260,"Crow01",224.0,H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x1ecc，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1ee0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x1ef4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1f0c，10号。
        return
    end
    P["MainSub01b"]=B.part1
end

-- stage06.ecl：MainSub02，0x1f2c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1f2c，40号。
        H.at(a,v,0)
        -- 源0x1f40，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x1f54，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f68，15号。
        H.async(a,P["MainSub02b"],"MainSub02b",nil)
        H.at(a,v,0)
        -- 源0x1f88，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1fa0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x1fb4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1fc8，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x1fdc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1ff0，256号。
        H.spawn(a,256,"BPhantom00",224.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x2024，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2038，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x204c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2064，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x2078，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x208c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x20a0，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x20b8，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x20cc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x20e0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x20f4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2108，256号。
        H.spawn(a,256,"BPhantom00",64.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x213c，83号。
        v.origin=v.origin+H.int(20)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2150，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2164，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x217c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x2190，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x21a4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x21b8，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x21d0，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x21e4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x21f8，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x220c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2220，256号。
        H.spawn(a,256,"BPhantom00",-224.0,128.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2254，83号。
        v.origin=v.origin+H.int(20)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x2268，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x227c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x2294，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x22a8，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x22bc，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x22d0，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x22e8，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x22fc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2310，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2324，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2338，256号。
        H.spawn(a,256,"BPhantom00",-64.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x236c，83号。
        v.origin=v.origin+H.int(20)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x2380，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2394，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x23ac，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x23c0，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x23d4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x23e8，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x2400，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2414，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2428，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x243c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2450，256号。
        H.spawn(a,256,"BPhantom00",224.0,128.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2484，83号。
        v.origin=v.origin+H.int(20)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x2498，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x24ac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x24c4，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x24d8，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x24ec，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x2504，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2518，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x252c，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2540，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2554，256号。
        H.spawn(a,256,"BPhantom00",64.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2588，83号。
        v.origin=v.origin+H.int(20)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x259c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x25b0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x25c8，10号。
        return
    end
    P["MainSub02"]=B.part1
end

-- stage06.ecl：MainSub02b，0x25e8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x25e8，40号。
        H.at(a,v,0)
        -- 源0x25fc，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x2610，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2624，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x2638，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x264c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2660，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2678，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x268c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x26a0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x26b4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x26c8，256号。
        H.spawn(a,256,"BPhantom00",-224.0,128.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x26fc，83号。
        v.origin=v.origin+H.int(20)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2710，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2724，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x273c，83号。
        v.origin=v.origin+H.int(240)
        H.at(a,v,0)
        -- 源0x2750，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x2764，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2778，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2790，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x27a4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x27b8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x27cc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x27e0，256号。
        H.spawn(a,256,"BPhantom00",-64.0,-32.0,100,1000,2)
        H.at(a,v,0)
        -- 源0x2814，83号。
        v.origin=v.origin+H.int(20)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x2828，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x283c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x2854，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2868，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x287c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2890，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x28a8，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x28bc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x28d0，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x28e4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x28f8，256号。
        H.spawn(a,256,"BPhantom00",224.0,128.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x292c，83号。
        v.origin=v.origin+H.int(20)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x2940，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2954，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x296c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x2980，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x2994，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x29a8，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x29c0，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x29d4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x29e8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x29fc，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2a10，256号。
        H.spawn(a,256,"BPhantom00",64.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2a44，83号。
        v.origin=v.origin+H.int(20)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x2a58，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2a6c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x2a84，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x2a98，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2aac，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x2ac4，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x2ad8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2aec，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x2b00，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2b14，256号。
        H.spawn(a,256,"BPhantom00",-224.0,128.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2b48，83号。
        v.origin=v.origin+H.int(20)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x2b5c，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2b70，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x2b88，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x2b9c，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2bb0，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x2bc8，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0x2bdc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2bf0，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x2c04，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2c18，256号。
        H.spawn(a,256,"BPhantom00",-64.0,-32.0,50,1000,2)
        H.at(a,v,0)
        -- 源0x2c4c，83号。
        v.origin=v.origin+H.int(20)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x2c60，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2c74，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x2c8c，10号。
        return
    end
    P["MainSub02b"]=B.part1
end

-- stage06.ecl：MainSub03，0x2cac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2cac，40号。
        H.at(a,v,0)
        -- 源0x2cc0，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2cd4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2ce8，15号。
        H.async(a,P["MainSub03b"],"MainSub03b",nil)
        H.at(a,v,0)
        -- 源0x2d08，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2d20，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2d34，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2d48，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2d5c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2d6c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2d7c，265号。
        H.spawn(a,265,"Crow02",-224.0,H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x2dac，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2dc0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2dd4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2dec，10号。
        return
    end
    P["MainSub03"]=B.part1
end

-- stage06.ecl：MainSub03b，0x2e0c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2e0c，40号。
        H.at(a,v,0)
        -- 源0x2e20，42号。
        H.push(v,10)
        H.at(a,v,0)
        -- 源0x2e34，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e48，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2e60，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x2e74，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2e88，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2e9c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x2eac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2ebc，267号。
        H.spawn(a,267,"Crow02",224.0,H.read(a,v,-1),200,1000,2)
        H.at(a,v,0)
        -- 源0x2eec，83号。
        v.origin=v.origin+H.int(40)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2f00，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x2f14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2f2c，10号。
        return
    end
    P["MainSub03b"]=B.part1
end

-- stage06.ecl：MainSub04，0x2f4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2f4c，40号。
        H.at(a,v,0)
        -- 源0x2f60，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x2f74，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2f88，15号。
        H.async(a,P["MainSub04b"],"MainSub04b",nil)
        H.at(a,v,0)
        -- 源0x2fa8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2fc0，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x2fd4，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x2fe8，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x2ffc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x300c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x301c，265号。
        H.spawn(a,265,"Crow03",-224.0,H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x304c，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3060，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x3074，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x308c，10号。
        return
    end
    P["MainSub04"]=B.part1
end

-- stage06.ecl：MainSub04b，0x30ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x30ac，40号。
        H.at(a,v,0)
        -- 源0x30c0，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x30d4，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x30e8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3100，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x3114，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x3128，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x313c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x314c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x315c，267号。
        H.spawn(a,267,"Crow03",224.0,H.read(a,v,-1),50,1000,2)
        H.at(a,v,0)
        -- 源0x318c，83号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x31a0，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0x31b4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x31cc，10号。
        return
    end
    P["MainSub04b"]=B.part1
end

-- stage06.ecl：MainSub05，0x31ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x31ec，40号。
        H.at(a,v,0)
        -- 源0x3200，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3214，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x3228，44号。
        H.push(v,0.006283000111579895)
        H.at(a,v,0)
        -- 源0x323c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3250，256号。
        H.spawn(a,256,"RPhantom01",0.0,-32.0,6000,1000,0)
        H.at(a,v,0)
        -- 源0x3284，83号。
        v.origin=v.origin+H.int(520)
        H.at(a,v,0)
        -- 源0x3298，44号。
        H.push(v,-0.01256600022315979)
        H.at(a,v,0)
        -- 源0x32ac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x32c0，256号。
        H.spawn(a,256,"RPhantom01",0.0,-32.0,6000,1000,0)
        H.at(a,v,0)
        -- 源0x32f4，83号。
        v.origin=v.origin+H.int(450)
        H.at(a,v,0)
        -- 源0x3308，10号。
        return
    end
    P["MainSub05"]=B.part1
end

-- stage06.ecl：MapleEnemy，0x3328；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3328，40号。
        H.at(a,v,0)
        -- 源0x333c，322号。
        H.flags(a,32,true)
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3350，264号。
        H.effect_abs(a,0,179)
        H.at(a,v,3)
        -- 源0x3368，12号。
        v.origin=H.clock(a)-(0);return B.part2(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,3)
        -- 源0x3380，1号。
        H.erase(a);return
    end
    P["MapleEnemy"]=B.part1
end

-- stage06.ecl：Phantom00，0x33a0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x33a0，40号。
        H.at(a,v,0)
        -- 源0x33b4，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x33c8，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x33e0，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x33f4，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x340c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x3424，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x3438，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x344c，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x3460，15号。
        H.async(a,P["Phantom00_at"],"Phantom00_at",nil)
        H.at(a,v,0)
        -- 源0x3484，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3498，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x34ac，286号。
        H.velocity(a,1,(v.l[8] or 0),1.5)
        H.at(a,v,0)
        -- 源0x34c4，300号。
        H.ellipse(a,0,H.read(a,v,-9980),0.02617993950843811,64.0,0.0,(v.l[8] or 0),0.0)
        H.at(a,v,0)
        -- 源0x34ec，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3504，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3518，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x352c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3544，10号。
        return
    end
    P["Phantom00"]=B.part1
end

-- stage06.ecl：Phantom00_at，0x3564；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3564，40号。
        H.at(a,v,0)
        -- 源0x3578，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x358c，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x35a4，402号。
        H.gun_sprite(a,0,1,4)
        H.at(a,v,0)
        -- 源0x35c0，436号。
        H.gun_count_diff(a,0,1,1,1,1,1,1,1,1)
        H.at(a,v,0)
        -- 源0x35f4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3610，435号。
        H.gun_speed_diff(a,0,3.5,4.0,4.5,5.0,1.7000000476837158,1.7000000476837158,1.7000000476837158,1.7000000476837158)
        H.at(a,v,0)
        -- 源0x3644，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3674，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x3688，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x369c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x36ac，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x36c0，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x36d8，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x36ec，42号。
        H.push(v,354)
        H.at(a,v,0)
        -- 源0x3700，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3710，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3728，401号。
        H.fire(a,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x373c，368号。
        v.origin=v.origin+H.int(18)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x375c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3770，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3788，10号。
        return
    end
    P["Phantom00_at"]=B.part1
end

-- stage06.ecl：Phantom01，0x37a8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x37a8，40号。
        H.at(a,v,0)
        -- 源0x37bc，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x37d0，259号。
        H.anm_slot(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x37e8，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x37fc，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x380c，327号。
        H.drop_extra(a,1,20)
        H.at(a,v,0)
        -- 源0x3824，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x383c，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3854，320号。
        H.hurtbox(a,24.0,24.0)
        H.at(a,v,0)
        -- 源0x386c，321号。
        H.hitbox(a,16.0,16.0)
        H.at(a,v,0)
        -- 源0x3884，83号。
        v.origin=v.origin+H.int(12)
        H.at(a,v,0)
        -- 源0x3898，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x38ac，323号。
        H.flags(a,3,false)
        H.at(a,v,0)
        -- 源0x38c0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x38d4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x38e8，284号。
        H.velocity(a,0,1.5707963705062866,3.0)
        H.at(a,v,0)
        -- 源0x3900，285号。
        H.velocity_time(a,0,120,0,-999999.0,0.0)
        H.at(a,v,120)
        -- 源0x3920，15号。
        H.async(a,P["Phantom01_at"],"Phantom01_at",nil)
        H.at(a,v,720)
        -- 源0x3944，284号。
        H.velocity(a,0,-1.5707963705062866,0.0)
        H.at(a,v,720)
        -- 源0x395c，285号。
        H.velocity_time(a,0,200,0,-999999.0,2.0)
        H.at(a,v,720)
        -- 源0x397c，21号。
        H.stop_threads(a)
        H.at(a,v,720)
        -- 源0x398c，12号。
        v.origin=H.clock(a)-(720);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,720)
        -- 源0x39a4，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,720)
        -- 源0x39b8，42号。
        H.push(v,1)
        H.at(a,v,720)
        -- 源0x39cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(720);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,720)
        -- 源0x39e4，10号。
        return
    end
    P["Phantom01"]=B.part1
end

-- stage06.ecl：Phantom01_at，0x3a04；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3a04，40号。
        H.at(a,v,0)
        -- 源0x3a18，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x3a2c，407号。
        H.gun_aim(a,0,5)
        H.at(a,v,0)
        -- 源0x3a44，402号。
        H.gun_sprite(a,0,3,3)
        H.at(a,v,0)
        -- 源0x3a60，436号。
        H.gun_count_diff(a,0,3,6,6,9,1,1,1,1)
        H.at(a,v,0)
        -- 源0x3a94，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3ab0，435号。
        H.gun_speed_diff(a,0,1.7999999523162842,2.0,3.0,3.0,1.7000000476837158,1.7000000476837158,1.7000000476837158,1.7000000476837158)
        H.at(a,v,0)
        -- 源0x3ae4，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3b14，42号。
        H.push(v,H.read(a,v,-10000))
        H.at(a,v,0)
        -- 源0x3b28，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0x3b3c，58号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(math.fmod(left,right))) end
        H.at(a,v,0)
        -- 源0x3b4c，83号。
        v.origin=v.origin+H.int(H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x3b60，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,0)
        -- 源0x3b74，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3b88，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,0)
        -- 源0x3b9c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3bb0，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3bc4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3bd8，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3bf0，438号。
        H.gun_distance(a,0,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3c08，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0x3c24，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x3c38，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3c4c，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3c60，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3c70，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3c84，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x3c98，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x3cac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3cbc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3cd0，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3ce4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x3cf8，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x3d08，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x3d20，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x3d34，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3d48，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x3d58，45号。
        v.l[8]=H.f32(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3d6c，82号。
        v.l[0]=H.f32(H.angle((v.l[0] or 0)))
        H.at(a,v,0)
        -- 源0x3d80，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x3d94，83号。
        v.origin=v.origin+H.int(2)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x3da8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3dbc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x3dd4，10号。
        return
    end
    P["Phantom01_at"]=B.part1
end

-- stage06.ecl：RPhantom00，0x3df4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3df4，40号。
        H.at(a,v,0)
        -- 源0x3e08，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3e1c，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x3e34，330号。
        H.drop_main(a,1)
        H.at(a,v,0)
        -- 源0x3e48，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",94,1)
        H.at(a,v,0)
        -- 源0x3e78，1号。
        H.erase(a);return
    end
    P["RPhantom00"]=B.part1
end

-- stage06.ecl：RPhantom01，0x3e98；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3e98，40号。
        H.at(a,v,0)
        -- 源0x3eac，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3ec0，259号。
        H.anm_slot(a,1,46)
        H.at(a,v,0)
        -- 源0x3ed8，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",94,1)
        H.at(a,v,0)
        -- 源0x3f08，1号。
        H.erase(a);return
    end
    P["RPhantom01"]=B.part1
end

-- stage06.ecl：YPhantom00，0x3f28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3f28，40号。
        H.at(a,v,0)
        -- 源0x3f3c，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3f50，330号。
        H.drop_main(a,2)
        H.at(a,v,0)
        -- 源0x3f64，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x3f7c，11号。
        H.call(a,v,P["Phantom00"],"Phantom00",100,1)
        H.at(a,v,0)
        -- 源0x3fac，1号。
        H.erase(a);return
    end
    P["YPhantom00"]=B.part1
end

-- stage06.ecl：YPhantom01，0x3fcc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3fcc，40号。
        H.at(a,v,0)
        -- 源0x3fe0，258号。
        H.select_anm(a,1)
        H.at(a,v,0)
        -- 源0x3ff4，259号。
        H.anm_slot(a,1,48)
        H.at(a,v,0)
        -- 源0x400c，11号。
        H.call(a,v,P["Phantom01"],"Phantom01",100,1)
        H.at(a,v,0)
        -- 源0x403c，1号。
        H.erase(a);return
    end
    P["YPhantom01"]=B.part1
end

-- stage06.ecl：main，0x405c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x405c，40号。
        H.at(a,v,0)
        -- 源0x4070，322号。
        H.flags(a,32,true)
        H.at(a,v,0)
        -- 源0x4084，257号。
        H.spawn(a,257,"MapleEnemy",0.0,-16.0,20,1000,2)
        H.at(a,v,0)
        -- 源0x40b8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x40cc，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x40e0，11号。
        H.call(a,v,P["MainSub00"],"MainSub00")
        H.at(a,v,0)
        -- 源0x4100，83号。
        v.origin=v.origin+H.int(280)
        H.at(a,v,0)
        -- 源0x4114，11号。
        H.call(a,v,P["MainSub01"],"MainSub01")
        H.at(a,v,0)
        -- 源0x4134，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x4148，11号。
        H.call(a,v,P["MainSub02"],"MainSub02")
        H.at(a,v,0)
        -- 源0x4168，83号。
        v.origin=v.origin+H.int(210)
        H.at(a,v,0)
        -- 源0x417c，336号。
        H.sound(a,53)
        H.at(a,v,0)
        -- 源0x4190，338号。
        H.dialog(a,2)
        H.at(a,v,0)
        -- 源0x41a4，257号。
        H.spawn(a,257,"MBoss",192.0,-32.0,40,10000,1)
        H.at(a,v,0)
        -- 源0x41d4，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x41e4，83号。
        v.origin=v.origin+H.int(1000)
        H.at(a,v,0)
        -- 源0x41f8，11号。
        H.call(a,v,P["MainSub03"],"MainSub03")
        H.at(a,v,0)
        -- 源0x4218，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x422c，11号。
        H.call(a,v,P["MainSub04"],"MainSub04")
        H.at(a,v,0)
        -- 源0x424c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x4260，11号。
        H.call(a,v,P["MainSub05"],"MainSub05")
        H.at(a,v,0)
        -- 源0x4280，83号。
        v.origin=v.origin+H.int(360)
        H.at(a,v,0)
        -- 源0x4294，338号。
        H.dialog(a,0)
        H.at(a,v,0)
        -- 源0x42a8，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x42b8，257号。
        H.spawn(a,257,"Boss",-216.0,64.0,40,1000,1)
        H.at(a,v,0)
        -- 源0x42e8，340号。
        H.boss_wait(a,v)
        H.at(a,v,0)
        -- 源0x42f8，338号。
        H.dialog(a,1)
        H.at(a,v,0)
        -- 源0x430c，339号。
        H.dialog_wait(a,v)
        H.at(a,v,0)
        -- 源0x431c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4334，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4348，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x435c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,40000)
        -- 源0x4374，0号。
        H.at(a,v,40000)
        -- 源0x4384，1号。
        H.erase(a);return
    end
    P["main"]=B.part1
end

-- stage06mboss.ecl：MBoss，0x80；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x80，40号。
        H.at(a,v,0)
        -- 源0x94，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0xa8，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0xbc，259号。
        H.anm_slot(a,2,170)
        H.at(a,v,0)
        -- 源0xd4，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0xe8，262号。
        H.anm_main(a,0,7)
        H.at(a,v,0)
        -- 源0x100，322号。
        H.flags(a,64,true)
        H.at(a,v,0)
        -- 源0x114，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x12c，321号。
        H.hitbox(a,40.0,40.0)
        H.at(a,v,0)
        -- 源0x144，331号。
        H.life(a,2000)
        H.at(a,v,0)
        -- 源0x158，347号。
        H.life_marker(a,0,2000.0,-24448)
        H.at(a,v,0)
        -- 源0x174，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x188，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x19c，344号。
        a.chapter=6
        H.at(a,v,0)
        -- 源0x1b0，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x1d0，83号。
        v.origin=v.origin+H.int(70)
        H.at(a,v,0)
        -- 源0x1e4，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x1f8，259号。
        H.anm_slot(a,0,35)
        H.at(a,v,60)
        -- 源0x210，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x220，262号。
        H.anm_main(a,0,27)
        H.at(a,v,60)
        -- 源0x238，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,60)
        -- 源0x258，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x26c，440号。
        H.fog(a,160.0,8421376)
        H.at(a,v,60)
        -- 源0x284，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x298，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x2b0，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x2c4，11号。
        H.call(a,v,P["MBossCard1"],"MBossCard1")
        H.at(a,v,60)
        -- 源0x2e4，12号。
        v.origin=H.clock(a)-(60);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,60)
        -- 源0x2fc，83号。
        v.origin=v.origin+H.int(1000)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,60)
        -- 源0x310，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x324，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0x33c，1号。
        H.erase(a);return
    end
    P["MBoss"]=B.part1
end

-- stage06mboss.ecl：MBossCard1，0x35c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x35c，40号。
        H.at(a,v,0)
        -- 源0x370，334号。
        H.interrupt(a,0,0,2220,"Boss2")
        H.at(a,v,0)
        -- 源0x398，357号。
        H.spell(a,138,2220,0,"妖怪「火焔の車輪」",357)
        H.at(a,v,0)
        -- 源0x3cc，344号。
        a.chapter=15
        H.at(a,v,0)
        -- 源0x3e0，331号。
        H.life(a,2000)
        H.at(a,v,0)
        -- 源0x3f4，347号。
        H.life_marker(a,0,2000.0,-24448)
        H.at(a,v,0)
        -- 源0x410，334号。
        H.interrupt(a,0,0,2220,"MBossDead")
        H.at(a,v,0)
        -- 源0x43c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x44c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x460，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x494，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4a4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4b8，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4cc，325号。
        a.limit=nil
        H.at(a,v,30)
        -- 源0x4dc，263号。
        H.effect(a,0,131)
        H.at(a,v,90)
        -- 源0x4f4，0号。
        H.at(a,v,90)
        -- 源0x504，322号。
        H.flags(a,12,true)
        H.at(a,v,90)
        -- 源0x518，42号。
        H.push(v,50)
        H.at(a,v,90)
        -- 源0x52c，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,90)
        -- 源0x540，12号。
        v.origin=H.clock(a)-(90);return B.part4(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,90)
        -- 源0x558，44号。
        H.push(v,0.026179999113082886)
        H.at(a,v,90)
        -- 源0x56c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,90)
        -- 源0x580，44号。
        H.push(v,0.0065449997782707214)
        H.at(a,v,90)
        -- 源0x594，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,90)
        -- 源0x5a8，42号。
        H.push(v,25)
        H.at(a,v,90)
        -- 源0x5bc，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x5d0，42号。
        H.push(v,0)
        H.at(a,v,90)
        -- 源0x5e4，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x5f8，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil)
        H.at(a,v,90)
        -- 源0x61c，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x630，44号。
        H.push(v,-0.026179999113082886)
        H.at(a,v,90)
        -- 源0x644，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,90)
        -- 源0x658，44号。
        H.push(v,-0.0065449997782707214)
        H.at(a,v,90)
        -- 源0x66c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,90)
        -- 源0x680，42号。
        H.push(v,18)
        H.at(a,v,90)
        -- 源0x694，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x6a8，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x6bc，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,90)
        -- 源0x6d0，15号。
        H.async(a,P["MBossCard1_at"],"MBossCard1_at",nil)
        H.at(a,v,90)
        -- 源0x6f4，83号。
        v.origin=v.origin+H.int((v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x708，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x71c，42号。
        H.push(v,30)
        H.at(a,v,90)
        -- 源0x730，67号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,90)
        -- 源0x740，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(90);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,90)
        -- 源0x758，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,90)
        -- 源0x76c，42号。
        H.push(v,4)
        H.at(a,v,90)
        -- 源0x780，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,90)
        -- 源0x790，43号。
        v.l[16]=H.int(H.pop(v))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,90)
        -- 源0x7a4，42号。
        H.push(v,1)
        H.at(a,v,90)
        -- 源0x7b8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(90);return B.part2(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,90)
        -- 源0x7d0，10号。
        return
    end
    P["MBossCard1"]=B.part1
end

-- stage06mboss.ecl：MBossCard1_at，0x7f0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7f0，40号。
        H.at(a,v,0)
        -- 源0x804，400号。
        H.gun_new(a,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x818，407号。
        H.gun_aim(a,H.read(a,v,-9984),3)
        H.at(a,v,0)
        -- 源0x830，402号。
        H.gun_sprite(a,H.read(a,v,-9984),H.read(a,v,-9985),0)
        H.at(a,v,0)
        -- 源0x84c，436号。
        H.gun_count_diff(a,H.read(a,v,-9984),12,24,26,28,1,1,1,1)
        H.at(a,v,0)
        -- 源0x880，404号。
        H.gun_angle(a,H.read(a,v,-9984),0.0,0.0)
        H.at(a,v,0)
        -- 源0x89c，435号。
        H.gun_speed_diff(a,H.read(a,v,-9984),1.75,1.75,1.75,1.75,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x8d0，409号。
        H.gun_transform(a,H.read(a,v,-9984),0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x900，409号。
        H.gun_transform(a,H.read(a,v,-9984),2,0,4,60,-999999,0.01666666753590107,-999999.0)
        H.at(a,v,0)
        -- 源0x930，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x944，43号。
        v.l[12]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x958，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x96c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x980，42号。
        H.push(v,100)
        H.at(a,v,0)
        -- 源0x994，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9a8，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x9bc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9d0，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x9e4，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9f8，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0xa0c，43号。
        v.l[20]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa20，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa38，409号。
        H.gun_transform(a,(v.l[20] or 0),1,0,4096,30,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa68，438号。
        H.gun_distance(a,(v.l[20] or 0),(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa80，404号。
        H.gun_angle(a,(v.l[20] or 0),(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0xa9c，401号。
        H.fire(a,(v.l[20] or 0))
        H.at(a,v,0)
        -- 源0xab0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xac4，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0xad8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xae8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xafc，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xb10，42号。
        H.push(v,7)
        H.at(a,v,0)
        -- 源0xb24，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0xb34，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xb48，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0xb5c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xb70，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0xb80，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xb94，83号。
        v.origin=v.origin+H.int(8)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xba8，78号。
        H.push(v,(v.l[12] or 0))
        v.l[12]=H.int((v.l[12] or 0)-1)
        H.at(a,v,0)
        -- 源0xbbc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xbd4，10号。
        return
    end
    P["MBossCard1_at"]=B.part1
end

-- stage06mboss.ecl：MBossDead，0xbf4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xbf4，40号。
        H.at(a,v,0)
        -- 源0xc08，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0xc1c，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0xc34，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0xc48，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0xc60，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0xc78，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xc8c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xca0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xcb0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xcc8，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xd00，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xd18，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,60)
        -- 源0xd50，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0xd60，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0xd70，345号。
        H.kill_all(a)
        H.at(a,v,60)
        -- 源0xd80，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0xd94，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,60)
        -- 源0xda8，42号。
        H.push(v,0)
        H.at(a,v,60)
        -- 源0xdbc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0xdcc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,60)
        -- 源0xde4，326号。
        H.drop_clear(a)
        H.at(a,v,60)
        -- 源0xdf4，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,60)
        -- 源0xe08，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xe1c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,60)
        -- 源0xe2c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(60);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,60)
        -- 源0xe44，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,60)
        -- 源0xe58，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0xe6c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,60)
        -- 源0xe80，327号。
        H.drop_extra(a,4,2)
        H.at(a,v,60)
        -- 源0xe98，327号。
        H.drop_extra(a,2,10)
        H.at(a,v,60)
        -- 源0xeb0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,60)
        -- 源0xec8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,60)
        -- 源0xed8，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0xef4，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0xf0c，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0xf24，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0xf38，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0xf4c，1号。
        H.erase(a);return
    end
    P["MBossDead"]=B.part1
end

-- stage06boss.ecl：Boss，0x334；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x334，40号。
        H.at(a,v,0)
        -- 源0x348，332号。
        H.boss_slot(a,0)
        H.at(a,v,0)
        -- 源0x35c，258号。
        H.select_anm(a,2)
        H.at(a,v,0)
        -- 源0x370，262号。
        H.anm_main(a,0,0)
        H.at(a,v,0)
        -- 源0x388，322号。
        H.flags(a,76,true)
        H.at(a,v,0)
        -- 源0x39c，320号。
        H.hurtbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3b4，321号。
        H.hitbox(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x3cc，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x3e0，331号。
        H.life(a,14000)
        H.at(a,v,0)
        -- 源0x3f4，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x414，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x428，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x43c，344号。
        a.chapter=24
        H.at(a,v,60)
        -- 源0x450，339号。
        H.dialog_wait(a,v)
        H.at(a,v,60)
        -- 源0x460，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x474，440号。
        H.fog(a,160.0,16776960)
        H.at(a,v,60)
        -- 源0x48c，324号。
        H.limit(a,0.0,128.0,280.0,96.0)
        H.at(a,v,60)
        -- 源0x4ac，331号。
        H.life(a,14000)
        H.at(a,v,60)
        -- 源0x4c0，258号。
        H.select_anm(a,0)
        H.at(a,v,60)
        -- 源0x4d4，259号。
        H.anm_slot(a,1,92)
        H.at(a,v,60)
        -- 源0x4ec，258号。
        H.select_anm(a,2)
        H.at(a,v,60)
        -- 源0x500，11号。
        H.call(a,v,P["Boss1"],"Boss1")
        H.at(a,v,60)
        -- 源0x51c，1号。
        H.erase(a);return
    end
    P["Boss"]=B.part1
end

-- stage06boss.ecl：Boss1，0x53c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x53c，40号。
        H.at(a,v,0)
        -- 源0x550，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x560，347号。
        H.life_marker(a,0,3000.0,-24448)
        H.at(a,v,0)
        -- 源0x57c，334号。
        H.interrupt(a,0,3000,3600,"BossCard1")
        H.at(a,v,0)
        -- 源0x5a8，344号。
        a.chapter=24
        H.at(a,v,0)
        -- 源0x5bc，360号。
        a.stars=4
        H.at(a,v,0)
        -- 源0x5d0，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,0)
        -- 源0x5f0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x608，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x61c，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x630，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x644，15号。
        H.async(a,P["Boss1At1"],"Boss1At1",nil)
        H.at(a,v,0)
        -- 源0x664，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,0)
        -- 源0x678，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,0)
        -- 源0x694，83号。
        v.origin=v.origin+H.int(60)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6a8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6bc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6d4，10号。
        return
    end
    P["Boss1"]=B.part1
end

-- stage06boss.ecl：Boss1At1，0x6f4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6f4，40号。
        H.at(a,v,0)
        -- 源0x708，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x71c，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x734，402号。
        H.gun_sprite(a,0,19,6)
        H.at(a,v,0)
        -- 源0x750，436号。
        H.gun_count_diff(a,0,24,32,40,56,1,1,1,1)
        H.at(a,v,0)
        -- 源0x784，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7a0，435号。
        H.gun_speed_diff(a,0,2.0,2.0,2.0,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x7d4，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x804，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x834，409号。
        H.gun_transform(a,0,2,0,4,60,-999999,0.13333334028720856,-999999.0)
        H.at(a,v,0)
        -- 源0x864，403号。
        H.gun_offset(a,0,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x880，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0x894，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8a8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x8bc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8d0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8e8，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x904，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x918，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x92c，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x940，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x950，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x964，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x978，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x98c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9a4，10号。
        return
    end
    P["Boss1At1"]=B.part1
end

-- stage06boss.ecl：Boss2，0x9c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9c4，40号。
        H.at(a,v,0)
        -- 源0x9d8，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x9e8，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x9f8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xa0c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa20，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa30，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa48，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0xa5c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa74，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa88，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0xa98，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0xaa8，331号。
        H.life(a,9400)
        H.at(a,v,0)
        -- 源0xabc，334号。
        H.interrupt(a,0,2400,4200,"BossCard2")
        H.at(a,v,0)
        -- 源0xae8，347号。
        H.life_marker(a,0,2400.0,-24448)
        H.at(a,v,0)
        -- 源0xb04，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0xb18，360号。
        a.stars=3
        H.at(a,v,0)
        -- 源0xb2c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xb40，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb54，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb64，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xb7c，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0xb90，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0xba0，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0xbb4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xbc8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xbd8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xbf0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xc04，327号。
        H.drop_extra(a,1,15)
        H.at(a,v,0)
        -- 源0xc1c，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0xc34，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0xc4c，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xc5c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xc70，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xc84，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0xc98，281号。
        H.position_time(a,0,60,4,-120.0,128.0)
        H.at(a,v,60)
        -- 源0xcb8，0号。
        H.at(a,v,60)
        -- 源0xcc8，325号。
        a.limit=nil
        H.at(a,v,60)
        -- 源0xcd8，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0xcf0，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0xd10，281号。
        H.position_time(a,0,160,1,320.0,128.0)
        H.at(a,v,60)
        -- 源0xd30，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0xd48，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0xd60，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0xd80，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0xd94，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0xdb4，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,60)
        -- 源0xdcc，281号。
        H.position_time(a,0,160,1,-320.0,128.0)
        H.at(a,v,60)
        -- 源0xdec，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0xe04，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0xe1c，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0xe3c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0xe50，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0xe70，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,60)
        -- 源0xe88，281号。
        H.position_time(a,0,160,1,320.0,128.0)
        H.at(a,v,60)
        -- 源0xea8，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0xec0，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0xed8，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0xef8，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0xf0c，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,60)
        -- 源0xf24，281号。
        H.position_time(a,0,120,9,0.0,128.0)
        H.at(a,v,60)
        -- 源0xf44，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0xf5c，286号。
        H.velocity(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0xf74，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0xf88，15号。
        H.async(a,P["Boss2At2"],"Boss2At2",nil)
        H.at(a,v,60)
        -- 源0xfa8，83号。
        v.origin=v.origin+H.int(180)
        H.at(a,v,60)
        -- 源0xfbc，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0xfdc，281号。
        H.position_time(a,0,160,1,-320.0,128.0)
        H.at(a,v,60)
        -- 源0xffc，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0x1014，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0x102c，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0x104c，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0x1060，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0x1080，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,60)
        -- 源0x1098，281号。
        H.position_time(a,0,160,1,320.0,128.0)
        H.at(a,v,60)
        -- 源0x10b8，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0x10d0，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0x10e8，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0x1108，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0x111c，15号。
        H.async(a,P["Boss2At1"],"Boss2At1",nil)
        H.at(a,v,60)
        -- 源0x113c，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,60)
        -- 源0x1154，281号。
        H.position_time(a,0,160,1,-320.0,128.0)
        H.at(a,v,60)
        -- 源0x1174，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0x118c，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,60)
        -- 源0x11a4，287号。
        H.velocity_time(a,1,160,4,-999999.0,-2.0)
        H.at(a,v,60)
        -- 源0x11c4，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,60)
        -- 源0x11d8，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,60)
        -- 源0x11f0，281号。
        H.position_time(a,0,120,9,0.0,128.0)
        H.at(a,v,60)
        -- 源0x1210，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0x1228，286号。
        H.velocity(a,1,0.0,0.0)
        H.at(a,v,60)
        -- 源0x1240，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,60)
        -- 源0x1254，15号。
        H.async(a,P["Boss2At2"],"Boss2At2",nil)
        H.at(a,v,60)
        -- 源0x1274，83号。
        v.origin=v.origin+H.int(180)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x1288，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x129c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x12b4，10号。
        return
    end
    P["Boss2"]=B.part1
end

-- stage06boss.ecl：Boss2At1，0x12d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x12d4，40号。
        H.at(a,v,0)
        -- 源0x12e8，355号。
        v.l[0]=H.int(28)
        H.at(a,v,0)
        -- 源0x130c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1324，44号。
        H.push(v,H.read(a,v,-9958))
        H.at(a,v,0)
        -- 源0x1338，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x134c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x1360，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x1370，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1380，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1394，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x13a8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x13b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x13c8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x13dc，256号。
        H.spawn(a,256,"Boss2At1b",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x1410，368号。
        v.origin=v.origin+H.int(5)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1430，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1444，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x145c，10号。
        return
    end
    P["Boss2At1"]=B.part1
end

-- stage06boss.ecl：Boss2At1b，0x147c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x147c，40号。
        H.at(a,v,0)
        -- 源0x1490，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x14a4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x14b8，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x14d0，402号。
        H.gun_sprite(a,0,19,2)
        H.at(a,v,0)
        -- 源0x14ec，406号。
        H.gun_count(a,0,2,1)
        H.at(a,v,0)
        -- 源0x1508，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1524，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x1540，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1570，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x158c，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x15a4，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x15b8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x15cc，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,0)
        -- 源0x15e0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x15f4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x160c，409号。
        H.gun_transform(a,0,1,0,4,80,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x163c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1650，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x1664，44号。
        H.push(v,0.006300000008195639)
        H.at(a,v,0)
        -- 源0x1678，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x1688，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x169c，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x16b0，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x16c4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x16dc，1号。
        H.erase(a);return
    end
    P["Boss2At1b"]=B.part1
end

-- stage06boss.ecl：Boss2At2，0x16fc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x16fc，40号。
        H.at(a,v,0)
        -- 源0x1710，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1724，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x173c，402号。
        H.gun_sprite(a,0,17,0)
        H.at(a,v,0)
        -- 源0x1758，406号。
        H.gun_count(a,0,16,1)
        H.at(a,v,0)
        -- 源0x1774，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1790，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x17ac，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x17dc，355号。
        v.l[0]=H.int(16)
        H.at(a,v,0)
        -- 源0x1800，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1818，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x182c，368号。
        v.origin=v.origin+H.int(10)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x184c，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x1860，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1878，10号。
        return
    end
    P["Boss2At2"]=B.part1
end

-- stage06boss.ecl：Boss3，0x1898；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1898，40号。
        H.at(a,v,0)
        -- 源0x18ac，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x18bc，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x18cc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x18e0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x18f4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1904，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x191c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x1930，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1948，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x195c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x196c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x197c，331号。
        H.life(a,14000)
        H.at(a,v,0)
        -- 源0x1990，334号。
        H.interrupt(a,0,3000,4200,"BossCard3")
        H.at(a,v,0)
        -- 源0x19bc，347号。
        H.life_marker(a,0,3000.0,-24448)
        H.at(a,v,0)
        -- 源0x19d8，344号。
        a.chapter=26
        H.at(a,v,0)
        -- 源0x19ec，360号。
        a.stars=2
        H.at(a,v,0)
        -- 源0x1a00，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x1a14，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x1a28，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1a38，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x1a50，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x1a64，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x1a74，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x1a88，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1a9c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x1aac，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x1ac4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x1ad8，327号。
        H.drop_extra(a,1,15)
        H.at(a,v,0)
        -- 源0x1af0，327号。
        H.drop_extra(a,2,15)
        H.at(a,v,0)
        -- 源0x1b08，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x1b20，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x1b30，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x1b44，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x1b58，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x1b6c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x1b8c，0号。
        H.at(a,v,60)
        -- 源0x1b9c，324号。
        H.limit(a,0.0,128.0,280.0,16.0)
        H.at(a,v,60)
        -- 源0x1bbc，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x1bd4，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x1be8，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x1bfc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x1c10，15号。
        H.async(a,P["Boss3At1"],"Boss3At1",nil)
        H.at(a,v,60)
        -- 源0x1c30，15号。
        H.async(a,P["Boss3At2"],"Boss3At2",nil)
        H.at(a,v,60)
        -- 源0x1c50，83号。
        v.origin=v.origin+H.int(160)
        H.at(a,v,60)
        -- 源0x1c64，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,60)
        -- 源0x1c80，83号。
        v.origin=v.origin+H.int(60)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x1c94，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x1ca8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x1cc0，10号。
        return
    end
    P["Boss3"]=B.part1
end

-- stage06boss.ecl：Boss3At1，0x1ce0；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1ce0，40号。
        H.at(a,v,0)
        -- 源0x1cf4，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x1d08，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x1d20，402号。
        H.gun_sprite(a,0,19,6)
        H.at(a,v,0)
        -- 源0x1d3c，436号。
        H.gun_count_diff(a,0,8,16,24,28,1,1,1,1)
        H.at(a,v,0)
        -- 源0x1d70，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x1d8c，435号。
        H.gun_speed_diff(a,0,2.0,2.0,2.0,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x1dc0，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1df0，409号。
        H.gun_transform(a,0,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x1e20，409号。
        H.gun_transform(a,0,2,0,8,60,-999999,0.10000000149011612,0.02617993950843811)
        H.at(a,v,0)
        -- 源0x1e50，403号。
        H.gun_offset(a,0,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x1e6c，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0x1e80，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x1e94，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x1ea8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1ebc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x1ed4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x1ee8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x1efc，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x1f10，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x1f20，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x1f34，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x1f48，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x1f5c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x1f70，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x1f88，10号。
        return
    end
    P["Boss3At1"]=B.part1
end

-- stage06boss.ecl：Boss3At2，0x1fa8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x1fa8，40号。
        H.at(a,v,0)
        -- 源0x1fbc，400号。
        H.gun_new(a,1)
        H.at(a,v,0)
        -- 源0x1fd0，407号。
        H.gun_aim(a,1,3)
        H.at(a,v,0)
        -- 源0x1fe8，402号。
        H.gun_sprite(a,1,19,6)
        H.at(a,v,0)
        -- 源0x2004，436号。
        H.gun_count_diff(a,1,8,16,24,28,1,1,1,1)
        H.at(a,v,0)
        -- 源0x2038，404号。
        H.gun_angle(a,1,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2054，435号。
        H.gun_speed_diff(a,1,2.0,2.0,2.0,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x2088，409号。
        H.gun_transform(a,1,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x20b8，409号。
        H.gun_transform(a,1,1,0,4096,40,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x20e8，409号。
        H.gun_transform(a,1,2,0,8,60,-999999,0.10000000149011612,-0.02617993950843811)
        H.at(a,v,0)
        -- 源0x2118，403号。
        H.gun_offset(a,1,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x2134，42号。
        H.push(v,48)
        H.at(a,v,0)
        -- 源0x2148，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x215c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2170，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2184，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x219c，401号。
        H.fire(a,1)
        H.at(a,v,0)
        -- 源0x21b0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x21c4，44号。
        H.push(v,32.0)
        H.at(a,v,0)
        -- 源0x21d8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x21e8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x21fc，82号。
        v.l[4]=H.f32(H.angle((v.l[4] or 0)))
        H.at(a,v,0)
        -- 源0x2210，83号。
        v.origin=v.origin+H.int(3)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2224，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x2238，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2250，10号。
        return
    end
    P["Boss3At2"]=B.part1
end

-- stage06boss.ecl：Boss4，0x2270；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2270，40号。
        H.at(a,v,0)
        -- 源0x2284，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x2294，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x22a4，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x22b8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x22cc，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x22dc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x22f4，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x2308，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2320，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2334，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x2344，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x2354，331号。
        H.life(a,10500)
        H.at(a,v,0)
        -- 源0x2368，334号。
        H.interrupt(a,0,3500,4200,"BossCard4")
        H.at(a,v,0)
        -- 源0x2394，347号。
        H.life_marker(a,0,3500.0,-24448)
        H.at(a,v,0)
        -- 源0x23b0，344号。
        a.chapter=25
        H.at(a,v,0)
        -- 源0x23c4，360号。
        a.stars=1
        H.at(a,v,0)
        -- 源0x23d8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x23ec，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x2400，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2410，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x2428，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x243c，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x244c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x2460，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x2474，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x2484，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x249c，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x24b0，327号。
        H.drop_extra(a,1,20)
        H.at(a,v,0)
        -- 源0x24c8，327号。
        H.drop_extra(a,2,20)
        H.at(a,v,0)
        -- 源0x24e0，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x24f8，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x2508，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x251c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2530，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x2544，281号。
        H.position_time(a,0,60,4,120.0,128.0)
        H.at(a,v,120)
        -- 源0x2564，0号。
        H.at(a,v,120)
        -- 源0x2574，325号。
        a.limit=nil
        H.at(a,v,120)
        -- 源0x2584，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x259c，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x25bc，281号。
        H.position_time(a,0,80,1,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x25dc，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x25f4，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x260c，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x262c，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x2640，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x2660，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x2678，281号。
        H.position_time(a,0,80,1,320.0,128.0)
        H.at(a,v,120)
        -- 源0x2698，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x26b0，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x26c8，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x26e8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x26fc，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x271c，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,120)
        -- 源0x2734，281号。
        H.position_time(a,0,80,1,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x2754，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x276c，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x2784，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x27a4，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x27b8，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x27d0，281号。
        H.position_time(a,0,60,9,0.0,128.0)
        H.at(a,v,120)
        -- 源0x27f0，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2808，286号。
        H.velocity(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2820，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x2834，15号。
        H.async(a,P["Boss4At2"],"Boss4At2",nil)
        H.at(a,v,120)
        -- 源0x2854，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,120)
        -- 源0x2868，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x2888，281号。
        H.position_time(a,0,80,1,320.0,128.0)
        H.at(a,v,120)
        -- 源0x28a8，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x28c0，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x28d8，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x28f8，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x290c，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x292c，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,120)
        -- 源0x2944，281号。
        H.position_time(a,0,80,1,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x2964，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x297c，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x2994，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x29b4，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x29c8，15号。
        H.async(a,P["Boss4At1"],"Boss4At1",nil)
        H.at(a,v,120)
        -- 源0x29e8，280号。
        H.position(a,0,-320.0,128.0)
        H.at(a,v,120)
        -- 源0x2a00，281号。
        H.position_time(a,0,80,1,320.0,128.0)
        H.at(a,v,120)
        -- 源0x2a20，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2a38，286号。
        H.velocity(a,1,1.5707963705062866,2.0)
        H.at(a,v,120)
        -- 源0x2a50，287号。
        H.velocity_time(a,1,80,4,-999999.0,-2.0)
        H.at(a,v,120)
        -- 源0x2a70，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,120)
        -- 源0x2a84，280号。
        H.position(a,0,320.0,128.0)
        H.at(a,v,120)
        -- 源0x2a9c，281号。
        H.position_time(a,0,60,9,0.0,128.0)
        H.at(a,v,120)
        -- 源0x2abc，282号。
        H.position(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2ad4，286号。
        H.velocity(a,1,0.0,0.0)
        H.at(a,v,120)
        -- 源0x2aec，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x2b00，15号。
        H.async(a,P["Boss4At2"],"Boss4At2",nil)
        H.at(a,v,120)
        -- 源0x2b20，83号。
        v.origin=v.origin+H.int(100)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x2b34，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x2b48，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x2b60，10号。
        return
    end
    P["Boss4"]=B.part1
end

-- stage06boss.ecl：Boss4At1，0x2b80；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2b80，40号。
        H.at(a,v,0)
        -- 源0x2b94，355号。
        v.l[0]=H.int(18)
        H.at(a,v,0)
        -- 源0x2bb8，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2bd0，44号。
        H.push(v,H.read(a,v,-9958))
        H.at(a,v,0)
        -- 源0x2be4，44号。
        H.push(v,3.1415927410125732)
        H.at(a,v,0)
        -- 源0x2bf8，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x2c0c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2c1c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2c2c，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x2c40，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x2c54，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x2c64，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x2c74，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x2c88，256号。
        H.spawn(a,256,"Boss4At1b",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x2cbc，368号。
        v.origin=v.origin+H.int(6)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2cdc，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x2cf0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2d08，10号。
        return
    end
    P["Boss4At1"]=B.part1
end

-- stage06boss.ecl：Boss4At1b，0x2d28；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2d28，40号。
        H.at(a,v,0)
        -- 源0x2d3c，322号。
        H.flags(a,288,true)
        H.at(a,v,0)
        -- 源0x2d50，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2d64，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x2d7c，402号。
        H.gun_sprite(a,0,19,3)
        H.at(a,v,0)
        -- 源0x2d98，406号。
        H.gun_count(a,0,2,1)
        H.at(a,v,0)
        -- 源0x2db4，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x2dd0，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x2dec，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x2e1c，404号。
        H.gun_angle(a,0,H.read(a,v,-9981),0.0)
        H.at(a,v,0)
        -- 源0x2e38，438号。
        H.gun_distance(a,0,32.0)
        H.at(a,v,0)
        -- 源0x2e50，42号。
        H.push(v,16)
        H.at(a,v,0)
        -- 源0x2e64，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x2e78，44号。
        H.push(v,0.10000000149011612)
        H.at(a,v,0)
        -- 源0x2e8c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2ea0，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x2eb8，409号。
        H.gun_transform(a,0,1,0,4,80,-999999,(v.l[4] or 0),-999999.0)
        H.at(a,v,0)
        -- 源0x2ee8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x2efc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x2f10，44号。
        H.push(v,0.006300000008195639)
        H.at(a,v,0)
        -- 源0x2f24，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x2f34，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x2f48，83号。
        v.origin=v.origin+H.int(2)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x2f5c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x2f70，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x2f88，1号。
        H.erase(a);return
    end
    P["Boss4At1b"]=B.part1
end

-- stage06boss.ecl：Boss4At2，0x2fa8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x2fa8，40号。
        H.at(a,v,0)
        -- 源0x2fbc，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x2fd0，407号。
        H.gun_aim(a,0,2)
        H.at(a,v,0)
        -- 源0x2fe8，402号。
        H.gun_sprite(a,0,17,3)
        H.at(a,v,0)
        -- 源0x3004，406号。
        H.gun_count(a,0,16,1)
        H.at(a,v,0)
        -- 源0x3020，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x303c，405号。
        H.gun_speed(a,0,3.0,1.5)
        H.at(a,v,0)
        -- 源0x3058，409号。
        H.gun_transform(a,0,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3088，355号。
        v.l[0]=H.int(12)
        H.at(a,v,0)
        -- 源0x30ac，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x30c4，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x30d8，368号。
        v.origin=v.origin+H.int(14)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x30f8，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x310c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x3124，10号。
        return
    end
    P["Boss4At2"]=B.part1
end

-- stage06boss.ecl：BossCard1，0x3144；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3144，40号。
        H.at(a,v,0)
        -- 源0x3158，346号。
        a.protect=0.0
        H.at(a,v,0)
        -- 源0x316c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x317c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x318c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x319c，443号。
        H.callback(a,443,0)
        H.at(a,v,0)
        -- 源0x31b0，365号。
        H.mark_effects(a)
        H.at(a,v,0)
        -- 源0x31c0，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x31d4，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x3208，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x321c，334号。
        H.interrupt(a,0,0,3600,"Boss2")
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x32d0，357号。
        H.spell(a,142,3600,500000,"核熱「核反応制御不能」",357)
        H.at(a,v,0)
        -- 源0x3308，344号。
        a.chapter=43
        H.at(a,v,0)
        -- 源0x331c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x332c，281号。
        H.position_time(a,0,60,4,0.0,160.0)
        H.at(a,v,0)
        -- 源0x334c，324号。
        H.limit(a,0.0,128.0,384.0,256.0)
        H.at(a,v,0)
        -- 源0x336c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x3380，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x3394，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x33a4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x33bc，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x33d0，329号。
        H.drop(a)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x33e0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x33f4，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x3408，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0x341c，264号。
        H.effect_abs(a,2,24)
        H.at(a,v,120)
        -- 源0x3434，0号。
        H.at(a,v,120)
        -- 源0x3444，12号。
        v.origin=H.clock(a)-(120);return B.part19(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,120)
        -- 源0x345c，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x3474，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x3488，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x349c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x34b0，263号。
        H.effect(a,0,176)
        H.at(a,v,120)
        -- 源0x34c8，336号。
        H.sound(a,54)
        H.at(a,v,120)
        -- 源0x34dc，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,120)
        -- 源0x34f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3504，42号。
        H.push(v,8)
        H.at(a,v,120)
        -- 源0x3518，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,120)
        -- 源0x352c，12号。
        v.origin=H.clock(a)-(120);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,120)
        -- 源0x3544，44号。
        H.push(v,1.0)
        H.at(a,v,120)
        -- 源0x3558，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,120)
        -- 源0x356c，44号。
        H.push(v,0.5)
        H.at(a,v,120)
        -- 源0x3580，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,120)
        -- 源0x3590，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x35a0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x35b4，256号。
        H.spawn(a,256,"BossCard1Bomb",0.0,-32.0,200,10,0)
        H.at(a,v,120)
        -- 源0x35ec，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0x3600，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,120)
        -- 源0x3614，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x3624，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,120)
        -- 源0x3638，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,120)
        -- 源0x364c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x3664，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,120)
        -- 源0x3678，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,120)
        -- 源0x368c，42号。
        H.push(v,2)
        H.at(a,v,120)
        -- 源0x36a0，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,120)
        -- 源0x36b0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(120);return B.part11(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x36c8，336号。
        H.sound(a,54)
        H.at(a,v,120)
        -- 源0x36dc，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,120)
        -- 源0x36f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3704，355号。
        v.l[16]=H.int(8)
        H.at(a,v,120)
        -- 源0x3728，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,120)
        -- 源0x373c，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,120)
        -- 源0x3750，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,120)
        -- 源0x3760，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,120)
        -- 源0x3774，12号。
        v.origin=H.clock(a)-(120);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x378c，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,120)
        -- 源0x37a0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x37b4，256号。
        H.spawn(a,256,"BossCard1Bomb",0.0,-32.0,200,10,0)
        H.at(a,v,120)
        -- 源0x37ec，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0x3800，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,120)
        -- 源0x3814，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x3824，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,120)
        -- 源0x3838，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,120)
        -- 源0x384c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,120)
        -- 源0x3864，15号。
        H.async(a,P["BossCard1At"],"BossCard1At",nil)
        H.at(a,v,120)
        -- 源0x3884，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x3898，368号。
        v.origin=v.origin+H.int(75)
        H.at(a,v,120)
        -- 源0x38b8，263号。
        H.effect(a,0,131)
        H.at(a,v,120)
        -- 源0x38d0，336号。
        H.sound(a,41)
        H.at(a,v,120)
        -- 源0x38e4，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x38f8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x390c，263号。
        H.effect(a,0,176)
        H.at(a,v,120)
        -- 源0x3924，336号。
        H.sound(a,54)
        H.at(a,v,120)
        -- 源0x3938，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,120)
        -- 源0x394c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3960，42号。
        H.push(v,8)
        H.at(a,v,120)
        -- 源0x3974，43号。
        v.l[16]=H.int(H.pop(v))
        H.at(a,v,120)
        -- 源0x3988，12号。
        v.origin=H.clock(a)-(120);return B.part13(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,120)
        -- 源0x39a0，44号。
        H.push(v,1.0)
        H.at(a,v,120)
        -- 源0x39b4，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,120)
        -- 源0x39c8，44号。
        H.push(v,0.5)
        H.at(a,v,120)
        -- 源0x39dc，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,120)
        -- 源0x39ec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x39fc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3a10，256号。
        H.spawn(a,256,"BossCard1Bomb",0.0,-32.0,200,10,0)
        H.at(a,v,120)
        -- 源0x3a48，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0x3a5c，44号。
        H.push(v,0.785398006439209)
        H.at(a,v,120)
        -- 源0x3a70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x3a80，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,120)
        -- 源0x3a94，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,120)
        -- 源0x3aa8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part12(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,120)
        -- 源0x3ac0，83号。
        v.origin=v.origin+H.int(100)
        H.at(a,v,120)
        -- 源0x3ad4，15号。
        H.async(a,P["BossCard1At2"],"BossCard1At2",nil)
        H.at(a,v,120)
        -- 源0x3af8，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,120)
        -- 源0x3b0c，42号。
        H.push(v,2)
        H.at(a,v,120)
        -- 源0x3b20，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,120)
        -- 源0x3b30，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(120);return B.part18(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,120)
        -- 源0x3b48，336号。
        H.sound(a,54)
        H.at(a,v,120)
        -- 源0x3b5c，44号。
        H.push(v,H.read(a,v,-9989))
        H.at(a,v,120)
        -- 源0x3b70，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3b84，355号。
        v.l[16]=H.int(8)
        H.at(a,v,120)
        -- 源0x3ba8，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,120)
        -- 源0x3bbc，42号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,120)
        -- 源0x3bd0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,120)
        -- 源0x3be0，45号。
        v.l[8]=H.f32(H.pop(v))
        H.at(a,v,120)
        -- 源0x3bf4，12号。
        v.origin=H.clock(a)-(120);return B.part17(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,120)
        -- 源0x3c0c，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,120)
        -- 源0x3c20，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,120)
        -- 源0x3c34，256号。
        H.spawn(a,256,"BossCard1Bomb",0.0,-32.0,200,10,0)
        H.at(a,v,120)
        -- 源0x3c6c，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,120)
        -- 源0x3c80，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,120)
        -- 源0x3c94，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,120)
        -- 源0x3ca4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,120)
        -- 源0x3cb8，78号。
        H.push(v,(v.l[16] or 0))
        v.l[16]=H.int((v.l[16] or 0)-1)
        H.at(a,v,120)
        -- 源0x3ccc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part16(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,120)
        -- 源0x3ce4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x3cf8，368号。
        v.origin=v.origin+H.int(75)
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,120)
        -- 源0x3d18，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x3d2c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part4(a,v) end
        return B.part20(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,120)
        -- 源0x3d44，12号。
        v.origin=H.clock(a)-(120);return B.part22(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,120)
        -- 源0x3d5c，83号。
        v.origin=v.origin+H.int(1000)
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,120)
        -- 源0x3d70，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x3d84，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part21(a,v) end
        return B.part23(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,120)
        -- 源0x3d9c，10号。
        return
    end
    P["BossCard1"]=B.part1
end

-- stage06boss.ecl：BossCard1At，0x3dbc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x3dbc，40号。
        H.at(a,v,0)
        -- 源0x3dd0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3de4，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x3df8，356号。
        v.l[4]=H.f32(0.04908738657832146)
        H.at(a,v,0)
        -- 源0x3e1c，355号。
        v.l[8]=H.int(210)
        H.at(a,v,0)
        -- 源0x3e40，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x3e58，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x3e6c，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x3e84，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x3ea0，406号。
        H.gun_count(a,2,3,1)
        H.at(a,v,0)
        -- 源0x3ebc，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x3ed8，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x3ef4，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x3f24，403号。
        H.gun_offset(a,2,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x3f40，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x3f54，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x3f68，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x3f7c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x3f8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x3f9c，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x3fb8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x3fcc，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x3fe0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x3ff0，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,0)
        -- 源0x4004，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4014，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4030，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x4044，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4058，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x406c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x407c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4090，368号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x40b0，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x40c4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x40dc，10号。
        return
    end
    P["BossCard1At"]=B.part1
end

-- stage06boss.ecl：BossCard1At2，0x40fc；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x40fc，40号。
        H.at(a,v,0)
        -- 源0x4110，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x4124，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4138，356号。
        v.l[4]=H.f32(0.04908738657832146)
        H.at(a,v,0)
        -- 源0x415c，355号。
        v.l[8]=H.int(210)
        H.at(a,v,0)
        -- 源0x4180，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4198，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x41ac，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x41c4，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x41e0，406号。
        H.gun_count(a,2,3,1)
        H.at(a,v,0)
        -- 源0x41fc，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x4218，405号。
        H.gun_speed(a,2,0.0,1.5)
        H.at(a,v,0)
        -- 源0x4234，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x4264，403号。
        H.gun_offset(a,2,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x4280，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4294，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x42a8，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x42bc，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x42cc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x42dc，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x42f8，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x430c，44号。
        H.push(v,0.5)
        H.at(a,v,0)
        -- 源0x4320，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x4330，44号。
        H.push(v,1.2000000476837158)
        H.at(a,v,0)
        -- 源0x4344，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4354，405号。
        H.gun_speed(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x4370，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x4384，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x4398，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x43ac，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x43bc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x43d0，368号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x43f0，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x4404，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x441c，10号。
        return
    end
    P["BossCard1At2"]=B.part1
end

-- stage06boss.ecl：BossCard1Bomb，0x443c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x443c，40号。
        H.at(a,v,0)
        -- 源0x4450，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x4464，259号。
        H.anm_slot(a,0,181)
        H.at(a,v,0)
        -- 源0x447c，322号。
        H.flags(a,2573,true)
        H.at(a,v,0)
        -- 源0x4490，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x44a8，334号。
        H.interrupt(a,0,0,0,"BossCard1BombErase")
        H.at(a,v,0)
        -- 源0x44dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x44f0，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4504，15号。
        H.async(a,P["BossCard1BombOut"],"BossCard1BombOut",nil)
        H.at(a,v,0)
        -- 源0x452c，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x4540，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x4554，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x4568，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x457c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4594，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x45ac，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x45c0，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x45d4，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x45e4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x45f8，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x460c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x4620，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4638，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4650，42号。
        H.push(v,H.read(a,v,-9983))
        H.at(a,v,0)
        -- 源0x4664，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4678，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4688，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x46a0，1号。
        H.erase(a);return
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x46b0，83号。
        v.origin=v.origin+H.int(1)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x46c4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x46d8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x46f0，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x4708，83号。
        v.origin=v.origin+H.int(1000)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x471c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4730，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x4748，1号。
        H.erase(a);return
    end
    P["BossCard1Bomb"]=B.part1
end

-- stage06boss.ecl：BossCard1BombErase，0x4768；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4768，40号。
        H.at(a,v,0)
        -- 源0x477c，322号。
        H.flags(a,3,true)
        H.at(a,v,0)
        -- 源0x4790，275号。
        H.anm_switch(a,0,1)
        H.at(a,v,0)
        -- 源0x47a8，83号。
        v.origin=v.origin+H.int(20)
        H.at(a,v,0)
        -- 源0x47bc，1号。
        H.erase(a);return
    end
    P["BossCard1BombErase"]=B.part1
end

-- stage06boss.ecl：BossCard1BombOut，0x47ec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x47ec，40号。
        H.at(a,v,0)
        -- 源0x4800，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4818，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x482c，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x4840，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x4854，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x4864，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4874，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x4888，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x489c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x48b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x48c0，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x48d0，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x48e0，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x48f4，42号。
        H.push(v,-128)
        H.at(a,v,0)
        -- 源0x4908，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4918，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4928，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x493c，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0x4950，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x4964，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x4974，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4984，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4994，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x49ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x49c0，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x49d4，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x49e8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x49fc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4a14，10号。
        return
    end
    P["BossCard1BombOut"]=B.part1
end

-- stage06boss.ecl：BossCard2，0x4a34；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4a34，40号。
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4ae4，357号。
        H.spell(a,146,3600,500000,"爆符「ペタフレア」",357)
        H.at(a,v,0)
        -- 源0x4b18，334号。
        H.interrupt(a,0,0,3600,"Boss3")
        H.at(a,v,0)
        -- 源0x4b40，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x4b50，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x4b60，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0x4b70，281号。
        H.position_time(a,0,60,4,0.0,64.0)
        H.at(a,v,0)
        -- 源0x4b90，335号。
        a.invul=60
        H.at(a,v,0)
        -- 源0x4ba4，336号。
        H.sound(a,7)
        H.at(a,v,0)
        -- 源0x4bb8，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x4bcc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x4be0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4bf0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4c08，256号。
        H.spawn(a,256,"Ecl_EtBreak",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0x4c3c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x4c54，256号。
        H.spawn(a,256,"Ecl_EtBreak_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x4c8c，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x4ca0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4cb4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4cc4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x4cdc，330号。
        H.drop_main(a,5)
        H.at(a,v,0)
        -- 源0x4cf0，329号。
        H.drop(a)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x4d00，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4d14，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x4d28，344号。
        a.chapter=44
        H.at(a,v,0)
        -- 源0x4d3c，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0x4d50，264号。
        H.effect_abs(a,2,24)
        H.at(a,v,120)
        -- 源0x4d68，0号。
        H.at(a,v,120)
        -- 源0x4d78，15号。
        H.async(a,P["BossCard2at"],"BossCard2at",nil)
        H.at(a,v,120)
        -- 源0x4d98，12号。
        v.origin=H.clock(a)-(120);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,120)
        -- 源0x4db0，269号。
        H.anm_cast(a,0)
        H.at(a,v,120)
        -- 源0x4dc4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,120)
        -- 源0x4dd8，292号。
        H.wander(a,0,60,0,1.5)
        H.at(a,v,120)
        -- 源0x4df4，83号。
        v.origin=v.origin+H.int(340)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,120)
        -- 源0x4e08，42号。
        H.push(v,1)
        H.at(a,v,120)
        -- 源0x4e1c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(120);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,120)
        -- 源0x4e34，10号。
        return
    end
    P["BossCard2"]=B.part1
end

-- stage06boss.ecl：BossCard2Bomb，0x4e54；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x4e54，40号。
        H.at(a,v,0)
        -- 源0x4e68，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x4e94，259号。
        H.anm_slot(a,0,183)
        H.at(a,v,0)
        -- 源0x4eac，322号。
        H.flags(a,2573,true)
        H.at(a,v,0)
        -- 源0x4ec0，284号。
        H.velocity(a,0,1.5707963705062866,2.5)
        H.at(a,v,0)
        -- 源0x4ed8，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x4eec，334号。
        H.interrupt(a,0,0,0,"BossCard1BombErase")
        H.at(a,v,0)
        -- 源0x4f20，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x4f34，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x4f48，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x4f58，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x4f70，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x4f84，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x4f9c，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x4fb8，436号。
        H.gun_count_diff(a,2,12,16,16,16,1,1,1,1)
        H.at(a,v,0)
        -- 源0x4fec，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x5008，435号。
        H.gun_speed_diff(a,2,1.7999999523162842,2.0,2.0,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x503c，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5054，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x5068，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x5080，402号。
        H.gun_sprite(a,2,1,6)
        H.at(a,v,0)
        -- 源0x509c，436号。
        H.gun_count_diff(a,2,12,16,17,19,1,1,1,1)
        H.at(a,v,0)
        -- 源0x50d0，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x50ec，435号。
        H.gun_speed_diff(a,2,1.7999999523162842,2.0,2.0,2.0,1.5,1.5,1.5,1.5)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5120，409号。
        H.gun_transform(a,2,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5150，409号。
        H.gun_transform(a,2,1,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x5180，438号。
        H.gun_distance(a,2,32.0)
        H.at(a,v,0)
        -- 源0x5198，404号。
        H.gun_angle(a,2,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x51b4，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x51c8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x51dc，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x51f0，15号。
        H.async(a,P["BossCard1BombOut"],"BossCard1BombOut",nil)
        H.at(a,v,0)
        -- 源0x5218，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x522c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5240，69号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5250，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part12(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x5268，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x527c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5290，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x52a4，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x52b8，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x52d0，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x52e8，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x52fc，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x5310，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5320，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5334，83号。
        v.origin=v.origin+H.int(1)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x5348，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x535c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x5374，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,0)
        -- 源0x5388，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x539c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x53b0，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x53c8，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x53e0，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x53f4，44号。
        H.push(v,1.2999999523162842)
        H.at(a,v,0)
        -- 源0x5408，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5418，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x542c，83号。
        v.origin=v.origin+H.int(1)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x5440，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x5454，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x546c，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x5484，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x5498，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x54ac，42号。
        H.push(v,15)
        H.at(a,v,0)
        -- 源0x54c0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x54d4，12号。
        v.origin=H.clock(a)-(0);return B.part14(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x54ec，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5504，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5518，42号。
        H.push(v,9)
        H.at(a,v,0)
        -- 源0x552c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x553c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5550，83号。
        v.origin=v.origin+H.int(1)
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x5564，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x5578，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x5590，83号。
        v.origin=v.origin+H.int(25)
        H.at(a,v,0)
        -- 源0x55a4，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x55b8，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x55cc，12号。
        v.origin=H.clock(a)-(0);return B.part17(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x55e4，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x55fc，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x5610，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0x5624，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5634，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x5648，83号。
        v.origin=v.origin+H.int(1)
        return B.part17(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x565c，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x5670，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part16(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x5688，12号。
        v.origin=H.clock(a)-(0);return B.part22(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x56a0，42号。
        H.push(v,H.read(a,v,-9983))
        H.at(a,v,0)
        -- 源0x56b4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x56c8，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x56d8，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part21(a,v) end
        return B.part20(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,0)
        -- 源0x56f0，1号。
        H.erase(a);return
    end
    function B.part21(a,v)
        H.at(a,v,0)
        -- 源0x5700，83号。
        v.origin=v.origin+H.int(1)
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,0)
        -- 源0x5714，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5728，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part19(a,v) end
        return B.part23(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,0)
        -- 源0x5740，12号。
        v.origin=H.clock(a)-(0);return B.part25(a,v)
    end
    function B.part24(a,v)
        H.at(a,v,0)
        -- 源0x5758，83号。
        v.origin=v.origin+H.int(1000)
        return B.part25(a,v)
    end
    function B.part25(a,v)
        H.at(a,v,0)
        -- 源0x576c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5780，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part24(a,v) end
        return B.part26(a,v)
    end
    function B.part26(a,v)
        H.at(a,v,0)
        -- 源0x5798，1号。
        H.erase(a);return
    end
    P["BossCard2Bomb"]=B.part1
end

-- stage06boss.ecl：BossCard2BombOut，0x57b8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x57b8，40号。
        H.at(a,v,0)
        -- 源0x57cc，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x57e4，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x57f8，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x580c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5820，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x5830，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5840，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x5854，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x5868，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x587c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x588c，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x589c，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x58ac，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x58c0，42号。
        H.push(v,-128)
        H.at(a,v,0)
        -- 源0x58d4，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x58e4，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x58f4，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x5908，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0x591c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5930，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5940，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5950，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5960，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5978，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x598c，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x59a0，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x59b4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x59c8，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x59e0，10号。
        return
    end
    P["BossCard2BombOut"]=B.part1
end

-- stage06boss.ecl：BossCard2at，0x5a00；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5a00，40号。
        H.at(a,v,0)
        -- 源0x5a14，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5a2c，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5a40，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5a54，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5a64，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5a78，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5a8c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5aa0，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5ab0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5ac0，257号。
        H.spawn(a,257,"BossCard2Bomb",H.read(a,v,-1),H.read(a,v,-1),100,10,0)
        H.at(a,v,0)
        -- 源0x5af8，368号。
        v.origin=v.origin+H.int(13)
        H.at(a,v,0)
        -- 源0x5b18，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5b2c，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5b40，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5b50，42号。
        H.push(v,-160)
        H.at(a,v,0)
        -- 源0x5b64，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5b78，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5b8c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5b9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5bac，257号。
        H.spawn(a,257,"BossCard2Bomb",H.read(a,v,-1),H.read(a,v,-1),100,10,0)
        H.at(a,v,0)
        -- 源0x5be4，368号。
        v.origin=v.origin+H.int(13)
        H.at(a,v,0)
        -- 源0x5c04，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5c18，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5c2c，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5c3c，42号。
        H.push(v,160)
        H.at(a,v,0)
        -- 源0x5c50，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5c64，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5c78，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5c88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5c98，257号。
        H.spawn(a,257,"BossCard2Bomb",H.read(a,v,-1),H.read(a,v,-1),100,10,0)
        H.at(a,v,0)
        -- 源0x5cd0，368号。
        v.origin=v.origin+H.int(13)
        H.at(a,v,0)
        -- 源0x5cf0，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5d04，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5d18，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5d28，42号。
        H.push(v,-96)
        H.at(a,v,0)
        -- 源0x5d3c，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5d50，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5d64，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5d74，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5d84，257号。
        H.spawn(a,257,"BossCard2Bomb",H.read(a,v,-1),H.read(a,v,-1),100,10,0)
        H.at(a,v,0)
        -- 源0x5dbc，368号。
        v.origin=v.origin+H.int(13)
        H.at(a,v,0)
        -- 源0x5ddc，44号。
        H.push(v,H.read(a,v,-9999))
        H.at(a,v,0)
        -- 源0x5df0，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x5e04，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5e14，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x5e28，44号。
        H.push(v,H.read(a,v,-9987))
        H.at(a,v,0)
        -- 源0x5e3c，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x5e50，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x5e60，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x5e70，257号。
        H.spawn(a,257,"BossCard2Bomb",H.read(a,v,-1),H.read(a,v,-1),100,10,0)
        H.at(a,v,0)
        -- 源0x5ea8，368号。
        v.origin=v.origin+H.int(13)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5ec8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x5edc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5ef4，10号。
        return
    end
    P["BossCard2at"]=B.part1
end

-- stage06boss.ecl：BossCard3，0x5f14；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x5f14，40号。
        H.at(a,v,0)
        -- 源0x5f28，335号。
        a.invul=100
        H.at(a,v,0)
        -- 源0x5f3c，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x5f4c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x5f60，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x5f74，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x5f84，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x5f9c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x5fb0，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x5fc8，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x5fdc，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x5fec，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x5ffc，334号。
        H.interrupt(a,0,0,4200,"Boss4")
        H.at(a,v,0)
        -- 源0x6024，344号。
        a.chapter=45
        H.at(a,v,0)
        -- 源0x6038，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x604c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x6060，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6070，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6088，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x6098，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x60ac，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x60c0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x60d0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x60e8，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x60fc，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x610c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6120，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6134，336号。
        H.sound(a,15)
        H.at(a,v,0)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x61cc，357号。
        H.spell(a,150,4200,500000,"焔星「十凶星」",357)
        H.at(a,v,0)
        -- 源0x61fc，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x6210，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0x6224，264号。
        H.effect_abs(a,2,24)
        H.at(a,v,0)
        -- 源0x623c，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,60)
        -- 源0x625c，0号。
        H.at(a,v,60)
        -- 源0x626c，263号。
        H.effect(a,0,131)
        H.at(a,v,60)
        -- 源0x6284，336号。
        H.sound(a,41)
        H.at(a,v,60)
        -- 源0x6298，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x62ac，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,60)
        -- 源0x62c0，324号。
        H.limit(a,0.0,128.0,280.0,32.0)
        H.at(a,v,60)
        H.at(a,v,60)
        -- 源0x6304，15号。
        H.async(a,P["BossCard3At1h"],"BossCard3At1h",nil)
        H.at(a,v,60)
        -- 源0x6328，15号。
        H.async(a,P["BossCard3At"],"BossCard3At",nil)
        H.at(a,v,60)
        -- 源0x6348，269号。
        H.anm_cast(a,0)
        H.at(a,v,60)
        -- 源0x635c，12号。
        v.origin=H.clock(a)-(60);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,60)
        -- 源0x6374，83号。
        v.origin=v.origin+H.int(100)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,60)
        -- 源0x6388，42号。
        H.push(v,1)
        H.at(a,v,60)
        -- 源0x639c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,60)
        -- 源0x63b4，10号。
        return
    end
    P["BossCard3"]=B.part1
end

-- stage06boss.ecl：BossCard3At，0x63d4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x63d4，40号。
        H.at(a,v,0)
        -- 源0x63e8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x63fc，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6410，42号。
        H.push(v,2100)
        H.at(a,v,0)
        -- 源0x6424，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x6438，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x644c，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x6460，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x6478，402号。
        H.gun_sprite(a,2,1,13)
        H.at(a,v,0)
        -- 源0x6494，436号。
        H.gun_count_diff(a,2,10,16,16,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x64c8，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x64e4，435号。
        H.gun_speed_diff(a,2,1.5,1.5,1.7999999523162842,1.5,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x6518，402号。
        H.gun_sprite(a,2,1,4)
        H.at(a,v,0)
        -- 源0x6534，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x6564，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x6578，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x658c，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x659c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x65b4，409号。
        H.gun_transform(a,2,1,0,8,240,-999999,0.0,-0.0062831854447722435)
        H.at(a,v,0)
        -- 源0x65e4，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x65fc，409号。
        H.gun_transform(a,2,1,0,8,240,-999999,0.0,0.0062831854447722435)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x662c，403号。
        H.gun_offset(a,2,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x6648，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6660，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6674，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x6688，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x669c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x66ac，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x66bc，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x66d8，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x66ec，42号。
        H.push(v,H.read(a,v,-9959))
        H.at(a,v,0)
        -- 源0x6700，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6714，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x6724，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x673c，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6750，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x6764，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6774，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6788，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x67a0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x67b4，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x67c8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x67d8，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x67ec，368号。
        v.origin=v.origin+H.int(15)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x680c，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x6820，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x6838，10号。
        return
    end
    P["BossCard3At"]=B.part1
end

-- stage06boss.ecl：BossCard3At1，0x6858；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6858，40号。
        H.at(a,v,0)
        -- 源0x686c，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x6880，355号。
        v.l[4]=H.int(4)
        H.at(a,v,0)
        -- 源0x68a4，44号。
        H.push(v,0.5235990285873413)
        H.at(a,v,0)
        -- 源0x68b8，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x68cc，44号。
        H.push(v,0.007853999733924866)
        H.at(a,v,0)
        -- 源0x68e0，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x68f4，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x6908，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x691c，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x6930，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6944，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6954，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6968，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6980，256号。
        H.spawn(a,256,"BossCard3Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x69b8，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x69cc，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x69e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x69f0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6a04，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x6a18，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6a30，355号。
        v.l[4]=H.int(4)
        H.at(a,v,0)
        -- 源0x6a54，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6a68，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6a7c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x6a90，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6aa0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6ab0，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6ac4，44号。
        H.push(v,0.007853999733924866)
        H.at(a,v,0)
        -- 源0x6ad8，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6aec，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x6b00，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6b14，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6b2c，256号。
        H.spawn(a,256,"BossCard3Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x6b64，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6b78，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6b8c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6b9c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x6bb0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x6bc4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x6bdc，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x6bf4，83号。
        v.origin=v.origin+H.int(15)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x6c08，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x6c1c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x6c34，10号。
        return
    end
    P["BossCard3At1"]=B.part1
end

-- stage06boss.ecl：BossCard3At1h，0x6c54；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x6c54，40号。
        H.at(a,v,0)
        -- 源0x6c68，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x6c7c，355号。
        v.l[4]=H.int(5)
        H.at(a,v,0)
        -- 源0x6ca0，44号。
        H.push(v,-0.5235990285873413)
        H.at(a,v,0)
        -- 源0x6cb4，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6cc8，44号。
        H.push(v,-0.010471999645233154)
        H.at(a,v,0)
        -- 源0x6cdc，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6cf0，42号。
        H.push(v,140)
        H.at(a,v,0)
        -- 源0x6d04，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6d18，44号。
        H.push(v,6.2831854820251465)
        H.at(a,v,0)
        -- 源0x6d2c，42号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x6d40，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6d50，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x6d64，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x6d7c，256号。
        H.spawn(a,256,"BossCard3Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x6db4，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6dc8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6ddc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6dec，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x6e00，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x6e14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x6e2c，355号。
        v.l[4]=H.int(5)
        H.at(a,v,0)
        -- 源0x6e50，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6e64，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6e78，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x6e8c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x6e9c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6eac，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6ec0，44号。
        H.push(v,0.007853999733924866)
        H.at(a,v,0)
        -- 源0x6ed4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6ee8，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x6efc，45号。
        H.write(a,-9979,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x6f10，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x6f28，256号。
        H.spawn(a,256,"BossCard3Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x6f60，44号。
        H.push(v,H.read(a,v,-9981))
        H.at(a,v,0)
        -- 源0x6f74，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x6f88，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x6f98，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x6fac，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x6fc0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x6fd8，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x6ff0，83号。
        v.origin=v.origin+H.int(15)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x7004，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7018，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x7030，10号。
        return
    end
    P["BossCard3At1h"]=B.part1
end

-- stage06boss.ecl：BossCard3Bomb，0x7050；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7050，40号。
        H.at(a,v,0)
        -- 源0x7064，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x7078，259号。
        H.anm_slot(a,0,181)
        H.at(a,v,0)
        -- 源0x7090，322号。
        H.flags(a,525,true)
        H.at(a,v,0)
        -- 源0x70a4，288号。
        H.circle(a,0,H.read(a,v,-9981),H.read(a,v,-9980),0.0,0.0)
        H.at(a,v,0)
        -- 源0x70c4，289号。
        H.circle_time(a,0,240,4,-999999.0,H.read(a,v,-9979),0.0)
        H.at(a,v,0)
        -- 源0x70e8，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x70fc，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7110，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x7124，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7138，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7150，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x7168，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x717c，42号。
        H.push(v,12)
        H.at(a,v,0)
        -- 源0x7190，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x71a0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x71b4，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x71c8，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x71dc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,226)
        -- 源0x71f4，0号。
        H.at(a,v,226)
        -- 源0x7204，336号。
        H.sound(a,54)
        H.at(a,v,226)
        -- 源0x7218，42号。
        H.push(v,0)
        H.at(a,v,226)
        -- 源0x722c，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,226)
        -- 源0x7240，12号。
        v.origin=H.clock(a)-(226);return B.part8(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,226)
        -- 源0x7258，42号。
        H.push(v,H.read(a,v,-9983))
        H.at(a,v,226)
        -- 源0x726c，42号。
        H.push(v,1)
        H.at(a,v,226)
        -- 源0x7280，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,226)
        -- 源0x7290，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(226);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,226)
        -- 源0x72a8，1号。
        H.erase(a);return
    end
    function B.part7(a,v)
        H.at(a,v,226)
        -- 源0x72b8，83号。
        v.origin=v.origin+H.int(1)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,226)
        -- 源0x72cc，42号。
        H.push(v,1)
        H.at(a,v,226)
        -- 源0x72e0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(226);return B.part5(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,226)
        -- 源0x72f8，12号。
        v.origin=H.clock(a)-(226);return B.part11(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,226)
        -- 源0x7310，83号。
        v.origin=v.origin+H.int(1000)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,226)
        -- 源0x7324，42号。
        H.push(v,1)
        H.at(a,v,226)
        -- 源0x7338，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(226);return B.part10(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,226)
        -- 源0x7350，1号。
        H.erase(a);return
    end
    P["BossCard3Bomb"]=B.part1
end

-- stage06boss.ecl：BossCard3BombOut，0x7370；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7370，40号。
        H.at(a,v,0)
        -- 源0x7384，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x739c，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x73b0，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x73c4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x73d8，53号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left-right)) end
        H.at(a,v,0)
        -- 源0x73e8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x73f8，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x740c，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x7420，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x7434，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7444，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7454，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7464，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x7478，42号。
        H.push(v,-128)
        H.at(a,v,0)
        -- 源0x748c，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x749c，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x74ac，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x74c0，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0x74d4，42号。
        H.push(v,128)
        H.at(a,v,0)
        -- 源0x74e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x74f8，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7508，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7518，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7530，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7544，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7558，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x756c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7580，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x7598，10号。
        return
    end
    P["BossCard3BombOut"]=B.part1
end

-- stage06boss.ecl：BossCard4，0x75b8；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x75b8，40号。
        H.at(a,v,0)
        -- 源0x75cc，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x75dc，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x75ec，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x7600，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7614，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7624，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x763c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x7650，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7668，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x767c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x768c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x769c，335号。
        a.invul=260
        H.at(a,v,0)
        -- 源0x76b0，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0x76c0，334号。
        H.interrupt(a,0,0,4200,"BossCard5")
        H.at(a,v,0)
        -- 源0x76ec，344号。
        a.chapter=27
        H.at(a,v,0)
        -- 源0x7700，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x7714，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7728，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7738，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x7750，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x7760，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x7774，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7788，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x7798，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x77b0，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x77c4，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x77dc，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x77ec，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7800，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7814，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x7828，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x783c，324号。
        H.limit(a,0.0,224.0,280.0,320.0)
        H.at(a,v,0)
        -- 源0x785c，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x787c，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7890，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x78a4，263号。
        H.effect(a,0,197)
        H.at(a,v,0)
        -- 源0x78bc，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x78d0，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x78e4，263号。
        H.effect(a,0,197)
        H.at(a,v,0)
        -- 源0x78fc，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7910，263号。
        H.effect(a,0,197)
        H.at(a,v,0)
        -- 源0x7928，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x793c，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0x7950，264号。
        H.effect_abs(a,2,24)
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x79a4，357号。
        H.spell(a,154,4200,500000,"「ヘルズトカマク」",357)
        H.at(a,v,0)
        -- 源0x79d8，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x79ec，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x7a00，44号。
        H.push(v,1.570796012878418)
        H.at(a,v,0)
        -- 源0x7a14，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7a28，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x7a3c，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7a50，256号。
        H.spawn(a,256,"BossCard4Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x7a88，44号。
        H.push(v,-1.570796012878418)
        H.at(a,v,0)
        -- 源0x7a9c，45号。
        H.write(a,-9981,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7ab0，44号。
        H.push(v,1.0)
        H.at(a,v,0)
        -- 源0x7ac4，45号。
        H.write(a,-9980,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7ad8，256号。
        H.spawn(a,256,"BossCard4Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x7b10，83号。
        v.origin=v.origin+H.int(120)
        H.at(a,v,0)
        -- 源0x7b24，281号。
        H.position_time(a,0,60,4,0.0,128.0)
        H.at(a,v,0)
        -- 源0x7b44，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x7b58，324号。
        H.limit(a,0.0,128.0,380.0,32.0)
        H.at(a,v,0)
        -- 源0x7b78，12号。
        v.origin=H.clock(a)-(0);return B.part10(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x7b90，292号。
        H.wander(a,0,60,4,3.0)
        H.at(a,v,0)
        -- 源0x7bac，83号。
        v.origin=v.origin+H.int(100)
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x7bc0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x7bd4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x7bec，10号。
        return
    end
    P["BossCard4"]=B.part1
end

-- stage06boss.ecl：BossCard4At，0x7c0c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7c0c，40号。
        H.at(a,v,0)
        -- 源0x7c20，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7c34，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7c48，42号。
        H.push(v,210)
        H.at(a,v,0)
        -- 源0x7c5c，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7c70，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x7c84，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x7c98，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x7cb0，402号。
        H.gun_sprite(a,2,1,13)
        H.at(a,v,0)
        -- 源0x7ccc，406号。
        H.gun_count(a,2,16,1)
        H.at(a,v,0)
        -- 源0x7ce8，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x7d04，405号。
        H.gun_speed(a,2,1.5,1.5)
        H.at(a,v,0)
        -- 源0x7d20，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x7d50，409号。
        H.gun_transform(a,2,1,0,8,240,-999999,0.0,-0.0062831854447722435)
        H.at(a,v,0)
        -- 源0x7d80，403号。
        H.gun_offset(a,2,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x7d9c，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7db4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7dc8，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x7ddc，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x7df0，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x7e00，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7e10，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x7e2c，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x7e40，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x7e54，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x7e68，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x7e78，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7e8c，83号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x7ea0，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x7eb4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x7ecc，10号。
        return
    end
    P["BossCard4At"]=B.part1
end

-- stage06boss.ecl：BossCard4Bomb，0x7eec；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x7eec，40号。
        H.at(a,v,0)
        -- 源0x7f00，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0x7f14，259号。
        H.anm_slot(a,0,185)
        H.at(a,v,0)
        -- 源0x7f2c，322号。
        H.flags(a,525,true)
        H.at(a,v,0)
        -- 源0x7f40，284号。
        H.velocity(a,0,H.read(a,v,-9981),H.read(a,v,-9980))
        H.at(a,v,0)
        -- 源0x7f58，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x7f6c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x7f80，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x7f94，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0x7fa8，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x7fbc，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0x7fd0，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x7fe4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x7ffc，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8014，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8028，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x803c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x804c，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8060，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8074，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x8088，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x80a0，15号。
        H.async(a,P["BossCard4BombOut"],"BossCard4BombOut",nil)
        H.at(a,v,0)
        -- 源0x80c8，12号。
        v.origin=H.clock(a)-(0);return B.part11(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x80e0，42号。
        H.push(v,H.read(a,v,-9983))
        H.at(a,v,0)
        -- 源0x80f4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8108，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8118，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part10(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8130，42号。
        H.push(v,120)
        H.at(a,v,0)
        -- 源0x8144，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x8158，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8170，321号。
        H.hitbox(a,(v.l[4] or 0),(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x8188，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x819c，44号。
        H.push(v,3.0)
        H.at(a,v,0)
        -- 源0x81b0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x81c0，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x81d4，83号。
        v.origin=v.origin+H.int(1)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x81e8，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0x81fc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x8214，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x822c，83号。
        v.origin=v.origin+H.int(1)
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x8240，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8254，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x826c，12号。
        v.origin=H.clock(a)-(0);return B.part14(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x8284，83号。
        v.origin=v.origin+H.int(1000)
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x8298，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x82ac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x82c4，1号。
        H.erase(a);return
    end
    P["BossCard4Bomb"]=B.part1
end

-- stage06boss.ecl：BossCard4BombAt，0x82e4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x82e4，40号。
        H.at(a,v,0)
        -- 源0x82f8，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x830c，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x8324，402号。
        H.gun_sprite(a,2,25,0)
        H.at(a,v,0)
        -- 源0x8340，436号。
        H.gun_count_diff(a,2,24,48,48,48,1,1,1,1)
        H.at(a,v,0)
        -- 源0x8374，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8390，435号。
        H.gun_speed_diff(a,2,1.0,1.0,1.0,1.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x83c4，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x83d8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x83ec，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x8400，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x8414，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8424，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x843c，83号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8450，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8468，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x847c，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x8490，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x84a0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x84b8，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x84cc，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x84e0，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x84f0，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8504，438号。
        H.gun_distance(a,2,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x851c，404号。
        H.gun_angle(a,2,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x8538，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x854c，83号。
        v.origin=v.origin+H.int(60)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8560，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8574，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x858c，10号。
        return
    end
    P["BossCard4BombAt"]=B.part1
end

-- stage06boss.ecl：BossCard4BombAth，0x85ac；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x85ac，40号。
        H.at(a,v,0)
        -- 源0x85c0，356号。
        v.l[4]=H.f32(-0.008333333767950535)
        H.at(a,v,0)
        -- 源0x85e4，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x85f8，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x8610，402号。
        H.gun_sprite(a,2,25,1)
        H.at(a,v,0)
        -- 源0x862c，436号。
        H.gun_count_diff(a,2,24,48,48,48,1,1,1,1)
        H.at(a,v,0)
        -- 源0x8660，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x867c，435号。
        H.gun_speed_diff(a,2,1.0,1.0,1.5,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0x86b0，409号。
        H.gun_transform(a,2,0,0,1024,500,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x86e0，409号。
        H.gun_transform(a,2,1,0,8,120,-999999,(v.l[4] or 0),0.02617993950843811)
        H.at(a,v,0)
        -- 源0x8710，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x8724，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x8738，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x874c，42号。
        H.push(v,224)
        H.at(a,v,0)
        -- 源0x8760，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8770，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8788，83号。
        v.origin=v.origin+H.int(30)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x879c，12号。
        v.origin=H.clock(a)-(0);return B.part7(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x87b4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x87c8，42号。
        H.push(v,96)
        H.at(a,v,0)
        -- 源0x87dc，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x87ec，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part6(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8804，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8818，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x882c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x883c，45号。
        v.l[0]=H.f32(H.pop(v))
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8850，438号。
        H.gun_distance(a,2,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x8868，404号。
        H.gun_angle(a,2,H.read(a,v,-9998),0.0)
        H.at(a,v,0)
        -- 源0x8884，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x8898，368号。
        v.origin=v.origin+H.int(52)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x88b8，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x88cc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x88e4，10号。
        return
    end
    P["BossCard4BombAth"]=B.part1
end

-- stage06boss.ecl：BossCard4BombOut，0x8904；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8904，40号。
        H.at(a,v,0)
        -- 源0x8918，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8930，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x8944，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0x8958，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8968，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0x897c，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0x8990，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x89a0，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x89b0，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x89c4，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x89d8，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x89e8，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x89f8，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0x8a0c，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0x8a20，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8a30，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8a40，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8a58，263号。
        H.effect(a,0,176)
        H.at(a,v,0)
        -- 源0x8a70，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0x8a88，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x8aa0，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x8ab4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8ac8，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x8b00，15号。
        H.async(a,P["BossCard4BombAth"],"BossCard4BombAth",nil)
        H.at(a,v,0)
        -- 源0x8b28，10号。
        return
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8b38，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8b4c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8b60，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8b78，10号。
        return
    end
    P["BossCard4BombOut"]=B.part1
end

-- stage06boss.ecl：BossCard5，0x8b98；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x8b98，40号。
        H.at(a,v,0)
        -- 源0x8bac，333号。
        a.phase_time=0
        H.at(a,v,0)
        -- 源0x8bbc，345号。
        H.kill_all(a)
        H.at(a,v,0)
        -- 源0x8bcc，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8be0，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8bf4，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8c04，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x8c1c，420号。
        H.cancel(a,640.0,true)
        H.at(a,v,0)
        -- 源0x8c30，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x8c48，421号。
        H.cancel(a,640.0,false)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x8c5c，343号。
        H.spell_end(a)
        H.at(a,v,0)
        -- 源0x8c6c，21号。
        H.stop_threads(a)
        H.at(a,v,0)
        -- 源0x8c7c，335号。
        a.invul=260
        H.at(a,v,0)
        -- 源0x8c90，307号。
        H.motion_reset(a)
        H.at(a,v,0)
        -- 源0x8ca0，331号。
        H.life(a,6500)
        H.at(a,v,0)
        -- 源0x8cb4，334号。
        H.interrupt(a,0,0,8400,"BossDead")
        H.at(a,v,0)
        -- 源0x8ce0，347号。
        H.life_marker(a,0,6500.0,-24448)
        H.at(a,v,0)
        -- 源0x8cfc，360号。
        a.stars=0
        H.at(a,v,0)
        -- 源0x8d10，344号。
        a.chapter=28
        H.at(a,v,0)
        -- 源0x8d24，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0x8d38，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x8d4c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8d5c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x8d74，326号。
        H.drop_clear(a)
        H.at(a,v,0)
        -- 源0x8d84，42号。
        H.push(v,H.read(a,v,-9947))
        H.at(a,v,0)
        -- 源0x8d98，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8dac，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x8dbc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part7(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x8dd4，330号。
        H.drop_main(a,5)
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x8de8，327号。
        H.drop_extra(a,4,1)
        H.at(a,v,0)
        -- 源0x8e00，327号。
        H.drop_extra(a,1,20)
        H.at(a,v,0)
        -- 源0x8e18，327号。
        H.drop_extra(a,2,40)
        H.at(a,v,0)
        -- 源0x8e30，328号。
        H.drop_area(a,48.0,48.0)
        H.at(a,v,0)
        -- 源0x8e48，329号。
        H.drop(a)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x8e58，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x8e6c，43号。
        H.write(a,-9947,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x8e80，336号。
        H.sound(a,15)
        H.at(a,v,0)
        -- 源0x8e94，322号。
        H.flags(a,2,true)
        H.at(a,v,0)
        -- 源0x8ea8，324号。
        H.limit(a,0.0,224.0,280.0,320.0)
        H.at(a,v,0)
        -- 源0x8ec8，281号。
        H.position_time(a,0,60,4,0.0,224.0)
        H.at(a,v,0)
        -- 源0x8ee8，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x8efc，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x8f10，263号。
        H.effect(a,0,131)
        H.at(a,v,0)
        -- 源0x8f28，269号。
        H.anm_cast(a,0)
        H.at(a,v,0)
        -- 源0x8f3c，333号。
        a.phase_time=0
        H.at(a,v,0)
        H.at(a,v,0)
        -- 源0x8f80，357号。
        H.spell(a,158,8400,500000,"「サブタレイニアンサン」",357)
        H.at(a,v,0)
        -- 源0x8fbc，344号。
        a.chapter=46
        H.at(a,v,0)
        -- 源0x8fd0，15号。
        H.async(a,P["BossCard5At3"],"BossCard5At3",nil)
        H.at(a,v,0)
        -- 源0x8ff4，83号。
        v.origin=v.origin+H.int(60)
        H.at(a,v,0)
        -- 源0x9008，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x901c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9030，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9044，15号。
        H.async(a,P["BossCard5At2"],"BossCard5At2",nil)
        H.at(a,v,0)
        -- 源0x9068，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x907c，336号。
        H.sound(a,55)
        H.at(a,v,0)
        -- 源0x9090，264号。
        H.effect_abs(a,2,24)
        H.at(a,v,0)
        -- 源0x90a8，337号。
        H.shake(a,30,0,3)
        H.at(a,v,0)
        -- 源0x90c4，336号。
        H.sound(a,41)
        H.at(a,v,0)
        -- 源0x90d8，263号。
        H.effect(a,0,197)
        H.at(a,v,0)
        -- 源0x90f0，83号。
        v.origin=v.origin+H.int(30)
        H.at(a,v,0)
        -- 源0x9104，337号。
        H.shake(a,90,3,3)
        H.at(a,v,0)
        -- 源0x9120，83号。
        v.origin=v.origin+H.int(90)
        H.at(a,v,0)
        -- 源0x9134，337号。
        H.shake(a,30,3,0)
        H.at(a,v,0)
        -- 源0x9150，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9164，43号。
        H.write(a,-9985,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9178，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0x918c，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x91a0，443号。
        H.callback(a,443,5)
        H.at(a,v,0)
        -- 源0x91b4，15号。
        H.async(a,P["BossCard5At1"],"BossCard5At1",nil)
        H.at(a,v,0)
        -- 源0x91d8，256号。
        H.spawn(a,256,"BossCard5Bomb",0.0,0.0,100,10,0)
        H.at(a,v,0)
        -- 源0x9210，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9224，43号。
        H.write(a,-9984,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9238，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x924c，43号。
        H.write(a,-9982,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9260，12号。
        v.origin=H.clock(a)-(0);return B.part21(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x9278，42号。
        H.push(v,H.read(a,v,-9982))
        H.at(a,v,0)
        -- 源0x928c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x92a0，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x92b0，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part13(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x92c8，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x92dc，42号。
        H.push(v,5000)
        H.at(a,v,0)
        -- 源0x92f0，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9300，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part12(a,v) end
        return B.part11(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0x9318，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x932c，43号。
        H.write(a,-9982,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9340，336号。
        H.sound(a,54)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0x9354，12号。
        v.origin=H.clock(a)-(0);return B.part20(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0x936c，42号。
        H.push(v,H.read(a,v,-9982))
        H.at(a,v,0)
        -- 源0x9380，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9394，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x93a4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part14(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0x93bc，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x93d0，42号。
        H.push(v,3000)
        H.at(a,v,0)
        -- 源0x93e4，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x93f4，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part16(a,v) end
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0x940c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x9420，43号。
        H.write(a,-9982,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9434，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x9448，15号。
        H.async(a,P["BossCard5At1b"],"BossCard5At1b",nil)
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0x946c，12号。
        v.origin=H.clock(a)-(0);return B.part20(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0x9484，42号。
        H.push(v,H.read(a,v,-9982))
        H.at(a,v,0)
        -- 源0x9498，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0x94ac，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x94bc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part20(a,v) end
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0x94d4，42号。
        H.push(v,H.read(a,v,-9954))
        H.at(a,v,0)
        -- 源0x94e8，42号。
        H.push(v,1500)
        H.at(a,v,0)
        -- 源0x94fc，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x950c，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part20(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0x9524，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0x9538，43号。
        H.write(a,-9982,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0x954c，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0x9560，15号。
        H.async(a,P["BossCard5At1b"],"BossCard5At1b",nil)
        return B.part20(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,0)
        -- 源0x9584，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0x9598，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0x95ac，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x95bc，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0x95d0，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0x95e4，55号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left*right)) end
        H.at(a,v,0)
        -- 源0x95f4，320号。
        H.hurtbox(a,H.read(a,v,-1),H.read(a,v,-1))
        H.at(a,v,0)
        -- 源0x960c，83号。
        v.origin=v.origin+H.int(1)
        return B.part21(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,0)
        -- 源0x9620，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9634，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part9(a,v) end
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,0)
        -- 源0x964c，10号。
        return
    end
    P["BossCard5"]=B.part1
end

-- stage06boss.ecl：BossCard5At，0x966c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x966c，40号。
        H.at(a,v,0)
        -- 源0x9680，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9694，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x96a8，42号。
        H.push(v,210)
        H.at(a,v,0)
        -- 源0x96bc，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x96d0，83号。
        v.origin=v.origin+H.int(200)
        H.at(a,v,0)
        -- 源0x96e4，400号。
        H.gun_new(a,2)
        H.at(a,v,0)
        -- 源0x96f8，407号。
        H.gun_aim(a,2,3)
        H.at(a,v,0)
        -- 源0x9710，402号。
        H.gun_sprite(a,2,1,13)
        H.at(a,v,0)
        -- 源0x972c，406号。
        H.gun_count(a,2,16,1)
        H.at(a,v,0)
        -- 源0x9748，404号。
        H.gun_angle(a,2,0.0,0.0)
        H.at(a,v,0)
        -- 源0x9764，405号。
        H.gun_speed(a,2,1.5,1.5)
        H.at(a,v,0)
        -- 源0x9780，409号。
        H.gun_transform(a,2,0,1,2,0,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x97b0，409号。
        H.gun_transform(a,2,1,0,8,240,-999999,0.0,-0.0062831854447722435)
        H.at(a,v,0)
        -- 源0x97e0，403号。
        H.gun_offset(a,2,0.0,-32.0)
        H.at(a,v,0)
        -- 源0x97fc，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9814，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9828，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x983c，42号。
        H.push(v,64)
        H.at(a,v,0)
        -- 源0x9850，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0x9860，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9870，404号。
        H.gun_angle(a,2,H.read(a,v,-1),0.0)
        H.at(a,v,0)
        -- 源0x988c，401号。
        H.fire(a,2)
        H.at(a,v,0)
        -- 源0x98a0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x98b4，44号。
        H.push(v,0.09817499667406082)
        H.at(a,v,0)
        -- 源0x98c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x98d8，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x98ec，83号。
        v.origin=v.origin+H.int(15)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9900，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,0)
        -- 源0x9914，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x992c，10号。
        return
    end
    P["BossCard5At"]=B.part1
end

-- stage06boss.ecl：BossCard5At1，0x994c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x994c，40号。
        H.at(a,v,0)
        -- 源0x9960，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x9974，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9988，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x99a0，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x99b4，44号。
        H.push(v,0.00800000037997961)
        H.at(a,v,0)
        -- 源0x99c8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x99d8，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x99ec，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9a00，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x9a14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9a2c，10号。
        return
    end
    P["BossCard5At1"]=B.part1
end

-- stage06boss.ecl：BossCard5At1b，0x9a4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9a4c，40号。
        H.at(a,v,0)
        -- 源0x9a60，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0x9a74，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9a88，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9aa0，44号。
        H.push(v,H.read(a,v,-9978))
        H.at(a,v,0)
        -- 源0x9ab4，44号。
        H.push(v,0.004000000189989805)
        H.at(a,v,0)
        -- 源0x9ac8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9ad8，45号。
        H.write(a,-9978,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0x9aec，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9b00，78号。
        H.push(v,(v.l[0] or 0))
        v.l[0]=H.int((v.l[0] or 0)-1)
        H.at(a,v,0)
        -- 源0x9b14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9b2c，10号。
        return
    end
    P["BossCard5At1b"]=B.part1
end

-- stage06boss.ecl：BossCard5At2，0x9b4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9b4c，40号。
        H.at(a,v,0)
        -- 源0x9b60，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0x9b74，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0x9b8c，402号。
        H.gun_sprite(a,0,1,2)
        H.at(a,v,0)
        -- 源0x9ba8，436号。
        H.gun_count_diff(a,0,8,16,18,20,1,1,1,1)
        H.at(a,v,0)
        -- 源0x9bdc，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0x9bf8，405号。
        H.gun_speed(a,0,0.0,1.5)
        H.at(a,v,0)
        -- 源0x9c14，409号。
        H.gun_transform(a,0,0,1,2,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9c44，409号。
        H.gun_transform(a,0,1,0,1024,3000,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0x9c74，346号。
        a.protect=32.0
        H.at(a,v,0)
        -- 源0x9c88，42号。
        H.push(v,32)
        H.at(a,v,0)
        -- 源0x9c9c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9cb0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0x9cc4，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9cd8，356号。
        v.l[8]=H.f32(0.11990811675786972)
        H.at(a,v,0)
        -- 源0x9cfc，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9d14，438号。
        H.gun_distance(a,0,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9d2c，404号。
        H.gun_angle(a,0,(v.l[4] or 0),0.0)
        H.at(a,v,0)
        -- 源0x9d48，44号。
        H.push(v,(v.l[4] or 0))
        H.at(a,v,0)
        -- 源0x9d5c，44号。
        H.push(v,(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0x9d70，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9d80，45号。
        v.l[4]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9d94，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9da8，42号。
        H.push(v,320)
        H.at(a,v,0)
        -- 源0x9dbc，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9dcc，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0x9de4，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9df8，44号。
        H.push(v,16.0)
        H.at(a,v,0)
        -- 源0x9e0c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0x9e1c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0x9e30，12号。
        v.origin=H.clock(a)-(0);return B.part8(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0x9e48，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0x9e60，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0x9e74，42号。
        H.push(v,H.read(a,v,-9984))
        H.at(a,v,0)
        -- 源0x9e88，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0x9e9c，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0x9eac，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0x9ec4，83号。
        v.origin=v.origin+H.int(20)
        return B.part8(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0x9ed8，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0x9eec，83号。
        v.origin=v.origin+H.int(10)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0x9f00，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9f14，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0x9f2c，10号。
        return
    end
    P["BossCard5At2"]=B.part1
end

-- stage06boss.ecl：BossCard5At3，0x9f4c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0x9f4c，40号。
        H.at(a,v,0)
        -- 源0x9f60，42号。
        H.push(v,8400)
        H.at(a,v,0)
        -- 源0x9f74，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9f88，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0x9fa0，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0x9fb4，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0x9fc8，52号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left-right)) end
        H.at(a,v,0)
        -- 源0x9fd8，43号。
        v.l[0]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0x9fec，42号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xa000，42号。
        H.push(v,30)
        H.at(a,v,0)
        -- 源0xa014，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xa028，54号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.int(left*right)) end
        H.at(a,v,0)
        -- 源0xa038，63号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa048，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa060，42号。
        H.push(v,4)
        H.at(a,v,0)
        -- 源0xa074，43号。
        H.write(a,-9982,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa088，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0xa09c，15号。
        H.async(a,P["BossCard5At1b"],"BossCard5At1b",nil)
        H.at(a,v,0)
        -- 源0xa0c0，15号。
        H.async(a,P["BossCard5At1b"],"BossCard5At1b",nil)
        H.at(a,v,0)
        -- 源0xa0e4，15号。
        H.async(a,P["BossCard5At1b"],"BossCard5At1b",nil)
        H.at(a,v,0)
        -- 源0xa108，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa120，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa134，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa148，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xa160，10号。
        return
    end
    P["BossCard5At3"]=B.part1
end

-- stage06boss.ecl：BossCard5Bomb，0xa180；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa180，40号。
        H.at(a,v,0)
        -- 源0xa194，258号。
        H.select_anm(a,0)
        H.at(a,v,0)
        -- 源0xa1a8，259号。
        H.anm_slot(a,0,187)
        H.at(a,v,0)
        -- 源0xa1c0，322号。
        H.flags(a,525,true)
        H.at(a,v,0)
        -- 源0xa1d4，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0xa1e8，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa1fc，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa210，42号。
        H.push(v,8)
        H.at(a,v,0)
        -- 源0xa224，45号。
        H.write(a,-9939,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa238，42号。
        H.push(v,14)
        H.at(a,v,0)
        -- 源0xa24c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa260，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xa278，321号。
        H.hitbox(a,H.read(a,v,-9939),H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa290，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa2a4，42号。
        H.push(v,6)
        H.at(a,v,0)
        -- 源0xa2b8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa2c8，45号。
        H.write(a,-9939,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa2dc，83号。
        v.origin=v.origin+H.int(1)
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xa2f0，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xa304，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xa31c，12号。
        v.origin=H.clock(a)-(0);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xa334，83号。
        v.origin=v.origin+H.int(1)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xa348，42号。
        H.push(v,H.read(a,v,-9940))
        H.at(a,v,0)
        -- 源0xa35c，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xa370，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa380，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,0)
        -- 源0xa398，15号。
        H.async(a,P["BossCard5BombAt"],"BossCard5BombAt",nil)
        H.at(a,v,0)
        -- 源0xa3bc，15号。
        H.async(a,P["BossCard5BombAt2"],"BossCard5BombAt2",nil)
        H.at(a,v,0)
        -- 源0xa3e4，12号。
        v.origin=H.clock(a)-(0);return B.part9(a,v)
    end
    function B.part8(a,v)
        H.at(a,v,0)
        -- 源0xa3fc，83号。
        v.origin=v.origin+H.int(1)
        return B.part9(a,v)
    end
    function B.part9(a,v)
        H.at(a,v,0)
        -- 源0xa410，42号。
        H.push(v,H.read(a,v,-9940))
        H.at(a,v,0)
        -- 源0xa424，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa438，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa448，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part8(a,v) end
        return B.part10(a,v)
    end
    function B.part10(a,v)
        H.at(a,v,0)
        -- 源0xa460，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0xa478，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xa48c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa4a0，12号。
        v.origin=H.clock(a)-(0);return B.part12(a,v)
    end
    function B.part11(a,v)
        H.at(a,v,0)
        -- 源0xa4b8，321号。
        H.hitbox(a,H.read(a,v,-9939),H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa4d0，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa4e4，44号。
        H.push(v,0.8999999761581421)
        H.at(a,v,0)
        -- 源0xa4f8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa508，45号。
        H.write(a,-9939,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa51c，83号。
        v.origin=v.origin+H.int(1)
        return B.part12(a,v)
    end
    function B.part12(a,v)
        H.at(a,v,0)
        -- 源0xa530，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xa544，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part11(a,v) end
        return B.part13(a,v)
    end
    function B.part13(a,v)
        H.at(a,v,0)
        -- 源0xa55c，12号。
        v.origin=H.clock(a)-(0);return B.part15(a,v)
    end
    function B.part14(a,v)
        H.at(a,v,0)
        -- 源0xa574，83号。
        v.origin=v.origin+H.int(1)
        return B.part15(a,v)
    end
    function B.part15(a,v)
        H.at(a,v,0)
        -- 源0xa588，42号。
        H.push(v,H.read(a,v,-9940))
        H.at(a,v,0)
        -- 源0xa59c，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xa5b0，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa5c0，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part14(a,v) end
        return B.part16(a,v)
    end
    function B.part16(a,v)
        H.at(a,v,0)
        -- 源0xa5d8，275号。
        H.anm_switch(a,0,3)
        H.at(a,v,0)
        -- 源0xa5f0，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xa604，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa618，12号。
        v.origin=H.clock(a)-(0);return B.part18(a,v)
    end
    function B.part17(a,v)
        H.at(a,v,0)
        -- 源0xa630，321号。
        H.hitbox(a,H.read(a,v,-9939),H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa648，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa65c，44号。
        H.push(v,0.8999999761581421)
        H.at(a,v,0)
        -- 源0xa670，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa680，45号。
        H.write(a,-9939,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa694，83号。
        v.origin=v.origin+H.int(1)
        return B.part18(a,v)
    end
    function B.part18(a,v)
        H.at(a,v,0)
        -- 源0xa6a8，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xa6bc，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part17(a,v) end
        return B.part19(a,v)
    end
    function B.part19(a,v)
        H.at(a,v,0)
        -- 源0xa6d4，12号。
        v.origin=H.clock(a)-(0);return B.part21(a,v)
    end
    function B.part20(a,v)
        H.at(a,v,0)
        -- 源0xa6ec，83号。
        v.origin=v.origin+H.int(1)
        return B.part21(a,v)
    end
    function B.part21(a,v)
        H.at(a,v,0)
        -- 源0xa700，42号。
        H.push(v,H.read(a,v,-9940))
        H.at(a,v,0)
        -- 源0xa714，42号。
        H.push(v,3)
        H.at(a,v,0)
        -- 源0xa728，65号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<=right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xa738，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part20(a,v) end
        return B.part22(a,v)
    end
    function B.part22(a,v)
        H.at(a,v,0)
        -- 源0xa750，275号。
        H.anm_switch(a,0,4)
        H.at(a,v,0)
        -- 源0xa768，42号。
        H.push(v,60)
        H.at(a,v,0)
        -- 源0xa77c，43号。
        v.l[8]=H.int(H.pop(v))
        H.at(a,v,0)
        -- 源0xa790，12号。
        v.origin=H.clock(a)-(0);return B.part24(a,v)
    end
    function B.part23(a,v)
        H.at(a,v,0)
        -- 源0xa7a8，321号。
        H.hitbox(a,H.read(a,v,-9939),H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa7c0，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xa7d4，44号。
        H.push(v,0.800000011920929)
        H.at(a,v,0)
        -- 源0xa7e8，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xa7f8，45号。
        H.write(a,-9939,H.f32(H.pop(v)))
        H.at(a,v,0)
        -- 源0xa80c，83号。
        v.origin=v.origin+H.int(1)
        return B.part24(a,v)
    end
    function B.part24(a,v)
        H.at(a,v,0)
        -- 源0xa820，78号。
        H.push(v,(v.l[8] or 0))
        v.l[8]=H.int((v.l[8] or 0)-1)
        H.at(a,v,0)
        -- 源0xa834，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part23(a,v) end
        return B.part25(a,v)
    end
    function B.part25(a,v)
        H.at(a,v,0)
        -- 源0xa84c，12号。
        v.origin=H.clock(a)-(0);return B.part27(a,v)
    end
    function B.part26(a,v)
        H.at(a,v,0)
        -- 源0xa864，83号。
        v.origin=v.origin+H.int(1000)
        return B.part27(a,v)
    end
    function B.part27(a,v)
        H.at(a,v,0)
        -- 源0xa878，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xa88c，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part26(a,v) end
        return B.part28(a,v)
    end
    function B.part28(a,v)
        H.at(a,v,0)
        -- 源0xa8a4，1号。
        H.erase(a);return
    end
    P["BossCard5Bomb"]=B.part1
end

-- stage06boss.ecl：BossCard5BombAt，0xa8c4；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xa8c4，40号。
        H.at(a,v,0)
        -- 源0xa8d8，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xa8ec，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xa904，402号。
        H.gun_sprite(a,0,0,0)
        H.at(a,v,0)
        -- 源0xa920，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xa93c，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xa958，435号。
        H.gun_speed_diff(a,0,0.5,0.5,0.5,1.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0xa98c，409号。
        H.gun_transform(a,0,0,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xa9bc，44号。
        H.push(v,0.0)
        H.at(a,v,0)
        -- 源0xa9d0，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xa9e4，356号。
        v.l[16]=H.f32(0.06981316953897476)
        H.at(a,v,0)
        -- 源0xaa08，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xaa20，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaa34，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xaa48，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0xaa5c，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xaa6c，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaa7c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xaa90，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xaaa4，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xaab8，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xaac8，81号。
        do local r=H.read(a,v,-1);local angle=(v.l[0] or 0);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xaae8，403号。
        H.gun_offset(a,0,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xab04，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xab18，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xab2c，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xab40，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xab50，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xab60，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xab74，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0xab90，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xaba4，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xabc4，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xabd8，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xabec，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xabfc，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xac10，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xac24，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xac38，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xac50，10号。
        return
    end
    P["BossCard5BombAt"]=B.part1
end

-- stage06boss.ecl：BossCard5BombAt2，0xac70；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xac70，40号。
        H.at(a,v,0)
        -- 源0xac84，400号。
        H.gun_new(a,0)
        H.at(a,v,0)
        -- 源0xac98，407号。
        H.gun_aim(a,0,3)
        H.at(a,v,0)
        -- 源0xacb0，402号。
        H.gun_sprite(a,0,0,0)
        H.at(a,v,0)
        -- 源0xaccc，406号。
        H.gun_count(a,0,1,1)
        H.at(a,v,0)
        -- 源0xace8，404号。
        H.gun_angle(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xad04，435号。
        H.gun_speed_diff(a,0,0.5,0.5,0.5,2.0,1.5,1.5,1.5,1.5)
        H.at(a,v,0)
        -- 源0xad38，409号。
        H.gun_transform(a,0,0,0,268435456,1,-999999,-999999.0,-999999.0)
        H.at(a,v,0)
        -- 源0xad68，44号。
        H.push(v,3.1415929794311523)
        H.at(a,v,0)
        -- 源0xad7c，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xad90，356号。
        v.l[16]=H.f32(0.06981316953897476)
        H.at(a,v,0)
        -- 源0xadb4，12号。
        v.origin=H.clock(a)-(0);return B.part3(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xadcc，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xade0，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xadf4，42号。
        H.push(v,80)
        H.at(a,v,0)
        -- 源0xae08，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xae18，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xae28，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xae3c，44号。
        H.push(v,H.read(a,v,-9939))
        H.at(a,v,0)
        -- 源0xae50，42号。
        H.push(v,2)
        H.at(a,v,0)
        -- 源0xae64，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xae74，81号。
        do local r=H.read(a,v,-1);local angle=(v.l[0] or 0);v.l[4]=H.f32(math.cos(angle)*r);v.l[8]=H.f32(math.sin(angle)*r) end
        H.at(a,v,0)
        -- 源0xae94，403号。
        H.gun_offset(a,0,(v.l[4] or 0),(v.l[8] or 0))
        H.at(a,v,0)
        -- 源0xaeb0，44号。
        H.push(v,(v.l[0] or 0))
        H.at(a,v,0)
        -- 源0xaec4，44号。
        H.push(v,H.read(a,v,-9998))
        H.at(a,v,0)
        -- 源0xaed8，42号。
        H.push(v,20)
        H.at(a,v,0)
        -- 源0xaeec，57号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left/right)) end
        H.at(a,v,0)
        -- 源0xaefc，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xaf0c，45号。
        v.l[0]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xaf20，404号。
        H.gun_angle(a,0,(v.l[0] or 0),0.0)
        H.at(a,v,0)
        -- 源0xaf3c，401号。
        H.fire(a,0)
        H.at(a,v,0)
        -- 源0xaf50，368号。
        v.origin=v.origin+H.int(2)
        H.at(a,v,0)
        -- 源0xaf70，44号。
        H.push(v,(v.l[12] or 0))
        H.at(a,v,0)
        -- 源0xaf84，44号。
        H.push(v,(v.l[16] or 0))
        H.at(a,v,0)
        -- 源0xaf98，51号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,H.f32(left+right)) end
        H.at(a,v,0)
        -- 源0xafa8，45号。
        v.l[12]=H.f32(H.pop(v))
        H.at(a,v,0)
        -- 源0xafbc，82号。
        v.l[12]=H.f32(H.angle((v.l[12] or 0)))
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xafd0，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xafe4，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xaffc，10号。
        return
    end
    P["BossCard5BombAt2"]=B.part1
end

-- stage06boss.ecl：BossCard5BombOut，0xb01c；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb01c，40号。
        H.at(a,v,0)
        -- 源0xb030，12号。
        v.origin=H.clock(a)-(0);return B.part5(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb048，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0xb05c，42号。
        H.push(v,-192)
        H.at(a,v,0)
        -- 源0xb070，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb080，44号。
        H.push(v,H.read(a,v,-9997))
        H.at(a,v,0)
        -- 源0xb094，42号。
        H.push(v,192)
        H.at(a,v,0)
        -- 源0xb0a8，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb0b8，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb0c8，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0xb0dc，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb0f0，64号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left<right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb100，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb110，44号。
        H.push(v,H.read(a,v,-9996))
        H.at(a,v,0)
        -- 源0xb124，42号。
        H.push(v,448)
        H.at(a,v,0)
        -- 源0xb138，68号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left>right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb148，73号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,((left~=0 or right~=0) and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb158，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part4(a,v) end
        return B.part3(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb170，263号。
        H.effect(a,0,176)
        H.at(a,v,0)
        -- 源0xb188，275号。
        H.anm_switch(a,0,2)
        H.at(a,v,0)
        -- 源0xb1a0，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,0)
        -- 源0xb1b8，336号。
        H.sound(a,54)
        H.at(a,v,0)
        -- 源0xb1cc，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb1e0，43号。
        H.write(a,-9983,H.int(H.pop(v)))
        H.at(a,v,0)
        -- 源0xb1f4，15号。
        H.async(a,P["BossCard5BombAt"],"BossCard5BombAt",nil)
        H.at(a,v,0)
        -- 源0xb218，10号。
        return
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb228，83号。
        v.origin=v.origin+H.int(1)
        return B.part5(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,0)
        -- 源0xb23c，42号。
        H.push(v,1)
        H.at(a,v,0)
        -- 源0xb250，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(0);return B.part2(a,v) end
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,0)
        -- 源0xb268，10号。
        return
    end
    P["BossCard5BombOut"]=B.part1
end

-- stage06boss.ecl：BossDead，0xb288；只编译Lunatic掩码。
do
    local B={}
    function B.part1(a,v)
        H.at(a,v,0)
        -- 源0xb288，40号。
        H.at(a,v,0)
        -- 源0xb29c，322号。
        H.flags(a,140,true)
        H.at(a,v,0)
        -- 源0xb2b0，263号。
        H.effect(a,0,76)
        H.at(a,v,0)
        -- 源0xb2c8，336号。
        H.sound(a,18)
        H.at(a,v,0)
        -- 源0xb2dc，263号。
        H.effect(a,0,141)
        H.at(a,v,0)
        -- 源0xb2f4，284号。
        H.velocity(a,0,H.read(a,v,-9998),0.4000000059604645)
        H.at(a,v,0)
        -- 源0xb30c，42号。
        H.push(v,H.read(a,v,-9986))
        H.at(a,v,0)
        -- 源0xb320，42号。
        H.push(v,0)
        H.at(a,v,0)
        -- 源0xb334，59号。
        do local right=H.pop(v);local left=H.pop(v);H.push(v,(left==right and 1 or 0)) end
        H.at(a,v,0)
        -- 源0xb344，13号。
        if H.pop(v)==0 then v.origin=H.clock(a)-(0);return B.part3(a,v) end
        return B.part2(a,v)
    end
    function B.part2(a,v)
        H.at(a,v,0)
        -- 源0xb35c，256号。
        H.spawn(a,256,"Ecl_EtBreak2",0.0,0.0,9999,0,0)
        H.at(a,v,0)
        -- 源0xb394，12号。
        v.origin=H.clock(a)-(0);return B.part4(a,v)
    end
    function B.part3(a,v)
        H.at(a,v,0)
        -- 源0xb3ac，256号。
        H.spawn(a,256,"Ecl_EtBreak2_ni",0.0,0.0,9999,0,0)
        return B.part4(a,v)
    end
    function B.part4(a,v)
        H.at(a,v,0)
        -- 源0xb3e4，367号。
        H.time_scale(a,0.5)
        H.at(a,v,60)
        -- 源0xb3f8，410号。
        H.cancel(a,1e9,true)
        H.at(a,v,60)
        -- 源0xb408，343号。
        H.spell_end(a)
        H.at(a,v,60)
        -- 源0xb418，345号。
        H.kill_all(a)
        H.at(a,v,60)
        -- 源0xb428，367号。
        H.time_scale(a,0.25)
        H.at(a,v,60)
        -- 源0xb43c，332号。
        H.boss_slot(a,-1)
        H.at(a,v,60)
        -- 源0xb450，330号。
        H.drop_main(a,0)
        H.at(a,v,60)
        -- 源0xb464，337号。
        H.shake(a,30,12,0)
        H.at(a,v,60)
        -- 源0xb480，263号。
        H.effect(a,0,76)
        H.at(a,v,60)
        -- 源0xb498，263号。
        H.effect(a,0,142)
        H.at(a,v,60)
        -- 源0xb4b0，336号。
        H.sound(a,18)
        H.at(a,v,60)
        -- 源0xb4c4，322号。
        H.flags(a,32,true)
        H.at(a,v,60)
        -- 源0xb4d8，284号。
        H.velocity(a,0,0.0,0.0)
        H.at(a,v,60)
        -- 源0xb4f0，42号。
        H.push(v,40)
        H.at(a,v,60)
        -- 源0xb504，43号。
        v.l[4]=H.int(H.pop(v))
        H.at(a,v,60)
        -- 源0xb518，12号。
        v.origin=H.clock(a)-(61);return B.part6(a,v)
    end
    function B.part5(a,v)
        H.at(a,v,61)
        -- 源0xb530，322号。
        H.flags(a,32,true)
        return B.part6(a,v)
    end
    function B.part6(a,v)
        H.at(a,v,61)
        -- 源0xb544，78号。
        H.push(v,(v.l[4] or 0))
        v.l[4]=H.int((v.l[4] or 0)-1)
        H.at(a,v,61)
        -- 源0xb558，14号。
        if H.pop(v)~=0 then v.origin=H.clock(a)-(60);return B.part5(a,v) end
        return B.part7(a,v)
    end
    function B.part7(a,v)
        H.at(a,v,61)
        -- 源0xb570，367号。
        H.time_scale(a,1.0)
        H.at(a,v,61)
        -- 源0xb584，1号。
        H.erase(a);return
    end
    P["BossDead"]=B.part1
end

return P
