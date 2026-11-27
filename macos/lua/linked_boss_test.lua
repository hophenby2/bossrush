-- 双子星真实挑战入口：强化伤害换算、双体受击、复活、血圈和原作条/粒子绘制。
local T={}
function T.install()
    ext.Debugging=function()end
    local spell=false
    GetInput=function()LoadSaveInputState({spell=spell})end
    local started,owner,c,route,wait=false,nil,nil,1,nil
    local samples,done,deathCase,deathPassed={},false,nil,0
    local frame,render=FrameFunc,RenderFunc
    local function bodies()
        local result={}
        for _,s in ipairs(c.entities)do if s.kind=='boss'then result[#result+1]=s.native end end
        return result
    end
    local function begin()
        local a,b=unpack(bodies())
        assert(c.linked and owner.hide and owner.protect and a~=owner and b~=owner,'独立身体未创建')
        assert(a.hp==5500 and b.hp==5500 and a.maxhp==5500 and b.maxhp==5500,'原生初始HP不符')
        local total=owner.hp
        Damage(owner,1e9);assert(owner.hp==total,'Bomb会重复伤害流程宿主')
        Damage(a,100);assert(a.hp<5500 and a.hp>0 and b.hp==5500,'强化模式伤害没有分别进入身体')
        local own=a.hp
        Damage(b,100);assert(a.hp==own and b.hp<5500 and b.hp>0,'副体伤害串给主血条')
        samples[route]={key=c.key,main_damage=5500-a.hp,partner_damage=5500-b.hp}
        Damage(a,1e9);assert(a.hp==0,'不能击破单体')
        wait=0
    end
    local function deathbomb(at)
        deathCase={at=at,frame=0,dead=lstg.var.dead}
        c.hostAppearance.protect=true
        for _,b in ipairs(bodies())do b.protect=true end
        lstg.var.upgrades.players[1].bombs=3
        player.protect=0
        cheat=false
        local contact=New(object)
        player._playersys:colli(contact);object.RawDel(contact)
        cheat=true
        assert(player.__deathbomb_pending and lstg.var.dead==deathCase.dead,'原生命中当帧已经记miss')
        spell=at==1
    end
    RenderFunc=function()
        local result=render()
        if c and wait and wait>10 and not done then
            local a,b=unpack(bodies())
            local ar,br=RogueBossHUD.rings[a],RogueBossHUD.rings[b]
            assert(ar and br and #RogueBossHUD.current==2,'双体独立血圈/底条未进入正式绘制')
            assert(ar.boss.hp==a.hp and br.boss.hp==b.hp,'血圈仍共用血量')
            if wait==100 then
                plus.CreateDirectory('snapshot');Snapshot('snapshot/linked-boss-'..route..'.png')
                -- 原作机体/练习模式用的两张Sprite条也走一次实际渲染。
                local enabled=RogueBossHUD.enabled;RogueBossHUD.enabled=function()return false end
                TH38.runtime.actor.render(a);TH38.runtime.actor.render(b)
                RogueBossHUD.enabled=enabled
                samples[route].rings,samples[route].originalBars,samples[route].bottomBars=true,true,2
            end
        end
        return result
    end
    FrameFunc=function()
        AndroidFocus=function()end
        if IsValid(player)then player.protect=60000 end
        local quit=frame()
        if not started and GameDebug.title and not GameDebug.title.locked and stage.current_stage.timer>90 then
            started=true
            local filters=RogueTen.defaultFilters('staged')
            local pool=RogueTen.buildPool(filters)
            local entry
            for _,bucket in ipairs(pool)do for _,e in ipairs(bucket.cards)do if e.cardId==38034 then entry=e end end end
            assert(entry,'挑战卡池缺少双子星')
            RogueTen.drawStages=function()return {entry}end
            lstg.var.player_name,lstg.var.rep_player='reimu_player','Reimu'
            assert(RogueTen.start('staged',filters))
        elseif started and stage.current_stage.stage_name=='RogueTwo@RogueTwo' then
            if not owner then
                for _,b in ipairs(boss_group)do
                    if IsValid(b)and b.asl_controller and b.asl_clock>95 then owner,c=b,b.asl_controller;deathbomb(1);break end
                end
            elseif deathCase then
                local d=deathCase;d.frame=d.frame+1
                if d.cooldown then
                    if d.at==8 then
                        deathCase=nil;c.hostAppearance.protect=false
                        for _,b in ipairs(bodies())do b.protect=false end
                        begin()
                    else deathbomb(d.at+1) end
                elseif d.frame==d.at then
                    assert(player.death==0 and not player.__deathbomb_pending and lstg.var.dead==d.dead,'原生第'..d.at..'帧决死失败')
                    assert(lstg.var.upgrades.players[1].bombs==2,'决死必须只消耗一雷')
                    deathPassed=deathPassed+1;d.cooldown=true;spell=false
                    task.Clear(player)
                    if IsValid(player._original_bomb)then object.RawDel(player._original_bomb)end
                else spell=d.frame+1==d.at end
            elseif wait then
                wait=wait+1
                local a,b=unpack(bodies())
                if wait<200 then assert(a.hp==0 and owner.hp>0,'单体提早复活或整卡提前结束')
                elseif wait==200 then
                    assert(a.hp==4500 and not c.linkReviving,'原生400tick复活错误')
                    assert(samples[route].rings and samples[route].originalBars,'没有经过实际绘制')
                    samples[route].revivalTicks=400
                    if route==1 then
                        TH38.runtime.clear(c);owner.hp=11000
                        c=TH38.runtime.controller(owner,'L/stage4/bossB/6');owner.asl_controller=c
                        route=2;begin()
                    else
                        Damage(a,1e9);Damage(b,1e9);wait=nil
                    end
                end
            elseif c.linkDefeated then
                assert(owner.hp==0,'双体都倒下仍不能结束')
                done=true
                local f=assert(io.open('User/linked-boss.json','wb'))
                f:write(Serialize({passed=true,platform='macOS Metal，共用逻辑',deathbombCases=deathPassed,samples=samples}));f:close()
                lstg.SystemLog('LINKED_BOSS_PASS: '..Serialize(samples));return true
            end
        end
        return quit
    end
end
return T
