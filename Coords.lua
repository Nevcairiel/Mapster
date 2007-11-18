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
local stop = nil
local left, top, width, height, scale

local MouseXY, OnUpdate

function Mapster_Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame)
		display:SetScript("OnUpdate", OnUpdate)

		cursortext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		cursortext:SetPoint("RIGHT", WorldMapFrame, "CENTER", -50, -367)

		playertext = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		playertext:SetPoint("LEFT", WorldMapFrame, "CENTER", 50, -367)
	end
	display:Show()
end

function MouseXY()
	if not stop then
		left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
		width = WorldMapDetailFrame:GetWidth()
		height = WorldMapDetailFrame:GetHeight()
		scale = WorldMapDetailFrame:GetEffectiveScale()
		stop = true
	end

	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height

	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		cx, cy = nil, nil
	end

	return cx, cy
end

local coords = " %s:\n %.1f, %.1f"
function OnUpdate()
	local px, py = GetPlayerMapPosition("player")
	local cx, cy = MouseXY()

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
