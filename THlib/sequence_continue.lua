-- 续关占用普通录像输入帧，暂停关卡协程、物件和碰撞；不借用断点续玩的ContinueGame。
local P=SequenceResources
function P.canContinue()
    local s=P.state();if not s then return false end
    if not lstg.var.sequence_key:find('lunatic',1,true) then return false end
    if s.game==6 then return (s.continues or 0)<3 end
    -- 上限在开局时随录像初态保存，重放不读取之后增长的本机游玩时间。
    if s.game==7 then return (s.continues or 0)<(s.continue_limit or 3) end
    if s.game==8 then return (s.clock or 0)<11 and s.stage_name~='6B' end
    return s.game==10
end
function P.continueRun(scene)
    local s=assert(P.state());assert(P.canContinue(),'当前原作关卡不能续关')
    s.continues=(s.continues or 0)+1
    s.lives=2;s.bombs=P.data(s.game,P.machine(s.game,s.machine).primary).bombs or 3
    s.power=0;s.extends=0;s.points=0;s.stage_points=0;s.stage_graze=0;s.power_chain=0
    lstg.var.score=s.continues;lstg.var.graze=0
    if s.game==7 then s.cherry=0
    elseif s.game==8 then s.clock=(s.clock or 0)+1
    elseif s.game==10 then s.faith=50000;s.faith_timer=0;s.faith_decay=90 end
    local p=player
    p.original_deathbomb=nil;p.original_respawn=nil;p.original_drop_delay=nil
    p.death=0;p.x,p.y=0,-176;p.protect=180
    scene.sequence_continue=nil;P.sync()
    if scene.sequence_music then ResumeMusic(scene.sequence_music) end
    if s.game==10 then OriginalSequence.restartChapter(scene) end
end
function P.continueFrame(scene)
    local s=P.state();if not s or not scene or scene.sequence_finished then return false end
    local menu=scene.sequence_continue
    if not menu and s.lives>=0 then return false end
    if not menu and player and player.original_respawn and player.original_respawn>0 then return false end
    if not menu then
        if not P.canContinue() then OriginalSequence.finish(scene,false);return true end
        menu={time=0,yes=false,previous={}};scene.sequence_continue=menu
        if scene.sequence_music then PauseMusic(scene.sequence_music) end
    end
    local key=KeyState or {};local previous=menu.previous
    menu.time=menu.time+1
    if menu.time>=30 then
        if key.up and not previous.up or key.down and not previous.down then menu.yes=not menu.yes;PlaySound('select00',.3) end
        if key.spell and not previous.spell then OriginalSequence.finish(scene,false)
        elseif key.shoot and not previous.shoot then
            if menu.yes then P.continueRun(scene) else OriginalSequence.finish(scene,false) end
        end
    end
    menu.previous={up=key.up,down=key.down,shoot=key.shoot,spell=key.spell}
    return true
end
function P.renderContinue(scene)
    local menu=scene and scene.sequence_continue;if not menu then return end
    SetViewMode('ui')
    local x,y=screen.width/2,screen.height/2
    SetImageState('white','',Color(200,0,0,0));RenderRect('white',x-180,x+180,y-100,y+100)
    ui:RenderText('title','是否续关？',x,y+60,.9,Color(255,255,255,255),'center')
    local s=P.state();local detail=s.game==10 and '从本关开头重新开始' or s.game==8 and '时间推进三十分钟' or ('剩余续关次数：'..((s.game==7 and s.continue_limit or 3)-(s.continues or 0)))
    ui:RenderText('title',detail,x,y+25,.5,Color(255,220,220,220),'center')
    ui:RenderText('title',(menu.yes and '▶ ' or '   ')..'继续',x,y-15,.7,menu.yes and Color(255,255,160,192) or Color(255,160,160,160),'center')
    ui:RenderText('title',(menu.yes and '   ' or '▶ ')..'结束',x,y-55,.7,not menu.yes and Color(255,255,160,192) or Color(255,160,160,160),'center')
    SetViewMode('world')
end
return P
