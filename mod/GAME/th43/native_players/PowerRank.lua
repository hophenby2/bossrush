---=====================================
--- PowerRank 系统
--- author: S7UPID
---=====================================

---@class system.PowerRank
local M = {}
system.PowerRank = M

local clear_bullet_circle, clear_bullet_circle2, hited_circle, clear_bullet_and_laser_in_range
do
    local color = {"green", "blue", "purple", "orange", "orange"}
    local function loadRes()
        local path = "res/effect/"
        for i = 1, 5 do
            LoadTexture("boom_"..color[i], path.."boom_"..color[i]..".png")
            --LoadImageFromFile("boom_"..color[i], path..color[i]..".png")
        end
    end
    loadRes()
    function clear_bullet_and_laser_in_range(x, y, r, drop_item)
        if drop_item then
            EGGlib.ObjectEvent.allBulletsDo(
                    function(obj)
                        if Dist(x, y, obj.x, obj.y) < r then
                            Kill(obj)
                        end
                    end)
        else
            EGGlib.ObjectEvent.allBulletsDo(
                    function(obj)
                        if Dist(x, y, obj.x, obj.y) < r then
                            Del(obj)
                        end
                    end)
        end
        EISlib.Bullet.Laser.cutLasersByCircle(x, y, r, drop_item)
    end
    --被弹扩散圈
    hited_circle = Class(object)
    function hited_circle:init(rmax, t, wt, index)
        self.x, self.y = player.x, player.y
        self.size = {0, 0, 0}
        self.range = rmax
        self.rate = 0
        self._color = Color(255, 255, 255, 255)
        index = index or M.getRank() + 1
        self.colors = color[index]
        clear_bullet_and_laser_in_range(self.x, self.y, self.range)
        task.New(self, function()
            local ds = 1/t
            for _ = 1, t do
                for i = 1, 3 do
                    self.size[i] = min(1, self.size[i] + ds*i)
                end
                task.Wait(1)
            end
            local drate = 1/wt
            for _ = 1, wt do
                self.rate = self.rate + drate
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function hited_circle:frame()
        task.Do(self)
    end
    function hited_circle:render()
        for i = 1, 3 do
            sp.misc.RenderRing3("boom_"..self.colors, self.x, self.y, self.rate*self.range*self.size[i], self.range*self.size[i], 60, 1, 0, 360, "mul+add", Color(100*(1-self.rate), 255, 255, 255))
        end
    end
    M.hited_circle = hited_circle

    --rank提升消弹圈
    local rank_up_circle = Class(object)
    function rank_up_circle:init(x, y, rmax, t, wt, index, alwaysClearBullet)
        self.x, self.y = x, y
        self.layer = LAYER_BG+51
        self.size = {0, 0, 0}
        self.range = rmax
        self.rate = 0
        self._color = Color(255, 255, 255, 255)
        index = index or M.getRank() + 1
        self.colors = color[index]
        if not IsValid(_boss) or alwaysClearBullet then --只要boss不在场就是全屏消弹
            clear_bullet_and_laser_in_range(self.x, self.y, 900, true)
        end
        task.New(self, function()
            local ds = 1/t
            for _ = 1, t do
                for i = 1, 3 do
                    self.size[i] = min(1, self.size[i] + ds*i)
                end
                task.Wait(1)
            end
            local drate = 1/wt
            for _ = 1, wt do
                self.rate = self.rate + drate
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function rank_up_circle:frame()
        task.Do(self)
    end
    function rank_up_circle:render()
        for i = 1, 3 do
            sp.misc.RenderRing3("boom_"..self.colors, self.x, self.y, self.rate*self.range*self.size[i], self.range*self.size[i], 60, 1, 0, 360, "mul+add", Color(100*(1-self.rate), 255, 255, 255))
        end
    end
    function clear_bullet_circle(x, y, rmax, t, index, alwaysClearBullet)
        New(rank_up_circle, x, y, rmax, t, 30, index, alwaysClearBullet)
    end
    function clear_bullet_circle2(rmax, t0, t1, index)
        tasker(function ()
            local r, dr = 0, rmax/t0
            for _ = 1, t1 do
                r = min(rmax, r + dr)
                EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(
                        player.x, player.y, r, index --x, y, rmax, index
                )
                task.Wait(1)
            end
        end)
    end
    M.clear_bullet_circle = clear_bullet_circle
    M.clear_bullet_circle2 = clear_bullet_circle2
end

--与powerrank系统有关的变量初始化
local function PowerRankValueInit()
    lstg.var.powerRank_maxrank = 4 --最大rank等级
    lstg.var.powerRank_rank = 0 --rank等级(取值范围0-4)
    lstg.var.powerRank_maxchip = 6 --最大碎片数
    lstg.var.powerRank_maxvalue = 5000 --填充满槽的值
    lstg.var.powerRank_value = 0 --当前槽值
    lstg.var.powerRank_total_value = 0 --全关总涨槽值(统计数据)
    lstg.var.powerRank_hyper_max_time = 27*60 --hyper模式最大持续时间（帧）
    lstg.var.powerRank_hyper_time_left = -1 --hyper剩余时间,0是hyper结束帧，-1表示未启动
    lstg.tmpvar.powerRank_hyperPause = false --停止hyper
    lstg.var.powerRank_hyper_chip_left = 0 --hyper模式下存储碎片的计数器
    lstg.var.powerRank_max_hyper_chip_left = 6 --最大存储碎片数
    lstg.tmpvar.powerRank_isHitedToHyper =  false --被弹触发hyper
    lstg.var.powerRank_hyper_hited_count = 0
    lstg.tmpvar.powerRank_infinite = false --是否在无限爆Hyper
end
PowerRankValueInit()

--region Rank Operation 与rank有关的操作
--获取rank值
function M.getMaxRank()
    return lstg.var.powerRank_maxrank
end
function M.getRank()
    return lstg.var.powerRank_rank
end
--设置rank值
function M.setRank(rank)
    lstg.var.powerRank_rank = min(4, max(0, rank))
end
--基本是测试用的功能， 在设置rank值的同时更新一次rank事件
function M.setRankWithEvent(rank)
    M.setRank(rank)
    M.rankDownEvent()
end
--增加rank值
function M.addRank(drank)
    lstg.var.powerRank_rank = min(4, max(0, lstg.var.powerRank_rank + drank))
end
--通过收集碎片的方式让rank提高
function M.updateRank(drank)
    --升级时应该要有音效的
    if drank then
        if drank > 0 and M.getRank()+drank < 4 then --这种方法无法使rank变为4级
            M.addRank(drank)
            M.rankUpEvent()
        elseif drank < 0 then
            M.addRank(drank)
            M.rankDownEvent()
        end
    end
end
--每升一级rank时的事件
function M.rankUpEvent()
    if IsValid(lstg.tmpvar.current_road) then
        lstg.tmpvar.current_road.class.updateByRankChange() --更新一下敌人
    end
    local rank = M.getRank()
    if rank == 0 then

    elseif rank >= 1 and rank <= 3 then
        if not IsValid(_boss) then --boss战时当然不能无敌！
            player.protect = max(player.protect, 30)
        end
        clear_bullet_circle(player.x, player.y, 600, 30, rank)
        if database.setting.gameplay.show_powerup_popup then
            --[[if rank < 3 then
                New(effect.PowerUp, player.x, player.y, "normal") --你被强化辣，快去送！
            else --3rank就是满p
                New(effect.fullPowerUp)
            end]]
            --现在火力升级提示都去掉了，因为火力已不与rank挂钩
        end
    end

    --自机更换装备
    if player.class.changeEquip then
        player.class.changeEquip(player, rank)
    end
    -- 放个好听的音效
    PlaySound("extend")
end
--每降一级rank时的事件
function M.rankDownEvent()
    if IsValid(lstg.tmpvar.current_road) then
        lstg.tmpvar.current_road.class.updateByRankChange() --更新一下敌人
    end
    local rank = M.getRank()
    --自机更换装备
    if player.class.changeEquip then
        player.class.changeEquip(player, rank)
    end
    -- 放个吓人的音效
    --PlaySound("broken1")
end
--endregion

--region Chip Operation 与碎片有关的操作
--获取碎片数
function M.getChip()
    return lstg.var.powerRank_chip
end
function M.getMaxChip()
    return lstg.var.powerRank_maxchip
end
--设置碎片数
function M.setChip(chip)
    lstg.var.powerRank_chip = min(M.getMaxChip(), max(0, chip))
end
--增加碎片数
function M.addChip(dchip)
    if M.getRank() < 4 then
        local notHyperBeforeChip = not M.canHyper()
        lstg.var.powerRank_chip = lstg.var.powerRank_chip + dchip
        if notHyperBeforeChip and M.canHyper() then
            if database.setting.gameplay.show_powerup_popup then
                --New(effect.PowerUp, player.x, player.y, "full") --提醒你可以爆啦！
                New(effect.fullPowerUp, "hyper_ready") --还有一个更大的！
            end
            PlaySound("cast00") --可以放H的提示音效
        end
    else
        M.setChip(0) --4rank碎片数会被锁在0
        M.addHyperChipLeft(dchip)
    end
    local drank = 0
    while M.getChip() >= M.getMaxChip() do
        if M.getRank() + drank < 3 then
            lstg.var.powerRank_chip = lstg.var.powerRank_chip - lstg.var.powerRank_maxchip
            drank = drank + 1
        elseif M.getRank() + drank == 3 then --3rank满碎片
            M.setChip(M.getMaxChip())
            break
        end
    end
    while lstg.var.powerRank_chip < 0 do
        if M.getRank() + drank > 0 then
            lstg.var.powerRank_chip = lstg.var.powerRank_chip + lstg.var.powerRank_maxchip
            drank = drank - 1
        else --rank为0的情况
            lstg.var.powerRank_chip = 0 --直接归零，跳出！
        end
    end
    if drank > 0 or drank < 0 then
        M.updateRank(drank)
    else
        --音效
        local i = M.getChip() - 1 --取值范围 -1 4
        if i >= 0 and i <= 4 then --0碎片表示升级，不播放音效
            PlaySound("ding"..i)
        elseif i >= 5 then
            PlaySound("ding4")
        end
    end

end
--endregion

--region Value Operation 与槽值有关的操作
--获取槽值
function M.getValue()
    return lstg.var.powerRank_value
end
function M.getMaxValue()
    return lstg.var.powerRank_maxvalue
end
function M.getTotalValue()
    return lstg.var.powerRank_total_value
end
--设置槽值
function M.setValue(value)
    lstg.var.powerRank_value = max(0, min(M.getMaxValue(), value))
end
function M.setTotalValue(value)
    lstg.var.powerRank_total_value = value
end
--增加槽值
function M.addValue(dvalue)
    if not M.isChipLeftFull() then --如果打出来的存储碎片数没有填满
        lstg.var.powerRank_value = lstg.var.powerRank_value + dvalue
        local flag = false --3rank的标志，防止系统进入死循环
        while lstg.var.powerRank_value >= lstg.var.powerRank_maxvalue and not flag do
            if  not (M.getRank() == 3 and M.getChip() == M.getMaxChip()) --3rank满碎片会锁槽
                    and not (M.getRank() == 4 and M.isChipLeftFull()) --4rank满存储碎片也会锁(注意，这里使用isChipLeftFull()并不与最上层的isChipLeftFull()互斥！因为while循环的事件可能会改变即时判定结果
            then --只要不是3rank 满碎片都会清空槽并生成碎片
                lstg.var.powerRank_value = lstg.var.powerRank_value - lstg.var.powerRank_maxvalue
                -- creat_chip()  --在自机正上方生成一个碎片
                if M.getRank() == 4 then --hyper时会被存储
                    M.addHyperChipLeft(1)
                else --非hyper时于自机正上方生成
                    PlaySound("bonus2")
                    item.collectByTarget(item.Blood.create(player.x, player.y + 100, item.Blood.Big), player) -- 现在填满一次掉3倍碎片
                end
            elseif M.getRank() == 3 then
                M.setValue(M.getMaxValue()) --槽被锁定为满槽
                flag = true
            elseif M.getRank() == 4 then
                M.setValue(0) --槽锁定为零槽
            end
        end
    else --仅针对hyper时打出来的碎片存储数填满
        M.setValue(0) --槽锁定为零槽
    end
    M.addTotalValue(dvalue)
end
function M.addTotalValue(dvalue)
    lstg.var.powerRank_total_value = lstg.var.powerRank_total_value + dvalue
end
--endregion

--region Normal Event 常见事件处理
--当自机在非hyper下中弹时
function M.normalHit(player)
    if M.canHyper() then
        if system.getBomb() > 0 then
            if system.getBomb() == 1 then
                effect.decBombEffect(1)
            else
                effect.decBombEffect(2)
            end
            system.addBomb(-2) --b数减2
            player.death = 0 --自机复活
            player.protect = max(player.protect, 121) --有必要事先给好无敌，否则可能会存在一帧内同时碰撞两颗或更多颗子弹的情况，导致扣b或者直接暴毙，然后复活后带着hyper起来
            M.hitedToHyper() --被动启动hyper
        else
            --那你没了呀
        end
    end
end
--当自机miss时
function M.missEvent()
    local rank = M.getRank()
    --[[if rank > 0 then   --0级miss无事发生, 其他等级要掉1rank
        M.updateRank(-1)
        for i = 0, 2 do
            for u = -1, 1, 2 do
                New(item_big_power, player.x, player.y + 30, 90 + (i + 0.5)*15*u, 90, 192)
            end
        end
    end]] --现在不掉大p了
    --连击数清0(取消)
    --system.setChain(0)
    if not (M.getRank() == 0 and M.getChip() == 0) then
        PlaySound("broken1")
    end
    if M.getRank() > 0 then
        M.updateRank(-1) --回调：掉一级rank
    else
        M.setChip(0) --你把你碎片全给我交了！
    end
end
--当自机使用bomb时(
function M.bombEvent()
    if not (M.getRank() == 0 and M.getChip() == 0) then
        PlaySound("broken1")
    end
    if M.getRank() > 0 or (M.getRank() == 0 and M.getChip() >= 3) then
        --M.updateRank(-1) --回调：掉一级rank
        M.addChip(-3) --现在只-3碎片
    else
        M.setChip(0) --你把你碎片全给我交了！
    end
    --M.addChip(-3) --掉三片碎片
    item.collectAllPowerAndPoint(1, true) --把p点和蓝点都吸回来
end
--endregion

--region HyperMode hyper模式
function M.setHyperTime(time)
    lstg.var.powerRank_hyper_time_left = max(-1, min(lstg.var.powerRank_hyper_max_time, time))
end
function M.setHyperMaxTime(maxtime)
    lstg.var.powerRank_hyper_max_time = maxtime
end
function M.getHyperTime()
    return lstg.var.powerRank_hyper_time_left
end
function M.getHyperMaxTime()
    return lstg.var.powerRank_hyper_max_time
end
function M.setHyperChipLeft(chip)
    lstg.var.powerRank_hyper_chip_left = min(M.getMaxHyperChipLeft(), max(0, chip))
end
function M.setMaxHyperChipLeft(chip)
    lstg.var.powerRank_max_hyper_chip_left = chip
    M.setHyperChipLeft(M.getHyperChipLeft()) --同时也要更新一下当前碎片存储数
end
function M.resetMaxHyperChipLeft()
    M.setMaxHyperChipLeft(6)
end
function M.clearMaxHyperChipLeft()
    M.setMaxHyperChipLeft(0)
end
function M.addHyperChipLeft(dchip)
    lstg.var.powerRank_hyper_chip_left = min(M.getMaxHyperChipLeft(), max(0, lstg.var.powerRank_hyper_chip_left + dchip))
end
function M.getHyperChipLeft()
    return lstg.var.powerRank_hyper_chip_left
end
function M.getMaxHyperChipLeft()
    return lstg.var.powerRank_max_hyper_chip_left
end
function M.isChipLeftFull()
    if M.getHyperChipLeft() == M.getMaxHyperChipLeft() then
        return true
    end
    return false
end
--使hypertime增加，虽然话说如此但一般是传负数进来减少的，最小值为-1
function M.addHyperTime(dt)
    lstg.var.powerRank_hyper_time_left = max(lstg.var.powerRank_hyper_time_left + dt, -1)
end
--hyper启动时的事件
function M.hyperStart()
    if database.setting.gameplay.show_powerup_popup then
        New(effect.fullPowerUp, "hyper") --你被强化辣，快去送！
    end
    M.resetMaxHyperChipLeft() --初始化一下hyper期间可存储的碎片数
    --PlaySound("enep01")
    PlaySound("nep00") --试试更骚的？
    effect.shakeScreen(120, 4) --开启hyper时震屏，但是符卡时是不消弹的，是否考虑符卡期间去掉呢？
    clear_bullet_circle(player.x, player.y, 600, 30, 4, true) --全屏消弹，并且不受boss影响
    player.protect = max(player.protect, 121) --前120f为动画状态，且自机进入无敌保护
    M.setHyperTime(lstg.var.powerRank_hyper_max_time)
    M.setRank(M.getMaxRank()) --rank直接到满
    if IsValid(lstg.tmpvar.current_road) then
        lstg.tmpvar.current_road.class.updateByRankChange()
    end
    M.setChip(0) --碎片要清零
    if player.class.hyperStart then
        player.class.hyperStart(player)
    end
    if player.class.changeEquip then
        player.class.changeEquip(player, M.getRank())
    end
    if IsValid(_boss) and _boss.current_card then
        if _boss.timer > 120 then
            _boss.sc_bonus = 0 --在符卡开符2s之后再放Hyper的话，就没符卡分了
        end
    end
end
--标记被动触发hyper flag
function M.hitedToHyper()
    lstg.tmpvar.powerRank_isHitedToHyper = true
end
function M.closeHitedToHyper()
    lstg.tmpvar.powerRank_isHitedToHyper = false
end
function M.isHitedToHyper()
    return lstg.tmpvar.powerRank_isHitedToHyper
end
--H结束后的奖励结算
function M.hyperEndReward()
    local n = M.getHyperChipLeft() - M.getHitedCount() --刷取的碎片数 - 被弹
    n = max(0, n)
    local da, a
    if n == 0 then
        da = 0
    else
        da = 360/n
    end
    n = (n-1)/2
    for i = -n, n do
        a = 90 + da*i
        item.collectByTarget(item.Blood.create(player.x + 150 * cos(a), player.y + 150 * sin(a), item.Blood.Big), player)
    end
end
--hyper正常结束时的事件
function M.hyperNormalEnd(player)
    M.updateRank(-4) --rank滑落回第0级
    if player.class.changeEquip then --装备该换回普通装备了
        player.class.changeEquip(player, M.getRank())
    end
    if player.class.hyperEnd then
        player.class.hyperEnd(player)
    end
    PlaySound("warning2") --播放成功的音效
    --todo 既然特意区分了正常结束，有没有必要给正常结束一些奖励呢？
    clear_bullet_and_laser_in_range(player.x, player.y, 900, true) --全屏消弹
    clear_bullet_circle(player.x, player.y, 300, 45) --全屏消弹
    player.protect = max(player.protect, 120) --还要有2s的保护时间
    M.setHyperTime(-1) --时间要清为-1（虽然执行此函数的条件就是时间为零）
    M.hyperEndReward() --结算奖励
    M.setHitedCount(0) --中弹计数器清零
    M.setHyperChipLeft(0) --hyper碎片槽被清空
    M.resetMaxHyperChipLeft() --别忘了把存储碎片上限设置回来，不然会锁槽的！
    if IsValid(_boss) and _boss.current_card then
        if _boss.timer > 120 then
            _boss.sc_bonus = 0 --在符卡开符2s之后再结束Hyper的话，就没符卡分了
        end
    end
end
--hyper 因中弹太多而结束时的事件
function M.hyperEnd(player)
    M.updateRank(-4) --掉到0
    if player.class.changeEquip then --装备该换回普通装备了
        player.class.changeEquip(player, M.getRank())
    end
    if player.class.hyperEnd then
        player.class.hyperEnd(player)
    end
    PlaySound("broken1") --播放结界破碎音效
    clear_bullet_and_laser_in_range(player.x, player.y, 900, false) --全屏消弹
    player.protect = max(player.protect, 120) --还要有2s的保护时间
    M.setHyperTime(-1) --时间要清为-1
    item.Blood.killAllChip() --清掉屏幕上所有的碎片
    M.hyperEndReward() --结算奖励
    M.setHitedCount(0) --中弹计数器清零
    M.setHyperChipLeft(0) --hyper碎片槽被清空但不掉出
    M.resetMaxHyperChipLeft() --别忘了把存储碎片上限设置回来，不然会锁槽的！
    if IsValid(_boss) and _boss.current_card then
        if _boss.timer > 120 then
            _boss.sc_bonus = 0 --在符卡开符2s之后再结束Hyper的话，就没符卡分了
        end
    end
end
--hyper 在放b结束时的事件
function M.hyperBomb(player)
    M.hyperEnd(player)
end
--hyper在被弹时的事件
function M.hyperHit(player)
    --M.clearMaxHyperChipLeft() --只要中弹了，打出来的存储碎片就无效
    if player.class.hyperHited then --执行自机自己的hyper被弹逻辑
        player.class.hyperHited(player) --注：现在消弹效果也写到player里去了
    end
    if M.getHitedCount() < M.getMaxHitedCount(player) then --前两次中弹（注意，第一次中弹获取的值是0，第二第是1，第三次才是2）
        system.spellcard.auxiliary.addPlayerHyperBreak() -- 标记一下符卡期间Hyper中弹的次数
        M.setHitedCount(M.getHitedCount() + 1) --中弹计数加1
        player.protect = max(120, player.protect) --中弹有2s保护
    else
        M.setHitedCount(M.getHitedCount() + 1) --中弹计数加1
        M.hyperEnd(player) --因中弹而击碎的hyper
    end
    player.death = 0 --自机复活
    PlaySound("broken1")
end
--在hyper时间被完全暂停时触发被弹，表明已进入六面最终阶段，每一次被弹都会把雷转化成护盾防止一次死亡
function M.hyperPauseHit(player)
    --此处禁用自机结界破碎逻辑
    --M.clearMaxHyperChipLeft() --只要中弹了，打出来的存储碎片就无效
    --[[if player.class.hyperHited then --执行自机自己的hyper被弹逻辑
        player.class.hyperHited(player) --注：现在消弹效果也写到player里去了
    end]]
    if system.getBomb() > 0 then
        --[[if system.getBomb() == 1 then
            effect.decBombEffect(1)
            system.addBomb(-1) --b数减2
        else
            effect.decBombEffect(2)
            system.addBomb(-2) --b数减2
        end]]
        effect.decBombEffect(1)
        system.addBomb(-1) --b数减2
        player.protect = max(120, player.protect) --中弹有2s保护
        EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(player.x, player.y, 100, 3, 0, 15, nil, true)
        player.death = 0 --自机复活
        PlaySound("broken1")
    else
        PlaySound("pldead00")
        --那你没了呀
    end
end

--可放爆H了吗？
function M.canHyper()
    if M.getRank() == 3 and M.getChip() >= M.getMaxChip() then --3rank满碎片才可以放
        return true
    end
    return false
end
--是否在hyper状态
function M.isInHyper()
    if M.getHyperTime() > -1 then
        return true
    end
    return false
end
--是否在hyper即将结束前一帧
function M.isHyperWillEnd()
    if M.getHyperTime() == 0 then
        return true
    end
    return false
end

function M.isHyperPaused()
    return lstg.tmpvar.powerRank_hyperPause
end
--
function M.pauseHyper()
    lstg.tmpvar.powerRank_hyperPause = true
end
function M.resumeHyper()
    lstg.tmpvar.powerRank_hyperPause = false
end

--无限hyper模式（只为临时解决续关断无限hyper的需求，所以只用于单纯作个标记）
function M.openInfiniteHyperMode()
    lstg.tmpvar.powerRank_infinite = true
end
function M.closeInfiniteHyperMode()
    lstg.tmpvar.powerRank_infinite = false
end
function M.isInfiniteHyperMode()
    return lstg.tmpvar.powerRank_infinite
end
--endregion

--region 需要装在player_class里的帧逻辑部分
function M.Init(player)
    player.hited = 0 --hyper期间被弹次数
    player.hyper_allow_hited_count = 1 --hyper期间最多被弹次数
end

function M.getHitedCount()
    return lstg.var.powerRank_hyper_hited_count
end
function M.setHitedCount(hited)
    lstg.var.powerRank_hyper_hited_count = hited
end
function M.getMaxHitedCount(player)
    return player.hyper_allow_hited_count
end
function M.setMaxHitedCount(player, maxhit)
    player.hyper_allow_hited_count = maxhit
end

local function isBossTimeSpellCard()
    local b = boss.GetFirstBoss()
    if lstg.IsValid(b) and b._bosssys and b._bosssys.getCurrentCard then
        local c = b._bosssys:getCurrentCard()
        if c and c.type == boss.action.Type.Card and c.mode == "timespell" then
            return true
        end
    end
    return false
end

--hyper系统帧逻辑(已置入player_system
function M.Frame(player)
    if M.isInHyper() then --先判断自机在不在hyper
        if M.getHyperTime() > M.getHyperMaxTime() - 120 then --我不管你是什么情况，反正只要爆了前120f必须流逝掉
            item.collectAllPowerAndPoint(2, false) --2倍回收所有道具
            M.addHyperTime(-1)
        elseif not player.dialog and not M.isHyperPaused() then
            --以下是三种需要hyper结束的情况,相应的执行函数定义在上面
            if player_class.isInBomb(player) then --最先判断这帧有没有用雷
                M.hyperBomb(player) --执行hyper期间放雷惩罚
            elseif player_class.isInDeathSentence(player) then --如果这帧自机中弹进入决死的话
                M.hyperHit(player) --执行hyper期间中弹惩罚
            elseif M.isHyperWillEnd() then --然后判断hyper在不在结束前一帧 --todo 这个写法有点危险，因为出了点事，有空最好改改
                M.hyperNormalEnd(player) --在的话就执行正常hyper结束事件
            end

            if M.isInHyper() then --注意，这里的判断不是多余的，因为上面事hyper事件结束的函数会把时间设为-1，导致不在hyper，不在hyper状态时就不能再执行收点操作
                if M.getHitedCount() == 0 then --H过程中没中弹
                    item.collectAllPowerAndPoint(2, false) --2倍回收所有道具
                elseif M.getHitedCount() == 1 then --中弹一次（三个自机是一样的）
                    item.collectAllPowerAndPoint(1, false) --1倍
                elseif M.getHitedCount() == 2 then --中弹两次（只有灵梦有这种情况，其他机体已经强制关闭H了）
                    item.collectAllPowerAndPoint(1, true) --不仅是1倍回收，而且不受全局最大得点倍率影响
                end
            end
            --时符时hyper不流逝
            if not isBossTimeSpellCard() then
                M.addHyperTime(-1) --hyper持续时间计数器减1（如果执行了上面的结束情况函数，这里减1刚好能让time处于-1，即不在hyper的状态）
            end
        elseif M.isHyperPaused() and player_class.isInDeathSentence(player) then --如果在hyper暂停时，还能触发决死判断，说明已经到了六面或者ex面最终阶段，在此处无限爆hyper，雷会被作为抵消一次中弹的保险被动使用
            M.hyperPauseHit(player)
        else --其它时间无条件回收道具吧
            if M.getHitedCount() == 0 then --H过程中没中弹
                item.collectAllPowerAndPoint(2, false) --2倍回收所有道具
            elseif M.getHitedCount() == 1 then --中弹一次（三个自机是一样的）
                item.collectAllPowerAndPoint(1, false) --1倍
            else
                item.collectAllPowerAndPoint(1, true) --不仅是1倍回收，而且不受全局最大得点倍率影响
            end
        end
    else --剩下的就是处理不在hyper状态的事了
        if player_class.isUseSpell(player) then --自机放b时
            M.bombEvent() --自机正常放b事件
        elseif player_class.isMiss(player) then --自机miss扣除残机时
            M.missEvent() --自机miss事件
            --现在hyper不是自动开了！所以rank4开始hyper事件被移除了，写到bomb逻辑里去了
        end
    end
end
--endregion

--region 系统数值初始化
function M.init()
    M.setRank(0) --rank等级初始化
    M.setChip(0) --碎片数初始化
    M.setValue(0) --槽值初始化
    M.setTotalValue(0) --总槽值初始化
    M.setHyperTime(-1) --hyper剩余时间初始化
    M.resetMaxHyperChipLeft() --最大碎片存储数
    M.setHyperChipLeft(0) --碎片存储数
    M.setHitedCount(0) --hyper时被弹计数器
end

--endregion

--region dps 用于计算dps值
function M.addTotalDamage(dmg)
    lstg.var.total_damage = lstg.var.total_damage + dmg
end
--endregion
