#!/usr/bin/env python3
"""复测五张参照卡，输出多种子分数及神德的弹隙和择位图。"""
from pathlib import Path
from dataclasses import asdict
from concurrent.futures import ProcessPoolExecutor
import argparse,hashlib,json,os,subprocess,time
import numpy as np
from model import Parameters,measure

ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
ORDER=[391,3607,3601,3606,3600]
TITLES={391:'妹红八非',3607:'無双風神',3601:'ハイドロカモフラージュ',3606:'二百十日',3600:'風神様の神徳'}

def trial(seed,folder,frames,p):
    target=folder/str(seed);target.mkdir(parents=True,exist_ok=True)
    env=dict(os.environ,STAGE_SEED=str(seed))
    for stage,cards in [('31',[391]),('35',[3600,3601,3606,3607])]:
        with (target/f'th{stage}.log').open('w') as log:
            subprocess.run(['luajit',str(HERE/'trace.lua'),f'mod/GAME/th{stage}.lua',str(frames),str(target),','.join(map(str,cards))],cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
    rows=[];example=None
    for card in ORDER:
        result=measure(target,card,p)
        if card==3600:example=result
        rows.append({key:value for key,value in result.items() if key!='field' and not key.endswith('_route')})
    return rows,example

def summarize(runs):
    out=[]
    for card in ORDER:
        rows=[next(r for r in run if r['card']==card) for run in runs]
        item={'card':card,'name':TITLES[card],'policies':{}}
        for policy in rows[0]['policies']:
            item['policies'][policy]={key:{'median':float(np.median([r['policies'][policy][key] for r in rows])),
                'min':float(min(r['policies'][policy][key] for r in rows)),'max':float(max(r['policies'][policy][key] for r in rows))}
                for key in rows[0]['policies'][policy]}
        out.append(item)
    return out

def plot(summary,example,target):
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    from matplotlib.font_manager import FontProperties,fontManager
    fonts=[Path('/System/Library/Fonts/PingFang.ttc'),Path('/System/Library/Fonts/Supplemental/Arial Unicode.ttf')]
    font=next((f for f in fonts if f.exists()),None)
    if font:fontManager.addfont(str(font))
    prop=FontProperties(fname=str(font)) if font else None
    if prop:plt.rcParams['font.family']=prop.get_name()
    plt.rcParams['axes.unicode_minus']=False
    fig,(ax,heat)=plt.subplots(1,2,figsize=(14,5.5),layout='constrained',gridspec_kw={'width_ratios':[1.1,1]})
    y=np.arange(len(ORDER))
    for j,(policy,label,color) in enumerate([('centre_micro','中央小范围微避','#d86b43'),('sparse_route','有限前视择位','#397eb1')]):
        values=[r['policies'][policy]['score']['median'] for r in summary]
        low=[v-r['policies'][policy]['score']['min'] for v,r in zip(values,summary)]
        high=[r['policies'][policy]['score']['max']-v for v,r in zip(values,summary)]
        ax.barh(y+(j-.5)*.32,values,height=.30,label=label,color=color,xerr=[low,high],capsize=3)
    ax.set_yticks(y,[TITLES[c] for c in ORDER],fontproperties=prop);ax.invert_yaxis()
    ax.set_xlabel('相对威胁分  越高越难');ax.set_title('多种子结果  误差线为种子范围');ax.legend(loc='lower right')
    field=example['field'];values=np.log1p(field['flow'])
    im=heat.imshow(values,origin='lower',aspect='auto',extent=[field['x'][0],field['x'][-1],0,len(values)*field['dt']/60],cmap='magma')
    t=np.arange(len(values))*field['dt']/60
    heat.plot(example['sparse_route_route'],t,color='#67e4e8',lw=1,label='择位路线')
    heat.plot(example['centre_micro_route'],t,color='white',lw=.6,label='中央微避')
    heat.set_xlabel('板底横坐标');heat.set_ylabel('时间 秒');heat.set_title('神德  来弹压力与受限择位路线');heat.legend(loc='lower right')
    fig.colorbar(im,ax=heat,label='log(1 + 通行时机压力)')
    fig.savefig(target,dpi=170);plt.close(fig)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--seeds',default='20260916,11111,98765,31415,777')
    parser.add_argument('--frames',type=int,default=1800)
    parser.add_argument('--output',type=Path,default=HERE/'results.json')
    parser.add_argument('--no-plot',action='store_true')
    args=parser.parse_args();seeds=[int(v) for v in args.seeds.split(',')];p=Parameters()
    runs=[];example=None;start=time.monotonic()
    with ProcessPoolExecutor(max_workers=min(3,len(seeds))) as pool:
      futures=[pool.submit(trial,seed,HERE/'build',args.frames,p) for seed in seeds]
      for seed,future in zip(seeds,futures):
        rows,view=future.result();runs.append(rows)
        if example is None:example=view
        print(seed,[(r['card'],round(r['policies']['centre_micro' if r['card']!=3600 else 'sparse_route']['score'],2)) for r in rows],flush=True)
    summary=summarize(runs)
    def ordered(rows,policy):
        values=[r['policies'][policy if policy!='reference' else ('sparse_route' if r['card']==3600 else 'centre_micro')]['score'] for r in rows]
        return all(a>b for a,b in zip(values,values[1:]))
    report={'version':'0.1','parameters':asdict(p),'frames_requested':args.frames,'seeds':seeds,'runs':runs,'summary':summary,
        'reference_order_each_seed':[ordered(run,'reference') for run in runs],
        'all_mobile_order_each_seed':[ordered(run,'sparse_route') for run in runs],
        'notes':['公式不读取卡号或名称。卡号仅用于采样和检验给定顺序。','前视读取已出现子弹的未来轨迹，不读未来新生弹；是离线理想预测原型。','固定参考弹场来自板底中央，自机相关发弹的跨站位结果需要闭环复测。']}
    scores=[r['policies']['sparse_route' if r['card']==3600 else 'centre_micro']['score']['median'] for r in summary]
    report['reference_order_medians']=all(a>b for a,b in zip(scores,scores[1:]))
    sources=['mod/GAME/th31.lua','mod/GAME/th35.lua','THlib/bullet/bulletStyle.lua','THlib/bullet/visual_match.lua',
             'tools/check_stage.lua','tools/threat_v2/trace.lua','tools/threat_v2/model.py']
    report['source_hashes']={name:hashlib.sha256((ROOT/name).read_bytes()).hexdigest() for name in sources}
    args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    if not args.no_plot:plot(summary,example,args.output.with_suffix('.png'))
    print('完成，用时',round(time.monotonic()-start,1),'秒；排序',report['reference_order_each_seed'],flush=True)
if __name__=='__main__':main()
