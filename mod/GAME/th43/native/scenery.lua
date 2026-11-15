-- 一面飞离的甲板与展开的机翼。原程序只把它们登记到绘制队列。
return function(program, path, remove)
    local band = require('bit').band
    local s16, word = program.s16, program.word
    local M = {}

    function M.init(o)
        local s = o.state
        o.wait, o.offsetH, o.offsetL = word(s,0x18),0,word(s,0x1a)
        o.picture, o.nextPicture, o.clock = 15,15,s[0x1c] or 0
        o.group = GROUP.GHOST
    end

    function M.step(o)
        local run = o.run
        if not path.step(o) then remove(o); return end
        if o.kind == 0x8d then
            if run.major >= 0x176 then remove(o); return end
            if not run.freeze then
                if o.wait > 0 then
                    o.wait = o.wait-1
                else
                    o.offsetH,o.offsetL = o.offsetH-17,o.offsetL+25
                end
            end
            return
        end
        local inside = band(o.h+0x2400,0xffff)<0xb800
        if o.entered and not inside then remove(o); return end
        o.entered = o.entered or inside
        if run.freeze then return end
        if o.wait > 0 then o.wait=o.wait-1; return end
        if o.nextPicture > 0 then
            o.clock = o.clock-1
            if o.clock < 0 then
                o.clock,o.picture = o.state[0x1d],o.nextPicture
                o.nextPicture = o.nextPicture-1
            end
        end
        if o.offsetL < 0x2e00 then o.offsetL = o.offsetL+0x30 end
    end

    function M.render(o, draw)
        local art = program.scenery[o.kind].art
        if o.kind == 0x8d then
            if o.run.major >= 0x13d and (o.offsetL <= 0x3600 or o.run.freeze) then
                draw(o,art[1],s16(0xdc00+o.offsetH),s16(0xe500+o.offsetL))
            end
            draw(o,art[2],-0x3ac0,-0x2d00)
        else
            local h,l = program.add(o.h,o.l,-0x2200,-0x1600)
            local dh,dl = s16(h-o.h),s16(l-o.l)
            draw(o,art[o.picture][1],dh,s16(dl-o.offsetL))
            draw(o,art[o.picture][2],dh,s16(dl+o.offsetL))
        end
    end

    return M
end
