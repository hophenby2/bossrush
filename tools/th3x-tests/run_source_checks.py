"""保存可重复的原作核对结果与代码指纹；未覆盖的语义不能因汇总通过而变成已完成。"""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
CHECKS = [
    ('entry_contracts.py', '全部条目的入口时限/已解析血量与保护窗口；不是完整攻击行为'),
    ('check_card_sources.py', '部分Last Word发射参数、相位及入口判定'),
    ('check_actor_sources.py', '11种使魔第一批ANM、若干附着链分支及出屏边界'),
    ('check_familiar_profiles.py', 'TH31全部77个使魔配置的交互/近身停火指令和160条出生血量来源'),
    ('check_keine_sources.py', '慧音两段补入攻击的整卡出生/发弹/激光参数和逐帧使魔位置'),
    ('check_prism_projectiles.py', '三姐妹六段原作中的444种发弹/命令组合，各181帧弹体运动及弹雾转换'),
    ('check_prism_nonspell_sources.py', '三姐妹新增六段非符的3600帧发弹、命令继承、激光及移动请求；三档Rank'),
    ('check_prism_sources.py', '三姐妹机体分支、独立减伤、上一帧伤害汇总及换卡'),
    ('check_boss_contact_sources.py', 'TH34十张卡实际协程的体术/隐藏开关与判定框'),
    ('check_th095_roles.py', 'TH33全部85幕的入场角色ANM和背景资源选择'),
    ('reverse_coverage.py', '从原作反查符卡入口；确认漏段不计为通过'),
]


def main():
    records = []
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1')
    for name, scope in CHECKS:
        path = Path('tools/th3x-tests') / name
        result = subprocess.run([sys.executable, '-X', 'utf8', str(path)], cwd=ROOT,
                                env=env, capture_output=True, text=True, encoding='utf-8')
        records.append(dict(script=path.as_posix(), scope=scope, exit_code=result.returncode,
                            stdout=result.stdout, stderr=result.stderr))
        print(name, ('扫描完成（缺口另列）' if name=='reverse_coverage.py' else '通过') if result.returncode == 0 else '失败', flush=True)
    files = [ROOT / name for name in ('core.lua', 'launch.lua', 'launcher.lua', 'tools/check_stage.lua')]
    for name in ('THlib', 'mod', 'Resources'):
        files.extend((ROOT / name).rglob('*.lua'))
    files.extend((ROOT / 'tools/th3x-tests').glob('*.py'))
    reverse = json.loads((ROOT / 'tools/th3x-tests/reverse-coverage-2026-11-02.json').read_text('utf-8'))
    data = dict(created_utc=datetime.now(timezone.utc).isoformat(),
                full_original_frame_equivalence=False,
                explanation='每项仅对列出的范围负责。纯Lua测试含引擎桩件；真实引擎结果另存。全量逐帧对齐仍未完成。',
                checks=records, confirmed_gaps=reverse['confirmed_gaps'],
                hashes={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
                        for p in sorted(files)})
    output = ROOT / 'tools/th3x-tests/verification-source-2026-11-02.json'
    output.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', 'utf-8')
    print(output)
    return int(any(row['exit_code'] != 0 for row in records))


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    raise SystemExit(main())
