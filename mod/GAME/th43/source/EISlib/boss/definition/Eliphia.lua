-----------------------------------------------
---东方栖霞园 Eliphia点图动作及特效
-----------------------------------------------

local T = EISlib.BossDefinition.Type
local Bclass = {}
EISlib.BossDefinition.Eliphia = Bclass
--导入其他包


--行走图设置
local boss_name = "Eliphia"  --以boss名来作为其相关素材的前缀
local path = "res/boss/"..boss_name.."/"

local boss_arua_img = boss_name.."boss_arua"

--符卡背景
local scbg_imgs = {}
for i = 1, 6 do
    scbg_imgs[i] = boss_name.."_scbg"..i
end
--符文
local rune_ani = boss_name.."rune"
Bclass.rune_ani = rune_ani
local rune_eff = boss_name.."rune_eff"
Bclass.rune_eff = rune_eff

local scbg = Class(_spellcard_background)
function scbg:init(boss)
    --先与boss绑定
    if IsValid(boss) then
        self.boss = boss
    else
        Del(self)
    end
    _spellcard_background.init(self)
    --法阵跟随boss
    local function moveWithBoss(obj)
        obj.x, obj.y = self.center_x, self.center_y
    end
    self.center_x, self.center_y = 0, 144
    _spellcard_background.addLayer(self, scbg_imgs[6],
            true, --is tile
            0, 0, 0, --x, y, rot
            0, -1, 0, "mul+rev", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                self.a = 150 + 105*sin(self.timer)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg_imgs[5],
            false, --is tile
            self.center_x, self.center_y, 0, --x, y, rot
            0, 0, -0.2, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                moveWithBoss(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg_imgs[4],
            false, --is tile
            self.center_x, self.center_y, 0, --x, y, rot
            0, 0, 0.2, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                moveWithBoss(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg_imgs[3],
            false, --is tile
            self.center_x, self.center_y, 0, --x, y, rot
            0, 0, -0.2, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                moveWithBoss(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg_imgs[2],
            false, --is tile
            self.center_x, self.center_y, 0, --x, y, rot
            0, 0, 0.2, "", --vx, vy, omiga, blend
            1, 1, --hscale, vscale
            function(self)
            end,
            function(self)
                moveWithBoss(self)
            end,
            function(self)
            end
    )
    _spellcard_background.addLayer(self, scbg_imgs[1], false, 0, 0, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
            end,
            function(self)
            end
    )
end
function scbg:frame()
    --法阵跟随boss
    self.center_x, self.center_y = self.center_x + 0.1*(self.boss.x - self.center_x), self.center_y + 0.1*(self.boss.y - self.center_y)
    _spellcard_background.frame(self)
end

--立绘演出
local pic_show_img = boss_name.."pic_show"
--雪花道具
local alphaChange = EGGlib.ObjectEvent.alphaChange --透明度变化事件
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velchTask = EGGlib.ObjectEvent.velocityChangeTask

local pic_show = Class(object)
function pic_show:init()
    self.img = pic_show_img
    self.layer = LAYER_BG + 3
    self.x, self.y = -150, 150
    local size = 0.4
    self.hscale, self.vscale = size, size
    robject.set_color(self, "", 0, 255, 255, 255)
    alphaChangeTask(self, 0, 255, 60)
    --[[for _ = 1, 60 do
        New(snow)
    end]]
    task.New(self, function()
        --圈
        EGGlib.RenderEffect.createScOpenShowCircle("mul+add", 255, 0, 255, 30, 30, 30)
        --闪虚影
        EGGlib.RenderEffect.createBossPicShowTrail(self, 1,--dlayer
                9, --maxnum
                3, --frame
                self.img, --img,
                1, --size,
                30, --times,
                175, 255, 255 --r, g, b
        )
        --立绘移动
        task.MoveTo(self, 50, 0, 60, MOVE_DECEL)
        alphaChangeTask(self, 255, 0, 45)
        task.MoveTo(self, 200, -100, 45, MOVE_ACCEL)
        Del(self)
    end)
end
function pic_show:frame()
    task.Do(self)
end
function pic_show:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

--region 三面boss的书本
local book_normal_ani = boss_name.."book_normal"
local book_opening_ani = boss_name.."book_opening"
local book_opened_ani = boss_name.."book_opened"
local book = Class(object)
function book:init(x, y)
    self.x, self.y = x, y
    robject.set_color(self, "", 255, 255, 255, 255)
    book.changeNormalState(self) --默认为普通模式
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY - 1
    --setmetatable(self, {__index = book})
end
function book:frame()
    if self.status == "del" then
        task.clear(self)
        --
    else
        task.Do(self)
    end
end
function book:render()
    SetAnimationState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, self.vscale)
end
--书普通模式
function book:changeNormalState()
    self.timer = 0
    self.img = book_normal_ani
end
--书打开模式
function book:changeOpenState()
    self.timer = 0
    self.img = book_opening_ani
    task.New(self, function()
        task.Wait(16)
        self.img = book_opened_ani
    end)
end
--endregion

--region 三面boss魔法阵
local magic_img = "new_magic"
local color_index = {
    1, 1, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 8, 9
}
local renderImg = EGGlib.RenderEffect.renderImg
local magic = Class(other_enemy)
function magic:init(x, y, hp, show_hpbar, drop, death_func, co1, co2)
    other_enemy.init(self,
            x, y, magic_img..color_index[co1], --x, y, img,
            hp, show_hpbar, --hp, show_hpbar,
            drop,
            true, --no_count
            death_func)
    self.img2 = magic_img..color_index[co2]
    self._color = Color(255, 255, 255, 255)
    self._blend = ""
end
function magic:frame()
    other_enemy.frame(self)
end
function magic:render()
    local x, y, blend, color, h, v = self.x, self.y, self._blend, self._color, self.hscale, self.vscale
    renderImg(self.img, x, y, self.timer, 1.5*h, 1.5*v, blend, color)
    renderImg(self.img2, x, y, -self.timer, 1*h, 1*v, blend, color)
end

--endregion
local BossRes = T.createBossRes(
        boss_name, --boss_name,
        "s3_boss", --theme_music,
        stage3_background, --background,
        --资源载入函数
        function()
            --符卡背景
            for i = 1, 6 do
                LoadImageFromFile(scbg_imgs[i], path .. "scbg"..i..".png", true, 0, 0, false, 0)
            end
            --行走图
            LoadTexture(boss_name.."_BossWalkImage", path .. "BossWalkImage.png")--载入行走图资源
            --立绘
            do
                local sp_path = "res/performer/Eliphia/"
                LoadImageFromFile(pic_show_img, sp_path .. "normal.png", true, 0, 0, false, 0)
            end
            --书本道具
            local book_tex = boss_name.."book"
            LoadTexture(book_tex, path.."book.png")
            LoadAnimation(book_normal_ani, book_tex, 0, 0, 256, 256, 4, 2, 4)
            LoadAnimation(book_opening_ani, book_tex, 0, 512, 256, 256, 4, 1, 4)
            LoadAnimation(book_opened_ani, book_tex, 0, 768, 256, 256, 4, 1, 4)
            --魔法阵
            LoadImageFromFile(boss_arua_img, path.."boss_arua.png")
            --符文
            local rune_tex = boss_name.."rune"
            LoadTexture(rune_tex, path.."rune.png")
            LoadAnimation(rune_ani, rune_tex, 0, 0, 256, 256, 4, 1, 4)
            LoadImage(rune_eff, rune_tex, 1024, 0, 256, 256)
        end,
        --行走图动作函数
        T.createWalkImage(
                boss_name.."_BossWalkImage", 240, 240, 6, --tex, u, v, n
        --normalMovementFunc,
                T.createNormalMovementFunc(
                        T.createActionTable({1, 2, 3, 4, 5, 1, 2, 3, 6, 7}), --normal
                        T.createActionTable({8, 9, 10, 11, 12, 13, 14}, 4), --left
                        T.createActionTable({15, 16, 17, 18, 19, 20, 21}, 4), --right
                        8, --cutFrame,
                        0.5  --size,
                ),
                {
                    --施法
                    {"cast", T.createSpecialActionFunc(
                            {22, 23, 24, 25, 26, 27, 28}, --action_table,
                            function(wisys, self, actionCount, actionCountMax, cutFrame)
                                local n = int(actionCount/cutFrame) + 1
                                if n > 3 then
                                    n = 4 + int(n - 4)%4 --19 20 21 22循环
                                end
                                return n
                            end, --func,
                            8, 0.5)}, --cutFrame, size
                },
        --spActionFuncTable,
                {
                    {"cast", --固定时间施法动作
                     function(self, isWait)
                         self:setAction("cast", 56)
                         if isWait then
                             task.Wait(56)
                         end
                     end},
                    {"cast2", --自定义时间施法动作
                     function(self, time)
                         self:setAction("cast", time)
                     end
                    }
                }),
        --boss相关特效
        T.createBossEffectFunc(
                function(self) --createSaoQiFunc
                    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 0, 0, "mul+add"
                    self.saoqi = New(boss_saoqi, self)
                end,
                --scOpenEffect,
                function(self)
                    --New(pic_show)
                    EGGlib.RenderEffect.createScOpenShowCircle("", 100, 100, 255, 30, 30, 30)
                    effect.generalSpellShow(pic_show_img, 0.5, boss_arua_img, 100, 100, 255)
                    task.Wait(60) --模拟默认立绘演出90f
                    self.absorbAction(self, 60)
                end,
                --absorbEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 0, 255)
                    if t then task.Wait(t) end
                end,
                --breakEffect,
                function(self, t, x, y)
                    x, y = x or self.x, y or self.y
                    New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', 255, 0, 255)
                    if t then task.Wait(t) end
                end,
                --absorbAction,
                function(self, t, x, y)
                    self.cast("cast")
                    x, y = x or self.x, y or self.y
                    self.absorbEffect(self, t, x, y)
                end,
                --scBreakEffect
                function(self)
                    EGGlib.RenderEffect.scBreakEffect(self.x, self.y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff')
                end
        ),
        scbg, --scbg
        pic_show, --pic_show
        function(self)
            boss.class.changeAuraImg(self, boss_arua_img)
            --召唤书使魔
            self.createBook = function(x, y)
                return New(book, x, y)
            end
            --召唤魔法阵
            self.createMagic = function(x, y, hp, show_hpbar, drop, death_func, co1, co2)
                return New(magic, x, y, hp, show_hpbar, drop, death_func, co1, co2)
            end
        end
)
return BossRes
