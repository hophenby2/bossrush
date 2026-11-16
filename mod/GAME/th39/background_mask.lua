-- CrazyStorm 的 Cover 遮罩按层合并。使用同一套 UV 裁切矩形与椭圆。
local M={}
local function hasMask(o)
    return o.active and o.maskOn and o.maskType and o.maskType>0 and o.halfw>0 and o.halfh>0
end
local function figure(c,o,project)
    local x,y=project(o.x+c.offsetx,o.y+c.offsety)
    local rotation=o.Circle and 0 or -(o.degree or 0)
    local ca,sa=cos(rotation),sin(rotation)
    local w,h=o.halfw*2/3,o.halfh*2/3
    local edges={}
    if o.Circle then
        for i=1,32 do
            local a=(i-1)*360/32
            edges[i]={x+w*cos(a),y+h*sin(a)}
        end
    else
        for i,corner in ipairs({{-1,-1},{1,-1},{1,1},{-1,1}}) do
            local dx,dy=corner[1]*w,corner[2]*h
            edges[i]={x+dx*ca-dy*sa,y+dx*sa+dy*ca}
        end
    end
    return edges
end
function M.layers(c,project)
    local sources={}
    for _,o in ipairs(c.emitters) do
        if o.kind=='cover' then
            if not o.Deepbind and hasMask(o) then sources[#sources+1]=o end
            if o.Deepbind then
                for _,child in pairs(o.children) do
                    if hasMask(child) and child.bound_source and child.bound_source.alive then sources[#sources+1]=child end
                end
            end
        end
    end
    local result={}
    if #sources==0 then return result end
    for _,o in ipairs(sources) do
        o.maskPolygon=figure(c,o,project)
    end
    for _,s in ipairs(c.particles) do
        local layer=s.layerid
        if not result[layer] then
            local masks={}
            for _,o in ipairs(sources) do
                if o.parentid~=layer and o.maskMutex and #masks<8 then
                    masks[#masks+1]={o.maskType==1 and 2 or 1,o.maskPolygon}
                end
            end
            for _,o in ipairs(sources) do
                if o.parentid==layer and #masks<8 then masks[#masks+1]={o.maskType,o.maskPolygon} end
            end
            result[layer]=masks
        end
    end
    return result
end

local function cut(poly,a,b)
    local inside,outside={},{}
    local dx,dy=b[1]-a[1],b[2]-a[2]
    local last=poly[#poly]
    local plane=dx*(last[2]-a[2])-dy*(last[1]-a[1])
    for _,point in ipairs(poly) do
        local nextPlane=dx*(point[2]-a[2])-dy*(point[1]-a[1])
        if (plane>=0)~=(nextPlane>=0) then
            local t=plane/(plane-nextPlane)
            local cross={}
            for j=1,5 do cross[j]=last[j]+(point[j]-last[j])*t end
            cross[6]=point[6]
            inside[#inside+1]=cross
            outside[#outside+1]=cross
        end
        local half=nextPlane>=0 and inside or outside
        half[#half+1]=point
        last,plane=point,nextPlane
    end
    return inside,outside
end
local function partition(poly,mask,outside)
    local a=mask[#mask]
    for _,b in ipairs(mask) do
        local rest
        poly,rest=cut(poly,a,b)
        if #rest>=3 then outside[#outside+1]=rest end
        if #poly<3 then return end
        a=b
    end
    return poly
end
function M.draw(masks,tex,blend,poly)
    local visible,hidden={},{}
    if masks[1][1]==1 then hidden[1]=poly else visible[1]=poly end
    for _,mask in ipairs(masks) do
        local add=mask[1]==1
        local from,to=add and hidden or visible,add and visible or hidden
        local outside={}
        for _,piece in ipairs(from) do
            local inside=partition(piece,mask[2],outside)
            if inside then to[#to+1]=inside end
        end
        if add then hidden=outside else visible=outside end
    end
    for _,piece in ipairs(visible) do
        for j=2,#piece-1 do
            RenderTexture(tex,blend,piece[1],piece[j],piece[j+1],piece[j+1])
        end
    end
end
return M
