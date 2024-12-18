std = "lua51"
max_line_length = false
exclude_files = {
	"Libs/",
	"Locale/find-locale-strings.lua",
	"BattleMap.lua",
	".luacheckrc"
}

ignore = {
	"211/L", -- Unused local variable L
	"211/_.*", -- Unused local variable starting with _
	"212", -- Unused argument
	"213/_.*", -- Unused loop variable starting with _
	"311", -- Value assigned to a local variable is unused
	"512", -- loop is only executed once
	"542", -- empty if branch
}

globals = {
	"HelpPlate",
	"UIPanelWindows",
	"UISpecialFrames",
	"WorldMapFrame",

	"MapsterFogClearData",

	"StaticPopupDialogs.MAPSTER_RELOAD_UI_SCALING",
}

read_globals = {
	"sqrt",
	"strsplit",
	"tinsert",
	"issecurevariable",

	-- Third Party Addon/Libraries
	"LibStub",

	-- API functions
	"C_AddOns",
	"C_Map",
	"C_MapExplorationInfo",
	"CreateFrame",
	"GetBuildInfo",
	"GetCursorPosition",
	"GetCVarBool",
	"InCombatLockdown",
	"IsPlayerMoving",
	"PlaySound",
	"ReloadUI",
	"SetCVar",

	-- FrameXML Frames
	"BattlefieldMinimap",
	"InterfaceOptionsFrame",
	"PlayerMovementFrameFader",
	"Settings",
	"UIParent",
	"WorldMapZoomOutButton",

	-- FrameXML Functions
	"DeltaLerp",
	"HelpPlate_Show",
	"HideUIPanel",

	-- FrameXML Misc
	"BonusObjectivePinMixin",
	"EncounterJournalPinMixin",
	"GameFontNormal",
	"QuestPinMixin",
	"WorldMap_WorldQuestPinMixin",

	"STATICPOPUP_NUMDIALOGS",
	"StaticPopup_Show",

	-- FrameXML Constants
	"MAP_FADE_TEXT",
	"NO",
	"SOUNDKIT",
	"WOW_PROJECT_ID",
	"WOW_PROJECT_MAINLINE",
	"WOW_PROJECT_CLASSIC",
	"WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
	"WOW_PROJECT_WRATH_CLASSIC",
}
