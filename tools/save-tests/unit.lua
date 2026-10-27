local R=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local C,P=R.C,R.P
local total=0
local function check(ok,label) assert(ok,label);total=total+1 end
local function rejects(fn,label) check(not pcall(fn),label) end
check(C.sha256('abc')=='ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad','SHA-256 向量')
check(C.sha256(string.rep('a',1000000))=='cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0','SHA-256 长消息')
for n=0,300 do local t={};for i=1,n do t[i]=string.char((i*47+n)%256) end;local s=table.concat(t)
    check(C.unbase64(C.base64(s))==s,'Base64 二进制往返');check(C.decompress(C.compress(s))==s,'LZ 二进制往返') end
local s=string.rep('Boss Rush 中文 data 0123456789\0',10000)
check(C.decompress(C.compress(s))==s and #C.compress(s)<#s/5,'重复内容压缩')
rejects(function() C.decompress('\128\0\0') end,'非法回溯')
local limit=C.MAX_RAW;C.MAX_RAW=100;rejects(function() C.decompress('\0A'..string.rep('\255\0\1',10)) end,'解压上限');C.MAX_RAW=limit
plus.CreateDirectory('User');local old=C.lock(Serialize({money=120,PlayerBrand='TEST',Achievement={true},Duration={1,2,3,4,5}}))
local f=assert(io.open('User/Score.dat','wb'));f:write(old);f:close()
P.init();local first=P.index.active
check(P.read('Score.dat')==old,'迁移内容一致');check(P.readFile('User/Score.dat')==old,'原存档未删除或改写')
local second=P.create('另一个存档');P.activate(second)
P.write('Score.dat',C.lock(Serialize({money=888,PlayerBrand='SECOND'})))
P.write('Spellcard.dat',C.lock(Serialize({{reimu={1,3}}})))
local function uint(n,size) local out={};for i=1,size do out[i]=string.char(n%256);n=math.floor(n/256) end;return table.concat(out) end
local function text(s,size) return uint(#s,size)..s end
local checkpoint='STGR'..uint(1,2)..text('Boss Rush HD',2)..uint(1,2)..uint(0,2)..text('',4)..text('TEST',2)..text('',4)..uint(1,2)..text('TH06@BossRush',2)..text(Serialize({score=1,dead=0,getsc=0,graze=0,saving=0,current_system=''}),4)..string.rep('\0',16)..text('reimu',2)..uint(3,4)..'abc'
P.write('saving1.file',checkpoint)
check(P.read('Score.dat',first)==old,'存档互相隔离')
local bundle=P.export({first,second},true);local token=C.pack(bundle)
check(#C.unpack(token).entries==2,'多个存档口令往返')
local preview=P.preview(bundle);check(#preview==2 and preview[1].identical and preview[2].checkpoint,'导入预览')
local untouched=#P.index.profiles;local b=C.unpack(token);b.entries[2].uuid=C.id();b.entries[2].name='仅导入这份'
local result=P.import(b,{2},'copy');check(result.imported==1 and #P.index.profiles==untouched+1,'选择性导入')
local before=#P.index.profiles;result=P.import(bundle,{1,2},'copy');check(result.skipped==2 and #P.index.profiles==before,'相同进度不重复导入')
local changed=P.export({first},false);local originalFirst=P.read('Score.dat',first)
changed.entries[1].files['Score.dat']=C.base64(C.lock(Serialize({money=777,PlayerBrand='PC'})))
local files={};for k,v in pairs(changed.entries[1].files) do files[k]=C.unbase64(v) end;changed.entries[1].digest=P.digest(files)
result=P.import(changed,{1},'copy');check(result.imported==1 and P.read('Score.dat',first)==originalFirst,'冲突默认保留副本')
local backups=#P.index.backups;result=P.import(changed,{1},'replace')
check(result.skipped==1,'已有相同副本时跳过')
changed.entries[1].files['Score.dat']=C.base64(C.lock(Serialize({money=778})));files['Score.dat']=C.unbase64(changed.entries[1].files['Score.dat']);changed.entries[1].digest=P.digest(files)
result=P.import(changed,{1},'replace');check(result.imported==1 and #P.index.backups==backups+1,'替换前保留备份')
check(P.read('Score.dat',first)==originalFirst,'备份目录保留原字节');P.restore(first);check(P.entry(first).id==first,'备份可恢复')
local active=P.export({second},true);active.entries[1].files['Score.dat']=C.base64(C.lock(Serialize({money=999})));local activeFiles={};for k,v in pairs(active.entries[1].files) do activeFiles[k]=C.unbase64(v) end;active.entries[1].digest=P.digest(activeFiles)
rejects(function() P.import(active,{1},'replace') end,'不覆盖正在运行的存档')
local valid=C.pack(changed);rejects(function() C.unpack(valid:sub(1,#valid-1)..(valid:sub(-1)=='A' and 'B' or 'A')) end,'口令篡改拒绝')
local evil=C.unpack(token);evil.entries[1].files['../setting']='eA';rejects(function() P.validate(evil) end,'路径穿越拒绝')
evil=C.unpack(token);evil.version=2;rejects(function() P.validate(evil) end,'不兼容版本拒绝')
evil=C.unpack(token);evil.entries[1].uuid='../bad';rejects(function() P.validate(evil) end,'非法编号拒绝')
evil=C.unpack(token);evil.entries[1].files['Score.dat']=C.base64(C.lock(Serialize({money='wrong'})));rejects(function() P.validate(evil) end,'错误数值类型拒绝')
local originalOpen=io.open;local oldIndex=Serialize(P.index)
io.open=function(path,mode) if path=='User/profiles/index.json.new' then return nil,'模拟磁盘写入失败' end;return originalOpen(path,mode) end
rejects(function() P.create('写盘失败') end,'索引写入失败回滚');io.open=originalOpen
check(Serialize(P.index)==oldIndex,'失败时内存索引不变')
local indexPath='User/profiles/index.json';os.remove(indexPath);P.init();check(P.index.active==second,'索引主文件丢失后恢复备份')
local beforeBackup=P.readFile(indexPath..'.bak');local broken=assert(io.open(indexPath,'wb'));broken:write('{broken');broken:close();P.init()
check(P.readFile(indexPath..'.bak')==beforeBackup and DeSerialize(P.readFile(indexPath)).active==second,'坏索引恢复时不破坏可用备份')
rejects(function() P.archive(second) end,'当前槽不能被归档')
local archive=P.create('归档回归');P.archive(archive);rejects(function() P.entry(archive) end,'归档后移出活动列表');P.restore(archive);check(P.entry(archive).id==archive,'归档可恢复')
local truncated=P.export({second},true);truncated.entries[1].files['saving1.file']=C.base64(checkpoint:sub(1,-2))
rejects(function() P.validate(truncated) end,'截断的检查点拒绝')
-- 执行真实切换重建函数，验证空槽的机签、符卡槽、金币校验及成就缓存。
local newSlot=P.create('空槽切换回归');lstg={DoFile=function() end};SYSTEM_COUNT=11;int=math.floor
sp={LockString=function(_,v) return C.lock(v) end,UnLockString=function(_,v) return C.lock(v,true) end}
dofile(R.root..'/THlib/lib/Lscoredata.lua');dofile(R.root..'/core.lua')
P=SaveProfiles;player_list={{'灵梦','reimu'}};_sc_table={{card={card_id=3488}}}
ext={achievement={getcount=99,achievement={1,2}},saving={SaveManager={Refresh=function(self) self.refreshed=true end}},replay={IsReplay=function() return false end}}
CurrentVerifiableOffset=7;P.pending=newSlot;ReloadSaveProfile()
check(scoredata.PlayerBrand=='PLAYER' and CurrentMoney==7 and scoredata.money==0,'空槽机签与金币校验重建')
check(spell_card_data[3488].reimu[1]==0 and spell_card_data[3488].reimu[2]==0,'已注册符卡历史重建')
check(ext.achievement.getcount==0 and #ext.achievement.achievement==0,'成就缓存隔离')
check(ext.saving.SaveManager._repdir==P.userRoot() and ext.saving.SaveManager.refreshed,'继续游戏列表切换')
AddMoney(.75);AddMoney(.75);check(scoredata.money==1 and CurrentMoney==8,'金币小数累计在新槽正确工作')
P.write('saving1.file',checkpoint);P.write('saving1.file',checkpoint)
dofile(R.root..'/THlib/plus/Utility.lua');dofile(R.root..'/THlib/plus/IO.lua');dofile(R.root..'/THlib/plus/Replay.lua')
__UTF8ToANSI=function(value) return value end
plus.EnumFiles=function() return {
    {isDirectory=false,real_name='saving1.file',name=P.path('saving1.file')},
    {isDirectory=false,real_name='saving1.file.bak',name=P.path('saving1.file')..'.bak'}
} end
local manager=plus.ReplayManager(P.userRoot(),'file','saving')
check(manager:GetRecord(1).stages[1].frameCount==3,'实际检查点解析与备份文件隔离')
-- 执行真实 FrameFunc，暂停 1000 秒后只补正常一帧，不补跑同步期间的战斗。
local source=assert(io.open(R.root..'/THlib/ext/ext.lua','rb')):read('*a'):gsub('\r\n','\n')
local frame=assert(source:match('(function FrameFunc%(%)\n.-)\nfunction RenderFunc'))
SaveSync={visible=true,frame=function() end};stage={current_stage={is_menu=true}}
lstg={var={timeslow=1},quit_flag=false};setting={keysys={menu=27}}
local noop=function() end;ChangeGameTitle,CheckMoney=noop,noop;GetLastKey=function() return 0 end
ext={pause_menu={IsKilled=function() return true end},manual={IsKilled=function() return true end},StageIsMenu=function() return true end,
    achievement={frame=noop},MusicChange={frame=noop},Debugging=noop,InputDuration=noop,DurationAchievement=noop}
local exercise=assert(loadstring('local offset=99;local before,after,differ=0,0,1;local time=1000;local played;local stopWatch={GetElapsed=function() return time end};local DoFrameEx=function(count) played=count end;\n'..frame..
    '\nreturn function() FrameFunc();SaveSync.visible=false;time=time+1/60;FrameFunc();return played end'))()
check(exercise()==1,'关闭同步页后不会补跑暂停时长')
print('存档单元回归通过：'..total..' 项（仅使用临时用户目录）')
