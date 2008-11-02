-- Please make sure to save the file as UTF-8; ¶
--
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "frFR")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster permet de contrôler divers aspects de la carte du monde. Vous pouvez modifier son style, contrôler les plugins qui lui ajoutent de nouvelles fonctionnalités, et configurer différents profils pour tous vos personnages."
L["Style"] = "Style"
L["alpha_desc"] = "Vous pouvez modifier la transparence de la carte du monde afin de continuer à voir l'environnement du jeu quand vous consultez la carte."
L["Alpha"] = "Transparence"
L["scale_desc"] = "Modifiez l'échelle de la carte du monde si vous ne souhaitez pas que tout votre écran soit occupé quand la carte est ouverte."
L["Scale"] = "Échelle"
-- L["Hide Map Button"] = true

-- Coords
L["Coordinates"] = "Coordonnées" -- name of the module
L["coords_desc"] = "Le module des coordonnées ajoute sur la fenêtre de la carte du monde les coordonnées actuelles de votre personnage ainsi que ceux de votre curseur."
L["Enable Coordinates"] = "Activer coordonnées"
L["Accuracy"] = "Précision"
L["coords_accuracy_desc"] = "\nVous pouvez ici contrôler la précision des coordonnées. Par exemple, si vous voulez des coordonnées très précises, mettez la valeur à 2."

L["Cursor"] = "Curseur "
L["Player"] = "Joueur "

-- Group Icons
L["Group Icons"] = "Icônes de groupe" -- name of the module
L["groupicons_desc"] = "Le module des icônes de groupe converti les icônes des joueurs affichés sur la carte du monde et sur la carte locale en des icônes plus significatives, indiquant leurs classes et (si en raid) leurs groupes."
L["Enable Group Icons"] = "Activer icônes de groupe"

-- BattleMap
-- L["BattleMap"] = true -- name of the module
-- L["battlemap_desc"] = "The BattleMap module allows you to change the style of the BattlefieldMinimap, removing unnecessary textures or PvP Objectives."
-- L["Enable BattleMap"] = true
-- L["battlemap_textures_desc"] = "\nHide the surrounding textures around the BattleMap, only leaving you with the pure map overlays."
-- L["Hide Textures"] = true

-- FogClear
L["FogClear"] = "Antibrouillard" -- name of the module
L["fogclear_desc"] = "Le module d'antibrouillard enlève le brouillard de guerre de la carte du monde, affichant ainsi tout ce qui se trouve dans les zones qui vous sont inconnues."
L["Enable FogClear"] = "Activer antibrouillard"
L["Overlay Color"] = "Couleur de superposition"
L["Reset FogClear Data"] = "RÀZ des données"
L["reset_desc"] = "Antibrouillard enregistre les nouvelles données dans votre propre SavedVariables, mais ces données peuvent devenir corrompues (ou tout simplement obsolètes) avec un nouveau patch. Réinitialisez les données si une des cartes du monde semble corrompue."
L["Note: You need to reload your UI after reseting the data!"] = "Note : rechargez votre IU après la réinitialisation des données !"
--L["Debug"] = true
--L["debug_desc"] = "Turn on debugging for the FogClear Module."