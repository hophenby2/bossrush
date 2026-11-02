-- 永夜抄三面缺失阶段：ecldata3 Sub30..33、Sub71..74，Lunatic。
-- 坐标仅在入口取 x-192、224-y；公转角/角速度及发弹张角一起取反。
-- 使魔先执行枪，再更新公转位置；贴图旋转由原作ANM自身负责。
-- 差异1：Boss Rush没有刻符路线判定，高天原作为独立练习/战斗条目提供；原作须达刻符阈值。
return function(class, EX, laser)
    local object, New, IsValid = object, New, IsValid
    local M = class.th08_combat
    local PI, RAD = math.pi, 180 / math.pi
    local ANGLE_STEP = 2.094395160675049
    local OMEGA = 0.07853981852531433
    local FIRST = 90
    local GROW, RESUME = 40, 100
    local PYRAMID_PERIOD = 1100
    local LASER_START, LASER_ACTIVE, LASER_END = 120, 20, 10
    local LASER_WIDTH, LASER_LENGTH, LASER_HIT = 12, 640, 90
    local LASER_LIMIT = 256

    M.profiles['ecldata3:33'] = {
        spawns={{90,1500,false,false},{90,150,false,false}},
        events={{0,77,24,24},{0,160,30},{0,80,8192}}, attached=true,
        life=function(o,args) return args[6] end,
    }
    M.profiles['ecldata3:73'] = {
        spawns={{90,1200,96,128},{90,1200,288,128},{90,500,192,224}},
        events={{0,77,24,24},{0,160,30},{0,80,8192}}, attached=true,
        life=function(o,args) return args[6] end,
    }

    -- 两张均为符卡，DispatchShotInstruction跳过rank修正。
    -- 使魔保留32px出生默认值；SET_BOSS已把本体的近身闸清零，不能一起过滤。
    local function shoot(o, args)
        if o.th08_source and (o.x-player.x)^2+(o.y-player.y)^2 < 1024 then return end
        EX.shoot(o,o.x,o.y,args)
    end
    local beam = Class(laser, {
        init=function(o,x,y,angle)
            laser.init(o,EX.color(6),x,y,angle*RAD,0,LASER_LENGTH,0,1.2,0,0)
            o.keine_phase,o.keine_timer=1,0
            o._native_laser_phase={'keine_phase','keine_timer',LASER_END,LASER_WIDTH}
            o.bound,o.colli,o.alpha=false,false,1
        end,
        frame=function(o)
            local t=o.keine_timer
            if o.keine_phase==1 then
                o.w=t>LASER_START-30 and t*LASER_WIDTH/LASER_START or 1.2
                o.colli=t>=LASER_HIT
                if t>=LASER_START then o.keine_phase,o.keine_timer,t=2,0,0 end
            end
            if o.keine_phase==2 then
                o.w,o.colli=LASER_WIDTH,true
                if t>=LASER_ACTIVE then o.keine_phase,o.keine_timer,t=3,0,0 end
            end
            if o.keine_phase==3 then
                if t>=LASER_END then object.RawDel(o);return end
                o.w,o.colli=LASER_WIDTH*(1-t/LASER_END),t<LASER_END
            end
            OriginalBulletVisual.native_laser(o,o.keine_phase,t,LASER_WIDTH,LASER_END)
            laser.frame(o)
            o.keine_timer=t+1
        end,
    })
    class.th08_keine_laser=beam

    local function actor(key,kind)
        return M.actor(key,{
            init=function(o,x,y,angle,omega,radial,hp,owner)
                o.x,o.y=x,y
                o.img,o.layer,o.group='servant',LAYER.ENEMY,GROUP.NONTJT
                o.bound,o.colli,o.navi=false,false,false
                o.rot,o.hscale,o.vscale=0,1,1
                o.keine_x,o.keine_y=x,y
                o.keine_angle,o.keine_omega0=angle,omega
                o.keine_omega,o.keine_radial,o.keine_radius=omega,radial,0
                o.keine_t,o.keine_owner=0,owner
                EX.clear_records(o)
            end,
            frame=function(o)
                local t=o.keine_t
                if t>=(kind==1 and 1300 or 3700) then object.RawDel(o);return end
                if t==GROW then o.keine_omega,o.keine_radial=0,0 end
                if t==RESUME then o.keine_omega=o.keine_omega0/(kind==1 and 7 or 16) end
                if t>=GROW then
                    local angle=math.atan2(o.keine_y-o.y,o.keine_x-o.x)
                    if kind==1 and (t-GROW)%12==0 then
                        shoot(o,{op=97,type=3,color=EX.color(6),count1=2,count2=1,
                            speed1=2.2,speed2=0.5,angle=angle,step=-1.0471975803375244,flags=514})
                    elseif kind==2 and (t-GROW)%32==0 and IsValid(o.keine_owner) then
                        -- ins_114不检查与自机距离；发射后位置固定，不挂回旋转使魔。
                        local list=o.keine_owner.keine_lasers
                        M.actor_count(list)
                        if #list<LASER_LIMIT then list[#list+1]=New(beam,o.x,o.y,angle) end
                    end
                end
                o.keine_angle=o.keine_angle+o.keine_omega
                if o.keine_angle>PI then o.keine_angle=o.keine_angle-2*PI
                elseif o.keine_angle< -PI then o.keine_angle=o.keine_angle+2*PI end
                o.keine_radius=o.keine_radius+o.keine_radial
                o.x=o.keine_x+math.cos(o.keine_angle)*o.keine_radius
                o.y=o.keine_y+math.sin(o.keine_angle)*o.keine_radius
                o.keine_t=t+1
            end,
        })
    end
    local pyramid=actor('ecldata3:33',1)
    local takama=actor('ecldata3:73',2)
    class.th08_keine_pyramid,class.th08_keine_takama=pyramid,takama

    local function spawn(o,cls,x,y,angle,omega,radial,hp)
        local unit=New(cls,x,y,-angle,-omega,radial,hp,o)
        o.keine_actors[#o.keine_actors+1]=unit
    end
    local function pyramid_spawn(o)
        -- Sub30的四个三角形；第二至四组是150life，不能统一成第一组的1500。
        for _,group in ipairs({{-PI/2,-OMEGA,1.6,1500},{PI/2,OMEGA,2.4,150},
                               {PI,-OMEGA,3.2,150},{0,OMEGA,3.6,150}}) do
            for i=0,2 do spawn(o,pyramid,o.x,o.y,group[1]+i*ANGLE_STEP,group[2],group[3],group[4]) end
        end
    end
    local function takama_spawn(o)
        for i=0,2 do spawn(o,takama,-96,96,-PI/2+i*ANGLE_STEP, OMEGA,0.8,1200) end
        for i=0,2 do spawn(o,takama, 96,96,-PI/2+i*ANGLE_STEP,-OMEGA,0.8,1200) end
        -- 中央的四只顺序来自Sub71:0xa0a0..0xa15c，不把两组反向公转合并。
        spawn(o,takama,0,0,0,-OMEGA,0.8,500)
        spawn(o,takama,0,0,PI,-OMEGA,0.8,500)
        spawn(o,takama,0,0,PI,OMEGA,0.8,500)
        spawn(o,takama,0,0,2*PI,OMEGA,0.8,500)
    end
    local function make(kind)
        return {
            init=function(o)
                EX.clear_records(o);EX.pool_clear()
                o.group,o.colli=GROUP.ENEMY,true
                o.keine_t,o.keine_gun_start=0,nil
                o.keine_actors,o.keine_lasers={},{}
            end,
            frame=function(o)
                if not o.keine_t then return end
                local t=o.keine_t
                M.actor_count(o.keine_actors);M.actor_count(o.keine_lasers)
                if kind==1 then
                    if t>=FIRST and (t-FIRST)%PYRAMID_PERIOD==0 then pyramid_spawn(o) end
                    -- 重挂子context时清其时钟；旧枪在1190帧仍会开火，1290帧被新枪替换。
                    if t>=190 and (t-190)%PYRAMID_PERIOD==0 then o.keine_gun_start=t end
                    if o.keine_gun_start and (t-o.keine_gun_start)%200==0 then
                        shoot(o,{op=98,type=10,color=EX.color(1),count1=3,count2=3,
                            speed1=3,speed2=1.5,angle=0,step=0,flags=4})
                    end
                else
                    if t==FIRST then takama_spawn(o) end
                    if t>=210 and (t-210)%30==0 then
                        shoot(o,{op=98,type=2,color=EX.color(2),count1=42,count2=3,
                            speed1=3.2,speed2=1.2,angle=0,step=-0.19634954631328583,flags=515})
                    end
                end
                o.keine_t=t+1
            end,
            del=function(o)
                o.keine_t,o.keine_gun_start=nil,nil
                for _,list in ipairs({o.keine_actors or {},o.keine_lasers or {}}) do
                    for _,unit in ipairs(list) do if IsValid(unit) then object.RawDel(unit) end end
                end
                o.keine_actors,o.keine_lasers=nil,nil
                EX.pool_clear()
            end,
        }
    end
    return make(1),make(2)
end
