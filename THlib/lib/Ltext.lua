--======================================
--luastg text
--======================================

----------------------------------------
--文字渲染

local ENUM_TTF_FMT = {
    left = 0x00000000,
    center = 0x00000001,
    right = 0x00000002,

    top = 0x00000000,
    vcenter = 0x00000004,
    bottom = 0x00000008,

    wordbreak = 0x00000010,

    noclip = 0x00000100,

    paragraph = 0x00000010,
    centerpoint = 0x00000105,
}
setmetatable(ENUM_TTF_FMT, { __index = load("return 0") })

local lstg = lstg
function RenderTTF(ttfname, text, x, y, color, ...)
    local fmt = 0
    for _, t in ipairs({ ... }) do
        fmt = fmt + ENUM_TTF_FMT[t]
    end
    lstg.RenderTTF(ttfname, text, x, x, y, y, fmt, color)
end

function RenderTTF2(ttfname, text, x, y, scale, color, ...)
    local fmt = 0
    for _, t in ipairs({ ... }) do
        fmt = fmt + ENUM_TTF_FMT[t]
    end
    lstg.RenderTTF(ttfname, text, x, x,y,y, fmt, color, scale)
end

function RenderText(fontname, text, x, y, size, ...)
    local fmt = 0
    for _, t in ipairs({ ... }) do
        fmt = fmt + ENUM_TTF_FMT[t]
    end
    lstg.RenderText(fontname, text, x, y, size, fmt)
end
