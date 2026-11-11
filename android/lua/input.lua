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
    -- 左右镜像共用动作和开关状态；从上到下为射击、低速、Bomb，触控尺寸由56增至76。
    { key = 90, action = 'shoot', x = 52, y = 210, radius = 38, label = '射击', toggle = true },
    { key = 16, action = 'slow', x = 52, y = 130, radius = 38, label = '低速', toggle = true },
    { key = 88, action = 'spell', x = 52, y = 50, radius = 38, label = 'Bomb' },
    { key = 90, action = 'shoot', x = 908, y = 210, radius = 38, label = '射击', toggle = true },
    { key = 16, action = 'slow', x = 908, y = 130, radius = 38, label = '低速', toggle = true },
    { key = 88, action = 'spell', x = 908, y = 50, radius = 38, label = 'Bomb' },
    { key = 27, x = 920, y = 518, radius = 18, label = '暂停' },
}
local menuButtons = {
    { key=13, x=890, y=40, radius=28, label='确定' },
    { key=27, x=810, y=40, radius=28, label='返回' },
}
local portraitPause={key=27,x=34,y=0,radius=28,label='暂停'}
local portraitSlow={key=16,action='slow',radius=30,label='低速'}
function I.slowMode()
    local mode=setting and setting.touchSlowMode
    return mode==2 and 2 or mode==3 and 3 or 1
end
local function activeButtons(menuMode)
    if AndroidPortrait and AndroidPortrait.enabled() then
        if menuMode then return {} end
        portraitPause.x,portraitPause.y=AndroidPortrait.pauseButton()
        portraitSlow.x,portraitSlow.y=AndroidPortrait.slowButton()
        portraitSlow.toggle=I.slowMode()==1
        return {portraitPause,portraitSlow}
    end
    return menuMode and menuButtons or buttons
end
function I.menuMode()
    if GameNet and GameNet.client() then return false end
    return ext and (ext.StageIsMenu() or (ext.pause_menu and not ext.pause_menu:IsKilled())) or false
end
-- 暂停列表没有桌面菜单的鼠标处理：按实际文字位置选行，点击确认，拖动只改变选中项。
function I.pauseMenu(menu, text)
    local t = I.pauseTap
    I.pauseTap = nil
    if not t then
        for _, touch in pairs(I.touches) do
            if touch.pauseMenu == menu then t = touch; break end
        end
    end
    if not t or t.pauseMenu ~= menu or t.pauseChoose ~= menu.choose then return end
    local x, top, count = menu.choose and 480 or menu.mask_x, menu.choose and 225 or 245, menu.choose and 2 or #text
    local row = math.floor((top-t.y)/25+0.5)+1
    if t.x < x-16 or t.x > x+(menu.choose and 150 or 205) or row < 1 or row > count
        or math.abs(t.y-(top-(row-1)*25)) > 12.5 then return end
    local field = menu.choose and 'pos2' or 'pos'
    if menu[field] ~= row then
        menu[field] = row
        PlaySound('select00', 0.3)
    end
    if t.pauseEnded and not t.pauseMoved then return 13 end
end
function I.pulse(key) I.pulses[key] = 2; I.last = key end
local function binding(action, fallback)
    return setting and setting.keys and setting.keys[action] or fallback
end
local function buttonKey(button) return button.action and binding(button.action, button.key) or button.key end
local function move(keys, action, fallback) keys[binding(action, fallback)] = true end
local function canDrag()
    -- 侧栏与场地共用相对拖动，不再保留左下角的摇杆区域。
    return lstg.world and player
end
local function clock() return lstg.AndroidClock and lstg.AndroidClock() or os.clock() end
local function controlBlocked(p)
    local death=p.death or 0
    -- death<50已进入可操作的复活阶段，>90也由自机系统视为正常；无敌protect不锁定移动。
    return p.lock or p.dialog or p.time_stop or p.realrealreal_lock or (death>=50 and death<=90)
end
local function tapInterval()
    return math.max(50,math.min(500,tonumber(setting and setting.touchBombInterval) or 170))/1000
