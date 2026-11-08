"""只读提取原版TH11 ECL，保留二进制及两种编码的声明，供离线展开与独立探针使用。"""
from pathlib import Path
import argparse
import subprocess


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('dat',type=Path)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--thtk',type=Path,default=Path(r'E:\workspace\thtkGUI-th20tr\thtk\thtk-th20'))
    args=ap.parse_args()
    dat=args.dat.resolve();out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    assert dat.is_file() and dat.parent!=out,'缓存必须与原版目录分开'
    subprocess.run([str(args.thtk/'thdat.exe'),'-C',str(out),'-g','-x','11',str(dat),'*.ecl'],check=True,capture_output=True)
    files=sorted(out.glob('*.ecl'));assert len(files)==20,len(files)
    for path in files:
        for utf8 in (False,True):
            dest=path.with_suffix('.utf8' if utf8 else '.ecl.txt')
            with dest.open('wb') as stream:
                subprocess.run([str(args.thtk/'thecl.exe'),'-d','11',*(['-j'] if utf8 else []),'-r','-x',str(path)],stdout=stream,check=True)
    print('已提取并反汇编20份ECL；没有修改原版目录。')


if __name__=='__main__':main()
