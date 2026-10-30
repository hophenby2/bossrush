#!/bin/zsh
set -euo pipefail
br_mac_root="${0:A:h}"
cd "$br_mac_root/.."
if /usr/bin/pgrep -x BossRushHD >/dev/null; then
    print '请先退出 Mac 游戏，再刷新脚本并启动。'
    exit 1
fi
if [[ -f "$br_mac_root/dist/Boss Rush HD.app/Contents/MacOS/BossRushHD" ]]; then
    python3 "$br_mac_root/build.py" --update-assets
else
    python3 "$br_mac_root/build.py"
fi
open "$br_mac_root/dist/Boss Rush HD.app"
