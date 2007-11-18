
local db
local defaults = {
	profile = {
		scale = 0.75,
		alpha = 1,
		strata = "FULLSCREEN"
	}
}

local wmfOnShow, wmfStartMoving, wmfStopMoving

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0", "AceHook-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")

function Mapster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MapsterDB", defaults)
	db = self.db.profile
	
	self.callbacks = CallbackHandler:New(self)
end

local oldUIPanel, oldwmfOnKeyDown
function Mapster:OnEnable()
	oldUIPanel = UIPanelWindows["WorldMapFrame"]
	UIPanelWindows["WorldMapFrame"] = nil
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", false)
	WorldMapFrame:HookScript("OnShow", wmfOnShow)
	BlackoutWorld:Hide()

	oldwmfOnKeyDown = WorldMapFrame:GetScript("OnKeyDown")
	WorldMapFrame:SetScript("OnKeyDown", nil)

	WorldMapFrame:SetMovable(true)
	WorldMapFrame:RegisterForDrag("LeftButton")
	WorldMapFrame:SetScript("OnDragStart", wmfStartMoving)
	WorldMapFrame:SetScript("OnDragStop", wmfStopMoving)

	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", db.x or 0, db.y or 0)

	self:SetAlpha()
	self:SetStrata()

	hooksecurefunc(WorldMapTooltip, "Show", function(self)
		self:SetFrameStrata("TOOLTIP")
	end)

	self:RawHook("CloseSpecialWindows", true)
end

function Mapster:OnDisable()
	UIPanelWindows["WorldMapFrame"] = oldUIPanel
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", true)
	WorldMapFrame:SetScript("OnKeyDown", oldwmfOnKeyDown)
	BlackoutWorld:Show()
end

function wmfOnShow(frame)
	frame:SetScale(db.scale)
	frame:SetWidth(1024)
	frame:SetHeight(768)
	Mapster:SetStrata()
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
	frame:SetPoint("CENTER", "UIParent", "CENTER", db.x, db.y)
	
	Mapster.callbacks:Fire("MapPositionChanged")
end

function Mapster:SetStrata(value)
	if value then db.strata = value end
	WorldMapFrame:SetFrameStrata(db.strata)
	WorldMapDetailFrame:SetFrameStrata(db.strata)
end

function Mapster:SetAlpha(value)
	if value then db.alpha = value end
	WorldMapFrame:SetAlpha(db.alpha)
end

function Mapster:CloseSpecialWindows()
	local result = self.hooks["CloseSpecialWindows"]()
	if WorldMapFrame:IsShown() then
			ToggleWorldMap()
			result = 1
	end
	return result
end
