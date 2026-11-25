-- 显式原生回归：原卡竹干生长、竹节、分枝，以及旋转长椭圆的实际碰撞。
local T={}
function T.install()
    ext.Debugging=function()end
    AndroidFocus=function()end
    local scene=stage.New('TheisBambooRegression')
    local env,point,originalNew
    local shots,beams,trees,owners={},{},{},{}
    local checks,hits=0,0
    local Point=Class(object,{
        init=function(o)o.group=GROUP.NONTJT;o.a,o.b=1,1;o.bound=false;o.hide=true end,
        colli=function()hits=hits+1 end,
    },true)
    local function near(a,b,label)
        assert(math.abs(a-b)<.002,label..': '..a..' / '..b)
        checks=checks+1
    end
    function scene:init()
        lstg.var.is_practice,lstg.var.cheat=true,true
        lstg.var.__hp_scale_version,lstg.var.__native_player_version=nil,nil
        ext.notUIdraw=true
        ui.ResourceLoading.state=nil
        ui.ResourceLoading.beforeFrame=function()return false end
        ui.ResourceLoading.afterFrame=function()end
        env=GameContent.ports[39].source
        env.difficulty=4
        local a,b=Rand(),Rand()
        a:Seed(739);b:Seed(739)
        local signs={}
        for _=1,512 do
            local sign=a:Sign();signs[sign]=true
            assert(sign==b:Int(0,1)*2-1,'随机方向或随机数消费次数不一致')
            assert(a:Float(-5,5)==b:Float(-5,5),'随机方向改变了后续随机序列')
        end
        assert(signs[-1] and signs[1] and not signs[4294967295],'随机方向没有覆盖正负分支')
        ran:Seed(739)
        NativePlayers.configure(39,'reimu')
        item._init_item(self)
        NativePlayers.spawn()
        player.protect=60000
        local state=NativePlayers.state()
        state.stageChain,state.stageBlue,state.enemiesCreated,state.enemiesKilled=0,0,0,0
        env._boss_table={}
        env.ext.sc_pr=true
        lstg.tmpvar._system_items={red=0,blue=0,green=0,night=0}
        originalNew=env.New
        env.New=function(class,...)
            local ok,caller=pcall(env.task.GetSelf)
            if not ok then caller=nil end
            local o=originalNew(class,...)
            local root=caller and owners[caller]
            if class==env._editor_class.s1_LSC_bamboo_spawn then
                local x,y=...
                root={o=o,x=x,y=y,frame=scene.timer,id=#trees+1};trees[#trees+1]=root
            end
            if root then owners[o]=root end
            if class==env._editor_class.s1_LSC_stick then
                local x,y,angle,len,t,width=...
                if root and caller==root.o then
                    local n=(root.mainCount or 0)+1;root.mainCount=n
                    near(len,math.max(40,80-8*(n-1)),'主干各节长度')
                    near(width,2.65-.175*(n-1),'主干各节宽度')
                    assert(angle>=75 and angle<=105,'主干方向超出原作范围')
                    near(x,root.endX or root.x,'主干连接x')
                    near(y,root.endY or root.y,'主干连接y')
                    root.endX,root.endY=x+len*cos(angle),y+len*sin(angle)
                end
                if root then root.beamCount=(root.beamCount or 0)+1 end
                beams[#beams+1]={o=o,x=x,y=y,angle=angle,len=len,t=t,width=width,tree=root}
            end
            return o
        end
        shots[1]=env.New(env._editor_class.s1_LSC_stick,-100,-100,90,80,15,2.65)
        shots[2]=env.New(env._editor_class.s1_LSC_stick,20,-100,45,80,15,2.65)
        -- 出生时 a=b=2，随后只增加 a，也必须保持椭圆。
        shots[3]=env.New(env._editor_class.s1_LSC_stick,60,40,0,80,15,.5)
        shots[4]=env.New(env._editor_class.s1_LSC_flat_ball,-100,-20,90,.9,15)
        point=New(Point)
    end
    scene.frame=function()if IsValid(player)then player.protect=60000 end end
    scene.render=function()SetViewMode('world');RenderClearViewMode(Color(255,0,0,0))end
    local function collide(o,along,across)
        point.x=o.x+along*cos(o.rot)-across*sin(o.rot)
        point.y=o.y+along*sin(o.rot)+across*cos(o.rot)
        hits=0;CollisionCheck(GROUP.NONTJT,GROUP.ENEMY_BULLET)
        return hits>0
    end
    local function collisionChecks()
        for _,o in ipairs(shots)do o.colli=false end
        for i=1,3 do
            local o=shots[i];o.colli=true
            assert(not collide(o,0,20),'竹干短轴之外出现圆形误判')
            assert(collide(o,32,0),'竹干长轴内漏判')
            -- 对照：旧的圆形映射会在同一位置误判，确认检查走了真实碰撞路径。
            o.rect=false
            assert(collide(o,0,20),'圆形对照未触发碰撞')
            o.rect='ellipse';o.colli=false
            checks=checks+3
        end
        local o=shots[4];o.colli=true
        assert(collide(o,0,10),'竹节短轴被错误缩成圆')
        assert(not collide(o,8,0),'竹节长轴之外误判')
        o.colli=false;checks=checks+2
    end
    GetInput=function()LoadSaveInputState({})end
    local frame,started=FrameFunc,false
    function FrameFunc()
        AndroidFocus=function()end
        for _=1,8 do
            local quit=frame()
            if not started and stage.current_stage.is_menu and stage.current_stage.timer>=90 and GameDebug.title and not GameDebug.title.locked then
                started=true;stage.Set('none','TheisBambooRegression')
            elseif stage.current_stage==scene then
                for _,b in ipairs(beams)do
                    local o=b.o
                    if IsValid(o) and o.class~=o.imgclass and o.hscale>0 then
                        -- 原作每帧 dh=len/21/t，中心每帧前进 len/2/t。
                        near(o.x,b.x+21*o.hscale/2*cos(b.angle),'竹干中心x')
                        near(o.y,b.y+21*o.hscale/2*sin(b.angle),'竹干中心y')
                        near(o.a,10*o.hscale,'竹干长轴')
                        near(o.b,4*b.width,'竹干短轴')
                        near(o.rot,b.angle,'竹干旋转')
                        assert(o.hscale<=b.len/21+.002,'竹干超过原作长度')
                    end
                end
                if scene.timer==40 then
                    collisionChecks()
                    plus.CreateDirectory('snapshot');Snapshot('snapshot/theis-bamboo.png')
                elseif scene.timer==60 then
                    for _,o in ipairs(shots)do object.RawDel(o)end
                    local class=env._editor_class['LSC1:Lunatic']
                    env.New(class,{class.cards[2]})
                elseif scene.timer==900 or scene.timer==1700 or scene.timer==2500 then
                    Snapshot('snapshot/theis-bamboo-grown-'..scene.timer..'.png')
                end
                for o,root in pairs(owners)do if IsValid(o) and o._master and IsValid(o._master) and owners[o._master] then
                    assert(owners[o._master]==root,'子对象串到了另一棵树')
                end end
                if scene.timer>=3300 then
                    assert(#trees==19,'原卡四波应生成4+5+5+5棵树')
                    assert(#beams==19*72+3,'原卡四波的主干/侧枝数量错误')
                    for _,root in ipairs(trees)do
                        assert(root.mainCount==9 and root.beamCount==72,'同一棵树缺失/串入主干或侧枝')
                    end
                    env.New=originalNew
                    local f=assert(io.open('User/theis-bamboo.json','wb'))
                    f:write(Serialize({passed=true,trees=#trees,beams=#beams,checks=checks}));f:close()
                    return true
                end
            end
            if quit then return quit end
        end
    end
end
return T
