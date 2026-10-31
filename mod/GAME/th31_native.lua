-- TH08 stg4benm.anm的火花不是圆玉；Sub57/70的回调直接判定旋转矩形。
-- 来源：stg4benm/script6..9、18..25；EclExIns.cpp:529/554/578；Player::CalcLaserHitbox。
local N={}
LoadTexture('th31_master_spark','Resources/System/th31_master_spark.png')
LoadImage('th31_master_spark','th31_master_spark',1,0,255,128)
local function mix(a,b,u) return a+(b-a)*math.max(0,math.min(1,u)) end
function N.spark(o,script)
    o.img='th31_master_spark'
    o.th08_spark_script=script
    o._inf_graze,o.IsLaser=true,true
end
function N.render_spark(o)
    local script=o.th08_spark_script
    local age=o.o_t or o.sp_t or o.h_t or 0
    local band=script>=22 and 22 or (script>=18 and 18 or 6)
    local layer=script-band
    local fade=band==22 and 130 or (band==18 and 240 or 310)
    local ending=band==22 and 170 or (band==18 and 300 or 370)
    if age>=ending then return end
    local initial=({0.1,0.05,0.03,0.02})[layer+1]
    local full=band==6 and ({2,1.5,1,0.5})[layer+1] or ({3,2.5,2,1.5})[layer+1]
    local sx=(band==22 and 3.9 or 2.3)*math.min(1,(age/60)^2)
    local u=1-(1-math.max(0,math.min(1,(age-60)/60)))^2
    local sy=mix(initial,full,u)
    local a=age<90 and 96 or mix(96,255,(age-90)/30)
    if age>=fade then a=mix(255,0,(age-fade)/(ending-fade)) end
    local tint=({255,224,192,128})[layer+1]
    SetImageState(o.img,'mul+add',a,255,mix(255,tint,age/60),mix(255,tint,age/60))
    Render(o.img,o.x,o.y,o.rot,sx,sy)
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
