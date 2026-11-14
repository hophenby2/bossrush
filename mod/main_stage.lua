local original_flow=dofile('mod/GAME/original/stage_flow.lua')
-- 新局使用共用原作顺序；下方原Task保留给没有流程版本标记的旧录像。
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
    self:Task(function()
        if lstg.var.__original_flow_version==original_flow.VERSION then original_flow.run(self.level);return end
        task.Wait(60)
        ---一张一张来（boss.CreateGroup 会阻塞到这张卡打完）。
        ---原来分成 1..7 / 8..17 两段没有意义；真正的坑是旧版把 17 个角色全
        ---登记在组 1 的 a..q 上，CreateGroup(1) 会一次把 17 个 boss 全建出来。
        ---★ 1..17 是 17 个 Last Word 角色，**别改成别的数**。两个非 Last Word 的
        ---  原作中 BOSS 用额外的组：组 19 = EX 白泽慧音、组 18 = 五面因幡帝。
        ---  必须在组 3 / 组 4 之间插入：这样 EX 白泽慧音紧跟人类慧音，五面道中与帝
        ---  紧贴铃仙组；放到循环末尾会把这两段拆到全部 Last Word 之后。
        for i = 1, 17 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
            if i == 3 then
                boss.CreateGroup(19, self.level)
                task.Wait(60)
                boss.CreateGroup(18, self.level)
                task.Wait(60)
            end
        end
    end)
    self:Next(52)
end)--29

NewStage("TH32", "红魔乡原作", 30, function(self)
    self:Option(TH06_bg, "TH06_0")
    self:Task(function()
        if lstg.var.__original_flow_version==original_flow.VERSION then original_flow.run(self.level);return end
        -- 各面道中前半 → 中 Boss → 道中后半 → 主 Boss；帕秋莉保留四条机体路线。
        for _, group in ipairs(_editor_class["TH32"].boss_order) do
            boss.CreateGroup(group, self.level)
            task.Wait(120)
        end
    end)
    self:Next(52)
end)--30

