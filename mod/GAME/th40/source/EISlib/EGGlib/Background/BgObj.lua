---======================================
---背景基础元素一些常用的接口
---by S7UPID
---2021.1.22
---======================================
--导入所在库
local B = EGGlib.BG
local baseBG = B.baseBG
--导入其他类、方法、接口
local C = EGGlib.BG.comp
local newSimpleClass = EGGlib.Class.newSimpleClass
local ballToVector3 = EGGlib.Math.BallToVec3

--飘落物类定义
B.FallingObjectInterface = newSimpleClass()
do
    local cls = B.FallingObjectInterface
    --构造方法
    function cls.constructor(self, v, rot_ball, omiga, live_time, index)
        local v_list = ballToVector3(rot_ball)
        self.vx, self.vy, self.vz = v_list[1], v_list[2], v_list[3]
        self.vx, self.vy, self.vz = v*self.vx, v*self.vy, v*self.vz
        self.omiga = omiga
        self.t = live_time --花能存活的时间
        self._index = index
        self.status = 'normal'
    end
    --更新方法
    function cls.update(self)
        self.t = self.t - 1
        baseBG.updateObjAngle(self, self.omiga) --花自旋
        baseBG.updateBgObjPos(self, self.vx, self.vy, self.vz) --花位置更新
        if self.t > 0 then --透明度变化
            baseBG.updateBgObjAlp(self, 10)
            if baseBG.getBgObjAlp(self) >= 180 then
                baseBG.setBgObjAlp(self, 180)
            end
        elseif self.t > -30 then
            baseBG.updateBgObjAlp(self, -10)
            if baseBG.getBgObjAlp(self) >= 180 then
                baseBG.setBgObjAlp(self, 180)
            end
        else
            self.status = 'del'
        end
    end
end

