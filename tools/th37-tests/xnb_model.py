"""读取已解压XNB的原始模型顶点、UV、骨骼与材质，不做网格简化。"""
import struct
from pathlib import Path
import numpy as np
class Reader:
 def __init__(self,p):
  self.b=p.read_bytes();self.at=10
  assert self.b[:3]==b'XNB' and not self.b[5]&128
 def read(self,fmt):
  f=struct.Struct('<'+fmt);v=f.unpack_from(self.b,self.at);self.at+=f.size
  return v[0] if len(v)==1 else v
 def var(self):
  n=0
  for s in range(0,35,7):
   v=self.read('B');n|=(v&127)<<s
   if v<128:return n
  raise ValueError(n)
 def string(self):
  n=self.var();v=self.b[self.at:self.at+n];self.at+=n;return v.decode()
 def parse(self):
  types=[self.string().split(',')[0].split('.')[-1] for _ in range(0)]
  for _ in range(self.var()):
   types.append(self.string().split(',')[0].split('.')[-1]);self.read('I')
  nshared=self.var();assert types[self.var()-1]=='ModelReader'
  n=self.read('I');bones=[];parents=[]
  def obj():
   kind=self.var()
   if kind==0:return None
   assert types[kind-1]=='StringReader', (kind,self.at)
   return self.string()
  def bref():return self.read('B' if n<255 else 'I')-1
  for _ in range(n):
   obj();bones.append(np.array(self.read('16f')).reshape(4,4))
  for _ in range(n):
   parents.append(bref())
   for _ in range(self.read('I')):bref()
  def transform(i):
   if i<0:return np.eye(4)
   return bones[i]@transform(parents[i])
  meshes=[]
  for _ in range(self.read('I')):
   name,bone=obj(),bref()
   self.read('4f');obj()
   transform_matrix=bones[bone] if bone>=0 else np.eye(4)
   for _ in range(self.read('I')):
    vertex,count,start,triangles=self.read('4i');obj()
    vb,ib,fx=self.var(),self.var(),self.var()
    meshes.append((name,transform_matrix,vertex,count,start,triangles,vb,ib,fx))
  bref();obj()
  shared=[None]
  for _ in range(nshared):
   t=types[self.var()-1]
   if t=='VertexBufferReader':
    stride,n=self.read('2I')
    attrs=[self.read('4I') for _ in range(n)]
    count=self.read('I')
    xy=next(v[0] for v in attrs if v[2:]==(0,0))
    uv=next(v[0] for v in attrs if v[2:]==(2,0))
    positions=np.ndarray((count,3),dtype='<f4',buffer=self.b,offset=self.at+xy,strides=(stride,4))
    tex=np.ndarray((count,2),dtype='<f4',buffer=self.b,offset=self.at+uv,strides=(stride,4))
    shared.append((positions,tex));self.at+=stride*count
   elif t=='IndexBufferReader':
    short=self.read('B');size=self.read('I')
    shared.append(np.frombuffer(self.b,dtype='<u2' if short else '<u4',count=size//(2 if short else 4),offset=self.at))
    self.at+=size
   elif t=='BasicEffectReader':
    tex=self.string();colors=self.read('11f');flags=self.read('B')
    shared.append((tex,colors[10]))
   else:raise ValueError((t,self.at))
  assert self.at==len(self.b),(self.at,len(self.b))
  result=[]
  for name,m,vertex,count,start,triangles,vb,ib,fx in meshes:
   if triangles==0:continue
   p,t=shared[vb]
   ix=shared[ib][start:start+triangles*3].astype(np.int64)+vertex
   p=np.concatenate([p[ix],np.ones((len(ix),1))],1)@m
   tex,alpha=shared[fx]
   result.append((name,tex,alpha,np.concatenate([p[:,:3],t[ix]],axis=1).reshape(-1,3,5)))
  return result
