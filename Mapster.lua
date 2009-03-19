--[[
Copyright (c) 2008, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0")

local db
local defaults = {
	profile = {
		scale = 0.75,
		alpha = 1,
		strata = "HIGH",
		hideMapButton = false,
		arrowScale = 0.88,
		modules = {
			['*'] = true,
		},
	}
}

local format = string.format

local wmfOnShow, wmfStartMoving, wmfStopMoving, dropdownScaleFix

function Mapster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MapsterDB", defaults, "Default")
	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	db = self.db.profile
	
	self:SetupOptions()
end


-- local oldUIPanel,
local oldwmfOnKeyDown, realZone
function Mapster:OnEnable()
	self:SetupMapButton()
	
	local vis = WorldMapFrame:IsVisible()
	if vis then
		HideUIPanel(WorldMapFrame)
	end
	
	--oldUIPanel = UIPanelWindows["WorldMapFrame"]
	UIPanelWindows["WorldMapFrame"] = nil
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", false)
	WorldMapFrame:HookScript("OnShow", wmfOnShow)
	WorldMapFrame:HookScript("OnHide", wmfOnHide)
	BlackoutWorld:Hide()

	oldwmfOnKeyDown = WorldMapFrame:GetScript("OnKeyDown")
	WorldMapFrame:SetScript("OnKeyDown", nil)

	WorldMapFrame:SetMovable(true)
	WorldMapFrame:RegisterForDrag("LeftButton")
	WorldMapFrame:SetScript("OnDragStart", wmfStartMoving)
	WorldMapFrame:SetScript("OnDragStop", wmfStopMoving)

	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", db.x or 0, db.y or 0)
	WorldMapFrame:SetToplevel(true)
	
	WorldMapContinentDropDownButton:SetScript("OnClick", dropdownScaleFix)
	WorldMapZoneDropDownButton:SetScript("OnClick", dropdownScaleFix)
	WorldMapZoneMinimapDropDownButton:SetScript("OnClick", dropdownScaleFix)
	
	self:SetAlpha()
	-- Apply all frame settings
	wmfOnShow(WorldMapFrame)

	hooksecurefunc(WorldMapTooltip, "Show", function(self)
		self:SetFrameStrata("TOOLTIP")
	end)

	tinsert(UISpecialFrames, "WorldMapFrame")
	
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	
	self:SetArrow()
	
	if vis then
		ShowUIPanel(WorldMapFrame)
	end
end

--[[
function Mapster:OnDisable()
	UIPanelWindows["WorldMapFrame"] = oldUIPanel
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", true)
	WorldMapFrame:SetScript("OnKeyDown", oldwmfOnKeyDown)
	BlackoutWorld:Show()
end
]]

function Mapster:Refresh()
	db = self.db.profile
	
	self:SetStrata()
	self:SetAlpha()
	self:SetArrow()
	if WorldMapFrame:IsShown() then
		WorldMapFrame:SetScale(db.scale)
	end
	
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
	
	if self.optionsButton then
		if db.hideMapButton then
			self.optionsButton:Hide()
		else
			self.optionsButton:Show()
		end
	end
end

local function getZoneId()
	return (GetCurrentMapZone() + GetCurrentMapContinent() * 100)
end

function Mapster:ZONE_CHANGED_NEW_AREA()
	local curZone = getZoneId()
	if realZone == curZone or ((curZone % 100) > 0 and (GetPlayerMapPosition("player")) ~= 0) then
		SetMapToCurrentZone()
		realZone = getZoneId()
	end
end

local oldBFMOnUpdate
function wmfOnShow(frame)
	frame:SetScale(db.scale)
	frame:SetWidth(1024)
	frame:SetHeight(768)
	Mapster:SetStrata()
	realZone = getZoneId()
	if BattlefieldMinimap then
		oldBFMOnUpdate = BattlefieldMinimap:GetScript("OnUpdate")
		BattlefieldMinimap:SetScript("OnUpdate", nil)
	end
end

function wmfOnHide(frame)
	SetMapToCurrentZone()
	if BattlefieldMinimap then
		BattlefieldMinimap:SetScript("OnUpdate", oldBFMOnUpdate or BattlefieldMinimap_OnUpdate)
	end
end

function wmfStartMoving(frame)
	frame:StartMoving()
end

function wmfStopMoving(frame)
	frame:StopMovingOrSizing()

	-- save position relative to center of the screen
	local x,y = frame:GetCenter()
	local z = UIParent:GetEffectiveScale() / 2 / frame:GetScale()
	db.x = x - GetScreenWidth() * z
	db.y = y - GetScreenHeight() * z
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", db.x, db.y)
end

function dropdownScaleFix(self)
	ToggleDropDownMenu(nil, nil, self:GetParent())
	DropDownList1:SetScale(db.scale)
end

function Mapster:SetStrata()
	WorldMapFrame:SetFrameStrata(db.strata)
	WorldMapDetailFrame:SetFrameStrata(db.strata)
end

function Mapster:SetAlpha()
	WorldMapFrame:SetAlpha(db.alpha)
end

function Mapster:SetArrow()
	PlayerArrowFrame:SetModelScale(db.arrowScale)
	PlayerArrowEffectFrame:SetModelScale(db.arrowScale)
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
