-- 0x0c09b912 的定点累加与 0x0c1d6580 的第二层 opcode 14；只输出地面实体所需位移。
-- 首个可操作逻辑步前累计 213.5 像素，原版 5485 帧为 409.5 像素、卷轴位置 51。
-- 该指令表以第三层位置推进；位置 514 后第三层固定 2 像素，第二层继续加速，不能互相代替。
-- 这里只输出地面位移，背景图块仍由现有加载器绘制。
local rows=dofile('mod/GAME/th46/groundbug_data.lua').scroll
local unit=65536
return {
    open=function(run)run.groundScroll={total=213.5*unit,control=213.5*unit,speed=56*4096,controlSpeed=56*4096,index=2};run.roadGroundDelta=0 end,
    step=function(run)
        local s=run.groundScroll
        local total=s.total+s.speed
        run.roadGroundDelta=(math.floor(total/unit)-math.floor(s.total/unit))*unit
        s.total,s.control=total,s.control+s.controlSpeed
        local position=math.floor(s.control/(8*unit))
        while rows[s.index] and rows[s.index][1]<=position do
            s.speed,s.controlSpeed=rows[s.index][2]*4096,rows[s.index][3]*4096;s.index=s.index+1
        end
    end,
}
