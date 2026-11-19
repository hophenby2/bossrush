-- 同一进程通过实际练习入口往返，保留资源池与原作类缓存以重现跨作品问题。
local T={}
function T.install()
    ext.Debugging=function() end
    AndroidFocus=function() end
    local portrait=os.getenv('BOSSRUSH_MAC_TEST_PORTRAIT')=='1'
    if portrait then
        AndroidPortrait=assert(loadfile('android/portrait.lua'))()
        setting.androidPortrait=true
        AndroidPortrait.enabled=function() return stage.current_stage and not stage.current_stage.is_menu end
        AndroidPortrait.resetScreen=function()
            if not AndroidPortrait.enabled() then return false end
            screen.width,screen.height=540,960;screen.scale=setting.resy/960
            screen.dx=(setting.resx-540*screen.scale)/2;screen.dy=0
            return true
        end
    end
    local cases={}
    for _,level in ipairs({29,30,31,32,33,35,36,37,38,40,41}) do
        cases[#cases+1]={level=level};cases[#cases+1]={level=39}
    end
    local systems=os.getenv('BOSSRUSH_MAC_TEST_SUITE')~='cross'
    if systems then
        cases={}
        for _,level in ipairs({35,36,37,38,39,41}) do cases[#cases+1]={level=level} end
        for _,level in ipairs({35,36,37,38,39,41}) do
            cases[#cases+1]={level=level,chapter=true}
        end
    end
    local current,started=1,false
    local results={}
    local hostStar
    local draws,fields,shots={},{},{}
    if portrait then
        local lower=ui.NativeHUD.compact.lower
        function ui.NativeHUD.compact.lower(...)
            local index=stage.current_stage.practiceSystemsIndex
            if index then fields[index]=(fields[index] or 0)+1 end
            return lower(...)
        end
    end
    local render=RenderTexture
    function RenderTexture(name,...)
        if name=='native_source_37_grazebox' or name=='native_source_39_spscore' then
            local index=stage.current_stage.practiceSystemsIndex
            if index then draws[index]=(draws[index] or 0)+1 end
        end
        return render(name,...)
    end
    local sound=lstg.PlaySound
    function lstg.PlaySound(name,...)
        assert(CheckRes('snd',name),'练习切换后缺少音效：'..name..'，前一作 '..tostring(cases[current-1] and cases[current-1].level))
        if name=='THEIS_plst00' then
            assert(CheckRes('snd',name)=='global','祈华梦自机音效仍依赖关卡资源池')
            shots[current]=(shots[current] or 0)+1
        end
        return sound(name,...)
    end
    local frame=FrameFunc
    function FrameFunc()
        local active=stage.current_stage
        AndroidInput.keys[setting.keys.shoot]=started and active and not active.is_menu
        if player and IsValid(player) then player.protect=120 end
        for _,b in ipairs(boss_group or {}) do if IsValid(b) and b.hp and b.hp>0 then b.hp=100000 end end
        if started and active and not active.is_menu then
            active.practiceSystemsIndex=current
            if not portrait and active.nativeHud and not active.nativeHud.probed then
                local h=active.nativeHud;local key=cases[current].level==41 and 'draw' or 'field'
                local field,index=h[key],current;h.probed=true
                if field then h[key]=function(...) fields[index]=(fields[index] or 0)+1;return field(...) end end
            end
            if systems and player and IsValid(player) and player.native_level==35 then
                local sakura=player.mhj_source.sakura
                if active.timer==5 then sakura.Power=sakura.hipower end
                if active.timer==45 then player.x,player.y=60,-100 end
                if active.timer==65 then player.x,player.y=-40,-60 end
            end
            if systems and player and IsValid(player) and player.native_level==37 and active.timer==5 then
                local lantern=player.mhj_source.lantern
                lantern.Power=math.floor(lantern.setting.HiPower/2)
            end
        end
        local quit=frame()
        local scene=stage.current_stage
        if scene and scene.is_menu and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked and not started then
            local tex,u,v,w,h=GetImageTextureRegion('star_big2')
            if not hostStar then hostStar={tex,u,v,w,h} end
            for i,value in ipairs({tex,u,v,w,h}) do assert(value==hostStar[i],'跨作品练习污染了宿主图片的图集参数') end
            assert(CheckRes('tex',tex),'宿主星形仍引用已释放的图集')
            local case=cases[current]
            local level=case.level
            if case.chapter==true then case.chapter=assert(dofile('mod/original_practice.lua').chapters(level)[1]) end
            local index=#_sc_pr_table[level]>0 and 1 or nil
            for i,u in ipairs(_sc_pr_table[level]) do
                if u.sc_group[1].card.is_sc then index=i;break end
            end
            assert(index,'缺少练习卡 '..level)
            lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
            lstg.var.sc_index,lstg.var.sc_group=index,{level,index}
            local machines=NativePlayers.machines(level)
            if case.chapter then
                OriginalSequence.start(case.chapter.route,machines[1].id,nil,case.chapter.chapter)
            else stage.group.PracticeStart('Spell Practice@Spell Practice',true,machines and machines[1].id) end
            started=true
            lstg.SystemLog('PRACTICE_SYSTEMS: 进入 '..level)
        elseif started and scene and not scene.is_menu and scene.timer>=100 then
            local level=cases[current].level
            local s=NativePlayers.state()
            assert(lstg.var.is_practice)
            local row={level=level,kind=cases[current].chapter and 'stage' or 'spell',sound=CheckRes('snd','THEIS_plst00')}
            if level==39 then assert((shots[current] or 0)>0,'祈华梦没有实际射击');row.shooting_sounds=shots[current] end
            if NativePlayers.machines(level) then
                assert(s and s.level==level)
                assert(portrait or level==40 or scene.nativeHud,'原作 HUD 未接入练习')
                if systems then
                    assert((fields[current] or 0)>0,'未绘制特殊系统 HUD '..level)
                    row.field_frames=fields[current]
                    if level==35 or level==37 then
                        assert((draws[current] or 0)>0,'特殊系统纹理未实际绘制 '..level)
                        row.system_draws=draws[current]
                    end
                    if level==35 then
                        local fx=assert(player.mhj_source.sakura.e29)
                        local count=0
                        for b,v in pairs(fx.controller.bullets) do if IsValid(b) then
                            assert(math.abs(b.x-player.x-v.fx+fx.opos.X)<.001 and math.abs(b.y-player.y+v.fy-fx.opos.Y)<.001,'粉色环的已有粒子没有跟随自机')
                            count=count+1
                        end end
                        assert(count>0,'没有生成粉色环');row.ring_particles=count
                        local fixed=assert(player.mhj_source.sakura.e30).controller
                        assert(not fixed.positionx and not fixed.positiony,'固定的屏幕效果被错误地平移')
                    end
                    plus.CreateDirectory('snapshot')
                    Snapshot('snapshot/practice-'..row.kind..'-'..level..'.png')
                end
            end
            results[#results+1]=row
            stage.group.ReturnToTitle(false,0)
            started=false;current=current+1
            if current>#cases then
                local f=assert(io.open('User/mac-test.json','wb'))
                f:write(Serialize({passed=true,portrait=portrait,cases=results}));f:close()
                lstg.SystemLog('BOSSRUSH_MAC_TEST: practice-systems 通过');return true
            end
        end
        return quit
    end
end
return T
