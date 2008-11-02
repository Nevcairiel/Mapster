-- Please make sure to save the file as UTF-8; ¶
--
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "deDE")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster erlaubt die Kontrolle \195\188ber verschiedene Aspekte deiner Weltkarte. Du kannst den Stil der Karte \195\164ndern, die Plugins die die Funktionalit\195\164t der Weltkarte erweitern kontrollieren, und verschiedene Profile f\195\188r alle deine Charaktere erstellen."
L["Style"] = "Stil"
L["alpha_desc"] = "Du kannst die Transparenz der Weltkarte \195\164ndern, so da\195\159 du weiterhin die Umgebung wahrnehmen kannst, w\195\164hrend die Karte ge\195\182ffnet."
L["Alpha"] = "Alpha"
L["scale_desc"] = "\195\132ndere die Skalierung der Weltkarte wenn sie ge\195\182ffnet weniger Platz in Anspruch nehmen soll."
L["Scale"] = "Skalierung"
-- L["Hide Map Button"] = true

-- Coords
L["Coordinates"] = "Koordinaten" -- name of the module
L["coords_desc"] = "Das Koordinaten-Modul f\195\188gt die Anzeige deiner aktuellen Position hinzu, sowie die Koordinaten deines Mauszeigers auf der Weltkarte."
L["Enable Coordinates"] = "Koordinaten aktivieren"
L["Accuracy"] = "Genauigkeit"
L["coords_accuracy_desc"] = "\nDu kannst die Genauigkeit der Koordinaten einstellen, zB wenn du sehr exakte Werte ben\195\182tigst dann stelle den Wert auf 2."

L["Cursor"] = "Kursor"
L["Player"] = "Spieler"

-- Group Icons
L["Group Icons"] = "Gruppensymbole" -- name of the module
L["groupicons_desc"] = "Das Gruppensymbole-Modul konvertiert die Spielersymbole auf der Weltkarte in aussagekr\195\164ftigere Symbole, welche die Klasse und (in Schlachtz\195\188gen) die Sub-Gruppe anzeigen."
L["Enable Group Icons"] = "Gruppensymbole aktivieren"

-- BattleMap
-- L["BattleMap"] = true -- name of the module
-- L["battlemap_desc"] = "The BattleMap module allows you to change the style of the BattlefieldMinimap, removing unnecessary textures or PvP Objectives."
-- L["Enable BattleMap"] = true
-- L["battlemap_textures_desc"] = "\nHide the surrounding textures around the BattleMap, only leaving you with the pure map overlays."
-- L["Hide Textures"] = true

-- FogClear
L["FogClear"] = "FogClear" -- name of the module
L["fogclear_desc"] = "Das FogClear-Modul entfernt den Nebel des Krieges auf der Weltkarte, womit alle bisher unentdeckten Gebiete automatisch aufgedeckt werden."
L["Enable FogClear"] = "FogClear aktivieren"
L["Overlay Color"] = "Overlay-Farbe"
--L["Reset FogClear Data"] = true
--L["reset_desc"] = "FogClear collects new Data in your own SavedVariables, but that data might get corrupted (or simply old) with a new patch. Reset the data if you see corruption in the world map."
--L["Note: You need to reload your UI after reseting the data!"] = true
--L["Debug"] = true
--L["debug_desc"] = "Turn on debugging for the FogClear Module."
