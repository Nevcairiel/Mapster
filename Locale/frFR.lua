--[[ $Id$ ]]
local L = LibStub("AceLocale-3.0"):NewLocale("Mapster", "frFR")
if not L then return end

-- Mapster Config
L["intro_desc"] = "Mapster permet de contrôler divers aspects de la carte du monde. Vous pouvez modifier son style, contrôler les plugins qui lui ajoutent de nouvelles fonctionnalités, et configurer différents profils pour tous vos personnages."
L["Style"] = "Style"
L["alpha_desc"] = "Vous pouvez modifier la transparence de la carte du monde afin de continuer à voir l'environnement du jeu quand vous consultez la carte."
L["Alpha"] = "Transparence"
L["scale_desc"] = "Modifiez l'échelle de la carte du monde si vous ne souhaitez pas que tout votre écran soit occupé quand la carte est ouverte."
L["Scale"] = "Échelle"

-- Coords
L["Coordinates"] = "Coordonnées" -- name of the module
L["coords_desc"] = "Le module des coordonnées ajoute sur la fenêtre de la carte du monde les coordonnées actuelles de votre personnage ainsi que ceux de votre curseur."
L["Enable Coordinates"] = "Activer les coordonnées"
L["Accuracy"] = "Précision"
L["coords_accuracy_desc"] = "\nVous pouvez ici contrôler la précision des coordonnées. Par exemple, si vous voulez des coordonnées très précises, mettez la valeur à 2."

L["Cursor"] = "Curseur"
L["Player"] = "Joueur"

-- Group Icons
L["Group Icons"] = "Icônes de groupe" -- name of the module
L["groupicons_desc"] = "Le module des icônes de groupe converti les icônes des joueurs affichés sur la carte du monde et sur la carte locale en des icônes plus significatives, indiquant leurs classes et (si en raid) leurs groupes."
L["Enable Group Icons"] = "Activer Icônes de groupe"

-- FogClear
L["FogClear"] = "Antibrouillard" -- name of the module
L["fogclear_desc"] = "Le module d'antibrouillard enlève le brouillard de guerre de la carte du monde, affichant ainsi tout ce qui se trouve dans les zones qui vous sont inconnues."
L["Enable FogClear"] = "Activer l'antibrouillard"
L["fogclear_desc_color"] = "Cependant, si vous préférez savoir quelles zones vous n'avez pas encore découvertes, vous pouvez définir une couleur qui sera appliquée à ces zones, afin de savoir où aller."
L["Overlay Color"] = "Couleur de superposition"