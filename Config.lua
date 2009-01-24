--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

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

local options, moduleOptions = nil, {}
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = "Mapster",
			args = {
				general = {
					order = 1,
					type = "group",
					name = "General Settings",
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
						nl = {
							order = 6,
							type = "description",
							name = "",
						},
						hideMapButton = {
							order = 7,
							type = "toggle",
							name = L["Hide Map Button"],
						},
					},
				},
			},
		}
		for k,v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	
	return options
end

local function optFunc() 
	-- open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(Mapster.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(Mapster.optionsFrames.Mapster)
end

function Mapster:SetupOptions()
	InterfaceOptionsFrame:SetFrameStrata("DIALOG") 
	
	self.optionsFrames = {}
	
	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Mapster", getOptions)
	self.optionsFrames.Mapster = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Mapster", nil, nil, "general")
	
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")
	
	LibStub("AceConsole-3.0"):RegisterChatCommand( "mapster", optFunc)
end

function Mapster:RegisterModuleOptions(name, optionTbl, displayName)
	moduleOptions[name] = optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Mapster", displayName, "Mapster", name)
end

function Mapster:SetupMapButton()
	-- create button on the worldmap to toggle the options
	self.optionsButton = CreateFrame("Button", "MapsterOptionsButton", WorldMapFrame, "UIPanelButtonTemplate")
	self.optionsButton:SetWidth(95)
	self.optionsButton:SetHeight(22)
	self.optionsButton:SetText("Mapster")
	self.optionsButton:ClearAllPoints()
	self.optionsButton:SetPoint("TOPRIGHT", "WorldMapPositioningGuide", "TOPRIGHT", -6, -37)
	
	if self.db.profile.hideMapButton or (QuestHelperWorldMapButton and QuestHelperWorldMapButton:IsShown()) then
		self.optionsButton:Hide()
	else
		self.optionsButton:Show()
	end
	
	self.optionsButton:SetScript("OnClick", optFunc)
end
