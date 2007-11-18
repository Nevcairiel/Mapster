local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local Mapster_Coords = Mapster:NewModule("Coords")

local fmt = string.format
local IsInInstance = IsInInstance
local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = GetPlayerMapPosition
local select = select
local display = nil
local cursortext = nil
local playertext = nil

function Mapster_Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame)
		display:SetScript("OnUpdate", self.OnUpdate)

		cursortext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		cursortext:SetPoint("RIGHT", WorldMapFrame, "CENTER", -50, -367)

		playertext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		playertext:SetPoint("LEFT", WorldMapFrame, "CENTER", 50, -367)
	end
	display:Show()
end

function Mapster:MouseXY()
	local x, y = GetCursorPosition()
	local left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
	local width = WorldMapDetailFrame:GetWidth()
	local height = WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height

	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		cx, cy = nil, nil
	end

	return cx, cy
end

local coords = " %s:\n %.0f, %.0f"
function Mapster_Coords.OnUpdate()
	local px, py = GetPlayerMapPosition("player")
	local cx, cy = Mapster:MouseXY()

	if cx then
		cursortext:SetText(fmt(coords, "Cursor", 100 * cx, 100 * cy))
	else
		cursortext:SetText("")
	end

	if IsInInstance() and select(2, IsInInstance()) ~= "pvp" then
		playertext:SetText("")
	else
		playertext:SetText(fmt(coords, "Player", 100 * px, 100 * py))
	end
end
