-- 实际机体目录和配置函数：跨作品/机体来源切换不能残留上一次的系统标志。
arg={'practice-players'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
CopyImage=function()end
dofile('THlib/native_players.lua');dofile('THlib/sequence_resources.lua')
OriginalSequence={catalog=dofile('mod/sequence_catalog.lua')}
player_list={{'博丽灵梦','reimu_player','Reimu'},{'琪露诺','chiruno_player','Chiruno'},
    {'射命丸文','aya_player','Aya'},{'雾雨魔理沙','marisa_player','Marisa'}}
local P=dofile('mod/practice_players.lua');local count=0
for _,level in ipairs({29,30,31,32,33,35,36,37,38,39,40,41})do
    local rows,seen=P.candidates(level),{}
    assert(#rows>4,'缺少原作机体 '..level)
    for _,m in ipairs(rows)do
        assert(not seen[m.key],'候选key重复');seen[m.key]=true
        assert(P.resolve(level,m.key).id==m.id);count=count+1
    end
end
lstg.var={}
P.configure(35,'original:sanae')
assert(NativePlayers.enabled() and lstg.var.native_player_id=='sanae')
P.configure(32,'project:marisa_player')
assert(not NativePlayers.enabled() and not SequenceResources.enabled() and lstg.var.player_name=='marisa_player')
P.configure(30,'original:marisab',nil,'th06_lunatic')
assert(SequenceResources.enabled() and not NativePlayers.enabled() and lstg.var.sequence_player=='marisab')
SequenceResources.reset();assert(SequenceResources.state().game==6 and SequenceResources.state().power==128)
P.configure(36,'original:marisa_b')
assert(NativePlayers.enabled() and not SequenceResources.enabled() and not lstg.var.original_resources)
P.configure(39,'project:reimu_player')
assert(not NativePlayers.enabled() and not SequenceResources.enabled() and not lstg.var.sequence_player and not lstg.var.theis_route)
P.configure(40,'original:dream',{1,0,1,3,1,1})
assert(lstg.var.like_dreamer_loadout[4]==3)
P.configure(40,'project:chiruno_player')
assert(not lstg.var.like_dreamer_loadout and lstg.var.player_name=='chiruno_player')
assert(not pcall(P.resolve,35,'original:dream'),'不能跨作品套用机体')
assert(P.default(30,'original:sanae')=='original:reimua','隐式开局不能继承其他作品的机体key')
assert(P.default(35,'project:marisa_player')=='project:marisa_player','有效的项目机体应能沿用')
print('PASS 十二作 '..count..' 个机体候选与跨来源切换、原作满火力、Dreamer装备清理')
