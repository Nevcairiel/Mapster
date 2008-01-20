--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

--[[ $Id$ ]]
local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")

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
	plugins = {},
	get = optGetter,
	set = optSetter,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = "Mapster allows you to control various aspects of your World Map. You can change the style of the map, control the plugins that extend the map with new functionality, and configure different profiles for every of your characters."
		},
		style = {
			order = 5,
			name = "Style",
			type = "group",
			args = {
				alphadesc = {
					order = 2,
					type = "description",
					name = "You can change the transparency of the world map to allow you to continue seeing the world environment while your map is open for navigation.",
				},
				alpha = {
					order = 3,
					name = "Alpha",
					type = "range",
					min = 0, max = 1, step = 0.01,
					isPercent = true,
				},
				scaledesc = {
					order = 4,
					type = "description",
					name = "Change the scale of the world map if you do not want the whole screen filled while the map is open.",
				},
				scale = {
					order = 5,
					name = "Scale",
					type = "range",
					min = 0.1, max = 1, step = 0.01,
					isPercent = true,
				},
			},
		},
	},
}

function Mapster:SetupOptions()
	-- create button on the worldmap to toggle the options
	self.optionsButton = CreateFrame("Button", "MapsterOptionsButton", WorldMapFrame, "UIPanelButtonTemplate")
	self.optionsButton:SetWidth(110)
	self.optionsButton:SetHeight(22)
	self.optionsButton:SetText("Options")
	self.optionsButton:ClearAllPoints()
	self.optionsButton:SetPoint("TOPLEFT", "WorldMapZoomOutButton", "TOPRIGHT", 50, 0)
	self.optionsButton:Show()
	
	self.optionsButton:SetScript("OnClick", function() LibStub("AceConfigDialog-3.0"):Open("Mapster") end)
	
	-- setup options table
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Mapster", options)
end

function Mapster:InjectOptions(name, optionTbl)
	options.plugins[name] = optionTbl
end
