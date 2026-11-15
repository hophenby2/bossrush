-- 敌弹对象保留 PGM 的出生坐标、碰撞盒、速度向量及后续速度变化。
local abs = math.abs

local function create(source)
    local M = {}
    local function setVisual(o, visual)
        o.image, o.offsetX, o.offsetY, o.contact = visual[2],visual[4],visual[3],visual[5]
        o.colli=o.contact and not o.fade
    end
    local Bullet = Class(object, {
        init = function(o, run, shot)
            o.run, o.shot, o.age, o.change = run, shot, 0, 1
            o.x, o.y = source.world(shot.x, shot.y)
            o.stepX, o.stepY = shot.dy/64, shot.dx/64
            if shot.aimed and IsValid(player) then
                -- 对照轨迹留下原来一波内的角差，再套在本局的自机方向上。
                local angle = Angle(o.x, o.y, player.x, player.y) - Angle(o.x, o.y, source.aimX or -50, source.aimY or -168.4375)
                o.aimAngle, o.cosAim, o.sinAim = angle, cos(angle), sin(angle)
                o.stepX, o.stepY = o.stepX*o.cosAim-o.stepY*o.sinAim, o.stepX*o.sinAim+o.stepY*o.cosAim
            end
            o.a, o.b, o.rect = shot.b, shot.a, true
            o.group, o.layer = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET
            o.bound, o.colli = false, true
            if shot.visuals then
                setVisual(o,shot.visuals[1])
                o.visual=2
            end
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial = o.run.serial
            o.age = o.age + 1
            if o.fade then
                o.fade = o.fade-1
                if o.fade == 0 then object.RawDel(o); return end
            end
            if o.shot.life and o.age >= o.shot.life and not o.fade then object.RawDel(o); return end
            local change = o.shot.changes[o.change]
            if change and change[1] == o.age then
                local dx, dy = change[3]/64, change[2]/64
                if o.cosAim then dx, dy = dx*o.cosAim-dy*o.sinAim, dx*o.sinAim+dy*o.cosAim end
                o.stepX, o.stepY, o.change = dx, dy, o.change+1
            end
            local visual = o.visual and o.shot.visuals[o.visual]
            if visual and visual[1]==o.age then
                setVisual(o,visual)
                o.visual=o.visual+1
            end
            o.x, o.y = o.x+o.stepX, o.y+o.stepY
            if abs(o.x) > 160 or abs(o.y) > 270 then object.RawDel(o) end
        end,
        render = function(o)
            local sprite = (o.run.imageAtlas or source.image)[o.image or o.shot.image]
            if not sprite then return end
            local alpha = o.fade and o.fade*17 or 255
            SetImageState(sprite[1], '', alpha, 255, 255, 255)
            if o.offsetX then
                Render(sprite[1],math.floor(o.x+o.offsetX/64)+sprite[2]/2,
                    math.floor(o.y+o.offsetY/64)+sprite[3]/2)
            else
                Render(sprite[1],o.x,o.y,o.aimAngle or 0)
            end
        end,
    })

    function M.emit(run, shot)
        local enemy = run.actors[shot.owner]
        if shot.owner ~= 0 and (not IsValid(enemy) or enemy.hp <= 0) then return end
        local o = New(Bullet, run, shot)
        -- 出生当帧的位置已经是抓取帧结束时的位置。
        o.serial = run.serial
    end

    function M.clear(run, discard)
        for _, o in ObjList(GROUP.ENEMY_BULLET) do
            if o.run == run then
                if discard then object.RawDel(o)
                elseif not o.fade then o.fade, o.colli = 15, false end
            end
        end
    end
    M.Bullet = Bullet
    return M
end

return {create=create}
