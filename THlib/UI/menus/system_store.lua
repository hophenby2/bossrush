local text = {
    [[攻击敌人时增加樱点，高速状态增加更多，[击破boss],[收卡]掉落樱点，樱点需要自己收集
樱点数量显示于右处，装满进度条即可开启樱花结界
开启结界时，结界持续一段时间，擦弹获得大量分数
结界<被弹结束>时：樱点扣除为0，全屏消弹，取消boss收卡奖励，约1.3秒的冷却时间
结界<时间耗尽>时：奖励一定分数，约1.3秒的冷却时间
结界无法主动结束]],
    [[一个百分比显示于自机下方，满80%即是人态
[高速][擦弹]会增加，
[自机miss][低速][不射击]时会降低",
人态时：
加强攻击力，攻击对象掉落小信仰点，射击与攻击对象获得大量分数
(如果使用射命丸文自机，该系统将失效) ]],
    [[<长按X键蓄力，蓄力时无法攻击>，
初始能蓄力1级，之后[每收几个卡就加几级]，最低1级，最高4级
蓄力n级，最高等级就减(n-1)级，
蓄力攻击如下：
1级：发射一些自机专属弹幕，受人态影响，射命丸文和琪露诺无效果
2级：1级效果基础，小灵击，自机无敌
3级：2级效果基础，大灵击，会判定收卡失败
4级：2级效果基础，超大灵击，会判定收卡失败]],
    [[信仰数量显示于右处，达到目标值即可随机获得一次效果
信仰的获得方式：
①人态(人态系统)、Hyper模式(暴走系统)时攻击敌人
②击破敌人，季节结界(季节系统)，水獭屏障(暴走系统)消弹时掉落
③击破绿UFO(飞碟系统)掉落的信仰道具

一些效果凭依于其他系统，目前可获得的效果如下：
①自机无敌5秒
②开启樱花结界(樱花系统)     ③蓄力满级(蓄力系统)
④快速召唤UFO(飞碟系统)     ⑤充满灵界槽(灵界系统)
⑥快速开启Hyper模式(暴走系统)]],
    [[擦弹会使信号上升，信号倍数与擦弹加的分有关，信号越高，擦弹分越高
满信号是3.00，会自动收点，满信号后擦弹会继续缓慢增加信号倍数
没有擦弹时信号会逐渐下降 ]],
    [[UFO的一些特性和原作类似，如靠近会减速，打爆彩碟掉最后一个色......
召唤出的UFO没有体术判定
在非特殊情况下，收卡掉落1个UFO
在左边会显示接下来要掉落的UFO，带问号表示接下来是彩碟
---击破UFO的奖励
①红碟：掉落抵消一次miss的道具，掉落一些樱点
②蓝碟：掉落大量蓝点，信号大幅度增加
③绿碟：掉落少数信仰道具，加一级蓄力的道具
④彩碟：额外掉落一个UFO(左边显示的)，并且给全屏敌人造成一定伤害 ]],
    [[小神灵的一些特性与原作类似，如蓝灵连续出9个就会出白灵......
灵界的开启方式：满槽时，低速+C
注意：自机被弹不会自动开启灵界，必须自己主动
灵界时：自机无敌，提高伤害，boss取消符卡奖励，全屏吸灵
(灵界效果固定，与自机无关) ]],
    [[收集掉落的物品(包括UFO，小神灵)，会增加右边的槽
槽里有红绿蓝三个部分，分别的物品分别增加，比如樱点就会增加红
槽满时会根据颜色占有百分比进行奖励
红色会赠送一个樱花结界
蓝色会小范围消弹
绿色会掉落加一级蓄力的道具
并且根据颜色纯净度进行加分，最高奖分100000]],
    [[擦弹范围变大，
擦弹效果：子弹变红，轻微抖动，
擦弹时，道具减速掉落，擦久了额外奖励5点擦弹值，小神灵会慢慢飞向自机]],
    [[每个自机都有专属的季节解放效果
季节道具由[攻击]、[擦弹]、[使用季节解放消弹]掉落
季节解放总体就是在自机位置生成一个季节结界，可以消弹，
同时会使自机无敌一段时间
最低1级，最高6级
春【灵梦】：季节结界面积随等级上升
夏【琪露诺】：每次使用只消耗1个等级
秋【射命丸文】：季节结界可随自机一起移动
冬【雾雨魔理沙】：季节结界时长最长且随等级上升]],
    [[动物灵的大部分特性等同于原作
但是填充槽变成了九宫格，填满9个才能开启
一种颜色的动物灵有5个以上才能有hyper模式
红绿紫的hyper，全自机统一
红：封魔针射击
绿：将敌机子弹消除的水獭屏障
紫：贯穿全屏的粗激光
hyper模式时停止射击并不会延长结束时间
hyper模式不会因为被弹结束，也不能主动结束 ]]
}

