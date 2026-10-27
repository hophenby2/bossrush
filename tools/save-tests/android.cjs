// 实际 Android WebView ↔ Windows x64（Wine）存档服务；仅桌面端使用临时数据。
const fs=require('fs'),path=require('path'),os=require('os'),{spawn,execFileSync}=require('child_process');
const puppeteer=require(process.env.BOSSRUSH_PUPPETEER||'/opt/homebrew/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/puppeteer');
const root=path.resolve(__dirname,'../..'),adb=process.env.ADB||path.join(os.homedir(),'Library/Android/sdk/platform-tools/adb');
const win=p=>'Z:'+p.replaceAll('/','\\'),sleep=ms=>new Promise(r=>setTimeout(r,ms));
const run=(...args)=>execFileSync(adb,args,{encoding:'utf8',timeout:10000});
const sandbox=fs.mkdtempSync(path.join(os.tmpdir(),'bossrush-win-android-'));
const pc=spawn('wine',[path.join(root,'android/build/save-tests/LuaJIT-win/src/luajit.exe'),win(path.join(__dirname,'host.lua')),win(root),win(sandbox)],{env:{...process.env,WINEPREFIX:path.join(root,'android/build/save-tests/wine'),WINEDEBUG:'-all',MVK_CONFIG_LOG_LEVEL:'0'},stdio:['ignore','pipe','pipe']});
let browser,pcHeartbeat;
(async()=>{
  for(let n=0;!fs.existsSync(path.join(sandbox,'host.json'))&&n<1000;n++)await sleep(30);
  const config=JSON.parse(fs.readFileSync(path.join(sandbox,'host.json')));
  const desktop=async(p,body)=>{const r=await fetch('http://127.0.0.1:'+config.port+p,{method:body?'POST':'GET',headers:{Authorization:'Bearer '+config.token,'Content-Type':'application/json'},body:body?JSON.stringify(body):undefined});const v=await r.json();if(!r.ok)throw Error(v.error);return v;};
  const tag=Date.now().toString(36),labelA='PC 同步测试 A '+tag,labelB='PC 同步测试 B '+tag,labelMobile='Android 反向同步测试 '+tag;
  pcHeartbeat=setInterval(()=>desktop('/api/status').catch(()=>{}),4000);pcHeartbeat.unref();
  const first=(await desktop('/api/create',{name:labelA})).id,second=(await desktop('/api/create',{name:labelB})).id;
  const lock=s=>{const p=[2,3,5,7,11,13,17,19,23,29,31,37,41];return Buffer.from([...Buffer.from(s)].map((v,i)=>(v+p[(i+1)%13]-1)%127+1));};
  fs.writeFileSync(path.join(sandbox,'User/profiles',first,'Score.dat'),lock(JSON.stringify({money:321,PlayerBrand:'PC_SYNC'})));
  // 直到真实游戏进入标题，才发送 F10，避免加载阶段吞掉输入。
  for(let i=0;i<180;i++){const log=run('shell','run-as','org.bossrush.hd','tail','-c','7000','files/lstg_log.txt');if(log.includes('BOSSRUSH_STAGE: menu')||log.includes('BOSSRUSH_PERF: stage=menu'))break;await sleep(1000);}
  run('shell','input','swipe','2000','32','2000','32','1000');await sleep(1500);
  const pid=run('shell','pidof','org.bossrush.hd').trim();
  for(let i=0;i<180;i++){if(run('shell','cat','/proc/net/unix').includes('webview_devtools_remote_'+pid))break;await sleep(1000);}
  run('forward','tcp:9223','localabstract:webview_devtools_remote_'+pid);
  browser=await puppeteer.connect({browserURL:'http://127.0.0.1:9223'});
  let page;for(let i=0;i<60;i++){page=(await browser.pages()).find(p=>p.url().startsWith('http://127.0.0.1:'));if(page)break;await sleep(500);}
  if(!page)throw Error('Android 管理页未打开');await page.waitForFunction(()=>typeof api==='function'&&document.querySelector('#profileList .card'),{timeout:60000});
  const mobile=(p,body)=>page.evaluate(args=>args.hasBody?api(args.path,args.body):api(args.path),{path:p,body:body??null,hasBody:body!==undefined});
  const original=(await mobile('/api/status')).active;await page.evaluate(()=>{if(typeof stopCamera==='function')stopCamera();});
  const token=(await desktop('/api/export',{ids:[first,second],checkpoint:false})).token;
  const qrcode=require(path.join(root,'THlib/save/web/vendor/qrcode.js'));
  const fragments=await page.evaluate(value=>BossRushSaveUI.makeParts(value),token);
  for(const fragment of [...fragments].reverse()){
    const qr=qrcode(0,'M');qr.addData(fragment,'Byte');qr.make();const image=Buffer.from(qr.createSvgTag({cellSize:4,margin:20,scalable:false})).toString('base64');
    await page.evaluate(async encoded=>{const image=new Image();image.src='data:image/svg+xml;base64,'+encoded;await image.decode();const value=await BossRushSaveUI.decodeImage(image);if(!value)throw Error('Android QR 图像识别失败');await BossRushSaveUI.acceptScan(value);},image);
  }
  let status=await mobile('/api/status');let offer=status.incoming.find(v=>v.entries.length===2);if(!offer)throw Error('二维码未读取两份存档');
  await mobile('/api/import',{pending:offer.pending,selection:[1],policy:'copy'});status=await mobile('/api/status');
  if(!status.profiles.some(p=>p.name===labelA)||status.profiles.some(p=>p.name===labelB))throw Error('Android 选择性导入错误');
  const pair=Buffer.from(config.code.slice(5),'base64url');pair.set([10,0,2,2],0);const code='BRP1-'+pair.toString('base64url');
  const job=async operation=>{for(let i=0;i<180;i++){const v=await mobile('/api/job/'+operation.job);if(v.state==='done')return v.result;if(v.state==='error')throw Error(v.error);await sleep(250);}throw Error('Android 网络传输超时');};
  await job(await mobile('/api/pair',{code}));
  offer=await job(await mobile('/api/pull',{ids:[second],checkpoint:false}));await mobile('/api/import',{pending:offer.pending,selection:[1],policy:'copy'});
  const native=(await mobile('/api/create',{name:labelMobile})).id;
  const sent=await job(await mobile('/api/push',{ids:[native],checkpoint:false}));
  await desktop('/api/import',{pending:sent.pending,selection:[1],policy:'copy'});
  if(!(await desktop('/api/status')).profiles.some(p=>p.name===labelMobile))throw Error('Android → Windows 反向同步失败');
  // 切换空槽验证运行时缓存重建；随后返回原槽，保留原有玩家进度。
  await mobile('/api/switch',{id:native});for(let i=0;i<120;i++){if((await mobile('/api/status')).active===native)break;await sleep(250);}
  if((await mobile('/api/status')).active!==native)throw Error('Android 未完成切换');
  await mobile('/api/switch',{id:original});for(let i=0;i<120;i++){if((await mobile('/api/status')).active===original)break;await sleep(250);}
  if((await mobile('/api/status')).active!==original)throw Error('Android 未恢复原槽');
  // 实际相机权限与视频帧；二维码识别另以上方真实 QR 图像通过 Android JS 引擎验证。
  run('shell','pm','grant','org.bossrush.hd','android.permission.CAMERA');await page.click('[data-tab=exchange]');await page.click('#scanQR');
  await page.waitForFunction(()=>document.querySelector('#camera').readyState>=2,{timeout:30000});
  const camera=await page.evaluate(()=>({width:$('camera').videoWidth,height:$('camera').videoHeight}));
  if(camera.width<1)throw Error('Android 相机无画面');
  fs.writeFileSync(path.join(root,'android/dist/save-sync-test/android-camera.png'),execFileSync(adb,['exec-out','screencap','-p'],{maxBuffer:16*1024*1024}));await page.click('#closeCamera');
  await page.click('[data-tab=profiles]');await page.evaluate(()=>window.scrollTo({top:0,behavior:'instant'}));
  fs.writeFileSync(path.join(root,'android/dist/save-sync-test/android-manager.png'),execFileSync(adb,['exec-out','screencap','-p'],{maxBuffer:16*1024*1024}));
  fs.writeFileSync(path.join(root,'android/dist/save-sync-test/android-integration.json'),JSON.stringify({passed:true,qrParts:fragments.length,selectedImport:true,windowsToAndroid:true,androidToWindows:true,switchAndRestore:true,camera},null,2));
  await page.click('#returnGame').catch(()=>{});await sleep(1000);fs.writeFileSync(path.join(root,'android/dist/save-sync-test/android-restored.png'),execFileSync(adb,['exec-out','screencap','-p'],{maxBuffer:16*1024*1024}));
  console.log('Android 实机运行回归通过：QR 图像导入、多存档筛选、Windows x64 双向传输、切换空槽再恢复、相机视频帧。');
})().catch(error=>{console.error(error);process.exitCode=1;}).finally(()=>{clearInterval(pcHeartbeat);if(browser)browser.disconnect();pc.kill();fs.rmSync(sandbox,{recursive:true,force:true});});
