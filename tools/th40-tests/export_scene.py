#!/usr/bin/env python3
"""Export original SSS sprite planes and DirectX text meshes without LOD or resizing."""
import argparse,hashlib,json,re
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
def lua(v):
 if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
 if isinstance(v,(int,float)):return format(v,'.9g')
 if isinstance(v,list):return '{'+','.join(map(lua,v))+'}'
 return '{'+','.join('['+lua(k)+']='+lua(x) for k,x in v.items())+'}'
def block(s,start):
 a=s.index('{',start);depth=1;b=a+1
 while depth:
  depth+=(s[b]=='{')-(s[b]=='}');b+=1
 return s[a+1:b-1],b
num=re.compile(r'-?\d+(?:\.\d*)?(?:[eE][+-]?\d+)?')
def nums(s):return [float(x) for x in num.findall(s)]
def xmesh(path,out,hashes):
 raw=path.read_bytes();hashes[str(path.name)]=hashlib.sha256(raw).hexdigest();s=raw.decode('gb18030');materials={};parts=[]
 for m in re.finditer(r'(?m)^Material (\w+)\s*\{',s):
  b,_=block(s,m.start());name=re.search(r'TextureFilename\s*\{\s*"([^"]+)"',b)
  materials[m[1]]=name[1] if name else None
 for m in re.finditer(r'(?m)^Frame \w+\s*\{',s):
  frame,_=block(s,m.start());mb=re.search(r'\bMesh\s*\{',frame)
  if not mb:continue
  mesh,_=block(frame,mb.start());prefix=mesh.split('MeshNormals')[0];v=nums(prefix);nv=int(v[0]);verts=[v[1+i*3:4+i*3] for i in range(nv)];k=1+nv*3;nf=int(v[k]);k+=1;faces=[]
  for _ in range(nf):n=int(v[k]);faces.append([int(t) for t in v[k+1:k+n+1]]);k+=n+1
  if not faces:continue
  uvb=re.search(r'MeshTextureCoords\s*\{',mesh);assert uvb,path
  uv=nums(block(mesh,uvb.start())[0]);uvs=[uv[1+i*2:3+i*2] for i in range(nv)]
  matb=block(mesh,re.search(r'MeshMaterialList\s*\{',mesh).start())[0];ref=re.findall(r'\{\s*(\w+)\s*\}',matb);ids=nums(matb.split('{')[0]);ids=[int(t) for t in ids[2:]];assert len(ids)==nf
  mat=nums(block(frame,frame.index('FrameTransformMatrix'))[0]);transformed=[]
  for x,y,z in verts:transformed.append([x*mat[i]+y*mat[4+i]+z*mat[8+i]+mat[12+i] for i in range(3)])
  for j,name in enumerate(ref):
   tex=materials[name];assert tex
   if not (path.parent/tex).is_file():tex=tex.replace('\\','')
   dest=out/(Path(tex).stem+'.png');Image.open(path.parent/tex).convert('RGBA').save(dest)
   hashes[tex]=hashlib.sha256((path.parent/tex).read_bytes()).hexdigest();flat=[]
   for face,mi in zip(faces,ids):
    if mi!=j:continue
    for i in range(1,len(face)-1):
     for idx in [face[0],face[i],face[i+1]]:flat+=transformed[idx]+uvs[idx]
   if flat:parts.append({'file':dest.name,'vertices':flat})
 return {'parts':parts}
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--game',type=Path,required=True);ap.add_argument('--source',type=Path,required=True);a=ap.parse_args();out=ROOT/'Resources/th40/scene';out.mkdir(exist_ok=True);hashes={};regions={}
 for txt in (a.game/'Image').rglob('*.txt'):
  try:s=txt.read_text(encoding='utf-8-sig')
  except UnicodeError:s=txt.read_text(encoding='gb18030')
  for line in s.splitlines():
   v=line.split()
   if len(v)>=7:
    try:regions[v[0]]=(txt.with_suffix('.png'),*[int(x) for x in v[1:7]])
    except ValueError:pass
 needed=['BG01a','BG01b','Tree','Cloud01','Cloud02','zhu','BG02d','liba','591-1','591-1R','柳树','地砖','草地','万花镜素材','黑暗滤镜','极光素材','云（亮层）','夜空（暗）','草地ex','Tree1','Tree2','天色','夜空底色','星星1','星星2']
 result={}
 for name in needed:
  region=regions.get(name)
  if region:p,x,y,w,h,dx,dy=region
  else:
   p=next((a.game/'Image').rglob(name+'.png'));w,h=Image.open(p).size;x=y=dx=dy=0
  dest=out/(name+'.png');im=Image.open(p);im.crop((x,y,x+w,y+h)).save(dest)
  result[name]={'file':dest.name,'w':w,'h':h,'cx':w/2+dx,'cy':h/2+dy};hashes[str(p.relative_to(a.game))]=hashlib.sha256(p.read_bytes()).hexdigest()
 for name,file in [('Stair','stair.X'),('祭坛','祭坛.X')]:result[name]=xmesh(a.game/'Model'/file,out,hashes)
 for p in [*a.source.glob('EnvironmentSSS*.cs'),*a.source.glob('GameState_SSS*.cs'),*[a.source/(n+'.cs') for n in ['Background3DObject','BackgroundTree','BackgroundGroupSSS01','BackgroundTouhouStage02_3D','BaseParticle3D','BackgroundManager3D','Model','Model_Mesh','BaseObject','BackgroundTransitionIn','BackgroundTransitionOut']]]:hashes[p.name]=hashlib.sha256(p.read_bytes()).hexdigest()
 (ROOT/'mod/GAME/th40/scene_data.lua').write_text('-- Full source geometry and original rotating centers.\nreturn '+lua(result)+'\n')
 (ROOT/'mod/GAME/th40/scene_sources.json').write_text(json.dumps({'sha256':hashes,'models':{n:sum(len(p['vertices'])//15 for p in result[n]['parts']) for n in ['Stair','祭坛']}},ensure_ascii=False,indent=2)+'\n')
 print('Exported',len(result),'original models')
if __name__=='__main__':main()