local store = {}
local function AddStoreItem(id, price, picture, name, describe, achievementid, otheraction, othercondition)
    local store_unit = {}
    store_unit.action = otheraction or function(self)
        scoredata.UnlockSystem[self.id] = true
        if self.achievementid then
            ext.achievement:get(self.achievementid)
        end
    end
    store_unit.condition = othercondition or function(self)
        return not scoredata.UnlockSystem[self.id]
    end
    store_unit.id = id
    store_unit.price = price
    store_unit.discount = 1
    store_unit.name = name
    store_unit.describe = describe
    store_unit.picture = picture
    store_unit.achievementid = achievementid
    table.insert(store, store_unit)
    return store_unit
end
_G.store = store
function InitStore()
    LoadTexture("hair", "mod\\hair.png")
    for p in pairs(store) do
        store[p] = nil
    end
    AddStoreItem(nil, 90, "hair", function()
        return ("给作者买一根头发\n*他现在有%d根头发*"):format(scoredata.hair)
    end, [[买，都可以买]], nil, function()
        scoredata.hair = scoredata.hair + 1
        if scoredata.hair >= 100 then
            ext.achievement:get(124)
        end
        if scoredata.hair >= 1000 then
            ext.achievement:get(125)
        end
    end, function()
        return true
    end)
    local new = AddStoreItem(nil, 30000, "th16AEXPIC", "东方天空璋AfterExtra",
            [[是作者很久以前做的东西
现在搬到了boss rush里并进行了完善
-------------------------------------
是主角组们在神社与一个不起眼的妖精？的邂逅]], nil, function()
                scoredata.bought[2] = true
            end, function()
                return not scoredata.bought[2]
            end)
    new.discount = 0.75--打折
    AddStoreItem(nil, 10000, "badapplePIC", "可以躲避的Bad Apple!!",
            [[谨慎购买
主要内容就是把ba的黑白换成了弹幕版，然后来躲避
大量无缝，背板注意！！]], nil, function()
                scoredata.bought[1] = true
            end, function()
                return not scoredata.bought[1]
            end)
    AddStoreItem(nil, 20000, "title_pl2", "琪露诺自机",
            [[像大战争一样，可以冰冻弹幕
所有弹幕（包括火弹）都可以冰冻，除了激光
冰块破碎会少量增加蓄力值，会增加分数

注意：
攻击时必须连续点击，不能按住，按住会判为蓄力冻结
冰块不会对敌人造成伤害，造成伤害的只能用主炮]], nil, function()
                scoredata.UnlockChiruno = true
            end, function()
                return not scoredata.UnlockChiruno
            end)
    for i, p in ipairs(SystemList) do
        AddStoreItem(i, p.price, ("stage_pic%d"):format(p.pic), p.title, text[i], p.achievementid)
    end
end

---@class system_store
system_store = Class(object)
function system_store:init(exitFunc)
    InitStore()
    self.x, self.y = 960, 540
    self.alpha = 0
    self.bound = false
    self.locked = true
    self.list = store
    self.pricecache = {}
    for i, p in ipairs(self.list) do
        self.pricecache[i] = p.price + CurrentVerifiableOffset
    end
    self.cache = {}
    self.maxdx = 15
    self.dxt = 5
    self.pos = 1
    self.exit_func = exitFunc
    self.tri_alpha = 1
    ------------------------------------------
    --self._list, self._pos = sp:GetListSection(self.list, 4, self.pos, 2)
    self.now = nil
    self.ty = 0
    self._ty = 0
    function self:yes()
        if self.now ~= self.pos then
            self.now = self.pos
            self.tri_alpha = 0
            task.New(self, function()
                for i = 1, 30 do
                    self.tri_alpha = sin(i * 3)
                    task.Wait()
                end
            end)
            PlaySound("select00")
        else
            local unit = self.list[self.pos]
            if unit:condition() then

                local price = unit.price * unit.discount
                if scoredata.money - price > 0 then
                    PlaySound("extend")
                    AddMoney(-price)
                    unit:action()
                else
                    PlaySound("invalid")
                    New(info, "资金力不足")
                end
            end
        end
    end
