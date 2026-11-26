-- 按原作演员索引检查姓名，尤其不能把同一面的中Boss和关底Boss合并。
local names={[2]='橙',[3]='伊吹萃香',[4]='爱丽丝·玛格特罗依德',[5]='莉莉·怀特',
    [6]='八云蓝',[7]='修普',[8]='西行寺幽幽子',[9]='八云紫'}
local spring=dofile('mod/GAME/th37/catalogue.lua');local count=0
for _,chapter in ipairs(spring.chapters)do for _,group in ipairs(chapter.bosses)do
    for _,card in ipairs(group.cards)do assert(card.actor==names[group.actor],card.id);count=count+1 end
end end
assert(spring.chapters[4].bosses[1].cards[1].actor=='修普')
assert(spring.chapters[4].bosses[2].cards[1].actor=='八云蓝')
assert(spring.chapters[4].bosses[3].cards[1].actor=='修普')
local night=dofile('mod/GAME/th39/catalogue.lua')
for i,name in ipairs({'莉格露·奈特巴格','廷达','？？？','因幡帝','上白泽慧音','铃仙·优昙华院·因幡',
    '蓬莱山辉夜','八意永琳','「修普诺斯」','「塔纳托斯」'})do assert(night.actors[i][1]==name)end
local snow=dofile('mod/GAME/th38/actors.lua')
assert(snow.profiles[snow.phases['L/stage4/bossA/4'][1]].name=='荼靡 结音 / 墨樱 初月')
assert(snow.profiles[snow.phases['L/stage4/bossA/4'][2]].name=='荼靡 结音 / 墨樱 初月')
local summer=dofile('mod/GAME/th40/phases.lua')
local found=0
for _,card in ipairs(summer.phases)do if card.boss=='Rakukun' then assert(card.boss_name=='桃雨落薰');found=found+1 end end
assert(found>0)
print('PASS 春雪 '..count..' 张卡按演员署名，四面角色切换、永夜角色索引、雪莲华双Boss与夏夜祭姓名')
