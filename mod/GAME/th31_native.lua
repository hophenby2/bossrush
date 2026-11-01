-- TH08 stg4benm.anm的火花不是圆玉；Sub57/70的回调直接判定旋转矩形。
-- 来源：stg4benm/script6..9、18..25；EclExIns.cpp:529/554/578；Player::CalcLaserHitbox。
local N={}
LoadTexture('th31_master_spark','Resources/System/th31_master_spark.png')
LoadImage('th31_master_spark','th31_master_spark',1,0,255,128)
function N.spark(o,script)
    o.img='th31_master_spark'
    o.th08_spark_script=script
    -- 四层火花由调用方明确传入 6..9、18..21 或22..25，不能全部重放同一个子程序。
    OriginalStageVisual.main_script(o,8,'stg4benm',script)
    o._original_explicit=true
    o._inf_graze,o.IsLaser=true,true
end
function N.render_spark(o)
    OriginalStageVisual.draw(o)
end
function N.spark_hit(o,x,y,outer,inner,timer)
    local function test(p)
        if not p or not IsValid(p) then return end
        local a=o.rot*math.pi/180
        local dx,dy=p.x-x,p.y-y
        local along=dx*math.cos(a)+dy*math.sin(a)
        local normal=-dx*math.sin(a)+dy*math.cos(a)
        local hx,hy=p.A or p.a or 0,p.B or p.b or 0
        if along+hx>=0 and along-hx<=590 and math.abs(normal)<=outer/2+hy then
            p.class.colli(p,o)
        elseif timer%12==0 and along+hx>=-48 and along-hx<=638
            and math.abs(normal)<=inner/2+48+hy and p.grazer then
            p.grazer.class.colli(p.grazer,o,true,p.x,p.y)
        end
    end
    if GameNet and GameNet.forEachPlayer then GameNet.forEachPlayer(test) else test(player) end
end
return N
