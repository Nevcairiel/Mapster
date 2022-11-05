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
}

read_globals = {
	"sqrt",
	"strsplit",
	"tinsert",

	-- Third Party Addon/Libraries
	"LibStub",

	-- API functions
	"C_Map",
	"C_MapExplorationInfo",
	"CreateFrame",
	"GetBuildInfo",
	"GetCursorPosition",
	"GetCVarBool",
	"InCombatLockdown",
	"IsAddOnLoaded",
	"IsPlayerMoving",
	"SetCVar",

	-- FrameXML Frames
	"BattlefieldMinimap",
	"InterfaceOptionsFrame",
	"PlayerMovementFrameFader",
	"UIParent",
	"WorldMapZoomOutButton",

	-- FrameXML Functions
	"DeltaLerp",
	"HelpPlate_Show",
	"InterfaceOptionsFrame_OpenToCategory",
	"TexturePool_HideAndClearAnchors",

	-- FrameXML Misc
	"BonusObjectivePinMixin",
	"EncounterJournalPinMixin",
	"GameFontNormal",
	"QuestPinMixin",

	-- FrameXML Constants
	"MAP_FADE_TEXT",
	"WOW_PROJECT_ID",
	"WOW_PROJECT_MAINLINE",
	"WOW_PROJECT_CLASSIC",
	"WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
	"WOW_PROJECT_WRATH_CLASSIC",
}
