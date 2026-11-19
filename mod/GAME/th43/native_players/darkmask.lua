local M={}
local inter=source_interpolation
local darkmask = lstg.Class(object)

function darkmask:init()
	---@type stg.player.object
	self.player = nil
	self.group = GROUP_GHOST
	self.layer = LAYER_BG + 50
	self.colli = false
	self.bound = false
	self.alpha = 0
	self.setPlayer = darkmask.setPlayer
	self._a, self._r, self._g, self._b = 255, 150, 255, 150
end
function darkmask:frame()
	local player = self.player
	local con = false
	if lstg.IsValid(player) then
		local sys = system.PowerRank
		-- hyper状态且hyper没暂停且不处于对话场景
		--local c1 = sys.isInHyper() and (not player.dialog) and (not sys.isHyperPaused())
		local c1 = false --现在自机结界圈后面会有一个背景减法效果，感觉不需要开Hyper时背景变暗了
		-- bomb状态
		local c2 = player_class.isInBomb(player)
		con = c1 or c2
		if sys.isInHyper() then --hyper情况
			if sys.getHyperTime() > sys.getHyperMaxTime() - 10 then
				self.alpha = inter.balance(self.alpha, 0, 1, 0.2, true) --值被限制在0~1之间， true代表+0.2，  false则是-0.2
			elseif sys.getHyperTime() > sys.getHyperMaxTime() - 30 then
				self.alpha = inter.balance(self.alpha, 0, 1, 0.05, false)
			end
			if not (player.dialog or sys.isHyperPaused()) then --（如果不在 (对话或者hyper暂停) 时）最后2秒时屏幕会闪红
				if sys.getHyperTime() <= 10 then
					self.alpha = inter.balance(self.alpha, 0, 1, 0.05, false)
				elseif sys.getHyperTime() <= 120 then
					self.alpha = inter.balance(self.alpha, 0, 1, 0.025, true)
				end
			else
				self.alpha = inter.balance(self.alpha, 0, 1, 0.05, false)
			end
		else --放b情况
			self.alpha = inter.balance(self.alpha, 0, 0.5, 0.1, con)
		end

	else
		self.status = "del"
	end
end
function darkmask:render()
	if self.alpha > 0 then
		lstg.SetImageState("board_ch", "mul+rev",
				lstg.Color(self.alpha * self._a, self._r, self._g, self._b))
		local w = lstg.world
		lstg.RenderRect("board_ch", w.l - 50, w.r + 50, w.b - 50, w.t + 50)
	end
end

---@param player stg.player.object
function darkmask:setPlayer(player)
	self.player = player
	return self
end
---@return stg.player.component.DarkMask
function darkmask.create()
	local obj = lstg.New(darkmask)
	return obj
end

function darkmask:setColor(a, r, g, b)
	self._a, self._r, self._g, self._b = a, r, g, b
end

M.DarkMask = darkmask

--endregion
----------------------------------------

return M.DarkMask
