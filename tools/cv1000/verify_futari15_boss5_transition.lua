-- 检查完整本体的真实伤害/超时通知能切换原生主任务；外部炮台与演出只检查清除请求。
return function(body,p)
    local unit=65536
    local objects={}
    local function run(timeout,linked,finalTimeout)
        local run={serial=0}
        local host=body.create(run,p)
        objects[#objects+1]=host
        local requests={}
        local api={random=function()return 0 end,
            invoke=function(_,kind,args)
                if kind=='alive'then return false end
                if kind=='weapon_active'then return 0 end
                if kind=='player_field80'then assert(linked);return 1 end
                if kind=='clear'then requests[#requests+1]=args[1]
                elseif kind=='bullet_cancel'then
                    assert(args[2]==96)
                    if(#requests==0 and timeout)or(#requests==6 and finalTimeout)then assert(args[1]==0xc06d5d0)
                    elseif linked then assert(args[1]==0xc06d6a0 and args[3]==234 and args[4]==7 and args[5]==17)
                    else assert(args[1]==0xc06d6a0 and args[3]==0 and args[4]==0 and args[5]==0)end
                    requests[#requests+1]='cancel'
                elseif kind=='signal'then return
                elseif kind=='service'and args[1]==0xc078a50 then requests[#requests+1]='prepare'
                else error('换段联动多请求了接口 '..kind)end
            end}
        local manager=body.attachControl(host,api,'second_init')
        local moving=body.attachMotion(host,'simple_init')
        local saved,seen={manager,moving},{}
        local function remember()
            for _,o in pairs(manager.slots)do
                if not seen[o]then seen[o]=true;saved[#saved+1]=o end
            end
        end
        remember()
        local damageEvent=linked and{sourceInfo={7,234,300,17}}or nil
        host.inputs={paused=false,inhibitDefeat=false,motion={0,0,120*unit,80*unit,1,0}}
        local function advance()run.serial=run.serial+1;body.step(host);remember()end
        body.core.enable(host,true)
        if timeout then host.raw[0x267c]=0 end
        advance()
        local prior=manager.slots[1]
        if not timeout then
            assert(prior.mode=='second')
            host.boxes[1].damage(host.boxes[1],738688,damageEvent)
            assert(prior.closed,'自弹过阈值后旧主任务没有立即清除')
            advance()
        end
        assert(host.phase==1 and host.raw[0x2694]==(timeout and 2 or 1))
        assert(requests[1]=='cancel'and requests[2]=='gun'and requests[3]=='task'and #requests==3,'换段消弹及撤销炮台/演出顺序不符')
        assert(host.motion==moving and not moving.closed,'换段错误清除了移动槽')
        local current=manager.slots[1]
        assert(current.mode=='change1'and host.invulnerable and not host.enabled)
        assert(host.boxes[1].hitEffect==37 and not host.boxes[1].colli)
        -- 单独提供演出完成条件，核对末状态解除无敌、后槽同一步初始化及参数回收。
        current.vars[0],current.vars[4],current.vars[36]=3,0,0
        advance()
        assert(current.closed and manager.slots[2].mode=='second')
        assert(not host.invulnerable and host.raw[0x263c]==0 and host.request==nil)
        host.boxes[1].damage(host.boxes[1],523392,damageEvent)
        assert(host.phase==2 and manager.slots[1].mode=='change2_init')
        assert(requests[4]=='cancel'and requests[5]=='gun'and requests[6]=='task'and #requests==6)
        advance()
        current=manager.slots[1]
        assert(current.mode=='change2'and host.invulnerable)
        current.vars[0],current.vars[4],current.vars[36]=4,0,0
        host.raw[0x21f8]=2
        advance()
        assert(current.closed and manager.slots[2].mode=='third')
        assert(not host.invulnerable and host.raw[0x263c]==0)
        assert(host.motion==moving and manager.pool==moving.pool)
        if finalTimeout then
            host.raw[0x2684]=0;advance()
        else
            host.boxes[1].damage(host.boxes[1],545664,damageEvent)
            assert(manager.slots[1].mode=='defeat_init');advance()
        end
        assert(host.raw[0x2634]==1 and host.hp==0 and not host.enabled)
        assert(requests[7]=='cancel'and requests[8]=='prepare'and requests[9]=='gun'and requests[10]=='task')
        current=manager.slots[1]
        assert(current.mode=='defeat'and current.vars[56]==0 and host.rootFlag96==0)
        assert(host.motion==moving and not moving.closed)
        -- 此处只验证退休信号回收联动；完整击破时序由独立原版样本覆盖。
        current.vars[0],current.vars[24]=40,-1
        advance()
        assert(host.closed and host.retireRequested and manager.closed and moving.closed)
        host.transitionObjects=saved
        body.close(host);body.close(host)
        for i=0,399 do assert(not host.nativeParameters.used[i],'换段联动泄漏共享参数块')end
    end
    run(false);run(true);run(false,true);run(true,false,true)
    return objects
end
