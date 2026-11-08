"""汇总严格对象桩的长测与多种子读数；原作移植只记录密度，不据此改参数。"""
from pathlib import Path
import argparse
import json
import re


def read(path):
    text=path.read_text('utf-8');assert '通过：注册无误，各卡模拟无运行时错误' in text,path
    assert 'FAIL' not in text,path
    rows={};current=None
    for line in text.splitlines():
        m=re.search(r'OK\s+\[\d+\].*?\(id=(\d+)\).*?对象 (\d+) / 弹 (\d+)',line)
        if m:
            current=dict(id=int(m[1]),objects=int(m[2]),bullets=int(m[3]));rows[current['id']]=current
            continue
        m=re.search(r'^\s+\[\d+\].*?\(id=(\d+)\)',line)
        if m:
            current=dict(id=int(m[1]),objects=0,bullets=0);rows[current['id']]=current
        elif current:
            m=re.search(r'峰值同屏 对象 (\d+) / 弹 (\d+)',line)
            if m:current['objects'],current['bullets']=int(m[1]),int(m[2])
            m=re.search(r'60px 内弹数\s+平均 ([\d.]+) 峰值 (\d+)',line)
            if m:current['near_average'],current['near_peak']=float(m[1]),int(m[2])
            m=re.search(r'死局 \d+ 帧（([\d.]+)%）',line)
            if m:current['dead_percent']=float(m[1])
    assert set(rows)==set(range(11000,11086))|set(range(11101,11108)),('漏跑',path,len(rows))
    return rows


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('directory',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    before=read(args.directory/'th36-final-3600.txt');after=read(args.directory/'th36-final-7200.txt')
    seeds=(20260916,11111,98765,55555,31415,777)
    cases={seed:read(args.directory/f'th36-final-threat-{seed}.txt') for seed in seeds}
    rows=[]
    for key in before:
        samples=[dict(seed=seed,**cases[seed][key]) for seed in seeds]
        rows.append(dict(id=key,peak3600=before[key],peak7200=after[key],
            worst_near_average=max(r.get('near_average',0) for r in samples),
            worst_dead_percent=max(r.get('dead_percent',0) for r in samples),samples=samples))
    result=dict(entries=len(rows),seeds=seeds,
        scope='严格Lua对象桩，真实ANM状态与精灵尺寸，省略ANM空绘制；激光/自机使用桩，不证明原版无解率。长于3600帧的耐久卡及整关不能按短卡峰值增长判漏。',rows=rows)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n','utf-8',newline='\n')
    print(json.dumps(dict(entries=len(rows),seeds=len(seeds),peak_growth=sum(r['peak7200']['bullets']>r['peak3600']['bullets'] for r in rows)),ensure_ascii=False))


if __name__=='__main__':main()
