--[[
Copyright (c) 2009, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "InstanceMaps"
local Maps = Mapster:NewModule(MODNAME, "AceHook-3.0")

local data = {
	-- Northrend Instances
	{
		["Ahn'kahet: The Old Kingdom"] = {
			"AhnKahet",
			{"Area 1", "Area 2"},
		},
		["Azjol-Nerub"] = {
			"AzjolNerub",
			{"Area 1", "Area 2", "Area 3"},
		},
		["The Culling of Stratholme"] = {
			"CoTStratholme",
			--"TheCullingofStratholme",
			{"Area 1", "Area 2"},
		},
		["Drak'Tharon Keep"] = {
			"DrakTharonKeep",
			--"DrakTheron",
			{"Area 1", "Area 2"},
		},
		--["Gundrak"] = "GunDrak",
		["Gundrak"] = {
			"GunDrak",
			{"Area 1"},
		},
		["The Nexus"] = {
			"TheNexus",
			{"Area 1"},
		},
		--["The Nexus"] = "TheNexus",
		["The Oculus"] = {
			"Nexus80",
			--"TheOculus",
			{"Area 1", "Area 2", "Area 3", "Area 4"},
		},
		["Ulduar: Halls of Lightning"] = {
			"HallsofLightning",
			{"Area 1", "Area 2"},
		},
		["Ulduar: Halls of Stone"] = {
			"Ulduar77",
			--"HallsofStone",
			{"Area 1"},
		},
		["Utgarde Keep"] = {
			"UtgardeKeep",
			{"Area 1", "Area 2", "Area 3"},
		},
		["Utgarde Pinnacle"] = {
			"UtgardePinnacle",
			{"Area 1", "Area 2"},
		},
		--["Violet Hold"] = "VioletHold",
		["Violet Hold"] = {
			"VioletHold",
			{"Area 1"},
		},
	},

	-- Northrend Raids
	{
		["Naxxramas"] = {
			"Naxxramas",
			{"The Construct Quarter", "The Arachnid Quarter", "The Military Quarter", "The Plague Quarter", "Naxxramas Overview", "Sapphiron and Kel'Thuzad"},
		},
		--["The Eye of Eternity"] = "EyeOfEternity",
		["The Eye of Eternity"] = {
			"EyeOfEternity",
			{"Area 1"},
		},
		["The Obsidian Sanctum"] = "TheObsidianSanctum",
--		["The Obsidian Sanctum"] = {
--			"TheObsidianSanctum",
--			{"Area 1"},
--		},
		["Ulduar"] = {
			"Ulduar",
			{[0] = "Area Base", "Area 1", "Area 2", "Area 3", "Area 4"},
		},
		["Vault of Archavon"] = {
			"VaultofArchavon",
			{"Area 1"},
		},
	},
	{
		["Alterac Valley"] = "AlteracValley",
		["Arathi Basin"] = "ArathiBasin",
		["Eye of the Storm"] = "NetherstormArena",
		["Strand of the Ancients"] = "StrandoftheAncients",
		["Warsong Gulch"] = "WarsongGulch",
	},
}

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["Instance Maps"],
			arg = MODNAME,
			get = optGetter,
			set = optSetter,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["The Instance Maps module allows you to view the Instance and Battleground Maps provided by the game without being in the instance yourself."],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable Instance Maps"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
			},
		}
	end

	return options
end

local cont_offset

function Maps:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["Instance Maps"])

	cont_offset = select('#', GetMapContinents())

	self.zones = {}

	for i, data in pairs(data) do
		local id = i + cont_offset
		self.zones[id] = {}
		for name in pairs(data) do
			-- Todo: translate with babble-zone here, maybe?
			tinsert(self.zones[id], name)
		end
		table.sort(self.zones[id])
	end
end

function Maps:OnEnable()
	self:RawHook("WorldMapContinentsDropDown_Update", true)
	self:RawHook("WorldMapFrame_LoadContinents", true)

	self:RawHook("WorldMapZoneDropDown_Update", true)
	self:RawHook("WorldMapZoneDropDown_Initialize", true)
	self:RawHook("WorldMapZoneButton_OnClick", true)

	self:RawHook("WorldMapLevelDropDown_Update", true)
	self:RawHook("WorldMapLevelDropDown_Initialize", true)
	WorldMapLevelUpButton:SetScript("OnClick", self.WorldMapLevelUp_OnClick)
	WorldMapLevelDownButton:SetScript("OnClick", self.WorldMapLevelDown_OnClick)

	self:RawHook("SetMapZoom", true)
	self:RawHook("SetDungeonMapLevel", true)
	self:Hook("SetMapToCurrentZone", true)

	self:RawHook("WorldMapFrame_Update", true)
end

function Maps:OnDisable()
	self:UnhookAll()
	self.mapCont, self.mapZone, self.dungeonLevel = nil, nil, nil
	WorldMapFrame_Update()
	WorldMapContinentsDropDown_Update()
	WorldMapZoneDropDown_Update()
	WorldMapLevelDropDown_Update()

	WorldMapLevelUpButton:SetScript("OnClick", WorldMapLevelUp_OnClick)
	WorldMapLevelDownButton:SetScript("OnClick", WorldMapLevelDown_OnClick)
end

function Maps:WorldMapContinentsDropDown_Update()
	self.hooks.WorldMapContinentsDropDown_Update()
	if self.mapCont then
		UIDropDownMenu_SetSelectedID(WorldMapContinentDropDown, self.mapCont)
	end
end

