-- 失败前冻结同一场战斗，答对一题抵消一次失败判定；真实失误与收卡历史不回退。
local V={MAX=3,PROTECT=180}
local Q=GameQuiz
local savedFields={'x','y','death','lock','dialog','hide','colli','time_stop'}
local function state()
    if lstg.var.__revive_version~=1 then return end
    if not lstg.var.revive then lstg.var.revive={used=0,credits=0,asked={}} end
    return lstg.var.revive
end
function V.misses() return lstg.var.dead-((lstg.var.revive and lstg.var.revive.credits) or 0) end
function V.active()
    if not stage.current_stage or stage.current_stage.is_menu then return false end
    local s=state();return s and s.quiz~=nil
end
function V.request(allowed)
    local s=state()
    if not s or not IsValid(player) or s.quiz or s.used>=V.MAX or s.failedAt==lstg.var.dead or V.misses()<=allowed then return false end
    -- 独立随机源，抽题和打乱选项不消耗弹幕随机序列；三次机会内不重复题目。
    local gen=Rand();gen:Seed((lstg.var.ran_seed+s.used*1009+lstg.var.dead*9176)%2147483647)
    local candidates={}
    for i=1,#Q.questions do
        local seen=false;for _,index in ipairs(s.asked) do if index==i then seen=true end end
        if not seen then candidates[#candidates+1]=i end
    end
    local index=candidates[gen:Int(1,#candidates)];s.asked[#s.asked+1]=index
    local q=Q.new(index,gen);q.original={};q.allowed=allowed
    for _,key in ipairs(savedFields) do q.original[key]=player[key] end
    s.quiz=q
    player.death=0;player.lock=false;player.dialog=false;player.time_stop=false;player.hide=false;player.colli=false
    player.x=math.max(-184,math.min(184,player.x));player.y=-176
    q.choice=Q.answer(player.x)
    if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_REVIVE: question='..index..' used='..s.used) end
    return true
end
local function complete(s,q)
    local x=player.x
    for _,key in ipairs(savedFields) do player[key]=q.original[key] end
    if q.result then
        s.used=s.used+1;s.credits=s.credits+math.max(1,V.misses()-q.allowed)
        player.x=x;player.y=-176;player.death=0;player.hide=false
        player.protect=math.max(player.protect or 0,V.PROTECT)
    else s.failedAt=lstg.var.dead end
    s.quiz=nil
    if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_REVIVE: result='..tostring(q.result)..' used='..s.used..' dead='..lstg.var.dead) end
end
function V.frame(scene)
    if not scene or scene.is_menu then return false end
    local allowed=scene.revive_miss_limit or scene.AllowMissCount
    if allowed then V.request(allowed) end
    local s=state();local q=s and s.quiz
    if not q then return false end
    if not IsValid(player) then s.quiz=nil;s.failedAt=lstg.var.dead;return false end
    if q.result~=nil then
        q.feedback=q.feedback-1
        if q.feedback<=0 then complete(s,q) end
        return true
    end
    q.age=q.age+1
    local speed=KeyIsDown('slow') and (player.lspeed or 2) or (player.hspeed or 4)
    player.x=math.max(-184,math.min(184,player.x+((KeyIsDown('right') and 1 or 0)-(KeyIsDown('left') and 1 or 0))*speed))
    q.choice=Q.answer(player.x)
    local cancel=q.age>=30 and KeyIsPressed('spell')
    if q.age>=Q.TIME or (q.age>=30 and KeyIsPressed('shoot')) or cancel then
        q.result=not cancel and q.choice==q.correct;q.feedback=60
        PlaySound(q.result and 'bonus' or 'invalid')
    end
    return true
end
function V.render()
    if not stage.current_stage or stage.current_stage.is_menu then return end
    local s=state();local q=s and s.quiz
    if not q then return end
    SetViewMode('ui')
    SetImageState('white','',Color(238,10,18,32));RenderRect('white',272,692,30,506)
    local color=Color(255,237,244,255)
    ui:RenderText('title',string.format('答题复活 · 剩余 %d 次',V.MAX-s.used),482,478,0.85,color,'centerpoint')
    ui:RenderText('title','原符卡题库 · 移动到答案区，射击确认',482,444,0.55,color,'centerpoint')
    -- 沿用原题目落下曲线，压缩高度为说明区与四个答案区留出空间。
    local progress=math.min(1,q.age/Q.TIME)
    for i,line in ipairs(Q.wrap(q.text,24)) do
        ui:RenderText('title',line,482,400-(i-1)*28-Q.fall(progress)*36,0.58,color,'centerpoint')
    end
    local labels={'A','B','C','D'}
    for i=1,4 do
        local left=282+(i-1)*100
        local selected=q.choice==i
        local correct=q.result~=nil and q.correct==i
        SetImageState('white','',Color(230,correct and 35 or (selected and 75 or 28),correct and 137 or (selected and 102 or 42),correct and 90 or (selected and 158 or 65)))
        RenderRect('white',left,left+96,140,265)
        ui:RenderText('title',labels[i],left+48,242,0.75,color,'centerpoint')
        ui:RenderText('title',q.choices[i],left+48,204,0.48,color,'centerpoint')
        if selected then ui:RenderText('title','▲',left+48,164,0.7,color,'centerpoint') end
    end
    local text=q.result==nil and string.format('剩余 %.1f 秒 · 符卡键放弃',(Q.TIME-q.age)/60)
        or (q.result and '答对了！复活后无敌 3 秒' or '本局结束')
    ui:RenderText('title',text,482,100,0.6,color,'centerpoint')
end
GameRevive=V
return V
