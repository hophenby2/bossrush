-- 直接执行正式掉落接取：色块下沿/侧沿、扫掠、动态增量文字及竖屏数值。
arg={'reward-contact'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local Q=GameQuiz;local D=dofile('THlib/drops.lua')
lstg.var.__drops_version=D.VERSION;D.reset()
local p=player;p.A,p.B,p.death,p.lock,p.dialog,p.hide=3,3,0,false,false,false
local function contact(x,y,previous)
    p.x,p.y=x,y
    return Q.contact(previous or {x=x,y=y},p,0,0,3,120,true,true)
end
assert(contact(-130,234)==1 and contact(0,280)==2 and contact(130,330)==3,'色块底部/内部/顶部没有即时接取')
assert(contact(0,231)==2 and not contact(0,230.9),'色块下沿没有使用自机接触半径')
assert(not contact(250,280) and not contact(0,200),'色块外误选')
assert(contact(-150,280,{x=-250,y=280})==1,'水平进入色块没有接取')
assert(contact(0,100,{x=0,y=400})==2,'高速穿过色块漏选')
assert(not Q.contact({x=0,y=280},{x=0,y=280,A=3,B=3},0,0,3,120,true,false),'传统非色块选项被改变')
p.x,p.y=0,240
local s=lstg.var.upgrades
s.queue[1]={id=1,options={1,2,3},age=0,duration=120,linear=true,colorMask=true,picks={false,false}}
local selection=Q.selection;Q.selection=function()end
D.frame({is_menu=false});Q.selection=selection
assert(s.players[1].red==12000 and not s.active,'正式掉落在色块内仍要等中心/弹墙')
s.players[1].red=17280;s.players[1].blue=12345
assert(D.optionLines(2)[2].text=='+0.3','火力奖励不是前后差值的一位小数')
s.players[2].red=30000
assert(D.optionLines(2,2)[2].text=='+0.6','奖励预览没有使用指定自机倍率')
ui=ui or {}
local texts={};local render=ui.RenderText
ui.RenderText=function(_,font,text)texts[#texts+1]=text end
ui.RunHUD=dofile('THlib/UI/run_hud.lua')
ui.RunHUD.growth(10,100,255)
assert(texts[1]=='火力 ×1.7' and texts[2]=='雷填充速率 ×1.2','左下角倍率没有保留一位小数')
ui.RenderText=render
print('PASS：色块全域/下沿/侧沿/高速扫掠、正式掉落立即接取、按当前火力预览+增量、左下角一位小数')
