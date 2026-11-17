-- CV1000 的 240×320 关卡使用共用街机对象和发弹中间层。
return function(code, level, machine, road)
    local source=dofile('mod/GAME/pgm/source.lua')(code:lower())
    source.stageFiles=true
    if road then source.road=road() end
    local bullets=dofile('mod/GAME/pgm/bullets.lua').create(source)
    local player=dofile('mod/GAME/pgm/player.lua')(source,bullets,machine)
    _editor_class[code]=dofile('mod/GAME/pgm/stage.lua')(source,bullets,player,level)
end
