-- EnvironmentSSS01..06/Ex and BackgroundGroupSSS01. Angles use source radians.
local S={}
local pi,sin,cos,atan=math.pi,math.sin,math.cos,math.atan
local function add(s,name,x,y,fields,first)
    local o={name=name,x=x,y=y,z=0,rx=0,ry=0,angle=0,scale=1,alpha=255,maxAlpha=255,time=0,v=0,dir=0,rgb={255,255,255}}
    for k,v in pairs(fields or {}) do o[k]=v end
    if first then table.insert(s.objects,1,o) else s.objects[#s.objects+1]=o end
    return o
end
local function particle(s,name,x,y,fields)
    local o=add({objects=s.particles},name,x,y,fields);o.particle=true;return o
end
local function ran(s,a,b) s.seed=s.seed*48271%2147483647;return a+math.floor(s.seed/2147483647*(b-a)) end
local function angle(s) return atan((s.at[3]-s.eye[3])/(s.at[2]-s.eye[2])) end
local function fog(s) if s.time>50 then s.fogStart=math.min(10,s.fogStart+1);s.fogEnd=math.min(900,s.fogEnd+20) end end
local function forward(s)
    s.eye[2],s.at[2]=s.eye[2]+s.velocity,s.at[2]+s.velocity
    s.eye[1],s.at[1]=40*sin(s.time/360),40*sin((s.time-60)/360)
end
local function prune(s,n)
    for i=#s.objects,1,-1 do if s.objects[i].y<s.eye[2]-n then table.remove(s.objects,i) end end
end
local function trees(s,ex)
    while s.y3<s.eye[2]+4200 do
        local a=ex and angle(s) or 0
        for i,row in ipairs({{300,0,false},{-300,0,true},{300,200,true},{-300,200,false}}) do
            add(s,ex and (i<3 and 'Tree2' or 'Tree1') or '柳树',row[1],s.y3+row[2],{rx=-pi/2+a,height=ex and (i<3 and 233 or 225)*cos(a) or 400,mirror=row[3]},true)
        end
        s.y3=s.y3+400
    end
    if not ex then
        while s.y1<s.eye[2]+3072 do add(s,'地砖',0,s.y1,{rx=-pi},true);s.y1=s.y1+256 end
    end
    while s.y2<s.eye[2]+1950 do add(s,ex and '草地ex' or '草地',0,s.y2,{rx=-pi,scale=ex and 2 or 5},true);s.y2=s.y2+(ex and 486 or 1625) end
    prune(s,1000)
end
local function glow(s,large)
    local a=angle(s)
    add(s,'591-1',ran(s,large and -400 or -200,large and 400 or 200),s.eye[2]+ran(s,100,500),{
        scale=ran(s,large and 80 or 40,large and 100 or 60)/100,sv=-.004,v=ran(s,-10,10)/20,
        dir=ran(s,0,360)*pi/180,vz=ran(s,6,15)/20,life=200,active=true,rx=-pi/2+a,
        alpha=0,av=10,z=large and s.eye[3]-200 or 0})
end
local function aurora(s)
    particle(s,'极光素材',192,125,{alpha=128,active=true,rgb={0,0,0},aurora=true})
end
local function update(o,s)
    o.time=o.time+1;o.x=o.x+o.v*cos(o.dir);o.y=o.y+o.v*sin(o.dir)
    o.z=o.z+(o.vz or 0);o.angle=o.angle+(o.spin or 0)
    o.alpha=math.max(0,math.min(o.maxAlpha,o.alpha+(o.av or 0)))
    o.scale=math.max(.0001,o.scale+(o.sv or 0))
    if o.alphaEvents and o.alphaEvents[o.time] then o.av=o.alphaEvents[o.time] end
    if o.cloudPulse and o.time>100 then o.av=-pi/5*sin((s.time-100)/300*pi*2) end
    if o.aurora then
        if o.time*2<255 then o.rgb={o.time*2,o.time*2,o.time*2} end
        o.alpha=128+48*sin(o.time/200*pi*2)
    end
end
function S.new(chapter,offset)
    chapter=tostring(chapter)
    local s={chapter=chapter,time=0,story=0,objects={},particles={},seed=1181,y1=-1000,y2=-1000,y3=-1000,
        velocity=1,eye={0,0,170},at={0,200,170},up={0,0,1},fogStart=0,fogEnd=200,fogColor={0,0,0},fov=pi/2}
    if chapter=='1' then
        s.velocity=2;s.eye={0,2200,130};s.at={0,2400,50};s.fogEnd=50
        add(s,'BG01b',0,0,{floor=true})
        for i=0,19 do
            for _,row in ipairs({{290,100,true},{290,0,false},{-400,162,true},{-400,62,false}}) do
                add(s,'Tree',row[1],4200-i*200+row[2],{tree=true,mirror=row[3]})
            end
        end
        for i=0,9 do
            for _,x in ipairs({0,-1024,-2048}) do add(s,'Cloud02',x,i*500,{scale=2,z=-10,rx=-pi,alpha=50,v=.5}) end
            for _,x in ipairs({0,1024,2048}) do add(s,'Cloud01',x,i*500+250,{scale=2,z=-20,rx=-pi,alpha=50,v=-.5,mirror=true}) end
        end
    elseif chapter=='2' then s.eye[3],s.at[3]=70,70
    elseif chapter=='5' then
        s.eye={400,-460,210};s.at={400,0,0};s.fogEnd=0;s.fov=pi/4;add(s,'Stair',0,0)
    elseif chapter=='6' then s.velocity=.5;s.fov=pi/4
    elseif chapter=='EX' then s.eye[3]=250;s.fogColor={80,165,255} end
    for t=1,offset or 0 do S.step(s,t) end
    return s
end
function S.step(s,story)
    s.time=s.time+1;s.story=story or s.story+1
    local t,tm,c=s.time,s.story,s.chapter
    if c=='1' then
        if t%2048==0 then for _,o in ipairs(s.objects) do if not o.tree and not o.floor and o.name~='591-1' then o.x=o.x-1024 end end end
        if t%30==0 then glow(s) end
        if tm==6000 then s.boss=true end
        s.eye[2],s.at[2]=s.eye[2]+s.velocity,s.at[2]+s.velocity
        if s.eye[2]>3500 then
            s.eye[2],s.at[2]=s.eye[2]-2000,s.at[2]-2000
            for _,o in ipairs(s.objects) do if o.name=='591-1' then o.y=o.y-2000 end end
        end
        s.eye[1],s.at[1]=40*sin(t/180),40*sin(t/180);s.up={.02*sin(t/90),1,0}
        if s.boss then
            if s.eye[3]<430 then s.eye[3],s.at[3]=s.eye[3]+1,s.at[3]+1.05 end
            for _,o in ipairs(s.objects) do if not o.tree and not o.floor then o.alpha=math.max(0,o.alpha-.5) end end
            s.fogStart=math.min(230,s.fogStart+1);s.fogEnd=math.min(1010,s.fogEnd+1)
        elseif t<=980 then s.fogEnd=math.min(400,s.fogEnd+2)
        else s.fogStart=math.min(130,s.fogStart+1);s.fogEnd=math.min(510,s.fogEnd+1) end
    elseif c=='2' then
        while s.y3<s.eye[2]+1600 do
            for _,r in ipairs({{200,0,false},{-200,0,true},{200,100,true},{-200,100,false}}) do add(s,'zhu',r[1],s.y3+r[2],{rx=-pi/2,height=256,mirror=r[3]},true) end
            s.y3=s.y3+200
        end
        while s.y2<s.eye[2]+1500 do add(s,'BG02d',0,s.y2,{rx=-pi},true);s.y2=s.y2+310 end
        while s.y1<s.eye[2]+1500 do
            for _,x in ipairs({150,-150}) do
                add(s,'liba',x,s.y1,{angle=x>0 and pi/2 or -pi/2,ry=x>0 and -pi/2 or pi/2,height=45},true)
                add(s,'591-1R',x,s.y1,{scale=1.5,active=true,rx=-pi/2+angle(s),alpha=0,av=10,height=60},true)
            end
            s.y1=s.y1+133
        end
        prune(s,310);forward(s);fog(s)
    elseif c=='3' or c=='EX' then trees(s,c=='EX');forward(s);fog(s)
    elseif c=='4' then
        if tm<400 then fog(s);forward(s);trees(s)
        elseif tm>4000 and s.at[2]<500 then s.at[2]=s.at[2]+1 end
        if tm==550 then
            s.eye={0,0,250};s.at={0,0,0};s.up={0,1,1};s.objects={};add(s,'万花镜素材',0,0,{spin=pi/1800})
            add(s,'黑暗滤镜',0,0,{height=10,alphaEvents={[3350]=-5}});s.fogStart,s.fogEnd=0,2000000
        elseif tm==4300 then aurora(s) end
        if tm==8701 and #s.particles==0 then
            s.eye={0,0,250};s.at={0,500,0};s.up={0,1,1};add(s,'万花镜素材',0,0,{spin=pi/1800});s.fogStart,s.fogEnd=0,2000000;aurora(s)
        end
    elseif c=='5' then
        s.eye[2],s.at[2]=s.eye[2]+s.velocity,s.at[2]+s.velocity;s.eye[3],s.at[3]=s.eye[3]+s.velocity,s.at[3]+s.velocity
        if s.eye[2]>-100 then s.eye[2],s.at[2]=s.eye[2]-150,s.at[2]-150;s.eye[3],s.at[3]=s.eye[3]-150,s.at[3]-150 end
        local sway=cos(t/180);s.eye[1],s.at[1]=s.eye[1]+sway/18,s.at[1]+sway/18
        if t>100 and t<5050 then s.fogEnd=math.min(700,s.fogEnd+1) end
        local v=tm>400 and tm<700 and 1 or tm>=700 and tm<800 and .5 or tm>=800 and tm<850 and .2
        if v then s.eye[1],s.at[1]=s.eye[1]-v,s.at[1]-v end
        if tm>200 and tm<300 then s.eye[2],s.eye[3]=s.eye[2]+.5,s.eye[3]-.5
        elseif tm>1100 and tm<1400 then s.eye[1],s.at[1],s.eye[3]=s.eye[1]+.1,s.at[1]+.13,s.eye[3]-.1;s.up[1]=math.min(.03,s.up[1]+.0001)
        elseif tm>1800 and tm<2100 then
            if s.eye[1]>30 then s.eye[1]=s.eye[1]-.35 end;if s.at[1]<200 then s.at[1]=s.at[1]+.25 end
            s.eye[3]=s.eye[3]-.3;s.up[1]=s.up[1]-.0001
        end
        if tm>8200 and tm<8250 then particle(s,'云（亮层）',192+ran(s,-20,20),240+ran(s,-20,20),{alpha=0,av=.2,scale=2,rgb={128,128,128},alphaEvents={[300]=-.2},spin=ran(s,-50,50)/20*pi/180,z=(tm-8200)/10,life=1500}) end
        if tm==8601 then s.objects={};add(s,'祭坛',0,0,{scale=10});s.velocity=0;s.eye={0,-480,480};s.at={0,0,300};s.up={0,0,1};s.fogStart,s.fogEnd=200,700 end
        if tm>8600 then s.eye[1],s.at[1]=s.eye[1]+.1*sway,s.at[1]+sway/12;s.eye[2],s.at[2]=s.eye[2]-sway/17,s.at[2]-sway/13 end
    elseif c=='6' then
        fog(s);s.velocity=math.max(.5,s.velocity);forward(s)
        if tm==3 then particle(s,'BG01a',192,224,{alphaEvents={[500]=-2}});add(s,'祭坛',0,0,{scale=10});s.velocity=0;s.eye={0,-550,280};s.at={0,0,100};s.up={0,0,1} end
        if tm>0 and tm<800 then s.at[3],s.eye[3]=s.at[3]+1.5,s.eye[3]+1.5
        elseif tm==800 then
            s.y2=s.y2-4000;s.objects={}
            while s.y2<s.eye[2]+6132 do
                add(s,'云（亮层）',0,s.y2,{scale=3,z=s.eye[3]-200,rx=-pi,alpha=0,maxAlpha=250,av=2.5},true)
                add(s,'Cloud01',0,s.y2+250,{scale=3,mirror=true,z=s.eye[3]-180,rx=-pi,alpha=0,maxAlpha=50,av=.5,v=.5,dir=-pi/2,cloudPulse=true})
                s.y2=s.y2+1314
            end
        elseif tm>800 then
            if tm<1000 then s.eye[3]=s.eye[3]+1 end
            if tm<8000 and t%10==0 then glow(s,true) end
            if tm>8000 and tm<8200 then s.at[3]=s.at[3]+1.5 end
        end
        if tm==8200 then particle(s,'夜空（暗）',192,224,{alpha=0,av=3}) end
        if tm==8401 and #s.particles==0 then particle(s,'夜空（暗）',192,224) end
        prune(s,1000)
    end
    for _,list in ipairs({s.objects,s.particles}) do
        for i=#list,1,-1 do local o=list[i]
            if o.life and o.time>o.life then table.remove(list,i) else update(o,s) end
        end
    end
end
function S.fade(s)
    local delay,life=200,320
    if s.chapter=='EX' then delay=0
    elseif s.chapter=='4' then delay,life=20,150
    elseif s.chapter=='6' then delay,life=30,250 end
    local a=math.max(0,255-math.max(0,s.time-1-delay)*(math.floor(255/(life-delay))+1))
    if s.chapter=='4' then
        if s.story>=550 then a=math.max(a,math.max(0,255-(s.story-549)))
        elseif s.story>=150 then a=math.max(a,math.min(255,s.story-149)) end
    end
    return a
end
S.add=add
return S
