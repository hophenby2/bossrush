---=====================================
---luastg input
---=====================================

----------------------------------------
---按键状态更新

local KeyState = {}
local KeyStatePre = {}
local keys = setting.keys
_G.KeyState = KeyState
_G.KeyStatePre = KeyStatePre
---刷新输入
function GetInput()
    local GetKeyState = GetKeyState
    local rep = ext.replay
    if stage.next_stage then
        KeyStatePre = {}
    else
        -- 刷新KeyStatePre
        for k in pairs(keys) do
            KeyStatePre[k] = KeyState[k]
        end
    end
    if rep.IsRecording() then
        -- 更新按键状态

        for k, v in pairs(keys) do
            KeyState[k] = GetKeyState(v)
        end
        local PAD = { GetKeyState(97), GetKeyState(99), GetKeyState(103), GetKeyState(105) }
        KeyState["left"] = (PAD[1] or PAD[3] or GetKeyState(100)) or KeyState["left"]
        KeyState["right"] = (PAD[2] or PAD[4] or GetKeyState(102)) or KeyState["right"]
        KeyState["up"] = (PAD[3] or PAD[4] or GetKeyState(104)) or KeyState["up"]
        KeyState["down"] = (PAD[1] or PAD[2] or GetKeyState(98)) or KeyState["down"]
        if not GetKeyState(keys.shoot) and GetKeyState(KEY.CTRL) then
            KeyState["shoot"] = not KeyStatePre["shoot"]
        end
        -- 记录当前帧的按键
        replayWriter:Record(KeyState)
    elseif rep.IsReplay() then
        -- 载入按键状态
        replayReader:Next(KeyState)
    end
end

---是否按下
function KeyIsDown(key)
    return KeyState[key]
end

---是否在当前帧按下
function KeyIsPressed(key)
    return KeyState[key] and (not KeyStatePre[key])
end

---将按键二进制码转换为字面值，用于设置界面
function KeyCodeToName()
    local key2name = {}
    --按键code（参见launch和微软文档）作为索引，名称为值
    for k, v in pairs(KEY) do
        key2name[v] = k
    end
    --似乎是按照keycode从0到255重新排列keyname
    for i = 0, 255 do
        key2name[i] = key2name[i] or '?'
    end
    return key2name
end
