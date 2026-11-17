-- 0x124bd6 从当前火力档挂激光槽。0x124856 逐帧伸长，下一帧采用部件扫描得到的截点。
return function(program,art)
    local floor,min,max = math.floor,math.min,math.max
    local M = {}

    local function place(ray)
        local p = ray.pilot
        ray.h,ray.l = p.h + ray.mountH,p.l + ray.mountL
        ray.x,ray.y = program.world(ray.h,ray.l)
    end

    local function drawBeam(ray,sprites)
        local source,field = ray.source,ray.source.field
        local frame = floor((ray.age - 5) / 2) % 4 + 1
        local tipLength = min(ray.length,field[4])
        local bodyLength = ray.length - tipLength
        for base = 0,bodyLength-1,0x800 do
            local image = sprites[source.beam[frame]]
            local length = min(0x800,bodyLength - base)
            if length == 0x800 then
                art.draw(image,ray.h + base,ray.l,field[5],field[6],ray.mirror)
            else
                local x,y = program.world(ray.h + base + field[5],ray.l + field[6])
                local scale = length / 0x800
                Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] * scale / 2,
                    0,ray.mirror and -1 or 1,scale)
            end
        end
        if tipLength > 0 then
            art.draw(sprites[source.tip[frame]],ray.h + bodyLength,ray.l,field[7],field[8],ray.mirror)
        end
    end

    local Ray = Class(object,{
        init = function(ray,p,source,mount)
            ray.pilot,ray.source,ray.mountH,ray.mountL = p,source,mount[1],mount[2]
            ray.length,ray.width,ray.damage = unpack(source.field,1,3)
            ray.age,ray.mirror = 0,mount[2] < 0
            ray.group,ray.layer,ray.bound,ray.colli = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
            place(ray)
        end,
        render = function(ray)
            local assets = ray.pilot.run.art
            if not assets then return end
            if ray.age < 5 then
                local head = ray.source.heads[floor(ray.age / 2) % 2 + 1]
                art.draw(assets.sprites[head[1]],ray.h,ray.l,head[2],head[3],ray.mirror)
            else
                drawBeam(ray,assets.sprites)
            end
        end,
    })

    function M.spawn(p)
        local source = program.agehaLaser[p.form][p.power + 1]
        for i,mount in ipairs(source.mounts) do p.rays[i] = New(Ray,p,source,mount) end
    end

    function M.step(p)
        for _,ray in ipairs(p.rays) do
            place(ray)
            ray.age = ray.age + 1
            if ray.age >= 5 then
                if ray.hitStop then
                    ray.length,ray.capped = max(0x400,ray.hitStop - ray.h),false
                elseif ray.capped then
                    ray.length = max(0x400,0x7800 - ray.h)
                else
                    ray.length = ray.length + 0x800
                    ray.capped = ray.length >= 0x7800
                end
            end
        end
    end

    function M.clear(p)
        for i = #p.rays,1,-1 do
            object.RawDel(p.rays[i])
            p.rays[i] = nil
        end
    end

    return M
end
