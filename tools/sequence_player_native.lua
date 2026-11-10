-- 在隔离发行目录中驱动所有原作机体，真实创建自机弹、道具并走原生渲染和碰撞。
local T={}
function T.install()
    SaveResume.INTERVAL=math.huge
    scoredata.PlayerBrand='顺序自机隔离验证';scoredata.version=ui.version
    local entries,index,frames,done={},0,0,false
    local results,errors={},{}
    local current
    local drops,hits,killed={},{},{}
    local audit={}
    local decision
    local background_wait=0
    local spawn,hit=SequenceResources.spawnItem,SequenceResources.hitEnemy
    SequenceResources.spawnItem=function(kind,...)
        local o=spawn(kind,...)
        if o then drops[kind]=(drops[kind] or 0)+1 end
        return o
    end
    SequenceResources.hitEnemy=function(o,...)
        hits[o._original_source and o._original_source.key or 'other']=true
        return hit(o,...)
    end
    local probe=os.getenv('SEQUENCE_PLAYER_PROBE')
    local opening={}
    local openingHooked=false
    local function setupOpening()
        if probe~='opening' or openingHooked then return end
        openingHooked=true
        local create=t10mid.spawn
        t10mid.spawn=function(...)
            local o=create(...)
            if o and #opening<10 then
                local row={o=o,key=o._original_source.key,born=frames,events={}}
                opening[#opening+1]=row;o.sequence_test_row=row
            end
            return o
        end
        local drop=SequenceResources.dropOriginalEnemy
        SequenceResources.dropOriginalEnemy=function(o)
            local row=o.sequence_test_row
            if row then row.killed=frames;row.y=o.y;row.drops_before={}
                for kind,n in pairs(drops) do row.drops_before[kind]=n end
            end
            local result=drop(o)
            if row then
                row.dropped={}
                for kind,n in pairs(drops) do
                    local delta=n-(row.drops_before[kind] or 0)
                    if delta>0 then row.dropped[kind]=delta end
                end
            end
            return result
        end
    end
    local render,input=RenderFunc,GetInput
    local function save()
        local f=assert(io.open('sequence-player-result.json','w'))
        f:write(Serialize{completed=#results,expected=#entries,results=results,errors=errors});f:close()
    end
    local function launch()
        index=index+1;current=entries[index];frames=0;drops={};hits={};killed={};opening={};audit={};decision=nil;background_wait=0
        if not current then done=true;save();return end
        setupOpening()
        OriginalSequence.start(current.key,current.machine)
    end
    function GetInput()
        input()
        if current then
            KeyState.shoot=probe~='background' and probe~='hud';KeyState.slow=math.floor(frames/120)%2==1
            KeyState.spell=not probe and (frames==30 or frames==400)
            KeyState.left=false;KeyState.right=false;KeyState.up=false;KeyState.down=false
            if probe=='audit' then
                KeyState.shoot=frames%90<45
                KeyState.left=frames%240<40;KeyState.right=frames%240>=80 and frames%240<120
                KeyState.up=frames%240>=160 and frames%240<180;KeyState.down=frames%240>=200 and frames%240<220
            end
            if probe=='decision' then KeyState.shoot=false;KeyState.slow=false;KeyState.spell=frames==354 end
            if probe=='bombs' then KeyState.slow=frames>=570 and frames<1050 or frames>=1530 end
            if probe=='continue' then
                KeyState.shoot=false;KeyState.slow=false
                local menu=stage.current_stage and stage.current_stage.sequence_continue
                if menu then KeyState.up=menu.time==34;KeyState.shoot=menu.time==39 end
            end
            if probe=='opening' and player then
                KeyState.slow=false
                for _,row in ipairs(opening) do
                    local o=row.o
                    if IsValid(o) and o.hp>0 then
                        KeyState.left=player.x>o.x+2;KeyState.right=player.x<o.x-2;break
                    end
                end
            end
        end
    end
    local mask=mask_fader.frame;mask_fader.frame=function() end
    function FrameFunc()
        if done then return true end
        local ok,err=xpcall(function()
            for _=1,(probe and frames>=300 and frames<312 and 1 or 20) do
                DoFrame();mask(mask_fader)
                if not current and index==0 and stage.current_stage and stage.current_stage.stage_name=='menu' then
                    for _,e in ipairs(probe and probe~='hud' and probe~='behavior' and probe~='continue' and probe~='bombs' and probe~='audit' and {{10,'th10_lunatic'}} or {{6,'th06_lunatic'},{7,'th07_lunatic'},{8,'th08_lunatic_b'},{10,'th10_lunatic'},{95,'th095_scenes'}}) do
                        for i,m in ipairs(SequenceResources.machines(e[1])) do
                            if (probe~='hud' and probe~='continue' or i==1) and (probe~='continue' and probe~='bombs' or e[1]~=95) then entries[#entries+1]={key=e[2],machine=m.id,game=e[1]} end
                        end
                    end
                    if probe=='decision' then
                        entries={}
                        for _,m in ipairs(SequenceResources.machines(8)) do entries[#entries+1]={key='th08_lunatic_b',machine=m.id,game=8} end
                    end
                    if probe and probe~='opening' and probe~='hud' and probe~='behavior' and probe~='continue' and probe~='bombs' and probe~='audit' and probe~='decision' then for i=#entries,2,-1 do entries[i]=nil end end
                    launch();break
                end
                if current and SequenceResources.state() and not stage.next_stage then
                    frames=frames+1
                    if player and IsValid(player) then player.protect=600 end
                    local s=SequenceResources.state()
                    -- 风神录续关会在本帧ResetPool，下一帧任务才重建背景。
                    if IsValid(stage.current_stage.sequence_background) then background_wait=0
                    else background_wait=background_wait+1 end
                    assert(background_wait<100,'当前机体开局没有重建原作背景')
                    if probe=='audit' and s.game~=95 then
                        local powers=s.game==10 and {0,19,20,39,40,59,60,79,80,99,100} or {0,7,8,15,16,31,32,47,64,96,128}
                        s.power=powers[math.min(#powers,math.floor(frames/80)+1)];SequenceResources.sync()
                        local count=0
                        for o in pairs(player.original_shots or {}) do if IsValid(o) then
                            count=count+1
                            assert(o.audit_post_x==nil or math.abs(o.x-o.audit_post_x)<.00001 and math.abs(o.y-o.audit_post_y)<.00001,('自机弹被引擎重复积分：帧%d, 位移%.3f/%.3f, 速度%.3f/%.3f, pause=%s'):format(frames,o.x-(o.audit_post_x or o.x),o.y-(o.audit_post_y or o.y),o.vx,o.vy,tostring(o.pause)))
                            assert(o.vm.data.archive==player.original_archive,'自机弹跨角色读取ANM')
                        end end
                        assert(count<=({[6]=80,[7]=96,[8]=128,[10]=128})[s.game],'超过原作自机弹池')
                        if frames%40==0 then audit[#audit+1]={frame=frames,power=s.power,slow=player.__slow_flag,shot_clock=player.original_shot_time,shots=count} end
                    end
                    if frames==1 then
                        s.power=probe=='opening' and 0 or s.game==10 and 80 or 128;SequenceResources.sync()
                        if probe=='opening' then player.x=-144 end
                    end
                    if probe=='hud' and frames==350 then
                        s.power=s.game==10 and 75 or 96;s.bombs=4;s.lives=3
                        s.points=42;s.stage_points=42;s.cherry=123450;s.cherry_max=400000;s.cherry_plus=49000;s.border=s.game==7 and 400 or 0
                        s.faith=234560;s.faith_timer=130;s.gauge=-8500;s.human=-85;s.time=1234
                        lstg.var.score=123456780;lstg.var.graze=456;SequenceResources.sync()
                    end
                    if (probe=='hud' or probe=='decision') and frames==120 and s.game~=95 then
                        local chapter=OriginalSequence.catalog.chapters(current.key,lstg.var.player_name)[1]
                        for _,row in ipairs(chapter.units) do
                            local part=row.unit.sc_group[1]
                            if row.role=='boss' and part.card.is_sc then
                                New(part.boss,{part.card});break
                            end
                        end
                    end
                    if probe=='decision' and frames==350 then
                        s.bombs=1;s.time=1000;player.protect=0;SequenceResources.collide(player,{})
                        assert(player.original_death_freeze,'符卡决死没有冻结弹幕')
                        decision={timer=stage.current_stage.timer,window=player.original_deathbomb,time=s.time}
                    elseif probe=='decision' and frames>350 and frames<355 then
                        assert(stage.current_stage.timer==decision.timer,'决死窗口仍推进关卡计时')
                        assert(player.original_deathbomb==decision.window-(frames-350),'决死输入窗口没有逐帧递减')
                    elseif probe=='decision' and frames==356 then
                        assert(s.bomb and player.death==0 and not player.original_death_freeze,'接受决死后未恢复正常帧')
                        assert(player.__slow_flag and stage.current_stage.timer>decision.timer,'决死后没有按原作切换形态并恢复关卡')
                        assert(s.bomb.time==2,'接受决死帧重复执行了自机更新')
                    end
                    if probe=='opening' then
                        for _,row in ipairs(opening) do
                            local o=row.o
                            if IsValid(o) and frames-row.born<5 then
                                row.events[#row.events+1]={age=frames-row.born,y=o.y,hp=o.hp,protect=o.protect,
                                    colli=o.colli,a=o.a,b=o.b,damage=o._original_damage_box,contact=o._original_contact_box}
                            end
                        end
                    end
                    if frames==60 and not probe then
                        SequenceResources.spawnItem('power',player.x,player.y)
                        SequenceResources.spawnItem('point',player.x,player.y)
                    end
                    if probe=='continue' and frames==120 then
                        s.lives=0;SequenceResources.miss(player);player.death=90;player.original_respawn=s.game==10 and 30 or 60
                    end
                    if probe=='bombs' and (frames==90 or frames==570 or frames==1050 or frames==1530) then
                        s.bombs=8;s.power=s.game==10 and 100 or 128
                        assert(SequenceResources.bombInput(player,{spell=true,slow=frames==570 or frames==1530},{spell=false},frames>=1050),'原作Bomb档位未施放')
                    end
                    if probe=='continue' and frames==280 then
                        assert(s.continues==1 and s.lives==2,'没有通过原作续关菜单恢复残机')
                        assert(not stage.current_stage.sequence_continue,'续关菜单未结束')
                        if s.game==10 then assert(lstg.var.sequence_run.road_time<100,'风神录续关没有重启当前道中') end
                    end
                    if probe=='drops' and frames>=200 and frames<=900 and frames%20==0 then
                        object.EnemyNontjtDo(function(o)
                            if IsValid(o) and o._original_source and not o.protect and o.hp>0 and not o._bosssys then
                                killed[#killed+1]=o._original_source.key
                                Damage(o,o.hp+1)
                            end
                        end)
                    end
                    if frames>=(probe=='bombs' and 2000 or 1000) then
                        if probe=='drops' then
                            assert(#killed>0,'没有击破真实道中敌机')
                            assert((drops.power or 0)+(drops.point or 0)+(drops.faith or 0)>0,'真实敌机击破未生成道具')
                        end
                        local openingResult={}
                        if probe=='opening' then
                            assert(#opening==10,'开场生成数必须为10')
                            for i,row in ipairs(opening) do
                                local kind=i==10 and 'faith' or i%2==1 and 'point' or 'power'
                                assert(row.killed and row.dropped and row.dropped[kind]==1,'开场第'..i..'只未被自机弹击破并生成原作道具')
                                local first=assert(row.events[1])
                                assert(first.damage[1]==24 and first.damage[2]==24 and first.contact[1]==16 and first.contact[2]==16,'开场第'..i..'只出生判定错误')
                                row.o=nil;openingResult[#openingResult+1]=row
                            end
                        end
                        results[#results+1]={game=current.game,machine=current.machine,frames=frames,
                            power=s.power,bombs=s.bombs,bomb_count=s.bomb_count,score=lstg.var.score,
                            drops=drops,hit_sources=hits,killed=killed,opening=openingResult,audit=audit}
                        save();launch();break
                    end
                end
            end
        end,debug.traceback)
        if not ok then errors[#errors+1]=err;done=true;save() end
        return done
    end
    function RenderFunc()
        local ok,err=xpcall(function()
            render()
            if probe=='bombs' and current then
                for i,start in ipairs({200,680,1160,1640}) do
                    if frames>=start and frames<start+20 then Snapshot('snapshot/bomb-'..current.game..'-'..current.machine..'-'..i..'.png') end
                end
            end
            if probe=='continue' and current and stage.current_stage.sequence_continue then Snapshot('snapshot/continue-'..current.game..'.png') end
            if probe=='behavior' and current and frames>=380 and frames<400 then Snapshot('snapshot/behavior-'..current.game..'-'..current.machine..'.png') end
            if probe=='audit' and current and frames>=940 and frames<960 then Snapshot('snapshot/audit-'..current.game..'-'..current.machine..'.png') end
            if probe and current and frames>=300 and frames<312 then Snapshot('snapshot/probe-'..frames..'.png') end
            if current and frames>=500 and frames<520 then
                Snapshot('snapshot/sequence-'..current.game..'-'..current.machine..'.png')
            end
        end,debug.traceback)
        if not ok then errors[#errors+1]=err;done=true;save() end
    end
end
return T
