-- 怒首领蜂大往生 V101 第一至五面，道中与 Boss 来自 PGM 对象池。
-- 差异 1：Type A 自弹、激光炸弹和资源规则使用 LuaSTG 近似，未接入蜂和 Hyper。
-- 差异 2：第一面可分别击破两侧部件，分支播放原程序的采样，跳转时动作相位仍有差异。
-- 差异 3：关底只接入已采到的攻击状态，二周目待补。
local source = dofile('mod/GAME/pgm/source.lua')('th44')
local bullets = dofile('mod/GAME/pgm/bullets.lua').create(source)
local machine = {
    name='Type A', speed=163, focus=91, hold=14, bombs=3, turn=8,
    shot={{-8,-.65},{0,0},{8,.65}}, interval=4, shotSpeed=12, shotDamage=22,
    laserWidth=6, laserDamage=42, bomb=66, focusBomb=100, bombWidth=48, bombDamage=88,
    color={255,181,104},
}
local player = dofile('mod/GAME/pgm/player.lua')(source,bullets,machine)
_editor_class.TH44 = dofile('mod/GAME/pgm/stage.lua')(source,bullets,player,42)
