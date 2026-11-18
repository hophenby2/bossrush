-- 关底主任务与已移植的原生移动、炮台和演出任务之间的连接。
-- 存活直接读取子对象的结束状态，不能从回归文件或录制帧号取得。
-- 场景、图形分配和声音仍需原生效果工厂；未知入口必须由调用方明确实现。
return function(host,modules,ports)
    ports=ports or {}
    local core,motion,tasks,guns=modules.core,modules.motion,modules.tasks,modules.guns
    local emit=ports.emit or modules.bullets.emit
    local emitFan=ports.emitFan or modules.bullets.fan
    local emitMotionFan=ports.emitMotionFan or modules.bullets.motionFan
    local random=ports.random or function(n)return ran:Int(0,n)end
    if not host.taskGroup then
        tasks.create(host,{
            invoke=function(owner,kind,args,slot)
                return assert(ports.effect,'关底尚未连接原生效果工厂')(owner,kind,args,slot)
            end,
            observe=ports.observeTask,
            close=ports.closeEffects,
        })
    end
    local modes={enter_pose='enter_init',enter_flash='flash_init',tilt='tilt_init',
        pose_left='arm_left',pose_right='arm_right',reset_pose='reset_init',leap_smoke='leap_smoke_init'}
    local previousGunDone=host.gunDone
    local previousMotionEvent=host.motionEvent
    host.motionEvent=function(owner,name,mode,wait)
        if name=='land'then tasks.spawn(owner.taskGroup,'landing_init')
        elseif name=='entry_pose'then tasks.spawn(owner.taskGroup,'pose_init',{wait})
        else error('关底移动事件尚未连接：'..tostring(name))end
        if previousMotionEvent then previousMotionEvent(owner,name,mode,wait)end
        if ports.motionEvent then ports.motionEvent(owner,name,mode,wait)end
    end
    host.gunDone=function(owner,gun)
        -- c158370 / c15837c：每份侧炮自然结束后分别收回左右关节，并非等下一组主任务收回。
        if rawget(gun,'gunType')=='side'then
            tasks.spawn(owner.taskGroup,'arm_left_reset')
            tasks.spawn(owner.taskGroup,'arm_right_reset')
        end
        if previousGunDone then previousGunDone(owner,gun)end
        if ports.gunDone then ports.gunDone(owner,gun)end
    end
    local api={observe=ports.observe,beforeSlot=ports.beforeSlot,afterSlot=ports.afterSlot}
    function api.invoke(_,kind,args)
        if kind=='random'then return random(args[1])end
        if kind=='alive'then return tasks.alive(args[2])end
        if kind=='spawn'then
            local name=args[1]
            if modes[name]then
                local config={};for i=2,#args do config[#config+1]=args[i]end
                return tasks.spawn(host.taskGroup,modes[name],config)
            elseif name=='head'then return guns.head(host,emit)
            elseif name=='burst'then return guns.burst(host,emitFan,args[2],args[3])
            elseif name=='side'then
                -- c157ce0 的四个参数依次为等待、串数、速度偏移、串间等待。
                return guns.side(host,emit,
                    {delay=args[2],waves=args[3],speed=args[4],pause=args[5]},
                    ports.side and ports.side()or nil)
            elseif name=='leap_gun'then
                return guns.leap(host,{motionFan=emitMotionFan,
                    baseSpeed=ports.baseSpeed or function()return 43 end,
                    random=ports.gunRandom or random},args[2])
            elseif name=='wide_gun'then
                local child=ports.child or function(run,_,x,y,owner,angle,speed,flags)
                    modules.children.load()
                    return modules.children.create(run,x,y,owner,angle,speed,flags,assert(ports.childPorts,
                        '宽幅炮子敌机缺少原生效果和 Bomb 状态接口'))
                end
                return guns.wide(host,{fan=emitFan,child=child,pose=function(owner,angle,mode)
                    owner.raw[76],owner.raw[80]=angle,mode
                    if owner.raw[0x1ac0]==0 or owner.raw[0x1ac0]==2 then
                        tasks.spawn(owner.taskGroup,'central_init')
                    end
                end},args[2])
            end
            return assert(ports.spawn,'关底子入口尚未连接：'..tostring(name))(host,name,args)
        end
        if kind=='stop'then
            assert(args[2]==1,'关底停止标志尚未移植')
            if tasks.alive(args[1])then guns.stop(args[1])end
            return
        end
        if kind=='pose'then return tasks.spawn(host.taskGroup,'pose_init',{args[2]})end
        if kind=='jump'then return end -- c1561a0 的两次本体写入已在主任务中完成。
        if kind=='motion'then
            if ports.motion then return ports.motion(host,args)end
            local config={};for i=3,#args do config[#config+1]=args[i]end
            if not host.motion then motion.create(host,args[2],config,ports.motionRandom)
            elseif args[1]=='ensure'then motion.ensure(host.motion,args[2],config)
            else motion.switch(host.motion,args[2],config)end
            return
        end
        if kind=='signal'then
            if args[1]=='enable_collision'then core.enable(host,args[2])end
            if ports.signal then return ports.signal(host,args)end
            assert(args[1]=='enable_collision','关底场景接口尚未连接：'..tostring(args[1]))
            return
        end
        error('关底主任务接口尚未连接：'..tostring(kind))
    end
    function api.close()
        guns.close(host.run)
        if host.taskGroup then tasks.close(host.taskGroup)end
        host.gunDone=previousGunDone
        host.motionEvent=previousMotionEvent
    end
    return api
end
