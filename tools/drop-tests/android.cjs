// 真实安卓回归：独立测试槽、击破掉落、强杀恢复、提前接取和实际命中倍率。
'use strict';
const fs=require('node:fs'),path=require('node:path'),cp=require('node:child_process');
const puppeteer=require(process.env.BOSSRUSH_PUPPETEER||'/opt/homebrew/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/puppeteer');
const root=path.resolve(__dirname,'../..'),out=path.join(root,'android/dist',process.env.BOSSRUSH_ANDROID_TEST_DIR||'choice-test');fs.mkdirSync(out,{recursive:true});
const file=path.join(out,'device-state.json');let state=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};
const adb=process.env.ADB||path.join(process.env.HOME,'Library/Android/sdk/platform-tools/adb'),serial=process.env.BOSSRUSH_SERIAL||'emulator-5554';
const run=(...args)=>cp.execFileSync(adb,['-s',serial,...args],{timeout:30000,maxBuffer:16*1024*1024});
const sleep=ms=>new Promise(r=>setTimeout(r,ms));const save=()=>fs.writeFileSync(file,JSON.stringify(state,null,2));
async function until(fn,seconds=120){const end=Date.now()+seconds*1000;let error;while(Date.now()<end){try{const v=await fn();if(v)return v;}catch(e){if(e.fatal)throw e;error=e;}await sleep(200);}throw error||Error('等待安卓测试状态超时');}
function log(){return run('exec-out','run-as','org.bossrush.hd','tail','-c','18000','files/lstg_log.txt').toString();}
function checkLog(){const text=log();if(text.includes('BOSSRUSH_ERROR:')){const e=Error(text.slice(-6000));e.fatal=true;throw e;}return text;}
async function api(url,body){const r=await fetch('http://127.0.0.1:42311'+url,{method:body===undefined?'GET':'POST',headers:{Authorization:'Bearer '+state.token,'Content-Type':'application/json'},body:body===undefined?undefined:JSON.stringify(body),signal:AbortSignal.timeout(20000)});const v=await r.json();if(!r.ok)throw Error(v.error);return v;}
async function manager(){
 run('shell','input','tap','2000','32');
 const pid=run('shell','pidof','org.bossrush.hd').toString().trim().split(/\s+/)[0];
 const socket=await until(()=>run('shell','cat','/proc/net/unix').toString().split('\n').find(s=>s.includes('webview_devtools_remote_'+pid))?.trim().split(/\s+/).at(-1)?.slice(1),40);
 run('forward','tcp:9231','localabstract:'+socket);
 const browser=await puppeteer.connect({browserURL:'http://127.0.0.1:9231'});let page;
 try{page=await until(async()=>(await browser.pages()).find(p=>p.url().includes('127.0.0.1')),40);}catch(e){browser.disconnect();throw e;}
 await page.waitForFunction(()=>typeof api==='function');const config=await page.evaluate(()=>({port:Number(location.port),token}));state.port=config.port;state.token=config.token;save();
 run('forward','tcp:42311','tcp:'+config.port);return {browser,page};
}
async function close(view){await api('/api/close',{});try{await view.page.evaluate(()=>BossRushNative.close());}catch(_){}view.browser.disconnect();}
function diagnostics(value){
 const local=path.join(out,'diagnostic.tmp');fs.writeFileSync(local,value);run('push',local,'/data/local/tmp/bossrush-drops-mode');run('shell','run-as','org.bossrush.hd','cp','/data/local/tmp/bossrush-drops-mode','files/bossrush/User/android-diagnostics');run('shell','rm','/data/local/tmp/bossrush-drops-mode');
}
function snapshot(name){fs.writeFileSync(path.join(out,name+'.png'),run('exec-out','screencap','-p'));}
function read(){checkLog();const r=cp.spawnSync(adb,['-s',serial,'exec-out','run-as','org.bossrush.hd','cat','files/bossrush/User/profiles/'+state.test+'/drops-check.json'],{timeout:10000});const text=r.stdout.toString();if(!text.trim().startsWith('{'))throw Error('诊断尚未生成');return JSON.parse(text);}
async function prepare(){
 const process=cp.spawnSync(adb,['-s',serial,'shell','pidof','org.bossrush.hd']);
 if(!process.stdout.toString().trim()){run('shell','am','start','-n','org.bossrush.hd/.BossRushActivity');await sleep(3000);}
 await until(()=>checkLog().includes('stage=menu'));const view=await manager();const status=await api('/api/status');
 if(!state.test){
  state.original=status.active;state.originalEntry=status.profiles.find(p=>p.id===status.active);
  const exists=cp.spawnSync(adb,['-s',serial,'shell','run-as','org.bossrush.hd','test','-f','files/bossrush/User/android-diagnostics']);
  state.diagnostics=exists.status===0?run('exec-out','run-as','org.bossrush.hd','cat','files/bossrush/User/android-diagnostics').toString('base64'):null;
  state.test=(await api('/api/create',{name:'阶段掉落测试 '+Date.now(),clone:status.active})).id;save();
 }
 await api('/api/switch',{id:state.test});await until(async()=>(await api('/api/status')).active===state.test);await close(view);console.log('独立测试槽已就绪');
}
async function start(mode){
 run('shell','am','force-stop','org.bossrush.hd');diagnostics('drops-'+mode);run('shell','run-as','org.bossrush.hd','rm','-f','files/bossrush/User/profiles/'+state.test+'/drops-check.json');
 run('shell','am','start','-n','org.bossrush.hd/.BossRushActivity');await sleep(2000);
 let lastContinue=0;
 const result=await until(()=>{const v=read();if((v.phase==='battle'||(v.phase==='falling'&&v.age<200))&&Date.now()-lastContinue>3500&&checkLog().slice(-2000).includes('paused=true')){run('shell','input','tap','2020','1000');lastContinue=Date.now();}return v.phase==='falling'&&v.age>=200&&!v.recovering&&v;});await sleep(3200);const saved=read();const revival=mode.includes('revive');snapshot(mode.endsWith('new')?'falling':'restored');
 if(mode.endsWith('new')){state.falling=saved;save();console.log('真实 Boss 击破并暂停于掉落中途',JSON.stringify({age:saved.age,red:saved.red,blue:saved.blue}));}
 else{
  await until(()=>checkLog().includes('restore verified'));
  if(saved.age!==state.falling.age||saved.red!==100||saved.blue!==100)throw Error('掉落恢复状态不符');
  console.log('强杀恢复保留下落进度与初始倍率',saved.age);
  run('shell','input','tap','2020','1000');await sleep(1200);snapshot(revival?'revive-live':'drop-live');
  if(revival){
    const q=read().quiz;const target=(q.correct-2.5)*96;
    // 使用真实虚拟摇杆先横移到正确区域，再上顶横线，不直接改位置或答案。
    for(let attempt=0;attempt<16;attempt++){
      const hero=read().hero;if(Math.abs(target-hero.x)<20)break;
      const px=target<hero.x?400:570;
      run('shell','input','swipe',String(px),'820',String(px),'820','120');
    }
    const middle=read();const lane=Math.max(1,Math.min(4,1+Math.floor((middle.hero.x+192)/96)));
    if(lane!==q.correct)throw Error('未移到正确答案区：'+JSON.stringify(middle.hero));
    run('shell','input','swipe','484','670','484','670','2200');
    const revived=await until(()=>{const v=read();return v.phase==='picked'&&v;});
    if(revived.revive.used!==1)throw Error('真实复活没有结算一次');
    fs.writeFileSync(path.join(out,'revive-result.json'),JSON.stringify({falling:state.falling,restored:saved,revived},null,2));snapshot('revived');
    console.log('复活四区实体、强杀恢复和上顶提前提交通过');return;
  }
  run('shell','input','swipe','324','660','340','650','3000');
  const picked=await until(()=>{const v=read();return v.phase==='picked'&&v;});
  if(picked.red!==110||picked.blue!==95)throw Error('实际接取组合数值不符：'+JSON.stringify(picked));
  if(mode.includes('toggle')){
    const tap=(x,y)=>run('shell','input','tap',String(x),String(y));
    tap(1946,900);
    const on=await until(()=>{const v=read();return v.input?.shoot&&v.input.shootKey&&v.visual?.factor===1.1&&v.shots>0&&v;},30);
    await sleep(1000);const sustained=read();if(sustained.shots<=on.shots)throw Error('点击抬手后未持续射击');
    tap(1740,896);const both=await until(()=>{const v=read();return v.input?.shoot&&v.input?.slow&&v.input.slowKey&&v;},30);snapshot('toggles-on');
    tap(1946,900);await until(()=>{const v=read();return !v.input?.shoot&&v.input?.slow&&!v.input.shootKey&&v;},30);
    await sleep(700);const stopped=read();await sleep(1200);const still=read();if(stopped.shots!==still.shots)throw Error('关闭后仍产生新子弹');
    tap(1740,896);const off=await until(()=>{const v=read();return !v.input?.shoot&&!v.input?.slow&&!v.input.slowKey&&v;},30);snapshot('toggles-off');
    fs.writeFileSync(path.join(out,'toggle-result.json'),JSON.stringify({on,sustained,both,stopped,still,off},null,2));
    console.log('真实单击开关、抬手连续射击、独立低速开关、关闭后停火与贴图×1.1通过');return;
  }
  run('shell','input','swipe','1946','900','1946','900','3000');
  const hit=await until(()=>{const v=read();return v.damage&&v;},30);
  if(Math.abs(hit.damage.factor-1.1)>0.0001||Math.abs(hit.damage.value-hit.damage.base*1.1)>0.0001)throw Error('实际命中倍率错误');
  fs.writeFileSync(path.join(out,'native-result.json'),JSON.stringify({falling:state.falling,restored:saved,picked,hit},null,2));snapshot('picked');
  console.log('提前接取、红110蓝95与实际伤害×1.1通过',hit.damage);
 }
}
async function cleanup(){
 const view=await manager();await api('/api/switch',{id:state.original});await until(async()=>(await api('/api/status')).active===state.original);
 await api('/api/archive',{id:state.test});const status=await api('/api/status');const original=status.profiles.find(p=>p.id===state.original);
 for(const key of ['money','resume','checkpoint','name'])if(original[key]!==state.originalEntry[key])throw Error('原存档发生变化：'+key);
 await close(view);run('shell','am','force-stop','org.bossrush.hd');
 if(state.diagnostics===null)run('shell','run-as','org.bossrush.hd','rm','-f','files/bossrush/User/android-diagnostics');else diagnostics(Buffer.from(state.diagnostics,'base64'));
 run('shell','am','start','-n','org.bossrush.hd/.BossRushActivity');state.cleaned=true;save();console.log('已恢复原存档、归档测试槽并移除私有诊断');
}
(async()=>{const mode=process.argv[2]||'prepare';if(mode==='prepare')await prepare();else if(mode==='cleanup')await cleanup();else await start(mode);})().catch(e=>{console.error(e);process.exitCode=1;});
