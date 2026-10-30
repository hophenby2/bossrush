local KEY_BIT = { 128, 64, 32, 16, 8, 4, 2, 1 }
local KEY_NAME = { "up", "down", "left", "right", "slow", "shoot", "spell", "special" }
local math, string = math, string
local assert = assert
---将按键状态转换为二进制数值
---@return number@返回二进制按键数值
function KeyState2Byte(state)
    local ret = 0
    for i, k in ipairs(KEY_NAME) do
        if state[k] then
            ret = ret + KEY_BIT[i]
        end
    end
    return ret
end

---将二进制数值转换为按键状态
function Byte2KeyState(state, b)
    for i, k in ipairs(KEY_NAME) do
        if b >= KEY_BIT[i] then
            state[k] = true
            b = b - KEY_BIT[i]
        else
            state[k] = false
        end
    end
end

-- 新录像每帧多存四字节拖拽目标；旧版仍是一字节按键，按关卡初态区分。
function PackTouchInput(state)
    if state.touch_x == nil or state.touch_y == nil then return string.char(255,255,255,255) end
    local function coord(v) return math.max(0,math.min(65534,math.floor(v*16+0.5)+32768)) end
    local x,y=coord(state.touch_x),coord(state.touch_y)
    return string.char(x%256,math.floor(x/256),y%256,math.floor(y/256))
end
function UnpackTouchInput(state,bytes)
    local a,b,c,d=bytes:byte(1,4);assert(d,'拖拽输入不完整')
    local x,y=a+b*256,c+d*256
    state.touch_x,state.touch_y=nil,nil
    if x~=65535 and y~=65535 then state.touch_x=(x-32768)/16;state.touch_y=(y-32768)/16 end
end
local function touchFormat() return lstg and lstg.var and lstg.var.__input_version==2 end

-------------------------------------------------- ReplayFrameReader

---@class ReplayFrameReader
local ReplayFrameReader = plus.Class()
plus.ReplayFrameReader = ReplayFrameReader

---构造ReplayFrameReader
---@param path string@文件路径
---@param offset number@录像数据偏移
---@param count number@录像帧数量
function ReplayFrameReader:init(path, offset, count, inputVersion)
    self._fs = plus.FileStream(__UTF8ToANSI(path), "rb")

    self._fs:Seek(offset)-- 定位到录像数据开始位置
    self._offset = offset
    self._touch = inputVersion==2 or (inputVersion==nil and touchFormat())
    self._read = 0  -- 已读取数量
    self._count = count  -- 帧数量
end

---下一帧
---@return boolean@若达到结尾则返回False，否则返回True
function ReplayFrameReader:Next(state)
    if self._read >= self._count then
        return false
    else
        local ret = self._fs:ReadByte()
        self._read = self._read + 1
        Byte2KeyState(state, ret)
        state.touch_x,state.touch_y,state.touch_unlimited=nil,nil,nil
        if self._touch then
            local bytes={};for i=1,4 do bytes[i]=string.char(assert(self._fs:ReadByte())) end
            UnpackTouchInput(state,table.concat(bytes))
        end
        return true
    end
end

---重置
function ReplayFrameReader:Reset()
    self._read = 0
    self._fs:Seek(self._offset)
end

---关闭文件流
function ReplayFrameReader:Close()
    self._fs:Close()
end

-------------------------------------------------- ReplayFrameWriter

---@class ReplayFrameWriter
local ReplayFrameWriter = plus.Class()
plus.ReplayFrameWriter = ReplayFrameWriter

---构造ReplayFrameWriter
function ReplayFrameWriter:init(inputVersion)
    self._data = {}
    self._touch = inputVersion==2 or (inputVersion==nil and touchFormat())
    self._targets = {}
    self._count = 0
end

---录取按键状态
function ReplayFrameWriter:Record(state)
    local b = KeyState2Byte(state)
    self._count = self._count + 1
    self._data[self._count] = b
    if self._touch then self._targets[self._count]=PackTouchInput(state) end
end

---将数据写成字节
---@param fs FileStream
function ReplayFrameWriter:Write(fs)
    for i = 1, self._count do
        fs:WriteByte(self._data[i])
        if self._touch then
            local target=self._targets[i];for j=1,4 do fs:WriteByte(target:byte(j)) end
        end
    end
