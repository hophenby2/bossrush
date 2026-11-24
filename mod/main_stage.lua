local original_flow=dofile('mod/GAME/original/stage_flow.lua')
-- 练习与整关统一使用当前原作阶段顺序。
local sg = stage.group
sg.New('menu', {}, "BossRush", true, 1)

stage_selects = {}
---@param event fun(self:stage)
local function NewStage(name, name2, level, event)
    local s = sg.AddStage("BossRush", name .. '@BossRush', true)
    sg.DefStageValue(s.name, 'displayname', name2)
    sg.DefStageValue(s.name, 'level', level)
    sg.DefStageValue(s.name, 'init', event)
    if name2 then
        ---@class stage_unit
        local unit = {
            id = level,
            title = name2,
            tex = "stage_pic" .. level,
            pulse = 0,
            stage = s,
            unlock_way = function()
                if scoredata.stage_practice[level] then
                    return true
                else
                    return ("请先通关：%s"):format(name2)
                end
            end
        }
        stage_selects[level] = unit
    end
end

NewStage("TH31", "永夜抄原作", 29, function(self)
    self:Option(TH08_bg, "TH08_NEW_0")
    self:Task(function() original_flow.run(self.level) end)
    self:Next(52)
end)--29

NewStage("TH32", "红魔乡原作", 30, function(self)
    self:Option(TH06_bg, "TH06_0")
    self:Task(function() original_flow.run(self.level) end)
    self:Next(52)
end)--30

NewStage("TH33", "文花帖原作", 31, function(self)
    ---复用 TH095（文花帖）的背景类与 BGM「幽雅に咲かせ、墨染の桜」——
    ---这张卡就是文花帖第 7 关第 5 幕，幽幽子自己的主题曲。
    self:Option(TH095_bg, "TH07_1")
    self:Task(function() original_flow.run(self.level) end)
    ---166 = 本关自己的通关成就（165 是 TH32 的）。注意 TH31/TH32 那两行写的是 52，
    ---那是 TH06 的成就 id —— 抄过来的话通关会给「驱散红雾之日」。
    self:Next(166)
end)--31

NewStage("TH34", "妖妖梦原作", 32, function(self)
    ---复用 TH07（妖妖梦）第 6 面的背景类与 BGM「幽雅に咲かせ、墨染の桜」（mod/music.lua:25），
    ---与 mod/GAME/th34.lua 里 boss.Define 用的那两个参数必须一致。
    self:Option(TH07_bg, "TH07_1")
    self:Task(function() original_flow.run(self.level) end)
    ---167 = 本关自己的通关成就（166 是 TH33 的）。
    self:Next(167)
end)--32

NewStage("TH35", "风神录原作", 33, function(self)
    ---复用 TH10（风神录）的背景类与 BGM「神さびた古戦場」（mod/music.lua:42），
    ---与 mod/GAME/th35.lua 里 boss.Define 用的那两个参数（"TH10_2" + TH10_bg）必须一致。
    self:Option(TH10_bg, "TH10_2")
    self:Task(function() original_flow.run(self.level) end)
    ---168 = 本关自己的通关成就（167 是 TH34 的）。
    self:Next(168)
end)--33

-- 独立来源编号35，关卡编号与练习存档保持稳定。
NewStage("TH37", "幕华祭春雪篇", 35, function(self)
    self:Option()
    self:Task(function()
        for _,chapter in ipairs(TH37.data.chapters) do TH37.runChapter(self,chapter) end
        task.Wait(120)
    end)
    self:Next()
end)

-- 雪莲华独立关卡练习；顺序模式分别选择Lunatic或Extra A。
NewStage("TH38", "雪莲华", 36, function(self)
    self:Option()
    self:Task(function()
        for _,chapter in ipairs(TH38.data.chapters) do TH38.runChapter(self,chapter) end
        task.Wait(120)
    end)
    self:Next()
end)
-- 幕华祭永夜篇整关练习使用同一关卡轴；Last Word 从符卡练习进入。
NewStage("TH39", "幕华祭永夜篇", 37, function(self)
    self:Option()
    self:Task(function()
        for _,chapter in ipairs(TH39.data.chapters) do
            if chapter.difficulty~=9 then TH39.runChapter(self,chapter) end
        end
        task.Wait(120)
    end)
    self:Next()
end)

-- 三作沿用同一份道中和攻击链。
NewStage("TH40", "夏夜祭原作", 38, function(self)
    self:Option()
    self:Task(function() original_flow.run(self.level) end)
    self:Next(170)
end)

local ports=dofile('mod/GAME/ports/register.lua')
for _,level in ipairs({39,40}) do
    local work=GameContent.ports[level]
    local title=level==39 and '祈华梦原作' or 'Like Dreamer'
    NewStage(work.code,title,level,function(self)
        self:Option()
        self:Task(function() ports.run(work,self) end)
        self:Next()
    end)
end

NewStage("TH43", "栖霞园原作", 41, function(self)
    self:Option()
    self:Task(function()
        for i=1,6 do TH43.runChapter(self,{name=tostring(i)}) end
        TH43.runChapter(self,{name='EX'})
    end)
    self:Next()
end)
