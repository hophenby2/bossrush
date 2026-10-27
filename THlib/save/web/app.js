'use strict';
const $=id=>document.getElementById(id), arr=value=>Array.isArray(value)?value:[];
const token=new URLSearchParams(location.hash.slice(1)).get('token')||'';
history.replaceState(null,'',location.pathname);
let state={}, selected=new Set(), remote=[], exported='', pendingIds='', timer, qrParts=[], qrIndex=0, stream, scanning=false, scanTimer, closed=false;
const fragments=new Map();
function message(text,error=false){$('message').textContent=text;$('message').className=error?'error':'';}
async function api(path,body){
  const response=await fetch(path,{method:body===undefined?'GET':'POST',headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:body===undefined?undefined:JSON.stringify(body)});
  const value=await response.json();if(!response.ok)throw Error(value.error||'操作失败');return value;
}
function action(fn){return async event=>{const button=event?.currentTarget;try{if(button?.tagName==='BUTTON')button.disabled=true;await fn(event);}catch(error){message(error.message,true);}finally{if(button?.tagName==='BUTTON')button.disabled=false;}};}
function node(tag,text,cls){const e=document.createElement(tag);if(text!==undefined)e.textContent=text;if(cls)e.className=cls;return e;}
function button(text,fn){const e=node('button',text);e.type='button';e.onclick=action(fn);return e;}
function tab(id){document.querySelectorAll('.tab').forEach(e=>e.classList.toggle('active',e.id===id));document.querySelectorAll('nav button').forEach(e=>e.classList.toggle('active',e.dataset.tab===id));}
document.querySelectorAll('nav button').forEach(e=>e.onclick=()=>tab(e.dataset.tab));
function ask(title,text,input){return new Promise(resolve=>{const d=$('askDialog');$('askTitle').textContent=title;$('askText').textContent=text;$('askInput').hidden=input===undefined;$('askInput').value=input||'';d.onclose=()=>resolve(d.returnValue==='ok'?(input===undefined?true:$('askInput').value):false);d.returnValue='cancel';d.showModal();});}
function selection(){if(!selected.size)throw Error('请先在“我的存档”勾选一份或几份');return [...selected];}
function updateCount(){$('selectionCount').textContent=`已选择 ${selected.size} 份`;$('selectAll').checked=arr(state.profiles).length>0&&selected.size===arr(state.profiles).length;}
function renderProfiles(){
  const list=$('profileList');list.replaceChildren();const available=new Set(arr(state.profiles).map(p=>p.id));selected=new Set([...selected].filter(id=>available.has(id)));
  for(const p of arr(state.profiles)){
    const card=node('article',undefined,'card'+(p.active?' current':''));const label=node('label');const check=node('input');check.type='checkbox';check.checked=selected.has(p.id);check.setAttribute('aria-label','选择 '+p.name);check.onchange=()=>{check.checked?selected.add(p.id):selected.delete(p.id);updateCount();};label.append(check,node('strong',p.name));if(p.active)label.append(node('span','当前','badge'));card.append(label);
    card.append(node('p',`${p.player||'尚未设置机签'} · 金币 ${p.money} · ${p.resume?'有关内续玩点':p.checkpoint?'有关卡检查点':'无检查点'}`,'meta'));
    const controls=node('div',undefined,'toolbar');const use=button(p.active?'正在使用':'切换到此存档',async()=>{if(await ask('切换存档',`将保存当前记录并返回标题，切换到“${p.name}”。`)){await api('/api/switch',{id:p.id});message('正在切换存档…');await refresh();}});use.disabled=p.active;
    controls.append(use,button('重命名',async()=>{const name=await ask('重命名存档','请填写新的存档名称。',p.name);if(name){await api('/api/rename',{id:p.id,name});await refresh();}}));if(!p.active)controls.append(button('归档',async()=>{if(await ask('归档存档','存档会移到备份区，可随时恢复。')){await api('/api/archive',{id:p.id});await refresh();}}));card.append(controls);list.append(card);
  }updateCount();
  const backups=$('backupList');backups.replaceChildren();for(const p of arr(state.backups)){const row=node('div',undefined,'toolbar');row.append(node('span',p.name),button('恢复为独立存档',async()=>{await api('/api/restore',{id:p.id});message('备份已恢复，现有存档保持保留。');await refresh();}));backups.append(row);}
}
function renderPair(){
  const address=$('localAddress'), old=address.value;address.replaceChildren();
  for(const p of arr(state.addresses)){const option=node('option',p.ip);option.value=p.ip;option.dataset.code=p.code;address.append(option);}if([...address.options].some(o=>o.value===old))address.value=old;
  $('pairCode').textContent=address.selectedOptions[0]?.dataset.code||'未找到共享网络地址，请连接 Wi-Fi 或开启热点后更新配对码';
  $('pairExpiry').textContent=state.expiresIn>0?`配对码剩余 ${Math.ceil(state.expiresIn/60)} 分钟；请选两台设备共同使用的网络地址。`:'配对已关闭，点击“更新配对码”重新启用。';
  $('peerState').textContent=state.connected?'已连接 '+state.connected:'尚未连接';
}
function renderIncoming(){
  const incoming=arr(state.incoming);const ids=incoming.map(p=>p.pending).sort().join(',');if(ids===pendingIds)return;pendingIds=ids;
  const list=$('incomingList');list.replaceChildren();if(!incoming.length){list.append(node('p','扫描、粘贴或局域网接收后，在这里选择。','muted'));return;}
  for(const offer of incoming){
    const panel=node('article',undefined,'panel');panel.append(node('h3',offer.origin));const checks=[];
    for(const p of arr(offer.entries)){const label=node('label',undefined,'check incomingRow'),check=node('input');check.type='checkbox';check.value=p.index;check.checked=!p.identical;checks.push(check);label.append(check,document.createTextNode(`${p.name} · ${p.resume?'含关内续玩点':p.checkpoint?'含关卡检查点':'成长与符卡记录'}${p.identical?' · 本机已有相同数据':arr(p.matches).length?' · 同源存档有不同进度':''}`));panel.append(label);}
    const policy=node('select');policy.setAttribute('aria-label','冲突处理方式');for(const [value,text] of [['copy','保留为新存档（推荐）'],['replace','替换同源存档，自动保留备份']]){const option=node('option',text);option.value=value;policy.append(option);}panel.append(policy);
    const controls=node('div',undefined,'toolbar');controls.append(button('导入所选存档',async()=>{const selection=checks.filter(c=>c.checked).map(c=>Number(c.value));if(!selection.length)throw Error('请选择至少一份存档');if(policy.value==='replace'&&!await ask('备份后替换','同源的非当前存档将被替换，替换前的数据可在备份区恢复。当前正在使用的存档须先切换或选择保留副本。'))return;const result=await api('/api/import',{pending:offer.pending,selection,policy:policy.value});message(`已导入 ${result.imported} 份，跳过 ${result.skipped} 份相同存档。`);await refresh();}),button('取消此次导入',async()=>{await api('/api/dismiss',{pending:offer.pending});await refresh();}));panel.append(controls);list.append(panel);
  }
}
async function refresh(){state=await api('/api/status');renderProfiles();renderPair();renderIncoming();}
async function job(request){
  message('正在传输，请保持两端管理页面打开…');for(let i=0;i<150;i++){const result=await api('/api/job/'+request.job);if(result.state==='done')return result.result;if(result.state==='error')throw Error(result.error);await new Promise(r=>setTimeout(r,1000));}throw Error('传输超时，请重试');
}
function renderRemote(profiles){remote=arr(profiles);const list=$('remoteList');list.replaceChildren();for(const p of remote){const card=node('label',undefined,'card'),check=node('input');check.type='checkbox';check.value=p.id;check.checked=true;check.className='remoteCheck';card.append(check,node('strong',p.name),node('p',`${p.player||'未设置机签'} · 金币 ${p.money} · ${p.resume?'有关内续玩点':p.checkpoint?'有关卡检查点':'无检查点'}`));list.append(card);}if(!remote.length)list.append(node('p','对方没有可同步的存档。'));}
function remoteSelection(){const ids=[...document.querySelectorAll('.remoteCheck:checked')].map(e=>e.value);if(!ids.length)throw Error('请选择对方的一份或几份存档');return ids;}
async function connect(code){const result=await job(await api('/api/pair',{code}));renderRemote(result.profiles);await refresh();tab('network');message('配对成功，可以双向发送或拉取所选存档。');}
async function copy(text){if(!text)throw Error('请先生成口令或配对码');if(window.BossRushNative){if(!window.BossRushNative.copy(text))throw Error('口令超过系统剪贴板容量，请保存为文件或使用局域网传输');message('已复制');return;}try{await navigator.clipboard.writeText(text);}catch(_){const area=node('textarea');area.value=text;document.body.append(area);area.select();if(!document.execCommand('copy'))throw Error('无法自动复制，请长按口令手动复制');area.remove();}message('已复制');}
function makeParts(value){if(value.length<=750)return[value];const id=value.slice(5,21),count=Math.ceil(value.length/750);if(count>256)throw Error('数据超过 256 张二维码，请取消附带检查点，或使用口令、文件、局域网传输');return Array.from({length:count},(_,i)=>`BRQ1.${id}.${i+1}.${count}.${value.slice(i*750,(i+1)*750)}`);}
function drawQR(){const qr=qrcode(0,'M');qr.addData(qrParts[qrIndex],'Byte');qr.make();$('qrCanvas').innerHTML=qr.createSvgTag({cellSize:4,margin:20,scalable:false});$('qrPage').textContent=`第 ${qrIndex+1} / ${qrParts.length} 张${qrParts.length>1?' · 收齐全部分片后才会导入':''}`;$('previousQR').disabled=$('nextQR').disabled=qrParts.length<2;}
function showQR(value,title){if(!value)throw Error('请先生成口令');qrParts=makeParts(value);qrIndex=0;$('qrTitle').textContent=title;drawQR();$('qrDialog').showModal();}
function closeQR(){clearInterval(timer);timer=null;$('autoQR').textContent='自动轮播';$('qrDialog').close();}
async function acceptScan(value){
  if(value.startsWith('bossrush-pair:'))value=value.slice(14);
  if(value.startsWith('BRP1-')){stopCamera();await connect(value);return;}
  if(value.startsWith('BRQ1.')){
    const m=value.match(/^BRQ1\.([a-f0-9]{16})\.(\d+)\.(\d+)\.([A-Za-z0-9_.-]+)$/);if(!m)throw Error('二维码分片格式无效');const [index,total]=[Number(m[2]),Number(m[3])];if(index<1||index>total||total>256)throw Error('二维码分片数量无效');
    let transfer=fragments.get(m[1]);if(!transfer){if(fragments.size>=4)fragments.clear();transfer={total,parts:new Map()};fragments.set(m[1],transfer);}if(transfer.total!==total)throw Error('二维码分片不属于同一份存档');const previous=transfer.parts.get(index);if(previous&&previous!==m[4])throw Error('二维码分片内容冲突');transfer.parts.set(index,m[4]);
    const progress=`已收集 ${transfer.parts.size} / ${total} 张分片`;$('scanProgress').textContent=$('cameraStatus').textContent=progress;
    if(transfer.parts.size!==total)return;value=Array.from({length:total},(_,i)=>transfer.parts.get(i+1)).join('');fragments.delete(m[1]);
  }
  if(!value.startsWith('BRS1.'))throw Error('未识别到 Boss Rush 存档或配对二维码');
  stopCamera();await api('/api/preview',{token:value});await refresh();$('incomingSection').scrollIntoView({behavior:'smooth'});message('已读取存档，请在待导入区选择一份或几份。');
}
async function decodeImage(source){const canvas=document.createElement('canvas');const ratio=Math.min(1,1600/(source.videoWidth||source.naturalWidth));canvas.width=Math.round((source.videoWidth||source.naturalWidth)*ratio);canvas.height=Math.round((source.videoHeight||source.naturalHeight)*ratio);if(!canvas.width||!canvas.height)return null;const ctx=canvas.getContext('2d',{willReadFrequently:true});ctx.drawImage(source,0,0,canvas.width,canvas.height);const image=ctx.getImageData(0,0,canvas.width,canvas.height);return jsQR(image.data,image.width,image.height,{inversionAttempts:'attemptBoth'})?.data;}
function stopCamera(){scanning=false;clearTimeout(scanTimer);if(stream)stream.getTracks().forEach(t=>t.stop());stream=null;$('camera').srcObject=null;if($('cameraDialog').open)$('cameraDialog').close();}
async function camera(){
  if(!navigator.mediaDevices?.getUserMedia)throw Error('此环境无法使用相机，可选择二维码图片或粘贴口令');$('cameraStatus').textContent='请允许相机权限，并将二维码放入画面';$('cameraDialog').showModal();
  try{stream=await navigator.mediaDevices.getUserMedia({video:{facingMode:'environment',width:{ideal:1280}},audio:false});if(!$('cameraDialog').open){stream.getTracks().forEach(t=>t.stop());stream=null;return;}$('camera').srcObject=stream;await $('camera').play();scanning=true;const tick=async()=>{if(!scanning)return;try{const value=await decodeImage($('camera'));if(value)await acceptScan(value);}catch(error){$('cameraStatus').textContent=error.message;}if(scanning)scanTimer=setTimeout(tick,300);};tick();}catch(error){stopCamera();throw Error('相机未能开启：'+error.message+'。也可以识别二维码图片。');}
}
$('createForm').onsubmit=action(async e=>{e.preventDefault();await api('/api/create',{name:$('profileName').value});$('profileName').value='';await refresh();message('新存档已创建，可随时切换。');});
$('cloneProfile').onclick=action(async()=>{const ids=selection();if(ids.length!==1)throw Error('复制时请选择一份存档');const name=await ask('复制存档','新副本会有独立身份，后续进度互不影响。',arr(state.profiles).find(p=>p.id===ids[0]).name+' 副本');if(name){await api('/api/create',{name,clone:ids[0]});await refresh();}});
$('selectAll').onchange=()=>{selected=$('selectAll').checked?new Set(arr(state.profiles).map(p=>p.id)):new Set();renderProfiles();};
$('exportToken').onclick=action(async()=>{exported=(await api('/api/export',{ids:selection(),checkpoint:$('includeCheckpoint').checked})).token;$('exportText').value=exported;message(`口令已生成，共 ${exported.length.toLocaleString()} 个字符。`);});
$('copyToken').onclick=action(()=>copy(exported));$('downloadToken').onclick=action(async()=>{if(!exported)throw Error('请先生成口令');const blob=new Blob([exported],{type:'text/plain;charset=utf-8'});if(window.BossRushNative){window.BossRushNative.save(exported);message('已打开系统文件保存界面。');return;}const url=URL.createObjectURL(blob),a=node('a');a.href=url;a.download='BossRush-'+new Date().toISOString().slice(0,10)+'.brsave';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);});
$('showQR').onclick=action(()=>showQR(exported,'存档二维码 · 无需网络'));
$('previewToken').onclick=action(()=>acceptScan($('importText').value.trim()));
$('pasteToken').onclick=action(async()=>{$('importText').value=window.BossRushNative?window.BossRushNative.paste():await navigator.clipboard.readText();});
$('importFile').onchange=action(async e=>{const file=e.target.files[0];if(file){if(file.size>24*1024*1024)throw Error('文件超过 24 MiB 上限');await acceptScan(await file.text());}e.target.value='';});
$('qrImages').onchange=action(async e=>{for(const file of e.target.files){if(file.size>20*1024*1024)throw Error('图片过大');const url=URL.createObjectURL(file),image=new Image();try{image.src=url;await image.decode();const value=await decodeImage(image);if(!value)throw Error('图片中未找到可识别的二维码');await acceptScan(value);}finally{URL.revokeObjectURL(url);}}e.target.value='';});
$('scanQR').onclick=$('scanPair').onclick=action(camera);$('closeCamera').onclick=stopCamera;$('cameraDialog').addEventListener('cancel',stopCamera);
$('previousQR').onclick=()=>{qrIndex=(qrIndex+qrParts.length-1)%qrParts.length;drawQR();};$('nextQR').onclick=()=>{qrIndex=(qrIndex+1)%qrParts.length;drawQR();};$('closeQR').onclick=closeQR;$('qrDialog').addEventListener('cancel',closeQR);
$('autoQR').onclick=()=>{if(timer){clearInterval(timer);timer=null;$('autoQR').textContent='自动轮播';}else{timer=setInterval(()=>{qrIndex=(qrIndex+1)%qrParts.length;drawQR();},1500);$('autoQR').textContent='停止轮播';}};
$('localAddress').onchange=()=>$('pairCode').textContent=$('localAddress').selectedOptions[0]?.dataset.code||'';
$('copyPair').onclick=action(()=>copy($('pairCode').textContent));$('pairQR').onclick=action(()=>showQR($('localAddress').selectedOptions[0]?.dataset.code,'局域网配对 · 两端须在同一网络'));
$('renewPair').onclick=action(async()=>{await api('/api/renew',{});await refresh();message('已更新配对码，旧配对码失效。');});
$('connectPair').onclick=action(()=>connect($('pairInput').value.trim()));$('remoteRefresh').onclick=action(async()=>renderRemote((await job(await api('/api/remote',{}))).profiles));
$('pullProfiles').onclick=action(async()=>{await job(await api('/api/pull',{ids:remoteSelection(),checkpoint:$('includeCheckpoint').checked}));await refresh();$('incomingSection').scrollIntoView({behavior:'smooth'});message('拉取完成，请在待导入区勾选并确认。');});
$('pushProfiles').onclick=action(async()=>{await job(await api('/api/push',{ids:selection(),checkpoint:$('includeCheckpoint').checked}));message('已发送，对方可选择其中一份或几份导入。');});
$('returnGame').onclick=action(async()=>{await api('/api/close',{});closed=true;stopCamera();if(window.BossRushNative)window.BossRushNative.close();else{document.querySelector('main').hidden=true;document.querySelector('nav').hidden=true;message('管理已关闭，可返回游戏。重新同步请在游戏中打开存档管理。');}});
window.addEventListener('pagehide',()=>{stopCamera();fetch('/api/close',{method:'POST',headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:'{}',keepalive:true}).catch(()=>{});});
if(!token)message('请从游戏中的“存档 / 同步”入口打开此页面。',true);else refresh().catch(e=>message(e.message,true));
setInterval(()=>{if(token&&!closed)refresh().catch(e=>message('连接中断：'+e.message,true));},4000);
// 供无相机的自动化回归注入真实二维码解码结果；不暴露存档密钥或写盘接口。
window.BossRushSaveUI={makeParts,acceptScan,decodeImage};
