-- 把原作道中和攻击入口放进符卡练习。顺序模式另走原作连续流程。
local M = {}
function M.work(code, level)
    local work = {code=code, level=level, order={}, chapters={}}
    _editor_class[code] = work
    GameContent.ports[level] = work
    work.background = Class(background, {
        init=function(o) background.init(o, false) end,
        render=function(o)
            SetImageState('white','',255,9,13,22)
            RenderRect('white',lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)
        end,
    })
    return work
end

function M.chapter(work, name, title, music)
    local chapter = {name=tostring(name), cards={}, title=title, music=music}
    work.order[#work.order+1] = chapter
    work.chapters[chapter.name] = chapter
    return chapter
end

function M.card(work, chapter, id, title, role, run, source, spell)
    local band = tostring(id)..'a'
    local bg = not work.ownHud and work.background or nil
    boss.Define(band, work.ownHud and "" or chapter.title, chapter.music, bg, {0,500}, nil, 'img_void', work.level)
    local card = boss.card.New(spell and title or '', 9999,9999,9999,1)
    card.phase_kind, card.phase_name = role, title
    card.port_source = source
    card.own_phase_display = work.ownHud
    card.before=function(o)
        o.hide,o.colli,o._colli = true,false,false
        o.ui.hide = true
        o.ui.drawname,o.ui.drawtime,o.ui.drawpointer=false,false,false
        o.ui.no_infobar,o.ui.no_timeCounter,o.ui.no_pointer=true,true,true
        if IsValid(o._bosssys.aura) then o._bosssys.aura.hide=true end
    end
    card.init=function(o)
        task.New(o,function()
            run()
            o.hp=0
        end)
    end
    boss.card.add({{card,band}},work.level,title,id)
    chapter.cards[#chapter.cards+1] = id
    return card
end

function M.run(work, scene)
    for _, chapter in ipairs(work.order) do
        work.runChapter(scene,chapter)
    end
end

return M