NewStage("TH33", "文花帖原作", 31, function(self)
    ---复用 TH095（文花帖）的背景类与 BGM「幽雅に咲かせ、墨染の桜」——
    ---这张卡就是文花帖第 7 关第 5 幕，幽幽子自己的主题曲。
    self:Option(TH095_bg, "TH07_1")
    self:Task(function()
        if lstg.var.__original_flow_version==original_flow.VERSION then original_flow.run(self.level);return end
        ---两个 boss 组：组 1 = 西行寺幽幽子（71/73/75/77），组 2 = 魂魄妖梦（72/74/76）。
        ---CreateGroup 按「组号 + 字母 + 关卡号」枚举，所以两次调用正好各建一个 boss。
        boss.CreateGroup(1, self.level)
        task.Wait(120)
        boss.CreateGroup(2, self.level)
        task.Wait(120)
        ---Stage EX（th095 的 scene 100..107，见 mod/GAME/th33.lua）：
        ---组 3 = 芙兰朵露（100/101）、组 4 = 八云紫（102/103）、
        ---组 5 = 藤原妹红（104/105）、组 6 = 伊吹萃香（106/107）。
        for i = 3, 6 do
            boss.CreateGroup(i, self.level)
            task.Wait(120)
        end
        ---原作 scene group 9（world10）的 8 幕：90/92/94/96 是小町（ecl20_a..d）、
        ---91/93/95/97 是映姬（ecl21_a..d）。按「一个角色一个组」拆成两组：
        ---组 7 = 小町（4 张）、组 8 = 映姬（4 张）。★ 别把两人塞进同一个组的 a/b。
        boss.CreateGroup(7, self.level)
        task.Wait(120)
        boss.CreateGroup(8, self.level)
        task.Wait(120)
        ---原作 scene group 8（world09 = 永遠亭）的 8 幕：80/82/84/86 是永琳（ecl18_a..d）、
        ---81/83/85/87 是辉夜（ecl19_a..d）。同样按「一个角色一个组」拆成两组：
        ---组 9 = 永琳（4 张）、组 10 = 辉夜（4 张）。
        boss.CreateGroup(9, self.level)
        task.Wait(120)
        boss.CreateGroup(10, self.level)
        task.Wait(120)
        ---原作 scene group 6（world07 = 红魔馆）的 8 幕：60/62/64/66 是咲夜（ecl14_a..d）、
        ---61/63/65/67 是レミリア（ecl15_a..d）。同样按「一个角色一个组」拆成两组：
        ---组 11 = 咲夜（4 张）、组 12 = レミリア（4 张）。
        boss.CreateGroup(11, self.level)
        task.Wait(120)
        boss.CreateGroup(12, self.level)
        task.Wait(120)
        ---原作 scene group 5（world06 = 橙与八云蓝）的 8 幕：50/52/54/56 是橙（ecl12_a..d）、
        ---51/53/55/57 是八云蓝（ecl13_a..d）。同样按「一个角色一个组」拆成两组：
        ---组 13 = 橙（4 张）、组 14 = 八云蓝（4 张）。
        boss.CreateGroup(13, self.level)
        task.Wait(120)
        boss.CreateGroup(14, self.level)
        task.Wait(120)
        ---原作 scene group 4（world05 = 红魔馆 / 地下图书馆）的 8 幕：40/42/44/46 是红美铃
        ---（ecl10_a..d）、41/43/45/47 是帕秋莉（ecl11_a..d）。同样按「一个角色一个组」拆成
        ---两组：组 15 = 红美铃（4 张，第 1 张是非符）、组 16 = 帕秋莉（4 张）。
        boss.CreateGroup(15, self.level)
        task.Wait(120)
        boss.CreateGroup(16, self.level)
        task.Wait(120)
        ---原作 scene group 3（world04 = 迷いの竹林 / 永遠亭）的 9 幕：30/33/35/38 是メディスン
        ---（ecl7_a..d，第 1 张是非符）、31/34/36 是铃仙（ecl9_a..c）、32/37 是因幡帝
        ---（ecl8_a..b）。按「一个角色一个组」拆成三组：
        ---组 17 = メディスン（4 张，第 1 张非符）、组 18 = 铃仙（3 张）、组 19 = 因幡帝（2 张）。
        boss.CreateGroup(17, self.level)
        task.Wait(120)
        boss.CreateGroup(18, self.level)
        task.Wait(120)
        boss.CreateGroup(19, self.level)
        task.Wait(120)
        ---原作 scene group 2（world03 = 魔法の森）的 8 幕：20/22/24/26 是アリス（ecl6_a..d，
        ---第 1 张是非符）、21/23/25/27 是上白沢慧音（ecl5_a..d）。按「一个角色一个组」拆成
        ---两组：组 20 = アリス（4 张）、组 21 = 慧音（4 张）。
        boss.CreateGroup(21, self.level)
        task.Wait(120)
        ---原作 scene group 1（world02 = 魔法の森）的 6 幕：10/12/14 是チルノ（ecl3_a..c）、
        ---11/13/15 是レティ（ecl4_a..c）。按「一个角色一个组」拆成两组：
        ---组 22 = チルノ（3 张，第 1 张非符）、组 23 = レティ（3 张，第 1 张非符）。
        boss.CreateGroup(22, self.level)
        task.Wait(120)
        boss.CreateGroup(23, self.level)
        task.Wait(120)
        ---原作 scene group 0（world01 = 夜の森）的 6 幕：0/2/4 是リグル（ecl1_a..c）、
        ---1/3/5 是ルーミア（ecl2_a..c）。同样拆成：组 24 = リグル（3 张，第 1 张非符）、
        ---组 25 = ルーミア（3 张，第 1 张非符）。
        boss.CreateGroup(24, self.level)
        task.Wait(120)
        boss.CreateGroup(25, self.level)
        task.Wait(120)
    end)
    ---166 = 本关自己的通关成就（165 是 TH32 的）。注意 TH31/TH32 那两行写的是 52，
    ---那是 TH06 的成就 id —— 抄过来的话通关会给「驱散红雾之日」。
    self:Next(166)
end)--31

