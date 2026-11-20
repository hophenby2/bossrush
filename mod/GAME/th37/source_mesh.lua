-- Windows 原生网格适配：保持顶点、材质次序和 XNA 的变换顺序。
local M=dofile('mod/GAME/ports/source_mesh.lua')
function M.prepare(parts)
    local list={}
    local i=1
    while i<=#parts do
        local first=parts[i]
        local vertices={}
        -- 只合并连续的同材质部件，透明表面的先后次序不变。
        repeat
            local source=parts[i][3]
            for j=1,#source do vertices[#vertices+1]=source[j] end
            i=i+1
        until not parts[i] or parts[i].texture~=first.texture or parts[i][2]~=first[2]
        list[#list+1]={mesh=lstg.CreateSourceModelMesh(first.texture,vertices),bounds=M.bounds(vertices)}
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    return list
end
function M.transform(pos,scale,rotation,t)
    t=t or {}
    local cx,sx=math.cos(rotation[1]),math.sin(rotation[1])
    local cy,sy=math.cos(rotation[2]),math.sin(rotation[2])
    local cz,sz=math.cos(rotation[3]),math.sin(rotation[3])
    -- 原式为 (顶点 + 位移) * 缩放 * Rx * Ry * Rz，位移也经过缩放和旋转。
    t[1],t[2],t[3]=cy*cz*scale[1],cy*sz*scale[1],-sy*scale[1]
    t[4],t[5],t[6]=(sx*sy*cz-cx*sz)*scale[2],(sx*sy*sz+cx*cz)*scale[2],sx*cy*scale[2]
    t[7],t[8],t[9]=(cx*sy*cz+sx*sz)*scale[3],(cx*sy*sz-sx*cz)*scale[3],cx*cy*scale[3]
    t[10]=t[1]*pos[1]+t[4]*pos[2]+t[7]*pos[3]
    t[11]=t[2]*pos[1]+t[5]*pos[2]+t[8]*pos[3]
    t[12]=t[3]*pos[1]+t[6]*pos[2]+t[9]*pos[3]
    return t
end
function M.draw(list,t,tint,uv,blend,depth,cutout,cull,planes,batch)
    for _,part in ipairs(list) do
        if M.visible(part.bounds,t,planes) then
            M.queue(batch,part.mesh,t,tint,uv,blend,depth,cutout,cull)
        end
    end
end
return M
