local function EnumPNG(list, searchPath, func)
    for _, v in ipairs(lstg.FileManager.EnumFiles(searchPath, "png", true)) do
        local path = v[1]
        local name = path:sub(searchPath:len() + 1, -5)
        table.insert(list, function()
            func(name, path)
        end)
    end
end

local function LoadingImage()

    local list = {}
    EnumPNG(list, "Resources\\BossBackGround\\", LoadTexture2)
    EnumPNG(list, "Resources\\BossImage\\", LoadTexture)
    EnumPNG(list, "Resources\\Special\\", LoadImageFromFile)
    table.insert(list, function()
        Include('Resources\\System\\system.lua')
    end)
    for _, v1 in pairs(LoadRes) do
        table.insert(list, v1)
    end
    -- 新作卡表要等前面的注册脚本执行完才存在，但进度预算必须从启动起就固定。
    -- 预留与基础资源等量的进度单位；后续展开的子任务只分摊这份预算，不扩展总数。
    list[#list+1]={weight=math.max(#list,1),build=function()
        local tasks={}
        if RogueEncounter then RogueEncounter.appendStartup(tasks) end
        tasks[#tasks+1]=function() InitAllClass() end
        return tasks
    end}
    return list
end
LoadImageFromFile("loading", "THlib\\UI\\loading.png")

local string = string
local clock = lstg.AndroidClock or os.clock

local SetImageState = SetImageState
local SetFontState = SetFontState

local Render = Render
local RenderTTF = RenderTTF
local RenderText = RenderText
local RenderRect = RenderRect

local Color = Color
-- 手机留出绘制时间；单次资源加载完成后再检查墙钟预算，不在一帧内持续占满线程。
local time = AndroidPlatform and 1 / 120 or 1 / 60



local stage_init = stage.New('init', false, true)
function stage_init:init()
    math.randomseed(os.time())
    self.start_time = clock()
    self.res = LoadingImage()
    self.taskindex = 1
    self.index,self.maxindex = 0,0
    for _,res in ipairs(self.res) do
        self.maxindex=self.maxindex+(type(res)=='table' and res.weight or 1)
    end
    self.textindex = math.random(1, #TIP)
    self.text = TIP[self.textindex]
    self.settime = self.timer
    SetResourceStatus("global")
    task.New(self, function()
        while not self.jump do
            coroutine.yield()
        end
        mask_fader:Do("close")
        task.Wait(30)
        SetResourceStatus("stage")
        stage.Set('none', "menu")
    end)
end
function stage_init:frame()

    self.timer = int((clock() - self.start_time) * 60)
    if self.timer - self.settime > 150 then
        -- 单条直接使用；多条只抽一次，在索引映射时排除上一条，避免重试死循环。
        if #TIP>1 then
            local index=math.random(1,#TIP-1)
            self.textindex=index>=self.textindex and index+1 or index
        else
            self.textindex=1
        end
        self.text = TIP[self.textindex]
        self.settime = self.timer
    end
    if self.taskindex > #self.res then
        if AndroidPlatform and not self.jump then
            lstg.SystemLog(string.format('BOSSRUSH_STARTUP: resources_ready %.1f ms', (clock()-self.start_time)*1000))
        end
        self.jump = true
    elseif not self.jump then
        local res
        local start_time, end_time = clock(), clock()
        while end_time - start_time < time do
            if self.taskindex > #self.res then
                return
            end
            res = self.res[self.taskindex]
            if type(res)=='function' then
                res()
                self.index=self.index+1
                self.taskindex=self.taskindex+1
            else
                if not res.tasks then
                    res.tasks,res.index,res.start=res.build(),1,self.index
                end
                local run=res.tasks[res.index]
                if run then run();res.index=res.index+1 end
                self.index=res.start+res.weight*min((res.index-1)/#res.tasks,1)
                if res.index>#res.tasks then self.taskindex=self.taskindex+1 end
            end
            end_time = clock()
        end
    end
end
local function renderLoading(self)
    local portrait=AndroidPortrait and AndroidPortrait.enabled()
    if portrait and not AndroidPortrait.rendering then return AndroidPortrait.loading(self,renderLoading) end
    local center,left,right,barY,tipY,statusY,imageY,imageScale=480,150,810,62.5,170,25,270,1
    local tipSize=1
    if portrait then
        center=screen.width/2
        left,right=24,screen.width-24
        imageScale=(right-left)/960
        tipSize=.9
        -- 底图、完整tip区域、读条及状态组成居中的连续一组，避免长屏按百分比分散。
        -- 按整份tip列表预留高度，随机换tip不会让图片和读条上下跳动。
        local rows,step=1,30*tipSize
        for _,text in ipairs(TIP or {self.text}) do
            local lines,lineStep=ui:TipLayout(text,right-left,tipSize)
            rows,step=max(rows,#lines),lineStep
        end
        local imageHeight=540*imageScale
        local blockHeight=imageHeight+38+(rows-1)*step+52+44+16
        local top=(screen.height+blockHeight)/2
        imageY=top-imageHeight/2
        tipY=top-imageHeight-38
        barY=tipY-(rows-1)*step-52
        statusY=barY-44
        SetImageState('white','',Color(255,0,0,0))
        RenderRect('white',0,screen.width,0,screen.height)
    end
    Render('loading',center,imageY,0,imageScale,imageScale)
    ui:RenderText('title',"少女折寿中"..string.rep('.',int(self.timer/20%6)+1),
        center,statusY,1,Color(255,255,227,132),'centerpoint')
    local length=min(self.index/self.maxindex,1)
    local innerLeft,innerRight=left+2,right-2
    SetImageState('white','',255,255,255,255)
    RenderRect('white',left,right,barY-12.5,barY+12.5)
    SetImageState('white','',255,0,0,0)
    RenderRect('white',innerLeft,innerRight,barY-10.5,barY+10.5)
    SetImageState('white','',Color(180,255-155*length,255*length,100*length))
    RenderRect('white',innerLeft,innerLeft+length*(innerRight-innerLeft),barY-10.5,barY+10.5)
    SetFontState('Score','',Color(255,255*length,255-28*length,100+32*length))
    ui:RenderTip(self.text,center,tipY,right-left,tipSize,
        Color(255,250,128,114+50*sin(self.timer*2)))
    ui:RenderText('title',('%0.2f%% ( %d / %d ) '):format(length*100,min(self.index,self.maxindex),self.maxindex),
        center,barY,.8,Color(255,255*length,255-28*length,100+32*length),'centerpoint')
end

stage_init.render=renderLoading

-- 战斗入口与启动页共用底图和读条；先提交加载画面，再执行可能阻塞的场景初始化。
local L={}
ui.ResourceLoading=L
function L.beforeFrame()
    if SaveResume and SaveResume.recovering then L.state=nil;return false end
    local next=stage.next_stage
    if next and next.is_menu then L.state=nil;return false end
    local s=L.state
    if next and not next.is_menu and (not s or s.target~=next) then
        L.state={target=next,start=clock(),index=0,maxindex=3,text='正在准备战斗，请稍候。',timer=0}
        return true
    end
    if not s and RogueEncounter and RogueEncounter.preloading() then
        L.state={target=stage.current_stage,start=clock(),index=1,maxindex=3,text='正在准备战斗，请稍候。',timer=0,preload=true}
        return true
    end
    if not s then return false end
    if s.done then
        if not s.presented then return true end
        L.state=nil
        -- 入场淡入已在加载画面期间推进，不再让完成后的读条退回黑底。
        if mask_fader.mode then mask_fader.time=0 end
        return false
    end
    if s.preload then
        if RogueEncounter.preloading() then s.index=2;RogueEncounter.preloadFrame()
        else L.ready() end
        return true
    end
    if s.initialized then
        -- 只推进独立的资源准备协程；关卡任务、自机和对象帧均由主循环冻结。
        if RogueEncounter and RogueEncounter.preloading() then
            s.index=2
            RogueEncounter.preloadFrame()
        elseif s.prepare then
            task.Do(s.prepare)
            if s.prepared then s.prepare=nil end
        end
        L.afterFrame()
        return true
    end
    return false
end
function L.stageReady()
    local s=L.state
    if not s or s.target~=stage.current_stage then return end
    s.index=1;s.initialized=true
    local scene=stage.current_stage
    if scene.prepareResources then
        s.prepare={}
        task.New(s.prepare,function() scene:prepareResources();s.prepared=true end)
    else s.prepared=true end
end
function L.ready()
    local s=L.state
    if s and s.target==stage.current_stage then s.index=s.maxindex;s.done=true end
end
function L.afterFrame()
    local s=L.state
    if not s or s.done or not s.initialized or s.target~=stage.current_stage then return end
    if not s.prepared or RogueEncounter and RogueEncounter.preloading() then return end
    -- 初始化及资源任务完成即就绪，不再通过推进战斗等待背景或 Boss 入场。
    L.ready()
end
function L.render()
    local s=L.state
    if not s then return end
    s.timer=int((clock()-s.start)*60)
    renderLoading(s)
    mask_fader:frame()
    if s.done then s.presented=true end
end
