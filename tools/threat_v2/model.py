"""板底弹隙与有限前视的威胁原型；读取 trace.lua 的实际逐帧轨迹。"""
from dataclasses import dataclass
from pathlib import Path
import numpy as np

BARRIER=1e6

@dataclass(frozen=True)
class Parameters:
    player_radius: float = .75
    y: float = -176
    x_step: float = 2
    speed: float = 4
    horizon: int = 120
    reaction: int = 12
    decision: int = 12
    comfort: float = 3
    timing_error: float = 3
    reading_span: float = 28
    kinetic_range: float = 16
    kinetic_weight: float = 1.5

def load_trace(folder: Path, card: int):
    meta=dict(line.split('\t',1) for line in (folder/f'{card}.meta.tsv').read_text().splitlines())
    data=np.fromfile(folder/f'{card}.f32',dtype='<f4').reshape(-1,10)
    assert len(data)==int(meta['records']) and len(data)>0
    assert int(meta['unknown_radius'])==0,'判定尺寸缺失，拒绝给出可信分数'
    step=int(meta['sample']);times=np.arange(step,int(meta['last_frame'])+1,step)
    # 手算弹 vx/vy 可能恒为零；速度必须由同一对象的实际位置差分取得。
    order=np.lexsort((data[:,0],data[:,1]));sorted_=data[order]
    same=np.diff(sorted_[:,1])==0
    delta=np.diff(sorted_[:,2:4],axis=0)/step
    velocity=np.zeros((len(data),2),dtype=np.float32)
    velocity[order[1:][same]]=delta[same]
    first=np.r_[True,~same]
    for i in np.flatnonzero(first):
        if i+1<len(order) and same[i]:velocity[order[i]]=velocity[order[i+1]]
    data=np.column_stack((data,velocity,np.full(len(data),step,dtype=np.float32)))
    cut=np.searchsorted(data[:,0],times)
    end=np.searchsorted(data[:,0],times,side='right')
    frames=[data[a:b] for a,b in zip(cut,end)]
    born=np.full(int(data[:,1].max())+1,np.inf)
    visible=((abs(data[:,2])<208)&(abs(data[:,3])<240))|(data[:,7]==1)
    np.minimum.at(born,data[visible,1].astype(int),data[visible,0])
    return meta,frames,born,step

def profile(rows,x,p,cutoff=None,born=None):
    if cutoff is not None:
        rows=rows[born[rows[:,1].astype(int)]<=cutoff]
    if not len(rows):return np.zeros(len(x)),np.full(len(x),100.),np.zeros(len(x)),np.zeros(len(x))
    # 圆形按判定半径；直线光按旋转矩形。视觉宽度不参与计算。
    dy=p.y-rows[:,3]
    circles=rows[:,7]==0
    observed_speed=np.minimum(np.linalg.norm(rows[:,10:12],axis=1),20)
    keep=(np.abs(dy)<rows[:,5]+p.player_radius+3*(p.comfort+observed_speed*p.timing_error))|(~circles)
    rows,dy=rows[keep],dy[keep]
    if not len(rows):return np.zeros(len(x)),np.full(len(x),100.),np.zeros(len(x)),np.zeros(len(x))
    dx=x[None,:]-rows[:,2,None]
    angle=np.deg2rad(rows[:,6,None]);co,si=np.cos(angle),np.sin(angle)
    u=dx*co+dy[:,None]*si;v=-dx*si+dy[:,None]*co
    radius=rows[:,4,None]+p.player_radius
    # 两次采样之间的扫掠，避免快弹跨过细间隙却被端点采样漏掉。
    vx,vy=rows[:,10,None],rows[:,11,None]
    speed2=vx*vx+vy*vy
    closest=np.clip(-(dx*vx+dy[:,None]*vy)/np.maximum(speed2,1e-9),0,rows[:,12,None])
    distance=np.hypot(dx+vx*closest,dy[:,None]+vy*closest)-radius
    rect=rows[:,7]==1
    if np.any(rect):
        qu=np.abs(u[rect])-rows[rect,4,None]
        qv=np.abs(v[rect])-rows[rect,5,None]
        distance[rect]=np.hypot(np.maximum(qu,0),np.maximum(qv,0))+np.minimum(np.maximum(qu,qv),0)-p.player_radius
    clearance=distance.min(axis=0)
    speed=np.minimum(np.linalg.norm(rows[:,10:12],axis=1),20)[:,None]
    tolerance=p.comfort+speed*p.timing_error
    # 通行时机误差转为空间误差；通量项修正快弹停留短、瞬时密度反而低的问题。
    density=np.exp(-np.maximum(distance,0)/tolerance)*np.maximum(speed/2,.15)
    density[distance>3*tolerance]=0
    flow=density.sum(axis=0)
    # 多颗相近弹形成的交叉压力；与单颗最近弹的余量分别保留。
    overlap=np.maximum(flow-density.max(axis=0),0)
    nearest_speed=speed[:,0][np.argmin(distance,axis=0)]
    cadence=np.where(clearance<p.kinetic_range,(nearest_speed/4)**2,0)
    return flow,clearance,overlap,cadence

def gap_width(clearance,step):
    safe=clearance>0
    cuts=np.flatnonzero(np.diff(np.r_[False,safe,False].astype(int)))
    width=np.zeros(len(safe))
    for a,b in zip(cuts[::2],cuts[1::2]):width[a:b]=(b-a)*step
    return width

