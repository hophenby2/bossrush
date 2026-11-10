-- 核对真实原作ANM、动态资源数值、画布位置和竖屏隔离；不访问玩家存档。
local f=assert(io.open('tools/check_original_anm.lua','rb'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('local pellet=',1,true))-1)))()
screen={width=960,height=540}
local portrait=false
AndroidPortrait={enabled=function() return portrait end}
local defaults={scrl=288,scrr=672,scrb=46,scrt=494}
GetDefaultWorld=function() return defaults end
GetFPS=function() return 60 end
local renders={}
SetImageState=function() end;Render=function(...) renders[#renders+1]={...} end;RenderRect=function() end
ui={RenderText=function() end}
local P=dofile('THlib/sequence_resources.lua')
local H=dofile('THlib/UI/original_hud.lua')
local n=0
local function check(ok,message) assert(ok,message);n=n+1 end
local function near(a,b) return math.abs(a-b)<1e-5 end
local entries={{6,'th06_lunatic','reimua'},{7,'th07_lunatic','reimua'},{8,'th08_lunatic_b','team0'},
    {10,'th10_lunatic','reimua'},{95,'th095_scenes','aya'}}
boss_group={};player={x=0,y=-176}
for _,entry in ipairs(entries) do
    local g,key,machine=unpack(entry)
    stage.current_stage={timer=0,is_menu=false}
    lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key=key,score=123456780,graze=456,
        original_resources={game=g,machine=machine,power=g==10 and 75 or 96,lives=3,bombs=4,extends=0,
            stage_points=42,points=42,time=1234,human=-85,gauge=-8500,faith=234560,faith_timer=100,
            cherry=123450,cherry_max=400000,cherry_plus=40000,border=g==7 and 400 or 0,stage_name='1'}}
    lstg.tmpvar={hiscore=234567890};lstg.world={scrl=288,scrr=672,scrb=46,scrt=494}
    H.layout()
    check(lstg.world.scrl==(g==95 and 288 or 192) and lstg.world.scrr-lstg.world.scrl==384,'640画布中的原作场地位置')
    local o={};H.controller.init(o)
    for i=1,180 do stage.current_stage.timer=i;H.controller.frame(o) end
    local state=lstg.var.original_resources
    H.frame();H.draw()
    check(state.faith==234560 and state.cherry_plus==40000 and lstg.var.score==123456780,'绘制不修改资源或分数')
    if g==7 then
        check(near(o.cherry.position[1],32) and near(o.cherry.position[2],449),'樱点使用原作底部位置')
        check(o.border.sprite~=nil,'森罗结界使用原作标记')
    elseif g==8 then
        check(near(o.gauge8.position[1],96-85*.56),'人妖率游标使用原作112像素量程')
        check(H.timeThreshold(state)==3000,'Lunatic一面刻符目标来自原作')
    elseif g==10 then
        check(o.power[0].sprite==11 and o.power[2].sprite==15 and o.power[3].sprite==13,'75火力显示原作3.75')
        check(o.faith[1].sprite==32 and o.faith[5].sprite==36,'信仰按原作十位存储与六位显示拆字')
        check(o.score[1].sprite==16 and o.score[8].sprite==9,'分数使用原作front数字精灵')
    end
    if g~=95 then
        local valid=IsValid;IsValid=function(b) return b.valid end
        boss_group={{valid=true,is_combat=true,x=0,y=96,hp=100,maxhp=200,sc_left=1,countdown=30,name='界面验证'}}
        renders={};H.drawBoss(o)
        if g==6 then
            local checked=false
            for _,r in ipairs(renders) do if r[1]=='original/6/front/sprite13' then
                check(near(r[2]-14*r[5]/2,256) and near(14*r[5],144),'红魔乡血条的原作左上锚点保持在场内')
                checked=true
            end end
            check(checked,'实际绘制红魔乡原作血条精灵')
        end
        IsValid=valid;boss_group={}
    end
    player.x,player.y=-128,-192
    for i=1,45 do H.controller.frame(o) end
    check(o.faded==true,'贴近底部系统UI时触发原作淡化')
    player.x,player.y=0,-176
    stage.current_stage.is_menu=true;H.layout()
    check(lstg.world.scrl==288,'返回菜单恢复旧视口')
    stage.current_stage.is_menu=false;portrait=true
    lstg.world.scrl,lstg.world.scrr=0,540
    H.layout();check(not H.enabled() and lstg.world.scrl==0 and lstg.world.scrr==540,'竖屏保留原有布局')
    portrait=false
    lstg.var.__sequence_system_version=nil
    check(not H.enabled(),'旧录像和其他模式不启用原作UI')
end
print('原作横屏界面检查通过：'..n)