end
function system_store:frame()
    task.Do(self)
    local y1, y2 = 20, 440
    local lineh = (y2 - y1) / 6
    for i, p in ipairs(self.list) do
        if self.pricecache[i] - CurrentVerifiableOffset ~= p.price then
            p.price = self.pricecache[i] - CurrentVerifiableOffset
            p.price = math.ceil(p.price)
            error("Invalid value")
        end
    end
    if not self.locked then
        self._ty = self._ty + (-self._ty + Forbid(self._ty, 0, max((#self.list - 4) * lineh, 0))) * 0.3
        self.ty = self.ty + (-self.ty + self._ty) * 0.3
        local mouse = ext.mouse
        menu:Updatekey()
        menu:ControlExit(0, 30, 540, 510)
        if menu:keyYes() then
            self:yes()
        elseif menu:keyNo() then
            PlaySound("cancel00", 0.3)
            if self.exit_func then
                self.exit_func()
            end
        else
            if menu:keyUp() then
                self.pos = self.pos - 1
                if #self.list - self.pos >= 2 and self.pos >= 3 then
                    self._ty = self._ty - lineh
                end
                if self.pos < 1 then
                    self.pos = 1
                    self._ty = self._ty - lineh
                end
                self.now = nil
                PlaySound("select00", 0.3)
                self.tri_alpha = 0
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
            end
            if menu:keyDown() then

                self.pos = self.pos + 1
                if #self.list - self.pos >= 2 and self.pos >= 3 then
                    self._ty = self._ty + lineh
                end
                if self.pos > #self.list then
                    self.pos = #self.list
                    self._ty = self._ty + lineh
                end
                self.now = nil
                PlaySound("select00", 0.3)
                self.tri_alpha = 0
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
            end
            self.maxpicture_r = 80
            local PBC = sp.math.PointBoundCheck
            if PBC(mouse.x, mouse.y, 120, 840, y1, y2) then
                if mouse:isDown(1) then
                    local ny = y2 - lineh / 2 + self.ty
                    for i in ipairs(self.list) do
                        if ny < y2 + lineh / 2 and ny > y1 - lineh / 2 then
                            if abs(mouse.y - ny) < lineh / 2 then
                                if mouse.x < 120 + lineh then
                                    local name = (type(self.list[i].name) == "string") and self.list[i].name or self.list[i].name()
                                    name = sp:SplitText(name, "\n")[1]
                                    local n = New(SimpleNotice, self, name, self.list[i].describe)
                                    n.width = 270
                                    n.height = 120
                                end
                                self.pos = i
                                PlaySound("select00", 0.3)
                                self:yes()
                                break
                            end
                        end
                        ny = ny - lineh
                    end
                end
                if mouse._wheel ~= 0 then
                    local d = -sign(mouse._wheel)
                    self.pos = self.pos + d
                    if d > 0 then
                        if #self.list - self.pos >= 2 and self.pos >= 3 then
                            self._ty = self._ty + lineh
                        end
                        if self.pos > #self.list then
                            self.pos = #self.list
                            self._ty = self._ty + lineh
                        end
                    else
                        if #self.list - self.pos >= 2 and self.pos >= 3 then
                            self._ty = self._ty - lineh
                        end
                        if self.pos < 1 then
                            self.pos = 1
                            self._ty = self._ty - lineh
                        end
                    end
                    self.now = nil
                    PlaySound("select00", 0.3)
                end
            end
        end

    end
    --self.pos = sp:TweakValue(self.pos, #self.list, 1)
    --self._list, self._pos = sp:GetListSection(self.list, 4, self.pos, 2)
end
function system_store:render()
    if self.alpha == 0 then
        return
    end
    ui:DrawBack(self.alpha, self.timer)
    local x1, x2 = 120, 840
    local y1, y2 = 20, 440
    SetImageState("white", '', self.alpha * 150, 0, 0, 0)
    RenderRect("white", x1, x2, y1, y2)
    --ui:RenderText("big_text", "商店", 480, 510, 0.8, Color(self.alpha * 255, 255, 255, 255), "center")

    SetImageState("white", '', self.alpha * 50, 0, 0, 30)
    RenderRect("white", 90, 240, 475, 455)
    SetImageState("white", '', self.alpha * 255, 255, 255, 255)
    misc.RenderOutLine("white", 90, 240, 475, 455, 0, 2)
    ui:RenderText("title", "资金力 :", 90 + 1, 465,
            0.8, Color(self.alpha * 255, 255, 227, 132), "left", "vcenter")
    ui:RenderText("title", ("%d"):format(min(scoredata.money * self.alpha, 9999999)), 240 - 1, 465,
            0.8, Color(self.alpha * 255, 255, 227, 132), "right", "vcenter")
    ui:RenderText("title", "点击插图获取详细信息", x2, y2 + 2,
            0.9, Color(self.alpha * (155 + 100 * sin(self.timer * 2)), 255, 255, 255), "right", "bottom")

    SetRenderRect(x1 - 2, x2 + 2, y1 - 2, y2 + 2, x1 - 2, x2 + 2, y1 - 2, y2 + 2)
    local lineh = (y2 - y1) / 6
    local ny = y2 - lineh / 2 + self.ty
    for i, p in ipairs(self.list) do
        if ny < y2 + lineh / 2 and ny > y1 - lineh / 2 then
            local rgb = 180
            if i == self.pos then
                rgb = 255
                local tri = self.tri_alpha
                SetImageState("white", '', self.alpha * 150, 30, 30, 30)
                RenderRect("white", x1, x2, ny - lineh / 2, ny + lineh / 2)
                if self.now == self.pos and self.list[self.pos]:condition() then
                    SetImageState("white", '', self.alpha * 50, 30, 0, 0)
                    RenderRect("white", x2 - lineh * tri, x2, ny - lineh / 2, ny + lineh / 2)
                    SetImageState("white", '', self.alpha * 255, 255, 255, 255)
                    misc.RenderOutLine("white", x2 - lineh * tri, x2, ny + lineh / 2, ny - lineh / 2, 2, 0)
                    SetRenderRect(lineh / 2 - lineh * tri - 1, lineh / 2, -lineh / 2, lineh / 2,
                            x2 - lineh * tri - 1, x2, ny - lineh / 2, ny + lineh / 2)
                    ui:RenderText("title", "购买", 0, 0, 1.5,
                            Color(tri * self.alpha * 255, 255, 255, 255), "centerpoint")
                    SetRenderRect(x1 - 2, x2 + 2, y1 - 2, y2 + 2, x1 - 2, x2 + 2, y1 - 2, y2 + 2)
                end

            end
            SetImageState("white", '', self.alpha * 255, rgb, rgb, rgb)
            misc.RenderOutLine("white", x1, x2, ny + lineh / 2, ny - lineh / 2, 2, 0)
            local offl = lineh / 2.3
            local size = (GetTextureSize(p.picture)) / 2
            misc.RenderTexInSize(p.picture, x1 + lineh / 2, ny, 0, offl / size, offl / size,
                    "", Color(self.alpha * 255, rgb, rgb, rgb))
            SetImageState("white", '', self.alpha * 255, rgb, rgb, rgb)
            misc.RenderOutLine("white", x1 - offl + lineh / 2, x1 + offl + lineh / 2, ny + offl, ny - offl, 0, 1.5)
            local name = (type(p.name) == "string") and p.name or p.name()
            ui:RenderText("title", name, x1 + lineh, ny + offl, 0.8,
                    Color(self.alpha * 255, rgb, rgb, rgb), "left", "top")
            if p.discount ~= 1 then
                ui:RenderText("title", ("$ %d  (%d%% off!)"):format(p.price * p.discount, 100*(1 - p.discount)),
                        x1 + lineh, ny - offl, 1, Color(self.alpha * 255, rgb, rgb, rgb), "left", "bottom")
            else
                ui:RenderText("title", ("$ %d"):format(p.price), x1 + lineh, ny - offl, 1,
                        Color(self.alpha * 255, rgb, rgb, rgb), "left", "bottom")
            end
            if not self.list[i]:condition() then
                SetImageState("white", '', self.alpha * 50, 0, 30, 0)
                RenderRect("white", x2 - lineh, x2, ny - lineh / 2, ny + lineh / 2)
                SetImageState("white", '', self.alpha * 255, rgb, rgb, rgb)
                misc.RenderOutLine("white", x2 - lineh, x2, ny + lineh / 2, ny - lineh / 2, 2, 0)
                ui:RenderText("title", "已购", x2 - lineh / 2, ny, 1.5,
                        Color(self.alpha * 255, rgb, rgb, rgb * 0.8), "centerpoint")
            end
        end
        ny = ny - lineh
    end
    SetImageState("white", '', self.alpha * 255, 255, 255, 255)
    misc.RenderOutLine("white", x1, x2, y2, y1, 0, 2)

    SetViewMode("ui")

    menu:RenderExit(0, 30, 540, 510, self.alpha)
end