def field(rows,x,p,cutoff=None,born=None):
    flow,clearance,overlap,cadence=profile(rows,x,p,cutoff,born)
    width=gap_width(clearance,p.x_step)
    precision=(12/(width+12))**2
    cost=.7*flow+.35*overlap+precision
    cost[clearance<=0]+=BARRIER
    return cost,flow,clearance,overlap,width,cadence

def path_dp(cost,start,max_shift,movement=.005):
    n,width=cost.shape
    value=cost[-1].copy();choices=np.zeros((max(n-1,0),width),dtype=np.int16)
    for t in range(n-2,-1,-1):
        best=np.full(width,np.inf);choice=np.arange(width,dtype=np.int16)
        occupied=np.r_[0,np.cumsum(cost[t+1]>=BARRIER)]
        for delta in range(-max_shift,max_shift+1):
            a=max(0,-delta);b=min(width,width-delta)
            v=value[a+delta:b+delta]+movement*abs(delta)
            index=np.arange(a,b)
            crossed=occupied[np.maximum(index,index+delta)+1]-occupied[np.minimum(index,index+delta)]
            v=v+BARRIER*(crossed>0)
            take=v<best[a:b]
            best[a:b][take]=v[take];choice[a:b][take]=np.arange(a+delta,b+delta,dtype=np.int16)[take]
        choices[t]=choice;value=cost[t]+best
    out=[int(start)]
    for t in range(n-1):out.append(int(choices[t,out[-1]]))
    return np.asarray(out)

def route(frames,born,dt,x,p,macro):
    span=abs(x)<=24 if not macro else np.ones(len(x),dtype=bool)
    indices=np.flatnonzero(span);xs=x[indices];pos=int(np.argmin(abs(xs)))
    horizon=max(2,p.horizon//dt);decision=max(1,p.decision//dt);reaction=max(0,p.reaction//dt)
    queue=[pos]*reaction;out=[]
    for t in range(0,len(frames),decision):
        n=min(horizon,len(frames)-t)
        predicted=np.stack([field(frames[t+k],xs,p,(t+1)*dt,born)[0] for k in range(n)])
        prefix=queue[:min(reaction,n)]
        start=prefix[-1] if prefix else pos
        tail=path_dp(predicted[len(prefix):],start,max(1,int(p.speed*dt/p.x_step))) if len(prefix)<n else np.empty(0,dtype=int)
        plan=prefix+tail.tolist()
        count=min(decision,len(plan));out.extend(indices[plan[:count]])
        if count:pos=plan[count-1]
        queue=plan[count:count+reaction]
        queue+=([pos]*(reaction-len(queue)))
    return np.asarray(out[:len(frames)],dtype=int)

def measure(folder,card,p=Parameters()):
    meta,frames,born,dt=load_trace(Path(folder),card)
    x=np.arange(-184,184+p.x_step/2,p.x_step)
    actual=[field(rows,x,p) for rows in frames]
    cost,flow,clearance,overlap,width,cadence=[np.stack([row[i] for row in actual]) for i in range(6)]
    first=np.flatnonzero(flow[:,np.argmin(abs(x))]>.1)
    begin=int(first[0]) if len(first) else 0
    result={'card':card,'name':meta['name'],'frames':len(frames)*dt,'active_from':begin*dt,'radius_coverage':1.,'policies':{}}
    scatter=emission_scatter(frames)
    reading_factor=1+min(scatter/p.reading_span,3)
    result['scatter']=scatter;result['reading_factor']=reading_factor
    for name,macro in [('fixed_centre',None),('centre_micro',False),('sparse_route',True)]:
        route_=np.full(len(frames),np.argmin(abs(x)),dtype=int) if macro is None else route(frames,born,dt,x,p,macro)
        take=(np.arange(len(frames)),route_)
        f,c,o,w,k=[arr[take][begin:] for arr in (flow,clearance,overlap,width,cadence)]
        movement=np.abs(np.diff(x[route_]))
        # 分数仍在成功路线处评估余量和重叠；避开碰撞不会把威胁度直接归零。
        base=.7*np.mean(f)+.35*np.mean(o)+np.mean((12/(w+12))**2)+2*np.mean(c<=0)
        score=100*(base*reading_factor+p.kinetic_weight*np.mean(k))
        span=60//dt
        wide=np.abs(x[route_[span:]]-x[route_[:-span]])>80 if len(route_)>span else np.array([],dtype=bool)
        result['policies'][name]={'score':float(score),'base_pressure':float(base),'cadence':float(k.mean()),'flow':float(f.mean()),'overlap':float(o.mean()),
            'collision_fraction':float(np.mean(c<=0)),'clearance_p10':float(np.percentile(c,10)),
            'gap_p10':float(np.percentile(w,10)),'movement_per_second':float(movement.sum()/(len(frames)*dt/60)),
            'large_relocations':int(np.sum(np.diff(np.r_[False,wide].astype(int))==1))}
        result[name+'_route']=x[route_]
    result['field']={'x':x,'flow':flow,'clearance':clearance,'dt':dt}
    return result

def emission_scatter(frames):
    seen=set();groups={}
    for rows in frames:
        for row in rows:
            ident=int(row[1])
            if ident in seen:continue
            seen.add(ident)
            if row[7]!=0:continue
            key=(int(row[0]//8),int((row[6]%360)//20),int(row[9]))
            groups.setdefault(key,[]).append(row[2:4])
    values=[]
    for points in groups.values():
        if len(points)>=3:
            points=np.asarray(points);values.append(float(np.sqrt(np.mean(np.sum((points-points.mean(axis=0))**2,axis=1)))))
    return float(np.median(values)) if values else 0.
