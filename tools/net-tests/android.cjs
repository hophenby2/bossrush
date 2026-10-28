// 在两个已初始化的安卓模拟器上验证真实双人战斗；测试槽与恢复信息写入忽略的 dist。
'use strict';
const fs=require('node:fs'),path=require('node:path'),cp=require('node:child_process');
const puppeteer=require(process.env.BOSSRUSH_PUPPETEER||'/opt/homebrew/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/puppeteer');
const root=path.resolve(__dirname,'../..'),out=path.join(root,'android/dist/net-test');fs.mkdirSync(out,{recursive:true});
const stateFile=path.join(out,'device-state.json'),state=fs.existsSync(stateFile)?JSON.parse(fs.readFileSync(stateFile)):{};
const adb=process.env.ADB||path.join(process.env.HOME,'Library/Android/sdk/platform-tools/adb');
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const run=(s,...a)=>cp.execFileSync(adb,['-s',s,...a],{timeout:20000,maxBuffer:16*1024*1024});
const save=()=>fs.writeFileSync(stateFile,JSON.stringify(state,null,2));
const sides=[{name:'host',serial:process.env.BOSSRUSH_HOST_SERIAL||'emulator-5554',debug:9223,http:42301},{name:'guest',serial:process.env.BOSSRUSH_GUEST_SERIAL||'emulator-5556',debug:9224,http:42302}];
async function until(fn,seconds=40){const end=Date.now()+seconds*1000;let error;while(Date.now()<end){try{const v=await fn();if(v)return v;}catch(e){error=e;}await sleep(100);}throw error||Error('等待联机状态超时');}
async function api(side,url,body){const r=await fetch('http://127.0.0.1:'+side.http+url,{method:body===undefined?'GET':'POST',headers:{Authorization:'Bearer '+state[side.name+'Api'].token,'Content-Type':'application/json'},body:body===undefined?undefined:JSON.stringify(body),signal:AbortSignal.timeout(15000)});const v=await r.json();if(!r.ok)throw Error(v.error);return v;}
const net=s=>api(s,'/api/coop/status');
async function open(side){
 await until(()=>run(side.serial,'exec-out','run-as','org.bossrush.hd','tail','-c','2200','files/lstg_log.txt').toString().includes('stage=menu'),120);
 run(side.serial,'shell','input','tap','1350','32');
 const socket=await until(()=>run(side.serial,'shell','cat','/proc/net/unix').toString().split('\n').find(s=>s.includes('webview_devtools_remote_'))?.trim().split(/\s+/).at(-1)?.slice(1));
 run(side.serial,'forward','tcp:'+side.debug,'localabstract:'+socket);
 const browser=await puppeteer.connect({browserURL:'http://127.0.0.1:'+side.debug});
 const page=(await browser.pages()).find(p=>p.url().includes('/coop.html'));if(!page)throw Error('联机大厅未打开');
 await page.waitForFunction(()=>typeof api==='function');
 const config=await page.evaluate(()=>({port:Number(location.port),token}));state[side.name+'Api']=config;save();
 run(side.serial,'forward','tcp:'+side.http,'tcp:'+config.port);
 const status=await api(side,'/api/status');
 if(!state[side.name+'Test']){
  state[side.name+'Original']=status.active;
  state[side.name+'Test']=(await api(side,'/api/create',{name:'联机原生测试 '+side.name+' '+Date.now(),clone:status.active})).id;save();
 }
 if(status.active!==state[side.name+'Test']){await api(side,'/api/switch',{id:state[side.name+'Test']});await until(async()=>(await api(side,'/api/status')).active===state[side.name+'Test']);}
 return {browser,page};
}
async function prepare(){for(const side of sides){const b=await open(side);b.browser.disconnect();console.log(side.name+' 联机大厅与测试槽就绪');}}
async function closeNative(side){try{const b=await puppeteer.connect({browserURL:'http://127.0.0.1:'+side.debug});for(const p of await b.pages())try{await p.evaluate(()=>{if(window.BossRushNative)BossRushNative.close();});}catch(_){}b.disconnect();}catch(_){} }
async function battle(relay){
 const [h,g]=sides;let server;
 try{
  await api(g,'/api/coop/leave',{});await api(h,'/api/coop/leave',{});
  let options={hero:'reimu_player',mode:'dual',port:39777,address:'10.0.2.15'};
  if(relay){server=cp.spawn('node',[path.join(root,'tools/relay/server.cjs')],{env:{...process.env,PORT:'39778',BIND:'0.0.0.0'},stdio:['ignore','pipe','pipe']});await until(()=>new Promise(resolve=>server.stdout.once('data',()=>resolve(true))),10);options.relay='10.0.2.2:39778';}
  else run(h.serial,'forward','tcp:39777','tcp:39777');
  const room=await api(h,'/api/coop/host',options);state.code=room.code;save();
  await api(g,'/api/coop/join',{code:room.code,hero:'reimu_player',address:relay?'':'10.0.2.2:39777'});
  await until(async()=>(await net(h)).ready);
  await api(h,'/api/coop/start',{});await Promise.all(sides.map(closeNative));
  await until(async()=>{const s=await net(g);if(s.error)throw Error(s.error);return s.frames>4;});
  const before=await net(h);
  run(g.serial,'shell','input','swipe','620','820','620','820','700');
  await sleep(200);const after=await net(h);
  if(after.players.length!==2||after.players[1].x<=before.players[1].x||Math.abs(after.players[0].x-before.players[0].x)>1)throw Error('双自机独立移动失败：'+JSON.stringify({before,after}));
  console.log('客机触控独立移动通过',before.players,after.players);
  // 两端各射击一秒，实际游戏代码生成各自的子弹及所有权。
  await Promise.all(sides.map(s=>new Promise((resolve,reject)=>cp.execFile(adb,['-s',s.serial,'shell','input','swipe','1946','900','1946','900','1500'],{timeout:10000},e=>e?reject(e):resolve()))));
  await sleep(700);const healthy=await net(g);if(!healthy.connected||healthy.frames<8)throw Error('射击后画面同步中断');
  await api(g,'/api/coop/pause',{value:true});await until(async()=>(await net(h)).paused[1]);await sleep(250);const paused=(await net(h)).tick;await sleep(400);if((await net(h)).tick!==paused)throw Error('暂停后逻辑仍推进');
  for(const s of sides)fs.writeFileSync(path.join(out,s.name+'-'+(relay?'relay':'direct')+'.png'),run(s.serial,'exec-out','screencap','-p'));
  await api(g,'/api/coop/pause',{value:false});await until(async()=>(await net(h)).tick>paused);
  const result={host:await net(h),guest:await net(g)};fs.writeFileSync(path.join(out,(relay?'relay':'direct')+'-result.json'),JSON.stringify(result,null,2));console.log((relay?'中继':'直连')+' 原生双端通过',JSON.stringify({frames:result.guest.frames,tick:result.host.tick,bytes:result.host.snapshotBytes,commands:result.host.renderCommands,ping:result.guest.ping}));
 }finally{await api(sides[1],'/api/coop/leave',{}).catch(()=>{});await api(sides[0],'/api/coop/leave',{}).catch(()=>{});if(server)server.kill();}
}
async function cleanup(){for(const s of sides){await api(s,'/api/coop/leave',{});const original=state[s.name+'Original'],test=state[s.name+'Test'];if(original){await api(s,'/api/switch',{id:original});await until(async()=>(await api(s,'/api/status')).active===original);if(test)await api(s,'/api/archive',{id:test});await api(s,'/api/close',{});console.log(s.name+' 已恢复原槽并归档测试槽');}}}
(async()=>{const mode=process.argv[2]||'prepare';if(mode==='prepare')await prepare();else if(mode==='cleanup')await cleanup();else await battle(mode==='relay');})().catch(e=>{console.error(e);process.exitCode=1;});