end
local function rebuild()
    local old, keys = I.keys, {}
    local portrait=AndroidPortrait and AndroidPortrait.enabled()
    local menuMode,slowHeld=I.menuMode(),false
    I.mouse.down = false
    I.targetX, I.targetY = nil, nil
    if not menuMode then
        if portrait then I.toggles.shoot=true end
        for _,b in ipairs(buttons) do
            if b.toggle and I.toggles[b.action] and not (portrait and b.action=='slow') then keys[buttonKey(b)]=true end
        end
    end
    for _, t in pairs(I.touches) do
        if t.button then
            if portrait and t.button.action=='slow' then slowHeld=true
            elseif not t.button.toggle then keys[buttonKey(t.button)] = true end
        elseif not t.drag and not t.ignored then
            I.mouse.down = true; I.mouse.x = t.x; I.mouse.y = t.y
        end
    end
    if portrait and not menuMode then
        local mode=I.slowMode()
        local slow=mode==1 and I.toggles.slow or mode==2 and slowHeld or mode==3 and not slowHeld
        keys[binding('slow',16)]=slow or nil
    end
    local t = I.movementId and I.touches[I.movementId]
    if t and t.drag and t.player == player then
        -- 目标单独写入逻辑输入，不再将任意拖拽方向量化为八方向按键。
        I.targetX, I.targetY = t.targetX, t.targetY
        -- 已有的一字节录像 / 关卡检查点仍沿用方向键，避免继续后改变帧格式。
        if lstg.var and lstg.var.__input_version~=2 and not (GameNet and GameNet.client()) then
            local slow=keys[binding('slow',16)] or player.slow==1
            local threshold=(slow and (player.lspeed or 2) or (player.hspeed or 4))*.5
            local dx,dy=t.targetX-player.x,t.targetY-player.y
            if math.abs(dx)>threshold and math.abs(dy)>threshold then threshold=threshold*.70710678 end
            if dx < -threshold then move(keys,'left',37) end
            if dx > threshold then move(keys,'right',39) end
            if dy < -threshold then move(keys,'down',40) end
            if dy > threshold then move(keys,'up',38) end
        end
    end
    for key in pairs(keys) do if not old[key] then I.last = key end end
    I.keys = keys
end
function I.touch(id, x, y, event)
    if AndroidPortrait and AndroidPortrait.touch(id,x,y,event) then return end
    if event == 'ended' or event == 'cancelled' then
        local old = I.touches[id]
        if event=='ended' and old and old.drag and old.tapTime and not old.tapMoved and not old.bombTap
            and (x-old.tapX)^2+(y-old.tapY)^2<=144 and clock()-old.tapTime<=tapInterval() and not I.menuMode() then
            I.lastTap={time=old.tapTime,player=old.player}
        elseif event=='cancelled' then I.lastTap=nil end
        if I.trace and old and old.drag and player and lstg.SystemLog then
            lstg.SystemLog(string.format('BOSSRUSH_DRAG_END: target=%.3f,%.3f player=%.3f,%.3f',old.targetX,old.targetY,player.x,player.y))
        end
        if event == 'ended' and old and not old.button and not old.drag and not old.ignored then I.mouseTap = 2 end
        if event == 'ended' and old and old.pauseMenu then
            old.x, old.y, old.pauseEnded = x, y, true
            old.pauseMoved = old.pauseMoved or (x-old.pauseStartX)^2+(y-old.pauseStartY)^2>64
            I.pauseTap = old
        end
        I.touches[id] = nil
        if I.movementId == id then I.movementId = nil end
    else
        local t = I.touches[id]
        if not t then
            t = { x = x, y = y }
            local debugKey=I.menuMode() and GameDebug and GameDebug.touchKey(x,y)
            if debugKey and event=='began' then t.button={key=debugKey};I.pulse(debugKey) end
            if GameFeatures and GameFeatures.coop and x>=480 and x<=630 and y>=510 and y<=538 then t.button={key=120};I.pulse(120) end
            if GameFeatures and GameFeatures.resume and x>=640 and x<=790 and y>=510 and y<=538 then
                t.button={key=116}; I.pulse(116)
            end
            if GameFeatures and GameFeatures.saveSync and x>=800 and x<=956 and y>=510 and y<=538 then
                t.button={key=121}; I.pulse(121)
            end
            for _, button in ipairs(activeButtons(I.menuMode())) do
                if t.button then break end
                if math.abs(x-button.x)<=button.radius and math.abs(y-button.y)<=button.radius then
                    t.button = button
                    if button.toggle and event=='began' then I.toggles[button.action]=not I.toggles[button.action] end
                    if button.key == 27 then I.pulse(27) end
                    break
                end
            end
            if not t.button and not I.menuMode() and canDrag() then
                t.drag = true; t.player = player
                t.targetX, t.targetY = player.x, player.y
                if event=='began' then t.tapTime=clock();t.tapX,t.tapY=x,y end
                if I.trace and lstg.SystemLog then lstg.SystemLog(string.format('BOSSRUSH_DRAG_BEGIN: player=%.3f,%.3f target=%.3f,%.3f',player.x,player.y,t.targetX,t.targetY)) end
                if I.movementId then t.drag,t.ignored=nil,true
                else
                    I.movementId = id
                    if t.tapTime then
                        local last=I.lastTap
                        if last and last.player==player and t.tapTime-last.time<=tapInterval()
                            and not controlBlocked(player)
                            and not (GameRevive and GameRevive.active()) then
                            I.pulse(binding('spell',88));t.bombTap=true
                        end
                        I.lastTap=nil
                    end
                end
            end
            local pause = ext and ext.pause_menu
            if not t.button and pause and not pause:IsKilled() and not pause.lock and pause.t < 1 then
                t.pauseMenu, t.pauseChoose = pause, pause.choose
                t.pauseStartX, t.pauseStartY = x, y
            end
            if t.button then I.lastTap=nil end
            I.touches[id] = t
        elseif t.drag and t.player == player then
            if t.tapX and (x-t.tapX)^2+(y-t.tapY)^2>144 then t.tapMoved=true end
            local w, offset = lstg.world, lstg.worldoffset or {}
            local sx = (w.r-w.l)/(w.scrr-w.scrl)/(offset.hscale or 1)
            local sy = (w.t-w.b)/(w.scrt-w.scrb)/(offset.vscale or 1)
            t.targetX = math.max(w.pl+8, math.min(w.pr-8, t.targetX+(x-t.x)*sx))
            t.targetY = math.max(w.pb+16, math.min(w.pt-32, t.targetY+(y-t.y)*sy))
        elseif not t.button and not t.drag and not t.ignored then
            I.wheel = I.wheel - (y-t.y)*8
            if t.pauseMenu and (x-t.pauseStartX)^2+(y-t.pauseStartY)^2>64 then t.pauseMoved=true end
        end
        t.x, t.y = x, y
    end
    rebuild()
