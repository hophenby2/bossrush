-- Espgaluda 第一至五面，道中与 Boss 来自 PGM 对象池。
-- 差异 1：Ageha 自弹、结界和资源规则使用 LuaSTG 近似，未接入觉圣与精灵石。
-- 差异 2：前两面关底按原伤害计数器换阶段，场上弹幕及部件轨迹来自对应采样区间。
-- 差异 3：第四和第五面的分段只覆盖已采到的状态。
local source = dofile('mod/GAME/pgm/source.lua')('th45')
local bullets = dofile('mod/GAME/pgm/bullets.lua').create(source)
local machine = {
    name='Ageha', speed=163, focus=82, hold=12, bombs=3,
    shot={{-6,-.22},{6,.22}}, interval=3, shotSpeed=13, shotDamage=28,
    laserWidth=9, laserDamage=46, bomb=56, focusBomb=88, bombWidth=40, bombDamage=96,
    color={107,224,180},
}
local player = dofile('mod/GAME/pgm/player.lua')(source,bullets,machine)
_editor_class.TH45 = dofile('mod/GAME/pgm/stage.lua')(source,bullets,player,43)
