--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "InstanceMaps"
local Maps = Mapster:NewModule(MODNAME, "AceHook-3.0")

local data = {
	-- Northrend Instances
	[5] = {
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
	[6] = {
		["Naxxramas"] = {
			"Naxxramas",
			{"The Construct Quarter", "The Arachnid Quarter", "The Military Quarter", "The Plague Quarter", "Naxxramas Overview", "Sapphiron and Kel'Thuzad"},
		},
		--["The Eye of Eternity"] = "EyeOfEternity",
		["The Eye of Eternity"] = {
			"EyeOfEternity",
			{"Area 1"},
		},
		["The Obsidian Sanctum"] = "TheObsidianSanctum\\TheObsidianSanctum%d",
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
	[7] = {
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

function Maps:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["Instance Maps"])

	self.zones = {}

	for id, data in pairs(data) do
		self.zones[id] = {}
		for name in pairs(data) do
			-- Todo: translate with babble-zone here, maybe?
			tinsert(self.zones[id], name)
		end
		table.sort(self.zones[id])
	end
end

function Maps:OnEnable()
	self:RawHook("GetMapContinents", true)
	self:RawHook("GetCurrentMapContinent", true)

	self:RawHook("GetMapZones", true)
	self:RawHook("GetCurrentMapZone", true)

	self:RawHook("GetNumDungeonMapLevels", true)
	self:RawHook("GetCurrentMapDungeonLevel", true)

	self:RawHook("SetMapZoom", true)
	self:RawHook("SetDungeonMapLevel", true)
	self:Hook("SetMapToCurrentZone", true)

	self:RawHook("WorldMapZoomOutButton_OnClick", true)

	self:RawHook("GetMapInfo", true)
end

function Maps:OnDisable()

end

function Maps:GetMapContinents()
	local continents = {self.hooks.GetMapContinents()}
	tinsert(continents, L["Northrend Instances"])
	tinsert(continents, L["Northrend Raids"])
	tinsert(continents, L["Battlegrounds"])
	return unpack(continents)
end

function Maps:GetCurrentMapContinent()
	return self.mapCont or self.hooks.GetCurrentMapContinent()
end

function Maps:GetMapZones(continent)
	if self.zones[continent] then
		return unpack(self.zones[continent])
	end
	return self.hooks.GetMapZones(continent)
end

function Maps:GetCurrentMapZone()
	return self.mapCont and (self.mapZone or 0) or self.hooks.GetCurrentMapZone()
end

function Maps:GetNumDungeonMapLevels()
	if self.mapCont and self.mapZone then
		local zone_data = data[self.mapCont][self.zones[self.mapCont][self.mapZone]]
		if type(zone_data) == "table" then
			return #(zone_data[2])
		else
			return 0
		end
	else
		return self.hooks.GetNumDungeonMapLevels()
	end
end

function Maps:GetCurrentMapDungeonLevel()
	return self.dungeonLevel or self.hooks.GetCurrentMapDungeonLevel()
end

function Maps:SetMapZoom(cont, zone)
	if self.zones[cont] then
		self.mapCont = cont
		self.mapZone = zone
		cont = -1
		zone = nil
		self.hooks.SetMapZoom(-1)
		if self.mapZone then
			if GetNumDungeonMapLevels() > 0 then
				self.dungeonLevel = 1
			end
			WorldMapFrame_Update()
			WorldMapLevelDropDown_Update()
		else
			WorldMapZoneDropDown_Update()
		end
	else
		self.mapCont = nil
		self.mapZone = nil
		self.dungeonLevel = nil
		self.hooks.SetMapZoom(cont, zone)
	end
end

function Maps:SetDungeonMapLevel(level)
	if self.mapCont and self.mapZone then
		self.dungeonLevel = max(1, min(level, GetNumDungeonMapLevels()))
		WorldMapFrame_Update()
	else
		self.hooks.SetDungeonMapLevel(level)
	end
end

function Maps:SetMapToCurrentZone()
	self.mapCont, self.mapZone, self.dungeonLevel = nil, nil, nil
end

function Maps:WorldMapZoomOutButton_OnClick()
	if self.mapZone then
		self.mapCont, self.mapZone, self.dungeonLevel = nil, nil, nil
		WorldMapFrame_Update()
		WorldMapContinentsDropDown_Update()
		WorldMapZoneDropDown_Update()
		WorldMapLevelDropDown_Update()
	else
		self.hooks.WorldMapZoomOutButton_OnClick()
	end
end

function Maps:GetMapInfo()
	if self.mapCont and self.mapZone then
		local zone_data = data[self.mapCont][self.zones[self.mapCont][self.mapZone]]
		if type(zone_data) == "table" then
			return zone_data[1]
		else
			return zone_data
		end
	else
		return self.hooks.GetMapInfo()
	end
end
