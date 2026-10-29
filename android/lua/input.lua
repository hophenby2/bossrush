-- 射击 / 低速按下时各自切换，其余动作与移动仍由触点持有。
local I = { touches = {}, keys = {}, pulses = {}, toggles = {}, mouse = { x = 480, y = 270, down = false }, mouseTap = 0, wheel = 0 }
local rawKey, rawLast = lstg.GetKeyState, lstg.GetLastKey
local xKeys = require('keycode')
local windows = { ESCAPE=27, BACKSPACE=8, TAB=9, ENTER=13, SPACE=32, SHIFT=16, CTRL=17,
    ALT=18, LEFT=37, UP=38, RIGHT=39, DOWN=40, HOME=36, END=35, PGUP=33, PGDN=34 }
local toX, fromX = {}, {}
for name, key in pairs(windows) do toX[key] = xKeys[name]; fromX[xKeys[name]] = key end
for code = 65, 90 do toX[code] = xKeys[string.char(code)]; fromX[toX[code]] = code end
for code = 48, 57 do toX[code] = xKeys[string.char(code)]; fromX[toX[code]] = code end
for number = 1, 12 do
    local value = xKeys['F'..number]
    if value then toX[111+number]=value; fromX[value]=111+number end
end
local buttons = {
    { key = 90, action = 'shoot', x = 853, y = 90, radius = 48, label = '射击', toggle = true },
    { key = 16, action = 'slow', x = 750, y = 92, radius = 40, label = '低速', toggle = true },
    { key = 88, action = 'spell', x = 853, y = 200, radius = 40, label = '符卡' },
    { key = 67, action = 'special', x = 750, y = 200, radius = 40, label = '特殊' },
    { key = 27, x = 874, y = 488, radius = 30, label = '暂停' },
}
local menuButtons = {
    { key=13, x=890, y=40, radius=28, label='确定' },
    { key=27, x=810, y=40, radius=28, label='返回' },
}
function I.menuMode()
    if GameNet and GameNet.client() then return false end
    return ext and (ext.StageIsMenu() or (ext.pause_menu and not ext.pause_menu:IsKilled())) or false
end
function I.pulse(key) I.pulses[key] = 2; I.last = key end
local function binding(action, fallback)
    return setting and setting.keys and setting.keys[action] or fallback
end
local function buttonKey(button) return button.action and binding(button.action, button.key) or button.key end
local function move(keys, action, fallback) keys[binding(action, fallback)] = true end
local function inPlayfield(x, y)
    local w = lstg.world
    return w and player and x >= w.scrl and x <= w.scrr and y >= w.scrb and y <= w.scrt
end
local function rebuild()
    local old, keys = I.keys, {}
    I.mouse.down = false
    if not I.menuMode() then
        for _,b in ipairs(buttons) do if b.toggle and I.toggles[b.action] then keys[buttonKey(b)]=true end end
    end
    for _, t in pairs(I.touches) do
        if t.button then if not t.button.toggle then keys[buttonKey(t.button)] = true end
        elseif not t.joystick and not t.drag and not t.ignored then
            I.mouse.down = true; I.mouse.x = t.x; I.mouse.y = t.y
        end
    end
    local t = I.movementId and I.touches[I.movementId]
    if t then
        if t.joystick then
            local dx, dy = t.x - 122, t.y - 130
            if dx < -18 then move(keys, 'left', 37) end
            if dx > 18 then move(keys, 'right', 39) end
            if dy < -18 then move(keys, 'down', 40) end
            if dy > 18 then move(keys, 'up', 38) end
        elseif t.drag and t.player == player then
            -- 相对拖拽只产生原有方向键，保留角色移速、碰撞、低速和录像的确定性。
            local slow = keys[binding('slow', 16)] or (player.slow == 1)
            local speed = slow and (player.lspeed or 2) or (player.hspeed or 4)
            local dx, dy = t.targetX-player.x, t.targetY-player.y
            local threshold = speed*0.5
            if math.abs(dx) > threshold and math.abs(dy) > threshold then threshold = threshold*0.70710678 end
            if dx < -threshold then move(keys, 'left', 37) end
            if dx > threshold then move(keys, 'right', 39) end
            if dy < -threshold then move(keys, 'down', 40) end
            if dy > threshold then move(keys, 'up', 38) end
        end
    end
    for key in pairs(keys) do if not old[key] then I.last = key end end
    I.keys = keys
