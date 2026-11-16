---=====================================
---S7P自用事件库
---code by S7UPID
---=====================================

local M = {}
EGGlib.ObjectEvent = M

--引入其他包


--region 对象速度操作
--设置速度（与全局的SetV相比，它不止作用于lstg.object，也可以作用于任何table
function M.setV(o, v, a)
    o.vx = v*cos(a)
    o.vy = v*sin(a)
end
--叠加速度
function M.addV1(o, v, a)
    o.vx = o.vx + v*cos(a)
    o.vy = o.vy + v*sin(a)
end
function M.addV2(o, vx, vy)
    o.vx = o.vx + vx
    o.vy = o.vy + vy
end
function M.addV3(o, vx, vy, drot)
    vx, vy = EGGlib.Math.TranRot(vx, vy, drot)
    M.addV2(o, vx, vy)
end

--叠加加速度
function M.addA1(o, acc, a)
    o.ax = o.ax + acc*cos(a)
    o.ay = o.ay + acc*sin(a)
end
function M.addA2(o, ax, ay)
    o.ax = o.ax + ax
    o.ay = o.ay + ay
end
function M.addA3(o, ax, ay, drot)
    ax, ay = EGGlib.Math.TranRot(ax, ay, drot)
    M.addA2(o, ax, ay)
end

--立即停止运动
function M.stop(o)
    o.vx, o.vy, o.ax, o.ay = 0, 0, 0, 0
end
--------------以下事件只能单独进行，不可叠加，也不可以与可叠加的事件同时进行------------

--一个可以同时均匀改变速度大小和方向的事件
---@param o  object @目标对象
---@param v0 number 初速度
---@param v1 number 末速度
---@param a0 number 初始方向
---@param da number 方向变化总量
---@param tv number 速度大小变化时间
---@param ta number 速度方向变化时间
---@param navi boolean 朝向是否与运动方向一致
function M.changeVelocity(o, v0, v1, a0, da, tv, ta, navi)  --change v 同时改变速度大小和方向事件
    if navi then o.navi = true end
    local dv
    dv, da = (v1 - v0) / tv, da / ta
    if tv > ta then
        for _ = 1, ta do
            v0 = v0 + dv
            a0 = a0 + da
            M.setV(o, v0, a0)
            task.Wait(1)
        end
        for _ = ta, tv do
            v0 = v0 + dv
            M.setV(o, v0, a0)
            task.Wait(1)
        end
    else
        for _ = 1, tv do
            v0 = v0 + dv
            a0 = a0 + da
            M.setV(o, v0, a0)
            task.Wait(1)
        end
        for _ = tv, ta do
            a0 = a0 + da
            M.setV(o, v0, a0)
            task.Wait(1)
        end
    end
end

function M.changeVelocityTask(o, v0, v1, a0, da, tv, ta, navi)
    task.New(o, function()
        M.changeVelocity(o, v0, v1, a0, da, tv, ta, navi)
    end)
end
    --在已有速度状态的情况下改变速度大小和方向
function M.addChangeVelocity(o, dv, da, tv, ta, navi)
    local v, a = Dist(0, 0, o.vx, o.vy), Angle(0, 0, o.vx, o.vy)
    M.changeVelocity(o, v, v + dv, a, da, tv, ta, navi)
end

--简易的改变速度方向事件
function M.angleChange(o, v0, a0, da, t0, navi)
    if navi then o.navi = true end
    da = da/t0
    for _ = 1, t0 do
        a0 = a0 + da
        M.setV(o, v0, a0)
        task.Wait(1)
    end
end
--在已有的速度状态的基础上改变速度方向
function M.addAngleChange(o, da, t0, navi)
    local v, a = Dist(0, 0, o.vx, o.vy), Angle(0, 0, o.vx, o.vy)
    M.angleChange(o, v, a, da, t0, navi)
end
--直线变速运动（先给予一个初速度再等待t1之后再运动）
function M.velocityChange(o, v0, v1, a0, t0, t1)
    t1 = t1 or 0
    local dv = (v1 - v0)/t0
    M.addV1(o, v0, a0)
    task.Wait(t1)
    M.addA1(o, dv, a0)
    task.Wait(t0)
    M.addA1(o, -dv, a0)
end
--上一个运动的task形式
function M.velocityChangeTask(o, v0, v1, a0, t0, t1)
    task.New(o, function()
        M.velocityChange(o, v0, v1, a0, t0, t1)
    end)
end
--改变速度方向事件的反向运动逻辑
function M.oppoVelocityChange(o, v0, v1, a0, t0, t1)
    t1 = t1 or 0
    local s = v0*t1 + t0*(v0 + v1)/2
    o.x, o.y = o.x - s*cos(a0), o.y - s*sin(a0)
    M.velocityChange(o, v0, v1, a0, t0, t1)
end
function M.oppoVelocityChangeTask(o, v0, v1, a0, t0, t1)
    task.New(o, function()
        M.oppoVelocityChange(o, v0, v1, a0, t0, t1)
    end)
end

--从0开始先加速后减速
local function accDecVelocityChange(o, v, a, t1, wt, t2)
    v = v or 0
    a = a or 0
    t1 = t1 or 1 --变速时间
    wt = wt or 0 --匀速持续时间
    t2 = t2 or t1
    local dv = v/t1
    M.addA1(o, dv, a)
    task.Wait(t1)
    M.addA1(o, -dv, a)
    task.Wait(wt)
    dv = v/t2
    M.addA1(o, -dv, a)
    task.Wait(t2)
    M.addA1(o, dv, a)
end
function M.accDecVelocityChange(o, v, a, t1, wt, t2)
    accDecVelocityChange(o, v, a, t1, wt, t2)
end

function M.accDecVelocityChangeTask(o, v, a, t1, wt, t2)
    task.New(o, function()
        accDecVelocityChange(o, v, a, t1, wt, t2)
    end)
end

--二维的从0开始先加速后减速
---@param isTask boolean 是否为task， 默认否
function M.accDecVelocityChange2(o, vx, a, wt, tx0, tx1, tx2, dt, vy, u, ty0, ty1, ty2, isTask)
    task.New(o, function()
        M.setV(o, vx, a)
        task.Wait(wt) --匀速时间
        M.accDecVelocityChangeTask(o, -2*vx, a, tx0, tx1, tx2)
        task.Wait(dt)
        M.accDecVelocityChangeTask(o, vy, a + 90*u, ty0, ty1, ty2)
    end)
    if not isTask then
        task.Wait(max(tx0 + tx1 + tx2, ty0 + ty1 + ty2))
    end
