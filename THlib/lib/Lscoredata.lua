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

---把符卡历史表补齐成「稠密数组」再交给 Serialize。
---引擎的 Serialize 是 cjson：一张表如果所有键都是 >=1 的整数，就按 JSON 数组编码，
---而 lua-cjson 的 lua_array_length() 有一条「稀疏数组」防御 ——
---    max(最大整数键) > 元素个数 × 2  且  max > 10   ⇒  直接报错
---    「Cannot serialise table: excessively sparse array」
---本作的符卡 id 是刻意不连续的（th33 用到 501，th34 用自己独立的一段 3400..3488，
---中间 2898 个号空着），所以最大键 3488 远大于「注册过的卡数 ≤ 502 的两倍」，
---每次切关时的 SaveSpellCardData 都会在这里炸掉 —— 游戏因此一关都进不去。
---这里只在 cjson 会拒绝的时候把 1..max 之间的空洞补成 false（编成稠密数组；
---补出来的 false 下次载入后仍是 false，读卡表的地方本来就是先判空再取 ——
---真正有卡片的 id 一定有表）。cjson 能接受时原样返回，不动文件格式。
function EncodeSpellCardData()
    local data = spell_card_data
    local max, count, allnum = 0, 0, true
    for k in pairs(data) do
        if type(k) == "number" and k >= 1 and k % 1 == 0 then
            if k > max then max = k end
            count = count + 1
        else
            allnum = false
        end
    end
    if not allnum or max <= 10 or max <= count * 2 then
        return data
    end
    local out = {}
    for i = 1, max do
        local v = data[i]
        if v == nil then
            v = false
        end
        out[i] = v
    end
    return out
end

function SaveSpellCardData()
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local spell_card_data_file = io.open("User\\Spellcard.dat", "wb")
    spell_card_data_file:write(sp:LockString(Serialize(EncodeSpellCardData())))
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