end
function I.touch(id, x, y, event)
    if event == 'ended' or event == 'cancelled' then
        local old = I.touches[id]
        if I.trace and old and old.drag and player and lstg.SystemLog then
            lstg.SystemLog(string.format('BOSSRUSH_DRAG_END: target=%.3f,%.3f player=%.3f,%.3f',old.targetX,old.targetY,player.x,player.y))
        end
        if event == 'ended' and old and not old.button and not old.joystick and not old.drag and not old.ignored then I.mouseTap = 2 end
        I.touches[id] = nil
        if I.movementId == id then I.movementId = nil end
    else
        local t = I.touches[id]
        if not t then
            t = { x = x, y = y }
            if x>=480 and x<=630 and y>=510 and y<=538 then t.button={key=120};I.pulse(120) end
            if x>=640 and x<=790 and y>=510 and y<=538 then
                t.button={key=116}; I.pulse(116)
            end
            if x>=800 and x<=956 and y>=510 and y<=538 then
                t.button={key=121}; I.pulse(121)
            end
            for _, button in ipairs(I.menuMode() and menuButtons or buttons) do
                if t.button then break end
                if (x-button.x)^2 + (y-button.y)^2 <= button.radius^2 then
                    t.button = button
                    if button.toggle and event=='began' then I.toggles[button.action]=not I.toggles[button.action] end
                    if button.key == 27 then I.pulse(27) end
                    break
                end
            end
            if not t.button and not I.menuMode() then
                if x < 235 and y < 255 then t.joystick = true
                elseif inPlayfield(x, y) then
                    t.drag = true; t.player = player
                    t.targetX, t.targetY = player.x, player.y
                    if I.trace and lstg.SystemLog then lstg.SystemLog(string.format('BOSSRUSH_DRAG_BEGIN: player=%.3f,%.3f target=%.3f,%.3f',player.x,player.y,t.targetX,t.targetY)) end
                end
                if t.joystick or t.drag then
                    if I.movementId then t.joystick, t.drag, t.ignored = nil, nil, true
                    else I.movementId = id end
                end
            end
            I.touches[id] = t
        elseif t.drag and t.player == player then
            local w, offset = lstg.world, lstg.worldoffset or {}
            local sx = (w.r-w.l)/(w.scrr-w.scrl)/(offset.hscale or 1)
            local sy = (w.t-w.b)/(w.scrt-w.scrb)/(offset.vscale or 1)
            t.targetX = math.max(w.pl+8, math.min(w.pr-8, t.targetX+(x-t.x)*sx))
            t.targetY = math.max(w.pb+16, math.min(w.pt-32, t.targetY+(y-t.y)*sy))
        elseif not t.button and not t.joystick and not t.ignored then I.wheel = I.wheel - (y-t.y)*8 end
        t.x, t.y = x, y
    end
    rebuild()
end
function I.reset(keepToggles)
    I.touches = {}; I.movementId = nil; I.keys = {}; I.pulses = {}; I.mouse.down = false; I.mouseTap = 0; I.wheel = 0; I.last = nil
    if not keepToggles then I.toggles={} end
end
local previousMode
function I.beginFrame()
    local mode = I.menuMode()
    -- 普通暂停只释放触点并暂时屏蔽开关，继续时沿用；回标题 / 切后台则清除开关。
    if previousMode ~= nil and previousMode ~= mode then I.reset(true) end
    if ext and ext.StageIsMenu() then I.toggles={} end
    previousMode = mode
    local t = I.movementId and I.touches[I.movementId]
    if t and t.drag then
        if t.player ~= player then
            t.drag, t.ignored, I.movementId = nil, true, nil
        elseif player.lock or player.dialog or (player.death or 0) > 0 then
            t.targetX, t.targetY = player.x, player.y
        end
    end
    rebuild()
end
function I.endFrame()
    for key, frames in pairs(I.pulses) do I.pulses[key] = frames > 1 and frames - 1 or nil end
    I.last = nil; I.wheel = 0; I.mouseTap = math.max(0, I.mouseTap-1)
end
lstg.GetKeyState = function(key) return I.keys[key] or I.pulses[key] ~= nil or (toX[key] and rawKey(toX[key])) or false end
lstg.GetLastKey = function() return I.last or fromX[rawLast()] or 0 end
lstg.GetMousePosition = function()
    local scale = screen and screen.scale or 1
    return I.mouse.x*scale+(screen and screen.dx or 0), I.mouse.y*scale+(screen and screen.dy or 0)
end
lstg.GetMouseState = function(button) return button == 0 and (I.mouse.down or I.mouseTap > 0) or (button == 2 and I.pulses[27] ~= nil) end
for _, key in ipairs({ 'GetKeyState', 'GetLastKey', 'GetMousePosition', 'GetMouseState' }) do _G[key] = lstg[key] end
function I.install(scene)
    local listener = cc.EventListenerTouchAllAtOnce:create()
    for _, descriptor in ipairs({ { cc.Handler.EVENT_TOUCHES_BEGAN, 'began' },
        { cc.Handler.EVENT_TOUCHES_MOVED, 'moved' }, { cc.Handler.EVENT_TOUCHES_ENDED, 'ended' },
        { cc.Handler.EVENT_TOUCHES_CANCELLED, 'cancelled' } }) do
        local event = descriptor[2]
        listener:registerScriptHandler(function(touches)
            for _, touch in ipairs(touches) do
                local p = touch:getLocation()
                I.touch(touch:getId(), (p.x-screen.dx)/screen.scale, (p.y-screen.dy)/screen.scale, event)
            end
        end, descriptor[1])
    end
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, scene)
end
function I.render()
    SetViewMode('ui')
    local menuMode = I.menuMode()
    for _, b in ipairs(menuMode and menuButtons or buttons) do
        local active=I.keys[buttonKey(b)]
        SetImageState('white', '', active and Color(180,40,110,75) or Color(90,34,57,82))
        RenderRect('white', b.x-b.radius, b.x+b.radius, b.y-b.radius, b.y+b.radius)
        local label=b.label..(b.toggle and (I.toggles[b.action] and ' 开' or ' 关') or '')
        RenderTTF('title', label, b.x, b.y, Color(230, 235, 241, 247), 'centerpoint')
    end
    if not menuMode then
        SetImageState('white', '', Color(90, 34, 57, 82))
        RenderRect('white', 42, 202, 50, 210)
        RenderTTF('title', '摇杆', 122, 130, Color(220, 235, 241, 247), 'centerpoint')
    end
end
return I
