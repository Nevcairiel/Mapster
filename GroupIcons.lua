-- GroupIcons Module for Mapster
-- Idea/Concept/Artwork taken from Cartographer
local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local GroupIcons = Mapster:NewModule("GroupIcons", "AceEvent-3.0", "AceTimer-3.0")

local fmt = string.format
local sub = string.sub
local strfind = string.find
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local select = select
local _G = _G

local UnitClass = UnitClass
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitAffectingCombat = UnitAffectingCombat
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local MapUnit_IsInactive = MapUnit_IsInactive

local path = "Interface\\AddOns\\Mapster\\Artwork\\"

local FixUnit, FixWorldMapUnits, FixBattlefieldUnits, OnUpdate, UpdateUnitIcon

function GroupIcons:OnEnable()
	if not IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
		self:RegisterEvent("ADDON_LOADED", function(event, addon)
			if addon == "Blizzard_BattlefieldMinimap" then
				GroupIcons:UnregisterEvent("ADDON_LOADED")
				FixBattlefieldUnits(true)
			end
		end)
	else
		FixBattlefieldUnits(true)
	end
	FixWorldMapUnits(true)
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
		local isRaid = strfind(name, "Raid", 1, true)
		UpdateUnitIcon(texture, self.unit, flash, isRaid)
	end
end

local grouptex = path .. "Group%d"
function UpdateUnitIcon(tex, unit, flash, isRaid)
	local fileName = select(2, UnitClass(unit))
	if not fileName then return end
	if isRaid then
		local subgroup = select(3, GetRaidRosterInfo(sub(unit, 5)+0))
		if not subgroup then return end
		tex:SetTexture(fmt(grouptex, subgroup))
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
