---=====================================
---luastg scoredata
---=====================================

----------------------------------------
---scoredata
---冒出来的null太可恶了
local function CheckData(_data)
    for k, v in pairs(_data) do
        if type(v) == "table" then
            CheckData(v)
        elseif type(v) == "userdata" then
            _data[k] = false
        end
    end
end

function InitScoreData()
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local file = "User\\Score.dat"
    --读取文件
    local data
    if not FileExist(file) then
        data = {}
    else
        local scoredata_file = io.open(file, "rb")
        local text = sp:UnLockString(scoredata_file:read("*a"))
        if pcall(DeSerialize, text) then
            data = DeSerialize(text)
        else
            lstg.ExtractRes(file, "User\\Score_error.dat")
            lstg.MsgBoxError("读取 Score.dat 失败\n已为您保留出现错误的存档\n请及时联系作者反馈此问题", "Warning!!", false)
            data = {}
        end
        scoredata_file:close()
        scoredata_file = nil
    end
    --初始化
    do
        data.Manual = data.Manual or {}
        data.Achievement = data.Achievement or {}
        data.NoticeAchievement = data.NoticeAchievement or {}
        -- for i = 1, #ext.manual.text do
        --     data.Manual[i] = data.Manual[i] == true
        --   end
        data.Duration = data.Duration or { 0, 0, 0, 0, 0 }
        data.stage_practice = data.stage_practice or {}
        data.UnlockSC = data.UnlockSC or {}
        data.UnlockSystem = data.UnlockSystem or {}
        for i = 1, SYSTEM_COUNT do
            data.UnlockSystem[i] = data.UnlockSystem[i] == true
        end
        --data.HideValue = data.HideValue or 0
        --frame,second,minute,hour,day
        data.ContinuousLogin = data.ContinuousLogin or 1
        local d = os.date("*t")
        data.LastLoginDate = data.LastLoginDate or os.time({ day = d.day, month = d.month, year = d.year })
        data.Player_playtime = data.Player_playtime or { 0, 0, 0, 0 }
        data.money = data.money or 0
        data.AllFinishCount = data.AllFinishCount or { 0, 0, 0, 0 }
        data.UnlockAya = data.UnlockAya == true
        data.UnlockChiruno = data.UnlockChiruno == true
        data.bought = data.bought or {}
        data.hair = data.hair or 0
        data.total_icecount = data.total_icecount or 0--琪露诺总共冻结的弹幕数
        data.total_photocount = data.total_photocount or 0--射命丸文总共拍照的照片数
    end
    CheckData(data)
    scoredata = data
end
function InitSpellCardData()
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local file = "User\\Spellcard.dat"
    --读取文件
    local data
    if not FileExist(file) then
        data = {}
    else
        local spell_card_data_file = io.open(file, "rb")
        local text = sp:UnLockString(spell_card_data_file:read("*a"))
        --Print(text)
        if pcall(DeSerialize, text) then
            data = DeSerialize(text)
        else
            lstg.ExtractRes(file, "User\\Spellcard_error.dat")
            lstg.MsgBoxError("读取 Spellcard.dat 失败\n已为您保留出现错误的存档\n请及时联系作者反馈此问题", "Warning!!", false)
            data = {}
        end
        spell_card_data_file:close()
        spell_card_data_file = nil
    end
    CheckData(data)
    spell_card_data = data
end

function SaveScoreData()
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local score_data_file = io.open("User\\Score.dat", "wb")
    score_data_file:write(sp:LockString(Serialize(scoredata)))
    score_data_file:close()
end

function SaveSpellCardData()
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local spell_card_data_file = io.open("User\\Spellcard.dat", "wb")
    spell_card_data_file:write(sp:LockString(Serialize(spell_card_data)))
    spell_card_data_file:close()
end

function DataBackUp()
    local file = io.open("User\\Score.dat.bak", "wb")
    for str in io.lines("User\\Score.dat") do
        file:write(str .. "\n")
    end
    file:close()
    file = io.open("User\\Spellcard.dat.bak", "wb")
    for str in io.lines("User\\Spellcard.dat") do
        file:write(str .. "\n")
    end
    file:close()
end
