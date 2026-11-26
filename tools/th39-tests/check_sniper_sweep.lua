-- 原卡547：补扫掠判定不能改变发弹数或出生轨迹，也不能制造枪心安全点。
arg={'moon-sniper'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
lstg.AndroidProjectBullet=function(b,img,x,y,rot,hs,vs,a,bb,layer,group,colli)
    b.x,b.y,b.rot,b.hscale,b.vscale,b.a,b.b,b.layer,b.group,b.colli=x,y,rot,hs,vs,a,bb,layer,group,colli
end
local R=dofile('mod/GAME/th39/runtime.lua');R.useStatePool=false;R.sound=function()end
player.x,player.y,player.protect,player.colli,player.a,player.b=0,-180,0,true,2,2;cheat=false
local originalNew,check=New,R.checkSweep
local results={}
for _,enabled in ipairs({false,true})do
    local objects,births,hits={},{},0
    player.class={colli=function()hits=hits+1 end}
    New=function(cls,s,...)
        local b=originalNew(cls,s,...);objects[#objects+1]=b
        if s.is_projectile then births[#births+1]=table.concat({s.type,s.fx,s.fy,s.sonspeed},',')end
        return b
    end
    R.checkSweep=enabled and check or function()return false end
    ran.Float=function(_,a,b)return (a+b)/2 end
    local c=R.controller({_live=true,x=0,y=100},'547')
    for tick=1,1400 do
        R.tick(c);local count=#objects
        for i=1,count do local b=objects[i];if IsValid(b) and b.class.frame then b.class.frame(b)end end
        local live={};for _,b in ipairs(objects)do if IsValid(b)then live[#live+1]=b end end;objects=live
    end
    results[#results+1]=table.concat(births,'\n')
    if enabled then assert(hits>0,'原卡枪心仍未命中')else assert(hits==0)end
    print('扫掠='..tostring(enabled)..' 出生='..#births..' 补判命中='..hits)
    R.clear(c)
end
assert(results[1]==results[2],'扫掠判定改变了原卡发弹或出生轨迹')
New,R.checkSweep=originalNew,check
print('PASS 月面狙击手原卡发弹不变，枪心快速弹恢复线段判定')
