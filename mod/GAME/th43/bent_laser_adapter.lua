-- EIS 曲线激光的样式编号不是纹理名。为宿主注册独立样式，保留颜色行、节点和消失绘制。
-- 协议依据：THEIS 10b2fb77/code/data/THlib/laser/bentlaser.lua，Add_bentlaser_texture[_16]。
return function(base,texture,image)
    local styles,envelopes={},{}
    local M={}
    local function register(id,tex,w,h,rows)
        local key='th43/bent/'..type(id)..':'..tostring(id)
        local dh=h/rows
        styles[id]=key
        local function draw(o,alpha)
            o.data:Render(tex,o._blend,Color(o._a*alpha,o._r,o._g,o._b),0,
                rows==16 and (o.index-1)*dh or 0,w,dh)
        end
        base.RenderFunc[key]=function(o)
            draw(o,o.alpha)
            if o.timer<o._l*4 and o.node then
                SetImageState(o.img4,o._blend,o._a,o._r,o._g,o._b)
                Render(o.img4,o.prex,o.prey,-3*o.timer,(8+o.timer%3)*.125*o.node/8)
                Render(o.img4,o.prex,o.prey,-3*o.timer+180,(8+o.timer%3)*.125*o.node/8)
            end
        end
        base.RenderFuncDeath[key]=function(o) draw(o,1-o.timer/30) end
    end
    function M.addTexture(id,tex)
        tex=texture(tex)
        local w,h=GetTextureSize(tex)
        register(id,tex,w,h,1)
    end
    function M.addTexture16(id,tex,w,h) register(id,texture(tex),w,h,16) end
    function M.addEnvelope(id,...)
        local values={...};envelopes[id]=#values>0 and values or nil
    end
    function M.init(o,index,x,y,len,width,style,node)
        base.init(o,index,x,y,len,width,styles[style] or style,node)
        o.img4=image('preimg'..index)
        local envelope=envelopes[style]
        if envelope then o.data:SetEnvelope(unpack(envelope)) end
    end
    return M
end
