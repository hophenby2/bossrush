-- 各原作 Character、Centeryidong、BaseMyPlane.Move 的输入优先级与边界。
local M={}
local profiles={
    [35]={-182,182,-213,197,math.sqrt(.5),'right'},
    [36]={(.74-4.5)*48,(8.25-4.5)*48,(-9.03+4.8)*48,(-.45+4.8)*48,.7071,'left'},
    [37]={(63-336)*2/3,(609-336)*2/3,(360-686)*2/3,(360-39)*2/3,math.sqrt(.5),'right'},
    [38]={-182,182,-208,200,.71},
}
function M.step(p,s,adapter)
    local key=p._playersys.keyState
    local profile=profiles[p.native_level]
    local dx,dy
    if profile and profile[6]=='right' then
        dx=key.right and 1 or key.left and -1 or 0
        dy=key.down and -1 or key.up and 1 or 0
    elseif profile and profile[6]=='left' then
        dx=key.left and -1 or key.right and 1 or 0
        dy=key.down and -1 or key.up and 1 or 0
    else
        dx=(key.right and 1 or 0)-(key.left and 1 or 0)
        dy=(key.up and 1 or 0)-(key.down and 1 or 0)
    end
    local fast,slow=p.hspeed,p.lspeed
    if adapter and adapter.speeds then fast,slow=adapter.speeds(p,s) end
    local v=p.slow==1 and slow or fast
    if p.lock then dx,dy=0,0 end
    if dx~=0 and dy~=0 then v=v*(profile and profile[5] or math.sqrt(.5)) end
    dx,dy=dx*v,dy*v
    if not p.lock and TouchInputMovement then
        local tx,ty=TouchInputMovement(p,p.key or KeyState,p.slow==1 and slow or fast)
        if tx then dx,dy=tx,ty end
    end
    local w=lstg.world
    local box=adapter and adapter.bounds and adapter.bounds(p,s) or profile or {w.pl+8,w.pr-8,w.pb+16,w.pt-32}
    p.x=math.max(box[1],math.min(box[2],p.x+dx))
    p.y=math.max(box[3],math.min(box[4],p.y+dy))
    p.__move_dx,p.__move_dy=dx,dy
end
return M
