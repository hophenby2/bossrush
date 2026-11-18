-- BackGround.cs的独立时间轴。背景等待Boss/BGM/模型到达时仍继续运动。
local S={}
local function copy(v) local r={};for i,x in ipairs(v) do r[i]=x end;return r end
local function model(name,label,pos,cutout,blend,depth)
    return {name=tostring(name),label=tostring(label),pos=pos or {0,0,0},cutout=cutout,blend=blend,
        depth=depth,alpha=1,color={1,1,1},scale={1,1,1},rotation={0,0,0},changes={}}
end
local function find(s,label) for _,m in ipairs(s.models) do if m.label==tostring(label) then return m end end end
S.find=find
local function transition(changes,vector,index,target,time,smooth)
    if time==0 then vector[index]=target;changes[index]=nil
    else changes[index]={from=vector[index],to=target,time=time,smooth=smooth} end
end
local function change(vector,changes)
    for i,c in pairs(changes) do
        vector[i]=vector[i]+(c.to-(c.smooth and vector[i] or c.from))/c.time
        if math.abs(vector[i]-c.to)<.001 then vector[i]=c.to;changes[i]=nil end
    end
end
local function command(s,c)
    local op=c[2];local a={unpack(c,3)}
    local m=find(s,a[1])
    if op=='SetModel' then s.models[#s.models+1]=model(a[1],a[5],{a[2],a[3],a[4]},a[6],a[7],a[8])
    elseif op=='PrepareModel' or op=='ActiveModel' then if m then m.prepare=op=='PrepareModel' end
    elseif op=='PutModelOnFront' then if m then m.pos[3]=m.pos[3]+s.travel[3] end
    elseif op=='PutModelOnNextLoop' then
        local z=s.nextloop;if z-s.travel[3]<s.loopdistance then z=z+s.loopdistance end
        if m then m.pos[3]=m.pos[3]+z end
    elseif op=='AnimateModelUV' then if m then m.uv={a[2],a[3]} end
    elseif op=='ResetModelOrder' then
        if m then for i,o in ipairs(s.models) do if m==o then table.remove(s.models,i);break end end;table.insert(s.models,a[2]+1,m) end
    elseif op=='DelModel' then for i=#s.models,1,-1 do if s.models[i].label==tostring(a[1]) then table.remove(s.models,i) end end
    elseif op=='SetRunningStep' or op=='SetRunningStepX' or op=='SetRunningStepY' then
        local i=op=='SetRunningStepX' and 1 or op=='SetRunningStepY' and 2 or 3
        s.speedTarget[i],s.speedTime[i]=a[1],a[2]
        if i==3 and a[2]==0 then s.speed[i]=a[1] end
    elseif op=='SetLoopOffset' then s.loopoffset=a[1]
    elseif op=='SetLoopDistance' then s.loopdistance=a[1]
    elseif op=='ClearRunningStep' or op=='ClearLoopStep' then
        s.steps,s.nextloop,s.thisloop=0,0,false
        if op=='ClearRunningStep' then s.travel={0,0,0} end
    elseif op=='SetStopLoop' then s.stoploop=a[1]
    elseif op=='UntilModelComing' then if m then s.mode,s.zcondition='model',m.pos[3]+a[2] end
    elseif op=='UntilBGMSwitch' then s.mode='music'
    elseif op=='SetWaitBoss' then s.waitboss=a[1]
    elseif op=='SetColor' then
        m=find(s,a[5]);if m then for i=1,3 do transition(m.changes,m.color,i,a[i],a[4]) end end
    elseif op=='SetAlpha' then
        m=find(s,a[3]);if m then m.alphaChange={m.alpha,a[1],a[2]};if a[2]==0 then m.alpha=a[1];m.alphaChange=nil end end
    elseif op=='ChangeView' or op=='ChangeTarget' then
        local vector,changes=op=='ChangeView' and s.eye or s.at,op=='ChangeView' and s.eyeChanges or s.atChanges
        for i=1,3 do if a[i]~=0 then transition(changes,vector,i,a[i],a[4],#a>4) end end
    elseif op=='ChangeField' then s.far=a[1]
    elseif op=='Shake' then s.shakeMax,s.shakeSpeed=a[1],a[2]
    elseif op=='LightSetting' then s.light=a[1]
    elseif op=='Open' or op=='Fadein' or op=='Fadeout' then s.fadeMode=op
    elseif op=='SetPraticleLauncher' then
        local m=model(a[1],a[21],nil,false,a[20],true);m.separate=true
        if a[21] then s.models[#s.models+1]=m end
        s.launchers[#s.launchers+1]={model=m,rectA={a[2],a[3],a[4]+s.travel[3]},rectB={a[5],a[6],a[7]+s.travel[3]},
            rotationRange={a[8],a[9],a[10]},speedRange={a[11],a[12],a[13]},attach=a[14],fade=a[15],
            quantity=a[16],interval=a[17],life=a[18],id=a[19],time=0}
    elseif op=='SetPraticle' then
        for _,l in ipairs(s.launchers) do if l.id==a[1] then
            l.scale={a[2],a[3],a[4]};l.particleLife=a[5];l.speed={a[6],a[7],a[8]}
            if #a>9 then l.accel={a[9],a[10],a[11]};l.rotation={a[12],a[13],a[14]};l.spin={a[15],a[16],a[17]};l.fadeTime=a[18]
            else l.accel,l.rotation,l.spin,l.fadeTime={0,0,0},{0,0,0},{0,0,0},a[9] end
            break
        end end
    else error('未知春雪背景命令：'..op) end
end
S.command=command
local function sample(s,a,b)
    s.seed=s.seed*48271%2147483647;return a+(b-a)*s.seed/2147483647
end
local function particles(s)
    for i=#s.launchers,1,-1 do
        local l=s.launchers[i]
        if l.dead then table.remove(s.launchers,i)
        else
            if l.attach then l.rectA[3]=l.rectA[3]+s.speed[3];l.rectB[3]=l.rectB[3]+s.speed[3] end
            l.time=l.time+1
            if l.time==l.interval then
                for _=1,l.quantity do
                    local p={model=l.model,scale=copy(l.scale),life=l.particleLife,time=0,pos={},speed={},rotation={},alpha=0,launcher=l}
                    for j=1,3 do
                        p.pos[j]=sample(s,l.rectA[j]/p.scale[j],l.rectB[j]/p.scale[j])
                        p.speed[j]=l.speed[j]+sample(s,-l.speedRange[j],l.speedRange[j])
                        p.rotation[j]=l.rotation[j]+sample(s,-l.rotationRange[j],l.rotationRange[j])
                    end
                    s.particles[#s.particles+1]=p
                end
                l.time=0
            end
            if l.time>=l.life then l.dead=true end
        end
    end
    for i=#s.particles,1,-1 do
        local p=s.particles[i];local l=p.launcher
        p.time=p.time+1
        for j=1,3 do p.speed[j]=p.speed[j]+l.accel[j];p.pos[j]=p.pos[j]+p.speed[j];p.rotation[j]=p.rotation[j]+l.spin[j] end
        if l.fade then
            if p.pos[2]<=0 and p.time<p.life then p.time=p.life end
            if p.time>=1 and p.time<=l.fadeTime then p.alpha=p.alpha+1/l.fadeTime
            elseif p.time>=p.life and p.time<=p.life+l.fadeTime then p.alpha=p.alpha-1/l.fadeTime end
        else p.alpha=1 end
        if p.time>=p.life and (p.alpha<=0 or not l.fade) then table.remove(s.particles,i) end
    end
end
function S.step(s,boss)
    while s.commands[s.pc] and s.commands[s.pc][1]==s.time do command(s,s.commands[s.pc]);s.pc=s.pc+1 end
    if s.fadeMode then
        s.fade=math.max(0,math.min(1,s.fade+(s.fadeMode=='Fadeout' and .04 or s.fadeMode=='Open' and -.0084 or -.04)))
        if s.fade==0 or s.fade==1 then s.fadeMode=nil end
    end
    local angle=math.sin(math.rad(s.shakeTime))*math.rad(s.shakeMax)
    s.up={math.sin(angle),math.cos(angle),0};s.shakeTime=(s.shakeTime+s.shakeSpeed)%360
    for i=1,3 do
        if s.speedTime[i]~=0 then s.speed[i]=s.speed[i]+(s.speedTarget[i]-s.speed[i])/s.speedTime[i] end
    end
    particles(s)
    for i=1,3 do s.travel[i]=s.travel[i]+s.speed[i] end
    s.steps=s.steps+s.speed[3]
    if not s.stoploop then
        for i=1,4 do
            local a,b=find(s,i..'001'),find(s,i..'002')
            if a and b and s.at[3]+s.travel[3]>1 then
                s.nextloop=(s.thisloop and a or b).pos[3]
                if s.steps>=s.loopdistance*(s.thisloop and 2 or 1)+s.loopoffset then (s.thisloop and b or a).pos[3]=s.nextloop+s.loopdistance end
            end
        end
        if s.at[3]+s.travel[3]>1 then
            if s.steps>=s.loopdistance+s.loopoffset and not s.thisloop then s.thisloop=true end
            if s.steps>=s.loopdistance*2+s.loopoffset and s.thisloop then s.thisloop=false;s.steps=0 end
        end
    end
    for i=1003,1006 do local m=find(s,i);if m then m.pos[3]=m.pos[3]+s.speed[3] end end
    local ground=find(s,1004)
    if ground and s.groundtime<=5040 then s.groundtime=s.groundtime+1;ground.pos[2]=ground.pos[2]-.02;ground.pos[3]=ground.pos[3]-.02 end
    if s.mode=='boss' then if not boss or not s.waitboss then s.time=s.time+1 end
    elseif s.mode=='model' and s.travel[3]>=s.zcondition then s.mode='boss' end
    for _,m in ipairs(s.models) do
        change(m.color,m.changes)
        local a=m.alphaChange
        if a then m.alpha=m.alpha+(a[2]-a[1])/a[3];if math.abs(m.alpha-a[2])<.001 then m.alpha=a[2];m.alphaChange=nil end end
    end
    change(s.eye,s.eyeChanges);change(s.at,s.atChanges)
    s.frame=s.frame+1
end
function S.new(chapter,clock,musicFrames)
    local s={commands=dofile('mod/GAME/th37/scenes/'..chapter..'.lua'),pc=1,time=0,frame=0,models={},launchers={},particles={},
        eye={0,165.122,-146.684},at={0,30.733,0},up={0,1,0},eyeChanges={},atChanges={},
        travel={0,0,0},speed={0,0,0},speedTarget={0,0,0},speedTime={0,0,0},steps=0,nextloop=0,
        loopdistance=642.759,loopoffset=0,groundtime=0,mode='boss',waitboss=true,shakeTime=0,shakeMax=0,shakeSpeed=0,
        far=1000,fade=1,seed=7919+chapter}
    for frame=1,clock or 0 do
        if musicFrames and musicFrames[frame] and s.mode=='music' then s.mode='boss' end
        S.step(s,false)
    end
    return s
end
return S