end

---获取帧数量
function ReplayFrameWriter:GetCount()
    return self._count
end

-------------------------------------------------- ReplayManager

---@class ReplayManager
local ReplayManager = plus.Class()
plus.ReplayManager = ReplayManager

---构造ReplayManager
---@param replayDirectory string@录像文件夹
---@param format string
---@param name string
function ReplayManager:init(replayDirectory, format, name)
    self._repdir = replayDirectory
    format = format or "rep"
    name = name or "slot"
    self._filefmt = "^" .. name .. "(%d+)%." .. format .. "$"
    self._filefmt2 = name .. "%d." .. format
    self._slots = nil
    self._slotmax = 16

    -- 检查录像目录是否存在
    if not plus.DirectoryExists(replayDirectory) then
        plus.CreateDirectory(replayDirectory)
    end

    -- 刷新录像数据
    self:Refresh()
end

---[静态函数]读取录像数据
---返回的录像数据信息以下述格式表述：
---{
---  path = "文件路径",
---   fileVersion = 1, gameName = "游戏名称", gameVersion = 1, gameExtendInfo = "",
---   userName = "用户名", userExtendInfo = "用户额外信息",
---    stages = {
---      {
---        stageName = "关卡名称", stageExtendInfo = "", score = 0, randomSeed = 0,
---       stageTime = 0, stageDate = 0, stagePlayer=lstg.var.rep_player，
---       frameCount = 300, frameDataPosition = 12345
---      }
---    }
---  }
---@param path string
function ReplayManager.ReadReplayInfo(path)
    local ret = { path = path }
    local f = plus.FileStream(__UTF8ToANSI(path), "rb")
    local r = plus.BinaryReader(f)

    plus.TryCatch {
        try = function()
            -- 读取文件头
            assert(r:ReadString(4) == "STGR", "invalid file format.")

            -- 版本号1
            ret.fileVersion = r:ReadUShort()  -- 文件版本
            assert(ret.fileVersion == 1, "unsupported file version.")

            -- 游戏数据
            local gameNameLength = r:ReadUShort()  -- 游戏名称
            ret.gameName = r:ReadString(gameNameLength)
            ret.gameVersion = r:ReadUShort()  -- 游戏版本
            ret.group_finish = r:ReadUShort() --是否完成关卡
            local gameExtendInfoLength = r:ReadUInt()  -- 额外信息
            ret.gameExtendInfo = r:ReadString(gameExtendInfoLength)

            -- 玩家信息
            local userNameLength = r:ReadUShort()  -- 机签
            ret.userName = r:ReadString(userNameLength)
            local userExtendInfoLength = r:ReadUInt()  -- 额外信息
            ret.userExtendInfo = r:ReadString(userExtendInfoLength)

            -- 关卡数据
            ret.stages = {}
            local recordStageCount = r:ReadUShort()  -- 关卡数量
            for _ = 1, recordStageCount do
                local stage = {}

                local stageNameLength = r:ReadUShort()  -- 关卡名称
                stage.stageName = r:ReadString(stageNameLength)
                local stageExtendInfoLength = r:ReadUInt()  -- 额外信息
                stage.stageExtendInfo = r:ReadString(stageExtendInfoLength)
                local scoreHigh = r:ReadUInt()  -- 分数的高32位
                local scoreLow = r:ReadUInt()  -- 分数的低32位
                stage.score = scoreLow + scoreHigh * 0x100000000
                stage.randomSeed = r:ReadUInt()  -- 随机数种子
                --stage.stageTime = r:ReadFloat()  -- 通关时间
                stage.stageDate = r:ReadUInt()  -- 游戏日期(UNIX时间戳)
                local stagePlayerLength = r:ReadUShort()  -- 使用自机
                stage.stagePlayer = r:ReadString(stagePlayerLength)
                --                   local stage_num = r:ReadUShort()  --关卡所在位置
                --                   stage.cur_stage_num = stage_num
                --                   stage.group_num= r:ReadUShort() --关卡组长度
                -- 录像数据
                stage.frameCount = r:ReadUInt()  -- 帧数
                stage.frameDataPosition = f:GetPosition()  -- 数据起始位置
                local initial=stage.stageExtendInfo~='' and DeSerialize(stage.stageExtendInfo) or {}
                f:Seek(stage.frameCount*(initial.__input_version==2 and 5 or 1))  -- 跳过帧数据
                table.insert(ret.stages, stage)
            end
        end,
        finally = function()
            f:Close()
        end
    }

    return ret
