local P = {}

function P.register(level, name, entries)
    local key = 'pgmpractice'
    boss.Define(key,name,'',nil,{0,500},nil,'img_void',level)
    for _, entry in ipairs(entries) do
        local card = boss.card.New(entry.title,0,0,1,1)
        card.practice_only, card.is_sc, card.pgm_practice = true,false,entry
        boss.card.add({{card,key}},level,entry.title,entry.id)
    end
end

return P
