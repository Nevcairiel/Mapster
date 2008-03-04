--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

--[[ $Id$ ]]
local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "Coords"
local Coords = Mapster:NewModule(MODNAME)

local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local WorldMapDetailFrame = WorldMapDetailFrame
local display, cursortext, playertext
local texttemplate, text = "%%s: %%.%df, %%.%df"

local MouseXY, OnUpdate

local db
local defaults = { 
	profile = {
		accuracy = 1,
	}
}

local optGetter, optSetter
do
	local mod = Coords
	function optGetter(info)
		local key = info[#info]
		return db[key]
	end

	function optSetter(info, value)
		local key = info[#info]
		db[key] = value
		mod:Refresh()
	end
end

local options = {
	coords = {
		order = 10,
		type = "group",
		name = L["Coordinates"],
		arg = MODNAME,
		get = optGetter,
		set = optSetter,
		args = {
			intro = {
				order = 1,
				type = "description",
				name = L["coords_desc"],
			},
			enabled = {
				order = 2,
				type = "toggle",
				name = L["Enable Coordinates"],
				get = function() return Mapster:GetModuleEnabled(MODNAME) end,
				set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
			},
			accuracydesc = {
				order = 3,
				type = "description",
				name = L["coords_accuracy_desc"],
			},
			accuracy = {
				order = 4,
				type = "range",
				name = L["Accuracy"],
				min = 0, max = 2, step = 1,
			},
		},
	},
}

function Coords:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	
	self:Refresh()
	
	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:InjectOptions(MODNAME, options)
end

function Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame)
		
		cursortext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		cursortext:SetPoint("RIGHT", WorldMapFrame, "CENTER", -50, -367)
		
		playertext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		playertext:SetPoint("LEFT", WorldMapFrame, "CENTER", 50, -367)
	end
	display:SetScript("OnUpdate", OnUpdate)
	display:Show()
end

function Coords:OnDisable()
	display:SetScript("OnUpdate", nil)
	display:Hide()
end

function Coords:Refresh()
	db = self.db.profile
	
	local acc = tonumber(db.accuracy) or 1
	text = texttemplate:format(acc, acc)
end

function MouseXY()
	local left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end
	
	return cx, cy
end

local cursor, player = L["Cursor"], L["Player"]
function OnUpdate()
	local cx, cy = MouseXY()
	local px, py = GetPlayerMapPosition("player")
	
	if cx then
		cursortext:SetFormattedText(text, cursor, 100 * cx, 100 * cy)
	else
		cursortext:SetText("")
	end
	
	if px == 0 then
		playertext:SetText("")
	else
		playertext:SetFormattedText(text, player, 100 * px, 100 * py)
	end
end
