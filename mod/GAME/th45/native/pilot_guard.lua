-- 0x131654 依次执行护罩展开、蓄力、放射和收束。碰撞槽与绘制共用原程序的炮口位置。
-- 差异 1：护罩蓄力的 IGS023 缩放由 LuaSTG 等比缩放绘制，判定框直接读取原表。
return function(program,art)
    local floor,min,max = math.floor,math.min,math.max
    local M = {}

    local function renderBeam(ray,sprites)
        local source,mirror = ray.source,ray.mountL < 0
        local index = floor(max(0,ray.age - 1) / 2)
        local function draw(frame,h)
            art.draw(sprites[frame[1]],h,ray.l,frame[2],frame[3],mirror)
        end
        local function drawCycle(row,h,frame)
            art.draw(sprites[row[3][frame]],h,ray.l,row[1],row[2],mirror)
        end
        if not ray.extending and not ray.fadeFrame then
            if source.start[index + 1] then draw(source.start[index + 1],ray.h) end
            return
        end
        local frame = 4 - ((index - #source.start) % 4)
        local fade = ray.fadeFrame
        if fade and not source.fadeHead[fade] then return end
        local endpoint = ray.h + ray.length
        if fade then draw(source.fadeHead[fade],ray.h)
        else drawCycle(source.head,ray.h,frame) end
        for offset = 0x800,14*0x800,0x800 do
            local h = ray.h + offset
            if h >= endpoint then break end
            if fade then draw(source.fadeBody[fade],h)
            else drawCycle(source.body,h,frame) end
        end
        if endpoint < 0x7800 then
            local h = max(endpoint,ray.h + (ray.damage == 0x90 and 0x1000 or 0x400))
            if fade then
                local tip = source.fadeTip[min(fade,#source.fadeTip)]
                if tip then draw(tip,h) end
            else drawCycle(source.tip,h,frame) end
        end
    end

    local Guard = Class(object,{
        init = function(o,p)
            o.pilot,o.data,o.phase,o.index = p,program.agehaGuard[p.form],'opening',0
            o.segments = {{h=p.h,l=p.l,damage=0x10}}
            o.group,o.layer,o.bound,o.colli = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
            o.x,o.y = p.x,p.y
        end,
        render = function(o)
            local p = o.pilot
            local assets = p.run.art
            if not assets then return end
            local frame = o.bubbleFrame
            if frame then
                local image = assets.sprites[frame[1]]
                local x,y = program.world(p.h+0x400+frame[2],p.l+frame[3])
                local scale = frame[8] / 128
                Render(image[1],floor(x)+image[2]/2,floor(y)+image[3]/2,0,scale,scale)
            else
                for _,ray in ipairs(o.segments) do renderBeam(ray,assets.sprites) end
            end
        end,
    })

    function M.begin(p,automatic)
        p.guardEnergy = max(0,p.guardEnergy - (automatic and 0x7d0 or 0x400))
        p.guard,p.guardCharge,p.protect = New(Guard,p),0x200,0xfe
    end

    function M.clear(p)
        if p.guard then object.RawDel(p.guard); p.guard = nil end
    end

    local function bubble(o,frame)
        local p,ray = o.pilot,o.segments[1]
        o.bubbleFrame = frame
        ray.h,ray.l = p.h,p.l
        ray.length,ray.back,ray.right,ray.left = unpack(frame,4,7)
    end

    local function fire(o)
        local p,charge = o.pilot,o.pilot.guardCharge
        local tier = charge >= 0x1000 and 4 or charge >= 0xaaa and 3 or charge >= 0x555 and 2 or 1
        o.phase,o.bubbleFrame,o.segments = 'beam',nil,{}
        for i,source in ipairs(o.data.levels[tier]) do
            local h,l,length,back,width,damage = unpack(source.field)
            o.segments[i] = {h=p.h+h,l=p.l+l,mountH=h,mountL=l,length=length,back=back,
                left=width,right=width,damage=damage,source=source,age=0}
        end
        p.protect = 0xff
        return 20
    end

    local function extend(ray,p)
        ray.h,ray.l = p.h + ray.mountH,p.l + ray.mountL
        if ray.extending then
            if ray.hitStop then
                ray.length,ray.capped = max(0x400,ray.hitStop-ray.h),false
            elseif ray.capped then
                ray.length = max(0x400,0x7800-ray.h)
            else
                ray.length = ray.length + 0x800
                ray.capped = ray.length >= 0x7800
            end
        end
        ray.age = ray.age + 1
        ray.extending = ray.age > #ray.source.start * 2
    end

    function M.step(p,held)
        local o = p.guard
        o.x,o.y = p.x,p.y
        if o.phase == 'opening' then
            local frame = o.data.opening[floor(o.index/2)+1]
            if frame then
                bubble(o,frame)
                o.index = o.index + 1
                return
            end
            o.phase,o.index = 'charge',0
        end
        if o.phase == 'charge' then
            if not held then return fire(o) end
            p.guardCharge = min(0x1000,p.guardCharge + 0xd)
            if p.guardEnergy < 4 then
                p.guardEnergy = 0
                return fire(o)
            end
            p.guardEnergy = p.guardEnergy - 4
            local index = floor(o.index/2)
            if index >= 64 then index = 56 + ((index - 56) % 8) end
            bubble(o,o.data.charge[index+1])
            o.index = o.index + 1
            return
        end
        for _,ray in ipairs(o.segments) do extend(ray,p) end
        if o.phase == 'beam' and o.segments[#o.segments].extending then
            p.guardCharge = max(0,p.guardCharge - 0x28)
            if p.guardCharge == 0 then o.phase,o.index = 'fade',0 end
        end
        if o.phase == 'fade' then
            local alive = false
            for i = #o.segments,1,-1 do
                local ray = o.segments[i]
                local frame = floor(o.index / ray.source.field[7]) + 1
                local row = ray.source.fadeHead[frame]
                if not row then table.remove(o.segments,i)
                else
                    ray.fadeFrame,ray.right,ray.left = frame,row[4],row[4]
                    alive = true
                end
            end
            if not alive then
                M.clear(p)
                p.protect = 0x5a
                return 22
            end
            o.index = o.index + 1
        end
    end

    return M
end
