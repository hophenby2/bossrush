-- 每份存档有独立目录；旧版文件只复制，不删除。索引提交前不暴露导入中的目录。
local C=assert(SaveCodec)
local P={ ROOT='User/profiles', FILES={'Score.dat','Spellcard.dat','saving1.file','resume.dat'} }
local function clone(v) return DeSerialize(Serialize(v)) end
local function id(v) return type(v)=='string' and #v==32 and not v:find('[^0-9a-f]') end
local function name(v) assert(type(v)=='string' and #v>0 and #v<=96 and not v:find('[%z\1-\31]'),'存档名称须为 1–32 个汉字或 1–96 个字节'); return v end
local function read(path,limit)
    local f=io.open(path,'rb'); if not f then return nil end
    local data=f:read((limit or C.MAX_RAW)+1); f:close()
    assert(#data<=(limit or C.MAX_RAW),'存档文件过大'); return data
end
local function exists(path) local f=io.open(path,'rb'); if f then f:close(); return true end; return false end
local function mkdir(path)
    local current=''
    for part in path:gmatch('[^/]+') do current=current=='' and part or current..'/'..part
        if not plus.DirectoryExists(current) then plus.CreateDirectory(current) end
    end
end
local function atomic(path,data)
    local f=assert(io.open(path..'.new','wb')); assert(f:write(data)); assert(f:flush()); assert(f:close())
    local had=exists(path)
    if had then os.remove(path..'.bak'); assert(os.rename(path,path..'.bak')) end
    local ok,err=os.rename(path..'.new',path)
    if not ok then if had then os.rename(path..'.bak',path) end; error(err or '存档提交失败') end
end
local function recover(path) return read(path) or read(path..'.bak') end
local function validateIndex(index)
    assert(type(index)=='table' and index.format=='BossRushProfiles' and index.version==1 and type(index.profiles)=='table','存档索引无效')
    local seen={}; for _,entry in ipairs(index.profiles) do
        assert(id(entry.id) and id(entry.uuid) and not seen[entry.id],'存档索引损坏'); name(entry.name); seen[entry.id]=true
    end
    assert(seen[index.active],'当前存档不存在'); index.backups=index.backups or {}; return index
end
local function commit(index) atomic(P.ROOT..'/index.json',Serialize(index)); P.index=index end
function P.entry(which)
    for _,entry in ipairs(P.index.profiles) do if entry.id==(which or P.index.active) then return entry end end
    error('找不到这份存档')
end
function P.path(file,which)
    assert(file=='Score.dat' or file=='Spellcard.dat' or file=='saving1.file' or file=='saving.file' or file=='resume.dat' or file:match('^Score[_%.]') or file:match('^Spellcard[_%.]'),'未知存档文件')
    assert(not file:find('[/\\]'),'存档文件名无效')
    local slot=which or P.index.active; assert(id(slot),'存档编号无效')
    return P.ROOT..'/'..slot..'/'..file
end
function P.userRoot() return P.ROOT..'/'..P.index.active end
function P.read(file,which)
    if file=='saving1.file' then return read(P.path(file,which)) end
    return recover(P.path(file,which))
end
function P.write(file,data)
    atomic(P.path(file),data); P.entry().updated=os.time()
end
local function prepare(entry,files)
    mkdir(P.ROOT..'/'..entry.id)
    for _,file in ipairs(P.FILES) do
        local data=files[file]
        if data then atomic(P.path(file,entry.id),data) end
    end
end
local function emptyFiles() return {['Score.dat']=C.lock('{}'),['Spellcard.dat']=C.lock('{}')} end
local function record(label,uuid)
    return {id=C.id(),uuid=uuid or C.id(),name=name(label),created=os.time(),updated=os.time()}
end
function P.init()
    mkdir(P.ROOT)
    local indexPath=P.ROOT..'/index.json'
    local raw=read(indexPath)
    if raw then
        local ok,index=pcall(function() return validateIndex(DeSerialize(raw)) end)
        if ok then P.index=index; return end
    end
    local backup=read(indexPath..'.bak')
    if backup then
        local ok,index=pcall(function() return validateIndex(DeSerialize(backup)) end)
        if ok then
            if raw then os.remove(indexPath..'.corrupt');assert(os.rename(indexPath,indexPath..'.corrupt')) end
            atomic(indexPath,backup);P.index=index;return
        end
    end
    assert(not raw and not backup,'存档索引及备份均损坏，请保留 User/profiles 后恢复备份')
    local entry=record('原有存档'); local files=emptyFiles()
    for _,file in ipairs(P.FILES) do files[file]=read('User/'..file) or files[file] end
    prepare(entry,files)
    commit({format='BossRushProfiles',version=1,active=entry.id,profiles={entry},backups={}})
end
function P.files(which,checkpoint)
    local files={}
    for _,file in ipairs(P.FILES) do if (file~='saving1.file' and file~='resume.dat') or checkpoint then files[file]=P.read(file,which) end end
    return files
end
local function digest(files)
    local parts={}; for _,file in ipairs(P.FILES) do if file~='resume.dat' or files[file] then local s=files[file] or '';parts[#parts+1]=file..':'..#s..':'..s end end
    return C.sha256(table.concat(parts))
end
function P.summary(entry)
    local ok,data=pcall(function() return DeSerialize(C.lock(P.read('Score.dat',entry.id) or C.lock('{}'),true)) end)
    data=ok and type(data)=='table' and data or {}
    return {id=entry.id,uuid=entry.uuid,name=entry.name,created=entry.created,updated=entry.updated,
        active=entry.id==P.index.active,player=type(data.PlayerBrand)=='string' and data.PlayerBrand or '',
        money=type(data.money)=='number' and data.money or 0,checkpoint=exists(P.path('saving1.file',entry.id)),resume=exists(P.path('resume.dat',entry.id))}
end
function P.list()
    local out={}; for _,entry in ipairs(P.index.profiles) do out[#out+1]=P.summary(entry) end; return out
end
function P.create(label,source)
    assert(#P.index.profiles<128,'最多保留 128 份存档，请先整理已有存档')
    local entry=record(label); prepare(entry,source and P.files(source,true) or emptyFiles())
    local index=clone(P.index); index.profiles[#index.profiles+1]=entry; commit(index); return entry.id
end
function P.rename(which,label)
    local index=clone(P.index); P.entry(which)
    for _,entry in ipairs(index.profiles) do if entry.id==which then entry.name=name(label) end end
    commit(index)
end
function P.archive(which)
    P.entry(which);assert(which~=P.index.active,'请先切换到另一份存档再归档当前存档')
    local index=clone(P.index)
    for i,entry in ipairs(index.profiles) do if entry.id==which then
        index.backups[#index.backups+1]=entry;table.remove(index.profiles,i);commit(index);return
    end end
end
function P.activate(which)
    P.entry(which); local index=clone(P.index); index.active=which; commit(index)
end
function P.export(selection,checkpoint)
    assert(type(selection)=='table' and #selection>0 and #selection<=128,'请选择要导出的存档')
    local entries,seen,version={},{},1
    for _,which in ipairs(selection) do
        assert(not seen[which],'重复选择存档'); seen[which]=true
        local entry=P.entry(which); local files=P.files(which,checkpoint); local encoded={}
        for file,bytes in pairs(files) do encoded[file]=C.base64(bytes);if file=='resume.dat' then version=2 end end
        entries[#entries+1]={uuid=entry.uuid,name=entry.name,created=entry.created,updated=entry.updated,files=encoded,digest=digest(files)}
    end
    return {format='BossRushSave',version=version,game='Boss Rush HD',created=os.time(),entries=entries}
end
local function dataTree(value,depth,budget)
    assert(depth<=24,'存档嵌套过深')
    if type(value)=='table' then
        for k,v in pairs(value) do budget[1]=budget[1]+1; assert(budget[1]<=200000,'存档字段过多')
            assert(type(k)=='number' or (type(k)=='string' and #k<=1024),'存档字段无效'); dataTree(v,depth+1,budget)
        end
    elseif type(value)=='number' then assert(value==value and math.abs(value)<1e18,'存档数值无效')
    elseif type(value)=='string' then assert(#value<=1024*1024,'存档字段过长')
    else assert(type(value)=='boolean' or type(value)=='userdata' or value==nil,'存档字段类型无效') end
end
local function checkpoint(bytes)
    local position=1
    local function take(count)
        assert(count>=0 and position+count-1<=#bytes,'继续游戏数据不完整')
        local value=bytes:sub(position,position+count-1);position=position+count;return value
    end
    local function uint(count) local value=0;local s=take(count);for i=count,1,-1 do value=value*256+s:byte(i) end;return value end
    local function text(count) local size=uint(count);assert(size<=1024*1024,'检查点字段过长');return take(size) end
    assert(take(4)=='STGR' and uint(2)==1,'继续游戏数据版本不兼容')
    assert(text(2)=='Boss Rush HD','检查点来自其他游戏');uint(2);uint(2);text(4);text(2);text(4)
    local count=uint(2);assert(count>0 and count<=128,'检查点关卡数量无效')
    for _=1,count do
        local stageName=text(2);assert(#stageName>0 and #stageName<1024,'检查点关卡名称无效')
        local state=DeSerialize(text(4));assert(type(state)=='table','检查点状态无效');dataTree(state,0,{0})
        for _,key in ipairs({'score','dead','getsc','graze','saving'}) do assert(type(state[key])=='number' and state[key]>=0,'检查点数值无效：'..key) end
        assert(type(state.current_system)=='string','检查点系统数据无效')
        take(16);text(2)
        local frames=uint(4);assert(frames<=1000000,'检查点帧数无效');take(frames)
    end
    assert(position==#bytes+1,'检查点存在多余数据')
end
function P.validateGrowth(score,spell)
    assert(type(score)=='table' and type(spell)=='table','成长或符卡数据无效')
    dataTree(score,0,{0});dataTree(spell,0,{0})
    assert(score.money==nil or (type(score.money)=='number' and score.money>=0 and score.money<=1e12),'金币数值无效')
    assert(score.PlayerBrand==nil or (type(score.PlayerBrand)=='string' and #score.PlayerBrand<=96),'机签数据无效')
    assert(score.version==nil or type(score.version)=='string','存档版本字段无效')
    for _,key in ipairs({'ContinuousLogin','LastLoginDate','hair','total_icecount','total_photocount','music_bar_pos','music_bar_playmode','music_bar_time','player_select','stageselectPos','resume_count'}) do
        assert(score[key]==nil or (type(score[key])=='number' and score[key]>=0),'存档数值类型错误：'..key)
    end
    for _,key in ipairs({'Manual','Achievement','NoticeAchievement','Duration','UnlockSystem','UnlockSC','bought','hiscore','stage_practice','system_selectid','menu_sc_pr','Player_playtime','AllFinishCount'}) do
        assert(score[key]==nil or type(score[key])=='table','成长字段类型错误：'..key)
    end
    for _,key in ipairs({'Duration','Player_playtime','AllFinishCount','hiscore'}) do
        if score[key] then for _,value in pairs(score[key]) do assert(type(value)=='number' and value>=0,'成长数值无效：'..key) end end
    end
    for _,players in pairs(spell) do if players~=false then
        assert(type(players)=='table','符卡记录类型无效')
        for player,history in pairs(players) do assert(type(player)=='string' and type(history)=='table' and type(history[1])=='number' and type(history[2])=='number' and history[1]>=0 and history[2]>=0,'符卡次数无效') end
    end end
end
function P.validateState(value)
    assert(type(value)=='table','续玩状态类型无效');dataTree(value,0,{0})
end
function P.validate(bundle)
    assert(type(bundle)=='table' and bundle.format=='BossRushSave' and (bundle.version==1 or bundle.version==2) and bundle.game=='Boss Rush HD','不兼容的存档格式或版本')
    assert(type(bundle.entries)=='table' and #bundle.entries>0 and #bundle.entries<=128,'存档数量无效')
    local decoded={}
    for _,entry in ipairs(bundle.entries) do
        assert(type(entry)=='table' and id(entry.uuid),'存档编号无效'); name(entry.name)
        assert(type(entry.created)=='number' and entry.created>=0 and entry.created<1e12 and type(entry.updated)=='number' and entry.updated>=0 and entry.updated<1e12,'存档时间无效')
        assert(type(entry.files)=='table','缺少存档内容'); local files={}
        for file,encoded in pairs(entry.files) do
            assert(file=='Score.dat' or file=='Spellcard.dat' or file=='saving1.file' or (file=='resume.dat' and bundle.version==2),'交换包包含未知文件')
            assert(type(encoded)=='string','存档文件编码无效'); files[file]=C.unbase64(encoded)
        end
        for _,file in ipairs({'Score.dat','Spellcard.dat'}) do
            assert(files[file],'存档数据不完整'); local data=DeSerialize(C.lock(files[file],true))
            assert(type(data)=='table','存档数据无效'); dataTree(data,0,{0})
            if file=='Score.dat' then
                assert(data.money==nil or (type(data.money)=='number' and data.money>=0 and data.money<=1e12),'金币数值无效')
                assert(data.PlayerBrand==nil or (type(data.PlayerBrand)=='string' and #data.PlayerBrand<=96),'机签数据无效')
                assert(data.version==nil or type(data.version)=='string','存档版本字段无效')
                for _,key in ipairs({'ContinuousLogin','LastLoginDate','hair','total_icecount','total_photocount','music_bar_pos','music_bar_playmode','music_bar_time','player_select','stageselectPos'}) do
                    assert(data[key]==nil or (type(data[key])=='number' and data[key]>=0),'存档数值类型错误：'..key)
                end
                for _,key in ipairs({'Manual','Achievement','NoticeAchievement','Duration','UnlockSystem','UnlockSC','bought','hiscore','stage_practice','system_selectid','menu_sc_pr','Player_playtime','AllFinishCount'}) do
                    assert(data[key]==nil or type(data[key])=='table','存档字段类型错误：'..key)
                end
                for _,key in ipairs({'Duration','Player_playtime','AllFinishCount'}) do
                    if data[key] then for _,value in pairs(data[key]) do assert(type(value)=='number' and value>=0,'计时或次数数据无效：'..key) end end
                end
                if data.hiscore then for _,value in pairs(data.hiscore) do assert(type(value)=='number' and value>=0,'最高分数据无效') end end
            else
                for _,players in pairs(data) do
                    if players~=false then
                        assert(type(players)=='table','符卡记录类型无效')
                        for player,history in pairs(players) do
                            assert(type(player)=='string' and type(history)=='table' and type(history[1])=='number' and type(history[2])=='number' and history[1]>=0 and history[2]>=0,'符卡次数数据无效')
                        end
                    end
                end
            end
        end
        if files['saving1.file'] then checkpoint(files['saving1.file']) end
        if files['resume.dat'] then
            assert(SaveResume,'当前运行时不支持关内续玩，请更新客户端')
            SaveResume.decode(files['resume.dat'])
        end
        assert(C.equal(digest(files),entry.digest),'存档文件校验失败')
        decoded[#decoded+1]={entry=entry,files=files}
    end
    return decoded
end
function P.preview(bundle)
    local decoded=P.validate(bundle); local out={}
    for i,item in ipairs(decoded) do
        local matching={}; local same=false
        for _,localEntry in ipairs(P.index.profiles) do
            if localEntry.uuid==item.entry.uuid then
                matching[#matching+1]={id=localEntry.id,name=localEntry.name,active=localEntry.id==P.index.active}
                if digest(P.files(localEntry.id,(item.files['saving1.file']~=nil or item.files['resume.dat']~=nil)))==item.entry.digest then same=true end
            end
        end
        out[i]={index=i,name=item.entry.name,uuid=item.entry.uuid,updated=item.entry.updated,
            checkpoint=item.files['saving1.file']~=nil,resume=item.files['resume.dat']~=nil,matches=matching,identical=same}
    end
    return out
end
function P.import(bundle,selection,policy)
    assert(policy=='copy' or policy=='replace','请选择保留副本或替换')
    local decoded=P.validate(bundle); assert(type(selection)=='table' and #selection>0,'请选择要导入的存档')
    local index=clone(P.index); local imported,skipped,seen=0,0,{}
    for _,number in ipairs(selection) do
        assert(type(number)=='number' and number%1==0 and decoded[number] and not seen[number],'存档选择无效'); seen[number]=true
        local item=decoded[number]; local target,identical
        for _,entry in ipairs(index.profiles) do if entry.uuid==item.entry.uuid then
            target=target or entry
            if digest(P.files(entry.id,(item.files['saving1.file']~=nil or item.files['resume.dat']~=nil)))==item.entry.digest then identical=true end
        end end
        if identical then skipped=skipped+1
        else
            if policy=='replace' and target then assert(target.id~=index.active,'请先切换到另一份存档，再替换当前存档；也可选择保留副本') end
            local entry=record(item.entry.name,item.entry.uuid); entry.created=item.entry.created; entry.updated=item.entry.updated
            prepare(entry,item.files)
            if target and policy=='replace' then
                for _,file in ipairs({'saving1.file','resume.dat'}) do if not item.files[file] then
                    local saved=P.read(file,target.id);if saved then atomic(P.path(file,entry.id),saved) end
                end end
                index.backups[#index.backups+1]=target
                for i,v in ipairs(index.profiles) do if v.id==target.id then index.profiles[i]=entry end end
            else
                assert(#index.profiles<128,'最多保留 128 份存档')
                if target and #entry.name+#'（同步副本）'<=96 then entry.name=entry.name..'（同步副本）' end
                index.profiles[#index.profiles+1]=entry
            end
            imported=imported+1
        end
    end
    commit(index); return {imported=imported,skipped=skipped}
end
function P.restore(which)
    local index=clone(P.index)
    for i,entry in ipairs(index.backups) do if entry.id==which then
        assert(#index.profiles<128,'存档槽已满'); if #entry.name+#'（恢复）'<=96 then entry.name=entry.name..'（恢复）' end; index.profiles[#index.profiles+1]=entry
        table.remove(index.backups,i); commit(index); return
    end end
    error('找不到备份')
end
P.atomic,P.readFile,P.digest=atomic,read,digest
SaveProfiles=P
return P
