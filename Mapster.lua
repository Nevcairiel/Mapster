--[[
Copyright (c) 2009-2016, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0", "AceHook-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local defaults = {
	profile = {
		hideMapButton = false,
		arrowScale = 0.9,
		modules = {
			['*'] = true,
		},
		scale = 1,
		poiScale = 0.9,
		ejScale = 0.8,
		alpha = 1,
		disableMouse = false,
	}
}

local format = string.format

local wmfOnShow, dropdownScaleFix, WorldMapFrameGetAlpha

function Mapster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MapsterDB", defaults, true)
	db = self.db.profile

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")

	self.elementsToHide = {}

	self.UIHider = CreateFrame("Frame")
	self.UIHider:Hide()

	self:SetupOptions()
end

local realZone
function Mapster:OnEnable()
	self:SetupMapButton()

	-- hook onshow to apply alpha and store current zone
	WorldMapFrame:HookScript("OnShow", wmfOnShow)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	-- hook the navbar to be able to scale tooltips
	self:SecureHook("NavBar_ToggleMenu")

	-- fix scale of the worldmap tooltip
	WorldMapTooltip:HookScript("OnShow", function(self) self:SetScale(1 / WorldMapFrame:GetScale()) end)

	-- hook to overwrite scale to include our custom scale
	self:SecureHook("WorldMapFrame_CalculateHitTranslations")
	self:SecureHook("WorldMapPOIFrame_AnchorPOI")
	self:SecureHook("EncounterJournal_AddMapButtons")

	self:RawHook(WorldMapPlayerLower, "SetPoint", "WorldMapPlayerSetPoint", true)
	self:RawHook(WorldMapPlayerUpper, "SetPoint", "WorldMapPlayerSetPoint", true)

	self:SecureHook("HelpPlate_Show")
	self:SecureHook("HelpPlate_Hide")
	self:SecureHook("HelpPlate_Button_AnimGroup_Show_OnFinished")

	-- hook alpha to override it
	WorldMapFrame.GetAlphaMapster = WorldMapFrame.GetAlpha
	WorldMapFrame.GetAlpha = WorldMapFrameGetAlpha
	WorldMapFrame.AnimAlphaIn:SetScript("OnFinished", function() WorldMapFrame:SetAlpha(db.alpha) end)

	self:SecureHook("WorldMapFrame_AnimateAlpha")

	-- load settings
	self:SetAlpha()
	self:SetArrow()
	self:SetScale()
	--self:UpdateMouseInteractivity()

	-- Update digsites, the Blizzard map doesn't set this properly on load
	--[[local _, _, arch = GetProfessions()
	if arch then
		if GetCVarBool("digSites") then
			WorldMapArchaeologyDigSites:Show()
		else
			WorldMapArchaeologyDigSites:Hide()
		end
	end--]]
end

function Mapster:Refresh()
	db = self.db.profile

	for k,v in self:IterateModules() do
		if self:GetModuleEnabled(k) and not v:IsEnabled() then
			self:EnableModule(k)
		elseif not self:GetModuleEnabled(k) and v:IsEnabled() then
			self:DisableModule(k)
		end
		if type(v.Refresh) == "function" then
			v:Refresh()
		end
	end

	-- apply new settings
	self:SetAlpha()
	self:SetArrow()
	self:SetScale()

	if self.optionsButton then
		if db.hideMapButton then
			self.optionsButton:Hide()
		else
			self.optionsButton:Show()
		end
	end

	--self:UpdateMouseInteractivity()

	-- apply settings to blizzard frames
	WorldMap_UpdateQuestBonusObjectives()
	WorldMapScrollFrame_ReanchorQuestPOIs()
	self:EncounterJournal_AddMapButtons()
end

function Mapster:NavBar_ToggleMenu(frame)
	if frame:GetParent() and frame:GetParent():GetParent() == WorldMapFrame then
		dropdownScaleFix()
	end
end

function Mapster:WorldMapPlayerSetPoint(frame, point, relFrame, relPoint, x, y)
	if x and y then
		x = x / db.arrowScale
		y = y / db.arrowScale
	end
	return self.hooks[frame].SetPoint(frame, point, relFrame, relPoint, x, y)
end

function Mapster:WorldMapFrame_CalculateHitTranslations(frame)
	frame.scale = WorldMapFrame:GetScale() * UIParent:GetScale()
end

function Mapster:WorldMapPOIFrame_AnchorPOI(poiButton, posX, posY)
	if posX and posY then
		local point, frame, relPoint, x, y = poiButton:GetPoint()
		poiButton:SetScale(db.poiScale)
		poiButton:SetPoint(point, frame, relPoint, x / db.poiScale, y / db.poiScale)
	end
end

function Mapster:EncounterJournal_AddMapButtons()
	local index = 1
	local bossButton = _G["EJMapButton"..index]

	local width = WorldMapDetailFrame:GetWidth() / db.ejScale
	local height = WorldMapDetailFrame:GetHeight() / db.ejScale

	while bossButton do
		if bossButton:IsShown() then
			local x, y = EJ_GetMapEncounter(index, WorldMapFrame.fromJournal)
			bossButton:SetScale(db.ejScale)
			bossButton:SetPoint("CENTER", WorldMapBossButtonFrame, "BOTTOMLEFT", x*width, y*height);
		end
		index = index + 1
		bossButton = _G["EJMapButton"..index]
	end
end

function Mapster:HelpPlate_Show(plate)
	if plate == WorldMapFrame_HelpPlate then
		HelpPlate:SetScale(db.scale)
		HelpPlate.__Mapster = true
	end
end

function Mapster:HelpPlate_Hide(userToggled)
	if HelpPlate.__Mapster then
		if not userToggled then
			HelpPlate:SetScale(1.0)
			HelpPlate.__Mapster = nil
		end
	end
end

function Mapster:HelpPlate_Button_AnimGroup_Show_OnFinished()
	if HelpPlate.__Mapster then
		HelpPlate:SetScale(1.0)
		HelpPlate.__Mapster = nil
	end
end

local function getZoneId()
	return (GetCurrentMapZone() + GetCurrentMapContinent() * 100)
end

function Mapster:ZONE_CHANGED_NEW_AREA()
	if not WorldMapFrame:IsShown() then
		return
	end
	local prevZone = getZoneId()
	SetMapToCurrentZone()
	local newRealZone = getZoneId()
	if prevZone ~= realZone and prevZone ~= newRealZone then
		local cont, zone = floor(prevZone / 100), mod(prevZone, 100)
		SetMapZoom(cont, zone)
	end
	realZone = newRealZone
end

function wmfOnShow(frame)
	realZone = getZoneId()

	if IsPlayerMoving() and GetCVarBool("mapFade") then
		if not WorldMapFrame:IsMouseOver() then
			WorldMapFrame:SetAlpha(WORLD_MAP_MIN_ALPHA)
		end
		WorldMapFrame.fadeOut = true
	end
end

function dropdownScaleFix()
	local uiScale = 1
	local uiParentScale = UIParent:GetScale()
	if GetCVar("useUIScale") == "1" then
		uiScale = tonumber(GetCVar("uiscale"))
		if uiParentScale < uiScale then
			uiScale = uiParentScale
		end
	else
		uiScale = uiParentScale
	end
	DropDownList1:SetScale(uiScale * db.scale)
end

function Mapster:SetAlpha()
	WorldMapFrame:SetAlpha(db.alpha)
end

function WorldMapFrameGetAlpha(frame)
	local alpha = WorldMapFrame:GetAlphaMapster()
	if abs(alpha - db.alpha) < 0.05 then
		return db.alpha
	end
	if abs(alpha - WORLD_MAP_MIN_ALPHA) < 0.05 then
		return WORLD_MAP_MIN_ALPHA
	end
	return alpha
end

function Mapster:WorldMapFrame_AnimateAlpha(frame, useStartDelay, anim, otherAnim, startAlpha, endAlpha)
	if frame == WorldMapFrame then
		if anim == frame.AnimAlphaIn and endAlpha ~= db.alpha then
			startAlpha = anim.Alpha:GetFromAlpha()
			local duration = ((db.alpha - startAlpha) / (db.alpha - WORLD_MAP_MIN_ALPHA)) * tonumber(GetCVar("mapAnimDuration"));
			anim:Stop()
			anim.Alpha:SetToAlpha(db.alpha)
			anim.Alpha:SetDuration(abs(duration))
			anim:Play()
		elseif anim == frame.AnimAlphaOut and startAlpha ~= db.alpha then
			startAlpha = min(anim.Alpha:GetFromAlpha(), db.alpha)
			frame:SetAlpha(startAlpha)
			local duration = ((endAlpha - startAlpha) / (db.alpha - WORLD_MAP_MIN_ALPHA)) * tonumber(GetCVar("mapAnimDuration"));
			anim:Stop()
			anim.Alpha:SetFromAlpha(startAlpha)
			anim.Alpha:SetDuration(abs(duration))
			anim:Play()
		end
	end
end

function Mapster:SetArrow()
	WorldMapPlayerUpper:SetScale(db.arrowScale)
	WorldMapPlayerLower:SetScale(db.arrowScale)
end

function Mapster:SetScale()
	WorldMapFrame:SetScale(db.scale)
	if HelpPlate.__Mapster then
		HelpPlate:SetScale(db.scale)
	end

	WorldMapBlobFrame_UpdateBlobs()
	WorldMapFrame_ResetPOIHitTranslations()
end

function Mapster:UpdateMouseInteractivity()
	if db.disableMouse then
		WorldMapButton:EnableMouse(false)
		WorldMapFrame:EnableMouse(false)
	else
		WorldMapButton:EnableMouse(true)
		WorldMapFrame:EnableMouse(true)
	end
end

function Mapster:GetModuleEnabled(module)
	return db.modules[module]
end

function Mapster:SetModuleEnabled(module, value)
	local old = db.modules[module]
	db.modules[module] = value
	if old ~= value then
		if value then
			self:EnableModule(module)
		else
			self:DisableModule(module)
		end
	end
end