end
function I.reset(keepToggles)
    I.touches = {}; I.movementId = nil; I.keys = {}; I.pulses = {}; I.mouse.down = false; I.mouseTap = 0; I.wheel = 0; I.last = nil; I.lastTap=nil; I.targetX, I.targetY = nil, nil
    if not keepToggles then I.toggles={} end
    I.pauseTap = nil
    if AndroidPortrait then AndroidPortrait.clearInput() end
end
-- 以 1/16 世界单位记录目标，触控、录像与联机使用相同的确定性坐标。
function I.readMovement(out)
    out.touch_x, out.touch_y, out.touch_unlimited = nil, nil, nil
    if I.targetX and not I.menuMode() then
        out.touch_x = math.floor(I.targetX*16+0.5)/16
        out.touch_y = math.floor(I.targetY*16+0.5)/16
        if GameNet and GameNet.client() then out.touch_unlimited=setting.touchUnlimited==true
        else out.touch_unlimited=lstg.var and lstg.var.__touch_unlimited==true end
    end
end
local previousMode, previousStage, previousPlayer
function I.beginFrame()
    if AndroidPortrait then AndroidPortrait.dispatch() end
    local mode = I.menuMode()
    -- 普通暂停只释放触点并暂时屏蔽开关，继续时沿用；回标题 / 切后台则清除开关。
    if previousMode ~= nil and previousMode ~= mode then I.reset(true) end
    if ext and ext.StageIsMenu() then I.toggles={};previousStage,previousPlayer=nil,nil end
    local currentStage = stage and stage.current_stage
    -- 每次进入新关卡（含直接启动）默认低速、射击；暂停回来沿用玩家的开关。
    if not mode and (previousStage ~= currentStage or previousPlayer ~= player) then
        I.reset(true)
        I.toggles.shoot, I.toggles.slow = true, true
    end
    if not mode then previousStage, previousPlayer = currentStage, player end
    previousMode = mode
    local t = I.movementId and I.touches[I.movementId]
    if t and t.drag then
        if t.player ~= player then
            t.drag, t.ignored, I.movementId = nil, true, nil
        end
    end
    rebuild()
end
function I.endFrame()
    for key, frames in pairs(I.pulses) do I.pulses[key] = frames > 1 and frames - 1 or nil end
    I.last = nil; I.wheel = 0; I.mouseTap = math.max(0, I.mouseTap-1)
end
lstg.GetKeyState = function(key)
    if AndroidPortrait and AndroidPortrait.enabled() and not I.menuMode() and key==binding('spell',88) then
        return I.pulses[key]~=nil
    end
    return I.keys[key] or I.pulses[key] ~= nil or (toX[key] and rawKey(toX[key])) or false
end
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
    if AndroidPortrait then AndroidPortrait.coverOutside() end
    SetViewMode('ui')
    local menuMode = I.menuMode()
    for _, b in ipairs(activeButtons(menuMode)) do
        local active=I.keys[buttonKey(b)]
        if b==portraitSlow then AndroidPortrait.drawSlowButton(b,active) end
        if not (AndroidPortrait and AndroidPortrait.enabled()) then
            SetImageState('white', '', active and Color(180,40,110,75) or Color(90,34,57,82))
            RenderRect('white', b.x-b.radius, b.x+b.radius, b.y-b.radius, b.y+b.radius)
        end
        local label=b.label..(b.toggle and b~=portraitSlow and (I.toggles[b.action] and ' 开' or ' 关') or '')
        ui:RenderText('title',label,b.x,b.y,menuMode and .8 or .75,Color(230,235,241,247),'centerpoint')
    end
end
return I
