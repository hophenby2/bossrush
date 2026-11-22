-- 发行包中的标题组件和音效。标题逐原作 120 Hz 更新，保持世界坐标与组件执行顺序。
local P={data=dofile('mod/GAME/th38/release_presentation.lua')}
local D=P.data
local floatBox=require('ffi').new('float[1]')
local function f32(x) floatBox[0]=x;return floatBox[0] end
local sounds,images,ready={},{},false
function P.prepare()
    if ready then return end
    local old=GetResourceStatus();SetResourceStatus('global')
    for name,cfg in pairs(D.sounds) do
        if not sounds[name] then
            local id='asl_source_'..name
            LoadSound(id,cfg.file);sounds[name]=id
        end
    end
    SetResourceStatus(old)
    ready=true
end
function P.sound(name,x,volume)
    P.prepare()
    PlaySound(assert(sounds[name],'雪莲华音效未导出：'..name),volume or 1,math.max(-1,math.min(1,(x or 0)/192)))
end
local shotNames={'magical25_dam_ice2','gun10','gun10_big','magical25_dam_ice','power24_zer','don20_gongji','tm2_bom003_hedan','mecha04'}
function P.shot(e,x)
    local kind=e.a2_5==1 and e.a2_6 or 1
    if kind~=0 then P.sound(assert(shotNames[kind],'雪莲华发弹音效编号无效：'..kind),(x-4.5)*48) end
