# 随机十战抽取来源（2026-11-06）

准备界面选择四作、Lunatic与Extra/Phantasm、Boss/道中；Boss包括符卡、非符与中Boss。每组至少保留一项；按筛选后的总池无放回抽十张，不足十张禁止开始，不跨池补抽。

仅收录已核对来源的卡号。妖妖梦ecldata8的23个Phantasm条目并入Extra/Phantasm开关。TH34显式Normal/Hard分支、TH31独立Last Word与TH32自制条目仍排除。

| 来源 | L Boss | L 道中 | EX/PH Boss | EX/PH 道中 |
| --- | ---: | ---: | ---: | ---: |
| TH31 | 83 | 13 | 22 | 2 |
| TH32 | 69 | 12 | 22 | 2 |
| TH34 | 60 | 6 | 43 | 2 |
| TH35 | 45 | 6 | 22 | 1 |

全开共410个候选；排除28项。

## 排除条目

| 来源/卡号 | 卡名 | 原ECL入口 | 排除原因 |
| --- | --- | --- | --- |
| TH31/351 | 「季节外调的蝴蝶风暴」 | `ecldata1sp.ecl:Sub36` | Last Word独立模式 |
| TH31/352 | 「盲夜鸟」 | `ecldata2sp.ecl:Sub46` | Last Word独立模式 |
| TH31/353 | 「日出之国的天子」 | `ecldata3sp.ecl:Sub56` | Last Word独立模式 |
| TH31/354 | 「幻胧月睨」 | `ecldata5sp.ecl:Sub40` | Last Word独立模式 |
| TH31/355 | 「天网蛛网捕蝶之法」 | `ecldata6sp.ecl:Sub76` | Last Word独立模式 |
| TH31/356 | 「蓬莱之树海」 | `ecldata7sp.ecl:Sub79` | Last Word独立模式 |
| TH31/357 | 「不死鸟再诞」 | `ecldata8sp.ecl:Sub110` | Last Word独立模式 |
| TH31/358 | 「远古的欺骗者」 | `ecldata5sp.ecl:Sub43` | Last Word独立模式 |
| TH31/359 | 「无何有净化」 | `ecldata8sp.ecl:Sub113` | Last Word独立模式 |
| TH31/360 | 「梦想天生」 | `ecldata4asp.ecl:Sub43` | Last Word独立模式 |
| TH31/361 | 「炽热之星」 | `ecldata4bsp.ecl:Sub60` | Last Word独立模式 |
| TH31/362 | 「紧缩世界」 | `ecldata_sk.ecl:Sub1` | Last Word独立模式 |
| TH31/363 | 「待宵反射卫星斩」 | `ecldata_ym.ecl:Sub1` | Last Word独立模式 |
| TH31/364 | 「格兰吉纽尔剧场的怪人」 | `ecldata_al.ecl:Sub1` | Last Word独立模式 |
| TH31/365 | 「猩红命运」 | `ecldata_rm.ecl:Sub1` | Last Word独立模式 |
| TH31/366 | 「西行寺无余涅槃」 | `ecldata_yy.ecl:Sub1` | Last Word独立模式 |
| TH31/367 | 「深弹幕结界 -梦幻泡影-」 | `ecldata_yk.ecl:Sub4` | Last Word独立模式 |
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
- 道中取已审阅清单的时间轴类型，不再通过标题包含“道中”猜测。
- 筛选与卡池版本在开局前写入录像/续玩初态；未带版本的旧录像使用旧抽取算法；版本2仍排除Phantasm以保留旧路线，新局版本3使用合并池。

按此前要求未运行测试、游戏或构建；本工具只读取已有源清单并导出白名单及报告。
