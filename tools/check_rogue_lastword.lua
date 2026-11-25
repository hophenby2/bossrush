-- 使用永夜篇真实元数据与老作正式登记，检查随机入口均排除Last Word。
local f=assert(io.open('tools/check_roguelike.lua','rb'));local setup=f:read('*a');f:close()
local stop=assert(setup:find('local bossFilters=R.defaultFilters',1,true))
local checks=[=[
TH39={data=dofile('mod/GAME/th39/catalogue.lua')}
_sc_pr_table[37]={}
local meta={};local special=0
for _,chapter in ipairs(TH39.data.chapters)do for _,group in ipairs(chapter.bosses)do for _,c in ipairs(group.cards)do
    meta[c.id]=c
    if c.kind==2 and chapter.difficulty==4 then special=special+1 end
    local card={card_id=c.id,name=c.title,is_sc=c.kind~=0,is_combat=true,t1=0,t3=3600}
    _sc_pr_table[37][#_sc_pr_table[37]+1]={CardName=c.title,sc_group={{card=card,boss={}}}}
end end end
local filters=R.defaultFilters();filters.stages={TH31=true,TH39=true};filters.difficulties.lastword=true
local pool=R.buildPool(filters);local found=0
for _,bucket in ipairs(pool)do for _,entry in ipairs(bucket.cards)do
    check(entry.originalDifficulty~='lastword','老作Last Word不进入随机池')
    if entry.source=='TH39' then check(meta[entry.cardId].kind~=2,'永夜篇条件Last Word不归入Lunatic');found=found+1 end
end end
check(special>0 and found>0,'同时覆盖Last Word与可随机的普通攻击')
local tags=dofile('mod/rogue_ports.lua').tags()
check(tags.TH39[39007].lastword and tags.TH39[39007].difficulty=='lunatic','萤灯夜歌保留来源难度并明确标注Last Word')
filters.difficulties={lastword=true}
local _,count=R.buildPool(filters);check(count==0,'旧勾选值不能绕过排除')
local ui=dofile('THlib/UI/rogue_pool.lua')
for _,entry in ipairs(ui.options)do check(entry.key~='lastword','高级选项不保留无效的Last Word开关')end
print('Last Word随机池排除通过：永夜篇L难度特殊卡'..special..'张；检查'..total..'项')
]=]
assert(loadstring(setup:sub(1,stop-1)..checks))()