end

---[静态函数]写入录像数据
---输入的录像信息需要满足下述表述：
---  {
---    gameName = "游戏名称", gameVersion = 1, gameExtendInfo = "额外信息",
---    userName = "用户名", userExtendInfo = "用户额外信息",
---    stages = {
---      {
---        stageName = "关卡名称", stageExtendInfo = "", score = 0, randomSeed = 0,
---        stageTime = 0, stageDate = 0, stagePlayer=lstg.var.rep_player，
---       frameData = ReplayFrameWriter()
---      }
---    }
---  }
---@param path string
---@param data table
function ReplayManager.SaveReplayInfo(path, data)
    local f = plus.FileStream(__UTF8ToANSI(path), "wb")
    local w = plus.BinaryWriter(f)

    ---用于记录当前replay文件是否已经完整保存
    ---如果保存中途出错，那么该文件会在finally函数中删除，防止下次进入游戏时读取到损坏的录像文件导致再次炸游戏
    local _save_finish = false

    plus.TryCatch {
        try = function()
            -- 写入文件头
            w:WriteString("STGR", false)

            -- 版本号1
            w:WriteUShort(1)

            -- 游戏数据
            w:WriteUShort(string.len(data.gameName))  -- 游戏名称
            w:WriteString(data.gameName, false)
            w:WriteUShort(data.gameVersion)  -- 游戏版本
            w:WriteUShort(data.group_finish) --是否完成关卡
            if data.gameExtendInfo then
                w:WriteUInt(string.len(data.gameExtendInfo))  -- 额外信息
                w:WriteString(data.gameExtendInfo, false)
            else
                w:WriteUInt(0)
            end

            -- 玩家信息
            w:WriteUShort(string.len(data.userName))  -- 机签
            w:WriteString(data.userName, false)
            if data.userExtendInfo then
                w:WriteUInt(string.len(data.userExtendInfo))  -- 额外信息
                w:WriteString(data.userExtendInfo, false)
            else
                w:WriteUInt(0)
            end

            -- 关卡数据
            local stageCount = #data.stages
            w:WriteUShort(stageCount)  -- 关卡数量
            for i = 1, stageCount do
                local stage = data.stages[i]

                w:WriteUShort(string.len(stage.stageName))  -- 关卡名称
                w:WriteString(stage.stageName, false)
                if stage.stageExtendInfo then
                    w:WriteUInt(string.len(stage.stageExtendInfo))  -- 额外信息
                    w:WriteString(stage.stageExtendInfo, false)
                else
                    w:WriteUInt(0)
                end
                w:WriteUInt(math.floor(stage.score / 0x100000000))  -- 分数的高32位
                w:WriteUInt(math.floor(stage.score % 0x100000000))  -- 分数的低32位
                w:WriteUInt(stage.randomSeed)  -- 随机数种子
                --w:WriteFloat(stage.stageTime or 0)  -- 通关时间
                w:WriteUInt(stage.stageDate or 0)  -- 游戏日期(UNIX时间戳)
                w:WriteUShort(string.len(stage.stagePlayer))  -- 使用自机
                w:WriteString(stage.stagePlayer, false)
                --                   w:WriteUShort(stage.cur_stage_num)--关卡所在位置
                --                   w:WriteUShort(stage.group_num)  --关卡组长度
                -- 录像数据
                w:WriteUInt(stage.frameData:GetCount())  -- 帧数
                stage.frameData:Write(f)  -- 数据
            end

            _save_finish = true
        end,
        finally = function()
            f:Close()
            if not (_save_finish) then
                f:Delete()--by ETC
            end
        end
    }
end

