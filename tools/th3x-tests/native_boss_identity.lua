-- 验证真实Boss对象的ANM库、角色脚本范围与实际绘制的左上角名字。
local expected={
    ['1mid']={'琪露诺','stg1enm',128,131},['1main']={'蕾蒂·霍瓦特洛克','stg1enm',132,136},
    ['2main']={'橙','stg2enm',128,133},['3mid']={'爱丽丝·玛格特洛依德','stg3enm',128,133},
    ['3main']={'爱丽丝·玛格特洛依德','stg3enm',128,133},
    ['4lunasa']={'露娜萨·普莉兹姆利巴','stg4enm',128,133},
    ['4merlin']={'梅露兰·普莉兹姆利巴','stg4enm',134,139},
    ['4lyrica']={'莉莉卡·普莉兹姆利巴','stg4enm',140,145},
    ['5main']={'魂魄妖梦','stg5enm',128,147},['6mid']={'魂魄妖梦','stg6enm',128,146},
    ['6main']={'西行寺幽幽子','stg6enm',147,155},['7mid']={'橙','stg7enm',128,133},
    ['7main']={'八云蓝','stg7enm',134,140},['8mid']={'八云蓝','stg8enm',134,142},
    ['8main']={'八云紫','stg8enm',128,133},
}
local names=OriginalStageVisual.boss_names
local group8={'Nightbug','Lorelei','Kamishirasawa','Reisen','Yagokoro','Neet','Mokou','Tewi','Kamishirasawa2',
    'Reimu','Marisa','Sakuya','Youmu','Alice','Remilia','Yuyuko','Yukari','Tewi','Kamishirasawa2'}
local group6={'Remilia','Rumia','Rumia','Daiyousei','Chiruno','Meirin','Meirin','Koakuma','Knowledge','Sakuya',
    'Sakuya','Sakuya','Knowledge','Flandre','Knowledge','Knowledge','Knowledge'}
local stages6={6,1,1,2,2,3,3,4,4,5,5,6,7,7,4,4,4}
local files95={'Nightbug','Rumia','Chiruno','Whiterock','Kamishirasawa','Alice','Reisen','Tewi','Medicine','Meirin',
    'Knowledge','Chen','Youmu','Sakuya','Remilia','Ran','Yuyuko','Yagokoro','Neet','Komachi','Shikieiki','Flandre','Yukari','Mokou','Suika'}
local entries10={s1mid={'Sizuha',1},s1boss={'Minoriko',1},s2mid={'Hina',2},s2boss={'Hina',2},
    s3mid={'Nitori',3},s3boss={'Nitori',3},s4mid={'Momizi',4},s4boss={'Aya',4},s5mid={'Sanae',5},
    s5boss={'Sanae',5},s6boss={'Kanako',6},s7mid={'Sanae',7},s7boss={'Suwako',7}}
local result={cards={},groups={}}
local current
local function save()
    local file=assert(io.open('identity-result.json','w'));file:write(Serialize(result));file:close()
end
local text=ui.RenderText
function ui:RenderText(font,label,...)
    if font=='boss_name' and current and IsValid(current.owner) and current.owner.is_combat then
        assert(label:find(current.row.name,1,true),'左上角Boss名与原作角色不一致：'..label)
        current.row.renderedName=label;save()
    end
    return text(self,font,label,...)
end
return function(owner,frames,card)
    local level=card.level
    if owner.current_card.phase_kind=='road' or card.cardId==368 and level==30 then current=nil;return end
    local group=tonumber((owner.class.id or ''):match('^(%d+)a%d+$'))
    local cfg,e,key,allowed
    if level==32 then
        cfg=_editor_class.TH34.th07_motion_source[card.cardId]
        if not cfg then current=nil;return end
        key=cfg.key;e=assert(expected[key]);allowed={}
        for id=e[3],e[4] do allowed[id]=true end
        local p=OriginalStageVisual.visual_program(7,cfg.file:gsub('%.ecl$','')..':'..cfg.sub)
        for _,event in ipairs(p.cfg and p.cfg.events or {}) do
            if event[2]==95 and type(event[3])=='number' then allowed[event[3]]=true end
        end
    elseif level==29 then
        local role=assert(group8[group]);key='TH31:'..role
        local archives={Nightbug='stg1enm',Lorelei='stg2enm',Kamishirasawa='stg3enm',Reisen='stg5enm',Tewi='stg5enm',
            Yagokoro='stg6enm',Neet='stg7enm',Mokou='stg8enm',Kamishirasawa2='stg8enm',Reimu='stg4aenm',Marisa='stg4benm',
            Sakuya='stgenm_sk',Youmu='stgenm_ym',Alice='stgenm_al',Remilia='stgenm_rm',Yuyuko='stgenm_yy',Yukari='stgenm_yk'}
        e={names[role],assert(archives[role])}
    elseif level==30 then
        local role=assert(group6[group]);key='TH32:'..group
        e={names[role]}
        assert(owner._original_actor.archive:find('stg'..stages6[group]..'enm',1,true)==1,'红魔乡必须取本面ANM')
    elseif level==31 then
        local source=assert(owner.current_card.original_ecl)
        local index=tonumber(source.file:match('ecl(%d+)_'));key='TH33:'..index
        e={names[assert(files95[index])],'enm'..index}
    elseif level==33 then
        cfg=assert(_editor_class.TH35.t10_boss_entry[card.cardId]);key='TH35:'..cfg.key
        local spec=assert(entries10[cfg.key]);e={names[spec[1]],'stgenm0'..spec[2]}
    else current=nil;return end
    local actor=assert(owner._original_actor)
    assert(owner.name==e[1],tostring(card.cardId)..' 名称错误：'..tostring(owner.name))
    assert(not e[2] or actor.archive==e[2],tostring(card.cardId)..' ANM库错误：'..actor.archive)
    local raw
    for id,index in pairs(actor.vm.data.ids) do if index==actor.vm.id then raw=id;break end end
    if level==32 then assert(raw and (raw<128 or allowed[raw]),tostring(card.cardId)..' 角色脚本错误：'..tostring(raw)) end
    local id=tostring(card.cardId);local row=result.cards[id]
    if not row then
        row={name=owner.name,key=key,level=level,archive=actor.archive,firstScript=raw or actor.vm.id,frames=0}
        result.cards[id]=row;result.groups[key]=true
    end
    row.frames=frames;current={row=row,owner=owner}
    if frames==1 or frames==300 or frames==900 then save() end
end
