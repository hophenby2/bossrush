-- 两作使用原版 UI 脚本，在各自的资源命名空间读取宿主的战斗账本。
return function(level)
    local bdb=level==41
    local root='THlib/UI/native/'
    local prefix='nativehud/'..level..'/'
    local folder=bdb and 'Resources/th43/ui/' or 'Resources/ports/theis/res/ui/'
    local env=setmetatable({}, {__index=_G})
    local api=setmetatable({}, {__index=lstg})
    env.lstg=api
    local function key(n)
        if n=='item_point_ui' then return 'th43/item_point_ui' end
        return prefix..n
    end
    local res={}
    function res:addTexture(n,path)
        if not CheckRes('tex',key(n)) then LoadTexture(key(n),folder..path:match('[^/]+$')) end
    end
    function res:addSprite(n,tex,...)
        if not CheckRes('img',key(n)) then LoadImage(key(n),key(tex),...) end
    end
    function res:setSpriteCenter(n,...) SetImageCenter(key(n),...) end
    local function nameAt(names,i) return type(names)=='table' and names[i] or names..i end
    function res:addSpriteSequence(names,tex,x,y,w,h,cols,rows)
        for i=1,cols*rows do self:addSprite(nameAt(names,i),tex,x+(i-1)%cols*w,y+math.floor((i-1)/cols)*h,w,h) end
    end
    function res:setSpriteSequenceCenter(names,w,h,...)
        for i=1,w*h do self:setSpriteCenter(nameAt(names,i),...) end
    end
    function res:setSpriteSequenceState(names,w,h,...)
        for i=1,w*h do SetImageState(key(nameAt(names,i)),...) end
    end
    local function noop() end
    res.load,res.Load=noop,noop
    res.AddSprite,res.AddTexture,res.SetSpriteCenter=res.addSprite,res.addTexture,res.setSpriteCenter
    api.ResourceSet={create=function() return res end,Create=function() return res end}
    api.Render=function(n,...) if n~='img_void' then return Render(key(n),...) end end
    api.RenderRect=function(n,...) return RenderRect(key(n),...) end
    api.SetImageState=function(n,...) if n~='img_void' and n~='' then return SetImageState(key(n),...) end end
    api.RenderTexture=function(n,...) return RenderTexture(key(n),...) end
    api.Class=function() return {} end
    env.Class=api.Class
    env.luaclass=function()
        local c={}
        function c.create() local o=setmetatable({},{__index=c});o:ctor();return o end
        return c
    end
    local function loadPart(f) return setfenv(assert(loadfile(root..f..'.lua')),env)() end
    env.EISlib={ui={PRELOAD=true}}
    env.ui={game={},camera={width=640,height=360,mode='16:9'},setCamera=noop,updateCamera=noop}
    env.menu={screen={width=640,height=360,mode=169}}
    env.SetViewMode=noop
    env.math=setmetatable({clamp=function(v,lo,hi) return math.max(lo,math.min(hi,v)) end},{__index=math})
    env.string=setmetatable({format_number=function(n)
        local v=tostring(math.floor(n))
        return (v:reverse():gsub('(%d%d%d)','%1,'):reverse():gsub('^,',''))
    end},{__index=string})
    local s
    local function val(k) return function() return s[k] or 0 end end
    local function graze() return lstg.var.graze or 0 end
    local sys={
        getScore=function() return lstg.var.score or 0 end,
        getLife=function() return bdb and math.floor(s.life/5) or s.life end,
        getBomb=function() return bdb and math.floor(s.bombs/5) or s.bombs end,
        getLifeChip=val('lifeChip'),getBombChip=val(bdb and 'bombFragments' or 'bombChip'),
        getTotalChain=val('dyeChain'),getChain=val('stageChain'),getTargetChain=val('dyeTarget'),
        checkChainAchieve=function() return s.dyeTarget and (s.stageChain or 0)>=s.dyeTarget end,
        getBonus=function() return bdb and math.max((s.difficulty or 4)*10000,s.pointrate or 0) or s.pointrate end,
        getBounsRateFromPointRate=function() return lstg.tmpvar.point_rate or 1 end,
        player={getGraze=graze,getTotalGraze=graze},record={getHighScore=function() return lstg.tmpvar.hiscore or 0 end},
    }
    env.system=sys
    env.difficultyIndex=function()
        return (s.difficulty==5 or ui.NativeHUD.isExtra()) and 6 or 4
    end
    if bdb then
        local power=TH43.runtime.env.system.PowerRank
        sys.PowerRank=setmetatable({
            getChip=val('rankChips'),getValue=val('rankValue'),getMaxValue=function() return 5000 end,
            getMaxRank=function() return 4 end,getMaxHyperChipLeft=function() return 6 end,
            getHyperChipLeft=val('hyperChips'),getHyperTime=function() return power.time or 0 end,
            getHitedCount=function() return 0 end,canHyper=function() return s.rank==3 and s.rankChips==6 end,
        },{__index=power})
        sys.getNextLifeBonusPointItemN=function()
            for _,n in ipairs(s.difficulty==5 and {1000,1600} or {1100,2300,3500,4700}) do
                if (s.points or 0)<n then return n end
            end
            return -1
        end
        local inter=loadPart('interpolation')
        env.require=function(n) if n=='etc.interpolation' then return inter end;return require(n) end
        loadPart('bdb_draw');loadPart('bdb_resources')
    end
    local original=loadPart(bdb and 'bdb' or 'theis')
    local rate,offset,hidden=0,0,60
    return {
        field=not bdb and function() original:damageBar(rate,offset) end or nil,
        boss=bdb and function(b,hp,time)
            local t=b.time_sc and 'gray' or b.is_sc and 'green' or 'blue'
            local g=env.ui.game
            api.Render('ui.game.boss.hpbar.bottom',320,352,0,.25)
            env.ui.drawProgressBar(g['boss_hp_bar_'..t],320,352,0,.25,.25,'',Color(0xffffffff),'left',hp)
            api.Render('ui.game.boss.hpbar.top',320,352,0,.25)
            for i=1,math.min(20,b.sc_left or 0) do api.Render('ui.game.boss.stage.mark2',464-6*i,347,0,.25) end
            env.ui.drawProgressBarS(g['hp_bar_'..t],320,7.5,0,.25,1,'centercut',hp)
            api.Render('ui.game.boss.pos',320+b.x*.75,1,0,.25)
            api.Render('ui.game.boss.attacktime.bg',175,343,0,.3)
            local x=env.ui.drawSpriteText(g.font1,('%02d'):format(math.min(99,math.floor(time))),182,332,0,.25,.25,'left')
            env.ui.drawSpriteText(g.font1,('.%02d'):format(math.floor(time*100)%100),x+1,333,0,.15,.15,'left')
        end,
        update=function(state)
            s=state;original.frame(original)
            if not bdb then
                local o=GameContent.ports[39].source.lastHitEnemy
                local live=o and IsValid(o) and o.maxhp and o.maxhp>0
                hidden=live and 0 or hidden+1
                local target=live and math.max(0,math.min(1,o.hp/o.maxhp)) or 0
                rate=target+(rate-target)*.8
                offset=hidden>=60 and math.max(-2,offset-4/60) or math.min(2,offset+.4)
            end
        end,
        frame=function() original.background(original) end,
        draw=function() if not bdb or not IsValid(lstg.tmpvar.th43_hide_hud) then original.render(original) end end,
    }
end
