---======================================
---私人背景库
---by S7UPID
---2020.1.8
---======================================

local setting = database.setting

local M = {}
EGGlib.BG = M
local C = {}
M.comp = C

--导入臭蛾子的数学库
--local eggmath = require("EISlib.egg.eggmath")
local eggmath = EGGlib.Math
local ToVector3 = eggmath.Vec3
local Multiplication_Cross3 = eggmath.Vec3Cross
local Dot_Product3 = eggmath.Vec3Dot
local _3ToQuaternion = eggmath.Vec3ToQuat
local Vector_Equal = eggmath.VecEqual
local Get_Opposite_Vector = eggmath.VecReverse
local ToQuaternion = eggmath.Quat
local Quaternion_Multiplication = eggmath.QuatMul
local Quaternion_Inversion = eggmath.QuatInv
local Point_by_Quaternion = eggmath.Vec3RotByQuat
local createBall = eggmath.Ball
local ballToVect3 = eggmath.BallToVec3
local Get_Four_Points = eggmath.GetRectFace
local newSimpleClass = EGGlib.Class.newSimpleClass
local extend = EGGlib.Class.extend

--输入纹理中心坐标以及宽度高度以及初始朝向向量，返回纹理四个渲染顶点，相关参数：x, y, z, l, h, rot
M.Get_Four_Points = Get_Four_Points
M.Get_Opposite_Vector = Get_Opposite_Vector
M.ballToVect3 = ballToVect3
--static
local square_stroke = "background_square_stroke"
M.square_stroke = square_stroke

--load
local function loadRes()
    LoadImageFromFile(square_stroke, "res/background/square.png")
end
loadRes()

