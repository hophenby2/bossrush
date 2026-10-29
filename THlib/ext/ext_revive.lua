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
    q.choice=Q.answer(player.x);q.previous={x=player.x,y=player.y}
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
    Q.clearSelection('revive');s.quiz=nil
    if lstg.SystemLog then lstg.SystemLog('BOSSRUSH_REVIVE: result='..tostring(q.result)..' used='..s.used..' dead='..lstg.var.dead) end
end
function V.frame(scene)
    if not scene or scene.is_menu then Q.clearSelection('revive');return false end
    local allowed=scene.revive_miss_limit or scene.AllowMissCount
    if allowed then V.request(allowed) end
    local s=state();local q=s and s.quiz
    if not q then return false end
    if not IsValid(player) then Q.clearSelection('revive');s.quiz=nil;s.failedAt=lstg.var.dead;return false end
    if q.result~=nil then
        q.feedback=q.feedback-1
        Q.selection('revive',q,q.text,q.choices,q.feedback/60)
        if q.feedback<=0 then complete(s,q) end
        return true
    end
    local oldAge=q.age;q.age=q.age+1
    Q.selection('revive',q,q.text,q.choices)
    local key={};for _,name in ipairs({'up','down','left','right','slow'}) do key[name]=KeyIsDown(name) end
    Q.move(player,key)
    q.choice=Q.answer(player.x)
    local choice=Q.contact(q.previous or {x=player.x,y=player.y},player,oldAge,q.age,4)
    q.previous={x=player.x,y=player.y}
    local cancel=q.age>=30 and KeyIsPressed('spell')
    if choice or cancel then
        q.choice=choice or q.choice;q.result=not cancel and q.choice==q.correct;q.feedback=60
        PlaySound(q.result and 'bonus' or 'invalid')
    end
    return true
end
function V.render()
    if not stage.current_stage or stage.current_stage.is_menu then return end
    local s=state();local q=s and s.quiz
    if not q then return end
    local previousMode=lstg.viewmode;SetViewMode('world')
    local text=q.result==nil and string.format('复活剩余 %d 次 · 上顶横线作答 · %.1f 秒',V.MAX-s.used,(Q.TIME-q.age)/60)
        or (q.result and '答对了！复活后无敌 3 秒' or '本局结束')
    ui:RenderText('title',text,0,-210,0.55,Color(255,237,244,255),'centerpoint')
    if previousMode then SetViewMode(previousMode) end
end
GameRevive=V
return V
