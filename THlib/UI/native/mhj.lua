-- 原作 SpecialSystem.Draw 的 SpriteBatch 出口；沿用原始切片、动画、数字与进度。
return function(level,CS)
    local batch={}
    local z,ox,oy,height=1,0,0,480
    local blend=''
    local function draw(shape,p,r,c,rot,origin,scale)
        if not shape or not r or r.Width<=0 or r.Height<=0 or c.a<=0 then return end
        local tex
        if shape=='37_bosslist' or shape=='39_hud_number' then
            tex='mhj_hud/'..shape
            if not CheckRes('tex',tex) then
                local pool=GetResourceStatus();SetResourceStatus('global')
                LoadTexture(tex,shape=='37_bosslist' and 'Resources/th37/bosslist.png' or 'Resources/th39/hud/number.png');SetResourceStatus(pool)
            end
        else tex=NativePlayers.visual.texture(shape) end
        origin=origin or CS.Vector2()
        scale=scale or 1
        local sx,sy=scale,scale
        if type(scale)=='table' then sx,sy=scale.X,scale.Y end
        local ca,sa=math.cos(rot or 0),math.sin(rot or 0)
        local color=Color(math.max(0,math.min(255,c.a*255)),c.r*255,c.g*255,c.b*255)
        local function vertex(x,y,u,v)
            x,y=(x-origin.X)*sx,(y-origin.Y)*sy
            return {ox+(p.X+x*ca-y*sa)*z,height-oy-(p.Y+x*sa+y*ca)*z,.5,u,v,color}
        end
        RenderTexture(tex,blend,vertex(0,0,r.X,r.Y),vertex(r.Width,0,r.X+r.Width,r.Y),
            vertex(r.Width,r.Height,r.X+r.Width,r.Y+r.Height),vertex(0,r.Height,r.X,r.Y+r.Height))
    end
    function batch:Begin(a,b) blend=(b or a)==1 and 'mul+add' or '' end
    function batch:End() end
    function batch:Draw(a,b,c,d,e,f,g)
        -- 永夜 NSpriteBatch 另有首参数为颜色的重载。
        if type(a)=='table' and a.r then return draw(b,c,d,a,e,f,g) end
        return draw(a,b,c,d,e,f,g)
    end
    function batch:Sprite(o)
        local r=CS.copy(o.rect)
        if o.animation then
            local x,y=o.animation:GetXIndex(),o.animation:GetYIndex()
            if x<0 then return end
            r.X,r.Y=r.X+x*r.Width,r.Y+y*r.Height
        end
        draw(o.shape,o.position,r,o.color,o.rotation,o.origin,o.scale)
    end
    function batch:Circle(p,r,w,start,arc,c)
        if arc<=0 then return end
        SetImageState('white','',Color(c.a*255,c.r*255,c.g*255,c.b*255))
        local x,y=ox+p.X*z,height-oy-p.Y*z
        local n=math.max(1,math.ceil(arc/8))
        for i=1,n do
            local a,b=start+arc*(i-1)/n,start+arc*i/n
            Render4V('white',x+(r-w)*z*cos(a),y+(r-w)*z*sin(a),.5,
                x+r*z*cos(a),y+r*z*sin(a),.5,
                x+r*z*cos(b),y+r*z*sin(b),.5,
                x+(r-w)*z*cos(b),y+(r-w)*z*sin(b),.5)
        end
    end
    function batch:DrawSpriteNumberWithShadow(shape,chars,onRight,p,align,c,scale)
        local function pass(dx,dy,color)
            local x=p.X+(onRight and -chars.Length*27*scale or 0)+dx
            for i=0,chars.Length-1 do
                local ch=chars[i]==':' and 58 or chars[i]
                if type(ch)=='number' and ch>=48 and ch<=58 then
                    draw(shape,CS.Vector2(x,p.Y+dy),CS.Rectangle((ch-48)*27,0,27,39),color,0,nil,scale)
                end
                x=x+27*scale
            end
        end
        for _,offset in ipairs({{-1,0},{0,-1},{1,0},{0,1},{-1,-1},{1,-1},{1,1},{-1,1},
            {-2,0},{0,-2},{2,0},{0,2},{-2,-1},{-1,-2},{2,-1},{1,-2},{2,1},{1,2},{-2,1},{-1,2}}) do
            pass(offset[1],offset[2],CS.Colors(0,0,0,c.a*c.a))
        end
        pass(0,0,c)
    end
    function batch:transform(x,y,scale,h) ox,oy,z,height=x,y,scale,h;blend='' end
    if level==37 then batch:transform(240,0,1.5,1080) end
    return batch
end
