-- 原Laser_move_zhi：寿命到期只收回尾部，纵轴收束完成后才销毁绑定发射器。
local M={}
local radii={[0]=.05,[1]=.05,[2]=.03,[3]=.06}
function M.direction(s)
    local p=s.parent
    local parentAngle=p and (p.rotation+(p.kind=='beam' and p.beamMode==1 and 90 or 0)) or 0
    return s.direction+parentAngle
end
function M.init(s,e)
    local sizeEvents=false
    for _,event in ipairs(e.events) do sizeEvents=sizeEvents or event[9]==22 or event[9]==23 end
    local length=sizeEvents and e.a6_8 or e.a54_2
    s.length=math.max(4,math.floor(length/4)*4)*.01
    s.width=sizeEvents and e.a6_7 or e.a54_3
    if s.laserStyle<0 or s.laserStyle>3 then s.laserStyle=0 end
    s.lineLength,s.lineGenerated,s.lineGrowing=0,0,true
    s.lineWidth=s.width
    s.lineRadius=s.width*radii[s.laserStyle]
end
local function shift(s,d)
    local a=M.direction(s)
    s.x,s.y=s.x+d*cos(a),s.y+d*sin(a)
end
function M.shrink(s)
    if s.lineLength<=.08*s.width then return false end
    s.lineLength=s.lineLength-.04;s.length=s.length-.04
    if s.lineGrowing then s.lineGenerated=s.lineGenerated-.04 end
    shift(s,-.16)
    return true
end
function M.step(s)
    local speed=s.speed*.01
    shift(s,speed)
    s.rotation=M.direction(s)
    s.lineWidth=s.width*.5
    s.lineRadius=s.width*radii[s.laserStyle]
    if s.lineGrowing then
        s.lineLength=s.lineLength+speed*.25;s.lineGenerated=s.lineGenerated+speed*.25
        if s.lineGenerated>=s.length then s.lineGrowing=false end
    else
        local delta=s.length-s.lineLength
        s.lineLength=s.length
        -- 原作未绑定时回退头部；运动绑定时使用Transform.Translate的正纵轴。
        shift(s,(s.parent and 2 or -2)*delta)
        if s.lineLength<=.08*s.width then s.alive=false end
    end
    s.life=s.life-1
    -- Laser_move_zhi只读chupingxiaoshi，不使用普通弹的延迟出屏回收字段。
    if s.exit==1 and (s.x<-.5 or s.x>9.7 or s.y< -10.5 or s.y>0) then M.shrink(s) end
    if s.life<0 then
        s.lineLength=s.lineLength-speed*.25;s.length=s.length-speed*.25
        if s.lineGrowing then s.lineGenerated=s.lineGenerated-speed*.25 end
        shift(s,-speed)
    end
end
return M