---给存档系统用的保存录像
---@param data table
function ReplayManager.SaveReplayInfo2(data)
    --先存在saving.file里
    local f = plus.FileStream(__UTF8ToANSI(SaveProfiles.path("saving.file")), "wb")
    local w = plus.BinaryWriter(f)
    local _save_finish = false
    plus.TryCatch {
        try = function()
            -- 写入文件头
            w:WriteString("STGR", false)

            -- 版本号1
            w:WriteUShort(1)

            -- 游戏数据
            w:WriteUShort(string.len(data.gameName))  -- 游戏名称
            w:WriteString(data.gameName, false)
            w:WriteUShort(data.gameVersion)  -- 游戏版本
            w:WriteUShort(data.group_finish) --是否完成关卡
            if data.gameExtendInfo then
                w:WriteUInt(string.len(data.gameExtendInfo))  -- 额外信息
                w:WriteString(data.gameExtendInfo, false)
            else
                w:WriteUInt(0)
            end

            -- 玩家信息
            w:WriteUShort(string.len(data.userName))  -- 机签
            w:WriteString(data.userName, false)
            if data.userExtendInfo then
                w:WriteUInt(string.len(data.userExtendInfo))  -- 额外信息
                w:WriteString(data.userExtendInfo, false)
            else
                w:WriteUInt(0)
            end

            -- 关卡数据
            local stageCount = #data.stages
            w:WriteUShort(stageCount)  -- 关卡数量
            for i = 1, stageCount do
                local stage = data.stages[i]

                w:WriteUShort(string.len(stage.stageName))  -- 关卡名称
                w:WriteString(stage.stageName, false)
                if stage.stageExtendInfo then
                    w:WriteUInt(string.len(stage.stageExtendInfo))  -- 额外信息
                    w:WriteString(stage.stageExtendInfo, false)
                else
                    w:WriteUInt(0)
                end
                w:WriteUInt(math.floor(stage.score / 0x100000000))  -- 分数的高32位
                w:WriteUInt(math.floor(stage.score % 0x100000000))  -- 分数的低32位
                w:WriteUInt(stage.randomSeed)  -- 随机数种子
                --w:WriteFloat(stage.stageTime or 0)  -- 通关时间
                w:WriteUInt(stage.stageDate or 0)  -- 游戏日期(UNIX时间戳)
                w:WriteUShort(string.len(stage.stagePlayer))  -- 使用自机
                w:WriteString(stage.stagePlayer, false)
                --                   w:WriteUShort(stage.cur_stage_num)--关卡所在位置
                --                   w:WriteUShort(stage.group_num)  --关卡组长度
                -- 录像数据
                w:WriteUInt(stage.frameData:GetCount())  -- 帧数
                stage.frameData:Write(f)  -- 数据
            end

            _save_finish = true
        end,
        finally = function()
            f:Close()
            if not (_save_finish) then
                --如果失败，就删掉文件，顺便警告一下
                f:Delete()--by ETC
                lstg.MsgBoxWarn([[非常抱歉！
                存档的时候出现了点问题！
                这是什么问题咱也不知道）
                请及时向作者反馈，
                希望有朝一日能解决这个问题（]])
            else
                --如果成功，就替换文件
                SaveProfiles.atomic(SaveProfiles.path("saving1.file"),
                    assert(SaveProfiles.readFile(SaveProfiles.path("saving.file"))))
                os.remove(SaveProfiles.path("saving.file"))
            end

        end
    }
end

---获取录像目录
function ReplayManager:GetReplayDirectory()
    return self._repdir
end

----构造录像文件名称
function ReplayManager:MakeReplayFilename(slot)
    return self._repdir .. "\\" .. string.format(self._filefmt2, slot)
end

---刷新
function ReplayManager:Refresh()
    self._slots = {}

    local files = plus.EnumFiles(self._repdir)
    for _, v in ipairs(files) do
        local _, _, id = string.find(v.real_name, self._filefmt)
        if v.isDirectory == false and id ~= nil then
            id = tonumber(id)
            assert(self._slots[id] == nil)
            local filename = v.name
            if not (id <= 0 or id > self._slotmax) then
                plus.TryCatch {
                    try = function()
                        self._slots[id] = ReplayManager.ReadReplayInfo(filename)
                    end,
                    catch = function(err)
                        self._slots[id] = nil
                        SystemLog("加载录像文件'" .. filename .. "'失败: " .. err)
                    end
                }
            end
        end
    end
end

---获取录像数量
function ReplayManager:GetSlotCount()
    return self._slotmax
end

---获取录像信息
---@param slot number@录像槽
function ReplayManager:GetRecord(slot)
    assert(slot >= 0 and slot <= self._slotmax, "invalid argument.")
    return self._slots[slot]
end
