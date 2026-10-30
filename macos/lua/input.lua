-- 复用 Android 的 Windows 键码映射；桌面默认使用键盘 / 鼠标，F8 可切换触屏预览。
local fu=cc.FileUtils:getInstance()
local rawPosition,rawMouse=lstg.GetMousePosition,lstg.GetMouseState
local I=assert(loadstring(fu:getStringFromFile('game/android/input.lua'),'@game/android/input.lua'))()
local beginFrame,render=I.beginFrame,I.render
local touchMousePosition,touchMouseState=lstg.GetMousePosition,lstg.GetMouseState
local held,toggleHeld=false,false
local nativeDown,reverse={},{}
local codes=require('keycode')
for name,key in pairs({ESCAPE=27,BACKSPACE=8,TAB=9,ENTER=13,SPACE=32,SHIFT=16,CTRL=17,ALT=18,
    LEFT=37,UP=38,RIGHT=39,DOWN=40,HOME=36,END=35,PGUP=33,PGDN=34,DELETE=46,INSERT=45,
    GRAVE=192,MINUS=189,EQUAL=187,BACKSLASH=220,LBRACKET=219,RBRACKET=221,SEMICOLON=186,APOSTROPHE=222,COMMA=188,PERIOD=190,SLASH=191}) do reverse[codes[name]]=key end
for key=48,90 do if codes[string.char(key)] then reverse[codes[string.char(key)]]=key end end
for key=1,12 do reverse[codes['F'..key]]=111+key end
-- Cocos 区分 Return / 小键盘 Enter，以及左右修饰键；Sub 使用同一个键码。
reverse[10]=13;reverse[13]=16;reverse[15]=17;reverse[17]=18
local reset=I.reset
function I.reset(keepToggles) nativeDown={};reset(keepToggles) end
I.preview=false
local function expose(name,fn) lstg[name]=fn;_G[name]=fn end
expose('GetMousePosition',function()
    if I.preview then return touchMousePosition() end
    return rawPosition()
end)
expose('GetMouseState',function(button)
    if I.preview then return touchMouseState(button) end
    -- Sub 为左、中、右；x 原生接口为从 1 开始的左、右、中。
    return rawMouse(({1,3,2})[button+1] or 0)
end)
function I.beginFrame()
    local toggle=GetKeyState(119) or I.last==119
    if toggle and not toggleHeld then
        I.preview=not I.preview;I.reset();held=false
        if I.preview then I.toggles.shoot=true;I.toggles.slow=true end
        lstg.SystemLog('BOSSRUSH_MAC_INPUT: '..(I.preview and '触屏预览' or '键盘鼠标'))
    end
    toggleHeld=toggle
    beginFrame()
    if not I.preview then I.toggles={};I.keys={} end
    for code in pairs(nativeDown) do local key=reverse[code];if key then I.keys[key]=true end end
end
function I.install(scene)
    -- 按下事件至少保留到下一逻辑帧，避免 macOS 在同一次事件轮询中交付按下 / 抬起时漏掉 Esc。
    local keyboard=cc.EventListenerKeyboard:create()
    keyboard:registerScriptHandler(function(code)
        nativeDown[code]=true
        if reverse[code] then I.last=reverse[code] end
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyboard:registerScriptHandler(function(code) nativeDown[code]=nil end,cc.Handler.EVENT_KEYBOARD_RELEASED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(keyboard,scene)
    local mouse=cc.EventListenerMouse:create()
    local function event(kind)
        return function(e)
            if I.preview then
                if kind~='moved' and e:getMouseButton()~=0 then return end
                if kind=='began' then held=true elseif kind=='ended' then held=false elseif not held then return end
                local p=e:getLocation()
                I.lastMouse={kind=kind,x=p.x,y=p.y,scale=screen.scale,nx=(p.x-screen.dx)/screen.scale,ny=(p.y-screen.dy)/screen.scale}
                I.touch('mac-mouse',(p.x-screen.dx)/screen.scale,(p.y-screen.dy)/screen.scale,kind)
            end
        end
    end
    mouse:registerScriptHandler(event('began'),cc.Handler.EVENT_MOUSE_DOWN)
    mouse:registerScriptHandler(event('moved'),cc.Handler.EVENT_MOUSE_MOVE)
    mouse:registerScriptHandler(event('ended'),cc.Handler.EVENT_MOUSE_UP)
    mouse:registerScriptHandler(function(e) I.wheel=I.wheel-e:getScrollY()*120 end,cc.Handler.EVENT_MOUSE_SCROLL)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(mouse,scene)
end
function I.render() if I.preview then render() end end
return I