end
local freeVoices,voiceSerial,voices={},0,{}
function P.audioSource(cfg,position)
    local c={clip=cfg.clip,volume=cfg.volume,pitch=cfg.pitch,loop=cfg.loop,mute=cfg.mute,isPlaying=false,time=0}
    local id,loadedClip,ticks,lastVolume,lastPitch
    function c:Stop()
        if id then StopSound(id) end
        self.isPlaying=false;self.time=0
    end
    function c:Play()
        if not self.clip then return end
        local sample=assert(D.sounds[self.clip],'雪莲华 prefab 音源缺失：'..self.clip)
        if loadedClip~=self.clip then
            if id then self:Dispose() end
            local pool=freeVoices[self.clip] or {};freeVoices[self.clip]=pool
            id=table.remove(pool)
            if not id then
                voiceSerial=voiceSerial+1;id='asl_voice_'..voiceSerial
                local previous=GetResourceStatus();SetResourceStatus('global')
                LoadSound(id,sample.file);SetResourceStatus(previous)
            end
            loadedClip=self.clip
        end
        if SetSESpeed then SetSESpeed(id,self.pitch) end
        local x=position()
        PlaySound(id,self.mute and 0 or self.volume,math.max(-1,math.min(1,(x-4.5)/4)))
        lastVolume,lastPitch=self.mute and 0 or self.volume,self.pitch
        ticks=sample.samples/sample.rate*120/self.pitch
        self.isPlaying,self.time=true,0
        voices[self]=true
    end
    function c:FixedUpdate()
        if not self.isPlaying then return end
        local volume=self.mute and 0 or self.volume
        if volume~=lastVolume then lstg.SetSourceSoundVolume(id,volume);lastVolume=volume end
        if self.pitch~=lastPitch then
            SetSESpeed(id,self.pitch);ticks=ticks*lastPitch/self.pitch;lastPitch=self.pitch
        end
        self.time=self.time+1/120
        ticks=ticks-1
        if ticks<=0 then
            if self.loop then self:Play() else self.isPlaying=false end
        end
    end
    function c:Dispose()
        self:Stop()
        if id then freeVoices[loadedClip][#freeVoices[loadedClip]+1]=id end
        id,loadedClip=nil,nil
        voices[self]=nil
    end
    return c
end
function P.clearAudio()
    for c in pairs(voices) do c:Dispose() end
    for _,id in pairs(sounds) do StopSound(id) end
end
local function image(name)
    if images[name] then return images[name] end
    local cfg=D.sprites[name];local id='asl_title_'..name
    local pool=GetResourceStatus();SetResourceStatus('global')
    LoadTexture(id,cfg.file);LoadImage(id,id,0,0,unpack(cfg.size))
    SetImageCenter(id,cfg.size[1]*cfg.pivot[1],cfg.size[2]*(1-cfg.pivot[2]))
    SetResourceStatus(pool);images[name]=id
    return id
end
local function clone(cfg,parent)
    local n={x=cfg.position[1],y=cfg.position[2],sx=cfg.scale[1],sy=cfg.scale[2],
        rot=math.deg(2*math.atan2(cfg.rotation[3],cfg.rotation[4])),cfg=cfg,parent=parent,children={},scripts={}}
    if cfg.color then n.alpha=cfg.color[4] end
    for _,script in ipairs(cfg.scripts) do
        local s={clock=0};for k,v in pairs(script) do s[k]=v end
        n.scripts[#n.scripts+1]=s
    end
    for _,child in ipairs(cfg.children) do n.children[#n.children+1]=clone(child,n) end
    if cfg.sprite then image(cfg.sprite) end
    return n
end
local function step(n)
    for _,s in ipairs(n.scripts) do if not s.done then
        local t=s.clock;local kind=s.kind
        if kind=='Tongyong_death' then
            if t>=s.time then n.dead=true end
        elseif kind=='Tongyong_xuanzhuan' then n.rot=f32(n.rot+s.zhuansu)
        elseif kind=='Tongyong_translate' then
            assert(s.random_xy==0,'标题没有随机位移组件')
            n.x=f32(n.x+s.v3.x*cos(n.rot)-s.v3.y*sin(n.rot))
            n.y=f32(n.y+s.v3.x*sin(n.rot)+s.v3.y*cos(n.rot))
        elseif kind=='Tongyong_jianxianjianyin' then
            if t>=s.time_yanshi then
                local delta=(s.a_kuadu~=0 and s.a_kuadu or 1)/s.time_long*(s.jianxian_or_jianyin~=0 and 1 or -1)
                n.alpha=f32(n.alpha+delta)
            end
            if t==s.time_yanshi+s.time_long then
                if s.a_kuadu==0 then n.alpha=s.jianxian_or_jianyin~=0 and 1 or 0 end
                s.done=true
            end
        elseif kind=='Tongyong_weiyi' then
            if t==s.time_yanshi then
                s.dx,s.dy=s.chushix-n.x,s.chushiy-n.y
            end
            if t>=s.time_yanshi then
                local k=math.pi/(2*s.time)*math.sin(math.pi*(t-s.time_yanshi)/s.time)
                n.x,n.y=f32(n.x+s.dx*k),f32(n.y+s.dy*k)
            end
            if t+1==s.time_yanshi+s.time then s.done=true end
        elseif kind=='Tongyong_suofang' then
            if t==s.time_yanshi then s.dx,s.dy=n.sx-s.mubiao_x,n.sy-s.mubiao_y end
            if t>=s.time_yanshi then
                local k=s.zhijie_or_sin~=0 and 1/s.time_chixu or math.pi/(2*s.time_chixu)*math.sin(math.pi*(t-s.time_yanshi)/s.time_chixu)
                n.sx,n.sy=f32(n.sx-s.dx*k),f32(n.sy-s.dy*k)
            end
            if t==s.time_yanshi+s.time_chixu then
                if s.zhijie_or_sin==0 then n.sx,n.sy=s.mubiao_x,s.mubiao_y end
                s.done=true
            end
        end
        s.clock=t+1
    end end
    for _,child in ipairs(n.children) do step(child) end
end
local function draw(n,x,y,rot,sx,sy)
    if n.dead then return end
    local dx,dy=n.x*sx,n.y*sy
    x,y=x+dx*cos(rot)-dy*sin(rot),y+dx*sin(rot)+dy*cos(rot)
    rot,sx,sy=rot+n.rot,sx*n.sx,sy*n.sy
    if n.cfg.sprite then
        local id=image(n.cfg.sprite);local cfg=D.sprites[n.cfg.sprite];local color=n.cfg.color
        SetImageState(id,'',math.max(0,math.min(1,n.alpha))*255,color[1]*255,color[2]*255,color[3]*255)
        Render(id,(x-4.5)*48,(y+4.8)*48,rot,sx*48/cfg.ppu,sy*48/cfg.ppu)
    end
    for _,child in ipairs(n.children) do draw(child,x,y,rot,sx,sy) end
end
local Title=Class(object,{
    init=function(o,cfg)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.BG+1,false,false
        o.root=clone(cfg)
    end,
    frame=function(o)
        step(o.root);step(o.root)
        if o.root.dead then object.RawDel(o) end
    end,
    render=function(o) draw(o.root,0,0,0,1,1) end,
})
function P.title(chapter,first,last)
    local cfg=D.titles[chapter]
    if cfg and first<=cfg.time and last>=cfg.time then New(Title,cfg.root) end
end
return P
