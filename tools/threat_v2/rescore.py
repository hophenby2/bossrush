#!/usr/bin/env python3
"""只调整阅读尺度和操作节拍权重时复用已记录的分量；不伪造轨迹或重排结果。"""
from pathlib import Path
from dataclasses import asdict
import argparse,hashlib,json
from model import Parameters,measure
from run import ORDER,ROOT,summarize,plot

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('report',type=Path);parser.add_argument('--plot',action='store_true')
    args=parser.parse_args();raw=args.report.read_bytes();report=json.loads(raw);p=Parameters()
    old=report['parameters'];new=asdict(p)
    for key,value in old.items():
        if key not in ('reading_span','kinetic_weight'):assert value==new[key],'该参数改变后必须重跑轨迹规划：'+key
    for run in report['runs']:
        for row in run:
            row['reading_factor']=1+min(row['scatter']/p.reading_span,3)
            for values in row['policies'].values():values['score']=100*(row['reading_factor']*values['base_pressure']+p.kinetic_weight*values['cadence'])
    report['parameters']=new;report['summary']=summarize(report['runs'])
    def ordered(run,policy):
        scores=[r['policies'][policy if policy!='reference' else ('sparse_route' if r['card']==3600 else 'centre_micro')]['score'] for r in run]
        return all(a>b for a,b in zip(scores,scores[1:]))
    report['reference_order_each_seed']=[ordered(run,'reference') for run in report['runs']]
    report['all_mobile_order_each_seed']=[ordered(run,'sparse_route') for run in report['runs']]
    values=[r['policies']['sparse_route' if r['card']==3600 else 'centre_micro']['score']['median'] for r in report['summary']]
    report['reference_order_medians']=all(a>b for a,b in zip(values,values[1:]))
    report['rescored_from_sha256']=hashlib.sha256(raw).hexdigest()
    report['source_hashes']['tools/threat_v2/model.py']=hashlib.sha256((ROOT/'tools/threat_v2/model.py').read_bytes()).hexdigest()
    args.report.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    if args.plot:
        example=measure(Path(__file__).resolve().parent/'build'/str(report['seeds'][0]),3600,p)
        plot(report['summary'],example,args.report.with_suffix('.png'))
    print(args.report,'中位数递减：',report['reference_order_medians'])
if __name__=='__main__':main()
