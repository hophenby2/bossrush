-- ParticleBeginBullet：出生位置固定、2倍大小、8帧渐隐；不改变子弹判定和发弹随机流。
local N=...
local M={}
local palette={[0]=0,1,1,2,2,3,3,4,4,5,5,5,6,6,6,7}
local Renderer
local function release(run)
    run.birth_mists=nil
    local renderers=run.mist_renderers;run.mist_renderers=nil
    for _,o in pairs(renderers or {}) do if IsValid(o) then object.RawDel(o) end end
end
Renderer=Class(object,{
    init=function(o,run,add)
        o.run,o.add=run,add;o.bound,o.colli=false,false;o.group=GROUP.GHOST
        -- 原作先画加算弹/特效，再画普通弹，最后画普通特效。
        o.layer=LAYER.ENEMY_BULLET+(add and -1 or .5)
    end,
    render=function(o)
        for _,p in ipairs(o.run.birth_mists or {}) do if p.add==o.add then
            SetImageState(p.img,p.add and 'mul+add' or '',255-31*math.min(p.age,7),255,255,255)
            Render(p.img,p.x,p.y,p.rot,2,2)
        end end
    end,
    del=function(o) release(o.run) end,
},true)
function M.spawn(b)
    local run=b.run;local color=N.bullet_colors[b.type or 0] or 0
    local img=assert(N.images['bullet25_'..(palette[color] or 0)],'夏夜祭缺少原出生弹雾纹理')
    run.birth_mists=run.birth_mists or {};run.mist_renderers=run.mist_renderers or {}
    local add=b.blend==true;local key=add and 'add' or 'normal'
    if not IsValid(run.mist_renderers[key]) then run.mist_renderers[key]=New(Renderer,run,add) end
    -- 原StageData.Ran与MyRandom分开；用独立System.Random同型流取整数角度。
    run.mist_random=run.mist_random or {random=N.random(lstg.var and lstg.var.ran_seed or 371)}
    local rot=math.floor((N.pm(run.mist_random)+1)*180)
    run.birth_mists[#run.birth_mists+1]={img=img,x=b.x,y=b.y,add=add,age=0,rot=rot}
end
function M.tick(run)
    local rows=run.birth_mists
    if not rows then return end
    local j=1
    for i=1,#rows do
        local p=rows[i];p.age=p.age+1
        if p.age<=8 then rows[j]=p;j=j+1 end
    end
    for i=#rows,j,-1 do rows[i]=nil end
end
M.clear=release
return M
