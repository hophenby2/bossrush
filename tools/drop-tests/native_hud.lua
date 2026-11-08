-- 在独立发行目录记录真实字体、掉落文字和Bomb扇形；不接触玩家存档。
local checked=false
local coop=false
local renderHUD=GameDrops.renderHUD
GameDrops.renderHUD=function(...)
    local net=GameNet
    if coop then GameNet={host=function() return true end} end
    local ok,err=pcall(renderHUD,...);GameNet=net
    if not ok then error(err,0) end
end
-- 只借用正式触控绘制函数，所有输入包装都限制在私有环境中。
local env={lstg={GetKeyState=function() return false end,GetLastKey=function() return 0 end},
    require=function() return setmetatable({},{__index=function(_,key) return key:byte() end}) end}
env._G=env;setmetatable(env,{__index=_G})
local chunk=assert(loadfile('native_android_input.lua'));setfenv(chunk,env)
local mobile=chunk()
local endScene=EndScene
EndScene=function() if coop then mobile.render() end;return endScene() end
return function(host,frames,current)
    if not checked then
        assert(GameDrops.VERSION==5 and lstg.var.__drops_version==5,'新局必须采用九枚库存版本')
        assert(GameDrops.bombState(1)==3,'新局初始持有三枚')
        local image={GetImageTextureRegion('star_big10')}
        assert(image[1]=='v310_bullet2' and image[2]==224 and image[3]==128,'核对绿色大星图集')
        checked=true
    end
    if frames==300 then
        coop=current.cardId==3604
        local parts={[3601]=.25,[3602]=.5,[3603]=.75,[3604]=.99}
        local p=lstg.var.upgrades.players[1]
        p.red,p.blue,p.green=13500,17500,7500
        p.bombs,p.bomb_fraction=3,assert(parts[current.cardId])*GameDrops.BOMB_FRAMES*10000
        local p2=lstg.var.upgrades.players[2]
        p2.red,p2.blue,p2.green,p2.bombs,p2.bomb_fraction=11500,14000,8500,2,.5*GameDrops.BOMB_FRAMES*10000
        local row={age=38,duration=120,linear=true,colorMask=true}
        GameQuiz.selection('hud-verification',row,nil,{GameDrops.optionLines(8),GameDrops.optionLines(3),GameDrops.optionLines(11)})
        current.hud_progress=parts[current.cardId]
        local f=assert(io.open('hud-progress.jsonl','a'))
        f:write(Serialize({id=current.cardId,progress=current.hud_progress,bombs=GameDrops.bombState(1)}),'\n');f:close()
    elseif frames==900 then
        local p=lstg.var.upgrades.players[1];p.bombs,p.bomb_fraction=9,0
        GameQuiz.clearSelection('hud-verification',true)
    end
end
