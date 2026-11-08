-- 调试入口只在标题菜单前台识别；状态仅保留本次进程，不写入存档或录像。
-- 用按下沿计数，避免长按8产生的重复KEYDOWN被当成五次输入。
local D={enabled=false,count=0,age=0,down=false}
local REQUIRED,GAP=5,120
function D.frame(title)
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
-- 横屏手机没有数字键时，连续点主菜单右下角版本号等价于输入8。
function D.touchKey(x,y)
    if not D.enabled and D.titleActive and x>=922 and x<=960 and y>=0 and y<=26 then return KEY['8'] end
end
return D
