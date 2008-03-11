--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

--[[ $Id$ ]]
local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local optGetter, optSetter
do
	function optGetter(info)
		local key = info[#info] 
		return Mapster.db.profile[key]
	end
	
	function optSetter(info, value)
		local key = info[#info]
		Mapster.db.profile[key] = value
		Mapster:Refresh()
	end
end

local options = {
	type = "group",
	name = "Mapster",
	get = optGetter,
	set = optSetter,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["intro_desc"],
		},
		alphadesc = {
			order = 2,
			type = "description",
			name = L["alpha_desc"],
		},
		alpha = {
			order = 3,
			name = L["Alpha"],
			type = "range",
			min = 0, max = 1, step = 0.01,
			isPercent = true,
		},
		scaledesc = {
			order = 4,
			type = "description",
			name = L["scale_desc"],
		},
		scale = {
			order = 5,
			name = L["Scale"],
			type = "range",
			min = 0.1, max = 1, step = 0.01,
			isPercent = true,
		},
	},
}

local function toggleOptions()
	local ACD = LibStub("AceConfigDialog-3.0")
	if ACD.OpenFrames["Mapster"] then
		ACD:Close("Mapster")
	else
		ACD:Open("Mapster")
	end
end

function Mapster:SetupOptions()
	-- create button on the worldmap to toggle the options
	self.optionsButton = CreateFrame("Button", "MapsterOptionsButton", WorldMapFrame, "UIPanelButtonTemplate")
	self.optionsButton:SetWidth(110)
	self.optionsButton:SetHeight(22)
	self.optionsButton:SetText("Mapster")
	self.optionsButton:ClearAllPoints()
	self.optionsButton:SetPoint("TOPRIGHT", "WorldMapPositioningGuide", "TOPRIGHT", -9, -37)
	self.optionsButton:Show()
	
	self.optionsButton:SetScript("OnClick", toggleOptions)
	
	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Mapster", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Mapster", "Mapster")
end

function Mapster:RegisterModuleOptions(name, optionTbl, displayName)
	name = "Mapster"..name
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(name, optionTbl)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, displayName, "Mapster")
end
