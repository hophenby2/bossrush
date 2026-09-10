function IncludeLuaFile(path)
    if GlobalAddAchievement then
        DoFile(path)
    else
        table.insert(LoadRes, function()
            Include(path)
        end)
    end
end

Include("THlib\\THlib.lua")
Include("mod\\_editor_output.lua")