--整个背景对象模版
local BG = Class(background)
--背景类基本方法
do
    --基础参数设置
    function BG:setBaseParam(eye_cen, eye_rot, v, a, up_rot, fovy, z, fog)
        BG.setEyeCen(self, eye_cen[1], eye_cen[2], eye_cen[3]) --设置中心
        BG.setEyeRot(self, eye_rot[1], eye_rot[2]) --1球坐标系的θ，取值0到180  2球坐标系的φ，取值0到360（当然也可以更高）
        --背景的朝向（背景向前移动方向）
        BG.setV(self, v, a)
        --对应于set3d的up
        BG.setUpRot(self, up_rot[1], up_rot[2])
        BG.setFovy(self, fovy)
        BG.setZ(self, z[1], z[2])
        BG.setFog(self, fog[1], fog[2], fog[3], fog[4], fog[5], fog[6])
    end
    --默认设置
    function BG:setDefault()
        self.layer = LAYER_BG
        self.eye_pos = {}
        self.eye_rot = {}
        self.eye_rot3 = {}
        self.bg_rot = {}
        self.bg_rot3 = {}
        self.bg_speed = 0
        self.up_rot = {}
        self.up = {}
        self.fovy = {}
        self._z = {}
        self.fog = {}
        BG.setBaseParam(self,
                {0, 4, 6}, --eye_cen,
                {95, 90}, --eye_rot,
                0, --v,
                {90, -90}, --a,
                {90, 90}, --up_rot,
                1.5, --fovy,
                {0, 60}, --z
                {0, 50, 255, 76, 0, 56} --fog
        )
        self.imgs ={} --自身的元素表初始化
        BG.bgComponentInit(self)
    end
    --以字符串名为索引把纹理加入到该背景元素表中
    ---@param img string @索引名
    ---@param tex string @纹理名
    ---@param w number @在背景中的宽
    ---@param h number @在背景中的高
    function BG:addToImg(img, tex, w, h)
        self.imgs[img] = {tex, w, h}
    end
    --以索引名获取纹理名
    ---@param img string @索引名
    function BG:getImgTex(img)
        if self.imgs[img] then
            return self.imgs[img][1]
        end
        return nil
    end
    --以索引名获取纹理在背景中的宽和高
    ---@param img string @索引名
    function BG:getImgWH(img)
        return self.imgs[img][2], self.imgs[img][3]
    end


    --region BgObj 背景元素对象
    
    ---@class BgObj
    
    --只创建对象，不加入任何对象表（适用于手动添加特殊对象）
    ---@param x number @center_x
    ---@param y number @center_y
    ---@return BgObj
    function BG:createBgObj(img, x, y, z, rot, blend, _a, _r, _g, _b, angle)
        blend = blend or ""
        _a, _r, _g, _b = _a or 255, _r or 255, _g or 255, _b or 255
        angle = angle or 0
        local tex, tex2, w, h
        if type(img) == "table" then
            tex = BG.getImgTex(self, img[1])
            w, h = BG.getImgWH(self, img[1])
            tex2 = BG.getImgTex(self, img[2])
        else
            tex = BG.getImgTex(self, img)
            tex2 = nil
            w, h = BG.getImgWH(self, img)
        end
        local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
        local n = ballToVect3(rot)
        local obj = {
            {tex, blend, _a, _r, _g, _b, tex2}, --1
            p, --2、四个顶点的坐标点集
            {x, y, z, 0}, --3、中心坐标
            {rot[1], rot[2], n[1], n[2], n[3]} --4、面朝向，前两个为球坐标系参数，后三个为球坐标系参数转为向量形式的参数
        } --现在规定rot只能是球坐标
        BG.setObjAngle(obj, angle) --更新一下p
        return obj
    end

    ---@param x number @foot_x
    ---@param y number @foot_y
    function BG.createBgObj2Directly(img, w, h, x, y, z, rot, blend, _a, _r, _g, _b, angle)
        local obj = BG.createBgObjDirectly(img, w, h, x, y, z, rot, blend, _a, _r, _g, _b, 0)
        BG.setObjAngle(obj, angle)
        local rot3 = BG.getRotParallelToObj(obj)
        local dx, dy, dz = 0.5*h*rot3[1], 0.5*h*rot3[2], 0.5*h*rot3[3] --在中心坐标加上此值，即可换算为脚坐标
        BG.updateBgObjPos(obj, dx, dy, dz)
        return obj
    end

    --直接由img, w, h创建背景元素对象（完全不经过BG类）
    function BG.createBgObjDirectly(img, w, h, x, y, z, rot, blend, _a, _r, _g, _b, angle)
        blend = blend or ""
        _a, _r, _g, _b = _a or 255, _r or 255, _g or 255, _b or 255
        angle = angle or 0
        local tex, tex2
        if type(img) == "table" then
            tex = img[1]
            tex2 = img[2]
        else
            tex = img
            tex2 = nil
        end
        local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
        local n = ballToVect3(rot)
        local obj = {
            {tex, blend, _a, _r, _g, _b, tex2}, --1
            p, --2、四个顶点的坐标点集
            {x, y, z, 0}, --3、中心坐标
            {rot[1], rot[2], n[1], n[2], n[3]} --4、面朝向，前两个为球坐标系参数，后三个为球坐标系参数转为向量形式的参数
        } --现在规定rot只能是球坐标
        BG.setObjAngle(obj, angle) --更新一下p
        return obj
    end
    --获取背景元素对象的位置的点集
    ---@param obj table @实例化的背景元素的对象
    ---@param i number @第i个顶点，限1-4
    ---@return table 四个顶点点集
    function BG.getObjPos(obj, i)
        return obj[2][i][1], obj[2][i][2], obj[2][i][3]
    end
    --设置背景元素对象的位置的点集
    ---@param obj table @实例化的背景元素的对象
    ---@param pos table @四元数类
    ---@return table 四个顶点点集
    function BG.setObjPos(obj, i, pos)
        obj[2][i][1], obj[2][i][2], obj[2][i][3] = pos[1], pos[2], pos[3]
    end
    function BG.setObjPos2(obj, i, x, y, z)
        obj[2][i][1], obj[2][i][2], obj[2][i][3] = x, y, z
    end
    --获取背景元素对象的中心位置
    ---@param obj table @实例化的背景元素的对象
    ---@return number 中心x, y, z坐标
    function BG.getObjCen(obj)
        return obj[3][1], obj[3][2], obj[3][3]
    end
    --获取背景元素对象的朝向的球坐标
    ---@param obj table @实例化的背景元素的对象
    ---@return table 单位向量
    function BG.getObjRot(obj)
        return obj[4][1], obj[4][2]
    end
    --获取背景元素对象的朝向的单位向量
    function BG.getObjRotVector3(obj)
        return ToVector3(obj[4][3], obj[4][4], obj[4][5])
    end
    --设置背景元素对象的朝向单位向量(仅修改数值但不改变渲染效果
    ---@param obj table @实例化的背景元素的对象
    ---@param rot table @三维方向单位向量
    function BG.setObjRot(obj, rot)
        local x1, y1, z1 = BG.getObjPos(obj)
        local x, y, z = BG.getObjCen(obj)
        for i = 1, 4 do
            BG.setObjPos(obj, i, Point_by_Quaternion(x, y, z, x1, y1, z1, ballToVect3({obj[4][1], obj[4][2]}), ballToVect3(rot)))
        end
        obj[4][1], obj[4][2] = rot[1], rot[2]
        local n = ballToVect3(rot)
        obj[4][3], obj[4][4], obj[4][5] = n[1], n[2], n[3]
    end
    --更新面朝向
    function BG.updateObjRot(obj, da, db)
        obj[4][1], obj[4][2] = obj[4][1] + da, obj[4][2] + db
        local x1, y1, z1
        local x, y, z = BG.getObjCen(obj)
        for i = 1, 4 do
            x1, y1, z1 = BG.getObjPos(obj, i)
            BG.setObjPos(obj, i, Point_by_Quaternion(x, y, z, x1, y1, z1, ballToVect3({obj[4][1] - da, obj[4][2] - db}), ballToVect3({obj[4][1], obj[4][2]})))
        end
    end
    --获取obj面上的贴图旋转角度
    function BG.getObjAngle(obj)
        return obj[3][4]
    end
    --设置obj面上的贴图旋转角度
    function BG.setObjAngle(obj, a)
        local da = a - BG.getObjAngle(obj)
        BG.updateObjAngle(obj, da)
    end
    --让某个obj面上的贴图转起来
    function BG.updateObjAngle(obj, da)
        obj[3][4] = obj[3][4] + da --数值更新
        local x, y, z = BG.getObjCen(obj)
        local x1, y1, z1
        local vector3 = BG.getObjRotVector3(obj) --面的法向量（轴）
        for i = 1, 4 do
            x1, y1, z1 = BG.getObjPos(obj, i)
            x1, y1, z1 = eggmath.getPointByRotateWithVector( --面上的点绕轴旋转
                    x1, y1, z1, --point_x, point_y, point_z
                    da, --da
                    x, y, z, --center_x, center_y, center_z
                    vector3 --UnitVector3
            )
            BG.setObjPos2(obj, i, x1, y1, z1)
        end
    end
    --获取贴图平行于贴图面的直线方向向量
    function BG.getRotParallelToObj(obj)
        local p, dx, dy, dz = obj[2]
        dx = p[3][1] - p[2][1]
        dy = p[3][2] - p[2][2]
        dz = p[3][3] - p[2][3]
        local l = math.sqrt(dx*dx + dy*dy + dz*dz)
        return {dx/l, dy/l, dz/l}
    end
    --更新某个obj某个顶点的位置(仅限于中心位置不变时单独调用，不然会错乱!!!!比如旋转）
    ---@param obj table @对象
    ---@param i number @顶点下标（范围1-4)
    ---@param dxdydz number @增量
    function BG.updateBgObjPoint(obj, i, dx, dy, dz)
        obj[2][i][1] = obj[2][i][1] + dx
        obj[2][i][2] = obj[2][i][2] + dy
        obj[2][i][3] = obj[2][i][3] + dz
    end
    --更新某个obj的位置
    function BG.updateBgObjPos(obj, dx, dy, dz)
        obj[3][1] = obj[3][1] + dx
        obj[3][2] = obj[3][2] + dy
        obj[3][3] = obj[3][3] + dz
        for i = 1, 4 do
            BG.updateBgObjPoint(obj, i, dx, dy, dz)
        end
    end
    --设置某个obj的位置
    function BG.setBgObjPos(obj, x, y, z)
        local dx, dy, dz = BG.getObjCen(obj)
        dx, dy, dz = (x - dx), (y - dy), (z - dz)
        obj[3][1] = x
        obj[3][2] = y
        obj[3][3] = z
        for i = 1, 4 do
            BG.updateBgObjPoint(obj, i, dx, dy, dz)
        end
    end
    --a r g b 操作模块
    --获取某个obj的透明度
    function BG.getBgObjAlp(obj)
        return obj[1][3]
    end
    --获取某个obj的透明度
    function BG.setBgObjAlp(obj, _a)
        obj[1][3] = _a
    end
    --更新某个obj的透明度
    function BG.updateBgObjAlp(obj, d_a)
        obj[1][3] = obj[1][3] + d_a
    end
    --获取某个bgobj的r g b值
    function BG.getBgObjRGB(obj)
        return obj[1][4], obj[1][5], obj[1][6]
    end
    --设置某个bgobj的r g b值
    function BG.setBgObjRGB(obj, r, g, b)
        obj[1][4], obj[1][5], obj[1][6] = r, g, b
    end
    --更新某个obj的r g b值
    function BG.updateBgObjRGB(obj, d_r, d_g, d_b)
        obj[1][4], obj[1][5], obj[1][6] = obj[1][4] + d_r, obj[1][5] + d_g, obj[1][6] + d_b
    end
    --获取某个bgobj的贴图名
    function BG.getBgObjImg(obj)
        return obj[1][1], obj[1][7]
    end
    --设置某个bgobj的贴图
    function BG.setBgObjImg(obj, img1, img2)
        obj[1][1], obj[1][7] = img1, img2
    end
    --endregion

    --region 2DBgObj
    function BG.create2DBgObj(img, x, y, rot, hscale, vscale, blend, _a, _r, _g, _b)
        blend = blend or ""
        _a, _r, _g, _b = _a or 255, _r or 255, _g or 255, _b or 255
        local obj = {
            {blend, _a, _r, _g, _b}, --SetImageState
            {img, x, y, rot, hscale, vscale} --Render
        }
        return obj
    end
    function BG.get2DBgObjImg(obj)
        return obj[2][1]
    end
    function BG.set2DBgObjImg(obj, img)
        obj[2][1] = img
    end
    function BG.get2DBgObjPos(obj)
        return obj[2][2], obj[2][3]
    end
    function BG.set2DBgObjPos(obj, x, y)
        obj[2][2], obj[2][3] = x, y
    end
    function BG.get2DBgObjRot(obj)
        return obj[2][4]
    end
    function BG.set2DBgObjRot(obj, rot)
        obj[2][4] = rot
    end
    function BG.get2DBgObjSize(obj)
        return obj[2][5], obj[2][6]
    end
    function BG.set2DBgObjSize(obj, hscale, vscale)
        obj[2][5], obj[2][6] = hscale, vscale
    end
    function BG.get2DBgObjBlend(obj)
        return obj[1][1]
    end
    function BG.set2DBgObjBlend(obj, blend)
        obj[1][1] = blend
    end
    function BG.get2DBgObjColor(obj)
        return obj[1][2], obj[1][3], obj[1][4], obj[1][5]
    end
    function BG.set2DBgObjColor(obj, a, r, g, b)
        obj[1][2], obj[1][3], obj[1][4], obj[1][5] = a, r, g, b
    end
    --endregion

    --region 与背景对象本身有关的操作方法
    --更新对象使之面与视线垂直(opsi = opposite)
    ---@param obj table @本关定义的背景元素
    function BG:opsiToEye(obj)
        BG.setObjRot(obj, Get_Opposite_Vector(self.eye_rot3))
    end
    --更新需要与视线垂直的所有对象（该方法可重载
    function BG:updateAllOpsiToEye()
        for _, v in ipairs(self.bg_comp) do
            for _, BgObj in ipairs(v.bg_objs) do
                BG.opsiToEye(self, BgObj)
            end
        end
    end
    --获取视野中心
    function BG:getEyeCen()
        return self.eye_pos[1], self.eye_pos[2], self.eye_pos[3]
    end
    --设置视野中心
    function BG:setEyeCen(x, y, z)
        self.eye_pos[1], self.eye_pos[2], self.eye_pos[3] = x, y, z
        Set3D('eye' , self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
    end
    --更新视野中心
    function BG:updateEyeCen(dx, dy, dz)
        self.eye_pos[1], self.eye_pos[2], self.eye_pos[3] = self.eye_pos[1] + dx, self.eye_pos[2] + dy, self.eye_pos[3] + dz
        Set3D('eye' , self.eye_pos[1], self.eye_pos[2], self.eye_pos[3]) --更新一下视野中心
        BG.updateAt(self) --at也要同时更新
    end
    --更新3维视线方向向量
    function BG:updateEyeRot3()
        self.eye_rot3[1], self.eye_rot3[2], self.eye_rot3[3] = sin(self.eye_rot[1])*cos(self.eye_rot[2]), cos(self.eye_rot[1]), sin(self.eye_rot[1])*sin(self.eye_rot[2])
        BG.updateAt(self)
    end
    --设置视线值
    function BG:setEyeRot(a, b)
        self.eye_rot[1], self.eye_rot[2] = a, b
        BG.updateEyeRot3(self) --更新一下
    end
    --获取视线值
    function BG:getEyeRot()
        return self.eye_rot[1], self.eye_rot3[2]
    end
    function BG:getEyeRot3()
        return self.eye_rot3[1], self.eye_rot3[2], self.eye_rot3[3]
    end
    --更新at
    function BG:updateAt()
        local a0, b0, c0 = BG.getEyeCen(self)
        local a1, b1, c1 = BG.getEyeRot3(self)
        self.at = {a0 + a1, b0 + b1, c0 + c1}
        Set3D('at'  , self.at[1], self.at[2], self.at[3])
    end
    --更新视线
    function BG:updateEyeRot(da, db)
        self.eye_rot[1], self.eye_rot3[2] = self.eye_rot[1] + da, self.eye_rot3[2] + db
        BG.updateEyeRot3(self)
        --BG.updateAllOpsiToEye(self)--更新渲染序列中所有面使之与视线垂直
        --更新一下视角
        BG.updateAt(self)
    end
    --获取背景运动速度和方向法向量
    function BG:getV()
        return self.bg_speed, self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3]
    end
    --设置背景运动速度
    ---@param v number @速度大小
    ---@param a table @球坐标
    function BG:setV(v, a)
        self.bg_rot[1], self.bg_rot[2] = a[1], a[2]
        local a = ballToVect3(a)
        self.bg_speed = v
        self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3] = a[1], a[2], a[3]
    end
    --更新背景运动速度
    function BG:updateV(dv, da, db)
        self.bg_speed = self.bg_speed + dv
        self.bg_rot[1], self.bg_rot[2] = self.bg_rot[1] + da, self.bg_rot[2] + db
        local a = ballToVect3(self.bg_rot)
        self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3] = a[1], a[2]. a[3]
    end

    --
    function BG:setZ(zmin, zmax)
        self._z = {zmin, zmax}
        Set3D('z', zmin, zmax) --渲染范围
    end
    --获取fog的范围
    function BG:getFogRange()
        return self.fog[1], self.fog[2]
    end
    --获取fog的a、r、g、b
    function BG:getFogColor()
        return self.fog[3], self.fog[4], self.fog[5], self.fog[6]
    end
    --设置雾的范围
    function BG:setFogRange(a, b)
        self.fog[1], self.fog[2] = a, b
        --Set3D('fog', a, b, Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6]))
    end
    --设置雾的a、r、g、b
    function BG:setFogColor(a, r, g, b)
        self.fog[3], self.fog[4], self.fog[5], self.fog[6] = a, r, g, b
        --Set3D('fog', self.fog[1], self.fog[2], Color(a, r, g, b))
    end
    --设置雾
    function BG:setFog(r0, r1, a, r, g, b)
        self.fog[1], self.fog[2] = r0, r1
        self.fog[3], self.fog[4], self.fog[5], self.fog[6] = a, r, g, b
        --Set3D('fog', r0, r1, Color(a, r, g, b))
    end
    --只更新雾
    function BG:updateFog()
        Set3D('fog', self.fog[1], self.fog[2], Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6]))
    end
    --更新雾的范围
    function BG:updateFogRange(da, db)
        self.fog[1], self.fog[2] = self.fog[1] + da, self.fog[2] + db
        --BG.updateFog(self)
    end
    --更新雾的a、r、g、b
    function BG:updateFogColor(da, dr, dg, db)
        self.fog[3], self.fog[4], self.fog[5], self.fog[6] = self.fog[3] + da, self.fog[4] + dr, self.fog[5] + dg, self.fog[6] + db
        --BG.updateFog(self)
    end
    --获取up(起床（x
    function BG:getUp()
        return self.up[1], self.up[2], self.up[3]
    end
    function BG:getUpRot()
        return self.up_rot[1], self.up_rot[2]
    end
    --设置up
    function BG:setUp(a, b, c)
        self.up[1], self.up[2], self.up[3] = a, b, c
        Set3D('up', a, b, c)
    end
    function BG:setUpRot(a, b)
        self.up_rot[1], self.up_rot[2] = a, b
        local up = ballToVect3(self.up_rot)
        BG.setUp(self, up[1], up[2], up[3])
    end
    --更新up_rot
    function BG:updateUpRot(da, db)
        self.up_rot[1], self.up_rot[2]= self.up_rot[1] + da, self.up_rot[2] + db
        local up = ballToVect3(self.up_rot)
        BG.setUp(self, up[1], up[2], up[3])
    end
    --获取fovy
    function BG:getFovy()
        return self.fovy[1]
    end
    --设置fovy
    function BG:setFovy(a)
        self.fovy[1] = a
        Set3D('fovy', a)
    end
    --更新fovy
    function BG:updateFovy(da)
        self.fovy[1] = self.fovy[1] + da
        Set3D('fovy', self.fovy[1])
    end
    --渲染黑色遮障(可供全局调节，降低背景亮度
    function BG:renderBlackBoard()
        local alp = setting.effect.background_mask * 0.01
        if alp < 1 then
            SetImageState("white", "", Color(255*alp, 0, 0, 0))
            Render4V("white", -192, 224, 0.5,
                              192, 224, 0.5,
                              192, -224, 0.5,
                              -192, -224, 0.5
            )
            SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
        end

    end
    --渲染灰色纯色背景(在关闭背景时启用
    function BG:renderGrayBoard()
        SetImageState("white", "", Color(255, 117, 138, 150))
        Render4V("white", -192, 224, 0.5,
                192, 224, 0.5,
                192, -224, 0.5,
                -192, -224, 0.5
        )
        SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
    end
    --渲染反色遮障
    function BG:renderAntiBoard(a, r, g, b)
        if a > 0 then
            SetImageState("white", "", Color(a, r, g, b))
            Render4V("white", -192, 224, 0.5,
                    192, 224, 0.5,
                    192, -224, 0.5,
                    -192, -224, 0.5
            )
            SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
        end

    end
    --endregion
end
--背景类事件
do
    --创建静止的连续纹理表
    function BG:createConBgObjsTable(img, x, y, z, rot, blend, _a, _r, _g, _b, num, a0, dist)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx, dy, dz = dist*a[1], dist*a[2], dist*a[3]
        for i = 0, num-1 do
            table.insert(tb, BG.createBgObj(self, img, x + dx*i, y + dy*i, z + dz*i, rot, blend, _a, _r, _g, _b))
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end

    function BG.createConBgObjsTableDirectly(img, imx_w, img_h, x, y, z, rot, blend, _a, _r, _g, _b, num, a0, dist)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx, dy, dz = dist*a[1], dist*a[2], dist*a[3]
        for i = 0, num-1 do
            table.insert(tb, BG.createBgObjDirectly(img, imx_w, img_h, x + dx*i, y + dy*i, z + dz*i, rot, blend, _a, _r, _g, _b))
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end

    --创建位于两侧的静止的连续纹理表(如常见的树
    ---@param wide number 两侧的宽度
    function BG:createTwoSidesBgObjsTable(img, x, y, z, rot, blend, _a, _r, _g, _b, num, a0, dist, wide)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx, dy, dz = dist*a[1], dist*a[2], dist*a[3]
        wide = 0.5*wide
        local u = 1
        for i = 0, num-1 do
            table.insert(tb, BG.createBgObj(self, img, x + dx*i + wide*u, y + dy*i, z + dz*i, rot, blend, _a, _r, _g, _b))
            u = -u
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end

    function BG.createTwoSidesBgObjsTableDirectly(img, img_x, img_y, x, y, z, rot, blend, _a, _r, _g, _b, num, a0, dist, wide)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx, dy, dz = dist*a[1], dist*a[2], dist*a[3]
        wide = 0.5*wide
        local u = 1
        for i = 0, num-1 do
            table.insert(tb, BG.createBgObjDirectly(img, img_x, img_y, x + dx*i + wide*u, y + dy*i, z + dz*i, rot, blend, _a, _r, _g, _b))
            u = -u
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end

    --创建平铺的连续纹理表（如地面
    ---@param a1 number 横向平铺角度
    function BG:createTileBgObjsTable(img, x, y, z, rot, blend, _a, _r, _g, _b, num_l, a0, dist, num_w, a1, w)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx_l, dy_l, dz_l = dist*a[1], dist*a[2], dist*a[3]
        local dx_w, dy_w = w*cos(a1), w*sin(a1)
        num_w = (num_w - 1)/2
        for j = -num_w, num_w do
            for i = 0, num_l-1 do
                table.insert(tb, BG.createBgObj(self, img, x + dx_l*i + dx_w*j, y + dy_l*i + dy_w*j, z + dz_l*i - 0.000001*j, rot, blend, _a, _r, _g, _b))
            end
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end
    function BG.createTileBgObjsTableDirectly(img, img_w, img_h, x, y, z, rot, blend, _a, _r, _g, _b, num_l, a0, dist, num_w, a1, w, isSymmetry)
        local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
        local tb = {} --创建存储创建对象的表
        local dx_l, dy_l, dz_l = dist*a[1], dist*a[2], dist*a[3]
        local dx_w, dy_w = w*cos(a1), w*sin(a1)
        num_w = (num_w - 1)/2
        if isSymmetry then --是否需要左右对称贴图
            for j = -num_w, num_w do
                for i = 0, num_l-1 do
                    table.insert(tb, BG.createBgObjDirectly(img, img_w*sign(j), img_h, x + dx_l*i + dx_w*j, y + dy_l*i + dy_w*j, z + dz_l*i - 0.000001*j, rot, blend, _a, _r, _g, _b))
                end
            end
        else
            for j = -num_w, num_w do
                for i = 0, num_l-1 do
                    table.insert(tb, BG.createBgObjDirectly(img, img_w, img_h, x + dx_l*i + dx_w*j, y + dy_l*i + dy_w*j, z + dz_l*i - 0.000001*j, rot, blend, _a, _r, _g, _b))
                end
            end
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end
    --创建卷曲面（隧道）
    function BG:createCurvedBgObjsTable(tex, x, y, z, blend, _a, _r, _g, _b, radius, n_r, len, n_l)
        local w, h = GetTextureSize(tex)
        if not (lstg.tmpvar.ImgList) then
            lstg.tmpvar.ImgList = {}
        end
        if not (lstg.tmpvar.ImgList[tex]) then
            LoadImageGroup(tex, tex, 0, 0, w / n_r, h / n_l, n_r, n_l, 0, 0)
            lstg.tmpvar.ImgList[tex] = true
        end

        local tb = {} --创建存储创建对象的表
        local img
        local a, da, dx, dy, rot = 0, 360/n_r
        for i = 1, n_r do
            a = a + da
            dx, dy = radius*cos(a), radius*sin(a)
            for j = 0, n_l - 1 do
                if a >= 0 and a <= 90 then
                    rot = {90 - a, 180}
                elseif a > 90 and a <= 180 then
                    rot = {(a - 90), 0}
                elseif a > 180 and a <= 270 then
                    rot = {(a - 90), 0}
                elseif a > 270 and a <= 360 then
                    rot = {180 - (a - 270), 180}
                end
                img = tex..(i + n_r*j)
                BG.addToImg(self, img, img, -6.35*radius/n_r, -len/n_l)
                table.insert(tb, BG.createBgObj(self, img, x + dx, y + dy, z + j/n_l*len - 0.000001*j, rot, blend, _a, _r, _g, _b))
                BG.updateObjAngle(tb[#tb], 90 - da*i) --为什么是反的
            end
        end
        return tb --返回的是一个存储该方法所创建对象的表
    end

    --使视野中心先匀加速，再匀速，最后匀减速至0运动
    function BG:accDecEyePos(v, rot, t0, t1, t2)
        task.New(self, function()
            local rot = ballToVect3(rot)  --用局部变量接收，注意保护原数据！
            local v, dv = 0, v/t0
            for _ = 1, t0 do
                v = v + dv
                BG.updateEyeCen(self, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
            for _ = 1, t1 do
                BG.updateEyeCen(self, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
            dv = -v/t2
            for _ = 1, t2 do
                v = v + dv
                BG.updateEyeCen(self, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
        end)
    end
    --使obj先匀加速，再匀速，最后匀减速至0运动
    function BG:accDecObjPos(obj, v, rot, t0, t1, t2, wt)
        wt = wt or 0
        task.New(self, function()
            task.Wait(wt)
            local rot = ballToVect3(rot)  --用局部变量接收，注意保护原数据！
            local v, dv = 0, v/t0
            for _ = 1, t0 do
                v = v + dv
                BG.updateBgObjPos(obj, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
            for _ = 1, t1 do
                BG.updateBgObjPos(obj, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
            dv = -v/t2
            for _ = 1, t2 do
                v = v + dv
                BG.updateBgObjPos(obj, v*rot[1], v*rot[2], v*rot[3])
                task.Wait(1)
            end
        end)
    end
    --均匀变化透明度
    function BG:chObjAlp(obj, d_a, t)
        task.New(self, function()
            d_a = d_a/t
            for _ = 1, t do
                BG.updateBgObjAlp(obj, d_a)
                task.Wait(1)
            end
        end)
    end
    --使某obj透明度在t时间内变为0
    function BG:chObjAlpToZero(obj, t)
        BG.chObjAlp(self, obj, -BG.getBgObjAlp(obj), t)
    end
    --使某obj透明度在t时间内变为_a
    function BG:chObjAlpTo(obj, _a, t)
        BG.chObjAlp(self, obj, _a-BG.getBgObjAlp(obj), t)
    end
    --在t时间内使视野仰角增加至
    function BG:changeEyeRot1To(eyerot2, t)
        task.New(self, function()
            local eyerot1 = M.baseBG.getEyeRot(self)
            local d = (eyerot2-eyerot1)/t
            for _ = 1, t do
                M.baseBG.updateEyeRot(self, d, 0)
                task.Wait(1)
            end
        end)
    end
    --在t时间使雾的范围变化至
    function BG:changeFogRange0To(fog1, t)
        task.New(self, function()
            local fog0 = M.baseBG.getFogRange(self)
            local d = (fog1-fog0)/t
            for _ = 1, t do
                M.baseBG.updateFogRange(self, d, 0)
                task.Wait(1)
            end
        end)
    end
    function BG:changeFogRange1To(fog1, t)
        task.New(self, function()
            local _, fog0 = M.baseBG.getFogRange(self)
            local d = (fog1-fog0)/t
            for _ = 1, t do
                M.baseBG.updateFogRange(self, 0, d)
                task.Wait(1)
            end
        end)
    end
    --在t时间使雾的颜色变化至
    function BG:changeFogARBGTo(a, r, g, b, t)
        task.New(self, function()
            local a0, r0, g0, b0 = M.baseBG.getFogColor(self)
            local da, dr, dg, db = (a-a0)/t, (r-r0)/t, (g-g0)/t, (b-b0)/t
            for _ = 1, t do
                M.baseBG.updateFogColor(self, da, dr, dg, db)
                task.Wait(1)
            end
        end)
    end
end
--背景类帧方法
do
    --按次序渲染
    function BG:renderInOrder()
        SetViewMode'3d'
        local obj, img, p
        for i = 1, #self.static do
            obj = self.static[i]
            img = obj[1][1]
            p = obj[2]
            SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
            Render4V(img,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
        end
        for i = 1, #self.objs do
            obj = self.objs[i]
            img = obj[1][1]
            p = obj[2]
            SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
            Render4V(img,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
        end
        SetViewMode'world'
    end
    function BG:render2dFontInOrder()
        local obj
        for i = 1, #self.static2dfont do
            obj = self.static2dfont[i]
            self.img = obj[1][1]
            SetImgState(self, obj[1][2], obj[1][3], 255, 255, 255)
            Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
        end
    end
    function BG:render2dRearInOrder()
        local obj
        for i = 1, #self.static2drear do
            obj = self.static2drear[i]
            self.img = obj[1][1]
            SetImgState(self, obj[1][2], obj[1][3], 255, 255, 255)
            Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
        end
    end
    --每帧都要更新所有背景元素
    function BG:updateFrame()
        --全遮障背景不显示
        if setting.effect.background_mask >= 100 then self.hide = true else self.hide = false end
        --静止类型的obj不受背景速度影响，故不更新
        local v, vx, vy, vz = BG.getV(self)
        vx, vy, vz = v*vx, v*vy, v*vz
        --普通类型的obj需要根据背景速度更新一次位置
        for _, obj in pairs(self.objs) do
            BG.updateBgObjPos(obj, vx, vy, vz)
        end
        --运动类型的obj需要再以自己的速度更新一次位置
        for _, obj in pairs(self.active) do
            BG.updateBgObjPos(obj, obj[5][1], obj[5][2], obj[5][3])
        end
    end
    --打印相关参数（测试用
    function BG:printParam()
        local color = Color(255, 255, 255, 255)
        SetViewMode'ui'
        local name = {"eye_pos", "eye_rot", "up_rot", "fovy", "z", "fog"}
        local param = {self.eye_pos, self.eye_rot, self.up_rot, self.fovy, self._z, self.fog}
        local x, y = 300, 200
        for i = 1, #param do
            x = 300
            --RenderText("menu", name[i], x, y, 0.5)
            RenderTTF('Mono24', name[i], x, y, x, y, 1, color, 'left', 'noclip')
            for j = 1, #param[i] do
                x = x + 30
                RenderTTF('Mono24', string.format("%.2f", param[i][j]), x, y, x, y, 1, color, 'left', 'noclip')
            end
            y = y - 20
        end
        x = 300
        for _, v in ipairs(BG.getAllBgComponent(self)) do
            RenderTTF('Mono24', C.getName(v), x, y, x, y, 1, color, 'left', 'noclip')
            RenderTTF('Mono24', C.getBgObjNumber(v), x - 30, y, x - 30, y, 1, color, 'left', 'noclip')
            y = y - 10
        end
        --RenderText("menu", "time = "..self.timer, x - 50, y, 0.5)
        SetViewMode'world'
    end
end
--背景类构造
do
    function BG:init()
        BG.setDefault(self)
    end
    function BG:frame()
        --BG.updateFrame(self)
        task.Do(self)
        BG.bgComponentFrame(self)
    end
    function BG:render()
        Set3D('eye', unpack(self.eye_pos))
        Set3D('at', unpack(self.at))
        Set3D('up', unpack(self.up))
        Set3D('fovy', self.fovy[1])
        Set3D('z', self._z[1], self._z[2])
        --BG.render2dFontInOrder(self)
        --BG.renderInOrder(self)
        --BG.render2dRearInOrder(self)
        BG.clearRenderPlane()
        BG.bgComponentRender(self)
        --BG.printParam(self)
    end
end
M.baseBG = BG

---------------------------背景组件模块-----------------------------
---@class BgComponent
---创建一个静态的背景组件
function C.getName(self)
    return self.name
end
function C.setAlpha(self, alpha)
    self.alpha = min(1, max(0, alpha))
end
function C.addAlpha(self, dalpha)
    self.alpha = self.alpha + dalpha
    self.alpha = min(1, max(0, self.alpha))
end
function C.setFog(self, r0, r1, a, r, g, b)
    self.fog = {r0, r1, a, r, g, b}
end
function C.useBgFog(self)
    self.fog = nil
end
function C.draw(self)
    if self.alpha > 0 then
        if self.isFog then
            if self.fog then
                BG.updateFog(self)
            else
                local current_bg = lstg.tmpvar.bg
                if current_bg then
                    BG.updateFog(current_bg)
                end
            end
        else
            Set3D('fog' ,100, 100, Color(0, 0, 0, 0))
        end
        SetViewMode'3d'
        local a = self.alpha
        local obj, img, p
        for i = 1, #self.bg_objs do
            obj = self.bg_objs[i]
            if obj[1][3] > 0 then
                img = obj[1][1]
                p = obj[2]
                SetImageState(img, obj[1][2], Color(obj[1][3]*a, obj[1][4], obj[1][5], obj[1][6]))
                Render4V(img,    p[1][1], p[1][2], p[1][3],
                        p[2][1], p[2][2], p[2][3],
                        p[3][1], p[3][2], p[3][3],
                        p[4][1], p[4][2], p[4][3])
            end
        end
        SetViewMode'world'
    end
end
--第二种默认的渲染方式，根据透明度渲染obj的img1和img2两张图（主要用于渐变
function C.draw2(self)
    if self.isFog then
        if self.fog then
            BG.updateFog(self)
        else
            local current_bg = lstg.tmpvar.bg
            if current_bg then
                BG.updateFog(current_bg)
            end
        end
    else
        Set3D('fog' ,100, 100, Color(0, 0, 0, 0))
    end
    SetViewMode'3d'
    local a = self.alpha
    local obj, img1, img2, _a, p
    for i = 1, #self.bg_objs do
        obj = self.bg_objs[i]
        _a = obj[1][3]
        img1, img2 = obj[1][1], obj[1][7]
        p = obj[2]
        if a <= 0 then --只渲染img2
            SetImageState(img2, obj[1][2], Color(_a, obj[1][4], obj[1][5], obj[1][6]))
            Render4V(img2,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
        elseif a >= 1 then --只渲染img1
            SetImageState(img1, obj[1][2], Color(_a, obj[1][4], obj[1][5], obj[1][6]))
            Render4V(img1,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
        else
            SetImageState(img1, obj[1][2], Color(_a*a, obj[1][4], obj[1][5], obj[1][6]))
            SetImageState(img2, obj[1][2], Color(_a*(1-a), obj[1][4], obj[1][5], obj[1][6]))
            Render4V(img1,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
            Render4V(img2,    p[1][1], p[1][2], p[1][3],
                    p[2][1], p[2][2], p[2][3],
                    p[3][1], p[3][2], p[3][3],
                    p[4][1], p[4][2], p[4][3])
        end
    end
    SetViewMode'world'
end
function C.draw2D(self)
    if self.alpha > 0 then
        local a = self.alpha
        local obj
        for i = 1, #self.bg_objs do
            obj = self.bg_objs[i]
            if obj[1][2] > 0 then
                SetImageState(obj[2][1], obj[1][1], Color(obj[1][2]*a, obj[1][3], obj[1][4], obj[1][5]))
                Render(obj[2][1], obj[2][2], obj[2][3], obj[2][4], obj[2][5], obj[2][6])
            end
        end
    end
end
function C.turnOnFog(self, FogOn)
    self.isFog = FogOn
end
--把一个背景对象添加进该组件中
function C.addBgObj(self, BgObj)
    table.insert(self.bg_objs, BgObj)
end
--把一组背景对象添加进该组件中
function C.addBgObjs(self, BgObj_t)
    for _, v in ipairs(BgObj_t) do
        C.addBgObj(self, v)
    end
end
--获取组件中有多少对象
function C.getBgObjNumber(self)
    return #self.bg_objs
end
--获取组件的所有对象的表
function C.getBgObjList(self)
    return self.bg_objs
end
--移动组件的所有对象在三维空间的位置
function C.updateAllObjPos(self, dx, dy, dz)
    for _, v in pairs(C.getBgObjList(self)) do
        BG.updateBgObjPos(v, dx, dy, dz)
    end
end
--设置组件的所有对象在三维空间的位置
function C.setAllObjPos(self, x, y, z)
    for _, v in pairs(C.getBgObjList(self)) do
        BG.setBgObjPos(v, x, y, z)
    end
end
--获取一个组件所有对象的位置表
function C.getComPosList(self)
    local pos_list = {}
    for k, obj in ipairs(C.getBgObjList(self)) do
        pos_list[k] = {}
        pos_list[k][1], pos_list[k][2], pos_list[k][3] = BG.getObjCen(obj)
    end
    return pos_list
end
--指定一个位置表，为某个组件添加元素组
function C.addBgObjsByList(self, pos_list, dx, dy, dz, img, w, h, rot, blend, a, r, g, b, angle)
    for _, v in ipairs(pos_list) do
        C.addBgObj(self,
                BG.createBgObjDirectly(
                        img, w, h,  --img, w, h,
                        v[1] + dx, v[2] + dy, v[3] + dz, rot, --x, y, z, rot,
                        blend, a, r, g, b,
                        angle)
        )
    end
end

C.getFogRange = BG.getFogRange
C.getFogColor = BG.getFogColor
C.setFogRange = BG.setFogRange
C.setFogColor = BG.setFogColor
C.updateFog = BG.updateFog
C.updateFogRange = BG.updateFogRange

---自定义组件类
function C.createComponentClassFunc(initFunc, updateFunc, is2D)
    local c = newSimpleClass()
    ---@param name string 组件名，可用于搜索
    function c.constructor(self, name, isfog, fog)
        self.bg_objs = {}
        self.alpha = 1
        self.name = name
        self._r, self._g, self._b = 255, 255, 255
        self.isFog = isfog
        self.fog = fog
        self.timer = 0
        initFunc(self)
    end
    function c.update(self)
        updateFunc(self)
        self.timer = self.timer + 1 --注意是每执行完一次update才会+1
    end
    if is2D then
        c.draw = C.draw2D
    else
        c.draw = C.draw
    end
    c.setAlpha = C.setAlpha
    c.addBgObj = C.addBgObj
    c.addBgObjs = C.addBgObjs
    ----------------------------------------引出去的创建方法
    ---@return BgComponent
    local function createComponent(name, isfog)
        return c.new(name, isfog)
    end
    return createComponent
end

---创建一个静态的3d组件
do
    --组件的obj只包含一个img
    local c1 = newSimpleClass()
    ---@param name string 组件名，可用于搜索
    function c1.constructor(self, name, isfog, fog)
        self.bg_objs = {}
        self.alpha = 1
        self.name = name
        self._r, self._g, self._b = 255, 255, 255
        self.isFog = isfog
        self.fog = fog
    end
    function c1.update(self)
        task.Do(self)
    end
    c1.draw = C.draw
    c1.setAlpha = C.setAlpha
    c1.addBgObj = C.addBgObj
    c1.addBgObjs = C.addBgObjs
    ----------------------------------------引出去的创建方法
    ---@return BgComponent
    function M.createStaticBgComponent(name, fog)
        return c1.new(name, fog)
    end

    ------------------------------------------------------
    --组件的obj包含两个img
    local c2 = newSimpleClass()
    extend(c2, c1)
    c2.draw = C.draw2
    ----------------------------------------引出去的创建方法
    ---@return BgComponent
    function M.createStaticBgComponent2(name, fog)
        local obj = c2.new(name, fog)
        obj.draw = C.draw2
        return obj
    end
end

---创建一个静态的2d组件
do
    --组件的obj只包含一个img
    local c1 = newSimpleClass()
    ---@param name string 组件名，可用于搜索
    function c1.constructor(self, name)
        self.bg_objs = {} --{{blend, a, r, g, b}, {img, x, y, rot, hscale, vscale}}
        self.alpha = 1
        self.name = name
    end
    function c1.update(self)
        task.Do(self)
    end
    c1.draw = C.draw2D
    c1.setAlpha = C.setAlpha
    c1.addBgObj = C.addBgObj
    c1.addBgObjs = C.addBgObjs
    ----------------------------------------引出去的创建方法
    ---@return BgComponent
    function M.create2DBgComponent(name)
        return c1.new(name)
    end
end

---创建一个前进（或后退）的背景组件
do
    --组件的obj只包含一个img
    local c1 = newSimpleClass()
    function c1.constructor(self, name, zmin, zmax, v, isfog, fog)
        self.bg_objs = {}
        self.alpha = 1
        self._r, self._g, self._b = 255, 255, 255
        self.v = v
        self.zmin, self.zmax = zmin, zmax
        self.name = name
        self.isFog = isfog
        self.fog = fog --是否受雾影响
    end
    --C.advanceBgComponentInit = c1.constructor
    function c1.update(self)
        task.Do(self)
        local obj
        local back = {} --存放要前进的obj
        local v = c1.getV(self)
        local d = self.zmax - self.zmin
        for i = 1, #self.bg_objs do
            obj = self.bg_objs[i]
            BG.updateBgObjPos(obj, 0, 0, v)
            BG.updateBgObjAlp(obj, 10)
            if BG.getBgObjAlp(obj) >= 255 then
                BG.setBgObjAlp(obj, 255)
            end
            if v < 0 then
                if obj[3][3] < self.zmin then
                    table.insert(back, obj)
                    --返回到z = zmax
                    BG.updateBgObjPos(obj, 0, 0, d)
                    BG.setBgObjAlp(obj, 0)
                end
            else
                if obj[3][3] > self.zmax then
                    table.insert(back, obj)
                    --返回到z = zmin
                    BG.updateBgObjPos(obj, 0, 0, -d)
                    BG.setBgObjAlp(obj, 0)
                end
            end
        end
        if v < 0 then
            for i = 1, #back do
                table.remove(self.bg_objs)
                local j = 1
                local _, _, currentZ, objZ = BG.getObjCen(back[i])
                while true do
                    _, _, objZ = BG.getObjCen(self.bg_objs[j])
                    if currentZ >= objZ then
                        break
                    else
                        j = j + 1
                    end
                end
                table.insert(self.bg_objs, j, back[i])
            end
        else
            for i = 1, #back do
                table.remove(self.bg_objs)
                local j = 1
                local _, _, currentZ, objZ = BG.getObjCen(back[i])
                while true do
                    _, _, objZ = BG.getObjCen(self.bg_objs[j])
                    if currentZ <= objZ then
                        break
                    else
                        j = j + 1
                    end
                end
                table.insert(self.bg_objs, j, back[i])
            end
        end
    end
    C.advanceBgComponentUpdate = c1.update
    c1.draw = C.draw
    function c1:getV()
        return self.v
    end
    function c1:setV(v)
        self.v = v
    end
    function c1:addV(dv)
        self.v = self.v + dv
    end
    function c1:setZRange(zmin, zmax)
        self.zmin, self.zmax = zmin or self.zmin, zmax or self.zmax
    end
    --渲染次序表倒序
    function c1:reverseOrder()
        local n = #self.bg_objs
        local t = {}
        for i = 1, n do
            t[n - i + 1] = self.bg_objs[i]
        end
        self.bg_objs = t
    end
    --根据z坐标对表进行排序整理，保证正常的前期次序
    function c1:sortByZ()
        local n = #self.bg_objs
        local t = {}
        --拷贝
        for i = 1, n do
            t[i] = self.bg_objs[i]
        end
        --升序排序
        local tmp, min_index, now_z
        for i = n, 1, -1 do
            _, _, tmp = BG.getObjCen(t[1])
            min_index = 1
            for j = 1, i do
                _, _, now_z = BG.getObjCen(t[j])
                if now_z < tmp then
                    tmp = now_z
                    min_index = j
                end
            end
            self.bg_objs[i] = t[min_index]
            table.remove(t, min_index)
        end
    end
    C.sortByZ = c1.sortByZ
    c1.setAlpha = C.setAlpha
    c1.addBgObj = C.addBgObj
    c1.addBgObjs = C.addBgObjs
    C.advanceBgComponentClass = c1
    ----------------------------------引出去的创建方法
    ---@return BgComponent
    function M.createAdvanceBgComponent(name, zmin, zmax, v, isfog, fog)
        return c1.new(name, zmin, zmax, v, isfog, fog)
    end
    ------------------------------------------------------
    --组件的obj包含两个img
    local c2 = newSimpleClass()
    extend(c2, c1)
    --c2.draw = C.draw2 --不懂为什么居然不生效
    ----------------------------------引出去的创建方法
    ---@return BgComponent
    function M.createAdvanceBgComponent2(name, zmin, zmax, v, isfog, fog)
        local obj = c2.new(name, zmin, zmax, v, isfog, fog)
        obj.draw = C.draw2
        return obj
    end
end

--背景组件模块初始化
function BG:bgComponentInit()
    self.bg_comp = {}
end
--添加一个背景组件
---@param BgComponent BgComponent 背景组件对象
function BG:addBgComponent(BgComponent, where_name, pos)
    if pos ~= 1 then pos = 0 end --pos 只能是0和1，如果是1的话则插入在被标记名字组件的后面，否则在前面
    if where_name then
        local i = BG.searchBgComponent(self, where_name)
        if i > 0 then
            table.insert(self.bg_comp, i + pos, BgComponent)
        else
            error("错误的插入")
        end
    else
        table.insert(self.bg_comp, BgComponent) --无指定名称则直接默认插入在最后
    end
end
--通过组件名来查找组件
function BG:searchBgComponent(name)
    for k, v in ipairs(self.bg_comp) do
        if v.name == name then
            return k
        end
    end
    return -1
end
--移除某个组件
function BG:removeBgComponent(name)
    local i = BG.searchBgComponent(self, name)
    if i ~= -1 then
        local n = #self.bg_comp - i
        for j = 0, n - 1 do --移 n 次
            self.bg_comp[i + j] = self.bg_comp[i + j + 1]
        end
        table.remove(self.bg_comp) --记得要移除最后一位
    end
end
--移除所有组件
function BG:removeAllBgComponent()
    self.bg_comp = {}
end
--获取所有组件表
function BG:getAllBgComponent()
    return self.bg_comp
end
--组件帧模块
function BG:bgComponentFrame()
    for _, v in ipairs(BG.getAllBgComponent(self)) do
        if v.update then
            v.update(v)
        elseif v.class.update then --这个兼容旧的update，更新完后可以删除
            v.class.update(v)
        end
    end
end
--组件渲染模块
function BG:bgComponentRender()
    for _, v in ipairs(BG.getAllBgComponent(self)) do
        if v.draw then
            v.draw(v)
        elseif v.class.draw then --这个兼容旧的update，更新完后可以删除
            v.class.draw(v)
        end
    end
end
--清理渲染平面模块
function BG.clearRenderPlane()
    SetImageState("white", "", Color(255, 0, 0, 0))
    RenderRect("white", -192, 192, -224, 224)
    SetImageState("white", "", Color(255, 255, 255, 255))
end

--以背景贴图素材的读取类
local R = newSimpleClass()
M.ReadClass = R
do
    --构造方法
    function R.constructor(self, stage_name, base_res_path)
        self.stage_name = stage_name
        self.folder_list = {}
        self.base_res_path = base_res_path
    end

    --
    function R.loadBgImgFromFile(self, folder_name, file_name_list)
        --folder_name = "part2"
        --file_name_list = {"cloud1", "cloud2", "cloud3", "ground", "moon", "sky"}
        local stage_name = self:getStageName()
        local base_res_path = self:getBaseResPath()
        --转化为固定背景素材格式的命名
        local img_name, path
        for i = 1, #file_name_list do
            img_name = string.format("%s_%s_%s", stage_name, folder_name, file_name_list[i])
            --SystemLog("<load_test>img_name:"..img_name)
            path = string.format("%s%s/%s.png", base_res_path, folder_name, file_name_list[i])
            --SystemLog("<load_test>path:"..path)
            LoadImageFromFile(img_name, path)
            R.addToList(self, folder_name, file_name_list[i])
        end
    end

    function R.loadBgAniFromFile(self, folder_name, file_name_list)
        --folder_name = "part2"
        --file_name_list = {{"cloud1", n, m, intv}}
        local stage_name = self:getStageName()
        local base_res_path = self:getBaseResPath()
        --转化为固定背景素材格式的命名
        local img_name, path
        for i = 1, #file_name_list do
            img_name = string.format("%s_%s_%s", stage_name, folder_name, file_name_list[i][1])
            --SystemLog("<load_test>img_name:"..img_name)
            path = string.format("%s%s/%s.png", base_res_path, folder_name, file_name_list[i][1])
            --SystemLog("<load_test>path:"..path)
            LoadAniFromFile(img_name, path, false, file_name_list[i][2], file_name_list[i][3], file_name_list[i][4])
            R.addToList(self, folder_name, file_name_list[i][1])
        end
    end

    function R.getImg(self, folder_name, file_name)
        --检测是否存在
        R.checkFileIsValid(self, folder_name, file_name)
        return string.format("%s_%s_%s", self:getStageName(), folder_name, file_name)
    end

    function R.addToList(self, folder_name, file_name)
        if not self.folder_list[folder_name] then
            self.folder_list[folder_name] = {}
        end
        table.insert(self.folder_list[folder_name], file_name)
    end

    function R.checkFileIsValid(self, folder_name, file_name)
        if not self.folder_list[folder_name] then
            error(string.format("Nonexistent folder name '%s'", folder_name))
        else
            local flag = false
            for _, s in pairs(self.folder_list[folder_name]) do
                if(s==file_name) then
                    flag = true
                    break
                end
            end
            if not flag then
                error(string.format("Nonexistent filename '%s' where folder name '%s'", file_name, folder_name))
            end
        end
    end

    --getter and setter
    function R:getStageName()
        return self.stage_name
    end
    function R:getBaseResPath()
        return self.base_res_path
    end
end