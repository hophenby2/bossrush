# Roguelike抽取来源（2026-11-09）

准备界面选择Lunatic、Extra/Phantasm与Last Word，以及作品、Boss/道中和卡片类型；Boss包括符卡、非符与中Boss。每组至少保留一项；交集至少一张即可开始，每轮无放回抽取，抽完重新洗牌，不跨池补抽。

仅收录已核对来源的卡号。妖妖梦ecldata8的23个Phantasm条目并入Extra/Phantasm开关。TH31的17张独立Last Word由新开关控制，默认关闭；仍与符卡/时符筛选取交集。TH34显式Normal/Hard分支与TH32自制条目仍排除；TH36白名单仅用于版本4历史录像。

| 来源 | L Boss | L 道中 | EX/PH Boss | EX/PH 道中 | Last Word |
| --- | ---: | ---: | ---: | ---: | ---: |
| TH31 | 83 | 13 | 22 | 2 | 17 |
| TH32 | 69 | 12 | 22 | 2 | 0 |
| TH34 | 60 | 6 | 43 | 2 | 0 |
| TH35 | 45 | 6 | 22 | 1 | 0 |
| TH36 | 65 | 6 | 21 | 1 | 0 |

白名单共520个候选（含仅供历史录像使用的TH36）；排除11项。

## 排除条目

| 来源/卡号 | 卡名 | 原ECL入口 | 排除原因 |
| --- | --- | --- | --- |
| TH32/368 | 「克罗里·尤斯福德」 | `无原作ECL:` | 自制条目 |
| TH34/4408 | 畜趣剣「無為無策の冥罰」 | `ecldata5.ecl:Sub66` | Normal |
| TH34/4468 | 仙符「屍解永遠」 | `ecldata2.ecl:Sub68` | Normal |
| TH34/4457 | 冬符「フラワーウィザラウェイ」 | `ecldata1.ecl:Sub48` | Normal |
| TH34/4439 | 紅符「紅毛の和蘭人形」 | `ecldata3.ecl:Sub46` | Normal |
| TH34/4472 | 闇符「霧の倫敦人形」 | `ecldata3.ecl:Sub50` | Normal |
| TH34/4473 | 廻符「輪廻の西蔵人形」 | `ecldata3.ecl:Sub52` | Hard |
| TH34/4470 | 仙符「鳳凰卵」 | `ecldata2.ecl:Sub44` | Normal |
| TH34/4471 | 鬼符「鬼門金神」 | `ecldata2.ecl:Sub70` | Hard |
| TH34/4475 | 弦奏「グァルネリ・デル・ジェス」 | `ecldata4.ecl:Sub127` | Normal |
| TH34/4476 | 合葬「プリズムコンチェルト」 | `ecldata4.ecl:Sub132` | Normal |

## 分类依据

- 原始文件与入口：`tools/th3x-tests/card-audit-index.json`，逐行记录见同目录`ECL_LINE_REVIEW_2026-11-05.md`。
- TH34的Normal/Hard采用`th07_motion_source.difficulty`的实际实现分支（1/2）；例如ecldata1/Sub39在0x4e10以mask03设置Sub48，ecldata3/Sub37在0x4f20/0x4f30以mask03/04选择Sub50/52。
- TH34/4468虽然Sub68有共同回调入口，移植卡明确使用Normal分支，仍排除；不能仅凭被共用子程序引用就判为L。
- Extra按原作扩展关ECL文件，TH34的ecldata8为Phantasm，TH31的ecldata8为Extra；两个原作来源均由Extra/Phantasm开关控制。
- Last Word取TH31的th08_lastword_source元数据，卡号351–367，独立于Lunatic与Extra/Phantasm；版本2–8录像仍排除，版本1沿用原抽取算法。
- 道中取已审阅清单的时间轴类型，不再通过标题包含“道中”猜测。
- TH36阶段来自`tools/th36-tests/low_speed_hp.json`的原始ECL探针。65个Lunatic、21个Extra阶段归Boss；11201–11207是按main时钟执行、剥离Boss演员的独立道中，11101–11107完整关卡不进入随机池。
- 筛选与卡池版本在开局前写入录像/续玩初态；未带版本的旧录像使用旧抽取算法；版本2仍排除Phantasm以保留旧路线，新局版本3使用合并池。
- 新局版本4加入TH36；版本1/2/3均保留此前来源集合，旧筛选中未勾选TH36时不会自行补入。

验证入口：`tools/check_roguelike.lua`与`tools/th36-tests/check_rogue.py`；本工具只读取源清单并导出白名单及报告。
