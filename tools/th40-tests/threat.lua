-- 将独立原作随机流接到公共威胁工具的种子；读数仅记录，不改原作参数。
local run=dofile
dofile=function(path)
    if path=='tools/check_stage.lua' then
        local hook=STAGE_HOOK;local before=hook.on_card
        hook.on_card=function(index,entry)
            lstg.var.th38_seed=(tonumber(os.getenv('STAGE_SEED')) or 20260916)+index*7919
            return before(index,entry)
        end
        local frame=hook.on_frame
        hook.on_frame=function(index,t,bullets,objects)
            local all={};for _,b in ipairs(bullets) do all[#all+1]=b end
            for _,o in ipairs(objects) do
                if o._live~=false and o.mode=='bullet' and o.colli~=false and not o.th38_removed then
                    local b={};for k,v in pairs(o) do b[k]=v end
                    local a=o.direction*math.pi/180
                    b.vx=o.speed*math.cos(a)*o.scale_x;b.vy=-o.speed*math.sin(a)*o.scale_y
                    all[#all+1]=b
                end
            end
            return frame(index,t,all,objects)
        end
    end
    return run(path)
end
return run('tools/threat.lua')
