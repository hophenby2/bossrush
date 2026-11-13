---======================================
---祈华梦背景
---======================================

---@type EISlib
local lib=EISlib

---@class EISlib.Background @祈华梦背景包
local M={}

---@type EISlib.Background
lib.Background=M

---背景根目录
M.path=lib.path.."background/"

---背景全局缩放
M.scale=1.0

local path=M.path

----------------------------------------
---导入背景

lstg.DoFile(path.."spellcard.lua")
