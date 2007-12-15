-- GroupIcons Module for Mapster
-- Idea/Concept/Artwork taken from Cartographer
local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local GroupIcons = Mapster:NewModule("GroupIcons", "AceEvent-3.0", "AceTimer-3.0")

local fmt = string.format
local strsub = string.sub
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local _G = _G

local path = "Interface\\AddOns\\Mapster\\Artwork\\"

local FixUnit, FixWorldMapUnits, FixBattlefieldUnits, OnUpdate, UpdateUnitIcon

function GroupIcons:OnEnable()
	self:RegisterEvent("ADDON_LOADED", function(event, addon)
		if addon == "Blizzard_BattlefieldMinimap" then
			FixBattlefieldUnits(true)
		end
	end)	
	FixWorldMapUnits(true)
	FixBattlefieldUnits(true)
end

function GroupIcons:OnDisable()
	FixWorldMapUnits(false)
	FixBattlefieldUnits(false)
end

function FixUnit(unit, state, isNormal)
	local frame = _G[unit]
	local icon = _G[unit.."Icon"]
	if state then
		frame:SetScript("OnUpdate", OnUpdate)
		if isNormal then
			icon:SetTexture(path .. "Normal")
		end
	else
		frame:SetScript("OnUpdate", MapUnit_OnUpdate)
		icon:SetVertexColor(1, 1, 1)
		icon:SetTexture("Interface\\WorldMap\\WorldMapPartyIcon")
	end
end

function FixWorldMapUnits(state)
	for i = 1, 4 do
		FixUnit(fmt("WorldMapParty%d", i), state, true)
	end
	for i = 1,40 do
		FixUnit(fmt("WorldMapRaid%d", i), state)
	end
end

function FixBattlefieldUnits(state)
	if BattlefieldMinimap then
		for i = 1, 40 do
			FixUnit(fmt("BattlefieldMinimapRaid%d", i), state)
		end
	end
end


function OnUpdate(self)
	local flash = GetTime() % 1 < 0.5
	
	local name = self:GetName().."Icon"
	local texture = _G[name]
	if texture then
		local isRaid = strmatch(name, "Raid")
		UpdateUnitIcon(texture, self.unit, flash, isRaid)
	end
end

function UpdateUnitIcon(tex, unit, flash, isRaid)
	local _, fileName = UnitClass(unit)
	if not fileName then return end
	if isRaid then
		local _, _, subgroup = GetRaidRosterInfo(strsub(unit, 5)+0)
		if not subgroup then return end
		tex:SetTexture(fmt("%sGroup%d", path, subgroup))
	end
	local t = RAID_CLASS_COLORS[fileName]
	if flash then
		if UnitAffectingCombat(unit) then
			-- red flash for units in combat
			tex:SetVertexColor(0.8, 0, 0)
		elseif UnitIsDeadOrGhost(unit) then
			-- dark grey flash for dead units
			tex:SetVertexColor(0.2, 0.2, 0.2)
		elseif MapUnit_IsInactive(unit) then
			-- flash in that blizzard color for inactive units (added in 2.3 iirc)
			tex:SetVertexColor(0.5, 0.2, 0)
		end
	elseif t then -- no flash, set class color
		tex:SetVertexColor(t.r, t.g, t.b)
	else --fallback grey, you never know what happens
		tex:SetVertexColor(0.8, 0.8, 0.8)
	end
end
