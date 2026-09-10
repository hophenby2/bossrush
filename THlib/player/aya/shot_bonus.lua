shot_bonus = {}
local shot_bonus = shot_bonus
shot_bonus.size = 0.5
shot_bonus.life = 240
shot_bonus.leftx = 120
shot_bonus.high = 140
local function GetSign()
    if player.x > 0 then
        return -1
    else
        return 1
    end
end

shot_bonus["Main"] = Class(object, {
    init = function(self, nnn)
        self.x = GetSign() * shot_bonus.leftx
        self.y = shot_bonus.high - 16 * nnn
        self.bound = false
        self.group = GROUP.GHOST
        self.layer = LAYER.TOP + 6
    end,
    frame = function(self)
        if self.timer > shot_bonus.life then
            object.Del(self)
        end
    end,
    render = function(self)
        local _a = 1
        if IsValid(player) and Dist(player.x, player.y, self.x, self.y) <= 80 then
            _a = 1 - (80 - max(Dist(player.x, player.y, self.x, self.y), 40)) / 50
        end
        SetFontState("Score", "",abs(200 * sin(self.timer * 40)) * _a, 255, 255, 255)
        RenderText("Score", self.text_left, self.x - 60, self.y, 0.25, "left")
        RenderText("Score", self.text_right, self.x + 60, self.y, 0.25, "right")
    end })

shot_bonus["BOSS SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 1.5
    photo.plus = photo.plus * self.plus

    self.text_left = "BOSS SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })
shot_bonus["SELF SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 1.2
    photo.plus = photo.plus * self.plus
    self.text_left = "SELF SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })

local num = { "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN" }
for i, n in ipairs(num) do
    shot_bonus[n .. " SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
        shot_bonus["Main"].init(self, nnn)
        self.plus = 0.9 + i * 0.3
        photo.plus = photo.plus * self.plus
        self.text_left = n .. " SHOT"
        self.text_right = "x" .. self.plus
        self.text = self.text_left .. self.text_right
    end })
end

shot_bonus["RISK SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 1.5
    photo.plus = photo.plus * self.plus
    self.text_left = "RISK SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })
shot_bonus["SOLO SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.addscore = 20000
    photo.score = photo.score + self.addscore
    self.text_left = "SOLO SHOT"
    self.text_right = "+" .. self.addscore
    self.text = self.text_left .. self.text_right
end })
shot_bonus["COLORFUL SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 1.2
    photo.plus = photo.plus * self.plus
    self.text_left = "COLORFUL SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })
shot_bonus["RAINBOW SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 1.3
    photo.plus = photo.plus * self.plus
    self.text_left = "RAINBOW SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })
shot_bonus["SKIRT SHOT"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn)
    shot_bonus["Main"].init(self, nnn)
    self.plus = 2
    photo.plus = photo.plus * self.plus
    self.text_left = "SKIRT SHOT"
    self.text_right = "x" .. self.plus
    self.text = self.text_left .. self.text_right
end })
shot_bonus["bullet bonus"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn, numofbullet)
    shot_bonus["Main"].init(self, nnn)
    self.num = numofbullet
    self.addscore = numofbullet * 150
    photo.score = photo.score + self.addscore
    self.text_left = "BULLET bonus"
    self.text_right = "+" .. self.num .. ' x150'
    self.text = self.text_left .. self.text_right
end })
shot_bonus["enemy bonus"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn, numofenemy)
    shot_bonus["Main"].init(self, nnn)
    self.num = numofenemy
    self.addscore = numofenemy * 500
    photo.score = photo.score + self.addscore
    self.text_left = "ENEMY bonus"
    self.text_right = "+" .. self.num .. ' x500'
    self.text = self.text_left .. self.text_right
end })
shot_bonus["base score"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn, score)
    shot_bonus["Main"].init(self, nnn)
    photo.score = photo.score + score
    self.text_left = "BASE SCORE"
    self.text_right = string.format("%d", score)
    self.text = self.text_left .. self.text_right
end })
shot_bonus["Total Score"] = Class(shot_bonus["Main"], { init = function(self, photo, nnn, score)
    shot_bonus["Main"].init(self, nnn)
    photo.score = photo.score + score
    self.text_left = "TOTAL SCORE"
    self.text_right = score
    self.text = self.text_left .. self.text_right
end })