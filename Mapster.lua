
local db
local defaults = {
	profile = {
		scale = 0.75,
		alpha = 1,
		strata = "HIGH",
		modules = {
			['*'] = true,
		},
	}
}

local wmfOnShow, wmfStartMoving, wmfStopMoving

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0", "AceHook-3.0")

function Mapster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MapsterDB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	db = self.db.profile
	
	self:SetupOptions()
end


local oldUIPanel, oldwmfOnKeyDown
function Mapster:OnEnable()
	oldUIPanel = UIPanelWindows["WorldMapFrame"]
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

function Mapster:Refresh()
	db = self.db.profile
	
	self:SetStrata()
	self:SetAlpha()
	if WorldMapFrame:IsShown() then
		WorldMapFrame:SetScale(db.scale)
	end
	
	for k,v in self:IterateModules() do
		if v.Refresh then
			v:Refresh()
		end
	end
end

function wmfOnShow(frame)
	frame:SetScale(db.scale)
	frame:SetWidth(1024)
	frame:SetHeight(768)
	Mapster:SetStrata()
end

function wmfOnHide(frame)
	SetMapToCurrentZone()
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
end

function Mapster:SetStrata()
	WorldMapFrame:SetFrameStrata(db.strata)
	WorldMapDetailFrame:SetFrameStrata(db.strata)
end

function Mapster:SetAlpha()
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
