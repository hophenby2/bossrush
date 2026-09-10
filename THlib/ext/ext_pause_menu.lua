---=====================================
---pause menu
---=====================================

----------------------------------------
---暂停菜单
local pausemenu = {  }

LoadFX("fx:pause_menu_blur", "shader\\texture_BoxBlur49.hlsl")


local TIP = {
    "bad apple可以no miss吗",
    "该游戏需要的性能太高了",
    "飞碟系统和暴走系统一起携带，屏幕整个乱起来了！",
    "红红蓝",
    "绀珠传系统的擦弹范围会变大，然后就很容易满信号和人槽",
    "有好多成就都是粉丝安利的",
    "怎么获得隐藏成就？——乱跑就完事啦",
    "配合系统玩的话会很无敌",
    "不要贪图小神灵哦",
    "试试用灵梦或魔理沙把一些od符卡收了吧",
    "目前你觉得哪个部分最好玩？",
    "春夏秋冬，全集合！",
    "成就过多，请随意收集",
    "你能看到我这条tip真的是太幸运了",
    "？",
    "看不见我看不见我",

    "山寺月中寻桂子，郡亭枕上看潮头。",
    "雾失楼台，月迷津渡。",
    "料得年年肠断处，明月夜，短松冈。",
    "月落乌啼霜满天，江枫渔火对愁眠。",
    "溪云初起日沉阁，山雨欲来风满楼。",

    "你知道吗，4.0和5.0间距了一年而且中间只有一个4.1.jpg",
    "黄昏之时将至。。",
    "绀珠传篇完美继承了\"超级困难\"的原作特色",
    "玄女娘娘兴儒度世大发慈悲让我刷分.jpg",
    "有些符卡确实是作者教你玩游戏（无奈",
    "脑子要爆炸啦！这弹幕要怎么做才好啊",
    "好多成就变成了隐藏成就.jpg",
    "获得所有成就的成就要获得所有成就才能获得的话要怎么获得这个成就呢",

    "《萤火之森》是绿川幸编著的漫画作品",
    "夜雀为《滑头鬼之孙》中出场的妖怪，最初作为四国妖怪七人同行之一",
    "白泽是中国古代神话中地位崇高的神兽，祥瑞之象征",
    "杀手兔是MC中的兔子变种，对任何玩家都敌对",
    "酒石酸唑吡坦为一催眠剂，镇静催眠作用很强",
    "《Baccano!》改编自由成田良悟创作、榎波克己负责插画的同名轻小说",
    "《BEASTARS》是板垣巴留所创作的日本漫画",
    "白泽亦能说人话，通万物之情，晓天下万物状貌",
    "乔鲁诺·乔巴纳，是《JOJO的奇妙冒险》第五季黄金之风的男主角",
    "罗刹，此云恶鬼也",
    "System Call... From Object Polygonal Shape",
    "克罗里·尤斯福德，漫画《终结的炽天使》及其衍生作品中人物",
    "在东方绯想天中的必杀技“蝴蝶梦之舞”被作为扇舞的基准动作之一",
    "《境界的彼方》是由鸟居奈古梦著作、鸭居知世插画的轻小说",

}
_G.TIP = TIP

