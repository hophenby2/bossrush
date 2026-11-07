-- 调用实际背景创建和捕获回调，确认关闭3D后省略中转且保留符卡层的直接绘制。
local pushed,popped,copied,cleared,directCleared=0,0,0,0,0
function Class(base,definition) return setmetatable(definition or {},{__index=base}) end
function New(class,...)
    local o=setmetatable({class=class},{__index=class})
    if class.init then class.init(o,...) end
    return o
end
object={init=function(self,x,y,group,layer) self.x,self.y,self.group,self.layer=x,y,group,layer end}
GROUP={GHOST=0};LAYER={BG=-700}
lstg={tmpvar={},world={l=-192,r=192,b=-224,t=224},
    PushRenderTarget=function() pushed=pushed+1 end,
    PopRenderTarget=function() popped=popped+1 end,
    RenderTexture=function() copied=copied+1 end}
function CreateRenderTarget() end
function LoadFX() end
function Include() end
function IsValid(o) return o~=nil end
function Color(a,r,g,b) return {a=a,r=r,g=g,b=b} end
function RenderClear() cleared=cleared+1 end
function RenderClearViewMode(c)
    assert(lstg.viewmode=='world' and c.a==255 and c.r==0 and c.g==0 and c.b==0,'黑底必须限制在战斗区')
    directCleared=directCleared+1
end
function SetViewMode(mode) lstg.viewmode=mode end
function WorldToScreen(x,y) return x,y end
dofile('THlib/background/background.lua')
local fake=Class(background)
fake.init=function(self) background.init(self,false) end
setting={displayBG=false};AndroidPlatform={};BossRushDesktop=false
local function draw(bg)
    bg.Capturer2.class.render(bg.Capturer2)
    -- 符卡背景仍在两回调之间按原层次绘制，捕获层不跳过它。
    bg.Capturer1.class.render(bg.Capturer1)
end
background.Create(fake)
draw(lstg.tmpvar.bg)
assert(pushed==0 and popped==0 and copied==0 and directCleared==1,'移动端关闭3D时应省略RT中转')
-- 开启3D的实例仍走原捕获路径；同样核对桌面关闭3D的兼容路径。
setting.displayBG=true
lstg.tmpvar.bg=nil
local real=background.Create(fake);draw(real)
assert(pushed==1 and popped==1 and copied==1 and cleared==1,'正常背景的捕获必须成对保留')
setting.displayBG=false;BossRushDesktop=true;lstg.tmpvar.bg=nil
background.Create(fake);draw(lstg.tmpvar.bg)
assert(pushed==2 and popped==2 and copied==2 and directCleared==1,'桌面行为保持原样')
print('移动端关闭3D的直接绘制、战斗区黑底及原捕获路径检查通过')
