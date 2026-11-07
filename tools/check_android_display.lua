-- 使用真实屏幕与显示适配代码核对宽屏居中，且不改动世界/镜头参数。
local function noop() end
local viewport, bounds
lstg = {}
setting={resx=1920,resy=1080};cur_setting={};default_setting={}
PI_2=math.pi/2
Color=function(...) return {...} end
SetBound=function(...) bounds={...} end
SetViewport=function(...) viewport={...} end
SetOrtho,SetFog,SetImageScale=noop,noop,noop
dofile('THlib/lib/Lscreen.lua')
local file=assert(io.open('THlib/ext/ext_other.lua','rb'))
local source=file:read('*a');file:close()
local first=assert(source:find('CreateRenderTarget("mask_fader")',1,true))
local last=assert(source:find('function mask_fader:BeforeRender()',first,true))
CreateRenderTarget=noop
assert(loadstring(source:sub(first,last-1),'@THlib/ext/ext_other.lua:mask_fader'))()
local display=dofile('android/lua/display.lua')
local inputResets,invalidations=0,0
AndroidInput={reset=function(keep) assert(keep);inputResets=inputResets+1 end}
AndroidPauseCache={invalidate=function() invalidations=invalidations+1 end}
local world=lstg.world
world.l,world.r,world.boundl,world.boundr=-140,140,-188,188
local offset=lstg.worldoffset
offset.dx,offset.hscale,offset.centerx=17,1.25,-23
for _,size in ipairs({{960,540},{2400,1080},{3168,1440},{1600,720},{1920,1200}}) do
    display.resize(size[1],size[2])
    assert(lstg.world==world and world.l==-140 and world.r==140,'缩放改变了战斗世界')
    assert(lstg.worldoffset==offset and offset.dx==17 and offset.hscale==1.25 and offset.centerx==-23,'缩放改变了镜头')
    assert(bounds[1]==-188 and bounds[2]==188,'原生回收边界被改变')
    SetViewMode('ui')
    assert(math.abs((viewport[1]+viewport[2])/2-size[1]/2)<0.001,'UI横向未居中')
    assert(math.abs((viewport[3]+viewport[4])/2-size[2]/2)<0.001,'UI纵向未居中')
    assert(math.abs(mask_fader.tox(screen.scale,480)-size[1]/2)<0.001,'过场采样漏算横向留边')
    assert(math.abs(mask_fader.toy(screen.scale,270)-size[2]/2)<0.001,'过场采样漏算纵向留边')
end
assert(inputResets==5 and invalidations==5)
print('宽屏/过场居中、世界与镜头保留、输入与暂停缓存更新检查通过')
