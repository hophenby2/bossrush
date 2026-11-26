-- 兼容math.bezier_curve的“控制点生成采样函数”接口。
-- de Casteljau逐层插值计算原控制点对应的Bézier多项式，不改变任务中的缓动和时长。
return function(...)
    local points={...}
    local count=select('#',...)
    assert(count>0,'贝塞尔曲线至少需要一个控制点')
    for i=1,count do assert(type(points[i])=='number','贝塞尔曲线控制点必须为数字') end
    local work={}
    return function(t)
        for i=1,count do work[i]=points[i] end
        for level=count-1,1,-1 do
            for i=1,level do work[i]=work[i]+(work[i+1]-work[i])*t end
        end
        return work[1]
    end
end