function Maps:WorldMapFrame_LoadContinents(...)
	self.hooks.WorldMapFrame_LoadContinents(...)

	local info = UIDropDownMenu_CreateInfo()
	info.text =  L["Northrend Instances"]
	info.func = WorldMapContinentButton_OnClick;
	info.checked = nil;
	UIDropDownMenu_AddButton(info)

	info.text =  L["Northrend Raids"]
	info.func = WorldMapContinentButton_OnClick;
	info.checked = nil;
	UIDropDownMenu_AddButton(info)

	info.text =  L["Battlegrounds"]
	info.func = WorldMapContinentButton_OnClick;
	info.checked = nil;
	UIDropDownMenu_AddButton(info)
end

function Maps:WorldMapZoneDropDown_Update()
	self.hooks.WorldMapZoneDropDown_Update()
	if self.mapZone then
		UIDropDownMenu_SetSelectedID(WorldMapZoneDropDown, self.mapZone)
	end
end

function Maps:WorldMapZoneDropDown_Initialize()
	if self.mapCont then
		WorldMapFrame_LoadZones(unpack(self.zones[self.mapCont]))
	else
		self.hooks.WorldMapZoneDropDown_Initialize()
	end
end

function Maps:WorldMapZoneButton_OnClick(frame)
	if self.mapCont then
		UIDropDownMenu_SetSelectedID(WorldMapZoneDropDown, frame:GetID());
		SetMapZoom(self.mapCont, frame:GetID());
	else
		self.hooks.WorldMapZoneButton_OnClick(frame)
	end
end

function Maps:WorldMapLevelDropDown_Update()
	self.hooks.WorldMapLevelDropDown_Update()
	if self.mapCont and self.mapZone and self:GetNumDungeonMapLevels() > 0 then
		UIDropDownMenu_SetSelectedID(WorldMapLevelDropDown, self.dungeonLevel)
		WorldMapLevelDropDown:Show()
		WorldMapLevelUpButton:Show()
		WorldMapLevelDownButton:Show()
	end
end

function Maps:WorldMapLevelDropDown_Initialize()
	if self.mapCont and self.mapZone then
		local info = UIDropDownMenu_CreateInfo()
		local level = self.dungeonLevel

		local mapname = strupper(GetMapInfo() or "");

		for i=1, self:GetNumDungeonMapLevels() do
			local floorname =_G["DUNGEON_FLOOR_" .. mapname .. i];
			info.text = floorname or string.format(FLOOR_NUMBER, i);
			info.func = WorldMapLevelButton_OnClick;
			info.checked = (i == level);
			UIDropDownMenu_AddButton(info);
		end
	else
		self.hooks.WorldMapLevelDropDown_Initialize()
	end
end

function Maps.WorldMapLevelUp_OnClick(frame)
	if Maps.mapCont and Maps.mapZone then
		Maps:SetDungeonMapLevel(Maps.dungeonLevel - 1)
		UIDropDownMenu_SetSelectedID(WorldMapLevelDropDown, Maps.dungeonLevel)
		PlaySound("UChatScrollButton")
	else
		WorldMapLevelUp_OnClick(frame)
	end
end

function Maps.WorldMapLevelDown_OnClick(frame)
	if Maps.mapCont and Maps.mapZone then
		Maps:SetDungeonMapLevel(Maps.dungeonLevel + 1)
		UIDropDownMenu_SetSelectedID(WorldMapLevelDropDown, Maps.dungeonLevel)
		PlaySound("UChatScrollButton")
	else
		WorldMapLevelDown_OnClick(frame)
	end
end

function Maps:SetMapZoom(cont, zone)
	if self.zones[cont] then
		self.mapCont = cont
		self.mapZone = zone
		if zone then
			if self:GetNumDungeonMapLevels() > 0 then
				self.dungeonLevel = (self:GetNumDungeonMapLevels() > 0) and 1 or 0
			end
		end
		self:WorldMapFrame_Update()
		self.hooks.SetMapZoom(-1)
	else
		self.mapCont = nil
		self.mapZone = nil
		self.dungeonLevel = nil
		self.hooks.SetMapZoom(cont, zone)
	end
end

function Maps:GetNumDungeonMapLevels()
	if self.mapCont and self.mapZone then
		local zone_data = data[self.mapCont - cont_offset][self.zones[self.mapCont][self.mapZone]]
		if type(zone_data) == "table" then
			return #(zone_data[2])
		else
			return 0
		end
	else
		return GetNumDungeonMapLevels()
	end
end

function Maps:SetDungeonMapLevel(level)
	if self.mapCont and self.mapZone then
		self.dungeonLevel = max(1, min(level, self:GetNumDungeonMapLevels()))
		self:WorldMapFrame_Update()
	else
		self.hooks.SetDungeonMapLevel(level)
	end
end

function Maps:SetMapToCurrentZone()
	self.mapCont, self.mapZone, self.dungeonLevel = nil, nil, nil
end

function Maps:WorldMapFrame_Update()
	if self.mapCont and self.mapZone then
		OutlandButton:Hide()
		AzerothButton:Hide()

		local mapFileName
		local zone_data = data[self.mapCont-cont_offset][self.zones[self.mapCont][self.mapZone]]
		if type(zone_data) == "table" then
			mapFileName = zone_data[1]
		else
			mapFileName = zone_data
		end

		local texName
		local dungeonLevel = self.dungeonLevel or 0
		for i=1, NUM_WORLDMAP_DETAIL_TILES do
			if ( dungeonLevel > 0 ) then
				texName = "Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..dungeonLevel.."_"..i;
			else
				texName = "Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..i;
			end
			_G["WorldMapDetailTile"..i]:SetTexture(texName);
		end
	else
		self.hooks.WorldMapFrame_Update()
	end
end

