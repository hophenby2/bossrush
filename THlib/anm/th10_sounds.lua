-- 风神录的显式 playSound 调度。只维护音效用的标量/context，绝不推进战斗对象或消耗弹幕随机数。
-- 弹枪与变换音仍在真实发弹/变换处播放；这里补齐蓄力、开符和独立提示声。
local T={banks={}}
local bit=bit or require('bit')
local scalar=require('ffi').new('union {float f; int32_t i;}[1]')
local function f32(v) scalar[0].f=v;return scalar[0].f end
local function trunc(v) return v<0 and math.ceil(v) or math.floor(v) end
local function context(name,args,id)
    local vars={}
    for i,v in ipairs(args or {}) do vars[(i-1)*4]=v end
    return {name=name,pc=1,time=0,vars=vars,stack={},returns={},id=id}
end
local function pop(c)
    local n=#c.stack;local v=assert(c.stack[n],'原作音效表达式栈为空')
    c.stack[n]=nil;return v
end
local function push(c,v) c.stack[#c.stack+1]=v end
local function random(s)
    s.seed=s.seed*16807%2147483647;return s.seed/2147483647
end
local function value(s,c,a)
    if type(a)~='table' then return a end
    local n=a.var
    if n==-1 then return pop(c) end
    if n>=0 then return c.vars[n] or 0 end
    if s.vars[n]~=nil then return s.vars[n] end
    local o=s.owner
    if n>=-9985 and n<=-9978 then
        o=o.th10carrier or o
        return o[(n<=-9982 and 'I'..(n+9985) or 'F'..(n+9981))] or 0
    end
    if n==-10000 then return trunc(random(s)*4294967296) end
    if n==-9999 then return random(s) end
    if n==-9998 then return random(s)*2*math.pi-math.pi end
    if n==-9987 then return random(s)*2-1 end
    if n==-9997 or n==-9977 then return o.x end
    if n==-9996 or n==-9976 then return 224-o.y end
    if n==-9995 or n==-9975 then return o.ecs and o.ecs.off.x or o.x end
    if n==-9994 or n==-9974 then return o.ecs and o.ecs.off.y or 224-o.y end
    if n==-9993 or n==-9973 then return o.ecs and o.ecs.base.x or 0 end
    if n==-9992 or n==-9972 then return o.ecs and o.ecs.base.y or 0 end
    if n==-9991 or n==-9965 then return player.x end
    if n==-9990 or n==-9964 then return 224-player.y end
    if n==-9989 or n==-9956 or n==-9955 then return math.atan2(o.y-player.y,player.x-o.x) end
    if n==-9988 then return s.clock end
    if n==-9986 then return bit.band(o.t10_flags or 0,0x10000)~=0 and 1 or 0 end
    if n==-9958 then return -(o.rot or 0)*math.pi/180 end
    if n==-9954 then return o.hp or 0 end
    if n>=-9953 and n<=-9950 then return n==-9950 and 1 or 0 end
    if n==-9963 then return (o.t10_bossref or o).x end
    if n==-9962 then return 224-(o.t10_bossref or o).y end
    if n==-9960 then return 0 end
    if n==-9959 then return 3 end
    if n==-9957 then return 1 end
    error('未接入的原作音效外部变量：'..n)
end
local function put(s,c,a,v,floating)
    assert(type(a)=='table','原作音效标量目标不是变量')
    v=floating and f32(v) or bit.tobit(trunc(v))
    if a.var>=0 then c.vars[a.var]=v else s.vars[a.var]=v end
end
local function call(s,c,name,args,async,id)
    if not s.bank.scripts[name] then return end
    if async then
        if s.bank.active[name] then s.threads[#s.threads+1]=context(name,args,id) end
    else
        c.returns[#c.returns+1]={name=c.name,pc=c.pc,time=c.time,vars=c.vars,stack=c.stack}
        local child=context(name,args)
        c.name,c.pc,c.time,c.vars,c.stack=child.name,child.pc,child.time,child.vars,child.stack
    end
end
local function run(s,c,play)
    local steps=0
    while not c.done do
        local row=s.bank.scripts[c.name][c.pc]
        if not row then c.done=true;break end
        if row[1]>c.time then break end
        c.pc=c.pc+1
        steps=steps+1;assert(steps<100000,'原作音效出现零帧循环：'..c.name)
        if bit.band(row[3],8)~=0 then
            local op=row[2]
            local function get(i) return value(s,c,row[i+3]) end
            if op==0 or op==30 then
                for i=4,#row do if type(row[i])=='table' and row[i].var==-1 then pop(c) end end
            elseif op==1 then c.done=true
            elseif op==10 then
                local p=table.remove(c.returns)
                if not p then c.done=true else
                    c.name,c.pc,c.time,c.vars,c.stack=p.name,p.pc,p.time,p.vars,p.stack
                end
            elseif op==11 or op==15 or op==16 then
                local args={};local start=op==16 and 3 or 2
                for i=start,#row-3 do args[#args+1]=get(i) end
                call(s,c,get(1),args,op~=11,op==16 and get(2) or nil)
            elseif op>=12 and op<=14 then
                local jump=op==12
                if not jump then local n=pop(c);jump=op==13 and n==0 or op==14 and n~=0 end
                if jump then c.pc,c.time=get(1),get(2) end
            elseif op==17 then
                local id=get(1)
                for _,thread in ipairs(s.threads) do if thread.id==id then thread.done=true end end
            elseif op==21 then
                for _,thread in ipairs(s.threads) do if thread~=c then thread.done=true end end
            elseif op==18 or op==19 or op==20 or op==40 or op==41 then
                -- context 的局部变量和返回帧由 call/return 显式保存。
            elseif op==42 or op==44 then push(c,get(1))
            elseif op==43 or op==45 then put(s,c,row[4],pop(c),op==45)
            elseif op>=50 and op<=70 then
                local right,left=pop(c),pop(c)
                local result
                if op==50 or op==51 then result=left+right
                elseif op==52 or op==53 then result=left-right
                elseif op==54 or op==55 then result=left*right
                elseif op==56 or op==57 then result=left/right
                elseif op==58 then result=math.fmod(left,right)
                elseif op==59 or op==60 then result=left==right and 1 or 0
                elseif op==61 or op==62 then result=left~=right and 1 or 0
                elseif op==63 or op==64 then result=left<right and 1 or 0
                elseif op==65 or op==66 then result=left<=right and 1 or 0
                elseif op==67 or op==68 then result=left>right and 1 or 0
                else result=left>=right and 1 or 0 end
                if op<=58 then result=op%2==1 and f32(result) or bit.tobit(trunc(result)) end
                push(c,result)
            elseif op==71 or op==72 then push(c,pop(c)==0 and 1 or 0)
            elseif op>=73 and op<=77 then
                local right,left=pop(c),pop(c)
                local result
                if op==73 then result=(left~=0 or right~=0) and 1 or 0
                elseif op==74 then result=(left~=0 and right~=0) and 1 or 0
                elseif op==75 then result=bit.bxor(left,right)
                elseif op==76 then result=bit.bor(left,right)
                else result=bit.band(left,right) end
                push(c,result)
            elseif op==78 then local v=get(1);put(s,c,row[4],v-1);push(c,v)
            elseif op==79 or op==80 then push(c,f32((op==79 and math.sin or math.cos)(pop(c))))
            elseif op==81 then
                local a,r=get(3),get(4)
                put(s,c,row[4],math.cos(a)*r,true);put(s,c,row[5],math.sin(a)*r,true)
            elseif op==82 then
                local v=get(1);local pi=3.1415927410125732
                while v>pi do v=f32(v-2*pi) end;while v< -pi do v=f32(v+2*pi) end
                put(s,c,row[4],v,true)
            elseif op==83 then c.time=c.time-get(1)
            elseif op==84 then push(c,bit.tobit(-pop(c)))
            elseif op==85 then scalar[0].f=pop(c);scalar[0].i=-scalar[0].i;push(c,scalar[0].f)
            elseif op==86 then local x,y=get(2),get(3);put(s,c,row[4],x*x+y*y,true)
            elseif op==87 then local x,y,tx,ty=get(1),get(2),get(3),get(4);push(c,f32(math.atan2(ty-y,tx-x)))
            elseif op==355 or op==356 then put(s,c,row[4],get(5),op==356)
            elseif op==349 or op==352 then put(s,c,row[4],get(3),op==349)
            elseif op==350 or op==353 then put(s,c,row[4],get(4),op==350)
            elseif op==351 or op==354 then put(s,c,row[4],(get(2)+get(3))/2,op==351)
            elseif op==368 then c.time=c.time-get(4)
            elseif op==336 then play(10,get(1),s.owner.x)
            else error('未接入的原作音效控制指令：'..op) end
        end
    end
    c.time=c.time+1
end
function T.bind(o,game,key)
    o._original_sound_program=nil
    if game~=10 then return end
    local file,name=key:match('^([^:]+):(.+)$')
    if not file then return end
    local bank=T.banks[file]
    if bank==nil then
        bank=dofile('mod/GAME/original/sound_programs.d/10_'..file..'.lua');T.banks[file]=bank
    end
    if not bank.active[name] then return end
    local seed=1
    for i=1,#key do seed=(seed*31+key:byte(i))%2147483647 end
    o._original_sound_program={owner=o,bank=bank,threads={context(name)},vars={},clock=-1,seed=seed}
end
function T.advance(o,clock,play)
    local s=o._original_sound_program
    if not s then return end
    while s.clock<clock do
        s.clock=s.clock+1
        local i=1
        while i<=#s.threads do local c=s.threads[i];if not c.done then run(s,c,play) end;i=i+1 end
        local count=0
        for n=1,#s.threads do
            local c=s.threads[n]
            if not c.done then count=count+1;s.threads[count]=c end
        end
        for n=#s.threads,count+1,-1 do s.threads[n]=nil end
    end
end
return T
