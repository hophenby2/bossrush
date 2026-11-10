-- 在隔离发行目录中驱动所有原作机体，真实创建自机弹、道具并走原生渲染和碰撞。
local T={}
function T.install()
    SaveResume.INTERVAL=math.huge
    scoredata.PlayerBrand='顺序自机隔离验证';scoredata.version=ui.version
    local entries,index,frames,done={},0,0,false
    local results,errors={},{}
    local current
    local drops,hits,killed={},{},{}
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
        index=index+1;current=entries[index];frames=0;drops={};hits={};killed={};opening={}
        if not current then done=true;save();return end
        setupOpening()
        OriginalSequence.start(current.key,current.machine)
    end
    function GetInput()
        input()
        if current then
            KeyState.shoot=probe~='background';KeyState.slow=math.floor(frames/120)%2==1
            KeyState.spell=not probe and (frames==30 or frames==400)
            KeyState.left=false;KeyState.right=false;KeyState.up=false;KeyState.down=false
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
                    for _,e in ipairs(probe and {{10,'th10_lunatic'}} or {{6,'th06_lunatic'},{7,'th07_lunatic'},{8,'th08_lunatic_b'},{10,'th10_lunatic'},{95,'th095_scenes'}}) do
                        for _,m in ipairs(SequenceResources.machines(e[1])) do entries[#entries+1]={key=e[2],machine=m.id,game=e[1]} end
                    end
                    if probe and probe~='opening' then for i=#entries,2,-1 do entries[i]=nil end end
                    launch();break
                end
                if current and SequenceResources.state() and not stage.next_stage then
                    frames=frames+1
                    if player and IsValid(player) then player.protect=600 end
                    local s=SequenceResources.state()
                    if frames==1 then
                        s.power=probe=='opening' and 0 or s.game==10 and 80 or 128;SequenceResources.sync()
                        if probe=='opening' then player.x=-144 end
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
                    if probe=='drops' and frames>=200 and frames<=900 and frames%20==0 then
                        object.EnemyNontjtDo(function(o)
                            if IsValid(o) and o._original_source and not o.protect and o.hp>0 and not o._bosssys then
                                killed[#killed+1]=o._original_source.key
                                Damage(o,o.hp+1)
                            end
                        end)
                    end
                    if frames>=1000 then
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
                            drops=drops,hit_sources=hits,killed=killed,opening=openingResult}
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
            if probe and current and frames>=300 and frames<312 then Snapshot('snapshot/probe-'..frames..'.png') end
            if current and frames>=500 and frames<520 then
                Snapshot('snapshot/sequence-'..current.game..'-'..current.machine..'.png')
            end
        end,debug.traceback)
        if not ok then errors[#errors+1]=err;done=true;save() end
    end
end
return T
