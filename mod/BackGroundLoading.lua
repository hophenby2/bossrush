local lbg = LoadRes
local Insert = table.insert

local LoadTexture = LoadTexture
local LoadImageFromFile = LoadImageFromFile
local LoadImageGroup = LoadImageGroup
local LoadImage = LoadImage
local SetImageState = SetImageState
local SetImageCenter = SetImageCenter
local LoadImageGroupFromFile = LoadImageGroupFromFile
local Color = Color


do
    local path = "mod\\BG\\TH14\\TH14_bg_"
    local function Load(id)
        Insert(lbg, function()
            LoadTexture2("14_" .. id, path .. id .. ".png")
        end)
    end
    for _, p in ipairs({ 11, 12, 13, 14, 21, 22, 23, 24, 25, 26, 34, 51, 52, 53, 54, 61, 63 }) do
        Load(p)
    end
    Insert(lbg, function()
        LoadImageFromFile("14_15", path .. "15.png")
        LoadImageFromFile("14_33", path .. "33.png")
        LoadImageFromFile("14_35", path .. "35.png")
        SetImageState("14_35", "mul+add")
        LoadImageFromFile("14_31", path .. "31.png")
        LoadImageFromFile("14_41", path .. "41.png")
        LoadImageFromFile("14_42", path .. "42.png")
        LoadImageFromFile("14_44", path .. "44.png")
        LoadImageFromFile("14_64", path .. "64.png")
        LoadImageGroupFromFile("14_32", path .. "32.png", nil, 2, 1)
        LoadImageGroupFromFile("14_43", path .. "43.png", nil, 1, 8)
    end)

end--TH14

do
    local path = "mod\\BG\\TH16\\TH16_bg_"
    Insert(lbg, function()
        LoadTexture2("16_floor", path .. "floor.png")
    end)
    for i = 1, 4 do
        Insert(lbg, function()
            LoadImageFromFile2("16_door" .. i, path .. "door" .. i .. ".png")
            
        end)
        Insert(lbg, function()
            LoadTexture2("16_spring" .. i, path .. "spring" .. i .. ".png")
            
        end)
        Insert(lbg, function()
            LoadImageFromFile2("16_autumn" .. i, path .. "autumn" .. i .. ".png")
            
        end)
    end
    for i = 1, 3 do
        Insert(lbg, function()
            LoadImageFromFile2("16_summer" .. i, path .. "summer" .. i .. ".png")
            
        end)
    end
    Insert(lbg, function()
        LoadTexture2("16_winter1", path .. "winter1.png")
        
    end)
    Insert(lbg, function()
        LoadTexture2("16_winter3", path .. "winter3.png")
        
    end)
    Insert(lbg, function()
        LoadImageFromFile2("16_winter2", path .. "winter2.png")
        
    end)
    Insert(lbg, function()
        LoadImageFromFile2("16_door", path .. "door.png")
        
    end)
end--TH16
