-- 队友结界的挡弹范围取自正在显示的完整圆圈；破碎的 shield1 碎片不再挡弹。
return function(valid)
    local M={count=0}
    local circles={}
    local abs,min,max=math.abs,math.min,math.max

    function M.remove(b)
        if circles[b] then circles[b]=nil;M.count=M.count-1 end
    end

    function M.sync(b,s,p)
        if not s.controller.teammateProtection or s.controller.closed or s.dis
                or not p or p[16]~='paopao' or s.alpha<=0
                or s.wscale==0 or s.hscale==0 then
            M.remove(b)
            return
        end
        local circle=circles[b]
        if not circle then circle={};circles[b]=circle;M.count=M.count+1 end
        -- 与弹图共用中心、缩放和朝向，不额外写一份固定半径或保护时长。
        local heading=(s.Withspeedd and math.deg(math.atan2(s.my or 0,s.mx or 0))+90 or s.head or 0)-90
        local ca,sa=cos(heading),sin(heading)
        local ox,oy=(p[3]/2-p[5])*s.wscale,(p[4]/2-p[6])*s.hscale
        circle.state=s
        circle.x,circle.y=s.fx+ox*ca-oy*sa,s.fy+ox*sa+oy*ca
        circle.rx,circle.ry=abs(p[3]*s.wscale)/2,abs(p[4]*s.hscale)/2
        circle.ca,circle.sa=ca,sa
    end

    function M.intercept(s)
        if M.count==0 then return false end
        for b,circle in pairs(circles) do
            local shield=circle.state
            if not valid(b) or b.mhj~=shield or shield.controller.closed or shield.dis then
                M.remove(b)
            else
                -- 在线段与椭圆上求最近点，避免高速弹一帧跨过整个结界后直接命中。
                local bx,by=(s.previousX or s.fx)-circle.x,(s.previousY or s.fy)-circle.y
                local ex,ey=s.fx-circle.x,s.fy-circle.y
                local ca,sa=circle.ca,circle.sa
                local x,y=(bx*ca+by*sa)/circle.rx,(-bx*sa+by*ca)/circle.ry
                local dx=(ex*ca+ey*sa)/circle.rx-x
                local dy=(-ex*sa+ey*ca)/circle.ry-y
                local length=dx*dx+dy*dy
                local t=length>0 and max(0,min(1,-(x*dx+y*dy)/length)) or 0
                if (x+t*dx)^2+(y+t*dy)^2<=1 then return true end
            end
        end
        return false
    end
    return M
end
