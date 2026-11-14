---=====================================
---S7P自用粒子特效库
---code by S7UPID
---=====================================
--库声明
local M = {}
EGGlib.Particle = M

--导入其他包
local newSimpleClass = EGGlib.Class.newSimpleClass
local Basic_movement = EGGlib.Class.Frequently.Basic_movement
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local defaultRenderAni = EGGlib.RenderEffect.defaultRenderAni

--类声明
M.Manager = Class(object)
M.Particle_Image = newSimpleClass()
M.Particle_Animation = newSimpleClass()

--region 粒子管理器
do
    local this = M.Manager
    function this.init(self)
        self.layer = LAYER_ENEMY + 1 --默认图层
        self.obj_list = {}
        self.del = false
        self.del_left_timer = 30
    end
    function this.frame(self)
        task.Do(self)
        for k, particle in pairs(self.obj_list) do
            if particle:isValid() then
                particle:update()
            else
                table.remove(self.obj_list, k)
            end
        end
        if self.del then
            if self.del_left_timer > 0 then
                self.del_left_timer = self.del_left_timer - 1
            else
                self.status = "del"
            end
        end
    end
    function this.render(self)
        local alpha_rate = self.del_left_timer/30
        for _, particle in pairs(self.obj_list) do
            particle:draw(alpha_rate)
        end
    end
    function this.del(self)
        self.status = "normal"
        if not self.del then
            self.del = true
        end
        task.clear(self)
    end
    function this.addParticle(self, particle)
        table.insert(self.obj_list, particle)
    end
    function this.isValid(self)
        return IsValid(self) and not self.isDel
    end
end
--endregion
--region 粒子贴图实例
do
    local this = M.Particle_Image
    function this.constructor(self, img, x, y, rot, hscale, vscale)
        self.img = img
        Basic_movement.implement(self, x, y)
        self.rot = rot
        self.omiga = 0
        self.hscale, self.vscale = hscale, vscale
        self.isDel = false
        self._blend = ""
        self._a, self._r, self._g, self._b = 255, 255, 255, 255
    end
    function this.update(self)
        task.Do(self)
        Basic_movement.update(self)
        self.rot = self.rot + self.omiga
    end
    function this.draw(self, alpha_rate)
        defaultRenderImg(self, alpha_rate)
    end
    function this.isValid(self)
        return not self.isDel
    end
    function this.del(self)
        self.isDel = true
    end
end
--endregion
--region 粒子帧动画实例
do
    local this = M.Particle_Animation
    function this.constructor(self, img, ani, x, y, rot, hscale, vscale)
        self.img = img
        self.ani = ani
        Basic_movement.implement(self, x, y)
        self.rot = rot
        self.omiga = 0
        self.hscale, self.vscale = hscale, vscale
        self.isDel = false
        self._blend = ""
        self._a, self._r, self._g, self._b = 255, 255, 255, 255
    end
    function this.update(self)
        task.Do(self)
        Basic_movement.update(self)
        self.rot = self.rot + self.omiga
        self.ani = self.ani + 1
    end
    function this.draw(self, alpha_rate)
        defaultRenderAni(self, alpha_rate)
    end
    function this.isValid(self)
        return not self.isDel
    end
    function this.del(self)
        self.isDel = true
    end
end
--endregion