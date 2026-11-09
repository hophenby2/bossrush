-- 真引擎中逐阶段比较 Lua 与批量原生判定；只在 contracts 诊断运行。
local T={}
function T.run()
    if not lstg.AndroidOriginalCollision then return end
    local C=OriginalCollision or dofile('THlib/bullet/original_collision.lua')
    local previousPlayer,previousMode=player,C.use_native
    local function run(native,bomb,game)
        C.use_native=native
        local hits=0
        local cls=Class(object,{
            init=function(o,g)
                o.group=g;o.x=10000;o.y=10000;o.a=3;o.b=5;o.rect=false;o.rot=37;o.colli=true;o.bound=false;o.hide=true
            end,
            colli=function() hits=hits+1 end,
        },true)
        local p=New(cls,GROUP.PLAYER);local b=New(cls,GROUP.ENEMY_BULLET)
        local enemy=New(cls,GROUP.ENEMY);local shot=New(cls,GROUP.PLAYER_BULLET)
        local actor=New(cls,GROUP.NONTJT)
        player=p;p.nextspell=bomb and 30 or 0
        C.bullet(b,8,3);C.unit(enemy,8,'performance-probe')
        actor._original_actor={game=7}
        actor._original_collision_game=game
        enemy._original_contact_box={14,18};enemy._original_damage_box={36,20}
        enemy._original_secondary_box={12,8};enemy._original_no_damage_during_bomb=bomb
        enemy._original_accepts_damage=not bomb;shot.dmg=7
        local rows={}
        local function capture()
            for _,o in ipairs({p,b,enemy,shot,actor}) do
                rows[#rows+1]=string.format('%.6f,%.6f,%.6f,%s,%s,%s',o.rot,o.a,o.b,tostring(o.rect),tostring(o.colli),tostring(o._original_collision_rot))
            end
        end
        C.begin();capture();C.shots();capture();C.secondary();capture()
        -- 碰撞中新进入消散的对象不得在 finish 中恢复判定。
        b.colli=false
        C.finish();capture()
        assert(shot.dmg==7 and not b.colli,'判定结束时复活了消散弹或改变了伤害')
        for _,o in ipairs({p,b,enemy,shot,actor}) do object.RawDel(o) end
        AfterFrame()
        return table.concat(rows,'|')..':'..hits
    end
    for _,bomb in ipairs({false,true}) do
        for _,game in ipairs({false,0,'8',true,7}) do
            assert(run(false,bomb,game)==run(true,bomb,game),'原作判定 Lua/原生阶段状态不一致')
        end
    end
    player=previousPlayer;C.use_native=previousMode
    lstg.SystemLog('BOSSRUSH_COLLISION_CHECK: Lua/原生主框、副框、Bomb免伤、actor判定与消散恢复一致')
end
return T