NewStage("TH34", "妖妖梦原作", 32, function(self)
    ---复用 TH07（妖妖梦）第 6 面的背景类与 BGM「幽雅に咲かせ、墨染の桜」（mod/music.lua:25），
    ---与 mod/GAME/th34.lua 里 boss.Define 用的那两个参数必须一致。
    self:Option(TH07_bg, "TH07_1")
    self:Task(function()
        if lstg.var.__original_flow_version==original_flow.VERSION then original_flow.run(self.level);return end
        ---只有一个空 boss（editname "1a"），它只是那张「成群的亡灵」耐久卡的载体。
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    ---167 = 本关自己的通关成就（166 是 TH33 的）。
    self:Next(167)
end)--32

NewStage("TH35", "风神录原作", 33, function(self)
    ---复用 TH10（风神录）的背景类与 BGM「神さびた古戦場」（mod/music.lua:42），
    ---与 mod/GAME/th35.lua 里 boss.Define 用的那两个参数（"TH10_2" + TH10_bg）必须一致。
    self:Option(TH10_bg, "TH10_2")
    self:Task(function()
        if lstg.var.__original_flow_version==original_flow.VERSION then original_flow.run(self.level);return end
        ---  组 1 = 六面 BOSS 八坂神奈子（風神様の神徳）
        ---        + stage07 中 BOSS 三张（神符「水眼の如き美しき源泉」/「杉で結ぶ古き縁」/
        ---          「神が歩かれた御神渡り」）+ stage05 BOSS 神奈子四张（奇跡「客星の明るすぎる夜」/
        ---          開海「モーゼの奇跡」/ 準備「サモンタケミナカタ」/ 大奇跡「八坂の神風」）——
        ---          stage07 的中 BOSS 也是神奈子，所以和 stage05 的 BOSS 共用 1a 组
        ---          （用别的组会让中 BOSS 顶着諏訪子的立绘出场）；
        ---  组 2 = stage03 中 BOSS 河城荷取（光学「ハイドロカモフラージュ」）；
        ---  组 3 = stage03 BOSS    河城荷取（漂溺 / 水符 / 河童）；
        ---  组 4 = stage04 BOSS    射命丸文（岐符 / 風神 / 無双風神 / 塞符）；
        ---  组 5 = stage07（Extra）BOSS 洩矢諏訪子（開宴 / 土着神 / 神具 / 源符 / 蛙狩 / 祟符）；
        ---  组 6 = stage01 中 BOSS 秋静葉（葉符「狂いの落葉」）；
        ---  组 7 = stage01 BOSS    秋穣子（秋符「秋の空と乙女の心」/ 豊作「穀物神の約束」）；
        ---  组 8 = stage02 BOSS    犬走椛（厄符「厄神様のバイオリズム」/ 疵痕「壊されたお守り」/
        ---                              悲運「大鐘婆の火」/ 創符「流刑人形」）；
        ---  组 9 = stage05 中 BOSS 東風谷早苗（秘術「一子相伝の弾幕」）。
        ---一个角色一个组；boss.CreateGroup 会依次把该组打完再返回（boss.lua:226），
        ---所以连着调用就是「打完一组再上下一组」。
        boss.CreateGroup(1, self.level)
        task.Wait(120)
        boss.CreateGroup(2, self.level)
        task.Wait(120)
        boss.CreateGroup(3, self.level)
        task.Wait(120)
        boss.CreateGroup(4, self.level)
        task.Wait(120)
        boss.CreateGroup(5, self.level)
        task.Wait(120)
        ---stage01 / stage02 / stage05（th35.lua 下半段"八、stage01/02/05 符卡"）。
        boss.CreateGroup(6, self.level)
        task.Wait(120)
        boss.CreateGroup(7, self.level)
        task.Wait(120)
        boss.CreateGroup(8, self.level)
        task.Wait(120)
        boss.CreateGroup(9, self.level)
        task.Wait(120)
        ---组 "a" = stage06 道中（th35.lua「九、stage06 道中」那张独立的道中搬运卡，
        ---boss.Define 用的是 editname "aa" ⇒ 建组时带 letter "a"）。
        boss.CreateGroup("a", self.level, "a")
        task.Wait(120)
        ---组 "b".."g" = stage01/02/03/04/05/07 的道中搬运卡
        ---（editname "ba".."ga" ⇒ 建组时再带 letter "a"）。
        boss.CreateGroup("b", self.level, "a")
        task.Wait(120)
        boss.CreateGroup("c", self.level, "a")
        task.Wait(120)
        boss.CreateGroup("d", self.level, "a")
        task.Wait(120)
        boss.CreateGroup("e", self.level, "a")
        task.Wait(120)
        ---组 "f"/"g" = stage05 / stage07(Extra) 的道中搬运卡（editname "fa"/"ga"）。
        boss.CreateGroup("f", self.level, "a")
        task.Wait(120)
        boss.CreateGroup("g", self.level, "a")
        task.Wait(120)
    end)
    ---168 = 本关自己的通关成就（167 是 TH34 的）。
    self:Next(168)
end)--33

-- 独立来源编号35；保留地灵殿34和旧练习/录像的全部槽位。
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
