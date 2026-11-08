-- 使用正式card.add核对六作覆盖率；切换只改显示字段，不更改记录ID、HP或执行函数。
arg={'卡名与背景核对'}
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
dofile('mod/_editor_output.lua')
scoredata={UnlockSC={}};spell_card_data={};player_list={};_sc_table={};_sc_pr_table={}
dofile('THlib/enemy/boss_card.lua');dofile('THlib/anm/original.lua')
for _,id in ipairs({'31','32','33','34','35','36'}) do dofile('mod/GAME/th'..id..'.lua') end
local S,H=SpellNames,_editor_class.TH36.runtime
local checks=0
local function check(v,message) assert(v,message);checks=checks+1 end
local expected={[29]=81,[30]=54,[31]=73,[32]=68,[33]=38,[34]=54}
local snapshot={}
for level=29,34 do
    local n=0
    for _,unit in ipairs(_sc_pr_table[level]) do
        for _,g in ipairs(unit.sc_group) do
            local c=g.card
            if c.is_sc and c.card_id~=368 then
                n=n+1
                check(c.name_ja and c.name_zh,'缺少双语卡名：'..c.card_id)
                check(c.name==c.name_zh,'默认中文')
                snapshot[#snapshot+1]={card=c,id=c.card_id,hp=c.hp,init=c.init,unit=unit}
            end
        end
    end
    check(n==expected[level],'原作符卡覆盖数不符：'..level)
end
for _,value in ipairs({1,0,1,0}) do
    cur_setting={spellNameLanguage=value};S.refresh()
    for _,p in ipairs(snapshot) do
        local c=p.card;local name=value==1 and c.name_ja or c.name_zh
        check(c.name==name and p.unit.CardName:find(name,1,true),'练习／随机池标题未同步')
        check(c.card_id==p.id and c.hp==p.hp and c.init==p.init,'切换改了战斗或历史槽位')
    end
end
local meta=_editor_class.TH36.catalogue
for _,m in ipairs(meta) do
    if m.spell==65 then
        check(S.text(34,m.id)=='回忆「百万鬼夜行」','萃香回忆被文的卡名覆盖')
        check(m.name_ja=='想起「百万鬼夜行」','觉回忆原名错误')
    end
end
local pairs_by_stage={[1]={7,8},[2]={7,8},[3]={8,9},[4]={12,13},[5]={16,17}}
local backgrounds=0
for _,m in ipairs(meta) do if m.spell then
    local s=H.session({_live=true},m.stage,m.sub,m)
    H.spell(s.root,m.spell,0,0,m.name_ja,342)
    local o=s.spell_background
    local pair=pairs_by_stage[m.stage] or (m.stage==6 and (m.mid and {21,22} or {18,17})
        or (m.mid and {7,8} or {11,12}))
    check(o.vms[1].id==pair[1] and o.vms[2].id==pair[2],'背景脚本配对错误：'..m.id)
    for frame=1,59 do s.frame=frame;H.step_backgrounds(s) end
    local target=m.stage==4 and 192 or m.stage==7 and not m.mid and 224 or 255
    check(o.vms[1].alpha[1]==255 and o.vms[2].alpha[1]==target,'原作60帧淡入／目标透明度错误')
    local previous=OriginalANM.draw;local count=0
    OriginalANM.draw=function(vm,x,y) check(x== -224 and y==240,'屏幕坐标换算重复');count=count+1 end
    o.class.render(o);OriginalANM.draw=previous
    check(count==2,'背景层数错误')
    H.spell_end(s.root);check(not IsValid(o) and not s.spell_background,'原作结束指令未清背景')
    H.close(s)
    for _,e in ipairs(s.effects) do check(not IsValid(e),'背景或立绘泄漏') end
    backgrounds=backgrounds+1
end end
check(backgrounds==54,'未覆盖全部TH36符卡')
print(('卡名／背景回归通过：%d项，368个原作符卡注册，TH36全部54张符卡背景。'):format(checks))