function pausemenu:init()
    self.kill = true

    self.pos = 1
    self.pos2 = 2
    self.ok = false
    self.choose = false
    self.lock = true
    self.textindex = math.random(1, #TIP)
    self.timer = 0
    self.t = 30

    self.eff = 0
    self.mask_color = Color(0, 255, 255, 255)
    self.mask_alph = 0
    self.mask_x = 0
    self.Option = false
    self.text = {
        { "返回游戏", "退出并保存录像", "返回标题菜单", "推把" },
        { "返回游戏", "返回标题菜单", "再放送" },
    }

    self.bgmlist = {}--用来储存正在播放的bgm
    self.pos_pre = 1
    self.pos_changed = 0
    self.pos2_pre = 1
    self.pos2_changed = 0
end

function pausemenu:frame()

    if self.kill then
        return "killed"
    end
    task.Do(self)
    --如果有可用的暂停菜单文字，则优先使用已有的
    local pause_menu_text
    if lstg.tmpvar.pause_menu_text then
        pause_menu_text = lstg.tmpvar.pause_menu_text
    else
        --根据是否是replay状态选择暂停菜单文字
        if ext.replay.IsReplay() then
            pause_menu_text = self.text[2]
        else
            pause_menu_text = self.text[1]
        end
    end
    --执行自身task

    --执行选项操作
    if (not self.lock) and self.t < 1 then
        local lastkey = GetLastKey()
        --关闭暂停菜单
        if lastkey == setting.keysys.menu then
            PlaySound('cancel00', 0.3)
            if lstg.tmpvar.death then
                self.pos = #pause_menu_text
            else
                if not ext.rep_over then
                    self.t = 60
                    self.choose = false
                    self:FlyOut()
                end
            end
        end
        --直接重开
        if lastkey == setting.keysys.retry then
            self.t = 60
            PlaySound('ok00', 0.3)
            self.choose = false
            if ext.replay.IsReplay() then
                ext.pause_menu_order = "再放送"
            else
                ext.pause_menu_order = "推把"
            end
            self:FlyOut()
        end
        --槽位切换
        do
            if lastkey == setting.keys.up then
                self.t = 4
                PlaySound('select00', 0.3)
                if not self.choose then
                    self.pos = self.pos - 1
                else
                    self.pos2 = self.pos2 - 1
                end
            elseif lastkey == setting.keys.down then
                self.t = 4
                PlaySound('select00', 0.3)
                if not self.choose then
                    self.pos = self.pos + 1
                else
                    self.pos2 = self.pos2 + 1
                end
            end
            self.pos = (self.pos - 1) % (#pause_menu_text) + 1
            self.pos2 = (self.pos2 - 1) % 2 + 1
        end
        --取消操作
        if lastkey == setting.keys.spell then
            if self.choose then
                self.t = 15
                PlaySound('cancel00', 0.3)
                self.choose = false
            else
                if not ext.rep_over then
                    PlaySound('cancel00', 0.3)
                    if lstg.tmpvar.death then
                        self.pos = #pause_menu_text
                    else
                        self.t = 60
                        self:FlyOut()
                    end
                end
            end
        end
        --按键操作
        if lastkey == setting.keys.shoot or lastkey == KEY.ENTER then
            if self.choose then
                if self.pos2 == 1 then
                    --确认选项，推送命令，暂停菜单关闭
                    self.t = 60
                    PlaySound('ok00', 0.3)
                    ext.PushPauseMenuOrder(pause_menu_text[self.pos])
                    self.choose = false
                    self:FlyOut()
                else
                    --取消选项
                    self.t = 15
                    PlaySound('cancel00', 0.3)
                    self.choose = false
                end
            else
                --未选中状态，进入二级菜单
                self.t = 15
                PlaySound('ok00', 0.3)
                if self.pos == 1 then
                    --对第一个选项特化处理
                    ext.PushPauseMenuOrder(pause_menu_text[self.pos])
                    self:FlyOut()
                else
                    self.choose = true
                end
            end
        end
    end
    --last op
    self.timer = self.timer + 1
    if self.t > 0 then
        self.t = self.t - 1
    end

    if self.choose then
        if self.eff < 20 then
            self.eff = self.eff + 1
        end
    else
        if self.eff > 0 then
            self.eff = self.eff - 1
        end
    end

    --shake_text
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.pos_pre ~= self.pos then
        self.pos_changed = ui.menu.shake_time
    end
    self.pos_pre = self.pos

    if self.pos2_changed > 0 then
        self.pos2_changed = self.pos2_changed - 1
    end
    if self.pos2_pre ~= self.pos2 then
        self.pos2_changed = ui.menu.shake_time
    end
    self.pos2_pre = self.pos2

end
function pausemenu.RenderText(x, y, text, color)
    local a = (color:ARGB())
    for i = 1, 4 do
        RenderTTF("title", text, x + cos(i * 90 + 45), y + sin(i * 90 + 45),
                Color(a, 0, 0, 0), "left", "vcenter")
    end
    RenderTTF("title", text, x, y, color, "left", "vcenter")
end
function pausemenu:render()

    if self.kill then
        return "killed"
    end

    --准备一些变量
    local dx = 480
    local dy = 300
    local m
    if ext.replay.IsReplay() then
        m = 2
    else
        m = 1
    end

    --绘制黑色遮罩

    SetViewMode 'ui'
    PostEffect("fx:pause_menu_blur", "PauseMenuBlur", 6, "", {
        { 2.0, 0.0, 0.0, 0.0 }, -- radiu, 未使用, 未使用, 未使用
    }, {})

    SetImageState('white', '', self.mask_color)
    RenderRect('white', 0, screen.width, 0, screen.height)

    if self.player_name == "aya_player" and ext.Aya_texture then
        local pic = ext.Aya_texture
        local color = Color(self.mask_alph * 0.9, 255, 255, 255)
        SetImageState('white', '', color)
        Render4V("white", pic.oA.x, pic.oA.y, 0.5, pic.oB.x, pic.oB.y, 0.5, pic.oC.x, pic.oC.y, 0.5, pic.oD.x, pic.oD.y, 0.5)
        pic.uv1[6], pic.uv2[6], pic.uv3[6], pic.uv4[6] = color, color, color, color
        RenderTexture("PhotoTexture", '', pic.uv1, pic.uv2, pic.uv3, pic.uv4)
    end

    --渲染底图
    local s = sin(self.eff * 4.5)
    SetImageState('pause_eff', '', self.mask_alph / 3, 200 * s + 55, 200 * (1 - s) + 55, 200 * (1 - s) + 55)
    Render('pause_eff', 300 + (dx - 300) * s, -60 + dy, 4 + 4 * sin(self.timer * 3), 0.4, 0.4)
    --准备选项
    local text
    local Choose = { '好！', '*不*' }
    if lstg.tmpvar.pause_menu_text then
        text = lstg.tmpvar.pause_menu_text
    else
        text = self.text[m]
    end
    local textnumber = #text
    if text then
        local y = -20 + dy
        local c = (self.choose and 100) or 255
        if lstg.tmpvar.pause_menu_text then
            --有现有的文字时高亮处理
            if ext.rep_over then
                self.RenderText(self.mask_x, y, "播放结束", Color(self.mask_alph + 15, c, c, c))
            elseif not ext.sc_pr then
                self.RenderText(self.mask_x, y, "游戏结束", Color(self.mask_alph + 15, c, c, c))
            end
        else
            --没有现有的文字时高亮处理
            if m == 1 then
                self.RenderText(self.mask_x, y, "游戏暂停", Color(self.mask_alph + 15, c, c, c))
            else
                self.RenderText(self.mask_x, y, "播放结束", Color(self.mask_alph + 15, c, c, c))
            end
        end
        --渲染选项列表
        local color
        local xos = 0
        for i = 1, textnumber do
            xos = 0
            if self.choose then
                color = (i == self.pos) and (Color(self.mask_alph, 128, 128, 128)) or (Color(self.mask_alph, 50, 50, 50))
            else
                if i == self.pos then
                    xos = ui.menu.shake_range * sin(ui.menu.shake_speed * self.pos_changed)
                    color = Color(self.mask_alph, 155 + 100 * sin(self.timer * 4.5), 255, 222)
                else
                    color = Color(self.mask_alph, 100, 100, 100)
                end
            end
            self.RenderText(self.mask_x + xos, -30 - i * 25 + dy, text[i], color)
        end
    end
    --渲染确定选项
    if self.choose then
        self.RenderText(-10 + dx, -50 + dy, "真的吗?", Color(self.mask_alph, 250, 128, 114))
        for i = 1, 2 do
            if i == self.pos2 then
                local xos = ui.menu.shake_range * sin(ui.menu.shake_speed * self.pos2_changed)
                self.RenderText(dx + xos, -50 - i * 25 + dy, Choose[i], Color(self.mask_alph + 15, 155 + 100 * sin(self.timer * 4.5), 255, 255))
            else
                self.RenderText(dx, -50 - i * 25 + dy, Choose[i], Color(self.mask_alph + 15, 100, 100, 100))
            end

        end
    end

    ui:RenderText("title", "Tips : " .. self.tip, 480, 125, 0.8,
            Color(self.mask_alph, 250, 128, 114 + 50 * sin(self.timer * 2)), "centerpoint")
end

function pausemenu:FlyIn()
    --清除一些flag
    ext.pop_pause_menu = nil
    local t = self.textindex
    while self.textindex == t do
        self.textindex = math.random(1, #TIP)
    end
    self.tip = TIP[self.textindex]

    if stage.current_stage.stop_watch then
        stage.current_stage.stop_watch:Pause()
    end
    self.kill = false--标记为开启状态

    self.pos = lstg.tmpvar.pause_menu_pos or 1
    self.pos2 = 2
    self.ok = false
    self.choose = false
    self.lock = true

    self.timer = 0
    self.t = 30
    self.player_name = GetGlobal("player_name")
    self.eff = 0
    self.mask_color = Color(0, 255, 255, 255)
    self.mask_alph = 0
    self.mask_x = 0
    task.New(self, function()
        self:PauseSound()
        PlaySound('pause', 0.5)
        local s
        for i = 1, 20 do
            s = task.SetMode[2](i / 20)
            self.mask_color = Color(s * 100, 0, 0, 0)
            self.mask_alph = s * 240
            self.mask_x = s * 300
            task.Wait()
        end
        self.lock = false
    end)
end

function pausemenu:FlyOut()
    self.lock = true

    task.New(self, function()
        local s
        for i = 1, 20 do
            s = task.SetMode[2](i / 20)
            self.mask_color = Color(100 - s * 100, 0, 0, 0)
            self.mask_alph = 240 - s * 240
            self.mask_x = 300 - s * 300
            task.Wait()
        end
        self:ResumeSound()
        if stage.current_stage.stop_watch then
            stage.current_stage.stop_watch:Resume()
        end
        self.kill = true--标记为关闭状态

        --清除一些flag
        lstg.tmpvar.death = false
        ext.rep_over = false
    end)
end

function pausemenu:PauseSound()
    if not ext.sc_pr then
        self.bgmlist = {}--先清空列表
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) == "playing" then
                PauseMusic(v)
                self.bgmlist[v] = true--标记
            end
        end
    else
        self.bgmlist = {}--先清空列表
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) == "playing" then
                self.bgmlist[v] = true--标记
            end
        end
        task.New(self, function()
            for i = 1, 20 do
                for o, _ in pairs(self.bgmlist) do
                    SetBGMVolume(o, 1 - i / 40)
                end
                task.Wait()
            end
        end)
    end
end

function pausemenu:ResumeSound()
    if not ext.sc_pr then
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) ~= 'stopped' and self.bgmlist[v] then
                --ResumeMusic(v)
                PlayMusic(v, 1, ext.music[v].timer / 60)--防止暂停时出现的音乐卡顿情况
            end
        end
    else
        local list = {}
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) ~= 'stopped' and self.bgmlist[v] then
                table.insert(list, v)
            end
        end
        for i = 1, 20 do
            for _, v in pairs(list) do
                SetBGMVolume(v, 0.5 + i / 40)
            end
            task.Wait()
        end
    end
end

function pausemenu:IsKilled()
    return self.kill
end

---@class ext.pausemenu @暂停菜单对象
ext.pause_menu = pausemenu
ext.pause_menu:init()

----------------------------------------
---暂停菜单资源
LoadImageFromFile('pause_eff', 'THlib\\UI\\pause.png')
