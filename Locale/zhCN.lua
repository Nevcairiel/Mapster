--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "zhCN")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster允许你控制世界地图的各种样式. 你可以改变地图的样式, 通过扩展插件来新增地图功能,并可以在每个人物下设置不同的配置."
 L["Style"] = "样式"
 L["alpha_desc"] = "改变世界地图的透明度, 使你打开地图的情况下继续操作你的人物."
 L["Alpha"] = "透明度"
 L["scale_desc"] = "调整世界地图的大小.它可以让你的世界地图不再覆盖整个屏幕."
 L["Scale"] = "缩放"

-- Coords
 L["Coordinates"] = "坐标" -- name of the module
 L["coords_desc"] = "在世界地图上增加你当前位置坐标和鼠标位置坐标."
 L["Enable Coordinates"] = "启用坐标"
L["Accuracy"] = "精准"
L["coords_accuracy_desc"] = "\n那你的坐标显示的更精确.例如:如果你需要精确的位置坐标,那么请设置到2."

 L["Cursor"] = "坐标"
 L["Player"] = "玩家"

-- Group Icons
 L["Group Icons"] = "队伍标记" -- name of the module
 L["groupicons_desc"] = "在世界地图和区域/战场地图上增加功能更强大的标记.它们可以详细的显示出职业以及队伍"
 L["Enable Group Icons"] = "启用队伍标记"

-- FogClear
 L["FogClear"] = "地图全亮" -- name of the module
 L["fogclear_desc"] = "地图全亮,显示你未征途的区域."
 L["Enable FogClear"] = "启用地图全亮"
 L["fogclear_desc_color"] = "如果你想知道未去过的区域, 那么你可以设置一层颜色来覆盖此区域的地图."
 L["Overlay Color"] = "覆盖颜色"
--by wolftankk@cwdg