-- 原作C#阶段与运动参数的离线转换；只包含Lua函数和常量。
local P={{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="mid",["source"]="Boss_Ami01.Ctrl1",["time"]=1200,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,120.0},["armor"]=0.0,["id"]=68001},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="mid",["source"]="SpellCard_SSS01_01",["time"]=1200,["maxhp"]=10000,["kind"]="spell",["title"]="微风「摇曳的三叶草」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.7,["backgrounds"]={"Card01b","Card01a"},["survival"]=false,["variants"]={["SpellCard_SSS01_01"]="微风「摇曳的三叶草」"},["id"]=68002},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="boss",["source"]="Boss_Ami02.Ctrl2",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,150.0},["armor"]=0.3,["id"]=68003},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="boss",["source"]="SpellCard_SSS01_02",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="星符「夏夜的晚星」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.905,["backgrounds"]={"Card01b","Card01a"},["survival"]=false,["variants"]={["SpellCard_SSS01_02"]="星符「夏夜的晚星」"},["id"]=68004},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="boss",["source"]="Boss_Ami02.Ctrl1",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,100.0},["armor"]=0.32,["id"]=68005},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="boss",["source"]="SpellCard_SSS01_03",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="四叶「大自然之花环」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.88,["backgrounds"]={"Card01b","Card01a"},["survival"]=false,["variants"]={["SpellCard_SSS01_03"]="四叶「大自然之花环」"},["id"]=68006},{["chapter"]="1",["boss"]="Ami",["boss_name"]="娅米",["role"]="boss",["source"]="SpellCard_SSS01_FSC",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="夜风「轮回的幸运之星」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.0,["backgrounds"]={"Card01b","Card01a"},["survival"]=false,["variants"]={["SpellCard_SSS01_FSC"]="夜风「轮回的幸运之星」"},["id"]=68007},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="mid",["source"]="Boss_Rakuki01.Ctrl1",["time"]=1200,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,120.0},["armor"]=0.0,["id"]=68008},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="mid",["source"]="SpellCard_SSS02_01",["time"]=1200,["maxhp"]=10000,["kind"]="spell",["title"]="魔矢「轮回的万箭」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.7,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS02_01"]="魔矢「轮回的万箭」"},["id"]=68009},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="Boss_Rakuki02.Ctrl3",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.0,["id"]=68010},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="SpellCard_SSS02_02",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="异器「琴引山之神弓」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.75,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS02_02"]="异器「琴引山之神弓」"},["id"]=68011},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="Boss_Rakuki02.Ctrl2",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.3,["id"]=68012},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="SpellCard_SSS02_03",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="魔狩「星夜的狩猎舞曲」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.8,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS02_03"]="魔狩「星夜的狩猎舞曲」"},["id"]=68013},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="SpellCard_SSS02_04",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="华箭「紫星之花」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.4,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS02_04"]="华箭「紫星之花」"},["id"]=68014},{["chapter"]="2",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="boss",["source"]="SpellCard_SSS02_FSC",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="秘术「龙卷旋风之箭」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.0,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS02_FSC"]="秘术「龙卷旋风之箭」"},["id"]=68015},{["chapter"]="3",["boss"]="Koreirei",["boss_name"]="古灵灵",["role"]="mid",["source"]="SpellCard_SSS03_01",["time"]=1200,["maxhp"]=10000,["kind"]="spell",["title"]="火符「燃烧地狱火海」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.15,["backgrounds"]={"Card03b","Card03a","Card03c"},["survival"]=false,["variants"]={["SpellCard_SSS03_01"]="火符「燃烧地狱火海」"},["id"]=68016},{["chapter"]="3",["boss"]="Koreirei",["boss_name"]="古灵灵",["role"]="mid",["source"]="SpellCard_SSS03_02",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="火光「午夜的大火灾」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.25,["backgrounds"]={"Card03b","Card03a","Card03c"},["survival"]=false,["variants"]={["SpellCard_SSS03_02"]="火光「午夜的大火灾」"},["id"]=68017},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="Boss_Seiryuu01.Ctrl3",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.25,["id"]=68018},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="SpellCard_SSS03_03",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="木魅「枛津姬命」",["hp"]=2000,["dest"]={192.0,220.0},["optional"]=false,["armor"]=0.86,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSS03_03"]="木魅「枛津姬命」"},["id"]=68019},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="Boss_Seiryuu01.Ctrl2",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,120.0},["armor"]=0.25,["id"]=68020},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="SpellCard_SSS03_04",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="妖符「柳下妖蝉」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.7,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSS03_04"]="妖符「柳下妖蝉」"},["id"]=68021},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="Boss_Seiryuu01.Ctrl1",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.25,["id"]=68022},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="SpellCard_SSS03_05",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="深绿「舞动的翠绿之风」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.9,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSS03_05"]="深绿「舞动的翠绿之风」"},["id"]=68023},{["chapter"]="3",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="boss",["source"]="SpellCard_SSS03_FSC",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="叶符「德律阿得斯的圣枝」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.0,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSS03_FSC"]="叶符「德律阿得斯的圣枝」"},["id"]=68024},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="Boss_Kage01.Ctrl5",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.55,["id"]=68025},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_01",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="魔镜「虚无幽幻之境」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.89,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS04_01"]="魔镜「虚无幽幻之境」"},["id"]=68026},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="Boss_Kage01.Ctrl4",["time"]=2400,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.5,["id"]=68027},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_02A",["time"]=2400,["maxhp"]=10000,["kind"]="spell",["title"]="镜符「月季色红梦裂隙」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.875,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS04_02A"]="镜符「月季色红梦裂隙」",["SpellCard_SSS04_02B"]="镜符「山吹色波纹裂隙」",["SpellCard_SSS04_02C"]="镜符「瑠璃色银河裂隙」",["SpellCard_SSS04_02D"]="镜符「若竹色翠石裂隙」"},["id"]=68028},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_03A",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="阴阳「神鬼一击」",["hp"]=10000,["dest"]={192.0,96.0},["optional"]=false,["armor"]=0.5,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS04_03A"]="阴阳「神鬼一击」",["SpellCard_SSS04_03B"]="流光「幻影魔炮」",["SpellCard_SSS04_03C"]="岚符「大孔雀暴风」",["SpellCard_SSS04_03D"]="空想「恋之宣告」"},["id"]=68029},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_04A",["time"]=2100,["maxhp"]=10000,["kind"]="spell",["title"]="辉针「闪耀万针剑」",["hp"]=10000,["dest"]={192.0,100.0},["optional"]=false,["armor"]=1.0,["backgrounds"]={},["survival"]=true,["variants"]={["SpellCard_SSS04_04A"]="辉针「闪耀万针剑」",["SpellCard_SSS04_04B"]="星符「急速彗星」",["SpellCard_SSS04_04C"]="秘术「遗忘之封印」",["SpellCard_SSS04_04D"]="「古明地恋的消失」"},["id"]=68030},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_05",["time"]=1680,["maxhp"]=10000,["kind"]="spell",["title"]="虹奥义「光幕结界」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=1.0,["backgrounds"]={},["survival"]=true,["variants"]={["SpellCard_SSS04_05"]="虹奥义「光幕结界」"},["id"]=68031},{["chapter"]="4",["boss"]="Kage",["boss_name"]="魅明魔影",["role"]="boss",["source"]="SpellCard_SSS04_FSC",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="境界「三原色」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.95,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS04_FSC"]="境界「三原色」"},["id"]=68032},{["chapter"]="5",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="mid",["source"]="Boss_Rakuki04.Ctrl1",["time"]=2880,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,120.0},["armor"]=0.0,["id"]=68033},{["chapter"]="5",["boss"]="Rakuki",["boss_name"]="桃雨洛熙",["role"]="mid",["source"]="SpellCard_SSS05_00",["time"]=2880,["maxhp"]=10000,["kind"]="spell",["title"]="杀箭「新星爆炸箭」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.8,["backgrounds"]={"Card02b","Card02a","Card02c"},["survival"]=false,["variants"]={["SpellCard_SSS05_00"]="杀箭「新星爆炸箭」"},["id"]=68034},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="Boss_Rakukun01.Ctrl5",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.24,["id"]=68035},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_01",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="火舞「夏夜流火」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.84,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_01"]="火舞「夏夜流火」"},["id"]=68036},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="Boss_Rakukun01.Ctrl4",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.3,["id"]=68037},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_02",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="焰机「星夜的火焰舞曲」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.81,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_02"]="焰机「星夜的火焰舞曲」"},["id"]=68038},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="Boss_Rakukun01.Ctrl3",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.56,["id"]=68039},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_03",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="混沌「守护之心」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.88,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_03"]="混沌「守护之心」"},["id"]=68040},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_04",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="焰符「八百里的烈焰」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.1,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_04"]="焰符「八百里的烈焰」"},["id"]=68041},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_05",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="「星神降临仪式」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.72,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_05"]="「星神降临仪式」"},["id"]=68042},{["chapter"]="5",["boss"]="Rakukun",["boss_name"]="桃雨洛薰",["role"]="boss",["source"]="SpellCard_SSS05_FSC",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="烈焰「焚秽净世」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.5,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSS05_FSC"]="烈焰「焚秽净世」"},["id"]=68043},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="Boss_Tensei01.Ctrl6",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,150.0},["armor"]=0.25,["id"]=68044},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_01",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="许愿星「星火辉迹」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.9,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_01"]="许愿星「星火辉迹」"},["id"]=68045},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="Boss_Tensei01.Ctrl5",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,150.0},["armor"]=0.31,["id"]=68046},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_02",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="耀星「白夜永昼之光」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.8685,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_02"]="耀星「白夜永昼之光」"},["id"]=68047},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="Boss_Tensei01.Ctrl4",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,150.0},["armor"]=0.1,["id"]=68048},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_03",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="星雨「故乡之星」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.91,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_03"]="星雨「故乡之星」"},["id"]=68049},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="Boss_Tensei01.Ctrl3",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,150.0},["armor"]=0.2,["id"]=68050},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_04",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="星图「宇宙棋盘」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.91,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_04"]="星图「宇宙棋盘」"},["id"]=68051},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_05",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="「弹幕之海」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=1.0,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=true,["variants"]={["SpellCard_SSS06_05"]="「弹幕之海」"},["id"]=68052},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_06",["time"]=7200,["maxhp"]=10000,["kind"]="spell",["title"]="「流星神话」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=1.0,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_06"]="「流星神话」"},["id"]=68053},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_FSC01",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="第一个愿望「无尽之财」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.6,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_FSC01"]="第一个愿望「无尽之财」"},["id"]=68054},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_FSC02",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="第二个愿望「无穷之力」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.0,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=false,["variants"]={["SpellCard_SSS06_FSC02"]="第二个愿望「无穷之力」"},["id"]=68055},{["chapter"]="6",["boss"]="Tensei",["boss_name"]="梦璃夜天星",["role"]="boss",["source"]="SpellCard_SSS06_FSC03",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="第三个愿望「永生不灭」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=-0.9,["backgrounds"]={"底色","绿光","蓝光","红光"},["survival"]=true,["variants"]={["SpellCard_SSS06_FSC03"]="第三个愿望「永生不灭」"},["id"]=68056},{["chapter"]="EX",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="mid",["source"]="SpellCard_SSSEx_01",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="青符「东之国度的树叶」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.25,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSSEx_01"]="青符「东之国度的树叶」"},["id"]=68057},{["chapter"]="EX",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="mid",["source"]="SpellCard_SSSEx_02",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="柳符「新生的柳叶绿芽」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.155,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSSEx_02"]="柳符「新生的柳叶绿芽」"},["id"]=68058},{["chapter"]="EX",["boss"]="Seiryuu",["boss_name"]="夏青柳",["role"]="mid",["source"]="SpellCard_SSSEx_03",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="蝶恋「千年之愿」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.55,["backgrounds"]={"Card03f","Card03d","Card03e"},["survival"]=false,["variants"]={["SpellCard_SSSEx_03"]="蝶恋「千年之愿」"},["id"]=68059},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl10",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.15,["id"]=68060},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_01A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="风符「环形气流」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.83,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_01A"]="风符「环形气流」",["SpellCard_SSSEx_01B"]="绽放「爱意的玫瑰」",["SpellCard_SSSEx_01C"]="冬临「初雪之寒径」",["SpellCard_SSSEx_01D"]="迴梦「月色琉璃光」"},["id"]=68061},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl9",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.0,["id"]=68062},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_02A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="速风「双龙卷」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.85,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_02A"]="速风「双龙卷」",["SpellCard_SSSEx_02B"]="幻花「仙晶玉莲」",["SpellCard_SSSEx_02C"]="仙器「太乙冰凌」",["SpellCard_SSSEx_02D"]="幽光「幻月蝶」"},["id"]=68063},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl8",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.15,["id"]=68064},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_03A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="风切「狂风交错」",["hp"]=2000,["dest"]={192.0,160.0},["optional"]=false,["armor"]=0.9,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_03A"]="风切「狂风交错」",["SpellCard_SSSEx_03B"]="萱草「忘却之爱」",["SpellCard_SSSEx_03C"]="霜冻「寒霜封印」",["SpellCard_SSSEx_03D"]="倒映「天之月水之月」"},["id"]=68065},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl7",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.265,["id"]=68066},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_04A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="舞风「阵风螺旋」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.835,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_04A"]="舞风「阵风螺旋」",["SpellCard_SSSEx_04B"]="荣符「生长与枯萎的循环」",["SpellCard_SSSEx_04C"]="米雪「冷云雪晶」",["SpellCard_SSSEx_04D"]="仙幻「月葬」"},["id"]=68067},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl6",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.15,["id"]=68068},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_05A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="飓风「台风眼」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.86,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_05A"]="飓风「台风眼」",["SpellCard_SSSEx_05B"]="花咲「百花缭乱」",["SpellCard_SSSEx_05C"]="六花「冰结界的雪花阵」",["SpellCard_SSSEx_05D"]="净符「月光世界」"},["id"]=68069},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl5",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.56,["id"]=68070},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_06A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="天岚「逆卷神风」",["hp"]=2000,["dest"]={192.0,192.0},["optional"]=false,["armor"]=0.815,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_06A"]="天岚「逆卷神风」",["SpellCard_SSSEx_06B"]="花符「云上的花田」",["SpellCard_SSSEx_06C"]="雪幕「冰雪流凌」",["SpellCard_SSSEx_06D"]="皎符「星月炮」"},["id"]=68071},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl4",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.56,["id"]=68072},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_07A",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="「雾隐流剑技 ～ 暴风疾斩」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.9,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_07A"]="「雾隐流剑技 ～ 暴风疾斩」",["SpellCard_SSSEx_07B"]="「雾隐流剑技 ～ 血染之樱」",["SpellCard_SSSEx_07C"]="「雾隐流剑技 ～ 落雪凝霜」",["SpellCard_SSSEx_07D"]="「雾隐流剑技 ～ 天地银蛇」"},["id"]=68073},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="Boss_Rika01.Ctrl3",["time"]=3600,["maxhp"]=10000,["kind"]="nonspell",["title"]="",["hp"]=8000,["dest"]={192.0,160.0},["armor"]=0.4,["id"]=68074},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_08",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="仙境「风花雪月」",["hp"]=2000,["dest"]={192.0,120.0},["optional"]=false,["armor"]=0.907,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_08"]="仙境「风花雪月」"},["id"]=68075},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_09",["time"]=3600,["maxhp"]=10000,["kind"]="spell",["title"]="仙蝶「无限的彩灵」",["hp"]=10000,["dest"]={192.0,-150.0},["optional"]=false,["armor"]=1.0,["backgrounds"]={},["survival"]=true,["variants"]={["SpellCard_SSSEx_09"]="仙蝶「无限的彩灵」"},["id"]=68076},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_10",["time"]=7200,["maxhp"]=10000,["kind"]="spell",["title"]="「未定」",["hp"]=10000,["dest"]={192.0,128.0},["optional"]=false,["armor"]=0.76,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_10"]="「未定」"},["id"]=68077},{["chapter"]="EX",["boss"]="Rika",["boss_name"]="雾隐梨花",["role"]="boss",["source"]="SpellCard_SSSEx_FSC",["time"]=3000,["maxhp"]=10000,["kind"]="spell",["title"]="「雾隐之蝶」",["hp"]=10000,["dest"]={192.0,120.0},["optional"]=true,["armor"]=0.76,["backgrounds"]={},["survival"]=false,["variants"]={["SpellCard_SSSEx_FSC"]="「雾隐之蝶」"},["id"]=68078},{["id"]=68079,["chapter"]="1",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭1道中前半",["hp"]=1,["time"]=3178,["clock_first"]=2,["clock_last"]=3180,["patterns"]={"St01/A/L/Stage01A1_L.mbg","St01/A/L/Stage01A2_L.mbg","St01/A/L/Stage01A3_L.mbg","St01/A/L/Stage01A4_L.mbg","St01/A/L/Stage01A5_L.mbg","St01/A/L/Stage01A6_L.mbg","St01/A/L/Stage01A7_L.mbg","St01/A/L/Stage01A8_L.mbg","St01/A/L/Stage01A_L.mbg"},["source"]="GameState_SSS01",["part"]="a"},{["id"]=68080,["chapter"]="1",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭1道中后半",["hp"]=1,["time"]=2439,["clock_first"]=4001,["clock_last"]=6440,["patterns"]={"St01/B/L/Stage01B1_L.mbg","St01/B/L/Stage01B2_L.mbg","St01/B/L/Stage01B3_L.mbg","St01/B/L/Stage01B4_L.mbg","St01/B/L/Stage01B5_L.mbg","St01/B/L/Stage01B_L.mbg"},["source"]="GameState_SSS01",["part"]="b"},{["id"]=68081,["chapter"]="2",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭2道中前半",["hp"]=1,["time"]=4678,["clock_first"]=2,["clock_last"]=4680,["patterns"]={"St02/A/L/Stage02A10_H.mbg","St02/A/L/Stage02A12_H.mbg","St02/A/L/Stage02A13_H.mbg","St02/A/L/Stage02A1_H.mbg","St02/A/L/Stage02A2-2_H.mbg","St02/A/L/Stage02A2-3_H.mbg","St02/A/L/Stage02A2_H.mbg","St02/A/L/Stage02A3_H.mbg","St02/A/L/Stage02A4_H.mbg","St02/A/L/Stage02A5-2_H.mbg","St02/A/L/Stage02A5_H.mbg","St02/A/L/Stage02A6_H.mbg","St02/A/L/Stage02A7_H.mbg","St02/A/L/Stage02A8_H.mbg","St02/A/L/Stage02A9-2_H.mbg","St02/A/L/Stage02A9_H.mbg","St02/A/L/Stage02A_H.mbg"},["source"]="GameState_SSS02",["part"]="a"},{["id"]=68082,["chapter"]="2",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭2道中后半",["hp"]=1,["time"]=2889,["clock_first"]=5001,["clock_last"]=7890,["patterns"]={"St02/B/L/Stage02B11_L.mbg","St02/B/L/Stage02B1_L.mbg","St02/B/L/Stage02B2_L.mbg","St02/B/L/Stage02B3_L.mbg","St02/B/L/Stage02B4_L.mbg","St02/B/L/Stage02B5_L.mbg","St02/B/L/Stage02B6_L.mbg","St02/B/L/Stage02B8_L.mbg","St02/B/L/Stage02B9_L.mbg"},["source"]="GameState_SSS02",["part"]="b"},{["id"]=68083,["chapter"]="3",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭3道中前半",["hp"]=1,["time"]=3358,["clock_first"]=2,["clock_last"]=3360,["patterns"]={"St03/A/L/Stage03A1_L.mbg","St03/A/L/Stage03A2_L.mbg","St03/A/L/Stage03A3_L.mbg","St03/A/L/Stage03A4_L.mbg","St03/A/L/Stage03A5_L.mbg","St03/A/L/Stage03A_L.mbg"},["source"]="GameState_SSS03",["part"]="a"},{["id"]=68084,["chapter"]="3",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭3道中后半",["hp"]=1,["time"]=3499,["clock_first"]=3801,["clock_last"]=7300,["patterns"]={"St03/B/L/Stage03A1_L.mbg","St03/B/L/Stage03A2_L.mbg","St03/B/L/Stage03A3_L.mbg","St03/B/L/Stage03A4_L.mbg","St03/B/L/Stage03A5_L.mbg","St03/B/L/Stage03A_L.mbg"},["source"]="GameState_SSS03",["part"]="b"},{["id"]=68085,["chapter"]="4",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭4道中前半",["hp"]=1,["time"]=8848,["clock_first"]=2,["clock_last"]=8850,["patterns"]={"St04/A/L/Stage04A1-1_L.mbg","St04/A/L/Stage04A1-2_L.mbg","St04/A/L/Stage04A1-3_L.mbg","St04/A/L/Stage04A2-0_L.mbg","St04/A/L/Stage04A2-1_L.mbg","St04/A/L/Stage04A2-2_L.mbg","St04/A/L/Stage04A2-3_L.mbg","St04/A/L/Stage04A3-0_L.mbg","St04/A/L/Stage04A3-1_L.mbg","St04/A/L/Stage04A3-2_L.mbg","St04/A/L/Stage04A3-3_L.mbg","St04/A/L/Stage04A4-1_L.mbg","St04/A/L/Stage04A4-2_L.mbg","St04/A/L/Stage04A4-3_L.mbg","St04/A/L/Stage04A5-0_L.mbg","St04/A/L/Stage04A5-1_L.mbg","St04/A/L/Stage04A5-2_L.mbg","St04/A/L/Stage04A5-3_L.mbg","St04/A/L/Stage04A5-4_L.mbg","St04/A/L/Stage04A5-5_L.mbg","St04/A/L/Stage04A6-0_L.mbg","St04/A/L/Stage04A6-1_L.mbg","St04/A/L/Stage04A6-2_L.mbg","St04/A/L/Stage04A6-3_L.mbg","St04/A/L/Stage04A6-4_L.mbg","St04/A/L/Stage04A7-0_L.mbg","St04/A/L/Stage04A7-1_L.mbg","St04/A/L/Stage04A7-2_L.mbg","St04/A/L/Stage04A8-01_L.mbg","St04/A/L/Stage04A8-02_L.mbg","St04/A/L/Stage04A8-0_L.mbg","St04/A/L/Stage04A8-11_L.mbg","St04/A/L/Stage04A8-12_L.mbg","St04/A/L/Stage04A8-13_L.mbg","St04/A/L/Stage04A8-1_L.mbg","St04/A/L/Stage04A8-2_L.mbg","St04/A/L/Stage04A8-3_L.mbg","St04/A/L/Stage04A8-4_L.mbg","St04/A/L/Stage04A9-0_L.mbg","St04/A/L/Stage04A9-1_L.mbg","St04/A/L/Stage04A9-2_L.mbg","St04/A/L/Stage04A9-3_L.mbg","St04/A/L/Stage04A9-4_L.mbg","St04/A/L/Stage04A9-5_L.mbg","St04/A/L/Stage04A9-6_L.mbg","St04/A/L/Stage04A9-7_L.mbg","St04/A/L/Stage04A9-8_L.mbg"},["source"]="GameState_SSS04",["part"]="a"},{["id"]=68087,["chapter"]="5",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭5道中前半",["hp"]=1,["time"]=2498,["clock_first"]=2,["clock_last"]=2500,["patterns"]={"St05/A/L/Stage05A1_L.mbg","St05/A/L/Stage05A2_L.mbg","St05/A/L/Stage05A3_L.mbg","St05/A/L/Stage05A4_L.mbg","St05/A/L/Stage05A5_L.mbg","St05/A/L/Stage05A6_L.mbg","St05/A/L/Stage05A7_L.mbg","St05/A/L/Stage05A8_L.mbg","St05/A/L/Stage05A9_L.mbg","St05/A/L/Stage05A_L.mbg"},["source"]="GameState_SSS05",["part"]="a"},{["id"]=68088,["chapter"]="5",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭5道中后半",["hp"]=1,["time"]=5749,["clock_first"]=3001,["clock_last"]=8750,["patterns"]={"St05/B/L/Stage05B10_L.mbg","St05/B/L/Stage05B11_L.mbg","St05/B/L/Stage05B12_L.mbg","St05/B/L/Stage05B13_L.mbg","St05/B/L/Stage05B14_L.mbg","St05/B/L/Stage05B1_L.mbg","St05/B/L/Stage05B2_L.mbg","St05/B/L/Stage05B3_L.mbg","St05/B/L/Stage05B4_L.mbg","St05/B/L/Stage05B5_L.mbg","St05/B/L/Stage05B6_L.mbg","St05/B/L/Stage05B7_L.mbg","St05/B/L/Stage05B8_L.mbg","St05/B/L/Stage05B9_L.mbg"},["source"]="GameState_SSS05",["part"]="b"},{["id"]=68089,["chapter"]="6",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭6道中前半",["hp"]=1,["time"]=8548,["clock_first"]=2,["clock_last"]=8550,["patterns"]={"St06/A/L/Stage06A00_L.mbg","St06/A/L/Stage06A0L.mbg","St06/A/L/Stage06A10L.mbg","St06/A/L/Stage06A11L.mbg","St06/A/L/Stage06A13L.mbg","St06/A/L/Stage06A14L.mbg","St06/A/L/Stage06A15L.mbg","St06/A/L/Stage06A16L.mbg","St06/A/L/Stage06A17L.mbg","St06/A/L/Stage06A18L.mbg","St06/A/L/Stage06A1L.mbg","St06/A/L/Stage06A3L.mbg","St06/A/L/Stage06A4L.mbg","St06/A/L/Stage06A5L.mbg","St06/A/L/Stage06A6L.mbg","St06/A/L/Stage06A7L.mbg","St06/A/L/Stage06A8L.mbg","St06/A/L/Stage06A9L.mbg","St06/A/L/Stage06AS4-2_L.mbg","St06/A/L/Stage06AS4-3_L.mbg"},["source"]="GameState_SSS06",["part"]="a"},{["id"]=68090,["chapter"]="EX",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭EX道中前半",["hp"]=1,["time"]=4918,["clock_first"]=2,["clock_last"]=4920,["patterns"]={"StEx/A/StageExA0.mbg","StEx/A/StageExA1.mbg","StEx/A/StageExA10.mbg","StEx/A/StageExA11.mbg","StEx/A/StageExA12.mbg","StEx/A/StageExA13.mbg","StEx/A/StageExA2.mbg","StEx/A/StageExA3.mbg","StEx/A/StageExA4.mbg","StEx/A/StageExA5.mbg","StEx/A/StageExA6.mbg","StEx/A/StageExA7.mbg","StEx/A/StageExA8.mbg","StEx/A/StageExA9.mbg"},["source"]="GameState_SSSEx",["part"]="a"},{["id"]=68091,["chapter"]="EX",["boss"]="road",["boss_name"]="道中",["role"]="road",["kind"]="road",["title"]="夏夜祭EX道中后半",["hp"]=1,["time"]=5199,["clock_first"]=5061,["clock_last"]=10260,["patterns"]={"StEx/B/Stage05B1.mbg","StEx/B/Stage05B10.mbg","StEx/B/Stage05B2.mbg","StEx/B/Stage05B3.mbg","StEx/B/Stage05B4.mbg","StEx/B/Stage05B5.mbg","StEx/B/Stage05B6.mbg","StEx/B/Stage05B7.mbg","StEx/B/Stage05B8.mbg","StEx/B/Stage05B9.mbg"},["source"]="GameState_SSSEx",["part"]="b"}}
P[1].step=function(o,t,N)
if (t == 100) then N.controller(o,"St01/道中Boss/1非L.mbg",true,"current") end
if (t > 100) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[2].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St01/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St01/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[3].step=function(o,t,N)
if (t == 60) then N.controller(o,"St01/关底Boss/1非L.mbg",true,"current") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[4].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St01/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St01/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[5].step=function(o,t,N)
if (t == 150) then N.controller(o,"St01/关底Boss/2非L.mbg",true,"current") end
if (t > 150) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[6].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St01/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St01/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[7].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St01/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St01/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[8].step=function(o,t,N)
if (t == 60) then N.controller(o,"St02/道中Boss/1非L.mbg",true,"current") end
if (t > 100) then N.wander(o,t,300,30,2.0,132.0,100.0,120.0,40.0) end
end
P[9].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St02/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St02/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[10].step=function(o,t,N)
if (t == 60) then N.controller(o,"St02/关底Boss/1非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[11].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St02/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St02/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[12].step=function(o,t,N)
if (t == 160) then N.controller(o,"St02/关底Boss/2非L.mbg",true,"default") end
if (t > 150) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[13].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St02/关底Boss/2符L.mbg",false,"default") end
else
if (t == 150) then N.controller(o,"St02/关底Boss/2符L.mbg",false,"default") end
end
end
P[14].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St02/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St02/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[15].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St02/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St02/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[16].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St03/道中Boss/1符L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
else
if (t == 100) then N.controller(o,"St03/道中Boss/1符L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
end
end
P[17].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St03/道中Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St03/道中Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[18].step=function(o,t,N)
if (t == 60) then N.controller(o,"St03/关底Boss/1非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,206,20,2.0,147.0,100.0,90.0,40.0) end
end
P[19].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St03/关底Boss/1符L.mbg",false,"default") end
else
if (t == 150) then N.controller(o,"St03/关底Boss/1符L.mbg",false,"default") end
end
end
P[20].step=function(o,t,N)
if (t == 160) then N.controller(o,"St03/关底Boss/2非L.mbg",true,"default") end
if (t > 150) then N.wander(o,t,206,30,2.0,132.0,100.0,120.0,40.0) end
end
P[21].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St03/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St03/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[22].step=function(o,t,N)
if (t == 160) then N.controller(o,"St03/关底Boss/3非L.mbg",true,"default") end
if (t > 150) then N.wander(o,t,206,30,2.0,132.0,100.0,120.0,40.0) end
end
P[23].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St03/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St03/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[24].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St03/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St03/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[25].step=function(o,t,N)
if (t == 60) then N.controller(o,"St04/关底Boss/1非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,138,20,2.0,147.0,100.0,90.0,40.0) end
end
P[26].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St04/关底Boss/1符L.mbg",true,"default") end
if (t > 50) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St04/关底Boss/1符L.mbg",true,"default") end
if (t > 50) then N.bob(o,t,80) end
end
end
P[27].step=function(o,t,N)
if (t == 60) then N.controller(o,"St04/关底Boss/2非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,138,20,2.0,147.0,100.0,90.0,40.0) end
end
P[28].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St04/关底Boss/2符L0.mbg",false,"default") end
if (t > 100) then N.wander(o,t,205,20,2.0,147.0,100.0,90.0,40.0) end
elseif route=="B" then
if (t == 150) then N.controller(o,"St04/关底Boss/2符L1.mbg",false,"default") end
if (t > 100) then N.wander(o,t,205,20,2.0,147.0,100.0,90.0,40.0) end
elseif route=="C" then
if (t == 150) then N.controller(o,"St04/关底Boss/2符L2.mbg",false,"default") end
if (t > 100) then N.wander(o,t,205,20,2.0,147.0,100.0,90.0,40.0) end
elseif route=="D" then
if (t == 150) then N.controller(o,"St04/关底Boss/2符L3.mbg",false,"default") end
if (t > 100) then N.wander(o,t,205,20,2.0,147.0,100.0,90.0,40.0) end
else
if (t == 150) then N.controller(o,"St04/关底Boss/2符L0.mbg",false,"default") end
if (t > 100) then N.wander(o,t,205,20,2.0,147.0,100.0,90.0,40.0) end
end
end
P[29].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St04/关底Boss/3符L0.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="B" then
if (t == 150) then N.controller(o,"St04/关底Boss/3符L1.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="C" then
if (t == 150) then N.controller(o,"St04/关底Boss/3符L2.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="D" then
if (t == 150) then N.controller(o,"St04/关底Boss/3符L3.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St04/关底Boss/3符L0.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[30].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St04/关底Boss/4符L0.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="B" then
if (t == 150) then N.controller(o,"St04/关底Boss/4符L1.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="C" then
if (t == 150) then N.controller(o,"St04/关底Boss/4符L2.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
elseif route=="D" then
if (t == 150) then N.controller(o,"St04/关底Boss/4符L3.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St04/关底Boss/4符L0.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[31].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St04/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St04/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[32].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St04/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St04/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[33].step=function(o,t,N)
if (t == 150) then N.controller(o,"St05/道中Boss/1非L.mbg",true,"current") end
if (t > 100) then N.wander(o,t,300,30,2.0,132.0,100.0,120.0,40.0) end
end
P[34].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/道中Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[35].step=function(o,t,N)
if (t == 60) then N.controller(o,"St05/关底Boss/1非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[36].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[37].step=function(o,t,N)
if (t == 160) then N.controller(o,"St05/关底Boss/2非L.mbg",true,"default") end
if (t > 150) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[38].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[39].step=function(o,t,N)
if (t == 60) then N.controller(o,"St05/关底Boss/3非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[40].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[41].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/关底Boss/4符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/关底Boss/4符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[42].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St05/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St05/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[43].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St05/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St05/关底Boss/FSC符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[44].step=function(o,t,N)
if (t == 60) then N.controller(o,"St06/关底Boss/1非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[45].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/1符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[46].step=function(o,t,N)
if (t == 60) then N.controller(o,"St06/关底Boss/2非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[47].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/2符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[48].step=function(o,t,N)
if (t == 160) then N.controller(o,"St06/关底Boss/3非L.mbg",true,"default") end
if (t > 150) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[49].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/3符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[50].step=function(o,t,N)
if (t == 150) then N.controller(o,"St06/关底Boss/4非L.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[51].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/4符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/4符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[52].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/5符L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[53].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 150) then N.controller(o,"St06/关底Boss/6符P1L.mbg",false,"default") end
if ((o.hp < (o.maxhp * 3) / 4  or  t > 1800)  and  o.flag == 1) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P2L.mbg",false,"default") end
if ((o.hp < (o.maxhp * 2) / 4  or  t > 3600)  and  o.flag == 2) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P3L.mbg",false,"default") end
if ((o.hp < o.maxhp / 4  or  t > 5400)  and  o.flag == 3) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P4L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 150) then N.controller(o,"St06/关底Boss/6符P1L.mbg",false,"default") end
if ((o.hp < (o.maxhp * 3) / 4  or  t > 1800)  and  o.flag == 1) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P2L.mbg",false,"default") end
if ((o.hp < (o.maxhp * 2) / 4  or  t > 3600)  and  o.flag == 2) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P3L.mbg",false,"default") end
if ((o.hp < o.maxhp / 4  or  t > 5400)  and  o.flag == 3) then N.clear(o);o.flag=o.flag+1;N.controller(o,"St06/关底Boss/6符P4L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[54].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St06/关底Boss/FSC1L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St06/关底Boss/FSC1L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[55].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St06/关底Boss/FSC2L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St06/关底Boss/FSC2L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[56].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"St06/关底Boss/FSC3L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
else
if (t == 100) then N.controller(o,"St06/关底Boss/FSC3L.mbg",false,"default") end
if (t > 100) then N.bob(o,t,80) end
end
end
P[57].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/道中Boss/1符.mbg",true,"default") end
else
if (t == 100) then N.controller(o,"StEx/道中Boss/1符.mbg",true,"default") end
end
end
P[58].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/道中Boss/2符.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
else
if (t == 100) then N.controller(o,"StEx/道中Boss/2符.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
end
end
P[59].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/道中Boss/3符.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
else
if (t == 100) then N.controller(o,"StEx/道中Boss/3符.mbg",true,"default") end
if (t > 50) then N.wander(o,t,150,20,2.0,147.0,100.0,90.0,40.0) end
end
end
P[60].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/1非.mbg",true,"default") end
end
P[61].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/1符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/1符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/1符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/1符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/1符0.mbg",false,"default") end
end
end
P[62].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/2非.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[63].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/2符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/2符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/2符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/2符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/2符0.mbg",false,"default") end
end
end
P[64].step=function(o,t,N)
if (t == 160) then N.controller(o,"StEx/关底Boss/3非.mbg",true,"default") end
end
P[65].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/3符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/3符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/3符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/3符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/3符0.mbg",false,"default") end
end
end
P[66].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/4非.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[67].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/4符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/4符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/4符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/4符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/4符0.mbg",false,"default") end
end
end
P[68].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/5非.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[69].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/5符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/5符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/5符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/5符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/5符0.mbg",false,"default") end
end
end
P[70].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/6非.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[71].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/6符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/6符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/6符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/6符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/6符0.mbg",false,"default") end
end
end
P[72].step=function(o,t,N)
if (t == 160) then N.controller(o,"StEx/关底Boss/7非.mbg",true,"default") end
if (t > 150) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[73].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/7符0.mbg",false,"default") end
elseif route=="B" then
if (t == 100) then N.controller(o,"StEx/关底Boss/7符1.mbg",false,"default") end
elseif route=="C" then
if (t == 100) then N.controller(o,"StEx/关底Boss/7符2.mbg",false,"default") end
elseif route=="D" then
if (t == 100) then N.controller(o,"StEx/关底Boss/7符3.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/7符0.mbg",false,"default") end
end
end
P[74].step=function(o,t,N)
if (t == 60) then N.controller(o,"StEx/关底Boss/8非.mbg",true,"default") end
if (t > 50) then N.wander(o,t,346,30,2.0,132.0,100.0,120.0,40.0) end
end
P[75].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/8符.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/8符.mbg",false,"default") end
end
end
P[76].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/9符.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/9符.mbg",false,"default") end
end
end
P[77].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/10符.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/10符.mbg",false,"default") end
end
end
P[78].step=function(o,t,N)
local route=N.route(o)
if route=="A" then
if (t == 100) then N.controller(o,"StEx/关底Boss/FSC符.mbg",false,"default") end
else
if (t == 100) then N.controller(o,"StEx/关底Boss/FSC符.mbg",false,"default") end
end
end
P[79].begin=function(o,N)
N.road_controller(o,"St01/A/L/Stage01A1_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A2_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A3_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A4_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A5_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A6_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A7_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A8_L.mbg",62)
N.road_controller(o,"St01/A/L/Stage01A_L.mbg",62)
end
P[80].begin=function(o,N)
N.road_controller(o,"St01/B/L/Stage01B1_L.mbg",4061)
N.road_controller(o,"St01/B/L/Stage01B2_L.mbg",4061)
N.road_controller(o,"St01/B/L/Stage01B3_L.mbg",4061)
N.road_controller(o,"St01/B/L/Stage01B4_L.mbg",4061)
N.road_controller(o,"St01/B/L/Stage01B5_L.mbg",4061)
N.road_controller(o,"St01/B/L/Stage01B_L.mbg",4061)
end
P[81].begin=function(o,N)
N.road_controller(o,"St02/A/L/Stage02A10_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A12_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A13_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A1_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A2-2_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A2-3_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A2_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A3_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A4_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A5-2_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A5_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A6_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A7_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A8_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A9-2_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A9_H.mbg",-58)
N.road_controller(o,"St02/A/L/Stage02A_H.mbg",-58)
end
P[82].begin=function(o,N)
N.road_controller(o,"St02/B/L/Stage02B11_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B1_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B2_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B3_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B4_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B5_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B6_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B8_L.mbg",4941)
N.road_controller(o,"St02/B/L/Stage02B9_L.mbg",4941)
end
P[83].begin=function(o,N)
N.road_controller(o,"St03/A/L/Stage03A1_L.mbg",-58)
N.road_controller(o,"St03/A/L/Stage03A2_L.mbg",-58)
N.road_controller(o,"St03/A/L/Stage03A3_L.mbg",-58)
N.road_controller(o,"St03/A/L/Stage03A4_L.mbg",-58)
N.road_controller(o,"St03/A/L/Stage03A5_L.mbg",-58)
N.road_controller(o,"St03/A/L/Stage03A_L.mbg",-58)
end
P[84].begin=function(o,N)
N.road_controller(o,"St03/B/L/Stage03A1_L.mbg",3741)
N.road_controller(o,"St03/B/L/Stage03A2_L.mbg",3741)
N.road_controller(o,"St03/B/L/Stage03A3_L.mbg",3741)
N.road_controller(o,"St03/B/L/Stage03A4_L.mbg",3741)
N.road_controller(o,"St03/B/L/Stage03A5_L.mbg",3741)
N.road_controller(o,"St03/B/L/Stage03A_L.mbg",3741)
end
P[85].begin=function(o,N)
N.road_controller(o,"St04/A/L/Stage04A1-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A1-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A1-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A2-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A2-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A2-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A2-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A3-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A3-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A3-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A3-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A4-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A4-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A4-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-4_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A5-5_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A6-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A6-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A6-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A6-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A6-4_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A7-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A7-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A7-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-01_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-02_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-11_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-12_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-13_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A8-4_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-0_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-1_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-2_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-3_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-4_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-5_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-6_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-7_L.mbg",-58)
N.road_controller(o,"St04/A/L/Stage04A9-8_L.mbg",-58)
end
P[86].begin=function(o,N)
N.road_controller(o,"St05/A/L/Stage05A1_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A2_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A3_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A4_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A5_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A6_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A7_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A8_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A9_L.mbg",-58)
N.road_controller(o,"St05/A/L/Stage05A_L.mbg",-58)
end
P[87].begin=function(o,N)
N.road_controller(o,"St05/B/L/Stage05B10_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B11_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B12_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B13_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B14_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B1_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B2_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B3_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B4_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B5_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B6_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B7_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B8_L.mbg",2941)
N.road_controller(o,"St05/B/L/Stage05B9_L.mbg",2941)
end
P[88].begin=function(o,N)
N.road_controller(o,"St06/A/L/Stage06A00_L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A0L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A10L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A11L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A13L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A14L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A15L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A16L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A17L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A18L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A1L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A3L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A4L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A5L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A6L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A7L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A8L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06A9L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06AS4-2_L.mbg",-58)
N.road_controller(o,"St06/A/L/Stage06AS4-3_L.mbg",-58)
end
P[89].begin=function(o,N)
N.road_controller(o,"StEx/A/StageExA0.mbg",-58)
N.road_controller(o,"StEx/A/StageExA1.mbg",-58)
N.road_controller(o,"StEx/A/StageExA10.mbg",-58)
N.road_controller(o,"StEx/A/StageExA11.mbg",-58)
N.road_controller(o,"StEx/A/StageExA12.mbg",-58)
N.road_controller(o,"StEx/A/StageExA13.mbg",-58)
N.road_controller(o,"StEx/A/StageExA2.mbg",-58)
N.road_controller(o,"StEx/A/StageExA3.mbg",-58)
N.road_controller(o,"StEx/A/StageExA4.mbg",-58)
N.road_controller(o,"StEx/A/StageExA5.mbg",-58)
N.road_controller(o,"StEx/A/StageExA6.mbg",-58)
N.road_controller(o,"StEx/A/StageExA7.mbg",-58)
N.road_controller(o,"StEx/A/StageExA8.mbg",-58)
N.road_controller(o,"StEx/A/StageExA9.mbg",-58)
end
P[90].begin=function(o,N)
N.road_controller(o,"StEx/B/Stage05B1.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B10.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B2.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B3.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B4.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B5.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B6.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B7.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B8.mbg",5001)
N.road_controller(o,"StEx/B/Stage05B9.mbg",5001)
end
return {phases=P,orders={["1"]={68079,68001,68002,68080,68003,68004,68005,68006,68007},["2"]={68081,68008,68009,68082,68010,68011,68012,68013,68014,68015},["3"]={68083,68016,68017,68084,68018,68019,68020,68021,68022,68023,68024},["4"]={68085,68025,68026,68027,68028,68029,68030,68031,68032},["5"]={68087,68033,68034,68088,68035,68036,68037,68038,68039,68040,68041,68042,68043},["6"]={68089,68044,68045,68046,68047,68048,68049,68050,68051,68052,68053,68054,68055,68056},["EX"]={68090,68057,68058,68059,68091,68060,68061,68062,68063,68064,68065,68066,68067,68068,68069,68070,68071,68072,68073,68074,68075,68076,68077,68078}},stages={["1"]={["clock"]={3180,4000,6440},["offset"]=60,["bosses"]={"Boss_Ami01","Boss_Ami02"},["ids"]={68001,68002,68003,68004,68005,68006,68007},["road_a"]="St01/A/L/",["road_b"]="St01/B/L/",["road_a_id"]=68079,["road_b_id"]=68080},["2"]={["clock"]={4680,5000,7890},["offset"]=-60,["bosses"]={"Boss_Rakuki01","Boss_Rakuki02"},["ids"]={68008,68009,68010,68011,68012,68013,68014,68015},["road_a"]="St02/A/L/",["road_b"]="St02/B/L/",["road_a_id"]=68081,["road_b_id"]=68082},["3"]={["clock"]={3360,3800,7300},["offset"]=-60,["bosses"]={"Boss_Koreirei01","Boss_Seiryuu01"},["ids"]={68016,68017,68018,68019,68020,68021,68022,68023,68024},["road_a"]="St03/A/L/",["road_b"]="St03/B/L/",["road_a_id"]=68083,["road_b_id"]=68084},["4"]={["clock"]={0,0,8850},["offset"]=-60,["bosses"]={"Boss_Kage01"},["ids"]={68025,68026,68027,68028,68029,68030,68031,68032},["road_a"]="St04/A/L/",["road_b"]="St04/B/L/",["road_a_id"]=68085},["5"]={["clock"]={2500,3000,8750},["offset"]=-60,["bosses"]={"Boss_Rakuki04","Boss_Rakukun01"},["ids"]={68033,68034,68035,68036,68037,68038,68039,68040,68041,68042,68043},["road_a"]="St05/A/L/",["road_b"]="St05/B/L/",["road_a_id"]=68087,["road_b_id"]=68088},["6"]={["clock"]={2550,3000,8550},["offset"]=-60,["bosses"]={"Boss_Tensei01"},["ids"]={68044,68045,68046,68047,68048,68049,68050,68051,68052,68053,68054,68055,68056},["road_a"]="St06/A/L/",["road_b"]="St06/B/L/",["road_a_id"]=68089},["EX"]={["clock"]={4920,5060,10260},["offset"]=-60,["bosses"]={"Boss_Seiryuu03","Boss_Rika01"},["ids"]={68057,68058,68059,68060,68061,68062,68063,68064,68065,68066,68067,68068,68069,68070,68071,68072,68073,68074,68075,68076,68077,68078},["road_a"]="StEx/A/",["road_b"]="StEx/B/",["road_a_id"]=68090,["road_b_id"]=68091}}}
