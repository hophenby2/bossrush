-- 完整发行版引擎验证。通过原游戏的单卡流程构造Boss，执行before/init/frame/render/del、
-- 自机与使魔碰撞、击破/超时结算、对象池回收；不加载check_stage的桩件。
local T={}
function T.install()
    -- 独立验证目录不需要每120逻辑帧重写续玩文件；保留正常输入和计时钩子。
    SaveResume.INTERVAL=math.huge
    local limit=tonumber(os.getenv('TH3X_FRAMES')) or 0
    local speed=tonumber(os.getenv('TH3X_SPEED')) or 60
    local seed=tonumber(os.getenv('TH3X_SEED')) or 20261031
    local mode=os.getenv('TH3X_MODE') or 'timeout'
    local run_id=os.getenv('TH3X_RUN_ID') or 'manual'
    local flow=os.getenv('TH3X_FLOW') or 'single'
    local games=','..(os.getenv('TH3X_GAMES') or '31,32,33,34,35')..','
    local selection=','..(os.getenv('TH3X_CASES') or '')..','
    local entries,records,errors={}, {}, {}
    local started,complete=false,false
    local current,host,frames,settle=nil,nil,0,0
    local accumulator=0
    local original_render=RenderFunc
    local original_input=GetInput
    -- 正常游戏每逻辑帧渲染一次；加速验证也要按逻辑帧推进开场遮罩，
    -- 否则900帧截图仍停在第几帧的转场，不能用来判断ANM是否正确。
    local mask_frame=mask_fader.frame
    mask_fader.frame=function() end
    function GetInput()
        original_input()
        if started and current then
            KeyState.slow=math.floor(frames/240)%2==1
            KeyState.shoot=mode=='defeat';KeyState.spell=false
            KeyState.left=false;KeyState.right=false;KeyState.up=false;KeyState.down=false
        end
    end
    local log=assert(io.open('native-cards.jsonl','w'))
    scoredata.PlayerBrand='TH3X 原生验证';scoredata.version=ui.version
    local function write(kind,row)
        row.kind=kind;log:write(Serialize(row),'\n');log:flush()
    end
    local function state()
        return {expected=#entries,completed=#records,records=records,errors=errors,
            current=current and {id=current.cardId,level=current.level,frames=frames,phase=current.phase,peak=current.peak},
            seed=seed,mode=mode,flow=flow,version=lstg.GetVersionName(),limit=limit,run_id=run_id}
    end
    local function save(final)
        local f=io.open(final and 'native-result.json' or 'native-progress.json','w')
        -- Windows的外部进度读取可能短暂占用文件；观测文件的锁不能变成游戏错误。
        if not f then
            if not final then return end
            f=assert(io.open('native-result.retry.json','w'))
        end
        f:write(Serialize(state()));f:close()
    end
    local function fail(err)
        errors[#errors+1]={id=current and current.cardId,level=current and current.level,
            frame=frames,error=tostring(err)}
        write('error',errors[#errors]);save(true);complete=true
    end
    local function sample()
        local counts={bullets=0,actors=0,lasers=0,objects=GetnObj()}
        for _,group in ipairs({GROUP.ENEMY_BULLET,GROUP.ENEMY_BULLET2,GROUP.INDES}) do
            for _,o in ObjList(group) do if o.imgclass then counts.bullets=counts.bullets+1 end end
        end
        for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do
            for _,o in ObjList(group) do if o~=host then counts.actors=counts.actors+1 end end
        end
        current.unmapped_visuals=current.unmapped_visuals or {}
        for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT,GROUP.INDES,GROUP.GHOST}) do
            for _,o in ObjList(group) do
                if o.img=='servant' and not o._original_actor and not o._original_no_sprite then
                    local info=debug.getinfo(o.class.init,'Sl')
                    current.unmapped_visuals[info.short_src..':'..info.linedefined]=true
                end
            end
        end
        local kinds={}
        for _,o in ObjList(GROUP.LASER) do
            counts.lasers=counts.lasers+1
            local info=debug.getinfo(o.class.frame,'Sl')
            local key=info.short_src..':'..info.linedefined..':game'..tostring(o._native_laser_game)
                ..':state'..tostring(o.lw209_state)..':status'..tostring(o.status)
            kinds[key]=(kinds[key] or 0)+1
        end
        current.laser_kinds=kinds
        local rate=ext.GetFakeFPS()
        current.min_rate=math.min(current.min_rate or 1,rate)
        current.max_photos=math.max(current.max_photos or 0,host and IsValid(host) and (host.photo_hit_count or 0) or 0)
        for k,v in pairs(counts) do current.peak[k]=math.max(current.peak[k] or 0,v) end
        if host and IsValid(host) then
            current.positions[#current.positions+1]={frames,host.x,host.y,host.hp}
        end
        return counts
    end
    local function finish()
        if not current or current.recorded then return end
        current.recorded=true
        local remaining=sample()
        local row={id=current.cardId,level=current.level,name=current.title,frames=frames,
            target=current.target,peak=current.peak,positions=current.positions,
            rendered=current.rendered or 0,ended=current.ended,phase=current.phase,laser_kinds=current.laser_kinds,
            min_rate=current.min_rate,max_photos=current.max_photos,damage_attempts=current.damage_attempts or 0,
            cleanup=remaining,original_ecl=current.original_ecl}
        row.unmapped_visuals=current.unmapped_visuals
        records[#records+1]=row;write('card',row);save(false)
    end
    local function launch()
        for game=31,35 do if games:find(','..game..',',1,true) then
            local level=game-2
            for index,unit in ipairs(_sc_pr_table[level] or {}) do
                local card=unit.sc_group[1].card
                if selection==',,' or selection:find(','..card.card_id..',',1,true) then
                    local entry={key='TH'..game..':'..index,index=index,level=level,source='TH'..game,
                        cardId=card.card_id,title=unit.CardName,spell=card.is_sc,peak={},positions={},original_ecl=card.original_ecl}
                    entries[#entries+1]=entry
                    local init,del=card.init,card.del
                    card.init=function(b)
                        if current~=entry then
                            finish();current,host,frames=entry,b,0
                            entry.phase='init';entry.target=limit>0 and limit or card.t3
                            entry.damage_at=math.max(600,card.t2+180)
                            entry.survival=card.t1==card.t3
                            math.randomseed(seed+level*100000+index*7919);ran:Seed(seed+level*100000+index*7919)
                            write('start',{id=entry.cardId,level=level,name=entry.title,target=entry.target})
                        end
                        init(b);entry.phase='combat';save(false)
                    end
                    card.del=function(b)
                        if current==entry then
                            entry.ended=b.timeout and 'timeout' or 'defeat';entry.phase='cleanup'
                            entry.max_photos=math.max(entry.max_photos or 0,b.photo_hit_count or 0)
                        end
                        del(b)
                    end
                end
            end
        end end
        assert(#entries>0,'没有匹配的卡片')
        local battles=entries
        if flow=='grouped' then
            local byclass={};battles={}
            for _,entry in ipairs(entries) do
                local unit=_sc_pr_table[entry.level][entry.index]
                assert(#unit.sc_group==1,'组合验证不能静默漏掉多Boss卡')
                local cls=unit.sc_group[1].boss
                if not byclass[cls] then byclass[cls]={};battles[#battles+1]=entry end
                local list=byclass[cls];list[#list+1]=unit.sc_group[1].card
            end
            local previous_new=New
            New=function(cls,cards,...)
                local list=byclass[cls]
                if list and type(cards)=='table' and #cards==1 and cards[1]==list[1] then cards=list end
                return previous_new(cls,cards,...)
            end
            lstg.New=New
        end
        RogueTen.COUNT=#battles;RogueTen.MISS_LIMIT=1000000
        RogueTen.draw=function() return battles end
        lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
        RogueTen.start();started=true;save(false)
    end
    function FrameFunc()
        if complete then return true end
        local ok,err=xpcall(function()
            for _=1,speed do
                local completed_before=#records
                -- 与DoFrameEx相同的分数帧累计，缓时窗口要改变实际推进量。
                accumulator=accumulator+ext.GetFakeFPS()
                if accumulator>=1 then
                accumulator=accumulator-1
                if player and IsValid(player) then
                    player.protect=600
                    player.lock=false
                    -- 实际player.frame仍决定形态、位置和碰撞；通过正常输入切换高低速。
                end
                DoFrame()
                mask_frame(mask_fader)
                ext.achievement:frame();ext.MusicChange:frame()
                if not started and stage.current_stage and stage.current_stage.stage_name=='menu' then launch() end
                if current and host and IsValid(host) and host.is_combat and current.phase=='combat' then
                    frames=frames+1
                    if frames%120==0 or frames==1 then sample() end
                    if frames%1200==0 then save(false) end
                    if mode=='photo' and host.photo_damage_limit and frames%480==0 then
                        boss.take_damage2(host,1)
                    elseif mode=='cancel' and frames%240==0 then
                        -- 普通消弹走可消性和出生状态，不使用换卡的强制清场入口。
                        New(bullet_cleaner,0,0,640,0,1,true,true,0,0)
                    elseif mode=='defeat' and not current.survival and frames>=current.damage_at and frames%60==0 then
                        current.damage_attempts=(current.damage_attempts or 0)+1
                        Damage(host,host.hp*1000000)
                    end
                    if frames>=current.target then
                        current.phase='ending'
                        if limit>0 then host.hp=0
                        end
                    end
                end
                if current and host and not IsValid(host) then
                    current.phase='done';finish();host=nil
                end
                if started and #records==#entries then
                    settle=settle+1
                    if settle>=120 then complete=true;save(true);break end
                end
                -- 大批推进只改变验证的墙钟时间；在首帧、两个截图点和换卡边界交还真实渲染。
                -- 避免隐藏窗口的后台限帧让完整513卡验证花在等待窗口上。
                if #records~=completed_before or (current and current.phase=='combat' and
                    ((frames>=1 and (current.rendered or 0)==0) or
                     (frames>=300 and not current.captured) or (frames>=900 and not current.captured_late))) then break end
                end
            end
        end,debug.traceback)
        if not ok then fail(err) end
        return complete
    end
    function RenderFunc()
        if complete then return end
        local ok,err=xpcall(function()
            original_render()
            if current then
                current.rendered=(current.rendered or 0)+1
                if frames>=300 and not current.captured then
                    current.captured=true
                    Snapshot(('snapshot/th%d-%d-%s.png'):format(current.level+2,current.cardId,mode))
                end
                if frames>=900 and not current.captured_late then
                    current.captured_late=true
                    Snapshot(('snapshot/th%d-%d-%s-late.png'):format(current.level+2,current.cardId,mode))
                end
            end
        end,debug.traceback)
        if not ok then fail(err) end
    end
    GameExit=function() log:close() end
end
return T
