// 实际浏览器回归：管理界面、选择导入、二维码编码和图片解码。
const fs=require('fs'), path=require('path'), os=require('os'), {spawn}=require('child_process');
const puppeteer=require(process.env.BOSSRUSH_PUPPETEER||'/opt/homebrew/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/puppeteer');
const root=path.resolve(__dirname,'../..'),sandbox=fs.mkdtempSync(path.join(os.tmpdir(),'bossrush-browser-'));
const host=spawn('luajit',[path.join(__dirname,'host.lua'),root,sandbox],{stdio:['ignore','pipe','pipe']});let browser;
const wait=ms=>new Promise(r=>setTimeout(r,ms));
(async()=>{
  for(let i=0;!fs.existsSync(path.join(sandbox,'host.json'))&&i<150;i++)await wait(20);
  const config=JSON.parse(fs.readFileSync(path.join(sandbox,'host.json')));
  const base='http://127.0.0.1:'+config.port;
  async function api(url,body){const r=await fetch(base+url,{method:body?'POST':'GET',headers:{Authorization:'Bearer '+config.token,'Content-Type':'application/json'},body:body?JSON.stringify(body):undefined});const v=await r.json();if(!r.ok)throw Error(v.error);return v;}
  browser=await puppeteer.launch({headless:true});const page=await browser.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.setViewport({width:1100,height:850});await page.goto(base+'/#token='+config.token);await page.waitForSelector('.card');
  await page.type('#profileName','浏览器测试存档');await page.click('#createForm button[type=submit]');await page.waitForFunction(()=>document.querySelectorAll('#profileList .card').length===2);
  await page.click('#selectAll');await page.click('[data-tab=exchange]');await page.click('#exportToken');await page.waitForFunction(()=>document.getElementById('exportText').value.startsWith('BRS1.'));
  const exported=await page.$eval('#exportText',e=>e.value);await page.type('#importText',exported);await page.click('#previewToken');await page.waitForSelector('#incomingList .incomingRow');
  const count=await page.$$eval('#incomingList .incomingRow',nodes=>nodes.length);if(count!==2)throw Error('导入预览未列出两个存档');
  await page.click('#showQR');await page.waitForSelector('#qrCanvas svg');
  const decoded=await page.evaluate(async()=>{
    const svg=document.querySelector('#qrCanvas svg'),text=new XMLSerializer().serializeToString(svg),image=new Image();image.src='data:image/svg+xml;base64,'+btoa(text);await image.decode();return BossRushSaveUI.decodeImage(image);
  });
  if(!decoded?.startsWith('BRS1.')&&!decoded?.startsWith('BRQ1.'))throw Error('真实二维码图像解码失败');
  await page.click('#closeQR');
  // 大口令分片乱序、重复扫描，最终只生成一份预览。
  await api('/api/dismiss',{pending:(await api('/api/status')).incoming[0].pending});
  const randomEntry=await api('/api/create',{name:'二维码长内容'});const payload=JSON.stringify({money:7,extra:require('crypto').randomBytes(2048).toString('hex')});
  const password=[2,3,5,7,11,13,17,19,23,29,31,37,41];
  fs.writeFileSync(path.join(sandbox,'User/profiles',randomEntry.id,'Score.dat'),Buffer.from([...Buffer.from(payload)].map((v,i)=>(v+password[(i+1)%13]-1)%127+1)));
  const bundle=await api('/api/export',{ids:[randomEntry.id],checkpoint:false});
  const parts=await page.evaluate(value=>BossRushSaveUI.makeParts(value),bundle.token);
  if(parts.length<2)throw Error('分片测试数据不足');
  await page.evaluate(async values=>{for(const v of [values[values.length-1],...values].reverse())await BossRushSaveUI.acceptScan(v);},parts);
  const state=await api('/api/status');if(state.incoming.length!==1)throw Error('二维码导入预览数量错误');
  await page.setViewport({width:390,height:844});await page.click('[data-tab=profiles]');await page.evaluate(()=>window.scrollTo({top:0,behavior:'instant'}));
  const overflow=await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth);if(overflow)throw Error('移动端界面横向溢出');
  await page.screenshot({path:path.join(root,'android/dist/save-sync-test/manager-mobile.png'),fullPage:true});
  await page.setViewport({width:1100,height:850});await page.screenshot({path:path.join(root,'android/dist/save-sync-test/manager-desktop.png'),fullPage:true});
  if(errors.length)throw Error(errors.join('; '));console.log('浏览器回归通过：创建/选择、两份导入预览、真实二维码图像解码、分片导入、390px 布局。');
})().catch(e=>{console.error(e);process.exitCode=1;}).finally(async()=>{if(browser)await browser.close();host.kill();fs.rmSync(sandbox,{recursive:true,force:true});});
