-- Please make sure to save the file as UTF-8; ¶
--
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "zhCN")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster让你改变世界地图的各种样式, 通过扩展插件来增强大地图的功能.冰可以为每个角色设置不同的配置"
L["Style"] = "样式"
L["alpha_desc"] = "改变世界地图的透明度, 使你在打开大地图的情况下仍然继续操作你的人物"
L["Alpha"] = "透明度"
L["scale_desc"] = "调整世界地图的显示比例. 它可以让你的世界地图不会再覆盖整个屏幕"
L["Scale"] = "缩放"
-- L["Hide Map Button"] = true

-- Coords
L["Coordinates"] = "坐标" -- name of the module
L["coords_desc"] = "在世界地图上加入你当前位置坐标和鼠标位置的鼠标"
L["Enable Coordinates"] = "启用坐标"
L["Accuracy"] = "高精度"
L["coords_accuracy_desc"] = "\n选择此项使你的坐标信息更加精确.例如: 如果你需要精确的位置坐标,请设置到2."

L["Cursor"] = "鼠标"
L["Player"] = "玩家"

-- Group Icons
L["Group Icons"] = "小队标记" -- name of the module
L["groupicons_desc"] = "增强在世界地图和区域/战场地图上的标记. 他们可以详细的显示职业和队伍"
L["Enable Group Icons"] = "启用小队标记"

-- FogClear
L["FogClear"] = "地图全亮" -- name of the module
L["fogclear_desc"] = "世界地图全亮.显示你没有去探索过的地图"
L["Enable FogClear"] =  "启用地图全亮"
L["Overlay Color"] = "覆盖颜色"
--L["Reset FogClear Data"] = true
--L["reset_desc"] = "FogClear collects new Data in your own SavedVariables, but that data might get corrupted (or simply old) with a new patch. Reset the data if you see corruption in the world map."
--L["Note: You need to reload your UI after reseting the data!"] = true
--L["Debug"] = true
--L["debug_desc"] = "Turn on debugging for the FogClear Module."
