-- 生命周期只释放触点；开关状态和暂停菜单各自保留自己的恢复责任。
return function(pauseCache,resetClock)
    local focused,pausedMusic=true,{}
    return function(active)
        if active==focused then return end -- Activity、音频焦点和引擎可能重复通知。
        focused=active
        if not active then
            if GameNet and GameNet.active() then GameNet.togglePause(true) end
            if SaveResume then SaveResume.flush('切到后台') end
            pauseCache.invalidate()
            AndroidInput.reset(true)
            if ext and not ext.StageIsMenu() and ext.pause_menu and ext.pause_menu:IsKilled() then
                ext.pop_pause_menu=true
            end
            for _,name in ipairs(EnumRes2('bgm')) do
                if GetMusicState(name)=='playing' then pausedMusic[name]=true;PauseMusic(name) end
            end
            if scoredata then SaveScoreData();SaveSpellCardData() end
            return
        end
        resetClock()
        local menu=ext and ext.pause_menu
        local menuOwns=menu and not ext.StageIsMenu() and not ext.sc_pr
            and (ext.pop_pause_menu or not menu:IsKilled())
        for name in pairs(pausedMusic) do
            local state=GetMusicState(name)
            if state and state~='stopped' then
                if menuOwns then
                    -- 暂停先于/晚于失焦均可；继续时由菜单恢复，不能漏记已被失焦暂停的曲目。
                    menu.focus_bgmlist=menu.focus_bgmlist or {}
                    menu.focus_bgmlist[name]=true
                    if not menu:IsKilled() then
                        -- FlyIn已打开菜单但PauseSound协程尚未推进时，两条路径都需保留。
                        menu.bgmlist=menu.bgmlist or {}
                        menu.bgmlist[name]=true
                    end
                else ResumeMusic(name) end
            end
        end
        pausedMusic={}
    end
end
