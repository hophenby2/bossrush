---=====================================
---achievement
---=====================================

----------------------------------------
---成就更新
---

LoadSound("se_notice", "THlib\\UI\\se_notice.wav")
LoadSound("se_trophy", "THlib\\UI\\se_trophy.wav")
LoadTexture("trophy", "THlib\\UI\\trophy.png")
LoadImage("tr_black", "trophy", 0, 0, 384, 88)
LoadImage("tr_cup", "trophy", 0, 88, 96, 104)
SetImageState("tr_cup", "", 255, 255, 227, 132)
LoadImage("tr_gold", "trophy", 96, 96, 32, 32)

local achievement = {
    rank = {
        { 192, 192, 192 },
        { 150, 252, 180 },
        { 120, 180, 255 },
        { 228, 100, 234 },
        { 250, 118, 120 },
        { 255, 223, 120 }
    }
}
achievement.getcount = 0
function achievement:init()
    self.acetext = AchievementInfo
    self.list = {}
    self.achievement = {}
    self.gold = {}
    self.timer = 0

end
local rand = math.random
function achievement:frame()
    task.Do(self)
    self.timer = self.timer + 1
    local a
    if self.achievement[1] then
        a = self.achievement[1]
        if a.timer == 1 then
            PlaySound("se_trophy", 1)
        end
        if a.timer <= 10 then
            a.y = 620 - sin(a.timer * 9) * 120
        elseif a.timer % 3 == 0 then
            table.insert(self.gold, {
                x = a.x + (rand() - 0.5) * 80,
                y = a.y + (rand() - 0.5) * 40,
                v = rand() + 0.5,
                a = rand() * 360,
                rot = rand() * 360,
                omiga = ({ -1, 1 })[rand(2)] * 3,
                scale = 0,
                alpha = 0,
                timer = 1
            })
        end
        if a.timer % 60 >= 0 and a.timer % 60 <= 15 then
            a.cups = 0.3 + 0.2 * sin((a.timer % 60) * 12)
        end
        if a.timer % 20 < 10 then
            a.col = { 135, 206, 235 }
        else
            a.col = { 150, 150, 150 }
        end
        if a.timer >= 240 then
            a.y = 500 + 120 * sin(min(90, a.timer - 240))
        end

        a.timer = a.timer + 1

        if a.y == 560 and a.timer > 240 then
            table.remove(self.achievement, 1)
        end
    end
    local g
    for i = #self.gold, 1, -1 do
        g = self.gold[i]
        g.x = g.x + cos(g.a) * g.v
        g.y = g.y + sin(g.a) * g.v
        g.rot = g.rot + g.omiga
        g.scale = min(0.3, g.scale + 0.03)
        if g.timer <= 10 then
            g.alpha = min(150, g.alpha + 150 / 10)
        end
        if g.timer >= 60 then
            g.alpha = max(0, g.alpha - 150 / 15)
        end
        if g.alpha == 0 and g.timer > 10 then
            table.remove(self.gold, i)
        end
        g.timer = g.timer + 1
    end
end
function achievement:render()
    local a
    SetViewMode("ui")
    if self.achievement[1] then
        a = self.achievement[1]
        Render("tr_black", a.x, a.y, 0, 0.7, 1)
        Render("tr_cup", a.x - 80, a.y, 180, a.cups)
        RenderTTF("sc_menu", "成就已达成！！！", a.x + 18, a.y + 18, Color(255, unpack(a.col)), "center")
        RenderTTF("sc_menu", self.acetext[a.co][1], a.x + 18, a.y - 6, Color(255, unpack(a.color)), "center")
    end
    for _, g in ipairs(self.gold) do
        SetImageState("tr_gold", "mul+add", g.alpha, 255, 227, 132)
        Render("tr_gold", g.x, g.y, g.rot, g.scale)
    end
    SetViewMode("world")
end
local getmoney = { 150, 300, 600, 1000, 1500, 3500 }
function achievement:get(id)
    if not GlobalAddAchievement or ext.replay.IsReplay() then
        return
    end
    if not scoredata["Achievement"][id] then
        self.acetext = AchievementInfo
        table.insert(self.achievement, { x = 820, y = 620, co = id, timer = 1, cups = 0.3, col = { 135, 206, 235 }, color = self.rank[self.acetext[id][5]] })
        scoredata.Achievement[id] = true
        scoredata.NoticeAchievement[id] = true
        self.getcount = self.getcount + 1
        AddMoney(getmoney[self.acetext[id][5]])
        if self.getcount == #self.acetext - 1 then
            self:get(76)
        end
        if self.getcount >= 100 then
            self:get(120)
        end
        if self.getcount >= 50 then
            self:get(75)
        end
        if self.getcount >= 25 then
            self:get(74)
        end
        if self.getcount >= 10 then
            self:get(73)
        end
    else
        return true
    end
end

---@class ext.achievement @实时更新的成就
ext.achievement = achievement
ext.achievement:init()

