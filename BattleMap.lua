--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "BattleMap"
local BattleMap = Mapster:NewModule(MODNAME, "AceEvent-3.0")

-- Make sure to get the global before FogClear loads and overwrites it
local GetNumMapOverlays = GetNumMapOverlays

local db
local defaults = { 
	profile = {
		hideTextures = false,
	}
}

local optGetter, optSetter
do
	local mod = BattleMap
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

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["BattleMap"],
			arg = MODNAME,
			get = optGetter,
			set = optSetter,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["battlemap_desc"],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable BattleMap"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
				texturesdesc = {
					order = 3,
					type = "description",
					name = L["battlemap_textures_desc"],
				},
				hideTextures = {
					order = 4,
					type = "toggle",
					name = L["Hide Textures"],
				},
			},
		}
	end
	
	return options
end

function BattleMap:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	
	self:Refresh()
	
	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["BattleMap"])
end

function BattleMap:OnEnable()
	db = self.db.profile
	
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()
	BattlefieldMinimapCloseButton:Hide()
	BattlefieldMinimapTab:Hide()

	self:RegisterEvent("WORLD_MAP_UPDATE", "UpdateTextureVisibility")
	
	self:Refresh()
end

function BattleMap:OnDisable()
	BattlefieldMinimapCorner:Show()
	BattlefieldMinimapBackground:Show()
	BattlefieldMinimapCloseButton:Show()
	BattlefieldMinimapTab:Show()
	
	self:Refresh()
end

function BattleMap:Refresh()
	db = self.db.profile
	
	self:UpdateTextureVisibility()
end

function BattleMap:UpdateTextureVisibility()
	local numOverlays = GetNumMapOverlays()
	if numOverlays > 0 and db.hideTextures and self:IsEnabled() then
		for i=1,12 do
			_G["BattlefieldMinimap"..i]:Hide()
		end
	else
		for i=1,12 do
			_G["BattlefieldMinimap"..i]:Show()
		end
	end
end
