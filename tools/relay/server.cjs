// 只转发联机报文；不运行游戏、不接收存档。Node 内置模块，无第三方依赖。
'use strict';
const net=require('node:net');
const crypto=require('node:crypto');
const MAX=2*1024*1024,MAX_ROOMS=Number(process.env.MAX_ROOMS||200);
const rooms=new Map(),sockets=new Set();
function frame(kind,value){const body=Buffer.concat([Buffer.from(kind),Buffer.isBuffer(value)?value:Buffer.from(JSON.stringify(value))]);const h=Buffer.alloc(4);h.writeUInt32BE(body.length);return Buffer.concat([h,body]);}
function message(s,value){if(!s.destroyed)s.write(frame('J',value));}
function equal(a,b){return typeof a==='string'&&typeof b==='string'&&a.length===b.length&&crypto.timingSafeEqual(Buffer.from(a),Buffer.from(b));}
const server=net.createServer(s=>{
 s.setNoDelay(true);s.setKeepAlive(true,5000);sockets.add(s);let buffer=Buffer.alloc(0),registered=false,room,role;
 const timer=setTimeout(()=>{if(!registered)s.destroy();},10000);timer.unref();
 function forward(packet){
  const target=role==='host'?room.guest:room.host;
  if(!target||target.destroyed)return;
  if(target.writableLength>8*MAX){s.destroy();return;}
  if(!target.write(packet)){s.pause();target.once('drain',()=>{if(!s.destroyed)s.resume();});}
 }
 s.on('data',chunk=>{
  try{
   buffer=Buffer.concat([buffer,chunk]);if(buffer.length>MAX+65536)throw Error('报文缓冲过大');
   while(buffer.length>=4){
    const length=buffer.readUInt32BE(0);if(length<1||length>MAX)throw Error('报文长度无效');
    if(buffer.length<length+4)break;
    const packet=buffer.subarray(0,length+4),body=buffer.subarray(4,length+4);buffer=buffer.subarray(length+4);
    if(!registered){
     if(length>4096||body[0]!==74)throw Error('缺少登记');
     const v=JSON.parse(body.subarray(1));if(!/^[a-f0-9]{32}$/.test(v.room)||!/^[a-f0-9]{64}$/.test(v.auth))throw Error('房间口令无效');
     if(v.t==='relay-host'){
      if(rooms.has(v.room)||rooms.size>=MAX_ROOMS)throw Error('房间已存在或中继已满');
      role='host';room={id:v.room,auth:v.auth,host:s,guest:null};rooms.set(v.room,room);
      message(s,{t:'relay-ready'});
     }else if(v.t==='relay-join'){
      room=rooms.get(v.room);if(!room||!equal(room.auth,v.auth)||room.guest)throw Error('房间不存在、口令错误或已满');
      role='guest';room.guest=s;message(room.host,{t:'relay-paired'});message(s,{t:'relay-paired'});
     }else throw Error('登记类型无效');
     registered=true;clearTimeout(timer);
    }else forward(packet);
   }
  }catch(e){message(s,{t:'relay-error',message:e.message});s.end();}
 });
 s.on('error',()=>{});
 s.on('close',()=>{
  clearTimeout(timer);sockets.delete(s);
  if(!room)return;
  if(role==='host'){
   rooms.delete(room.id);if(room.guest){message(room.guest,{t:'relay-peer-left',message:'房主已离开'});room.guest.end();}
  }else if(room.guest===s){room.guest=null;message(room.host,{t:'relay-peer-left',message:'另一位玩家已断开，可重新加入'});}
 });
});
const heartbeat=setInterval(()=>{for(const s of sockets)message(s,{t:'relay-heartbeat'});},5000);heartbeat.unref();
const port=Number(process.env.PORT||39778),bind=process.env.BIND||'0.0.0.0';
server.listen(port,bind,()=>process.stdout.write(JSON.stringify({ready:true,port:server.address().port,bind})+'\n'));
function shutdown(){clearInterval(heartbeat);for(const s of sockets)s.destroy();server.close(()=>process.exit(0));}
process.on('SIGTERM',shutdown);process.on('SIGINT',shutdown);
