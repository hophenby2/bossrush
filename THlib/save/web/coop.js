'use strict';
const $=id=>document.getElementById(id);
const token=new URLSearchParams(location.hash.slice(1)).get('token')||'';
history.replaceState(null,'',location.pathname);
let state={},closed=false,lastCode='',entered=false;
const phases={idle:'尚未连接',hosting:'等待另一位玩家',joining:'连接中…',joined:'已加入，等待房主开始',syncing:'重连同步中…',playing:'游戏中',disconnected:'连接已断开'};
function message(text,error=false){$('message').textContent=text;$('message').className=error?'error':'';}
async function api(path,body){const r=await fetch(path,{method:body===undefined?'GET':'POST',headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:body===undefined?undefined:JSON.stringify(body)});const v=await r.json();if(!r.ok)throw Error(v.error||'操作失败');return v;}
function action(fn){return async e=>{const b=e?.currentTarget;try{if(b)b.disabled=true;await fn();}catch(e){message(e.message,true);}finally{if(b)b.disabled=false;}};}
async function refresh(){
 const previous=state.phase;state=await api('/api/coop/status');
 $('status').textContent=(phases[state.phase]||state.phase)+(state.role?' · '+(state.role==='host'?'房主 P1':'加入方 P2'):'');
 $('details').textContent=state.error||((state.connected?'双方已连接':'等待连接')+(state.ready?' · 已准备':'')+' · '+state.ping+' ms'+(state.paused?.some(Boolean)?' · 已暂停':''));
 $('start').disabled=!(state.role==='host'&&state.connected&&state.ready&&!state.match);
 $('hero').disabled=!!state.role;$('host').disabled=state.match;$('join').disabled=state.match;
 $('reconnect').hidden=!(state.role==='client'&&!state.connected);$('resume').hidden=!state.match;
 $('addresses').textContent='本机地址：'+(Array.isArray(state.addresses)&&state.addresses.length?state.addresses.join(' / '):'尚未找到，可手动填写');
 $('invite').hidden=!state.code||state.role!=='host';
 if(state.code&&state.code!==lastCode){lastCode=state.code;$('code').value=state.code;const q=qrcode(0,'M');q.addData(state.code,'Byte');q.make();$('qr').innerHTML=q.createSvgTag({cellSize:3,margin:16});}
 $('summary').textContent=state.summary?(state.summary.won?'合作通关':'合作结束')+' · 分数 '+state.summary.score+' · 失误 '+state.summary.misses+' · 收卡 '+state.summary.captures:'';
 if(state.phase==='playing'&&!entered&&['joined','joining','syncing'].includes(previous)){entered=true;await closeView();}
}
async function closeView(){await api('/api/close',{});closed=true;if(window.BossRushNative)window.BossRushNative.close();else message('可返回游戏窗口。F9 可重新打开联机大厅。');}
$('transport').onchange=()=>{$('directFields').hidden=$('transport').value!=='direct';$('relayFields').hidden=$('transport').value!=='relay';};
$('host').onclick=action(async()=>{await api('/api/coop/host',{hero:$('hero').value,mode:$('mode').value,port:Number($('port').value),address:$('address').value.trim(),relay:$('transport').value==='relay'?$('relay').value.trim():''});entered=false;message('已创建房间，请把口令发给另一位玩家。');await refresh();});
$('join').onclick=action(async()=>{await api('/api/coop/join',{hero:$('hero').value,code:$('joinCode').value.trim(),address:$('override').value.trim()});entered=false;message('正在连接房主…');await refresh();});
$('start').onclick=action(async()=>{await api('/api/coop/start',{});entered=true;await closeView();});
$('leave').onclick=action(async()=>{await api('/api/coop/leave',{});entered=false;lastCode='';message('已退出房间，可返回标题。');await refresh();});
$('resume').onclick=action(async()=>{await api('/api/coop/pause',{value:false});await closeView();});
$('returnGame').onclick=action(closeView);
$('reconnect').onclick=action(async()=>{const code=state.code,hero=state.hero;await api('/api/coop/join',{code,hero,address:$('override').value.trim()});entered=false;await refresh();});
$('copy').onclick=action(async()=>{const value=$('code').value;if(window.BossRushNative){if(!window.BossRushNative.copy(value))throw Error('复制失败，请手动选择口令');}else{try{await navigator.clipboard.writeText(value);}catch(_){$('code').select();if(!document.execCommand('copy'))throw Error('请手动选择并复制口令');}}message('房间口令已复制。');});
async function poll(){if(closed)return;try{await refresh();}catch(e){message(e.message,true);}if(!closed)setTimeout(poll,500);}
poll();
