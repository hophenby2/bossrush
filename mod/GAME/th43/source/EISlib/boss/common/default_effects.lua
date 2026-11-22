-- 发行包原始通用特效回调，由 tools/th43-tests/export_release_effects.py 提取。
--- 默认的开卡演出
---@param self boss.object
function boss.defaultScOpenEffect(self)
	task.Wait(90) --模拟默认立绘演出90f
	self.absorbAction(self) --然后是带动作的蓄力
end

--- 默认的蓄力特效
---@param self boss.object
function boss.defaultAbsorbEffect(self, t, x, y)
	x, y = x or self.x, y or self.y
	New(EGGlib.RenderEffect.AbsorbEffect, x, y, 'tree_leaf_white', 'Cherry_eff', self.saoqiR, self.saoqiG, self.saoqiB)
	if t then task.Wait(t) end --若有传入t参数，则只允许放在task环境中！！
end

--- 默认的炸裂特效
---@param self boss.object
function boss.defaultBreakEffect(self, t, x, y)
	x, y = x or self.x, y or self.y
	New(EGGlib.RenderEffect.BreakEffect, x, y, 'tree_leaf_white', 'Cherry_eff', self.saoqiR, self.saoqiG, self.saoqiB)
	if t then task.Wait(t) end --若有传入t参数，则只允许放在task环境中！！
end

--- 默认的符卡击碎特效
---@param self boss.object
function boss.defaultScBreakEffect(self, x, y)
	x, y = x or self.x, y or self.y
	EGGlib.RenderEffect.scBreakEffect(x, y, self.saoqiR, self.saoqiG, self.saoqiB, 'tree_leaf_white', 'Cherry_eff')
end

--- 带动作的蓄力特效(然而默认的是不带动作的，要设置自己设置去！）
---@param self boss.object
function boss.defaultAbsorbAction(self, t, x, y)
	x, y = x or self.x, y or self.y
	boss.defaultAbsorbEffect(self, t, x, y)
end

