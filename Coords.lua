local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local Coords = Mapster:NewModule("Coords")

local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local WorldMapDetailFrame = WorldMapDetailFrame
local display, cursortext, playertext

local MouseXY, OnUpdate

local options = {
	coords = {
		type = "group",
		name = "Coordinates",
		args = {
			enabled = {
				type = "toggle",
				name = "Enable Coordinates",
				get = function() return Mapster:GetModuleEnabled("Coords") end,
				set = function(info, value) Mapster:SetModuleEnabled("Coords", value) end,
			},
		},
	},
}

function Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame)

		cursortext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		cursortext:SetPoint("RIGHT", WorldMapFrame, "CENTER", -50, -367)

		playertext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		playertext:SetPoint("LEFT", WorldMapFrame, "CENTER", 50, -367)
		
		Mapster:InjectOptions("Coordinates", options)
	end
	display:SetScript("OnUpdate", OnUpdate)
	display:Show()
end

function Coords:OnDisable()
	display:SetScript("OnUpdate", nil)
	display:Hide()
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

local text = " %s: %.2f, %.2f"
function OnUpdate()
	local cx, cy = MouseXY()
	local px, py = GetPlayerMapPosition("player")

	if cx then
		cursortext:SetFormattedText(text, "Cursor", 100 * cx, 100 * cy)
	else
		cursortext:SetText("")
	end

	if px == 0 then
		playertext:SetText("")
	else
		playertext:SetFormattedText(text, "Player", 100 * px, 100 * py)
	end
end
