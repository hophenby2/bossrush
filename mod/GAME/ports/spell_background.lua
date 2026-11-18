-- 原作二维符卡背景：保留层的更新回调、原图尺寸、平铺UV与整体淡入淡出。
-- 先合成各层再应用alpha，减色/加算层不会直接污染道中背景。
return function(E,name,base)
    local C=base or Class(object)
    if not base then
        function C:init()
            self.group,self.layer,self.bound,self.colli=GROUP.GHOST,LAYER.BG,false,false
            self.alpha,self.layers=0,{}
        end
        function C:AddLayer(img,tile,x,y,rot,vx,vy,omiga,blend,hs,vs,init,frame,render)
            local l={img=img,tile=tile,x=x,y=y,rot=rot,vx=vx,vy=vy,omiga=omiga,
                blend=blend or '',hscale=hs or 1,vscale=vs or hs or 1,
                a=255,r=255,g=255,b=255,timer=0,frame=frame,render=render}
            self.layers[#self.layers+1]=l
            if init then init(l) end
            return l
        end
        C.addLayer=C.AddLayer
        function C:frame()
            for _,l in ipairs(self.layers) do
                l.x,l.y,l.rot=l.x+l.vx,l.y+l.vy,l.rot+l.omiga
                l.timer=l.timer+1
                if l.frame then l.frame(l) end
            end
        end
    end
    local pool=GetResourceStatus();SetResourceStatus('global')
    CreateRenderTarget(name);SetResourceStatus(pool)
    local function tile(l)
        local w,h=E.GetTextureSize(l.img)
        local world=lstg.world
        local cx,cy=w/2-l.x,h/2+l.y
        local c,s=cos(l.rot),sin(l.rot)
        local function point(x,y)
            local u,v=x/l.hscale,-y/l.vscale
            return {x,y,.5,cx+u*c-v*s,cy+u*s+v*c,Color(l.a,l.r,l.g,l.b)}
        end
        local key=E.lstg.CheckRes and E.lstg.CheckRes(1,'th43/'..l.img) and 'th43/'..l.img or l.img
        SetTextureSamplerState(key,'linear+wrap')
        E.RenderTexture(l.img,l.blend,point(world.l,world.t),point(world.r,world.t),point(world.r,world.b),point(world.l,world.b))
    end
    function C:render()
        if not setting.displayBG or self.alpha<=0 then return end
        SetViewMode('world')
        PushRenderTarget(name);RenderClearViewMode(Color(255,0,0,0))
        for i=#self.layers,1,-1 do
            local l=self.layers[i]
            if l.tile then
                if base and E.misc.RnderTileSCBG then
                    E.misc.RnderTileSCBG(l.img,l.blend,Color(l.a,l.r,l.g,l.b),l.x,l.y,l.rot,l.hscale,l.vscale)
                else tile(l) end
            else
                E.SetImageState(l.img,l.blend,Color(l.a,l.r,l.g,l.b))
                E.Render(l.img,l.x,l.y,l.rot,l.hscale,l.vscale)
            end
            if l.render then l.render(l) end
        end
        PopRenderTarget(name)
        local w=lstg.world;local c=Color(math.min(1,self.alpha)*255,255,255,255)
        local function v(x,y)
            local u,t=WorldToScreen(x,y)
            return {x,y,.5,u,t,c}
        end
        RenderTexture(name,'',v(w.l,w.t),v(w.r,w.t),v(w.r,w.b),v(w.l,w.b))
    end
    return C
end
