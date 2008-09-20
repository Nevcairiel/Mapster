--[[ $Id$ ]]
-- Please make sure to save the file as UTF-8; ¶
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster","enUS", true)


-- Mapster Config
L["intro_desc"] = "Mapster allows you to control various aspects of your World Map. You can change the style of the map, control the plugins that extend the map with new functionality, and configure different profiles for every of your characters."
L["Style"] = true
L["alpha_desc"] = "You can change the transparency of the world map to allow you to continue seeing the world environment while your map is open for navigation."
L["Alpha"] = true
L["scale_desc"] = "Change the scale of the world map if you do not want the whole screen filled while the map is open."
L["Scale"] = true

-- Coords
L["Coordinates"] = true -- name of the module
L["coords_desc"] = "The Coordinates module adds a display of your current location, and the coordinates of your mouse cursor to the World Map frame."
L["Enable Coordinates"] = true
L["Accuracy"] = true
L["coords_accuracy_desc"] = "\nYou can control the accuracy of the coordinates, e.g. if you need very exact coordinates you can set this to 2."

L["Cursor"] = true
L["Player"] = true

-- Group Icons
L["Group Icons"] = true -- name of the module
L["groupicons_desc"] = "The Group Icons module converts the player icons on the World Map and the Zone/Battlefield map to more meaningful icons, showing their class and (in raids) their sub-group."
L["Enable Group Icons"] = true

-- FogClear
L["FogClear"] = true -- name of the module
L["fogclear_desc"] = "The FogClear module removes the Fog of War from the World map, thus displaying the artwork for all the undiscovered zones, optionally with a color overlay on undiscovered areas."
L["Enable FogClear"] = true
L["Overlay Color"] = true
L["Reset FogClear Data"] = true
L["reset_desc"] = "FogClear collects new Data in your own SavedVariables, but that data might get corrupted (or simply old) with a new patch. Reset the data if you see corruption in the world map."
L["Note: You need to reload your UI after reseting the data!"] = true
L["Debug"] = true
L["debug_desc"] = "Turn on debugging for the FogClear Module."
