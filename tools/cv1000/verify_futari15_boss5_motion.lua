-- 将同一份独立原版状态用于 LuaJIT 检查及真正 Sub 对象的自动 frame。
return function(motion,host,reference)
    local b=host.raw or{}
    for at,value in pairs(reference.initial)do b[at]=value end
    host.raw=b
    host.run.serial=reference.steps[1][1]-1
    local randomIndex,randomValues=1,{}
    local effects={}
    local memory={}
    host.motionMemoryInput=function(_,mode,block,pool)
        if mode=='wander_init'then
            assert(#memory==2,'缺少共享参数池的外部字节')
            pool.write(block,48,2,memory[1]);pool.write(block,50,1,memory[2])
        end
    end
    host.motionParticle=function(_,...)effects[#effects+1]={...}end
    local driver=motion.create(host,reference.steps[1][2],reference.steps[1][9],function(limit)
        assert(randomValues[randomIndex]==limit,'移动随机上限不符')
        local value=assert(randomValues[randomIndex+1],'缺少原版移动随机返回')
        randomIndex=randomIndex+2
        return value
    end)
    for name,value in pairs(reference.initialVars)do driver[name]=value end
    local h,index=0,1
    local function add(n)h=(h*131+n)%16777213 end
    local function prepare()
        local r=assert(reference.steps[index])
        for i=1,#r[10],2 do b[r[10][i]]=r[10][i+1]end
        if driver.mode~=r[2]then motion.switch(driver,r[2],r[9])end
        host.run.serial=r[1]
        host.motionInput={r[4],r[5],r[6],r[7],r[8],r[12]}
        randomIndex,randomValues=1,r[11]
        effects={}
        memory=r[14]
    end
    local function check()
        local r=reference.steps[index]
        assert(driver.mode==r[3],'第 '..r[1]..' 帧移动入口不符：'..driver.mode..' / '..r[3])
        assert(randomIndex==#randomValues+1,'本步原版随机数没有用完')
        add(r[1]);add(assert(motion.entries[driver.mode]))
        for _,field in ipairs(reference.fields)do add(assert(b[field[1]]))end
        for _,name in ipairs(reference.variables[driver.mode]or{})do
            local value=assert(driver[name],name)
            if (driver.mode=='retreat'and driver.state==0 and name=='clock')or
               (driver.mode=='wander'and driver.turning==0 and name=='turnTarget')then value=0 end
            add(value)
        end
        assert(#effects==#r[13],'第 '..r[1]..' 帧退场粒子数量不符：'..#effects..' / '..#r[13])
        add(#effects)
        for i,row in ipairs(effects)do
            for j,n in ipairs(row)do
                assert(n==r[13][i][j],'第 '..r[1]..' 帧退场粒子参数不符：'..j..' '..n..' / '..r[13][i][j])
                add(n)
            end
        end
        if reference.checkpoints[index]then
            assert(h==reference.checkpoints[index],'第五面移动不符：第 '..r[1]..' 帧，校验 '..h..' / '..reference.checkpoints[index])
        end
        index=index+1
        if index>#reference.steps then
            assert(h==reference.hash and index-1==reference.states)
            motion.close(driver);motion.close(driver)
            return true
        end
    end
    return {prepare=prepare,check=check,driver=driver,index=function()return index end}
end
