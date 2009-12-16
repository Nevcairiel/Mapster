--[[
Copyright (c) 2009, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "InstanceMaps"
local Maps = Mapster:NewModule(MODNAME, "AceHook-3.0")

local LBZ = LibStub("LibBabble-Zone-3.0", true)
local BZ = LBZ and LBZ:GetLookupTable() or setmetatable({}, {__index = function(t,k) return k end})

-- Data mostly from http://www.wowwiki.com/API_SetMapByID
local data = {
	-- Northrend Instances
	{
		["The Nexus"] = 520,
		["The Culling of Stratholme"] = 521,
		["Ahn'kahet: The Old Kingdom"] = 522,
		["Utgarde Keep"] = 523,
		["Utgarde Pinnacle"] = 524,
		["Halls of Lightning"] = 525,
		["Halls of Stone"] = 526,
		["The Oculus"] = 528,
		["Gundrak"] = 530,
		["Azjol-Nerub"] = 533,
		["Drak'Tharon Keep"] = 534,
		["The Violet Hold"] = 536,
		-- 3.2
		["Trial of the Champion"] = 542,
		-- 3.3
		["The Forge of Souls"] = 601,
		["Pit of Saron"] = 602,
		["Halls of Reflection"] = 603,
	},

	-- Northrend Raids
	{
		["The Eye of Eternity"] = 527,
		["Ulduar"] = 529,
		["The Obsidian Sanctum"] = 531,
		["Vault of Archavon"] = 532,
		["Naxxramas"] = 535,
		-- 3.2
		["Trial of the Crusader"] = 543,
		-- 3.3
		["Icecrown Citadel"] = 604,
	},
	{
		["Alterac Valley"] = 401,
		["Warsong Gulch"] = 443,
		["Arathi Basin"] = 461,
		["Eye of the Storm"] = 482,
		["Strand of the Ancients"] = 512,
	},
}

--[[
local db
local defaults = {
	profile = {
	}
}
]]

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
	--[[
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	]]

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["Instance Maps"])

	cont_offset = select('#', GetMapContinents())

	self.zone_names = {}
	self.zone_data = {}

	for i, idata in pairs(data) do
		local id = i + cont_offset

		local names = {}
		local name_data = {}
		for name, zdata in pairs(idata) do
			tinsert(names, BZ[name])
			name_data[name] = zdata
		end
		table.sort(names)
		self.zone_names[id] = names

		local zone_data = {}
		for k,v in pairs(names) do
			zone_data[k] = name_data[v]
		end
		self.zone_data[id] = zone_data
	end
	data = nil
end

function Maps:OnEnable()
	self:RawHook("WorldMapContinentsDropDown_Update", true)
	self:RawHook("WorldMapFrame_LoadContinents", true)

	self:RawHook("WorldMapZoneDropDown_Update", true)
	self:RawHook("WorldMapZoneDropDown_Initialize", true)
	self:RawHook("WorldMapZoneButton_OnClick", true)
	
	self:RawHook("SetMapZoom", true)
	self:Hook("SetMapToCurrentZone", true)
end

function Maps:OnDisable()
	self:UnhookAll()
	self.mapCont, self.mapZone = nil, nil
	WorldMapContinentsDropDown_Update()
	WorldMapZoneDropDown_Update()
end

function Maps:GetZoneData()
	return self.zone_data[self.mapCont][self.mapZone]
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
		WorldMapFrame_LoadZones(unpack(self.zone_names[self.mapCont]))
	else
		self.hooks.WorldMapZoneDropDown_Initialize()
	end
end

function Maps:WorldMapZoneButton_OnClick(frame)
	if self.mapCont then
		self.mapZone = frame:GetID()
		UIDropDownMenu_SetSelectedID(WorldMapZoneDropDown, self.mapZone)
		SetMapByID(self:GetZoneData())
	else
		self.hooks.WorldMapZoneButton_OnClick(frame)
	end
end

function Maps:SetMapZoom(cont, zone)
	if self.zone_names[cont] then
		self.mapCont = cont
		self.hooks.SetMapZoom(-1)
	else
		self.mapCont, self.mapZone = nil, nil
		self.hooks.SetMapZoom(cont, zone)
	end
end

function Maps:SetMapToCurrentZone()
	self.mapCont, self.mapZone = nil, nil
end