end

--简易的抛物线事件
function M.simPar(o, v, va, acc, acca)
    M.addV1(o, v, va)
    M.addA1(o, acc, acca)
end

--以抛物线的形式简单移动len距离
function M.moveLengthWithPar(o, len, vy, a, t, u)
    M.addV1(o, len/t, a)
    local acc = -2*vy/t
    M.simPar(o, vy, a + 90*u, acc, a + 90*u)
    task.Wait(t)
    --t帧后恢复
    M.addV1(o, -len/t, a)
    M.simPar(o, vy, a + 90*u, -acc, a + 90*u)
end

--以抛物线的形式移到某处
function M.movePointWithPar(o, x, y, vy, t, u)
    local dx, dy = x - o.x, y - o.y
    local len, a = Dist(0, 0, dx, dy), Angle(0, 0, dx, dy)
    M.moveLengthWithPar(o, len, vy, a, t, u)
end

--先后退t2时间，以抛物线的一半的形式在t1时间移动到接近x,y，在这里，vx轴方向为a方向，vy轴方向为垂直于a的方向，移动完成后可以设置惯性时间t1
--（后退t2时间所走的位移与最后惯性前进t1时间所走的位移之和刚好是0）
---@param vy number 竖直方向的初速度
---@param a number 抛向的角度，0度为平抛
---@param t0 number 抛物线运动走的时间
---@param t1 number 抛物线运动结束后的惯性减速时间
---@param t2 number 抛物线运动开始前的反向运动并加速时间(注：小于2意味着取消后退这个动作，直接进行抛物线移动，此后如果t1>0，最终会因为惯性减速原因不会精准到达x, y点
---@param t3 number t2有效时，返向运动结束时会停留t3时间
function M.halfMoveLengthWithPar(o, x, y, vy, a, t0, t1, t2, t3)
    t3 = t3 or 0
    local ax
    local dx, dy = x - o.x, y - o.y
    dx, dy = EGGlib.Math.TranRot(dx, dy, -a)
    local vx, ay = dx/t0, 2*dy/t0/t0 - vy/t0
    vx, vy = EGGlib.Math.TranRot(vx, 0, a)
    ax, ay = EGGlib.Math.TranRot(0, ay, a)
    local vxm, vym = vx + ax*t0, vy + ay*t0 --最终速度
    if t2 >= 2 then --注意：t2小于2意味着取消后退这个动作，直接进行抛物线移动，此后如果t1>0，最终会因为惯性减速原因不会精准到达x, y点
        t2 = math.floor(t2/2)
        --要走的路程 sx = vx*t2-0.5*vxm*t1  sy = vy*t2-0.5*vym*t1
        local dvx, dvy = (-vxm*t1/(2*t2))/t2, (-vym*t1/(2*t2))/t2
        M.addA2(o, dvx, dvy)
        task.Wait(t2) --加速
        M.addA2(o, -2*dvx, -2*dvy)
        task.Wait(t2) --减速到0
        M.addA2(o, dvx, dvy)
        --加速度置0，此时已经反向走了sx和sy
        task.Wait(t3)
    end
    M.addV2(o, vx, vy)
    M.addA2(o, ax, ay)
    task.Wait(t0) --抛物线运动t0
    M.addA2(o, -ax, -ay) --把原先的加速度撤去
    M.addA2(o, -vxm/t1, -vym/t1) --开始在t1时间减速到0
    task.Wait(t1) --剩下的惯性运动时间
    M.addA2(o, vxm/t1, vym/t1)
end
function M.halfMoveLengthWithParTask(o, x, y, vy, a, t0, t1, t2)
    task.New(o, function()
        M.halfMoveLengthWithPar(o, x, y, vy, a, t0, t1, t2)
    end)
end

--先减速后加速式运动
function M.decAccVelocityChange(obj, v0, v1, v2, a, wt, t0, t1, t2)
    M.addV1(obj, v0, a)
    task.Wait(wt) --先匀速
    local acc = (v1 - v0)/t0
    M.addA1(obj, acc, a)
    task.Wait(t0) --减速
    M.addA1(obj, -acc, a)
    task.Wait(t1) --匀速
    acc = (v2 - v1)/t2
    M.addA1(obj, acc, a)
    task.Wait(t2) --加速
    M.addA1(obj, -acc, a)
end

--在t时间内以一定紧密度p追踪目标(不可叠加
---@param o table 执行事件的对象
---@param target table 被追踪的对象
---@param dv number 此期间的速度变化
---@param t number 追踪时间
---@param p number 追踪强度
---@param conditionFunc function 返回true和false的判断条件
function M.aimToTarget(o, target, dv, t, p, conditionFunc)
    conditionFunc = conditionFunc or function() return true end
    dv = dv/t --求每帧自身方向与自身和目标方向角度的差值
    local v, a, da = Dist(0, 0, o.vx, o.vy), Angle(0, 0, o.vx, o.vy)
    for _ = 1, t do
        if IsValid(target) and conditionFunc(o, target) then
            da = (Angle(o.x, o.y, target.x, target.y) - a) % 360
            if da > 180 then
                da = da -360
            end
            a = a + da * p
            v = v + dv
            M.setV(o, v, a)
        else
            break
        end
        task.Wait(1)
    end
end
function M.aimToTargetTask(o, target, dv, t, p)
    task.New(o, function()
        M.aimToTarget(o, target, dv, t, p)
    end)
end

--上面的target替换成点了
function M.aimToPoint(o, x, y, dv, t, p, conditionFunc)
    conditionFunc = conditionFunc or function() return true end
    dv = dv/t --求每帧自身方向与自身和目标方向角度的差值
    local v, a, da = Dist(0, 0, o.vx, o.vy), Angle(0, 0, o.vx, o.vy)
    for _ = 1, t do
        if conditionFunc(o, x, y) then
            da = (Angle(o.x, o.y, x, y) - a) % 360
            if da > 180 then
                da = da -360
            end
            a = a + da * p
            v = v + dv
            M.setV(o, v, a)
        else
            break
        end
        task.Wait(1)
    end
end
function M.aimToPointTask(o, x, y, dv, t, p, conditionFunc)
    task.New(o, function()
        M.aimToPoint(o, x, y, dv, t, p, conditionFunc)
    end)
end

--停止当前速度
function M.stopV(o, t0)
    local v, a = GetV(o)
    o.ax, o.ay = 0, 0
    M.addA1(o, -v/t0, a)
    task.Wait(t0)
    M.addA1(o, v/t0, a)
end

--渐开线运动
function M.involuteMove(o, x, y, r0, dr, a0, da, t)
    t = t or _infinite
    for _ = 1, t do
        r0 = r0 + dr
        a0 = a0 + da
        o.x, o.y = x + r0*cos(a0), y + r0*sin(a0)
        task.Wait(1)
    end
end
function M.involuteMoveTask(o, x, y, r0, dr, a0, da, t)
    task.New(o, function()
        M.involuteMove(o, x, y, r0, dr, a0, da, t)
    end)
end

--给定位移s，角度a，加速时间、匀速时间、减速时间，构造一个加速-匀速-减速向a方向位移s长度的运动方式
function M.accDecDisplacement(o, s, a, t0, t1, t2)
    local v = s/((t0 + t2)/2 + t1)
    local acc0, acc2 = v/t0, -v/t2
    M.addA1(o, acc0, a)
    task.Wait(t0) --加速
    M.addA1(o, -acc0, a)
    task.Wait(t1) --匀速
    M.addA1(o, acc2, a)
    task.Wait(t2) --减速
    M.addA1(o, -acc2, a)
end
function M.accDecDisplacementTask(o, s, a, t0, t1, t2)
    task.New(o, function()
        M.accDecDisplacement(o, s, a, t0, t1, t2)
    end)
end

--加速-匀速-减速位移到某点的运动方式
function M.accDecMoveToPoint(o, x, y, t0, t1, t2)
    local s, a = Dist(o.x, o.y, x, y), Angle(o.x, o.y, x, y)
    M.accDecDisplacement(o, s, a, t0, t1, t2)
end
function M.accDecMoveToPointTask(o, x, y, t0, t1, t2)
    task.New(o, function()
        M.accDecMoveToPoint(o, x, y, t0, t1, t2)
    end)
end

--往一个方向加速匀速减速移动s，再加速匀速减速移动回来
function M.accDecDisplacementAndReturn(o, s, a, tg0, tg1, tg2, tr0, tr1, tr2)
    M.accDecDisplacement(o, s, a, tg0, tg1, tg2)
    M.accDecDisplacement(o, -s, a, tr0, tr1, tr2)
end
function M.accDecDisplacementAndReturnTask(o, s, a, tg0, tg1, tg2, tr0, tr1, tr2)
    task.New(o, function()
        M.accDecDisplacementAndReturn(o, s, a, tg0, tg1, tg2, tr0, tr1, tr2)
    end)
end

--加速下落事件
function M.setGravityAndMinV(o, ay, vymin)
    o.ay = ay
    while o.vy + ay > vymin do
        task.Wait(1)
    end
    o.vy = vymin
    o.ay = 0
end

function M.setGravityAndMinVTask(o, ay, vymin)
    task.New(o, function()
        M.setGravityAndMinV(o, ay, vymin)
    end)
end
--endregion

--region argb变化
function M.setAlpha(o, alpha)
    o._a = alpha
end
function M.addAlpha(o, dalpha)
    o._a = o._a + dalpha
end
function M.setRGB(o, r, g, b)
    o._r, o._g, o._b = r, g, b
end
function M.setARGB(o, a, r, g, b)
    M.setAlpha(o, a)
    M.setRGB(o, r, g, b)
end
--透明度均匀变化事件
function M.alphaChange(o, alpha0, alpha1, t0, colli0, colli1)
    if not o._blend then
        robject.set_color(o, "", 255, 255, 255, 255)
    end
    o._a = alpha0
    t0 = t0 or 60
    local dalp = (alpha1 - alpha0)/t0
    if colli0 ~= nil then o.colli = colli0 end
    for _ = 1, t0 do
        o._a = o._a + dalp
        task.Wait(1)
    end
    if colli1 ~= nil then o.colli = colli1 end
end
function M.alphaChangeTask(o, alpha0, alpha1, t0, colli0, colli1)
    if not o._blend then
        robject.set_color(o, "", 255, 255, 255, 255)
    end
    o._a = alpha0
    t0 = t0 or 60
    local dalp = (alpha1 - alpha0)/t0
    if colli0 ~= nil then o.colli = colli0 end
    task.New(o,function ()
        for _ = 1, t0 do
            o._a = o._a + dalp
            task.Wait(1)
        end
        if colli1 ~= nil then o.colli = colli1 end
    end)
end

--透明度从0变到满，且判定从无变到有
function M.appearByAlpha(o, t, isnChangeColli)
    t = t or 30
    if isnChangeColli then
        M.alphaChange(o, 0, 255, t, o.colli, o.colli)
    else
        M.alphaChange(o, 0, 255, t, false, true)
    end
end
function M.appearByAlphaTask(o, t, isnChangeColli)
    t = t or 30
    if isnChangeColli then
        M.alphaChangeTask(o, 0, 255, t, o.colli, o.colli)
    else
        M.alphaChangeTask(o, 0, 255, t, false, true)
    end
end

--消失
function M.disappearByAlpha(o, t)
    t = t or 30
    M.alphaChange(o, o._a, 0, t, false, true)
end
function M.disappearByAlphaTask(o, t)
    t = t or 30
    M.alphaChangeTask(o, o._a, 0, t, false, true)
end

--特殊颜色渐入效果
function M.argbChange(o, a, r, g, b, t, colli0, colli1)
    robject.set_color(o, o._blend or "", a, r, g, b)
    if colli0 ~= nil then o.colli = colli0 end
    local da, dr, dg, db = (255 - a)/t, (255 - r)/t, (255 - g)/t, (255 - b)/t
    task.New(o,function ()
        for _ = 1, t do
            o._a, o._r, o._g, o._b = o._a + da, o._r + dr, o._g + dg, o._b + db
            task.Wait(1)
        end
        if colli1 ~= nil then o.colli = colli1 end
    end)
end

function M.argbChangeTask(o, a, r, g, b, t, colli0, colli1)
    task.New(o, function()
        M.argbChange(o, a, r, g, b, t, colli0, colli1)
    end)
end

--黑色渐入效果
function M.appearByBlack(o, t)
    M.argbChange(o, 0, 0, 0, 0, t, false, true)
end

--color都变成255
function M.argbChangeToMax(o, t)
    M.argbChange(o, o._a, o._r, o._g, o._b, t, false, true)
end
--endregion

--region size Colli变化
function M.setSize(obj, hscale, vscale)
    obj.hscale, obj.vscale = hscale, vscale
end
function M.setSizeAndColli(obj, hscale, vscale)
    obj.hscale, obj.vscale = hscale, vscale
    obj.a, obj.b = obj.a*math.abs(obj.hscale), obj.b*math.abs(obj.vscale)
end

function M.setColli(obj, colli_a, colli_b)
    obj.a, obj.b = math.max(0,colli_a), math.max(0,colli_b)
end
--贴图大小变化
function M.addSize(obj, dh, dv)
    obj.hscale, obj.vscale = obj.hscale + dh, obj.vscale + dv
end
function M.addColli(obj, dcolli_a, dcolli_b)
    obj.a, obj.b = math.max(0,obj.a+dcolli_a), math.max(0,obj.b+dcolli_b)
end

function M.hscaleAndVscaleChange(obj, dh, dv, t)
    dh, dv = dh/t, dv/t
    for _ = 1, t do
        M.addSize(obj, dh, dv)
        task.Wait(1)
    end
end

function M.hscaleAndVscaleChangeTask(obj, dh, dv, t)
    task.New(obj, function()
        M.hscaleAndVscaleChange(obj, dh, dv, t)
    end)
end

function M.hscaleAndVscaleAndColliChange(obj, dh, dv, t)
    dh, dv = dh/t, dv/t
    local dcolli_a, dcolli_b = dh*obj.a/obj.hscale, dv*obj.b/obj.vscale
    for _ = 1, t do
        M.addSize(obj, dh, dv)
        M.addColli(obj, dcolli_a, dcolli_b)
        task.Wait(1)
    end
end

function M.hscaleAndVscaleAndColliChangeTask(obj, dh, dv, t)
    task.New(obj, function()
        M.hscaleAndVscaleAndColliChange(obj, dh, dv, t)
    end)
end

--贴图大小变化事件
function M.sizeChange(obj, ds, t0)
    ds = ds/t0
    local rate = 1
    if obj.hscale ~= 0 and obj.vscale ~= 0 then
        rate = obj.vscale/obj.hscale
    end
    local dv = ds*rate
    for _ = 1, t0 do
        M.addSize(obj, ds, dv)
        task.Wait(1)
    end
end
function M.sizeChangeTask(obj, ds, t0)
    task.New(obj, function()
        M.sizeChange(obj, ds, t0)
    end)
end

--贴图大小和判定都跟着一起变化
function M.sizeAndColliChange(obj, ds, t0)
    ds = ds/t0
    local rate = 1
    if obj.hscale ~= 0 and obj.vscale ~= 0 then
        rate = obj.vscale/obj.hscale
    end
    local dv = ds*rate
    local dcolli_a, dcolli_b = ds*obj.a/obj.hscale, dv*obj.b/obj.vscale
    for _ = 1, t0 do
        M.addSize(obj, ds, dv)
        M.addColli(obj, dcolli_a, dcolli_b)
        task.Wait(1)
    end
end
function M.sizeAndColliChangeTask(obj, ds, t0)
    task.New(obj, function()
        M.sizeAndColliChange(obj, ds, t0)
    end)
end

--特殊的变大效果（先撑大后缩回来一些
function M.spSizeAndColliChange(obj, ds, dt, phase)
    ds = ds/dt/sin(phase)
    local h0, v0 = obj.hscale, obj.vscale
    local dp = phase/dt
    local s, size = 0
    phase = 0
    local rate = 1
    if obj.hscale ~= 0 and obj.vscale ~= 0 then
        rate = obj.vscale/obj.hscale
    end
    local dv = ds*rate
    local dcolli_a, dcolli_b = ds*obj.a/obj.hscale, dv*obj.b/obj.vscale
    local h_sign, v_sign = sign(h0), sign(v0)
    for _ = 1, dt do
        s = s + ds
        phase = phase + dp
        size = s*sin(phase)
        obj.hscale, obj.vscale = h0 + size*h_sign, v0 + size*v_sign
        M.addColli(obj, dcolli_a, dcolli_b)
        task.Wait(1)
    end
end

function M.spSizeAndColliChangeTask(obj, ds, dt, phase)
    task.New(obj, function()
        M.spSizeAndColliChange(obj, ds, dt, phase)
    end)
end
--endregion

--region argb和size同时操作
--大小与颜色状态
function M.setARGBAndSize(o, a, r, g, b, hscale, vscale, colli_a, colli_b)
    M.setARGB(o, a, r, g, b)
    M.setSize(o, hscale, vscale)
    M.setColli(o, colli_a or o.a, colli_b or o.b)
end

--同时变化
function M.alphaAndSizeChange(o, d_a, d_s, t0)
    d_a = d_a/t0
    local d_h = sign(o.hscale)
    local d_v = sign(o.vscale)
    if d_h == 0 then
        d_h = 1
    end
    if d_v == 0 then
        d_v = 1
    end
    d_h = d_s/t0*d_h
    d_v = d_s/t0*d_v
    for _ = 1, t0 do
        o._a = o._a + d_a
        o.hscale, o.vscale = o.hscale + d_h, o.vscale + d_v
        task.Wait(1)
    end
end
function M.alphaAndSizeChangeTask(o, d_a, d_s, t0)
    task.New(o, function()
        M.alphaAndSizeChange(o, d_a, d_s, t0)
    end)
end

--透明度和大小同时变化的消失效果
function M.disappear(o, t)
    M.alphaAndSizeChange(o, -o._a, -o.hscale, t)
end
function M.disappearTask(o, t)
    M.alphaAndSizeChangeTask(o, -o._a, -o.hscale, t)
end
--endregion

--判断某个对象是否在激光范围内
---@param w number 激光的宽度
---@param o table 参与检测的对象
function M.isInLaser(x, y, a, w, o)
    local world = lstg.world
    if lstg.BoxCheck(o, world.l - 50 - o.a, world.r + 50 + o.a, world.b - 50 - o.b, world.t + 50 + o.b) then --在屏幕外再向外延伸50个单位
        local a1 = a - Angle(x, y, o.x, o.y)
        if Dist(x, y, o.x, o.y) <= (o.a + o.b)/2 then --激光源就在单位的判定内部就直接判为是
            return true
        elseif a%180 == 90 then
            if abs(o.x - x)<((o.a + o.b + w)/2) and cos(a1) >= 0 then
                return true
            else
                return false
            end
        else
            local A = tan(a)
            local C = y - A*x
            if abs(A*o.x - o.y + C)/hypot(A,1)<((o.a + o.b + w)/2) and cos(a1) >= 0 then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end

--判断某个对象是否在激光范围内（另一种算法，且不检测屏幕外）
---@param w number 激光的宽度
---@param o table 参与检测的对象
function M.isInLaser2(o, x, y, a, l, w)
    w = 0.5*w
    local dx, dy = o.x - x, o.y - y
    dx, dy = EGGlib.Math.TranRot(dx, dy, -a)
    if dx >= 0 and dx <= l and dy >= -w and dy <= w then
        return true
    else
        return false
    end
end

--判断某个对象是否在矩形范围内
---@param l number 短形的长
---@param w number 矩形的宽
---@param o table 参与检测的对象
function M.isInRect(o, x, y, a, l, w)
    local dx, dy = o.x - x, o.y - y
    dx, dy = EGGlib.Math.TranRot(dx, dy, -a)
    if dx >= -0.5*l and dx <= 0.5*l and dy >= -0.5*w and dy <= 0.5*w then
        return true
    else
        return false
    end
end

--出屏设置
function M.boundWait(obj, t)
    obj.bound = false
    task.New(obj, function()
        task.Wait(t)
        obj.bound = true
    end)
end


--反弹
function M.rebound(self, count, times, func)
    local flag = 0
    local t = 0
    count = count or 1
    times = times or 99999
    while(t<times and flag<count) do
        if(self.x <= -192 or self.x >= 192) then
            self.vx = -self.vx
            flag = flag + 1
            if func then func(self) end --反弹时触发的函数，参数只限于传入对象本身
        elseif(self.y <= -224 or self.y >= 224) then
            self.vy = -self.vy
            flag = flag + 1
            if func then func(self) end
        end
        task.Wait(1)
        t = t + 1
    end
end

function M.reboundTask(self, count, times, func)
    task.New(self, function()
        M.rebound(self, count, times, func)
    end)
end

--碰了墙还会转得更快的傻吊反弹
local function sprebound(self, count, times, domiga, dv)
    local flag = 0
    local t = 0
    task.New(self, function()
        while(t<times and flag<count) do
            if(self.x <= -384 or self.x >= 384) then
                if self.x <= -384 then
                    dv = -abs(dv)
                else
                    dv = abs(dv)
                end
                self.vx = -self.vx + dv
                flag = flag + 1
                self.omiga = self.omiga + domiga
            elseif(self.y <= -448 or self.y >= 448) then
                if self.y <= -448 then
                    dv = -abs(dv)
                else
                    dv = abs(dv)
                end
                self.vy = -self.vy + dv
                flag = flag + 1
                self.omiga = self.omiga + domiga
            end
            t = t + 1
            task.Wait(1)
        end
    end)
end

--使转速均匀变化，可设置最值
function M.omigaChange(self, o0, o1, t1, t0)
    t0 = t0 or 0
    self.omiga = self.omiga + o0
    task.Wait(t0)
    local d = (o1 - o0)/t1
    for _ = 1, t1 do
        self.omiga = self.omiga + d
        task.Wait(1)
    end
end

function M.omigaChangeTask(self, o0, o1, t1, t0)
    task.New(self, function()
        M.omigaChange(self, o0, o1, t1, t0)
    end)
end

--正圆旋转(dr逻辑
---@param self object 对象本身
---@param mst object 要旋转跟随的目标
---@param dr number 开始时每帧半径增量
---@param a number 初始角度
---@param omiga number 旋转角速度
---@param t0 number 初始半径增加时间
---@param t1 number 保持匀速的持续时间
---@param IsRotChange boolean 朝向是否与旋转更新（默认不
function M.rotateMoveWith1(self, mst, dr, a, omiga, t0, t1, IsRotChange) --跟随
    t0 = t0 or 0
    t1 = t1 or _infinite
    local r = 0
    local Expand
    --角度是否跟着变化（不填默认不跟
    if IsRotChange then
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    r = r + dr
                    a = a + omiga
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                    self.rot = a
                else
                    break
                end
                task.Wait(1)
            end
        end
    else
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    r = r + dr
                    a = a + omiga
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                else
                    break
                end
                task.Wait(1)
            end
        end
    end

    Expand(t0)
    dr = 0
    Expand(t1)
end
function M.rotateMoveWith1Task(self, mst, dr, a, omiga, t0, t1, IsRotChange)
    task.New(self, function()
        M.rotateMoveWith1(self, mst, dr, a, omiga, t0, t1, IsRotChange)
    end)
end
--正圆旋转(rmax逻辑
---@param ramx number 在t0时间内能扩大的半径值。
function M.rotateMoveWith2(self, mst, rmax, a, omiga, t0, t1, IsRotChange) --跟随
    t0 = max(t0 or 1, 1)
    t1 = t1 or _infinite
    local dr = rmax/t0
    M.rotateMoveWith1(self, mst, dr, a, omiga, t0, t1, IsRotChange)
end
function M.rotateMoveWith2Task(self, mst, rmax, a, omiga, t0, t1, IsRotChange) --跟随
    t0 = max(t0 or 1, 1)
    t1 = t1 or _infinite
    local dr = rmax/t0
    M.rotateMoveWith1Task(self, mst, dr, a, omiga, t0, t1, IsRotChange)
end

--有减速过程的正圆旋转
---@param self object 对象本身
---@param mst object 要旋转跟随的目标
---@param dr number 开始时每帧半径增量
---@param a number 初始角度
---@param omiga number 旋转角速度
---@param t0 number 初始半径增加时间
---@param t1 number 保持匀速的持续时间
---@param t2 number 停止旋转的时间
---@param IsRotChange boolean 朝向是否与旋转更新（默认不
function M.rotateMoveWith3(self, mst, dr, a, omiga, t0, t1, t2, IsRotChange) --跟随
    t0 = t0 or 0
    t1 = t1 or _infinite
    t2 = t2 or 1
    local r = 0
    local domiga = 0
    local Expand
    --角度是否跟着变化（不填默认不跟
    if IsRotChange then
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    r = r + dr
                    omiga = omiga - domiga
                    a = a + omiga
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                    self.rot = a
                else
                    break
                end
                task.Wait(1)
            end
        end
    else
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    r = r + dr
                    omiga = omiga - domiga
                    a = a + omiga
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                else
                    break
                end
                task.Wait(1)
            end
        end
    end

    Expand(t0)
    dr = 0
    Expand(t1)
    domiga = -omiga/t2
    Expand(t2)
end
function M.rotateMoveWith3Task(self, mst, dr, a, omiga, t0, t1, t2, IsRotChange) --跟随
    task.New(self, function()
        M.rotateMoveWith3(self, mst, dr, a, omiga, t0, t1, t2, IsRotChange)
    end)
end
--rmax逻辑
function M.rotateMoveWith4(self, mst, rmax, a, omiga, t0, t1, t2, IsRotChange)
    local dr = rmax/t0
    M.rotateMoveWith3(self, mst, dr, a, omiga, t0, t1, t2, IsRotChange)
end
function M.rotateMoveWith4Task(self, mst, rmax, a, omiga, t0, t1, t2, IsRotChange)
    local dr = rmax/t0
    M.rotateMoveWith3Task(self, mst, dr, a, omiga, t0, t1, t2, IsRotChange)
end

--斜椭圆旋转(dr逻辑
---@param obliqueAngle number 倾斜角
function M.obliqueRotateMoveWith1(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange) --跟随
    local dx, dy = cos(obliqueAngle), sin(obliqueAngle)
    local a, b = 0, 0
    t0 = t0 or 1
    t1 = t1 or _infinite
    t2 = t2 or 1
    local domiga = 0
    local Expand, dx1, dy1
    --角度是否跟着变化（不填默认不跟
    if IsRotChange then
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    a, b = a + da, b + db
                    omiga = omiga + domiga
                    angle = angle + omiga
                    dx1, dy1 = a*cos(angle), b*sin(angle)
                    self.x, self.y = mst.x + dx1*dx - dy1*dy, mst.y + dx1*dy + dy1*dx
                    self.rot = angle
                else
                    break
                end
                task.Wait(1)
            end
        end
    else
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    a, b = a + da, b + db
                    omiga = omiga + domiga
                    angle = angle + omiga
                    dx1, dy1 = a*cos(angle), b*sin(angle)
                    self.x, self.y = mst.x + dx1*dx - dy1*dy, mst.y + dx1*dy + dy1*dx
                else
                    break
                end
                task.Wait(1)
            end
        end
    end
    Expand(t0)
    da, db = 0, 0
    Expand(t1)
    domiga = -omiga/t2
    Expand(t2)
end
function M.obliqueRotateMoveWith1Task(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange) --跟随
    task.New(self, function()
        M.obliqueRotateMoveWith1(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange)
    end)
end
--斜椭圆旋转(rmax逻辑
function M.obliqueRotateMoveWith2(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange)
    local da, db = amax/t0, bmax/t0
    M.obliqueRotateMoveWith1(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange)
end
function M.obliqueRotateMoveWith2Task(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange)
    task.New(self, function()
        M.obliqueRotateMoveWith2(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, IsRotChange)
    end)
end

--斜椭圆旋转 外加 倾斜角旋转(dr逻辑
---@param obliqueAngle number 倾斜角
---@param dObliqueAngle number 每帧倾斜角变化
function M.obliqueRotateMoveWith3(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange) --跟随
    local dx, dy
    local a, b = 0, 0
    t0 = t0 or 1
    t1 = t1 or _infinite
    t2 = t2 or 1
    local domiga = 0
    local d_dObliqueAngle = 0
    local Expand, dx1, dy1
    --角度是否跟着变化（不填默认不跟
    if IsRotChange then
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    a, b = a + da, b + db
                    omiga = omiga + domiga
                    angle = angle + omiga
                    dObliqueAngle = dObliqueAngle + d_dObliqueAngle
                    obliqueAngle = obliqueAngle + dObliqueAngle
                    dx, dy = cos(obliqueAngle), sin(obliqueAngle)
                    dx1, dy1 = a*cos(angle), b*sin(angle)
                    self.x, self.y = mst.x + dx1*dx - dy1*dy, mst.y + dx1*dy + dy1*dx
                    self.rot = angle
                else
                    break
                end
                task.Wait(1)
            end
        end
    else
        Expand = function(t)
            for _ = 1, t do
                if IsValid(mst) then
                    a, b = a + da, b + db
                    omiga = omiga + domiga
                    angle = angle + omiga
                    dObliqueAngle = dObliqueAngle + d_dObliqueAngle
                    obliqueAngle = obliqueAngle + dObliqueAngle
                    dx, dy = cos(obliqueAngle), sin(obliqueAngle)
                    dx1, dy1 = a*cos(angle), b*sin(angle)
                    self.x, self.y = mst.x + dx1*dx - dy1*dy, mst.y + dx1*dy + dy1*dx
                else
                    break
                end
                task.Wait(1)
            end
        end
    end
    Expand(t0)
    da, db = 0, 0
    Expand(t1)
    domiga = -omiga/t2
    d_dObliqueAngle = -dObliqueAngle/t2
    Expand(t2)
end
function M.obliqueRotateMoveWith3Task(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
    task.New(self, function()
        M.obliqueRotateMoveWith3(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
    end)
end
--斜椭圆旋转 外加 倾斜角旋转(rmax逻辑
function M.obliqueRotateMoveWith4(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
    local da, db = amax/t0, bmax/t0
    M.obliqueRotateMoveWith3(self, mst, da, db, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
end
function M.obliqueRotateMoveWith4Task(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
    task.New(self, function()
        M.obliqueRotateMoveWith4(self, mst, amax, bmax, angle, omiga, t0, t1, t2, obliqueAngle, dObliqueAngle, IsRotChange)
    end)
end

--普通的跟随
function M.moveWith(obj, mst, dx, dy, t)
    t = t or _infinite
    for i = 1, t do
        if IsValid(mst) then
            obj.x, obj.y = mst.x + dx, mst.y + dy
        else
            break
        end
        task.Wait(1)
    end
end
function M.moveWithTask(obj, mst, dx, dy, t)
    task.New(obj, function()
        M.moveWith(obj, mst, dx, dy, t)
    end)
end

--region 遍历bullet与enemy的操作
--遍历场上所有可消子弹并执行传入函数的指令
function M.allBulletsDo(func)
    for _, obj in ObjList(GROUP_ENEMY_BULLET) do
        func(obj)
    end
end
function M.allIndesDo(func)
    for _, obj in ObjList(GROUP_INDES) do
        func(obj)
    end
end

--局部类，消弹器
local bullet_killer, bullet_deleter
do
    bullet_killer = Class(object)
    function bullet_killer:init(x, y, r, t, isClearIndes)
        self.x = x
        self.y = y
        self.range = r
        self.a, self.b = r, r
        self.group = GROUP_SPELL
        self.bound = false
        self.hide = true
        self.left_time = t
        self.isClearIndes = isClearIndes
    end
    function bullet_killer:frame()
        task.Do(self)
        local r = self.range
        self.a, self.b = r, r
        if self.left_time > 0 then
            self.left_time = self.left_time - 1
        else
            self.status = "del"
        end
    end
    function bullet_killer:colli(other)
        if other.group == GROUP_ENEMY_BULLET or (other.group == GROUP_INDES and self.isClearIndes) then
            Kill(other)
        end
    end

    bullet_deleter = Class(bullet_killer)
    function bullet_deleter:colli(other)
        if other.group == GROUP_ENEMY_BULLET or (other.group == GROUP_INDES and self.isClearIndes) then
            Del(other)
        end
    end
end

function M.clearBulletInRange(x, y, r, no_bonus)
    if no_bonus then
        --一般有限范围内消弹，判断方法是碰撞
        New(bullet_deleter, x, y, r, 1)
    else
        New(bullet_killer, x, y, r, 1)
    end
end

function M.clearBulletAndLaserInRange(x, y, r, cd, no_bonus)
    M.clearBulletInRange(x, y, r, no_bonus)
    EISlib.Bullet.Laser.cutLasersByCircle(x, y, r, not no_bonus, cd)
end

function M.clearBulletAndIndesAndLaserInRange(x, y, r, cd, no_bonus)
    if no_bonus then
        --一般有限范围内消弹，判断方法是碰撞
        New(bullet_deleter, x, y, r, 1, true)
    else
        New(bullet_killer, x, y, r, 1, true)
    end
    EISlib.Bullet.Laser.cutLasersByCircle(x, y, r, not no_bonus, cd)
end

--仅用于boss非符和符卡击破时的全屏消弹，正常击破后的消弹会统计分数
function M.clearAllAndGetBonus(no_bonus)
    local score = 0
    if no_bonus then
        EGGlib.ObjectEvent.allBulletsDo(
                function(obj)
                    Del(obj)
                end)
        EGGlib.ObjectEvent.allIndesDo(
                function(obj)
                    Del(obj)
                end)
        EISlib.Bullet.Laser.delAllLasers()
    else
        --因为要统计一瞬间消除的子弹分数，因此保留原消除方法。并且目前该游戏只有BOSS战攻击阶段击破时才用上此处代码块
        EGGlib.ObjectEvent.allBulletsDo(
                function(obj)
                    score = score + system.SMALL_POWER_SCORE
                    Kill(obj)
                end)
        EGGlib.ObjectEvent.allIndesDo(
                function(obj)
                    score = score + system.SMALL_POWER_SCORE
                    Kill(obj)
                end)
        local count = EISlib.Bullet.Laser.killAllLasers()
        score = score + count*system.SMALL_POWER_SCORE
    end
    --local count = EISlib.Bullet.Laser.cutLasersByCircle(0, 0, _infinite, not no_bonus, 0)

    return score
end

--瞬间消弹扩散圈
local color = {"green", "blue", "purple", "orange", "orange"}
local clear_bullet_circle_object = Class(object)
function clear_bullet_circle_object:init(x, y, rmax, index, cd, t, no_clear, no_bonus)
    self.x, self.y = x, y
    self.size = 0
    self.range = rmax
    self.rate = 0
    robject.set_color(self, "mul+add", 255, 255, 255, 255)
    index = index or (system.PowerRank.getRank() + 1)
    self.colors = color[index]
    if not no_clear then
        M.clearBulletAndLaserInRange(x, y, self.range, cd, no_bonus)
    end
    task.New(self, function()
        t = t or 30
        local drate = 1/t
        for _ = 1, t do
            self.rate = self.rate + drate
            task.Wait(1)
        end
        Del(self)
    end)
end
function clear_bullet_circle_object:frame()
    task.Do(self)
end
function clear_bullet_circle_object:render()
    sp.misc.RenderRing3("boom_"..self.colors, self.x, self.y, self.rate*self.range, self.range, 60, 1, 0, 360, self._blend, Color(self._a*(1-self.rate), self._r, self._g, self._b))
end
function M.clearBulletAndLaserInRangeCircle(x, y, rmax, index, cd, t, no_clear, no_bonus)
    return New(clear_bullet_circle_object, x, y, rmax, index, cd, t, no_clear, no_bonus)
end

--创建一个逐渐变大的圈，持续时间内每帧对圈内子弹做func
function M.allBulletsInCircleDo(x, y, r0, r1, t, func, obj)
    local f = function()
        local dr = (r1 - r0)/t
        for _ = 1, t do
            r0 = r0 + dr
            M.allBulletsDo(
                    function(obj)
                        if Dist(x, y, obj.x, obj.y) < r0 then
                            func(obj)
                        end
                    end)
            task.Wait(1)
        end
    end
    --有执行者就在执行者身上创建task，否则独自创建一个tasker
    if obj then
        task.New(obj, function()
            f()
        end)
    else
        tasker(f)
    end
end

--创建一个逐渐变大的圈，持续时间内每帧对圈内激光做截断
function M.allLaserInCircleDo(x, y, r0, r1, t, drop, obj, cd)
    local f = function()
        t = int(t/5) --截断5帧检测一次吧，性能有点伤不起。
        local dr = (r1 - r0)/t
        for _ = 1, t do
            r0 = r0 + dr
            EISlib.Bullet.Laser.cutLasersByCircle(x, y, r0, drop, cd)
            task.Wait(5)
        end
    end
    --有执行者就在执行者身上创建task，否则独自创建一个tasker
    if obj then
        task.New(obj, function()
            f()
        end)
    else
        tasker(f)
    end
end
--

--遍历场上所有有体术判定敌人并执行传入函数的指令
function M.allEnemyDo(func)
    for _, obj in ObjList(GROUP_ENEMY) do
        func(obj)
    end
end

--遍历场上所有无体术判定敌人并执行传入函数的指令
function M.allNontjtDo(func)
    for _, obj in ObjList(GROUP_NONTJT) do
        func(obj)
    end
end

--遍历场上所有敌人并执行传入函数的指令
function M.allEnemyAndNontjtDo(func)
    M.allNontjtDo(func)
    M.allEnemyDo(func)
end

--清除场上所有敌人和子弹（一般用于道中末需要清屏时）
function M.clearEnemyAndBullet()
    for _, unit in ObjList(GROUP_ENEMY) do
        Del(unit)
    end
    for _, unit in ObjList(GROUP_NONTJT) do
        Del(unit)
    end
    for _, unit in ObjList(GROUP_ENEMY_BULLET) do
        _del(unit, true)
    end
    for _, unit in ObjList(GROUP_INDES) do
        _del(unit, true)
    end
end
--endregion

--region 对象移动
--通过移动中心来决定移动逻辑
function M.moveToPlayerByCenter(x0, dx, y0, dy, x_min, x_max, y_min, y_max, t, obj)
    local move_mode
    --[[if ran:Int(1, 2) == 1 then
        move_mode = MOVE_X_TOWARDS_PLAYER
    else
        move_mode = MOVE_RANDOM
    end]] --暂时取消，改成100%朝向自机x移动
    move_mode = MOVE_X_TOWARDS_PLAYER
    if obj then
        task.New(obj, function()
            task.MoveToPlayer(obj, t, x0 - dx, x0 + dx, y0 - dy, y0 + dy, x_min, x_max, y_min, y_max, MOVE_ACC_DEC, move_mode)
        end)
    else
        error("invalid call.")
    end
end

--知道移动起始点和移动范围来决定移动距离
function M.moveToPlayerBySide(x0, dx, y0, dy, y_min, y_max, t, obj)
    local move_mode
    --[[if ran:Int(1, 2) == 1 then
        move_mode = MOVE_X_TOWARDS_PLAYER
    else
        move_mode = MOVE_RANDOM
    end]] --暂时取消，改成100%朝向自机x移动
    move_mode = MOVE_X_TOWARDS_PLAYER
    if obj then
        task.New(obj, function()
            task.MoveToPlayer(t, x0, x0 + dx, y0, y0 + dy, abs(dx), abs(dx), y_min, y_max, MOVE_ACC_DEC, move_mode)
        end)
    else
        task.MoveToPlayer(t, x0, x0 + dx, y0, y0 + dy, abs(dx), abs(dx), y_min, y_max, MOVE_ACC_DEC, move_mode)
    end
end

--新的boss移动逻辑
function M.bossMove(obj, x_min, x_max, dx_min, dx_max, y0, dy_min, dy_max, t)
    --根据目标的x坐标、自机x坐标、x边界来决定boss的横向移动方向
    local dx = ran:Int(dx_min, dx_max)
    if obj.x > player.x then
        dx = -dx
    elseif obj.x == player.x then
        dx = ran:Sign()*dx
    end
    --预移动：如果本次移动会超出边界，则实际会将x方向的移动反向
    if (obj.x + dx > x_max) or (obj.x + dx < x_min) then
        dx = -dx
    end
    --根据目标的y坐标和中心y坐标来决定boss的纵向移动方向
    local dy = ran:Int(dy_min, dy_max)
    if obj.y > y0 then
        dy = -dy
    end
    --简单的匀速直线运动
    dx, dy = dx/t, dy/t
    for _ = 1, t do
        obj.x, obj.y = obj.x + dx, obj.y + dy
        task.Wait(1)
    end
end

function M.bossMoveTask(obj, x_min, x_max, dx_min, dx_max, y0, dy_min, dy_max, t)
    task.New(obj, function()
        M.bossMove(obj, x_min, x_max, dx_min, dx_max, y0, dy_min, dy_max, t)
    end)
end

--默认的移动方式
function M.moveToPlayerDefault(t, obj, y0)
    y0 = y0 or 144
    t = t or 30
    M.bossMoveTask(obj,
            -40, 40, 15, 20, --x_min, x_max, dx_min, dx_max
            y0, 5, 10, t --y0, dy_min, dy_max, t
    )
end
--endregion

--设置小怪减伤
function M.setDmgRate(obj, rate)
    obj.dmgrate = rate
end

--小怪无敌、减伤时间
function M.setDecDmgTime(obj, dmgrate0, dmgrate1, t0, t1)
    t0 = t0 or 0
    t1 = t1 or 1
    M.setDmgRate(obj, dmgrate0)
    local ds = (dmgrate1 - dmgrate0)/t1
    task.New(obj, function()
        task.Wait(t0)
        for _ = 1, t1 do
            obj.dmgrate = obj.dmgrate + ds
            task.Wait(1)
        end
    end)
end

--直接设置无敌时间
function M.setProtectTime(obj, t)
    obj.protect = true
    task.New(obj, function()
        task.Wait(t)
        obj.protect = false
    end)
end

--设置出屏无敌保护
function M.setBoundProtect(enemy)
    enemy.bound_protect = true
end

--设置取消无敌保护
function M.cancelBoundProtect(enemy)
    enemy.bound_protect = false
end

--工具人对象（与tasker用法类似，不过要手写)
M.object = Class(object)
function M.object:init(x, y, func)
    self.x, self.y = x, y
    func(self)
end
function M.object:frame()
    task.Do(self)
end
function M.object:render()
end
function M.object:kill() end
function M.object.del() end


--添加帧逻辑(只可作用于新的子弹和新激光，luastg默认的子弹定义和激光无效）
function M.addFrame(obj, frame_func)
    obj.ex_frame = frame_func
end
