---------------------
---一些常用的弹幕发射器
---------------------
local M = {}
EGGlib.BulletGroup = M
--发出复杂形状的弹幕
function M.mulShooter(x, y, v0, a0, way0, dv_w, layer, dway, dv_l, da_l, da0, dda0, func, ...)
    local v, a, da, way, center_way
    for i = 0, layer - 1 do  --每一层弹幕
        way = way0 + i*dway - 1
        center_way = way/2
        da = da0 + dda0*i
        for j = 0, way do  --每一way弹幕
            v = v0 - dv_w*abs(j-center_way) + dv_l*i
            a = a0 + da*(j-center_way) + da_l*i
            func(x, y, v, a, ...)
        end
    end
end

--发出梯形形状的弹幕
function M.Trapezoid(x, y, v0, dv, a0, da0, way0, layer, func, ...)
    M.mulShooter(x, y, v0, a0, way0, 0, layer, 1, dv, 0, da0, 0, func, ...)
end

--发出三角形状的弹幕
function M.TriAngle(x, y, v0, dv, a0, da0, layer, func, ...)
    M.Trapezoid(x, y, v0, dv, a0, da0, 1, layer, func, ...)
end

--region 三角形描边
do
    local T = {} --type
    M.TriAngleStroke = T

    --发出三角形挖去中间部分只留下轮廓的弹幕
    function T.normal1(x, y, v0, dv, a0, da0, layer, func, ...)
        layer = layer - 1
        for i = -layer, layer do
            func(x, y, v0 + dv*abs(i), a0 + da0*i, ...)
        end
    end

    --通过规定扩散角的方法来发射上述形状
    function T.normal2(x, y, v0, dv, a0, sp, layer, func, ...)
        local da0 = sp/(2*layer - 2)
        T.normal1(x, y, v0, dv, a0, da0, layer, func, ...)
    end

    --发一圈这样的三角形描边弹(way与way间不会重合)
    function T.circle1(x, y, v0, dv, a0, layer, way, func, ...)
        local da = 360/way
        local da1 = da/layer
        for i = 0, way - 1 do
            T.normal1(x, y, v0, dv, a0 + da*i, da1, layer, func, ...)
        end
    end

    --发一圈这样的三角形描边弹(way与way间最边缘的子弹会重合的)
    function T.circle2(x, y, v0, dv, a0, layer, way, func, ...)
        local sp = 360/way
        for i = 0, way - 1 do
            T.normal2(x, y, v0, dv, a0 + sp*i, 0.5*sp, layer, func, ...)
        end
    end

    --发一圈这样的三角形描边弹(way数与三角形本身的形状独立, da发射)
    function T.circle3(x, y, v0, dv, a0, da0, layer, way, func, ...)
        local da = 360/way
        for i = 0, way - 1 do
            T.normal1(x, y, v0, dv, a0 + da*i, da0, layer, func, ...)
        end
    end

    --发一圈这样的三角形描边弹(way数与三角形本身的形状独立, sp发射)
    function T.circle4(x, y, v0, dv, a0, sp, layer, way, func, ...)
        local da = 360/way
        for i = 0, way - 1 do
            T.normal2(x, y, v0, dv, a0 + da*i, sp, layer, func, ...)
        end
    end

    --发好几层三角形描边弹
    function T.layer1(x, y, v0, dv, a0, da0, layer, layer2, dv_l2, da_l2, func, ...)
        for i = 0, layer2 - 1 do
            T.normal1(x, y, v0 + dv_l2*i, dv, a0 + da_l2*i, da0, layer, func, ...)
        end
    end

    --上面方法的第二种形式
    function T.layer2(x, y, v0, dv, a0, sp, layer, layer2, dv_l2, da_l2, func, ...)
        for i = 0, layer2 - 1 do
            T.normal2(x, y, v0 + dv_l2*i, dv, a0 + da_l2*i, sp, layer, func, ...)
        end
    end

    --发好几层好几圈这样的(way不分离，way与way间边缘子弹不会重合
    function T.circleLayer1(x, y, v0, dv, a0, layer, way, layer2, dv_l2, da_l2, dway, func, ...)
        local da, da0
        for j = 0, layer2 - 1 do
            da = 360/way
            da0 = da/layer
            for i = 0, way - 1 do
                T.normal1(x, y, v0 + dv_l2*j, dv, a0 + da*i + da_l2*j, da0, layer, func, ...)
            end
            way = way + dway
        end
    end

    --发好几层好几圈这样的(way不分离，way与way间边缘子弹会重合
    function T.circleLayer2(x, y, v0, dv, a0, layer, way, layer2, dv_l2, da_l2, dway, func, ...)
        local da, sp
        for j = 0, layer2 - 1 do
            da = 360/way
            sp = da
            for i = 0, way - 1 do
                T.normal2(x, y, v0 + dv_l2*j, dv, a0 + da*i + da_l2*j, sp, layer, func, ...)
            end
            way = way + dway
        end
    end

    --发好几层好几圈这样的(way分离，da发射
    function T.circleLayer3(x, y, v0, dv, a0, da0, layer, way, layer2, dv_l2, da_l2, dway, func, ...)
        local da
        for j = 0, layer2 - 1 do
            da = 360/way
            for i = 0, way - 1 do
                T.normal1(x, y, v0 + dv_l2*j, dv, a0 + da*i + da_l2*j, da0, layer, func, ...)
            end
            way = way + dway
        end
    end

    --发好几层好几圈这样的(way分离，sp发射
    function T.circleLayer4(x, y, v0, dv, a0, sp, layer, way, layer2, dv_l2, da_l2, dway, func, ...)
        local da
        for j = 0, layer2 - 1 do
            da = 360/way
            for i = 0, way - 1 do
                T.normal2(x, y, v0 + dv_l2*j, dv, a0 + da*i + da_l2*j, sp, layer, func, ...)
            end
            way = way + dway
        end
    end
end
--endregion

--region 扇形子弹（a在中间
do
    local T = {} --type
    M.Sector = T
    --发射一层扇形子弹（da发射
    function T.normal1(x, y, v, a, way, da, func)
        way = (way - 1)/2
        for i = -way, way do
            func(x, y, v, a + da*i)
        end
    end
    --发射一层扇形子弹（sp发射
    function T.normal2(x, y, v, a, way, sp, func)
        local da
        if way == 1 then
            da = 0
        else
            da = sp/(way - 1)
        end
        T.normal1(x, y, v, a, way, da, func)
    end

    --发射一扇(da扇，da发射
    function T.sector1(x, y, v, a, way, da, way1, da1, func)
        way1 = (way1 - 1)/2
        for i = -way1, way1 do
            T.normal1(x, y, v, a + i*da1, way, da, func)
        end
    end

    --发射一扇(da扇，sp发射
    function T.sector2(x, y, v, a, way, sp, way1, da1, func)
        way1 = (way1 - 1)/2
        for i = -way1, way1 do
            T.normal2(x, y, v, a + i*da1, way, sp, func)
        end
    end

    --发射一扇(sp扇，da发射
    function T.sector3(x, y, v, a, way, da, way1, sp1, func)
        local da1 = sp1*(way1 - 1)
        way1 = (way1 - 1)/2
        for i = -way1, way1 do
            T.normal1(x, y, v, a + i*da1, way, da, func)
        end
    end

    --发射一扇(sp扇，sp发射
    function T.sector4(x, y, v, a, way, sp, way1, sp1, func)
        local da1 = sp1*(way1 - 1)
        way1 = (way1 - 1)/2
        for i = -way1, way1 do
            T.normal2(x, y, v, a + i*da1, way, sp, func)
        end
    end

    --发射一圈(da发射
    function T.circle1(x, y, v, a, way, da, way1, func)
        local da0 = 360/way1
        for i = 0, way1 - 1 do
            T.normal1(x, y, v, a + i*da0, way, da, func)
        end
    end

    --发射一圈（sp发射
    function T.circle2(x, y, v, a, way, sp, way1, func)
        local da0 = 360/way1
        for i = 0, way1 - 1 do
            T.normal2(x, y, v, a + i*da0, way, sp, func)
        end
    end

    --发射几层(da发射
    function T.layer1(x, y, v, a, way, da, layer, dv_l, da_l, func)
        for i = 0, layer - 1 do
            T.normal1(x, y, v + dv_l*i, a + da_l*i, way, da, func)
        end
    end

    --发射几层(sp发射
    function T.layer2(x, y, v, a, way, sp, layer, dv_l, da_l, func)
        for i = 0, layer - 1 do
            T.normal2(x, y, v + dv_l*i, a + da_l*i, way, sp, func)
        end
    end

    --发射几层(da发射 dway
    function T.layer3(x, y, v, a, way, da, layer, dv_l, da_l, dway, func)
        for i = 0, layer - 1 do
            T.normal1(x, y, v + dv_l*i, a + da_l*i, way + dway*i, da, func)
        end
    end

    --发射几层(sp发射 dway
    function T.layer4(x, y, v, a, way, sp, layer, dv_l, da_l, dway, func)
        for i = 0, layer - 1 do
            T.normal2(x, y, v + dv_l*i, a + da_l*i, way + dway*i, sp, func)
        end
    end

    --发射几扇几层（da扇,da发射
    function T.sectorLayer1(x, y, v, a, way, da, way1, da_w, layer, dv_l, da_l, dway1, func)
        way1 = (way1 - 1)/2
        for j = 0, layer - 1 do
            for i = -way1, way1 do
                T.normal1(x, y, v + dv_l*j, a + da_w*i + da_l*j, way + dway1*j, da, func)
            end
        end
    end

    --发射几扇几层（da扇，sp发射
    function T.sectorLayer2(x, y, v, a, way, sp, way1, da_w, layer, dv_l, da_l, dway1, func)
        way1 = (way1 - 1)/2
        for j = 0, layer - 1 do
            for i = -way1, way1 do
                T.normal2(x, y, v + dv_l*j, a + da_w*i + da_l*j, way + dway1*j, sp, func)
            end
        end
    end

    --发射几扇几层（sp扇,da发射
    function T.sectorLayer3(x, y, v, a, way, da, way1, sp_w, layer, dv_l, da_l, dway1, func)
        local da0 = sp_w/(way1 - 1)
        way1 = (way1 - 1)/2
        for j = 0, layer - 1 do
            for i = -way1, way1 do
                T.normal1(x, y, v + dv_l*j, a + da0*i + da_l*j, way + dway1*j, da, func)
            end
        end
    end

    --发射几扇几层（sp扇，sp发射
    function T.sectorLayer4(x, y, v, a, way, sp, way1, sp_w, layer, dv_l, da_l, dway1, func)
        local da0 = sp_w/(way1 - 1)
        way1 = (way1 - 1)/2
        for j = 0, layer - 1 do
            for i = -way1, way1 do
                T.normal2(x, y, v + dv_l*j, a + da0*i + da_l*j, way + dway1*j, sp, func)
            end
        end
    end

    --发射几圈几层（da发射
    function T.circleLayer1(x, y, v, a, way, da, way1, layer, dv_l, da_l, dway1, func)
        local da0
        for j = 0, layer - 1 do
            da0 = 360/way1
            for i = 0, way1 - 1 do
                T.normal1(x, y, v + dv_l*j, a + da0*i + da_l*j, way + dway1*j, da, func)
            end
        end
    end

    --发射几圈几层（sp发射
    function T.circleLayer2(x, y, v, a, way, sp, way1, layer, dv_l, da_l, dway1, func)
        local da0
        for j = 0, layer - 1 do
            da0 = 360/way1
            for i = 0, way1 - 1 do
                T.normal2(x, y, v + dv_l*j, a + da0*i + da_l*j, way + dway1*j, sp, func)
            end
        end
    end
end
--endregion

--region 串形、弧形子弹
do
    local T = {}
    M.Curve = T
    --弧形（da不同，dv同）
    function T.normal1(x, y, v, a, bunch, da, func)
        for i = 0, bunch - 1 do
            func(x, y, v, a + da*i)
        end
    end
    --弧形(sp不同，dv同）
    function T.normal2(x, y, v, a, bunch, sp, func)
        local da = sp/(bunch - 1)
        T.normal2(x, y, v, a, bunch, da, func)
    end
    --前两种之和（da dv都不同）
    function T.normalDv1(x, y, v, a, bunch, dv, da, func)
        for i = 0, bunch - 1 do
            func(x, y, v + dv*i, a + da*i)
        end
    end
    --前两种之和（sp dv都不同）
    function T.normalDv2(x, y, v, a, bunch, dv, sp, func)
        local da = sp/(bunch - 1)
        T.normalDv1(x, y, v, a, bunch, dv, da, func)
    end

    --好几层(da发射, 弧形的v是相同的，da始终不变）
    function T.layer1(x, y, v, a, bunch, da, layer, dv_l, da_l, d_bunch, func)
        for i = 0, layer - 1 do
            T.normal1(x, y, v + dv_l*i, a + da_l*i, bunch + d_bunch*i, da, func)
        end
    end

    --好几层(da发射, 弧形的v是不同的，da始终不变）
    function T.layerDv1(x, y, v, a, bunch, dv, da, layer, dv_l, da_l, d_bunch, func)
        for i = 0, layer - 1 do
            T.normalDv1(x, y, v + dv_l*i, a + da_l*i, bunch + d_bunch*i, dv, da, func)
        end
    end

    --好几层(da发射, 弧形的v是相同的，da会变）
    function T.layer2(x, y, v, a, bunch, da, layer, dv_l, da_l, d_bunch, func)
        local sp = da*(layer - 1)
        T.layer3(x, y, v, a, bunch, sp, layer, dv_l, da_l, d_bunch, func)
    end

    --好几层(da发射, 弧形的v是不同的，da会变）
    function T.layerDv2(x, y, v, a, bunch, dv, da, layer, dv_l, da_l, d_bunch, func)
        local sp = da*(layer - 1)
        T.layerDv3(x, y, v, a, bunch, dv, sp, layer, dv_l, da_l, d_bunch, func)
    end

    --好几层(sp发射, 弧形的v是相同的，sp始终不变）
    function T.layer3(x, y, v, a, bunch, sp, layer, dv_l, da_l, d_bunch, func)
        for i = 0, layer - 1 do
            T.normal2(x, y, v + dv_l*i, a + da_l*i, bunch + d_bunch*i, sp, func)
        end
    end

    --好几层(sp发射, 弧形的v是不同的，sp始终不变）
    function T.layerDv3(x, y, v, a, bunch, dv, sp, layer, dv_l, da_l, d_bunch, func)
        for i = 0, layer - 1 do
            T.normalDv2(x, y, v + dv_l*i, a + da_l*i, bunch + d_bunch*i, dv, sp, func)
        end
    end

    --好几层(sp发射, 弧形的v是相同的，sp会变）
    function T.layer4(x, y, v, a, bunch, sp, layer, dv_l, da_l, d_bunch, func)
        local da = sp/(bunch-1)
        T.layer1(x, y, v, a, bunch, da, layer, dv_l, da_l, d_bunch, func)
    end

    --好几层(sp发射, 弧形的v是不同的，sp会变）
    function T.layerDv4(x, y, v, a, bunch, dv, sp, layer, dv_l, da_l, d_bunch, func)
        local da = sp/(bunch-1)
        T.layerDv1(x, y, v, a, bunch, dv, da, layer, dv_l, da_l, d_bunch, func)
    end
end
--endregion

--region 开花弹（最基础的形状
do
    local T = {}
    M.Circle = T
    function T.normal1(x, y, v, a, way, func)
        local da = 360/way
        for i = 0, way - 1 do
            func(x, y, v, a + i*da)
        end
    end
    --多层开花
    function T.layer1(x, y, v, a, way, layer, dv, da, dway, func)
        for i = 0, layer - 1 do
            T.normal1(x, y, v + dv*i, a + da*i, way + dway*i, func)
        end
    end
end
--endregion
function M.flowerShooter(x, y, v0, a0, way0, da_w, layer, dway, dv_l, func, ...)
    local v, a, da, way
    for i = 0, layer - 1 do  --每一层弹幕
        way = way0 + i*dway - 1
        da = 360/(way+1)
        v = v0 + dv_l*i
        for j = 0, way do  --每一way弹幕
            a = a0 + da*j + da_w*i
            func(x, y, v, a, ...)
        end
    end
end

--多层但是角度一致的开花弹
function M.equalAngleFlowerShooter(x, y, v0, dv_l, a0, way0, layer, func, ...)
    M.flowerShooter(x, y, v0, a0, way0, 0, layer, 0, dv_l, func, ...)
end

--单层开花弹
function M.singleFlowerShooter(x, y, v0, a0, way0, func, ...)
    M.flowerShooter(x, y, v0, a0, way0, 0, 1, 0, 0, func, ...)
end


--一串长条弹
function M.bunch(x, y, layer, v0, dv, a0, da, func, ...)
    for i = 0, layer - 1 do  --每一层弹幕
        func(x, y, v0 + dv*i, a0 + da*i, ...)
    end
end
--角度相同一单层长条弹
function M.straightBunch(x, y, layer, v0, dv, a0, func, ...)
    M.bunch(x, y, layer, v0, dv, a0, 0, func, ...)
end


--多边形全方位弹幕(默认多边形尖的一端为a的方向）
---@param v0 number 处于角的那一颗弹幕的速度（即最快速度）
---@param n number 边数，至少为3
---@param l number 每一边应该要有的弹幕数
function M.polygon1(x, y, v0, a, n, l, func)
    local da = 360/n
    local x0, y0, x1, y1
    local _v, _a
    local v = v0*cos(0.5*da) --获取最慢的弹幕的速度
    for j = 0, n - 1 do
        x0, y0 = cos(a + da*j), sin(a + da*j)
        x1, y1 = cos(a + da*(j + 1)), sin(a + da*(j + 1))
        for k = 0, l - 1 do
            _a = Angle(0, 0, x0 + (x1 - x0)*k/l, y0 + (y1 - y0)*k/l)
            _v = v/cos((k/l - 0.5)*da) --再根据角度差算回来
            func(x, y, _v, _a)
        end
    end
end


--多角形全方位弹幕(默认多边形尖的一端为a的方向）
---@param v0 number 处于角的那一颗弹幕的速度（即最快速度）
---@param n number 边数，至少为5
---@param l number 每一边应该要有的弹幕数
function M.polygon2(x, y, v0, a, n, l, func)
    local da = 720/n
    local x0, y0, x1, y1
    local _v, _a
    local v = v0*cos(0.5*da) --获取最慢的弹幕的速度
    for j = 0, n - 1 do
        x0, y0 = cos(a + da*j), sin(a + da*j)
        x1, y1 = cos(a + da*(j + 1)), sin(a + da*(j + 1))
        for k = 0, l - 1 do
            _a = Angle(0, 0, x0 + (x1 - x0)*k/l, y0 + (y1 - y0)*k/l)
            --_v = v/cos((k/l - 0.5)*da) --再根据角度差算回来 --这个会有很奇妙的形状233
            _v = v/cos(- _a + a + da*(j + 0.5))
            func(x, y, _v, _a)
        end
    end
end

--多边形相同朝向的弹幕（如本篇中一道中⑨的符卡弹幕）
---@param dsc number 初始距中心的距离
---@param dvc number 扩散速度（离开中心的相对速度）
---@param singleBulletFunc function 有返回值的单个弹幕生成函数
function M.polygon3(x, y, dsc, v, dvc, a, rot, n, singleBulletFunc)
    local vx, vy, dx, dy = v*cos(a), v*sin(a)
    local da_n = 360/n
    local obj
    for i = 0, n - 1 do
        dx, dy = cos(a + i*da_n + rot), sin(a + i*da_n + rot)
        obj = singleBulletFunc(x + dsc*dx, y + dsc*dy, 0, a)
        EGGlib.ObjectEvent.addV2(obj, vx + dvc*dx, vy + dvc*dy)
        obj.rot = a + rot
    end
end