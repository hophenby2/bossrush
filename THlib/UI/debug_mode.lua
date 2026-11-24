-- 调试入口只在标题菜单前台识别；状态仅保留本次进程，不写入存档或录像。
-- 用按下沿计数，避免长按8产生的重复KEYDOWN被当成五次输入。
local D={enabled=not (AndroidPlatform and not BossRushDesktop),count=0,age=0,down=false}
local REQUIRED,GAP=5,120
function D.bind(title)
    D.title=title;D.count,D.age,D.down=0,0,false
end
function D.frame(title)
    -- main_menu 也用于子菜单；它们不能覆盖标题的按键边沿与前台状态。
    if title~=D.title then return end
    local down=GetKeyState(KEY['8'])
    D.titleActive=title.alpha>0 and not title.locked
    if not D.titleActive or D.enabled then
        D.count,D.age=0,0
    else
        local key=GetLastKey()
        D.age=D.age+1
        if D.age>GAP or (key~=KEY.NULL and key~=KEY['8']) then D.count=0 end
        if down and not D.down then
            D.count,D.age=D.count+1,0
            if D.count>=REQUIRED then
                D.enabled=true;D.count=0
                title.on_debug_unlocked()
                PlaySound('extend')
            end
        end
    end
    D.down=down
end
-- 键盘与触屏共用本局无敌开关，显示也读取cheat，不另存一份按钮状态。
function D.canToggleCheat()
    return D.enabled and stage and stage.current_stage and not stage.current_stage.is_menu
        and ext and not ext.replay.IsReplay()
end
function D.toggleCheat()
    if not D.canToggleCheat() then return false end
    cheat=not cheat
    lstg.var.cheat=cheat
    return true
end
-- 横屏手机没有数字键时，连续点主菜单右下角版本号等价于输入8。
function D.touchKey(x,y)
    local right=screen and screen.width or 960
    local width=ui and ui.version and math.max(38,#ui.version*8) or 38
    if not D.enabled and D.titleActive and x>=right-width and x<=right and y>=0 and y<=26 then return KEY['8'] end
end
return D
