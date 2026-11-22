-- 静音测试也检查音频接口边界：环境音淡出不能改动全局混音器。
arg={'mhj-audio'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local created,baseNew={},New
New=function(cls,...) local o=baseNew(cls,...);created[#created+1]=o;return o end
local played,volumes,stopped={},{},{}
PlaySound=function(id,gain) played[#played+1]={id,gain} end
StopSound=function(id) stopped[id]=true end
SetSEVolume=function() error('环境音错误地改动了全局音量') end
SetSESpeed=function() end
lstg.SetSourceSoundVolume=function(id,gain) assert(type(id)=='string' and type(gain)=='number');volumes[id]=gain end
stage.current_stage={timer=1}
local A=dofile('mod/GAME/ports/mhj/source_audio.lua').new(39)
A.play('env1');local driver=created[#created]
assert(#played==1)
A.play('env1');assert(#played==1,'同帧原作音效没有去重')
A.fadeEnvironment(1,false)
for tick=1,60 do driver.timer=tick;driver.class.frame(driver) end
assert(volumes.mhj_source_39_env1==0,'环境音没有独立淡出')
assert(next(driver.active),'循环环境音意外终止')
A.fadeEnvironment(1,true);assert(stopped.mhj_source_39_env1,'淡入前未按原作停止环境声')
stage.current_stage.timer=2;A.play('damage00')
local data=dofile('mod/GAME/th39/sounds.lua')
assert(math.abs(played[#played][2]-data.cues.damage00.volume*3)<1e-9,'Default 分类音量倍率不同')
stage.current_stage.timer=3;A.play('tan')
assert(played[#played][2]<=data.cues.tan.volume,'永夜 Tan 错用 Default 的三倍增益')
A.stop('env1');assert(driver.active.env1==nil)
A.clear()
local Snow=dofile('mod/GAME/th38/presentation.lua')
local voice=Snow.audioSource({clip='gun10',volume=.5,pitch=1,loop=true,mute=false},function() return 4.5 end)
voice:Play();voice.volume=.25;voice:FixedUpdate()
assert(volumes.asl_voice_1==.25,'雪莲华运行中音源音量未同步')
Snow.clearAudio();assert(not voice.isPlaying,'切关后雪莲华音源仍在播放')
voice:Play();voice:Dispose();voice:Dispose() -- 再次清理不能向复用池重复归还音源。
print('PASS 原作音效去重、分类增益、独立淡入淡出、循环与停止；全局音量未调用')
