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
	"SetCVar",

	-- FrameXML Frames
	"BattlefieldMinimap",
	"InterfaceOptionsFrame",
	"PlayerMovementFrameFader",
	"UIParent",
	"WorldMapZoomOutButton",

	-- FrameXML Functions
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
}
