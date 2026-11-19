-- 使用真实注册与菜单初始化；全部存档状态只在内存中构造。
local f=assert(io.open('tools/sequence_registry.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('for _,id in ipairs({3400',1,true))-1)))()
local C=dofile('mod/sequence_catalog.lua');OriginalSequence={catalog=C}
local P=dofile('mod/original_practice.lua')
lstg.var.__sequence_version=nil
local count=0
for _,work in ipairs(P.stages) do
 local chapters=P.chapters(work.level);assert(#chapters>0,work.title)
 local seen={}
 for _,entry in ipairs(chapters) do
  assert(not seen[entry.key]);seen[entry.key]=true
  for _,player in ipairs({'reimu_player','marisa_player'}) do
   local list=C.chapters(entry.route,player,entry.chapter)
   assert(#list==1 and list[1].name==entry.chapter and #list[1].units>0,entry.key)
  end
  count=count+1
 end
 if work.level==29 then assert(seen['th08_lunatic_a:4A'] and seen['th08_lunatic_a:4B'] and seen['th08_lunatic_b:6B']) end
end
ui={menu={}};screen={width=960,height=540};KeyCodeToName=function() return {} end
dofile('THlib/UI/menus/scpr_menu.lua')
-- 先筛选真实的雪莲华符卡，再用稳定卡号恢复，避免列表下标变动后错位。
local view={};sc_pr_menu.TweakCard(view,true,false)
local row=assert(view.spells[7][5]);local id=_sc_pr_table[row[4]][row[1]].sc_group[1].card.card_id
scoredata={onlyshowcard=true,menu_sc_pr={pos=99999,diffpos=1,level=36,card_id=id}}
sp.GetListSection=function(_,list,_,pos) return list,pos end
local a={};sc_pr_menu.init(a,function() end)
assert(a.diffpos==7 and a.pos==5 and a.onlyshowcard,'菜单重建没有恢复原作、过滤器与符卡')
a.pos=6;a:remember();local b={};sc_pr_menu.init(b,function() end)
assert(b.diffpos==7 and b.pos==6,'下一次练习没有恢复最后位置')
scoredata.menu_sc_pr={pos=99999,diffpos=99999,card_id=-1}
local c={};sc_pr_menu.init(c,function() end)
assert(c.diffpos==#c.difficulty and c.pos==#c.spell,'旧游标或删除的卡必须夹在有效范围')
print(('十二作 %d 个独立关卡、原作分支与符卡选项记忆通过'):format(count))
